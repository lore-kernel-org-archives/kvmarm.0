Received: from mail-lf2-f12.google.com (mail-lf2-f12.google.com [74.125.229.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB33D5867C6
	for <kvmarm@lists.linux.dev>; Thu, 10 Sep 2026 18:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.229.204
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789065907; cv=pass; b=owtYc8jOTf8D9STckf9O8DVwX6ebIF5ER58FUmKcZ0DjH3y1DddN7iz7bTjmlhCfJyh+gkC9thhbbUfcb+s/+Y16bC+1s6dlky5ZmujBpOrC/C47UVL2U01w17LUY4C6gTqyx4rrPF4Ry+0Ig37oKC6v7hCM1+iuCRaIDO81UJE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789065907; c=relaxed/simple;
	bh=ZXmoK/6pYB0EUku110iJZ39Wy6sowbSU+f/mh13+y/4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MirekNF77HAdsXvWrx+QI8n/lk83CLBsi3OzMAPY1G/tDgi0V1u7ORzXAAIAEOUk395nV4ME9XABgSj8oVj/7/HPx+wnBlHQqB7m4b1zGMVl9LRnNj82z2BNmJSN3W2V7jJHb6s7J0S60FNqx2tFCjVef84keZlzwkhIi74Fk90=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XUxWS1Rb; arc=pass smtp.client-ip=74.125.229.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XUxWS1Rb"
Received: by mail-lf2-f12.google.com with SMTP id 2adb3069b0e04-5b4a0b17359so9464e87.0
        for <kvmarm@lists.linux.dev>; Thu, 10 Sep 2026 11:45:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789065904; cv=none;
        d=google.com; s=arc-20260327;
        b=SmnUU9WxwRGl/auUjBxsfPrI4foc3CGwlmmGpIybhAOuj0/Z1V6Xh3hFs644uorwDf
         PC44Nb0BxdmiHzixQBNYgfDeA5jelxf56S4Wa5PTKx2KRNwwoYt2OmLgHH3EregIlmtz
         jvRcgZDg3/36mw3aky7weVL8SjGO25+Qvly15A/KofW3xgfyw45t9BbM1wiO+0qGT78L
         NSVHgFslT0DpLLbRTY78VevD0iAyOLm3R+n4sWrDrRqEwkcCYUgK5ByMpSqAfmwCuGmh
         igdxFs+lV7kLOYMvJNMe1CQO3BpqWnZXOy1gl6c54pFmpjIDWNn1ZQWAlrTYRaSxO/Qk
         RLTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=6mxXlzJuLSIxRk+E9jigAcfOHrY2xXO1oOwkSi2OYVs=;
        fh=MTFjx7eTYGNvq/1MFrdJrPwC5ieFCDn9xAULoV2HXJo=;
        b=H2klZ1MEB0BRSvu+XH8ITjvLZ/p3uy7pfs2aeLcNavXMNpijsNDFpsELE1Iw0J7gZZ
         NlAwfB9Pv8iQ6qtdte7FZWhZLKbGI2coOwMPc53awdfHJVlIEfFe85rjqBqRrqNBu0qF
         COBLosmL7Fy1HP2kQX0koQDErkRTmT5VBbpWh9wfeTNl2PRT7Pd04hr8HteJxKsuJWdj
         6cv3XEHxoDbCzi1C/rOwpJ4TWUwcc7kweWUPuy6b5/gqztb9dbiY3sOUYf8D/fhi0Mfv
         WvsAwHzugtOXUzIB0St/RemifOiqVNSmr2734wO2g9FWgbTYSFy50SDz6cjkiDqdDFnt
         Wa+w==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789065904; x=1789670704; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6mxXlzJuLSIxRk+E9jigAcfOHrY2xXO1oOwkSi2OYVs=;
        b=XUxWS1Rb++wIIUfw0lMTpWlV2Ip4vdLfFw3k/wOLEy07p2luuQQWQo2q0OXszyswqK
         JcS+KpUmj8PiftB/OI4+LcycpAbgT8pJJDeK3Lgx5Dn0heJKHY7s66CLtlfCgrSLny8Z
         DE0NGgVv5NwGfNCpdhBCe4rQB0QIioe3q6PaXHcEZR2/t9iG2wzQPsJ8aWFbLq7GlQmE
         qMUFu/oczP9BP8aHnWHHxo+cTjg8oS+DNsuuWXppMZuLVZX3VtTAQZUp2J5+gCuqsylu
         v9qQRKk2jPwrEDuhlXCLwtdH2vCTKUKnupPSrxvySOxqd4XcvQ8IsGMkmTMPFR+Y4lrU
         u9Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789065904; x=1789670704;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=6mxXlzJuLSIxRk+E9jigAcfOHrY2xXO1oOwkSi2OYVs=;
        b=e0z0Zku9SHcwttheJLwSs8aD+jNd6AI6pr+Te7SLBZtY5DIruoaScP6JCimZUGcMph
         Cc5HDvPKlCZjjQwKXh2R2DZza1u+i2vaafDKToOPkFx5h/ode6Hmef20j0X1gSmyy76P
         WpaZtJdqukuJ3F3XLgCaO+otm2ndfZeAjVTwStV66Y/5KtXwLHrqEuk0EFlrLzzBvg93
         9QW13A5UYK3nBFGJs3zhs0/tX9XUpyOM0szEwnlyDt/AZIt2k1B1VDxJKPl9epKLycHK
         0cVyVp+Jxjaev9D3GuehKLHwuQrJwNXjQdl42eEDRSkL4hgf7dUPddaCnUBDcjHgCDGt
         jk/A==
X-Forwarded-Encrypted: i=1; AKwUvBwok5ZEn244hcZEH/79aUJaV6USyCxDSIgj4eMjdIcMWUvtz8N1hCkSxhY8lfVxn2+0nx7+8E8=@lists.linux.dev
X-Gm-Message-State: AFuF++lT9T76j9+esCaQTyxUI468U8W0qSpDinI9WaccrsdVJLOcAcwY
	n+45cMBqIiz0N7DDxPrSF/CgoU7YiwtbPgEbdQJ8rpUfOS+bdT+0UBDUh3BT5k9IzDtWEwtzDpF
	Nz9JV+34FynyZfRksHLprido3FEWjoPq7Y6MBQ3x1
X-Gm-Gg: AYBFou0JxOGH9VLWliZOSoZlxaYSNtt5HHd0HnCaFe7NHVDWDiOhuNqTjF4mdMnbXo1
	M/ZIaAGF+ieGuM9Z2kl2h+X1VnDMvgHpPESUmCv+6SPe5ug8iKOWJILzsfcWjIuKNUfavo1rTzl
	W8jZVqtgve8kGfIHCDl+x0kTxgvM78So8O/Rk8xgWQBlLoi8JzZu2lpigfglAn1maDp2bxPxxmy
	c3j2wY3lErKkerUEzFUiSXs/LWLtJKlw84N6jZXszbYuGXRhmy+4Nv+wyfRY5zppStNsVJxUBwS
	0c6H7U5dd7AcdrGBoysErxojRtFrueed59PfJae3wHnB+cyvRsyCcMzHc0O62pLf8IOhkTaCDQE
	+Lawkv2ze3gTIzw==
X-Received: by 2002:a05:6512:2346:b0:5ae:b0ee:f737 with SMTP id
 2adb3069b0e04-5b8a07b13f4mr18218e87.9.1789065902145; Thu, 10 Sep 2026
 11:45:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260825-kvm-arm-prefault-v1-0-befe8947702e@kernel.org>
In-Reply-To: <20260825-kvm-arm-prefault-v1-0-befe8947702e@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 10 Sep 2026 19:44:25 +0100
X-Gm-Features: AcwNN1Xstr2nKNQ0qtLcezmwbWTpmOb8zSO-m5akVdu8AVpy9ds-Ainfdlx4-oc
Message-ID: <CA+EHjTw=7M+ac5UCfM5yPmuX8RuqZN08TLfXAmTLbQgmuhNWtw@mail.gmail.com>
Subject: Re: [PATCH 0/8] KVM: arm64: Add KVM_PRE_FAULT_MEMORY support
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Jack Thomson <jackabt@amazon.com>, Jack Thomson <jackabt.amazon@gmail.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Vincent Donnefort <vdonnefort@google.com>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Sean Christopherson <seanjc@google.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Leo Soares Passos <Leo.Bras@arm.com>
Content-Type: text/plain; charset="UTF-8"

Hi Lorenzo,

On Tue, 25 Aug 2026 at 17:01, Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:
>
> This series implements the KVM stage 2 page table pre-faulting feature for
> arm64.

I know there's likely going to be a V2, but FWIW, I tested this series
as follows (finally managed to get protected mode running on my Mac):

QEMU (arm64, -cpu max,pauth=off):
- Protected-mode host, boots non-protected and protected guests
- pre_fault_memory_test on a non-protected host, VHE and nVHE, all 13
guest modes
- nv_pre_fault_memory_test with kvm-arm.mode=nested

FVP (AEM, FEAT_NV2):
- nv_pre_fault_memory_test with kvm-arm.mode=nested

Apple M4 hardware, running as a KVM host at EL2 under Apple's nested
virtualization (nVHE only):
- pre_fault_memory_test, anonymous and anonymous_thp backing, over the five
  guest modes available there (the IPA is capped at 40 bits and the 64K
  granule isn't implemented)
- with kvm-arm.mode=protected, pre_fault_memory_test skips on
  KVM_CAP_PRE_FAULT_MEMORY, so the pKVM exclusion holds on a live pKVM host

Tested-by: Fuad Tabba < fuad.tabba@linux.dev>
(happy to retest again when you respin)

Cheers,
/fuad


>
> == Foundations ==
>
> The series begins by establishing required foundations:
>
> 1. Updating kvm_s2_fault_desc to independently store the exception syndrome
>    register (ESR) value, and updating all code paths to use this value
>    exclusively.
>
> This is needed so we can later generate a synthetic fault to perform the
> pre-faulting - we need to be sure the code doesn't grab an incorrect ESR
> from elsewhere.
>
> 2. Updating kvm_s2_fault_desc to independently store the kvm_s2_mmu and
>    updating all code paths to use this value exclusively.
>
> Similarly this is needed so we can generate a synthetic fault against the
> canonical stage 2 MMU (it would make no sense for it to touch nested shadow
> page tables) - we need to be sure that the code doesn't grab an incorrect
> MMU from elsewhere.
>
> 3. Updating the abort paths which consume kvm_s2_fault_desc to also return
>    a kvm_s2_fault_result data structure.
>
> To perform pre-faulting the code must know the granule size of what was
> just walked. So the abort paths have to tell us what that was.
>
> 4. Pass walk flags to kvm_pgtable_get_leaf() to permit walking page tables
>    under the MMU read lock.
>
> This is Jack's patch, verbatim, which allows the use of the
> KVM_PGTABLE_WALK_SHARED flag to walk page tables under the MMU read lock.
>
> Pre-faulting requires it to be able to work in parallel as specified by the
> API. The read lock precludes page tables being torn down behind our back.
>
> == Implementation ==
>
> Pre-faulting is implemented in kvm_arch_vcpu_pre_fault_memory() whose job
> is to pre-fault the stage 2 page tables which map a specific GPA (which,
> for arm64, is the guest's IPA).
>
> This function is called by kvm_vcpu_pre_fault_memory() for each GPA in the
> range, which itself is ultimately invoked by userland via the
> KVM_PRE_FAULT_MEMORY ioctl.
>
> The implementation is simple - try to walk to the stage 2 page table
> mapping the GPA - if unmapped, fault it in through a synthetic page fault.
>
> pKVM is not supported regardless of whether the VM is protected or
> not.
>
> This is because pKVM instantiates vCPUs upon run, but pre-faulting is
> typically performed before a vCPU is run. It would be confusing and
> inconsistent to error out on non-running vCPUs but to pre-fault running
> ones.
>
> Jack's original test suite is also included in the series.
>
> == Credits ==
>
> This series is based, with gratitude, on Jack Thomson's series and their
> respins (links provided below) as well as the feedback he received.
>
> The series includes Jack's v5 "KVM: arm64: Pass walk flags to
> kvm_pgtable_get_leaf()" patch verbatim, and all three of his test patches,
> two of which required minor fixups.
>
> Link: https://patch.msgid.link/20260612162354.73378-1-jackabt.amazon@gmail.com/
> Link: https://patch.msgid.link/20260113152643.18858-1-jackabt.amazon@gmail.com/
> Link: https://patch.msgid.link/20251119154910.97716-1-jackabt.amazon@gmail.com/
> Link: https://patch.msgid.link/20251013151502.6679-1-jackabt.amazon@gmail.com/
> Link: https://patch.msgid.link/20250911134648.58945-1-jackabt.amazon@gmail.com/
>
> == Reviewer Notes ==
>
> I synced with maintainers on this who asked me to take a look, as there hadn't
> been progress on the series for some time.
>
> Am happy to rebase again after -rc1.
>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
> Jack Thomson (4):
>       KVM: arm64: Pass walk flags to kvm_pgtable_get_leaf()
>       KVM: selftests: Enable pre_fault_memory_test for arm64
>       KVM: selftests: Add option for different backing in pre-fault tests
>       KVM: selftests: Add nested pre-fault test for arm64
>
> Lorenzo Stoakes (ARM) (4):
>       KVM: arm64: Propagate and use esr in s2fd when handling guest aborts
>       KVM: arm64: Propagate and use mmu in s2fd when handling guest aborts
>       KVM: arm64: Propagate and use kvm_s2_fault_result on S2 fault
>       KVM: arm64: Implement KVM_PRE_FAULT_MEMORY
>
>  Documentation/virt/kvm/api.rst                     |  17 +-
>  arch/arm64/include/asm/esr.h                       | 129 +++++---
>  arch/arm64/include/asm/kvm_emulate.h               |  52 +---
>  arch/arm64/include/asm/kvm_pgtable.h               |   5 +-
>  arch/arm64/include/asm/kvm_pkvm.h                  |   2 +-
>  arch/arm64/kvm/Kconfig                             |   1 +
>  arch/arm64/kvm/arm.c                               |   1 +
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c              |  10 +-
>  arch/arm64/kvm/hyp/pgtable.c                       |   5 +-
>  arch/arm64/kvm/mmu.c                               | 324 +++++++++++++++++----
>  arch/arm64/kvm/nested.c                            |   2 +-
>  tools/testing/selftests/kvm/Makefile.kvm           |   2 +
>  .../selftests/kvm/arm64/nv_pre_fault_memory_test.c | 206 +++++++++++++
>  .../testing/selftests/kvm/pre_fault_memory_test.c  | 152 ++++++++--
>  14 files changed, 736 insertions(+), 172 deletions(-)
> ---
> base-commit: aa8e5dc6a7a2a1141ab40706a51010adcd0e57d2
> change-id: 20260815-kvm-arm-prefault-9bb411b6897d
>
> Best regards,
> --
> Lorenzo Stoakes (ARM) <ljs@kernel.org>
>
