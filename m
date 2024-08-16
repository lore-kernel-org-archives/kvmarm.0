Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC69F44374
	for <kvmarm@lists.linux.dev>; Fri, 16 Aug 2024 20:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723841591; cv=none; b=CWE+qtUyGW8k2Aq8Mjza0kYXZIxe9PGhDVNuVqy9qcUG63ZnzxtC+/BFF/HTWBefqXsnUiC+LT+wzuIYjocjQJoyeR/cbG2OcyF2jkmjI9N+C/6hajLobijl7jDpPCJkFc2oWJNh67kVQESE5n0/SzE4baqeUMKD4m8UNZ5JAug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723841591; c=relaxed/simple;
	bh=5UyYQI7yu8x9ERunnWfw8TX2oiDwoyPuYXK5BmikKNI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CB5AxL4wGCSX6UCiRxklxEvYr96h/rQV3bSfYYVU+SpFYg0hwvgC1KLL5AveYSKaoeHqgvptndHSZVMVBNJBbfG+7Of+++GSAdIHvrzuIZOtCsRyYn8ii3LTBx0XkTteoQHkCOzPj9N4lqy8M7zCVwm7miEGx4KYGrFD1UFPuu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YkD8HYhx; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YkD8HYhx"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2d3cd20b25cso1963209a91.1
        for <kvmarm@lists.linux.dev>; Fri, 16 Aug 2024 13:53:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723841589; x=1724446389; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=srTYGx2O1W3qN60rjYZPJHIr/dbzcFBsu06le/7UmjM=;
        b=YkD8HYhxaXOO1PHTc6zMIi8PAcUZRiJXkpw5GKjWWVN7XtLPrAq8QjDuO1esUIVYVJ
         4FrO6yQwnGi8qjwmDbNQjoznqpS/dNL0gA9mZ9L/Cvk+o0jC6L559yFwXkf0+E+tHN9p
         NX/tLPsqjAHrcpdRsEQ5oApuHuPnSmp/Ei/nDZ7dWWFRB+t59U0ZdNomahngbBC8eydY
         ouxNvrN81WJTr/tXCrNbklUVu/8pNG8FuKKT2rjnfSxZ3eW2tdfkqpOU/6E1EcGet6Xj
         dsbo1PkGuvM7KYEbqGeloPB1ezUK6sOG1O+hak4r0RhukdzrRjUrmn94NayveWxpMbIT
         tesw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723841589; x=1724446389;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=srTYGx2O1W3qN60rjYZPJHIr/dbzcFBsu06le/7UmjM=;
        b=UhGRbz876/kqMmKl1Drf4V58Rf5qf3uG7HyyTLJWk43cajxP7MO+h+q1rgXFVK3vZA
         40MrCg5VzIbqwhOC9suAq+6wPQV0DoIDT7hqYrgcDIyrLDN5r20bvoIC6mBgSDod08yg
         8QjUCNVY6s7FrunIDCFybT71wr4KekYCNzqq9c/F4wkZ+A4vvLoc85cVb9odBAzVWDlE
         LxrISK2dT3luMsYzYpPX//hQBv02NxWvXGk2tDznSnzttOmVf0MRYxVoaq7ipElr8aSR
         8/0jDRWas9/lhQj1e63fJbwmTVDMruDSRqiFYB+K5puxppOuQ+VvdDpR3pbGbRnNtGSI
         YZIQ==
X-Forwarded-Encrypted: i=1; AJvYcCUHUer8zv+kDBhRqrgpKZkDu++TDH9XYi7ti204EmrZlTqrcE/vjQZfKtTwod/lqDPc/4dXnf2uMA05MqE74fMkHIifDDpe
X-Gm-Message-State: AOJu0Yyivx4S3IalEKnoRV0Mm6EmJzpJF/sVOmmL8E841kMUDS94D22E
	jB74+AjdAktwMbSsKvM5Q9bZLKpFwIRP+GLGlVqIjh9FtzKwq1GoSMy9U/m7soKhL+o80GiHfLz
	rew==
X-Google-Smtp-Source: AGHT+IGpyWIC88JQ8UpHHFnbzA9sTpzlT6P3gnU0rL654gJSXsYoPHhMaqAVVk4iprqVrw9qiV+Fuc1p7zg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:9c05:b0:2d3:acfd:5805 with SMTP id
 98e67ed59e1d1-2d3e03e9c70mr9727a91.8.1723841588800; Fri, 16 Aug 2024 13:53:08
 -0700 (PDT)
Date: Fri, 16 Aug 2024 13:53:07 -0700
In-Reply-To: <20240809205158.1340255-2-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240809205158.1340255-1-amoorthy@google.com> <20240809205158.1340255-2-amoorthy@google.com>
Message-ID: <Zr-8M9rYplgN6IS3@google.com>
Subject: Re: [PATCH v2 1/3] KVM: Documentation: Clarify docs for KVM_CAP_MEMORY_FAULT_INFO
From: Sean Christopherson <seanjc@google.com>
To: Anish Moorthy <amoorthy@google.com>
Cc: oliver.upton@linux.dev, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	jthoughton@google.com, rananta@google.com
Content-Type: text/plain; charset="us-ascii"

