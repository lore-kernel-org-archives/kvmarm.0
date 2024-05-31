Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A47D1E492
	for <kvmarm@lists.linux.dev>; Fri, 31 May 2024 14:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717164581; cv=none; b=O3PBYa130p8vRij125+F7eclTcGAqiuIoxAGL1w1mY2s1SgSOw4FhqN8w0vxawkUz/FW5hgs3mAjlBUDUo1xEDrNZqEdjq3qB6cKwd5XpT3RFYXcLtfXcajh0375m5eRBKINgdmvv/4VCaEDFDIh8cNsI1k36rk51p1JwtNFOLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717164581; c=relaxed/simple;
	bh=Yl9+BUOU41B+3e5HOY5iTVlMTXDycmCZmAJJCc0kiXc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h6vwXJEKtyjVDDchev3uM3Pv/hW0sAqvyd9nopsBVSl2xUG2DRRbzQzjbmr0HbzPS8Q9j8c0QDPj16zMthj9iFCyQ+tbL5XX6XPLeOlwVW8UekOAuGLJXL2Fnwi2l6x/TBmBM0VrxCc1Rj92+VSeKDihyGmURu2kpz+qZDjTx00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uypFs0+o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uypFs0+o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C440DC116B1;
	Fri, 31 May 2024 14:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717164580;
	bh=Yl9+BUOU41B+3e5HOY5iTVlMTXDycmCZmAJJCc0kiXc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uypFs0+oQ2I9dUlAnTBeBaEMlVlRGtdHZHHuRKW9koswoW2vAkeE4djPZ8kSXAwJt
	 hxnBdcfTDZaXv0LsBFPJwHXx2OcMrxKNiN0qAnry+BdHAK3mSjUqFsV1lwPzdc73cG
	 KTfKi4zr2edorf/LEO14Xo6MTOufAuQidahuMr7Et1Cz2HRNLPRQk7w7LJMMHeA/58
	 NGOj7Cvky0EAg6VpGvATImlSh0UIDIbMTkCkUjOeBwvJuExCBDYwSo0U1J/kTMgBFZ
	 e9NwjbDF8PRuYTiM1BmLR+ivKhEdFuiKtyPiciZh19vprPi7JBH/VWHFVg0EJ29UmP
	 Ls+oEY6xdfQdw==
Date: Fri, 31 May 2024 15:09:33 +0100
From: Mark Brown <broonie@kernel.org>
To: Fuad Tabba <tabba@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	maz@kernel.org, will@kernel.org, qperret@google.com,
	seanjc@google.com, alexandru.elisei@arm.com,
	catalin.marinas@arm.com, philmd@linaro.org, james.morse@arm.com,
	suzuki.poulose@arm.com, oliver.upton@linux.dev,
	mark.rutland@arm.com, joey.gouly@arm.com, rananta@google.com,
	yuzenghui@huawei.com
Subject: Re: [PATCH v3 05/11] KVM: arm64: Eagerly restore host fpsimd/sve
 state in pKVM
Message-ID: <f205aea1-bc52-41ff-9545-704cda9e23ff@sirena.org.uk>
References: <20240528125914.277057-1-tabba@google.com>
 <20240528125914.277057-6-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="m7sZEcD8k07stBm1"
Content-Disposition: inline
In-Reply-To: <20240528125914.277057-6-tabba@google.com>
X-Cookie: Serving suggestion.


--m7sZEcD8k07stBm1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 28, 2024 at 01:59:08PM +0100, Fuad Tabba wrote:

> +static inline void __hyp_sve_save_host(void)
> +{
> +	struct cpu_sve_state *sve_state =3D *host_data_ptr(sve_state);
> +
> +	sve_state->zcr_el1 =3D read_sysreg_el1(SYS_ZCR);
> +	write_sysreg_s(ZCR_ELx_LEN_MASK, SYS_ZCR_EL2);

As well as the sync issue Oliver mentioned on the removal of
_cond_update() just doing these updates as a blind write creates a
surprise if we ever get more control bits in ZCR_EL2.

> +static void __hyp_sve_restore_host(void)
> +{
> +	struct cpu_sve_state *sve_state =3D *host_data_ptr(sve_state);
> +
> +	/*
> +	 * On saving/restoring host sve state, always use the maximum VL for
> +	 * the host. The layout of the data when saving the sve state depends
> +	 * on the VL, so use a consistent (i.e., the maximum) host VL.
> +	 *
> +	 * Setting ZCR_EL2 to ZCR_ELx_LEN_MASK sets the effective length
> +	 * supported by the system (or limited at EL3).
> +	 */
> +	write_sysreg_s(ZCR_ELx_LEN_MASK, SYS_ZCR_EL2);

Setting ZCR_ELx_LEN_MASK sets the VL to the maximum supported/configured
for the current PE, not the system.  This will hopefully be the same
since we really hope implementors continue to build symmetric systems
but there is handling for that case in the kernel just in case.  Given
that we record the host's maximum VL should we use it?

> +static void fpsimd_sve_flush(void)
> +{
> +	*host_data_ptr(fp_owner) =3D FP_STATE_HOST_OWNED;
> +}
> +

That's not what I'd have expected something called fpsimd_sve_flush() to
do, I'd have expected it to save the current state to memory and then
mark it as free (that's what fpsimd_flush_cpu_state() does in the host
kernel).  Perhaps just inline this into the one user?

> +static void fpsimd_sve_sync(struct kvm_vcpu *vcpu)
> +{
> +	if (!guest_owns_fp_regs())
> +		return;
> +
> +	cpacr_clear_set(0, CPACR_ELx_FPEN|CPACR_ELx_ZEN);
> +	isb();

Spaces around |.

>  static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
>  {
>  	struct kvm_vcpu *host_vcpu =3D hyp_vcpu->host_vcpu;
> =20
> +	fpsimd_sve_flush();
> +
>  	hyp_vcpu->vcpu.arch.ctxt	=3D host_vcpu->arch.ctxt;
> =20
>  	hyp_vcpu->vcpu.arch.sve_state	=3D kern_hyp_va(host_vcpu->arch.sve_state=
);
> -	hyp_vcpu->vcpu.arch.sve_max_vl	=3D host_vcpu->arch.sve_max_vl;
> +	hyp_vcpu->vcpu.arch.sve_max_vl	=3D min(host_vcpu->arch.sve_max_vl, kvm_=
host_sve_max_vl);

This needs a comment I think.

--m7sZEcD8k07stBm1
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmZZ2hwACgkQJNaLcl1U
h9Djowf+JAr69mbgDt10e+tVuDv4APJ5hmXBkb/DzfuEOtNwgodAvkdX1bF7I45f
5MV3bZzVbMmM/y6vPqnPyL2cLWO4VZ5MaH2I5emUXt5KZkSN2NBQP2UkAUCCf/t9
2XVCG2WvtGDp/cpfVCjPFDYpq9wE36EX3gXhkl6kK2SWSSTQsgGTIqi/5uSQ0mT5
BdtYeV/HSboH+vK+8yhz02OBat1pDWl2EHV6XNoXklJ5jpxUkd7TCM2+Wfcpq85D
VaZWYEE2UIWr2E6ScoNXDNR6iOh4z4UiZdCDyPW68Yo12Hec0LQH07pfjoIYPgCp
2McLYnhaYx44SDKM0SP2dep7etRubQ==
=oGVm
-----END PGP SIGNATURE-----

--m7sZEcD8k07stBm1--
