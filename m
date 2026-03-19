Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013053.outbound.protection.outlook.com [40.107.162.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 824733E92A9
	for <kvmarm@lists.linux.dev>; Thu, 19 Mar 2026 15:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.53
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773935626; cv=fail; b=JH7HoVwrftPlSPL6wVh6S7/XTn2Lsz6lo5Lq7L2t50BtxFJ3+RNEnMKRvEIZAcnUBCBUr1tooqql6tWfGaUrocFmClUrU3fHnDgv4E84ApdkfHRM50+JgQfARmA9pmZohrwVznzTE87bgS9qn09jy1aUJmuEic2Fopeunrr8VRc=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773935626; c=relaxed/simple;
	bh=xszZ2UOCR1Qc0v1ZMkzA1x6kpM54fA4Sq7X9aNrMnNM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=LHVVRJ+OAKeRhYdZ6dbJv5QQS/5TjFPH8eW8k9f4yHFJbve1dKCoTjzwUCdZoDoTogR1wMmbIQQ931sKUo6GsfcSKqwbCun/dHNL5JbNK9Clqs7TmFbJ3Br3gTL8vsz+/Bpcl8Bw2cKYGOj1FnMT1lFcbo+AXgdKifT9mQRWYZ8=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Up+7Ntxv; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Up+7Ntxv; arc=fail smtp.client-ip=40.107.162.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Up+7Ntxv";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Up+7Ntxv"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=yJdVoP3e/oEbX2eYSEiLvrANbpLVGkfGOcQNf9jRmlFR5E6sNPN+JObbd0H1Y7OLc4lkZ1AvWwFEu5NNYrGwDvaJ0znVW+XtitgWSJyWZyoMmZoppDw+z/5bxai5/aVlDotEjUyOlxT+yfINSWhjzScN0OXLe2Mzb01PWdaFelYoWOtmfEMWVM7RIYXc3vc7M4n7hgoHUdReys4ZYmVIX++knqKf+nWhV+OaOOroN9BMXTu4sSZTBTKLoRKOgJ7NzsouFY6ih4Ev0Sp7JK6g8LZ+X6nn0iFVdpjLaFlwv6onnBgAgGmFv1uD5WSdZT5RDAo7rXxiF5vhRx00jspjVw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F/htmt20Zf5SxtZm+SMY5uWn76PrsOYo2MFd1evphZI=;
 b=hDclPIkCh3Prf9vnM+Y6f7j7TtHDj6p+hc5V717iVboypL3/u1ix5xm22v660ti2w8mx5MKKP7IH0DLvw6qNlo1/0H6KhPs7CcMCFRDglvbuWqL557LSYhPCJ5q8TMI7Q0oUX/THpK1qN1tlovagjMdpR5jboyouPyois6tbyUa2mw69a0wpKq5ZW6ay9iuAnTs67v3IvAMq+sdm1lwJY/JNnpqeji25yBkjlyX2psCO3ZDm/7LmE9wDv6aiOj0McEK3DqhcMtjtygN6LipDr6ddl7/GDnZoW8iu1jvtC7woRt+0iecG8CiGg/PFtLs4ndTYEZ4INi1y55Hz0lV09Q==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F/htmt20Zf5SxtZm+SMY5uWn76PrsOYo2MFd1evphZI=;
 b=Up+7Ntxv3e3za3Q/L62Xrea4D2fATdVOCCoGtl6eEnosQRnWb3HbV2mFbvjGSj3yWt6zOsMg5t0zgcE3oWOqfGP/kU3u6HyrJnX0VBq/Be/HvoGEwSkRFAb7T+oKq4c/Rnp9/ZwnFw2R2iLTpe2gqOe5eLBAj5r51X5d24rbeZk=
Received: from DU7P191CA0019.EURP191.PROD.OUTLOOK.COM (2603:10a6:10:54e::33)
 by DBBPR08MB10796.eurprd08.prod.outlook.com (2603:10a6:10:530::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Thu, 19 Mar
 2026 15:53:38 +0000
Received: from DU2PEPF00028D01.eurprd03.prod.outlook.com
 (2603:10a6:10:54e:cafe::96) by DU7P191CA0019.outlook.office365.com
 (2603:10a6:10:54e::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.27 via Frontend Transport; Thu,
 19 Mar 2026 15:53:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF00028D01.mail.protection.outlook.com (10.167.242.185) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.19
 via Frontend Transport; Thu, 19 Mar 2026 15:53:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=j3Dn0mH5LLOMOmbuQKCS83G7iLxSXa2DiunnKo69tYMJibwePhUfjz3qNgsva1Y+K8+do2uWqvxJX/P/jVsdeT1DjoJLgDWDQzk9XoTopzCbOIPj/fJiHbl6CFRPTxf2abKN3M72pVi4hcDaQWrpS2gv6tla3qdC7Ed4aDgu9Dn6TJzwiTrRIRdfve/CqZuP8xbh8YPbu1M5LToW6rrmL2NksR3RwgykTWE2OHrvul1oed+siUL0GWoX8bvLoM43K2ivRRerPVN0KUMpF/T3CcA5+OcCdUnOvbZgOj/ivViTtBYEgT4eyaOSymbBgzVsNtMecVCkb7A5JsClQrb5fA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F/htmt20Zf5SxtZm+SMY5uWn76PrsOYo2MFd1evphZI=;
 b=NPPiytHh6vsvgps5UUOGDSPG5Jjbs5pW5OwU7KfHGbR2p/ByCr5C3G0q7LscPqyKj+UO7kYvXOE0eCXd2WDOZdMQAyNZ9VLecZDHte0/9fQWeFyG0rNf1OIyG0BmztXsMD9q6ju82v+6L7Uf7wOSF+CVqLiXZkQ2Cx6h+fOgu1EpELDtElTeAPJo0DmF2AyRI6Q0ERuk49unET/irsOrOPo7rLmxeG92CbfM+ekv7TUJSrASlSzTaryF+Qae+Mvp7bfAIkpJUklsnx4kaFvG7k7phIq15dTFvBSyE0/656LoZgN4QwJGY9wgj68KVcEYSLPfhm3QTgLXXoaBYzQHxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F/htmt20Zf5SxtZm+SMY5uWn76PrsOYo2MFd1evphZI=;
 b=Up+7Ntxv3e3za3Q/L62Xrea4D2fATdVOCCoGtl6eEnosQRnWb3HbV2mFbvjGSj3yWt6zOsMg5t0zgcE3oWOqfGP/kU3u6HyrJnX0VBq/Be/HvoGEwSkRFAb7T+oKq4c/Rnp9/ZwnFw2R2iLTpe2gqOe5eLBAj5r51X5d24rbeZk=
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com (2603:10a6:20b:504::10)
 by AS2PR08MB10250.eurprd08.prod.outlook.com (2603:10a6:20b:641::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Thu, 19 Mar
 2026 15:52:35 +0000
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27]) by AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27%6]) with mapi id 15.20.9723.018; Thu, 19 Mar 2026
 15:52:34 +0000
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
Subject: [PATCH v7 11/41] KVM: arm64: gic-v5: Detect implemented PPIs on boot
Thread-Topic: [PATCH v7 11/41] KVM: arm64: gic-v5: Detect implemented PPIs on
 boot
