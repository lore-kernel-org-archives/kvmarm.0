Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013047.outbound.protection.outlook.com [40.107.162.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E18642376B
	for <kvmarm@lists.linux.dev>; Fri, 24 Jul 2026 10:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.47
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784890408; cv=fail; b=c/t7YaE+LlDB3lE4njrwr5SKPBZhwROxyJHWwNBRaMgiaNhhhQ7d8U426B9k9GWlzgFbSvRlkqpmE1AQkAdZZQjSjDry3XJ0VH8nfdFxnePtZeiuUrYB2jKwiitFEGQfu1KWQ33eQ2+7VMTdOEM6PYNS8zN5Cp5qDJBZ5BbbQNE=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784890408; c=relaxed/simple;
	bh=rAXk+SpLPaewAP9jm8z1LHIZtjK9ErLH8isvDNTt+ok=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=I+tMyIg7c97cBfcEMIOFmLCKDYK5ND8YfcpApNgFcXMPAhHQ2nJli9ZkABtbWIcmwfo8nMVdTiovzzEZGPKfW851IsjyT0X6+RcQgVNRHeo5fFcyIEL1j+cj+Vd6wjI0/iBlbxuq3N9akZJlp//fqvPCz45R6WUxO57nXAAg31Y=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=NQO719xL; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=NQO719xL; arc=fail smtp.client-ip=40.107.162.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="NQO719xL";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="NQO719xL"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=Z8w7XVKTPHITIx2HSI3w3snK/MKUS1HBXEP0kIQ3oR5tNMQ/C19w+/nptx5sjdGNSnujKoPS933HfANlfMcmYoopCpVheenRPtplPHFDBbkjwkiS8lGLtq4JIIxapD546R8BncxRME4DPHhLUyxhunxqglgCEdHmfHhfCDBudMZgTp+5IphYwO8duZ9jfCO3qDrGvGSdEfeiv1jOuasNhTTVugexMsrIni8Uk8ZlenkDwZAn44zCfuRL02VBNx0wlvnUu+kXcUACXrqqVZo4VaqbPqz1ZMLXIcjLAvWWVXFPacAcrAnld3WZs/qDp8usMkhtVeIybCY/u5o3uou4og==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7K4ZSQ8Jvnkuwmx0Il02AQZW8LgMf1irH6iX7f7zBLU=;
 b=eeInDsRDQDayvN8auZ0X3DFB/r58p84e5PTqFSpD6391nFuNqnTirvVXTW5+KFFX+i3O3KrSucTFxTVBaL1rRWqJoqddwOcVLT7yKu0MtBerfxXloh6ApfotQswPW8m+YNag509FyXiWHwuJqOgagrtW68gNUCfsFPbXe0B50z98Jf/APRvFGDXOl2jdgLEgoJ8vc98+kN9GyBx36nTHlNBXXZawRAwMPyDB7QBH/aDjIgcB8WlUuOm+WVmFbCp49XPmPjIAb3KCR/dbEiHgN4DAasJ22PjYgVRBY+H6Gm9/cmdbHP9OEzp2aEym7JSa+0J1eRVPiifbvHABsddy+g==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7K4ZSQ8Jvnkuwmx0Il02AQZW8LgMf1irH6iX7f7zBLU=;
 b=NQO719xLH5AKsSscp13pu7+oCs1MYIUpj9YeXlD6Vy1YmyhcxVLkrLhzZ53/iJHBOZ0SffEAC1WYP7YKL4raLKn1RqbPsx8scweZmBMq8OIYrteAapGUkN3Y3S3oKi/dzecyb9ozkc07obNd5BGBpeQfPrrm8bHVj/4cBKK/Ttc=
Received: from DU6P191CA0045.EURP191.PROD.OUTLOOK.COM (2603:10a6:10:53f::26)
 by GV2PR08MB11979.eurprd08.prod.outlook.com (2603:10a6:150:36b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Fri, 24 Jul
 2026 10:53:20 +0000
Received: from DU6PEPF0000B61D.eurprd02.prod.outlook.com
 (2603:10a6:10:53f:cafe::a7) by DU6P191CA0045.outlook.office365.com
 (2603:10a6:10:53f::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.11 via Frontend Transport; Fri,
 24 Jul 2026 10:53:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU6PEPF0000B61D.mail.protection.outlook.com (10.167.8.137) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.5
 via Frontend Transport; Fri, 24 Jul 2026 10:53:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jO0v+5X/K3NHVTOQila8529AQ1s3v2DvfbOnsEWDEBvd3fMXjEiEOATCGRWSAfDJWjiS8zH3UN7ZT+pCdXGB9c0uvNf4B02b6D/IW7kEkgD8qRXcdFjK8geLo61Z5b46AW1XXJcWdNWNC6myExhV0aX97A7i4mczHwPt0EqAgKyah7gVTg6t8gRERBNkCwMae7qgvy2nIz5aLZWBB04qDILNOxiy9OMSUkkzvjaVhWY3eLlLfTrIJT2oAtSYOlBxxUyFyW/G+9nArulivwr+HJbFUDWP0RI8NZIU/AAj6d219UaKMvf1iBXHCXBz4RtGl9vCwBxbeUOT6o7/ELY0vA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7K4ZSQ8Jvnkuwmx0Il02AQZW8LgMf1irH6iX7f7zBLU=;
 b=sylFGn/QotN6d6cytvVShxthWlIE0pnX/FM5vgay1fFcHzWe0+iiMW5sxP2mbPA+qIH345jKmi3cQPO/Yg3NoIYeWIw6dD/k9740nLn93Ty8IX3+vvWCxhF9+ZY18n3YtGRsVX4kk7VoOgR+qHQAzJooN88TaEEPeNHckZOM0+dszvpebSBmFzgD02dgbSMnbl8E8M5WdojQEX0alR4mfKYcw8ov7IGOLcQhq/WKfgRNvUrZ/agIK2fBMxrq6m48csFXJMwKPSgFpb3w/3jQtjLxe78hGtM7iiSRhoHzYKVEWVvPmrbLffbzA80ToTrEq5fRuLNwf0elutNQmVSZmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7K4ZSQ8Jvnkuwmx0Il02AQZW8LgMf1irH6iX7f7zBLU=;
 b=NQO719xLH5AKsSscp13pu7+oCs1MYIUpj9YeXlD6Vy1YmyhcxVLkrLhzZ53/iJHBOZ0SffEAC1WYP7YKL4raLKn1RqbPsx8scweZmBMq8OIYrteAapGUkN3Y3S3oKi/dzecyb9ozkc07obNd5BGBpeQfPrrm8bHVj/4cBKK/Ttc=
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com (2603:10a6:10:407::19)
 by DU5PR08MB10466.eurprd08.prod.outlook.com (2603:10a6:10:516::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Fri, 24 Jul
 2026 10:52:16 +0000
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e]) by DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e%5]) with mapi id 15.21.0245.009; Fri, 24 Jul 2026
 10:52:16 +0000
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
Subject: [PATCH v4 15/48] KVM: arm64: gic-v5: Add resident/non-resident hyp
 calls
