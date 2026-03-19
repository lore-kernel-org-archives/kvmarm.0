Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011062.outbound.protection.outlook.com [52.101.70.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A83933E8C6F
	for <kvmarm@lists.linux.dev>; Thu, 19 Mar 2026 15:52:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.62
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773935536; cv=fail; b=pWlhpVsqP37f/BOfH7ueLbPHnftrVvEc/VGGS5RknoksjYQFAd0Sr+O0YkPpcmWfkyk2bJ2ySqPTLD1YjwCMxEvqhdVke8oSsneOIb2PDW4Wm9Yxo0AS8A4FtFdomenCBTdEoTTUWrPGuEqAhHoHBxnQUiaooA5MbsLHYOKGkPU=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773935536; c=relaxed/simple;
	bh=G/GDlvFZ49n8Jjz9TWrlhwBmOdwanl4kRWJKyTT+A5c=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=NGDK3eERx9vvT7OSKsvziUtV00V39xqIOWtOtqzvkjDYrtGsVArnlZhVU/IEPjM3lIrokNJyLscEFBcvUQqfP2Kf0S42YxVsYYt/h0PDRpbKcP39NE24hNzvUyD32neTx5YROE4gd5eowgDTR1SLCycT/Am7ZawMSIk5vmg1uBc=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=DqQrcQst; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=DqQrcQst; arc=fail smtp.client-ip=52.101.70.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="DqQrcQst";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="DqQrcQst"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=wfCaXU2TkselasqpWENz3l/dvsTeKyit0R35IN89gnimhJNHyStFUjQyq651H6YVc+dEW2qiSaQ9J5YXtvC/oIiGVWeCe1k5hqji8hp+H1DGlUk88g509GAfDkkZx1ycY0V2Xgc91ylk9qQ3xkGlYx4YbVcFQo/SYF1wBQ4x3PFKAkcV352cR4FsYqW3Yes1Ms8VT3zT+nowB+hpvuEhh7PdFiYtZ3rMNhcpfqi35Xi4cl3cCyiyMzdsnq8p4OiWKm6bir/NrTo5cJHZArK6bVopxD9KByZoqENdSZxly/BQUbrfq4Da7/swONoDtIUBorqzyWzjR4XtUuvkEKViGQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3GXnA6K30oH+MXye96k8+skM28W7AfDwi3QaUy0HncE=;
 b=I1onNK1N7RiRglwtdPb4jvoE06Pa/EtVlwvKSWM2MzHAnQeIjjMf2zxmTiMtjlVS7XAaL422egPccSFh4MOf9HCc/fIkfmsgV9olY5uFKoO3dGRrqVas8E1nrT4/EjUcDfcIOEuduFZisiNiGDRbNfF8kvL+M4oYsd4eA+8Zx1rd3ovqvJmquLadpIhh91QYnGn7UX4nf1AERAhfwRMltfmfQapZa8WJcdNrZGHkJGWMZ8oMwZN/9OxWVHGw8P4ZdxX1kzvd8DGnIHS7WYpJucj4HtLxp0FfUkFWnciO7VHeMpv12WI3QKpWm7y7HE50BEkhu8xRJ8tW++2hL++w9Q==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3GXnA6K30oH+MXye96k8+skM28W7AfDwi3QaUy0HncE=;
 b=DqQrcQstDVmzEiLkaQXEhlZj2KjWTanVV+ZhTk9vmCiMlaq9LTrooIBFDFPuMZohCblzFqhQrJR3dNIRJixulhyBxqO5zRWVMcOXAHlI12zyyFvrwHWRn5blMiM9cpaH4RX/XxaDvDrNv9uZuSL/r1TVM6bsJloH5xE8RQDlui0=
Received: from AM0PR02CA0139.eurprd02.prod.outlook.com (2603:10a6:20b:28d::6)
 by DU4PR08MB10957.eurprd08.prod.outlook.com (2603:10a6:10:56e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Thu, 19 Mar
 2026 15:52:04 +0000
Received: from AMS0EPF00000193.eurprd05.prod.outlook.com
 (2603:10a6:20b:28d:cafe::f9) by AM0PR02CA0139.outlook.office365.com
 (2603:10a6:20b:28d::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.27 via Frontend Transport; Thu,
 19 Mar 2026 15:52:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF00000193.mail.protection.outlook.com (10.167.16.212) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.19
 via Frontend Transport; Thu, 19 Mar 2026 15:52:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IdAimULJlv8Zkl0CdvrC/06su1YELNM9DxfO9hBl7R7pf4yESRt0h0ACsrFb0Tr20k6B0otWU42gspnVV/j8h25qIG0gl1+ut4sN9iw4gdvOwbifXwmBmnaIvTSxDQe/rfIPGkTzQasFQlVVD94W4enBFcYuB509LlY4HYHZIdIz0eNoMK2li4AGMmGZWhh3hfzLc4mcpWmgnrMZoeUhARQupgH5BnLMktm8ekIAc9bQpBIsht/fVVpvvNWj+18pO5ynYRLxaavkpoJhp9jYVw86EDtZxLdz3zEA03all7xVhB9Iz4Gs//QuNK4Ii2vE6ogC2YCL/oK9YX5u0TfLPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3GXnA6K30oH+MXye96k8+skM28W7AfDwi3QaUy0HncE=;
 b=JVGIPjx9IOTrlOIXTJTuEOsC0Odl5U9cdgZRgCrnmv427uKa4R5K7obXM/8pfi8IXvpYAONDM2SlHE5JYCTjvKLEVh9hRMGI1EGHp83rEYZnPZb0PB4wtJyclk9vcFiSQVFlxVfxcls4aeJsxtgGEH0XY7QnjUym8t79RKURhpMqWGt1RNUVTTPI08bETgg6HUHbikFpBpwc0SeVy5NpmjtOJ91qkZ0+/9UNiOB43SwYcYwZOFWIcumVoGWlbIzFSA2L7SXjl+ohj/1DCDBGV/2d6b8cyVjAGJJF/xzEi5od5Val8D9fzsCVZLf/NUFIzbRqf7uKUp0P4O9GXGNeQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3GXnA6K30oH+MXye96k8+skM28W7AfDwi3QaUy0HncE=;
 b=DqQrcQstDVmzEiLkaQXEhlZj2KjWTanVV+ZhTk9vmCiMlaq9LTrooIBFDFPuMZohCblzFqhQrJR3dNIRJixulhyBxqO5zRWVMcOXAHlI12zyyFvrwHWRn5blMiM9cpaH4RX/XxaDvDrNv9uZuSL/r1TVM6bsJloH5xE8RQDlui0=
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com (2603:10a6:20b:504::10)
 by AS2PR08MB10250.eurprd08.prod.outlook.com (2603:10a6:20b:641::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Thu, 19 Mar
 2026 15:51:01 +0000
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27]) by AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27%6]) with mapi id 15.20.9723.018; Thu, 19 Mar 2026
 15:51:01 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey Gouly
	<Joey.Gouly@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	Timothy Hayes <Timothy.Hayes@arm.com>, "jonathan.cameron@huawei.com"
	<jonathan.cameron@huawei.com>
