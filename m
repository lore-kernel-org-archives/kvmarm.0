Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ED7F355055;
	Thu, 24 Sep 2026 18:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790273020; cv=none; b=o+v1o6OM8nD0rbRp/uPUYDQdR6EMIHIZAQfiFvNfY5WF+RDm++nNaSUIQPgmIqeQB5gsq6tiz2aPFNGilWb8ZscsRti92qbOZyLn/zBfXu3Qm1igF3fzQvGDI7weTm/F/uFMmwXM6GqKxptEYzkvqKvoLx6lLnaOyZkR9SGQWzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790273020; c=relaxed/simple;
	bh=71px8qpq71xNX9a+eRwyGbRICfaSUVHKXe3pTEwOTuo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Ek6XfzHKw9zNfgt6Z668eCrKsszEP6Ph7UWE2IdPnNPi23GV6qDszYwwRNzY8Bg7/4u8IbZm76eQz9RZWUBNyWQKcVFgRqcmsYksAbyo5grTbW3exERjAcEpcIEsEcdftsEyEkN7bHn6HFX1+ORBQYjZ8wo/6JurbR5FyELJerU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jEPI82TS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jEPI82TS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 621381F000FF;
	Thu, 24 Sep 2026 18:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790273018;
	bh=71px8qpq71xNX9a+eRwyGbRICfaSUVHKXe3pTEwOTuo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jEPI82TST6TfKkt+os+JmZrkPleg68Fabps7GGpTpENY8It9JFa9BAHBIqSZaoFTp
	 YUFVmODrO+/5/ZQdAGyduT8dN8D5qhnhXA+CZcxI6MSHN/91CO/lmZnagdbvk/kwc6
	 TblgJSoo196ME4xA6l0ro56UL0trzc6KN4ddpzrYiZ+SruCdrd6Pb/fn7jTCs4DFq8
	 tH18FlI5zLyREJm7S6tHfnu7iveqUEZ8oMgtwXchSyVuBY0IWc5eXhkp1dySK32uKf
	 9mlKeAqUmaZKN/uvceUUYb2kwB34ON3NKNyjvtK28neZSqYME1W9yRO0HblPs3ZoJa
	 BwLHRbypR1cLA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 18/22] perf: arm_pmuv3: Handle IRQs for Partitioned
 PMU guest counters
Reply-To: sashiko-reviews@lists.linux.dev
To: "Colton Lewis" <coltonlewis@google.com>
Cc: kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org, kvm@vger.kernel.org, "Oliver
 Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>
In-Reply-To: <20260924172928.2110956-19-coltonlewis@google.com>
References: <20260924172928.2110956-1-coltonlewis@google.com>
 <20260924172928.2110956-19-coltonlewis@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 24 Sep 2026 18:03:37 +0000
Message-Id: <20260924180338.621381F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

> Because ARM hardware is not yet capable of direct PPI injection into
> guests, guest counters trigger physical PMU interrupts that must be
> handled by the host PMU interrupt handler.
>=20
> In armv8pmu_handle_irq(), clear the overflow flags in hardware for host
> counters, restrict host perf event handling to bits in cpuc->cntr_mask,
> and pass the overflow flags to kvm_pmu_handle_guest_irq(). The KVM hook
> clears the guest counter overflow flags in hardware and records them in
> the running vCPU's virtual PMOVSSET_EL0 register for subsequent guest
> interrupt injection.
>=20
> Additionally, provide kvm_pmu_host_start() and kvm_pmu_host_stop() so
> that armv8pmu_start() and armv8pmu_stop() toggle MDCR_EL2.HPME rather
> than PMCR_EL0.E when a partitioned guest's PMU state is loaded on the
> CPU.
>=20
> Signed-off-by: Colton Lewis <coltonlewis@google.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260924172928.2110=
956-1-coltonlewis@google.com?part=3D18

