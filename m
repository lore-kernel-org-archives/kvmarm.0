Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96DCB3CDBB1
	for <kvmarm@lists.linux.dev>; Wed, 15 Jul 2026 08:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784103852; cv=none; b=KyfRFxVbrsfSVd9pjhOWByFlYsQs0k+Ugp2dwrsJeaei9rpyU8SMn0xvtMGjo8unYqMxYv7TDqR4gk2tiJ9e/71F6P0+6Zyki9dpefwg1J9O46VD4jaz6NVAtHLc+7XeUb/+RrKZplEjOQn/g6arp5k09vKaw9SuqvXW1MzHXS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784103852; c=relaxed/simple;
	bh=qeRkCUPxrSwKbSS2Yk2lOyfBRAA957XxfacJczLZ/FU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=T5IB3X1F5MurLI1F86KbM8Gq26SChkZ67sjRfP2rtSeM4JZn3RD67X27I4p14ML6qwiCiAefRL0TLdXO158du95ZW0mOSqGr/6Cyx68Ewg93cl55LK6YreoNtjikeCLckVlhwkedd6WwpUJ/OijgvfJP40Q2hB3aSAiN5ihRqzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FsJGv2Qo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FsJGv2Qo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3987F1F000E9;
	Wed, 15 Jul 2026 08:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784103851;
	bh=qeRkCUPxrSwKbSS2Yk2lOyfBRAA957XxfacJczLZ/FU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FsJGv2Qo+hDXZ6vRPiiex4erZMjRicvu7tG1y3K94hmD9/QKVcnJMuYmLs13V6OaS
	 AGb6TdlZlEtzCHSFAOZgr2JROzsIBx/UmTUOSaO8VS4Xj5X3SMtQrnJDD0vUw8WmB9
	 ZxHLFBaJiZ7kFYc54QsNEudr20uS5GKN37ak3vwcNXXG9hfZIOxi5UNBNWk/Y087PY
	 cJhI/hOKJjDkqJ5DPZta5HsI9JdVFbDYKEksw+lnemxEGrIly6JuwHykQt2JIXVKpV
	 sGIfRI45ztQMlko9ixgeXr0sIspMhl3w106A7yqCcBiRfPF/FnpdmoVygK3Pxl+8hR
	 E9wcRUTSplSiw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 4/8] KVM: arm64: Move PSCI helper functions to a
 shared header
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fuad Tabba" <fuad.tabba@linux.dev>
Cc: "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>
In-Reply-To: <20260715081238.1891918-5-fuad.tabba@linux.dev>
References: <20260715081238.1891918-1-fuad.tabba@linux.dev>
 <20260715081238.1891918-5-fuad.tabba@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 15 Jul 2026 08:24:10 +0000
Message-Id: <20260715082411.3987F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] The header `include/kvm/arm_psci.h` is not self-contained because i=
t uses `vcpu_set_reg()` and `vcpu_get_reg()` without including `<asm/kvm_em=
ulate.h>`.
--

--- Patch [4]: [PATCH v6 4/8] KVM: arm64: Move PSCI helper functions to a s=
hared header ---
(Note: The format of this report has been altered to a free-form summary wi=
thout direct patch quotation due to automated system recitation restriction=
s.)

commit 41ab99d154503d49e14931a3e9bb6c067e760b44
Author: Fuad Tabba <fuad.tabba@linux.dev>

KVM: arm64: Move PSCI helper functions to a shared header

This patch moves several PSCI helper functions out of psci.c and into the
shared include/kvm/arm_psci.h header. It renames the file-local
psci_affinity_mask() to kvm_psci_affinity_mask() to support follow-up work
for protected-guest PSCI calls.

[Severity: Low]
In the newly moved kvm_psci_narrow_to_32bit() function within
include/kvm/arm_psci.h, the code makes use of vcpu_set_reg() and
vcpu_get_reg(). Does this new header location need an explicit include
for asm/kvm_emulate.h to ensure it remains self-contained?

If a C file includes kvm/arm_psci.h without having already included
asm/kvm_emulate.h, it looks like it might lead to a build failure due to
missing function declarations.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260715081238.1891=
918-1-fuad.tabba@linux.dev?part=3D4
