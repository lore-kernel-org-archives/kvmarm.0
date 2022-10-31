Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84573FA3740
	for <kvmarm@archiver.kernel.org>; Mon, 31 Oct 2022 09:08:38 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0E5FD4BACE;
	Mon, 31 Oct 2022 05:08:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id EV0PvV9E8bql; Mon, 31 Oct 2022 05:08:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 193554BAD6;
	Mon, 31 Oct 2022 05:08:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D77FE4BACE
 for <kvmarm@lists.cs.columbia.edu>; Mon, 31 Oct 2022 05:08:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uuGacKEN8E0b for <kvmarm@lists.cs.columbia.edu>;
 Mon, 31 Oct 2022 05:08:32 -0400 (EDT)
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2604D4BACB
 for <kvmarm@lists.cs.columbia.edu>; Mon, 31 Oct 2022 05:08:32 -0400 (EDT)
Date: Mon, 31 Oct 2022 09:08:25 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1667207310;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=U5/JbhY9LhPSVJdzEwNQNkVnYtJH0GE5orskeb4KkyM=;
 b=jv8WmDlSDnakkn2G4sRDBN9wI1fZ25KXJiRIu7pmtAqaYYLTMBBhML386CR6NVjUCjSw5k
 /oehu9sLm6mNwPLju/fWRXVaDrdIFKeJG83KuyaWFObAy/glCdCYnFeASrNhTnxGOb7jyK
 9abjDA6RtHarmimbY5SP6e0zPRXdbsk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v7 5/9] KVM: arm64: Improve no-running-vcpu report for
 dirty ring
Message-ID: <Y1+QiS0S3e6b358Q@google.com>
References: <20221031003621.164306-1-gshan@redhat.com>
 <20221031003621.164306-6-gshan@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20221031003621.164306-6-gshan@redhat.com>
X-Migadu-Flow: FLOW_OUT
Cc: shuah@kernel.org, catalin.marinas@arm.com, kvm@vger.kernel.org,
 maz@kernel.org, andrew.jones@linux.dev, dmatlack@google.com,
 shan.gavin@gmail.com, bgardon@google.com, kvmarm@lists.linux.dev,
 pbonzini@redhat.com, zhenyzha@redhat.com, will@kernel.org,
 kvmarm@lists.cs.columbia.edu, ajones@ventanamicro.com
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Mon, Oct 31, 2022 at 08:36:17AM +0800, Gavin Shan wrote:
> KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP should be enabled only when KVM
> device "kvm-arm-vgic-its" is used by userspace. Currently, it's the
> only case where a running VCPU is missed for dirty ring. However,
> there are potentially other devices introducing similar error in
> future.
> 
> In order to report those broken devices only, the no-running-vcpu
> warning message is escaped from KVM device "kvm-arm-vgic-its". For
> this, the function vgic_has_its() needs to be exposed with a more
> generic function name (kvm_vgic_has_its()).
> 
> Link: https://lore.kernel.org/kvmarm/Y1ghIKrAsRFwSFsO@google.com
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Gavin Shan <gshan@redhat.com>

I don't think this should be added as a separate patch.

The weak kvm_arch_allow_write_without_running_vcpu() (and adding its
caller) should be rolled into patch 4/9. The arm64 implementation of
that should be introduced in patch 6/9.

> ---
>  arch/arm64/kvm/mmu.c               | 14 ++++++++++++++
>  arch/arm64/kvm/vgic/vgic-init.c    |  4 ++--
>  arch/arm64/kvm/vgic/vgic-irqfd.c   |  4 ++--
>  arch/arm64/kvm/vgic/vgic-its.c     |  2 +-
>  arch/arm64/kvm/vgic/vgic-mmio-v3.c | 18 ++++--------------
>  arch/arm64/kvm/vgic/vgic.c         | 10 ++++++++++
>  arch/arm64/kvm/vgic/vgic.h         |  1 -
>  include/kvm/arm_vgic.h             |  1 +
>  include/linux/kvm_dirty_ring.h     |  1 +
>  virt/kvm/dirty_ring.c              |  5 +++++
>  virt/kvm/kvm_main.c                |  2 +-
>  11 files changed, 41 insertions(+), 21 deletions(-)
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 60ee3d9f01f8..e0855b2b3d66 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -932,6 +932,20 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
>  	kvm_mmu_write_protect_pt_masked(kvm, slot, gfn_offset, mask);
>  }
>  
> +/*
> + * kvm_arch_allow_write_without_running_vcpu - allow writing guest memory
> + * without the running VCPU when dirty ring is enabled.
> + *
> + * The running VCPU is required to track dirty guest pages when dirty ring
> + * is enabled. Otherwise, the backup bitmap should be used to track the
> + * dirty guest pages. When vgic/its is enabled, we need to use the backup
> + * bitmap to track the dirty guest pages for it.
> + */
> +bool kvm_arch_allow_write_without_running_vcpu(struct kvm *kvm)
> +{
> +	return kvm->dirty_ring_with_bitmap && kvm_vgic_has_its(kvm);
> +}

It is trivial for userspace to cause a WARN to fire like this. Just set
up the VM with !RING_WITH_BITMAP && ITS.

The goal is to catch KVM bugs, not userspace bugs, so I'd suggest only
checking whether or not an ITS is present.

[...]

> diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
> index 91201f743033..10218057c176 100644
> --- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
> +++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
> @@ -38,20 +38,10 @@ u64 update_64bit_reg(u64 reg, unsigned int offset, unsigned int len,
>  	return reg | ((u64)val << lower);
>  }
>  
> -bool vgic_has_its(struct kvm *kvm)
> -{
> -	struct vgic_dist *dist = &kvm->arch.vgic;
> -
> -	if (dist->vgic_model != KVM_DEV_TYPE_ARM_VGIC_V3)
> -		return false;
> -
> -	return dist->has_its;
> -}
> -

nit: renaming/exposing this helper should be done in a separate patch.
Also, I don't think you need to move it anywhere either.

[...]

> diff --git a/virt/kvm/dirty_ring.c b/virt/kvm/dirty_ring.c
> index 7ce6a5f81c98..f27e038043f3 100644
> --- a/virt/kvm/dirty_ring.c
> +++ b/virt/kvm/dirty_ring.c
> @@ -26,6 +26,11 @@ bool kvm_use_dirty_bitmap(struct kvm *kvm)
>  	return !kvm->dirty_ring_size || kvm->dirty_ring_with_bitmap;
>  }
>  
> +bool __weak kvm_arch_allow_write_without_running_vcpu(struct kvm *kvm)
> +{
> +	return kvm->dirty_ring_with_bitmap;
> +}
> +

Same comment on the arm64 implementation applies here. This should just
return false by default.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