Subject: [PATCH v7 05/41] KVM: arm64: vgic: Split out mapping IRQs and setting
 irq_ops
Thread-Topic: [PATCH v7 05/41] KVM: arm64: vgic: Split out mapping IRQs and
 setting irq_ops
Thread-Index: AQHct7gvZQ+XAbeHrkaLpJ7VG1566Q==
Date: Thu, 19 Mar 2026 15:51:01 +0000
Message-ID: <20260319154937.3619520-6-sascha.bischoff@arm.com>
References: <20260319154937.3619520-1-sascha.bischoff@arm.com>
In-Reply-To: <20260319154937.3619520-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS4PR08MB8241:EE_|AS2PR08MB10250:EE_|AMS0EPF00000193:EE_|DU4PR08MB10957:EE_
X-MS-Office365-Filtering-Correlation-Id: 82203d40-e0d2-41c9-3040-08de85cf7767
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|38070700021|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 p+nML3Fzxb5G9f1kqmwnZW/xqJxPuLQweyY2zMR+eb+5PIiiK4J7ehnJIUSClH1BD9WSZavqHjkltE4Gg2nK8lFFqzFSaTvY4g3gyEUs70UWneMl4hxxzxc7dD9bp2R3Sb2HOye29SDcP3sy9LFx3zB4nnyEw06NX1oxW6iXke5jZMZCcA7W98qy6+G8OvGpq3LMpkp8+M8Elu/MsoaUwMRp9RxHqhZ0LoATUPQfdrhulsoHmAlWM9vfj3dVM6DiWmejRhVQX52FxPGIsYIXuYAv6GE7wIdtjAOmVoN3pyvwIH/FVQeZ/0CgSEG44hIaKFuJBGuG9rwwaqlHwhj8Y1+PyXNwDe+o+xKZVpZPQrMBAui1bC6Fkf8nWWFg27WYpkz+PUFFIBIJ+l3ddkKhOQd4zJ2RTryHlrlFTWdTTF+63kjqWJAzkxvT7Vb2xxd+fOOQ0v3cqe2XBTDzV9skRNtMsl/A/IONbRAhambHqf9Pz6KxkvodUI7r3Q3DvTKR4t/1fXb3TddNy/j7av2FnRdpnUo1tfjqK6t89t/v1RFmX5dDmQ2gzwMPeP3YFkvC6yCJ3++kRVxJ+dwZp49CpuU3LszbzsUUhOPcrLwEIAnpaVOQyi7KAftF9+jWN/e/KD4MSIV5Qho7+1wSGBKjuBa2oxgsEz26sxJR/iSRRCgcsJk3/SEZfF8mAS23p67dpsDRh3PnP0XzyOAn3nNmdc+RZdtm6GW+mC900cl0YkedaoLjfEl5+iwi47LWMM+QW+eDBLdmhO/Zpw1NAIjt65orJ/2zo4smnBeWvkxjNkI=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS4PR08MB8241.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 uxJgK+yrTUWLqz527zVk1sRw3+cXweOm1h9IxAOeVbaXUP40BttdM/OleBzDlh/lmF+/DGRtEmCxEnJpkKvZyQUlKvFV378h4eq5OUg2NVIVz0bVsOe7TyKXt5mOmPLlW1o5s/iKwQImGleP9iwEOuwrFIF+fsMHGJJSWGB6ExklJWZdOKQd4lvgVT+EKkGT9WXoq4GJ1RVMSu5Jxz+b5uZSza0ufRxlBwgMtVAV8kytz3sgTZ9G8jK2EJeKyP99dXGIl9AeJn6hIxoEEMKvDKOmCWsKoTiqH4K00Rd18geK1+mrKAD2/T8WtZ9ccH4o2MzMbHefuGJZRjyZy4dkMw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB10250
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF00000193.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	3bac9b49-ddbf-4ce3-159b-08de85cf51f4
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|14060799003|82310400026|36860700016|376014|1800799024|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	UJvOPZZO0Y7CHKY1t3/jn6zrBKA7ixWPV1B1qvCbhVJHOl1KBCNnLGxVtJz4dIFSa2RpPzCv6mvdF/EsMAmbPpJMmAeFLjJXhcLVWQfZiJLReyJ03/VGuhUhKqKr8r669q42nEdgAPuKQdumHl0ervH6n7k4Onn8GbTyjdAeEfceXd+7uz2osrgSWHA4tKa0QJ1t8GhWiOmSrtFa3YWiNjaQilkYYK+9ar7hlpO3jcA6TJ3UpFL3F6N8VoFoS0E89NtKcUYWTUTg7P0fISmcMc9BLi5fIzX4z2vVO9WCfE983LFI5AtbYifEr/kUE9aW8qkYzdwknSWLnPdKCMetdv3K/VZmCrFWwrL1JaoO8bLfNI/i60DD8A375VAQOro094Mu+pnv80+QRT8vhXV5rcrZa3FgHgbLxQ1PIeafQx6ggI8b/MtSaMjsHUPm4gWGUI6/YHOFf8LXnO5rF4AomUSgd4ifVUxFwWacIR46mpkc/zK+jzf0jJzZY2oj0GZdW/wYB89Wy0p4RmF1XZbkU4sQIsTuUQEbvl0oO18UfweO8wBuy0rmGfq8HdbSkCxPa0QjyYtqSBjNTPBljmK4BTtXWWROUFMkrbg/T3Tp2JWuIVvLV34aRGYV1VY5DTvq1zv4NK6EUPGBJwpkSG9z+NzihJZLd/fnlMBb/A8wQ9sEOB3z24/oI8h8Vsec5T/s/WrjPd36Za9BhrpsFYiyy/pY5ZTJ7wIO3+MfoAHaf/bIwXYBBK5fQ3TFiE/GNvU5IRlV0MLQiLz9SVch/YfRrw==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(14060799003)(82310400026)(36860700016)(376014)(1800799024)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	GCrEx4xG3omGLij1IcqEAZG1NQugTBDjj/6FJOZkTjKxp7Yk1AGUZI24f3h3XcW9EGYKY3Eb75giYHX5tlHnoe61gudRsUPv2aebikty4e0DfN2qkz60pCsX3vNUWuYLRYftzG45yzFWPc4QuAi4uoixwYDwkI+Fdb9kpxzMg7Q5Ex0hQJ+tlrhd3mj0HyBDsWvPGxwlGIm1D/K8XJl2fcuqxvbZmIwpJu8WlpPKfkr5B3Q6q/V9BKcHBSNhwD0oFKkkOEHASmpWT+qFIXVqKorQYFSd4IO5JO9Beeses/1cceI1mDs5X2daCkHUdQ2Zq57AIAqzi/AxIIgTzk/Qi5JmzZ4b0w+Ve6cuCtC58LuHiiBWdKGcQPyLTz+RmKxfbbhIfB6undE0zaoIPTrwuVm9/9Oindz0Y3tx/42W7CFTD1JpVgrtRlithSmacN+V
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2026 15:52:04.0065
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 82203d40-e0d2-41c9-3040-08de85cf7767
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF00000193.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU4PR08MB10957

