Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010037.outbound.protection.outlook.com [52.101.84.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E517439F75;
	Fri,  4 Sep 2026 10:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.37
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788516449; cv=fail; b=peE9JCnux+MLEv/B6UTFNRqIFkCWFr60KljIasfjj/9PxUPlAOCDFzME/B57ZVkILG7UZ9SwlGglo3Pu94eqRGmhlO0NUld/selPxVqVC9iYDq2m7L0VjnI0wAgb3Mj1Hp3QahJadanrCsKfDPeuVrn0qMb3F4DYmrs+TcRQghU=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788516449; c=relaxed/simple;
	bh=NNBcA4CY+vG0+G+/3GwksSmQIVRuE4OH4M4dtdS5928=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=nd9J1eEQnTKU6W0qvbKcgPoL7/QWhUnhNCe4sTraSQ2OL+/7VTTP3kFu5saYZwyoJsGUM7MksXH4zb5TbiM43yPRIrRcb50FC95pMDjTLshP9pwU3JgnDrPTW5qi3Trn1r1sWEVU4pgMRm0MTOwC6xWRcp8b1wB0SWLeLjTjfy8=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=HtiNQS7p; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=HtiNQS7p; arc=fail smtp.client-ip=52.101.84.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="HtiNQS7p";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="HtiNQS7p"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=w10nuj2QLnBoPXLjzbMWU6JPZyQvTX21/beXGMACFzeGOPfFu9G+NglrDPEBMQU7fqpOWczdncLjdZCP9dLVb53lqWKRN/+CyNgDnGXGPdzBr423TiYlzv2xoAJ7DoD+EtfZ2DAGEuwYQaWm3yzjLWx/qR8NDMKLDzwOGF26j1GK+BeQbqeLD20rN443t/ElqxY5MkQrK1KbyWB4pXMaeqmO4echnnDJzdWUYpNKCcTHOZp78wh6wfwuC/PlbrmUQk3xP5VHjddgHPvoJNmxCLNed0JhtFDcjltgrbv1hL4Mnub+T2JDblPKTZzr/VgPrq+IfwJDK6WuAmwQI5tZPw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NNBcA4CY+vG0+G+/3GwksSmQIVRuE4OH4M4dtdS5928=;
 b=TCcp+XTyHicUVRZ0b7U1Cyg/YOGY9gfxZgrvLBeSCPUCKN9yXumnckPX1ySdEw8uQTycxN3lSLyWUHwZ6a9sgAG68gBqFbV9LWV/STIc6xo/ZTknwlQal+evYiptJWx8PNpU7I9L0cbWipFjExZXygHPBg2GrCPnWSwbu9i2cgcjYkU41GCr79O9qGO77+fgarWAiSmpQWAKtzKTtsCrLsCviB9h1x/i4S2QRedexwj0/e2QIo6OAf58fsUEf+5Pq7RR6L6gyAgmk9SHnm9d7dUZBHFPwDChfM1ZMtH4RS8xikV86fh3WbpMKNeQZ1QCB3xou3iVBsdIE8sPMwqaOQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NNBcA4CY+vG0+G+/3GwksSmQIVRuE4OH4M4dtdS5928=;
 b=HtiNQS7poVEyPKKj6qxw6fRd1HYK6bTlsWOMGWzotFnbtb9IInbpqtlEN3Pf/WQLCjMovWwPdjjrelTD55xXj/0N1qTOLkDIRFprxY7Hn+pnyQ4SvFWYNjHkQ/zHRz7LP1uSOL/aB9ljgql5FmKRlrPjPIyPhJMUYeXL61/wAb0=
Received: from AS4PR10CA0004.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:5dc::8)
 by GV2PR08MB10383.eurprd08.prod.outlook.com (2603:10a6:150:b0::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 10:07:21 +0000
Received: from DB5PEPF00014B92.eurprd02.prod.outlook.com
 (2603:10a6:20b:5dc:cafe::30) by AS4PR10CA0004.outlook.office365.com
 (2603:10a6:20b:5dc::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.12 via Frontend Transport; Fri, 4
 Sep 2026 10:07:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB5PEPF00014B92.mail.protection.outlook.com (10.167.8.230) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.8
 via Frontend Transport; Fri, 4 Sep 2026 10:07:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qQqlOweQPLDNAe/pvMS/Q5ymgHrJUmD0VHkXuN33uEoO64czM5Z4WWRDngDXrA1lYySeDUOnMdqWo7tpG5AHfJN/PwXMgI+ORJMIjIQ+o73KxyWXFhFzQSLrbulpLwfNJckGny2ZsgXGwk9N1NWOhBz2DAsKsWZkwLwd581jLHgBfzucRYdwxVFMku7SlBownJ+kmzIDnYCPuGhV6k6HQ8Hn2TkEDrqyzrJZyyqe2W5uObXTISpHfXzEyjInQKRxL7o7EJKdB8yJObRnNmRLPtIftKitQSs81fvBE7yOtol8ay9Eh0kB7+6Xm+pkydwgtb7vi0DSr+Bq8mS3hbLKcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NNBcA4CY+vG0+G+/3GwksSmQIVRuE4OH4M4dtdS5928=;
 b=sVQbiywZm+a4SBluDB1u8jlyK5VLlurVWZgdUmI72pU3aGvvRJJHo6Hz26X77jWt6poTiwj4dCAVJzpQatwxZA0Wnnw+ZBVYpsccBWctieHjm3tu0Fy8v7/8IMe5iFuKY792wPzaWr900KeUZRHPci8YT89XxZLXJLUJVOtYG/T5S2qys7nZ/xxSdyJ3K9+bLGQ41myViV9bMS6klk0RzoaRCG/bVqFfcYwaqhsnzgDaXFZTOhhRY6Dvsp6gNP7xLH8zFJYMUM2cjOlgoS/v2SYV4nREhTlcNBTZJsIVTSNDXIChKkwhgK2h2PQbWN0m0QgI7WLJoLnAPnnDR6Cq+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NNBcA4CY+vG0+G+/3GwksSmQIVRuE4OH4M4dtdS5928=;
 b=HtiNQS7poVEyPKKj6qxw6fRd1HYK6bTlsWOMGWzotFnbtb9IInbpqtlEN3Pf/WQLCjMovWwPdjjrelTD55xXj/0N1qTOLkDIRFprxY7Hn+pnyQ4SvFWYNjHkQ/zHRz7LP1uSOL/aB9ljgql5FmKRlrPjPIyPhJMUYeXL61/wAb0=
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com (2603:10a6:101:1d::23)
 by DBBPR08MB10794.eurprd08.prod.outlook.com (2603:10a6:10:53d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 10:06:38 +0000
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e]) by PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e%4]) with mapi id 15.21.0382.007; Fri, 4 Sep 2026
 10:06:38 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>
