From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [PATCH 06/10] vfio: introduce
 vfio_group_alloc_map_/unmap_free_reserved_iova
Date: Tue, 26 Jan 2016 17:37:49 +0100
Message-ID: <56A7A0DD.2080504@linaro.org>
References: <201601270035.rJBZW1lE%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2ECD840B58
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jan 2016 11:33:16 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id On7UtsI0lacv for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Jan 2016 11:33:14 -0500 (EST)
Received: from mail-wm0-f48.google.com (mail-wm0-f48.google.com [74.125.82.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 341DC409A2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jan 2016 11:33:13 -0500 (EST)
Received: by mail-wm0-f48.google.com with SMTP id l65so111754495wmf.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jan 2016 08:38:09 -0800 (PST)
In-Reply-To: <201601270035.rJBZW1lE%fengguang.wu@intel.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kbuild test robot <lkp@intel.com>
Cc: linux-arm-kernel@lists.infradead.org, eric.auger@st.com, kvm@vger.kernel.org, patches@linaro.org, marc.zyngier@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org, alex.williamson@redhat.com, kbuild-all@01.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi,
On 01/26/2016 05:17 PM, kbuild test robot wrote:
> Hi Eric,
> 
> [auto build test ERROR on v4.5-rc1]
> [also build test ERROR on next-20160125]
> [cannot apply to iommu/next]
> [if your patch is applied to the wrong git tree, please drop us a note to help improving the system]
> 
> url:    https://github.com/0day-ci/linux/commits/Eric-Auger/KVM-PCIe-MSI-passthrough-on-ARM-ARM64/20160126-211921
> config: x86_64-randconfig-s3-01262306 (attached as .config)
> reproduce:
>         # save the attached .config to linux build tree
>         make ARCH=x86_64 
> 
> All errors (new ones prefixed by >>):
> 
>>> ERROR: "alloc_iova" [drivers/vfio/vfio_iommu_type1.ko] undefined!
>>> ERROR: "free_iova" [drivers/vfio/vfio_iommu_type1.ko] undefined!

I will protect the code with CONFIG_IOMMU_IOVA if the usage of those
functions is acknowledged.

Thanks

Eric
> 
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
> 
