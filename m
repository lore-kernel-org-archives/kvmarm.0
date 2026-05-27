Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2476437B016
	for <kvmarm@lists.linux.dev>; Wed, 27 May 2026 15:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779895706; cv=fail; b=rzdknHLUmrMONx7JcwOMWBx2+cFyPzFqxTKGCUMM7FpYx+UOJd3QtVfJ2WyIwY9930L7bpl4Fq0ZUeGgC72bgUVy3MDpBfXNJTQQPeX+v6Zi2eXFXMgeJZS4AQLlRXGL2g7thib9EattFfuzWCeKaN9kEweZqGVKTpJJ6HmuaxQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779895706; c=relaxed/simple;
	bh=KrRWWIMbh9n3Fsd+mEh/be984baZdZ77R5gvSe3ZTyI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=KPd7106nlJNTbZRUQ0PTJq9HekdDONtaXYpq/OEXSxqbuniW+HChYABdk1aRx8aNr9iVCaM1teVEo8GfeZ2xAR3PKGqmbKiWWHjNYhWAOC6aVb201EheUrkDF4WznO6Hs/8MBv6vkTIGp51isiImXkkEknjiml5/gkqGcvmphPA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=bDvF/yR+; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=kFhjRpT/; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="bDvF/yR+";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="kFhjRpT/"
Received: from pps.filterd (m0127844.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64RCrhUH2567277;
	Wed, 27 May 2026 08:28:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=K/TaOcSocds5dyFCH8KfBz6vn1adZTMGI0ZCRJoIA
	wo=; b=bDvF/yR+SGwg/N7X83kkLIMO43Ph7is9MJNekGlRYtTdLenBh0F5pQL4l
	2GYfMU0LK4GsmEB38PMHUFnFQAL2YxlQcab7mxxkXuPLUR5HuiW9b/HEi5CwT8BZ
	eL47p1m42SxYdirPlAywHDa3FrfV4FX4STpadkP2/6P8AM7inlIMc3VK7JGGAEjh
	FjUSpaKrdTEpbJHxrMOyHKf9rAOQ3byzKZfV8C2B4n4HiAuFIwuypGQ00OCbwTfX
	YUzn8Isxdg8inkYdKn2FkVrsqaR8amibx3hY/SoNxYq54/kOB0oRxdOPMaYKPAct
	g3MCLD4wZqMRsS5I6+3t+y/BdazvQ==
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11020119.outbound.protection.outlook.com [52.101.201.119])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4edg592nek-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 27 May 2026 08:28:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vXRJin8RWKmb2VcK51bcTpjpklVExVPjWRkt8vvJYwEtCvbKHWF2pedW0J0sjR3KYozZNkoizAsiDOSNAxiyOEG7cdm4J2rJriAB77XeqrdhY89C4SLOllAm8YLOaIHXI96qsSRudEKBZ+gR3fiFSJnTb8Q9kzkD6CwejGEHXlVVB87Jp/9Djbu22Re3YQUpPQPx7hwJazBY8sPKC7YTVbCtvT3Y8rUmQof1y4nNyMJzYa7r2n+BIBC68DTeO52h3MBDK04c2ygXMURApfJsj/2HO3zFf4x9iQkTzSaS+FRThLbLm0v5nQ5S8ln3aH/0Cmr4uWi7Ae5Wl932A57Cmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K/TaOcSocds5dyFCH8KfBz6vn1adZTMGI0ZCRJoIAwo=;
 b=EQcdJ4q3HdKEKcG2+3ZM9l9lwq0lP0hzwtfgqB4dIPto0w+YUQqSZQz71fhJHleNwBQCX970qy+KwdXokQISr7WiaqycwEOTtm8o8aoDgmm4c8t8KEAwPMlrvMDdTSpFNIu2HgaDGxgEWpT73U7tKozAlmpaanEvi8ANih508ZKRvERzwR3lnQ1pRFiHzIStXeo2BlZQCdzH805uX5/AIO39+pfTv5byNcdD+V2oQBPeZJ4khNf5fWEr4fOJS/cP/soe3GRSg504eujMiKj4hHNoMBiX9Mvdf0XPaUMfDG+5G4KwSmd08W8QCoGmzYy9bWZ5PmIXO7j9MnFqhVdUIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K/TaOcSocds5dyFCH8KfBz6vn1adZTMGI0ZCRJoIAwo=;
 b=kFhjRpT/LVKsbt4QfpfnlXGP7nULruryhQxOFBdkB/ZRS+YVvvUoaRt2v6ZSCi6qxPuPZy3SPFL61Raes5DPf3rdBOXHxNFb9XtEWDIIHw95pu1YhRrMGJpHEWxhFcfZAKlqc4CPMCgmXoxcrdiTiQKGdokNUxHST+EkS4un0lp+ShmoQYiN96RCNNQTebkT6OMaX5XJUswTcGBAYEsRaVDnmPC6o8ppBWkzMuEiRdECuf/eJc/8uWB8q/mVp++a/7wGTCDb6srSPoEhtkzMkXr2dAl+0km2ryDQXG6O8oujsAGYPZI48bP4Qejn7aeiinvdZd4YZ3OpnBbmNg0uxQ==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by BY5PR02MB6472.namprd02.prod.outlook.com (2603:10b6:a03:1d7::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.13; Wed, 27 May
 2026 15:28:06 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%6]) with mapi id 15.21.0071.011; Wed, 27 May 2026
 15:28:05 +0000
