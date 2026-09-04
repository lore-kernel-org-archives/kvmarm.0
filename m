Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010031.outbound.protection.outlook.com [52.101.84.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B8D44772B6
	for <kvmarm@lists.linux.dev>; Fri,  4 Sep 2026 11:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.31
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788522186; cv=fail; b=SVgh1+ceN8Y2GHOLYLMcTSnyNTXEEyAS3zMoy6ZsBM2SwnEjF03FNpDYX5tojjvhvI7rjCJfSJeMnPBWs2YGEf7xwEwslZk5cSEwO6H81hUKMoanLtuLx/2ULWiF4zNIIxxi93bjjukDG4bzr1OH345Wov5uZrKvl1K6gNYpQRw=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788522186; c=relaxed/simple;
	bh=X8MPSujpGpHoZgvYTT9kbCmkXBIf2TBsnfNiZ1obNBw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=akW5WO2cbLKkBrgRIq76ZKLSCXPv2TJ4QEYRDY+w/ONEtjOGMsdm6e98L00sg/2eJvhaOJvl3fAMVsy6lYDdPGhWECBNzUqzEPKm5Wz8gSvFvTvDz4te5mHLAUeMZ84bZ7xWGUHpnEFrMCBxLN/hoQmpwj8YHhetC8xcXo8yHuk=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=WdyvGa+L; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=WdyvGa+L; arc=fail smtp.client-ip=52.101.84.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="WdyvGa+L";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="WdyvGa+L"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=Jeiu8knis+BIxpWsx43B6SDLkFKhXSsyOlp1D5LsdNAAW+UnvkaYFhhv9q4s2jk3Oi11Tn+saY62Q3Qj0P2uuUqtTlFpgdu3UTcpQ5f7lpbJfPIaz4g4IWBVyOXVZywcxb4y7FtVKOa8U1+0t9OhMo5GJe5aedAM9JYKOcT9Lr9IP7xw9kPgZIBFu5BXHi2rppAwfYyiplc7HPc/2EhoRtM+5umSMTv9EQZNMvs33cbzyGqY/sK53547fsWpWaYP9yb9rsINyhCmc757Vspb4a5vneaXyrsWtN9YnZh12RQcQMEOppTDUNrKWr5GApFz2XlV+lr/xtlLkSQKdfWDHA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MmmGjAkOYnN16SSfZzDCXlc5ekrmgREeQGO2+hL96uU=;
 b=PaNV2LKlt78/VKIOJOvmfNF/lVOrth+QKeM9I3p1RY9oM0BgZzLg5athqQpENysSZGyjwBVQGJ8gEqTMRKcFortp7VMpHEiJ9k1Yn5vt0mIu00/aYLRS3NI8nXMdDXJ2v2qUjqS6hKkBD8c3fdRTErcN7sAZ6JdJXRh1Mj7mvwdcKOzHpfnX/Hy91lJ33mlWyuPe3q/o7HWjLS3+Fp6NN/+LUsPcx+IgrOoCLIR2RhyI6LhU+RkGuiWc6Hacq93QszQbYmkyL5t86Qb2PwAIWXeddTc02NuYIkegpWbT7kNK1n6sLwbFiACEkRTzLZRpQWsrvv6O399/nsM50h2izg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MmmGjAkOYnN16SSfZzDCXlc5ekrmgREeQGO2+hL96uU=;
 b=WdyvGa+L6/brkKQpOvmGmjkNU8+zzaTOyGBBqGdNLeb7YIGjj6YjDi/wQPFVe39mtXTWxhWhuIRW+/uQ9bmfTaKVOmN2WcTFVrs8nCabSRpqyQP2Trp3KrXdUcaMCi6ND8BUCGlUFJvtz5WmB796kRUy6YPBp9CkeGRV6LVCmG8=
Received: from AS4P195CA0001.EURP195.PROD.OUTLOOK.COM (2603:10a6:20b:5e2::8)
 by GV2PR08MB9255.eurprd08.prod.outlook.com (2603:10a6:150:e3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 11:42:59 +0000
Received: from AMS1EPF00000099.eurprd02.prod.outlook.com
 (2603:10a6:20b:5e2:cafe::7d) by AS4P195CA0001.outlook.office365.com
 (2603:10a6:20b:5e2::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.12 via Frontend Transport; Fri, 4
 Sep 2026 11:42:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS1EPF00000099.mail.protection.outlook.com (10.167.242.70) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.8
 via Frontend Transport; Fri, 4 Sep 2026 11:42:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xeqHN8JdZtshiyM0YnzEMhas9h7oL1ou+Rg0lQkrrrbgdU07JOcj6s4YUdeQSADxlLCSyStPS313ZQ8sJ+KsLQ6cEqGHW6aUIOa7X/PC5+uaZUn+znUhWI22Z0GSYe5LWzHlUmABtAMEGphKCzmx1QVGR5Lyjcj1uC6k7HRKJYZUdoVo8HGEHcZLwOC0EJyPm8laE2RATygQLqBENup06sSbnI+H4XMgos7+dpBNPsxpWsoRY1KpohqE5kibj//iTmWslVpTJsuWHtEu1VaGd7I3Rwq5eMy1j2P2irknJ0Km0LTRQINjPTKcLiFTyPCjzO+Gag5/OzxsWchbOSyVfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MmmGjAkOYnN16SSfZzDCXlc5ekrmgREeQGO2+hL96uU=;
 b=Vt8qA34AN5iLjGpqei7vgxlZECLMd5HAFCUEMfAohi9NkqxpX7ijcFLmsJuioX8V0PVRkSHrhd17n8PXG7heN+tC9b4Pn8yRqoo0cumf58qHu550R9WibNKPe10S1i4xiN8aJtFYm/UOfky1tIJPt3OznkXFmGwVlOABfe3ynPU9XphE1StEYoTFjYumL9fgzvKmzwqxa8v1HTiicjzL1IEJdKa/6ecrY0qF44t6wXy+rsCCfZWxtV3d01gvkkIkv+vdkElFbaLo0yMhQXbjIfeSgB2NcQysN+E8ZwL/tOYyuYgDMS1gbq3hdnSLgZ0zTDrFy/4ppRAISlDemOSdWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MmmGjAkOYnN16SSfZzDCXlc5ekrmgREeQGO2+hL96uU=;
 b=WdyvGa+L6/brkKQpOvmGmjkNU8+zzaTOyGBBqGdNLeb7YIGjj6YjDi/wQPFVe39mtXTWxhWhuIRW+/uQ9bmfTaKVOmN2WcTFVrs8nCabSRpqyQP2Trp3KrXdUcaMCi6ND8BUCGlUFJvtz5WmB796kRUy6YPBp9CkeGRV6LVCmG8=
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com (2603:10a6:101:1d::23)
 by GVXPR08MB10864.eurprd08.prod.outlook.com (2603:10a6:150:154::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 11:42:24 +0000
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e]) by PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e%4]) with mapi id 15.21.0382.007; Fri, 4 Sep 2026
 11:42:24 +0000
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
Subject: [PATCH v6 16/49] KVM: arm64: gic-v5: Request doorbells when VPEs
 enter WFI
