Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793964897;
	b=hOp2vSHUBpKYMxEBytsGDozUTtjHCBrEgACW2lufXW2xuTkwWQ8Gpt1oktu7CMNX2B7o
	 u1D+wdpbEjnR6zZHcobUcJsK1pjn5U3vFPnEsbC6M9NOW00BoKvz/tqrEkw4xML1aAE8w
	 ZGXxf8PRIzujHJ70ricnKOU+56Tq5UzsqaPix8wmiHeCMRlhonbV/gUYJuP3dRUmVHShU
	 MpLo7c1QfTSBMg+e+lqh/cExGqLIU+EZUssYwrfm0koJYtNiW0sYVDKJotskM7sO/Jz3P
	 9/+HigKEJqVJ1rlBMKS39IYFDgma6GRdMhysrtc8R+tlpfV1GpbNI/G36JUCmhI7RdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793964897;
	h=Received:DKIM-Signature:Received:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To:
	 X-Cookie;
	bh=Gf9gD5fRD5pl+7Q+o6m2T83pqPAdlS2BRDBwZ+qU6Rk=;
	b=BmQ+ADECIify1fNnRBJ8mxPhaPJwhgrNHBdaxjZCD5BkSMTNnCjf6S4WjX4iP3FHxxcY
	 QgxWgyQ7Pc9CNd3KryzFAsl4dxAPuIeLoherJbUGf6rLlPsO4acbvTMjxWsMj9ZQgKkDn
	 mq4HkR4ooYzrw+vGN2RI4ZONqYveQiqLLCK/mmRxFBuSA8D71ZvQBnQy4xROnHVZlddxz
	 3GzdTw/TINYUy4Tuo/KQGXHnMRILfTbQokrIn3TeUGcn3AetkcNrlqmNcWND3oX74EgSX
	 1On7IBKXT5ddQAfMEAzoS8RTkUI85y9biXUWLsYSy7XYrtc0MYTGhes6EItMUy/GlBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Y4V30aWQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C15B0606D80B
	for <kvmarm@lists.linux.dev>; Fri,  6 Nov 2026 11:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Y4V30aWQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CC3C1F008A1;
	Fri,  6 Nov 2026 11:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793964896;
	bh=Gf9gD5fRD5pl+7Q+o6m2T83pqPAdlS2BRDBwZ+qU6Rk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Y4V30aWQj+kSrMyULbf2efgo68gVJPyWP7RsPwoEuXCL6tkaGc2OhRYNepNtM+Fd3
	 VZJ29fUWQCdmVO9rTlBie3BnR/p12SQawExnQ0M6R3nno9Kndm1MtBJYHgZtxLL/v1
	 9vU3nXQTBVu6x/+HMk3/q5M0Y6+wj1VJymU6jLQVOHT99QAHuFRLLtiw4dn5pLIyEG
	 hN83e15niAyg4luYMKcEWoT+2UPktzDMQMBhuok/hCXA2Gp8nS6nCjG7gAN04/ETr/
	 lmUa4jKesDpHet2FXy8LoL2csWkMhraso/CwEsbWWRPrsqi6lifUPkRS1ry0USUX2P
	 y+MVNN0QFIKKw==
Received: by traversing.sirena.org.uk (Postfix, from userid 1000)
	id 7E26C27E89F1; Fri, 06 Nov 2026 11:34:47 +0000 (GMT)
Date: Fri, 6 Nov 2026 11:34:47 +0000
From: Mark Brown <broonie@kernel.org>
To: Oliver Upton <oupton@kernel.org>
Cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Fuad Tabba <fuad.tabba@linux.dev>, Aishwarya.TCV@arm.com
Subject: Re: [PATCH v3 4/5] KVM: arm64: Convert TCR_EL2 to config-driven
 sanitisation
Message-ID: <5e8a61c2-24ff-46a1-819f-94fcd91c9688@sirena.org.uk>
References: <20261029223732.103785-1-oupton@kernel.org>
 <20261029223732.103785-5-oupton@kernel.org>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="Q+tSDECOZioM9ODW"
Content-Disposition: inline
In-Reply-To: <20261029223732.103785-5-oupton@kernel.org>
X-Cookie: Have a nice diurnal anomaly.


