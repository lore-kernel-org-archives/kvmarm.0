Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010059.outbound.protection.outlook.com [52.101.84.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63B104302F8
	for <kvmarm@lists.linux.dev>; Fri, 24 Jul 2026 10:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.59
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784890784; cv=fail; b=ICiCtypRyHw5wrxXvIhX1Scky8Lhzvvzq8ZICRc+JFvuWmwIy71j+omqRfLIxtoZ5sBvSblQW42KxOXGsNl3Wrg0Kh8xldcG2M0FZ/QPNGJ2LRQwMsOsctcqvY/ecPkxq0NvvQhIpwT2eLh3rGjxLM4Tj08arpQbkI7LEtKf6Cc=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784890784; c=relaxed/simple;
	bh=/25S7NPvpiVJRDXb4F60AX2lS5q5P5PhdeedgyTn45k=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=rGNF9K6hU5Zk/8/+0t5FrJbiNv0jJnzlJ5F+FRVR6PbfPkpSHhXjMsO/dLgJXJWcIN/L5UyW9NjvnrUukKw4Z8/BlEJlxqeeWaQlm9dg+C7Z9oeOX2qNIPGkjl9XrUYr+m1xSc7tKuTAg0M4OUe/RqZ0I0WemzIrDbcJRPryDYk=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Xu20EemL; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Xu20EemL; arc=fail smtp.client-ip=52.101.84.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Xu20EemL";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Xu20EemL"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=r/rnWYQJyWVouR+J0u/NV+FR3iCEYCqxhPmDUqpfQSKfrYI2JpZx4745/mR4KhogURpFvwLcEluDQNSSsivUdJtV8rpjjoKfKpVc0fEVtdJaEdjhT3pg06rcZ2swnKqKLF2oNSP/mRsk8zkB7eDpDh625Tjq1wlRXLJOH8Oik0vKcEp0zlEfAiGk76FoZ7mvhGs3fmRxA9jZaie0Ep5VZR6lTkvsRFfTisq4k6ZTZv7vaEBMb7L28pZA0hZ2u0Ul+/oMYF/Ato2PSeQtzNAMVAMh7krHJcdpEUHG+cmrMzqdujVsOSiFDauXbeNV2YYnoRUDYk46bhMlU18sMerkSQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QuEiNhsmn68TsAVPIuCk4w94QLQS7MHrdD4rRzBRjaE=;
 b=QcWyRfFScV8RX6gtcal1sajGq4LwLnIwefSHrS8797QeN3XVLf3QCX+PMnDKr8fJYlzCCcw7W2N3mC+i6bhdMoGKYDFq603DjHHrWkTPH5wtnKN7k8EreDNijG5x0A75VfqhelfR6AhTBF9nwzs+tOODnzXakgndGXgXuVhGrebrb5J5vjwe7reOVngz0mdxIRgCZixJY8qW3R0VRbImVIc8xv1oYrdDBbQRXiu1+hGp586scdYQN7rfiA4cLpmLqvMIX34/vNpevKdd+k+Spl5IbNLpUq0J7QSDdn+5g2930llTlbUCg3DXzv/sej1SH26NN6klv5P5sDqoQjHcFg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QuEiNhsmn68TsAVPIuCk4w94QLQS7MHrdD4rRzBRjaE=;
 b=Xu20EemLA7zdJzERqnzgAjlCdL/RyZx1RttByK636kHLyyDBv4mL1kDQgEc8KsBGd8ayQ7iDTMLlzpKHOWw4NPzcyDsUd3YzOWIH2gan3y7hfzEYxYtYWWYNHUnJolPxMMgusDgccuiC3t9g84MKjFH+mUg4cpCtFIRwASNwtLA=
Received: from AM9P193CA0001.EURP193.PROD.OUTLOOK.COM (2603:10a6:20b:21e::6)
 by DB3PR08MB9035.eurprd08.prod.outlook.com (2603:10a6:10:429::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Fri, 24 Jul
 2026 10:59:31 +0000
Received: from AMS0EPF000001AD.eurprd05.prod.outlook.com
 (2603:10a6:20b:21e:cafe::26) by AM9P193CA0001.outlook.office365.com
 (2603:10a6:20b:21e::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.10 via Frontend Transport; Fri,
 24 Jul 2026 10:59:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF000001AD.mail.protection.outlook.com (10.167.16.153) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.5
 via Frontend Transport; Fri, 24 Jul 2026 10:59:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=R+yyk8EYsHW09M5Mw4bhvwxCDuw+jhtGfr6FLqioeSE/cLSGvzwQkNMq4FZZ6yzVRYbFbmX4e4q878jzYqZSN/jVY0xRxY+g8uf8LpDEnMyFcdL7U6TucohipB0Ecde1G/77aiQqGAfQIAlVILDzdDZDEZ3qt20QmoS9fGefhINU94BMkugit3/cHEgCvNgkVN22Lkk42+15oKTqfN9dlbYRBgAPDq+oJK4PvKxcuEvfB+r+OWSwhEq1I35/uR3HuZkHHvfXozG8zG8Kvpw3xebVGErkCs9d+lG4Adkh5JWj/JQZjNtFdFnPvoGHrOLJ3nq5ZT5raXzBwFnI2TJ/Vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QuEiNhsmn68TsAVPIuCk4w94QLQS7MHrdD4rRzBRjaE=;
 b=LVsIRK2OsHH3MqJuSvAn2pCSkdsJRsmAdJcE2njmgXBVlR0eG7bshV517TnUPWSWY1FerQif0Kk+q8B2+RAP8RoDWxXW8D1YNbbAvAObM/lVOwPdx8BIgG8r8eFqNvV8BIXXzghYjTsciQ0sYgk+V/K0mSUaRh3Xc1d6d9Qo1hZLpV08222+acbd65brRGheu1G+o4sxyb05xMDP/y5K82D3frh85V1SJxsSyNOizWC6QUxidPK5Km1t/totUe+qHEX4I0tIa/SBOCtTDBHH4Rbri3GteHBdwANCDyzPvG49S8cIbIi/F4NSDfZlq0m/7dHrqg1BpSIn4rWIdX7uwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QuEiNhsmn68TsAVPIuCk4w94QLQS7MHrdD4rRzBRjaE=;
 b=Xu20EemLA7zdJzERqnzgAjlCdL/RyZx1RttByK636kHLyyDBv4mL1kDQgEc8KsBGd8ayQ7iDTMLlzpKHOWw4NPzcyDsUd3YzOWIH2gan3y7hfzEYxYtYWWYNHUnJolPxMMgusDgccuiC3t9g84MKjFH+mUg4cpCtFIRwASNwtLA=
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com (2603:10a6:10:407::19)
 by GV2PR08MB11279.eurprd08.prod.outlook.com (2603:10a6:150:2f0::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Fri, 24 Jul
 2026 10:58:28 +0000
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e]) by DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e%5]) with mapi id 15.21.0245.009; Fri, 24 Jul 2026
 10:58:28 +0000
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
Subject: [PATCH v4 39/48] Documentation: KVM: Add the VGICv5 IRS save/restore
 sequences
