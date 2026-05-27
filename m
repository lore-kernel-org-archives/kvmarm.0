Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BE6A3D25BC
	for <kvmarm@lists.linux.dev>; Wed, 27 May 2026 10:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779876970; cv=none; b=TQ4x5pKwvQrhMjdgZ7mrnClOcb8linnmoAhNT+RDvxZmK/1fSqOJQJK9znm/kU2OCfwKK4oNqicGir3e8zuS1+2KeCE+N8BE3Dw2T0kGMNF4wGRzo+mxuChzNIOPCw3USUK3V/66OfLkzlTL0vfqBt93m9/Jkkuz6Wy+VcrDdBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779876970; c=relaxed/simple;
	bh=+hL59vccO1ks9MzdM5CR38jiGk+XWT0SUi7IA3xkX5w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QGkLWBN4Byewt3WGPPNHeODBF2aha1A82Lj1hXNrWuBBGhOedV4A6Eh0WEel4nGb1e4eh6QIXs3NHpYXORmsJsK6UyVGXNO1f0hjb7bV7rhPSQcQC3ltV68iMvN8iBSpV3cGy+i5SEap03a4b9bupmAdoTmUUSKdvXew0HHwYnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=KiGG6vSz; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="KiGG6vSz"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7CBB2169C;
	Wed, 27 May 2026 03:16:00 -0700 (PDT)
Received: from [10.1.38.169] (e121487-lin.cambridge.arm.com [10.1.38.169])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 789273F7D8;
	Wed, 27 May 2026 03:16:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779876965; bh=+hL59vccO1ks9MzdM5CR38jiGk+XWT0SUi7IA3xkX5w=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=KiGG6vSz6PaoZdrTGFxpjyETQnPYOLshZ9pb7fUxb1O6qXXA0g8B8N8JwM6dB9Qe/
	 whiJ1iSAdbl30B1eiRbE9oZmBc3+d0gb8E4G6I9kbB6Ul7wDPKV3P8h6T2jYCGYDs/
	 W5pESKAwp7D0f4Popu7KQ7LkaqLQZwqG3F+trREo=
Message-ID: <7e7de0e4-2bc8-4391-82ff-23a0063f513d@arm.com>
Date: Wed, 27 May 2026 11:16:01 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/18] KVM: arm64: Don't override FFR save/restore
 argument
To: Mark Rutland <mark.rutland@arm.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Cc: broonie@kernel.org, catalin.marinas@arm.com, james.morse@arm.com,
 maz@kernel.org, oupton@kernel.org, tabba@google.com, will@kernel.org
References: <20260521132556.584676-1-mark.rutland@arm.com>
 <20260521132556.584676-3-mark.rutland@arm.com>
Content-Language: en-GB
From: Vladimir Murzin <vladimir.murzin@arm.com>
In-Reply-To: <20260521132556.584676-3-mark.rutland@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/21/26 14:25, Mark Rutland wrote:
> The __sve_save_state() and __sve_restore_state() functions take a
> parameter describing whether to save/restore the FFR, but both functions
> silently override this with '1'. This has always been benign (and
> callers have all passed 'true' since the parameter was introduced), but
> clearly this is not intentional.
> 
> Historically, the functions always saved/restored the FFR, and there was
> no parameter to control this.
> 
> In v5.16, the sve_save and sve_load assembly macros used by
> __sve_save_state() and __sve_restore_state() were changed to make
> saving/restoring FFR optional. The implementations of __sve_save_state()
> and __sve_restore_state() were changed to pass '1' to their respective
> macros, and the prototypes of __sve_save_state() and
> __sve_restore_state() were unchanged. See commit:
> 
>   9f5848665788 ("arm64/sve: Make access to FFR optional")
> 
> In v6.10, the prototypes of __sve_save_state() and __sve_restore_state()
> were changed to add 'save_ffr' and 'restore_ffr' parameters
> respectively, but the implementations were not changed to stop passing 1
> to their respective macros. All callers were changed to pass 'true' to
> __sve_save_state() and __sve_restore_state(). See commit:
> 
>   45f4ea9bcfe9 ("KVM: arm64: Fix prototype for __sve_save_state/__sve_restore_state")
> 
> This is all benign, but clearly unintentional, and it gets in the way of
> cleaning up the FPSIMD/SVE/SME code. Remove the unnecessary overriding.
> 
> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Fuad Tabba <tabba@google.com>
> Cc: James Morse <james.morse@arm.com>
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: Oliver Upton <oupton@kernel.org>
> Cc: Will Deacon <will@kernel.org>
> ---
>  arch/arm64/kvm/hyp/fpsimd.S | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/fpsimd.S b/arch/arm64/kvm/hyp/fpsimd.S
> index e950875e31cee..6e16cbfc5df27 100644
> --- a/arch/arm64/kvm/hyp/fpsimd.S
> +++ b/arch/arm64/kvm/hyp/fpsimd.S
> @@ -21,13 +21,11 @@ SYM_FUNC_START(__fpsimd_restore_state)
>  SYM_FUNC_END(__fpsimd_restore_state)
>  
>  SYM_FUNC_START(__sve_restore_state)
> -	mov	x2, #1
>  	sve_load 0, x1, x2, 3
>  	ret
>  SYM_FUNC_END(__sve_restore_state)
>  
>  SYM_FUNC_START(__sve_save_state)
> -	mov	x2, #1
>  	sve_save 0, x1, x2, 3
>  	ret
>  SYM_FUNC_END(__sve_save_state)
> -- 2.30.2
> 

FWIW,

Reviewed-by: Vladimir Murzin <vladimir.murzin@arm.com>
