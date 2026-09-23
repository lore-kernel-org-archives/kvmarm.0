Received: from mta0.migadu.com (out-207.mta0.migadu.com [91.218.175.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30A57423E9F
	for <kvmarm@lists.linux.dev>; Wed, 23 Sep 2026 18:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790187891; cv=none; b=cMwNO9sWrTfa2plpqN0SAYh+aBq9F5UZlbTj4wI3hrujfkdTTFZyJcGwppLk79gE/FC1Q6GELCppskXGrurIGyCVjckLJXrDTd5r3bXmmHnzNosG6BLO7tVblDQozT2AyC2CGMhbvYAFMPow+7EwIBQvmjSURRstCcg0PNQeSBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790187891; c=relaxed/simple;
	bh=Y9cNY9EVhpGWLF8ouVsemVx73ft+TAzzfsFY52UKAAQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NShnOqprLWA80hycYKFKed5w51X90vIiwBSK062aTp8OerAQBnHbSUh+J6l6hcV9bzdLVceJnKOn2DD6CEdLG3rYU8l9RAaTVUgRFwXEPvfhTudnBqe36TMryL50C9IG23ZMV9Uio2swhqK2dPjFHd6QPDNuowS9bWICAdDoh/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=nfnTSW8V; arc=none smtp.client-ip=91.218.175.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="nfnTSW8V"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=Y9cNY9EVhpGWLF8ouVsemVx73ft+TAzzfsFY52UKAAQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790187886; v=1; x=1790792686;
 b=nfnTSW8VPsVJwInjuw3KLfIkT4HFR3zU4x0DGjGEoECg8FRUHL+L+2tSiJbM6v+UrpvcyWDP
 h6PD2gz4QSFBOCQbPXEkUyy77j35pdueCudzf43VUTC8S/VuURBCO4g7kepnoZ+LyIX9kbRHIMs
 tgsHwMAdmJAXqnj4EU1Hd6c8=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 11ab815576fd51aa;
	Wed, 23 Sep 2026 18:24:46 +0000
X-Mizu-Trace-ID: 11ab815576fd51aa
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-5b8c42da963so1339e87.0
        for <kvmarm@lists.linux.dev>; Wed, 23 Sep 2026 11:24:42 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxuM3pPMPZQtM5cwc9hZbUP+0ckQz1E4LDfO+YRXjk9zE5BFcKMWGtDCQsQfm1vry+tk9D/LY8=@lists.linux.dev
X-Gm-Message-State: AFuF++m8LVTEsDPmAYPN1luQWnYH3j/4TvBiwGg2m59kPqe5r9KMrGrm
	TOVtZQTZ6wKlzOrj6Sgpbq41NKOo2GjYGxdlVXY0vZWd1pBgIk29stks3GA03TrjGJsowN8qRHF
	5PCu8B+wFaDs85QemrHamT3aSf/G+i6x7SuNgrLV5
X-Received: by 2002:a05:6512:1358:b0:5b2:a967:c0e1 with SMTP id
 2adb3069b0e04-5b8dd6d2b18mr46663e87.0.1790187881652; Wed, 23 Sep 2026
 11:24:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260923-kvm-arm-prefault-v4-0-d4b0b4dfa8c3@kernel.org> <20260923-kvm-arm-prefault-v4-4-d4b0b4dfa8c3@kernel.org>
In-Reply-To: <20260923-kvm-arm-prefault-v4-4-d4b0b4dfa8c3@kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Wed, 23 Sep 2026 19:24:05 +0100
X-Gmail-Original-Message-ID: <CA+EHjTwFTu1xGM6KBC8sXiHFqwTyynB+0_DTtpb+7BsUc1ervA@mail.gmail.com>
X-Gm-Features: AclHuK8Z8GjELqKo_KOGvxxJrDlIp-LJq9-fwgXmkezmX3voRH420SsqXo68zc8
Message-ID: <CA+EHjTwFTu1xGM6KBC8sXiHFqwTyynB+0_DTtpb+7BsUc1ervA@mail.gmail.com>
Subject: Re: [PATCH v4 04/14] KVM: arm64: Propagate and use esr in s2fd when
 handling guest aborts
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, Mark Rutland <mark.rutland@arm.com>, 
	Randy Dunlap <rdunlap@infradead.org>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, David Hildenbrand <david@kernel.org>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Sven Schnelle <svens@linux.ibm.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Shuah Khan <skhan@linuxfoundation.org>, Shuah Khan <shuah@kernel.org>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Jack Thomson <jackabt@amazon.com>, 
	Jack Thomson <jackabt.amazon@gmail.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Vincent Donnefort <vdonnefort@google.com>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
	Sean Christopherson <seanjc@google.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Leo Soares Passos <Leo.Bras@arm.com>, Wei-Lin Chang <weilin.chang@arm.com>, linux-s390@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 23 Sept 2026 at 16:16, Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:
>
> kvm_handle_guest_abort() establishes a kvm_s2_fault_desc data structure,
> s2fd, to store and propagate state to either pkvm_mem_abort(), gmem_abort()
> or user_mem_abort() handlers.
>
> Each of these, however, examines the Exception Syndrome Register (ESR) via
> s2fd->vcpu.
>
> Introduce an s2fd->esr field to abstract this and propagate it to callers.
>
> The value of this (beyond refactoring) is to be able to later generate
> faults with a synthetic esr, specifically to implement stage 2 page table
> pre-faulting.
>
> Abort handlers which use kvm_s2_fault_desc - gmem_abort() and
> user_mem_abort() - now only reference s2fd->esr and do not look it up in
> any other way, which makes it safe to pass a synthetic s2fd->esr value to
> these functions.
>
> No functional change intended.
>
> Reviewed-by: Oliver Upton <oupton@kernel.org>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad

> ---
>  arch/arm64/kvm/mmu.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
>
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 5e10a4cd31ea..cb677ab76484 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1655,21 +1655,22 @@ struct kvm_s2_fault_desc {
>         struct kvm_s2_trans     *nested;
>         struct kvm_memory_slot  *memslot;
>         unsigned long           hva;
> +       unsigned long           esr;
>  };
>
>  static bool kvm_s2_fault_is_perm(const struct kvm_s2_fault_desc *s2fd)
>  {
> -       return esr_fsc_is_permission_fault(kvm_vcpu_get_esr(s2fd->vcpu));
> +       return esr_fsc_is_permission_fault(s2fd->esr);
>  }
>
>  static bool kvm_s2_fault_is_exec(const struct kvm_s2_fault_desc *s2fd)
>  {
> -       return esr_abt_is_exec_fault(kvm_vcpu_get_esr(s2fd->vcpu));
> +       return esr_abt_is_exec_fault(s2fd->esr);
>  }
>
>  static bool kvm_s2_fault_is_write(const struct kvm_s2_fault_desc *s2fd)
>  {
> -       return esr_abt_is_write_fault(kvm_vcpu_get_esr(s2fd->vcpu));
> +       return esr_abt_is_write_fault(s2fd->esr);
>  }
>
>  static u64 kvm_s2_perm_fault_granule(const struct kvm_s2_fault_desc *s2fd)
> @@ -1678,7 +1679,7 @@ static u64 kvm_s2_perm_fault_granule(const struct kvm_s2_fault_desc *s2fd)
>
>         if (!kvm_s2_fault_is_perm(s2fd))
>                 return 0;
> -       level = kvm_vcpu_get_esr(s2fd->vcpu) & ESR_ELx_FSC_LEVEL;
> +       level = s2fd->esr & ESR_ELx_FSC_LEVEL;
>         return BIT(ARM64_HW_PGTABLE_LEVEL_SHIFT(level));
>  }
>
> @@ -2067,7 +2068,7 @@ static int kvm_s2_fault_compute_prot(const struct kvm_s2_fault_desc *s2fd,
>          * and trigger the exception here. Since the memslot is valid, inject
>          * the fault back to the guest.
>          */
> -       if (esr_fsc_is_excl_atomic_fault(kvm_vcpu_get_esr(s2fd->vcpu))) {
> +       if (esr_fsc_is_excl_atomic_fault(s2fd->esr)) {
>                 kvm_inject_dabt_excl_atomic(s2fd->vcpu, kvm_vcpu_get_hfar(s2fd->vcpu));
>                 return 1;
>         }
> @@ -2518,6 +2519,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
>                 .nested         = nested,
>                 .memslot        = memslot,
>                 .hva            = hva,
> +               .esr            = esr,
>         };
>
>         if (kvm_vm_is_protected(vcpu->kvm)) {
>
> --
> 2.55.0
>
