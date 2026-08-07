Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011060.outbound.protection.outlook.com [52.101.65.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77D8C34B669
	for <kvmarm@lists.linux.dev>; Fri,  7 Aug 2026 11:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.60
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786101473; cv=fail; b=TgkrWhyVuB4ufb2kI+mTb9AQUu/JmE0Sx/u3A8cjsLMyR5RKHwvGDeH4zMAoFmw9PhoEwZSnlOSH3f0GglzMT5yU/awl6k+RJlcCtx/xIrs6lCnlFJaAv8nvCbiGHgxs6PmqsqWte8H7mYSU4XC0HrIx332Uy1GyndlHOnnh4tA=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786101473; c=relaxed/simple;
	bh=Ox20t2x2przvsnAni2x40orfARKJWp9X+u9/UqdT4g8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=AUsJq/hu55Dyjm5R6DxJD654jYie++hDHrsYFFwnNdqa5tQUsyyBDt3eIOH0wDbLOaIRtKILTgQtW+F6GW3I230xl6/8u8jd/lOPJUxDVI86Mz1CkZmyHIhfXz+csnkRK3tvjBqka7Ir8C4Y6g+AKpVlj84hMMqFoSzFFZuIHmU=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=b01HKJ2X; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=b01HKJ2X; arc=fail smtp.client-ip=52.101.65.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="b01HKJ2X";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="b01HKJ2X"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=m277wpKLJz4v29TlscIFCf2+dK48rOMwSSTNkcqvUOvBaXYQ1Y0gzMQDBsav4MBWI5ypFu83zQUHrWevK4yWc8suiNx18pU3hw/LwRYAfX57Z6eaLNpR9DvecxxThMPYlMvEAQMW0sbGMasqhbclkU97rkXxgBcNT5H0nUSKthCkJyKbGybm8L0meZYZr8ZtlTXcQqEjWmxKQZpqldiDDDT+HH5V+Bfflmmc5O5OrG8OLgv9MU2ZwQD5FFiv1zu0fMNO3qzWmlz1OTE1UjicZAM8FVuY6VQ37ZxduQ3xf86KzzUWN5nqx2RveYaXJVDsV+0KO/D90KsL32O3/JazZw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QR7vPHCTAV4iPhzkPo3nfRoGLvjiHq1x2B/ZXDB8S6A=;
 b=g+b3vMJO6vQ8az0Kwv9qmu6UpVDGh89RI6PcH5j8z8E2M/mQjBvZusckTfy6hfXjL8UMSCSeATm5Re82Wyiv128zqmgrB6bfybEtSY+NXM13xR9LhaV3Tf19tZwKcY27+virityhh+Cpeh09xfbpX391HyYkagkUrBeks7qvxMXgG6s3Jpx/9iaj9kkAd6gxZ3Vqg6PQwL1vYBy/YJtkkU+DZLW/cfM7F08IO+L3RIxl4vn4EUetmy/guqlNw3cp53dT7wrkHxed4Za5ruWyRgIKsE2a/JVa8YPraFux8b88GpdfkjrSR8jA2ow0Cncqd3LCPf3wbby9poZsTBtDzA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QR7vPHCTAV4iPhzkPo3nfRoGLvjiHq1x2B/ZXDB8S6A=;
 b=b01HKJ2XqJPJtvSJzM2TZQABXUMMAUU17sY+40CIyG2DHOTrToxgd+xgrMiLWEFbMFq3+3zqIPTIlsKo4qIVIAQ5m1H002Oy1HXLDXgfNC7bAvYyv4OQhf+x/cUSC2zQamFOdE0WR4E8mOUMssr7kH8V8Ae2NdeS7WM6oRQK98Q=
Received: from DU2PR04CA0029.eurprd04.prod.outlook.com (2603:10a6:10:3b::34)
 by DB9PR08MB11403.eurprd08.prod.outlook.com (2603:10a6:10:60d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.21; Fri, 7 Aug
 2026 11:17:44 +0000
Received: from DU6PEPF00009529.eurprd02.prod.outlook.com
 (2603:10a6:10:3b:cafe::7b) by DU2PR04CA0029.outlook.office365.com
 (2603:10a6:10:3b::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.21 via Frontend Transport; Fri, 7
 Aug 2026 11:17:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU6PEPF00009529.mail.protection.outlook.com (10.167.8.10) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.6 via
 Frontend Transport; Fri, 7 Aug 2026 11:17:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=q1p4N4bRKCLvMz0LrzMQ1UOfE4mM+COGDNugYXTob4xKX/Gb1YlRggALOxP9vx8xVdCiShT1FcgOo/4wYd8i0DcYyeBzJ/Otp7TdbRZEB3NttFCsuzGmBdsGxWm6AQxB3mgNoV8/H3x+j6qQjzBg0JmfavKBB5c5B6OHh5mAishAvGOcb5B14HH5pTVAeEzHoDIvPkk2FTOhUZuE/mAex1j91ulVl1VQsweqOOHCTYaMjer1q7iC+zF39t8J49iZPDL5Sc3YMqnZZgyEP51LePDLo7xHfUS8G6vcM3YVqRoyI5iIRgWv+SmldMlfgu9S6zMgXNlKmMfoAwzAjBc40g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QR7vPHCTAV4iPhzkPo3nfRoGLvjiHq1x2B/ZXDB8S6A=;
 b=gZMgqq/bA5AOdFit2aZRvYJTJj+1j5kzeaKYgEI3ziLAiTPEsxA0cfU2MOswQqgAGuGeTFkJqMSq0HO36gEsD6lB39HCaX1f6dW94+QdI8TSoH6UwYt/vHmhb0XJTig3ySRN/zHcGrFxpmiTSQKr4WYYq1PBBABMobhKSS5JbSG8lRflIukPkAaoywlajt1GUrSi9IPiAorZNvMQk0zoQQK3RjGUaL9NhCKbw+B+3V7D+Gbd20VVxLHqVbFNto6k5J1lhbRLUWLFLdZ3wvfuQ5xI8/gBH1FacTxrzkTARGgtpJTLDthC3KDZwK8rw7qF58Tk4E2NvOJ0rl3Hvf/3Dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QR7vPHCTAV4iPhzkPo3nfRoGLvjiHq1x2B/ZXDB8S6A=;
 b=b01HKJ2XqJPJtvSJzM2TZQABXUMMAUU17sY+40CIyG2DHOTrToxgd+xgrMiLWEFbMFq3+3zqIPTIlsKo4qIVIAQ5m1H002Oy1HXLDXgfNC7bAvYyv4OQhf+x/cUSC2zQamFOdE0WR4E8mOUMssr7kH8V8Ae2NdeS7WM6oRQK98Q=
Received: from GV1PR08MB8428.eurprd08.prod.outlook.com (2603:10a6:150:81::5)
 by DB8PR08MB5356.eurprd08.prod.outlook.com (2603:10a6:10:f9::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.21; Fri, 7 Aug
 2026 11:17:11 +0000
Received: from GV1PR08MB8428.eurprd08.prod.outlook.com
 ([fe80::9b97:c973:3308:5ba7]) by GV1PR08MB8428.eurprd08.prod.outlook.com
 ([fe80::9b97:c973:3308:5ba7%5]) with mapi id 15.21.0292.018; Fri, 7 Aug 2026
 11:17:11 +0000
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
Subject: [PATCH v5 09/49] KVM: arm64: gic-v5: Create and manage VM and VPE
 tables
Thread-Topic: [PATCH v5 09/49] KVM: arm64: gic-v5: Create and manage VM and
 VPE tables
Thread-Index: AQHdJl5KRw/u74NHK0KVSRJtJtm9LA==
Date: Fri, 7 Aug 2026 11:17:11 +0000
Message-ID: <20260807111159.429128-10-sascha.bischoff@arm.com>
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
	GV1PR08MB8428:EE_|DB8PR08MB5356:EE_|DU6PEPF00009529:EE_|DB9PR08MB11403:EE_
X-MS-Office365-Filtering-Correlation-Id: 493b14d5-6232-4acc-307f-08def47580b0
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|366016|1800799024|23010399003|5023799004|56012099006|11063799006|10067099003|6133799003|3023799007|22082099003|18002099003|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 22dULup8jd8RFBDp/0LwZWDrkXAonGQqEHA8DznFG4Hi7OLdb31QJvUfTFGdHhfR1IVEZt9wDL/DLQMLBsvenpPdrnkwlgtmfhHGXKciiMCKEk6RTZbZa0IkDGTutmpFA7sTIx2k/4l2IBaPGWpzPYH7l64aVWWA5SBUPWfA2H3eoZODWsTXR++HYDWi6q1tZttQ6205Lb9Qv8AJZhOGcJXOWS7XFyKyXJ/12VBPoip1W/0GzBJYoWX04iWv9hD1uAFjTVrFP69qEWhWfi92Z/8sMlJBhATtwJFPK1s5Rkg4m/49L7xiPgRgYz+/liv16Gge/kvuObjh0mMP4/CHSR2Exk8tN/qxLGEs3UZe11k+n4DJ5YwEBP4ChwVVv3mRFFvbenO8H21SUlUcUkwIzORWGJ3RBg5nQfIPLAfDQ6qgeXdv5amIeguNPBQ+LUS34Yl8bDuF3i1ug9Cfi9PbI0tLMP95e34EHNGj//6bQezGWo99F/wMvg6Jxoa+dg6UezpLHH+KEnh862sG3R9mZRQN0f6QWw70KT6DfFN6hv2uAqpeJq40U3GqlAm42d8AxeBHWtBk/gnOrYMZTxpoHAC1Y7qHrgR3UrsT7uPSVO+JhKBo/fD9+kZtquaDSAJPpEuL3BqZxzhEjE6S6HmvLuOBdVWSBIeFlU9HkO1VOwmdmJWHZBI1b8y8NdPbCJA32LKRGi2hmyLbEJVbIoIiZ3qTCD+GSNHpIJAtvzYuigk=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB8428.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(23010399003)(5023799004)(56012099006)(11063799006)(10067099003)(6133799003)(3023799007)(22082099003)(18002099003)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 hvbfNOTv5aJ0vLhIQW1TdYTnJ/CbJqAl5lhFNM+WW4YGmfG98m/jALtcODVLlpaatL9e/ECYHimXklIW5tHTUzcxkM/NorYl53PGVuEmkfj1yTDTWpg4TIgHJ+6KRHuLX3I4DIFXoWU/GtggblxWFieSYa74satNQ7pVOoVUNYKkm4z7L+TQS/8+WLal0O86y5G5cdEjoUxMTlsnSIaejvvo+q21K8AoM/D8g/txd7/zjgAiGWW1s+YrJzqUO4e72lSeAx7WFlCw3/7P5W5cHfBsPan7BQGX0QfWqzwNkl/faiHI818OgKeH6NVJSkVKBsD/KAn9I8mCB/FFCbB02Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR08MB5356
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU6PEPF00009529.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	be057a46-ae4f-4c59-150d-08def4756d1b
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|36860700016|14060799003|23010399003|1800799024|82310400026|376014|5023799004|56012099006|11063799006|10067099003|6133799003|18002099003|22082099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	GITT1gNjTiQZVIztylcKN25xpmTO5dznMqU9he7heTMBZYrDIPyRo0ifK6/Q9QEMwwaELCCvgNVflDqyzQbgeINt6SIriNStA2MCQdFtBTO8kufDOWnVp+pM4YmN53q1BtkLzlJiU0cWfXgKxqkXOEZsLKWU43yuULtmHenFoXe/HKqTvrN7L2OZKRa/KjzFdqqecUz68slAOc8JxuRryRl19Uc0D/QJdJalq7nO3mH6CVkv+7XGJ6rsnMr3GmBooE9ULfNBV5ui/wVHAJRU9CR/EsBDLZ3QvLmqNU9BsKOIX++hRayM+FhNQjhZE4XX/netDDdg9rrNkkG/6ZeHCIkiHw6hZkUU/loEl7/aBXUFYNMqZ2k/6uV2I6+a+7jihQiRYEEl2vjsZhMGEEiChlwhWAT0IlTQGqnykgMhyBgrzc0Uhdf0ntragw9/d4DNGcsS0R36htzmxgfGv+Lo0r+MBltMpn+ZSPYP80mDf8Q/tswaJckRTBFGiDorAIppPASXkse63IQ34dEwikVIfRnlqkmdT1SfaewVqUZuecBk2kz1k7x3nC0MAzs5xfBrn/oJT5zQFAjlZ/FZdpBitX3zKQphrxEN/BoSnkrapTKrlFojr5soTmR+J/D/ui1xItEOsUxFQF+NZO8MADN6NlEzzywkGOvSH8Ra8LYHKuwwkNsCSfURJwNalWdzJzJPTs87+CZvgYtJGFGL4iV/Gw==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(36860700016)(14060799003)(23010399003)(1800799024)(82310400026)(376014)(5023799004)(56012099006)(11063799006)(10067099003)(6133799003)(18002099003)(22082099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	o4e3D+8YGsDcyiQnVmstUt+/qmRTS7j8NKlL/EJlO7AsxuMRxDIKph6f/Z6W6jOKtEv4rQvHgbKk6O3rU6QyljZP5USkXKoWSlNhAX90BDamS3JS2t/tBZSFGUkfUClZ15PK9bPdozJfdovcyjYLmFm/LaQInHyQ1yFqIGS39wHyjaPGFLjzFo2SMzePN1m9T3pnIVE8DNoovZurBbhTVrEPUROl2qfs8bVPJsp7kxgKrnsIRm0J8ybFyAhGVBUN9hkC6RM67oBup6Kqxbriin+DZq3hXYdvKOT1FH0tkznCGAB9mmw+BG8G+Y3e/txlifpkNQYmARnPD50k9jOGjbtg8FkRyc7pFZYkzpW4mZ+6bM+xsjUiZQvj5cXGnCdSbfZs1Ia5AL0MwsD7AXGN25/uscq0JrR9o1fVsPU7P9XL/26ES9gxNp7CoIr0Hjxv
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2026 11:17:43.9393
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 493b14d5-6232-4acc-307f-08def47580b0
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU6PEPF00009529.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB11403

GICv5 uses a set of in-memory tables to track and manage VM state.
These must be allocated by the hypervisor and provided to the IRS.

The VMT (Virtual Machine Table) is a linear or two-level table
comprising VMT Entries (VMTEs). Each VMTE describes the state for a
single VM. This state includes things such as the SPI and LPI IST
configuration (coming in a future commit), an implementation-defined
VM Descriptor, and a VPE Table (VPET).

The VPET contains one entry per possible VPE ID belonging to a VM. It
is used to mark a VPE as valid and provide the address of an
implementation-defined VPE Descriptor (VPED), which the hardware uses
to track and manage VPE state.

Allocate each VM's VPEDs as a single dense array indexed by vcpu_idx,
while the VPET remains indexed by the userspace-provided vcpu_id. This
keeps VPED storage proportional to the number of vCPUs even when their
IDs are sparse.

The VMT and VPET are shared with the IRS. On systems with a
non-coherent IRS, cache maintenance operates at cache-line
granularity, while multiple entries can occupy the same cache line.
Use a common lock for CPU accesses to these tables and IRS command
processing so that writing back one entry cannot overwrite an IRS
update to a neighbouring entry.

The implementation-defined VMD and VPED storage is also visible to the
IRS. Round these allocations up to whole cache lines to prevent cache
maintenance from corrupting unrelated slab objects. Initialise the
storage before publishing its addresses to the IRS.

This commit adds support for allocating the VMT and its descriptor
backing state, and for managing VMTEs. The VMTEs can be initialised or
released for reuse. VM IDs are allocated with an IDA, while an XArray
tracks the host-side allocations associated with populated VMTEs.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/Makefile              |   2 +-
 arch/arm64/kvm/vgic/vgic-init.c      |   2 +
 arch/arm64/kvm/vgic/vgic-v5-tables.c | 681 +++++++++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic-v5-tables.h | 100 ++++
 arch/arm64/kvm/vgic/vgic-v5.c        |  19 +
 drivers/irqchip/irq-gic-v5-irs.c     |  12 +-
 include/kvm/arm_vgic.h               |   4 +
 include/linux/irqchip/arm-gic-v5.h   |  14 +-
 8 files changed, 824 insertions(+), 10 deletions(-)
 create mode 100644 arch/arm64/kvm/vgic/vgic-v5-tables.c
 create mode 100644 arch/arm64/kvm/vgic/vgic-v5-tables.h

diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 59612d2f277c1..431de9b145ca1 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -24,7 +24,7 @@ kvm-y +=3D arm.o mmu.o mmio.o psci.o hypercalls.o pvtime.=
o \
 	 vgic/vgic-mmio.o vgic/vgic-mmio-v2.o \
 	 vgic/vgic-mmio-v3.o vgic/vgic-kvm-device.o \
 	 vgic/vgic-its.o vgic/vgic-debug.o vgic/vgic-v3-nested.o \
-	 vgic/vgic-v5.o
+	 vgic/vgic-v5.o vgic/vgic-v5-tables.o
=20
 kvm-$(CONFIG_HW_PERF_EVENTS)  +=3D pmu-emul.o pmu.o
 kvm-$(CONFIG_ARM64_PTR_AUTH)  +=3D pauth.o
diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-ini=
t.c
index 625d352756fcf..079a57c2b18f6 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -154,6 +154,8 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
 	case KVM_DEV_TYPE_ARM_VGIC_V3:
 		INIT_LIST_HEAD(&kvm->arch.vgic.rd_regions);
 		break;
+	case KVM_DEV_TYPE_ARM_VGIC_V5:
+		kvm->arch.vgic.gicv5_vm.vm_id =3D VGIC_V5_VM_ID_INVAL;
 	}
=20
 	/*
diff --git a/arch/arm64/kvm/vgic/vgic-v5-tables.c b/arch/arm64/kvm/vgic/vgi=
c-v5-tables.c
new file mode 100644
index 0000000000000..7252d48431a5a
--- /dev/null
+++ b/arch/arm64/kvm/vgic/vgic-v5-tables.c
@@ -0,0 +1,681 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2025, 2026 Arm Ltd.
+ */
+
+#include <kvm/arm_vgic.h>
+#include <linux/dma-mapping.h>
+#include <linux/kernel.h>
+#include <linux/mm.h>
+#include <linux/mutex.h>
+#include <linux/sizes.h>
+#include <linux/slab.h>
+#include <linux/xarray.h>
+#include <asm/kvm_mmu.h>
+
+#include "vgic.h"
+#include "vgic-v5-tables.h"
+
+#define irs_caps	kvm_vgic_global_state.vgic_v5_irs_caps
+
+static struct vgic_v5_vmt *vmt_info;
+
+/* Serialises IRS MMIO interaction (commands) and accesses to IRS tables. =
*/
+DEFINE_RAW_SPINLOCK(vgic_v5_irs_lock);
+
+/* Serialises lazy installation of shared second-level VMTs. */
+static DEFINE_MUTEX(vmt_l2_lock);
+
+static DEFINE_XARRAY(vm_info);
+
+/* Level 1 Virtual Machine Table Entry */
+#define GICV5_VMTEL1E_VALID		BIT_ULL(0)
+/* Note that there is no shift for the address by design */
+#define GICV5_VMTEL1E_L2_ADDR		GENMASK(51, 12)
+
+#define GICV5_VMTEL2E_SIZE		32ULL
+/* An L2 table (two-level VMT) is ALWAYS 4kB! */
+#define GICV5_VMT_L2_TABLE_SIZE		4096ULL
+#define GICV5_VMT_L2_TABLE_ENTRIES	(GICV5_VMT_L2_TABLE_SIZE / GICV5_VMTEL2=
E_SIZE)
+
+/*
+ * As the L2 VMTE is a large data structure, we are splitting it into 4 pa=
rts.
+ * We only mask and shift WITHIN each part for simplicity.
+ */
+/* First 64-bit chunk */
+#define GICV5_VMTEL2E_VALID		BIT_ULL(0)
+#define GICV5_VMTEL2E_VMD_ADDR_SHIFT	3ULL
+#define GICV5_VMTEL2E_VMD_ADDR		GENMASK_ULL(55, 3)
+/* Second 64-bit chunk */
+#define GICV5_VMTEL2E_VPET_ADDR_SHIFT	3ULL
+#define GICV5_VMTEL2E_VPET_ADDR		GENMASK_ULL(55, 3)
+#define GICV5_VMTEL2E_VPE_ID_BITS	GENMASK_ULL(63, 59)
+/* Third & fourth 64-bit chunks (the encodings are the same for each) */
+#define GICV5_VMTEL2E_IST_VALID		BIT_ULL(0)
+#define GICV5_VMTEL2E_IST_L2SZ		GENMASK_ULL(2, 1)
+#define GICV5_VMTEL2E_IST_ADDR_SHIFT	6ULL
+#define GICV5_VMTEL2E_IST_ADDR		GENMASK_ULL(55, 6)
+#define GICV5_VMTEL2E_IST_ISTSZ		GENMASK_ULL(57, 56)
+#define GICV5_VMTEL2E_IST_STRUCTURE	BIT_ULL(58)
+#define GICV5_VMTEL2E_IST_ID_BITS	GENMASK_ULL(63, 59)
+
+/* Virtual PE Table Entry */
+#define GICV5_VPE_VALID			BIT_ULL(0)
+/* Note that there is no shift for the address by design. */
+#define GICV5_VPED_ADDR_SHIFT		3ULL
+#define GICV5_VPED_ADDR			GENMASK_ULL(55, 3)
+
+/*
+ * Our IRS might be coherent or non-coherent. If coherent, we can just emi=
t a
+ * DSB to ensure that we're in sync. However, when non-coherent, we need t=
o
+ * manage our cached data explicitly.
+ *
+ * This helper is used to handle both coherent and non-coherent IRSes, and
+ * handles all combinations of cleaning and invalidating to the PoC.
+ */
+static void vgic_v5_clean_inval(void *va, size_t size)
+{
+	unsigned long base =3D (unsigned long)va;
+
+	dsb(ishst);
+
+	if (kvm_vgic_global_state.vgic_v5_irs_caps.non_coherent)
+		dcache_clean_inval_poc(base, base + size);
+}
+
+/*
+ * Create a linear VM Table. Directly using the number of entries supplied=
 as
+ * the size of an L2 VMTE (32 bytes) guarantees that our allocation is ali=
gned per
+ * the GICv5 requirements for the IRS_VMT_BASER.
+ */
+static int vgic_v5_alloc_vmt_linear(unsigned int num_entries)
+{
+	vmt_info->linear.vmt_base =3D kzalloc_objs(*vmt_info->linear.vmt_base,
+						 num_entries);
+	if (!vmt_info->linear.vmt_base)
+		return -ENOMEM;
+
+	vgic_v5_clean_inval(vmt_info->linear.vmt_base,
+			    num_entries * sizeof(struct vmtl2_entry));
+
+	return 0;
+}
+
+/*
+ * Allocate the first level of a two-level VM table. The second-level VM t=
ables
+ * are allocated on demand (by vgic_v5_alloc_l2_vmt()).
+ */
+static int vgic_v5_alloc_vmt_two_level(unsigned int num_entries)
+{
+	/*
+	 * Each L2 VMT array is always 4k-sized (covering 128 VMs). This is
+	 * mandated by the GICv5 specification (GICv5 EAC0 Specification rule
+	 * D_LSPBK). Hence, round up the number of entries to be at least 128
+	 * (or the next highest power of two as we give the HW the number of VM
+	 * ID bits).
+	 */
+	if (num_entries < GICV5_VMT_L2_TABLE_ENTRIES)
+		num_entries =3D GICV5_VMT_L2_TABLE_ENTRIES;
+	num_entries =3D roundup_pow_of_two(num_entries);
+
+	vmt_info->l2.num_l1_ents =3D (num_entries / GICV5_VMT_L2_TABLE_ENTRIES);
+	vmt_info->l2.vmt_base =3D kzalloc_objs(*vmt_info->l2.vmt_base,
+					     vmt_info->l2.num_l1_ents);
+	if (!vmt_info->l2.vmt_base)
+		return -ENOMEM;
+
+	vmt_info->l2.l2ptrs =3D kzalloc_objs(*vmt_info->l2.l2ptrs,
+					   vmt_info->l2.num_l1_ents,
+					   GFP_KERNEL);
+	if (!vmt_info->l2.l2ptrs) {
+		kfree(vmt_info->l2.vmt_base);
+		return -ENOMEM;
+	}
+
+	vgic_v5_clean_inval(vmt_info->l2.vmt_base,
+			    vmt_info->l2.num_l1_ents * sizeof(vmtl1_entry));
+
+	return 0;
+}
+
+/*
+ * Allocate a second level VMT, if required. This can be called eagerly, a=
nd
+ * will only perform the allocation if required.
+ */
+static int vgic_v5_alloc_l2_vmt(struct kvm *kvm)
+{
+	struct kvm_vcpu *vcpu0 =3D kvm_get_vcpu(kvm, 0);
+	u32 vm_id =3D vgic_v5_vm_id(kvm);
+	enum gicv5_vcpu_cmd cmd =3D VMT_L2_MAP;
+	struct vmtl2_entry *l2_table;
+	unsigned int l1_index;
+	int ret;
+
+	/* Nothing to do if we have linear tables! */
+	if (!vmt_info->two_level)
+		return 0;
+
+	if (vm_id =3D=3D VGIC_V5_VM_ID_INVAL)
+		return -EINVAL;
+
+	/*
+	 * We have 4k-sized L2 tables - this is mandated by the spec for
+	 * two-level VMTs (GICv5 EAC0 Specification rule D_LSPBK). This means
+	 * that we have 128 entries per L1 VMTE.
+	 */
+	l1_index =3D vm_id / GICV5_VMT_L2_TABLE_ENTRIES;
+
+	guard(mutex)(&vmt_l2_lock);
+
+	/* Already valid? Great! */
+	if (vmt_info->l2.l2ptrs[l1_index])
+		return 0;
+
+	l2_table =3D kzalloc_objs(*l2_table, GICV5_VMT_L2_TABLE_ENTRIES);
+	if (!l2_table)
+		return -ENOMEM;
+
+	/* The VMT is shared between all VMs. */
+	scoped_guard(raw_spinlock_irqsave, &vgic_v5_irs_lock) {
+		vgic_v5_clean_inval(l2_table, GICV5_VMT_L2_TABLE_SIZE);
+		vgic_v5_clean_inval(vmt_info->l2.vmt_base + l1_index,
+				    sizeof(vmtl1_entry));
+
+		WRITE_ONCE(vmt_info->l2.vmt_base[l1_index],
+			   cpu_to_le64(virt_to_phys(l2_table)));
+
+		vgic_v5_clean_inval(vmt_info->l2.vmt_base + l1_index,
+				    sizeof(vmtl1_entry));
+
+	}
+
+	/*
+	 * VMAP in the L2 VMT via the IRS. We use any of the VM's CPUs as a
+	 * conduit for interacting with the host's IRS. In the current case,
+	 * this lets us resolve the VM ID to pass to the hardware.
+	 */
+	ret =3D irq_set_vcpu_affinity(vgic_v5_vpe_db(vcpu0), &cmd);
+
+	/* We've failed to make the L2 VMT valid - things are very broken! */
+	if (ret) {
+		scoped_guard(raw_spinlock_irqsave, &vgic_v5_irs_lock) {
+			/* Remove the pointer from L1 table */
+			WRITE_ONCE(vmt_info->l2.vmt_base[l1_index], 0);
+
+			vgic_v5_clean_inval(vmt_info->l2.vmt_base + l1_index,
+					    sizeof(vmtl1_entry));
+		}
+
+		kfree(l2_table);
+		return ret;
+	}
+
+	vmt_info->l2.l2ptrs[l1_index] =3D l2_table;
+
+	return 0;
+}
+
+/*
+ * Allocate the top-level VMT. This can either be linear or two-level.
+ */
+int vgic_v5_vmt_allocate(unsigned int max_vpes)
+{
+	int ret;
+
+	/* Allocate the tracking structure */
+	vmt_info =3D kzalloc_obj(*vmt_info, GFP_KERNEL);
+	if (!vmt_info)
+		return -ENOMEM;
+
+	ida_init(&vmt_info->vm_id_ida);
+	vmt_info->max_vpes =3D max_vpes;
+	vmt_info->vmd_size =3D vgic_v5_irs_vmd_size(&irs_caps);
+	vmt_info->vped_size =3D vgic_v5_irs_vped_size(&irs_caps);
+	vmt_info->two_level =3D vgic_v5_irs_two_level_vmt_support(&irs_caps);
+	vmt_info->num_entries =3D vgic_v5_irs_max_vms(&irs_caps);
+
+	if (vmt_info->two_level)
+		ret =3D vgic_v5_alloc_vmt_two_level(vmt_info->num_entries);
+	else
+		ret =3D vgic_v5_alloc_vmt_linear(vmt_info->num_entries);
+
+	/* If anything failed, free our tracking structure before returning */
+	if (ret) {
+		kfree(vmt_info);
+		vmt_info =3D NULL;
+	}
+
+	return ret;
+}
+
+/*
+ * Free the VMT and associated tracking structures. This isn't strictly ex=
pected
+ * to be called in general operation, but instead exists for completeness.
+ */
+int vgic_v5_vmt_free(void)
+{
+	if (!vmt_info)
+		return 0;
+
+	if (!vmt_info->two_level) {
+		kfree(vmt_info->linear.vmt_base);
+	} else {
+		/* Free the L2 tables; kfree(NULL) is safe */
+		for (int i =3D 0; i < vmt_info->l2.num_l1_ents; ++i)
+			kfree(vmt_info->l2.l2ptrs[i]);
+		kfree(vmt_info->l2.l2ptrs);
+
+		/* And now free the L1 table */
+		kfree(vmt_info->l2.vmt_base);
+	}
+
+	ida_destroy(&vmt_info->vm_id_ida);
+	kfree(vmt_info);
+	vmt_info =3D NULL;
+
+	return 0;
+}
+
+/*
+ * Look up a VMT Entry by VM ID.
+ */
+static struct vmtl2_entry *vgic_v5_get_l2_vmte(u32 vm_id)
+{
+	unsigned int l1_index, l2_index;
+	struct vmtl2_entry *l2_table;
+
+	if (vm_id =3D=3D VGIC_V5_VM_ID_INVAL)
+		return ERR_PTR(-EINVAL);
+
+	if (!vmt_info->two_level)
+		return &vmt_info->linear.vmt_base[vm_id];
+
+	l1_index =3D vm_id / GICV5_VMT_L2_TABLE_ENTRIES;
+	l2_index =3D vm_id % GICV5_VMT_L2_TABLE_ENTRIES;
+
+	if (l1_index >=3D vmt_info->l2.num_l1_ents)
+		return ERR_PTR(-E2BIG);
+
+	if (!vmt_info->l2.l2ptrs[l1_index])
+		return ERR_PTR(-EINVAL);
+
+	l2_table =3D vmt_info->l2.l2ptrs[l1_index];
+	return &l2_table[l2_index];
+}
+
+/*
+ * Zero a VMT Entry, and flush & invalidate to the PoC, if required.
+ */
+static int vgic_v5_reset_vmte(struct kvm *kvm)
+{
+	u32 vm_id =3D vgic_v5_vm_id(kvm);
+	struct vmtl2_entry *vmte;
+
+	vmte =3D vgic_v5_get_l2_vmte(vm_id);
+	if (IS_ERR(vmte))
+		return PTR_ERR(vmte);
+
+	scoped_guard(raw_spinlock_irqsave, &vgic_v5_irs_lock) {
+		/*
+		 * The VMT is normal memory shared with the IRS. Invalidate before
+		 * rewriting the entry so that cacheline-granular maintenance cannot
+		 * later push stale data for neighbouring IRS-visible state back to
+		 * memory.
+		 */
+		vgic_v5_clean_inval(vmte, sizeof(*vmte));
+
+		/*
+		 * Prevent the compiler from eliding the individual VMTE
+		 * stores. Ordering and visibility to the IRS are provided by the
+		 * surrounding cache maintenance and command protocol, not by
+		 * WRITE_ONCE().
+		 *
+		 * The same compiler-access constraint applies to READ_ONCE() users in
+		 * this file: when inspecting IRS-visible table entries, read the field
+		 * exactly once and prevent the compiler from reusing, merging or
+		 * tearing the access. Coherency and freshness for non-coherent IRSes
+		 * still come from the surrounding cache maintenance.
+		 */
+		WRITE_ONCE(vmte->val[0], cpu_to_le64(0ULL));
+		WRITE_ONCE(vmte->val[1], cpu_to_le64(0ULL));
+		WRITE_ONCE(vmte->val[2], cpu_to_le64(0ULL));
+		WRITE_ONCE(vmte->val[3], cpu_to_le64(0ULL));
+
+		/* And make our write visible to the IRS (if non-coherent) */
+		vgic_v5_clean_inval(vmte, sizeof(*vmte));
+	}
+
+	return 0;
+}
+
+/*
+ * Use the IDA to allocate a new VM ID, and track it in the gicv5_vm data
+ * structure. If we're out of VM IDs, the IDA catches that, and we return =
the
+ * error (-ENOSPC). If we've previously allocated a VM ID, we catch that t=
oo and
+ * return -EBUSY.
+ */
+int vgic_v5_allocate_vm_id(struct kvm *kvm)
+{
+	int id;
+
+	if (kvm->arch.vgic.gicv5_vm.vm_id !=3D VGIC_V5_VM_ID_INVAL)
+		return -EBUSY;
+
+	id =3D ida_alloc_max(&vmt_info->vm_id_ida, vmt_info->num_entries - 1u,
+			   GFP_KERNEL);
+	if (id < 0)
+		return id;
+
+	kvm->arch.vgic.gicv5_vm.vm_id =3D id;
+
+	return 0;
+}
+
+/*
+ * Release the VM ID to allow it to be reallocated in the future.
+ */
+void vgic_v5_release_vm_id(struct kvm *kvm)
+{
+	if (kvm->arch.vgic.gicv5_vm.vm_id =3D=3D VGIC_V5_VM_ID_INVAL)
+		return;
+
+	ida_free(&vmt_info->vm_id_ida, kvm->arch.vgic.gicv5_vm.vm_id);
+	kvm->arch.vgic.gicv5_vm.vm_id =3D VGIC_V5_VM_ID_INVAL;
+}
+
+/*
+ * Initialise an entry in the VMT based on the index of the VM.
+ *
+ * Note: We don't mark the VMTE as valid as this needs to be done by
+ * the hardware.
+ */
+int vgic_v5_vmte_init(struct kvm *kvm)
+{
+	size_t vmd_alloc_size, vpet_alloc_size, vped_alloc_size;
+	void *vped_base =3D NULL, *vmd =3D NULL;
+	struct vgic_v5_vm_info *vmi =3D NULL;
+	u64 tmp, vmte_val0 =3D 0, vmte_val1;
+	u32 vm_id =3D vgic_v5_vm_id(kvm);
+	int ret, nr_cpus, nr_vcpus;
+	bool vmi_inserted =3D false;
+	struct vmtl2_entry *vmte;
+	vpe_entry *vpet =3D NULL;
+	struct kvm_vcpu *vcpu;
+	u16 max_vpe_id =3D 0;
+	unsigned long i;
+
+	nr_vcpus =3D atomic_read(&kvm->online_vcpus);
+	if (nr_vcpus > vmt_info->max_vpes)
+		return -E2BIG;
+
+	/*
+	 * If we're using two-level VMTs, L2 is allocated on demand. For linear
+	 * VMTs, this is a NOP.
+	 */
+	ret =3D vgic_v5_alloc_l2_vmt(kvm);
+	if (ret)
+		return ret;
+
+	vmte =3D vgic_v5_get_l2_vmte(vm_id);
+	if (IS_ERR(vmte))
+		return PTR_ERR(vmte);
+
+	/* If the entry is already valid, something went wrong */
+	scoped_guard(raw_spinlock_irqsave, &vgic_v5_irs_lock) {
+		vgic_v5_clean_inval(vmte, sizeof(*vmte));
+		if (le64_to_cpu(READ_ONCE(vmte->val[0])) & GICV5_VMTEL2E_VALID)
+			return -EINVAL;
+	}
+
+	ret =3D vgic_v5_reset_vmte(kvm);
+	if (ret)
+		return ret;
+
+	vmi =3D kzalloc_obj(*vmi);
+	if (!vmi) {
+		ret =3D -ENOMEM;
+		goto out_fail;
+	}
+
+	ret =3D xa_insert(&vm_info, vm_id, vmi, GFP_KERNEL);
+	if (ret)
+		goto out_fail;
+	vmi_inserted =3D true;
+
+	/* Allocate and assign the VM Descriptor, if required. */
+	if (vmt_info->vmd_size !=3D 0) {
+		vmd_alloc_size =3D round_up(vmt_info->vmd_size,
+					  dma_get_cache_alignment());
+		vmd =3D kzalloc(vmd_alloc_size, GFP_KERNEL);
+		if (!vmd) {
+			ret =3D -ENOMEM;
+			goto out_fail;
+		}
+
+		/* Stash the VA so we can free it later */
+		vmi->vmd_base =3D vmd;
+
+		tmp =3D FIELD_PREP(GICV5_VMTEL2E_VMD_ADDR,
+				 virt_to_phys(vmd) >> GICV5_VMTEL2E_VMD_ADDR_SHIFT);
+		vmte_val0 =3D tmp;
+	}
+
+	/*
+	 * Allocate and assign the VPE Table.
+	 *
+	 * First of all, iterate over all vcpus to find the highest VPE ID we
+	 * require - we need to ensure that we have enough storage for all
+	 * vcpu_id values that userspace has picked and not just the total
+	 * number of vcpus. This gives us the number of VPEs required for the
+	 * VM.
+	 *
+	 * Round up the number of VPEs to a whole power of two as we cannot
+	 * describe non-powers-of-two in the VMTE field as it conveys the number
+	 * of ID bits used and not the number of vPEs. IRS_IDR1.IAFFID_BITS is
+	 * encoded as N - 1, so expose at least one VPE ID bit even for a
+	 * single-vCPU VM to keep the views consistent.
+	 */
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		u16 vpe_id =3D vgic_v5_vpe_id(vcpu);
+
+		if (vpe_id > max_vpe_id)
+			max_vpe_id =3D vpe_id;
+	}
+
+	nr_cpus =3D max(2UL, roundup_pow_of_two(max_vpe_id + 1));
+	vmi->vpe_id_bits =3D fls(nr_cpus) - 1;
+
+	vpet_alloc_size =3D round_up((size_t)nr_cpus * sizeof(*vpet),
+				   dma_get_cache_alignment());
+	vpet =3D kzalloc(vpet_alloc_size, GFP_KERNEL);
+	if (!vpet) {
+		ret =3D -ENOMEM;
+		goto out_fail;
+	}
+
+	/* Stash the VA so we can free it later */
+	vmi->vpet_base =3D vpet;
+
+	tmp =3D FIELD_PREP(GICV5_VMTEL2E_VPET_ADDR,
+			 virt_to_phys(vpet) >> GICV5_VMTEL2E_VPET_ADDR_SHIFT);
+	tmp |=3D FIELD_PREP(GICV5_VMTEL2E_VPE_ID_BITS, vmi->vpe_id_bits);
+	vmte_val1 =3D tmp;
+
+	/*
+	 * Allocate a dense VPED array indexed by vcpu_idx. The VPET is indexed
+	 * by the potentially sparse vcpu_id, but using that ID here would waste
+	 * memory. Given that this is not userspace visible, we can cheat a bit
+	 * and use the dense index instead. This is the ONLY place that we do
+	 * this.
+	 *
+	 * Round the requested size up to a whole cacheline. kzalloc() gurantees
+	 * natural alignment, so we ensure that the cachelines cannot be shared
+	 * with unrelated slab objects. VPED and cacheline sizes are powers of
+	 * two, so this also preserves the required VPED alignment when a VPED
+	 * is larger than a cacheline.
+	 */
+	vped_alloc_size =3D round_up((size_t)nr_vcpus * vmt_info->vped_size,
+				   dma_get_cache_alignment());
+	vped_base =3D kzalloc(vped_alloc_size, GFP_KERNEL);
+	if (!vped_base) {
+		ret =3D -ENOMEM;
+		goto out_fail;
+	}
+	vmi->vped_base =3D vped_base;
+
+	if (vmd)
+		vgic_v5_clean_inval(vmd, vmd_alloc_size);
+	vgic_v5_clean_inval(vpet, vpet_alloc_size);
+	vgic_v5_clean_inval(vped_base, vped_alloc_size);
+
+	/* Publish the VMTE while serialising access to the shared VMT. */
+	scoped_guard(raw_spinlock_irqsave, &vgic_v5_irs_lock) {
+		WRITE_ONCE(vmte->val[0], cpu_to_le64(vmte_val0));
+		WRITE_ONCE(vmte->val[1], cpu_to_le64(vmte_val1));
+		vgic_v5_clean_inval(vmte, sizeof(*vmte));
+	}
+
+	kvm->arch.vgic.gicv5_vm.vmte_allocated =3D true;
+
+	return 0;
+
+out_fail:
+	/* kfree(NULL) is safe so we can just kfree() at leisure */
+	kfree(vmd);
+	kfree(vpet);
+	kfree(vped_base);
+	if (vmi_inserted)
+		xa_erase(&vm_info, vm_id);
+	kfree(vmi);
+
+	vgic_v5_reset_vmte(kvm);
+
+	return ret;
+}
+
+/*
+ * Release the VMT Entry, freeing up any allocated data structures before
+ * zeroing the VMTE.
+ *
+ * The VMTE must be marked as invalid before it is released.
+ */
+int vgic_v5_vmte_release(struct kvm *kvm)
+{
+	u32 vm_id =3D vgic_v5_vm_id(kvm);
+	struct vgic_v5_vm_info *vmi;
+	struct vmtl2_entry *vmte;
+	int ret;
+
+	vmte =3D vgic_v5_get_l2_vmte(vm_id);
+	if (IS_ERR(vmte))
+		return PTR_ERR(vmte);
+
+	/* Reject if the VMTE has not been marked as invalid! */
+	scoped_guard(raw_spinlock_irqsave, &vgic_v5_irs_lock) {
+		vgic_v5_clean_inval(vmte, sizeof(*vmte));
+		if (le64_to_cpu(READ_ONCE(vmte->val[0])) & GICV5_VMTEL2E_VALID)
+			return -EINVAL;
+	}
+
+	vmi =3D xa_load(&vm_info, vm_id);
+	if (!vmi)
+		goto no_vmi;
+
+	kfree(vmi->vped_base);
+	kfree(vmi->vpet_base);
+	kfree(vmi->vmd_base);
+
+	xa_erase(&vm_info, vm_id);
+	kfree(vmi);
+
+no_vmi:
+	/*
+	 * If we didn't get far enough into allocating a VMTE to create the VM
+	 * info structure, then we just zero the VMTE and move on. There's
+	 * nothing else we can realistically do here.
+	 */
+	ret =3D vgic_v5_reset_vmte(kvm);
+	if (ret)
+		return ret;
+
+	kvm->arch.vgic.gicv5_vm.vmte_allocated =3D false;
+
+	return 0;
+}
+
+/* Provide the preallocated VPE descriptor to the hardware via the VPE Tab=
le. */
+int vgic_v5_vmte_alloc_vpe(struct kvm_vcpu *vcpu)
+{
+	u32 vm_id =3D vgic_v5_vm_id(vcpu->kvm);
+	u16 vpe_id =3D vgic_v5_vpe_id(vcpu);
+	struct vgic_v5_vm_info *vmi;
+	vpe_entry tmp, *vpet_base;
+	void *vped;
+
+	/* Make sure we're not over what the hardware supports */
+	if (vpe_id >=3D vmt_info->max_vpes)
+		return -E2BIG;
+
+	vmi =3D xa_load(&vm_info, vm_id);
+	if (!vmi)
+		return -EINVAL;
+
+	if (vpe_id >=3D 1 << vmi->vpe_id_bits)
+		return -E2BIG;
+
+	vpet_base =3D vmi->vpet_base;
+
+	/* If the VPETE for this CPU is already valid we've gone wrong */
+	scoped_guard(raw_spinlock_irqsave, &vgic_v5_irs_lock) {
+		vgic_v5_clean_inval(&vpet_base[vpe_id], sizeof(*vpet_base));
+		if (le64_to_cpu(READ_ONCE(vpet_base[vpe_id])) & GICV5_VPE_VALID)
+			return -EBUSY;
+	}
+
+	vped =3D (u8 *)vmi->vped_base +
+		(size_t)vcpu->vcpu_idx * vmt_info->vped_size;
+
+	tmp =3D FIELD_PREP(GICV5_VPED_ADDR, virt_to_phys(vped) >> GICV5_VPED_ADDR=
_SHIFT);
+
+	scoped_guard(raw_spinlock_irqsave, &vgic_v5_irs_lock) {
+		WRITE_ONCE(vpet_base[vpe_id], cpu_to_le64(tmp));
+		vgic_v5_clean_inval(vpet_base + vpe_id, sizeof(vpe_entry));
+	}
+
+	return 0;
+}
+
+/* Clear the VPE's table entry after the VMTE has been made invalid. */
+int vgic_v5_vmte_free_vpe(struct kvm_vcpu *vcpu)
+{
+	u32 vm_id =3D vgic_v5_vm_id(vcpu->kvm);
+	u16 vpe_id =3D vgic_v5_vpe_id(vcpu);
+	struct vgic_v5_vm_info *vmi;
+	struct vmtl2_entry *vmte;
+	vpe_entry *vpet_base;
+
+	vmte =3D vgic_v5_get_l2_vmte(vm_id);
+	if (IS_ERR(vmte))
+		return PTR_ERR(vmte);
+
+	scoped_guard(raw_spinlock_irqsave, &vgic_v5_irs_lock) {
+		vgic_v5_clean_inval(vmte, sizeof(*vmte));
+		if (le64_to_cpu(READ_ONCE(vmte->val[0])) & GICV5_VMTEL2E_VALID)
+			return -EBUSY;
+	}
+
+	vmi =3D xa_load(&vm_info, vm_id);
+	if (!vmi)
+		return -EINVAL;
+
+	if (vpe_id >=3D 1 << vmi->vpe_id_bits)
+		return -E2BIG;
+
+	vpet_base =3D vmi->vpet_base;
+	scoped_guard(raw_spinlock_irqsave, &vgic_v5_irs_lock) {
+		WRITE_ONCE(vpet_base[vpe_id], 0ULL);
+		vgic_v5_clean_inval(vpet_base + vpe_id, sizeof(vpe_entry));
+	}
+
+	return 0;
+}
diff --git a/arch/arm64/kvm/vgic/vgic-v5-tables.h b/arch/arm64/kvm/vgic/vgi=
c-v5-tables.h
new file mode 100644
index 0000000000000..962be0c7cd3f6
--- /dev/null
+++ b/arch/arm64/kvm/vgic/vgic-v5-tables.h
@@ -0,0 +1,100 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (C) 2025, 2026 Arm Ltd.
+ */
+
+#ifndef __KVM_ARM_VGICV5_TABLES_H__
+#define __KVM_ARM_VGICV5_TABLES_H__
+
+#include <linux/spinlock.h>
+#include <linux/idr.h>
+#include <linux/irqchip/arm-gic-v5.h>
+
+/* Level 1 Virtual Machine Table Entry */
+typedef __le64 vmtl1_entry;
+
+/* Level 2 Virtual Machine Table Entry */
+struct vmtl2_entry {
+	__le64 val[4];
+};
+
+/* Virtual PE Table Entry */
+typedef __le64 vpe_entry;
+
+struct vgic_v5_vm_info {
+	void __iomem		*vmd_base;
+	vpe_entry __iomem	*vpet_base;
+	void			*vped_base;
+	u8			vpe_id_bits;
+};
+
+struct vgic_v5_vmt {
+	union {
+		struct {
+			struct vmtl2_entry *vmt_base;
+			unsigned int num_ents;
+		} linear;
+		struct {
+			vmtl1_entry *vmt_base;
+			struct vmtl2_entry **l2ptrs;
+			unsigned int num_l1_ents;
+		} l2;
+	};
+	bool		two_level;
+	unsigned int	num_entries;
+	unsigned int	max_vpes;
+	size_t		vmd_size;
+	size_t		vped_size;
+	struct ida	vm_id_ida;
+};
+
+static inline u32 vgic_v5_vm_id(struct kvm *kvm)
+{
+	return kvm->arch.vgic.gicv5_vm.vm_id;
+}
+
+/*
+ * For vGICv5, we need to consolidate two views:
+ *   - The vcpu ID assigned by userspace, which it can assign however it
+ *     sees fit.
+ *   - The index into the VPET, which is also presented to the guest as
+ *     the IAFFID for the VPE in question.
+ *
+ * Ideally, we don't want to intercept the guest setting an interrupt's af=
finity
+ * - this would somewhat defeat the point of allowing the hardware to mana=
ge the
+ * interrupt directly. Therefore, we need to use vcpu->vcpu_id as our VPE =
ID,
+ * which ensures that both userspace and the GICv5 hardware have a consist=
ent
+ * view.
+ *
+ * This means two things:
+ *   - Our VPET might be sparse, depending on the IDs picked by userspace.
+ *   - We need to check the vcpu ID provided by userspace, and reject anyt=
hing
+ *     we cannot handle.
+ *
+ * In order to at least ensure consistent usage in the places that we need=
 to
+ * use the VPE ID, we provide this helper.
+ */
+static inline u16 vgic_v5_vpe_id(struct kvm_vcpu *vcpu)
+{
+	return vcpu->vcpu_id;
+}
+
+static inline int vgic_v5_vpe_db(struct kvm_vcpu *vcpu)
+{
+	return vcpu->arch.vgic_cpu.vgic_v5.gicv5_vpe.db;
+}
+
+extern raw_spinlock_t vgic_v5_irs_lock;
+
+int vgic_v5_vmt_allocate(unsigned int max_vpes);
+int vgic_v5_vmt_free(void);
+
+int vgic_v5_allocate_vm_id(struct kvm *kvm);
+void vgic_v5_release_vm_id(struct kvm *kvm);
+
+int vgic_v5_vmte_init(struct kvm *kvm);
+int vgic_v5_vmte_release(struct kvm *kvm);
+int vgic_v5_vmte_alloc_vpe(struct kvm_vcpu *vcpu);
+int vgic_v5_vmte_free_vpe(struct kvm_vcpu *vcpu);
+
+#endif
diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 752329fc3d566..4d1d7701ef71d 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -5,10 +5,12 @@
=20
 #include <kvm/arm_vgic.h>
=20
+#include <linux/kvm_host.h>
 #include <linux/bitops.h>
 #include <linux/irqchip/arm-vgic-info.h>
 #include <linux/irqdomain.h>
=20
+#include "vgic-v5-tables.h"
 #include "vgic.h"
=20
 #define ppi_caps	kvm_vgic_global_state.vgic_v5_ppi_caps
@@ -129,6 +131,22 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
 	return 0;
 }
=20
+static int vgic_v5_db_set_vcpu_affinity(struct irq_data *data, void *vcpu_=
info)
+{
+	enum gicv5_vcpu_cmd *cmd =3D vcpu_info;
+
+	guard(raw_spinlock_irqsave)(&vgic_v5_irs_lock);
+
+	switch (*cmd) {
+	case VMT_L2_MAP:
+	case VMTE_MAKE_VALID:
+	case VMTE_MAKE_INVALID:
+		/* Not yet implemented */
+	default:
+		return -EINVAL;
+	}
+}
+
 /*
  * This set of irq_chip functions is specific for doorbells.
  */
@@ -140,6 +158,7 @@ static const struct irq_chip vgic_v5_db_irq_chip =3D {
 	.irq_set_affinity =3D irq_chip_set_affinity_parent,
 	.irq_get_irqchip_state =3D irq_chip_get_parent_state,
 	.irq_set_irqchip_state =3D irq_chip_set_parent_state,
+	.irq_set_vcpu_affinity =3D vgic_v5_db_set_vcpu_affinity,
 	.flags =3D IRQCHIP_SET_TYPE_MASKED | IRQCHIP_SKIP_SET_WAKE |
 		 IRQCHIP_MASK_ON_SUSPEND,
 };
diff --git a/drivers/irqchip/irq-gic-v5-irs.c b/drivers/irqchip/irq-gic-v5-=
irs.c
index 607e066821b52..70502b07ec8d7 100644
--- a/drivers/irqchip/irq-gic-v5-irs.c
+++ b/drivers/irqchip/irq-gic-v5-irs.c
@@ -269,24 +269,24 @@ int gicv5_irs_iste_alloc(const u32 lpi)
  * itself is not supported) again serves to make it easier to find physica=
