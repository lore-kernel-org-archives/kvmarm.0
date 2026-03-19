Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013051.outbound.protection.outlook.com [52.101.72.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E796B3E8C49
	for <kvmarm@lists.linux.dev>; Thu, 19 Mar 2026 15:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.51
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773935483; cv=fail; b=eopI4kifqdVzM/+5mc6UbZRFFBIbAObdkYf7lEgUqaS9pNX62casyNDUMnXRJ4g90c1Ksvuer5yTX69rOR3jkYuui1WZVN+Ky4LoTg7CGR+8uVcMibMvmmPkL63DeTA793w3yR3GAlpktqAK/KcUyABlt+hRe+D3v/w/BzpWves=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773935483; c=relaxed/simple;
	bh=rwGSDZ8br631kLb0Rt+SUs8zXNsNGN4eIFNyAnj0snU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=amSIUFJ3ko7Ozr+e56t3iqA1yVznrU8rtDHClIba782GRH/moWczpKq/J9iQDKRMKv2aZVlvgCU6ivkJnzmwdjdBKkwO9Z3uf+69ujpvIuO46amaoRmME+2L7HFHnei+fywJIY1yae/lWJQN4pNoFRnZm+b968JPxgelB910QTQ=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=sDEcmaFX; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=sDEcmaFX; arc=fail smtp.client-ip=52.101.72.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="sDEcmaFX";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="sDEcmaFX"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=R51vQfPibqfWVmqFJ74pYu/O8pFQiXJ1r1xFMJ35YgfG/FuSaLPX9d+wDTyzF/POFzoS5pWgziUUqfrF65kxhKnFpzjPeTgwhsFkX7/D+iFxUl3GBnbTcpaz3oZZPRcDnWbGSFS66yj5AMW/niKrwTUt57edCLeJW3nWCl/lnKudjvd6Snc3KphfbIKHrG7AYYIEyCfPsViLseiicWxU3p5QU2GM8sSBi2uEa0xBoUe2/ZK/JnuO+ekHd9na1RJxeWrwlEst0QS7DNIxArtocR+4e+G9XtJa0sVRK6MVIuOfnIWvtVCBhvZxf2E2G++z/2AKH4ndKCpJLyqahKJHig==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fKuHiW/qA5cc1ntDpBJaZtYUrr7uiqCM2ZhlgQ4Dm2M=;
 b=u7N7ZcMh7I+uRqWga/G0lN28okhbAQEJpab1/dcZfyQubV+ARNA1DJCdzg22yfqA3G6oUIJ0/Kq11eRB1gqjNLecIIM0U2NAcBoUkoW7+NpzjBseJL2xTkX2T49ZQ7a6UX2dPBfJzUcIc2/Nx1F8zDbrPR4lORHbrcYoVBuDokcPU7UVXIzAG8FWACgBthDTJpvrMSSuRHWDi2G5tjt+0mgjGW+KMJWv9pDz052gTcT+bk+4ZeJ5RV6pIm3avZqAvlAKuvUiDPtDqSS+YesVqPiLJOEpG05GVIh42zEtxP5EFmDVcExpV9+YNeMsXHdvxeQCBh3tILH1Mobnkq1rlA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fKuHiW/qA5cc1ntDpBJaZtYUrr7uiqCM2ZhlgQ4Dm2M=;
 b=sDEcmaFX0mryW5jmj7SV2AE3OFDdycODf3LARcXhnaoUB7f27I3Krc+f8FZ64+HJY9DGfJu+6C2dDTdw94VtMklXvuBGjEXnbT7MlQeL2wyhCUSpDRQAfihkz4jZHWtS9Q7qgMQOoL6mtSsCckP6WdrpE5BIq98f67VynUPUZjA=
Received: from DUZPR01CA0068.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:3c2::18) by DB5PR08MB10140.eurprd08.prod.outlook.com
 (2603:10a6:10:4a1::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Thu, 19 Mar
 2026 15:51:16 +0000
Received: from DU2PEPF00028D11.eurprd03.prod.outlook.com
 (2603:10a6:10:3c2:cafe::b6) by DUZPR01CA0068.outlook.office365.com
 (2603:10a6:10:3c2::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.20 via Frontend Transport; Thu,
 19 Mar 2026 15:51:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF00028D11.mail.protection.outlook.com (10.167.242.25) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.19
 via Frontend Transport; Thu, 19 Mar 2026 15:51:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UaB2vXQ3iDULC+qjBjqtGws3qxIwaaDnZDfiaXCnWoIK1or8usd+U/6Gj8N7zTCTSC0ZVHCwvl+nLismie2vL7e/2IjBPZoT8NBTJzoWEUmkpZCmjYsGPlmDklZwtodSDaeMBB+wKTVIBR9d/cuBhZ3tvqEI12jveiHz5M3wnOBZPt2T6ibn55TCXloFobO3pbIJXa5yMcQt0v1PBzJpbgWRYoqnH5k2KSaML+xFIvAjUPoNdVe4zl83CEvHAttKHAGEKlGEekPP4lWMGzfUa2J/zI38LThnWBSPbEs7JCLfUI3w2FShxznFTODxHE54YYDO5caBYuL4OzG+u96MXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fKuHiW/qA5cc1ntDpBJaZtYUrr7uiqCM2ZhlgQ4Dm2M=;
 b=gwnywYr99HW8/sP6kYu0jN4ZD6a7MhHwN3VLj1bgIqPkS4amLlukbR9ehKM1Ikx7OHP2BjxYkEIFZ7C50c5Ak5Joyp5J3kYo6zxbCTFT75MwlAxZGMqb2TyGcBzYHEz3DbF+iVnvwrjdeaOt9+COFNq2AY79mzVl7HWA9BsIP+MAAXLLBGnAoKOwYbxv+F/KMmvF7wn/Z7GWanqw0gutJkKhPGp28jQGsofS95sU50W4NYxpbmN8TdvaYsoZgGKc1GENfbH1JK52Hruxl8+sNJRkmGVKrYZFOKBl5e8nozBrCOoljtpP1pIg/mR1tNJBcbMoona6L5o6JWi0huw/WA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fKuHiW/qA5cc1ntDpBJaZtYUrr7uiqCM2ZhlgQ4Dm2M=;
 b=sDEcmaFX0mryW5jmj7SV2AE3OFDdycODf3LARcXhnaoUB7f27I3Krc+f8FZ64+HJY9DGfJu+6C2dDTdw94VtMklXvuBGjEXnbT7MlQeL2wyhCUSpDRQAfihkz4jZHWtS9Q7qgMQOoL6mtSsCckP6WdrpE5BIq98f67VynUPUZjA=
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com (2603:10a6:20b:504::10)
 by DU2PR08MB10185.eurprd08.prod.outlook.com (2603:10a6:10:49e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Thu, 19 Mar
 2026 15:50:13 +0000
Received: from AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27]) by AS4PR08MB8241.eurprd08.prod.outlook.com
 ([fe80::dde1:493a:db27:de27%6]) with mapi id 15.20.9723.018; Thu, 19 Mar 2026
 15:50:13 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey Gouly
	<Joey.Gouly@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	Timothy Hayes <Timothy.Hayes@arm.com>, "jonathan.cameron@huawei.com"
	<jonathan.cameron@huawei.com>
Subject: [PATCH v7 02/41] KVM: arm64: vgic: Rework vgic_is_v3() and add
 vgic_host_has_gicvX()
Thread-Topic: [PATCH v7 02/41] KVM: arm64: vgic: Rework vgic_is_v3() and add
 vgic_host_has_gicvX()
Thread-Index: AQHct7gSDnMs98A5Fk6uZBQBitnVbA==
Date: Thu, 19 Mar 2026 15:50:13 +0000
Message-ID: <20260319154937.3619520-3-sascha.bischoff@arm.com>
References: <20260319154937.3619520-1-sascha.bischoff@arm.com>
In-Reply-To: <20260319154937.3619520-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS4PR08MB8241:EE_|DU2PR08MB10185:EE_|DU2PEPF00028D11:EE_|DB5PR08MB10140:EE_
X-MS-Office365-Filtering-Correlation-Id: 49a93c27-390c-4e3d-b468-08de85cf5b33
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|56012099003|22082099003|18002099003|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 rcqW7roiAlwq9lvjkycFOus83fQV89dwS56IIDU/W5HuW+I0Cu5Ejd6k9Uc2Uf/qwfVT5bUL4yE1cwclDf1bY7zNDwt4As23WVQlE1rnAqAaZeQy9XbGGPT5Ta82/zCQf83ZIc/7v4RZt9u1KFLkmG/f2Tm9BqsbpS+rAnH5vjKk/1YUXwURIE36chJ3izdzsy4rX8uGO/bpVDmLXNMmgLkU/b26jbl5rB3UgrGdniaiBbY77rf2mmzlgORtRlN2DrhfOX0CEJNDpPN6O7H0o5AriXxKFRaWxmF0cq69YITccQ15IaU7J7jvVOdadTE6tqKNzf/cAZ0Z57521Z+QG6fHXNVVE7HmHxu5KehlvKc1lD8LWIEntOxF9z81KuDASw87ctOh3hTsEQCIM+N+R8pCrVeK+GCbRxgcYBNYQLggw2hzR5mcaDI4Sj2cJT4WfvL0jb/pouK2rcG4Pl7O8umVHFNLPdQD0LfbTF69N8fwlexyMThCSNN0JDMfyKQzbiI1WAc3YvZ0fmKUeD6MmI1l9ctIxueuI1HkafXK67cDcYJSqmp06RBUD+Siy+x0YzQ0Iihfw1T1Ukx+/OKWGwn0THKwE1fWecgAfEexTivTUBjHIAH/YgZfSsZCPHecmE9ZRNZTwGTSoDPT71onlkXy17qL2zdfLko8cSEyeKE3TROEU0KP+qID4+YB85AfrYF5YJh8QJ1fQz1byFnFIXP+xY9hTh7NyPG4N4AnSVoB87jL+1hNZAJEGrp8sStq2dMCvl6NbmXTJhr1AgNpspN73pGLFtwn41mB6VIAV/I=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS4PR08MB8241.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(56012099003)(22082099003)(18002099003)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 EV2Ax65rbVAL9kVozAE3dlKro8PX4MfD1dNiAcpEXkniW8/EwcoW6m+pw+8/IEUT0Zi46Hi+BfEq0ivqmX9jdonG5/l+733jaH+SzJDv+6X8cSBlMUHPFX5AthyaYI3dTtdkSqMBaUOtVqcI8rYIFcQslGlXSQdJG1hkiU9Qth6n0TE7wAZhGzw5e0ye5JQCdNZTuzU60b8nkDk5YgIlb82jVuQgZZg1UXJpxWVF8KWv+i8Z+wVSvQtHE7T8+VhTv9JVZQLl3mRm7ZrZ+G+FgrbbtfVg3YBKfh5bhlnsapejUVKC7oZAFMsm7DO33E0dT5I3Pd6ct2SSVH+vqLnZ8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR08MB10185
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF00028D11.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	b40c293f-bf73-4e1d-e16e-08de85cf354a
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|376014|1800799024|82310400026|14060799003|35042699022|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	PpW6IZ+Qe0oWNqT0RFeZMipktryKkOdBTyaE1qQP2981SEP/9G+bD3nih/iXwD34OtaAhdH9F3DJfeg/zXu+8/iCKsqYlGQ8N9ot6qMyxJ6Rycwd5x8k31zZXJt4nMep1T3r6jzjFddOL/aAQoRn9OHHZG59c2OMW3qaRs/3AmQ9qDXrHmZpegPEDoWohBs14XZyCvMtABeH9Fon4p2I7SVSSgVT/54MKvscZkIBUvE6fy6ju86msIuvzQa+JT431OEEGEsDvxYHfT8uUzbu4beOUyRou7KD1kIKtCNFVIXfgH6cm+ft6tM5X/wpoBthIwJBs4dfy3mf9LwOoXw8dnrfUEqTwSgJtB0lQ3xmO/bRHfXJ6w5Q3ZYfjNonZGmiEZusTKcc5bgmMb60/PxdtKhSNYhhgy1Jf+vOJm5K7zWVRHNWqIDMRRqQtBksXKhtb55vsfJ/k8HwGcYrCv49cSz243YmCeyPsWD/Fk4eGfF6LDaZo52M/d+jY1ikx1w8p5nfsuFPFu+pzFyhTF/S0DyxBOqZwfZW4h6O9Bathli7pRkyFcIYznJ7i5iuHTSfQPNaHavtQaoa/peoCupLMcYWtAs2L3J49gk7aKwJeeoj/LCKsjlOddeBIE0VXkLsyTLWY5EVY/9DT6qgFYfyWL7uLKJr6f3k0rVWAZMtnfpHybl4rUTZJin07YOmgiPyaGf4zIhBvWLwEc7g1DpjSVe26ePPfxqIZBExl/1KpMwYVs1vwA+eH4CP0HzyFm7RNlOPpYlKolCYbppmSTfEfw==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(376014)(1800799024)(82310400026)(14060799003)(35042699022)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	a5UqlLuZ+gRowxuNUSXhvGPE1kFo/x+6SXT4PPp7lvnbGzVfzVW/fh3Q/VAVJQtm+DFVjt0/8gjJTm7KmkNe39KXb+XOofx6CGujW6ifrddnLEkNuKHKceIVJNwTqNwlomWGOkL6BfWqddspKOrYjuI/TXIKzcKga1D2xp+vXMVaPehTMw5io+jqk+lyHK1H1OE6xBmAYMof1tISYHc7Zn57nGDV+7A32iNOYyauuQZbAn6tXAEj28BEIbigo30INxkj6m8ELIryP7HFcv4ks8W/WZo+XEij3SmqzflSOho4LeSNX92SMElyLniDcDbvnOPsrBJmm8BwDn0VEUODjpNux8bc/DAZPvy3jgzAjr6BDFiBlsd1GXp5E9cDlT7dYPt8FXgjnw52EpWUOEP8cyKn3GMXc668GbR/d9I201YBTQpDtjHdYD+rTnASE/W6
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2026 15:51:16.7002
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 49a93c27-390c-4e3d-b468-08de85cf5b33
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF00028D11.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB5PR08MB10140

The GIC version checks used to determine host capabilities and guest
configuration have become somewhat conflated (in part due to the
addition of GICv5 support). vgic_is_v3() is a prime example, which
prior to this change has been a combination of guest configuration and
host cabability.

Split out the host capability check from vgic_is_v3(), which now only
checks if the vgic model itself is GICv3. Add two new functions:
vgic_host_has_gicv3() and vgic_host_has_gicv5(). These explicitly
check the host capabilities, i.e., can the host system run a GICvX
guest or not.

The vgic_is_v3() check in vcpu_set_ich_hcr() has been replaced with
vgic_host_has_gicv3() as this only applies on GICv3-capable hardware,
and isn't strictly only applicable for a GICv3 guest (it is actually
vital for vGICv2 on GICv3 hosts).

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/sys_regs.c     |  2 +-
 arch/arm64/kvm/vgic/vgic-v3.c |  2 +-
 arch/arm64/kvm/vgic/vgic.h    | 17 +++++++++++++----
 3 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 4b9f4e5d946b1..0acd10e50aaba 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1985,7 +1985,7 @@ static u64 sanitise_id_aa64pfr0_el1(const struct kvm_=
vcpu *vcpu, u64 val)
 		val |=3D SYS_FIELD_PREP_ENUM(ID_AA64PFR0_EL1, CSV3, IMP);
 	}
