Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=2 smtp.remote-ip=52.101.69.28
ARC-Seal: i=3; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795495387;
	b=2/eGFKnYPLqoz1yVGp+49f1S1GqbDKjKQKAeblK6O/NCrBf425A0GTdpR7C7uaKOMCVF
	 z6HgMX6cd91KscBYUh/V1l+2UhfZCdZ5TvF87Y/rq+404SHZzGluYP6YBlWZc559vDJgW
	 JUOCUBHZj8ThJObqSxeqlQ5WTWmrAEoUp7CSX5Lr5i0gdhO9vrUDQCEeCkbJPuC/oP79j
	 cr33zOfy/N67Q9lYqfU6VDlg7HKr+XOAmoqjy1vQMxLF0aZvZOc2igTuMpplRq8XR7PEE
	 ulyLXSOMcOuiigvasnqlJawTna8qBxPQsXuXv5jNKBSTiRW1L+Sh0YKJejM/9KvFpmA==
ARC-Message-Signature: i=3; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795495387;
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
	bh=eay24BPjs9NOnuCX6oWW8h3C5k8/F0JEcFsciEVAsPM=;
	b=Nqbdjcgh2uP7uExRX6rT6OikdEPCd4C2ZSVOxDp2HsGQgq4Hhafm21ociPtWh+c5fCt9
	 BzIDjRfWlDUX16y5vJeAbDOuR+rX2IDnDKCuHkW9JnM2mznsu2eyu1i95Mz1qXu9490qw
	 Ge6dmugGkQQELtGsFGHv+tcipTcTRjKnJXVfB5TUcNcPiFvBuseruF/FQq5f+DKqtRRDR
	 lRgKsRW96N81E8YzUSW9TF+RsqauFhNUoJsV5RKJ6Lqg+WiQLjtdU2PQ9FLwbHul5wXF1
	 fF29NLGGKjPtjhfKeQ8mx1ymjzoBE7V1U1G1QM80ngaduWav0rLA85hI1iYBh+yw3Ug==