Thread-Topic: [PATCH v4 15/48] KVM: arm64: gic-v5: Add resident/non-resident
 hyp calls
Thread-Index: AQHdG1p9ww0ZJIJogUSgtSPy0z9gdw==
Date: Fri, 24 Jul 2026 10:52:16 +0000
Message-ID: <20260724104819.1296803-16-sascha.bischoff@arm.com>
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
	DU0PR08MB8421:EE_|DU5PR08MB10466:EE_|DU6PEPF0000B61D:EE_|GV2PR08MB11979:EE_
X-MS-Office365-Filtering-Correlation-Id: c953b9b5-c0c9-4315-d9ce-08dee971c62d
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|376014|23010399003|22082099003|18002099003|56012099006|11063799006|38070700021|10067099003;
X-Microsoft-Antispam-Message-Info-Original:
 HuvoMd1J+VT3Ydp5By6jmJTZaFmxloxLWXlOOusmUMBXhlOd03aS0HIWYy6myMhIWVvv+clfncO65rwVtQhuFCo/0RWNjZ3ypZkxAK9p1M3cBDlMb+w2+sHnei9jAL+pDdYRnzfKU85M5Dfzp8Jq5gWPYHAfRhOOJWvp0wtNRBZAgTtvQ/zJ5Xwau2S4uzRYMSaKSdCiHvkA23VkHV/LwltDybvcYd+/eKRhfSdXc+7usjlJwpc7SQAstH0xEs/QfyYmemgjIRRQOIlrksDuS7naJPoylGaYCZfjrtnSyyuUVu6XRt6zYor25bV/KVRXEV188yqS7LebGBh0k3MjI6cewoCePDzGVI6U9Op+P3kLdKmjhCHmWVdL9AuzMyir73haOAmrorQD3fMVEbuMLLfJ0I8HZGH/Cdsz7jeY7FSoUPgH5roh9C0lHKq0xVgUgTADe9j08YWmlP/hvYpoKxoThhLFIlayIu7F7tj2rXv0eNtJzyRpS3ITKRMMhkr8mBjPK9duNPTMHNQQ9SuzGvtCaJc0RsoOEF7h1EtMMbMWH6nGtR4IbKVokOvHw+tIsMe0WpHBXM0HZ98wC+waD3n5ganWdUgwZLXihGvbXL+kRsMyWJsfERG0OfFzenFL2qy0/HV5CUyi6mN62bH5SNBC51xPUEM5/o7tacC8ytDp7tjm82tHMsqeW8oMicqcbx4ZlEKe1Ye2RcZl8hvNs6u5AjLqmCu4cLrlFt5pStQ=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB8421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(23010399003)(22082099003)(18002099003)(56012099006)(11063799006)(38070700021)(10067099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 BZ0qE3rj40cCyX5A2L+uJ7IZKDl62uwSN4ukWOqGuRlqm38+7nlrbvsl1Xjn6HFIInj3IKhPP4d/NkvL2ncu3skwgwc0Fl8L8zk13leC/fn9bZEQMM6prPBWuR5kfzqddRHLLR0ccMJV+JEQ6P13dWsZv+ECLC43yFgOVc4NXFUUizlwhpqzErHfF61jokX6rh5RrAITBZEaYQyyWa2n4AFp5Bpk7/8C/0v1Hwz+tteocx5f7+TcyoBdFsAt+cR/p7W/c04x006pI4ccANOVl+EeupCSdrX3oDokd2DTDyZlA9pCAGv5HKxgYCL0LXoHiYqbKVagnPpK3JhFMXzdsg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU5PR08MB10466
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU6PEPF0000B61D.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	d59001d3-de56-4c70-ff1b-08dee971a05f
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|36860700016|35042699022|14060799003|1800799024|82310400026|56012099006|10067099003|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	M/pnYrWBKzsk62q8RyenrMOiv3U200k+EzVW3e/3cDaI46JtDsfDc6Ej07fEI17qnuY4PT55qehv3dbTUnFyhmiAuelzqtjdBM8jeH43eMHTDuDMqNn1HlOljDMW2XojT2WDsgIYkfLEeSCKdgqU97tc1ErSR2mmwqrRpqnlmgorGEtgSBolCS5Ntw95y9N6y64Ims8s3CNHUp6VwGItFDh1cA0wLAdiZ496aq7/Tv5ntKmTsxuAS2GSsxBICEZXNz94s+qR1ZR/WMAKDd+3kqAHn4rGb7UXf7+EEjQKhb9081Z9DfyeBq0sn21KLyq+LZvL1LZCRPwzWQ8o2TXQA62eIyFJqHBvHgux1+uFQZpmRICzBD0m9HZe5Iah2NA5HG02u+OiaL7RKKRXHsadDCJoLsExenwtqDtLWWnPyJ5BDqrn8denr9p1pCQoBHn2/dN8r2ASTmnjXgC00heFrwNUhYM3oy8yKtefjd6Ro959JhMeHszD1nVVVspV7pwgBNieLWfKVd8vV3f0/XD7eJeLROTB/sRYiKQ2A9FNsqBZlfatmXsFXO/+KrGZHNJPA65yvmoqxCB96q0+chkHl71A7iSxbu/bzk9mRpcVx2sZv+KlJDz3GV8uzVErw3HHBWDWYL3YtJBk74NjI2Jrs33TcBuUkiPTUcOHGFz5kR5uRsDRPyQL722YzKK/oX2nEeJBD1fDTyzUPmY+/0nzMw==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(376014)(36860700016)(35042699022)(14060799003)(1800799024)(82310400026)(56012099006)(10067099003)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	KcAxG0xl81JOCFz/l3pEpTEtvuW4dpbJFNb+myCZ9yfNb4ONbqFFQ8zt4Q2/xDchrxoPMista0nS+kpQlyQsqgbWH/N0bUOnjZKM3bLPqtNA3BcKgxqAPm5isfOfs5A+MSGPjdjUX+Aidp5UBNdihk30AEUo8Tw9ySPW9+Yw+3YRszdmzE4DXPialoRfqhtcmpnnMNqohba8VDhauQy2qO+SS71MCJn4s3VixHU5HyXegfS7sRNeR1F2xuugRPx4a1W2HucSC5nlGCAtA6ipU7NfvH3CeCJUp0dNma05X2pnWWpIT/hCycNwTBcbTNQ0EDXQFOJNoqkKMSqCx5MTOKy1BV68CrEFaWJu8pBdKiIICrwMFNtfV4+lUy/m+qpsuqZM8QfazcD2MHT28zs+qRY/0Lb7t0kOAMkdIfbJGO293OxNEiIBrDfq1nDZVYYJ
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2026 10:53:19.7538
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c953b9b5-c0c9-4315-d9ce-08dee971c62d
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU6PEPF0000B61D.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR08MB11979

GICv5 introduces the concept of VPE residency - a VPE can be either
resident or non-resident. When the VPE is resident, the IRS is allowed
to select interrupts that target that VPE (or the VM) as the HPPI
(Highest Priority Pending Interrupt). As the IRS handles both SPIs and
LPIs, these will only be picked as the IRS's HPPI when a VPE is
resident.

A GICv5 VPE is made resident by writing ICH_CONTEXTR_EL2 with
ICH_CONTEXTR_EL2.V set, together with valid VM and VPE IDs. This
informs the IRS that a specific VPE is running, and that it can begin
HPPI selection for that VPE. Making a VPE non-resident (by making the
ICH_CONTEXTR_EL2 invalid) informs the IRS that the VPE is no longer
running, and it stops HPPI selection for it.

This change introduces two new hyp calls - one to make a VPE resident
and its counterpart to make a VPE non-resident. As part of making a
VPE resident, the resulting ICH_CONTEXTR_EL2.F bit is checked to catch
residency faults. Such a fault indicates a broken VM/VPE setup, so
warn and mark the VM dead.

Furthermore, this change extends vgic_v5_load() and vgic_v5_put() to
make the VPEs resident and non-resident, respectively. Hence, the VPE
is considered resident for the entire load-to-put interval.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/include/asm/kvm_asm.h   |  2 ++
 arch/arm64/include/asm/kvm_hyp.h   |  2 ++
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 16 ++++++++++++++++
 arch/arm64/kvm/hyp/vgic-v5-sr.c    | 26 ++++++++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic-v5.c      | 16 ++++++++++++++--
 include/kvm/arm_vgic.h             |  3 +++
 6 files changed, 63 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_=
asm.h
index 043495f7fc78b..d9ff9c2999aa7 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -87,6 +87,8 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___tracing_write_event,
 	__KVM_HOST_SMCCC_FUNC___vgic_v3_save_aprs,
 	__KVM_HOST_SMCCC_FUNC___vgic_v3_restore_vmcr_aprs,
+	__KVM_HOST_SMCCC_FUNC___vgic_v5_make_resident,
+	__KVM_HOST_SMCCC_FUNC___vgic_v5_make_non_resident,
 	__KVM_HOST_SMCCC_FUNC___vgic_v5_save_apr,
 	__KVM_HOST_SMCCC_FUNC___vgic_v5_restore_vmcr_apr,
=20
diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_=
hyp.h
index 4974492744cc8..8fcbbff719cce 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -88,6 +88,8 @@ void __vgic_v3_restore_vmcr_aprs(struct vgic_v3_cpu_if *c=
pu_if);
 int __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu);
