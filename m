Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013051.outbound.protection.outlook.com [52.101.83.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6DDE3E3179
	for <kvmarm@lists.linux.dev>; Thu, 19 Mar 2026 15:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.51
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773935686; cv=fail; b=gcdqKGbrSWy/VKEksnnIkBg336JeFVG+4XWycxHGJ06LO5IR7yCgBrmw3IalsvvebfEwjNCKpbv+m2AYJ9lQsiX0QYMjHLrO4hlffS5XnexOp7Wptwt1RQEbF1/BNQyYjWD+T6IP7qDojB0By0zj/DaLDACUDSbCPpPQfPnXoCA=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773935686; c=relaxed/simple;
	bh=nNlWu/Qvxsf67edDWdNpb/A2UZBDnJvLzTirfYoDUic=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=bXAKAtEGMPCV0ArByxway4jcJBTysFRMjHl5uWVvUVTxeCInEmthCoUhOEExQCiHlGwpqdQYCtNoOy1biM11y3xpOS3wq5hEOAbvrOmakfFSyD9u/9Fk6HwzCkAEjw1RcOHrXfgIi537n5VZJKyB1YpkykeyccIoJGMfd76x2Zw=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Iqx8Pa+O; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Iqx8Pa+O; arc=fail smtp.client-ip=52.101.83.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Iqx8Pa+O";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Iqx8Pa+O"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=m5gBp4ubpUdvN8wLUbaMkr0PFooCaly/2wPHTqdkPINzRLTPWJnWFUR6jltJCVnm/vyuBUFKKYsFvhUtftzve//BQFE/0rQUtBn8ImVzdNN7EKzEwBvXXv0b/SOU19OHlogpqskW99j6/9bAH9pex8ZQBl3kYIwytbDsuAk5w56hvIk2PCUoaU1OOkg91m5G9mj1/CBvVf9dKO71Hhy+w5bpNIaDUF+IbYlQMQ2S+e1Z2gd/QHPUvdfRjMw4Ddpvr3YahYBsjCejUKuvMnmlo9sN2VMrgjwroO4qHxihIJdXYzmakq2wSB8yYntWZvMFx0sGfjiR0Txmyk4LBpAVCQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EeKJyfMDuagCR8fRmiZwPcGXkNFkvMuazzGc2En6x3c=;
 b=pG2dNGBl2ysmva+mkIwZrWVeXCbXodEBERqVSufCyTAE8T1uN/cjqpaZFPpe83lxQDLfnb0kHP8SEMO4larJf5xkCf9LfqjuJH7ZXbgQA1sa043ORWLGapAiaUoe9hO8RfOV0gf1hNptF8YEUEjgk6i2pI9d+umhp//H9L7CB+2c1GImtALh/1Q8T+JbE4aG8pydnTB/87zX2KiUesIno1TJsmICcNcCj42bHu2NgnEBYnrHKUzNuGFpelCF8TbBoMJmfBoVtdEuFC+IP8wJ4AKbemuoo0znFjh0lepvHnXEoUadH9Jn53DYZyGgEBiLaYE6xmizph+edPtOH9X1Yg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EeKJyfMDuagCR8fRmiZwPcGXkNFkvMuazzGc2En6x3c=;
 b=Iqx8Pa+OJo9utMZdNBaGwyyYjz++PPGCMHF8FS4WZudNUYA3Wjvo1qzmFtc8p4nnlxRduSYbex3LChjjWTAaC2UTaUXzwCgG+Pd798P9xfrcBbxM14VhNg+0frC56iZ8ATufYbEvInlya8WWNa4o5pr+tpC4nYqPsm+d1SxFOMg=
Received: from CWLP265CA0323.GBRP265.PROD.OUTLOOK.COM (2603:10a6:401:57::23)
 by VI1PR08MB5437.eurprd08.prod.outlook.com (2603:10a6:803:13d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Thu, 19 Mar
 2026 15:54:40 +0000
Received: from AM1PEPF000252DC.eurprd07.prod.outlook.com
 (2603:10a6:401:57:cafe::8a) by CWLP265CA0323.outlook.office365.com
 (2603:10a6:401:57::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.19 via Frontend Transport; Thu,
 19 Mar 2026 15:54:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM1PEPF000252DC.mail.protection.outlook.com (10.167.16.54) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.19
 via Frontend Transport; Thu, 19 Mar 2026 15:54:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EuYHKXHKm7RHugJR7BKs6XA4JGbcKx9y+GSos3A0v5OFIbjNVfmVnXB4RlSyuhjY7cm5kk+ETbXPIWIeefMKFi/uz5gb0dB068EzdTuiV1AtbEPvnYyEkfnvOY4ba0RnI1k1gR7pYUlrQ+dVSp5zGB7UxDBWZDrx1xGPxEqaEB4m7ShO+MRWTORXqbM3CYrJOlb0NZcjZdJNntd+IqFqTaVVc1wTwM9/3X2UgAVGdylfMgd6U0gTsV98OxwfCs0QOniAc2BmAIWrwwS3e001nsPUQu5zPCmjxLe1FilBcWSvA/uxiS2gw9wTfmoWTPhDvUib2kBTktzVG8I+JGrX8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EeKJyfMDuagCR8fRmiZwPcGXkNFkvMuazzGc2En6x3c=;
 b=kd81jXexmJnl1ldU5OrNTBRfI1vRExs9Wa4P+WdX9RXaWoeRX16Zo6mKCmcpWpMc4QlRb54ONtVgDG4NqUcg2gmjE2PeOcNvj+bnMY169DDgY+p6UU7gXBSWITj5QHmc9PhcWyakPmTXhwTNwUnlvnE/q0pmBm7B99pWvrix1nFt9kG/M7bLqzMlE5nMvajcSkftSmWMVPpGMrHgFJxodYccHP0Xq039r6UWq/UGlC9EbVRrH2IKDhRDSIKyYSqiUt5eB9jIbau2d2upqxJ36Fr1JqcNi6/Y3Fb7FtXv7Vbn5uQtQOR5STFZxYmeK5Uwj/dU7Q7lqBfkN00ATncrAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EeKJyfMDuagCR8fRmiZwPcGXkNFkvMuazzGc2En6x3c=;
 b=Iqx8Pa+OJo9utMZdNBaGwyyYjz++PPGCMHF8FS4WZudNUYA3Wjvo1qzmFtc8p4nnlxRduSYbex3LChjjWTAaC2UTaUXzwCgG+Pd798P9xfrcBbxM14VhNg+0frC56iZ8ATufYbEvInlya8WWNa4o5pr+tpC4nYqPsm+d1SxFOMg=
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com (2603:10a6:20b:504::10)
 by PA4PR08MB6191.eurprd08.prod.outlook.com (2603:10a6:102:f3::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Thu, 19 Mar
 2026 15:53:37 +0000
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27]) by AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27%6]) with mapi id 15.20.9723.018; Thu, 19 Mar 2026
 15:53:37 +0000
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
Subject: [PATCH v7 15/41] KVM: arm64: gic-v5: Trap and emulate ICC_IDR0_EL1
 accesses
