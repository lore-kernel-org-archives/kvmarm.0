Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013008.outbound.protection.outlook.com [40.107.162.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38D1E43031B
	for <kvmarm@lists.linux.dev>; Fri,  7 Aug 2026 11:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.8
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786101838; cv=fail; b=JmcL+toV5wZxLUU+G9ufLBZlNMnYDKMbVHDTeCT8I9OMRpZTcKfRP+4RinQ75xwoSfVUmiyBh1DY/+e0XX24NqVc7+0sH1QoQsv+bv+2XA5ArghJ3tgmaNckJrcooFoLkj6CrfmWlNpEsopXLlGGCRi9EfYvolY84QW2wEJsvNg=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786101838; c=relaxed/simple;
	bh=bc3BSg2WE3pXkac+qWyDuRYG5fdZUKY4VH+BUk2Dhls=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=JHbbLIW5JIJ527Gb/KgfhTfvoc5qKaexJWEHLBEEplMJXz/7KTj1og3cyJMs0NKWMtkQe8poprNYtx5eABKhl/2kgWyu6VwkX+jbV1AemyDvJRZQtFLdBaWpADTlt9i5r1D9iiuDwJ3tn04zczHQn4PJtPquve+nDVLcUq/Yryw=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=JNiFsJdX; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=JNiFsJdX; arc=fail smtp.client-ip=40.107.162.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="JNiFsJdX";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="JNiFsJdX"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=y3WrNks7XpxU+vqfysF6pFRApjYTa/mGox6Sk8+BvDwlO5Ytma3NhQ25Hw8K66KKCY6+IYQvIXTJeRGbxs7cKXAS7n3MLKUxN4Lx/F6uo8jgQ1DpOA405otazCfuqTaIQKBg+BGlVcE12i83k9r0uOxFo2Hxio/dmw1mi4ZvwcgiZ2oGcEjIRNjyCNMMsgVROBswMX9ZW45kttL3Wr/Sq/UBdQrAOcsT8WFtEAM21MCPp03n5O+7aBTxxB2I+aDDZ9kn86DNuNHk4P2MSsWGjK73l2wosljjOtdFaLvafyVebNv/FT2VJmB+nhej/Zj0NjlPELNJGmh/PqSJoAZMqQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JffFGL0Hb42X42/qbKxxL/clbqQVH9gFDIVB+ljIOzA=;
 b=xNggDQ3G0EbLnMK5pq8RzQrfqbFeAHeizQMdGACsb4eneBUOodV5f7tfvvX8l92cIVwP2GIM/yiHg1CUT1XnP1HLhJqBMJ0yVjisqAlRQbi3Pi0vyP4QFQsGE5UnvXSPXsRX5hrOi4eklTSzUzhfL1o7o7ym1FPHESiQjqgzIc2YBMH0fg9FGOyoQE8o6+EJr2g8lIs9ngz1M5aNPbavfAHAvNO90Cp1KF52AZdvFgbXsyduf2bmVwMhcm+9QvG7DQ1DKiu0U9ViB5Dct5pMKFOAxKh7f+8jkGTKt1QxdkBEPPyPWNO72lj/uE3UBH6KDfs8yh2V0eKygwDOfePFzw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JffFGL0Hb42X42/qbKxxL/clbqQVH9gFDIVB+ljIOzA=;
 b=JNiFsJdXGD8xrTwxdSowcaZh/JLMCUk5Lpjrmxp/JEzi92SGJVSQzajqi9ixpMLVSZ8GetZAJor3wb04Ssf8YAFyJPoQGWhyHNBjgRK3fWxX6Tom4cn+NEqHlijEZGVPyopbRHq1JYyn9cAPYko3VXyJgIFi1guFcmw/4490chA=
Received: from DU2PR04CA0354.eurprd04.prod.outlook.com (2603:10a6:10:2b4::7)
 by DBAPR08MB5781.eurprd08.prod.outlook.com (2603:10a6:10:1ad::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.16; Fri, 7 Aug
 2026 11:23:50 +0000
Received: from DB1PEPF000509FD.eurprd03.prod.outlook.com
 (2603:10a6:10:2b4:cafe::9d) by DU2PR04CA0354.outlook.office365.com
 (2603:10a6:10:2b4::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.24 via Frontend Transport; Fri, 7
 Aug 2026 11:23:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509FD.mail.protection.outlook.com (10.167.242.39) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.8
 via Frontend Transport; Fri, 7 Aug 2026 11:23:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LdfWYpQldmx/EnCV+ZhI0FomLOf39Wf3coyKh+CZFGDmPyCt8qz13EyD3LZBSGATjaoLwgzAGcF9pmF2ZFIY85jm0QOdbxI++NUs9Zi+LqvCCSDfHZCJuFOL53BVQ34zvvglT6KgsGaAI/sQIdcSh7Qng4pZxCPO+FsocIJcLoajNR5AFc+69BJEKcAYwx+XsMVWPthdOtmNXigcQEj6ykmoJfrXpRj1lwK6iE2PTEmCfL7IVE3nV8Q51veieQ5YSclPyao3id6w3PgMy7bfNdo6aMYi8Xkan8lz8ROOa9S23iY733rNMY+bjOujrnIz7AuRSvQqmlkdF6CxhTjvkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JffFGL0Hb42X42/qbKxxL/clbqQVH9gFDIVB+ljIOzA=;
 b=Oepyu5x4dSMCaEmL6cYJ32V3xncWkTZZ6EAVaLnJojdFAREDmM+4kiHUriJj7xnPJO5LAUSZ5i6USXWB9CQG5csO/ZlAoBOaS25AZdK7PIXxnhBZzWjRLbSQ/B4Jbn5yjkpAakWXOlDJ0Yfi0/QLImpSnwIHqR7WMLBS6a6sRQYroEkLUkxdcrQN46/lgbK+z/3J9uPraJgC8nM/hIlOgW4Yw7jX0rKjRB+q4skgz18jN5IGzs3GD8GM6zta+FimyaiiEVBwGxIV5s0erAVZQPdJfDUlVoIZQw+1ccVaq5dQVrDwR7GitDBeLprNeeyEkCYlnTtpN0cBDJQqMdzmrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JffFGL0Hb42X42/qbKxxL/clbqQVH9gFDIVB+ljIOzA=;
 b=JNiFsJdXGD8xrTwxdSowcaZh/JLMCUk5Lpjrmxp/JEzi92SGJVSQzajqi9ixpMLVSZ8GetZAJor3wb04Ssf8YAFyJPoQGWhyHNBjgRK3fWxX6Tom4cn+NEqHlijEZGVPyopbRHq1JYyn9cAPYko3VXyJgIFi1guFcmw/4490chA=
Received: from GV1PR08MB8428.eurprd08.prod.outlook.com (2603:10a6:150:81::5)
 by DB9PR08MB6729.eurprd08.prod.outlook.com (2603:10a6:10:2ac::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.23; Fri, 7 Aug
 2026 11:23:17 +0000
Received: from GV1PR08MB8428.eurprd08.prod.outlook.com
 ([fe80::9b97:c973:3308:5ba7]) by GV1PR08MB8428.eurprd08.prod.outlook.com
 ([fe80::9b97:c973:3308:5ba7%5]) with mapi id 15.21.0292.018; Fri, 7 Aug 2026
 11:23:17 +0000
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
Subject: [PATCH v5 21/49] KVM: arm64: gic-v5: Initialise per-VM IRS state
Thread-Topic: [PATCH v5 21/49] KVM: arm64: gic-v5: Initialise per-VM IRS state
Thread-Index: AQHdJl8kNHJ4D0scJkuPPMPROE2EmQ==
Date: Fri, 7 Aug 2026 11:23:17 +0000
Message-ID: <20260807111159.429128-22-sascha.bischoff@arm.com>
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
	GV1PR08MB8428:EE_|DB9PR08MB6729:EE_|DB1PEPF000509FD:EE_|DBAPR08MB5781:EE_
X-MS-Office365-Filtering-Correlation-Id: ca50f4da-4565-4030-908a-08def4765b27
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|56012099006|18002099003|22082099003|38070700021|6133799003|10067099003|11063799006;
X-Microsoft-Antispam-Message-Info-Original:
 APiqjKcc0jHyyPgqD2KycLTs5IBDTDEztQ9F0LBTjvW60utCzPGda+IPxLJ2O2QvjdJH9oVXrtw3KoJOc53NxbvYEQlnUOadFih0hV42yYI/fzTEa6uUwfOXszm/GiBGWjvxrGRI45VktMhBv16RXSDdWl6c9JQ5J1ousWMT5ZlJoNogVQDgrzoEnhU6y33rp1qo87E6p5K+IvEhPZSnhonwdg3Kt0tgoqc4UdQXI2NscCxpjV4EUNcLtKMaFlkx5dXbPNy9B57rn5wim/9D494uMrSKvonI3j1OhH5d19w8gqtsOYDAUPtQOrq3IGAmC29OHYYNlYtLwhxOQ+HWxKmZWAsqrR3T/+QLFoQS5UizFeZwv30Sjtg5C4O4DBsd8YGohZo/Xp/cFmNGp1Z6EjCzJ7/s91qTCX6ofjs869npZQuGkv/5JXdjaLURVG9Rdbvvy9wZP/v0jE5oKbtbNEPp7rJMyD+X8qfqhwNKF6jlZyWiUBmoifBh6jzLczmSKnWjGb+54J6wH8Y/YY3UOy5nNbZhVzdIbekqfkG9WENqQ/PNrrnB3WswxBrJCxlIznjfwn+tnTqy/WOGL5N0vnK+kp0dXG8uE17KDZNMaIX1Ms/Z/pcf8YSbGM6vH9kmR4Pq8piT5cITeWittbhn4nLrgDLC5qTCXJi1vjGnLLhXD/f3LDfBhutQ4EopZhnwWAT6aum8xfjEhaEpY8SBO7c81Cwp3FZCQu4+i+eA2+E=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB8428.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(56012099006)(18002099003)(22082099003)(38070700021)(6133799003)(10067099003)(11063799006);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 VL19gTx2IQo7ipTsTUtfNgGIaWX6Wg+o7vR6Obe3dUQnCDycoT4hLrpXnrimeXayQKMZCVwiA4EDp2CyEv/leJFiwETYa5uztVz/C5DY418Tp35tbhgAxgMv1ChjaA317SAict1tQcTKXGjJrh5WRBmFTQ5JyQ3hOWKXgDGcyeZNPEX9UA07bexIVtdVkd5Rs/lBN+mhVx+H5w0dJwUSAn8ENeszTxJ9pNzH2rGuKl31DAV+OVKoI58zth/U/uZWCaGm24OQEFRBdTG3zoiZ9pJ4qr0Tg1iOIqi5p4YEMupoKaxo9Kzmf7kwy3tjk5yYCZcxkAdeF8UfBiVaISMWPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB6729
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509FD.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	757fdb94-f9d8-4c5f-b196-08def4764779
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|1800799024|36860700016|23010399003|82310400026|376014|14060799003|22082099003|18002099003|11063799006|56012099006|6133799003|10067099003;
X-Microsoft-Antispam-Message-Info:
	mw6k+vmlM2eNpxYISpQDmeru3BcYoHOZyDjTbKi61vqIzviTh+184ZItv9xHuWtMeQN4D5cjKStyT4frW709S8qziHsxrWW4N7R4xzikPxlv+hhOuoAC5vXC49Y5OhwBYolLN7dQ2+XGFJFpYrrVJH+9FVEP7WMWSYWX3+N4tEswbXdhOhDw+je5wpNTWRwKeyo4dLFirtlgYxWEoS2R4EU9Og+z9fylgEVQgu9+nVrELdHt+Snq3qIwre/U3wi5GQXJ/SgpcXMkEIvcMsOeUjJW+Vxc/RuI4eRqruHU3OwuDOHWjAkx80jLPIpstM7x8hSxjnTT1NmSy+zk1WRSlF2IgXbpF4fKp00GPQnytbHFiEBqPz7HA0HCGm2zfzQxsWJDAbCPQ6cyDN44TEL+L1h83jeEE7S7CVcaSf26ZlVO0xTA14wyUfMWXa/pHfOTmVgTRyjBQyVAY5NiYoplyt1E9NFV7v48BWyqBxOFy3e6HAqWnyDB6UCKdeLzzQLUCaOc3vLKL/1mH+zfLx2vgtZpgTDlgDrnKAHi5myte2RQwL56YihhYKh1t7SXhlSwzDUaKGkNTW1GO9L37rUwFmjyXFY2ba8C9vJsHC0eJf/ki08XTQqGHdb/vdihXej/C+G8Q3zDfCIMkkdmuNwNK7nplnNZLLy9w1Z7NJHPt/1eWJsyHqC2wx5WENP3KdiokbW/78oLJ+cqLI9MmjUEhw==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(1800799024)(36860700016)(23010399003)(82310400026)(376014)(14060799003)(22082099003)(18002099003)(11063799006)(56012099006)(6133799003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	xhq1c9Tknct3nXMWjfMOZaWs1hQ8doa+Ztfkb55gHYM5yz2PrRVMlWgMymgZ9M3iCu0s0RfPmIH5uMhpgLZzMN+ZkIguVz1znEZvbeA6mbGWJiKJkXyJ2G14Jgw+J15snm8qe/wHQcw6t5VCVUVN9tXqrDGTOZQmPl2Nz3HqwrXXgFzCIyOt7ZDU/TbKw43kAweLy91UyWb7yaj22SR2d7Sc5BizMnUcpHTL7KHfo2vIdou0WA0z4wNVsSmUkziCGuqkb9piFu/64C8BawT/4A5WEKvIb1bymlipUEHQ3+Xz/T1fxNjL7G5cb6wEjQpMlLPyyDguPU74hkrGi5l2gjs8Qj2e8g1Io4FdNMOxQuWv4Bt6OuV1mMXzJG4rWeHU9oXOWsSKJrmx10I2A5UusnmUm2K9EUgaERtumvzcVpM4qB/BlVpBw1bZEwC5Svdj
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2026 11:23:50.4716
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ca50f4da-4565-4030-908a-08def4765b27
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509FD.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR08MB5781

A virtual GICv5 needs an emulated IRS in addition to the host IRS
state used to back VMTEs, VPEs, and ISTs. Without this, KVM can only
provide the CPU-local PPI state and cannot expose the IRS-backed SPI
and LPI configuration expected by a GICv5 guest.

Allocate the per-VM emulated IRS state when creating a virtual GICv5,
and initialise it from vgic_v5_init(). If userspace has not provided a
number of SPIs, use the GICv5 default of 32. The IRS init path
allocates the SPI state, initialises the virtual IRS register state,
and creates the backing SPI IST when SPIs are present.

Keep the per-VM IRS object alive for the lifetime of the virtual
GICv5.  vgic_v5_teardown() only unwinds resources allocated by
vgic_v5_init(), so failed initialisation can be retried, while
kvm_vgic_dist_destroy() frees the IRS object during final VGIC
destruction.

This gives virtual GICv5s the IRS backing required for SPIs and LPIs,
rather than being limited to PPIs only. Further patches add support
for SPI injection and lifecycle tracking.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-init.c | 59 +++++++++++++++++++++++----------
 arch/arm64/kvm/vgic/vgic-v5.c   |  8 ++++-
 2 files changed, 49 insertions(+), 18 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-ini=
t.c
index 8e1e844ed6e93..698bca671ffae 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -191,28 +191,48 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
 			break;
 	}
=20
-	if (ret) {
-		kvm_for_each_vcpu(i, vcpu, kvm) {
-			struct vgic_cpu *vgic_cpu =3D &vcpu->arch.vgic_cpu;
-			kfree(vgic_cpu->private_irqs);
-			vgic_cpu->private_irqs =3D NULL;
-		}
-
-		kvm->arch.vgic.vgic_model =3D 0;
-		goto out_unlock;
-	}
+	if (ret)
+		goto out_free_private_irqs;
=20
 	if (type =3D=3D KVM_DEV_TYPE_ARM_VGIC_V3)
 		kvm->arch.vgic.nassgicap =3D system_supports_direct_sgis();
=20
-	/*
-	 * We now know that we have a GICv5. The Arch Timer PPI interrupts may
-	 * have been initialised at this stage, but will have done so assuming
-	 * that we have an older GIC, meaning that the IntIDs won't be
-	 * correct. We init them again, and this time they will be correct.
-	 */
-	if (type =3D=3D KVM_DEV_TYPE_ARM_VGIC_V5)
+	if (type =3D=3D KVM_DEV_TYPE_ARM_VGIC_V5) {
+		/* Allocate a vIRS for GICv5 systems */
+		kvm->arch.vgic.vgic_v5_irs_data =3D kzalloc_obj(struct vgic_v5_irs,
+							      GFP_KERNEL_ACCOUNT);
+		if (!kvm->arch.vgic.vgic_v5_irs_data) {
+			ret =3D -ENOMEM;
+			goto out_free_private_irqs;
+		}
+
+		/*
+		 * Initialization happens later, for now just explicitly
+		 * disable the device and undef its base address.
+		 */
+		kvm->arch.vgic.vgic_v5_irs_data->vgic_v5_irs_base =3D VGIC_ADDR_UNDEF;
+
+		/*
+		 * We now know that we have a GICv5. The Arch Timer PPI
+		 * interrupts may have been initialised at this stage, but will
+		 * have done so assuming that we have an older GIC, meaning that
+		 * the IntIDs won't be correct. We init them again, and this
+		 * time they will be correct.
+		 */
 		kvm_timer_init_vm(kvm);
+	}
+
+	goto out_unlock;
+
+out_free_private_irqs:
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		struct vgic_cpu *vgic_cpu =3D &vcpu->arch.vgic_cpu;
+
+		kfree(vgic_cpu->private_irqs);
+		vgic_cpu->private_irqs =3D NULL;
+	}
+
+	kvm->arch.vgic.vgic_model =3D 0;
=20
 out_unlock:
 	mutex_unlock(&kvm->arch.config_lock);
@@ -496,6 +516,9 @@ int vgic_init(struct kvm *kvm)
 				return ret;
 		}
 	} else {
+		if (!dist->nr_spis)
+			dist->nr_spis =3D VGIC_V5_DEFAULT_NR_SPIS;
+
 		ret =3D vgic_v5_init(kvm);
 		if (ret)
 			return ret;
@@ -541,6 +564,8 @@ static void kvm_vgic_dist_destroy(struct kvm *kvm)
 		break;
 	case KVM_DEV_TYPE_ARM_VGIC_V5:
 		vgic_v5_teardown(kvm);
+		kfree(dist->vgic_v5_irs_data);
+		dist->vgic_v5_irs_data =3D NULL;
 		break;
 	}
=20
diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 2932f3cfbe8f4..6a7dabf90dd1b 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -672,7 +672,8 @@ void vgic_v5_teardown(struct kvm *kvm)
=20
 /*
  * Claim and populate a VMTE (optionally making a new L2 VMT valid), creat=
e VPE
- * doorbells, allocate VPET and populate for each VPE.
+ * doorbells, allocate VPET and populate for each VPE. Finally, we also in=
it the
+ * vIRS, which means allocating and making the virtual SPI IST valid.
  *
  * Note: We do need to put the cart before the horse here. The VPE doorbel=
ls are
  * our conduit for communication with the IRS, which means we need to have=
 those
@@ -751,6 +752,11 @@ int vgic_v5_init(struct kvm *kvm)
 			goto err;
 	}
=20
+	/* Init IRS (and alloc SPI IST) */
+	ret =3D kvm_vgic_v5_irs_init(kvm, kvm->arch.vgic.nr_spis);
+	if (ret)
+		goto err;
+
 	return 0;
=20
 err:
--=20
2.34.1
