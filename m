Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013025.outbound.protection.outlook.com [40.107.162.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AC193C1F36;
	Fri, 31 Jul 2026 13:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.25
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785505151; cv=fail; b=ilb+DR2T9bvE9egecqVfMfr8Z0htlofLJSWoGLmO9Y+pmrdQgP5Z97cdfgjzcFMEj29gBFbAHLXlEOgs3OMQeDPSNG2Xh+Vz47GCrZvTG5auEZR2y5NVJfaUjnaE2p0N9ZOAJcM5wuKIyfN+4uMJx4KEBrQdjC//PpwZSkYPWuY=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785505151; c=relaxed/simple;
	bh=x4bvqgRq48ERmu1o1xqBiz1iocLFtm5+ov7Gk91BJCg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=WcWhUctXCcvFZHXAkZK7nAOGvtBTJbTeYilpT+w2gULNDakfbGbhOpYmMUfc14zl/t2sTu9eZqGfnd/oplIN3VBcGn8SfjcuBsz3g3uwfqdPo0t7h1AbfWO1yLvGsVtMZqYnscUdfjyhgz85jmGg9e0/Mi+QFnl0RMXY5CmxJ2k=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=FMmvbFeD; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=FMmvbFeD; arc=fail smtp.client-ip=40.107.162.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="FMmvbFeD";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="FMmvbFeD"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=Wvb7vWwtMIpBO2KqA7Rcc4xlom9SWxU5OsmhQ1rGzOZl6eCcmDhaM2PujzvflTDjpPmnA4vaBCW3An1W23RD90xIxpjTOY6JJ7hq2TB861lglI+U5e0zzJj6pyk1JslNnyVQWHAA/y6W5IMOAKPblV9XN25qIckTgFNcaKB08xm2gSkFoNc8TYgHoY7LiWrxgHJ3ScKMsVyc6dNWy9CB8uYh1t+yuXv42GCZ7fGv5SPqkL0M+oaVy7Trv3gjpPcc21QRTSDmmlpIDM4UE/8A+EDM3mfN/RZ37tIFsRhAQo+Q398Xwfg3FnbhRLxuVj5D3y6seHVW3CzzCDtTNbQBAA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x4bvqgRq48ERmu1o1xqBiz1iocLFtm5+ov7Gk91BJCg=;
 b=w1WuG1M+G4mr0WhKVwQ4XpufEk+6PKKoh1KyxV1UxEWYiJW9KGpEMfUz12OdjxUySKKBRTEgY+GKDeP3ZBCHfOoCVgBbn/VEzpQm9ZOYeLgD++7DX+pGFjXOLxNIkpB41jKOLTTFfSKZasPYxxkqZg2A5NQckAMR8Bh1OVhllXV/+d+CaECDSuHO9ioGXvUqtLQKn32F/YWWTA2swWng9vB+34vhaQJdLo3cgYPQduF/yZbS4YHYB0vTMX2RguL/nrTzD65hUwIa6jlRYU/mVwuXGc3NH+7MElMSyTioZMe0yYG+wk3HP6Um1VbEQBzfagKdmDHymWpJpJ6ExjfHFw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x4bvqgRq48ERmu1o1xqBiz1iocLFtm5+ov7Gk91BJCg=;
 b=FMmvbFeDSuM7yRah60XugBOWZ9iSGXwYgXaecOuEMH8Bucvxvssws9ZiB8WqIduACFvmp44WfdFd/yjx37+lhBzkl4svEB/WU74lFjrj4hL7v3/yhF6opVSLuOgMpHYtmIWwxTorTAShthdPXGRNlc0nTRhZ2WmMxllMi2qLuVU=
Received: from AS9PR06CA0529.eurprd06.prod.outlook.com (2603:10a6:20b:49d::20)
 by GV2PR08MB11277.eurprd08.prod.outlook.com (2603:10a6:150:2f2::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.15; Fri, 31 Jul
 2026 13:39:01 +0000
Received: from DU6PEPF00009523.eurprd02.prod.outlook.com
 (2603:10a6:20b:49d:cafe::34) by AS9PR06CA0529.outlook.office365.com
 (2603:10a6:20b:49d::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.16 via Frontend Transport; Fri,
 31 Jul 2026 13:39:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU6PEPF00009523.mail.protection.outlook.com (10.167.8.4) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.8 via
 Frontend Transport; Fri, 31 Jul 2026 13:39:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=f2wDCDjd+5KnOJcHHNXcC9yT5ItZ6VT/hlYqgrNrzyh/uNYeVh6x3NgxmN4uaLWYSy8sm/GumOVO7ST6ae4PGcpNd++6HWXbG02sKy4pKVPLvPcQO643ZK0bZoQD3x0aYXgFI0ZKSGr2rDNOZCdi2ntf5yV2QQAr7CqCSWNX09/LLJhaq+HAsdC5wB6Qd0W7SB81EvLuviY6ENyjkKJx6+z8bpUNdeHR6fOJ/wT39PMRMMKWV+Jn3sHFC/OPQAUxhwbzxuR58ETgBWbeUOT1Vr7mDh/HvQ+Yj20Ji0wv6Vgku/2kktbPAFPyqamfd/qsOcH0x0iXnboxjuIBr8zq7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x4bvqgRq48ERmu1o1xqBiz1iocLFtm5+ov7Gk91BJCg=;
 b=PrbrlKcYyVZmEadraTmy76rsQAGfGLNuNQStu8hb4Kl3PY57QkSCVlajfSbaY8bt13sgadbj4XnZi+DLQF8+jpqXgbwqwiPpuDoIp996nZ8iFHeat1VTvIHkCKZE0frFEVOSf0aUppnFMDVB3t3oTnpzBG4fwhsgAQXwRP6K1oeROOMCIS7szXRbQTEN/CQnA/eGhkIzJy50i8tZfMuCqzstJkEdN03vqNmNQRWNZLz9tMk+K9HhC++T7dy3W18nCtNf03ux+C+s0dKiXJ0TAYBwy99MP1NiwDU5jDQf4n0rWSaWfJlVrqNsUD/FxyEUcIvsjh+xm1UAqMKxuYlJ5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x4bvqgRq48ERmu1o1xqBiz1iocLFtm5+ov7Gk91BJCg=;
 b=FMmvbFeDSuM7yRah60XugBOWZ9iSGXwYgXaecOuEMH8Bucvxvssws9ZiB8WqIduACFvmp44WfdFd/yjx37+lhBzkl4svEB/WU74lFjrj4hL7v3/yhF6opVSLuOgMpHYtmIWwxTorTAShthdPXGRNlc0nTRhZ2WmMxllMi2qLuVU=
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com (2603:10a6:10:407::19)
 by AS8PR08MB8372.eurprd08.prod.outlook.com (2603:10a6:20b:569::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.16; Fri, 31 Jul
 2026 13:37:56 +0000
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e]) by DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e%5]) with mapi id 15.21.0270.012; Fri, 31 Jul 2026
 13:37:56 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>
