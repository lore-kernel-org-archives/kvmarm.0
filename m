Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011057.outbound.protection.outlook.com [40.107.130.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDD5F3E8C57
	for <kvmarm@lists.linux.dev>; Thu, 19 Mar 2026 15:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.57
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773935469; cv=fail; b=K23zc1FQtTZjf6dfxW1IoOW/hM0anchMN8gbcJlJ1hArDi0vR01BIb8iF2qPPtsfBIyMsR13vHNL/yUtqmMWRuKJGAPXIhuYaaiA48An5/hsJUQOvuQHkCEMkUSl11HL/4xmF2eM70HcogTGId/cVs7UjxbhiNBdEOK5JCwCdPg=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773935469; c=relaxed/simple;
	bh=A2vyHiZ8ly61njyldHTV2OFt45ZIpMop/xWiDqkvMXM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=j1IwcwfwAEKP7GM6Cmjuczvb+0LiP8OwlVBRSodVnWXiqwCm7lV4t1h2m5oga6JKcr34jvPss78etRwe8On67OEk7AYqADQgF5bb4HOkRrTciXPnbyCmZJAuHiCLSc76Vtes0DkdUe7HgZ/NgWrBS6+BZUGIO6lctlFyV7zntCc=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=mnEb6/Sl; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=mnEb6/Sl; arc=fail smtp.client-ip=40.107.130.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="mnEb6/Sl";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="mnEb6/Sl"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=bEiZRri3YTU98K6Ic+3squtBUc6NdAgmTooZo33OPi4YAxIoOto6FvkYyJCu5wpezeZHbNmrBKMLlp7UJ0JLClK8Qh7KlQS46AgdPBzclzYiT477BKhxzjDXMVDew4TGB0hBKgPwyy6PRCSLg8iMCqgcxPMuov9lOp4cZ6MBWnkAcg+Xymghx5U4FwQb+lM3MUJfgN18R8PWYTeEjNlDMu2pWpkQz1j7k68ZkSXnmeZI4+XwKu2A35CuQG5z5rv72l1/GfZq62tA2vbRwHWmdtjc2J9R22B/ZPMVTgV3TwiShS8b8AADl8g+Qf1zrmqXW1GRhoVzxy3el+ww1mdKqw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0ohyXD/deYRqTsRC3VExmSAgU/u0ELN5Ti2MbeoXUcE=;
 b=uE8yxKDat4lymxMWiNNwnE9bWNQcuBD8FWxgXrczmfpYmSGGjgw/OQjKWOXTxpuTDN8BLvB0DuCspadtPTlh3hq8lD+ZRh9ZpChk8163VUNC+4JhZAdQ2YMCg1elHSvbIvqE72CCVzKbkEeEm8eVweLNU1ErMjmWm4/Zfv9HHdW5Mi/9sqeFTwthCR7ZQW/Qu7GkL6LvhWOz3/8utceQPg7y6/pQnxtPMFD0cL5KyljCqZlCr0iyQuKjqjcGmB/wrSS/a5gKDiO3qpT+CRsD+ia9lS2My8U03Ug/9ZwICpwLX1M3yrFAece+lL7P8QCpMDamwImWuW0ZUeCwqmzZ7Q==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0ohyXD/deYRqTsRC3VExmSAgU/u0ELN5Ti2MbeoXUcE=;
 b=mnEb6/SlNWrOzOgxj1vvH4I6OWvRNzgRWWIbfZNarUa6GNlDnmlnAjv3pKNBopLm4wEm7fFF8cSETL9TKtyAowWDJyhWpIDxSxdkeM70eUlbcH6yiI1rckXH6xtF5/dz8J9/9sORZWBeGHxcVAnpsIYygkcmG7q4VVRKaX+lBK8=
Received: from AM8P189CA0022.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:218::27)
 by AS4PR08MB7507.eurprd08.prod.outlook.com (2603:10a6:20b:4fe::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Thu, 19 Mar
 2026 15:51:00 +0000
Received: from AMS1EPF0000004C.eurprd04.prod.outlook.com
 (2603:10a6:20b:218:cafe::b0) by AM8P189CA0022.outlook.office365.com
 (2603:10a6:20b:218::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.19 via Frontend Transport; Thu,
 19 Mar 2026 15:51:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS1EPF0000004C.mail.protection.outlook.com (10.167.16.137) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.19
 via Frontend Transport; Thu, 19 Mar 2026 15:51:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ja5DNpS39kf7XjXVNF8podg4ZMFV5lhhAAGakQt8Andl2/CNkJbFX2wRhCCWaNYWwnKP2Qc6JyDthfN37Le5y5zK6Dl/KdWKedcmYypIYdRrCWidUHxelXHdQQIp+PRBL3/5KWBujHKSI+dzra5LS2XL88nuPkhWolscHslXGa7uISvq1lFqSi9gNzPcuTU8DHsL61R3kXLu6yxGGEtVfz8I5BAYkENHzH5lhi0m1iPTLALaAuwQ5grNpEuZ4X45XBXCpsx0kB7KJS46Voun6p9SYf642TK56g53nUoGfdPX11OC3Q4r2bR9x2Rp3/0lxnF1/eIgLp8jmWFnF72KHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0ohyXD/deYRqTsRC3VExmSAgU/u0ELN5Ti2MbeoXUcE=;
 b=euuVSStzU8Nr064SaEss20j62ECLOEkIu5U8z7aBazLBi41Q713TThddQMAasF6wlWuvpoXvZf5M3/ix9ALeUPBNcEKu4j5fyTILtum8+enSLezXRkHFEFkGjnBmxAyhOcdN8vmoiK9jLjH9nE59/OQrWZ7aC3UoFh9eGU+1THcYQzXeXoIutXEMlG6VPqFD8pJFD0IYeJZl0d8zbRzEoXrU5fFKr91iYT15vLlDHNhDDwDAgHrbMKxrvvnheq6bI6Fx8fy9kYrJry4vkaeG9HMAE+YakC6bHbNca6z4jhVwEI34AVWL2dRMBxrQrh+ZZWCeyEmSKN4Gdgp9wUhAyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0ohyXD/deYRqTsRC3VExmSAgU/u0ELN5Ti2MbeoXUcE=;
 b=mnEb6/SlNWrOzOgxj1vvH4I6OWvRNzgRWWIbfZNarUa6GNlDnmlnAjv3pKNBopLm4wEm7fFF8cSETL9TKtyAowWDJyhWpIDxSxdkeM70eUlbcH6yiI1rckXH6xtF5/dz8J9/9sORZWBeGHxcVAnpsIYygkcmG7q4VVRKaX+lBK8=
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com (2603:10a6:20b:504::10)
 by DU2PR08MB10185.eurprd08.prod.outlook.com (2603:10a6:10:49e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Thu, 19 Mar
 2026 15:49:57 +0000
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27]) by AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27%6]) with mapi id 15.20.9723.018; Thu, 19 Mar 2026
 15:49:57 +0000
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
Subject: [PATCH v7 01/41] KVM: arm64: vgic-v3: Drop userspace write
 sanitization for ID_AA64PFR0.GIC on GICv5
