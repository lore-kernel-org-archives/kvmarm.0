Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010066.outbound.protection.outlook.com [52.101.84.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E51C84EC67F;
	Thu,  3 Sep 2026 16:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.66
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788453246; cv=fail; b=pZ6OJwdi47QQbvI3147yDGoKmXuMa+HigOQ/tR9Q78T8GqA9NZtCWauUeHFJU33HUbP+vj89z3a0AyG+2n6FhhKoEdNVDuW3aaKZJqJGbzjJ7n3eV2S7fNSG8dS2PmU3E5szXvQa+tCwKiwkppaEoBqeaPx9LtWfJ6AmdBIp8VM=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788453246; c=relaxed/simple;
	bh=ydcByWMXaVEL/knwWI1NM0vssK5qhr07IKrejbwLqEA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Vyv4HX7oJ+3vOBclUp4EBRN1wdYiFW/KBUNHepFA8SeTOSJUBf+74wYJg2w2ujYmCMFumFHA8MRSmvN8NucP5TeufUgg49tonwr8Tz5q6HJ2UH4UG+BZ2kS1VgyEgZYI3GxDfEGEpYgenKFbAs/69EtVD3rWF+QUA67B4himIVE=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=DaPTCDD1; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=DaPTCDD1; arc=fail smtp.client-ip=52.101.84.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="DaPTCDD1";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="DaPTCDD1"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=TwcF+K7TWpNAJHzUzsbKVPTdHRgVccHMYHtuX8Mv9NMT19HaXl1ET7DY2lhvf3Q7TRBtS47hbPz9m1dkbjOng6LIYHOMEZSlfIJzB8Xy1XGtTezf+FX/6qzIHHqej4b5bg9I/fIDjfENYW2CEbpL7bGHkLQ//PHwjE/F8D6Vy9cjwUAUeyvbBfDtyJJrcTfWmJuCw2Bqfq8eAsw4SIC69NYs2Krv6/7QREgKZlyWabFkwyEw+urH5VCtKyioOQAv7O9OEvJNdAAYAwEzgpdwAjkQxSdmXFyi3+iztNbEVGjjEeAi5+0hovnlvqyAqGA671uI7QsH6OyB0vpuFb3kFw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ydcByWMXaVEL/knwWI1NM0vssK5qhr07IKrejbwLqEA=;
 b=MD3QhYYV9hocyQ6+X6Zddh8n5Pb7Kq6rziJc/GMKrPEonf9fnHENVrqXb/edl5P0DUDPHKkF6PQwNIJtOSdG8KMMHSYxaHzpGJg/vEjkgxCuMRq7ObDVqG/18ezhYv6qZlv7ThlbUSqg6XFcc+1BR1fqhvqVnt26yRgX3Gd1R+lvzvgVn3624SGPrmIaVHAOoy3uV5he7T0I9YiLVI6UFTxlVpXlWYqcXrz7zFM/yEilUFIVBfnTsdy+Wzvs8ML9cULgBNurryhZCiRhvusJfmmjamYnabvOP2vZWIU3ZRe0MwtHpmFZYeW6iWUzoqX2dFXA9DhAgAZgDY+0GvegLw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ydcByWMXaVEL/knwWI1NM0vssK5qhr07IKrejbwLqEA=;
 b=DaPTCDD1AXyDIc6w1/u8Z+XQs4pnbtxmpURg9aVde+iCKn6unvATRIUbvyAGaEV8dDZQHUr33yQuwnyyBqmlvPtkyBOgOEn6/AiM9u3gaZQzp7y650fL1nWIYtqC0dm0eFCKh+2P6mjPY9i9W3L33o4MCz0uez5OE1Ao8vkNPeM=
Received: from AS4PR09CA0002.eurprd09.prod.outlook.com (2603:10a6:20b:5e0::9)
 by AMCPR08MB999912.eurprd08.prod.outlook.com (2603:10a6:20b:782::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Thu, 3 Sep
 2026 16:33:57 +0000
Received: from CPH1EPF0000051B.eurprd04.prod.outlook.com
 (2603:10a6:20b:5e0:cafe::98) by AS4PR09CA0002.outlook.office365.com
 (2603:10a6:20b:5e0::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.12 via Frontend Transport; Thu, 3
 Sep 2026 16:33:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 CPH1EPF0000051B.mail.protection.outlook.com (10.167.241.230) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.8
 via Frontend Transport; Thu, 3 Sep 2026 16:33:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vaRrBqPZU8WisqSEdgVGb4Zbq1kIVwCyWgjVHhkIc9O/L3l40W2zjCYgmkZFLT+Yimz7q18pK9WSPXitjzBjDaLj1NKSGXtQbZvDd/gBIJ8mYQcuaUWLs+KhiRK92UFIrZPDyQvxvKK4JTkqRl3dRvfLrOEAtypBWcN+8fO5y7xK+8och+cRXznlLY1ZxS7vSIW2o2gTOsF0dFPBU4ut9uWGTIN2BtFfMjpnny1UBbxcZoSqHluMPQGHSkuTwkUlaNsFqrwDDV2ZBTI5ooghSNGsHnIPKZkReALFaTJhXOTHIumiRZ0F+43DCrEyN9eD22uCjP0RQBdW8Zb5TBFdHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ydcByWMXaVEL/knwWI1NM0vssK5qhr07IKrejbwLqEA=;
 b=aSTQGSbIj4SixWpzqCj1EHtYDleA5g7K9/kHfuHdh0+p53KmxH2MAcrOV6MHf+zRQg7bJ1L7cy3bY1H3wVpIdXRzgT5ZNptpe/b8GUFTCxStUhxZ1d3bouU3MhpH40o1pEc4ubWAf88KvHOc+vTJt/fP8SnwuuiNeGnbtMdolvA5wIfdz58MGL7Ct6DJ50VQQXtBhhmxS1CkVp2UCM0KBRkg1DAijeFNh8YPwIgD3VyIKDJ87/civu2WozlQcgmf5zrTHe2oO4RzUPp3YQ0huePaJwPcZQsL0iy1FC4DkEcT1lFVPvKHviFUFYpy/hhbZmsNFf8MTuaOA7PrnIhz5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ydcByWMXaVEL/knwWI1NM0vssK5qhr07IKrejbwLqEA=;
 b=DaPTCDD1AXyDIc6w1/u8Z+XQs4pnbtxmpURg9aVde+iCKn6unvATRIUbvyAGaEV8dDZQHUr33yQuwnyyBqmlvPtkyBOgOEn6/AiM9u3gaZQzp7y650fL1nWIYtqC0dm0eFCKh+2P6mjPY9i9W3L33o4MCz0uez5OE1Ao8vkNPeM=
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com (2603:10a6:101:1d::23)
 by AMDPR08MB11409.eurprd08.prod.outlook.com (2603:10a6:20b:71c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Thu, 3 Sep
 2026 16:33:24 +0000
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e]) by PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e%4]) with mapi id 15.21.0382.007; Thu, 3 Sep 2026
 16:33:24 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>
