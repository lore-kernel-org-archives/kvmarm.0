From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v11 4/8] vfio/type1: handle unmap/unpin and replay for
 VFIO_IOVA_RESERVED slots
Date: Mon, 25 Jul 2016 09:53:31 +0200
Message-ID: <36bf6d43-2990-0b7f-7ccd-aaea4212a6a0@redhat.com>
References: <201607240918.hP8YWSxI%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1F71F410EB
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Jul 2016 03:47:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id S+RUfk13W9FP for <kvmarm@lists.cs.columbia.edu>;
 Mon, 25 Jul 2016 03:47:16 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A33164053F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Jul 2016 03:47:16 -0400 (EDT)
In-Reply-To: <201607240918.hP8YWSxI%fengguang.wu@intel.com>
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
Cc: kvm@vger.kernel.org, will.deacon@arm.com, kvmarm@lists.cs.columbia.edu, eric.auger.pro@gmail.com, joro@8bytes.org, robert.richter@caviumnetworks.com, jason@lakedaemon.net, marc.zyngier@arm.com, andre.przywara@arm.com, Manish.Jaggi@caviumnetworks.com, alex.williamson@redhat.com, tglx@linutronix.de, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org, kbuild-all@01.org, pbonzini@redhat.com, robin.murphy@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 24/07/2016 03:41, kbuild test robot wrote:
> Hi,
> 
> [auto build test ERROR on vfio/next]
> [also build test ERROR on v4.7-rc7 next-20160722]
> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
> 
> url:    https://github.com/0day-ci/linux/commits/Eric-Auger/KVM-PCIe-MSI-passthrough-on-ARM-ARM64-kernel-part-3-3-vfio-changes/20160724-082318
> base:   https://github.com/awilliam/linux-vfio.git next
> config: x86_64-rhel (attached as .config)
> compiler: gcc-6 (Debian 6.1.1-9) 6.1.1 20160705
> reproduce:
>         # save the attached .config to linux build tree
>         make ARCH=x86_64 
> 
> All errors (new ones prefixed by >>):
> 
>>> drivers/vfio/vfio_iommu_type1.c:39:29: fatal error: linux/msi-iommu.h: No such file or directory
>     #include <linux/msi-iommu.h>
>                                 ^
>    compilation terminated.
> 
> vim +39 drivers/vfio/vfio_iommu_type1.c
> 
>     33	#include <linux/rbtree.h>
>     34	#include <linux/sched.h>
>     35	#include <linux/slab.h>
>     36	#include <linux/uaccess.h>
>     37	#include <linux/vfio.h>
>     38	#include <linux/workqueue.h>
>   > 39	#include <linux/msi-iommu.h>
Dependency on part I of this series.

Thanks

Eric
>     40	
>     41	#define DRIVER_VERSION  "0.2"
>     42	#define DRIVER_AUTHOR   "Alex Williamson <alex.williamson@redhat.com>"
> 
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
> 
