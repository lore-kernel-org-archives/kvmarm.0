Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B1C1511213
	for <kvmarm@lists.linux.dev>; Tue, 29 Sep 2026 13:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790687374; cv=fail; b=ERc1PlNONRoeOQp0AEocrCrQZ8bJ4/j7qv3hPkpFBK4fUy7pBaw8GNnG9L0lijj0BM7jdKDg4OEw31xMU9sp3OKPmrNeDcWLfCbiSSFxKDXrL0ETNkhv0kWE1nUmmVl7uHk5zUqMta614hVZBmsESe+MYOY+rOjdmOHv7q2rwUo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790687374; c=relaxed/simple;
	bh=nIzdQPl6QLCEB6PxteIuIsLLEmuuSc1zBFyQL9C4YEA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=i8EvctTm6TnXeb5if4efrwCN12s4dRvfHPHLTKDy7E3V5MnW3QERvFm7YfQfv49VGkl+TilDeXcqeI3V2o7l/MV+t3scrPlkMMG+co/So6uEm73JlNpICdPzIs+fV0AmXi6h9/FvZyO60qj64XfrxfhYB9RXZwnk6d2WfV29GAE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=qsMEKQzd; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=aEM4EU74; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="qsMEKQzd";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="aEM4EU74"
Received: from pps.filterd (m0127837.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68TAlkx3509130;
	Tue, 29 Sep 2026 06:09:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=nIzdQPl6QLCEB6PxteIuIsLLEmuuSc1zBFyQL9C4Y
	EA=; b=qsMEKQzdgkeadkKrEwgGLFhT5jtqCL41CDN6lllLT/ENjr3w5YVQ6cKBG
	bRhtJereFvBZ4Osji/0TYG47HJk6QoKGGWe99HROwV/7xCvmnbrn1MYAixHAanTU
	iTVOfzqlNnSXHQRiiot/KdD0z4gYYDCXf4IAe3G3MOYQpDzjpBRhzB7oF2d7D009
	Z0JSDNWLtpOgcEywwPhn/ul7MXRcDKujCFcpz/tSwShb2FjjYCsble37JdzBFJH2
	uq7Mr1OD+9rp3RWcWdoUuAT7+8UTML2kr5uw+sq8Cm5HwI57NdDEaSc+9g/B4Wm0
	0+hsJtUHTeLjDm2FOyEmfkf2tdzVw==
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11022132.outbound.protection.outlook.com [52.101.48.132])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4gyycv27ay-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 29 Sep 2026 06:09:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lKLVNjyKqNPfhOwyq8kl5LDc+4hnRQEQPXCBSPmmBbzsVch521FTcYxLa0ebwmedBD9BO9WBM2o6nBKYkfhnbMhzsIVJpAaxY7y+W7dZ4+F1CoShkohisWk5psk4tmRIIHW9XsdV75+Q5wUqT+AzdZ244cj8xlwhfSRsEnoNLe0J/c/BM/ejwy9HzEmpw1rcMe9aEymQRJlJkF9G5coJWK+fAddj6+/iaYvIPr6h7LTnnmtnWaVvHIKXdBTk1JZzG+K7jlptz/MwhMc7aAGvNEQE+FhzZS/PeO1eP4A3s8qCZ7hveMSZszbTo2MbM1dtspVM/zcVMd89o9YjVBCM9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nIzdQPl6QLCEB6PxteIuIsLLEmuuSc1zBFyQL9C4YEA=;
 b=tbjXjiBYPquHrkJtm4b6DGXxYLLPaStwLUzjj2mP9AmGZAU343Bi+BPc49qVnO18/aDwworwEV+PnSvyOdMb4w7FUsdSz/norwvkA4xFDSGxx/wJkiIn1ixwIz/Jp8cS8XpnB02n4Y8y52bH2+78LKCw4xCFzRRnKjA73M4rDfPg+q0E3rq81IZKiv6Am/Gkl7nXBA20Uao61yIGzUIhF08oKNVsF97BiAiKZ9LsA3pABIcU7qNWB4iy6/sCaC/Ul7+azXGfjK5i0Jdb9mKpyW5Ng9CeiW981f6mtOR6pcibtVtzbqcarLlceHttJ9YOqd0e2yGO0RemNN2f2P2Q5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nIzdQPl6QLCEB6PxteIuIsLLEmuuSc1zBFyQL9C4YEA=;
 b=aEM4EU74P2cox80nS81qDZcIxfHUjOjUvKv9ULhrifc6pIgeNR2el2vV1PNs4uvvaexjI6+bHi0FUg8V1HymdOpMG9KkCfWk6kn9bfKFHHEos82jq+8NmXoF1sf1HSVXqUEU/0fYT93AGgMpitcRVFNHrUMVKgoJAmKPVr9jsZYgWInvSSiEiPA5le+kGAmjT4IB6gKnzepU/CvHCw4dtgiF4/O40APzQktnDv/s38c6qnhuVLZFsA5EtCj+O8uFjoNjzmHjeB52ITm8xF+ihyX4uFm5df0RV4WSsiNticcqJOk3Ryz7lhU4vAuDzsDPQGOcoOw1yj6m0e9bQPp5vQ==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by IA1PR02MB9206.namprd02.prod.outlook.com (2603:10b6:208:426::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.24; Tue, 29 Sep
 2026 13:09:17 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%5]) with mapi id 15.21.0451.026; Tue, 29 Sep 2026
 13:09:14 +0000
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
Subject: Re: [RFC PATCH v4 08/25] target/arm/kvm: handle writeback for special
 ID register fields
