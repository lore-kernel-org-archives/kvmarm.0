Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80E5C277C8B
	for <kvmarm@lists.linux.dev>; Wed, 23 Jul 2025 08:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753260401; cv=none; b=UUgSw9IgFE37D2VvFLYv+K0mKlIEEUv5cD2807cCeBm+EiEdw57CJfaNqmTXLwf13PFbuKN/i+PNTGfB+EDgnvQ9v4o1o7UpDxliysH78wPCo5E3eFk0dLjMcOleNpFp9RyyzQUfdX9vO4zLPDovFcYk6HAvL8Y8HrSKC+uAipU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753260401; c=relaxed/simple;
	bh=UjZ2hpup/T/Wn8vDi4LQ5YZvaZ3lTOBS5mcYZ2jtxn8=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=YqtxANVtE3IrPttPRBTjd3mNaSUZsVvImIQcHk6pV7S0mingGRfAaoM5chmXAEQPSpNov9vgvK3+65RkiKtLIwLHazeJEs3SBQVf2i02vpkfpkGbhuJpD5p3CRkNjaqZFMYHYdMVJ7Y8w59ekR6rQBVdabQ5Q1SW0dKcz3KOf0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=PcNSGjeu; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="PcNSGjeu"
Content-Type: text/plain;
	charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1753260395;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6oxB5PSG3rSVBd3uKBa9I0cO8eKhcw0Hi0sAamyaJ6w=;
	b=PcNSGjeun8cNyHh7w9mXfz6xt7fkCyGGQ28JTMCbfNmUSyyQmZoR+CEfikjwPIwT3nrNZg
	izoee36/x89idG0gpMz4tGLsZCKzotxd1wcCnaCY7GmIIGGowtBNw08PWtpUdLaH85v1QP
	4+lqR8h1ReVVTIikO6ztayivqDq2AV0=
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.600.51.1.1\))
Subject: Re: [PATCH 4/4] KVM: arm64: selftest: vgic-v3: Add basic GICv3 sysreg
 userspace access test
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Itaru Kitayama <itaru.kitayama@linux.dev>
In-Reply-To: <87qzy7tja1.wl-maz@kernel.org>
Date: Wed, 23 Jul 2025 17:46:14 +0900
Cc: kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org,
 kvm@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Zenghui Yu <yuzenghui@huawei.com>,
 Eric Auger <eric.auger@redhat.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <576D387F-15E6-46C1-BA32-34FB64551CBA@linux.dev>
References: <20250718111154.104029-1-maz@kernel.org>
 <20250718111154.104029-5-maz@kernel.org> <aIBseJ3aO+hMVAee@vm4>
 <87qzy7tja1.wl-maz@kernel.org>
To: Marc Zyngier <maz@kernel.org>
X-Migadu-Flow: FLOW_OUT



> On Jul 23, 2025, at 17:15, Marc Zyngier <maz@kernel.org> wrote:
>=20
> On Wed, 23 Jul 2025 06:00:40 +0100,
> Itaru Kitayama <itaru.kitayama@linux.dev> wrote:
>>=20
>> On Fri, Jul 18, 2025 at 12:11:54PM +0100, Marc Zyngier wrote:
>>> We have a lot of more or less useful vgic tests, but none of them
>>> tracks the availability of GICv3 system registers, which is a bit
>>> annoying.
>>>=20
>>> Add one such test, which covers both EL1 and EL2 registers.
>>>=20
>>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>>=20
>> I've tested this selftest on the RevC FVP with kvm-arm.mode=3Dnested.
>>=20
>> Tested-by: Itaru Kitayama <itaru.kitayama@fujitsu.com>
>>=20
>> Running GIC_v3 tests.
>> __vm_create: mode=3D'PA-bits:40,  VA-bits:48,  4K pages' type=3D'0', =
pages=3D'672'
>> __vm_create: mode=3D'PA-bits:40,  VA-bits:48,  4K pages' type=3D'0', =
pages=3D'657'
>> __vm_create: mode=3D'PA-bits:40,  VA-bits:48,  4K pages' type=3D'0', =
pages=3D'672'
>> __vm_create: mode=3D'PA-bits:40,  VA-bits:48,  4K pages' type=3D'0', =
pages=3D'672'
>> __vm_create: mode=3D'PA-bits:40,  VA-bits:48,  4K pages' type=3D'0', =
pages=3D'672'
>> __vm_create: mode=3D'PA-bits:40,  VA-bits:48,  4K pages' type=3D'0', =
pages=3D'672'
>> __vm_create: mode=3D'PA-bits:40,  VA-bits:48,  4K pages' type=3D'0', =
pages=3D'682'
>> __vm_create: mode=3D'PA-bits:40,  VA-bits:48,  4K pages' type=3D'0', =
pages=3D'682'
>> __vm_create: mode=3D'PA-bits:40,  VA-bits:48,  4K pages' type=3D'0', =
pages=3D'657'
>> __vm_create: mode=3D'PA-bits:40,  VA-bits:48,  4K pages' type=3D'0', =
pages=3D'672'
>> __vm_create: mode=3D'PA-bits:40,  VA-bits:48,  4K pages' type=3D'0', =
pages=3D'657'
>=20
> I have no idea what you tested it on, because I get none of this
> nonsense.
>=20
> Where is it coming from?

=46rom lib/kvm_util.c file __vm_create()=E2=80=99s pr_debug().

Anyway, I rebuilt the kernel your recent two patch sets on top of =
kvm-next/next and did the test.=20

# ./arm64/vgic_init
Random seed: 0x6b8b4567
Running GIC_v3 tests.
SKIP SYS_ICC_AP0R1_EL1 for read
SKIP SYS_ICC_AP0R1_EL1 for write
SKIP SYS_ICC_AP0R2_EL1 for read
SKIP SYS_ICC_AP0R2_EL1 for write
SKIP SYS_ICC_AP0R3_EL1 for read
SKIP SYS_ICC_AP0R3_EL1 for write
SKIP SYS_ICC_AP1R1_EL1 for read
SKIP SYS_ICC_AP1R1_EL1 for write
SKIP SYS_ICC_AP1R2_EL1 for read
SKIP SYS_ICC_AP1R2_EL1 for write
SKIP SYS_ICC_AP1R3_EL1 for read
SKIP SYS_ICC_AP1R3_EL1 for write
SKIP SYS_ICH_AP0R1_EL2 for read
SKIP SYS_ICH_AP0R1_EL2 for write
SKIP SYS_ICH_AP0R2_EL2 for read
SKIP SYS_ICH_AP0R2_EL2 for write
SKIP SYS_ICH_AP0R3_EL2 for read
SKIP SYS_ICH_AP0R3_EL2 for write
SKIP SYS_ICH_AP1R1_EL2 for read
SKIP SYS_ICH_AP1R1_EL2 for write
SKIP SYS_ICH_AP1R2_EL2 for read
SKIP SYS_ICH_AP1R2_EL2 for write
SKIP SYS_ICH_AP1R3_EL2 for read
SKIP SYS_ICH_AP1R3_EL2 for write

Thanks,
Itaru.

> M.
>=20
> --=20
> Jazz isn't dead. It just smells funny.


