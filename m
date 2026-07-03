Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011039.outbound.protection.outlook.com [52.101.65.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1609C2C21EE
	for <kvmarm@lists.linux.dev>; Fri,  3 Jul 2026 15:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.39
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783094299; cv=fail; b=imx7bsoElKI18/WfZhHguFGhNMse1k1tF/uMY19Jz9YAGX4owNdO2pFSwPYCPgpgMgXIZn+BETeCzjoM8PGRls4vxpTMrH2mbDjVmBQysvrw0jbIZZROzJZP+Yghe7VLCRhHb1awvUu47AJVS8Ub8raKp/9le5S+gTfO+Bw7WWg=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783094299; c=relaxed/simple;
	bh=BfnYuB6HuNH1OUTir0uxHpzToW9/twOB5FyoIkQdOg0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=r4ylL+3VUAcdj07aUpLTmqGB8dty/Ax8a8Lrxrjb0pkAKra9laUNk2XJwR3PqqpalJlc+riGXVJHSe0Mmoo0jD2XGYRMv2sdEUsse+lwCTDB00xU5QX6eE0xnua2IcfjH8CpVaXw5YXbwn2/KTEKRQhzA17hOG145/aIsh51R+4=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Z2BrX0ps; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Z2BrX0ps; arc=fail smtp.client-ip=52.101.65.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Z2BrX0ps";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Z2BrX0ps"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=kvemzab5MFrnZotvvt6QhxUdwnz2bavGkF/FrRV4VX/iV5EU81364Jg8pXeN2UL8rUNBpODq6NeXJnIxn6N/3ha2ODHDmhTXwm7nTlECnlNlfarYWpWwFD2ajApzA5mUbYLhoDpD1pN2oWdPBPtrd22LOsUuKf/rET2wNBa9cq70i6/4m+fXvl+rFk95zDN+n+joi2eA4pbUvpATw5n9JMHb3wcGvTZcr43Yoow4qL5EJcvB131e6V9DQBDU7l0onP5cWtAX0EdN9fEnAsQNMu8+kpZoqBMJFxufiwPLO+vRZwYxVLa9OY6aKxrdkN3GEnRnjf/ma5pojQ82Ic5irA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z9FZ6Jqp8uHJ39gwPjelSye//c4Mr59/5Q8Zn32ZNN0=;
 b=x0Ow5Eq+dvnZZyKK26192JX8SeYUvKG5DGooqF1u2jvAg2K0ZHRJ/1dWuMGLQhLwEJ64+TSLvt6RtiVnEM3X//CL9eqesbLFrk9cSxapWRJX1YsDjNgozNYH8QABjQ28q1fqk/tbpzca/XgFE/VWq7T6dr1spHxm4wQcvp8t3cJUFZqAu/HGaf0fu6e8lHKkD1bQLb2sIk8swtlIFMJxouVDy7bg3L/XjhDpnFOqiDeG7lRR0DLmS8cZmoUAa6vjcJqSigUfb/eR0E1IrUdd5AcgB6LYD4U2gESL8iHXKCwGUkmKr3OaObO1Q7uFQh6TGxqkv411VO8MV5mf5+0FTQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z9FZ6Jqp8uHJ39gwPjelSye//c4Mr59/5Q8Zn32ZNN0=;
 b=Z2BrX0psFMKPP70EnwEVo89DqiTxwj/kR6B89eDGJXVRza9jICculNBYTSXd+mGKaTx34jGnQE3lARnfniRIER2Ns5Zl0+HPG+XRgE3H14EoF+EuMxacXjHJDmMDodU+n50o7qZT+Pu8k/xHRI9u+1vKR7ltxY2Sm9AQS01/6CM=
Received: from AS4P191CA0003.EURP191.PROD.OUTLOOK.COM (2603:10a6:20b:5d5::18)
 by DU5PR08MB10659.eurprd08.prod.outlook.com (2603:10a6:10:51b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.11; Fri, 3 Jul
 2026 15:58:13 +0000
Received: from AMS0EPF000001B3.eurprd05.prod.outlook.com
 (2603:10a6:20b:5d5:cafe::4c) by AS4P191CA0003.outlook.office365.com
 (2603:10a6:20b:5d5::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.11 via Frontend Transport; Fri, 3
 Jul 2026 15:58:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF000001B3.mail.protection.outlook.com (10.167.16.167) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.6
 via Frontend Transport; Fri, 3 Jul 2026 15:58:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=G6d9fWzvNkMOlAM3mNVtryhmaqg55kgjBb7CwZZqVsTGJlxatmpaCP4UGvWFPm3QQWDtFeDA8VuN7AVsiSDMDjzHLqYzSUADIvwm836skY9Ixzc6c8hs488pvsfchYmunIuUydkcN92rXq1bc1DgK1BRuHWnEjYZDRmh5BcvGOljgUuuIXpI98GADtrvQWTjssohNVEgQMwGo7oC9VckEf4LiW8Mq5I5W1E8YceJnM1QG9R0MKIcxSnHqzbVmaBe9gMwBs/v7j6+LNvLEvqzqSeV+7+4kd8iZB/HCoBjkrI4Zsc06NMdvBHuENHPe0iTERkuGvSNaEP67yblx7e6Sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z9FZ6Jqp8uHJ39gwPjelSye//c4Mr59/5Q8Zn32ZNN0=;
 b=yiXjMUzqbpuM6FaRobuKjFOh/OJ5beHUnO17Vfm6jXW5EksACM/zfcvnkEqqMrrBiytniliPFRda294lAzvczPbO6ofZDvqFu/v6ntil+KXYTIYGNXwg7K6/GVw61bcPeUpM0Lq2xAaDVmezEEaUle+YMLuF1pHqkYsm7ypssqwXvNlIXUuQUJBffXMuZiLjYpDTHsIVjBb+zj9io6+qfMNJYHN8nGNVj9yThU8Vkg9tyq5EbazZ1o6IxR8n2Sc2uQiU0Q6BnhASEInLf0+iqM5z2FGcDIfM6qaC+iW6bAw3MLGcQDOilxELGY9FQR7wKPVisMIuBFEF6VLlz5dn7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z9FZ6Jqp8uHJ39gwPjelSye//c4Mr59/5Q8Zn32ZNN0=;
 b=Z2BrX0psFMKPP70EnwEVo89DqiTxwj/kR6B89eDGJXVRza9jICculNBYTSXd+mGKaTx34jGnQE3lARnfniRIER2Ns5Zl0+HPG+XRgE3H14EoF+EuMxacXjHJDmMDodU+n50o7qZT+Pu8k/xHRI9u+1vKR7ltxY2Sm9AQS01/6CM=
Received: from DU2PR08MB7310.eurprd08.prod.outlook.com (2603:10a6:10:2e5::5)
 by PAWPR08MB11014.eurprd08.prod.outlook.com (2603:10a6:102:46c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.11; Fri, 3 Jul
 2026 15:57:10 +0000
Received: from DU2PR08MB7310.eurprd08.prod.outlook.com
 ([fe80::e007:b494:8a24:1fc0]) by DU2PR08MB7310.eurprd08.prod.outlook.com
 ([fe80::e007:b494:8a24:1fc0%4]) with mapi id 15.21.0181.009; Fri, 3 Jul 2026
 15:57:10 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey Gouly
	<Joey.Gouly@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	Timothy Hayes <Timothy.Hayes@arm.com>
Subject: [PATCH v3 13/40] KVM: arm64: gic-v5: Implement VPE IRS MMIO Ops
Thread-Topic: [PATCH v3 13/40] KVM: arm64: gic-v5: Implement VPE IRS MMIO Ops
Thread-Index: AQHdCwSb1VvPrPGSt0KlBNlwB2PDYQ==
Date: Fri, 3 Jul 2026 15:57:10 +0000
Message-ID: <20260703154811.3355680-14-sascha.bischoff@arm.com>
References: <20260703154811.3355680-1-sascha.bischoff@arm.com>
In-Reply-To: <20260703154811.3355680-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU2PR08MB7310:EE_|PAWPR08MB11014:EE_|AMS0EPF000001B3:EE_|DU5PR08MB10659:EE_
X-MS-Office365-Filtering-Correlation-Id: ab7bd4c0-21f1-4dbd-7ecd-08ded91be2cc
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|38070700021|3023799007|56012099006|11063799006|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info-Original:
 NwatIzr/dq4C4aqKd4mBYXqfWMUqaiaoC0YxgFYJCbyrILnY5uGRDMZH+uG6yzkG0tgCIKiAdTfKEBAT6tdba8xMZQm40kcQlM5jkj7/MIlwcpytmpxwwrRv9wUglCdOLws0XmHK0WBdJbS0efuvqB2AZ/29zyp5qA8MmMBeaVk/lTPWvncTWRineKZUovyMRfLCTrA53OG+90C+48TPlvp1HI/gxr/YGZdn3ihCGoFc3jayTV2Sx3lWAAUle9YYBRBN32Hls/YdG0xhCiXnGR94MrBk/IG+QqvohgVYU1shdCklSpjtwl/5mPgohaOVnLycqn4S1NUHuuDqp81C2VjN0gftlyzibSvHCvkj435Kb9klZ048/mGabsA/ulg18Yqvqnkp9/Tc/VXzmF+nym+nOvMMQk2lt99+rxzUOXc2v6C9Dix2VvGX97rDhvyim2DoI+4fHlsx3eVy26w1L22jCdhrfm0s8DmQweZff9jxp5beBreeY1LJvS9W6iK3MtbmMDWF/IIsQIhCQhzCgB4eprytL9uJvzNf/RNFyR9hdHBinfx+EHs7pnKLKA8SKnNGsdriSUauQgpKhOlYpjp4dCACrG35pGYiRH+XqQe0NCELhR/OW3VcOId5SMTt6hUaa1SZgmA9ELnAFRpg7CC9G7qSIbEmDiWTaQzkWO1nKmelq1PB/7y3cT+cefRRXnQ/jOPxzaCiRxpAF+x3Sd67vEqTmKSUBwFXduHeqWQ=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU2PR08MB7310.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(38070700021)(3023799007)(56012099006)(11063799006)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 YkimSg703tqv3jHKyth7WIL+IUBXKHcB1E2YstyF8uCu3TAlzNOR3Oo/fy7o8GILqbETUd3geC2tGmvvqNuKJtlCmY9aQ8qbL7L7eZAzdR/K7XV97O1fSoldiTPeplz9u5Y9vIzYi5Padj+EoqZ5a68W4NY2Zd9TrtsiKWZ4vwDxFgZjsTeS2PCUfdqFDxlhIrirDAmIBDKDYzmt0gitowLRBaWPyFcBaNJcd5bLYougIkV7uWHvoIyBRicpSWrUY2rN5D+6jbJKvNDKJufkKpCf7OABbmBJHB6ZpK3Yh7wPsK453iYI9UotugBuVN9ahyxUQv62FJQZZ15QYLCL/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR08MB11014
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF000001B3.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	2a6ea97a-d42f-493c-37d0-08ded91bbda7
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|23010399003|376014|36860700016|14060799003|35042699022|11063799006|3023799007|22082099003|18002099003|56012099006|6133799003;
X-Microsoft-Antispam-Message-Info:
	B8yl5D3ndypM2AE9hRB8p8LSZWwJHaeT0QtfGj93wUysq63+g9JS8EzQK5B/TsrX/AAKYaxqbAHA6i9n8KsEz/f9Ffl197pWvnKKqmULGRHjc+wP2LTpttA9cNI8G4iEyuGAra49IQT6Ynd2ojyeLwy/ZS+jaeOypCZS94NzZdehRrubYO/2581euKAPkEgVS+B4u6+ksrSb7hwmGW6AxuXASKTwxekSFc1mLnikenj3EgHjjGcMJ/UOMBMN+471Pua465rrBiKKdxWk9RSEOPYzTUqDl1tiq40KbzmFmsfSY6mQydTppqeqnryXfgsb0yzopShAqU15SVrIWdEGY5JRL7mxjV2xmkxNqPSW9tbiUf4DcVvnc4/MAPwXnNZEwCucoDslltvECxAlKZ/Efi61Dc/z5mnAA2mX7VzPhpZVaGvA4ExUhUAfj8Zb9YMglyRTIPBadtSjPY8928lE0Q/l4rsgzzo1ZVLwhaJZa0e2yOJac+wRrR8RW7qmeybf8E755n6X9M0+MKpp7zTPVHOu4chPbE6bG8LMh5K6jkZ1S1knkpZGQA1wx3tfhM7n/k8YqeKLtfOMrP/lBgJ6bLGnWRi5zIUVIY9ycIgKRn8GViETFTePqitlL/oWJFi1+YnvaJ41lOD6mDHIdxjpBzya86KVEn3iT4SGDL45V5ZXojpuoPd3T7iSYrgukof/2wOoE/JF77kMhwsIPaE18g==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(23010399003)(376014)(36860700016)(14060799003)(35042699022)(11063799006)(3023799007)(22082099003)(18002099003)(56012099006)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	w7sVpCGTDP70+qq23DPvq0VF6C5H02Dz+9b9y+eshC1UzFWDBtDy8TJPZyAECkYC6xmsrWq9ztYYHjI19Gjh1R93rEwHu97AMLjhyGHHlIqgIRvC3X4AkeFZD5J7WgjhI0/vmqvApWwGkTrLkYtdTWgMFxKy4sky+nFiTmggO+WchAakrmw3bAKiogRFQTMXktJw7Gx6isR5m8J5nodQyyshuNiToI8Iur3YiJLGETkDgtOn2annzJJZeR/TQU4kXp4m2T7sGUT/YwZVQhd6+NNQYC08RBpt9wHLTqpAl1ka0sks8fF7rpa6UlVSDs8hXi1Iem4O2NfaDN8B/tQUzSSEaeZgbdBmPsEeBeR1AO02m99yz+V1dmEb5FV/FN2ywPGwDPq0Hi04mP3IsH40oOl50lcsbBL3ntawk2me+5A9nqprJW/xTaIjR+2sy0Va
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2026 15:58:12.4619
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ab7bd4c0-21f1-4dbd-7ecd-08ded91be2cc
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF000001B3.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU5PR08MB10659

Introduce interfaces to make VPEs valid, and to configure them, via
the host's IRS. As with the other valid bits in the GICv5 VM tables,
VPEs cannot be made valid directly, and instead are made valid via an
IRS MMIO Op.

Additionally, some of the VPE configuration takes place via the IRS
MMIO interface too (via the IRS_VPE_CR0, IRS_VPE_DBR). VPE doorbells
are, for example, configured via this interface.

The existing VPE-doorbell-based commands are extended with:

        VPE_MAKE_VALID - Make the VPE valid in the VPET

Note: There is no VPE_MAKE_INVALID as VPEs are only made invalid on
teardown, at which point the whole VMTE is marked as invalid. Hence,
it is not required.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-v5.c      | 84 ++++++++++++++++++++++++++++++
 include/linux/irqchip/arm-gic-v5.h |  1 +
 2 files changed, 85 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index fd64ea0173b2f..6d7d9e6ed9dbf 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -232,6 +232,18 @@ static int vgic_v5_irs_wait_for_vm_op(void)
 					NULL);
 }
=20
+/*
+ * Wait for completion of a change in any of IRS_VPE_SELR, IRS_VPE_DBR,
+ * IRS_VPE_CR0.
+ */
+static int vgic_v5_irs_wait_for_vpe_op(void)
+{
+	return gicv5_wait_for_op_atomic(irs_caps.irs_base,
+					GICV5_IRS_VPE_STATUSR,
+					GICV5_IRS_VPE_STATUSR_IDLE,
+					NULL);
+}
+
 static int vgic_v5_irs_write_vm_mmio_reg(u64 val, u32 offset)
 {
 	int ret;
@@ -332,10 +344,73 @@ static int vgic_v5_irs_set_vist_invalid(u16 vm_id, bo=
ol spi_ist)
 	return __vgic_v5_irs_update_vist_validity(vm_id, spi_ist, true);
 }
=20
+static int vgic_v5_irs_set_up_vpe(u16 vm_id, u16 vpe_id,
+				  irq_hw_number_t db_hwirq)
+{
+	u64 vmap_vper, dbr, selr;
+	u32 statusr, cr0;
+	int ret;
+
+	guard(raw_spinlock_irqsave)(&global_irs_lock);
+
+	/* Make sure that we are idle to begin with */
+	ret =3D vgic_v5_irs_wait_for_vm_op();
+	if (ret)
+		return ret;
+
+	/* Mark the VPE as valid */
+	vmap_vper =3D FIELD_PREP(GICV5_IRS_VMAP_VPER_VPE_ID, vpe_id) |
+		    FIELD_PREP(GICV5_IRS_VMAP_VPER_VM_ID, vm_id) |
+		    GICV5_IRS_VMAP_VPER_M;
+	irs_writeq_relaxed(vmap_vper, GICV5_IRS_VMAP_VPER);
+
+	/* Wait for the VPE to be marked valid in the VPET */
+	ret =3D vgic_v5_irs_wait_for_vm_op();
+	if (ret)
+		return ret;
+
+	selr =3D FIELD_PREP(GICV5_IRS_VPE_SELR_VPE_ID, vpe_id) |
+	       FIELD_PREP(GICV5_IRS_VPE_SELR_VM_ID, vm_id) |
+	       GICV5_IRS_VPE_SELR_S;
+	irs_writeq_relaxed(selr, GICV5_IRS_VPE_SELR);
+
+	ret =3D vgic_v5_irs_wait_for_vpe_op();
+	if (ret)
+		return ret;
+
+	statusr =3D irs_readl_relaxed(GICV5_IRS_VPE_STATUSR);
+	if (!FIELD_GET(GICV5_IRS_VPE_STATUSR_V, statusr))
+		return -EINVAL;
+
+	/* Set targeted only routing (disable 1ofN vPE selection) */
+	cr0 =3D GICV5_IRS_VPE_CR0_DPS;
+	irs_writel_relaxed(cr0, GICV5_IRS_VPE_CR0);
+
+	ret =3D vgic_v5_irs_wait_for_vpe_op();
+	if (ret)
+		return ret;
+
+	/*
+	 * The VPE has not yet run. Therefore, make sure that all interrupts
+	 * will generate a doorbell.
+	 */
+	dbr =3D FIELD_PREP(GICV5_IRS_VPE_DBR_INTID, db_hwirq) |
+	      GICV5_IRS_VPE_DBR_DBV;
+	irs_writeq_relaxed(dbr, GICV5_IRS_VPE_DBR);
+
+	ret =3D vgic_v5_irs_wait_for_vpe_op();
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
 static int vgic_v5_db_set_vcpu_affinity(struct irq_data *data, void *vcpu_=
info)
 {
 	struct vgic_v5_vm *vm =3D data->domain->host_data;
 	enum gicv5_vcpu_cmd *cmd =3D vcpu_info;
+	/* Our VPE ID is the index within the doorbell domain */
+	u16 vpe_id =3D data->hwirq;
=20
 	switch (*cmd) {
 	case VMT_L2_MAP:
@@ -344,6 +419,15 @@ static int vgic_v5_db_set_vcpu_affinity(struct irq_dat=
a *data, void *vcpu_info)
 		return vgic_v5_irs_set_vm_valid(vm->vm_id);
 	case VMTE_MAKE_INVALID:
 		return vgic_v5_irs_set_vm_invalid(vm->vm_id);
+	case VPE_MAKE_VALID:
+		/*
+		 * We need the actual LPI ID which lives in the top-most parent
+		 * domain. This hwirq won't include the type (LPI) but that's
+		 * not required for the IRS_VPE_DBR.
+		 */
+		while (data->parent_data)
+			data =3D data->parent_data;
+		return vgic_v5_irs_set_up_vpe(vm->vm_id, vpe_id, data->hwirq);
 	case SPI_VIST_MAKE_VALID:
 		return vgic_v5_irs_set_vist_valid(vm->vm_id, true);
 	case LPI_VIST_MAKE_VALID:
diff --git a/include/linux/irqchip/arm-gic-v5.h b/include/linux/irqchip/arm=
-gic-v5.h
index 74152d22de070..8b6c497d3b590 100644
--- a/include/linux/irqchip/arm-gic-v5.h
+++ b/include/linux/irqchip/arm-gic-v5.h
@@ -659,6 +659,7 @@ enum gicv5_vcpu_cmd {
 	VMT_L2_MAP,		/* Map in a L2 VMT - *may* happen on VM init */
 	VMTE_MAKE_VALID,	/* Make the VMTE valid */
 	VMTE_MAKE_INVALID,	/* Make the VMTE (et al.) invalid */
+	VPE_MAKE_VALID,		/* No corresponding invalid */
 	SPI_VIST_MAKE_VALID,	/* No corresponding invalid */
 	LPI_VIST_MAKE_VALID,	/* Triggered by a guest */
 	LPI_VIST_MAKE_INVALID,	/* Triggered by a guest */
--=20
2.34.1