From: Khushit Shah <khushit.shah@nutanix.com>
To: Eric Auger <eric.auger@redhat.com>
CC: "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "qemu-arm@nongnu.org"
	<qemu-arm@nongnu.org>,
        "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
        "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
        Shaju Abraham
	<shaju.abraham@nutanix.com>,
        "yangjinqian1@huawei.com"
	<yangjinqian1@huawei.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "richard.henderson@linaro.org" <richard.henderson@linaro.org>,
        "sebott@redhat.com" <sebott@redhat.com>,
        "skolothumtho@nvidia.com"
	<skolothumtho@nvidia.com>,
        "philmd@linaro.org" <philmd@linaro.org>,
        "maz@kernel.org" <maz@kernel.org>,
        "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "armbru@redhat.com" <armbru@redhat.com>,
        "berrange@redhat.com"
	<berrange@redhat.com>,
        "abologna@redhat.com" <abologna@redhat.com>,
        "jdenemar@redhat.com" <jdenemar@redhat.com>
Subject: Re: [PATCH v5 12/18] arm/kvm: write back modified ID regs to KVM
Thread-Topic: [PATCH v5 12/18] arm/kvm: write back modified ID regs to KVM
Thread-Index: AQHc55O3Z83/o4B/sUidnhGgkCnOE7Yh/r8AgAAM4IA=
Date: Wed, 27 May 2026 15:28:05 +0000
Message-ID: <5B64C821-01F8-48E2-8F68-95000AC9DF4F@nutanix.com>
References: <20260519132905.145643-1-eric.auger@redhat.com>
 <20260519132905.145643-13-eric.auger@redhat.com>
 <A29EDF01-278F-4975-9659-44359311204D@nutanix.com>