Thread-Index: AQHct7hnsQw5+tNnM0Kw+jZpQE1+qg==
Date: Thu, 19 Mar 2026 15:52:34 +0000
Message-ID: <20260319154937.3619520-12-sascha.bischoff@arm.com>
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
	AS4PR08MB8241:EE_|AS2PR08MB10250:EE_|DU2PEPF00028D01:EE_|DBBPR08MB10796:EE_
X-MS-Office365-Filtering-Correlation-Id: 2ac21c9f-de57-476e-fc19-08de85cfaf07
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|38070700021|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 2T4/6Ae99Jldr7pojyxY322j5VplGQSA+4HFgyjmTELj8OTD+h5Li3QlWup9Qjmgo2+2B5VTIEsa7U7CHRjsXbn3EBjskq12WRnVgB93peVIEjWJMhUuGEPSps1E8gvm6MgJvwCIDRAYxXs3zqFpTWqBDGuOBQ7ePtQsv5ueAhcBSqY7NucPu4vJbfAMeuTH3d0aR6m0uSDGAdjmbhgj0hB2No75mqGKXgXu07vjwKLP8LACZewOgEsMe2UhGSnnNcCfkO1lxnTRq9Y29buqN27gWHwzVUuzJSHpMnTzUSFKhghHj5G6AMpHwIcjRkqKPJTQYt+L7faJFfE/r5fKYUQul2XTFbJdf/j+mVnFSupuLdlv/Pld1nazKVnWQXcAzHyWquccbsW6Q88Ae02G27VyAAWvXacWUER0HYISk0oRZ9CJeb0+2wGIFjnKlGjNqNYV8Eurll3Vt4Kl1bhi/8foHZsJqjW7gfXibzaUQgqWHLmsBkpAd0LGmAlSXIZ7Ttd2B5kENEKxHWKEcMob4vNutdPFhXv4QFmiJJIacXzjYy0SNbxH/AgWR7IUf1llYNPhu4s3le8lKM30m/otiMQARyb3d4AmN3BvVEo9nBAv5obT9Ms3+q9ZGRHAxANvkcgf/h5t0ESP+VHbffvIeR4lBV34crfX7kOxp9NqDnflsJXL9YWJTlU4Rou7kVz4wQmowDojMp41Jxnd6Kmx34mPtB0xlvtheG6sKZk14XqA1ibusAMyA72KgwdNAssYDqvGfsOZ56iv5QkxifLL7PKLCofo2MfdiaW4XhSpMlc=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS4PR08MB8241.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 Jxd1spKKcKOqlbyrmtZWtQRJhUn+JvWw+MymiHp/fTj0iBWtYSp4XsinSx3h64w+D50mB9UoL9pQZvedp8FEGTuxzrOPWF5T9FFMGVaTIY648fuqgLYBa9h/GpPgPbwceluDdX8Qjj1S5NmaO2yBnKC21srM8p688yjiN+ZMZtrfpCxwrQQJ2sHpOmcujun6ghdu/bDE0uw+4+kpRMcRZvxfEKZx1wqi7LDZ0jmHw5wxIViOgR7bRA2N6fYshKUcdJAd9YCBmyBG/gyGQJpQ32hKyUIO/sutlvKuZL0Hzb89ydJDxBS2y5UkMBs4o99BGhzQruw8a3DMNH/nleBIIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB10250
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF00028D01.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	83468c65-060d-423c-cc9a-08de85cf89a3
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|36860700016|1800799024|82310400026|14060799003|376014|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	7lWEvYeRE63nRIkemj7rtO3dS/TDze9SC4MAOW2p4puwTucC0OaVrDNN29Em7k4w7TBlLdvEf+DWcO07hmqXQIyUf4a+WdBtoc5ovFSj8aev89vi/rqizkwPpQOKOIJOV2BufEecK7YOYHkcvgBx5jPQKnMWlGHdQBIlTTMzzij+SfYXrDbPlro5Lihzn2rtipiJEIeL9IrzLj+19knZvY84sqZm7RM86zpIIcyA32CRolXhJu7bVbrkLElKurmlwlzpIfVCqElEiGZwPSYSdClH1ckN+SHNrz8a1pZJrTYHFdtxZJqHApNTbdA6pOsCGH19t5Lp9EFEGaJZrffKpXbnJigUzD0ufHooyGGhligIcgyNRpRpMHni501/Q50stScq0eJWmjtOYKtTufceqhPVhGAAVNttRPZ6oM0Weg6FdVW8D0BIzAABfK3+h3ljS2I2slT3D+3ukWb7asFXyzZkFi545NBSFrkkF9aWFJtYaVzm3gIHaHHt+oG6JXvr7nRDpji8VDqQ4dAGg0sN/mYJ+19r5ri6lMD9Kyor44e1g03s2wlCDMEsLdu8xioWPumZnN+BArDd/uqqDmnt2rzXd3f/HAph2vZ0hLbXMKiEebB8XJTUfWRl1dvc3QCIVAzqkryPIJouqvVhvEITvxjwlprtLe84HOwKzObSKp0tKXBY+gLw/nq0W/O9xRlIUcODTgeVwjBQmdYA+/C88xoDZ0/2SEVjci6hWXa0odwPn89Z5y/09aewHo2ohUOZJkGQkbgGQyQua6OhwhUiuA==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(36860700016)(1800799024)(82310400026)(14060799003)(376014)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	+q8PkeX10qaCQpi7XRX/+/w7kjA7WFIggyeUQC9Snu8g0M80hf3nrI+AKqLWqF8S6AKtgKh4Uci1WbDHUqexnPxGVx+bYSUEnihoKeydkqFDHuITUm5wAFN7snH4b+7wfUckhKteDl4DYBCR069PT3xdr9fKPlaybfTsgq7QwSuglk7d25zZRhBw2JV4AjsgfoAnXKwLBMLvZoynpLozc2abSKueBUhtPBTMp7iMsOaSaBJ/nMmZGEl/705nSA8kBDT4XZT6bMDua5VtYXY2UuOPGyW1YrWpGtUtKdVC3azkPg8Hw49hKiRFtZLkYPOscAl1FZZSdpjrCgLx+3TGuQyNRb72Y3AgEJo4iu4bh06qNL5ySisuylF7uHPIFYQieNOLGvWozkJZrlkQQ50gu4CFfk6mEKFW+Co7hS3SppRVV010cLyujrof55lM3uV3
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2026 15:53:37.3365
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ac21c9f-de57-476e-fc19-08de85cfaf07
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF00028D01.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB10796

