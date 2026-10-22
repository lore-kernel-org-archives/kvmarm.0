Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.155.12
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792667741;
	b=k0uC8cAvEk+nbRKBLjxBUcTe/BGgI7V4uiFlsXRMPxkoszw4Dss0u5/ESI3xmBzDJYwr
	 lbaDKAKjhg/9Jckfp92j3lpKIGMkcR+Q2uwgTRM6Ss+ZL7T12NQl1ewaRTc3GcQdCcZmB
	 spEM8awrr/9bvRxlSPjelFKOkRHjx10vqKJTsUlnPSuNiQqtjleCffphPEKrdqFEZYD9m
	 6nxA4c4KC9TRbGtLSiXDfcsKPop4VRdqmhK1AWH25ZCauzCGLqhw4oO/g40diQn0EWyHU
	 faj0/aoz1N+C3USiHZgYUWgQM96/zbhNsbeZg1socTYfqTz+NZW1osm4wGQtKZvE9Sw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792667741;
	h=DMARC-Filter:Received:DKIM-Signature:Received:DKIM-Signature:
	 Received:Received:From:To:CC:Subject:Thread-Topic:Thread-Index:Date:
	 Message-ID:References:In-Reply-To:Accept-Language:Content-Language:
	 X-MS-Has-Attach:X-MS-TNEF-Correlator:x-ms-publictraffictype:
	 x-ms-traffictypediagnostic:x-ms-office365-filtering-correlation-id:
	 x-proofpoint-crosstenant:x-ms-exchange-senderadcheck:
	 x-ms-exchange-antispam-relay:x-microsoft-antispam:
	 x-microsoft-antispam-message-info:x-forefront-antispam-report:
	 x-ms-exchange-antispam-messagedata-chunkcount:
	 x-ms-exchange-antispam-messagedata-0:Content-Type:Content-ID:
	 Content-Transfer-Encoding:MIME-Version:
	 X-Exchange-RoutingPolicyChecked:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-AuthAs:X-MS-Exchange-CrossTenant-AuthSource:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-originalarrivaltime:
	 X-MS-Exchange-CrossTenant-fromentityheader:
	 X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
	 X-MS-Exchange-CrossTenant-userprincipalname:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:
	 X-Authority-Analysis:X-Proofpoint-GUID:X-Proofpoint-Spam-Info:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Reason;
	bh=O6HZWd1A4Fle1LTpX1B3X/CbjTBFw/JlkqJioZhEN4A=;
	b=ZTvuR59iu1ppHjXoAyAXHzbRR4tca6Bww4uPpBAKaFs1xK/0tCtCgeuO30rAIqrIGCZh
	 5hMlvquhxZEuWxkaWw6DdHMj54zp9Oagc+EImLl64zFh8gzcRcNduxcnc7RU4pagz/p/7
	 7sJVNa2V6QxqYIhlV5pucauj6tsPtvIy76EFewuh7BsjoZQTR1eS5J+JVfE1fBMPYGL0l
	 mWwfFOaKZJXQOBQT75iGRiuh0NBGSfKeoHZno9XbwhAUZ7xK/DHbRETi7B6aozCy47sUV
	 s3/KBpfokYuvqO5fDfeTGmUR7kt9H7BvsMqzKDLVfJraQ9ISG7gv3a3qrRQvhfgTd4w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nutanix.com;
	spf=pass smtp.mailfrom=nutanix.com;
	dkim=pass header.d=nutanix.com header.i=@nutanix.com header.a=rsa-sha256 header.s=proofpoint20171006 header.b=m+GgnB6Y;
	dkim=pass header.d=nutanix.com header.i=@nutanix.com header.a=rsa-sha256 header.s=selector1 header.b=akMeEi8L;
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.155.12
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45F9F606A31A
	for <kvmarm@lists.linux.dev>; Thu, 22 Oct 2026 11:15:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 45F9F606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=nutanix.com header.i=@nutanix.com header.a=rsa-sha256 header.s=proofpoint20171006 header.b=m+GgnB6Y;
	dkim=pass (2048-bit key, unprotected) header.d=nutanix.com header.i=@nutanix.com header.a=rsa-sha256 header.s=selector1 header.b=akMeEi8L
Received: from pps.filterd (m0127842.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69M9xpiO2875364;
	Thu, 22 Oct 2026 04:15:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=O6HZWd1A4Fle1LTpX1B3X/CbjTBFw/JlkqJioZhEN
	4A=; b=m+GgnB6Y35ngqpFCj5atxzxBgldEM2Y3yKtowsLEF3yFHY6hl0VRULRKB
	GRACQ9E5/XO8Ee4Yd29X8Hy/UPfwZL5vrEkDli932DWygqQ2RfvkUAUF4HB7XuAl
	c+bZ7TBYwmoYZiGWWh2nLR67qcHyB2kKQ6rN2h9F88S2/1jV1qiSpyZmS/SpvJyV
	DaNWXef1Cq6+AQNSGels9NNfWQZsIAMWYDewcr/CVY3yeK6A2m4SiIA5MFAwZUVA
	4DI1P6WU7Wx5bgjQpwleKBCc7R/ChVf0V8qVr2WVEfFMfvmSGDdkqOdjByH1cDh4
	gwGYTGD1a2sHQE/xUo3MF9giE1CpA==
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11021131.outbound.protection.outlook.com [40.107.208.131])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4hf9729ash-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 22 Oct 2026 04:15:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=r4Pe9ULA4huLNTXvQZxyr7l4Uv68qBl6BH/VpnVXSxAxbJjbPqSxRBV1TTRzWWnfn8HoM+HxRW2IMXf14uwcJWVFwwpbIF9XLYD042sb+1UT+HULFIBxry+lKLlzyur5Rx/an4O0Z5jb+GFfHVWKuVPy2S78hYadqIK/ZtLJSamhGEyUNv48Cgyn6N5kNJnnmNxoBHnKoPEaDteijrx1yZ3hJtPw6Oodu/l4/+n3junRXI3VA2fIB/EKV7vtG+vUVq3p9G2jZ3Xmjaa79+XTVqG0elX/Bymvyg4ua7BGXbmyjXZm5IpNWcIgk2bDR4MG+nA5x7ix7i4Ip/evAzkFyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O6HZWd1A4Fle1LTpX1B3X/CbjTBFw/JlkqJioZhEN4A=;
 b=P8E3STneEYVq1rvZZ74XMH/XW5vx0DAqe+kj+T+e8toL3Wpzz/GSdFb3F4FwCoTkzqICKTHUJlK7J0ZrZhIMhAvASFFpDGky8rlmIU0gaefPXetBDZuj34wpzh2q4YwVq8M5JmDY643LCOuanjIkp5J3BQzlT6B2NiiIW3ems4uwA4DKwtRPl7+PqR2oUSxtPrhCiInDMBiFvgSorweWvGV2/eqRLhEm8zatIRU2MEAw7KiW9s3mzpqKjzkFed9nCCaJe9t9cALcQngROo3nf54YCA3t6ntlKSk58PkWpWtUhhwTRSRN76daNFRslu3zmopdjnHQM2rndefpxRJtRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O6HZWd1A4Fle1LTpX1B3X/CbjTBFw/JlkqJioZhEN4A=;
 b=akMeEi8LFoUpV97cVdDQWLs1+HS69HIh6HVBoSjskuTqqH0ohfb8j0D+Rf1raJgMS93/OCZFmIQaeYU+YTavY3AYUpFcH1w0tvyk5hVvfbt2rqsprLc7teBldPuQPZY9j92NWi/AuINICJ123zt2/WvZkJgMnjj5yXD7Kj5P73Cw8vJ3Y2T2xyWwCf5c5qbhf/bZzUMPUBCs54IoTqGgORRk5pQGf3oVzVQJZvI5rejirUTp6flSIVTL6AdoQMpneoVs/MEM/5HTprKzdeqxdiWlvQa046QaGLcgjBwZW0vStWIeJ6M2hulcKSFDadjbmkB4dbnI2oRKmC6lMwnubA==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by SA3PR02MB11046.namprd02.prod.outlook.com (2603:10b6:806:460::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.15; Thu, 22 Oct
 2026 11:15:24 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%5]) with mapi id 15.21.0546.012; Thu, 22 Oct 2026
 11:15:23 +0000