In-Reply-To: <A29EDF01-278F-4975-9659-44359311204D@nutanix.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA2PR02MB7564:EE_|BY5PR02MB6472:EE_
x-ms-office365-filtering-correlation-id: e0f5714c-312d-4967-a8a9-08debc048caf
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|7416014|376014|366016|38070700021|18002099003|22082099003|6133799003|56012099006|4143699003;
x-microsoft-antispam-message-info:
 k1vDPK77WZLUdWt7Ar+UAUs8vQWi2BMUu8zEsAt4ZgbhU1wS2H54UbJImAzWjNmZLUgh0LlyxI+DazDntbCe+0dSJlK3fh4amDbjxZXKnJn1FCID5ZuKMSxSwlEQSYwZobZgIHJiwcbI9qZLgX6jWg5kupV7OLBLG58kRQWGJ/CH1+N5GGwa3vwtUTDa+ju5esObAar7G20WCbKfifpGVTlAv4CuoQN+73DLII+ZKHHgIfnogoivp+DH5WcskPNT/ADLJkW1DyoUqhPsNMfor3VtIggD55c5WQ1rVo0D5WppOHluFK8XvWfZ1xWuMPQQQ7eXdYS1lwAON+SuIMAaS/mku29mmmqwxH89dtrl1KFan9Cu6uXeYjn7HdNN6BMd1vZad3Atd4+e/a/ZS59q5GrudA5pF3TYeNDy+YRj9Fobu05JI5a3rm9O/Ty27fI/XSAI2QInC/VYkURCbf/JvJta6mLJrA0eDi5Uhd+3Qr5c1nVUP3OX9fItjz+PFlSeJHkaTXpJGKi3vSmN4YrMq1dVoy1dMQuUZoOXr1RMjeaRAnYqgErvmawi9JONS1fQhRtdU8oPM3Md5GmrvyAi1G+LOu1XzIYwdPFHTAQbyi7gD7SaPcmYvLd/wky/3hedbFp2lpw48CUgLEQEYiNhjz7XGpDWXqoIRCwwdycLdv3SmhJqpvXqgnRy1KEokl+HxWffqZZZVit0P7mKpL2TLxCh+hofUu/x+Z3APAyRnoRz71QKh0frs9KL+yZuN2ca
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(38070700021)(18002099003)(22082099003)(6133799003)(56012099006)(4143699003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?o1hIManSxQSjt+JYwiOwNv7q9S76og9/lWSYZPpG8xsZFQfs3Z6NTt8O/3uY?=
 =?us-ascii?Q?T/CoopBbZySiNB8R5+zyrv4yWqQfoFatIw/gJQWVDgrw6buUaMqk9XzWxwXd?=
 =?us-ascii?Q?5kfzTE8FZbiIx79Tw6fl+J/XBZ0lB8cKJJ7N+MfcjxZZUV/kZCB4gUi1FSR7?=
 =?us-ascii?Q?SAlbfU2RK10n0B39+VL7Y62aQFds3tNCOX6BJ1z0hHqZ66eQJHdxYYp3Ww2d?=
 =?us-ascii?Q?WT/e3r5Adg0q300pqmgLdd8UywpKQ+4DhSiNRNdeg4rJlPqS5XATbCNXFLGU?=
 =?us-ascii?Q?lKLW53N1dPsuyP6MHFzH/JIB4HdgYQDim641mZHYCQVYfoC+vSe5jKw/hofz?=
 =?us-ascii?Q?+dnx+CwqY01VVujEQY7JdnkqOytDFcaWlHNpu1StCSH7kdZs1UdErj3gcrYn?=
 =?us-ascii?Q?iztFwZUZcbzoMp7gYNRPaY8hX3gvTR1rgtCwPXo3amTdAURHoqaxLKHoOn67?=
 =?us-ascii?Q?EB4w7ZMgFNzqtYPKjFm1+x+2+lk9H+osr8ioJGsleJDytEQB413jrJ6suKaU?=
 =?us-ascii?Q?+3K4UbTpydk9SwAApthon2xb6OSHzlN6uBNHOC0scSEKqZCruZfF96Xy8AY1?=
 =?us-ascii?Q?FDuz3Uamin5uBw5Twt6c44JgvrYQTkVz7RM/TDvvEZkr3S7MfqDG2Qm3TkKF?=
 =?us-ascii?Q?Cz5dm44EFHDGfdbRYWS/E5fxqwWumPKGlg633Z+oOtOEwuy/tvLMb9RF/KEb?=
 =?us-ascii?Q?bPSuA8vGK4ATrvMF19krK66bWv8BH4awii4ktWMov27qcTSaM+fM2ljrb7ju?=
 =?us-ascii?Q?dHxbmYC+xCInRJ5H/EKIJfPhy5rSWKEI2J7Gbhty0KRCy4ehzbsbVgi8ucfa?=
 =?us-ascii?Q?MTWV1fkFIr3J2LqauxpmJeHZhXdOHJBGMmdT3zibvm3WZ0QmcDyZlUpTkENh?=
 =?us-ascii?Q?L6KFjrJf7WqeiAL/mfmvURSDZS7aiZ6lXmr574SULZXIz3Z8yymKUvznqMZ3?=
 =?us-ascii?Q?TAW9K5VJ7BjJj7YqWkhynVBHjwTl5AGOXK/5L+fhfVoPfIZKUGVNwYzpwBJl?=
 =?us-ascii?Q?szJk3f7vxopcViFCi+18RGFd4dJMLrt/rSqv2OD2equvhVgSuU/fCEyofKWg?=
 =?us-ascii?Q?8cbzdkpnGbBp0ubksYGothfYWhzCYnfN4XlJBbwixcCLUs4nJXLhgkwtSHY6?=
 =?us-ascii?Q?t2TZ1yCSggUMPkf+CdUe+8W3rifMIRJl5//3DsUDwO5E+sqdzMGL3WkL0IvF?=
 =?us-ascii?Q?8PleAkeZuHu0xt/plenAmU1Mh2qksWp1ThcQMXgLo6SSmY0UMInQbIz/4M6Q?=
 =?us-ascii?Q?5qYDXnSXzoBnDFp9G3kkqYrZdRwDUnXjprnmk3XppRVAc7LcIQK3NjCYmfQB?=
 =?us-ascii?Q?dV6kJwklkr80k4jYWO/40q/ivpvZxxlU4c6hYm3twPDlTFo0aXcGNCiMwnIV?=
 =?us-ascii?Q?x99W15wnb44nZVVPeECr9ZdPcVPKIgVtFjsOcMS5p0Wp0j8LPVYIBVIy0Jjq?=
 =?us-ascii?Q?KXFR3hzlvhbxVuA0YOKV4RY3Kc/DRWtyx6yPqDLamPrzUBe2IZYKSi0dolDe?=
 =?us-ascii?Q?eHQTpgnVUkW0PFaSgiIxUebSuf6vcC6xdq7HmOx8ZrpYRfYAj9p60pu5torD?=
 =?us-ascii?Q?G8gSAU3euCTWarrF2FmMo1Fqd9H6JW7qQDHK7ExF0II9oXuS5lHONphRLItM?=
 =?us-ascii?Q?tyV2uNhzmuF7xptURM1RtdKQQdOfioWOqM3rnfsOYdvAvdU4vgncEog6pZ0w?=
 =?us-ascii?Q?kyaTxm3P8CTiQtGDGum0U28nO86lSVgejCllPZnbpDBNwObwfPa0TcS8aWX2?=
 =?us-ascii?Q?g953SoMTrbszlnbUfz2YeQz6ylDV5ss=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E2795337ABF6514BB99A1662154CCA1C@namprd02.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	GJmebHSPLj3GZFcIJxYw73/gdgebr7AxJJeIcVIm4HN4CTY0fKA0DbVGVUaXyhWbSfMCdBvsRKzLO6mzEL7hhFoyfsxoCKqb9rzjGVJKe5ms3J4z0+yoMC27qh0kGgN8PPsH5+PKDUlg5q8KtHSnUi4TyZcyEzzetnJ68yYLKc/haJI7vTubMZGh+c9nRF1Y0xkw2q/mVvMW1RQlS2/3yzOYKHBS9SLRkJwYiiLKfL2tj0GT5OkJG+h8w5aXrYhW/RjieFkb2HOQEAZCcuuHA1JQ8fs+mbYrMuwqg+kn9wnXQIM7x7WlYp542kJvIASm6msyNNfLBGWnsAM6BrpA+w==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0f5714c-312d-4967-a8a9-08debc048caf
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 May 2026 15:28:05.9104
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EIF7b54lUyNwiiySwUCqox5BlLtyOITr0hVOkh74jYCmSw6bDWXE4E7Kg9K7HRhNp1lcCT2RK+mxtBaY7rFGHOGh7RA3Y61NqE/Mw5ObsvI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR02MB6472
X-Proofpoint-ORIG-GUID: q3DGSsxwktrueePF8DiJYJIgXOivnjnI
X-Proofpoint-GUID: q3DGSsxwktrueePF8DiJYJIgXOivnjnI
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTI3MDE1NCBTYWx0ZWRfX/yRgfs1R+whA
 GwqLaZ14VpYWu7FYH4akhi3dJ6PA36QnkO6sL0Okw8UEEtiFLWIK8Vrz9iipOEL114hjQN8aKcK
 7w7sSX0k3FkVv6q1PQPtcWzaVO6k+MDDfy/70i06aST+pIaGoDHDyCv9JyX5Tr2oLQ0ZfuoZVyR
 yfhpGST7qAeTTHSde0zrRSbyjYPIQHX/stHA+QlwZFLnNS1Yjnbd65J4LmpbfqXSRGaLx3vS7OH
 AMzPAin9b+MqxPS4BecirAopwo7IBlsVLByrVmV5tizWHBJYIS2nVYd7Fg3pOIJldSSVaxdf/mx
 bnHdnVcks1TQI6UQFZw3EQ161D5inhbx/4v4VGQCbPsuyOjSaKAZMiPctuVqLGZ7l/l1rI483cQ
 LtB2206kmHeh441/Vh+lK/ay/Jk04u3pYBgW9zo/GHO4+BsSdtSbv0RXZtLZRcGDOxsEpfN1WEG
 xyM2388TZ/s3uilpsmg==
X-Authority-Analysis: v=2.4 cv=aNnAb79m c=1 sm=1 tr=0 ts=6a170d88 cx=c_pps
 a=j7k210cWVAfXhyiYu0S74w==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=NGcC8JguVDcA:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VofLwUrZ8Iiv6rRUPXIb:22 a=0LlEyIVc8U2lsR7dKhuH:22 a=64Cc0HZtAAAA:8
 a=9g9Rteg0ShzoPARwiFAA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-05-27_02,2026-05-26_03,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

From 92b813355251d61ab7941a8df500ab35c0a34193 Mon Sep 17 00:00:00 2001
From: Khushit Shah <khushit.shah@nutanix.com>
Date: Mon, 25 May 2026 17:51:54 +0530
Subject: [PATCH] target/arm/kvm: cache host ID register views with and
 without EL2

kvm_arm_get_host_cpu_features() probes the host by spinning up a
scratch vCPU and reading its ID registers. When the host kernel
advertises nested virtualization, the scratch was always created with
KVM_ARM_VCPU_HAS_EL2, which makes the kernel run limit_nv_id_reg() on
that vCPU and force several ID register fields (e.g.
ID_AA64MMFR4_EL1.NV_frac, parts of ID_AA64DFR0_EL1, etc.) to values
that match KVM's nested-virt emulation rather than the raw host
capability.

Split the cache into two slots indexed by with_el2 (lazily populated)
and plumb the selector through kvm_arm_set_cpu_features_from_host()
and kvm_arm_get_host_isar(). Callers pick the view that matches their
intent.

Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
---
Patch 1, part of RFC v2 for named models for arm.
will not cleanly apply but for the gist of the solution.
---
 target/arm/arm-cpu-models.c |  5 +++--
 target/arm/arm-qmp-cmds.c   |  4 ++--
 target/arm/cpu64.c          |  2 +-
 target/arm/kvm-stub.c       |  7 ++++++-
 target/arm/kvm.c            | 37 +++++++++++++++++++++----------------
 target/arm/kvm_arm.h        |  5 +++--
 6 files changed, 36 insertions(+), 24 deletions(-)

diff --git a/target/arm/arm-cpu-models.c b/target/arm/arm-cpu-models.c
index 9265bb776a..31765be55b 100644
--- a/target/arm/arm-cpu-models.c
+++ b/target/arm/arm-cpu-models.c
@@ -549,7 +549,8 @@ static void arm_named_cpu_initfn(Object *obj)
         return;
     }
