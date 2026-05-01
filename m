Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013008.outbound.protection.outlook.com [52.101.83.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B0E23FFACF
	for <kvmarm@lists.linux.dev>; Fri,  1 May 2026 16:48:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.8
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777654095; cv=fail; b=qQf5J8FPAo0Gfp+TAIGGSHRiBdKY69Duxr0rT4rFyflD/TVUv2silQ4ePiSsygrYVX8ZZWBIgHncSZrr9lplaqhMga7RwZhAM+XfU9O8oDcK5O3NwEO6gkmGDcoo6HrlxCNyHiaSyTTTrbNw971JYGhKjUWaTaBjgVH2CrE/NA0=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777654095; c=relaxed/simple;
	bh=upEE7eHZn77bfXkw3XGT39Gk32Rf2ShhLAMr81HPJgY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ZZCdvtRrgiQIWTTWGbcCPn28MroU4l2EfoN4jHQSEejAKRexdVYAWjlWNqdV8VD0j0DRosEOXBwFxjy6pQrmLWOWRHJ1UtmsbWXZYhsnMaEdDqNuZcgCqXy06n28xTSPaJHyUAweh9GwgQVwhb7XRvPzPBgL7/9UHJqMX1m0+78=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Ciq1jlSw; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Ciq1jlSw; arc=fail smtp.client-ip=52.101.83.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Ciq1jlSw";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Ciq1jlSw"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=JfNIlzYRUe7w9ivF05aiyKQXXvPFt8O1v/HaBIzqmx0QKClYftvAyR5e1Mu4l31oXmFi5njwkmZqgfvpd256bHW+3ZlUaWP121aJmnJei0A7gWlyBwF4joMkwkGP88wGgqLheOJVcdAwuYLxsULWeJsM67+TZkV+od5f9r3oN4DzdYfZqfNK3+As4preEybF90PD+U0r8Fh6CyYp+W/KSJGJ9h2o+eBmOeqM7I3KPLhJp4YvdOlFJfGZWMAe080C1d1WlQ6sz+lE8YZpUIrnlccLpGl6K7hRp3D8mEEeNl7cWXms7SRN1VyWGfs8v6bdt4nx5lAPobx7stfQr3fs5Q==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=upEE7eHZn77bfXkw3XGT39Gk32Rf2ShhLAMr81HPJgY=;
 b=lbjokHkQvcAsO5w6RVQdzXoI4ulpeiDh7m7Irb0IdbzsOfjpZFCn4wq7eCEoBxx/NbQdQXbmM/8OpmhV8haAvBiZ5J+rb+8kwfe2+Huzx5WRbDB1W08f4xdaMZQrsRiQ2Af+hMTmFgzKJiIGtdxaQCECxhwxAdTgDWF22+xelF+glQXyAKDkqnIELBRznywfE/ffzjJn4GePIVEBxsizg6VN+yq0cA48QNnAQqveen4hGpo6fL5Kvx6fUqiZwNDxbPtb7/M3y8F4tBuo3EqtkECLVScBY/o/fbl6V3pWNt+oFHDELOAtnt6h36nOhxiwdEls4Oc7CxEtStEKqbiWfQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=upEE7eHZn77bfXkw3XGT39Gk32Rf2ShhLAMr81HPJgY=;
 b=Ciq1jlSwkH07QN9/aI814qhlxRdMhswOn6HWLmReWTAxKr8xwDgOq5bNCi+KBiJe1Uj/velochA/tiufaf55NWvKW11wg7leZSmj9pW2EFm2AOuMMz6fr1C3NookUTP+GzKn49rPDPbbtjZ+OWlGzKP3VcBoDtrwc3/2uW0gLZk=
Received: from DU7P194CA0027.EURP194.PROD.OUTLOOK.COM (2603:10a6:10:553::7) by
 AS2PR08MB10082.eurprd08.prod.outlook.com (2603:10a6:20b:62f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.21; Fri, 1 May
 2026 16:48:02 +0000
Received: from DB1PEPF000509E6.eurprd03.prod.outlook.com
 (2603:10a6:10:553:cafe::6a) by DU7P194CA0027.outlook.office365.com
 (2603:10a6:10:553::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9870.22 via Frontend Transport; Fri,
 1 May 2026 16:48:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509E6.mail.protection.outlook.com (10.167.242.56) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9870.22
 via Frontend Transport; Fri, 1 May 2026 16:48:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bC88KLhpl3UdyU0jNCjCbzdqY3llYi9IWFjPGDCuDf41NdVNUtIyJWpfjtf/pJzb7Lhl7a1ClB9gRKaj/nXNjNALubM1drLaIQSQeAYifz/VR49XCR98XRu0McL0ffaLTEN9A9oEuJXdHzGFKgqxRnCt8BuW4FS5Mh2IyvVC+i++pJqM1e9LniHmucoC7sT5SYxPhdpokx/ZQYwCzzx3m28slO6H5AnIeUryB4a0CG7B6OoklyH/nq9br+Z0lBUg8ttd4IDH+zy/DS0ASVNmHOPYDQ8YFeZpGLu43j2v13bIZh+eZXNkDG+Wei4jC3TLa70RpTM18/334zIUwA1cFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=upEE7eHZn77bfXkw3XGT39Gk32Rf2ShhLAMr81HPJgY=;
 b=nta7nNTda50Pi5jXolD4NdrRbXWHJAHUScAFt0SwwR5j++JzjApqL0uLc78qAbq4BHKx6tTbTJujVPyzJtWtDabb6SN3jFqOVuL8cyjVhkeHWnNy8aUMX+z+R0h6T9ZiKyTehMqTKFgJ7Pttjb225uye/gd+2qdPHdg7xEIXd/RaH3CuQx14fl5zoPKs3MQUj+E9lz8SqDLwAUNkSM2SeF7TZj16TDWYwnan4CB/YZnXd7UTSDehdHntTZB0zz7bWisAlxq8MyasoZAFtcfYkYg36glBk1piXQyQ+fu97TDh5gmBvl2/qmfgtM6FoMtj5+sWq76kb79O1G2IZ0rEkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=upEE7eHZn77bfXkw3XGT39Gk32Rf2ShhLAMr81HPJgY=;
 b=Ciq1jlSwkH07QN9/aI814qhlxRdMhswOn6HWLmReWTAxKr8xwDgOq5bNCi+KBiJe1Uj/velochA/tiufaf55NWvKW11wg7leZSmj9pW2EFm2AOuMMz6fr1C3NookUTP+GzKn49rPDPbbtjZ+OWlGzKP3VcBoDtrwc3/2uW0gLZk=
Received: from AM6PR08MB3399.eurprd08.prod.outlook.com (2603:10a6:20b:47::18)
 by VI1PR08MB9958.eurprd08.prod.outlook.com (2603:10a6:800:1c0::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.20; Fri, 1 May
 2026 16:46:58 +0000
Received: from AM6PR08MB3399.eurprd08.prod.outlook.com
 ([fe80::59cd:4b6:fceb:3de7]) by AM6PR08MB3399.eurprd08.prod.outlook.com
 ([fe80::59cd:4b6:fceb:3de7%5]) with mapi id 15.20.9870.016; Fri, 1 May 2026
 16:46:58 +0000
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
Subject: Re: [PATCH 04/43] irqchip/gic-v5: Provide IRS config frame attrs to
 KVM
Thread-Topic: [PATCH 04/43] irqchip/gic-v5: Provide IRS config frame attrs to
 KVM
Thread-Index: AQHc1l/veploA5YIZ0CWTPRUjFcuorX0kbwAgATVwoA=
Date: Fri, 1 May 2026 16:46:58 +0000
Message-ID: <5acb42e527d71ee8945012b63aef4a94541744ac.camel@arm.com>
References: <20260427160547.3129448-1-sascha.bischoff@arm.com>
	 <20260427160547.3129448-5-sascha.bischoff@arm.com>
	 <86qznzyvyl.wl-maz@kernel.org>
In-Reply-To: <86qznzyvyl.wl-maz@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AM6PR08MB3399:EE_|VI1PR08MB9958:EE_|DB1PEPF000509E6:EE_|AS2PR08MB10082:EE_
X-MS-Office365-Filtering-Correlation-Id: c4e7680d-c2f3-48f1-7dcb-08dea7a16868
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|38070700021|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 o6roFNEFPAHUta80FAGvR9gXPgGAkHAv3jopFuVewk+OvNwZRYZP0//l2X3vuAymUethpd3UodU3G0CSGHJsdNXeSFoIp5We8liYkB7r1sp1gRocyX1Eisx+UTDj7psj1QCvAEJRKA+vAznBLVjaR3XXTjUbf8gAgvnQb0+2T2kSG1808LI7PovTCYhippYlRgJOHKHDUjMTcPYS5FAw0rwiVQS9ZqsK1tYw/0EQwOuvWsnu7b2koegY2wJVpsuH8HwwMADeku2sf8Sluz1gcCmjsR8zqRMFI1FO2oghAtN64rXbFnlrvfBFuB7h8dEyFJfCuUl8ZoUuLM9dIEuwss/9DSoNsZTfQ8P78ewNyI1THa5KeKxNRPsEp1OJUGpayqM70eony6SA0i4ZmIW3gSZXmH0pfK/jM0t1535bS1qWIOCub3aAyr6wNUDX5eYjEEtZgs/0CXXPHPqJbnTbXLlPuyeIt4PGL7xreuiW/xEI3eMLOxFDZb+6RmZpx/YiZl3BGb8Z1xRUsOh3266uDQsq4WWlIWVjEioHBn7nN5Cm0ocA6QWxPEgLIs1LjHIJFpV9DExePe0n++5lf+tfwPoPdhH29tEeDKT2grNmbB/KeppWwf3VR3lzO+1bGdfJ/YKlxhkG2wFtUluoggpljncz9NU0b/52lKhA6TUYTSNLBtxpUlpggnS+RYklmqD1XRPJITCR1AsGGd9bXnMmECS9rY2j52wnDFWngX9ydJOiRTEfX3PP07NG+MMJiE7C
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR08MB3399.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700021)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <67100CC0F5B64C4EA032842FFB486D3E@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 lMpvJ2L61LO5KgO8Bcez346SiGF7hSKgYqfbRpTDDH42pdsQxF5zFMWRbns7CmIZ+32AH8ulluQiO/NEtvYGqiE0Z8BHt07OEDlsRCiX24rWSiVct+ceFfAfzttStuU7SeVly744ZIJ8hngKruRY4PWuITWkl1ZaGZjW7PSZ9D8qmKBb8LhzmnLOnYnfHrEClBizYeqIGYqt7Dxu/mfLjiJAFeKRa756yh0SZDQ8tB3JZ+LwKDUEkGuv+3V6c+NW2akb1Mfz1JMqfhiI0twpgYlJKcIFao3ibp+LqAv30pB6pTQH1Q2Ik7ex+Ut/9scOGvZfsqr+8csQyQwjTRvBBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB9958
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509E6.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	5f8baa04-9c31-462d-64d5-08dea7a1428b
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|35042699022|36860700016|14060799003|1800799024|376014|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	8rexmHIfObAFJ40CuUFv5hbgqlWx3wLMSDmp2lFaIU45Sxz3rwLNKc9rqmnjSRrbWzi1F0NgfoX+sHSTtQfEhIX9115T7CmM+zMQUMrdcmKIiKoz/e9gGimvgZ612TYMOSvPla/RibpZan4Mk/gSQHhwE0/Sx8CdC2h8Cbw/QwMKHH09evI6qeh0CMhBuTHyAjVTt8Ob352Bn3/iAUQPpl1nFnuL16z2TGXcblJm+S9mLvAO2c1zd2SiHU5cyuXq0aY1lfTO3bvywYs/IbRFKwRiBGXBnjPytmuNvsvUxuvI13zYBSn55XwWI9iUv2wx2pq4bUun6s3Xwbg+gw4Tir2kWStT80w+ndrKLQxRpjxg+lkn7qMrf5eybg5MeGbeQSCjez92M7g61P+Qb+8Gv6OigTAnfEUrBj6jBm5oqLA+9vqgeCjFQRFOj6Rf472aQqS7NhUMU+9/Lr3n77S0SEE8iNj4ey2Mnk/rcb84/YgsHM1CbJm9ZmkUO6HSVT53Nzq/VRyRREEtbX6ID98jEH3Ht2hcN4vRul3cz+d+B1Ihx4JtC1jHzOmaHdqXCVQGrcC6rXpsrdjdzVsfcsPfYCzcvUsEd9ZteUbMQxcazHAlfxvICZHGHrcO3CYF+gYw0Z9g5zN8FtzirX5dp5an5htu2whTxPgcPGnssKGptwJSZxt/fQHsUinfKN+YnJZQNDV3fxiCHalPEpD8zCS+ll+Y5CQxIqQjSJvoJW5oKm4=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(35042699022)(36860700016)(14060799003)(1800799024)(376014)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	6zS7Yd4K7QE9PeowVKacxIxyULcopxI7HSgmPxoZqyd+JFYrSrIO4cZUByCvsifDD+qUHUdDXpXQLSea2QLZBf6LfH+hluamP4HY/4ZIOEedZUorx+a+cbZQWV0T9TlTqmxxhmJ+UUCahtnRylMj5fcdjDnehjMA4xR4GvnFTxtgP3k1Og590wveGdQDKfYBEo/tz3YEWIzJcHtoSYgIJPgfEpV3GUKTW1uVtniXprSDKzfv4VoVxVjIeGbOBfrSPPcWsX4SVcyFbmTSQvTBRo1qzHsMULsvbzMdssFSMf9HdDENv8hbiWLObhoZE1lUpZhmK9V7TuvxnnqIvQ/eo2ypFBZlptt1PnHC+PliaNV1N6Xp8ftaYbUIwslJbAaYlhsaI+DtjS55/6v9MpUMgnJSkZIJV9d1R/SZRi5SDwTbhuGyoUz0apq40dTtmp6K
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2026 16:48:01.5348
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c4e7680d-c2f3-48f1-7dcb-08dea7a16868
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509E6.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB10082

T24gVHVlLCAyMDI2LTA0LTI4IGF0IDE1OjU2ICswMTAwLCBNYXJjIFp5bmdpZXIgd3JvdGU6DQo+
IE9uIE1vbiwgMjcgQXByIDIwMjYgMTc6MDc6MjQgKzAxMDAsDQo+IFNhc2NoYSBCaXNjaG9mZiA8
U2FzY2hhLkJpc2Nob2ZmQGFybS5jb20+IHdyb3RlOg0KPiA+IA0KPiA+IEtWTSBuZWVkcyB0byBp
bnRlcmFjdCB3aXRoIHRoZSBob3N0IElSUyBpbiBvcmRlciB0bywgZm9yIGV4YW1wbGUsDQo+ID4g
bWFrZQ0KPiA+IFZNcyBvciBWUEVzIHZhbGlkLiBUaGVyZSBhcmUgdHdvIHBvdGVudGlhbCBhcHBy
b2FjaGVzIGhlcmUuIEVpdGhlcg0KPiA+IHRoZQ0KPiA+IGhvc3QgaXJxY2hpcCBkcml2ZXIgY2Fu
IHByb3ZpZGUgYW4gaW50ZXJmYWNlLCBvciBLVk0gY2FuIGludGVyYWN0DQo+ID4gZGlyZWN0bHkg
d2l0aCB0aGUgaG9zdCBJUlMuIFRoZSBsYXR0ZXIgb2YgdGhlc2UgdHdvIGlzIGNob3NlbiBhcw0K
PiA+IHRoZQ0KPiA+IHNldCBvZiBNTUlPIHJlZ2lzdGVycyB0aGF0IEtWTSBuZWVkcyB0byBpbnRl
cmFjdCB3aXRoIGlzIG9ydGhvZ29uYWwNCj4gPiB0bw0KPiA+IHRoZSBzZXQgdXNlZCBieSB0aGUg
aG9zdCBpcnFjaGlwIGRyaXZlciAod2l0aCB0aGUgZXhjZXB0aW9uIG9mIHNvbWUNCj4gPiBvZg0K
PiA+IHRoZSByZWFkLW9ubHkgSVJTX0lEUnggcmVnaXN0ZXJzKS4NCj4gPiANCj4gPiBQYXNzIEtW
TSBhIHBvaW50ZXIgdG8gYW4gSVJTIGNvbmZpZyBmcmFtZSAtIHRoZSBjb25maWcgZnJhbWUNCj4g
PiBiZWxvbmdpbmcNCj4gPiB0byBBTlkgSVJTIGlzIGZpbmUgYXMgbG9uZyBhcyBvbmUgSVJTJ3Mg
Y29uZmlnIGZyYW1lIGlzIHVzZWQNCj4gPiBjb25zaXN0ZW50bHkgLSBpbiBzdHJ1Y3QgZ2ljX2t2
bV9pbmZvLiBBZGRpdGlvbmFsbHksIGluY2x1ZGUgYSBmbGFnDQo+ID4gdGVsbGluZyBLVk0gd2hl
dGhlciB0aGUgSVJTIGlzIGNvaGVyZW50IG9yIG5vbi1jb2hlcmVudCBpbiBvcmRlciB0bw0KPiA+
IG1ha2Ugc3VyZSB0aGF0IEtWTSBjYW4gZG8gdGhlIGNvcnJlY3QgY2FjaGUgc3RhdGUgbWFuYWdl
bWVudCwgaWYNCj4gPiByZXF1aXJlZC4NCj4gPiANCj4gPiBTaWduZWQtb2ZmLWJ5OiBTYXNjaGEg
QmlzY2hvZmYgPHNhc2NoYS5iaXNjaG9mZkBhcm0uY29tPg0KPiA+IC0tLQ0KPiA+IMKgZHJpdmVy
cy9pcnFjaGlwL2lycS1naWMtdjUtaXJzLmPCoMKgwqDCoMKgIHwgMjYNCj4gPiArKysrKysrKysr
KysrKysrKysrKysrKysrKw0KPiA+IMKgZHJpdmVycy9pcnFjaGlwL2lycS1naWMtdjUuY8KgwqDC
oMKgwqDCoMKgwqDCoCB8wqAgMyArKysNCj4gPiDCoGluY2x1ZGUvbGludXgvaXJxY2hpcC9hcm0t
Z2ljLXY1LmjCoMKgwqAgfMKgIDIgKysNCj4gPiDCoGluY2x1ZGUvbGludXgvaXJxY2hpcC9hcm0t
dmdpYy1pbmZvLmggfMKgIDUgKysrKysNCj4gPiDCoDQgZmlsZXMgY2hhbmdlZCwgMzYgaW5zZXJ0
aW9ucygrKQ0KPiA+IA0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL2lycWNoaXAvaXJxLWdpYy12
NS1pcnMuYw0KPiA+IGIvZHJpdmVycy9pcnFjaGlwL2lycS1naWMtdjUtaXJzLmMNCj4gPiBpbmRl
eCBmM2ZjZTBiMWUyNWQ5Li41ZGZhMDQzY2Y5ZTM0IDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMv
aXJxY2hpcC9pcnEtZ2ljLXY1LWlycy5jDQo+ID4gKysrIGIvZHJpdmVycy9pcnFjaGlwL2lycS1n
aWMtdjUtaXJzLmMNCj4gPiBAQCAtNTAsNiArNTAsMzIgQEAgc3RhdGljIHZvaWQgaXJzX3dyaXRl
cV9yZWxheGVkKHN0cnVjdA0KPiA+IGdpY3Y1X2lyc19jaGlwX2RhdGEgKmlyc19kYXRhLA0KPiA+
IMKgCXdyaXRlcV9yZWxheGVkKHZhbCwgaXJzX2RhdGEtPmlyc19iYXNlICsgcmVnX29mZnNldCk7
DQo+ID4gwqB9DQo+ID4gwqANCj4gPiArdm9pZCBfX2lvbWVtICpnaWN2NV9pcnNfZ2V0X2NvbmZp
Z19mcmFtZV9iYXNlKHZvaWQpDQo+ID4gK3sNCj4gPiArCXN0cnVjdCBnaWN2NV9pcnNfY2hpcF9k
YXRhICppcnNfZGF0YSA9DQo+ID4gcGVyX2NwdShwZXJfY3B1X2lyc19kYXRhLA0KPiA+ICsJCQkJ
CQnCoMKgwqDCoMKgwqANCj4gPiBzbXBfcHJvY2Vzc29yX2lkKCkpOw0KPiA+ICsNCj4gPiArCWlm
ICghaXJzX2RhdGEpDQo+ID4gKwkJcmV0dXJuIE5VTEw7DQo+ID4gKw0KPiA+ICsJcmV0dXJuIGly
c19kYXRhLT5pcnNfYmFzZTsNCj4gPiArfQ0KPiA+ICsNCj4gPiArYm9vbCBnaWN2NV9pcnNfaXNf
bm9uX2NvaGVyZW50KHZvaWQpDQo+ID4gK3sNCj4gPiArCXN0cnVjdCBnaWN2NV9pcnNfY2hpcF9k
YXRhICppcnNfZGF0YSA9DQo+ID4gcGVyX2NwdShwZXJfY3B1X2lyc19kYXRhLA0KPiA+ICsJCQkJ
CQnCoMKgwqDCoMKgwqANCj4gPiBzbXBfcHJvY2Vzc29yX2lkKCkpOw0KPiA+ICsNCj4gPiArCWlm
ICghaXJzX2RhdGEpIHsNCj4gPiArCQlwcl9lcnIoIkZhaWxlZCB0byBsb29rIHVwIElSUyBmb3Ig
Q1BVICVkXG4iLA0KPiA+ICsJCcKgwqDCoMKgwqDCoCBzbXBfcHJvY2Vzc29yX2lkKCkpOw0KPiA+
ICsJCXJldHVybiBmYWxzZTsNCj4gPiArCX0NCj4gPiArDQo+ID4gKwlyZXR1cm4gISEoaXJzX2Rh
dGEtPmZsYWdzICYgSVJTX0ZMQUdTX05PTl9DT0hFUkVOVCk7DQo+ID4gK30NCj4gPiArDQo+IA0K
PiBGcmFua2x5LCB3ZSBkb24ndCBuZWVkIHRoZXNlIG1pY3JvLWhlbHBlcnMuIEp1c3QgYWRkICpv
bmUqIHRoYXQNCj4gcmV0dXJucyBhIHBvaW50ZXIgdG8gdGhlIElSUyBkYXRhIGZvciBDUFUwLCBh
bmQgZG8gdGhlIGluZm9ybWF0aW9uDQo+IGNoZXJyeS1waWNraW5nIGluIHRoZSBjYWxsZXIuDQoN
CkkndmUgZHJvcHBlZCB0aGVzZSBhbmQgaGF2ZSBkb25lIHdoYXQgeW91IHN1Z2dlc3RlZC4NCg0K
PiANCj4gPiArDQo+ID4gwqAvKg0KPiA+IMKgICogVGhlIHBvbGxpbmcgd2FpdCAoaW4gZ2ljdjVf
d2FpdF9mb3Jfb3Bfc19hdG9taWMoKSkgb24gYSBHSUMNCj4gPiByZWdpc3Rlcg0KPiA+IMKgICog
cHJvdmlkZXMgdGhlIG1lbW9yeSBiYXJyaWVycyAodGhyb3VnaCBNTUlPIGFjY2Vzc29ycykNCj4g
PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9pcnFjaGlwL2lycS1naWMtdjUuYyBiL2RyaXZlcnMvaXJx
Y2hpcC9pcnEtDQo+ID4gZ2ljLXY1LmMNCj4gPiBpbmRleCA1OGU0NTdkNGMxNDc2Li4zMzI5MDE5
NzIyMzYwIDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvaXJxY2hpcC9pcnEtZ2ljLXY1LmMNCj4g
PiArKysgYi9kcml2ZXJzL2lycWNoaXAvaXJxLWdpYy12NS5jDQo+ID4gQEAgLTExMzQsNiArMTEz
NCw5IEBAIHN0YXRpYyB2b2lkIF9faW5pdA0KPiA+IGdpY19vZl9zZXR1cF9rdm1faW5mbyhzdHJ1
Y3QgZGV2aWNlX25vZGUgKm5vZGUpDQo+ID4gwqANCj4gPiDCoAlnaWNfdjVfa3ZtX2luZm8udHlw
ZSA9IEdJQ19WNTsNCj4gPiDCoA0KPiA+ICsJZ2ljX3Y1X2t2bV9pbmZvLmdpY3Y1X2lycy5iYXNl
ID0NCj4gPiBnaWN2NV9pcnNfZ2V0X2NvbmZpZ19mcmFtZV9iYXNlKCk7DQo+ID4gKwlnaWNfdjVf
a3ZtX2luZm8uZ2ljdjVfaXJzLm5vbl9jb2hlcmVudCA9DQo+ID4gZ2ljdjVfaXJzX2lzX25vbl9j
b2hlcmVudCgpOw0KPiA+ICsNCj4gPiDCoAkvKiBHSUMgVmlydHVhbCBDUFUgaW50ZXJmYWNlIG1h
aW50ZW5hbmNlIGludGVycnVwdCAqLw0KPiA+IMKgCWdpY192NV9rdm1faW5mby5ub19tYWludF9p
cnFfbWFzayA9IGZhbHNlOw0KPiA+IMKgCWdpY192NV9rdm1faW5mby5tYWludF9pcnEgPSBpcnFf
b2ZfcGFyc2VfYW5kX21hcChub2RlLCAwKTsNCj4gDQo+IFdoaWxlIHlvdSdyZSBhdCBpdCwgeW91
IG1heSB3YW50IHRvIGZpeCB0aGUgY2hlY2sgb24gdGhlIG1haW50ZW5hbmNlDQo+IGludGVycnVw
dCwgd2hpY2ggZ2l2ZXMgdXAgcmVnaXN0ZXJpbmcgd2l0aCBLVk0gaWYgbm8gTUkgaXMgZm91bmQs
DQo+IGV2ZW4NCj4gaW4gdGhlIGFic2VuY2Ugb2YgRkVBVF9HQ0lFX0xFR0FDWS4NCg0KSSd2ZSBk
b25lIHRoZSByZS13b3JrIGhlcmUuIEdJQ3Y1IHN5c3RlbXMgd2l0aG91dCBGRUFUX0dDSUVfTEVH
QUNZIGNhbg0Kbm93IG9taXQgdGhlIE1JLiBJZiB3ZSBoYXZlIHRoZSBmZWF0dXJlLCB0aGVuIHRo
ZSBNSSByZW1haW5zIG1hbmRhdG9yeSwNCmFuZCB3ZSBiYWlsIG91dCBhdCBwcm9iZS10aW1lIGlu
IGt2bV92Z2ljX2h5cF9pbml0KCkuIFdpbGwgaW5jbHVkZSB0aGlzDQppbiBteSBuZXh0IHZlcnNp
b24gb2YgdGhlIHNlcmllcy4NCg0KPiANCj4gVGhhbmtzLA0KPiANCj4gCU0uDQo+IA0KDQo=
