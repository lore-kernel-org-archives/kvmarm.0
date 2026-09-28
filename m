Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C6ED49CF22
	for <kvmarm@lists.linux.dev>; Mon, 28 Sep 2026 13:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790602037; cv=fail; b=Sv9fH6rYvpijjNq1c5ioRfEKf+oZ8fSwcakt2GIxyIOrDdoMeCufYehYqBKE861ONcGzaQ07/EEyI24+nRtwRV9F0uEwW3V9rkynowo0UF4ezUOp8bWgw2WbUxq20+EuHeTxTP4+ejPlB77Jg83osC/1k+/D+XqmDswnj6Ucuqk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790602037; c=relaxed/simple;
	bh=2e66Q7kqMK/lAB4OyxwKuEP91AgnGxk1TPK0uGbF4wo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=TszHAeqjnM+tvrFBxctVgJXa+WE9oHahXHLYxwaW4Dn0J4cmhnzXdoPqUdbEmp2Suiyn2yGCU/gGC+I1LTlurvwqu0Kmcrp8bgIxG6iK9pbuvuUOSDDGX88OcnKdo8Yth6BK6nBd7EO3vr/ZbmoA8V+zbr/3NvruoemTPOiKww8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=bJAYhbu7; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=VjsEXQpS; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="bJAYhbu7";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="VjsEXQpS"
Received: from pps.filterd (m0127843.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68SBBHD41505552;
	Mon, 28 Sep 2026 06:27:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=2e66Q7kqMK/lAB4OyxwKuEP91AgnGxk1TPK0uGbF4
	wo=; b=bJAYhbu7k5TRcjCoe6IYzUUVQtfE+nPjOLhDc/7AiwempAIJoK9D2Tl97
	u4RUA2gRbDi0BVWQZRg7Ya4ikUuEVQm9W8tM4eNZOOVRmFryWCOz4adhsW/F0mqd
	yv4mCibPVXoYaL1eJPQ2d2a0/ykfX85+JfiAt0S4j8lAthAPHTogT4J6qonv3W9U
	usJurfIxBZDIWVJV0wfz8OFR0S2gEzzjV9gVcDUBO9974uoLhCHhy+1xJMS1azhd
	28bwfCVHu9L8dswP0ga/L+kfLo5VSGvDGSlxagvB+RI4lIhhssuBLVps9eVvdfpK
	F2942ZS9iGpKucBlQWnHRXTcubA7A==
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11023115.outbound.protection.outlook.com [40.93.201.115])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4gxc5e3e1p-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 28 Sep 2026 06:27:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=U5Z0P+KeQdR2mKgWduN0W93Yd5S9XRf7Hv50DM76VHNAHwFLwoy14ayYqhz9p4a2Nod8VCYIeow41MtX7zd2hsezEZBLsle8DscGPW3vYAknLM4CFUBVBsi4nI6An696doJD0CBL1TyKMgVWcvruvTQSr3DgdViKAkH4IQEHosUxDm8z3SBROrnJZoObmqktsoydtHLeE/XE2Zf8MRMLRWHThXfpkLKx0hadWljxI0VsbnQnQfikK163ZaZFn4Saowp0P4tv07jpnJhr5UfPsyvrhzTeZX8ocLwEDINCflObiBB6qXO6pspGZ/qxu0xFQi+ECI+pHNrPFZtdULmhxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2e66Q7kqMK/lAB4OyxwKuEP91AgnGxk1TPK0uGbF4wo=;
 b=WO3YFMcGfGs3/cD3yxyVIe+Z/Ot0fangbsaiQbxwvwZ0CDyD43OP1GX6VTnC5K7qCi9J2YHuVI2deDwxZZExs1tPimm2q+h7pQXrog25DC55IP2KBFMN+iZ05buNSX0uAGkQpPQjlZ+nWiO+WuviPFdmE+ygOAdmqKk2n09WoryixInxcXrjsPbyskVMFNZL/QM4tijFb/h6TlFlj5AQU+ADR1ymqyuX0HldsWS+uDWhctiM3rBIpJvPoRHwUNzQUJAu2uyUOJZBfKkoaBtPlog8aX1jDKGytZPGSdiAo2W0s0sZSIRVLr7ox1BLBTbawKkPgYFem2Ix2x1lusbvLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2e66Q7kqMK/lAB4OyxwKuEP91AgnGxk1TPK0uGbF4wo=;
 b=VjsEXQpSKd92VUwOhgWCxdzTCJ4NAd/5ccGQUfKLzF5p7rp5goGf0/SP8CRZ2AX23PVeOD4fgPVFNP7S9JbJAcecR6GQ/YdaII9BJMknoIMvR44Ez5T039X/hxmvvB8JkiomSLQx7h1bUHXqAo9NaeDkR2ZiMlmtw/330fl0Mewbn8mCIqV50CxLGKheN17nM22LHnKA2SgWw7ONu58w3/P4QlvgMw5V1ldn4dQDVLKR1f2Tz2sUJrP0HBiO9lnxs+Sfq8E+UD4pExPE0KWbcFarKaHGCQdWD3nZ/cnL6ZMojAfAz0u2MaVYKihcCHvdP5pM9eKTK0JEnGAqIVNtZA==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by BY5PR02MB6914.namprd02.prod.outlook.com (2603:10b6:a03:239::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.24; Mon, 28 Sep
 2026 13:26:56 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%5]) with mapi id 15.21.0451.022; Mon, 28 Sep 2026
 13:26:56 +0000
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
Subject: Re: [PATCH v9 18/26] target/arm/cpu: Expose writable ID reg field
 properties on the kvm host vcpu model
