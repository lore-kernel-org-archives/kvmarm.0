Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012066.outbound.protection.outlook.com [52.101.66.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B751637B021;
	Wed,  8 Jul 2026 14:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.66
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783522052; cv=fail; b=dT3TXk2qePVyfvr7Y8px/Vkl60ymJIyZKShdHzX8+TKIE9ct/MSrZAkV5n9ldw429/TnfGO3DuuHyxt04hJVbjENDBjNT4b8ikjpERyh+3d7VLT6TI1cpfmexD8xY+h/QyNhrRz0ZonUPAj7OX/fkX9kdnZKwzt6aBelMvmqXv8=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783522052; c=relaxed/simple;
	bh=dnkrnCg8Mi7FqwIXjQSNVhmvdQ/J91CF1pmoAauL10k=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=R83TJTCGyhVUBWl79/nJIZYLClysxCLZB8qgSJO9ccsFv4apQtG0oAMBAr3MXeeE0LNiiViIy92VcfCy6e1pVx/yMF6n+h+8yk5tIBtMIp0Kv60/d/19ZpGJDOrDHgyFvm42qGie1AFebrZvwLi6oOjG50ervyRfImWzztlZgzQ=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=AsYq2aD4; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=AsYq2aD4; arc=fail smtp.client-ip=52.101.66.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="AsYq2aD4";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="AsYq2aD4"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=xsZD+xre2vfpXZ2VNrEL+0K/1k1zhQmSs30CtSw/UWwkPppgl7fILZKyOkwE99YiMJRXV5PhR6G5f2hZDaapLkdCVYue/jSpulsfETEj1mL3JgOeYJXwKHFMoyka5i0BI6mfz5Qmr2TuACrH+CL0lyZJrmccmjgztCloxu/SCEtLRBD8pIpCzBM7MchAELWf/28Dnk9iCuRnFMCoBBEvAkQl/x2JMcOI4ll9AErTTc64nNeebibH8KmlWadk42ElHUaG/SbrYct0UWERy6JID02mNg+jxwQpD1X5+WlO+rgGGIDESJa3GHzW08zKltxQHcP9qnnpLEPDXP222GHqyw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dnkrnCg8Mi7FqwIXjQSNVhmvdQ/J91CF1pmoAauL10k=;
 b=n65x0BtEdfwva9OkqEkuGv86xW8Azv4mvfCH6a/QDdXyrQXqauuApuwK867+k/hNWoFgwyeXkrH0HDze+vvZX05CNP44OLJ3YWh30kdMxlXVUyRIhqjAC9vspkqricy4zMKYiThUfuZDow41la+hj4SDXV3NsIQ1SMA+x8tYW5Rh82s9d1uFk/tklr+OkG94CqzES7Pb8gsdHIV8OCdQO0BRTvOurOQF50XyPWfPXZgKEKytTkrjVzQ+BPJP5rNwYb8HvnX8hA//OYwYpJ7J3Eksj6XqsmzsX81HbjKLv9qSoc8xyKD54g1s2puBNGxSR9Sbr44+CNRMilbGR8IAcQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dnkrnCg8Mi7FqwIXjQSNVhmvdQ/J91CF1pmoAauL10k=;
 b=AsYq2aD4GlIHYG3fdpyqSgQg5t7K6uVXob8JjgZ4CoensUvDnKp/AzgMsT/z+XourUaVAuERIG/LytH3S+j2eiUl9LvamFcAEQHiFgVpiT33hSBfTRt/RNnCbxXlQK+WPvzBLXfxv9ixG2t4tE+IuNvS7oa2lcysE8TFb8mNkIk=
Received: from DU2PR04CA0340.eurprd04.prod.outlook.com (2603:10a6:10:2b4::12)
 by AS8PR08MB8135.eurprd08.prod.outlook.com (2603:10a6:20b:560::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Wed, 8 Jul
 2026 14:47:24 +0000
Received: from DB1PEPF000509FB.eurprd03.prod.outlook.com
 (2603:10a6:10:2b4:cafe::25) by DU2PR04CA0340.outlook.office365.com
 (2603:10a6:10:2b4::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.202.10 via Frontend Transport; Wed, 8
 Jul 2026 14:47:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509FB.mail.protection.outlook.com (10.167.242.37) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.6
 via Frontend Transport; Wed, 8 Jul 2026 14:47:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LUiBpZ0ZwcESeBQOKA2V7hFg/9PqYiOAFsSSSNjaqkLr/h+MzDX7HfszzD9PgK0oEnRKrW2v/gT75jOStgKs/3CITclpwJdpEDwEtLe1UZmm5fk0QFnKpwgOtvggEmv8v6FRtwMb3cajlViBTTSTY0aUeKkyfSikF+kEAYK6iLDc9KAfkn05le6cWWKPX24ut9Gxua+Elx36wKtymV+f9giWPkDpnNcQM0FBbVhIWhIYQKL/zbIzTBoJj3tcxWT4hL70GhpKr0VBAmRZu5ktwYQMNQbSI8tobz96i8qzoolsC5IWiTf8hg2w4Qu/ifito7cs69XPFNPcmW0fnhDOkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dnkrnCg8Mi7FqwIXjQSNVhmvdQ/J91CF1pmoAauL10k=;
 b=Fl3NkG/yTryvqctukxNNcY+WUzwabf9iJRF554dm0DYtwc7FsYfzGAFvqI08Li3qsaRaXFdad0tbWas2b/cQTy8iuKaZ3cSij4yMLI59+gqIuYblsHnByxSDzvXGSOcHNhDhKgsa26K2oq+Oeqw0Mkfyk4ITIeNib3buBD4Vb5d6VjqfOUx3aRDEIC2OH07PRVSvR9zADoQj3CaXZfTVi6hQa21IpNR6+atVWfF4Gg2bRWdXuAWyhRIipxaxPQvqAHT2Ibm7F8ihIGuimFBnpmnQVTqjnq7/o0FeDMvldbb1W9sEgsJqTtoPELNCncHHiXYeMOQoCY9ytjjSs+iQZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dnkrnCg8Mi7FqwIXjQSNVhmvdQ/J91CF1pmoAauL10k=;
 b=AsYq2aD4GlIHYG3fdpyqSgQg5t7K6uVXob8JjgZ4CoensUvDnKp/AzgMsT/z+XourUaVAuERIG/LytH3S+j2eiUl9LvamFcAEQHiFgVpiT33hSBfTRt/RNnCbxXlQK+WPvzBLXfxv9ixG2t4tE+IuNvS7oa2lcysE8TFb8mNkIk=
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com (2603:10a6:10:407::19)
 by DB9PR08MB7560.eurprd08.prod.outlook.com (2603:10a6:10:307::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Wed, 8 Jul
 2026 14:46:19 +0000
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e]) by DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e%5]) with mapi id 15.21.0181.009; Wed, 8 Jul 2026
 14:46:19 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>
