Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011013.outbound.protection.outlook.com [52.101.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24F043E95B5
	for <kvmarm@lists.linux.dev>; Thu, 19 Mar 2026 15:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.13
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773935736; cv=fail; b=CSTNbTFFAYIirxCIsZKmfkaGy8vEuibxjNeTsVbh3qn9HWUde+bl+h0efSjRPtxyYR1kBGpZ5OH5Rezjmd36589q2E80vr/M1PIHS76s4kNVCM+v68ejEnO5EDB21ovg5nNnuQfsTze+kc0tApb57yOpVfZ2wNtp+3VSdY5ImsM=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773935736; c=relaxed/simple;
	bh=wK3rh0lninUGVNqCQVMmZdIM2AekTdAYjGV9ZE/GuA0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=iyQdABCXR2WOl5UqBaKiD9xuZE+H3GtthESYocPWVE2igURFMtrrEtMlDevMuM6hd2KvX0p4y/0Bx7GcxNk1YAW4qe5fi+RwxC1mqquGxuvDsMLCIvEUA5hLzSB0dpmZM0AnA2jZVQ1rOONulyPFy6Mmw3Y4pjsPBqbbq9z7WYw=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=m19yJKdn; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=m19yJKdn; arc=fail smtp.client-ip=52.101.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="m19yJKdn";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="m19yJKdn"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=Cg+4iBfzqCEbukmN1OZ7jWbTQTg8THkVl5lmQHYI9+DyqdR8SKaqWBOBmGYLvjbQSvPv34g4xRjyT4RNMQYBZb0ydQ3JK/gK8O7Nn7UHXzG+rK1ZpMlyCBzEpRAZung2+dKJgacFfNNLMIAF4ZGrbao5POKCUEmAPQu/A+okQ/BxBKbB9CsFePShQmHEaIqfkzw/nN/IjKAeyebngrLZIBK2dx69DJmaJkcnrN6MSsNZbVzTz9y4k76T9nEzLrnRWAOUhC4mHXpl9CTukOZiuWktFszHWI++CWlMt7AjIEJoR1KOh/McaXqW8lQ+rTfYOlP3R7dLJniCARI9BhGmDQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RoQp/GAPfpffJiURSA647sXcaWSWeTuxz+YhEnf74kc=;
 b=ZUC8XJi/fXpsGIncm+OES/efqor7D0JFu+eLxTROi/+C0qm33qsabspQYKcz2YAsP0PsmmC+q9DHjOFbIWyMJQN5Dfw9ri1DMumMMQxJgBCKSdHR99CLaHzkGs5YnCUpL4naIarTf9z64Nbat3K7TPZAvgZrhCtGAUweNVI5jYWxYQGYb0gGPIp+n16wzdwn2WGkoLE7BSHgsVCybiFPFafM7XMB/rJWIVBKXBXt/k+4ic8lV2dw6G0Xuc5qxLfgS3HIzQQQzk6muPwsYgnFDoXG5ki4VEcg84RotSQryaqfpaO04ROecpRaZWvq9yTHVtVSje/nFnSsUI2RUiEKyA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RoQp/GAPfpffJiURSA647sXcaWSWeTuxz+YhEnf74kc=;
 b=m19yJKdnREjLkWdvABuQQILGdLo6mWdbrrrgypPTt8ibZipnSNfGW52CYUNMFUiu/DCII6w3zi8hUgiW1N9ty/25AsTlSLRYWgzN292oabzvLKPdObgLTCcVEj52qpeyiByRlVBSykkglbjhF/DgOMwDDXgpqxgVX/On5OYkZZQ=
Received: from AS9PR0301CA0014.eurprd03.prod.outlook.com
 (2603:10a6:20b:468::21) by AM9PR08MB6130.eurprd08.prod.outlook.com
 (2603:10a6:20b:2d8::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Thu, 19 Mar
 2026 15:55:28 +0000
Received: from AMS0EPF000001A8.eurprd05.prod.outlook.com
 (2603:10a6:20b:468:cafe::4f) by AS9PR0301CA0014.outlook.office365.com
 (2603:10a6:20b:468::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.27 via Frontend Transport; Thu,
 19 Mar 2026 15:54:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF000001A8.mail.protection.outlook.com (10.167.16.148) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.19
 via Frontend Transport; Thu, 19 Mar 2026 15:55:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iKk0hSnlbihBLG6q10PCS7nZv8myvFIH2NOxenyKmX6QdZFXHmc2Wd6sN0LP9SSXxXprOzk8SkMKFwY3HHfb6KEQbo8Dwr5bXZz3lX4SJQ5ZILvOdYTBSeUzHCIuEVgyjQgk06Oj09tD4QaEd4yfBdVuH8KzVVNKuaWr+ULG4qM3MtU7BQg0946dOqc9uE+khwbOfEdMGqIQK9FfJ7xljMK1y1ZCjyiTCQkzu6+mOGkQHuX6C5sfL2jOHwI8HvoE5r5RPYPz81sOmXkH0fuuB4Iv8YdW/9mRiGU+xOF+KvlY0+CSQ1OU6uQK2KBOLTOdbbduNE5Gvl2Knx2rGkPtVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RoQp/GAPfpffJiURSA647sXcaWSWeTuxz+YhEnf74kc=;
 b=SYo4U5fzRlxAX/972E7m7yJ8UJSbQwNB+hENXVaMuf853sUXQFHkavMVKVbXzXGIA1Dl1rWKBUWfwCfh5SRsUSaNs6f4BuOpNPMMCH3DH4+XIuuy22mK1rRyQPgkux3p0WaXXUMRtKl+HcSGLLGd4624wEmKAkYo1OkB2p1MI5j252t5N9u93pJTjZnfn5rCXsYKn098vpIXL73GkjyVNeZwCLh02ZOAA4VOW4MfBiOSJhhMdxP1Svv68vRLbK5EDuqBvqU2+2BY8uhDcgmDtiWKaLK3ST/C1KLwe23tDukGG50y3JeHuPIj57/B6RT8KHPpn9FrnGVrNPfEFLihvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RoQp/GAPfpffJiURSA647sXcaWSWeTuxz+YhEnf74kc=;
 b=m19yJKdnREjLkWdvABuQQILGdLo6mWdbrrrgypPTt8ibZipnSNfGW52CYUNMFUiu/DCII6w3zi8hUgiW1N9ty/25AsTlSLRYWgzN292oabzvLKPdObgLTCcVEj52qpeyiByRlVBSykkglbjhF/DgOMwDDXgpqxgVX/On5OYkZZQ=
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com (2603:10a6:20b:504::10)
 by PA4PR08MB6191.eurprd08.prod.outlook.com (2603:10a6:102:f3::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Thu, 19 Mar
 2026 15:54:24 +0000
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27]) by AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27%6]) with mapi id 15.20.9723.018; Thu, 19 Mar 2026
 15:54:24 +0000
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
Subject: [PATCH v7 18/41] KVM: arm64: gic-v5: Finalize GICv5 PPIs and generate
 mask
