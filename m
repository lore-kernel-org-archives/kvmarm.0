Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D530A4BEE4F;
	Thu, 24 Sep 2026 17:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790271845; cv=none; b=jCP1FxomrVcUhSnVcRY8gLkBo77zUjR07+J9wMLALDqNnLwwaKKH37k74o8zddUGuWQMsT7B0iB93rN84JmyHi0oWgszSXztx1f4RybYZRiIbOaNv7cwMD83J7D+GSXOTWId/nbhSdWTWdj6tX3+2rpkAJPmWglXQrDWpCD4hRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790271845; c=relaxed/simple;
	bh=2wTxbc3MUo0XmiLTF3/ZsX7N++K0wak+rwlTgp/XG2U=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=a7hcl81gkmuUcUlX5LTGQAkg8Ag1/hCfRTlcpmba6IGZmyO25knxySTInxDP6Du5UQWrjwL2csRs/62Fx2AbFkqrP6HbYH94Ux/HokUbCnoXt4iYq8sj/oHrUzrwYapXX6zBz31svDcJh18TdCjQkmsTNHSCyREltWQwUEFjZN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H1t56tH0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H1t56tH0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22BF11F00893;
	Thu, 24 Sep 2026 17:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790271843;
	bh=s6EOAkWe93zXBDvJVeWSfnv+/pS4btqTvKm/M6xpAZk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=H1t56tH0bHP2ENW3WC8MTfeFwGWAJD8Iu3offXPB4Ir/pJWQCapDrG3KrDg3D0bgj
	 9jPhKAD5sKh6x9XGrgp5hMNyLWhtViIzUs9fqk5WXogfSFPH/G8VdiI7LdBIlijoW8
	 4KQVMi7c2H1T6SUGYPyN2GU1SY0JfNtsQrB0FtB6ODVtAL/zdQoFX+g35f8L6fE2QP
	 /yendT6sR044Wm3Colw6n1CZAj+qsNfhsNUgKjt8tbCIL6JCCwBPK8dQbsTtoX9NDP
	 9KXSR1lZYlYIGi1JZNKGFSXOy+HzXCDSlQM2yzd9Slf1vEiECoM3HOL9V0YC8C//nJ
	 Q31A+VNQL0uog==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 08/22] KVM: arm64: Add initial scaffolding for
 Partitioned PMU
Reply-To: sashiko-reviews@lists.linux.dev
To: "Colton Lewis" <coltonlewis@google.com>
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, linux-perf-users@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev
In-Reply-To: <20260924172928.2110956-9-coltonlewis@google.com>
References: <20260924172928.2110956-1-coltonlewis@google.com>
 <20260924172928.2110956-9-coltonlewis@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 24 Sep 2026 17:44:02 +0000
Message-Id: <20260924174403.22BF11F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

> Add the foundational helpers for Partitioned PMU support in
> arch/arm64/kvm/pmu-direct.c:
> - has_host_pmu_partition_support() and has_kvm_pmu_partition_support()
>   to check VHE and PMUv3 availability.
> - kvm_pmu_partition_enable() and kvm_pmu_is_partitioned() to track per-VM
>   partitioning state via KVM_ARCH_FLAG_PARTITION_PMU_ENABLED.
> - kvm_pmu_host_counter_mask() and kvm_pmu_guest_counter_mask() to
>   compute the bitmasks of host-reserved (HPMN..N-1) and guest-reserved
>   (0..HPMN-1 and PMCCNTR_EL0) hardware counters.
>=20
> Signed-off-by: Colton Lewis <coltonlewis@google.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260924172928.2110=
956-1-coltonlewis@google.com?part=3D8

