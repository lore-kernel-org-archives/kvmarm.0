Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013041.outbound.protection.outlook.com [40.107.162.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FE6E3E9288
	for <kvmarm@lists.linux.dev>; Thu, 19 Mar 2026 15:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.41
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773935657; cv=fail; b=niBq0epaFsrx+Jgmo8c+kdKgX1pf1+VBFuaznAqKnCjkzdNeQbcfVFIaVNqFpuvP8ZAzRWd7jW8QiT3cSXdRY2LcxbKnBQltZUMZ5jtosU+aUzRsx/zrxQc4Ir7HcvkJvWB9oBAdQQmz2/lSM6Ba/90Hun2LMtRdSCy3Okh2/Q0=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773935657; c=relaxed/simple;
	bh=E6Cekd1mFq9yXbDM/tdLdbMksIvDQrFncfPfweCXXZk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=iKDyrJKhaLWRmhgQAfkTJZ5q5NkGGkil3OpDOMDIWNBEc+8fS8op50Ksd60QyutwHgx3rnpolXg3LJiZYsMHZU0arZnjuGYFgkQwmhFP37ixBo2Hh0l6sbZXcAEvMakFqgciy82JzMY9WEXkl7P01DpgllAA/M5ED35bed8gPvY=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Y21OqeO/; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Y21OqeO/; arc=fail smtp.client-ip=40.107.162.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Y21OqeO/";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Y21OqeO/"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=xDr9/SMpLQoHiKPJwAnMfEKZDASiUtOcptU2Omp+UTTLKbtyPhK9DnfHg9LOMOnA8Y0ikf6XIYYD+OoIccpgWl0HIF7vcbIKZ3h+YyRjoJlt09qUFQ/4RhjVddUwOqlZCIsmE5BjOo/yeaL6jxRuPn+ZNulGrOE+2sHG63XgffsgqPRirRTBLBZkYEFdg/KQK93IxBJJgxIgqJnKMRTH8UjTkyvFupdhjl5ojp97bb4XB85mWHfcyjK0FC+Z7GW+2+6IWJWZMWWoPzXRjJxsYpgNusbnzcFoMpWxvXmzjs9uxME0rUI1IYgIMUKPkE3S3Pq2kORM3y1LmPlwrAJr2w==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n/kRsz7ejfEfUsS6mGDjv0iX2YNtLpaByMScrUGSOIY=;
 b=g88RJCJzKAWdebWa5RfPdAPdSy1yo6yheoXI6pTtzsykp6N4lSUxJM+kustxVP8mK/WkfnJGg7KUcwBTLbXIQ/pCG87SmwltniteILauCxC/38LnlEenasCqhFIZkiYaRsU09yFn0USEQQwDomjFCg7CmLvFCEbdSjZ83OZj9KH9lVRYBwFJDqnWPbM3gqxta5emSlVTCgZaB7M1QpDVpJTgD2Ci6+LieizTrhXkf9OofrB0/NfU/mEiPjsRRa86K+/1KXNcQBjRsdQ4ZhSWnPruVJVRMW7kRu9AtOWatb7C3PMX0ysgrNtPUrJywVHjBdWd8sGyp20oJ97WEsAgGA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n/kRsz7ejfEfUsS6mGDjv0iX2YNtLpaByMScrUGSOIY=;
 b=Y21OqeO/Si7ehmMDckGHa9cO4mUwx6yi5AuZV1tUxHdLmS0OD0NTuUpEK05EwPRIFXdK9aqyGvjKPzscrp/cidq6E/jBQ42mOxczMnzF7Xn9SjawKSaHLe5HJmp/sJFamzxU7m1q8/i+XbAWbrK1/wYvKQDcIEKmDn3nsX5887Y=
Received: from DU7P251CA0005.EURP251.PROD.OUTLOOK.COM (2603:10a6:10:551::32)
 by DBBPR08MB6186.eurprd08.prod.outlook.com (2603:10a6:10:204::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Thu, 19 Mar
 2026 15:54:08 +0000
Received: from DU6PEPF0000B61F.eurprd02.prod.outlook.com
 (2603:10a6:10:551:cafe::c9) by DU7P251CA0005.outlook.office365.com
 (2603:10a6:10:551::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.19 via Frontend Transport; Thu,
 19 Mar 2026 15:54:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU6PEPF0000B61F.mail.protection.outlook.com (10.167.8.134) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.19
 via Frontend Transport; Thu, 19 Mar 2026 15:54:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vsllDrUqXoysQSM1ySF11CHbncw8DTVm1Te4R2c6zSonzI/dpHbcemHv5pppv/mzdWeckwJuTepd4a99riizadVFY0S0MrYpM6GableG4uWK8MO1AMGMeKC8xqjSQ32jXHtRFJi4DVGzkC/N3AoTmeuhXlES8LUX3Ej2ivDV8TANBuXaErs5h8RZl69rLB8nJnvUOPEgzzU24oaROQ/QLpgGp3rQ0vaizZMhy6DMwK4On2MoYhUn0Dn7SpU32wOjKXWyOo/Nzvc+BeHwgWVEy8JyOsPECyHLn2PXEP+Kz8xPk5PHJuMOpUQ7cfa6xt6FlrA3RY62zZ6qwMcZj/gtGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n/kRsz7ejfEfUsS6mGDjv0iX2YNtLpaByMScrUGSOIY=;
 b=VsNesfsFW4hWBFhtc2uBSlFSEdvmskS7djuOS6J8EP+Bj6DrhBdS4CwUBXR7E4LcycQnSwvGwwL3JoySySWlHcfPNkT4dOjBTXHrtcO89VVey2lazeiHcQDkFGXDRV4Tmo8qtgH92gQZLcYxHxlRK+kmUoMYEs9AqUHhxKRXrEiaA5w5IqM/nIqGl6CdHuSndxewhueLODxx4vG6NbkscjPpOJUQ9IQW7nXQB3spKJ3tkSS/Siv2qGTOzw1HjG5BgI7Y73LEWCLdWyYGktZkIwaGx9ShmcITnVtHQKN+pjROnEEI6wD+49oUTf412rhxT36z7S9B0gEH2RdD4WE/nQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n/kRsz7ejfEfUsS6mGDjv0iX2YNtLpaByMScrUGSOIY=;
 b=Y21OqeO/Si7ehmMDckGHa9cO4mUwx6yi5AuZV1tUxHdLmS0OD0NTuUpEK05EwPRIFXdK9aqyGvjKPzscrp/cidq6E/jBQ42mOxczMnzF7Xn9SjawKSaHLe5HJmp/sJFamzxU7m1q8/i+XbAWbrK1/wYvKQDcIEKmDn3nsX5887Y=
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com (2603:10a6:20b:504::10)
 by PA4PR08MB6191.eurprd08.prod.outlook.com (2603:10a6:102:f3::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Thu, 19 Mar
 2026 15:53:06 +0000
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27]) by AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27%6]) with mapi id 15.20.9723.018; Thu, 19 Mar 2026
 15:53:06 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey Gouly
	<Joey.Gouly@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	Timothy Hayes <Timothy.Hayes@arm.com>, "jonathan.cameron@huawei.com"
	<jonathan.cameron@huawei.com>
