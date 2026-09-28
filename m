Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B2A54CA28B
	for <kvmarm@lists.linux.dev>; Mon, 28 Sep 2026 13:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790602506; cv=fail; b=ZdadLCj3FHLmRXa3j+6h2EkxwN0oX5GBXoZuAI7z/39D88Og3FrAMNwJuhx/ZZlvVjXkLuGD/5Zjjlx/K5hMZG4zNKBvn3/hfvbdgVAQ2jdRKqL6WvFpP7XfnRsb5WL2Xp2HO3Z/WsEtC221dxbGSKAQuI2nArxrFQ5dQw9b4SE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790602506; c=relaxed/simple;
	bh=BFlVm5iJ/VG9KW6l+nigzupsJPDiaTTdGGwu214A7A0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=BUP4OsIrFPAokia3Bk3UQLld0vGiY8TnHTD3Noy4lnwWqj5p2WEZx+JVnLYnJlrONfsVWpGHvORC5rbfWpgzcJOAXLdNUvATNNYRVQ8mvBFfpCbv/3I/5ICZI8P/VEy1nQQ19IMptYhHOE6SNB42BsAwu7/UQ8WxZJwmNLYusqk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=0KM5hNBw; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=hfIWkUCC; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="0KM5hNBw";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="hfIWkUCC"
Received: from pps.filterd (m0127842.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68SBB2L23988060;
	Mon, 28 Sep 2026 06:34:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=BFlVm5iJ/VG9KW6l+nigzupsJPDiaTTdGGwu214A7
	A0=; b=0KM5hNBwvCTv4ITrRpruipgNOrz+zlYAPs9IG7/15jkToYu2D1UO7bxER
	ctpewTxLuggu1HEYEmndgW247P8QCsadg9pM/vc3nKpLJ4ljPPzFosNVtJ3g6sNv
	9OMQNfP9HrsMXfxdx+FMbnpc1vQJuMpO6APNVQtVn8YorDEmxJemLSiZqc4xeA64
	v4MGiBSKJVSdmfnT06FVkE0te5QtTULbU61HsoIXKnbWsI2uGrrKRpcm2RW7L+ax
	1rZ8VsB6t5Gaq3sGNZWDr2onOaTY9nq9+0rKN92QXXKKjYSo/UWB0aUeTbyVxuVm
	kzxLJ58bYS09ox96XWQVKN8LO2QZQ==
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11023121.outbound.protection.outlook.com [40.93.196.121])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4gxdccbcys-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 28 Sep 2026 06:34:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=p9ZmoOeZ5xOB1v7nepypEfqWJkm2uMe3+O+XkqSM4XW53q8qwbzokl6xysT54jycZvM0+wx/E8hzGnFKOrMes5y1tw+5nl2P/xXXKdS/5NGQNqck33iaFrB/9Nt3LTbNKXBgJyOFOgEUGhR52hlvqFkbp8RVdn5bXCRcW5TU2ZaifZVqAte7ejDW6b+NJTk+pnq+ep17gMD9Vq3I0runfODvohMEc931G+PmHVeIy2kTLSs4ZkgPihNYma9YSkVv0m1TMw8dK7bAnkxdg0bl/Fb3hTR9gL3gJkOy5nSge/Vbr7zrrHQypuiN7EMrrMGrz2oZA3r3vd1hR0A/qQCGlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BFlVm5iJ/VG9KW6l+nigzupsJPDiaTTdGGwu214A7A0=;
 b=pOnf3lGBEBmlp9ZPzY59w1+EUVG03JKnm2mPHBg7YlB7JJvZD4r8liOYRQHB5z7Halc6X6CfKYtcyPLX+VW7GOuVZQe8JFYvj/6+MMsGIzYpH5fsZhCwfmg3ltJGGS4myEDFlNT+C/rFeKl4bTpbScrq0EtZiDxAY81/KfZsegOn2clgu2juPw1w4tEipwl69N9pUYOFKh8XEGJEPlKA5zNk9MHuPNAE2QhWaLz0sDqxj7F7zswqrsQwRbdtTkSY2VNWZLyWlieTvgGlqLBVgZvzN0p3+n34SPEtpNXrPFt1pmCJTn+zq+UZW9sOC/J7AkAWlQzMtcUt0DbY7mWt/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BFlVm5iJ/VG9KW6l+nigzupsJPDiaTTdGGwu214A7A0=;
 b=hfIWkUCC78+xa1GcFXnOa4nsoPFQkiQG0kumViuvlPluabHeqyXmpipWCgjCxKgyBOD9mSO0dpqwONjQJYDSoxhewlwldqsUCuRtvfZm9dGFwC0yZD1Dw3RprLA+fM/a67hFiFotINC0BQfrhHy82jKjutFDagqO3BVzYHZxUZ4UW8gBlbYWjwvNwwG8n5SCgEInVi6/ues46uEAfD50CgPPePBD3OoG9ccuAFSB4p/40g/wBxazBt71zICamaDY6vUqX0O7+coNXIt079/qtJaFmQRzrp525R40SLGXbMfq92xPnTLnMrxihvehjWJi+wJEH1faWsiEZ4HmKc4jQw==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by BL3PR02MB8114.namprd02.prod.outlook.com (2603:10b6:208:35d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.24; Mon, 28 Sep
 2026 13:34:47 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%5]) with mapi id 15.21.0451.022; Mon, 28 Sep 2026
 13:34:47 +0000
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
        "philmd@oss.qualcomm.com"
	<philmd@oss.qualcomm.com>,
        "maz@kernel.org" <maz@kernel.org>,
        "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
        "pbonzini@redhat.com"
	<pbonzini@redhat.com>,
        "armbru@redhat.com" <armbru@redhat.com>,
        "berrange@redhat.com" <berrange@redhat.com>,
        "abologna@redhat.com"
	<abologna@redhat.com>,
        "jdenemar@redhat.com" <jdenemar@redhat.com>
