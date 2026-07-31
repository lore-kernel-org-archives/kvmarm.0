Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010052.outbound.protection.outlook.com [52.101.84.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 726903B14D0;
	Fri, 31 Jul 2026 09:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.52
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785490407; cv=fail; b=pQIL39+V4etlRtvjzS2yAN15vVv8hWLKbCme6DdE4AnfA+/ZuARWjYQMMutHCSjlkSUaFHS15I09rlzq9dK+0ZNZLThnk+kh84lgKp8TGOd/xoJkGoG4p9z8zqwGrYOXqN6SgxJGfqUPO4maGOiNRwnRu8Rf23UV7HxkOjh0bJU=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785490407; c=relaxed/simple;
	bh=nRUa8owVZPWWFDRRiQPXRg99tekaAUNlq8wtoKtEPfw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=pdXDhmpJnpB5YAg8ywmrTiEH6fynA+cKaQil64fw7phr3jOxmh7Iqfm3NVomsAR4e/8IHdbseT16+OunOcZb48aP5EDaoJuFJFv7HLV0rMg3rWhc3h5AdWFG/ueRy+gj30ckyUuyxqiTh/cMNLE1JZn0QHZiPFDOQfd+DzJMsJ0=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=hY4g2Ka8; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=hY4g2Ka8; arc=fail smtp.client-ip=52.101.84.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="hY4g2Ka8";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="hY4g2Ka8"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=GBYLEB2TJ691IaNJfZEYSSMADDULTEyocREbaK92Rhy2MEOgINSohsT45Egpf4ClTu/prei/Qnhh8A3QtZD5ac5z1mpBG92xtff05q/Z8ig0nzRR6Y59piGe0mnK0yZ7FZPA9bE31+3eriJj7xf0tXauEYbMCRm3NsMZX/mLcz6pM/gtyCTvp6hVqpYnzTfsqkg0V5Y6VN9hd6H5ErwU8uByxhSRLofNs0fCMdIoLLgye5nL/sXI71HJU37t05p3cAKIRBpgnvZqWw9kNU4/qKljWZHsxnTNmr9lh+ZQWvq5zU9B8NyJHORrGIKYmPmJL40CkI6SODrwvlB8ODqasg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nRUa8owVZPWWFDRRiQPXRg99tekaAUNlq8wtoKtEPfw=;
 b=Xrz8FTp8GkvZeHzfgdunpoSG9xEPkv/khJShodUDuRFbBUvsB3wdMCxdNthbuchHPeP15bV7sQh+5HpCsEdz+vIkBkDOPSZRMcaJEcieB3KAVLzh/pAJopCLJQsEDXyI3l/tqS9buKDeRfnVWoEtRxrpDN5hBQujVjxocGJFD/3RWlZ9wAQLMb0NZ0yjal1B/6SZ+ClfG7nXB+1IVNtVrGeAZ81Y9+9TUd5i9z8gBPuA0eCRqVsQuuOpw4D080X+ejBePEuADN3wVSA8FEi2kY/uxNjP2rm64I7bUq6NsDo47PZgIdkCTuOk/LiIR7VMKWwcZAi+XX6hcnZEX6kA6Q==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nRUa8owVZPWWFDRRiQPXRg99tekaAUNlq8wtoKtEPfw=;
 b=hY4g2Ka8PtjR6cF3QCcfsFR6dMw9S+31gfGulHlnP/E7KvKCyumyQwZ/5e5orucsCxwCcw32Ti/eDudItBWRAPgnCDfqA3RhNWX138JSmkZR6eqFAqPShR+uO2HwcgIZl4GiLcnQXqJzBgM8lNmlNAXm72SMVz8DQQ5xSlVw8ws=
Received: from AS9PR06CA0265.eurprd06.prod.outlook.com (2603:10a6:20b:45f::34)
 by AS4PR08MB7554.eurprd08.prod.outlook.com (2603:10a6:20b:4fc::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.15; Fri, 31 Jul
 2026 09:33:19 +0000
Received: from DB1PEPF000509F3.eurprd02.prod.outlook.com
 (2603:10a6:20b:45f:cafe::ac) by AS9PR06CA0265.outlook.office365.com
 (2603:10a6:20b:45f::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.15 via Frontend Transport; Fri,
 31 Jul 2026 09:33:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509F3.mail.protection.outlook.com (10.167.242.149) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.8
 via Frontend Transport; Fri, 31 Jul 2026 09:33:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FKC3MzRek+5YlWOSpCYEbMjBdQR0W/n9OWhqS6fscA/sJgcBD02peqBh4R/mNOfu2ILnavrvNRgg8oNVeRS45sCZpIei3W8wPM9w1nK+wQhdLdNXybt9QH1tzxWNBRlFdaeFHu4voG7FFxI9GpOdgOmdlCPQZsv9x7yq7+l1fQv3woG9M73HCzAtFtrCbObfyXkyV/giWJZ1xPkR/grqTjYDz/MoNH4dFPXM0sEzeotUTPRNkMlhjdAKCg6NEVvHhwQsKuyM4LjaKJWSdh7xXiJA52tKtDbWNReCmsGwKhB8jRAzyz12Y3MN1LczAj8XK/GMEzMIq//9jeACynd/YA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nRUa8owVZPWWFDRRiQPXRg99tekaAUNlq8wtoKtEPfw=;
 b=CzxvDpRLRiQVxo4z2pWFiBQUQvpD1jY0ZDYG4ZqNgcvwzbVkZ9TU+dXNd5Glkmc4Rvv8DBMsn41v2gg7WkegXLIZIETr4cslyxMpCzZ1TNWa8tnqIf4bVUHNl6+aTMFbiqU6PUFV6vKMdyalNkJgLfA/c6TmrDGNeMLIzJTpOQg/FtRIEtG8cq0F231Vi1/onx6az1fz9vPcW3x20vtHXLyNUJ/em9qKbZbT0WAFw1RCPQTD8v7skUK6YCoPP/SFPltKvC5FHtPJ/7ZS4T+FoaQ07WPD1ot+WjvaIyZXuOVLw5LqfDRj/iPcmecEBQY9lOgo36cvOYPclgoLNT7yBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nRUa8owVZPWWFDRRiQPXRg99tekaAUNlq8wtoKtEPfw=;
 b=hY4g2Ka8PtjR6cF3QCcfsFR6dMw9S+31gfGulHlnP/E7KvKCyumyQwZ/5e5orucsCxwCcw32Ti/eDudItBWRAPgnCDfqA3RhNWX138JSmkZR6eqFAqPShR+uO2HwcgIZl4GiLcnQXqJzBgM8lNmlNAXm72SMVz8DQQ5xSlVw8ws=
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com (2603:10a6:10:407::19)
 by GVXPR08MB10861.eurprd08.prod.outlook.com (2603:10a6:150:154::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.15; Fri, 31 Jul
 2026 09:32:15 +0000
Received: from DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e]) by DU0PR08MB8421.eurprd08.prod.outlook.com
 ([fe80::2158:1cab:1d88:ba2e%5]) with mapi id 15.21.0270.012; Fri, 31 Jul 2026
 09:32:15 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>
CC: "maz@kernel.org" <maz@kernel.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"oupton@kernel.org" <oupton@kernel.org>, nd <nd@arm.com>
Subject: Re: [PATCH v4 06/48] arm64/sysreg: Update ICC_CR0_EL1 with LINK and
 LINK_IDLE fields
Thread-Topic: [PATCH v4 06/48] arm64/sysreg: Update ICC_CR0_EL1 with LINK and
 LINK_IDLE fields
Thread-Index: AQHdG1org3jaXTCfYEatWTNEozH+CbZ8hF4AgArj2wA=
Date: Fri, 31 Jul 2026 09:32:15 +0000
Message-ID: <b81b92407122cecf0c395b8ca94f8a3ae24b5e13.camel@arm.com>
References: <20260724104819.1296803-1-sascha.bischoff@arm.com>
	 <20260724104819.1296803-7-sascha.bischoff@arm.com>
	 <20260724111405.63DD51F01833@smtp.kernel.org>
In-Reply-To: <20260724111405.63DD51F01833@smtp.kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU0PR08MB8421:EE_|GVXPR08MB10861:EE_|DB1PEPF000509F3:EE_|AS4PR08MB7554:EE_
X-MS-Office365-Filtering-Correlation-Id: 143b50ac-2f29-46be-7526-08deeee6c1b6
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|10067099003|4143699003|11063799006|6133799003|56012099006|18002099003|22082099003|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 jnBEm8KxblHvqxBvL7AVCPGhZOlQbnGRupJJsOQ+CFnVxQ9uz6yy1+qPPv7TbqMZJoi2k7yEQvpUUsNPYtqREQjvBjAw0CT6j/NPmnWUotn7YR75tlHleXnGvNZ7vTPf2+Q+U1VZHesJ9za+LNs3N5XJwCt3bCNeWmCAEFrlMgi1D8/MjPlqxhP9GT9VahJU4AwcXG2RZPXyxkzrUFpyiK02rFIuM7/fJ27G8tVuv3JS2UIjDYfAEVYcmsX/8wS0+9DTXTNKubWdGdz304HBKKXI5TLbSZneW3ssEIVPnKMDzvAPcpuzFxL017HywHk67FQ727QyB3d8+G/CQKf+V9uQAOjzAcWs/+ihqq7Te/EvdrHanSydbprHb4eq0tvpkxt+/h0vmxuxBlFRu4HZWFE57c8wBVRwBpEqZQ3mLakp/7j8sXdtFlHeeeKgfhdIbHtMKyqpghhwkwbCYRVpAtV3fakGl6+WL3Om3NmY+qQwyifK2Szyw2jLkSjGvBkefDrr3PYMVukfhTpv4+EEOvcGLUl1tmVRHx36nZ/a4pXw3NIBNmiymatvZMMja359kJ2H9P1s4vTQ+LpF3ckxpl3lEssfWzPNQsoNev3x8stMHx4afmvHD/YnY6xrUCCg9gJ0EQwWXU6e+K4ffUVDSls+N3mj1G+0Jaresr3BbMSOCOgL5hZWNiknjNZtV6ynp+F6uK5ZxQU1M/3FfYZfyXcDCa/hQLrFArmK6BZmeVI=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB8421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(10067099003)(4143699003)(11063799006)(6133799003)(56012099006)(18002099003)(22082099003)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <008530707EB2E4479170771D135910E4@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 NBXDUeX9vuOudHZYvgNuD4PLIkWDdA8x8llp1ZmDj6N93cmx6LRMIBHOdYXFJQzrlqHWH1c/mC2iyIEBEsfd+f/T+4wT1YFCfQBksLIsdPjraJrMpDaHb9yMyAGy4kS1YeJ9deAM+QAeaCTOzB7CDex8B3e/MxpKgQo8fmvU4TuzD3ZFOLuGU37q4P/St8cfxxCb6K1k+AiRstpZ5RtT0Yci/fmez5c1qaKE8+b2K8xLIG2LxWGJ9+a+AXl+quhv2Kz/Dgn+Zx9L3SWb9/XNyQqUdk/KEdF2cXPATxb9JiYZEl4mwAvydH6CIUteNDaTI8riJRE8hkAlg2aHHG7XWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR08MB10861
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509F3.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	b1c8ebdf-91a2-43b6-86fc-08deeee69bce
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|36860700016|14060799003|23010399003|82310400026|1800799024|376014|56012099006|10067099003|18002099003|22082099003|6133799003|11063799006|4143699003;
X-Microsoft-Antispam-Message-Info:
	Ms4k7ADpT3VpOZ7L42db2NoW3hkJkdVQewn8mN88HvUCMO3xaHHC3x+KgC0JxI+l4Nxoi2Yq5Olze1hVF68WF6SOZuC03dN+sM7B21LseW8+694nA5oZPQ8CF1g6+6S/Jhk1oUkY4IOfBP0wSFmFvtUxb89yQuSY6JJosN47Yjlz/PR+MFncyZOOzEsXbrjXJZcXl9c3YBhPCSrCi1H6iRQ/WCWZSju6F7w6E6jwpo0b5QALexZ57sHWUncIpiG3mpWoJh/etQVV0q9A3vSMZelOvWOHIaKF1/tIk1uoa8dboKiTLKP6g/jb4Vu+t51m1jBcFn/OJMYAcONGP4/XB34Qzjp5FgbOpFhkgrlK+rldO1UG9rH4rDOV320EOa3LMQt8PxWw1NJmS853HsruAuA79Buo4zgH64Zx09/14Xj9pJpGkpUmSn/8qrHEf46U+rvclrij5zS5YM1yLVmgORAptVdSG9/QHrils2rtviqXBoGIpGsdLfXiLMpbRGNQXlwE7HzGVjt4Epgu4RLFv3BlXTLGDD3f9Ooq49thc6nw9BCTzsuws4jVUhTAZEhNQIT3jllLtZMDDju88A2TsRxDyiX2UQJ2nPQTubcVQCZ2L404m73LZ4dYIN3f/snFf8pQG61KS+qdMBBmCcIX+nABNdGDIAlnsH1PXQtHKVziPvmirA2cRqlhQ/cVqVllqSyp32S2PbS5z6LxeQDw0g==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(36860700016)(14060799003)(23010399003)(82310400026)(1800799024)(376014)(56012099006)(10067099003)(18002099003)(22082099003)(6133799003)(11063799006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	K21Tfwz6/kpHjE9b0CULub69rdOJrOZoGf/pDdInvchfiye0cxXPM5P6hT1CqcRr8sl0dAFOUfGtPie0F7f4RCUYhAVuTwcc16SpEr6UU6LVlYOL9UhcjwAntBYjX3dymTQzqUJWUCDztyouIO6UW97nFLdrr4Yqrdx4lUeMhSDg/4CVM4TS3iuPvaKZ/qmTe+spj0oYyYxACt31hNrBkiBG8BXqrpQeN6jdglOr8if/wZE3AkjxJuLKiIGuNSKUfLm3DCM2FIdz+vmSBtBrNJWS9HdIOGyP3GRAEcddwYO5IPhgqRm1Kyryp4XWXgHNbETdibv8ciaxsR4/gs3x8lgfv40puATx48QPKTWFT4mb2yJkYRDExyrznDPU6G5tHlus77O420YVN0gTMYJcMY1V1EcHMDMXzsvEfLbM07dGoJ0DLVuO5CDmnpDodzhm
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2026 09:33:19.2024
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 143b50ac-2f29-46be-7526-08deeee6c1b6
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509F3.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR08MB7554

T24gRnJpLCAyMDI2LTA3LTI0IGF0IDExOjE0ICswMDAwLCBzYXNoaWtvLWJvdEBrZXJuZWwub3Jn
IHdyb3RlOg0KPiBbU2V2ZXJpdHk6IEhpZ2hdDQo+IFRoaXMgaXMgYSBwcmUtZXhpc3RpbmcgaXNz
dWUsIGJ1dCBzaW5jZSB0aGlzIHBhdGNoIHVwZGF0ZXMgdGhlDQo+IElDQ19DUjBfRUwxDQo+IHN5
c3JlZyBkZWZpbml0aW9ucywgaXMgaXQgcG9zc2libGUgdGhhdCBjb250ZXh0IHN5bmNocm9uaXph
dGlvbg0KPiBldmVudHMgYXJlDQo+IG1pc3NpbmcgYWZ0ZXIgd3JpdGVzIHRvIHRoZXNlIGNvbnRy
b2wgcmVnaXN0ZXJzPw0KPiANCj4gRm9yIGV4YW1wbGUsIGluIGRyaXZlcnMvaXJxY2hpcC9pcnEt
Z2ljLQ0KPiB2NS5jOmdpY3Y1X2NwdV9kaXNhYmxlX2ludGVycnVwdHMoKSwNCj4gU1lTX0lDQ19D
UjBfRUwxIGlzIHdyaXR0ZW4gd2l0aG91dCBhbiBpbW1lZGlhdGUgaXNiKCk6DQo+IA0KPiBkcml2
ZXJzL2lycWNoaXAvaXJxLWdpYy12NS5jOmdpY3Y1X2NwdV9kaXNhYmxlX2ludGVycnVwdHMoKSB7
DQo+IAljcjAgPSBGSUVMRF9QUkVQKElDQ19DUjBfRUwxX0VOLCAwKTsNCj4gCXdyaXRlX3N5c3Jl
Z19zKGNyMCwgU1lTX0lDQ19DUjBfRUwxKTsNCj4gfQ0KPiANCj4gQSBzaW1pbGFyIHBhdHRlcm4g
b2NjdXJzIGluIGdpY3Y1X2NwdV9lbmFibGVfaW50ZXJydXB0cygpLA0KPiB3cml0ZV9wcGlfc3lz
cmVnX3MoKSwNCj4gYW5kIGdpY3Y1X3BwaV9wcmlvcml0eV9pbml0KCkgZm9yIHJlZ2lzdGVycyBs
aWtlIFNZU19JQ0NfUENSX0VMMSwgDQo+IFNZU19JQ0NfUFBJX1NQRU5EUjBfRUwxLCBhbmQgU1lT
X0lDQ19QUElfUFJJT1JJVFlSMF9FTDEuIElzIHRoZXJlIGENCj4gcmlzayBvZg0KPiBvcGVyYXRp
bmcgdW5kZXIgYSBzdGFsZSBwaXBlbGluZSBjb25maWd1cmF0aW9uIGlmIGFuIElTQiBkb2VzIG5v
dA0KPiBpbW1lZGlhdGVseQ0KPiBmb2xsb3cgdGhlc2Ugd3JpdGVzPw0KDQpBaCwgdGhpcyBhZ2Fp
bj8gTm8uIFRoaXMgaXMgbm90IGFuIGlzc3VlLCBhbmQgInN0YWxlIHBpcGVsaW5lDQpjb25maWd1
cmF0aW9uIiByZWFsbHkgaXNuJ3Qgd2hhdCB3ZSdkIGdldCBoZXJlIChvciBhIHRoaW5nKS4NCg0K
VGhhbmtzLA0KU2FzY2hhDQo=
