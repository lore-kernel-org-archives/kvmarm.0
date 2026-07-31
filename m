Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012009.outbound.protection.outlook.com [52.101.66.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAAB9307492
	for <kvmarm@lists.linux.dev>; Fri, 31 Jul 2026 08:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.9
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785488221; cv=fail; b=R1Cx/TbzKPbSZ66aU2wWdZTzzYlztXB6Z+XY39GhD+D91qDUvzetK4XO0FAj2iu3wUweCnD2NNvxDCrrnEn8QJGgjrLUHECMdcrW95NQiCcwqhapusfRUn/f9mL3VXu74iMFdgxH8yJFQ3yvLDdGejZjddsKpt1JAnaalbiaSv4=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785488221; c=relaxed/simple;
	bh=FIViNb0iKled/ZPN6TC1886+aQPJsEXZ/Ff5ck6K71g=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=XWh/AXc0+6dVU9QC6VD39W+++CxYFP8uyCtwViAdp/yNyJtUpOZujmee4PbsIxHYV9HTaNr4SDZKg7m0bsz+YWxjercut08y24nYatPzV1wGYFsYAhJcB6+oOjV58lE6YzzCdGxQKSehFkuA9++Kgi+5gXClLTZDPF0gHeon9xs=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=QoupnApS; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=QoupnApS; arc=fail smtp.client-ip=52.101.66.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="QoupnApS";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="QoupnApS"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=KZexe/DvB4LXUxeS0ayAvjDxt6BBGpssaqcP8151op/j2ZK8mVAvpyeHugJS/nKAEKn/HBNQjM4iGWgyBHlvmnCgzpNuib00mtzfhoPcs9IhfWqIssPIRWScWuRVtgr5kWVDtQ11cohfQVu5LBN9BUBAqvC01C3MGflUJpy56LwN0mHbfy7iMxUXMypaqAKRSoaUPodf7zYjKpptADsXmKXa/UATirvRe1J3zkfJlDdnaBHufRc0/8lqcKd7e1UAjo0ho2uCXhg6EeVaGQ0IKGr7LuQbOKULubRI1Oyje8WYxvbfqR6CPGXniZCeUqZSRNIALIFvUPyk/jAzE4pk4Q==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FIViNb0iKled/ZPN6TC1886+aQPJsEXZ/Ff5ck6K71g=;
 b=vLXLy/U6q6FjFswbkyLevb2WkWtiStJqHluj7X14f+1zJlfNe2v61kJQ2yhMYM5l6YwCimgi1yaPwiVwqfCb5Vsd3FumHozb17Mw3pQBkKPGr+0cQGkpfiRpz6VZyYKMM/epH+z/yCvyt2WIw0dkfiem83PQ8SHZQaqMVLny86OuJn7SF6A/grGdyrJH6cU+Oz0v/jAcGU0dCmGnMsowpxJOHXv60npB7NFBW2OGm9AtLkg5UUhuoOKYGKZpuwr+FKo0HquqouDRpWwJICxh3VnjIm66t6TFHcRnuhUCXLA5Niw30LY38xozcaiFen8M/3wdrq6PzQliZSc4KFY42w==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=linux.dev smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FIViNb0iKled/ZPN6TC1886+aQPJsEXZ/Ff5ck6K71g=;
 b=QoupnApS49Ro/rKPy5s/EBk7BxkBWaMEU38OZhDSCgbpOSlv4ZSE+Gxdr6fR9mnDtY+CzFbhoX2HdxMnXUsJzFdjLTGelsAEy3QK5tj324xCdgyOKSo7aGQ+TBwo9Fp27jAXdD0KjCHjj4WQwsE+3JiCoUYcBxr8c7XUWIFIDMw=
Received: from AS9PR06CA0682.eurprd06.prod.outlook.com (2603:10a6:20b:49c::27)
 by GV1PR08MB8308.eurprd08.prod.outlook.com (2603:10a6:150:a5::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.15; Fri, 31 Jul
 2026 08:56:50 +0000
Received: from AM4PEPF00027A6B.eurprd04.prod.outlook.com
 (2603:10a6:20b:49c:cafe::4c) by AS9PR06CA0682.outlook.office365.com
 (2603:10a6:20b:49c::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.15 via Frontend Transport; Fri,
 31 Jul 2026 08:56:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM4PEPF00027A6B.mail.protection.outlook.com (10.167.16.89) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.8
 via Frontend Transport; Fri, 31 Jul 2026 08:56:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FYiRtxYoOhwrXzEUdcnlQnsN4AjUMb9RhpzgsQFcC9PfwyYzb/rbSLo1dbG7JBmrlSiUvpH9LWaz0IwHfmSVDIpCJqRSjJOgumGrYSwSDffSkgpWpmbAOdKLBcKb45J5OkffoTp3SgW3mPdqJia8t9S1ON744lJv6ThwyzWMQMiMBAWcqVHV1JLKilGT/shVBcTwY6+lB8kZmhNBWdjDWD5NsO9KCivfvUMi0k3SCel5BjANEP6WLWuSRJy1z7l78USX81DOVu11EHPVSaHldOJHk6uZpE9UtZOp85aICVHGo0HwAlZO3rb60kZgFXBM9jeZc5dSSnGzfSaNIh3hTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FIViNb0iKled/ZPN6TC1886+aQPJsEXZ/Ff5ck6K71g=;
 b=d2PmBT32H6+ZC/pe0kyKBUzr6TzupGBSKhmoiDiyCVKi6BtSDiM5fKpN2u4nxCwjLiaZaOe/lvQUruoEX5NfE/N49g+ABoXLjnhzvJhz1vcnU8M5XBf9I0OF3INJUD7Mj6h6+Enk433NSDqkkBS/++muTObB3Iz+WXGjzRroNjqd1DVsWc3/BgOZSneH+Yc8hDr5oMX56gq/DRNaZ8LnnlOIS9lgJETsKEG1rcmrZR0bdaMtMYhnI3+t+rNJiBAFXNnvma/TINWzeeaeODkcMb9BeP6UoXvQbtZyxfb7kIUanM6c+gu9+j9v7c0Y0RHgiA3zAAmp8XglcPstM4IPFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FIViNb0iKled/ZPN6TC1886+aQPJsEXZ/Ff5ck6K71g=;
 b=QoupnApS49Ro/rKPy5s/EBk7BxkBWaMEU38OZhDSCgbpOSlv4ZSE+Gxdr6fR9mnDtY+CzFbhoX2HdxMnXUsJzFdjLTGelsAEy3QK5tj324xCdgyOKSo7aGQ+TBwo9Fp27jAXdD0KjCHjj4WQwsE+3JiCoUYcBxr8c7XUWIFIDMw=
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com (2603:10a6:10:407::19)
 by DU0PR08MB9629.eurprd08.prod.outlook.com (2603:10a6:10:44a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.15; Fri, 31 Jul
 2026 08:55:46 +0000
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e]) by DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e%5]) with mapi id 15.21.0270.012; Fri, 31 Jul 2026
 08:55:46 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "fuad.tabba@linux.dev" <fuad.tabba@linux.dev>
