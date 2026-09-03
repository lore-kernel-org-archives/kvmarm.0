Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013058.outbound.protection.outlook.com [52.101.83.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE2393D47A8;
	Thu,  3 Sep 2026 14:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.58
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788445403; cv=fail; b=BLOkq3+KXmIVXHaQdA30zb8GaQsCbiqPYsrpJfK3+ZWRFGo912EzmX+GC95mA7pASbsN+tQq4GaKRpvUAzQA1rvO9X2YzoRJZe+dgh+8QZva1d8b+M2Wv9i/g0MDQsKIA/vDkYDa/K1WBowoBSK+Ph5A9YxnaJNQaC0eeP9f2M4=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788445403; c=relaxed/simple;
	bh=sqDceeTAVn13lZAieyJHxIDQiSlYVj5L1EnyvAw8joU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Jd8zy7AB/ecn+NSH/zqjQm/EIMPs/RT2Q0c1wMN/6FLm+NWdqoGqjPSX8NIWpZdqF9SRyKkQIy06JXTdQSlmDcxsnjHxEyR/4KeOamOUwMeBwN48TCUyMRJl9On8aWRBmHDP6Pcx2EAJkOphiNu7wXeB1L0Ku5lHvQP5YqIDp0Y=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=l+23nzIk; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=l+23nzIk; arc=fail smtp.client-ip=52.101.83.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="l+23nzIk";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="l+23nzIk"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=b0H8uHCIT5tDNxpFZlwDtk4KzmOpExe8qicvylqjft3n6LTBsTZ+pPxRPh70dLuLCAlb6emJs3+W+BZhLoDF9UlPdJmnH5lXv1SEVjwPzFeejxLe7XDCb3zwVpcrNNYfy3Y+HNK+sPLznLweEfp3tiQnsvIcQiYsP/woBtbVS1x/BsmsmetsJCRxUDhASu2qjbwdOUFdmCS+KZBN2B22A/20yqHgnYlGgfa9/3ZUIdnsXSvmBUPGdj4p7kYLZLatmh6mheoZUKk7ZN/3X7u23Q4mbgU1YaIUKxQ4DlXvCOP52AClbRJO0gPNSmmxKIuzE/S99yW/kDENulqzS4ZrtA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sqDceeTAVn13lZAieyJHxIDQiSlYVj5L1EnyvAw8joU=;
 b=hioLZqfeCiOhjmYaqvm3ZejLh/0o9YSLmHFvEPFMPq/H+IgpqD2MzbSsBCNci1pL9OIOfGC17ZkHjZ1e6/nx1BRMSI/2E8GAq+l1Szakn+jBLYdFOmBh4HVnLskLqkb6mJA2tiL8Dzzq6Xmq4t1sBsobB0aGbZslaMWdoSUbXXatNtnveDarrqLuV2KntvZcv3G+4QzsYWtxkJg1rEISiTBjiFH1/JUYCUD3L0brS6wjV+Tmsc5u3XK0qTsuf848oxD6S9Jzrcu3JHXV7mlNK1c1F70kQz9MthmQcvvQriRbOlzSoDJ4AYFD3w7J1owO3m6zbSJkGgt8mE0JBtK1BA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sqDceeTAVn13lZAieyJHxIDQiSlYVj5L1EnyvAw8joU=;
 b=l+23nzIkQyhW6mHyJtXbyOoqVPmpoUiXdVQkT7JepFwh4dysGm90d/4jH7wCA4fuNxdkLUT0fPfa8/TVYWq4amMb0i/7Na99P+A4YKxFgclhuwI35Z2/M9LatjqSoq8qOj/8m+o8PNh+dYZ+OVM4S7iI5pj7RTdnF1Ne/mcKKp8=
Received: from MA3P292CA0043.ESPP292.PROD.OUTLOOK.COM (2603:10a6:250:46::17)
 by DB5PR08MB9998.eurprd08.prod.outlook.com (2603:10a6:10:489::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Thu, 3 Sep
 2026 14:22:57 +0000
Received: from MAD0EPF000008B3.eurprd04.prod.outlook.com
 (2603:10a6:250:46:cafe::35) by MA3P292CA0043.outlook.office365.com
 (2603:10a6:250:46::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.11 via Frontend Transport; Thu, 3
 Sep 2026 14:22:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 MAD0EPF000008B3.mail.protection.outlook.com (10.167.241.135) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.8
 via Frontend Transport; Thu, 3 Sep 2026 14:22:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Va8Sg+YwOKTPEcvo+pe+iIYpOfUvOXOux+6cjC0AbhQOjZ1DFX303ly7YBU33V19qiUpts6W3GyZkRu+zr2jVOKvDy14dmYPuBfN1DtirHDF8/uUkqy6Dlc8OeaIDuaHL54flRtEG+7d+6EUBSZwfkvnADxtIfNKRJammAHiXbiCPX4OHOU8HpJ0XYt2BptAo0+I3LUKfs9KODSUiP756jXb8vCItoeN4/rOLTjy1/j9Cd6qDbKmX+LTyPhpG/wewfO51ok8v23xJeOK6Gr1/HZGybZmqHR8sGS2ivuuVcEj5l0GFtfFcEwCntW4ngQ3HlJmZozsTo2YIrTNsi58eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sqDceeTAVn13lZAieyJHxIDQiSlYVj5L1EnyvAw8joU=;
 b=gQ6bTCzcQ9gg2doD00X3QwwJhg0dLOEXxzRqYqw5+3CbdV2OmQ2lt/qa0Y1pUd9MIdBjA3tl83qdtHD8sT+ciNmuFL4feTchAuu5NbQ7e31k6mPEShfziHuqt8UPRUCbnWd1GcTBfIgr1+qUbiHGZXJuJno4u4ZW5L6lsaQiIdXBSlnhAJqkCj1iwdFjPSe0mgoPHqZdoihNacO503y4cVm+eKdpJ2PMTTB7aH0TAvgBEnSTjomcbkXAwF280LmbIhRpF8+3iaX0dqD6isJMS+lalmMyG2Y52q0LnVMg+ohiihA0Us1ZkYyyBrKkcwpWH7l4VZCt7uPjUFic7GAT7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sqDceeTAVn13lZAieyJHxIDQiSlYVj5L1EnyvAw8joU=;
 b=l+23nzIkQyhW6mHyJtXbyOoqVPmpoUiXdVQkT7JepFwh4dysGm90d/4jH7wCA4fuNxdkLUT0fPfa8/TVYWq4amMb0i/7Na99P+A4YKxFgclhuwI35Z2/M9LatjqSoq8qOj/8m+o8PNh+dYZ+OVM4S7iI5pj7RTdnF1Ne/mcKKp8=
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com (2603:10a6:101:1d::23)
 by MRWPR08MB11683.eurprd08.prod.outlook.com (2603:10a6:501:94::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Thu, 3 Sep
 2026 14:22:24 +0000
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e]) by PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e%4]) with mapi id 15.21.0382.007; Thu, 3 Sep 2026
 14:22:24 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>