=20
-    kvm_arm_set_cpu_features_from_host(cpu);
+    /* For now let's not support nested virt for named models */
+    kvm_arm_set_cpu_features_from_host(cpu, false);
     if (!arm_feature(&cpu->env, ARM_FEATURE_AARCH64)) {
         return;
     }
@@ -592,7 +593,7 @@ void arm_cpu_class_check_missing_features(ARMCPUClass *=
acc, strList **blockers)
         }
     }
=20
-    arm_idregs_get_blockers(cpu, kvm_arm_get_host_isar(), blockers);
+    arm_idregs_get_blockers(cpu, kvm_arm_get_host_isar(false), blockers);
 out:
     object_unref(obj);
 }
diff --git a/target/arm/arm-qmp-cmds.c b/target/arm/arm-qmp-cmds.c
index 84341a2105..453442ab93 100644
--- a/target/arm/arm-qmp-cmds.c
+++ b/target/arm/arm-qmp-cmds.c
@@ -82,7 +82,7 @@ CpuPropSupportedValues *qmp_query_cpu_props_supported_val=
ues(Error **errp)
         QList *sv =3D qlist_new();
=20
         arm_prop_append_supported_values(pdesc,
-                                         kvm_arm_get_host_isar(), sv);
+                                         kvm_arm_get_host_isar(false), sv)=
;
         qdict_put_obj(props, pdesc->name, QOBJECT(sv));
     }