CC: "maz@kernel.org" <maz@kernel.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"oupton@kernel.org" <oupton@kernel.org>, nd <nd@arm.com>
Subject: Re: [PATCH v5 06/49] arm64/sysreg: Update ICC_CR0_EL1 with LINK and
 LINK_IDLE fields
Thread-Topic: [PATCH v5 06/49] arm64/sysreg: Update ICC_CR0_EL1 with LINK and
 LINK_IDLE fields
Thread-Index: AQHdJl4T1Lfjl0jqBESpkNM6iSoXnraSgJEAgCq2koA=
Date: Thu, 3 Sep 2026 16:33:23 +0000
Message-ID: <8dfe376bc9ef7b4a370ae92f020805b8af55604a.camel@arm.com>
References: <20260807111159.429128-1-sascha.bischoff@arm.com>
	 <20260807111159.429128-7-sascha.bischoff@arm.com>
	 <20260807121703.D4B7A1F00A3A@smtp.kernel.org>
In-Reply-To: <20260807121703.D4B7A1F00A3A@smtp.kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	PR2PR08MB4889:EE_|AMDPR08MB11409:EE_|CPH1EPF0000051B:EE_|AMCPR08MB999912:EE_
X-MS-Office365-Filtering-Correlation-Id: aa2e730f-53ed-4a3c-71a6-08df09d926df
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|23010399003|366016|10067099003|56012099006|11063799006|4143699003|6133799003|10063799003|3023799007|18002099003|22082099003|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 RfHQWI2BdPdinuPcl0q0TZg+Qbr21gGECp+o4VhKIQHMapo9h27zrlVj2AAEbatSMMyViQLPpvcmcrzhg/gBsm46bQlSxQjdRai9jzYd/deyM56JExSuF6PHk9I4sgzUtnjq4bBuZYpSNN45gzzcejAbMjft9LdOmuhaeBmtJ28zhThILfpvVQ1U4/Zn9+XHZ/0BQhAlF3QqOEa4qpP0rH13SY/wp9XL3g2xO1aYQf9n9B4HV2RMwRxw3U8DKx6sH9jP+Y5X2bqc7pYygc1Vz/WbdwljBVNp8kUgKwtXwjW0YXNCDbd0WXxkGO7dE7L8m2/M4PolL+2gzZNoEhF7NUxJVtqSyNEVaAkdCCGZ60yryyGhD+xQ5F9HDAwHjkEvpSV5LCcLvBCWgSPD5mL/8fqF5VPZb/mecTRahaUjGBtK/wwYqJYUiCpRgqc8U8NVTaYih2k1wyXnO4g5BaLBQTtbfCip/ywwHhI0JZuaxi2pMkPjFzM2v82mgiHrLd6MotAcyoi9Dafjbg2uynWSPas18GPRAc937ZdbkxB5PkbRdNJ2l3sqca+XOnBp/DRiuILxU7ew/sEct2I/lqpB7K2fhvWBmMp+28ZyDOVoXYPFcLhOOsozX9igrJ6CViNcDGThDMPRYwrEPZVKuh2B+5dyM4gSBDbS8yd90vzOC1hAVr4SsU/K6tG3nGziXxg4N9dbyHl8oJa1PFs+dHrNzR6neR2UBJGNYWlNR6XInKc=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR2PR08MB4889.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(23010399003)(366016)(10067099003)(56012099006)(11063799006)(4143699003)(6133799003)(10063799003)(3023799007)(18002099003)(22082099003)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <3E92E0C4EF52554D9622464CD4E76CA6@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 V/AwyzU742/wY5yFcv6zcDBWRrVJWaPAcmdbRjQfzGyvOKA1BMpMfChDjmd2ZiYBuzlsp6Q4RDCXq5/b3RXnKd3pQ6VPPmUZCOwN6A068rI5CQ9ouqUv6KqhHgZ3x5kvwGOiDrqDIl8I5qLaYilPAmo3mJc4UaxxAHOgUDqPQp8xU+0LGs/QdDOZYXRknJNg+qx5NULUCSOWyAiYJx2Z2cdI9Bzt7C/nfV1Z1Ov4d98P4O4f76JkZNCdwEbYX+eOuuxGCrs3fMJg++zkSH6RGqU9nSjdANkWhUeLkYpgewaIn6/z1sDcX2/KzfDdY3W0ChErDv4YRBMztF5UAhi2HQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AMDPR08MB11409
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 CPH1EPF0000051B.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	85d07875-4728-43bc-5f48-08df09d912f4
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|82310400026|14060799003|1800799024|35042699022|23010399003|376014|10063799003|18002099003|10067099003|3023799007|6133799003|22082099003|11063799006|4143699003|56012099006;
X-Microsoft-Antispam-Message-Info:
	AsJqAVkzV5ibQQtoxp2k9Eh6Nl4HNlw9bE9KoACiqXwzjMZVfwBL3ygxwhI1WeMQVGb0/YvPo2wIIdzFRu7/nx8jcBome2wc/4zBX0lDuv6pNVvaMRhPMDfwSsbZl0LipjPVSB0S00kPT0/B0F5Wlj81dfQF2U/NRbHDot7Mn5PlkRQ4XYsVb1VaMjr45TQc7ud3OIh9/6e0NmUxJwmPJ0DAPxFXCtEkt4ZiOeLN96bRZY4BG7caJySWu/NR2M/y8ErENWByYnm1/ShbuYVFZK/MN8+MxbbzY3rFMXHMhzURixhiBbVohcDgyq7Otq94ks4b+i0Lvt3Rw9uRQyO7nmgfPWkFECWIrcOgUyDDRnldjS1sQASnqPX69PRqaNsIlKFNv3aTEgFztctU0k5g+ZeypBix1MuDmgAHiJFKl/JAEq4PmcvFYGqi9nawxbSVsORZJbBs+FpM0yIECyrsY4gZSVQX/D9LsFywyVcI9fCZFJjrdzBUnnFeIk4HMqYRl/vFu1ipPL7wd0BGm5CdNRnw9DLu9xgMGJkS2GK3N1uIXCMPygcnPOWZH/tptlAjwjCgN3voNXCFeFCGwRLCsjvtY/CS+UXVl6dS5lM5Ig2sEvJppRJejzrBOtQu0vsRitMcGGSAnOMEv9RvrGSCCD0NIKXn++JaIhSUlSGHciU=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(82310400026)(14060799003)(1800799024)(35042699022)(23010399003)(376014)(10063799003)(18002099003)(10067099003)(3023799007)(6133799003)(22082099003)(11063799006)(4143699003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	LqcKoRlTbITtSnuJVleVI3uj6MDLbBIzrvwdMerq0FHyVwpta3vYKY/WKcVTdGSZLgcpTxvK2gfflfZ/w25kfQdkCZkYb87gmG0kQ9ly9CLNueH3I3NE/DA74auT8osNgHGx5vOkA+LmQ0XVwT0+ERp2vRco8OkMRnzWKNS9ds04tmg/QYpOdqXdKf0bb4jZOVSyFqesQ+8fS+JpRwKtShBsCSIdFjlzk6Lp83rVM/Ha25QhSAyULnbVj9enuTiyGxS/HEan3NM1d3oS46r4lIIA3KFF7Z4dT9rGhiW1QsL9lWAI0fy6n1B3TMAGZiD+jxEZoJWnHQdNKSMU0PfKxcO2kR0XpN9LKDSLdUEJ2MMuj/1k6p/qLOiCLl7UrlmyGD+fQzrXrtor2/b0XknMLK1xDy+hZsyZP3+YFBDw4ccgScVTzKwPpqM7whtCPSpL
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2026 16:33:57.3028
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: aa2e730f-53ed-4a3c-71a6-08df09d926df
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CPH1EPF0000051B.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AMCPR08MB999912

T24gRnJpLCAyMDI2LTA4LTA3IGF0IDEyOjE3ICswMDAwLCBzYXNoaWtvLWJvdEBrZXJuZWwub3Jn
IHdyb3RlOg0KPiBUaGFuayB5b3UgZm9yIHlvdXIgY29udHJpYnV0aW9uISBTYXNoaWtvIEFJIHJl
dmlldyBmb3VuZCAzIHBvdGVudGlhbA0KPiBpc3N1ZShzKSB0byBjb25zaWRlcjoNCj4gDQo+IFBy
ZS1leGlzdGluZyBpc3N1ZXM6DQo+IC0gW0hpZ2hdIE1pc3NpbmcgQ29udGV4dCBTeW5jaHJvbml6
YXRpb24gRXZlbnQgKElTQikgYWZ0ZXIgY29udHJvbC0NCj4gcGxhbmUgc3lzdGVtIHJlZ2lzdGVy
IHdyaXRlcy4NCj4gLSBbSGlnaF0gQ09OU1RSQUlORUQgVU5QUkVESUNUQUJMRSBpbnN0cnVjdGlv
biBlbmNvZGluZyB3aGVuIGVtaXR0aW5nDQo+IHN5c3RlbSBpbnN0cnVjdGlvbnMgdGhhdCBzdHJ1
Y3R1cmFsbHkgZGVtYW5kIGEgc3BlY2lmaWMgZml4ZWQNCj4gcmVnaXN0ZXIgKGUuZy4sIGBDREVP
SWApLg0KPiAtIFtNZWRpdW1dIFBvdGVudGlhbCBjbG9iYmVyaW5nIG9mIG5ld2x5IGRlZmluZWQg
YExJTktgIGFuZA0KPiBgTElOS19JRExFYCBmaWVsZHMgaW4gYElDQ19DUjBfRUwxYCBkdWUgdG8g
YWJzb2x1dGUgd3JpdGVzLg0KPiAtLQ0KPiANCj4gLS0tIFBhdGNoIFs2XTogW1BBVENIIHY1IDA2
LzQ5XSBhcm02NC9zeXNyZWc6IFVwZGF0ZSBJQ0NfQ1IwX0VMMSB3aXRoDQo+IExJTksgYW5kIExJ
TktfSURMRSBmaWVsZHMgLS0tDQo+IGNvbW1pdCAwODU1YzQxZWE1NWI3ZDQ4MzEyOWRjMWQxODFl
MGMzNmMwMGI2NWU0DQo+IEF1dGhvcjogU2FzY2hhIEJpc2Nob2ZmIDxTYXNjaGEuQmlzY2hvZmZA
YXJtLmNvbT4NCj4gDQo+IGFybTY0L3N5c3JlZzogVXBkYXRlIElDQ19DUjBfRUwxIHdpdGggTElO
SyBhbmQgTElOS19JRExFIGZpZWxkcw0KPiDCoMKgwqAgDQo+IFRoaXMgY29tbWl0IGFkZHMgdGhl
IExJTksgYW5kIExJTktfSURMRSBmaWVsZHMgdG8gdGhlIElDQ19DUjBfRUwxDQo+IHN5c3JlZw0K
PiBkZWZpbml0aW9uLiBUaGVzZSBmaWVsZHMgd2VyZSBtaXNzaW5nIHNpbmNlIHRoZSByZWdpc3Rl
ciB3YXMgYWRkZWQgdG8NCj4gdGhlDQo+IGdlbmVyYXRvci4NCj4gDQo+ID4gZGlmZiAtLWdpdCBh
L2FyY2gvYXJtNjQvdG9vbHMvc3lzcmVnIGIvYXJjaC9hcm02NC90b29scy9zeXNyZWcNCj4gPiBp
bmRleCBlMDcwYWRhMDYxOTZmLi5lZDU5MzMwYmE1MWMwIDEwMDY0NA0KPiA+IC0tLSBhL2FyY2gv
YXJtNjQvdG9vbHMvc3lzcmVnDQo+ID4gKysrIGIvYXJjaC9hcm02NC90b29scy9zeXNyZWcNCj4g
PiBAQCAtMzczNyw3ICszNzM3LDkgQEANCj4gPiBTeXNyZWcJSUNDX0NSMF9FTDEJMwkxCTEyCTAJ
MQ0KPiA+IMKgUmVzMAk2MzozOQ0KPiA+IMKgRmllbGQJMzgJUElEDQo+ID4gwqBGaWVsZAkzNzoz
MglJUFBUDQo+ID4gLVJlczAJMzE6MQ0KPiA+ICtSZXMwCTMxOjMNCj4gPiArRmllbGQJMglMSU5L
X0lETEUNCj4gPiArRmllbGQJMQlMSU5LDQo+IA0KPiBbU2V2ZXJpdHk6IE1lZGl1bV0NCj4gVGhp
cyBpc24ndCBhIGJ1ZyBpbnRyb2R1Y2VkIGJ5IHRoaXMgcGF0Y2gsIGJ1dCBkb2VzIHRoZQ0KPiBp
bml0aWFsaXphdGlvbg0KPiBjb2RlIGhhbmRsZSB0aGVzZSBuZXcgZmllbGRzIGNvcnJlY3RseT8N
Cj4gDQo+IElmIExJTksgYW5kIExJTktfSURMRSBhcmUgZXhwZWN0ZWQgdG8gcmV0YWluIGZpcm13
YXJlLWNvbmZpZ3VyZWQgb3INCj4gZGVmYXVsdA0KPiByZXNldCB2YWx1ZXMsIHVzaW5nIGFuIGFi
c29sdXRlIHdyaXRlIHRvIGluaXRpYWxpemUgb25seSB0aGUgRU4gYml0DQo+IHdpbGwgY2xlYXIN
Cj4gdGhlbSB0byB6ZXJvLCBwb3RlbnRpYWxseSBicmVha2luZyBoYXJkd2FyZSBmdW5jdGlvbmFs
aXR5Lg0KPiANCj4gRm9yIGluc3RhbmNlLCB0aGlzIHBhdHRlcm4gaXMgc2VlbiBpbiBkcml2ZXJz
L2lycWNoaXAvaXJxLWdpYy12NS5jIGluDQo+IGdpY3Y1X2NwdV9lbmFibGVfaW50ZXJydXB0cygp
Og0KPiANCj4gCWNyMCA9IEZJRUxEX1BSRVAoSUNDX0NSMF9FTDFfRU4sIDEpOw0KPiAJd3JpdGVf
c3lzcmVnX3MoY3IwLCBTWVNfSUNDX0NSMF9FTDEpOw0KPiANCj4gQSBzaW1pbGFyIGFic29sdXRl
IHdyaXRlIGNsZWFyaW5nIHRoZSBuZXdseSBkZWZpbmVkIGJpdHMgaXMgYWxzbw0KPiBwcmVzZW50
IGluDQo+IHRvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2t2bS9pbmNsdWRlL2FybTY0L2dpY192NS5o
Lg0KPiANCj4gQ291bGQgeW91IGNvbmZpcm0gaWYgdGhlIGNvbnN1bWVycyBhcmUgcm9idXN0IHRv
IHRoaXMgY2hhbmdlPw0KDQpSaWdodCBub3csIHRoZSBMaW51eCBob3N0IGRyaXZlciBpbXBsZW1l
bnRhdGlvbiBzb21ld2hhdCBhc3N1bWVzIHRoYXQNCkVMMyBpcyBwcmVzZW50LiBJZiBFTDMgaXMg
cHJlc2VudCwgdGhlc2UgZmllbGRzIGFyZSBSTyBhcyBpdCBpcyBFTDMncw0KcmVzcG9uc2liaWxp
dHkgdG8gbWFuYWdlIHRoZSBsaW5rIHN0YXRlLiBJbiB0aGlzIGNhc2UsIG5vdCBkb2luZyBhDQpy
ZWFkLW1vZGlmeS13cml0ZSB3b24ndCBicmVhayBhbnl0aGluZy4NCg0KSWYgRUwzIGlzIG5vdCBw
cmVzZW50LCBOUyBzb2Z0d2FyZSBtdXN0IGVzdGFibGlzaCB0aGlzIGxpbmsgKGlmIG5vdA0KZXN0
YWJsaXNoZWQpIGFuZCBrZWVwIGl0IGFjdGl2ZS4gSG93ZXZlciwgaW4gdGhpcyBjYXNlIHRoZSBJ
V0IgYWxzbw0KYnJlYWtzIGFzIHRoZSBNb3N0IFBlcm1pc3NpdmUgU2VjdXJpdHkgU3RhdGUgbXVz
dCBlbmFibGUgYW5kIGNvbmZpZ3VyZQ0KaXQuIElmIEVMMyBkb2Vzbid0IGV4aXN0LCB0aGVuIHdl
IGhhdmUgYSBzaW5nbGUgd29ybGQgYW5kIGhlbmNlIHRoaXMNCmJlY29tZXMgTlMncyByZXNwb25z
aWJpbGl0eSB0b28uIEluIHRoZSBjdXJyZW50IGltcGxlbWVudGF0aW9uLCB0aGlzDQp3b3VsZCBi
cmVhayB0b28uDQoNCkFsdGhvdWdoIHRoaXMgaXMgdW5saWtlbHkgdG8gYmUgYW4gaXNzdWUgYW55
dGltZSBzb29uLCBJJ2xsIHBvc3QgYQ0Kc2VwYXJhdGUgZml4IGZvciB0aGUgSUNDX0NSMF9FTDEg
Y2hhbmdlLg0KDQo+IA0KPiBbU2V2ZXJpdHk6IEhpZ2hdDQo+IFRoaXMgaXMgYSBwcmUtZXhpc3Rp
bmcgaXNzdWUsIGJ1dCBJIG5vdGljZWQgYSBtaXNzaW5nIGNvbnRleHQNCj4gc3luY2hyb25pemF0
aW9uDQo+IGV2ZW50IGFmdGVyIGNvbnRyb2wtcGxhbmUgc3lzdGVtIHJlZ2lzdGVyIHdyaXRlcyBp
biB0aGUgR0lDdjUgZHJpdmVyLg0KPiANCj4gRXhlY3V0aW5nIGluc3RydWN0aW9ucyBpbiBhbiBh
cmNoaXRlY3R1cmFsbHkgdW5kZWZpbmVkIHBpcGVsaW5lIHN0YXRlDQo+IGNhbiByZXN1bHQNCj4g
aW4gdW5leHBlY3RlZCBleGNlcHRpb25zLCBjb3JydXB0ZWQgYWNjZXNzZXMsIG9yIGRyb3BwZWQg
aW50ZXJydXB0cy4NCj4gDQo+IE11bHRpcGxlIGZ1bmN0aW9ucyBiYXRjaCB3cml0ZXMgdG8gSUND
XypfRUwxIHJlZ2lzdGVycyBvciByZXR1cm4NCj4gaW1tZWRpYXRlbHkNCj4gYWZ0ZXIgYSB3cml0
ZSB3aXRob3V0IGlzc3VpbmcgYW4gaXNiKCkuDQo+IA0KPiBGb3IgZXhhbXBsZSwgaW4gZHJpdmVy
cy9pcnFjaGlwL2lycS1naWMtDQo+IHY1LmM6Z2ljdjVfY3B1X2Rpc2FibGVfaW50ZXJydXB0cygp
Og0KPiANCj4gCWNyMCA9IEZJRUxEX1BSRVAoSUNDX0NSMF9FTDFfRU4sIDApOw0KPiAJd3JpdGVf
c3lzcmVnX3MoY3IwLCBTWVNfSUNDX0NSMF9FTDEpOw0KPiB9DQo+IA0KPiBBIHNpbWlsYXIgcGF0
dGVybiBiYXRjaGVzIGNvbnNlY3V0aXZlIHdyaXRlcyBpbg0KPiBnaWN2NV9jcHVfZW5hYmxlX2lu
dGVycnVwdHMoKToNCj4gDQo+IAl3cml0ZV9zeXNyZWdfcygwLCBTWVNfSUNDX1BQSV9FTkFCTEVS
MF9FTDEpOw0KPiAJd3JpdGVfc3lzcmVnX3MoMCwgU1lTX0lDQ19QUElfRU5BQkxFUjFfRUwxKTsN
Cj4gDQo+IEFyZSB0aGVzZSB3cml0ZXMgc3VwcG9zZWQgdG8gaGF2ZSBhbiBpc2IoKSBhcyB0aGUg
dmVyeSBuZXh0DQo+IGluc3RydWN0aW9uIHRvDQo+IHN5bmNocm9uaXplIHRoZSBwaXBlbGluZT8N
Cg0KTm8uIFdlIGRvbid0IG5lZWQgYW4gSVNCIGFmdGVyIGV2ZXJ5IHN5c3RlbSByZWdpc3RlciB3
cml0ZS4gVGhpcyBpcw0KcmVxdWlyZWQgaW4gY29tZSBjaXJjdW1zdGFuY2VzIGFuZCBub3Qgb3Ro
ZXJzLCBhbmQgcHV0dGluZyB0aGVtDQpldmVyeXdoZXJlIHdvdWxkIGJlIGV4Y2Vzc2l2ZS4NCg0K
PiANCj4gW1NldmVyaXR5OiBIaWdoXQ0KPiBUaGlzIGlzIGEgcHJlLWV4aXN0aW5nIGlzc3VlLCBi
dXQgaXMgdGhlcmUgYSByaXNrIG9mIGNvbnN0cmFpbmVkDQo+IHVucHJlZGljdGFibGUNCj4gaW5z
dHJ1Y3Rpb24gZW5jb2Rpbmcgd2hlbiBlbWl0dGluZyBzeXN0ZW0gaW5zdHJ1Y3Rpb25zIGxpa2Ug
Q0RFT0k/DQo+IA0KPiBUaGUgd3JpdGVfc3lzcmVnX3MgbWFjcm8gcmVsaWVzIG9uIHRoZSBjb21w
aWxlcidzICJyWiIgY29uc3RyYWludCBmb3INCj4gcmVnaXN0ZXINCj4gYWxsb2NhdGlvbi4NCj4g
DQo+IFN5c3RlbSBpbnN0cnVjdGlvbnMgbGlrZSBHSUMgQ0RFT0kgYXJjaGl0ZWN0dXJhbGx5IG1h
bmRhdGUgdGhlIHVzZSBvZg0KPiBYWlINCj4gKHJlZ2lzdGVyIDMxKS4gQWxsb3dpbmcgdGhlIGNv
bXBpbGVyIHRvIHNlbGVjdCBhbiBhcmJpdHJhcnkgZ2VuZXJhbC0NCj4gcHVycG9zZQ0KPiByZWdp
c3RlciBjb250YWluaW5nIHplcm8gbWlzZW5jb2RlcyB0aGUgaW5zdHJ1Y3Rpb24uDQo+IA0KPiBU
aGlzIG9jY3VycyBpbiB0b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9rdm0vaW5jbHVkZS9hcm02NC9n
aWNfdjUuaDoNCj4gDQo+IAkjZGVmaW5lIGdpY19pbnNuKHYsIGluc24pCXdyaXRlX3N5c3JlZ19z
KHYsDQo+IEdJQ1Y1X09QX0dJQ18jI2luc24pDQo+IA0KPiBhbmQgaXMgdXNlZCBpbiBkcml2ZXJz
L2lycWNoaXAvaXJxLWdpYy12NS5jOmdpY3Y1X2hhbmRsZV9pcnEoKToNCj4gDQo+IAlnaWNfaW5z
bigwLCBDREVPSSk7DQo+IA0KPiBTaG91bGQgdGhpcyBiZSBoYXJkY29kZWQgdG8gdXNlIFhaUiB0
byBwcmV2ZW50IHRoZSBoYXJkd2FyZSBmcm9tDQo+IHRyZWF0aW5nIGl0DQo+IGFzIGNvbnN0cmFp
bmVkIHVucHJlZGljdGFibGU/DQoNCklmIHlvdSBsb29rIGF0IHRoZSBkZWZpbml0aW9uIG9mIHdy
aXRlX3N5c3JlZ19zKCksIHRoZW4geW91J2Qgc2VlIHRoYXQNCml0IGV4cGxpY2l0bHkgdXNlcyBY
WlIgaWYgYSB2YWx1ZSBvZiAwIGlzIHdyaXR0ZW4uIFRoaXMgaXMgbm90IGFuIGlzc3VlDQphbnlt
b3JlLg0KDQo+IA0KPiA+IMKgRmllbGQJMAlFTg0KPiA+IMKgRW5kU3lzcmVnDQo+IA0KDQpUaGFu
a3MsDQpTYXNjaGENCg==