ARC-Authentication-Results: i=3; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=selector1 header.b="Rk08KB/a";
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=selector1 header.b="Rk08KB/a";
	arc=pass header.oldest-pass=2 smtp.remote-ip=52.101.69.28
Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010028.outbound.protection.outlook.com [52.101.69.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 135BB606A330;
	Tue, 24 Nov 2026 04:43:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 135BB606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=selector1 header.b=Rk08KB/a;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=selector1 header.b=Rk08KB/a
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=QZIPxb27zFsYLA2l3e7YCdwc7eSHdP6J2lheQs1aO+vmrLS5wQ8UD6QHDjJ6gs0dwt0fdBpxJ9ivjMj6U63W8kAsgPAlxeHIAq/uSV27lzfnnlBLuURrB47JTlqF9BfbWrBcYRMNHL2k1L/eRmoPKsZXsK7YwLMy6exalbfgHOYlRIpnGR2mNjEQ/2sDxvwt7G7VnPgTeObBLKwq/sTxo7ys/piWY6skmxWhkmelzQ8l/gEVZRxEUtyeLZ6WZyPJnM/lt1oTWzbu3lUfkAJ8Qo/DMVtJwc8Gz1ogTeSik5IIPp7w3NEoe/bnf91ZxwbhNohYUKatjw3xwY+jwCY28g==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eay24BPjs9NOnuCX6oWW8h3C5k8/F0JEcFsciEVAsPM=;
 b=aAnwzpYe/obvZJqUJzJP37EGdm7lYEKd7VifXIkdxkOHA5gNL4hQzqXr9P4pfQTgIXrqHTZQ/HCYeoZsANXmXXwlaWQqA0hdhDq1d1+hYtfZ8j67sR2utrWhufgyHd9xuQT6Ka9TsIAH3S/N4hH40d6nVtgm/SnK+FDiJ8LSqC07/R2c/gjo4hiV5CkLAUedwOysm51e0ZSNeF+ilHPvBXU9IkCYAce0l3s4hwqw2OhyY0Vggkee59cHnMvuk+y6jlyJFqBJFST5FhhSYLhnBM1X5JjpzkkKOv7LCP0TETsJ4kS9PK/Jxij5AvBC32FNPsRfnx2kF0Uou7rEJwU25g==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eay24BPjs9NOnuCX6oWW8h3C5k8/F0JEcFsciEVAsPM=;
 b=Rk08KB/aLkeQ5ByEz0vhsWGdn8HdZymiNMgqDXJuP1mZbPVWvz4lhKLT+9+Xs3e3aD8j9RDXM2SSzA48MPM2xHKLLQCJ8vg+74zJK8O3uOku6FeOfsUK0RDILYOpAgdl46YifN7ncrU7iX476exf548OJtSEVT0+lGRce4PTZEo=
Received: from AM6P195CA0089.EURP195.PROD.OUTLOOK.COM (2603:10a6:209:87::37)
 by DU0PR08MB8908.eurprd08.prod.outlook.com (2603:10a6:10:464::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.14; Tue, 24 Nov
 2026 04:42:59 +0000
Received: from CPH1EPF00000525.eurprd05.prod.outlook.com
 (2603:10a6:209:87:cafe::83) by AM6P195CA0089.outlook.office365.com
 (2603:10a6:209:87::37) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.639.14 via Frontend Transport; Tue,
 24 Nov 2026 04:42:59 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 4.158.2.129) smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 CPH1EPF00000525.mail.protection.outlook.com (10.167.241.136) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.662.3
 via Frontend Transport; Tue, 24 Nov 2026 04:42:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nwbnAKi/gJk/RyOWo//FITarfRiPnJ8nfU/rbuI9OjC/nVdn4RA6dzNTMwIDNRX9vBNh4pzwkD2nwXP8K2skTYMNHVFgrp3PbfAwnMHeXeRf7VRlQA06/6KMFHGx+umO6Fz0rK5fHSWbM6h0l/a4ujwEWe7mMjWF9yl3pQ7KISiNsNneDdRoodjFM94be7RgAKxjUJA703T0n7NTUviDBRqwHX+h05pTkVWTiHt/PQv49fxi6ZirCe317/H45AClgFVTkhim844AKCK97XX8dZuD4I+e0eEye2cKIkDVg8vJ1I/0kWVE0g8EzHHY6TT6hjk7HLn8IgU2Jn7ZU5z7lQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eay24BPjs9NOnuCX6oWW8h3C5k8/F0JEcFsciEVAsPM=;
 b=AaWY5nEkH0MbALATEiSIECki4yx/8BKV/TqLq4bK+ti0P1MQkw743HO0OD0DHpX9Qhr0r2wYyZ71BIj5nEawoA+H0ugjePmA69Bb4cO9favByNzOOwKJmDzi1PAxg803gRNH/4UF7rS7zqpyzO8clfhhYis6GB4HSt8+qX0RcHeS8ZvtoBeVOxd675zmZUf1iOCfpM0fMtFFori/XImMbAhTuftnXQsSRzPxt3UwvhZoALQYthpFCAr6KY/Rqa5T9uL75cxfIxjIfxzKYEKlyrfyOYN5Dx5zWloEZBe4keoDTCstQvmRkkKIO3Xe/DPWIXq8bDlkhB7yunjZ2rFwTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eay24BPjs9NOnuCX6oWW8h3C5k8/F0JEcFsciEVAsPM=;
 b=Rk08KB/aLkeQ5ByEz0vhsWGdn8HdZymiNMgqDXJuP1mZbPVWvz4lhKLT+9+Xs3e3aD8j9RDXM2SSzA48MPM2xHKLLQCJ8vg+74zJK8O3uOku6FeOfsUK0RDILYOpAgdl46YifN7ncrU7iX476exf548OJtSEVT0+lGRce4PTZEo=
Received: from AS2PR08MB9786.eurprd08.prod.outlook.com (2603:10a6:20b:605::22)
 by AM9PR08MB5891.eurprd08.prod.outlook.com (2603:10a6:20b:2da::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.14; Tue, 24 Nov
 2026 04:42:24 +0000
Received: from AS2PR08MB9786.eurprd08.prod.outlook.com
 ([fe80::d721:dfdb:2f83:155]) by AS2PR08MB9786.eurprd08.prod.outlook.com
 ([fe80::d721:dfdb:2f83:155%6]) with mapi id 15.21.0639.012; Tue, 24 Nov 2026
 04:42:24 +0000
From: Justin He <Justin.He@arm.com>
To: "sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>
CC: "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, Oliver Upton
	<oupton@kernel.org>, Marc Zyngier <maz@kernel.org>
Subject: RE: [PATCH] KVM: arm64: nv: Allow the L1 VNCR page in cacheable
 PFNMAP memory
Thread-Topic: [PATCH] KVM: arm64: nv: Allow the L1 VNCR page in cacheable
 PFNMAP memory
Thread-Index: AQHde78UgIYonkM4fkaRTRN5l99S9rc8iqkAgAAW/bA=
Date: Tue, 24 Nov 2026 04:42:23 +0000
Message-ID:
 <AS2PR08MB97863F01CF45618DE8E0E63CF7442@AS2PR08MB9786.eurprd08.prod.outlook.com>
References: <20261124025336.4107575-1-justin.he@arm.com>
 <sashiko-outbox-230439@kernel.org>
In-Reply-To: <sashiko-outbox-230439@kernel.org>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Authentication-Results-Original: mx.microsoft.com 1; dkim=none (message not
 signed) header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS2PR08MB9786:EE_|AM9PR08MB5891:EE_|CPH1EPF00000525:EE_|DU0PR08MB8908:EE_
X-MS-Office365-Filtering-Correlation-Id: 1a117cef-9cb8-4eb8-8524-08df49e569e0
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|23010399003|1800799024|38070700021|10067099003|4143699003|11063799006|56012099006|261022075727099003|261021121427099003|261022105027099003|261026121527099003|261028144727099003|261102123227099003|261026140227099003|261009223027099003|18002099003|6133799003|22082099003|3023799007;
X-Microsoft-Antispam-Message-Info-Original:
 Pr6vJhPddvxZlPCCbXXQPFk3GytvxzRXB5VhK3Z9rTEBFilSaylEonkHFnZMH9YL+Sg4bjqwkfil+eXptDyPI2wMqLYlUGIVZNQzmT/q0JVTSvuWKrHsmIc0U3z85r5Cj7x1P7zQWjVxPPQYvYxj3OePY623OuKl7akS547FAy3SpQy+/bjWEDNJg2IX2WPv4Z1ct/v1a3m5IXKSg/MwdF3rneT2/j3wVCBfbhd1Cmn/AsOujw/gy+5P+gTRG6Zs2UEvyLp0G4rANSGGJeAvCIGb2E1zSbyQDvOkg7hlLxMZOtgquJFXp7LWavWmZ6DZ5WUbsYBJe8vBW6Td5sjZGjcdLbhCPpySTJQxL+gFldPfTKG8XNpuduzHb6ZVnTB0AntSY6dIV0OCmNWh01VrIkrEoGI0TZPA/SsAoJnagyDtYxb7+Kww56Thngj/VJhv36PFSiUFnG9Wrde3nD7OtTVRMLURr8FDBtkJ421qr2vt+ZOwPxe9EHAToIwh5GXIMk/TCpo+ZmbcDCxzVltFabp5uzjYd2qgJJXSlikKsNbx3hL9jccZMUCBbO5l18xeIiil2ubDzyTBpBD4x3gN7KVTDILewPe187VttMtwuq9dcijYn0oRCmZRzZcK+0be+mN/jqI6Wykmu48vNH9Ev0lLW2XdMFVUwNjRRw3Sf8k=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS2PR08MB9786.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(23010399003)(1800799024)(38070700021)(10067099003)(4143699003)(11063799006)(56012099006)(261022075727099003)(261021121427099003)(261022105027099003)(261026121527099003)(261028144727099003)(261102123227099003)(261026140227099003)(261009223027099003)(18002099003)(6133799003)(22082099003)(3023799007);DIR:OUT;SFP:1101;
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
 ZIspXdUnzeSIY8ezgq53vUbRBgpZj3OWe/ooxr5NxlE24S0nj8HEkDLVFElE8iVHCNA/7TE6tYU3GiO7M+Tq4Uj9JvaPOsnwOtqpHIOKYfmxbMHQ0DEEjhxWRVqKMBmnMuWP8cgKGQSD9pkSSEUSElE6FxrmGo/yidaun/61fYF1qyNfYbSIPPMDw+0kFuYy2r13fGR3ccNzHAzsXVPaJepSMtzlZRO98+/9kQIjSWKBvzK8HfFqh2z6XqltXgAdHrANDHcMvr5MBG7HMvpL3IxCNWVaLJCUBkYy4jXWX6mZ/c0EgA+t+0GtFO8STkB4yqPo6IBadDDlMX8MRUf9Ag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR08MB5891
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 CPH1EPF00000525.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	29cf1946-2358-46b7-514f-08df49e55589
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|376014|14060799003|36860700016|23010399003|1800799024|82310400026|10067099003|4143699003|11063799006|56012099006|261022075727099003|261021121427099003|261022105027099003|261026121527099003|261028144727099003|261102123227099003|261026140227099003|261009223027099003|18002099003|6133799003|22082099003|13003099007|3023799007;
X-Microsoft-Antispam-Message-Info:
	Kp6VM0fQVaSdnkuYtbw/2s4OfyI2ZOnw1P4ySre1gMGWDOe9kPPsJqIywMXpktLc710EW7YAy4ZQaBvEV/WUa0Q/AjtcMGhPQBAUTT+bAcIKyx9WwHAJ7yFzVTKfsIkCWDve3lxtyOSyUQlDRvsYm1QFpUaRRocPUVvPxoSDPidwQoH4qZfHpVefMtJ5mMrhwubA774555SMdhlpTQG7uAKWKddajBMzPllfNbwd+eNtNmU718DbFeL4rMznDwD+VBCKaAg6nFxRlQ+ITkoeP7e44K1CvoaJ7+nfzIKUgIgU00azhhJKrwPVH1QVuV+8D+htdtCizyI2A8vpV4ilMsO4uDwlUlQ75mZtWFAIoPInAZLYuIbCZWS9jbG7pYajcdzrwU4Fu0cx5O21awtoPwlHtNnmLi0bMnklOGusSYtIiFPhSf+8Rf3Wpi0yRcURLWrKTa6j0gu/QGQ978L0+1LW+cPdMBRlPnaqeqKEPQ1kr1zEL1ZyGs58x3c2/faNa6l39xFlKgNcKuOQELYdOpZpI7WAO8ugIubN7OojdvWJUQm0ocbOod7a4rds2yEmkc3pKjdKq5X/SnfTVTZad6brXEFAv/sNtMfJLTD6o3DFE0sPiWeDDiKfztV3upDWsdzoS66G3gHRwVTVgWdjcA==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(376014)(14060799003)(36860700016)(23010399003)(1800799024)(82310400026)(10067099003)(4143699003)(11063799006)(56012099006)(261022075727099003)(261021121427099003)(261022105027099003)(261026121527099003)(261028144727099003)(261102123227099003)(261026140227099003)(261009223027099003)(18002099003)(6133799003)(22082099003)(13003099007)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	AqhBPdXUGl25dTTLEAOxH/Rg/tIcf1ovCRbz1KIuKCUcH1BpVNETRnU0Ri7KueKn5c4s4+u1i1/b/7130TpD1eiVcuvhX8d4KXisbvJg26uUqeyDu3zZ3rh5RhApbNY6gl9vpNwBLgd/EIDRUPmoolKpqFeeWoGKBJKXbHZP2yQcg8v9rDm6sjRm6cQX72YYC70HyHFjVw7V5wgUwksCnKBQEp4EgIdxDii1KEi6g3rqapb5K42HuUUj0EuRr2UafoVAU5g1vyk7yG6CBm7CIbuh3XZHWZNKGUZb3N29O5+/n+1M852BwBtj77iCWDhjZssoc1mCAywbxwbpIqTjUFIcrS/Ph+nSSXqJ19SruTQM1G1MByMBUX8zBuDRPosoZs19xw1IiNd0P8tMTdcDXvYYu/9/OlDTd7mFAu2vSuO1yT7F5OjII7jlS18Na2Cf
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2026 04:42:58.0876
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a117cef-9cb8-4eb8-8524-08df49e569e0
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CPH1EPF00000525.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB8908



> -----Original Message-----
> From: sashiko-bot@kernel.org <sashiko-bot@kernel.org>
> Sent: Tuesday, November 24, 2026 11:08 AM
> To: Justin He <Justin.He@arm.com>
> Cc: kvmarm@lists.linux.dev; Oliver Upton <oupton@kernel.org>; Marc
> Zyngier <maz@kernel.org>
> Subject: Re: [PATCH] KVM: arm64: nv: Allow the L1 VNCR page in cacheable
> PFNMAP memory
>
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [Medium] KVM: arm64: nv: vncr_pfn_is_cacheable() rejects read-only
>   memslots
> It also noticed 1 related pre-existing issue this patch does not
> introduce:
> - [High] KVM: arm64: nv: unhandled -EPERM in kvm_handle_vncr_abort() [1]
> --
>
> commit 9fdd9f2ca0f89e14eb8d6921a8424af26dfde3e6
> Author: Jia He <justin.he@arm.com>
>
> KVM: arm64: nv: Allow the L1 VNCR page in cacheable PFNMAP memory
>
> This commit allows the L1 VNCR page to reside in a cacheable VM_PFNMAP
> or
> VM_MIXEDMAP VMA when the system supports cacheable PFNMAP
> mappings at
> stage-2, matching the stage-2 fault path.
>
> > diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> > index 78d5b18dbd2d6..85b97a888d71d 100644
> > --- a/arch/arm64/kvm/nested.c
> > +++ b/arch/arm64/kvm/nested.c
> > @@ -1561,6 +1561,36 @@ static u64 read_vncr_el2(struct kvm_vcpu *vcpu)
> >     return (u64)sign_extend64(__vcpu_sys_reg(vcpu, VNCR_EL2), 48);
> >  }
> >
> > +/*
> > + * Allow a non-memory PFN only if it comes from a cacheable
> VM_PFNMAP or
> > + * VM_MIXEDMAP VMA, as for a stage-2 mapping. The VMA is looked up
> after the
> > + * PFN has been faulted in: the caller must check mmu_invalidate_retry=
()
> > + * against a sequence count sampled before the fault-in.
> > + */
> > +static bool vncr_pfn_is_cacheable(struct kvm_memory_slot *memslot,
> gfn_t gfn,
> > +                             kvm_pfn_t pfn)
> > +{
> > +   struct vm_area_struct *vma;
> > +   unsigned long hva;
> > +   bool ret =3D false;
> > +
> > +   if (pfn_is_map_memory(pfn))
> > +           return true;
> > +
> > +   if (!kvm_supports_cacheable_pfnmap())
> > +           return false;
> > +
> > +   hva =3D gfn_to_hva_memslot(memslot, gfn);
> > +
> > +   mmap_read_lock(current->mm);
> > +   vma =3D vma_lookup(current->mm, hva);
> > +   if (vma && (vma->vm_flags & (VM_PFNMAP | VM_MIXEDMAP)))
> > +           ret =3D kvm_vma_is_cacheable(vma);
> > +   mmap_read_unlock(current->mm);
> > +
> > +   return ret;
> > +}
>
> [Severity: Medium]
> Does gfn_to_hva_memslot() reject a KVM_MEM_READONLY memslot here?
>
Indeed. gfn_to_hva_memslot() treats the lookup as a write and returns
KVM_HVA_ERR_RO_BAD for a read-only memslot. The VMA lookup then fails
and the guest hypervisor gets an SEA instead of a read-only VNCR
mapping. I reproduced the SEA with a VNCR page in a read-only cacheable
PFNMAP memslot. I am writing v2, using gfn_to_hva_memslot_prot(), as kvm_ha=
ndle_guest_abort() does.

> gfn_to_hva_memslot() assumes a write access and returns
> KVM_HVA_ERR_RO_BAD
> when the memslot is read-only.  On a read access to an L1 VNCR page in a
> read-only memslot backed by a cacheable VM_PFNMAP or VM_MIXEDMAP
> VMA,
> __kvm_faultin_pfn() faults in the PFN with writable =3D false, but
> vma_lookup() then looks up KVM_HVA_ERR_RO_BAD and returns NULL,
> causing
> kvm_translate_vncr() to inject an SEA instead of installing a read-only
> VNCR mapping as supported since 2684e02bac41 ("KVM: arm64: nv: Respect
> read-only PFN when mapping L1 VNCR").  Using __gfn_to_hva_memslot() (or
> gfn_to_hva_memslot_prot() as in kvm_handle_guest_abort()) would avoid
> failing on read-only memslots.
>
> > @@ -1633,12 +1663,7 @@ static int kvm_translate_vncr(struct kvm_vcpu
> *vcpu, bool *is_gmem)
> >             writable =3D !(memslot->flags & KVM_MEM_READONLY);
> >     }
> >
> > -   /*
> > -    * FIXME: This check is too restrictive as KVM allows cacheable
> memory
> > -    * attributes for PFNMAP VMAs that have cacheable attributes in hos=
t
> > -    * stage-1.
> > -    */
> > -   if (!pfn_is_map_memory(pfn)) {
> > +   if (!vncr_pfn_is_cacheable(memslot, gfn, pfn)) {
> >             kvm_release_faultin_page(vcpu->kvm, page, true, false);
> >             fail_s1_walk(&vt->wr, ESR_ELx_FSC_EXTABT, false);
> >             return -EINVAL;
>
> [Severity: High]
> This problem wasn't introduced by this patch, but can
> kvm_handle_vncr_abort() drop a pending SEA and loop forever when
> kvm_translate_vncr() returns -EPERM [1]?
>
Yes. Since bff8aa213dee, __kvm_at_swap_desc() returns -EPERM when the
descriptor is in a read-only memslot, and kvm_handle_vncr_abort() has
no case for it. The vCPU keeps taking the same VNCR abort. Only a guest
that puts its own EL2 stage-1 table in a read-only memslot is affected.
Will fix and send it separately in v2.

Thanks,
Jia He(Justin)

> When hardware Access Flag updates (TCR_EL2.HA) are enabled for guest
> EL2&0 and a stage-1 descriptor with PTE_AF =3D=3D 0 resides in a read-onl=
y
> memslot, walk_s1() -> kvm_swap_s1_desc() -> __kvm_at_swap_desc() fails
> with -EPERM and records ESR_ELx_FSC_SEA_TTW(level) in vt->wr.fst.
> Because the switch statement in kvm_handle_vncr_abort() does not include
> -EPERM in its fault-injection cases:
>
> arch/arm64/kvm/nested.c:kvm_handle_vncr_abort() {
>       ...
>       case -EFAULT:
>       case -EIO:
>       case -EHWPOISON:
>               if (is_gmem)
>                       return 0;
>               fallthrough;
>       case -EINVAL:
>       case -ENOENT:
>       case -EACCES:
>               /*
>                * Translation failed, inject the corresponding
>                * exception back to EL2.
>                */
>               esr &=3D ~ESR_ELx_FSC;
>               esr |=3D FIELD_PREP(ESR_ELx_FSC, vt->wr.fst);
>
>               kvm_inject_nested_sync(vcpu, esr);
>               break;
>       ...
> }
>
> KVM returns 1 without injecting the abort or mapping the VNCR page,
> trapping the vCPU in an infinite VNCR abort loop.
>
> [1] https://sashiko.dev/#/bug/linux-5a55db9b-f840-4142-8a1e-110e2882e8fa
>
> --
> Sashiko AI review * https://sashiko.dev/#/patchset/20261124025336.4107575=
-
> 1-justin.he@arm.com?part=3D1
IMPORTANT NOTICE: The contents of this email and any attachments are confid=
ential and may also be privileged. If you are not the intended recipient, p=
lease notify the sender immediately and do not disclose the contents to any=
 other person, use it for any purpose, or store or copy the information in =
any medium. Thank you.