Subject: Re: [PATCH v9 21/26] target/arm/kvm: add helper to test SYSREG props
 against a scratch vcpu
Thread-Topic: [PATCH v9 21/26] target/arm/kvm: add helper to test SYSREG props
 against a scratch vcpu
Thread-Index: AQHdT04hnQAY0MElHUCRx5yUzZGEGg==
Date: Mon, 28 Sep 2026 13:34:47 +0000
Message-ID: <E471D5C1-D254-4DC9-BD22-E02660DE144F@nutanix.com>
References: <20260916144721.751810-1-eric.auger@redhat.com>
 <20260916144721.751810-22-eric.auger@redhat.com>
In-Reply-To: <20260916144721.751810-22-eric.auger@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nutanix.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA2PR02MB7564:EE_|BL3PR02MB8114:EE_
x-ms-office365-filtering-correlation-id: 9e9bc701-1f77-42c7-97b0-08df1d65438d
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|23010399003|7416014|376014|1800799024|38070700021|4143699003|56012099006|10067099003|18002099003|22082099003|6133799003;
x-microsoft-antispam-message-info:
 GElmXGprhWnqpoW1G4XnrIsuNICayNgXkvTHU7O8nsTFwOoEsGyjbu2UC2Q3MmX++KNYS7FW58sX9PANRNU0Ka4lUPbcBvW4nwK6fkvomHdW0aovBZ6/sqMeq9WIju2VI10ZYHU1vfRPz96CCqKmpjxuIMNF9tcLDD1hoKoDgknkLaGVz18/3YvrmOn7h9DZVQl7AF/e1lUyc9DURniF2we1a300JuuVQh1ouMda1kUGJK0qDhyx6gukuLGPEcmoYlqYRToMV3Fx8lmFJCqQtz6QkNXmo2p93RKcSDWg+a3zI7V7guyMNMXVevmEdTTMrtpRsH1E4ynosXtC9R0ZOfI6g5beMaGPmqjFKYLdHNjIrDLO82S5T3yLcSrKjK9XLgpwd9otfRwvQYfllXyvJKndHtJzWn6z3VvwzuYxaUUrjDehJqNQHBJPbd0PAdvgzCJj7WwTt0mVcLAQJHa8qzGqwNnj+l8IrOrcJn3ZLwP+VT/zKjdal5vwSR22hcG6oG0RlGNDBqwZN9oVtycDIi4OdMe1LJJVB2uqza0rKwL4oHVd5bKNGa3PEM+EgfKFwAcDMb9EA4hJnS5CjBcwU/nIMuJsVM/6WeJc0vMDvYicHz4B1doRGY/ZAToPshuUr5K6oVrlPvMyJ8ntJEh5REje9+0rMzjnCxi/cb0GEjETBlawPSqb6S2YLYJ26R1nymYASkNInviqQmdX2+0DTXl33T/wLSliJcJMeompq1k=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(7416014)(376014)(1800799024)(38070700021)(4143699003)(56012099006)(10067099003)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?S2NHSGViS2UvbGViYUQvK1JpWkxPZXRXTDhJZkJLSWdqbkV1V0RNYXJVdWJ4?=
 =?utf-8?B?OHpwL3gwYkJ2b1E2OXdETll3U0VUYjUrRk5VOTlqZHdGbVl1aFc1RE5zejVY?=
 =?utf-8?B?WURyd0ZIVjNtemc2ZndscnJ6S0k2djJQdzVoWmlsdjh5K1M3QzQ2VVJaZE5m?=
 =?utf-8?B?S2VLR2RNY1BaSmFFU0JlQXVjK2l5QktEVmRUaWZJcmp6Q3VqaEhuS2ZQZUoz?=
 =?utf-8?B?TEhGNTc1N0hFVk1QVTVEMVRUVzhwT2ZEdXE5TnZyWTIvVFNBNWZmUml5djlo?=
 =?utf-8?B?VHhDOTZ1SmNKS1RaVytNMWNqTU1EWGY1ZHBsVm5Kclp2NkMxK0szVzQyaTNG?=
 =?utf-8?B?bGxhL0Y5U1hNUEJRR0I4UTdFRldPNS9RSUg2MmJBblRkRXluVUhiVFd3dGtU?=
 =?utf-8?B?OHJXNmRnamN6ZFh2Z3cxNDlGdGFCbmpmcGVWU1E3aDhxc2ptRyszNXZWeWtq?=
 =?utf-8?B?YlNScHFGSmx6Wmx1cHo1L0QrRGtOMk43R0I5SXhCU0crTFg2UkZLejNYckd5?=
 =?utf-8?B?UU8wVkh0UkllbkZlRDVIVEsvK2MyVmRRTS83UW1jUEo0MkhDN2NjUW96djUr?=
 =?utf-8?B?bTRodDQydE5hcjZKcUVoalJ0cEk1N1U2RGVwYUhiKytrQUx2ZnlsV0Q3RzhQ?=
 =?utf-8?B?S1BQUlZEd0tITnNtK0lhaHlrckJiaXcxYmRZVmprQmFjb0d2RlNuNVpEYjI4?=
 =?utf-8?B?QTdDYmxKTG9Ga0RDbkR5OTc5RVhVazE2Tnk0T081b211OGx1dkZOM3paWFF0?=
 =?utf-8?B?RS9vU3FUcEpuY1h3S1FCVnhIRncyMGdrUVEzYzdqNm5KTmVTMjBNRzJWWk9L?=
 =?utf-8?B?R3NqUklZVUZrLzlDTTkrWHlpTFJheE1xeXZHT1d6UUF6VU1FZWpCQkZIRElx?=
 =?utf-8?B?d1M3L1I4cXRoUHA4R2Z4aXFGWjNUQWpPSy85bTAyUFJuWEYyRmI1ZGFBbk9p?=
 =?utf-8?B?U0Z0OFMrNHN2aVRjai9Wc2FrZUhGRGl6RUI4dzA2ZENHQ2g1RzQvclRRTS9L?=
 =?utf-8?B?UVdabjFPbkNTVGJuUnZtcUZ3cGlOMkU2ZkF4bUhtaDVwbytoODdlWDArUFdy?=
 =?utf-8?B?NVR5ckZvcjJVYi9mNHVUVmN1U3hjUDZJKzI3ckY4VS9RZWNrbWRHSFByWDBx?=
 =?utf-8?B?N1E0TWkxQ2JTcjNZTExGRHF0OWMvcnBvZE0vZEN3VVk5MkdWUGZSU0p5bFhp?=
 =?utf-8?B?SkFwbmtlazAyUStIRGpqSVJtZkg3QUo4SlJpWnE2d1ZFS1psOGlhZ1ZxdHpF?=
 =?utf-8?B?bEF2REhFS0kwQkVxRDAzWDhIMzcwaEtDM2xjRWpYTGcrS1hHU3RrZ2tRenp6?=
 =?utf-8?B?UUE1MTA3ODNpbmN3cFA4Vy9mZlgxTm1ScEorTTdHRENBTWRzUnRPdTVoMTRK?=
 =?utf-8?B?MFlTMWJ0UlRpK09qcUhNNWFUQ0p2UlQzdHBXdFpIc2Y2TkIwWENpM1Y0VkVj?=
 =?utf-8?B?OWVoeTZpaEtxMFRIeVNzOWdreDM5MS9GSm40RjZmUkMvSEhncDlpNWViNGcy?=
 =?utf-8?B?S2MwUXpsck1RUFNWbkJkbUIzN01xS2lzdEdaZk8wNWlBRmZiQmRhbjNYUG9k?=
 =?utf-8?B?cGNuRnl0Mjc3NVdnL3dBN2wzbXFYWWxncGhIQ1orQVEzeXEydlVZdkpLWnZB?=
 =?utf-8?B?aVNCdlBRTWRKelJvVldJV1RGeDJ3REhmUmo3UjZ5ZEIwaTdSQkxVcVBiUkxN?=
 =?utf-8?B?TC9XU2pqKzhicTFtVDdoV2RQTFdMR1k3RG5RdENONC8xbUN0dDFNWGxjMzFR?=
 =?utf-8?B?Zk83Ry90MjRYVUYwUHNibWFaMmo2WVRDTjhBSEtPV0VlV0s1emVPVmNzSm5Z?=
 =?utf-8?B?VFJ0SFYvM3VvaGNhRWdtMzA0OHJMb0grNnBzendxT3RpWjE2VG1XVkRaVmY3?=
 =?utf-8?B?dHJYZEVFY3hEL2kyMXJKZkNpazZ6Q3BpUlRQTEJlVWdMMG1QQVZ4Qlkzb2dD?=
 =?utf-8?B?QS81cVRGMW5zMlB5ZDgxOXREVDZZZUU1ZjhVR2pnTHBuWGEvQ0VTMStJdEE0?=
 =?utf-8?B?SE04OHVBdlowYmtFTXpnWWNoMDYxaTVzSGhpRDRCNGdZQkpIN1hVWWtaaGNL?=
 =?utf-8?B?VUd6SFFmL1UxZTZscnBiNi9ac2FFczdBUlVkakp0UU1ud3pxbnJCQ2xZWm9I?=
 =?utf-8?B?dGx4azd5bDRuZXpzUUpMR1B1QnhNYXJ2WWVUZitkZWVmRGNNcUtOKy9peXVm?=
 =?utf-8?B?K3RncXRIajVOcG1PTkFxcitqbEJGWFoyQ2Y5OHF6TXI2YnlhZVgvZFQwaU9p?=
 =?utf-8?B?Tm02YU1zeWJlVUJZWmR5azdRL0t5bTMxYW16Q2ZZRDVkVnQxZmZndll3TERP?=
 =?utf-8?B?U01xYmdPbW5McUtvd2NlR1RKYzlKREhONEp6aHZ2RXJ2c2swbkpUUUkvRTFC?=
 =?utf-8?Q?nd+bkmbWnl/VkY6I=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <959EC672680C8B41878154230D4303F6@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	QqC5EVFdG6DxgonudkoP771+wHrJhYvfsL38G89uAGo6qpqldNokrGRNL1jJDE3tKYpDoR4foZz5vZXPWCclzbo9Ea33gGCtZpz8i4ff3FmeA2iCoYlDmXCTKWrbVTy8lt5WYAmTWUVdGl89odnyjVwHgON6T3ISTUmKwHVvGwjL8n0DjBX3ifMWq45qn/O993vVjCvK3K0TXiTp2L39WrUZ/v95as1iP4MNsXmxYV+eWKtlHq1eu9vyuBm7QYh25mqWCVbPfJ2umQguNcyT15fRYu4q2Atht22YlGKYKszuzkFHa4Gx6CkDo/JUD3bGQc2AFtHI8zyqD+Ld/Uq2kQ==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e9bc701-1f77-42c7-97b0-08df1d65438d
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Sep 2026 13:34:47.1832
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DQC74GqprNMyCZez5zGxPpv3V+wHRzSedMoNmTDPRTrgJzbWIiqO9FeztaTR9yFZCx66kZndWzVJv/0G6MKukrketDVDbJFD2ralPQ5JuqI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR02MB8114
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI4MDA1MyBTYWx0ZWRfX2fMndQXw1uER
 eQ9/wlxYmBsEUl7KSNmgxHx4teekA/FdSkSuzZZkces/EiUklCJYdj71MyYMp8ekeOt1kBLN/10
 XpTnJtn4lfHvMmZhpOVtxgINEEGgKAdKpn1/ChCUCOZWWYBgBpj1cNMwDv5UtuJnhQcNaiIvvi8
 teZJYbd5/h224iI+CqoFjigZ4A4PZwhthP/YmqdmIcaLd1+a4uPxWe5b5xZv5+hh5emHL1K7zDi
 aOlcE87FPzFOsYV1qRzvmBoJI08TOo7v3d/xTlo0xeg65a+zwLWgtjYID3z/cFVR2BHw+/8pjBb
 3T2VZ1xtHPEC/u47FUL6wgyFz46/SczEsvxNEBPC72ZWGfSJ/tIw6OFT6vtYzKOlCs3ovWKeshc
 NzRW86KCE+H0p8Fi6CcXg5NTUH1rKxv6oRt0j3Wkix4GdcQZRNP80poGqDxY0LeL9lzclmv3U7X
 DWRT0YFjT4juiMmM1xw==
