Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD2991DEFE8;
	Mon,  3 Aug 2026 17:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785778793; cv=none; b=avdeBaXnU2tWVTpGUPJY5X1UdfAGvLSiJty42zQVg5YnEtXYlz5/XkRZEBPc8fjFSbx1oPIPmQG56WcK8o+ulcJljIPcNsrvFuYTUbvcplbfmnd4XQrKJS6V86Aj2Fl7OTYv0TnXgkMpyTlEb1KhBuQhtZ9v5whIOhXuuI3kM9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785778793; c=relaxed/simple;
	bh=wCzFI2MLtYMRWlwIW+L5yh7Jf2hRTvM2YaCbyD5nyB8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pIGFFzF2xtPJ/FxTmPWARZX4M+GyXtxweRaeQFxFvE3QGE/s9bS8tD0L6HpfZn9klGYnsROjdcz+FDdhqzT5H6bovk5E44ithEPJvYz943fccs6lSiD5GXK3CscYu2GyXJ1phFxrqtpnRD5tZHiOeBDyv6gV1GjVTIpfgv+niiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=awVCjJ+K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="awVCjJ+K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB10F1F000E9;
	Mon,  3 Aug 2026 17:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785778791;
	bh=ANCJ090YSljPVuosjhGz2DsCnXK8OPLoRjSiDiI3kN8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=awVCjJ+KyUB+NFUezo/gqQocKqiE/KbengTUFkfH8zcpr33swm5ytGItr/0UnCjTS
	 934c0Ab5WRblr698r3bCSIJDTv0DreO4ZA6smBwLlnjIBNFAdotOUJmwhMkeUQZG0f
	 6abeSZARVg+54wLdhSE2wpahdcNEjeuA29KrW+m8c0QIOGwoDNTFWL5ZTMjmvunUwB
	 IZNYboc/RSCKOXO7lkKx+0D9Dq0G5c2odnA11Gl8QbL2WvmCVh1HugtPBNHilbzoQF
	 JdaamWHpTF46CVjFoLmag9ffmSsSY5GGBDJzgb3vyS/0bCJxC5SSR+Z3dRP+DK77CN
	 On37/0pgj+jwQ==
Date: Mon, 3 Aug 2026 18:39:46 +0100
From: Mark Brown <broonie@kernel.org>
To: Fuad Tabba <tabba@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] KVM: arm64: Block ID register changes after we rely
 on the values
Message-ID: <5d80e90f-179f-4b36-8a54-9e777f8b7aa8@sirena.org.uk>
References: <20260731-kvm-arm64-idreg-final-v1-0-3de2a5616dc6@kernel.org>
 <20260731-kvm-arm64-idreg-final-v1-2-3de2a5616dc6@kernel.org>
 <CA+EHjTxoAwkUJ1Tyu5700hZBFtc1HpCt14-8Gh2O5qA_NpnaFQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="36SEx+wND90T2F85"
Content-Disposition: inline
In-Reply-To: <CA+EHjTxoAwkUJ1Tyu5700hZBFtc1HpCt14-8Gh2O5qA_NpnaFQ@mail.gmail.com>
X-Cookie: Prunes give you a run for your money.


--36SEx+wND90T2F85
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Aug 02, 2026 at 06:13:38PM +0100, Fuad Tabba wrote:
> On Fri, 31 Jul 2026 at 21:46, Mark Brown <broonie@kernel.org> wrote:

> The flag fixes this. One consistency point: set_id_reg() and
> set_imp_id_reg() now gate on the new flag, but
> kvm_vm_finalize_sys_regs() still returns early on
> kvm_vm_has_ran_once(), and so does the KVM_BUG_ON() in
> kvm_set_vm_id_reg(). Could both move to kvm_id_regs_final(), so one
> predicate expresses the invariant? If so I think they would need to
> move together, since on a retried first run kvm_vm_finalize_sys_regs()
> re-runs and re-writes the ID regs via kvm_set_vm_id_reg(), so
> switching only the BUG_ON would trip it.

Yeah, I think that's sensible.  I think I was thinking we might want to
add non-ID register stuff at some point, but we don't currently have any
of that and the ID register stuff that is there ought to be joined up.

> Separately, would a selftest for that failed-run path be worth adding,
> checking that KVM_SET_ONE_REG on an ID reg and KVM_CREATE_DEVICE both
> return -EBUSY?

It feels like there's a general gap here with ordering and interactions
during VM setup, both with the API calls and ideally also with
combinations of features.  Covering that is probably much more
beneficial than a focused test for the specific issue, that'd catch
recurrences of the specific mechanism but it'd be easy for it to miss
something else that causes the ID registers to change.

--36SEx+wND90T2F85
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmpw0mEACgkQJNaLcl1U
h9B7ZQf+M5zCfT7i75HdE3i14+l66LGOQqS+9Uv/BpcCJinHD+GCrG5npWWtMbAw
D+O5Xlqh4CvW5q+TglHUqpQPiL/aU8cnmcSsxVPxIXYLAqT4hNCfY4jtmC8malde
BwMBoMJPrs+UVqL6b16LDn94ug373LNeVYk3F4NfzA5Ehlkd2fjt8rk6Z8/45/6Y
x/tUrnZmER1BZxm8SUWIh5GiSYPnJaBVNaSo2wSNu1/2/NeaoyXHRQz/o0bCN4HL
+e2m90wwjetFwk9UFDo3OEaUDUTR+DEjvi7AyCkxtXXnebXwV7d5Klay1bcsFGzf
s2HFAyifLePXHTTrMHpZ/7pgABMB4g==
=iC0q
-----END PGP SIGNATURE-----

--36SEx+wND90T2F85--
