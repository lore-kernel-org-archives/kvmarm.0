Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012005.outbound.protection.outlook.com [52.101.66.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EEBA379C44;
	Fri,  4 Sep 2026 10:15:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.5
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788516963; cv=fail; b=tufR9D6YF1IAOxjgzylFGPs6hFahX3U9xktppQPCQjRmU7mCSPXaIeXlLbbtki56HAO7ikj0fGZCUPkLAE9c8wxyQ35MDFrtlEamrxd2CBPyAQJVBg1ysXg/2+VBfplBZLAOsXzqC+Ss7H1oDf8KtojsbNANGaSrmicXqQJa+oc=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788516963; c=relaxed/simple;
	bh=3YmMzhzlj/kbaLsfCnheAROX7w3lPdguJZcvfJ5evUg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=gTsp/55QZsgQoWPoUHmVkww0kMP7kCbARRAZfY0sqxVffsNpOAgbM6SPTL+aiJh8fuOhGJ8MnqZ2uvLh0zy1iPFwNDbZ6nf/9qbPGYwoYxQnTAahvefyfJK0fqFh1+ncJpFt5/xzIvOp0GfbGzNjl1xChH76JELDqOrMuUJS2D4=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=LkjH9gpe; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=LkjH9gpe; arc=fail smtp.client-ip=52.101.66.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="LkjH9gpe";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="LkjH9gpe"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=DXV1NXbiQ/RLzQ417wjRu9Iqqx9IsAdvM0Co/VNlMgUbtkuHUicnT3m5tdudTYFNsSQwdpue/fa9jAgRthYAsUewA4mO3BwrKh7iTukOY4AGrVuVJzrOXRiGFzhvrRYktaylneIf16rZGX5w/YfzDysxRbIl+RgS/tmUVEIXj9eYTFNmIF24IFbnJ1an+7y/DWVQMFV6YcVvRAUIw3U+mvf8pbyWNcFGyQu/0CZl4WjR0rCyOQ0wMUciAafStLtETgpW3GpJzKHxpjKVU5JRzoguLOvFuURnmW6NlC0igZQ+jBZ/pwHynNKpRMcWcAXCArVjZfEYpFVGbSRLfhbxow==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3YmMzhzlj/kbaLsfCnheAROX7w3lPdguJZcvfJ5evUg=;
 b=m+EE1a+0mu/XG5pGGb196+MQ9uDeOGvthlGiReZ7FtZlloH1njJdInyBfHq+JazYgLWdfGKmtVWsajdcG5pQMrKaHO4AjD6NGg+CmrHUIDWgQVIyFHi6nLBSHOpEY3IWaIu+ElGZmRY8rjpUV6QzcH/lbZ6+BtUil8ENs4oT7Vatb2Mx3sAfeq7rcgBbz7ro3khXNoht67DYKM28CP0UNNX4P4hKFFcTTGw6yiIZmI7sTDTmfvvIhHMoMci9rVzeCGcnYUWkPSF+6FFJSoLQ/ji2IucxKDTtUqFMlJgwsAhB+NhpupEZpOlaakjCu260FMfVn/FdhmEL0vrGYPYPBQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3YmMzhzlj/kbaLsfCnheAROX7w3lPdguJZcvfJ5evUg=;
 b=LkjH9gpecek678Xs86wz5PyizyEgB2wM1OqH1ijuYJzWq5qoFe/CfGTjxza5fAiIADJC8IEh2C9DDqXGK20DquODrCVegFlXtK5nv1vwIhtxzvz2jVViq4fcV4PAYBjmlTC1eT4IjlwSoyQsrEdK7cvBwflHEToxAnHhxqixTSE=
Received: from PAZP264CA0220.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:237::34)
 by AM8PR08MB6435.eurprd08.prod.outlook.com (2603:10a6:20b:317::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 10:15:51 +0000
Received: from MI3PEPF00008555.eurprd05.prod.outlook.com
 (2603:10a6:102:237:cafe::6f) by PAZP264CA0220.outlook.office365.com
 (2603:10a6:102:237::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.12 via Frontend Transport; Fri, 4
 Sep 2026 10:15:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 MI3PEPF00008555.mail.protection.outlook.com (10.167.240.9) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.8
 via Frontend Transport; Fri, 4 Sep 2026 10:15:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XubryzU5BXr805JLABtUKErfDols3tcDIvjNptj+EWadQHNvrqYIfEc8KQ1XIRuSS/F4kdAzJPXimMExVRbDz+nNeCdfyIf/ob3JjaA7po7r7SEhra3LUCgmmxNcj6raqSKLqxbBcimHqiHvFRsxDvFh1qbDevwZsXX6eYrOnA3EkC9loE844vEfvluC67T1YWBdxIoB0fX3Ckv6qjntz1hArxmCggZVr0on4b4NHoneSVjDfTmjMXrdHAecSocMOfdMXt3zZMjJAvHRDISNP10wK0JG+ceybdBEa7fVUtVMevuqe4ol9Ixy7es3drwFqK/o+pJRYvmZp3KxvznDSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3YmMzhzlj/kbaLsfCnheAROX7w3lPdguJZcvfJ5evUg=;
 b=D2BOvunIK0XoYzpXZu1iiiYGsatw1tPGdVF4LRFV5ybDvmxHXNW2a1vcAx1Vc14JdERFeMs+j2y1B9OApRs+3ZMLtmdOcDX9xV+M8yFx5U+HldgP/Jrk3q030nDeEc1y8oc4PqLSw5qLJucqGQ2dikof54PzwjQnPHM2BGS+C8aAj+D+mlJjI5Hr9CdO5gOsO/uNdwgF6Z24jGD4UBcquqk89XZBDJBHF+tbRBuISSbJDyozWPew6A9ZhX88faLPQuhNFibolnRUpxFA3BRDsFN9PPjv7BE1KTtuKSey6kN4Us6D0JPXTo76hd6zHWUmOQ4I7irRyJ3IxKU8yxY+aA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3YmMzhzlj/kbaLsfCnheAROX7w3lPdguJZcvfJ5evUg=;
 b=LkjH9gpecek678Xs86wz5PyizyEgB2wM1OqH1ijuYJzWq5qoFe/CfGTjxza5fAiIADJC8IEh2C9DDqXGK20DquODrCVegFlXtK5nv1vwIhtxzvz2jVViq4fcV4PAYBjmlTC1eT4IjlwSoyQsrEdK7cvBwflHEToxAnHhxqixTSE=
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com (2603:10a6:101:1d::23)
 by VI0PR08MB11383.eurprd08.prod.outlook.com (2603:10a6:800:303::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 10:15:17 +0000
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e]) by PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e%4]) with mapi id 15.21.0382.007; Fri, 4 Sep 2026
 10:15:17 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>
