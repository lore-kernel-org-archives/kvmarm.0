Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793732863;
	b=sRmrHu7g7O0U9ConqVUMWhv2GHWO3+wV2SXK9Ih8qxOakCnxnZRbZ8az4AIuWCJLrMAT
	 dkkVGV+LDkSwfE8Pz1D9/mv7odvLxW9AgU/wiDVJnUhBWZ9mvrMyXJbccTITSaPVvUahv
	 ISLF2rOI7mMyVlKIiiBdALknuuO2eAqYbDdN6Tulfac1N9mV6ha+b8xlAX7xJd225xJvH
	 ODvyCX63DB9gKT43OCJWzLt+3Re1LuClv7HgAv6cWk7kzUyxAaIxB5IWAKpCHg9gKXWhx
	 p2cMLRw3o3Vj++b3On6XO0SMrMzrVJgpSWcJxeqygtqkfrzHANWJKhyD77wp1JJ6C5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793732863;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=j6MbSsBqXrp0dMj1UoXcAeObU3QV9NcnvNWemCX499Y=;
	b=RK2u0rZ4KjYHtdBgppFeRCqqwqQvNTt903Rt+c+Qk22ZYANI3YdkHOjshzqpXs4fJasZ
	 L/IBGrAPovR8GPo8jXX1kC9YgqOxohHJ/slOxUXEGeoKmcZ6jSQE6GbWJ16vUoAOHe/hb
	 Q+2pgpBrfIBrxs0RU2oQKJGtvsN3kQWrNmZUzmrUo2CETU2RMPVn8yNvs9+hP64auN2Rb
	 fKFg00RnIQrwMAcalzFLWpTjrB+SgL8hTXMPgI99ICQJhN+UFf2NcIGK+It/1dwCVZVaQ
	 PAzy16fi+G47fDXnlkYO6RaKC+ueo+XJAYN0FdymopFFWueESg6QCizI6zFVwamKaOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lqUks20W;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52949606A339;
	Tue,  3 Nov 2026 19:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lqUks20W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98E551F000C1;
	Tue,  3 Nov 2026 19:07:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793732862;
	bh=j6MbSsBqXrp0dMj1UoXcAeObU3QV9NcnvNWemCX499Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lqUks20WYDC7B2p/rL/zhBI3ASQnV205gEchgxjPoRmPWScFWzYNzb6ZqSb2r62Rp
	 Fvd8SGw4VViGJtuMd93yhAANJQrwKRaWE5/althCzxSD9BdS/UI8ESRv2jUi2zsC+d
	 G7ksyu+3dCIpxgIjUb95bNZB6rPDA5v1/74zg9ArZTK3Q6A9jTQQZzQi4oWKB/wK6s
	 6mee1OfY/BNieYq6qKh4KTAxvHeg2YOQTVwMSJxqn8cOwo00nEgeqDiAsTvFGaCz0V
	 8hl3++ZMSvrlHxNpFidWGbSZmHv2OGWAUl0+NrJE1w3uK4a2IUFBm9BNCVZ7AxdeC0
	 ueUCiU9kwTMWQ==
Date: Tue, 3 Nov 2026 19:07:37 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Will Deacon <will@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH] KVM: arm64: Use S1E1A when Stage-1 PIE is supported
Message-ID: <auoprWUijipSDn83@gremlin>
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

This was useful as an excuse to go and investigate all this, take notes,
and learn why it all makes sense :)

And it does, so:

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

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
>

--
Cheers, Lorenzo
