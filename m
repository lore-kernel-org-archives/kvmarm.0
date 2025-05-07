Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C66DD7E1
	for <kvmarm@lists.linux.dev>; Wed,  7 May 2025 00:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746576355; cv=none; b=RcQyKa50XPCqSy3uKCokB6JwEp8I4bwbagpAJG6imJL6tGdQlKWocnHhqdeaoGoNv2e05Ygeec6K8RKTkq3FE1FOoRFXXK6TpkKJswDEbXnRj8G2WpbjhTISDjQlDSv0D6a6wNcLQgb1qX1oJq4DD4ZfHiFz21W1fJanC/fv83g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746576355; c=relaxed/simple;
	bh=yaCcykgp16u3flZaJJz5SvxS7btAI9N+qBqGdItQ0JU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Yicsyr9S7+U/wWeL4u0jCdhDudjcT7DabqOXQki67SmVUC6br3TgSvjqD3slY9KRWPVVkT1aKjlM43ZZ/joeeZeH8WLHCiPr22CwHbJyvPVAa0uu1Tx/vhHp6Z7/2IFSv6CdaSlYsGOKJbl3z1lNTVCD1j1j6i6IyUMQZ1nfBJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TCndXH77; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TCndXH77"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-30a59538b17so3540369a91.3
        for <kvmarm@lists.linux.dev>; Tue, 06 May 2025 17:05:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746576352; x=1747181152; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=kf6t6m3UzjOjQqBtIkrrADeHvo58X2zFNTMCoBeF4hc=;
        b=TCndXH77Sw2tZDFWvh+DEe0LmgAdWxHm+Q4PGMgw6RhKwpxAehI9n8xYwxSTuRdrWs
         DGUedNKn1+2KnSBmAUdXhhZdIAIy+x1r92XQf9vVeRPA68OsewGTQyL7y0aedL/pH2dN
         9KMAKHyEUL6ZwBlwciXqFaRIKUdxRW8v9GaYkwJ+eRwWsYxtu/fhuKj4vvS/iCELw8fE
         H99BgNjs795nOlR/lnE9VmBSUOL80glyMSYqhCSzgGnWiJHFH5rVaIJRL78TYX37VdVX
         s+VtywrQORiuiARBBdnCI7rzFsH3MLwAUxDNkj1qCCJtRt/g0qKKNm5uO6/p3p2KFBtB
         XRbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746576352; x=1747181152;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kf6t6m3UzjOjQqBtIkrrADeHvo58X2zFNTMCoBeF4hc=;
        b=LNMcCPelZVfrLbaH66Kjhi7O7YwBIPIX4TZu9gdxBL+zb/Ao/aaNkwIA0HGUJs5n5E
         vxOdjs6K7KTevwaZOqjd56Ih4gP5RJLkENgZX0rWlSNYiSyCbzDwcmHZR2j9ziX+YndP
         aZ/dX4b/+aOsAEZQGKw+1HsSAw6zZFJ98JxTgjXl5q2b2qgAeiyUsJRsbN8PuptB6Rv3
         etQDqZY6MTzJi6TjAgLnzZjvKPbO2SfCI6K1baMR78FFdStnpIZoRpuLVg59/Mga1e/A
         M+fCpZZy6jdtxna/mT9uRBD0jOZhkOwIa+YH9lKWDwfKDy9gI9kn6btfZknPURIMCKL2
         JpnA==
X-Forwarded-Encrypted: i=1; AJvYcCWqqhDvDExk9czRUhVri+msXhYYizJKdznljx72D4Iqxu55iDh1NAvh3sKTSXociDAzWiBZKVU=@lists.linux.dev
X-Gm-Message-State: AOJu0YzB0gJl96Nh0P6lh/iwHm9l0wm7pVh61r69XJXYTJsYnMK7l4YG
	SeTkO73RoIKDYMuhow2xMH7+vKRiIdrpZiodGZFvuD5SbpD57v1kUsO1ADHErJyRSptfN2jTdsj
	GKg==
X-Google-Smtp-Source: AGHT+IFMFJ1FHxkmhNJJNI7L8Ht1/2Wzfj8wbIGxb39Uyx2QJZM+bpzpV88A2XUmDg8f6OQLimWa7W0pTy4=
X-Received: from pjbnd2.prod.google.com ([2002:a17:90b:4cc2:b0:2f5:63a:4513])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:da87:b0:2fe:b907:3b05
 with SMTP id 98e67ed59e1d1-30aac29bf2bmr1865902a91.29.1746576352169; Tue, 06
 May 2025 17:05:52 -0700 (PDT)
Date: Tue, 6 May 2025 17:05:50 -0700
In-Reply-To: <20250109204929.1106563-6-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250109204929.1106563-1-jthoughton@google.com> <20250109204929.1106563-6-jthoughton@google.com>
Message-ID: <aBqj3s8THH9SFzLO@google.com>
Subject: Re: [PATCH v2 05/13] KVM: x86/mmu: Add support for KVM_MEM_USERFAULT
From: Sean Christopherson <seanjc@google.com>
To: James Houghton <jthoughton@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Yan Zhao <yan.y.zhao@intel.com>, 
	Nikita Kalyazin <kalyazin@amazon.com>, Anish Moorthy <amoorthy@google.com>, 
	Peter Gonda <pgonda@google.com>, Peter Xu <peterx@redhat.com>, 
	David Matlack <dmatlack@google.com>, wei.w.wang@intel.com, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"