CC: "yuzenghui@huawei.com" <yuzenghui@huawei.com>, "lpieralisi@kernel.org"
	<lpieralisi@kernel.org>, Timothy Hayes <Timothy.Hayes@arm.com>, Suzuki
 Poulose <Suzuki.Poulose@arm.com>, nd <nd@arm.com>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, Joey Gouly <Joey.Gouly@arm.com>, "maz@kernel.org"
	<maz@kernel.org>, "oliver.upton@linux.dev" <oliver.upton@linux.dev>
Subject: Re: [PATCH v4 35/48] KVM: arm64: gic-v5: Implement save/restore
 mechanisms for ISTs
Thread-Topic: [PATCH v4 35/48] KVM: arm64: gic-v5: Implement save/restore
 mechanisms for ISTs
Thread-Index: AQHdG1s2hyISS/J40E6VsYHBmGEMzLaBvGoAgAWhnoA=
Date: Fri, 31 Jul 2026 08:55:46 +0000
Message-ID: <7b25b4313db1bab3f82679b1c2fe5e7925cc66c0.camel@arm.com>
References: <20260724104819.1296803-1-sascha.bischoff@arm.com>
	 <20260724104819.1296803-36-sascha.bischoff@arm.com>
	 <CA+EHjTwrx6Ce4LMHFz9MNGo87PvFFHxEOY7Dqrk85j3W+wDtxQ@mail.gmail.com>
