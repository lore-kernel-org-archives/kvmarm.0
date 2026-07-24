Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013042.outbound.protection.outlook.com [40.107.162.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67EA435DA78
	for <kvmarm@lists.linux.dev>; Fri, 24 Jul 2026 10:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.42
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784890420; cv=fail; b=JB/3syIsFatRYlVogSVaiQ/lrPy3LgGD0JPX2CnGRxa2nEW/BCSZEFGIl5AD3R5hrB0WB0FZYx8SMuYlklsPwpuph30kYpgk8aCXtGPGabAcJReHa5rU3YRAixSUxb47nvxsYCkCVWKs8hynXW6XA9pC0HJJFWkV3f6JGWikDSs=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784890420; c=relaxed/simple;
	bh=xAZE40RY1kWw5MhCWNDGI8KPXsQw+itpHSUkzvmdXLA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=mphkV2U/KcxoEJQaKdvsTeQPKveN2FSoydElC4YkvE8VFb8NPNpwuU4gE8aj/YG88iYwGmBG1O9QXC8cl0QI2i8p7aLTPLf1NVgeQoqL6nA0h5bZjNaf1B4GQgWD/6+I38R2tN0l7G9pa7WwTV9KuZRGfZcc5r4z2HZVpvK74ZA=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=dZZQ05jv; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=dZZQ05jv; arc=fail smtp.client-ip=40.107.162.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="dZZQ05jv";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="dZZQ05jv"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=JoJmp/M4YpCGmg/wjxNDxDigr7OdUxOxhLgVBbFmsKhX1LM43vc2sEqYaDIlbh2q1OZ4on6EsQ46aXGIu/mshple+0RPX6IhbepltrLjCoExquIHFhLwe4xjPifNI+dtLKDaLpI90rtVG1YTWw9m/Op+g3Z+bmZYEcy5qB9fMRg6txkb0iRN0huLbvSZXAPVDi36ctC2Pwg7jmUzSE9PIIVHrqaiGlz/TwZeOzdrAIpOBlqP/oQQcWpqQZGgCIPXAQOQp/uvc3uOno2eLDz5GEOSymhJkTatXdRWUH9IZ6OCROBzcZuwmnFwfUxQXu7k/VBnO5niCryKmTfoG2EPcw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RPxhunrJcN62o+nquqqFf8qB5miIlaAx89C20JPzrJ0=;
 b=IsgdpFgI3lSE3shHaJjn0DPJIFgQfIh/Y3dL/YOp/CVkx1Ltghs8qz31/OIMH7I3MQ91lvKg1w8fmVI6YAKusXZNCRelgvzUbCrlXPs8Gf/JAdy7qE2ULt5ux7i5U5UORmq6ehtBPvlE3Q1VD5UydSbgB2J08wjE8j+D5iGCfHKcSZVI8u5DAintJjLtxBoW6MdEOodVZfXCYR/xgp6jJVEw/RKYv2mAGdpPLa8IFGPhHb4yfCIDfR5BwkYf6FS6h1Csg1bGiYukFzl/qa1pCW4T/HzR6NAExFxVuRrguNqbk/RQ8gcSJX99qBeIcwmusanbn9gtf1kKVhXRuBAWFg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RPxhunrJcN62o+nquqqFf8qB5miIlaAx89C20JPzrJ0=;
 b=dZZQ05jv3YrSUEG8Nt8g5QqF9T+FiITeJtLe53MzpVrqmUDNNrGnO0BDInbHPP1o8BfbWJP0vqwMAyNR/HV4sMUh70EHJ0mmliC10Op1tQ0ctA4vuy7NjHKts2Md/IUJ5z+wJ03NVtiA3y8lh7pK6+S5NN/OLXAyhvHo1auEA54=
Received: from DUZP191CA0038.EURP191.PROD.OUTLOOK.COM (2603:10a6:10:4f8::22)
 by AM8PR08MB5699.eurprd08.prod.outlook.com (2603:10a6:20b:1d8::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Fri, 24 Jul
 2026 10:53:34 +0000
Received: from DB1PEPF000509F7.eurprd02.prod.outlook.com
 (2603:10a6:10:4f8:cafe::d) by DUZP191CA0038.outlook.office365.com
 (2603:10a6:10:4f8::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.11 via Frontend Transport; Fri,
 24 Jul 2026 10:53:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509F7.mail.protection.outlook.com (10.167.242.153) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.5
 via Frontend Transport; Fri, 24 Jul 2026 10:53:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oCTYYHLnckh7RznKKAMv6fyYdIM+ZJet+iMLoGLZ53G3URTBCPDY7b/Z50/DQXCy68UWGNRdt2ISaBXgD3bb7LP3VwvEIVXfSWJz8C+2vfnyM98FRIeFbCB4JceIfOj2bWqA90D5IuBsGhE8520M/KhFqogAW4K/IquPix49DCmeorhV2QfsD+jN5jio+sFGldQGUyd5qUqb7saCatnzftaOpxFsaB4INV5UkSg19pJjR4ByldFPz1SqXR9fVzVeV4bofwradBwU4u1sVD8spzckEqMNFZ6phsFplD0JnqMHKRCrUFU9ue32AltcEiFpDmZ+LlY72V37xt1B5VNK8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RPxhunrJcN62o+nquqqFf8qB5miIlaAx89C20JPzrJ0=;
 b=TMht4YFTx27AHyE02N5IAklIlCA1ZBpdThSnc1ASBWT/q1zLIWmgFI2kVlkZLFy1ACWOu6NsMGSCldzdD9dmqkWFTWFjKzRkszD9D4YYsfxARwGQqI1MXgIkdwUsxJ8h72FXxdnCAk613/41kYLLm6ygFpCkYQ5eb7EihukCvJlBLZWFjili+yRE7yo5vrlIBnH9qVK01DyKgJ2ilfu4ounF+e12hQEuANnDZiW4PrSqCKWFVURTufGqT6NfVi4nXskjRMKUN2N63pic4BfC7w+EiF1VFC9GmrNlnlwMGt3JrcPMWAXQAy2wix93FXnuSZdoMTaYnB25lA6Jhe1IBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RPxhunrJcN62o+nquqqFf8qB5miIlaAx89C20JPzrJ0=;
 b=dZZQ05jv3YrSUEG8Nt8g5QqF9T+FiITeJtLe53MzpVrqmUDNNrGnO0BDInbHPP1o8BfbWJP0vqwMAyNR/HV4sMUh70EHJ0mmliC10Op1tQ0ctA4vuy7NjHKts2Md/IUJ5z+wJ03NVtiA3y8lh7pK6+S5NN/OLXAyhvHo1auEA54=
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com (2603:10a6:10:407::19)
 by DU5PR08MB10466.eurprd08.prod.outlook.com (2603:10a6:10:516::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Fri, 24 Jul
 2026 10:52:32 +0000
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e]) by DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e%5]) with mapi id 15.21.0245.009; Fri, 24 Jul 2026
 10:52:32 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey Gouly
	<Joey.Gouly@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	Timothy Hayes <Timothy.Hayes@arm.com>, "fuad.tabba@linux.dev"
	<fuad.tabba@linux.dev>
