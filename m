Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010064.outbound.protection.outlook.com [52.101.69.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5859E36655D;
	Fri,  4 Sep 2026 09:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.64
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788514136; cv=fail; b=CXVc9m4xxuaVTRm5AR+UkqKPzGA+SdSYmXSUpaBJP6k5zmCc5lUzMxGF1w9FNt51uuY/N1Qps8/AOeyhGTAOUMehqOdWkBm2HPHAXXiUV3Q3Omln+CTsWtudhgREJ9QlAPghCEZl/TY29ba7YV3FD79CyQOxo6+mUNQwxK68hDg=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788514136; c=relaxed/simple;
	bh=9U0sCox0xDfECgaWHgvMXIQKfXAqjbMs/xWZ+y75Uhw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=rEZFJFa1u6jq87q/rvayZk4cRRP0+761QN8QuNbIbjecTnWgModmyd7TfM/NKdXeOavjGNFDV0bwwEBElhbFsnppf6gXJW1Nj6aKFLFsA+qPDuAr4LMiCO8xZbj0cpvPGQkrHgOnOJNL1PFPdH37SqNqOqrtBxt8BoCG9ZbyC+I=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Pyb3J/h/; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Pyb3J/h/; arc=fail smtp.client-ip=52.101.69.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Pyb3J/h/";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Pyb3J/h/"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=i4/3WYchOyt9PAEBTDgfEmKrCrAMPpqyF/Xj3VCI08v4M8X10waMO8M3m/Ns0dw79S7UmnQ5fp8ztNIG59Mmz9NMU/ulPLhcsHhjeHDl+thl/3lKyxcbb1B7UAUh1VNHnWW4aigmwb5tEDPlrxg/jqqL7EX7Pi1O+G7Hl5JR/9tMBnlNWEFZWpSsFGS+WDapPfvDO6XoiBvmOuK0YVbSpcH2EAws1g0AVZDQ59QMKySqhVVCsU4j1P/QyxS/AciKnx+KSwuJ8ixssmqfAJJbxcs/jlsjKW1I+TGNr3W8ujU1GBgao9FZ4tu+HzJoeGNTk99LQiQ0Q5eG92FVK2S1IQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9U0sCox0xDfECgaWHgvMXIQKfXAqjbMs/xWZ+y75Uhw=;
 b=qV1WOzuyutfvo8jc8QebgK+kRpOnBoWUPrxmByyscg6GO/ZpNN41naywWJM7V1Zk9N+He/X9JDChDf8x/J39PUbEXxhrBnywbU1ElEVFjQQ0e7Treo9f5vDP6zPP5gD5+mdANXq9nPQdO0/svnmkHJ6a5CInO9haL77qs76H1d5GwF3p6ovk05gGLjQemC+j0b+dkE2q1DmATjsw5/9b1taUEiBEVFfqpKml2RB4S9srHeel9b0CrvwcNPRi0riZeslZ2hKlVL2sAVonSNKUZ77vgv6pRM355iI1nkJU8TbgrLPSP0VmCeHaijF+xKDOd9ZWvai7x0qOmPPUouLt0A==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9U0sCox0xDfECgaWHgvMXIQKfXAqjbMs/xWZ+y75Uhw=;
 b=Pyb3J/h/vVw6E4EAR1bmh8H201+35fiZSwLTdtIckW1rbxvSnsrfSaUtR7pgJPnbrdoC+OAXfcjvKLYTJF1kYc1UnXRskhJ9vdkp8H6Fe2uJq67t2CiygAZENFAlUtaWOAfOHMSbOVWKIEYDX+3zELpNPDbE68BR7iqp+29uRvE=
Received: from AS9PR06CA0105.eurprd06.prod.outlook.com (2603:10a6:20b:465::27)
 by MIWPR08MB294223.eurprd08.prod.outlook.com (2603:10a6:290:d8::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.10; Fri, 4 Sep
 2026 09:28:49 +0000
Received: from AM3PEPF0000A795.eurprd04.prod.outlook.com
 (2603:10a6:20b:465:cafe::1b) by AS9PR06CA0105.outlook.office365.com
 (2603:10a6:20b:465::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.13 via Frontend Transport; Fri, 4
 Sep 2026 09:28:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM3PEPF0000A795.mail.protection.outlook.com (10.167.16.100) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.8
 via Frontend Transport; Fri, 4 Sep 2026 09:28:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XaP4h2udLpepSqpaHdADM6uRH/ZZpMV/D0Eqo3536dnFtZLFbeALJAKTkfNsi3pGwzk1PeW/KwD3v3mjXWdTE/Ely01trJLLijw0X1s5cW1ReGXDfO9d+Sl8IKQyz5i+48SKR+aK+wjpZo9p35HIBce/LYHHmoH52jFTA9/HjiQy5sBfqq1DDs+YtCxN19Z0OgXQoAeWH72enVQcd48h4tfGKsqvKIfNeFfAoMYePmtV06ZuOQvPiU9cbN0id6r0CqBrTpXBDx0Yi31U4Wxej8PiPcMwHMtEC0nxuTDmgtlrSNAJn/6PqxkDMmF5y1FIPtwdXAe/1A9MTpC7LM4NoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9U0sCox0xDfECgaWHgvMXIQKfXAqjbMs/xWZ+y75Uhw=;
 b=EDVKOx1ZbkdngGM2zp01vgPP9TxH80KEElLSZhyRqA7x/cjF9BGTkiYhhqNd4Gu3Q8L+FlJb3Y6YCdaFLOV2m5a/wTSsoafaQaUAwWxkMchtKfZZmTQEhfA1nbG6gMDxudn77Qv5Ad/1G/xyCfUHxMRxQ61xNQuaeTDUWVGthbWx0iI77PAN5bt2HIQuHOpEZlM7gdWULuWgHZPhcA+Fx5I/09gE+yTaqrwPyHA+Q/NvUeSygVYoqIDkaOY9LvK3mk+234ANWM7A/ZK8TRACapEYnzCdRygHtoWM8SagIhPyaRuLNJq1T8hmfPlRT4AEdLG+xVToCe+vvWaDI3IYwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9U0sCox0xDfECgaWHgvMXIQKfXAqjbMs/xWZ+y75Uhw=;
 b=Pyb3J/h/vVw6E4EAR1bmh8H201+35fiZSwLTdtIckW1rbxvSnsrfSaUtR7pgJPnbrdoC+OAXfcjvKLYTJF1kYc1UnXRskhJ9vdkp8H6Fe2uJq67t2CiygAZENFAlUtaWOAfOHMSbOVWKIEYDX+3zELpNPDbE68BR7iqp+29uRvE=
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com (2603:10a6:101:1d::23)
 by ZR6PR08MB999854.eurprd08.prod.outlook.com (2603:10a6:910:d6::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 09:28:17 +0000
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e]) by PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e%4]) with mapi id 15.21.0382.007; Fri, 4 Sep 2026
 09:28:17 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>
