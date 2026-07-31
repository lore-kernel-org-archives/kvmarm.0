Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013017.outbound.protection.outlook.com [52.101.83.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3400444C66F;
	Fri, 31 Jul 2026 16:25:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.17
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785515115; cv=fail; b=pCB0YZdtW9onb5BsP3uEp2kBZgx8twdI8TeCRFSO5dtBBTqB9hCDTuTrW1FQsdCH1h/ImNSWBipKc77pW9vAHKiV3xko9EEPUrboHM50GLa41yAcRnBnzhwyzGLBoH4v/Rw0g8dDkL2+LoYUBJGCRK5WeNMNccj+164sJNZi7Nk=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785515115; c=relaxed/simple;
	bh=WEkMUmwuffbKA50SK5ttWfIE2P1171poVmJgJ5cyE6I=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=B5QWasrXQA4TcWEOrvWGu/KDvX90Bds80pnEWGhaTDhUCW/PR6iVhzJV5sVkgsF0qE/CXsIfq6RiNjGwe/+BrLC7VhLF9f+PKOgqV/F/GN3eZ9YX1uakQg0+uCJe8RAMPmdqWVNlC+NGVIIV8sEDTH25EOrvWu3DZsJcJ4X5iL4=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=TCM+CV38; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=TCM+CV38; arc=fail smtp.client-ip=52.101.83.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="TCM+CV38";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="TCM+CV38"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=SVccf1I5GwRhQ5+VvLnbubPwoz5zU1zVDMT2LkSwJ3TzCyVt2rSTbR6xOI06p8Onzbl7g6kfsPP11S/5KABiLk4YlQ6APqv5AjWG7to4i9B225S75Dk3VvpwUIkt0ug4iC/EagdLfCy1HtPb26aY5uWBxUPG2DynlcoAGOysxx7/hOrZHUEb6GY8PQZjPBcX5nNl1ha123MIOXYbEjHxK6t+/A36D6YgBxsIVgVhMkq+UDn79aUGI4T831rHbqdrWbZOfZqiFbzwKdl0Kfy5SXwLIQ/Ixa12PfJ6GRTcrfqFOWhFAXVmSPk4nSMv7sfq92+4WUBg/MrUIC0EF3tbeQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WEkMUmwuffbKA50SK5ttWfIE2P1171poVmJgJ5cyE6I=;
 b=JDJvFZmuQfJpL6zF4CHx5pAG3HJxclQy7cC3GP3PlM5xYd7EpxpO0uGWl5SSINlqyOJJ9BW6hdy9A3pN/ArNN/vhmfmFEFNijZqGg4DS5XpDOLNezHWPBM3xPBwKrshcVqGfLQhnZr2KOZ5yAq1RCbWLm4dncwdHU8W+C1LAjqu7yvTRdi8TSTeegQgnLi6fdT8GglPnB0PYh6IcTVzVJettmoqAIAzZtsGJ2fETpMgp6BOP5wdsXcz2QYHGc+QlVvrZe/lnCQm/lG6FjKwZcszQzeHGYs9xI9A31Km/7aN38PV97KuFJjXcfRiLlc+gT65mFGIamYOaqoWte9VICQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WEkMUmwuffbKA50SK5ttWfIE2P1171poVmJgJ5cyE6I=;
 b=TCM+CV385qjOQzIJgPIltZuC/VAygAiV/J9Kvf1BFY1J4+7OAIthuyTXZOadoIuQvcwtXLO2OjGkYGzGVMv16pITbwSS8mUlSWHWCnFjD6n69ziPhRvifGhNc6sZ6RS+wtloUQDraWevjtaxwqPuDxB7E2wwpYonQCTxX8LjUWs=
Received: from DUZPR01CA0016.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:46b::9) by DB9PR08MB9659.eurprd08.prod.outlook.com
 (2603:10a6:10:45e::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.15; Fri, 31 Jul
 2026 16:25:05 +0000
Received: from DU2PEPF00028D0D.eurprd03.prod.outlook.com
 (2603:10a6:10:46b:cafe::1f) by DUZPR01CA0016.outlook.office365.com
 (2603:10a6:10:46b::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.15 via Frontend Transport; Fri,
 31 Jul 2026 16:25:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF00028D0D.mail.protection.outlook.com (10.167.242.21) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.5
 via Frontend Transport; Fri, 31 Jul 2026 16:25:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=i7M/f9CZZxHGqGypQYQ6fFKDyHZE1WcG8VCIzi9HZYqtxrSQDISf4DHSQ+FDXOZnUpgC6VwtcMRQm94MlarjDq9PpjGSVJ3bjSp4RHcCHb7RZaA+cYBtWktG3UKf7WmQ5L5/NXDQ/7AXbojNRh4CxxCARnH7Pkl63BJV1IDAZ0TzaWWOn6WRQZ/pNRTyocra2TN06FgZFw1vCxR6H/CL1tppfsbV5ls1KkVU40ETyKLb88LgVr+RKjdIbXXXMUSUBnWzl13NO6rulrDJXttz/oBlmjf29u/JaDYCImKaF9HOKFNMIwOR4nGFtxfWVNXIsKopSrb+rlaE0Kz8sBCblQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WEkMUmwuffbKA50SK5ttWfIE2P1171poVmJgJ5cyE6I=;
 b=aWIYwH1q2qY4FXZIWmTDcnCBi1fhRAB+BLVwLJGjsSUajdxmH2FGobbxg6qYb0PnJndgU3nzm+ZLYuq7j+iCbNh0dHe1EEzpyUyBmkg7dopqoirodAN8stj3x/zhnCES2Q7gcpxb//VID4TnrbQNnT8lNFWKIbFBEwNan+f4v5E+kmLsCKySDJVEDhrlHQCfGi6ue0oGl8F2eB2uHFfnmTUSrydEXcDGUn+TWnCl8j7GwQBIJnr5yUl8FwqkA2BMmckoTvl0viQO0TkaKPi47qBbuJuZPqCksXoA0CxHBycKkh5Zk29DCIw6Fh9JWSdKzZ5+qiX6fG16sdY8HozrJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WEkMUmwuffbKA50SK5ttWfIE2P1171poVmJgJ5cyE6I=;
 b=TCM+CV385qjOQzIJgPIltZuC/VAygAiV/J9Kvf1BFY1J4+7OAIthuyTXZOadoIuQvcwtXLO2OjGkYGzGVMv16pITbwSS8mUlSWHWCnFjD6n69ziPhRvifGhNc6sZ6RS+wtloUQDraWevjtaxwqPuDxB7E2wwpYonQCTxX8LjUWs=
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com (2603:10a6:10:407::19)
 by FRZPR08MB11047.eurprd08.prod.outlook.com (2603:10a6:d10:13b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.15; Fri, 31 Jul
 2026 16:24:03 +0000
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e]) by DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e%5]) with mapi id 15.21.0270.012; Fri, 31 Jul 2026
 16:24:02 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>
