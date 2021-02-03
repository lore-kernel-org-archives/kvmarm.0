Return-Path: <SRS0=xLVY=HF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71EACC433E0
	for <kvmarm@archiver.kernel.org>; Wed,  3 Feb 2021 15:54:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BFCD464F8C
	for <kvmarm@archiver.kernel.org>; Wed,  3 Feb 2021 15:54:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BFCD464F8C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3C71E4B28B;
	Wed,  3 Feb 2021 10:54:06 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 849BMP7h1pF3; Wed,  3 Feb 2021 10:54:05 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 26B324B274;
	Wed,  3 Feb 2021 10:54:05 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C4CF94B274
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Feb 2021 10:54:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VZrZVujnYH7N for <kvmarm@lists.cs.columbia.edu>;
 Wed,  3 Feb 2021 10:54:02 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 93E624B222
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Feb 2021 10:54:02 -0500 (EST)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 71DCF64F55;
 Wed,  3 Feb 2021 15:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1612367641;
 bh=LboLHM+6kIOh+gRaFnxe+9BKVjr4IMqy2/wdrtr8YPM=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=dIc9iPjjDgDhe3A+EVOFewT1KzjihGTkkVlbtTGWiLbdsiMbRFH0KhRIz9uZyia+f
 z93MgcrhCcxUQW725BBor3g+fQMct+Ns9J1l1dOY9ipYK+E8rvrYvuhuS4lbKQEKXz
 WEizc349XENeMZw90ZJej3JfWzD40pwKEhEIxmqrWpnvxCJYqeAVs4TCp3+k5ogpIy
 skemPMst7d2Z+O6clupBCwPXsNNZQcPWpVXw1b05kHptOzLsL+sX8ygfoWZupSUnWB
 HzwOwX9AGaub0Ao697Dy1MzA7k1CBwREMIdS5S0wFhurodwQNLbhTBjQvZ1yuNqGFr
 ufDHaSbamHi0w==
Date: Wed, 3 Feb 2021 15:53:54 +0000
From: Will Deacon <will@kernel.org>
To: Quentin Perret <qperret@google.com>
Subject: Re: [RFC PATCH v2 21/26] KVM: arm64: Refactor kvm_arm_setup_stage2()
Message-ID: <20210203155354.GE18974@willie-the-truck>
References: <20210108121524.656872-1-qperret@google.com>
 <20210108121524.656872-22-qperret@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210108121524.656872-22-qperret@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: devicetree@vger.kernel.org, kernel-team@android.com, android-kvm@google.com,
 Catalin Marinas <catalin.marinas@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
 linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
 Frank Rowand <frowand.list@gmail.com>, kvmarm@lists.cs.columbia.edu
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

On Fri, Jan 08, 2021 at 12:15:19PM +0000, Quentin Perret wrote:
> In order to re-use some of the stage 2 setup at EL2, factor parts of
> kvm_arm_setup_stage2() out into static inline functions.
> 
> No functional change intended.
> 
> Signed-off-by: Quentin Perret <qperret@google.com>
> ---
>  arch/arm64/include/asm/kvm_mmu.h | 48 ++++++++++++++++++++++++++++++++
>  arch/arm64/kvm/reset.c           | 42 +++-------------------------
>  2 files changed, 52 insertions(+), 38 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
> index 662f0415344e..83b4c5cf4768 100644
> --- a/arch/arm64/include/asm/kvm_mmu.h
> +++ b/arch/arm64/include/asm/kvm_mmu.h
> @@ -280,6 +280,54 @@ static inline int kvm_write_guest_lock(struct kvm *kvm, gpa_t gpa,
>  	return ret;
>  }
>  
> +static inline u64 kvm_get_parange(u64 mmfr0)
> +{
> +	u64 parange = cpuid_feature_extract_unsigned_field(mmfr0,
> +				ID_AA64MMFR0_PARANGE_SHIFT);
> +	if (parange > ID_AA64MMFR0_PARANGE_MAX)
> +		parange = ID_AA64MMFR0_PARANGE_MAX;
> +
> +	return parange;
> +}
> +
> +/*
> + * The VTCR value is common across all the physical CPUs on the system.
> + * We use system wide sanitised values to fill in different fields,
> + * except for Hardware Management of Access Flags. HA Flag is set
> + * unconditionally on all CPUs, as it is safe to run with or without
> + * the feature and the bit is RES0 on CPUs that don't support it.
> + */
> +static inline u64 kvm_get_vtcr(u64 mmfr0, u64 mmfr1, u32 phys_shift)
> +{
> +	u64 vtcr = VTCR_EL2_FLAGS;
> +	u8 lvls;
> +
> +	vtcr |= kvm_get_parange(mmfr0) << VTCR_EL2_PS_SHIFT;
> +	vtcr |= VTCR_EL2_T0SZ(phys_shift);
> +	/*
> +	 * Use a minimum 2 level page table to prevent splitting
> +	 * host PMD huge pages at stage2.
> +	 */
> +	lvls = stage2_pgtable_levels(phys_shift);
> +	if (lvls < 2)
> +		lvls = 2;
> +	vtcr |= VTCR_EL2_LVLS_TO_SL0(lvls);
> +
> +	/*
> +	 * Enable the Hardware Access Flag management, unconditionally
> +	 * on all CPUs. The features is RES0 on CPUs without the support
> +	 * and must be ignored by the CPUs.
> +	 */
> +	vtcr |= VTCR_EL2_HA;
> +
> +	/* Set the vmid bits */
> +	vtcr |= (get_vmid_bits(mmfr1) == 16) ?
> +		VTCR_EL2_VS_16BIT :
> +		VTCR_EL2_VS_8BIT;
> +
> +	return vtcr;
> +}

Although I think this is functionally fine, I think it's unusual to see
large "static inline" functions like this in shared header files. One
alternative approach would be to follow the example of
kernel/locking/qspinlock_paravirt.h, where the header is guarded in such a
way that is only ever included by kernel/locking/qspinlock.c and therefore
doesn't need the "inline" at all. That separation really helps, I think.

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