Thread-Topic: [PATCH v7 15/41] KVM: arm64: gic-v5: Trap and emulate
 ICC_IDR0_EL1 accesses
Thread-Index: AQHct7iM6FKANu2tnUKAWye9gXTM/g==
Date: Thu, 19 Mar 2026 15:53:37 +0000
Message-ID: <20260319154937.3619520-16-sascha.bischoff@arm.com>
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
	AS4PR08MB8241:EE_|PA4PR08MB6191:EE_|AM1PEPF000252DC:EE_|VI1PR08MB5437:EE_
X-MS-Office365-Filtering-Correlation-Id: 3bb3cea0-7067-417e-da06-08de85cfd410
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|18002099003|22082099003|56012099003|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 cgYHAMtbGJkmzPHDro49wnCj87GjScjLDc7j3sCMmHf4ku057reCqGKToScs9p3uOCeh1qEQnKfO+Rm5MZy00OdMDcZz2lA/eMJ9DYPerxHJ6QR66SiToQm82INRY4W1rDD9CozCJI/2kOcTD4CJ8i7+3pWsIbh9idsoCEW6FChD/zISBKckAeLGsIrlsyY7ZjIxDZLRheYFnBHN8Tfl+mceKJ5Yw9R4KmA+TKskEojV3EuQO4lLIyjjXBgc3OQJ2j+UKPUAWTd3QGVkm6eHOsYaTaMmN8iaqkKnZPoG4aka13oEs7Z9Ndt9igEkQPdEVC4Mmr3nREPSjLRoN3BL4pMart7Ji4OkO/XXfSseR4u6sdK4mAYUmMnHBdaKrHfusmsdHFPsqiMPNQlaRrjsOaarQDc3pJsSvz358CoYK6EF+RNojWhltnTEASxqX09TxB4hqxE0o+N6rsuo28XuhyEqRv7zNIwKry4NJgTQTb+HEECGz0FxJAsICCEVtfoGjPFjqADET8fORYvxOac7gTH/HAOzrA7NK1HN644degmWbNIU3G6ejFEDMwwqDA/AFTx4TOE4p+4o2jSjrlLXMBQPKfa3suZGHGrtIYIKGyNiFXOoxQELOZZBPnWd68mFeJiI6uLAFrnoU/a+FFFZKui335eFxvESRd7nxNa1i9ilIcqhp6Ugnl15uIXP64ezuBGH25nwgpRt6mun4iWXL9yjDFwZipGvLgScnWnEk1cQlLXrGJtWtFWg+/UwBckptwcx+Pa0PK1tOmczz4MOJYHyJGqz0JTri2VhqEkaDKs=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS4PR08MB8241.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(18002099003)(22082099003)(56012099003)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 SPdbG6b01ptBTlJlULE0ar4Bz5qHVMhc7fcFbYPxz4qlApdmcnYWG9f/kTSQRh2+/l5o5qlzjk5sV655WlyvTWUdHxxJxvY47Qje4lO/ZKlfEWeuqRmzlbpOWKnH/5GUoaJJLN8ldxWM1EY+DYyXA5/z7wepDFkfZmB/ADht9hTofhAui8++wZ2cWtq8Da0AcSiWJWxoM5xFQqOsRY26lUjzyhgiBVbGBrxj7+TKpcZXaQaBtzHgZL3XBqnhGPABplYgU5YqVsERySn5oYqnxeNHQInPY1TM9iMfxbbX+XskQS62k4z3uw093JNcWeuEUsigJlclFRRpS/MWbKZaqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR08MB6191
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM1PEPF000252DC.eurprd07.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	ae417dc4-2d4c-4132-f820-08de85cfaed6
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|35042699022|82310400026|14060799003|376014|1800799024|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	R5gCs3mTACItmueopifhw0iWcoBIfFkRxOm1Wh1oLc3SvIJBjwKV4NJJ41Ai2obcPjC7R2Y6es9ZxArsBNuAT2n2tMtiSeJCz//3bjk9l5i62SwSglwjdwe6iqtJyQBnjYuA9tEJPlUFeMw2i5u18diS6O2EObHVUEZnGrn8cLXverAO2lS53QmETJE45BcK1w04XlV47xxN6Q8N958geP6g9GgeL1BBTsrQGxMnVBVNphLus/vTMiG2WlR6ryx+LdeusOkPPLJPQ88ODw+Ryb/uBqJLKICyFJlcFn0oh+S9TagLR1FtmadXxK0GDuWH18X0CIZq+UrvGC7WYMRWmuP3MKqNd+Xps53qGqZL2lsop9lvQy1yPxeJeFg/KpUuqXzQApPXut5j/jhyoPWiCfdpO/A8QfO/i0YDzu8728DYnBj2z1TV1M2V1R7HwLoAhQQN+2CRomClepqEIjhvQdRCpU69W+HjbmlckYZrDDtEWKfV6CD7871IeWVsS0U6mssoeFoGGTtmAbrcxq26oHU1pXf3nCzpS74FQBn0eBaWItAQTnwbLbmOrM3xpQaXdADZhBfvvJCj9M7kZ7frSiCssAimS08iqZfNRWdBQOBVJyaj7Vyw2tP6XtMBUCPVD2DspmYn6DnXe7Jgh2FgSebCS1jY1AXGzRcrsZwh9ZAkvqqoBE4IN+JwXdT1yuSVKZw9I9s8ZTIj8rQMOCZDp3ZOaAW48n1DYr83Mb52gvwPUbaBG9Xvvu8E6jbbEIXur9rfWbSGHCLH5VOJzARhew==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(35042699022)(82310400026)(14060799003)(376014)(1800799024)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	QB99ZGN4SJbleNH5ooFjupnOjgh0GFVMQa/uXAqDh8/BAo2NqzDbxrXS9/PJ+6On9m3mJQ2tAS64ZVGV0oDJ9Q/aKZe0MyIakoUh4ee007je4DejAb1YWVpAo8mglrrNb2kRtPRYy5hqsCxLejZmfaF0Jr9NTbiMsaQQhpp+L5/CPc/qgXdXGtTdfvtSjpNxqSkJ40OkV/4Q2mtLm7O5xvwMhMQ3SUcUfMKqgiy/xmNtAiYumF2ZSs/e2tpko82xTC4wx8EgWUrNVzIiw5AYIWuOXlG+TCQ0CFOqqFxxpQTlMcrtrAqqurI8OiCEucBYnWjcyUWmJErwyWjhPc0nutPs4+fwuaZD22FTBwdxHPCCPfXPrGqM7lsCTq6vvshXbzhDMuP5ArvkfZ81pM7u8ry4vWS57egP0o4vR2AXEft/LYGbE27IQY/rU+tKnv3z
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2026 15:54:39.4784
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bb3cea0-7067-417e-da06-08de85cfd410
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM1PEPF000252DC.eurprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB5437