Subject: [PATCH v7 13/41] KVM: arm64: gic-v5: Support GICv5 FGTs & FGUs
Thread-Topic: [PATCH v7 13/41] KVM: arm64: gic-v5: Support GICv5 FGTs & FGUs
Thread-Index: AQHct7h5zXndN4kgbU+1byjikhgJtw==
Date: Thu, 19 Mar 2026 15:53:05 +0000
Message-ID: <20260319154937.3619520-14-sascha.bischoff@arm.com>
References: <20260319154937.3619520-1-sascha.bischoff@arm.com>
In-Reply-To: <20260319154937.3619520-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS4PR08MB8241:EE_|PA4PR08MB6191:EE_|DU6PEPF0000B61F:EE_|DBBPR08MB6186:EE_
X-MS-Office365-Filtering-Correlation-Id: dfbaec07-a57e-4dce-d5e7-08de85cfc181
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|18002099003|22082099003|56012099003|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 wWDrkhs6tSERVmtC0/Ad/uG38aXs5QlNR/9GyDjv7dj7ftIjYkq9OAWdXZiKojJ55STgLUBxHUp+1eSl3wJINmnw+9SOODXjsQEkWzGddMz7rtvs55vv71dxNrcv0Bn1KsnQV4Z94uNc6YCDK0UI/IEiGbi59tfRWQjfODdkwBpUfubUtaXJu5yGLkettUAwocveLq88nUQyd4QWZOkehkj9GOoBcTS3iFRU/xypyyV5xxtoMcF3KeK5+bsOQuypMiAIfL+6PP4kbDJztvD6REEY5TFBN6awah1iURtkk1bu6wDgmYW96qBrBZGelMCjFZNFZi9hwWWA24S1UJfp6+oMkm9qvxBSwRUO/gGRj9UUWJxRENEdEZ1i5DQJEplz1/AESyogvUIVyoRItWR+l+FNQ2h0ZFFDipA8mPxShE9okLhJI9iQ1hDP5bwmqW+wj5SkIxYq47UU4V1o2CncPR3A9jacxrJ7n+hpRC7dX15qmtNwTJ5CLch0vZZR+9sLDJ4hTvsKtYAyTppS8Cj9J4t2JgcfMfWCkT3y+c0WqwQWrrO3MfVQ8KQ1HwrR+JA7LKSIhODjjgp6tA4BT3+XJWfnpakmPj0E3p8RycvUkqBW99SJrEuqVi/K/oaZn67NOOuw2hNOYHIfeBpyMNHB9uBlj3uOfRsgaCQ/6+2kf4U9K6gko85JF+wJuhk9+VxjqGYYcyH+0K2cPA1s9lQBITb7WHQBTQC6NHha/jB9G/aZaVgwgkbYWp2VS7kGpMCBC19Legsd3CL946Vqq+t87BCSx9AnG6mws8fPYU9/NlU=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS4PR08MB8241.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(18002099003)(22082099003)(56012099003)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 SABHi2C2YlEgbgmWIBI+WNGCgQjF723mClqnJyULy7c8b6acXPxD9+8S3swi+XCLg47lZbgwHP4tYb1Bz3Ug0X7nj0AkHFnJwPAl8bbEWnckDc0cWFFOynGl9QWOp4GpRmUqlWjzIdkPpd6mkBlTdJdthkI55e9kqASIHzlpBCbLCUsU1JU7DQ5cc2/TSeJUSX7AmoS3yc/uojBOeOEEB/j2O+q+Qe0y6olTvhQofwlzmoQWM35kA0RLGIkGsiFXXUjT55COYr1SqVU5YR5DECBCKu8wa3Zksb2e1yKlg7fvj+hwJFiueWs2U3SGTXzUSvtmssWsLpPenR6XA6E7aA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR08MB6191
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU6PEPF0000B61F.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	1a1fba61-3735-4a53-86b5-08de85cf9c46
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|36860700016|1800799024|82310400026|14060799003|376014|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	RVk2wh9eJodv4eK8cZxKwgpWbftL6gdUCmpX+EVOghFsnfT6NpfV4P8nqag0avnLi/5hO9dlKXBhshuCLtP82ZB/Vhabwja5e5n9A/AoZH5zmfVXpywyHvKJP74Up9EoZ7AbGDauwLJBL/vA9/yo0bKElNXRYWr3LqeinSoobR+ikTNH4M0/Im1Y8N1lUiYdYly4LgfduvfDDg2upuE526xdqDfQ0ylOkXj/O5l+W+un6c9x3zaRnCFiIwR4zXumVHCNxcOw8hYEtG8394SlIienL0Eqfq3MVTeCZDyz57q3AfVWZfg3FHpcLOKhRPJ0nviPMih8PDj1wo67muUuVYW9bf9eKDigdvNOOxFmmBbCH2TsGnvSwjAM/3C/SGfjx+vFfde//by3CDWkWEo61dlPCVxlIZpU4hRnkfWZUCcwLo4haKCuyhwcB26dKEHoGgESa/lkK/k+6nuSbH6khArooszTdY/DdkaIDh9VeQ8Vf9nfvGQRCd7HM2/Ao1oFnBnVxJxQ+pjPaanDt3TSFJyn5aRNQvbQj04Fk6bpndjF9atmycyDUdpVRHvszr6Yo+qqW0430Nljt4sddcs8NCC820079EzHf2vSVGLVBJQ67DEajK/SsPyo6hjAWOZI0VTnZJhGbpYSFsF0hyQrulm5Tb+T6Ac6t3jshFiHDsSASLC+m7nu4Q8LPw6Uz9rhHB7IB/lcHqGKzAn6I3pI+hkvAXajyBgm0aD0Ns+P5iSasnE1s1Gzxd/fqPH6kDXv99HI00BFiCtocCPbEWt7Wg==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(36860700016)(1800799024)(82310400026)(14060799003)(376014)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	9X04+qkLE1aPRe+1fENv3R4xfLq9f1vXkrF2pdtoxdMyL3B1avj3ETNsumdYnD+yeMqZCs1Nk/pKsXmXUtPajs4NERAdwrBV/4nrsFrda083AOuehR6kqQkWI4raNXmVKd23uTq+eGlH3Ubh35/P09gY36y2aNylZ4YSWFTlBnBwG9/unkIVKKwSs8k2xJGc9pCoLG+8t1u2YMFnlV4asX7cJrF6trOB3T8kaU5ygB92O7u691tbomZkGxtJjdM1zyIcH8GNDj1o/PiFV04DVeiwkAqf7IYJvALBvxqt8yhixXfoP7ahxD9WLEVuXO91xfeHccsM9M1f4Cj8PiSwdOFyxjhpzxbQuD/KSjohJ9kt5fDbrLbWSbMY9j5mI2MP4cSUtk3rg9FUOx21BzjMdXDiHbDyJrZTuXFK2GI+q/NLaaNZB51I3k/MLBWxO6fi
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2026 15:54:08.3350
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dfbaec07-a57e-4dce-d5e7-08de85cfc181
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU6PEPF0000B61F.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB6186

