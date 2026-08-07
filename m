Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013065.outbound.protection.outlook.com [40.107.159.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F17846C4AE
	for <kvmarm@lists.linux.dev>; Fri,  7 Aug 2026 11:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.65
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786101226; cv=fail; b=TAo8cB92cuWiIsPrIXl4ktydSRjMqy1SWQEycqLTy54DDUXAolwDbiU0KRc49//FRYcNbd8/UDX5YxW+5+fwfhTKKAwsSIk4xgR6uTumE40kzm/0ByW4KwTtMuk2Dpmz9GXIJS+OmaemRSYT2jFRT4AOB1AN9QVzESSIzgo8BTs=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786101226; c=relaxed/simple;
	bh=V9MNNa7cvJCEXOoD1vnyxSmHmBRsM43aXmQv/hryv84=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=H8a0hLURzUVtwgLjr7S9BJ2iMsR8YAwmL977xrPvNwCJq9tLThkfi1IhkOYLx7gb2LDfB4JrKgjEjiRW8rETEPjLUfywNO6kObjX3DdSC0JJlsnJen/KDAKIRUUv8YD7qIC5xFW4R/EIy5zjeTkPhb05E2/ec0Ax3UR97vd11N4=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=rptMaagd; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=rptMaagd; arc=fail smtp.client-ip=40.107.159.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="rptMaagd";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="rptMaagd"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=NptYL7iiUDkG+LmnTM1evzZaVnBnIESwOkAtfFAvWMMPwUn83Fk7tGe76ZvwwHmobuRycjhs5Oog/IkouCqHy6S72VcaOI1yfwtnhml61NCLOOYL1+Zjf7DTdQ5KcJXHvbAb5HW1LtK6faTUgJIQBZ1f0NuErSrv6x6S2P3fiqHRS3MEC2PG+oLFnHIECqXR89z21H8WjfG6sAZjKFXzeTgtDfP82JzvAbeuQaTlY9YO+gLtXZS2UD3S89coLU4+MynkQvKzWvadNwoPz3IVpmrwrxaSvAUSf6rLVJwAMKShMLS/U9Zp6DjVtDghtl53tqR2Yb7GMsRDMaCKFYNFMA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pvq4ZTKhaTZQ53GNsD599tKwpxxf3JS9e1zecB9mH4E=;
 b=egbLKU6+KP64tUx8r4fdiMCTNYcajdxMYNkBo5GFZe5uPQM4JT4LeFJst1zicauAHFBcp3k3cqLQNLTvabBMf++Lg9gEtcFCJ6jIcjNcTxYwT0semCdGKTmq2UL7vmFc4eM4Km08iVWfQ08Itdg8VhMm5nI/893VYf2CSzXst8x1aVYqooIvQ/LCS+D/7abs2ESH9Avw1XwFmxqy5oLjswKqURcQpsF6LYviHjaT3g4qbatkS9/GIrVsyBfIurDQGcky6Q6UMjzqabp3opsR0wNlm5k5AWoZpacNUtWo+ya8YAmk0ww0eepFD9dqh99AKRPXWFjK734RYDA46V3H/A==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pvq4ZTKhaTZQ53GNsD599tKwpxxf3JS9e1zecB9mH4E=;
 b=rptMaagdHMY/sl3nimv/fp2exYfhYd0qKJhmlZr+RymnvzbGEIKLA3gpCYXve00hRYBM259f8/giMvsFJZshakk/6yr9AZA1zUGTKBcZMcDXCWczKr04D15Q0q+sZwWK/53dK4nDuxAbJTjrz4lqWnVDX7wg1gt9FXPVFfrLU1g=
Received: from AS4P195CA0011.EURP195.PROD.OUTLOOK.COM (2603:10a6:20b:5e2::15)
 by VI0PR08MB11824.eurprd08.prod.outlook.com (2603:10a6:800:325::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.21; Fri, 7 Aug
 2026 11:13:39 +0000
Received: from AMS0EPF000001B5.eurprd05.prod.outlook.com
 (2603:10a6:20b:5e2:cafe::81) by AS4P195CA0011.outlook.office365.com
 (2603:10a6:20b:5e2::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.23 via Frontend Transport; Fri, 7
 Aug 2026 11:13:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF000001B5.mail.protection.outlook.com (10.167.16.169) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.6
 via Frontend Transport; Fri, 7 Aug 2026 11:13:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kmnqJjMiuhN76wO3ImUzSE88PFtII9XMnwDQjljvYs4QXfIqJER+vDtpgfH4CZM3SG2Up/mqUhIFLo6bKuWdAPkeQfguuNi6Pfc6UMTpeF34WRYxUZ5jq6GCfBLI7z6GE6JiJJtegQFi40hP4T1a/zCUjwRxAcdLQZNml+ciDCdg9Gf+TO/1Dxu0cASr8SEQSHFEDbG0fUFchZvdVkQxQ1oAU4xnAwh+khtZb1EEbqyCqXeStLlnUg1ULV1q1crLk8+FRRL4U5mruVRxe9f4+RcztUirnir3Ve5mwHKGL+tLUDd21Uwd0oLNCQtaQ9+DLmaaZarvMor0EeCAkSBOFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pvq4ZTKhaTZQ53GNsD599tKwpxxf3JS9e1zecB9mH4E=;
 b=Y0wCZS07lNj3knVrx9RqGRvM9pSw1odkpOZGUp3J5Mglz9eaanw25FxFbFPhqvJbUau+Nj5GXUhKE+8iSUjZSQWLkYJsHN/aL+VtQuTM50aaXw8mI/GjxGcnHYh6K7/ns7TQNGF9mQzcWTlSEevvNBPq0ZYBrfcRzn7iIiC4nxsuz5WuJM5S2QQf1mn5+Cgj7AcQHKduzsPkdETmPmRpVC6gLZYjQBLQU6ciJVQDOiFzbrW42VWqM565EPa3j7U8i6xIAQPUEs0o7stiSDpmPZgAHQMVH2V3sYLB5gEylatUIPxJZCkHEGJN7nfOHMTZjSYX3MFHySQaATApljwIpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pvq4ZTKhaTZQ53GNsD599tKwpxxf3JS9e1zecB9mH4E=;
 b=rptMaagdHMY/sl3nimv/fp2exYfhYd0qKJhmlZr+RymnvzbGEIKLA3gpCYXve00hRYBM259f8/giMvsFJZshakk/6yr9AZA1zUGTKBcZMcDXCWczKr04D15Q0q+sZwWK/53dK4nDuxAbJTjrz4lqWnVDX7wg1gt9FXPVFfrLU1g=
Received: from GV1PR08MB8428.eurprd08.prod.outlook.com (2603:10a6:150:81::5)
 by GV2PR08MB11562.eurprd08.prod.outlook.com (2603:10a6:150:2d6::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.23; Fri, 7 Aug
 2026 11:13:06 +0000
Received: from GV1PR08MB8428.eurprd08.prod.outlook.com
 ([fe80::9b97:c973:3308:5ba7]) by GV1PR08MB8428.eurprd08.prod.outlook.com
 ([fe80::9b97:c973:3308:5ba7%5]) with mapi id 15.21.0292.018; Fri, 7 Aug 2026
 11:13:06 +0000
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
Subject: [PATCH v5 01/49] irqchip/gic-v5: Allow KVM setup without a
 maintenance IRQ
Thread-Topic: [PATCH v5 01/49] irqchip/gic-v5: Allow KVM setup without a
 maintenance IRQ
Thread-Index: AQHdJl24jkdi8eemjka+LkpivtHy0g==
Date: Fri, 7 Aug 2026 11:13:06 +0000
Message-ID: <20260807111159.429128-2-sascha.bischoff@arm.com>
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
	GV1PR08MB8428:EE_|GV2PR08MB11562:EE_|AMS0EPF000001B5:EE_|VI0PR08MB11824:EE_
X-MS-Office365-Filtering-Correlation-Id: f9357a00-5df5-4c64-6284-08def474eedd
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|22082099003|18002099003|5023799004|11063799006|56012099006|38070700021|10067099003;
X-Microsoft-Antispam-Message-Info-Original:
 ARlr6fHlHn4DQ2v/DWJB0fis7pscagXJkh+R4pivUAI0ia26sz6SJMF4uctorNF87EVRlFLw1s+lj39vceNpmlmXYKwZWWqhshdjL8hQL6PDqi5njesN9Xk+A9fUzpo+O+Gbyt9PqMi+TE1jXupHPxu/7xhqrfQM86AEiD9vRbqWsza5McuWnLN2LlI74N/hn3aqKqkBKhhGnPfy7tZM6m5v1xchosk0kumKQNm7nYJnVsCDAlE6xxGXVZqFhKvpTYrmIMawj4MFhL2h31URgxsB3A4rTIm9vZ6tQDseNe5pegGiq40KHF1g5Xxp2/prQOWO4iiJGCLSl163Jl7AbiGo4ahQWCi/x1sZSfcc50I9xX30qaLTUeAzWu+vZeG0/yH7/m5FP8U+h81gj8dyY/G4WJie4oLkmlJrrmCJZg1OEm73tbeCLTmmc5ChVKtOnN5P+/yL1vR/h8sweP7TubFDPJCRGKtpCcOnUe8fBS1k4gNwlHhdMn4g/Vzi0cuQ11dRU2BiicbjZht1gIF1jlrBSRxuqvnDKyFzl+tv1HKTLb7bBqKLhtem9BmaE+wV9/XZcNmPEIJzgWQo7ha3FjYQsfGKIiqeI/ArQLOi8o/vOfybnHwXkoWifuK7/VSCgiLdbHsXtIT5N71leWzO8zVneOA+1s70JXUShkVuMSiPMMjKuSBNMiaJ3W98WWVY+74VcQtwwsZSQY4l6jnv7JKvPRvoa5Xn4JAKfLQouRY=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB8428.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(22082099003)(18002099003)(5023799004)(11063799006)(56012099006)(38070700021)(10067099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 q/XUgWODcc5p+UMaZsS8ovccM1gvHmgtYVW3aTFlW0G0MmjhPOlRlf9Bi5aWf9lURjejO5u4WqzI0DASqX4Pq517eM+y1mLI4vBmqIOIP9+LwCh14teUKbgteVcbWU6/6YCpDQqpVu3lkyUqPwD6Op8dZX7i8/uBtRn0M/wGC5MQC27Ly/9n9QrHPgjrVxCvxQMg+8WycZmMdSen8Ns7/kex5ZCJeRVRBHRamUXXyFpTVGWmy8053ehwc6pYxcMyx2jOCEirB9Cq7R2jRZup7pw6IeHKbtV0sqVmjTamDgtJxUwbed1m7A9p9/dF/4vhFxCYUirEN5UWWSFflcth0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR08MB11562
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF000001B5.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	dbb08667-d765-4ead-b026-08def474db0d
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|23010399003|82310400026|35042699022|1800799024|36860700016|376014|22082099003|18002099003|56012099006|11063799006|5023799004|10067099003;
X-Microsoft-Antispam-Message-Info:
	VqCiXcNXu/HUdGmtvcNNi2/ZVVoAryV4HmMUmvkKlJ3ZN1wSjc8LKbwFXx3b6a/3nr7hQGJPsmH0/MFxhDEzLw4yv6Jl+SKpVP3IrEPDsxxHhokKcgicaz1zHHxKSGle3CrAHNOFeeeTI8ieIEhIXhAx30ke8F6/FbYzRnso/ywIF9wJyNqm+qjr0eqN9YLlVb6dataIxI8FGONP+HUsoXTqQ/VrSTdxqE8GfeKWceUPIjgYLIm3ckog1XzX15LchMoqRSaofxtWiKrPN3mAdvfFxQ+X1tagyGZipE6kYWBjtK5sndReSVM8c/Qp6Z/r2KpAEy1zuBc8sGP+k83A96KTwFsEh2y5D/q0GuRbesMed8xv8dSym5h3/l1dKsjf7oXsLRw2Eh1nf5JCGns+TC04TyJq5lVhYGZWNAWkd9oM1ANPeQj0apriOP6vNmedH60SzFcOGhg/nKicnFqKxx7pb+3eMHE5JA6FEsZ0mS36P8bjX9YJsjyXafB3pkdz5i7pm80S1LS/fGyH42C6CRWFru0onHJHJKYxJTGNyjv9KwcDsZZR4XK1dEuwEPVRTTK3aNbSO4UYa3xZfh/eg1sI5eJe70UYZfAd4w12aj23ACxj6cwuyvT4juuoT1Xdqt0DJ6l2fc/pW7R2EI5BPigIqPorSjZsbY7Jqko/lUnA0JvkmxkA4VfPiS4yXJQoOmc+SK379EkrsdnXQZfLTQ==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(23010399003)(82310400026)(35042699022)(1800799024)(36860700016)(376014)(22082099003)(18002099003)(56012099006)(11063799006)(5023799004)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	CIPu28brg+wqFJjR5qz13RucZrwimJIb0K0OPEeVsC0pXZ2KUhsLrveni1G3lreDSYi6N7qVOS4Q1qaibTvHlYLVfKZJLRAkA8rNS2UfcXGR9l8mJhzEyDm94ClDjNu072tJdO4qUhRaysjDRHhcko8wJ9n6+rrzTCz9zqH6mXoCMbXLoEdArEv4VGxberItD0LBH6zAFc8OcPxQpeNrP2hBum0DMMbGlV5873LEzGg/yQcwqlcXjXZxh5DcaXL8jeEoDU+1Ttf8DPOsT7gI+39M/Kf81ooVYmw9tpRHI7FkuOk8GFUoUITo/ZPecDulLBI9zG6hL+hvg0qxtSZJ9WBSGbnQgsyIKJmmct74AzlHd1/hZa2peDvWMWZBtC10DuZavEzgR9a+BSj1UNHNStIVqddR4T4hH8AmR3NZSG7miLfBmtxvgTSSL0HSr/Nb
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2026 11:13:39.3138
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f9357a00-5df5-4c64-6284-08def474eedd
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF000001B5.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR08MB11824

GICv5 does not require a virtual CPU interface maintenance interrupt
for native GCIE operation. The interrupt is only needed when
FEAT_GCIE_LEGACY is present, as the legacy GICv3 interface still
relies on maintenance IRQ delivery.

Stop rejecting KVM setup solely because the maintenance interrupt is
absent. Parse the interrupt if present, but if none is described and
the system does not advertise FEAT_GCIE_LEGACY, tell KVM that no
maintenance interrupt is required.

This lets native GICv5 KVM support be registered on systems that do
not provide a maintenance interrupt, while requiring a maintenance
interrupt for GICv3-capable systems.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 drivers/irqchip/irq-gic-v5.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v5.c b/drivers/irqchip/irq-gic-v5.c
index e9d1795235a66..c04523a438cee 100644
--- a/drivers/irqchip/irq-gic-v5.c
+++ b/drivers/irqchip/irq-gic-v5.c
@@ -1143,10 +1143,18 @@ static void __init gic_of_setup_kvm_info(struct dev=
ice_node *node)
 	/* GIC Virtual CPU interface maintenance interrupt */
 	gic_v5_kvm_info.no_maint_irq_mask =3D false;
 	gic_v5_kvm_info.maint_irq =3D irq_of_parse_and_map(node, 0);
-	if (!gic_v5_kvm_info.maint_irq) {
-		pr_warn("cannot find GICv5 virtual CPU interface maintenance interrupt\n=
");
-		return;
-	}
+
+	/*
+	 * We require an MI if we have legacy support, but don't, otherwise.
+	 * Given that there's an existing flag to convey that an MI isn't
+	 * needed, we (ab)use it to tell KVM that the MI isn't needed if we
+	 * don't support legacy.
+	 *
+	 * The check for ARM64_HAS_GICV5_LEGACY explicitly doesn't use
+	 * cpus_have_final_cap() here as we run too early.
+	 */
+	if (!cpus_have_cap(ARM64_HAS_GICV5_LEGACY) && !gic_v5_kvm_info.maint_irq)
+		gic_v5_kvm_info.no_maint_irq_mask =3D true;
=20
 	vgic_set_kvm_info(&gic_v5_kvm_info);
 }
--=20
2.34.1
