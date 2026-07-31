Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010051.outbound.protection.outlook.com [52.101.69.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E47153CB57C;
	Fri, 31 Jul 2026 14:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.51
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785508594; cv=fail; b=WW/16t4WYy9JvIgH4Wk32pRqpxaVi6RGyvtovEB/b55TS4XQLJ3WwncJzlr/YChIxpoff+nvg5V6YQ4PTudOQrxk6agCe3Ug2eN9VSCAvex0nm81b7opbXq05A0aFm2DnlHjbDdF6tJAFzk4kJJ2ih7PqqvAACiaoSwN92Uf2Pg=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785508594; c=relaxed/simple;
	bh=z3k7PXi00zjb3+Wfx1Bfr8qcGgdFdAxsPVeH9oCtHb0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=uPg0deBGf0K2Lt12nU8FFqFW/3Km8BKB8KeX0W2KlkJyzWKojgHavGctxbLxRFDtZ6quiUhbgO2Dqo6O8BP7CUZeb3hAkBqgp8QnfAj0rgYV+7ANFHxr6/eXogDfGlmdGqOsF+HAlqkMdRgLqdvm5DvgIm9dIijZRb9C01xSGz0=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=WdwgkPnf; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=WdwgkPnf; arc=fail smtp.client-ip=52.101.69.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="WdwgkPnf";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="WdwgkPnf"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=dd3zW8+ta1qg+b6+Nl9Uh8MzBuBtasiUWQQ4lmAAixwh5QkwANwDh/4sI385p8SaT9Q0dHz0vVexJM9JpnLS7iqBNgd5rmjiurm1JwaraBiK2oO8Sc3/Bs1aBFXIpCeM75sc+e9u+X5VrfpQ2g3UYCf9Ly5AYrekGCGhWHyR8gtBxxtx9VyxHbskIZVAutF6r3UrixqUR9IbqhcrgGZRJJxlEYKWmmLk0vW23VWVR/JX7IKX4hGj5nMWA8q0Pk89OZtp8WsJZs+LnQa7iKy2hv+K3wZZjA2mfZGuAGd29tskJ83AamQ7/vzRl1lvYWrgKgRVFCh8AVawdGJS+sH3Xg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z3k7PXi00zjb3+Wfx1Bfr8qcGgdFdAxsPVeH9oCtHb0=;
 b=c1nWBNjfv9zvDLxEoRUHUa1UPfCBikde7eDQfIbYOXfnJULxoPvTNjZnI81OOvEq47PI058jo8Bm+y3+DpYy2G1avEun5RjUaiJYaq5dojRUgkQomtiXabq8ZDfxnnkP/gaOeb6ELq/T7ayD7q/mAMHGjcy/RugJs1xlh6YSNbmXctoZLevLsa13uxbhcLX/MC2tkYDx7O4eMlcDlvNfgSqw+jnEV8pPedC2bM1L6sc9iEJRxz1t+gwy5VyOspFJkJA1Wg/f6XNHPcra1KNv+rxEddGUYGPzBVVniOgI1pq5jI+u494t2ZQuyUaVci1EFerb+YOco95XpRztPCKI0g==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z3k7PXi00zjb3+Wfx1Bfr8qcGgdFdAxsPVeH9oCtHb0=;
 b=WdwgkPnf8PlA1YA73gmiAnU6VJKe+ykpk1MRBmDCXXxQJ45i0elIhDhrXCktIsbYYs1Ylsm5szyzeYTBCG6htHNmUwQ3kKT0vfbmJeJwUYHWj4KBc4K2NMv+K4r6AtzWnJ4lp6Ps+fRg2flhr8RhCkrVJjbEZii3Y0EtQm/hvLY=
Received: from AS4P189CA0041.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:5dd::15)
 by DU0PR08MB9273.eurprd08.prod.outlook.com (2603:10a6:10:419::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.15; Fri, 31 Jul
 2026 14:36:27 +0000
Received: from AM1PEPF000252E1.eurprd07.prod.outlook.com
 (2603:10a6:20b:5dd:cafe::70) by AS4P189CA0041.outlook.office365.com
 (2603:10a6:20b:5dd::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.15 via Frontend Transport; Fri,
 31 Jul 2026 14:36:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM1PEPF000252E1.mail.protection.outlook.com (10.167.16.59) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.8
 via Frontend Transport; Fri, 31 Jul 2026 14:36:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aGzKSMm7Q+WiddPObtVoNvEtfjsxiRk4mAcbB+piGmo6KxqiewnKg5pP5yijFH3gsm1uAA5F4Aovtgd8PTN1Hyzrldkt3aXi7U2L52cdk8+SlQBoEX+KxjjvuCdeSyqNQvSI0FEzQcOUP+MRCA2ByKgN+5ffgU8bIrtu7RMsmkLgxidqoegZdFGA8FHZyyjVAlR3Kysl7fmXqSdh5UeGib37PmX5dvfQQwrQjjUyVPesl4YihSHOnFiHGC53RWESRBdgWxYc/IxitBmq1WRZXFowKPNJ3L4yMl0C4Q18r9Z0HP4xQ1X/lQPyLzpc03lZkS1KIAQBXyaoaJd3FYWtcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z3k7PXi00zjb3+Wfx1Bfr8qcGgdFdAxsPVeH9oCtHb0=;
 b=tTlAiU8d9eJvx/hJRRXL8uapDrOpn3NB8omInptNN4GqCWtdbqariz9QoGkw5HNLMckRceIhRg2Em5oZI2JJHNZLNJi97Soq6j9REUjW+O5qWszaBV4hPmpMb0m8rmT39wW5XotWVhWb1zboJ0S2oxh10QpuzUxOO7eXsD31wFV94CKZj7xHavN9a+yB9cBk6nBfuuDZ9uUzDvsCbFG4hA6fQUaTc87lKWnzi82RUCkE7yuhMAVL0YoWwgevEiusPBJhcAdnAzyqlw9LYCLH60gbsdJbJOGX1erwNr6aHiXUgi0BfdoRD97/V2XIyM983RZzAxsYFLVjOrBD6TfpyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z3k7PXi00zjb3+Wfx1Bfr8qcGgdFdAxsPVeH9oCtHb0=;
 b=WdwgkPnf8PlA1YA73gmiAnU6VJKe+ykpk1MRBmDCXXxQJ45i0elIhDhrXCktIsbYYs1Ylsm5szyzeYTBCG6htHNmUwQ3kKT0vfbmJeJwUYHWj4KBc4K2NMv+K4r6AtzWnJ4lp6Ps+fRg2flhr8RhCkrVJjbEZii3Y0EtQm/hvLY=
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com (2603:10a6:10:407::19)
 by AM7PR08MB5525.eurprd08.prod.outlook.com (2603:10a6:20b:107::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.15; Fri, 31 Jul
 2026 14:35:25 +0000
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e]) by DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e%5]) with mapi id 15.21.0270.012; Fri, 31 Jul 2026
 14:35:25 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>
