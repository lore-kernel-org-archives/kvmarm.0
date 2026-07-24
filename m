Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012055.outbound.protection.outlook.com [52.101.66.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A196542BC20
	for <kvmarm@lists.linux.dev>; Fri, 24 Jul 2026 10:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.55
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784890717; cv=fail; b=B24RxEa1iHqiqNs1Aj5YYguQDljGVAID3qFhRCXKHgd8PEtKZVPf/42zH4Pg5x/MT0F3wUhyHnvDZaZr0g462vrTLr2cbWrm2vHQpngyzWhSOQqo/jOGLgGCYBW+82Fo9PBZsfYNRwI/AjCILFj6QPn8/QU+ga/qJRLA9lZ4NbM=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784890717; c=relaxed/simple;
	bh=mmkyfIn7hi0pU2fYmX7TjQ6/J8JHq/wM3KnddYe448E=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=m75bxIQrmiCItMWrWwbKy0U4IO1N9pxFXHg0fgw/rv9jTRqWQzR+Z2ly3ihdHG9DXRheOpKGjOm5bePLASI4d09329GSybUVQbDvINoD9UfPmeCQzAjm+ACxUNw1uc0JLinqbGPm6QqKpx93KyWNVOekTgmnbtC0uPnkxH86rxA=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=aZEkf8Ic; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=aZEkf8Ic; arc=fail smtp.client-ip=52.101.66.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="aZEkf8Ic";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="aZEkf8Ic"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=LKtL067hR0dRV4FvyBN9JMoSk7g0p225gvBqyx5cQw6TimLP64tV00stuHqT315y2URQRyTOPvxRvFtmkWNeuvONcOb2JpbESIv6cNIB4mPGItK2JCyvuRRtFOUPULRtOutsuL4i1o8RQfLMTTH7u/PC7hvL8hTghH8jg9nB1zGNHx4WLsMVTEFrJ875y/EbfrlWKAJteGM5kCQ6OD2RyRznyDRr3jejcEtIw2XADsIogtwRQWxp9KB09qq1mGH79ZM5vZJpLRc8iBa/7fPfzBXK+zpYSVAgYCEct1nZLqSK/E+eAhFfcNISOdBDFMLLTg6xTobbBAxqvCDDfPbdkw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d9Q+N8c+/EaoBz1WbwR+c+QrkqQZ3NsQVUtW+lJ1Kng=;
 b=un7zHkxRA/mEMMbPfx7oUVafoAcXlcSscVd4H9lcH5H6iXiRTkSFLfJhDCzgOaFDYyfntP1/kVBr5QcAK38VqQ0xPDQceE1zQGxV8s2IPEp74nvt3rmr5/n5M4I0HNIgnEB2lScnndevgg4kZT5mHZxjWxR4JJporMqAkmAEaNZqmLzQ+hmpjPLDa5qfKL0eq7K+jU1fzbqQJP6W5u6wAAoB/39yjIVVsysWoCzD2tyGGWY/fJEIeY+nL/wdQVEZAUeYsBGFSSIXr6LXDkxMERb/26Z0pFIY2Wggp6t2mTJuf/1lgC6p6bkmdUzUK2+G+2LVYSG1rH38q82huPDKGg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d9Q+N8c+/EaoBz1WbwR+c+QrkqQZ3NsQVUtW+lJ1Kng=;
 b=aZEkf8IcmhQwRjchDBD9TG4mwTZAVZURvUTX1RwdGJrqcANQAaAzbBX+W3AHN+6aF+yXW2+zbTGyLYYK9ZkRvwC7p+41Lg98QOQCMcs8CmWUkL83QdpwaKUvLY+vLupZqlNX/QCSqwu3pUYG275+RbUv0mU6K+73cAp4N1MPrwA=
Received: from AS4P250CA0012.EURP250.PROD.OUTLOOK.COM (2603:10a6:20b:5df::18)
 by DB9PR08MB6586.eurprd08.prod.outlook.com (2603:10a6:10:23f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Fri, 24 Jul
 2026 10:58:30 +0000
Received: from AMS0EPF00000194.eurprd05.prod.outlook.com
 (2603:10a6:20b:5df:cafe::42) by AS4P250CA0012.outlook.office365.com
 (2603:10a6:20b:5df::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.11 via Frontend Transport; Fri,
 24 Jul 2026 10:58:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF00000194.mail.protection.outlook.com (10.167.16.214) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.5
 via Frontend Transport; Fri, 24 Jul 2026 10:58:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wFLec+gb8GdyA/hokARI+EQmbdZH1O/VDQkh012KeRXnYr0jzwNGTQP03bCQqDbYfz8F+mAuRWDd+3yrSH6oum+fC6SGv494lYRpEbJSYffPpDWIMK1Feq/wokF527OcB4TruWBzfQXuGMoEvpJQ4mhcNMQTV5heXg4RYgcs1ByrKC1naEeCLA9YZjPpfwyl0KsoKNdrKkNACEDzeTnDdtnIgylJPePml695GReFXRPy3P68eATqpPQex8Z2NvCorE3xLlf8S6qAE2VdnAi+14yrORU6+8x1BcfVCUZNiDMXJD/SV0waAJjByTB2ZsUONjx/Jtg+kK2FLciesaHw/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d9Q+N8c+/EaoBz1WbwR+c+QrkqQZ3NsQVUtW+lJ1Kng=;
 b=Ha24zWCTjLzIkSTybPVaoJDL61S1Al47WYsDOwJ5e5I53DMKCJhvZ8dAEga/vwAHklhdEOo626hcJMgWePbh4TCuCnLHYdhFIToZfq++K5+rp1QvPqA7F4vCpVxcQIRGE47nJctyKgkE5V8hl4cIvzJEh1pfqz+GyhPXE9CyPAspxg36btyHHY4Bz9W0umS0KEAYRAqI2HP5ikRnNro58elS1j3SFfegG5EkIaWwqZNOybgBfbbWsZNsrO7C/k+2wiRduKoF+WyFRGehLUXLdtGrviXfqwUXaPjprXiofYLAzbGjXoBrsUCUUZBmeU/mfbtmag5ErmDpEBYyDmdP/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d9Q+N8c+/EaoBz1WbwR+c+QrkqQZ3NsQVUtW+lJ1Kng=;
 b=aZEkf8IcmhQwRjchDBD9TG4mwTZAVZURvUTX1RwdGJrqcANQAaAzbBX+W3AHN+6aF+yXW2+zbTGyLYYK9ZkRvwC7p+41Lg98QOQCMcs8CmWUkL83QdpwaKUvLY+vLupZqlNX/QCSqwu3pUYG275+RbUv0mU6K+73cAp4N1MPrwA=
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com (2603:10a6:10:407::19)
 by GV2PR08MB11279.eurprd08.prod.outlook.com (2603:10a6:150:2f0::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Fri, 24 Jul
 2026 10:57:26 +0000
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e]) by DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e%5]) with mapi id 15.21.0245.009; Fri, 24 Jul 2026
 10:57:26 +0000
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
Subject: [PATCH v4 35/48] KVM: arm64: gic-v5: Implement save/restore
 mechanisms for ISTs
Thread-Topic: [PATCH v4 35/48] KVM: arm64: gic-v5: Implement save/restore
 mechanisms for ISTs
Thread-Index: AQHdG1s2hyISS/J40E6VsYHBmGEMzA==
Date: Fri, 24 Jul 2026 10:57:26 +0000
Message-ID: <20260724104819.1296803-36-sascha.bischoff@arm.com>
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
	DU0PR08MB8421:EE_|GV2PR08MB11279:EE_|AMS0EPF00000194:EE_|DB9PR08MB6586:EE_
