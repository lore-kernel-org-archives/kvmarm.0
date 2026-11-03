Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793722048;
	b=WN4bIw+8QuB4ewm2tRXbAighDW8PMzQRLA3KHXxFpLq7tSns9dtLzUVGy9cEJedE1xik
	 nSSYp7heB3ehR6xtNgP+/14B16IVVDSb8DedR2fd++PCCNUZHtcweBUjz8XiuQtZ8d4x9
	 stdu9G7EfyJR5o+jboalWK07nUGtzYQPct6TUiy2SF1z0Kv+09IwXh1hA2GV8/YccQln/
	 JnviROOqoq6iLyflCcwfQ+UzbUX6u8yBsrNfAV67YBcaOV3tWNIBgChENHcL5wK2dwel8
	 tI5WIQvnHvTxm1IfqdMwbg/7wpgsWz7daL4vGxAY0Q7PUrSjRkV8eenwLXwfujQn9mA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793722048;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=Lurr83DY7RNGEQa9JPmFXFrFx43jfa0KXzqU4qll3xw=;
	b=nilL6v15g+KcVqcBOzUihemBSN71YuY0NKguta/jEYVvmjbuRMOmgmE1JzLJhTh/egi6
	 P2f3PSa8zMTNkY+lpisT/4uS3efpORX6k94huM7a9PKG9LD8YAMI9M6vPS0w168LYv7Oe
	 BF/XwPbIs0FFfjmDu7oLLtAyniC8GaLTP7Wt2MzH7QyndIYTVxl8UFDaX0kYaMUAQlKgf
	 Upo/oW3qmMuUlaro2QwzuooLxSPKPFidnkDVG1yS5/TxTeVt0IN1vbT3JB10HkjQyMJtI
	 s8HwOvkQXrc5pRnTpeNy8LxGY8vDSi43aSRaHnW8abqOLcw6rPrvD/EPrqUwM0vR93Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=Ek12x9Jr;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 666C4606A327
	for <kvmarm@lists.linux.dev>; Tue,  3 Nov 2026 16:07:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 666C4606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=Ek12x9Jr
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7C33C1650;
	Tue,  3 Nov 2026 08:07:23 -0800 (PST)
Received: from e143914.arm.com (e143914.arm.com [10.2.213.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 774093F628;
	Tue,  3 Nov 2026 08:07:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793722046; bh=PVc5o0niP5HBPsCk9R8APTQWF1tcjeU1GcGP9Gzx5V8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ek12x9JrrlcTlhBaTGEaKcSuQkNgsDRJmN9hRSDjhphoNKVeNbKin9umpGZ/gh/up
	 ViF8aaEDJkOcCRHnFjtYE/8SM2N0S7OkhQ0+6Hipc+DtuvZPe4qKRFl6MF8glw38zH
	 a3KFNBjnO16m65vuyZIcZVHxm2CYHcTJNmMQ3VQc=
Date: Tue, 3 Nov 2026 16:07:20 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: Will Deacon <will@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH] KVM: arm64: Use S1E1A when Stage-1 PIE is supported
Message-ID: <auoGuA4VoOzciFTp@e143914.arm.com>
References: <20261103133540.29566-1-will@kernel.org>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261103133540.29566-1-will@kernel.org>

On Tue, Nov 03, 2026 at 01:35:39PM +0000, Will Deacon wrote:
> On a system with stage-1 PIE, a guest can try to execute from an
> execute-only mapping at stage-1 but trigger a permission fault at
> stage-2 if the stage-2 mapping is execute-never.
> 
> In this case, the EL2 permission fault handler will attempt to translate
> the faulting VA using an AT S1E1R operation, which will fail due to the
> lack of read permission at stage-1. We will then return to the guest and
> take the exact same fault the next time around.
> 
> Similarly to commit 55f4b215fb60 ("KVM: arm64: use `at s1e1a` for POE"),
> use the S1E1A operation to bypass stage-1 permission checks when
> obtaining the IPA for a stage-2 permission fault. Like FEAT_S1POE,
> FEAT_S1PIE implies FEAT_ATS1A, so extend the existing AT invocation in
> __translate_far_to_hpfar() to use the permission-bypassing variant when
> S1PIE is implemented.
> 
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Oliver Upton <oupton@kernel.org>
> Cc: Fuad Tabba <fuad.tabba@linux.dev>
> Cc: Joey Gouly <joey.gouly@arm.com>
> Cc: Steffen Eiden <seiden@linux.ibm.com>
> Cc: Ard Biesheuvel <ardb@kernel.org>
> Signed-off-by: Will Deacon <will@kernel.org>

This makes sense to me.

Reviewed-by: Joey Gouly <joey.gouly@arm.com>

Thanks,
Joey

> ---
> 
> I've been debugging an external report of a failure in Android related
> to S1PIE. The symptoms match what I would expect from this issue and
> this patch has been reported to fix the problem, but I don't have enough
> information to know for sure that my analysis is correct. I've had to
> piece things together based on partial information and bits of logs.
> 
>  arch/arm64/include/asm/cpufeature.h    | 5 +++++
>  arch/arm64/kvm/hyp/include/hyp/fault.h | 5 +++--
>  2 files changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
> index 4f04ad82ea34..f05ace660fa2 100644
> --- a/arch/arm64/include/asm/cpufeature.h
> +++ b/arch/arm64/include/asm/cpufeature.h
> @@ -841,6 +841,11 @@ static inline bool system_supports_lpa2(void)
>  	return cpus_have_final_cap(ARM64_HAS_LPA2);
>  }
>  
> +static inline bool system_supports_pie(void)
> +{
> +	return alternative_has_cap_unlikely(ARM64_HAS_S1PIE);
> +}
> +
>  static inline bool system_supports_poe(void)
>  {
>  	return alternative_has_cap_unlikely(ARM64_HAS_S1POE);
> diff --git a/arch/arm64/kvm/hyp/include/hyp/fault.h b/arch/arm64/kvm/hyp/include/hyp/fault.h
> index fc573fc767b0..741ea12be07d 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/fault.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/fault.h
> @@ -38,8 +38,9 @@ static inline bool __translate_far_to_hpfar(u64 far, u64 *hpfar)
>  	 * saved the guest context yet, and we may return early...
>  	 */
>  	par = read_sysreg_par();
> -	ret = system_supports_poe() ? __kvm_at(OP_AT_S1E1A, far) :
> -	                              __kvm_at(OP_AT_S1E1R, far);
> +	ret = system_supports_poe() || system_supports_pie() ?
> +		__kvm_at(OP_AT_S1E1A, far) :
> +		__kvm_at(OP_AT_S1E1R, far);
>  	if (!ret)
>  		tmp = read_sysreg_par();
>  	else
> -- 
> 2.56.0.385.gac671c819a-goog
> 