From: Khushit Shah <khushit.shah@nutanix.com>
To: "eric.auger@redhat.com" <eric.auger@redhat.com>
CC: "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "qemu-arm@nongnu.org"
	<qemu-arm@nongnu.org>,
        "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>,
        "richard.henderson@linaro.org"
	<richard.henderson@linaro.org>,
        "maz@kernel.org" <maz@kernel.org>,
        "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
        "berrange@redhat.com"
	<berrange@redhat.com>,
        "abologna@redhat.com" <abologna@redhat.com>,
        "jdenemar@redhat.com" <jdenemar@redhat.com>,
        "gshan@redhat.com"
	<gshan@redhat.com>,
        "skolothumtho@nvidia.com" <skolothumtho@nvidia.com>,
        "sebott@redhat.com" <sebott@redhat.com>,
        "armbru@redhat.com"
	<armbru@redhat.com>,
        "philmd@linaro.org" <philmd@linaro.org>,
        "yangjinqian1@huawei.com" <yangjinqian1@huawei.com>,
        Shaju Abraham
	<shaju.abraham@nutanix.com>,
        Mark Cave-Ayland <mark.caveayland@nutanix.com>,
        "ping@khushitshah.com" <ping@khushitshah.com>,
        Sandesh Patel
	<sandesh.patel@nutanix.com>
Subject: Re: [RFC PATCH v4 17/25] target/arm: fail named CPU models on unknown
 non-zero feature ID regs
Thread-Topic: [RFC PATCH v4 17/25] target/arm: fail named CPU models on
 unknown non-zero feature ID regs
Thread-Index: AQHdScVs9zFpgk8q60C00ldSBfmtPLcAP9MAgAlZ2AA=
Date: Thu, 22 Oct 2026 11:15:23 +0000
Message-ID: <89B11270-7193-414B-9B01-F2D1E60E123F@nutanix.com>
References: <20260921123249.1708067-1-khushit.shah@nutanix.com>
 <20260921123249.1708067-18-khushit.shah@nutanix.com>
 <09800653-48cd-4cbb-a2ca-3d3cc65253f9@redhat.com>