Thread-Topic: [PATCH v4 39/48] Documentation: KVM: Add the VGICv5 IRS
 save/restore sequences
Thread-Index: AQHdG1tbn7Irf8JYB0mOG3Cz+O7Zkw==
Date: Fri, 24 Jul 2026 10:58:28 +0000
Message-ID: <20260724104819.1296803-40-sascha.bischoff@arm.com>
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
	DU0PR08MB8421:EE_|GV2PR08MB11279:EE_|AMS0EPF000001AD:EE_|DB3PR08MB9035:EE_
X-MS-Office365-Filtering-Correlation-Id: 5f65d874-b639-45dd-7087-08dee972a355
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|22082099003|18002099003|56012099006|11063799006|38070700021|6133799003|10067099003;
X-Microsoft-Antispam-Message-Info-Original:
 Qwj+zkK1LJ96SDxD+2K+X2iRXovcH5Tho6L3AFE/QYiEa87BHHjWoTHgGBLYRxhMEOmzBlReOs/GuNzLMFhHQ1ebdCk8SDlzvcFGSe80fSHw5pF0LIEbxQqAuRvmaxiTVLPor1Lr5UNeh2Z/uGl2pNjQfjIJISORQNgU3HTZoPU+gLY+QlMo0jzxEZuAkWHURPNNYWQqj1pj0i3i10lPPv/RF2g3j1ORGY1aL3S1n4WdyPRHolx7RuEDstiwogLdq/GNtiW1Yh0BAn2+ztmktoW7+tL5UlxM9h9PsggpgMt8MMlwE9dXc49g+adh0e9cJAzJmjGWc0FW3eNwgYb2NZ3xGlnRjrBj4lD64BtQC124hE9/RcfMjgzU4cSmBHyYxFrqwAuU95OCAk5JVQiJJ2iC1qNJ9MbF/4zwDTxGukznuc+VJZZCukUrq2I8ZPGQZSyAOCT9gzIaK4MQnmR5dkIF92YRDrkg3SKCUYLdV/8cE1xt0vAJp5DSVt4PW4vwwA8dbqGi7d6plc5Xkgz6MzfneV9HgpS0tq4RgrTA1d5zBhQzjyqRl4qBlJEpG8Go4LNeV/dMVQrYtatzhPTYDc1pHqzOQSVc18aUGr6e/9g91z3WR1j9KfX9PfvmPtaG8kBs4+KxRnq/l3kO8kgxB38sklOLQJM4cLAbgXTpssikwNv/KdG6j11P33BMSZGfAMLA0z9ADVa+a9yeuKF6ZEupCSw+oG/cNeoXOvNWcbs=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB8421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(22082099003)(18002099003)(56012099006)(11063799006)(38070700021)(6133799003)(10067099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 LUmd/uqX/uOQz7Ze03D8VsWA7OPt0s8Sae+Br8eFq5t06tdB9trX0xbpffqrr6ZgxhsJS9knkAcsDGxWV8jZA8ehrD0n1YVrIyYPaBpEY3835YyMw43M8Lb4b3pHxRVrXwoU0cMHe7kiz0VwYzRgTDDOlSzKA1V79XPIhp9nLfVym6pEcnvNf3iAVXFz6Df3BcQ/WpkDG22nISThibp08poCpizPl7WFkr9GYbV/veCE/L/t8RZzD76lsseX4TAUooIJiDvJ/8cizeC1w6zBLHb+DJ5xgD3zjwFL+EK7RF+fngJjuzU5Nibj7egUPSF8brX/fqSvuJU1K3CcSSkytA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR08MB11279
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF000001AD.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	abe0fcb8-ee10-4ff5-7c2e-08dee9727dfd
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|82310400026|35042699022|1800799024|23010399003|36860700016|376014|56012099006|10067099003|11063799006|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	d80GFkeL3rsOcS5F6QLDWwhZ5Sb7FquEeOccdfabp8k4FVBNVnYeDhoScDtBCj8yfHFk73N25rP2CACAeThAiX4Xb2/cMurkEs+ax4ibovTxxDGcETO0vUmZN/29MzOt/0W6cg2cBHj+WRz/HYEvMidXW1ziGM9Jdb/avxXL/rukDeJgGUoBRc6jtAr8Ht4YsAIBUqfqfcKEQ25WO2ovc1gSvJVcfpeQU9C/ZUBr6OXX99OmuwACzKUsZ0vG6VKTxk6EpnsxYJ9tyHcTKnyC5jTuxatP2ii2C2ftrCLOPyxwNC7HJBiLGD/RMVQ4OcLJauJLsp1ySq0DXCcVe/edwJIOEsQRpg+B9kVZretCaD4pP0av5DssMDuQFld0D6A3xtYGb63v72SPvYvoG6iJEDL2fkh8XFAIvlYAcRT6G5/c6gnIhW6cFXYSO2mL52eBrtPNRXrNwVMIBrcdCxcHhLfkUHE78WuSR6E/Eo7zenza6Yqpc3gobqVpllcwdqw27grocTnJUq5/meC1j53PNz71LaOoXHe/FRdh6usyyu4+VkLMso8EME/5H/EUU1i+j2YZHaCoE3p9B00wTKDvtdDOKw9IBhxj90gZEpHEX67V5tWzuHCR6m2ONXGqMEwKCxQI8RzYE7LCDC5rQlbxCUMDylcsQ6i7YKTAtWoBJRwM91X3vZvRXBN7J7lFw2Ick7TnVKfUVthdlhO5nG4f+g==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(82310400026)(35042699022)(1800799024)(23010399003)(36860700016)(376014)(56012099006)(10067099003)(11063799006)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	wZ5jZ8CghyiyIx2wl8kjmgOfHoLLTKFXeVkDPJld2R2o4UFnuM9KzSBiYRMfzCXUpIYLofIF3kqCr2gxFrb056h3IHMCoCE/ADuimJEZvmClcZ5b/Cv8028/xdCPdOvAlHPw2NRGHv2vvNy/kTS+qPWVx1ZuFbfRL8OpGjt/VwOylcYHY8mWf8/TMZmHt5MnClc+cdmxLZM6Sz7+tcHfDl7t7AHrg9r7wT+t9alEJtxqiK8ICmieuusCPdeD498AOsn4BS6NdzRG6etWaI5I5QNgl7HhDND/ejbori4cN/qSCJtHedrSjE8gtNMp2jDbUwlUjqeiy7pqub5kyZ1EuNmTPmyJIMPgCj4fen/kIr0iIhR09HPFdg+vnHs9q4eeE/5T6DSKFCzK41upwbOnz8HwKo28gNEkAeJbPdcl7dx1c+jdwDt9Ll+OzlinenDH
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2026 10:59:30.8176
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f65d874-b639-45dd-7087-08dee972a355
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF000001AD.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR08MB9035

Document the ordering requirements for saving and restoring the GICv5
IRS state.

The IST state is exposed through KVM_DEV_ARM_VGIC_GRP_IST and is copied
to or from userspace-provided buffers. Saving the ISTs therefore does
not update guest memory, so userspace does not need to serialize guest
memory after saving the IST state.

On restore, userspace must create the vCPUs, configure the IRS address,
restore the number of SPIs, and initialize the VGIC before restoring IRS
state. The IRS MMIO registers may be restored in any order, but the
final IRS_IDR* state and the IRS_IST_CFGR/IRS_IST_BASER state that
describes any LPI IST must be restored before KVM_DEV_ARM_VGIC_GRP_IST.
KVM uses that state to validate the userspace IST buffers and allocate
any host LPI IST.

The IRS_*_STATUSR registers are observational state in KVM. Userspace
may save them for validation or debugging, but they are not required as
restore input and do not need to be replayed.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 .../virt/kvm/devices/arm-vgic-v5.rst          | 49 +++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/Documentation/virt/kvm/devices/arm-vgic-v5.rst b/Documentation=
/virt/kvm/devices/arm-vgic-v5.rst
index 318d9033ddb4f..6813051789ac4 100644
--- a/Documentation/virt/kvm/devices/arm-vgic-v5.rst
+++ b/Documentation/virt/kvm/devices/arm-vgic-v5.rst
@@ -255,3 +255,52 @@ KVM_DEV_ARM_VGIC_GRP_IRS_REGS
                    or tracking pending interrupts
       -ETIMEDOUT   An IRS save/VM operation timed out
       =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+IRS Save Sequence:
+------------------
+
+The following operations are required when saving the virtual GICv5 IRS:
+
+a) Save the ISTs by issuing KVM_GET_DEVICE_ATTR on KVM_DEV_ARM_VGIC_GRP_IS=
T.
+b) Save the IRS MMIO register state by issuing KVM_GET_DEVICE_ATTR on
+   KVM_DEV_ARM_VGIC_GRP_IRS_REGS.
+
+These two steps may be performed in either order. Saving the ISTs writes a=
ll
+IST state to userspace-provided buffers and does not update guest memory.
+
+IRS Restore Sequence:
+---------------------
+
+The following ordering must be followed when restoring the virtual GICv5 a=
nd
+IRS:
+
+a) Create vCPUs.
+b) Provide the IRS base address by issuing KVM_SET_DEVICE_ATTR on
+   KVM_DEV_ARM_VGIC_GRP_ADDR
+c) Restore the number of SPIs by issuing KVM_SET_DEVICE_ATTR on
+   KVM_DEV_ARM_VGIC_GRP_NR_IRQS.
+d) Initialise the GIC - this sets up the default state and creates the SPI
+   IST - by issuing KVM_SET_DEVICE_ATTR on KVM_DEV_ARM_VGIC_GRP_CTRL with
+   KVM_DEV_ARM_VGIC_CTRL_INIT
+e) Restore the IRS MMIO register state by issuing KVM_SET_DEVICE_ATTR on
+   KVM_DEV_ARM_VGIC_GRP_IRS_REGS. The IRS registers may be restored in any
+   order, but any IRS_IDR* state and the IRS_IST_CFGR/IRS_IST_BASER state
+   describing an LPI IST must be restored before restoring the ISTs. KVM u=
ses
+   the restored IRS_IST_CFGR and IRS_IST_BASER state to allocate the LPI I=
ST
+   during the following step.
+f) Restore the ISTs by issuing KVM_SET_DEVICE_ATTR on
+   KVM_DEV_ARM_VGIC_GRP_IST.
+
+The number of SPIs must be restored before VGIC initialization because
+initialization allocates the SPI state and fixes the SPI range exposed by =
the
+IRS ID registers.
+
+The IRS's MMIO registers must be restored prior to restoring the ISTs as t=
hese
+are used to convey the number of LPIs the guest has configured to KVM.
+
+The various ``*_STATUSR`` registers are observational state in the current=
 KVM
+implementation. Userspace may save them for validation or debugging purpos=
es,
+but they are not required as restore input and do not need to be replayed =
during
+restore.
+
+Then vCPUs can be started.
--=20
2.34.1