--Q+tSDECOZioM9ODW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 29, 2026 at 03:37:31PM -0700, Oliver Upton wrote:
> From: Wei-Lin Chang <weilin.chang@arm.com>
>=20
> Feature dependencies of the fields in TCR_EL2 are extracted from
> Registers.json of the BSD licenced AARCHMRS
> (AARCHMRS_OPENSOURCE_A_profile_FAT-2026-06).
>=20
> Places where we slightly deviate from the above:
>=20
>  - Stick to the ARM ARM M.c requirement for TCR_EL2.TCMA*, which only
>    depends on FEAT_MTE2. This avoids updating ID_AA64PFR2_EL1 with new
>    VMTE* definitions that we don't know the meaning of, as they aren't
>    present in the ARM ARM yet.
>=20
>  - Ignore TCR_EL2.DS's requirement of needing the effective value of
>    TCR2_EL2.D128 be 0. This requires runtime detection of TCR2_EL2.D128
>    and we don't have D128 support yet.
>=20
>  - TCR_EL2.AS is dependent on FEAT_ASID16, this information is missing
>    from the json.

I'm seeing a regression in -next for the pre_fault_memory_test selftest
when run on qemu with EL2 and NV enabled which bisects to this commit in
-next:

# selftests: kvm: pre_fault_memory_test
<47>[ 1358.708301] systemd-journald[75]: Sent WATCHDOG=3D1 notification.
# Random seed: 0xe322a57
# Testing guest mode: PA-bits:52,  VA-bits:48,  4K pages
# Testing memory backing src type: anonymous
#
# =3D=3D=3D=3D Test Assertion Failure =3D=3D=3D=3D
#   pre_fault_memory_test.c:260: false
#   pid=3D1888 tid=3D1888 errno=3D2 - No such file or directory
# sh: 1: addr2line: not found
#   Unknown ucall 0x0.
not ok 48 selftests: kvm: pre_fault_memory_test # exit=3D254

The NV pre fault test appears to run fine in the same run, and the test
passes when run on the same qemu version in vanilla VHE mode.

Full log:

  https://lava.sirena.org.uk/scheduler/job/196379#L2476

bisect log:

