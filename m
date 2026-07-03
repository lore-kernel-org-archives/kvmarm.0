Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011062.outbound.protection.outlook.com [40.107.130.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 338FB242D97
	for <kvmarm@lists.linux.dev>; Fri,  3 Jul 2026 15:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.62
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783094335; cv=fail; b=ZGSxdSFaJOYW27Z6ExYqaUx95HQdhRsyCCSd6hd3wtdv1ehzsrUnzD0w2940T5IZLcKH+27JhZ0/YocssurYZMv21Py7KTE42CrNVH/7f1fLgzyVw18eMOVsMRFzEqIYulbNFZ4vwKxsvfiFwmQgOWwEfLoSfj3KAu3jLCYDUOg=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783094335; c=relaxed/simple;
	bh=Bcq8SmGe0EO385AHga83K3+0regTj9Ra8Q1+oE3pWYE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=pnx+U7amYczwXMN2CnhlPT0QNMaO7bvN/lSkT5wgdkTLLX1KD1qMi0MMdZ5I0zp2E1ChgiNiPSNRCQozNC41UD5tDH3+4n94S8Y7UPcHCkryd1P2XkYecN66LP9c63szuGrb4OA/uphl3P7xbJiYBbQzCfsQg7r+AJMs/f++lng=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=B16jiVpF; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=B16jiVpF; arc=fail smtp.client-ip=40.107.130.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="B16jiVpF";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="B16jiVpF"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=Od1+NrHOFb2SMj2KMWstX45L6HHeILEfQ2WesyTP/kOoXQ+iEzAEnDHQnawjpd1eJstki8v+RNPCAMraTAjvKMdm2f6qHAhJ41H+WpVcWPxcE2FKD5nnoAuE3rqHsJonWwwe8ycgayc2pXiJeELW7lotfA7kdMe38YWdx5dgh9+/IpYmYDXYep4NeHyvWdyM7Vcw1SFk/w5vH8foVKjccbk+Ivji5SJ998Gp62UJHVR7uC7TuYNen+K8lb/efOgqAJkN+8RN/jYRULv79lwviE2UC9NRLzL+ED1h1rt7W7FVCoaRcZvjpi+jAfe8Zux8VEXDKfYzr+1pa7YtfKVUZw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9hqS1c2v6uv7RXAUiriv+EnHWBDSgoTKsBsmLSILauM=;
 b=tY7yDm0mq6aHSAff8xE+qNi1Rai1edr7+Kd1nmfEw2MlZzX2AJcMnIn56mOIgFoHUN1qRFxiCECT3pw4tRNi3jO7felxZk90DxRGNOVO8ZTTZepcKugiw04Z09ZiuK1maz7T96aClrJ2LkybW1rZKt3J7Fs+yyST0rNwC4pwJ8u8WgttUhgzbCZxK3anJut9IssfjcvwUz3FrmA/87515jZ6hjF+Yk/v3JbxMD3+U4/JNKpoq5xTjEtfn/j062d2iP3B9JcZ/k68dBo2Ksdav9zbTePhA50fSAWO994wjJo57Z4zOzlP/FOp0dupXkd1LLNZCIXMME35ury6zaaYQg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9hqS1c2v6uv7RXAUiriv+EnHWBDSgoTKsBsmLSILauM=;
 b=B16jiVpFil2Kzcv8rvINrQP96E8FfFIZ55upDEQNCPoYI0XCqPwdN3s5SjaCACvoy5U9R5d7nuezbkQweWb3sQK33SBGT8/R1c9u+btN6FMhedSjBbJP2loI2WnMiMYKUPqQ7YEzwcVETyB/frloeaCreiov5cQ7SAw77MgZQgg=
Received: from AS4P189CA0028.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:5db::18)
 by VI0PR08MB10778.eurprd08.prod.outlook.com (2603:10a6:800:202::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.11; Fri, 3 Jul
 2026 15:58:46 +0000
Received: from AM3PEPF00009B9C.eurprd04.prod.outlook.com
 (2603:10a6:20b:5db:cafe::97) by AS4P189CA0028.outlook.office365.com
 (2603:10a6:20b:5db::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.11 via Frontend Transport; Fri, 3
 Jul 2026 15:58:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM3PEPF00009B9C.mail.protection.outlook.com (10.167.16.21) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.6
 via Frontend Transport; Fri, 3 Jul 2026 15:58:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UVbEtf4DMh4d3qA6yQkH3nQ0eRZp1U6LTsVwBB9RikDSGO5GsSFImrLDwUZMGoN3UgyYMTppaBuUD4BdK0r9LtOOFwPErbXjrK1fs/rPvWrQ2zsCTzqq5NxTpn5cOqc4jJytEESYvYGQ+CL61ITnL1srMD527+/zk5exnF4dtyczMVX7eEmL+mqMdKbWFWyOmt7ESGjdxn9osaCL6jHeSGwJnqXnnewxKZZoIar03YmyVysSbnlwIzZsu+i54ZHsA6Lo2fZGYK5qunHX3EUpksgeCB8CwLrVB+U+Ve2LCLLzwWbV1qMf3HlvWWH1K8NC/yDmjGr91AfHbaK+Ei4J1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9hqS1c2v6uv7RXAUiriv+EnHWBDSgoTKsBsmLSILauM=;
 b=d259XxA2mgdF6sfgqNR/dJ0VmZbR391uvpeVlaA/L3lAp774HY9KP+1Fvf9gyJ9l3890HxgSkKhb+/+5N/pBCxAhUIvmgFvxLZKSvW4jZ0MQErJ+vMAX1Ry+dCWHBdP8PrsgVQXxqCU6/AZpjz6G3JSYoxyFD/hzq2qC+F2d0FJL+SkEVybjcKyL2gEnl23wzPxsI8MUu8krwD9DtZ2Ff9aCqysuygsTHB0MpSCMsOYle5fTiS0zQ8jliXQUloNcY4cYvce8RgU9GeNeLgghIw9jgHDjnC/BdbQwmBCmsX8eIk2fu4DcXE9BMHYSSB1aSKv7T1XTMdSCYFfRebtmjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9hqS1c2v6uv7RXAUiriv+EnHWBDSgoTKsBsmLSILauM=;
 b=B16jiVpFil2Kzcv8rvINrQP96E8FfFIZ55upDEQNCPoYI0XCqPwdN3s5SjaCACvoy5U9R5d7nuezbkQweWb3sQK33SBGT8/R1c9u+btN6FMhedSjBbJP2loI2WnMiMYKUPqQ7YEzwcVETyB/frloeaCreiov5cQ7SAw77MgZQgg=
Received: from DU2PR08MB7310.eurprd08.prod.outlook.com (2603:10a6:10:2e5::5)
 by GV4PR08MB11250.eurprd08.prod.outlook.com (2603:10a6:150:2e9::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.11; Fri, 3 Jul
 2026 15:57:40 +0000
Received: from DU2PR08MB7310.eurprd08.prod.outlook.com
 ([fe80::e007:b494:8a24:1fc0]) by DU2PR08MB7310.eurprd08.prod.outlook.com
 ([fe80::e007:b494:8a24:1fc0%4]) with mapi id 15.21.0181.009; Fri, 3 Jul 2026
 15:57:40 +0000
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
Subject: [PATCH v3 14/40] KVM: arm64: gic-v5: Set up VMTEs and VPE doorbells
Thread-Topic: [PATCH v3 14/40] KVM: arm64: gic-v5: Set up VMTEs and VPE
 doorbells
Thread-Index: AQHdCwStHIcIR9elq0qvIufBD8MIyw==
Date: Fri, 3 Jul 2026 15:57:40 +0000
Message-ID: <20260703154811.3355680-15-sascha.bischoff@arm.com>
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
	DU2PR08MB7310:EE_|GV4PR08MB11250:EE_|AM3PEPF00009B9C:EE_|VI0PR08MB10778:EE_
X-MS-Office365-Filtering-Correlation-Id: 229fe556-eb53-4243-3a1f-08ded91bf690
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|38070700021|56012099006|11063799006|5023799004|6133799003|18002099003|3023799007|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 jXFDhQEPhnZUSfXKOjtmCt2z6GZXhlaTHyUpMcGWycw5rG5uReXx2yUfR4VCnBH9bV5jrRrJVvHSRTI/8UmQOlOaP/rBOaCiLzSYW6skuyN1hqKOwd9h4AFMnvkOA8bfy93Xs64ErzvpfEiCendqelH1+LY2uyc3xH7ADkOaC7ZL0VwCsRxSHgfcA3K1MNId6k9tbDJrpTxVUC8kcfcYJrcbwso0o5Hnzl4pJ1pplJCpABjtouw2/dFC5DPRauTRCy90gYkdYB+J+PwwCM4WOtdrsachbNZehpfss62VWbGLak2vcA309t8DS+IpSoRUALlI979ZQRV1psa6vcwT3ykNndePtdPU+Gwz9qcVMiRbNV6eudJE5GcB1w4N3Pcjws5mWgOh1FOZqpxbagqUbjGehUtHnG/8/ynmeXUNEHX+uFXwlNDFS/ZvVEcZIEvUBGbyG9Sy2LEo9xqua3RWDV5mWP4RE1F4rOWS8yd2pCI2sDNyzK04ipad3dycH0f8N95rOuWQRaKZ64lZWSZw1YyuRoLZ6PM+6kZFDkAdjDcwhDuzumHiDWS3wwQyX/dy6zzmG2J3uFIFNlOQrjHnV5cTNDymIQEO+tLabBziEZ22UFFvaBoMawZqq+m90JKQbmsPnYJhJnNLcOUfA3D5YEW5mxnA1ibUmwe7p6lznP2LNFOazotTIuOv8P1mSfmYW3o4qup5AAEBjmN3DMtnIR2UvxkUQFltmGuXCZac6II=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU2PR08MB7310.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(38070700021)(56012099006)(11063799006)(5023799004)(6133799003)(18002099003)(3023799007)(22082099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 XjgqLK01GrMu6WylNbj5UDK3RFXz1CzLrOZgUkrNzBpiN73/wMInhctf0HSnxxdS4/1vFoyxoUaYijzD7nDiJkBpgzLbqfGzYXXU7vp4xawbAbGGi/WDuuYGjFk5DqDrjyhTsYTZksk3q3L/hhcrehIkCpPrJcoVjl15IiEPnmsgAhZeKCzLacQtunvFJgAcMRTSkEN8UGRPBkQJSvNg0/jsygKzuo++6Ok6Vo3k06I6p3mF/YMQYv2f1oX6d7F7xP+5rnGCH8cir+fDtfMZp40Ndxtq2zv99DmtbLFtl/fn/dGU8XONxnZzGKZ+0TFJaD4776dSCRM2fK3vkIfuLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV4PR08MB11250
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM3PEPF00009B9C.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	110d7452-7120-4c98-1dbb-08ded91bcfce
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700016|1800799024|35042699022|14060799003|23010399003|82310400026|11063799006|5023799004|56012099006|3023799007|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	plzY5d53STV98G0txW3dUCFhf/zgHHilhe6Clh+gxESioimMptf+KfZAWpT8tpWbBTu2w+Hs1mAaDo595h4MojdzB6WRVXb6XbNGOkUBxUpr9dYy5Mu3nuGxOEcBZMTcqExVkxkUFiL2jzWyjqJsgIUIgxm87s9uI0T/tFLYG6KcRJxO6r4zokuopwIq//qGbT9WPyu9qGme4h68CJYDdLyhFq0WjtWMWpZ1kROKWreShABTEr6JX2ul3ORLPNAB86Fd7JuU6FF4t7C8ofqNgGzidGXZrCNNVl+pStXwmzV5BTk5hNenh48+/GpmeLEpUQlZ4SaNIqCN9Uzg+3ii/hDZGiUrksinXK715THsF+wyw+uK2wLuBHVCOWZc/K8Cof4+BFARPRAVlUka+9QhxeVPtThrHsBRGKmgpccgiL6D3StbQ0k0KGU+fexBplGIecDopy3FkZpkhn5f2v5sWzTnNpDX5gpVsX11vklbYQD73rKz1aC/pAlphPPGkQfdVmuwmoxyjAyOaCVIF8GFwY+cBrkZXwijNyQK+UJ5/qQyXFGtt3rR0zaZgeEdOsIwzplSLgehDcP8Od0v0BLzSl0tEQREo/zBprpkfp8xfoIc/tAN6b2vN0kq4Xrrbc/J2FQWgzvkCENas/pan44zXl3UoXv7sYBU4/NHolmKE5f2Ls8Ai7+SaEI9v6uO2NZ1C+69lo4fR7pM5N/95kBQAA==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(36860700016)(1800799024)(35042699022)(14060799003)(23010399003)(82310400026)(11063799006)(5023799004)(56012099006)(3023799007)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	U7bCgj/shE2AerQONflsb37vkxFd1JakyEKwmRXWloEz3v+bYkVACNTu4YjozbP9PNwZB3ewhnZ9V/3d3bvG78k+pNLZueAMA0b304HqOOR8HEQ47zZHy92vBbwY9T9pz3JpBHrlSuyMiDm3868wQZJPLD0qq0isnc7RlhDi1v8zoTfvVOX6flJWKUiOy7HbKV6T3x83FDAu8mSD34nOJfhDCocVynjoNmI1L4Qb0j+F1KhD4Ew1+obVMIhmPNYDDN3ny0N6riOYJj8qSExd8v2+k6LzPRL3pStP2DiyiLcZ6qEBysWeHoRCQBsh7twAYcf/Ym/YOBoAsb/1J+KlESDhSxMyTr1rcOlFqlV3oPxUIVuBGzveBZfy7W+utjUlpddhjnkH46Tw/b0EcoPYZqE7c/qr1jnPziO+b9pHZvEZHgd+M/+m5agcaraA2EwW
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2026 15:58:45.6217
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 229fe556-eb53-4243-3a1f-08ded91bf690
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM3PEPF00009B9C.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR08MB10778

A GICv5 VM needs a VM table entry before it can use SPIs and LPIs,
which are backed by the host IRS. The VM table itself is created at
probe time, but each VM still needs to claim and populate one VMTE
before it can use those interrupts.

Allocate a VM ID during vgic_v5_init(). The VM ID is also the index
into the VM table, so allocating it selects the VMTE slot that will be
used for the lifetime of the VM.

Create a per-VM VPE doorbell irq domain, allocate one doorbell
interrupt per vcpu, request the interrupts, and keep the doorbell IRQ
number in the vcpu's GICv5 state. The doorbell handler itself marks
the VPE doorbell as fired, raises KVM_REQ_IRQ_PENDING, and kicks the
target vcpu so that KVM can re-evaluate pending interrupt state.

With the VM ID and doorbells in place, initialise the VMTE backing
state, including the VM descriptor and VPE table. The doorbells have
to exist before making the VMTE valid, as they provide the IRQ-side
conduit used by the IRS commands. Make the VMTE valid via the IRS,
then allocate the VPE state for each vcpu.

Add vgic_v5_teardown() to unwind the state in the reverse order. Make
the VMTE invalid, free the VPE state, release the VMTE backing state,
free the doorbell IRQs and irq domain, and finally release the VM ID
so that the VMTE slot can be reused by a later VM.

On init failure, call the same teardown path so that partially created
state is unwound consistently.

As part of resetting VCPUs mark them as valid in the VM VPE
Table. This informs the IRS that a specific VPE may be made resident,
and without this the IRS will treat the VPE as invalid.

Also introduce a wrapper around the VPE doorbells -
vgic_v5_send_command(). This takes a struct kvm_vcpu pointer, and the
command to run, and triggers the function bound to the command via
that vcpu's doorbell. This is a convenience function to simplify the
code.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-v5.c | 165 +++++++++++++++++++++++++++++++---
 1 file changed, 155 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 6d7d9e6ed9dbf..f1cc36696669d 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -405,6 +405,23 @@ static int vgic_v5_irs_set_up_vpe(u16 vm_id, u16 vpe_i=
d,
 	return 0;
 }
=20
+static irqreturn_t db_handler(int irq, void *data)
+{
+	struct kvm_vcpu *vcpu =3D data;
+
+	WRITE_ONCE(vcpu->arch.vgic_cpu.vgic_v5.gicv5_vpe.db_fired, true);
+
+	kvm_make_request(KVM_REQ_IRQ_PENDING, vcpu);
+	kvm_vcpu_kick(vcpu);
+
+	return IRQ_HANDLED;
+}
+
+static int vgic_v5_send_command(struct kvm_vcpu *vcpu, enum gicv5_vcpu_cmd=
 cmd)
+{
+	return irq_set_vcpu_affinity(vgic_v5_vpe_db(vcpu), &cmd);
+}
+
 static int vgic_v5_db_set_vcpu_affinity(struct irq_data *data, void *vcpu_=
info)
 {
 	struct vgic_v5_vm *vm =3D data->domain->host_data;
@@ -579,33 +596,112 @@ void vgic_v5_reset(struct kvm_vcpu *vcpu)
 	 * CPUIF (but potentially fewer in the IRS).
 	 */
 	vcpu->arch.vgic_cpu.num_pri_bits =3D 5;
+
+	/* Make the VPE valid in the VPET */
+	if (WARN_ON(vgic_v5_send_command(vcpu, VPE_MAKE_VALID)))
+		return;
+}
+
+static void vgic_v5_free_doorbells(struct kvm *kvm, unsigned int nr_dbs)
+{
+	struct vgic_v5_vm *vm =3D &kvm->arch.vgic.gicv5_vm;
+	struct kvm_vcpu *vcpu;
+	unsigned long i;
+	int db;
+
+	for (i =3D 0; i < nr_dbs; i++) {
+		vcpu =3D kvm_get_vcpu(kvm, i);
+		db =3D vgic_v5_vpe_db(vcpu);
+		if (!db)
+			continue;
+
+		free_irq(db, vcpu);
+		vcpu->arch.vgic_cpu.vgic_v5.gicv5_vpe.db =3D 0;
+	}
+
+	if (vm->vpe_db_base) {
+		irq_domain_free_irqs(vm->vpe_db_base,
+				     atomic_read(&kvm->online_vcpus));
+		vm->vpe_db_base =3D 0;
+	}
 }
=20
 void vgic_v5_teardown(struct kvm *kvm)
 {
+	struct vgic_dist *dist =3D &kvm->arch.vgic;
+	struct kvm_vcpu *vcpu, *vcpu0;
+	unsigned long i;
+	int rc;
+
+	/*
+	 * If the VM's ID isn't valid, then we either failed init very early or
+	 * we've been called a second time. Nothing to do here in either case.
+	 */
+	if (kvm->arch.vgic.gicv5_vm.vm_id =3D=3D VGIC_V5_VM_ID_INVAL)
+		return;
+
+	if (kvm->arch.vgic.gicv5_vm.vmte_allocated) {
+		/* Make the VM invalid  */
+		vcpu0 =3D kvm_get_vcpu(kvm, 0);
+		rc =3D vgic_v5_send_command(vcpu0, VMTE_MAKE_INVALID);
+		if (rc) {
+			kvm_err("could not make VMTE invalid\n");
+			return;
+		}
+
+		kvm_for_each_vcpu(i, vcpu, kvm) {
+			if (vgic_v5_vmte_free_vpe(vcpu))
+				kvm_err("Failed to free VPE\n");
+		}
+
+		if (vgic_v5_vmte_release(kvm)) {
+			kvm_err("Failed to release VM 0x%x\n", dist->gicv5_vm.vm_id);
+			return;
+		}
+	}
+
+	vgic_v5_free_doorbells(kvm, atomic_read(&kvm->online_vcpus));
+
 	vgic_v5_teardown_per_vm_domain(&kvm->arch.vgic.gicv5_vm);
+
+	/*
+	 * We only release the VM ID itself if we didn't fail earlier. It does
+	 * mean that we might lose the VM ID (and associated VMTE, etc), but
+	 * given that we've failed to tear them down correctly there's no way to
+	 * safely reuse them. The VM ID allocating IDA will make sure we don't
+	 * accidentally reuse this partially torn down state.
+	 */
+	vgic_v5_release_vm_id(kvm);
 }
=20
+/*
+ * Claim and populate a VMTE (optionally making a new L2 VMT valid), creat=
e VPE
+ * doorbells, allocate VPET and populate for each VPE.
+ *
+ * Note: We do need to put the cart before the horse here. The VPE doorbel=
ls are
+ * our conduit for communication with the IRS, which means we need to have=
 those
+ * before making the VMTE valid.
+ *
+ * On failure, we clean up in the teardown path (vgic_v5_teardown()).
+ */
 int vgic_v5_init(struct kvm *kvm)
 {
-	struct kvm_vcpu *vcpu;
-	unsigned long idx;
-	int ret;
+	struct kvm_vcpu *vcpu, *vcpu0;
+	int nr_vcpus, ret =3D 0;
+	unsigned int db_virq;
+	unsigned long i;
=20
-	if (vgic_initialized(kvm))
-		return 0;
+	nr_vcpus =3D atomic_read(&kvm->online_vcpus);
+	if (nr_vcpus =3D=3D 0)
+		return -ENODEV;
=20
-	kvm_for_each_vcpu(idx, vcpu, kvm) {
+	kvm_for_each_vcpu(i, vcpu, kvm) {
 		if (vcpu_has_nv(vcpu)) {
 			kvm_err("Nested GICv5 VMs are currently unsupported\n");
 			return -EINVAL;
 		}
 	}
=20
-	ret =3D vgic_v5_create_per_vm_domain(kvm);
-	if (ret)
-		return ret;
-
 	/* We only allow userspace to drive the SW_PPI, if it is implemented. */
 	bitmap_zero(kvm->arch.vgic.gicv5_vm.userspace_ppis,
 		    VGIC_V5_NR_PRIVATE_IRQS);
@@ -614,7 +710,56 @@ int vgic_v5_init(struct kvm *kvm)
 		   kvm->arch.vgic.gicv5_vm.userspace_ppis,
 		   ppi_caps.impl_ppi_mask, VGIC_V5_NR_PRIVATE_IRQS);
=20
+	ret =3D vgic_v5_allocate_vm_id(kvm);
+	if (ret)
+		return ret;
+
+	ret =3D vgic_v5_create_per_vm_domain(kvm);
+	if (ret)
+		goto err;
+
+	db_virq =3D kvm->arch.vgic.gicv5_vm.vpe_db_base;
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		ret =3D request_irq(db_virq + i, db_handler, 0, "vcpu", vcpu);
+		if (ret)
+			goto err;
+
+		/* Stash it with the VCPU for easy retrieval */
+		vcpu->arch.vgic_cpu.vgic_v5.gicv5_vpe.db =3D db_virq + i;
+	}
+
+	/* Populate VMTE (with VPET and VM descriptor) */
+	ret =3D vgic_v5_vmte_init(kvm);
+	if (ret)
+		goto err;
+
+	/* We pick the first vcpu to make the VMTE valid - any would do */
+	vcpu0 =3D kvm_get_vcpu(kvm, 0);
+	ret =3D vgic_v5_send_command(vcpu0, VMTE_MAKE_VALID);
+	if (ret)
+		goto err;
+
+	/* Loop over all VPEs, allocate/populate their data structures */
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		ret =3D vgic_v5_vmte_alloc_vpe(vcpu);
+		if (ret)
+			goto err;
+	}
+
 	return 0;
+
+err:
+	/*
+	 * Explicitly tear everything down on failure. The teardown function is
+	 * written to handle any partial state we might have, so we don't need
+	 * to do any clean-up first. Teardown will be called a second time on VM
+	 * destruction, but that's fine - it is better to leave things in a
+	 * clean state now, and doubly so because userspace could actually go
+	 * and retry init.
+	 */
+	vgic_v5_teardown(kvm);
+
+	return ret;
 }
=20
 int vgic_v5_map_resources(struct kvm *kvm)
--=20
2.34.1