Thread-Topic: [RFC PATCH v4 08/25] target/arm/kvm: handle writeback for
 special ID register fields
Thread-Index: AQHdScVnVa3Hz5ai9EyoEFthTgDDig==
Date: Tue, 29 Sep 2026 13:09:14 +0000
Message-ID: <3EF48EF1-279C-4EBA-9673-D9FB269155DC@nutanix.com>
References: <20260921123249.1708067-1-khushit.shah@nutanix.com>
 <20260921123249.1708067-9-khushit.shah@nutanix.com>
 <aabcb61b-8341-423f-b113-e7ab2b34c2ac@redhat.com>
In-Reply-To: <aabcb61b-8341-423f-b113-e7ab2b34c2ac@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nutanix.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA2PR02MB7564:EE_|IA1PR02MB9206:EE_
x-ms-office365-filtering-correlation-id: 4d9335ec-2e00-4d0e-a420-08df1e2adca7
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|376014|7416014|366016|23010399003|10067099003|56012099006|6133799003|4143699003|22082099003|18002099003|38070700021;
x-microsoft-antispam-message-info:
 CLioVgkKBi8OFQsiWXOXGLqG9Agl9u3G0vsgMIbUKFMkhLwkfzEkpgIVtc4TYKXrbLpgezzmSC2mGbT8u1JHAgUhAPPBOvcNTP2SDzf5C0SRJnkj4gddyKsDdM5WKtoaMbtxNJtal18R8XwB/9Na1CImUTeX0RTEtUeH3AnbfNh+eQ5/B5bJxOHS+6HPgt9ChADV+2d3sp6/orvVaMsm98hNrCfrXTOh1rNqitOHYlYJvs8suhkqBTBjBA07I0xMkdVDK7DJX7L5JC2HzFy3FEpJAVexpD4OFTNWlkJaEgHV6y0bRFjDwWwgylY9J4/y4bs+3n2beYioyz2n6NVh1ZVhtBAORLv7Lcv/7lRFysePdln5c9/R0Q9MHKNHrGpAXIB+lpDI28Qe1fuCp9VwnYF+jVbb7OFbWSLB/r/JC1wpD8Kvn7HJL+j9I7Mvo2BiOVkrs147btPrGW807Kd5DWYfNHaQySa2pNuuvAwo0yNkcIxbqSqYVViZwzcCHyHr3UPjWdc2fmgqO5OFtdwibueCjpZnLtT43RdhhSHS9WO1IlWGelmk99l2tVzJKCZtn9p/BGMb+wU2DE1b0WbJcSdEZ1U++SA7smNQbb9SUT5uCI/8ksT1nJhRgz2ZJ4JwDiEmlezSNsLaIuj9Z3gjgAwtzZQZMg0DSe/ji0hbH+8LPsxIn0Kq/WVqSsO4LvdZkEfDpLMJbr26eWSvURXVwfPZc0nsiZrCcdPMcp/Kl/0=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(23010399003)(10067099003)(56012099006)(6133799003)(4143699003)(22082099003)(18002099003)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?eWpXNGt2L2NkZ3NzOWhTeUJQYUdoOFpCRTg2N1JleE9rd1lHZWlCRnc5SUFy?=
 =?utf-8?B?dHFBTHJGL0dvMHRWNFRwb3JJMTJib2N6UVR5MTBjZkY4bGNnV3pTRll6MVF0?=
 =?utf-8?B?Nkd6MzFTN2FqRmZxQ29BUVRVMFB3dUpNQjF5NFdXd0VoamV2UFhabWlaUG45?=
 =?utf-8?B?VUI2L21IS2lRcEpscnUzY2FWSFBCL09FWVg0aVNFV3BTd3h0Q0l0bFdkeGd1?=
 =?utf-8?B?ZEorSW9yRUlUOE04eFpaZjZmdEJoa2FtaG8rZUZOQmNFVDdWZnU2LzRrdWtu?=
 =?utf-8?B?aVBTMG9QKyt3dmxzcTdQdXV0TXV1UFhkb3ZUNFl1TnU3eDhJUjdxU3JVTHVI?=
 =?utf-8?B?ZWdWUjMwc3J1SmlSRFgwWVpwQ3BUaFBCeng4dEhGY2huRkV2cGlVVHFpdU90?=
 =?utf-8?B?dGxTdEpkZVFKYjNwSG9oNDFzMTNGeDk4OWp3ZEJxaThLTnhCTlBRZGpmemdo?=
 =?utf-8?B?OWpMZURsS2VvbDFVNFNsWkhSSUJmeSthcDhwbnQvTHRMVVE2eklZeHoyRnB6?=
 =?utf-8?B?RW80YUVRRTM5Vmo3d2tBY29pK1p4and4UzA3RkdQNnhSbExqeWlUTjAwQmNP?=
 =?utf-8?B?SW0xT0hKSklaV3VGM29QN04vbjZickxtYlVYOE40ZHU1eklWOU5kOGsyejdI?=
 =?utf-8?B?UUdwMjgrU2FadGhFVkM4UU4yMFFzVjdESk5Sb3drM0VDL21HU3Z3Y2J1OXhP?=
 =?utf-8?B?RzBWY21kSnJqdXkwWlZqd1pBc2w0UThPT0hoRnRUbDhraTBmc2NXSXFGZE1D?=
 =?utf-8?B?ditySWJFQTZ0N3VNQ1J0ekJTRENiMzB1VktpUVU2UHREWWJsUHZpRjgrbW5s?=
 =?utf-8?B?bGI1bjdTL0NDeS9Kd1VLWGNIMnkycko1Y0YwYllEVCtoQmxuR2kvSkNVMDVk?=
 =?utf-8?B?SlRyZENFbUYvR2E3eDRWRlpaUXBoYStpSjZmUlJQSzVqcHQ4Q2EvaWNCeHJx?=
 =?utf-8?B?cFlPcUhqZEtoTVpORUd0YXBLZlRnZ3B5WFIvQWhKcXdxK3pPNHc1NjYwSHBz?=
 =?utf-8?B?aHFnRGROc2ZXL2VtN2hxM2txbElXNk1UU2RHV3Fidk1Zb0xmM1MxNDZHNUtt?=
 =?utf-8?B?TFRjSzZTSTN1YkxrT1Q1OUFxRHhNL2E5UDR6bEsrdks3NDNFQW40cElWL3dS?=
 =?utf-8?B?UlNRaVBlYzhYRVVwSko1TW1zNnpBWXBWY3dQLzZ3R2hsajlMZHZpeDBJTUVY?=
 =?utf-8?B?OFlCb3JMZGRRU0RGMDJ3UXMxaWI2UTFyNmJ1TSthNVZ5MzJ2U3JhWmRkWVpO?=
 =?utf-8?B?MTB2SFppVVh6VFVVb1BsM3U5c00xWFZIeEpuZmxScWRGZGRXQ0lUWjhOcXpV?=
 =?utf-8?B?VlRud3JqME1RNWpBVUdXSDdkTnV0Yjcyb3dhZUNyTmNvYnZiajEydVJNM3Bx?=
 =?utf-8?B?bDdiS1Blb2RuczUrY0h5bklraktSTGFZelZDT0EvQkRqN1VSZzJ6bzN0TVkx?=
 =?utf-8?B?a0FvOVhhcFNjS3JibjBXRXJsNUV0QWFwUk9mcnN0MDludkd4L3lkWVFZL0pv?=
 =?utf-8?B?OGRINmdqYlk0MU5peVhHZWI5Wmd5M210RmtrdHZ4SkJWM1NvdzI3TDhvNk13?=
 =?utf-8?B?WWg1N29oeXFxOHBGdjFUd3FCbWlrbkErTmRaZ3RPSm12OEprVU5RSVdCdW9k?=
 =?utf-8?B?WU9xMWxVdHdLdmVVLzlkdi9DdUNkMWRTU0IxWGJhS3JEb2VvV2UwN1hJRlRZ?=
 =?utf-8?B?V0g3d1h3cm85NEVFTGxPOFFBU0JvbFBOclhuck9FK2ZMdjdud0toeFg0T2xs?=
 =?utf-8?B?Y2tkcnltSlJMSEpZRnZZajBtNjBTcUlpbjArNVkvZW5XcGhnbHRmeW9yWTBB?=
 =?utf-8?B?c0FFMEdocEF4cTFyWjEvWDBzZ2JMZVBubXdSb2ZlKzl6M092Yy9ocFFlcGxE?=
 =?utf-8?B?T09lUGo4WXRVRG5RT1Q4aURIemJwMGUycjMwTnAybHNrMEJldGxQMWFHNUQz?=
 =?utf-8?B?MDlXWHZoMEtOcmZKTlBmekVySVlRT3FKeDdIN1ZzVWtabVVBM0QwNHFoc2hs?=
 =?utf-8?B?VVorVDFxNjk0N2lNcjNqSkhJeGRvK25oSkdYUmcrUi9lN1gwdzh5bHRqVWps?=
 =?utf-8?B?SzltSjJqMHZiWkpHOGZpSmVEdWNFNFVSRmNkSjhIZWorTnhuVzUxcXNpN1Qv?=
 =?utf-8?B?QW04SEpmamxxbkZVL1FvcTU3TUoxeVdyQzdCTE45ak5PUHBoVGJicHdCYmpH?=
 =?utf-8?B?VGlodW8zM25tR3RYa1M0UW55bVo4bXRjTzM2LzJDZlJTcGdVN2lUZFRRQ2kz?=
 =?utf-8?B?WjFYSEdMSFVzd1FBUHdzMjRxd1hOQUFFWVZLdHhSelIzMnJqY0ViMEV2Mmts?=
 =?utf-8?B?M3EzSndEcnVUemZSRmdzNUVaNE83NXY0UjV1TGpEMHhJNHJzV090RjhGZXlx?=
 =?utf-8?Q?svlAwavTHgHkjzI0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DFAF908C5EE0E4408C3C7E635BEC8ED2@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	YXrN/G4Kp97bRMwzJPddqWmTB1i/yM4JiI1rLF4f95w7qwdM19i8Ms7p+61gePJQIUQaz93IZ2PhwkAlLNmnC5IahqLItD4oNsE6xJLsUutA4PPJNkZ0Zgfk89GcUHS33Yh5/a5yf5LRYzUkG/xHrmLTaVGUI0Obn98Brn+WTpy6rcXWe2tJIfpn/One4Jsi6tZAn6CrGjBdRPdU/RYD+a+2YS9AGl6jsuGvjGVfu8z5eOx5MMVczzCzt86eC9bJXLtsKO7iROiOsp9rXUWFIz7ZkJLOZ9JZ9KL2cwF3SBcQbb22nhdTgYy9cC0EQ6Y02StldBEUCyUicdwpEK+DrQ==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d9335ec-2e00-4d0e-a420-08df1e2adca7
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Sep 2026 13:09:14.9304
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YQK3pgxkQbSceLprSF3ZJlNXh1YY7U6h0Kgig7WNrXZ5JEiSL4zbmJgAD4U2BqMEGYMOSO+B4RR9FhoxeGPB1gYne97rnE0O/a4WZnzQxVI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR02MB9206
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI5MDA1MiBTYWx0ZWRfX3ecAUDUvYuGt
 jN02ILcNIGuwCur9by7H3LsxsDVWh9R76mcsxkJKHHo/5gAkxkx9kYCCgzBi0BNJZZMCtFvF1jF
 Xyi76gOg3hBOjwAYrzm2rx46IBxFcgpc69AMVHhB2e/1lLwacfnesXwig1klYcccsr3DmJldz3K
 v/EnMBQlEF7zasE45ik5mUSb6VK8qbUG8+rDfYeek1cxomIhQRV655aFZ8v1aigCBKxGdId4BIs
 WQUOyTJDniaKZqMApqGjjn7sZBlWHXQdyZXB9SrgEks8kSaCWy01dH9r53Vg1kKg992OnrIJEL1
 RmDn++Xe3ijPKCc/odEUxST37Yw3TMET/Cd0ayFRHXBC96tYer1x1waFlH6+4CFnklVU8BrtERp
 bHYMM+6NI7S+jAuKuY50VkHXinR/ehFnWq0/+v3qB7MwNpU4UQNvLM60WjX9xVvPErpCH+aPC5h
 SCyVcZq+H/geQZFYpFQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI5MDA1MiBTYWx0ZWRfX3FVp4siF673Y
 r4Qx1gKn20gS03HPwpWM3TDQBxPqpfNStCAf9UqUGHWw/3HlpbzUM7U4t6nWSvfGlwR/Oz9RXIq
 5K4ZBQLKvlSLBBsRoebhcNaRlEBsv0w=
