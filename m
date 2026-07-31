Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011053.outbound.protection.outlook.com [52.101.65.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BD51365A00;
	Fri, 31 Jul 2026 07:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.53
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785482384; cv=fail; b=fK9Rb+bDpCBSs7LVB7hm8RWcA0ov6s0G+2yXX24Qk3HkmlbhygmuHLx7Fo36nTEsNbEl7eQdGqaW94cRNt5sI/nryPXNKn+kYj4DpG16mEiTO6FFr2XvNQyRi3Nn5/FDYBIbgrNhosSs5mf2fsiXWSb8QXMgiKRBXAD074eXbLo=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785482384; c=relaxed/simple;
	bh=WhyBPQUtExHuyOh/kc6jEHzd97EZl4F0vZ/uGDFIZBc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=bZKKeBes7+/0k9YyxD+OMlmDfJTrd+GbTHENq/jR3V/K6nUmpazMto5dqTv5Qh0d+k/FU4DRrOl+8h3Q+FNwYcwa0OvAalK4jmorUzvWcZEvKla0N4J5YLQh244J3nrn909WTwxnerhcNO96mY7OQN6Pp20RK7kNfSkTXhKWAfo=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=RO41BjFO; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=RO41BjFO; arc=fail smtp.client-ip=52.101.65.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="RO41BjFO";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="RO41BjFO"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=kozj498EYd7KXxEzKb0XsLLVhoR0M1GV7ROlUx4wbusO2Z54f74+xENjrdS4OWoglETu86kP4C2kZzIg0MZjwOWk2sNSB8LqqqEUiKA9FNyso7P/fv/7I74IKgwSM7vw+Uk8DmmP/+8YmnVXdSaEhe5/XENkLW8Pnl/VDHAUF6DVWi0vUGaDy9urHANX5JUSiihbD2mp6a5n+rPVHY+rbjr/00AEYZtl3mgTwE4U9/9jYVtEsqvz5TfcDOadqNenEU6MbcafEWMVUD6E08MuGqDHsw+IFgUzWOPo2AGZRkQnr4+0kMQ4q/vVsRs8zebYzv1vDM/1ztbo9SOeC8BVUA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WhyBPQUtExHuyOh/kc6jEHzd97EZl4F0vZ/uGDFIZBc=;
 b=iWhXhznKQxh0TvO2j5tw+Nr0h/wgOaIwWh3Rpa6c76rf5vTX2uGPMdHL2uVqCOTGQBqkW3K/+isLe2xrXrmwfvzNa7iMbFN65a9FXT4DYhGhzoHCNCawfq1iNzOA/LyVpYEvl+7k/9iAvO1GQQqbs9naTaKtnthtoh9y+YrLpHiqC2Atc5yoK+5Lm/XuLTj6gQN5QUawHhv7KT3r7GCyCIazVBMIYxaHDZC5phOr6KIVv6sffkfnctDU3YU/wclYQ/hkeH2XXpxVVXvMiCjzeE5TaGqvEClw6yOQvReFGX2d3StKgFVrmw7oW+qHcI9s5ssLZ+1AIIaeRH71XCJKVA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WhyBPQUtExHuyOh/kc6jEHzd97EZl4F0vZ/uGDFIZBc=;
 b=RO41BjFONXLs98rgVr0QrDMxJqKdmiJuktc0z6BSulZcH8P1nHbz5HwacUZxktEOUS7mwZyg0tpv4hPiBXlY2+13h/lIQzTmBatx67FIZ71MICTsDTVjI1NNZHbVz+FMtxL9bgATc4cx3m7NCrlI9SLB/UOZ5MfgQ4CbvRXM7kA=
Received: from DU7P194CA0023.EURP194.PROD.OUTLOOK.COM (2603:10a6:10:553::14)
 by GVXPR08MB11700.eurprd08.prod.outlook.com (2603:10a6:150:314::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.15; Fri, 31 Jul
 2026 07:19:35 +0000
Received: from DB5PEPF00014B9E.eurprd02.prod.outlook.com
 (2603:10a6:10:553:cafe::9e) by DU7P194CA0023.outlook.office365.com
 (2603:10a6:10:553::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.15 via Frontend Transport; Fri,
 31 Jul 2026 07:19:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB5PEPF00014B9E.mail.protection.outlook.com (10.167.8.171) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.8
 via Frontend Transport; Fri, 31 Jul 2026 07:19:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZaF4n16NNGu9enznwYlSYc4YAtrHQh6rdBbbwTKT3fec/35n6wblW7/pHpylwx9DoLMxZbelhV31GE55UZGCR4ScvjCMwy7pJLd/TAAdh69wAEdalfRFAfMCHcOtKTic1pJv/Mm5BcqqO941/Opgo7s9a+0pgTf/OfNZO9ZeOe/IVv1j2Xlhm29eumZJUZxCkWxkLQBX5wd5rmfsUcOsfGgQtg8DeQ+qqcKLkjeKsVuwjCem+2fpePKY8cWtJXQZntM2gNWzAj+r7hhil3fQkTtfOyBmbyLR6BexfjX9OBCGkqD0jgSWHqvMDVaskI40CmB0UvDHcRTSbnmF/5nr9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WhyBPQUtExHuyOh/kc6jEHzd97EZl4F0vZ/uGDFIZBc=;
 b=ObSBEpW+j6rTy4ar0cLvA+JsK953Fonn6KeaeNvXbzFaYBiEvdzA8VOg5EkGxxeYlKxrzIkspbeTyFkF4fiPzAukpqseh4pOaM2lr/SOYnJNcLPmDFoGyb1Dooh205+voo1e2MZm5FpGUA9G06BV/gqG6rYEAAXd2dc/MxRga/2CUPMgKyn54Df8lpyRjW3RNbbGbP3yK9RPir7QHa4Bhzf6SfJ7xl4SzQlsLi2nutSOnntDuYXg5pLlWW6oXNbcnrx407R2Y3TD5MRsUcI/8X1DQZSmVC9HmaZZfb6blK5tTvhjkCd7kw/luUenzYhZfEVwajYB2r1SlTppmvpK9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WhyBPQUtExHuyOh/kc6jEHzd97EZl4F0vZ/uGDFIZBc=;
 b=RO41BjFONXLs98rgVr0QrDMxJqKdmiJuktc0z6BSulZcH8P1nHbz5HwacUZxktEOUS7mwZyg0tpv4hPiBXlY2+13h/lIQzTmBatx67FIZ71MICTsDTVjI1NNZHbVz+FMtxL9bgATc4cx3m7NCrlI9SLB/UOZ5MfgQ4CbvRXM7kA=
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com (2603:10a6:10:407::19)
 by PAWPR08MB11523.eurprd08.prod.outlook.com (2603:10a6:102:50a::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.16; Fri, 31 Jul
 2026 07:18:29 +0000
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e]) by DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e%5]) with mapi id 15.21.0270.012; Fri, 31 Jul 2026
 07:18:29 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "maz@kernel.org" <maz@kernel.org>, "sashiko-reviews@lists.linux.dev"
	<sashiko-reviews@lists.linux.dev>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "oupton@kernel.org" <oupton@kernel.org>, nd
	<nd@arm.com>, "lpieralisi@kernel.org" <lpieralisi@kernel.org>
