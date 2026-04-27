Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011039.outbound.protection.outlook.com [40.107.130.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC98D348898
	for <kvmarm@lists.linux.dev>; Mon, 27 Apr 2026 16:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.39
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777306037; cv=fail; b=Yus9WB+eKeHDSaIzs0gJOaYV7dDqNy+3jezsaewzNhPPKkBKHOv5RG6hWvMHpSn8qOCpu8+nINMMyk/sj+ye/FYQ4XFai6VATO/LBzuLWbA/qkFVo3BKvL3gX7eqbISrG3nMUdq118C1a718r9bh3POpeAzfgCf7GzzWEZhGTOY=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777306037; c=relaxed/simple;
	bh=P7iilhX/m6EvoqAuxU3QvtA0LX8XrDOdu8KhywwYUZk=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=JONspV+IC9FTAA401YDoy36LtXwi7lv6G03W0VBIdcfTUQ9z3lPbMO1q7e4NrrU7NMvJowyMqJJTJWwfVUx9nisL71ES2USxY+gqTBlexlgol3Vwu7FMhLS0B0O9Xm4LL0y1AV8I27g9AGaUJqBZpFd3Qm/IA31pP9LNxnEjntQ=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=V+z1lwoJ; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=V+z1lwoJ; arc=fail smtp.client-ip=40.107.130.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="V+z1lwoJ";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="V+z1lwoJ"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=VdRkbw7ldhSjaSZjAPTV2LeulAUDgEJRZ/KpzR0yhqlI+crH+YWWSWSRjDyuhdMyG2dFRJsuBL2OQXczDOo1cH8ssSdTt9Tt1YYjKUtRbm0vuQcRjlBJwv5fCa3rPWKsw04kfHjM2VI/qkohB2VxN0BYztGRXBNjWchNqBkRcNPn2PU+thBCOygfweBcQw75DRVBlBqURUpwm60GQpSpitE9qnfentzQdt6amZ4ighGI4OtrUdIywqoUvZNJrZp0ayHkC+kbpmY+bSSdVXMhfDTjIyYC38siIUqOhY99zaHcEAENuomcghGSaJ5C2nf2ZdIsYf6gQyceOke/lMKw7Q==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mdF63JcQg4/82I5PM8ujUpOJwiOOVXWIDWY9QpdU46E=;
 b=nnp9xr+ndRyr686hGLAHgI+Oa3A0+03ZEMkJoRymoDn0JXH24OxLzK26UHrwbRS4GIMAP537Y9IL0f/xWZ4AaYGPSCifs8NC/f67SJs5gmuNodfHf4q+lw7Z7SLa48FaZX5T4SawNlQAlnPqyPQWf1bxIUSYx2/xrR/kJGupb5l1QjXBN890ueCYomv5FqBMx0K8nELav0wj4Xs89xpmIolHPLhjXDPnZz8ELovtpe2i6Lkocl07E3342PZu86zpHt+3XXV4rFTxYg/e291rSCIOGZHUyJhsovemYjiTNl5wZt2vK1Be3zD5vWAVK48uBg0wBRm011ia0vGpcFdzag==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mdF63JcQg4/82I5PM8ujUpOJwiOOVXWIDWY9QpdU46E=;
 b=V+z1lwoJFYEPVkR9PBIzu0+d4pvuCj1X6Q55Z3d2dzvcFALPfbMkO6SFH6rBYs11y2e8UA7v018SKEjhOFGdQ6ceIJlf438cbiulLMh1PmPWTY4Rf8wDOG8mjd+WQiLBViI8Rv0oQrfHrumkjD3IXZXp1xVtsov64RSnlAiTxCk=
Received: from CWLP265CA0420.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:1b6::18)
 by AS2PR08MB8430.eurprd08.prod.outlook.com (2603:10a6:20b:559::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Mon, 27 Apr
 2026 16:07:08 +0000
Received: from AMS0EPF0000019D.eurprd05.prod.outlook.com
 (2603:10a6:400:1b6:cafe::ea) by CWLP265CA0420.outlook.office365.com
 (2603:10a6:400:1b6::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9846.26 via Frontend Transport; Mon,
 27 Apr 2026 16:07:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF0000019D.mail.protection.outlook.com (10.167.16.249) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9846.18
 via Frontend Transport; Mon, 27 Apr 2026 16:07:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Sg0g7RYexIZCo2PSipGHpwZDCovWdknNolyThGrYwqMm+tXHQGmjIYN+MJHoSOw89FH3lDnxGWG05S+9zvuDkrirm4XQfwKuI3nlVR4aQSLjPmHWocoMBkzclGb5sCjWBPtAYgspj+psFteccx55c5ZAHfzkh0ueFXXOvuVzbag1wQkNKp5C0m4R0+GYjOP5SAsvMQjUEAOVJFfXQwU5Ve/GSPs4wNIG4KSuJ45SPIKjBujMiFqvQaWUiS4LIILYKcK5/+RXjrgRUOLKp86y4sRjSGdkpd9++vwoQ+gqBpIe/bx0znDR3xyznxCpZyLXF6Dxo5UfaunUvWzIb5fI2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mdF63JcQg4/82I5PM8ujUpOJwiOOVXWIDWY9QpdU46E=;
 b=k6+Xtte0c8NIK5TQnNZL2oqKLyFAQsdSCk9ej9q1uAnBd8Ql0LfaXTqP+DnktAqEPXYGAT5yWO1YUxwvMHdQLi/v50IBN8MDD9OFzlaBOAaLO6U3XhvsUey/ixO3m9s+N2PNVV5x/D76QCrmKjoesbMbbL0l634TQZXc/ECZOI2wsg9b6yJH/4SiVY1wJkAIkh5FtGJ84tkGFqsFp5i2NtXUTvxd0xmnI5so7EbhSU8cxxtpcToW7WfrW0HLPWFS/NZdTxwHSAkCThLFYgxQaXTr8owlaMtkXqyQQa13Fe2c4DbcwGfiY5o202RThnc12xv6TE3WV5ZxTYnKtdLjRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mdF63JcQg4/82I5PM8ujUpOJwiOOVXWIDWY9QpdU46E=;
 b=V+z1lwoJFYEPVkR9PBIzu0+d4pvuCj1X6Q55Z3d2dzvcFALPfbMkO6SFH6rBYs11y2e8UA7v018SKEjhOFGdQ6ceIJlf438cbiulLMh1PmPWTY4Rf8wDOG8mjd+WQiLBViI8Rv0oQrfHrumkjD3IXZXp1xVtsov64RSnlAiTxCk=
Received: from VI1PR08MB3408.eurprd08.prod.outlook.com (2603:10a6:803:7c::10)
 by GV1PR08MB8308.eurprd08.prod.outlook.com (2603:10a6:150:a5::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Mon, 27 Apr
 2026 16:06:02 +0000
Received: from VI1PR08MB3408.eurprd08.prod.outlook.com
 ([fe80::6daa:d2f4:acf1:84ba]) by VI1PR08MB3408.eurprd08.prod.outlook.com
 ([fe80::6daa:d2f4:acf1:84ba%7]) with mapi id 15.20.9846.025; Mon, 27 Apr 2026
 16:06:01 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey Gouly
	<Joey.Gouly@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	Timothy Hayes <Timothy.Hayes@arm.com>
Subject: [PATCH 00/43] KVM: arm64: Add GICv5 IRS support
Thread-Topic: [PATCH 00/43] KVM: arm64: Add GICv5 IRS support
Thread-Index: AQHc1l++4cMd9DIErk2StF1f/tkWQw==
Date: Mon, 27 Apr 2026 16:06:01 +0000
Message-ID: <20260427160547.3129448-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	VI1PR08MB3408:EE_|GV1PR08MB8308:EE_|AMS0EPF0000019D:EE_|AS2PR08MB8430:EE_
X-MS-Office365-Filtering-Correlation-Id: 72a8bb29-000d-4a7b-adfe-08dea4770856
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|376014|56012099003|18002099003|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 nmWmLbvXfzr0Bfrjf1IciiMKY1YGs1u3KhnzSyUUP5wnzv7ESI8/FUtA9aM73Y3FT0ANB0njepqnJqCY3FBhRRj8MfEYf7XXf3v+G6tzm044pxj/JSkKS5muLkSsEYam1Vs2JgK1IhQFCVp6lI4HUY1vbQwIzYgg/w6CwOvzEg1jcOvLCSWJM7hD1RVzris8DYs0RKSCn262s2+BK9Wp1s/rsL+TDFT14BOvkTdJmYSNaaVO0Mybvj93LfWty+FsBttB/c/pQBfcbwzJf28dpxDRRE8m3SN072AshsXULRPoJWhg8WQ+AG10OaNBR/Rv1x9WQWB6M+sKRHfTzSH0VFpxQ7Kkd6KjYd7RsYn9WumveCu5pehmU43EEYNQabjcWNW5ZlgQBu5nPFW3RHN5mqBOYDa+MAPuf/qclxFzcKNEToiKGtN+syD1AC/WGqgS9glOnTid+83coZXIrEELIivwQrbe9ji2GlLxz4+ADWOZu2tk98yd+4pwa67WywMB60dBn3uZkRNR0IjZENM/94tdLo688/x4dvZX184T02DPjPYLUPDP4Asa9sMPkx+jWNd6omzkdNow3USn/EY4dm4/sVwiHnKNx0G/VlHh4hlsIjCYBxoOd3b+eAeqcu/vtMRk3FYZ77YgtEsrRY+W2AROWEV0fqeLh76lw3+vTOvxbM0on2/4nQp2c6GLUcyk8QjLje7rkAlhDvcRgnDemep2n2qbD8+S/vrHCvtDCqDF/h3ncfY63XMS1F/0VFv9XRWMFfQt24wH6O9u8tF5tTicFx+7q6x3hqd3nV4Ve5wxvyd0o2lR0Bq5mDkg1uK+
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3408.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(56012099003)(18002099003)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 NNmuvkrBGTVnEFdqKlPELEWW/YTv5h8Mko94Fv18wGxPYNuneVCS76uKITT++GjQshe6CYuZ02XOlciMcpKjobYCuF3lt6A5DJHYu8W4NtzJE7FLPlFFZwvMetk/PKJui9RNJiIWYUx5dfSWhoPoitYoPGt0DmsAilU+Gk5BfGBUG8rkcZb04Blepf+p8d2LsO2BcqMKXpcaApUrAR07ZDNljUJ5373cxrAt2e3EV5Mhfg571wTn9pfquPlm1aKbpvOsWz0kVKjsgCu+FaK6J3UIUeT+sU1NGPOaRcgOt3u6LV9FnIFXuoJhgLU5MHpvDrHgderNxMjk8f4Tf4y6Kw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR08MB8308
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF0000019D.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	8de30a99-7cdc-49ea-cd4c-08dea476e0c6
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|14060799003|35042699022|376014|36860700016|13003099007|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	lBqNFyJ3ufvgjFf9VM0tLMLwzx1zgOu7erGNzotljFvsK1qBS3410vyTtcGl4XUIk6J6ZgiAuuUz0AVav/gNLL1krNHqlzNnbFMZeWSzmWhqe+0n2VXiEi+CdkEigzauf78jwMQ2AAbqhrq8QJrY1Vn+d92AEKi8quLWu9O4/w8xopgxKV6pmGfDvcCloP6HgkLT5jfCIcWWfL7Jb9EHOD/qrVZV91e5aihlBGZ5CdOcVUQfirm5FSNc6Jq0MVv7p7bDZSK0SDRTpaKfNiPGCs2qF/25dNSgljbX9gsY24utSlrQkBd7vF8Ofy5K+G++IRaH5uTwbrqQSC6544nBq0YqYivcrdbCY6d0sxx9FaNLJ41y2zAbJ5O/1oai5mqVFvuKKsPoym4ywfqHyF7/SfCnnGIW95jCXySa4RfN8Pbc+yVVTytXmQhzR9NWQDffPPOgCIA75p9k2H0/JnnX4uOpzEPLCFk0PG60I8rzNSvlEGocCoGVwb91gyC5zP2UObDSFBUi1I7LzIUfs5o0rpBltwrKg+Wfzuvmtg+jDT5RNXxOE6hOYUOGPlkRaDc6SUUG3qHm1V/FmYLxVoLpXe1jkRfUe9vk6QKv7WlQGXBgVb4NWNS5cPJ8EHjkSH0JEokLLwkGsAyhQkt5dFmZjzaQT4aLWIezB0t3S+dvHFC8bmrFrdpB5oVonKHQRYOYhj+V4vYtbEAXLm5iQg1vQSjsavqYAlySCbYio7owKrneshFdOvPhrfcomGV5E1mpmBMQIj8ZKRH9DEl1Ud79qVYyLpa3wmzTlvCiGWGCwOc=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(14060799003)(35042699022)(376014)(36860700016)(13003099007)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	nOfUX1yxCEX4h2BjTWv0nrFEfns6EZTbE+gAdUauS1gHF0cQjEq39xR7bq9Kn9dm0+HwG0QwYgdoSoTiod6A55RTJxUc+bTOHiJjT1QEyT+WsqF0Qy41WebN2KR/rKzbttS6Q11pxk/j9DI6hF0PkExWhs1UQX8/fnlJUftcqo1KfI7BZAAJoXaS1MA5Im5zdRv94oAnvRIlfFOyUQxHvMsmqQqEXxyAQQSoQevBJtytDQ5gkNAOhvFtD0JCTSu8YKSAiznYkVXvTOnhTJp9kXuRDjlAWKYBxwyj2BptSKyM6u7G3Sxeh/ADCJWCqqjieolTns6f3WD5J3OkMUhPFXD6T4ZGrtQNiH4F46Q5ySQfYluLHfgbRcjMnQc91pISL7Yf2DSuSfcq8hgt/KxNCkjexv/qunQMQ3at0dBp+T+Ob8ygOaS4rQlNLms3Xo03
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2026 16:07:08.0128
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 72a8bb29-000d-4a7b-adfe-08dea4770856
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF0000019D.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB8430

Hi all,

This series builds on the initial vGICv5 support [1] and adds support
for the GICv5 IRS, as described by the GICv5 (EAC0) specification [2].
With this, a GICv5 guest is no longer restricted to PPIs, and can
make use of SPIs and LPIs as well.

With SPIs and LPIs available, this series makes it possible to boot a
full Linux guest on the Arm FVP model [3], using the setup described
in Lorenzo's GICv5 Linux software enablement guide [4]. In addition,
GICv5 IPIs are typically implemented as LPIs, so LPI support is what
makes guests with more than one vCPU possible.

The corresponding kvmtool changes are available separately [5]. With
these changes, `--irqchip=3Dgicv5` works now. The `--irqchip=3Dgicv5-its`
configuration does not work with this series, as ITS/MSI support is not
included here.

The IRS is created as part of the vgic-v5 device, and is not a
separate KVM device. This is because implementing the CPU interface
alone would limit a guest to a single vCPU and PPIs only. Hence, the
IRS is bundled into the VGIC, much like the distributor for GICv3.

The series adds the host-side plumbing needed for KVM to interact with
the physical IRS, including VM and VPE table management, VPE residency,
and VPE doorbells. It also adds an emulated IRS MMIO interface for the
guest, together with the UAPI needed for userspace to configure the IRS
address and to save/restore the IRS and IST state.

The main pieces are:

* Host IRS capability discovery and configuration frame plumbing.

* Allocation and management of the GICv5 VM table, VPE table, VMTEs,
  VPEs, and guest IST backing storage.

* VPE residency and doorbell handling, allowing the IRS to select SPIs
  and LPIs for resident VPEs and wake non-resident VPEs when required.

* Emulation of the GICv5 IRS MMIO CONFIG_FRAME for guests.
  Virtualisation, MPAM, MEC, SWERR are not supported and are RAZ/WI.

* SPI injection support using GIC VDPEND, together with tracking of
  in-flight SPIs so that deactivation notifiers can still be handled.

* Save/restore support for GICv5 EL1 system registers, IRS MMIO state,
  and guest ISTs.

* Documentation for the new VGICv5 IRS userspace interfaces and the
  required save/restore ordering.

Please pay close attention to the save/restore interface and ordering,
in particular to make sure that no guest state has been omitted.

LPIs are explicitly driven by the guest through the IRS/IST state. This
series does not add direct LPI injection support, and does not add MSI
support. It also does not add GICv5 ITS emulation.

These changes are based on v7.1-rc1. They presume the existence of the
still-under-review changes in [6]. I've pushed the full set of changes
to a branch at [7].

Thanks for taking the time to look at these changes. Apologies for the
size of the series, but this is a rather hard set to disentangle and
review separately!

Thanks,
Sascha

[1] https://lore.kernel.org/all/20260319154937.3619520-1-sascha.bischoff@ar=
m.com/
[2] https://developer.arm.com/documentation/aes0070/latest
[3] https://developer.arm.com/documentation/108086/latest
[4] https://linaro.atlassian.net/wiki/x/CQAF-wY
[5] https://lore.kernel.org/all/20260116182606.61856-1-sascha.bischoff@arm.=
com/
[6] https://lore.kernel.org/all/20260415115559.2227718-1-maz@kernel.org/
[7] https://gitlab.arm.com/linux-arm/linux-sb/-/tree/gicv5_kvm_irs_support

Sascha Bischoff (43):
  arm64/sysreg: Add GICv5 GIC VDPEND and VDRCFG encodings
  arm64/sysreg: Update ICC_CR0_EL1 with LINK and LINK_IDLE fields
  KVM: arm64: gic-v5: Add resident/non-resident hyp calls
  irqchip/gic-v5: Provide IRS config frame attrs to KVM
  KVM: arm64: gic-v5: Extract host IRS caps from IRS config frame
  KVM: arm64: gic-v5: Add VPE doorbell domain
  KVM: arm64: gic-v5: Create & manage VM and VPE tables
  KVM: arm64: gic-v5: Introduce guest IST alloc and management
  KVM: arm64: gic-v5: Implement VMT/vIST IRS MMIO Ops
  KVM: arm64: gic-v5: Implement VPE IRS MMIO Ops
  KVM: arm64: gic-v5: Make VPEs valid in vgic_v5_reset()
  KVM: arm64: gic-v5: Clear db_fired flag before making VPE non-resident
  KVM: arm64: gic-v5: Make VPEs (non-)resident in vgic_load/put
  KVM: arm64: gic-v5: Request VPE doorbells when going non-resident
  KVM: arm64: gic-v5: Handle doorbells in kvm_vgic_vcpu_pending_irq()
  KVM: arm64: gic-v5: Initialise and teardown VMTEs & doorbells
  KVM: arm64: gic-v5: Enable VPE DBs on VPE reset and disable on
    teardown
  KVM: arm64: gic-v5: Define remaining IRS MMIO registers
  KVM: arm64: gic-v5: Introduce struct vgic_v5_irs and IRS base address
  KVM: arm64: gic-v5: Add IRS IODEV to iodev_types and generic MMIO
    handlers
  KVM: arm64: gic-v5: Add KVM_VGIC_V5_ADDR_TYPE_IRS to UAPI
  KVM: arm64: gic-v5: Add GICv5 IRS IODEV and MMIO emulation
  KVM: arm64: gic-v5: Set IRICHPPIDIS based on IRS enable state
  KVM: arm64: gic-v5: Call IRS init/teardown from vgic_v5 init/teardown
  KVM: arm64: gic-v5: Register the IRS IODEV
  Documentation: KVM: Extend VGICv5 docs for KVM_VGIC_V5_ADDR_TYPE_IRS
  KVM: arm64: selftests: Update vGICv5 selftest to set IRS address
  KVM: arm64: gic-v5: Introduce SPI AP list
  KVM: arm64: gic-v5: Add GIC VDPEND and GIC VDRCFG hyp calls
  KVM: arm64: gic-v5: Track SPI state for in-flight SPIs
  KVM: arm64: gic: Introduce set_pending_state() to irq_op
  KVM: arm64: gic-v5: Support SPI injection
  KVM: arm64: gic-v5: Add GICv5 SPI injection to irqfd
  KVM: arm64: gic-v5: Mask per-vcpu PPI state in
    vgic_v5_finalize_ppi_state()
  KVM: arm64: gic-v5: Add GICv5 EL1 sysreg userspace set/get interface
  KVM: arm64: gic-v5: Implement save/restore mechanisms for ISTs
  KVM: arm64: gic-v5: Handle userspace accesses to IRS MMIO region
  KVM: arm64: gic-v5: Add VGIC_GRP_IRS_REGS/VGIC_GRP_IST to UAPI
  KVM: arm64: gic-v5: Plumb in has/set/get_attr for sysregs & IRS MMIO
    regs
  Documentation: KVM: Document KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS for
    VGICv5
  Documentation: KVM: Add KVM_DEV_ARM_VGIC_GRP_IRS_REGS to VGICv5 docs
  Documentation: KVM: Add docs for KVM_DEV_ARM_VGIC_GRP_IST
  Documentation: KVM: Add the VGICv5 IRS save/restore sequences

 .../virt/kvm/devices/arm-vgic-v5.rst          |  224 ++-
 arch/arm64/include/asm/kvm_asm.h              |    4 +
 arch/arm64/include/asm/kvm_hyp.h              |    4 +
 arch/arm64/include/asm/sysreg.h               |   18 +-
 arch/arm64/include/uapi/asm/kvm.h             |    7 +
 arch/arm64/kvm/Makefile                       |    3 +-
 arch/arm64/kvm/arm.c                          |    2 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            |   33 +
 arch/arm64/kvm/hyp/vgic-v5-sr.c               |   54 +
 arch/arm64/kvm/sys_regs.c                     |    6 +-
 arch/arm64/kvm/vgic-sys-reg-v5.c              |  510 +++++
 arch/arm64/kvm/vgic/vgic-init.c               |   57 +-
 arch/arm64/kvm/vgic/vgic-irqfd.c              |   13 +-
 arch/arm64/kvm/vgic/vgic-irs-v5.c             | 1075 ++++++++++
 arch/arm64/kvm/vgic/vgic-kvm-device.c         |  235 ++-
 arch/arm64/kvm/vgic/vgic-mmio.c               |    6 +
 arch/arm64/kvm/vgic/vgic-mmio.h               |    2 +
 arch/arm64/kvm/vgic/vgic-v5-tables.c          | 1766 +++++++++++++++++
 arch/arm64/kvm/vgic/vgic-v5-tables.h          |  212 ++
 arch/arm64/kvm/vgic/vgic-v5.c                 | 1250 +++++++++++-
 arch/arm64/kvm/vgic/vgic.c                    |   25 +-
 arch/arm64/kvm/vgic/vgic.h                    |   20 +-
 arch/arm64/tools/sysreg                       |    4 +-
 drivers/irqchip/irq-gic-v5-irs.c              |   26 +
 drivers/irqchip/irq-gic-v5.c                  |    3 +
 include/kvm/arm_vgic.h                        |  126 +-
 include/linux/irqchip/arm-gic-v5.h            |  199 +-
 include/linux/irqchip/arm-vgic-info.h         |    5 +
 tools/arch/arm64/include/uapi/asm/kvm.h       |    2 +
 tools/testing/selftests/kvm/arm64/vgic_v5.c   |    6 +
 .../selftests/kvm/include/arm64/gic_v5.h      |    3 +
 31 files changed, 5791 insertions(+), 109 deletions(-)
 create mode 100644 arch/arm64/kvm/vgic-sys-reg-v5.c
 create mode 100644 arch/arm64/kvm/vgic/vgic-irs-v5.c
 create mode 100644 arch/arm64/kvm/vgic/vgic-v5-tables.c
 create mode 100644 arch/arm64/kvm/vgic/vgic-v5-tables.h

--=20
2.34.1
