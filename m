Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C68233D3B8
	for <kvmarm@lists.linux.dev>; Tue,  3 Jun 2025 18:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748973729; cv=fail; b=tIWO9uBq900TPPYcVQeaSYY9cO2P1t1LEaGZarhZ/bVvxYaGeuXu2SPOHPCowjUj2vPPwAnuQK5Wb6AfehPnAuU8Y0jNDPmKFAJOgieH6Es5At36MR8L+8ubE1NH6d89jcvSv9TAJavWLL2AXDtvTutMGs6RrGb7oKksTo6ibnI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748973729; c=relaxed/simple;
	bh=1AkXLCBm/bMhSD+FQ76LYt512/qRLcRHtzx98N0t2R4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=uY+V3VHDLFe5XwocPyeiKCMiHcySABekC/RohVG2MjRcaI8yB7IdQ3BIyf/OLopUjY5turM0QCzpqVQcHbBM9aRD/Ai7cQPVX9FjyxOkAdb/rZt0OCCheOJF7w+EaYbz0XbVxRJIIEt/x8JVuRLwFpIVEjDL4QnJuLgq3uwZXSg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=WAjg3uEN; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=s6uv8OxP; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WAjg3uEN";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="s6uv8OxP"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 553HY5FP032365;
	Tue, 3 Jun 2025 18:01:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=y5hPksRxI3Au0PG+5GsgsAEwUcJY/d9vFspzqbhsHIU=; b=
	WAjg3uENfq4PH4NmSsYIcX1VW1JNy4H+bcgGirfdlxpacVBYJEnWbrIjJ21JvBSQ
	xYGoBQrnBBSS1gGcU3y3pS1F3cPoz8yfSB5QDBvb6GYrXu+cI+t8PA8cU+pYCost
	Z43imuoupNLV7LT0IY4p19Qvl2Nz1yj0pIIy3ozGvEvENo5ZwBfX/gjW3CglcoiL
	HEcjfjLbMK2xkHj8ocZJnYsG9gcyOk5SMEDN/LxZtP8rPvlQYJ0BMQrxlmjj96kc
	GFBvWzMYSrqqrEN2G0YUi1K3B0EaBFUq2HfcRiujhewf5d4/Mkds73aPqReGfMbr
	BcFq5Mv0ApIBGkXbt4Ms/g==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 471g8gae5s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 03 Jun 2025 18:01:39 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 553GxoL5030930;
	Tue, 3 Jun 2025 18:01:38 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11011016.outbound.protection.outlook.com [40.93.194.16])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 46yr79r5g5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 03 Jun 2025 18:01:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fTNPmiQSohP0Nx7tzYM7te3vxephcwA3p6ct+2a9qcBDDEnB2vfbFg1ud0TCPQ13pkolAxryPn7BjXZonUgGbntoy5/zMDK3yZnseDqwEaZF7Cftdh7njVacbaCp/ipyfQ3cQhJ2TdW8nAHRclolQ5U5SZTtdw43PWbWOkSWpaq1mVjSLYznXMnUHMaK1Lt1OSLR0Xj/up3eV6XHPBhO1liiRrH2oZPE0EhBOlGpwY2p8h7a39jiI808xQ39DKWPSGqxQHP/hwCJdksefxwhw5x+J70DAlYhSP5WW2azSaFTice/TT4R4ILshRmm/TisWvnj+xflC2Q6CfeF5K+wbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y5hPksRxI3Au0PG+5GsgsAEwUcJY/d9vFspzqbhsHIU=;
 b=gDJlVuwYKbpIDxFHc03UP9BpHRl8fI+arnrDAxiQeaRxBB+onpKPDlt/cG8wXSPQMbo6QRtA1pdz6hLiJdqthnrawtKT8JdTuwmAXOSXf4C++IV8qro662BmM3REUvgzmb2y2tFyxpvHX+tHJhIVze8EPS+CVWV7CXpFeDt1re8T/3TCPSjCvhBasgwqavnIU1OD8S5Fz6zupxuO/27C82ARxxdv8ObqyTY6GWbTMOjpXwNj+t2WBSiKSvLqAm1SAONS0XIE/7fdNV34yj4XVBiFYwAaOmbBlgnRdUFs/vIS7asOyc2kl0u0M59Oo9dXk4vBtAx3uNQGKQ59WEtjFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y5hPksRxI3Au0PG+5GsgsAEwUcJY/d9vFspzqbhsHIU=;
 b=s6uv8OxPUwSfEtfE1YAHdiywM/4QD+4dOSOVfoNI1C0I1PIWJOb5GSoctgVm3tLDsBSRvb+C25CMuO9ifdlu9sBHujsUHu24y6/SoLoe99yqC7yLf2yjfec0iQphEXBiPpUBSelTh3b2VwP5bKjDqazx4PtfyUC+Tx1cOCgjKkc=
Received: from PH0PR10MB5433.namprd10.prod.outlook.com (2603:10b6:510:e0::9)
 by CO1PR10MB4737.namprd10.prod.outlook.com (2603:10b6:303:91::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.29; Tue, 3 Jun
 2025 18:01:35 +0000
Received: from PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::47be:ad6e:e3be:ba80]) by PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::47be:ad6e:e3be:ba80%7]) with mapi id 15.20.8813.018; Tue, 3 Jun 2025
 18:01:34 +0000
From: Miguel Luis <miguel.luis@oracle.com>
To: Marc Zyngier <maz@kernel.org>
CC: "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
        "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
        Joey Gouly <joey.gouly@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton
	<oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v2 1/4] KVM: arm64: Add assignment-specific sysreg
 accessor
Thread-Topic: [PATCH v2 1/4] KVM: arm64: Add assignment-specific sysreg
 accessor
Thread-Index: AQHb1FZnevywAwfY5kO+OoerOuGUWrPxulwA
Date: Tue, 3 Jun 2025 18:01:34 +0000
Message-ID: <84553621-E2B8-47A0-A812-FE273505ED47@oracle.com>
References: <20250603070824.1192795-1-maz@kernel.org>
 <20250603070824.1192795-2-maz@kernel.org>
