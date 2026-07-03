Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013001.outbound.protection.outlook.com [52.101.83.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 648822DC798
	for <kvmarm@lists.linux.dev>; Fri,  3 Jul 2026 16:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.1
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783094948; cv=fail; b=LEZM9NkF8yFWetULc5soENrNJKhURtRft7HVS8WzOJUKLLUQbHCv8HLkVH/k38RYhj969jh+XqoX0A9unXxJKUXt6aemM5nwkh6Mfxi5vsdd06dpH5Rf1Up5Znl3gHCy/FAJvPLpkkopGAuoG2ViTogmKaIa+4OQ7G7LbNCjeu8=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783094948; c=relaxed/simple;
	bh=jtiUQ8FpkIkYWyXHMgTtMn31F8Qkyf8+4UvyylK8LL8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=biivFWIj6hjUq1lm7nxdH9nTOyidgKEzgtnmepqPV6y08D1jOcvvVabnpmHI9TBt3XynEq1zlHE4BJN6MZHP4gwpTE/oq7PDmAk/h51yzA6mKZ+rjaN1YmGph7xJ/jFylVG1hSljNqPLVghpfVSwF+VbwerZ+KMiECBLHobvJN8=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=AlT+wcn8; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=AlT+wcn8; arc=fail smtp.client-ip=52.101.83.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="AlT+wcn8";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="AlT+wcn8"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=BAIFDMLZWJmURAJQ3oGaC/JhtK7qokeBO/JAEJ/bzQghqcOrMjPcBpCMmen5uSIKIGwYwsnvteUsu1RUVJ8wTgGMlt5W1FdhXqdou8XDJJ2PC2Z7/uQnCXkfwstTgPvR2rQNeztXpFhD0A098hjduaRXTcTMS835FwekyX51OkdDq6FWVjsf/oHGCLJUTFTJJnmP5f8ZKoCuhkCGaDL7n2kXpNbQvVIqXqcNGaq+BLJ4TtvKDKbU7gI4kKkG+AJzDYikhV0bXgDNiOQpNZQW1i0SAf6575nEMNBhNulbuvpxZUZ7GPIy5j3o60xcZQcNuyr4hfvAWAl6xQuh6Ei1/Q==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LI/5POaRIRXRu7GjdUSJsFwFsUj2dhJ7GEvB3d4xXIk=;
 b=JM0lpc87nIo/0Ak/Pl3WuhD8k5CuHemg64FBfvcnIv0ZYpG1ht55HiYKPb+wZBMIYxLlDPifWwJt4AUiJsJyC5k40TjCNqUnDUmvKK9BSPe7POZOsMcwkHhnvO1brBkNbNZrDAf1SELFZQ5mZWmBMblUtS/9w+7PLiWIUHPmPHb8XZahA85IG46sJjo8ZXmiw8+qj44/7hocdOqoCiEoF14+hIpjWClA35EECsluCaBPZj3kdxhQFXeG3KS/DHPQpWDBF0aniNjMJSgd5Q5HZ7Iq4+/1KIVUg3vN1/CPmOqtF1YoH9i6CaOeorQqu46PCrKPDTruNGaDd++fWZMizQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LI/5POaRIRXRu7GjdUSJsFwFsUj2dhJ7GEvB3d4xXIk=;
 b=AlT+wcn8rxyIPi7qqIuf3e5ibOtUIrEzaZnrCuxhr10Av28BvVU9K5np4/S3DWrKxM2Z+K1h1LxMkijp9x9kcdUGz4ZzCE4i8hIruKJWS2TU/6y2Qefshnc8tXxB8prjP9Fou3ZHEdkaEippKSNqO50awoRMVYF4EFDA4mCMJSY=
Received: from DU2PR04CA0240.eurprd04.prod.outlook.com (2603:10a6:10:2b1::35)
 by PA4PR08MB7457.eurprd08.prod.outlook.com (2603:10a6:102:2a4::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Fri, 3 Jul
 2026 16:08:54 +0000
Received: from DB1PEPF00050A00.eurprd03.prod.outlook.com
 (2603:10a6:10:2b1:cafe::54) by DU2PR04CA0240.outlook.office365.com
 (2603:10a6:10:2b1::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.11 via Frontend Transport; Fri, 3
 Jul 2026 16:08:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF00050A00.mail.protection.outlook.com (10.167.242.42) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.6
 via Frontend Transport; Fri, 3 Jul 2026 16:08:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=M7bXvOcjlmTSLHGSiDAjF1/nrdTyhVVfqf1BSkCE8z90blSRWvqDU/2jLkSL4zFujuKI0BzJnFzQVatdw8z0XuvvTclxpwmXBVmrAmsFu4PyyWeZw3YlvsWP0XrGHz4fj6lWxKJ7geVZHQ94Yt2u9avMH67CYrZNjCH5prnlhftjo/2EHJ0P13gQAARnUcIJyBHv4waRhnVSmemfjaJuX9Mc7T4JL3nHZ3UmAUV0Ta6tm7OvNVu3VL4mKmQV/gfdr9jPPOlqPdN7eDpG2FNWkV+aBiS4hv6Tp4HT57SOz88OiedE8WENXff7VndemmGQXdEyMgCui5xsQaq3uQlaZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LI/5POaRIRXRu7GjdUSJsFwFsUj2dhJ7GEvB3d4xXIk=;
 b=VqdPAxdo+eNrq3qi95HLNY0NWjf+2HVBWGO6L1j0ukaIbA0z7M3h/HWdMnNaT53b9WhOdthiokZ8cvCHwfTjPB4kQI6QZyKJq0WY3bcmXLB0E8NCG52ATiY6ugtv5COkjTUzjdghCrZlvfwLvdzQM70z+/GFXj8gLcGdhGmifPdrSscaFlvLHF+0OZFvgzeAqJYvHW1LcOYzuPxjc4PphNFdlmrpSgbhEM2OQW/4LDY4SaKuWQ+jB1di9o1N/6qMOpQ5a4h3C8xM5Fuqh2niYEQSEQNsD0bBVNk1vk3g3DGUo0CUb4VkErLaNyfCbGKYW55y7U25kseU/qj/j6g9Yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LI/5POaRIRXRu7GjdUSJsFwFsUj2dhJ7GEvB3d4xXIk=;
 b=AlT+wcn8rxyIPi7qqIuf3e5ibOtUIrEzaZnrCuxhr10Av28BvVU9K5np4/S3DWrKxM2Z+K1h1LxMkijp9x9kcdUGz4ZzCE4i8hIruKJWS2TU/6y2Qefshnc8tXxB8prjP9Fou3ZHEdkaEippKSNqO50awoRMVYF4EFDA4mCMJSY=
Received: from DU2PR08MB7310.eurprd08.prod.outlook.com (2603:10a6:10:2e5::5)
 by AM0PR08MB5459.eurprd08.prod.outlook.com (2603:10a6:208:186::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.11; Fri, 3 Jul
 2026 16:07:51 +0000
Received: from DU2PR08MB7310.eurprd08.prod.outlook.com
 ([fe80::e007:b494:8a24:1fc0]) by DU2PR08MB7310.eurprd08.prod.outlook.com
 ([fe80::e007:b494:8a24:1fc0%4]) with mapi id 15.21.0181.009; Fri, 3 Jul 2026
 16:07:51 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey Gouly
	<Joey.Gouly@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	Timothy Hayes <Timothy.Hayes@arm.com>
Subject: [PATCH v3 34/40] KVM: arm64: gic-v5: Handle userspace accesses to IRS
 MMIO region
Thread-Topic: [PATCH v3 34/40] KVM: arm64: gic-v5: Handle userspace accesses
 to IRS MMIO region
Thread-Index: AQHdCwYZP4fAqu49C0S0RRmoEb+l2A==
Date: Fri, 3 Jul 2026 16:07:51 +0000
Message-ID: <20260703154811.3355680-35-sascha.bischoff@arm.com>
References: <20260703154811.3355680-1-sascha.bischoff@arm.com>
In-Reply-To: <20260703154811.3355680-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU2PR08MB7310:EE_|AM0PR08MB5459:EE_|DB1PEPF00050A00:EE_|PA4PR08MB7457:EE_
X-MS-Office365-Filtering-Correlation-Id: 716ed718-4c8f-49a6-1aa9-08ded91d610d
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|3023799007|18002099003|22082099003|6133799003|56012099006|5023799004|11063799006|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 WEHXHBMmm6Q9SRJPJk03Wy/Sc/H5+eXqbfmCDLa80FkD3UEIupeNjP0qseXhr8HqTWDjCSvyendEUb+wVxUYuIMKL2esVZxOLFsOfEZ2eQX22dQ+JxA8wH3VUJZuvUbnvPl6QH5IoNmdCZCGZWHKBsOzuN5WUWI7WaGh5VkZJy+9YFPzZvvyUljxcnGuVizxDGnweokVQiwp/RwTW5vbUYdElnIuAoLJXkwmbn2MNQSJI5JbiSiJiD3B1fYT/gxxXwGk0EWhFLdz10VjqD/oH8LCtAlelkCaerRUgIeylv+EgRYJPPU5zTrsodScAKvs7Z39bGLTki0PJpEo3IqHm4DWmFehDPfX3ciAHMN6md5gf9H2o02MvU1CtGW9yMDos5i0i3ASy7ego0CTZb8rEMUL7c6ClHoErp+Az9Mv0yOfXOQO7Fuk/JjELdEoPJQ68A/TCZWiEH4oFehwwvMvx6cA9b1w7GvX4hTNV75AgK5VqlQmvHrL80v9SuvpmRht+Tb+XG7/Fhuc5erEN85j2GYAW1vIXDecfpbM3QnCkwDprIv5MzzVcsydr9Ij+C+VEhl2fA82YnB+A/CPYkuSij+nWlYZTTfL+n0GLdnWsy98xyWLvHoOSNgcjMowRlzZW6rzY3Zp/8JNDyILLzH6kUrMoWcTuj1jqOACc8fMKV7A5PevMRkzemlwgai82gU3IDvVuvQb2WMsg31gnXghfeKPx3Z9/2FuMgez+uWXJUE=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU2PR08MB7310.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(3023799007)(18002099003)(22082099003)(6133799003)(56012099006)(5023799004)(11063799006)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 Gsh8capeD5gxkhRE6zRKjQXQBmTgJ5PXqhg0za7RKphL5C+8RYZm78o0/SBsSHDpGaz+ok1Q+wPMEe2y1ef3uL8+/xOysp3A12ESNIiw75XwpOQDHHzXzIQG23E2L5g9g4Bz4IG6Wu6jaYU0TSCL03CqHYfciVOLoFx22G7DrwrqW03DUT9Xp8ch/z9lUHPp+8R7uSagnn94V8Yn7SiG9ID5s+JgsfhSvm/9RHG5wISRvuUwVz4k+PIpSHr/0qOS3Psa7wfO2x32ubKtjx0xygeoGasPk/ya6za/OvRjS0Rf9T7u7+JGSS1vu4Kp29mMSgRZ9VLOq0f7yxRJRgC0Ig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB5459
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF00050A00.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	b49bb4f2-58e9-4f75-54b7-08ded91d3bcd
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|35042699022|1800799024|82310400026|30052699003|14060799003|23010399003|376014|18002099003|22082099003|3023799007|11063799006|5023799004|56012099006|6133799003;
X-Microsoft-Antispam-Message-Info:
	BJe8n5DPtFY4F6i8fz4mjo7JztCpGszsFSrXGsu1yO6zx4eAWRd3ruI+PM5OQ8ZtvrhhrbRSMCD00DN/yul6Nf/Qkxux/PvaugL+UBLRwsxhwzDp5w6TmmMX8pwBD1IFNDrcN8JpgwDvSh6INlLs++Ud59dcD36jIDCaweAn4P1o59JuNL5CRcZZ/Qx3kFd71FNClc6fdgF0uziuME6F13qsjk7JDAEMkkSvRJxkvRIED7JQ4/8nDhxh7lP11mLz0EE6CmGPn8qLoRauL+TJVgOIvwKsru1jO/Q9+1Lk7Vfo/NGA0iXeXmdiGkag8zJSmzAjeuWIVcroaD08NNbrMjU4jSTzR1mp6ckaas/ZV7+EbI+o9vzGyZqL8beBH9cm1ua9erHmF6zIuXPYvoNNranQFO/mm118D2cWW0LUB36DQY5sETLgvvdPh//WxFCq6jCVNfZx4UwFWjMdQmbzaNRZO9NY9L1qkGLspRNTJlX7XQ6jTDziJR/LElGVCF6Bjh2zTA/lxJmhuLR7L6lZ2CCot9rhRF6Dyo6Dmivv70HZIf841nmiSWWUwaifyNi1XghLYUu7L0volIh3R3u7iZNX4CsdUU16l6iSBzD2+AeYEDk5liFizvWSQ50SCh5mcfxrbBBjfVzQU/SdKtVG/vm4KIrmSMG/L5EZTKZoZ7hLKZH4fEa+o6RkqVyBkQhL4BNS3Zzx2t2sGHM8HkCM7Q==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(35042699022)(1800799024)(82310400026)(30052699003)(14060799003)(23010399003)(376014)(18002099003)(22082099003)(3023799007)(11063799006)(5023799004)(56012099006)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	uz82cF3p607WBgGxVqfJAfdcQuq83xEG6MDbPM2acnufYQwVQ8LaaQmzc90Bk6KJcetNUen13r0/UKECR/bo5LpFzywXUFwaaGGjLTc97WeEtuxlKRPdVfNS8FCD+VH9DjZ2XOjNt3z3MMiANx7Lo23RQfqz3yjiWnkrmf9ZctwA+ttetTWFSqYrfTa7CnGsKiGgMS/EJKoK2zjv9F/lQmkBf+veMsSoWOnZBztvDYvUDFfiQVIhUDTBvXYvmTs6XX8vmgO2zKhIOs/c8uiufgpVIsr8K7fKBdJDzmMOFGxjtb1u4a7dwc0c6l+8gLWKlYM4VSrxG4fZp4fEPx+M1O+xsLr8hBqZYXVrYHfptMC2nq1W3CSH+Jt8vs7qCD1eOxValGfpWJkf7YCGJ2DDJBDfuz8a/xXBJaNYgvk4D/wnLGvaDWmtF0AO3iDcFf+b
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2026 16:08:53.7629
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 716ed718-4c8f-49a6-1aa9-08ded91d610d
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF00050A00.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR08MB7457

As part of saving and restoring state of a GICv5-based system,
userspace is required to save/restore the IRS MMIO registers. These
include important information such as guest IST configuration, and in
general KVM needs to present consistent state to the guest.

Provide accessors to read and write the IRS MMIO state. This is
modelled on what is already done for the GICv3 ITS as the idea is
broadly the same.

Where possible, the existing access mechanisms are used, but for some
registers the access is handled a bit differently as they have wider
effects. For example, some writes need to be sanitised to make sure
that the hardware is capable (IST capabilities presented to the guest,
for example). Similar things apply to the SPI config where we block
userspace from setting anything that doesn't match what has been set
already.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/include/uapi/asm/kvm.h       |   1 +
 arch/arm64/kvm/vgic/vgic-irs-v5.c       | 428 ++++++++++++++++++++----
 arch/arm64/kvm/vgic/vgic-kvm-device.c   |  55 ++-
 arch/arm64/kvm/vgic/vgic.h              |   4 +
 tools/arch/arm64/include/uapi/asm/kvm.h |   1 +
 5 files changed, 406 insertions(+), 83 deletions(-)

diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/as=
m/kvm.h
index d1b2ca317f586..710a0d267347d 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -422,6 +422,7 @@ enum {
 #define KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO  7
 #define KVM_DEV_ARM_VGIC_GRP_ITS_REGS 8
 #define KVM_DEV_ARM_VGIC_GRP_MAINT_IRQ  9
+#define KVM_DEV_ARM_VGIC_GRP_IRS_REGS	10
 #define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT	10
 #define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_MASK \
 			(0x3fffffULL << KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT)
diff --git a/arch/arm64/kvm/vgic/vgic-irs-v5.c b/arch/arm64/kvm/vgic/vgic-i=
rs-v5.c
index 96bf02170caa7..1d63cfe704fda 100644
--- a/arch/arm64/kvm/vgic/vgic-irs-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-irs-v5.c
@@ -392,12 +392,61 @@ static unsigned long vgic_v5_mmio_read_irs_ist(struct=
 kvm_vcpu *vcpu,
 	return value;
 }
=20
+static void vgic_v5_update_irs_ist_baser(struct vgic_v5_irs *irs,
+					 unsigned long val)
+{
+	irs->ist_baser.valid =3D !!(val & GICV5_IRS_IST_BASER_VALID);
+	irs->ist_baser.addr =3D FIELD_GET(GICV5_IRS_IST_BASER_ADDR_MASK, val)
+		<< GICV5_IRS_IST_BASER_ADDR_SHIFT;
+}
+
+static int vgic_v5_write_irs_ist_baser(struct kvm_vcpu *vcpu, unsigned lon=
g val)
+{
+	struct vgic_v5_irs *irs =3D vgic_v5_get_irs(vcpu);
+	enum gicv5_vcpu_cmd cmd =3D LPI_VIST_MAKE_INVALID;
+	bool valid =3D !!(val & GICV5_IRS_IST_BASER_VALID);
+	int rc;
+
+	/* Valid -> Invalid */
+	if (irs->ist_baser.valid && !valid) {
+		/* Make the LPI IST invalid and then ... */
+		rc =3D irq_set_vcpu_affinity(vgic_v5_vpe_db(vcpu), &cmd);
+		if (rc)
+			return rc;
+
+		/*
+		 * ... free the host IST if we successfully marked the
+		 * IST as invalid. Frankly, if we failed to make the
+		 * guest's IST as invalid, we're cooked because it means
+		 * that the IRS may still be using the memory that we
+		 * want to free. Hence, we leave it allocated and skip
+		 * the clearing of valid bit in the baser.
+		 */
+		rc =3D vgic_v5_lpi_ist_free(vcpu->kvm);
+		if (rc)
+			return rc;
+	} else if (!irs->ist_baser.valid && valid) { /* Invalid -> Valid */
+		if (!vgic_v5_ist_cfgr_valid(irs)) {
+			kvm_err("Guest programmed invalid IRS_IST_CFGR\n");
+			return -EINVAL;
+		}
+
+		rc =3D vgic_v5_lpi_ist_alloc(vcpu->kvm, irs->ist_cfgr.lpi_id_bits);
+		if (rc)
+			return rc;
+	}
+
+	/* Now that we've handled the edges, update the valid bit and addr */
+	vgic_v5_update_irs_ist_baser(irs, val);
+
+	return 0;
+}
+
 static void vgic_v5_mmio_write_irs_ist(struct kvm_vcpu *vcpu, gpa_t addr,
 				       unsigned int len, unsigned long val)
 {
 	struct vgic_v5_irs *irs =3D vgic_v5_get_irs(vcpu);
 	const size_t offset =3D addr & (SZ_64K - 1);
-	enum gicv5_vcpu_cmd cmd =3D LPI_VIST_MAKE_INVALID;
=20
 	switch (offset) {
 	case GICV5_IRS_IST_CFGR:
@@ -407,84 +456,214 @@ static void vgic_v5_mmio_write_irs_ist(struct kvm_vc=
pu *vcpu, gpa_t addr,
 		irs->ist_cfgr.structure =3D !!(val & GICV5_IRS_IST_CFGR_STRUCTURE);
 		return;
 	case GICV5_IRS_IST_BASER: {
-		bool valid =3D !!(val & GICV5_IRS_IST_BASER_VALID);
-
 		guard(mutex)(&vcpu->kvm->arch.config_lock);
+		vgic_v5_write_irs_ist_baser(vcpu, val);
+		return;
+	}
+	default:
+		return;
+	}
+}
=20
-		/* Valid -> Invalid */
-		if (irs->ist_baser.valid && !valid) {
-			/* Make the LPI IST invalid and then ... */
-			if (irq_set_vcpu_affinity(vgic_v5_vpe_db(vcpu), &cmd))
-				break;
+static unsigned long vgic_v5_mmio_uaccess_read_irs_status(struct kvm_vcpu =
*vcpu,
+							  gpa_t addr,
+							  unsigned int len)
+{
+	const size_t offset =3D addr & (SZ_64K - 1);
=20
-			/*
-			 * ... free the host IST if we successfully marked the
-			 * IST as invalid. Frankly, if we failed to make the
-			 * guest's IST as invalid, we're cooked because it means
-			 * that the IRS may still be using the memory that we
-			 * want to free. Hence, we leave it allocated and skip
-			 * the clearing of valid bit in the baser.
-			 */
-			if (vgic_v5_lpi_ist_free(vcpu->kvm))
-				break;
-		} else if (!irs->ist_baser.valid && valid) { /* Invalid -> Valid */
-			if (!vgic_v5_ist_cfgr_valid(irs)) {
-				kvm_err("Guest programmed invalid IRS_IST_CFGR\n");
-				break;
-			}
-
-			if (vgic_v5_lpi_ist_alloc(vcpu->kvm, irs->ist_cfgr.lpi_id_bits))
-				break;
-		}
+	switch (offset) {
+	case GICV5_IRS_SYNC_STATUSR:
+		return GICV5_IRS_SYNC_STATUSR_IDLE;
+	case GICV5_IRS_SPI_STATUSR:
+		return GICV5_IRS_SPI_STATUSR_IDLE;
+	case GICV5_IRS_PE_STATUSR:
+		return GICV5_IRS_PE_STATUSR_IDLE;
+	case GICV5_IRS_IST_STATUSR:
+		return GICV5_IRS_IST_STATUSR_IDLE;
+	default:
+		return 0;
+	}
+}
=20
-		/* Now that we've handled the edges, update the valid bit and addr */
-		irs->ist_baser.valid =3D !!(val & GICV5_IRS_IST_BASER_VALID);
-		irs->ist_baser.addr =3D FIELD_GET(GICV5_IRS_IST_BASER_ADDR_MASK, val)
-			<< GICV5_IRS_IST_BASER_ADDR_SHIFT;
+static int vgic_v5_mmio_uaccess_write_irs(struct kvm_vcpu *vcpu, gpa_t add=
r,
+					  unsigned int len, unsigned long val)
+{
+	struct vgic_dist *vgic =3D &vcpu->kvm->arch.vgic;
+	struct vgic_v5_irs *irs_data =3D vgic->vgic_v5_irs_data;
+	size_t offset =3D addr & (SZ_64K - 1);
=20
-		return;
+	/*
+	 * The following registers are ONLY settable via uaccesses. The guest
+	 * cannot write them!
+	 */
+
+	switch (offset) {
+	case GICV5_IRS_IDR0:
+		if (FIELD_GET(GICV5_IRS_IDR0_INT_DOM, val) !=3D
+		    GICV5_IRS_IDR0_INT_DOM_NON_SECURE)
+			return -EINVAL;
+
+		if ((val & GICV5_IRS_IDR0_VIRT) ||
+		    (val & GICV5_IRS_IDR0_ONE_N) ||
+		    (val & GICV5_IRS_IDR0_VIRT_ONE_N) ||
+		    (val & GICV5_IRS_IDR0_SETLPI) ||
+		    (val & GICV5_IRS_IDR0_MEC) ||
+		    (val & GICV5_IRS_IDR0_MPAM) ||
+		    (val & GICV5_IRS_IDR0_SWE))
+			return -EINVAL;
+
+		irs_data->idr0.domain =3D FIELD_GET(GICV5_IRS_IDR0_INT_DOM, val);
+		irs_data->idr0.pa_range =3D FIELD_GET(GICV5_IRS_IDR0_PA_RANGE, val);
+		irs_data->idr0.virt =3D !!(val & GICV5_IRS_IDR0_VIRT);
+		irs_data->idr0.setlpi =3D !!(val & GICV5_IRS_IDR0_SETLPI);
+		irs_data->idr0.mec =3D !!(val & GICV5_IRS_IDR0_MEC);
+		irs_data->idr0.mpam =3D !!(val & GICV5_IRS_IDR0_MPAM);
+		irs_data->idr0.swe =3D !!(val & GICV5_IRS_IDR0_SWE);
+		irs_data->idr0.irs_id =3D FIELD_GET(GICV5_IRS_IDR0_IRSID, val);
+		break;
+	case GICV5_IRS_IDR1: {
+		unsigned int iaffid_bits, priority_bits;
+		u8 vpe_id_bits;
+
+		/* Ignore writes to PE_CNT as this is populated from num vcpus */
+		iaffid_bits =3D FIELD_GET(GICV5_IRS_IDR1_IAFFID_BITS, val);
+		priority_bits =3D FIELD_GET(GICV5_IRS_IDR1_PRIORITY_BITS, val);
+
+		/*
+		 * IAFFID_BITS is derived from the host IRS VPE ID capacity and
+		 * is encoded as N - 1.
+		 */
+		vpe_id_bits =3D fls(kvm_vgic_global_state.vgic_v5_irs_caps.max_vpes) - 1=
;
+		if (iaffid_bits !=3D vpe_id_bits - 1)
+			return -EINVAL;
+
+		if (priority_bits > gicv5_global_data.irs_pri_bits - 1)
+			return -EINVAL;
+
+		irs_data->idr1.priority_bits =3D priority_bits;
+		break;
 	}
+	case GICV5_IRS_IDR2:
+		/* We always support LPIs */
+		if (!(val & GICV5_IRS_IDR2_LPI))
+			return -EINVAL;
+
+		/* We only support LPIs with linear, non-metadata guest ISTs */
+		if (val & GICV5_IRS_IDR2_IST_LEVELS)
+			return -EINVAL;
+
+		if ((val & GICV5_IRS_IDR2_ISTMD) ||
+		    FIELD_GET(GICV5_IRS_IDR2_ISTMD_SZ, val))
+			return -EINVAL;
+
+		/* We can't present more bits than we have support for in HW */
+		if (FIELD_GET(GICV5_IRS_IDR2_ID_BITS, val) > irs_caps.ist_id_bits)
+			return -EINVAL;
+
+		/* Min LPI ID bits must be greater than or equal to the HW */
+		if (FIELD_GET(GICV5_IRS_IDR2_MIN_LPI_ID_BITS, val) <
+		    irs_caps.min_lpi_id_bits)
+			return -EINVAL;
+
+		if (FIELD_GET(GICV5_IRS_IDR2_MIN_LPI_ID_BITS, val) >
+		    FIELD_GET(GICV5_IRS_IDR2_ID_BITS, val))
+			return -EINVAL;
+
+		irs_data->idr2.istmd_sz =3D FIELD_GET(GICV5_IRS_IDR2_ISTMD_SZ, val);
+		irs_data->idr2.istmd =3D !!(val & GICV5_IRS_IDR2_ISTMD);
+		irs_data->idr2.ist_l2sz =3D FIELD_GET(GICV5_IRS_IDR2_IST_L2SZ, val);
+		irs_data->idr2.ist_levels =3D !!(val & GICV5_IRS_IDR2_IST_LEVELS);
+		irs_data->idr2.min_lpi_id_bits =3D FIELD_GET(GICV5_IRS_IDR2_MIN_LPI_ID_B=
ITS, val);
+		irs_data->idr2.id_bits =3D FIELD_GET(GICV5_IRS_IDR2_ID_BITS, val);
+		break;
+	case GICV5_IRS_IDR5:
+		if (FIELD_GET(GICV5_IRS_IDR5_SPI_RANGE, val) !=3D irs_data->idr5.spi_ran=
ge)
+			return -EINVAL;
+		break;
+	case GICV5_IRS_IDR6:
+		if (FIELD_GET(GICV5_IRS_IDR6_SPI_IRS_RANGE, val) !=3D irs_data->idr6.spi=
_irs_range)
+			return -EINVAL;
+		break;
+	case GICV5_IRS_IDR7:
+		if (FIELD_GET(GICV5_IRS_IDR7_SPI_BASE, val) !=3D irs_data->idr7.spi_base=
)
+			return -EINVAL;
+		break;
+	case GICV5_IRS_IST_BASER:
+		vgic_v5_update_irs_ist_baser(irs_data, val);
+		break;
+	case GICV5_IRS_CR0:
+		vgic->enabled =3D !!(val & GICV5_IRS_CR0_IRSEN);
+		break;
+	case GICV5_IRS_SPI_CFGR:
+		break;
+	case GICV5_IRS_IIDR:
+		fallthrough;
+	case GICV5_IRS_AIDR:
+		break;
 	default:
-		return;
+		return -EINVAL;
 	}
+
+	return 0;
 }
=20
 static const struct vgic_register_region vgic_v5_irs_registers[] =3D {
 	/*
 	 * This is the IRS_CONFIG_FRAME.
 	 */
-	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IDR0, vgic_v5_mmio_read_irs_misc,
-				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IDR1, vgic_v5_mmio_read_irs_misc,
-				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IDR2, vgic_v5_mmio_read_irs_misc,
-				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH_UACCESS(GICV5_IRS_IDR0, vgic_v5_mmio_read_irs_m=
isc,
+					  vgic_mmio_write_wi, NULL,
+					  vgic_v5_mmio_uaccess_write_irs, 4,
+					  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH_UACCESS(GICV5_IRS_IDR1, vgic_v5_mmio_read_irs_m=
isc,
+					  vgic_mmio_write_wi, NULL,
+					  vgic_v5_mmio_uaccess_write_irs, 4,
+					  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH_UACCESS(GICV5_IRS_IDR2, vgic_v5_mmio_read_irs_m=
isc,
+					  vgic_mmio_write_wi, NULL,
+					  vgic_v5_mmio_uaccess_write_irs, 4,
+					  VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IDR3, vgic_mmio_read_raz,
 				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IDR4, vgic_mmio_read_raz,
 				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IDR5, vgic_v5_mmio_read_irs_misc,
-				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IDR6, vgic_v5_mmio_read_irs_misc,
-				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IDR7, vgic_v5_mmio_read_irs_misc,
-				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IIDR, vgic_v5_mmio_read_irs_misc,
-				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_AIDR, vgic_v5_mmio_read_irs_misc,
-				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_CR0, vgic_v5_mmio_read_irs_misc,
-				  vgic_v5_mmio_write_irs_misc, 4,
-				  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH_UACCESS(GICV5_IRS_IDR5, vgic_v5_mmio_read_irs_m=
isc,
+					  vgic_mmio_write_wi, NULL,
+					  vgic_v5_mmio_uaccess_write_irs, 4,
+					  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH_UACCESS(GICV5_IRS_IDR6, vgic_v5_mmio_read_irs_m=
isc,
+					  vgic_mmio_write_wi, NULL,
+					  vgic_v5_mmio_uaccess_write_irs, 4,
+					  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH_UACCESS(GICV5_IRS_IDR7, vgic_v5_mmio_read_irs_m=
isc,
+					  vgic_mmio_write_wi, NULL,
+					  vgic_v5_mmio_uaccess_write_irs, 4,
+					  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH_UACCESS(GICV5_IRS_IIDR, vgic_v5_mmio_read_irs_m=
isc,
+					  vgic_mmio_write_wi, NULL,
+					  vgic_v5_mmio_uaccess_write_irs, 4,
+					  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH_UACCESS(GICV5_IRS_AIDR, vgic_v5_mmio_read_irs_m=
isc,
+					  vgic_mmio_write_wi, NULL,
+					  vgic_v5_mmio_uaccess_write_irs, 4,
+					  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH_UACCESS(GICV5_IRS_CR0,
+					  vgic_v5_mmio_read_irs_misc,
+					  vgic_v5_mmio_write_irs_misc, NULL,
+					  vgic_v5_mmio_uaccess_write_irs, 4,
+					  VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_CR1, vgic_v5_mmio_read_irs_misc,
 				  vgic_v5_mmio_write_irs_misc, 4,
 				  VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_SYNCR, vgic_mmio_read_raz,
 				  vgic_mmio_write_wi, 4,
 				  VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_SYNC_STATUSR,
-				  vgic_v5_mmio_read_irs_misc,
-				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH_UACCESS(GICV5_IRS_SYNC_STATUSR,
+					  vgic_v5_mmio_read_irs_misc,
+					  vgic_mmio_write_wi,
+					  vgic_v5_mmio_uaccess_read_irs_status,
+					  vgic_mmio_uaccess_write_wi, 4,
+					  VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_SPI_VMR, vgic_mmio_read_raz,
 				  vgic_mmio_write_wi, 8,
 				  VGIC_ACCESS_64bit),
@@ -492,35 +671,48 @@ static const struct vgic_register_region vgic_v5_irs_=
registers[] =3D {
 				  vgic_v5_mmio_write_irs_spi, 4,
 				  VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_SPI_DOMAINR, vgic_v5_mmio_read_irs_sp=
i,
-				  vgic_v5_mmio_write_irs_spi, 4,
-				  VGIC_ACCESS_32bit),
+				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_SPI_RESAMPLER, vgic_mmio_read_raz,
 				  vgic_mmio_write_wi, 4,
 				  VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_SPI_CFGR, vgic_v5_mmio_read_irs_spi,
-				  vgic_v5_mmio_write_irs_spi, 4,
-				  VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_SPI_STATUSR,
-				  vgic_v5_mmio_read_irs_spi, vgic_mmio_write_wi,
-				  4, VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_PE_SELR, vgic_v5_mmio_read_irs_misc,
+	REGISTER_DESC_WITH_LENGTH_UACCESS(GICV5_IRS_SPI_CFGR,
+					  vgic_v5_mmio_read_irs_spi,
+					  vgic_v5_mmio_write_irs_spi, NULL,
+					  vgic_v5_mmio_uaccess_write_irs, 4,
+					  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH_UACCESS(GICV5_IRS_SPI_STATUSR,
+					  vgic_v5_mmio_read_irs_spi,
+					  vgic_mmio_write_wi,
+					  vgic_v5_mmio_uaccess_read_irs_status,
+					  vgic_mmio_uaccess_write_wi, 4,
+					  VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_PE_SELR,
+				  vgic_v5_mmio_read_irs_misc,
 				  vgic_v5_mmio_write_irs_misc, 4,
 				  VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_PE_STATUSR,
-				  vgic_v5_mmio_read_irs_misc,
-				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH_UACCESS(GICV5_IRS_PE_STATUSR,
+					  vgic_v5_mmio_read_irs_misc,
+					  vgic_mmio_write_wi,
+					  vgic_v5_mmio_uaccess_read_irs_status,
+					  vgic_mmio_uaccess_write_wi, 4,
+					  VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_PE_CR0, vgic_v5_mmio_read_irs_misc,
 				  vgic_v5_mmio_write_irs_misc, 4,
 				  VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IST_BASER, vgic_v5_mmio_read_irs_ist,
-				  vgic_v5_mmio_write_irs_ist, 8,
-				  VGIC_ACCESS_64bit),
+	REGISTER_DESC_WITH_LENGTH_UACCESS(GICV5_IRS_IST_BASER,
+					  vgic_v5_mmio_read_irs_ist,
+					  vgic_v5_mmio_write_irs_ist, NULL,
+					  vgic_v5_mmio_uaccess_write_irs, 8,
+					  VGIC_ACCESS_64bit),
 	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IST_CFGR, vgic_v5_mmio_read_irs_ist,
 				  vgic_v5_mmio_write_irs_ist, 4,
 				  VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IST_STATUSR,
-				  vgic_v5_mmio_read_irs_ist, vgic_mmio_write_wi,
-				  4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH_UACCESS(GICV5_IRS_IST_STATUSR,
+					  vgic_v5_mmio_read_irs_ist,
+					  vgic_mmio_write_wi,
+					  vgic_v5_mmio_uaccess_read_irs_status,
+					  vgic_mmio_uaccess_write_wi, 4,
+					  VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_MAP_L2_ISTR, vgic_mmio_read_raz,
 				  vgic_mmio_write_wi, 4, VGIC_ACCESS_32bit),
=20
@@ -756,3 +948,93 @@ int kvm_vgic_v5_irs_init(struct kvm *kvm, unsigned int=
 nr_spis)
=20
 	return 0;
 }
+
+int vgic_v5_has_attr_regs(struct kvm_device *dev, struct kvm_device_attr *=
attr)
+{
+	const struct vgic_register_region *region;
+	struct vgic_reg_attr reg_attr;
+	struct kvm_vcpu *vcpu;
+	gpa_t addr, offset;
+	int ret, align;
+
+	ret =3D vgic_v5_parse_attr(dev, attr, &reg_attr);
+	if (ret)
+		return ret;
+
+	vcpu =3D reg_attr.vcpu;
+	addr =3D reg_attr.addr;
+
+	if (attr->group =3D=3D KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS)
+		return vgic_v5_has_cpu_sysregs_attr(vcpu, attr);
+
+	offset =3D attr->attr;
+
+	if (IS_VGIC_ADDR_UNDEF(dev->kvm->arch.vgic.vgic_v5_irs_data->vgic_v5_irs_=
base))
+		return -ENXIO;
+
+	region =3D vgic_find_mmio_region(vgic_v5_irs_registers,
+				       ARRAY_SIZE(vgic_v5_irs_registers),
+				       offset);
+	if (!region)
+		return -ENXIO;
+
+	align =3D region->access_flags & VGIC_ACCESS_64bit ? 0x7 : 0x3;
+	if (offset & align)
+		return -EINVAL;
+
+	return 0;
+}
+
+/*
+ * Access the IRS MMIO Regs. Relevant locks have been taken by the calling=
 code.
+ */
+int vgic_v5_irs_attr_regs_access(struct kvm_device *dev,
+				 struct kvm_device_attr *attr,
+				 u64 *reg, bool is_write)
+{
+	const struct vgic_register_region *region;
+	gpa_t addr, offset;
+	unsigned int len;
+	int align, ret =3D 0;
+
+	offset =3D attr->attr;
+
+	if (IS_VGIC_ADDR_UNDEF(dev->kvm->arch.vgic.vgic_v5_irs_data->vgic_v5_irs_=
base))
+		return -ENXIO;
+
+	region =3D vgic_find_mmio_region(vgic_v5_irs_registers,
+				       ARRAY_SIZE(vgic_v5_irs_registers),
+				       offset);
+	if (!region)
+		return -ENXIO;
+
+	/*
+	 * Although the spec supports upper/lower 32-bit accesses to
+	 * 64-bit IRS registers, the userspace ABI requires 64-bit
+	 * accesses to all 64-bit wide registers. We therefore only
+	 * support 32-bit accesses to 32-bit-wide registers.
+	 */
+	align =3D region->access_flags & VGIC_ACCESS_64bit ? 0x7 : 0x3;
+	len =3D region->access_flags & VGIC_ACCESS_64bit ? 8 : 4;
+
+	if (offset & align)
+		return -EINVAL;
+
+	addr =3D dev->kvm->arch.vgic.vgic_v5_irs_data->vgic_v5_irs_base + offset;
+
+	if (is_write) {
+		if (region->uaccess_write)
+			ret =3D region->uaccess_write(kvm_get_vcpu(dev->kvm, 0),
+						    addr, len, *reg);
+		else
+			region->write(kvm_get_vcpu(dev->kvm, 0), addr, len, *reg);
+	} else {
+		if (region->uaccess_read)
+			*reg =3D region->uaccess_read(kvm_get_vcpu(dev->kvm, 0),
+						    addr, len);
+		else
+			*reg =3D region->read(kvm_get_vcpu(dev->kvm, 0), addr, len);
+	}
+
+	return ret;
+}
diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vg=
ic-kvm-device.c
index 075e4c1326754..cab3d6db070ac 100644
--- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
+++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
@@ -786,6 +786,9 @@ int vgic_v5_parse_attr(struct kvm_device *dev, struct k=
vm_device_attr *attr,
 		mpidr_reg =3D VGIC_TO_MPIDR(vgic_mpidr);
 		reg_attr->vcpu =3D kvm_mpidr_to_vcpu(dev->kvm, mpidr_reg);
 		break;
+	case KVM_DEV_ARM_VGIC_GRP_IRS_REGS:
+		reg_attr->vcpu =3D kvm_get_vcpu(dev->kvm, 0);
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -818,8 +821,11 @@ static int vgic_v5_attr_regs_access(struct kvm_device =
*dev,
 				    struct kvm_device_attr *attr,
 				    bool is_write)
 {
+	u64 __user *uaddr =3D (u64 __user *)(unsigned long)attr->addr;
 	struct vgic_reg_attr reg_attr;
 	struct kvm_vcpu *vcpu;
+	bool uaccess;
+	u64 val;
 	int ret;
=20
 	ret =3D vgic_v5_parse_attr(dev, attr, &reg_attr);
@@ -828,6 +834,22 @@ static int vgic_v5_attr_regs_access(struct kvm_device =
*dev,
=20
 	vcpu =3D reg_attr.vcpu;
=20
+	switch (attr->group) {
+	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
+		/* Sysregs uaccess is performed by the sysreg handling code */
+		uaccess =3D false;
+		break;
+	case KVM_DEV_ARM_VGIC_GRP_IRS_REGS:
+		fallthrough;
+	default:
+		uaccess =3D true;
+	}
+
+	if (uaccess && is_write) {
+		if (get_user(val, uaddr))
+			return -EFAULT;
+	}
+
 	mutex_lock(&dev->kvm->lock);
=20
 	if (kvm_trylock_all_vcpus(dev->kvm)) {
@@ -846,6 +868,18 @@ static int vgic_v5_attr_regs_access(struct kvm_device =
*dev,
 	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
 		ret =3D vgic_v5_cpu_sysregs_uaccess(vcpu, attr, is_write);
 		break;
+	case KVM_DEV_ARM_VGIC_GRP_IRS_REGS:
+		/*
+		 * The IRS registers are a mixture of 32-bit and 64-bit
+		 * registers. Internally, we always perform the correctly sized
+		 * access, but the UAPI is defined in such a way that we are
+		 * always provided a __u64 by userspace. When userspace writes,
+		 * the upper 32-bits are ignored for 32-bit accesses, and on a
+		 * read any 32-bit accesses are written back to user memory
+		 * using the full 64-bits.
+		 */
+		ret =3D vgic_v5_irs_attr_regs_access(dev, attr, &val, is_write);
+		break;
 	default:
 		ret =3D -EINVAL;
 		break;
@@ -856,6 +890,9 @@ static int vgic_v5_attr_regs_access(struct kvm_device *=
dev,
 	kvm_unlock_all_vcpus(dev->kvm);
 	mutex_unlock(&dev->kvm->lock);
=20
+	if (!ret && uaccess && !is_write)
+		ret =3D put_user(val, uaddr);
+
 	return ret;
 }
=20
@@ -865,6 +902,8 @@ static int vgic_v5_set_attr(struct kvm_device *dev,
 	switch (attr->group) {
 	case KVM_DEV_ARM_VGIC_GRP_ADDR:
 		break;
+	case KVM_DEV_ARM_VGIC_GRP_IRS_REGS:
+		fallthrough;
 	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
 		return vgic_v5_attr_regs_access(dev, attr, true);
 	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
@@ -891,6 +930,8 @@ static int vgic_v5_get_attr(struct kvm_device *dev,
 	switch (attr->group) {
 	case KVM_DEV_ARM_VGIC_GRP_ADDR:
 		break;
+	case KVM_DEV_ARM_VGIC_GRP_IRS_REGS:
+		fallthrough;
 	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
 		return vgic_v5_attr_regs_access(dev, attr, false);
 	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
@@ -922,16 +963,10 @@ static int vgic_v5_has_attr(struct kvm_device *dev,
 			return 0;
 		}
 		return -ENXIO;
-	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS: {
-		struct vgic_reg_attr reg_attr;
-		int ret;
-
-		ret =3D vgic_v5_parse_attr(dev, attr, &reg_attr);
-		if (ret)
-			return ret;
-
-		return vgic_v5_has_cpu_sysregs_attr(reg_attr.vcpu, attr);
-	}
+	case KVM_DEV_ARM_VGIC_GRP_IRS_REGS:
+		fallthrough;
+	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
+		return vgic_v5_has_attr_regs(dev, attr);
 	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
 		return 0;
 	case KVM_DEV_ARM_VGIC_GRP_CTRL:
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index bcdac044a23f4..e05b4a5c2e49b 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -389,6 +389,10 @@ int vgic_v5_cpu_sysregs_uaccess(struct kvm_vcpu *vcpu,
 				struct kvm_device_attr *attr, bool is_write);
 int vgic_v5_has_cpu_sysregs_attr(struct kvm_vcpu *vcpu, struct kvm_device_=
attr *attr);
 const struct sys_reg_desc *vgic_v5_get_sysreg_table(unsigned int *sz);
+int vgic_v5_irs_attr_regs_access(struct kvm_device *dev,
+				 struct kvm_device_attr *attr,
+				 u64 *reg, bool is_write);
+int vgic_v5_has_attr_regs(struct kvm_device *dev, struct kvm_device_attr *=
attr);
=20
 #define for_each_visible_v5_ppi(__i, __k)		\
 	for_each_set_bit(__i, (__k)->arch.vgic.gicv5_vm.vgic_ppi_mask, VGIC_V5_NR=
_PRIVATE_IRQS)
diff --git a/tools/arch/arm64/include/uapi/asm/kvm.h b/tools/arch/arm64/inc=
lude/uapi/asm/kvm.h
index d1b2ca317f586..710a0d267347d 100644
--- a/tools/arch/arm64/include/uapi/asm/kvm.h
+++ b/tools/arch/arm64/include/uapi/asm/kvm.h
@@ -422,6 +422,7 @@ enum {
 #define KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO  7
 #define KVM_DEV_ARM_VGIC_GRP_ITS_REGS 8
 #define KVM_DEV_ARM_VGIC_GRP_MAINT_IRQ  9
+#define KVM_DEV_ARM_VGIC_GRP_IRS_REGS	10
 #define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT	10
 #define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_MASK \
 			(0x3fffffULL << KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT)
--=20
2.34.1
