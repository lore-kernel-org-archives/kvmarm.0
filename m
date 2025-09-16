Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013014.outbound.protection.outlook.com [52.101.72.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6208F224B01
	for <kvmarm@lists.linux.dev>; Tue, 16 Sep 2025 10:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.14
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758016984; cv=fail; b=an6H1LUquMrfWAmkE1l41fd7Cl0NOKmEhGnxyoTzv2BAmP9qrRQhge4V8T/WIYvkdqAMOV4dnS7OTa1KeRW3fjMTLrIyw5EcXo7N6tNIIcQB5SLSX4ndLDeLRVCFLlm5jdmBM9zehrA1mk0gPTROKWeldO8HmLKnjgBKN4RhY0k=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758016984; c=relaxed/simple;
	bh=E+N04wJ0NGSUBcdvKtTq9bCrddKpZzJ7SVZm1PHf0Lg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=uAa9MVoHe2rDyhnxU2B0/F6gQzt64g61ciEBNcxLQKJQUB5h9H0dPcMaUUJI0WhhGmLQi4Wzxlz19QLCsoUCQR5s4+3LB37+I1eOXnTPjIODX6Y8fdMvCzwSUG1JEP+9MmQDXMpK3df0LawI23XDfHVBaWS8pMQp/Ox+vOACUsU=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=anfqdQ7b; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=anfqdQ7b; arc=fail smtp.client-ip=52.101.72.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="anfqdQ7b";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="anfqdQ7b"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=QOJfpl0PFRme8MAXTJ01sywbaQgtgSQYcA+BOUpVbsco+BjJm/esQS2bjMuX77yvoo2qiiqEZR5a8HaEOdjKoraAvuqSvOtdB9x7caRs4ZLNysqviStqaMG4dGB0kzouaJYSvBcK1mEPGWJ3YrASzhEY/Wy+hGNW1CS1ueCVgDcWD2gRmXTlBQwW7LC4sqsf6gumVHiBUx7qQGSj90I118XnFDMOCFQMyrnmM3lVvRITGIvMe1cSBMbVZ62XvoCR13n9INmThWG77930+A8aUGH9Lj7smBGXzRpzf9bbmEfWR7I3kFgeM9lNvvWUY20DrH+wPSBOsLF+RWX+QSCD2w==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7zLND5qDFYgtFTw0Ofi0oGgClk4mha1DAfA1buRMy+A=;
 b=LKHFUQDKPaWk44bvkrSXwXW1KUuooqdgXcwMZDWeFkb2SxOp25TkcKCOzUxKJr+0rPtioZeki4BVlRi5FiWXOOWGRpUJMaq5pPax6uZTaWmTjeJBaONX2E5Y/N99mcVrlNn7T/8Wtl+dwylhO9f/p/bNWCCr8EU8/7Cf23gx7KD4nWMffPg8zive5BPHTGV030TnjdsOsvcvmY/pzoHcs/E10rdSLT1u7A1bbjSplpU8xchikBpqb1yeLdAcEupYKBJmHUmD4Jv8NcDQhjUyWNVBTz1M5lV+JKJQlKLVyJ66IOfvQ1/zZVhEj6fHAtfC9JdhZrshfWgHCYmIrGLlpQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7zLND5qDFYgtFTw0Ofi0oGgClk4mha1DAfA1buRMy+A=;
 b=anfqdQ7bp7wVz5M8G0QBFcgsmmDcJj3A3jrkcGvBjn4dKv7lstEd0d1roz+hjcuEmJW11cAMn5GPNVXu3bVq5GIp/5OeRnn2j+tXNelARKuABA9uawMs5741zcoNMFSuBvEi9x0Yx2RZnlP7jlj0A0tkrlvJ5l4Doi1l7pkCrgk=
Received: from DU2PR04CA0277.eurprd04.prod.outlook.com (2603:10a6:10:28c::12)
 by AMDPR08MB11526.eurprd08.prod.outlook.com (2603:10a6:20b:719::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.22; Tue, 16 Sep
 2025 10:02:58 +0000
Received: from DB3PEPF0000885E.eurprd02.prod.outlook.com
 (2603:10a6:10:28c:cafe::81) by DU2PR04CA0277.outlook.office365.com
 (2603:10a6:10:28c::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9115.21 via Frontend Transport; Tue,
 16 Sep 2025 10:02:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB3PEPF0000885E.mail.protection.outlook.com (10.167.242.9) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9137.12
 via Frontend Transport; Tue, 16 Sep 2025 10:02:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mufq3M+9AZQAf+vfDBJ7r1JxYfXTJu6f+xj29BohyRuVxLlF0vjPEMbK0fBZlARCSHURw46ae4t/oX87CpqLERHyuDJVdQXKTtcb7I7dZoIyNhYkiuaE1HmALhgKXItspAQ+qC28ddjI/UcR9Xh5L5S3NXvViMoSuzAY5vPSQaHIqS+5bWvJEYKf6/gEG4ASlbUpk3s2xUwLmAqE93t+5mprKfDLIS9TG1ApjRe//qeTV0c59eGTGvJUb0TfXJt25HDqckfVDT8RC89Iv4a71pgPuhQf1AP8Kj9Eo1To1IlGhxM3Xm/AQsjcPmHkM7iC+hJhoi+v8OVeWO8Yqe/1Ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7zLND5qDFYgtFTw0Ofi0oGgClk4mha1DAfA1buRMy+A=;
 b=hw+kbczfIjZ8jjzlAFLLKYA0O+NdZ//B1L6duauIZPBFpPaomQL8QaXEKOpLnmfm9FoF3WoDbfqoDMGNPI+pYFaMYYGa5lGw04QpNFCx/udHKePkGncWo8WpX5Zw4+wKCrSR4KXveEaftIFc5AX58gdGBIPIKkm1o1nQSgiAYQAPaWjbPAR9CJAQdHYc1ZFQulLQY7+VbC4XfvymTJ6dtp7ro+OXnOtRObRwX0xa4xVUdU5+D2CTx8O88G9ybdiHI95E+Tb26RYmp/m8zl5mYA0wGlDWaykXK2ZTCsMfTs077O0SvSJvri5B/LF6g5hojF43J17X4L0eIYRywNKBpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7zLND5qDFYgtFTw0Ofi0oGgClk4mha1DAfA1buRMy+A=;
 b=anfqdQ7bp7wVz5M8G0QBFcgsmmDcJj3A3jrkcGvBjn4dKv7lstEd0d1roz+hjcuEmJW11cAMn5GPNVXu3bVq5GIp/5OeRnn2j+tXNelARKuABA9uawMs5741zcoNMFSuBvEi9x0Yx2RZnlP7jlj0A0tkrlvJ5l4Doi1l7pkCrgk=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20) by AM8PR08MB5666.eurprd08.prod.outlook.com
 (2603:10a6:20b:1de::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.22; Tue, 16 Sep
 2025 10:02:24 +0000
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739]) by GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739%3]) with mapi id 15.20.9115.020; Tue, 16 Sep 2025
 10:02:22 +0000
