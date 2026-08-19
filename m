Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010042.outbound.protection.outlook.com [52.101.84.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EABF3381EB3
	for <kvmarm@lists.linux.dev>; Wed, 19 Aug 2026 15:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.42
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787153976; cv=fail; b=GzKtVw3/q8T5dxLXNVpNPcgBzo9TusaETFm56RjTUMVI5pFlZDwUSMe9Lgny5EaV0rQjww0Rum2XWctK0LcgczPIrQQY3fNrViwK2iNDFzx72zhZ+aMpA6LjL9ohg/UfLGQEkKn3vZxSgEZROesrBb48SLMgDl/1Yf+5sdtX+0U=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787153976; c=relaxed/simple;
	bh=EjrMgIi9Yvy9iLfbYmFdSKe+SzmC2Szm1bgVLgw0l6M=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Pvi6P+gEKWElqrKI64GVZqlmvSGcaSal4ooaWDDq3vI7xY6Z/PhFlP+hSKQUmrH/HIqhdrGcadioAQwH4NFUPtzf0m3G6sqa/jpdytn9iHCLh5Z7megon0QPCyH73qwDJmb01GDxUAXSg4TjHSdWbC439rE2aD9sFSuERRJkby8=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=OL6Fxbwa; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=OL6Fxbwa; arc=fail smtp.client-ip=52.101.84.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="OL6Fxbwa";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="OL6Fxbwa"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=zP6ixo9b2jHNwRt96npOX+6FgttcOFLCwUh4pGoF7zcD22bKdEcHSeXriNWFJtgf1jL6f4ajxp6pYgrM0GaL1D+gzXSXkw29hgtHM3rNFj6zEpLAk85wHSxA1YrXEd5oTknjTCDiSQd1+YPBQI8o6WsDCf0mhRiuGRrZYccepOJl/LzZKYQHxLoCTJuq1gGlSqF5W9jyhYY7d8vygmhemhjI4qbesbzDCGJrk44HlGW2kRnEQ1fHiOluGonCdZidHak58UUbDT1PFcGOJ8dZnhmXwNqSBj6ec8a+FZta0VXlAyjoEpacyqaZKEWb5BXmuWtt4wo6P8D5+ImB1LCZ8w==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ioO5vbJUZoRyyyRXxA49fyudNIJnPrk+ibjm+k+TU/I=;
 b=wWR/HCd9NK/siq9ixVhJQz9vtIOiQaWmyORuHewTrJQTcTVF9fI/Ml+jqqGbFXBSIzr1oKO7Z97thZsG1N0oOmEAFrlIpgaZLNksROXhWOEWF8+P+7Q6NudxFlCBXBg9sXgkYqT643uesLYdrCSMazzhKOcRrd67Czb3FGc2mA4MA7whET6/4S+fVl2tXPbQFDGEvP14a5l0RX21XxkJtna53S6OvQAi+WxsmtXkfG1/xjJ9EErDoljYarPsyXza67/VIgt5WSUXb7ZWK2+/Ri92YUsXA5WyT/3zu1nfLtzDrxS9PUrBcfwNJFT52WPfLbkRaXv1RcGgOkGqvXl29A==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=google.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ioO5vbJUZoRyyyRXxA49fyudNIJnPrk+ibjm+k+TU/I=;
 b=OL6FxbwabJIXJMG1FP4WnZxVR91M1+xtOn/lK5zA3fJFjzvC0K7aS3p/JML+Sg++2oF2hVSsWFHCf/7UvCvsgYeowhC+6blWiJFi4hy9SRnnaS6qxaN9PYJK+wuMFTxAK3kZYFJ2lYl6aIArMhBSEPxvYJcZeJ6Ai47axibrdo0=
Received: from DU2PR04CA0331.eurprd04.prod.outlook.com (2603:10a6:10:2b4::19)
 by AS8PR08MB6102.eurprd08.prod.outlook.com (2603:10a6:20b:23d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.8; Wed, 19 Aug
 2026 15:39:30 +0000
Received: from DB1PEPF00039231.eurprd03.prod.outlook.com
 (2603:10a6:10:2b4:cafe::24) by DU2PR04CA0331.outlook.office365.com
 (2603:10a6:10:2b4::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.339.8 via Frontend Transport; Wed, 19
 Aug 2026 15:39:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF00039231.mail.protection.outlook.com (10.167.8.104) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.339.3
 via Frontend Transport; Wed, 19 Aug 2026 15:39:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YnI+OTXaMmbDW81yv/NXJ0zTPYAspmOaMOfsyc+S9p3jGP0EiYpaK4Or9K0x4J5X7yShrB1H3LN7sV9ueJiJZ3pfW6/RSS1STaSEn2S//lb7yuZHYTqZ/zDNw9Du9TeM1js8931qq8BGEmzd08kTs8KQ6oDn6qx9TDJSsknDeqljY367zGnLbi4B0QfKoWtZHzhlK3jorRAX7GtHTrNxpFbx+EXfJIHOwZ9PNyhrwQPGAX0pTwLoKzJK8ia63qQ6NLgCwt7DwKajrP7pTJAR5Mgjb4jDA7IHvWx3SVr7BwfRZ0+0AhP8MjI4pP3iF3Gp8nngBud6so3ZksG9e+Dj6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ioO5vbJUZoRyyyRXxA49fyudNIJnPrk+ibjm+k+TU/I=;
 b=Ng27um2n6tOF+u/+CYgywhrA5XVdx9buKocuVON8aNvwaQdoe030P4BZgQ2VLBYwbje+t88qWdVut3UR4pQGC6Y3CE3jiF+0TPx9G6zkFf4KZ88Qae4KvPvidXOihcoU11gKWI5EH7giKHzE3T9L2JvLPfxViXJtFORKgIyBGsQHtXRCntlQdmgXqisXOwOmTz2fZoPQ+3W5MrbhvGYdOBJqpSO4TzzxQmpQlATT36UkmqJ6bA0bllnxLJjqVvMNTnmGxOOIToYQX+HEBKYFfXr292NxnT8eaoY63uW/Swl84vlkky4jDUUaBc47os0XRQcDFBF169GYLtKDFI1lrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ioO5vbJUZoRyyyRXxA49fyudNIJnPrk+ibjm+k+TU/I=;
 b=OL6FxbwabJIXJMG1FP4WnZxVR91M1+xtOn/lK5zA3fJFjzvC0K7aS3p/JML+Sg++2oF2hVSsWFHCf/7UvCvsgYeowhC+6blWiJFi4hy9SRnnaS6qxaN9PYJK+wuMFTxAK3kZYFJ2lYl6aIArMhBSEPxvYJcZeJ6Ai47axibrdo0=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from AS8PR08MB9597.eurprd08.prod.outlook.com (2603:10a6:20b:61b::18)
 by AS8PR08MB5880.eurprd08.prod.outlook.com (2603:10a6:20b:29f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.8; Wed, 19 Aug
 2026 15:38:58 +0000
Received: from AS8PR08MB9597.eurprd08.prod.outlook.com
 ([fe80::e11:42b9:2ed1:ef5f]) by AS8PR08MB9597.eurprd08.prod.outlook.com
 ([fe80::e11:42b9:2ed1:ef5f%4]) with mapi id 15.21.0339.007; Wed, 19 Aug 2026
 15:38:58 +0000
Message-ID: <7f52191f-c6b5-4d27-8e11-2c00bd9de968@arm.com>
Date: Wed, 19 Aug 2026 17:38:55 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/3] KVM: Dirty page logging for guest_memfd-only
 memslots
To: Alexandru Elisei <alexandru.elisei@arm.com>,
 Sean Christopherson <seanjc@google.com>
Cc: Mark Rutland <mark.rutland@arm.com>, pbonzini@redhat.com,
 kvm@vger.kernel.org, maz@kernel.org, oupton@kernel.org, joey.gouly@arm.com,
 seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 fuad.tabba@linux.dev
References: <ak0ziUcCXUlDdcla@google.com> <ak-EKSslAz1uqEtv@J2N7QTR9R3>
 <ak_wC4Q-mQe14DI8@google.com> <alDI1b8fC99SG4_a@J2N7QTR9R3>
 <a127176a-1722-460c-aa84-754e1d343f53@arm.com> <an3sEiQlIuGEjUur@raptor>
 <b6080c23-a2a8-4bc5-b3bd-982bd766c648@arm.com> <an5UJ4S_P1LUFmzD@google.com>
 <487aa57c-72ad-453b-971d-ca24a8380429@arm.com> <an8SOvLybeilzCEU@google.com>
 <an9JNUln8dKaidQc@raptor>
From: David Hildenbrand <david.hildenbrand@arm.com>
Content-Language: en-US
Autocrypt: addr=david.hildenbrand@arm.com; keydata=
 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 fa0=
In-Reply-To: <an9JNUln8dKaidQc@raptor>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZR0P278CA0135.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:40::14) To AS8PR08MB9597.eurprd08.prod.outlook.com
 (2603:10a6:20b:61b::18)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	AS8PR08MB9597:EE_|AS8PR08MB5880:EE_|DB1PEPF00039231:EE_|AS8PR08MB6102:EE_
X-MS-Office365-Filtering-Correlation-Id: e7c74822-d8ff-46a9-b48d-08defe080f4d
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|7416014|376014|366016|1800799024|56012099006|10067099003|4143699003|5023799004|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info-Original:
 zB/B6sA03la53qHHiutziq/ZqeOgS4pQ1Jdy3iv51ri8vTVa3afmC9PrTe4acAhuhF87w0PNJR6w9ihyhQxjAss6YfE/hwMe0W6T3w0G0pcOhHteJY0WjxWw1gTMfA816STk/HdHwlCpJJuvalakcgjoSlK1IWJZwkgsRIQlaHlaETAkmwzJJt9bB06vCojIKLLNO+iruKqv28J5uvPxHO3vDX9CGbKcfKpwONNdTeWAmpRsxzJH/1aiHbOPrQaoumy20GhrlWzD88cerAZ7+ZSu4nZoabcXQxsGAJdxneiiyJbjgl3QxxG9tSbuK6BCyxSqT+z0o2jOVSCnr3PnN2vpAbejvuPwSiy2XLjHW/RRz3MXS8enBacQkEPdFW6I86IOHyFVlmqX+6NdmcZ8Gz4QFDScD5Qncxo7EXLhC7GziMSnXY3/5pP5PxWJO4/tJmxp19sbqC4PDjpHiWQy3mG0AKlGqANYKS3QVPVo0zHhIfyOd0sppdhCZnP6sco/OwF0u0w3y1rbTpmMVWVwTPJAmRO5W7M/vc8rwLx6PE9VoNpiCVDyJMgLptVWmoS0iV8pMmJcJT2W0JxJ/GPB412IqFRp5V6S3izRjcX4WPdgol/ZlxrKCfkRX4W318JAdCF28ASn5vAXKxBH751VMX9alQKpngAOtfyT7kV1SnQ=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR08MB9597.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(366016)(1800799024)(56012099006)(10067099003)(4143699003)(5023799004)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 osd4dhdBGMtVuY5j1vHmfzpY1zKMZpl7RUU1nRwqtKV220S6WpIw88JqAPpk8DFh4dVy+wTKW0SRPHErFuE7TRJQLapwX78ORuJ6rqQ2HBctZFyn05+xMpWwu7UICXOK+u1iQuctrwu9xKil2Xxdd1MvDSxwPARpi5/2v4d8WPqhnS2Cz0tGVVf9aRgqfG1qqU9m/d00U+N9uW/tpY9y6r341lyvX4H3gps9wi0sgidotayfxoq4r/IhtJHzbSZJ63pHOKIp8clcEhd5BJ4Ym+oNdrYWQ8+E6/jYvsiEQGDHli1yfnq5Uukph8CC1o3LQpeigtAz/WJgpZgxcVqDQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB5880
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF00039231.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	72dfafea-af77-4a73-b9fa-08defe07fbfe
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|23010399003|82310400026|14060799003|36860700016|35042699022|56012099006|10067099003|5023799004|4143699003|22082099003|18002099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	5VJJsOXMO1nprVywpgeBuac9J46dTYKv1+4WfZ6e4IXUgA+kLSNzpRkl5OO7X6jFbokTBEWB7pvRuuUbX++XjCi+b6mgHa/FD/PbGb+hZAWwdubSVx8nuTtqx8Y0wOUceREKmwCTWtOXWzYg28AjeVI0d42XqvPc0ZLwOM6jj77QZF/aUg73tDmL6grqwNlRKF4qnZiI5t4JNeLsfxosPVzCZJKv2PZdfmdSMmDNpjASThyXuymXenWZ3230AQgsljjy+tSeBmbmCG5ceTw/lhlNYeN1UaMslIfpjqxvFmGm0dGIdpVU0DUOzsCKgcDaBf54bsZWtJke651exgQBvMMXfUm31mAAj/dWg29eS0zRQooMLak4dkvPQp8fK5OUuC0Ya/EVaz6Znn2hjdYR0XhcnBITCal1CH/e5ORrG1IUTUijVP2xUqR096lgOqKw2UFTYpbg+Zsc24m/zzw2gUiW1Nve3CI0lHVd/JkWeqkaOxY1QzEJdSj8234YkDA8g1PQ4T5ruY0gLYdfbXdWESZTcmtb4qYAp337//SgDsdfZsOVcz0juzov+NsOhp6YcoO0+V6zsyt55Y2YpdRX70vkPZxlKg+YTVL2IQJQdvxi538XnXwRaRwMh/CQ/fcZBkNFggOJf/0LcDeaQdVmRPIbgMyhE3wm2tsbipTPJPqEbzGIdYI+0VumKypP4woDpe/wgUnW0pSRBxEo3Gq07g==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(23010399003)(82310400026)(14060799003)(36860700016)(35042699022)(56012099006)(10067099003)(5023799004)(4143699003)(22082099003)(18002099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	oVZiSe8kKFovBW/pcQziq3o2GBdyeU37u18SGK22LS/vXRnpCH0eGIC0KlRNt0fwijfE3yUMlOtDP3ZnCxb48OYveeWiW+fR7mMvOzVBNJUV4P9JDWeHm6WJyCiM3p8KkjHSp58tqV1KgrVpI0mV8iNo+EY/O1b6b2Mqe4WVnKIiRtRKY+B81uyWUoCySilaqqn6bTQevQPGxrA/s/Vnw0Ju+aaTZSwyMDc8+Vr0vMczez+uBFO6bNpBDaoR7Jt5usCssUbOfY7ucLP6FpZG0EGqMqPqjBXFPkRx3L8KUUbeL6E+hgIw0w+zStscM9ngFBCUis6po8xd2kPMT5dV1mQwEDKu7TQEUsAnNJdZ4YyTnGuwgPIyjEVXK3RutB/ow5CI2ZgmrrrvJaA65Vr6XN89PC9VBHlgRVuTezPE27+zBN4jL6ip2ewtePVuJc7E
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2026 15:39:30.2064
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e7c74822-d8ff-46a9-b48d-08defe080f4d
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF00039231.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB6102

On 8/14/26 18:58, Alexandru Elisei wrote:
> Hi,
> 
> On Fri, Aug 14, 2026 at 06:03:54AM -0700, Sean Christopherson wrote:
>> On Fri, Aug 14, 2026, David Hildenbrand wrote:
>>> We have a hardware feature that requires pages to always be mapped into S2. Some
>>> things I had in mind:
>>>
>>> 1) Page migration would not be a problem as long as hardware could be paused
>>>    while migrating (e.g., kick all vCPUs). I doubt someone would implement that
>>>    right now,  but you could consider it an implementation detail that page
>>>    migration cannot be supported right now.
>>>
>>> 2) Newer hardware could mitigate this problem, allowing the feature to support
>>>    pages temporarily being unmapped from S2.
>>>
>>> 3) Disallowing page migration is really just one implication of "pages must
>>>    always be mapped into S2".
>>>
>>> So what we really want is "if feature X is enabled and hardware requires it,
>>> always keep pages mapped into S2, which currently implies that page migration
>>> cannot be supported."
>>>
>>> Which isn't all that different to "if a confidential VM is run on current TDX
>>> hardware, always keep pages mapped into S2, which currently implies that page
>>> migration cannot be supported."
>>>
>>> So I was wondering whether the flow could be:
>>>
>>> User space enabled CPU feature for VM -> KVM knows that current hardware
>>> requires for that CPU feature to have S2 always mapped -> KVM tells guest_memfd
>>> that S2 must be always mapped / disables page migration.
>>
>> I'm a-ok with adding a flag to guest_memfd to communicate whether or not page
>> migration is allowed, because guest_memfd needs to actively support page migration.
>>
>> I'm not ok adding a flag telling guest_memfd that memory must always be mapped
>> in S2, because guest_memfd doesn't care.  E.g. KVM doesn't yet support page
>> migration for SNP, but SNP tracks page ownership in an out-of-band table and so
>> KVM can map/unmap all guest memory from S2 at will.
>>
>>> That would be in contrast to user space having to guess that page migration on
>>> the current hardware with the current guest_memfd implementation does not
>>> support page migration, to then disable exactly that.
>>>
>>> Does that explanation makes sense? I don't know the exact mechanism to do that,
>>> but that's just my high-level thinking.
>>
>> Yes, I'm supportive of KVM expressing to guest_memfd that page migration isn't
>> supported by the VM.  I'm only objecting to expressing that memory must stay
>> mapped in S2, because guest_memfd doesn't care *why* page migration is or isn't
>> supported/allowed by a particular VM.
> 
> My naive contribution is this idea I had:
> 
> 1. Userspace queries support in KVM for feature xyz by checking the
> capability KVM_CAP_xyz.
> 
> 2. Userspace knows that for feature xyz to work correctly, it is required
> that memory remains mapped at stage 2.
> 
> 3. Userspace creates a guest_memfd instance with the right combination of
> flags set and _unset_ for feature xyz to work correctly - i.e, to keep
> memory mapped at stage 2.
> 
> For this to work, new guest_memfd features that might lead to memory being
> unmapped are enabled via a flag, and KVM keeps memory mapped at stage 2 by
> default, to maintain compatibility with an userspace not updated for the
> new features/flags.

I was wondering whether KVM could be driving that setting in guest_memfd, with
less userspace intervention.

1. Userspace enables support in KVM for feature xyz through
capability KVM_CAP_xyz.

2. KVM knows that the feature, on the current hardware requires permanent S2
mapping, so it instructs guest_memfd to disable any features that could lead to
a temporary unmapping (e.g.,migration support).

-- 
Cheers,

David