In-Reply-To:
 <CA+EHjTwrx6Ce4LMHFz9MNGo87PvFFHxEOY7Dqrk85j3W+wDtxQ@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU0PR08MB8421:EE_|DU0PR08MB9629:EE_|AM4PEPF00027A6B:EE_|GV1PR08MB8308:EE_
X-MS-Office365-Filtering-Correlation-Id: 2ad8e62d-26a0-49a6-27b4-08deeee1a8fc
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|23010399003|376014|18002099003|22082099003|56012099006|11063799006|4143699003|3023799007|38070700021|10067099003;
X-Microsoft-Antispam-Message-Info-Original:
 2qiwIwruOB3JibFkgRQUNVrCqYtxh9BIRkvy1YhxFf9KXzOd7IlvCRUgmu86114kGUy4wP6mIIOvlY03lDtVwU0EbHHGWxuZe8bMxV/oyj9sOBnU7kToOefBqcfA5y5g/7R+Wzk0d1w/NkldXx5jKN5enyWXW6yO3wpcSRZ0HERZUHFb+nersMgpKyMiaJNXcP+4P5DDHA3hymjYJkG0hMUfLXLkPzEnsABbjKnW6OQdsWuntcnnldCBJV9AdwOw3Va2S9YcOWkG3JMv3JlDUa64JonGp5xW9Q86hvVvNIkevdfM6McOKLcVveMVkInk8KXynZshJVs1jA1yk4Vzfduz7B0LpgmyTxVIld4ZZ6mOjTMdu3LmmKF2QVVu/PfWmnIBFdoBWdmK/rn7qCgIO1CmhkwTe5KNkX5cM6nIhSdsRGWd6jMDwiI4V7Dds4lZny5n4DlG0m3R1va8ggl7pVeEMqKZl4jftPf0x5hCyASIYu4tQkTfDQpnEviAyvAzqr9Mj+lfuJMSG7riAn+PtkAFUb8zbDV2+qvYNTGQ4hKs/VfwemKEwNJvtkRnTyOfr3KFADsEu03sCJSLbVsWCjHY/+iCQyhwqMBOfg+hG2/KOejHsG84+i6QakWQdWit5TXKYzx3Ct61si3aGBD1KTJHhbzdr1/1CqButSzsW7u+0TbAXDg/VVu9IbiVia+x2nZBLR7v5638JDkgNmNCCX9fBnsihK2v0NNjICYyIoM=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB8421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(376014)(18002099003)(22082099003)(56012099006)(11063799006)(4143699003)(3023799007)(38070700021)(10067099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <97BA1473E351544A9D8BB729D451CAC8@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 GtwKcC4KHTVg8sW/KECeDWQzfR/RYaRkxztYD+fgwre/rhXavb6sytL1Ed2FkJ+E7oy6Am9Fvm3AeY/0WKMjFJdsGVW0o+z7XeJCNxRRJoUx7jcD15YMeE4ACwtyz9eHArC7czZFwZxEC8hpCG12yp8tALgjaVTpCJOzTwqKU1VAODPsFGqDZKHYWPjw9rf1/9Vr483nFg9ZNq1IdtuyFaIieRutVg5uwW31FgWnhA+5YJPmdR/cv/AAej8qRCtGMFW4w999VPaPVD2JJeN0mb8NITQ3niW6hl98bRywhXdMXIeKxuVwBq13Khgt/1QP5dJ4JiUOUOrBs/GneBs6Gg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB9629
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM4PEPF00027A6B.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	804cc8ea-4d7c-48b9-1624-08deeee182fa
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|35042699022|376014|23010399003|14060799003|1800799024|82310400026|11063799006|56012099006|10067099003|4143699003|18002099003|22082099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	SAgWZfhdgLv6vFM9OmwtDvvG5ocHZeCqtXVokkpzZ/D/ufpF4GN4rljPjrxRG71KA3r/L+VjvGjxNdgYzZd8wY/CSiiajJHCO8ypOQ0/kU8djDUia+NmbfgIBleM0QxrK7I0lz7MdSiMTgJlP4VCTxRIDfxi5/tz4VrgIgPQ7BQdWowo0vBj2qkcEcOVPHuCdSw23uwfoPRGjNXxLkM+DDWxXtqPsaf9aaXKJ+TqgB3fDpz5LQ/sk3wT4olfwbs9yb7YH5Tife2/zOoCvaQjbf/f2iRbdzqLZL7FhDnCFiIp1T8zolfEvAi3vV2ByDAUCeWyGDZVo+QHSuSApOynCqTYT43O3KYoBc/urrnrTSN2MCviPajdpMBLcS4d4k4GwsADJmCb9z21BzOv0diLFBROguTAc9Ktmt56dy7NtihAuCX+lrobSa+6kykb2iZjx+zYhifZeYnnfSJg7dMFOMHSx8GmlSWrMB8LqKuOMt47Ze1ZFUPJPfs9mFKawX5ttF+wg0LQRGZaUKy1n5kprBnIq/KNTw6Roz7N6m3Zj9S7qX34TC2Y0P+EmxbrDy8x0bQwsL0aZFF8YG66XwmroPyQP2nrIq6if+F5UP6m5AkBSd2yH0vB9a8XUvrDzItXX1d2bRukmm3Ip5fmePz3kBJHAwESaUvLN/aP1q6U6eg0TnnwXJGAUXMn5U9C3nidGy5GNortaEvKFbMOCnNvsQ==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(35042699022)(376014)(23010399003)(14060799003)(1800799024)(82310400026)(11063799006)(56012099006)(10067099003)(4143699003)(18002099003)(22082099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	3AKGI5L+YBC5G6PehLO0ZMdUkTQY0MmFkMG0fPF2AScbc8TkNLemiegxXpBW5Ff4s8SYSLFktzETTLV4zMlmpPUbDi4UbzDekYnD9jYgPprTfQdBOgLhyT7Fs8yxatFrJgC2aTA4sGixThHdCNhqAqF/MrA9CEOwR/WZuGqYa8jvLQMX2/Dp25MkgG9SO4FZmCyT3NjWMDO+DqYk+ZPzydcDrFN0dUG25RwruFmfJXNaPX0v/f8qlFUhmjrxYkmrE62o+ZhD5U+Vq8I6So9Hy10eRLZykMV/D6+FpvzRF2Wp+VCQZJArsSiE+Ydh7dP4vHvx9VYdI2G2SW+K4vyN2v1f0J1KVMj/OAy3ka2SP8rPBTD7lGvCkRlrt75g80DGFvLihZaMIXpBFEI2x9u8uSOcz+tCG2i2eGjUO1DCGPw77kKQzGP3422IxlIiJPhx
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2026 08:56:50.2339
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ad8e62d-26a0-49a6-27b4-08deeee1a8fc
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM4PEPF00027A6B.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR08MB8308

SGkgRnVhZCwNCg0KT24gTW9uLCAyMDI2LTA3LTI3IGF0IDE5OjU2ICswMTAwLCBGdWFkIFRhYmJh
IHdyb3RlOg0KPiBPbiBGcmksIDI0IEp1bCAyMDI2IGF0IDExOjU4LCBTYXNjaGEgQmlzY2hvZmYN
Cj4gPFNhc2NoYS5CaXNjaG9mZkBhcm0uY29tPiB3cm90ZToNCj4gLi4uDQo+IA0KPiA+ICsvKg0K
PiA+ICsgKiBTYXZlIHRoZSBMUEkgSVNUIHRvIHVzZXJzcGFjZSBtZW1vcnkuDQo+ID4gKyAqDQo+
ID4gKyAqIFRoZSBMUEkgSVNUIG1heSBiZSBsaW5lYXIgb3IgdHdvLWxldmVsLCBzbyBob3N0IGl0
ZXJhdGlvbg0KPiA+IGRlcGVuZHMgb24gdGhlDQo+ID4gKyAqIGFsbG9jYXRlZCBob3N0IHNoYXBl
Lg0KPiA+ICsgKi8NCj4gPiAraW50IHZnaWNfdjVfc2F2ZV9scGlfaXN0KHN0cnVjdCBrdm0gKmt2
bSwgc3RydWN0IGt2bV92Z2ljX3Y1X2lzdA0KPiA+ICppc3RfYXR0cikNCj4gPiArew0KPiA+ICvC
oMKgwqDCoMKgwqAgc3RydWN0IHZnaWNfdjVfaXN0X2Rlc2MgaXN0Ow0KPiA+ICvCoMKgwqDCoMKg
wqAgdTMyIF9fdXNlciAqdWFkZHI7DQo+ID4gK8KgwqDCoMKgwqDCoCBpbnQgcmV0Ow0KPiA+ICsN
Cj4gPiArwqDCoMKgwqDCoMKgIHJldCA9IHZnaWNfdjVfZ2V0X2xwaV9pc3RfZGVzYyhrdm0sICZp
c3QpOw0KPiA+ICvCoMKgwqDCoMKgwqAgaWYgKHJldCkNCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoCByZXR1cm4gcmV0Ow0KPiA+ICsNCj4gPiArwqDCoMKgwqDCoMKgIGlmICghaXN0
LnByZXNlbnQpDQo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcmV0dXJuIDA7DQo+
ID4gKw0KPiA+ICvCoMKgwqDCoMKgwqAgdWFkZHIgPSAodTMyIF9fdXNlciAqKSh1bnNpZ25lZCBs
b25nKWlzdF9hdHRyLQ0KPiA+ID5scGlfaXN0X2FkZHI7DQo+ID4gKw0KPiA+ICvCoMKgwqDCoMKg
wqAgaWYgKCFpc3Qudm1pLT5oX2xwaV9pc3Rfc3RydWN0dXJlKQ0KPiA+ICvCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgIHJldHVybiB2Z2ljX3Y1X3NhdmVfbGluZWFyX2lzdCgmaXN0LCB1YWRk
ciwNCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIEJJVChpc3QuaWRfYml0
cykpOw0KPiA+ICsNCj4gPiArwqDCoMKgwqDCoMKgIHJldHVybiB2Z2ljX3Y1X3NhdmVfdHdvX2xl
dmVsX2lzdCgmaXN0LCB1YWRkcik7DQo+ID4gK30NCj4gDQo+IFRoaXMgYm91bmRzIHRoZSB3YWxr
IHdpdGggdGhlIElEX0JJVFMgc3RhbXBlZCBpbnRvIHRoZSBWTVRFIHdoZW4gdGhlDQo+IGhvc3Qg
SVNUIHdhcyBhbGxvY2F0ZWQuLi4NCj4gDQo+IC4uLg0KPiANCj4gPiArc3RhdGljIGludCB2Z2lj
X3Y1X3ZhbGlkYXRlX2lzdF9hdHRyKHN0cnVjdCBrdm0gKmt2bSwNCj4gPiArwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oCBjb25zdCBzdHJ1Y3Qga3ZtX3ZnaWNfdjVfaXN0DQo+ID4gKmlzdF9hdHRyKQ0KPiA+ICt7DQo+
ID4gK8KgwqDCoMKgwqDCoCB1bnNpZ25lZCBpbnQgaWRfYml0czsNCj4gPiArwqDCoMKgwqDCoMKg
IGludCByZXQ7DQo+ID4gKw0KPiA+ICvCoMKgwqDCoMKgwqAgLyogV2UgYWx3YXlzIGhhdmUgU1BJ
cyB0byBzYXZlICovDQo+ID4gK8KgwqDCoMKgwqDCoCByZXQgPSB2Z2ljX3Y1X3ZhbGlkYXRlX2lz
dF91c2VyX2J1ZmZlcihpc3RfYXR0ci0NCj4gPiA+c3BpX2lzdF9hZGRyLA0KPiA+ICvCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgIGlzdF9hdHRyLT5zcGlfaXN0X3NpemUsDQo+ID4gK8KgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqAga3ZtLT5hcmNoLnZnaWMubnJfc3BpcyAqDQo+ID4gc2l6ZW9mKF9fdTMyKSk7DQo+ID4g
K8KgwqDCoMKgwqDCoCBpZiAocmV0KQ0KPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
IHJldHVybiByZXQ7DQo+ID4gKw0KPiA+ICvCoMKgwqDCoMKgwqAgLyogV2UgZG9uJ3QgYWx3YXlz
IGhhdmUgTFBJcyB0byBzYXZlICovDQo+ID4gK8KgwqDCoMKgwqDCoCByZXQgPSB2Z2ljX3Y1X2ly
c19scGlfaXN0X2lkX2JpdHMoa3ZtLCAmaWRfYml0cyk7DQo+ID4gK8KgwqDCoMKgwqDCoCBpZiAo
cmV0IDwgMCkNCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCByZXR1cm4gcmV0Ow0K
PiA+ICsNCj4gPiArwqDCoMKgwqDCoMKgIC8qIE5vIExQSSBJU1QgKi8NCj4gPiArwqDCoMKgwqDC
oMKgIGlmICghcmV0KSB7DQo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgaWYgKGlz
dF9hdHRyLT5scGlfaXN0X2FkZHIgfHwgaXN0X2F0dHItDQo+ID4gPmxwaV9pc3Rfc2l6ZSkNCj4g
PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcmV0dXJuIC1F
SU5WQUw7DQo+ID4gKw0KPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJldHVybiAw
Ow0KPiA+ICvCoMKgwqDCoMKgwqAgfQ0KPiA+ICsNCj4gPiArwqDCoMKgwqDCoMKgIHJldHVybiB2
Z2ljX3Y1X3ZhbGlkYXRlX2lzdF91c2VyX2J1ZmZlcihpc3RfYXR0ci0NCj4gPiA+bHBpX2lzdF9h
ZGRyLA0KPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgaXN0X2F0dHItDQo+
ID4gPmxwaV9pc3Rfc2l6ZSwNCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
IEJJVChpZF9iaXRzKSAqDQo+ID4gc2l6ZW9mKF9fdTMyKSk7DQo+ID4gK30NCj4gDQo+IC4uLiBh
bmQgdGhpcyBzaXplcyB0aGUgYnVmZmVyIGZyb20gdGhlIGVtdWxhdGVkIElSU19JU1RfQ0ZHUi4g
SSB0aGluaw0KPiB0aGUgdHdvIGFyZSB1c2luZyBkaWZmZXJlbnQgdmFsdWVzLCBhbmQgSSBjb3Vs
ZCBub3QgZmluZCBhbnl0aGluZw0KPiB0aGF0DQo+IHJlLXN5bmNzIHRoZW0uDQo+IA0KPiBUaGUg
dHdvIHdyaXRlcnMgb2YgSVJTX0lTVF9DRkdSIGRpZmZlcjoNCj4gYHZnaWNfdjVfbW1pb193cml0
ZV9pcnNfaXN0KClgDQo+IHJldHVybnMgZWFybHkgd2hpbGUgYGlzdF9iYXNlci52YWxpZGAgaXMg
c2V0LA0KPiBgdmdpY192NV9tbWlvX3VhY2Nlc3Nfd3JpdGVfaXJzKClgIGRvZXMgbm90LiBTbyB1
c2Vyc3BhY2UgY2FuIHJlc3RvcmUNCj4gdGhlIElTVCwgc3RhbXBpbmcgdGhlIFZNVEUgZnJvbSB0
aGUgbGFyZ2VyIExQSV9JRF9CSVRTLCByZXdyaXRlDQo+IElSU19JU1RfQ0ZHUiBzbWFsbGVyLCBh
bmQgdGhlbiBzYXZlIHdpdGggdGhlIG1hdGNoaW5nIHNtYWxsZXIgYnVmZmVyLg0KPiBgdmdpY192
NV9pc3RfY2Zncl92YWxpZCgpYCBhY2NlcHRzIGRvd24gdG8gSVJTX0lEUjIuTUlOX0xQSV9JRF9C
SVRTLA0KPiBzbyBvbiBhIHBhcnQgcmVwb3J0aW5nIDAgdGhhdCBpcyBCSVQoMTYpIGVudHJpZXMg
aW50byBhIGJ1ZmZlcg0KPiB2YWxpZGF0ZWQgYXQgNCBieXRlcy4gYHRlc3RfdmdpY192NV9pc3Rf
c2F2ZV9yZXN0b3JlKClgIGluIHBhdGNoIDQ4DQo+IGFscmVhZHkgcmVzdG9yZXMgYW5kIHRoZW4g
cmUtc2F2ZXMgYmVmb3JlIGFueSB2Q1BVIHJ1bnMsIGl0IGp1c3QgZG9lcw0KPiBub3Qgd3JpdGUg
SVJTX0lTVF9DRkdSIGluIHRoYXQgd2luZG93Lg0KDQpZZWFoLCB0aGF0J3MgdmVyeSBtdWNoIG5v
dCBkZXNpcmVkISBJJ3ZlIGdvbmUgYW5kIGhhdmUgcmVzdHJpY3RlZCB3aGF0DQp1c2Vyc3BhY2Ug
Y2FuIHJlYWxpc3RpY2FsbHkgZG8gLSB3ZSBzaG91bGRuJ3QgYmUgaW4gYSBzaXR1YXRpb24gd2hl
cmUNCnVzZXJzcGFjZSBjYW4gZm9yY2UgdGhpbmdzIHRvIGdvIG91dCBvZiBzeW5jLCBJTU8uIA0K
DQpJJ3ZlIHVwZGF0ZWQgdGhlIGNvZGUgdG8gcmVqZWN0IHVzZXJzcGFjZSB3cml0ZXMgdG8gdGhl
IElSU19JU1RfQ0ZHUg0Kb25jZSBhbmQgTFBJIElTVCBoYXMgYmVlbiBhbGxvY2F0ZWQgLSB1bmxl
c3MgdXNlcnNwYWNlIGp1c3Qgc28gaGFwcGVucw0KdG8gd3JpdGUgdGhlIHNhbWUgdmFsdWUgaW4g
d2hpY2ggY2FzZSB0aGUgTk9QIGlzIGFsbG93ZWQuIFRoZQ0KYWxsb2NhdGlvbiBvZiB0aGUgTFBJ
IElTVCBoYXBwZW5zIGFzIHBhcnQgb2YgcmVzdG9yaW5nIHRoZSBJU1QsIHNvDQpicm9hZGx5IHVz
ZXJzcGFjZSBpcyBhbGxvd2VkIHRvIGRvIHdoYXRldmVyIGl0IGxpa2VzLCB1bnRpbCB0aGUgSVNU
IGhhcw0KYmVlbiBjcmVhdGVkLCBhdCB3aGljaCBwb2ludCB0aGUgdmFsdWVzIGFyZSBmcm96ZW4u
IEkndmUgYWRkZWQgYQ0Kc2ltaWxhciByZXN0cmljdGlvbiBmb3IgdGhlIElSU19JU1RfQkFTRVIg
LSB0aGUgdmFsdWUgaXMgZnJvemVuIG9uY2UNCnRoZSBJU1QgaXMgYWxsb2NhdGVkLg0KDQo+IA0K
PiBhcm0tdmdpYy12NS5yc3Qgc2F5cyB0aGUgTFBJIGJ1ZmZlciBzaXplIG11c3QgYmUgQklUKGxw
aV9pZF9iaXRzKSAqDQo+IHNpemVvZihfX3UzMiksICJ3aGVyZSBscGlfaWRfYml0cyBpcyB0aGUg
TFBJIElEIHdpZHRoIGNvbmZpZ3VyZWQgaW4NCj4gSVJTX0lTVF9DRkdSIiwgd2hpY2ggaXMgdGhl
IHZhbHVlIHRoZSB2YWxpZGF0aW9uIHVzZXMgYW5kIG5vdCB0aGUgb25lDQo+IHRoZSB3YWxrIHVz
ZXMuDQoNClllYWgsIGJ1dCB3ZSBzaG91bGQgbWFuZGF0ZSB0aGF0IHRoZXNlIGFyZSB0aGUgc2Ft
ZS4gVGhlcmVmb3JlLCB0aGUNCmNvZGUgbm93IHJlamVjdHMgTFBJIElTVCBzYXZlcyB3aGVuIHRo
ZSBWTVRF4oCZcyBJU1RfSURfQklUUyBkaWZmZXIgZnJvbQ0KSVJTX0lTVF9DRkdSLkxQSV9JRF9C
SVRTLg0KDQo+IA0KPiBBZGRpbmcgdGhlIGBpc3RfYmFzZXIudmFsaWRgIGNoZWNrIHRvIHRoZSB1
YWNjZXNzIHBhdGggd291bGQgYnJlYWsNCj4gcmVzdG9yZSwgc2luY2UgdGhlIHNhbWUgZmlsZSBz
YXlzIHRoZSBJUlMgcmVnaXN0ZXJzIG1heSBiZSByZXN0b3JlZA0KPiBpbg0KPiBhbnkgb3JkZXIu
IFZhbGlkYXRpbmcgYWdhaW5zdCB0aGUgdmFsdWUgdGhlIHdhbGsgdXNlcywgb3IgcmVqZWN0aW5n
IGENCj4gc2F2ZSB3aGVuIHRoZSByZWdpc3RlciBhbmQgdGhlIFZNVEUgZGlzYWdyZWUsDQo+IGJv
dGggbG9vayB3b3JrYWJsZS4gQm91bmRpbmcgdGhlIHdhbGsgYnkgdGhlIHJlZ2lzdGVyIGluc3Rl
YWQgd291bGQNCj4gcmVhZCBwYXN0IHRoZSBob3N0IGFsbG9jYXRpb24gd2hlbmV2ZXIgdGhlIHJl
Z2lzdGVyIGlzIHRoZSBsYXJnZXIgb2YNCj4gdGhlIHR3bywgc28gSSBkbyBub3QgdGhpbmsgdGhh
dCBkaXJlY3Rpb24gd29ya3MuDQoNCkFncmVlZCwgSSBkb24ndCB0aGluayB0aGF0IGRpcmVjdGlv
biB3b3Jrcy4gVGhlIGxpbWl0IG5lZWRzIHRvIGJlIGJhc2VkDQpvbiB3aGF0IHRoZSBob3N0IGhh
cyBhbGxvY2F0ZWQuDQoNCkluIGdlbmVyYWwsIEkndmUgZG9uZSB0aGUgZm9sbG93aW5nOg0KDQot
IFJlamVjdCBMUEkgSVNUIHNhdmVzIHdoZW4gdGhlIFZNVEXigJlzIElTVF9JRF9CSVRTIGlzIGRp
ZmZlcmVudCBmcm9tDQpJUlNfSVNUX0NGR1IuTFBJX0lEX0JJVFMuDQotIE1ha2UgSVJTX0lTVF9D
RkdSIGFuZCBJUlNfSVNUX0JBU0VSIGltbXV0YWJsZSBhZnRlciBhbGxvY2F0aW5nIHRoZQ0KTFBJ
IElTVC4gSWRlbnRpY2FsIHVzZXJzcGFjZSB3cml0ZXMgYXJlIGFjY2VwdGVkIGJ1dCBhcmUgTk9Q
cy4NCi0gQWRkZWQgdGVzdHMgZm9yIHRoZSBCQVNFUiBhbmQgQ0ZHUiByZXN0cmljdGlvbnMgdG8g
dGhlIHNlbGZ0ZXN0cy4NCg0KPiANCj4gYHB1dF91c2VyKClgIHRhcmdldHMgdGhlIGNhbGxlcidz
IG93biBtYXBwaW5nIGFuZCB0aGUgaG9zdC1zaWRlIHJlYWRzDQo+IHN0YXkgaW4gYm91bmRzLCBz
byBJIHRoaW5rIHRoaXMgaXMgYSBjb3JyZWN0bmVzcyBwcm9ibGVtIHJhdGhlciB0aGFuDQo+IGEN
Cj4gc2VjdXJpdHkgb25lLiBUaGUgU1BJIHNhdmUgdXNlcyBgbnJfc3Bpc2Agb24gYm90aCBzaWRl
cyBhbmQgcmVzdG9yZQ0KPiBzdGFtcHMgdGhlIFZNVEUgZnJvbSB0aGUgdmFsdWUgaXQgdmFsaWRh
dGVkLA0KPiBzbyBvbmx5IHRoZSBMUEkgc2F2ZSBsb29rcyBhZmZlY3RlZCwgbGluZWFyIGFuZCB0
d28tbGV2ZWwgYWxpa2UuDQo+IA0KPiBDaGVlcnMsDQo+IC9mdWFkDQoNClRoYW5rcywNClNhc2No
YQ0KDQo=
