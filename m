Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70CC32931F1
	for <kvmarm@lists.linux.dev>; Fri, 25 Sep 2026 12:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790338619; cv=fail; b=QQG0OXPpwFim+118EZYeQRv+K5/yJylSiysvfdhCMVg0Fz8uVQHHk1tx5C3K0YZ775tlf0v6RIw2gUd3s5zah7EKwTlqjJy1N2bdEoQubsgOv2pBgaRS0RQB8V6plbYgUuO+5qvJtl3DPqEhWxIZteQwFWjmm3bzSXtvPudgpkg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790338619; c=relaxed/simple;
	bh=9QkYu3SIcTj+m/iZhl22k8Ucrz58JmjWWpO+zAMCTgs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=W+srH3cGk4pWSJpzZ3qprlCaKOr7iKbYi1DgVycZWilFqzGWxvPJWNo88BAzOZGbzlCIsztL/NzuDyu/JkjkeIxSFKgrXxhKAJINNcoQnsoF6ZQ4qsX3mBq8tKSxZPivyLB6fP1dqHKLp5mV7mFpJ55lwsYGgUVkEVKKGzkKLXE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=Dl7yT2/n; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=IkcVmkmZ; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="Dl7yT2/n";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="IkcVmkmZ"
Received: from pps.filterd (m0127839.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68P868C5246566;
	Fri, 25 Sep 2026 05:16:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=9QkYu3SIcTj+m/iZhl22k8Ucrz58JmjWWpO+zAMCT
	gs=; b=Dl7yT2/nHqeroMsfrsoAzYC0nBbMjEigzU0dXqInE64yw3s+ygh+f+QBW
	L+wZVm791kZRgIB2c7UXAYjsjdVdPJGQxWKtBu620/g+YCIQiNd9oeOMO7K5OqwD
	7pV42Q2vfbenF85Idxc9d/RJIsMVJz+t+ag+COrVJ/UYBxk1CRgvJMdMs8/Uh4vY
	1AQjGXUrGAdPZQQFTVXwTxPgPBVkU6fwMtSnF/aOkGSMPARwJAQVAdP0+wbBQsIf
	pohV8oOrgWO8p0uWwx1io7xykxIecLB5+KOwPBNySvXZYoAvYxgU10/2OSgGVlp2
	NUstk/6lxU6iefim94+8iYc5BpxNw==
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11023126.outbound.protection.outlook.com [40.93.196.126])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4gwn5b0h4v-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 25 Sep 2026 05:16:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xCeLC3Wqvi/zbKPdtUZvFKVoP4QmEX/mDbnJ2yidx4aUCQcNDjFThWz5Mgib4ryg44/0XDhK/phmpBkyg0cTdgddhjuz+5VZkA1bRo4jht6oZky/48K3zcAnxhNQ8PBIUusw7nGag7uiqc9g3/mENGKgvOTW6gQGf0CFGlN4iDeY6StKSNF3BcilbVEg5ejLj6+x6y5G5bHUXgF9pkQc2WCkGmYDuogeCdQW3aINpz6D1AF9vZeCvXqwfUykouPonVWERp+GgVTyiJgBShLJMRnjXXdKCkHTjvjIi4cr2RINDflAzvKcNKvckvzY6DYf99otub4adL4y00ccls5ORQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9QkYu3SIcTj+m/iZhl22k8Ucrz58JmjWWpO+zAMCTgs=;
 b=ohbxKz25otSiNXxc7tcWkRNeIUyZVT3Gtsu6DhG83C4IdCOxu0sU/eGdqO/iWMtTS2ZEObjy/mSxLNZzOGk142h4EkZVM+010k/MfEDLe1tXCfCxwgxCV3hfRcATtOCmYulK6J6xw+rfMZL/F9eI80kmKMo9okrOxyG5+tleBvGVw5gAMGtBLY/stTKQFSrjPVdMY/nM6aEevWX/fWmHmxTj/rKOZNRrPNpmu+ItAH7ii0kxXMJeOqnyYURtVXELqg6TX0jJdrzGkFANswCsxhu0Jduy9mnRDsrE46yf1p+hcY+9Md+qI/rCmBuflCbcN7cMO2mOhmXtyuzY8bPtwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9QkYu3SIcTj+m/iZhl22k8Ucrz58JmjWWpO+zAMCTgs=;
 b=IkcVmkmZeN3NlmS2JT7NRwBF/UFTK+c5im5Br3/ZIHpkOUMqkuZFSxMibASxCnedTMo++tu6DvoNkQIfoRSaXHKUKNmkB3gjl3RsKsRalRkwBYlOqm2vCHIN74zoQxHnviVlPTGpBPZlqs1rgfjOwaIXI8klXGljj6/e54BATTudn5Un0h3YLGFp05lX0Qz9BzUCMfjqgct4KlY/Fzpm7GnGK0YrkVvjyybK9o8PhkT3Oi/1PAIFZDECRHMnuQNQZpY84BirnmV4FosEdQ9BWEBorge4x890l76ezQ/tBRzav3nBY0GhNcbjxVI40UiZ1l1+Za4fiBYtkKassElBKQ==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by PHXPR02MB11342.namprd02.prod.outlook.com (2603:10b6:510:3cc::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.18; Fri, 25 Sep
 2026 12:16:41 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%5]) with mapi id 15.21.0451.014; Fri, 25 Sep 2026
 12:16:41 +0000
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
Subject: Re: [PATCH v9 09/26] target/arm/cpu_idregs: generate tables for Arm64
 ID registers and fields