On Fri, Aug 09, 2024, Anish Moorthy wrote:
> The initial paragraph of the documentation here makes it sound like a
> KVM_EXIT_MEMORY_FAULT will always accompany an EFAULT from KVM_RUN, but
> that's not a guarantee.
> 
> Also, define zero to be a special value for the "size" field. This
> allows memory faults exits to be set up in spots where KVM_RUN must
> EFAULT, but is not able to supply an accurate size.
> 
> Signed-off-by: Anish Moorthy <amoorthy@google.com>
> ---
>  Documentation/virt/kvm/api.rst | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 8e5dad80b337..c5ce7944005c 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -7073,7 +7073,8 @@ spec refer, https://github.com/riscv/riscv-sbi-doc.
>  
>  KVM_EXIT_MEMORY_FAULT indicates the vCPU has encountered a memory fault that
>  could not be resolved by KVM.  The 'gpa' and 'size' (in bytes) describe the
> -guest physical address range [gpa, gpa + size) of the fault.  The 'flags' field
> +guest physical address range [gpa, gpa + size) of the fault: when zero, it
> +indicates that the size of the fault could not be determined. The 'flags' field
>  describes properties of the faulting access that are likely pertinent:
>  
>   - KVM_MEMORY_EXIT_FLAG_PRIVATE - When set, indicates the memory fault occurred
> @@ -8131,7 +8132,7 @@ unavailable to host or other VMs.
>  :Architectures: x86
>  :Returns: Informational only, -EINVAL on direct KVM_ENABLE_CAP.
>  
> -The presence of this capability indicates that KVM_RUN will fill
> +The presence of this capability indicates that KVM_RUN *may* fill

I would prefer to fix KVM than to change the documentation.  The "will fill" is
specifically scoped to guest page fault VM-Exits, so it should be a fully solvable
problem.  I don't want to leave wriggle room for KVM, because then it will be
quite difficult for userspace to do anything useful with memory_fault.

E.g. for x86, convert all -EFAULTs that are returned when KVM is hosed to -EIO
and KVM_BUG_ON, and then there's only one -EFAULT that doesn't fill memory_fault.
Completely untested...

---
 arch/x86/kvm/mmu/mmu.c         | 13 +++++++------
 arch/x86/kvm/mmu/paging_tmpl.h |  4 ++--
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 928cf84778b0..cb4e3a1041ed 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3225,8 +3225,8 @@ static int direct_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 					     fault->req_level >= it.level);
 	}
 
-	if (WARN_ON_ONCE(it.level != fault->goal_level))
-		return -EFAULT;
+	if (KVM_BUG_ON(it.level != fault->goal_level, vcpu->kvm))
+		return -EIO;
 
 	ret = mmu_set_spte(vcpu, fault->slot, it.sptep, ACC_ALL,
 			   base_gfn, fault->pfn, fault);
@@ -3264,6 +3264,7 @@ static int kvm_handle_error_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fa
 		return RET_PF_RETRY;
 	}
 
+	kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
 	return -EFAULT;
 }
 
@@ -4597,8 +4598,8 @@ int kvm_handle_page_fault(struct kvm_vcpu *vcpu, u64 error_code,
 
 #ifndef CONFIG_X86_64
 	/* A 64-bit CR2 should be impossible on 32-bit KVM. */
-	if (WARN_ON_ONCE(fault_address >> 32))
-		return -EFAULT;
+	if (KVM_BUG_ON(fault_address >> 32, vcpu->kvm))
+		return -EIO;
 #endif
 	/*
 	 * Legacy #PF exception only have a 32-bit error code.  Simply drop the
@@ -5988,8 +5989,8 @@ int noinline kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 err
 
 	r = RET_PF_INVALID;
 	if (unlikely(error_code & PFERR_RSVD_MASK)) {
-		if (WARN_ON_ONCE(error_code & PFERR_PRIVATE_ACCESS))
-			return -EFAULT;
+		if (KVM_BUG_ON(error_code & PFERR_PRIVATE_ACCESS, vcpu->kvm))
+			return -EIO;
 
 		r = handle_mmio_page_fault(vcpu, cr2_or_gpa, direct);
 		if (r == RET_PF_EMULATE)
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 69941cebb3a8..4f4704c65c40 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -745,8 +745,8 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 					     fault->req_level >= it.level);
 	}
 
-	if (WARN_ON_ONCE(it.level != fault->goal_level))
-		return -EFAULT;
+	if (KVM_BUG_ON(it.level != fault->goal_level, vcpu->kvm))
+		return -EIO;
 
 	ret = mmu_set_spte(vcpu, fault->slot, it.sptep, gw->pte_access,
 			   base_gfn, fault->pfn, fault);

base-commit: 12ac7b9981ff30f0deffe6331bb742c71b279300
-- 

