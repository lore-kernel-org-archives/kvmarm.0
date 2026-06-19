Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA0D211CAF
	for <kvmarm@lists.linux.dev>; Fri, 19 Jun 2026 06:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781849381; cv=fail; b=K7GLId/nLZLvTRltdGfmQcrglh05aC5ufwXL4JhWpNRe92ObfaubLv0JY2kEQu85HzcbxbbWpok5qMQYrCDA8Wq3TPxSUvDeZ5NulBgkjEJchR0z7k6HMvjp3KbUEFph7CYVsINPk4QfszWQvY7RWOhdp0lh7zm6l9XLSq+kYH8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781849381; c=relaxed/simple;
	bh=4unxNFS+2yM0Bz7NOgwZJEIg3YRypb1nw/vfwU5WJ74=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=SkUgyBX8NPX0LFqYSjj//z/ONdJ55t9ZaBw7T4oGv4aIXHepcdxmxykrc+9VPd6A7USQiUUQHZGshBOXjyxgJwpncKd8OPkq2sxuxM6ODir6NFm/QPoLxDrJxPYMVrWx55MGRAYBzVTamD2/cosUhO65aj5cdGu7t7TPoK6Vaxg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=0rP41chx; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=FzktIHjl; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="0rP41chx";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="FzktIHjl"
Received: from pps.filterd (m0127841.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65J2utsP2483969;
	Thu, 18 Jun 2026 23:09:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=4unxNFS+2yM0Bz7NOgwZJEIg3YRypb1nw/vfwU5WJ
	74=; b=0rP41chx/9Gc6+Nh/77WHvCxC6ZEEBXAnnvG15FoykpJbIvAFVKJBDGFY
	aWNemIJ+Vb8Oz74MvB9ppYh4h0GBSIldOaCvx/jLjySe1eZC3R9iBTs1+Zaahcr7
	VUfSr/BELc6o+fIGwJLu0KIi3ZQ/OjEGAfpzFEjA1uKLY9T/4h/YQ0BjWEnY3WkS
	q7cpbw11Spu58hkFKKYSDCxQvWPccCryBG+ewpp7pCiwJqwQHKdc2YvIxfot2A1e
	6EdCfr1ph6wPP5ftgyph6Dz0p+C/77gK8wYozuGtvgJ/ZgL9NnE97Z5TGergcqX4
	x2Wbo7rJvMjgzxH/lX4Zi2PkMVCZw==
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11022085.outbound.protection.outlook.com [40.107.200.85])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4euyk2ms8r-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 18 Jun 2026 23:09:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PGneAXzWeVu/5KVc6WBKpomrM3qA116MgJAyAi1Pumf0ceorp9hpwNCHLqQ8z7FNBEyFzVMWNNp3uUGcsAw7zZAAERZjWDTaAc9wr4hve3dbHFz8D7USccgXDPHRwLu1s5zHmSy6Ez9EN9ydR2r+shKlDC0VPOqXohXKaixvP3cgKvHNleam33a7/p8Ke4jEqyWd7gEOLG5e4Xoxm6Ru6/3tj+jOKx1kM2yPap1P7FoqoDi5/sHe/JN5OkqoK9lKI3kRZZnVL69PWnvJLHtD/krnzjjbejx5ocU/yo5WMaTlmnYKk6co35Ac6dIFvGLtAy88mS6FZzYwFqItqw9XUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4unxNFS+2yM0Bz7NOgwZJEIg3YRypb1nw/vfwU5WJ74=;
 b=lipFG4l7ct6oXjxqszHJQBNPF1gXmhsyQxKqE5FEp27RMrsTP+dwWvFXXGAyqRLBsoVuxNisn0qt+PGuSLOUrGGXhFlfoBQOh7QNfpWohUPVaVJUsyhF5o1i18oFaqroAH4E/eBzotfocnT7vTbUSLMMq/pcSC+ncH4bLd29cIOimH2R5jydlmEUEd0loyMsWy2uWLVaOJuoTwcS1kjkqZr/wnz/urXYQFr2FrcSOnlT0fVXdIdQkPEINU9i1D6sb9oVnJjxwknElbnkTxgKjxym4DyB6XRRs9ebKcdvTR5K+pqvjIRw3PgrBSFzwR2DQrZnQgs9cOvNBUk4QnyHVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4unxNFS+2yM0Bz7NOgwZJEIg3YRypb1nw/vfwU5WJ74=;
 b=FzktIHjl8xOwUygqgOAcgy66l7uZ4eA6ox12S3SFNF08C25TcX6me/OS13lmdky+21wZJkJmurK789CfwrZXQJSEfIR727Dk2eZ3GrfCxqjhlYjgx8mD8iboRp1fEwV4xsHBe4SQmxXT5EA1WDJ+/gkk4W+EQMw7HjTWhpNsXgAfVy5mh8iJvvVOB/vcgfXcWD6UvF4FNizy8R4FSCUdUv74WEZ8Fb29CGer3PEtbPGbRKsX+0NieGKzSv4hjIGmb6Sp7mJWvEa+t0XNWTBMhr1FBRCBJoywiiofLYLYWZnY4+NT/rowmIjZ8SFGGP6hfJj86s56R8b/zpGBpR5PBg==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by SAWPR02MB11995.namprd02.prod.outlook.com (2603:10b6:806:55a::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.11; Fri, 19 Jun
 2026 06:09:11 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%5]) with mapi id 15.21.0139.009; Fri, 19 Jun 2026
 06:09:11 +0000