lly
  * contiguous blocks of memory.
  */
-static unsigned int gicv5_irs_l2_sz(u32 idr2)
+unsigned int gicv5_irs_l2_sz(u32 l2sz)
 {
 	switch (PAGE_SIZE) {
 	case SZ_64K:
-		if (GICV5_IRS_IST_L2SZ_SUPPORT_64KB(idr2))
+		if (GICV5_IRS_IST_L2SZ_SUPPORT_64KB(l2sz))
 			return GICV5_IRS_IST_CFGR_L2SZ_64K;
 		fallthrough;
 	case SZ_4K:
-		if (GICV5_IRS_IST_L2SZ_SUPPORT_4KB(idr2))
+		if (GICV5_IRS_IST_L2SZ_SUPPORT_4KB(l2sz))
 			return GICV5_IRS_IST_CFGR_L2SZ_4K;
 		fallthrough;
 	case SZ_16K:
-		if (GICV5_IRS_IST_L2SZ_SUPPORT_16KB(idr2))
+		if (GICV5_IRS_IST_L2SZ_SUPPORT_16KB(l2sz))
 			return GICV5_IRS_IST_CFGR_L2SZ_16K;
 		break;
 	}
=20
-	if (GICV5_IRS_IST_L2SZ_SUPPORT_4KB(idr2))
+	if (GICV5_IRS_IST_L2SZ_SUPPORT_4KB(l2sz))
 		return GICV5_IRS_IST_CFGR_L2SZ_4K;
=20
 	return GICV5_IRS_IST_CFGR_L2SZ_64K;
@@ -334,7 +334,7 @@ static int __init gicv5_irs_init_ist(struct gicv5_irs_c=
hip_data *irs_data)
 	lpi_id_bits =3D min(lpi_id_bits, gicv5_global_data.cpuif_id_bits);
=20
 	if (two_levels)
-		l2sz =3D gicv5_irs_l2_sz(idr2);
+		l2sz =3D gicv5_irs_l2_sz(FIELD_GET(GICV5_IRS_IDR2_IST_L2SZ, idr2));
=20
 	istmd =3D !!FIELD_GET(GICV5_IRS_IDR2_ISTMD, idr2);
=20
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 6e5aa248f3cfd..7923ff20d9d7d 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -361,6 +361,8 @@ struct vgic_redist_region {
 	struct list_head list;
 };
=20
+#define VGIC_V5_VM_ID_INVAL		(-1)
+
 struct vgic_v5_vm {
 	/*
 	 * We only expose a subset of PPIs to the guest. This subset is a
@@ -383,6 +385,8 @@ struct vgic_v5_vm {
 	struct fwnode_handle	*fwnode;
 	struct irq_domain	*domain;
 	int			vpe_db_base;
+	u32			vm_id;
+	bool			vmte_allocated;
 };
=20
 struct vgic_dist {
diff --git a/include/linux/irqchip/arm-gic-v5.h b/include/linux/irqchip/arm=
-gic-v5.h
index 21c8a69f99bb6..27b13bf2c1e2c 100644
--- a/include/linux/irqchip/arm-gic-v5.h
+++ b/include/linux/irqchip/arm-gic-v5.h
@@ -159,9 +159,9 @@
 #define GICV5_IRS_IDR2_LPI		BIT(5)
 #define GICV5_IRS_IDR2_ID_BITS		GENMASK(4, 0)
=20
-#define GICV5_IRS_IST_L2SZ_SUPPORT_4KB(r)	FIELD_GET(BIT(11), (r))
-#define GICV5_IRS_IST_L2SZ_SUPPORT_16KB(r)	FIELD_GET(BIT(12), (r))
-#define GICV5_IRS_IST_L2SZ_SUPPORT_64KB(r)	FIELD_GET(BIT(13), (r))
+#define GICV5_IRS_IST_L2SZ_SUPPORT_4KB(r)	FIELD_GET(BIT(0), (r))
+#define GICV5_IRS_IST_L2SZ_SUPPORT_16KB(r)	FIELD_GET(BIT(1), (r))
+#define GICV5_IRS_IST_L2SZ_SUPPORT_64KB(r)	FIELD_GET(BIT(2), (r))
=20
 #define GICV5_IRS_IDR3_VMT_LEVELS	BIT(10)
 #define GICV5_IRS_IDR3_VM_ID_BITS	GENMASK(9, 5)
@@ -609,6 +609,7 @@ int gicv5_irs_cpu_to_iaffid(int cpu_id, u16 *iaffid);
 struct gicv5_irs_chip_data *gicv5_irs_lookup_by_spi_id(u32 spi_id);
 int gicv5_spi_irq_set_type(struct irq_data *d, unsigned int type);
 int gicv5_irs_iste_alloc(u32 lpi);
+unsigned int gicv5_irs_l2_sz(u32 l2sz);
 void gicv5_irs_syncr(void);
=20
 /* Embedded in kvm.arch */
@@ -653,4 +654,11 @@ void gicv5_deinit_lpis(void);
=20
 void __init gicv5_its_of_probe(struct device_node *parent);
 void __init gicv5_its_acpi_probe(void);
+
+enum gicv5_vcpu_cmd {
+	VMT_L2_MAP,		/* Map in a L2 VMT - *may* happen on VM init */
+	VMTE_MAKE_VALID,	/* Make the VMTE valid */
+	VMTE_MAKE_INVALID,	/* Make the VMTE (et al.) invalid */
+};
+
 #endif
--=20
2.34.1