X-Authority-Analysis: v=2.4 cv=FM2OVOos c=1 sm=1 tr=0 ts=6abbb881 cx=c_pps
 a=D7hViFZnkHkNtnby+5Sw9A==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VofLwUrZ8Iiv6rRUPXIb:22 a=Ap8k9tRZuQ82DLYWQqG7:22 a=20KFwNOVAAAA:8
 a=64Cc0HZtAAAA:8 a=MJ3db33aqVT_XWkCQYgA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: PB-NOBIcxwoy8-SWd8KXvbGiVj9cn4Pk
X-Proofpoint-ORIG-GUID: PB-NOBIcxwoy8-SWd8KXvbGiVj9cn4Pk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-29_04,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gMjQgU2VwIDIwMjYsIGF0IDM6MjfigK9QTSwgRXJpYyBBdWdlciA8ZXJpYy5hdWdl
ckByZWRoYXQuY29tPiB3cm90ZToNCj4gDQo+ICEtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tfA0KPiAgQ0FVVElPTjogRXh0
ZXJuYWwgRW1haWwNCj4gDQo+IHwtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tIQ0KPiANCj4gDQo+IA0KPiBPbiA5LzIxLzI2
IDI6MzIgUE0sIEtodXNoaXQgU2hhaCB3cm90ZToNCj4+IFNvbWUgZmllbGRzIHNob3VsZCBub3Qg
YmUgd3JpdHRlbiBiYWNrIHRvIEtWTSBmb3IgdmFyaW91cyByZWFzb25zOg0KPj4gLSBJRF9BQTY0
UEZSMF9FTDEuR0lDIC8gSURfUEZSMV9FTDEuR0lDIGFyZSBmYWJyaWNhdGVkIGJ5IEtWTSBiYXNl
ZCBvbg0KPj4gICB0aGUgZ2ljLXZlcnNpb24gcHJvcGVydHkuDQo+PiAtIEtWTSBkb2VzIG5vdCBh
bGxvdyB3cml0aW5nIDAgdG8gSURfREZSMF9FTDEuQ29wRGJnLCB3aGljaCBicmVha3MNCj4+ICAg
Ym9vdGluZyBhbiBBQXJjaDY0LW9ubHkgZ3Vlc3Qgb24gYSBob3N0IHRoYXQgYWxzbyBzdXBwb3J0
cyBBQXJjaDMyLg0KPj4gLSBJRF9ERlIwX0VMMS5QZXJmTW9uIGlzIHBvcHVsYXRlZCBieSBLVk0g
ZXZlbiBmb3IgQUFyY2g2NC1vbmx5IGd1ZXN0cw0KPj4gICBidXQgaXMgbm90IHdyaXRhYmxlIHRo
ZXJlLg0KPj4gLSBNUElEUl9FTDEgaXMgbWFuYWdlZCBieSBLVk0gYmFzZWQgb24gdkNQVSBpbmRl
eC4NCj4+IC0gSG9sZCBvZmYgd3JpdGluZyBiYWNrIENMSURSX0VMMSB1bnRpbCB3ZSBwcm9wZXJs
eSBzdXBwb3J0IGV4cG9zaW5nDQo+PiAgIGNhY2hlIHRvcG9sb2d5IHRvIGEgS1ZNIGd1ZXN0Lg0K
Pj4gDQo+PiBTaWduZWQtb2ZmLWJ5OiBLaHVzaGl0IFNoYWggPGtodXNoaXQuc2hhaEBudXRhbml4
LmNvbT4NCj4+IC0tLQ0KPj4gdGFyZ2V0L2FybS9jcHUtaWRyZWdzLmMgfCAgNiArKysrKysNCj4+
IHRhcmdldC9hcm0vY3B1LWlkcmVncy5oIHwgIDIgKysNCj4+IHRhcmdldC9hcm0va3ZtLmMgICAg
ICAgIHwgNDAgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrLQ0KPj4gMyBm
aWxlcyBjaGFuZ2VkLCA0NyBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pDQo+PiANCj4+IGRp
ZmYgLS1naXQgYS90YXJnZXQvYXJtL2NwdS1pZHJlZ3MuYyBiL3RhcmdldC9hcm0vY3B1LWlkcmVn
cy5jDQo+PiBpbmRleCBkNThiOGVkMDYzLi4xZjdlYmZlOWJiIDEwMDY0NA0KPj4gLS0tIGEvdGFy
Z2V0L2FybS9jcHUtaWRyZWdzLmMNCj4+ICsrKyBiL3RhcmdldC9hcm0vY3B1LWlkcmVncy5jDQo+
PiBAQCAtMTA3LDMgKzEwNyw5IEBAIGJvb2wgYXJtX2ZpZWxkX2lzX3dyaXRhYmxlKGNvbnN0IEFS
TTY0U3lzUmVnRmllbGQgKmZpZWxkKQ0KPj4gICAgIHJldHVybiAoYXJtNjRfaWRfcmVnc1tmaWVs
ZC0+aW5kZXhdLndyaXRhYmxlX21hc2sgJiBmaWVsZF9tYXNrKQ0KPj4gICAgICAgICAgICA9PSBm
aWVsZF9tYXNrOw0KPj4gfQ0KPj4gKw0KPj4gK2Jvb2wgZmllbGRfbWF0Y2hlcyhjb25zdCBBUk02
NFN5c1JlZ0ZpZWxkICpmaWVsZCwgQVJNSURSZWdpc3RlcklkeCBpbmRleCwNCj4+ICsgICAgICAg
ICAgICAgICAgICAgY29uc3QgY2hhciAqbmFtZSkNCj4+ICt7DQo+PiArICAgIHJldHVybiBmaWVs
ZC0+aW5kZXggPT0gaW5kZXggJiYgIXN0cmNtcChmaWVsZC0+bmFtZSwgbmFtZSk7DQo+PiArfQ0K
Pj4gZGlmZiAtLWdpdCBhL3RhcmdldC9hcm0vY3B1LWlkcmVncy5oIGIvdGFyZ2V0L2FybS9jcHUt
aWRyZWdzLmgNCj4+IGluZGV4IGFhYjFhNzlkYjEuLjhlZjNmOTM1MGUgMTAwNjQ0DQo+PiAtLS0g
YS90YXJnZXQvYXJtL2NwdS1pZHJlZ3MuaA0KPj4gKysrIGIvdGFyZ2V0L2FybS9jcHUtaWRyZWdz
LmgNCj4+IEBAIC0zNSw0ICszNSw2IEBAIGV4dGVybiBBUk02NFN5c1JlZyBhcm02NF9pZF9yZWdz
W05VTV9JRF9JRFhdOw0KPj4gDQo+PiB1aW50NjRfdCBhcm1fZ2V0X2ZpZWxkX21hc2soY29uc3Qg
QVJNNjRTeXNSZWdGaWVsZCAqZmllbGQpOw0KPj4gYm9vbCBhcm1fZmllbGRfaXNfd3JpdGFibGUo
Y29uc3QgQVJNNjRTeXNSZWdGaWVsZCAqZmllbGQpOw0KPj4gK2Jvb2wgZmllbGRfbWF0Y2hlcyhj
b25zdCBBUk02NFN5c1JlZ0ZpZWxkICpmaWVsZCwgQVJNSURSZWdpc3RlcklkeCBpbmRleCwNCj4+
ICsgICAgICAgICAgICAgICAgICAgY29uc3QgY2hhciAqbmFtZSk7DQo+PiAjZW5kaWYNCj4+IGRp
ZmYgLS1naXQgYS90YXJnZXQvYXJtL2t2bS5jIGIvdGFyZ2V0L2FybS9rdm0uYw0KPj4gaW5kZXgg
MmQ5NGIzYTg4NC4uNzBkOWEwNzU4MCAxMDA2NDQNCj4+IC0tLSBhL3RhcmdldC9hcm0va3ZtLmMN
Cj4+ICsrKyBiL3RhcmdldC9hcm0va3ZtLmMNCj4+IEBAIC0xMzE3LDEwICsxMzE3LDQwIEBAIGJv
b2wga3ZtX2FybV9jcHVfcG9zdF9sb2FkKEFSTUNQVSAqY3B1KQ0KPj4gICAgIHJldHVybiB0cnVl
Ow0KPj4gfQ0KPj4gDQo+PiArc3RhdGljIGJvb2wgYXJtX2ZpZWxkX3NraXBfd3JpdGViYWNrX2Fs
d2F5cyhjb25zdCBBUk02NFN5c1JlZ0ZpZWxkICpmaWVsZCkNCj4+ICt7DQo+PiArICAgIC8qDQo+
PiArICAgICAqIEdJQyBpcyBjb250cm9sbGVkIGJ5IHRoZSBnaWMtdmVyc2lvbiBwcm9wZXJ0eSBh
bmQgZmFicmljYXRlZCBieSBLVk0NCj4+ICsgICAgICogd2hlbiB0aGUgdkdJQyBkZXZpY2UgaXMg
Y3JlYXRlZCwgc28gYSBuYW1lZCBDUFUgbW9kZWwgbXVzdCBub3QgdG91Y2gNCj4+ICsgICAgICog
aXQuIEtWTSBhbHNvIHJlamVjdHMgd3JpdGluZyAwIHRvIElEX0RGUjBfRUwxLkNvcERiZywgd2hp
Y2ggYnJlYWtzDQo+PiArICAgICAqIGJvb3RpbmcgYSBtb2RlbCB0aGF0IGxhY2tzIEFBcmNoMzIg
c3VwcG9ydCBvbiBhIGhvc3QgdGhhdCBzdXBwb3J0cw0KPj4gKyAgICAgKiBpdC4gTVBJRFJfRUwx
IGlzIG1hbmFnZWQgYnkgS1ZNIGJhc2VkIG9uIHZDUFUgaW5kZXgsIHNraXAgd3JpdGluZyBpdA0K
Pj4gKyAgICAgKiBiYWNrLiBTaW1pbGFybHksIHNraXAgd3JpdGluZyBiYWNrIENMSURSX0VMMSB0
aWxsIHdlIHByb3Blcmx5DQo+PiArICAgICAqIHN1cHBvcnQgZXhwb3NpbmcgY2FjaGUgZm9yIEtW
TSBndWVzdC4NCj4+ICsgICAgICovDQo+PiArICAgIHJldHVybiBmaWVsZF9tYXRjaGVzKGZpZWxk
LCBJRF9BQTY0UEZSMF9FTDFfSURYLCAiR0lDIikNCj4+ICsgICAgICAgIHx8IGZpZWxkX21hdGNo
ZXMoZmllbGQsIElEX1BGUjFfRUwxX0lEWCwgIkdJQyIpDQo+PiArICAgICAgICB8fCBmaWVsZF9t
YXRjaGVzKGZpZWxkLCBJRF9ERlIwX0VMMV9JRFgsICJDb3BEYmciKQ0KPj4gKyAgICAgICAgfHwg
ZmllbGQtPmluZGV4ID09IE1QSURSX0VMMV9JRFgNCj4+ICsgICAgICAgIHx8IGZpZWxkLT5pbmRl
eCA9PSBDTElEUl9FTDFfSURYOw0KPiANCj4gd2hhdCBkb2VzIGhhcHBlbiBmb3IgU01JRFJfRUwx
IGFuZCBHTUlEX0VMMSB3aG9zZSB2YWx1ZSBjb3VsZCBub3QgYmUNCj4gaW5pdGlhbGl6ZWQgZnJv
bSBob3N0LiBUaGUgc2V0dGVyIGZvciBhbnkgb2YgdGhlaXIgZmllbGQgc2hhbGwgZmFpbC4NCg0K
WWVwLCB0aGlzIHdpbGwgZmFpbCBkdXJpbmcgd3JpdGUgYmFjay4NCg0KPj4gK30NCj4+ICsNCj4+
ICtzdGF0aWMgYm9vbA0KPj4gK2FybV9maWVsZF9za2lwX3dyaXRlYmFja19pZl9ub3Rfd3JpdGFi
bGUoY29uc3QgQVJNNjRTeXNSZWdGaWVsZCAqZmllbGQpDQo+PiArew0KPj4gKyAgICAvKg0KPj4g
KyAgICAgKiBLVk0gcG9wdWxhdGVzIElEX0RGUjBfRUwxLlBlcmZNb24gZXZlbiBmb3IgQUFyY2g2
NC1vbmx5IGd1ZXN0cyBidXQNCj4+ICsgICAgICogZG9lcyBub3QgZXhwb3NlIGl0IGFzIHdyaXRh
YmxlIHRoZXJlLCBzbyBza2lwIGl0IHdoZW4gaXQgaXMgbm90DQo+PiArICAgICAqIHdyaXRhYmxl
Lg0KPj4gKyAgICAgKi8NCj4+ICsgICAgcmV0dXJuIGZpZWxkX21hdGNoZXMoZmllbGQsIElEX0RG
UjBfRUwxX0lEWCwgIlBlcmZNb24iKTsNCj4+ICt9DQo+PiArDQo+PiAvKg0KPj4gICogQ29weSB3
cml0YWJsZSBJRCByZWcgZmllbGRzIGZyb20gaXNhci5pZHJlZ3NbXSBpbnRvIHRoZSBLVk0gY3By
ZWcgbGlzdCwNCj4+ICAqIHNvIHRoZSBzdWJzZXF1ZW50IHdyaXRlX2xpc3RfdG9fa3Ztc3RhdGUo
KSBwdXNoZXMgdGhlbSB0byBLVk0uDQo+PiAtICogT25seSB3cml0YWJsZSBmaWVsZHMgYXJlIGNv
cGllZC4NCj4+ICsgKiBPbmx5IHdyaXRhYmxlIGZpZWxkcyBhcmUgY29waWVkOyBmaWVsZHMgdGhh
dCBtdXN0IG5vdCBiZSB3cml0dGVuIGJhY2sNCj4+ICsgKiAoc2VlIGFybV9maWVsZF9za2lwX3dy
aXRlYmFja18qKSBhcmUgc2tpcHBlZC4NCj4+ICAqIFJldHVybnMgLTEgaWYgYW55IHZDUFUncyBJ
RCByZWcgdmFsdWUgZGlmZmVycyBmcm9tIHRoZSBob3N0IHZhbHVlIGFuZCB0aGUNCj4+ICAqIGZp
ZWxkIGlzIG5vdCB3cml0YWJsZS4NCj4+ICAqLw0KPj4gQEAgLTEzNTcsNiArMTM4NywxNCBAQCBz
dGF0aWMgaW50IGt2bV9hcm1fd3JpdGVfaWRyZWdzX3RvX2NwcmVnX2xpc3QoQVJNQ1BVICpjcHUp
DQo+PiAgICAgICAgICAgICAgICAgY29udGludWU7DQo+PiAgICAgICAgICAgICB9DQo+PiANCj4+
ICsgICAgICAgICAgICBpZiAoYXJtX2ZpZWxkX3NraXBfd3JpdGViYWNrX2Fsd2F5cyhmaWVsZCkg
fHwNCj4+ICsgICAgICAgICAgICAgICAgKCFhcm1fZmllbGRfaXNfd3JpdGFibGUoZmllbGQpICYm
DQo+PiArICAgICAgICAgICAgICAgICBhcm1fZmllbGRfc2tpcF93cml0ZWJhY2tfaWZfbm90X3dy
aXRhYmxlKGZpZWxkKSkpIHsNCj4+ICsgICAgICAgICAgICAgICAgLyogTmV2ZXIgd3JpdGUgdGhp
cyBmaWVsZCBiYWNrOyBrZWVwIEtWTSdzIHZhbHVlLiAqLw0KPj4gKyAgICAgICAgICAgICAgICB3
cml0YWJsZV9tYXNrICY9IH5maWVsZF9tYXNrOw0KPj4gKyAgICAgICAgICAgICAgICBjb250aW51
ZTsNCj4+ICsgICAgICAgICAgICB9DQo+PiArDQo+PiAgICAgICAgICAgICBpZiAoIWFybV9maWVs
ZF9pc193cml0YWJsZShmaWVsZCkpIHsNCj4+ICAgICAgICAgICAgICAgICBlcnJvcl9yZXBvcnQo
IiVzLiVzIGlzIG5vdCB3cml0YWJsZTogaG9zdD0weCUiIFBSSXg2NA0KPj4gICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAiLCByZXF1ZXN0ZWQ9MHglIiBQUkl4NjQsDQo+IHY5IGhhcyBjaGFu
Z2VkIHRoZSB3YXkgbmV3IGZpZWxkIHZhbHVlcyBhcmUgc3RvcmVkLiB3cml0YWJsZSBmaWVsZCBw
cm9wcw0KPiBhbmQgbm9uIHdyaXRhYmxlIGZpZWxkIHByb3BzIGNvdWxkIGhhdmUgZGlmZmVyZW50
IHNldHRlcnMuIEEgbm9uDQo+IHdyaXRhYmxlIGZpZWxkIHNldHRlciBqdXN0IG5lZWRzIHRvIGNo
ZWNrIHRoZSBuZXcgdmFsdWUgaXMgdGhlIHNhbWUgYXMNCj4gdGhlIGN1cnJlbnQgaG9zdCB2YWx1
ZS4gTm8gbmVlZCB0byByZWNvcmQgdGhlIG5ldyB2YWx1ZSBpbiB0aGUgaGFzaHRhYmxlDQo+IGZv
ciBmdXJ0aGVyIGNvbW1pdG1lbnQuDQoNCkkgZG9u4oCZdCBsaWtlIHRoZSBpZGVhIG9mIGRpZmZl
cmVudCBzZXR0ZXJzLiBJIHdpbGwgbm90IGV4cG9zZSBmaWVsZHMgd2hpY2gNCmNvbmZsaWN0cyB3
aXRoIGxlZ2FjeSBvcHRpb25zIGxpa2UgR1BBL0FQQSB3aGljaCBjb25mbGljdHMgd2l0aCBwYXV0
aC4NCg0KQnV0IHdlIGRvIGxvc2Ugc29tZSBpbnRyb3NwZWN0YWJpbGl0eSB3aXRoIHRoaXMgb3B0
aW9uLg0KDQpUaGFua3MsDQpLaHVzaGl0DQoNCj4gDQo+IEVyaWMNCg0KDQo=