Subject: Re: [PATCH v4 03/48] irqchip/gic-v5: Set up gic_kvm_info on ACPI
 hosts
Thread-Topic: [PATCH v4 03/48] irqchip/gic-v5: Set up gic_kvm_info on ACPI
 hosts
Thread-Index: AQHdG1oPG3RMJAfolkyg5EHOLdLQgbZ8hdcAgAF+aoCACEfmAA==
Date: Fri, 31 Jul 2026 07:18:28 +0000
Message-ID: <175296049076c90510ffd37ecfc8f13a15d3d536.camel@arm.com>
References: <20260724104819.1296803-1-sascha.bischoff@arm.com>
	 <20260724104819.1296803-4-sascha.bischoff@arm.com>
	 <20260724111920.6F63C1F00A3F@smtp.kernel.org>
	 <8733x7qt4s.wl-maz@kernel.org>
In-Reply-To: <8733x7qt4s.wl-maz@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU0PR08MB8421:EE_|PAWPR08MB11523:EE_|DB5PEPF00014B9E:EE_|GVXPR08MB11700:EE_
X-MS-Office365-Filtering-Correlation-Id: d7f0cb99-564b-4971-2e3b-08deeed412cd
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|376014|23010399003|11063799006|56012099006|3023799007|4143699003|10067099003|18002099003|22082099003|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 ZJ/AlzmC7jT3mDOR1TP2uljIDlQEoaL1gTSov4vVgwTmS3dv7Wf1ZWBTVtw3OCLDONhDr1UejNPwLVMygCCH5N9mfoTjMH9B8+POAa6Co0WDpIKfzZJuL6LSh+Hsi+Rve/MpPJLNb180V/MKNf5doRzt8vRq6yUHFB+Pe1f1/w6JoigA6YiV6Oz2ouJ3d3E3WfMTgAt0sYl3g2RbhIhU/vdxhV5UYgyigCamTBgiFmQRhWL1eFvSm206j3+0cp7KWabH8aNlu4evXS88Rgc0Lh4jpCN8chTqshVx/tR5vzOwqIZyzyrlauslhh5Lq8z77O5re17h8o5jS4N+B1862YR64Vc8UsxxDVj507PYJzFuNEk0CeA51+yMZXrZ7ZtRjBaSr5P9o98gBs9srMKnHHN8g0euMItQQix87H8eiiey2+Sv+OQlPLgDfbyYsldBf4lMQrUXgDjF9JG663tadPHfjhO3Vw1DFpoEeHDDhB1yndimkLAitSzQfhW3X5F3ihU9Bp0dUPcEmG6H+qBY7nzGz+GR4I8dFNDhqTMp8Khgy5tl4tiiBTW3jK9q+lSHv6OQRnmVUUyv4fC0nJyJINfXwqVwYXXuBjtpO+lY7lOrEgsi4Jat2Jskp4xdapbjyBydY8gK9gVhSnxIsstwir2yv6vsIl08OTwJCRnVBcxbTE4iMAwBNLp8xslA8SU9MVLjTQ8M0kno9RLcV+0N+mw1rxZDYOs8oXG/s+Nt1s8=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB8421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(23010399003)(11063799006)(56012099006)(3023799007)(4143699003)(10067099003)(18002099003)(22082099003)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <81D1625CEFF5C44CBAD38F157AA5FCE7@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 dypwYiZk/LCbJTY4zTG3mEWCzMltQZqB+io8IXJhjV/tKkTx1P6L0t+iv2s9MrwVc4Z5SWFCg4N+lRsOt67SNhTxE4JHkzofQeOKctJQJQfeo3fXmD36/Hcz7XanFzHG+TEeThYEg4SZ32vf810ZsIVBqbfzx+cyiSOb2JDxFOCv9xjzLq1pfl+vy6dCbH5l2p1bmLeg9Z+CK1heCqSKq5BIRcGquEugc4RCQGUzV6fVTqwftSlckNXZ+j2W9TVCe3+bZnbYz2Tre1vJbOJWO5DqPV1YQR7Lmla2/czisycp/D4FLtd8/3u1kvwEBloeuAuq+I9NUJ4KDJWBGFFWUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR08MB11523
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB5PEPF00014B9E.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	ca8be3b1-7d76-49d6-c968-08deeed3eba7
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|35042699022|14060799003|376014|36860700016|82310400026|10067099003|4143699003|11063799006|56012099006|3023799007|18002099003|22082099003|13003099007;
X-Microsoft-Antispam-Message-Info:
	wK6LlTJsAE140amHwCfUP4+EmIXZPJyTn2GaLitoWbSyUkQCe8586JdR0AIYHBfJWgjF3G/4vdsDlksWwxgBkf+iufto54dlqUL+S81FEZ4HM+hzph+mOrAmFPdS9Jvi6Vm10ye2J1BcSQYv5Mr8WUXjvBTUiEgE8NNC535siSjofx50W3dNC0Mt4kEWqhzwhwZAfI/ly18cdqLrF4R2KOou50rgb3jEVJNZNaeMg7z/w7N7w33ks+lknGA6iNFV9UbIdABRtAIsa1C4WINwuna15b05hQ9s60PKX52zHX36d/sKtqJA++HgjRyoWXmOh9vomLlj+ZQqNxXaBr8ENrbt9ulcJASYiSP+MK4dn19dLYdIq8/qQPzI8tHtiZZgwc4nlXONgD0+IetbYlKVP40o3P7XrXYopXa2ZG82V0NIYP0GinNB4p+L2DH2somkESANmGxCwe653HL6Gd4ghI0I7g2a+eXIBQr7p+Cn7RRgxkGzBvqokgvx8OcOpVVkCMkvLR9ZU4yAPVCjFqKDFhFodA1UDxMA0pcXek6Ba4EaSuUnTbOiVMP/jmnicp5Dv0+TNHFG8FEY1HiWLkpGJK3/LWBWaFdQla6OklIwq8wXykY/E2HehgCRsyQL4/fzcrUJic9HAg+eYQLj2H6GcL9HfYsL1tX3sO7noDrSTGXFKfL3LXLOxT93mzGPTJhHchm9ZFun+hLHc1316L9aag==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(35042699022)(14060799003)(376014)(36860700016)(82310400026)(10067099003)(4143699003)(11063799006)(56012099006)(3023799007)(18002099003)(22082099003)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	2F1mS7/KhjqN05nKaEzKWPnzi1vG49+52fwx/cyBdYMUn07RtlqmYVzlMJw16JFNa0ojp0l9+OU3brH0OLI+xckoCZAkj6kJ877SaLSw1vU34iHbNANHUG5+5SxJAqFDk/u0Lk8HufNkUJR/nLKXHzVnUVUufcSlf0/du/dWPXd+VpE+RDHx46ykEsWNBua5/xqsdzn4XpovoW49bNkFLXtM0hO5i6hiUeW4rb7dQXKQnqCPOyyKM3GRO79C4IbadMuZ2lPGRCy9i1QELnfkWhu8SzwdSa5YmEl+7/FI9fnOh1VfPx5u8nA3o2UBi5Jj53CZSJTjSUqF2DepeeCqbfD822rifmWqpfeV4pz2hduyGKTx7yjQN7cA6+YKS7Ru95qZt8kpepQxIpyUlwolsz2zmkq1WGI0Kmrjclolssu0LDvNPy6ZXUJzKatVnXMI
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2026 07:19:34.8117
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d7f0cb99-564b-4971-2e3b-08deeed412cd
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5PEPF00014B9E.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR08MB11700