As part of booting the system and initialising KVM, create and
populate a mask of the implemented PPIs. This mask allows future PPI
operations (such as save/restore or state, or syncing back into the
shadow state) to only consider PPIs that are actually implemented on
the host.

The set of implemented virtual PPIs matches the set of implemented
physical PPIs for a GICv5 host. Therefore, this mask represents all
PPIs that could ever by used by a GICv5-based guest on a specific
host, albeit pre-filtered by what we support in KVM (see next
paragraph).

Only architected PPIs are currently supported in KVM with
GICv5. Moreover, as KVM only supports a subset of all possible PPIS
(Timers, PMU, GICv5 SW_PPI) the PPI mask only includes these PPIs, if
present. The timers are always assumed to be present; if we have KVM
we have EL2, which means that we have the EL1 & EL2 Timer PPIs. If we
have a PMU (v3), then the PMUIRQ is present. The GICv5 SW_PPI is
always assumed to be present.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
---
 arch/arm64/kvm/vgic/vgic-v5.c      | 31 ++++++++++++++++++++++++++++++
 include/kvm/arm_vgic.h             | 13 +++++++++++++
 include/linux/irqchip/arm-gic-v5.h | 22 +++++++++++++++++++++
 3 files changed, 66 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 9d9aa5774e634..cf8382a954bbc 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -4,10 +4,39 @@
  */
