From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [RFC PATCH 1/3] kvm: arm/arm64: vgic-vits: separate
 vgic_its_free_list() function
Date: Wed, 13 Sep 2017 12:14:05 -0700
Message-ID: <20170913191405.GH1631@lvm>
References: <1504703110-10744-1-git-send-email-wanghaibin.wang@huawei.com>
 <1504703110-10744-2-git-send-email-wanghaibin.wang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B345349C2E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Sep 2017 15:11:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cOVLi5vU3Ayw for <kvmarm@lists.cs.columbia.edu>;
 Wed, 13 Sep 2017 15:11:27 -0400 (EDT)
Received: from mail-pf0-f172.google.com (mail-pf0-f172.google.com
 [209.85.192.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C725640D25
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Sep 2017 15:11:27 -0400 (EDT)
Received: by mail-pf0-f172.google.com with SMTP id q76so1647021pfq.2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Sep 2017 12:14:07 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1504703110-10744-2-git-send-email-wanghaibin.wang@huawei.com>
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
Cc: marc.zyngier@arm.com, andre.przywara@arm.com, kvmarm@lists.cs.columbia.edu, wu.wubin@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Sep 06, 2017 at 09:05:08PM +0800, wanghaibin wrote:
> We slightly refactor vgic_its_destroy, separate vgic_its_free_list()
> function for later patch invoke.
> 
> The patch also take a functional change. If the its->device_list.next

I don't see a functional change in this patch?

Thanks,
-Christoffer

> is NULL, we still should free the its.
> Honestly, I can't understand How does the its->device_list.next is NULL
> happened at this moment.
> 
> Signed-off-by: wanghaibin <wanghaibin.wang@huawei.com>
> ---
>  virt/kvm/arm/vgic/vgic-its.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> index aa6b68d..25d614f 100644
> --- a/virt/kvm/arm/vgic/vgic-its.c
> +++ b/virt/kvm/arm/vgic/vgic-its.c
> @@ -1624,10 +1624,8 @@ static void vgic_its_free_device(struct kvm *kvm, struct its_device *dev)
>  	kfree(dev);
>  }
>  
> -static void vgic_its_destroy(struct kvm_device *kvm_dev)
> +static void vgic_its_free_list(struct kvm *kvm, struct vgic_its *its)
>  {
> -	struct kvm *kvm = kvm_dev->kvm;
> -	struct vgic_its *its = kvm_dev->private;
>  	struct list_head *cur, *temp;
>  
>  	/*
> @@ -1653,7 +1651,14 @@ static void vgic_its_destroy(struct kvm_device *kvm_dev)
>  		kfree(coll);
>  	}
>  	mutex_unlock(&its->its_lock);
> +}
> +
> +static void vgic_its_destroy(struct kvm_device *kvm_dev)
> +{
> +	struct kvm *kvm = kvm_dev->kvm;
> +	struct vgic_its *its = kvm_dev->private;
>  
> +	vgic_its_free_list(kvm, its);
>  	kfree(its);
>  }
>  
> -- 
> 1.8.3.1
> 
> 