In-Reply-To: <20250603070824.1192795-2-maz@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR10MB5433:EE_|CO1PR10MB4737:EE_
x-ms-office365-filtering-correlation-id: 35cc9591-e372-4e07-c7fa-08dda2c8adc6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?nuEg/PRk108NOJcfXf7/1S/Hf52fpAh9lJ58+jXiisRZgnHSWSlYvUo5Urr7?=
 =?us-ascii?Q?xYLkrg8wMSbszqSD2G4W2x+fooAFB9FVEZku7Ib1xFO6bsUQDNWykjmAhuJO?=
 =?us-ascii?Q?el1pbEoRiYSQaoNqTm0Fiaq95Ar1zbTiYV4Pw9/ELlkw0VEjP6/PXkxtoiZD?=
 =?us-ascii?Q?zpECaN0nCuDQcCfbTmD2wHo3e7HsxT5aEiTGk35fVJX38Iau/qKicjAyrAGr?=
 =?us-ascii?Q?oIVHf+GgpRXIUhc8ao+w9ovCH1QuVZM2dSK0HsEYubgjmgF9oS7QrqG/gQoB?=
 =?us-ascii?Q?IBMVmXAem5YtzvU+tR1R6aagjNNRLfl66R6v2BLEQpbX3nySIDmSBGA9G80h?=
 =?us-ascii?Q?VKCjYhKTl6RMvc5CMurHrfIUGomSpv8DSaVGDbVxS0o0IKTrR6MEvaOzEyUl?=
 =?us-ascii?Q?0gzAXoC801xaYOhPxbZBBtjTQQmtMlxu0JNiUZOytgyWkXD+5FMBOKJLaUfz?=
 =?us-ascii?Q?/UWAWtn1rYw93rpWTthX6H1p0PuGzY4vLSkKyBu/WbZ6s59rZ7OlorA1SmVd?=
 =?us-ascii?Q?KyPYWCKE0mdk26+NihdaOhOnWNsxN1bvprpFvSnY4OmIZnReP/bNAwl4kF9M?=
 =?us-ascii?Q?mpfQn9jTmZcrcKb4vGeGQ5M+3dxUzhnmUEnxZWtOPL96EsORKyVb3cDjAXg1?=
 =?us-ascii?Q?kHxaHDBlR5ia3ypiUtWd0lEz7BGjyB1ndeYUHo3Cct+TWtLsDF4A1f+U2NZ2?=
 =?us-ascii?Q?f/gAjqn2evIWPgobfYpzkutcwV2lVe//H81RGp9fVhgrp86+lkXam/5DLD6I?=
 =?us-ascii?Q?z6yqJSAMYjamXVTaU3ejsiRRuVDhDHnhIHX9XJTT5KpTeyV8hLKOP7Ap1pp2?=
 =?us-ascii?Q?NH13AzK1ts2fknAOFG2zE/GfzUvSiFxb3Ze5E2DVaittXw5yp1WdStF9vjmk?=
 =?us-ascii?Q?ukTsNm+rd4tb6m5wGCfP0DXVyQkU/yJzUPBwWlW15dY3RlJFUHkvYz4tMREG?=
 =?us-ascii?Q?lavL39yao67qakUTFDRXCqwgIAtr+eJUG5SwHDAXKBsUytXIr5e0Kw9gLCq+?=
 =?us-ascii?Q?7sXfDvboUZyTmsonN/cTnNxCww5YVS0tpd6pMOgMym531Id7xFoaDJgin0vK?=
 =?us-ascii?Q?t7rpfNsYrujq/Bb4mX3btDYPZJmI3IitBF4kq+zY+VQdi23ABGrtWBpYhx3T?=
 =?us-ascii?Q?AR8hNwAEugP4lTu1inopT3E7eZZwJAddebd68K4t4/jigDqonBCpsESDPq9k?=
 =?us-ascii?Q?BLerK5Bmis0JUiosFcxWHH6Z40223GXNrdfFh9xkc0r7ehwmKo4lzec2CzaJ?=
 =?us-ascii?Q?2hetFyq+DnOzDXT2BdNG+IivpuVpT/uomISikRcJpy3ylyurhH7A7JZn3BRt?=
 =?us-ascii?Q?1ASPUc7b9CY4A9GU460g3mgMbKilFz3BoVQpfPedTc38On4ZhDcJEv6FOIHR?=
 =?us-ascii?Q?rXJs9RInBOc9+eySpGNFC/6T24VfeUS228QwIxSb1nVv14rsSTyvzLPdNxAX?=
 =?us-ascii?Q?CdG7yIlLSZbSJyB4PuRyywiti8VUWjhWB4QmvirE4QlldvA1yHAR9VsYGs12?=
 =?us-ascii?Q?VIMKMQVHnxKgcis=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5433.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?NEM3ekm8C/KX2L3BXbr9wFoh68N07vKeUSQKfH1bzxoAeomOL6bmMRssIm9p?=
 =?us-ascii?Q?uoIECyZq594aM09+225k69+WOSfAtDqmLOLe9hi+yNIyb+ouvMFATvO80ot4?=
 =?us-ascii?Q?n7E7WTjO3/13SiVgOo6gpm4gSjIY9E1wrWV2Ka0pJ+lyVqPXzYEzaxf/fjaF?=
 =?us-ascii?Q?AEQNH2HS7oenqr6zGwO/zsWdZ0EeRl6A12eVRvNuxU7/WabEUjBh9GgiT95h?=
 =?us-ascii?Q?p2i7iEmm5LpZcuP+8HBFaUGPc6LlJ1XixDDSwgkwnTs7Ql7CWlQBKgG9qmlE?=
 =?us-ascii?Q?o3MorWWCEcCVElK3QbYonci33IKHxsP4C89JVya6rZ2ZV75NVJu8fCzyQlas?=
 =?us-ascii?Q?GMXB43cCK6oKjW/zeAflF4glsC5ifQeqd1/rGn1Na+96gHGbQ2uCbde1+0r4?=
 =?us-ascii?Q?AKY5GWdUeHkRJtCDCLDExLK/LftZmdhJfowaWXGB3F+Z4RnuhR37JePBGZVV?=
 =?us-ascii?Q?IWsRWumfoxR2EaZiSRoHoux6HvtO+e3Zxv1V6rG035pkKargDTmjXCL3zbQv?=
 =?us-ascii?Q?Ge6QMt0sLQBoGtENAhkt9usem3zzbolL3f7lXx46NT4VA0kFr57rfs+H3PMj?=
 =?us-ascii?Q?7rMMy8dxTbBXfUtbWvnhkxgjuRMGglc8cPI+OKkVmah21EzfitfCCZKFnN7n?=
 =?us-ascii?Q?Nl82Zd1VjTePMco7yjoyHB+mO2eq+5CV893AiL3JcjpyFzkHEKkrQlcZin1N?=
 =?us-ascii?Q?AKLvholoPMEb3risOaCsMnBGbhT6TE6b/asA+y6OPIynJYeWPJ3H0yyNLR2m?=
 =?us-ascii?Q?AGYhwI7iOnYUILx6E/7U9qsjM4vJCTGjiEbSHrcWtPFX/0RlLFj6EIBBGSOd?=
 =?us-ascii?Q?ciO3to6J1k/wukSW5pWswnmczqJYrttxwwhKRTPS7b/W1PI4Nn0/jGxKCk06?=
 =?us-ascii?Q?REYaGrvH11S6vZcXiCQQ+QhOAF2SkPrdlguAwbFwz15JfFaeMV0klphokb5n?=
 =?us-ascii?Q?3csE1WYeYvoyhnmkJnAJBdv/vtHW4dW/xdYdnRu7dNVOVcEPRecLudZNV9nz?=
 =?us-ascii?Q?Z8VBiS4r1CElk+Z5cQIwIZg49EK1AZKefe5NY9PdK+Ee4SVxGYE6Oxa/hJB/?=
 =?us-ascii?Q?1vo7SwgQhOqOK+MhdpQK+lCCbuF+L9Wdch8+c3l2jgN2zwGCBmkaCaaINo+l?=
 =?us-ascii?Q?EQFiYPFCVynCDj4gj0dUBYcqykQJH5JAn8W+YeWWirI+f1Zuolvd2xcMGwxR?=
 =?us-ascii?Q?E0lkjBy/fXxtAY7+WKs4K9pE1RqgQrHKC5SlMEnTQidw3vHY/HWg6EckrurT?=
 =?us-ascii?Q?KJbVGk8kwBg2VVZYRN5V/KrpfhUKouVHrviXtSPMz3zMr5koCwWKKyc1Keqm?=
 =?us-ascii?Q?U4K95hJxcD5hNrXgu+eJCG5e3T84uSFllw4b0dmjT9hjAoUpPAoo+Hw7grXJ?=
 =?us-ascii?Q?rtMN3kudiJuV4PlZOOewLULA3AuNFWBbTrvftcKJj8XcsnV1nI8DDSv9vfRO?=
 =?us-ascii?Q?UrCiqlL9N7sEDG9r9QfP8DGg1NKyYLPC7GTcqRDVfBE9NX4MN5oOxYamfSo5?=
 =?us-ascii?Q?diJ0SoX+Hb5Nd8OsUHx+xaic+nHZzCSbn7YAxAka5l04Ow462V2U1ytQ+QpT?=
 =?us-ascii?Q?dAQDvrSr59ub2mRHt9utcYATbK8wQv/QRYa/QzPc29Dggl3mbVwbmN77Q3up?=
 =?us-ascii?Q?0Q=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F0E3659E143DC742AC5D7C0D9145A73E@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	j8xUq9Ozr2yQdxZjI7rbD7ZCTHd7RtEk0YJoFKRHqInEdZxXpO2npGJTjr+N2UMxCu0Zcxnhg25ovr+EIE97Pgx3f/JI7mWFgn1czf9Ak2F/XI05kcLvLO/EyL9eyrTOIw+h7IFjVDby5UzKrzy042+qUD87y6JO/qgLYUmye/mlxtJXuHVJszaRbmMn9NZhyLtNAYcuhLFb9eULFUrJZ8a3TbsMZKTCPFJoRZedjpVDKOhwWhVQJLF9dPY6jqgNfXuxpQ9qQFMWipdtn+HXFOVAZEmL9wjE35qJ96xO+k2RpZusePXlztX5NJIck5iBFlJpE9uBmydyqn6LyCTojPPrwajQQEbDSb3RTlQ+e0DRqofdAt+EAYLTaP3priH2CT6gLa6N8dqhWVE99UF4MocmTTks6b3/QUl4Sk9BTNDQFmS4vocVMw8P8FWU88B+os+sIwv9Zp0q/xEYy5mzF/ojdk6G50XOumLr38U7+Ns/zwUC8yNI2D1JMf+vVXO866TjxcFP08meFzpDgrtm3KLRsBKcSXt2Wq0Vl+1dom4VL6C5CmlwQUX8L2l5jBXn3XO2A6HuoqMJDHDEvcZ5iXwAQN6P+uNLSRhF4KSPDV4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5433.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35cc9591-e372-4e07-c7fa-08dda2c8adc6
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jun 2025 18:01:34.8859
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +rE/Vki0Ww3wDj4hdOct0UTcfFZPIZ4ttE1KG4AWtbnjqNr27tLYrURgsQBgo7213XCL33hDLcHMb4QBONeKIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4737
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-03_02,2025-06-02_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 suspectscore=0 phishscore=0 adultscore=0 spamscore=0 mlxlogscore=999
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2506030157
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjAzMDE1NyBTYWx0ZWRfX5zLSYCIBzmHu KbRkoPaIn+2pYH1xWCaEE0hWRFNgaCja2jgtJZrhxY2Uh3pyzVWEmLSkudpzBJrUtg5U6d04QDL UKIgUhsBf8Zhz1MTYgvFkTiBCZwgwrrv3+kdeaLsLolPFpfz/BzbD3XW3KIS4/XhgQD2xMxYLyK
 oAHYhhv5MwV92b1iwjy6pQiT5YsRNKkUirGhmrTHQJvh2XYBO0cTXkUbMkdJe4VdhXAZ/oFJRgQ h6aRwd5rQgUpct3JqpnWW/uKDSRAwWuk6Fm8MhjZdjBHvYuttKk8GuX4JjQWTDMshhtjmt4EhwG x8kKYWVO4K6w6sCvVXZ621Dmp/MccTxrpJUzULEmZMKyAds1cUrhYKh/rrqgVmed2hzhcMer9M2
 pp+f3WZ2z6CgGyb+ONZ02WuXsFEhT35Zwggz+9wlrsf/KKQA2/n4ZxTiwXeH/zx5FaM6gU2Q
