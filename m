Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010061.outbound.protection.outlook.com [52.101.69.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8411E46D092
	for <kvmarm@lists.linux.dev>; Fri,  7 Aug 2026 11:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.61
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786102449; cv=fail; b=aY8uq182a1rjUAvofX9HL4gUkLSIXAIbq44VWiGIj7lX9BusPZ6ApdYaYl/tDZPqRls5eE7mir2IRhKMylh41pkKuYjF4sjUaPrHrylNUh8EdbyGqIq1F8zwC9Je/2JmpPZ9E8Pi8nY+iVEmkqKtNVdjYdR0Z54x3mHCJjvx56k=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786102449; c=relaxed/simple;
	bh=LTF//5qyXkGZjaatD0B9iCpKfYEdXAKwIaKvVibe6WE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ohUkGCNyI0a7W+ffHLmkpPqRzm3IIfhogjHlDHqBptx8bFolW0r6Uue7JWmE86V3p9rhBrVAtpld+03CBBS8KgLZiuU/C5cH1L3KyI+ysOFlFSBgvStOK9mn5vrJmXHq9aupHR3WthwCx6aej+Ux6jfgIzsCCTEUszpsZEVT1LY=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=YLJhjtPk; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=YLJhjtPk; arc=fail smtp.client-ip=52.101.69.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="YLJhjtPk";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="YLJhjtPk"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=xfQZOnMZw3juMKWkngcfIrvEPetYnD12CFMyLcstAsiuGvAThQy7J/4XYVAX8VyUP70/J0Hp7cWH5Rjg8SAm5VwE2SgLWlnjNOHiW+uGnfwPeMnsWEN7xFhslWdrM6+28P3GTT616PlqXVGIV54uI+yuyChw5s3A4esXnQ2eiRBRXnpDEDjWMZw7QEB8TwawS4CwTPTlWqdWJPn+X+SQQ+KwWwHI8dpNBnJernFHOTleHuhnmiXDhlMoEMMDIoB3dt44vwUwtAXjxgJPe3Wsvd1w9HnfA+11wevvpKlA8JcuaDUwSLKkHghgKQ0FzAzhHt6EjtQVbfwa0Zgq43FDNQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fc/spRFCFrN3uW5kKAd7LP81faP5jED02ujhgF0Zwmg=;
 b=IT7qAm3/8VxmPiy3NfaMNpkM6QSlhlrRnTUrwrbXDdaPmceFc/p4XakPPk7pylUBiP92xvXo6XahRJuqqhGcqp+2QWuhDtwwCNM6FPUMqOqT8Wgm5cgFw6KCobuygGPnBDCu3a0U5TVSgMS/t+qnLK4OoIOM8zqcYZXUAwkkf3MigZ3lMf/dNSSJ71BaplQGkfN7gPxF4QvIpFcL837LR1vcuBqcDOB1uJkbHT6/+KG+iNqSxNrA0pVb/XcZOQhliu8EHbmXtKcA2uFI2CYtSs45AUAgsOfMMskFOzQTzx8R6qpaCpdXhTogQ/rjecvkouq9q2xZiIpvJCnZzqwjYA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fc/spRFCFrN3uW5kKAd7LP81faP5jED02ujhgF0Zwmg=;
 b=YLJhjtPkcrAkvYFF6ZTNfFMEJfHDASHPnUkT0+w3BOUReZZ0xoociZGVIxMB2c6ZceWeSqCYSUYzrwrWs6a1rFWaPyg3sRmHSD1v916GxNie7zxmWGRfMGb7VYLF++xkdcHJT345av2869/Hvw3ei4k9SKyUk9q8+CFWWJTosi4=
Received: from AS4P191CA0007.EURP191.PROD.OUTLOOK.COM (2603:10a6:20b:5d5::7)
 by PA4PR08MB5887.eurprd08.prod.outlook.com (2603:10a6:102:f2::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.23; Fri, 7 Aug
 2026 11:34:02 +0000
Received: from AM4PEPF00027A5D.eurprd04.prod.outlook.com
 (2603:10a6:20b:5d5:cafe::3f) by AS4P191CA0007.outlook.office365.com
 (2603:10a6:20b:5d5::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.23 via Frontend Transport; Fri, 7
 Aug 2026 11:34:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM4PEPF00027A5D.mail.protection.outlook.com (10.167.16.69) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.6
 via Frontend Transport; Fri, 7 Aug 2026 11:34:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pjCTIWGtkyFq6S0F+0iGhWQg9qjzGdHmJjl97ieFnk81UKBsaccHMTJJ5gbQcPClaDJm59upp80yK4vj+3bMNTC51iCNATupDJjQj/S30d5yaWBdC+KnzFJ6LsHe1esI24aMLAyurdt8dazs1PosH96IfurrfmFCymkhG0bdvDw0VPg3d5qlihzUmV1tRJnFjB+G2J412RFmbuCI6ThJn0Esew3KSCZQtpsjRRChBlb/rXiS7aVhXehKlsEVSDHDlp1/+HF/MtZp7sWDMRXTZEKGXijrFsjxm2vWMfB7BBOEY8kk58kOUx63eMU8Kh/uX2tk7b8i+YeGPvmIWKsyaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fc/spRFCFrN3uW5kKAd7LP81faP5jED02ujhgF0Zwmg=;
 b=xXHuz7893j7C+SULOkwPbQ+fPe5000YtlkUOFpLT9bEJO3N7Pc0nU3Q+8qX2axQ+i9pou0y2LzQh+fnNRklcyvB6Es9IYlNILi6oO/RSaL+RoLZ3kUSVoaW/Su8EVxcLJ63Keixg38Aam8CDLDJRo8q0TKuVsVqhth1QWBFvWF3VZ/5g+xLeUDt6pAK1roMmuxzx5ngUmiEo0AIm/oETyml2GWPtbwMDNiQWcgf8yT0Dcv298ZOgUCny8rj8IYGAMENqzkBz8FbxO7CWwDswvWK/TbRDbMBlbv4wPtGtaJKj48f9OI4VHABvymUxVWPoUZMgUz1oy23kLo+UHrZ8tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fc/spRFCFrN3uW5kKAd7LP81faP5jED02ujhgF0Zwmg=;
 b=YLJhjtPkcrAkvYFF6ZTNfFMEJfHDASHPnUkT0+w3BOUReZZ0xoociZGVIxMB2c6ZceWeSqCYSUYzrwrWs6a1rFWaPyg3sRmHSD1v916GxNie7zxmWGRfMGb7VYLF++xkdcHJT345av2869/Hvw3ei4k9SKyUk9q8+CFWWJTosi4=
Received: from GV1PR08MB8428.eurprd08.prod.outlook.com (2603:10a6:150:81::5)
 by DU0PR08MB7565.eurprd08.prod.outlook.com (2603:10a6:10:316::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.19; Fri, 7 Aug
 2026 11:33:29 +0000
Received: from GV1PR08MB8428.eurprd08.prod.outlook.com
 ([fe80::9b97:c973:3308:5ba7]) by GV1PR08MB8428.eurprd08.prod.outlook.com
 ([fe80::9b97:c973:3308:5ba7%5]) with mapi id 15.21.0292.018; Fri, 7 Aug 2026
 11:33:29 +0000
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
Subject: [PATCH v5 41/49] KVM: selftests: Add VGICv5 NR_IRQS attribute tests
Thread-Topic: [PATCH v5 41/49] KVM: selftests: Add VGICv5 NR_IRQS attribute
 tests
Thread-Index: AQHdJmCRr0PVBQvioECpYrEqe5Gu+g==
Date: Fri, 7 Aug 2026 11:33:29 +0000
Message-ID: <20260807111159.429128-42-sascha.bischoff@arm.com>
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
	GV1PR08MB8428:EE_|DU0PR08MB7565:EE_|AM4PEPF00027A5D:EE_|PA4PR08MB5887:EE_
X-MS-Office365-Filtering-Correlation-Id: 70cb2cd7-de7d-45cd-2cf6-08def477c784
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|23010399003|376014|10067099003|56012099006|11063799006|6133799003|38070700021|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info-Original:
 95MW8tygftWZab5ZSj4qqyAR1keX4ktrw2L5bW2LcOsIV0Q55WUmflUriUZmVJbDaKMBvJ37jNe74USkxPjzcyl3sHWGXmgnQzGgjuPj59FiDYSiitWzPcCmmIkJozcC0U9qR4LCReqcasEbQxYhwxVL/h/AGXzqKNkfIXUkR1Y6m7GanO47QbkyveGlQz+RNb6NuoBUMGLdZtmlE9/B1FCfNaGXNSqjCVwQjpfMuiHrNWyGtQKgwoJTEsvbo01VNCHyr9LRRlQ9Zq8pGVrkAMjBgVIEKBPRfaonViXx40TGnkaaG2ylu3ED2weer9WFz5F+NdH3+C7r15BNA82qEmH71XHxk5UVpKagzbGHCxvL9s0rXiH7p3ZNs8CGlEOccBzD17Ypb2L954cOks0DMAIoAAf9N7MJFmshjudKnwoPFnjOheUNfgCRTk2d7gOUqsAbA+W8fRU6uy9kvtiMujhwWJGSB8ofFIsoyRpkXMECnWydeX3Vs8XXjMkzupitmY4MwADHARAUnoB98STSGXVlcCE/O2nk8Fpp2vW+WVSunyo9kRJRTOBPbx/7p8irWk7KCCMv0Df3fbZK6QAEYpOr/G0wO+aBOMJN47SWLRF6gAAuYFnq9OjIquH9UubRicbHXUhKCkFBNh4K23w3TUPZjigEuKsbts/idMoklvhIxdzLbnkmsTfTJf0DtUa+JYclAtstF8SGnGXUESxjoyFQDgL+BiW6vBwkPSWOMes=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB8428.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(376014)(10067099003)(56012099006)(11063799006)(6133799003)(38070700021)(22082099003)(18002099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 IHUzbGgO1l5/+GFygcLJKPPh6swkGg/Eh/H6B53MGNQre9omclsuvEOHCR/1SjzZO3KWbHdAeMZ0N6gEyyNWi8UKu4JoshjJ13dWL+bsr7+YJLW6j48in19PnDg6L4zrSSG6GelWB7b6vtUdysOoYdnYtFvTB1B08tpuwX7PLoG5JBWG2V5d/pwEuFsV1ZBWdEa1PhWUeXEVLL41NJ5HleIuKfOEu+tOivnYKBJuKElfm3ncgxAooYajFU+0iEH+3+06vfa5nvFRlvELmsLs0x9s6orgaVWE6cLh4sc6p1uzSB5flPRL3JiALgdD7DWCp7leLuD5vij3tF7hpR3/JA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB7565
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM4PEPF00027A5D.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	16a59ed8-0984-4aba-2a30-08def477b411
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|35042699022|376014|36860700016|23010399003|14060799003|30052699003|82310400026|18002099003|22082099003|10067099003|56012099006|6133799003|11063799006;
X-Microsoft-Antispam-Message-Info:
	toyQSsLQ+ekg64XjVULlgsbCVwDK20S4Glo7v+VW1Sez/NhpWybShBd/7bfkCEPIGYGX5TSpuT6JfCx7LOWwvu37+53FVQIyaC4dmPVYitBY8J9gVVSCQzpKLbMp6E/8ZpbqtUnImREsixnzz5k5FOdZYsk4JDNmfzSAQGXCTUypjdbc5F18d3kExAGH36RUqqd24k4UbisnKQnfwfJ/wbJL9BtmecdCsaZaNzwFOZpbkkFgiHCK7MR4/5loljP/eizAQMbKgdAp+6zOucmTdadRUr2WC842vMo/ZwvTE82XbcKemCxJzHQ3e1K05lANl5eBrdp3aB1bRuMGVlkbvMf0O7J0tHJ2IpOXyxg+nqcmyNLB8a0pHmEchxcCLGy0MwZgJd0cMJom7+LKv+ukk1FFKbLRv75lRzXjoVzI/6JgDT6A1YoAEK+/mAibEhOolL4Mo7/H6sVdnPYdL5V2FrH8qfETw5PysbWdldpekGbaydYGHzo9FVmoFY+kNmSAfLIESIjFvCGFx6/zldTBmQWv7c6xCwzmAJRtFUNXV+7RiZWq7sF+G2gC8Urs1QP97c1iiAOKYl5UHiZirFkYhlLMDBZOL9JBHGyDocserZRdMygNCRwxF9aAbOzyE0a+IaeT7HEUPgKR1Jq2ZN7NsjW24uvMc8CSNSbJ6SauDn8isiihni4R/mVeLHnXSgir3xXoLsDCGdd60OHGyPftnw==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(35042699022)(376014)(36860700016)(23010399003)(14060799003)(30052699003)(82310400026)(18002099003)(22082099003)(10067099003)(56012099006)(6133799003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	HH2slDjnLIC55Q5Bk39pz3dmjxi/SFSiiSY+OFVGsxEKOjovMXaeKb0h7laQ2RczpnL3Ti4aXcKr1Sxjb00lBN8+rqEfkt86ciI/zCgblJjWkrsa4exjILrvFYEdtjM6M21DYZ0OKUfnVDSAehdPnp1VAecYnZMabnvo71X+6c1WhziLqsnslmlbiIZheZQzJaTZHzba5F8ZJMSZI9v82Yejx44U/lsPSx1J8yoou+izmlw+lmgWAvWobBMdZvaqM013eZiZExv5bndPlHjmOCr4rO1iZrgPCm9eDjlV7x2J3bSSWZvghzaZW1jx6QXIEDw5wqCsD9h5hJyE/qSbCDTvSONhzqyMLyLjQnSVOi4feB+d2kAr5yJEyHK2BymEPeLg9lfelWtkhj0whHm96XRG7flbl8429Sa8XIxf4pq5V6FDpbzlTGDBrzVO+oNv
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2026 11:34:01.7787
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 70cb2cd7-de7d-45cd-2cf6-08def477c784
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM4PEPF00027A5D.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR08MB5887

Add coverage for the VGICv5 NR_IRQS attribute. VGICv5 exposes a
userspace-selectable SPI count, and KVM must reject values outside its
supported range or values that would change the interrupt layout after
it has been fixed.

Verify that the attribute defaults to zero before initialisation,
rejects too few SPIs, non-32-aligned counts, and a 32-aligned count
beyond the 1024-SPI maximum. Also verify that the maximum count is
accepted and can be initialised, that the selected count is reported,
that initialisation selects the default count, and that subsequent
changes are rejected.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 tools/testing/selftests/kvm/arm64/vgic_v5.c | 190 +++++++++++++++-----
 1 file changed, 142 insertions(+), 48 deletions(-)

diff --git a/tools/testing/selftests/kvm/arm64/vgic_v5.c b/tools/testing/se=
lftests/kvm/arm64/vgic_v5.c
index 51ea2fe7141ad..f4c0d2c003bb4 100644
--- a/tools/testing/selftests/kvm/arm64/vgic_v5.c
+++ b/tools/testing/selftests/kvm/arm64/vgic_v5.c
@@ -13,6 +13,8 @@
 #include "vgic.h"
=20
 #define NR_VCPUS		1
+#define VGIC_V5_DEFAULT_NR_SPIS	32
+#define VGIC_V5_MAX_NR_SPIS	BIT(16)
=20
 static u64 max_phys_size;
=20
@@ -27,6 +29,63 @@ struct vm_gic {
 #define GUEST_CMD_IS_AWAKE	12
 #define GUEST_CMD_IS_READY	13
=20
+static void guest_irq_handler(struct ex_regs *regs)
+{
+	bool valid;
+	u32 hwirq;
+	u64 ia;
+	static int count;
+
+	/*
+	 * We have pending interrupts. Should never actually enter WFI
+	 * here!
+	 */
+	wfi();
+	GUEST_SYNC(GUEST_CMD_IS_AWAKE);
+
+	ia =3D gicr_insn(CDIA);
+	valid =3D GICV5_GICR_CDIA_VALID(ia);
+
+	GUEST_SYNC(GUEST_CMD_IRQ_CDIA);
+
+	if (!valid)
+		return;
+
+	gsb_ack();
+	isb();
+
+	hwirq =3D FIELD_GET(GICV5_GICR_CDIA_INTID, ia);
+
+	gic_insn(hwirq, CDDI);
+	gic_insn(0, CDEOI);
+
+	GUEST_SYNC(GUEST_CMD_IRQ_DIEOI);
+
+	if (++count >=3D 2)
+		GUEST_DONE();
+
+	/* Ask for the next interrupt to be injected */
+	GUEST_SYNC(GUEST_CMD_IS_READY);
+}
+
+static void guest_code(void)
+{
+	local_irq_disable();
+
+	gicv5_cpu_enable_interrupts();
+	local_irq_enable();
+
+	/* Enable the SW_PPI (3) */
+	write_sysreg_s(BIT_ULL(3), SYS_ICC_PPI_ENABLER0_EL1);
+
+	/* Ask for the first interrupt to be injected */
+	GUEST_SYNC(GUEST_CMD_IS_READY);
+
+	/* Loop forever waiting for interrupts */
+	for (;;)
+		cpu_relax();
+}
+
 /* we don't want to assert on run execution, hence that helper */
 static int run_vcpu(struct kvm_vcpu *vcpu)
 {
@@ -51,7 +110,7 @@ static const struct vgic_region_attr gic_v5_irs_region =
=3D {
 	.alignment =3D GICV5_IRS_ALIGN,
 };
=20
-static void test_vgic_v5_create(void)
+static void test_vgic_v5_addr_attrs(void)
 {
 	struct kvm_vcpu *vcpu;
 	struct vm_gic v;
@@ -125,60 +184,92 @@ static void test_vgic_v5_create(void)
 	vm_gic_destroy(&v);
 }
=20
-static void guest_irq_handler(struct ex_regs *regs)
+static void test_vgic_v5_nr_irqs_attrs(void)
 {
-	bool valid;
-	u32 hwirq;
-	u64 ia;
-	static int count;
-
-	/*
-	 * We have pending interrupts. Should never actually enter WFI
-	 * here!
-	 */
-	wfi();
-	GUEST_SYNC(GUEST_CMD_IS_AWAKE);
-
-	ia =3D gicr_insn(CDIA);
-	valid =3D GICV5_GICR_CDIA_VALID(ia);
-
-	GUEST_SYNC(GUEST_CMD_IRQ_CDIA);
-
-	if (!valid)
-		return;
-
-	gsb_ack();
-	isb();
-
-	hwirq =3D FIELD_GET(GICV5_GICR_CDIA_INTID, ia);
-
-	gic_insn(hwirq, CDDI);
-	gic_insn(0, CDEOI);
+	const u32 max_nr_spis =3D BIT(10);
+	struct kvm_vcpu *vcpu;
+	struct vm_gic v;
+	u32 nr_irqs;
+	int ret;
=20
-	GUEST_SYNC(GUEST_CMD_IRQ_DIEOI);
+	v.gic_dev_type =3D KVM_DEV_TYPE_ARM_VGIC_V5;
+	v.vm =3D __vm_create(VM_SHAPE_DEFAULT, NR_VCPUS, 0);
+	v.gic_fd =3D kvm_create_device(v.vm, v.gic_dev_type);
=20
-	if (++count >=3D 2)
-		GUEST_DONE();
+	/* Check existing group/attribute */
+	kvm_has_device_attr(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_NR_IRQS, 0);
+
+	/* Before userspace sets NR_IRQS, no SPI count has been selected. */
+	nr_irqs =3D 0xbad;
+	ret =3D __kvm_device_attr_get(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_NR_IRQS,
+				    0, &nr_irqs);
+	TEST_ASSERT(!ret && nr_irqs =3D=3D 0, "GICv5 NR_IRQS defaults to 0 before=
 init");
+
+	/* Too few SPIs */
+	nr_irqs =3D VGIC_V5_DEFAULT_NR_SPIS - 1;
+	ret =3D __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_NR_IRQS,
+				    0, &nr_irqs);
+	TEST_ASSERT(ret && errno =3D=3D EINVAL, "GICv5 NR_IRQS below minimum");
+
+	/* Not a multiple of 32 */
+	nr_irqs =3D VGIC_V5_DEFAULT_NR_SPIS + 1;
+	ret =3D __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_NR_IRQS,
+				    0, &nr_irqs);
+	TEST_ASSERT(ret && errno =3D=3D EINVAL, "GICv5 NR_IRQS not 32-aligned");
+
+	/* Larger than KVM's supported VGICv5 SPI count */
+	nr_irqs =3D max_nr_spis + 32;
+	ret =3D __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_NR_IRQS,
+				    0, &nr_irqs);
+	TEST_ASSERT(ret && errno =3D=3D EINVAL, "GICv5 NR_IRQS above maximum");
+
+	/* Valid custom SPI count */
+	nr_irqs =3D max_nr_spis;
+	ret =3D __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_NR_IRQS,
+				    0, &nr_irqs);
+	TEST_ASSERT(!ret, "GICv5 NR_IRQS accepts valid custom SPI count");
+
+	nr_irqs =3D 0xbad;
+	ret =3D __kvm_device_attr_get(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_NR_IRQS,
+				    0, &nr_irqs);
+	TEST_ASSERT(!ret && nr_irqs =3D=3D max_nr_spis,
+		    "GICv5 NR_IRQS returns SPI count only");
+
+	/* A second successful configuration attempt must be rejected. */
+	nr_irqs =3D VGIC_V5_DEFAULT_NR_SPIS;
+	ret =3D __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_NR_IRQS,
+				    0, &nr_irqs);
+	TEST_ASSERT(ret && errno =3D=3D EBUSY, "GICv5 NR_IRQS set twice");
+
+	/* The maximum supported count must also initialize successfully. */
+	vcpu =3D vm_vcpu_add(v.vm, 0, NULL);
+	TEST_ASSERT(vcpu, "Failed to create vCPU");
+	kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+			    KVM_DEV_ARM_VGIC_CTRL_INIT, NULL);
=20
-	/* Ask for the next interrupt to be injected */
-	GUEST_SYNC(GUEST_CMD_IS_READY);
-}
+	vm_gic_destroy(&v);
=20
-static void guest_code(void)
-{
-	local_irq_disable();
+	/* If userspace does not set NR_IRQS, init selects the default. */
+	v.vm =3D __vm_create(VM_SHAPE_DEFAULT, NR_VCPUS, 0);
+	v.gic_fd =3D kvm_create_device(v.vm, v.gic_dev_type);
+	vcpu =3D vm_vcpu_add(v.vm, 0, NULL);
+	TEST_ASSERT(vcpu, "Failed to create vCPU");
+	kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+			    KVM_DEV_ARM_VGIC_CTRL_INIT, NULL);
=20
-	gicv5_cpu_enable_interrupts();
-	local_irq_enable();
+	nr_irqs =3D 0xbad;
+	ret =3D __kvm_device_attr_get(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_NR_IRQS,
+				    0, &nr_irqs);
+	TEST_ASSERT(!ret && nr_irqs =3D=3D VGIC_V5_DEFAULT_NR_SPIS,
+		    "GICv5 NR_IRQS defaults to 32 SPIs after init");
=20
-	/* Enable the SW_PPI (3) */
-	write_sysreg_s(BIT_ULL(3), SYS_ICC_PPI_ENABLER0_EL1);
+	nr_irqs =3D VGIC_V5_DEFAULT_NR_SPIS * 2;
+	ret =3D __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_NR_IRQS,
+				    0, &nr_irqs);
+	TEST_ASSERT(ret && errno =3D=3D EBUSY, "GICv5 NR_IRQS set after init");
=20
-	/* Ask for the first interrupt to be injected */
-	GUEST_SYNC(GUEST_CMD_IS_READY);
+	vm_gic_destroy(&v);
=20
-	/* Loop forever waiting for interrupts */
-	while (1);
 }
=20
 static void test_vgic_v5_ppis(u32 gic_dev_type)
@@ -294,8 +385,11 @@ int test_kvm_device(u32 gic_dev_type)
=20
 void run_tests(u32 gic_dev_type)
 {
-	pr_info("Test VGICv5 Creation & Setup\n");
-	test_vgic_v5_create();
+	pr_info("Test VGICv5 address attrs\n");
+	test_vgic_v5_addr_attrs();
+
+	pr_info("Test VGICv5 NR_IRQS attrs\n");
+	test_vgic_v5_nr_irqs_attrs();
=20
 	pr_info("Test VGICv5 PPIs\n");
 	test_vgic_v5_ppis(gic_dev_type);
--=20
2.34.1