=20
 #include <kvm/arm_vgic.h>
+
+#include <linux/bitops.h>
 #include <linux/irqchip/arm-vgic-info.h>
=20
 #include "vgic.h"
=20
+static struct vgic_v5_ppi_caps ppi_caps;
+
+/*
+ * Not all PPIs are guaranteed to be implemented for GICv5. Deterermine wh=
ich
+ * ones are, and generate a mask.
+ */
+static void vgic_v5_get_implemented_ppis(void)
+{
+	if (!cpus_have_final_cap(ARM64_HAS_GICV5_CPUIF))
+		return;
+
+	/*
+	 * If we have KVM, we have EL2, which means that we have support for the
+	 * EL1 and EL2 Physical & Virtual timers.
+	 */
+	__assign_bit(GICV5_ARCH_PPI_CNTHP, ppi_caps.impl_ppi_mask, 1);
+	__assign_bit(GICV5_ARCH_PPI_CNTV, ppi_caps.impl_ppi_mask, 1);
+	__assign_bit(GICV5_ARCH_PPI_CNTHV, ppi_caps.impl_ppi_mask, 1);
+	__assign_bit(GICV5_ARCH_PPI_CNTP, ppi_caps.impl_ppi_mask, 1);
+
+	/* The SW_PPI should be available */
+	__assign_bit(GICV5_ARCH_PPI_SW_PPI, ppi_caps.impl_ppi_mask, 1);
+
+	/* The PMUIRQ is available if we have the PMU */
+	__assign_bit(GICV5_ARCH_PPI_PMUIRQ, ppi_caps.impl_ppi_mask, system_suppor=
ts_pmuv3());
+}
+
 /*
  * Probe for a vGICv5 compatible interrupt controller, returning 0 on succ=
ess.
  * Currently only supports GICv3-based VMs on a GICv5 host, and hence only
@@ -18,6 +47,8 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
 	u64 ich_vtr_el2;
 	int ret;
=20
+	vgic_v5_get_implemented_ppis();
+
 	if (!cpus_have_final_cap(ARM64_HAS_GICV5_LEGACY))
 		return -ENODEV;
=20
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index b8011b395796d..0fabeabedd6d7 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -32,6 +32,14 @@
 #define VGIC_MIN_LPI		8192
 #define KVM_IRQCHIP_NUM_PINS	(1020 - 32)
=20
+/*
+ * GICv5 supports 128 PPIs, but only the first 64 are architected. We only
+ * support the timers and PMU in KVM, both of which are architected. Rathe=
r than
+ * handling twice the state, we instead opt to only support the architecte=
d set
+ * in KVM for now. At a future stage, this can be bumped up to 128, if req=
uired.
+ */
+#define VGIC_V5_NR_PRIVATE_IRQS	64
+
 #define is_v5_type(t, i)	(FIELD_GET(GICV5_HWIRQ_TYPE, (i)) =3D=3D (t))