CC: "maz@kernel.org" <maz@kernel.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"oupton@kernel.org" <oupton@kernel.org>, nd <nd@arm.com>
Subject: Re: [PATCH v5 26/49] KVM: arm64: gic: Introduce set_pending_state()
 to irq_ops
Thread-Topic: [PATCH v5 26/49] KVM: arm64: gic: Introduce set_pending_state()
 to irq_ops
Thread-Index: AQHdJl+A+eqyJTzMx0qJ+aTmDSWcZLaSsiCAgCugjgA=
Date: Fri, 4 Sep 2026 09:28:17 +0000
Message-ID: <24460779a7439a59f97f7d48abe865839afc215d.camel@arm.com>
References: <20260807111159.429128-1-sascha.bischoff@arm.com>
	 <20260807111159.429128-27-sascha.bischoff@arm.com>
	 <20260807151428.28DD11F00A3A@smtp.kernel.org>
In-Reply-To: <20260807151428.28DD11F00A3A@smtp.kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	PR2PR08MB4889:EE_|ZR6PR08MB999854:EE_|AM3PEPF0000A795:EE_|MIWPR08MB294223:EE_
X-MS-Office365-Filtering-Correlation-Id: e3b94166-1f70-49d6-33a9-08df0a66ed5e
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|1800799024|23010399003|366016|38070700021|6133799003|18002099003|10067099003|5023799004|11063799006|4143699003|56012099006|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 /MmH1F4zfDoT04Hp9RbJGpVjNIy2oS/KKxBS6oArc18hjllq7CDVhETfS3fh66OegB9jq3R9a7qydMWmraIiuR3y1C7cEONp0awysyN6wCqTk8eCpy/x+ZKDLtwmR/LhVV4RYUGf4vAehqkbHProDa2myds59LhLcXQqCjDJ/FzItgk6KxGlW7ewQATH2G/3fIFB0yWoPSJrlccxKi/wQhZ5sEnTkTiz+uW0yllc8ZQXckri2eN/h0T2dO7SnkpYJVr8AqtRjXziNau9X3PK3b01naiAhPeEPKA8CL88MJGYd0prJQ+Er/8kZrynY1LXqSWkIckUObRr+4wy0awrV8Q0pxw+JAL8sDPoZZnM8wn/Iiw86qvD6MR6TEaJ16kpbXZ0NH32YTvn/sLk5FNvamSk0ktSCP/FqEoTq6OoZtgz18WMLt3G1jJRt5XtQBxhHN2x3o67yTyuSr8pHOFCetR7tUM3V4GZCZqzdKo/fhaCa/ieVLqiPLxJdcgEwP4lclJJwb6fmuKOO5SkbPF+tu21jjYY0N4yEgffA9vkHDOPUcfSSz2MGBAeQesEloFD16Q3i/kHqBdsoOKL7rtm4wk+c8yoBPAYcXDC8v31JjpphiSNv82heEYWhW7GpWidohCZrnYpjJQ12+CkrEA54V+YiBaZuDjCSJztyZK/Xs7ngQwpyAw2voIj8bQd9ar+Ypxg6K/+oIBhlXehQxdhfhrDc7qb/K1EF6HT22oWU/g=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR2PR08MB4889.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(23010399003)(366016)(38070700021)(6133799003)(18002099003)(10067099003)(5023799004)(11063799006)(4143699003)(56012099006)(22082099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <2666993CD775ED448C99E5A17178EA87@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 Zh/Nje7WUKqwXNxDwhn2fcUnGcy5EDVX2MUWW+LlTOMWxNuyMtTDn5ZQaRLJTkxtEqzqXkXYaL26NbELGJP7ZoQtHFrG5y9j7oMNm0bp+Ix2+281iMrM422mBWAmhgheFVqTvmu/YQzlNdr9H9xwOOyCYDGq7WuhwBGpq4U0vIpc6GcZfS7b08PWqqEyZgwjpvSGWXhuaaQDU1hWka8WAbYHddoYteBHTshjLEfvLTaiMOtuphnmEaoROJqlXXiE6PwAk/ijgaOcYO9zhdnfiZ0Tw1sAy8NKHkyMUSwLFYMAsHBuLDbACoTTivFMl7avC7wTygW9lOy465ZlrTBeAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZR6PR08MB999854
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM3PEPF0000A795.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	c5efb97a-e2e7-4c94-03e8-08df0a66da26
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|376014|82310400026|1800799024|23010399003|14060799003|35042699022|6133799003|10067099003|11063799006|4143699003|56012099006|5023799004|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	uPSafLjxZztYhTdzjDydfAwHgkLuy9UV8nXVa91QcxSyjTc9r0aCasVxoyi6uK++V47/J2w3yimIQQxkg9U3YT2u6kZOlLDrXL/lA9Ogs2HQulScUsxYX5xXabkE5eyxinuilARlKXnCEleEJayrW/T++v34sWfLURdSz3i4Ius5Hv1RH3x+lk61pT/3AlaL25EiTB0ci3PqjRxNtMl1sZlaLm7BbXpqqDgwGGUQ+7RMvFIODuPLMcZ/9EFsMGhhEmcNdWcAhiSPKZYIiiZKOjVP10oilMdDpWzwT6/BiR+lFhrFHAX3G9BwO0hbFpXsQDpNw/LsLh1PtVZBlzZRIllLXozNcBps/pLYNDdFUAKLqIE9rRqMaMQ866ilTenKu3lwLvt7KvAe4sO5UWIr+1l1K1Iuudru6Ix4B5JonQafkgB6y1nqVIg4RdGiaWca6N0ZbPODdyfqP09KASKsSdv7WLKU1uW2/+kR09a5fZSjyBWaH3U4NpoXYlTxwzF5qMuvUgVUaLD7SSCgkqw71hmovCi4dDlxzgxroho6PE/3XOoQKYp6A/ZpZdLYq2qPB5nLdWbks7ltGjCukYUsoikNYN7Aqb2bHKuL0f3xleHRUWkJwz6lUWX7jEkBgUYQJCsw5w3W6moQQK4DL67X9K/4XT3FwGTOlAR/aPI+1X8=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(376014)(82310400026)(1800799024)(23010399003)(14060799003)(35042699022)(6133799003)(10067099003)(11063799006)(4143699003)(56012099006)(5023799004)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	QXLddmizGaABqulQrjcxJoidn6VmUdv5RmTZoC/686M7St9r5r0kqmmlFyDwAeYoVdrg1P2UjPqsmit2W1sJMxDmsMue2Y0q7akwkv9HlgUBpnnY4TJG+k2M1SoAMy+qNN26toSfuedQy1D3JY6T+kik+AuN0eMZhBTTVp2OjGexCV+XTuTPHtfA0NHfr1meDzyuB9o4qxs1i8kXMd93acitOb9piUS4GXppzmkOHe9H2n+TQimO1Y6ay+/TQnzUd+9R4sw3jEurlMaLPMCvM0y8dupwI1VrItK25DKFlHCThZpyQV21oQy2ia8ZOWaX163FwXG4bicbQ9uzHdiV3A+Zllz9WaHv/8fdPUtRHwSQZDTc/ZD6DTsi6/l3BH1RMdvvYKxupEopoXWSuMpA4QmHQ3MMBQws/1Yvusm7FzcpSssiNALt8eM4bs4X+F+m
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2026 09:28:49.4276
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e3b94166-1f70-49d6-33a9-08df0a66ed5e
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM3PEPF0000A795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MIWPR08MB294223

T24gRnJpLCAyMDI2LTA4LTA3IGF0IDE1OjE0ICswMDAwLCBzYXNoaWtvLWJvdEBrZXJuZWwub3Jn
IHdyb3RlOg0KPiBUaGFuayB5b3UgZm9yIHlvdXIgY29udHJpYnV0aW9uISBTYXNoaWtvIEFJIHJl
dmlldyBmb3VuZCAxIHBvdGVudGlhbA0KPiBpc3N1ZShzKSB0byBjb25zaWRlcjoNCj4gLSBbSGln
aF0gVGhlIGBzZXRfcGVuZGluZ19zdGF0ZWAgY2FsbGJhY2sgaXMgb25seSBpbnZva2VkIGluDQo+
IGBrdm1fdmdpY19pbmplY3RfaXJxKClgLCBsZWF2aW5nIGhhcmR3YXJlIHN0YXRlIG91dCBvZiBz
eW5jIHdoZW4gVkdJQw0KPiBzaGFkb3cgc3RhdGUgaXMgbW9kaWZpZWQgYnkgb3RoZXIgcGF0aHMu
DQo+IC0tDQo+IA0KPiAtLS0gUGF0Y2ggWzI2XTogW1BBVENIIHY1IDI2LzQ5XSBLVk06IGFybTY0
OiBnaWM6IEludHJvZHVjZQ0KPiBzZXRfcGVuZGluZ19zdGF0ZSgpIHRvIGlycV9vcHMgLS0tDQo+
IGNvbW1pdCA3MDZhY2Y0OTFkOTc5ODFmOWRkNDk4ZWMyMWMzNDFjYmE0NmYxZjQ3DQo+IEF1dGhv
cjogU2FzY2hhIEJpc2Nob2ZmIDxTYXNjaGEuQmlzY2hvZmZAYXJtLmNvbT4NCj4gU3ViamVjdDog
S1ZNOiBhcm02NDogZ2ljOiBJbnRyb2R1Y2Ugc2V0X3BlbmRpbmdfc3RhdGUoKSB0byBpcnFfb3Bz
DQo+IA0KPiBUaGlzIGNvbW1pdCBpbnRyb2R1Y2VzIGEgc2V0X3BlbmRpbmdfc3RhdGUoKSBmdW5j
dGlvbiBwb2ludGVyIHRvDQo+IGlycV9vcHMuDQo+IFRoaXMgYWxsb3dzIGhhcmR3YXJlLW1hbmFn
ZWQgaW50ZXJydXB0cyB0byBtaXJyb3IgS1ZNJ3MgVkdJQyBzaGFkb3cNCj4gcGVuZGluZw0KPiBz
dGF0ZSBpbnRvIHRoZSBoYXJkd2FyZSB3aGVuIHRoZSBzdGF0ZSBjaGFuZ2VzLg0KPiANCj4gPiBk
aWZmIC0tZ2l0IGEvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLmMNCj4gPiBiL2FyY2gvYXJtNjQv
a3ZtL3ZnaWMvdmdpYy5jDQo+ID4gaW5kZXggMTY5YTg2NjQzMjJkMC4uMDIzNzkyYzI4ZmM1YyAx
MDA2NDQNCj4gPiAtLS0gYS9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMuYw0KPiA+ICsrKyBiL2Fy
Y2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy5jDQo+ID4gQEAgLTU2Myw2ICs1NjMsOSBAQCBpbnQga3Zt
X3ZnaWNfaW5qZWN0X2lycShzdHJ1Y3Qga3ZtICprdm0sIHN0cnVjdA0KPiA+IGt2bV92Y3B1ICp2
Y3B1LA0KPiA+IMKgCWVsc2UNCj4gPiDCoAkJaXJxLT5wZW5kaW5nX2xhdGNoID0gdHJ1ZTsNCj4g
PiDCoA0KPiA+ICsJaWYgKGlycS0+b3BzICYmIGlycS0+b3BzLT5zZXRfcGVuZGluZ19zdGF0ZSkN
Cj4gPiArCQlXQVJOX09OX09OQ0UoIWlycS0+b3BzLT5zZXRfcGVuZGluZ19zdGF0ZSh2Y3B1LA0K
PiA+IGlycSkpOw0KPiA+ICsNCj4gDQo+IFtTZXZlcml0eTogSGlnaF0NCj4gU2luY2UgdGhlIHNl
dF9wZW5kaW5nX3N0YXRlIGNhbGxiYWNrIGlzIG9ubHkgaW52b2tlZCBoZXJlIGluDQo+IGt2bV92
Z2ljX2luamVjdF9pcnEoKSwgd2lsbCB0aGUgaGFyZHdhcmUgc3RhdGUgYmVjb21lIG91dCBvZiBz
eW5jDQo+IHdoZW4gdGhlDQo+IFZHSUMgc2hhZG93IHN0YXRlIGlzIG1vZGlmaWVkIGJ5IG90aGVy
IHBhdGhzPw0KDQpXZSB0cmVhdCBTUElzIGFzICJpbmplY3QgYW5kIGZvcmdldCIuIFRoZSBoYXJk
d2FyZSBtYW5hZ2VzIHRoZWlyIHN0YXRlLA0KYW5kIGRldGVybWluZXMgd2hlbiB0aGV5IHNob3Vs
ZCBiZSBwcmVzZW50ZWQgdG8gdGhlIGd1ZXN0LiBBbGwgd2UgZG8gaXMNCnRvIGdpdmUgaGFyZHdh
cmUgdGhlIG1vc3QgcmVjZW50IHBlbmRpbmcgc3RhdGUuIFRoZXJlZm9yZSwgd2UgZG9uJ3QNCm5l
ZWQgdG8gZG8gYW55dGhpbmcgaW4gdGhlIG90aGVyIHBhdGhzLg0KDQo+IA0KPiBGb3IgZXhhbXBs
ZSwgaWYgYSBndWVzdCBhY2Nlc3NlcyB0aGUgR0lDRF9JQ1BFTkRSIHJlZ2lzdGVyLCBLVk0NCj4g
dXBkYXRlcw0KPiBpcnEtPnBlbmRpbmdfbGF0Y2ggaW4gX19jbGVhcl9wZW5kaW5nKCksIGJ1dCBk
b2VzIG5vdCBhcHBlYXIgdG8NCj4gaW52b2tlIHRoZQ0KPiBoYXJkd2FyZSBzeW5jIGNhbGxiYWNr
Og0KPiANCj4gYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLW1taW8uYzpfX2NsZWFyX3BlbmRpbmco
KSB7DQo+IAkJaWYgKGlycS0+aHcgJiYgIWlzX3VzZXIpDQo+IAkJCXZnaWNfaHdfaXJxX2NwZW5k
aW5nKHZjcHUsIGlycSk7DQo+IAkJZWxzZQ0KPiAJCQlpcnEtPnBlbmRpbmdfbGF0Y2ggPSBmYWxz
ZTsNCj4gfQ0KPiANCj4gQSBzaW1pbGFyIGRlc3luYyBzZWVtcyBwb3NzaWJsZSBpbiBfX3NldF9w
ZW5kaW5nKCkgd2hlbiBoYW5kbGluZw0KPiBHSUNEX0lTUEVORFIgd3JpdGVzLCBhcyB3ZWxsIGFz
IGluIHZnaWNfd3JpdGVfaXJxX2xpbmVfbGV2ZWxfaW5mbygpDQo+IGFuZA0KPiBrdm1fdmdpY19y
ZXNldF9tYXBwZWRfaXJxKCkuDQoNClRoZXNlIGFyZSBub3QgcHJlc2VudCB3aXRoIEdJQ3Y1IChh
cyBpbiwgdGhpcyBpcyBmb3IgYSBjb21wbGV0ZWx5DQpkaWZmZXJlbnQgR0lDIG1vZGVsKSwgc28g
dGhpcyBpcyBub3QgYW4gaXNzdWUuDQoNCj4gDQo+IENvdWxkIHRoaXMgbGVhZCB0byBzdHVjayBp
bnRlcnJ1cHRzIG9yIHNwdXJpb3VzIGluamVjdGlvbnMgZm9yDQo+IGhhcmR3YXJlLW1hbmFnZWQg
aW50ZXJydXB0cyBpZiB0aGUgaGFyZHdhcmUgcmVtYWlucyBwZW5kaW5nIGFmdGVyIHRoZQ0KPiBz
aGFkb3cNCj4gc3RhdGUgaXMgY2xlYXJlZD8NCg0KTm8uDQoNCj4gDQo+ID4gwqAJdmdpY19xdWV1
ZV9pcnFfdW5sb2NrKGt2bSwgaXJxLCBmbGFncyk7DQo+ID4gwqAJdmdpY19wdXRfaXJxKGt2bSwg
aXJxKTsNCj4gDQoNClRoYW5rcywNClNhc2NoYQ0K