Unless accesses to the ICC_IDR0_EL1 are trapped by KVM, the guest
reads the same state as the host. This isn't desirable as it limits
the migratability of VMs and means that KVM can't hide hardware
features such as FEAT_GCIE_LEGACY.

Trap and emulate accesses to the register, and present KVM's chosen ID
bits and Priority bits (which is 5, as GICv5 only supports 5 bits of
priority in the CPU interface). FEAT_GCIE_LEGACY is never presented to
the guest as it is only relevant for nested guests doing mixed GICv5
and GICv3 support.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
---
 arch/arm64/kvm/config.c   | 11 +++++++++--
 arch/arm64/kvm/sys_regs.c | 23 +++++++++++++++++++++++
 2 files changed, 32 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index bac5f49fdbdef..5663f25905e83 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -1688,8 +1688,15 @@ static void __compute_ich_hfgrtr(struct kvm_vcpu *vc=
pu)
 {
 	__compute_fgt(vcpu, ICH_HFGRTR_EL2);
=20
-	/* ICC_IAFFIDR_EL1 *always* needs to be trapped when running a guest */
-	*vcpu_fgt(vcpu, ICH_HFGRTR_EL2) &=3D ~ICH_HFGRTR_EL2_ICC_IAFFIDR_EL1;
+	/*
+	 * ICC_IAFFIDR_EL1 *always* needs to be trapped when running a guest.
+	 *
+	 * We also trap accesses to ICC_IDR0_EL1 to allow us to completely hide
+	 * FEAT_GCIE_LEGACY from the guest, and to (potentially) present fewer
+	 * ID bits than the host supports.
+	 */
+	*vcpu_fgt(vcpu, ICH_HFGRTR_EL2) &=3D ~(ICH_HFGRTR_EL2_ICC_IAFFIDR_EL1 |
+					     ICH_HFGRTR_EL2_ICC_IDRn_EL1);
 }
