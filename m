Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B15E93DDAFD;
	Thu,  1 Oct 2026 16:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790872916; cv=none; b=Zi9xg5etBWygO9rjR/Zn2LuheVALYVHmGDOsoTsqki3bUt7/woPP4Z8R0OsK6TzGHTIKLiyqElAtbLaw2+LFvQievN+KYoemPklRkqMQacgb4+M05geGMnoT/vxM0d7e9OzpW0L4ftXK+baR1aVswabnaPl34tAeS2ozn9/xoqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790872916; c=relaxed/simple;
	bh=AY9iaZGWyYRkUc9XubczlcTYFN/80sMzL04PqdMfZuo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YOaoJ2IIFHZJZWWlpICwru7TYpdIPjew/Ogdi3Ic+rlXI1f0cqT6YpgPMD9Olm4MJP2eeR+LVmISI7kkWl1GuWtFIl9Mkyj9y91pMOzYgWu2Eck5oidq0+MSk04BZzkH5flQCp9boaH999zyPrqQJJD1l4SxeTrDaJTLWSxbJu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PSaAw3rp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PSaAw3rp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBDC31F000FF;
	Thu,  1 Oct 2026 16:41:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790872915;
	bh=on88P7izvphnCHCDc8e1Yaww3dTpsQnTne0sTtDZayk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PSaAw3rp4iuMnLC2doiY087YMDwz30kvUtFgDv8SFiWd82JL1XyBPYwZQH4D9szjz
	 869IgWaH459u48KKhV/iM/v5TVMxn63Yz6MevE5LEgk+2eUJfjY/Ni5RUaZQ4To0us
	 vlIbxDQTENO0/kaNv0dpPT9XQhTqRWFGahGNcs6fSoqMzEcrl4tvLeVVfESRc0HjFj
	 hYp6rGGOMLx0sqDqvUwS8SP17rXI8SsMhypDqJDyOyDeVDVkoW2rMLQjd5J7qH1dD1
	 i1DAoiZ4MomHCbTeEE4Bgy6JCl7PEhMuMxM4Plp6VATs471uvz8AAEYPP2lZareaGa
	 JLRKPdwYS/h0g==
Date: Thu, 1 Oct 2026 17:41:48 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Mark Brown <broonie@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Shuah Khan <shuah@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Fuad Tabba <fuad.tabba@linux.dev>, Peter Maydell <peter.maydell@linaro.org>, 
	Leonardo Bras <leo.bras@arm.com>, Wei-Lin Chang <weilin.chang@arm.com>, 
	Yao Yuan <yaoyuan@linux.alibaba.com>, linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
	kvmarm@lists.linux.dev, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v21 13/15] KVM: selftests: arm64: Only restore SPSR_EL1
 and ELR_EL1 if they change
Message-ID: <ar6M4AqGoSUb1dkq@gremlin>
References: <20260930-arm64-gcs-v21-0-3556644cd927@kernel.org>
 <20260930-arm64-gcs-v21-13-3556644cd927@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260930-arm64-gcs-v21-13-3556644cd927@kernel.org>

On Wed, Sep 30, 2026 at 10:48:23PM +0100, Mark Brown wrote:
> When EXLOCK is enabled for ELx writes to SPSR_ELx and ELR_ELx generate
> GCS exceptions. Currently the selftest helpers unconditionally reload the
> saved values for these registers regardless of if the handler didn't change
> them. This gets in the way of EXLOCK testing, making it hard to generate
> contexts which will generate an invalid ERET since we never get as far as
> doing an exception return while EXLOCK is enabled.

Sounds reasonable.

>
> In order to facilitate testing of nested virtualisation emulation of EXLOCK
> change our reloads into read/modify/write cycles, suppressing the writes
> when they would not change the value in the register.

Also sounds sensible.

>
> Reviewed-by: Leonardo Bras <leo.bras@arm.com>
> Signed-off-by: Mark Brown <broonie@kernel.org>

Also looks obviously correct (TM) to me so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  tools/testing/selftests/kvm/lib/arm64/handlers.S | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>
> diff --git a/tools/testing/selftests/kvm/lib/arm64/handlers.S b/tools/testing/selftests/kvm/lib/arm64/handlers.S
> index 0e443eadfac6..367c22d61cba 100644
> --- a/tools/testing/selftests/kvm/lib/arm64/handlers.S
> +++ b/tools/testing/selftests/kvm/lib/arm64/handlers.S
> @@ -33,8 +33,18 @@
>
>  .macro restore_registers
>  	ldp	x1, x2, [sp, #16 * 16] /* PC, PSTATE */
> +
> +	/* Suppress redundant writes to support GCS exception lock testing */
> +	mrs	x3, elr_el1
> +	cmp	x1, x3
> +	beq	.Lskip_elr_\@
>  	msr	elr_el1, x1
> +.Lskip_elr_\@:
> +	mrs	x3, spsr_el1
> +	cmp	x2, x3
> +	beq	.Lskip_spsr_\@

Even as an arm64 assembly novice I can see what this is doing :)

>  	msr	spsr_el1, x2
> +.Lskip_spsr_\@:
>
>  	/* sp is not restored */
>  	ldp	x30, xzr, [sp, #16 * 15] /* x30, SP */
>
> --
> 2.47.3
>
>

--
Cheers, Lorenzo