Date: Tue, 16 Sep 2025 11:02:19 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>, broonie@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, james.morse@arm.com,
	ardb@kernel.org, scott@os.amperecomputing.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com, mark.rutland@arm.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND v7 4/6] arm64: futex: refactor futex atomic
 operation
Message-ID: <aMk1qxS3htyaTgEQ@e129823.arm.com>
References: <20250816151929.197589-1-yeoreum.yun@arm.com>
 <20250816151929.197589-5-yeoreum.yun@arm.com>
 <aMRQIeIdyiWVR8a0@arm.com>
 <aMfrR0vserl/hfZ3@e129823.arm.com>
 <aMhrscd1gz_syMtL@arm.com>
 <aMh4q4-xAPHnaOul@willie-the-truck>
 <aMkLb6jPiSbzeRWL@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aMkLb6jPiSbzeRWL@arm.com>
X-ClientProxiedBy: LO4P123CA0333.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18c::14) To GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GV1PR08MB10521:EE_|AM8PR08MB5666:EE_|DB3PEPF0000885E:EE_|AMDPR08MB11526:EE_
X-MS-Office365-Filtering-Correlation-Id: 1d278995-5888-4b56-9136-08ddf5083692
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info-Original:
 =?us-ascii?Q?Bv7ugJwkdkaBX6YvR3UCNTfmkTMoH6FpddcS35kSmYWNvtzBj4+QupC7mn6V?=
 =?us-ascii?Q?1B7t8ivAMwr/F+3pso1SvZh4z0lljRJip++1uy56J8Crm2FX2/fP2uuSAleM?=
 =?us-ascii?Q?jEBI2womVBWFO0Rjk4NAaydRSPf98zkQbevtk1PVlMeHv5v/8/mzOP987uW7?=
 =?us-ascii?Q?v9HmUpCyxvr7rMsbeGTEtGMzbmETueCDFlNMw1x7jHcULMKyXyuU2upPzapy?=
 =?us-ascii?Q?nMQh1J16hXx9F5WT/+k8vIg2FTSDIz3kzzRthUZQnx2MxQTLL9B4bq9WGlLV?=
 =?us-ascii?Q?quEnaX3ySenq1eiFpvsP5WaAb8jvnpkIXMsIShDMrTcBDrrDP3MMYVEr8GXk?=
 =?us-ascii?Q?GXnfl70OcTFA9OBIWeemBjbh2vjfaAmxlMg5DPQ1hFx+XKpTCrQVNZ+rUJWp?=
 =?us-ascii?Q?4m3vMILRZnYt77OeVyXa95taF6aHtEIPJAj7Q8UJVIpHDNkSHWenk8lnoZ+z?=
 =?us-ascii?Q?pu9cZPhFrSt43qFXL12MGghKCTWkcLM6nHO4axNFdPaDSZ3NGvCv+hHglDmJ?=
 =?us-ascii?Q?oA+fBLM89MD2OifCSmgP/CTouYAKyMCx8Sc/NIyR35WsdFMlbMdMBrHsQCW9?=
 =?us-ascii?Q?t7MjP0i0izV5NjDvOQA3YKcC78B44ZmaQzBHiNeNTTLqMC1QO1pg95f6StnR?=
 =?us-ascii?Q?ajdFnshHzdoT9Ni0SBEJF1z2wn1h+901palizHj1LcFuQC7FBrwvmNx9LSTJ?=
 =?us-ascii?Q?FKvlRAmecIJX507mexRG+YUTSX/gyaD8qPYmn/CHXFZ7gV1BDIRMk87V16vo?=
 =?us-ascii?Q?zgeC/p3O2CdRp6BpMXGlehIE6SyMWrQhgA0wmaLsGHzfGjfptNVvTH4I2+lx?=
 =?us-ascii?Q?8IRWR8V7ekRvD3kXCFklnZ48HK+J5OBdVWP1c+dwR0qniXNq+p4afdgS+iAp?=
 =?us-ascii?Q?VZHgUE0tuLIh3lC2ZzzS4iJ2ZcNuRp7VApUs5eeCexJSJ7Aurpp7GsxvyIsz?=
 =?us-ascii?Q?6G9pElJclt1hWuvcr7BQWthteToHo96pl8IgQOi/WYR6GBrTM2cPA7UGUfYo?=
 =?us-ascii?Q?AHDzRV9Xk7g27JN0pHE1SLA/OIU9ixxZlR3fpTiYiYhNdbeQfBIHYnSB7bNO?=
 =?us-ascii?Q?IgiDQ4ODtOQnjdxVRPksSWuIUhLhyrmxXodNyZDl7oT+tuYp3e94e3Kpv4b6?=
 =?us-ascii?Q?EeOXBGOAORMMaOsNIuT92mReLoQ8zwSLW+AlouNO4zsLx9sLXhNQVzVuBsKs?=
 =?us-ascii?Q?spyP2c6QagGQl3kdVH3EEKkOoV6cg7myI808R0UXF52ZMYdt2aLX+HJWZmv1?=
 =?us-ascii?Q?YZKiu2Fv5AI+YNCi7saZk9yajOQnWgqU8NMK54V6viKKjp0MfMMXk1K4ZxzI?=
 =?us-ascii?Q?DWjhvgu9lI6QYrY1w5VAv5PsGSsb9kTpeac2u2BHykbF2R/BneNqsCjLb54v?=
 =?us-ascii?Q?zNWXUC6fA71OGmnOHOvdSlUMyt34hHi07LJlbNwWGbWFwOd+nRjOEbWlMu5n?=
 =?us-ascii?Q?er2yhTOakO8=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB10521.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR08MB5666
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB3PEPF0000885E.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	f604b0c1-2849-49ee-c712-08ddf5082167
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|14060799003|35042699022|1800799024|7416014|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?DGxsWrefF4uKifMjW3VO6bjJjlr7UQyRt12YLLBfru85GixeM0FeJ7YENqjF?=
 =?us-ascii?Q?r8wUC65w9kUGeoTSJbP8FLrcz1/iktPQrjhwaFHo1ywsoFmhB0DiO5FqRtAT?=
 =?us-ascii?Q?QLCy8kTjHajDjtjLI+sdoetrf9rpFFgl3FWPmVQ2gU+oCskv5xtDaVDzRCw7?=
 =?us-ascii?Q?ewOB10YfRfstK6ShL4Gb9lRlMZN9RLWAxwAoCLNl0q7PlNBg4M5CkvSi7COD?=
 =?us-ascii?Q?lUNdChExPcBqWQJX7WWk+n8UEmRSWgI6vqNh3THqcSYRVyPM5MVoc6EzJS8Z?=
 =?us-ascii?Q?GmzS7rTMiIJSkB5+eobFV7/Uqv6bykfZja2DwqNSHIkU6YTVOfdUQm3fiGWF?=
 =?us-ascii?Q?fxWJlfwEdPvu08Se3pMwhza6zJboQj+TRzhwN5EMqOIcKnP76bw/gDKyMfPR?=
 =?us-ascii?Q?3QrP1B2mB195p7kL52wQJQJPHAuyD8ClHEn9cXy6gKjFI9vJPia6NAHRwp0j?=
 =?us-ascii?Q?RRYE0w/auCwl6pXykCWV9k/yAY5eAyUx9ZWwen/ve2wTrIIU8Q2Qv1vJBYlT?=
 =?us-ascii?Q?xlaxXEl37JT454rb2EFo4dRNk4vpQDMp0aE/jWVMb2aEeW8qNJn+RCsxRMnJ?=
 =?us-ascii?Q?XlSQ0dDsNxDTsyP9/+oVvR2elTXRh7RXjq/OJ2xRkbe45AqMvSGtFbkOO3Ob?=
 =?us-ascii?Q?Xy7sHPmf3Ywmu8oWutWnDmeIrIjvUvG0ivCtcmEpLY9oTpIZ3I1HoONbbicf?=
 =?us-ascii?Q?GKLgrDs44VUT99lycfQ+AeTQUY4+xzNK8Q0GpHLf+a91Ws46WwdG7TKXsQj2?=
 =?us-ascii?Q?jw1dYkv4ICkMPVgsvgICMwsXJg5ofPM/tu7X5AH15B3PpLGVJnFourTty5Kj?=
 =?us-ascii?Q?o5DedO2cgAHNzH1nxS5sAcCFPbrvklv9EuRHYJ3z1dEaC7WSVcUk01DQdoZ+?=
 =?us-ascii?Q?T+pag+la16nK/466irYoNVzefC+KE+tNwO39PJuwB3xinnXxgRRK1jYY6/ia?=
 =?us-ascii?Q?bMwV/+4ch+noF42u4V5VOSzcgV/IyqCjvyPEZNb00CckXPNfPGIfpMdtpjnZ?=
 =?us-ascii?Q?6Raq12YrC86Nq0ije+yI6bdF6AZ//o4vEzbg2dNgcO2TkqH66okMEuKarLsZ?=
 =?us-ascii?Q?wjCEeUgKVTLr92fjylAcqHtH63MCfu4xfmGpHYmBRqbfRT6MlOZx1Gmvsc01?=
 =?us-ascii?Q?wm10YKknTytH0F0kC6IrRQZIq2WfeFpwfE6ex9XZO23xsierBmkJqsWZ02Ej?=
 =?us-ascii?Q?Zq8pu8QshynsDxX2ScLHXL94hP8bysmkm+Pf9U8lldSj6xDWoALbRkRkCsUf?=
 =?us-ascii?Q?NRZoQyeuzJKqoxda5buT4D44eg9X6Mx08/IS/phfELSAGEg9dyt1Vy5ulcEw?=
 =?us-ascii?Q?WeDLN9cpjNpV+SXVBvr40ZYMQBhSyu58rnVxX+fTWvR5ft02okOYLZxD9oGD?=
 =?us-ascii?Q?spj5Fxey7r7C6WUJKXnEYyHofUTwYbLSkymYqSAbAOhXlJHQSXJ6Nm7c9WFE?=
 =?us-ascii?Q?nzgtlWDM9cIkK9CgkQvLg3DyMjBjkgMMptXVSdlMg/e0CaOLc0TVZ7l8bpE0?=
 =?us-ascii?Q?UOPEew+0449UuWFojPl+9xjWLP1VPLOZgeSg?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(14060799003)(35042699022)(1800799024)(7416014)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2025 10:02:57.9511
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d278995-5888-4b56-9136-08ddf5083692
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB3PEPF0000885E.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AMDPR08MB11526