Thread-Topic: [PATCH v7 18/41] KVM: arm64: gic-v5: Finalize GICv5 PPIs and
 generate mask
Thread-Index: AQHct7ioCOz4vDIKmUmS+mCgmGGMUA==
Date: Thu, 19 Mar 2026 15:54:23 +0000
Message-ID: <20260319154937.3619520-19-sascha.bischoff@arm.com>
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
	AS4PR08MB8241:EE_|PA4PR08MB6191:EE_|AMS0EPF000001A8:EE_|AM9PR08MB6130:EE_
X-MS-Office365-Filtering-Correlation-Id: 04a661ce-d5ab-4654-b796-08de85cff0d7
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|18002099003|22082099003|56012099003|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 b63Tr+UkFYUufdApjrOZYUUQ5cGAjl7+u8HqaTnmE29HCN8CzG4cL138gtycVEQ8DSFMT8g3WD3wll3gOd0HpTqhmQGwQx7sXOhkJfLOeaH6n0IalAuDvzieI88DRwrxU7br7psHEkpId7XYFvFLQJ6X8kxaIbmq22feC405XuclW1UnqGC8WYaEa8PXA9qzm30QBn7fdXZ1KRxaJzMrQs7KLfjMJYFLMdkgWxn41L843tE6YbKNn4g2ctXN45bJwpCNloA2q35dhWWJARY9/JjIMVGznNADewzH5RLLf3uqawwwpn6N5tCU9hUBkWBBGezddgxF0NTPlkUWszzlTA6aGIpegcT0Jo4HySv09YFQGcDhSsHkGNm/emmDsfFuXe8s+DJKRBHexDUckIGVmBdTVLYHRef2EB3iaq369z3LPSfkV6P02J6Sy4oqOGBLZHkoWjibQXq/QUtFla7+D5BILWAinWbmMC8iiRyXgP9eZTDEBCNWX/cmkXssCD716Ve8Naa7WV6u9PkYRquoKxjGJl08ZkaZLdNsgn7mRw7eHJfitixACuLzVK5uiaTghdiqeNa0/zyPcdTf/SgJxwpAz7VyizwgGuOreTUYgV2CTq3Kbe7LEC8ovwR5kn0a5JVoGuIaugNG7sWvPk/ztiGrscoXbfUbsKbpAVVjQDPhsAvGU35OeTTFK8DUlztngMfGljZ2aYEvxjkRs5EwNQk5PH52TM2GjbcouCILc+9VcraGxBFHSWnzEhaf8FU+Cg3ILFGPsFULX7FjZP181WJcPmglKkJtK6V1EPS2F14=
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
 StrF4zdnswBH1PNbSbBZbVShcLiRuGKqPdiy7XtXJS71oI2tZXZjtfnd5u4cxwHtDQJxWAC4LLWsvvpCxhiTbE0EXTctVuQ6TYavXb7wAkr0+lE57nrGiPlB71cDzPf1tGKek/W919hzNFsN0DwOOqB5CeuXOCDtBV46QX50AayG1FtHQUEOo2QMuBc/ZLI+NNtMdM21alDnXjSHzO+PewdtoFQrPdbYjgc4ltIAFYI/AmYvmvGbHs3RcOPyxn3BI+VZC/xvw9jLbXJn1S4Y9l5LsuyJU5tvS1pP2XLWRFjQUaKYf8kSxCN5krIjRqwd/9DHH6DKb6J/qbs1tHppyw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR08MB6191
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF000001A8.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	73603312-830b-42db-4cb3-08de85cfcacc
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|14060799003|376014|36860700016|35042699022|1800799024|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	I1QMC1+iu2sfO+1X7r7zu8+LmIeyY29GgUuuf02B2tuwyS2YoTa2FVk1NvrK8fuWgVCXmbTmFxvd3yGtbc4FsehbMCXOg9CHlf6/EqNoaeQbhpdqNTNBfG6SwE0Zz1XbAprlSZNKdHNVBY83hCQy5Ls0HaXMO6qPT4jFZ2VGIsYbaPXT3dyTLRV4XXNG+gbU2hy5rs12+x/cJexDZRxHwQIUbB3oZbARoChyTvJ13IxDxQOVmTsC4GPHckTsa6pdnUgM4sR2sYJDKeNziKktWVTvsVt9jA+wZ3FHUd8SrTMZKEF73J5ByvWWX4bgiOdCo4gxRZyqZTU7EotVr7gQFGi73/3Bhtfz3CKIl61MBE0UjC8pKAkgpyiw6WodS2Pw2vrRvPgBj9jVnKaW8yBsQC7zQsmGFQjeUNzuM+cSOW2WlkqMPvLYDWCOavqs9YpLYxqcq1XfpcNPJwPNx8AoWSfiMOQ/eLmg2HCbbfyqVARwUZnF8OLMPub6BGncKeERxm1LnkZWtZxSzQZ/lguwnkSXAaCf/YZvczzxHLr6rQS0r6FJNKyt2ZqZraNsxe7rJmR50ssp6Ho2Ghee2TBeozQkddpNkyNYuhjRM02b0Vdud3s3zTFUnyxmWtvVA7nUSo2Bb38fiYkLjZPiSeSw7s1Cz+4oXt01zdk/MNeqx73paKqgJjQ2AOOVeOZiwAyJI8nGEfimELp95zK7LZjh5AT0yenApt5/rHQKAuF0AQ0la3WPLK2ZeXngBhINot5vwM7/HzPvzO+xxdpFfdsPRA==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(14060799003)(376014)(36860700016)(35042699022)(1800799024)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	ad+WUfcSLE9yyDoiiUtRy4KNb2J1hBcf9S1ZAHApDBuV9Em0fmkmIYdw45RydEysGLDsRSBewA5V1SGwt6XOiSR3jrJkHMUmYR/gDbFrwvWyGNFmM9ZRHtBNGzD0AqLyfgZVTAVi3KbSvQoGQP3fC6ol8gNqR1s5b4rKxH8JpEORtzDXW+lIFCHpTXAYk7nBMO0wp+tFD/wnDAkv8B7z4VqK41Eqc0UBL8dVmwmX+hjhBXlOuBplIAnkESlMOFn7Wdtt3HsRwUAi0HSDYAymNXA/VdQhUaGWGmiP1kdF+lmyf8gKcIrr5RJ6ucHeT76EmY6CCQ7bv7O6rzTjyaJbVFlb4Y49WROdZLBfSxEjLRwULyqeUTFUsn2qBtjmNvS2VYxieE7iDTLr9uDoB37zmICZJkO/fxtHhrKWVQnD0uLiUoEpXzvjyxTyy46+c153
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2026 15:55:27.7639
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 04a661ce-d5ab-4654-b796-08de85cff0d7
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF000001A8.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR08MB6130