X-Proofpoint-GUID: ufhHiKTUPo-5GIOTl4FkD3m4EpKHn1q5
X-Proofpoint-ORIG-GUID: ufhHiKTUPo-5GIOTl4FkD3m4EpKHn1q5
X-Authority-Analysis: v=2.4 cv=H5Tbw/Yi c=1 sm=1 tr=0 ts=683f3883 b=1 cx=c_pps a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=x7FSe4bSpGLgn4tiAfkA:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:14714

Hi Marc,

> On 3 Jun 2025, at 07:08, Marc Zyngier <maz@kernel.org> wrote:
>=20
> Assigning a value to a system register doesn't do what it is
> supposed to be doing if that register is one that has RESx bits.
>=20
> The main problem is that we use __vcpu_sys_reg(), which can be used
> both as a lvalue and rvalue. When used as a lvalue, the bit masking
> occurs *before* the new value is assigned, meaning that we (1) do
> pointless work on the old cvalue, and (2) potentially assign an
> invalid value as we fail to apply the masks to it.
>=20
> Fix this by providing a new __vcpu_assign_sys_reg() that does
> what it says on the tin, and sanitises the *new* value instead of
> the old one. This comes with a significant amount of churn.
>=20
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
> arch/arm64/include/asm/kvm_host.h          | 11 ++++++
> arch/arm64/kvm/arch_timer.c                | 16 ++++----
> arch/arm64/kvm/hyp/exception.c             |  4 +-
> arch/arm64/kvm/hyp/include/hyp/switch.h    |  4 +-
> arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h |  6 +--
> arch/arm64/kvm/hyp/nvhe/hyp-main.c         |  4 +-
> arch/arm64/kvm/hyp/vhe/switch.c            |  4 +-
> arch/arm64/kvm/hyp/vhe/sysreg-sr.c         | 44 +++++++++++-----------
> arch/arm64/kvm/pmu-emul.c                  | 14 +++----
> arch/arm64/kvm/sys_regs.c                  | 38 ++++++++++---------
> arch/arm64/kvm/sys_regs.h                  |  4 +-
> arch/arm64/kvm/vgic/vgic-v3-nested.c       | 10 ++---
> 12 files changed, 86 insertions(+), 73 deletions(-)
>=20
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/k=
vm_host.h
> index d941abc6b5eef..3b84ad91116b4 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -1107,6 +1107,17 @@ static inline u64 *___ctxt_sys_reg(const struct kv=
m_cpu_context *ctxt, int r)
> #define ctxt_sys_reg(c,r) (*__ctxt_sys_reg(c,r))
>=20
> u64 kvm_vcpu_apply_reg_masks(const struct kvm_vcpu *, enum vcpu_sysreg, u=
64);
> +
> +#define __vcpu_assign_sys_reg(v, r, val) \
> + do { \
> + const struct kvm_cpu_context *ctxt =3D &(v)->arch.ctxt; \
> + u64 __v =3D (val); \
> + if (vcpu_has_nv((v)) && (r) >=3D __SANITISED_REG_START__) \

Would it make sense to make it more strict by testing < NR_SYS_REGS too?

Thanks
Miguel

> + __v =3D kvm_vcpu_apply_reg_masks((v), (r), __v); \
> + \
> + ctxt_sys_reg(ctxt, (r)) =3D __v; \
> + } while (0)
> +
> #define __vcpu_sys_reg(v,r) \
> (*({ \
> const struct kvm_cpu_context *ctxt =3D &(v)->arch.ctxt; \
> diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
> index 5133dcbfe9f76..5a67a6d4d95b7 100644
> --- a/arch/arm64/kvm/arch_timer.c
> +++ b/arch/arm64/kvm/arch_timer.c
> @@ -108,16 +108,16 @@ static void timer_set_ctl(struct arch_timer_context=
 *ctxt, u32 ctl)
>=20
> switch(arch_timer_ctx_index(ctxt)) {
> case TIMER_VTIMER:
> - __vcpu_sys_reg(vcpu, CNTV_CTL_EL0) =3D ctl;
> + __vcpu_assign_sys_reg(vcpu, CNTV_CTL_EL0, ctl);
> break;
> case TIMER_PTIMER:
> - __vcpu_sys_reg(vcpu, CNTP_CTL_EL0) =3D ctl;
> + __vcpu_assign_sys_reg(vcpu, CNTP_CTL_EL0, ctl);
> break;
> case TIMER_HVTIMER:
> - __vcpu_sys_reg(vcpu, CNTHV_CTL_EL2) =3D ctl;
> + __vcpu_assign_sys_reg(vcpu, CNTHV_CTL_EL2, ctl);
> break;
> case TIMER_HPTIMER:
> - __vcpu_sys_reg(vcpu, CNTHP_CTL_EL2) =3D ctl;
> + __vcpu_assign_sys_reg(vcpu, CNTHP_CTL_EL2, ctl);
> break;
> default:
> WARN_ON(1);
> @@ -130,16 +130,16 @@ static void timer_set_cval(struct arch_timer_contex=
t *ctxt, u64 cval)
>=20
> switch(arch_timer_ctx_index(ctxt)) {
> case TIMER_VTIMER:
> - __vcpu_sys_reg(vcpu, CNTV_CVAL_EL0) =3D cval;
> + __vcpu_assign_sys_reg(vcpu, CNTV_CVAL_EL0, cval);
> break;
> case TIMER_PTIMER:
> - __vcpu_sys_reg(vcpu, CNTP_CVAL_EL0) =3D cval;
> + __vcpu_assign_sys_reg(vcpu, CNTP_CVAL_EL0, cval);
> break;
> case TIMER_HVTIMER:
> - __vcpu_sys_reg(vcpu, CNTHV_CVAL_EL2) =3D cval;
> + __vcpu_assign_sys_reg(vcpu, CNTHV_CVAL_EL2, cval);
> break;
> case TIMER_HPTIMER:
> - __vcpu_sys_reg(vcpu, CNTHP_CVAL_EL2) =3D cval;
> + __vcpu_assign_sys_reg(vcpu, CNTHP_CVAL_EL2, cval);
> break;
> default:
> WARN_ON(1);
> diff --git a/arch/arm64/kvm/hyp/exception.c b/arch/arm64/kvm/hyp/exceptio=
n.c
> index 424a5107cddb5..6a2a899a344e6 100644
> --- a/arch/arm64/kvm/hyp/exception.c
> +++ b/arch/arm64/kvm/hyp/exception.c
> @@ -37,7 +37,7 @@ static inline void __vcpu_write_sys_reg(struct kvm_vcpu=
 *vcpu, u64 val, int reg)
> if (unlikely(vcpu_has_nv(vcpu)))
> vcpu_write_sys_reg(vcpu, val, reg);
> else if (!__vcpu_write_sys_reg_to_cpu(val, reg))
> - __vcpu_sys_reg(vcpu, reg) =3D val;
> + __vcpu_assign_sys_reg(vcpu, reg, val);
> }
>=20
> static void __vcpu_write_spsr(struct kvm_vcpu *vcpu, unsigned long target=
_mode,
> @@ -51,7 +51,7 @@ static void __vcpu_write_spsr(struct kvm_vcpu *vcpu, un=
signed long target_mode,
> } else if (has_vhe()) {
> write_sysreg_el1(val, SYS_SPSR);
> } else {
> - __vcpu_sys_reg(vcpu, SPSR_EL1) =3D val;
> + __vcpu_assign_sys_reg(vcpu, SPSR_EL1, val);
> }
> }
>=20
> diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp=
/include/hyp/switch.h
> index eef310cdbdbd5..aa5b561b92182 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> @@ -45,7 +45,7 @@ static inline void __fpsimd_save_fpexc32(struct kvm_vcp=
u *vcpu)
> if (!vcpu_el1_is_32bit(vcpu))
> return;
>=20
> - __vcpu_sys_reg(vcpu, FPEXC32_EL2) =3D read_sysreg(fpexc32_el2);
> + __vcpu_assign_sys_reg(vcpu, FPEXC32_EL2, read_sysreg(fpexc32_el2));
> }
>=20
> static inline void __activate_traps_fpsimd32(struct kvm_vcpu *vcpu)
> @@ -457,7 +457,7 @@ static inline void fpsimd_lazy_switch_to_host(struct =
kvm_vcpu *vcpu)
> */
> if (vcpu_has_sve(vcpu)) {
> zcr_el1 =3D read_sysreg_el1(SYS_ZCR);
> - __vcpu_sys_reg(vcpu, vcpu_sve_zcr_elx(vcpu)) =3D zcr_el1;
> + __vcpu_assign_sys_reg(vcpu, vcpu_sve_zcr_elx(vcpu), zcr_el1);
>=20
> /*
> * The guest's state is always saved using the guest's max VL.
> diff --git a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h b/arch/arm64/kvm/=
hyp/include/hyp/sysreg-sr.h
> index b9cff893bbe0b..4d0dbea4c56f7 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
> @@ -307,11 +307,11 @@ static inline void __sysreg32_save_state(struct kvm=
_vcpu *vcpu)
> vcpu->arch.ctxt.spsr_irq =3D read_sysreg(spsr_irq);
> vcpu->arch.ctxt.spsr_fiq =3D read_sysreg(spsr_fiq);
>=20
> - __vcpu_sys_reg(vcpu, DACR32_EL2) =3D read_sysreg(dacr32_el2);
> - __vcpu_sys_reg(vcpu, IFSR32_EL2) =3D read_sysreg(ifsr32_el2);
> + __vcpu_assign_sys_reg(vcpu, DACR32_EL2, read_sysreg(dacr32_el2));
> + __vcpu_assign_sys_reg(vcpu, IFSR32_EL2, read_sysreg(ifsr32_el2));
>=20
> if (has_vhe() || kvm_debug_regs_in_use(vcpu))
> - __vcpu_sys_reg(vcpu, DBGVCR32_EL2) =3D read_sysreg(dbgvcr32_el2);
> + __vcpu_assign_sys_reg(vcpu, DBGVCR32_EL2, read_sysreg(dbgvcr32_el2));
> }
>=20
> static inline void __sysreg32_restore_state(struct kvm_vcpu *vcpu)
> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe=
/hyp-main.c
> index 8e8848de4d470..e9198e56e784b 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> @@ -26,7 +26,7 @@ void __kvm_hyp_host_forward_smc(struct kvm_cpu_context =
*host_ctxt);
>=20
> static void __hyp_sve_save_guest(struct kvm_vcpu *vcpu)
> {
> - __vcpu_sys_reg(vcpu, ZCR_EL1) =3D read_sysreg_el1(SYS_ZCR);
> + __vcpu_assign_sys_reg(vcpu, ZCR_EL1, read_sysreg_el1(SYS_ZCR));
> /*
> * On saving/restoring guest sve state, always use the maximum VL for
> * the guest. The layout of the data when saving the sve state depends
> @@ -79,7 +79,7 @@ static void fpsimd_sve_sync(struct kvm_vcpu *vcpu)
>=20
> has_fpmr =3D kvm_has_fpmr(kern_hyp_va(vcpu->kvm));
> if (has_fpmr)
> - __vcpu_sys_reg(vcpu, FPMR) =3D read_sysreg_s(SYS_FPMR);
> + __vcpu_assign_sys_reg(vcpu, FPMR, read_sysreg_s(SYS_FPMR));
>=20
> if (system_supports_sve())
> __hyp_sve_restore_host();
> diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/swi=
tch.c
> index c9b330dc20669..09df2b42bc1b7 100644
> --- a/arch/arm64/kvm/hyp/vhe/switch.c
> +++ b/arch/arm64/kvm/hyp/vhe/switch.c
> @@ -223,9 +223,9 @@ static void __deactivate_traps(struct kvm_vcpu *vcpu)
> */
> val =3D read_sysreg_el0(SYS_CNTP_CVAL);
> if (map.direct_ptimer =3D=3D vcpu_ptimer(vcpu))
> - __vcpu_sys_reg(vcpu, CNTP_CVAL_EL0) =3D val;
> + __vcpu_assign_sys_reg(vcpu, CNTP_CVAL_EL0, val);
> if (map.direct_ptimer =3D=3D vcpu_hptimer(vcpu))
> - __vcpu_sys_reg(vcpu, CNTHP_CVAL_EL2) =3D val;
> + __vcpu_assign_sys_reg(vcpu, CNTHP_CVAL_EL2, val);
>=20
> offset =3D read_sysreg_s(SYS_CNTPOFF_EL2);
>=20
> diff --git a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c b/arch/arm64/kvm/hyp/vhe/=
sysreg-sr.c
> index 3814b0b2c937f..34c7bf7fe9def 100644
> --- a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
> +++ b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
> @@ -18,17 +18,17 @@
> static void __sysreg_save_vel2_state(struct kvm_vcpu *vcpu)
> {
> /* These registers are common with EL1 */
> - __vcpu_sys_reg(vcpu, PAR_EL1) =3D read_sysreg(par_el1);
> - __vcpu_sys_reg(vcpu, TPIDR_EL1) =3D read_sysreg(tpidr_el1);
> -
> - __vcpu_sys_reg(vcpu, ESR_EL2) =3D read_sysreg_el1(SYS_ESR);
> - __vcpu_sys_reg(vcpu, AFSR0_EL2) =3D read_sysreg_el1(SYS_AFSR0);
> - __vcpu_sys_reg(vcpu, AFSR1_EL2) =3D read_sysreg_el1(SYS_AFSR1);
> - __vcpu_sys_reg(vcpu, FAR_EL2) =3D read_sysreg_el1(SYS_FAR);
> - __vcpu_sys_reg(vcpu, MAIR_EL2) =3D read_sysreg_el1(SYS_MAIR);
> - __vcpu_sys_reg(vcpu, VBAR_EL2) =3D read_sysreg_el1(SYS_VBAR);
> - __vcpu_sys_reg(vcpu, CONTEXTIDR_EL2) =3D read_sysreg_el1(SYS_CONTEXTIDR=
);
> - __vcpu_sys_reg(vcpu, AMAIR_EL2) =3D read_sysreg_el1(SYS_AMAIR);
> + __vcpu_assign_sys_reg(vcpu, PAR_EL1, read_sysreg(par_el1));
> + __vcpu_assign_sys_reg(vcpu, TPIDR_EL1, read_sysreg(tpidr_el1));
> +
> + __vcpu_assign_sys_reg(vcpu, ESR_EL2, read_sysreg_el1(SYS_ESR));
> + __vcpu_assign_sys_reg(vcpu, AFSR0_EL2, read_sysreg_el1(SYS_AFSR0));
> + __vcpu_assign_sys_reg(vcpu, AFSR1_EL2, read_sysreg_el1(SYS_AFSR1));
> + __vcpu_assign_sys_reg(vcpu, FAR_EL2, read_sysreg_el1(SYS_FAR));
> + __vcpu_assign_sys_reg(vcpu, MAIR_EL2, read_sysreg_el1(SYS_MAIR));
> + __vcpu_assign_sys_reg(vcpu, VBAR_EL2, read_sysreg_el1(SYS_VBAR));
> + __vcpu_assign_sys_reg(vcpu, CONTEXTIDR_EL2, read_sysreg_el1(SYS_CONTEXT=
IDR));
> + __vcpu_assign_sys_reg(vcpu, AMAIR_EL2, read_sysreg_el1(SYS_AMAIR));
>=20
> /*
> * In VHE mode those registers are compatible between EL1 and EL2,
> @@ -46,21 +46,21 @@ static void __sysreg_save_vel2_state(struct kvm_vcpu =
*vcpu)
> * are always trapped, ensuring that the in-memory
> * copy is always up-to-date. A small blessing...
> */
> - __vcpu_sys_reg(vcpu, SCTLR_EL2) =3D read_sysreg_el1(SYS_SCTLR);
> - __vcpu_sys_reg(vcpu, TTBR0_EL2) =3D read_sysreg_el1(SYS_TTBR0);
> - __vcpu_sys_reg(vcpu, TTBR1_EL2) =3D read_sysreg_el1(SYS_TTBR1);
> - __vcpu_sys_reg(vcpu, TCR_EL2) =3D read_sysreg_el1(SYS_TCR);
> + __vcpu_assign_sys_reg(vcpu, SCTLR_EL2, read_sysreg_el1(SYS_SCTLR));
> + __vcpu_assign_sys_reg(vcpu, TTBR0_EL2, read_sysreg_el1(SYS_TTBR0));
> + __vcpu_assign_sys_reg(vcpu, TTBR1_EL2, read_sysreg_el1(SYS_TTBR1));
> + __vcpu_assign_sys_reg(vcpu, TCR_EL2, read_sysreg_el1(SYS_TCR));
>=20
> if (ctxt_has_tcrx(&vcpu->arch.ctxt)) {
> - __vcpu_sys_reg(vcpu, TCR2_EL2) =3D read_sysreg_el1(SYS_TCR2);
> + __vcpu_assign_sys_reg(vcpu, TCR2_EL2, read_sysreg_el1(SYS_TCR2));
>=20
> if (ctxt_has_s1pie(&vcpu->arch.ctxt)) {
> - __vcpu_sys_reg(vcpu, PIRE0_EL2) =3D read_sysreg_el1(SYS_PIRE0);
> - __vcpu_sys_reg(vcpu, PIR_EL2) =3D read_sysreg_el1(SYS_PIR);
> + __vcpu_assign_sys_reg(vcpu, PIRE0_EL2, read_sysreg_el1(SYS_PIRE0));
> + __vcpu_assign_sys_reg(vcpu, PIR_EL2, read_sysreg_el1(SYS_PIR));
> }
>=20
> if (ctxt_has_s1poe(&vcpu->arch.ctxt))
> - __vcpu_sys_reg(vcpu, POR_EL2) =3D read_sysreg_el1(SYS_POR);
> + __vcpu_assign_sys_reg(vcpu, POR_EL2, read_sysreg_el1(SYS_POR));
> }
>=20
> /*
> @@ -74,9 +74,9 @@ static void __sysreg_save_vel2_state(struct kvm_vcpu *v=
cpu)
> __vcpu_sys_reg(vcpu, CNTHCTL_EL2) |=3D val;
> }
>=20
> - __vcpu_sys_reg(vcpu, SP_EL2) =3D read_sysreg(sp_el1);
> - __vcpu_sys_reg(vcpu, ELR_EL2) =3D read_sysreg_el1(SYS_ELR);
> - __vcpu_sys_reg(vcpu, SPSR_EL2) =3D read_sysreg_el1(SYS_SPSR);
> + __vcpu_assign_sys_reg(vcpu, SP_EL2, read_sysreg(sp_el1));
> + __vcpu_assign_sys_reg(vcpu, ELR_EL2, read_sysreg_el1(SYS_ELR));
> + __vcpu_assign_sys_reg(vcpu, SPSR_EL2, read_sysreg_el1(SYS_SPSR));
> }
>=20
> static void __sysreg_restore_vel2_state(struct kvm_vcpu *vcpu)
> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> index 25c29107f13fd..4f0ae8073f788 100644
> --- a/arch/arm64/kvm/pmu-emul.c
> +++ b/arch/arm64/kvm/pmu-emul.c
> @@ -178,7 +178,7 @@ static void kvm_pmu_set_pmc_value(struct kvm_pmc *pmc=
, u64 val, bool force)
> val |=3D lower_32_bits(val);
> }
>=20
> - __vcpu_sys_reg(vcpu, reg) =3D val;
> + __vcpu_assign_sys_reg(vcpu, reg, val);
>=20
> /* Recreate the perf event to reflect the updated sample_period */
> kvm_pmu_create_perf_event(pmc);
> @@ -204,7 +204,7 @@ void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu,=
 u64 select_idx, u64 val)
> void kvm_pmu_set_counter_value_user(struct kvm_vcpu *vcpu, u64 select_idx=
, u64 val)
> {
> kvm_pmu_release_perf_event(kvm_vcpu_idx_to_pmc(vcpu, select_idx));
> - __vcpu_sys_reg(vcpu, counter_index_to_reg(select_idx)) =3D val;
> + __vcpu_assign_sys_reg(vcpu, counter_index_to_reg(select_idx), val);
> kvm_make_request(KVM_REQ_RELOAD_PMU, vcpu);
> }
>=20
> @@ -239,7 +239,7 @@ static void kvm_pmu_stop_counter(struct kvm_pmc *pmc)
>=20
> reg =3D counter_index_to_reg(pmc->idx);
>=20
> - __vcpu_sys_reg(vcpu, reg) =3D val;
> + __vcpu_assign_sys_reg(vcpu, reg, val);
>=20
> kvm_pmu_release_perf_event(pmc);
> }
> @@ -503,7 +503,7 @@ static void kvm_pmu_counter_increment(struct kvm_vcpu=
 *vcpu,
> reg =3D __vcpu_sys_reg(vcpu, counter_index_to_reg(i)) + 1;
> if (!kvm_pmc_is_64bit(pmc))
> reg =3D lower_32_bits(reg);
> - __vcpu_sys_reg(vcpu, counter_index_to_reg(i)) =3D reg;
> + __vcpu_assign_sys_reg(vcpu, counter_index_to_reg(i), reg);
>=20
> /* No overflow? move on */
> if (kvm_pmc_has_64bit_overflow(pmc) ? reg : lower_32_bits(reg))
> @@ -602,7 +602,7 @@ void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 v=
al)
> kvm_make_request(KVM_REQ_RELOAD_PMU, vcpu);
>=20
> /* The reset bits don't indicate any state, and shouldn't be saved. */
> - __vcpu_sys_reg(vcpu, PMCR_EL0) =3D val & ~(ARMV8_PMU_PMCR_C | ARMV8_PMU=
_PMCR_P);
> + __vcpu_assign_sys_reg(vcpu, PMCR_EL0, (val & ~(ARMV8_PMU_PMCR_C | ARMV8=
_PMU_PMCR_P)));
>=20
> if (val & ARMV8_PMU_PMCR_C)
> kvm_pmu_set_counter_value(vcpu, ARMV8_PMU_CYCLE_IDX, 0);
> @@ -779,7 +779,7 @@ void kvm_pmu_set_counter_event_type(struct kvm_vcpu *=
vcpu, u64 data,
> u64 reg;
>=20
> reg =3D counter_index_to_evtreg(pmc->idx);
> - __vcpu_sys_reg(vcpu, reg) =3D data & kvm_pmu_evtyper_mask(vcpu->kvm);
> + __vcpu_assign_sys_reg(vcpu, reg, (data & kvm_pmu_evtyper_mask(vcpu->kvm=
)));
>=20
> kvm_pmu_create_perf_event(pmc);
> }
> @@ -1038,7 +1038,7 @@ static void kvm_arm_set_nr_counters(struct kvm *kvm=
, unsigned int nr)
> u64 val =3D __vcpu_sys_reg(vcpu, MDCR_EL2);
> val &=3D ~MDCR_EL2_HPMN;
> val |=3D FIELD_PREP(MDCR_EL2_HPMN, kvm->arch.nr_pmu_counters);
> - __vcpu_sys_reg(vcpu, MDCR_EL2) =3D val;
> + __vcpu_assign_sys_reg(vcpu, MDCR_EL2, val);
> }
> }
> }
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 707c651aff031..93d0ca7ed9365 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -228,7 +228,7 @@ void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 va=
l, int reg)
> * to reverse-translate virtual EL2 system registers for a
> * non-VHE guest hypervisor.
> */
> - __vcpu_sys_reg(vcpu, reg) =3D val;
> + __vcpu_assign_sys_reg(vcpu, reg, val);
>=20
> switch (reg) {
> case CNTHCTL_EL2:
> @@ -263,7 +263,7 @@ void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 va=
l, int reg)
> return;
>=20
> memory_write:
> - __vcpu_sys_reg(vcpu, reg) =3D val;
> + __vcpu_assign_sys_reg(vcpu, reg, val);
> }
>=20
> /* CSSELR values; used to index KVM_REG_ARM_DEMUX_ID_CCSIDR */
> @@ -605,7 +605,7 @@ static int set_oslsr_el1(struct kvm_vcpu *vcpu, const=
 struct sys_reg_desc *rd,
> if ((val ^ rd->val) & ~OSLSR_EL1_OSLK)
> return -EINVAL;
>=20
> - __vcpu_sys_reg(vcpu, rd->reg) =3D val;
> + __vcpu_assign_sys_reg(vcpu, rd->reg, val);
> return 0;
> }
>=20
> @@ -835,7 +835,7 @@ static u64 reset_pmcr(struct kvm_vcpu *vcpu, const st=
ruct sys_reg_desc *r)
> * The value of PMCR.N field is included when the
> * vCPU register is read via kvm_vcpu_read_pmcr().
> */
> - __vcpu_sys_reg(vcpu, r->reg) =3D pmcr;
> + __vcpu_assign_sys_reg(vcpu, r->reg, pmcr);
>=20
> return __vcpu_sys_reg(vcpu, r->reg);
> }
> @@ -907,7 +907,7 @@ static bool access_pmselr(struct kvm_vcpu *vcpu, stru=
ct sys_reg_params *p,
> return false;
>=20
> if (p->is_write)
> - __vcpu_sys_reg(vcpu, PMSELR_EL0) =3D p->regval;
> + __vcpu_assign_sys_reg(vcpu, PMSELR_EL0, p->regval);
> else
> /* return PMSELR.SEL field */
> p->regval =3D __vcpu_sys_reg(vcpu, PMSELR_EL0)
> @@ -1076,7 +1076,7 @@ static int set_pmreg(struct kvm_vcpu *vcpu, const s=
truct sys_reg_desc *r, u64 va
> {
> u64 mask =3D kvm_pmu_accessible_counter_mask(vcpu);
>=20
> - __vcpu_sys_reg(vcpu, r->reg) =3D val & mask;
> + __vcpu_assign_sys_reg(vcpu, r->reg, val & mask);
> kvm_make_request(KVM_REQ_RELOAD_PMU, vcpu);
>=20
> return 0;
> @@ -1185,8 +1185,8 @@ static bool access_pmuserenr(struct kvm_vcpu *vcpu,=
 struct sys_reg_params *p,
> if (!vcpu_mode_priv(vcpu))
> return undef_access(vcpu, p, r);
>=20
> - __vcpu_sys_reg(vcpu, PMUSERENR_EL0) =3D
> -       p->regval & ARMV8_PMU_USERENR_MASK;
> + __vcpu_assign_sys_reg(vcpu, PMUSERENR_EL0,
> +      (p->regval & ARMV8_PMU_USERENR_MASK));
> } else {
> p->regval =3D __vcpu_sys_reg(vcpu, PMUSERENR_EL0)
>    & ARMV8_PMU_USERENR_MASK;
> @@ -1237,7 +1237,7 @@ static int set_pmcr(struct kvm_vcpu *vcpu, const st=
ruct sys_reg_desc *r,
> if (!kvm_supports_32bit_el0())
> val |=3D ARMV8_PMU_PMCR_LC;
>=20
> - __vcpu_sys_reg(vcpu, r->reg) =3D val;
> + __vcpu_assign_sys_reg(vcpu, r->reg, val);
> kvm_make_request(KVM_REQ_RELOAD_PMU, vcpu);
>=20
> return 0;
> @@ -2207,7 +2207,7 @@ static u64 reset_clidr(struct kvm_vcpu *vcpu, const=
 struct sys_reg_desc *r)
> if (kvm_has_mte(vcpu->kvm))
> clidr |=3D 2ULL << CLIDR_TTYPE_SHIFT(loc);
>=20
> - __vcpu_sys_reg(vcpu, r->reg) =3D clidr;
> + __vcpu_assign_sys_reg(vcpu, r->reg, clidr);
>=20
> return __vcpu_sys_reg(vcpu, r->reg);
> }
> @@ -2221,7 +2221,7 @@ static int set_clidr(struct kvm_vcpu *vcpu, const s=
truct sys_reg_desc *rd,
> if ((val & CLIDR_EL1_RES0) || (!(ctr_el0 & CTR_EL0_IDC) && idc))
> return -EINVAL;
>=20
> - __vcpu_sys_reg(vcpu, rd->reg) =3D val;
> + __vcpu_assign_sys_reg(vcpu, rd->reg, val);
>=20
> return 0;
> }
> @@ -2398,7 +2398,7 @@ static bool access_sp_el1(struct kvm_vcpu *vcpu,
>  const struct sys_reg_desc *r)
> {
> if (p->is_write)
> - __vcpu_sys_reg(vcpu, SP_EL1) =3D p->regval;
> + __vcpu_assign_sys_reg(vcpu, SP_EL1, p->regval);
> else
> p->regval =3D __vcpu_sys_reg(vcpu, SP_EL1);
>=20
> @@ -2422,7 +2422,7 @@ static bool access_spsr(struct kvm_vcpu *vcpu,
> const struct sys_reg_desc *r)
> {
> if (p->is_write)
> - __vcpu_sys_reg(vcpu, SPSR_EL1) =3D p->regval;
> + __vcpu_assign_sys_reg(vcpu, SPSR_EL1, p->regval);
> else
> p->regval =3D __vcpu_sys_reg(vcpu, SPSR_EL1);
>=20
> @@ -2434,7 +2434,7 @@ static bool access_cntkctl_el12(struct kvm_vcpu *vc=
pu,
> const struct sys_reg_desc *r)
> {
> if (p->is_write)
> - __vcpu_sys_reg(vcpu, CNTKCTL_EL1) =3D p->regval;
> + __vcpu_assign_sys_reg(vcpu, CNTKCTL_EL1, p->regval);
> else
> p->regval =3D __vcpu_sys_reg(vcpu, CNTKCTL_EL1);
>=20
> @@ -2448,7 +2448,9 @@ static u64 reset_hcr(struct kvm_vcpu *vcpu, const s=
truct sys_reg_desc *r)
> if (!cpus_have_final_cap(ARM64_HAS_HCR_NV1))
> val |=3D HCR_E2H;
>=20
> - return __vcpu_sys_reg(vcpu, r->reg) =3D val;
> + __vcpu_assign_sys_reg(vcpu, r->reg, val);
> +
> + return __vcpu_sys_reg(vcpu, r->reg);
> }
>=20
> static unsigned int __el2_visibility(const struct kvm_vcpu *vcpu,
> @@ -2619,7 +2621,7 @@ static bool access_mdcr(struct kvm_vcpu *vcpu,
> u64_replace_bits(val, hpmn, MDCR_EL2_HPMN);
> }
>=20
> - __vcpu_sys_reg(vcpu, MDCR_EL2) =3D val;
> + __vcpu_assign_sys_reg(vcpu, MDCR_EL2, val);
>=20
> /*
> * Request a reload of the PMU to enable/disable the counters
> @@ -2748,7 +2750,7 @@ static int set_imp_id_reg(struct kvm_vcpu *vcpu, co=
nst struct sys_reg_desc *r,
>=20
> static u64 reset_mdcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r=
)
> {
> - __vcpu_sys_reg(vcpu, r->reg) =3D vcpu->kvm->arch.nr_pmu_counters;
> + __vcpu_assign_sys_reg(vcpu, r->reg, vcpu->kvm->arch.nr_pmu_counters);
> return vcpu->kvm->arch.nr_pmu_counters;
> }
>=20
> @@ -5006,7 +5008,7 @@ int kvm_sys_reg_set_user(struct kvm_vcpu *vcpu, con=
st struct kvm_one_reg *reg,
> if (r->set_user) {
> ret =3D (r->set_user)(vcpu, r, val);
> } else {
> - __vcpu_sys_reg(vcpu, r->reg) =3D val;
> + __vcpu_assign_sys_reg(vcpu, r->reg, val);
> ret =3D 0;
> }
>=20
> diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
> index cc6338d387663..ef97d9fc67cc5 100644
> --- a/arch/arm64/kvm/sys_regs.h
> +++ b/arch/arm64/kvm/sys_regs.h
> @@ -137,7 +137,7 @@ static inline u64 reset_unknown(struct kvm_vcpu *vcpu=
,
> {
> BUG_ON(!r->reg);
> BUG_ON(r->reg >=3D NR_SYS_REGS);
> - __vcpu_sys_reg(vcpu, r->reg) =3D 0x1de7ec7edbadc0deULL;
> + __vcpu_assign_sys_reg(vcpu, r->reg, 0x1de7ec7edbadc0deULL);
> return __vcpu_sys_reg(vcpu, r->reg);
> }
>=20
> @@ -145,7 +145,7 @@ static inline u64 reset_val(struct kvm_vcpu *vcpu, co=
nst struct sys_reg_desc *r)
> {
> BUG_ON(!r->reg);
> BUG_ON(r->reg >=3D NR_SYS_REGS);
> - __vcpu_sys_reg(vcpu, r->reg) =3D r->val;
> + __vcpu_assign_sys_reg(vcpu, r->reg, r->val);
> return __vcpu_sys_reg(vcpu, r->reg);
> }
>=20
> diff --git a/arch/arm64/kvm/vgic/vgic-v3-nested.c b/arch/arm64/kvm/vgic/v=
gic-v3-nested.c
> index 4f6954c306747..d22a8ad7bcc51 100644
> --- a/arch/arm64/kvm/vgic/vgic-v3-nested.c
> +++ b/arch/arm64/kvm/vgic/vgic-v3-nested.c
> @@ -356,12 +356,12 @@ void vgic_v3_put_nested(struct kvm_vcpu *vcpu)
> val =3D __vcpu_sys_reg(vcpu, ICH_HCR_EL2);
> val &=3D ~ICH_HCR_EL2_EOIcount_MASK;
> val |=3D (s_cpu_if->vgic_hcr & ICH_HCR_EL2_EOIcount_MASK);
> - __vcpu_sys_reg(vcpu, ICH_HCR_EL2) =3D val;
> - __vcpu_sys_reg(vcpu, ICH_VMCR_EL2) =3D s_cpu_if->vgic_vmcr;
> + __vcpu_assign_sys_reg(vcpu, ICH_HCR_EL2, val);
> + __vcpu_assign_sys_reg(vcpu, ICH_VMCR_EL2, s_cpu_if->vgic_vmcr);
>=20
> for (i =3D 0; i < 4; i++) {
> - __vcpu_sys_reg(vcpu, ICH_AP0RN(i)) =3D s_cpu_if->vgic_ap0r[i];
> - __vcpu_sys_reg(vcpu, ICH_AP1RN(i)) =3D s_cpu_if->vgic_ap1r[i];
> + __vcpu_assign_sys_reg(vcpu, ICH_AP0RN(i), s_cpu_if->vgic_ap0r[i]);
> + __vcpu_assign_sys_reg(vcpu, ICH_AP1RN(i), s_cpu_if->vgic_ap1r[i]);
> }
>=20
> for_each_set_bit(i, &shadow_if->lr_map, kvm_vgic_global_state.nr_lr) {
> @@ -370,7 +370,7 @@ void vgic_v3_put_nested(struct kvm_vcpu *vcpu)
> val &=3D ~ICH_LR_STATE;
> val |=3D s_cpu_if->vgic_lr[i] & ICH_LR_STATE;
>=20
> - __vcpu_sys_reg(vcpu, ICH_LRN(i)) =3D val;
> + __vcpu_assign_sys_reg(vcpu, ICH_LRN(i), val);
> s_cpu_if->vgic_lr[i] =3D 0;
> }
>=20
> --=20
> 2.39.2
>=20
>=20

