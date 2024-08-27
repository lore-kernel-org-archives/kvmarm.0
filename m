Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D7E9158DD0
	for <kvmarm@lists.linux.dev>; Tue, 27 Aug 2024 08:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724749132; cv=none; b=FMMzywtVUIwCgs/woRXsflV8LYOGhwqRGUvFHRSo5P26uwquTVhxvVHYezdpAJ1bbQWefKEdAJfWn5h8b6SpMCbPoImkyxpDGnpYjRr+0wGmgNeNbF2LLM4ihDrVN878Y1j5oNfA5CdFJHiaL14uV9+MBEsyan3zLwRUnvqKuJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724749132; c=relaxed/simple;
	bh=oNdOviKyuIrr5vkcgKfovQ1IBbsfJ1aSy7l73C8Cxj4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=pwa+ps+JXRF8LKnU0PS12+hMiVFzDq5zM31Ioivkx+vHcAQ1CjU1tSCbVAZBJORSHlQDLrl9xkcMS7wpFKGVQxllp7d4112ZXzhwDPm7b0VKwj+jR1BHn39OGADLZZXCjfy7epjyTRK2N+35zimI09rUrr99Gv/rIU9xJRFFnuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4WtLzs4k2BzyRDN;
	Tue, 27 Aug 2024 16:58:17 +0800 (CST)
Received: from kwepemm000007.china.huawei.com (unknown [7.193.23.189])
	by mail.maildlp.com (Postfix) with ESMTPS id C6032140137;
	Tue, 27 Aug 2024 16:58:46 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 kwepemm000007.china.huawei.com (7.193.23.189) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 27 Aug 2024 16:58:45 +0800
Received: from lhrpeml500005.china.huawei.com ([7.191.163.240]) by
 lhrpeml500005.china.huawei.com ([7.191.163.240]) with mapi id 15.01.2507.039;
 Tue, 27 Aug 2024 09:58:43 +0100
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: James Morse <james.morse@arm.com>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>
CC: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>, yuzenghui <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
	Jing Zhang <jingzhangos@google.com>, "Wangzhou (B)" <wangzhou1@hisilicon.com>
Subject: RE: [PATCH v3 4/6] KVM: arm64: Disable MPAM visibility by default and
 ignore VMM writes
Thread-Topic: [PATCH v3 4/6] KVM: arm64: Disable MPAM visibility by default
 and ignore VMM writes
Thread-Index: AQHae7EcWBfUhFLWfESLuHqxbBJIrbHdahYAgF5ahfA=
Date: Tue, 27 Aug 2024 08:58:43 +0000
Message-ID: <82695efb73ca463b904aa49a595be06c@huawei.com>
References: <20240321165728.31907-1-james.morse@arm.com>
 <20240321165728.31907-5-james.morse@arm.com>
 <e22f30c045b64f3da68fb0aa6c0b4e2c@huawei.com>
In-Reply-To: <e22f30c045b64f3da68fb0aa6c0b4e2c@huawei.com>
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

Hi James,

> -----Original Message-----
> From: Shameerali Kolothum Thodi
> Sent: Friday, June 28, 2024 9:11 AM
> To: 'James Morse' <james.morse@arm.com>; linux-arm-
> kernel@lists.infradead.org; kvmarm@lists.linux.dev
> Cc: Marc Zyngier <maz@kernel.org>; Oliver Upton <oliver.upton@linux.dev>;
> Suzuki K Poulose <suzuki.poulose@arm.com>; yuzenghui
> <yuzenghui@huawei.com>; Catalin Marinas <catalin.marinas@arm.com>;
> Will Deacon <will@kernel.org>; Jing Zhang <jingzhangos@google.com>;
> Wangzhou (B) <wangzhou1@hisilicon.com>
> Subject: RE: [PATCH v3 4/6] KVM: arm64: Disable MPAM visibility by defaul=
t
> and ignore VMM writes
 (vcpu, rd, user_val);
> > +}
>=20
> Commit 14e270fa5c4c(arm64/cpufeature: Add remaining feature bits in
> ID_AA64PFR1 register")
> exposes the MPAMFRAC filed in in AA64PFR1_EL1. Don't we need a similar
> handling for that
> as well to handle the FEAT_MPAMv0p1 case?
>=20
> Also any chance you plan to respin this series soon? We do have hardware
> that benefits from this
> series.

Just a gentle ping to see if you have plans to respin this series soon or n=
ot.=20
Please let me know, if I can be of any help. We do have platforms that
differ in their MPAM features and that breaks migration.=20

Thanks,
Shameer