CC: "maz@kernel.org" <maz@kernel.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"oupton@kernel.org" <oupton@kernel.org>, nd <nd@arm.com>
Subject: Re: [PATCH v4 41/48] KVM: selftests: Add VGICv5 NR_IRQS attribute
 tests
Thread-Topic: [PATCH v4 41/48] KVM: selftests: Add VGICv5 NR_IRQS attribute
 tests
Thread-Index: AQHdG1tttDEzstl/NEyfUZegvM8dUrZ8ke8AgAtJWQA=
Date: Fri, 31 Jul 2026 16:24:02 +0000
Message-ID: <1b1ad564a732dcaf7c81789a7569d55c9c335276.camel@arm.com>
References: <20260724104819.1296803-1-sascha.bischoff@arm.com>
	 <20260724104819.1296803-42-sascha.bischoff@arm.com>
	 <20260724120240.C69B91F00A3E@smtp.kernel.org>
In-Reply-To: <20260724120240.C69B91F00A3E@smtp.kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU0PR08MB8421:EE_|FRZPR08MB11047:EE_|DU2PEPF00028D0D:EE_|DB9PR08MB9659:EE_
X-MS-Office365-Filtering-Correlation-Id: 55e86e68-9e47-46ce-96ff-08deef2047a0
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|10067099003|11063799006|4143699003|6133799003|56012099006|18002099003|22082099003|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 sQBRm6t/LW3bcJ+VefWjBSyLNmTJs/Yu8lxFJYIx8MkdKJYvX9GcVhauye5H8ttBycoS46ifwJj9i4GlsO5rJIAMAa43pOrQ0eVVvYZRWkvT/vhQCpwA228megYTn/5afa+0FkqJDvw52PV7YaYGgSGTGzKLOr+mNU3ziwdHJTmn91c42yrVpKw4cbimDyQUAUB4B4P+JAFvqKVp6hav1zvcOu9SbGFm5yMFPoDklMQdldZf3AbyZWSvb1VoxwX29gzNEr/vAn9W6dbYf+hOZsGgaK1SBuMcXcWYLDAr3SoyIKe9UNDNX9c2n04nKUCZ9JMqiypDYjMTKqf7H6RbjUHZgoI6VViAmRHmH+/k8scL1hThnuhSDxIPe1Vngf6HdfypNDiyK64rhLSQl8wpxtlTu9eXl0RbFUka42Nnq/04g22ypsDoFGx744smMwuYc590ASmMMdV58N1N5+1Zj+CHmSSsh/fXK3e5Txt823wmu51J7zVxT/R82yscfT6E0uBsy7X5rXSuGyePF4om3YaVQTILc71qnsvjDbuBb1WU2Is4T46VPzia0rIJmsh2WS+cihRMyrtP71Hs+5k8wgGl6ktc/DFarfu9CQlfxf0c5mXqlSv++Whjwr6wkrFGNNqsx+oU5XBxagbvJYK9Ha0gSiXqyPNUlGnQA+h+HavHtAtSqVuMcrlT57UACITVK82fKv+dxTB5IQhz1KG4bOgILRGx9bxuFpQv5LwawuY=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB8421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(10067099003)(11063799006)(4143699003)(6133799003)(56012099006)(18002099003)(22082099003)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <C01F500CBACE0B469712DE99A1B77C4F@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 HFNrXc8chFoLwtOkE1Vqul8cxPnu4BrwoFz+Cu6UeB7C5yJVbqsAxe2zFw/NjTXr6FNG+ixdMxbWfdoFD73N0cuTUzfeRC97Zxh4UVjkEUJS0RmJkAs6bMUOl05n9fwPvFunQo9y6zAJZptToyVguB1dD6EpWKIjRmbgmRzs4Azx6YCyeduRPS9UyCVchhVFNIFJ31xIQqBoWbymmzVYWCY3PJn10FMT3xGhKIua9x4ArJq0DTktpJ1Cnn7Q0h618M49tiP03t2xdicJUqbokUoi8gjAGfBlT7tFOArxHd2NTyfi2IQ1ZpRR2p5atSjimEGCzW3kvqeLADbrJ7e6JQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: FRZPR08MB11047
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF00028D0D.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	b75d1f49-e9b3-419c-0bc4-08deef202269
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|23010399003|35042699022|36860700016|82310400026|1800799024|376014|56012099006|10067099003|18002099003|22082099003|6133799003|11063799006|4143699003;
X-Microsoft-Antispam-Message-Info:
	iiQ/lkTZgGtfHrcODpC2zZuxc3PpM9sX2FT6I0jJGNO8kmd8O74QW9k2BQQpMGnr2vUPPTDCnmXHJasf6IQSDBYcUsH5Djzh7OvLctWb8x3HmZ7K2jovwpTOufTPlpOO6pKbhYYB7UaQnT/avPoRUeqry1FQQLn4KasFYrvLQXcBazpgWvS5yCV3lRVooCazKAUYXx5jIVwzBkVN3/NPZTaff/QzVoDMEpY/RYZQ3w2/jjlOHw6U07JbdA7qpw3PC8H3zI5ApHHJzdYnM5BTimHrtcF9HJxPQKcACzYHrIEVF9ffheBxllPeqR36VWeufrYgwSrI+Xume7p8SAI+uOu+ne2rX9ItBYVeJW2sK0naZLmF30f3Is5BLLzNruP9gwiIoDadHW6yaI9hinFfqDhZM5t+p4Jk4Ddxl4tq1GxWVJdMDT9V609+6qhtyrch8fB+gYbta7GGxHdJ1gaAJVHXxcjEfovNfp5pBdtS5Sb7/ELcnTI/kZDA8+4G8+AHpIyifITsd9rYTEe6uhjTbSAM5sB/iVVrbMA2Tw0Xilb9oUxQTFFMNDAltFZ+NcxuPwYRkFwis6wwFHh4eIyBTb/QwGeO/HV1SZHgdQxlYu1pn6LjqPNBw3LnFfNLL/7fIkiL7MKDiPnJxmfP+pER88fK5fIyzpwmilVYD3OgkF4gmnaBOP8K7nEOndfH7CTjIqyHkJ50PwAAgj9TIDSs8w==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(23010399003)(35042699022)(36860700016)(82310400026)(1800799024)(376014)(56012099006)(10067099003)(18002099003)(22082099003)(6133799003)(11063799006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	ftVhz+J1nbKtES9H3rzogkhgTMHMOr3wqcJsZV0KzKEUoqa0DDpFAFhh6S7D/p5SjLZp96EwHVEDoYI1WgLE9A/y84ijzDx1BH1ePDhnifKB9FjA8DJRyC3V/kGkDMFMb5JePvPIDY23R3ydLlB1Kjo4JsmR/93VtnR+U28bpSj8QMUC5VORNPavOQisLbF1TYZ6ZsN3MIM7fklwvNengeHzlOtbuqICktsm+I6sV58eQEZvQQN5ogr7DwbW0hWrU3cCGhQsbm5oSDRcorDDB51BVov3M6RiRgNAUJ+cbuy8pxUF8IvgBRAEBaiCnhZqGMz5hci9EZkhyWZu//iFuVgrkXNx6j4D7adI0+Gj499rpAWLfFmf1+vBP1PlMhr7/3o9u3+D73S/T8m0cK5gDmq9T7CFgEQ4yBz3e7hN7GYPfxXYSfO2BJf4YgxKvS6t
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2026 16:25:05.1811
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 55e86e68-9e47-46ce-96ff-08deef2047a0
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF00028D0D.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB9659

T24gRnJpLCAyMDI2LTA3LTI0IGF0IDEyOjAyICswMDAwLCBzYXNoaWtvLWJvdEBrZXJuZWwub3Jn
IHdyb3RlOg0KPiBUaGFuayB5b3UgZm9yIHlvdXIgY29udHJpYnV0aW9uISBTYXNoaWtvIEFJIHJl
dmlldyBmb3VuZCAzIHBvdGVudGlhbA0KPiBpc3N1ZShzKSB0byBjb25zaWRlcjoNCj4gLSBbTWVk
aXVtXSBUaGUgcmV0dXJuIHZhbHVlIG9mIGBrdm1faGFzX2RldmljZV9hdHRyKClgIGlzIHNpbGVu
dGx5DQo+IGlnbm9yZWQsIHJlbmRlcmluZyB0aGUgYXR0cmlidXRlIGNoZWNrIGluZWZmZWN0aXZl
Lg0KPiAtIFtNZWRpdW1dIFRoZSB0ZXN0IGZvciBleGNlZWRpbmcgdGhlIG1heGltdW0gc3VwcG9y
dGVkIFNQSSBjb3VudA0KPiB1c2VzIGFuIHVuYWxpZ25lZCB2YWx1ZSwgZmFpbGluZyB0byBjb3Jy
ZWN0bHkgdmVyaWZ5IHRoZSBib3VuZHMNCj4gY2hlY2suDQo+IC0gW01lZGl1bV0gVGhlIHRlc3Qg
bWVhbnQgdG8gdmVyaWZ5IHRoYXQgYE5SX0lSUVNgIGlzIGltbXV0YWJsZSBhZnRlcg0KPiB0aGUg
Vk0gaGFzIHJ1biBpcyBkZWZlYXRlZCBieSBhbiBleHBsaWNpdCBgQ1RSTF9JTklUYCBjYWxsLg0K
PiAtLQ0KPiANCj4gLS0tIFBhdGNoIFs0MV06IFtQQVRDSCB2NCA0MS80OF0gS1ZNOiBzZWxmdGVz
dHM6IEFkZCBWR0lDdjUgTlJfSVJRUw0KPiBhdHRyaWJ1dGUgdGVzdHMgLS0tDQo+IGNvbW1pdCA0
YzIzNjRjNWUyODMzYzE5NjI5NzdkMmUyODA1Y2FmZTc2M2I0MjdkDQo+IEF1dGhvcjogU2FzY2hh
IEJpc2Nob2ZmIDxTYXNjaGEuQmlzY2hvZmZAYXJtLmNvbT4NCj4gDQo+IEtWTTogc2VsZnRlc3Rz
OiBBZGQgVkdJQ3Y1IE5SX0lSUVMgYXR0cmlidXRlIHRlc3RzDQo+IA0KPiBBZGQgY292ZXJhZ2Ug
Zm9yIHRoZSBWR0lDdjUgTlJfSVJRUyBhdHRyaWJ1dGUuIFZHSUN2NSBleHBvc2VzIGENCj4gdXNl
cnNwYWNlLXNlbGVjdGFibGUgU1BJIGNvdW50LCBhbmQgS1ZNIG11c3QgcmVqZWN0IHZhbHVlcyB0
aGF0DQo+IGNhbm5vdA0KPiBiZSByZXByZXNlbnRlZCBieSB0aGUgdmlydHVhbCBJUlMgb3IgdGhh
dCB3b3VsZCBjaGFuZ2UgdGhlIGludGVycnVwdA0KPiBsYXlvdXQgYWZ0ZXIgaXQgaGFzIGJlZW4g
Zml4ZWQuDQo+IA0KPiA+IGRpZmYgLS1naXQgYS90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9rdm0v
YXJtNjQvdmdpY192NS5jDQo+ID4gYi90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9rdm0vYXJtNjQv
dmdpY192NS5jDQo+ID4gaW5kZXggNTFlYTJmZTcxNDFhZC4uOTVkNzRmNTAxZWYwOSAxMDA2NDQN
Cj4gPiAtLS0gYS90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9rdm0vYXJtNjQvdmdpY192NS5jDQo+
ID4gKysrIGIvdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMva3ZtL2FybTY0L3ZnaWNfdjUuYw0KPiAN
Cj4gWyAuLi4gXQ0KPiANCj4gPiBAQCAtMTI1LDYwICsxODMsMTA2IEBAIHN0YXRpYyB2b2lkIHRl
c3RfdmdpY192NV9jcmVhdGUodm9pZCkNCj4gPiDCoAl2bV9naWNfZGVzdHJveSgmdik7DQo+ID4g
wqB9DQo+ID4gwqANCj4gPiAtc3RhdGljIHZvaWQgZ3Vlc3RfaXJxX2hhbmRsZXIoc3RydWN0IGV4
X3JlZ3MgKnJlZ3MpDQo+ID4gK3N0YXRpYyB2b2lkIHRlc3RfdmdpY192NV9ucl9pcnFzX2F0dHJz
KHZvaWQpDQo+ID4gwqB7DQo+ID4gLQlib29sIHZhbGlkOw0KPiA+IC0JdTMyIGh3aXJxOw0KPiA+
IC0JdTY0IGlhOw0KPiA+IC0Jc3RhdGljIGludCBjb3VudDsNCj4gPiAtDQo+ID4gLQkvKg0KPiA+
IC0JICogV2UgaGF2ZSBwZW5kaW5nIGludGVycnVwdHMuIFNob3VsZCBuZXZlciBhY3R1YWxseSBl
bnRlcg0KPiA+IFdGSQ0KPiA+IC0JICogaGVyZSENCj4gPiAtCSAqLw0KPiA+IC0Jd2ZpKCk7DQo+
ID4gLQlHVUVTVF9TWU5DKEdVRVNUX0NNRF9JU19BV0FLRSk7DQo+ID4gLQ0KPiA+IC0JaWEgPSBn
aWNyX2luc24oQ0RJQSk7DQo+ID4gLQl2YWxpZCA9IEdJQ1Y1X0dJQ1JfQ0RJQV9WQUxJRChpYSk7
DQo+ID4gLQ0KPiA+IC0JR1VFU1RfU1lOQyhHVUVTVF9DTURfSVJRX0NESUEpOw0KPiA+ICsJc3Ry
dWN0IGt2bV92Y3B1ICp2Y3B1Ow0KPiA+ICsJc3RydWN0IHZtX2dpYyB2Ow0KPiA+ICsJdWludDY0
X3QgYXR0cjsNCj4gPiArCXUzMiBucl9pcnFzOw0KPiA+ICsJaW50IHJldDsNCj4gPiDCoA0KPiA+
IC0JaWYgKCF2YWxpZCkNCj4gPiAtCQlyZXR1cm47DQo+ID4gKwl2LmdpY19kZXZfdHlwZSA9IEtW
TV9ERVZfVFlQRV9BUk1fVkdJQ19WNTsNCj4gPiArCXYudm0gPSBfX3ZtX2NyZWF0ZShWTV9TSEFQ
RV9ERUZBVUxULCBOUl9WQ1BVUywgMCk7DQo+ID4gKwl2LmdpY19mZCA9IGt2bV9jcmVhdGVfZGV2
aWNlKHYudm0sIHYuZ2ljX2Rldl90eXBlKTsNCj4gPiDCoA0KPiA+IC0JZ3NiX2FjaygpOw0KPiA+
IC0JaXNiKCk7DQo+ID4gKwkvKiBDaGVjayBleGlzdGluZyBncm91cC9hdHRyaWJ1dGUgKi8NCj4g
PiArCWt2bV9oYXNfZGV2aWNlX2F0dHIodi5naWNfZmQsDQo+ID4gS1ZNX0RFVl9BUk1fVkdJQ19H
UlBfTlJfSVJRUywgMCk7DQo+IA0KPiBbU2V2ZXJpdHk6IE1lZGl1bV0NCj4gSXMgdGhlIHJldHVy
biB2YWx1ZSBvZiBrdm1faGFzX2RldmljZV9hdHRyKCkgaW50ZW50aW9uYWxseSBpZ25vcmVkDQo+
IGhlcmU/DQoNClRoZXJlIGlzbid0IG9uZS4gVGhpcyByZXR1cm5zIHZvaWQuIFRoZXJlJ3MgYSBU
RVNUX0FTU0VSVCgpIGluIHRoYXQNCmZ1bmN0aW9uIHRoYXQgY2F0Y2hlcyB0aGUgaXNzdWUuDQoN
Cj4gDQo+IElmIHRoZSBhdHRyaWJ1dGUgaXMgbWlzc2luZywgdGhlIHRlc3Qgd2lsbCBwcm9jZWVk
IGFuZCBmYWlsIG9uDQo+IHN1YnNlcXVlbnQNCj4gb3BlcmF0aW9ucyByYXRoZXIgdGhhbiBjbGVh
bmx5IHNraXBwaW5nIG9yIHJlcG9ydGluZyB0aGUgbWlzc2luZw0KPiBhdHRyaWJ1dGUuDQo+IERv
ZXMgdGhpcyBjaGVjayBuZWVkIHRvIGJlIHdyYXBwZWQgaW4gYSBURVNUX1JFUVVJUkUoKSBvcg0K
PiBURVNUX0FTU0VSVCgpPw0KDQpBcyBJIHN0YXRlZCBhYm92ZSwgaXQgaXMhDQoNCj4gDQo+ID4g
Kw0KPiA+ICsJLyogQmVmb3JlIHVzZXJzcGFjZSBzZXRzIE5SX0lSUVMsIG5vIFNQSSBjb3VudCBo
YXMgYmVlbg0KPiA+IHNlbGVjdGVkLiAqLw0KPiA+ICsJbnJfaXJxcyA9IDB4YmFkOw0KPiANCj4g
WyAuLi4gXQ0KPiANCj4gPiArCS8qIE5vdCBhIG11bHRpcGxlIG9mIDMyICovDQo+ID4gKwlucl9p
cnFzID0gVkdJQ19WNV9ERUZBVUxUX05SX1NQSVMgKyAxOw0KPiA+ICsJcmV0ID0gX19rdm1fZGV2
aWNlX2F0dHJfc2V0KHYuZ2ljX2ZkLA0KPiA+IEtWTV9ERVZfQVJNX1ZHSUNfR1JQX05SX0lSUVMs
DQo+ID4gKwkJCQnCoMKgwqAgMCwgJm5yX2lycXMpOw0KPiA+ICsJVEVTVF9BU1NFUlQocmV0ICYm
IGVycm5vID09IEVJTlZBTCwgIkdJQ3Y1IE5SX0lSUVMgbm90IDMyLQ0KPiA+IGFsaWduZWQiKTsN
Cj4gPiArDQo+ID4gKwkvKiBMYXJnZXIgdGhhbiBLVk0ncyBzdXBwb3J0ZWQgVkdJQ3Y1IFNQSSBj
b3VudCAqLw0KPiA+ICsJbnJfaXJxcyA9IFZHSUNfVjVfTUFYX05SX1NQSVMgKyAxOw0KPiA+ICsJ
cmV0ID0gX19rdm1fZGV2aWNlX2F0dHJfc2V0KHYuZ2ljX2ZkLA0KPiA+IEtWTV9ERVZfQVJNX1ZH
SUNfR1JQX05SX0lSUVMsDQo+ID4gKwkJCQnCoMKgwqAgMCwgJm5yX2lycXMpOw0KPiA+ICsJVEVT
VF9BU1NFUlQocmV0ICYmIGVycm5vID09IEVJTlZBTCwgIkdJQ3Y1IE5SX0lSUVMgYWJvdmUNCj4g
PiBtYXhpbXVtIik7DQo+IA0KPiBbU2V2ZXJpdHk6IE1lZGl1bV0NCj4gV2lsbCB0aGlzIGNoZWNr
IGFjdHVhbGx5IHZlcmlmeSB0aGUgbWF4aW11bSBsaW1pdD8NCj4gDQo+IFNpbmNlIFZHSUNfVjVf
TUFYX05SX1NQSVMgKDY1NTM2KSArIDEgaXMgNjU1MzcsIHdoaWNoIGlzIG5vdCBhDQo+IG11bHRp
cGxlIG9mDQo+IDMyLCB0aGUga2VybmVsIHdpbGwgcmVqZWN0IGl0IHdpdGggRUlOVkFMIGR1ZSB0
byB0aGUgYWxpZ25tZW50DQo+IGNvbnN0cmFpbnQNCj4gYmVmb3JlIGl0IHJlYWNoZXMgdGhlIG1h
eGltdW0gU1BJIGxpbWl0IGNoZWNrLg0KPiANCj4gU2hvdWxkIHRoaXMgdGVzdCB1c2UgVkdJQ19W
NV9NQVhfTlJfU1BJUyArIDMyIHRvIGVuc3VyZSB3ZSB0ZXN0IHRoZQ0KPiB1cHBlcg0KPiBib3Vu
ZCBjaGVjayByYXRoZXIgdGhhbiB0cmlnZ2VyaW5nIHRoZSBhbGlnbm1lbnQgY2hlY2sgYWdhaW4/
DQoNCkkndmUgYWRkcmVzc2VkIHRoaXMgYXMgcGFydCBvZiByZWR1Y2luZyB0aGUgR0lDdjUgU1BJ
IGxpbWl0IHRvIDEwMjQuDQoNCj4gDQo+ID4gKw0KPiA+ICsJLyogVmFsaWQgY3VzdG9tIFNQSSBj
b3VudCAqLw0KPiA+ICsJbnJfaXJxcyA9IFZHSUNfVjVfREVGQVVMVF9OUl9TUElTICogMjsNCj4g
DQo+IFsgLi4uIF0NCj4gDQo+ID4gKwkvKiBOUl9JUlFTIG11c3QgcmVtYWluIGltbXV0YWJsZSBh
ZnRlciB0aGUgVk0gaGFzIHJ1bi4gKi8NCj4gPiArCXYudm0gPSBfX3ZtX2NyZWF0ZShWTV9TSEFQ
RV9ERUZBVUxULCBOUl9WQ1BVUywgMCk7DQo+ID4gKwl2LmdpY19mZCA9IGt2bV9jcmVhdGVfZGV2
aWNlKHYudm0sIHYuZ2ljX2Rldl90eXBlKTsNCj4gPiArCXZjcHUgPSB2bV92Y3B1X2FkZCh2LnZt
LCAwLCBndWVzdF9jb2RlKTsNCj4gPiDCoA0KPiA+IC0JZ2ljX2luc24oaHdpcnEsIENEREkpOw0K
PiA+IC0JZ2ljX2luc24oMCwgQ0RFT0kpOw0KPiA+ICsJYXR0ciA9IEdJQ1Y1X0lSU19DT05GSUdf
QkFTRV9HUEE7DQo+ID4gKwlrdm1fZGV2aWNlX2F0dHJfc2V0KHYuZ2ljX2ZkLCBLVk1fREVWX0FS
TV9WR0lDX0dSUF9BRERSLA0KPiA+ICsJCQnCoMKgwqAgS1ZNX1ZHSUNfVjVfQUREUl9UWVBFX0lS
UywgJmF0dHIpOw0KPiA+ICsJa3ZtX2RldmljZV9hdHRyX3NldCh2LmdpY19mZCwgS1ZNX0RFVl9B
Uk1fVkdJQ19HUlBfQ1RSTCwNCj4gPiArCQkJwqDCoMKgIEtWTV9ERVZfQVJNX1ZHSUNfQ1RSTF9J
TklULCBOVUxMKTsNCj4gPiDCoA0KPiA+IC0JR1VFU1RfU1lOQyhHVUVTVF9DTURfSVJRX0RJRU9J
KTsNCj4gPiArCXJldCA9IHJ1bl92Y3B1KHZjcHUpOw0KPiA+ICsJVEVTVF9BU1NFUlQoIXJldCwg
IkZhaWxlZCB0byBydW4gR0lDdjUgVk0gYmVmb3JlIE5SX0lSUVMNCj4gPiB0ZXN0Iik7DQo+IA0K
PiBbU2V2ZXJpdHk6IE1lZGl1bV0NCj4gRG9lcyB0aGlzIGV4cGxpY2l0IEtWTV9ERVZfQVJNX1ZH
SUNfQ1RSTF9JTklUIGNhbGwgZGVmZWF0IHRoZSBwdXJwb3NlDQo+IG9mDQo+IHRlc3RpbmcgaWYg
dGhlIGF0dHJpYnV0ZSBpcyBpbW11dGFibGUgYWZ0ZXIgdGhlIFZNIGhhcyBydW4/DQo+IA0KPiBU
aGUgcHJldmlvdXMgdGVzdCBibG9jayBhbHJlYWR5IHZlcmlmaWVzIHRoYXQgYW4gZXhwbGljaXQg
SU5JVCBsb2Nrcw0KPiB0aGUNCj4gTlJfSVJRUyBhdHRyaWJ1dGUuIEJ5IGNhbGxpbmcgaXQgaGVy
ZSBiZWZvcmUgcnVuX3ZjcHUoKSwgdGhlDQo+IHN1YnNlcXVlbnQNCj4gX19rdm1fZGV2aWNlX2F0
dHJfc2V0KCkgd2lsbCByZXR1cm4gRUJVU1kgc29sZWx5IGJlY2F1c2Ugb2YgdGhpcw0KPiBleHBs
aWNpdA0KPiBJTklULCBtYXNraW5nIHdoZXRoZXIgS1ZNX1JVTiBhY3R1YWxseSBpbXBsaWNpdGx5
IGxvY2tzIHRoZSBhdHRyaWJ1dGUNCj4gYXMNCj4gaW50ZW5kZWQuDQoNClRoaXMgdGVzdCBpcyBh
IGR1cGxpY2F0ZSBvZiB3aGF0IGhhcyBhbHJlYWR5IGJlZW4gdGVzdGVkLiBUaGVyZWZvcmUsDQpJ
J3ZlIGRyb3BwZWQgaXQuIEl0IGRpZG4ndCBhZGQgYW55dGhpbmcgdXNlZnVsLg0KDQo+IA0KPiA+
IMKgDQo+ID4gLQlpZiAoKytjb3VudCA+PSAyKQ0KPiA+IC0JCUdVRVNUX0RPTkUoKTsNCj4gPiAr
CW5yX2lycXMgPSBWR0lDX1Y1X0RFRkFVTFRfTlJfU1BJUyAqIDI7DQo+ID4gKwlyZXQgPSBfX2t2
bV9kZXZpY2VfYXR0cl9zZXQodi5naWNfZmQsDQo+ID4gS1ZNX0RFVl9BUk1fVkdJQ19HUlBfTlJf
SVJRUywNCj4gPiArCQkJCcKgwqDCoCAwLCAmbnJfaXJxcyk7DQo+ID4gKwlURVNUX0FTU0VSVChy
ZXQgJiYgZXJybm8gPT0gRUJVU1ksICJHSUN2NSBOUl9JUlFTIHNldA0KPiA+IGFmdGVyIHJ1biIp
Ow0KPiA+IMKgDQo+ID4gLQkvKiBBc2sgZm9yIHRoZSBuZXh0IGludGVycnVwdCB0byBiZSBpbmpl
Y3RlZCAqLw0KPiA+IC0JR1VFU1RfU1lOQyhHVUVTVF9DTURfSVNfUkVBRFkpOw0KPiA+IC19DQo+
ID4gKwl2bV9naWNfZGVzdHJveSgmdik7DQo+ID4gwqB9DQo+IA0KDQpUaGFua3MsDQpTYXNjaGEN
Cg==
