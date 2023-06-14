Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27F7D101DD
	for <kvmarm@lists.linux.dev>; Wed, 14 Jun 2023 20:25:18 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-bcef239a9fbso143792276.1
        for <kvmarm@lists.linux.dev>; Wed, 14 Jun 2023 13:25:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686774318; x=1689366318;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=TQP3yKANSdJaGpHIoSjygsRuBRtatk9kXbKWlLHfOX0=;
        b=mBRUipmKMnt/8crj4NeT1dfesMkIIaLHc109CZoZqwN4fM4pLmESBO4fBRiYCneCwy
         mDygdWsNM7SZXMC3zSIWpumHCIig9eaDA9A7+ndsxOozz88/qMSiWVim4HFEF9+/McSI
         4ARNDtuClWiXSzSSn0QqHTAl4YHKakhpnlKpe///BtlQrkLLtFqr/JRL8ZBZJc4fEt+r
         7GYUF+3dERlV3iSFmSvZP0N7JhQOKlAt9UM5+YxJfQpLM6E0c3Vs+JXSmPcFxU/ly84K
         MfwarMHIPDgVsR4EUsBOMHhh7mmn5nFC85ZvgwNAYekLTmdzHOjIO3A32mG64UM5obhz
         avRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686774318; x=1689366318;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TQP3yKANSdJaGpHIoSjygsRuBRtatk9kXbKWlLHfOX0=;
        b=DgUh3fgsfo+MEKnRUgp/Rhoiu0t/mMEGHMIThyu4R6DCqoH/Xy6Efu/dGcBZKG9UL8
         2sE9CHyUSaQdSiEktRM1kfjghgeH38uAPDRzi+D6YpAWA8FkH9UJDhSTJEChg1l1OGRF
         PnwUeo/uRLnPjM0uFpFwjR576crjqxNeZNvDfZMFwLOJQ/5WVJugHgGfJwX+QU0dbmgr
         6ftijdgihuGcioJc5dIVzufNj8amA5ZRu6oFsEoQYaxE/1i/TPWKwiz6np2zgQ7ogVEF
         pdJbkW1P9RmvSI8EJL741zilx7+X37wocDOTORiYMANGWlK/1MsGAXxGZ1LLFwyyW8es
         U/ZQ==
X-Gm-Message-State: AC+VfDwbRFvjcnouU4woy0l1o8FIHqomUC/gbxlgcfL/HOhWsgXQ9nwq
	to+tJhtjDRe+A6u/7BFIGFNlLHEIrVk=
X-Google-Smtp-Source: ACHHUZ7uV3qfE5wDKEFNhAw0hJ7SWAeJwh3eagfxYc279M8XxA1fVNOzH1aWNqsgS6QXoYvvT84EtADmvu4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1185:b0:ba8:381b:f764 with SMTP id
 m5-20020a056902118500b00ba8381bf764mr1192321ybu.3.1686774318001; Wed, 14 Jun
 2023 13:25:18 -0700 (PDT)
Date: Wed, 14 Jun 2023 13:25:16 -0700
In-Reply-To: <20230602161921.208564-11-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230602161921.208564-1-amoorthy@google.com> <20230602161921.208564-11-amoorthy@google.com>
Message-ID: <ZIoiLGotFsDDvRN3@google.com>
Subject: Re: [PATCH v4 10/16] KVM: x86: Implement KVM_CAP_NOWAIT_ON_FAULT
From: Sean Christopherson <seanjc@google.com>
To: Anish Moorthy <amoorthy@google.com>
Cc: oliver.upton@linux.dev, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com, 
	jthoughton@google.com, bgardon@google.com, dmatlack@google.com, 
	ricarkol@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	nadav.amit@gmail.com, isaku.yamahata@gmail.com
Content-Type: text/plain; charset="us-ascii"

On Fri, Jun 02, 2023, Anish Moorthy wrote:
> When the memslot flag is enabled, fail guest memory accesses for which
> fast-gup fails (ie, where resolving the page fault would require putting
> the faulting thread to sleep).
> 
> Suggested-by: James Houghton <jthoughton@google.com>
> Signed-off-by: Anish Moorthy <amoorthy@google.com>
> ---
>  Documentation/virt/kvm/api.rst |  2 +-
>  arch/x86/kvm/mmu/mmu.c         | 17 ++++++++++++-----
>  arch/x86/kvm/x86.c             |  1 +
>  3 files changed, 14 insertions(+), 6 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 9daadbe2c7ed..aa7b4024fd41 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -7783,7 +7783,7 @@ bugs and reported to the maintainers so that annotations can be added.
>  7.35 KVM_CAP_NOWAIT_ON_FAULT
>  ----------------------------
>  
> -:Architectures: None
> +:Architectures: x86
>  :Returns: -EINVAL.
>  
>  The presence of this capability indicates that userspace may pass the
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index cb71aae9aaec..288008a64e5c 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4299,7 +4299,9 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
>  	kvm_mmu_do_page_fault(vcpu, work->cr2_or_gpa, 0, true, NULL);
>  }
>  
> -static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
> +static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu,
> +			     struct kvm_page_fault *fault,
> +			     bool nowait)

More booleans!?  Just say no!  And in this case, there's no reason to pass in a
flag, just handle this entirely in __kvm_faultin_pfn().

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 7b6eab6f84e8..ebf21f1f43ce 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4302,6 +4302,7 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
 static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
        struct kvm_memory_slot *slot = fault->slot;
+       bool nowait = kvm_is_slot_nowait_on_fault(slot);
        bool async;
 
        /*
@@ -4332,9 +4333,12 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
        }
 
        async = false;
-       fault->pfn = __gfn_to_pfn_memslot(slot, fault->gfn, false, false, &async,
-                                         fault->write, &fault->map_writable,
-                                         &fault->hva);
+
+       fault->pfn = __gfn_to_pfn_memslot(slot, fault->gfn,
+                                         nowait, false,
+                                         nowait ? NULL : &async,
+                                         fault->write, &fault->map_writable, &fault->hva);
+
        if (!async)
                return RET_PF_CONTINUE; /* *pfn has correct page already */


On a related topic, I would *love* for someone to overhaul gfn_to_pfn() to replace
the "booleans for everything" approach and instead have KVM pass FOLL_* flags
internally.  Rough sketch here: https://lkml.kernel.org/r/ZGvUsf7lMkrNDHuE%40google.com