CC: "maz@kernel.org" <maz@kernel.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"oupton@kernel.org" <oupton@kernel.org>, nd <nd@arm.com>
Subject: Re: [PATCH v4 26/48] KVM: arm64: gic: Introduce set_pending_state()
 to irq_op
Thread-Topic: [PATCH v4 26/48] KVM: arm64: gic: Introduce set_pending_state()
 to irq_op
Thread-Index: AQHdG1rjcUTOwBdDKUyvswmGyjM5zrZ8i3oAgAshZAA=
Date: Fri, 31 Jul 2026 13:37:55 +0000
Message-ID: <db5a1e1866bbc63595f40fe651ad792f36c0099c.camel@arm.com>
References: <20260724104819.1296803-1-sascha.bischoff@arm.com>
	 <20260724104819.1296803-27-sascha.bischoff@arm.com>
	 <20260724113933.01D4A1F000E9@smtp.kernel.org>
In-Reply-To: <20260724113933.01D4A1F000E9@smtp.kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU0PR08MB8421:EE_|AS8PR08MB8372:EE_|DU6PEPF00009523:EE_|GV2PR08MB11277:EE_
X-MS-Office365-Filtering-Correlation-Id: 05b2a5a6-55b2-439c-af68-08deef091490
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|366016|1800799024|23010399003|38070700021|6133799003|3023799007|56012099006|11063799006|4143699003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 gesQ3yvBS+35M42PFnhLfg2PCGn0oHv5EgDk0bhD65o295SkeZqWDWJz8pyrZpWmtymBLMMumlglZFztzpkc+c7z1yUmM05qfbSd/p8VXQa+0uZRnCTT1jKXGPTDTiYYzTYidwOG7c+QWeDIeDxpDLcxFXDA1ZmPX0uxGw/WjIXwh1ZL7dx/IJBMbaM4A+thweo1J5ZpqumMhaQEf8qLIgh7C/ylW3xQ90SNRBSszNBbj0X1sd7Id3SdBMm7SDE4cuKW7Ggw5QHN558exGHyUSBBA3qC32AxyC4qoq4Ex5/v6qn2EMiXx764MVIQFzcVy7QeYBBhGCAs3bwa+DtsAuahVNg/1itV7K/w45YE+ohtP5GlI+PqzJJcuSDXH/tLe7mgnNDJllUEAzXmEaGWkJ5H12m+41g4TOF65kLBU7WqsvQYhcOha1p+yILfRaSpVeAvFCsWvtgzszTpS5DTiKLI8ilOgGP5E8VWxroOWmdQIWNB/MVKQkZ+iEGuaFc7Pxv3zO8eOYHdK89mPlAagedwJhZnIyFOWoFVQVLTeESMD0raCSzFPsztqOIUVksqBtZZEmFebW3h70mNi4RrbJn8XVyA5gJjnqukukmBk8EyTU/8+K+Vs25Rvbp5eu9eITTgRYyDTzeEmPLf5tHg1XKK7/MGuSLL5zEyaRTf6aPwmU7scWE6EzVn0/+VQHAxAhd/+lIpw0aQ1x+9StTLBHZTwdZiQju8tHMlu4fDwUg=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB8421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(23010399003)(38070700021)(6133799003)(3023799007)(56012099006)(11063799006)(4143699003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <DA5BC299E7087E40A907DC37A0BE9576@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 EhaqXos7TxkQzw7krOifxOYKyZyPZzyeqx/B7uV5Zk2olSH6/PlsUoHyIhnOu8SwFcD2IzzOlwIxA48H6GxDUFCHK9LVXGITce/Z4benVmT5aVMZJtHPAmSlhezxzlE5ZqHbrCVQ8M07fmIaytsJg4CrSKJIZRpl8uUp3d5ZF/yYNDpMirichA/Apl3PmcQF5Hdv0wTTUb4lkswEZsf5AyQ3jOu8VOK7I1rxqii/Rf+gIP5qkSNPwwQUUmunX6R//gaUv1pRXlXlPB/RuKdcOHwFzFa8sQo/gUVCZ943mVGXdFYAz/ln4DiRMIjPlivesQ2x7kmXeS6cWfd1MexTog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB8372
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU6PEPF00009523.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	9af9da55-9984-461f-16de-08deef08edba
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|35042699022|376014|14060799003|1800799024|23010399003|82310400026|6133799003|11063799006|56012099006|10067099003|4143699003|22082099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	rcw6HqNkh6EzxUi6EmP9l//EsjaAQ3ph3JMtq+dAVqSGtt+l8NVqc1siwh1bwIo+Bng1PfXNWktQargPHAbI8nvKE9fMGtR+kYB8b89ZGAVX4rGWjNKXEV2sPmAnyjtOBOb25BS2BQjYTTq5LbfhbV0kar5ZBYeA2ZNdzscnlwWcE1B6xpwng8mSlLAwZ3YreqHtdqlvDeVnayCJsL4QaSJI2ptJeaYLolSoAgB+4b8cO4hPId7B7qqCsR8R/Qw1uGI+lhl+PlEVCQ6ZV4yBTsAHd9BR1QN2Y1sdlp/MnRdtIMoT5cUiWp1x85PF7p6UbaIQhMouAv9iqmFfGu/9WJSmUbJTpOeaiJxuMIKD8ltjxvFeXotXYxnzHI3UJs2PqSf1O0QEF2uIZpUqNLLGHtH/aIlAqStkWmv1oj8+XMCz5aJLeKfrBwdl/iJLwptTqBVBd8imbxCphZ4sGuIDy6peUtKgZ9esUn80+IayCdZUGU3k0lMW5FJ9LBFlRCX9ZsvqP6T3GQmmX5jSj19+WUnmGWd2Armh3guIICO2usPauqFpw/WkPSHm9H9KrhkD/4ER0BcDtgyUo9lKzHRXIXKXJcXudxR+snm1s/UHRAGFadrlHUwB6YH6P6FSW/9jBJmBdzzl6dRj+1mYZPRz6418hVx3NJAICESDkuYXkhDHz+djmogrF7yfz4C+fozTKXABBNfPwTjme3cbk7tWFQ==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(35042699022)(376014)(14060799003)(1800799024)(23010399003)(82310400026)(6133799003)(11063799006)(56012099006)(10067099003)(4143699003)(22082099003)(18002099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	6OiF3mBxDKvTPAAurU5JfjA1vm+7AZHp9xoRIi6wDprhZ/P+nYZx0779v/+mPCJdG9B0lNV+lsXKeh7tAyk1cD8JRNiXEpUGPTW6IvxWpqNv754bTM7dYbGMiTlYXL6dX1Caq32W7RVQavJ/dq71ievdOyz7OYwKfj/AXk9ekkuA4RqW7d4u+6G7oyAAzA7gfrnZDsAw58gFdHGmskSEWOQvMOeYN+IDBvqI8vZcjCjRooOUj8yjkDuRFIHcaNyCq6GhRbARBpqT+Uj0mjkSIN0NNxB66RbrIhpXWlovwdPEp81CkBK3TTU+aBD8k+GCksjVgk9cQH79JeJlrEihUvZkwWiIw66F0fJxtQvqBbNdKwUk6k4jRmQ+Gzo36y6asKnPM8TwbutnvpcALiYOEBVYiV3Rtaa480OHWmjAL+Exs4tPH7A6eV8JIHNxMToe
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2026 13:39:01.0769
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 05b2a5a6-55b2-439c-af68-08deef091490
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU6PEPF00009523.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR08MB11277

T24gRnJpLCAyMDI2LTA3LTI0IGF0IDExOjM5ICswMDAwLCBzYXNoaWtvLWJvdEBrZXJuZWwub3Jn
IHdyb3RlOg0KPiBUaGFuayB5b3UgZm9yIHlvdXIgY29udHJpYnV0aW9uISBTYXNoaWtvIEFJIHJl
dmlldyBmb3VuZCAyIHBvdGVudGlhbA0KPiBpc3N1ZShzKSB0byBjb25zaWRlcjoNCj4gLSBbSGln
aF0gSW5jb21wbGV0ZSBzdGF0ZSBtaXJyb3Jpbmc6IGhhcmR3YXJlIHBlbmRpbmcgc3RhdGUNCj4g
ZGVzeW5jaHJvbml6ZXMgZnJvbSBWR0lDIHNoYWRvdyBzdGF0ZSBvbiBndWVzdCBNTUlPL0lUUyB3
cml0ZXMuDQo+IC0gW01lZGl1bV0gVXNlcnNwYWNlLXJlYWNoYWJsZSBXQVJOX09OX09OQ0Ugd2hl
biBzZXRfcGVuZGluZ19zdGF0ZQ0KPiBmYWlscywgY2F1c2luZyBwb3RlbnRpYWwgRGVuaWFsIG9m
IFNlcnZpY2UuDQo+IC0tDQo+IA0KPiAtLS0gUGF0Y2ggWzI2XTogW1BBVENIIHY0IDI2LzQ4XSBL
Vk06IGFybTY0OiBnaWM6IEludHJvZHVjZQ0KPiBzZXRfcGVuZGluZ19zdGF0ZSgpIHRvIGlycV9v
cCAtLS0NCj4gY29tbWl0IGY2YThiOGYzOGViNzgwMDkwYTY0ZDA1MWJkYjlkNDE5ZGNmNzVlMjYN
Cj4gQXV0aG9yOiBTYXNjaGEgQmlzY2hvZmYgPFNhc2NoYS5CaXNjaG9mZkBhcm0uY29tPg0KPiAN
Cj4gS1ZNOiBhcm02NDogZ2ljOiBJbnRyb2R1Y2Ugc2V0X3BlbmRpbmdfc3RhdGUoKSB0byBpcnFf
b3ANCj4gDQo+IFRoaXMgcGF0Y2ggaW50cm9kdWNlcyBhIHNldF9wZW5kaW5nX3N0YXRlKCkgZnVu
Y3Rpb24gcG9pbnRlciB0bw0KPiBpcnFfb3BzLg0KPiBUaGlzIGFsbG93cyB0aGUgVkdJQyB0byBj
b21tdW5pY2F0ZSBwZW5kaW5nIHN0YXRlIGRpcmVjdGx5IHRvDQo+IGhhcmR3YXJlIGZvcg0KPiBj
YXNlcyB3aGVyZSBoYXJkd2FyZSBtYW5hZ2VzIHBhcnRzIG9mIHRoZSBpbnRlcnJ1cHQgbGlmZWN5
Y2xlLCBsaWtlDQo+IEdJQ3Y1Lg0KPiBJdCB3aXJlcyB0aGlzIG5ldyBjYWxsYmFjayBpbnRvIGt2
bV92Z2ljX2luamVjdF9pcnEoKS4NCj4gDQo+ID4gVGhlIGludGVudCBpcyBmb3IgdGhpcyB0byBi
ZSB1c2VkIGFmdGVyIHRoZSBWR0lDIHNoYWRvdw0KPiA+IHBlbmRpbmcgc3RhdGUgaGFzIGNoYW5n
ZWQsIGFsbG93aW5nIHRoZSBiYWNrZW5kIHRvIG1pcnJvciB0aGUNCj4gPiB1cGRhdGVkDQo+ID4g
c3RhdGUgaW50byBoYXJkd2FyZS4NCj4gPiANCj4gPiBUaGlzIG5ldyBmdW5jdGlvbiBpcyBwbHVt
YmVkIGludG8ga3ZtX3ZnaWNfaW5qZWN0X2lycSgpLCBhbmQgaXMNCj4gPiBvbmx5DQo+ID4gY2Fs
bGVkIGlmIGlycV9vcHMgYXJlIHByb3ZpZGVkIGFuZCB0aGlzIGZ1bmN0aW9uIHBvaW50ZXIgaXMN
Cj4gPiBleHBsaWNpdGx5DQo+ID4gc2V0Lg0KPiANCj4gW1NldmVyaXR5OiBIaWdoXQ0KPiBJZiB0
aGUgaW50ZW50IGlzIHRvIG1pcnJvciB0aGUgc3RhdGUgYWZ0ZXIgdGhlIFZHSUMgc2hhZG93IHBl
bmRpbmcNCj4gc3RhdGUNCj4gaGFzIGNoYW5nZWQsIHNob3VsZCB0aGlzIGFsc28gYmUgd2lyZWQg
dXAgZm9yIGd1ZXN0IE1NSU8gd3JpdGVzIGFuZA0KPiBJVFMNCj4gY29tbWFuZHM/DQo+IA0KPiBG
b3IgZXhhbXBsZSwgd2hlbiBhIGd1ZXN0IHdyaXRlcyB0byBJU1BFTkRSIG9yIElDUEVORFIsIHRo
ZSBzaGFkb3cNCj4gc3RhdGUgaXMNCj4gdXBkYXRlZCBpbiBhcmNoL2FybTY0L2t2bS92Z2ljL3Zn
aWMtbW1pby5jOl9fc2V0X3BlbmRpbmcoKSBhbmQNCj4gX19jbGVhcl9wZW5kaW5nKCksIGJ1dCBz
ZXRfcGVuZGluZ19zdGF0ZSgpIGlzIG5vdCBjYWxsZWQuDQoNClRob3NlIGFyZSBHSUN2MyByZWdp
c3RlcnMuDQoNCj4gDQo+IFNpbWlsYXJseSwgaW4gYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLQ0K
PiBpdHMuYzp2Z2ljX2l0c19jbWRfaGFuZGxlX2NsZWFyKCksDQo+IHRoZSBJVFMgQ0xFQVIgY29t
bWFuZCB1cGRhdGVzIHRoZSBMUEkgcGVuZGluZyBzdGF0ZSB3aXRob3V0IG5vdGlmeWluZw0KPiB0
aGUNCj4gaGFyZHdhcmUuDQoNCkdJQ3YzLiBUaGVyZSdzIGEgZ29vZCByZWFzb24gdGhhdCB0aGlz
IGNvZGUgd2Fzbid0IHVwZGF0ZWQuDQoNCj4gDQo+IENvdWxkIHRoaXMgb21pc3Npb24gY2F1c2Ug
dGhlIGhhcmR3YXJlIHBlbmRpbmcgc3RhdGUgdG8gYmVjb21lDQo+IGRlc3luY2hyb25pemVkDQo+
IGZyb20gdGhlIFZHSUMgc2hhZG93IHN0YXRlLCBsZWFkaW5nIHRvIG1pc3NlZCBvciBzcHVyaW91
cyBpbnRlcnJ1cHRzPw0KDQpVaCwgbm8uIEdJQ3YzICE9IEdJQ3Y1LiBUaGlzIGlzIGEgY29tcGxl
dGVseSBkaWZmZXJlbnQgcGF0aCBmb3IgYQ0KZGlmZmVyZW50IHZHSUMgbW9kZWwuDQoNCj4gDQo+
ID4gZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy5jDQo+ID4gYi9hcmNoL2Fy
bTY0L2t2bS92Z2ljL3ZnaWMuYw0KPiA+IGluZGV4IDE2OWE4NjY0MzIyZDAuLjAyMzc5MmMyOGZj
NWMgMTAwNjQ0DQo+ID4gLS0tIGEvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLmMNCj4gPiArKysg
Yi9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMuYw0KPiA+IEBAIC01NjMsNiArNTYzLDkgQEAgaW50
IGt2bV92Z2ljX2luamVjdF9pcnEoc3RydWN0IGt2bSAqa3ZtLCBzdHJ1Y3QNCj4gPiBrdm1fdmNw
dSAqdmNwdSwNCj4gPiDCoAllbHNlDQo+ID4gwqAJCWlycS0+cGVuZGluZ19sYXRjaCA9IHRydWU7
DQo+ID4gwqANCj4gPiArCWlmIChpcnEtPm9wcyAmJiBpcnEtPm9wcy0+c2V0X3BlbmRpbmdfc3Rh
dGUpDQo+ID4gKwkJV0FSTl9PTl9PTkNFKCFpcnEtPm9wcy0+c2V0X3BlbmRpbmdfc3RhdGUodmNw
dSwNCj4gPiBpcnEpKTsNCj4gDQo+IFtTZXZlcml0eTogTWVkaXVtXQ0KPiBDYW4gYSBndWVzdCBv
ciB1bnByaXZpbGVnZWQgaG9zdC11c2Vyc3BhY2UgdHJpZ2dlciB0aGlzIHdhcm5pbmc/DQo+IA0K
PiBTaW5jZSBrdm1fdmdpY19pbmplY3RfaXJxKCkgaXMgcmVhY2hhYmxlIHZpYSB1c2Vyc3BhY2Ug
aW5qZWN0aW9uDQo+IChlLmcuLCBLVk1fSVJRX0xJTkUpIG9yIGd1ZXN0IGFjdGlvbnMsIGlmIGFu
IGFkdmVyc2FyeSBjYW4gY3JlYXRlDQo+IGNvbmRpdGlvbnMgdGhhdCBjYXVzZSBzZXRfcGVuZGlu
Z19zdGF0ZSgpIHRvIGZhaWwsIHRoZXkgY291bGQgdHJpZ2dlcg0KPiB0aGlzIFdBUk5fT05fT05D
RS4gVGhpcyB3b3VsZCB2aW9sYXRlIHRoZSBLVk0gZ3VpZGVsaW5lIGFnYWluc3QNCj4gdXNlci1y
ZWFjaGFibGUgd2FybmluZ3MuDQo+IA0KPiBDb3VsZCB0aGlzIGJlIHJlcGxhY2VkIHdpdGggYSBw
cl93YXJuX29uY2UoKSBvciBoYW5kbGVkIGJ5IHJldHVybmluZw0KPiBhbiBlcnJvciBjb2RlPw0K
PiANCg0KSW4gZ2VuZXJhbCwgSSBkb24ndCB0aGluayB3ZSBjYW4gaGl0IHRoaXMuIEl0IHdvdWxk
IG1lYW4gdGhhdCB3ZSd2ZQ0KbWFkZSBpdCB0aGlzIGZhciBhbmQgaGF2ZSBtYW5hZ2VkIHRvIHJl
c29sdmUgYSBzdHJ1Y3QgdmdpY19pcnEuDQoNClRoYW5rcywNClNhc2NoYQ0K