=20
@@ -119,7 +119,7 @@ CpuPropInfoList *qmp_query_arm_cpu_named_model_prop_inf=
o(Error **errp)
=20
         sv =3D qlist_new();
         arm_prop_append_supported_values(pdesc,
-                                         kvm_arm_get_host_isar(), sv);
+                                         kvm_arm_get_host_isar(false), sv)=
;
=20
         prop_info->supported_values =3D QOBJECT(sv);
         prop_info->composite =3D NULL;
diff --git a/target/arm/cpu64.c b/target/arm/cpu64.c
index 109cead3c8..16b4d87dc1 100644
--- a/target/arm/cpu64.c
+++ b/target/arm/cpu64.c
@@ -875,7 +875,7 @@ static void aarch64_host_initfn(Object *obj)
=20
 #if defined(CONFIG_KVM)
     kvm_arm_set_cpreg_mig_tolerances(cpu);
-    kvm_arm_set_cpu_features_from_host(cpu);
+    kvm_arm_set_cpu_features_from_host(cpu, true);
     aarch64_add_sve_properties(obj);
     arm_add_cpu_props(obj);
 #elif defined(CONFIG_HVF)
diff --git a/target/arm/kvm-stub.c b/target/arm/kvm-stub.c
index 88cbe8d85c..98f41818ba 100644
--- a/target/arm/kvm-stub.c
+++ b/target/arm/kvm-stub.c
@@ -45,7 +45,7 @@ bool kvm_arm_el2_supported(void)
 /*
  * These functions should never actually be called without KVM support.
  */
