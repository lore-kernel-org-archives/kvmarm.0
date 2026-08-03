Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D6BE33C183
	for <kvmarm@lists.linux.dev>; Mon,  3 Aug 2026 15:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785772396; cv=fail; b=G+4JtbBeGwrD+jw4GsnWsdvA0bTqfO83yOlK1GU2koKAeWt+3anWyvm+6g4bpJhs5pY4S1TecjNlCcAgCMbAIvQWjjIV20A91hwi3w55vdr3J1JsVw1JWI2mrXrhjLnlRORsRIXDWXd5TVj0ZPIS9JdTBdjwkOgYIj2ogyhGo3w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785772396; c=relaxed/simple;
	bh=8v3nycEouxKEP+yLx4C/RJS4LmK6hACcAxPVB92U1ME=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=g67OV9npOUTBLYpXaFRXqx8YAAdWeRQTPfhgyCA5TQoGkBWs/H4KI4Mff9vGeiB1U89UTE6dAII6AQpJdkm2AJD8JsIxanXZ9t1fcEB3P0VFR4bmhM6tMxYrGLHYLEeiMnPTkBlJKhkcXVJo6joU177wUwDZQzr0WGivoviX+KQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=KZZJeYOw; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=LXO4TmeL; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="KZZJeYOw";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="LXO4TmeL"
Received: from pps.filterd (m0127840.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 673EHuNg1504543;
	Mon, 3 Aug 2026 08:48:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=8v3nycEouxKEP+yLx4C/RJS4LmK6hACcAxPVB92U1
	ME=; b=KZZJeYOwnd0tRnPg/ipxjchuURVaBwzPiNHtlcTAuRvZhsQCgMdjo5NWy
	F/bXbxaljYpu2LV69ev3oTCdEMoLNZp2kymBONUBWoEjIHmdrKWRbLykQDsuxNIt
	1svBPa6hzj9snrS4TY/7uaZjiQi8IMbkn6/VE+zMj77+CU7nd34BIz4axm2mOGor
	4lXORRwOrhuIIbMw52EWLuOScwYJhO/MnvDR1qyN9L5Zrcn2+CsTD89vtp+pM6RR
	QGPEh4PwST73AJh9zmwSCgC4382vWm/MDhuO9KohaTGYwbVA7TCvgrLxKzdsXd7V
	fUyk9jN6MqpMk0izEPoHmlPc2rtEQ==
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11022125.outbound.protection.outlook.com [40.93.195.125])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4fsd4sm1vb-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 03 Aug 2026 08:47:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Jb+PV98W97Rih3BkIa63JJoojaRWwwmOCI+89XatC56qgkBirijj6ueg1dkyleRpkimhzpoTD6kKpR331aR7QYFc7pC/OhBBuiRSoWhZHjRkz8cItd/bZVJSPq6s216l9JxIZ95R0YQdyycdl/svcfHh9C1sbO1BRJWUPFOZrXAGWkWEECg6ZY3mkGa8nNIIiegq+uRYxs/9EUwiewDdfBFCChN9PwVOtID+LpWuW7tr+2xh96Mk0oybAb7LOZ232ipHah+uGU4AGYkDuY78/xz0nmx5a0W9WGr5sJ/0GuRXqM20APaR16EdVr5Yg+cL2OBdvtQiUO0T9lg8AzxiMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8v3nycEouxKEP+yLx4C/RJS4LmK6hACcAxPVB92U1ME=;
 b=y++p9r27QD3kgrr4AXOzV//kehNv3HrOoQ+32kgJl5bKtw5XqybZ+b1XdKSic+WjLFCk0I0t2HizfKW4GHeSKf+sd3u5bAR+owWz2vAENsg8zw/9f5TDT9IRrBJRYoXHb9bX7iXEcpgxSbx8zGF9e4QtHkh1TGSdU080hhigzLd1f7L4ygspH8ipe2DB5oi4YQzcT6SHH4OQdANVJyLIamRU6Jz1apPDtFoWCRfgE+/VXK1YcFIDhebm2dWFVvqsbirwHY9f5mhf0jio21Gd3mnPaXcC7z4r1gN5ttBV2wvCue/y3CLW6wMx7BcNHGNyyWf1KJEpAXxaGnMiU/1/3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8v3nycEouxKEP+yLx4C/RJS4LmK6hACcAxPVB92U1ME=;
 b=LXO4TmeLHzJ4ythWW8b0ZLjZ+/Jg721PPTpnZDX+GhtAeRiTwIILADNVDR75uE0UvdeZ6uy7/Zs4dyEOwtUnJzuYm6SQj++EyQW6XExVsUY1mZaCoIIDBtfyHJeyg2XDiU9ZnmVmHjU4tWo7ZjVBZt8KyBK/jS3PpDMR5rQYWfde/rVjjjcJGq19gDuHuNKD6pvE32KuSZPKRmcZr1P/QFoVZdXW4NzDKNKarHqO3Qt+OavBZnLpx3VbPvYbeIHeizzEBJfsvIOtudwLBwYQvPv1Y0LYDp9CIsSCMbstRdum7aLuv2sww1ta2orsUx6hjxCy8oei2bdD2+5dIOwp/A==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by MWHPR02MB10353.namprd02.prod.outlook.com (2603:10b6:303:285::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.17; Mon, 3 Aug
 2026 15:47:53 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%5]) with mapi id 15.21.0270.016; Mon, 3 Aug 2026
 15:47:53 +0000
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
        Prerna Saxena <prerna.saxena@nutanix.com>
