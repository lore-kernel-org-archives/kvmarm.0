Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011066.outbound.protection.outlook.com [52.101.70.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F1103B52F8
	for <kvmarm@lists.linux.dev>; Fri, 24 Jul 2026 10:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.66
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784890256; cv=fail; b=EQgTY1Rg3LHjD3qPgwq1awViHBUvFBrdcOa0BoQdXhiBk1jyFR0VJGCEMBEK18Smp5HsODVcxp+EyItkth2GcISSXs2LNCZVnDoGiY1iteZHuCU9xY5NLurUC+h6omRtAkp9NvtRQ6KvMjxrNWmHNtzLIYpI6Fw9athZEC37nlQ=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784890256; c=relaxed/simple;
	bh=SBUYjWiooJFCuhoJ2OliYphmbLZe/Y1rWwmfYkm1XBY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=SiKVhU6oq2jf6sPHt4oiwi82IoRVbIXEDXtuu+9bX1QMscTGL8jdA5oSDHfrG6wRc+9oQ7CyBLC3rwJgiIPlgeF1TRqa2LRm0cKL2Kw+QdWdVZ+XNV/LjnffFK1/PyLtxhqmwXro45bBtuIqqQP1o8Xla+Y1lsJnJFqdscwvHUU=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=NN2GgZVJ; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=NN2GgZVJ; arc=fail smtp.client-ip=52.101.70.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="NN2GgZVJ";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="NN2GgZVJ"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=hbLrEC5gvV8ILSQACH13onSWXEXvR1VaDEuK9XMl4AIcniUw1XHs+6yoHS59h6Cy/epbaCUu8iDIDpSrQV6/6yVJUsU+FgWrNCx53WwFQvwUjMAqwJawezkNH7wMga69KlVaz6rHubpWt/902wREOF2K/s7G2WBIdyfWUvXrdEsAEiXFrxV2gimJXlu2RNU43awqpJv9R6+chTz/QxFN9szN622P85jbIPEUhpZ38lVq7YlUUDjOTT9+38qWpQDu3yKm8vLZbOaInSphzOxiZc+jNfdBkVApE8dpFk+aDdMcfW/3KI8tHEqxE+EpC1MYNwgU3LVg7wJ5sKHCv7wnkQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xGIkjePEaXQdYQQXr0f5I8kES5jfWalnIi1vIQ/EeOk=;
 b=b5SV9hW7AcEV1XRWWb1D4kxsDGpEjHv9rRzE85Wlv+GApAOnriHyLCt8sLivz/MQjqsExz3lGQ8jXtjR7PXyv2VlcpS6eN2wVlquciWB2m+ooUiTHi0z8AJhr2C0ehCyEzc0JSs/1N2Ltxf+2HfL2oCVhW1g+qmmbFBonq43R22zF1ni4ztxHtmL5WJHkNvKtzV5cMm0gh4AB4lHElgaXTJH77xTPG7uWJWXFas6eGEOxLxz4xWPgqauvT7h9r6Jull+VvZQKHo9dwUzK5CCF6uAubkk5wnkhP0hA7G+YV0g40pd8SW/emGDsFaDsPWQToCRWsblJDCjsv0ttJDEdA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xGIkjePEaXQdYQQXr0f5I8kES5jfWalnIi1vIQ/EeOk=;
 b=NN2GgZVJtpaQl5O1ZGY1Eu+756sj1oUWRCGZNUw2BxPhJcqmt2aDhPOg070O8WdOprnhQpui7KRLvp7w9lQS1DvLisyTaYB2+mInwX84jE3cnF2i3gF7ooWGY16cSFyV89eVfKaA/3gmYUUhXKRW8O2n9LKIy4iuIBJ2Ij9Uz7Q=
Received: from AS9PR06CA0595.eurprd06.prod.outlook.com (2603:10a6:20b:486::29)
 by AS8PR08MB8300.eurprd08.prod.outlook.com (2603:10a6:20b:56e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Fri, 24 Jul
 2026 10:50:44 +0000
Received: from AMS0EPF000001AC.eurprd05.prod.outlook.com
 (2603:10a6:20b:486:cafe::59) by AS9PR06CA0595.outlook.office365.com
 (2603:10a6:20b:486::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.11 via Frontend Transport; Fri,
 24 Jul 2026 10:50:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF000001AC.mail.protection.outlook.com (10.167.16.152) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.5
 via Frontend Transport; Fri, 24 Jul 2026 10:50:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=H5bed6bc2TsDti/hZAPIRputodgmoOjQaD35S52g6+vpfgGInh/TCpNBmYq7gw1qeVQf85mofNgA9TC1U6GvF6KBOn8gzwBzKQ/FBFU8s4AmJXE6z5Uj8bYJLKJQkJdP5qIXNlfPAByP7FgTHOUFncKZ8AiMUSUOfZPMdeTgrh6SEXBW1d/FO2gOvoedtEv1HWCQmrFH40RWUf6RlHXgxzSXBXZOzdzRw1e0qekx3ylAevBo5PmdXuL8kVY7zP6eAohr4NkB3iELsjzXVfT59H9Ab0JvbIR2nJbKMslNKH8XobLsVVc5p0+npB2yNDDlZQ7e6oesclqRXpizJSndLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xGIkjePEaXQdYQQXr0f5I8kES5jfWalnIi1vIQ/EeOk=;
 b=sTxfO9PWH1nWUAt2oxqHAg/L8eLUDUniJvZCaI51vXHcW/wiE4Lc+pjxW8fPCoMa6bvvtwyma4UtWcFxWc0nYz8weuIp9fgypbL4W3jSbjSf3p+fieKpzFn9YkHsbE5LFhTXevb6W4HBvXVTTf/yB+/7P+5YVO3sbzqvQfm9EHLZDKw3TgM7AD7sRVZln9Rf52lW98Eg68Qr0gpznChPTFjRcRztKcDjBJWUdt/1Qlobiz+RIHsFHFNuz8dGVVZ8KlqPzinwC5vYnDA/UUaCDQig/8nV/kyvChWMPTTIsmtgh0SsbhMQbro4nfhlA73R5G6p2nW7ssbzDbHzSL0Mpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xGIkjePEaXQdYQQXr0f5I8kES5jfWalnIi1vIQ/EeOk=;
 b=NN2GgZVJtpaQl5O1ZGY1Eu+756sj1oUWRCGZNUw2BxPhJcqmt2aDhPOg070O8WdOprnhQpui7KRLvp7w9lQS1DvLisyTaYB2+mInwX84jE3cnF2i3gF7ooWGY16cSFyV89eVfKaA/3gmYUUhXKRW8O2n9LKIy4iuIBJ2Ij9Uz7Q=
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com (2603:10a6:10:407::19)
 by PA4PR08MB6127.eurprd08.prod.outlook.com (2603:10a6:102:f3::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Fri, 24 Jul
 2026 10:49:42 +0000
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e]) by DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e%5]) with mapi id 15.21.0245.009; Fri, 24 Jul 2026
 10:49:42 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey Gouly
	<Joey.Gouly@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	Timothy Hayes <Timothy.Hayes@arm.com>, "fuad.tabba@linux.dev"
	<fuad.tabba@linux.dev>