CC: "maz@kernel.org" <maz@kernel.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"oupton@kernel.org" <oupton@kernel.org>, nd <nd@arm.com>
Subject: Re: [PATCH v4 34/48] KVM: arm64: gic-v5: Add VGICv5 IST save/restore
 UAPI
Thread-Topic: [PATCH v4 34/48] KVM: arm64: gic-v5: Add VGICv5 IST save/restore
 UAPI
Thread-Index: AQHdG1st6ZOC13q6KkSxrYLjad6E8bZ8jYMAgAsvawA=
Date: Fri, 31 Jul 2026 14:35:25 +0000
Message-ID: <517c91a503f86e3970227beba6ec78ad79ed1c9c.camel@arm.com>
References: <20260724104819.1296803-1-sascha.bischoff@arm.com>
	 <20260724104819.1296803-35-sascha.bischoff@arm.com>
	 <20260724114650.CF4381F000E9@smtp.kernel.org>
In-Reply-To: <20260724114650.CF4381F000E9@smtp.kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU0PR08MB8421:EE_|AM7PR08MB5525:EE_|AM1PEPF000252E1:EE_|DU0PR08MB9273:EE_
X-MS-Office365-Filtering-Correlation-Id: 7d0291d5-7c6e-4cd1-70b0-08deef111ab0
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|23010399003|1800799024|376014|38070700021|56012099006|10067099003|18002099003|22082099003|6133799003|5023799004|11063799006|4143699003|3023799007;
X-Microsoft-Antispam-Message-Info-Original:
 R0WxCVSnRZki8yYjcaSQpDnsfTP1C8LrNNd/lzObKP37OjyWemBBN04FkeuLBv07s6aoxpOGm5a0WV/EcEHTwAYl8UTGC/pCj/c0y1DFZ64+zHa2BBlpTL2zlwhTXA7nkCVw6txGDCvQRcmiEzBiiWf9eQF/slLsmF+j30yQ9+AbFiLB/noUG2fdy850Fz8xnJEpVbJ7I/Q680tin9lJ9hvXBhzdeR7uF5z9mWc1cOF/TYRLAN1+8m27crzM/u7wkLisXMqfsxYrnZjb9EEd8+NukM3B4eRYYaO25zT3L1IKwlGsHuiVgPb7QIRQ6u0qD2WOOgzG9aEspUf8MYovhEdf5LobVNMPXRIQH0Wgo69UpJ/j6Wst2jSrJvm4GljTciqepvK2q+NGH39r7SsujqjX8noJHO2qG/eusKWeJdw2DfRqksAagiNccqjFy4mgvk86jjm1RhIcWgXUTnmiu5fqtTsO6bbbvK3m3UB7k7RwACAL0jZw8+PhZ8p2K0UolcjVyTJDT20zrn9c6gKMWxOlPGe+PvuKWaHEAiYkMwiToJzay9DpOLmwW/5grST7qtf+KjeqkRFp4wV8e0NB82N5O7nly7v5g5yFLx7MGpc8mXtSuhX9YJG8iaoFPyOD07OjrFqzoGWg7WlDd5EpzF4NL5BGdp1c4QahdAQH5WsyYkZIb9oJVNEex5o0N5H2Es+uy0VqfoQ4Krn/Kfq1L/r9aZUC63eEom1MSgQF/z0=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB8421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(376014)(38070700021)(56012099006)(10067099003)(18002099003)(22082099003)(6133799003)(5023799004)(11063799006)(4143699003)(3023799007);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <52C8BC90A5C01B4FA68FB46C27C15797@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 JRdCeHrTRM2YhOgP4sJVnB2sHxIumQf4xgEHPeVWmTws88hdQEi5TdT1EvIYmPKsm/X+0fEk16lyQvW/mEF+qKUEuIMGaH8Xn1txfDnSqTYwFKDDfgLb4Z2NyqrZJfSEZByO3K6N/Rp7RY7AWQWb0hM9wrgModrQylFjXsQp5AXebayXdRj9uk+ssSTQBgHt5NR5AzBBF//X9FeqE4u7JhNo9rsUGc31+5/0Agrc/eOvknYgC2e/BUtuJ8EkAnSKA6/zjfLzTBMb1r9HVYGb524smr8VghaE+gXWJOl56B6mCKKyrrL34AB8ZLpprhlioD2SVOffrJ0hNXK7IEaHZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR08MB5525
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM1PEPF000252E1.eurprd07.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	28c5fd93-ccb7-4c58-5fa8-08deef10f58f
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|14060799003|35042699022|36860700016|1800799024|376014|23010399003|6133799003|11063799006|5023799004|4143699003|56012099006|3023799007|18002099003|22082099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	V4xlE4FXzYwBVw3jTf/wrrbCnf++ZcrD9iho6fyFlwcsLJg/7OEx1b5G+1qGiQe5LOnfoDOml3j/hkMm9EUXu36fqn0aV37bH9AogoGIcKDIVawT0L0Q9pLgoVI87y1+eDGZ3AKlNPL24zn8w52Z6x84gQ/vQ9cwlwlG2zQcomccn2MghF3ZuJvW5DlFyoERtE+DwwlPFEr4enlzcGVAK4YNzMB9UQTjAq/r6AQmFfj8KgvpQDfJmgCfOE8E1nBIL8VSI7Fsxj8NKy0HtwF+MkQ8sbjp7l7dnwz734off9HBV36gnW/saMWTIACelQkjlqzAlqL9d9DzVe1wptbyJWU8+Yt7vqduP7be3x6UXrfkDe7j2c2DcuU1iaCblqZnta66EJZcvVvfmMKHuJzNQ6qzk/hCmWKRnWLeAnOlS/CcfVYqcp2W3W5J+upnHL0X+y0LIV+neJ70b4/9wEW0pA2AIyS6St77Qkm4pjvHNYO7xHeYhIc3yZBXQuEkYpmNAdMK58V3xAJfcb/qbq1ke1Pe7kl2AI9Jkp5724DiTETL+cPp8xON71l4eZLMOKQf00t2Rb38GjDo3ZYW8xf1skMLqDqbMu+Q8QTUkcQHUlQC18trqysHsy710T2hGyNuTFPJmZwKtp7xzSi3jlt8eRD2aQxKvIsuLS5xD5/O/FKCxteD5rFBsJTxDk/UX96GyUFR6Lv+/5EjUd476YvRpA==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(14060799003)(35042699022)(36860700016)(1800799024)(376014)(23010399003)(6133799003)(11063799006)(5023799004)(4143699003)(56012099006)(3023799007)(18002099003)(22082099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	9tik7L9X7Mnee8s09mH8m9+Td958VJzayXPQqTFHzWqJOuj3UZVDc08aEmhKDqSbYGqtU7qbgvWP42Hg9wlpsAggytErRX2ulMcYafRo+zbz5mAT5ZdYUV6v7sA8iFaUG4Bwdqq2do1Tifmwhc5N1mNuGYF2T8t1H6mSxxgigQDbz57ate43TExOg0ILkQcKA8c1/uihu5IGcevbFnsTEJkQf3s+ltW05Y4PUR/cH0zm9jsFS/gCOMJ4yfYfMBTqLOdE0gz0qPnnwGhQEG44c9KKsGKETXYFesz7NdECnH+6JuX7ANDxJ9SS9tDUVL+Rupxe1G+bEBzl5kjjURnTGuCIWrgCL5cYF0Oh5NqR4HgHoWBxsYByQipTwPlMJnW0dv/QKdL1pwpbTavaDO/5xJqtYDbMAE7+PlH7tiT9HGP3p90TBv2sxMY+Qanp6EUZ
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2026 14:36:27.3388
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d0291d5-7c6e-4cd1-70b0-08deef111ab0
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM1PEPF000252E1.eurprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB9273

T24gRnJpLCAyMDI2LTA3LTI0IGF0IDExOjQ2ICswMDAwLCBzYXNoaWtvLWJvdEBrZXJuZWwub3Jn
IHdyb3RlOg0KPiBUaGFuayB5b3UgZm9yIHlvdXIgY29udHJpYnV0aW9uISBTYXNoaWtvIEFJIHJl
dmlldyBmb3VuZCAzIHBvdGVudGlhbA0KPiBpc3N1ZShzKSB0byBjb25zaWRlcjoNCj4gLSBbTWVk
aXVtXSBUaGUgS1ZNIGltcGxlbWVudGF0aW9uIGZvciB0aGUgbmV3bHkgYWRkZWQgVkdJQ3Y1IElT
VA0KPiBhdHRyaWJ1dGUgZ3JvdXAgaXMgZW50aXJlbHkgbWlzc2luZy4NCj4gLSBbTG93XSBUaGUg
QVJNLXNwZWNpZmljIGBzdHJ1Y3Qga3ZtX3ZnaWNfdjVfaXN0YCBpcyBhZGRlZCB0byB0aGUNCj4g
Y3Jvc3MtYXJjaGl0ZWN0dXJlIGBpbmNsdWRlL3VhcGkvbGludXgva3ZtLmhgIGluc3RlYWQgb2Yg
dGhlDQo+IGFyY2hpdGVjdHVyZS1zcGVjaWZpYyBgYXJjaC9hcm02NC9pbmNsdWRlL3VhcGkvYXNt
L2t2bS5oYCwgcG9sbHV0aW5nDQo+IHRoZSBnbG9iYWwgVUFQSSBuYW1lc3BhY2UgYW5kIGNhdXNp
bmcgYSB0b29scyBoZWFkZXIgZGVzeW5jLg0KPiAtIFtMb3ddIFRoZSBuZXcgYEtWTV9ERVZfQVJN
X1ZHSUNfR1JQX0lTVGAgZGV2aWNlIGF0dHJpYnV0ZSBncm91cCBhbmQNCj4gaXRzIGRlc2NyaXB0
b3Igc3RydWN0dXJlIGFyZSBjb21wbGV0ZWx5IHVuZG9jdW1lbnRlZC4NCj4gLS0NCj4gDQo+IC0t
LSBQYXRjaCBbMzRdOiBbUEFUQ0ggdjQgMzQvNDhdIEtWTTogYXJtNjQ6IGdpYy12NTogQWRkIFZH
SUN2NSBJU1QNCj4gc2F2ZS9yZXN0b3JlIFVBUEkgLS0tDQo+IGNvbW1pdCAxOGE0NzVmMjE0ZmVl
YzY3MzA1NWE3MTJhNWI2ZDg0NGFhOWVkYjFhDQo+IEF1dGhvcjogU2FzY2hhIEJpc2Nob2ZmIDxT
YXNjaGEuQmlzY2hvZmZAYXJtLmNvbT4NCj4gDQo+IEtWTTogYXJtNjQ6IGdpYy12NTogQWRkIFZH
SUN2NSBJU1Qgc2F2ZS9yZXN0b3JlIFVBUEkNCj4gwqDCoMKgIA0KPiBBZGQgdGhlIFZHSUN2NSBJ
U1QgZGV2aWNlIGF0dHJpYnV0ZSBncm91cCB1c2VkIGJ5IHVzZXJzcGFjZSB0byBzYXZlDQo+IGFu
ZCByZXN0b3JlIHRoZSBJUlMgSW50ZXJydXB0IFN0YXRlIFRhYmxlcy4gSXQgaW50cm9kdWNlcyB0
aGUNCj4ga3ZtX3ZnaWNfdjVfaXN0IGRlc2NyaXB0b3Igc3RydWN0dXJlIGZvciBTUEkgYW5kIExQ
SSBJU1QgYnVmZmVycy4NCj4gDQo+ID4gZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQvaW5jbHVkZS91
YXBpL2FzbS9rdm0uaA0KPiA+IGIvYXJjaC9hcm02NC9pbmNsdWRlL3VhcGkvYXNtL2t2bS5oDQo+
ID4gaW5kZXggNzEwYTBkMjY3MzQ3ZC4uMWI5YmJlYWIxOGE0ZSAxMDA2NDQNCj4gPiAtLS0gYS9h
cmNoL2FybTY0L2luY2x1ZGUvdWFwaS9hc20va3ZtLmgNCj4gPiArKysgYi9hcmNoL2FybTY0L2lu
Y2x1ZGUvdWFwaS9hc20va3ZtLmgNCj4gPiBAQCAtNDIzLDYgKzQyMyw3IEBAIGVudW0gew0KPiA+
IMKgI2RlZmluZSBLVk1fREVWX0FSTV9WR0lDX0dSUF9JVFNfUkVHUyA4DQo+ID4gwqAjZGVmaW5l
IEtWTV9ERVZfQVJNX1ZHSUNfR1JQX01BSU5UX0lSUcKgIDkNCj4gPiDCoCNkZWZpbmUgS1ZNX0RF
Vl9BUk1fVkdJQ19HUlBfSVJTX1JFR1MJMTANCj4gPiArI2RlZmluZSBLVk1fREVWX0FSTV9WR0lD
X0dSUF9JU1QJMTENCj4gDQo+IFtTZXZlcml0eTogTWVkaXVtXQ0KPiBUaGUgY29tbWl0IG1lc3Nh
Z2Ugc3RhdGVzIHRoaXMgYXR0cmlidXRlIGdyb3VwIGlzIHVzZWQgYnkgdXNlcnNwYWNlDQo+IHRv
IHNhdmUNCj4gYW5kIHJlc3RvcmUgdGhlIElSUyBJbnRlcnJ1cHQgU3RhdGUgVGFibGVzLiBJcyB0
aGUgYmFja2VuZA0KPiBpbXBsZW1lbnRhdGlvbiBmb3INCj4gdGhpcyBuZXcgVUFQSSBpbnRlbnRp
b25hbGx5IG9taXR0ZWQgZnJvbSB0aGlzIHBhdGNoPw0KDQpZZXMuIENvbWluZyBpbiBvbmUgb2Yg
dGhlIG5leHQgb25lcy4NCg0KPiANCj4gV2l0aG91dCB0aGUgY29ycmVzcG9uZGluZyBLVk0gVkdJ
QyBkZXZpY2Ugb3BzIGluIHRoZSBjb2RlYmFzZSB0bw0KPiBwYXJzZSB0aGUNCj4gYXR0cmlidXRl
LCB0aGlzIFVBUEkgY3VycmVudGx5IGFwcGVhcnMgdW51c2FibGUuDQo+IA0KPiBbU2V2ZXJpdHk6
IExvd10NCj4gSXMgdGhlcmUgYSBtaXNzaW5nIGRvY3VtZW50YXRpb24gdXBkYXRlIGZvciB0aGlz
IG5ldyBndWVzdC12aXNpYmxlDQo+IGZlYXR1cmU/DQo+IA0KPiBLZXJuZWwgZ3VpZGVsaW5lcyB0
eXBpY2FsbHkgZXhwZWN0IG5ldyBVQVBJIGFkZGl0aW9ucyB0byBiZQ0KPiBleHBsaWNpdGx5DQo+
IGRvY3VtZW50ZWQuIFRoaXMgcGF0Y2ggb21pdHMgdXBkYXRpbmcgdGhlIEtWTSBkZXZpY2UgZG9j
dW1lbnRhdGlvbiB0bw0KPiBleHBsYWluDQo+IHRoZSB1c2FnZSBzZW1hbnRpY3MsIGV4cGVjdGVk
IGFsaWdubWVudCwgYW5kIGxpZmVjeWNsZSBjb25zdHJhaW50cw0KPiBmb3IgdGhlDQo+IFZHSUN2
NSBJU1QgYXR0cmlidXRlLg0KDQpUaGlzIGlzIHF1aXRlIGV4dGVuc2l2ZWx5IGRvY3VtZW50ZWQg
aW4gYW4gZXhwbGljaXQgZG9jdW1lbnRhdGlvbg0KcGF0Y2hlcyBmb3IgdGhpcyBzcGVjaWZpYyBV
QVBJLg0KDQo+IA0KPiA+IMKgI2RlZmluZSBLVk1fREVWX0FSTV9WR0lDX0xJTkVfTEVWRUxfSU5G
T19TSElGVAkxMA0KPiA+IMKgI2RlZmluZSBLVk1fREVWX0FSTV9WR0lDX0xJTkVfTEVWRUxfSU5G
T19NQVNLIFwNCj4gPiDCoAkJCSgweDNmZmZmZlVMTCA8PA0KPiA+IEtWTV9ERVZfQVJNX1ZHSUNf
TElORV9MRVZFTF9JTkZPX1NISUZUKQ0KPiA+IGRpZmYgLS1naXQgYS9pbmNsdWRlL3VhcGkvbGlu
dXgva3ZtLmggYi9pbmNsdWRlL3VhcGkvbGludXgva3ZtLmgNCj4gPiBpbmRleCA0MTkwMTEwOTdm
YThlLi5kZjYzNTZmYjQ1YjA4IDEwMDY0NA0KPiA+IC0tLSBhL2luY2x1ZGUvdWFwaS9saW51eC9r
dm0uaA0KPiA+ICsrKyBiL2luY2x1ZGUvdWFwaS9saW51eC9rdm0uaA0KPiA+IEBAIC0xMTkxLDYg
KzExOTEsMTMgQEAgc3RydWN0IGt2bV9kZXZpY2VfYXR0ciB7DQo+ID4gwqAJX191NjQJYWRkcjsJ
CS8qIHVzZXJzcGFjZSBhZGRyZXNzIG9mIGF0dHIgZGF0YQ0KPiA+ICovDQo+ID4gwqB9Ow0KPiA+
IMKgDQo+ID4gK3N0cnVjdCBrdm1fdmdpY192NV9pc3Qgew0KPiANCj4gW1NldmVyaXR5OiBMb3dd
DQo+IFNob3VsZCB0aGlzIEFSTS1zcGVjaWZpYyBzdHJ1Y3R1cmUgYmUgcGxhY2VkIGluIHRoZSBh
cmNoaXRlY3R1cmUtDQo+IHNwZWNpZmljDQo+IGhlYWRlciBhcmNoL2FybTY0L2luY2x1ZGUvdWFw
aS9hc20va3ZtLmggaW5zdGVhZCBvZiB0aGUgZ2xvYmFsDQo+IGNyb3NzLWFyY2hpdGVjdHVyZSBp
bmNsdWRlL3VhcGkvbGludXgva3ZtLmg/IA0KPiANCj4gQWRkaXRpb25hbGx5LCB3aGlsZSB0aGUg
cGF0Y2ggdXBkYXRlcyB0aGUgdG9vbHMgY29weSBvZiB0aGUgYXJtNjQNCj4gVUFQSQ0KPiBoZWFk
ZXIsIGl0IGFwcGVhcnMgdG8gbWlzcyBzeW5jaW5nIHRoZSB0b29scyBjb3B5IG9mIHRoZSBnbG9i
YWwNCj4gaGVhZGVyDQo+ICh0b29scy9pbmNsdWRlL3VhcGkvbGludXgva3ZtLmgpLiBEb2VzIHRo
aXMgb21pc3Npb24gbGVhZCB0byBhIHRvb2xzDQo+IGhlYWRlcg0KPiBkZXN5bmMgd2FybmluZz8N
Cg0KQWgsIHllcy4gSSBkaWQgcHV0IHRoYXQgaW50byB0aGUgd3JvbmcgaGVhZGVyLiBIYXZlIG1v
dmVkIGl0IHRvIHRoZQ0KYXJtLXNwZWNpZmljIGhlYWRlci4NCg0KPiANCj4gPiArCV9fdTY0CXNw
aV9pc3RfYWRkcjsNCj4gPiArCV9fdTY0CXNwaV9pc3Rfc2l6ZTsNCj4gPiArCV9fdTY0CWxwaV9p
c3RfYWRkcjsNCj4gPiArCV9fdTY0CWxwaV9pc3Rfc2l6ZTsNCj4gPiArfTsNCj4gPiArDQo+ID4g
wqAjZGVmaW5lwqAgS1ZNX0RFVl9WRklPX0ZJTEUJCQkxDQo+IA0KPiBbIC4uLiBdDQo+IA0KVGhh
bmtzLA0KU2FzY2hhDQo=