Prior to this change, the act of mapping a virtual IRQ to a physical
one also set the irq_ops. Unmapping then reset the irq_ops to NULL. So
far, this has been fine and hasn't caused any major issues.

Now, however, as GICv5 support is being added to KVM, it has become
apparent that conflating mapping/unmapping IRQs and setting/clearing
irq_ops can cause issues. The reason is that the upcoming GICv5
support introduces a set of default irq_ops for PPIs, and removing
this when unmapping will cause things to break rather horribly.

Split out the mapping/unmapping of IRQs from the setting/clearing of
irq_ops. The arch timer code is updated to set the irq_ops following a
successful map. The irq_ops are intentionally not removed again on an
unmap as the only irq_op introduced by the arch timer only takes
effect if the hw bit in struct vgic_irq is set. Therefore, it is safe
to leave this in place, and it avoids additional complexity when GICv5
support is introduced.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/arch_timer.c | 24 +++++++++++++-----------
 arch/arm64/kvm/vgic/vgic.c  | 27 +++++++++++++++++++++------
 include/kvm/arm_vgic.h      |  5 ++++-
 3 files changed, 38 insertions(+), 18 deletions(-)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index 600f250753b45..dcdb1726e8358 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -740,13 +740,11 @@ static void kvm_timer_vcpu_load_nested_switch(struct =
kvm_vcpu *vcpu,
=20
 		ret =3D kvm_vgic_map_phys_irq(vcpu,
 					    map->direct_vtimer->host_timer_irq,
-					    timer_irq(map->direct_vtimer),
-					    &arch_timer_irq_ops);
+					    timer_irq(map->direct_vtimer));
 		WARN_ON_ONCE(ret);
 		ret =3D kvm_vgic_map_phys_irq(vcpu,
 					    map->direct_ptimer->host_timer_irq,
-					    timer_irq(map->direct_ptimer),
-					    &arch_timer_irq_ops);
+					    timer_irq(map->direct_ptimer));
 		WARN_ON_ONCE(ret);
 	}
 }
