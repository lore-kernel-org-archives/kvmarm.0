Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013032.outbound.protection.outlook.com [40.107.162.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6C44347FD7
	for <kvmarm@lists.linux.dev>; Fri, 14 Nov 2025 20:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.32
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763151311; cv=fail; b=nw1ngES0tQd0iWnu4wNOxruUiSNSqHIvJeHnfcKFXjZZIJKYf/Pra4VMMtFscHJsb5hqPrzITOXNAzPND272EkhHED62diw+k2oYJuNQ8NugEaksziM5ewCitjY2edDIcFEQO3uVTrQF8sC4VH5k8QWRhbS1xdaHbO9nwlxSlO0=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763151311; c=relaxed/simple;
	bh=OvKtjwq1quBGOKtVmT/ldFzkQhGzzkqYsvY4fs5946k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Aca7nkyjR/prwMWYI2S4aes4b59sH+bkDtn6XYPxePrHF1a97s8tzo9+CsQnq1UyYrFj3yJJ6Xghz53I+BDngtFjoNUXrZKOTrzrwssCYWeABi1u/eQMgb+oMKmyPTzvtCAFxoBCh+C75as7l0wVXHJPcTf/F2macgZmXB72uWA=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=YN9QYHUA; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=YN9QYHUA; arc=fail smtp.client-ip=40.107.162.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="YN9QYHUA";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="YN9QYHUA"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=oQxsFMrFK+n4q05ENOJ5ouzEPReCHWsYPGuMTF8vvofuMP8ZfglkoLZxU3FwPILAUH/92kMIR+D6Bl2BBKRIU4NxAhSWeMoyD+KSc/ekqKfJ29n/hnhBdJLfQ2FyuvlZhueKg1RkCS571s0/rRYzipvHHa2YpmrPr4LgvA7aciZQ9ZlpXCWbtzPam5SE1pEVo1jLeB4689es6TSqKSAjvAbwnEm5C29n0W5rCwFX1EeykLTz38zMrP0NKLmQsfQJW/YXZpysUimwL5k5ZKT3wFsnKRHOkhKMHBOg0sc2uZaP/fSTHAjsHFLIb5GpA7BzIp0iEQQ6PfTwdK6Pm+jVjQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ewpkvNfSqu77Os03vtyEhrIlN/IqD7d/nJNgwEsClns=;
 b=QZ1u9Anxic4GmQFipWK8RTPZ7QHGvYIxZ112wikfQRkOxsQ32bMnNpSlIJKjyfYiXljRwOjWvb/SuZYzqsNHwYEfzpiuiB9/2V+kiA+0XCiqo9ULui4MA3zRVELrhx/LcJZyT1HCjTMFOIBVKos8IX5zJJyYpWzS/raYaxSBW7FDmeSA+9CqYsEcaGOfb8ovvQE9KNOMaCk0pnovoMq9dyic3ccYqfsDrEnHGUut/mkoh0LOD7HGtMjIP/vmMsiWarC/8OEUJulBcrvmClW3jYb/GC4Ymr7RckE/pqefxTWtu/QV7Ss6V6PWbNwTHOGjTW3zwK9D5WLj5fazxwhbBw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ewpkvNfSqu77Os03vtyEhrIlN/IqD7d/nJNgwEsClns=;
 b=YN9QYHUAbyzEPXos9aBxtd4uqDGMEtdb59RnTOctMJOuVYoZ/bGv1XR4/X1fOYGuCHRNMR+h4sbb0ZKCzSLtrTPyJNEjPtADytS0darSAgokrVyL6AeH6JAzWtNG3i4Jazt/pgxYb8iAng2iFyUHVGDU/zQtcUA9Ktelm04CtfI=
Received: from DU6P191CA0033.EURP191.PROD.OUTLOOK.COM (2603:10a6:10:53f::8) by
 GV2PR08MB8169.eurprd08.prod.outlook.com (2603:10a6:150:78::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9320.17; Fri, 14 Nov 2025 20:15:01 +0000
Received: from DU2PEPF00028D0F.eurprd03.prod.outlook.com
 (2603:10a6:10:53f:cafe::c2) by DU6P191CA0033.outlook.office365.com
 (2603:10a6:10:53f::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9320.17 via Frontend Transport; Fri,
 14 Nov 2025 20:14:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF00028D0F.mail.protection.outlook.com (10.167.242.23) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9320.13
 via Frontend Transport; Fri, 14 Nov 2025 20:15:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Tzhu73I0e/9LJbZ5jde3b5fdXSv+sXm+vdYRB1AHnHFFOgUb5vFRP1bVdSORxDoNOmSTBf2y9O7BF8qjnYD8Jm5HAzdVNJxK7kZUO+qLjseH6cYSpLd4rybZ8m2yv5LEnqzs1n6FRRw1g/Ua+IgYDRoq9eB+sOgBsm4yeg5cLkVos/JMC2LxDuOnAloVN8X50o5IpWGj21P0h658uHUTsmjh7lta7bafiAQ78iFNXGqMeAQFB1OxYttHa2ydeeknCCa6xkbKGyIPwZ89DRlE63uDomab7sigz9Hoxji5B8PeFSvRkucNC7+mXcOijXVKg7DcAeO5daJv79kEwlQEQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ewpkvNfSqu77Os03vtyEhrIlN/IqD7d/nJNgwEsClns=;
 b=OmLIyEFCBqJkgGZWCYq2o+LLrr3DjY3AqVvmwsiW9WqPD9dqxj3Jb0+UoezcWsZxzS1veT5gdlebAc2aWFMSJYgBLPpOErAQNdNj5RkFuJv7HgGhwzvx2KSnFSZ5MRIyLGzkvy0yfiESqy/wvC7Kvlt6nbwxw4xQGAgwcwZXXtf8AU/cX0Jyz56JolVb0vG9DI3ypgbwtC797TX0TK+ap4qofMVFhCDrRloaq1pzy2yTUNIEpejIZ1GskI28a19YWzWhiEFYwdPWL2oo8XeJMG5aT6f6AbsoAjLTTi5lezqAaEx3yNE2XjwzD9dt/ISJqmLaszhfOdqQhDjXy0EJQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ewpkvNfSqu77Os03vtyEhrIlN/IqD7d/nJNgwEsClns=;
 b=YN9QYHUAbyzEPXos9aBxtd4uqDGMEtdb59RnTOctMJOuVYoZ/bGv1XR4/X1fOYGuCHRNMR+h4sbb0ZKCzSLtrTPyJNEjPtADytS0darSAgokrVyL6AeH6JAzWtNG3i4Jazt/pgxYb8iAng2iFyUHVGDU/zQtcUA9Ktelm04CtfI=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20) by VI0PR08MB11041.eurprd08.prod.outlook.com
 (2603:10a6:800:256::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.17; Fri, 14 Nov
 2025 20:14:25 +0000
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739]) by GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739%3]) with mapi id 15.20.9320.013; Fri, 14 Nov 2025
 20:14:25 +0000
