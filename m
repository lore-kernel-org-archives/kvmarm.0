Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013049.outbound.protection.outlook.com [40.107.159.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 437EE375F8A
	for <kvmarm@lists.linux.dev>; Thu, 19 Mar 2026 11:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.49
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773920205; cv=fail; b=a8jDu4c8eLwTK66xnwG9nN/CE4Kn5sDDg2GzVivmvrR9jbrPBfh5eN/z2VZThU3+SjASwJ8Bw5f6yAl0GU1hzDfd64w/IVjN4GuxdCrhXCKZOY+pXQb7ctjJVh8vc6diUOzFOdTudtv8sVIFYnsBqo2yUzzfGVHa4DePXPrtURc=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773920205; c=relaxed/simple;
	bh=2LU0HIHsdOSzcSRD7Q1roROrouwKSufk78a1siZtEho=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=lGImt1/280Pf9QX4L1DZUy0X8XuQo/+rCMERKfFWopps6AF5vLcbYuzZT6jGKtvBrsv+t/2PaZLiFSOllqe9nMdulgOG7WPI1cAxUAf826/qhl6Vm+umwy+g4mZMC6hvYPqcj0dmwavqWRHYM0A+RHK44AaSxDYffsCAINHyTwo=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=HVb4FwZf; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=HVb4FwZf; arc=fail smtp.client-ip=40.107.159.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="HVb4FwZf";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="HVb4FwZf"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=QqONcVjC4KDuSRyFUK2Hqv9h+HwM6Z3wR3rt33NIVRts+J9Unlqkuyle4rCxNbHpdWWr/T//UUuLE1v3U1amqPSgtoYPhbJh4sk2Al1xxjSbipDYzPkOYAiNaRz3YN0mPyvTpzM9llXPgAe8rLbPAYt6h9a5eTIHjTMYYFy9drIZ8UMlpejudjjQZ8J96xMNd4jj+VOWgsYwCsw3TpKjRbx+I6wgfHbAr4L0rmhjxzHyDN1GucOYhmCrY/X8rR03hWWHDhmr6Clmh05S9vjTu6BNLHv/6/5Qfpon2kc3jSobS5S8E1W4YR4e8c5dCM+REE6AJ9/Bz8mfIQQn5W19+w==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2LU0HIHsdOSzcSRD7Q1roROrouwKSufk78a1siZtEho=;
 b=jms6+9PQ6TSWz5TavxKrsrlEKy4f5yd0IPJzG73/p+XkEeZxzkFi5ok6jHSE7XYgjt0gR5f6gGY588lyeKhMO4SKbR+pE1NDLxkGAaSrSMSCGLHJgolRHw0lmrlMuxnG40iop5tAOHwHJ2MKngaoGLreGDQN4YImwsuTr1kZlllz76D0MdjLeL4TRYTy58DsLch81MnoMvjQKLyRfjGF/0zI6sbrvpfn+FqmVSEAVxzEd9ALwfWhoCsX/dO3cG8vFzSnrjrNujDuF33j7ucvElSV6yKyyqVHvCJ6GddT+H3gGcgWSemSYKPmp978BW8l/1HuTy6EOXts10/qz5HZ0Q==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=huawei.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2LU0HIHsdOSzcSRD7Q1roROrouwKSufk78a1siZtEho=;
 b=HVb4FwZfdvYjIgYDRBIefg5vIqKfyb4tb+ADrat5hQukTsz4QFE32rGmhKgyHm6FipSDudre5JK7RYoeIflpo/CLw/2no4Er8wNRFmBZfLFQ2ysa6Iq9T8khs5zViGtJrNVQn+wFAklH0Ng18gXloIQ7UWKP5S9yVXL8miPk9l8=
Received: from AS9PR06CA0646.eurprd06.prod.outlook.com (2603:10a6:20b:46f::14)
 by PAVPR08MB9746.eurprd08.prod.outlook.com (2603:10a6:102:31d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Thu, 19 Mar
 2026 11:36:35 +0000
Received: from AMS1EPF00000049.eurprd04.prod.outlook.com
 (2603:10a6:20b:46f:cafe::46) by AS9PR06CA0646.outlook.office365.com
 (2603:10a6:20b:46f::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.27 via Frontend Transport; Thu,
 19 Mar 2026 11:36:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS1EPF00000049.mail.protection.outlook.com (10.167.16.133) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.19
 via Frontend Transport; Thu, 19 Mar 2026 11:36:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=is1EbZhDJ5DD/FNRBBOON+FZjk+adgO4H7JcEX+LMg04KpH+eb1aOqqy93Av/U02Uk2hFtNucs4PHncq4CA2C5mzb/u9j7cmyZjGBW0T8Zxg7xhlEJ9NICZ0zZuBmfftVoWCGhcfPDc0FqtdrgNv3k046k98bPEva1iiq0Q9VhCgQIwVCOhqxWZLYsv+dPKH3RMEEYbP8UK3WZkRdFg9VC9YXQwe9lZ75x2v48u1P6JIk1KL3Pavxcgz0I1cCZjqCF/K3CWTPrQ7oezhpjEicjrsKDLgBF/bqsroBVWXd8ivVGfGoSDZ4UjcziV7OeLMTg+A3jaNNTbzmLYa8S1h6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2LU0HIHsdOSzcSRD7Q1roROrouwKSufk78a1siZtEho=;
 b=TsXOotvcAX/RIFfWr6d1PqnpYLkLYI2XDkyd3ALALygS0QH45StHN2b4FKsRBviM6aCj9n0m41p4NTp8UrSrQVMRskDyrrWrXmFoz+otpBFDEg27pfwyFhQbsQajY6UklwR0Mzw4RY9tsWm2AgUoniIAVIkUNegN52QGH7tu6Wjs2sy2+E0ika84daXNvASOkh/AEQSbT2prHKhQxa/3hJ2Ecwavrwj15nfye89RTsLdt0dEe4eaaIqhiu2Nhlqtl5EI9p9AmJDH5E0d3agcLcLAFvIpL+0d1inJvBuPKE4YTLamvzthZclsg0z6IhJR9cymMZMmaqhnbbxuG7TzVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2LU0HIHsdOSzcSRD7Q1roROrouwKSufk78a1siZtEho=;
 b=HVb4FwZfdvYjIgYDRBIefg5vIqKfyb4tb+ADrat5hQukTsz4QFE32rGmhKgyHm6FipSDudre5JK7RYoeIflpo/CLw/2no4Er8wNRFmBZfLFQ2ysa6Iq9T8khs5zViGtJrNVQn+wFAklH0Ng18gXloIQ7UWKP5S9yVXL8miPk9l8=
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com (2603:10a6:20b:504::10)
 by DBBPR08MB5930.eurprd08.prod.outlook.com (2603:10a6:10:200::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Thu, 19 Mar
 2026 11:35:32 +0000
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27]) by AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27%6]) with mapi id 15.20.9723.018; Thu, 19 Mar 2026
 11:35:32 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "jonathan.cameron@huawei.com" <jonathan.cameron@huawei.com>