CC: "maz@kernel.org" <maz@kernel.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"oupton@kernel.org" <oupton@kernel.org>, nd <nd@arm.com>
Subject: Re: [PATCH v5 34/49] KVM: arm64: gic-v5: Add VGICv5 IST save/restore
 UAPI
Thread-Topic: [PATCH v5 34/49] KVM: arm64: gic-v5: Add VGICv5 IST save/restore
 UAPI
Thread-Index: AQHdJmAR/W/7R/IQfUK/DzVQvtdk1baSx2oAgCuV+QA=
Date: Fri, 4 Sep 2026 10:06:37 +0000
Message-ID: <310292e9e369baf399ee0afd98d803e3dc716399.camel@arm.com>
References: <20260807111159.429128-1-sascha.bischoff@arm.com>
	 <20260807111159.429128-35-sascha.bischoff@arm.com>
	 <20260807163041.2A3971F000E9@smtp.kernel.org>
In-Reply-To: <20260807163041.2A3971F000E9@smtp.kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	PR2PR08MB4889:EE_|DBBPR08MB10794:EE_|DB5PEPF00014B92:EE_|GV2PR08MB10383:EE_
X-MS-Office365-Filtering-Correlation-Id: 12631a68-951b-42fe-384d-08df0a6c4f06
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|23010399003|366016|22082099003|56012099006|10067099003|11063799006|4143699003|18002099003|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 xTlibcy24O1rNXHl8kwM1qjLoQ4wspP3Xfn2HPhIjzyLog48pai/2wUaHzlx6mrAwEyR3VtG1/mW1udZzxAzPa/bz6V2b3sxi9RAWMGIBbtoNLW6hvxVLyBLhbpFGFy1LR7S99tIBvecjaorlLBshJRi+ShidwYoiVmBnAi1SHZ21kEybJZaD7aJ0WREm9GqQP5CvKHkEQs3xTAKVZzXEVH1N0GYi2zl9tOGr1JC0d//FRqmEffWq+Bg+SxM0eev+Atg4aCwAY+lSMYvReR32PKVdxCzdYyJcMSjTKPfw35XMtNs1UA/KJGQzgnlhwQuGVMMPb2le27K9xFrcW5PCfZ+GnTbbl6kXdxLnE//oLskbOje8Zr+A9VAmhp4nDFuD1wvAQIfDWWfQRB2HlBmWZWN14sK7yvD/KZhhylY//0GKGHd3FpV3tzExHyW/4T60LGS7zSBWXrPC54n86/5WY/cEzbf4c1WEfYqeVoczlFAgMY4315erYc13dfoGFFCTBSMcSDjjZk4nzLJXUJMG0JjqsbuxH3XEo+orGJn33tZJclL/EBXFhgxAEzS/v7XwLl4O2mg8z3lhJoLy6iQDxaiw71cBn159Ig/7QIg9gC4BzXYU6m+Ue9PqXUli97PfsLe52AdJyNV32vC+4ic7ZpzgTXaAnGpUgzECF5oL1hBli6gfs7IcbLe4PGoGQEq87G/UzMGQ9Ddr+XK2Owea1y8w784xljEFOjurKNsNdw=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR2PR08MB4889.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(23010399003)(366016)(22082099003)(56012099006)(10067099003)(11063799006)(4143699003)(18002099003)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <E18DAFF71495144783CA5D0E1CAA72A1@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 jodkfr5p+1AiCY9WD87kHEsXpDjcjGKMDZlLbOkXFCsiqKpDuwx7GD2cTGts+Oesnw7DcZPNiJ7BET1I+VuYVFBdUYiDYX8K5J0uzIkuwXTgzaY3oZ8jBnkg5EVI7wHmE2BiWcYjzW4iUTP2olsVhXBQacJoxmpSS3MS3j7cqTJcy03CCpI27EsDcuuyHts06v0NkVJrTpdvHHlqbXpAoL3OaBfUbmQSuWTmEMahiIeB+D/immuSXJRgMG7MoifaLST8F82lhQwWHWO99bPbSuK9z3VJA6ZAQG2GzmJzpMlSi3eV0arEOcsfV+ZiCDrIEEOq1RVZEFoVM/1gtQk4rQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB10794
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB5PEPF00014B92.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	fb8f7ae7-5eb1-4d9a-cf15-08df0a6c358c
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|14060799003|1800799024|35042699022|23010399003|376014|18002099003|22082099003|56012099006|10067099003|4143699003|11063799006;
X-Microsoft-Antispam-Message-Info:
	Rs3Hic8bgVP5QdVBj+8mOF1myOFsl7Cxo8UuiArOIsncIrFXNZrc7Th/D5boH6b2MmN/rtJONQ5YaOfUIUdnNdaVPPPVGcIonNS6MHyhcsZ1X18I9pCmkb2DepALroJlPWGW4Z7lj0OjyMb1dgIc9GzPo38YbCNw+QxxOVVwzrsLw7nj1YmSq/ItNQDKQOs01Va37HqcLSxYla7fz+lGzDqckhI6iQkO8E52WOl2e3T7FH71CZCtx0p33RQixLayEgILsAJJ1Ad+iO6l14LoAFRw6FAwy1rmrwv3OQmEoKWDpJYMrp3HPo/2OKALyOg/oeUFm/ZYy4Xzb+3BdlB0lIYS4/8b1Yyxy+O7N4PDvt5/HrkV2GhPBC23OXZt6TDlxFR82V9UZ/qzW2IcuGxdyMhAsq3AZfzjcx+a9ERCUqicIBv5KKdjgFtYumCtrOMOvE7c5LOM+bvf+fsSk0JMePO5lDVmbUxt+yeKdtXTcWnIL6TP4bFIgYyFpjfhSiRrnUnaKj9Hl32m+cbKxX27ilTg3AbUs9ePIUUeOKh3l83cgQaQHDLOLKUoDBAd5hKz88MP2PrvbgNI5L4Mdwd/ff/4uCiK9leiCeo7IjyOGjxNIW9XSs7FDmGOBwqqOMaKRO3+1fwV1MOxau2r1XNKU1o64IUHutbMiwp+1HTiWi8=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(14060799003)(1800799024)(35042699022)(23010399003)(376014)(18002099003)(22082099003)(56012099006)(10067099003)(4143699003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	cUEHKZNklQQGPViocl6t00JfUbg+U4OLf5hQ6ewxseqqzvlRbudvJOwEl0ygf72xqLrPkfViSj2/rdUHjvukCT1jTHJCi06m1jWwqDb5vtWBg4uVOKbULbVN0z81YoE602Q4/nz8AzzMj3k2QIU7Pehb/3nGtQLTlyh1f1h9ENAdszOU4ENRdXdaVKtGOu4XeWa5mRCn56CTf4ZTv6gVoAOEQglvAHMr+lbzpjzl2w0rQna+2ZMuIEM4VvhS5Q4iQ37ZzQjafx2VlfrtF9mnnqPoCXfJzY68DL/39vOAzzA2WXEifQwj6TsDa9y6rgPJZPa+ZMdKyx/Gv690VJXe5mvZqd+prn43cWwHEc/nHVY8Thsy2crEQT73z72BpJl4Q2UQVNnF/OyW+FXaZbqheHiBoUv6Kp6Q1MKwUzYCLBYqVEwP5YClc0TfiWTUKQc1
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2026 10:07:20.7435
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 12631a68-951b-42fe-384d-08df0a6c4f06
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5PEPF00014B92.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR08MB10383

T24gRnJpLCAyMDI2LTA4LTA3IGF0IDE2OjMwICswMDAwLCBzYXNoaWtvLWJvdEBrZXJuZWwub3Jn
IHdyb3RlOg0KPiBUaGFuayB5b3UgZm9yIHlvdXIgY29udHJpYnV0aW9uISBTYXNoaWtvIEFJIHJl
dmlldyBmb3VuZCAxIHBvdGVudGlhbA0KPiBpc3N1ZShzKSB0byBjb25zaWRlcjoNCj4gLSBbTWVk
aXVtXSBJbmNvbXBsZXRlIGltcGxlbWVudGF0aW9uOiBVQVBJIGRlZmluaXRpb25zIGFkZGVkIHdp
dGhvdXQNCj4gY29ycmVzcG9uZGluZyBrZXJuZWwgYmFja2VuZA0KPiAtLQ0KPiANCj4gLS0tIFBh
dGNoIFszNF06IFtQQVRDSCB2NSAzNC80OV0gS1ZNOiBhcm02NDogZ2ljLXY1OiBBZGQgVkdJQ3Y1
IElTVA0KPiBzYXZlL3Jlc3RvcmUgVUFQSSAtLS0NCj4gY29tbWl0IGRiNGY2OWJmNDY3Mjk3MGM5
OTg5MWIxYzFiZDk2NTJjNGViZmI4OGENCj4gQXV0aG9yOiBTYXNjaGEgQmlzY2hvZmYgPFNhc2No
YS5CaXNjaG9mZkBhcm0uY29tPg0KPiANCj4gS1ZNOiBhcm02NDogZ2ljLXY1OiBBZGQgVkdJQ3Y1
IElTVCBzYXZlL3Jlc3RvcmUgVUFQSQ0KPiDCoMKgwqAgDQo+IFRoaXMgY29tbWl0IGludHJvZHVj
ZXMgS1ZNX0RFVl9BUk1fVkdJQ19HUlBfSVNUIGFzIGEgVkdJQ3Y1IGRldmljZQ0KPiBhdHRyaWJ1
dGUNCj4gZ3JvdXAgdG8gdHJhbnNmZXIgU1BJIGFuZCBMUEkgSVNUIHN0YXRlIGJldHdlZW4gS1ZN
IGFuZCB1c2Vyc3BhY2UuIEl0DQo+IGRlZmluZXMNCj4gc3RydWN0IGt2bV92Z2ljX3Y1X2lzdCBh
cyBhIGRlc2NyaXB0b3IgZm9yIHRoZSBJU1QgYnVmZmVycy4NCj4gDQo+ID4gZGlmZiAtLWdpdCBh
L2FyY2gvYXJtNjQvaW5jbHVkZS91YXBpL2FzbS9rdm0uaA0KPiA+IGIvYXJjaC9hcm02NC9pbmNs
dWRlL3VhcGkvYXNtL2t2bS5oDQo+ID4gaW5kZXggNzEwYTBkMjY3MzQ3ZC4uOTk5ODI1MmVhOGVj
OCAxMDA2NDQNCj4gPiAtLS0gYS9hcmNoL2FybTY0L2luY2x1ZGUvdWFwaS9hc20va3ZtLmgNCj4g
PiArKysgYi9hcmNoL2FybTY0L2luY2x1ZGUvdWFwaS9hc20va3ZtLmgNCj4gPiBAQCAtNDIzLDYg
KzQyMywxNSBAQCBlbnVtIHsNCj4gPiDCoCNkZWZpbmUgS1ZNX0RFVl9BUk1fVkdJQ19HUlBfSVRT
X1JFR1MgOA0KPiA+IMKgI2RlZmluZSBLVk1fREVWX0FSTV9WR0lDX0dSUF9NQUlOVF9JUlHCoCA5
DQo+ID4gwqAjZGVmaW5lIEtWTV9ERVZfQVJNX1ZHSUNfR1JQX0lSU19SRUdTCTEwDQo+ID4gKyNk
ZWZpbmUgS1ZNX0RFVl9BUk1fVkdJQ19HUlBfSVNUCTExDQo+ID4gKw0KPiA+ICtzdHJ1Y3Qga3Zt
X3ZnaWNfdjVfaXN0IHsNCj4gPiArCV9fdTY0CXNwaV9pc3RfYWRkcjsNCj4gPiArCV9fdTY0CXNw
aV9pc3Rfc2l6ZTsNCj4gPiArCV9fdTY0CWxwaV9pc3RfYWRkcjsNCj4gPiArCV9fdTY0CWxwaV9p
c3Rfc2l6ZTsNCj4gPiArfTsNCj4gDQo+IFtTZXZlcml0eTogTWVkaXVtXQ0KPiBBcmUgdGhlIGJh
Y2tlbmQgaW9jdGwgaGFuZGxlcnMgZm9yIHRoaXMgbmV3IFVBUEkgbWlzc2luZyBmcm9tIHRoaXMN
Cj4gcGF0Y2g/DQo+IA0KPiBUaGUgY29tbWl0IG1lc3NhZ2Ugbm90ZXMgdGhpcyBpcyB1c2VkIHRv
IHRyYW5zZmVyIHN0YXRlIGJldHdlZW4gS1ZNDQo+IGFuZA0KPiB1c2Vyc3BhY2UsIGJ1dCBpdCBs
b29rcyBsaWtlIG9ubHkgdGhlIGhlYWRlciBkZWZpbml0aW9ucyBhcmUgcHJlc2VudC4NCj4gDQo+
IFdpdGhvdXQgdGhlIGJhY2tlbmQgY29kZSwgdXNlcnNwYWNlIGF0dGVtcHRpbmcgdG8gdXNlDQo+
IEtWTV9ERVZfQVJNX1ZHSUNfR1JQX0lTVA0KPiB3aWxsIHJlY2VpdmUgYW4gZXJyb3IuDQo+IA0K
PiBbIC4uLiBdDQo+IA0KDQpUaGF0J3MgaW5kZWVkIGNvcnJlY3QuIFRoZXkgYXJlIGFkZGVkIGlu
IHN1YnNlcXVlbnQgY29tbWl0cywgc28gdGhpcyBpcw0KZmluZSBhbmQgYnkgZGVzaWduLg0KDQpU
aGFua3MsDQpTYXNjaGENCg==