=20
 #define __irq_is_sgi(t, i)						\
@@ -420,6 +428,11 @@ struct vgic_v3_cpu_if {
 	unsigned int used_lrs;
 };
=20
+/* What PPI capabilities does a GICv5 host have */
+struct vgic_v5_ppi_caps {
+	DECLARE_BITMAP(impl_ppi_mask, VGIC_V5_NR_PRIVATE_IRQS);
+};
+
 struct vgic_cpu {
 	/* CPU vif control registers for world switch */
 	union {
diff --git a/include/linux/irqchip/arm-gic-v5.h b/include/linux/irqchip/arm=
-gic-v5.h
index b78488df6c989..b1566a7c93ecb 100644
--- a/include/linux/irqchip/arm-gic-v5.h
+++ b/include/linux/irqchip/arm-gic-v5.h
@@ -24,6 +24,28 @@
 #define GICV5_HWIRQ_TYPE_LPI		UL(0x2)
 #define GICV5_HWIRQ_TYPE_SPI		UL(0x3)
=20
+/*
+ * Architected PPIs
+ */
+#define GICV5_ARCH_PPI_S_DB_PPI		0x0
+#define GICV5_ARCH_PPI_RL_DB_PPI	0x1
+#define GICV5_ARCH_PPI_NS_DB_PPI	0x2
+#define GICV5_ARCH_PPI_SW_PPI		0x3
+#define GICV5_ARCH_PPI_HACDBSIRQ	0xf
+#define GICV5_ARCH_PPI_CNTHVS		0x13
+#define GICV5_ARCH_PPI_CNTHPS		0x14
+#define GICV5_ARCH_PPI_PMBIRQ		0x15
+#define GICV5_ARCH_PPI_COMMIRQ		0x16
+#define GICV5_ARCH_PPI_PMUIRQ		0x17
+#define GICV5_ARCH_PPI_CTIIRQ		0x18
+#define GICV5_ARCH_PPI_GICMNT		0x19
+#define GICV5_ARCH_PPI_CNTHP		0x1a
+#define GICV5_ARCH_PPI_CNTV		0x1b
+#define GICV5_ARCH_PPI_CNTHV		0x1c
+#define GICV5_ARCH_PPI_CNTPS		0x1d
+#define GICV5_ARCH_PPI_CNTP		0x1e
+#define GICV5_ARCH_PPI_TRBIRQ		0x1f
+
 /*
  * Tables attributes
  */
--=20
2.34.1
