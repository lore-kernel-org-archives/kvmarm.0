Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=2 smtp.remote-ip=52.101.65.3
ARC-Seal: i=3; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795508038;
	b=oFx8EoGDbAXUm0XYjYGUX5M8KWHEpP0qMpHWIVbqsQdhaZEF7+Iroer/UstvaAd8uSVK
	 rTGi9W+TQUa3+D5LW4sYcZBOKLekr4UoYu9HgKykdSErivwcqYBmyRYE5p4aih50bY1nu
	 qNUO7e4nAhmiyiT6VebjmWZzFdAfm5UrVjnESMfrdwicHSIXS3apTD5bsUuvJsPunrZz6
	 wAb5+uVP6qqa1cRUjctBv4GfRdHHKvgAj9qcMTldSGkvndtLr9N+SXwJcX08FhxKiaVXG
	 ll7DFqQXguHTU/PpsSBk9gmg3+r+LSGJWFW9Tex0tPYL4g3+eqUOJJF9Mj5eR3OQa/A==
ARC-Message-Signature: i=3; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795508038;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:
	 DKIM-Signature:Received:Received:From:To:CC:Subject:Thread-Topic:
	 Thread-Index:Date:Message-ID:References:In-Reply-To:Accept-Language:
	 Content-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:
	 Authentication-Results-Original:x-ms-traffictypediagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:x-checkrecipientrouted:
	 nodisclaimer:X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam-Untrusted:
	 X-Microsoft-Antispam-Message-Info-Original:
	 X-Forefront-Antispam-Report-Untrusted:Content-Type:
	 Content-Transfer-Encoding:MIME-Version:
	 X-Exchange-RoutingPolicyChecked:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:
	 X-EOPAttributedMessage:
	 X-MS-Exchange-Transport-CrossTenantHeadersStripped:
	 X-MS-PublicTrafficType:X-MS-Office365-Filtering-Correlation-Id-Prvs:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=qz/Gy0kGZ3xNNuVlmOOkcX3nwfAD+QZVVlSBXV4mxxY=;
	b=JJNO7QOywH43kplUcYugI7QBSqmrLa7hzkN6Vq2nD/nXWTzktWIZFQ8vEEg2ZMnOqhEf
	 bPYuBwMHSHTRpqLHzgJXsDCq2DMD26T6q4HQWGDeBb2jbanN1NgwXsIzK6diIUcMIeAjY
	 yt71lfmJtLP5nGBj10bfET9CRYZidR28oUGxirWkMJhGGSK1Eqg9XNIuzDl6vqDnddp5J
	 J0ITg9/8LXZktEUhIeo+16LlggzrGh1UCsoQzqkKTddvfAmdSDNZdAbJW+1Jmey19t29v
	 Fjq/6PlmG0JMBbqgVU3N5uTMIqy/2kWkfGbzX1zUVO8baxkzXVLzLBpUOcHlVoaAE4A==