X-MS-Office365-Filtering-Correlation-Id: 4f248d2a-cfe8-4466-6123-08dee9727f34
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|22082099003|18002099003|56012099006|11063799006|5023799004|3023799007|38070700021|6133799003|10067099003;
X-Microsoft-Antispam-Message-Info-Original:
 K1AN3/0FcwORkq/7byJeV0A1AFX5/m4lrBCyprRIhJOs0FFLoIK3LYbyb0//eon4KWb4DqCoCTUesxiXzpy4r4wUz1eQ7YxFy266IoPVY5zwous2QIYxioZZ4gAzSDozfnS3Q7I+edA2UFD9l143JPc3liOqc71ZZB2IUrslb+837cHv8+rPBUcMbV3L+Fv9PWsZi9+va9OtaQAviLals/hymNvHFMcZhU1KS/WODxj0Lu6RJx+jDueoajAx2j8hWJfWP4e3q2vbXeHypUqjUU9fcg6DI8fMotAku0AHX1rbwH42XqKnL6OZMSe1omda1M200by1v5PENvg6xqPBMY32SrVkKdzOVJvM0z1gadK5Vc03ea8I0Xy+LIiaxnAW5K+qp3aANx8S/psGBE0BT5L+dDpVgSt6h3VCO+fhfX9+LO7zoemE1xqyU7ULIf+GbF6CbZEZbMtBiuzG4EnwYPfV4borVCT3g5CamblLaUHxHxggMmKSynaD+q+dFKYYLa6OL9e02cK1Z5TXkmigbfL0tXtXe1wgtI8dnwLK/gr6pRjr+chW9JRTRWhphf8d36a0nUWjdL3e0JTSDNi2bdzSaWLJ4wyA4jQ7IUYtGMbt37KW+y+rsM3URi6kzwrP5YIYKwCzWCGdLiIZumYd5UDGhugnNmlpUSiDar9ZU2e4UfhdwKA+30gNhkbQk59ATTU2aRhEueHOJGjbf8mCi9So+68Q8kE2OrbyUdLz2dE=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB8421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(22082099003)(18002099003)(56012099006)(11063799006)(5023799004)(3023799007)(38070700021)(6133799003)(10067099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 qL57aOGh0hlkYRC9je7CxphmPYDCf/U0orVQR2ZViELQSuK5pbEkI+R5uPgqVFwfvxFL37CpBs0zNFscwFJ9Vo5c+Z/2KlXY20Ttkl3J1ePPc9nMW8Tf1+iEOhJCbqsxMzjCJQJFaJIYzbpExnLEGybun252A33iQfqqzPeKNVH1xAg2m1DU8ifX9Xx3kz0+BX7xT6xYXzQrGjsUdAFDjwplUnzn9eBbLFE/6VEYl1BraHb1MwGzea1taSsOV36OT6dCIi8QHwVyQQTNcf0JBP9H8rf8WBZp42TK+nn32dF1aE+5akgDpgDcsVD8HkfAugsb0aN+meAsGoKFpEFr1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR08MB11279
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF00000194.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	994958b0-f79f-4d86-e803-08dee9725916
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|23010399003|1800799024|35042699022|36860700016|14060799003|6133799003|5023799004|56012099006|11063799006|18002099003|22082099003|3023799007|10067099003;
X-Microsoft-Antispam-Message-Info:
	Lh7e20N2sfiGndmoPgfbifZEHhZ2AIez3CkJlY3Ew2GpOcZJj6KgWaiKTfyrZK+Kcq9tin5ozedQRexmsKU/i19uzV5UgmNYkICEaj1FvyHLyA0KJvn8lACdcOZyUtkohOXfqbCeKCypF+B8mjG7mPEkOAZvOtL+aflmgGJy00La/RmoYOjkVxtT6MnIIpS9n6hVHVOuV8TcFjV+bD9ZR7NyUZuXpfWryDXdRYjvPGNboZEa79iZkQUNXegw9n1pT2zt1n3xlyem4afZE3FF5RPrwfsn4eg5VrV4AUzqBUcV1VKuE84rZme3jDa5xWaaF97I1bRMxBst/tHleYgWOd2PiAWdOfMIqbN1jQSlkATE1tfcqYe2ERnvrRGZdHyDh2T49r5CA6UGE+0a21qy/GWA4Jzu0KOto7WAUJ4D0l2h60moVe7OGNmCkfKs5M6ZxP3NpwHuhXb9XxO5SxjzJRbks4iyg3B4cm9am+IfO3ldfZLeqDFQAXj+ZCMcajyQCvwLymKrKi2GlMABy71PoxMHNV2XP/Y0E20YvG/4Bnt6Nz+OBC0xWqroEFCRYwm7tecCFafgm0QdFnjcQhWBs8LXRyjWJFeSPAkNJpsyBKtPlBIMY2ywMdk6BTI029ui+vshSAY/FEAAVqxCTpqPrzQBC7hrwoaeu2/M6Dmeizfed8R88coUF9tJ8fG40qn0dSZBFioIqM41dI7tjxMd0A==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(23010399003)(1800799024)(35042699022)(36860700016)(14060799003)(6133799003)(5023799004)(56012099006)(11063799006)(18002099003)(22082099003)(3023799007)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	KcNIF3m9zaz0DS1QulArGkpSZwOp+0FGQkblkp15mPR6vsypc1iDCNe7hqgbSBYDbG8qd4uYZsE6S/l//EwZRYOAzxpYo/yddSSghWzagPc7lk2QweMEqGwthedN0520TlLR2Ml2PdI0O7zk+Ve970BbUJdVLuxaOR72/VdnVR2bM6+G4jKneimSWav9/BiO7gRcPmRGMe6SSCts/gRtEI/1D/MBUXaaVvoMpX8k3MRg89NEA+rb9K0GRMaT3Hzuwp/21icJWwReCjCyhpdw8e2tjgi354sJHiSB75G7Jy2Ywtr/vcjt912AUzUGL5sanjMjEXvQaAe1+p56II0GpVrNHGFedMASYYU7rdIKNXf2AYIgjVgOx303uK6Uimuw+1ZppNJnRXny0KHpdWgTSHuvSBd8IV1iKIAy+l1cVVjG0okZi3ybDiA7s6g8zujc
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2026 10:58:30.1916
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f248d2a-cfe8-4466-6123-08dee9727f34
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF00000194.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB6586

When running a GICv5 VM, there are up to two ISTs that must be saved
or restored when migrating a VM.

The SPI IST is allocated by the hypervisor, as the guest presumes the
memory for the SPI state is allocated by the hardware. The LPI IST is
also shadowed in KVM when the guest enables LPIs, so the guest's LPI
IST memory is not used directly by the physical GICv5 hardware.

As both in-use ISTs are backed by host allocations, userspace provides
migration storage for both tables through KVM_DEV_ARM_VGIC_GRP_IST.
The userspace descriptor supplies separate SPI and LPI buffers, each
containing the architected 32-bit ISTE state for the corresponding
interrupt number space. If the guest has not configured an LPI IST,
userspace must omit the LPI buffer.

On save, the VM itself is quiesced using IRS_SAVE_VMR. This ensures
that the hardware has written all interrupt state back to the ISTs.
Following the save operation, IRS_SAVE_VM_STATUSR is checked to ensure
that the guest has remained quiescent. If it has not, an error is
propagated back to userspace so the save can be retried.

