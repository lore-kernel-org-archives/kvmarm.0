Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D77FE4C9DE3;
	Thu, 24 Sep 2026 17:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790272523; cv=none; b=X4t54lFpjrR/ooePPRRMl0uKUvImOEQu1oX5l7O69nimUT/e8jr5MHnamncZCx/G6IM6OWkdWGHJhCU4t17LXFdgEaU+Ecl08trvFsEv3qgp4XSSbfhrTW1YxhOWtjGvpabm1nqWO30vo5FNcjMCkFM6+zrbKhMcpVLbsibpHuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790272523; c=relaxed/simple;
	bh=sm/muZr0A27fe4h+phBSS5dAtT3McJ8wsNt6MrJKqLY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Gub2ZMwoZmTp5hsDEFtdnR8bmaIQCINa1lZZscVgGthbRjO9l5Fz6/2bLTyDiikQ9wYagqGKoUKsKpEmu7jrfM+QN7suyQUgzepn+FEvrfRRcw6mePsofWgU/S0R5Jp2Na8FKbCvL67TVvUk91ZF1Vay78f2+HllKSjhmozuBUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EXCUhphY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EXCUhphY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39F021F00893;
	Thu, 24 Sep 2026 17:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790272521;
	bh=sm/muZr0A27fe4h+phBSS5dAtT3McJ8wsNt6MrJKqLY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=EXCUhphYycEGMFeaBw+Nmoxpn7NTp+vOEyrAdVUeOywwhHW6NxDBHMakoFr3glz89
	 sgvLxuJx2YvxzvjW9rSB/b3QAvUdD7T3D/nbSPfQEN4kLeiTyKJIsv+/UXzGu1DK7T
	 7kDBenWnpTJON6yB7UTebIu8gNn6WoKdPGbC7J5dzbaWzcvw6c+4xe+MHX3mjFUI1y
	 Y2s9m0V7d5JKOHzU/dsJRJo+C9YieZwsJSEIngaRKVVRT1pxFKeskVS5TlyvUwUIu3
	 kycOt24WDhnY0a4cULOPgQ7c3+3m8gnaZBaff7QbNL6zBFZiTZcjd5Z9h8n7ZOKLSt
	 ScnpSr+L7eS/g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 12/22] KVM: arm64: Context swap Partitioned PMU guest
 registers
Reply-To: sashiko-reviews@lists.linux.dev
To: "Colton Lewis" <coltonlewis@google.com>
Cc: "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, kvm@vger.kernel.org, "Oliver
 Upton" <oupton@kernel.org>, linux-perf-users@vger.kernel.org
In-Reply-To: <20260924172928.2110956-13-coltonlewis@google.com>
References: <20260924172928.2110956-1-coltonlewis@google.com>
 <20260924172928.2110956-13-coltonlewis@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 24 Sep 2026 17:55:20 +0000
Message-Id: <20260924175521.39F021F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

> Save and restore newly untrapped registers that can be directly
> accessed by the guest when the PMU is partitioned.
>=20
> - PMEVCNTRn_EL0
> - PMCCNTR_EL0
> - PMSELR_EL0
> - PMCR_EL0
> - PMCNTEN_EL0
> - PMINTEN_EL1
>=20
> If we know we are not partitioned (that is, using the emulated vPMU),
> then return immediately. A later patch will make this lazy so the
> context swaps don't happen unless the guest has accessed the PMU.
>=20
> PMEVTYPER is handled in a following patch since we must apply the KVM
> event filter before writing values to hardware.
>=20
> PMOVS guest counters are cleared to avoid the possibility of
> generating spurious interrupts when PMINTEN is written. This is fine
> because the virtual register for PMOVS is always the canonical value.
>=20
> Signed-off-by: Colton Lewis <coltonlewis@google.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260924172928.2110=
956-1-coltonlewis@google.com?part=3D12

