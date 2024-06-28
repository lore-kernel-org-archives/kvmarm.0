Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDA67145334
	for <kvmarm@lists.linux.dev>; Fri, 28 Jun 2024 08:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719563032; cv=none; b=ZDclcFUlklCdJG8epBD8EEtwZGpfDPZPJ+WpblypeQRmIwwIb2UAj0in1issi9fDVB852yWC/0BV8AjYiynjjaKsk0rzzT68uv2dvhwxrGFK9yrLwc2l07l7ePWM65CJd73FNF4KiTZ1L/JKaCEJUfepP+OPPpNj/PIH0Dz9gs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719563032; c=relaxed/simple;
	bh=q5qxoQbok8NLcAy7qNuLyz67EJN4COtEkjW7zZ4HwYc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Osc0+sKmgLbihQVvYIdaIOGNTfc/joDX0w+/LvSQHdrBMxoA63kycWfl84feDZ/8kYhJ52kce+jyZc6otdA2vrONtJorUZs/U42Lk+nuoxtqz80QfX7Neh7rdTAGRpvydTFkxdepEl3zVtEaf8YqExJsG4Kf/S0H6+Y6ziLBEiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4W9T3W6c9GznY0p;
	Fri, 28 Jun 2024 16:23:35 +0800 (CST)
Received: from kwepemd100011.china.huawei.com (unknown [7.221.188.204])
	by mail.maildlp.com (Postfix) with ESMTPS id 061CC14037B;
	Fri, 28 Jun 2024 16:23:45 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 kwepemd100011.china.huawei.com (7.221.188.204) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Fri, 28 Jun 2024 16:23:44 +0800
Received: from lhrpeml500005.china.huawei.com ([7.191.163.240]) by
 lhrpeml500005.china.huawei.com ([7.191.163.240]) with mapi id 15.01.2507.039;
 Fri, 28 Jun 2024 09:23:42 +0100
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: James Morse <james.morse@arm.com>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>
CC: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>, yuzenghui <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
	Jing Zhang <jingzhangos@google.com>, "Wangzhou (B)" <wangzhou1@hisilicon.com>
Subject: RE: [PATCH v3 2/6] arm64: cpufeature: discover CPU support for MPAM
Thread-Topic: [PATCH v3 2/6] arm64: cpufeature: discover CPU support for MPAM
Thread-Index: AQHae7EdUanKGVVahEKqsfZWh2WHurHdb8Pg
Date: Fri, 28 Jun 2024 08:23:42 +0000
Message-ID: <b61717873ad84b5d874a5b0b502208a9@huawei.com>
References: <20240321165728.31907-1-james.morse@arm.com>
 <20240321165728.31907-3-james.morse@arm.com>
In-Reply-To: <20240321165728.31907-3-james.morse@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0



> -----Original Message-----
> From: linux-arm-kernel <linux-arm-kernel-bounces@lists.infradead.org> On
> Behalf Of James Morse
> Sent: Thursday, March 21, 2024 4:57 PM
> To: linux-arm-kernel@lists.infradead.org; kvmarm@lists.linux.dev
> Cc: Marc Zyngier <maz@kernel.org>; Oliver Upton <oliver.upton@linux.dev>;
> Suzuki K Poulose <suzuki.poulose@arm.com>; yuzenghui
> <yuzenghui@huawei.com>; Catalin Marinas <catalin.marinas@arm.com>; Will
> Deacon <will@kernel.org>; Jing Zhang <jingzhangos@google.com>; James
> Morse <james.morse@arm.com>
> Subject: [PATCH v3 2/6] arm64: cpufeature: discover CPU support for MPAM
>=20
> ARMv8.4 adds support for 'Memory Partitioning And Monitoring' (MPAM)
> which describes an interface to cache and bandwidth controls wherever
> they appear in the system.
>=20
> Add support to detect MPAM. Like SVE, MPAM has an extra id register that
> describes some more properties, including the virtualisation support,
> which is optional. Detect this separately so we can detect
> mismatched/insane systems, but still use MPAM on the host even if the
> virtualisation support is missing.
>=20
> MPAM needs enabling at the highest implemented exception level, otherwise
> the register accesses trap. The 'enabled' flag is accessible to lower
> exception levels, but its in a register that traps when MPAM isn't enable=
d.
> The cpufeature 'matches' hook is extended to test this on one of the
> CPUs, so that firmware can emulate MPAM as disabled if it is reserved
> for use by secure world.
>=20
> Secondary CPUs that appear late could trip cpufeature's 'lower safe'
> behaviour after the MPAM properties have been advertised to user-space.
> Add a verify call to ensure late secondaries match the existing CPUs.
>=20
> (If you have a boot failure that bisects here its likely your CPUs
> advertise MPAM in the id registers, but firmware failed to either enable
> or MPAM, or emulate the trap as if it were disabled)
>=20
> Signed-off-by: James Morse <james.morse@arm.com>
> ---


> @@ -2852,6 +2912,15 @@ static const struct arm64_cpu_capabilities
> arm64_features[] =3D {
>  		ARM64_CPUID_FIELDS(ID_AA64MMFR0_EL1, TGRAN16,
> 52_BIT)
>  #endif
>  #endif
> +#endif
> +#ifdef CONFIG_ARM64_MPAM
> +	{
> +		.desc =3D "Memory Partitioning And Monitoring",
> +		.type =3D ARM64_CPUCAP_SYSTEM_FEATURE,
> +		.capability =3D ARM64_MPAM,
> +		.matches =3D test_has_mpam,
> +		.cpu_enable =3D cpu_enable_mpam,
> +		ARM64_CPUID_FIELDS(ID_AA64PFR0_EL1, MPAM, 1)
>  	},
>  #endif

This one gives me a compile error as seems to miss the" }," for the above
ARM64_VA_BITS_52. Please check.

Thanks,
Shameer