=20
 void kvm_vcpu_load_fgt(struct kvm_vcpu *vcpu)
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index d4531457ea026..85300e76bbe46 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -681,6 +681,28 @@ static bool access_gic_dir(struct kvm_vcpu *vcpu,
 	return true;
 }
=20
+static bool access_gicv5_idr0(struct kvm_vcpu *vcpu, struct sys_reg_params=
 *p,
+			      const struct sys_reg_desc *r)
+{
+	if (p->is_write)
+		return undef_access(vcpu, p, r);
+
+	/*
+	 * Expose KVM's priority- and ID-bits to the guest, but not GCIE_LEGACY.
+	 *
+	 * Note: for GICv5 the mimic the way that the num_pri_bits and
+	 * num_id_bits fields are used with GICv3:
+	 * - num_pri_bits stores the actual number of priority bits, whereas the
+	 *   register field stores num_pri_bits - 1.
+	 * - num_id_bits stores the raw field value, which is 0b0000 for 16 bits
+	 *   and 0b0001 for 24 bits.
+	 */
+	p->regval =3D FIELD_PREP(ICC_IDR0_EL1_PRI_BITS, vcpu->arch.vgic_cpu.num_p=
ri_bits - 1) |
+		    FIELD_PREP(ICC_IDR0_EL1_ID_BITS, vcpu->arch.vgic_cpu.num_id_bits);
+
+	return true;
+}
+
 static bool access_gicv5_iaffid(struct kvm_vcpu *vcpu, struct sys_reg_para=
ms *p,
 				const struct sys_reg_desc *r)
 {
@@ -3420,6 +3442,7 @@ static const struct sys_reg_desc sys_reg_descs[] =3D =
{
 	{ SYS_DESC(SYS_ICC_AP1R1_EL1), undef_access },
 	{ SYS_DESC(SYS_ICC_AP1R2_EL1), undef_access },
 	{ SYS_DESC(SYS_ICC_AP1R3_EL1), undef_access },
+	{ SYS_DESC(SYS_ICC_IDR0_EL1), access_gicv5_idr0 },
 	{ SYS_DESC(SYS_ICC_IAFFIDR_EL1), access_gicv5_iaffid },
 	{ SYS_DESC(SYS_ICC_DIR_EL1), access_gic_dir },
 	{ SYS_DESC(SYS_ICC_RPR_EL1), undef_access },
--=20
2.34.1