Hi,
> On Mon, Sep 15, 2025 at 09:35:55PM +0100, Will Deacon wrote:
> > On Mon, Sep 15, 2025 at 08:40:33PM +0100, Catalin Marinas wrote:
> > > On Mon, Sep 15, 2025 at 11:32:39AM +0100, Yeoreum Yun wrote:
> > > > So I think it would be better to keep the current LLSC implementation
> > > > in LSUI.
> > >
> > > I think the code would look simpler with LL/SC but you can give it a try
> > > and post the code sample here (not in a new series).
> >
> > If you stick the cas*t instruction in its own helper say, cmpxchg_user(),
> > then you can do all the shifting/masking in C and I don't reckon it's
> > that bad. It means we (a) get rid of exclusives, which is the whole
> > point of this and (b) don't have to mess around with PAN.
>
> We get rid of PAN toggling already since FEAT_LSUI introduces
> LDTXR/STTXR. But, I'm all for CAS if it doesn't look too bad. Easier
> I think if we do a get_user() of a u64 and combine it with the futex u32
> while taking care of CPU endianness. All in a loop. Hopefully the
> compiler is smart enough to reduce masking/or'ing to fewer instructions.
>

Sorry for my wrong previous email.

Here is what i intened with CAS operation:

diff --git a/arch/arm64/include/asm/futex.h b/arch/arm64/include/asm/futex.h
index 1d6d9f856ac5..0aeda7ced2c0 100644
--- a/arch/arm64/include/asm/futex.h
+++ b/arch/arm64/include/asm/futex.h
@@ -126,6 +126,60 @@ LSUI_FUTEX_ATOMIC_OP(or, ldtset, al)
 LSUI_FUTEX_ATOMIC_OP(andnot, ldtclr, al)
 LSUI_FUTEX_ATOMIC_OP(set, swpt, al)

