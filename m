Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013036.outbound.protection.outlook.com [40.107.159.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B892847886D;
	Wed,  8 Jul 2026 14:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.36
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783522459; cv=fail; b=MBeI8AFw9DpBYRUJcb4q+Gm49yjBoIDRymqpnrjfA9O/4RsIavn7QVLI+oUmdrBMIEAgwFRTmCGOT8kVUdjFgCAvtTNX2Wk8d7PrXxgkLt+wnf9FuM1DKery/blcF8xt0P5SwbLGAc2hF8hR0iF2Hli0YXJfVK4hieWc3j5QiZQ=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783522459; c=relaxed/simple;
	bh=jxT0RNcjG1TDxHy7xIAvIlLZ5C4LNEZymovIvm57+10=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=NM7ArQwl14z9hx+iAzLNflGejzTyRTHhZdy5ewq5nm5d3YM4keH0YWZ0IxzF4nor6iX6eT6AcKLKtxwXE22wnC4F50kBSIc046BuPYaoOr7vpLwAbI27yG6zFNPGOZiiQy+NPdpEP6nLdSxpDxSQxCl6uWCCVR6ePPPuHo0FvaY=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=QGDO8IBe; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=QGDO8IBe; arc=fail smtp.client-ip=40.107.159.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="QGDO8IBe";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="QGDO8IBe"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=OzGa2IVlqFOOG7KTYJi/mVX/7mchVe9ynCaOxZxpvxcatIJjpApQSZ7Q5fUgU0pwnt3a+yaCu4z/wXmbGGlx+urdZkdkd1dEqLzkl0jSWH34Ujh2hfIqODPTOeEsJXEVxVLBZ8HWaG8T+YXH4W1ERVAXKTFkwZS37RiXfGYVvhhKN1h36LD2Ncwedhxe6tpxaaL9SpJ9LLMnE/bib7IK4CBVlha7mL6QpStoJltLOf6EACUJiv3iIcG8uT7hS/qcXUIeUOpYPxACKBlMWjNo2/qoZ+cHu6aC0RFYCqEdHCOCOtmPgaoaYMcJqD8t8/sBY1C0xV1+XLQTiuOtMRON2A==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jxT0RNcjG1TDxHy7xIAvIlLZ5C4LNEZymovIvm57+10=;
 b=xw2vcgMKBBepxCUDXQGRd75qTYzrIl8d+fNJA3spAVtEVeo8n0TsphssgoglBGLHQblQrc30SraPBj4GqgTqm/WLXrD1AEX1JwzoiWZzH5wODnd/x3Z96fQ5MSIbIE8ll04SmsO+GJ9URNqvAmx+EsLzxBzcAPC2YsA1b+0DLFiO7hEw1rMZFeeF3koEPZy5700+Jj7SZfWvqMz382ppHlTLY8yFBXKB6+lJFvjMI3UXP5ZcGHZ+VE2ZTw6U/dav+ehp3bXqcNDsN6A/Q3K9WbjqOsbvQRFFmQqMt8jLgVVDronGCfIjpd4zk2e57465RLKMDN9kKRu6ZANAX+MQxw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jxT0RNcjG1TDxHy7xIAvIlLZ5C4LNEZymovIvm57+10=;
 b=QGDO8IBe/VSyOrX61MRuDjPtrHyIJgXYP7ArcGQTkdE+wmLfOFDvAG9CikE1zyjyxvWj6q+wHjU3bPJ6D8AnxhvV6/BhtBt+BOJc0Gqfl+xo/sJ+qGVVj4ux8MouJQDMu24B/PtPm2+Tf9ghwguqnwuUlN63FwfLcSW5mAEisb8=
Received: from DU7PR01CA0032.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:50e::8) by DB9PR08MB7795.eurprd08.prod.outlook.com
 (2603:10a6:10:39a::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.8; Wed, 8 Jul 2026
 14:54:13 +0000
Received: from DB5PEPF00014B95.eurprd02.prod.outlook.com
 (2603:10a6:10:50e:cafe::28) by DU7PR01CA0032.outlook.office365.com
 (2603:10a6:10:50e::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.202.10 via Frontend Transport; Wed, 8
 Jul 2026 14:54:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB5PEPF00014B95.mail.protection.outlook.com (10.167.8.233) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.6
 via Frontend Transport; Wed, 8 Jul 2026 14:54:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=t1xnqQGbHVxAMqpKh6lexXiyyZVL95WrMTaIg8VSuqgujcIXYzHAW1qkJzQDlZ6hWTxEya9GgNQ1OKlUOs+Qam1zvYt8ELtkw+zw5lJR7YLKhc0CODo5cYwl8SzI4IWbEGt0on9vBLSOvF3yUa5It6fl/+HUiaUqvV4fUpLXlNVpy+M0k8BedZnUbkoEIs8K6HvRKOy+JJvEaKoEvboKeRJrr7TEhLQppADUMNy2NpQTszkWnoFGUcQeSVJjRfzx26iOE4njv48W6MNnFR6g3AK85g1aJt6dWEFIs3u4Adtzl98+euyAnE2q4CzXjsaom6PunIxure3M6NOWTEwIUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jxT0RNcjG1TDxHy7xIAvIlLZ5C4LNEZymovIvm57+10=;
 b=lQQu9Vl29TMkaYwo6MCLAXWG7ZekFeuNOWciaY2cwI+FubdDtI4f923eRs+rbM63U8xEBFFIJFWsxNzlv3WEJ9vsa1rvcMbjoeY0tbVz9k3UcaRelcdDsWoPALPnFjr9y/QwwciIR54fwh2D4hNqzzRISG7Gt+reyUZ/u/Qr8ePYJzpAS7hX71VQJPPRFmBDFiueuwxl7S7YTdkKnfiufbNv51IxYOPAGurUUkrzvSpHHhp4f1Y2WbWQoGoHRhM+u/oX/QbjtRnufufkgEmqJKuu+Oe3tKRyF727UKl8IYmzZpqDQC9718haFKQdesMPDJ9cFilOI+CI7xX5zo+XUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jxT0RNcjG1TDxHy7xIAvIlLZ5C4LNEZymovIvm57+10=;
 b=QGDO8IBe/VSyOrX61MRuDjPtrHyIJgXYP7ArcGQTkdE+wmLfOFDvAG9CikE1zyjyxvWj6q+wHjU3bPJ6D8AnxhvV6/BhtBt+BOJc0Gqfl+xo/sJ+qGVVj4ux8MouJQDMu24B/PtPm2+Tf9ghwguqnwuUlN63FwfLcSW5mAEisb8=
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com (2603:10a6:10:407::19)
 by PR3PR08MB5659.eurprd08.prod.outlook.com (2603:10a6:102:83::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.14; Wed, 8 Jul
 2026 14:53:07 +0000
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e]) by DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e%5]) with mapi id 15.21.0181.009; Wed, 8 Jul 2026
 14:53:07 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>
