Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011007.outbound.protection.outlook.com [40.107.130.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9BCF431A3C
	for <kvmarm@lists.linux.dev>; Fri,  7 Aug 2026 11:21:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.7
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786101691; cv=fail; b=IhjFYPETRSY5pe7BY2joQI08dmWnvE+oVYMmOc/+lIbx3QJcCXoL8GfIaoy6mRZWdp2UED+EjzKBssJKLX/GnDbzHhW3I4JjAwlp8DNFRm0hCdSh+kdMwvvbgInHlapAtyvCK2HtZqAwUdTYT7QppvNnhgq8cUyoR94FHuGcKmA=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786101691; c=relaxed/simple;
	bh=XO0mltY5YWrgLguMZ22izWR76voJr0238rJXgC5nOIw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=mPztB7yY9tEXcvKUTXljOqi22mVKIbt05mCwlW8K1TmFLZr4dtTR/HjYCcMf06nxv411AQGQkTAwysjl1xPFL6A815WZEN0MhMJmfhW9Uo70uJ0fAGzZbd9scGKsDZZZRQTVKq+vlVe37p3QpS4/3vSgji8r0QLEGhbD0j/5wlM=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=arYshVEv; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=arYshVEv; arc=fail smtp.client-ip=40.107.130.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="arYshVEv";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="arYshVEv"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=Xj48b99/P2Rn1uDmFFZrjlwurf9RulWvAJvcyejDGLGl4WhV1PfMKRt+BuqyvrRV5rWzlqps7xGryB6P5YdpkDonrrub3K9SoExY/Mx2eQri+lvEU1EcYqVSq/rT/geM7t9HunIW7pbXjmwRg2kDaWeMgeznNIW0KGe1JcbTbxHxI6imRCDc5mGKUbqKlK5n59FKEX2cJGatvkVRaSU+Ma2ZETh+nd3gg9Y/SgIdj12toTCng+3LLvwliQysPEJJ6EcWXfYo4kPKwsHXGT8XVFtM46S29LsPLk8/myl7+dChINR/E5ZROy3/UdYoFzlLESaj40nDtP7Ee/IAvxLR1w==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IFjS/5qT4MQpcnse4A5/dMnqF7FqJR5+FFIPTeoPLPo=;
 b=pGCeh+eJxxFuQZthN5PMymJjHviUFSlTk7YjZOpjNaRxrL9MY1ndVcd/xfhg5PculHln37z+Vajo3fPq2aeIQk7RlzkYxAJnh+SyG74VAwlFERjLPQ6DQ5duJLWx5VrBVu2nYylgXzbQZ2k/+XAkkMXld/buxOu0CO6w15rk6yDt12/w+xkQQB82DpUizX6dXXnT4vn5wNYdaHmK5yIMN5PUPZ586LXqzV6eV3wWGVtcftldR5bbiwUIcgOHUB9QR7kcorIJQZs34NRXzd2+OFseGhMxlKI0pNabWRJ2eTKpb5dJkL9rIKMCwXcnnNTAkw+b4zG/jfsV37GB9ZNIcg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IFjS/5qT4MQpcnse4A5/dMnqF7FqJR5+FFIPTeoPLPo=;
 b=arYshVEvyoNPcFXduhet1SINeDQvVVkgfwa7RmHjeEreCT/1marqVnulrKQAwotAF9yINdWSaNyGHW8haLgFypQ0DYvQe9NPq2qz03nAtutgu3RiNOj2uy7ZELIxEZlkZlvmQeUVrkp9fXkfm6Wn0hkyMA0eKPPRt553rd+IP9U=
Received: from AS4P195CA0018.EURP195.PROD.OUTLOOK.COM (2603:10a6:20b:5d6::15)
 by DU0PR08MB8731.eurprd08.prod.outlook.com (2603:10a6:10:401::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.21; Fri, 7 Aug
 2026 11:21:18 +0000
Received: from AM4PEPF00027A68.eurprd04.prod.outlook.com
 (2603:10a6:20b:5d6:cafe::43) by AS4P195CA0018.outlook.office365.com
 (2603:10a6:20b:5d6::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.23 via Frontend Transport; Fri, 7
 Aug 2026 11:21:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM4PEPF00027A68.mail.protection.outlook.com (10.167.16.85) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.6
 via Frontend Transport; Fri, 7 Aug 2026 11:21:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=coc5yt0cQFZXN1sMsfzea6YaesDPscW8qMuExMgHlqWyURYQuzXZodtva4dDp48HAuDs/DOuJQPq9vQm0hVqTxycsVG2ZFGfj+gbyBYUmlze9nwKoGbkZqIDDzT48l3pbUVQR/oskqIiEoLMBcOmUt+jUxO6l9Fsj0AhWb+D/dx/31AdhzPIhpc17ng3OrfbuTuMBUuMCRuXK8QhpDRYzmLVooF7jkw8ok4AmrSjOxrtEw6dLxEuCawgmanVjot4KUaTkP6Ag4FPNhreiHiAN2MxiZFKLXJ5LW3BMRBmKOLmDlPsiWRK8QeC7x+H8s864VJ08QSbIRv/5rO7lMP4oQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IFjS/5qT4MQpcnse4A5/dMnqF7FqJR5+FFIPTeoPLPo=;
 b=jdXCZ0t4UAUfb95x4vevC93tNJPKG1kl+SH+3fDruD/Jgj8erVXXHaRxIJHfftPfTgS2Jk5e9tFUmcjZ89Paj/D0PErAMm895ZozyzdpRxJLP0fapSvUCPpojDPbLohGcbYrhqh1da1yJp8AvCKxrUUMACd8MQx4A3fDCNGR4U4EPtVP8+VW7iFElUmPv7ktYZKKzSrINQTQlijYze2F2JixZgU7EM6LrwREGoZh63pAYzqXJj4d/f9zhUtHKYoLMLfYaEnXikz4Jyo5GTZTWfS3Ow1AmrYQeNTsbucqJlvf8U9QtWT+26ts7otu1pJCZWMa3Uaq8GHvyGC8paTo1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IFjS/5qT4MQpcnse4A5/dMnqF7FqJR5+FFIPTeoPLPo=;
 b=arYshVEvyoNPcFXduhet1SINeDQvVVkgfwa7RmHjeEreCT/1marqVnulrKQAwotAF9yINdWSaNyGHW8haLgFypQ0DYvQe9NPq2qz03nAtutgu3RiNOj2uy7ZELIxEZlkZlvmQeUVrkp9fXkfm6Wn0hkyMA0eKPPRt553rd+IP9U=
Received: from GV1PR08MB8428.eurprd08.prod.outlook.com (2603:10a6:150:81::5)
 by GV2PR08MB8725.eurprd08.prod.outlook.com (2603:10a6:150:b4::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.23; Fri, 7 Aug
 2026 11:20:45 +0000
Received: from GV1PR08MB8428.eurprd08.prod.outlook.com
 ([fe80::9b97:c973:3308:5ba7]) by GV1PR08MB8428.eurprd08.prod.outlook.com
 ([fe80::9b97:c973:3308:5ba7%5]) with mapi id 15.21.0292.018; Fri, 7 Aug 2026
 11:20:45 +0000
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
Subject: [PATCH v5 16/49] KVM: arm64: gic-v5: Request doorbells when VPEs
 enter WFI
Thread-Topic: [PATCH v5 16/49] KVM: arm64: gic-v5: Request doorbells when VPEs
 enter WFI
Thread-Index: AQHdJl7KxhfkqiSaIE2YpLmrTWFajA==
Date: Fri, 7 Aug 2026 11:20:44 +0000
Message-ID: <20260807111159.429128-17-sascha.bischoff@arm.com>
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
	GV1PR08MB8428:EE_|GV2PR08MB8725:EE_|AM4PEPF00027A68:EE_|DU0PR08MB8731:EE_
X-MS-Office365-Filtering-Correlation-Id: 936bceb0-5a0a-469e-c6a9-08def4760030
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|23010399003|366016|1800799024|38070700021|10067099003|11063799006|56012099006|22082099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info-Original:
 AZn4XZKg2VKwXlNZFNJ7bY2xfDcKTtPWfzBhWSg5cV3d6ZErtJQ7s2EDwQhJPFsbp48K4mQkdqQjgPqT34Xc6aJSd16JH02FZcP5TsnOOtV4J8hK1R7YYtmbBebOx/1P93fqwcoGiRSs8+8nnUOvxR1rOKaQ0m10G6gjMvntprMtqAwXAxukxbKAMASUZ+45ld4MHSNEO5Xl4trBhjuwHeFK7ug562Bg3e26EqT+AJlCDG8IvYbX/2YPXx/yai4tN3qISmOz5w+3i9zQW9MXtm7nu70lKENZi9dKMkjNaXORPCbPY30XNMFkGzO3myJmRldRNcS4/w9K0jQzKe9ItuCMHS1Sr0ovwF7uMfztoDLi9Ugf78doLQMRlq0TGH+CMNdx0vLhEnRB/UkdofFAk1+eM+udaKXPa08pOT6PaVlQecDF2KU5X8iDwDpk8fBwQsYHvn1cdWs7USMnmzBkTQesMIyoBNu7fS6VNJKExa4+dmDHZ2irNMBRL6miKOpnSUimbaNdtibkAzZdupzZ0Z0aSHMollz4ygF8o+bkqlOjTxKdVHFlCmA5N6a0zNXYL2Riu9eCiNX6LSZYWgYK6kf+Q1P9jlAyvTDkKfRpB1V7qDQJmYcNJGI9ZnzO7W6yoC8w/jV8RosRcfzx4vvHb5AX1ELKqfuinwH4be8pkhoiMtzzzIW5kXpzewbVz16THK+aNtIz58dlDq9LFX9Jgci752yuV6hAcKqGZw20FSY=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB8428.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(366016)(1800799024)(38070700021)(10067099003)(11063799006)(56012099006)(22082099003)(18002099003)(3023799007);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 XLA4DtyPGmZdwmrLaxcbJwjyMS59B8IeIjQnKcTKx9wbvt+tE/5AwrzLML1VXoYRCEnuRJcC6UtgIOxCIMMm5x8hc2oPAz767fNfI6OWaF6yAO27ecTQUmQJSjRx/u5D4e7MugejZvNSv1jzbkIxbC7lffYEILVD4r2iv3ODxRdXtVFLYNrUMY+iWDkaXzs+oHP30DkpmYAuh5AmwdsZH95no7ZwFdIV70IZEzqVu/h+fLhjQZ/vzTYVUdFDJodYbUkfFA/PSQkfsa0sZb1fOQsn+sHNd5h07Vf28cvYEOfKrbyWd8aEcXyuu2m1fzIkLP90GWV9Xh31mtEGUM+yZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR08MB8725
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM4PEPF00027A68.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	953ffd7d-bffb-4474-bc6d-08def475ec81
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|14060799003|82310400026|36860700016|35042699022|23010399003|22082099003|18002099003|3023799007|56012099006|11063799006|10067099003;
X-Microsoft-Antispam-Message-Info:
	ncDbQBqsB1oYkRj3NpgSwmUpjpiYQRiI3voaY4jfUJJTRXG2umB6blxO6TbK0Kt/W9+3emvHfSADk56N7lr1MRype4RXjMCrQA9C2sFp1VQxnHZsZrQXVKMPuG6zdTS2TCmEvv/MEsx9PcF2gSYIzF+pljfMRn7rsYj12FCGqQ8l3u+wT6dSZi5QZ/7vFEbLCz3by97w1sPFA31aitp3SRqp0rnWwMknukg3xG197QzLzEHF50xaQi5NmojlWNoyeJ+fyiYyERZ3bY6yYbM3p0P6/IbWrQMBh7+PBLR7VkUV3Pa0fQovfo5WC69sL18GSb36uLTBpGNhnppAZgPaiy9tEhGh10YQpmcHLptpEOxQ1IjNQtNDJ5kPqZRDTQ972bYYjqGHUNMm9Dkb0C0zuD2DgCfkdUW37M7vzXkANbIPd9hKfGSGkYbGC0vaGvsDdDiFJCyUpipP3+ZR0l7/FAgcg+TTz6VEaMQMJReqlobX3EKUv4cJo3Ftb5c1L6U1kMyhQoVAcAeU1uX8UdW+nlPuPr2mh6FwdEevDPaYxsZIq9xnJ+GpO4ChQlxHvr9aZUDr6ezOGxHcu3YGlANK75n0/ir/PisFfxSAut4tZRTC89VwI1uutu2VfkmKBGo676B34MeavimIQ5Rbqy0lEaDe73b0M7plUzH7ikT3QhH3YNDGBe9tPOwgq+FQyBFI3nPdLrIoVrqMoG1LwpmwDg==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(14060799003)(82310400026)(36860700016)(35042699022)(23010399003)(22082099003)(18002099003)(3023799007)(56012099006)(11063799006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	HjSmEMrxnNxkAADEMT7g33iRY5NI/xFs/zkIdjEuZTA0t4NfMIB9dUcPK+cD1MvJSHxijJP2MA6g6LogoY0Gc/fykHwNOodXtWnk94IYxeCtf4i2S3xagkMUfd6QJt0f3FntTb7YZePpOIM55dN4vkFrbhX2sEadZFdxanEvADNquqiBH/FuG8FOVgJXt4LkmTwnmLRr2csdwcLGtWJsTmccJHPY4XtWPTXpXagtDwHMZPlDyrgNBPqnM89fytOE3VsS1xj22hZjc0juLB5/FSMjrBA2SLG2SNrWJ0H/Tnptushvsk97YeyV1OjZLIBEl1BL7U+ppYTYoQLoFQt/4J93lIsup+TdUSeLGsrZruQmOUdnus8xO2IFzHuAIeL7TxIOxhjce1Zow12d6b1aki2LiZBDAb1JAcBPGRNaeBM+y9NU7mIf6tTJDR7iX1/u
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2026 11:21:17.8705
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 936bceb0-5a0a-469e-c6a9-08def4760030
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM4PEPF00027A68.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB8731

When a GICv5 VPE is made non-resident as part of the vcpu entering
WFI, request a VPE doorbell so that KVM can be notified when a
suitable SPI or LPI becomes pending for that VPE.

Program the doorbell priority mask, DBPM, from the effective virtual
priority mask before making the VPE non-resident. DBPM is the priority
threshold used by the GICv5 hardware to decide whether a pending SPI
or LPI is allowed to signal the VPE doorbell. This allows hardware to
signal the doorbell only for interrupts that the vcpu can actually
take, and avoids waking it for interrupts masked by the guest priority
state. If no interrupt can be signalled to the vcpu, leave the
doorbell request clear.

Make the doorbell interrupt affine to the current CPU before
requesting it. This nudges the wakeup back towards the CPU that last
ran the vcpu, where the relevant state is more likely to be cache-hot,
while also spreading doorbell interrupts across host PEs as different
vcpus enter WFI on different CPUs.

Clear stale db_fired state before making the VPE non-resident. Any
previous doorbell notification has already been consumed by this
point, and clearing it before the non-resident transition ensures that
a newly fired doorbell is observed.

Finally, teach kvm_vgic_vcpu_pending_irq() to report pending work for
a GICv5 vcpu when its VPE doorbell has fired, in addition to the
existing pending-PPI check.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/hyp/vgic-v5-sr.c |  9 ++++++++
 arch/arm64/kvm/vgic/vgic-v5.c   | 40 +++++++++++++++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic.c      |  6 ++++-
 3 files changed, 54 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/vgic-v5-sr.c b/arch/arm64/kvm/hyp/vgic-v5-s=
r.c
index f064045a31aee..46992a6c2cacb 100644
--- a/arch/arm64/kvm/hyp/vgic-v5-sr.c
+++ b/arch/arm64/kvm/hyp/vgic-v5-sr.c
@@ -22,6 +22,15 @@ void __vgic_v5_make_resident(struct vgic_v5_cpu_if *cpu_=
if)
=20
 void __vgic_v5_make_non_resident(struct vgic_v5_cpu_if *cpu_if)
 {
+	/*
+	 * Clear the db_fired state to ensure that we're ready for the next
+	 * doorbell when it is requested. If a doorbell firing caused us to
+	 * enter the guest, then we've already consumed that state at this
+	 * point, so this is safe to clear. Use WRITE_ONCE() to ensure we're not
+	 * racing with the doorbell firing and setting the state true again.
+	 */
+	WRITE_ONCE(cpu_if->gicv5_vpe.db_fired, false);
+
 	/*
 	 * Make as non-resident before actually making non-resident. Avoids race
 	 * with doorbell arriving.
diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index c36ae9e07ae26..2932f3cfbe8f4 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -1099,6 +1099,46 @@ void vgic_v5_put(struct kvm_vcpu *vcpu)
 	kvm_call_hyp(__vgic_v5_save_apr, cpu_if);
=20
 	cpu_if->vgic_contextr =3D 0;
+	if (vcpu_get_flag(vcpu, IN_WFI)) {
+		u32 priority_mask;
+		int dbpm;
+
+		/*
+		 * Find the virtual running priority and use this to calculate
+		 * the doorbell priority mask. We combine the highest active
+		 * priority and the CPU's priority mask. The guest can't handle
+		 * interrupts with priorities less than or equal to the virtual
+		 * running priority, so there's literally no point in waking the
+		 * guest for these.
+		 *
+		 * The priority needs to be higher than the mask to signal, so
+		 * pick the next higher priority (subtract 1).
+		 */
+		priority_mask =3D vgic_v5_get_effective_priority_mask(vcpu);
+
+		/*
+		 * Request a doorbell *unless* the priority is 0, indicating
+		 * that no interrupt can wake the CPU up.
+		 */
+		if (priority_mask) {
+			int db_irq =3D vgic_v5_vpe_db(vcpu);
+			struct irq_data *d =3D irq_get_irq_data(db_irq);
+			const struct cpumask *aff =3D irq_data_get_effective_affinity_mask(d);
+			int cpu =3D smp_processor_id();
+
+			dbpm =3D priority_mask - 1;
+			cpu_if->vgic_contextr =3D FIELD_PREP(ICH_CONTEXTR_EL2_DB, 1) |
+						FIELD_PREP(ICH_CONTEXTR_EL2_DBPM, dbpm);
+
+			/*
+			 * Make the doorbell affine to this CPU, if it isn't
+			 * already. Actively check the cpumask first as it is
+			 * cheaper than changing the affinity every time.
+			 */
+			if (!cpumask_test_cpu(cpu, aff))
+				WARN_ON(irq_set_affinity(db_irq, cpumask_of(cpu)));
+		}
+	}
=20
 	kvm_call_hyp(__vgic_v5_make_non_resident, cpu_if);
=20
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index 74bace10a22ed..45af0287d6587 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -1233,8 +1233,12 @@ int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu)
 	unsigned long flags;
 	struct vgic_vmcr vmcr;
=20
-	if (vgic_is_v5(vcpu->kvm))
+	if (vgic_is_v5(vcpu->kvm)) {
+		if (READ_ONCE(vcpu->arch.vgic_cpu.vgic_v5.gicv5_vpe.db_fired))
+			return true;
+
 		return vgic_v5_has_pending_ppi(vcpu);
+	}
=20
 	if (!vcpu->kvm->arch.vgic.enabled)
 		return false;
--=20
2.34.1
