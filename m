Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 784B01D097C
	for <kvmarm@lists.linux.dev>; Thu, 17 Oct 2024 08:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729154075; cv=none; b=SUY++27NTEtueNnMzJ2Ifu1mr5v7WtN0mncJ8ke/8ZUdNr6UCqoIkMr8l/fiRX0/7veWG7BBYrWmbI39Sf+VTq/eItPiq7wN9ZvwQ7K4cefA5YnoVr0ZHOXNiz6cM3fQIhAxXuIo6/mzVePGtHgZisqp3oWuLLmhgAl6DyXVMpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729154075; c=relaxed/simple;
	bh=TGBTVv9vq43mhZlE3SdBIOxvPyhhcU3tXboJajTa2u4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=KMxfrtZjrAuXCa1gkL0diwfr/LFZFGeUpfqN8SRxM74T8EkJlrz4PXydsSQghNOO1yuXsOPPjN2l4AwaekPbAqw9RZzJPCpP/LjpQh9TyOs1wziUYxEa+n4KrqUwxtttRm3IeS/nowQgfeRnbpCMgXgQ9WjiLRp5mc6c81Ao+y0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4XTh1z1DjMzQrfx;
	Thu, 17 Oct 2024 16:33:43 +0800 (CST)
Received: from kwepemm000006.china.huawei.com (unknown [7.193.23.237])
	by mail.maildlp.com (Postfix) with ESMTPS id 827E5140118;
	Thu, 17 Oct 2024 16:34:28 +0800 (CST)
Received: from frapeml500008.china.huawei.com (7.182.85.71) by
 kwepemm000006.china.huawei.com (7.193.23.237) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 17 Oct 2024 16:34:27 +0800
Received: from frapeml500008.china.huawei.com ([7.182.85.71]) by
 frapeml500008.china.huawei.com ([7.182.85.71]) with mapi id 15.01.2507.039;
 Thu, 17 Oct 2024 10:34:25 +0200
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: Joey Gouly <joey.gouly@arm.com>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>
CC: "anshuman.khandual@arm.com" <anshuman.khandual@arm.com>,
	"james.morse@arm.com" <james.morse@arm.com>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>, Suzuki K Poulose
	<suzuki.poulose@arm.com>, yuzenghui <yuzenghui@huawei.com>, Jing Zhang
	<jingzhangos@google.com>, Catalin Marinas <catalin.marinas@arm.com>, "Will
 Deacon" <will@kernel.org>
Subject: RE: [PATCH v5 0/7] KVM: arm64: Hide unsupported MPAM from the guest
Thread-Topic: [PATCH v5 0/7] KVM: arm64: Hide unsupported MPAM from the guest
Thread-Index: AQHbHwexicx1ebZGbU6GNf483hgb+7KKnx3A
Date: Thu, 17 Oct 2024 08:34:25 +0000
Message-ID: <bd62b87d2a1746e39c4fc6a6fde8c98e@huawei.com>
References: <20241015133923.3910916-1-joey.gouly@arm.com>
In-Reply-To: <20241015133923.3910916-1-joey.gouly@arm.com>
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
> From: Joey Gouly <joey.gouly@arm.com>
> Sent: Tuesday, October 15, 2024 2:39 PM
> To: linux-arm-kernel@lists.infradead.org; kvmarm@lists.linux.dev
> Cc: anshuman.khandual@arm.com; james.morse@arm.com;
> joey.gouly@arm.com; Marc Zyngier <maz@kernel.org>; Oliver Upton
> <oliver.upton@linux.dev>; Suzuki K Poulose <suzuki.poulose@arm.com>;
> yuzenghui <yuzenghui@huawei.com>; Jing Zhang
> <jingzhangos@google.com>; Shameerali Kolothum Thodi
> <shameerali.kolothum.thodi@huawei.com>; Catalin Marinas
> <catalin.marinas@arm.com>; Will Deacon <will@kernel.org>
> Subject: [PATCH v5 0/7] KVM: arm64: Hide unsupported MPAM from the
> guest

I did basic sanity tests with this series on a HiSilicon platform that has =
MPAM support and
it looks fine.

FWIW,
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>

Thanks,
SHameer