Subject: [PATCH v4 16/48] KVM: arm64: gic-v5: Request doorbells when VPEs
 enter WFI
Thread-Topic: [PATCH v4 16/48] KVM: arm64: gic-v5: Request doorbells when VPEs
 enter WFI
Thread-Index: AQHdG1qHixGm7P28DEaB9oxXfibtSw==
Date: Fri, 24 Jul 2026 10:52:31 +0000
Message-ID: <20260724104819.1296803-17-sascha.bischoff@arm.com>
References: <20260724104819.1296803-1-sascha.bischoff@arm.com>
In-Reply-To: <20260724104819.1296803-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU0PR08MB8421:EE_|DU5PR08MB10466:EE_|DB1PEPF000509F7:EE_|AM8PR08MB5699:EE_
X-MS-Office365-Filtering-Correlation-Id: de2e1b9d-6aaa-407e-0ba9-08dee971cf18
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|376014|23010399003|22082099003|18002099003|56012099006|11063799006|3023799007|38070700021|10067099003;
X-Microsoft-Antispam-Message-Info-Original:
 ZBYq1XN2I28WlUFYKJen0eL0yKHrPHQluyTFfhpIdrm53O8U9ru7hRtKuG0mF6lQXnDR/Bgacg1EGLX7D1Vy+3rw8YbANYbRC5NTmQ30ailiLI28ZiMSNi22oW2DUkBmEHjN0syFWw8fUfY+5Jh9fRtY9AQgOmnospYaxSq9yTLW3Ki+elnUcNM/uWz9Q0nvrYjJ08BsAGbCcEYN5z/pZDL1KtQfT8h5ydG5veHHxwQdsajIiK7MI/4WMvs0kg1FRU4eosJ210SDkygBDfzSyq7Wqk12W9EAPc40bB8TGXoW//sRWlj/X8hUvYZyLA0m6vhBxk3jAdq3OH4AC1vhmeqleknI/QPl7ZANDG85DyaFBRBYinweGLDlNdZK49XaKMAJT+u30Na0oFbdcbgDiO1/usNyNG0l8OKzmEV6ZI+GROWh4Fo+QnH4oQKYgi20nmF9KmQLTsrnDOD9aMYkCWWugw6dSFlV2+EZu7XfFnZ3p8FsOc3D4ujZHGfdbrMq6FF9i4ZansxG/5kmlpFZOAfwQpzjJUqYEgTvd3I5pkVT9bzUR7ZKeSDzmOhdPuEAFDr0B38bOlyhfkeiDtvyq7TkJJnYzp8qjemGVZHfsIDk85VvjUWB6PW2WK9Svmpuh9Cd6ZzR0FMa48bOmyglrUSj4NLa3Mza6XfuMlMZYF9w7OrxstLXzwF5O+qWB9yFFUfBlTL5dZzj1aVh1f/dHqkC1zMvNS+BPTPSFk2Idrg=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB8421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(23010399003)(22082099003)(18002099003)(56012099006)(11063799006)(3023799007)(38070700021)(10067099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 CRVTyAgYy6Bjv3zTHA8C+c4+SseUHwvkG3fqXCr5Sy35NfONdG0fTK5bTEMSbl1QMOtwl9uRg5kHrKnF1NwTFfVNM8Tx4HprOfeHfVkaRAbnybWq3ouqaO6c7ubCGjePPVHE76JsygN0b1DAIRhAr36Ba0Yr5mV8Bm7DYL1TKYo7GDPDy65qZ1eUkxnCbajz6yHacnWgISslbxANi+dOhBuf17qMz7as86QeNDv6Mxrn/ZfF0NNFOULPTb0PyTSr82Fi+DcML763xiYaUmrAh/a1pd+xFzRr7ctQfDJ4uw/FB3U53OScJ28EmP4zEVkPy2ox7aUtJJMyLGbAubx3Rg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU5PR08MB10466
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509F7.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	829ea63c-836d-408a-5bd2-08dee971a9ad
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|35042699022|14060799003|82310400026|23010399003|376014|36860700016|56012099006|11063799006|10067099003|3023799007|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	G5+T66epaaib1dYtXhbkp9AJOlZCnEJgpBEEb6k1jQyX14toPYu4N2ZWsOy2Eah9TjNnUtiu+VHraludSJjtSkQXXpRNjKVzy04zuD1ASE/i8x+w++VLU+XukJafdjzENaH0jRv2JaYf7InS4qx2XnQS8omvtBZjjZ2qHEvZXLquPWFptp1MgsBH5AvWDSpGQEXuOV89PFSk7l5ha3ahk22V1DBd0GOd6lpMg49+2hANKdGfxYgw3D4qjwb9Fb4llNH+DyllyJYF6cKtCO8vIbNuQ1rO9mSxf1biwjrXMLHt+IhZ4WvbkAS1guyOYmttyjhcOCTUqj/UHOFa6Wd+SXHCTS58TAaRw5IV3kCtB4dc3sf76q2npzP5KzkSeeMAG3cGFwr0bsugicIl1glOMkeB8xe33KLEwGonE7zc4/CpOSy13h89IrBmLXXsYodM4AoQKXL2vLXC6M+j32mFCKeR2MDjElPOyGyb35W/COEN2p/xl9CqHadiyA8/wh8cI2rJX5GE424xWSmmAyo7CbUSppZ219r+1NMK2NTl1qKt/Y/2dpg2533MV46/fvn6yudK744G7LvefURDJ9SP7qNY9AGA7LyOVnAOtM1648HFl8BqQ2nkyWhncC72rG3/ugzMENMBnslcBX83yDg1A+J86KO1353SlOtHUuV81p2KSqIhJWqYt0BsX3zCmhI3sdwrWLheNUNIIsOTAfrvgw==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(35042699022)(14060799003)(82310400026)(23010399003)(376014)(36860700016)(56012099006)(11063799006)(10067099003)(3023799007)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	sFHlY55ndKI/vgYkutAnYzTj1rBWLWq2/4+kB/h+WSKiPY4/9pLp3hP7NtbYSrq2pWjXlw7gSXqVAEUrYkbrDTgK+zpmdr93ZeOnBvOljXI2yRtVrtM/eAHSzhzhqmQ/z85dmOTILSjQ5Q50Q2trinXi21oCu28VLTvTuOJLWPQG350gYJFqffFrocLR8P568FaOLIiPRdU9gQ5Y1LKgpOJJ7+3d1r86zz/+Ei10lYOI+MU0m92ujClkFpK9NjsWzBEYUJjkJEl1jdWpP2ry5Y3iyGKnX+qYlD749LTyryV5Jn6OPQ57KX5g7HPWUOkztSSMguZ0yIygTb0hXsOaac55o7YcC2SBOwbUZlEXNgoaFWJaVIx9zwjaevdhsgCABklj+j7lopUP1qaoXpliQIEDt50E9f+HRiyBcdefYrYQ6YX7wnI3jxG0cmil1iyW
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2026 10:53:34.7147
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: de2e1b9d-6aaa-407e-0ba9-08dee971cf18
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509F7.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR08MB5699