Date: Fri, 14 Nov 2025 20:14:22 +0000
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Will Deacon <will@kernel.org>, sudeep.holla@arm.com
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, perlarsen@google.com, ayrton@google.com,
	ben.horgan@arm.com, sudeep.holla@arm.com, stuart.yoder@arm.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] KVM: arm64: fix FF-A call failure when ff-a
 driver is built-in
Message-ID: <aReNnhPnuDQVrO+l@e129823.arm.com>
References: <20251030102245.2313898-1-yeoreum.yun@arm.com>
 <20251030102245.2313898-2-yeoreum.yun@arm.com>
 <aRdX1YM0Y8WMP05w@willie-the-truck>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aRdX1YM0Y8WMP05w@willie-the-truck>
X-ClientProxiedBy: LO2P265CA0161.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9::29) To GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GV1PR08MB10521:EE_|VI0PR08MB11041:EE_|DU2PEPF00028D0F:EE_|GV2PR08MB8169:EE_
X-MS-Office365-Filtering-Correlation-Id: 89ce744f-437e-4dec-3627-08de23ba7dba
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?M2YyMXp3UFRqSTliWjB1NDBwcTRnVEdkSXdiMklOdklQUmZmVVBBdit2bzFK?=
 =?utf-8?B?dE9LSlhPaFRKS1c5TDdzNXNnSkkyYkR1ZWpwRkdwZlBHTXdRU256L3c0V1JX?=
 =?utf-8?B?TFNYYU83RDNEalo1ZGJ3Y2dSR0hsQUZBcU13dzN0L3dMaFh0QzBFWkRNOEdu?=
 =?utf-8?B?YkhvZDNlWHBoRUFTeTlKWW5Wc2dVdyt2NlRVWmZHaUpwRUVPQmZwOXN2R3d6?=
 =?utf-8?B?b2Nuei9VZlVoNm81YW5CclI1MUlxdEIzdUVDQWpQbWR3alZvVFZPMCtuN1BH?=
 =?utf-8?B?N3ZVbVhQai9TS2FUKzNxV2hYa1ozbG9SNVRJUG1mMzRFWTV5dlVWRDZXbWl1?=
 =?utf-8?B?UEFHNm9BRjNRSFBnRWU1bHRIMkVPSG5wTnRzdDJPenYvaXdyYUw3RC81Mjk2?=
 =?utf-8?B?VjExZ3p4U08zUnFtRlFUczVKWWVhWVZPdnpBM1NWK0Q2Zy85UnhTVHFQbENm?=
 =?utf-8?B?M01GTVFXRHBtUFNVeHRLVmlXMjhGUXBMZ0ZmQ2VwS2lKWE9iK2NhTXdZZVU0?=
 =?utf-8?B?WHcwMndnV0FQRTZlYlNoZDdrSnZxcm9weVkzZC9rK09PTWFNVnBmbUdXSnBv?=
 =?utf-8?B?OEFsdTc1TVBVK2lWdWVUQzdPWkV6K3FmT2ZhTkdoaTVoYU1rN1BqTmo0RGpo?=
 =?utf-8?B?aEh0SUNJMDhRWmJpeFhTWmIrcHBXNGhHM2NBZnVqUFZNNzA2STJ1VGUzeENW?=
 =?utf-8?B?dnlWbnNUQVNELysyRFBhZlhMNS9LeXVGdzJ6NkVFVHRCSlNVZk51bHIraWFZ?=
 =?utf-8?B?M2NGL3p1M3Nka3QrNUZrQjdtWTFUWWF3T3BXdWlKSnEwT1k3QWRWNFVKM2Zh?=
 =?utf-8?B?U0ZGK2c2Nm11NlBLSDZsb0V5VDJBZllHL0xxdU9ZeFZvNU9DSWdWWFZzRGNv?=
 =?utf-8?B?VzU1U1EzRnIyVERpREZ6eTY3Lyt5eXQ3OFhHMmptNU9uQ3ZsT2FNcVBpSGNI?=
 =?utf-8?B?c2pCa3JKK3RKYmd6aFVJY3YvaUdReU1SRGhza0lrSit0c09JZkVCajRhQXha?=
 =?utf-8?B?SlNQc3JxSGNBNURxRlI0Rkppa1hmZ3c3anNrTEgrUWFiaW5qUVptSTBpZnlZ?=
 =?utf-8?B?MUkvZzFwMlVjMm1Sb0xvRDhNUDJOREJTS3p4bm5rOURXR0VmaURlY3RpV1R4?=
 =?utf-8?B?M1N3dUhPK2EvMGtuOHRtUlRnRVpEUlZRZ3RPcGFGQ2FoZ3VJWDh6bHhBK2c1?=
 =?utf-8?B?bmRldHR4V1pSM0dLWUtBUDRIZTcvNWI1MFZaNkE0Ym9PWDZabkdNL29hVURP?=
 =?utf-8?B?SmtVV3BqbVQ2cGtvRlFEVTh3eVhGOGkzdDVDODV6WUVNMjhFQmFITTFxSVFG?=
 =?utf-8?B?TXUxak1zZER6TmZDT1FtMUN5dllTT3F3QW1tdmZCN2IvVzAwNWlqaXErUHhj?=
 =?utf-8?B?VHlQR0R4bmpkN2h4RjVDdzdCTXduRnJpOUNuUnJwTTVoOEUrd0VCZ1pKclNF?=
 =?utf-8?B?K00yenc5aGJETDJtL005V0pBanltZjh4UStPeHNIQ3VTK2IyS1RzMjFaa3J2?=
 =?utf-8?B?dFA4bjJjSjdwMzJxdjkrOGY1di9RTFBpRDhDVXhaUzBueUVNZzA4cERRYzZ3?=
 =?utf-8?B?LzN3TWt6U3N3M3lqOTkrZ1NMWW9YN0svNFoyUWREdEZRUDZLbDJ5OC9WV3lC?=
 =?utf-8?B?U3ZyMkcyVGJrUkFMUnRTQnZndG84L21hcGxjZUs3c0xBT05jYnFBd2ExQ1hH?=
 =?utf-8?B?L202ZU9NYkQ1YzNyV2d0RWR3Q00xaGVHTExyMXB6U3AxUkhUOTZJc3JaMUQr?=
 =?utf-8?B?MDAvazB3K0VuZmNwd2U5Y0k2eVA2cVgyTlgxL1NCQU9iSGp5ZUNGdnZFMVJQ?=
 =?utf-8?B?ZlU5azA3alZTbHNwaVMrOGNGT1NMRjdvU1kvM0l5bWh3cDZKQ3I0aWNnbGtD?=
 =?utf-8?B?WEo3YkZ4YUlrZXVtMmFVTjd3YmxNMEhONVhnZENxS29yVkQwVUxaM2FTV0Nr?=
 =?utf-8?B?RG9jTnU5bkJDV3NBSEVsS1l4dVRWWGIyTHBPbEFYcG5sb2w3Yjhva1lLL0p5?=
 =?utf-8?B?UklTaGR1OHhRPT0=?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB10521.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR08MB11041
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF00028D0F.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	4a5f93b8-fb8f-4d20-0603-08de23ba6848
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|35042699022|36860700013|376014|1800799024|14060799003|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bEd0Q1o0RjR0OEJzdUlSMHJVREtpNGx2TWh5V3FXRVhIaGJqMEl1ODRDaUZI?=
 =?utf-8?B?RjFsWTBuTE9qdHNmTUNLcExIRXRkb2hVR1RTR1VRZ0RNS2FoOWRVR0ZrSWE2?=
 =?utf-8?B?ODdQeis4eklTWFpiY3Z0WTFZZVp5dEJxNGJoVFowdE1TT3pHa2hNQ0l6OXpk?=
 =?utf-8?B?WWV0MmRnaVVBLzhKaGpwN0Jxc2Q2QWRQaGVXVlNacWF0STAzT25CREJEVEg4?=
 =?utf-8?B?U2RSY1BOcVZrNE5kZkhYRWFVWWFCMlBJbFNWWm1aRGZJd0ZHSUFwZW00b3g2?=
 =?utf-8?B?dHdrNTU2TWpOREFCemFDUUZXYjdUWXFzOS8yVmFzbGJFL09UT0hVeTY3ZERC?=
 =?utf-8?B?a24wcWh2K0ZETzNkNzlNenRYazhuWWN3OTlrRXJmMUlkaEZtV0RTYVJrNlBm?=
 =?utf-8?B?T0VOczU0NDdVMFMrK3ZsQ2JOVG1SWm13VFhueTB2TG95am0zbnlUT2R6YllF?=
 =?utf-8?B?VWZaRkJuZCtPam9lK2VLTTlHMmpvSEJ1TEJ5M2pwZ24vcm5BNHdYWUlwc3lW?=
 =?utf-8?B?aitleHIxaU4wMy9PeUh6N0xmbWQ4WnNIOHQ3UkFHeHBzRmRsYWpvL3J4T2cr?=
 =?utf-8?B?SXR1NlpidW5scEJUWVhkK3ZoNDFtTGlSWHlwWG9hb29Tb3NYNHRRL0pnR2Nm?=
 =?utf-8?B?T0RFeWcwY1dYZzZhdnE4SDFxaElXTk5pemg3ZjJXcTlDekIweXZvbGxUc0k1?=
 =?utf-8?B?ZzJiay94NEFlREhURWREanlackxnWHFJNnR5aUNFaFl6eW5YaXhqSy9VaWFp?=
 =?utf-8?B?ZUwrWHQ4dkFuaGxYSnVFT2wvTUREcWIrUTNmWkFDQ1FyNWlCeWRqZmdteUxz?=
 =?utf-8?B?b3k4NkNOd28xSExtcnFFay9IY1Y3bUcvVmhybVZENmpKWUdicGM0T1JwU2ZV?=
 =?utf-8?B?Q0c0aGNRWVJKN3NhOTltNStCelJSV2UrSjdTZ1hLL2lrcnMvLzBlU0ZrUHJX?=
 =?utf-8?B?ZFNkSWdKbXJpZTYrSmhtNTlRczd4S1dSL1o5TE84a2tvc3ltOVZqbWdSWW5i?=
 =?utf-8?B?a2t6R2Z6KzhHeE5odG56c1NFdm1VVUR3MkFvRkxwZjZoSFRQQ000L1ordW5r?=
 =?utf-8?B?Y3NYd0hHQmM5YW5yNUM0Sjc5WHVsWmFkWDRkTmhhQUtnN3g0dUJWRGptV243?=
 =?utf-8?B?a3ZCcUdubGFEclB1ZXJ6TTdFQ1NaSTRJMkV3RnU2UGdrL1VMcm5tK2ZCQ0hF?=
 =?utf-8?B?ZkxOcDF4NFJDQWNEOC9HSXF0RWVPdHVQNmtyOGFqQzlCTGlQWE1tcmhLYWFK?=
 =?utf-8?B?aWxiS0N0TFVsRzN3ZWJ4aU5FREdLUmNEdGR3OEQvZGNTY2JIWGMyRVV2TmVF?=
 =?utf-8?B?bXRkQVVFTFl5MkpFT2NnMzlmajkrQWpzNVdpL0VMVFNWUC9wc0NYRzBjcVUy?=
 =?utf-8?B?Vm5ZU3g2Rm8ycERxOVVJd0ZoZjFwSDdkdXNZeG9nd2V0YkNDWVpLQ2M4QUFC?=
 =?utf-8?B?WkY0SUdVdHRiaG9oYVF6MDVYQmhLOFhIVDJyRXhLTTdZbWVhbW1McnpZMjEv?=
 =?utf-8?B?NWV1VCt3Wm1FUEMyTWs3aXJkOFFaVzJLUEZwMzhRMzl0Wk8vb094N2xXS1pY?=
 =?utf-8?B?WUFaSmNMNm0vY1dtbzJwNGl4eWFIZzlEdWFEY3BWV2o2ZHpjWWgwUHpmRnlB?=
 =?utf-8?B?MjJRakpETEpGSFpkM2VTV09vU0RURURXUGJYMjFjb016Qlo4Qk5nSzU4S0kx?=
 =?utf-8?B?ZzlKemsxVXlPZ3VZSjBXMlQyQkMrTXFENG9NOEY3Ti9ZL3pjZTNVekp1ME1B?=
 =?utf-8?B?UkJWVUtwSWdDQUt2ZmtMOGhkZzNGS2RCbVROT0xZQUN5cUtyRTVzSWlib2w3?=
 =?utf-8?B?VzN4SHBWekcyU3pQQ2hOWEJwQWUvb2d6RmVLTjk3OGlEYXVwNXBReEpSVEc3?=
 =?utf-8?B?dUFUOFcvNW01MlJRSngwTXhKNkhaL3E2Ti9lRThHbVB3RW5QVWYvaE9SVG8z?=
 =?utf-8?B?TytNNmp4WFpKa09ZRUU2NTRkbDF1Q0xYT2dwL2FzRjdWMkRvd0RMT1hDSU11?=
 =?utf-8?B?ZnJ0Z0lSN0hycHIyUDVPNDhveHEvQ213TVJHRDQ5UWlNaXdXTDBXR1Q4Qm5F?=
 =?utf-8?B?N2lwRzFMWVpzaVNabjNNZytwM092N2dRYXFHYm54a20vaXhHbUpmWGNKeUhE?=
 =?utf-8?Q?i5lNO98Q+L8Lud+6gDgvFKp9X?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(35042699022)(36860700013)(376014)(1800799024)(14060799003)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2025 20:15:01.2333
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 89ce744f-437e-4dec-3627-08de23ba7dba
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF00028D0F.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR08MB8169

