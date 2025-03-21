Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ABB01DFE1;
	Fri, 21 Mar 2025 00:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742516488; cv=none; b=HSptBIA+WSKnDw1E+la01hC+7cuOu1vODX880WOegrQi7v5zrX4QmZ8JyNNk9WB0xEWHvHw3gmf5IUo/KIN+wOzX6sYfIRaYN45MRjSbKeCGZeimbTfJ5pqjmN+Mfcj5B6H5IfBfUDtIq2Udepu6iM/hQ0AE/6IDC213GQLLFxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742516488; c=relaxed/simple;
	bh=CxkNOjGCXba3Gux3AVvDj40UuxcrMhBca247x44Ivao=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G/2WZJm8oAK7W7+jozs5f42MNcec+m33tN1LP2jW3mccrP4ceCV6KuViCBiHGOgnNbzhlj3ZUVFvqmrhIAllYNbRPM7lK5ZcoWMlibCBI2wDY+Q7usR9Mc5NVygaHvXmqD6BubsMqHRXQ1uEA4Zz+hXNLsrbIdDDsN2neYHoPYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KotrjRaA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KotrjRaA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23C46C4CEDD;
	Fri, 21 Mar 2025 00:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742516487;
	bh=CxkNOjGCXba3Gux3AVvDj40UuxcrMhBca247x44Ivao=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KotrjRaAyd4760o+CZLXOYyqyRkeV+05DN6izHbzU+07hE3040y+uRbPEe3uls0hw
	 VS96RqtDU0PCyHHKsEEtahHRaS7MPq5QiXDT8OOnlhd58PJVjW4ZB101D8LhkyPwmi
	 V9J0eY8s8Z19JnGvN3gTI6quuE0cLuAg/ZdxZfbvPLbXO2dmC7Ix/vlIzEn/M60bjY
	 EdgEuoiXE9OtPySIGRD6RduCOPUYhpdKU7kRmtMAt0hm85Xky817j9MZv2qU0cwvC/
	 ZGqjreD/DiMxOiUREb/kMTdpDxgAszFqENnHIrbpAT+Z8+6D3FxKu4ceELTWhssbdC
	 XdPxv5/wYn9ew==
Date: Fri, 21 Mar 2025 00:21:22 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	Mark Rutland <mark.rutland@arm.com>, Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH 6.12 v2 3/8] KVM: arm64: Remove host FPSIMD saving for
 non-protected KVM
Message-ID: <e01d14ee-4071-4871-8b6c-acc24c9b862f@sirena.org.uk>
References: <20250321-stable-sve-6-12-v2-0-417ca2278d18@kernel.org>
 <20250321-stable-sve-6-12-v2-3-417ca2278d18@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="NiQQUQUX8lYYs2VU"
Content-Disposition: inline
In-Reply-To: <20250321-stable-sve-6-12-v2-3-417ca2278d18@kernel.org>
X-Cookie: Do not fold, spindle or mutilate.


--NiQQUQUX8lYYs2VU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 21, 2025 at 12:12:59AM +0000, Mark Brown wrote:
> From: Mark Rutland <mark.rutland@arm.com>

[ Upstream commit 8eca7f6d5100b6997df4f532090bc3f7e0203bef ]

