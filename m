Return-Path: <SRS0=aIiX=IH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 552C2C433E0
	for <kvmarm@archiver.kernel.org>; Tue,  9 Mar 2021 14:05:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9D4A0651C7
	for <kvmarm@archiver.kernel.org>; Tue,  9 Mar 2021 14:05:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9D4A0651C7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2BFD14B399;
	Tue,  9 Mar 2021 09:05:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HuW-6RhmIPsM; Tue,  9 Mar 2021 09:05:38 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7CA924B36E;
	Tue,  9 Mar 2021 09:05:38 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3D7854B365
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Mar 2021 09:05:37 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PcETA-Ei6BbU for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Mar 2021 09:05:35 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 343474B2C9
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Mar 2021 09:05:35 -0500 (EST)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5F345651BC;
 Tue,  9 Mar 2021 14:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1615298733;
 bh=TXFyWZPHheQTfjIK2kd6LjPJ24kLhlnsvHPduOP6/pU=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=ljqk/HLJGPqAhnbVLxuJBVYmpA3a/gpakTeq2jSnDfJ4ODGdfxPGQoZkLaRF8sLkX
 Z9LdSoLOdtnXDqR/YOsaNmyVl/a9Gm2EpeYcDjd2aKANAEDAz64S491ZBim6sE9dBf
 0wNnv/yVQBXxniz3XssTBHpJvwPZlZbu6cz4ELcWDx2sBT7MnVLvr1JJGfBNr0hb4S
 xEz6zMdOtFIVEZul/a/vuR7ctRHq5TVbcAo/Ds5L9eReHIYgYFIRRgfxXHbQbWflkQ
 CtG6CXy7+VFTozFwYVmqvfuLSm97ATpF+MEqLyZDRHG+75XuXt3BEnBAV1RfIhtNR2
 58HMKLQGgb50w==
Date: Tue, 9 Mar 2021 14:05:28 +0000
From: Will Deacon <will@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH] arm64/mm: Fix __enable_mmu() for new TGRAN range values
Message-ID: <20210309140527.GB28395@willie-the-truck>
References: <1614954969-14338-1-git-send-email-anshuman.khandual@arm.com>
 <8735x5zozr.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <8735x5zozr.wl-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: linux-efi@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>, linux-kernel@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On Mon, Mar 08, 2021 at 02:42:00PM +0000, Marc Zyngier wrote:
> On Fri, 05 Mar 2021 14:36:09 +0000,
> Anshuman Khandual <anshuman.khandual@arm.com> wrote:
> > -	switch (cpuid_feature_extract_unsigned_field(mmfr0, tgran_2)) {
> > -	default:
> > -	case 1:
> > +	tgran_2 = cpuid_feature_extract_unsigned_field(mmfr0, tgran_2_shift);
> > +	if (tgran_2 == ID_AA64MMFR0_TGRAN_2_SUPPORTED_NONE) {
> >  		kvm_err("PAGE_SIZE not supported at Stage-2, giving up\n");
> >  		return -EINVAL;
> > -	case 0:
> > +	} else if (tgran_2 == ID_AA64MMFR0_TGRAN_2_SUPPORTED_DEFAULT) {
> >  		kvm_debug("PAGE_SIZE supported at Stage-2 (default)\n");
> > -		break;
> > -	case 2:
> > +	} else if (tgran_2 >= ID_AA64MMFR0_TGRAN_2_SUPPORTED_MIN &&
> > +		   tgran_2 <= ID_AA64MMFR0_TGRAN_2_SUPPORTED_MAX) {
> >  		kvm_debug("PAGE_SIZE supported at Stage-2 (advertised)\n");
> > -		break;
> > +	} else {
> > +		kvm_err("Unsupported value, giving up\n");
> > +		return -EINVAL;
> 
> nit: this doesn't say *what* value is unsupported, and I really
> preferred the switch-case version, such as this:
> 
> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> index 1f22b36a0eff..d267e4b1aec6 100644
> --- a/arch/arm64/kvm/reset.c
> +++ b/arch/arm64/kvm/reset.c
> @@ -312,15 +312,18 @@ int kvm_set_ipa_limit(void)
>  
>  	switch (cpuid_feature_extract_unsigned_field(mmfr0, tgran_2)) {
>  	default:
> -	case 1:
> +	case ID_AA64MMFR0_TGRAN_2_SUPPORTED_NONE:
>  		kvm_err("PAGE_SIZE not supported at Stage-2, giving up\n");
>  		return -EINVAL;
> -	case 0:
> +	case ID_AA64MMFR0_TGRAN_2_SUPPORTED_DEFAULT:
>  		kvm_debug("PAGE_SIZE supported at Stage-2 (default)\n");
>  		break;
> -	case 2:
> +	case ID_AA64MMFR0_TGRAN_2_SUPPORTED_MIN ... ID_AA64MMFR0_TGRAN_2_SUPPORTED_MAX:
>  		kvm_debug("PAGE_SIZE supported at Stage-2 (advertised)\n");
>  		break;
> +	default:
> +		kvm_err("Unsupported value for TGRAN_2, giving up\n");
> +		return -EINVAL;
>  	}
>  
>  	kvm_ipa_limit = id_aa64mmfr0_parange_to_phys_shift(parange);
> 
> 
> Otherwise:
> 
> Acked-by: Marc Zyngier <maz@kernel.org>

Anshuman -- please can you spin a v2 with the switch syntax as suggested
above by Marc?

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