+ Sudeep

Hi Will,

> On Thu, Oct 30, 2025 at 10:22:44AM +0000, Yeoreum Yun wrote:
> > Until has_version_negotiated is set to true,
> > all FF-A function calls fail except FFA_VERSION.
> > The has_version_negotiated flag is set to true when
> > the first FFA_VERSION call is made after init_hyp_mode().
> >
> > This works fine when the FF-A driver is built as a module,
> > since ffa_init() is invoked after kvm_arm_init(), allowing do_ffa_version()
> > to set has_version_negotiated to true.
> >
> > However, when the FF-A driver is built-in (CONFIG_ARM_FFA_TRANSPORT=y),
> > all FF-A calls fail. This happens because ffa_init() runs before
> > kvm_arm_init() — the init level of ffa_init() is rootfs_initcall.
> > As a result, the hypervisor cannot set has_version_negotiated,
> > since the FFA_VERSION call made in ffa_init() does not trap to the hypervisor
> > (HCR_EL2.TSC is cleared before kvm_arm_init()).
> >
> > Consequently, this causes failures when using EFI variable services
> > with secure partitions that rely on FFA_SEND_DIRECT_MSG.
> >
> > To fix this, call hyp_ffa_post_init() and set has_version_negotiated
> > during hyp_ffa_init() when the FF-A driver is built-in (CONFIG_ARM_FFA_TRANSPORT=y).
> >
> > Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> > ---
> >  arch/arm64/kvm/hyp/nvhe/ffa.c | 12 ++++++++++++
> >  1 file changed, 12 insertions(+)
> >
> > diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> > index 4e16f9b96f63..0ae87ff61758 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> > @@ -984,5 +984,17 @@ int hyp_ffa_init(void *pages)
> >  	};
> >
> >  	version_lock = __HYP_SPIN_LOCK_UNLOCKED;
> > +
> > +	if (IS_BUILTIN(CONFIG_ARM_FFA_TRANSPORT)) {
> > +		hyp_spin_lock(&version_lock);
> > +		if (hyp_ffa_post_init()) {
> > +			hyp_spin_unlock(&version_lock);
> > +			return -EOPNOTSUPP;
> > +		}
> > +
> > +		smp_store_release(&has_version_negotiated, true);
> > +		hyp_spin_unlock(&version_lock);
> > +	}
> > +
>
> I don't think this is the right approach.
>
> If the host starts using FF-A before pKVM has initialised, then we've
> got bigger problems than the version because we have no way of knowing
> which pages have been shared with TZ before we initialised.