On Thu, Jan 09, 2025, James Houghton wrote:
> Adhering to the requirements of KVM Userfault:
> 
> 1. Zap all sptes for the memslot when KVM_MEM_USERFAULT is toggled on
>    with kvm_arch_flush_shadow_memslot().
> 2. Only all PAGE_SIZE sptes when KVM_MEM_USERFAULT is enabled (for both
>    normal/GUP memory and guest_memfd memory).
> 3. Reconstruct huge mappings when KVM_MEM_USERFAULT is toggled off with
>    kvm_mmu_recover_huge_pages(). This is the behavior when dirty logging
>    is disabled; remain consistent with it.
> 
> With the new logic in kvm_mmu_slot_apply_flags(), I've simplified the
> two dirty-logging-toggle checks into one, and I have dropped the
> WARN_ON() that was there.
> 
> Signed-off-by: James Houghton <jthoughton@google.com>
> ---
>  arch/x86/kvm/Kconfig            |  1 +
>  arch/x86/kvm/mmu/mmu.c          | 27 +++++++++++++++++++++----
>  arch/x86/kvm/mmu/mmu_internal.h | 20 +++++++++++++++---
>  arch/x86/kvm/x86.c              | 36 ++++++++++++++++++++++++---------
>  include/linux/kvm_host.h        |  5 ++++-
>  5 files changed, 71 insertions(+), 18 deletions(-)
> 
> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> index ea2c4f21c1ca..286c6825cd1c 100644
> --- a/arch/x86/kvm/Kconfig
> +++ b/arch/x86/kvm/Kconfig
> @@ -47,6 +47,7 @@ config KVM_X86
>  	select KVM_GENERIC_PRE_FAULT_MEMORY
>  	select KVM_GENERIC_PRIVATE_MEM if KVM_SW_PROTECTED_VM
>  	select KVM_WERROR if WERROR
> +	select HAVE_KVM_USERFAULT
>  
>  config KVM
>  	tristate "Kernel-based Virtual Machine (KVM) support"
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 2401606db260..5cab2785b97f 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4280,14 +4280,19 @@ static inline u8 kvm_max_level_for_order(int order)
>  	return PG_LEVEL_4K;
>  }
>  
> -static u8 kvm_max_private_mapping_level(struct kvm *kvm, kvm_pfn_t pfn,
> -					u8 max_level, int gmem_order)
> +static u8 kvm_max_private_mapping_level(struct kvm *kvm,
> +					struct kvm_memory_slot *slot,
> +					kvm_pfn_t pfn, u8 max_level,
> +					int gmem_order)
>  {
>  	u8 req_max_level;
>  
>  	if (max_level == PG_LEVEL_4K)
>  		return PG_LEVEL_4K;
>  
> +	if (kvm_memslot_userfault(slot))

Unless I'm missing something, this can go in kvm_mmu_hugepage_adjust():

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index a4439e9e0726..49eb6b9b268c 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3304,7 +3304,7 @@ void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
        if (is_error_noslot_pfn(fault->pfn))
                return;
 
-       if (kvm_slot_dirty_track_enabled(slot))
+       if (kvm_slot_dirty_track_enabled(slot) || kvm_is_userfault_memslot(slot))
                return;
 
>  static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 1b04092ec76a..2abb425a6514 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -13053,12 +13053,36 @@ static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
>  	u32 new_flags = new ? new->flags : 0;
>  	bool log_dirty_pages = new_flags & KVM_MEM_LOG_DIRTY_PAGES;
>  
> +	/*
> +	 * When toggling KVM Userfault on, zap all sptes so that userfault-ness
> +	 * will be respected at refault time. All new faults will only install
> +	 * small sptes. Therefore, when toggling it off, recover hugepages.
> +	 *
> +	 * For MOVE and DELETE, there will be nothing to do, as the old
> +	 * mappings will have already been deleted by
> +	 * kvm_arch_flush_shadow_memslot().
> +	 *
> +	 * For CREATE, no mappings will have been created yet.
> +	 */

Eh, trim this down and the reference the comment below to explain why FLAGS_ONLY
is the only case that needs to be handled.

> +	if ((old_flags ^ new_flags) & KVM_MEM_USERFAULT &&
> +	    (change == KVM_MR_FLAGS_ONLY)) {
> +		if (old_flags & KVM_MEM_USERFAULT)
> +			kvm_mmu_recover_huge_pages(kvm, new);
> +		else
> +			kvm_arch_flush_shadow_memslot(kvm, old);

The call to kvm_arch_flush_shadow_memslot() should definitely go in common code.
The fancy recovery logic is arch specific, but blasting the memslot when userfault
is toggled on is not.