=20
 /* GICv5 */
+void __vgic_v5_make_resident(struct vgic_v5_cpu_if *cpu_if);
+void __vgic_v5_make_non_resident(struct vgic_v5_cpu_if *cpu_if);
 void __vgic_v5_save_apr(struct vgic_v5_cpu_if *cpu_if);
 void __vgic_v5_restore_vmcr_apr(struct vgic_v5_cpu_if *cpu_if);
 /* No hypercalls for the following */
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/h=
yp-main.c
index d3c69de698f48..09756f71df08e 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -691,6 +691,20 @@ static void handle___tracing_write_event(struct kvm_cp=
u_context *host_ctxt)
 	trace_selftest(id);
 }
=20
+static void handle___vgic_v5_make_resident(struct kvm_cpu_context *host_ct=
xt)
+{
+	DECLARE_REG(struct vgic_v5_cpu_if *, cpu_if, host_ctxt, 1);
+
+	__vgic_v5_make_resident(kern_hyp_va(cpu_if));
+}
+
+static void handle___vgic_v5_make_non_resident(struct kvm_cpu_context *hos=
t_ctxt)
+{
+	DECLARE_REG(struct vgic_v5_cpu_if *, cpu_if, host_ctxt, 1);
+
+	__vgic_v5_make_non_resident(kern_hyp_va(cpu_if));
+}
+
 static void handle___vgic_v5_save_apr(struct kvm_cpu_context *host_ctxt)
 {
 	DECLARE_REG(struct vgic_v5_cpu_if *, cpu_if, host_ctxt, 1);
@@ -738,6 +752,8 @@ static const hcall_t host_hcall[] =3D {
 	HANDLE_FUNC(__tracing_write_event),
 	HANDLE_FUNC(__vgic_v3_save_aprs),
 	HANDLE_FUNC(__vgic_v3_restore_vmcr_aprs),
+	HANDLE_FUNC(__vgic_v5_make_resident),
+	HANDLE_FUNC(__vgic_v5_make_non_resident),
 	HANDLE_FUNC(__vgic_v5_save_apr),
 	HANDLE_FUNC(__vgic_v5_restore_vmcr_apr),
=20
diff --git a/arch/arm64/kvm/hyp/vgic-v5-sr.c b/arch/arm64/kvm/hyp/vgic-v5-s=
r.c
index 6d69dfe89a96c..f064045a31aee 100644
--- a/arch/arm64/kvm/hyp/vgic-v5-sr.c
+++ b/arch/arm64/kvm/hyp/vgic-v5-sr.c
@@ -7,6 +7,32 @@
=20
 #include <asm/kvm_hyp.h>
=20
+void __vgic_v5_make_resident(struct vgic_v5_cpu_if *cpu_if)
+{
+	write_sysreg_s(cpu_if->vgic_contextr, SYS_ICH_CONTEXTR_EL2);
+	isb();
+
+	/* Catch any faults */
+	cpu_if->vgic_contextr =3D read_sysreg_s(SYS_ICH_CONTEXTR_EL2);
+	if (!!FIELD_GET(ICH_CONTEXTR_EL2_F, cpu_if->vgic_contextr))
+		return;
+
+	cpu_if->gicv5_vpe.resident =3D true;
+}
+
+void __vgic_v5_make_non_resident(struct vgic_v5_cpu_if *cpu_if)
+{
+	/*
+	 * Make as non-resident before actually making non-resident. Avoids race
+	 * with doorbell arriving.
+	 */
+	cpu_if->gicv5_vpe.resident =3D false;
+	dsb(st);
+
+	write_sysreg_s(cpu_if->vgic_contextr, SYS_ICH_CONTEXTR_EL2);
+	isb();
+}
+
 void __vgic_v5_save_apr(struct vgic_v5_cpu_if *cpu_if)
 {
 	cpu_if->vgic_apr =3D read_sysreg_s(SYS_ICH_APR_EL2);
diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 4a62aa7d6505a..e3df8a5f9f657 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -1061,6 +1061,8 @@ void vgic_v5_flush_ppi_state(struct kvm_vcpu *vcpu)
 void vgic_v5_load(struct kvm_vcpu *vcpu)
 {
 	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+	u16 vm =3D vgic_v5_vm_id(vcpu->kvm);
+	u16 vpe =3D vgic_v5_vpe_id(vcpu);
=20
 	/*
 	 * On the WFI path, vgic_load is called a second time. The first is when
@@ -1073,7 +1075,15 @@ void vgic_v5_load(struct kvm_vcpu *vcpu)
=20
 	kvm_call_hyp(__vgic_v5_restore_vmcr_apr, cpu_if);
=20
-	cpu_if->gicv5_vpe.resident =3D true;
+	cpu_if->vgic_contextr =3D FIELD_PREP(ICH_CONTEXTR_EL2_V, true) |
+				FIELD_PREP(ICH_CONTEXTR_EL2_VPE, vpe) |
+				FIELD_PREP(ICH_CONTEXTR_EL2_VM, vm);
+
+	kvm_call_hyp(__vgic_v5_make_resident, cpu_if);
+
+	/* Failed to make the VPE resident? Bang! */
+	if (WARN_ON(!!FIELD_GET(ICH_CONTEXTR_EL2_F, cpu_if->vgic_contextr)))
+		kvm_vm_dead(vcpu->kvm);
 }
=20
 void vgic_v5_put(struct kvm_vcpu *vcpu)
@@ -1091,7 +1101,9 @@ void vgic_v5_put(struct kvm_vcpu *vcpu)
=20
 	kvm_call_hyp(__vgic_v5_save_apr, cpu_if);
=20
-	cpu_if->gicv5_vpe.resident =3D false;
+	cpu_if->vgic_contextr =3D 0;
+
+	kvm_call_hyp(__vgic_v5_make_non_resident, cpu_if);
=20
 	/* The shadow priority is only updated on entering WFI */
 	if (vcpu_get_flag(vcpu, IN_WFI))
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 6f736094a0e7e..faecde764fea3 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -536,6 +536,9 @@ struct vgic_v5_cpu_if {
 	 */
 	u64	vgic_icsr;
=20
+	/* The contextr used to make VPEs resident and non-resident */
+	u64	vgic_contextr;
+
 	struct gicv5_vpe gicv5_vpe;
 };
=20
--=20
2.34.1