When a GICv5 VPE is made non-resident as part of the vcpu entering
WFI, request a VPE doorbell so that KVM can be notified when a
suitable SPI or LPI becomes pending for that VPE.

Program the doorbell priority mask, DBPM, from the effective virtual
priority mask before making the VPE non-resident. DBPM is the priority
threshold used by the GICv5 hardware to decide whether a pending SPI
or LPI is allowed to signal the VPE doorbell. This allows hardware to
signal the doorbell only for interrupts that the vcpu can actually
take, and avoids waking it for interrupts masked by the guest priority
state. If no interrupt can be signalled to the vcpu, leave the
doorbell request clear.

Make the doorbell interrupt affine to the current CPU before
requesting it. This nudges the wakeup back towards the CPU that last
ran the vcpu, where the relevant state is more likely to be cache-hot,
while also spreading doorbell interrupts across host PEs as different
vcpus enter WFI on different CPUs.

Clear stale db_fired state before making the VPE non-resident. Any
previous doorbell notification has already been consumed by this
point, and clearing it before the non-resident transition ensures that
a newly fired doorbell is observed.

Finally, teach kvm_vgic_vcpu_pending_irq() to report pending work for
a GICv5 vcpu when its VPE doorbell has fired, in addition to the
existing pending-PPI check.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/hyp/vgic-v5-sr.c |  9 ++++++++
 arch/arm64/kvm/vgic/vgic-v5.c   | 40 +++++++++++++++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic.c      |  6 ++++-
 3 files changed, 54 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/vgic-v5-sr.c b/arch/arm64/kvm/hyp/vgic-v5-s=