Thread-Topic: [PATCH v9 09/26] target/arm/cpu_idregs: generate tables for
 Arm64 ID registers and fields
Thread-Index: AQHdTOe4YSlbHrhiM0ml4KWJGeQkTw==
Date: Fri, 25 Sep 2026 12:16:40 +0000
Message-ID: <B69D7B70-46EE-4E1C-B56A-F404DB511E3D@nutanix.com>
References: <20260916144721.751810-1-eric.auger@redhat.com>
 <20260916144721.751810-10-eric.auger@redhat.com>
In-Reply-To: <20260916144721.751810-10-eric.auger@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nutanix.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA2PR02MB7564:EE_|PHXPR02MB11342:EE_
x-ms-office365-filtering-correlation-id: 46422f5a-e772-4695-d17a-08df1afedb22
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|23010399003|366016|7416014|376014|260925021311599003|260925021911599003|4143699003|10067099003|56012099006|22082099003|18002099003|6133799003|38070700021|260925022911599003;
x-microsoft-antispam-message-info:
 GAeOtMZfWfkY6kwFjYandPq62DMEX7h9VJ/y3ica9ys+BACU78nsz3oDkvotJw53WMfd0JObeNpW9WGkp6ZuGByvHp0OZYvJzQ+KTFkYsfVnJE4Mj9/ENtq5wmhKYiVhDN2fW0fCfhkhV/aH1+STlPxG5LbtI1bUGRGiegmuCMONUcxyoZji8ubHKpPAwXtyb+y9EQ4dCnRHOB8sCmTHroRk9PKtdvfphOfuXWNs3mEsdsxaadBWRBvUX/P0jzvrybO6jB+n7HzXr1z6Ea1c++zJ6ovaqBOe6l61UbCCItZk04nC1hsq/32dwvqwO7KjqhIGDN89mAQUR24bl1l/or8W05rWfp1dzSfYULXCl3vLLvUCQdRmVnQK/Nb+DrbhmHy9Dk6HVhDMfYuLAvBXirocN5c2GCG+B3lGZFgdDR1xWgJONcfKU89eLGP0ZIhwCXL7qymGne6EUzQ01/IeLcaYfy354m/KOXqoaaIT2q8QymkTLfgb1S9O0KWoMcmt6M1U6wMlAkhlFsK0q3ejIi6M53hRuOGc9oQCyXHtt/aHwdtK4EqUyOj6NO4EUoHaOstc1qz9rpdWZcCes6UvrPOcW+CEAGZMI6Mm+BRx8LCfWsWIdUZ+OAATmezyJXynuOwLfDkg9SA81Bit58AQ9JVpwJwtP7ZlUEf6l752Ond4JNSSXH7BApnf1XJX8ba9SHQYu8+IWqSr2+0o2KPpITnKw2VtkA6o4FTtXYV8Exo=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(366016)(7416014)(376014)(260925021311599003)(260925021911599003)(4143699003)(10067099003)(56012099006)(22082099003)(18002099003)(6133799003)(38070700021)(260925022911599003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?RWIwWGYvWUpuSUlkdmJha2lVV3FGbUNHYmljaTNmSytyNTR1OGxSaWFGSEZT?=
 =?utf-8?B?R0pnQ1EwOFBFcGwzWFNQbTJoeXdhbDlGZnE5eXBudHlWTFNUak9EK2M5ZUhE?=
 =?utf-8?B?cWdnYXgzOG1aTndHRUZQbWxkTTNlTHdZeXlVYWtVRDRFTVpuY2RqYmtnVjFx?=
 =?utf-8?B?NkNHWG5aZFlxT2RBU3poQzAzRHo1emNNZi9sNC9pTnEvMnQ1aXJDWVFHUGh2?=
 =?utf-8?B?YUxlMENpMUYvVWJlNG9FTlduSWh2SkpyeWRFVEtMN2ZPOGt0bU5ZYWZZSXZB?=
 =?utf-8?B?ZzduQll2OGFCRW9OQ0pKdHZ3bXFrNFowRkFRQkFYdHJhTC85RlUxV1FoMitL?=
 =?utf-8?B?WGg4RTZiZHRrQWRUVFF2UkV0aGF4R3k1c1YzL3FvWEREKzAzbjFzcHEzZU91?=
 =?utf-8?B?bzBRY29YbGhPc0hwZHM3Ykhkb3Z5UjZLdmRjNnVScE9UMmZWckh2V0dYNlZI?=
 =?utf-8?B?Tll1dU1lSStpcGFNRUx1TjFraGxsUEhFM2lUaHlZUVdUZW9XekZ0QTRFZFZV?=
 =?utf-8?B?djAxYjk3b1p0NERWeGt3YloxaTd6YnROUFIyYVpXYXBqeFJqVzhUOXQ3Y1VP?=
 =?utf-8?B?N0YvaFBvUlhlU0dvQ1JYU2VIUVFNMUJoNlJvbG5zNkc2dXRhL3J1Zm94UDhL?=
 =?utf-8?B?TUJSZUM5c2l0SlN2L2V2ZlZRQ2M0TzhzZUxENytIT3RUcEM4YXVVcy9BZ0xK?=
 =?utf-8?B?MTNwRXZIalIzWnJxTWo4RU5TeGFYVkw0VHNHSTBzMFI5WVNzbjFWY0Fubkto?=
 =?utf-8?B?bjNvTWk1M3ZkM2pnaXVEUUwrajNQQjQvNUZVL2dYdk1pd1VYOXpnRXFqOTNj?=
 =?utf-8?B?YkV5Vm81RjlMa1ptTEpwaHdzenVKbEdHd0h5cnBURTI5YmJpRzFqb0VIbHVl?=
 =?utf-8?B?MGFybEFnUURiNm9JeHpaQXE0SmFNeDNaak1WU3RNY0c5Tkpjd0F2b0IwK0RS?=
 =?utf-8?B?aFcyeFE5NXArRHV3bVNBWnNNZDV4T0FVaGFvVEIwc21JSjhqb2Ztci9pdENp?=
 =?utf-8?B?YTVDY05lZ1dWVWtWV0NrNEZlTmNJejI3MHFHN2wwRzFjeWJyZ1VpajRKYS9Q?=
 =?utf-8?B?Y2tkNkpPUzhHRHM5WFdJTzlqdlMxUG1ncWtFMXEyZWNqeUcxN1JkRVdqeUg5?=
 =?utf-8?B?dEZrc0JzN3dXV3hOZDYycUdNMlNKVzVYSlNzOVVvTEFjdlR0SFhsR0NRZVBY?=
 =?utf-8?B?UUphbWkrVmhDNnBPNlpoY0Q4UWcwbWQ2d3A0bDlSVkdYQnUwK1FNUUo2V0RH?=
 =?utf-8?B?SksvaHdUMi93UTZ5NWlxcldOa2FCWjNzMzh1UVJHZHF3QW56OWFpcmd1NUZV?=
 =?utf-8?B?Z2dhZ1ZwLys3SHhtSXlDQmprMW84Q1gwVEhMQS9nMTJ3dGMwcTVOeHkvNUNw?=
 =?utf-8?B?NndmMVNkdTZBN3Z2cGlyREV0OHlyaUt1TVVkWllRN25OQmVNNzFmTnEwZDNi?=
 =?utf-8?B?RFV3U0YzaVRnVEZEbFU0dCtPT0dSZ2Y4SjZsZUtJbDlDRGEvNWk1YU93eFU5?=
 =?utf-8?B?d3NUVUtlaTlXTmZ3VlBhK3cyY0poSGZNdmg2ZWJtUUcxVDhrNkZjclBhU1p5?=
 =?utf-8?B?azBwS29GNHVvWWllRFA2NFpoKzdYMGpobVhLRWFHemZZd1VYTitKcC9qUXQ0?=
 =?utf-8?B?K3hTZHpwUHdVWDhVZWk5SEorWWZlSHI1S0FrSytxNTY2NUphZkhsTFAvcGht?=
 =?utf-8?B?bk5tZE9IbnZtK1pRd0x2L3lIK05BQ3JmRi9kdE5HQ3o0bU91ZWt1bnlZRGYv?=
 =?utf-8?B?Y1VMM3BoZndSZXpmWktKL1FKZURJMVhLNHNVWUgzaTFsRk5ZUk91bk5pd2x3?=
 =?utf-8?B?NytVQmhmY2EvYloyVHdpWUtBY2swUkpDbHlGZDhWVlBVek9VVE84clhOckJG?=
 =?utf-8?B?Tk40Slo5SHVteGovRUVvMnN2REFZYkxQbjRqYWRPemhJRXRSRW9NTjBWSEdR?=
 =?utf-8?B?U1lmRHFPRFJmV2NvaCswTGhZNlZnbHFyQVZwRFBXcnlMUXN6ZXFLUHFKU2FR?=
 =?utf-8?B?NVhWWmtLbml6K0dNZzh4YUxvdmFTZGEyZ1lrMllTbUkraEtQRi9xeDRCOElR?=
 =?utf-8?B?eDZJRmdaYmk2U1Z5eUpCZDJrNlFNV296VlBOdmJndStkK0cxcGFUS2lxK0ps?=
 =?utf-8?B?ajV3UXVKelZVV0hTcUhFcU56ZXljNkVROE1JQXVZdUQ5OXpaYXk5S3ZQRlds?=
 =?utf-8?B?dmZxMUZpckZIQjJ1SUZvMGoxOURHaXJGMElKSlVYd2FpREV2UzF4YmxxTUhQ?=
 =?utf-8?B?Smx6R2ZNdTZxbUVPbklmcnRQMFRlK2NJZXlzUFRjZEhqbnIzQzZlTTZBTjRv?=
 =?utf-8?B?VVF3L0VBUCtRVVhtanJyQkpOcEtpcDI4TjdaTmh5eS9mY1pzY2Jkak9wTmlG?=
 =?utf-8?Q?3eh3oXbHElSTG2GM=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1CE2CF14CA075F43874435ED6CAA5830@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	piWYSLhQVLUhLHWLbHNIb7CzkJvaUSzQVVW9EU7yVsK4WVCWw4vCECjlE448qryx7gIhx1JrOqMbYvnYpCg0+QVhdlU7uPvmIthGvCrpXGdh1HkryweRMsMRMob5BF3rHntJ7GCNRKrjF2COVLbfhQti4VDi6MPhuDgIZZGph8gpqzD+hrxYXFkLqRmGcHPGXV0uabR4Cos2ewil7FZI/ZPVDwQtCy3VWy67jkqWYdsligWnBE7Kpm3R6h8Le98QXoNpkS7KI3d+J7L2aEqNi0qteDxNIEfvq3e4kIBjt462EF7pxEk0rr13s/tadLKeE+wZM5F3tYTAwcThEAWI/A==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 46422f5a-e772-4695-d17a-08df1afedb22
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Sep 2026 12:16:40.9925
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0HAQt4BoxA/AIdurhi4Ck+K3dgSMmHei+0+JrsOaoVubIHKlBmLaPltufU9oCYpMGvOg401q8hDLXo++5MG/Z01ZPPwRfaqEX85BJjCxV2E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PHXPR02MB11342
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI1MDA0OCBTYWx0ZWRfX5KtOCJ6Xqt3y
 xZKe944Dd0GSvJDHF30+lTqpx7xD8EVGlZ01ZK3G0j2TciYZjrbiM0/ETuJWvmEpy5gyUIHJGx5
 28jWpTCR1q4A0VLB7tOmAQV0pLczfvU=
X-Proofpoint-ORIG-GUID: CajnFQ81yokX03wanmBG6sZo3vve5LM2
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI1MDA0OCBTYWx0ZWRfX1wrqrqaF3SAG
 NWEGMRQ8zAwYyPHdG3rnUjWrjMpe0fU6RJbvX5iHbkZ1SB9SkY/Dq913PVNySsyZaCMeVGSIhRu
 BHt23repGoEh+4U3vr9AclDSLsJbIGNjUJKizyzBGwlzRt4Aaz3fG1OPc4zFJAa+y7zRf4aTbg+
 foXmTiRsbGVdBqaYHahKbSB44/y3bKanvsEg9glKUYE7IOT0Hs1zMO0RJFTeJumWinpK6DfW0bJ
 Q0ZfK+CTFk85jWc4l8+/vdbh8r/6cTTlqzXH5NwN2PafkAI8x6ybdrM/KLk915tRP6RrBI3XrTw
 Ir/n2nyvCj6UdJtcid0yZrrI9Tl23NPeln9ITCFge0KMX4efUunnri+UVnMHDciBJjAWwFXsxyl
 SwDLPZVahDju9tymLq2dQN8NmAMPJ4oVFXAgVx30ScZepfN3DCIZ3tJlX7iULLXVvQEv85JXDJc
 Lq5W0gadEwRw3trk6xA==
X-Authority-Analysis: v=2.4 cv=PJ2aavqC c=1 sm=1 tr=0 ts=6ab6662b cx=c_pps
 a=y8YxP5mruHbmkpqRckQjqQ==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VofLwUrZ8Iiv6rRUPXIb:22 a=y4UcunY2MAxhM4LwGdWI:22 a=20KFwNOVAAAA:8
 a=64Cc0HZtAAAA:8 a=rok4wjhScJExe7kjtJYA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: CajnFQ81yokX03wanmBG6sZo3vve5LM2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-25_02,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gMTYgU2VwIDIwMjYsIGF0IDg6MTXigK9QTSwgRXJpYyBBdWdlciA8ZXJpYy5hdWdl
ckByZWRoYXQuY29tPiB3cm90ZToNCj4gDQo+ICEtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tfA0KPiAgQ0FVVElPTjogRXh0
ZXJuYWwgRW1haWwNCj4gDQo+IHwtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tIQ0KPiANCj4gRnJvbTogU2hhanUgQWJyYWhh
bSA8c2hhanUuYWJyYWhhbUBudXRhbml4LmNvbT4NCj4gDQo+IEluY2x1ZGUgY3B1LWlkcmVncy5o
LmluYyBtdWx0aXBsZSB0aW1lcyB3aXRoIGRpZmZlcmVudCBkZWZpbml0aW9ucyBmb3IgdGhlDQo+
IFgtbWFjcm9zLiBUaGlzIHdpbGwgZ2VuZXJhdGUgdGFibGVzIGZvciBhbGwgQXJtNjQgSUQgcmVn
aXN0ZXJzIGFuZCB0aGVpcg0KPiBmaWVsZHMuIEFkZGl0aW9uYWxseSwgaW5pdGlhbGl6ZSB0aGUg
dGFibGVzIHdpdGggYWxsIGFyY2hpdGVjdHVyYWxseSBkZWZpbmVkDQo+IHZhbHVlcy4gVGhlc2Ug
dGFibGVzIHdpbGwgYmUgY29uc3VtZWQgYnkgdGhlIHByb3BlcnR5IGxheWVyIGluIGZ1dHVyZQ0K
PiBwYXRjaGVzLg0KPiANCj4gTm90ZToNCj4gVGhpcyB0cmlnZ2VycyBhIG1pbm90IGNoZWNrcGF0
Y2ggZXJyb3IgYnV0IEkgcHJlZmVyIHRvIGtlZXAgdGhlIGNvbWEgaW4NCj4gdGhlIG1hY3JvLg0K
PiBFUlJPUjogTWFjcm9zIHdpdGggY29tcGxleCB2YWx1ZXMgc2hvdWxkIGJlIGVuY2xvc2VkIGlu
IHBhcmVudGhlc2lzDQo+ICsjZGVmaW5lIElEUkVHX0ZJRUxEX0FSQ0hfVkFMKHYpICh2KSwNCj4g
DQo+IENvLWF1dGhvcmVkLWJ5OiBLaHVzaGl0IFNoYWggPGtodXNoaXQuc2hhaEBudXRhbml4LmNv
bT4NCj4gU2lnbmVkLW9mZi1ieTogS2h1c2hpdCBTaGFoIDxraHVzaGl0LnNoYWhAbnV0YW5peC5j
b20+DQo+IFNpZ25lZC1vZmYtYnk6IFNoYWp1IEFicmFoYW0gPHNoYWp1LmFicmFoYW1AbnV0YW5p
eC5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IEVyaWMgQXVnZXIgPGVyaWMuYXVnZXJAcmVkaGF0LmNv
bT4NCj4gDQpMR1RNLCBvbmx5IG1pbm9yIG5pdHMuDQoNCj4gLS0tDQo+IHY3IC0+IHY4DQo+IEFk
YXB0YXRpb24gYWZ0ZXIgcmVtb3ZhbCBvZiBzdHJ1Y3QgQXJtSWRSZWdBcmNoVmFsDQo+IA0KPiB2
NSAtPiB2Ng0KPiAtIHJlc3RvcmVkIHN1cHBvcnQgb2YgZW51bSB2YWx1ZXMNCj4gLS0tDQo+IHRh
cmdldC9hcm0vY3B1LWlkcmVncy5jIHwgOTYgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysNCj4gdGFyZ2V0L2FybS9tZXNvbi5idWlsZCAgfCAgMSArDQo+IDIgZmlsZXMg
Y2hhbmdlZCwgOTcgaW5zZXJ0aW9ucygrKQ0KPiBjcmVhdGUgbW9kZSAxMDA2NDQgdGFyZ2V0L2Fy
bS9jcHUtaWRyZWdzLmMNCj4gDQo+IGRpZmYgLS1naXQgYS90YXJnZXQvYXJtL2NwdS1pZHJlZ3Mu
YyBiL3RhcmdldC9hcm0vY3B1LWlkcmVncy5jDQo+IG5ldyBmaWxlIG1vZGUgMTAwNjQ0DQo+IGlu
ZGV4IDAwMDAwMDAwMDAuLjE5OWQ1OTMxNTMNCj4gLS0tIC9kZXYvbnVsbA0KPiArKysgYi90YXJn
ZXQvYXJtL2NwdS1pZHJlZ3MuYw0KPiBAQCAtMCwwICsxLDk2IEBADQo+ICsvKg0KPiArICogICBB
Uk0gSUQgcmVnaXN0ZXIgZmllbGQgdGFibGUuDQo+ICsgKg0KPiArICogICBCdWlsZHMgdGhlIHBl
ci1pZC1yZWdpc3RlciBmaWVsZCBkZXNjcmlwdG9yIGFycmF5cyBhbmQgdGhlIGdsb2JhbA0KPiAr
ICogICBhcm1faWRyZWdzW10gdGFibGUuDQo+ICsgKg0KPiArICogIFNQRFgtTGljZW5zZS1JZGVu
dGlmaWVyOiBHUEwtMi4wLW9yLWxhdGVyDQo+ICsgKi8NCj4gKyNpbmNsdWRlICJxZW11L29zZGVw
LmgiDQo+ICsjaW5jbHVkZSAicWVtdS9lcnJvci1yZXBvcnQuaCINCj4gKyNpbmNsdWRlICJxYXBp
L2Vycm9yLmgiDQo+ICsjaW5jbHVkZSAiY3B1LmgiDQo+ICsjaW5jbHVkZSAiY3B1LWlkcmVncy5o
Ig0KPiArDQo+ICsvKg0KPiArICogR2VuZXJhdGUgYW4gYXJyYXkgb2YgYXJjaGl0ZWN0dXJlbHkg
ZGVmaW5lZCB2YWx1ZXMgZm9yIGVhY2ggZmllbGQNCj4gKyAqIGFzc29jaWF0ZWQgd2l0aCBlbnVt
IHZhbHVlcw0KPiArICovDQo+ICsNCj4gKyNkZWZpbmUgSURSRUdfU1RBUlQocmVnKQ0KPiArI2Rl
ZmluZSBJRFJFR19FTkQocmVnKQ0KPiArI2RlZmluZSBJRFJFR19GSUVMRChyZWcsIGZpZWxkLCBz
aGlmdCwgbGVuZ3RoKQ0KPiArI2RlZmluZSBJRFJFR19GSUVMRF9TVEFSVChyZWcsIGZpZWxkLCBz
aGlmdCwgbGVuZ3RoKSBcDQo+ICsgICAgc3RhdGljIGNvbnN0IHVpbnQ2NF90IHJlZyMjXyMjZmll
bGQjI19hcmNoX3ZhbHNbXSA9IHsNCj4gKyNkZWZpbmUgSURSRUdfRklFTERfQVJDSF9WQUwodikg
KHYpLA0KPiArI2RlZmluZSBJRFJFR19GSUVMRF9FTkQocmVnLCBmaWVsZCkgXA0KPiArICAgIH07
DQo+ICsNCj4gKyNpbmNsdWRlICJjcHUtaWRyZWdzLmguaW5jIg0KPiArDQo+ICsjdW5kZWYgSURS
RUdfU1RBUlQNCj4gKyN1bmRlZiBJRFJFR19FTkQNCj4gKyN1bmRlZiBJRFJFR19GSUVMRA0KPiAr
I3VuZGVmIElEUkVHX0ZJRUxEX1NUQVJUDQo+ICsjdW5kZWYgSURSRUdfRklFTERfRU5EDQo+ICsj
dW5kZWYgSURSRUdfRklFTERfQVJDSF9WQUwNCj4gKw0KPiArLyogZ2VuZXJhdGUgYW4gYXJyYXkg
b2YgcGVyLXJlZ2lzdGVyIEFybUlkUmVnRmllbGRbXSBkZXNjcmlwdG9ycyAqLw0KPiArDQo+ICsj
ZGVmaW5lIElEUkVHX1NUQVJUKHJlZykgXA0KPiArICAgIHN0YXRpYyBBUk02NFN5c1JlZ0ZpZWxk
IHJlZyMjX2ZpZWxkc1tdID0gew0KPiArDQo+ICsjZGVmaW5lIElEUkVHX0VORChyZWcpIFwNCj4g
KyAgICB9Ow0KPiArDQo+ICsjZGVmaW5lIElEUkVHX0ZJRUxEX1NUQVJUKHJlZywgZmllbGQsIF9z
aGlmdCwgX2xlbmd0aCkgIFwNCj4gKyAgICB7ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBcDQpTb21lIFwgYXJlIHRhYmJlZCwg
YW5kIG90aGVycyBhcmUgbm90Lg0KPiArICAgICAgICAubmFtZSA9ICNmaWVsZCwgXA0KPiArICAg
ICAgICAuaW5kZXggPSByZWcjI19JRFgsIFwNCj4gKyAgICAgICAgLnNoaWZ0ID0gKF9zaGlmdCks
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBcDQo+ICsgICAgICAg
IC5sZW5ndGggPSAoX2xlbmd0aCksICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgXA0KPiArICAgICAgICAuYXJjaF92YWxzID0gKHVpbnQ2NF90ICopcmVnIyNfIyNmaWVs
ZCMjX2FyY2hfdmFscywgICAgXA0KPiArICAgICAgICAuYXJjaF92YWxzX2NvdW50ID0gQVJSQVlf
U0laRShyZWcjI18jI2ZpZWxkIyNfYXJjaF92YWxzKSwgICAgIFwNCj4gKyAgICB9LA0KPiArDQo+
ICsjZGVmaW5lIElEUkVHX0ZJRUxEKHJlZywgZmllbGQsIF9zaGlmdCwgX2xlbmd0aCkgXA0KPiAr
ICAgIHsgXA0KPiArICAgICAgICAubmFtZSA9ICNmaWVsZCwgXA0KPiArICAgICAgICAuaW5kZXgg
PSByZWcjI19JRFgsIFwNCj4gKyAgICAgICAgLnNoaWZ0ID0gKF9zaGlmdCksIFwNCj4gKyAgICAg
ICAgLmxlbmd0aCA9IChfbGVuZ3RoKSwgXA0KPiArICAgIH0sDQo+ICsNCj4gKyNkZWZpbmUgSURS
RUdfRklFTERfQVJDSF9WQUwodikNCj4gKw0KPiArI2RlZmluZSBJRFJFR19GSUVMRF9FTkQocmVn
LCBmaWVsZCkNCj4gKw0KPiArI2luY2x1ZGUgImNwdS1pZHJlZ3MuaC5pbmMiDQo+ICsNCj4gKyN1
bmRlZiBJRFJFR19TVEFSVA0KPiArI3VuZGVmIElEUkVHX0VORA0KPiArI3VuZGVmIElEUkVHX0ZJ
RUxEDQo+ICsjdW5kZWYgSURSRUdfRklFTERfU1RBUlQNCj4gKyN1bmRlZiBJRFJFR19GSUVMRF9F
TkQNCj4gKyN1bmRlZiBJRFJFR19GSUVMRF9BUkNIX1ZBTA0KPiArDQo+ICsvKiBnZW5lcmF0ZSBh
biBhcnJheSBvZiB0b3AgbGV2ZWwgSUQgcmVnaXN0ZXJzICovDQo+ICsNCj4gKyNkZWZpbmUgSURS
RUdfRU5EKHJlZykNCj4gKyNkZWZpbmUgSURSRUdfRklFTEQocmVnLCBmaWVsZCwgc2hpZnQsIGxl
bmd0aCkNCj4gKyNkZWZpbmUgSURSRUdfRklFTERfU1RBUlQocmVnLCBmaWVsZCwgc2hpZnQsIGxl
bmd0aCkNCj4gKyNkZWZpbmUgSURSRUdfRklFTERfQVJDSF9WQUwodikNCj4gKyNkZWZpbmUgSURS
RUdfRklFTERfRU5EKHJlZywgZmllbGQpDQo+ICsNCj4gKyNkZWZpbmUgSURSRUdfU1RBUlQocmVn
KSBcDQo+ICsgICAgW3JlZyMjX0lEWF0gPSB7IFwNCj4gKyAgICAgICAgLm5hbWUgPSAjcmVnLCBc
DQo+ICsgICAgICAgIC5pbmRleCA9IHJlZyMjX0lEWCwgXA0KPiArICAgICAgICAuZmllbGRzID0g
cmVnIyNfZmllbGRzLCBcDQo+ICsgICAgICAgIC5maWVsZHNfY291bnQgPSBBUlJBWV9TSVpFKHJl
ZyMjX2ZpZWxkcyksIFwNCiAgICAgICAgICAud3JpdGFibGVfbWFzayA9IDBVTEwsIFw/DQo+ICsg
ICAgfSwNCj4gKw0KPiArQVJNNjRTeXNSZWcgYXJtNjRfaWRfcmVnc1tOVU1fSURfSURYXSA9IHsN
Cj4gKyNpbmNsdWRlICJjcHUtaWRyZWdzLmguaW5jIg0KPiArfTsNCj4gKw0KPiBkaWZmIC0tZ2l0
IGEvdGFyZ2V0L2FybS9tZXNvbi5idWlsZCBiL3RhcmdldC9hcm0vbWVzb24uYnVpbGQNCj4gaW5k
ZXggMDM2OWY5NmI0Yy4uMzg0ZDkwYzUzMCAxMDA2NDQNCj4gLS0tIGEvdGFyZ2V0L2FybS9tZXNv
bi5idWlsZA0KPiArKysgYi90YXJnZXQvYXJtL21lc29uLmJ1aWxkDQo+IEBAIC0zMCw2ICszMCw3
IEBAIGFybV9jb21tb25fdXNlcl9zeXN0ZW1fc3MuYWRkKHdoZW46ICdUQVJHRVRfQUFSQ0g2NCcs
IGlmX3RydWU6IGZpbGVzKA0KPiANCj4gYXJtX2NvbW1vbl9zeXN0ZW1fc3MuYWRkKGZpbGVzKA0K
PiAgICdhcm0tcW1wLWNtZHMuYycsDQo+ICsgICdjcHUtaWRyZWdzLmMnLA0KPiApKQ0KPiBhcm1f
c3lzdGVtX3NzLmFkZCh3aGVuOiAnQ09ORklHX0tWTScsIGlmX3RydWU6IGZpbGVzKCdoeXBfZ2Ri
c3R1Yi5jJywgJ2t2bS5jJykpDQo+IGFybV9zeXN0ZW1fc3MuYWRkKHdoZW46ICdDT05GSUdfSFZG
JywgaWZfdHJ1ZTogZmlsZXMoJ2h5cF9nZGJzdHViLmMnKSkNCj4gLS0gDQo+IDIuNTMuMA0KPiAN
Cg0K