Right. for Rx Tx buffer also. This is mentioned by Sebastian in
another thread (https://lore.kernel.org/all/aQRuvu8V3woqnqCV@google.com/)

> Why can't FFA defer initialisation until after the proxy has initialised
> when pKVM is enabled? The fact that the driver is modular indicates that
> this should be do-able.

For example, IMA doesn't support the module build
and if ffa driver and related drivers using ffa driver defered,
IMA couldn't generated "boot aggregate log" which should be produced
at that time with PCR values in the TPM using CRB over FF-A.

That's why commit 0e0546eabcd6 ("firmware: arm_ffa: Change initcall level of ffa_init() to rootfs_initcall")
changes init level of FFA core driver.

But I think this problem already exist before the commit
since the FF-A driver's initcall level was device_initcall() and
arm_kvm_init() is also device_initcall().

IOW, if linker depolyes the FF-A driver's initcall first when
FFA driver and KVM are built as built-in,
pKVM couldn't hook the SMC call in the FFA driver's initcall.

TBH, I'm still thinking the way to solve it but
Currently I couldn't find out some solution except the one which is bad in
https://lore.kernel.org/all/aQSKpZDrLzf%2Fbcx7@e129823.arm.com/
(seperate the arm_kvm_init into two part)...

--
Sincerely,
Yeoreum Yun
