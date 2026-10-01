Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 047CA1A6822;
	Thu,  1 Oct 2026 16:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790872743; cv=none; b=hc/anek47WPPrv6TI0vOQTrDnd7N0LMOBHPrPwdeNcQCezU5uvKZY+QqhCv58n5M2hTOep/u5N46SnLfekSkHWcL5KDckY5YxxrPbzQ095BhXGESak02ChJgBUe+Um277/WCnGVcqAR1J6D3gdnopui0cxY9+fkX+o8dWDvPFg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790872743; c=relaxed/simple;
	bh=atzKYEkSNf/oEYXZJEAEHrfV7pM0xz0gQsVLLJrHEgQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WzZ194Ra5Gxi1k7/IK++jtQnn1xVR2ecPWhPAU8oF/f1W3w/r5asBHQYIkF9FHpsPv2z2NSPGVV/xOYqRGQnPu6ySM5IeCfV5Q+SRd1SdZUJmrmknFDQs37LxCIx2oUSwWeh7S0uyk6AAvDjvNEYvDeeYa6Jx4JjMKqPP92q75Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ih38u32l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ih38u32l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 407411F000FF;
	Thu,  1 Oct 2026 16:38:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790872741;
	bh=53qEhBkxOk8Rhw/laCIFBAvn8/m0XtPcvZMYs9C6rlQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ih38u32lPiJYlaJAURPfglfqwPvJJxhtf5w7W7gSfONpcFZzZDJYU6r4nW3CPdmEU
	 GqoXWL8her2J6bcMV8UXzEiEVVlsBpoLP5nByHKacD7wwS26XFQKugqsRKZIFEwVmj
	 JA+xslQaQC1Nbjjt8qzVnPE2bfC9L+z40rHufLphSQVcnGSMrFZtVtthpS5tyd+gFo
	 eNHHwIYCTZloAMKT8sbG25on4W+Cqebz7aZblobreWAHexQC7WiPCBQrziapwvFRGu
	 kjQHnrb96C9aAAslyi6KvHaZlrD9RoddsdxJZtn4H/ENIux8KW4XPqPPetdjdy2xW7
	 KfyM51MqwEu/g==
Date: Thu, 1 Oct 2026 17:38:54 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Mark Brown <broonie@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Shuah Khan <shuah@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Fuad Tabba <fuad.tabba@linux.dev>, Peter Maydell <peter.maydell@linaro.org>, 
	Leonardo Bras <leo.bras@arm.com>, Wei-Lin Chang <weilin.chang@arm.com>, 
	Yao Yuan <yaoyuan@linux.alibaba.com>, linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
	kvmarm@lists.linux.dev, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v21 12/15] KVM: selftests: arm64: Add GCS to set_id_regs
Message-ID: <ar6MIFW2vfM893yd@gremlin>
References: <20260930-arm64-gcs-v21-0-3556644cd927@kernel.org>
 <20260930-arm64-gcs-v21-12-3556644cd927@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260930-arm64-gcs-v21-12-3556644cd927@kernel.org>

On Wed, Sep 30, 2026 at 10:48:22PM +0100, Mark Brown wrote:
> Now that GCS is configurable via the ID registers update set_id_regs to
> cover ID_AA64PFR1_EL1.GCS.

Should maybe also mention adding the GCS-without-S1PIE test?

>
> Signed-off-by: Mark Brown <broonie@kernel.org>

Looks obviously correct (TM) to me too so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  tools/testing/selftests/kvm/arm64/set_id_regs.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/tools/testing/selftests/kvm/arm64/set_id_regs.c b/tools/testing/selftests/kvm/arm64/set_id_regs.c
> index cb5e6358c59c..9db8516748cc 100644
> --- a/tools/testing/selftests/kvm/arm64/set_id_regs.c
> +++ b/tools/testing/selftests/kvm/arm64/set_id_regs.c
> @@ -154,6 +154,7 @@ static const struct reg_ftr_bits ftr_id_aa64pfr0_el1[] = {
>
>  static const struct reg_ftr_bits ftr_id_aa64pfr1_el1[] = {
>  	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64PFR1_EL1, DF2, 0),
> +	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64PFR1_EL1, GCS, 0),
>  	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64PFR1_EL1, CSV2_frac, 0),
>  	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64PFR1_EL1, SSBS, ID_AA64PFR1_EL1_SSBS_NI),
>  	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64PFR1_EL1, BT, 0),
> @@ -818,6 +819,12 @@ struct reg_ftr_val {
>  	  .mask = r ## _ ## f ## _MASK,				\
>  	  .val = (r ## _ ## f ## _ ## v  << r ## _ ## f ## _SHIFT) }
>
> +static const struct reg_ftr_val gcs_no_s1pie[] = {
> +	REG_FTR_VAL(ID_AA64PFR1_EL1, GCS, IMP),
> +	REG_FTR_VAL(ID_AA64MMFR3_EL1, S1PIE, NI),
> +	{ }
> +};
> +
>  static const struct reg_ftr_val s1pie_no_tcr2[] = {
>  	REG_FTR_VAL(ID_AA64MMFR3_EL1, TCRX, NI),
>  	REG_FTR_VAL(ID_AA64MMFR3_EL1, S1PIE, IMP),
> @@ -836,6 +843,7 @@ struct ftr_config {
>  };
>
>  static const struct ftr_config invalid_configs[] = {
> +	{ .name = "GCS without S1PIE", .regs = gcs_no_s1pie },
>  	{ .name = "S1PIE without TCRX", .regs = s1pie_no_tcr2 },
>  	{ .name = "S1POE without TCRX", .regs = s1poe_no_tcr2 },
>  };
>
> --
> 2.47.3
>
>

--
Cheers, Lorenzo
