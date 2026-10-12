Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E7522BEFEE
	for <kvmarm@lists.linux.dev>; Mon, 12 Oct 2026 08:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791793551; cv=fail; b=Wna03mlKYab457Yfdepi1ks3EB8P1pFryz3TDcHAVU9csKEaEpDH7GwS4WNS583f95gMwfaRjU7hbvkjo97UCkvxskAUjcSreonnv7XnMM/lddkRKIpPr2eGq/34PZdd7lhIUh9NblYwYvKo2n9w4kiReehs68QAp+xT8Nk54LY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791793551; c=relaxed/simple;
	bh=Bgyip4cvntF6iu3dYg/vESgmqTSc0/rDzaeRqefQXcw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=BeNsT+chJE2TQ68eieL+fHHpmeeK1P8SGpCKFyIOMqkg34mzoPL8lh+SpFf/rHlzU5jDWOcPgI8K6iPwhJ62uEITg8Iu27XK0FysoSvOl1uoLweyfU7hZHdJTJW0YPMdnUdsYv7tk9qMZlkUmCMpEPbGcOEfpHFwuCsIrf0WrJY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=TbwD26o3; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=hvPHEy05; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="TbwD26o3";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="hvPHEy05"
Received: from pps.filterd (m0127844.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69C8L6St2490258;
	Mon, 12 Oct 2026 01:25:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=Bgyip4cvntF6iu3dYg/vESgmqTSc0/rDzaeRqefQX
	cw=; b=TbwD26o3HsgPQwr9lYsjfOOFy3qAY/jMpH8/NKBylDkiGyRT+xN1/QvNL
	jhnVuEGXBqKyicqjHYEcow4b5oXFNGFlkPLuGQwo3bT7ymVP0AhXi8/l+PfJw8uC
	AueD/k12FruVOBoCq+O/r5GCmbc+yoCKPnscSZkj7pYkbhac1pqS1EunwaxL/THT
	eI7NlRUxHm4PPRt2iQzbWCekhi7TQfU2nDuSxgZZFWy5Eumt3e0AWle48TyVGbov
	3vDNyGgecFfl+yCfcfbZWOqolfoDR2mhAa39sSMGGNgWrHXMPZyzbQ/wzg1k5obg
	VKv5ZOn/gS3ByPLl+F/HJxObN95Sw==
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11022125.outbound.protection.outlook.com [52.101.43.125])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4h7mw02jxd-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 12 Oct 2026 01:25:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZTxEAv2wwhVCZvA8hVFP/6SZyTaO6DWdbv0zwMDHxmWmZipkyjc0JaUrPTj+i/cC4yJBsDtm6VYQwcBT562MVGXcvpyEK3VwhHVPyuAmgj1qFCM2caUJKD2OIeLhm82xIPNsl5I5g759jphdnm5e8qq05glw02DqDSi7mVGRus/hyPewzdw/PPrd0dOhGsiZYWHLWJcwftRcGzWzwfXV8B4v7n3xU48GYSJeqizBD56mYV5cpnp2BDFGZL4Ok8KhcxVVh1jCuzH6D1aWpE3lDSi/h1XEDwNp7jLx0T5WvW2M7q4EknrZRssn9BzEfQs55aj7R7To+Ew3qu+9En/sHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Bgyip4cvntF6iu3dYg/vESgmqTSc0/rDzaeRqefQXcw=;
 b=xmG8HHwe436+LaE1qfcMoDxuNX/sFRRHGUmY7SSowjaMv4hBJivm7TssnVCVjBb1MF5DrBKOrEE6vwLe+DsOYnf+qgDao4Copf9YlCKRfDoEN+tzEHueG2rvLcoUcYBMgSpq6fzXCp6GgWH0TdJOFR5jd2IfxxtcFe5AK2rXnjENFmoIzc7IAKK5EjjLxQHb1en/eDEHvPm+wL1fDloE1IM3sOmUAI9CjOLs7khDtasZRsvJEDih0fewOhyj7FiZwMC01dzI8ntjoe3M0rAmSwBMHIMuDKoOb23n0Wesc+igXsB3IrZD+nagkhiy87XrjfXbf+4gLGkb6K6q6tv3/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bgyip4cvntF6iu3dYg/vESgmqTSc0/rDzaeRqefQXcw=;
 b=hvPHEy05nrxtsqukOHr54TYckkGJ/8wXkmTD8XSgxzy7Qb5t4dADa2bnMjin2iK2helSifr5tKE1ny8UbyrmdrFWIx6mp/zn946eEOGIOJRYdAB/5d6LLlXT16leWFQjaKNFTIDEj0RW+0Y5tX15Pe5lJx33r4hZPRDjddrZVvRvAU3JpLrxnI14qJ0Ly1HtBns62UPZD9cdfU32WbAE85L3hB38orgPrKhdX6TWhFZwBeN4ieylrhYtmQnBc8Hlb/5dDaQsCbzHEB37OFrckb1uf8AF0yx9RXJtUW3y6PZyWppBKJrmvdK8ZB1a+zAdiHtX5+zjr4Cit2XxbFJgFg==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by DS7PR02MB11036.namprd02.prod.outlook.com (2603:10b6:8:265::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.21; Mon, 12 Oct
 2026 08:25:35 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%5]) with mapi id 15.21.0496.020; Mon, 12 Oct 2026
 08:25:35 +0000
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
Subject: Re: [PATCH v10 12/26] arm/kvm: Initialize isar.idregs[] with all
 writable host ID regs
