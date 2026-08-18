Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 122C83E7BBF
	for <kvmarm@lists.linux.dev>; Tue, 18 Aug 2026 09:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787046248; cv=fail; b=TcQ1Fa0dgDFoENUSPYW+iv59SLPGo7O3X22K1ZBiVHZToRPYBp2PT+n0Eqha5VOicAliWit+lQSGAUYFA5NIbmtboWh/Gy6zHjScx7dM8TTELNuLlqZ82I+L0rBUteyMwPpdLJbhJPWrFryO+R++W4kmOeU8hIdGGQP6dNZ7oVw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787046248; c=relaxed/simple;
	bh=HZZtJ6FxMizhWOsnp81H9EJc8rv/CS7lmMHvYvwJPJw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Ux7VExyNil2lC9z59pXg2Xoop/nO+hcm9BBVzIiaPC3qb/uwqmb5rxRgtGb/ny+clRau/FPN5O756YXWfuoZz3W5c+9rscND7/UHYpd61f6+DuiuFvL98sKsnPLA9Bi19QXTrABAUeYbbai8JQ24xvIziSv91LLC4xaqXN/aCCo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=QdvveMy1; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=gQBetMsZ; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="QdvveMy1";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="gQBetMsZ"
Received: from pps.filterd (m0127842.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67I85uxb2011218;
	Tue, 18 Aug 2026 02:43:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=HZZtJ6FxMizhWOsnp81H9EJc8rv/CS7lmMHvYvwJP
	Jw=; b=QdvveMy1W62rVupx74zCNcvm2LGr3C0J1BqhivbXwun7s06V7hcOg4z2o
	rAQs1H7gp2VU28jh9MaDY1PVoD8/TjVA6nlAiFjyu1Q1nqnhAFN9aZ3LKJ1N350R
	mGNstFjNwknbHiA9uTOSTjR/wJmHcvlRAuFePEVeY2ZGrhM2ezU/bVun/fTv5Zv4
	PSjNAOuROlgomVCC96wL7zWhTj779cQavGQHGbyTMDzSnqsIELnQyVhDMtf6IhGo
	Oeb1wHLndiBmHTsZJNju2EVh0eBriq91nSEJMLqImhi4t0XabBqIp8XwVjZ1Mlbk
	sWenOoFyDwlGCms72/WUkvuiwr8uA==
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11020120.outbound.protection.outlook.com [52.101.56.120])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4g2qe9e5wa-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 18 Aug 2026 02:43:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=k7G5f7od9gxstDFxwtHeO4Z/GHA1Q//6XG8ELTz1QkrUOPLnCmDomuwWi+ALK1ZSNxAAnPi36k7y4dXQcOR5V1wpBPbo2NBj2XS9Y0pBoKNcsppVKuSchex6cCRCc/SKCnjGBCQgk1pd+hPViY8nHlYijtx6olTHVI9jIMrhWvAkjPl5b7GEPc31TlauGFJY0VgzELEgvT7aa4nAbZG+iR22rbJlKk5lfSsnW/LNgsAYbUJjPkkSvNKi8CKm+keqS2x58VCHZ4UJa53+N/oRgE2bJAYwbS4azh2Rm911Ou0eAlWLLdD/8x1G43K3phtmQAel5noZSZ5VnktDNeWoog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HZZtJ6FxMizhWOsnp81H9EJc8rv/CS7lmMHvYvwJPJw=;
 b=vXYbaIamtI9rX5ILwQkXYvHjrlQALgWz+9l2g12L3BbyWoOpIpRBNImzRkdUOwQN9CulA028TjGrfEMkE3BqBwyAxYqS1ssJ3DYz92KnyqyK7i2nXF8d+FzpuFJODVF7lDQHQsvbx4vV4/ANvm2k2JVSOGGUqJFla/pCymPJ53+xwWGoS6SgjcZctfNv/nFqemRYSdALUL32eqZinEW5YOQ5TDo5Y8UuqBVikvS1nkKw2n7WQQX+9N+KhlhqSycN6N/6MJXszqV6AgHP+vKakdTSj1ktDRn1XjJSIOY0wpm9K5g+ltpgIJ/efrT/yOCVQbejoHWjrSatTFtKfc+Spw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HZZtJ6FxMizhWOsnp81H9EJc8rv/CS7lmMHvYvwJPJw=;
 b=gQBetMsZbG7MogoYrlP2IFSvTvyUPMyieDFXJrLwGRAkh9yHpdCDeoqsPBRip5HvZmCCv/xYrzYkej3xf7c7ZbuK3zBT9Jq9iA05eJkJWH/O/+iUVYLkp+NPsj5KaT9C+2ymEgFhVPru0XnO7gou7wV2tK8yE9IPhsv2NSs350YLFxt4TXZetdM+q0kugP/9oSGO68TfHmyGCmaEbOM3kEn/FtzZjgjdmqAKqsvflVJDUMsFQStKZzc5dslMxceK6/M49hYQdJe8SPb0KGT3XOg8fYwmhdYWKaD/NX1SS3XKNcx6ts/s0erYYl0aWVlXQ0S6mVUIfpyabMAlNGIWWg==
