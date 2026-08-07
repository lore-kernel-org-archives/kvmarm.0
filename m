Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013034.outbound.protection.outlook.com [40.107.159.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72E4D1A9F97
	for <kvmarm@lists.linux.dev>; Fri,  7 Aug 2026 11:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.34
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786102113; cv=fail; b=n7d10p0LnjSlQ6gCqnEfizUTqE664MXXHb385WOuVSmPs1v6HHiTF2sIzOhgLpd+RoZn6duo6tqbb2qjQIKdkCS40DmA2vRzAEuSwEipFyQDQSIMtaUpjuORsI6sNPEqccZSm9w5dV2FGsdykNQxgpdxZ8VvesLIm16z1Q5zPyg=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786102113; c=relaxed/simple;
	bh=un/2OqLh9/Mv6Gmx/igK/pxuiEtSt+YJLoPHzDJVtdY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=dGJh3s94r90j5xtZnNGlZK80XBZiF4ZJf7Q3iB3pTQAQfJSxPDsdGtQ1XIQoWdmPyxMdj3OF1mJ5YT4fREggKWo2dLd3OsHsbD8xbMX8A4/xOVzfUHZzW0FcQ4StU8RtHi0h1VVilxAqOAB97DtBgcdxzWsiRV37gHC9YjnTW3k=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=cBDoZK1a; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=cBDoZK1a; arc=fail smtp.client-ip=40.107.159.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="cBDoZK1a";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="cBDoZK1a"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=PN+oq0MYtu3pEN7YO9ArHRmQMcEIS9ee7HPt9SetdKerlCPnN99zCAkZ/kSSR7jJA+ou2sneOt/9I7tOg3sQ9/3nucos+HIMRlM0LQc39V3hoEtodJvZM7A/uLSznXLjP5gpBbN42VAGaEBxdlu5Uvpph+sP3h38pzDlqtc02QuBTHTsuIK031OLt6Y4Tf86oJqoUH/PRCmjAFTPo2S8Up52AukGf8i0DV1laZfvMVsjWzOdUD+6VTAoe314x+UCyleJhJjeXByVsUU3Zfg5ZED2iWDgf2ypo9JyZD/e/cFUeCEZueOytuNzUDIDaV7s9R+Wui2zUyw0ed5uUgE8vA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ytNvkvRw5hgJ8Jlh409nWZS3UlvcCpTYN8E0wjkllKg=;
 b=p9io60pE47UmJDtCTIchg76WvUKF9UDX7IHlsOuAclahT8FRuGdFBxhTTsXJW+22jlIPklmkLB7GrvjZKcBugrTLTKe2723gZpTbzpnkxv3PrlTPpPRgFXfBeb9ThH+5sU2hJCYjjRQN/lfFtMcErT//Yke2oxpuvXa+axSSHepzYlbpd9lkDhGbYzB5YXgTG8rIOzdLLl4nlsZ7koayetxrmMewopGgFJVhLV6m4DxDARH6AL6PDmdlawSqUEYbtT9MJsEPhaFDyt1n4j4lmd1IDcemSOkTO6y4C5ARuiE7RXPQyR8dGUMb8ga1Wf5AxStiGAy4Fg1TiAEVuq1+qQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ytNvkvRw5hgJ8Jlh409nWZS3UlvcCpTYN8E0wjkllKg=;
 b=cBDoZK1aGzKI7l/tjPMhCJ++e9cLliTF9pOoiJ8S6KIhIYGM+KeGp9Shwfk6RMekqI0gPUMBHqTGljnCvWL6ANfLfOtLiAASOaQL1OVa/yRIeiFDU/M1wpnNM9pTL/j7lPmcBsDOZkdwZtLHu8lyFKd23oy2vUi6d0Ijl2c5lsg=
Received: from DUZPR01CA0014.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:3c3::7) by DU0PR08MB7810.eurprd08.prod.outlook.com
 (2603:10a6:10:3b6::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.22; Fri, 7 Aug
 2026 11:28:26 +0000
Received: from DU2PEPF00028D0F.eurprd03.prod.outlook.com
 (2603:10a6:10:3c3:cafe::18) by DUZPR01CA0014.outlook.office365.com
 (2603:10a6:10:3c3::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.23 via Frontend Transport; Fri, 7
 Aug 2026 11:28:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF00028D0F.mail.protection.outlook.com (10.167.242.23) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.8
 via Frontend Transport; Fri, 7 Aug 2026 11:28:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Xisn05BQeSh0rxeMcihZwQ6TCwU+p8c935IqpwGvlUQzs8sTWQBGTO4Cs6wbrBtIUgHNHuFofTqlLPW61QXt/vblFTxXGYqHKnDTvImQm9ut18rbgCNVQwRM586VZT2iEW4NHsq2xDJBz1LNGN4FlmMAy9TPK8V9Cn8duCt23WYDzDxMttHQwM81ei47VBwlFRc5AtLkz6FiX3hqDatdbhrbXmkqMzuOd4LCkpuStnSO0O9latHyJItIkMyNFVZzqyYc6oPMtpSrBOWb4zoysUD1RgaWHr9ECxJs/YzLpOsoL4vmRCjYF34+0crKNJ8p18nsdt1xWtIIfxAsvKHVkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ytNvkvRw5hgJ8Jlh409nWZS3UlvcCpTYN8E0wjkllKg=;
 b=FQuuIxyl42g4pfLVhfg4ARe4AcZlrZuZqXRoGViCBh2gvl6kuol8/x2muAzXYJDn/ZtKmbGe2mdM4znoekvNWVWbwHS9SOLR4APsPzCvQDcFQg5zUDtS4qB1B7LNi04d8h3NNyfnANNMsRvhnVKl8MjGSHaC6JIX+hcLc9F9ckTe0IftGW2cd88h8xJqYhi7/DK/wcIIu/RwaMhj5fknufDTFEL4AtFbsjczsZY9Bai69C7vEVgM9j8ikBgQysdzvHiHiuLLL/ViD7B7lhbP0qF04XzTbdQVpZPZhVDGOMkwRFzZpr9jQjB6e9AnS+DyZ0K9kBxPYHj5m3edA2n4Nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ytNvkvRw5hgJ8Jlh409nWZS3UlvcCpTYN8E0wjkllKg=;
 b=cBDoZK1aGzKI7l/tjPMhCJ++e9cLliTF9pOoiJ8S6KIhIYGM+KeGp9Shwfk6RMekqI0gPUMBHqTGljnCvWL6ANfLfOtLiAASOaQL1OVa/yRIeiFDU/M1wpnNM9pTL/j7lPmcBsDOZkdwZtLHu8lyFKd23oy2vUi6d0Ijl2c5lsg=
Received: from GV1PR08MB8428.eurprd08.prod.outlook.com (2603:10a6:150:81::5)
 by PAVPR08MB9724.eurprd08.prod.outlook.com (2603:10a6:102:31f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.20; Fri, 7 Aug
 2026 11:27:53 +0000
Received: from GV1PR08MB8428.eurprd08.prod.outlook.com
 ([fe80::9b97:c973:3308:5ba7]) by GV1PR08MB8428.eurprd08.prod.outlook.com
 ([fe80::9b97:c973:3308:5ba7%5]) with mapi id 15.21.0292.018; Fri, 7 Aug 2026
 11:27:52 +0000
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
Subject: [PATCH v5 30/49] KVM: arm64: gic-v5: Mask per-vCPU PPI state in
 vgic_v5_finalize_ppi_state()
Thread-Topic: [PATCH v5 30/49] KVM: arm64: gic-v5: Mask per-vCPU PPI state in
 vgic_v5_finalize_ppi_state()
Thread-Index: AQHdJl/Ia1aQCInCgE+Z9vwMbc83mg==
Date: Fri, 7 Aug 2026 11:27:52 +0000
Message-ID: <20260807111159.429128-31-sascha.bischoff@arm.com>
References: <20260807111159.429128-1-sascha.bischoff@arm.com>
In-Reply-To: <20260807111159.429128-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	GV1PR08MB8428:EE_|PAVPR08MB9724:EE_|DU2PEPF00028D0F:EE_|DU0PR08MB7810:EE_
X-MS-Office365-Filtering-Correlation-Id: b9c3cbbd-c41d-42aa-9af0-08def476ff30
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|23010399003|11063799006|56012099006|10067099003|6133799003|3023799007|18002099003|22082099003|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 8PqzPE9SFdpN/UMkfND+lYIC/e2Deb7Gub6Qj9cOdNb/6VnmI4qc/8c/ckZqyWwg9ZOlAx/DA8NaGlzi/7cKMjDMx8XecSSaMPIQ9WzM4hUV+qghJ5Xbnbm9YQYlhf1IVG/Gcqk5SGfz+37XYNpSByTVRBcH56OcYsoJsPJrf2+wLUH2aMV+GhOkHHmR1t0hBsK4mapcEEdYKPfyeyE3OlqPYkVYhkMUxuBtd/V3c5j9ivmxLcmUYXlRRxeLkKzNEIl3RLj7qWyNJ9Q4HzEBTxQ2WZjsUW23wqXpxrmSr5idND/IxWcduMHuish0EtnAfKlkXI1yN2QZkLYG6nIFh37RC+Yo0h0oILAH0lwDB4QYWHlPedJzBKrSN0J8i+jq2JI1BzMxEDPnyO+f/aokC9wNXVUasKh8LcxOFdRuVlv20liyPZMB6AKiE5ZRHGAlnGfjyvRV5CBcqFbJs73VGhUWPYZjm7S4W4O57U5naAPNaI82bgLFB6opE05dPkw0q5RFUo4jaqtSyAkXeBrN2TAxrFAa+JQW+gkok/rFrATZpyNYpu/Z5ZoatwuDfXmAPrSfC4bbzwR8YzL2iBNixo5i6Mm31yWX+Gc7MX93OBJ9yeM8OqjhXOo/eIEBwRX0QYi+LOmATd8lQXzsuYzHXjenH/Q0RR/Bf6EMuv4BKnPKuLBGKjxLiroHc8lzd5VLc2gB3PnGN6ilO1KqM/CrmHNVS5kbilt1/ZPE7bwnlrk=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB8428.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(23010399003)(11063799006)(56012099006)(10067099003)(6133799003)(3023799007)(18002099003)(22082099003)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 sek2o6H1wlyTJP2oGf05j6om6ltya2IILR+vLUOUlclhx4EXnpI+ky9X7g3GAoWJg1I9NND+G6Adgnf63gYflPManJ0NLDtaFGJGomiS/4rF1giiZAPxGkx4/E1rmGthIz47IYrsU+HAmaFo1MJ0ZavC5wrU/SJh6bVXZ7Txf+SqFnZtApIC/c2NYMLR6CRjDOIih9hNZax5tE7jUuta4PIuBaClRMD7MCbNJYADIvQrj3UBYEhnBxvRra5OpyG5Hvlonqlf6Q2ylRIg2SONuXTG9j4hmWnc1godGOYoCA3vKNY0q/T1cy4KvfAJZ9qKMYcJAcPVCevWddfcxJBRag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAVPR08MB9724
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF00028D0F.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	676199e4-dada-4f10-3f82-08def476eb75
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|82310400026|23010399003|14060799003|35042699022|36860700016|10067099003|11063799006|56012099006|6133799003|3023799007|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	vQ6fPxVDSj0OHPy0OYuI4yz/DlUh7F93E57rzA2QP/KAZhfbTMckiR4K/V7XiYdjDYMNTdGct+1+W+mCu3sIYApOpFn4zO/4expEBWglgNoQ7po/aahbmtxBYGPdjX1/T0GpDHV6jFa8i3+0VKC71unwFnUCk271UN83XKjoe4brestpw8qNIraaNLVkgp4RMjdoyzuOAzGnxbyQLTdb28WXadEhdNN0H5LSXHS0A9CLPjINqhRNlOZekhEY96GO8O4Bw93Dfuhx9VPGF4LJ/PICtbs//iRLPYpW9ENF9pueZZxWWZNhcu45TfyPG3SEcVw01yBxjYVELSovhxNtD7fZfVVW/Kv8DfWRpiyCaV3K1l6Gjsp5v3anybed5FR0W6tzAsLuGOj8LSGdVMHAKO+hIvlvIVYYtPWYqUp0NmRghfeVlwe32D4NwwjQW4xudLp7ZK2ZQjwDi6QJ+S4v7NJ5VGuV/WJ+ltD/wYuaMLy7+v+0GsMCTmV0DXwO9J042qoC+zhT4m89vzii1GukmtZCtZsfU9qO3Miyg98lSP/UrWxGY/SKF0aCUnXVah2nKsXlWSwZHW7PEhj1uSX3R7GuJujZUsGrMq6B2XQNp8CiAwMsP62JP0joquB4cSmAbrFgx8GiWTdlPghGiP2k3mbqc8bjb+LWfqTnegKtGr2yiNZCtaQtBJpMKrbMRT73Z93riHJP0iLaEmi1b+fw7g==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(82310400026)(23010399003)(14060799003)(35042699022)(36860700016)(10067099003)(11063799006)(56012099006)(6133799003)(3023799007)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	IyMHHDHesOklomZEJ4WKz8FNJmxhn6xyw8z0g3Op8oOF9t3bNo5LPzA/a8zeH4AeaunWaImEaKnTojQiV39kgzIk+hu9/QTktdUPiFbel716FC70Ghk9qIt85nN4AY6MnwLWdfRgrlqBKeRg7/h8+KwRzjThw5I4jEhJzSe3VOo92X2Qi34nRZ+lP1WyYoW9aSPOiwApAaF4H6LwVTeTrv4+9acumONVNXb+YumERjDVTJCbFJXfxmpiB4CZILSFmr6O2F43rNvEKGbBsqnMSzo9eqmdINUnZda3OAHkzBOHJNCpi9oP0sHSytNbl4S5pUCmscstehe0vVveQkFJTkFyH8Zb83dCYCSoAL0yqOvChYlibqKlHUudn2RZntPAbh/FO4x3337BeBnVY74oWo+hQfkV6AMi7veqoMzpOMOMmpLU8rMFXqNsulFq1yi2
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2026 11:28:25.6797
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b9c3cbbd-c41d-42aa-9af0-08def476ff30
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF00028D0F.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB7810

Only a subset of the possible PPIs are exposed to a guest when running
with a vGICv5. First of all, only the architected PPIs are considered
by KVM. Secondly, only a set of those is exposed to a guest: those
corresponding to devices that KVM emulates, such as the timers and
PMU, and the GICv5 SW_PPI.

The finalisation of exposed PPIs happens on first vCPU run, as this is
the first time when the full set of exposed devices is known. At this
stage a mask is calculated, and this mask is applied both to hide
non-exposed PPI state from the guest and to reduce overhead when
iterating over the PPIs.

While preparing userspace access to the GICv5 system registers, it
became apparent that restoring the GICv5 PPI registers can result in a
mismatch between the state supplied by userspace and the state KVM
intends to expose. Userspace can provide Enable, Active, and Pending
state for PPIs that KVM has chosen to hide from the guest.

Userspace must restore PPI state before any vCPU runs. The userspace
access path added subsequently enforces this ordering. Rework
vgic_v5_finalize_ppi_state() to calculate the mask of exposed PPIs and
clear any state belonging to non-exposed PPIs. This ensures that only
the state KVM intends to expose is visible to the guest.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/arm.c          |  2 +-
 arch/arm64/kvm/vgic/vgic-v5.c | 71 +++++++++++++++++++++++++----------
 include/kvm/arm_vgic.h        |  2 +-
 3 files changed, 53 insertions(+), 22 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 908a058314117..c56e2a007b2e7 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -974,7 +974,7 @@ int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
 			return ret;
 	}
=20
-	ret =3D vgic_v5_finalize_ppi_state(kvm);
+	ret =3D vgic_v5_finalize_ppi_state(vcpu);
 	if (ret)
 		return ret;
=20
diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 62e069c21367a..beabc5980b2c1 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -781,9 +781,10 @@ int vgic_v5_map_resources(struct kvm *kvm)
 	return 0;
 }
=20
-int vgic_v5_finalize_ppi_state(struct kvm *kvm)
+int vgic_v5_finalize_ppi_state(struct kvm_vcpu *vcpu)
 {
-	struct kvm_vcpu *vcpu0;
+	struct kvm *kvm	=3D vcpu->kvm;
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
 	int i;
=20
 	if (!vgic_is_v5(kvm))
@@ -792,35 +793,65 @@ int vgic_v5_finalize_ppi_state(struct kvm *kvm)
 	guard(mutex)(&kvm->arch.config_lock);
=20
 	/*
-	 * If SW_PPI has been advertised, then we know we already
-	 * initialised the whole thing, and we can return early. Yes,
-	 * this is pretty hackish as far as state tracking goes...
+	 * Discover the set of PPIs that are exposed to the guest once per VM.
+	 * Once known, apply that mask to each VCPU's restored PPI state as the
+	 * VCPUs are first run.
 	 */
-	if (test_bit(GICV5_ARCH_PPI_SW_PPI, kvm->arch.vgic.gicv5_vm.vgic_ppi_mask=
))
-		return 0;
-
-	/* The PPI state for all VCPUs should be the same. Pick the first. */
-	vcpu0 =3D kvm_get_vcpu(kvm, 0);
+	if (!test_bit(GICV5_ARCH_PPI_SW_PPI, kvm->arch.vgic.gicv5_vm.vgic_ppi_mas=
k)) {
+		bitmap_zero(kvm->arch.vgic.gicv5_vm.vgic_ppi_mask,
+			    VGIC_V5_NR_PRIVATE_IRQS);
+		bitmap_zero(kvm->arch.vgic.gicv5_vm.vgic_ppi_hmr,
+			    VGIC_V5_NR_PRIVATE_IRQS);
+
+		for_each_set_bit(i, ppi_caps.impl_ppi_mask, VGIC_V5_NR_PRIVATE_IRQS) {
+			const u32 intid =3D vgic_v5_make_ppi(i);
+			struct vgic_irq *irq;
+
+			irq =3D vgic_get_vcpu_irq(vcpu, intid);
+
+			/* Expose PPIs with an owner or the SW_PPI, only */
+			scoped_guard(raw_spinlock_irqsave, &irq->irq_lock) {
+				if (irq->owner || i =3D=3D GICV5_ARCH_PPI_SW_PPI) {
+					__set_bit(i, kvm->arch.vgic.gicv5_vm.vgic_ppi_mask);
+					__assign_bit(i, kvm->arch.vgic.gicv5_vm.vgic_ppi_hmr,
+						     irq->config =3D=3D VGIC_CONFIG_LEVEL);
+				}
+			}
=20
-	bitmap_zero(kvm->arch.vgic.gicv5_vm.vgic_ppi_mask, VGIC_V5_NR_PRIVATE_IRQ=
S);
-	bitmap_zero(kvm->arch.vgic.gicv5_vm.vgic_ppi_hmr, VGIC_V5_NR_PRIVATE_IRQS=
);
+			vgic_put_irq(kvm, irq);
+		}
+	}
=20
-	for_each_set_bit(i, ppi_caps.impl_ppi_mask, VGIC_V5_NR_PRIVATE_IRQS) {
+	/*
+	 * Apply the mask to Enable, Active. Skip pending as that's calculated
+	 * on guest entry.
+	 */
+	bitmap_and(cpu_if->vgic_ppi_enabler, cpu_if->vgic_ppi_enabler,
+		   kvm->arch.vgic.gicv5_vm.vgic_ppi_mask, VGIC_V5_NR_PRIVATE_IRQS);
+	bitmap_and(cpu_if->vgic_ppi_activer, cpu_if->vgic_ppi_activer,
+		   kvm->arch.vgic.gicv5_vm.vgic_ppi_mask, VGIC_V5_NR_PRIVATE_IRQS);
+
+	/* Also update the vgic_irqs */
+	for (i =3D 0; i < VGIC_V5_NR_PRIVATE_IRQS; i++) {
+		bool visible =3D test_bit(i, kvm->arch.vgic.gicv5_vm.vgic_ppi_mask);
 		const u32 intid =3D vgic_v5_make_ppi(i);
 		struct vgic_irq *irq;
=20
-		irq =3D vgic_get_vcpu_irq(vcpu0, intid);
+		irq =3D vgic_get_vcpu_irq(vcpu, intid);
=20
-		/* Expose PPIs with an owner or the SW_PPI, only */
 		scoped_guard(raw_spinlock_irqsave, &irq->irq_lock) {
-			if (irq->owner || i =3D=3D GICV5_ARCH_PPI_SW_PPI) {
-				__set_bit(i, kvm->arch.vgic.gicv5_vm.vgic_ppi_mask);
-				__assign_bit(i, kvm->arch.vgic.gicv5_vm.vgic_ppi_hmr,
-					     irq->config =3D=3D VGIC_CONFIG_LEVEL);
+			if (!visible) {
+				irq->enabled =3D false;
+				irq->active =3D false;
+				irq->pending_latch =3D false;
+				irq->line_level =3D false;
+			} else {
+				irq->enabled =3D test_bit(i, cpu_if->vgic_ppi_enabler);
+				irq->active =3D test_bit(i, cpu_if->vgic_ppi_activer);
 			}
 		}
=20
-		vgic_put_irq(vcpu0->kvm, irq);
+		vgic_put_irq(kvm, irq);
 	}
=20
 	return 0;
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 9f16ee63d5763..b6526c678a5a2 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -823,7 +823,7 @@ static inline u32 vgic_v5_irs_max_vpes(const struct vgi=
c_v5_irs_caps *caps)
 	return BIT(FIELD_GET(GICV5_IRS_IDR4_VPE_ID_BITS, caps->idr4) + 1);
 }
=20
-int vgic_v5_finalize_ppi_state(struct kvm *kvm);
+int vgic_v5_finalize_ppi_state(struct kvm_vcpu *vcpu);
 bool vgic_v5_ppi_queue_irq_unlock(struct kvm *kvm, struct vgic_irq *irq,
 				  unsigned long flags);
 void vgic_v5_set_ppi_dvi(struct kvm_vcpu *vcpu, struct vgic_irq *irq, bool=
 dvi);
--=20
2.34.1
