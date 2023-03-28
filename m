Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E0548BFB
	for <kvmarm@lists.linux.dev>; Tue, 28 Mar 2023 15:44:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE088C4339C;
	Tue, 28 Mar 2023 15:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1680018291;
	bh=2qbd4bjrDdkXBHtMl7GMvza8RwChsXMgrkrhwgZlTfQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=e93kkbZomFWiap39HuNDS2TdduJKUYi5TpxiANbi2FJiNdvKvWn8y5Usb7kwI2A4L
	 uSBsod7gGZz+cNcs+tNgjaHpAK8wl7yhw2oT2FJ9KE+Uhcz4mJ8R9pLTCiK5kKd1tV
	 ECn3KRjw0mXmgcWt2nb6gKYZleiNuAFWxBIBYXGgB1jJG0xaz0PV0siXl32AUz0yL+
	 DdVMb7i5ZQv3MQeUpZsQliPHTp0ONPZhhy/OBFinbpcy4IIiuJfXwhK85pKwosEgH9
	 95WfOXj/t4EPBKkWddSIqBl8McvoQ3uSkWF2tk6CBccYdMH2fmMYxXO8yUNYLtxtZQ
	 Hd565dkVNJURA==
Date: Tue, 28 Mar 2023 16:44:46 +0100
From: Mark Brown <broonie@kernel.org>
To: Will Deacon <will@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH v2 2/2] KVM: arm64: Move FGT value configuration to vCPU
 state
Message-ID: <09c6419a-1160-485c-a72d-ae0b8eec8d49@sirena.org.uk>
References: <20230301-kvm-arm64-fgt-v2-0-c11c0dcf810a@kernel.org>
 <20230301-kvm-arm64-fgt-v2-2-c11c0dcf810a@kernel.org>
 <20230328152744.GB1844@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="2hO75k0Mz0dBUeH3"
Content-Disposition: inline
In-Reply-To: <20230328152744.GB1844@willie-the-truck>
X-Cookie: Oh, wow!  Look at the moon!


--2hO75k0Mz0dBUeH3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 28, 2023 at 04:27:45PM +0100, Will Deacon wrote:
> On Thu, Mar 23, 2023 at 03:48:36PM +0000, Mark Brown wrote:

> > +	if (cpus_have_final_cap(ARM64_HAS_FGT)) {
> > +		host_ctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
> > +
> > +		write_sysreg_s(__vcpu_sys_reg(vcpu, HFGRTR_EL2),
> > +			       SYS_HFGRTR_EL2);
> > +		write_sysreg_s(__vcpu_sys_reg(vcpu, HFGWTR_EL2),
> > +			       SYS_HFGWTR_EL2);

> I don't understand this hunk. Where is `host_ctxt` being used?

That's bitrot from a previous version, should be removed.

--2hO75k0Mz0dBUeH3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmQjC20ACgkQJNaLcl1U
h9DfKgf/ccM0P2IJ6/yOqP6pi+B/jaTs//4cY2ncF+ObaPz3yzVKg/aAoESEvJJd
7byGoPeV3Otn25KajMKlg2YML6oqssOxhkKp/BguaMbIYkFdCZNANvmRJcZgFIz5
SXSr1ZWcv9jS1bcgrH3Ym9XLv1uDjiE3lEBY72zcAzDF150NUCQqVAHz77p6ZIsZ
ZBit5Cr6gDIWj9PTvX7GTzWGPVJnrwMZrUC+X922T/0lUosnKJGMe1mC2XQPzUp3
vZg0i8b93Fv8hnppvFj9Qmj7kWOp8RKvQBCrXjn47zwkNSRq7lK+2/sitbYQ62zk
b9yklhqOoHhef6Et6ylPaj3bjLXGJQ==
=etva
-----END PGP SIGNATURE-----

--2hO75k0Mz0dBUeH3--