We only want to expose a subset of the PPIs to a guest. If a PPI does
not have an owner, it is not being actively driven by a device. The
SW_PPI is a special case, as it is likely for userspace to wish to
inject that.

Therefore, just prior to running the guest for the first time, we need
to finalize the PPIs. A mask is generated which, when combined with
trapping a guest's PPI accesses, allows for the guest's view of the
PPI to be filtered. This mask is global to the VM as all VCPUs PPI
configurations must match.

In addition, the PPI HMR is calculated.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
---
 arch/arm64/kvm/arm.c          |  4 ++++
 arch/arm64/kvm/vgic/vgic-v5.c | 35 +++++++++++++++++++++++++++++++++++
 include/kvm/arm_vgic.h        | 24 ++++++++++++++++++++++++
 3 files changed, 63 insertions(+)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 0b27e2c437be7..0e74e8da3e344 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -934,6 +934,10 @@ int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu=
)
 			return ret;
 	}
=20
+	ret =3D vgic_v5_finalize_ppi_state(kvm);
+	if (ret)
+		return ret;
+
 	if (is_protected_kvm_enabled()) {
 		ret =3D pkvm_create_hyp_vm(kvm);
 		if (ret)
diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 41317e1d94a2f..07f416fbc4bc8 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -87,6 +87,41 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
 	return 0;
 }
