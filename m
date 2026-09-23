Received: from mta0.migadu.com (out-237.mta0.migadu.com [91.218.175.237])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E49CF374756
	for <kvmarm@lists.linux.dev>; Wed, 23 Sep 2026 18:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.237
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790187936; cv=none; b=b0lNRn+eCaNrTxl/YquCTzcgDkPI9N0jyFTxkSWoo2hn+bIuIYXUMI7dca/EldsjUL0dEQLD/dnRLEQXPKn6jE9Hj2QtAxSuyC/ne8pbyR/KRMmpHhYBMDzO10A+3dSrq0tL9m1WqmPks9NBzGo+QxXtYbGgCuKOW71BAJo5yEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790187936; c=relaxed/simple;
	bh=eBhoSZys/skO8VhIcCPkCwRrgSwHPSgz35h6Fpfdqy0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rbRH3u1mNW9Jfgh1oIM7s43gMUkPdwxR4pfF8zQGaAg16DqYar3Uk87o5u2joLvUdq8H9jAhh3IshxautvF3AgtvrHgPH2t0u4qowScC95F/EvSn6UNEBgeS1EphawMtSPnvbe+NIvVW1Jc/Zh7TWeX2ZO0teYfSxTt08zkKrZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Z7ziTbHb; arc=none smtp.client-ip=91.218.175.237
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Z7ziTbHb"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=eBhoSZys/skO8VhIcCPkCwRrgSwHPSgz35h6Fpfdqy0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790187927; v=1; x=1790792727;
 b=Z7ziTbHbwmayRVpmrTaiBdgfDpBhH00EGT1KO+Z4+tytUOMJnSWd8kf1fjma/TCZ9n3EWN2V
 1RLmm5zFQn1KmYPi1A7szKSSkA9fWN02yFWmU9vJC2mujYbrUBz9JmXL6TfwCkcPE4ak/SzpmYo
 EOLBR3lmrYWLe/MDNUfJPmlI=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 609859165a1ed646;
	Wed, 23 Sep 2026 18:25:26 +0000
X-Mizu-Trace-ID: 609859165a1ed646
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-5b778bdb5b8so1055e87.1
        for <kvmarm@lists.linux.dev>; Wed, 23 Sep 2026 11:25:22 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwA1phVPapw6Dn2H5UbM7ogyQUJvEIqIxVz7Jmr2kjcx5/ZBI9G1iROVySqA0KeCzAk3y6QBKY=@lists.linux.dev
X-Gm-Message-State: AFuF++kZWMYl8Zc5ONe5wFxFhJ+6BHcc1AdW31zERoSaOBjOblmQgxZi
	eCQBNVTDs0O+bpZim+NG7WCGxCaNopJqW/+Ii7EfIfPUj3wr6p/up1QEs82N0iwTXAEv3vRTH2v
	10T0BfUjk1pg3bxtI9nx+1d9kkqSP1ejbA8RhC7Sb
X-Received: by 2002:a05:6512:2395:b0:5b8:b502:9a76 with SMTP id
 2adb3069b0e04-5b8de5cbe34mr31894e87.13.1790187921175; Wed, 23 Sep 2026
 11:25:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260923-kvm-arm-prefault-v4-0-d4b0b4dfa8c3@kernel.org> <20260923-kvm-arm-prefault-v4-2-d4b0b4dfa8c3@kernel.org>
In-Reply-To: <20260923-kvm-arm-prefault-v4-2-d4b0b4dfa8c3@kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Wed, 23 Sep 2026 19:24:45 +0100
X-Gmail-Original-Message-ID: <CA+EHjTzAK5HvyQaGQyzA8KckLj8hhg2g=ibXVxLhpMd4akvrOA@mail.gmail.com>
X-Gm-Features: AclHuK-LVBecQrvB6_SGAbPJR_XCf_HtzjMFK7HtibXH2JM7oY3kOspYw5Nd0jM
Message-ID: <CA+EHjTzAK5HvyQaGQyzA8KckLj8hhg2g=ibXVxLhpMd4akvrOA@mail.gmail.com>
Subject: Re: [PATCH v4 02/14] arm64: Add ESR fault helpers
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
> Add helper functions which operate directly on an ESR value rather than
> trying to access the register itself.
>
> These mirror equivalent KVM vCPU wrappers in kvm_emulate.h and allow those
> wrappers and KVM's stage-2 fault handling to operate on a plain ESR value.
>
> This is needed to later generate a synthetic fault for the stage-2 page
> table pre-faulting mechanism.
>
> No functional change intended.
>
> Reviewed-by: Oliver Upton <oupton@kernel.org>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad

> ---
>  arch/arm64/include/asm/esr.h         | 29 +++++++++++++++++++++++++++++
>  arch/arm64/include/asm/kvm_emulate.h | 10 ++++++++++
>  2 files changed, 39 insertions(+)
>
> diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
> index f816f5d77f1a..86756fc9bb5a 100644
> --- a/arch/arm64/include/asm/esr.h
> +++ b/arch/arm64/include/asm/esr.h
> @@ -437,6 +437,35 @@
>  #ifndef __ASSEMBLER__
>  #include <asm/types.h>
>
> +static __always_inline bool esr_trap_is_iabt(unsigned long esr)
> +{
> +       return ESR_ELx_EC(esr) == ESR_ELx_EC_IABT_LOW;
> +}
> +
> +/* Always check for S1PTW *before* using this. */
> +static __always_inline bool esr_dabt_is_write(unsigned long esr)
> +{
> +       return esr & ESR_ELx_WNR;
> +}
> +
> +static __always_inline bool esr_dabt_is_cm(unsigned long esr)
> +{
> +       return esr & ESR_ELx_CM;
> +}
> +
> +static __always_inline bool esr_abt_is_sea(unsigned long esr)
> +{
> +       switch (esr & ESR_ELx_FSC) {
> +       case ESR_ELx_FSC_EXTABT:
> +       case ESR_ELx_FSC_SEA_TTW(-1) ... ESR_ELx_FSC_SEA_TTW(3):
> +       case ESR_ELx_FSC_SECC:
> +       case ESR_ELx_FSC_SECC_TTW(-1) ... ESR_ELx_FSC_SECC_TTW(3):
> +               return true;
> +       default:
> +               return false;
> +       }
> +}
> +
>  static inline unsigned long esr_brk_comment(unsigned long esr)
>  {
>         return esr & ESR_ELx_BRK64_ISS_COMMENT_MASK;
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index a3c1928bdf74..654e8c1b4461 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -336,6 +336,16 @@ static __always_inline u64 kvm_vcpu_get_esr(const struct kvm_vcpu *vcpu)
>         return vcpu->arch.fault.esr_el2;
>  }
>
> +static __always_inline bool esr_abt_is_s1ptw(unsigned long esr)
> +{
> +       return esr & ESR_ELx_S1PTW;
> +}
> +
> +static __always_inline bool esr_abt_is_exec_fault(unsigned long esr)
> +{
> +       return esr_trap_is_iabt(esr) && !esr_abt_is_s1ptw(esr);
> +}
> +
>  static inline bool guest_hyp_wfx_traps_enabled(const struct kvm_vcpu *vcpu)
>  {
>         u64 esr = kvm_vcpu_get_esr(vcpu);
>
> --
> 2.55.0
>
