Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011028.outbound.protection.outlook.com [52.101.70.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89EA4483BCD
	for <kvmarm@lists.linux.dev>; Fri,  4 Sep 2026 11:47:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.28
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788522461; cv=fail; b=O3hG6IdzE146fEsXq3SZ+c3w+wt+dLswYJ4jjKGIXgllo9Ki3NpKKYrUKokraSJIC/5RP95qq1mK90EMjA4RPcbLAuWDmReZWAk2AmJt7ut+TZfwg96YaoS9Rmuwlz23nQ1DXmp5C6mjrRYkCHP5BWxBIIL842Ov0aiDciwU7Cs=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788522461; c=relaxed/simple;
	bh=7YFgTfzT0SrwlWU1evkh7u24cQmxjjWVsXI+qiXtV6c=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=nxvrw+nZzhlu15J0SCtqtnoUUrlQ5+EKNnYbkHaZc6I2XENRAq6YKOXD4JvdlctkH0ReGHMQnDLO10OPRJmdG09R6QGdgrkT+ZDP+1AeCgOB3b7HiBK0cIV6mHG6SA7iEI4gDooOL8imETLvwkQEZ0w1xzYEU0GpmoVgkZYSkxo=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ml1bF2h2; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ml1bF2h2; arc=fail smtp.client-ip=52.101.70.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ml1bF2h2";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ml1bF2h2"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=lTRoiWc8CVf3ZlF/UnkAkZZmgHnQV196XLgusoXRDhWcnWkL07WGhYgPFTqLGPoyfnxXkbmePqFKYKLrJhqCkLDT4mFmfwzC5eUttG3qfjyow+2LY4z/WfS4vjN0fr+dXodLShnHYwMublmiLBfHGQVm8DXEuk0qicABQdEoNyLBiwhDv8Rcw1VDAI4G7LRKMFFaEp0cO2216Gx7If6ylNJqFqnY9ONdDL9zwKAdYdZfhGWwj1XlQTx/XrLQBVhv3gozgb2eTZkQFZo6Bu37w9hbrh8aWiRuI0vdnmWP3NWd1MfZBdvxZzhgqURcgka8Wg2DWdBnElxKEMPLG+6kiA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uTDihgOlVzgMS4bz/7uFY8Kz+y6JCWylFmdgHn4K4CA=;
 b=etsKtjMS5trNlut9MvxViKBK3AiTm9NHfa2bfVdASXJQTTi6B5GtwuIgQs/BrQtZR1mahGa1S8DrZVjvdd49eciomR4nZY98pGFxWupI2b20DOqCe/8FNJ08RMrLCaszmIj+8CTbhU4EPm04Rb274vsufK7cWmGal8lxQz4h9g1N6S3kKMiegHJ1RaGpaCqyitkBx/Ve5JwYw2B8t7ezeaSr4RjrYDsZKbp6VoXLO/YipnYWxPDo5KCcW0IJsr3+pXAjwm3a1wCWbIc3S01fZxJuQFRVaV9QlU+QEhUyKiaQqBJVgD60lr1nrJxaP7+DOHWwzAXI3NEJKpzzQ16d1Q==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uTDihgOlVzgMS4bz/7uFY8Kz+y6JCWylFmdgHn4K4CA=;
 b=ml1bF2h2OXoyA8np75z0DqhLJS4NtBa+cQ286H/9IgZv6IbCqV73Nl8NMyyFrvTQiaXEQh+xdt6amkKEnY9qDbdmqRGSviUTXnN6Z5HTdMkxTLF6tsbq0EeloK69dzRCDBIiWPWwkIhJTJAla2a8hTlfst2CadFBCZDGh/W/FxQ=
Received: from AM0PR02CA0159.eurprd02.prod.outlook.com (2603:10a6:20b:28d::26)
 by DBAPR08MB5653.eurprd08.prod.outlook.com (2603:10a6:10:1a9::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 11:47:33 +0000
Received: from AMS1EPF0000004C.eurprd04.prod.outlook.com
 (2603:10a6:20b:28d:cafe::77) by AM0PR02CA0159.outlook.office365.com
 (2603:10a6:20b:28d::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.11 via Frontend Transport; Fri, 4
 Sep 2026 11:47:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS1EPF0000004C.mail.protection.outlook.com (10.167.16.137) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.8
 via Frontend Transport; Fri, 4 Sep 2026 11:47:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F0C21tnZCNyiwgxnPAhNHyRalvHaRJngIFTMc7De4KZnIU0Y1qMGW/VYYxnEzGpVwK90lRX/f8mtcnxjqhgPuoIajUY7HVevAmSR6kYhHMtdkKdlVLJ/0SHsnAqxcB0AuxM5sPnHNy2ZKu1ryPCQ+CDhc6XWQJtX0209nwZieRReHt5piBVxCrsFX+oZYjsAZMAAXoIDevPNmvgXrLfptz3yTMwzXCltBBDt5KgnJ9G+IdsSI757hnwGleG0lhcAjjzaLIKoxhC7lrHi3gh5OwC0kIyZ41EgVm15TXFVj7ZivdEvrlAhZCbGgA0uie/1zSq5fZiNU/zCw/+7tSs3Xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uTDihgOlVzgMS4bz/7uFY8Kz+y6JCWylFmdgHn4K4CA=;
 b=IO05dVJ7jm/WUaBcOCixVUNA+loDjBD310CKPILzDQxyMirM8tpuZNA08ufakmL+D5jBnofmr/7Ny1rvMvQr2X7vdwgoJ27C2Q49NjQ/3AS68MzduvPF+s0BVVY3gGHQ2oN4JjkH+sDDKNUe32cejVw5tX0oTV01fJ4VxJGgD9nX8/fl1ulNuq6B21FVuSshy5RsNwSc/E7/GJzNEcvJCoYJVUjD4f2Rtf6X4AITFOjSFTOpl01+Yhn5A3IhlMp+rf7H12sfvJnauP7aKOW5YMKyM3WZo2lKvVHtp76GNfcEFaO7b2T3Ah9gcdnESnNSRNCUm77K3Fyfk2AB/U2k7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uTDihgOlVzgMS4bz/7uFY8Kz+y6JCWylFmdgHn4K4CA=;
 b=ml1bF2h2OXoyA8np75z0DqhLJS4NtBa+cQ286H/9IgZv6IbCqV73Nl8NMyyFrvTQiaXEQh+xdt6amkKEnY9qDbdmqRGSviUTXnN6Z5HTdMkxTLF6tsbq0EeloK69dzRCDBIiWPWwkIhJTJAla2a8hTlfst2CadFBCZDGh/W/FxQ=
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com (2603:10a6:101:1d::23)
 by PAWPR08MB10898.eurprd08.prod.outlook.com (2603:10a6:102:46f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 11:47:00 +0000
Received: from PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e]) by PR2PR08MB4889.eurprd08.prod.outlook.com
 ([fe80::8bda:5986:a1f1:cb7e%4]) with mapi id 15.21.0382.007; Fri, 4 Sep 2026
 11:46:58 +0000
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
Subject: [PATCH v6 25/49] KVM: arm64: gic-v5: Add GIC VDPEND hyp call
Thread-Topic: [PATCH v6 25/49] KVM: arm64: gic-v5: Add GIC VDPEND hyp call
Thread-Index: AQHdPGMXLobnrof05UiBmINCEgVuKg==
Date: Fri, 4 Sep 2026 11:46:57 +0000
Message-ID: <20260904113404.4051341-26-sascha.bischoff@arm.com>
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
	PR2PR08MB4889:EE_|PAWPR08MB10898:EE_|AMS1EPF0000004C:EE_|DBAPR08MB5653:EE_
X-MS-Office365-Filtering-Correlation-Id: 9c0e9c8d-2f8e-406c-d10d-08df0a7a4eb0
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|23010399003|10067099003|38070700021|11063799006|56012099006|3023799007|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 J+EP8soFRPymCrHxhMb3AxCN3iX7XgOYAGrVBwVorgpgE/k6+/iGqAuP3jwMv7ZLcByzmu/s8c4FOqrJxnUXa90CuSEk2BcqVZcrGVTNB5gtRGxBEB1Zrc8+c+uqZqyhX+f79RAXhk+9BS1Lw7WX23sJ73VK0l9VXcjbR5kATGnxheBwD4Zie98RDxWxW0sdAnlBOgnE1TZSlQ8HM/Qd/mak5lp1HdWsI0caPT+nbaraLM8uYrOFeOHr8ep/u2uPr0wvUZ4WwCPPM8Ez72aJC18u+25NgtMc53orENoX4VKBVfO8pB8sRi2wqCZS3MAqez2wxXoJnVciedTyvuqAjAqJ+M+n23t39C03OjXLFvCl2y1kPzQey5G6a56oAKt5A/hcRtpm9WXku5+wGPYneQtcShidWv8FB2DWDIZ4+Si1OmCK7MUnJ/pn2eueEt263njq5IWJjG/3NjZeGcIoH6S+ToI1vKM75svWMVl2wncIgJLKLDNb+3uz4zRjLR9VXcGHyMSAQoMxfDfJ5o03r4wqnjUvMmpn/bg2bk1jO8iyEeWU3K+9K/7h5/qnzixQI9vCuQy0sbLl54neFjnem+NmlF6Qhv2a2lgUJPgOE6TmEGAgioPAFYnJ9VEqCzROrL1aCkKdbBRecgnBjSvFCVQsijUTja8SfzsDq+yZuAljXDjT4sJD8zqW48aXucYaLTZOEzxSzlaVJAfh4J41xOTxTiUFowxvfg657ReQJn0=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR2PR08MB4889.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(23010399003)(10067099003)(38070700021)(11063799006)(56012099006)(3023799007)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 AP2KZFd2S7j1HqbY0+8TIfKAMkvmj8WJSNuaiy0VQ1r317A1SInlR3BlkZzjGq/Ze1Z/O8mPR7qkxIbQqQtXwPju0x+UJ0pnnNVthK5vpCIQVsHfPk/0Nhr8lOlfctb987lPMW7FKrwpr64/Aa9r5e17hu3a6edFah25KG4ZOnK17q0WoM7i34crRBM14JTew+zDe1F+eLqePjssoq5yPGv9obE95YtHfNfKSXTljISj9hsS30UxLdfYm+oGZelMlsWlMYocSH7jLlN56XddAl07y62dgWO8PKrFRyRvj32X6N+76gH5yZHowakq2Ib1xh5hjCjnO7dPpvftvKDfZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR08MB10898
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS1EPF0000004C.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	59c7c3f9-1f9b-4b6c-d8e0-08df0a7a39ad
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|35042699022|14060799003|23010399003|82310400026|36860700016|56012099006|10067099003|6133799003|11063799006|3023799007|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	R9QcQfztm7CFmL9LhN1E3+zMtL+taDOOMRpk1OyHw2IjZIkek5daCEAGdv5XTUzqmmNXjonQs8rD3j6V/FGuyKeGGHKZXZzaIBiUkkFdK7U0UrQlONo+jE8HWOM5g7Hh1QpCwVhJeTw36mw8E6/NdzBF+hOn8r+gls16GM/LckGYg0JhBzviOcQcBTp8kNNOepEcX3VUXLcUD9ArZ0K2XSuYxjSQGbUqR2exg1VjctP7qdNgLtWCKkhskOA7na0JE/xBw5DXkynxziwIAyKLgfevnPpMgD8TariTafI/nSwCvPJhQYtU331Zk5cCRYfjOjHuE7GAXQDDR9+jLOCvcw94paym+JAWed/6+cEbeoVMTJB9efD0KkFYsH3r62kI0jQ3+ixDzIHSjztDoU0ZcfDJ/44VRbDpWC8rbjO9d8ZOweyyxEW9aBU29snR6xIxr9cSbPM+cxaHl3HdxFh5o6J0uowC9AlMQ8OOk8stqjE45OlcdYOkx5Pho4LJe8Fi0nAEvYE9oSKH8ytVS3WYkwX3psIWW/Y0jbrh/UzoCphH3uf+W7H7wNSM2nFReFkTf8K6g2iE2TvM+EkbLr7Hhdb7XA2T5D/DoDaZmNlzZRk/pcgexAulvCCDVX+dTDgUc8Da2H/LjehFcRx4uw8BxAe9919g8/fIdzviNB10Ae4=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(35042699022)(14060799003)(23010399003)(82310400026)(36860700016)(56012099006)(10067099003)(6133799003)(11063799006)(3023799007)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	ckKk07k0JvO2GL9/fD8KILp63cKyy+2Y7e9npp4W6QsQaHwzIgR2gfGWIYr5DGFktRyWaZL/Gm2JeL5zNmDRcJsVj5g1kt3ChEGD7chhmQiNGfdex69N9aNs4jY9qY7vDbuECOTSpdOcDF0MomrjSBWr2ECY1kMUVch8IIOwkl/JQAG5CadpPy5XP8YEM9WNuRd+Qi5gI1xMxKVr4kLmdGyLcy7OBZW9QSVmceQQ7QGzpBVV0sA0DhGoBNppr3QexFi/MV7o+4kZ32ffOv3BxqjEccMSPtwjbR0ixQx2/Y8nDtjnP5qkvJOMi3JyLJ9Rjt2TsjgJTQc3lm92tJLLinyFJyZ/edENl0Hf/oa1KzUn5YGviHtku74lq+FpJW8mO4w2XgekM5kGznz1jDcg/SKHF2COqKI0jxvRhAbOcnQijne5ZUR/ffpQXUJ0wgrZ
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2026 11:47:33.1485
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c0e9c8d-2f8e-406c-d10d-08df0a7a4eb0
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS1EPF0000004C.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR08MB5653

With PPIs, their state is injected via the ICH_PPI_x_EL2 system
registers. For SPIs and LPIs, there are no such registers as these
would limit the number of interrupts significantly. Instead, SPI and
LPI pending state can be managed from the hypervisor using the GIC
VDPEND instruction. This provides a way to set an SPI or LPI for a VM
as pending or non-pending, i.e., to inject interrupts into a guest.

This system instruction is only executable from EL2, and therefore
must be wrapped in a hypercall for NVHE/hVHE configurations.

With pKVM this hypercall is explicitly a no-op as we currently don't
support the combination of GICv5 and pKVM.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/include/asm/kvm_asm.h   |  1 +
 arch/arm64/include/asm/kvm_hyp.h   |  1 +
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 13 +++++++++++++
 arch/arm64/kvm/hyp/vgic-v5-sr.c    | 10 ++++++++++
 4 files changed, 25 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_=
asm.h
index 55f7c5c74d1ab..bffdeb36da1d2 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -89,6 +89,7 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___vgic_v3_restore_vmcr_aprs,
 	__KVM_HOST_SMCCC_FUNC___vgic_v5_make_resident,
 	__KVM_HOST_SMCCC_FUNC___vgic_v5_make_non_resident,
+	__KVM_HOST_SMCCC_FUNC___vgic_v5_vdpend,
 	__KVM_HOST_SMCCC_FUNC___vgic_v5_save_apr,
 	__KVM_HOST_SMCCC_FUNC___vgic_v5_restore_vmcr_apr,
=20
diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_=
hyp.h
index 8fcbbff719cce..8e2f0280c0cc5 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -97,6 +97,7 @@ void __vgic_v5_save_ppi_state(struct vgic_v5_cpu_if *cpu_=
if);
 void __vgic_v5_restore_ppi_state(struct vgic_v5_cpu_if *cpu_if);
 void __vgic_v5_save_state(struct vgic_v5_cpu_if *cpu_if);
 void __vgic_v5_restore_state(struct vgic_v5_cpu_if *cpu_if);
+void __vgic_v5_vdpend(u32 intid, bool pending, u16 vm);
=20
 #ifdef __KVM_NVHE_HYPERVISOR__
 void __timer_enable_traps(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/h=
yp-main.c
index cd709eb426b5f..bb18c174b247f 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -919,6 +919,18 @@ static void handle___vgic_v5_restore_vmcr_apr(struct k=
vm_cpu_context *host_ctxt)
 	__vgic_v5_restore_vmcr_apr(kern_hyp_va(cpu_if));
 }
=20
+static void handle___vgic_v5_vdpend(struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(u32, intid, host_ctxt, 1);
+	DECLARE_REG(bool, pending, host_ctxt, 2);
+	DECLARE_REG(u16, vm, host_ctxt, 3);
+
+	if (unlikely(is_protected_kvm_enabled()))
+		return;
+
+	__vgic_v5_vdpend(intid, pending, vm);
+}
+
 typedef void (*hcall_t)(struct kvm_cpu_context *);
=20
 #define HANDLE_FUNC(x)	[__KVM_HOST_SMCCC_FUNC_##x] =3D (hcall_t)handle_##x
@@ -954,6 +966,7 @@ static const hcall_t host_hcall[] =3D {
 	HANDLE_FUNC(__vgic_v3_restore_vmcr_aprs),
 	HANDLE_FUNC(__vgic_v5_make_resident),
 	HANDLE_FUNC(__vgic_v5_make_non_resident),
+	HANDLE_FUNC(__vgic_v5_vdpend),
 	HANDLE_FUNC(__vgic_v5_save_apr),
 	HANDLE_FUNC(__vgic_v5_restore_vmcr_apr),
=20
diff --git a/arch/arm64/kvm/hyp/vgic-v5-sr.c b/arch/arm64/kvm/hyp/vgic-v5-s=
r.c
index 46992a6c2cacb..94746317ca79f 100644
--- a/arch/arm64/kvm/hyp/vgic-v5-sr.c
+++ b/arch/arm64/kvm/hyp/vgic-v5-sr.c
@@ -149,3 +149,13 @@ void __vgic_v5_restore_state(struct vgic_v5_cpu_if *cp=
u_if)
 {
 	write_sysreg_s(cpu_if->vgic_icsr, SYS_ICC_ICSR_EL1);
 }
+
+void __vgic_v5_vdpend(u32 intid, bool pending, u16 vm)
+{
+	u64 value;
+
+	value =3D intid & (GICV5_GIC_VDPEND_ID_MASK | GICV5_GIC_VDPEND_TYPE_MASK)=
;
+	value |=3D FIELD_PREP(GICV5_GIC_VDPEND_PENDING_MASK, pending);
+	value |=3D FIELD_PREP(GICV5_GIC_VDPEND_VM_MASK, vm);
+	gic_insn(value, VDPEND);
+}
--=20
2.34.1