Subject: Re: [RFC PATCH v3 06/19] target/arm/kvm: Read all ID registers from
 KVM
Thread-Topic: [RFC PATCH v3 06/19] target/arm/kvm: Read all ID registers from
 KVM
Thread-Index: AQHdFWuWbj9h1nAzYEq1zR8lsJZlvrZ5IxKAgBNw7QA=
Date: Mon, 3 Aug 2026 15:47:53 +0000
Message-ID: <3F04531C-A7FB-4877-9AEE-9CE2E5729089@nutanix.com>
References: <20260716213858.609699-1-khushit.shah@nutanix.com>
 <20260716213858.609699-7-khushit.shah@nutanix.com>
 <980b8a5e-2c9f-4a7b-8014-15cc96831cf0@redhat.com>
In-Reply-To: <980b8a5e-2c9f-4a7b-8014-15cc96831cf0@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA2PR02MB7564:EE_|MWHPR02MB10353:EE_
x-ms-office365-filtering-correlation-id: b0c6c1b5-7693-4179-956c-08def1769462
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|23010399003|7416014|376014|1800799024|38070700021|6133799003|4143699003|56012099006|10067099003|22082099003|18002099003|3023799007;
x-microsoft-antispam-message-info:
 6/kevhfGsIbwy7jDURhI4C3hHYyRM1/X65ZxPxh56nxQ5j4lD9bkZMzAxM6iyCzuXDb8HdvnOCzuhQ4+gRYzq7WA2jkJL+p13qACypX+75xXHrva3R1jHBZWy7QurbgfmC9FC6Ev4z4GHq02zwXOyitDnmNBnetMZqrm4mh1oFAXSQPeP64ocVGYk/1aXfwRSjrbidorVDHmPhUUlJwr3+nroLHtR6soGnYZ/4UPJhqSbwLqR3JgiAQvoy/b8/oiCfIYz4W3y2qe58DwzJRi0KWYPjw+29VDeoiD+oxHQQxN0SkPZjJAOiO4+kcUTkYbUPTKaf0h0eJZOSVwN5LjRsKisjsA75XCjPT6pK/zGKqocijvJQT6X4GbPtKBUs6i/DFpMAQI54z1v4fgD8Eour2/L74jeDXQDsGk/yGN6UWAEBXn0OzMW5+JAzjd0OjITDaiFdjhX7gWrJNPoB3cI5OKhKuTN5RCsaxN+efmRyauqR8SZSs5q3kp13AuRqb0j/VfZpxmFp2gUBjgr2jd/ck+prMrP+yvEWQ9tpGTVsZE2wdhg/c8tzsPare+OWNbOsDY++IREorW6eI3wGFhZwqLLPyNjwdGxRPFKIDKrejegETFDKy5woGSHgnf01iw/7E5QpsQE2+kt8QcUSkfYYsZPV6PKFz8VI1dvvpB+t8rVQXfYZmdjW2T9jLuZQUtcaX2GDOYpbMtCbhx6Euu+J7f0WLawjzmOsTUVaKFrPY=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(7416014)(376014)(1800799024)(38070700021)(6133799003)(4143699003)(56012099006)(10067099003)(22082099003)(18002099003)(3023799007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?OHZHWW9DZ3lWZ3Vhem9nV1U4b1ByNDI2RDlTVDl0cXdyTHJWbWNHYnI0L21q?=
 =?utf-8?B?aUlSSDhBVFN0OUFNcCtuS0JvbmVOcStpL1VJc1JNOE85Ukp1WW1Iby9xWExS?=
 =?utf-8?B?RWJHSUpvVVVrWVdFWXJhQ1NvSEZiRFV5dll1SVhJWnQyWU1KTTBOckJkUGxH?=
 =?utf-8?B?UCtDRVFqVmN6YUNWdHVKYURQU3dQTmNacklLbmdKcDBJQ0VVRzJJbUZlcVlT?=
 =?utf-8?B?VjBOTGc3eUoxZ0ljc0Q0S01KU2dibnpOc1JNNFYzd0xWcTdUbGhZZStSZDls?=
 =?utf-8?B?Z3RhR1NmZUxOc1paVUE0Ym54V25kRDZwQ2tWcjZqdGh4ZUQydVBiUCt5aVdk?=
 =?utf-8?B?OFgwRHBXdHJuUzBaSlhVcE1QNDRXcmN5QUxoSEtOdFY5NDBHYUgwd3Q0dExL?=
 =?utf-8?B?Z2w2ZnJocU1LNUh3S1luem12ek9wMkFHSjlaNEl6Wm1TQmxqMVkxUHhVU2lp?=
 =?utf-8?B?akI4RUlEbkR4bmh2MWp3UllKSjBpMmhnTGlJVEFacWVBUnJSWHJQWmJMcjdI?=
 =?utf-8?B?OUFmallYMVFPM0llWklJMHd0Z0hSbkhEYnBwMnBNaDVtTzdQeTIyZVpxeCtr?=
 =?utf-8?B?QkQ3L3E1a2xqdHJuVmZKTG1YcUdkL3RQdDYrZGpRQTFmTXltT01mVmNEdHFP?=
 =?utf-8?B?b2ZFRUVKN3ppdU5Gd1hqUlIrV1gzNHcxbWNNbzk2ZDIrUUp6b0kyT1N1TmJD?=
 =?utf-8?B?WlF0WTg3OVIvMW14WmtPek9XSTAxdkdwUEN4TjJyVy9hNEFsM2xZT1AwM2ZF?=
 =?utf-8?B?NWVaZGNJRUw5cjcwOWM4TjRyQXFmVm5XU3NlMWpyTGx3dURkc0piakx1bHBS?=
 =?utf-8?B?MUdNY1QrVTNzRzV3WHVUZUVnS2s0QVlxUXI2QURadVFxclVIUFFQL0RrRm1i?=
 =?utf-8?B?NWo2V0tmRjhaNVVCV0FvTjByMlZOUll0ZW9Ma1k1VWtGb2lPby82RURSTlBv?=
 =?utf-8?B?NG1EQjB6UnpobXljZUQ0U3E5TzRPbmVTQ3NHblJKeWYrK3V3VzNVZDF0bHBL?=
 =?utf-8?B?ZDBNWU5xT0tlWEE2ZXZ3V0NyWEN5L2VxQXl5Y1llbG85MU1ZdXZHdTNyOUdN?=
 =?utf-8?B?WTd3NEgxSmtVUXBpaG9oa2k5Z29MR0F6cG1JNmpNM1hMYzdzRldlRlpYNWJr?=
 =?utf-8?B?S2FFbmRnK3hoeUZoVHNCMGhJZ2U0UjBYT0xFYmRYbDd4NGwvZDg0aHFyVkVi?=
 =?utf-8?B?a2NZSkpHMDVMOFJDSzJOZ0kwNWEvQTBseHVicEFKbWx1TmNlVWQ5SHlQaVdu?=
 =?utf-8?B?WUN4VzN0cUNpTFJqeFRzN3g4T21PSnQ5Qm1YVjdkalM5c0R3NVpyUjkrZ3kw?=
 =?utf-8?B?STRlVWhKWDJrdzFZQlZhTmd6eHIzVC83TUlUUTBCVk9TYi9nZ1FwbnVTSU9q?=
 =?utf-8?B?YzBIRUlDV1ZlZGN1QWkvVzBaM3pnQytGSGo2TVAzVDl2SDBhczA1WkI5Zm9G?=
 =?utf-8?B?YjAzZ2dIT1JlQ2ZiMWxwcVhyYW9GSFNaSEJkelU5ZzdnWTJzcHZsOVZ1OFIv?=
 =?utf-8?B?dzJDODFvM0dQeGpKNVRHaUdsSFh0N1hmTEdmdVZmbWVrNjRmL0RTbjJsWVlG?=
 =?utf-8?B?T1BBOHQ3NzBvaUlEbmd0ZklyOVZTUGxsU29iVVBGcEVnU0lMMnNUdmcyQTJ3?=
 =?utf-8?B?U0xmTDM2UkJxWnVyanNrKzh5Q25zaXZuV29VeHJIeXNQTXRGYXRXWlYwL29F?=
 =?utf-8?B?ckY1eG1tR2VFVTJBamtFRVF2Y0U0U3RZWE9TWnJ2OXNZOFN2S1dHd2lhRzFU?=
 =?utf-8?B?MHE2eE1Rd0hWNkVkSGdrQzdqTzRkdFhnSEpzZXFYQmV4MlZwVEU3RGk0OXIz?=
 =?utf-8?B?N1pNWGZNWllnZ0hYMlc2NndyamNuTE5SRkRzSVVMZUo4RklJOGpYVjR6ZjQ3?=
 =?utf-8?B?aWVVSHhRTmZhS2xqcW9IQ1pSWGRUeXVobm1IdG1kKzlJZ2cvdXZiSG5OMkk4?=
 =?utf-8?B?dlZyb2paTVRhQ0JlSnRjZ252OFM3dkRLcllMZmJFWjh6eHM3SjFnbUwycWNj?=
 =?utf-8?B?YW1oMUkwa29vVVFCNU1CZGFENndvNXJIY0ZFc1h3ODJ2OGIwWWdIV1pvZURv?=
 =?utf-8?B?NWp1bFdUMmlzenVvMGtoSFRiS25velF0UGdQTTNYVXpSZUZsME5SUXo4eE1K?=
 =?utf-8?B?bVJ5SEc4RHptQ29GNkc4OExrMDhoUi80Tm1uYTRFWEdVbkVLQ2N3YUpSTjU4?=
 =?utf-8?B?R3FsTktqNnNBSXUrRis0UTlVS1YzcEhzdjFtZ0VDR3VZWjNxZXoycjZIYWh2?=
 =?utf-8?B?SUxjTE56TmRFSWwvQlk0OS9vL2RwMk50U0FQNlFDT2EvdlAxN3JHSmJ2OWRP?=
 =?utf-8?B?bC9oMTBwYXdzdkhsMFlVUE5oeFU4SGlzV0ZtMzEyeC8rdytTd1FvQU9jNDUx?=
 =?utf-8?Q?vt8LdWvTaqClaz8c=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1DEC4AB1EE37D941BE33AB2A91AB4BC8@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	J9Q3GBmGgUJjCAsj756mLkaQMi0FJ+PmdHBy8++yhil+i7kQWqpW4nr1HQnTQVbewugdkNv/rDA5F3/SZ+QkdG4Hl3cLiik4D4WINJGGLbdcG++ok52eVRJ2FHXz6sNMv9tAMZb6oojSCuP95maYEzKgKtSQqGwC3TFTMF0Znv1jt4g4u/umePjnunV60scY3Mw0MUQQ2jK9Y6VDCkY5UOWINAvfG4ifZi3mVjzAYnb2quDbgNiTcBD2b4aE4V8wzZBfESsvX6WmdIpUryF9COHnaPOkhuysqDn6jNjn5XoQdiW5cEdEj11GK8szmhrQAHFqT81zRYl0jvp+v831ZA==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0c6c1b5-7693-4179-956c-08def1769462
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Aug 2026 15:47:53.0843
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FHMQkTmxYtG/dM8vhIbbTjxWOeAfkaZUB8YFFhWfCntEJOKTZMiLOc3pChFiHmg1wDHbxlnF9ErP09bNid1eW44LCRNL0pLFU+356P0bU/I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR02MB10353
X-Proofpoint-ORIG-GUID: 1pWdYInao3ulnnP2RFld-8w5liG5Wk5o
X-Proofpoint-Spam-Info: AW1haW4tMjYwODAzMDE0MSBTYWx0ZWRfX+dMM/Q6jx+Rq
 3nST/5yywMNvG5baUad0+YYUpRsoFCgGhYuuVp7tPemO5HXjNxQFkZNk6CXm35RvSBDC5ZnfTP2
 HjzWzcIiIcvo8jmcDImB68xr1tuVO20=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODAzMDE0MSBTYWx0ZWRfX971iOteNF6BD
 qWAEnnw8YaMaAZKt2kPdck9UBUTSF3ugZIFeD5VBCHFOMGTupnVPLSyaTAIN2yh5zKTxwhEN+KN
 7jZBV5N2v40aUCgX6LH4z7qiLwwzkPwnWBQ/Soo37/c2R6lukq7oIdHFT4ZxJFnSMjyGurQJaiF
 crv7Qhefz+87bgMePgDyYAykuV1GLz3Aq4t76sJYik0DNKY/V57PT5+VZ2C8OHK4zD8ZmweuYPE
 4UD45POPVVmHk8MT2Qnu3qOxj/b79NlA1KGonOAUxk38Vk3hgkRRbAKi+mh43qwEFkANpKyiv7M
 KFV4HAuPFEKc6z9puPwGo/8SEJqBTeTOqlSn6Rytzxmk3IoV6tTvDdXEe/RjehBF/ZwhzC3vHpm
 t66uR+rZ1DGwIhsEYhaIGNLIIuLEE6hD/Huq3K7d71+0c+VZLpnHRQszawCtICiY+Pus2NXzJRl
 Rxz2Ap2lfL1Foy/mV1w==
X-Proofpoint-GUID: 1pWdYInao3ulnnP2RFld-8w5liG5Wk5o
X-Authority-Analysis: v=2.4 cv=YOuvDxGx c=1 sm=1 tr=0 ts=6a70b82f cx=c_pps
 a=Cjv2mA+u7YWQeGlDvlytMQ==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Sv0fKeRqtYgA:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VofLwUrZ8Iiv6rRUPXIb:22 a=_-M8LpHI31CeLmyZm6wg:22 a=20KFwNOVAAAA:8
 a=64Cc0HZtAAAA:8 a=GAUgpH38FEuhcPahyh4A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-03_03,2026-08-03_02,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gMjIgSnVsIDIwMjYsIGF0IDEyOjI04oCvUE0sIEVyaWMgQXVnZXIgPGVyaWMuYXVn
ZXJAcmVkaGF0LmNvbT4gd3JvdGU6DQo+IA0KPiAhLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLXwNCj4gIENBVVRJT046IEV4
dGVybmFsIEVtYWlsDQo+IA0KPiB8LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLSENCj4gDQo+IA0KPiANCj4gT24gNy8xNi8y
NiAxMTozOCBQTSwgS2h1c2hpdCBTaGFoIHdyb3RlOg0KPj4gVHJ5IHRvIHJlYWQgYWxsIHRoZSBJ
RCByZWdpc3RlcnMgZnJvbSBLVk0uIEtWTSBtYXkgcmV0dXJuIEVOT0VOVCwgZm9yDQo+PiBJRCBy
ZWdpc3RlcnMgaXQgZG9lcyBub3Qgc3VwcG9ydCByZWFkaW5nIGZyb20gdXNlcnNwYWNlLiBJZ25v
cmUgdGhvc2UNCj4+IHJlZ2lzdGVycy4gQXMgdGhpcyBsaXN0IGlzIHNtYWxsLCBpbiBmdXR1cmUg
d2UgbWF5IGFueXdheSB3YW50IHRvDQo+PiBoYW5kbGUgdGhvc2UgcmVnaXN0ZXIgc3BlY2lhbGx5
Lg0KPj4gDQo+PiBXZSB3YW50IHRvIGRvIHRoaXMgc28gdGhhdCB3ZSBjYW4gZXhwb3NlIG1vcmUg
b3IgbGVzcyBjb21wbGV0ZQ0KPj4gaG9zdCBmZWF0dXJlIHZpZXcgdG8gbWFuYWdlbWVudCBzdGFj
aywgYXMgZm9yIG1pZ3JhdGlvbiwgd2Ugd2FudCBib3RoDQo+PiB3cml0YWJsZSBhbmQgbm9uLXdy
aXRhYmxlIElEIHJlZ2lzdGVycyB0byBtYXRjaC4NCj4+IA0KPj4gQWxzbyByZW1vdmUgdGhlIHVu
dXNlZCAnY3B1JyBhcmdzIHRocm91Z2hvdXQgdGhlIGNhbGwtY2hhaW4uDQo+IEkgd2lsbCBpbnRl
Z3JhdGUgdGhpcyBmaXggaW4gdGhlIHBhcmVudCBzZXJpZXMNCg0KQWNrZWQuDQoNCj4+IA0KPj4g
U2lnbmVkLW9mZi1ieTogS2h1c2hpdCBTaGFoIDxraHVzaGl0LnNoYWhAbnV0YW5peC5jb20+DQo+
PiAtLS0NCj4+IHRhcmdldC9hcm0va3ZtLmMgfCAzOCArKysrKysrKysrKysrKysrKysrLS0tLS0t
LS0tLS0tLS0tLS0tLQ0KPj4gMSBmaWxlIGNoYW5nZWQsIDE5IGluc2VydGlvbnMoKyksIDE5IGRl
bGV0aW9ucygtKQ0KPj4gDQo+PiBkaWZmIC0tZ2l0IGEvdGFyZ2V0L2FybS9rdm0uYyBiL3Rhcmdl
dC9hcm0va3ZtLmMNCj4+IGluZGV4IDYzYjM3MjdlMDUuLjQyZmY3MzFmNmUgMTAwNjQ0DQo+PiAt
LS0gYS90YXJnZXQvYXJtL2t2bS5jDQo+PiArKysgYi90YXJnZXQvYXJtL2t2bS5jDQo+PiBAQCAt
MjkyLDE0ICsyOTIsMTQgQEAgc3RhdGljIGludCBrdm1fZmVhdHVyZV9pZHhfdG9faWRyZWdzX2lk
eChpbnQga2lkeCkNCj4+IH0NCj4+IA0KPj4gLyoNCj4+IC0gKiBnZXRfaG9zdF9jcHVfaWRyZWdz
OiBSZWFkIGFsbCB0aGUgd3JpdGFibGUgSUQgcmVnIGhvc3QgdmFsdWVzDQo+PiArICogZ2V0X2hv
c3RfY3B1X2lkcmVnczogUmVhZCBhbGwgdGhlIElEIHJlZyBob3N0IHZhbHVlcw0KPj4gICoNCj4+
IC0gKiBOZWVkIHRvIGJlIGNhbGxlZCBvbmNlIHRoZSB3cml0YWJsZSBtYXNrIGhhcyBiZWVuIHBv
cHVsYXRlZA0KPj4gLSAqIE5vdGUgd2UgbWF5IHdhbnQgdG8gcmVhZCBhbGwgdGhlIGtub3duIGlk
IHJlZ3MgYnV0IHNvbWUgb2YgdGhlbSBhcmUgbm90DQo+PiAtICogd3JpdGFibGUgYW5kIHJldHVy
biBhbiBlcnJvciwgaGVuY2UgdGhlIGNob2ljZSBvZiByZWFkaW5nIG9ubHkgdGhvc2Ugd2hpY2gN
Cj4+IC0gKiBhcmUgd3JpdGFibGUuIFRob3NlIGFyZSBhbHNvIHJlYWRhYmxlIQ0KPj4gKyAqIFdl
IGN1cnJlbnRseSB0cnkgdG8gcmVhZCBhbGwgdGhlIHJlZ2lzdGVycy4gSWYgdGhlIHJlYWQgZmFp
bHMgd2l0aA0KPj4gKyAqIEVOT0VOVCAoS1ZNIGRvZXMgbm90IGlkZW50aWZ5IHRoZSBJRCByZWdp
c3RlcikgaWdub3JlIGl0Lg0KPj4gKyAqIFNvbWUgb2YgdGhlIHJlZ2lzdGVycyB0aGF0IGVycm9y
ZWQgd2l0aCBFTk9FTlQgd2lsbCBhbnl3YXkgbmVlZCBzcGVjaWFsDQo+PiArICogaGFuZGxpbmcu
DQo+PiAgKi8NCj4+IC1zdGF0aWMgaW50IGdldF9ob3N0X2NwdV9pZHJlZ3MoQVJNQ1BVICpjcHUs
IGludCBmZCwgQVJNSG9zdENQVUZlYXR1cmVzICphaGNmKQ0KPj4gK3N0YXRpYyBpbnQgZ2V0X2hv
c3RfY3B1X2lkcmVncyhpbnQgZmQsIEFSTUhvc3RDUFVGZWF0dXJlcyAqYWhjZikNCj4+IHsNCj4+
ICAgICBpbnQgZXJyID0gMDsNCj4+ICAgICBpbnQgaTsNCj4+IEBAIC0zMTAsMjYgKzMxMCwyNiBA
QCBzdGF0aWMgaW50IGdldF9ob3N0X2NwdV9pZHJlZ3MoQVJNQ1BVICpjcHUsIGludCBmZCwgQVJN
SG9zdENQVUZlYXR1cmVzICphaGNmKQ0KPj4gICAgICAgICB1aW50NjRfdCAqcmVnOw0KPj4gICAg
ICAgICBpbnQgcmV0Ow0KPj4gDQo+PiAtICAgICAgICBpZiAoIXN5c3JlZ2Rlc2MtPndyaXRhYmxl
X21hc2spIHsNCj4+IC0gICAgICAgICAgICBjb250aW51ZTsNCj4+IC0gICAgICAgIH0NCj4+IC0N
Cj4+ICAgICAgICAgcmVnID0gJmFoY2YtPmlzYXIuaWRyZWdzW2ldOw0KPj4gICAgICAgICByZXQg
PSByZWFkX3N5c19yZWc2NChmZCwgcmVnLCBpZHJlZ3Nfc3lzcmVnX3RvX2t2bV9yZWcoc3lzcmVn
KSk7DQo+PiAtICAgICAgICB0cmFjZV9nZXRfaG9zdF9jcHVfaWRyZWdzKHN5c3JlZ2Rlc2MtPm5h
bWUsICpyZWcpOw0KPj4gICAgICAgICBpZiAocmV0KSB7DQo+PiAtICAgICAgICAgICAgZXJyb3Jf
cmVwb3J0KCIlcyBlcnJvciByZWFkaW5nIHZhbHVlIG9mIGhvc3QgJXMgcmVnaXN0ZXIgKCVtKSIs
DQo+PiAtICAgICAgICAgICAgICAgICAgICAgICAgIF9fZnVuY19fLCBzeXNyZWdkZXNjLT5uYW1l
KTsNCj4+IC0NCj4+IC0gICAgICAgICAgICBlcnIgPSByZXQ7DQo+PiArICAgICAgICAgICAgaWYg
KGVycm5vID09IEVOT0VOVCkgew0KPj4gKyAgICAgICAgICAgICAgICB3YXJuX3JlcG9ydCgiJXMg
ZXJyb3IgcmVhZGluZyB2YWx1ZSBvZiBob3N0ICVzIHJlZ2lzdGVyICINCj4+ICsgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICIoRU5PRU5UKSIsIF9fZnVuY19fLCBzeXNyZWdkZXNjLT5u
YW1lKTsNCj4gaWYgdGhlcmUgYXJlIGV4cGVjdGVkIGNhc2VzIHdoZXJlIHRoZSByZWFkIGlzIGZh
aWxpbmcgSSBkb24ndCB0aGluayB3ZQ0KPiB3YW50IHRvIHdhcm4uIEFkZCBhIHRyYWNlIHBvaW50
IGluc3RlYWQuDQoNCkFja2VkLCB3aWxsIGNoYW5nZSB0byB0cmFjZXBvaW50IGluIHY0Lg0KDQo+
PiArICAgICAgICAgICAgfSBlbHNlIHsNCj4+ICsgICAgICAgICAgICAgICAgZXJyb3JfcmVwb3J0
KCIlcyBlcnJvciByZWFkaW5nIHZhbHVlIG9mIGhvc3QgJXMgcmVnaXN0ZXIiDQo+PiArICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICIgKCVtKSIsIF9fZnVuY19fLCBzeXNyZWdkZXNjLT5uYW1l
KTsNCj4+ICsgICAgICAgICAgICAgICAgZXJyID0gcmV0Ow0KPj4gKyAgICAgICAgICAgIH0NCj4+
ICAgICAgICAgfQ0KPj4gKyAgICAgICAgdHJhY2VfZ2V0X2hvc3RfY3B1X2lkcmVncyhzeXNyZWdk
ZXNjLT5uYW1lLCAqcmVnKTsNCj4+ICAgICB9DQo+PiAgICAgcmV0dXJuIGVycjsNCj4+IH0NCj4+
IA0KPj4gDQo+PiBzdGF0aWMgdm9pZA0KPj4gLWt2bV9hcm1fZ2V0X2hvc3RfY3B1X2ZlYXR1cmVz
KEFSTUNQVSAqY3B1LCBBUk1Ib3N0Q1BVRmVhdHVyZXMgKmFoY2YpDQo+PiAra3ZtX2FybV9nZXRf
aG9zdF9jcHVfZmVhdHVyZXMoQVJNSG9zdENQVUZlYXR1cmVzICphaGNmKQ0KPj4gew0KPj4gICAg
IC8qIElkZW50aWZ5IHRoZSBmZWF0dXJlIGJpdHMgY29ycmVzcG9uZGluZyB0byB0aGUgaG9zdCBD
UFUsIGFuZA0KPj4gICAgICAqIGZpbGwgb3V0IHRoZSBBUk1Ib3N0Q1BVQ2xhc3MgZmllbGRzIGFj
Y29yZGluZ2x5LiBUbyBkbyB0aGlzDQo+PiBAQCAtNDE1LDggKzQxNSw4IEBAIGt2bV9hcm1fZ2V0
X2hvc3RfY3B1X2ZlYXR1cmVzKEFSTUNQVSAqY3B1LCBBUk1Ib3N0Q1BVRmVhdHVyZXMgKmFoY2Yp
DQo+PiAgICAgICAgIFNFVF9JRFJFRygmYWhjZi0+aXNhciwgSURfQUE2NFBGUjAsIDB4MDAwMDAw
MTEpOyAvKiBFTDEmMCwgQUFyY2g2NCBvbmx5ICovDQo+PiAgICAgICAgIGVyciA9IDA7DQo+PiAg
ICAgfSBlbHNlIHsNCj4+IC0gICAgICAgIC8qIE1ha2Ugc3VyZSBhbGwgd3JpdGFibGUgSUQgcmVn
IHZhbHVlcyBhcmUgaW5pdGlhbGl6ZWQgKi8NCj4+IC0gICAgICAgIGVyciB8PSBnZXRfaG9zdF9j
cHVfaWRyZWdzKGNwdSwgZmQsIGFoY2YpOw0KPj4gKyAgICAgICAgLyogVHJ5IHRvIHJlYWQgYWxs
IHRoZSBJRCByZWdpc3RlcnMgKi8NCj4+ICsgICAgICAgIGVyciB8PSBnZXRfaG9zdF9jcHVfaWRy
ZWdzKGZkLCBhaGNmKTsNCj4+IA0KPj4gICAgICAgICAvKg0KPj4gICAgICAgICAgKiB0ZW1wb3Jh
cmlseSBvdmVycmlkZSB0aGUgQ0xJRFJfRUwxIHZhbHVlIHNpbmNlIHNvbWUgaG9zdCB2YWx1ZXMN
Cj4+IEBAIC01OTUsNyArNTk1LDcgQEAgdm9pZCBrdm1fYXJtX3NldF9jcHVfZmVhdHVyZXNfZnJv
bV9ob3N0KEFSTUNQVSAqY3B1KQ0KPj4gICAgIGdfZnJlZSh3cml0YWJsZV9tYXApOw0KPj4gDQo+
PiAgICAgaWYgKCFhcm1faG9zdF9jcHVfZmVhdHVyZXMuZHRiX2NvbXBhdGlibGUpIHsNCj4+IC0g
ICAgICAgIGt2bV9hcm1fZ2V0X2hvc3RfY3B1X2ZlYXR1cmVzKGNwdSwgJmFybV9ob3N0X2NwdV9m
ZWF0dXJlcyk7DQo+PiArICAgICAgICBrdm1fYXJtX2dldF9ob3N0X2NwdV9mZWF0dXJlcygmYXJt
X2hvc3RfY3B1X2ZlYXR1cmVzKTsNCj4+ICAgICB9DQo+PiANCj4+ICAgICBjcHUtPmt2bV90YXJn
ZXQgPSBhcm1faG9zdF9jcHVfZmVhdHVyZXMudGFyZ2V0Ow0KPiBUaGFua3MNCj4gDQo+IEVyaWMN
Cg0KDQo=