Thread-Topic: [PATCH v10 12/26] arm/kvm: Initialize isar.idregs[] with all
 writable host ID regs
Thread-Index: AQHdWLytTlozwUMUdEWG691NELQFGLb5lPsA
Date: Mon, 12 Oct 2026 08:25:35 +0000
Message-ID: <76E7DC0A-7763-4076-9715-73B9B632EA38@nutanix.com>
References: <20261010133725.642498-1-eric.auger@redhat.com>
 <20261010133725.642498-13-eric.auger@redhat.com>
In-Reply-To: <20261010133725.642498-13-eric.auger@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nutanix.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA2PR02MB7564:EE_|DS7PR02MB11036:EE_
x-ms-office365-filtering-correlation-id: df4e4329-ee24-4795-70df-08df283a6372
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|376014|1800799024|23010399003|366016|6133799003|18002099003|22082099003|10067099003|38070700021|261009223027099003|4143699003|56012099006;
x-microsoft-antispam-message-info:
 xq038bbL6xGW8M51YSu2Lt/oY225abgs1LD2oPWlaaiyfEaiiqrvckC4fRqHHqKhibtDIKwAjJeV7mnOuu9+IiWFEU9rxrWmQt3omgbEtNR9cF/KKy3UerF+EyRHGI/g59fg5F/xsQsZtKj3Dt9JxeZuODSnr1fEzSWpbjLL0HYhtJFH1RirZQY3g/TrvP7MLmkO/1ssnRyusxbICZ/jU2/Zs9tl/nhqczCvBP+F+RUJxC5IzPPTAm00LgWuDRkqmK0S9idRR0ipScEz7R35ZcGrlDvs1TVOlxCdDK+q7bjoiV4+8Eg2u8DejrFm+Qm//ryBk8Y5WLb8b4JqGcB3P77XtdPm5mMmU2t8PoJF48biitrzgzkDdrrd1MxX8EN0A1RU8/rf0Ft8BydjhPc9qXlO3QXdNI9lqoZXQgkoDg5BGHYuFj0ogZBLaQrQIt/CSXe6R6IFzPHVijqpYA2QSmqc5c82N7/cW4EHmcN9a9cfxxUVLW+Pj64OTsToTeduLTLXD2mlu3gq0lsQ9qb9MJ8jmMzGOAMFU+VZOHd1HqUGVDul3nomAbMA2EqVMCWDmDguXfCxw9MmzYSKJEA7a/ZAceS/iNrf80Yp+vKFtQzZ3breb/zkQjUZMeDbv6pcWiJGmvYt8My7q4De+QynU+E3oMA36C0LyLlLznLOaRs0/OZHPNHy3q3cNnL/iMsVAE1LDMh4/aDNwrVOys6mNWucmBXz5lw2AhKZu7gM5YE=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(23010399003)(366016)(6133799003)(18002099003)(22082099003)(10067099003)(38070700021)(261009223027099003)(4143699003)(56012099006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?Slk5YmtZMUFWMExCeWdlamZXbktvMzJMKzhEclpTRVZDbkhNZDZMYzdTSUdF?=
 =?utf-8?B?YmVoTkd5anhyK3ZZdmwrcURiMUFYbkRwNTBPZi96ckxjKzczTTVTeU12REpt?=
 =?utf-8?B?YnBXUlV5dXc5amxEYmRYZGJ0TzN4TnVEV0NRY0JBWmlyU0E5bHBsUlRucHU4?=
 =?utf-8?B?N1JkZ1g1eTFpSFFoVUM1MVhIdXdlM3BOeElvUWdxUlExSUd1UlVQOTRGWG1B?=
 =?utf-8?B?RDVUTUIxV215cm56enpScS9FY3RsYmFZemhXNjJPSTk5L1F4UkpCTFc0byty?=
 =?utf-8?B?YXAvRTZxTXU2VEVodHMyNGhtRFlRc2pCUWEwTWlDTWF1Lzhqb29uUDFXYVR4?=
 =?utf-8?B?dWF0cHMvRStHYUsxQUJ5OU1Xa3hJeWhHNEFPMjZXTDIvMm9QSUxPK25TbUZh?=
 =?utf-8?B?VFdEMjBtWTdrZXA3RFVqQXRLeUhFRFVFVHdGR0tIV1JJUHc2dWY5cWdtYWIr?=
 =?utf-8?B?d0VjQ2lEa0hVS1V4d0t1ZW1CcWNYbWxPUFBmNjNzd2pEa3ZJc0pORk84SDgr?=
 =?utf-8?B?cDVzamU1dTBYYnRxT0ljcW82SG5JVGt3ZTZiTzIvSG5FVmovcCtNQVVFUzZi?=
 =?utf-8?B?WUU0ZHkyL2xlV0xmRTkwVkVyNDJ2WXJkakdQOHhPVU9UcWxhdkY2bDV5eno5?=
 =?utf-8?B?MXdiZEVWenZxNERKYkVZMEFjc21GTFVlWXE2eUhYQU9IQVEzb2F5Ry91NXVO?=
 =?utf-8?B?bXo2Rk1GUEU3OWxvaS94OVd3SWI4WWZpYTk0SHNjSnN4VmtUdHlmdUlFWDNT?=
 =?utf-8?B?M2FXM2h0UXYzZTZrQ2xKZDJmSzQ3dVpNYmIxbmVURmNvUC9HeU5GR1VlckFC?=
 =?utf-8?B?cUdJWDVrM0xCb0VQYzFrS3Iwc2ZFc2ZDV3VhWnpTSjlRQ0hRRC9hV0lWb0tJ?=
 =?utf-8?B?RlNIVXBETExBVWNHaWluZE1ORTRaOERaWGtEd1MzblJnQ1lyUlByU283YXRv?=
 =?utf-8?B?dnVucG4vS0V5ZlNQelFHbTlVVTBjbUpFNGxCZnZ0SEZLT090Q3VNZlI2SzBs?=
 =?utf-8?B?WUx3eXpDd1FSYUZwWEx3dGNYRTJBQ2kvS3ZWUVRTek5Mc01CdW1nd3I3TWRQ?=
 =?utf-8?B?bVRnalNFWGdPSGszK3hNWlZySi92Y3RvZU9YWHVMbWZHdzVIOXRIVFUwWDhH?=
 =?utf-8?B?RUhBYWxWYnJZc3hnZW1PS0JRWCtxSzlSbVUzK1NQdXp5dEplVWlaWG0weGti?=
 =?utf-8?B?ZHlFT3EzQ2M3MUltNjhWMHdRcmxmWHhGSVlnK3dYRXJLT2lHcFFsaWk3WE1k?=
 =?utf-8?B?R1BPeE40dUhqSllLZHZXTDVMSXlNejRzd3FZakViZmhaL0w5bWtTZkJtbW9E?=
 =?utf-8?B?L2xpc0JXamQvM2l6V2RzTFEva2tYelMwMllSVmdPa2JwZG5TMHcyWFo0WU9o?=
 =?utf-8?B?Y2hRRzl4UmpqdlVpR0hKZk9aUS9STzJJQWMzU1M2RlNFY3hPYm9KUGthMmhV?=
 =?utf-8?B?SEVMTk9jcXpFdWVXL3poQlJ0SHZYd1NteGtBTWFGcG1rRHd5aklYQ1FyWEdP?=
 =?utf-8?B?TlFYZFlXa2Y5V0RmbTZkNkxvcWcrN0RhYW1Dem9IT0c4OFNscHpJYkxaYVlz?=
 =?utf-8?B?anlMelJEMmthYWNocXd3Q0drU1psL0lmcVBPbXhGWTZzRXJFeDJNT0s0R09M?=
 =?utf-8?B?SkFhZTdVQ2ZKYTQ4d1F4NHZRUS93SmJEUURFRzdDcWtQTFdPMjlQT0Iva1o2?=
 =?utf-8?B?R3lzVDN0WXpYNUNwL2Q3bzhBd0VscW9jU1UyVGlOVmRwbjRqcytjZnJhbjA3?=
 =?utf-8?B?c3FoclpraUw1ZFMxa05sMGdQQ3JvbXpISFlTbXJIK3VkRnViM1ZmbStXZXhj?=
 =?utf-8?B?RkFNWEkybHhKTHFSYjFtVFJCWlQ5M1JuV0lNZk5hRk1HK3UrSHpCb2lma0lB?=
 =?utf-8?B?QWp3YVRSRnRpMnlrR2JESFNiY3UyMUhjVHFYODdLaTRFM21qNmhSWS9lNC9j?=
 =?utf-8?B?MjFFS1c1cCtodXBrbVFrYWRiSnFzelFqbDhqbmYzT2wyMHRWeW1mNk5aSXRH?=
 =?utf-8?B?NDNMMzYxbkZ1WndpQWk1aVJIQ2pzbXZZVHRiZzZGUkxGSUswNjhQZWNNTkoz?=
 =?utf-8?B?cXpZYUhZTkdmRHZrWHo3NlVYRmpwZHFkNkF4OERFTDc0WTFDMTN1YkRpS00w?=
 =?utf-8?B?SFlIL00wZklLWkN0S0UxTU1idmN5TG9zZDliUUxTeXlPMkxDWEo3Nkt3S29R?=
 =?utf-8?B?UGtKZ0lSRmJ0aEw3RmR5bHRMQ1FodTU0WGRkZk5DdUl0VHdOam5lU1F5a2pn?=
 =?utf-8?B?K0E5ZEI4bkY0YVdDS3NZS2tlL2FXVS9aYXVmWjk0alFZSmdZSlBHdkhkR2Jr?=
 =?utf-8?B?UmRaSHlKVGtCbCtGajd1ZVRqcjZNRWNFV0dubERjZHNZSWJMV0hXNWxHamV0?=
 =?utf-8?Q?6oCKbBZYo5+WBybg=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <57083D510A948B47B0CFDA40F296EA26@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	eUpbnv/h6NOlNjc+jx7YXZ5D4mCcNbKJOGys3vNP+FxrDcaJm6i/RRDsNsGBKG9D19BSbY4a9FFakOrN1E5XdhZM2OHmxoHPdM96mfVBi+zpShxZIn+Jn1RWhvQvmKLgkXKW6HPExz0dPb+sZx9B6NkLvVCjxVTr/Uq3p1Ub3YSdYQlTX6pNodZumRzrTy6Y+9AxpD3eg7Js1FPOzoXrs33N7bciXLysyRL36MvA90uJyQ8IHyXMhK954qCBQ7JdY8lXXso30PRWDAPOdUwqz4kBufUrWQ5cMXrdbqNu/U8g5vTXm/bu/oarDNGw8YGrrwXGn9MjL/ToTi/ylmbvwQ==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df4e4329-ee24-4795-70df-08df283a6372
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Oct 2026 08:25:35.0534
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AOHzUuruSRU9XrPTjt8KTECKFmCGCM7DTYbWkhH0y00+ISnAmws766cV+OM5orYiacxKXWyFcob0oU7xje1Bh0IQDh+y6XOwbj36OyPUOGk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR02MB11036
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEyMDAzMyBTYWx0ZWRfX7CEi1DIb5cZG
 k9dxIgIvWtrljX65W0jnsOa7cED62KmLu22BQjLzW8M7SN08kdqQJTJFWJJMdOmO9UF8FGJdnaj
 g+WkQgnes0elkjggnsMN20tDmwQdLvnDeQ4OwX4j2AXIQit2tfVoGsyU8KoYFi3G8ZmRk69gWbg
 hZ2CoxvXrl66T3oz2hKbbtQRmFBR7xR/J/nJQEEMcyOc0GR7p+mi8RFfy2fEZSV7gRGCDAfudZX
 NxOC5WmFv4xXKKNwM/+kpnHUkdcFmK6HcxlX78SochYbxpNUuLf3yG5bxiru9plCfnKcLlbqK2P
 AWCXtH1fn43rUFUCuiNEI3k+WAzKc3pfRpdLLsKWuoI53UC7nkGi4TUHYohBh0StIi7rxeSMf3z
 vfjwl4rXYaifE9drAUwWwEvanVsQ56RMV6zzK7dwi13J/IG1X+c+H87D+0eIoJMV2JjmfoJ5ag2
 /sDl9V+GEYQnmqdoFmA==