T24gU2F0LCAyMDI2LTA3LTI1IGF0IDExOjA4ICswMTAwLCBNYXJjIFp5bmdpZXIgd3JvdGU6DQo+
IE9uIEZyaSwgMjQgSnVsIDIwMjYgMTI6MTk6MjAgKzAxMDAsDQo+IHNhc2hpa28tYm90QGtlcm5l
bC5vcmfCoHdyb3RlOg0KPiA+IA0KPiA+IFRoYW5rIHlvdSBmb3IgeW91ciBjb250cmlidXRpb24h
IFNhc2hpa28gQUkgcmV2aWV3IGZvdW5kIDENCj4gPiBwb3RlbnRpYWwgaXNzdWUocykgdG8gY29u
c2lkZXI6DQo+ID4gLSBbSGlnaF0gRmFpbGVkIEFDUEkgR1NJIHJlZ2lzdHJhdGlvbiBmb3IgbWFp
bnRlbmFuY2UgSVJRIGR1ZSB0bw0KPiA+IG1pc3NpbmcgR0lDdjUgaGFyZHdhcmUgSVJRIHR5cGUg
ZW5jb2RpbmcuDQo+ID4gLS0NCj4gDQo+IFsuLi5dDQo+IA0KPiA+IFtTZXZlcml0eTogSGlnaF0N
Cj4gPiBEb2VzIHRoaXMgZmFpbCB0byByZWdpc3RlciB0aGUgbWFpbnRlbmFuY2UgSVJRPw0KPiA+
IA0KPiA+IGFjcGlfcmVnaXN0ZXJfZ3NpKCkgcGFzc2VzIHRoZSByYXcgbWFpbnRfaXJxIGRpcmVj
dGx5IGludG8NCj4gPiBmd3NwZWMucGFyYW1bMF0uDQo+ID4gSG93ZXZlciwgdGhlIEdJQ3Y1IFBQ
SSBkb21haW4gc2VsZWN0IGZ1bmN0aW9uIGV4cGVjdHMgdGhlIGhhcmR3YXJlDQo+ID4gSVJRIHR5
cGUgdG8NCj4gPiBiZSBlbmNvZGVkIGluIHRoZSB1cHBlciBiaXRzOg0KPiA+IA0KPiA+IGRyaXZl
cnMvaXJxY2hpcC9pcnEtZ2ljLXY1LmM6Z2ljdjVfaXJxX3BwaV9kb21haW5fc2VsZWN0KCkgew0K
PiA+IMKgwqDCoCAuLi4NCj4gPiDCoMKgwqAgaWYgKGlzX2Z3bm9kZV9pcnFjaGlwKGZ3c3BlYy0+
Zndub2RlKSkNCj4gPiDCoMKgwqDCoMKgwqDCoCBod2lycV90eXBlID0gRklFTERfR0VUKEdJQ1Y1
X0hXSVJRX1RZUEUsIGZ3c3BlYy0+cGFyYW1bMF0pOw0KPiA+IA0KPiA+IMKgwqDCoCBpZiAoaHdp
cnFfdHlwZSAhPSBHSUNWNV9IV0lSUV9UWVBFX1BQSSkNCj4gPiDCoMKgwqDCoMKgwqDCoCByZXR1
cm4gMDsNCj4gPiDCoMKgwqAgLi4uDQo+ID4gfQ0KPiA+IA0KPiA+IEJlY2F1c2UgdGhlIHJhdyBN
QURUIHZhbHVlIGRvZXNuJ3QgaGF2ZSB0aGUgR0lDVjVfSFdJUlFfVFlQRV9QUEkNCj4gPiBiaXRz
IHNldCwgdGhlDQo+ID4gbWFwcGluZyB3aWxsIGJlIHJlamVjdGVkLiBTaG91bGQgdGhlIEdTSSBi
ZSBlbmNvZGVkIHdpdGggdGhlIFBQSQ0KPiA+IHR5cGUgYmVmb3JlDQo+ID4gY2FsbGluZyBhY3Bp
X3JlZ2lzdGVyX2dzaSgpPw0KPiANCj4gV2hlcmUgaXMgdGhpcyBjb21pbmcgZnJvbT8gSSBjYW4n
dCBldmVuIGZpbmQgYW55IHB1YmxpYyBkb2N1bWVudGF0aW9uDQo+IGZvciBBQ1BJIEdJQ3Y1IHN1
cHBvcnQuLi4NCg0KQW5kIG5vciBjYW4gU2FzaGlrbywgc28gaXQgaXMgdmVyeSBtdWNoIGZhbGxp
bmcgYmFjayBvbiB3aGF0IGl0IHdvdWxkDQpleHBlY3QgZm9yIG9sZGVyIEdJQ3Mgd2l0aCByYW5n
ZS1iYXNlZCBpbnRlcnJ1cHRzLCBsaWtlIEdJQ3YzLg0KDQpNeSBjaGFuZ2VzIGFyZSBiYXNlZCBv
biAoYW5kIGhhdmUgYmVlbiB0ZXN0ZWQgYWdhaW5zdCkgdGhlIEdJQ3Y1IEFDUEkNCnN1cHBvcnQg
YmVpbmcgYWRkZWQgdG8gRURLMiB3aGljaCBjYW4gYmUgZm91bmQgYXQNCmh0dHBzOi8vZ2l0aHVi
LmNvbS90aWFub2NvcmUvZWRrMi9wdWxsLzExOTk4IGFuZA0KaHR0cHM6Ly9naXRodWIuY29tL3Rp
YW5vY29yZS9lZGsyLXBsYXRmb3Jtcy9wdWxsLzkzMQ0KDQpJbiB2MiwgSSdkIGV4cGxpY2l0bHkg
cmUtZW5jb2RlZCB0aGUgR1NJIGFzIGEgR0lDdjUgUFBJLCBidXQgZHJvcHBlZA0KdGhhdCBpbiBy
ZXNwb25zZSB0byBhIGNvbW1lbnQgZnJvbSAoYW5kIG9mZmxpbmUgZGlzY3Vzc2lvbiB3aXRoDQpM
b3JlbnpvKSAtIHRoZSBHU0kgc2hvdWxkIGFscmVhZHkgYmUgZW5jb2RlZCBhcyBhIEdJQ3Y1IFBQ
SSwgaS5lLiB3aXRoDQp0aGUgdXBwZXIgVHlwZSBiaXRzIHNldCBhcHByb3ByaWF0ZWx5LiBTZWUN
Cmh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2FsbC9haGZyYUUydlZzWkwyeGNzQGxwaWVyYWxpc2kv
IEl0IHdvdWxkbid0DQpoYXZlIGJlZW4gd3Jvbmcgd2l0aCB0aGF0IHJlLWVuY29kaW5nIHByZXNl
bnQgYnV0IGl0IHdhcyBzdXBlcmZsdW91cywNCmFuZCBoZW5jZSBJIGRyb3BwZWQgaXQuIA0KDQpG
V0lXLCB0aGUgZWRrMi1wbGF0Zm9ybXMgR0lDdjUgc3VwcG9ydCBmb3IgdGhlIEZWUCBleHBsaWNp
dGx5IGVuY29kZXMNCnRoZSBWR0lDX0lSUSAoc28gTUkpIGFzOg0KDQojZGVmaW5lIEZWUF9HSUNW
NV9WR0lDX0lSUSAgICAgICAgICAgICAgICAgICAgKEdJQ1Y1X0lOVEVSUlVQVF9UWVBFX1BQSSB8
IDB4MTkpDQoNClNlZSBbMV0gZm9yIHRoZSBmdWxsIGRpZmYsIGlmIGludGVyZXN0ZWQuDQoNCj4g
DQo+IFNhc2NoYT8NCj4gDQo+IAlNLg0KPiANCg0KVGhhbmtzLA0KU2FzY2hhDQoNClsxXQ0KaHR0
cHM6Ly9naXRodWIuY29tL3RpYW5vY29yZS9lZGsyLXBsYXRmb3Jtcy9wdWxsLzkzMS9maWxlcyNk
aWZmLTg2ODRjOWRjZTQxMDJiYzA0Nzk2Zjc4NmM1NjcyOTE1OTM1Yzk4NTM5MDVjMjVkZTU4OWVk
OGQ4MTBjZDUxMmZSMTEyDQo=
