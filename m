Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011059.outbound.protection.outlook.com [40.107.130.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB45B31AA9B
	for <kvmarm@lists.linux.dev>; Tue, 17 Mar 2026 11:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.59
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773747717; cv=fail; b=iTzpMu8+jz4KBOxbBbviBFAImx+ZGGDn1KEIhDz01c4fj1AMQh5rLrXyVCWArhs1JYQ/2YP/O2p7KGMLgfKDI6jR+KWSsqrE0l1Dl/jLJ0udgPb3PyQOv+UfHsKnYTE3uug0mI4PmHX8oBQ6+QFnC+qqvahhiBeL1mGv7DW4Sus=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773747717; c=relaxed/simple;
	bh=1e7Xvj+aAXy7J9FpXooY+XFx4p1K9wZDCJQM44D9bAE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=eH4dhYmHON5chpndFa9x2CQ3VZT22U7vjOV3JC0LBu2gHlxA0/pUghVb8oUobDks0EmVC7uWr14YIKYMsTG9Ps04ydhEZevdh26LEj7xVniooZnZKwhN+ro9fxEWVdWN2yOTTs44rwtGXpXTYcB52YSgUgeAKzcjG+mV8EE/uDA=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=UzntJ51+; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=UzntJ51+; arc=fail smtp.client-ip=40.107.130.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="UzntJ51+";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="UzntJ51+"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=I6LlfmJvWaT69atoRZMVHJnJkdWHw/+Pg40vKqJU51MFN6gB8qbOxSAwqCAHG+S9s6r892Vj7zmvTVuHWvgOWW7LinTsO6IvfU6I9t/9DE8gP0ireFxlN6hSM7dg8b0LMs/GCmIWAok+coGx1cbec4u0+LrC1Imn9vkMnWD5zl5iTmCK+1ryMkAnJBbNmg2oz/MTg2AXIuxy0c2dWxeKsuaah0bavklJmxtzAfRiw4oJD0S+hQCVnHbrZRkbGpCFacObXYDzGhMD7AFcJg19T+DJFORvMS/PxvbjuV3Ggw52Gstq88rkkClexAS7KDCYURa8EtDpc096iD9Sbn8Yyg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/PlNBb2+AbRPrmo3v/ZUNhccSo53iBZhuCnj2B5YQpw=;
 b=WcNKgFbV0OW0v1Xp/dOEP6YXCuCmaEWBcz7HMtSotMxpzR9QrrR+yqY4ZPniDsqEhoWo3+MlFkD/qv4YLP/yBx1TxoZr4QSJ06YF/wJw/LuzlZrt8uhT6humYV/hwzxdamTw0uD1O9qw1yx3Nq3NseDoq+/fjtnlJ7GBP7EmjoV7d/02qCe/DY32Xs0AkhsRZtpVXilLj1AfIDB3lVTD5tZuiC3Sx2ekgeac365dYJiFpQk7/D5HgLEhQPBZ4BE7Bia+GDYEabgsQbYMHqcScV7PheLThHwOhDODbegbN77E6tNHMVEpE4jKKAGpPEfB+xuSZkeWmb6qjI0NmK+mFQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/PlNBb2+AbRPrmo3v/ZUNhccSo53iBZhuCnj2B5YQpw=;
 b=UzntJ51+vimZoI8BiDv0BhnH0J9mgFw2HqIYCrYhLM0xbzCLQ+byKaKzoMTqmUqOVT93OTmraxCvsM0v9MD5EBCUTJvlI3hY867uKl9p6JuVvWVDx3JOjD51UaPIR/AEe3nyRvOoKPQobKr1aenTNLl+odqu2UMsN0pIiHzJnwI=
Received: from AS9PR05CA0139.eurprd05.prod.outlook.com (2603:10a6:20b:497::31)
 by VI0PR08MB11668.eurprd08.prod.outlook.com (2603:10a6:800:30c::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.22; Tue, 17 Mar
 2026 11:41:49 +0000
Received: from AM4PEPF00025F96.EURPRD83.prod.outlook.com
 (2603:10a6:20b:497:cafe::43) by AS9PR05CA0139.outlook.office365.com
 (2603:10a6:20b:497::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.25 via Frontend Transport; Tue,
 17 Mar 2026 11:41:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM4PEPF00025F96.mail.protection.outlook.com (10.167.16.5) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9745.0 via
 Frontend Transport; Tue, 17 Mar 2026 11:41:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JT34Zm9f1rMAtwK4XyYe2BCxrLPDY7IxHwUlu5y88Q7bZkssQWq/qeOY24qwyEpsTP253t8Ya2z7f60kDUbfwu2oA9hM/lnkx5BgkVguBnh/7YA5BMZ8sIqg1+oSv5okklBL8fOnXFsVndt0xfK2exXwCQ/WPo0de39t1lV6Ej7PVjD8y+8eKqK1vU+2Ck5vFyMabhAqvP1+QU+ACSNaMjkfU9aBk4etMl/VE+UiHfAq/nLXVj2KuyTakdPoTCZwbEsZ0ta0r/4kp+XxqPfdeLPyHxJSbvEOJuQOYre+gKZXlJKll5kyRRMsy2GTHBPb8C47Reb+FqGliq5TCd+u8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/PlNBb2+AbRPrmo3v/ZUNhccSo53iBZhuCnj2B5YQpw=;
 b=H+OUqmUwxXonBL50jQJbjc9QNPdzj9f1wdou6FBrc9oQG8QQ4XE08zIpfN7udoS/NE/n9S8KLoToFNnvPlKJxYcG/Oy18ckCUi5ViGmGpIrObqSMZu9ya188gWfDVTVJw8ORL1NSpFUuaoYjDQ/yTrhJ5/8SlmEFfO3pVgQMQOQ5UQ1rDw/pq17yU4cuFjiDYPUynbD7EsEbc5k+No5+C0rwVFO0z69m+4cD8JDQLb2uVTpplC30QiR4Xheff5fpaY10rJ6AaXhbQtSzZdOJqwiZZyjFSlu3rYmese+v9+I6pzHj/THKZDcq2r+ivjuOEU2hHPMyFn+QLMeYAwVbEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/PlNBb2+AbRPrmo3v/ZUNhccSo53iBZhuCnj2B5YQpw=;
 b=UzntJ51+vimZoI8BiDv0BhnH0J9mgFw2HqIYCrYhLM0xbzCLQ+byKaKzoMTqmUqOVT93OTmraxCvsM0v9MD5EBCUTJvlI3hY867uKl9p6JuVvWVDx3JOjD51UaPIR/AEe3nyRvOoKPQobKr1aenTNLl+odqu2UMsN0pIiHzJnwI=
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com (2603:10a6:20b:504::10)
 by VI1PR08MB10122.eurprd08.prod.outlook.com (2603:10a6:800:1c8::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.21; Tue, 17 Mar
 2026 11:40:44 +0000
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27]) by AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27%6]) with mapi id 15.20.9700.022; Tue, 17 Mar 2026
 11:40:44 +0000
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
Subject: [PATCH v6 03/39] KVM: arm64: Return early from
 kvm_finalize_sys_regs() if guest has run
