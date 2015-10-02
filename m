From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [PATCH v2 09/15] KVM: arm64: implement basic ITS register handlers
Date: Fri, 02 Oct 2015 10:51:38 +0300
Message-ID: <00a101d0fce7$2d60fc00$8822f400$@samsung.com>
References: <1436538111-4294-1-git-send-email-andre.przywara@arm.com>
 <1436538111-4294-10-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A039412D6
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Oct 2015 03:50:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wrDbTvoehgIc for <kvmarm@lists.cs.columbia.edu>;
 Fri,  2 Oct 2015 03:50:03 -0400 (EDT)
Received: from mailout3.w1.samsung.com (mailout3.w1.samsung.com
 [210.118.77.13])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4D0B8412A6
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Oct 2015 03:50:02 -0400 (EDT)
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NVL00DE71U76M60@mailout3.w1.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Fri, 02 Oct 2015 08:51:43 +0100 (BST)
In-reply-to: <1436538111-4294-10-git-send-email-andre.przywara@arm.com>
Content-language: ru
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: 'Andre Przywara' <andre.przywara@arm.com>, marc.zyngier@arm.com, christoffer.dall@linaro.org, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

 Hello!

 Long time has passed, but i started working on live migration of this thing, and found some more
problems.

> @@ -117,9 +305,26 @@ int vits_init(struct kvm *kvm)
>  	struct vgic_dist *dist = &kvm->arch.vgic;
>  	struct vgic_its *its = &dist->its;
> 
> +	dist->pendbaser = kmalloc(sizeof(u64) * dist->nr_cpus, GFP_KERNEL);
> +	if (!dist->pendbaser)
> +		return -ENOMEM;
> +
>  	spin_lock_init(&its->lock);
> 
>  	its->enabled = false;
> 
>  	return -ENXIO;
>  }
> +

 vits_init() allocates table for per-CPU pendbaser values. However, it is called from within
vgicv3_map_resources(), which is in turn called upon first vCPU run. This is too late, because in
case of live migration we would first want to set up all registers from within the userspace. But,
when i start doing this, i crash in handle_mmio_pendbaser_redist(), because of dist->pendbaser being
NULL.
 The solution is to split the function up. I moved vgic_register_kvm_io_dev() (introduced by later
patch) to vits_map_resources(), which is now called where vits_init() originally was. My new
vits_init() (which is made reentrant by checking for dist->pendbaser != NULL) is now called from
within two places:
 a) vits_map_resources()
 b) handle_mmio_pendbaser_redist()

 Therefore, all allocations happen either on first vCPU run, or on first PENDBASER access, whatever
comes first. An alternative is to do allocations during KVM_DEV_ARM_VGIC_CTRL_INIT.

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia
