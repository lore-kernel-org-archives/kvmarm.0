Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010050.outbound.protection.outlook.com [52.101.84.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB0C63537D2
	for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 14:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.50
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779375226; cv=fail; b=l5/EG2kuMaS5oAYcn2rB2L44nkPJvS4opmoRiLDFnfbMCaDgy13po/r6wbgnPMuiNKjYotsJnvGqBihWVjirXbm/bXFZqt88mAd/xtC471Xq+FpIllgP+mBbshl8eOhhd7oUJ/Um20YRqPNGvbMSl0MdOE2+40bsQffNT1gA52k=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779375226; c=relaxed/simple;
	bh=CBEudaM1SDI3x51jduzmySkCdfW4kIXa5eJZGzDUNXE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=GIsfjCzQmzZMAXCNnfdNp142jll/lXX7pZa8NIBchSNmFw6aHnGxkW8llc8nJIsUPBVtD6tO1fPi6zBH+QXsjRsjrkQhUoaQynGwr5ZJ+OyCOWseVVRhl+8TLk5FLuncNLD1fHUQ9ACspLHZXZf9LmkyBmJQzcd+0zGb1kTubYY=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ZOs+77jy; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ZOs+77jy; arc=fail smtp.client-ip=52.101.84.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ZOs+77jy";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ZOs+77jy"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=fail;
 b=IV12AokjVxoZryRUiEN+/LO8BlJXU2nxw+KmXtpYzQetnm1t6y6C0U7yg+BKXsUlNvPzHBLzYU3tx7MY0WUSn27/+zwm95QXWBRhhne6Zej6aD7d64GMRfhhuxricvbD6rHg4FyjP4K/1ffZTQT6kMDbhT4iKcouMyAhFpsDZE0ZZuEu8AkDu/DdZcaSItezvtjTA4JRJ8q0v5syGaEGm0PbI0nnFlwCjHrmUTzLVH8LLCaYdTFTx9lLzP94T0i8dFbyPhUH6Rpxpk8oQ61uJFMcAB7wI353qIK5KrJF63n/eBhWSCw7I3Jb8kCwnQ1zHrWrPJKJnEWzUU/0Aw80/g==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4bLMqK4YQXkTZNJY2KfxAW4BHU8oq3D+SE+2aDDX1pg=;
 b=cllHYwB+H9ioHZbb9exfx15Cgeeg37fKx7ORdiP6J8dHDhLOkXFCaBcloi0QjQdzyE65/mKuRB3jckSJqdpqMA1wD7utcbr2gws/rMOLLjhScnN3mFiu5b6D+swKPgekPDsrF/lnTSV0FOX1t3RHDoYbu5tXcfLkDHioQr+gePr0tKc1op7vW/fxQpC+gysP/ZMppzcntzCxx/PHTALNM0tecUwUfZ1ClOi/DjR2aDLQWDyx9lkOpIhKdTIwis8tXrnewxHUY4beQ2ER9Gtdq25KHWCb55gzH0vfn4RqHm2zcAXdU/sG+up9bSiRGFKceX/P0D7rMTxKHgRSoMyZCA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=fail (48)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4bLMqK4YQXkTZNJY2KfxAW4BHU8oq3D+SE+2aDDX1pg=;
 b=ZOs+77jym6Ggi/WMBjLWuADnk7ByA7GPrUYeHGHiqEP2vwwwNyVwl6qEaXL0h6Rd2RQR1zJIeTocSc0r69GEVmu5bh6vlb+l7CFk+Gq7B9KNUo7ljaHm7UhHav+mVu79gS3qVkxLefWCb7OBXmwLHTynYkSUH1ZqO5nuFA1nScg=
Received: from DUZPR01CA0254.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4b5::26) by AS2PR08MB8925.eurprd08.prod.outlook.com
 (2603:10a6:20b:5f8::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.14; Thu, 21 May
 2026 14:53:36 +0000
Received: from DU2PEPF0001E9C1.eurprd03.prod.outlook.com
 (2603:10a6:10:4b5:cafe::73) by DUZPR01CA0254.outlook.office365.com
 (2603:10a6:10:4b5::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.48.17 via Frontend Transport; Thu, 21
 May 2026 14:53:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF0001E9C1.mail.protection.outlook.com (10.167.8.70) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.48.11 via
 Frontend Transport; Thu, 21 May 2026 14:53:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fzh6Te13iWDw7b8ePX57L3wKMrFB6/F8zuP+CgXRKudZ5b2WzYy++gy6svKULAXdruduDR108rmZu7u+u5Un0/uqxxcoVk/II849hmSVnB6al5vNHJL+ogD/68yyFo+xaqvABmkUuHt8ycYCOToNTnbY4AYq9K+A2NnEsEVK5jVorX5yeqSApeX54QEF0m4AQzsVI5Ay0wsMJUY6MXhU5IM3C6p6DZXrUC24+7sYKc36avrUI29dfj7fsXTob3kkTGqlAZJld6I70XOo9dzHuFTW5puZsK4Iyv14KfJ7s4ZXw697nYo8PpFiqX6BFqTCLpr2+AKhx8jjXIkPAwCoDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4bLMqK4YQXkTZNJY2KfxAW4BHU8oq3D+SE+2aDDX1pg=;
 b=GOhwaMHoQyLVT3dF6+cltIv58F5ZPgIJU1C5A83SeqVEg6pJHPTvBGh0eJWpG5T5wlmdznzaZjhR+EvObClFrar6vdW8UIMnEt2v0PtPXyvA5Xz0+CauEVG2rGjJVH9BiXRpFIGgP0xOsAI6p1fk+OaAbT7yrRlZeRc7Ll21ZoAgptx7ezdVpZSWyD8oykdUHigIxZOl2vt/A02ztF0pNcKPhnYFUKWdSvRvxdFZv+tT5xhyZJ9JRs2jRfeEmH15G7PIv0QMStZx2jf502RbwJzrDNzlGZac9pTt3Zhged5mjdqTtkWCgmpGvfSfsbxstpW86RKKEW14mMelQfW/8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4bLMqK4YQXkTZNJY2KfxAW4BHU8oq3D+SE+2aDDX1pg=;
 b=ZOs+77jym6Ggi/WMBjLWuADnk7ByA7GPrUYeHGHiqEP2vwwwNyVwl6qEaXL0h6Rd2RQR1zJIeTocSc0r69GEVmu5bh6vlb+l7CFk+Gq7B9KNUo7ljaHm7UhHav+mVu79gS3qVkxLefWCb7OBXmwLHTynYkSUH1ZqO5nuFA1nScg=
Received: from GV1PR08MB7315.eurprd08.prod.outlook.com (2603:10a6:150:1e::15)
 by VE1PR08MB5856.eurprd08.prod.outlook.com (2603:10a6:800:1ab::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.17; Thu, 21 May
 2026 14:52:33 +0000
Received: from GV1PR08MB7315.eurprd08.prod.outlook.com
 ([fe80::c249:1aed:a4c2:4193]) by GV1PR08MB7315.eurprd08.prod.outlook.com
 ([fe80::c249:1aed:a4c2:4193%3]) with mapi id 15.21.0048.013; Thu, 21 May 2026
 14:52:33 +0000
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
Subject: [PATCH v2 10/39] KVM: arm64: gic-v5: Introduce guest IST alloc and
 management
Thread-Topic: [PATCH v2 10/39] KVM: arm64: gic-v5: Introduce guest IST alloc
 and management
Thread-Index: AQHc6TF02IXwXC943UGwwAoUL7eRGA==
Date: Thu, 21 May 2026 14:52:33 +0000
Message-ID: <20260521144846.1899475-11-sascha.bischoff@arm.com>
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
	GV1PR08MB7315:EE_|VE1PR08MB5856:EE_|DU2PEPF0001E9C1:EE_|AS2PR08MB8925:EE_
X-MS-Office365-Filtering-Correlation-Id: 3310bafe-7311-4d6c-1526-08deb748bcb5
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|38070700021|56012099003|18002099003|22082099003|11063799006|6133799003|3023799007;
X-Microsoft-Antispam-Message-Info-Original:
 9WCywEI+JfUW0bRWeL0btJ35QbG+MgOUddSFhf2cPw7X7LXsWoJKKfv2M0AkOsQ3UKfRG3+7toUO/68wXpHD8AAthr0m0sk2RJCdw2uKc1IQUbq/NyCSEe7qoq8+9rQ+Q/mr2F8Y/zIdPIQGFvoNiFav/0ccsloVaJnLevvPKmoqcoKxbXkzWRqp+R3oADpxf02KBq7rrZoMiTOaeN1+rs1grsqJE79XmH5pHYGyWTopte5cai4NYsDRJHgDAKKWN243KG8D5fr4IzIEiEiPm0yYF+PmCDkZfUrYUD+OXyb0ZMmO33jA32c4K4swIKllgENJQY1QJ2CU0vbH41h5a3eXo/0oUKTnum4nZ2ClJAi5GLB4P9BR+h5n+leI0uBInP2mItHvnNgCL3KINW4A/E7viM8YQLGHq3L9tvoSK92C4vSPMPa1hEgIPjrzaCqBq4TER3nGfZA1PFJHgoTCqsMq/YKFpeIQmP4TvP1zgiCaYrU0MD/vwVrijCiij7R0kfIRuNW0ZthsVbKfnSJn/nFpVi8TlyHROssULy9+ObXwXekXaDFsXL9PB2TWElGe0wbMbuITG4aS7Z0MVcDA9WhK81rXDuyRKWiEgB5GbIJVmdxAcERrkxMFuBPC6Qb/XFGxGqOB0V/4NeAFgXMla5bfdJzws2I9OpKD9ElpncJFA7k/Qdr7Nr2lRYFmM++kxySlm5XhCwtYI3i+lFHl98a15RR+GzF4qJJy/ljFdcmMhbzCixmrbogZ4SqYeQ3R
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB7315.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021)(56012099003)(18002099003)(22082099003)(11063799006)(6133799003)(3023799007);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 dppUxzmvoc+v7ybT7j8oOBnpAmlnMjuiYNKRAlA1sH5eSgHCdj8ydfL6dm/TFJ6l+M1atEV63K3V8MOQlXbOxF7DBw8MYR7UZyh5VG+l2XZFb4cjP10MIN60ohjmueaEuDnqH95+YXtS81/sgLHVyC63IRANYE3lKSSNlkRvQx9kPPurTbxMSYn1CJWyBo5f0qsZYNN+8luiKTfzOSavlSO6IcopUa8lD2kFfpmpnkPw6wIKeYKWoxJepIcR3igpExttC+L+uMP2I4K/YTxlt7eNUlOcn2ff/4O6FR+SMXTK6MIf91A/bpnTgUFKiA5+l0ZrCG94c4NiM3IkmZrC/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR08MB5856
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF0001E9C1.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	bd01de9a-9d75-407e-3e47-08deb7489760
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|1800799024|82310400026|376014|35042699022|36860700016|22082099003|18002099003|56012099003|3023799007|11063799006|6133799003;
X-Microsoft-Antispam-Message-Info:
	9lqcHTat5JsJtjleNo9SwEMcC6avUngA/E2wnjbJLy5FF9bq3LL62GLw2Qqth6qfp8e3tlV9l0N1inBvXs6AH+ibxySf834S1Ku0zR2iV72hwtNEv0b8f2Rlxomte8gSkbAMba3HraWwpJaCc2sY3XQKNqBBbUwpmVvibcUciSMG0QZGEwnsR5HN8Imrjocv/bbs/zNaoArMeS2oUOW+gnM4WY/Ui9LjkzfwXQaWkRU2lqRtnV2hk6wuWQzZDTRjqj0dcVGeNaMZEzyyJF8XO9ljvVp1rcn2Oj8IOyGf55EPKqDIs3h/Fv9ivtUE/aCpNuUQXIslPuxfV0O6T2G/Zt9Pxd0TZH7k9bltGdYrAPRIV41nCZOSTLbOE+BlEOsk76vbSCaZqn6wxbYdBREzVWSo6ukMtpLSVTvYG5ZQ6FzgP86fiLSyLq2llXg6ZJMluSRTM153loq137Y53b/pHNMefS5ZvA7j3kS4dYfJH698y7syPoLmuTWQ6bqm2W0C7IMRc4ju0lhad/UKDX3BDaOmSI8xTCDXgJdcWBvnmrLBoX23ieKAACQtv6XmV+t4W1jV1AkqH0pcA+eZUl733MvltanQy5NOjxINkyRB22SRyh1q2gt263Y0LmNm0dbddXL7AooAIwjIKFkptFrrEqqFUxRbArhSrTYpvcFEJFQIL3LGI1E1CPv+8C239hxj4PIceKSc2r5PK49AIIEL1i5p1hqJJmSFLg/VRU2UUgE=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(1800799024)(82310400026)(376014)(35042699022)(36860700016)(22082099003)(18002099003)(56012099003)(3023799007)(11063799006)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	JdpsOXQd8npajXP4t3gHp+1025tPhDuh7G0QoAOvk7PY/rHyZGX8Fn1RNrPJ9zNwU9GIoBX2sBnlc4MEYozdgkuZhuqLAvdiMyZcnPIVnh3XFNs1Ljc4fIzUlziYhPdAQtSqWL+IjS/Wfeza/ili/Nqap4i3C0e8s/firAnuHYd72do+Hhaft93hrBmZOfFf5llrFjGHb/pnMQWSkT66IbspmBi7hVwfInZRSZkMo3ugIYvgHzYQapg4hUQ69VwX6W9cE2dokVzVq6WOYpwjW/yCtS70/T4dh0SEhqHRBr2FR0TVGVqpHiI9GSl/8HxABt5W++L7RVQ2h2I9VJO/F36UkULejozWm+S6FU+WiGoKONBGs/UI6fui78Ihq8zw5rJMUI/M53d6n3g3tYkZJsL2MbdfLgJlRS5uOfvUdL/oCDRqfOD9eSAFY1eRstUk
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2026 14:53:36.3590
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3310bafe-7311-4d6c-1526-08deb748bcb5
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF0001E9C1.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB8925

GICv5 guests use Interrupt State Tables (ISTs) to track and manage the
interrupt state for SPIs and LPIs. These ISTs are provided to the host's
IRS via the VMTE.

On a host GICv5 system, SPIs do not require any up-front memory
allocation prior to their use, unlike LPIs which require the OS to
allocate an IST. For a GICv5 guest, the same holds from the guest's
point of view: SPIs should require no explicit memory allocation by the
guest. This means that KVM must provision the memory passed to the IRS
for managing a guest's SPI state.

Allocate the SPI IST before running the guest for the first time. As only
a small number of SPIs are expected, this is always allocated as a linear
IST. The host is responsible for freeing this memory on guest teardown.

For LPIs, the guest provisions memory for its LPI IST. KVM does not pass
that memory directly to the host IRS. Instead, allocate a shadow LPI IST
and pass that to the IRS through the VMTE. The LPI IST may be allocated
as a two-level structure when supported and required by the configured
LPI ID space, as many more LPIs are expected than SPIs. The host frees
this memory on guest teardown.

This commit also extends the doorbell domain to allow the doorbells
themselves to act as a conduit for issuing commands, similar to what
exists for GICv4 support. Effectively, irq_set_vcpu_affinity() becomes
an ioctl-like interface for issuing commands specific to either a VM or
the particular VPE that the doorbell belongs to. Add support for:

        VMT_L2_MAP - Make a second level VM table valid
        VMTE_MAKE_VALID - Make a single VMTE, and hence VM, valid
        VMTE_MAKE_INVALID - Make a single VMTE, and hence VM, invalid
        SPI_VIST_MAKE_VALID - Make the SPI IST valid
        LPI_VIST_MAKE_VALID - Make the LPI IST valid
        LPI_VIST_MAKE_INVALID - Make the LPI IST invalid

None of these commands are plumbed through to the host IRS at this
stage.

There is intentionally no SPI_VIST_MAKE_INVALID command. The SPI IST is
allocated as part of VM creation and is not invalidated while the VM is
live. It is freed when the VM is destroyed, after the VMTE has been made
invalid. The LPI IST, on the other hand, is driven by the guest, which is
free to invalidate and free its LPI IST at any point.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-v5-tables.c | 527 +++++++++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic-v5-tables.h |  22 ++
 arch/arm64/kvm/vgic/vgic-v5.c        |   3 +
 include/linux/irqchip/arm-gic-v5.h   |   3 +
 4 files changed, 555 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-v5-tables.c b/arch/arm64/kvm/vgic/vgi=
c-v5-tables.c
index e9b92893b4e1f..a1d0f620b7913 100644
--- a/arch/arm64/kvm/vgic/vgic-v5-tables.c
+++ b/arch/arm64/kvm/vgic/vgic-v5-tables.c
@@ -59,6 +59,14 @@ static DEFINE_XARRAY(vm_info);
 #define GICV5_VPED_ADDR_SHIFT		3ULL
 #define GICV5_VPED_ADDR			GENMASK_ULL(55, 3)
=20
+/*
+ * The LPI and SPI configuration is stored in the 2nd and 3rd 64-bit chunk=
s of
+ * the VMTE (0-based). We call this a section here in an attempt to simpli=
fy the
+ * code.
+ */
+#define GICV5_VMTEL2_LPI_SECTION	2
+#define GICV5_VMTEL2_SPI_SECTION	3
+
 /*
  * Our IRS might be coherent or non-coherent. If coherent, we can just emi=
t a
  * DSB to ensure that we're in sync. However, when non-coherent, we need t=
o
@@ -489,6 +497,25 @@ int vgic_v5_vmte_init(struct kvm *kvm)
 	return ret;
 }
=20
+/*
+ * The following set of forward declarations makes the code layout a *litt=
le*
+ * clearer as it lets us keep the IST-related code together.
+ */
+static int vgic_v5_alloc_linear_ist(struct kvm *kvm, bool spi_ist,
+				    unsigned int id_bits,
+				    unsigned int istsz);
+static int vgic_v5_alloc_l1_ist(struct kvm *kvm, unsigned int id_bits,
+				unsigned int istsz, unsigned int l2_split);
+static int vgic_v5_alloc_l2_ists(struct kvm *kvm, unsigned int id_bits,
+				 unsigned int istsz, unsigned int l2_split);
+static int vgic_v5_alloc_two_level_lpi_ist(struct kvm *kvm,
+					   unsigned int id_bits,
+					   unsigned int istsz,
+					   unsigned int l2_split);
+static int vgic_v5_linear_ist_free(struct kvm *kvm, bool spi);
+static int vgic_v5_two_level_ist_free(struct kvm *kvm, bool spi);
+static int vgic_v5_spi_ist_free(struct kvm *kvm);
+
 /*
  * Release the VMT Entry, freeing up any allocated data structures before
  * zeroing the VMTE.
@@ -521,6 +548,20 @@ int vgic_v5_vmte_release(struct kvm *kvm)
 	kfree(vmi->vpet_base);
 	kfree(vmi->vmd_base);
=20
+	/* If we have an LPI IST, free it */
+	if (vmi->h_lpi_ist) {
+		ret =3D vgic_v5_lpi_ist_free(kvm);
+		if (ret)
+			return ret;
+	}
+
+	/* If we have an SPI IST, free it */
+	if (vmi->h_spi_ist) {
+		ret =3D vgic_v5_spi_ist_free(kvm);
+		if (ret)
+			return ret;
+	}
+
 	xa_erase(&vm_info, vm_id);
 	kfree(vmi);
=20
@@ -623,3 +664,489 @@ int vgic_v5_vmte_free_vpe(struct kvm_vcpu *vcpu)
=20
 	return 0;
 }
+
+/*
+ * Assign an already allocated IST to the VM by populating the fields in t=
he
+ * corresponding VMTE. We re-use this code for both an SPI IST and LPI IST=
, even
+ * if the paths to reach it might be vastly different.
+ */
+static int vgic_v5_vmte_assign_ist(struct kvm *kvm, phys_addr_t ist_base,
+				   bool two_level, unsigned int id_bits,
+				   unsigned int l2sz, unsigned int istsz,
+				   bool spi_ist)
+{
+	struct kvm_vcpu *vcpu0 =3D kvm_get_vcpu(kvm, 0);
+	u16 vm_id =3D vgic_v5_vm_id(kvm);
+	enum gicv5_vcpu_cmd cmd;
+	struct vmtl2_entry *vmte;
+	unsigned int section;
+	u64 tmp;
+	int ret;
+
+	/*
+	 * The L2 VMTE comprises four 64-bit "sections", where sections 2 & 3
+	 * describe the LPI and SPI ISTs, respectively. Both the LPI and SPI
+	 * sections have the same layout, and as we are either operating on SPIs
+	 * or LPIs we pick a section of the VMTE to modify up-front.
+	 *
+	 * See the GICv5 EAC0 Specification 11.2.2 for more details about the
+	 * VMTE layout.
+	 */
+	section =3D spi_ist ? GICV5_VMTEL2_SPI_SECTION : GICV5_VMTEL2_LPI_SECTION=
;
+
+	if (ist_base & ~GICV5_VMTEL2E_IST_ADDR) {
+		kvm_err("IST alignment issue! Address: 0x%llx, Mask 0x%llx\n",
+			ist_base, GICV5_VMTEL2E_IST_ADDR);
+		return -EINVAL;
+	}
+
+	vmte =3D vgic_v5_get_l2_vmte(vm_id);
+	if (IS_ERR(vmte))
+		return PTR_ERR(vmte);
+
+	/* Bail if already allocated */
+	vgic_v5_clean_inval(vmte, sizeof(*vmte));
+	if (le64_to_cpu(READ_ONCE(vmte->val[section])) & GICV5_VMTEL2E_IST_VALID)
+		return -EINVAL;
+
+	tmp =3D FIELD_PREP(GICV5_VMTEL2E_IST_L2SZ, l2sz);
+	tmp |=3D FIELD_PREP(GICV5_VMTEL2E_IST_ADDR,
+			ist_base >> GICV5_VMTEL2E_IST_ADDR_SHIFT);
+	tmp |=3D FIELD_PREP(GICV5_VMTEL2E_IST_ISTSZ, istsz);
+	tmp |=3D FIELD_PREP(GICV5_VMTEL2E_IST_ID_BITS, id_bits);
+	if (two_level)
+		tmp |=3D GICV5_VMTEL2E_IST_STRUCTURE;
+
+	WRITE_ONCE(vmte->val[section], cpu_to_le64(tmp));
+	vgic_v5_clean_inval(vmte, sizeof(*vmte));
+
+	/* Finally, mark the entry as valid */
+	cmd =3D spi_ist ? SPI_VIST_MAKE_VALID : LPI_VIST_MAKE_VALID;
+	ret =3D irq_set_vcpu_affinity(vgic_v5_vpe_db(vcpu0), &cmd);
+
+	return ret;
+}
+
+/*
+ * Allocate a Linear IST - always used for SPIs and potentially LPIs.
+ *
+ * The calculation for n has been taken from section 11.2.2 of the GICv5 E=
AC0
+ * spec.
+ *
+ * NOTE: istsz is the FIELD used by GICv5, not the actual size (or log2() =
of the
+ * size).
+ */
+static int vgic_v5_alloc_linear_ist(struct kvm *kvm, bool spi_ist,
+				    unsigned int id_bits, unsigned int istsz)
+{
+	const size_t n =3D id_bits + 1 + istsz;
+	u16 vm_id =3D vgic_v5_vm_id(kvm);
+	struct vgic_v5_vm_info *vmi;
+	__le64 *ist;
+	u32 l1sz;
+
+	vmi =3D xa_load(&vm_info, vm_id);
+	if (WARN_ON_ONCE(!vmi))
+		return -EINVAL;
+
+	/*
+	 * Allocate the IST. We only have one level, so we just use the L2 ISTE.
+	 */
+	l1sz =3D BIT(n + 1);
+	ist =3D kzalloc(l1sz, GFP_KERNEL);
+	if (!ist)
+		return -ENOMEM;
+
+	if (spi_ist) {
+		vmi->h_spi_ist =3D ist;
+	} else {
+		vmi->h_lpi_ist_structure =3D false;
+		vmi->h_lpi_ist =3D ist;
+	}
+
+	vgic_v5_clean_inval(ist, l1sz);
+
+	return 0;
+}
+
+/*
+ * Allocate the first level of a two-level IST - LPI, only.
+ *
+ * The calculation for n has been taken from section 11.2.2 of the GICv5 E=
AC0
+ * spec.
+ *
+ * NOTE: istsz and l2sz are the FIELDS used by GICv5, not the actual sizes=
 (or
+ * log2() of the sizes).
+ */
+static int vgic_v5_alloc_l1_ist(struct kvm *kvm, unsigned int id_bits,
+				unsigned int istsz, unsigned int l2sz)
+{
+	const size_t n =3D  max(5, id_bits - ((10 - istsz) + (2 * l2sz)) + 3 - 1)=
;
+	u16 vm_id =3D vgic_v5_vm_id(kvm);
+	const u32 l1_size =3D BIT(n + 1);
+	struct vgic_v5_vm_info *vmi;
+	__le64 *ist;
+
+	vmi =3D xa_load(&vm_info, vm_id);
+	if (!vmi)
+		return -EINVAL;
+
+	ist =3D kzalloc(l1_size, GFP_KERNEL);
+	if (!ist)
+		return -ENOMEM;
+
+	vmi->h_lpi_ist_structure =3D true;
+	vmi->h_lpi_ist =3D ist;
+
+	vgic_v5_clean_inval(ist, l1_size);
+
+	return 0;
+}
+
+/*
+ * Allocate ALL of the second level ISTs for a two-level IST - LPI, only.
+ *
+ * The calculation for n has been taken from section 11.2.2 of the GICv5 E=
AC0
+ * spec. The l2_size calculation is from section 11.2.3 of the same docume=
nt.
+ *
+ * NOTE: istsz and l2sz are the FIELDS used by GICv5, not the actual sizes=
 (or
+ * log2() of the sizes).
+ */
+static int vgic_v5_alloc_l2_ists(struct kvm *kvm, unsigned int id_bits,
+				 unsigned int istsz, unsigned int l2sz)
+{
+	const size_t n =3D  max(5, id_bits - ((10 - istsz) + (2 * l2sz)) + 3 - 1)=
;
+	const int l1_entries =3D BIT(n + 1) / GICV5_IRS_ISTL1E_SIZE;
+	const size_t l2_size =3D BIT(11 + (2 * l2sz) + 1);
+	u16 vm_id =3D vgic_v5_vm_id(kvm);
+	struct vgic_v5_vm_info *vmi;
+	__le64 *l2ist;
+	__le64 *l1ist;
+	int index;
+	u64 val;
+
+	vmi =3D xa_load(&vm_info, vm_id);
+	if (WARN_ON_ONCE(!vmi))
+		return -EINVAL;
+
+	l1ist =3D vmi->h_lpi_ist;
+
+	/*
+	 * Allocate the storage for the pointers to the L2 ISTs (used when
+	 * freeing later).
+	 */
+	vmi->h_lpi_l2_ists =3D kzalloc_objs(*vmi->h_lpi_l2_ists, l1_entries,
+					  GFP_KERNEL);
+	if (!vmi->h_lpi_l2_ists)
+		return -ENOMEM;
+
+	/* Allocate the L2 IST for each L1 IST entry */
+	for (index =3D 0; index < l1_entries; ++index) {
+		l2ist =3D kzalloc(l2_size, GFP_KERNEL);
+		if (!l2ist) {
+			while (--index >=3D 0)
+				kfree(vmi->h_lpi_l2_ists[index]);
+
+			kfree(vmi->h_lpi_l2_ists);
+			vmi->h_lpi_l2_ists =3D NULL;
+
+			return -ENOMEM;
+		}
+
+		/*
+		 * We are not doing on-demand allocation of the L2 ISTs, and are
+		 * instead provisioning the whole IST up front. This means that
+		 * we are able to mark the L2 ISTs as valid in the L1 ISTEs as
+		 * the overall IST is not yet valid.
+		 */
+		val =3D (virt_to_phys(l2ist) & GICV5_ISTL1E_L2_ADDR_MASK) |
+		      GICV5_ISTL1E_VALID;
+		l1ist[index] =3D cpu_to_le64(val);
+
+		vmi->h_lpi_l2_ists[index] =3D l2ist;
+
+		vgic_v5_clean_inval(l2ist, l2_size);
+	}
+
+	/* Handle CMOs for the whole L1 IST in one go */
+	vgic_v5_clean_inval(l1ist, l1_entries * sizeof(*l1ist));
+
+	return 0;
+}
+
+/* Allocate a two-level IST - LPIs, only */
+static int vgic_v5_alloc_two_level_lpi_ist(struct kvm *kvm, unsigned int i=
d_bits,
+					   unsigned int istsz, unsigned int l2sz)
+{
+	u16 vm_id =3D vgic_v5_vm_id(kvm);
+	struct vgic_v5_vm_info *vmi;
+	int ret;
+
+	/*
+	 * Allocate the L1 IST first, then all of the L2s. Everything
+	 * is preallocated and we do no on-demand IST allocation. This
+	 * is to avoid needing to track if and when the guest is doing
+	 * on-demand IST allocation.
+	 */
+	ret =3D vgic_v5_alloc_l1_ist(kvm, id_bits, istsz, l2sz);
+	if (ret)
+		return ret;
+
+	ret =3D vgic_v5_alloc_l2_ists(kvm, id_bits, istsz, l2sz);
+	if (ret) {
+		/* Free the L1 IST again */
+		vmi =3D xa_load(&vm_info, vm_id);
+		kfree(vmi->h_lpi_ist);
+		vmi->h_lpi_ist =3D 0;
+
+		return ret;
+	}
+
+	return 0;
+}
+
+static void vgic_v5_free_allocated_lpi_ist(struct vgic_v5_vm_info *vmi,
+					   unsigned int id_bits,
+					   unsigned int istsz,
+					   unsigned int l2sz)
+{
+	if (!vmi->h_lpi_ist_structure) {
+		kfree(vmi->h_lpi_ist);
+		vmi->h_lpi_ist =3D NULL;
+		return;
+	}
+
+	if (vmi->h_lpi_l2_ists) {
+		const size_t n =3D max(5, id_bits - ((10 - istsz) + (2 * l2sz)) + 3 - 1)=
;
+		const int l1_entries =3D BIT(n + 1) / GICV5_IRS_ISTL1E_SIZE;
+		int index;
+
+		for (index =3D 0; index < l1_entries; ++index)
+			kfree(vmi->h_lpi_l2_ists[index]);
+
+		kfree(vmi->h_lpi_l2_ists);
+		vmi->h_lpi_l2_ists =3D NULL;
+	}
+
+	kfree(vmi->h_lpi_ist);
+	vmi->h_lpi_ist =3D NULL;
+}
+
+static void vgic_v5_free_allocated_spi_ist(struct kvm *kvm)
+{
+	u16 vm_id =3D vgic_v5_vm_id(kvm);
+	struct vgic_v5_vm_info *vmi;
+
+	vmi =3D xa_load(&vm_info, vm_id);
+	if (WARN_ON_ONCE(!vmi))
+		return;
+
+	kfree(vmi->h_spi_ist);
+	vmi->h_spi_ist =3D NULL;
+}
+
+/*
+ * Free a Linear IST. Can only happen once the VM is dead.
+ */
+static int vgic_v5_linear_ist_free(struct kvm *kvm, bool spi)
+{
+	u16 vm_id =3D vgic_v5_vm_id(kvm);
+	struct vmtl2_entry *vmte;
+	struct vgic_v5_vm_info *vmi;
+	int section;
+
+	vmi =3D xa_load(&vm_info, vm_id);
+	if (!vmi)
+		return -EINVAL;
+
+	vmte =3D vgic_v5_get_l2_vmte(vm_id);
+	if (IS_ERR(vmte))
+		return PTR_ERR(vmte);
+
+	if (spi) {
+		section =3D GICV5_VMTEL2_SPI_SECTION;
+		vgic_v5_free_allocated_spi_ist(kvm);
+	} else {
+		section =3D GICV5_VMTEL2_LPI_SECTION;
+		vgic_v5_free_allocated_lpi_ist(vmi, 0, 0, 0);
+	}
+
+	/* The VM should be dead here, so we can just zero the VMT section */
+	vmte->val[section] =3D cpu_to_le64(0);
+	vgic_v5_clean_inval(vmte, sizeof(*vmte));
+
+	return 0;
+}
+
+/*
+ * Free a Two-Level IST. Can only happen once the VM is dead.
+ */
+static int vgic_v5_two_level_ist_free(struct kvm *kvm, bool spi)
+{
+	unsigned int id_bits, istsz, l2sz;
+	u16 vm_id =3D vgic_v5_vm_id(kvm);
+	struct vgic_v5_vm_info *vmi;
+	struct vmtl2_entry *vmte;
+	__le64 tmp;
+	int section;
+
+	/* We don't create two-level SPI ISTs, so freeing is a bad idea! */
+	if (spi)
+		return -EINVAL;
+
+	vmi =3D xa_load(&vm_info, vm_id);
+	if (!vmi)
+		return -EINVAL;
+
+	section =3D GICV5_VMTEL2_LPI_SECTION;
+
+	if (!vmi->h_lpi_ist_structure)
+		return -EINVAL;
+
+	vmte =3D vgic_v5_get_l2_vmte(vm_id);
+	if (IS_ERR(vmte))
+		return PTR_ERR(vmte);
+
+	tmp =3D le64_to_cpu(READ_ONCE(vmte->val[section]));
+
+	id_bits =3D FIELD_GET(GICV5_VMTEL2E_IST_ID_BITS, tmp);
+	istsz =3D FIELD_GET(GICV5_VMTEL2E_IST_ISTSZ, tmp);
+	l2sz =3D FIELD_GET(GICV5_VMTEL2E_IST_L2SZ, tmp);
+
+	vgic_v5_free_allocated_lpi_ist(vmi, id_bits, istsz, l2sz);
+
+	/* The VM must be dead, so we can just zero the VMT section */
+	vmte->val[section] =3D cpu_to_le64(0);
+	vgic_v5_clean_inval(vmte, sizeof(*vmte));
+
+	return 0;
+}
+
+/* Helper to determine ISTE size based on metadata requirements */
+static unsigned int vgic_v5_ist_istsz(unsigned int id_bits)
+{
+	if (!irs_caps.istmd)
+		return GICV5_IRS_IST_CFGR_ISTSZ_4;
+
+	if (id_bits >=3D irs_caps.istmd_sz)
+		return GICV5_IRS_IST_CFGR_ISTSZ_16;
+
+	return GICV5_IRS_IST_CFGR_ISTSZ_8;
+}
+
+/*
+ * Allocate an IST for SPIs.
+ *
+ * We don't anticipate a large number of SPIs being allocated. Therefore, =
we
+ * always allocate a Linear IST for SPIs. This will need to be revisited s=
hould
+ * that assumption no longer hold.
+ */
+int vgic_v5_spi_ist_allocate(struct kvm *kvm, unsigned int id_bits)
+{
+	u16 vm_id =3D vgic_v5_vm_id(kvm);
+	struct vgic_v5_vm_info *vmi;
+	phys_addr_t base_addr;
+	unsigned int istsz;
+	int ret;
+
+	istsz =3D vgic_v5_ist_istsz(id_bits);
+
+	vmi =3D xa_load(&vm_info, vm_id);
+	if (WARN_ON_ONCE(!vmi))
+		return -EINVAL;
+
+	ret =3D vgic_v5_alloc_linear_ist(kvm, true, id_bits, istsz);
+	if (ret)
+		return ret;
+	base_addr =3D virt_to_phys(vmi->h_spi_ist);
+
+	ret =3D vgic_v5_vmte_assign_ist(kvm, base_addr, false, id_bits, 0, istsz,
+				      true);
+	if (ret) {
+		vgic_v5_free_allocated_spi_ist(kvm);
+		return ret;
+	}
+
+	return 0;
+}
+
+/*
+ * Free the IST for SPIs. Should only happen once the VM is dead.
+ */
+static int vgic_v5_spi_ist_free(struct kvm *kvm)
+{
+	return vgic_v5_linear_ist_free(kvm, true);
+}
+
+/*
+ * Allocate an IST for LPIs.
+ *
+ * Unlike with SPIs, we anticipate that the guest will allocate a relative=
ly
+ * large number of LPIs. Therefore, while we support doing a linear LPI IS=
T, it
+ * is expected that LPI ISTs will be two-level.
+ */
+int vgic_v5_lpi_ist_alloc(struct kvm *kvm, unsigned int id_bits)
+{
+	u16 vm_id =3D vgic_v5_vm_id(kvm);
+	struct vgic_v5_vm_info *vmi;
+	unsigned int istsz, l2sz;
+	phys_addr_t phys_addr;
+	bool two_level;
+	int ret;
+
+	vmi =3D xa_load(&vm_info, vm_id);
+	if (WARN_ON_ONCE(!vmi))
+		return -EINVAL;
+
+	if (vmi->h_lpi_ist)
+		return -EBUSY;
+
+	istsz =3D vgic_v5_ist_istsz(id_bits);
+	l2sz =3D gicv5_irs_l2_sz(irs_caps.ist_l2sz);
+
+	/*
+	 * Determine if we want to create a Linear or a Two-Level IST.
+	 *
+	 * A two-level IST is only required when a single L2 IST cannot cover
+	 * the requested ID space. This depends on the L2 IST size selected for
+	 * the IRS, not PAGE_SIZE. Using PAGE_SIZE here would switch to
+	 * two-level too early when the selected L2 IST is larger than a page,
+	 * and the allocation sizing arithmetic would underflow.
+	 */
+	two_level =3D irs_caps.ist_levels &&
+		id_bits > ((10 - istsz) + (2 * l2sz));
+
+	if (!two_level)
+		ret =3D vgic_v5_alloc_linear_ist(kvm, false /* LPIs, not SPIs */,
+					       id_bits, istsz);
+	else
+		ret =3D vgic_v5_alloc_two_level_lpi_ist(kvm, id_bits, istsz,
+						      l2sz);
+
+	if (ret)
+		return ret;
+
+	phys_addr =3D virt_to_phys(vmi->h_lpi_ist);
+	ret =3D vgic_v5_vmte_assign_ist(kvm, phys_addr, two_level, id_bits, l2sz,
+				      istsz, false);
+	if (ret)
+		vgic_v5_free_allocated_lpi_ist(vmi, id_bits, istsz, l2sz);
+
+	return ret;
+}
+
+/* Free the LPI IST again */
+int vgic_v5_lpi_ist_free(struct kvm *kvm)
+{
+	u16 vm_id =3D vgic_v5_vm_id(kvm);
+	struct vgic_v5_vm_info *vmi;
+
+	vmi =3D xa_load(&vm_info, vm_id);
+	if (!vmi)
+		return -ENXIO;
+
+	if (!vmi->h_lpi_ist_structure)
+		return vgic_v5_linear_ist_free(kvm, false);
+	else
+		return vgic_v5_two_level_ist_free(kvm, false);
+}
diff --git a/arch/arm64/kvm/vgic/vgic-v5-tables.h b/arch/arm64/kvm/vgic/vgi=
c-v5-tables.h
index 3ca5bc7214fc9..81fed6c5b1559 100644
--- a/arch/arm64/kvm/vgic/vgic-v5-tables.h
+++ b/arch/arm64/kvm/vgic/vgic-v5-tables.h
@@ -25,6 +25,24 @@ struct vgic_v5_vm_info {
 	vpe_entry __iomem	*vpet_base;
 	void __iomem		**vped_ptrs;
 	u8			vpe_id_bits;
+
+	/*
+	 * Both the LPI and SPI ISTs are allocated by the hypervisor. While it
+	 * would be possible to track and access them by iterating over the ISTs
+	 * themselves, it makes more sense to store pointers to the ISTs.
+	 *
+	 * The LPI IST can either be two-level or linear. Hence, we keep track
+	 * of the structure. If it is two-level, we retain pointers to the L1
+	 * IST and to each L2 IST array. If it is linear, we just store the base
+	 * address of the IST array.
+	 *
+	 * The SPI IST is linear, and therefore we just store the base address
+	 * of the SPI IST array.
+	 */
+	bool			h_lpi_ist_structure;
+	__le64			*h_lpi_ist;
+	__le64			**h_lpi_l2_ists;
+	__le64			*h_spi_ist;
 };
=20
 struct vgic_v5_vmt {
@@ -73,4 +91,8 @@ int vgic_v5_vmte_release(struct kvm *kvm);
 int vgic_v5_vmte_alloc_vpe(struct kvm_vcpu *vcpu);
 int vgic_v5_vmte_free_vpe(struct kvm_vcpu *vcpu);
=20
+int vgic_v5_spi_ist_allocate(struct kvm *kvm, unsigned int id_bits);
+int vgic_v5_lpi_ist_alloc(struct kvm *kvm, unsigned int id_bits);
+int vgic_v5_lpi_ist_free(struct kvm *kvm);
+
 #endif
diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index adfe0b207ef40..120eadff9a128 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -161,6 +161,9 @@ static int vgic_v5_db_set_vcpu_affinity(struct irq_data=
 *data, void *vcpu_info)
 	case VMT_L2_MAP:
 	case VMTE_MAKE_VALID:
 	case VMTE_MAKE_INVALID:
+	case SPI_VIST_MAKE_VALID:
+	case LPI_VIST_MAKE_VALID:
+	case LPI_VIST_MAKE_INVALID:
 		/* Not yet implemented */
 	default:
 		return -EINVAL;
diff --git a/include/linux/irqchip/arm-gic-v5.h b/include/linux/irqchip/arm=
-gic-v5.h
index 64e31068d9d17..ef649faeeb0ff 100644
--- a/include/linux/irqchip/arm-gic-v5.h
+++ b/include/linux/irqchip/arm-gic-v5.h
@@ -623,6 +623,9 @@ enum gicv5_vcpu_cmd {
 	VMT_L2_MAP,		/* Map in a L2 VMT - *may* happen on VM init */
 	VMTE_MAKE_VALID,	/* Make the VMTE valid */
 	VMTE_MAKE_INVALID,	/* Make the VMTE (et al.) invalid */
+	SPI_VIST_MAKE_VALID,	/* No corresponding invalid */
+	LPI_VIST_MAKE_VALID,	/* Triggered by a guest */
+	LPI_VIST_MAKE_INVALID,	/* Triggered by a guest */
 };
=20
 #endif
--=20
2.34.1