Thread-Topic: [PATCH v7 01/41] KVM: arm64: vgic-v3: Drop userspace write
 sanitization for ID_AA64PFR0.GIC on GICv5
Thread-Index: AQHct7gJ9v3JGJoU2UiiEPTx0DV77w==
Date: Thu, 19 Mar 2026 15:49:57 +0000
Message-ID: <20260319154937.3619520-2-sascha.bischoff@arm.com>
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
	AS4PR08MB8241:EE_|DU2PR08MB10185:EE_|AMS1EPF0000004C:EE_|AS4PR08MB7507:EE_
X-MS-Office365-Filtering-Correlation-Id: 82a04df8-2f7b-4024-ff23-08de85cf517b
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|56012099003|22082099003|18002099003|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 ZNzFxH5/MWSU/Bb3qmT+l1h05+NGv9t0VwWrqV+log0sdbmWv1hv8WIR26V9JIsg7TBFjzXuY7o+mVqJDIF2j+v6fHVa/7f7fPrc2VINdoc65rAKrofgsYYcbeetduGC4JtXqOJ+UaosegI9KjXwUd/bR46v1Rn4NiSJoj3t2x351O9upaoVfSW9RwPOuUwrcffosCfBu+NFfgszaUdUDR1jLBqmHVjex/Oa5US2AwBLX8HisDMX+0NMSd58pxn2nTAKacYnmRgawSZnrsZW7MnfI4IZuLJI2Mc2HDIw2UdNXHLB85e2OqXUqMTIfxFO7P9xf/pCc6IbWwz0B2oz9eHGZgqz91tMlBlg1pbbZl/6w1i+5jUtvpZ2YzUnl27GDNtZxCO44PBhYavZ4WRwIu7/PfAsB/S+Uc6a0znAJicAyA+jEjhp3s0PmMT7YYaTfekG0jv8MiPM8NHYA2M/k9e21kfsHnHgjo55gjiKvCR+9q4mXsjz1llLtwCeWNq1xogR/sS3qOjU0jKXtSxnW6tqEWeFrrkg4PiZAxuZGH+nos3lt7ukYMJUksimAEwvwfKIGBi572W4nG+KMOV0e56hwNBLyhKCoQ2eL95s4PSi+qum+3OIg4ZGmoBBvbG9hyYNhWoQcG75wwi9xhZTc2gQL9JxIaPy8yzgmI2JWUIVfQ2K7ekIWZQMOirGYhcg0QOdak9QkqoT0hTwHqNoyfhnO+5xXHVaaEE6molb2oO+ifEn/cA5qWmFYFWPp/1gu20MLB7ofiBszr3p6GzvzqE/BrO/d7wuSGS9NU6eb1w=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS4PR08MB8241.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(56012099003)(22082099003)(18002099003)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 ZXAQQsg2b/Db0WwEePoRwLROaYUPHFhoCFDEW3hkL14pgtLXeB5twMN0AAr9mqomJRL1KBI8Xelxz1V/poiEofqla9hCvgOlRHHOuFGWrVPqrrDup3AFQU3EUPQ7BPemGHrRaJugDjhfv/ZTHp3QMlG83VBAQzpljqScn1CcLRLYQBIuZTJjVHEQS+dcEU6OfRpLDdimoo/WAa6I6jGbB7s7YKfE8kxIue/Jfq+QhCCYZ0ewWIVajsPwVJteeu341WwFvQ8PovAcXUjrUj1u7ueWDAHX05FJVFqah3haDdaiPWTtQgoPcC57tf5AKdurTnJzuJ0b4D0oT2K1l6Dyqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR08MB10185
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS1EPF0000004C.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	eebd32d1-a6cd-43a3-21bb-08de85cf2c05
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|35042699022|82310400026|1800799024|376014|14060799003|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	/u65Vxx0VfYZQuK/kAkwpZ+eqWAHWLX2j2MDCSk/jWiw+sgNcNv4mR3clCGPYXLWrsVAsITT47rBMybeKfdXi1JXN1XJnZmoc+8Qic00ammEuoPf425XPvkrWqul8rI9b6to4so2jifBmU1USVeWybZ9JnOupZLHZ+KF/9WOVmaYmbJxb8SfMBE2vWE2bm9xuUBGrGhoiz8wbLlr7Rp/du+wzYizRvz97WaawCG++MwE8i+HkJOU7lrlkmjECrj1uHfjuPLr3L+X6ILrT4dinf/MoDAQCU56TyoW9n0+Po/e6XzzpnY+o9BFqzrkSjSUTucvCY9ZdhLi14QXmbqcR6VkmexGfpFuL54BDd59k0VG513hQV7c3j8gF64Nles+HgYty9J6SuYyCfgTDN06whJW/M8piKS7nEi2tbLpZMzlQ/hGPsfm5oMKsEgkJw4mTsbyCTPgR3V+SU02tbUdz8pQIhdfA5HzcOSm7p89S5TPiKPkTGlaJdneNFsSrAAsqVz8IfDiED4mrK8+whUiALmF7NjsMz49KktR6j0bCun0HpHDBgprDjUsxlyt8H+cxmqrKvnvo3SIBgTqQ3j0WAeMoLoEcVGyxUcSImMrGo07G+aM/fy5zoynETAboitsrH8fvyxqw/QZYF1Cu4ZqvnlJX1g0AZz/YF7Yp0VjGfFuNYHN78pcbOnz2XnSNOZmEeV19qAyAUBIc5917sLDyyGtyvcm/E2FREZHs8dF0Ur5YhRhrGoorHzx4WQybtmRR+090c9EFAyq/LFXT58Grg==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(35042699022)(82310400026)(1800799024)(376014)(14060799003)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	4zdM4BPZoQCaTfFq7gnRZM+gElpWhkH8lr1vd4X2wwGtRCTO0cqhwpOtUMA/NzB4QdhhcPflD4MP78Jw0MpLTMJOslebFYBs/rfenUOp/TC704HQWK8MXS1K6LjHSRKCpTnrUo3vdckms5BLNc9pOFd0ymiwn8olM8gy14C/BlZOEMBBTQ3eQ5qVVckIpaF39xlCz0yu626EC+VtjHPGl9oveGSsQT8LHls98/d38sTbWgKH/3+kMgVkEZUovlHKGWji23x4sC+9l+86PmQsJZp4R/eh/hlFp50F6laFWG5apxEvj1b2B+ErVG6tBWhh01jj4BIbtd19/phkiCJc3SIFJkf5v1GlrOnyfkEPAG6N2hhyFKHRpkqRtF5U2z07WcjIePjH1RBn6biwibpkT7VPBQUTKK8PlCSPNLDH/OyUZuisdCsZHe91QBaCeL+C
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2026 15:51:00.4023
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 82a04df8-2f7b-4024-ff23-08de85cf517b
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS1EPF0000004C.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR08MB7507