CC: "maz@kernel.org" <maz@kernel.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"oupton@kernel.org" <oupton@kernel.org>, nd <nd@arm.com>
Subject: Re: [PATCH v3 10/40] KVM: arm64: gic-v5: Introduce guest IST alloc
 and management
Thread-Topic: [PATCH v3 10/40] KVM: arm64: gic-v5: Introduce guest IST alloc
 and management
Thread-Index: AQHdCwRkIMNo+jdCqE6H51OdjKk18bZb/bKAgAe9VYA=
Date: Wed, 8 Jul 2026 14:46:18 +0000
Message-ID: <cf3d4d60f1e40f33b659ef0747627ea9d8639f98.camel@arm.com>
References: <20260703154811.3355680-1-sascha.bischoff@arm.com>
	 <20260703154811.3355680-11-sascha.bischoff@arm.com>
	 <20260703163449.9546F1F000E9@smtp.kernel.org>
In-Reply-To: <20260703163449.9546F1F000E9@smtp.kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU0PR08MB8421:EE_|DB9PR08MB7560:EE_|DB1PEPF000509FB:EE_|AS8PR08MB8135:EE_
X-MS-Office365-Filtering-Correlation-Id: c72cfd95-a58f-4673-bc70-08dedcffd2e5
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|4143699003|11063799006|56012099006|6133799003|38070700021|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info-Original:
 S6VUK8wrbwvQXyK85zKqwL9w+TM2xa/Awrk3mKqwlbOKF5EoEVXM47Iya7vwM1554CmlIXaHVVA6HOprNetlnNjEzurU5VrDBZgax6OEPBv5QiY3Yh3H/vkjsMLOBxKvT47+YwNBXtQYiwtz2+rI+FF+fKvP14vCmGfJMzUj8Qd7XjOde5qodfskaoGz90ufjgM0VHPgP9cpyixQYmIUdcm6yihhMH8z7u2q7OhrctwjvUc0e5hpBDYwHwg7UM78Fklv/qyMHKuuMK+fxVXbKwEJt0wJX+MoleoP3hF3/sJOWUimy4SmJUMpiRa2oIQvp4QEvUxVUyotmrI9RfOJPv9nkVEpoAyQqWdtQPJx+ziyvJm3O8F6EF1351DuQEaupyBsfFSxhAjSrEul3RFigyozkOd0trpxEjv+Pql7xAe+BEYD6MGSNZ1i8I9Bx2bSgp0StxuHiE8qXmRjAVQWMV45qBKTN5lERwUgFdb68ygY0rBL7SKPa8KfWwR/UjDH7O0EflwYRU/KH5Qw+XSmiN7yIDY3y4wGdYYYEYn6dANIx3EapyGQIIqqvATHZHmvsiefm9lI3HtSMtDAWD4TuYgv1BHGQ0vcGv0Z6u5f4OPdcWn8XnXfYQtlQFkOToonoOfE8NU10qQu1GruQBdtrD6cRYwNpkAyICRkabS+JBLOrymWZ9LhlbbUFridnU9uP4W3Z5PAX9ZEQsTGIir8QalqPcgyBvCvlM74iSYNU9g=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB8421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(4143699003)(11063799006)(56012099006)(6133799003)(38070700021)(22082099003)(18002099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <23C5BE51D76C08468996A55E814233EC@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 PD7NhPEcwPoUBnGZ080JmpLnUM6bEmIAec3MKAnb5OLyUNetY/SN9gSXEvPaUvR7dlS+E0CeaRjAp60LrfHRxv9DU4lBB2MUQoau8Ky3cfPsKFCDiebSyzWecV5XgbIzrJeYHogzRI1WMm2zQSSbRZv9xj9RhV3nH2mrvnZLZhTKBzRand7MtZRhuE7yruIAiRmHSP7ra4GGA8n7Cq3omJcw11VkORgVB+T2qZBbwxQZdXpVsRoi5gVITTwN/mMUIH5GEBwXVehX8UQW2iKFOf3gimVUKbS575ODHqTL2N+M8gQ+IGd9X9am4mXbiPHo9FOLiXMGkGnyhmQDrX5rKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB7560
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509FB.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	9991386a-52d1-4c23-2f56-08dedcffabbf
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|376014|23010399003|35042699022|1800799024|82310400026|36860700016|22082099003|11063799006|6133799003|4143699003|18002099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	Ze5G5Gs0RIu8yEH2sbJi5mTcPZHapzKOPwxN9cprcrLkBMRKcCS0Pshc5HF6MEeF8UXqsGD8l5SGn9zfxQ5aBLZc+671zpC97sfH4cowI2y5umr5O7k0opcM4WBEOQL4UzXJ/1mFcqrv1okegw4k4YOIFCQ2pmcPzwX1v6Op0XI+MCuWFEvSdDH5WEXbSAIkT5/T4R3jLRcAin9f8rb25p4NF+EAd0MUDxhQpsnk9rAP/9SdCQfjEr/SB094CG3f/901sLL45FJBTnxnks+JSJFTDtKbMCEnMpN/LiRg2hdoLsWG1LM0XpMClkAlX5Y49b3J5OKDPowG86O/lfhLLgBW0e24Yx+Ub7zZqCAt3k06EHZlQ35FeZSgQdJsgnOHgmXlpb4FSDJO/UWbFnb/ywirVe09E/Y4jU0AvdPbqWR+LoqzJvj4/gfmG4jJFG4yBuhiDX/nsyowjdWeHdO2UnGD0Oz4y9jTBjWqcKykqu36SJD4XVBYkrHa0roMxFT6aWSDLMcYP0J5nY0Gl3nMKZpwEfONSzoozTtVAi7hvq7Mlffi9K+XhA1aiCxKts+H7fKBaqaVnHDcL5efE464xPYDRrCKHH2kj/PUht5oAt5YecHvErFprjKadVFj5uzwaBfgtOB/7V0R9cyYekOPp9xBOJH8aL3Rla8igDRb2Hr+RF4kYJHhzhBGtYwRbrCmv+oKHBedGYyhwNfPUXko8Q==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(376014)(23010399003)(35042699022)(1800799024)(82310400026)(36860700016)(22082099003)(11063799006)(6133799003)(4143699003)(18002099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	X2vf6fyezqPJVW5tzgi4WC87wLgZc7oMVs35H877mHgjQOEhsG/QER6M7/Q0ebPXvUETSiN0wVJqjHIMsgVHUgE4S2L4eBBNNjD0uraRG0Tel4Trx56TvEZaEGC9McZTQufS0bzW/5PgQxwI99FhfZXRs5x1qPQejmfXFPpI8SxUHMDW86895lfO0ZZgRfyj+QEKEKiAteUhf6cTHjovP8BW4hhSGXhP/L+xo2oIVvGVuwQ1ERmTYDTgvch4qU1jPc4pfHB+v5H+dkZo6fAUVw6F/K6N9u6zl1kzli4kL7sYzk3JfWxa5WMKMy449wfh8j5ohgy1rLRwFv013aIjVjYw4MtDwSKQfn1Xl/qbkIScUTf3amrcODtdUbIiAS8lpgK/o+FmRUZkdkBCobfB8Pjz+KFvHGhg6RDExSX5XyWeMGcxWgZECHJoBO3ad60t
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2026 14:47:24.5143
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c72cfd95-a58f-4673-bc70-08dedcffd2e5
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509FB.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB8135

T24gRnJpLCAyMDI2LTA3LTAzIGF0IDE2OjM0ICswMDAwLCBzYXNoaWtvLWJvdEBrZXJuZWwub3Jn
IHdyb3RlOg0KPiBUaGFuayB5b3UgZm9yIHlvdXIgY29udHJpYnV0aW9uISBTYXNoaWtvIEFJIHJl
dmlldyBmb3VuZCAyIHBvdGVudGlhbA0KPiBpc3N1ZShzKSB0byBjb25zaWRlcjoNCj4gLSBbSGln
aF0gSW50ZWdlciB0cnVuY2F0aW9uIG9mIElTVCBhbGxvY2F0aW9uIHNpemUgY2F1c2VzIHplcm8t
c2l6ZWQNCj4gYWxsb2NhdGlvbnMgYW5kIGhhcmR3YXJlIG1lbW9yeSBjb3JydXB0aW9uLg0KPiAt
IFtMb3ddIEVuZGlhbm5lc3MgdHlwZSBtaXNtYXRjaCB3aGVuIHBhcnNpbmcgVk1URSBzdGF0ZSB1
c2luZw0KPiBgRklFTERfR0VUKClgLg0KPiAtLQ0KPiANCj4gY29tbWl0IDFiYzU3ZGE3OTlmMTEy
NWI0N2VlNDdkMDE1NjgwMmNjMDQyMDA2OTYNCj4gQXV0aG9yOiBTYXNjaGEgQmlzY2hvZmYgPFNh
c2NoYS5CaXNjaG9mZkBhcm0uY29tPg0KPiANCj4gS1ZNOiBhcm02NDogZ2ljLXY1OiBJbnRyb2R1
Y2UgZ3Vlc3QgSVNUIGFsbG9jIGFuZCBtYW5hZ2VtZW50DQo+IA0KPiBHSUN2NSBndWVzdHMgdXNl
IEludGVycnVwdCBTdGF0ZSBUYWJsZXMgKElTVHMpIHRvIHRyYWNrIGFuZCBtYW5hZ2UNCj4gdGhl
DQo+IGludGVycnVwdCBzdGF0ZSBmb3IgU1BJcyBhbmQgTFBJcy4gVGhpcyBjb21taXQgcHJvdmlz
aW9ucyBtZW1vcnkgZm9yDQo+IG1hbmFnaW5nIGEgZ3Vlc3QncyBTUEkgc3RhdGUgYW5kIHNoYWRv
dyBMUEkgSVNUcyBwYXNzZWQgdG8gdGhlIGhvc3QNCj4gSVJTLg0KPiANCj4gPiBkaWZmIC0tZ2l0
IGEvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLXY1LXRhYmxlcy5jDQo+ID4gYi9hcmNoL2FybTY0
L2t2bS92Z2ljL3ZnaWMtdjUtdGFibGVzLmMNCj4gPiBpbmRleCBkYjhjYjZhMzg0OTk0Li43OWIz
MDVkMmQ1MDk3IDEwMDY0NA0KPiA+IC0tLSBhL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy12NS10
YWJsZXMuYw0KPiA+ICsrKyBiL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy12NS10YWJsZXMuYw0K
PiANCj4gWyAuLi4gXQ0KPiANCj4gPiArc3RhdGljIGludCB2Z2ljX3Y1X2FsbG9jX2xpbmVhcl9p
c3Qoc3RydWN0IGt2bSAqa3ZtLCBib29sIHNwaV9pc3QsDQo+ID4gKwkJCQnCoMKgwqAgdW5zaWdu
ZWQgaW50IGlkX2JpdHMsIHVuc2lnbmVkDQo+ID4gaW50IGlzdHN6KQ0KPiA+ICt7DQo+ID4gKwlj
b25zdCBzaXplX3QgbiA9IGlkX2JpdHMgKyAxICsgaXN0c3o7DQo+ID4gKwl1MzIgdm1faWQgPSB2
Z2ljX3Y1X3ZtX2lkKGt2bSk7DQo+ID4gKwlzdHJ1Y3QgdmdpY192NV92bV9pbmZvICp2bWk7DQo+
ID4gKwlfX2xlNjQgKmlzdDsNCj4gPiArCXUzMiBsMXN6Ow0KPiA+ICsNCj4gPiArCXZtaSA9IHhh
X2xvYWQoJnZtX2luZm8sIHZtX2lkKTsNCj4gPiArCWlmICghdm1pKQ0KPiA+ICsJCXJldHVybiAt
RUlOVkFMOw0KPiA+ICsNCj4gPiArCS8qDQo+ID4gKwkgKiBBbGxvY2F0ZSB0aGUgSVNULiBXZSBv
bmx5IGhhdmUgb25lIGxldmVsLCBzbyB3ZSBqdXN0DQo+ID4gdXNlIHRoZSBMMiBJU1RFLg0KPiA+
ICsJICovDQo+ID4gKwlsMXN6ID0gQklUKG4gKyAxKTsNCj4gPiArCWlzdCA9IGt6YWxsb2MobDFz
eiwgR0ZQX0tFUk5FTF9BQ0NPVU5UKTsNCj4gDQo+IFtTZXZlcml0eTogSGlnaF0NCj4gQ2FuIHRo
aXMgY2F1c2UgaW50ZWdlciB0cnVuY2F0aW9uIGFuZCB6ZXJvLXNpemVkIGFsbG9jYXRpb25zIGlm
IGENCj4gZ3Vlc3QNCj4gcmVxdWVzdHMgYSBsYXJnZSBMUEkgSUQgc3BhY2U/DQo+IA0KPiBJbiB2
Z2ljX3Y1X2FsbG9jX2xpbmVhcl9pc3QoKSwgdGhlIGFsbG9jYXRpb24gc2l6ZSBpcyBjYWxjdWxh
dGVkIGFzDQo+IEJJVChuICsgMSkNCj4gYW5kIHN0b3JlZCBpbiBhIDMyLWJpdCB1MzIgbDFzei4g
VGhlIHZhbHVlIG4gaXMgZGVyaXZlZCBmcm9tIGlkX2JpdHMNCj4gKyAxICsNCj4gaXN0c3ouIElm
IGEgZ3Vlc3QgcmVxdWVzdHMgYSBsYXJnZSBMUEkgSUQgc3BhY2UgKGUuZy4sIGlkX2JpdHMgPSAz
MSkNCj4gb24gYQ0KPiBzeXN0ZW0gdGhhdCBmYWxscyBiYWNrIHRvIGxpbmVhciBJU1RzLCBuIGV2
YWx1YXRlcyB0byAzNC4NCj4gDQo+IEJJVCgzNSkgZXZhbHVhdGVzIHRvIGEgNjQtYml0IHZhbHVl
IHRoYXQgaXMgc2lsZW50bHkgdHJ1bmNhdGVkIHRvIDANCj4gd2hlbg0KPiBhc3NpZ25lZCB0byBs
MXN6LiBUaGUgc3Vic2VxdWVudCBremFsbG9jKDApIHN1Y2NlZWRzIGJ1dCByZXR1cm5zDQo+IFpF
Uk9fU0laRV9QVFIuIEtWTSB0aGVuIGJsaW5kbHkgcGFzc2VzIHRoZSBpbnZhbGlkIHBzZXVkby1w
aHlzaWNhbA0KPiBhZGRyZXNzIHRvDQo+IHRoZSBoYXJkd2FyZSBWTVRFLCB3aGljaCBjYW4gbGVh
ZCB0byBzZXZlcmUgaG9zdCBtZW1vcnkgY29ycnVwdGlvbiBvcg0KPiBJT01NVQ0KPiBmYXVsdHMg
d2hlbiB0aGUgaGFyZHdhcmUgcm91dGVzIHZpcnR1YWwgaW50ZXJydXB0cy4NCg0KTm8sIHRoaXMg
aXMgbm90IGFuIGlzc3VlLg0KDQoxLiBUaGUgYXJjaGl0ZWN0dXJlICJvbmx5IiBzdXBwb3J0cyB1
cCB0byAyNCBJRCBiaXRzLg0KMi4gV2UgbGltaXQgYSBndWVzdCB0byBhdCBtb3N0IDE2IExQSSBJ
RCBCaXRzIChvciBmZXdlciBpZiB0aGUgaGFyZHdhcmUNCml0c2VsZiBnaXZlcyB1cyBhIGxvd2Vy
IGxpbWl0IHRoYW4gdGhhdCkuDQozLiBXZSBjaGVjayB0aGUgZ3Vlc3QtcHJvdmlkZWQgSUQgYml0
cyBhZ2FpbnN0IHRoZSBsaW1pdHMgd2UndmUgZXhwb3NlZA0KdG8gdGhlIGd1ZXN0IGluIHRoZSBJ
UlNfSUR4IHJlZ2lzdGVycy4NCg0KPiANCj4gWyAuLi4gXQ0KPiANCj4gPiArc3RhdGljIGludCB2
Z2ljX3Y1X3R3b19sZXZlbF9pc3RfZnJlZShzdHJ1Y3Qga3ZtICprdm0sIGJvb2wgc3BpKQ0KPiA+
ICt7DQo+ID4gKwl1bnNpZ25lZCBpbnQgaWRfYml0cywgaXN0c3osIGwyc3o7DQo+ID4gKwl1MzIg
dm1faWQgPSB2Z2ljX3Y1X3ZtX2lkKGt2bSk7DQo+ID4gKwlzdHJ1Y3QgdmdpY192NV92bV9pbmZv
ICp2bWk7DQo+ID4gKwlzdHJ1Y3Qgdm10bDJfZW50cnkgKnZtdGU7DQo+ID4gKwlfX2xlNjQgdG1w
Ow0KPiA+ICsJaW50IHNlY3Rpb247DQo+ID4gKw0KPiA+ICsJLyogV2UgZG9uJ3QgY3JlYXRlIHR3
by1sZXZlbCBTUEkgSVNUcywgc28gZnJlZWluZyBpcyBhIGJhZA0KPiA+IGlkZWEhICovDQo+ID4g
KwlpZiAoc3BpKQ0KPiA+ICsJCXJldHVybiAtRUlOVkFMOw0KPiA+ICsNCj4gPiArCXZtaSA9IHhh
X2xvYWQoJnZtX2luZm8sIHZtX2lkKTsNCj4gPiArCWlmICghdm1pKQ0KPiA+ICsJCXJldHVybiAt
RUlOVkFMOw0KPiA+ICsNCj4gPiArCXNlY3Rpb24gPSBHSUNWNV9WTVRFTDJfTFBJX1NFQ1RJT047
DQo+ID4gKw0KPiA+ICsJaWYgKCF2bWktPmhfbHBpX2lzdF9zdHJ1Y3R1cmUpDQo+ID4gKwkJcmV0
dXJuIC1FSU5WQUw7DQo+ID4gKw0KPiA+ICsJdm10ZSA9IHZnaWNfdjVfZ2V0X2wyX3ZtdGUodm1f
aWQpOw0KPiA+ICsJaWYgKElTX0VSUih2bXRlKSkNCj4gPiArCQlyZXR1cm4gUFRSX0VSUih2bXRl
KTsNCj4gPiArDQo+ID4gKwl0bXAgPSBsZTY0X3RvX2NwdShSRUFEX09OQ0Uodm10ZS0+dmFsW3Nl
Y3Rpb25dKSk7DQo+ID4gKw0KPiA+ICsJaWRfYml0cyA9IEZJRUxEX0dFVChHSUNWNV9WTVRFTDJF
X0lTVF9JRF9CSVRTLCB0bXApOw0KPiANCj4gW1NldmVyaXR5OiBMb3ddDQo+IFRoaXMgaXNuJ3Qg
YSBidWcsIGJ1dCBkb2VzIHRoaXMgY2F1c2Ugc3BhcnNlIHdhcm5pbmdzIGR1ZSB0byBhbg0KPiBl
bmRpYW5uZXNzDQo+IHR5cGUgbWlzbWF0Y2g/DQo+IA0KPiBJbiB2Z2ljX3Y1X3R3b19sZXZlbF9p
c3RfZnJlZSgpLCBsZTY0X3RvX2NwdSgpIGlzIHVzZWQgdG8gY29udmVydCB0aGUNCj4gVk1URQ0K
PiBlbnRyeSB0byBuYXRpdmUgZW5kaWFubmVzcy4gSG93ZXZlciwgdGhlIHJlc3VsdCBpcyBhc3Np
Z25lZCB0byB0bXAsDQo+IHdoaWNoIGlzDQo+IGRlY2xhcmVkIGFzIF9fbGU2NC4gVGhlIG5hdGl2
ZSB2YWx1ZSBpcyB0aGVuIHBhc3NlZCBpbnRvIEZJRUxEX0dFVCgpLA0KPiB3aGljaA0KPiBleHBl
Y3RzIGEgbmF0aXZlIHVuc2lnbmVkIGludGVnZXIgdHlwZS4gV2hpbGUgdGhpcyBjb21waWxlcyBh
bmQNCj4gZnVuY3Rpb25zDQo+IGlkZW50aWNhbGx5IHRvIHU2NCBiZWNhdXNlIF9fbGU2NCBpcyBp
bnRlcm5hbGx5IGFuIHVuc2lnbmVkIDY0LWJpdA0KPiBpbnRlZ2VyLA0KPiBpdCBicmVha3MgZW5k
aWFubmVzcyBzZW1hbnRpYyBjb250cmFjdHMuDQo+IA0KQWgsIHllcy4gVGhpcyBpcyBhbiBpc3N1
ZS4gQ2hhbmdlZCB0byB1c2UgdTY0LCBub3QgX19sZTY0Lg0KDQpUaGFua3MsDQpTYXNjaGENCg==