Subject: [PATCH v4 05/48] arm64/sysreg: Add GICv5 GIC VDPEND encoding
Thread-Topic: [PATCH v4 05/48] arm64/sysreg: Add GICv5 GIC VDPEND encoding
Thread-Index: AQHdG1oi9BmK38SiYUa/pb/olhNkAw==
Date: Fri, 24 Jul 2026 10:49:42 +0000
Message-ID: <20260724104819.1296803-6-sascha.bischoff@arm.com>
References: <20260724104819.1296803-1-sascha.bischoff@arm.com>
In-Reply-To: <20260724104819.1296803-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU0PR08MB8421:EE_|PA4PR08MB6127:EE_|AMS0EPF000001AC:EE_|AS8PR08MB8300:EE_
X-MS-Office365-Filtering-Correlation-Id: e18c3127-d4a9-45be-1ae2-08dee97169bf
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|23010399003|366016|1800799024|38070700021|6133799003|56012099006|11063799006|18002099003|22082099003|3023799007|10067099003;
X-Microsoft-Antispam-Message-Info-Original:
 z8xAYwvGbeyoYGtt/ulG7nCWDg3q4dbwyhqKUCPDeynySfW8eXDTfnRyXhNfbbpMyuLcwflbHG7IeCp60dQyMmrMcLXqYP2UONKW876nbjmpypdqEvd8dQSPZHwE5T457QyGQEo/4vVy33Wmk8bz3tbiFCNvKlGY42yD0VDZ8eub6dG2IFkPc9VKUtkFJ9Zw/6DX/7lz41a1YtNsmWQ1aQiaCKJxzuI32fBcxGLjS2MWONwBiM+hn/lGs3Aixw1SDuMVuceTjLXYfFgiefgA9E/9d8nyfJ1K8NlrrhEgrxSsMoxRGpdbETUH0Kj2VKzLsUUT8qSoctavG2t+e8XV+zG9cxXlR4sKg2XNOsqTWrsF4IdFHRRHdcfVNR/7avuDvcOst+HiMyTXcvPuYUINDUyzUuySGf6RIHVq39q2AS4OfwLo4FBF+4LJ8fGTVzH5myO66EPIsj38mGthBf6VNJ0VP409bDonIWsfDCJ6hcN2lyaGBCQ+vx1KnI+0dFtTcd9cdq1C1gDLZdKeZ5HozxOnKrtChTT2O2mWSBfCkCEFAJtkPZMcvETwxSHWcetB9aJ3GUIQ3SAOn7wnjutrvzYADT9zd1sEbJbP5SxWrjKJeKyjXPXHC0QBwRp71AR4wKCPKyW5nbocnhI5wjGuMCMCwZZFsPlDwDmo6hEzDa8lF78LJturlIPwxw2gPyEGuu9wRMiU4kvTvQM6kB0KgQt647AL328cS/cy7neu/0I=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB8421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(366016)(1800799024)(38070700021)(6133799003)(56012099006)(11063799006)(18002099003)(22082099003)(3023799007)(10067099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 JDtWRfje5uieEbu1s3GvueKzIychL+MYjlJIlmL3AzxDpWwwR3BxYawfIE3/sXXJiwtDjbNRCkGIuxsQpUDnlTv0xSinlrsIAHE9iWKS5CwWo0l3m1jNwj/fW/EA1K9tl1asVKUPDQvS4m/cT3Ehk7GG3k1SOTX4r9n/GYBAOfoGrxLD7+JkSuGQ4oljJsJ8LtmeV6X9yliOry2eRHyRot2ZriGoMrHOnCTXUfb/LNngJEEAeGHd7UQAzeuhO5wMOTL3xwvcqQqoc38iqhhwwHseZdGLeHbo1vShYLtIIvuZOK5MipwB5Wdcicz86hHDOOjB4QMWudZ/hHchVdruwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR08MB6127
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF000001AC.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	7da943cd-feeb-4973-54d7-08dee971448e
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700016|35042699022|376014|23010399003|14060799003|3023799007|56012099006|11063799006|10067099003|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	COmIGuE6SpPvgQZSM/vM6TzDPGKe3DqJ729JnGsZZvqh/kPv3sD5Dg7intoNZu6qqjNEogLT8GtOW+dyKcsADKeSlYvEoIJMkIx7AJJuRFE7roheuG/SoOjNOs0FZgOKQkPtodZXWjJX/Wlbx8/CYxYRwTXqrPqU7/ex+eQUf+shaOSSDsT9GuAVzs2cqksCdj+ewYTnYPZ667C+y8N2lzzc8SieYsW5FpWZalkHvGfq1uzJvVxhjVouy9B9qOm/rqjuF72KE1/Q55VCZc0I3Hv2AMXupP0i+rofKTXbU6nCTP20Td+NoeO8B6VZHbcCIXZe8BF/0HTMT0O64IbSaMgTH2KqfR4keQkDLXCfhrBb7B1fNdFp7v+fj3mA/rFtO+Nz31lpeAfjRmS6MTNuzABFgRYHc+SB6ekDnZy/5NDG7MOia/+UwxYOEDRm14m74eykJ0hCEvXbO+KJ4K5h2Tv6Y1YF/6cCKbVZekc6BZl5qfu9KDFBVFXIsECGz1Tweh5IAdgpaXCLwLaHhfZKr4L+uJWwmTQbs01BSv+3814FDUD1qMCmyxrd0MHHg9iLMtbz0sF/5z95VJ7noswUXDWLTZ0qSQN8In4lU1vMBECNsPxxAYd4cawtFSzx5TRMR5c0VHNhefPrJNVa+X5oSesqf84LwUmiH2sixtcA9F8MolRL+PYUZUD8XQcDTkkFAZmOnw/B57Y3UajIYknfhw==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700016)(35042699022)(376014)(23010399003)(14060799003)(3023799007)(56012099006)(11063799006)(10067099003)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	3iWIUg5lca7EuD/XYpP+pW+jTMLnT3JpqDlBKkRTZLoG1PqYVpYFTWF0jeLsSHyv/KaYpfsd+3WDSiEjrYzlxn02xecOQMcq1vaPbDoIDfzZ3+QWuIzPafJL64nM+8MgrqTB67yfw+5luCSb3vaVl35q1bpm2zWtlc4JEReYUcG1q4ysn9jDTlzSQOlrxNGhYCETcsR8uzr1SwPNwDr1XCCb5iTJWpYGVFVxPPS+d+6jXzFSbPWjIAZb5TNqJo7BYFVlwr7IxNUz2V/NJCTSOEx2oralIiTAEAepQZ7GPaEIWzThCz68n50Jdn6OBM4a9LK6t9D8rahkyBv5Lkx+NpwTjfkz88JkfQTVlK0HFhsmoiP574Cqr87wUhLR9xaOv+c0J29TInFYHiBuf+DMKL17eI1BJVO+t+GFSp/EGvE8ziZTTknTyArDtwUT+eTO
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2026 10:50:44.6993
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e18c3127-d4a9-45be-1ae2-08dee97169bf
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF000001AC.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB8300