>=20
> Now that the host eagerly saves its own FPSIMD/SVE/SME state,
> non-protected KVM never needs to save the host FPSIMD/SVE/SME state,
> and the code to do this is never used. Protected KVM still needs to
> save/restore the host FPSIMD/SVE state to avoid leaking guest state to
> the host (and to avoid revealing to the host whether the guest used
> FPSIMD/SVE/SME), and that code needs to be retained.
>=20
> Remove the unused code and data structures.
>=20
> To avoid the need for a stub copy of kvm_hyp_save_fpsimd_host() in the
> VHE hyp code, the nVHE/hVHE version is moved into the shared switch
> header, where it is only invoked when KVM is in protected mode.
>=20
> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> Reviewed-by: Mark Brown <broonie@kernel.org>
> Tested-by: Mark Brown <broonie@kernel.org>
> Acked-by: Will Deacon <will@kernel.org>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Fuad Tabba <tabba@google.com>
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Oliver Upton <oliver.upton@linux.dev>
> Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
> Link: https://lore.kernel.org/r/20250210195226.1215254-3-mark.rutland@arm=
=2Ecom
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_host.h       | 20 +++++---------------
>  arch/arm64/kvm/arm.c                    |  8 --------
>  arch/arm64/kvm/fpsimd.c                 |  2 --
>  arch/arm64/kvm/hyp/include/hyp/switch.h | 25 +++++++++++++++++++++++--
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c      |  2 +-
>  arch/arm64/kvm/hyp/nvhe/switch.c        | 28 ----------------------------
>  arch/arm64/kvm/hyp/vhe/switch.c         |  8 --------
>  7 files changed, 29 insertions(+), 64 deletions(-)
>=20
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/k=
vm_host.h
> index d148cf578cb84e7dec4d1add2afa60a3c7a1e041..d8802490b25cba65369f03d94=
627a2624f14b072 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -602,23 +602,13 @@ struct kvm_host_data {
>  	struct kvm_cpu_context host_ctxt;
> =20
>  	/*
> -	 * All pointers in this union are hyp VA.
> +	 * Hyp VA.
>  	 * sve_state is only used in pKVM and if system_supports_sve().
>  	 */
> -	union {
> -		struct user_fpsimd_state *fpsimd_state;
> -		struct cpu_sve_state *sve_state;
> -	};
> -
> -	union {
> -		/* HYP VA pointer to the host storage for FPMR */
> -		u64	*fpmr_ptr;
> -		/*
> -		 * Used by pKVM only, as it needs to provide storage
> -		 * for the host
> -		 */
> -		u64	fpmr;
> -	};
> +	struct cpu_sve_state *sve_state;
> +
> +	/* Used by pKVM only. */
> +	u64	fpmr;
> =20
>  	/* Ownership of the FP regs */
>  	enum {
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index e6f0443210a8b7a65f616b25b2e6f74a05683ed6..634d3f62481827a3bf3aba6bf=
78cafed71b5bd32 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -2476,14 +2476,6 @@ static void finalize_init_hyp_mode(void)
>  			per_cpu_ptr_nvhe_sym(kvm_host_data, cpu)->sve_state =3D
>  				kern_hyp_va(sve_state);
>  		}
> -	} else {
> -		for_each_possible_cpu(cpu) {
> -			struct user_fpsimd_state *fpsimd_state;
> -
> -			fpsimd_state =3D &per_cpu_ptr_nvhe_sym(kvm_host_data, cpu)->host_ctxt=
=2Efp_regs;
> -			per_cpu_ptr_nvhe_sym(kvm_host_data, cpu)->fpsimd_state =3D
> -				kern_hyp_va(fpsimd_state);
> -		}
>  	}
>  }
> =20
> diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
> index efb54ed60fe1d1d8a904b10a4a4bd3c820d9dac5..2ee6bde85235581d6bc9cba7e=
578c55875b5d5a1 100644
> --- a/arch/arm64/kvm/fpsimd.c
> +++ b/arch/arm64/kvm/fpsimd.c
> @@ -64,8 +64,6 @@ void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu)
>  	 */
>  	fpsimd_save_and_flush_cpu_state();
>  	*host_data_ptr(fp_owner) =3D FP_STATE_FREE;
> -	*host_data_ptr(fpsimd_state) =3D NULL;
> -	*host_data_ptr(fpmr_ptr) =3D NULL;
> =20
>  	vcpu_clear_flag(vcpu, HOST_SVE_ENABLED);
>  	if (read_sysreg(cpacr_el1) & CPACR_EL1_ZEN_EL0EN)
> diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp=
/include/hyp/switch.h
> index 5310fe1da6165bcdedfb5ce61bce353e4c9dd58b..a7f6a653f33718d1a25e23260=
8e63ea287f2a672 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> @@ -344,7 +344,28 @@ static inline void __hyp_sve_save_host(void)
>  			 true);
>  }
> =20
> -static void kvm_hyp_save_fpsimd_host(struct kvm_vcpu *vcpu);
> +static void kvm_hyp_save_fpsimd_host(struct kvm_vcpu *vcpu)
> +{
> +	/*
> +	 * Non-protected kvm relies on the host restoring its sve state.
> +	 * Protected kvm restores the host's sve state as not to reveal that
> +	 * fpsimd was used by a guest nor leak upper sve bits.
> +	 */
> +	if (system_supports_sve()) {
> +		__hyp_sve_save_host();
> +
> +		/* Re-enable SVE traps if not supported for the guest vcpu. */
> +		if (!vcpu_has_sve(vcpu))
> +			cpacr_clear_set(CPACR_ELx_ZEN, 0);
> +
> +	} else {
> +		__fpsimd_save_state(host_data_ptr(host_ctxt.fp_regs));
> +	}
> +
> +	if (kvm_has_fpmr(kern_hyp_va(vcpu->kvm)))
> +		*host_data_ptr(fpmr) =3D read_sysreg_s(SYS_FPMR);
> +}
> +
> =20
>  /*
>   * We trap the first access to the FP/SIMD to save the host context and
> @@ -394,7 +415,7 @@ static bool kvm_hyp_handle_fpsimd(struct kvm_vcpu *vc=
pu, u64 *exit_code)
>  	isb();
> =20
>  	/* Write out the host state if it's in the registers */
> -	if (host_owns_fp_regs())
> +	if (is_protected_kvm_enabled() && host_owns_fp_regs())
>  		kvm_hyp_save_fpsimd_host(vcpu);
> =20
>  	/* Restore the guest state */
> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe=
/hyp-main.c
> index fefc89209f9e41c95478f6770881eb314a38b4c2..4e757a77322c9efc59cdff501=
745f7c80d452358 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> @@ -83,7 +83,7 @@ static void fpsimd_sve_sync(struct kvm_vcpu *vcpu)
>  	if (system_supports_sve())
>  		__hyp_sve_restore_host();
>  	else
> -		__fpsimd_restore_state(*host_data_ptr(fpsimd_state));
> +		__fpsimd_restore_state(host_data_ptr(host_ctxt.fp_regs));
> =20
>  	if (has_fpmr)
>  		write_sysreg_s(*host_data_ptr(fpmr), SYS_FPMR);
> diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/s=
witch.c
> index 81d933a71310fd1132b2450cd08108e071a2cf78..3ce16f90fe6af7be21bc7b84a=
9d8b3905b8b08a7 100644
> --- a/arch/arm64/kvm/hyp/nvhe/switch.c
> +++ b/arch/arm64/kvm/hyp/nvhe/switch.c
> @@ -193,34 +193,6 @@ static bool kvm_handle_pvm_sys64(struct kvm_vcpu *vc=
pu, u64 *exit_code)
>  		kvm_handle_pvm_sysreg(vcpu, exit_code));
>  }
> =20
> -static void kvm_hyp_save_fpsimd_host(struct kvm_vcpu *vcpu)
> -{
> -	/*
> -	 * Non-protected kvm relies on the host restoring its sve state.
> -	 * Protected kvm restores the host's sve state as not to reveal that
> -	 * fpsimd was used by a guest nor leak upper sve bits.
> -	 */
> -	if (unlikely(is_protected_kvm_enabled() && system_supports_sve())) {
> -		__hyp_sve_save_host();
> -
> -		/* Re-enable SVE traps if not supported for the guest vcpu. */
> -		if (!vcpu_has_sve(vcpu))
> -			cpacr_clear_set(CPACR_ELx_ZEN, 0);
> -
> -	} else {
> -		__fpsimd_save_state(*host_data_ptr(fpsimd_state));
> -	}
> -
> -	if (kvm_has_fpmr(kern_hyp_va(vcpu->kvm))) {
> -		u64 val =3D read_sysreg_s(SYS_FPMR);
> -
> -		if (unlikely(is_protected_kvm_enabled()))
> -			*host_data_ptr(fpmr) =3D val;
> -		else
> -			**host_data_ptr(fpmr_ptr) =3D val;
> -	}
> -}
> -
>  static const exit_handler_fn hyp_exit_handlers[] =3D {
>  	[0 ... ESR_ELx_EC_MAX]		=3D NULL,
>  	[ESR_ELx_EC_CP15_32]		=3D kvm_hyp_handle_cp15_32,
> diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/swi=
tch.c
> index 80581b1c399595fd64d0ccada498edac322480a6..e7ca0424107adec2371ae4553=
ebab9857c60b6d9 100644
> --- a/arch/arm64/kvm/hyp/vhe/switch.c
> +++ b/arch/arm64/kvm/hyp/vhe/switch.c
> @@ -309,14 +309,6 @@ static bool kvm_hyp_handle_eret(struct kvm_vcpu *vcp=
u, u64 *exit_code)
>  	return true;
>  }
> =20
> -static void kvm_hyp_save_fpsimd_host(struct kvm_vcpu *vcpu)
> -{
> -	__fpsimd_save_state(*host_data_ptr(fpsimd_state));
> -
> -	if (kvm_has_fpmr(vcpu->kvm))
> -		**host_data_ptr(fpmr_ptr) =3D read_sysreg_s(SYS_FPMR);
> -}
> -
>  static bool kvm_hyp_handle_tlbi_el2(struct kvm_vcpu *vcpu, u64 *exit_cod=
e)
>  {
>  	int ret =3D -EINVAL;
>=20
> --=20
> 2.39.5
>=20

--NiQQUQUX8lYYs2VU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmfcsQEACgkQJNaLcl1U
h9DO1gf9FAGkYL3ijlXp5wnPPu0zGv77eolWFBJPqZosJwTiihWRzcek59HNwBHy
WuCZU+aynAtU5HpkgHJ+qivL9PFbFLK11XKaekkKxDM5GRpb+xVdxCTDk3Rgout2
DUFGTuKfP6iq98Z9mnJTNCO1fQh9woRuDgcVrSU5xYiEF1d73ykdyNhZLggrroOl
xvL42gx9AcXqYPRra6jwivPsYgf6m+9s+QFf75/2eR7AYeB75lABgYoahHf0te9y
u785JmsgsOANl38//7toRm/zq5zvtZNjLJ6kZg2305HtxBg1VAUMpbl2Es5gr+ZW
JggZrk/Rrc4WSa+ByVDg2ExRyhWzbw==
=zOny
-----END PGP SIGNATURE-----

--NiQQUQUX8lYYs2VU--
