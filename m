Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013052.outbound.protection.outlook.com [40.107.159.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C4F73AE185
	for <kvmarm@lists.linux.dev>; Tue, 17 Mar 2026 11:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.52
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773747833; cv=fail; b=TbPTjLkRZVgXf3S/NrU30BBgzWjUC/qoeq9CHR5sKy7LQZxhrrRadI3Y7cU7JMOyNhRbt8BgSLXLHwW4cym/gzke8iObYFBUV9S8fCgm5Be7tsrEGVURcH/ojz9/gwcWXk8v3XSYtjllTAtma6yAhLTtEbqiDzOw5pjYa6QsvMY=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773747833; c=relaxed/simple;
	bh=xszZ2UOCR1Qc0v1ZMkzA1x6kpM54fA4Sq7X9aNrMnNM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=BEVeQwRdl93qbWg0w5kpQK8bqM0r/jgh/Ld/PucKwWrEL1WabjxV+aAKJIpe9PjclUYTRYB3Fl5xzu97Zc85nBeziSZhILn48r7OKydFFxzuI23o15Y9eUtWDkLa6twTx4nZXJNpV3Je6JhvNV33HlYdHK1vdRs6zJZvfYOpwE4=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=KnrjOQa2; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=KnrjOQa2; arc=fail smtp.client-ip=40.107.159.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="KnrjOQa2";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="KnrjOQa2"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=GMEZ16GknpCeFYYco8QwRub3t+993JY3s9/vy03YsfT2m0nEZA5UxoxVbq+2ML/h0xn+g9f2zWSLDhfqbCkqKeNhc0pOZtQOTTJ3mC4iOpt0tqfieb1qcXcvP24TLkJ1sUez05wLx3cJXZ2w/5n32RALiaCmp+ZqIubKqLH/7/thV0y21gcwRLa6Ip6Vssn1svlZkRubIGFn3YcnQsZMHtvwBUWlO9/rD2IBAi7Nsgdfu7XQR5au5k3r5s3a8PtbvpRX5t8U/pBPA/l+fNkV92fO4zL/9Jci/WzMOCiq3bluIrTCTr1FqKREs2dSQJ/YJsBiKNv9eQ7seiWvlFebiA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F/htmt20Zf5SxtZm+SMY5uWn76PrsOYo2MFd1evphZI=;
 b=CxWLVl/l5gM8cgQMdWRBKsa95BE7naBWaMR7SmCtWgL9ty0x2nMoaomltXr4+yFqgSx/8R2uk9uTt67ybR07vkKUp/a9fZ7BZ9ztYjvsiLBa2KkLkK0CBxOMZ39JroCeiBkH/NoJD8/hsWcBPHD885xdXOs5xQLGvstGvuRatYyOvw9XsjUR/Ze186436JVsXNZFAgp5pBePhcjIUjPnHEcU/W4fgK9pVgwXQQuof4l8+YfPoR2svWgfwyd2xmotU92yDZQftwiOergqUEP4hhXHluyaXbjpnb6XYnvFXIMULOJqC+5nTYleoZg1807RSqlTzl0UpC1dx5CYrHvszA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F/htmt20Zf5SxtZm+SMY5uWn76PrsOYo2MFd1evphZI=;
 b=KnrjOQa2Lc7H2yLb7iHJmNH1SBTYsyawqjkFQsRhg2DksWFtCmwA2i/yMwpdld60Fh2xkO2hqwCy8+C8CsGsJiD+gmetGDHb5Q0C/EP/zAlyiGYvnJA/1jAYwwDw8tKLaNVem1nZjm1S+4NNpLP2mfmxfqnIWJ0v/hHWZaMb8IE=
Received: from DUZPR01CA0055.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:469::19) by AS8PR08MB9455.eurprd08.prod.outlook.com
 (2603:10a6:20b:5ed::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.24; Tue, 17 Mar
 2026 11:43:39 +0000
Received: from DU2PEPF00028D0E.eurprd03.prod.outlook.com
 (2603:10a6:10:469:cafe::11) by DUZPR01CA0055.outlook.office365.com
 (2603:10a6:10:469::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.27 via Frontend Transport; Tue,
 17 Mar 2026 11:43:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF00028D0E.mail.protection.outlook.com (10.167.242.22) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9678.18
 via Frontend Transport; Tue, 17 Mar 2026 11:43:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yO2u9K4bFg4IW0Cv3pIQ3NhO7o5uuWWhLIgMqO6SKr/MO8yA+lry2v7tolO/JafDMXfUApo2krq4I4Va+Dhceiyr0AOvZpC56b6OlO8m00DLXwcAigObir9T5jyCGrwFrGi4H9UEd7hodW1UE6GbVwE+bd0/SnNLBZL9e+dbN88dAbCkgR0Xe/R4EFVd6YRHwV6bnVwTQEMyr4Sh9rR9RvWLt76Bg0szeI0FEN3f6D+DNsFACSKgHe9sNs1GkWqL3Ex3GbT+1668fOXPKZ7jTmF5HVQVR7YV1y35Ol7/7rj5PNe/Eh9utzUZsZjdIHxvgUp882+OdUxuUaUbk/KiLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F/htmt20Zf5SxtZm+SMY5uWn76PrsOYo2MFd1evphZI=;
 b=bJWWPPjaLpplc2RmkvScBxFSsKVbBKrga2yrPmF7NiX70MrSOBg1Hf6+JcbR5xWC4YmwOKuFWbZ3LXmOrDDQ6tTbs9z2RqPikZNFDTfBpUoA7ByxhGunqZSbQ6FQhmucj7a7AZUb9JNTPegNsMfRp3flgAgEtFvUMxXbNftU3g0M6bRAMf+Frh9bdrcKi4fdG4sjQeGbeL6MMOk3W2q10suIVxUVxw4tPezHpJs8QhGq6zPBdZ22uIpi+HRHK414xVgdGedGXlYADFczakPjdQ5bskTAuB6Q5CcZrRz9VdXpQ0mgdvXT5/EgVvCUcaQJ8rgvSD/erE/lMxhJ+hkANQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F/htmt20Zf5SxtZm+SMY5uWn76PrsOYo2MFd1evphZI=;
 b=KnrjOQa2Lc7H2yLb7iHJmNH1SBTYsyawqjkFQsRhg2DksWFtCmwA2i/yMwpdld60Fh2xkO2hqwCy8+C8CsGsJiD+gmetGDHb5Q0C/EP/zAlyiGYvnJA/1jAYwwDw8tKLaNVem1nZjm1S+4NNpLP2mfmxfqnIWJ0v/hHWZaMb8IE=
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com (2603:10a6:20b:504::10)
 by VI1PR08MB10122.eurprd08.prod.outlook.com (2603:10a6:800:1c8::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.21; Tue, 17 Mar
 2026 11:42:34 +0000
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27]) by AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27%6]) with mapi id 15.20.9700.022; Tue, 17 Mar 2026
 11:42:32 +0000
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
Subject: [PATCH v6 10/39] KVM: arm64: gic-v5: Detect implemented PPIs on boot
Thread-Topic: [PATCH v6 10/39] KVM: arm64: gic-v5: Detect implemented PPIs on
 boot
