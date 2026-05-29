Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013027.outbound.protection.outlook.com [40.107.162.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9150E3D0937
	for <kvmarm@lists.linux.dev>; Fri, 29 May 2026 14:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.27
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780065311; cv=fail; b=ab5atQmdKUG4HAkKItLmcccN52Tajuzo7Ka1fZHZB6e6SAFgyeaQNcVDSEh/oUyfmaet45miAbStkHTHXAxbWs0jU7EPPYrxixKINcKQPw2BHgRNprXpa5Koe0ChoEi45CGM9whkqdL4n4RtK0LG/XSsVYNGqwqXSwfrQDDQVok=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780065311; c=relaxed/simple;
	bh=m07vg7pVFPrQKRPwxfI4HMVUWhnvNPEmqS1C7UfxAVI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=LGeuyjS0iehnppqHyUo11fDI1jexRAfPYZNj5gKEZ1RLVndjG9MJR63EYOS07bLaxS57NiRphxHU3gT+aYycfRGKo5UMJ+208SliCDSROoEq+tKqeI5A51Sa44TfUEBS9LPPxCxh/E1dKroTyZJ6FBsr9FQ66qazFaW9SdVkIUA=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=K2jN8fMn; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=K2jN8fMn; arc=fail smtp.client-ip=40.107.162.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="K2jN8fMn";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="K2jN8fMn"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=rbKp/6naecqCLMqMH9/guKaGtIe/UT8nPPHw/FF/kxV4sGK9hc+HpgQjnDcgkQGsugaz1rgay8vp26Zr1+U1ITanBOg52pvj2Xzb9D/J/TMRH9YImxEo6WGfSH8kMHyKU35/j12/wgCsNeDt4ZcpvIZJ5TapejFPAunqV2UFiGQ7/WcvSJUiGqhQrsaa70A4j4ZUbA4M391QHFtFjr/tdFn+yWW6En9dB0RSOr41mo8lFwHEkHLc1qh48OXW1FmnyxdEZGyxcyuxE7OYyDxAejZLbydwlBUD773Y68YWPDI2LgexyHNdLPBaYvrWnoiUhkzQ5zQ6GYNM+1noastjsQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m07vg7pVFPrQKRPwxfI4HMVUWhnvNPEmqS1C7UfxAVI=;
 b=vycSEN7XYIkMMqZdQMgdYyHrISVHIhvXXS8a6NCt9OxcXPdLLntFyF0G4CU6tszEJvpCfWPZlsoXFdz+JFHzFN4vJyfq6wSvcAlWeNGJTnQUoDdGrTxcllvgezFgMVx9kNji1im+nScKAzm1VjM/7jfbRGg6MFyhLTbPo02PA6qzU7CtZmyh98bvs7CtTi4Qbwe0VfrxfqlGY8yDFJPtuc584lEo4mUsBwnRpgBywjU/cMsZSkAY+RM38hJHBAhN9PceIx0bP2NgVypvEfT+mLbuAjOcS1zfzgSFiF1fmlIDqUewwOmQnG/tbaS1QHadgfa6q0QqRCVX6nNKdtvjlQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m07vg7pVFPrQKRPwxfI4HMVUWhnvNPEmqS1C7UfxAVI=;
 b=K2jN8fMnyQpMUGgdeN4ZvwDYCJQ0Ibg1iH10FIBtFGxcKxIMfNLnf4kVJkJ/PtJQiTNU9sQONl5m3MRqtzPCYdMEEVou2NZLuJhYDXvHTz5DAg+FM96nQUahHfIH0irBk639iuQumvUXu2SUC+XHvSY7Iz/lcdQXZ/MP9z1Huog=
Received: from DU7P195CA0030.EURP195.PROD.OUTLOOK.COM (2603:10a6:10:54d::17)
 by GV2PR08MB11944.eurprd08.prod.outlook.com (2603:10a6:150:340::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.13; Fri, 29 May
 2026 14:35:03 +0000
Received: from DB1PEPF000509E4.eurprd03.prod.outlook.com
 (2603:10a6:10:54d:cafe::30) by DU7P195CA0030.outlook.office365.com
 (2603:10a6:10:54d::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.71.14 via Frontend Transport; Fri, 29
 May 2026 14:35:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509E4.mail.protection.outlook.com (10.167.242.54) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.48.11
 via Frontend Transport; Fri, 29 May 2026 14:35:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sgWv1YRSBKkXH82m/MDQgPhzcSDga3VCR7SlWPcJJsi9dorz8yXNU20w9cfOLwY9GRNwmkWjeFa5yCr99+2WgB9+BHlDRjs7mvRjI2LBwxz+P7s62oLrpZu/OBD+ktYxy+6Gyok3CG8OHhR0zC51flSNKAfoWpnX5/xCdmRmau6AkM4APczEE2svzt57mUyg9k3I/0c+Y9WWlM1KVgiOxJgnh3kGd4srwRVdBnqzZD/lLicR1Od99GxKMeK+uQXymRHuwl1u3ybchs1r1BRyEyywrcchFkEF7sH2Sc+VcZ48+hWoXn82TAK6LCXtmtP7GVovlXAaWnfDv3yg0jRWqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m07vg7pVFPrQKRPwxfI4HMVUWhnvNPEmqS1C7UfxAVI=;
 b=jqkDHoUub2d4sv2EQ3P/h6y4J2C4MPojey3e+VXSzfYBhrg22rDJ5px0hUiJ/kwm+ZrJIJMYV/0E2FXga7590Vfus2tK4JCz36r5LnlUfuBxBRlJZCelXGUVeT4Hx5QKB+wLTQw0zr/1f6YueGo4nrp4ZZIyHvLxOeCrt5eqyjHJsxpxtahvalHBBN9LqgXQcs8ZmNwUm+ytcFPat4kGWSbe5Vcb/WZOQFusP5SlRB4jUV2GwpBeMLiso7s4cyEd4qHuvXc9C7MkONNksTq3vl7zzvulja4pfnTgy+twIrkJfJjF+pW+c5H/BCocz2a19tW4DkjGVYvzMbzx1L9lNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m07vg7pVFPrQKRPwxfI4HMVUWhnvNPEmqS1C7UfxAVI=;
 b=K2jN8fMnyQpMUGgdeN4ZvwDYCJQ0Ibg1iH10FIBtFGxcKxIMfNLnf4kVJkJ/PtJQiTNU9sQONl5m3MRqtzPCYdMEEVou2NZLuJhYDXvHTz5DAg+FM96nQUahHfIH0irBk639iuQumvUXu2SUC+XHvSY7Iz/lcdQXZ/MP9z1Huog=
Received: from GV1PR08MB7315.eurprd08.prod.outlook.com (2603:10a6:150:1e::15)
 by DU5PR08MB10703.eurprd08.prod.outlook.com (2603:10a6:10:520::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.15; Fri, 29 May
 2026 14:33:59 +0000
Received: from GV1PR08MB7315.eurprd08.prod.outlook.com
 ([fe80::c249:1aed:a4c2:4193]) by GV1PR08MB7315.eurprd08.prod.outlook.com
 ([fe80::c249:1aed:a4c2:4193%3]) with mapi id 15.21.0071.014; Fri, 29 May 2026
 14:33:57 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "maz@kernel.org" <maz@kernel.org>
CC: "yuzenghui@huawei.com" <yuzenghui@huawei.com>, Timothy Hayes
	<Timothy.Hayes@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>, nd
	<nd@arm.com>, "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, Joey Gouly <Joey.Gouly@arm.com>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>, "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>
Subject: Re: [PATCH v2 03/39] irqchip/gic-v5: Setup gic_kvm_info on ACPI hosts
Thread-Topic: [PATCH v2 03/39] irqchip/gic-v5: Setup gic_kvm_info on ACPI
 hosts
Thread-Index: AQHc6TEe+iYHG8M0IEiAkiOjZsvaubYhu0WAgANis4A=
Date: Fri, 29 May 2026 14:33:57 +0000
Message-ID: <86ce9d751635eb6cd1c39db8d5501829851641e5.camel@arm.com>
References: <20260521144846.1899475-1-sascha.bischoff@arm.com>
	 <20260521144846.1899475-4-sascha.bischoff@arm.com>
	 <86mrxlunue.wl-maz@kernel.org>
In-Reply-To: <86mrxlunue.wl-maz@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	GV1PR08MB7315:EE_|DU5PR08MB10703:EE_|DB1PEPF000509E4:EE_|GV2PR08MB11944:EE_
X-MS-Office365-Filtering-Correlation-Id: 8f87ab8c-e26d-459d-8f6e-08debd8f787f
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|366016|1800799024|22082099003|18002099003|38070700021|3023799007|6133799003|4143699003|56012099006|11063799006|5023799004;
X-Microsoft-Antispam-Message-Info-Original:
 6kKXZk6WT6tOnlB5ey8JNHESAi23atgCiveDDIkS7RsPW1v3vfPY4giFfstZS7tD6CNqTxsLEYnkJ3BkS3FUsJNnFjgxTewUe8rrGQVsZm5i1lFxi18FBS+2H05+fznXr5yLAqQBscEMSRdoAJlxps/lOKJRQ2ygCVvSj2leMl3NB5wLeGYvu/M2T8trQEwMgSoMGRAcho1Z94sM0ULkIuS9jFpCx1/5kmNzB0i0ArgIggoSwRFdQ2ZKeI7MVokrybY1KCNF/J4teI1aLM93VHySWgaINTANtU6XJLsjo9Qc74IcwNuR9QBsWHPpFBrpdRlO/XA5iAcjGGslikOhnaTTwdDfgYIiZxF26kxQxxiNghpjhSmeG58I/onRixMu6VcA4s3TmLLGNLgbW/+jx+6youHmbj0NdyjbUSA/zEE1E9oIwvb2GPJq3ENd4PrLxFYnmTRtdzc0Nq3tMihhKmatRQVo3z6WuvBbrFWkT9jXXPevJkIzDV8JMBmHACWsik6t1FhGLIZqbOs8hx/xLS/K/+7xiKp7uTSqpM6WMtd8eAs7zHX98E2px1y2S45M4SzY0AiXR4yY/Y+Ztt9HcXcPcjU+bzAFezjHa9NS2vazQ85h/hpndKPlxSvTGg8HxyRi5S53oYKX+Od3igv/fR0pBEDCE0Wxds+8hvXrbRy6JhVv/I9bGBUMdiVBomaW8ox5DQNEvLTw6IB5+VN6JyiRJF0zRCL3y1wld4c2UzR5ojIYjj8fvSas4293yZgY
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB7315.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(22082099003)(18002099003)(38070700021)(3023799007)(6133799003)(4143699003)(56012099006)(11063799006)(5023799004);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <DFEC4CDF7B66A346A2D720818A1C023A@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 MucR4y8pY19vs9CvODSMy84oMBWd3SaEf6niueIWr5V5tTKl8lUz1jG4AaEmuYwdVbuUnkOC5kpBVs8d/wX0t5XTJJaShE+L5XVVRB/f2PcCkwUioyxxa+l4238oFujKkBJ3XMuPsiBqZH7fN5dGsxNCsx94cSWwVhlcfpZxj7By+oMyn6ENhnq1ll327wcizSPrJz1PcTDlAnczg2/F5Bbu+hgVHsbXD5TorQOrXtF1ZUJWB94jpRx4XHoQADWI3xPijN8FiSfJkAoPvoPivK6UXn8KIgP2YkarztGPVJL6eInTAqyPofQTxJurXIC7fOx7CqRU7lAiOZDi8SElSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU5PR08MB10703
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509E4.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	f410a911-78db-47d9-a8c4-08debd8f5111
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|14060799003|36860700016|35042699022|1800799024|82310400026|6133799003|56012099006|4143699003|3023799007|11063799006|5023799004|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	DVPRqTxiCNgYDE2lsqw5T/j81cqMT40kcMIzK+ho3ym/DS5eXWEA2ossIKkaefynT/CaWQh0XST5i0tSGFgGvizFG7oYvTuiMjJ8V1bcCftWCCd0EM5TorbDXbpYn6IaKdbqnxcpAJNI2A0jQemVwZmniRb9AWYxidwj/bHRnYCzotfzqke8YPwerhrsqqStF7yzugs1x6rfr4vGeka/9iszqb+gMKrd+0pXhUeCiAf1lq1h3/Ne32owwfGEfA9IbQKx8V64UzSYB10EBMzaG8D+YtJXUa3QUvmpQDPvvhOKoSPGg6l8Vjj5qOww7mh8A7g0V6t6bjKHjvcOV9kGsHGk33u0M0qEq1Cv8dDsmi2vHr0iUuU73vk1l1TKHaxgUgipipT+IULeHoAmUHGXZqCXKame9hRqWYuXrmGdwqLFerME0G0zwNy0DNpzlNe25ntoEqxm+hU2Gk+I0GIhFjrViyqAbTzZxgEMgkNLceq+URHcjjqXmJqpD6KSUHri2xxy1Q6RvClirt64pcEkTYvLGh3BU5A2TCDxoeIS2YT0I9GVXo42b3eMtB57ZtaSfNPfPg9GGHOua+Udjyy+bus4R7zaQ2Y3K3ZyFexuo2L3EWOPGeP8cLBezTuu8Skc49apDV40g+KGg+JXBcoXceFvwzjOrPRDLEdR+MXmfwosPO0T4PjgxlJMvbtH9vgrC+BkhW/qojdyMGZE8EaC6DnElhtFYu9VTnzg5s9sBbI=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(14060799003)(36860700016)(35042699022)(1800799024)(82310400026)(6133799003)(56012099006)(4143699003)(3023799007)(11063799006)(5023799004)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	bvJsxUgGfU/Bha7mMAvft8QXYyhzVeXe7aSrFmNPBw6+AMLo/cR1ziyx9iez3QkFzdYkES4yHg2cfxeajKA6dWaQkWyDdzOGIe7R9zRlpv0gVKqhOpbnXQNObgmfXS7aSe/ZG3dc38kAxBZf/lqjco6fCje7fdLjVYp9DvskvXd42brsD5RWJEbvPfZuKGHOg8z4tp0gSAelOZWiTUSHAhRF2AopZdS5ryRGJqSY1cthS3M7dl9C2f+CAjbj4GbMXvi9dHMglQE46FiVe1AuLvEcHPlNTHBvS/LWgFNs/tDAxrpo8nZm47J0zznl8czEq6lbJt6S2WIwSzFV5UnoyAMZrXrT2Pr0G3zOYiCpQIMArU5Ieqhrx6QzhzS5Q6IVq5gkp8+F2SWL0DfTuanyYrrnbmw1Hu5vaisBiUjwW2DksL9/r/QkgZGqCXm6HrlY
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2026 14:35:03.1705
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f87ab8c-e26d-459d-8f6e-08debd8f787f
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509E4.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR08MB11944

T24gV2VkLCAyMDI2LTA1LTI3IGF0IDExOjUxICswMTAwLCBNYXJjIFp5bmdpZXIgd3JvdGU6DQo+
IE9uIFRodSwgMjEgTWF5IDIwMjYgMTU6NTA6MDkgKzAxMDAsDQo+IFNhc2NoYSBCaXNjaG9mZiA8
U2FzY2hhLkJpc2Nob2ZmQGFybS5jb20+IHdyb3RlOg0KPiA+IA0KPiA+IERldmljZS10cmVlIGJh
c2VkIEdJQ3Y1IHByb2JpbmcgYWxyZWFkeSBwYXNzZXMgdGhlIElSUyBkZXRhaWxzIGFuZA0KPiA+
IG1haW50ZW5hbmNlIGludGVycnVwdCB0byBLVk0sIGJ1dCB0aGUgQUNQSSBwYXRoIG9ubHkgaW5p
dGlhbGlzZXMNCj4gPiB0aGUNCj4gPiBpcnFjaGlwIGFuZCBpbnN0YWxscyB0aGUgQUNQSSBJUlEg
bW9kZWwuIEFzIGEgcmVzdWx0LCBLVk0gbmV2ZXINCj4gPiBzZWVzDQo+ID4gdGhlIEdJQ3Y1IGhv
c3QgaW5mb3JtYXRpb24gcmVxdWlyZWQgdG8gcHJvYmUgdGhlIHZHSUMgb24gQUNQSQ0KPiA+IHN5
c3RlbXMuDQo+ID4gDQo+ID4gQWRkIHRoZSBBQ1BJIGVxdWl2YWxlbnQgb2YgdGhlIERUIEtWTSBz
ZXR1cC4gUGFyc2UgdGhlIE1BRFQgR0lDQw0KPiA+IGVudHJpZXMgZm9yIHRoZSBtYWludGVuYW5j
ZSBpbnRlcnJ1cHQsIHJlcXVpcmUgYWxsIHJlbGV2YW50IGVudHJpZXMNCj4gPiB0bw0KPiA+IGFn
cmVlLCByZWdpc3RlciB0aGUgaW50ZXJydXB0IGFzIGEgR0lDdjUgUFBJLWVuY29kZWQgR1NJLCBh
bmQgcGFzcw0KPiA+IHRoZQ0KPiA+IHJlc3VsdGluZyBJUlEgdG9nZXRoZXIgd2l0aCB0aGUgSVJT
IGJhc2UgYW5kIGNvaGVyZW5jeSBpbmZvcm1hdGlvbg0KPiA+IHRvDQo+ID4gS1ZNLiBOYXRpdmUg
R0lDdjUgZG9lcyBub3QgcmVxdWlyZSBhIG1haW50ZW5hbmNlIGludGVycnVwdCB1bmxlc3MNCj4g
PiB0aGUNCj4gPiBsZWdhY3kgR0lDdjMtY29tcGF0aWJsZSBDUFUgaW50ZXJmYWNlIGlzIHByZXNl
bnQsIHNvIHByZXNlcnZlIHRoZQ0KPiA+IGV4aXN0aW5nIG5vLW1haW50ZW5hbmNlLUlSUSBoYW5k
bGluZyBmb3IgdGhhdCBjYXNlLg0KPiA+IA0KPiA+IFNpZ25lZC1vZmYtYnk6IFNhc2NoYSBCaXNj
aG9mZiA8c2FzY2hhLmJpc2Nob2ZmQGFybS5jb20+DQo+ID4gLS0tDQo+ID4gwqBkcml2ZXJzL2ly
cWNoaXAvaXJxLWdpYy12NS5jIHwgMTAzDQo+ID4gKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrLS0NCj4gPiDCoDEgZmlsZSBjaGFuZ2VkLCA5OCBpbnNlcnRpb25zKCspLCA1IGRlbGV0
aW9ucygtKQ0KPiA+IA0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL2lycWNoaXAvaXJxLWdpYy12
NS5jIGIvZHJpdmVycy9pcnFjaGlwL2lycS0NCj4gPiBnaWMtdjUuYw0KPiA+IGluZGV4IDcwN2Rl
YWJiZjJmNjMuLmNjZDFlYzY5YTZhYjIgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9pcnFjaGlw
L2lycS1naWMtdjUuYw0KPiA+ICsrKyBiL2RyaXZlcnMvaXJxY2hpcC9pcnEtZ2ljLXY1LmMNCj4g
PiBAQCAtMTEyNiw3ICsxMTI2LDcgQEAgc3RhdGljIHZvaWQgZ2ljdjVfc2V0X2NwdWlmX2lkYml0
cyh2b2lkKQ0KPiA+IMKgI2lmZGVmIENPTkZJR19LVk0NCj4gPiDCoHN0YXRpYyBzdHJ1Y3QgZ2lj
X2t2bV9pbmZvIGdpY192NV9rdm1faW5mbyBfX2luaXRkYXRhOw0KPiA+IMKgDQo+ID4gLXN0YXRp
YyB2b2lkIF9faW5pdCBnaWNfb2Zfc2V0dXBfa3ZtX2luZm8oc3RydWN0IGRldmljZV9ub2RlICpu
b2RlKQ0KPiA+ICtzdGF0aWMgdm9pZCBfX2luaXQgZ2ljX3NldHVwX2t2bV9pbmZvKHVuc2lnbmVk
IGludCBtYWludF9pcnEpDQo+ID4gwqB7DQo+ID4gwqAJc3RydWN0IGdpY3Y1X2lyc19jaGlwX2Rh
dGEgKmlyc19kYXRhID0NCj4gPiBnaWN2NV9pcnNfZ2V0X2NoaXBfZGF0YSgpOw0KPiA+IMKgDQo+
ID4gQEAgLTExNDAsMTMgKzExNDAsMTQgQEAgc3RhdGljIHZvaWQgX19pbml0DQo+ID4gZ2ljX29m
X3NldHVwX2t2bV9pbmZvKHN0cnVjdCBkZXZpY2Vfbm9kZSAqbm9kZSkNCj4gPiDCoAkJcmV0dXJu
Ow0KPiA+IMKgCX0NCj4gPiDCoA0KPiA+IC0JZ2ljX3Y1X2t2bV9pbmZvLnR5cGUgPSBHSUNfVjU7
DQo+ID4gKwlpZiAoV0FSTl9PTighaXJzX2RhdGEpKQ0KPiA+ICsJCXJldHVybjsNCj4gPiDCoA0K
PiA+ICsJZ2ljX3Y1X2t2bV9pbmZvLnR5cGUgPSBHSUNfVjU7DQo+ID4gwqAJZ2ljX3Y1X2t2bV9p
bmZvLmdpY3Y1X2lycy5iYXNlID0gaXJzX2RhdGEtPmlyc19iYXNlOw0KPiA+IMKgCWdpY192NV9r
dm1faW5mby5naWN2NV9pcnMubm9uX2NvaGVyZW50ID0gISEoaXJzX2RhdGEtDQo+ID4gPmZsYWdz
ICYgSVJTX0ZMQUdTX05PTl9DT0hFUkVOVCk7DQo+ID4gLQ0KPiA+IC0JLyogR0lDIFZpcnR1YWwg
Q1BVIGludGVyZmFjZSBtYWludGVuYW5jZSBpbnRlcnJ1cHQgKi8NCj4gPiAtCWdpY192NV9rdm1f
aW5mby5tYWludF9pcnEgPSBpcnFfb2ZfcGFyc2VfYW5kX21hcChub2RlLCAwKTsNCj4gPiArCWdp
Y192NV9rdm1faW5mby5tYWludF9pcnEgPSBtYWludF9pcnE7DQo+ID4gKwlnaWNfdjVfa3ZtX2lu
Zm8ubm9fbWFpbnRfaXJxX21hc2sgPSBmYWxzZTsNCj4gDQo+IA0KPiBZb3UgcmVtb3ZlIHRoaXMg
bGFzdCBsaW5lIGZyb20gcGF0Y2ggIzEsIGFuZCByZWludHJvZHVjZSBpdCBoZXJlLiBNeQ0KPiBn
dXQgZmVlbGluZyBpcyB0aGF0IGl0IHNob3VsZCBuZXZlciBiZSByZW1vdmVkIHRoZSBmaXJzdCBw
bGFjZS4NCg0KQWdyZWVkLiBJJ3ZlIGNsZWFuZWQgdGhhdCBub2lzZSB1cC4NCg0KPiANCj4gPiAN
Cj4gPiDCoAkvKg0KPiA+IMKgCSAqIFdlIHJlcXVpcmUgYW4gTUkgaWYgd2UgaGF2ZSBsZWdhY3kg
c3VwcG9ydCwgYnV0IGRvbid0LA0KPiA+IG90aGVyd2lzZS4NCj4gPiBAQCAtMTE2MiwxMCArMTE2
MywxMDEgQEAgc3RhdGljIHZvaWQgX19pbml0DQo+ID4gZ2ljX29mX3NldHVwX2t2bV9pbmZvKHN0
cnVjdCBkZXZpY2Vfbm9kZSAqbm9kZSkNCj4gPiDCoA0KPiA+IMKgCXZnaWNfc2V0X2t2bV9pbmZv
KCZnaWNfdjVfa3ZtX2luZm8pOw0KPiA+IMKgfQ0KPiA+ICsNCj4gPiArc3RhdGljIHZvaWQgX19p
bml0IGdpY19vZl9zZXR1cF9rdm1faW5mbyhzdHJ1Y3QgZGV2aWNlX25vZGUgKm5vZGUpDQo+ID4g
K3sNCj4gPiArCS8qIEdJQyBWaXJ0dWFsIENQVSBpbnRlcmZhY2UgbWFpbnRlbmFuY2UgaW50ZXJy
dXB0ICovDQo+ID4gKwlnaWNfc2V0dXBfa3ZtX2luZm8oaXJxX29mX3BhcnNlX2FuZF9tYXAobm9k
ZSwgMCkpOw0KPiA+ICt9DQo+ID4gKw0KPiA+ICsjaWZkZWYgQ09ORklHX0FDUEkNCj4gPiArc3Ry
dWN0IGdpY3Y1X2FjcGlfa3ZtX2luZm8gew0KPiA+ICsJdTMyIG1haW50X2lycTsNCj4gPiArCWlu
dCBtYWludF9pcnFfbW9kZTsNCj4gPiArfTsNCj4gPiArDQo+ID4gK3N0YXRpYyBzdHJ1Y3QgZ2lj
djVfYWNwaV9rdm1faW5mbyBhY3BpX3Y1X2t2bV9pbmZvIF9faW5pdGRhdGE7DQo+ID4gKw0KPiA+
ICtzdGF0aWMgaW50IF9faW5pdCBnaWNfYWNwaV9wYXJzZV92aXJ0X21hZHRfZ2ljYyh1bmlvbg0K
PiA+IGFjcGlfc3VidGFibGVfaGVhZGVycyAqaGVhZGVyLA0KPiA+ICsJCQkJCQljb25zdCB1bnNp
Z25lZA0KPiA+IGxvbmcgZW5kKQ0KPiA+ICt7DQo+ID4gKwlzdHJ1Y3QgYWNwaV9tYWR0X2dlbmVy
aWNfaW50ZXJydXB0ICpnaWNjID0NCj4gPiArCQkoc3RydWN0IGFjcGlfbWFkdF9nZW5lcmljX2lu
dGVycnVwdCAqKWhlYWRlcjsNCj4gPiArCXN0YXRpYyBpbnQgZmlyc3RfbWFkdCA9IHRydWU7DQo+
ID4gKwlpbnQgbWFpbnRfaXJxX21vZGU7DQo+ID4gKw0KPiA+ICsJaWYgKCEoZ2ljYy0+ZmxhZ3Mg
Jg0KPiA+ICsJwqDCoMKgwqDCoCAoQUNQSV9NQURUX0VOQUJMRUQgfA0KPiA+IEFDUElfTUFEVF9H
SUNDX09OTElORV9DQVBBQkxFKSkpDQo+ID4gKwkJcmV0dXJuIDA7DQo+ID4gKw0KPiA+ICsJbWFp
bnRfaXJxX21vZGUgPSAoZ2ljYy0+ZmxhZ3MgJiBBQ1BJX01BRFRfVkdJQ19JUlFfTU9ERSkgPw0K
PiA+ICsJCQkgQUNQSV9FREdFX1NFTlNJVElWRSA6DQo+ID4gQUNQSV9MRVZFTF9TRU5TSVRJVkU7
DQo+ID4gKw0KPiA+ICsJaWYgKGZpcnN0X21hZHQpIHsNCj4gPiArCQlmaXJzdF9tYWR0ID0gZmFs
c2U7DQo+ID4gKw0KPiA+ICsJCWFjcGlfdjVfa3ZtX2luZm8ubWFpbnRfaXJxID0gZ2ljYy0+dmdp
Y19pbnRlcnJ1cHQ7DQo+ID4gKwkJYWNwaV92NV9rdm1faW5mby5tYWludF9pcnFfbW9kZSA9IG1h
aW50X2lycV9tb2RlOw0KPiA+ICsJCXJldHVybiAwOw0KPiA+ICsJfQ0KPiA+ICsNCj4gPiArCS8q
IFRoZSBtYWludGVuYW5jZSBpbnRlcnJ1cHQgbXVzdCBiZSB0aGUgc2FtZSBmb3IgZXZlcnkNCj4g
PiBHSUNDIGVudHJ5LiAqLw0KPiA+ICsJaWYgKGFjcGlfdjVfa3ZtX2luZm8ubWFpbnRfaXJxICE9
IGdpY2MtPnZnaWNfaW50ZXJydXB0IHx8DQo+ID4gKwnCoMKgwqAgYWNwaV92NV9rdm1faW5mby5t
YWludF9pcnFfbW9kZSAhPSBtYWludF9pcnFfbW9kZSkNCj4gPiArCQlyZXR1cm4gLUVJTlZBTDsN
Cj4gPiArDQo+ID4gKwlyZXR1cm4gMDsNCj4gPiArfQ0KPiA+ICsNCj4gPiArc3RhdGljIGJvb2wg
X19pbml0IGdpY19hY3BpX2NvbGxlY3RfdmlydF9pbmZvKHZvaWQpDQo+ID4gK3sNCj4gPiArCWlu
dCBjb3VudDsNCj4gPiArDQo+ID4gKwlhY3BpX3Y1X2t2bV9pbmZvLm1haW50X2lycSA9IDA7DQo+
ID4gKwlhY3BpX3Y1X2t2bV9pbmZvLm1haW50X2lycV9tb2RlID0gMDsNCj4gPiArDQo+ID4gKwlj
b3VudCA9DQo+ID4gYWNwaV90YWJsZV9wYXJzZV9tYWR0KEFDUElfTUFEVF9UWVBFX0dFTkVSSUNf
SU5URVJSVVBULA0KPiA+ICsJCQkJwqDCoMKgwqDCoA0KPiA+IGdpY19hY3BpX3BhcnNlX3ZpcnRf
bWFkdF9naWNjLCAwKTsNCj4gPiArDQo+ID4gKwlyZXR1cm4gY291bnQgPiAwOw0KPiA+ICt9DQo+
ID4gKw0KPiA+ICtzdGF0aWMgdm9pZCBfX2luaXQgZ2ljX2FjcGlfc2V0dXBfa3ZtX2luZm8odm9p
ZCkNCj4gPiArew0KPiA+ICsJdW5zaWduZWQgaW50IG1haW50X2lycSA9IDA7DQo+ID4gKwlpbnQg
aXJxOw0KPiA+ICsNCj4gPiArCWlmICghZ2ljX2FjcGlfY29sbGVjdF92aXJ0X2luZm8oKSkgew0K
PiA+ICsJCXByX3dhcm4oIlVuYWJsZSB0byBnZXQgaGFyZHdhcmUgaW5mb3JtYXRpb24gdXNlZA0K
PiA+IGZvciB2aXJ0dWFsaXphdGlvblxuIik7DQo+ID4gKwkJcmV0dXJuOw0KPiA+ICsJfQ0KPiA+
ICsNCj4gPiArCWlmIChhY3BpX3Y1X2t2bV9pbmZvLm1haW50X2lycSkgew0KPiA+ICsJCXUzMiBn
c2kgPSBGSUVMRF9QUkVQKEdJQ1Y1X0hXSVJRX1RZUEUsDQo+ID4gR0lDVjVfSFdJUlFfVFlQRV9Q
UEkpIHwNCj4gPiArCQkJwqAgRklFTERfUFJFUChHSUNWNV9IV0lSUV9JRCwNCj4gPiBhY3BpX3Y1
X2t2bV9pbmZvLm1haW50X2lycSk7DQo+ID4gKw0KPiA+ICsJCWlycSA9IGFjcGlfcmVnaXN0ZXJf
Z3NpKE5VTEwsIGdzaSwNCj4gPiArCQkJCQlhY3BpX3Y1X2t2bV9pbmZvLm1haW50X2lycQ0KPiA+
IF9tb2RlLA0KPiA+ICsJCQkJCUFDUElfQUNUSVZFX0hJR0gpOw0KPiA+ICsJCWlmIChpcnEgPD0g
MCkNCj4gPiArCQkJcmV0dXJuOw0KPiANCj4gVGhpcyBwcm9iYWJseSBkZXNlcnZlcyBhIGJpdCBv
ZiBhIHdhcm5pbmcuIEFuZCBtYXliZSBub3QgY29tcGxldGVseQ0KPiBmYWlsIHRoZSByZWdpc3Ry
YXRpb24gd2l0aCBLVk0/DQoNClRoYXQncyBhIGdvb2QgcG9pbnQuIEF0IHRoaXMgc3RhZ2Ugd2Ug
ZG9uJ3Qga25vdyBpZiB3ZSBoYXZlIGxlZ2FjeQ0Kc3VwcG9ydCBvciBub3QsIHdoaWNoIG1lYW5z
IHdlIGFsc28gZG9uJ3Qga25vdyBpZiB3ZSBuZWVkIHRoZSBNSSBpbiB0aGUNCmZpcnN0IHBsYWNl
LiBJJ3ZlIGNoYW5nZWQgdG8gZW1pdHRpbmcgYSB3YXJuaW5nIGhlcmUsIGFuZCBsZXQgdGhlDQpl
eGlzdGluZyBjb2RlIGluIGdpY19zZXR1cF9rdm1faW5mbygpIGZpZ3VyZSBvdXQgaWYgd2UgY2Fu
IGNvbnRpbnVlIG9yDQpub3QuDQoNCj4gDQo+IFRoYW5rcywNCj4gDQo+IAlNLg0KPiANCg0KVGhh
bmtzLA0KU2FzY2hhDQo=
