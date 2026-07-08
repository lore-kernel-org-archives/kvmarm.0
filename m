Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD345202963
	for <kvmarm@lists.linux.dev>; Wed,  8 Jul 2026 23:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783551841; cv=none; b=Utjf5N2n9lv1Wr6HqrKpsv4J1PcNhpavst2tik6llN5hSy8BVn0AX4Mjbsriqwu5SRKujN0SWwttsp1bpXSeXHUVV9fWWi6JYk21MDfaFjiVuoQLe8GyNQ5w/GEToUqyLKnIQV/E4j1XROxDIFr2dST5RW8cHWOPTjmgHWekjJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783551841; c=relaxed/simple;
	bh=6IyvamalGy1yLiYwR++Bdew+3++nYXZnTKnSjkw5aJU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=hhND38uTj47Ej9nNK3g5twvoPzH3uTGCgt7rS+liBwJ7PXi0NWx2viUU565rtw3jVHu0t/kpTFqX45TshL5y7aD4Y2cvuDumuOfy2Ta8tUt3BrNCyRBWHjUC4PBwdO+q31y8T80FGZ1z2wp60SS5rABXOKEawcHa8kPurTIYuuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A9GZB9tc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A9GZB9tc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07B351F000E9;
	Wed,  8 Jul 2026 23:03:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783551840;
	bh=3Ua+xhXL0PFDMLwzqQXbI3q8pNVwT6nnyhwhanqlZmc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=A9GZB9tcouL49mh6wHncazvoXpe8KwLiAXoZcY3mKLmbww5XPyLcNGPrveJ6iqIEE
	 F5UHpxj1SCr7+deWikFVeOuGYrBR1eX/CpRYZKTyKBGWgfbdb5iLYiKAkPXTFDRj3P
	 60jx7nmeV1gatKGeh1CYEGd9ROeknqhUH7KhJbisCq9paaOqKaFNeua1aa0F9ydrZH
	 JZN1q1hau26pnj5wWFa46zaCbwbf2fIraqr8atSaM81LKWGIwMXQ1Bd4m1MMzsgPQr
	 4A0t1SqCjaF/peUemYRiHG+Q6y5OZiDIBoHY/wT5OjHsq0T7YIyGqSnxoczMCaQZ9X
	 O42ybC7VocDxg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 6.6 v2 1/6] arm64: sysreg: Add layout for
 ID_AA64MMFR4_EL1
Reply-To: sashiko-reviews@lists.linux.dev
To: "Colton Lewis" <coltonlewis@google.com>
Cc: kvmarm@lists.linux.dev, "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>
In-Reply-To: <20260708225124.4130846-2-coltonlewis@google.com>
References: <20260708225124.4130846-1-coltonlewis@google.com>
 <20260708225124.4130846-2-coltonlewis@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 08 Jul 2026 23:03:59 +0000
Message-Id: <20260708230400.07B351F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] The `EIESB` field in `ID_AA64MMFR4_EL1` is incorrectly defined a=
s a `SignedEnum` instead of an `UnsignedEnum`, which will break cross-CPU f=
eature resolution and capability detection.
--

--- Patch [1]: [PATCH 6.6 v2 1/6] arm64: sysreg: Add layout for ID_AA64MMFR=
4_EL1 ---
commit 553e432fbf7b950e883b1046b692639bcd77b3c1
Author: Marc Zyngier <maz@kernel.org>

arm64: sysreg: Add layout for ID_AA64MMFR4_EL1

ARMv9.5 has introduced ID_AA64MMFR4_EL1 with a bunch of new features. Add t=
he=20
corresponding layout.

Link: https://lore.kernel.org/r/20240122181344.258974-5-maz@kernel.org

> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
> index 76ce150e7347e..f7180d391f829 100644
> --- a/arch/arm64/tools/sysreg
> +++ b/arch/arm64/tools/sysreg
> @@ -1669,6 +1669,43 @@ UnsignedEnum	3:0	TCRX

[ ... ]

> +UnsignedEnum	11:8	ASID2
> +	0b0000	NI
> +	0b0001	IMP
> +EndEnum
> +SignedEnum	7:4	EIESB
> +	0b0000	NI
> +	0b0001	ToEL3
> +	0b0010	ToELx
> +	0b1111	ANY
> +EndEnum

[Severity: Medium]
Will defining EIESB as a SignedEnum cause issues with capability detection?

If this generates ID_AA64MMFR4_EL1_EIESB_SIGNED as true, it seems like
the cpufeature framework will extract and evaluate the 4-bit field 0b1111=20
(ANY) as -1.

Since -1 < 2 (ToELx), could this cause the kernel to fail to detect the ANY
error injection capability or resolve to the wrong capability level on
heterogeneous systems?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260708225124.4130=
846-1-coltonlewis@google.com?part=3D1