ARC-Authentication-Results: i=3; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=selector1 header.b=ULTvYK51;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=selector1 header.b=ULTvYK51;
	arc=pass header.oldest-pass=2 smtp.remote-ip=52.101.65.3
Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011003.outbound.protection.outlook.com [52.101.65.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50F2B606A321
	for <kvmarm@lists.linux.dev>; Tue, 24 Nov 2026 08:13:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 50F2B606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=selector1 header.b=ULTvYK51;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=selector1 header.b=ULTvYK51
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=pOGjaq4HOA3/qQ3cnCtVLybUYD3UVJ8zZKS/T0sPcusSkKy48KzBoZ8WGp5aUM5lfsBUG3z0/ieYzbnf/w5RzYyqOTliGaZfXzpsSBe8egF0OFb6Zug1dsV6l0S+zuxX4ukeQH0nVQXx22EoM4H2L/tphrqkswG+R7ikeIkfYpvZkifon9z7hY5zGZHHm0bgUU2s7H1kp1lF/Qr1QqfqxhV8PFztY5nZuBYX4EJx1PDP5e6+DeeSwBlKhl10ck0BQ/ktXkKlebOQd0etOrrjbPn4l92K3UwGXzRZEzZzYuxDNyTwlQ3LX87cQbe/l+yyW2e7R6KFwVR2k+DPmHIDfw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qz/Gy0kGZ3xNNuVlmOOkcX3nwfAD+QZVVlSBXV4mxxY=;
 b=gwIqLfh1O1trvwO9z4JC3pfrQp4EIR2nlUJiKEQ1B9H7xez0WtTM3BfKQ8vshyhzabAMimBzh//WevfMUOOaPnprAjAsvA7qVySPOmm/gCgXUNbyQbtNndvtOtiiMQc7EcBoHs7gLHG/PCCWD7CaisD32IsNc+2lO/IGOK4o/KO5S7Sms4cDUoxMRS+mVtgYpo/wvpIQVeikeuXtyUPfoT8ymVxOIZwlvZepEY8OGiV6+U9p5MQbaTMuScPsRaFIbmzmDv/4d5E2Gh5oI6ut4MZbaL/RRLfMzZo/brD5TFlki8oKiyghPAXDpV/wjfFUH/B9LRB6vjM/RLWh3UETdQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=linux.alibaba.com smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qz/Gy0kGZ3xNNuVlmOOkcX3nwfAD+QZVVlSBXV4mxxY=;
 b=ULTvYK51fe4Y3ek/F/eGMzIIDOJUmVM/WdAQ4dHY4PWe2wlYiBTMulKDc2jMIRfdWQ97bjVeQywBPrhIsxlB7HZrAmHw1x89QMy2eQgfnVJTAHsAO62LnmuhPI5X6737F+sWlYKDEviCuxSfkMFuXKbDr3erNOgW6Fq8ppAgZqU=
Received: from DU7P250CA0021.EURP250.PROD.OUTLOOK.COM (2603:10a6:10:54f::10)
 by GVXPR08MB10787.eurprd08.prod.outlook.com (2603:10a6:150:150::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.14; Tue, 24 Nov
 2026 08:13:44 +0000
Received: from DB1PEPF000509E9.eurprd03.prod.outlook.com
 (2603:10a6:10:54f:cafe::a8) by DU7P250CA0021.outlook.office365.com
 (2603:10a6:10:54f::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.662.6 via Frontend Transport; Tue, 24
 Nov 2026 08:13:44 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 4.158.2.129) smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509E9.mail.protection.outlook.com (10.167.242.59) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.639.5
 via Frontend Transport; Tue, 24 Nov 2026 08:13:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HoOUkFfMy94lTtv1eOM1wTHLZkJodCb+eSPWBiLeCMu7r/HgjVxTDoZre2RE46fUIEb7Feh75OQXPhCz5aOlZOuDvNbzf4a/HgQgh/vGD9NJC2k/5MCa3sOBwHKjtxUSNLF//5TbBJtUgwkCVVXhgiwx+VjX2LemaqaVxHOnm/xMMW8G4+7fneAMZDWNsrDsOmbejlLpFf9AZz5LeN6TKwzDjHwPIvIup7GL6yhWmM4OKJEHNg0nDDnd+9w3sLuuCzt9Laz4KdguYGWDbF0FySOaBhJyZ5BnlbsaI0blrt6jSV8n8WZ/9f64hRjtNdQpvpIpTEsCdcHtuE3BgZNFQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qz/Gy0kGZ3xNNuVlmOOkcX3nwfAD+QZVVlSBXV4mxxY=;
 b=mJsLq6B3BfiJZbb6xX3zAQeAlvqAz/DqUfUwHJK4P4SNfDwaXzgZbb7L26ABpGNI0eAoe7xw0cpDFAu7sjWO7ZRQezkNx6dUcT6hbeQFnEg7iT75MFJBhVRD08UDFDIbDa+2O0WeAJt9dv3GjrAh8QfpKxmTqIZRzA2AccV8sitqJGRaI2GQVeWNHnnzlDNlamDF91YzqPg1Y27XTl427EUdgQ28DgoNfYSqQxED2wqDYWNlzCVms37S96fOUu5+N9wOGJ1Ey92iNH02LpTvn6Lo3HXJmzdmyDlbV7AsqPl3JX0nh6PrOFp2GjyJcg9zFYkJJpWV1mGa8WxunZU0bA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qz/Gy0kGZ3xNNuVlmOOkcX3nwfAD+QZVVlSBXV4mxxY=;
 b=ULTvYK51fe4Y3ek/F/eGMzIIDOJUmVM/WdAQ4dHY4PWe2wlYiBTMulKDc2jMIRfdWQ97bjVeQywBPrhIsxlB7HZrAmHw1x89QMy2eQgfnVJTAHsAO62LnmuhPI5X6737F+sWlYKDEviCuxSfkMFuXKbDr3erNOgW6Fq8ppAgZqU=
Received: from AS2PR08MB9786.eurprd08.prod.outlook.com (2603:10a6:20b:605::22)
 by PAVPR08MB9532.eurprd08.prod.outlook.com (2603:10a6:102:312::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.13; Tue, 24 Nov
 2026 08:13:00 +0000
Received: from AS2PR08MB9786.eurprd08.prod.outlook.com
 ([fe80::d721:dfdb:2f83:155]) by AS2PR08MB9786.eurprd08.prod.outlook.com
 ([fe80::d721:dfdb:2f83:155%6]) with mapi id 15.21.0639.012; Tue, 24 Nov 2026
 08:12:59 +0000
From: Justin He <Justin.He@arm.com>
To: Yao Yuan <yaoyuan@linux.alibaba.com>
CC: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Fuad
 Tabba <fuad.tabba@linux.dev>, Joey Gouly <Joey.Gouly@arm.com>, Steffen Eiden
	<seiden@linux.ibm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>, Zenghui Yu
	<yuzenghui@huawei.com>, Catalin Marinas <Catalin.Marinas@arm.com>, Will
 Deacon <will@kernel.org>, Mark Rutland <Mark.Rutland@arm.com>, Paolo Bonzini
	<pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, Shuah Khan
	<shuah@kernel.org>, Sascha Bischoff <Sascha.Bischoff@arm.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>
Subject: RE: [PATCH 3/3] KVM: selftests: arm64: Test KVM_PRE_FAULT_MEMORY
 before first KVM_RUN
Thread-Topic: [PATCH 3/3] KVM: selftests: arm64: Test KVM_PRE_FAULT_MEMORY
 before first KVM_RUN
Thread-Index: AQHde1zMDs/Q2stDPkmFlaiiFOxCN7c8z3MAgAAP9EA=
Date: Tue, 24 Nov 2026 08:12:59 +0000
Message-ID:
 <AS2PR08MB97864B308EA8B8528C915E71F7442@AS2PR08MB9786.eurprd08.prod.outlook.com>
References: <20261123150917.2679600-1-justin.he@arm.com>
 <20261123150917.2679600-4-justin.he@arm.com>
 <6gdla4edbwa6e2s36libskrg5h3glxq3tdl7blthke42sbuqb7@tpczgelv4vud>
In-Reply-To: <6gdla4edbwa6e2s36libskrg5h3glxq3tdl7blthke42sbuqb7@tpczgelv4vud>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Authentication-Results-Original: mx.microsoft.com 1; dkim=none (message not
 signed) header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS2PR08MB9786:EE_|PAVPR08MB9532:EE_|DB1PEPF000509E9:EE_|GVXPR08MB10787:EE_
X-MS-Office365-Filtering-Correlation-Id: fc736694-008b-49ca-667b-08df4a02db1a
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|7416014|6133799003|22082099003|18002099003|11063799006|56012099006|261009223027099003|261021123027099003|4143699003|261022105027099003|261102123227099003|261026121527099003|261028144727099003|261026140227099003|261021121427099003|261022075727099003|38070700021|10067099003;
X-Microsoft-Antispam-Message-Info-Original:
 AX1HtReWUdlZcdnO+CMnqysIMYU1xT1G+hmVq0uv0B7KcLC0LZIVZmWFSsMVB2k6M2ssd98zgo3fWKrMzl8lMeJtH/0M7TyLKhELE2PfgYgurgpmtAQu2gIBct983bZSD2Csi1kRG24JgBullG7JHhGDci8Yb8gE2LrlhC5VuzmNewyRwGsxFyj8p52ZqrzWXl2Euh/pqgmiwxnZTrdn+tOtuk0HZvWQBkTh4W6bBUTjzVHk50FnclIDbtEgPWOLIa8+keHiawGH9/LRt9SadpfkjKxw2/7JH8en3ua846oCQb/gLp0UuWIapyRTl4fn7UUMNI3+x4aQRZkItjQ7F1dCYu4iZRh/RKtSAJVvocD1YjaH4gU3ObPkegjZk1rXewth5Fh9VFMgyqGocxnp5OpgbbcSgOnxY9ESIR0kgqQUzzcaS7tO2bmC9rAf3jJej4xhnXJ8EVWW3OswZpv+bwNeO/golaY1zvfOS5kJSKykF5ITSI2WeBFqelDCH6Cwf7unhSRXxIIy1Ecgy28vxcOiuvcv+e4lMrFW0mzHN7ElrKMPr0vdPZr9/MzarSqQXHEg7/IX7KIlCxgTizSN6r1VQZXVLcwViqHbwtHs8D55O8pORJDBgvmT2fLUSSYHp7jY3rgvr6+LA3IZQTAC1nI19U5IcTN5452PbOjoGuVjypYml3kjE8DNWTpurGBK0LcUvMux1MXHFGhS+7+b+dDWm+IrvWaWxCbTws90jH8=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS2PR08MB9786.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(7416014)(6133799003)(22082099003)(18002099003)(11063799006)(56012099006)(261009223027099003)(261021123027099003)(4143699003)(261022105027099003)(261102123227099003)(261026121527099003)(261028144727099003)(261026140227099003)(261021121427099003)(261022075727099003)(38070700021)(10067099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 M8w5XoAvbCgZqXlLlN8xuX2LOOzCUC+ZwZdTSidU/mlZyIud66IbvHJkHWoOuWAA1RpFPqKhyU94+UpK2YXbhbQYuwubvxZL3jl+dLiTRML0wKr7arOCZOWU9Mp/st+0MRYFqOrTpeCHIyeWcyYXmBNIWZiEnUCzs9bX6S7lEe1WuwG8U8sUurv6MHMzs7PU3tpRp0AJBp4oVqF1e3Jw0gCmVqv66+T0nufn8hSpMIdEZHNE3lCypgTmDKppNPzaem2ja83kpnOOvjV/SGX5/7gWvdAldOc1pEM8Mt1Z0mmU7REvjd9qMYolS1YT8RD3y+zNav6Wjp9AErEk2dvAVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAVPR08MB9532
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509E9.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	73dbc1b7-6f28-4c6f-8746-08df4a02c0fc
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|376014|7416014|23010399003|14060799003|35042699022|36860700016|6133799003|18002099003|261009223027099003|22082099003|261021123027099003|261021121427099003|261022105027099003|261022075727099003|261026140227099003|261026121527099003|261028144727099003|56012099006|4143699003|10067099003|261102123227099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	MAmWPjgPCyNsAxtWjyZOdah6ck8OpZyO2j6VvhCXaMoHbd2Z/KhU0H1GXuf3tvJJ/dqkHFe37K1n7tJAjUmrTqW0JgjaiWSJJv+zzxnnHuy5zbx7ML5ZkUXkF1OXpo2rQ0DtzmzVvP8BziAQsq6Dkyn75riMa0C0MM4d8drCi//J7m5mVKyK0mFYvtlDoTkRiJaD4rNKhUifFZlwBVHAYd5Zc4PwuaAVj0b3VH71pCUKg6bs9WZ5/a1dCuwtnKnmX5+GfTv+NUkAPu9oEPvp5w9KfGvz6Ve0Zg5f/2RCI2bpGVrJIM3lhSFHC9xv7sAel0MkrDNJLCzy9DSkxwUXH3r81kd/INzj58UfUfsznW+/9Ll8c7qWS0bQurKwirgRlec5Mn97gj6L9kuY00DMetY6jc/1M2Cupxhu+jbI6aefTHi8ucdt57x0zzOwXA3cFJvyppMmL4rQfCNUrg/O8QQGbK8fyh7OmCJvugDZgFmyA0qsEIR7Bw0apV9Lyf+++/SVLr/ZLJVBg4jVugzvJtSrW+15O9h8e3r7Ad+bhOfsbj3/yPjO0TTVI2fvQdlPJKBehRQ6BqwVP51hHFBippNieGQwNYsOYeD41mM1DXxLIVjBmWDUqNYHPNaj4hB2IIXPI9Lj46TJpOmXJcnFtw1YiTy4UrOrsIXimvuUD7Uv0v2vSNKLmzVEhxXRObV9frXsSxJWcBwGmqJlOgxBNw==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(376014)(7416014)(23010399003)(14060799003)(35042699022)(36860700016)(6133799003)(18002099003)(261009223027099003)(22082099003)(261021123027099003)(261021121427099003)(261022105027099003)(261022075727099003)(261026140227099003)(261026121527099003)(261028144727099003)(56012099006)(4143699003)(10067099003)(261102123227099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Cip4GZA5M42L44/xcxV02lLPlup+OXePszWFJmgRKvXKbAi+c6wQpRX/vQUJuAp+zHJw0LXYYUP/H13WMlexoaKfXrd5pYYeRyhU+wu7GN0Q0x/uByr8pqgJX6u1iTvTqE2POMdPWNwnlbRhjFEjO+AaRP6vvzlaZ1kQwvIu26WH1T9DAkxLaAYRvj50974ZyCxsAeq4nKhtsJ1VmKhQt4hluBstz+oMO7UH6gWSlvL79aSKcaQpi9PFdR5ONoqiLG3zcR/zx6YjXkvzuGtrzV1A9M0vg0WB4VcPpyLpjPWLBlV8fSQynFbgsrgSXedr7ZC4HuOWcsqRHibSphcFJ8FDTh3giDtBwvMHhhHusTXk6jKCRwDVH5E0A4NhTuRTXXqaQBi+a+eejGNx+qm4VGCssxYsKYdstOTW+5cW9aaV6DCuAX4A+v4fpX2CHjsu
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2026 08:13:43.5161
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fc736694-008b-49ca-667b-08df4a02db1a
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509E9.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR08MB10787

Hi Yao,

> -----Original Message-----
[...]
>=20
> > Without EL2, cover immediate_exit on the first KVM_RUN, retrying after =
a
> > failed first KVM_RUN, and pre-faulting while the vCPU moves from the
> > main thread to a worker thread for its first run and back to the main
> > thread for its second run. The two threads are pinned to different CPUs
> > when at least two are available.
>=20
> I suggest to list them for better readability e.g:
>=20
> Test cases for w/o EL2:
> 1. Immediate_exit on the first KVM_RUN
> 2. Retrying pre-fault after a failed first KVM_RUN.
> 3. Pre-faulting while moving the vCPU between 2 threads.
> (more details of 3 can be given in code implementation there)
>=20
Will do in v2.

> > With EL2, additionally cover an EL2 vCPU with ID_AA64MMFR4_EL1.NV_frac
> > cleared to 0 and HCR_EL2.NV=3D1 at EL1h (the NULL vncr_tlb reproducer),=
 an
> > EL2 vCPU with a vEL1 context and asymmetric HCR_EL2.IMO/FMO staged
> before
> > the first run, and the same thread handoff. An unfixed kernel reports
> > the staged context case only as a WARN in the kernel log; the test
> > itself still passes.
> >
> > Signed-off-by: Jia He <justin.he@arm.com>
> > ---
> >  .../kvm/arm64/nv_pre_fault_memory_test.c      | 335 ++++++++++++++++--
> >  1 file changed, 298 insertions(+), 37 deletions(-)
> >
> > diff --git a/tools/testing/selftests/kvm/arm64/nv_pre_fault_memory_test=
.c
> b/tools/testing/selftests/kvm/arm64/nv_pre_fault_memory_test.c
> > index 09c1db303856..6dbcf3b0ef13 100644
> > --- a/tools/testing/selftests/kvm/arm64/nv_pre_fault_memory_test.c
> > +++ b/tools/testing/selftests/kvm/arm64/nv_pre_fault_memory_test.c
>=20
> ...
>=20
> > +
> > +/*
> > + * Pre-fault before the first KVM_RUN with ID_AA64MMFR4_EL1.NV_frac =
=3D=3D
> 0
> > + * (no vncr_tlb) and HCR_EL2.NV=3D1 at EL1h.
> > + */
> > +static void test_pre_first_run_no_nv2(void)
>=20
> This may not necessary per Marc's comment on patch 2 ?
>=20
I'd like to keep it. It is the reproducer for the NULL vncr_tlb
dereference that patch 1 fixes, not a test for patch 2. With patch 2
dropped, it becomes the regression test for patch 1. I'll add that to
the comment.

> > +{
> > +	struct kvm_vcpu *vcpu;
> > +	struct kvm_vm *vm;
> > +	u64 val;
> > +
> > +	pr_info("Testing pre-first-run pre-fault with NV_frac=3D0 and
> HCR_EL2.NV=3D1\n");
> > +	vm =3D setup_test_vm(true, false, guest_el1_touch_and_done, &vcpu);
> > +
> > +	/* Copy the EL2 S1 configuration into the EL1 sysregs for vEL1. */
> > +	vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_SCTLR_EL1),
> > +		     vcpu_get_reg(vcpu,
> KVM_ARM64_SYS_REG(SYS_SCTLR_EL2)));
> > +	vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_TCR_EL1),
> > +		     vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_TCR_EL2)));
>=20
> ...
>=20
> > +
> > +static void *first_run_worker(void *arg)
> > +{
> > +	struct handoff_args *h =3D arg;
> > +
> > +	maybe_pin_self_to_cpu(h->cpu);
> > +	pre_fault(h->vcpu, TEST_MEM_GPA + SZ_1M, TEST_MEM_SIZE -
> SZ_1M);
> > +
> > +	vcpu_run(h->vcpu);
> > +	expect_ucall_sync(h->vcpu, 1);
> > +	return NULL;
> > +}
> > +
> > +/*
> > + * Pre-fault in the main thread, run the vCPU for the first time in a =
worker
>=20
> Minor: the pre-fault happens in worker thead yet, see first_run_worker().
>=20
Right, both threads pre-fault. I'll fix the comment.

> > + * thread, then pre-fault and run it again in the main thread. This ch=
anges
> > + * vcpu->pid both before and after the first run. If at least two CPUs=
 are
> > + * available, the two threads are pinned to different CPUs.
> > + */
> > +static void test_thread_handoff(bool has_el2)
> > +{
> > +	struct handoff_args h =3D { .cpu =3D -1 };
> > +	struct kvm_vcpu *vcpu;
> > +	struct kvm_vm *vm;
> > +	cpu_set_t allowed;
> > +	int cpu, cpu0 =3D -1;
> > +	pthread_t thr;
> > +
> > +	pr_info("Testing pre-fault across a thread handoff (%s vCPU)\n",
> > +		has_el2 ? "EL2" : "EL1");
> > +
> > +	CPU_ZERO(&allowed);
> > +	kvm_pthread_getaffinity(pthread_self(), &allowed);
> > +	for (cpu =3D 0; cpu < CPU_SETSIZE; cpu++) {
> > +		if (!CPU_ISSET(cpu, &allowed))
> > +			continue;
> > +		if (cpu0 < 0) {
> > +			cpu0 =3D cpu;
> > +		} else {
> > +			h.cpu =3D cpu;
> > +			break;
> > +		}
> > +	}
> > +	if (h.cpu < 0)
> > +		pr_info("Only one CPU available, not testing CPU
> migration\n");
> > +
> > +	maybe_pin_self_to_cpu(cpu0);
> > +	vm =3D setup_test_vm(has_el2, false,
> > +			   has_el2 ? guest_code : guest_el1_code, &vcpu);
> > +	pre_fault(vcpu, TEST_MEM_GPA, SZ_1M);
> > +
> > +	h.vcpu =3D vcpu;
> > +	kvm_pthread_create(&thr, NULL, first_run_worker, &h);
> > +	kvm_pthread_join(thr, NULL);
> > +
> > +	pre_fault(vcpu, TEST_MEM_GPA, TEST_MEM_SIZE);
> > +	vcpu_run(vcpu);
> > +	expect_ucall_done(vcpu);
> > +
> > +	kvm_pthread_setaffinity(pthread_self(), &allowed);
> > +
> > +	kvm_vm_free(vm);
> > +}
> > +
> > +static void test_pre_first_run_el1(void)
> > +{
> > +	int feature =3D KVM_ARM_VCPU_SVE;
> > +	struct kvm_vcpu *vcpu;
> > +	struct kvm_vm *vm;
> > +	int ret;
> > +
> > +	pr_info("Testing pre-first-run pre-fault with immediate_exit\n");
>                                              ^^^^
> The vcpu->run->immediate_exit =3D 1 happens afte the pre_fault, thus
> s/with/then/ looks more accurate here if this is the desired behavior.
>=20
Yes, will fix.

Thanks,
Jia He (Justin)