In-Reply-To: <09800653-48cd-4cbb-a2ca-3d3cc65253f9@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nutanix.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA2PR02MB7564:EE_|SA3PR02MB11046:EE_
x-ms-office365-filtering-correlation-id: 3fb08579-0645-4dff-5c91-08df302dc488
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|23010399003|376014|1800799024|7416014|366016|261021130227099003|261021121427099003|56012099006|38070700021|261021135927099003|4143699003|261009223027099003|18002099003|10067099003|261021123027099003|6133799003|261021133027099003|22082099003;
x-microsoft-antispam-message-info:
 VSZ5Pc2cm1HM+48KyRniGL58OKCSTd3GVuFEqrPpQRvjUE8IiSHs5wM9Z2VplQb8fHXuBzAwgtV3x+TXv3IVZr143XreQP5X+COEYDqFlqStPssioFI34ysqacR8i9b4cx1+GyxeiZLAtp+DnWhj/nG2KHCjR4tBd5amzcEf+BIs2u9U98SdM5St2nKeWBaikwXahDq05D3/6B9T2qHK5KjjraqyJf+QDyATAhOnPX15XLJ1F235Plw2eQwdpd/Gz2q49DXPgOJu/tYc7NLH3xvkmwTuNvPv41KHu46l/aUGPNXXPQ/OGcfsfSRnYpC5EPImWG8ncnATGxT3eO2gpkCVF5iYiiAKdEUN+X3MXIzBIBbqRwxBvRa5g1HCgRKcIRobqfWb0gQbrAI9inLhlhQUnAL0vzSUeSoCn0BTs1hXgsM6wQwHx0MUPTl8TztC3yTAGCY1WiXDf19CmfSFANQyqvNzvoawUgzl8Fi6XkDQQZ8a4q5VZ0N7jYdsgxQk8jJFIYGV3++jpBAQM9b6VBnLc7LdpoOrKS790mn8Je7NcNzDEMncyhk7f8YZH0EIUIxBGQPsd+difoFPF4Ax5Mk3QRcLY+QnalHOcSy5cEpvMMofsSs+wFajtUzUbtiBRJIjoAf+5bmfEWaY6OhwrcEnVU5WsxPpzeyd7S97wEgDw8xX2XhOEW7jwAP/ndIhEXF4ioGyo+E5JZCjuVtKlcWRjuzyaD72IpU49e6eR0k=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(7416014)(366016)(261021130227099003)(261021121427099003)(56012099006)(38070700021)(261021135927099003)(4143699003)(261009223027099003)(18002099003)(10067099003)(261021123027099003)(6133799003)(261021133027099003)(22082099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?YnVXcElWdFA0aWYxdDJnT0xUMGVaSHpCVTZnU04vZ0k2dEFzZytOS3hjZWk4?=
 =?utf-8?B?RzNQaWVkU2hzRldDby9jNGN3M0JvQll3eHBYbll0Ty9IVitkMjZEdmt4ODc0?=
 =?utf-8?B?M3FZdU5MbUlwOHNiOEFpeStIRlM2M1hvRGVsNEo5UURqQ054RXljUnpYSExa?=
 =?utf-8?B?QkJpQnBBcW5vWkJSVTBNbkt1VVd5bWxzd1NBZFR0UjJvTGdlRXI3TUpIWGtP?=
 =?utf-8?B?WkNYV1VCOTFqOXpJWGNpZGQ4N2FuYloweG1ka2g3ZnM2MEdDOVVOTGNleHFu?=
 =?utf-8?B?blZVdjBhY2JaZXAxZWw5SFNwL3lST2JTMXA1clZnRktYdnJRRHNPK2tKeGVU?=
 =?utf-8?B?OTNPR0l6Ymx4YWc1WHNzQ1EwRG9RREdXaE1jRHl3ajN5L1Z6S2dNV0hLbWht?=
 =?utf-8?B?bkhyTFVUNEVaT1RnMkVERG13MFpTWDJYTjVCSThWZVBtc0JmMmQvNzZocVB1?=
 =?utf-8?B?UnZTQkNxZHpuaXo2WHFERFFMYUd2YkNBZU5EbzNpSldKTldjamhkZXlRRVhk?=
 =?utf-8?B?c2l5UmVQZ2Q5SDJXN0tCNVZUMzhrOFlMYmNTR3NrSkFudE1sc3JibW1nNStn?=
 =?utf-8?B?VzhhVkdGbG1nTWJ4aXlEdDIxR1VLZmgzd0NubGVyZmpxeStUZWdSek9hNC9O?=
 =?utf-8?B?YkVXS2phVzVrandnMlBoZG5xa1JsNnlDVTdYc0lXNjFlMXQxODYxc290U0pr?=
 =?utf-8?B?QjJSYmdhUlM4STlqSkJ3dHZzdVlYNUh6Kzg1cHlOd1ExL0pEMkRZd1Nla0hF?=
 =?utf-8?B?TFUwOUU5ckcyNFdjUTlRSXBVNHhmQWFaVzREUzllaEE0QlZ2NTVrS1c0RWJj?=
 =?utf-8?B?aXVycmVUNTJrY0ZmUDhZcW9Cd1BhU016b3BkQ2xBYkZLSEdDWmRxV055eGhi?=
 =?utf-8?B?TWFjZU1TdkQ5NjVDV3ZaYm9USUt2UHZyMHNhWlBod3JWdHlmOEhRRTR3NjF2?=
 =?utf-8?B?NDVpa2NzMVJFemMzNEtmcGlNYk50TW4wQ1NGNmdCaWluZkpvVWZvNjFzV2NX?=
 =?utf-8?B?Z1hFckJ2VGlMMFlkU1V5dmZwdzNFbHhWOFEyUnN1M3pNRVFxRDlUUmxUV2Ns?=
 =?utf-8?B?a2hOcE5YZURZM0dpUjNVZFVlejNJMU03N283T0JGRXF5M0dGTm0zZGdHSzF2?=
 =?utf-8?B?SWFuSVZ4dlNDVkZoUlV0TWpDeCtzZ2wreHZ1bU5adkdpc3Fnam5HVWp1YkFv?=
 =?utf-8?B?RlBpamNUQzhxYmZvRVV1Zk1IcUhGRDY4d01nWWprM3dlY0dMdHlrOTZBUGFw?=
 =?utf-8?B?S3B6OTJ1VDZKdDJ4MHJhL1hPRGFQZW5sLzNOcGxSMmlNaXhTYzB6c2VGdm9J?=
 =?utf-8?B?ZkxqemgxL2VhR0xpR3d4MjNtdUMzVm14RWxIQXROL3d6a1hzTFdSVnNzaldW?=
 =?utf-8?B?akhId0hPUERMVEw5QUFwTE51WWMrbkMzcVEvTHN5NGpUNGZrdWQwVk51cWhy?=
 =?utf-8?B?WG1ScEtGWFMxZXRBejNHN1J5WHdNblJUc29FQVUvN3N0V2xCU09rc1pvbEhX?=
 =?utf-8?B?M3NoN1FtMWxCYUU1YzNyS2xRMUlhdWd1Q3hKS3MwUXZHUmRWSUYzbGFTN1Ey?=
 =?utf-8?B?S2xEeVNxLzBYcHp2WE5ScUNEeG5GczhMZEdSQ2xwYUg4TDYrQkljby9RTjla?=
 =?utf-8?B?UU90STh0czhEenNOOXh6WmUwMnJ6bnlRTVZQbTViRlRWc1VTNEx5S2ZKTmh6?=
 =?utf-8?B?cWN4N1NpeGh4N0xPZHRUTGUySVl5dHdBbHc3SWQ1WnFuMHBmTytEcmlFOCtv?=
 =?utf-8?B?SnhqSnZDL2VTckJ5Sldldm9Nb1JKYmJUOG9oL1FteHpMdnRibDlUaENqdk4w?=
 =?utf-8?B?WkhUQ21xWU1lVVBlR21sV0l3VlJOaVdXRGJORE8vMzdSa0lLSG9FcGtoelRV?=
 =?utf-8?B?eXJSN0gzZkV6NUhEVUxaTGZWWE9PcThwMXBIWUk3MDJiZ3B2ZUFpcUt0M3hV?=
 =?utf-8?B?N3piRTJ4Vjd3Y3FzSVdUVFZhdDJiK0JvcHNRRFE3NGdiRUlyMDZSMUtra3FU?=
 =?utf-8?B?TzJ1ZzdzQktQUmpiRlBtV1dGM0FQY1psMWlsWDMwUUN3UjlsdHRqRkJaNSts?=
 =?utf-8?B?b2NtN0s3TnpWWi9SU3lUbUp1SWd5TWlLVHI1bzhWbzQ4M2VUOE1NK0dIbVQx?=
 =?utf-8?B?eFBOOURKeXVkcTkvSEpma0ViRmhtWUlRMkdsaTM0Y2FEUStWdVN4WmowQ2FY?=
 =?utf-8?B?bm0vQ1l1T0wxZHdKNkNaaC96LytoOXVxakYyMUpjNDJjRmNNYWszamd3em9o?=
 =?utf-8?B?a1VKdWQvTWZ1YWRyQ0VnQlVHZmVWNThDS2pWRW1sZVVCejkxa252OGRSL3pj?=
 =?utf-8?B?K3NkZ1pOYXZ4OXNCcUsvTWxrcWdyWkx5TXNiMVJOODNNcEtmYnNuT2dNUEl1?=
 =?utf-8?Q?yuo9Zn8sVGbL/taY=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1094FB2983F7594CBD8C3F0643740628@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	T5UWK7iJ01z19bNtLBC3I0IxZaRJ7cPc+yS+riZJaUHO85K/fMYeVscCHVskut/TY76Na9q5bMAwEPqAZ5a+oDnq7stGMqR3RHYI+dKMvUIRRzInOVljnkvNgjeiV9CB+maysTGv1gCY855k/kOaCErDoUaghp+cgYhuBmNcuxXt9CDIAAwoMW6y8Nh8KF2AjtY8W2C5l9z1BVZ3SwEsEbrJl3tI1rqKqDlOqVVMbvguotcFNxFElpWmObei+GrvUAsBQau1NSGpv0uSos324WqXLogC51vRDGxvZDemU8RGd7YDTEH4zTzSaFX0XrqXiTdHonKZihTU37fsVqWCWw==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3fb08579-0645-4dff-5c91-08df302dc488
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Oct 2026 11:15:23.8410
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jTQRoa3Kp4TfUXNYYXpMuE7OBDvWWIp1T1ruYmvQ+BxUz6H0aGJqVP1QC+pkomfNVDsIIB0cwYk5iPp5nnseZ8qdO1pTbRcA4P8maVWlFdk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR02MB11046
X-Authority-Analysis: v=2.4 cv=SpMFe/O0 c=1 sm=1 tr=0 ts=6ad9f04f cx=c_pps
 a=J/nSLBw9du72GTmP7dreuw==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VofLwUrZ8Iiv6rRUPXIb:22 a=VUi8bpU7OL1Oj2-RSIOF:22 a=20KFwNOVAAAA:8
 a=64Cc0HZtAAAA:8 a=xxmmEZG-5yuxRTVU430A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: dC8pIZPUlM09gRA2oWQlLbNbbfv4XzB7
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIyMDA0NCBTYWx0ZWRfX1udV7ok37mFi
 CH0//6gbcD3bEU69M4t7tJ/BL6yquyMmJSuJK2im1VU37ZGRsFLYa3/nuJqJGyRo1jXiSigBZT7
 BbejzzfuJP/IE8ymtOTJugPfvAqkes8=
X-Proofpoint-ORIG-GUID: dC8pIZPUlM09gRA2oWQlLbNbbfv4XzB7
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIyMDA0NCBTYWx0ZWRfX3h95tvos0+7O
 FD7aWynbWbxa4Zb0CTGuZuEJYiVDjoRoeSDm2fot4BvUHmf9WUCUt6MI9tGLZhRXRsI7+ceayKU
 9+HEVSHWHlM+FWcj67/QSHVRdVchXcwceBCeJ1bNJT5cRdHnRHq438MsitY/iv5W07gOG9nF3/U
 Ec5kaN9HGr6KeHtCwdkogIYvapAJEFECv+Lwt40MqF/9Vui4fY1s0XQOelxMl1JlimJ3B4oWolo
 jQzSCjLkC980w9ir4sSaH3AcYTva1q81nCUWsHSFa+JRZQta3pb9vyc+c/6EmLiuKAGL3frGPrk
 m3uyWcY7KEB/LEUOip+Z93OJrng9PyGeNcP5aij49JLwDp8Eudi3Sn0Voe0eTuX4KzyZHWoqb8u
 IXYDBZCHGC5yRLZxDhRVJPjNF2NyXDXD+43Z73aMmvNqx1+TYju7Q0oleRji4plaRVVgAybnJvZ
 e9fFbmeYSMxqqAnn5pw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-22_04,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gMTYgT2N0IDIwMjYsIGF0IDU6NTfigK9QTSwgRXJpYyBBdWdlciA8ZXJpYy5hdWdl
ckByZWRoYXQuY29tPiB3cm90ZToNCj4gDQo+ICEtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tfA0KPiAgQ0FVVElPTjogRXh0
ZXJuYWwgRW1haWwNCj4gDQo+IHwtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tIQ0KPiANCj4gSGkgS2h1c2hpdA0KPiBPbiA5
LzIxLzI2IDI6MzIgUE0sIEtodXNoaXQgU2hhaCB3cm90ZToNCj4+IE5hbWVkIENQVSBtb2RlbHMg
emVybyB0aGUgSUQgcmVnaXN0ZXJzIFFFTVUga25vd3MgYWJvdXQgYW5kIHRoZW4gYXBwbHkNCj4+
IFNZU1JFR18gcHJvcGVydGllcy4gSG93ZXZlciwgdGhlIGhvc3QgYW5kIEtWTSBtaWdodCBleHBv
c2UgSUQNCj4+IHJlZ2lzdGVycyB0aGF0IFFFTVUgZG9lcyBub3Qga25vdyBhYm91dCB5ZXQuIElu
IHRoaXMgc2NlbmFyaW8sIG5hbWVkDQo+IHRoaXMgbWF5IGFsc28gaGFwcGVuIHdpdGggcmVzZXJ2
ZWQgZmllbGRzIGJlY29taW5nIG5hbWVkLCBubz8NCkNvcnJlY3QsIFRoYW5rcywgSSB3aWxsIGFk
ZCBhIGNoZWNrIHRoYXQgYWxsIHRoZSBSRVN4IGZpZWxkcy4NCg0KPj4gQ1BVIG1vZGVscyBtaWdo
dA0KPiBcbg0KPj4gbGVhayBob3N0IGZlYXR1cmVzIHRvIHRoZSBndWVzdC4NCj4+IA0KPj4gUGFy
dCBvZiB0aGUgcHJvYmxlbSBjYW4gYmUgYWRkcmVzc2VkIGJlY2F1c2UgdGhlIEFybSBBcmNoaXRl
Y3R1cmUNCj4+IFJlZmVyZW5jZSBNYW51YWwgc3BlY2lmaWVzIHRoYXQgdW51c2VkIGVuY29kaW5n
cyBpbiB0aGUgc3BhY2UgKG9wMT09MCwNCj4+IENSbj09MCwgQ1JtPT17Mi03fSkgbWF5IGJlIHRy
ZWF0ZWQgYXMgUkVTMC4gVGhpcyByYW5nZSBpbmNsdWRlcyBhbGwNCj4+IElEX0FBNjQqIHJlZ2lz
dGVycy4NCj4gYWN0dWFsbHkgdGhlIEtWTSB3cml0YWJsZSBBUEkgY292ZXJzIEFBcmNoNjQgU3lz
dGVtIHJlZ2lzdGVyIHNwYWNlDQo+IA0KPiB3aXRoIG9wMD09Mywgb3AxPT17MCwgMSwgM30sIENS
bj09MCwgQ1JtPT17MC03fSwgb3AyPT17MC03fS4NCj4gc28gZG8geW91IG1lYW4geW91IG9ubHkg
Y2hlY2sgcGFydCBvZiB0aGUgc3BhY2UuIEluIHRoZSBwb3NpdGl2ZSBkb24ndCB3ZSBuZWVkIHRv
IGJlIG1vcmUgcHJlY2lzZSBhbmQgY2hlY2sgZm9yIGEgZ2l2ZW4gb3Bjb2RlIGlmIGl0IGlzIGtu
b3duDQpTb3JyeSwgSSBkbyBub3QgdW5kZXJzdGFuZC4gVGhpcyBpcyBleGFjdGx5IHdoYXQgdGhp
cyBjb21taXQgZG9lcy4NCg0KPiANCj4+IA0KPj4gRXJyb3Igb3V0IGlmIEtWTSByZXR1cm5zIGEg
bm9uLXplcm8gdmFsdWUgZm9yIGEgcmVnaXN0ZXIgaW4gdGhlIGFib3ZlDQo+PiBzcGFjZSB3aGlj
aCBRRU1VIGRvZXMgbm90IGtub3cgYWJvdXQgeWV0Lg0KPj4gDQo+PiBnZXRfc3lzcmVnX2lkeCgp
IG5vdyByZXR1cm5zIC0xIGZvciBlbmNvZGluZ3MgdGhhdCBhcmUgbm90IGtub3duIElEDQo+PiBy
ZWdpc3RlcnMsIGFuZCBrdm1fYXJtX3JlYWRfc3lzX3JlZzY0KCkgZXhwb3NlcyBhIEtWTSBHRVRf
T05FX1JFRw0KPj4gcmVhZCBmb3IgdGhpcyBwcm9iZS4NCj4+IA0KPj4gU2lnbmVkLW9mZi1ieTog
S2h1c2hpdCBTaGFoIDxraHVzaGl0LnNoYWhAbnV0YW5peC5jb20+DQo+PiAtLS0NCj4+IHRhcmdl
dC9hcm0vY3B1LW1vZGVscy5jICB8IDc0ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysNCj4+IHRhcmdldC9hcm0vY3B1LXN5c3JlZ3MuaCB8ICAyICstDQo+PiB0YXJnZXQv
YXJtL2NwdTY0LmMgICAgICAgfCAgMyArLQ0KPj4gdGFyZ2V0L2FybS9rdm0tc3R1Yi5jICAgIHwg
IDcgKysrKw0KPj4gdGFyZ2V0L2FybS9rdm0uYyAgICAgICAgIHwgIDcgKysrKw0KPj4gdGFyZ2V0
L2FybS9rdm1fYXJtLmggICAgIHwgMTIgKysrKysrKw0KPj4gNiBmaWxlcyBjaGFuZ2VkLCAxMDMg
aW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkNCj4+IA0KPj4gZGlmZiAtLWdpdCBhL3Rhcmdl
dC9hcm0vY3B1LW1vZGVscy5jIGIvdGFyZ2V0L2FybS9jcHUtbW9kZWxzLmMNCj4+IGluZGV4IDRl
OTI5MDk3NTUuLjg1NWViNWVlNmIgMTAwNjQ0DQo+PiAtLS0gYS90YXJnZXQvYXJtL2NwdS1tb2Rl
bHMuYw0KPj4gKysrIGIvdGFyZ2V0L2FybS9jcHUtbW9kZWxzLmMNCj4+IEBAIC0zNjIsNiArMzYy
LDc4IEBAIHN0YXRpYyB2b2lkIHJlc2V0X3JlczFfZmllbGRzKEFSTUNQVSAqY3B1KQ0KPj4gICAg
IH0NCj4+IH0NCj4+IA0KPj4gKy8qDQo+PiArICogRnJvbSBBUk0gQVJNOg0KPj4gKyAqDQo+PiAr
ICogICAgIEZvciB1bnVzZWQgZW5jb2RpbmdzIGluIHRoZSBwYXJ0IG9mIHRoZSBzcGFjZSB0aGF0
IGhhcyBvcDE9PTAgYW5kDQo+PiArICogICAgIENSbT09ezItN30sIGRpcmVjdCByZWFkcyB0aGF0
IGFyZSBub3QgdHJhcHBlZCBiZWhhdmUgYXMgUmVzZXJ2ZWQsDQo+PiArICogICAgIFJFUzAgdG8g
ZW5zdXJlIGNvcnJlY3QgYmVoYXZpb3IgaWYgdGhlIGVuY29kaW5ncyBhcmUgdXNlZCBmb3IgSUQN
Cj4+ICsgKiAgICAgcmVnaXN0ZXJzIGluIHRoZSBmdXR1cmUuDQo+PiArICoNCj4+ICsgKiBJdCBp
bmNsdWRlcyBldmVyeSBJRF9BQTY0KiByZWdpc3Rlci4NCj4+ICsgKg0KPj4gKyAqIEZvciBuYW1l
ZCBDUFUgbW9kZWxzLCB3ZSBjYW4gY2hlY2sgaWYgYW55IG9mIHRoZSB1bmtub3duIElEIHJlZ2lz
dGVycw0KPj4gKyAqIHRoYXQgZmFsbCBpbnRvIHRoaXMgc3BhY2UgaXMgbm9uLXplcm8gb24gdGhl
IGhvc3QuIElmIHNvLCB0aGUgbmFtZWQgQ1BVDQo+PiArICogbW9kZWwgbGVha3MgdGhvc2UgaG9z
dCBmZWF0dXJlcy4gRXJyb3Igb3V0IGluIHN1Y2ggY2FzZS4NCj4+ICsgKg0KPj4gKyAqIFdlIGNh
bm5vdCBkbyB0aGUgc2FtZSBmb3IgdGhlIHJlbWFpbmluZyBGZWF0dXJlIElEIHNwYWNlIChvcDE9
PTAgYW5kDQo+PiArICogQ1JtPT0wLCBvciBvcDE9PXsxLDN9KS4gVW51c2VkIGVuY29kaW5ncyB0
aGVyZSBhcmUgVU5ERUZJTkVELiBUaGUNCj4+ICsgKiBpbXBsZW1lbnRlZCByZWdpc3RlcnMgaW4g
dGhhdCBzcGFjZSAoTUlEUl9FTDEsIENUUl9FTDAsIERDWklEX0VMMCwNCj4+ICsgKiBDQ1NJRFJf
RUwxLCAuLi4pIGFyZSBpZGVudGlmaWNhdGlvbiBvciBjYWNoZSBnZW9tZXRyeS4NCj4+ICsgKi8N
Cj4+ICtzdGF0aWMgdm9pZCBhcm1fbmFtZWRfY3B1X3plcm9fdW5rbm93bl9mZWF0dXJlX2lkcyhB
Uk1DUFUgKmNwdSwgRXJyb3IgKiplcnJwKQ0KPj4gK3sNCj4+ICsgICAgdWludDMyX3QgaW5pdF9m
ZWF0dXJlczAgPSAwOw0KPj4gKyAgICBzdGF0aWMgYm9vbCBjaGVja2VkOw0KPj4gKyAgICB1aW50
MzJfdCB0YXJnZXQ7DQo+PiArICAgIGludCBmZGFycmF5WzNdOw0KPj4gKyAgICBpbnQgY3JtLCBv
cDI7DQo+PiArICAgIGludCBmZDsNCj4+ICsNCj4+ICsgICAgaWYgKGNoZWNrZWQpIHsNCj4+ICsg
ICAgICAgIHJldHVybjsNCj4+ICsgICAgfQ0KPj4gKw0KPj4gKyAgICBpZiAoIWt2bV9hcm1fY3Jl
YXRlX3NjcmF0Y2hfbWF4X2hvc3RfdmNwdShmZGFycmF5LCAmaW5pdF9mZWF0dXJlczAsDQo+PiAr
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICZ0YXJnZXQsIGVy
cnApKSB7DQo+IGNhbid0IHdlIGRvIHRoYXQgd2hlbiB3ZSByZXRyaWV2ZSB0aGUgaG9zdCBmZWF0
dXJlcyBvbiB0aGUgMXN0IGNyZWF0ZWQNCj4gc2NyYXRjaCB2Y3B1LiBXZSBzaGFsbCBhdm9pZCBj
cmVhdGluZyB0b28gbWFueSBvZiB0aGVtIGlmIHBvc3NpYmxlLg0KSSB3aWxsIHRyeSB0byBjaGVj
ayBpZiB0aGVyZSBpcyBhbiBlbGVnYW50IHdheSB0byBmb2xkIHRoaXMgaW50byBob3N0IHByb2Jl
Lg0KDQpBcyB3ZSBkb27igJl0IHdhbnQgdG8gc3RvcCAtY3B1IGhvc3QgZ3Vlc3QgaW4gdGhpcyBj
YXNlLg0KDQpUaGFua3MsDQpLaHVzaGl0DQo+PiArICAgICAgICByZXR1cm47DQo+PiArICAgIH0N
Cj4+ICsNCj4+ICsgICAgZmQgPSBmZGFycmF5WzJdOw0KPj4gKyAgICBmb3IgKGNybSA9IDI7IGNy
bSA8PSA3OyBjcm0rKykgew0KPj4gKyAgICAgICAgZm9yIChvcDIgPSAwOyBvcDIgPD0gNzsgb3Ay
KyspIHsNCj4+ICsgICAgICAgICAgICB1aW50NjRfdCB2YWwgPSAwOw0KPj4gKyAgICAgICAgICAg
IGludCByZXQ7DQo+PiArDQo+PiArICAgICAgICAgICAgaWYgKGdldF9zeXNyZWdfaWR4KEVOQ09E
RV9JRF9SRUcoMywgMCwgMCwgY3JtLCBvcDIpKSAhPSAtMSkgew0KPj4gKyAgICAgICAgICAgICAg
ICBjb250aW51ZTsNCj4+ICsgICAgICAgICAgICB9DQo+PiArDQo+PiArICAgICAgICAgICAgcmV0
ID0ga3ZtX2FybV9yZWFkX3N5c19yZWc2NChmZCwgJnZhbCwgMywgMCwgMCwgY3JtLCBvcDIpOw0K
Pj4gKyAgICAgICAgICAgIGlmIChyZXQpIHsNCj4+ICsgICAgICAgICAgICAgICAgY29udGludWU7
DQo+PiArICAgICAgICAgICAgfQ0KPj4gKw0KPj4gKyAgICAgICAgICAgIC8qDQo+PiArICAgICAg
ICAgICAgICogVE9ETzogaWYgdGhpcyBlbmNvZGluZyBpcyB3cml0YWJsZSwgdHJ5IHRvIHdyaXRl
IDA/DQo+PiArICAgICAgICAgICAgICovDQo+PiArICAgICAgICAgICAgaWYgKHZhbCkgew0KPj4g
KyAgICAgICAgICAgICAgICBlcnJvcl9zZXRnKGVycnAsDQo+PiArICAgICAgICAgICAgICAgICAg
ICAgICAgICAgInVua25vd24gRmVhdHVyZSBJRCByZWdpc3RlciAiDQo+PiArICAgICAgICAgICAg
ICAgICAgICAgICAgICAgIihvcDA9Mywgb3AxPTAsIENSbj0wLCBDUm09JWQsIG9wMj0lZCkgIg0K
Pj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICJyZWFkcyBhcyAweCUiIFBSSXg2NCAiIG9u
IHRoZSBob3N0OyBuYW1lZCBDUFUgIg0KPj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICJt
b2RlbHMgY2Fubm90IGhpZGUgaXQiLA0KPj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgIGNy
bSwgb3AyLCB2YWwpOw0KPj4gKyAgICAgICAgICAgICAgICBrdm1fYXJtX2Rlc3Ryb3lfc2NyYXRj
aF9ob3N0X3ZjcHUoZmRhcnJheSk7DQo+PiArICAgICAgICAgICAgICAgIHJldHVybjsNCj4+ICsg
ICAgICAgICAgICB9DQo+PiArICAgICAgICB9DQo+PiArICAgIH0NCj4+ICsNCj4+ICsgICAga3Zt
X2FybV9kZXN0cm95X3NjcmF0Y2hfaG9zdF92Y3B1KGZkYXJyYXkpOw0KPj4gKyAgICBjaGVja2Vk
ID0gdHJ1ZTsNCj4+ICt9DQo+PiArDQo+PiBzdGF0aWMgdm9pZCBhcm1fbmFtZWRfY3B1X2luaXRm
bihPYmplY3QgKm9iaikNCj4+IHsNCj4+ICAgICBBUk1DUFUgKmNwdSA9IEFSTV9DUFUob2JqKTsN
Cj4+IEBAIC00MDEsNiArNDczLDggQEAgc3RhdGljIHZvaWQgYXJtX25hbWVkX2NwdV9pbml0Zm4o
T2JqZWN0ICpvYmopDQo+PiANCj4+ICAgICAvKiAzLiBSZWFsaXplIHRoZSBtb2RlbCBjaGFpbi4g
Ki8NCj4+ICAgICBhcm1fcmVhbGl6ZV9tb2RlbF9jaGFpbihvYmosIG1vZGVsLCAmZXJyb3JfYWJv
cnQpOw0KPj4gKw0KPj4gKyAgICBhcm1fbmFtZWRfY3B1X3plcm9fdW5rbm93bl9mZWF0dXJlX2lk
cyhjcHUsICZlcnJvcl9hYm9ydCk7DQo+PiB9DQo+PiANCj4+IHZvaWQgYXJtX3JlZ2lzdGVyX25h
bWVkX2NwdV9tb2RlbHModm9pZCkNCj4+IGRpZmYgLS1naXQgYS90YXJnZXQvYXJtL2NwdS1zeXNy
ZWdzLmggYi90YXJnZXQvYXJtL2NwdS1zeXNyZWdzLmgNCj4+IGluZGV4IDc4NzdhM2IwNmEuLmQ0
OGI0NDcwNWYgMTAwNjQ0DQo+PiAtLS0gYS90YXJnZXQvYXJtL2NwdS1zeXNyZWdzLmgNCj4+ICsr
KyBiL3RhcmdldC9hcm0vY3B1LXN5c3JlZ3MuaA0KPj4gQEAgLTM3LDYgKzM3LDYgQEAgdHlwZWRl
ZiBlbnVtIEFSTVN5c1JlZ3Mgew0KPj4gDQo+PiBleHRlcm4gY29uc3QgdWludDMyX3QgaWRfcmVn
aXN0ZXJfc3lzcmVnW05VTV9JRF9JRFhdOw0KPj4gDQo+PiAtaW50IGdldF9zeXNyZWdfaWR4KEFS
TVN5c1JlZ3Mgc3lzcmVnKTsNCj4+ICtpbnQgZ2V0X3N5c3JlZ19pZHgoQVJNU3lzUmVncyBzeXNy
ZWcpOyAvKiAtMSBpZiBAc3lzcmVnIGlzIG5vdCBhIGtub3duIElEIHJlZ2lzdGVyICovDQo+PiAN
Cj4+ICNlbmRpZiAvKiBBUk1fQ1BVX1NZU1JFR1NfSCAqLw0KPj4gZGlmZiAtLWdpdCBhL3Rhcmdl
dC9hcm0vY3B1NjQuYyBiL3RhcmdldC9hcm0vY3B1NjQuYw0KPj4gaW5kZXggYTAxMTRiMGZhMi4u
M2NjNjk4ZDY1YSAxMDA2NDQNCj4+IC0tLSBhL3RhcmdldC9hcm0vY3B1NjQuYw0KPj4gKysrIGIv
dGFyZ2V0L2FybS9jcHU2NC5jDQo+PiBAQCAtNTcsOCArNTcsOSBAQCBpbnQgZ2V0X3N5c3JlZ19p
ZHgoQVJNU3lzUmVncyBzeXNyZWcpDQo+PiB7DQo+PiAgICAgc3dpdGNoIChzeXNyZWcpIHsNCj4+
ICNpbmNsdWRlICJjcHUtc3lzcmVncy5oLmluYyINCj4+ICsgICAgZGVmYXVsdDoNCj4+ICsgICAg
ICAgIHJldHVybiAtMTsNCj4+ICAgICB9DQo+PiAtICAgIGdfYXNzZXJ0X25vdF9yZWFjaGVkKCk7
DQo+PiB9DQo+PiANCj4+ICN1bmRlZiBERUYNCj4+IGRpZmYgLS1naXQgYS90YXJnZXQvYXJtL2t2
bS1zdHViLmMgYi90YXJnZXQvYXJtL2t2bS1zdHViLmMNCj4+IGluZGV4IGVhZTJlMWVjMmMuLmQy
NjNhZGM5MjEgMTAwNjQ0DQo+PiAtLS0gYS90YXJnZXQvYXJtL2t2bS1zdHViLmMNCj4+ICsrKyBi
L3RhcmdldC9hcm0va3ZtLXN0dWIuYw0KPj4gQEAgLTUwLDYgKzUwLDEzIEBAIHZvaWQga3ZtX2Fy
bV9zZXRfY3B1X2ZlYXR1cmVzX2Zyb21faG9zdChBUk1DUFUgKmNwdSkNCj4+ICAgICBnX2Fzc2Vy
dF9ub3RfcmVhY2hlZCgpOw0KPj4gfQ0KPj4gDQo+PiAraW50IGt2bV9hcm1fcmVhZF9zeXNfcmVn
NjQoaW50IGZkLCB1aW50NjRfdCAqdmFsLA0KPj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAg
IHVpbnQ4X3Qgb3AwLCB1aW50OF90IG9wMSwNCj4+ICsgICAgICAgICAgICAgICAgICAgICAgICAg
ICB1aW50OF90IGNybiwgdWludDhfdCBjcm0sIHVpbnQ4X3Qgb3AyKQ0KPj4gK3sNCj4+ICsgICAg
Z19hc3NlcnRfbm90X3JlYWNoZWQoKTsNCj4+ICt9DQo+PiArDQo+PiB2b2lkIGt2bV9hcm1fYWRk
X3ZjcHVfcHJvcGVydGllcyhBUk1DUFUgKmNwdSkNCj4+IHsNCj4+ICAgICBnX2Fzc2VydF9ub3Rf
cmVhY2hlZCgpOw0KPj4gZGlmZiAtLWdpdCBhL3RhcmdldC9hcm0va3ZtLmMgYi90YXJnZXQvYXJt
L2t2bS5jDQo+PiBpbmRleCA3MGQ5YTA3NTgwLi42ZjcwNGMwNTA5IDEwMDY0NA0KPj4gLS0tIGEv
dGFyZ2V0L2FybS9rdm0uYw0KPj4gKysrIGIvdGFyZ2V0L2FybS9rdm0uYw0KPj4gQEAgLTI2Myw2
ICsyNjMsMTMgQEAgc3RhdGljIGludCByZWFkX3N5c19yZWc2NChpbnQgZmQsIHVpbnQ2NF90ICpw
cmV0LCB1aW50NjRfdCBpZCkNCj4+ICAgICByZXR1cm4gaW9jdGwoZmQsIEtWTV9HRVRfT05FX1JF
RywgJmlkcmVnKTsNCj4+IH0NCj4+IA0KPj4gK2ludCBrdm1fYXJtX3JlYWRfc3lzX3JlZzY0KGlu
dCBmZCwgdWludDY0X3QgKnZhbCwNCj4+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICB1aW50
OF90IG9wMCwgdWludDhfdCBvcDEsDQo+PiArICAgICAgICAgICAgICAgICAgICAgICAgICAgdWlu
dDhfdCBjcm4sIHVpbnQ4X3QgY3JtLCB1aW50OF90IG9wMikNCj4+ICt7DQo+PiArICAgIHJldHVy
biByZWFkX3N5c19yZWc2NChmZCwgdmFsLCBBUk02NF9TWVNfUkVHKG9wMCwgb3AxLCBjcm4sIGNy
bSwgb3AyKSk7DQo+PiArfQ0KPj4gKw0KPj4gc3RhdGljIHVpbnQ2NF90IGlkcmVnc19zeXNyZWdf
dG9fa3ZtX3JlZyhBUk1TeXNSZWdzIHN5c3JlZykNCj4+IHsNCj4+ICAgICByZXR1cm4gQVJNNjRf
U1lTX1JFRygoc3lzcmVnICYgQ1BfUkVHX0FSTTY0X1NZU1JFR19PUDBfTUFTSykgPj4gQ1BfUkVH
X0FSTTY0X1NZU1JFR19PUDBfU0hJRlQsDQo+PiBkaWZmIC0tZ2l0IGEvdGFyZ2V0L2FybS9rdm1f
YXJtLmggYi90YXJnZXQvYXJtL2t2bV9hcm0uaA0KPj4gaW5kZXggOTk3MTIwOTY2Zi4uNGU1NjNm
YWI5NiAxMDA2NDQNCj4+IC0tLSBhL3RhcmdldC9hcm0va3ZtX2FybS5oDQo+PiArKysgYi90YXJn
ZXQvYXJtL2t2bV9hcm0uaA0KPj4gQEAgLTE1NCw2ICsxNTQsMTggQEAgYm9vbCBrdm1fYXJtX2Ny
ZWF0ZV9zY3JhdGNoX21heF9ob3N0X3ZjcHUoaW50ICpmZGFycmF5LA0KPj4gICovDQo+PiB2b2lk
IGt2bV9hcm1fc2V0X2NwdV9mZWF0dXJlc19mcm9tX2hvc3QoQVJNQ1BVICpjcHUpOw0KPj4gDQo+
PiArLyoqDQo+PiArICoga3ZtX2FybV9yZWFkX3N5c19yZWc2NDoNCj4+ICsgKiBAZmQ6IHZDUFUg
ZmQNCj4+ICsgKiBAdmFsOiBmaWxsZWQgd2l0aCB0aGUgcmVnaXN0ZXIgdmFsdWUgb24gc3VjY2Vz
cw0KPj4gKyAqIEBvcDAvQG9wMS9AY3JuL0Bjcm0vQG9wMjogU3lzdGVtIElEIHJlZ2lzdGVyIGVu
Y29kaW5nDQo+PiArICoNCj4+ICsgKiBSZXR1cm5zOiAwIG9uIHN1Y2Nlc3MsIC0xIG9uIGZhaWx1
cmUuDQo+PiArICovDQo+PiAraW50IGt2bV9hcm1fcmVhZF9zeXNfcmVnNjQoaW50IGZkLCB1aW50
NjRfdCAqdmFsLA0KPj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgIHVpbnQ4X3Qgb3AwLCB1
aW50OF90IG9wMSwNCj4+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICB1aW50OF90IGNybiwg
dWludDhfdCBjcm0sIHVpbnQ4X3Qgb3AyKTsNCj4+ICsNCj4+IC8qKg0KPj4gICoga3ZtX2FybV9h
ZGRfdmNwdV9wcm9wZXJ0aWVzOg0KPj4gICogQGNwdTogVGhlIENQVSBvYmplY3QgdG8gYWRkIHRo
ZSBwcm9wZXJ0aWVzIHRvDQo+IFRoYW5rcw0KPiANCj4gRXJpYw0KDQoNCg==