CC: "maz@kernel.org" <maz@kernel.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"oupton@kernel.org" <oupton@kernel.org>, nd <nd@arm.com>
Subject: Re: [PATCH v5 03/49] irqchip/gic-v5: Set up gic_kvm_info on ACPI
 hosts
Thread-Topic: [PATCH v5 03/49] irqchip/gic-v5: Set up gic_kvm_info on ACPI
 hosts
Thread-Index: AQHdJl3dOdPEmMuWIEihuIlxfsIsfbaSfCgAgCqWYoA=
Date: Thu, 3 Sep 2026 14:22:24 +0000
Message-ID: <816a2673db63a10dfcc9e8b918e1aec9c39039c5.camel@arm.com>
References: <20260807111159.429128-1-sascha.bischoff@arm.com>
	 <20260807111159.429128-4-sascha.bischoff@arm.com>
	 <20260807120115.368FC1F00A3A@smtp.kernel.org>
In-Reply-To: <20260807120115.368FC1F00A3A@smtp.kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	PR2PR08MB4889:EE_|MRWPR08MB11683:EE_|MAD0EPF000008B3:EE_|DB5PR08MB9998:EE_
X-MS-Office365-Filtering-Correlation-Id: 6ec67169-d72c-41ae-9b4f-08df09c6d9f4
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|23010399003|366016|18002099003|22082099003|5023799004|11063799006|38070700021|4143699003|6133799003|10067099003|56012099006;
X-Microsoft-Antispam-Message-Info-Original:
 OWr4Yq001zhCUGLEQb7bdCQd9QJQMXDioA9/ca8xYrIQNujS3sbUmGkIlxEmiRG3vQt/IyE/1+10L+5VBHDkFMMRLgH7sP9x64eYG+ZPVHY2+b7wOaYqYma83Ot2cquAjCbWMfvydLmb2LM4M4iBpL902zJXT6xD8q3hM83cHYBEI37oiQUI3g6f0BaQeTjeRh9c3w2pCNfS6BwOSQYk7bPYtonT2Win3EYP40X8DzMwcXMcIGNUiERrV56e+aoVxMFdd+VZAnYKG29CccP36kFVtvuG9M3FFp8PBo5xaY0kzr3eaBzl8GLp/UlbP/GIHIUYkEVuJX7fnx0i4/t3bsovbkLjpV0XGY2cQcMDgQgXOkVq4liTGIUdvmaRTIdFBrBf6vcPGXAxGV+jQKw+TlfwF3ZROu7ybgEVFSxyXDzNe1ULi23wclB90boJFA3OVGZU3g/9yJgjFSpAlzYkiALboC0Hy5/b4/A8zofgkyvExZgY7W6TiZD1lkz9+WilAgA1v2azZmqbSDCYnIPbAXcaudqQUJwolk/mnm+c+uo8NAGpRQ23a4r7IN7WCy1qDke3WNTwThZr9tw2tWI9pZrvKYHhUvwCNigojaaVOk80VDCJKalM8e+Y6pzSnS12iaUKQ/nL67wSxPiFJLkHwV3fNkUUFLQCN/3C2jn58AkEhMnS1Qy2dWx4zBMuvMq0oZV3RTR1pzvmSRZgh03q3quj9UcP8SncZHkbEHjXCJ8=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR2PR08MB4889.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(23010399003)(366016)(18002099003)(22082099003)(5023799004)(11063799006)(38070700021)(4143699003)(6133799003)(10067099003)(56012099006);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <160E593935BBAF439105CD36F0088772@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 BFBO0qG6mNlzfY49X3ppEPLmZSOl6W6U07UTpPQdTwbhP5YZ1f0psO9qXZ0gQ75mnVuvTUQ+/Swm9f5ImPsXQjYg1NOk1xwNjjW9+pRkLH/jvbadjK7KRfB9qul8HnVqzEU+7Aw8huhSYOu00zVeDa9Ra2yl6bJKfnijR/BaTwlLLvPD95+JV/aEEMxHrK18rSOaN1tgLAhHOvuTGKgQKQlhPoOv/k5cSrY29JpoHM+dPOPiUk0IbrVtL9mM2I+3HngD8oV0A2e1czP6jxI2TdJKasGce2u306K7+F73vN/HWCONh2iliKYG+n+6H7bI4nnTvpHagf70ECPZr4nyNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MRWPR08MB11683
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 MAD0EPF000008B3.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	dc4e924a-beb6-45dc-475e-08df09c6c64f
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|1800799024|376014|35042699022|23010399003|14060799003|82310400026|4143699003|10067099003|5023799004|56012099006|11063799006|18002099003|22082099003|13003099007|6133799003;
X-Microsoft-Antispam-Message-Info:
	dJ7mHU6yzmLfWS5GfhHIC6Vm6I+554LN8sANj6qoYYe5V6L5ej7aj8pwhZsFZ5F11rMHniRgUAFzbbQmGEG2/xjSc9iq0T8JgqOcgdLQ0alIyJzUomACUcE3D9YrRLx5SukIqcCcK09QWM5W3vN1czyvDFemIEWkCSEs/Ph7xDIvnoQ+k/kuBdjSmDvhPRjk91XUadXMCgt6GjMyeZoKsdfSd0CjhQ/LWh23rSShMFl3IhoXK4dahn2qUtmjUUo6B2Y9JzwQoRy8s/KzsTI37e/XnHDCaUL7/c12KOFXRMJICmCWGxHxcA9wmsYKlhjldzHs3M47sqnDVNZdTHSUqownZ2OLRMsVPNnPhArdw/gOhLpFMddF58P/LKwjUxaHyKRuGythb61ITtLJV9PSTKqswNpCoULvHs1Ml8UG6OjC+TOyFZ9jU+eamPkbb4z5mSjeBojdDhvIEBdMS89AP8j1L/SOUZq7EPHYdAsWFWaxQ3W+DTEEc/jZUSVgAQatxTb4zHhk4hxMIABmP7C6fi96prLe0xNFEXTY/m4Divuz9S+d1/9mswOaqcSbZGh569gImBa2RHl7YJiUQpsDMXj/fYrIa1VhYczW6VgbohII6F2X2yJB2IV9YZ0v401qYdrBFOuBMQ7qe0SmskILTL/pfZ0NhJgcKzZvQM07+Ig=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(1800799024)(376014)(35042699022)(23010399003)(14060799003)(82310400026)(4143699003)(10067099003)(5023799004)(56012099006)(11063799006)(18002099003)(22082099003)(13003099007)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	j7LtZ5fucusbhCvlIxfTC+mumunf5nB0bVmDZhEXG5yUu/zhVm4BE4/0Okwn9kzfHEGCLJLOYitIEVob63V9BKxky/nSrzaiNciBjmhgnBLupXGRDxSGRYZ3hCBcYtFmxaVtb9NoUY6x63IpSc4TbM9zr1818TnrPpZL6jupLU0zaCvJD6JNN2/OtHOTb2PA21dxQjfHpSKgcvxu9f5QiKEeF0eFO8YjM8N3/wQkXTHYXhV05hIRgVYaIZHZ051ZTI87IHZbGgmwMpLRN2nrNWAtWaOeS95illWIV2wl5zxUAR/j8bhIUUm/f6JPw41vGxh8Gk4PUVXAe23rFF+k5hgKE2/O/xFQeaWD0faDMRYtdljz04yNSfbem3dqMe1Ew5QCWX5DB6odGKd6wqw1LvlP6CAQ7+fA+YV4nIFaj6HIXE4kKL8WSYO+60B6y5QI
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2026 14:22:57.3114
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ec67169-d72c-41ae-9b4f-08df09c6d9f4
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MAD0EPF000008B3.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB5PR08MB9998