From: Khushit Shah <khushit.shah@nutanix.com>
To: Eric Auger <eric.auger@redhat.com>
CC: "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "qemu-arm@nongnu.org"
	<qemu-arm@nongnu.org>,
        "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
        "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
        Shaju Abraham
	<shaju.abraham@nutanix.com>,
        "yangjinqian1@huawei.com"
	<yangjinqian1@huawei.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "richard.henderson@linaro.org" <richard.henderson@linaro.org>,
        "sebott@redhat.com" <sebott@redhat.com>,
        "skolothumtho@nvidia.com"
	<skolothumtho@nvidia.com>,
        "philmd@linaro.org" <philmd@linaro.org>,
        "maz@kernel.org" <maz@kernel.org>,
        "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "armbru@redhat.com" <armbru@redhat.com>,
        "berrange@redhat.com"
	<berrange@redhat.com>,
        "abologna@redhat.com" <abologna@redhat.com>,
        "jdenemar@redhat.com" <jdenemar@redhat.com>
Subject: Re: [RFC PATCH v6 04/17] arm/cpu: Add infra to handle generated ID
 register definitions
Thread-Topic: [RFC PATCH v6 04/17] arm/cpu: Add infra to handle generated ID
 register definitions
Thread-Index: AQHc/ZPY1tU/D5842EWKy4Bpj7nwMrZFaRUA
Date: Fri, 19 Jun 2026 06:09:10 +0000
Message-ID: <CB5D3764-490B-4DFD-AFDE-65B1DC9D595B@nutanix.com>
References: <20260616132625.1732031-1-eric.auger@redhat.com>
 <20260616132625.1732031-5-eric.auger@redhat.com>