CC: "yuzenghui@huawei.com" <yuzenghui@huawei.com>, "lpieralisi@kernel.org"
	<lpieralisi@kernel.org>, Timothy Hayes <Timothy.Hayes@arm.com>, Suzuki
 Poulose <Suzuki.Poulose@arm.com>, nd <nd@arm.com>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, Joey Gouly <Joey.Gouly@arm.com>, "maz@kernel.org"
	<maz@kernel.org>, "oliver.upton@linux.dev" <oliver.upton@linux.dev>
Subject: Re: [PATCH v6 01/39] KVM: arm64: vgic-v3: Drop userspace write
 sanitization for ID_AA64PFR0.GIC on GICv5
Thread-Topic: [PATCH v6 01/39] KVM: arm64: vgic-v3: Drop userspace write
 sanitization for ID_AA64PFR0.GIC on GICv5
Thread-Index: AQHctgLRLUYEpAPoHkKTVpo+4ahohLW1oxgAgAAZ3oA=
Date: Thu, 19 Mar 2026 11:35:32 +0000
Message-ID: <88437fc1251f775d51e42d4b5e8318cd7031fa81.camel@arm.com>
References: <20260317113949.2548118-1-sascha.bischoff@arm.com>
	 <20260317113949.2548118-2-sascha.bischoff@arm.com>
	 <20260319100256.00004de2@huawei.com>
