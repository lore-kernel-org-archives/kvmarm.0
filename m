Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011052.outbound.protection.outlook.com [40.107.130.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56AF84302ED
	for <kvmarm@lists.linux.dev>; Fri,  7 Aug 2026 11:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.52
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786101291; cv=fail; b=EJr7LDFc0ZHEWMCZDPyjSMNOzoVk26GgycA7raqht6ufAGWkaGsG8WJndZRMFQfMy5CEJHbCxkZzhWp8mriiBxjQQHoGmFLF3vqBDdDDKojfoyF0huV8KK4XwDws9z1xi35VKJm5OCI+PkIONWoGxsKKlHjq/gKXm8+iX/mRp2w=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786101291; c=relaxed/simple;
	bh=EyOIVke7pbq21kTz4zMsXXlRc0q+RZZj+lRWXscbzzk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=hAR70EyOD282uaBYbzLXq/zEpLgl1rUc6cOVu9fByaH4EgV6gOpx+u5RLF5e87SCo8TJsN5yVK5AzRcfmqlreb4OdQdpfu5SPb5nMLVytppUQifo4YrJCphmScyxn93iUgV0g63FZs6/agofWj/+2+ZdPuYyp5iLdACNc54QO+I=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=oKFHtvGY; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=oKFHtvGY; arc=fail smtp.client-ip=40.107.130.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="oKFHtvGY";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="oKFHtvGY"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=MX5Rr1/L4c5W3/pkIuyxIj13HcV3q3/HAT3Ogt6OO048NQkHsqwA6P+tSgsNF3TBbVXL0oFdCe9I/FuYJWs2UysPCSGMEWKPRBzfDp163a61/rJ+/znBmIlaP6q3SlOOiK44mNAzwlI6vbW5WNnmfXggIcIX/uafM7FpJLPIZ9xKeUKIPtuTiSsE4ldM9XSgzuNsXFFtUIlIfGxw7qDmwegMLeyybtqUhptjpmBiT68WxHuxsUbTSDLAiEtM0smJdA9hwY8Cki55zUPSwX4VujEpD6zRZbLyrbm9nxv5FbBLhB0vhsQ/Vof8xkeI/PP67AmShuPsCxiK1JktufbB6Q==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=egNm7K684Da2mZ6DTkN5yb/U0q/q7mGn9o2CYXzzRYg=;
 b=HQH0Ep5LqnyuQOJIiIwIrJTxMyqPPFOZxVQI+hYTjwE811DspJHND7eT+iw6cmKlPG+PElPFjhW1rhSRBkqLvxT8+DMJnKjyBc+TrhBK/5IkRwGvjbxa2D3cw/KjlKUEaXUIpHg0kVRk51Ph7ncuUe6ySgVzY1T7X8kGGzzP3BCPeOmWvW3rTXTZHrCRJUVXNZNqvy7JlYrTMhnZWav+mswMncCdind1mDE2huEn5LC4NmuzZn9eL0d3cM7vy2LsIbcOBYKfdYSkJBjepLYcDEcLr5Jf+HGS+loedexyDgRsczEk8q9q1W4VUKoarQbbRhpL4PvNdBDScA9J8ooZ7A==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=egNm7K684Da2mZ6DTkN5yb/U0q/q7mGn9o2CYXzzRYg=;
 b=oKFHtvGYnfSxsd2UKo0XsphxB5mvponFNoyJHdqIFoLJEpaNPORm6qqN4EXhZObxP3DSD0L6BMElEyoTD9oLpu0hBDlsumptwMN+vavd+IjZc7i+ILiKcu7sWt/BT42CmFddFhLAJcx0BwXKe/ph20UY/9EFGQ/xzOxh+SkdRt8=
Received: from DB8P191CA0024.EURP191.PROD.OUTLOOK.COM (2603:10a6:10:130::34)
 by PA6PR08MB10860.eurprd08.prod.outlook.com (2603:10a6:102:3d9::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.23; Fri, 7 Aug
 2026 11:14:41 +0000
Received: from DB1PEPF000509FE.eurprd03.prod.outlook.com
 (2603:10a6:10:130:cafe::5e) by DB8P191CA0024.outlook.office365.com
 (2603:10a6:10:130::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.23 via Frontend Transport; Fri, 7
 Aug 2026 11:14:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509FE.mail.protection.outlook.com (10.167.242.40) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.8
 via Frontend Transport; Fri, 7 Aug 2026 11:14:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xM0YhyiQOaKQLBSRrW6G2uP74oj89Q/Ho8cI3ezbYTcJngeCw8EBKn9IMkHMDGI5mIuoiYL353r9g8IcUyYcKgw03oFEQBZG6XcSk7jkeq46PbiEDSiSMkmq95Lkwpo7PKXzTnvS7ypyDvM2qYyjKd/rFgFU0qXTzK03Bnc4595FOK3LWht8sHiQzOhhX2TzesIbu62+l9dNq/243Ewnm2ZpNCDObLlgtoa/R8qurtsa87hZGOcoUUsKi/D8Ze1cstvUItb8SsxBVlELShz0fYgHkO1Gojnux6sztm4Vim/ijlq6oZBSMGPlWltfUO+z7cDzPWeWQh4SdSDvVEY2RA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=egNm7K684Da2mZ6DTkN5yb/U0q/q7mGn9o2CYXzzRYg=;
 b=gk+ALHY1kYDuOKMvT6lVn0aWLOBcIiUV8Ko/R82paWy4J9K15EvWBXoC1V2sqsAwEzTqTjO2fXjhi6Xtb20lQLWgkTpxrd+weHyBm7L2M/ExOAPZxjAbxbVUQe58oXIav0Dand2VQiFU1lBw6s7rH5DbAUXQYBCUihWdrPrAzuXMwoODhgayehg08uPgq9EIGNV/BzG+M7Wye0hR2jlo9rqZulQO46eJQtOskgkRYgDIA7NvqA7/dnZ69AJAmFgyVaYSQxFYIMrXAKXl9+Da2ma3oZfNZ64Vh/f6u7tQs4hnsgtiBGaxteNMkvga0reNtTDZmTsh02BwauFThr+tNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=egNm7K684Da2mZ6DTkN5yb/U0q/q7mGn9o2CYXzzRYg=;
 b=oKFHtvGYnfSxsd2UKo0XsphxB5mvponFNoyJHdqIFoLJEpaNPORm6qqN4EXhZObxP3DSD0L6BMElEyoTD9oLpu0hBDlsumptwMN+vavd+IjZc7i+ILiKcu7sWt/BT42CmFddFhLAJcx0BwXKe/ph20UY/9EFGQ/xzOxh+SkdRt8=
Received: from GV1PR08MB8428.eurprd08.prod.outlook.com (2603:10a6:150:81::5)
 by GV2PR08MB11562.eurprd08.prod.outlook.com (2603:10a6:150:2d6::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.23; Fri, 7 Aug
 2026 11:14:07 +0000
Received: from GV1PR08MB8428.eurprd08.prod.outlook.com
 ([fe80::9b97:c973:3308:5ba7]) by GV1PR08MB8428.eurprd08.prod.outlook.com
 ([fe80::9b97:c973:3308:5ba7%5]) with mapi id 15.21.0292.018; Fri, 7 Aug 2026
 11:14:07 +0000
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
Subject: [PATCH v5 03/49] irqchip/gic-v5: Set up gic_kvm_info on ACPI hosts
Thread-Topic: [PATCH v5 03/49] irqchip/gic-v5: Set up gic_kvm_info on ACPI
 hosts
Thread-Index: AQHdJl3dOdPEmMuWIEihuIlxfsIsfQ==
Date: Fri, 7 Aug 2026 11:14:07 +0000
Message-ID: <20260807111159.429128-4-sascha.bischoff@arm.com>
References: <20260807111159.429128-1-sascha.bischoff@arm.com>
In-Reply-To: <20260807111159.429128-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	GV1PR08MB8428:EE_|GV2PR08MB11562:EE_|DB1PEPF000509FE:EE_|PA6PR08MB10860:EE_
X-MS-Office365-Filtering-Correlation-Id: a1a93688-f9e3-42cd-cb4a-08def47513c1
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|22082099003|18002099003|5023799004|11063799006|56012099006|38070700021|6133799003|10067099003;
X-Microsoft-Antispam-Message-Info-Original:
 3RoLPH060xOWQWyafsLnhPsI8UDwITOfpr3U34nyAyleDPf4ZV1CMxOoGmiIZMKLitBejnqDr9943876oUT1/vm1z0ryukhL/jNMjt+O9I1zM/e+5SeIe4UhFbDss2AXQkCVzZJwHxgNbBrXn9l7118b4Mcd9ySiro9HR9JboxYR2VJNMMccnQv+Qtrnk5x+EbEzqoJTYeTKUbkvM4KOB6OH2zOSpUH6AnVzbt7FEpkD+1R43yaKyqX3HUKHauWK3QTFB1LUwwCOsKNAOQ59xwTPvVnWQ6cvC1Pn3vnZHVnrJ9hd305gmr7sh5RbB0yHFvNPHc4ciXuxsMdQ1TpXBcFH+VmhIvv8aYcTqKc1X1eLYphD6ed41RFlRcfZHXTXIq0V5tvmknSvOL2qTZ+IPNDe2Ro+1GSNx4J1HyY312ISh1KOet1KouTe+3rX0edODRsWUjTKCneL3uDn0woET2jXNQ1hbuaKUbOOILka91dZpH02TmD6iucrifkPkad+0gJjLSi0WvT1Qi2fT5EHWPCNaetTOvjKFX88mYG5bLEE87g2wIF0+KI4wH5AjdO+JRVT6k+60SlIWUAA1DkJG2s5fRVukgd572/4YHADpWxE9qMaG1PPkgwvfuVLRBrZIgYlmRf3k5LUbtan8wXKoMlp0uqvCGqRAgMzOLoPBfGwMZKYbaj6tHTGgC9yxP0lvE5VwDfVhJdvJyMNRzTEdSbO4zF30oqRkvQr8x3TAy0=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB8428.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(22082099003)(18002099003)(5023799004)(11063799006)(56012099006)(38070700021)(6133799003)(10067099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 jZ5X1nntBdHz3oY6V6vsAfYGGREdKelQ78J2xXdepEK3Zv6E8WTAcvbOiKNuadLLogFi7JN5u8P1lRh0WLk4nOju78fyRilGSxYyKoPoW7Ux8ykGR81qf5oR1D4aZ5djQBQD51tmYztSj50esdOrH6USCI88cloipsatoP1lOGlVRyA9xbXrhZsSKOs+dFFK74fwxklYuDWeIVfdgp2mKFLYZ5XER1x8nVUrlZ7iXYY80tX2OiakIVhX4ednlUU6vFd3YOdL470FCFLONkHxFN26a0Vgqu2hMw23vJstvmavKc3dJs8p75HmCQEzABF+IqhkCSalHvTM/Z1Es+vuuQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR08MB11562
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509FE.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	b3882035-2b3d-49f2-72cf-08def474ff97
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|35042699022|23010399003|36860700016|14060799003|1800799024|82310400026|6133799003|10067099003|5023799004|11063799006|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	TuupL/sAZn8Bd7Oq4BuuXkHHudf3tsyjqdaETq42uax+plZ+dFzjLhSK9o/GrAJf8rMsLBsYc44oWVrvcOtTx29OUGZGikyxrRSu/v4NXc0dmuKeh7864/f1z/v0lKm/0zTclKEexpzD1cf6xlud0urSolBbRlHv9FOZEOKT4dQZkpCJt4xLscduMecFFzc/9EYjC4apNoI0yyq0DY3I/9dgVcbKHJhZC5tmEYsoaYddUFD8kJfYvc28u6PUrvLYFB2JDUPV68v9haapkVD3PRBDYqztqIo6obpR1FAK2Xgn4wFJms9Zd+SaU7A0SkrAeyra2QLpA3a18NGZA95l1c/p+rheyUeEYMG53ilmakCMunspqd8ATv/0hyfjhvc/ncndW3UOUkaFEuNkOo4eBExCvhR5pAj3MQPsWcwU33hhc25O9PbGgFxABaqCe8tUw1Th0tBsdhB1Zn1gfzaWu3BIatZtH++SNx8ls8p7ReDJ8S7SWrs1mDWrF4C3atFOK+xCfuiOq0q3jWIvM/IfOkWgu4kqKB99QRKj3Yd7qcb3u3txHlHfFli0iTA6zsla0PDadaDRgfO8Z5h8U3FjnRTSQ8A4jJ1UwBWXD48sNzQMQJhjkRWtt/1usY1ClRV5HwtsJQyL0Rbs+dlsRluQgn9lroyt+FCn+Gtsbku05l7Gn0S9sGvw0wFKVs0np3ap8Hgj8CktjaT7DEE1PSaVPw==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(35042699022)(23010399003)(36860700016)(14060799003)(1800799024)(82310400026)(6133799003)(10067099003)(5023799004)(11063799006)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	zCZQmvpnVDWwukG1G8YZxlLwS7cyh1jEkOUURsweZblBlsxsBh5iyLXmqUdzFafQJkonG7Dem4WTLSgEbDHTogpCYtyDwKpm3Cq+BFvVaaXHZxmDD3g8xuXqb0xblkvMR0S4yMmIPtcf2eEbz8+gXW/40xlrzH2oEZXfkA8dDdlfDzXVHU9NL/qCEFIZeJy4jMKKk311hU/Or2w/preFUe7TOHzWP/FboiRppxolh8FYGJAn2tQVu5d2Lkh7YvT4dtQlpe2WqTeDPMd4kSiDdlKn9RRsciD5Fz9xbcMASaJFrHn1uCGNUNA3Ou8Gob3CHz1luxeAWtzBIDlmhvfy0dRxWdcyO/bLYC73SJAECnPCofAldMyr9UttA4shjQwo0NP/t10JpztlidHFsw4UYJQ0ZvCo6gfJyvak9369PzjzyJhJC3MyYCcPpNyg87ZL
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2026 11:14:41.1926
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a1a93688-f9e3-42cd-cb4a-08def47513c1
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509FE.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA6PR08MB10860

Device-tree based GICv5 probing already passes the IRS details and
maintenance interrupt to KVM, but the ACPI path only initialises the
irqchip and installs the ACPI IRQ model. As a result, KVM never sees
the GICv5 host information required to probe the vGIC on ACPI systems.

Add the ACPI equivalent of the DT KVM setup. Parse the MADT GICC
entries for the maintenance interrupt, retaining the value from the
first relevant entry and warning if later entries disagree. Warn if
firmware describes the interrupt as edge-triggered, but register it as
a level-sensitive, active-high GSI. Pass the resulting IRQ together
with the IRS base and coherency information to KVM.

Native GICv5 does not require a maintenance interrupt unless the
legacy GICv3-compatible CPU interface is present, so preserve the
existing no-maintenance-IRQ handling for that case.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 drivers/irqchip/irq-gic-v5.c | 95 ++++++++++++++++++++++++++++++++++--
 1 file changed, 91 insertions(+), 4 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v5.c b/drivers/irqchip/irq-gic-v5.c
index e7a7aedcfaf78..5b8ea8551d832 100644
--- a/drivers/irqchip/irq-gic-v5.c
+++ b/drivers/irqchip/irq-gic-v5.c
@@ -1126,7 +1126,7 @@ static void gicv5_set_cpuif_idbits(void)
 #ifdef CONFIG_KVM
 static struct gic_kvm_info gic_v5_kvm_info __initdata;
=20
-static void __init gic_of_setup_kvm_info(struct device_node *node)
+static void __init gic_setup_kvm_info(unsigned int maint_irq)
 {
 	struct gicv5_irs_chip_data *irs_data =3D gicv5_irs_get_chip_data();
=20
@@ -1137,17 +1137,19 @@ static void __init gic_of_setup_kvm_info(struct dev=
ice_node *node)
 	 */
 	if (!gicv5_global_data.virt_capable) {
 		pr_info("GIC implementation is not virtualization capable\n");
-		return;
+		goto out_dispose_maint_irq;
 	}
=20
-	gic_v5_kvm_info.type =3D GIC_V5;
+	if (WARN_ON(!irs_data))
+		goto out_dispose_maint_irq;
=20
+	gic_v5_kvm_info.type =3D GIC_V5;
 	gic_v5_kvm_info.gicv5_irs.base =3D irs_data->irs_base;
 	gic_v5_kvm_info.gicv5_irs.non_coherent =3D !!(irs_data->flags & IRS_FLAGS=
_NON_COHERENT);
=20
 	/* GIC Virtual CPU interface maintenance interrupt */
 	gic_v5_kvm_info.no_maint_irq_mask =3D false;
-	gic_v5_kvm_info.maint_irq =3D irq_of_parse_and_map(node, 0);
+	gic_v5_kvm_info.maint_irq =3D maint_irq;
=20
 	/*
 	 * We require an MI if we have legacy support, but don't, otherwise.
@@ -1162,11 +1164,95 @@ static void __init gic_of_setup_kvm_info(struct dev=
ice_node *node)
 		gic_v5_kvm_info.no_maint_irq_mask =3D true;
=20
 	vgic_set_kvm_info(&gic_v5_kvm_info);
+	return;
+
+out_dispose_maint_irq:
+	irq_dispose_mapping(maint_irq);
+}
+
+static void __init gic_of_setup_kvm_info(struct device_node *node)
+{
+	/* GIC Virtual CPU interface maintenance interrupt */
+	gic_setup_kvm_info(irq_of_parse_and_map(node, 0));
+}
+
+#ifdef CONFIG_ACPI
+struct gicv5_acpi_kvm_info {
+	u32 maint_irq;
+};
+
+static struct gicv5_acpi_kvm_info acpi_v5_kvm_info __initdata;
+
+static int __init gic_acpi_parse_virt_madt_gicc(union acpi_subtable_header=
s *header,
+						const unsigned long end)
+{
+	struct acpi_madt_generic_interrupt *gicc =3D
+		(struct acpi_madt_generic_interrupt *)header;
+	static int first_madt =3D true;
+
+	if (!(gicc->flags &
+	      (ACPI_MADT_ENABLED | ACPI_MADT_GICC_ONLINE_CAPABLE)))
+		return 0;
+
+	if (gicc->flags & ACPI_MADT_VGIC_IRQ_MODE)
+		pr_warn_once(FW_BUG "MI wrongly advertised as Edge-triggered\n");
+
+	if (first_madt) {
+		first_madt =3D false;
+
+		acpi_v5_kvm_info.maint_irq =3D gicc->vgic_interrupt;
+		return 0;
+	}
+
+	if (acpi_v5_kvm_info.maint_irq !=3D gicc->vgic_interrupt)
+		pr_warn_once(FW_BUG "MI not the same on all CPUs\n");
+
+	return 0;
+}
+
+static bool __init gic_acpi_collect_virt_info(void)
+{
+	int count;
+
+	count =3D acpi_table_parse_madt(ACPI_MADT_TYPE_GENERIC_INTERRUPT,
+				      gic_acpi_parse_virt_madt_gicc, 0);
+
+	return count > 0;
 }
+
+static void __init gic_acpi_setup_kvm_info(void)
+{
+	unsigned int maint_irq =3D 0;
+	int irq;
+
+	if (!gic_acpi_collect_virt_info()) {
+		pr_warn("Unable to get hardware information used for virtualization\n");
+		return;
+	}
+
+	if (acpi_v5_kvm_info.maint_irq) {
+		irq =3D acpi_register_gsi(NULL, acpi_v5_kvm_info.maint_irq,
+					ACPI_LEVEL_SENSITIVE,
+					ACPI_ACTIVE_HIGH);
+		if (irq > 0)
+			maint_irq =3D irq;
+		else
+			pr_warn("Failed to register GSI for GICv5 maintenance IRQ\n");
+	}
+
+	gic_setup_kvm_info(maint_irq);
+}
+#endif // CONFIG_ACPI
 #else
 static inline void __init gic_of_setup_kvm_info(struct device_node *node)
 {
 }
+
+#ifdef CONFIG_ACPI
+static inline void __init gic_acpi_setup_kvm_info(void)
+{
+}
+#endif
 #endif // CONFIG_KVM
=20
 static int __init gicv5_init_common(struct fwnode_handle *parent_domain)
@@ -1265,6 +1351,7 @@ static int __init gic_acpi_init(union acpi_subtable_h=
eaders *header, const unsig
 		goto out_irs;
=20
 	acpi_set_irq_model(ACPI_IRQ_MODEL_GIC_V5, gic_v5_get_gsi_domain_id);
+	gic_acpi_setup_kvm_info();
=20
 	return 0;
=20
--=20
2.34.1