r.c
index f064045a31aee..46992a6c2cacb 100644
--- a/arch/arm64/kvm/hyp/vgic-v5-sr.c
+++ b/arch/arm64/kvm/hyp/vgic-v5-sr.c
@@ -22,6 +22,15 @@ void __vgic_v5_make_resident(struct vgic_v5_cpu_if *cpu_=
if)
=20
 void __vgic_v5_make_non_resident(struct vgic_v5_cpu_if *cpu_if)
 {
+	/*
+	 * Clear the db_fired state to ensure that we're ready for the next
+	 * doorbell when it is requested. If a doorbell firing caused us to
+	 * enter the guest, then we've already consumed that state at this
+	 * point, so this is safe to clear. Use WRITE_ONCE() to ensure we're not
+	 * racing with the doorbell firing and setting the state true again.
+	 */
+	WRITE_ONCE(cpu_if->gicv5_vpe.db_fired, false);
+
 	/*
 	 * Make as non-resident before actually making non-resident. Avoids race
 	 * with doorbell arriving.
diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index e3df8a5f9f657..8ef53cac32414 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -1102,6 +1102,46 @@ void vgic_v5_put(struct kvm_vcpu *vcpu)
 	kvm_call_hyp(__vgic_v5_save_apr, cpu_if);
=20
 	cpu_if->vgic_contextr =3D 0;
+	if (vcpu_get_flag(vcpu, IN_WFI)) {
+		u32 priority_mask;
+		int dbpm;
+
+		/*
+		 * Find the virtual running priority and use this to calculate
+		 * the doorbell priority mask. We combine the highest active
+		 * priority and the CPU's priority mask. The guest can't handle
+		 * interrupts with priorities less than or equal to the virtual
+		 * running priority, so there's literally no point in waking the
+		 * guest for these.
+		 *
+		 * The priority needs to be higher than the mask to signal, so
+		 * pick the next higher priority (subtract 1).
+		 */
+		priority_mask =3D vgic_v5_get_effective_priority_mask(vcpu);
+
+		/*
+		 * Request a doorbell *unless* the priority is 0, indicating
+		 * that no interrupt can wake the CPU up.
+		 */
+		if (priority_mask) {
+			int db_irq =3D vgic_v5_vpe_db(vcpu);
+			struct irq_data *d =3D irq_get_irq_data(db_irq);
+			const struct cpumask *aff =3D irq_data_get_effective_affinity_mask(d);
+			int cpu =3D smp_processor_id();
+
+			dbpm =3D priority_mask - 1;
+			cpu_if->vgic_contextr =3D FIELD_PREP(ICH_CONTEXTR_EL2_DB, 1) |
+						FIELD_PREP(ICH_CONTEXTR_EL2_DBPM, dbpm);
+
+			/*
+			 * Make the doorbell affine to this CPU, if it isn't
+			 * already. Actively check the cpumask first as it is
+			 * cheaper than changing the affinity every time.
+			 */
+			if (!cpumask_test_cpu(cpu, aff))
+				WARN_ON(irq_set_affinity(db_irq, cpumask_of(cpu)));
+		}
+	}
=20
 	kvm_call_hyp(__vgic_v5_make_non_resident, cpu_if);
=20
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index ccb7e3a90cd07..47315c3fe120e 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -1235,8 +1235,12 @@ int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu)
 	unsigned long flags;
 	struct vgic_vmcr vmcr;
=20
-	if (vgic_is_v5(vcpu->kvm))
+	if (vgic_is_v5(vcpu->kvm)) {
+		if (READ_ONCE(vcpu->arch.vgic_cpu.vgic_v5.gicv5_vpe.db_fired))
+			return true;
+
 		return vgic_v5_has_pending_ppi(vcpu);
+	}
=20
 	if (!vcpu->kvm->arch.vgic.enabled)
 		return false;
--=20
2.34.1
