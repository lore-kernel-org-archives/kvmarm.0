Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013033.outbound.protection.outlook.com [40.107.159.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 787783F8EB2;
	Fri, 10 Jul 2026 09:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.33
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783676764; cv=fail; b=myCpuxbR8uzdrLYFnaj+DJlIVfEeeMhF35K9fBaTXzW5Tta+x5RyW61Sz5JyVsqUz/76Wn5n3YwXHcYHGpJjzTOSo9N2tnQAnyAzyvqsfK5kcToB0x/+esgKodLVy2X+Tr5UVkvFZQx+KEw6qr1iniGKX9iCwXd7VaDUiugsDDo=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783676764; c=relaxed/simple;
	bh=EgR8F+3+pv3uxI6GJEbd7QTZziMp+QbIitYKFNEO64o=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ilBgkxUT/S59U9gCz1yC9iWzYdBLcLFr1CUV+r9LWE/m2MU5MxgBaiFtmQJjVaMt0NLQ2X8Lk6hdxAp+SAD6IM1+IjmUdJuaAjK92fXszQnK1anhogzSDtkYCfFAutcMZjAhNs+TIIZ8zYUW0zSKOG9JvTER1ICq21TKBDL6GiM=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ge+unyxr; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ge+unyxr; arc=fail smtp.client-ip=40.107.159.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ge+unyxr";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ge+unyxr"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=F1WSNqduUFsLigRUlLiH/vcchV9K1XbxyaCiF6/7Bp2UwCXJAKVDbKjULS9Hscs54OGqTbOee8yZwowlfovrs/SdXyTZqzluRhQNBbm155p33UEn+tOP9JJHmkq3JhbBGXmlefLzyifizLQpdD200cwBtq94D5GiTckPRro2ei7PJbTwMHgzskbltc9tQw7Mm3KCljg6UyVH61I6bDEBFn14Fd0aDsHv9GBNC2oQOUUcPsnZzyhTrRU8yN1BR0MOohgPTTqbt0aLUvrKXteqqB0GtD+pCoiBLVU/lkO0Imo9Fy/KSIr/AXjpJIqIFN6tN2s2MbBaMjuP1RPso/q0kA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EgR8F+3+pv3uxI6GJEbd7QTZziMp+QbIitYKFNEO64o=;
 b=ZBCzynZH1RwZ03fKDcsvVDMuRc+FGGdUYteua1wwjlDzzGGLqTIkmQu6tbLUFPp5Cdy51Yh5OYMdjXmTQmueq2sMZdmR4MQ/cUg3xguvEy2kS8BkiG3YNCagjSjDLnyo4k3oXIqLRINGa3mObE02cV9SkQzdlZRKR4VxW3drvwMSiHmpv9/hahmGE7T57PJuKRs+V1z5Cqu/ByvKCoapqoPIHOESN6BeV1wz3XRifpg6wU2rjNrgp2puoU83TvpFibDPJ7i9WV/yKN2FziMU5L3JGdT40cxb1x3mMsr9DQZdFqiq+XDxdf85NLQHwUuBet+MqLhaOloK7dtG8QC0tA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EgR8F+3+pv3uxI6GJEbd7QTZziMp+QbIitYKFNEO64o=;
 b=ge+unyxrrQJpjYSazTVs1dZu3U7Lu3WuN4ziBHYUy23/7d4iRjdRofzBodLONfax7jB3v+iUEEhECI32FPII9fhyIa0phvWHiW3WvCr+KTa+wxLr0drA36C8g3IMXFhGTII4Ea9W1N0QGN1RMJuUJ0hAq2jg8+CQoNPq+Gt+go0=
Received: from AS9PR05CA0301.eurprd05.prod.outlook.com (2603:10a6:20b:491::26)
 by VI0PR08MB11668.eurprd08.prod.outlook.com (2603:10a6:800:30c::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.17; Fri, 10 Jul
 2026 09:45:52 +0000
Received: from AMS0EPF000001A4.eurprd05.prod.outlook.com
 (2603:10a6:20b:491:cafe::57) by AS9PR05CA0301.outlook.office365.com
 (2603:10a6:20b:491::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.202.12 via Frontend Transport; Fri,
 10 Jul 2026 09:45:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF000001A4.mail.protection.outlook.com (10.167.16.229) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.6
 via Frontend Transport; Fri, 10 Jul 2026 09:45:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eNWd+dtEO4edAQSsyBBojedXsmUIKcfoTX7iDGn8KPahTEXLtSpbW2VsifsSFieu817g92NB09RcgQQHqKsYdHSnC0Wjgice4TEEahaaJfD0scgPmxar1UNIG7g2Q0vZv0fwqvuSURT4JGLrfboBHGfX8GnDqFEohZZbWUa9+9CEShm2tV6yc/6TIVapsDPc9jV7hnqKkocsTpOw9Uj05vBlDdN+ELKamS1JXkEESA3WnFU5ClR3efgpAMVCclEkMY+qHxmwefL7dxSzlHAXpUzCsKuJMzRsxMdxc4EByp6gtMoucaF6oPwrjWm8iUnRHdzs8se5meBXX8UfZTaKcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EgR8F+3+pv3uxI6GJEbd7QTZziMp+QbIitYKFNEO64o=;
 b=j6RlBKCJl4bpZte2jYt3hZHlAHH1X3LFmXg61A/D5f7v2xPPSODwuZC28mj+B9k53dgct5XgqUn9fsUsq4VPJXbw8HpxB6EiljXvoTomEFSns3SFh5joYXmiKMpMk9NCObQk4n0Nc5ChoSp4Ep178q58uQpecXf4bIWqQioe62WaVDkAC0p1A+3wdL5sRojvYsySN4VSenbp+AeRPiNSfSa7ouYxNuTjPst05qEl6uo5HN+5B/7WcOmhepd5O9SpK3qnEhHnxhlRFfznPOjQNz+sJgXZv1lhh30dMYAXmKHMNU1GR5b9i1wuvJuN9n35WgCeC8vK7+Xlvl2bbt94hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EgR8F+3+pv3uxI6GJEbd7QTZziMp+QbIitYKFNEO64o=;
 b=ge+unyxrrQJpjYSazTVs1dZu3U7Lu3WuN4ziBHYUy23/7d4iRjdRofzBodLONfax7jB3v+iUEEhECI32FPII9fhyIa0phvWHiW3WvCr+KTa+wxLr0drA36C8g3IMXFhGTII4Ea9W1N0QGN1RMJuUJ0hAq2jg8+CQoNPq+Gt+go0=
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com (2603:10a6:10:407::19)
 by AM8PR08MB6531.eurprd08.prod.outlook.com (2603:10a6:20b:355::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.17; Fri, 10 Jul
 2026 09:44:49 +0000
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e]) by DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e%5]) with mapi id 15.21.0181.016; Fri, 10 Jul 2026
 09:44:48 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>