X-Proofpoint-ORIG-GUID: AhhAEZ_2hZwlIgc1wMOuh-96DSgxEzua
X-Authority-Analysis: v=2.4 cv=fP2sTpae c=1 sm=1 tr=0 ts=6aba6cf8 cx=c_pps
 a=ZDePlyM4ypdfO5fYno2TiQ==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VofLwUrZ8Iiv6rRUPXIb:22 a=VUi8bpU7OL1Oj2-RSIOF:22 a=20KFwNOVAAAA:8
 a=jftXCBUiCFkjTSMBtesA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI4MDA1MyBTYWx0ZWRfX1EBD+tzVJV7s
 ngO28iiFmH/3A/urdClOCN4yMe5UlPKVIJC5aeZ2i3jZr82l3jjCO+PBALlXEha+twM72MUYdhF
 u7+CIDKSiychnX3wsqSKB342t3QU71c=
X-Proofpoint-GUID: AhhAEZ_2hZwlIgc1wMOuh-96DSgxEzua
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-28_03,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gMTYgU2VwIDIwMjYsIGF0IDg6MTXigK9QTSwgRXJpYyBBdWdlciA8ZXJpYy5hdWdl
ckByZWRoYXQuY29tPiB3cm90ZToNCj4gDQo+ICEtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tfA0KPiAgQ0FVVElPTjogRXh0
ZXJuYWwgRW1haWwNCj4gDQo+IHwtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tIQ0KPiANCj4gQWRkIGt2bV9pZHJlZ193cml0
ZV9zY3JhdGNoX3ZjcHUgaGVscGVyIHRoYXQgd2lsbCBiZSB1c2VkDQo+IGJ5IHFtcF9xdWVyeV9j
cHVfbW9kZWxfZXhwYW5zaW9uIGNvZGUgdG8gdGVzdCBTWVNSRUcgc2V0dGluZ3MNCj4gYWdhaW5z
dCBhIHNjcmF0Y2ggdmNwdS4gSW5kZWVkIHdoZW4gdGhlIGV4cGFuc2lvbiBjb2RlIGlzIGNhbGxl
ZA0KPiB0aGUgYWN0dWFsIHZjcHUgaGFzIG5vdCBiZWVuIGluaXRpYWxpemVkIHNvIHdlIHVzZSBh
IHNjcmF0Y2ggdmNwdS4NCj4gVGhpcyBsYXR0ZXIgaGFzIGJlZW4gaW5pdGlhbGl6ZWQgd2l0aCBm
ZWF0dXJlcyB0YWtlbiBmcm9tDQo+IGxlZ2FjeSBjb21wb3NpdGl2ZSBvcHRpb25zIChFTDIsIFNW
RSwgLi4uKS4gU28gdGhlIHRyaWFsIGlzDQo+IHZlcnkgY2xvc2UgdG8gdGhlIGZpbmFsIHNldHVw
Lg0KPiANCj4gU2lnbmVkLW9mZi1ieTogRXJpYyBBdWdlciA8ZXJpYy5hdWdlckByZWRoYXQuY29t
Pg0KPiAtLS0NCj4gdGFyZ2V0L2FybS9rdm1fYXJtLmggICAgfCAgNCArKysrDQo+IHRhcmdldC9h
cm0va3ZtLXN0dWIuYyAgIHwgIDcgKysrKysrDQo+IHRhcmdldC9hcm0va3ZtLmMgICAgICAgIHwg
NTEgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysNCj4gdGFyZ2V0L2Fy
bS90cmFjZS1ldmVudHMgfCAgMSArDQo+IDQgZmlsZXMgY2hhbmdlZCwgNjMgaW5zZXJ0aW9ucygr
KQ0KPiANCj4gZGlmZiAtLWdpdCBhL3RhcmdldC9hcm0va3ZtX2FybS5oIGIvdGFyZ2V0L2FybS9r
dm1fYXJtLmgNCj4gaW5kZXggMmIzNDc0Y2MzNi4uYmFjZTY5ZWZlZCAxMDA2NDQNCj4gLS0tIGEv
dGFyZ2V0L2FybS9rdm1fYXJtLmgNCj4gKysrIGIvdGFyZ2V0L2FybS9rdm1fYXJtLmgNCj4gQEAg
LTE0LDYgKzE0LDcgQEANCj4gI2luY2x1ZGUgInFhcGkvcWFwaS10eXBlcy1taXNjLWFybS5oIg0K
PiAjaW5jbHVkZSAic3lzdGVtL2t2bS5oIg0KPiAjaW5jbHVkZSAidGFyZ2V0L2FybS9jcHUtcW9t
LmgiDQo+ICsjaW5jbHVkZSAiY3B1LWlkcmVncy5oIg0KPiANCj4gI2RlZmluZSBLVk1fQVJNX1ZH
SUNfVjIgICAoMSA8PCAwKQ0KPiAjZGVmaW5lIEtWTV9BUk1fVkdJQ19WMyAgICgxIDw8IDEpDQo+
IEBAIC0yNTAsNCArMjUxLDcgQEAgdm9pZCBhcm1fZ2ljX2NhcF9rdm1fcHJvYmUoR0lDQ2FwYWJp
bGl0eSAqdjIsIEdJQ0NhcGFiaWxpdHkgKnYzKTsNCj4gICovDQo+IGNoYXIgKmt2bV9wcmludF9y
ZWdpc3Rlcl9uYW1lKHVpbnQ2NF90IHJlZ2lkeCk7DQo+IA0KPiArYm9vbCBrdm1faWRyZWdfd3Jp
dGVfc2NyYXRjaF92Y3B1KEFSTUNQVSAqY3B1LCBpbnQgY3B1ZmQsDQo+ICsgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgQVJNNjRTeXNSZWdGaWVsZCAqZmllbGQsIHVpbnQ2NF90IG5l
d2Z2LA0KPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIEVycm9yICoqZXJycCk7
DQo+ICNlbmRpZg0KPiBkaWZmIC0tZ2l0IGEvdGFyZ2V0L2FybS9rdm0tc3R1Yi5jIGIvdGFyZ2V0
L2FybS9rdm0tc3R1Yi5jDQo+IGluZGV4IDg4Y2JlOGQ4NWMuLjhlNmZhZTBhNGQgMTAwNjQ0DQo+
IC0tLSBhL3RhcmdldC9hcm0va3ZtLXN0dWIuYw0KPiArKysgYi90YXJnZXQvYXJtL2t2bS1zdHVi
LmMNCj4gQEAgLTExOSwzICsxMTksMTAgQEAgY2hhciAqa3ZtX3ByaW50X3JlZ2lzdGVyX25hbWUo
dWludDY0X3QgcmVnaWR4KQ0KPiB7DQo+ICAgICBnX2Fzc2VydF9ub3RfcmVhY2hlZCgpOw0KPiB9
DQo+ICsNCj4gK2Jvb2wga3ZtX2lkcmVnX3dyaXRlX3NjcmF0Y2hfdmNwdShBUk1DUFUgKmNwdSwg
aW50IGNwdWZkLA0KPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIEFSTTY0U3lz
UmVnRmllbGQgKmZpZWxkLCB1aW50NjRfdCBuZXdmdiwNCj4gKyAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICBFcnJvciAqKmVycnApDQo+ICt7DQo+ICsgICAgZ19hc3NlcnRfbm90X3Jl
YWNoZWQoKTsNCj4gK30NCj4gZGlmZiAtLWdpdCBhL3RhcmdldC9hcm0va3ZtLmMgYi90YXJnZXQv
YXJtL2t2bS5jDQo+IGluZGV4IDUzNzY3MzE3N2EuLmY3Y2EwZTAyNTAgMTAwNjQ0DQo+IC0tLSBh
L3RhcmdldC9hcm0va3ZtLmMNCj4gKysrIGIvdGFyZ2V0L2FybS9rdm0uYw0KPiBAQCAtNDQ3LDYg
KzQ0Nyw1NyBAQCBzdGF0aWMgYm9vbCBrdm1fYXJtX3ZjcHVfdmFsaWRhdGVfc3lzcmVnKEFSTUNQ
VSAqY3B1LCBBUk02NFN5c1JlZ0ZpZWxkICpmaWVsZCwNCj4gI2RlZmluZSBLRVlfVE9fUkVHX0lE
WChrZXkpICAgICAoKHVpbnQzMl90KSgoKHVpbnQ2NF90KShrZXkpKSA+PiA4KSkNCj4gI2RlZmlu
ZSBLRVlfVE9fU0hJRlQoa2V5KSAgICAgICAoKHVpbnQ4X3QpKCgodWludDY0X3QpKGtleSkpICYg
MHhGRikpDQo+IA0KPiArYm9vbCBrdm1faWRyZWdfd3JpdGVfc2NyYXRjaF92Y3B1KEFSTUNQVSAq
Y3B1LCBpbnQgY3B1ZmQsDQo+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgQVJN
NjRTeXNSZWdGaWVsZCAqZmllbGQsIHVpbnQ2NF90IG5ld2Z2LA0KPiArICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgIEVycm9yICoqZXJycCkNCj4gK3sNCj4gKyAgICB1aW50NjRfdCBt
YXNrLCBvbGRfcmVnX3ZhbCwgbmV3X3JlZ192YWwsIG9sZGZ2Ow0KPiArICAgIHN0cnVjdCBrdm1f
b25lX3JlZyByZWc7DQo+ICsgICAgaW50IGxvd2VyID0gZmllbGQtPnNoaWZ0Ow0KPiArICAgIGlu
dCBsZW5ndGggPSBmaWVsZC0+bGVuZ3RoOw0KPiArICAgIGludCBpbmRleCA9IGZpZWxkLT5pbmRl
eDsNCj4gKyAgICB1aW50NjRfdCBraWR4Ow0KPiArICAgIGludCByZXQ7DQo+ICsNCj4gKyAgICBt
YXNrID0gTUFLRV82NEJJVF9NQVNLKGxvd2VyLCBsZW5ndGgpOw0KPiArDQo+ICsgICAgaWYgKCFr
dm1fYXJtX3ZjcHVfdmFsaWRhdGVfc3lzcmVnKGNwdSwgZmllbGQsIG5ld2Z2LCBlcnJwKSkgew0K
PiArICAgICAgICByZXR1cm4gZmFsc2U7DQo+ICsgICAgfTsNCj4gKw0KPiArICAgIGtpZHggPSBp
ZHJlZ3Nfc3lzcmVnX3RvX2t2bV9yZWcoaWRfcmVnaXN0ZXJfc3lzcmVnW2luZGV4XSk7DQo+ICsg
ICAgcmV0ID0gcmVhZF9zeXNfcmVnNjQoY3B1ZmQsICZvbGRfcmVnX3ZhbCwga2lkeCk7DQo+ICsg
ICAgaWYgKHJldCkgew0KPiArICAgICAgICBlcnJvcl9zZXRnKGVycnAsICJmYWlsZWQgdG8gcmVh
ZCB0aGUgc2NyYXRjaCB2Y3B1IHZhbHVlIGZvciBmaWVsZCAlcyAlbSIsDQo+ICsgICAgICAgICAg
ICAgICAgICAgZmllbGQtPm5hbWUpOw0KPiArICAgICAgICByZXR1cm4gZmFsc2U7DQo+ICsgICAg
fQ0KPiArICAgIG9sZGZ2ID0gKG9sZF9yZWdfdmFsICYgbWFzaykgPj4gbG93ZXI7DQo+ICsNCj4g
KyAgICBuZXdfcmVnX3ZhbCA9IG9sZF9yZWdfdmFsICYgfm1hc2s7DQo+ICsgICAgbmV3X3JlZ192
YWwgfD0gbmV3ZnYgPDwgbG93ZXI7DQo+ICsNCj4gKyAgICByZWcuaWQgPSBraWR4Ow0KPiArICAg
IHJlZy5hZGRyID0gKHVpbnRwdHJfdCkmbmV3X3JlZ192YWw7DQo+ICsgICAgcmV0ID0gaW9jdGwo
Y3B1ZmQsIEtWTV9TRVRfT05FX1JFRywgJnJlZyk7DQo+ICsgICAgaWYgKHJldCkgew0KPiArICAg
ICAgICBlcnJvcl9zZXRnKGVycnAsICJmYWlsZWQgdG8gYXBwbHkgbmV3IHZhbHVlIDB4JSJQUkl4
NjQiIGZvciBmaWVsZCAlcyAiDQo+ICsgICAgICAgICAgICAgICAgICAgIihwcmV2aW91cyBpcyAw
eCUiUFJJeDY0Iik6ICVtIiwgbmV3ZnYsIGZpZWxkLT5uYW1lLCBvbGRmdik7DQo+ICsgICAgICAg
IHJldHVybiBmYWxzZTsNCj4gKyAgICB9IGVsc2Ugew0KPiArICAgICAgICB1aW50NjRfdCBjaGVj
a192YWwsIGFjdHVhbGZ2Ow0KPiArDQo+ICsgICAgICAgIHJldCA9IHJlYWRfc3lzX3JlZzY0KGNw
dWZkLCAmY2hlY2tfdmFsLCBraWR4KTsNCj4gKyAgICAgICAgaWYgKHJldCkgew0KPiArICAgICAg
ICAgICAgZXJyb3Jfc2V0ZyhlcnJwLCAiZmFpbGVkIHRvIHJlYWQgdGhlIG5ldyByZWcgdmFsdWU6
ICVtIik7DQo+ICsgICAgICAgICAgICByZXR1cm4gZmFsc2U7DQo+ICsgICAgICAgIH0NCj4gKyAg
ICAgICAgYWN0dWFsZnYgPSAoY2hlY2tfdmFsICYgbWFzaykgPj4gbG93ZXI7DQo+ICsgICAgICAg
IHRyYWNlX2t2bV9pZHJlZ193cml0ZV9zY3JhdGNoX3ZjcHUoZmllbGQtPm5hbWUsIG9sZGZ2LCBu
ZXdmdiwgYWN0dWFsZnYpOw0KPiArICAgIH0NCj4gKyAgICByZXR1cm4gdHJ1ZTsNCj4gK30NCj4g
Kw0KDQpIaSBFcmljLA0KDQpUaGlzIGxvb2tzIHNpbWlsYXIgdG8ga3ZtX2FybV9hcHBseV9zeXNy
ZWdfcHJvcHMoKSwgd2UgbWF5YmUgYmUgYWJsZSB0byBhYnN0cmFjdCBvdXQga3ZtX2FybV9hcHBs
eV9zeXNyZWdfcHJvcCgpLA0Kd2hpY2ggY2FuIHRoZW4gYmUgdXNlZCBieSBib3RoIHRoZXNlIGZ1
bmN0aW9ucy4NCg0KPiBzdGF0aWMgdm9pZCBzZXRfc3lzcmVnX3Byb3AoT2JqZWN0ICpvYmosIFZp
c2l0b3IgKnYsDQo+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICBjb25zdCBjaGFyICpuYW1l
LCB2b2lkICpvcGFxdWUsDQo+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICBFcnJvciAqKmVy
cnApDQo+IGRpZmYgLS1naXQgYS90YXJnZXQvYXJtL3RyYWNlLWV2ZW50cyBiL3RhcmdldC9hcm0v
dHJhY2UtZXZlbnRzDQo+IGluZGV4IDJhOWNjNjcwMzUuLjdhM2Y0OTlhMGUgMTAwNjQ0DQo+IC0t
LSBhL3RhcmdldC9hcm0vdHJhY2UtZXZlbnRzDQo+ICsrKyBiL3RhcmdldC9hcm0vdHJhY2UtZXZl
bnRzDQo+IEBAIC0yMSw2ICsyMSw3IEBAIHNldF9zeXNyZWdfcHJvcChjb25zdCBjaGFyICpuYW1l
LCB1aW50NjRfdCBvbGQsIHVpbnQ2NF90IG1hc2ssIHVpbnQ2NF90IGZpZWxkX3ZhDQo+IGFwcGx5
X3N5c3JlZ19wcm9wKGNvbnN0IGNoYXIgKnJlZ19uYW1lLCBjb25zdCBjaGFyICpmaWVsZF9uYW1l
LCB1aW50NjRfdCBvbGQsIHVpbnQ2NF90IGN1cnJlbnQsIHVpbnQ2NF90IG1hc2ssIHVpbnQ2NF90
IGZpZWxkX3ZhbHVlLCB1aW50NjRfdCBuZXcpICIlcy4lcyBvbGQ9MHglIlBSSXg2NCIgY3VycmVu
dD0weCUiUFJJeDY0IiBtYXNrPTB4JSJQUkl4NjQiIG5ldyBmaWVsZCB2YWx1ZT0weCUiUFJJeDY0
IiBuZXc9MHglIlBSSXg2NA0KPiBuYl9zeXNyZWdfcHJvcHMoY29uc3QgY2hhciAqbmFtZSwgaW50
IGNvdW50KSAiJXM6ICVkIFNZU1JFRyBwcm9wZXJ0aWVzIg0KPiB1bmV4cGVjdGVkX3dyaXRhYmxl
X3Jlc2VydmVkX2ZpZWxkKGNvbnN0IGNoYXIgKnJlZ19uYW1lLCBjb25zdCBjaGFyICpmaWVsZF9u
YW1lLCBpbnQgbG93ZXIsIGludCB1cHBlcikgIlVuZXhwZWN0ZWQgd3JpdGFibGUgcmVzZXJ2ZWQg
ZmllbGQ6ICVzLiVzIFslZCwlZF0sIHNraXAgaXQgLi4uIg0KPiAra3ZtX2lkcmVnX3dyaXRlX3Nj
cmF0Y2hfdmNwdShjb25zdCBjaGFyICpuYW1lLCB1aW50NjRfdCBvbGRmdiwgdWludDY0X3QgbmV3
ZnYsIHVpbnQ2NF90IGFjdHVhbGZ2KSAic3VjY2Vzc2Z1bCBkcnktcnVuIGZvciAlcyBvbGQ9MHgl
IlBSSXg2NCIgbmV3PTB4JSJQUkl4NjQiIGFjdHVhbD0weCUiUFJJeDY0DQo+IA0KPiAjIGNwdS5j
DQo+IGFybV9jcHVfcmVzZXQodWludDY0X3QgbXBfYWZmKSAiY3B1ICUiIFBSSXU2NA0KPiAtLSAN
Cj4gMi41My4wDQo+IA0KDQo=