Thread-Topic: [PATCH v9 18/26] target/arm/cpu: Expose writable ID reg field
 properties on the kvm host vcpu model
Thread-Index: AQHdT00IzzQ8fofTnUmrnB/Fj42A3Q==
Date: Mon, 28 Sep 2026 13:26:56 +0000
Message-ID: <8C14A4F3-BD37-4754-981A-829464016DE0@nutanix.com>
References: <20260916144721.751810-1-eric.auger@redhat.com>
 <20260916144721.751810-19-eric.auger@redhat.com>
In-Reply-To: <20260916144721.751810-19-eric.auger@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nutanix.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA2PR02MB7564:EE_|BY5PR02MB6914:EE_
x-ms-office365-filtering-correlation-id: fb759d35-4d6a-47ba-0106-08df1d642b2a
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|23010399003|366016|376014|1800799024|38070700021|4143699003|6133799003|10067099003|56012099006|22082099003|18002099003|3023799007;
x-microsoft-antispam-message-info:
 vtapEH6ipJwBBGknlhNH+Xyl3W3VxS4J+7BvpO5bOXXKZVAJQOKV7PcRG2nYsquaMUAVUnAud+fO4syS//ccfuSUn/JTeXpQAyfOL0+uAzY4JdMIItivovrvt+hmlP/cp5PQHitA/VMH0/kqqBDE2ktVwgOVekP9G9YYxUH12HvkNYk/t/jF+MAi4h/81KuTw0kNt6qsXZuLypGaUl16SbeGu/LcB03xJ7m4FAfyHf6oEZsZ5zHBJftVKhvS+BPpvMwr5O9Y4Xwt5cXZc5CS4ntdMiiouO6Tb/SbNRm9xDYiPCJdQp4BtPn7gbd7FlOvndLnOTBxJ/QiatX4GGP/VASmS8fP/gb9twUN91qa5II/c4WDvb802+AV1x79h862NS9kP56fH73zJC0PdEZb/e7yqMTKWoThvML98RVqat/ddmhEPfOwt+DEs2SBf8sjUp2TpBDu32jMeMZ9CflFwAXSiWdRMUgPhYW0WK1sarlRtNWqA1G6/KrHY6M7yDYBMl2d9fXiytx7Si95ParIF4B81Y1J2wtLCndeJ2Dowk6HP5xuDQeiZwHc/7MgDf8RxLVDMpRb7ZmLfXPsrF8bg+xTv7KWu8pmCEKc5G0n9eXVxImWrVvkscuYGQsmaT4YKP60YVEM5oilm0lhAEyZmRptxEPUmjPXRNkUeup9aGJb5Zgl4uXRvjOHFkGVoUcoQr1ag1hmk/TvxTDqgVJuZ9PXkObdSTza9K3Sy7fRzE8=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(23010399003)(366016)(376014)(1800799024)(38070700021)(4143699003)(6133799003)(10067099003)(56012099006)(22082099003)(18002099003)(3023799007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?cWs0bTRENENvYXFUMmZKMmVxWTBqNjY4RkhrUVU3REZKcjBuSkNrQVRjUlVl?=
 =?utf-8?B?c09ZNlIxNTNhTEVmM0RXU2Z2T3J6SFdxdEkvM3ovU1lxWENGUEYwQjlGYUNK?=
 =?utf-8?B?Qi9aeWR0VTg1NFhmQ0tpYmZZTEU4L2dHS05USk9yajlIcHkwVVVFODN1UnEv?=
 =?utf-8?B?bW5venRib25ycVp4VDdkaDVSem5QUG95cGllTGNGaGU1eUdBZVoxU2I0ZXJP?=
 =?utf-8?B?ZEsxUWZRbXZWSlJUbFJtTjNWN2dsd2xtandueU8wMHY2cmY2VlJUcWgybzlq?=
 =?utf-8?B?ZzZKaXdEZFlMNEFBVjVvdlhLbHdMUVJVZHh5Sy9QeHNhSDh2V1BiUEVYb3p5?=
 =?utf-8?B?cnc4TldnNXFBcG5ockJncTQzejFxVmNYd1owdkJ5ZTFpQmNwRkoxWlVxVlVY?=
 =?utf-8?B?UVI2UE1PUWNkODFFWUlwTi91SHBucEd2aytKLzE2U3MxS3dqVDh5blRoQ2lv?=
 =?utf-8?B?aS9uelU4Sm1GTi96RldydWtaeE03K3d2MmQwdGkvQldoazBpY09MSDY2Qjln?=
 =?utf-8?B?dXZqRndGV205bmNiQk1RdWJwcEpHQkZoY1kyL0szbW9uWVNXbXVFSDRXT2gv?=
 =?utf-8?B?QWc3SWdRZTFnc2hydXdwMWpSeFJNdGRwZ1c0Tzg3VVdkdHdJTTBoeXY4VDVV?=
 =?utf-8?B?STJieDJybW9ML21OZzJnNzJWdXJXMmI1a3BydlhjWmUzZXZKMG1IOEtFd2FY?=
 =?utf-8?B?b3pJVjVYaTJwLzNnVjRtdTg2MVpDVDZleXM4UUc5cDZJU201clVZT3lwVWVu?=
 =?utf-8?B?OFRtdEg1TzNENFBERVlJOE4rN05HaFFFcTRieURKb0F0T0Q5OWJoNnFiMEZI?=
 =?utf-8?B?Q0wzZXdyR0JycGhTOEVVN1NDdWtLNnBmUjZkak5VSmUyeGNTdFlZeUl3UFRr?=
 =?utf-8?B?QW5IaWJDdnZoYnJXYkY1SkFTMGxsOFlqZC8rYXBZOTBiR05mUlFGd21Lc2VR?=
 =?utf-8?B?d2hkYUlJVVUzTHFmSnZKVTNpNUZwU1YvaG9IbGpjT01oU1MvczNVT1d6VDA5?=
 =?utf-8?B?czJYVGFZajNCcDFoMXQzamo1cE0ybUwvOFJPRDh4Qm9WeWh3RUhXeUJ6T1Z5?=
 =?utf-8?B?a3BuMk1xVk5zVDJyaHFnMDlVR1RBVkRBSFFmZUF1NUZNajk0OElQVXF0K3BI?=
 =?utf-8?B?Qlo4UE1wZVNYOUg0VjE3N2RUaURqYVpxMUJhNy9UZTJrVmhYVDVXZWdQbW05?=
 =?utf-8?B?Yk5YRUE0dFVpaGpueUlkdGNzSHBZaEVGeVJySGNXOEZ5WkNFU2o4MXZxMW9y?=
 =?utf-8?B?SFh3aFdxSXZFd3EwQWM5VUtPNldPQ1VkMnBGRjQ5b3dFRWxwUFRBbTBEWFlm?=
 =?utf-8?B?WmJJdE9RL2FBRDdETk5KbnBpTkpGZk4xamt5NGU0Qk1NV0FodjhIQUFnWVE3?=
 =?utf-8?B?Y3E0NytUUHZMVVN1KzFOZHoxTmJWaUZGdU9hSW5PUUxYeFBuYTlvTHVPKzl6?=
 =?utf-8?B?WVY5NkV0WCthNytVdmo1NngyNVdNVC9xbFFIVFhaUXhVYjdLd09TWkFBSzJD?=
 =?utf-8?B?dElEYlB2NTlXL0l5L3ZzSWhVWW1PaUxUbWRRd3daUi82V2llVm82NUxtYWVM?=
 =?utf-8?B?NjM4R3B4ZkdveW4ydmo2Sk5OOERLd3VKaXdqTE05YU9LUk0xeTYvVlRpUUpw?=
 =?utf-8?B?ZDVFdURndzFlbUtrTnNsZWJMVHJ2ZVF1UjVNM3luZlVMYWErWEtQeUhQRUZR?=
 =?utf-8?B?Ni9lUUJlNzdoRDNCL0lhUEhlcHRoa2UraGpCM0FpNjdvY205a3h4MWNLc1pF?=
 =?utf-8?B?ZDYrT3lBNVc2WDVnSEIrbmViV0lPbGNscmU4VEo3MS9pRUhFRGZKYXVHcGk2?=
 =?utf-8?B?My83RUgvTVRUc0xyWm5GVUQ5dERsZWp5ZlBvbllOWnM1OEFTVjFlY05mM3VU?=
 =?utf-8?B?NmNmRFN0VElKTkgrS25JRnBSbzFxSHpXSGV0UU42QU9Zank3aHBPZFFheURv?=
 =?utf-8?B?dnlLV2JSb0MxSi9abFZCMjV3NjRPQkk1V3MweXdETVZ6Ri9LMzQwelBpbjJB?=
 =?utf-8?B?cStzZlVHQ2JHWFFXQXdkc1lFRWFsTjBHdUZpdXZoTmhRR1dOay9tQ1cybGxR?=
 =?utf-8?B?TWt6SXlaMlV1QVJjWXRUQ3d2NnhzQUZyT3NpK1dsdllIdjVjQTFOMlJ6VE04?=
 =?utf-8?B?NHdvWElDKzhEeXh2b3NnV3Q5VS9HMFM0VFZnM3dKT0FtdEtEclJ6dnBocVBS?=
 =?utf-8?B?QkJSenpiM3FtRThvVDZkY2lKaXBuKzZta2hnZVBtMEE5QndVRFZPNGxsRnl3?=
 =?utf-8?B?MWxtcEJCM1lWNW5vOGo4VDVwZWlkVzFDUWkvanBqUHdwZ002bDBndGN0dmph?=
 =?utf-8?B?Nk1SMHM3TnBUbjNpa0ZLckxGSWZBdVRUUTVvRlhkbFlxK2I5VjBSQXd2b3Iy?=
 =?utf-8?Q?Xkt9+FDa5wAAzbG0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <643A89AF8364F24A808465789595A3EA@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	mD2xH9klOLz6vYFDH6ebgID/BmgnOohtM82A/kRxowxg0wFHNak5S/9viuhChWHqAFbiVPHnfBXz3dB1Hs9xbC+jSdArhd3vlj7xS7z613Ti/S9kjOFQjzvIKXzLJDAbXtj+Yqtvuglu+7AIXbYQZSq2cF3Of4eOo+R5ZdCnfNOgdCuPWrHkyYGVFFqPhxD1rPxnGiObJ1t0gHtdCgy1F/seNHOCwfEfHtthPNUHQf9UCZ8ZyprO1HKVyCLZhk/A+LwOcuDR5C9ddk3bHYkcWjY2ueQPlnbHoQcC06aSnoACcWJFXHM0nrXOG5z0IQt0aqHYh6am2ORA2Osl3mkd2Q==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb759d35-4d6a-47ba-0106-08df1d642b2a
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Sep 2026 13:26:56.7402
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JLYSXA1lbjmSqfHvM8wNJf4GzkwldrWabV6BMgI2z65FTgtmpCg0mfV4lMstt+AcndkOXl0IMwN9+BPq4tjcHgwYwEqykHwi+0ZE0cjgxv4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR02MB6914
X-Proofpoint-GUID: Jb_xnoKLGu0jWedUBTzDff9WnMbHvqR3
X-Proofpoint-ORIG-GUID: Jb_xnoKLGu0jWedUBTzDff9WnMbHvqR3
X-Authority-Analysis: v=2.4 cv=MfT5KJ/f c=1 sm=1 tr=0 ts=6aba6b24 cx=c_pps
 a=y6Sm6l44Xb9uyrH0UefkHw==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VofLwUrZ8Iiv6rRUPXIb:22 a=dEe9Ve2bX-KnNSUMM2s9:22 a=20KFwNOVAAAA:8
 a=oMlQa_Q0kTu41m72zMgA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI4MDA1MyBTYWx0ZWRfXxlUJk58M99kB
 pZID/WrvPkPqronNVdvPpUS7UiwwGu2RJehRt9ZitfRRNGRlEockm+k22H+CySdPFpBwjMavKYy
 caj4tKIiYWmReBnp4vg4SaquLr7bivJjRaho4pCBK2xFV+6e1iVmS3f+vINWy7bMAdCfeBKASEF
 fLkhAEoU4SXteKsjf3xlVwf0SIMoy2vVq3vByqXAUXOnh+L9TUav6awvtkqq8TeL67nLCZbJzil
 c7biQd3mcq0uknalWNIPNElW3qf4WpK/zjhIYp+WK2nmeuTB2mzUu/b05fm6B22HwJuSO2cA/PY
 /CZWsKB3atpw0Xfr+asXyo/D0+pf4iosoUFdy4kgN0UFILNleEa58Ljqp0xiO3I24TyYDkQDpYg
 M0he5rV1DQ72gR0XZ0agXLGMNuQLU9UIR/3T2H/gamHSY4VI0Gl1uhuAlQepLOL1f0xS8Qq1dKc
 gSPMK+W+NEs0qNh1SqQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI4MDA1MyBTYWx0ZWRfX+CNrtHEQDItY
 iWVpmZF3A8+guvjvgYfdKFS4Wp6TySOut9mbmGeEkCPTabmIAmUnWPn/5saLFy64EHyA7Ctu6k0
 1p905AHKTmzzzf033ey4Y+pnPI+IbKo=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-28_03,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gMTYgU2VwIDIwMjYsIGF0IDg6MTXigK9QTSwgRXJpYyBBdWdlciA8ZXJpYy5hdWdl
