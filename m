Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013028.outbound.protection.outlook.com [52.101.83.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16FC4483815;
	Fri,  4 Sep 2026 11:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.28
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788519911; cv=fail; b=XC/IwjD8hyoQXXMPdH+UlTiThg776iI7SkprV5karP83Nb/6QuCud0kj56rw0MYJ0whWXTZ/jxL/FUb2Nl1TnE/Om1n4tYTIWKvg9/W61a8MBfThMV0F2TcZv2zAw/Si9OBax/RVoWHc+r1BzJO7EP8b9D9u7IGu6KhDE96Q13g=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788519911; c=relaxed/simple;
	bh=COyMcdixz5+QT4K0cshfOgggorP538YMv8WGoFxIeI4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=dpKAXpHzbPW/MCOcnEAW6ysnOMmm7GIWDZD87wIlXlOMyKifBmEbTrn2RkpMq+PpRYELw2XvST6iZhbN5koW6PCCn5Hn97I5tIX31Sy1uNKhgO2vg5lrnao+VVbSO8upNvDGv8ZqFz9k3JuXEgiPs0tW3NEYzeQA7X+D2itzbXw=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=j/V+I0Gl; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=j/V+I0Gl; arc=fail smtp.client-ip=52.101.83.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="j/V+I0Gl";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="j/V+I0Gl"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=PWWO/j40yvUG1zHzQE6Lm14E8d1xok8+zy7AW2KHzz7XIbc5Mo2AEjXMJvI48dHdvxaYYi7R1vFW3phOv67c2I9Lt0czabJAgWrOAxczd07XmjNfcDPM+g8mpRUhCJ1/GeLzwF9vtj/pw7LHr4QqjzxEuhrkERyXFNS78zNp0bvQVuvqzn9ijKZzIeD8PXqx42FZBCzvQ3k1rw3O3G4oA6G6xxANNN0+X8M1feMEzCVn3kAPCLlOpMKUoH4JTv7LaHUE4KGIs1F2ah1QGhAPRVR4oGDPGXWfeNmT16OlMAuZp9HXoD+SKNNIUOkSrDTWkt4tSYHL9sPYZaCQQ1KwPw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=COyMcdixz5+QT4K0cshfOgggorP538YMv8WGoFxIeI4=;
 b=acHsTek4frrN6/xJ87PFP7xwOfj1DZrAZ9vkj5Bnw523OrPC4v08G/ujL6J5LTcUbftI3DpIKcYzdcAJTIGG8ee9ZUsqxoC1sa9Mn2VR9fispY6JFkLrHCjgNhgl0O8hALJri6GCdxCt3qD1+HYvfcZKhV4vq+KdVhs2ViiFvOh/KINuwiXhvJOCRjf28GjujBdJdiiZig/Duggk90MAmCbo2j9P1yBPzqJEYUHGhjlKok26uYzX3h4l1PdM6eEoSXQ5iOCCo1KP/YAJ5QvXe4FpmoFJUJNKtU78diGvJhAI9EjBAnYlGyhfqE53yS+TDLdVzvCjeeZbjOsMjZc01Q==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=COyMcdixz5+QT4K0cshfOgggorP538YMv8WGoFxIeI4=;
 b=j/V+I0GlQLLOCrMPiy/DyjUDg9kzPxhkxslDzJOlF3bkzjjabOxwTT01Un7yWS5TuIm5gEbh2Ux6s5GdycOw5i9eKVe6LwxYwN/VcPaA6HENL2xLv/l8k0nfrf8vADKDdV3n+peDdakM6N+E/oV6BgGFYkjusgnSba+AbpaSQnk=
Received: from DUZPR01CA0295.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4b7::11) by DU5PR08MB10635.eurprd08.prod.outlook.com
 (2603:10a6:10:51d::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 11:05:01 +0000
Received: from DU2PEPF00028D11.eurprd03.prod.outlook.com
 (2603:10a6:10:4b7:cafe::36) by DUZPR01CA0295.outlook.office365.com
 (2603:10a6:10:4b7::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.12 via Frontend Transport; Fri, 4
 Sep 2026 11:05:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF00028D11.mail.protection.outlook.com (10.167.242.25) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.360.3
 via Frontend Transport; Fri, 4 Sep 2026 11:05:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=c4OOV+hk9j5irdRfONtMSgeunvoqk7sQQcAGHl8F900qHRydL9KX/n1SpnsHqw3nJPqozhrdVGoIBgf8SQ9Oc9AUUd97OTVQmCuQ/QhZHETNZ374SugGwerAMvnggGwdi6dkdnRXl4zLSWhbLYK7qr5MM4APa/M7k/PVlVingfsFPq4oyL3dGFGMD4BZHEcLgcrzYgF005mMqdPF6jT64E1tdizpzMqiFf8pomTAv8Q5pHlnwTCLYKZ2dKb1F6zr1A7mf0UpFhu5ui1JZOGdSIuMmcSo4VXj/rDnaex2bkSY62Bz/S0/KDLDHbRhCc/5bSXJ/05BD1zW1v8vc48mgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=COyMcdixz5+QT4K0cshfOgggorP538YMv8WGoFxIeI4=;
 b=qWlSZ8r0Gdh62fzBbe8G2jquSkliKtgPys7bOIRMv8J89skwlQAeCScZEWRnqLP+MKcdvil/poUeNZiYxbTPaMbw9lqwwEG3P/3f6qdTdPr0FIbiO6W+GngXoJplAbe6PFjU20i3UDG9Jk5LW89zsZ4rXYM6vykE0IINVAKUergWDA3vVPXeipuA2XyTiTYKg/ITFhSSwzH44IsQdxn7J2cgIBExk1wSG1KRzZsxHSxT4KWyYUpl6BPf4ikCXw2Zx3xXnfg3yRY6mB/Fq5I0jXvoOxVqWfLAck3tW+xTvkjhi5UAcsHse2l8eKIhrOk+I6Itk0SrxszLpvTURoeVIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=COyMcdixz5+QT4K0cshfOgggorP538YMv8WGoFxIeI4=;
 b=j/V+I0GlQLLOCrMPiy/DyjUDg9kzPxhkxslDzJOlF3bkzjjabOxwTT01Un7yWS5TuIm5gEbh2Ux6s5GdycOw5i9eKVe6LwxYwN/VcPaA6HENL2xLv/l8k0nfrf8vADKDdV3n+peDdakM6N+E/oV6BgGFYkjusgnSba+AbpaSQnk=
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com (2603:10a6:101:1d::23)
 by AM8PR08MB5603.eurprd08.prod.outlook.com (2603:10a6:20b:1d4::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 11:04:28 +0000
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e]) by PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e%4]) with mapi id 15.21.0382.007; Fri, 4 Sep 2026
 11:04:27 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>