CC: "maz@kernel.org" <maz@kernel.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"oupton@kernel.org" <oupton@kernel.org>, nd <nd@arm.com>
Subject: Re: [PATCH v3 13/40] KVM: arm64: gic-v5: Implement VPE IRS MMIO Ops
Thread-Topic: [PATCH v3 13/40] KVM: arm64: gic-v5: Implement VPE IRS MMIO Ops
Thread-Index: AQHdCwSb1VvPrPGSt0KlBNlwB2PDYbZb+12AgAfBkQA=
Date: Wed, 8 Jul 2026 14:53:07 +0000
Message-ID: <ba36eeb1b442729eca2f440073e6a5410f46f14f.camel@arm.com>
References: <20260703154811.3355680-1-sascha.bischoff@arm.com>
	 <20260703154811.3355680-14-sascha.bischoff@arm.com>
	 <20260703162630.67D381F000E9@smtp.kernel.org>
In-Reply-To: <20260703162630.67D381F000E9@smtp.kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU0PR08MB8421:EE_|PR3PR08MB5659:EE_|DB5PEPF00014B95:EE_|DB9PR08MB7795:EE_
X-MS-Office365-Filtering-Correlation-Id: db5b0b4b-8272-4b25-b0ce-08dedd00c648
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|22082099003|18002099003|38070700021|3023799007|4143699003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info-Original:
 ElTYJ41thGFflbirSAkJtOzeEzCEglaLkAxocv+tvriAwJUyUkQxQOdsp2fDAmpifTwTPzc/LyH8ZAG8u7xgzIkL914wmdSnqKc3CoisCt6RdOF9GbP7F0/uYcYEvIciYr+Duj1LW6+htxDm5LdupTM+NWLL4yq3B5IeqdgYPGQjAtBvcteYF2/41pTyvrF8ujauFviyaUfZ7l6dbLCSCcvlfCwkoHwiIGLS39WgiofLTBiq3PVpAjljrzXFRzMQwav96YY/vsnh7XSfZb9RuDvxF4qhFJQWl32/S5RZrvvdIGc+ofPLbu2elmG+NvlRvvh7yibKkFJrL3mHDpmOLEDCml3FaUphHy2gPqTG5f0KVQQpQ2vFkIOrbt5mQ/nLPGEZOu6P15j9vvOQvLmcPueOA7SyUM5IprtNtEvP3LUHr/dGsjEUd1PIxlJ6pBJ4vrcTPNKkBt76gmqEy5mGaKELO3ABHGjr0/CeA4B6SeUJ7Uhl/pYtw9uWT3Fkiv3hTcpM1I2j83j2c5gC9eTvhpGNlxIg1u8FCUu7xFaIFpFttPzvD1tXAQSLp9W/MQVA9jg5hh4bFDl7qwkwvb3CnGt3HmhaQ0wNjaAKis43WYSym59NiGW4SPO6kMIrQIvKUuhlXAECAT8fbJL3oJQk9MIQGEEhFsOS6MV/4NP7sUwKnsIpuRMrdhvzm1MPuwyk1apdFoA9n/ii1Lk7K6jcTVAgOEyLRT0oqXhZNWgZcJo=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB8421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(22082099003)(18002099003)(38070700021)(3023799007)(4143699003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <2B7E0EFFF365C74DB6F4528E24CF32BB@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 FutzpX5lhq/eyIBJJJaOtywCz/u8PZiClzguXjI0gf3O/EEFr+1Z+ClOJ/VdoqCoE0Mw6knegrEquOGh4qrAvDh8rOnLWZ0K51mcZ0HMhjsGgRJCmRF7WM/+svuEktGUy14ZENq+TanLprafoEjv6I8KEC7kKqNGJE6gGxuGB7hvO1chXWrRAM9j11k61CmV5zVq0bx3sxsNg3dsn82PJE9B0V6hMfRD2/wYr1RZXd2RCfGR97bb6EtvqomG+ZlsaujUWJ1/3B3JLEYsYVPY00cPRg1Nt9BFMGAIT2b+Z6jhhcvvEUXXeJlj30vuiLH/1DMHON88L89geOPeU5NoUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR08MB5659
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB5PEPF00014B95.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	5ea81771-bca0-42e8-2f54-08dedd009f30
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|35042699022|14060799003|23010399003|36860700016|376014|82310400026|22082099003|18002099003|11063799006|56012099006|3023799007|4143699003;
X-Microsoft-Antispam-Message-Info:
	BuvDSO/4v0qLM4YK552BdHZ4SKQ5ukaGFy15HTKoIKKrcpYUR77+lvK7lDbj3XCHUJ17XEEx1gbSyBn6kSNS4d5qViV2g6W/UPcgvaYvoNsR3s+vX4r5t8M/vvdFLh89H9irHWvCVh0gpYt8yZ3sKSZ6Tnoco0TSY0IABTv3jdg0YqvBaMf4RMBqiMNEccVYg1zgzcrHGtFjnpWli2NfNs4vM6r+Nix/46EGVL4J8jD0RCIqyXeyTs7zCT0MiPY8OU6Y7Y5pyb+acXhwOVlG9FcyAejViC5uuLP2Lylha+5ggcCL23T7Ug97eKFQDKV6NPNvMtpnG11W2IxLd7Yc6mbOGp5jBB8Ygc2HTG54t27Y6FwYcnJQ9ZV5w7HVOekYXZr6cvGR03HowxTl8q5CKVX9d+3XwCBc+TuQnEXt8hoW8MHepQmOuoIYT0NoabYsjdv0eLHhiDrbWoSgOwk68t/jUIA7hYTJ2TRkY09ADQphQPoDfe3KeFc+26AUlOKdSPFhsU/2s9ZbWiaQyDmDvCjqJA9sjBNWy/7TLI958+UkEk4DU8GpKTh8eqULi3n7sVPH9amgOTwvg1mRX3bB+DaFnx9dqZC8yip4nFe6MxHCF5O8vu82qXhUlKW+8FFf2w1kHmFj/dJjz2Do8kyIEinoVfXxvN1eLdV5WdOVPBcnocFPGGdrrS4xN6K92IekTSM2YvsCTxhpMqSpj6Qp/w==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(35042699022)(14060799003)(23010399003)(36860700016)(376014)(82310400026)(22082099003)(18002099003)(11063799006)(56012099006)(3023799007)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	HaYvVOKai4SkpqFz6+HULABdUSv4Qjfnz0lecELAiutkourRO3IJ9CvGvS5XI6lWVdu/dVIvdv6RvVltGEjZa4vF9q1P11+iI5POWI9anuWsfGlaUOFm+OG5NpvEGVCDJTQayXIcyCb8ZdSZ8BbEJ5Mea/lBSRH+8uClhbr2JyaSbr9NrDTvWmq1p86PlAJpAKjZASYIEPQGsFr4VpRoIFQlxY0dVNpV9qfnJHdDQPVGQI/jS94MwIZ2zk79H646WH/xxUhoPGEtl+wmBRyn78UAqfrUdG8UL5TC1Wt0kxhWksLEysf4CLCoHqJGALdPhLbhmGurnC1u03TPATnMgMixPjfS/XOIPznkf2LqT7ZXBIXccZdz3FYxHxqpF8F8E7aNfSqg9XMVobNKZ6Y8UbvvfzkY462vfqCCEFXsrZRrVYzM1cVf9rhRiBBRU9nK
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2026 14:54:12.8461
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: db5b0b4b-8272-4b25-b0ce-08dedd00c648
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5PEPF00014B95.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB7795

T24gRnJpLCAyMDI2LTA3LTAzIGF0IDE2OjI2ICswMDAwLCBzYXNoaWtvLWJvdEBrZXJuZWwub3Jn
IHdyb3RlOg0KPiBUaGFuayB5b3UgZm9yIHlvdXIgY29udHJpYnV0aW9uISBTYXNoaWtvIEFJIHJl
dmlldyBmb3VuZCAxIHBvdGVudGlhbA0KPiBpc3N1ZShzKSB0byBjb25zaWRlcjoNCj4gLSBbSGln
aF0gTWlzc2luZyBoYXJkd2FyZSBpZGxlIGNoZWNrIGJlZm9yZSBpc3N1aW5nIFZQRSBjb21tYW5k
cyBpbg0KPiBgdmdpY192NV9pcnNfc2V0X3VwX3ZwZSgpYCBjYXVzZXMgc3RhdGUgY29ycnVwdGlv
biBvbiB0aW1lb3V0DQo+IHJlY292ZXJ5Lg0KPiAtLQ0KPiANCj4gY29tbWl0IDBlODZkN2M3NjZj
YzJmNTllOTc4MmE4NDY1OGIwZTdlZDY3ODU5N2ENCj4gQXV0aG9yOiBTYXNjaGEgQmlzY2hvZmYg
PFNhc2NoYS5CaXNjaG9mZkBhcm0uY29tPg0KPiBTdWJqZWN0OiBLVk06IGFybTY0OiBnaWMtdjU6
IEltcGxlbWVudCBWUEUgSVJTIE1NSU8gT3BzDQo+IA0KPiBUaGlzIGNvbW1pdCBpbnRyb2R1Y2Vz
IGludGVyZmFjZXMgdG8gdmFsaWRhdGUgYW5kIGNvbmZpZ3VyZSBWUEVzIHZpYQ0KPiB0aGUgDQo+
IGhvc3QncyBJUlMgTU1JTyBpbnRlcmZhY2UuIEl0IGFsc28gZXh0ZW5kcyB0aGUgVlBFIGRvb3Ji
ZWxsIGNvbW1hbmRzDQo+IHdpdGggDQo+IFZQRV9NQUtFX1ZBTElELg0KPiANCj4gPiBkaWZmIC0t
Z2l0IGEvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLXY1LmMNCj4gPiBiL2FyY2gvYXJtNjQva3Zt
L3ZnaWMvdmdpYy12NS5jDQo+ID4gaW5kZXggZmQ2NGVhMDE3M2IyZi4uNmQ3ZDllNmVkOWRiZiAx
MDA2NDQNCj4gPiAtLS0gYS9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtdjUuYw0KPiA+ICsrKyBi
L2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy12NS5jDQo+IA0KPiBbIC4uLiBdDQo+IA0KPiA+IEBA
IC0zMzIsMTAgKzM0NCw3MyBAQCBzdGF0aWMgaW50IHZnaWNfdjVfaXJzX3NldF92aXN0X2ludmFs
aWQodTE2DQo+ID4gdm1faWQsIGJvb2wgc3BpX2lzdCkNCj4gPiDCoAlyZXR1cm4gX192Z2ljX3Y1
X2lyc191cGRhdGVfdmlzdF92YWxpZGl0eSh2bV9pZCwgc3BpX2lzdCwNCj4gPiB0cnVlKTsNCj4g
PiDCoH0NCj4gPiDCoA0KPiA+ICtzdGF0aWMgaW50IHZnaWNfdjVfaXJzX3NldF91cF92cGUodTE2
IHZtX2lkLCB1MTYgdnBlX2lkLA0KPiA+ICsJCQkJwqAgaXJxX2h3X251bWJlcl90IGRiX2h3aXJx
KQ0KPiA+ICt7DQo+ID4gKwl1NjQgdm1hcF92cGVyLCBkYnIsIHNlbHI7DQo+ID4gKwl1MzIgc3Rh
dHVzciwgY3IwOw0KPiA+ICsJaW50IHJldDsNCj4gPiArDQo+ID4gKwlndWFyZChyYXdfc3Bpbmxv
Y2tfaXJxc2F2ZSkoJmdsb2JhbF9pcnNfbG9jayk7DQo+ID4gKw0KPiA+ICsJLyogTWFrZSBzdXJl
IHRoYXQgd2UgYXJlIGlkbGUgdG8gYmVnaW4gd2l0aCAqLw0KPiA+ICsJcmV0ID0gdmdpY192NV9p
cnNfd2FpdF9mb3Jfdm1fb3AoKTsNCj4gPiArCWlmIChyZXQpDQo+ID4gKwkJcmV0dXJuIHJldDsN
Cj4gPiArDQo+ID4gKwkvKiBNYXJrIHRoZSBWUEUgYXMgdmFsaWQgKi8NCj4gPiArCXZtYXBfdnBl
ciA9IEZJRUxEX1BSRVAoR0lDVjVfSVJTX1ZNQVBfVlBFUl9WUEVfSUQsIHZwZV9pZCkNCj4gPiB8
DQo+ID4gKwkJwqDCoMKgIEZJRUxEX1BSRVAoR0lDVjVfSVJTX1ZNQVBfVlBFUl9WTV9JRCwgdm1f
aWQpIHwNCj4gPiArCQnCoMKgwqAgR0lDVjVfSVJTX1ZNQVBfVlBFUl9NOw0KPiA+ICsJaXJzX3dy
aXRlcV9yZWxheGVkKHZtYXBfdnBlciwgR0lDVjVfSVJTX1ZNQVBfVlBFUik7DQo+ID4gKw0KPiA+
ICsJLyogV2FpdCBmb3IgdGhlIFZQRSB0byBiZSBtYXJrZWQgdmFsaWQgaW4gdGhlIFZQRVQgKi8N
Cj4gPiArCXJldCA9IHZnaWNfdjVfaXJzX3dhaXRfZm9yX3ZtX29wKCk7DQo+ID4gKwlpZiAocmV0
KQ0KPiA+ICsJCXJldHVybiByZXQ7DQo+ID4gKw0KPiA+ICsJc2VsciA9IEZJRUxEX1BSRVAoR0lD
VjVfSVJTX1ZQRV9TRUxSX1ZQRV9JRCwgdnBlX2lkKSB8DQo+ID4gKwnCoMKgwqDCoMKgwqAgRklF
TERfUFJFUChHSUNWNV9JUlNfVlBFX1NFTFJfVk1fSUQsIHZtX2lkKSB8DQo+ID4gKwnCoMKgwqDC
oMKgwqAgR0lDVjVfSVJTX1ZQRV9TRUxSX1M7DQo+ID4gKwlpcnNfd3JpdGVxX3JlbGF4ZWQoc2Vs
ciwgR0lDVjVfSVJTX1ZQRV9TRUxSKTsNCj4gDQo+IFtTZXZlcml0eTogSGlnaF0NCj4gSXMgaXQg
cG9zc2libGUgdG8gY2xvYmJlciBhIHN0aWxsLWJ1c3kgVlBFIGVuZ2luZSBoZXJlIGlmIGEgcHJl
dmlvdXMNCj4gb3BlcmF0aW9uIHRpbWVkIG91dD8NCj4gDQo+IFdoaWxlIHZnaWNfdjVfaXJzX3Nl
dF91cF92cGUoKSBjaGVja3MgdmdpY192NV9pcnNfd2FpdF9mb3Jfdm1fb3AoKSBhdA0KPiB0aGUN
Cj4gc3RhcnQgb2YgdGhlIGZ1bmN0aW9uLCB0aGVyZSBkb2VzIG5vdCBhcHBlYXIgdG8gYmUgYSBo
YXJkd2FyZSBpZGxlDQo+IGNoZWNrIGZvcg0KPiB0aGUgVlBFIG9wZXJhdGlvbiB1bml0IChsaWtl
IHZnaWNfdjVfaXJzX3dhaXRfZm9yX3ZwZV9vcCgpKSBiZWZvcmUNCj4gd3JpdGluZw0KPiB0byBH
SUNWNV9JUlNfVlBFX1NFTFIuDQo+IA0KPiBJZiBhbiBlYXJsaWVyIGNhbGwgdG8gdmdpY192NV9p
cnNfc2V0X3VwX3ZwZSgpIHRpbWVkIG91dCB3YWl0aW5nIGZvcg0KPiBhIFZQRQ0KPiBvcGVyYXRp
b24gYW5kIHJlbGVhc2VkIGdsb2JhbF9pcnNfbG9jayBvbiB0aGUgZXJyb3IgcGF0aCwgYQ0KPiBz
dWJzZXF1ZW50IGNhbGwNCj4gY291bGQgZmluZCB0aGUgVk0gb3BlcmF0aW9uIHVuaXQgaWRsZSBi
dXQgdGhlIFZQRSBvcGVyYXRpb24gdW5pdA0KPiBzdGlsbCBidXN5Lg0KPiBXcml0aW5nIHRvIEdJ
Q1Y1X0lSU19WUEVfU0VMUiBpbiB0aGlzIHN0YXRlIGNvdWxkIGNvcnJ1cHQgdGhlDQo+IGhhcmR3
YXJlIHN0YXRlLg0KPiANCg0KVGhlIHBoeXNpY2FsIElSUyBhY2Nlc3NlcyBhcmUgc2VyaWFsaXNl
ZCBieSB0aGUgZ2xvYmFsX2lyc19sb2NrLCBzbw0KdGhlcmUgaXMgbm8gY29uY3VycmVudCB3cml0
ZXIgdGhhdCBjYW4gcmFjZSB3aXRoIHRoaXMgSVJTX1ZQRV9TRUxSDQp3cml0ZS4gVGhlIG9ubHkg
d2F5IHRvIHJlYWNoIHRoaXMgcG9pbnQgd2l0aCBJUlNfVlBFX1NUQVRVU1IuSURMRSBzdGlsbA0K
Y2xlYXIgd291bGQgYmUgaWYgYW4gZWFybGllciBvcGVyYXRpb24gaGFkIGFscmVhZHkgdGltZWQg
b3V0LCByZXR1cm5lZA0KYW4gZXJyb3IsIGFuZCByZWxlYXNlZCB0aGUgbG9jayB3aGlsZSB0aGUg
aGFyZHdhcmUgd2FzIHN0aWxsIGJ1c3kNCihwcmVzdW1lZCBicm9rZW4sIGZyYW5rbHkpLiBBdCB0
aGF0IHBvaW50IHRoZSBJUlMgc3RhdGUgaXMgYWxyZWFkeQ0KdW5yZWxpYWJsZSwgYW5kIHdlJ2Qg
cXVpdGUgbGlrZWx5IGVuY291bnRlciB0aGUgc2FtZSB0aW1lb3V0IGFnYWluLg0KDQpGb3IgdGhl
IG5vbi1lcnJvciBwYXRoLCBlYWNoIFZQRSBvcGVyYXRpb24gaXMgZm9sbG93ZWQgYnkNCnZnaWNf
djVfaXJzX3dhaXRfZm9yX3ZwZV9vcCgpLCBzbyB0aGUgbmV4dCBvcGVyYXRpb24gaXNzdWVkIHVu
ZGVyIHRoZQ0KbG9jayBzdGFydHMgZnJvbSBpZGxlLg0KDQpUaGFua3MsDQpTYXNjaGENCg==
