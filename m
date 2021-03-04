Return-Path: <SRS0=dAAB=IC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6986DC433DB
	for <kvmarm@archiver.kernel.org>; Thu,  4 Mar 2021 19:39:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CECCC64F64
	for <kvmarm@archiver.kernel.org>; Thu,  4 Mar 2021 19:39:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CECCC64F64
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 13A1C4B65D;
	Thu,  4 Mar 2021 14:39:17 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JfyldAShB+sw; Thu,  4 Mar 2021 14:39:15 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E04914B664;
	Thu,  4 Mar 2021 14:39:15 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EFFFF4B65F
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Mar 2021 14:39:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Uvz8gK8RN2tC for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Mar 2021 14:39:14 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 07E444B65D
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Mar 2021 14:39:14 -0500 (EST)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3C5D464F60;
 Thu,  4 Mar 2021 19:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1614886753;
 bh=aI8BOthiv/XoVAjzXsTcAVCGuPJu3RX8bBEOeiMMP9o=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=Vp0R4MR5XPFCy4evMVY9Vhpn4ovFcqqoWie42ktox8X+fmC5jgR2XEXc0BeOWRA6H
 E8wvUpqIm13NOUVJr2L98dKT7kw7SEOx7/N/EECcqV180dE8pNuIR/ZiwapF2Yl5zk
 IEg+uIjwUjn2SyFAd4ABLrOb7ZqYEguwYk9RHqXGZ5+o2DNNPYclFMVZFhH8q0qGRc
 s/VE2a55ukN3Khe20GuGf2NADpo5cS2lI6HSClJLYGYeJyb1BgerxfT58ynWBYqZB4
 ZsouCxcFwBO2R2M+9nlJgsHJh4oT2VuNJIp92oatIqzDM/hlT4OmFCdBNuOosI+4i+
 Guz9+bCddyRww==
Date: Thu, 4 Mar 2021 19:39:07 +0000
From: Will Deacon <will@kernel.org>
To: Quentin Perret <qperret@google.com>
Subject: Re: [PATCH v3 22/32] KVM: arm64: Refactor __populate_fault_info()
Message-ID: <20210304193906.GB21950@willie-the-truck>
References: <20210302150002.3685113-1-qperret@google.com>
 <20210302150002.3685113-23-qperret@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210302150002.3685113-23-qperret@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: android-kvm@google.com, catalin.marinas@arm.com, mate.toth-pal@arm.com,
 seanjc@google.com, tabba@google.com, linux-kernel@vger.kernel.org,
 robh+dt@kernel.org, linux-arm-kernel@lists.infradead.org, maz@kernel.org,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu
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

On Tue, Mar 02, 2021 at 02:59:52PM +0000, Quentin Perret wrote:
> Refactor __populate_fault_info() to introduce __get_fault_info() which
> will be used once the host is wrapped in a stage 2.
> 
> Signed-off-by: Quentin Perret <qperret@google.com>
> ---
>  arch/arm64/kvm/hyp/include/hyp/switch.h | 37 ++++++++++++++-----------
>  1 file changed, 21 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
> index 6c1f51f25eb3..1f017c9851bb 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> @@ -160,19 +160,9 @@ static inline bool __translate_far_to_hpfar(u64 far, u64 *hpfar)
>  	return true;
>  }
>  
> -static inline bool __populate_fault_info(struct kvm_vcpu *vcpu)
> +static inline bool __get_fault_info(u64 esr, struct kvm_vcpu_fault_info *fault)
>  {
> -	u8 ec;
> -	u64 esr;
> -	u64 hpfar, far;
> -
> -	esr = vcpu->arch.fault.esr_el2;
> -	ec = ESR_ELx_EC(esr);
> -
> -	if (ec != ESR_ELx_EC_DABT_LOW && ec != ESR_ELx_EC_IABT_LOW)
> -		return true;
> -
> -	far = read_sysreg_el2(SYS_FAR);
> +	fault->far_el2 = read_sysreg_el2(SYS_FAR);
>  
>  	/*
>  	 * The HPFAR can be invalid if the stage 2 fault did not
> @@ -188,14 +178,29 @@ static inline bool __populate_fault_info(struct kvm_vcpu *vcpu)
>  	if (!(esr & ESR_ELx_S1PTW) &&
>  	    (cpus_have_final_cap(ARM64_WORKAROUND_834220) ||
>  	     (esr & ESR_ELx_FSC_TYPE) == FSC_PERM)) {
> -		if (!__translate_far_to_hpfar(far, &hpfar))
> +		if (!__translate_far_to_hpfar(fault->far_el2, &fault->hpfar_el2))
>  			return false;
>  	} else {
> -		hpfar = read_sysreg(hpfar_el2);
> +		fault->hpfar_el2 = read_sysreg(hpfar_el2);
>  	}
>  
> -	vcpu->arch.fault.far_el2 = far;
> -	vcpu->arch.fault.hpfar_el2 = hpfar;
> +	return true;
> +}
> +
> +static inline bool __populate_fault_info(struct kvm_vcpu *vcpu)
> +{
> +	u8 ec;
> +	u64 esr;
> +
> +	esr = vcpu->arch.fault.esr_el2;
> +	ec = ESR_ELx_EC(esr);
> +
> +	if (ec != ESR_ELx_EC_DABT_LOW && ec != ESR_ELx_EC_IABT_LOW)
> +		return true;
> +
> +	if (!__get_fault_info(esr, &vcpu->arch.fault))
> +		return false;
> +
>  	return true;

Just return __get_fault_info(esr, &vcpu->arch.fault); here.

With that:

Acked-by: Will Deacon <will@kernel.org>

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