In-Reply-To: <20260616132625.1732031-5-eric.auger@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA2PR02MB7564:EE_|SAWPR02MB11995:EE_
x-ms-office365-filtering-correlation-id: 9d4eac88-977d-4691-60c9-08decdc947cf
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|23010399003|376014|1800799024|7416014|366016|38070700021|56012099006|4143699003|6133799003|18002099003|22082099003;
x-microsoft-antispam-message-info:
 VXqFC4u48ZI6c61aL3BpxJQCyGecuH5GqEpadxjLZeG3UYZlCADhapciTs7PwPseWoELNDWpYLeHXjobG5+xOULPRNUIvu4/6HxPKUKMsNO3haztDPzlcvCMpbPoVDjV7jmHlo8W/CJf6DKTT3vlV2GKIPxCx2RpVyH4vvSor9g9Tt5hdQwMb4E/+19Ks0yUk92pWJRudIQmHhJdtvl9WNikm2O75LfW3gTJTfIIJ27YYZrATEGydnQfLJ+VkrTlzTOf/vDuO+L2f0cdAXIpLQ64nE8SPfqD1QFaKGsb0ieUH7Je+bneXrs4DMpg/FiyfqSDFr1LU6tg/7YrC6uP0EYAjdSh0uonop5+WfVF6cTACRJK8ErpqIRnv9MbhSvbX7Tm5+6F+wUe0QqQQMOUKESYyTK1u+I9Pj7zKsalTtF3w6G1kqA4ZKWY567eadu1pIJJlgjdrz90VTiuZ6oU6ccmblrlRsCiwltkaIDz/Nq/f6itpfVkJbwODzKPZ+73QCY1ndTrqTqwoEGEx2mYHiJq9Dk4+yYEOuyVK4kjOUY97B4mHOhyQ1zw4XsKSol+fh/HpsORFsyvt1Az2SRcUvZaswl7QzMrFuz11QLvhVUIouVrGDb6B0GZhGQVoIudxFqBYMqIp5QrI6wg8yV7R5deDPHRyCLBLWAepfBYGNvedruD4nxOcuECe3VLEtGZHzVpCgHvV6t+UmQGEoboyb4wjEvlf+vBvtJb82mwWxs=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(7416014)(366016)(38070700021)(56012099006)(4143699003)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?ZFFNMHFYa1BrSngxRXNpNVpzN3NaeVdGdEdEQXNtdjFwODRZZmNyZnR3cEI1?=
 =?utf-8?B?K3JqZFppYzg1aUtmaThydUpqMys5cE5xNmNZTmhydzluOElPc3R6aHl4eTJR?=
 =?utf-8?B?UVYrc092dE4yamZib0NzczhKSzhETkM5YkNZcVF0YWdCR3lvNjNLT0FZdGU0?=
 =?utf-8?B?MVVXaGp3dktvUFlOUlJWZVFyYnFJNW0yb0p4ZDI5WmJKbHUxUHVodkpwNXor?=
 =?utf-8?B?SkViYldaZG55WCs5dGo5bTNwRG50Sk1KclBlUTVPRUZVaDFzUXBRT2tVcG1F?=
 =?utf-8?B?d3VxeWFKSmFhNjFQVlJYT2FsYjRkaGlQSEZwUUlPQmlpbitqcy8wSGZ2Z0l6?=
 =?utf-8?B?dkxzT3dTMHM3QXRtbmR4T1NOOS9waWRPMnNjcXJ0YmpGUUFtK2tjaHAraFVj?=
 =?utf-8?B?eXQvVDJiR2RzMzBNRjk4cjVkekdsbFd2UGRkemg3Rmxna1F4RERMYmVNVDFJ?=
 =?utf-8?B?SXNta3lzVWg4L0lwUDFOL0swdnQwYTJqVGM1ZDZDcG5SeldpZ0NvUGlodjNW?=
 =?utf-8?B?Tzh5MEEvdVNWRTlPWlJidXBhZHNRV1NDV3ZTby93YS9sWEN2YXNKVFFqTU9Z?=
 =?utf-8?B?ZGdNTnBTU3c0SXJkRUJsdXZTU3JLM040VW1RY1B3ZlFtN3M3cDJDZUFmd0g0?=
 =?utf-8?B?MC8vTGFQM2tZWTBzUHVhWUtZcEJ6amxRajBXaVIwbzY4WFJjdHRGR0lrNG8z?=
 =?utf-8?B?c0tjdDZYSlZxL3k3L3ZuYUQzUFRadFpsV1dyZkNjcXd5TTNYV1lvYWt1S1Jv?=
 =?utf-8?B?WU1DdEhIVEk1a3V6aGhlanRhNWtzQ1NsQlkvMGM4elA3UnNSZEoySFg1dlMy?=
 =?utf-8?B?WmtJdmFDbHpBdE9LVmtib0VPd3M3ODZmTkhlelNXdGRCSGF0MGllNjVObmZM?=
 =?utf-8?B?b2dGa0ZtYWR1MFE2S3pLaXVyV3BpZE9XL1VONldOL0F5dEFuaEE3SUdiWCtN?=
 =?utf-8?B?WEcvU0thRENQbTN6T1NneEd5U2ovTkY5bWdsRWkxQVpqMlhXQVd6TEJLcXB6?=
 =?utf-8?B?ZDVTMkxkbEtKV081TlpLeE1NNTdFMEIxUVNoRDlwQStiWndlY1I2OTY5TFpN?=
 =?utf-8?B?cGUwMWRFYklRZGF4YzVqYlRUZEhYdkwyd3IrSHZBVURQQjZjN1JFcXNSbE9q?=
 =?utf-8?B?UWZJNEdtSVlLUEhPYjZFZVBDclptTm5tZjJIZTVsV2gwbklnb0oydHE3MjBq?=
 =?utf-8?B?SmVmSm9tZ0RyMzRueXdwSUpta1dvb0FtWkNzK043dHRqaHlLV3BUMEdUZGpq?=
 =?utf-8?B?eGhmSCtPeHBvYmlXS1Jsb2w0bmk3eDN2dGRqZXNyR3hOUzVZbGxpSFNyZlBT?=
 =?utf-8?B?ejF4RW9LMFFsZ3M3aFFZQW1zeUx6Zm5PUTkzN29yY3lZektFTjlRM3RFbDEz?=
 =?utf-8?B?Z3hQR0ZDZ05FamRObUVNaGloRGRkOVE5TzBTbjMvSzhUdDJ3OXJQMW5BcVlw?=
 =?utf-8?B?QVp1M3VUbEMzbEhEMS9WeHROakdmOUxLVFd6dmxSQWp2VVJoVTNXdFdFTDFj?=
 =?utf-8?B?VXdobEZpSE5vb1lEQ2dhdGh2NnJBNDFGQWd4SWl5S2hYa1JHSytQd2g1bHZU?=
 =?utf-8?B?clBzMUh2L1NXRzNIZTZ3cVVPZEZRT0g4R3o3VXhWcU0wVVRnYzlucVdjb0xH?=
 =?utf-8?B?M252dDJjekRoNHJNT05SMzh6L0J6Uy9Telp2VHZZbzV1WHlkTHh4N1hVQjI4?=
 =?utf-8?B?VHNGUnBMV3RDNmJKZUxhQU9kaUdjSDMxdkJKYnFpVmpNZE42S0dreUFpYUl4?=
 =?utf-8?B?Qk5MU3JYUjZoeS84WFE5RDZhVVpOaXRYVU9RZ1ZLY1g5UU1IczNwWEcwV3JR?=
 =?utf-8?B?RGhEK0JjdHJlb1J3VUZnZTl5eWVrc2hoN2UvSDVJM1hrRXlKeEJJK3NCYUhu?=
 =?utf-8?B?SDBENWVUNDhUdUJ3RzUzNlFqVUtLVkdyMTFYSkJ4alJZTUQwYmY1Y01BVnRs?=
 =?utf-8?B?cHZpMng2U0FaNVBSamFNcWhPaUZHZy9jRFVnWW05UG9icnMyLzJKcFI1NlJV?=
 =?utf-8?B?VnVLWC84TjdVWnlZMG5GR0ZDNXlnYkxkVVlUT2FZeWNGTitTN2RSMWdrRUUy?=
 =?utf-8?B?elBjN2c5OVNMaGd0aG95QVVtaE55cmVDU0ZGRXJ6djBudGpad1Vnb1Npc2Ir?=
 =?utf-8?B?OUpDQ0pVdUdkMzloRHpNMW84VzJ6bHhPclpHMUxoUU1YbTRtUjRxbUY5cWp4?=
 =?utf-8?B?dWhwUWdDS2hjU1ZTQ2d1bWNvbWdhc2lrTDFrbHhuSDA0LzNkWmZPeklwZXZm?=
 =?utf-8?B?d3cxS2lrNGhVWER0WTRxaU5nRC83dXA0WU8ybk5CK2c5QjI3TlQ1cmFTK2VX?=
 =?utf-8?B?c1p6RmxodFdGTmRmT3p1R2JQa2NJVFNVMEhiMWtCMXBwWng5MXNBZ29nSTkv?=
 =?utf-8?Q?HieyrCD6dYCUzUVw=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <14B4B3B1C2A1514EA74D6E1144598DD6@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	fl1IUJrr9SAgIdmTj2XDS7K7TYWyrQEfpCteVrvY/SSc+8axfJ2B0Pdk51MKCvF3fX09uCwwxmCZDdQxfDaCCPxaa1AednF1ydZKW06kYXytA0Sk+y1IlprCvfiG5UgW75RfN3CmGec8EwuOGeHGYEY+skeJGYb6uxyVnLUwYBBKJppHujqM6BP+kPdwpn8wWMPO3gwnkaSGoHok6wF+bQ7pAfJtILsGjQSdU0PqsBZ3NBUe+uava6ETfu94n93nU9ij6GTsRRDfDqtLAouk8WJk0B1TzOqvHE19Ita2p2me41zuLgJ+h7WA9nDLs/lLOknEUDSk7yCTeWUpjF7poA==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d4eac88-977d-4691-60c9-08decdc947cf
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jun 2026 06:09:10.9992
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XGc+tyapkOvc8Jqv9NEYCsqCDq1W+zhigHqxSFT3weED8wmNnFhmFkyU2HijXTtvogMgM6HdiRPtYT7X4ibgwIh363VjWJEraOUZbEfe3eQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SAWPR02MB11995
X-Authority-Analysis: v=2.4 cv=evDvCIpX c=1 sm=1 tr=0 ts=6a34dd08 cx=c_pps
 a=jGG6JRppMrTRDPguzGMrcw==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=FelO9ux0wxsA:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VofLwUrZ8Iiv6rRUPXIb:22 a=jxMXjlTPpCISP5mWtjnE:22 a=20KFwNOVAAAA:8
 a=64Cc0HZtAAAA:8 a=rapeV_N5vWS931luybQA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE5MDA1NCBTYWx0ZWRfX8HH4gGVt2cdN
 f5f0G5XEVxJ93LVIBkBX7jVlccBlbqUKGJCensBBxQLkjdzCpuzJNSG/1ZHdP4N9ZadWZHacPkv
 CRIlTg/uqoPB7swgzeo2+oUZVDKEiLwK2/tKcTvK9sc3/sRyjiuNCgGq2USVUU3flnGv9iuZo8B
 Vx11bpdXFbryWN1Vsnb72NJly9eJiJVytgfWc83LDp8JESLPDK7fO7nFk653BN+USvTc7PrvsAK
 LyZOJEWGkJGL/7/dgDdbLZR7zgG4EV05dcKeJfux5/HJmzL9bWaKohhtpB04UzFFIKvY97W2YB1
 F9CvZ9pFuAxSOr4GP2X23v8Walte6fBbN0QALwCxJVd7qMWnuAaTjCiAJWr3l67YMk1qfMFT08o
 KpGwjYWWhbbRnXV8l1nJ7GuMDJ9gzrB42vxobNsJC30tokJFOaZ7XzHWCQeyEzsZRp+9oohNohl
 urM0yYsIn4yHgTkqwkA==
