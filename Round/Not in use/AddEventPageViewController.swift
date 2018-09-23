//
//  AddEventPageViewController.swift
//  Round
//
//  Created by Jared Boynton on 7/25/18.
//  Copyright © 2018 Jared Boynton. All rights reserved.
//

import UIKit

class AddEventPageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    lazy var orderedViewControllers: [UIViewController] = {
        return [self.newVC(viewController: "sBDate"),
                self.newVC(viewController: "sBTime"),
                self.newVC(viewController: "sBLocation"),
                self.newVC(viewController: "sBQuestions")]
    }()
    
    var pageControl = UIPageControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        

        self.dataSource = self
        if let firstViewController = orderedViewControllers.first{
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
            firstViewController.title = "date"
            }
        
        
        self.delegate = self
        configurePageControl()

    }
    
    func newVC(viewController: String) -> UIViewController{
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: viewController)
    }
    

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else{
            return nil
        }
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else{
            return nil
        }
        guard orderedViewControllers.count > previousIndex else{
            return nil
        }
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else{
            return nil
        }
        let nextIndex = viewControllerIndex + 1
        guard orderedViewControllers.count != nextIndex else{
            return nil
        }
        guard orderedViewControllers.count > nextIndex else{
            return nil
        }
        return orderedViewControllers[nextIndex]
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        let contentPageViewController = pageViewController.viewControllers![0]
        self.pageControl.currentPage = orderedViewControllers.index(of: contentPageViewController)!
        
    }
    
    
    func configurePageControl(){
        pageControl = UIPageControl(frame: CGRect(x: 0, y: UIScreen.main.bounds.maxY - 85, width: UIScreen.main.bounds.width, height: 50))
        
        pageControl.numberOfPages = orderedViewControllers.count
        pageControl.currentPage = 0
        pageControl.tintColor = UIColor.white
        pageControl.pageIndicatorTintColor = UIColor.flatNavyBlueDark
        pageControl.currentPageIndicatorTintColor = UIColor.flatPink
        self.view.addSubview(pageControl)
        
    }
    


}