=20
-	if (vgic_is_v3(vcpu->kvm)) {
+	if (vgic_host_has_gicv3()) {
 		val &=3D ~ID_AA64PFR0_EL1_GIC_MASK;
 		val |=3D SYS_FIELD_PREP_ENUM(ID_AA64PFR0_EL1, GIC, IMP);
 	}
diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index 6a355eca19348..9e841e7afd4a7 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -499,7 +499,7 @@ void vcpu_set_ich_hcr(struct kvm_vcpu *vcpu)
 {
 	struct vgic_v3_cpu_if *vgic_v3 =3D &vcpu->arch.vgic_cpu.vgic_v3;
=20
-	if (!vgic_is_v3(vcpu->kvm))
+	if (!vgic_host_has_gicv3())
 		return;
=20
 	/* Hide GICv3 sysreg if necessary */
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index c9b3bb07e483c..0bb8fa10bb4ef 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -454,15 +454,24 @@ void vgic_v3_put_nested(struct kvm_vcpu *vcpu);
 void vgic_v3_handle_nested_maint_irq(struct kvm_vcpu *vcpu);
 void vgic_v3_nested_update_mi(struct kvm_vcpu *vcpu);
=20
-static inline bool vgic_is_v3_compat(struct kvm *kvm)
+static inline bool vgic_is_v3(struct kvm *kvm)
+{
+	return kvm->arch.vgic.vgic_model =3D=3D KVM_DEV_TYPE_ARM_VGIC_V3;
+}
+
+static inline bool vgic_host_has_gicv3(void)
 {
-	return cpus_have_final_cap(ARM64_HAS_GICV5_CPUIF) &&
+	/*
+	 * Either the host is a native GICv3, or it is GICv5 with
+	 * FEAT_GCIE_LEGACY.
+	 */
+	return kvm_vgic_global_state.type =3D=3D VGIC_V3 ||
 		kvm_vgic_global_state.has_gcie_v3_compat;
 }
=20
-static inline bool vgic_is_v3(struct kvm *kvm)
+static inline bool vgic_host_has_gicv5(void)
 {
-	return kvm_vgic_global_state.type =3D=3D VGIC_V3 || vgic_is_v3_compat(kvm=
);
+	return kvm_vgic_global_state.type =3D=3D VGIC_V5;
 }
=20
 int vgic_its_debug_init(struct kvm_device *dev);
--=20
2.34.1