-void kvm_arm_set_cpu_features_from_host(ARMCPU *cpu)
+void kvm_arm_set_cpu_features_from_host(ARMCPU *cpu, bool with_el2)
 {
     g_assert_not_reached();
 }
@@ -119,3 +119,8 @@ char *kvm_print_register_name(uint64_t regidx)
 {
     g_assert_not_reached();
 }
+
+const ARMISARegisters *kvm_arm_get_host_isar(bool with_el2)
+{
+    return NULL;
+}
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index 9f8368712f..c26ed485a3 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -65,7 +65,7 @@ typedef struct ARMHostCPUFeatures {
     const char *dtb_compatible;
 } ARMHostCPUFeatures;
=20
-static ARMHostCPUFeatures arm_host_cpu_features;
+static ARMHostCPUFeatures arm_host_cpu_features[2];
=20
 #define DEF(NAME, OP0, OP1, CRN, CRM, OP2) [NAME##_IDX] =3D #NAME,
 const char * const sysreg_names[NUM_ID_IDX] =3D {
@@ -349,7 +349,7 @@ static uint32_t kvm_arm_sve_get_vls(int fd)
     return vls[0] & MAKE_64BIT_MASK(0, ARM_MAX_VQ);
 }
=20
-static void kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
+static void kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf, bool w=
ith_el2)
 {
     /* Identify the feature bits corresponding to the host CPU, and
      * fill out the ARMHostCPUClass fields accordingly. To do this
@@ -389,7 +389,7 @@ static void kvm_arm_get_host_cpu_features(ARMHostCPUFea=
tures *ahcf)
      * Ask for EL2 if supported.
      */
     el2_supported =3D kvm_arm_el2_supported();
-    if (el2_supported) {
+    if (el2_supported && with_el2) {
         init.features[0] |=3D 1 << KVM_ARM_VCPU_HAS_EL2;
     }
=20
@@ -528,7 +528,7 @@ static void kvm_arm_get_host_cpu_features(ARMHostCPUFea=
tures *ahcf)
             err |=3D get_host_cpu_reg(fd, ahcf, ID_AA64ZFR0_EL1_IDX);
=20
             /* Read the set of supported vector lengths. */
-            arm_host_cpu_features.sve_vq_supported =3D kvm_arm_sve_get_vls=
(fd);
+            ahcf->sve_vq_supported =3D kvm_arm_sve_get_vls(fd);
         }
     }
     /*
@@ -586,15 +586,15 @@ static void kvm_arm_get_host_cpu_features(ARMHostCPUF=
eatures *ahcf)
     ahcf->features =3D features;
 }
=20
-void kvm_arm_set_cpu_features_from_host(ARMCPU *cpu)
+void kvm_arm_set_cpu_features_from_host(ARMCPU *cpu, bool with_el2)
 {
     CPUARMState *env =3D &cpu->env;
=20
-    if (!arm_host_cpu_features.dtb_compatible) {
-        kvm_arm_get_host_cpu_features(&arm_host_cpu_features);
+    if (!arm_host_cpu_features[with_el2].dtb_compatible) {
+        kvm_arm_get_host_cpu_features(&arm_host_cpu_features[with_el2], wi=
th_el2);
     }
=20
-    cpu->kvm_target =3D arm_host_cpu_features.target;
+    cpu->kvm_target =3D arm_host_cpu_features[with_el2].target;
=20
     if (cpu->kvm_target =3D=3D QEMU_KVM_ARM_TARGET_NONE) {
         /*
@@ -605,15 +605,18 @@ void kvm_arm_set_cpu_features_from_host(ARMCPU *cpu)
         return;
     }
=20
-    cpu->dtb_compatible =3D arm_host_cpu_features.dtb_compatible;
-    cpu->isar =3D arm_host_cpu_features.isar;
-    cpu->sve_vq.supported =3D arm_host_cpu_features.sve_vq_supported;
-    env->features =3D arm_host_cpu_features.features;
+    cpu->dtb_compatible =3D arm_host_cpu_features[with_el2].dtb_compatible=
;
+    cpu->isar =3D arm_host_cpu_features[with_el2].isar;
+    cpu->sve_vq.supported =3D arm_host_cpu_features[with_el2].sve_vq_suppo=
rted;
+    env->features =3D arm_host_cpu_features[with_el2].features;
 }
=20
-const ARMISARegisters *kvm_arm_get_host_isar(void)
+const ARMISARegisters *kvm_arm_get_host_isar(bool with_el2)
 {
-    return &arm_host_cpu_features.isar;
+    if (!arm_host_cpu_features[with_el2].dtb_compatible) {
+        kvm_arm_get_host_cpu_features(&arm_host_cpu_features[with_el2], wi=
th_el2);
+    }
+    return &arm_host_cpu_features[with_el2].isar;
 }
=20
 static bool kvm_no_adjvtime_get(Object *obj, Error **errp)
@@ -2331,9 +2334,11 @@ int kvm_arch_init_vcpu(CPUState *cs)
                 "  host=3D0x%016" PRIx64 "\n",
                 _i, sysreg_names[_i] ? sysreg_names[_i] : "(null)",
                 cpu->isar.idregs[_i],
-                arm_host_cpu_features.isar.idregs[_i]);
+                arm_host_cpu_features[cpu->has_el2].isar.idregs[_i]);
     }
-    if (!arm_idregs_validate_safe_rule(cpu, &arm_host_cpu_features.isar, &=
err)) {
+
+    /* validate the cpu->isar.idregs[] against the ahcf->isar.idregs[], se=
lect ahcf based on the cpu->has_el2 */
+    if (!arm_idregs_validate_safe_rule(cpu, &arm_host_cpu_features[cpu->ha=
s_el2].isar, &err)) {
         error_report_err(err);
         return -EINVAL;
     }