=20
+int vgic_v5_finalize_ppi_state(struct kvm *kvm)
+{
+	struct kvm_vcpu *vcpu0;
+	int i;
+
+	if (!vgic_is_v5(kvm))
+		return 0;
+
+	/* The PPI state for all VCPUs should be the same. Pick the first. */
+	vcpu0 =3D kvm_get_vcpu(kvm, 0);
+
+	bitmap_zero(kvm->arch.vgic.gicv5_vm.vgic_ppi_mask, VGIC_V5_NR_PRIVATE_IRQ=
S);
+	bitmap_zero(kvm->arch.vgic.gicv5_vm.vgic_ppi_hmr, VGIC_V5_NR_PRIVATE_IRQS=
);
+
+	for_each_set_bit(i, ppi_caps.impl_ppi_mask, VGIC_V5_NR_PRIVATE_IRQS) {
+		const u32 intid =3D vgic_v5_make_ppi(i);
+		struct vgic_irq *irq;
+
+		irq =3D vgic_get_vcpu_irq(vcpu0, intid);
+
+		/* Expose PPIs with an owner or the SW_PPI, only */
+		scoped_guard(raw_spinlock_irqsave, &irq->irq_lock) {
+			if (irq->owner || i =3D=3D GICV5_ARCH_PPI_SW_PPI) {
+				__assign_bit(i, kvm->arch.vgic.gicv5_vm.vgic_ppi_mask, 1);
+				__assign_bit(i, kvm->arch.vgic.gicv5_vm.vgic_ppi_hmr,
+					     irq->config =3D=3D VGIC_CONFIG_LEVEL);
+			}
+		}
+
+		vgic_put_irq(vcpu0->kvm, irq);
+	}
+
+	return 0;
+}
+
 void vgic_v5_load(struct kvm_vcpu *vcpu)
 {
 	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index b27bfc463a311..fdad0263499ba 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -326,6 +326,23 @@ struct vgic_redist_region {
 	struct list_head list;
 };
=20
+struct vgic_v5_vm {
+	/*
+	 * We only expose a subset of PPIs to the guest. This subset is a
+	 * combination of the PPIs that are actually implemented and what we
+	 * actually choose to expose.
+	 */
+	DECLARE_BITMAP(vgic_ppi_mask, VGIC_V5_NR_PRIVATE_IRQS);
+
+	/*
+	 * The HMR itself is handled by the hardware, but we still need to have
+	 * a mask that we can use when merging in pending state (only the state
+	 * of Edge PPIs is merged back in from the guest an the HMR provides a
+	 * convenient way to do that).
+	 */
+	DECLARE_BITMAP(vgic_ppi_hmr, VGIC_V5_NR_PRIVATE_IRQS);
+};
+
 struct vgic_dist {
 	bool			in_kernel;
 	bool			ready;
@@ -398,6 +415,11 @@ struct vgic_dist {
 	 * else.
 	 */
 	struct its_vm		its_vm;
+
+	/*
+	 * GICv5 per-VM data.
+	 */
+	struct vgic_v5_vm	gicv5_vm;
 };
=20
 struct vgic_v2_cpu_if {
@@ -588,6 +610,8 @@ int vgic_v4_load(struct kvm_vcpu *vcpu);
 void vgic_v4_commit(struct kvm_vcpu *vcpu);
 int vgic_v4_put(struct kvm_vcpu *vcpu);
=20
+int vgic_v5_finalize_ppi_state(struct kvm *kvm);
+
 bool vgic_state_is_nested(struct kvm_vcpu *vcpu);
=20
 /* CPU HP callbacks */
--=20
2.34.1