ckByZWRoYXQuY29tPiB3cm90ZToNCj4gDQo+ICEtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tfA0KPiAgQ0FVVElPTjogRXh0
ZXJuYWwgRW1haWwNCj4gDQo+IHwtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tIQ0KPiANCj4gSWYgdGhlIGhvc3Qgc3VwcG9y
dHMgS1ZNX0NBUF9BUk1fU1VQUE9SVEVEX1JFR19NQVNLX1JBTkdFUyBhbmQNCj4gS1ZNX0FSTV9H
RVRfUkVHX1dSSVRBQkxFX01BU0tTIGlvY3RsIHN1Y2Nlc3NmdWxseSByZXRyaWV2ZWQgdGhlIG1h
c2sNCj4gb2Ygd3JpdGFibGUgZmllbGRzIGZvciBhbGwgSUQgcmVncywgZXhwb3NlIHVpbnQ2NCBT
WVNSRUcgcHJvcGVydGllcw0KPiBmb3IgYWxsIHRoZSB3cml0YWJsZSBJRCByZWcgZmllbGRzIGV4
cG9zZWQgYnkgdGhlIGhvc3Qga2VybmVsIHdoaWNoDQo+IGNhbiBiZSBtYXRjaGVkIGluIHRhcmdl
dC9hcm0vY3B1LWlkcmVncy5oLmluYy4NCj4gDQo+IFByb3BlcnRpZXMgYXJlIG5hbWVkICBTWVNS
RUdfPFJFRz5fPEZJRUxEPiB3aXRoIFJFRyBhbmQgRklFTEQNCj4gYmVpbmcgdGhvc2UgdXNlZCBB
UkNITVJTIFJlZ2lzdGVycy5qc29uLg0KPiANCj4gV2hlbiBzdWNoIHByb3BlcnRpZXMgYXJlIHNl
dCwgdGhleSBvdmVycmlkZSB0aGUgZGVmYXVsdCBmaWVsZCB2YWx1ZQ0KPiByZXRyaWV2ZWQgZnJv
bSB0aGUgaG9zdCBhbmQgcmVpbmplY3RlZCBpbnRvIEtWTS4gVGhlbiB0aGUgYWN0dWFsIHZhbHVl
DQo+IGJlaW5nIGFwcGxpZWQgYXQgS1ZNIGRlcGVuZHMgb24gdGhlIHJlZ2lzdGVyLCBpZS4gaXQg
Y2FuIGJlIHNhbml0aXplZC4NCj4gSW4gY2FzZSB0aGUgZmllbGQgdmFsdWUgaXMgcmVqZWN0ZWQg
YnkgS1ZNLCB0aGUgdnBjdSBpbml0IGZhaWxzLg0KPiANCj4gQW55d2F5IHRoZXJlIGlzIGEgZmly
c3QgYXR0ZW1wdCB0byB3cml0ZSBiYWNrIHRoaXMgdmFsdWUgaW50byBLVk0uDQo+IA0KPiBUaGVu
IGxlZ2FjeSBDUFUgb3B0aW9ucyAodmlydHVhbGl6YXRpb24sIHNlY3VyZSwgLi4uKSBjYW4gc3Rp
bGwNCj4gb3ZlcnJpZGUgdGhlIHByZXZpb3VzIHZhbHVlLiBTbyBsb3cgbGV2ZWwgSURSRUcgZmll
bGQgcHJvcGVydGllcw0KPiBhcHBseSBiZWZvcmUgdGhlIGxlZ2FjeSBvbmVzLg0KPiANCj4gQW4g
ZXhhbXBsZSBvZiBpbnZvY2F0aW9uIGlzOg0KPiAtY3B1IGhvc3QsU1lTUkVHX0lEX0FBNjRNTUZS
MF9FTDFfRUNWPTB4MA0KPiB3aGljaCBzZXRzIEVDViBmaWVsZCBvZiBJRF9BQTY0TU1GUjBfRUwx
IHRvIDAgKGVuaGFuY2VkIGNvdW50ZXINCj4gdmlydHVhbGl6YXRpb24pLg0KPiANCj4gU2lnbmVk
LW9mZi1ieTogRXJpYyBBdWdlciA8ZXJpYy5hdWdlckByZWRoYXQuY29tPg0KPiBTaWduZWQtb2Zm
LWJ5OiBDb3JuZWxpYSBIdWNrIDxjb2h1Y2tAcmVkaGF0LmNvbT4NCj4gUmV2aWV3ZWQtYnk6IFNl
YmFzdGlhbiBPdHQgPHNlYm90dEByZWRoYXQuY29tPg0KPiANCkhpIEVyaWMsDQoNClRoZSBjb21t
aXQgbWVzc2FnZSBuZWVkcyBhbiB1cGRhdGUgOikNCg0KPiAtLS0NCj4gdjUgLT4gdjY6DQo+IC0g
ZG8gbm90IGNoZWNrIHdyaXRhYmxlX21hcCBhbnltb3JlDQo+IA0KPiB2NCAtPiB2NToNCj4gLSBn
ZXQgcmlkIG9mIHJldCBsb2NhbCB2YXJpYWJsZSwgZHluYW1pY2FsbHkgYWxsb2NhdGUgYW5kIGZy
ZWUgd3JpdGFibGVfbWFwDQo+ICBoZXJlDQo+IC0tLQ0KPiB0YXJnZXQvYXJtL2NwdTY0LmMgfCA1
ICsrKysrDQo+IDEgZmlsZSBjaGFuZ2VkLCA1IGluc2VydGlvbnMoKykNCj4gDQo+IGRpZmYgLS1n
aXQgYS90YXJnZXQvYXJtL2NwdTY0LmMgYi90YXJnZXQvYXJtL2NwdTY0LmMNCj4gaW5kZXggNGU4
YzQ3MjUzMC4uZTA0MDYyZTg0OCAxMDA2NDQNCj4gLS0tIGEvdGFyZ2V0L2FybS9jcHU2NC5jDQo+
ICsrKyBiL3RhcmdldC9hcm0vY3B1NjQuYw0KPiBAQCAtMzcsNiArMzcsNyBAQA0KPiAjaW5jbHVk
ZSAiaHcvY29yZS9xZGV2LXByb3BlcnRpZXMuaCINCj4gI2luY2x1ZGUgImludGVybmFscy5oIg0K
PiAjaW5jbHVkZSAiY3B1LWZlYXR1cmVzLmgiDQo+ICsjaW5jbHVkZSAiY3B1LWlkcmVncy5oIg0K
PiANCj4gLyogY29udmVydCBiZXR3ZWVuIDxyZWdpc3Rlcj5fSURYIGFuZCBTWVNfPHJlZ2lzdGVy
PiAqLw0KPiAjZGVmaW5lIERFRihOQU1FLCBPUDAsIE9QMSwgQ1JOLCBDUk0sIE9QMikgICAgICBc
DQo+IEBAIC04MDcsNiArODA4LDEwIEBAIHZvaWQgYWFyY2g2NF9ob3N0X2luaXRmbihPYmplY3Qg
Km9iaikNCj4gICAgIGt2bV9hcm1fc2V0X2NwcmVnX21pZ190b2xlcmFuY2VzKGNwdSk7DQo+ICAg
ICBrdm1fYXJtX3NldF9jcHVfZmVhdHVyZXNfZnJvbV9ob3N0KGNwdSk7DQo+ICAgICBhYXJjaDY0
X2FkZF9zdmVfcHJvcGVydGllcyhvYmopOw0KPiArDQo+ICsgICAgLyogZ2VuZXJhdGUgU1lTUkVH
IHByb3BlcnRpZXMgYWNjb3JkaW5nIHRvIHdyaXRhYmxlIG1hc2tzICovDQo+ICsgICAga3ZtX2Fy
bV9leHBvc2VfaWRyZWdfcHJvcGVydGllcyhjcHUsIGFybTY0X2lkX3JlZ3MpOw0KPiArDQo+ICNl
bGlmIGRlZmluZWQoQ09ORklHX0hWRikNCj4gICAgIGh2Zl9hcm1fc2V0X2NwdV9mZWF0dXJlc19m
cm9tX2hvc3QoY3B1KTsNCj4gI2VsaWYgZGVmaW5lZChDT05GSUdfV0hQWCkNCj4gLS0gDQo+IDIu
NTMuMA0KPiANCg0K
