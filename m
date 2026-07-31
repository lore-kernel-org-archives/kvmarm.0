Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011051.outbound.protection.outlook.com [52.101.65.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFB302DC32C;
	Fri, 31 Jul 2026 13:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.51
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785503842; cv=fail; b=K5ujB4ms9VzdbvyznhnroHlHD30brBrzF2sTQBrR7Sxy8IJ/6GlIlag+X+rKFpZWy1Pvnv1Hyz/lDIElWu3JBgzICagyhHTVMCSWOvKk5q3jXMbJNGnompMZpksQioJfZS6sDP30jwVeqN4G1VKAWkFwEg0gmggup761R/M7C3c=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785503842; c=relaxed/simple;
	bh=H4StgItb4/wOTV02Bhq1Tw9Ppv5GEIxB2IMMIJMCLRk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=HKosOdFV9ldoVT85NEWcXpnLrCkag1g9Lw2EHwmpWhjGFUo2cpx+KzizkxfoFVUhJBCv44UOPzSATcvPd8O09yg2qEMeKla3KwfDm9riy0mKrrlzWqXNpb/tysNfnRQ7Om99tJROz1Xeu9H4Ta71bwELthsm7m6t1VRPRKCNQ9o=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=oPDclFOk; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=oPDclFOk; arc=fail smtp.client-ip=52.101.65.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="oPDclFOk";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="oPDclFOk"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=l/E6qpRRAGQkcV+vvN6l3xt+hHZjon9xAqHWgYV7TdfBCgDKpBS9vuKRNpSFJFB3m8TF4nzTvm0covW3kYwXeVyAli3HvB6YujmiVadvRXtaZl1xqGO/ePbliyLlcosAx8ErjLyKl8myVg40VxLookG/vKyZjdvjtGalREXKhQVh4to2jDP8Z4djLm95idQuzYH/ZLFzcLRGCZY5F+wuHYLmN2zzM2Xiwg62iGPxRLtQDqbdpbkTyTuRXJlcnuuLvu5CmQgU4DnCiLyhxD9OGbKLx+uQrvWIloMKTKbQmsBefFM03NiK0irhXHVWeKjpBEH0hSSeDUkAuDHGEabSMw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H4StgItb4/wOTV02Bhq1Tw9Ppv5GEIxB2IMMIJMCLRk=;
 b=nHVZK+kc8R5x22GfCfckTkZQ1eNc9cD05z/uyMMEiAwGX9MnB31x5aD9t7mZ3Gm7p8JBYy3KirvdawOsOGT4D7XPs0cxoAUzg0avlURViLv13FBSsdEx/aRvyTP80qk1vTHFfMBWzxnug3WV7nG3pBY+GN334yQ2oYqY2rxhn04fFUDsKhA/1WF0U5MukM19gyVAdFZQZNNS6f/u7n6kXPI8P2/JGRNDDcAGOksGRpdqm+zdA/CKOFk0s8MzfebyqR0nrg/mXMYM9oEC0XAoG/xr31Nr+LWVOyto6XsRzpDNyJGC6UnbOyENPNoaetLBUna3eAM6W6ClMMRDMBr7Cg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H4StgItb4/wOTV02Bhq1Tw9Ppv5GEIxB2IMMIJMCLRk=;
 b=oPDclFOk20zmjD1n3Pgl7BDWqRSZFPTeZ5B62m/bv+c2mNakIQZK9JecPho2ApUd35py6XdV3vF6144Y7MZ94+uxkUrgx7MxJjHGOiL3O1bgHT3VdLVmBE3bVs8/T5s+8tUIKRdjf2kgJlJV//eikyA4/4IdaMxDk8rOQrg5DFk=
Received: from DUZPR01CA0071.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:3c2::16) by DB9PR08MB6396.eurprd08.prod.outlook.com
 (2603:10a6:10:23e::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.15; Fri, 31 Jul
 2026 13:17:15 +0000
Received: from DU2PEPF0001E9BF.eurprd03.prod.outlook.com
 (2603:10a6:10:3c2:cafe::98) by DUZPR01CA0071.outlook.office365.com
 (2603:10a6:10:3c2::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.15 via Frontend Transport; Fri,
 31 Jul 2026 13:17:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF0001E9BF.mail.protection.outlook.com (10.167.8.68) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.8 via
 Frontend Transport; Fri, 31 Jul 2026 13:17:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ozaBuMWMSpGr2Hc5ImTAbMmM8K3nzQUM/zKI4pkV2Swbpvic716BW3KhxSgkZPTEBow3awBlkoVoEMR2tPNkPwNWADofVqIxDaxZNKdr7hnHWlGrRIMXbiXmExDkhPkW4HqhHYu6EVt8QoaKPeimcX53puX04iwmzSjPR9by/uQZ8bqOxzVa9kYGoQyRdFMnrTZOayrW6BfCUu6vrFz8nATYbzZBpDU4wfn7GCT70L6eHZ00p5LUsd8hp8X1CobW31kxqlEJ38las0u1mJNfv4EyYWXLKf9YMnie1manN6PlQGvVxg6JvzPMZLoMYPr6hZm3TpMpWtCZrGpwrdfr/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H4StgItb4/wOTV02Bhq1Tw9Ppv5GEIxB2IMMIJMCLRk=;
 b=Ij3mpMMX+FaXXx4nNgXWuKfwBgxXYWgiRgnWlL3nXAXbnEfaXjfLe/hUsOKJbYuFpC4JrwwRMghLwU7j+64E9DWBKuCYuGMNwWtU2mUKrqR1k/iu+YQAtXZOf3ZK8LNIYN0kH3dPSjs2Oj6FPJXRRbi+3QbwZ71223jLPgZKSO3o9fv9xLCMgzFlR6Bz6zoBHwstXDm4dWwKC6x40mMNF995fg/AafqIC56Xpv8t4qnZOifeZ+8M/Rzu1Wj/3n7BMTtRIIveewnQ+aU6huhPkvTiHZdearkTvIdBzaVnJn+vUIAfhHfDmtJK9q4h5+gQ4bVBgX3IfA0k7LBkOlwrOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H4StgItb4/wOTV02Bhq1Tw9Ppv5GEIxB2IMMIJMCLRk=;
 b=oPDclFOk20zmjD1n3Pgl7BDWqRSZFPTeZ5B62m/bv+c2mNakIQZK9JecPho2ApUd35py6XdV3vF6144Y7MZ94+uxkUrgx7MxJjHGOiL3O1bgHT3VdLVmBE3bVs8/T5s+8tUIKRdjf2kgJlJV//eikyA4/4IdaMxDk8rOQrg5DFk=
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com (2603:10a6:10:407::19)
 by DU5PR08MB10400.eurprd08.prod.outlook.com (2603:10a6:10:521::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.16; Fri, 31 Jul
 2026 13:16:12 +0000
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e]) by DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e%5]) with mapi id 15.21.0270.012; Fri, 31 Jul 2026
 13:16:11 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>