Drop a check that blocked userspace writes to ID_AA64PFR0_EL1 for
writes that set the GIC field to 0 (NI) on GICv5 hosts. There is no
such check for GICv3 native systems, and having inconsistent behaviour
both complicates the logic and risks breaking existing userspace
software that expects to be able to write the register.

This means that userspace is now able to create a GICv3 guest on GICv5
hosts, and disable the guest from seeing that it has a GICv3. This
matches the already existing behaviour for GICv3-native VMs, allowing
for fewer issues when migrating from GICv3 hosts to compatible GICv5
hosts.

Additionally, this allows the trap and FGU infrastucture to kick in as
these rely on the state of the feature bits that have been set.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/sys_regs.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 1b4cacb6e918a..4b9f4e5d946b1 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2177,14 +2177,6 @@ static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu=
,
 	    (vcpu_has_nv(vcpu) && !FIELD_GET(ID_AA64PFR0_EL1_EL2, user_val)))
 		return -EINVAL;
=20
-	/*
-	 * If we are running on a GICv5 host and support FEAT_GCIE_LEGACY, then
-	 * we support GICv3. Fail attempts to do anything but set that to IMP.
-	 */
-	if (vgic_is_v3_compat(vcpu->kvm) &&
-	    FIELD_GET(ID_AA64PFR0_EL1_GIC_MASK, user_val) !=3D ID_AA64PFR0_EL1_GI=
C_IMP)
-		return -EINVAL;
-
 	return set_id_reg(vcpu, rd, user_val);
 }
=20
--=20
2.34.1