diff --git a/target/arm/kvm_arm.h b/target/arm/kvm_arm.h
index 750dbe1ef4..538f87e69e 100644
--- a/target/arm/kvm_arm.h
+++ b/target/arm/kvm_arm.h
@@ -129,11 +129,12 @@ void kvm_arm_destroy_scratch_host_vcpu(int *fdarray);
 /**
  * kvm_arm_set_cpu_features_from_host:
  * @cpu: ARMCPU to set the features for
+ * @with_el2: probe the host with the EL2-enabled scratch vCPU view
  *
  * Set up the ARMCPU struct fields up to match the information probed
  * from the host CPU.
  */
-void kvm_arm_set_cpu_features_from_host(ARMCPU *cpu);
+void kvm_arm_set_cpu_features_from_host(ARMCPU *cpu, bool with_el2);
=20
 /**
  * kvm_arm_add_vcpu_properties:
@@ -231,7 +232,7 @@ void kvm_arm_enable_mte(Object *cpuobj, Error **errp);
=20
 void arm_cpu_kvm_set_irq(void *arm_cpu, int irq, int level);
=20
-const ARMISARegisters *kvm_arm_get_host_isar(void);
+const ARMISARegisters *kvm_arm_get_host_isar(bool with_el2);
=20
 void arm_gic_cap_kvm_probe(GICCapability *v2, GICCapability *v3);
=20
--=20
2.52.0

