From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v2 0/4] kvm: arm/arm64: vgic: APRn uaccess support.
Date: Fri, 21 Jul 2017 15:27:03 +0200
Message-ID: <20170721132703.GJ16350@cbox>
References: <1500287012-16996-1-git-send-email-wanghaibin.wang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1904E40FAE
 for <kvmarm@lists.cs.columbia.edu>; Fri, 21 Jul 2017 09:26:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lth+ytrH5xfw for <kvmarm@lists.cs.columbia.edu>;
 Fri, 21 Jul 2017 09:26:12 -0400 (EDT)
Received: from mail-wm0-f41.google.com (mail-wm0-f41.google.com [74.125.82.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0E63140D1A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 21 Jul 2017 09:26:11 -0400 (EDT)
Received: by mail-wm0-f41.google.com with SMTP id w191so8497893wmw.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 21 Jul 2017 06:27:05 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1500287012-16996-1-git-send-email-wanghaibin.wang@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: wanghaibin <wanghaibin.wang@huawei.com>
Cc: marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu, wu.wubin@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Wanghaibin,

On Mon, Jul 17, 2017 at 06:23:28PM +0800, wanghaibin wrote:
> v2: Split the patch again to make it easier for review
>     some fixes were proposed by Marc
> 
> v1: the problem describe:
> https://lists.cs.columbia.edu/pipermail/kvmarm/2017-July/026295.html

please also include the same description in the cover letter for future
revisions of this patch series.  People may not remember the context
(like me) or others may jump in as reviewers at a later time, and having
to go back and look at an old posting via a link is not very friendly to
the review process.

Thanks,
-Christoffer

> 
> wanghaibin (4):
>   kvm: arm/arm64: vgic: Implement the vGICv2 GICC_APRn uaccess
>     interface.
>   kvm: arm/arm64: vgic-v2: Add GICH_APRn accessors for GICv2
>   kvm: arm/arm64: vgic-v3: add ICH_AP[01]Rn accessors for GICv3
>   kvm: arm/arm64: vgic: clean up vGICv3 ICC_APRn sysreg uaccess
> 
>  arch/arm64/kvm/vgic-sys-reg-v3.c | 25 +++++--------------------
>  virt/kvm/arm/vgic/vgic-mmio-v2.c | 22 ++++++++++++++++++++--
>  virt/kvm/arm/vgic/vgic-mmio.c    | 28 ++++++++++++++++++++++++++++
>  virt/kvm/arm/vgic/vgic-v2.c      | 18 ++++++++++++++++++
>  virt/kvm/arm/vgic/vgic-v3.c      | 20 ++++++++++++++++++++
>  virt/kvm/arm/vgic/vgic.h         |  7 +++++++
>  6 files changed, 98 insertions(+), 22 deletions(-)
> 
> -- 
> 1.8.3.1
> 
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
