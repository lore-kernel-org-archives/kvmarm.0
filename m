Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55AB6440623;
	Mon,  5 Oct 2026 09:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791192608; cv=none; b=ASOB4HCDAp7Z1Vo+Lb6QQZXL/Bi1ibAEDRVyoLnF/YSOCByyWoEdfaL8ymWK0Rlb4g8zB/AQxpJc0JV1UEju7ZAmUtX7TPGhMPvooY36UeNOqANIMTA8DHGys5hyCRiC5EFyScUC2lSImf342+uOHf+pfEaaz6h1peaVcW1ZzEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791192608; c=relaxed/simple;
	bh=YIWsSkgl1cNIyNIxr3UP6ukmUKqCnbIs4JH9TwdL4yY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Bgo6KCnMTjjB35u7gva0DHsThrM0ww5v5V2lhjpuz/iiGK6PcKINgvwFRLLGcAaDRx+uFF5AWaVOzCkADhkNZx/rgLhhrjwfxmdxldw+EeaJ5RiP6FUKuCSMz2DTB7GmydiUfAfbzzfrxMaVLqEyKvThfpRa7TJAgc2ZXJ0PD7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CpbA21gi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CpbA21gi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 928C41F000FF;
	Mon,  5 Oct 2026 09:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791192606;
	bh=YIWsSkgl1cNIyNIxr3UP6ukmUKqCnbIs4JH9TwdL4yY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CpbA21gixR9UJBW/hKfJG4+ecMLebSIP9GooFHUCjEgp4wI1qcfwPEcCHqd2uC5EO
	 ATqbCqxbpj5xgRCgdtRku9vSvjPO+9I2gFuBFzOTZt8FLqaYcqRIPQT1eK/0ExUVXK
	 s31kf8vRRC6pxLl1d7ELFEQxwcMmkt+yVkrT6KeD2QLpZCrbzG75T5I5f4ZQqEfAYg
	 ACS0h82J/vQ/HW2qUUM63HRiuF8QHscqCLhoaETTUR7n5OVxN4v4UQsh+CRxAEYYRo
	 j8tUaSDxdb4c7G1+ToqZErmQNCt1PTRgV4tiIaJv7k8lWbbuWsKKNG4J6SanBECr6W
	 py652TBipfIGg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v22 23/23] KVM: arm64: CCA: Control user register access
 for Realms
Reply-To: sashiko-reviews@lists.linux.dev
To: "Suzuki K Poulose" <suzuki.poulose@arm.com>
Cc: "Marc Zyngier" <maz@kernel.org>, kvm@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20261005090754.2140522-24-suzuki.poulose@arm.com>
References: <20261005090754.2140522-1-suzuki.poulose@arm.com>
 <20261005090754.2140522-24-suzuki.poulose@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 05 Oct 2026 09:30:06 +0000
Message-Id: <20261005093006.928C41F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] kvm: arm64: missing lifecycle checks for Realm configuration reg=
isters
--

commit c1323429b568607fedbbcbc78dbc0df5d8c3cfd9
Author: Jean-Philippe Brucker <jpb@kernel.org>
Subject: KVM: arm64: CCA: Control user register access for Realms

This commit restricts the host access to register states for a given Realm,
aligning with RMM restrictions. It exposes certain registers for initial
Realm parameter configuration, as well as specific core registers at creati=
on
or during specific exits.

[Severity: Medium]
In arch/arm64/kvm/guest.c within validate_realm_set_reg at line 769, the co=
de
returns true unconditionally for KVM_REG_ARM_ID_AA64DFR0_EL1 and
KVM_REG_ARM64_SVE_VLS. Does this allow an unprivileged VMM userspace process
to write to these Realm configuration registers even after the Realm
Descriptor has already been created? If the VMM calls KVM_SET_ONE_REG after
finalization, it appears KVM might silently accept the write and update its
software state, while the RMM ignores it. Could this lead to a silent state
desynchronization between KVM and the RMM?

[Severity: Medium]
Similarly, in arch/arm64/kvm/guest.c within kvm_realm_validate_core_reg at
line 86, the function returns true unconditionally for the PC register. The
comment above states that the PC can only be set before the realm is
activated. Without an explicit lifecycle check in this path, can the VMM
modify the PC via KVM_SET_ONE_REG even after the Realm Execution Context
has been activated?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261005090754.2140=
522-1-suzuki.poulose@arm.com?part=3D23
