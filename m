Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013040.outbound.protection.outlook.com [52.101.83.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EF5B331ECF
	for <kvmarm@lists.linux.dev>; Thu, 13 Aug 2026 20:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.40
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786651607; cv=fail; b=Gd30r7e8/VkjKlPGadoS99bb1Mg/j4PVtS4PAwhJdOD0DTI+0e12ElL6H6KaOUsdKvRZvcP90hd0hOWhTVnyP/73t5nopm+CAf4+dy1wde7dY+QTHY/RiwOOvlm59AY74HY3hDLmyRiy+p3nm1/kXvs7zIz+Bqyv3mDCshCgwPE=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786651607; c=relaxed/simple;
	bh=v67v+3FTV2h0vVijhW2t3fQSNsAlgLOqPfk0G6PdUdU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=UhTBi8jHXKVByxVbdKTX2mfaUl2Rdn4XWDJqJCMN3t7o040f1Darh1TzcpkIv22EDqe4/B20RCAa//CdFkKWOj74/WuivVmZiLrF1jW4eIWbxc8xxlbiRgaih+e6IidnU3a/8k6MVd/4JD4zBoaGpXH7PlsJHdUeeNxDlPBRc5M=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=oGHbK7yY; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=oGHbK7yY; arc=fail smtp.client-ip=52.101.83.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="oGHbK7yY";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="oGHbK7yY"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=qvZKeWjFiJLQEdIqwFym+gbklMSmalIToNBGyGww55kBD/2b4EGikQ+Ja3sd6NhmBhpsV2cJ1q31JvV/FuGOmtFweDqJTNiEhZ65uyaaOlDkPV4ZztKRM5Ey6eJo2lGo5cBgtR3d238fisP2C4gnJ/yZV84jbI6V6KEfDKiIDDMG5DmCKv/6h4Lc510PayzuOifo3hSYRaGoRnNjx+JSuLFC0urUEjJAo+pufuaj6ImsXjE5BDkFogg4WtsGhnxA2AUReJFnbFyIO+nIMG8Ng51Igv9C/sKEeBPAQulnyipoxLhRUeFHwwFWKOuLrRtrgVvVBLU2NT/0FcSCq2Cbcw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CrDnP7o1RpGdk4ZHeIQjOiIhLr4RIX1gVEaI4JdGzbc=;
 b=biJ1Je30U85XerJQbx4PZ1zqcg7FzyXbf3hr0uQ6UDN222hWgIJegjTRxhiDXT5D1c/7Y+anPz6X+aY4Rx1whdSF/NXCHZyzj4tLcCNJbuR79S02VwbdrbWCXTZLZY9CFqz3Nzr8h7eKgvORU+5rJQAxJhp8WEK8vnP0M50ZdOnGIlROSJIUtuslOadd3QncLiC04QQpmKUkbkFuvypdi2OhaVc1WlurDNwB3w7dz45NS8KCVGk3x20qAaR5gbLEiNldQtU38klWZ7cPrXMIdiSNj394+BOfh0A0xwaqhv+TXjjMxcoYaI3SLpiPv06/o9wqKTsXAGp8jkMXK+kpPA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=google.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CrDnP7o1RpGdk4ZHeIQjOiIhLr4RIX1gVEaI4JdGzbc=;
 b=oGHbK7yY9O/6ZKQVymaYjmUidoipwuOMQjmoRHt3Th5eDZrzJWOqVZWPRUfKXQeHEoITaHESBtiU8peh4adQDX+ThBjm2BHRKEDALL2l1lrh1la+LutcHFS0nQFH+RqlPcsCfXsbWFCbMecuZfDfrKgFN13N63+IWP0mG6P/qzc=
Received: from AM9P193CA0002.EURP193.PROD.OUTLOOK.COM (2603:10a6:20b:21e::7)
 by VE1PR08MB5598.eurprd08.prod.outlook.com (2603:10a6:800:1a2::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.14; Thu, 13 Aug
 2026 20:06:38 +0000
Received: from DB5PEPF00014B8E.eurprd02.prod.outlook.com
 (2603:10a6:20b:21e:cafe::5c) by AM9P193CA0002.outlook.office365.com
 (2603:10a6:20b:21e::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.14 via Frontend Transport; Thu,
 13 Aug 2026 20:06:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB5PEPF00014B8E.mail.protection.outlook.com (10.167.8.202) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.339.3
 via Frontend Transport; Thu, 13 Aug 2026 20:06:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VjobpwI54a1MfezbK5haqlyPeVcDS7wCOpIrYQinKZXeJr6loEAKEJneOzpkaIMfD034SldLyeB2rmk9PWrFMixhaJY73cEKj7wPMce8X0BugiABE1kq+xdrheK8mUCSPpGLHJYfNeeX9z3jVq1qcAU6nE7kODmAxn0ae/SdfYtfUQY7HR40wV9F6/t7vyA5QbnxFFyITjk0Rry51EvoF9pP74bk1ydKvh7Md3LuC8xM/I9XND6mMVvvPtE+fZ8Y+bqdnt25ZniIp2N+kGhTaxQscu64PhQM30aN6fj7RZzVELhCDf2OSTLaGEQVu4ppyd078l0b6r71iR9TjE6wiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CrDnP7o1RpGdk4ZHeIQjOiIhLr4RIX1gVEaI4JdGzbc=;
 b=hTk7NW2iP4r8/EehnM6gqW3qSgZmuT5UvRlDj7IrcYxqMP5lvaB0aJQcHADDP3cTXiY0cQMEm5KEp7vQTsp3QTTF/8WiYJfawtSgl84yyaiWKXj9I/5Xrj39ZDaYcgfKQJ1zfzQ6h7yAjBQr+n5ROZwiYyn6atRiwbvy+e71eixtUBLGxxjRMN9E+kO3GOT8Q/h0RhnHKxnnJSBcx3uo9lY8jrUwze8INQjQZSEXeF8KP/n7TX2vi0AC6IuNlhhig4WFvDthykNDiSDvBhv1VwPwH/UOo2wK8R1O5flStr/G12CexEF7Bd6ZsdTwjcmU/C2hsm5V1V0sGHS1pziQfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CrDnP7o1RpGdk4ZHeIQjOiIhLr4RIX1gVEaI4JdGzbc=;
 b=oGHbK7yY9O/6ZKQVymaYjmUidoipwuOMQjmoRHt3Th5eDZrzJWOqVZWPRUfKXQeHEoITaHESBtiU8peh4adQDX+ThBjm2BHRKEDALL2l1lrh1la+LutcHFS0nQFH+RqlPcsCfXsbWFCbMecuZfDfrKgFN13N63+IWP0mG6P/qzc=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from AS8PR08MB9597.eurprd08.prod.outlook.com (2603:10a6:20b:61b::18)
 by DU2PR08MB7311.eurprd08.prod.outlook.com (2603:10a6:10:2e6::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.13; Thu, 13 Aug
 2026 20:06:04 +0000
Received: from AS8PR08MB9597.eurprd08.prod.outlook.com
 ([fe80::e11:42b9:2ed1:ef5f]) by AS8PR08MB9597.eurprd08.prod.outlook.com
 ([fe80::e11:42b9:2ed1:ef5f%4]) with mapi id 15.21.0315.014; Thu, 13 Aug 2026
 20:06:04 +0000
Message-ID: <b6080c23-a2a8-4bc5-b3bd-982bd766c648@arm.com>
Date: Thu, 13 Aug 2026 22:01:33 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/3] KVM: Dirty page logging for guest_memfd-only
 memslots
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>,
 Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com,
 kvm@vger.kernel.org, maz@kernel.org, oupton@kernel.org, joey.gouly@arm.com,
 seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 fuad.tabba@linux.dev
References: <20260702142912.6395-1-alexandru.elisei@arm.com>
 <akxOrMnlNga-vtQv@google.com> <ak0wSQ1133O7B96D@raptor>
 <ak0ziUcCXUlDdcla@google.com> <ak-EKSslAz1uqEtv@J2N7QTR9R3>
 <ak_wC4Q-mQe14DI8@google.com> <alDI1b8fC99SG4_a@J2N7QTR9R3>
 <a127176a-1722-460c-aa84-754e1d343f53@arm.com> <an3sEiQlIuGEjUur@raptor>
From: David Hildenbrand <david.hildenbrand@arm.com>
Content-Language: en-US
Autocrypt: addr=david.hildenbrand@arm.com; keydata=
 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 fa0=
In-Reply-To: <an3sEiQlIuGEjUur@raptor>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0152.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:188::13) To AS8PR08MB9597.eurprd08.prod.outlook.com
 (2603:10a6:20b:61b::18)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	AS8PR08MB9597:EE_|DU2PR08MB7311:EE_|DB5PEPF00014B8E:EE_|VE1PR08MB5598:EE_
X-MS-Office365-Filtering-Correlation-Id: ee36a406-541f-47a3-339b-08def9766183
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|7416014|376014|366016|1800799024|23010399003|4143699003|11063799006|56012099006|18002099003|10067099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 OyWpD3vyn5o6QBzZg/5ttfH0U/3oKAaUi6iKKfE3NTfgfcmrTQSBffuKnaRmdubyT+e+ycUTKK9cB1u0/ki+m817u3jIoKU3wA9g6O7QOAzPMo7IStAWZhc3UYblizr+zd+WrW1D6ZZdilRabPrAvDjcXGO7h0dHPn1kv69QVQ2uvtEWpGkk5N4swowN9K9UeHqE2N37vFzcW34NHvPQWIxxQ+nFQSi5BJi57xUIjagjzeboepyYyPBb1VUtXWfsnkkfkjTClwWUja26WaXRfpU3Lc0uCfB0qCXNPu+GT0iBWcfcQ0LQsC7lZRx1QWFr9T4dIDYiIDOC4QKVpNYzd1C9HrPBcRL9JNT9+RG3mTOl/bP/bDM7i5Oaf0l6G2UNGfnxqgYjCHBR3XIopVzxU6Q4xTBcYKPO1C/66MkKJj6g5UCZQqeQ/Wo3Dxtk2u0OQ5UJthbKbzVCuUuEsKPI3J1NglJRfy0MZBRObYh8S9K5sD37IAooGBkXEVGzDngoOt2bw3LcvrRzobs2O8mC7BkaE+H6byffomkkKgfslFINzLG+9lFnlk27vKPJAxsHe0wkDBue9EtNsJDMozjuSiLf88fwEpEY4oHbwaNqHYF2ib7e4jce9RBJxm+CueKHMrVsHhzmbS6Ydriu+zTc56E5705BytC93lFLGHG8Bjo=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR08MB9597.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(23010399003)(4143699003)(11063799006)(56012099006)(18002099003)(10067099003)(22082099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 MGXr4Fawp8Ma72bbo6mYZvkddcewbCjcbcCOP8AlV6XnSLVu5L9i8N0SR5DVJZw6sh9c2AQfFNC05wECIg/Nr0cIzBfpBorbCY6Ml+wvLvPR//cTkxiLoeqX+xPLGYWzScMQP+c2kDgHHKR+R1cefR4Vfk7PJARKIhOCT4A6W/lFbiwnuWBI3LuaLjCLIL7ERa2Bqxi0bj/lPTcXCRuFrQFWlWjRxydnvNRpmBp/r4fg+4gr0x/pz1kXvZvJFnC6qqg6zaeTjE+wRc7L1kyplhL//VEwImJGRtYqlrjcWtuNBJ9n3Is2/9oNQrsjZwYcXT9r/0N50dFYOkF2sYtwnA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR08MB7311
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB5PEPF00014B8E.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	96dd180f-f4a7-4eaa-0908-08def9764de0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|82310400026|36860700016|30052699003|1800799024|35042699022|376014|7416014|14060799003|56012099006|18002099003|22082099003|10067099003|4143699003|11063799006;
X-Microsoft-Antispam-Message-Info:
	OI69o4NvcNTQ1vsezgI2CJIq8eCl8z3IEyqGmr8TzLyN7kF/p35uOi8U2zYMbv+k9ozQnypoRokZDwVjH3lAalVb4x0VffzvuD3UgvbeoZhwp5CxbhaTioFh7z04W2ktI4Yxc9ObYv5WKnqpYzFptXGv0UlNLdfoLn/f7kYet4d9TQQ6Ba9ZE8QR/fOPwAS4PqADh2/mw6ifs6QLpE6xWINxwQQNL8Ab8ZeEHeoSHxxwdydmjYZIGCLQZ06uk/GRMQzrqK1W0FylVgO2tX9xSw3Iao0akM+WkEWqF4PR+Fk/9ySt05c0uR4fpX6uwcq1XL5fuKImE4ahybn63TsrhQ8JxktQ1/Oh2zHEy7GYK/QtOWEBtxqpD1Vy8FkVz5tgfjTqElTpK1/Y19S1/ja3Ukem+hzFh4ffYqJ7L/0AIA+xjyadN+eqqPjmfHWPXJqPdvAdKRNxv7i8AEoH8RIyz1sB//TC+vchIj6ioxjESAeSSZ1tSr9d18dGpLE7xe0d+NRxArassSrzxtQWUQ9Nl3dyE1e1h+hkGS8KJCLaAWXbmq/FweiXFDFihFG/l4n97M6GTGOqMQOWUefqo+wkkPJlzt7dUs3Txcf2wO8472QkrZit38vi5/Xgl0bwGKg4SDR+jKu06k9mvWq9nAdYOTBDcbnmSdpea1gL06/yPMKCg8r1LQ+WhRgkUwJzczAvhKSGqyuUHDv1NurqLt696w==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(82310400026)(36860700016)(30052699003)(1800799024)(35042699022)(376014)(7416014)(14060799003)(56012099006)(18002099003)(22082099003)(10067099003)(4143699003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	XtNhPppKdOf4rn+sPe02/nFSKRlfenY9OJVXahdrGAp8Y9HGcFrfVbnHwJBSh9QZn029+UMYRCABzKujMSL1H02PpigDz9OBDRKwNYwB9Szwq7W/R40rtAfSjHticO2BsxZ0PXiq0sDxNhdAMkUI8vqqxisSwBQJnIfdiqDrOt/JAuIFwNEt5uqhcV5kihj9Sqv4KjCS0JAzToZnBCxJM/rri22W7bdn5njQ8FjglOTNxLlVFuEPyIezOrxHcD5c5dTeB3mWkdb57k2OiALeXjG255f2/VBvOVPqMqCzKWtoJQ1CW0YKsKfkZz+cO3vLxdZFE4ffB/iQ04QM0mreYegtm5wtbJstCTT/60bnMfsLlBm8freoRdRu6j6LWZfTCbyhtBOlPNR70TvNAG1LYLX7LPHMEZ5N0Jetda3f7Q34eplUrIGe0LI6b0H0qRly
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2026 20:06:36.9426
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ee36a406-541f-47a3-339b-08def9766183
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5PEPF00014B8E.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR08MB5598

On 8/13/26 18:09, Alexandru Elisei wrote:
> Hi Sean, David,

Hi,

> 
> On Mon, Jul 13, 2026 at 04:11:57PM +0200, David Hildenbrand wrote:
>>
>>>
>>> Yeah. I agree (with the caveats you mention). Arm folk need to go figure
>>> out if it's worthwhile to support with all those caveats.
>>
>> Right, disabling migration (once gmem supports it) was also what I discussed
>> with Alexandru when that topic comes up.
>>
>> How to communicate to gmem that it wants these fixed mappings is a good question.
> 
> There's already a proposal for how to do this in the migratable guest_memfd
> series [1] - it's a new guest_memfd creation flag that disables migration.
> 

In the guest_memfd call I was arguing against the flag in the first version, and
instead adding it when actually required.

I was also raising whether KVM couldn't tell guest_memfd (e.g., at creation
time?) that it supports a CPU feature that requires S2 to be always mapped to
disable migration.

It would then be a contract between KVM and guest_memfd without user space
having to be involved on that level.

> With Sean's comment that he expects swap/reclaim to be fully userspace
> driven, I believe that would be enough to guarantee on the _kernel_ side
> that SPE will work as intended for a guest.

That's my understanding.

> 
> I'm a slightly concerned though that all of this will work by chance, and
> not by design, and in the future the behaviour might change to allow
> guest_memfd memory to be unmapped from stage 2 without the VMM or KVM
> explicitly allowing it or initiating it.

Thus my idea of the explicit contract between KVM and guest_memfd. Instead of
being a "this doesn't support migration" it would be a "S2 always mapped"
kind-of contract.

> 
> My understanding from the conversation so far is that the plan for the
> future of guest_memfd is to support an option/mode where the memory is
> effectively "pinned" at stage 2 (but which allows userspace to explicitly
> free/unmap it, of course). Is that correct, or am I being overly optimistic
> in my interpretation?

We could then even disallow fallocate() to punch holes if that contract is
negotiated.

-- 
Cheers,

David