CC: "maz@kernel.org" <maz@kernel.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"oupton@kernel.org" <oupton@kernel.org>, nd <nd@arm.com>
Subject: Re: [PATCH v5 41/49] KVM: selftests: Add VGICv5 NR_IRQS attribute
 tests
Thread-Topic: [PATCH v5 41/49] KVM: selftests: Add VGICv5 NR_IRQS attribute
 tests
Thread-Index: AQHdJmCRr0PVBQvioECpYrEqe5Gu+raS0ySAgCuMqYA=
Date: Fri, 4 Sep 2026 10:15:16 +0000
Message-ID: <49f7ce1ffb1e07e08545592e8eb37ff256d7f4ff.camel@arm.com>
References: <20260807111159.429128-1-sascha.bischoff@arm.com>
	 <20260807111159.429128-42-sascha.bischoff@arm.com>
	 <20260807171240.33F011F00ADB@smtp.kernel.org>
In-Reply-To: <20260807171240.33F011F00ADB@smtp.kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	PR2PR08MB4889:EE_|VI0PR08MB11383:EE_|MI3PEPF00008555:EE_|AM8PR08MB6435:EE_
X-MS-Office365-Filtering-Correlation-Id: 3d78f1b3-8132-490d-58fe-08df0a6d7f0b
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|23010399003|22082099003|56012099006|10067099003|11063799006|4143699003|6133799003|18002099003|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 vQY79XLj2xfJOxvx1vd7awuRQCLh3v75FLVhqYtA464MgD591ezZ7lWgiejylwToXzPcnc8pNxrZ08cvTvEcBuaTA4OPL9jNA4a0E1W/AXj/Vtwx+EmTC6Nz42fqBpnsBvmPS9tBQieZKIDWIziTXOHTI32qwU4xGnEghcgX1GBKgQPCZiZVGHDznDyWfS7nlmYrsq2vDGScrheoNw5uyOf/rIBAtbz9gNWEMlBtwnDLb2VGZ/zUsTNXzxptetQBvBgcze3lrzN1mr67VQYRqYjedCKoho6bdRXc3XGUPXAtIVIlVsXk8FvLpdmKDPwKvaC+HGAFDlfXtGL33h09Ie20vB3lCr4g5HTjXjQuQVLKwDFypI4rQslsiyhlzhMVIxKzwvuXNGfqlUTTH5woon5dY99Q79P1n0fFQgwBfdc+l2diIb7Wuwmz1KYAo00eLKK49Ye8h4lonwyYl1Ws63oNi6q3diiCZrem6uy8CNaVBHkMhhq0QAe+hxtJaM9T/YopbAogHLY4PRu/231UcIaGl2Lo+AqgWsLh1RTcRKNaBCLp8ZsJJyJhCJ7DDekYUrOVA9eq01o5VDrdwOHHVO69BwMk1CHO3qwejbu24QDeKf/Nzy48kaghfv0aY4Qk984U5SX4A9b6C2ULwsBESbzYdUWCNAsUlL6LpXqrobmghLzrw9lSkT1FCg0Tvq/8unhzI1QuOO+CKmy/2Ap/mrVWsI7qn0cuDG1tKOnYp/Y=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR2PR08MB4889.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(23010399003)(22082099003)(56012099006)(10067099003)(11063799006)(4143699003)(6133799003)(18002099003)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <33948A6470D1D6498665E48A133709F8@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 ZD8PrhY3FbSkduaqjxra2ljgCvedMy/MYcc03z4LHCNyjeT/zXnQvParJU7alrWF96M28r+bvvi41OWMJGN6Azx3YACulGW4RtFaWobXl1Xj1qN02kS9trW8kq+4aQky5eLzABbafhJVwCD4wQtE4boZrsWIzO9tagJuB9GwypDwR/70wab+wSLudMc3ScOBQbrNBcegPIQl90N6FJtzUmYedEw3jxZjI6HAw3vic5Kg+iq4Kat0WFaPdzRKeWdfwfW7hj6/iipyp+KpWm3jXPOjs+g+cmIuvIR+o8nYESLbqlgdGGiPSpdXAA0ThaOo6x7YceiSnuIMIG68NsnxoA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR08MB11383
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 MI3PEPF00008555.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	fed0fc10-382b-4d5f-8f45-08df0a6d6adb
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|14060799003|36860700016|23010399003|1800799024|82310400026|376014|4143699003|10067099003|11063799006|6133799003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	qYJnz23bDB5iSNO132fmprZKmV5hDc7p9PwN61ogqsp5/tAUdF/KsQ8AqqnrN0jjz9iLavCrCZXjoQzvse8mBU923f8tuybOhh1kq/Owo5rqn8ytGE3FZSSvrhsaN208LJUIpiOJAAjNll1ZquJaPFhTzJxH+hkfOtqyu3whzBUnGlRpifySA8B5L5UGVi2doIgL2i6+inAh1siyCdm6LSDPDU7LADUU/KJYN2IY9RuRRL51JzJWvldKRmX4zMfrxXrLtet6a7EMu/8l3GYVMoTHEbrt2EE090AaXIsL5Z0KVfafq30Q26gf7X3WvBMtSxit/JrD+MdU4iEWVLQhxduRkQ9L7vdEGY3acJNX0xwk3HZ+0lDgy3SHwYzkmeKeXoTNorgidnimH5oydba4uCGoNKJu3Bgawi3/VOGUvLaj6NEio2lrXsoQz7kWbxXYQXHpVjqleeGDDEpwJZkTU9qZbtlweHJwHuDf5vTk3xuTjrCxas1ZvDv6ubkxfZFt/yNfgnTRmT25AtIrUzofAAmYApihUYxcUDM/511gkdAXixel+mRuCL97+BNuAVb2cnkDkVJVrb8FyB27NFZuRcau9SpTTxfsLoUtlARKblh/NObDbmE/Xs+lTAXaaNvWnt9B/v7yk8NZs/UQTBXNocVrb/WLtL5ABeJpsesgRUE=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(14060799003)(36860700016)(23010399003)(1800799024)(82310400026)(376014)(4143699003)(10067099003)(11063799006)(6133799003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	ViDYRELZg5WUxHXGZef0xxx2aJ+VYh7fuGewT+f/zTbqB5MZZYnrPR7gGisr0/dtqp53mEx8rzhMEgSEkWzherVuIVvO0VorOSpvp0dj/1GW5Q9M2kO/Q7OtBm/UAXpeco03MKqFFniHkb0y3qEFxNzxKlKonMjd1vTcsLp70GlX7eSAiYWu38SO0a47wjcpTCpzSNQal0kHdiLb53r9d/2Uri3AypSCjqRu3gxxA13Iut0NGwpTIymfXcaOukB6ukoASJWtJygWCx3Ac4lROVFsK3cQxexv0uIBGfsvEQDaHSqEUaLPUV0T1zCA72pFWbBzrmByONN47jDSmt4sRfYk7K4vWvQwf9QC8g+8uEwmdYnv+31NGaGPUvmhZ3QfW6yLdjeuw7/oVkgGxxJfG1iC+8ybzPQWIQCzkGyR77Km5THWtIPtrULy5X/onL34
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2026 10:15:50.7437
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d78f1b3-8132-490d-58fe-08df0a6d7f0b
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MI3PEPF00008555.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR08MB6435

T24gRnJpLCAyMDI2LTA4LTA3IGF0IDE3OjEyICswMDAwLCBzYXNoaWtvLWJvdEBrZXJuZWwub3Jn
IHdyb3RlOg0KPiBUaGFuayB5b3UgZm9yIHlvdXIgY29udHJpYnV0aW9uISBTYXNoaWtvIEFJIHJl
dmlldyBmb3VuZCAxIHBvdGVudGlhbA0KPiBpc3N1ZShzKSB0byBjb25zaWRlcjoNCj4gLSBbTG93
XSBUaGUgZmlsZS1sZXZlbCBtYWNybyBgVkdJQ19WNV9NQVhfTlJfU1BJU2AgY29udHJhZGljdHMg
dGhlDQo+IGFjdHVhbCBtYXhpbXVtIFNQSSBjb3VudCBoYXJkY29kZWQgaW4gdGhlIHRlc3QgbG9n
aWMgYW5kIEtWTQ0KPiBpbXBsZW1lbnRhdGlvbi4NCj4gLS0NCj4gDQo+IC0tLSBQYXRjaCBbNDFd
OiBbUEFUQ0ggdjUgNDEvNDldIEtWTTogc2VsZnRlc3RzOiBBZGQgVkdJQ3Y1IE5SX0lSUVMNCj4g
YXR0cmlidXRlIHRlc3RzIC0tLQ0KPiBjb21taXQgZGE4ZGEwMDkyMDYwN2RmNjhhMTQ4Y2Q2MTc3
MmVhMjQxZDlhODIwZg0KPiBBdXRob3I6IFNhc2NoYSBCaXNjaG9mZiA8U2FzY2hhLkJpc2Nob2Zm
QGFybS5jb20+DQo+IA0KPiBLVk06IHNlbGZ0ZXN0czogQWRkIFZHSUN2NSBOUl9JUlFTIGF0dHJp
YnV0ZSB0ZXN0cw0KPiANCj4gVGhpcyBjb21taXQgYWRkcyBjb3ZlcmFnZSBmb3IgdGhlIFZHSUN2
NSBOUl9JUlFTIGF0dHJpYnV0ZS4gSXQNCj4gdmVyaWZpZXMNCj4gdGhhdCBLVk0gcmVqZWN0cyB2
YWx1ZXMgb3V0c2lkZSB0aGUgc3VwcG9ydGVkIHJhbmdlLCBub24tMzItYWxpZ25lZA0KPiBjb3Vu
dHMsDQo+IGFuZCBhdHRlbXB0cyB0byBjaGFuZ2UgdGhlIGNvdW50IGFmdGVyIGluaXRpYWxpemF0
aW9uLg0KPiANCj4gPiBkaWZmIC0tZ2l0IGEvdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMva3ZtL2Fy
bTY0L3ZnaWNfdjUuYw0KPiA+IGIvdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMva3ZtL2FybTY0L3Zn
aWNfdjUuYw0KPiA+IGluZGV4IDUxZWEyZmU3MTQxYWQuLmY0YzBkMmMwMDNiYjQgMTAwNjQ0DQo+
ID4gLS0tIGEvdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMva3ZtL2FybTY0L3ZnaWNfdjUuYw0KPiA+
ICsrKyBiL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2t2bS9hcm02NC92Z2ljX3Y1LmMNCj4gPiBA
QCAtMTMsNiArMTMsOCBAQA0KPiA+IMKgI2luY2x1ZGUgInZnaWMuaCINCj4gPiDCoA0KPiA+IMKg
I2RlZmluZSBOUl9WQ1BVUwkJMQ0KPiA+ICsjZGVmaW5lIFZHSUNfVjVfREVGQVVMVF9OUl9TUElT
CTMyDQo+ID4gKyNkZWZpbmUgVkdJQ19WNV9NQVhfTlJfU1BJUwlCSVQoMTYpDQo+IA0KPiBbU2V2
ZXJpdHk6IExvd10NCj4gVGhpcyBpc24ndCBhIGJ1ZywgYnV0IHRoaXMgbWFjcm8gZGVmaW5lcyB0
aGUgbWF4aW11bSBhcyA2NTUzNiwNCj4gd2hlcmVhcyB0aGUNCj4gY29tbWl0IG1lc3NhZ2UgY29y
cmVjdGx5IG1lbnRpb25zIGEgIjEwMjQtU1BJIG1heGltdW0iLg0KDQpJIGhhdmUgZml4ZWQgdGhp
cyB0byB1c2UgQklUKDEwKS4NCg0KPiANCj4gWyAuLi4gXQ0KPiANCj4gPiBAQCAtMTI1LDYwICsx
ODQsOTIgQEAgc3RhdGljIHZvaWQgdGVzdF92Z2ljX3Y1X2NyZWF0ZSh2b2lkKQ0KPiA+IMKgCXZt
X2dpY19kZXN0cm95KCZ2KTsNCj4gPiDCoH0NCj4gPiDCoA0KPiA+IC1zdGF0aWMgdm9pZCBndWVz
dF9pcnFfaGFuZGxlcihzdHJ1Y3QgZXhfcmVncyAqcmVncykNCj4gPiArc3RhdGljIHZvaWQgdGVz
dF92Z2ljX3Y1X25yX2lycXNfYXR0cnModm9pZCkNCj4gPiDCoHsNCj4gPiAtCWJvb2wgdmFsaWQ7
DQo+ID4gLQl1MzIgaHdpcnE7DQo+ID4gLQl1NjQgaWE7DQo+ID4gLQlzdGF0aWMgaW50IGNvdW50
Ow0KPiA+IC0NCj4gPiAtCS8qDQo+ID4gLQkgKiBXZSBoYXZlIHBlbmRpbmcgaW50ZXJydXB0cy4g
U2hvdWxkIG5ldmVyIGFjdHVhbGx5IGVudGVyDQo+ID4gV0ZJDQo+ID4gLQkgKiBoZXJlIQ0KPiA+
IC0JICovDQo+ID4gLQl3ZmkoKTsNCj4gPiAtCUdVRVNUX1NZTkMoR1VFU1RfQ01EX0lTX0FXQUtF
KTsNCj4gPiAtDQo+ID4gLQlpYSA9IGdpY3JfaW5zbihDRElBKTsNCj4gPiAtCXZhbGlkID0gR0lD
VjVfR0lDUl9DRElBX1ZBTElEKGlhKTsNCj4gPiAtDQo+ID4gLQlHVUVTVF9TWU5DKEdVRVNUX0NN
RF9JUlFfQ0RJQSk7DQo+ID4gLQ0KPiA+IC0JaWYgKCF2YWxpZCkNCj4gPiAtCQlyZXR1cm47DQo+
ID4gLQ0KPiA+IC0JZ3NiX2FjaygpOw0KPiA+IC0JaXNiKCk7DQo+ID4gLQ0KPiA+IC0JaHdpcnEg
PSBGSUVMRF9HRVQoR0lDVjVfR0lDUl9DRElBX0lOVElELCBpYSk7DQo+ID4gLQ0KPiA+IC0JZ2lj
X2luc24oaHdpcnEsIENEREkpOw0KPiA+IC0JZ2ljX2luc24oMCwgQ0RFT0kpOw0KPiA+ICsJY29u
c3QgdTMyIG1heF9ucl9zcGlzID0gQklUKDEwKTsNCj4gDQo+IFtTZXZlcml0eTogTG93XQ0KPiBE
b2VzIFZHSUNfVjVfTUFYX05SX1NQSVMgZ28gY29tcGxldGVseSB1bnVzZWQgaW4gZmF2b3Igb2Yg
dGhpcyBsb2NhbA0KPiBtYXhfbnJfc3BpcyB2YXJpYWJsZT8NCj4gDQo+IFNob3VsZCBWR0lDX1Y1
X01BWF9OUl9TUElTIGJlIGRlZmluZWQgYXMgQklUKDEwKSBhbmQgdXNlZCBoZXJlDQo+IGluc3Rl
YWQgdG8NCj4gYXZvaWQgaGF2aW5nIHR3byBjb250cmFkaWN0b3J5IGxpbWl0cz8NCg0KSSd2ZSBz
d2l0Y2hlZCB0byB1c2luZyB0aGUgZ2xvYmFsIGRlZmluZS4NCg0KPiANCj4gPiArCXN0cnVjdCBr
dm1fdmNwdSAqdmNwdTsNCj4gPiArCXN0cnVjdCB2bV9naWMgdjsNCj4gPiArCXUzMiBucl9pcnFz
Ow0KPiA+ICsJaW50IHJldDsNCj4gDQoNClRoYW5rcywNClNhc2NoYQ0K