@@ -1082,6 +1080,7 @@ static void timer_context_init(struct kvm_vcpu *vcpu,=
 int timerid)
 void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu)
 {
 	struct arch_timer_cpu *timer =3D vcpu_timer(vcpu);
+	struct timer_map map;
=20
 	for (int i =3D 0; i < NR_KVM_TIMERS; i++)
 		timer_context_init(vcpu, i);
@@ -1095,6 +1094,13 @@ void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu)
=20
 	hrtimer_setup(&timer->bg_timer, kvm_bg_timer_expire, CLOCK_MONOTONIC,
 		      HRTIMER_MODE_ABS_HARD);
+
+	get_timer_map(vcpu, &map);
+	kvm_vgic_set_irq_ops(vcpu, timer_irq(map.direct_vtimer),
+			     &arch_timer_irq_ops);
+	if (map.direct_ptimer)
+		kvm_vgic_set_irq_ops(vcpu, timer_irq(map.direct_ptimer),
+				     &arch_timer_irq_ops);
 }
=20
 void kvm_timer_init_vm(struct kvm *kvm)
@@ -1565,18 +1571,14 @@ int kvm_timer_enable(struct kvm_vcpu *vcpu)
=20
 	ret =3D kvm_vgic_map_phys_irq(vcpu,
 				    map.direct_vtimer->host_timer_irq,
-				    timer_irq(map.direct_vtimer),
-				    &arch_timer_irq_ops);
+				    timer_irq(map.direct_vtimer));
 	if (ret)
 		return ret;