Thread-Topic: [PATCH v6 03/39] KVM: arm64: Return early from
 kvm_finalize_sys_regs() if guest has run
Thread-Index: AQHctgLjp4iWVEuIGEy0s65+xvO5ow==
Date: Tue, 17 Mar 2026 11:40:44 +0000
Message-ID: <20260317113949.2548118-4-sascha.bischoff@arm.com>
References: <20260317113949.2548118-1-sascha.bischoff@arm.com>
In-Reply-To: <20260317113949.2548118-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS4PR08MB8241:EE_|VI1PR08MB10122:EE_|AM4PEPF00025F96:EE_|VI0PR08MB11668:EE_
X-MS-Office365-Filtering-Correlation-Id: f517babf-6dd9-4c17-e274-08de841a2ce5
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|38070700021|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 4aVisAVSVffKtxkT+hZhhP7x+cbujFUwCdTvggR8eISsU4/DkOV3LuG8yBVu+N1OZxN9xfpz4eqo+tFPqLIAXpALCG3u811dOlSgDCDfNL+hziAyXBqmIZBLGpit/KqwEqjM6f6nGgUtRvviezElZRtQZ3PBbSknG9PE0OItwjcRyYz5tMtn6qK0Ln4GI02+Hu4PiKJliSx/umTpSz+LvXU84DTSTzfwuuB5JDm9L6esa4DKQpxJ7PqQDKMgjXv+8IfzgAKuSBMdlCd/1RAPNZtSMlTYayxdsR6nXsGrmlgzadTxJBsuPeloM70Hk/bsgx8x/8UPM6zJgEXRRNBgUm2IGn62JhP+2rgxAW4ORCxYLVLAi7GE0i41A7GM0k/QlZ2W8O09tSNlE7PI9YL9R/P/fAg00PDDopj5v8caRI6bxAq+/ovChORthFax+FXmkiO5HXIM9tsFy/+9PZANckWdhdNXjVDYlHebp4m4TIeNWMrIMrEX9i+A6nUOOFNUWXfHJlF0MdxP1sFj4M+FRnm9lPM37c7B5ubcWNyXtbxWo9BGO8V/yD8bWKbOmvvd7fUpeqT40srpV+wwlzqMF/unCpy+h+ka0FqzPbb7Fmtcaft/fFpuLUHrvJD0q8BLqjgxQqjYVjVLDBN0LKB8BmFQPGMXdXxdVZyyFPPMen4YRua4nCSh3Z0Pgzw5BDx5wLpGol0+eDbn0JF3gp8/Cz07LtwEfMRamGfADrzDRj2XGGfidd44l9zAiz8nID0O2lszFJRPDS/z1P4iIYBeNFkmQNllTjxLfxGjiqz3F0Y=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS4PR08MB8241.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700021)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 XOxw14bIEDv5zOTIFKPqScoiVuGydnVIv97psqX6mYym1tCPHHYPNjiqYuQzM1jxq/D6HU91h7H7hWYp4GKQQBzeAjzRDfFBTo1IZf6LHYsBxjctE3ZwrySORFHEQwIpLK7TuWKDTYfiYqLRtETL5rmc1Afs5pid3L+KDHZp6G/tSx4dUiDVQtbyQxfAb8JL9aThQVPX8jtdqrCzRAA00KoEt0HwByGNc97lNLDe6bluoKuHdKSgIbE0dWebdEZaopgC4jL0oJMVxXu1WItnxT0ZLY0ZlwdVFbkIMfSlGI9WHyWBLQh0BcCP8pYkn8BP6pRCL4C59g4AR6ec8FoOqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB10122
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM4PEPF00025F96.EURPRD83.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	3ca36ace-f2e7-461b-8ae1-08de841a063b
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|36860700016|1800799024|82310400026|35042699022|376014|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	q9uAsejwJ1PEUNqzSpy5NyPW4etpOnQ340KdnAAsmltZbSaqOCoTVEtM8v9i1lqOGDKOuxTBgIwHlRH0S3kV5kGTo97aOTf8VO0t+xkw8fWIJc8VVtZMuTOBRL2/PdJzq1Dmo0Z7nJ8E0fZChPVQjIPpvW/x4nzp+ZXITaD4+6UZuVolRg3CqPx5Eyiw1BQNoNCB848kwpapUNE5LoY5MsNQTe7yxzdhdRphE97V/TjtffVI/XM19oJHT8oWM6X39A6KVg+ZTUNoxyLCMOO/3U4piOhBgiQThj1XEqi3SXCDCYYUJ3DLZCmlGDmfEmF1wb1+EHC25W7Eku0g4jf45dof8HYErz35v6Ct0RWo2vMQ2CcWZ5ahalcODvVm3sFPj0X0tnd6K2fvUQYMzVnTLiKlu55y8HmToJXDzLiXQ6zUdVldYSqVTSic1JaLWsfgg7mFmeEi6DAtC6DFhW0dfZ+1P2Drj+BxpvvXgtLOnm1tm5CM5+hs+tojNnogr4X6ke2JIvGiZJpWsIEIEtIA7YJIbvUw8oLDhssOq7YbPSQZ4WP+XjV8s96XWQnwIpTo/lw7P+k81ZexYNQy5Svbvn8H3FdvIpXa6gaK7bwY1guSRpjTAFbykNKZOW8PTG0bWAp1+KnBdr/xlsR7Lo84HcAO9EOD0MecoooXb1RSKg2RqqAALQLIMi1ZWgazs1IWOkxmPXRj11TDWLqIcnzRa2twvaQ8NWTMiYY8K2AtgdDAxWVM4LZUqJQuIR5QU8cnaSfmgYGMbxbHWTb4GTJo0g==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(36860700016)(1800799024)(82310400026)(35042699022)(376014)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	64JlhyiCrecT+KADbOjcP4PEYAAR3s9rmm8j3pMwT7RMaFO3BCda5978V89msWl/N6rrFy3fcD5xXyq5hKN8vzhsq+XUUEfL1Yv7m4O4Sd5Xok+d5u8OLJQWQVGrZ+XQqEBwxblqBromhhEOkzB5mL4WilpfPcUcmLQxJ28vVD4j0ipJLorYgzdauOWLw70lktkAwUHimtVXu+UKx7hgxBBBP6W5mk+cpPBNId5oUmt7gWp0MKTvDWKTg/CDv/TF9nhfQcp6n1EVlcxrFbjlwKID99+j3y2ehFvOHHjWkfTpwKqyZhk/AbRE7hxKVfkAdCrxeuol9s4fwWIZ3MlOoHweuQ5Qdg9yR5cNBCy3Cl5PxCDCu+aumFOSSokqlVKNEdliVqupFnvIFSkeT/jEbKUpYLYVlsGDjWPOu/O8k7NOF40jKTUjYOMNatrvK2u3
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2026 11:41:48.9446
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f517babf-6dd9-4c17-e274-08de841a2ce5
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM4PEPF00025F96.EURPRD83.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR08MB11668

If the guest has already run, we have no business finalizing the
system register state - it is too late. Therefore, check early and
bail if the VM has already run.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/sys_regs.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 0acd10e50aaba..42c84b7900ff5 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -5659,11 +5659,14 @@ int kvm_finalize_sys_regs(struct kvm_vcpu *vcpu)
=20
 	guard(mutex)(&kvm->arch.config_lock);
=20
+	if (kvm_vm_has_ran_once(kvm))
+		return 0;
+
 	/*
 	 * This hacks into the ID registers, so only perform it when the
 	 * first vcpu runs, or the kvm_set_vm_id_reg() helper will scream.
 	 */
-	if (!irqchip_in_kernel(kvm) && !kvm_vm_has_ran_once(kvm)) {
+	if (!irqchip_in_kernel(kvm)) {
 		u64 val;
=20
 		val =3D kvm_read_vm_id_reg(kvm, SYS_ID_AA64PFR0_EL1) & ~ID_AA64PFR0_EL1_=
GIC;
--=20
2.34.1
