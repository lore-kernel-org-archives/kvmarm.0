Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012039.outbound.protection.outlook.com [52.101.66.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 773B637C92A
	for <kvmarm@lists.linux.dev>; Fri,  7 Aug 2026 11:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.39
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786101259; cv=fail; b=O/8ofj+Udv40Iye4YRVGNf9ovBHGZD/wzci/YrTUQo/+L7rh9AyrpK0ywFKkw4HJ8XoccrQVlmhXycVi8N5zQlx8GimHjyeYczwR+f65ctc5pOW2zaCYuGs56ko9dt4VQm2+cqGeGgGI+FPH6mlCxzotXGCGG4ftefSCtPYLAUc=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786101259; c=relaxed/simple;
	bh=f7vW0xr8fEuhMjCkDaELzENRPXq27YhsOTb0m4sG8w8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=HzU9nsfIpke9/Qo4kZwEpFxQN/100cNTyk6kjgRgE7RyD/7nSqf/vSiTzAW80C7cHT5GPzJdDOjttxrHQqd1BNDpFo2T4+r+ltZ3hyCzZ55QItiDU9OjUKOihFt60PmYeWY8O5nLzU4tGzgVBcXWrdX8hVYRRlcttz5JU4JYLYo=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=gNj5knES; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=gNj5knES; arc=fail smtp.client-ip=52.101.66.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="gNj5knES";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="gNj5knES"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=v2QYMIYK/+2Wcw7w0itpQ7BRpxeusV1VyDeWcmJRmP6l+XKApxjnYyFn2f7qDwtoEUNbS804shPYCIKBQlQn9lmd6aMdfAN6PsV+62DdY6c+S+kiuMrsEezWWt7w30810P3t0S073aC+yCPjWRIKUVqvPgSzKY+cRcy82LRCDYBzIO0qxFVFxPalyWYRapS+KDb7dAtYq44rk3rZ29GFCCa9g/8t49TsM9JV14aGjOjpowhx1/OHnxy2tv6UVqBbH+Uev+WDA0dMBgoBUWxeglFhOQxjon6u7mgvl6hpo1pIyoRLy6IN6K0Gb6I8zMtJ7dwvIv0vlsT7fEhpMMqufA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fr2i0nvEkGp9HAHVDIoJKXx7M2WYB3EoV3jhKsW5UoA=;
 b=k692VNJxPkRaUyr28ey/yMMotBmhqYzmGzPfjvk0meIVWtASK0qP0W2IK9CH1T3wbNfswxc+Y6ZFPbfsNbUT8a6ktAgQ3zLjCC/QQGAXf9gEvYRYCSfRg7nidPjn7hyRZxdsS/XvitfQ0b2JbLfE8X4EYGAM6topymWx/DXMeuYMQNTZdPFDQtSkuuHy+SwbQDtAB3OrJnLIXX+PmvlUrS6TQxsCeE4M5mRvS4WYQr9cdjGxe9PUgyVDTwY1zXi3Qrgpv7jj60kdtZCXq6rJe1FefEN+hXQL89n+49aSIfLCkymnH9JFy3woU97gg+tvRjV+T6peTWrF6dsHP9QIYg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fr2i0nvEkGp9HAHVDIoJKXx7M2WYB3EoV3jhKsW5UoA=;
 b=gNj5knESqFwmKmBqFa0vwn5QcwthroLjurEl/NS8KBBApDKERifJxfUVByGYwahTGC7DlZfiTKMMUHjZnMjKZizUXZ/GuRcsmx8DE1qJkYPiH1zc7wR9iwZMa/vlaqyjjmt+OFtSNeVfwh8QUHqGQHRu55Jzl2tRjG8rxCrNR8w=
Received: from AM0PR10CA0056.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:150::36)
 by GV1PR08MB8058.eurprd08.prod.outlook.com (2603:10a6:150:96::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.23; Fri, 7 Aug
 2026 11:14:10 +0000
Received: from DB1PEPF000509F2.eurprd02.prod.outlook.com
 (2603:10a6:20b:150:cafe::6a) by AM0PR10CA0056.outlook.office365.com
 (2603:10a6:20b:150::36) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.23 via Frontend Transport; Fri, 7
 Aug 2026 11:14:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509F2.mail.protection.outlook.com (10.167.242.148) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.6
 via Frontend Transport; Fri, 7 Aug 2026 11:14:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jzf6/fZFS203Lj/NhIgzHjpbF6oyTbM9UEgfWmEn9ZsnqLrqHb1Wlz9/aJaWVeuwOzDpyzKDBYuYvbgPoyhcj/9vh1f30Nsuj8//N4fXSz09+xyCBPFDaX/jWb+reRylX+fbJsXjsz/lsQxyjVgrbjjjT2xAWVLqt+wayunMwBHRJX0Fcfp5HJtfzvW9go6EorsL3E1n7DLO0BW0dgEzOOoyQHc5JNb0bFAEMOgS66w3zCnQrYGWkg+nagWy6AU0kS+lSZN9uLMZPCW+x5Q272Lsx+IivJ/OtSRd/TuuBma2351SEdfHLo8T/7MCRlE2nhefNaIqAj5c9EcvfayfOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fr2i0nvEkGp9HAHVDIoJKXx7M2WYB3EoV3jhKsW5UoA=;
 b=KRYJTVrGDgIwk8058xq+z537CPoqLmx3Cp1lKfvj4u43CPVwo8eRgt9BtQxU8DVmT1ff0cUWJz5sBcp6+CAD/QXUSOLPJClxeE+PFdokwT+bKpnLHc+THuEndeG/w2e7EhIvgQDnBztEjN4V1AcFMWT/TCzTzEAYTLcaim6arpr+toVJhhOvk4f4OtdR/olHh5TgJ9SGuRG3A07hMuPFXh3PXY9dd63OG6M1Ds9CIiHik9yjYg/2aUb/lgnIXG3mHMmaHGJYMMmFrmG7Xc+DU6FdgvWrXn6gCMEVe6XSw3ERxVu09iCGcGHh1cYPRpKAv1PG5L5ZU3xnqmWOKqH9yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fr2i0nvEkGp9HAHVDIoJKXx7M2WYB3EoV3jhKsW5UoA=;
 b=gNj5knESqFwmKmBqFa0vwn5QcwthroLjurEl/NS8KBBApDKERifJxfUVByGYwahTGC7DlZfiTKMMUHjZnMjKZizUXZ/GuRcsmx8DE1qJkYPiH1zc7wR9iwZMa/vlaqyjjmt+OFtSNeVfwh8QUHqGQHRu55Jzl2tRjG8rxCrNR8w=
Received: from GV1PR08MB8428.eurprd08.prod.outlook.com (2603:10a6:150:81::5)
 by GV2PR08MB11562.eurprd08.prod.outlook.com (2603:10a6:150:2d6::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.23; Fri, 7 Aug
 2026 11:13:36 +0000
Received: from GV1PR08MB8428.eurprd08.prod.outlook.com
 ([fe80::9b97:c973:3308:5ba7]) by GV1PR08MB8428.eurprd08.prod.outlook.com
 ([fe80::9b97:c973:3308:5ba7%5]) with mapi id 15.21.0292.018; Fri, 7 Aug 2026
 11:13:36 +0000
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
Subject: [PATCH v5 02/49] irqchip/gic-v5: Provide OF IRS config frame attrs to
 KVM
Thread-Topic: [PATCH v5 02/49] irqchip/gic-v5: Provide OF IRS config frame
 attrs to KVM
Thread-Index: AQHdJl3KQVx539nr6E+f1sNlGKe2Tw==
Date: Fri, 7 Aug 2026 11:13:36 +0000
Message-ID: <20260807111159.429128-3-sascha.bischoff@arm.com>
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
	GV1PR08MB8428:EE_|GV2PR08MB11562:EE_|DB1PEPF000509F2:EE_|GV1PR08MB8058:EE_
X-MS-Office365-Filtering-Correlation-Id: 02f20ea4-e881-4d4d-d1a8-08def47500da
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|22082099003|18002099003|11063799006|56012099006|38070700021|10067099003;
X-Microsoft-Antispam-Message-Info-Original:
 LLvcP2MWR0uEPoE8dE6HhrMpYXqXeVqp2g4CCg2ACd7VKMmtI0x5hXfg4LtNh0mnCuu6yYBXq1LGUI11wnYoKmiSKjNmsDKwITobi5euv4fb8DE3WDpv3GhDut036c93GPPlF45aWdmUlPWXCiPexd4mTie0yb23Wz3lMnV3kOrO/E/TspYBXMVB/kDuaN+PCnQDIKyRNBmR3cb3uEfcVi0RQ7qS9lz8QLtR7bojs0KI83V+S+nXY1JIM71k9XJraGUtfUdBB94QAAK7ScKZn+q3LQMi1OElPty6iGCsaP6ORoxaC8K8dPjOf5vvj3sq2t05HMO01e5QLs28zXGNtgGKn7nVFMzt3m7LIpDQ0g6r2bLrtzbD7jGAKutBl6LLzd6+9Ekwws3ORZ/HtaXlARnSJJmW29As41bBVRJqoyfJR+ypc0KwpFQrnKrqSUaqXBX4U+zvRDDMXw/syWAQzV64CUWP+GoCb4yZD1+xs0dglZQ1Gi31bdUyapLR6kKxFVFuP1S03fidAfX7RwS7KQZiWsjcKJng/EzeanMoSEqOhqfanaoeJVwggUG0XjKm2X3kUANSNttIw4DV1be2d7wgEp8CxmlgbLpSUWW5ZxMN70Efy/s3j/6EALsN0g7NTMzf51u8dZOln5j4c87JM2DXsHyDaMjSvxqfAUFXaHF9PBaKwkqWjSvGuGnoGQfoYuP8xttfrvOYXXSFH0XIE02OIWolnhiUN148/o0wQS8=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB8428.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(22082099003)(18002099003)(11063799006)(56012099006)(38070700021)(10067099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 fq/8vQ/b5l07PsB17gGSLING51cfiVmmJdKmiYOVTZbuQBfQtight0sIDnypMdmT/lILO1hkq+qALnyWRFSAC8YRyjlDTOo4QvI32bMoNigCvVZpoU8bL4zTy3OKyE+dKEHwNi03QOSP8EZj55ptgOB8zvKgmh1LGA1dVu3plBUXQ8s1UPFmZE9YJ46TPwz9bB2E2d9u3ZBZqInXuNLvNMN9P+JUXu4DGU47sFtOlEyAsqCf/xJ9Pp4C//mrKKjsc03DUNOO6Ku10pTaLXENS9ANo2Hrt7WTxgOK97PasyjM/RB5I1ldRL4e0fdQXdPPGPfQdkdGJPlW9u77XKcvIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR08MB11562
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509F2.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	3a5a9905-c98b-4735-1b48-08def474ed4e
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|35042699022|23010399003|36860700016|14060799003|1800799024|82310400026|10067099003|11063799006|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	xISx921Ok9B/dMbqKGD9+JTEnqQD/6UBXbVm3gwa2OtxDdalKjszK02/AmxSkpYDAS3bW5IeQReeaSwrwAuW/ccFi8rgsh8x5iRxAgG4A2GOseOD+YY/vAhFNx/eCQbhQoUTIY1+uGOUlnFU+2b+YYx+qxFjyM5EhcIV66uSZjyZrr2MF0vZqyMAtGyz/e4OgaDIGMyh8bxkg7ubHZycVrholDQ3tgT2z6Y7m2q1JuX//0H+TO3LtEMgvjnEi8lMNalYVE5vbc8Rr/vRTIEyviDk+AlzG9ouPHMQFIfZi7gGHp4nvIYiP0Rad7BK+P3RAKmrVNPPvc50q7bzGDEBbS80L2QMsZ8Lg3JlcFbnPqaNT/HH4EbOHsXzA90lRtLIGRDJ9p+c7yNbCsaBlowbvEjYEWqn9D/g48oo8x4Sa9y89esyr5jENS8Uha/zYGeqLXBN6T10m27WnTMn50F+Jiq5k24vd5cfB2ngGkEPn5FWDK4OXIkzynU/MjHa311YDMRE5U2I7P0Ylmz0XYLiH0I0Z7WQVmpA4hMjExFoi98+gUtzXdo/0OM3RfjZMQSMl1QcwbnkDHgFK/NlOZTysP7ShMY1sFgStA0/0+qvW28JaNQe1lE7NtuhLILpbhTgB3cE/PNhVGM5Fn1PCSLqSUMb8ezcNJHWWRR47NW10aJifhr/TAr40Pb3eduarhhoRUfD/LZP9DwOoWV6PIPNhQ==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(35042699022)(23010399003)(36860700016)(14060799003)(1800799024)(82310400026)(10067099003)(11063799006)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	1Ou0piFbD05rb9cDlLlWHOD0YIRjSpaoffN26DDQGFdn0/aINNjfW4dOVUYshqBGAbsgytbsQOydZOVg8RFXGspzbo+q1BDZF6HbqpfMJerqKlE13nxlr8yB2vzydeW5K+2wGtuSGqHzlK6W+CIlo90jArm5jAowa8DGBhRNdQsn7SbTQ0ak2hdikG+9EVTTsm+bgtxLm0PIoF/VLulbQM9W6/m8WuaZWGPX8O882e73rFNmcbl6PB7/xiwW8RqbLcYRot092xAGsR0I2cCDs7rrmRY4DRhvsP0jJNFfA/nH5UEGsHxo5FLY8pyyx7X5h/mBVlZuy6zt6ZJXxH7X18Oxh/zfuKdGQ1ppD1BCnaBD6sYIkJZo8RHVKnwxSaDs0xtw39Qu+csUfssmFkBpL2nzfHsni5oV6kwHAwmRXlsZ/QXT46zlWgbP5QaVaByN
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2026 11:14:09.4868
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 02f20ea4-e881-4d4d-d1a8-08def47500da
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509F2.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR08MB8058

KVM needs to interact with the host IRS in order to, for example, make
VMs or VPEs valid. There are two potential approaches here. Either the
host irqchip driver can provide an interface, or KVM can interact
directly with the host IRS. The latter of these two is chosen as the
set of MMIO registers that KVM needs to interact with is orthogonal to
the set used by the host irqchip driver (with the exception of some of
the read-only IRS_IDRx registers).

Pass KVM a pointer to an IRS config frame - the config frame belonging
to ANY IRS is fine as long as one IRS's config frame is used
consistently - in struct gic_kvm_info. Additionally, include a flag
telling KVM whether the IRS is coherent or non-coherent in order to
make sure that KVM can do the correct cache state management, if
required.

Only OF (Device Tree) is supported with this change. ACPI is not.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 drivers/irqchip/irq-gic-v5-irs.c      | 7 +++++--
 drivers/irqchip/irq-gic-v5.c          | 5 +++++
 include/linux/irqchip/arm-gic-v5.h    | 3 +++
 include/linux/irqchip/arm-vgic-info.h | 5 +++++
 4 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v5-irs.c b/drivers/irqchip/irq-gic-v5-=
irs.c
index f3fce0b1e25d9..607e066821b52 100644
--- a/drivers/irqchip/irq-gic-v5-irs.c
+++ b/drivers/irqchip/irq-gic-v5-irs.c
@@ -21,8 +21,6 @@
  */
 #define LPI_ID_BITS_LINEAR		12
=20
-#define IRS_FLAGS_NON_COHERENT		BIT(0)
-
 static DEFINE_PER_CPU_READ_MOSTLY(struct gicv5_irs_chip_data *, per_cpu_ir=
s_data);
 static LIST_HEAD(irs_nodes);
=20
@@ -50,6 +48,11 @@ static void irs_writeq_relaxed(struct gicv5_irs_chip_dat=
a *irs_data,
 	writeq_relaxed(val, irs_data->irs_base + reg_offset);
 }
=20
+struct gicv5_irs_chip_data *gicv5_irs_get_chip_data(void)
+{
+	return per_cpu(per_cpu_irs_data, 0);
+}
+
 /*
  * The polling wait (in gicv5_wait_for_op_s_atomic()) on a GIC register
  * provides the memory barriers (through MMIO accessors)
diff --git a/drivers/irqchip/irq-gic-v5.c b/drivers/irqchip/irq-gic-v5.c
index c04523a438cee..e7a7aedcfaf78 100644
--- a/drivers/irqchip/irq-gic-v5.c
+++ b/drivers/irqchip/irq-gic-v5.c
@@ -1128,6 +1128,8 @@ static struct gic_kvm_info gic_v5_kvm_info __initdata=
;
=20
 static void __init gic_of_setup_kvm_info(struct device_node *node)
 {
+	struct gicv5_irs_chip_data *irs_data =3D gicv5_irs_get_chip_data();
+
 	/*
 	 * If we don't have native GICv5 virtualisation support, then
 	 * we also don't have FEAT_GCIE_LEGACY - the architecture
@@ -1140,6 +1142,9 @@ static void __init gic_of_setup_kvm_info(struct devic=
e_node *node)
=20
 	gic_v5_kvm_info.type =3D GIC_V5;
=20
+	gic_v5_kvm_info.gicv5_irs.base =3D irs_data->irs_base;
+	gic_v5_kvm_info.gicv5_irs.non_coherent =3D !!(irs_data->flags & IRS_FLAGS=
_NON_COHERENT);
+
 	/* GIC Virtual CPU interface maintenance interrupt */
 	gic_v5_kvm_info.no_maint_irq_mask =3D false;
 	gic_v5_kvm_info.maint_irq =3D irq_of_parse_and_map(node, 0);
diff --git a/include/linux/irqchip/arm-gic-v5.h b/include/linux/irqchip/arm=
-gic-v5.h
index f78787e654f4c..681c5c51207d6 100644
--- a/include/linux/irqchip/arm-gic-v5.h
+++ b/include/linux/irqchip/arm-gic-v5.h
@@ -330,6 +330,8 @@ struct gicv5_irs_chip_data {
 	raw_spinlock_t		spi_config_lock;
 };
=20
+#define IRS_FLAGS_NON_COHERENT		BIT(0)
+
 static inline int gicv5_wait_for_op_s_atomic(void __iomem *addr, u32 offse=
t,
 					     const char *reg_s, u32 mask,
 					     u32 *val)
@@ -377,6 +379,7 @@ void __init gicv5_free_lpi_domain(void);
=20
 int gicv5_irs_of_probe(struct device_node *parent);
 int gicv5_irs_acpi_probe(void);
+struct gicv5_irs_chip_data *gicv5_irs_get_chip_data(void);
 void gicv5_irs_remove(void);
 int gicv5_irs_enable(void);
 void gicv5_irs_its_probe(void);
diff --git a/include/linux/irqchip/arm-vgic-info.h b/include/linux/irqchip/=
arm-vgic-info.h
index 67d9d960273b9..f05370e2debf4 100644
--- a/include/linux/irqchip/arm-vgic-info.h
+++ b/include/linux/irqchip/arm-vgic-info.h
@@ -38,6 +38,11 @@ struct gic_kvm_info {
 	bool		has_v4_1;
 	/* Deactivation impared, subpar stuff */
 	bool		no_hw_deactivation;
+	/* GICv5 IRS base */
+	struct {
+		void __iomem	*base;
+		bool		non_coherent;
+	}		gicv5_irs;
 };
=20
 #ifdef CONFIG_KVM
--=20
2.34.1