CC: "maz@kernel.org" <maz@kernel.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"oupton@kernel.org" <oupton@kernel.org>, nd <nd@arm.com>
Subject: Re: [PATCH v4 15/48] KVM: arm64: gic-v5: Add resident/non-resident
 hyp calls
Thread-Topic: [PATCH v4 15/48] KVM: arm64: gic-v5: Add resident/non-resident
 hyp calls
Thread-Index: AQHdG1p9ww0ZJIJogUSgtSPy0z9gd7Z8h+cAgAse5QA=
Date: Fri, 31 Jul 2026 13:16:11 +0000
Message-ID: <fae1dc94a4f9bdd0813fe8affd2d3d7e24fba2ab.camel@arm.com>
References: <20260724104819.1296803-1-sascha.bischoff@arm.com>
	 <20260724104819.1296803-16-sascha.bischoff@arm.com>
	 <20260724112645.10AC51F000E9@smtp.kernel.org>
In-Reply-To: <20260724112645.10AC51F000E9@smtp.kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU0PR08MB8421:EE_|DU5PR08MB10400:EE_|DU2PEPF0001E9BF:EE_|DB9PR08MB6396:EE_
X-MS-Office365-Filtering-Correlation-Id: 86a52b47-2e0b-4719-826d-08deef0609f7
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|366016|1800799024|23010399003|38070700021|20046099003|3023799007|56012099006|11063799006|4143699003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 VQ303nSp/ls34gY9FqiuPXrc8avb4Q7R/JAb5HvsRg2/nNXCmBSLnLQmd6NteLuqNO6vFJszOqdYV+BxrDRmdJ8QwglZMTi0jtGMKTk12MjG7XjaoMD0XjsTOsOJaFLqqqxapzF7sliOiaeofw7IUDeAeTIyRMebPNQTwAP9naoq9UVRke89qm9vqViq6iPWfVZcagTIQaLNVpIFpTeg7KTsCY3cFtzbe7LpRyGwVaISHNv+Co9kS8UAcs2MFtLxF1f2QKaxlsPD88DhH1r2TIORwNUsFhJHl4uP2ECtuZaH4HAhBDSJbcWmYSZKh9pbVsfPhmetyWT/nuWn/Kqri4pS/cK0pfDzdrUw708AwqGtbdb9w7qaJkoDzDklYR4lgeJIRUYtD2fMtdD8OO7LzDK8xintunIKfCjP7qHf1GY6PUAL3LH0ucFh67frcNcoYqgw6jrroBgKqU5W3CRQXqbIIPcqKe4EDK+p10wI+aes8WRPTqglMmQ/4PJcrYbWrtefoU2rARUZLVvnx+Va6ksqvJlWBSAU0ndOoqll+jC6A761iiUbUuTYzGzjYf+RQZS3d4EGWuW5bwn6Oo1LS4ozSKkD9HW6vSnCfwrEbiNU5Jy3X6BmJgkbA+gO3IIehzqP+nBfjUT5LR57MZb8Z8VBtqHsmRLq5P9Aw+Qjinc2sktYVR0JxTorK5oBE4qkzVYX9HIYHx+PbXiSLZEwuuplU61S3zKzV6ZmU6V+n3M=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB8421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(23010399003)(38070700021)(20046099003)(3023799007)(56012099006)(11063799006)(4143699003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <A794791D5A0FA943978C3EDFC392EF6E@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 YFYLEvY2h/a/JK9ZPWc+QmJvLQXMSoOGq6yIM+ubdFnra30AzQA3k/vDAD2muQJf2uwBNAJ+eJQAAUHGkxLoucpZ2wa8F/DZKeMavI8YZMxOSTd1Qs5Oh1PDNcUK7W9I4g4i97Kc5oNXDTqciHNxHdeFs05YMlvuRR2hhUPyMZMFW+pt59t2tnEEKz0cPpYkvf71/jEKmZTB31T0xYtrGFsmShfR+OIEA7RQr3RWWzCtKO9uPG+axh4vHmKxeJcCCFlGRtiUhg4xEibUwetbVNKYTowNKlEUvV+RNLZxiIrzKIgpDdBC81kVIdRVrof1WtX/gj1NylZllGUwXvQnHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU5PR08MB10400
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF0001E9BF.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	708784a8-a777-4c06-803a-08deef05e41d
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|36860700016|23010399003|14060799003|1800799024|35042699022|20046099003|56012099006|11063799006|4143699003|10067099003|3023799007|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	JhWfeuwoi1yw9Jopu43Tv9Q72jfrD/7Dw4oGmis76zATJPdq3/ExjyCaxac8eA+EjLSau2InC8V+PhS/ZslTE5te0120dH6qhxMJUDTMpSw9EDDEanXiI3FUgLGpWGxG2dXO259ReNoFuCbwJSPbvh8/NJLCbkOhRdZun9FbWoyly10FjudS6SXgusMW9VFG8zZ+JSc2tfoCfmj0SSnqK9LG2blmXK7wZI4ITBE+wZ1xZKAC0d1JOLox0u/Gtgv5ZGtDko5RB2FFBAWUegzymAyCIVVi6Jf3mMFnScNzcfRPLmADzZciP3Ha6loExIbjqalogwneZ+aGcrJ4XOIHpy9zoI7156ckn+CqHEN8ITsUBsrwRHxbZBpP6Ek7Oq9W6CoByQb1kqlr9X/BEZweb+VGyatOaBMRdXsoe30CItwqIXceCoFIlrjO0Ve6kq1ZVd6ATbr7Wo+sHRK32ONusEr8/S25DT1P6k4M1pF/OM7WiVbue1BfjFQ+f5WlzgUeAF8Ird0iYN2z1FNAx5OAqB9Hf3L3ukpTENtJ58cb8KcoAV/WnBAQE1fzbPQ3nKoSIoCBGrjSKptNrCeggRkUlEsfeLH4m8/XadHoc49waBni6dnh6m8vb2+tgS2F0qbItv5XcVuG76C2PbAWposazOZCHuJm3yHJsmOIPSjy7JmdF+YHhHjv/6N3tBkOoXKNkgSI8qx5p8J46Xdxf5m3Jg==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(36860700016)(23010399003)(14060799003)(1800799024)(35042699022)(20046099003)(56012099006)(11063799006)(4143699003)(10067099003)(3023799007)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	XZVN2a5+c1qt92djUtdrclWnl8Z+/jo9gbtd8N2vW+5MujyGvBv7Jr9JQCHylhFwe58qKNhtcMgI4EVMrWppdkbh9FQtPfusmlnZagiJm6ey+xw8INlGw5TRtHfaIx1KOIMWAGo1o3kq17ySx1McwOfrtU8iOLHIFIjJS/CxUVDpM/VeadAGXalGp7IpzaHuCZreZ5ld25V0oKuUIt+oJtZ3y4R+XavKeAkJEQEKUELwzqFhyA6nRxO1EkeLZOPU4yn1awT8pyIbKaGqRzX3t4sw1zEFYHR/BZSI3emuUOfVjhHQcVGPc4hOS9DNBYN7W+STgfDCzD4Zlz1DI4lbjD/i84udbBOzfj3NyFm1b/xFErrtWt5B+vCwn7uh1LblyEU0x2JcDTgkjVcj3H4ELn78LNgEItLCRUSdCa3e8WIRu6roAVw2fFjPIEpXcOcz
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2026 13:17:14.8177
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 86a52b47-2e0b-4719-826d-08deef0609f7
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF0001E9BF.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB6396

T24gRnJpLCAyMDI2LTA3LTI0IGF0IDExOjI2ICswMDAwLCBzYXNoaWtvLWJvdEBrZXJuZWwub3Jn
IHdyb3RlOg0KPiBUaGFuayB5b3UgZm9yIHlvdXIgY29udHJpYnV0aW9uISBTYXNoaWtvIEFJIHJl
dmlldyBmb3VuZCAyIHBvdGVudGlhbA0KPiBpc3N1ZShzKSB0byBjb25zaWRlcjoNCj4gLSBbQ3Jp
dGljYWxdIFRoZSBfX3ZnaWNfdjVfbWFrZV9yZXNpZGVudCBhbmQNCj4gX192Z2ljX3Y1X21ha2Vf
bm9uX3Jlc2lkZW50IGh5cGVyY2FsbHMgd3JpdGUgdW52YWxpZGF0ZWQgaG9zdC0NCj4gc3VwcGxp
ZWQgZGF0YSBkaXJlY3RseSB0byB0aGUgc2Vuc2l0aXZlIElDSF9DT05URVhUUl9FTDIgc3lzdGVt
DQo+IHJlZ2lzdGVyLCBicmVha2luZyBwS1ZNIGlzb2xhdGlvbi4NCj4gLSBbTWVkaXVtXSBFTDIg
ZG91YmxlLWZldGNoZXMgdGhlIHN5c3RlbSByZWdpc3RlciB2YWx1ZSBmcm9tIGhvc3QNCj4gbWVt
b3J5IHRvIGNoZWNrIGZvciByZXNpZGVuY3kgZmF1bHRzLCBlbmFibGluZyBhIFRPQ1RPVSByYWNl
Lg0KPiAtLQ0KPiANCj4gLS0tIFBhdGNoIFsxNV06IFtQQVRDSCB2NCAxNS80OF0gS1ZNOiBhcm02
NDogZ2ljLXY1OiBBZGQNCj4gcmVzaWRlbnQvbm9uLXJlc2lkZW50IGh5cCBjYWxscyAtLS0NCj4g
Y29tbWl0IDFiMTg1YmYyYzhjODNkNzZiYzU4M2RhYjA2MGYwZDhmNjA1YjA5MzkNCj4gQXV0aG9y
OiBTYXNjaGEgQmlzY2hvZmYgPFNhc2NoYS5CaXNjaG9mZkBhcm0uY29tPg0KPiANCj4gS1ZNOiBh
cm02NDogZ2ljLXY1OiBBZGQgcmVzaWRlbnQvbm9uLXJlc2lkZW50IGh5cCBjYWxscw0KPiANCj4g
VGhpcyBwYXRjaCBpbnRyb2R1Y2VzIEdJQ3Y1IFZQRSByZXNpZGVuY3kgbWFuYWdlbWVudCBieSBh
ZGRpbmcNCj4gaHlwZXJjYWxscw0KPiB0byBtYWtlIGEgVlBFIHJlc2lkZW50IG9yIG5vbi1yZXNp
ZGVudCB2aWEgSUNIX0NPTlRFWFRSX0VMMi4gSXQgYWxzbw0KPiB1cGRhdGVzIHZnaWNfdjVfbG9h
ZCgpIGFuZCB2Z2ljX3Y1X3B1dCgpIHRvIHVzZSB0aGVzZSBoeXBlcmNhbGxzLA0KPiBlbnN1cmlu
Zw0KPiB0aGUgVlBFIGlzIGNvbnNpZGVyZWQgcmVzaWRlbnQgZHVyaW5nIHRoZSBsb2FkLXRvLXB1
dCBpbnRlcnZhbC4NCj4gDQo+ID4gZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQva3ZtL2h5cC9udmhl
L2h5cC1tYWluLmMNCj4gPiBiL2FyY2gvYXJtNjQva3ZtL2h5cC9udmhlL2h5cC1tYWluLmMNCj4g
PiAtLS0gYS9hcmNoL2FybTY0L2t2bS9oeXAvbnZoZS9oeXAtbWFpbi5jDQo+ID4gKysrIGIvYXJj
aC9hcm02NC9rdm0vaHlwL252aGUvaHlwLW1haW4uYw0KPiANCj4gWyAuLi4gXQ0KPiANCj4gPiBA
QCAtNjkxLDYgKzY5MSwyMCBAQCBzdGF0aWMgdm9pZA0KPiA+IGhhbmRsZV9fX3RyYWNpbmdfd3Jp
dGVfZXZlbnQoc3RydWN0IGt2bV9jcHVfY29udGV4dCAqaG9zdF9jdHh0KQ0KPiA+IMKgCXRyYWNl
X3NlbGZ0ZXN0KGlkKTsNCj4gPiDCoH0NCj4gPiDCoA0KPiA+ICtzdGF0aWMgdm9pZCBoYW5kbGVf
X192Z2ljX3Y1X21ha2VfcmVzaWRlbnQoc3RydWN0IGt2bV9jcHVfY29udGV4dA0KPiA+ICpob3N0
X2N0eHQpDQo+ID4gK3sNCj4gPiArCURFQ0xBUkVfUkVHKHN0cnVjdCB2Z2ljX3Y1X2NwdV9pZiAq
LCBjcHVfaWYsIGhvc3RfY3R4dCwNCj4gPiAxKTsNCj4gPiArDQo+ID4gKwlfX3ZnaWNfdjVfbWFr
ZV9yZXNpZGVudChrZXJuX2h5cF92YShjcHVfaWYpKTsNCj4gDQo+IFtTZXZlcml0eTogQ3JpdGlj
YWxdDQo+IERvZXMgdGhpcyBoeXBlcmNhbGwgYWN0IG9uIGEgcmF3LCB1bnZhbGlkYXRlZCBob3N0
IG1lbW9yeSBwb2ludGVyDQo+IHBhc3NlZCBpbg0KPiBhIHJlZ2lzdGVyPw0KPiANCj4gQmVjYXVz
ZSB0aGUgaG9zdCBjYW4gcGFzcyBhbiBhcmJpdHJhcnkgcG9pbnRlciB0bw0KPiBoYW5kbGVfX192
Z2ljX3Y1X21ha2VfcmVzaWRlbnQoKSwgRUwyIHNob3VsZCBjb3B5IHRoZSBuZWNlc3NhcnkNCj4g
ZmllbGRzIHRvDQo+IEVMMiBwcml2YXRlIG1lbW9yeSBhbmQgdmFsaWRhdGUgdGhlbSBiZWZvcmUg
YWN0aW5nIG9uIHRoZSBkYXRhIHRvDQo+IHByZXZlbnQNCj4gaXNvbGF0aW9uIGJ5cGFzc2VzLg0K
DQpBcyBwcmV2aW91c2x5IGRpc2N1c3NlZCwgd2UgZG9uJ3Qgc3VwcG9ydCBwS1ZNIGF0IHRoZSBt
b21lbnQgZm9yIEdJQ3Y1Lg0KVGhpcyBpcyBmaW5lIGZvciBub3cuDQoNCj4gDQo+ID4gK30NCj4g
PiArDQo+ID4gK3N0YXRpYyB2b2lkIGhhbmRsZV9fX3ZnaWNfdjVfbWFrZV9ub25fcmVzaWRlbnQo
c3RydWN0DQo+ID4ga3ZtX2NwdV9jb250ZXh0ICpob3N0X2N0eHQpDQo+ID4gK3sNCj4gDQo+IFsg
Li4uIF0NCj4gDQo+ID4gZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQva3ZtL2h5cC92Z2ljLXY1LXNy
LmMNCj4gPiBiL2FyY2gvYXJtNjQva3ZtL2h5cC92Z2ljLXY1LXNyLmMNCj4gPiAtLS0gYS9hcmNo
L2FybTY0L2t2bS9oeXAvdmdpYy12NS1zci5jDQo+ID4gKysrIGIvYXJjaC9hcm02NC9rdm0vaHlw
L3ZnaWMtdjUtc3IuYw0KPiA+IEBAIC03LDYgKzcsMzIgQEANCj4gPiDCoA0KPiA+IMKgI2luY2x1
ZGUgPGFzbS9rdm1faHlwLmg+DQo+ID4gwqANCj4gPiArdm9pZCBfX3ZnaWNfdjVfbWFrZV9yZXNp
ZGVudChzdHJ1Y3QgdmdpY192NV9jcHVfaWYgKmNwdV9pZikNCj4gPiArew0KPiA+ICsJd3JpdGVf
c3lzcmVnX3MoY3B1X2lmLT52Z2ljX2NvbnRleHRyLA0KPiA+IFNZU19JQ0hfQ09OVEVYVFJfRUwy
KTsNCj4gDQo+IFtTZXZlcml0eTogQ3JpdGljYWxdDQo+IERvZXMgdGhpcyBjb2RlIHdyaXRlIHVu
dmFsaWRhdGVkIGhvc3Qtc3VwcGxpZWQgZGF0YSBkaXJlY3RseSB0byB0aGUNCj4gc2Vuc2l0aXZl
IElDSF9DT05URVhUUl9FTDIgc3lzdGVtIHJlZ2lzdGVyPw0KPiANCj4gVW5kZXIgdGhlIHBLVk0g
dGhyZWF0IG1vZGVsLCBjcHVfaWYgcG9pbnRzIHRvIHVudHJ1c3RlZCBob3N0IG1lbW9yeQ0KPiBw
b3N0DQo+IGRlcHJpdmlsZWdlLiBCeSBibGluZGx5IHJlYWRpbmcgdmdpY19jb250ZXh0ciBmcm9t
IHRoZSBob3N0IGFuZA0KPiB3cml0aW5nIGl0DQo+IHRvIHRoZSBoYXJkd2FyZSByZWdpc3Rlciwg
YSBtYWxpY2lvdXMgaG9zdCBjb3VsZCBwb3RlbnRpYWxseSBzdXBwbHkNCj4gYW4NCj4gYXJiaXRy
YXJ5IFZNSUQgYW5kIFZQRUlEIGJlbG9uZ2luZyB0byBhIHByb3RlY3RlZCBWTS4gVGhpcyBjb3Vs
ZA0KPiB0cmljayB0aGUNCj4gSW50ZXJydXB0IFJvdXRpbmcgU3lzdGVtIGludG8gcm91dGluZyBh
IHByb3RlY3RlZCBWTSdzIGludGVycnVwdHMgdG8NCj4gdGhlDQo+IGhvc3QncyBwaHlzaWNhbCBD
UFUuDQo+IA0KPiBTaG91bGQgRUwyIGRlcml2ZSBhbmQgdmFsaWRhdGUgdGhlIHJlc2lkZW5jeSBz
dGF0ZSBmcm9tIEVMMi1wcml2YXRlDQo+IGRhdGENCj4gaW5zdGVhZCBvZiB0cnVzdGluZyB0aGUg
cmF3IGh5cGVyY2FsbCBwYXJhbWV0ZXJzIGluDQo+IF9fdmdpY192NV9tYWtlX3Jlc2lkZW50KCk/
DQoNCkFzIEkgc3RhdGVkIGFib3ZlLCBuby4gV2UncmUgbm90IGN1cnJlbnRseSBzdXBwb3J0aW5n
IHBLVk0uDQoNCj4gDQo+ID4gKwlpc2IoKTsNCj4gPiArDQo+ID4gKwkvKiBDYXRjaCBhbnkgZmF1
bHRzICovDQo+ID4gKwljcHVfaWYtPnZnaWNfY29udGV4dHIgPQ0KPiA+IHJlYWRfc3lzcmVnX3Mo
U1lTX0lDSF9DT05URVhUUl9FTDIpOw0KPiA+ICsJaWYgKCEhRklFTERfR0VUKElDSF9DT05URVhU
Ul9FTDJfRiwgY3B1X2lmLQ0KPiA+ID52Z2ljX2NvbnRleHRyKSkNCj4gDQo+IFtTZXZlcml0eTog
TWVkaXVtXQ0KPiBDYW4gdGhpcyBzZXF1ZW5jZSBjYXVzZSBhIFRpbWUtb2YtQ2hlY2sgdG8gVGlt
ZS1vZi1Vc2UgcmFjZT8NCj4gDQo+IFRoZSBjb2RlIHdyaXRlcyB0aGUgc3lzdGVtIHJlZ2lzdGVy
IHZhbHVlIHRvIGNwdV9pZi0+dmdpY19jb250ZXh0ciBpbg0KPiBob3N0LXNoYXJlZCBtZW1vcnks
IGFuZCB0aGVuIGltbWVkaWF0ZWx5IGV2YWx1YXRlcyBpdCBiYWNrIGZyb20gaG9zdA0KPiBtZW1v
cnkNCj4gdXNpbmcgRklFTERfR0VUKCkuIEEgY29uY3VycmVudCB0aHJlYWQgb24gdGhlIGhvc3Qg
Y291bGQgb3ZlcndyaXRlDQo+IHRoaXMNCj4gbWVtb3J5IGxvY2F0aW9uIGJldHdlZW4gdGhlIHdy
aXRlIGFuZCB0aGUgY2hlY2suDQo+IA0KPiBJZiB0aGUgaGFyZHdhcmUgcmVwb3J0cyBhIHJlc2lk
ZW5jeSBmYXVsdCAoRj0xKSwgY291bGQgdGhlIGhvc3QNCj4gb3ZlcndyaXRlDQo+IHRoZSBtZW1v
cnkgd2l0aCBGPTAgdG8gdHJpY2sgRUwyIGludG8gaWdub3JpbmcgdGhlIGZhdWx0PyBSZWFkaW5n
IHRoZQ0KPiBzeXN0ZW0gcmVnaXN0ZXIgaW50byBhIGxvY2FsIEVMMi1wcml2YXRlIHZhcmlhYmxl
IGZvciB2YWxpZGF0aW9uDQo+IGJlZm9yZQ0KPiB3cml0aW5nIGl0IG91dCB0byBob3N0IG1lbW9y
eSBtaWdodCBhdm9pZCB0aGlzIGlzc3VlLg0KDQpXZSBzaG91bGQgbmV2ZXIgYmUgaW4gdGhlIHNp
dHVhdGlvbiB3aGVyZSB0aGlzIGhhcHBlbnMuIFRoZSBvbmx5IHRpbWVzDQp3aGVyZSB0aGUgc3Rh
dGUgb2YgY3B1X2lmLT52Z2ljX2NvbnRleHRyIGlzIGNoYW5nZWQgaXMgYXMgcGFydCBvZg0Kdmdp
Y192NV9sb2FkKCkgb3IgdmdpY192NV9wdXQoKS4NCg0KPiANCj4gPiArCQlyZXR1cm47DQo+ID4g
Kw0KPiA+ICsJY3B1X2lmLT5naWN2NV92cGUucmVzaWRlbnQgPSB0cnVlOw0KPiA+ICt9DQo+ID4g
Kw0KPiA+ICt2b2lkIF9fdmdpY192NV9tYWtlX25vbl9yZXNpZGVudChzdHJ1Y3QgdmdpY192NV9j
cHVfaWYgKmNwdV9pZikNCj4gPiArew0KPiA+ICsJLyoNCj4gPiArCSAqIE1ha2UgYXMgbm9uLXJl
c2lkZW50IGJlZm9yZSBhY3R1YWxseSBtYWtpbmcgbm9uLQ0KPiA+IHJlc2lkZW50LiBBdm9pZHMg
cmFjZQ0KPiA+ICsJICogd2l0aCBkb29yYmVsbCBhcnJpdmluZy4NCj4gPiArCSAqLw0KPiA+ICsJ
Y3B1X2lmLT5naWN2NV92cGUucmVzaWRlbnQgPSBmYWxzZTsNCj4gPiArCWRzYihzdCk7DQo+ID4g
Kw0KPiA+ICsJd3JpdGVfc3lzcmVnX3MoY3B1X2lmLT52Z2ljX2NvbnRleHRyLA0KPiA+IFNZU19J
Q0hfQ09OVEVYVFJfRUwyKTsNCj4gDQo+IFtTZXZlcml0eTogQ3JpdGljYWxdDQo+IFNpbWlsYXJs
eSB0byBfX3ZnaWNfdjVfbWFrZV9yZXNpZGVudCgpLCBkb2VzDQo+IF9fdmdpY192NV9tYWtlX25v
bl9yZXNpZGVudCgpDQo+IHdyaXRlIGhvc3QtY29udHJvbGxlZCBtZW1vcnkgdG8gdGhlIHN5c3Rl
bSByZWdpc3RlciBpbnN0ZWFkIG9mDQo+IHNlY3VyZWx5DQo+IHdyaXRpbmcgYSBoYXJkY29kZWQg
MCBmcm9tIEVMMi1wcml2YXRlIHN0YXRlPw0KDQpOby4gU2VlIGFib3ZlLg0KDQo+IA0KPiA+ICsJ
aXNiKCk7DQo+ID4gK30NCj4gDQoNClRoYW5rcywNClNhc2NoYQ0K