# bad: [39ee95e368c911fdd4d896d9e30dc39e03655533] Merge branch 'for-linux-n=
ext-fixes' of https://gitlab.freedesktop.org/drm/misc/kernel.git
# good: [05441d697f7f9a927264f4058cbbc6a03dfcac9d] Merge tag 'cocci-7.4-rc1=
' of git://git.kernel.org/pub/scm/linux/kernel/git/jlawall/linux
# good: [5b4696e0bfc358619adaeab25ad35b4979af8331] ocfs2: cache the mount c=
ontext for dentry lock callbacks
# good: [81755e75f86c490bc9296f6cec0cd221edecaa27] KVM: arm64: Reset TCR_EL=
2 according to guest's E2H mode
# good: [b5d08dcf25e7a22a7f52d9806c6c6db0c3354a0b] KVM: arm64: selftests: T=
est MOVI and MOVALL on a pending LPI
# good: [2942baff3a951e0805d0ce9608f318e21c7e3744] arm64: sysreg: Add TCR_E=
L2 to sysreg infrastructure
# good: [126429e2f503ade63502978beb0c519066442250] ocfs2: stop recovery bef=
ore shutting down local allocators
git bisect start '39ee95e368c911fdd4d896d9e30dc39e03655533' '05441d697f7f9a=
927264f4058cbbc6a03dfcac9d' '5b4696e0bfc358619adaeab25ad35b4979af8331' '817=
55e75f86c490bc9296f6cec0cd221edecaa27' 'b5d08dcf25e7a22a7f52d9806c6c6db0c33=
54a0b' '2942baff3a951e0805d0ce9608f318e21c7e3744' '126429e2f503ade63502978b=
eb0c519066442250'
# test job: [5b4696e0bfc358619adaeab25ad35b4979af8331] https://lava.sirena.=
org.uk/scheduler/job/190826
# test job: [81755e75f86c490bc9296f6cec0cd221edecaa27] https://lava.sirena.=
org.uk/scheduler/job/196795
# test job: [b5d08dcf25e7a22a7f52d9806c6c6db0c3354a0b] https://lava.sirena.=
org.uk/scheduler/job/194830
# test job: [2942baff3a951e0805d0ce9608f318e21c7e3744] https://lava.sirena.=
org.uk/scheduler/job/196614
# test job: [126429e2f503ade63502978beb0c519066442250] https://lava.sirena.=
org.uk/scheduler/job/190308
# test job: [39ee95e368c911fdd4d896d9e30dc39e03655533] https://lava.sirena.=
org.uk/scheduler/job/198582
# bad: [39ee95e368c911fdd4d896d9e30dc39e03655533] Merge branch 'for-linux-n=
ext-fixes' of https://gitlab.freedesktop.org/drm/misc/kernel.git
git bisect bad 39ee95e368c911fdd4d896d9e30dc39e03655533
# test job: [cbf47fe57a568f178ac55176d98a13caba1d8598] https://lava.sirena.=
org.uk/scheduler/job/195738
# bad: [cbf47fe57a568f178ac55176d98a13caba1d8598] KVM: arm64: Clear the who=
le hugetlb folio when sanitising MTE tags
git bisect bad cbf47fe57a568f178ac55176d98a13caba1d8598
# test job: [f86c6685ac5cf60f80478c006a521aef122a9517] https://lava.sirena.=
org.uk/scheduler/job/194120
# bad: [f86c6685ac5cf60f80478c006a521aef122a9517] Merge branch kvm-arm64/mm=
u-fixes-7.4-1 into kvmarm-master/fixes
git bisect bad f86c6685ac5cf60f80478c006a521aef122a9517
# test job: [388faffbd371fd367d39535ad2aa07fbbd745c08] https://lava.sirena.=
org.uk/scheduler/job/196379
# bad: [388faffbd371fd367d39535ad2aa07fbbd745c08] KVM: arm64: Convert TCR_E=
L2 to config-driven sanitisation
git bisect bad 388faffbd371fd367d39535ad2aa07fbbd745c08
# first bad commit: [388faffbd371fd367d39535ad2aa07fbbd745c08] KVM: arm64: =
Convert TCR_EL2 to config-driven sanitisation
# test job: [62b9e1f75a3c39cfc38b3950bbad017ac5f95bcc] https://lava.sirena.=
org.uk/scheduler/job/199296
# bad: [62b9e1f75a3c39cfc38b3950bbad017ac5f95bcc] KVM: arm64: Clear the who=
le hugetlb folio when storing MTE tags
git bisect bad 62b9e1f75a3c39cfc38b3950bbad017ac5f95bcc
# test job: [0e24f9db2ebedc271add0c5dbf2821b8f8a0ab06] https://lava.sirena.=
org.uk/scheduler/job/199765
# bad: [0e24f9db2ebedc271add0c5dbf2821b8f8a0ab06] KVM: arm64: Add an ISB af=
ter mapping a hyp fixmap slot
git bisect bad 0e24f9db2ebedc271add0c5dbf2821b8f8a0ab06
# test job: [361564a8d4305100ee4140ff7b345d1bf2c1a1b2] https://lava.sirena.=
org.uk/scheduler/job/200104
# bad: [361564a8d4305100ee4140ff7b345d1bf2c1a1b2] KVM: arm64: nv: Correctly=
 compute the effective TCR_EL1 for nVHE TCR_EL2
git bisect bad 361564a8d4305100ee4140ff7b345d1bf2c1a1b2
# test job: [388faffbd371fd367d39535ad2aa07fbbd745c08] https://lava.sirena.=
org.uk/scheduler/job/196379
# bad: [388faffbd371fd367d39535ad2aa07fbbd745c08] KVM: arm64: Convert TCR_E=
L2 to config-driven sanitisation
git bisect bad 388faffbd371fd367d39535ad2aa07fbbd745c08
# first bad commit: [388faffbd371fd367d39535ad2aa07fbbd745c08] KVM: arm64: =
Convert TCR_EL2 to config-driven sanitisation

--Q+tSDECOZioM9ODW
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQReagvpf3TrrA7BoYYv73Ows9A4iQUCau27VwAKCRAv73Ows9A4
iRzOAP42fbJOeL2JgLldR3yOcQk2vlJFl9o7dPY+rOMfa5MtEQEAng8Vfo0XGQqI
ruDRjjIihEtDms/tKYHXHu/mzbsJBAQ=
=8ggV
-----END PGP SIGNATURE-----

--Q+tSDECOZioM9ODW--