On restore, the VM is first made invalid, as the tables must not be
updated while they are valid. The SPI and LPI ISTs are then restored
from the userspace-provided buffers before making the VM valid again.
As part of restoring the ISTs, pending interrupts are tracked and IST
pending state is cleared. Once the VM is made valid, these interrupts
are made pending again via the GIC VDPEND system instruction.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-irs-v5.c     |  20 +
 arch/arm64/kvm/vgic/vgic-kvm-device.c |  13 +
 arch/arm64/kvm/vgic/vgic-v5-tables.c  | 596 ++++++++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic-v5-tables.h  |  16 +
 arch/arm64/kvm/vgic/vgic-v5.c         | 329 +++++++++++++-
 arch/arm64/kvm/vgic/vgic.h            |   5 +
 6 files changed, 976 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-irs-v5.c b/arch/arm64/kvm/vgic/vgic-i=
rs-v5.c
index 8eadb9a1f1ec2..be580d9a00cd5 100644
--- a/arch/arm64/kvm/vgic/vgic-irs-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-irs-v5.c
@@ -1028,6 +1028,26 @@ int kvm_vgic_v5_irs_init(struct kvm *kvm, unsigned i=
nt nr_spis)
 	return 0;
 }
=20
+int vgic_v5_irs_lpi_ist_id_bits(struct kvm *kvm, unsigned int *id_bits)
+{
+	struct vgic_v5_irs *irs =3D kvm->arch.vgic.vgic_v5_irs_data;
+
+	if (!irs)
+		return -ENXIO;
+
+	if (!irs->ist_baser.valid)
+		return 0;
+
+	if (!vgic_v5_ist_cfgr_valid(irs)) {
+		kvm_err("Guest programmed invalid IRS_IST_CFGR\n");
+		return -EINVAL;
+	}
+
+	*id_bits =3D irs->ist_cfgr.lpi_id_bits;
+
+	return 1;
+}
+
 int vgic_v5_has_attr_regs(struct kvm_device *dev, struct kvm_device_attr *=
attr)
 {
 	const struct vgic_register_region *region;
diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vg=
ic-kvm-device.c
index f1f1fcb08161f..1c205cb1361fd 100644
--- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
+++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
@@ -920,6 +920,11 @@ static int vgic_v5_set_attr(struct kvm_device *dev,
 	switch (attr->group) {
 	case KVM_DEV_ARM_VGIC_GRP_ADDR:
 		break;
+	case KVM_DEV_ARM_VGIC_GRP_IST:
+		if (attr->attr)
+			return -ENXIO;
+
+		return vgic_v5_irs_restore_ists(dev->kvm, attr);
 	case KVM_DEV_ARM_VGIC_GRP_IRS_REGS:
 		fallthrough;
 	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
@@ -948,6 +953,11 @@ static int vgic_v5_get_attr(struct kvm_device *dev,
 	switch (attr->group) {
 	case KVM_DEV_ARM_VGIC_GRP_ADDR:
 		break;
+	case KVM_DEV_ARM_VGIC_GRP_IST:
+		if (attr->attr)
+			return -ENXIO;
+
+		return vgic_v5_irs_save_ists(dev->kvm, attr);
 	case KVM_DEV_ARM_VGIC_GRP_IRS_REGS:
 		fallthrough;
 	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
@@ -997,6 +1007,9 @@ static int vgic_v5_has_attr(struct kvm_device *dev,
 		default:
 			return -ENXIO;
 		}
+		break;
+	case KVM_DEV_ARM_VGIC_GRP_IST:
+		return attr->attr ? -ENXIO : 0;
 	default:
 		return -ENXIO;
 	}
diff --git a/arch/arm64/kvm/vgic/vgic-v5-tables.c b/arch/arm64/kvm/vgic/vgi=
c-v5-tables.c
index 718410e8c9f3b..f220267266c29 100644
--- a/arch/arm64/kvm/vgic/vgic-v5-tables.c
+++ b/arch/arm64/kvm/vgic/vgic-v5-tables.c
@@ -9,6 +9,7 @@
 #include <linux/mutex.h>
 #include <linux/sizes.h>
 #include <linux/slab.h>
+#include <linux/uaccess.h>
 #include <linux/xarray.h>
 #include <asm/kvm_mmu.h>
=20
@@ -59,6 +60,20 @@ static DEFINE_XARRAY(vm_info);
 #define GICV5_VPED_ADDR_SHIFT		3ULL
 #define GICV5_VPED_ADDR			GENMASK_ULL(55, 3)
=20
+/* L2 Interrupt State Table Entry */
+#define GICV5_ISTL2E_PENDING		BIT(0)
+#define GICV5_ISTL2E_ACTIVE		BIT(1)
+#define GICV5_ISTL2E_HM			BIT(2)
+#define GICV5_ISTL2E_ENABLE		BIT(3)
+#define GICV5_ISTL2E_IRM		BIT(4)
+#define GICV5_ISTL2E_HWU		GENMASK(10, 9)
+#define GICV5_ISTL2E_PRIORITY		GENMASK(15, 11)
+#define GICV5_ISTL2E_IAFFID		GENMASK(31, 16)
+
+#define GICV5_ISTE_SIZE(istsz)		BIT((istsz) + 2)
+#define GICV5_LINEAR_IST_SIZE(id_bits, istsz)	\
+	(BIT(id_bits) * GICV5_ISTE_SIZE(istsz))
+
 /*
  * The LPI and SPI configuration is stored in the 2nd and 3rd 64-bit chunk=
s of
  * the VMTE (0-based). We call this a section here in an attempt to simpli=
fy the
@@ -67,6 +82,26 @@ static DEFINE_XARRAY(vm_info);
 #define GICV5_VMTEL2_LPI_SECTION	2
 #define GICV5_VMTEL2_SPI_SECTION	3
=20
+struct vgic_v5_ist_desc {
+	struct vgic_v5_vm_info	*vmi;
+	void			*base;
+	unsigned int		id_bits;
+	unsigned int		istsz;
+	unsigned int		l2sz;
+	size_t			iste_size;
+	bool			present;
+};
+
+struct vgic_v5_two_level_ist_shape {
+	size_t	l1_entries;
+	size_t	l2_entries;
+};
+
+struct vgic_v5_pending_irq {
+	u32			irq;
+	struct list_head	next;
+};
+
 static int vgic_v5_alloc_linear_ist(struct kvm *kvm, bool spi_ist,
 				    unsigned int id_bits,
 				    unsigned int istsz);
@@ -100,6 +135,22 @@ static void vgic_v5_clean_inval(void *va, size_t size)
 		dcache_clean_inval_poc(base, base + size);
 }
=20
+static void vgic_v5_drain_pending_irqs(struct kvm *kvm,
+				       struct vgic_v5_vm_info *vmi,
+				       bool reinject)
+{
+	struct vgic_v5_pending_irq *pirq, *tmp;
+
+	list_for_each_entry_safe(pirq, tmp, &vmi->pending_irqs, next) {
+		if (reinject)
+			kvm_call_hyp(__vgic_v5_vdpend, pirq->irq, true,
+				     vgic_v5_vm_id(kvm));
+
+		list_del(&pirq->next);
+		kfree(pirq);
+	}
+}
+
 /*
  * Create a linear VM Table. Directly using the number of entries supplied=
 as
  * the size of an L2 VMTE (32 bytes) guarantees that our allocation is ali=
gned per
@@ -446,6 +497,13 @@ int vgic_v5_vmte_init(struct kvm *kvm)
 	if (ret)
 		goto out_fail;
=20
+	/*
+	 * If we are restoring the state of a guest, we need to re-inject any
+	 * IRQs that were pending when the state of the guest was originally
+	 * saved. We use the pending_irqs list for this.
+	 */
+	INIT_LIST_HEAD(&vmi->pending_irqs);
+
 	/* Allocate and assign the VM Descriptor, if required. */
 	if (vmt_info->vmd_size !=3D 0) {
 		vmd =3D kzalloc(vmt_info->vmd_size, GFP_KERNEL);
@@ -543,6 +601,9 @@ int vgic_v5_vmte_release(struct kvm *kvm)
 	if (!vmi)
 		goto no_vmi;
=20
+	/* Unlikely, but possible. Avoid leaking the memory. */
+	vgic_v5_drain_pending_irqs(kvm, vmi, false);
+
 	/* If we have an LPI IST, free it */
 	if (vmi->h_lpi_ist) {
 		ret =3D vgic_v5_lpi_ist_free(kvm);
@@ -1121,6 +1182,18 @@ static int vgic_v5_spi_ist_free(struct kvm *kvm)
 	return vgic_v5_linear_ist_free(kvm, true);
 }
=20
+int vgic_v5_lpi_ist_exists(struct kvm *kvm)
+{
+	u32 vm_id =3D vgic_v5_vm_id(kvm);
+	struct vgic_v5_vm_info *vmi;
+
+	vmi =3D xa_load(&vm_info, vm_id);
+	if (!vmi)
+		return -ENXIO;
+
+	return !!vmi->h_lpi_ist;
+}
+
 /*
  * Allocate an IST for LPIs.
  *
@@ -1197,3 +1270,526 @@ int vgic_v5_lpi_ist_free(struct kvm *kvm)
 	else
 		return vgic_v5_two_level_ist_free(kvm, false);
 }
+
+static struct vgic_v5_two_level_ist_shape
+vgic_v5_two_level_ist_shape(const struct vgic_v5_ist_desc *ist)
+{
+	struct vgic_v5_two_level_ist_shape shape;
+	size_t l2bits, n;
+
+	l2bits =3D (10 - ist->istsz) + (2 * ist->l2sz);
+	n =3D max(2, ist->id_bits - l2bits + 3 - 1);
+
+	shape.l1_entries =3D BIT(n + 1) / GICV5_IRS_ISTL1E_SIZE;
+	shape.l2_entries =3D BIT(l2bits);
+
+	return shape;
+}
+
+static int vgic_v5_read_vm_ist_desc(struct kvm *kvm, unsigned int section,
+				    struct vgic_v5_ist_desc *ist)
+{
+	u32 vm_id =3D vgic_v5_vm_id(kvm);
+	struct vmtl2_entry *vmte;
+	u64 vmte_ist_section;
+
+	vmte =3D vgic_v5_get_l2_vmte(vm_id);
+	if (IS_ERR(vmte))
+		return PTR_ERR(vmte);
+
+	vgic_v5_clean_inval(vmte, sizeof(*vmte));
+	vmte_ist_section =3D le64_to_cpu(READ_ONCE(vmte->val[section]));
+
+	ist->id_bits =3D FIELD_GET(GICV5_VMTEL2E_IST_ID_BITS, vmte_ist_section);
+	ist->istsz =3D FIELD_GET(GICV5_VMTEL2E_IST_ISTSZ, vmte_ist_section);
+	ist->l2sz =3D FIELD_GET(GICV5_VMTEL2E_IST_L2SZ, vmte_ist_section);
+	ist->iste_size =3D GICV5_ISTE_SIZE(ist->istsz);
+
+	return !!(vmte_ist_section & GICV5_VMTEL2E_IST_VALID);
+}
+
+static int vgic_v5_get_spi_ist_desc(struct kvm *kvm, bool userspace_buf,
+				    struct vgic_v5_ist_desc *ist)
+{
+	u32 vm_id =3D vgic_v5_vm_id(kvm);
+	int ret;
+
+	memset(ist, 0, sizeof(*ist));
+
+	ist->vmi =3D xa_load(&vm_info, vm_id);
+	if (!ist->vmi)
+		return -ENXIO;
+
+	ret =3D vgic_v5_read_vm_ist_desc(kvm, GICV5_VMTEL2_SPI_SECTION, ist);
+	if (ret < 0)
+		return ret;
+
+	ist->base =3D ist->vmi->h_spi_ist;
+
+	/* We don't have SPIs, but userspace is trying to save/restore them. */
+	if (!ist->base && userspace_buf)
+		return -ENOENT;
+
+	/* We have SPIs but userspace isn't trying to save/restore them. */
+	if (ist->base && !userspace_buf)
+		return -EINVAL;
+
+	/* No SPIs and no userspace buffer: nothing to do. */
+	if (!ist->base && !userspace_buf)
+		return 0;
+
+	ist->present =3D true;
+	return 0;
+}
+
+static int vgic_v5_get_lpi_ist_desc(struct kvm *kvm,
+				    struct vgic_v5_ist_desc *ist)
+{
+	u32 vm_id =3D vgic_v5_vm_id(kvm);
+	bool guest_valid, host_valid;
+	int ret;
+
+	memset(ist, 0, sizeof(*ist));
+
+	ist->vmi =3D xa_load(&vm_info, vm_id);
+	if (WARN_ON_ONCE(!ist->vmi))
+		return -ENXIO;
+
+	ret =3D vgic_v5_read_vm_ist_desc(kvm, GICV5_VMTEL2_LPI_SECTION, ist);
+	if (ret < 0)
+		return ret;
+
+	host_valid =3D ret;
+	guest_valid =3D kvm->arch.vgic.vgic_v5_irs_data->ist_baser.valid;
+	ist->base =3D ist->vmi->h_lpi_ist;
+
+	/* If there is no IST to save/restore, return without error. */
+	if (!guest_valid && !host_valid && !ist->base)
+		return 0;
+
+	/* Mismatched combination of valid state */
+	if (!guest_valid || !host_valid || !ist->base)
+		return -ENXIO;
+
+	if (ist->vmi->h_lpi_ist_structure && !ist->vmi->h_lpi_l2_ists)
+		return -ENXIO;
+
+	ist->present =3D true;
+	return 0;
+}
+
+/*
+ * Save a linear host IST to userspace memory.
+ *
+ * Only the architected 32-bit ISTE state is stored. Metadata is skipped w=
hen
+ * striding through the host IST.
+ */
+static int vgic_v5_save_linear_ist(const struct vgic_v5_ist_desc *ist,
+				   u32 __user *uaddr, size_t nr_entries)
+{
+	__le32 h_iste;
+	size_t index;
+	int ret;
+
+	vgic_v5_clean_inval(ist->base,
+			    GICV5_LINEAR_IST_SIZE(ist->id_bits, ist->istsz));
+
+	for (index =3D 0; index < nr_entries; index++) {
+		__le32 *h_iste_addr =3D ist->base + index * ist->iste_size;
+
+		h_iste =3D READ_ONCE(*h_iste_addr);
+		ret =3D put_user(h_iste, uaddr);
+		if (ret)
+			return ret;
+
+		uaddr++;
+	}
+
+	return 0;
+}
+
+/*
+ * Save a two-level host IST to userspace memory.
+ *
+ * Only the architected 32-bit ISTE state is stored. Metadata is skipped w=
hen
+ * striding through the host IST.
+ */
+static int vgic_v5_save_two_level_ist(const struct vgic_v5_ist_desc *ist,
+				      u32 __user *uaddr)
+{
+	struct vgic_v5_two_level_ist_shape shape;
+	size_t h_l1_index, h_l2_index;
+	void *h_l2_ist_base;
+	__le32 h_iste;
+	int ret;
+
+	shape =3D vgic_v5_two_level_ist_shape(ist);
+
+	vgic_v5_clean_inval(ist->base,
+			    shape.l1_entries * sizeof(*ist->vmi->h_lpi_ist));
+
+	for (h_l1_index =3D 0; h_l1_index < shape.l1_entries; h_l1_index++) {
+		u64 l1_iste;
+
+		/*
+		 * Host L2 ISTs are preallocated. Any invalid L1 entry means the
+		 * host IST state is inconsistent.
+		 */
+		l1_iste =3D le64_to_cpu(READ_ONCE(ist->vmi->h_lpi_ist[h_l1_index]));
+		if (!FIELD_GET(GICV5_ISTL1E_VALID, l1_iste))
+			return -ENXIO;
+
+		h_l2_ist_base =3D ist->vmi->h_lpi_l2_ists[h_l1_index];
+		if (!h_l2_ist_base)
+			return -ENXIO;
+
+		vgic_v5_clean_inval(h_l2_ist_base,
+				    shape.l2_entries * ist->iste_size);
+
+		for (h_l2_index =3D 0; h_l2_index < shape.l2_entries; h_l2_index++) {
+			h_iste =3D *(__le32 *)(h_l2_ist_base +
+					     h_l2_index * ist->iste_size);
+
+			ret =3D put_user(h_iste, uaddr);
+			if (ret)
+				return ret;
+
+			uaddr++;
+		}
+	}
+
+	return 0;
+}
+
+/*
+ * Save the SPI IST to userspace-provided memory.
+ */
+int vgic_v5_save_spi_ist(struct kvm *kvm, struct kvm_vgic_v5_ist *ist_attr=
)
+{
+	struct vgic_v5_ist_desc ist;
+	u32 __user *uaddr;
+	int ret;
+
+	ret =3D vgic_v5_get_spi_ist_desc(kvm, !!ist_attr->spi_ist_addr, &ist);
+	if (ret || !ist.present)
+		return ret;
+
+	uaddr =3D (u32 __user *)(unsigned long)ist_attr->spi_ist_addr;
+
+	/* The host SPI IST is always linear. */
+	return vgic_v5_save_linear_ist(&ist, uaddr,
+				       kvm->arch.vgic.nr_spis);
+}
+
+/*
+ * Save the LPI IST to userspace memory.
+ *
+ * The LPI IST may be linear or two-level, so host iteration depends on th=
e
+ * allocated host shape.
+ */
+int vgic_v5_save_lpi_ist(struct kvm *kvm, struct kvm_vgic_v5_ist *ist_attr=
)
+{
+	struct vgic_v5_ist_desc ist;
+	u32 __user *uaddr;
+	int ret;
+
+	ret =3D vgic_v5_get_lpi_ist_desc(kvm, &ist);
+	if (ret)
+		return ret;
+
+	if (!ist.present)
+		return 0;
+
+	uaddr =3D (u32 __user *)(unsigned long)ist_attr->lpi_ist_addr;
+
+	if (!ist.vmi->h_lpi_ist_structure)
+		return vgic_v5_save_linear_ist(&ist, uaddr,
+					       BIT(ist.id_bits));
+
+	return vgic_v5_save_two_level_ist(&ist, uaddr);
+}
+
+/*
+ * Track any SPIs and LPIs that were marked as pending at the point where =
the
+ * IST was restored.
+ *
+ * Restored pending state is cleared from the host ISTE and replayed with =
VDPEND
+ * before the VM first runs.
+ */
+static int vgic_v5_track_pending_irq(struct list_head *pending_irqs, u32 i=
ntid,
+				     u32 type)
+{
+	struct vgic_v5_pending_irq *pirq;
+
+	pirq =3D kzalloc_obj(*pirq, GFP_KERNEL);
+	if (!pirq)
+		return -ENOMEM;
+
+	/* Encode the interrupt as a GICv5 IntID. */
+	pirq->irq =3D FIELD_PREP(GICV5_HWIRQ_TYPE, type) |
+		    FIELD_PREP(GICV5_HWIRQ_ID, intid);
+
+	INIT_LIST_HEAD(&pirq->next);
+	list_add_tail(&pirq->next, pending_irqs);
+
+	return 0;
+}
+
+/*
+ * Process and sanitise each restored ISTE.
+ *
+ * HWU is for hardware use and must not survive migration. Pending state i=
s
+ * tracked, cleared from the ISTE, and replayed before the VM first runs.
+ */
+static int vgic_v5_process_iste(__le32 *iste, struct list_head *pending_ir=
qs,
+				u32 intid, u32 type)
+{
+	u32 iste_data =3D le32_to_cpu(READ_ONCE(*iste));
+	int ret;
+
+	/* Pending state is replayed later with VDPEND. */
+	if (iste_data & GICV5_ISTL2E_PENDING) {
+		ret =3D vgic_v5_track_pending_irq(pending_irqs, intid, type);
+		if (ret)
+			return ret;
+	}
+
+	iste_data &=3D ~GICV5_ISTL2E_PENDING;
+	iste_data &=3D ~GICV5_ISTL2E_HWU;
+
+	WRITE_ONCE(*iste, cpu_to_le32(iste_data));
+
+	return 0;
+}
+
+static void vgic_v5_restore_spi_config(struct kvm *kvm, __le32 iste, u32 s=
pi)
+{
+	u32 iste_data =3D le32_to_cpu(iste);
+	bool pending =3D iste_data & GICV5_ISTL2E_PENDING;
+	struct vgic_irq *irq;
+	unsigned long flags;
+
+	irq =3D vgic_get_irq(kvm, vgic_v5_make_spi(spi));
+	if (WARN_ON_ONCE(!irq))
+		return;
+
+	raw_spin_lock_irqsave(&irq->irq_lock, flags);
+
+	if (iste_data & GICV5_ISTL2E_HM)
+		irq->config =3D VGIC_CONFIG_LEVEL;
+	else
+		irq->config =3D VGIC_CONFIG_EDGE;
+
+	if (irq->config =3D=3D VGIC_CONFIG_EDGE)
+		irq->pending_latch =3D pending;
+	else if (pending)
+		irq->pending_latch =3D true;
+	else if (!irq->active)
+		irq->pending_latch =3D false;
+
+	raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
+	vgic_put_irq(kvm, irq);
+}
+
+static int vgic_v5_restore_ist_entry(struct kvm *kvm,
+				     const struct vgic_v5_ist_desc *ist,
+				     void *h_iste_addr, __le32 h_iste,
+				     u32 intid, u32 intid_type)
+{
+	__le32 raw_iste =3D h_iste;
+	int ret;
+
+	/*
+	 * Sanitise the IST, clearing HWU & pending fields. Pending state is
+	 * later replayed via GIC VDPEND.
+	 */
+	ret =3D vgic_v5_process_iste(&h_iste, &ist->vmi->pending_irqs,
+				   intid, intid_type);
+	if (ret)
+		return ret;
+
+	if (intid_type =3D=3D GICV5_HWIRQ_TYPE_SPI)
+		vgic_v5_restore_spi_config(kvm, raw_iste, intid);
+
+	/*
+	 * Zero the full ISTE (incl metadata), and write back the non-metadata
+	 * region, only.
+	 */
+	memset(h_iste_addr, 0, ist->iste_size);
+	WRITE_ONCE(*(__le32 *)h_iste_addr, h_iste);
+	vgic_v5_clean_inval(h_iste_addr, ist->iste_size);
+
+	return 0;
+}
+
+/*
+ * Restore a userspace IST image to a linear host IST.
+ *
+ * The userspace IST image is a linear array of 32-bit ISTEs.
+ */
+static int vgic_v5_restore_linear_ist(struct kvm *kvm,
+				      const struct vgic_v5_ist_desc *ist,
+				      u32 __user *uaddr, size_t nr_entries,
+				      u32 intid_type)
+{
+	__le32 h_iste;
+	size_t index;
+	int ret;
+
+	for (index =3D 0; index < nr_entries; index++) {
+		void *h_iste_addr =3D ist->base + index * ist->iste_size;
+
+		ret =3D get_user(h_iste, uaddr);
+		if (ret)
+			return ret;
+
+		ret =3D vgic_v5_restore_ist_entry(kvm, ist, h_iste_addr,
+					h_iste, index, intid_type);
+		if (ret)
+			return ret;
+
+		uaddr++;
+	}
+
+	return 0;
+}
+
+/*
+ * Restore a userspace IST image to a two-level host IST.
+ *
+ * The userspace IST image is a linear array of 32-bit ISTEs.
+ */
+static int vgic_v5_restore_two_level_ist(struct kvm *kvm,
+					 const struct vgic_v5_ist_desc *ist,
+					 u32 __user *uaddr, u32 intid_type)
+{
+	struct vgic_v5_two_level_ist_shape shape;
+	size_t h_l1_index, h_l2_index;
+	void *h_l2_ist_base;
+	__le32 h_iste;
+	int ret;
+
+	shape =3D vgic_v5_two_level_ist_shape(ist);
+
+	vgic_v5_clean_inval(ist->vmi->h_lpi_ist,
+			    shape.l1_entries * sizeof(*ist->vmi->h_lpi_ist));
+
+	for (h_l1_index =3D 0; h_l1_index < shape.l1_entries; ++h_l1_index) {
+		u64 l1_iste;
+
+		/*
+		 * Host L2 ISTs are preallocated. Any invalid L1 entry means the
+		 * host IST state is inconsistent.
+		 */
+		l1_iste =3D le64_to_cpu(READ_ONCE(ist->vmi->h_lpi_ist[h_l1_index]));
+		if (!FIELD_GET(GICV5_ISTL1E_VALID, l1_iste))
+			return -ENXIO;
+
+		h_l2_ist_base =3D ist->vmi->h_lpi_l2_ists[h_l1_index];
+		if (!h_l2_ist_base)
+			return -ENXIO;
+
+		for (h_l2_index =3D 0; h_l2_index < shape.l2_entries; h_l2_index++) {
+			void *h_iste_addr =3D h_l2_ist_base +
+					    h_l2_index * ist->iste_size;
+			u32 intid =3D h_l1_index * shape.l2_entries + h_l2_index;
+
+			ret =3D get_user(h_iste, uaddr);
+			if (ret)
+				return ret;
+
+			ret =3D vgic_v5_restore_ist_entry(kvm, ist, h_iste_addr,
+							h_iste, intid,
+							intid_type);
+			if (ret)
+				return ret;
+
+			uaddr++;
+		}
+	}
+
+	return 0;
+}
+
+/*
+ * Restore the SPI IST from userspace-provided buffer to the host-allocate=
d IST.
+ */
+int vgic_v5_restore_spi_ist(struct kvm *kvm, struct kvm_vgic_v5_ist *ist_a=
ttr)
+{
+	u32 __user *uaddr;
+	struct vgic_v5_ist_desc ist;
+	int ret;
+
+	ret =3D vgic_v5_get_spi_ist_desc(kvm, !!ist_attr->spi_ist_addr, &ist);
+	if (ret || !ist.present)
+		return ret;
+
+	uaddr =3D (u32 __user *)(unsigned long)ist_attr->spi_ist_addr;
+
+	/* The host SPI IST is always linear. */
+	return vgic_v5_restore_linear_ist(kvm, &ist, uaddr,
+					  kvm->arch.vgic.nr_spis,
+					  GICV5_HWIRQ_TYPE_SPI);
+}
+
+/*
+ * Restore the LPI IST from userspace memory to the host-allocated LPI IST=
.
+ *
+ * The host LPI IST may be linear or two-level, so host iteration depends =
on the
+ * host IST's shape.
+ */
+int vgic_v5_restore_lpi_ist(struct kvm *kvm, struct kvm_vgic_v5_ist *ist_a=
ttr)
+{
+	u32 __user *uaddr;
+	struct vgic_v5_ist_desc ist;
+	int ret;
+
+	ret =3D vgic_v5_get_lpi_ist_desc(kvm, &ist);
+	if (ret)
+		return ret;
+
+	if (!ist.present)
+		return 0;
+
+	uaddr =3D (u32 __user *)(unsigned long)ist_attr->lpi_ist_addr;
+
+	if (!ist.vmi->h_lpi_ist_structure)
+		return vgic_v5_restore_linear_ist(kvm, &ist, uaddr,
+						  BIT(ist.id_bits),
+						  GICV5_HWIRQ_TYPE_LPI);
+
+	return vgic_v5_restore_two_level_ist(kvm, &ist, uaddr,
+					     GICV5_HWIRQ_TYPE_LPI);
+}
+
+/*
+ * Process the pending IRQs removing them from the list and optionally inj=
ecting
+ * them.
+ */
+static int vgic_v5_process_pending_irqs(struct kvm *kvm, bool inject)
+{
+	u32 vm_id =3D vgic_v5_vm_id(kvm);
+	struct vgic_v5_vm_info *vmi;
+
+	lockdep_assert_held(&kvm->arch.config_lock);
+
+	vmi =3D xa_load(&vm_info, vm_id);
+	if (!vmi)
+		return -ENXIO;
+
+	vgic_v5_drain_pending_irqs(kvm, vmi, inject);
+
+	return 0;
+}
+
+/* Replay pending state that was cleared while restoring guest IST state. =
*/
+int vgic_v5_restore_pending_irqs(struct kvm *kvm)
+{
+	return vgic_v5_process_pending_irqs(kvm, true);
+}
+
+/* Drop pending state collected by a failed IST restore. */
+void vgic_v5_discard_pending_irqs(struct kvm *kvm)
+{
+	vgic_v5_process_pending_irqs(kvm, false);
+}
diff --git a/arch/arm64/kvm/vgic/vgic-v5-tables.h b/arch/arm64/kvm/vgic/vgi=
c-v5-tables.h
index bc2fc5cb2c8d9..9a272b8cc6c87 100644
--- a/arch/arm64/kvm/vgic/vgic-v5-tables.h
+++ b/arch/arm64/kvm/vgic/vgic-v5-tables.h
@@ -8,6 +8,7 @@
=20
 #include <linux/idr.h>
 #include <linux/irqchip/arm-gic-v5.h>
+#include <linux/list.h>
=20
 /* Level 1 Virtual Machine Table Entry */
 typedef __le64 vmtl1_entry;
@@ -43,6 +44,9 @@ struct vgic_v5_vm_info {
 	__le64			*h_lpi_ist;
 	__le64			**h_lpi_l2_ists;
 	__le64			*h_spi_ist;
+
+	/* Tracking of pending interrupts as part of IST restore */
+	struct list_head	pending_irqs;
 };
=20
 struct vgic_v5_vmt {
@@ -94,7 +98,19 @@ int vgic_v5_vmte_alloc_vpe(struct kvm_vcpu *vcpu);
 int vgic_v5_vmte_free_vpe(struct kvm_vcpu *vcpu);
=20
 int vgic_v5_spi_ist_alloc(struct kvm *kvm, unsigned int id_bits);
+int vgic_v5_lpi_ist_exists(struct kvm *kvm);
 int vgic_v5_lpi_ist_alloc(struct kvm *kvm, unsigned int id_bits);
 int vgic_v5_lpi_ist_free(struct kvm *kvm);
=20
+int vgic_v5_save_spi_ist(struct kvm *kvm,
+			 struct kvm_vgic_v5_ist *ist_attr);
+int vgic_v5_save_lpi_ist(struct kvm *kvm,
+			 struct kvm_vgic_v5_ist *ist_attr);
+int vgic_v5_restore_spi_ist(struct kvm *kvm,
+			    struct kvm_vgic_v5_ist *ist_attr);
+int vgic_v5_restore_lpi_ist(struct kvm *kvm,
+			    struct kvm_vgic_v5_ist *ist_attr);
+int vgic_v5_restore_pending_irqs(struct kvm *kvm);
+void vgic_v5_discard_pending_irqs(struct kvm *kvm);
+
 #endif
diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 6af1264ed2371..153a8fcd4db7c 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -8,6 +8,8 @@
 #include <linux/bitops.h>
 #include <linux/irqchip/arm-vgic-info.h>
 #include <linux/irqdomain.h>
+#include <linux/kvm_host.h>
+#include <linux/uaccess.h>
=20
 #include "vgic.h"
 #include "vgic-v5-tables.h"
@@ -245,6 +247,17 @@ static int vgic_v5_irs_wait_for_vpe_op(void)
 					NULL);
 }
=20
+/*
+ * Wait for a write to IRS_SAVE_VMR to complete.
+ */
+static int vgic_v5_irs_wait_for_save_vm_op(u32 *statusr)
+{
+	return gicv5_wait_for_op_atomic(irs_caps.irs_base,
+					GICV5_IRS_SAVE_VM_STATUSR,
+					GICV5_IRS_SAVE_VM_STATUSR_IDLE,
+					statusr);
+}
+
 static int vgic_v5_irs_write_vm_mmio_reg(u64 val, u32 offset)
 {
 	int ret;
@@ -406,6 +419,27 @@ static int vgic_v5_irs_set_up_vpe(u16 vm_id, u16 vpe_i=
d,
 	return 0;
 }
=20
+static int vgic_v5_irs_save_vm_op(u16 vm_id, bool save, u32 *statusr)
+{
+	u64 save_vmr;
+	int ret;
+
+	save_vmr =3D FIELD_PREP(GICV5_IRS_SAVE_VMR_VM_ID, vm_id);
+	save_vmr |=3D GICV5_IRS_SAVE_VMR_Q;
+	save_vmr |=3D FIELD_PREP(GICV5_IRS_SAVE_VMR_S, save);
+
+	guard(raw_spinlock_irqsave)(&global_irs_lock);
+
+	/* Make sure that we are idle to begin with. */
+	ret =3D vgic_v5_irs_wait_for_save_vm_op(NULL);
+	if (ret)
+		return ret;
+
+	irs_writeq_relaxed(save_vmr, GICV5_IRS_SAVE_VMR);
+
+	return vgic_v5_irs_wait_for_save_vm_op(statusr);
+}
+
 static irqreturn_t db_handler(int irq, void *data)
 {
 	struct kvm_vcpu *vcpu =3D data;
@@ -1102,9 +1136,9 @@ static bool vgic_v5_set_spi_pending_state(struct kvm_=
vcpu *vcpu,
 	return true;
 }
=20
-static bool vgic_v5_spi_queue_irq_unlock(struct kvm *kvm,
-					 struct vgic_irq *irq,
-					 unsigned long flags)
+bool vgic_v5_spi_queue_irq_unlock(struct kvm *kvm,
+				  struct vgic_irq *irq,
+				  unsigned long flags)
 	__releases(&irq->irq_lock)
 {
 	lockdep_assert_held(&irq->irq_lock);
@@ -1267,3 +1301,292 @@ void vgic_v5_save_state(struct kvm_vcpu *vcpu)
 	__vgic_v5_save_ppi_state(cpu_if);
 	dsb(sy);
 }
+
+static int vgic_v5_irs_status_is_quiesced(u32 statusr)
+{
+	if (statusr & GICV5_IRS_SAVE_VM_STATUSR_Q)
+		return 0;
+
+	return -EBUSY;
+}
+
+static int vgic_v5_irs_is_quiesced(u16 vm_id)
+{
+	u32 statusr;
+	int ret;
+
+	ret =3D vgic_v5_irs_save_vm_op(vm_id, false, &statusr);
+	if (ret)
+		return ret;
+
+	return vgic_v5_irs_status_is_quiesced(statusr);
+}
+
+static int vgic_v5_copy_ist_attr(struct kvm_device_attr *attr,
+				 struct kvm_vgic_v5_ist *ist_attr)
+{
+	void __user *uaddr =3D (void __user *)(unsigned long)attr->addr;
+
+	if (!uaddr)
+		return -EINVAL;
+
+	if (copy_from_user(ist_attr, uaddr, sizeof(*ist_attr)))
+		return -EFAULT;
+
+	return 0;
+}
+
+static int vgic_v5_validate_ist_user_buffer(__u64 addr, __u64 size,
+					    size_t expected)
+{
+	if (!addr || size !=3D expected)
+		return -EINVAL;
+
+	return 0;
+}
+
+static int vgic_v5_validate_ist_attr(struct kvm *kvm,
+				     const struct kvm_vgic_v5_ist *ist_attr)
+{
+	unsigned int id_bits;
+	int ret;
+
+	/* We always have SPIs to save */
+	ret =3D vgic_v5_validate_ist_user_buffer(ist_attr->spi_ist_addr,
+					ist_attr->spi_ist_size,
+					kvm->arch.vgic.nr_spis * sizeof(__u32));
+	if (ret)
+		return ret;
+
+	/* We don't always have LPIs to save */
+	ret =3D vgic_v5_irs_lpi_ist_id_bits(kvm, &id_bits);
+	if (ret < 0)
+		return ret;
+
+	/* No LPI IST */
+	if (!ret) {
+		if (ist_attr->lpi_ist_addr || ist_attr->lpi_ist_size)
+			return -EINVAL;
+
+		return 0;
+	}
+
+	return vgic_v5_validate_ist_user_buffer(ist_attr->lpi_ist_addr,
+					       ist_attr->lpi_ist_size,
+					       BIT(id_bits) * sizeof(__u32));
+}
+
+int vgic_v5_irs_save_ists(struct kvm *kvm, struct kvm_device_attr *attr)
+{
+	struct kvm_vgic_v5_ist ist_attr;
+	u16 vm_id =3D vgic_v5_vm_id(kvm);
+	u32 statusr;
+	int ret =3D 0;
+
+	mutex_lock(&kvm->lock);
+
+	if (kvm_trylock_all_vcpus(kvm)) {
+		mutex_unlock(&kvm->lock);
+		return -EBUSY;
+	}
+
+	mutex_lock(&kvm->arch.config_lock);
+
+	if (!vgic_initialized(kvm)) {
+		ret =3D -EBUSY;
+		goto out_unlock;
+	}
+
+	ret =3D vgic_v5_copy_ist_attr(attr, &ist_attr);
+	if (ret)
+		goto out_unlock;
+
+	ret =3D vgic_v5_validate_ist_attr(kvm, &ist_attr);
+	if (ret)
+		goto out_unlock;
+
+	ret =3D vgic_v5_irs_save_vm_op(vm_id, true, &statusr);
+	if (ret) {
+		kvm_err("Failed to save GICv5 IRS VM state: %d\n", ret);
+		goto out_unlock;
+	}
+
+	ret =3D vgic_v5_irs_status_is_quiesced(statusr);
+	if (ret)
+		goto out_unlock;
+
+	/* Save the SPI IST to the userspace buffer. */
+	ret =3D vgic_v5_save_spi_ist(kvm, &ist_attr);
+	if (ret)
+		goto out_unlock;
+
+	ret =3D vgic_v5_irs_is_quiesced(vm_id);
+	if (ret)
+		goto out_unlock;
+
+	/* Save the LPI IST to the userspace buffer. */
+	ret =3D vgic_v5_save_lpi_ist(kvm, &ist_attr);
+	if (ret)
+		goto out_unlock;
+
+	ret =3D vgic_v5_irs_is_quiesced(vm_id);
+	if (ret)
+		goto out_unlock;
+
+out_unlock:
+	mutex_unlock(&kvm->arch.config_lock);
+	kvm_unlock_all_vcpus(kvm);
+	mutex_unlock(&kvm->lock);
+
+	return ret;
+}
+
+/* Allocate the LPI IST to restore into */
+static int vgic_v5_restore_lpi_ist_alloc(struct kvm *kvm, bool *allocated)
+{
+	unsigned int id_bits;
+	int ret;
+
+	*allocated =3D false;
+
+	ret =3D vgic_v5_irs_lpi_ist_id_bits(kvm, &id_bits);
+	if (ret <=3D 0)
+		return ret;
+
+	ret =3D vgic_v5_lpi_ist_alloc(kvm, id_bits);
+	if (ret)
+		return ret;
+
+	*allocated =3D true;
+
+	return 0;
+}
+
+/*
+ * Clean up the LPI IST if we allocated it, and restore the VMTE to the
+ * original, valid state.
+ */
+static void vgic_v5_restore_cleanup(struct kvm *kvm,
+				    struct kvm_vcpu *vcpu,
+				    bool lpi_ist_allocated)
+{
+	/*
+	 * We are on the restore failure path, so we do a best-effort
+	 * cleanup. These commands might fail, but at this stage this is the
+	 * best we can realistically do.
+	 */
+	if (lpi_ist_allocated) {
+		if (!vgic_v5_send_command(vcpu, VMTE_MAKE_INVALID))
+			vgic_v5_lpi_ist_free(kvm);
+	}
+
+	vgic_v5_send_command(vcpu, VMTE_MAKE_VALID);
+}
+
+int vgic_v5_irs_restore_ists(struct kvm *kvm, struct kvm_device_attr *attr=
)
+{
+	bool lpi_ist_allocated =3D false, vmte_invalid =3D false;
+	struct kvm_vcpu *vcpu0 =3D kvm_get_vcpu(kvm, 0);
+	struct kvm_vgic_v5_ist ist_attr;
+	int ret =3D 0;
+
+	mutex_lock(&kvm->lock);
+
+	if (kvm_trylock_all_vcpus(kvm)) {
+		mutex_unlock(&kvm->lock);
+		return -EBUSY;
+	}
+
+	mutex_lock(&kvm->arch.config_lock);
+
+	if (!vgic_initialized(kvm)) {
+		ret =3D -EBUSY;
+		goto out_unlock;
+	}
+
+	if (kvm_vm_has_ran_once(kvm)) {
+		ret =3D -EBUSY;
+		goto out_unlock;
+	}
+
+	ret =3D vgic_v5_copy_ist_attr(attr, &ist_attr);
+	if (ret)
+		goto out_unlock;
+
+	ret =3D vgic_v5_validate_ist_attr(kvm, &ist_attr);
+	if (ret)
+		goto out_unlock;
+
+	ret =3D vgic_v5_lpi_ist_exists(kvm);
+	if (ret) {
+		if (ret > 0)
+			ret =3D -EBUSY;
+		goto out_unlock;
+	}
+
+	/*
+	 * If the guest has previously allocated an IST (which we check based on
+	 * the IRS_IST_BASER), extract the number of LPI ID bits from the
+	 * IRS_IST_CFGR. Else, do nothing.
+	 *
+	 * We do this before making the VMTE invalid as we rely on
+	 * IRS_VMAP_VISTR to mark the IST as valid in the VMTE. This can only
+	 * happen while the VMTE is valid.
+	 */
+	ret =3D vgic_v5_restore_lpi_ist_alloc(kvm, &lpi_ist_allocated);
+	if (ret)
+		goto out_unlock;
+
+	/*
+	 * Host ISTs are updated while the VMTE is invalid, so the GIC cannot
+	 * observe partially restored state.
+	 */
+	ret =3D vgic_v5_send_command(vcpu0, VMTE_MAKE_INVALID);
+	if (ret) {
+		/*
+		 * If invalidation fails, the restore cannot safely update host
+		 * IST state.
+		 */
+		goto out_unlock;
+	}
+	vmte_invalid =3D true;
+
+	/* Restore the SPI IST from the userspace buffer. */
+	ret =3D vgic_v5_restore_spi_ist(kvm, &ist_attr);
+	if (ret)
+		goto out_unlock;
+
+	/* Restore the LPI IST from the userspace buffer. */
+	if (lpi_ist_allocated) {
+		ret =3D vgic_v5_restore_lpi_ist(kvm, &ist_attr);
+		if (ret)
+			goto out_unlock;
+	}
+
+	/* And make the VM Valid again */
+	ret =3D vgic_v5_send_command(vcpu0, VMTE_MAKE_VALID);
+	if (ret)
+		goto out_unlock;
+	vmte_invalid =3D false;
+
+	/*
+	 * As part of restoring the ISTs, and previously pending interrupts have
+	 * been tracked and made non-pending. Now that the ISTs have been
+	 * restored, and the VM is valid again, restore the pending interrupts.
+	 */
+	ret =3D vgic_v5_restore_pending_irqs(kvm);
+	if (ret)
+		goto out_unlock;
+
+out_unlock:
+	if (ret && (vmte_invalid || lpi_ist_allocated)) {
+		vgic_v5_discard_pending_irqs(kvm);
+		vgic_v5_restore_cleanup(kvm, vcpu0, lpi_ist_allocated);
+	}
+
+	mutex_unlock(&kvm->arch.config_lock);
+	kvm_unlock_all_vcpus(kvm);
+	mutex_unlock(&kvm->lock);
+
+	return ret;
+}
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index 7536e9a13086e..cb673da96ec55 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -373,6 +373,8 @@ void vgic_v5_teardown(struct kvm *kvm);
 int vgic_v5_map_resources(struct kvm *kvm);
 void vgic_v5_set_ppi_ops(struct kvm_vcpu *vcpu, u32 vintid);
 void vgic_v5_set_spi_ops(struct vgic_irq *irq);
+bool vgic_v5_spi_queue_irq_unlock(struct kvm *kvm, struct vgic_irq *irq,
+				  unsigned long flags);
 void vgic_v5_set_irq_pend(struct kvm_vcpu *vcpu, struct vgic_irq *irq);
 bool vgic_v5_has_pending_ppi(struct kvm_vcpu *vcpu);
 void vgic_v5_flush_ppi_state(struct kvm_vcpu *vcpu);
@@ -384,11 +386,14 @@ void vgic_v5_get_vmcr(struct kvm_vcpu *vcpu, struct v=
gic_vmcr *vmcr);
 void vgic_v5_restore_state(struct kvm_vcpu *vcpu);
 void vgic_v5_save_state(struct kvm_vcpu *vcpu);
 int vgic_v5_register_irs_iodev(struct kvm *kvm, gpa_t irs_base_address);
+int vgic_v5_irs_lpi_ist_id_bits(struct kvm *kvm, unsigned int *id_bits);
=20
 int vgic_v5_cpu_sysregs_uaccess(struct kvm_vcpu *vcpu,
 				struct kvm_device_attr *attr, bool is_write);
 int vgic_v5_has_cpu_sysregs_attr(struct kvm_vcpu *vcpu, struct kvm_device_=
attr *attr);
 const struct sys_reg_desc *vgic_v5_get_sysreg_table(unsigned int *sz);
+int vgic_v5_irs_save_ists(struct kvm *kvm, struct kvm_device_attr *attr);
+int vgic_v5_irs_restore_ists(struct kvm *kvm, struct kvm_device_attr *attr=
);
 int vgic_v5_irs_attr_regs_access(struct kvm_device *dev,
 				 struct kvm_device_attr *attr,
 				 u64 *reg, bool is_write);
--=20
2.34.1