Thread-Index: AQHctgMk419bOgNpgk+fshzleIfmiA==
Date: Tue, 17 Mar 2026 11:42:32 +0000
Message-ID: <20260317113949.2548118-11-sascha.bischoff@arm.com>
References: <20260317113949.2548118-1-sascha.bischoff@arm.com>
In-Reply-To: <20260317113949.2548118-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS4PR08MB8241:EE_|VI1PR08MB10122:EE_|DU2PEPF00028D0E:EE_|AS8PR08MB9455:EE_
X-MS-Office365-Filtering-Correlation-Id: 2d84c5aa-9eaa-4e8c-b02c-08de841a6e81
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|38070700021|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 w9u0KLPSsjAzlfG4kQquGgiQyu5LQX9M16BuDUY9yCmw1iFQmK0EMUbXw9ZXU692sOKWoyRyYEyUa3cURCjafKHw538wi/6NVEBJWlYhiVf9JlPnYQHEU1It4OS0pnUGU1p9AeJY37Mu8sFzRgLB6NFuxu61ATKX1vgM6Qd7UKNZvJnAmcMM6TpHG+Pq7RqwOlVYK5LR0T3JKz38I0hly6CeM4Mo1uaJszo1RBW4hZvBiP2o/ER4ewUrMr+8iOCMOZ/hW5lJPtaqtg3yiVclxsMxFXqa9JDAuUW7vbepKdmmHHy0hl/4kugL4C55p8l2WAx/6vRQ506mhT1hgwnQU75kIIbwHuU+nw6eMDiP+6rit+Z8xd/ZpjE529YDUwWQ09sdwF5LOeTZ6PkL6v2cc016tWyOt5fTfhF59GfPGcUvsJKKq7cOJnptDb/v4LJrwhl5FYpq6ghivtRvkgKGoDFlywFrZ/j85fqDGpzE4vch9/ETz7xLOjiMSdd61FrGo1hSeFGKkWcAHTGLRlA+o9xQt0iway/uvOMqkNMX1TitEBGcYS+rnu4gBizWAnL6KfzWb48cx8fE+56nUauN4N9Ucgh1+vhHfBDH70qxGZDjNF6EyedhE7ZK2iXYl8BXEig8lHaJTlpxG5tIE7YRu2nYUTie9x0LX1xuOv3XU9BhiZ7F255lLrhS4w0GZ9Ky00WJ868fb+EbBOiMBFA7xoP3765nj07/PNTdFxqQNX7h4jfUxOkA17N7ujPnc0GjACJf9yUytfN5sl84cExogdEPl0S4Xp544dHMzUhDvS4=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS4PR08MB8241.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700021)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 gbG5m3mvNY1udPL+XIrYZfCtbsBVWVhLQ6GVYLCZ9Hj48cCrummqNN8jugsgonREOp0NiEC6Ga4VBWvMF91CwTfmAMC6Q+wVT9B5PvoKuRbAmvmPxbXiT4Pbd1v0ki0I9dGMXPCxceA93mF8hHG3w5cHHLQUFGQ6PevaqGhKleF+HvOVPzzwkiNEWMIKFmiYaPFJeJFLeOcstn6SkBVbhj9vxYRYUvIEw4AwkiSb6dEXYLSfGBCH/fwFThxxQfGIJKUqap4XUALsQgtht/G0M9iYXeWglLkZxxP0x9+LxNaAJhqPGSlpH6WoGION+H1fn2QZln+CeYKmueiUnvXBEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB10122
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF00028D0E.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	ca8657f0-0667-4599-e98d-08de841a46b0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|82310400026|35042699022|376014|1800799024|36860700016|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	i56OB4K1eOSgiExiRf5db5RLeyvgI7h+5FuXCWrYco25WIpkihg91lg6ns3fk8FDLKra4UxbRlQwh8sxaOG+FdWoXOAMIRDr7mDciSHHq+8uNV33uLRRYHhE2GkFutpvFG1jqmtPgJoBqhNC3ofyu/Zt/gWRnL9IFrznioV5N6DYmBHg5UQjhAq5yZZURJeFRwi4r/J1gekCIxt6O5APIkbT32BUcJSVNgmd0evIpu3k77RR3hnGBGpUvSwCtXTgFWkBNPh5NIp972x184kcsQaF1lV9bcCTwTvNoA9KCjC0aFPetMYk8zuE3TulfQZpzyUUvqm//adDFylVH/FjKnzoPW2H2NTSwNB9q3h7LFT+0nkSHOgCfj/+kC9OVKcSiJhYudazZe2Mw0ZcrvoVTmhuqxRa57Cwzda7DupO93Qm4zlXBjSBH4vOn2v1nx+ElQkw7aQxrVbogcOwD1thIQwfiy+9/a7iGgmT97CwyX1CnUfest12cEYvJT/z5EoaDtw10wthXMNN/ltuE8UJG53a7tToClEGXhsNgTvdfr0klfp88zUi5Pkn/9TaojGJc5R1uSQIg6FLyNyrSId0GRNs3LEgxfdnBav9UiM0euZCPY3RdOHEiGOgBXQZ33bD2bYLx6UJ2sJG2ETU0NkaXyjX3PkGWJGFcj2A3NH7/20mk+DP0O70oMBENfO3xhLzr3Hnr/CmLd8PkKA1DGS1NJPBwuD4XQSn2IPkU8jP2/XrArhNda8+LcwFDifQUURnkCmu3E3zOHpFhJrRo5+VgQ==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(82310400026)(35042699022)(376014)(1800799024)(36860700016)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	GUqqdHyzF4sewYdqODSX55JHIxunZDwofuybGsdxQwaiTs+Pko4EWt36DlUTgtXtBd+ev4+EiMBYFHy8QGnDucA8w0NV4BLDLt3LU3Jw2RUadItsQS6RbYcQBiaReMBTL+zHQiFX1riZtKj2UvCLQZspZJ3OpLTHByegKrvkA7YObwY+bcEi437o49svRiRIhXnl8U/WlkfIJsCfFYvG0P9PdVaCrxXglxQgaSV/DbeJnEj7oDy7rmsX59faWt3ML2hfE+xu1h9SsmAFyHH3zr1cYzEyT+5ez/5HIBwzDsqALw7fhg7yP7TcD2wF6jwad3f5Gev+zHi/lmUUqNEUxLqBaSimzA1qP1GtbxmSDOLHIFNVZ5tS+HOmiOsMhJ4tTOOaQWtzEW9ACQ0P3TEJXI4P/XjsXvOWo02lVw2rVZe+gR9EJ9sxPM86K0qLAO58
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2026 11:43:39.0057
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d84c5aa-9eaa-4e8c-b02c-08de841a6e81
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF00028D0E.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB9455

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
