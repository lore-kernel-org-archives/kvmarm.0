Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011050.outbound.protection.outlook.com [52.101.65.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06E0A348898
	for <kvmarm@lists.linux.dev>; Mon, 27 Apr 2026 16:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.50
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777306180; cv=fail; b=ful0xV/EFLCggCVesDqPPEb9P2XihXI8pFsHJVCNL8k6K7O1Irdw8XdNbC9kGlWrhnoPyLF7PgWHSB0doHjPHyg4YBJGz7mT2eXjzwAjJVTcuB2Q39qKg53Qb07H6ZjE5iy4fBhVVs3xn7onUuhq8AhzLkEgt8KZ5F9nR/M+PtM=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777306180; c=relaxed/simple;
	bh=hFKJqwP/vwGEo3Uwhm2u8dXAQCSxB119Ci32fdLm5tM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=MbdXHWwRlEv3H7j76mPmvhC8mRLQV7CgDzC3ZJEpGwY/kTWLaeHqOLawYsIbV3wqDFliTJNofBw3WGAUnLU5Ng9P8pIikc4yfF7GlrgLauRk/B1qN2cMTWn2gBZADr7luLzmjV8s7V8UG9KFVLOKTwXvUhT/SIoS7jGE5nebSL0=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Yqz4LGFI; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Yqz4LGFI; arc=fail smtp.client-ip=52.101.65.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Yqz4LGFI";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Yqz4LGFI"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=OKqOjtQkc0DIZimMNZLEVCdWNdX++jPbtjOy8JHzP/v+sa68n5ilRmrGoCHpvfk9kl54mgloVTC03kuT2W+SO5h1yfTc20UqqVSLym7/v86h6bjqxuVOoxRQxMGFfhky7KpLJA8JYqjmMPXtvRbkQLToFXqamWcMcisygzSAZ+Uxn3UUp/TgvVEb6XQao1SSGAdFGCzKTyawmspDnpIwPUtGhPvJL12yG6n4ooBCVJWE7YNV4jCai9rrMgs28bnY6m9wuKBgBJd347MiJyea+kUVLL9rIaIf9uS4oiPrSnEOkOIdMi4Vqp6pz9y2l8KvHG5WsMg3Cljf6rErsvmrkg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q62GnaSA2Vvspl/MfK1e5PDILFIT3C37Jmd6Ijq8t9g=;
 b=GmfyH7WlHVF6O+QLaoF93xovJUnsZcwvfSeseZKeuvhJ9GpwZ2w5xriHqLPmWVnDlio8EvfZC3qY3wU7fkfMF9sIgeSIUsb4x5VEzuLMwQQKtc47g+HVZnvTLbnITXat4eefUxOMXzL/nD5MkSefvxeK94qHOecUxA2coBwi3SMKUeN5Fnagf6yWp78zSx4mguYFbgHB9y4xHjEt1GO+M1nTkrKOMsvRxALD6KSDl/XUYBdr34gWjXx1hkXL2Wx7BR1fvegLuVGmArRHtW1+Afk5AiYtlcj2unOgb56g2LRbZlYWgV3kpm4yA/U+sVWdL57/g5FBZqSQBtl7qiUgVw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q62GnaSA2Vvspl/MfK1e5PDILFIT3C37Jmd6Ijq8t9g=;
 b=Yqz4LGFI6ZxpRRR58wtVA4bBh5IPCRs75roOX2B/bP0fAcCIMaB0dOncn5wqAl47p7z86lOsfUo//imJog8khQZMYtRJsV6RAYCd2XNfxbLNVw7Vv9ZvZsWXuLIwxBnjPkLEXvKr0l7iMfApSp1PlYvj3NUY1vlHpyYPThRsZNM=
Received: from CWLP265CA0433.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:1d7::19)
 by AS8PR08MB7918.eurprd08.prod.outlook.com (2603:10a6:20b:539::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Mon, 27 Apr
 2026 16:09:29 +0000
Received: from DB1PEPF000509F6.eurprd02.prod.outlook.com
 (2603:10a6:400:1d7:cafe::84) by CWLP265CA0433.outlook.office365.com
 (2603:10a6:400:1d7::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9846.25 via Frontend Transport; Mon,
 27 Apr 2026 16:09:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509F6.mail.protection.outlook.com (10.167.242.152) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9846.18
 via Frontend Transport; Mon, 27 Apr 2026 16:09:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DfBuODsodADHL8f9PnyI3joKIyD0BPOveW7WxZ8+S9AjNYOLULKw2/BAKPRWLvMmdyytTmxnQB++/k7aKIfUYRtrYh60XSW5EOsl0t6jrJdqPiAkCiFHvUP4i/MWwBiX+IvbmYLsVLhCAAEgBJXh5qTQcKcCn0VFEN+p+ZJYDHxsQkr+mItxrhNpn0VO8112PMy1Kr0MPw1WkOv3S/fXJXt7KRO0sfDQXHlLZZcx4lkW0OvX4OLs6Ak7Sm2e6Pi9qxAVWn3jGZOooaiaoV8EwebEJB3iYosatV9cMCJrpGpO+ELqbT5LotFliQEC/htZra9pe5JQzbXpxNBikILEdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q62GnaSA2Vvspl/MfK1e5PDILFIT3C37Jmd6Ijq8t9g=;
 b=pYU08QCqmZNKKbq8XP0Cq3gSFnA8s7+Py9O0cMGCz116OB1ORTp8ghYsIUAlyi71cXbVcoo9JW+2sVtHAI6aOMtc6itzYEMY2Obdor/CKGCXQn8dvVd9vBkDI9quO3fLEvJoxvmBWbRPqHL370AxnOVtp59faIDtHa9yZo4fD1tSolvpvStJ2/PX2RodymqV9WSQOkIYzo1Uw47qDkCfA3wXS7EEQQxtG01cdCIbbno7kvTCUi4EkwruOkUO8jtfMJYas8c6XAR0mPMQl6TkIFcA0qpGYOFkNwwjjpPqKXcLhcW3Zgj2U9oAUSbavMR86zibOE07XwHMvI0pbV7nlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q62GnaSA2Vvspl/MfK1e5PDILFIT3C37Jmd6Ijq8t9g=;
 b=Yqz4LGFI6ZxpRRR58wtVA4bBh5IPCRs75roOX2B/bP0fAcCIMaB0dOncn5wqAl47p7z86lOsfUo//imJog8khQZMYtRJsV6RAYCd2XNfxbLNVw7Vv9ZvZsWXuLIwxBnjPkLEXvKr0l7iMfApSp1PlYvj3NUY1vlHpyYPThRsZNM=
Received: from VI1PR08MB3408.eurprd08.prod.outlook.com (2603:10a6:803:7c::10)
 by VE1PR08MB5792.eurprd08.prod.outlook.com (2603:10a6:800:1a6::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.20; Mon, 27 Apr
 2026 16:08:25 +0000
Received: from VI1PR08MB3408.eurprd08.prod.outlook.com
 ([fe80::6daa:d2f4:acf1:84ba]) by VI1PR08MB3408.eurprd08.prod.outlook.com
 ([fe80::6daa:d2f4:acf1:84ba%7]) with mapi id 15.20.9846.025; Mon, 27 Apr 2026
 16:08:25 +0000
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
Subject: [PATCH 07/43] KVM: arm64: gic-v5: Create & manage VM and VPE tables
Thread-Topic: [PATCH 07/43] KVM: arm64: gic-v5: Create & manage VM and VPE
 tables
Thread-Index: AQHc1mAUg8cc+Wo/p0+C9FJ2cphGjw==
Date: Mon, 27 Apr 2026 16:08:25 +0000
Message-ID: <20260427160547.3129448-8-sascha.bischoff@arm.com>
References: <20260427160547.3129448-1-sascha.bischoff@arm.com>
In-Reply-To: <20260427160547.3129448-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	VI1PR08MB3408:EE_|VE1PR08MB5792:EE_|DB1PEPF000509F6:EE_|AS8PR08MB7918:EE_
X-MS-Office365-Filtering-Correlation-Id: ea5caad8-b097-4f77-3e73-08dea4775c15
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|38070700021|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 pYISLmnY+DI/VoA22VWD+80ZabLDJquze7mmXIHTzNmLOi3MS8fAV9VerGFQYXyJlYcestPIeERxBzmUXfMM8ZhKeKG5IcfB88/s216fcSWbSoAcbdbwubobThKxt5ZfYcxC3Pj5ASC//Cm1z5znY52hhefp9DS0wUvWkF+KyhrXq2vkf/hOabqUsj+lb0dBc6XMWY+/0SQR2rb3eMN1zPA9PR9TOxk+mnNe10mnWK7VW/GzAkocClDU3BrFaD4cC/iKGPRi/KKHmyyjPxM6139FUfpOGsETnc5ZfRpriR6jU+P4lTy2OxskYY4/WR0FcgayaZB7cYs4UrC34TRc4UUFvXN14yTJM7Zy8OQJ3SnF7nz8B6siTDbp3dQLSKJ4BZOLJFgYW96Cc7Rk7N+oMHag7uCtCcsKZehHbSn6wwiIvy68oMRg8WJ5Vu8+PBw5l0DPOu6ryHqdgtjzS10EsPhEL8wL7HW6/cArzjRnlV7jcfAvH0Xe7+b2im7tAiwU4ckiOCZMPrRIR8LA0rkQl3Sq/iXvc80E+larSpKTVF4ey3INlrC49wNdI1aQQgbtSj2fZ489odVsg3QXeUlPnmVHUbcG+zQ0nIBAGrPv4s/ItVHLInVr7Dk5knaVe9aGB+BScAd1NzDGVrDFhVAQo49OCwVHlW931aJv0sRhNsEnECfqpidaQgzdEY+nRBrtqcpzQ2e7aXkS7HY2f7+rKDMsNFRNYv8bVfCVvPauaSsIvYteqxDc7nZJ6jDbp/E9mDUgi+xzXH31JB0gcHgswYQMOYYRrJz3cMYpPGmPPnA=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3408.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 b4l5kbS19KY21eZTr15TX077YIPqQ+QsFolGBes/7aL0GXF55Evvc3VaoC6K968haccJAiqBD7miGj2M1PWnLgXId8ztXU6Gl41v1BMI58Sy095CLRs5Lqq607A3lMlp47CRTqUtx0g0we2q0swS/v6oycbpnPia1S8zf+9KNGrrK900Y4/1N6zyRXWTG6zdxZvx9avgBzCWwmTgaxCbkLTQKciSnn4uLmpHlpH+qbPFfuf9xIGpZ4Reb5Y+maKdB5M98kAw20G3vuQ9Qf3r6f9coyOw3+9CMUq8+DUN0W6xjIyDAbCdekhVudqHajHbbdYgcrPObnVYcO4u0z4E8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR08MB5792
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509F6.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	3dbdbc7e-3459-400a-8f3d-08dea4773691
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|376014|36860700016|82310400026|14060799003|1800799024|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	XGxEJSPPzrswa6gSOfaeppwqiH66bvByQbQbv0bxtdCU4FhO1k0v7QDeGkewzaLK0Dm0+uUsy7vMo7wiQQtmkzbSg0/6D1y+Hbo1lCOiyCNmK8y80a1apkesgGBfLOn9a1uhRRMm5QjbhPXBrEEjXXAPQLc059PS8nkd9JnNrtjKrDi0RtA79la7R1jmJoOMCMe/xeO8/TmCSTmKpqvidbUViZ3GMBmfrbvVH/d4bP5g+NQeCakuYDyxbSMX262vVeeNeLhhV9znXhUJPBxzFEYdjBVs93hk2VpGErA4ZzmbMu/S7RnZ1s/fdXdrCUQsWoVcaLUDqHQESr9o2ku8VROVGdJ81Z9v5jkZkj44Kn9v9N7r+YjXKMW7b8aEIE99JphkpVhSKwVZxdmwI9tpwo4np6KGbc50MHKCvQgIexw6TR9iudNU9BlVGRl7b+33/a+SMyfknIFWusaIbl18LXYNdnCFJjUNO8PL4ZVUDwE4gCGf5dVSfVxn5FIq4h5E0wok1UHQUNpV9CRLH+Rse4uwRPcKXl5RF4YkRPYmMMQ9OPbkakts/fWCRPCVYq6dsc+ZBjZjAwmjT+95dpo30Krsa2IPwwXPaYaoRF2vAUQ6ys9pzTGkVFmYHO0diITCzMQKMVFN7I5er0w5+SwOwB3vUsj8rg01cZoyrl4WJ6rpcqFa85d6/ZDrR6ebatZ+RNJuBIrmP673cWs87lBeTexAmcLqK06Wx0dSYqzAKqzF5ll+zZVQIH8BKg+7OmXV+OXbakKhYH8uG4VJZk0fTg==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(376014)(36860700016)(82310400026)(14060799003)(1800799024)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Ubh6GBIx+f59tndIjnKmm7tLfmhRjYZrVX5QFMSNrG46bn98+bW2zI6MNUR87tV8jPc/hDm41JFBzKkMhULUNh6/yejQpr4I1pxQwbwg3y/5DULOvld/7pleJsZFthLUkpULEBPyCLSZcByU0f5kZq4pj0/hsBtfFXItPFH2fXEOkh0EgOBs1h8U1IywrwG3effHHYkj/mO2ac1zV/ryZKvg4/fPJkQN0nDZV50GuT0Dyac73kc5E6vbxCavui/xB39e4I1Ca3dEEIwdeBnqC9qRZNAdzBNuLuzsmOWasezO+bqGy/lfqRSFWH3OqqpabunU6ctxeSZ31euHfPsb+aA/Fwcg5hLwOrcGo0MEadDS9aZjJXqSvXjRP8IQYqb8xkTA8snNpK+dtujQGdMOimb2cRw9u/62PEnzrIbzMmt34YVJTob6dacrmUOXv3Lt
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2026 16:09:28.5013
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ea5caad8-b097-4f77-3e73-08dea4775c15
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509F6.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB7918

GICv5 uses a set of in-memory tables to track and manage VM
state. These must be allocated by the hypervisor, and provided to the
IRS to use.

The VMT (Virtual Machine Table) is a linear or two level table
comprising VMT Entries (VMTE). Each VMTE describes the state for a
single VM. This state includes things such as the SPI and LPI IST
configuration (coming in a future commit), an implementation-defined
VM Descriptor, and a VPE Table (VPET).

The VPET contains one entry per VPE belonging to a VM, and is used to
mark a VPE as valid, as well as providing the address of an
implementation-defined VPE Descriptor, which is used by the hardware
to track and manage VPE state.

This commit adds support for allocating the VMT, and managing the
VMTEs. The VMTEs can be initialised or released for re-use. Allocation
and tracking of unused VMTEs is handled with an IDA.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-v5-tables.c | 628 +++++++++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic-v5-tables.h | 108 +++++
 include/kvm/arm_vgic.h               |   2 +
 include/linux/irqchip/arm-gic-v5.h   |  13 +
 4 files changed, 751 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-v5-tables.c b/arch/arm64/kvm/vgic/vgi=
c-v5-tables.c
index 30e2b108b1aa3..502d05d46cccf 100644
--- a/arch/arm64/kvm/vgic/vgic-v5-tables.c
+++ b/arch/arm64/kvm/vgic/vgic-v5-tables.c
@@ -3,6 +3,634 @@
  * Copyright (C) 2025, 2026 Arm Ltd.
  */
=20
+#include <kvm/arm_vgic.h>
+#include <linux/kernel.h>
+#include <linux/mm.h>
+#include <linux/sizes.h>
+#include <linux/slab.h>
+#include <linux/xarray.h>
+#include <asm/kvm_mmu.h>
+
+#include "vgic.h"
 #include "vgic-v5-tables.h"
=20
 struct vgic_v5_host_ist_caps gicv5_host_ist_caps;
+
+static struct vgic_v5_vmt *vmt_info;
+DEFINE_XARRAY(vm_info);
+
+static bool vgic_v5_vmt_allocated(void)
+{
+	return vmt_info !=3D NULL;
+}
+
+static int vgic_v5_check_vm_id(u16 vm_id)
+{
+	if (vm_id >=3D vmt_info->num_entries)
+		return -EINVAL;
+
+	return 0;
+}
+
+/*
+ * Our IRS might be coherent or non-coherent. If coherent, we can just emi=
t a
+ * DSB to ensure that we're in sync. However, when non-coherent, we need t=
o
+ * manage our cached data explicitly.
+ *
+ * This helper is used to handle both coherent and non-coherent IRSes, and
+ * handles all combinations of cleaning and invalidating to the PoC.
+ */
+static void vgic_v5_clean_inval(void *va, size_t size, bool clean, bool in=
val)
+{
+	unsigned long base =3D (unsigned long)va;
+
+	/* Catch any accidental NOPs */
+	BUILD_BUG_ON(!(clean || inval));
+
+	/* Coherent; emit DSB. */
+	if (!gicv5_host_ist_caps.irs_non_coherent) {
+		dsb(ishst);
+		return;
+	}
+
+	if (clean && inval)
+		dcache_clean_inval_poc(base, base + size);
+	else if (clean)
+		dcache_clean_poc(base, base + size);
+	else if (inval)
+		dcache_inval_poc(base, base + size);
+}
+
+/*
+ * Create a linear VM table, rounding up the number of entries to at least=
 one
+ * whole page to give us nicer alignment.
+ *
+ * Note: We don't update the number of entries tracked in our tracking str=
ucture
+ * as this might be higher than the number of bits supported by the HW.
+ */
+static int vgic_v5_alloc_vmt_linear(unsigned int num_entries)
+{
+	unsigned int l2_entries_per_page;
+	size_t alloc_size;
+
+	/* Potentially throw away a bit of memory for the sake of alignment! */
+	l2_entries_per_page =3D PAGE_SIZE / GICV5_VMTEL2E_SIZE;
+	if (num_entries < l2_entries_per_page)
+		num_entries =3D l2_entries_per_page;
+
+	alloc_size =3D num_entries * sizeof(struct vmtl2_entry);
+
+	vmt_info->linear.vmt_base =3D kzalloc(alloc_size, GFP_KERNEL);
+	if (vmt_info->linear.vmt_base =3D=3D NULL)
+		return -ENOMEM;
+
+	vgic_v5_clean_inval(vmt_info->linear.vmt_base, alloc_size, true, true);
+
+	return 0;
+}
+
+/*
+ * Allocate the first level of a two-level VM table. The second-level VM t=
ables
+ * are allocated on demand (by vgic_v5_alloc_l2_vmt()).
+ *
+ * Note: If there are too few entries, these are rounded up to the size of=
 an L2
+ * table (4k) to ensure sane alignment. As with the linear table, the trac=
ked
+ * number of entries is not increased to avoid the case of going above wha=
t the
+ * hardware supports.
+ */
+static int vgic_v5_alloc_vmt_two_level(unsigned int num_entries)
+{
+	size_t alloc_size;
+
+	/* Potentially throw away a bit of memory for the sake of alignment! */
+	if (num_entries < GICV5_VMT_L2_TABLE_ENTRIES)
+		num_entries =3D GICV5_VMT_L2_TABLE_ENTRIES;
+
+	/*
+	 * Let's make sure that we always allocate a whole power of 2
+	 * of entries. Note that we need to subtract 1 from the fls()
+	 * result in order to give the correct number of bits as we
+	 * are operating on a whole power of 2.
+	 */
+	num_entries =3D roundup_pow_of_two(num_entries);
+
+	vmt_info->l2.num_l1_ents =3D (num_entries / GICV5_VMT_L2_TABLE_ENTRIES);
+	alloc_size =3D vmt_info->l2.num_l1_ents * sizeof(vmtl1_entry);
+
+	vmt_info->l2.vmt_base =3D kzalloc(alloc_size, GFP_KERNEL);
+	if (vmt_info->l2.vmt_base =3D=3D NULL)
+		return -ENOMEM;
+
+	vgic_v5_clean_inval(vmt_info->l2.vmt_base, alloc_size, true, true);
+
+	vmt_info->l2.l2ptrs =3D kzalloc_objs(*vmt_info->l2.l2ptrs,
+					   vmt_info->l2.num_l1_ents,
+					   GFP_KERNEL);
+	if (vmt_info->l2.l2ptrs =3D=3D NULL) {
+		kfree(vmt_info->l2.vmt_base);
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+
+/*
+ * Allocate a second level VMT, if required. This can be called eagerly, a=
nd
+ * will only perform the allocation if required.
+ */
+static int vgic_v5_alloc_l2_vmt(struct kvm *kvm)
+{
+	unsigned int l1_index;
+	struct vmtl2_entry *l2_table;
+	vmtl1_entry tmp;
+	u16 vm_id =3D vgic_v5_vm_id(kvm);
+	struct kvm_vcpu *vcpu0 =3D kvm_get_vcpu(kvm, 0);
+	struct gicv5_cmd_info cmd_info;
+	int ret;
+
+	if (!vgic_v5_vmt_allocated())
+		return -ENXIO;
+
+	/* Nothing to do if we have linear tables! */
+	if (!vmt_info->two_level)
+		return 0;
+
+	ret =3D vgic_v5_check_vm_id(vm_id);
+	if (ret)
+		return ret;
+
+	/*
+	 * We have 4k-sized L2 tables - this is mandated by the spec for
+	 * two-level VMTs. This means that we have 128 entries per L1 VMTE.
+	 */
+	l1_index =3D vm_id / GICV5_VMT_L2_TABLE_ENTRIES;
+
+	if (l1_index > vmt_info->l2.num_l1_ents)
+		return -E2BIG;
+
+	/* Already valid? Great! */
+	if (vmt_info->l2.l2ptrs[l1_index] !=3D NULL)
+		return 0;
+
+	l2_table =3D kzalloc(GICV5_VMT_L2_TABLE_SIZE, GFP_KERNEL);
+	if (l2_table =3D=3D NULL)
+		return -ENOMEM;
+
+	if (virt_to_phys(l2_table) & ~GICV5_VMTEL1E_L2_ADDR) {
+		kfree(l2_table);
+		return -EINVAL;
+	}
+
+	vmt_info->l2.l2ptrs[l1_index] =3D l2_table;
+
+	/* Alignment issue! */
+	if (virt_to_phys(l2_table) & ~GICV5_VMTEL1E_L2_ADDR) {
+		kfree(l2_table);
+		return -EFAULT;
+	}
+
+	tmp =3D virt_to_phys(l2_table) & GICV5_VMTEL1E_L2_ADDR;
+	WRITE_ONCE(vmt_info->l2.vmt_base[l1_index], cpu_to_le64(tmp));
+
+	vgic_v5_clean_inval(l2_table, GICV5_VMT_L2_TABLE_SIZE, true, true);
+	/* Skip inval for now - wait until table is made valid by HW */
+	vgic_v5_clean_inval(vmt_info->l2.vmt_base + l1_index,
+			    sizeof(vmtl1_entry), true, false);
+
+	/* VMAP in the L2 VMT via the IRS */
+	cmd_info.cmd_type =3D VMT_L2_MAP;
+	ret =3D irq_set_vcpu_affinity(vgic_v5_vpe_db(vcpu0), &cmd_info);
+
+	/* We've failed to make the L2 VMT valid - things are very broken! */
+	if (ret) {
+		/* Remove the pointer from L1 table */
+		WRITE_ONCE(vmt_info->l2.vmt_base[l1_index], 0);
+
+		kfree(l2_table);
+		vmt_info->l2.l2ptrs[l1_index] =3D NULL;
+
+		return ret;
+	}
+
+	/* Table updated; inval our copy */
+	vgic_v5_clean_inval(vmt_info->l2.vmt_base + l1_index,
+			    sizeof(vmtl1_entry), false, true);
+
+	return ret;
+}
+
+/*
+ * Allocate the top-level VMT. This can either be linear or two-level.
+ */
+int vgic_v5_vmt_allocate(bool two_level, unsigned int num_entries,
+			 size_t vmd_size, size_t vped_size,
+			 unsigned int max_vpes)
+{
+	int ret =3D 0;
+
+	if (vgic_v5_vmt_allocated())
+		return -EBUSY;
+
+	/* VMD is optional; using 0 to signal that it not needed. */
+	if (vmd_size !=3D 0 &&
+	    (vmd_size < VMD_MIN_SIZE || vmd_size > VMD_MAX_SIZE))
+		return -EINVAL;
+
+	if (vped_size < VPED_MIN_SIZE || vped_size > VPED_MAX_SIZE)
+		return -EINVAL;
+
+	/* Allocate the tracking structure */
+	vmt_info =3D kzalloc_obj(*vmt_info, GFP_KERNEL);
+	if (vmt_info =3D=3D NULL)
+		return -ENOMEM;
+
+	ida_init(&vmt_info->vm_id_ida);
+	vmt_info->max_vpes =3D max_vpes;
+	vmt_info->vmd_size =3D vmd_size;
+	vmt_info->vped_size =3D vped_size;
+	vmt_info->two_level =3D two_level;
+	vmt_info->num_entries =3D num_entries;
+
+	if (!two_level)
+		ret =3D vgic_v5_alloc_vmt_linear(num_entries);
+	else
+		ret =3D vgic_v5_alloc_vmt_two_level(num_entries);
+
+	/* If anything failed, free our tracking structure before returning */
+	if (ret) {
+		kfree(vmt_info);
+		vmt_info =3D NULL;
+	}
+
+	return ret;
+}
+
+/*
+ * Free the VMT and associated tracking structures. This isn't strictly ex=
pected
+ * to be called in general operation, but instead exists for completeness.
+ */
+int vgic_v5_vmt_free(void)
+{
+	if (!vgic_v5_vmt_allocated())
+		return -EINVAL;
+
+	if (!vmt_info->two_level) {
+		kfree(vmt_info->linear.vmt_base);
+	} else {
+		/* Free the L2 tables; kfree(NULL) is safe */
+		for (int i =3D 0; i < vmt_info->l2.num_l1_ents; ++i)
+			kfree(vmt_info->l2.l2ptrs[i]);
+		kfree(vmt_info->l2.l2ptrs);
+
+		/* And now free the L1 table */
+		kfree(vmt_info->l2.vmt_base);
+	}
+
+	ida_destroy(&vmt_info->vm_id_ida);
+	kfree(vmt_info);
+	vmt_info =3D NULL;
+
+	return 0;
+}
+
+/*
+ * Look up a VMT Entry by VM ID.
+ */
+static int vgic_v5_get_l2_vmte(u16 vm_id, struct vmtl2_entry **vmte)
+{
+	unsigned int l1_index, l2_index;
+	struct vmtl2_entry *l2_table;
+	int ret;
+
+	ret =3D vgic_v5_check_vm_id(vm_id);
+	if (ret)
+		return ret;
+
+	if (!vmt_info->two_level) {
+		/* All entries always valid for Linear table */
+		*vmte =3D &vmt_info->linear.vmt_base[vm_id];
+	} else {
+		l1_index =3D vm_id / GICV5_VMT_L2_TABLE_ENTRIES;
+		l2_index =3D vm_id % GICV5_VMT_L2_TABLE_ENTRIES;
+
+		if (l1_index > vmt_info->l2.num_l1_ents)
+			return -E2BIG;
+
+		if (vmt_info->l2.l2ptrs[l1_index] =3D=3D NULL)
+			return -EINVAL;
+
+		l2_table =3D vmt_info->l2.l2ptrs[l1_index];
+		*vmte =3D &l2_table[l2_index];
+	}
+
+	return 0;
+}
+
+/*
+ * Zero a VMT Entry, and flush & invalidate to the PoC, if required.
+ */
+static int vgic_v5_reset_vmte(struct kvm *kvm)
+{
+	u16 vm_id =3D vgic_v5_vm_id(kvm);
+	struct vmtl2_entry *vmte;
+	int ret;
+
+	ret =3D vgic_v5_get_l2_vmte(vm_id, &vmte);
+	if (ret)
+		return ret;
+
+	WRITE_ONCE(vmte->val[0], 0ULL);
+	WRITE_ONCE(vmte->val[1], 0ULL);
+	WRITE_ONCE(vmte->val[2], 0ULL);
+	WRITE_ONCE(vmte->val[3], 0ULL);
+
+	vgic_v5_clean_inval(vmte, sizeof(*vmte), true, true);
+
+	return 0;
+}
+
+/*
+ * Use the IDA to allocate a new VM ID, and track it in the gicv5_vm data
+ * structure. If we're out of VM IDs, the IDA catches that, and we return =
the
+ * error (-ENOSPC).
+ */
+int vgic_v5_allocate_vm_id(struct kvm *kvm)
+{
+	int id;
+
+	id =3D ida_alloc_max(&vmt_info->vm_id_ida, vmt_info->num_entries - 1u,
+			   GFP_KERNEL);
+	if (id < 0)
+		return id;
+
+	kvm->arch.vgic.gicv5_vm.vm_id =3D id;
+	kvm->arch.vgic.gicv5_vm.vm_id_valid =3D true;
+
+	return 0;
+}
+
+/*
+ * Release the VM ID to allow it to be reallocated in the future.
+ */
+void vgic_v5_release_vm_id(struct kvm *kvm)
+{
+	ida_free(&vmt_info->vm_id_ida, kvm->arch.vgic.gicv5_vm.vm_id);
+	kvm->arch.vgic.gicv5_vm.vm_id_valid =3D false;
+}
+
+/*
+ * Initialise an entry in the VMT based on the index of the VM.
+ *
+ * Note: We don't mark the VMTE as valid as this needs to be done by
+ * the hardware.
+ */
+int vgic_v5_vmte_init(struct kvm *kvm)
+{
+	int nr_cpus =3D atomic_read(&kvm->online_vcpus);
+	struct vgic_v5_vm_info *vmi =3D NULL;
+	u16 vm_id =3D vgic_v5_vm_id(kvm);
+	void *vmd =3D NULL, *vpet =3D NULL;
+	struct vmtl2_entry *vmte;
+	void **vped_ptrs =3D NULL;
+	size_t vpet_alloc_size;
+	int ret;
+	u64 tmp;
+
+	if (nr_cpus > vmt_info->max_vpes)
+		return -E2BIG;
+
+	/*
+	 * If we're using two-level VMTs, L2 is allocated on demand. For linear
+	 * VMTs, this is a NOP.
+	 */
+	if (vgic_v5_alloc_l2_vmt(kvm))
+		return -EIO;
+
+	ret =3D vgic_v5_get_l2_vmte(vm_id, &vmte);
+	if (ret)
+		return ret;
+
+	/* If the entry is already valid, something went wrong */
+	if (FIELD_GET(GICV5_VMTEL2E_VALID, le64_to_cpu(READ_ONCE(vmte->val[0]))))=
 {
+		vgic_v5_clean_inval(vmte, sizeof(*vmte), true, true);
+		return -EINVAL;
+	}
+
+	ret =3D vgic_v5_reset_vmte(kvm);
+	if (ret)
+		return ret;
+
+	vmi =3D kzalloc_objs(*vmi, GFP_KERNEL);
+	if (vmi =3D=3D NULL) {
+		ret =3D -ENOMEM;
+		goto out_fail;
+	}
+
+	ret =3D xa_insert(&vm_info, vm_id, vmi, GFP_KERNEL);
+	if (ret)
+		goto out_fail;
+
+	/* Allocate and assign the VM Descriptor, if required. */
+	if (vmt_info->vmd_size !=3D 0) {
+		vmd =3D kzalloc(vmt_info->vmd_size, GFP_KERNEL);
+		if (!vmd) {
+			ret =3D -ENOMEM;
+			goto out_fail;
+		}
+
+		/* Stash the VA so we can free it later */
+		vmi->vmd_base =3D vmd;
+
+		tmp =3D FIELD_PREP(GICV5_VMTEL2E_VMD_ADDR,
+				virt_to_phys(vmd) >>
+				GICV5_VMTEL2E_VMD_ADDR_SHIFT);
+		WRITE_ONCE(vmte->val[0], cpu_to_le64(tmp));
+	}
+
+	/*
+	 * Allocate and assign the VPE Table. We can only describe the number of
+	 * VPE ID Bits in the VMTE, and therefore we round up the number of CPUs
+	 * to a whole power of two.
+	 */
+	nr_cpus =3D roundup_pow_of_two(nr_cpus);
+	vmi->vpe_id_bits =3D fls(nr_cpus) - 1;
+
+	vpet_alloc_size =3D sizeof(vpe_entry) * nr_cpus;
+	vpet =3D kzalloc(vpet_alloc_size, GFP_KERNEL);
+	if (!vpet) {
+		ret =3D -ENOMEM;
+		goto out_fail;
+	}
+
+	/* Stash the VA so we can free it later */
+	vmi->vpet_base =3D vpet;
+
+	tmp =3D FIELD_PREP(GICV5_VMTEL2E_VPET_ADDR,
+			virt_to_phys(vpet) >> GICV5_VMTEL2E_VPET_ADDR_SHIFT);
+	tmp |=3D FIELD_PREP(GICV5_VMTEL2E_VPE_ID_BITS, vmi->vpe_id_bits);
+	WRITE_ONCE(vmte->val[1], cpu_to_le64(tmp));
+
+	vped_ptrs =3D kzalloc_objs(*vped_ptrs, nr_cpus, GFP_KERNEL);
+	if (vped_ptrs =3D=3D NULL) {
+		ret =3D -ENOMEM;
+		goto out_fail;
+	}
+	vmi->vped_ptrs =3D vped_ptrs;
+
+	if (vmd)
+		vgic_v5_clean_inval(vmd, vmt_info->vmd_size, true, true);
+	vgic_v5_clean_inval(vpet, vpet_alloc_size, true, true);
+	vgic_v5_clean_inval(vmte, sizeof(*vmte), true, true);
+
+	kvm->arch.vgic.gicv5_vm.vmte_allocated =3D true;
+
+	return 0;
+
+out_fail:
+	/* kfree(NULL) is safe so we can just kfree() at leisure */
+	kfree(vmd);
+	kfree(vpet);
+	kfree(vped_ptrs);
+	if (vmi)
+		xa_erase(&vm_info, vm_id);
+	kfree(vmi);
+
+	vgic_v5_reset_vmte(kvm);
+
+	return ret;
+}
+
+/*
+ * Release the VMT Entry, freeing up any allocated data structures before
+ * zeroing the VMTE.
+ *
+ * The VMTE must be marked as invalid before it is released.
+ */
+int vgic_v5_vmte_release(struct kvm *kvm)
+{
+	u16 vm_id =3D vgic_v5_vm_id(kvm);
+	struct vgic_v5_vm_info *vmi;
+	struct vmtl2_entry *vmte;
+	int ret;
+
+	ret =3D vgic_v5_get_l2_vmte(vm_id, &vmte);
+	if (ret)
+		return ret;
+
+	/* Reject if the VMTE has not been marked as invalid! */
+	if (FIELD_GET(GICV5_VMTEL2E_VALID, le64_to_cpu(READ_ONCE(vmte->val[0]))))=
 {
+		vgic_v5_clean_inval(vmte, sizeof(*vmte), true, true);
+		return -EINVAL;
+	}
+
+	vmi =3D xa_load(&vm_info, vm_id);
+	if (WARN_ON_ONCE(!vmi))
+		goto no_vmi;
+
+	kfree(vmi->vmd_base);
+	kfree(vmi->vpet_base);
+
+	xa_erase(&vm_info, vm_id);
+	kfree(vmi);
+
+no_vmi:
+	/*
+	 * If we didn't get far enough into allocating a VMTE to create the VM
+	 * info structure, then we just zero the VMTE and move on. There's
+	 * nothing else we can realistically do here.
+	 */
+	ret =3D vgic_v5_reset_vmte(kvm);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+/*
+ * Allocate a VPE descriptor and provide it to the hardware via the VPE Ta=
ble.
+ */
+int vgic_v5_vmte_alloc_vpe(struct kvm_vcpu *vcpu)
+{
+	u16 vm_id =3D vgic_v5_vm_id(vcpu->kvm);
+	u16 vpe_id =3D vgic_v5_vpe_id(vcpu);
+	struct vgic_v5_vm_info *vmi;
+	vpe_entry tmp, *vpet_base;
+	void *vped;
+
+	/* Make sure we're not over what the hardware supports */
+	if (vpe_id >=3D vmt_info->max_vpes)
+		return -E2BIG;
+
+	vmi =3D xa_load(&vm_info, vm_id);
+	if (WARN_ON_ONCE(!vmi))
+		return -EINVAL;
+
+	if (vpe_id >=3D 1 << vmi->vpe_id_bits)
+		return -E2BIG;
+
+	vpet_base =3D vmi->vpet_base;
+
+	/* If the VPETE for this CPU is already valid we've gone wrong */
+	if (FIELD_GET(GICV5_VPE_VALID, le64_to_cpu(READ_ONCE(vpet_base[vpe_id])))=
) {
+		vgic_v5_clean_inval(&vpet_base[vpe_id], sizeof(*vpet_base), true, true);
+		return -EBUSY;
+	}
+
+	/* Alloc VPE Descriptor. Only used by IRS. */
+	vped =3D kzalloc(vmt_info->vped_size, GFP_KERNEL);
+	if (vped =3D=3D NULL)
+		return -ENOMEM;
+
+	vmi->vped_ptrs[vpe_id] =3D vped;
+
+	tmp =3D FIELD_PREP(GICV5_VPED_ADDR, virt_to_phys(vped) >> GICV5_VPED_ADDR=
_SHIFT);
+	WRITE_ONCE(vpet_base[vpe_id], cpu_to_le64(tmp));
+
+	vgic_v5_clean_inval(vped, vmt_info->vped_size, true, true);
+	vgic_v5_clean_inval(vpet_base + vpe_id, sizeof(vpe_entry), true, true);
+
+	return 0;
+}
+
+/*
+ * Free the memory allocated for the VPE descriptor.
+ */
+int vgic_v5_vmte_free_vpe(struct kvm_vcpu *vcpu)
+{
+	u16 vm_id =3D vgic_v5_vm_id(vcpu->kvm);
+	u16 vpe_id =3D vgic_v5_vpe_id(vcpu);
+	struct vgic_v5_vm_info *vmi;
+	struct vmtl2_entry *vmte;
+	vpe_entry *vpet_base;
+	void *vped;
+	int ret;
+
+	ret =3D vgic_v5_get_l2_vmte(vm_id, &vmte);
+	if (ret)
+		return ret;
+
+	if (FIELD_GET(GICV5_VMTEL2E_VALID, le64_to_cpu(READ_ONCE(vmte->val[0]))))=
 {
+		vgic_v5_clean_inval(vmte, sizeof(*vmte), true, true);
+		return -EBUSY;
+	}
+
+	vmi =3D xa_load(&vm_info, vm_id);
+	if (!vmi)
+		return -EINVAL;
+
+	if (vpe_id >=3D 1 << vmi->vpe_id_bits)
+		return -E2BIG;
+
+	vpet_base =3D vmi->vpet_base;
+	WRITE_ONCE(vpet_base[vpe_id], 0ULL);
+
+	vgic_v5_clean_inval(vpet_base + vpe_id, sizeof(vpe_entry), true, true);
+
+	/* Free VPE Descriptor. Only used by IRS. */
+	vped =3D vmi->vped_ptrs[vpe_id];
+	vmi->vped_ptrs[vpe_id] =3D NULL;
+	kfree(vped);
+
+	return 0;
+}
diff --git a/arch/arm64/kvm/vgic/vgic-v5-tables.h b/arch/arm64/kvm/vgic/vgi=
c-v5-tables.h
index cf00a248eabd5..5501a44308362 100644
--- a/arch/arm64/kvm/vgic/vgic-v5-tables.h
+++ b/arch/arm64/kvm/vgic/vgic-v5-tables.h
@@ -8,6 +8,86 @@
=20
 #include <linux/irqchip/arm-gic-v5.h>
=20
+#define VM_ID_BITS_MIN	8
+#define VM_ID_BITS_MAX	16
+#define VMD_MIN_SIZE	8
+#define VMD_MAX_SIZE	4096
+#define VPED_MIN_SIZE	8
+#define VPED_MAX_SIZE	4096
+#define VPE_ID_BITS_MIN	8
+#define VPE_ID_BITS_MAX	16
+
+/* Level 1 Virtual Machine Table Entry */
+typedef __le64 vmtl1_entry;
+#define GICV5_VMTEL1E_VALID		BIT_ULL(0)
+/* Note that there is no shift for the address by design */
+#define GICV5_VMTEL1E_L2_ADDR		GENMASK(51, 12)
+
+#define GICV5_VMTEL2E_SIZE		32ULL
+/* An L2 table (two-level VMT) is ALWAYS 4kB! */
+#define GICV5_VMT_L2_TABLE_SIZE		4096ULL
+#define GICV5_VMT_L2_TABLE_ENTRIES	(GICV5_VMT_L2_TABLE_SIZE / GICV5_VMTEL2=
E_SIZE)
+
+/* Level 2 Virtual Machine Table Entry */
+struct vmtl2_entry {
+	__le64 val[4];
+};
+
+/*
+ * As the L2 VMTE is a large data structure, we are splitting it into 4 pa=
rts.
+ * We only mask and shift WITHIN each part for simplicity.
+ */
+/* First 64-bit chunk */
+#define GICV5_VMTEL2E_VALID		BIT_ULL(0)
+#define GICV5_VMTEL2E_VMD_ADDR_SHIFT	3ULL
+#define GICV5_VMTEL2E_VMD_ADDR		GENMASK_ULL(55, 3)
+/* Second 64-bit chunk */
+#define GICV5_VMTEL2E_VPET_ADDR_SHIFT	3ULL
+#define GICV5_VMTEL2E_VPET_ADDR		GENMASK_ULL(55, 3)
+#define GICV5_VMTEL2E_VPE_ID_BITS	GENMASK_ULL(63, 59)
+/* Third & fourth 64-bit chunks (the encodings are the same for each) */
+#define GICV5_VMTEL2E_IST_VALID		BIT_ULL(0)
+#define GICV5_VMTEL2E_IST_L2SZ		GENMASK_ULL(2, 1)
+#define GICV5_VMTEL2E_IST_ADDR_SHIFT	6ULL
+#define GICV5_VMTEL2E_IST_ADDR		GENMASK_ULL(55, 6)
+#define GICV5_VMTEL2E_IST_ISTSZ		GENMASK_ULL(57, 56)
+#define GICV5_VMTEL2E_IST_STRUCTURE	BIT_ULL(58)
+#define GICV5_VMTEL2E_IST_ID_BITS	GENMASK_ULL(63, 59)
+
+/* Virtual PE Table Entry */
+typedef __le64 vpe_entry;
+#define GICV5_VPE_VALID			BIT_ULL(0)
+/* Note that there is no shift for the address by design. */
+#define GICV5_VPED_ADDR_SHIFT		3ULL
+#define GICV5_VPED_ADDR			GENMASK_ULL(55, 3)
+
+struct vgic_v5_vm_info {
+	void __iomem		*vmd_base;
+	vpe_entry __iomem	*vpet_base;
+	void __iomem		**vped_ptrs;
+	u8			vpe_id_bits;
+};
+
+struct vgic_v5_vmt {
+	union {
+		struct {
+			struct vmtl2_entry *vmt_base;
+			unsigned int num_ents;
+		} linear;
+		struct {
+			vmtl1_entry *vmt_base;
+			struct vmtl2_entry **l2ptrs;
+			unsigned int num_l1_ents;
+		} l2;
+	};
+	bool		two_level;
+	unsigned int	num_entries;
+	unsigned int	max_vpes;
+	size_t		vmd_size;
+	size_t		vped_size;
+	struct ida	vm_id_ida;
+};
+
 struct vgic_v5_host_ist_caps {
 	/* IST Capabilities */
=20
@@ -38,4 +118,32 @@ static inline struct vgic_v5_host_ist_caps *vgic_v5_hos=
t_caps(void)
 	return &gicv5_host_ist_caps;
 }
=20
+static inline u16 vgic_v5_vm_id(struct kvm *kvm)
+{
+	return kvm->arch.vgic.gicv5_vm.vm_id;
+}
+
+static inline u16 vgic_v5_vpe_id(struct kvm_vcpu *vcpu)
+{
+	return vcpu->vcpu_id;
+}
+
+static inline int vgic_v5_vpe_db(struct kvm_vcpu *vcpu)
+{
+	return vcpu->arch.vgic_cpu.vgic_v5.gicv5_vpe.db;
+}
+
+int vgic_v5_vmt_allocate(bool two_level, unsigned int num_entries,
+			 size_t vmd_size, size_t vped_size,
+			 unsigned int vpe_id_bits);
+int vgic_v5_vmt_free(void);
+
+int vgic_v5_allocate_vm_id(struct kvm *kvm);
+void vgic_v5_release_vm_id(struct kvm *kvm);
+
+int vgic_v5_vmte_init(struct kvm *kvm);
+int vgic_v5_vmte_release(struct kvm *kvm);
+int vgic_v5_vmte_alloc_vpe(struct kvm_vcpu *vcpu);
+int vgic_v5_vmte_free_vpe(struct kvm_vcpu *vcpu);
+
 #endif
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 05dbd01f6fd21..0bcbc751593cc 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -372,6 +372,8 @@ struct vgic_v5_vm {
 	int			vpe_db_base;
 	int			nr_vpes;
 	u16			vm_id;
+	bool			vm_id_valid;
+	bool			vmte_allocated;
 };
=20
 struct vgic_dist {
diff --git a/include/linux/irqchip/arm-gic-v5.h b/include/linux/irqchip/arm=
-gic-v5.h
index 087d94f739672..89579ee04f5d1 100644
--- a/include/linux/irqchip/arm-gic-v5.h
+++ b/include/linux/irqchip/arm-gic-v5.h
@@ -182,6 +182,7 @@
 #define GICV5_IRS_MAP_L2_ISTR_ID	GENMASK(23, 0)
=20
 #define GICV5_ISTL1E_VALID		BIT_ULL(0)
+#define GICV5_IRS_ISTL1E_SIZE		8UL
=20
 #define GICV5_ISTL1E_L2_ADDR_MASK	GENMASK_ULL(55, 12)
=20
@@ -444,4 +445,16 @@ void gicv5_free_lpi(u32 lpi);
=20
 void __init gicv5_its_of_probe(struct device_node *parent);
 void __init gicv5_its_acpi_probe(void);
+
+enum gicv5_vcpu_info_cmd_type {
+	VMT_L2_MAP,		/* Map in a L2 VMT - *may* happen on VM init */
+	VMTE_MAKE_VALID,	/* Make the VMTE valid */
+	VMTE_MAKE_INVALID,	/* Make the VMTE (et al.) invalid */
+};
+
+struct gicv5_cmd_info {
+	enum gicv5_vcpu_info_cmd_type	cmd_type;
+	u64				data;
+};
+
 #endif
--=20
2.34.1