Thread-Topic: [PATCH v6 16/49] KVM: arm64: gic-v5: Request doorbells when VPEs
 enter WFI
Thread-Index: AQHdPGJ0rv1ZDRI6/k+ioWHnXfRI8Q==
Date: Fri, 4 Sep 2026 11:42:24 +0000
Message-ID: <20260904113404.4051341-17-sascha.bischoff@arm.com>
References: <20260904113404.4051341-1-sascha.bischoff@arm.com>
In-Reply-To: <20260904113404.4051341-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	PR2PR08MB4889:EE_|GVXPR08MB10864:EE_|AMS1EPF00000099:EE_|GV2PR08MB9255:EE_
X-MS-Office365-Filtering-Correlation-Id: b264c3ed-b84f-4ed1-e488-08df0a79ab7d
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|23010399003|1800799024|366016|10067099003|3023799007|11063799006|22082099003|56012099006|38070700021|18002099003;
X-Microsoft-Antispam-Message-Info-Original:
 QpPdfT4dzKBzzBeGXIAon1oztqxfmrOaS4YCM5YNaZ+19sVytiIAe/xmrMwG/sdHDm0wHXsPGDtut8ETH522HoVzbrM0MB4B3odYBxzonFoh1PupAQCRigkkvF1ubaX3QzwojCXVoE9Ihlr0VexbAMp2rmsYjyzl+uOpuGouF/fm2Wb2WRHHxWs7ZxkRqL+PV58uGFFKRRPXXSGpbvv7wrhs8U6e9/jaVTpmGANezXfcp2VvQEUD0PhE7NdSGcyyH++NFqfpnoq6wNnRLkaoZApwDYQlo76PmBqlf+VNoiri9mwasZr/tK8hwQaXydv6blDXAcDNif07nWqjOk1PbJt1coYrOzlrAiwGK2sNZSrpB+v/ka6+Wgyva30pvwqbnWor2T3NjaVbff5uFsfd5riHTBmkOsvVImkmqD8uqqXXADrDcebUQEOT5GIBJK2ZnRlLNrBKK8xOfHtlBrQWicE3HRmSf67J5jE3F4JqYUCU1jLZLmQyJYpOvx22FSyvzM+DlLGhXcg3GDr8gPUNGgKvWT0yGiO5brXwgWJ+ex/KPn9UfcM7ATZqXZ0Ja7hl9fM2/cv57yc/dMy322ba80vAz8f0zVXJJPBBblsnVJNtWDydx0M/9eoD7e5NDJAJNBAWrVYB0NYX762V7Jehe/eRyacQgHGy/mp6b4FlobxtKzUpXUlRy3NAKDY8un0QtXiNxlPQkzQMoLvSvLnj2wlZT3X+Bh22XWOpLOQmuOM=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR2PR08MB4889.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(366016)(10067099003)(3023799007)(11063799006)(22082099003)(56012099006)(38070700021)(18002099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 h5eKc+jn3oelMjgo5BfETMUNeFbhD731uFjgcTzFSJRdNdiGGfWxVHvtM5eURr4+iqIaI2yNsbj0XY2jjssuvwxQKxws6FOgqeBj4hz4dYh3HGPPehmm48ilH54roBnPpKLWSdFsPsTYg6tIUXEJs4Pgu5WV49OrhYRagUko0mBG2h7vqCvqgOmG6RPNfwQyh37BHNxLYIwtN92M6btTPkEBAoNWGzGQOEpo9F9PTJxYD9xRiVLruOD/YCBL+99x1Q7di5knHwC6CxaF9XbBUpE/aWex5xyhLLM+NhzpRyb99th0jKuqYsWzUfuoiaAc/HqzGeYAbhomN5+QwgZC4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR08MB10864
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS1EPF00000099.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	4a38495d-f096-460c-39ef-08df0a7996aa
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|1800799024|376014|35042699022|23010399003|82310400026|36860700016|10067099003|56012099006|11063799006|3023799007|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	9H6NwJwmUaS8qgWfZ43FzkRzUEK3PTwYCpA7GrMwj1O9hfVPuAa6PGTHBCZ8PYammnyzBV5ddUMPC33/JNkF56SIkyJax5g83145ZXJ0BXRSazwdfSZcjyouL46hAll+xebIWt+K3MhJDlyagq3uvIOvtjB5DNYEvG9AfN639jEHVeXczpdIyjjSuQ5mwuH8S7wlMXeTrRw8sxj5qu/Of+O+kAqfM+zdi98UIR+tf0a/iuO/Ro5dxv6Uw5xxwqimzUKnaWGlgFt2rYn1hLHCvTtVChbbCiS3eHURBQbPI5RdHAM/ySgqNkWR41KYQl/QsFo+V9FTVCpp1LWz23IMZCS0Mf4TeVNwbBew86AAozYVcWnFr4JGqGJiNQlC86lpSDujH1NGWzJaYRTXLipprpShdM/bErwmZ7c+anGfiwO7FlrjFJmZnInHs6BJS7KFeq0XFIv5l2NcwlQL9ANC8L0U7QLNYUciDm0PX9QK7JKqcm/lKEfnT7yrHDTxEJ9mSkOB8VAFFzfxa7ARnfNGtkmpUned126S8YWflT5Xw3nHLowQvJO30F5P4Nn6KIOUnqa/zaVbumrRzkAGMepbN4G1n7Qi0FYzqzY6KADIeYrxjXCQzXfZMeyYL4+ggUkAFtK65R9+17bqNgwpwSBH8+/8LFBszPImarUKhagR0ME=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(1800799024)(376014)(35042699022)(23010399003)(82310400026)(36860700016)(10067099003)(56012099006)(11063799006)(3023799007)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	EKAVq6yqAiVENJsEdwAEuboOUBWhF93+lPtflUQ4aB/QeuQi4kxntn8vyzzLkS61u8QljpYrxE8447mG0iAd15o3ItfNBDS7U1BsRQUTVbjcl8iSFKk/WWsZJQfqlK3DLKsS6IEH7Hbydfo8uW6D4BpFHNKLWCra6gHT6Rp9yFdfri1wtsW1laMrzxnmzHI+x1rKYBT8BEknxe6sfX24cpI8ZacA7MjHeVnYgq69pFEtujwSmhLgZzJDh47XZgLD1u8dNlPViSsjzpZacjPAnEMdYcvs0AYj39V3upM7Ao/U+P+fYZfkwCDWnRpjNj6AIlgLR3zHLz5EVxyhYEa4VB/9LjxpBtnzDTpzJVJ/uE+Nt1ej4ghSL7vNR5DG05Jkr7efFq0dpfK9gCRG8Yj1uYaJDEgGvZsMKd9ELIFb89lshA5UUQa4AFwS0VVBY7Ke
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2026 11:42:59.3352
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b264c3ed-b84f-4ed1-e488-08df0a79ab7d
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS1EPF00000099.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR08MB9255

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

Attempt to make the doorbell interrupt affine to the current CPU
before requesting it. Treat affinity failures as non-fatal and
continue using the existing placement. A successful move nudges the
wakeup back towards the CPU that last ran the vcpu, where the relevant
state is more likely to be cache-hot, while also spreading doorbell
interrupts across host PEs as different vcpus enter WFI on different
CPUs.

Clear stale db_fired state before making the VPE non-resident. Any
previous doorbell notification has already been consumed by this
point, and clearing it before the non-resident transition ensures that
a newly fired doorbell is observed.

Finally, teach kvm_vgic_vcpu_pending_irq() to report pending work for
a GICv5 vcpu when its VPE doorbell has fired, in addition to the
existing pending-PPI check.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/hyp/vgic-v5-sr.c |  9 +++++++
 arch/arm64/kvm/vgic/vgic-v5.c   | 46 +++++++++++++++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic.c      |  6 ++++-
 3 files changed, 60 insertions(+), 1 deletion(-)

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
index d7d6db5014269..5a058ef8fe701 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -1095,6 +1095,52 @@ void vgic_v5_put(struct kvm_vcpu *vcpu)
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
+			if (!cpumask_test_cpu(cpu, aff)) {
+				int ret;
+
+				ret =3D irq_set_affinity(db_irq, cpumask_of(cpu));
+				if (ret)
+					kvm_debug_ratelimited("Failed to move doorbell IRQ %d to CPU %d: %d\n=
",
+							      db_irq, cpu, ret);
+			}
+		}
+	}
=20
 	kvm_call_hyp(__vgic_v5_make_non_resident, cpu_if);
=20
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index b25303d9919fd..ca4fb45f7d501 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -1236,8 +1236,12 @@ int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu)
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