CC: "maz@kernel.org" <maz@kernel.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"oupton@kernel.org" <oupton@kernel.org>, nd <nd@arm.com>
Subject: Re: [PATCH v5 36/49] Documentation: KVM: Document
 KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS for VGICv5
Thread-Topic: [PATCH v5 36/49] Documentation: KVM: Document
 KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS for VGICv5
Thread-Index: AQHdJmA2P2LZ7dRr4kuSI5fmQV+HNraSzkoAgCufQQA=
Date: Fri, 4 Sep 2026 11:04:27 +0000
Message-ID: <6c550cdcb7954c84c4a36de454250221ce2801e9.camel@arm.com>
References: <20260807111159.429128-1-sascha.bischoff@arm.com>
	 <20260807111159.429128-37-sascha.bischoff@arm.com>
	 <20260807165516.D7FC21F000E9@smtp.kernel.org>
In-Reply-To: <20260807165516.D7FC21F000E9@smtp.kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	PR2PR08MB4889:EE_|AM8PR08MB5603:EE_|DU2PEPF00028D11:EE_|DU5PR08MB10635:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a6c7b77-1b7d-4056-c26c-08df0a745d88
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|23010399003|366016|22082099003|10067099003|56012099006|11063799006|4143699003|18002099003|6133799003|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 ch+3zN1j+M5KtyAM/DA99rwJGNlzzitQIttK2zr9eD8D3A4ABiawPW+Mym2iA1zs4kB+N1RAgrTknrHkJxLmIJJ8a2W8XX6SsUOzG4dJl/SjDdo7IhXRHRUreoZ9v+mKcK7WIieN/bykdMjV1BHc79oMFI5l/lYEPyK57PE0m05haOiGUScOnMeit6hVJVpQ9w1O6n8nSsaUyVmbUcQex+SEgl8bXx4ukt+g8CinL6cVZqb5O9MaaHWBbN6w8TLJeZ4COY5ndIQcinHfoY/Gl8WdH25G4izv+ithkM6Q16ZWx2lcwhBn33q7cd2hukziSAXNyqqnrJmhyxmus4FlSE7Bo+PvE3ylQBtbusB64wphAdxUOVDrVwr+l4A8zlMM+IC4O43XndyezkjMQCziAFUqsiOpoKDqj1PNEQz3n9C37ANZsbS9pD+T2sZ8Vl+grgsAKZGbrfizlp5Z6ySGwOIfrY2PKwTjNdiNVYnwBEZAyk7QG5cMiJer31+34qHuqU/e5hkzuEM+wXAUHWUvLxNNMDErYMiUDmYoVjit0Lj3+KzMiuj4P2fQ1BIS/Z+0P6JVB7dbXB1YO9RBvHDTfR4Z/dJC9qyYSB/bo4GEfb8Rw3pZK16Do22/jft1+MYLmzkf41xpgaMg9hU5qAN/YA/n5IAjMNrwOGgVW93dlS7K8NnVT4KMdC1wvdehqpiPfCNt4oj0q1FbZGuBSxMTkeParkt/ravwoYxA4b6LfME=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR2PR08MB4889.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(23010399003)(366016)(22082099003)(10067099003)(56012099006)(11063799006)(4143699003)(18002099003)(6133799003)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <AE7374009D094145903D1248910ECC41@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 bAMB39XvgCMVKttzMCjt+6jXNAskysqeswNbpMbjQwODVjSD0NNYxHwbHAFbDeOpMWO4OLeOBsNeXHfTYf2489N5f0I6JTqi8sZZ8ypO9CfVLsanubBHFzgfHhG2E69eFb4+dmq/XGEjoObY0HRj9IwK9j0r4Q2r2HI6O3mSzCaFqBS/YmPgj0QfGDWXYzXFe+P8ge1z2JqFHYm7Vo1YAi5TIkZWgzxeFfAp/JiwGKwgQWRMPSH41Up6p1devzfYO/l8J76pZd77AGdMGGT6Eg2ZmXdNT55cQAStmky4m/3C1OE+X1Xohy8YBtmnBm8L6ZZMLWb3+QaPy5tQA/bELw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR08MB5603
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF00028D11.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	197856fe-9e51-4ba5-ff09-08df0a7449ac
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|1800799024|14060799003|36860700016|82310400026|23010399003|376014|10067099003|6133799003|22082099003|18002099003|11063799006|56012099006|4143699003;
X-Microsoft-Antispam-Message-Info:
	f+6bRnVGUsb4vPza2SoUQTsLPEnpHGKk+lKJGqMnye8NU9uKRA2SRD0/0wAxMQwr4hhGObwgBpZmOjlnDRTV7tF1T7uNKRmtSH9hJwMsujTdxyhwMKS7rEFVH9TZu3rqGQlFzaatA5x+EzXcKuXrFw3xTLZHnXbPxMA7oKlgBPk41E8FWRpnXWZLo9m+ZBiuZJYZecBIX9t2dJuJdFYVRkvzPvEWsHSGDm/VoO7p+Z9NS7X1WFurmzOzhZp2zlRBbA+DHtG0gLcwccJj47FhVwQ5Q+It2mJDRjII2UhHvYt8CDvSN1lC0cVb4qmDG4zTu+v4gPHrIW8fTNLh6lyiRS2MxcRchkY5255yWb6CDbKQlzA5JBeEExe1M/HSbhg8lZ5j15V9RTgrmpDjryxCoNTWeRAoEAFPmj+dzhHQSbEO/voxjVkYcqSFxvnvKkbeMx0wRFcOhSnNYJMu0QXxQcvnumnfiVIc6UwdFkQh72+q99puV0+3RHS3GEH7wqm1jMfutSfKtY45WaIH7MsBbDl6JgBsiNmye0J5ca45Cmw55vsFVUuZXls57dtDfKgFlkTxXqBrvJakbGlzOcn8rSly/TUeaD3OUtInzrFgqeWAlBbPJmc4gYNDLLv1kx7JOOxRiI7/BnMS5E6vbPNpmqtAp4LEA8DKGrq60bqfgm4=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(1800799024)(14060799003)(36860700016)(82310400026)(23010399003)(376014)(10067099003)(6133799003)(22082099003)(18002099003)(11063799006)(56012099006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	/dNoad/4Oe+iY2pp6k0ODG7LiYLAhmZXOl2CVMrsdrqKmm4t5jMVMYfKSxZb0a4ZsGuYqlpqjIFw411078ty7xff+CfuXD1bFGgjNhCtoJJGRvrOwSnRjtWB0vprO1TvB3FInMtbwEWxyWEmJDExCX8LvcZWm1YBYpqX4wkubAJGf30FH6kmIqu53vRkxQhyuJoWqxdFuTKslgIqGB99pk+FapynzOLzjzAdljMN++TEwOrFpVOtUIDFWhu872NXENtw/rXZQANd4/+d2vI5hqt0sVRtcXzsYo7GimnqTRf79iWVl8SjtTOJ693urvNR5pRle6SGMZFvSYf8tIwIyk+HopA2knGZzygwLMfzFdyT2Yglkqq0SqwDFWybmrazmYA+UHyKlIH1g9altyvyyoydaqaSJaSPhohbO4VfPheUL77HSsIjK4FfnbgExyMh
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2026 11:05:01.0616
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a6c7b77-1b7d-4056-c26c-08df0a745d88
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF00028D11.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU5PR08MB10635

T24gRnJpLCAyMDI2LTA4LTA3IGF0IDE2OjU1ICswMDAwLCBzYXNoaWtvLWJvdEBrZXJuZWwub3Jn
IHdyb3RlOg0KPiBUaGFuayB5b3UgZm9yIHlvdXIgY29udHJpYnV0aW9uISBTYXNoaWtvIEFJIHJl
dmlldyBmb3VuZCAxIHBvdGVudGlhbA0KPiBpc3N1ZShzKSB0byBjb25zaWRlcjoNCj4gLSBbSGln
aF0gUmVzdHJpY3RpbmcgdXNlci1zcGFjZSB3cml0ZXMgdG8gVkdJQ3Y1IHN5c3RlbSByZWdpc3Rl
cnMsDQo+IElSUyBNTUlPIHJlZ2lzdGVycywgYW5kIElTVCBzdGF0ZSBhZnRlciBhIFZDUFUgaGFz
IHJ1biBwcmV2ZW50cyBWTQ0KPiBzb2Z0IHJlc2V0Lg0KPiAtLQ0KPiANCj4gLS0tIFBhdGNoIFsz
Nl06IFtQQVRDSCB2NSAzNi80OV0gRG9jdW1lbnRhdGlvbjogS1ZNOiBEb2N1bWVudA0KPiBLVk1f
REVWX0FSTV9WR0lDX0dSUF9DUFVfU1lTUkVHUyBmb3IgVkdJQ3Y1IC0tLQ0KPiBjb21taXQgNWJl
ODI2YjViODZkZGJjZmE3NzhmNTgyYWQzMTRiYTFlNDU5OTExMw0KPiBBdXRob3I6IFNhc2NoYSBC
aXNjaG9mZiA8U2FzY2hhLkJpc2Nob2ZmQGFybS5jb20+DQo+IA0KPiBEb2N1bWVudGF0aW9uOiBL
Vk06IERvY3VtZW50IEtWTV9ERVZfQVJNX1ZHSUNfR1JQX0NQVV9TWVNSRUdTIGZvcg0KPiBWR0lD
djUNCj4gwqDCoMKgIA0KPiBUaGlzIGNvbW1pdCBkb2N1bWVudHMgdGhlIEtWTV9ERVZfQVJNX1ZH
SUNfR1JQX0NQVV9TWVNSRUdTIEFQSSBmb3INCj4gdGhlIHZpcnR1YWwNCj4gR0lDdjUsIGRlZmlu
aW5nIHRoZSByZWdpc3RlciBsYXlvdXQsIHN1cHBvcnRlZCBzeXN0ZW0gcmVnaXN0ZXJzLCBhbmQN
Cj4gZXJyb3INCj4gY29kZXMuDQo+IA0KPiA+IGRpZmYgLS1naXQgYS9Eb2N1bWVudGF0aW9uL3Zp
cnQva3ZtL2RldmljZXMvYXJtLXZnaWMtdjUucnN0DQo+ID4gYi9Eb2N1bWVudGF0aW9uL3ZpcnQv
a3ZtL2RldmljZXMvYXJtLXZnaWMtdjUucnN0DQo+ID4gaW5kZXggYzc4MmVhNGQ0NjA5Yy4uN2U0
MWQ2Njk5NTM4ZiAxMDA2NDQNCj4gPiAtLS0gYS9Eb2N1bWVudGF0aW9uL3ZpcnQva3ZtL2Rldmlj
ZXMvYXJtLXZnaWMtdjUucnN0DQo+ID4gKysrIGIvRG9jdW1lbnRhdGlvbi92aXJ0L2t2bS9kZXZp
Y2VzL2FybS12Z2ljLXY1LnJzdA0KPiBbIC4uLiBdDQo+ID4gK8KgIEVycm9yczoNCj4gPiArDQo+
ID4gK8KgwqDCoCA9PT09PT09wqANCj4gPiA9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09DQo+ID4gK8KgwqDCoCAtRU5YSU/CoMKgIEdl
dHRpbmcgb3Igc2V0dGluZyB0aGlzIHJlZ2lzdGVyIGlzIG5vdCBzdXBwb3J0ZWQNCj4gPiArwqDC
oMKgIC1FQlVTWcKgwqAgVkNQVSBpcyBydW5uaW5nLCBvciB3cml0ZSBhdHRlbXB0ZWQgYWZ0ZXIg
YSBWQ1BVIGhhcw0KPiA+IHJ1bg0KPiANCj4gW1NldmVyaXR5OiBIaWdoXQ0KPiBEb2VzIHJldHVy
bmluZyAtRUJVU1kgd2hlbiBhIHdyaXRlIGlzIGF0dGVtcHRlZCBhZnRlciBhIFZDUFUgaGFzIHJ1
bg0KPiBwcmV2ZW50DQo+IFZNIHNvZnQgcmVzZXRzPw0KPiANCj4gRHVyaW5nIGEgc29mdCByZXNl
dCAoc3VjaCBhcyBQU0NJIFNZU1RFTV9SRVNFVCksIFFFTVUgdHlwaWNhbGx5DQo+IHBhdXNlcyB0
aGUNCj4gdkNQVXMgYW5kIHJld3JpdGVzIHRoZSBpbml0aWFsIHN0YXRlIG9mIHRoZSBHSUMgZGV2
aWNlIHdoaWxlIHRoZSBLVk0NCj4gVk0gaXMNCj4gc3RpbGwgY29uc2lkZXJlZCB0byBoYXZlIHJ1
biBvbmNlLCBzaW5jZSBpdCBkb2Vzbid0IGRlc3Ryb3kgYW5kDQo+IHJlY3JlYXRlIHRoZQ0KPiBl
bnRpcmUgS1ZNIFZNLg0KPiANCj4gSWYgS1ZNIGVuZm9yY2VzIHRoaXMgcmVzdHJpY3Rpb24gb24g
S1ZNX0RFVl9BUk1fVkdJQ19HUlBfQ1BVX1NZU1JFR1MNCj4gYW5kDQo+IG90aGVyIGRldmljZSBz
dGF0ZXMsIHdvbid0IHRoaXMgcmVqZWN0IFFFTVUncyBzdGF0ZSByZXN0b3JlIHNlcXVlbmNlDQo+
IGFuZA0KPiBwcmV2ZW50IHRoZSBWTSBmcm9tIHJlYm9vdGluZyBncmFjZWZ1bGx5Pw0KDQpUaGlz
IGlzIGEgZ29vZCBwb2ludCwgYnV0IEkgZG9uJ3QgdGhpbmsgdGhhdCB3ZSBjYW4gcmVhbGlzdGlj
YWxseSB3b3JrDQp0aGlzIGludG8gdGhlIGV4aXN0aW5nIEFQSXMuDQoNCkkgdGhpbmsgd2Ugd2ls
bCBhY3R1YWxseSBuZWVkIGFuIGV4cGxpY2l0DQpLVk1fREVWX0FSTV9WR0lDX1Y1X0NUUkxfUkVT
RVQgb3Igc2ltaWxhciwgbGlrZSB3ZSBhbHJlYWR5IGhhdmUgZm9yIHRoZQ0KSVRTIChLVk1fREVW
X0FSTV9JVFNfQ1RSTF9SRVNFVCkuIFRoZSBwcm9ibGVtIHdlIGhhdmUgaXMgdGhhdCBHSUN2NQ0K
bWFuYWdlcyB0aGUgc3RhdGUgb2YgaW50ZXJydXB0cyBpbiBoYXJkd2FyZSwgc28gb24gYSByZXNl
dCB3ZSBwcmV0dHkNCm11Y2ggbmVlZCB0byBtYWtlIHRoZSBWTSBpbnZhbGlkLCB0ZWFyIGRvd24g
dGhlIElTVHMsIHJlYWxsb2NhdGUgYQ0KY2xlYW4gU1BJIElTVCwgemVybyBLVk0ncyBQUEkvU1BJ
IHNoYWRvdyBzdGF0ZSwgcmVzZXQgdGhlIElSUyBNTUlPDQpyZWdpc3RlciBzdGF0ZSwgYW5kIHRo
ZW4gbWFrZSB0aGUgVk0gdmFsaWQgYWdhaW4uIEVpdGhlciB0aGF0IG9yIHdlIGxldA0Kc3RhdGUg
cGVyc2lzdCBhY3Jvc3MgdGhhdCBib3VuZGFyeSwgaW4gd2hpY2ggY2FzZSBZTU1WLg0KDQpJcyB0
aGlzIHNvbWV0aGluZyB0aGF0IHdlJ2QgYmUgaGFwcHkgdG8gYWRkcmVzcyBsYXRlciwgb3Igc2hv
dWxkIEkgd29yaw0KdGhpcyBpbnRvIHRoZSBjdXJyZW50IHNlcmllcz8NCg0KPiANCj4gPiArwqDC
oMKgIC1FSU5WQUzCoCBJbnZhbGlkIG1waWRyIG9yIHJlZ2lzdGVyIHZhbHVlIHN1cHBsaWVkDQo+
ID4gK8KgwqDCoCA9PT09PT09wqANCj4gPiA9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09DQo+IA0KVGhhbmtzLA0KU2FzY2hhDQo=