CC: "maz@kernel.org" <maz@kernel.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"oupton@kernel.org" <oupton@kernel.org>, nd <nd@arm.com>
Subject: Re: [PATCH v3 26/40] KVM: arm64: gic-v5: Add GIC VDPEND and GIC
 VDRCFG hyp calls
Thread-Topic: [PATCH v3 26/40] KVM: arm64: gic-v5: Add GIC VDPEND and GIC
 VDRCFG hyp calls
Thread-Index: AQHdCwWH3cGLlqKzd0e8BJTczryBqLZb/NeAgAqOmIA=
Date: Fri, 10 Jul 2026 09:44:48 +0000
Message-ID: <ba53a2c124259c5f13a3db4cd1231cb9bdf6c5af.camel@arm.com>
References: <20260703154811.3355680-1-sascha.bischoff@arm.com>
	 <20260703154811.3355680-27-sascha.bischoff@arm.com>
	 <20260703163147.AAE071F000E9@smtp.kernel.org>
In-Reply-To: <20260703163147.AAE071F000E9@smtp.kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU0PR08MB8421:EE_|AM8PR08MB6531:EE_|AMS0EPF000001A4:EE_|VI0PR08MB11668:EE_
X-MS-Office365-Filtering-Correlation-Id: 888e552e-8064-40f0-0427-08dede680782
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|23010399003|376014|22082099003|18002099003|4143699003|56012099006|11063799006|3023799007|38070700021|6133799003;
X-Microsoft-Antispam-Message-Info-Original:
 c1So5B5+6MX6OBWk54vWiRCMAS2P2IirYKyT5PoK0SuEbUSxlu7AzSwnJ20swl66pERU6mTf+ZOK5eiN7eT6qeYz3hRPdEdDuhKZf3nxZPa3ALkxdTGkuiRF7IkHrIXVHTNVJ3zlKuAtPSfBqFlhMRbHygkCpXWPye91wM0dhR+Z2U7EBZvnteA6RRleXLEzhfHcbAdHSA9USNUrZln5fkDeL97NADZZ79QrS1KZA8lx8gkSXKYKnQ8m5CQSxABwsSHashby2ikGVj0snj+5Y198snHaLtHN0ply7nwGS7rtvaTt9Fp3hJhJLqPCBZ5TxY0E+JUHzkv6b+MQcP+4oZVUb0HpdgHvlgmp6xHaglbi4ttvjFMvRgiclwPjg5Wq2I6XuTIUqzk5K3SFk74XVqcpYVDe4PEcjJlkpB6Cd10KWuUlJ/wGbWRBy14ZJHMi7q/9HbTbq9me58JwbURRaknK68NryZ1UFM2d4XBg/o27gK16+aJvc19yj0InI5+egDYm2khsyrLhccwg9JJEI8MfnepItpvGk7yYYOHPijlbDNKCQUnFvV2VDwqMMn/D9qv+wrjZRAXfMrnDMNBdv1vMhqYDvBWgRjtqSh9JD8KVS2BHt+/oHs9+F3a34a4bBdGO89C1qJImR9Cbzb033Rwz3vy3GtNBIIq3FcVBtmIb1XQRgBk/fCxjPugeXGpI08AMjJyDxumbrgsRd7rmeQbmLs7tIIIPwk5tDM+Tz/U=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB8421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(376014)(22082099003)(18002099003)(4143699003)(56012099006)(11063799006)(3023799007)(38070700021)(6133799003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <4650532E95B97F49BB880EE35D6621E5@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 XiY59oTf304Ml2ACEyFXvrNE+ga3MtAVe/KEfU2RSlRX9cDxEbiwDFW54elf0sDRJo++luDO0FBeY7I0Mdw0QMHhxn+oMtAMsgR7/q1sJ/BB9ikQt18Xt181iI5VwDbr3z81uWLKoVFhYe1LJZMVNcGjjhvTL4kayTjoeXke+hWSduUo/S2bCVbSnPusAOE90mCDDFZ3HWD9pu/b0pb9R6px2g8pUFxLXxQktbM9OTP/A4ZLqzy7/a2Cwlz2GG0Efz7SfZ3ja+eRJOeJdW3aD0pE7L+han6TESoenZvW3mntO/2rRunG3zhdkKd0DvuydvVdIBMpKO3o2rEgyOgITg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR08MB6531
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF000001A4.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	0fe0ac45-dbaa-49d3-61ea-08dede67e1f1
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700016|35042699022|14060799003|82310400026|376014|23010399003|18002099003|22082099003|3023799007|6133799003|56012099006|11063799006|4143699003;
X-Microsoft-Antispam-Message-Info:
	UscxNzcDan+Q7ns8wfhH6Spd3bJyeSlW50LOBoxuDsrIZ0oU5o04aj59LGN0GUkL677UzMLO9JQu1f4qUvK3ukm6Vpkwy5Gam9ZI4UByRMvspYlgglaRLyIXXONOdRlDuvuBqCwN1+zWmEJ1YsUlsSlbdVp2mej3XlOCM3amUABHmXYcTGC2fozQ+PAFh+Jb10/Ja4nYH21AguBZhN0RHdkKTYHHjiJKzqPyN1t/ZQ7tB9z3SruEVaYLk5selHMRW5abUg3ays+EenW5OmrGQd1a9XNfQqiL36krNTsQtwIhBKP19DTBlqDdUuRxnh8WEBftr2PAUlr+GthDkjUHdj78qROsGLCHbe83ZTRlSSIKAR1VCnHHr8UvcxNUsAAHAmPCDyFrQwayR3WAwi4mmdnEgmsHFvlVgKsh/qBttW5AhwpqeDhPls80UwyHQZL60EmnWpoA4yT78O5FX3G6Mf8R0N4EY+pCZGGcKus10uhRgwuUJYPzgAYlE1WbfNSBSHWtvAqDN2PhrS1W7yTV0615dv4CDgex579b6IEbpmC5Cv94TRc4b8tqVct90S/1teiUZdgMhTDOcx37cRd+Fwwv8BcwSSxDgySlMVwRd5MXddt1s/thW/rMHjqdOfOKdmd0fJk12YzMyK3MuYt7MYeM/psG8TUSOZ7nRHq2zMcCMlnRfOquHKiaSt2Zyo0g6/18BbmwlOtIkq5vmPyffg==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700016)(35042699022)(14060799003)(82310400026)(376014)(23010399003)(18002099003)(22082099003)(3023799007)(6133799003)(56012099006)(11063799006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	usI16oVVggBAADLnLya+h1f1utdejgUx11xy+HDrEveW4c2JfmCM1AdAPq6hAPuUXr8w2xXiMq6bE55pBzll4GfHrcOWxStp7eIKaHTcVPhzAfCxSCFTBu8Nk40GMwhYnUgGI4eXrKUciDHe/PKQ94ppQT1HF9zDGmLnWTFiEz8EVmvQx8WQlbxyw1MFHjVsxb5aXAIGQTa8ESTcv12hLKWzL6j26weBy8kLAXWK4u4i/+FqnrNY+0TKJYTpCiyv7vikI2J3Zq4rPG6M/2mDXGDI3PuQLSqQUng15r03Lsl5VP39zIgrCuNlX9IvhKe3E+7dCpPN9Jns7ai3KbYGpm4CNQtquCL/DqUW6RTkSA26WII/atC/IdhFqmUg1Ouzq+uc8cRG02CXaNAwenqptXXfL1EcWn7enI/5+0r0MXsWYZPp0Nbgg5qS4dihBA7m
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2026 09:45:51.6102
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 888e552e-8064-40f0-0427-08dede680782
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF000001A4.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR08MB11668

T24gRnJpLCAyMDI2LTA3LTAzIGF0IDE2OjMxICswMDAwLCBzYXNoaWtvLWJvdEBrZXJuZWwub3Jn
IHdyb3RlOg0KPiBUaGFuayB5b3UgZm9yIHlvdXIgY29udHJpYnV0aW9uISBTYXNoaWtvIEFJIHJl
dmlldyBmb3VuZCAxIHBvdGVudGlhbA0KPiBpc3N1ZShzKSB0byBjb25zaWRlcjoNCj4gLSBbSGln
aF0gTWlzc2luZyBDb250ZXh0IFN5bmNocm9uaXphdGlvbiBFdmVudCAoSVNCKSBhZnRlciB3cml0
aW5nIHRvDQo+IHRoZSBWRFBFTkQgc3lzdGVtIHJlZ2lzdGVyLg0KPiAtLQ0KPiANCj4gY29tbWl0
IDNkNjYzMWZmZjVkYjUzYzNmN2Y2NTE3ZWEyODJlN2U4N2IxNDJmOWENCj4gQXV0aG9yOiBTYXNj
aGEgQmlzY2hvZmYgPFNhc2NoYS5CaXNjaG9mZkBhcm0uY29tPg0KPiANCj4gS1ZNOiBhcm02NDog
Z2ljLXY1OiBBZGQgR0lDIFZEUEVORCBhbmQgR0lDIFZEUkNGRyBoeXAgY2FsbHMNCj4gDQo+IFRo
aXMgY29tbWl0IGludHJvZHVjZXMgaHlwZXJjYWxscyB0byBtYW5hZ2UgU1BJIGFuZCBMUEkgcGVu
ZGluZw0KPiBzdGF0ZXMgZm9yIGENCj4gVk0gdXNpbmcgdGhlIEdJQyBWRFBFTkQgYW5kIEdJQyBW
RFJDRkcgc3lzdGVtIGluc3RydWN0aW9ucy4gSXQgd3JhcHMNCj4gdGhlc2UNCj4gRUwyLW9ubHkg
aW5zdHJ1Y3Rpb25zIGZvciBOVkhFL2hWSEUgY29uZmlndXJhdGlvbnMgdG8gYWxsb3cgdGhlDQo+
IGh5cGVydmlzb3INCj4gdG8gaW5qZWN0IGludGVycnVwdHMgYW5kIHF1ZXJ5IGRlYWN0aXZhdGVk
IHN0YXRlcy4NCj4gDQo+IFsgLi4uIF0NCj4gDQo+ID4gZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQv
a3ZtL2h5cC92Z2ljLXY1LXNyLmMNCj4gPiBiL2FyY2gvYXJtNjQva3ZtL2h5cC92Z2ljLXY1LXNy
LmMNCj4gPiBpbmRleCA0Njk5MmE2YzJjYWNiLi5jNTBlNmFlOTNiYTNmIDEwMDY0NA0KPiA+IC0t
LSBhL2FyY2gvYXJtNjQva3ZtL2h5cC92Z2ljLXY1LXNyLmMNCj4gPiArKysgYi9hcmNoL2FybTY0
L2t2bS9oeXAvdmdpYy12NS1zci5jDQo+ID4gQEAgLTE0OSwzICsxNDksMjMgQEAgdm9pZCBfX3Zn
aWNfdjVfcmVzdG9yZV9zdGF0ZShzdHJ1Y3QNCj4gPiB2Z2ljX3Y1X2NwdV9pZiAqY3B1X2lmKQ0K
PiA+IMKgew0KPiA+IMKgCXdyaXRlX3N5c3JlZ19zKGNwdV9pZi0+dmdpY19pY3NyLCBTWVNfSUND
X0lDU1JfRUwxKTsNCj4gPiDCoH0NCj4gPiArDQo+ID4gK3ZvaWQgX192Z2ljX3Y1X3ZkcGVuZCh1
MzIgaW50aWQsIGJvb2wgcGVuZGluZywgdTE2IHZtKQ0KPiA+ICt7DQo+ID4gKwl1NjQgdmFsdWU7
DQo+ID4gKw0KPiA+ICsJdmFsdWUgPSBpbnRpZCAmIChHSUNWNV9HSUNfVkRQRU5EX0lEX01BU0sg
fA0KPiA+IEdJQ1Y1X0dJQ19WRFBFTkRfVFlQRV9NQVNLKTsNCj4gPiArCXZhbHVlIHw9IEZJRUxE
X1BSRVAoR0lDVjVfR0lDX1ZEUEVORF9QRU5ESU5HX01BU0ssDQo+ID4gcGVuZGluZyk7DQo+ID4g
Kwl2YWx1ZSB8PSBGSUVMRF9QUkVQKEdJQ1Y1X0dJQ19WRFBFTkRfVk1fTUFTSywgdm0pOw0KPiA+
ICsJZ2ljX2luc24odmFsdWUsIFZEUEVORCk7DQo+ID4gK30NCj4gDQo+IFtTZXZlcml0eTogSGln
aF0NCj4gSXMgYSBjb250ZXh0IHN5bmNocm9uaXphdGlvbiBldmVudCBuZWVkZWQgaW1tZWRpYXRl
bHkgYWZ0ZXIgdGhpcw0KPiBzeXN0ZW0gcmVnaXN0ZXINCj4gd3JpdGU/DQoNCk5vLiBXZSdyZSBt
YWtpbmcgYW4gU1BJIChvciBpbiB0aGUgZnV0dXJlIExQSSkgcGVuZGluZyh3aGljaCBnb2VzIG91
dA0Kb3ZlciBHSUNTdHJlYW0gdG8gdGhlIElSUyBzbyB0aGUgbGFzdCB0aGluZyB3ZSB3YW50IHRv
IGRvIGlzIHRvIHdhaXQNCmFyb3VuZCBmb3IgdGhhdCB0byBjb21wbGV0ZS4gVGhlIGhhcmR3YXJl
IHdpbGwgc2lnbmFsIHRoZSBpbnRlcnJ1cHQgdG8NCnRoZSBndWVzdCAob3IgZ2VuZXJhdGUgYSBk
b29yYmVsbCkgYXQgc29tZSBwb2ludCBpbiB0aGUgZnV0dXJlIHdoZW4gdGhlDQppbnRlcnJ1cHQg
aXMgc2VsZWN0ZWQgYXMgdGhlIEhQUEkgZm9yIHRoZSBndWVzdC4NCg0KPiANCj4gV2hlbiBfX3Zn
aWNfdjVfdmRwZW5kKCkgY29tcGxldGVzIHRoZSB3cml0ZSB2aWEgZ2ljX2luc24oKSwgaXQNCj4g
cmV0dXJucyBkaXJlY3RseS4NCj4gV2l0aG91dCBhbiBleHBsaWNpdCBpc2IoKSBiZWZvcmUgcmV0
dXJuaW5nLCBjb3VsZCB0aGUgQ1BVIHBpcGVsaW5lIGJlDQo+IGxlZnQgaW4NCj4gYW4gdW5kZWZp
bmVkIGFyY2hpdGVjdHVyYWwgc3RhdGUgZm9yIHN1YnNlcXVlbnQgaW5zdHJ1Y3Rpb25zPw0KDQpQ
bGVhc2Ugc3RvcCB0aGlzICJ1bmRlZmluZWQgYXJjaGl0ZWN0dXJhbCBzdGF0ZSIgc3R1ZmYgZm9y
IHRoZSBDUFUNCnBpcGVsaW5lLiBJdCBkb2Vzbid0IG1ha2UgYW55IHNlbnNlLg0KDQo+IA0KPiBG
b3IgY29tcGFyaXNvbiwgdGhlIF9fdmdpY192NV92ZHJjZmcoKSBpbXBsZW1lbnRhdGlvbiBpbiB0
aGlzIHNhbWUNCj4gcGF0Y2gNCj4gaW5jbHVkZXMgYW4gaXNiKCkgaW1tZWRpYXRlbHkgYWZ0ZXIg
aXRzIGdpY19pbnNuKCkgY2FsbC4NCg0KQ29ycmVjdCwgaXQgZG9lcy4gVGhlcmUncyBhIGdvb2Qg
cmVhc29uIGZvciBpdCB0b28uIFdlIG5lZWQgdG8gYmUgc3VyZQ0KdGhhdCB0aGUgVkRSQ0ZHIGhh
cyBjb21wbGV0ZWQgYmVmb3JlIHdlIHJlYWQgZnJvbSB0aGUgcmVnaXN0ZXIgdGhhdCBpdA0KcG9w
dWxhdGVzIChJQ0NfSUNTUl9FTDEpLiBFbHNlLCB3ZSdkIHJlYWQgc3RhbGUgc3RhdGUuIFRoaXMg
b25lIGV4YW1wbGUNCmRvZXNuJ3QgbWVhbiB0aGF0IGFsbCBHSUMgaW5zdHJ1Y3Rpb25zIG5lZWQg
dG8gYmUgdHJlYXRlZCBsaWtlIHRoYXQhDQoNCj4gDQo+IFsgLi4uIF0NCj4gDQpUaGFua3MsDQpT
YXNjaGENCg==