+
+#define LSUI_CMPXCHG_HELPER(suffix, start_bit)                                 \
+static __always_inline int                                                     \
+__lsui_cmpxchg_helper_##suffix(u64 __user *uaddr, u32 oldval, u32 newval)      \
+{                                                                              \
+       int ret = 0;                                                            \
+       u64 oval, nval, tmp;                                                    \
+                                                                               \
+       asm volatile("//__lsui_cmpxchg_helper_" #suffix "\n"                    \
+       __LSUI_PREAMBLE                                                         \
+"      prfm    pstl1strm, %2\n"                                                \
+"1:    ldtr    %x1, %2\n"                                                      \
+"      mov     %x3, %x1\n"                                                     \
+"      bfi     %x1, %x5, #" #start_bit ", #32\n"                               \
+"      bfi     %x3, %x6, #" #start_bit ", #32\n"                               \
+"      mov     %x4, %x1\n"                                                     \
+"2:    caslt   %x1, %x3, %2\n"                                                 \
+"      sub     %x1, %x1, %x4\n"                                                \
+"      cbz     %x1, 3f\n"                                                      \
+"      mov     %w0, %w7\n"                                                     \
+"3:\n"                                                                         \
+"      dmb     ish\n"                                                          \
+"4:\n"                                                                         \
+       _ASM_EXTABLE_UACCESS_ERR(1b, 4b, %w0)                                   \
+       _ASM_EXTABLE_UACCESS_ERR(2b, 4b, %w0)                                   \
+       : "+r" (ret), "=&r" (oval), "+Q" (*uaddr), "=&r" (nval), "=&r" (tmp)    \
+       : "r" (oldval), "r" (newval), "Ir" (-EAGAIN)                            \
+       : "memory");                                                            \
+                                                                               \
+       return ret;                                                             \
+}
+
+LSUI_CMPXCHG_HELPER(lo, 0)
+LSUI_CMPXCHG_HELPER(hi, 32)
+
+static __always_inline int
+__lsui_cmpxchg_helper(u32 __user *uaddr, u32 oldval, u32 newval, u32 *oval)
+{
+       int ret;
+       unsigned long uaddr_al;
+
+       uaddr_al = ALIGN_DOWN((unsigned long)uaddr, sizeof(u64));
+
+       if (uaddr_al != (unsigned long)uaddr)
+               ret = __lsui_cmpxchg_helper_hi((u64 __user *)uaddr_al, oldval, newval);
+       else
+               ret = __lsui_cmpxchg_helper_lo((u64 __user *)uaddr_al, oldval, newval);
+
+       if (!ret)
+               *oval = oldval;
+
+       return ret;
+}
+
 static __always_inline int
 __lsui_futex_atomic_and(int oparg, u32 __user *uaddr, int *oval)
 {
@@ -135,71 +189,25 @@ __lsui_futex_atomic_and(int oparg, u32 __user *uaddr, int *oval)
 static __always_inline int
 __lsui_futex_atomic_eor(int oparg, u32 __user *uaddr, int *oval)
 {
-       unsigned int loops = FUTEX_MAX_LOOPS;
-       int ret, oldval, tmp;
+       int ret = -EAGAIN;
+       u32 oldval, newval;

        /*
         * there are no ldteor/stteor instructions...
         */
-       asm volatile("// __lsui_futex_atomic_eor\n"
-       __LSUI_PREAMBLE
-"      prfm    pstl1strm, %2\n"
-"1:    ldtxr   %w1, %2\n"
-"      eor     %w3, %w1, %w5\n"
-"2:    stltxr  %w0, %w3, %2\n"
-"      cbz     %w0, 3f\n"
-"      sub     %w4, %w4, %w0\n"
-"      cbnz    %w4, 1b\n"
-"      mov     %w0, %w6\n"
-"3:\n"
-"      dmb     ish\n"
-       _ASM_EXTABLE_UACCESS_ERR(1b, 3b, %w0)
-       _ASM_EXTABLE_UACCESS_ERR(2b, 3b, %w0)
-       : "=&r" (ret), "=&r" (oldval), "+Q" (*uaddr), "=&r" (tmp),
-         "+r" (loops)
-       : "r" (oparg), "Ir" (-EAGAIN)
-       : "memory");
+       unsafe_get_user(oldval, uaddr, err_fault);
+       newval = oldval ^ oparg;

-       if (!ret)
-               *oval = oldval;
+       ret = __lsui_cmpxchg_helper(uaddr, oldval, newval, oval);

+err_fault:
        return ret;
 }

 static __always_inline int
 __lsui_futex_cmpxchg(u32 __user *uaddr, u32 oldval, u32 newval, u32 *oval)
 {
-       int ret = 0;
-       unsigned int loops = FUTEX_MAX_LOOPS;
-       u32 val, tmp;
-
-       /*
-        * cas{al}t doesn't support word size...
-        */
-       asm volatile("//__lsui_futex_cmpxchg\n"
-       __LSUI_PREAMBLE
-"      prfm    pstl1strm, %2\n"
-"1:    ldtxr   %w1, %2\n"
-"      eor     %w3, %w1, %w5\n"
-"      cbnz    %w3, 4f\n"
-"2:    stltxr  %w3, %w6, %2\n"
-"      cbz     %w3, 3f\n"
-"      sub     %w4, %w4, %w3\n"
-"      cbnz    %w4, 1b\n"
-"      mov     %w0, %w7\n"
-"3:\n"
-"      dmb     ish\n"
-"4:\n"
-       _ASM_EXTABLE_UACCESS_ERR(1b, 4b, %w0)
-       _ASM_EXTABLE_UACCESS_ERR(2b, 4b, %w0)
-       : "+r" (ret), "=&r" (val), "+Q" (*uaddr), "=&r" (tmp), "+r" (loops)
-       : "r" (oldval), "r" (newval), "Ir" (-EAGAIN)
-       : "memory");
-
-       if (!ret)
-               *oval = oldval;
-
-       return ret;
+       return __lsui_cmpxchg_helper(uaddr, oldval, newval, oval);
 }

 #define __lsui_llsc_body(op, ...)                                      \
(END)

Am I missing something?

Thanks!

--
Sincerely,
Yeoreum Yun