=20
-	if (map.direct_ptimer) {
+	if (map.direct_ptimer)
 		ret =3D kvm_vgic_map_phys_irq(vcpu,
 					    map.direct_ptimer->host_timer_irq,
-					    timer_irq(map.direct_ptimer),
-					    &arch_timer_irq_ops);
-	}
-
+					    timer_irq(map.direct_ptimer));
 	if (ret)
 		return ret;
=20
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index e22b79cfff965..9e0d26348a2a1 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -553,10 +553,27 @@ int kvm_vgic_inject_irq(struct kvm *kvm, struct kvm_v=
cpu *vcpu,
 	return 0;
 }
=20
+void kvm_vgic_set_irq_ops(struct kvm_vcpu *vcpu, u32 vintid,
+			  struct irq_ops *ops)
+{
+	struct vgic_irq *irq =3D vgic_get_vcpu_irq(vcpu, vintid);
+
+	BUG_ON(!irq);
+
+	scoped_guard(raw_spinlock_irqsave, &irq->irq_lock)
+		irq->ops =3D ops;
+
+	vgic_put_irq(vcpu->kvm, irq);
+}
+
+void kvm_vgic_clear_irq_ops(struct kvm_vcpu *vcpu, u32 vintid)
+{
+	kvm_vgic_set_irq_ops(vcpu, vintid, NULL);
+}
+
 /* @irq->irq_lock must be held */
 static int kvm_vgic_map_irq(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
-			    unsigned int host_irq,
-			    struct irq_ops *ops)
+			    unsigned int host_irq)
 {
 	struct irq_desc *desc;
 	struct irq_data *data;
@@ -576,7 +593,6 @@ static int kvm_vgic_map_irq(struct kvm_vcpu *vcpu, stru=
ct vgic_irq *irq,
 	irq->hw =3D true;
 	irq->host_irq =3D host_irq;
 	irq->hwintid =3D data->hwirq;
-	irq->ops =3D ops;
 	return 0;
 }
=20
@@ -585,11 +601,10 @@ static inline void kvm_vgic_unmap_irq(struct vgic_irq=
 *irq)
 {
 	irq->hw =3D false;
 	irq->hwintid =3D 0;
-	irq->ops =3D NULL;
 }
=20
 int kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu, unsigned int host_irq,
-			  u32 vintid, struct irq_ops *ops)
+			  u32 vintid)
 {
 	struct vgic_irq *irq =3D vgic_get_vcpu_irq(vcpu, vintid);
 	unsigned long flags;
@@ -598,7 +613,7 @@ int kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu, unsign=
ed int host_irq,
 	BUG_ON(!irq);
=20
 	raw_spin_lock_irqsave(&irq->irq_lock, flags);
-	ret =3D kvm_vgic_map_irq(vcpu, irq, host_irq, ops);
+	ret =3D kvm_vgic_map_irq(vcpu, irq, host_irq);
 	raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
 	vgic_put_irq(vcpu->kvm, irq);
=20
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index f2eafc65bbf4c..46262d1433bca 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -397,8 +397,11 @@ void kvm_vgic_init_cpu_hardware(void);
=20
 int kvm_vgic_inject_irq(struct kvm *kvm, struct kvm_vcpu *vcpu,
 			unsigned int intid, bool level, void *owner);
+void kvm_vgic_set_irq_ops(struct kvm_vcpu *vcpu, u32 vintid,
+			  struct irq_ops *ops);
+void kvm_vgic_clear_irq_ops(struct kvm_vcpu *vcpu, u32 vintid);
 int kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu, unsigned int host_irq,
-			  u32 vintid, struct irq_ops *ops);
+			  u32 vintid);
 int kvm_vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, unsigned int vintid);
 int kvm_vgic_get_map(struct kvm_vcpu *vcpu, unsigned int vintid);
 bool kvm_vgic_map_is_active(struct kvm_vcpu *vcpu, unsigned int vintid);
--=20
2.34.1
