Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013056.outbound.protection.outlook.com [40.107.159.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86AA1284B29
	for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 14:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.56
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779375474; cv=fail; b=XtgvUFmQ1IRwQxQ99G3L6JekrfSvs4jaraPh3pwJx/x6G9xC0ElhpW4FzT++l4QPULvAe9OcbYl3/Pt8gD9NYulqSGnM26pCXJoqbkUhO734YNFbhKLbCc2PHpgqse7jOtjcHO9pweXuIfp+AHVWGHJTOxlDwE6UAQdxrti8Q/g=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779375474; c=relaxed/simple;
	bh=0ks6UHBU7mwwSsbFOzTnEi3gS5AFPyvX4/WWIkhpo/c=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=fFfT3x6IyIabcSQhUCfWAe7PDbgBR/01+aUkUzBgPRqBfqtFTBpIldLY0jHyArmk7Sar4pvuz8qvhK25ImW76KaeXZLevnGSgDOEXFkoMMx0GGATxmt0mhPHB94UMK7I+yc/936rNX/PY3gvyDyk971Y2Ke5DvHX6zt/trV6i2A=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=EI56IAK+; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=EI56IAK+; arc=fail smtp.client-ip=40.107.159.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="EI56IAK+";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="EI56IAK+"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=nuwBWAarEYKwEbjswNU+jlrNvOOjYSZfEcdng0os987CFaTte16G8EVVnKmXfN5jrw5kHThFWMzPJ78+G9kZSZ9DGRXV21Hmj0qgjIIaAdpNxB9idLw8fdwgH0w7OBaZRYck/XOolIePoR1mVeILCmQlSwy6JlO93cL/PiGCRMVPeGriPjTmHVKEGCb2npsZmiCZ/tMN9wn/Z3kguGSZk5ykCN745bk0Z1wjHSAVhAm5V0b4OBwRb6/LFDTTIUIyBWwaYKLyh6LZ2CxZ115FbJXpQn/Or8Etim7pjYzQjNNH7G2kvvtav5XDISZI5VI5dDMXbr8MlUBe+Sv8nEpv4A==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bCPVZOQDUofnIA43Xm/cPl/zPVI3sgIxK/DVYxlqQ+8=;
 b=bj6wGkGevR9HjWEdVyuOwhfLdV+UsoHLuKnYYLJ5lSOZn7hbEnFvFA/vQe0LLtNzu0FPDSn9rPdtVT2aSkdO1GjAzIxxOm/SppM9IahysEemxHCRfGRhILMxzDN5UPlQSubzqM20heKMkVXwM67wr2pVIahvlQdgV19EDodXnY0JiSZtDo4zOaN+qMY2sopYmb++N80sz9NSTGx7iMUk4DOngs+BV2QuTElPTR8LiUVhGGm42kq2Db3HGXV/ZuF74loG0ZHTuSnl/1bVSpccl99zABCK4JSVFPfIUl6iSP/kA7RrQUNfdJxaFRBCAuTVWArLi405nAPwSMy5rxUDhg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bCPVZOQDUofnIA43Xm/cPl/zPVI3sgIxK/DVYxlqQ+8=;
 b=EI56IAK+hzfI1rNxl/1NcTLQzkhIfLtgMrhUgKzWAREDkBp7/21IY2HNCb64mz+6s5H4WeCqplv/HA3yX2sHWurFLHYBUQPCvZvLYCCbQMgSlL2ihJhJpVHYQm4VDqPXHnZznKFY4s0isoKVJBLxiv5GsDKQnrZixDRAWu96qGE=
Received: from AS9PR06CA0580.eurprd06.prod.outlook.com (2603:10a6:20b:486::15)
 by AS8PR08MB10364.eurprd08.prod.outlook.com (2603:10a6:20b:56a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.17; Thu, 21 May
 2026 14:57:45 +0000
Received: from AM3PEPF0000A78D.eurprd04.prod.outlook.com
 (2603:10a6:20b:486:cafe::1c) by AS9PR06CA0580.outlook.office365.com
 (2603:10a6:20b:486::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.48.17 via Frontend Transport; Thu, 21
 May 2026 14:57:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM3PEPF0000A78D.mail.protection.outlook.com (10.167.16.116) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.71.7 via
 Frontend Transport; Thu, 21 May 2026 14:57:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=A8NF29o1wya7pcDVNP0OniLOg20+ZgkNfNwetQLpk9fI4PDpUArTgVZwwuyz6+YBHos5VyomLK5WOso5Gc5olDzUWnINne3A+UP+E2LCqMhmgdl62E9kRMlWkPdEhNQlr9yVb6mqo1o3WEAmyeSwj7cRJFgIjSfs5V/mypHD8GwqQWnXKiY53lak5psjtcbn6ALvSR8UIkQxvfBvInzmyenNuUDtpCFZJ7aZT5ADRr9LnJSDLzOpS9a87ka23oZKaubHVvwBiYlRkVQxlHXn3UFNhx1rnaCwT/AfKj7F19oYn9Cxxx2/kVBNiyg8XWrzk4OnWLcUdPAaoSxY5aZVbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bCPVZOQDUofnIA43Xm/cPl/zPVI3sgIxK/DVYxlqQ+8=;
 b=rDHiYA6JvhGP1IhgQeW5wbZpshZ/DQmZ5CZs0opGq9cniC2n7rzBAwVU4Y5a8obLBVVuCh6R4I7wDbDOHI7ojLYBu/U4izTm009bKm2XysQ/fJPKu0kVUCTdJwMv5zGLfK/9LirzEsQE0SqXu2EFC+jW84LBKDJbgHXvKatVGGHBX22EgPuZU5vnFe4CzjoFCr9NNujqGoYkrIRgMNkEM2WZzcEUPKCFNAsgZIuX4A6taPfzbf4tITMNACCEdzga0hC859jRxpy9LfGmN4AqWgrcjzmescwMXPj62XBTjOPcIxddJpalaTv+nGa5I1w57ieyBepxc70Yp1tZE4FoYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bCPVZOQDUofnIA43Xm/cPl/zPVI3sgIxK/DVYxlqQ+8=;
 b=EI56IAK+hzfI1rNxl/1NcTLQzkhIfLtgMrhUgKzWAREDkBp7/21IY2HNCb64mz+6s5H4WeCqplv/HA3yX2sHWurFLHYBUQPCvZvLYCCbQMgSlL2ihJhJpVHYQm4VDqPXHnZznKFY4s0isoKVJBLxiv5GsDKQnrZixDRAWu96qGE=
Received: from GV1PR08MB7315.eurprd08.prod.outlook.com (2603:10a6:150:1e::15)
 by PAVPR08MB9209.eurprd08.prod.outlook.com (2603:10a6:102:30a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.25.21; Thu, 21 May
 2026 14:56:41 +0000
Received: from GV1PR08MB7315.eurprd08.prod.outlook.com
 ([fe80::c249:1aed:a4c2:4193]) by GV1PR08MB7315.eurprd08.prod.outlook.com
 ([fe80::c249:1aed:a4c2:4193%3]) with mapi id 15.21.0048.013; Thu, 21 May 2026
 14:56:41 +0000
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
Subject: [PATCH v2 22/39] KVM: arm64: gic-v5: Register the IRS IODEV
Thread-Topic: [PATCH v2 22/39] KVM: arm64: gic-v5: Register the IRS IODEV
Thread-Index: AQHc6TIIRqyBTex21UyMpRgDnkE33g==
Date: Thu, 21 May 2026 14:56:41 +0000
Message-ID: <20260521144846.1899475-23-sascha.bischoff@arm.com>
References: <20260521144846.1899475-1-sascha.bischoff@arm.com>
In-Reply-To: <20260521144846.1899475-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	GV1PR08MB7315:EE_|PAVPR08MB9209:EE_|AM3PEPF0000A78D:EE_|AS8PR08MB10364:EE_
X-MS-Office365-Filtering-Correlation-Id: 0f87075d-8d08-42ff-1353-08deb749510c
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|376014|38070700021|56012099003|22082099003|18002099003|11063799006|6133799003;
X-Microsoft-Antispam-Message-Info-Original:
 j70Aum5Aw1SDbu3oj6dp1fWswCAMGAuyGeDwUmmDG7yPLdzkJLQsXtDhxq9r2FUR50KobZPDazPlmjGx0qyIj20VbYGqxM70Fx64Cs6MjPJgXFinxC/vT3Dre9IWXncZh+hOjeqRhfTUbvj0q49AWd9XjaGinMObH/F37mlzQIJg0A03Xk8AhyXxdKv2VN790pJom2m2O9IhrHfuWeEv7YDsZfJPVABGih/RXFw/CQ83sFkNON2KicxNquNT7AqII6pgVxTmmIa6y34075tntCam9aVf1Nw0XbmdGmr14nc7aOVL8VzPvJnBdiS0wl+ILPul5qOdCGPxUSQIvqTK97/eRCMLG66SFH43xZRueVRdAK9kAoNysQUDUpLBZ+96aG76ZkFEbxB6CepkHZbREo6YxlibDsBH1RfJCz29knAjNo/gT4s7n18erbnhJlq8P5zU51/kCOVh7dUKbruwLFqjM/3UwiiCHDpFzGyh1F5zgOcWNds6fLKKnBSiyxhuJNmM/jAgoYeggb9uiNmAQ1ehsXm5l2xhJ7Y3wt8JSe40dZPozJAE+Uqf9ArLjWMrLQeDhzP2vEi4fzGxa2YclT1L9nUN/H97TcKSzdd+E7ccoiYInvLF8Cb3FBsm3fU68BluNU4CkFiJQ+EeOFeEpA4rp8MCsIpOYhtu+ifrnC1kaTkoboakzP0WUWdxoJ7x6/RPWNXc+66zNuqBSFJKrhuJ5pJXKx/d9hnYhLthgdL2DCIllIP5/fglwoW6o47i
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB7315.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700021)(56012099003)(22082099003)(18002099003)(11063799006)(6133799003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 IKYVql0xp09k/hm0Zu0w1Zk8hXpELyTnLLKku599EpkQjkk0SG86pQ6nDTEkYQ8idccO6kTnRBEr5UEkh/3pZUym6n1MNfN+ztv13D/lP712G8YtsE951oXfwuNV+V0voheo7ej8YTps+71HIiTZ3rYp671zp0K9AlrvhkEbkGIOAKQ1eBzGWvyytzKKPyUz4CzgqxlI3AvUVRglwcYdske3NWLsqqkCcfzivvARg55ay5xlss9io8E7SOFJUP8CJzgBh/vT8sZFSjh1NgcGC/d29/fUxEHI4qdugQjmgIlKKDuGz1EhUHRl32Qb/uDZIv9x+DwdddFeSESUcp70kA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAVPR08MB9209
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM3PEPF0000A78D.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	1e1dee60-42a9-441c-e63d-08deb7492ad4
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|1800799024|14060799003|36860700016|376014|82310400026|22082099003|56012099003|18002099003|11063799006|6133799003;
X-Microsoft-Antispam-Message-Info:
	GEG3fEnRHLESeZRJUqWcEf99yGXlNbxCyAYiCfGgB9B4wdkD/QBEGN8NKT2LcLYrDNjpC32A5Qg+eLBs8la4A/XBZy5vOUHs69i60XipB6/hGs3skOWH1nG/Jql2nfho5qKiwSdPrfy4QAyvxUvgADsJvXTSfYLEKhCET8lXROnxYP5M6FFKtKScPaJ8jpHGwAYdSm3bGEtzaUrBx1fD8wKMhsyR/Ss1j3EwWU3Gh4IQGbrgjP+XMX2N6RUSPltyeb9fabfDSNYSd/HsV/6tyM24BcpdWfviZuHxRcg6KDVZBip/Toi4RrPy9lp8EZuDLDYKD1qxur2ld1OlvfaSOY2BSGBzGjsjG9IRYLXHh8OkC+b/q4Oc/jjUKWRiyh9dG1nEcBldiKujdRBL1Lyoyrk0au6iYmEukmufVhHGSlNZSzYROCY/sA89+bU16xuSF/pYeGwH2t0jeirBP7iR6be5moIDbCMJyukjNCExJOKG3vWp8ehzXCXXBgyhy8Uttl7yw378BQSNuIzlVXhdX0ftAaX8HVrwnDNwr25hyGAbahgu5qtPYO2XuGTnGj6kMEQ4HwllRS0w7CmkEPrMSDkhq99Grtz1rYEF63b1j+g49yP4FOmi8zdjoNHxDpL8J0Un9b2zwj23akjuZD4VDlQizWHw2GNIs875AMHKMYnG/RrLbWLIfmNHxtT3kFw6+JKBGVn9zsSOb2atAuEenwU4wlKRibL5d/rGdWs/aqI=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(1800799024)(14060799003)(36860700016)(376014)(82310400026)(22082099003)(56012099003)(18002099003)(11063799006)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	+sVJCVdRtEEiLhY8Twe3iCPBkCay6aI2jm1o6sPfwdrH81ScRy3JEYbRqv03yM+dYvgy7RcXBDow5W3cGN3NErbZ7xqIBBDv4PHy5ba8EsuoDjrShNN9Zj3fXnI35CziwR+QSYpK3mz60Vztuf3/x8Suhtp6A1vtjZx1r3g+shv4THg/XDUDZUyyy1ty3UmJq8JQ9aVAD56/q0QfwcsQUoEvujvf0ibAuDvKndTxHAWgJptaKuZ5HXz2Jfmc/7ZB61xa4T5/IgLcMARqOUOOU+QS7BmI0TSi8Jvpod9mAWZ5LWGL4YEy1oDmM/E5jAuDzjYh9kGzrldzhyuNti6akDK5bVfP1HW17eMpdo2odVMmRLYDrt1ar1qn4hVDWSLBoEfyoP1xtOsueJ+ekHfjilv/pN3H0CGRD1o2lRQpfmgvFA9KFOGkKUjUHX0dKx0m
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2026 14:57:45.2380
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f87075d-8d08-42ff-1353-08deb749510c
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM3PEPF0000A78D.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB10364

Now that we have an emulated IRS, it needs to be registered, which
ensures that guest accesses to the MMIO regions handled by the device
are handled appropriately in KVM. Therefore, as part of
vgic_map_resources, the GICv5 IRS IODEV is registered. If the address
for the IRS is not provided, bail out reporting an error - this is not
a supported config.

As part of this change, expose setting the address of the emulated IRS
via KVM_VGIC_V5_ADDR_TYPE_IRS to userspace. Also allow userspace to set
the number of SPIs handled by the emulated GICv5 implementation, using a
GICv5-specific SPI count rather than the legacy total interrupt count.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-init.c       |  19 ++++-
 arch/arm64/kvm/vgic/vgic-kvm-device.c | 106 ++++++++++++++++++--------
 2 files changed, 91 insertions(+), 34 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-ini=
t.c
index aa883507d00d1..f6c8a11c9aa44 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -657,9 +657,8 @@ int vgic_lazy_init(struct kvm *kvm)
 int kvm_vgic_map_resources(struct kvm *kvm)
 {
 	struct vgic_dist *dist =3D &kvm->arch.vgic;
-	bool needs_dist =3D true;
 	enum vgic_type type;
-	gpa_t dist_base;
+	gpa_t dist_base, irs_base;
 	int ret =3D 0;
=20
 	if (likely(smp_load_acquire(&dist->ready)))
@@ -682,13 +681,12 @@ int kvm_vgic_map_resources(struct kvm *kvm)
 	} else {
 		ret =3D vgic_v5_map_resources(kvm);
 		type =3D VGIC_V5;
-		needs_dist =3D false;
 	}
=20
 	if (ret)
 		goto out;
=20
-	if (needs_dist) {
+	if (type !=3D VGIC_V5) {
 		dist_base =3D dist->vgic_dist_base;
 		mutex_unlock(&kvm->arch.config_lock);
=20
@@ -698,7 +696,20 @@ int kvm_vgic_map_resources(struct kvm *kvm)
 			goto out_slots;
 		}
 	} else {
+		irs_base =3D dist->vgic_v5_irs_data->vgic_v5_irs_base;
 		mutex_unlock(&kvm->arch.config_lock);
+
+		if (IS_VGIC_ADDR_UNDEF(irs_base)) {
+			kvm_err("No IRS address provided\n");
+			ret =3D -ENXIO;
+			goto out_slots;
+		}
+
+		ret =3D vgic_v5_register_irs_iodev(kvm, irs_base);
+		if (ret) {
+			kvm_err("Unable to register VGIC IRS MMIO regions\n");
+			goto out_slots;
+		}
 	}
=20
 	smp_store_release(&dist->ready, true);
diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vg=
ic-kvm-device.c
index 90be99443df3b..2bf1930902b8e 100644
--- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
+++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
@@ -181,6 +181,14 @@ static int kvm_vgic_addr(struct kvm *kvm, struct kvm_d=
evice_attr *attr, bool wri
 		addr |=3D (u64)rdreg->count << KVM_VGIC_V3_RDIST_COUNT_SHIFT;
 		goto out;
 	}
+	case KVM_VGIC_V5_ADDR_TYPE_IRS:
+		r =3D vgic_check_type(kvm, KVM_DEV_TYPE_ARM_VGIC_V5);
+		if (r)
+			break;
+		addr_ptr =3D &vgic->vgic_v5_irs_data->vgic_v5_irs_base;
+		alignment =3D SZ_64K;
+		size =3D KVM_VGIC_V5_IRS_SIZE;
+		break;
 	default:
 		r =3D -ENODEV;
 	}
@@ -224,31 +232,48 @@ static int vgic_set_common_attr(struct kvm_device *de=
v,
 		if (get_user(val, uaddr))
 			return -EFAULT;
=20
-		/*
-		 * We require:
-		 * - at least 32 SPIs on top of the 16 SGIs and 16 PPIs
-		 * - at most 1024 interrupts
-		 * - a multiple of 32 interrupts
-		 */
-		if (val < (VGIC_NR_PRIVATE_IRQS + 32) ||
-		    val > VGIC_MAX_RESERVED ||
-		    (val & 31))
-			return -EINVAL;
+		if (!vgic_is_v5(dev->kvm)) {
+			/*
+			 * We require:
+			 * - at least 32 SPIs on top of the 16 SGIs and 16 PPIs
+			 * - at most 1024 interrupts
+			 * - a multiple of 32 interrupts
+			 */
+			if (val < (VGIC_NR_PRIVATE_IRQS + 32) ||
+			    val > VGIC_MAX_RESERVED || (val & 31))
+				return -EINVAL;
=20
-		mutex_lock(&dev->kvm->arch.config_lock);
+			mutex_lock(&dev->kvm->arch.config_lock);
=20
-		/*
-		 * Either userspace has already configured NR_IRQS or
-		 * the vgic has already been initialized and vgic_init()
-		 * supplied a default amount of SPIs.
-		 */
-		if (dev->kvm->arch.vgic.nr_spis)
-			ret =3D -EBUSY;
-		else
-			dev->kvm->arch.vgic.nr_spis =3D
-				val - VGIC_NR_PRIVATE_IRQS;
+			/*
+			 * Either userspace has already configured NR_IRQS or
+			 * the vgic has already been initialized and vgic_init()
+			 * supplied a default amount of SPIs.
+			 */
+			if (dev->kvm->arch.vgic.nr_spis)
+				ret =3D -EBUSY;
+			else
+				dev->kvm->arch.vgic.nr_spis =3D
+					val - VGIC_NR_PRIVATE_IRQS;
=20
-		mutex_unlock(&dev->kvm->arch.config_lock);
+			mutex_unlock(&dev->kvm->arch.config_lock);
+		} else {
+			/*
+			 * GICv5 reports a number of SPIs, not a total number of
+			 * interrupts. Require a multiple of 32 SPIs.
+			 */
+			if (val < VGIC_V5_DEFAULT_NR_SPIS ||
+			    val > FIELD_MAX(GICV5_IRS_IDR5_SPI_RANGE) ||
+			    (val & 31))
+				return -EINVAL;
+
+			mutex_lock(&dev->kvm->arch.config_lock);
+			if (vgic_initialized(dev->kvm) || dev->kvm->arch.vgic.nr_spis)
+				ret =3D -EBUSY;
+			else
+				dev->kvm->arch.vgic.nr_spis =3D val;
+			mutex_unlock(&dev->kvm->arch.config_lock);
+		}
=20
 		return ret;
 	}
@@ -299,9 +324,14 @@ static int vgic_get_common_attr(struct kvm_device *dev=
,
 		return (r =3D=3D -ENODEV) ? -ENXIO : r;
 	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS: {
 		u32 __user *uaddr =3D (u32 __user *)(long)attr->addr;
-
-		r =3D put_user(dev->kvm->arch.vgic.nr_spis +
-			     VGIC_NR_PRIVATE_IRQS, uaddr);
+		/* Older GICs */
+		if (!vgic_is_v5(dev->kvm)) {
+			r =3D put_user(dev->kvm->arch.vgic.nr_spis +
+					     VGIC_NR_PRIVATE_IRQS,
+				     uaddr);
+		} else {
+			r =3D put_user(dev->kvm->arch.vgic.nr_spis, uaddr);
+		}
 		break;
 	}
 	}
@@ -748,21 +778,25 @@ static int vgic_v5_set_attr(struct kvm_device *dev,
 {
 	switch (attr->group) {
 	case KVM_DEV_ARM_VGIC_GRP_ADDR:
+		break;
 	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
-	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
 		return -ENXIO;
+	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
+		break;
 	case KVM_DEV_ARM_VGIC_GRP_CTRL:
 		switch (attr->attr) {
 		case KVM_DEV_ARM_VGIC_CTRL_INIT:
-			return vgic_set_common_attr(dev, attr);
+			break;
 		case KVM_DEV_ARM_VGIC_USERSPACE_PPIS:
 		default:
 			return -ENXIO;
 		}
+		break;
 	default:
 		return -ENXIO;
 	}
=20
+	return vgic_set_common_attr(dev, attr);
 }
=20
 static int vgic_v5_get_attr(struct kvm_device *dev,
@@ -770,21 +804,26 @@ static int vgic_v5_get_attr(struct kvm_device *dev,
 {
 	switch (attr->group) {
 	case KVM_DEV_ARM_VGIC_GRP_ADDR:
+		break;
 	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
-	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
 		return -ENXIO;
+	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
+		break;
 	case KVM_DEV_ARM_VGIC_GRP_CTRL:
 		switch (attr->attr) {
 		case KVM_DEV_ARM_VGIC_CTRL_INIT:
-			return vgic_get_common_attr(dev, attr);
+			break;
 		case KVM_DEV_ARM_VGIC_USERSPACE_PPIS:
 			return vgic_v5_get_userspace_ppis(dev, attr);
 		default:
 			return -ENXIO;
 		}
+		break;
 	default:
 		return -ENXIO;
 	}
+
+	return vgic_get_common_attr(dev, attr);
 }
=20
 static int vgic_v5_has_attr(struct kvm_device *dev,
@@ -792,15 +831,22 @@ static int vgic_v5_has_attr(struct kvm_device *dev,
 {
 	switch (attr->group) {
 	case KVM_DEV_ARM_VGIC_GRP_ADDR:
+		switch (attr->attr) {
+		case KVM_VGIC_V5_ADDR_TYPE_IRS:
+			return 0;
+		}
+		return -ENXIO;
 	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
-	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
 		return -ENXIO;
+	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
+		return 0;
 	case KVM_DEV_ARM_VGIC_GRP_CTRL:
 		switch (attr->attr) {
 		case KVM_DEV_ARM_VGIC_CTRL_INIT:
 			return 0;
 		case KVM_DEV_ARM_VGIC_USERSPACE_PPIS:
 			return 0;
+		case KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES:
 		default:
 			return -ENXIO;
 		}
--=20
2.34.1