Extend the existing FGT/FGU infrastructure to include the GICv5 trap
registers (ICH_HFGRTR_EL2, ICH_HFGWTR_EL2, ICH_HFGITR_EL2). This
involves mapping the trap registers and their bits to the
corresponding feature that introduces them (FEAT_GCIE for all, in this
case), and mapping each trap bit to the system register/instruction
controlled by it.

As of this change, none of the GICv5 instructions or register accesses
are being trapped.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
---
 arch/arm64/include/asm/kvm_host.h       | 19 +++++
 arch/arm64/include/asm/vncr_mapping.h   |  3 +
 arch/arm64/kvm/arm.c                    |  3 +
 arch/arm64/kvm/config.c                 | 97 +++++++++++++++++++++++--
 arch/arm64/kvm/emulate-nested.c         | 68 +++++++++++++++++
 arch/arm64/kvm/hyp/include/hyp/switch.h | 27 +++++++
 arch/arm64/kvm/hyp/nvhe/switch.c        |  3 +
 arch/arm64/kvm/sys_regs.c               |  2 +
 8 files changed, 215 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm=
_host.h
index 70cb9cfd760a3..64a1ee6c442f0 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -287,6 +287,9 @@ enum fgt_group_id {
 	HDFGRTR2_GROUP,
 	HDFGWTR2_GROUP =3D HDFGRTR2_GROUP,
 	HFGITR2_GROUP,
+	ICH_HFGRTR_GROUP,
+	ICH_HFGWTR_GROUP =3D ICH_HFGRTR_GROUP,
+	ICH_HFGITR_GROUP,
=20
 	/* Must be last */
 	__NR_FGT_GROUP_IDS__
@@ -620,6 +623,10 @@ enum vcpu_sysreg {
 	VNCR(ICH_HCR_EL2),
 	VNCR(ICH_VMCR_EL2),
=20
+	VNCR(ICH_HFGRTR_EL2),
+	VNCR(ICH_HFGWTR_EL2),
+	VNCR(ICH_HFGITR_EL2),
+
 	NR_SYS_REGS	/* Nothing after this line! */
 };
=20
@@ -675,6 +682,9 @@ extern struct fgt_masks hfgwtr2_masks;
 extern struct fgt_masks hfgitr2_masks;
 extern struct fgt_masks hdfgrtr2_masks;
 extern struct fgt_masks hdfgwtr2_masks;
+extern struct fgt_masks ich_hfgrtr_masks;
+extern struct fgt_masks ich_hfgwtr_masks;
+extern struct fgt_masks ich_hfgitr_masks;
=20
 extern struct fgt_masks kvm_nvhe_sym(hfgrtr_masks);
 extern struct fgt_masks kvm_nvhe_sym(hfgwtr_masks);
@@ -687,6 +697,9 @@ extern struct fgt_masks kvm_nvhe_sym(hfgwtr2_masks);
 extern struct fgt_masks kvm_nvhe_sym(hfgitr2_masks);
 extern struct fgt_masks kvm_nvhe_sym(hdfgrtr2_masks);
 extern struct fgt_masks kvm_nvhe_sym(hdfgwtr2_masks);
+extern struct fgt_masks kvm_nvhe_sym(ich_hfgrtr_masks);
+extern struct fgt_masks kvm_nvhe_sym(ich_hfgwtr_masks);
+extern struct fgt_masks kvm_nvhe_sym(ich_hfgitr_masks);
=20
 struct kvm_cpu_context {
 	struct user_pt_regs regs;	/* sp =3D sp_el0 */
@@ -1659,6 +1672,11 @@ static __always_inline enum fgt_group_id __fgt_reg_t=
o_group_id(enum vcpu_sysreg
 	case HDFGRTR2_EL2:
 	case HDFGWTR2_EL2:
 		return HDFGRTR2_GROUP;
+	case ICH_HFGRTR_EL2:
+	case ICH_HFGWTR_EL2:
+		return ICH_HFGRTR_GROUP;
+	case ICH_HFGITR_EL2:
+		return ICH_HFGITR_GROUP;
 	default:
 		BUILD_BUG_ON(1);
 	}
@@ -1673,6 +1691,7 @@ static __always_inline enum fgt_group_id __fgt_reg_to=
_group_id(enum vcpu_sysreg
 		case HDFGWTR_EL2:					\
 		case HFGWTR2_EL2:					\
 		case HDFGWTR2_EL2:					\
+		case ICH_HFGWTR_EL2:					\
 			p =3D &(vcpu)->arch.fgt[id].w;			\
 			break;						\
 		default:						\
diff --git a/arch/arm64/include/asm/vncr_mapping.h b/arch/arm64/include/asm=
/vncr_mapping.h
index c2485a862e690..14366d35ce82f 100644
--- a/arch/arm64/include/asm/vncr_mapping.h
+++ b/arch/arm64/include/asm/vncr_mapping.h
@@ -108,5 +108,8 @@
 #define VNCR_MPAMVPM5_EL2       0x968
 #define VNCR_MPAMVPM6_EL2       0x970
 #define VNCR_MPAMVPM7_EL2       0x978
+#define VNCR_ICH_HFGITR_EL2	0xB10
+#define VNCR_ICH_HFGRTR_EL2	0xB18
+#define VNCR_ICH_HFGWTR_EL2	0xB20
=20
 #endif /* __ARM64_VNCR_MAPPING_H__ */
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 4e46336798946..0b27e2c437be7 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2529,6 +2529,9 @@ static void kvm_hyp_init_symbols(void)
 	kvm_nvhe_sym(hfgitr2_masks) =3D hfgitr2_masks;
 	kvm_nvhe_sym(hdfgrtr2_masks)=3D hdfgrtr2_masks;
 	kvm_nvhe_sym(hdfgwtr2_masks)=3D hdfgwtr2_masks;
+	kvm_nvhe_sym(ich_hfgrtr_masks) =3D ich_hfgrtr_masks;
+	kvm_nvhe_sym(ich_hfgwtr_masks) =3D ich_hfgwtr_masks;
+	kvm_nvhe_sym(ich_hfgitr_masks) =3D ich_hfgitr_masks;
=20
 	/*
 	 * Flush entire BSS since part of its data containing init symbols is rea=
d
diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index d9f553cbf9dfd..e4ec1bda8dfcb 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -225,6 +225,7 @@ struct reg_feat_map_desc {
 #define FEAT_MTPMU		ID_AA64DFR0_EL1, MTPMU, IMP
 #define FEAT_HCX		ID_AA64MMFR1_EL1, HCX, IMP
 #define FEAT_S2PIE		ID_AA64MMFR3_EL1, S2PIE, IMP
+#define FEAT_GCIE		ID_AA64PFR2_EL1, GCIE, IMP
=20
 static bool not_feat_aa64el3(struct kvm *kvm)
 {
@@ -1277,6 +1278,58 @@ static const struct reg_bits_to_feat_map vtcr_el2_fe=
at_map[] =3D {
 static const DECLARE_FEAT_MAP(vtcr_el2_desc, VTCR_EL2,
 			      vtcr_el2_feat_map, FEAT_AA64EL2);
=20
+static const struct reg_bits_to_feat_map ich_hfgrtr_feat_map[] =3D {
+	NEEDS_FEAT(ICH_HFGRTR_EL2_ICC_APR_EL1 |
+		   ICH_HFGRTR_EL2_ICC_IDRn_EL1 |
+		   ICH_HFGRTR_EL2_ICC_CR0_EL1 |
+		   ICH_HFGRTR_EL2_ICC_HPPIR_EL1 |
+		   ICH_HFGRTR_EL2_ICC_PCR_EL1 |
+		   ICH_HFGRTR_EL2_ICC_ICSR_EL1 |
+		   ICH_HFGRTR_EL2_ICC_IAFFIDR_EL1 |
+		   ICH_HFGRTR_EL2_ICC_PPI_HMRn_EL1 |
+		   ICH_HFGRTR_EL2_ICC_PPI_ENABLERn_EL1 |
+		   ICH_HFGRTR_EL2_ICC_PPI_PENDRn_EL1 |
+		   ICH_HFGRTR_EL2_ICC_PPI_PRIORITYRn_EL1 |
+		   ICH_HFGRTR_EL2_ICC_PPI_ACTIVERn_EL1,
+		   FEAT_GCIE),
+};
+
+static const DECLARE_FEAT_MAP_FGT(ich_hfgrtr_desc, ich_hfgrtr_masks,
+				  ich_hfgrtr_feat_map, FEAT_GCIE);
+
+static const struct reg_bits_to_feat_map ich_hfgwtr_feat_map[] =3D {
+	NEEDS_FEAT(ICH_HFGWTR_EL2_ICC_APR_EL1 |
+		   ICH_HFGWTR_EL2_ICC_CR0_EL1 |
+		   ICH_HFGWTR_EL2_ICC_PCR_EL1 |
+		   ICH_HFGWTR_EL2_ICC_ICSR_EL1 |
+		   ICH_HFGWTR_EL2_ICC_PPI_ENABLERn_EL1 |
+		   ICH_HFGWTR_EL2_ICC_PPI_PENDRn_EL1 |
+		   ICH_HFGWTR_EL2_ICC_PPI_PRIORITYRn_EL1 |
+		   ICH_HFGWTR_EL2_ICC_PPI_ACTIVERn_EL1,
+		   FEAT_GCIE),
+};
+
+static const DECLARE_FEAT_MAP_FGT(ich_hfgwtr_desc, ich_hfgwtr_masks,
+				  ich_hfgwtr_feat_map, FEAT_GCIE);
+
+static const struct reg_bits_to_feat_map ich_hfgitr_feat_map[] =3D {
+	NEEDS_FEAT(ICH_HFGITR_EL2_GICCDEN |
+		   ICH_HFGITR_EL2_GICCDDIS |
+		   ICH_HFGITR_EL2_GICCDPRI |
+		   ICH_HFGITR_EL2_GICCDAFF |
+		   ICH_HFGITR_EL2_GICCDPEND |
+		   ICH_HFGITR_EL2_GICCDRCFG |
+		   ICH_HFGITR_EL2_GICCDHM |
+		   ICH_HFGITR_EL2_GICCDEOI |
+		   ICH_HFGITR_EL2_GICCDDI |
+		   ICH_HFGITR_EL2_GICRCDIA |
+		   ICH_HFGITR_EL2_GICRCDNMIA,
+		   FEAT_GCIE),
+};
+
+static const DECLARE_FEAT_MAP_FGT(ich_hfgitr_desc, ich_hfgitr_masks,
+				  ich_hfgitr_feat_map, FEAT_GCIE);
+
 static void __init check_feat_map(const struct reg_bits_to_feat_map *map,
 				  int map_size, u64 resx, const char *str)
 {
@@ -1328,6 +1381,9 @@ void __init check_feature_map(void)
 	check_reg_desc(&sctlr_el2_desc);
 	check_reg_desc(&mdcr_el2_desc);
 	check_reg_desc(&vtcr_el2_desc);
+	check_reg_desc(&ich_hfgrtr_desc);
+	check_reg_desc(&ich_hfgwtr_desc);
+	check_reg_desc(&ich_hfgitr_desc);
 }
=20
 static bool idreg_feat_match(struct kvm *kvm, const struct reg_bits_to_fea=
t_map *map)
@@ -1460,6 +1516,13 @@ void compute_fgu(struct kvm *kvm, enum fgt_group_id =
fgt)
 		val |=3D compute_fgu_bits(kvm, &hdfgrtr2_desc);
 		val |=3D compute_fgu_bits(kvm, &hdfgwtr2_desc);
 		break;
+	case ICH_HFGRTR_GROUP:
+		val |=3D compute_fgu_bits(kvm, &ich_hfgrtr_desc);
+		val |=3D compute_fgu_bits(kvm, &ich_hfgwtr_desc);
+		break;
+	case ICH_HFGITR_GROUP:
+		val |=3D compute_fgu_bits(kvm, &ich_hfgitr_desc);
+		break;
 	default:
 		BUG();
 	}
@@ -1531,6 +1594,15 @@ struct resx get_reg_fixed_bits(struct kvm *kvm, enum=
 vcpu_sysreg reg)
 	case VTCR_EL2:
 		resx =3D compute_reg_resx_bits(kvm, &vtcr_el2_desc, 0, 0);
 		break;
+	case ICH_HFGRTR_EL2:
+		resx =3D compute_reg_resx_bits(kvm, &ich_hfgrtr_desc, 0, 0);
+		break;
+	case ICH_HFGWTR_EL2:
+		resx =3D compute_reg_resx_bits(kvm, &ich_hfgwtr_desc, 0, 0);
+		break;
+	case ICH_HFGITR_EL2:
+		resx =3D compute_reg_resx_bits(kvm, &ich_hfgitr_desc, 0, 0);
+		break;
 	default:
 		WARN_ON_ONCE(1);
 		resx =3D (typeof(resx)){};
@@ -1565,6 +1637,12 @@ static __always_inline struct fgt_masks *__fgt_reg_t=
o_masks(enum vcpu_sysreg reg
 		return &hdfgrtr2_masks;
 	case HDFGWTR2_EL2:
 		return &hdfgwtr2_masks;
+	case ICH_HFGRTR_EL2:
+		return &ich_hfgrtr_masks;
+	case ICH_HFGWTR_EL2:
+		return &ich_hfgwtr_masks;
+	case ICH_HFGITR_EL2:
+		return &ich_hfgitr_masks;
 	default:
 		BUILD_BUG_ON(1);
 	}
@@ -1618,12 +1696,17 @@ void kvm_vcpu_load_fgt(struct kvm_vcpu *vcpu)
 	__compute_hdfgwtr(vcpu);
 	__compute_fgt(vcpu, HAFGRTR_EL2);
=20
-	if (!cpus_have_final_cap(ARM64_HAS_FGT2))
-		return;
+	if (cpus_have_final_cap(ARM64_HAS_FGT2)) {
+		__compute_fgt(vcpu, HFGRTR2_EL2);
+		__compute_fgt(vcpu, HFGWTR2_EL2);
+		__compute_fgt(vcpu, HFGITR2_EL2);
+		__compute_fgt(vcpu, HDFGRTR2_EL2);
+		__compute_fgt(vcpu, HDFGWTR2_EL2);
+	}
=20
-	__compute_fgt(vcpu, HFGRTR2_EL2);
-	__compute_fgt(vcpu, HFGWTR2_EL2);
-	__compute_fgt(vcpu, HFGITR2_EL2);
-	__compute_fgt(vcpu, HDFGRTR2_EL2);
-	__compute_fgt(vcpu, HDFGWTR2_EL2);
+	if (cpus_have_final_cap(ARM64_HAS_GICV5_CPUIF)) {
+		__compute_fgt(vcpu, ICH_HFGRTR_EL2);
+		__compute_fgt(vcpu, ICH_HFGWTR_EL2);
+		__compute_fgt(vcpu, ICH_HFGITR_EL2);
+	}
 }
diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-neste=
d.c
index 22d497554c949..dba7ced74ca5e 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -2053,6 +2053,60 @@ static const struct encoding_to_trap_config encoding=
_to_fgt[] __initconst =3D {
 	SR_FGT(SYS_AMEVCNTR0_EL0(2),	HAFGRTR, AMEVCNTR02_EL0, 1),
 	SR_FGT(SYS_AMEVCNTR0_EL0(1),	HAFGRTR, AMEVCNTR01_EL0, 1),
 	SR_FGT(SYS_AMEVCNTR0_EL0(0),	HAFGRTR, AMEVCNTR00_EL0, 1),
+
+	/*
+	 * ICH_HFGRTR_EL2 & ICH_HFGWTR_EL2
+	 */
+	SR_FGT(SYS_ICC_APR_EL1,			ICH_HFGRTR, ICC_APR_EL1, 0),
+	SR_FGT(SYS_ICC_IDR0_EL1,		ICH_HFGRTR, ICC_IDRn_EL1, 0),
+	SR_FGT(SYS_ICC_CR0_EL1,			ICH_HFGRTR, ICC_CR0_EL1, 0),
+	SR_FGT(SYS_ICC_HPPIR_EL1,		ICH_HFGRTR, ICC_HPPIR_EL1, 0),
+	SR_FGT(SYS_ICC_PCR_EL1,			ICH_HFGRTR, ICC_PCR_EL1, 0),
+	SR_FGT(SYS_ICC_ICSR_EL1,		ICH_HFGRTR, ICC_ICSR_EL1, 0),
+	SR_FGT(SYS_ICC_IAFFIDR_EL1,		ICH_HFGRTR, ICC_IAFFIDR_EL1, 0),
+	SR_FGT(SYS_ICC_PPI_HMR0_EL1,		ICH_HFGRTR, ICC_PPI_HMRn_EL1, 0),
+	SR_FGT(SYS_ICC_PPI_HMR1_EL1,		ICH_HFGRTR, ICC_PPI_HMRn_EL1, 0),
+	SR_FGT(SYS_ICC_PPI_ENABLER0_EL1,	ICH_HFGRTR, ICC_PPI_ENABLERn_EL1, 0),
+	SR_FGT(SYS_ICC_PPI_ENABLER1_EL1,	ICH_HFGRTR, ICC_PPI_ENABLERn_EL1, 0),
+	SR_FGT(SYS_ICC_PPI_CPENDR0_EL1,		ICH_HFGRTR, ICC_PPI_PENDRn_EL1, 0),
+	SR_FGT(SYS_ICC_PPI_CPENDR1_EL1,		ICH_HFGRTR, ICC_PPI_PENDRn_EL1, 0),
+	SR_FGT(SYS_ICC_PPI_SPENDR0_EL1,		ICH_HFGRTR, ICC_PPI_PENDRn_EL1, 0),
+	SR_FGT(SYS_ICC_PPI_SPENDR1_EL1,		ICH_HFGRTR, ICC_PPI_PENDRn_EL1, 0),
+	SR_FGT(SYS_ICC_PPI_PRIORITYR0_EL1,	ICH_HFGRTR, ICC_PPI_PRIORITYRn_EL1, 0)=
,
+	SR_FGT(SYS_ICC_PPI_PRIORITYR1_EL1,	ICH_HFGRTR, ICC_PPI_PRIORITYRn_EL1, 0)=
,
+	SR_FGT(SYS_ICC_PPI_PRIORITYR2_EL1,	ICH_HFGRTR, ICC_PPI_PRIORITYRn_EL1, 0)=
,
+	SR_FGT(SYS_ICC_PPI_PRIORITYR3_EL1,	ICH_HFGRTR, ICC_PPI_PRIORITYRn_EL1, 0)=
,
+	SR_FGT(SYS_ICC_PPI_PRIORITYR4_EL1,	ICH_HFGRTR, ICC_PPI_PRIORITYRn_EL1, 0)=
,
+	SR_FGT(SYS_ICC_PPI_PRIORITYR5_EL1,	ICH_HFGRTR, ICC_PPI_PRIORITYRn_EL1, 0)=
,
+	SR_FGT(SYS_ICC_PPI_PRIORITYR6_EL1,	ICH_HFGRTR, ICC_PPI_PRIORITYRn_EL1, 0)=
,
+	SR_FGT(SYS_ICC_PPI_PRIORITYR7_EL1,	ICH_HFGRTR, ICC_PPI_PRIORITYRn_EL1, 0)=
,
+	SR_FGT(SYS_ICC_PPI_PRIORITYR8_EL1,	ICH_HFGRTR, ICC_PPI_PRIORITYRn_EL1, 0)=
,
+	SR_FGT(SYS_ICC_PPI_PRIORITYR9_EL1,	ICH_HFGRTR, ICC_PPI_PRIORITYRn_EL1, 0)=
,
+	SR_FGT(SYS_ICC_PPI_PRIORITYR10_EL1,	ICH_HFGRTR, ICC_PPI_PRIORITYRn_EL1, 0=
),
+	SR_FGT(SYS_ICC_PPI_PRIORITYR11_EL1,	ICH_HFGRTR, ICC_PPI_PRIORITYRn_EL1, 0=
),
+	SR_FGT(SYS_ICC_PPI_PRIORITYR12_EL1,	ICH_HFGRTR, ICC_PPI_PRIORITYRn_EL1, 0=
),
+	SR_FGT(SYS_ICC_PPI_PRIORITYR13_EL1,	ICH_HFGRTR, ICC_PPI_PRIORITYRn_EL1, 0=
),
+	SR_FGT(SYS_ICC_PPI_PRIORITYR14_EL1,	ICH_HFGRTR, ICC_PPI_PRIORITYRn_EL1, 0=
),
+	SR_FGT(SYS_ICC_PPI_PRIORITYR15_EL1,	ICH_HFGRTR, ICC_PPI_PRIORITYRn_EL1, 0=
),
+	SR_FGT(SYS_ICC_PPI_CACTIVER0_EL1,	ICH_HFGRTR, ICC_PPI_ACTIVERn_EL1, 0),
+	SR_FGT(SYS_ICC_PPI_CACTIVER1_EL1,	ICH_HFGRTR, ICC_PPI_ACTIVERn_EL1, 0),
+	SR_FGT(SYS_ICC_PPI_SACTIVER0_EL1,	ICH_HFGRTR, ICC_PPI_ACTIVERn_EL1, 0),
+	SR_FGT(SYS_ICC_PPI_SACTIVER1_EL1,	ICH_HFGRTR, ICC_PPI_ACTIVERn_EL1, 0),
+
+	/*
+	 * ICH_HFGITR_EL2
+	 */
+	SR_FGT(GICV5_OP_GIC_CDEN,	ICH_HFGITR, GICCDEN, 0),
+	SR_FGT(GICV5_OP_GIC_CDDIS,	ICH_HFGITR, GICCDDIS, 0),
+	SR_FGT(GICV5_OP_GIC_CDPRI,	ICH_HFGITR, GICCDPRI, 0),
+	SR_FGT(GICV5_OP_GIC_CDAFF,	ICH_HFGITR, GICCDAFF, 0),
+	SR_FGT(GICV5_OP_GIC_CDPEND,	ICH_HFGITR, GICCDPEND, 0),
+	SR_FGT(GICV5_OP_GIC_CDRCFG,	ICH_HFGITR, GICCDRCFG, 0),
+	SR_FGT(GICV5_OP_GIC_CDHM,	ICH_HFGITR, GICCDHM, 0),
+	SR_FGT(GICV5_OP_GIC_CDEOI,	ICH_HFGITR, GICCDEOI, 0),
+	SR_FGT(GICV5_OP_GIC_CDDI,	ICH_HFGITR, GICCDDI, 0),
+	SR_FGT(GICV5_OP_GICR_CDIA,	ICH_HFGITR, GICRCDIA, 0),
+	SR_FGT(GICV5_OP_GICR_CDNMIA,	ICH_HFGITR, GICRCDNMIA, 0),
 };
=20
 /*
@@ -2127,6 +2181,9 @@ FGT_MASKS(hfgwtr2_masks, HFGWTR2_EL2);
 FGT_MASKS(hfgitr2_masks, HFGITR2_EL2);
 FGT_MASKS(hdfgrtr2_masks, HDFGRTR2_EL2);
 FGT_MASKS(hdfgwtr2_masks, HDFGWTR2_EL2);
+FGT_MASKS(ich_hfgrtr_masks, ICH_HFGRTR_EL2);
+FGT_MASKS(ich_hfgwtr_masks, ICH_HFGWTR_EL2);
+FGT_MASKS(ich_hfgitr_masks, ICH_HFGITR_EL2);
=20
 static __init bool aggregate_fgt(union trap_config tc)
 {
@@ -2162,6 +2219,14 @@ static __init bool aggregate_fgt(union trap_config t=
c)
 		rmasks =3D &hfgitr2_masks;
 		wmasks =3D NULL;
 		break;
+	case ICH_HFGRTR_GROUP:
+		rmasks =3D &ich_hfgrtr_masks;
+		wmasks =3D &ich_hfgwtr_masks;
+		break;
+	case ICH_HFGITR_GROUP:
+		rmasks =3D &ich_hfgitr_masks;
+		wmasks =3D NULL;
+		break;
 	}
=20
 	rresx =3D rmasks->res0 | rmasks->res1;
@@ -2232,6 +2297,9 @@ static __init int check_all_fgt_masks(int ret)
 		&hfgitr2_masks,
 		&hdfgrtr2_masks,
 		&hdfgwtr2_masks,
+		&ich_hfgrtr_masks,
+		&ich_hfgwtr_masks,
+		&ich_hfgitr_masks,
 	};
 	int err =3D 0;
=20
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/i=
nclude/hyp/switch.h
index 2597e8bda8672..ae04fd680d1e2 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -233,6 +233,18 @@ static inline void __activate_traps_hfgxtr(struct kvm_=
vcpu *vcpu)
 	__activate_fgt(hctxt, vcpu, HDFGWTR2_EL2);
 }
=20
+static inline void __activate_traps_ich_hfgxtr(struct kvm_vcpu *vcpu)
+{
+	struct kvm_cpu_context *hctxt =3D host_data_ptr(host_ctxt);
+
+	if (!cpus_have_final_cap(ARM64_HAS_GICV5_CPUIF))
+		return;
+
+	__activate_fgt(hctxt, vcpu, ICH_HFGRTR_EL2);
+	__activate_fgt(hctxt, vcpu, ICH_HFGWTR_EL2);
+	__activate_fgt(hctxt, vcpu, ICH_HFGITR_EL2);
+}
+
 #define __deactivate_fgt(htcxt, vcpu, reg)				\
 	do {								\
 		write_sysreg_s(ctxt_sys_reg(hctxt, reg),		\
@@ -265,6 +277,19 @@ static inline void __deactivate_traps_hfgxtr(struct kv=
m_vcpu *vcpu)
 	__deactivate_fgt(hctxt, vcpu, HDFGWTR2_EL2);
 }
=20
+static inline void __deactivate_traps_ich_hfgxtr(struct kvm_vcpu *vcpu)
+{
+	struct kvm_cpu_context *hctxt =3D host_data_ptr(host_ctxt);
+
+	if (!cpus_have_final_cap(ARM64_HAS_GICV5_CPUIF))
+		return;
+
+	__deactivate_fgt(hctxt, vcpu, ICH_HFGRTR_EL2);
+	__deactivate_fgt(hctxt, vcpu, ICH_HFGWTR_EL2);
+	__deactivate_fgt(hctxt, vcpu, ICH_HFGITR_EL2);
+
+}
+
 static inline void  __activate_traps_mpam(struct kvm_vcpu *vcpu)
 {
 	u64 r =3D MPAM2_EL2_TRAPMPAM0EL1 | MPAM2_EL2_TRAPMPAM1EL1;
@@ -328,6 +353,7 @@ static inline void __activate_traps_common(struct kvm_v=
cpu *vcpu)
 	}
=20
 	__activate_traps_hfgxtr(vcpu);
+	__activate_traps_ich_hfgxtr(vcpu);
 	__activate_traps_mpam(vcpu);
 }
=20
@@ -345,6 +371,7 @@ static inline void __deactivate_traps_common(struct kvm=
_vcpu *vcpu)
 		write_sysreg_s(ctxt_sys_reg(hctxt, HCRX_EL2), SYS_HCRX_EL2);
=20
 	__deactivate_traps_hfgxtr(vcpu);
+	__deactivate_traps_ich_hfgxtr(vcpu);
 	__deactivate_traps_mpam();
 }
=20
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/swi=
tch.c
index 779089e42681e..b41485ce295ab 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -44,6 +44,9 @@ struct fgt_masks hfgwtr2_masks;
 struct fgt_masks hfgitr2_masks;
 struct fgt_masks hdfgrtr2_masks;
 struct fgt_masks hdfgwtr2_masks;
+struct fgt_masks ich_hfgrtr_masks;
+struct fgt_masks ich_hfgwtr_masks;
+struct fgt_masks ich_hfgitr_masks;
=20
 extern void kvm_nvhe_prepare_backtrace(unsigned long fp, unsigned long pc)=
;
=20
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 140cf35f4eeb4..cd6deaf473159 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -5661,6 +5661,8 @@ void kvm_calculate_traps(struct kvm_vcpu *vcpu)
 	compute_fgu(kvm, HFGRTR2_GROUP);
 	compute_fgu(kvm, HFGITR2_GROUP);
 	compute_fgu(kvm, HDFGRTR2_GROUP);
+	compute_fgu(kvm, ICH_HFGRTR_GROUP);
+	compute_fgu(kvm, ICH_HFGITR_GROUP);
=20
 	set_bit(KVM_ARCH_FLAG_FGU_INITIALIZED, &kvm->arch.flags);
 out:
--=20
2.34.1