X-Proofpoint-ORIG-GUID: cdvGtSW2chbgbELjns5nTcRDIFKV-QXd
X-Authority-Analysis: v=2.4 cv=eZ2o7LEH c=1 sm=1 tr=0 ts=6acc9982 cx=c_pps
 a=YMpgYF4YqoZtRZf0gxQL+w==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VofLwUrZ8Iiv6rRUPXIb:22 a=0LlEyIVc8U2lsR7dKhuH:22 a=20KFwNOVAAAA:8
 a=76DONOJ-3wu2KbdviDsA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: cdvGtSW2chbgbELjns5nTcRDIFKV-QXd
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEyMDAzMyBTYWx0ZWRfX5d9fi81yljMl
 iV08RWFutpV3ZLc7SGbdjiig7yqEc83D5yOj36vRu4yeYptukeX1+wH4B+ELlOS+Q4EFEBNf/Yv
 VVdyXS6/U8k5F/rL2rh9I2FtuYXKmFA=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-12_03,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gMTAgT2N0IDIwMjYsIGF0IDc6MDbigK9QTSwgRXJpYyBBdWdlciA8ZXJpYy5hdWdl
ckByZWRoYXQuY29tPiB3cm90ZToNCj4gDQo+ICEtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tfA0KPiAgQ0FVVElPTjogRXh0
ZXJuYWwgRW1haWwNCj4gDQo+IHwtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tIQ0KPiANCj4ga3ZtX2FybV9nZXRfaG9zdF9j
cHVfZmVhdHVyZXMoKSBhbHJlYWR5IHJldHJpZXZlcyB0aGUgdmFsdWVzIG9mIHNvbWUNCj4gaG9z
dCBpZCByZWdpc3RlcnMgdG8gYW5hbHl6ZSB0aGUgYXZhaWxhYmxlIHZjcHUgZmVhdHVyZXMuDQo+
IA0KPiBFdmVudHVhbGx5IHdlIHdhbnQgdG8gYmUgYWJsZSB0byBhbGxvdyB0aGUgdXNlciB0byBj
aGFuZ2UgdGhlIHZhbHVlDQo+IG9mIHdyaXRhYmxlIElEIHJlZyBmaWVsZHMuIFNvIHdlIG5lZWQg
dG8gc3RvcmUgdGhlIGluaXRpYWwgdmFsdWUgb2YgYWxsDQo+IHdyaXRhYmxlIElEIHJlZ3MgaW50
byBpc2FyLmlkcmVnc1tdLg0KPiANCj4gSW50cm9kdWNlIGEgbmV3IGdldF9ob3N0X2NwdV9pZHJl
Z3MoKSBoZWxwZXIgdGhhdCBwb3B1bGF0ZXMgaXNhci5pZHJlZ3NbXQ0KPiBhbmQgY2FsbCBpdCBm
cm9tIGt2bV9hcm1fZ2V0X2hvc3RfY3B1X2ZlYXR1cmVzLg0KPiANCj4gVGhpcyBwYXRjaCBoYXMg
bm8gaW1wYWN0IG9uIGNwcmVnIHZhbHVlcy4gaXNhci5pZHJlZ3NbXSBpcyBvbmx5DQo+IHVzZWQg
YXMgYSB0ZW1wb3Jhcnkgc3RvcmFnZSBmb3IgcmVnaXN0ZXIgdmFsdWVzIHRvIGJlIHVwZGF0ZWQg
aW4gcGxhY2UNCj4gbGF0ZXIuICBBbHNvIGl0IGRvZXMgbm90IGhhbmRsZSB0aGUgd3JpdGViYWNr
IG9mIGlzYXIuaWRyZWdzW10gaW50byBjcHJlZw0KPiB2YWx1ZSBsaXN0IGFmdGVyIHVzZXIgdXBk
YXRlLiBUaGlzIHdpbGwgYmUgaGFuZGxlZCBzZXBhcmF0ZWx5Lg0KPiANCj4gTm90ZSB0aGUgaG9z
dCB2YWx1ZXMgYXJlIHJldHJpZXZlZCBmcm9tIHRoZSBzY3JhdGNoIHZjcHUgaW5pdGlhbGl6ZWQg
d2l0aA0KPiBhbGwgdGhlIGF2YWlsYWJsZSBjYXBhYmlsaXRpZXMgZXhwb3NlZCBieSBLVk0sIGlu
ZGVwZW5kZW50bHkgb24gdGhlDQo+IGZpbmFsIHZjcHUgZmVhdHVyZXMgbWFkZSBieSB0aGUgdXNl
ciB0aHJvdWdoIHRoZSBsZWdhY3kgY29tcG9zaXRlDQo+IG9wdGlvbnMgc3VjaCBhcyBzdmUsIHBh
dXRoLCB2aXJ0dWFsaXphdGlvbiwgLi4uDQo+IA0KPiBBdCB0aGUgbW9tZW50LCB0aGUgb25seSBj
YWxsZXIgc2V0cyB3cml0YWJsZSB0byB0cnVlLiBOYW1lZCB2Y3B1IG1vZGVscw0KPiB3aWxsIHVz
ZSB0aGUgd3JpdGFibGU9ZmFsc2UgbW9kZS4gTm90ZSB0aGlzIHdpbGwgcmVxdWlyZSBzb21lIGV4
dHJhDQo+IGhhbmRsaW5nIGZvciBJRCByZWdzIHRoYXQgY2Fubm90IGJlIHJlYWQgZnJvbSBLVk0u
DQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBFcmljIEF1Z2VyIDxlcmljLmF1Z2VyQHJlZGhhdC5jb20+
DQo+IFNpZ25lZC1vZmYtYnk6IENvcm5lbGlhIEh1Y2sgPGNvaHVja0ByZWRoYXQuY29tPg0KPiAN
Cj4gLS0tDQo+IHY5IC0+IHYxMDoNCj4gLSBnZXQgcmlkIG9mIHNwdXJpb3VzIGt2bV9hcm1fd3Jp
dGFibGVfaWRyZWdzX3RvX2NwcmVnX2xpc3QgdHJhY2UgcG9pbnQNCj4gLSBhZGQgYSB3cml0YWJs
ZSBwYXJhbWV0ZXIgdG8gZ2V0X2hvc3RfY3B1X2lkcmVncw0KPiAtIHNvbWUgY29kZSBjbGVhbnVw
DQo+IA0KPiB2OCAtPiB2OToNCj4gLSBpbXByb3ZlIHRoZSBjb21taXQgbXNnLiBPbmx5IGluaXRp
YWxpemUgaW4gdGhpcyBwYXRjaCBhbmQgbW92ZSB0aGUNCj4gIHdyaXRlIGJhY2sgdG8gY3ByZWcg
dmFsdWUgbGlzdCBpbiBhIGRpZmZlcmVudCBwYXRjaC4NCj4gLSBEbyBub3QgaGFjayBDTElEUiBo
ZXJlLiBUaGUgY29ycmVjdCB3YXkgdG8gZml4IHRoYXQgdGVtcG9yYXJpbHkgaXMgdG8NCj4gIGRv
IHRoYXQgaW4gdGhlIG1hY2hpbmUgaW5zdGVhZC4NCj4gDQo+IHY3IC0+IHY4DQo+IC0gZml4IGlu
ZGVudCBhbmQgYWRkZWQgS2h1c2hpdCdzIFItYg0KPiANCj4gdjYgLT4gdjcNCj4gLSByZW1vdmUg
dmNwdSBmcm9tIHByb3RvdHlwZXMgKEtodXNoaXQpDQo+IA0KPiB2NSAtPiB2Ng0KPiAtIGRvIG5v
dCBjaGVjayB3cml0YWJsZV9tYXAgYW55bW9yZQ0KPiAtLS0NCj4gdGFyZ2V0L2FybS9rdm0uYyAg
ICAgICAgfCA0NCArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrLQ0KPiB0
YXJnZXQvYXJtL3RyYWNlLWV2ZW50cyB8ICAxICsNCj4gMiBmaWxlcyBjaGFuZ2VkLCA0NCBpbnNl
cnRpb25zKCspLCAxIGRlbGV0aW9uKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvdGFyZ2V0L2FybS9r
dm0uYyBiL3RhcmdldC9hcm0va3ZtLmMNCj4gaW5kZXggMmU2ODEzMDYxMS4uYWM0ZjMwNzI3NiAx
MDA2NDQNCj4gLS0tIGEvdGFyZ2V0L2FybS9rdm0uYw0KPiArKysgYi90YXJnZXQvYXJtL2t2bS5j
DQo+IEBAIC00Myw2ICs0Myw3IEBADQo+ICNpbmNsdWRlICJody9hY3BpL2doZXMuaCINCj4gI2lu
Y2x1ZGUgInRhcmdldC9hcm0vZ3RpbWVyLmgiDQo+ICNpbmNsdWRlICJtaWdyYXRpb24vYmxvY2tl
ci5oIg0KPiArI2luY2x1ZGUgImNwdS1pZHJlZ3MuaCINCj4gDQo+IGNvbnN0IEtWTUNhcGFiaWxp
dHlJbmZvIGt2bV9hcmNoX3JlcXVpcmVkX2NhcGFiaWxpdGllc1tdID0gew0KPiAgICAgS1ZNX0NB
UF9JTkZPKERFVklDRV9DVFJMKSwNCj4gQEAgLTMyOSw3ICszMzAsNDUgQEAgc3RhdGljIGludCBr
dm1fZmVhdHVyZV9pZHhfdG9faWRyZWdzX2lkeChpbnQga2lkeCkNCj4gICAgIHJldHVybiBnZXRf
c3lzcmVnX2lkeChzeXNyZWcpOw0KPiB9DQo+IA0KPiAtc3RhdGljIHZvaWQga3ZtX2FybV9nZXRf
aG9zdF9jcHVfZmVhdHVyZXMoQVJNSG9zdENQVUZlYXR1cmVzICphaGNmKQ0KPiArLyoNCj4gKyAq
IGdldF9ob3N0X2NwdV9pZHJlZ3M6IFJlYWQgYWxsIHRoZSBJRCByZWdpc3RlciB2YWx1ZXMgZnJv
bSBLVk0NCj4gKyAqIHZjcHUgZmQgYW5kIHBvcHVsYXRlIEBhaGNmLT5pc2FyLmlkcmVnc1tdIHdp
dGggdGhvc2UgdmFsdWVzDQo+ICsgKg0KPiArICogTmVlZCB0byBiZSBjYWxsZWQgb25jZSB0aGUg
d3JpdGFibGUgbWFzayBoYXMgYmVlbiBwb3B1bGF0ZWQNCj4gKyAqIGlmIEB3cml0YWJsZSBpcyBz
ZXQNCj4gKyAqDQo+ICsgKiBAZmQ6IHZjcHUgZmQNCj4gKyAqIEBhaGNmOiBBUk1Ib3N0Q1BVRmVh
dHVyZXMgd2hvc2UgQGFoY2YtPmlzYXIuaWRyZWdzW10gd2lsbCBiZQ0KPiArICogICAgICAgIHBv
cHVsYXRlZA0KPiArICogQHdyaXRhYmxlOiBpZiBzZXQsIG9ubHkgd3JpdGFibGUgSUQgcmVncyBh
cmUgcmVhZA0KPiArICovDQo+ICtzdGF0aWMgaW50IGdldF9ob3N0X2NwdV9pZHJlZ3MoaW50IGZk
LCBBUk1Ib3N0Q1BVRmVhdHVyZXMgKmFoY2YsIGJvb2wgd3JpdGFibGUpDQo+ICt7DQo+ICsgICAg
Zm9yIChpbnQgaSA9IDA7IGkgPCBOVU1fSURfSURYOyBpKyspIHsNCj4gKyAgICAgICAgQVJNNjRT
eXNSZWcgKnN5c3JlZ2Rlc2MgPSAmYXJtNjRfaWRfcmVnc1tpXTsNCj4gKyAgICAgICAgQVJNU3lz
UmVncyBzeXNyZWcgPSBpZF9yZWdpc3Rlcl9zeXNyZWdbaV07DQo+ICsgICAgICAgIHVpbnQ2NF90
ICpyZWc7DQo+ICsgICAgICAgIGludCByZXQ7DQo+ICsNCj4gKyAgICAgICAgaWYgKHdyaXRhYmxl
ICYmICFzeXNyZWdkZXNjLT53cml0YWJsZV9tYXNrKSB7DQo+ICsgICAgICAgICAgICBjb250aW51
ZTsNCj4gKyAgICAgICAgfQ0KPiArDQo+ICsgICAgICAgIHJlZyA9ICZhaGNmLT5pc2FyLmlkcmVn
c1tpXTsNCj4gKyAgICAgICAgcmV0ID0gcmVhZF9zeXNfcmVnNjQoZmQsIHJlZywgaWRyZWdzX3N5
c3JlZ190b19rdm1fcmVnKHN5c3JlZykpOw0KPiArICAgICAgICBpZiAocmV0KSB7DQpIaSBFcmlj
LA0KDQpXZSBzaG91bGQgaWdub3JlIEVOT0VOVCBlcnJvcnMgaGVyZS4NCg0KQWxzbywgV2hlbiB3
ZSByZWFkIHRoZSBmdWxsIHJlZ2lzdGVyIHNldCwgd2UgbmVlZCB0byB0YWtlIGNhcmUgb2YNCnNv
bWUgc3BlY2lhbCBjYXNlcywgbGlrZSBJIGRvIGluICh0YXJnZXQvYXJtL2t2bTogaGFuZGxlIHNw
ZWNpYWwgSUQNCnJlZ2lzdGVycyB3aGVuIHJlYWRpbmcgZnJvbSBLVk0pIChJIGNhbiBoYW5kbGUg
dGhpcyBpbiBteSBzZXJpZXMNCmlmIHlvdSBsaWtlKS4NCg0KQW55d2F5LCBmb3Igbm93LCB1c2lu
ZyBhIGxvY2FsIGNvbW1pdCBmb3IgdGhlIGZpcnN0IHBvaW50Lg0KDQpUaGFua3MsDQpLaHVzaGl0
DQoNCj4gKyAgICAgICAgICAgIGVycm9yX3JlcG9ydCgiJXMgZXJyb3IgcmVhZGluZyB2YWx1ZSBv
ZiBob3N0ICVzIHJlZ2lzdGVyICglbSkiLA0KPiArICAgICAgICAgICAgICAgICAgICAgICAgIF9f
ZnVuY19fLCBzeXNyZWdkZXNjLT5uYW1lKTsNCj4gKw0KPiArICAgICAgICAgICAgcmV0dXJuIHJl
dDsNCj4gKyAgICAgICAgfQ0KPiArICAgICAgICB0cmFjZV9nZXRfaG9zdF9jcHVfaWRyZWdzKHN5
c3JlZ2Rlc2MtPm5hbWUsICpyZWcpOw0KPiArICAgIH0NCj4gKyAgICByZXR1cm4gMDsNCj4gK30N
Cj4gKw0KPiArc3RhdGljIHZvaWQNCj4gK2t2bV9hcm1fZ2V0X2hvc3RfY3B1X2ZlYXR1cmVzKEFS
TUhvc3RDUFVGZWF0dXJlcyAqYWhjZikNCj4gew0KPiAgICAgLyogSWRlbnRpZnkgdGhlIGZlYXR1
cmUgYml0cyBjb3JyZXNwb25kaW5nIHRvIHRoZSBob3N0IENQVSwgYW5kDQo+ICAgICAgKiBmaWxs
IG91dCB0aGUgQVJNSG9zdENQVUNsYXNzIGZpZWxkcyBhY2NvcmRpbmdseS4gVG8gZG8gdGhpcw0K
PiBAQCAtNDE1LDYgKzQ1NCw5IEBAIHN0YXRpYyB2b2lkIGt2bV9hcm1fZ2V0X2hvc3RfY3B1X2Zl
YXR1cmVzKEFSTUhvc3RDUFVGZWF0dXJlcyAqYWhjZikNCj4gICAgICAgICBTRVRfSURSRUcoJmFo
Y2YtPmlzYXIsIElEX0FBNjRQRlIwLCAweDAwMDAwMDExKTsgLyogRUwxJjAsIEFBcmNoNjQgb25s
eSAqLw0KPiAgICAgICAgIGVyciA9IDA7DQo+ICAgICB9IGVsc2Ugew0KPiArICAgICAgICAvKiBN
YWtlIHN1cmUgYWxsIHdyaXRhYmxlIElEIHJlZyB2YWx1ZXMgYXJlIGluaXRpYWxpemVkICovDQo+
ICsgICAgICAgIGVyciB8PSBnZXRfaG9zdF9jcHVfaWRyZWdzKGZkLCBhaGNmLCB0cnVlKTsNCj4g
Kw0KPiAgICAgICAgIGVyciB8PSBnZXRfaG9zdF9jcHVfcmVnKGZkLCBhaGNmLCBJRF9BQTY0UEZS
MV9FTDFfSURYKTsNCj4gICAgICAgICBlcnIgfD0gZ2V0X2hvc3RfY3B1X3JlZyhmZCwgYWhjZiwg
SURfQUE2NFBGUjJfRUwxX0lEWCk7DQo+ICAgICAgICAgZXJyIHw9IGdldF9ob3N0X2NwdV9yZWco
ZmQsIGFoY2YsIElEX0FBNjRTTUZSMF9FTDFfSURYKTsNCj4gZGlmZiAtLWdpdCBhL3RhcmdldC9h
cm0vdHJhY2UtZXZlbnRzIGIvdGFyZ2V0L2FybS90cmFjZS1ldmVudHMNCj4gaW5kZXggODUwMmZi
MzI2NS4uOGM3ZmFmNTdjNyAxMDA2NDQNCj4gLS0tIGEvdGFyZ2V0L2FybS90cmFjZS1ldmVudHMN
Cj4gKysrIGIvdGFyZ2V0L2FybS90cmFjZS1ldmVudHMNCj4gQEAgLTEzLDYgKzEzLDcgQEAgYXJt
X2d0X3VwZGF0ZV9pcnEoaW50IHRpbWVyLCBpbnQgaXJxc3RhdGUpICJndF91cGRhdGVfaXJxOiB0
aW1lciAlZCBpcnFzdGF0ZSAlZCINCj4gDQo+ICMga3ZtLmMNCj4ga3ZtX2FybV9maXh1cF9tc2lf
cm91dGUodWludDY0X3QgaW92YSwgdWludDY0X3QgZ3BhKSAiTVNJIGlvdmEgPSAweCUiUFJJeDY0
IiBpcyB0cmFuc2xhdGVkIGludG8gMHglIlBSSXg2NA0KPiArZ2V0X2hvc3RfY3B1X2lkcmVncyhj
b25zdCBjaGFyICpuYW1lLCB1aW50NjRfdCB2YWx1ZSkgInNjcmF0Y2ggdmNwdSBob3N0IHZhbHVl
IGZvciAlcyBpcyAweCUiUFJJeDY0DQo+IA0KPiAjIGNwdS5jDQo+IGFybV9jcHVfcmVzZXQodWlu
dDY0X3QgbXBfYWZmKSAiY3B1ICUiIFBSSXU2NA0KPiAtLSANCj4gMi41My4wDQo+IA0KDQo=
