Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B218044470E;
	Mon,  7 Sep 2026 10:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788775825; cv=none; b=Nq0xM5xJJwBJLBmYSiF/zXoRmUlbo6pd1Zh4S03GR2P1A0wcOqsw/3tGL0tA8IgVtol4+BlIq3YAV6pCq1idi3em4RafskNkpjhHbLs6yLXN/a0ce0DsaaOqXDXEM6sj3bKf8Huk+wvCfwMifpa3D2wBCKG/oKXgC55m/YIXFNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788775825; c=relaxed/simple;
	bh=S0boZOvHafjunImYn8787U6P+j4MPCVDmkfuTHgx3Do=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=JuVytDWr/1Cs27S524npZIzhFGA8ZXIakvr+itupq8S+S8l8PKrc9eY8jSlQZwM6Jb6g7KcNryZq4wV+z4RSuj3JrO1YkHb1USJhN1hjyY6PLjAgky/TyYvzuBNT9UvWTO2mpGimv2KeNFsjn77Xz8dvatJNsCwV676lBCoxALQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IMXKOas5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IMXKOas5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDDFD1F00A3A;
	Mon,  7 Sep 2026 10:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788775823;
	bh=tvRZDbLQrS9wa07Kzmc5NiGUlI3JSFIRkW8mBYDtfk4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=IMXKOas5xC/pRR9gqhDMEziObXQ5rPtlSPznfo8WqWKe2bkbelJb+/MnoNSbeiJrb
	 VdRg5APQ9BPJkG8452vlJPROvT5+ed4Mdrl9O477fi2PSOpFiP1HcoRTvCeFkRq71P
	 Eqv2FLKrCn8gTx3kchXUVo6Z6BubHpbvRCxc71NUoNcSpAIVnzXkcXCfvYpy0c+DYZ
	 C9FMGOv8JpFNE6MAdgLsWym6fGDXjmQLvaI6lnB8XOXvk8qxSvuaEL+ZmoTEGfvSLt
	 /dKiC1yG5z8oitJeomUwocF207ALh7TzyR/x1srpuItzKtXxeNaEnL+Ovb/aWz/iSw
	 Et6XR9GIAw2qA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v17 7/7] firmware: arm_rmm: Add wrappers for Realm
 related RMI commands
Reply-To: sashiko-reviews@lists.linux.dev
To: "Suzuki K Poulose" <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260907095942.1140734-8-suzuki.poulose@arm.com>
References: <20260907095942.1140734-1-suzuki.poulose@arm.com>
 <20260907095942.1140734-8-suzuki.poulose@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 07 Sep 2026 10:10:22 +0000
Message-Id: <20260907101022.DDDFD1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] RMI wrapper functions silently discard output registers on SMC cal=
l errors, preventing error recovery and leaking memory.
--

commit a6c85c25d264d328a0bb8014d88418e614ccef39
Author: Steven Price <steven.price@arm.com>

firmware: arm_rmm: Add wrappers for Realm related RMI commands

Introduce wrappers for the RMI functions needed for creating and managing
realm guests. This will be used by the KVM to manage the Realms.

> diff --git a/include/linux/arm-rmi-cmds.h b/include/linux/arm-rmi-cmds.h
> --- a/include/linux/arm-rmi-cmds.h
> +++ b/include/linux/arm-rmi-cmds.h

[ ... ]

> +static inline long rmi_rtt_data_map(unsigned long rd,
[ ... ]
> +{
[ ... ]
> +	ret =3D rmi_sro_execute(&regs);
> +
> +	if (ret =3D=3D RMI_SUCCESS && out_top)
> +		*out_top =3D regs.a1;

[Severity: High]
If the RMM returns an error like RMI_ERROR_RTT partway through, does this
discard the intermediate progress in regs.a1 by gating it on RMI_SUCCESS?

If out_top is lost, it seems KVM wouldn't know where the operation stopped,
making proper error recovery or partial mapping cleanup impossible.

[ ... ]

> +static inline long rmi_rtt_data_unmap(unsigned long rd,
[ ... ]
> +{
[ ... ]
> +	ret =3D rmi_sro_execute(&regs);
> +
> +	if (ret =3D=3D RMI_SUCCESS) {
> +		if (out_top)
> +			*out_top =3D regs.a1;
> +		if (out_range)
> +			*out_range =3D regs.a2;
> +		if (out_count)
> +			*out_count =3D regs.a3;
> +	}

[Severity: High]
Can this lead to a leak of physical pages?

When an error occurs (e.g., RMI_ERROR_RTT due to state conflicts), the RMM
populates the output registers with the number of successfully unmapped
pages. Because this is gated behind RMI_SUCCESS, losing out_count means KVM
loses track of how many physical pages were written to the output address
list.

[ ... ]

> +static inline long rmi_rtt_destroy(unsigned long rd,
[ ... ]
> +{
[ ... ]
> +	long ret =3D rmi_sro_execute(&regs);
> +
> +	if (ret =3D=3D RMI_SUCCESS) {
> +		if (out_rtt)
> +			*out_rtt =3D regs.a1;
> +		if (out_top)
> +			*out_top =3D regs.a2;
> +	}

[Severity: High]
Does discarding these outputs on error prevent diagnosing the destruction
failure?

If an RMI_ERROR_RTT occurs, the live IPA location is returned in the output
registers, but it looks like it gets dropped here since the return code is
not RMI_SUCCESS.

[ ... ]

> +static inline long rmi_rtt_unprot_unmap(unsigned long rd,
[ ... ]
> +{
[ ... ]
> +	long ret =3D rmi_sro_execute(&regs);
> +
> +	if (ret =3D=3D RMI_SUCCESS) {
> +		if (out_top)
> +			*out_top =3D regs.a1;
> +		if (out_range)
> +			*out_range =3D regs.a2;
> +		if (out_count)
> +			*out_count =3D regs.a3;
> +	}

[Severity: High]
Similar to the data unmap wrapper above, does dropping out_count on a
non-success return code leak physical pages for unprotected memory?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260907095942.1140=
734-1-suzuki.poulose@arm.com?part=3D7