T24gRnJpLCAyMDI2LTA4LTA3IGF0IDEyOjAxICswMDAwLCBzYXNoaWtvLWJvdEBrZXJuZWwub3Jn
IHdyb3RlOg0KPiBUaGFuayB5b3UgZm9yIHlvdXIgY29udHJpYnV0aW9uISBTYXNoaWtvIEFJIHJl
dmlldyBmb3VuZCAxIHBvdGVudGlhbA0KPiBpc3N1ZShzKSB0byBjb25zaWRlcjoNCj4gLSBbSGln
aF0gTWlzc2luZyBib3VuZHMgY2hlY2sgaW4gZ2ljX2FjcGlfcGFyc2VfdmlydF9tYWR0X2dpY2Mo
KSB3aGVuDQo+IHBhcnNpbmcgQUNQSSBNQURUIEdJQ0Mgc3VidGFibGVzLCBsZWFkaW5nIHRvIG91
dC1vZi1ib3VuZHMgcmVhZCBvbg0KPiBtYWxmb3JtZWQgdGFibGVzLg0KPiAtLQ0KPiANCj4gLS0t
IFBhdGNoIFszXTogW1BBVENIIHY1IDAzLzQ5XSBpcnFjaGlwL2dpYy12NTogU2V0IHVwIGdpY19r
dm1faW5mbw0KPiBvbiBBQ1BJIGhvc3RzIC0tLQ0KPiBjb21taXQgNzE0N2U1YjZmZWMzOWRjZDcx
ZTUzM2I3ZGRkNTI1MmQzMDkxMDNhNQ0KPiBBdXRob3I6IFNhc2NoYSBCaXNjaG9mZiA8U2FzY2hh
LkJpc2Nob2ZmQGFybS5jb20+DQo+IA0KPiBpcnFjaGlwL2dpYy12NTogU2V0IHVwIGdpY19rdm1f
aW5mbyBvbiBBQ1BJIGhvc3RzDQo+IA0KPiBUaGlzIGNvbW1pdCBhZGRzIHRoZSBBQ1BJIGVxdWl2
YWxlbnQgb2YgdGhlIERUIEtWTSBzZXR1cCBmb3IgR0lDdjUuDQo+IEl0IHBhcnNlcw0KPiB0aGUg
TUFEVCBHSUNDIGVudHJpZXMgdG8gcmV0cmlldmUgYW5kIHJlZ2lzdGVyIHRoZSBtYWludGVuYW5j
ZQ0KPiBpbnRlcnJ1cHQsIGFuZA0KPiBwYXNzZXMgdGhlIHJlc3VsdGluZyBJUlEgYWxvbmcgd2l0
aCBJUlMgYmFzZSBhbmQgY29oZXJlbmN5DQo+IGluZm9ybWF0aW9uIHRvIEtWTS4NCj4gDQo+ID4g
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvaXJxY2hpcC9pcnEtZ2ljLXY1LmMgYi9kcml2ZXJzL2lycWNo
aXAvaXJxLQ0KPiA+IGdpYy12NS5jDQo+ID4gaW5kZXggZTdhN2FlZGNmYWY3OC4uNWI4ZWE4NTUx
ZDgzMiAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL2lycWNoaXAvaXJxLWdpYy12NS5jDQo+ID4g
KysrIGIvZHJpdmVycy9pcnFjaGlwL2lycS1naWMtdjUuYw0KPiBbIC4uLiBdDQo+ID4gQEAgLTEx
NjIsMTEgKzExNjQsOTUgQEAgc3RhdGljIHZvaWQgX19pbml0DQo+ID4gZ2ljX29mX3NldHVwX2t2
bV9pbmZvKHN0cnVjdCBkZXZpY2Vfbm9kZSAqbm9kZSkNCj4gWyAuLi4gXQ0KPiA+ICtzdGF0aWMg
aW50IF9faW5pdCBnaWNfYWNwaV9wYXJzZV92aXJ0X21hZHRfZ2ljYyh1bmlvbg0KPiA+IGFjcGlf
c3VidGFibGVfaGVhZGVycyAqaGVhZGVyLA0KPiA+ICsJCQkJCQljb25zdCB1bnNpZ25lZA0KPiA+
IGxvbmcgZW5kKQ0KPiA+ICt7DQo+ID4gKwlzdHJ1Y3QgYWNwaV9tYWR0X2dlbmVyaWNfaW50ZXJy
dXB0ICpnaWNjID0NCj4gPiArCQkoc3RydWN0IGFjcGlfbWFkdF9nZW5lcmljX2ludGVycnVwdCAq
KWhlYWRlcjsNCj4gPiArCXN0YXRpYyBpbnQgZmlyc3RfbWFkdCA9IHRydWU7DQo+ID4gKw0KPiA+
ICsJaWYgKCEoZ2ljYy0+ZmxhZ3MgJg0KPiANCj4gW1NldmVyaXR5OiBIaWdoXQ0KPiBDb3VsZCB0
aGlzIHJlYWQgb2YgZ2ljYy0+ZmxhZ3MgbGVhZCB0byBhbiBvdXQtb2YtYm91bmRzIG1lbW9yeQ0K
PiBhY2Nlc3M/DQo+IA0KPiBJZiB0aGUgZmlybXdhcmUgcHJvdmlkZXMgYSBtYWxmb3JtZWQgQUNQ
SSBNQURUIHRhYmxlIHdpdGggYW4gZW50cnkNCj4gbGVuZ3RoDQo+IHNtYWxsZXIgdGhhbiB0aGUg
c2l6ZSBvZiBzdHJ1Y3QgYWNwaV9tYWR0X2dlbmVyaWNfaW50ZXJydXB0LCByZWFkaW5nDQo+IGdp
Y2MtPmZsYWdzIG9yIGdpY2MtPnZnaWNfaW50ZXJydXB0IG1pZ2h0IGNyb3NzIGEgcGFnZSBib3Vu
ZGFyeSBhbmQNCj4gY2F1c2UgYQ0KPiBrZXJuZWwgcGFuaWMgZHVyaW5nIGVhcmx5IGJvb3QuDQo+
IA0KPiBXb3VsZCBpdCBtYWtlIHNlbnNlIHRvIHZhbGlkYXRlIHRoZSBlbnRyeSBzaXplIGFnYWlu
c3QgdGhlIGVuZA0KPiBwb2ludGVyIGhlcmUsDQo+IHBlcmhhcHMgYnkgdXNpbmcgYSBtYWNybyBs
aWtlIEJBRF9NQURUX0dJQ0NfRU5UUlkoZ2ljYywgZW5kKSwgYmVmb3JlDQo+IGFjY2Vzc2luZw0K
PiBhbnkgb2YgdGhlIHN0cnVjdHVyZSdzIGZpZWxkcz8NCg0KVGhpcyBoYXMgYmVlbiBhZGRyZXNz
ZWQgYnkgTG9yZW56byBpbiBoaXMgc2VyaWVzIGhlcmU6DQpodHRwczovL2xvcmUua2VybmVsLm9y
Zy9hbGwvMjAyNjA4MTItZ2ljdjUtNy0yLWZpeGVzLXYxLTAtMzc0M2U4MmM2OWE0QGtlcm5lbC5v
cmcvDQoNCj4gDQo+ID4gKwnCoMKgwqDCoMKgIChBQ1BJX01BRFRfRU5BQkxFRCB8DQo+ID4gQUNQ
SV9NQURUX0dJQ0NfT05MSU5FX0NBUEFCTEUpKSkNCj4gPiArCQlyZXR1cm4gMDsNCj4gDQoNClRo
YW5rcywNClNhc2NoYQ0K