X-Proofpoint-GUID: CPXq-vdWcwMqvFa4PIw9c2enjhufCjw0
X-Proofpoint-ORIG-GUID: CPXq-vdWcwMqvFa4PIw9c2enjhufCjw0
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE5MDA1NCBTYWx0ZWRfX+fvMzxDLTNL3
 XqA90iWvWWD50UEIwHNmQgPtsVwkuiXjmtlMBYG81jc0uBW8pc1TaccUX9Sp72fOZ5w3VrcToby
 4lqJ6umltUUQqaQX6Qj8OrPbRPNpwOc=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-19_01,2026-06-18_03,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gMTYgSnVuIDIwMjYsIGF0IDY6NDbigK9QTSwgRXJpYyBBdWdlciA8ZXJpYy5hdWdl
ckByZWRoYXQuY29tPiB3cm90ZToNCj4gDQo+ICEtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tfA0KPiAgQ0FVVElPTjogRXh0
ZXJuYWwgRW1haWwNCj4gDQo+IHwtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tIQ0KPiANCj4gSW50cm9kdWNlIGFuIGluZnJh
c3RydWN0dXJlIHRvIHN0b3JlIHRoZSBkZWZpbml0aW9uIG9mIGFsbCBJRCByZWdzOg0KPiBUaGlz
IGluY2x1ZGUgdGhlaXIgbmFtZSwgaW5kZXggYW5kIGFycmF5IG9mIG5hbWVkIGZpZWxkcy4NCj4g
DQo+IFNpZ25lZC1vZmYtYnk6IEVyaWMgQXVnZXIgPGVyaWMuYXVnZXJAcmVkaGF0LmNvbT4NCj4g
U2lnbmVkLW9mZi1ieTogQ29ybmVsaWEgSHVjayA8Y29odWNrQHJlZGhhdC5jb20+DQo+IENvLWF1
dGhvcmVkLWJ5OiBLaHVzaGl0IFNoYWggPGtodXNoaXQuc2hhaEBudXRhbml4LmNvbT4NClNpZ25l
ZC1vZmYtYnk6IEtodXNoaXQgU2hhaCA8a2h1c2hpdC5zaGFoQG51dGFuaXguY29tPg0KDQo+IC0t
LQ0KPiANCj4gdjUgLT4gdjY6DQo+IC0gYWRkIEFybUlkUmVnQXJjaFZhbA0KPiAtLS0NCj4gdGFy
Z2V0L2FybS9jcHUtaWRyZWdzLmggfCA0MSArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKw0KPiAxIGZpbGUgY2hhbmdlZCwgNDEgaW5zZXJ0aW9ucygrKQ0KPiBjcmVhdGUg
bW9kZSAxMDA2NDQgdGFyZ2V0L2FybS9jcHUtaWRyZWdzLmgNCj4gDQo+IGRpZmYgLS1naXQgYS90
YXJnZXQvYXJtL2NwdS1pZHJlZ3MuaCBiL3RhcmdldC9hcm0vY3B1LWlkcmVncy5oDQo+IG5ldyBm
aWxlIG1vZGUgMTAwNjQ0DQo+IGluZGV4IDAwMDAwMDAwMDAuLjI0NWYxYzgxMDMNCj4gLS0tIC9k
ZXYvbnVsbA0KPiArKysgYi90YXJnZXQvYXJtL2NwdS1pZHJlZ3MuaA0KPiBAQCAtMCwwICsxLDQx
IEBADQo+ICsvKg0KPiArICogaGFuZGxlIElEIHJlZ2lzdGVycyBhbmQgdGhlaXIgZmllbGRzDQo+
ICsgKg0KPiArICogU1BEWC1MaWNlbnNlLUlkZW50aWZpZXI6IEdQTC0yLjAtb3ItbGF0ZXINCj4g
KyAqLw0KPiArI2lmbmRlZiBUQVJHRVRfQVJNX0NQVV9JRFJFR1NfSA0KPiArI2RlZmluZSBUQVJH
RVRfQVJNX0NQVV9JRFJFR1NfSA0KPiArDQo+ICsjaW5jbHVkZSAicWVtdS9vc2RlcC5oIg0KPiAr
I2luY2x1ZGUgInFlbXUvZXJyb3ItcmVwb3J0LmgiDQo+ICsjaW5jbHVkZSAiY3B1LmgiDQo+ICsj
aW5jbHVkZSAiY3B1LXN5c3JlZ3MuaCINCj4gKw0KPiArdHlwZWRlZiBzdHJ1Y3QgQXJtSWRSZWdB
cmNoVmFsIHsNCj4gKyAgICB1aW50NjRfdCB2YWx1ZTsNCj4gKyAgICBjb25zdCBjaGFyICpuYW1l
Ow0KPiArfSBBcm1JZFJlZ0FyY2hWYWw7DQo+ICsNCj4gK3R5cGVkZWYgc3RydWN0IEFSTTY0U3lz
UmVnRmllbGQgew0KPiArICAgIGNvbnN0IGNoYXIgKm5hbWU7IC8qIG5hbWUgb2YgdGhlIGZpZWxk
LCBmb3IgaW5zdGFuY2UgQ1RSX0VMMF9JREMgKi8NCj4gKyAgICBBUk1JRFJlZ2lzdGVySWR4IGlu
ZGV4OyAvKiBwYXJlbnQgcmVnaXN0ZXIsIGUuZy4gQ1RSX0VMMF9JRFggKi8NCj4gKyAgICBpbnQg
c2hpZnQ7IC8qIGxzYiBvZiB0aGUgZmllbGQgaW4gdGhlIHJlZ2lzdGVyICovDQo+ICsgICAgaW50
IGxlbmd0aDsgLyogaGlnaGVzdCBiaXQgbnVtYmVyICovDQo+ICsgICAgQXJtSWRSZWdBcmNoVmFs
ICphcmNoX3ZhbHM7DQo+ICsgICAgdWludDMyX3QgYXJjaF92YWxzX2NvdW50Ow0KPiArfSBBUk02
NFN5c1JlZ0ZpZWxkOw0KPiArDQo+ICt0eXBlZGVmIHN0cnVjdCBBUk02NFN5c1JlZyB7DQo+ICsg
ICAgY29uc3QgY2hhciAqbmFtZTsgICAvKiBuYW1lIG9mIHRoZSBzeXNyZWcsIGZvciBpbnN0YW5j
ZSBDVFJfRUwwICovDQo+ICsgICAgQVJNSURSZWdpc3RlcklkeCBpbmRleDsgLyogcmVnaXN0ZXIg
aW5kZXgsIGUuZy4gQ1RSX0VMMF9JRFggKi8NCj4gKyAgICBzdHJ1Y3QgQVJNNjRTeXNSZWdGaWVs
ZCAqZmllbGRzOw0KPiArICAgIHVpbnQzMl90IGZpZWxkc19jb3VudDsNCj4gKyAgICB1aW50NjRf
dCB3cml0YWJsZV9tYXNrOw0KPiArfSBBUk02NFN5c1JlZzsNCj4gKw0KPiArLyoNCj4gKyAqIExp
c3Qgb2YgZXhwb3NlZCBJRCByZWdzIChhdXRvbWF0aWNhbGx5IHBvcHVsYXRlZCBmcm9tIEFBUkNI
TVJTIFJlZ2lzdGVycy5qc29uKQ0KPiArICovDQo+ICtleHRlcm4gQVJNNjRTeXNSZWcgYXJtNjRf
aWRfcmVnc1tOVU1fSURfSURYXTsNCj4gKw0KPiArI2VuZGlmDQo+IC0tIA0KPiAyLjUzLjANCj4g
DQoNCg==