In-Reply-To: <20260319100256.00004de2@huawei.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS4PR08MB8241:EE_|DBBPR08MB5930:EE_|AMS1EPF00000049:EE_|PAVPR08MB9746:EE_
X-MS-Office365-Filtering-Correlation-Id: 95a5da98-30cf-434a-e0bb-08de85abc6d4
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|1800799024|366016|38070700021|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 9p1uyELNAewGrZWiOvjVSJTO86KDSBysYiD+PY/cEOo591B/I00fBsKxN/7IN/JU2W/9ak7NuXxNPKN8ewZxMPrKVnybal+ypjkRzy9jLqkKUHG7tULlOUe5AWpryQ/aGgdnlya9VX6HSfLACD+z63w1JXzNv6xaTdgmvokS+iTVs66GMrO0MnKojoUUhbcmO+8uJZnkmp5XzSeB/y12Iaw7sMLXBtiEJ0nFP6WK23mZrduxdUEpHC81a8FI6w17HpClHCqviexpl7YPlxLbubarTzDndd3ZzoW9DMOY9bKxXY0rYsjeLokkqOqBnrvU/vQ5lQdQ2JyOchlCpeYKlCnLRbr2JAbBI5S43TkdGAkSuRgcuLY8G3GhD5UP72qEuS+P3e7luAEJeRsUHQQIBAgMJ4/261TSgPDU8HXAnpJD75E/Tg+6dXUWCooBVSbWogZAcq470QcAiklT4MciBQA/nwKU/E9IJdxgfLkSe456a0DhOODHJw0tb99iPoOR9hw1hfAVZm9i4MWImmvPixV5ulwoIfZpyaU3q/6Li8dSGsbGGE/DBNkorj6bZklaEOb1Z8xshDxtc20b4hXdGCriT0aojGS7G8Mna3mZgL0UDG60Qrs+DpMQkOcfwgUnXVQkXUMAtkoe5ksxpwSVp17chcfAeICUtWpdKgix5TtcQIpna4ywhNomOADIakvh9ziwT5WSJbcixCMhUM/0Sb9eBTrdPqd4CndDROkFfNJQOnzrYJPU7bYvlpwFbnXwfs5yZEHJpe8G8hFHZ9rqnenbas8I1nbN7vxiInzp888=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS4PR08MB8241.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700021)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <5A82469096D3B242960281BCC759F11E@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 AuVVQ1Mi/SRsRwy1MlGbMcvqwRmtpAH/ofshwLT0wCSbH2Os1D/VXhtMYA7EOH+6jCf+LKAK7gbRFBdafL4mFw5Ev2yet4mQcmmrOZd9YWvhZNz/iI/cA4WLilZ11eJtMjW0BK7eg+jFX1adRZMdxWbYScSTJU7a1jc/2fgcggQ1b4Y15edjn5QByGCvr5NXLoWRmAd1x1sbqBNlFXp8oLdxqArNY99uCFNGs9i4yGPYOMDQAjfTzPdIQfR+jgPnuPhZW8iO8TFvifxRlNRbLhrA5IMqnL9htNLoHP3MvUyj5YfANR/TTDgsyCJkYv8fGzX8Wnp3nbOuxkg7ftuz5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB5930
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS1EPF00000049.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	da37f509-25a3-44b9-a41d-08de85aba11b
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|35042699022|376014|36860700016|82310400026|1800799024|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	gfWudT/wBjFgJZSN8VOaKdbHKxJwmSEcCPktyVJOvX/cpWcazKGe9aPQkg7KWk/ekwxygdvlKfqFjjtbWYCl8toEn5MANCS2ym1Ap9yt0PFSX2tTvXSSVF/BKd+VjTCSi5JMyGVZlGxdv9MLbYYRDU6EoE5w6I8CWyE1g5jNo18P1imLB7ZN3X4sw9P9wmR5xAxgk2g6m/+PZcunoEO5ZJZjJTu0u/2IyzOaTJ8mk6LJogc2nE8MQmkyXy8KIj4/aKyzDBgSq5t1Z4xRHIIeW2TFpojjp+GEFsJAEKfPZX4askkWltADrEmLcukFb0mYUfUR+PW61RfJVqRJ1aqvmuYP074H7V1UtGnyHbwC4SfhSce/uaJNKqlJVUkD0R5sVkoAz/HGKQ9MnxwPLQ79eYX9phpLxooht7BEz4Odhw8+HsJUhnzYx/pVHzDiFGeIAJw9icYa1WVTE2NE/Q8DXBOqD+9bazio3Dv86TwA3H2LDG/SuEa9TdvXcx3zqfMQmbIRKNZLJYR5sSyl1dsqYZlgbWe/eWAWhfAkPhAJtjH/6kt5unhPbQby3W1xF2fj3nxp6R+b39xbr4oyqMt2WfmfJzj5GFrztYfcm6/LTUXC3jecnXr8r3CJuHBiY+/j+49he91dBo9KxUZu5D746Clc6h7P0TyqsBevvWohQFPDYsfJ6vDUqHqXY9nr3KXgIPT+StNsPpurAdnOuieZDQ+W6eOIK0ERmRXRhXDkyHnJN4QNPNxoyXEmEH1QFx67XyDHnZ4bMvSUJ+DmtewTmQ==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(35042699022)(376014)(36860700016)(82310400026)(1800799024)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	qKkO2Dz976KO8XWidquNWTfGh4zI2HhVrN07ttqcuEho+RTuhUF5pQotbrF4C7bYM4IsLzc/n2DHmr9DZP5bBKkaYPyRtIHyuOnM02E0CGwTx32JWU141b9CVTFyJt3X+byPCtoQF+D2+i+SX4/ZlJ7UqqZ2/Vfvpa6MtRpWRvZsxAgCjFh5yA08mbvPyjyYQ9CW4+UMg+3JKCDfbSpEaNId3lglPvnrQjTutOtmUTDCloZP0oNsIfQ+dh9hTxj531bHaZP7ih4N4BhHHK6BLHXBKHAZbleoEjzFB6R1ozVxPYjNHrik1BFZAohoHjD1/++fZ8xWwqSEVy7YdYKk+nTRelY0kPPSu9vyTaK/n8I0ojtbzXF7bRqamSaXoxjVgePtkT33CcBUxI7sjWmsvpkFSoNjqv3rp+pQOOjMOcJpmLeZZo4xTrjfh4XXjHOP
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2026 11:36:35.2274
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 95a5da98-30cf-434a-e0bb-08de85abc6d4
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS1EPF00000049.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAVPR08MB9746