Received: from PH0PR02MB7557.namprd02.prod.outlook.com (2603:10b6:510:54::17)
 by CH2PR02MB6726.namprd02.prod.outlook.com (2603:10b6:610:aa::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.17; Tue, 18 Aug
 2026 09:43:45 +0000
Received: from PH0PR02MB7557.namprd02.prod.outlook.com
 ([fe80::4917:bc05:4373:6bef]) by PH0PR02MB7557.namprd02.prod.outlook.com
 ([fe80::4917:bc05:4373:6bef%4]) with mapi id 15.21.0339.007; Tue, 18 Aug 2026
 09:43:45 +0000
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
Subject: Re: [RFC PATCH v3 02/19] scripts: bug fixes in
 update-aarch64-cpu-sysreg-properties
Thread-Topic: [RFC PATCH v3 02/19] scripts: bug fixes in
 update-aarch64-cpu-sysreg-properties
Thread-Index: AQHdFWuUW7xD36Uxa0axgITHGLlSqQ==
Date: Tue, 18 Aug 2026 09:43:45 +0000
Message-ID: <D0C8CE98-55F0-475C-AC56-731A3858E5D2@nutanix.com>
References: <20260716213858.609699-1-khushit.shah@nutanix.com>
 <20260716213858.609699-3-khushit.shah@nutanix.com>
 <b839f20a-da50-493c-9b71-78069b62b867@redhat.com>
 <7B85F7CA-C4CB-4EAD-BCB1-6D2135934F5B@nutanix.com>
 <8d9e5cef-526e-4d4f-86a2-d86bdaeabd34@redhat.com>
In-Reply-To: <8d9e5cef-526e-4d4f-86a2-d86bdaeabd34@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR02MB7557:EE_|CH2PR02MB6726:EE_
x-ms-office365-filtering-correlation-id: c08ce9a5-f5e2-4c45-7cf2-08defd0d3246
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|376014|1800799024|366016|23010399003|38070700021|6133799003|3023799007|56012099006|10067099003|4143699003|22082099003|18002099003;
x-microsoft-antispam-message-info:
 yJKsbl/Je8FQKcabx9LGIauL4eQC0HTigcyK7GiDJ4r7wEAJj+svpuTfKbwzS50RCmjklLYhiPVGfOjdOaKpquIsOoz0Cc6CqKGtE/6ZWwyUt7jQ987m7cg/0uLeKta7hCfCqpoMHophfvHZo6W1Cn8ugt7Xhhj8vmJ9DNkg1n0eCJPq4let2MddUpGWV1r7mQcxYxK5PU6dcvbtXKHzWR02NWYroxk2w5brKrZbAwFtuhK4LS0L5Fp7SsOVzIwAtbOWZDpXCiS0iEcRkuoo30P0Q5v0B794eUvg+fX5Bmf9Ykn1PLkvJMaBP5oAolEnZlPb6CxJxZYPeHxS/zMa0Wp1lKHEpBTAI9RpGEMDgpyDLS8rlNe4DpKJaC1ZB4GNUU8DAxEUWLEEuMjH2f5LjY2EM3RM2AZU6nzl4ZAUF2N04eiKd6QTYNXPz303aHXNTTH3Yl00EVdSdF8BVrdGS+7aPDwMw8NJf0H6uk1l+e5Vy9GhCOy+Qw/zWjvXtuByTiPGJrkpuzUYc9I7x2mZCKR9R9U29Jd4487jWA6EqUVSq72XHa5MQgIzypjhvSCTxxp/Au7d+mZcXN/38oSgQov/1Sg2znBzIx0iZp4hhEE5PZjeLvAu0v2oJ36AaYbX1fQgtnZ5zANZjxbsL0Nb+sI7h3DUxRYQgJsAb5cPxDLOYsXrD73mGW9RI9q6CzN8o7B6fyVKzvHuB7CjNgaQRgdwE5U0FP8o8sYhB+An3H8=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR02MB7557.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(23010399003)(38070700021)(6133799003)(3023799007)(56012099006)(10067099003)(4143699003)(22082099003)(18002099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?blUzdGhNdEwwc2liSUpac1ZmR245M0hCODJteVQ5bFBqMWxQMkw4NjVDZm9k?=
 =?utf-8?B?WGxoa0hQSG1yb1N3YXI3WmdkamtnUWp2Ulp5UmdaTkhYNEcvZlpIR1FkaDlk?=
 =?utf-8?B?RCtvMFpHNXdiWWYzVUYwZDdrNTZsODF0QktCVWdRdGtna1ptQkZXN3l0Ymx1?=
 =?utf-8?B?cEpIWXZNWlAwRVFsMWt4MUJnbU9yT0l3TG5wYXlrSVB1LzRvK1llYkhJd3hl?=
 =?utf-8?B?N1EvVUsyT1NYM2h6c0NTM25iRGpTazg1YjRZRll6eEQ0K3BhMHl4aVZHZENC?=
 =?utf-8?B?S2piT3c5SWp5aXVYMGlaNlpEcGRFN2JmNjJrcTUvdG92bk12aGZXRDl6RXFZ?=
 =?utf-8?B?Qm1yZkxXcWU4QnpYRGF4dThOZXRySU9remRvRmZEaVlOSmZvZGpYYTRIOHpL?=
 =?utf-8?B?TUcrR1hVV0ZRcXR4OXVrUmplY1FYWlY1VUF3Ylcva2VpOW1tSlF5ZGp5WFB2?=
 =?utf-8?B?a2RBcnZwTHNOVzAvb2FKRVJqMG9DcUpncXNBRVplV1hDRUxacTRhVE1jSm5u?=
 =?utf-8?B?TGJhNUhDVEU5dHF5MlhZOTZYM3RqaDNHYUVITm5UQ1ZvSUI3U2ViVStTYkd1?=
 =?utf-8?B?WitNUTcwZ0FEb3Y1M29vci81cUdjaHlVaE91RlJIUGF1d1lHU1hqZVpYN0k5?=
 =?utf-8?B?Vm1kZlFEY3lKZEVCT3N6ajdNMUVoOFV4aE1KQkxGSDlEZTJXclIxc3RZNCtD?=
 =?utf-8?B?MVFFbWMrL1UrOXFXdTZ2RkNydGV4SDZWWUxVZnlsS3ROa0pFeC83S3BDc1Zr?=
 =?utf-8?B?TGZ2NVd0UTdRODdYQjN4Q1ZjM3FLMEpJTk9ubGM5ZjVLVXdYbEtidEFFZXlr?=
 =?utf-8?B?MGNCZ1RlUU45UHExY3YzOGxUWVlDVFg1anZQSVlPUk13ZGw4SEhoSHVvVlRy?=
 =?utf-8?B?NmV3U25jSm5nOHlDNUFKL0g0UEh1R1NKOHd5TS9Zbm90YlZuVjR2dEgrdUNz?=
 =?utf-8?B?bWU1M0FzNG8rcmd6TjgrQVJwUHV6QS9YNHN4NEdIM1h0OG96d1g3WkNNL3Yz?=
 =?utf-8?B?aUY0cHlvSVNSbHpyQzNBdTFWWHI1cEx2aHZ0Ri9GdEsvcEpVeWJRZXpyVkxL?=
 =?utf-8?B?SWMvektaOW1ZZ1Uzd2I0UHNPTWhjYXVPV0JzWGYxNTVBYjFwU1YxVTlvRWlz?=
 =?utf-8?B?R0c2dzU2a3I4RitlWk9NQzhENW52Z2tBaXVTMDhyRTdRa1FDVllqODdWYTcr?=
 =?utf-8?B?bFUvRHBJV3cvS1QzK0ViR0NRS1dqcEU0dU9iSGw1SGd4eTU0a2FQMXM3RCtG?=
 =?utf-8?B?a2ovNm5VazBibFdYZXZDcGdRZ0FYYmkxRUdUVERMMkRUdE0vSE9TK2xIN29v?=
 =?utf-8?B?cWMzNUpUSFZWSVNyRVo2WWs2Zk9NTWVtcm0rWHVkNHlNanlzOEhON0x4TnZT?=
 =?utf-8?B?WkZhb2pZcGxCZjJSMXBZakhzQjIzKzUvbDkyMGExcG85SWpuVVQ4V2NvQVNh?=
 =?utf-8?B?czhtRDJtQ2VjelMxSCsvZlVRdkxia3Y2Wi90WUkrNUI1Rngrb1N5bVhUdmF5?=
 =?utf-8?B?dHVqdHFmUXBLa3ZxNWhjREszZnpWamFyc3JzUVdZNWZNUXVHYXI2MGFFTGcw?=
 =?utf-8?B?cjJsL2R6K2g1TnB5Um1pZW5RQjJ5TncyYU0vY1V1UVFaMlFRdEV5TjhoSktT?=
 =?utf-8?B?WXQ4ZU1jVzhnMWF6NjY4Q3dHY21hUFpQcEtmMUFkQXQ3RHVpZm5VZU1uQWRD?=
 =?utf-8?B?dmdZYnRzRnpDd2E4THViQ3o5Um8vTW82cnZaUHJHdWlyRDZwVmZlT1hDbzFE?=
 =?utf-8?B?bncvaTFZQzdBOVc1UloySnFBVm9LS0YxbjNKL3ZNYjUwSlM5MFVYYkh6d2po?=
 =?utf-8?B?bkpHWXNiWDZZaWN4VWVHTUd3K2gxUExyVytkNkZUUUZQdTRrNFF5d3daUHlW?=
 =?utf-8?B?WGtrODB3YWpLY0hwbHYrVURnclViQXNUSEFlOE8yZE95MWhvYmpEZHN0YVhP?=
 =?utf-8?B?STFOZ3ZmM1N2c2JlQzg4VHpObmtNODh2YWVnZW16RUhFRGMxWFgyaUo3SGZI?=
 =?utf-8?B?MDZsS3hEODhWSERBQ1BvdWIzNWZJOGxzWm5JM3RoOEhwcTFJOC9neFBmTWNV?=
 =?utf-8?B?YnhHUlhJMGl4ZVFGZ0F1RURhMmJJblpyVzFsR25iK045elFKc3ZobmY0L3k1?=
 =?utf-8?B?MkIybEV6Q2dPbFZaaXo2dmdVcnZKM01DaE9BUzNnVEhwUkpXOUJpQzVmZ1hZ?=
 =?utf-8?B?eC9GMnFrdmEwQmtBRTF0SGRUaUFiZHI4ZHllWEQ0ODZxa2t4UWs5c3NVL1Jl?=
 =?utf-8?B?U0UyZGFsU3pHWloweXRhdlJLTHFqNE80QnZMR1BRRXM4ZWdPZ2s0STllUEdj?=
 =?utf-8?B?aU1tdVpaZDV6SHAzeS9hWHB2WUg1N0J6Q3hqSi8wTWU4MU41TmcwS3l6N2xw?=
 =?utf-8?Q?+3f0wiXVG+Z0xfcg=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C90C2F739140044494E6FAB0C0E43BDD@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	X8bNssdKkGehzdmavp1b7HgtoU18MeEtSh45z8X1pehaGXoSHXW/GAqK1v1I1DCLwB82elfYVBCfe60i6bTDr0P6A470xv4enY2oY7PFvW6vWwoel6AQx9mUNNVZvgkxk8PergpL415SgUKWurpS0F5N/Skkz++rsh7BRC/MQWHyoZgBSFf7OahZeyfNUNRrvA6KZlXwUHktO985gH+v76yVdDhgaNI5isdRWICJum089NI5m09euxeH9Om5vU0L7nS1zvbiel/+6JwEGWBtbjGH9BQBCrFoEIKHSBvSGgQW/MkDv/HnR7vZa/2VAruGgBJF0dZ2berrmXPGdK3SFw==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR02MB7557.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c08ce9a5-f5e2-4c45-7cf2-08defd0d3246
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Aug 2026 09:43:45.2714
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: V9jXUKmh0mlJ6upXbvXOD3LmCrPjCs3yaZ0MqtUOnL9hdAyYCAuK2+eKerATjijkMYWO+l/kWmWqXn1dcPdsZDLd4u4EJpRCq7A2E6aSkwc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR02MB6726
X-Proofpoint-ORIG-GUID: 2plZQdC4iVX-aq1x7jkSxRN3oprEwCSs
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE4MDA3MSBTYWx0ZWRfX86k6hdP0qt6O
 tSE0DzmrJEmN0fdMQyLO7Yfa0Y9bZ1aBxghPWqpAALCC5HjZCT2E0eVEaY+CFr6Hu7QEnYnin/j
 8E9LT9febf2n1ZcZCnOXnHFPoz/Kgq4=
X-Authority-Analysis: v=2.4 cv=MP9QXsZl c=1 sm=1 tr=0 ts=6a842954 cx=c_pps
 a=aU9leGltzW+WU5hfHysV/A==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Sv0fKeRqtYgA:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VofLwUrZ8Iiv6rRUPXIb:22 a=VUi8bpU7OL1Oj2-RSIOF:22 a=20KFwNOVAAAA:8
 a=64Cc0HZtAAAA:8 a=MSCayZ_6bYjCFNH2ovoA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: 2plZQdC4iVX-aq1x7jkSxRN3oprEwCSs
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE4MDA3MSBTYWx0ZWRfX2T01x5YXcjdQ
 0ieGtkb7itc+2NH5qnCzXnX77HPSD+/lGEY5CMvTkVGgi1Ae4z7mUqX4qX9t8WoYEUHYeWs80Q+
 OPvT93UKGnDlsuzZd0zeBhHfE3uEDZt93AxDYZ8W3KGX93qCeeJu5P7KQpSz4v1qjYN+wbIyq2K
 yUOYqcvZsB0XD+Z9jIVBaNm1+EQqhcaB3NiByRB0LGy5CvCqk1rKjVYDXV3Wovm35pE5FtD54pk
 gKKRqRL9rn5U+WkKuXy30Tz0/XIGNei305Q/uCMgwdSj5/9RrTjvd50Bv8LJPHyN917LJwsxh8T
 PPOVQ8kSijs95Qjnthpce6Ts0yAqKziYkuWijiZf7os/oZVu/NbdGrT15ExL7FXiBBHwFoh0dHD
 Birf9cB4veUw/f4tNr1ap1QpJC4j8wSKkNxiabnZrZk6GFmxzUd+aEJaCDrQ9dm8Imk3LhHJN+f
 g6ZZ5IQ/PERscvu6mXA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-17_04,2026-08-12_01,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gMTQgQXVnIDIwMjYsIGF0IDc6MTXigK9QTSwgRXJpYyBBdWdlciA8ZXJpYy5hdWdl
ckByZWRoYXQuY29tPiB3cm90ZToNCj4gDQo+ICEtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tfA0KPiAgQ0FVVElPTjogRXh0
ZXJuYWwgRW1haWwNCj4gDQo+IHwtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tIQ0KPiANCj4gDQo+IA0KPiBPbiA4LzMvMjYg
NDozMiBQTSwgS2h1c2hpdCBTaGFoIHdyb3RlOg0KPj4gDQo+Pj4gT24gMjAgSnVsIDIwMjYsIGF0
IDc6NTTigK9QTSwgRXJpYyBBdWdlciA8ZXJpYy5hdWdlckByZWRoYXQuY29tPiB3cm90ZToNCj4+
PiANCj4+PiAhLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLXwNCj4+PiBDQVVUSU9OOiBFeHRlcm5hbCBFbWFpbA0KPj4+IA0K
Pj4+IHwtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tIQ0KPj4+IA0KPj4+IA0KPj4+IA0KPj4+IE9uIDcvMTYvMjYgMTE6Mzgg
UE0sIEtodXNoaXQgU2hhaCB3cm90ZToNCj4+Pj4gLSBoYW5kbGUgcXVvdGVkIGJpdHN0cmluZ3Mg
IGFuZCBkZWNpbWFsDQo+Pj4+IC0gc2tpcCBWYWx1ZXMuVmFsdWVSYW5nZSBlbnRyaWVzLg0KPj4+
IFRoZSBhYm92ZSBpcyB0aGUgaXNzdWUgeW91IHJlcG9ydGVkIG9uIG15IHY2LiBTZWUgbXkgY29t
bWVudCBvbiB0aGUNCj4+PiBvdGhlciB0aHJlYWQuDQo+PiBBY2tlZC4NCj4+Pj4gLSBFbWl0IHVu
aXF1ZSBSRVN4X3tsc2J9IG5hbWVzIGZvciByZXNlcnZlZCBmaWVsZHMgc28gbm8gdHdvIGZpZWxk
cyBpbg0KPj4+PiBhIHJlZ2lzdGVyIHNoYXJlIGEgbmFtZS4NCj4+PiBUaGUgcmVxdWlyZW1lbnQg
Zm9yIG5hbWluZyBSRVMgZmllbGQgbmVlZHMgdG8gYmUgZXhwbGFpbmVkLiBJIHVuZGVyc3RhbmQN
Cj4+PiB0aGF0IG5vdyB5b3UgZXhwb3NlIGFsbCBmaWVsZHMgaW5jbHVkaW5nIHRob3NlIHdoaWNo
IGFyZSBub3Qgd3JpdGFibGUgaXQNCj4+PiBtYXkgYmUgcmVxdWlyZWQgYnV0IGF0IHRoaXMgc3Rh
Z2UgSSBzdGlsbCBmYWlsIHdoeSB0aGlzIGlzIHJlcXVlc3RlZC4NCj4+IEkgdGhpbmsgd2UgZG9u
4oCZdCBuZWVkIHRvIGV4cG9zZSBSRVMgZmllbGRzIHRvIHVzZXJzLiANCj4+IEkgd2FzIHRoaW5r
aW5nIG9mIGNhc2Ugd2hlcmUgYSBSRVMwIGZpZWxkIGlzIHJlcHVycG9zZWQgZm9yDQo+PiBzb21l
dGhpbmcgZWxzZSwgYnV0IHRoYXQgc2hvdWxkIGJlIHRha2VuIGNhcmUgYnkgemVyb2luZyB0aGUN
Cj4+IElEIHJlZ3MgYXJyYXkgYmVmb3JlIGluaXRpYXRpbmcgdGhlIG5hbWVkIG1vZGVsIGhpZXJh
cmNoeS4NCj4+IChSRVMxIGZpZWxkIGluIENUUl9FTDAgbmVlZHMgc29tZSBoYW5kbGluZykuDQo+
IEkgYWxzbyB0aGluayBzby4geW91IGNhbiByZWx5IG9uIEFBUkNITVJTIGRlc2MgdG8gaWRlbnRp
ZnkgdGhlIHJpZ2h0DQo+IGRlZmF1bHQgdmFsdWVzLg0KQWNrZWQuDQoNCj4+IA0KPj4gT24gd2h5
IHdlIGV2ZW4gbmVlZCB0byBleHBvc2Ugbm9uLXdyaXRhYmxlIGZpZWxkczoNCj4+IC0gQXNzdW1l
IHNvbWUgbm9uLXdyaXRhYmxlIGZpZWxkIG1pc21hdGNoZXMgZm9yIHRoZSBtb2RlbCBhbmQNCj4+
ICBob3N0LCB3aHkgZG8gd2Ugd2FudCB0byBzdG9wIHVzZXJzIGZyb20gZXhwbGljaXRseSBvdmVy
cmlkaW5nDQo+PiAgdGhlIG1vZGVsJ3MgZmllbGQgdmFsdWUgdG8gaG9zdCB2YWx1ZT8NCj4gDQo+
IEkgYWdyZWUgdGhpcyBuZWVkcyB0byBiZSBjaGVja2VkLiBIb3dldmVyIGFzIEkgc3VnZ2VzdGVk
IEkgdGhpbmsgeW91IGNhbg0KPiBhdm9pZCBleHBvc2luZyB0aGVtIHRvIHRoZSBlbmQtdXNlcnMg
YXMgcHJvcHMuIFlvdSBqdXN0IG5lZWQgdG8gcmVhZCB0aGUNCj4gdmFsdWUgZnJvbSBob3N0IGFu
ZCBjb21wYXJlIGl0IHdpdGggdGhlIHZhbHVlIHNldCBpbiB0aGUgbmFtZWQgbW9kZWwuIA0KSSBh
bSBub3Qgc3VyZSBob3cgdGhhdCB3aWxsIHdvcmssIGFzc3VtZSBmb2xsb3dpbmcgc2NlbmFyaW86
DQoNCi0gSG9zdCBpcyBydW5uaW5nIG9uIGBuZW92ZXJzZS12MmAgY29yZSBhbmQgd2Ugd2FudCB0
byBydW4gZ3Vlc3Qgd2l0aCBgbmVvdmVyc2UtdjFgDQogIG1vZGVsLiDigJxwYXV0aOKAnSBmaWVs
ZHMgYXJlIG5vdCBleGFjdGx5IHdyaXRhYmxlLCBhbmQgIm5lb3ZlcnNlLXYx4oCdIGltcGxlbWVu
dHMNCiAgZGlmZmVyZW50IHBhdXRoIGFsZ29yaXRobSB0aGFuICJuZW92ZXJzZS12MuKAnS4gTm93
LCBpZiB3ZSBkb27igJl0IGV4cG9zZSDigJxwYXV0aOKAnSBhcw0KICBpdCBpcyBub3Qgd3JpdGFi
bGUsIGhvdyB3aWxsIGVuZCB1c2VyIGJlIGFibGUgdG8gc2F5IEkgd2FudCB0byBydW4gbmVvdmVy
c2UtdjENCiAgbW9kZWwgc28gcGxlYXNlIGRpc2FibGUgInBhdXRo4oCdLg0KDQpXaGF0IEkgd2Fu
dCB0byBzdXBwb3J0IGlzIGVuZCB1c2VyIHRvIHNheSAicGxlYXNlIHVzZSB0aGUgaG9zdCB2YWx1
ZSBmb3Igc29tZSBub24td3JpdGFibGUNCmZpZWxkcyBhcyB0aGUgbW9kZWwgSSB3YW50IHRvIHJ1
biBoYXMgdmFsdWVzIHdoaWNoIGFyZSBub3Qgc3VwcG9ydGVkIG9uIHRoZSBjdXJyZW50IGhvc3Qu
4oCdDQoNClRoZSBzYW1lIOKAnHBhdXRo4oCdIGV4YW1wbGUgd2lsbCBzdWZmZXIgaWYgd2UgZG9u
4oCZdCBleHBvc2UgQVBBL0dQQSBpbiBjcHUtbW9kZWwtZXhwYW5zaW9uLA0KaG93IHdpbGwgbWFu
YWdlbWVudCBzdGFjayBpbmZlciB0aGF0IGJvdGggaG9zdCBzdXBwb3J0cyDigJxwYXV0aCIgYnV0
IHRoZXkgc3VwcG9ydCBkaWZmZXJlbnQNCnZlcnNpb25zIGFuZCBhcmUgbm90IGNvbXBhdGlibGU/
DQoNCldhcm0gUmVnYXJkcywNCktodXNoaXQNCg0KPj4gDQo+PiANCj4+Pj4gLSBFbWl0IGEgZHVt
bXkgNjQtYml0IFZBTCBmaWVsZCBmb3IgcmVnaXN0ZXJzIHdpdGggbm8gZGVmaW5lZCBmaWVsZHMs
DQo+Pj4+IHN1Y2ggYXMgQUlEUl9FTDEgYW5kIFJFVklEUl9FTDEuDQo+Pj4gVGhpcyBpcyB5ZXQg
YW5vdGhlciBmdW5jdGlvbmFsIGNoYW5nZSB0aGF0IGNvdWxkIGJlIHNlcGFyYXRlLg0KPj4gQWNr
ZWQsIHdpbGwgZG8gaW4gdjQuDQo+IA0KPiBUaGFua3MNCj4gDQo+IEVyaWMNCj4+IA0KPj4+IFRo
YW5rcw0KPj4+IA0KPj4+IEVyaWMNCj4+Pj4gU2lnbmVkLW9mZi1ieTogS2h1c2hpdCBTaGFoIDxr
aHVzaGl0LnNoYWhAbnV0YW5peC5jb20+DQo+Pj4+IC0tLQ0KPj4+PiAuLi4vdXBkYXRlLWFhcmNo
NjQtY3B1LXN5c3JlZy1wcm9wZXJ0aWVzLnB5ICAgfCA2NyArKysrKysrKysrKysrLS0tLS0tDQo+
Pj4+IDEgZmlsZSBjaGFuZ2VkLCA0NSBpbnNlcnRpb25zKCspLCAyMiBkZWxldGlvbnMoLSkNCj4+
Pj4gbW9kZSBjaGFuZ2UgMTAwNjQ0ID0+IDEwMDc1NSBzY3JpcHRzL3VwZGF0ZS1hYXJjaDY0LWNw
dS1zeXNyZWctcHJvcGVydGllcy5weQ0KPj4+PiANCj4+Pj4gZGlmZiAtLWdpdCBhL3NjcmlwdHMv
dXBkYXRlLWFhcmNoNjQtY3B1LXN5c3JlZy1wcm9wZXJ0aWVzLnB5IGIvc2NyaXB0cy91cGRhdGUt
YWFyY2g2NC1jcHUtc3lzcmVnLXByb3BlcnRpZXMucHkNCj4+Pj4gb2xkIG1vZGUgMTAwNjQ0DQo+
Pj4+IG5ldyBtb2RlIDEwMDc1NQ0KPj4+PiBpbmRleCA5ZTgyOWZkYTJlLi5lY2MzNWRiNTI4DQo+
Pj4+IC0tLSBhL3NjcmlwdHMvdXBkYXRlLWFhcmNoNjQtY3B1LXN5c3JlZy1wcm9wZXJ0aWVzLnB5
DQo+Pj4+ICsrKyBiL3NjcmlwdHMvdXBkYXRlLWFhcmNoNjQtY3B1LXN5c3JlZy1wcm9wZXJ0aWVz
LnB5DQo+Pj4+IEBAIC0xMDYsNiArMTA2LDI5IEBAIGRlZiBjb2xsZWN0X2ZpZWxkcyhpdGVtLCBi
aXRfb2Zmc2V0PTApOg0KPj4+PiANCj4+Pj4gICAgcmV0dXJuIGZpZWxkcw0KPj4+PiANCj4+Pj4g
K2RlZiBwYXJzZV92YWx1ZV9pbnQocmF3X3ZhbCk6DQo+Pj4+ICsgICAgaWYgcmF3X3ZhbCBpcyBO
b25lIG9yIGlzaW5zdGFuY2UocmF3X3ZhbCwgYm9vbCk6DQo+Pj4+ICsgICAgICAgIHJldHVybiBO
b25lDQo+Pj4+ICsNCj4+Pj4gKyAgICAjIG1heSBhbHJlYWR5IGJlIHJlYWwgbnVtYmVyDQo+Pj4+
ICsgICAgaWYgaXNpbnN0YW5jZShyYXdfdmFsLCBpbnQpOg0KPj4+PiArICAgICAgICByZXR1cm4g
cmF3X3ZhbA0KPj4+PiArDQo+Pj4+ICsgICAgcmF3X3N0ciA9IHN0cihyYXdfdmFsKS5zdHJpcCgp
DQo+Pj4+ICsNCj4+Pj4gKyAgICBpZiAiJyIgaW4gcmF3X3N0cjoNCj4+Pj4gKyAgICAgICAgIyBx
dW90ZWQgYml0c3RyaW5nIGxpa2UgIicwMTAwJyINCj4+Pj4gKyAgICAgICAgYml0cyA9IHJhd19z
dHIucmVwbGFjZSgiJyIsICIiKQ0KPj4+PiArICAgICAgICB0cnk6DQo+Pj4+ICsgICAgICAgICAg
ICByZXR1cm4gaW50KGJpdHMsIDIpDQo+Pj4+ICsgICAgICAgIGV4Y2VwdCBWYWx1ZUVycm9yOg0K
Pj4+PiArICAgICAgICAgICAgcmV0dXJuIE5vbmUNCj4+Pj4gKw0KPj4+PiArICAgICMgdW5xdW90
ZWQsIHRyeSBkZWNpbWFsDQo+Pj4+ICsgICAgdHJ5Og0KPj4+PiArICAgICAgICByZXR1cm4gaW50
KHJhd19zdHIsIDApDQo+Pj4+ICsgICAgZXhjZXB0IFZhbHVlRXJyb3I6DQo+Pj4+ICsgICAgICAg
IHJldHVybiBOb25lDQo+Pj4+IA0KPj4+PiBkZWYgZXh0cmFjdF9maWVsZF9lbnVtcyhmaWVsZCk6
DQo+Pj4+ICAgIGVudW1zID0gW10NCj4+Pj4gQEAgLTEyNCwzMiArMTQ3LDIzIEBAIGRlZiBleHRy
YWN0X2ZpZWxkX2VudW1zKGZpZWxkKToNCj4+Pj4gICAgaWYgbm90IGlzaW5zdGFuY2UodmFsX2Vu
dHJpZXMsIGxpc3QpOg0KPj4+PiAgICAgICAgcmV0dXJuIGVudW1zDQo+Pj4+IA0KPj4+PiArICAg
ICMgQSBWYWx1ZXMuVmFsdWVSYW5nZSBmaWVsZCBzcGVjaWZpZXMgc3RhcnQgYW5kIGVuZCB2YWx1
ZSBmb3IgYSByYW5nZS4NCj4+Pj4gKyAgICAjIERvbid0IGVudW1lcmF0ZSBhbnl0aGluZyBmb3Ig
dGhlbS4NCj4+Pj4gKyAgICBmb3IgdmFsX2VudHJ5IGluIHZhbF9lbnRyaWVzOg0KPj4+PiArICAg
ICAgICBpZiBpc2luc3RhbmNlKHZhbF9lbnRyeSwgZGljdCkgYW5kIFwNCj4+Pj4gKyAgICAgICAg
ICAgdmFsX2VudHJ5LmdldCgiX3R5cGUiKSA9PSAiVmFsdWVzLlZhbHVlUmFuZ2UiOg0KPj4+PiAr
ICAgICAgICAgICAgICAgcmV0dXJuIFtdDQo+Pj4+ICsNCj4+Pj4gICAgZm9yIHZhbF9lbnRyeSBp
biB2YWxfZW50cmllczoNCj4+Pj4gICAgICAgIGlmIG5vdCBpc2luc3RhbmNlKHZhbF9lbnRyeSwg
ZGljdCk6DQo+Pj4+ICAgICAgICAgICAgY29udGludWUNCj4+Pj4gLSAgICAgICAgICAgIA0KPj4+
PiArDQo+Pj4+ICAgICAgICBpZiB2YWxfZW50cnkuZ2V0KCJfdHlwZSIpID09ICJWYWx1ZXMuVmFs
dWUiOg0KPj4+PiAtICAgICAgICAgICAgcmF3X3ZhbCA9IHZhbF9lbnRyeS5nZXQoInZhbHVlIikN
Cj4+Pj4gLSAgICAgICAgICAgIGlmIHJhd192YWwgaXMgTm9uZToNCj4+Pj4gKyAgICAgICAgICAg
IGludF92YWwgPSBwYXJzZV92YWx1ZV9pbnQodmFsX2VudHJ5LmdldCgidmFsdWUiKSkNCj4+Pj4g
KyAgICAgICAgICAgIGlmIGludF92YWwgaXMgTm9uZToNCj4+Pj4gICAgICAgICAgICAgICAgY29u
dGludWUNCj4+Pj4gLSAgICAgICAgICAgICAgICANCj4+Pj4gLSAgICAgICAgICAgICMgc29tZSBv
ZiB0aGUgdmFsdWVzIGhhdmUgJyBsaWtlICInMDEwMCciDQo+Pj4+IC0gICAgICAgICAgICByYXdf
dmFsX3N0ciA9IHN0cihyYXdfdmFsKS5zdHJpcCgpLnJlcGxhY2UoIiciLCAiIikNCj4+Pj4gLSAg
ICAgICAgICAgIA0KPj4+PiAtICAgICAgICAgICAgdHJ5Og0KPj4+PiAtICAgICAgICAgICAgICAg
ICMgY29udmVydCBpbnRvIGJpbiANCj4+Pj4gLSAgICAgICAgICAgICAgICBpbnRfdmFsID0gaW50
KHJhd192YWxfc3RyLCAyKQ0KPj4+PiAtICAgICAgICAgICAgZXhjZXB0IFZhbHVlRXJyb3I6DQo+
Pj4+IC0gICAgICAgICAgICAgICAgdHJ5Og0KPj4+PiAtICAgICAgICAgICAgICAgICAgICAjIEZh
bGxiYWNrIHRvIGRlYyBpZiBub3QgYmluDQo+Pj4+IC0gICAgICAgICAgICAgICAgICAgIGludF92
YWwgPSBpbnQocmF3X3ZhbF9zdHIsIDApDQo+Pj4+IC0gICAgICAgICAgICAgICAgZXhjZXB0IFZh
bHVlRXJyb3I6DQo+Pj4+IC0gICAgICAgICAgICAgICAgICAgIGNvbnRpbnVlDQo+Pj4+IC0gICAg
ICAgICAgICANCj4+Pj4gLSAgICAgICAgICAgIGVudW1zLmFwcGVuZCh7DQo+Pj4+IC0gICAgICAg
ICAgICAgICAgJ3ZhbHVlJzogaW50X3ZhbA0KPj4+PiAtICAgICAgICAgICAgfSkNCj4+Pj4gLSAg
ICAgICAgICAgIA0KPj4+PiArICAgICAgICAgICAgZW51bXMuYXBwZW5kKHsndmFsdWUnOiBpbnRf
dmFsfSkNCj4+Pj4gKw0KPj4+PiAgICByZXR1cm4gZW51bXMNCj4+Pj4gDQo+Pj4+IGRlZiBnZW5l
cmF0ZV9zeXNyZWdfcHJvcGVydGllc19mcm9tX3JlZ2lzdGVyc19qc29uKGlkX3JlZ19uYW1lcywg
cmF3X2pzb25fcGF0aCk6DQo+Pj4+IEBAIC0yMTAsNyArMjI0LDcgQEAgZGVmIGdlbmVyYXRlX3N5
c3JlZ19wcm9wZXJ0aWVzX2Zyb21fcmVnaXN0ZXJzX2pzb24oaWRfcmVnX25hbWVzLCByYXdfanNv
bl9wYXRoKToNCj4+Pj4gICAgICAgICAgICAgICAgICAgICAgIG1zYiA+IGN1cnJlbnRfZmllbGRz
ZXRfZmllbGRzW3VuaXF1ZV9rZXldWydtc2InXToNCj4+Pj4gICAgICAgICAgICAgICAgICAgICAg
ICBlbnVtcyA9IGV4dHJhY3RfZmllbGRfZW51bXModmFsKQ0KPj4+PiAgICAgICAgICAgICAgICAg
ICAgICAgIGN1cnJlbnRfZmllbGRzZXRfZmllbGRzW3VuaXF1ZV9rZXldID0gew0KPj4+PiAtICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICdyYXdfbmFtZSc6IG5hbWUsDQo+Pj4+ICsgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgJ3Jhd19uYW1lJzogdW5pcXVlX2tleSwNCj4+Pj4gICAgICAg
ICAgICAgICAgICAgICAgICAgICAgJ2xzYic6IGxzYiwNCj4+Pj4gICAgICAgICAgICAgICAgICAg
ICAgICAgICAgJ21zYic6IG1zYiwNCj4+Pj4gICAgICAgICAgICAgICAgICAgICAgICAgICAgJ3dp
ZHRoJzogd2lkdGgsDQo+Pj4+IEBAIC0yMzgsNiArMjUyLDE1IEBAIGRlZiBnZW5lcmF0ZV9zeXNy
ZWdfcHJvcGVydGllc19mcm9tX3JlZ2lzdGVyc19qc29uKGlkX3JlZ19uYW1lcywgcmF3X2pzb25f
cGF0aCk6DQo+Pj4+ICAgICAgICAjIFNvcnQgZGVjcmVhc2luZyBsc2JzDQo+Pj4+ICAgICAgICBz
b3J0ZWRfZmllbGRzID0gc29ydGVkKHVuaXF1ZV9maWVsZHMuaXRlbXMoKSwNCj4+Pj4gICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAga2V5PWxhbWJkYSB4OiB4WzFdWydsc2InXSwgcmV2ZXJz
ZT1UcnVlKQ0KPj4+PiArICAgICAgICBpZiBsZW4oc29ydGVkX2ZpZWxkcykgPT0gMDoNCj4+Pj4g
KyAgICAgICAgICAgICMgY2FzZXMgbGlrZSBSRVZJRFJfRUwxIGFuZCBBSURSX0VMMS4NCj4+Pj4g
KyAgICAgICAgICAgICMgYXVnbWVudCBhIGR1bW15IGZpZWxkcyBWQUwuDQo+Pj4+ICsgICAgICAg
ICAgICBzb3J0ZWRfZmllbGRzLmFwcGVuZCgoJ1ZBTCcsIHsNCj4+Pj4gKyAgICAgICAgICAgICAg
ICAnbHNiJzogMCwNCj4+Pj4gKyAgICAgICAgICAgICAgICAnbXNiJzogNjMsDQo+Pj4+ICsgICAg
ICAgICAgICAgICAgJ3dpZHRoJzogNjQsDQo+Pj4+ICsgICAgICAgICAgICAgICAgJ2VudW1zJzog
W10NCj4+Pj4gKyAgICAgICAgICAgIH0pKQ0KPj4+PiANCj4+Pj4gICAgICAgIGZvciB1bmlxdWVf
a2V5LCBiaXRzIGluIHNvcnRlZF9maWVsZHM6DQo+Pj4+ICAgICAgICAgICAgZW51bXNfbGlzdCA9
IGJpdHMuZ2V0KCdlbnVtcycsIFtdKQ0KDQoNCg==
