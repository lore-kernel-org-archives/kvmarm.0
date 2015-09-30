From: Bhushan Bharat <Bharat.Bhushan@freescale.com>
Subject: RE: [RFC PATCH 5/6] vfio-pci: Create iommu mapping for msi interrupt
Date: Wed, 30 Sep 2015 11:32:43 +0000
Message-ID: <CY1PR0301MB1276ACAFB5993B6CB94E984C904D0@CY1PR0301MB1276.namprd03.prod.outlook.com>
References: <1443624989-24346-5-git-send-email-Bharat.Bhushan@freescale.com>
 <201509301912.JBx38XcF%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <201509301912.JBx38XcF%fengguang.wu@intel.com>
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "alex.williamson@redhat.com" <alex.williamson@redhat.com>, "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>, "eric.auger@linaro.org" <eric.auger@linaro.org>, "pranavkumar@linaro.org" <pranavkumar@linaro.org>, "marc.zyngier@arm.com" <marc.zyngier@arm.com>, "will.deacon@arm.com" <will.deacon@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu


> -----Original Message-----
> From: kbuild test robot [mailto:lkp@intel.com]
> Sent: Wednesday, September 30, 2015 4:33 PM
> To: Bhushan Bharat-R65777 <Bharat.Bhushan@freescale.com>
> Cc: kbuild-all@01.org; kvmarm@lists.cs.columbia.edu; kvm@vger.kernel.org;
> alex.williamson@redhat.com; christoffer.dall@linaro.org;
> eric.auger@linaro.org; pranavkumar@linaro.org; marc.zyngier@arm.com;
> will.deacon@arm.com; Bhushan Bharat-R65777
> <Bharat.Bhushan@freescale.com>
> Subject: Re: [RFC PATCH 5/6] vfio-pci: Create iommu mapping for msi
> interrupt
> 
> Hi Bharat,
> 
> [auto build test results on v4.3-rc3 -- if it's inappropriate base, please ignore]
> 
> config: x86_64-rhel (attached as .config)
> reproduce:
>   git checkout 6fdf43e0b410216a2fe2d1d6e8541fb4f69557f9
>   # save the attached .config to linux build tree
>   make ARCH=x86_64
> 
> All error/warnings (new ones prefixed by >>):
> 
> >> ERROR: "vfio_device_map_msi" [drivers/vfio/pci/vfio-pci.ko] undefined!
> >> ERROR: "vfio_device_unmap_msi" [drivers/vfio/pci/vfio-pci.ko]
> undefined!

Yes, this is the problem, I will correct this in next version.

Thanks
-Bharat

> 
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