Add the encoding for the GIC VDPEND system instruction. This operates on
the virtual interrupt domain, and is used to make interrupts pending for
a VM.

This is part of enabling GICv5 KVM support, and is required for injection
of SPIs and LPIs.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/include/asm/sysreg.h | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysre=
g.h
index 7aa08d59d4944..c840b37adb2fb 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -1040,7 +1040,7 @@
 #define GCS_CAP(x)	((((unsigned long)x) & GCS_CAP_ADDR_MASK) | \
 					       GCS_CAP_VALID_TOKEN)
 /*
- * Definitions for GICv5 instructions
+ * Definitions for GICv5 instructions for the Current Domain
  */
 #define GICV5_OP_GIC_CDAFF		sys_insn(1, 0, 12, 1, 3)
 #define GICV5_OP_GIC_CDDI		sys_insn(1, 0, 12, 2, 0)
@@ -1105,6 +1105,17 @@
 #define GICV5_GICR_CDNMIA_TYPE_MASK	GENMASK_ULL(31, 29)
 #define GICV5_GICR_CDNMIA_ID_MASK	GENMASK_ULL(23, 0)
=20
+/*
+ * Definitions for GICv5 instructions for the Virtual Domain
+ */
+#define GICV5_OP_GIC_VDPEND		sys_insn(1, 4, 12, 1, 4)
+
+/* Shift and mask definitions for GIC VDPEND */
+#define GICV5_GIC_VDPEND_PENDING_MASK	BIT_ULL(63)
+#define GICV5_GIC_VDPEND_VM_MASK	GENMASK_ULL(47, 32)
+#define GICV5_GIC_VDPEND_TYPE_MASK	GENMASK_ULL(31, 29)
+#define GICV5_GIC_VDPEND_ID_MASK	GENMASK_ULL(23, 0)
+
 #define gicr_insn(insn)			read_sysreg_s(GICV5_OP_GICR_##insn)
 #define gic_insn(v, insn)		write_sysreg_s(v, GICV5_OP_GIC_##insn)
=20
--=20
2.34.1