T24gVGh1LCAyMDI2LTAzLTE5IGF0IDEwOjAyICswMDAwLCBKb25hdGhhbiBDYW1lcm9uIHdyb3Rl
Og0KPiBPbiBUdWUsIDE3IE1hciAyMDI2IDExOjQwOjEzICswMDAwDQo+IFNhc2NoYSBCaXNjaG9m
ZiA8U2FzY2hhLkJpc2Nob2ZmQGFybS5jb20+IHdyb3RlOg0KPiANCj4gPiBEcm9wIGEgY2hlY2sg
dGhhdCBibG9ja2VkIHVzZXJzcGFjZSB3cml0ZXMgdG8gSURfQUE2NFBGUjBfRUwxIGZvcg0KPiA+
IHdyaXRlcyB0aGF0IHNldCB0aGUgR0lDIGZpZWxkIHRvIDAgKE5JKSBvbiBHSUN2NSBob3N0cy4g
VGhlcmUgaXMgbm8NCj4gPiBzdWNoIGNoZWNrIGZvciBHSUN2MyBuYXRpdmUgc3lzdGVtcywgYW5k
IGhhdmluZyBpbmNvbnNpc3RlbnQNCj4gPiBiZWhhdmlvdXINCj4gPiBib3RoIGNvbXBsaWNhdGVz
IHRoZSBsb2dpYyBhbmQgcmlza3MgYnJlYWtpbmcgZXhpc3RpbmcgdXNlcnNwYWNlDQo+ID4gc29m
dHdhcmUgdGhhdCBleHBlY3RzIHRvIGJlIGFibGUgdG8gd3JpdGUgdGhlIHJlZ2lzdGVyLg0KPiA+
IA0KPiA+IFRoaXMgbWVhbnMgdGhhdCB1c2Vyc3BhY2UgaXMgbm93IGFibGUgdG8gY3JlYXRlIGEg
R0lDdjMgZ3Vlc3Qgb24NCj4gPiBHSUN2NQ0KPiA+IGhvc3RzLCBhbmQgZGlzYWJsZSB0aGUgZ3Vl
c3QgZnJvbSBzZWVpbmcgdGhhdCBpdCBoYXMgYSBHSUN2My4gVGhpcw0KPiANCj4gSnVzdCB0byBj
bGFyaWZ5IHRoaXMgaXMgcmVtb3ZpbmcgYSBjaGVjayBvbiBhIG5vbnNlbnNpY2FsIHNldHVwPw0K
PiBJJ20gbm90IGFnYWluc3QgaXQgaWYgdGhhdCBzaW1wbGlmaWVzIHRoaW5ncyBidXQgSSBjb3Vs
ZG4ndCBxdWl0ZQ0KPiBwYXJzZSB0aGUgZGVzY3JpcHRpb24uDQoNCkVmZmVjdGl2ZWx5LCB3ZSB3
ZXJlIGJlaW5nIG1vcmUgc3RyaWN0IHdoZW4gcnVubmluZyB3aXRoIEdJQ3YzIG9uIGENCkdJQ3Y1
IGhvc3QgdGhhbiB3aGVuIHJ1bm5pbmcgbmF0aXZlbHkgb24gYSBHSUN2MyBob3N0LiBUaGlzIGJ5
IGl0c2VsZg0Kd2Fzbid0IHRvbyBiaWcgYW4gaXNzdWUsIGJ1dCBpdCBjYW4gY2F1c2UgZXhpc3Rp
bmcgc29mdHdhcmUgYnJlYWsgaWYgaXQNCnJlbGllcyBvbiBiZWluZyBhYmxlIHRvIGhpZGUgR0lD
djMgdGhpcyB3YXkgKGZvciB3aGF0ZXZlciByZWFzb24uLi4pLA0KYW5kIHNvbWV3aGF0IGJyZWFr
cyB0aGUgcG9ydGFiaWxpdHkgc3RvcnkuDQoNCk1vcmVvdmVyLCB3ZSB0ZXN0IHRoZXNlIHNvcnRz
IG9mIHRoaW5ncyBpbiB0aGUgc2VsZnRlc3RzLiBJZiBhIHZpcnR1YWwNCkdJQ3YzIGlzIGNyZWF0
ZWQgYnV0IHRoZW4gdXNlcnNwYWNlIGNvbWVzIGFsb25nIGFuZCB6ZXJvcyB0aGUgZmVhdHVyZQ0K
Yml0cyAoc28sIGhpZGVzIHRoZSBmZWF0dXJlKSwgd2UgZXhwZWN0IHRoZSBGR1UgaW5mcmFzdHJ1
Y3R1cmUgdG8gdGFrZQ0Kb3ZlciB0byB1bmRlZiByZWdpc3RlcnMvaW5zdHJ1Y3Rpb25zIHJlbGF0
ZWQgdG8gdGhhdCBmZWF0dXJlLiBTbywgaW4NCnRoaXMgY2FzZSwgcmF0aGVyIHRoYW4gbGV0dGlu
ZyB1c2Vyc3BhY2UgaGlkZSB0aGUgdmlydHVhbCBHSUN2MyBmcm9tDQp0aGUgZ3Vlc3QsIHdlIGlu
c3RlYWQgc3RvcHBlZCBpdCBmcm9tIGhpZGluZyBpdC4NCg0KRG9lcyB0aGF0IG1ha2Ugc29tZSBz
b3J0IG9mIHNlbnNlPw0KDQpUaGFua3MsDQpTYXNjaGENCg0KPiANCj4gPiBtYXRjaGVzIHRoZSBh
bHJlYWR5IGV4aXN0aW5nIGJlaGF2aW91ciBmb3IgR0lDdjMtbmF0aXZlIFZNcy4NCj4gPiANCj4g
PiBTaWduZWQtb2ZmLWJ5OiBTYXNjaGEgQmlzY2hvZmYgPHNhc2NoYS5iaXNjaG9mZkBhcm0uY29t
Pg0KPiA+IC0tLQ0KPiA+IMKgYXJjaC9hcm02NC9rdm0vc3lzX3JlZ3MuYyB8IDggLS0tLS0tLS0N
Cj4gPiDCoDEgZmlsZSBjaGFuZ2VkLCA4IGRlbGV0aW9ucygtKQ0KPiA+IA0KPiA+IGRpZmYgLS1n
aXQgYS9hcmNoL2FybTY0L2t2bS9zeXNfcmVncy5jIGIvYXJjaC9hcm02NC9rdm0vc3lzX3JlZ3Mu
Yw0KPiA+IGluZGV4IDFiNGNhY2I2ZTkxOGEuLjRiOWY0ZTVkOTQ2YjEgMTAwNjQ0DQo+ID4gLS0t
IGEvYXJjaC9hcm02NC9rdm0vc3lzX3JlZ3MuYw0KPiA+ICsrKyBiL2FyY2gvYXJtNjQva3ZtL3N5
c19yZWdzLmMNCj4gPiBAQCAtMjE3NywxNCArMjE3Nyw2IEBAIHN0YXRpYyBpbnQgc2V0X2lkX2Fh
NjRwZnIwX2VsMShzdHJ1Y3QNCj4gPiBrdm1fdmNwdSAqdmNwdSwNCj4gPiDCoAnCoMKgwqAgKHZj
cHVfaGFzX252KHZjcHUpICYmICFGSUVMRF9HRVQoSURfQUE2NFBGUjBfRUwxX0VMMiwNCj4gPiB1
c2VyX3ZhbCkpKQ0KPiA+IMKgCQlyZXR1cm4gLUVJTlZBTDsNCj4gPiDCoA0KPiA+IC0JLyoNCj4g
PiAtCSAqIElmIHdlIGFyZSBydW5uaW5nIG9uIGEgR0lDdjUgaG9zdCBhbmQgc3VwcG9ydA0KPiA+
IEZFQVRfR0NJRV9MRUdBQ1ksIHRoZW4NCj4gPiAtCSAqIHdlIHN1cHBvcnQgR0lDdjMuIEZhaWwg
YXR0ZW1wdHMgdG8gZG8gYW55dGhpbmcgYnV0IHNldA0KPiA+IHRoYXQgdG8gSU1QLg0KPiA+IC0J
ICovDQo+ID4gLQlpZiAodmdpY19pc192M19jb21wYXQodmNwdS0+a3ZtKSAmJg0KPiA+IC0JwqDC
oMKgIEZJRUxEX0dFVChJRF9BQTY0UEZSMF9FTDFfR0lDX01BU0ssIHVzZXJfdmFsKSAhPQ0KPiA+
IElEX0FBNjRQRlIwX0VMMV9HSUNfSU1QKQ0KPiA+IC0JCXJldHVybiAtRUlOVkFMOw0KPiA+IC0N
Cj4gPiDCoAlyZXR1cm4gc2V0X2lkX3JlZyh2Y3B1LCByZCwgdXNlcl92YWwpOw0KPiA+IMKgfQ0K
PiA+IMKgDQo+IA0KDQo=
