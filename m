Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86DBB40681D
	for <kvmarm@lists.linux.dev>; Thu, 20 Aug 2026 09:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787219390; cv=fail; b=kHl4pFqlwHuQ1xOnUOlNe2ZafkeWjL3EAJy4k35OOabLHVdOz1pmIVHbBRhcLuoH6YzpU6SBWQjQPX7qDiaBtJZwr4FBdQwgUYi+joTV5wt2DWd3w6dfO1cHiWMuzZhNRNSky7q74nPN4t8VFDbYHhDi0P1RFaInJ8TFE8C99YE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787219390; c=relaxed/simple;
	bh=Tq2G1dU3V0E8FsbyA2CeSuXgL0fU7R0+pdQeINokDmg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=eYKBmMoHMNCrexS7rTYcO8TEr4ABLRCpCKI9wemhpo1nLqwjoAf5j1bEMHRPt8+ZgKXDW+a0kmkdMb0vwxMVHSOxdboRKbEP/7moygu0d0zwKUgIrr8VQ7r/EAUJVm0ma1vJRwVANZyNpaFPoyYKlnYN+zaQdO+kcUCKNeBzlEg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=PylITztx; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=PqFDu/b+; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="PylITztx";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="PqFDu/b+"
Received: from pps.filterd (m0127840.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67JLEAQL1227058;
	Thu, 20 Aug 2026 02:49:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=Tq2G1dU3V0E8FsbyA2CeSuXgL0fU7R0+pdQeINokD
	mg=; b=PylITztxlnnRwMBg7h7Za+e4au/12gOvwR3QQjJdSYtWu9fcdXYu0X7AE
	ZzgMrJEiy1T+nJXkle2da5YIlP3PFs1bMH0q7L2+vxdkN91cvECpP8bvURxNGPiL
	nIkr+gnVoVtuZTcwcKk4N8dv+MdkSulEsHjlDESpEsj8BdYyqK6vckOsKZT8szPF
	j4qGRgBqkGuqUf82brBvNsDVxLel/NTvqOyj8U9qjz8SmSGzeLxwlhK8SDz/ovfu
	hC8/t0dqDW3O2Q7jyVkMsakGY8OtyYfabd8jpuMEHGEN6x4xDiLrb7NHx8wkQwOm
	ej+8GiNU0vv6DqTfguvtWyMtadgvg==
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11023135.outbound.protection.outlook.com [40.93.201.135])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4g4uw5nbmx-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 20 Aug 2026 02:49:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NMFU1oAs9cOt8xtuAVfzYmTsPfKeyqJbb/D+Gy8geAjiGjdME1LvbcJ+o7arvv0sCwyQX2WFee9wjln7vW0gKCko0suS7EfirKQjUBmhE27UIz2d1dV2VfUnSM2BbnjWwtJ/wT2p81ioGcZKzX0rpDU1BpACAkDsRS8PHUarKnWfrkZ6N7DYLwi7OXH9zxr2++vFnGY0qorcoZDmKAmoq8yOb1+c5NlDI79aX0mZjy1ADbqv//S7LBuzkPjY21pIpg2iq1iF4k5m6CcmGCI38p83Pc0Zuy0l6vQ35QcOjQmCGs4uiQtl6aMNqsJQ6c/0SRcT3+yQjNOFQvf1STsXBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Tq2G1dU3V0E8FsbyA2CeSuXgL0fU7R0+pdQeINokDmg=;
 b=BHu+9nUOkYrwk5YrIAE2UDC8uSsIB7lxiNt8BJJZllEze4c+6Pphry9Sglk26SKwNRG47JvWcb//2/aeVgHB9WG9/H0NnzXKSuoTsmFZXckdjktgSxHSpoi7X+Se4iivN++HlX77jZRbGXxlL2bl4JoV7+3opVgDAZSCtrwiMMv4MqJ5PTjlGqtPe8LO/mxfoBSF29L0y5L1Al+fYFXvVUVbyE5irxh+fxcEt+/TNXGN2UssXFmtSWg+gdmcspNh1mIjhT/rctDtB0L3PfRr9+VVnhCKuRoNTOZfHXC/nSvKh17csayiTlnfOonTZFGG24FByrGCf6K2iBg5nvmgDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tq2G1dU3V0E8FsbyA2CeSuXgL0fU7R0+pdQeINokDmg=;
 b=PqFDu/b+xk+MPrdUr3E1c+NpLgDEergcosBFXWh2ZFzM/mgC5D2nxoKqhtYoe4R48Gdc+Rl75q6WU9o3TvVqltSydJ142VlODW3Y5uEtEt1oBIhsdU7S4Oc5pwXUBeEAVGj2GDNjWetFPBTS+EJsLiVQOYWTZf/TdsBY0fB2yfuY2YjOEXxILdShnM0kVR7ygbVGV1qAaF+wD7z86nP1LUMJkDI7OmTveqD2x/s7lq895FmgUPlS0/2Ef9cUAMbOkGEmXD0YqwPGHD/GtWJ2S3z9eWnVGGg04LTLWCdNKpami8Ww5uwzbjVdTOcpmoUsS1iufReGouLk7qYalUVIjg==
Received: from PH0PR02MB7557.namprd02.prod.outlook.com (2603:10b6:510:54::17)
 by DM6PR02MB6667.namprd02.prod.outlook.com (2603:10b6:5:219::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.9; Thu, 20 Aug
 2026 09:49:30 +0000
Received: from PH0PR02MB7557.namprd02.prod.outlook.com
 ([fe80::4917:bc05:4373:6bef]) by PH0PR02MB7557.namprd02.prod.outlook.com
 ([fe80::4917:bc05:4373:6bef%4]) with mapi id 15.21.0339.007; Thu, 20 Aug 2026
 09:49:30 +0000
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
Subject: Re: [RFC PATCH v7 11/18] arm/kvm: Initialize all writable ID
 registers from host
Thread-Topic: [RFC PATCH v7 11/18] arm/kvm: Initialize all writable ID
 registers from host
Thread-Index: AQHdMIkssMfvApN8EE6PJReIPUSAIw==
Date: Thu, 20 Aug 2026 09:49:30 +0000
Message-ID: <1547C742-1711-40CC-A03D-8E15B18BB35E@nutanix.com>
References: <20260726153221.24773-1-eric.auger@redhat.com>
 <20260726153221.24773-12-eric.auger@redhat.com>
In-Reply-To: <20260726153221.24773-12-eric.auger@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR02MB7557:EE_|DM6PR02MB6667:EE_
x-ms-office365-filtering-correlation-id: c3578921-5280-4772-2d50-08defea05500
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|23010399003|7416014|376014|366016|1800799024|6133799003|38070700021|18002099003|22082099003|4143699003|56012099006|10067099003|3023799007;
x-microsoft-antispam-message-info:
 4YUsdCXrn0xlLx6SIV6Dx+VhBKLQcJzh8Po2cXDTIruBCzSoWxdA+nyyDSXO1W5xnbH9iPyzA7gwCtotBXGZiQDrxyMsjFKEGY7oSI/5XIQ+D8SCxBdqaG7VKlge5IgOjB71DzrS77/YdBQM37vPoPerpMPA3xdDJCIvasrT5XRBziIjTUQ501u7s4rYU3tORzYS5S+04ztki+RMNupsDX6PhocG7Y23kPwDtr1qqB06if9PuvgqmXu9iX5gVXPYk9T7mI36Tn5DYqpMt3vzZ9GRuNlOJhldvs7F/ZA79kV0Yr1QI+cCSU4w4ULtohKMToKad3DEbAqGUiAkbQuTyJxIXl/mZDKZzaoyxa7mgz146YXEZuzyj9mB2ZCpmIN7sOabJ5std0elDXBSVNQ19/CyUwY1gp8LyQzLlfmUnttiyzZYXe5Vh/1s5XyCIgSE1el0iuT/RAsgQkbl6b0eo0BrO7xRLqeVcVMvP1OSAQTWqTMwgewInx7qSAOxEFlOIJLiprLLZYKLxuN03nXtWY5EvgiwmS+oDee+Lue/5wXb5NlQAsdLayQFAbTqmMqGWJ4/c6KGb69FrhRcUn7CZVgZ88HfNcjbgQ/H8cwIQkMYzA2m/2WpZM6n30Bs/M9ydlCUcFx/6uOgU+iuUaAVTgk0J16kHUTlyml8+DNjkb2PCVGct7ptPKsVdgzWnqTsqt+vpS03s21FtduevaT9rxSwGUIRz4enzbe36aRV9eE=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR02MB7557.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(366016)(1800799024)(6133799003)(38070700021)(18002099003)(22082099003)(4143699003)(56012099006)(10067099003)(3023799007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?Njdqc3paUDN6YnVIdnlzRWtOY0Y4bjRnaGUzbjRXRm54WW1hMWR2anJoOC9X?=
 =?utf-8?B?V3NJRU1OVjJReisyUkF2Z0lSdThuem92bm0xSGFLanpxZmE2WDNoVUFTTDlu?=
 =?utf-8?B?dzlUdVNjMkFIbDJtcVBIajl1M2N1VnNYTVpXTU8rMityeENrbHVpa3QyUXRT?=
 =?utf-8?B?RkFyd2QvSU1lbzBCQTBSNzQyZFppMFpTLzdlcmY4TmN4YmpTRnVZdWhBUGww?=
 =?utf-8?B?UVNQVmRaYXRnWW10ZW53L0w5SEp4SWw0V016TVJ0eGRTMnNOYmpCVnBFanph?=
 =?utf-8?B?TUp1ZWROblpvSG5HcjEycDk0cHBwdnhtdVlIVC9wT0w4V2Qrb0xwU3hGRzBS?=
 =?utf-8?B?cEVTeVZLVTAya09oZ3k2eXk0YlZjc3ZDY2orSGYrb0M0aHBkR3p4Rzl4ekly?=
 =?utf-8?B?amlOT2k4UzdoNDFDSDBST3RLamJKNlhHMXVPaHlFQnFVTnBLSlJxUjAvbTlS?=
 =?utf-8?B?bU85VlNwc1BtekZIZGZqaVkza2x1aHZHeklOMEtnWmIxK2thQmt0Yk81TjQ2?=
 =?utf-8?B?SXBRdHBGZDZFaEdYY0dtcXZ5L2J3VzhOSzIwTUpFdFJkUDNvak9uaSs5cFBM?=
 =?utf-8?B?T2VtNUg3UXg1R3ppSW0wSzhLYzB2ZW9YcTRabGZsaUdQOFV4N0Q0WlFsUG9y?=
 =?utf-8?B?dTluWDh1aHdSckdDRVRoaDNybnRRdnVZcHFpanZJaHVDY2FNeHpZSlA2QXpo?=
 =?utf-8?B?alJsRnJQeUN4WVdhQzI3ZVZkdkxFZ2ZTMGJLcC9jQ1hMY2xsdVBaRWFWMTdT?=
 =?utf-8?B?T0lZejVScmw0UjVraU9CL01Yb3JQRDlYdHZMSGlXK2l0UjN0UFBUYkJZZnNU?=
 =?utf-8?B?emJpREJBcDlpNk8vMFZpbGg0SnlCMmcxWEhGaEJNQTcvdEFUTEg0eENrWG8z?=
 =?utf-8?B?VnBzODBJd1VpbVV6UCs3Z1plQlhSV1NiWitzWlZsTk53Q0ZYRFdqNjRwVGNj?=
 =?utf-8?B?aG1GUTlkM3E3RC9wa0xmeDZRdnVrTmZUeXRMbGR4MDRKanVYanFHcDUyTzhi?=
 =?utf-8?B?NFBvZHphaGFmTnBLdGlEWTFKWTNPR1A0YlVtUnlENm9tbGU2MERXTTJSU0Fj?=
 =?utf-8?B?OHdPc3pSVHFkbkdGaVBEQURjMFhqNWEvd1I5WXppZ3J3am14ZmgxU0tlWjhh?=
 =?utf-8?B?Z1JjYmVjWmdMZ0F4RWZrTnJObkdYUEVQaXp4aTVEeGp2bUIwMzJhSHliNC9i?=
 =?utf-8?B?a0hhUFFRakxsRlgzK1c0cWM0MHBQckJBeEFxRHIvV3J0LzY3bE9FRVFjWUxS?=
 =?utf-8?B?ZHdoS1RMOWhXS05aSXNwQ2tzWjNFNXZGM0VnSTVxTStwTVZzVnE5aGx2ZDlG?=
 =?utf-8?B?ZzBlMUtDNWlqVm9LaE45VWUrdWRNQ2VTeE5YTGtqcWNXQnlVMmh0OHRLbHN4?=
 =?utf-8?B?L3kvY3VmTDZwb2hwRlJSbW0yRE5PK2Rxd1h5NENPR2x0UWpMbmhDS2FrMVEz?=
 =?utf-8?B?d1V0YVpwZmJUQitRRDgvclhlblNBZkEyVU9JOWVvMzlxQy9RNG9sOEtGdS8w?=
 =?utf-8?B?OTZ2QkpNc3lMeHY0NGJxT3VRTXRHQkFjemd6cllOOEZaaFZ2TmVYRTRTRS9Q?=
 =?utf-8?B?d1ByNFFiZ2N0OVMxTUJFOEw4emd1RGd4NUZ1cEg0RUw2NitWRCtLZmN2WG9x?=
 =?utf-8?B?NXZnYXZXL0tla3NwaGp2VDJ3Q2xIR21OYnQ3eUFVVDN2R2FqQ1djTXVyY3N0?=
 =?utf-8?B?OTh3Qmd2R3pEajlzYktuL3JRaWlOb2NXaHdIZ0R6VFFTMjliMHVMeUx3ejhu?=
 =?utf-8?B?ZXVQQ3NCRlRKRE9MUS9NZ1B4bFFEZys3WGRQOG1FQXlsOWliM2pSN3dLai9t?=
 =?utf-8?B?Z2gxSkFrS3lYUytaRTk5MDZSblNwTnRQRERwWnlEcWxwWWdtaHRHY1c2WHJ3?=
 =?utf-8?B?ZG8xZVlvZ05yWllVOU9NemxSOVRUWG9IMnlaSGpoNUh6NnpPRnBvdVpOZURC?=
 =?utf-8?B?VmRwd0pHWk5icXo0QzBtV0c1d2hvMHoxakhzd0NwQVVwZFQ0VW1KekxnZXBx?=
 =?utf-8?B?SU45akZ5UEN0d1FOR0NVTy9NeTVMa2ZPRGc0dklyN1ZES3R5YWVGKzJqZ2JW?=
 =?utf-8?B?RWZxMnhMbm1hSXpHeTE1anFRSzFJSytTc0hkZUZWV1Nuc2h6QWcxeHQ4LytC?=
 =?utf-8?B?YVBWNEF6YXR3aDJVUk9qVmtGaTVSdWRqaGl4c1ZCRW9FUEpyTmF1dWVOMmdW?=
 =?utf-8?B?WjNnZE5nME1tZXZ0WGh2WmNUL3k3N1grRnFoNGg2MnA4OURLVW5YK1IvbjJn?=
 =?utf-8?B?M2haMjBhRml0cldEWWRHOEJRSnlCTVdmMHNjMTdUZ2phRENPaEVSQlBTcVlL?=
 =?utf-8?B?UkNtUWVVdDlPODEwYUFhdzlDaXhrNmxEU0g1Qm9GWjhiL21IVXV4VUFnZVYv?=
 =?utf-8?Q?q5B1Was28ESvoKB0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4D1555B0CC9B8C4F97FA21F5CE23A5AC@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	gmytobT9RvMyrObRcVBLANulymRhooCFCsFphxL3OyLJ8px8eThqJ9zW/teDcooDN1RaZXA7E/0wEfqGb28zP33CXSEKZyv9J8Xi0P9FFsCMRL5RtziPRIHJuVdUjB9la2EUTMjbaGqPeSdkewV0+MyYSGBYSRIQLyLGdAuOEaXorrV+o5q7frzAAhMizE2j9IBL2Wig8M6mRkhlsqaV0ocwiHsNAo/nryn8qFe9AwCzdZvy84puacwjdzAWyHC8qz7jjyAk+L/5UF1z6O+kfr+XVhZfq1QMsHMdiAcedMpT404s4PF4WR/d6dHxvhhnynxFZ9IzLDhI5PNxZ6yqgA==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR02MB7557.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3578921-5280-4772-2d50-08defea05500
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Aug 2026 09:49:30.6860
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yC823lEB3z9QllswSUPbKKGdTGVET3c7e3BwHn0P018qDVzDgL18G+E1kAE8u2dY6PYxztZUSkGk9kO9zbzNu/y0j1ZMciDrGgwhD4flYWI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR02MB6667
X-Authority-Analysis: v=2.4 cv=INwyzAvG c=1 sm=1 tr=0 ts=6a86cdad cx=c_pps
 a=Ke4oXhF3hNgZYysaZJC1nw==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Sv0fKeRqtYgA:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VofLwUrZ8Iiv6rRUPXIb:22 a=_-M8LpHI31CeLmyZm6wg:22 a=20KFwNOVAAAA:8
 a=64Cc0HZtAAAA:8 a=BCQ71Y6UH9PdGioOhYkA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYwODIwMDA3MiBTYWx0ZWRfX3UbuKVLS0or+
 5ZucaF2U0G/S+dpYs/gl2NJ7fJWcZYLsSwDi6hfL4fArNa4I6qJd6uvLb0RFOuhTMRQ4UhC9DRF
 YfCYyuT4ItnoKX60uph+NSxtRAbnIug=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODIwMDA3MiBTYWx0ZWRfX6R3JQYO2aMJp
 jP15qpMD+WA+pwzXmoyFwfIMCq3wyYzhrBNCpfu6UnhT+PqCEg+8pzb1cB957Vi3b/NXr1gfK1e
 QIcZCrZu6Sf2WJ1uaOA52pZoEcvnBJQeIhUDsz1If9yIp+4rYSBrncA+Vy05K1dHb0+/aYvxS/9
 l88V6zyhlxvVhZ+poOwXNrycq6C8bvgKwJ3nrwBZysPFX+3KOPh/XQjD/Fg69Lw5AXOGjBPcrk6
 eed2e1U+Cx/xRlaKiePiOaLg1G5dMZAbOk5YZQJ1I9R1ezJ+aSyAsvff1hdy9x2TJNAEe7w+Qxb
 4oiq7QHVTo2HshTLXapds7cpDlATFgd7uRquWF4u9iVCt7QwllUGmE2wqycA+tLSghzHX/Pr40w
 gKLqcYa3Ic6pr9lEorDcXNGal/sNcv3VDoSHf35eLtZsKx+UmP3Nx+HEefjSDWALOAGXqh94bAW
 jh9ChVlK1jV3t0uSqBQ==
X-Proofpoint-ORIG-GUID: jLnfYHcfhFD3BjGSC7PLUjgCD2dfvGuJ
X-Proofpoint-GUID: jLnfYHcfhFD3BjGSC7PLUjgCD2dfvGuJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-19_06,2026-08-19_02,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gMjYgSnVsIDIwMjYsIGF0IDg6NTnigK9QTSwgRXJpYyBBdWdlciA8ZXJpYy5hdWdl
ckByZWRoYXQuY29tPiB3cm90ZToNCj4gDQo+ICEtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tfA0KPiAgQ0FVVElPTjogRXh0
ZXJuYWwgRW1haWwNCj4gDQo+IHwtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tIQ0KPiANCj4gV2Ugd2FudCB0byBhbGxvdyBv
dmVyd3JpdGluZyB3cml0YWJsZSBmaWVsZHMgb2Ygc29tZSBJRCByZWdpc3RlcnMuDQo+IEhvd2V2
ZXIgY3VycmVudGx5IHNvbWUgb2YgdGhlbSBhcmUgbmV2ZXIgdG91Y2hlZCwgbmVpdGhlciByZWFk
IG5vcg0KPiB3LiBFeGFtcGxlcyBhcmUgQ0xJRFJfRUwxLCBDVFJfRUwwLCBSRVZJRFJfRUwxLCBN
SURSX0VMMS4NCj4gDQo+IFdlIHdhbnQgdG8gaW5pdGlhbGl6ZSB0aGVtIGZyb20gdGhlIGhvc3Qg
dmFsdWUsIGFsbG93IG92ZXJ3cml0ZQ0KPiBhbmQgd3JpdGUgYmFjayBmb3Iga3ZtIGFmdGVyd2Fy
ZHMuIFRoaXMgcGF0Y2ggaW1wbGVtZW50cyB0aGUNCj4gaW5pdGlhbGl6YXRpb24uDQo+IA0KPiBJ
bnRyb2R1Y2UgYSBuZXcgZ2V0X2hvc3RfY3B1X2lkcmVncygpIGhlbHBlciB0aGF0IGdldHMgdGhl
IGhvc3QNCj4gdmFsdWVzIGZvciBhbGwgd3JpdGFibGUgSUQgcmVncyBhbmQgc3RvcmUgdGhlbSBp
biBpc2FyLmlkcmVnc1tdLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogRXJpYyBBdWdlciA8ZXJpYy5h
dWdlckByZWRoYXQuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBDb3JuZWxpYSBIdWNrIDxjb2h1Y2tA
cmVkaGF0LmNvbT4NCj4gDQo+IC0tLQ0KPiANCj4gdjYgLT4gdjcNCj4gLSByZW1vdmUgdmNwdSBm
cm9tIHByb3RvdHlwZXMgKEtodXNoaXQpDQo+IA0KPiB2NSAtPiB2Ng0KPiAtIGRvIG5vdCBjaGVj
ayB3cml0YWJsZV9tYXAgYW55bW9yZQ0KPiAtLS0NCj4gdGFyZ2V0L2FybS9rdm0uYyAgICAgICAg
fCA5NiArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrLQ0KPiB0YXJnZXQv
YXJtL3RyYWNlLWV2ZW50cyB8ICAyICsNCj4gMiBmaWxlcyBjaGFuZ2VkLCA5NiBpbnNlcnRpb25z
KCspLCAyIGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL3RhcmdldC9hcm0va3ZtLmMg
Yi90YXJnZXQvYXJtL2t2bS5jDQo+IGluZGV4IGQyNzBmOTg3MGUuLjRmOWIwYTU1OWQgMTAwNjQ0
DQo+IC0tLSBhL3RhcmdldC9hcm0va3ZtLmMNCj4gKysrIGIvdGFyZ2V0L2FybS9rdm0uYw0KPiBA
QCAtNDMsNiArNDMsNyBAQA0KPiAjaW5jbHVkZSAiaHcvYWNwaS9naGVzLmgiDQo+ICNpbmNsdWRl
ICJ0YXJnZXQvYXJtL2d0aW1lci5oIg0KPiAjaW5jbHVkZSAibWlncmF0aW9uL2Jsb2NrZXIuaCIN
Cj4gKyNpbmNsdWRlICJjcHUtaWRyZWdzLmgiDQo+IA0KPiBjb25zdCBLVk1DYXBhYmlsaXR5SW5m
byBrdm1fYXJjaF9yZXF1aXJlZF9jYXBhYmlsaXRpZXNbXSA9IHsNCj4gICAgIEtWTV9DQVBfSU5G
TyhERVZJQ0VfQ1RSTCksDQo+IEBAIC0yOTAsNyArMjkxLDQ0IEBAIHN0YXRpYyBpbnQga3ZtX2Zl
YXR1cmVfaWR4X3RvX2lkcmVnc19pZHgoaW50IGtpZHgpDQo+ICAgICByZXR1cm4gZ2V0X3N5c3Jl
Z19pZHgoc3lzcmVnKTsNCj4gfQ0KPiANCj4gLXN0YXRpYyB2b2lkIGt2bV9hcm1fZ2V0X2hvc3Rf
Y3B1X2ZlYXR1cmVzKEFSTUhvc3RDUFVGZWF0dXJlcyAqYWhjZikNCj4gKy8qDQo+ICsgKiBnZXRf
aG9zdF9jcHVfaWRyZWdzOiBSZWFkIGFsbCB0aGUgd3JpdGFibGUgSUQgcmVnIGhvc3QgdmFsdWVz
DQo+ICsgKg0KPiArICogTmVlZCB0byBiZSBjYWxsZWQgb25jZSB0aGUgd3JpdGFibGUgbWFzayBo
YXMgYmVlbiBwb3B1bGF0ZWQNCj4gKyAqIE5vdGUgd2UgbWF5IHdhbnQgdG8gcmVhZCBhbGwgdGhl
IGtub3duIGlkIHJlZ3MgYnV0IHNvbWUgb2YgdGhlbSBhcmUgbm90DQo+ICsgKiB3cml0YWJsZSBh
bmQgcmV0dXJuIGFuIGVycm9yLCBoZW5jZSB0aGUgY2hvaWNlIG9mIHJlYWRpbmcgb25seSB0aG9z
ZSB3aGljaA0KPiArICogYXJlIHdyaXRhYmxlLiBUaG9zZSBhcmUgYWxzbyByZWFkYWJsZSENCj4g
KyAqLw0KPiArc3RhdGljIGludCBnZXRfaG9zdF9jcHVfaWRyZWdzKGludCBmZCwgQVJNSG9zdENQ
VUZlYXR1cmVzICphaGNmKQ0KPiArew0KPiArICAgIGludCBlcnIgPSAwOw0KPiArICAgIGludCBp
Ow0KPiArDQo+ICsgICAgZm9yIChpID0gMDsgaSA8IE5VTV9JRF9JRFg7IGkrKykgew0KPiArICAg
ICAgICBBUk02NFN5c1JlZyAqc3lzcmVnZGVzYyA9ICZhcm02NF9pZF9yZWdzW2ldOw0KPiArICAg
ICAgICBBUk1TeXNSZWdzIHN5c3JlZyA9IGlkX3JlZ2lzdGVyX3N5c3JlZ1tpXTsNCj4gKyAgICAg
ICAgdWludDY0X3QgKnJlZzsNCj4gKyAgICAgICAgaW50IHJldDsNCj4gKw0KPiArICAgICAgICBp
ZiAoIXN5c3JlZ2Rlc2MtPndyaXRhYmxlX21hc2spIHsNCj4gKyAgICAgICAgICAgIGNvbnRpbnVl
Ow0KPiArICAgICAgICB9DQo+ICsNCj4gKyAgICAgICAgcmVnID0gJmFoY2YtPmlzYXIuaWRyZWdz
W2ldOw0KPiArICAgICAgICByZXQgPSByZWFkX3N5c19yZWc2NChmZCwgcmVnLCBpZHJlZ3Nfc3lz
cmVnX3RvX2t2bV9yZWcoc3lzcmVnKSk7DQo+ICsgICAgICAgIHRyYWNlX2dldF9ob3N0X2NwdV9p
ZHJlZ3Moc3lzcmVnZGVzYy0+bmFtZSwgKnJlZyk7DQo+ICsgICAgICAgIGlmIChyZXQpIHsNCj4g
KyAgICAgICAgICAgIGVycm9yX3JlcG9ydCgiJXMgZXJyb3IgcmVhZGluZyB2YWx1ZSBvZiBob3N0
ICVzIHJlZ2lzdGVyICglbSkiLA0KPiArICAgICAgICAgICAgICAgICAgICAgICAgIF9fZnVuY19f
LCBzeXNyZWdkZXNjLT5uYW1lKTsNCj4gKw0KPiArICAgICAgICAgICAgZXJyID0gcmV0Ow0KPiAr
ICAgICAgICB9DQo+ICsgICAgfQ0KPiArICAgIHJldHVybiBlcnI7DQo+ICt9DQo+ICsNCj4gK3N0
YXRpYyB2b2lkDQo+ICtrdm1fYXJtX2dldF9ob3N0X2NwdV9mZWF0dXJlcyhBUk1Ib3N0Q1BVRmVh
dHVyZXMgKmFoY2YpDQo+IHsNCj4gICAgIC8qIElkZW50aWZ5IHRoZSBmZWF0dXJlIGJpdHMgY29y
cmVzcG9uZGluZyB0byB0aGUgaG9zdCBDUFUsIGFuZA0KPiAgICAgICogZmlsbCBvdXQgdGhlIEFS
TUhvc3RDUFVDbGFzcyBmaWVsZHMgYWNjb3JkaW5nbHkuIFRvIGRvIHRoaXMNCj4gQEAgLTM3Niw2
ICs0MTQsMTYgQEAgc3RhdGljIHZvaWQga3ZtX2FybV9nZXRfaG9zdF9jcHVfZmVhdHVyZXMoQVJN
SG9zdENQVUZlYXR1cmVzICphaGNmKQ0KPiAgICAgICAgIFNFVF9JRFJFRygmYWhjZi0+aXNhciwg
SURfQUE2NFBGUjAsIDB4MDAwMDAwMTEpOyAvKiBFTDEmMCwgQUFyY2g2NCBvbmx5ICovDQo+ICAg
ICAgICAgZXJyID0gMDsNCj4gICAgIH0gZWxzZSB7DQo+ICsgICAgICAgIC8qIE1ha2Ugc3VyZSBh
bGwgd3JpdGFibGUgSUQgcmVnIHZhbHVlcyBhcmUgaW5pdGlhbGl6ZWQgKi8NCj4gKyAgICAgICAg
ZXJyIHw9IGdldF9ob3N0X2NwdV9pZHJlZ3MoZmQsIGFoY2YpOw0KPiArDQo+ICsgICAgICAgIC8q
DQo+ICsgICAgICAgICAqIHRlbXBvcmFyaWx5IG92ZXJyaWRlIHRoZSBDTElEUl9FTDEgdmFsdWUg
c2luY2Ugc29tZSBob3N0IHZhbHVlcw0KPiArICAgICAgICAgKiB0cmlnZ2VyICJVbmlmaWVkIHR5
cGUgaXMgbm90IGltcGxlbWVudGVkIGF0IGxldmVsIG4iIGVycm9yIGluDQo+ICsgICAgICAgICAq
IGZkdF9hZGRfY3B1X25vZGVzKCkNCj4gKyAgICAgICAgICovDQo+ICsgICAgICAgIFNFVF9JRFJF
RygmYWhjZi0+aXNhciwgQ0xJRFIsIDB4MCk7DQo+ICsNCj4gICAgICAgICBlcnIgfD0gZ2V0X2hv
c3RfY3B1X3JlZyhmZCwgYWhjZiwgSURfQUE2NFBGUjFfRUwxX0lEWCk7DQo+ICAgICAgICAgZXJy
IHw9IGdldF9ob3N0X2NwdV9yZWcoZmQsIGFoY2YsIElEX0FBNjRQRlIyX0VMMV9JRFgpOw0KPiAg
ICAgICAgIGVyciB8PSBnZXRfaG9zdF9jcHVfcmVnKGZkLCBhaGNmLCBJRF9BQTY0U01GUjBfRUwx
X0lEWCk7DQo+IEBAIC0xMTYxLDYgKzEyMDksMzQgQEAgYm9vbCBrdm1fYXJtX2NwdV9wb3N0X2xv
YWQoQVJNQ1BVICpjcHUpDQo+ICAgICByZXR1cm4gdHJ1ZTsNCj4gfQ0KPiANCj4gKy8qDQo+ICsg
KiBDb3B5IHdyaXRhYmxlIElEIHJlZ3MgZnJvbSBpc2FyLmlkcmVnc1tdIHRvIGNwcmVnX2xpc3QN
Cj4gKyAqIGluIGNhc2UgdGhlaXIgdmFsdWUgZGlmZmVycyBmcm9tIHRoZSBvcmlnaW5hbCBpbml0
IGNwcmVnIHZhbHVlDQo+ICsgKi8NCj4gK3N0YXRpYyB2b2lkIGt2bV9hcm1fd3JpdGFibGVfaWRy
ZWdzX3RvX2NwcmVnX2xpc3QoQVJNQ1BVICpjcHUpDQo+ICt7DQo+ICsgICAgZm9yIChpbnQgaSA9
IDA7IGkgPCBOVU1fSURfSURYOyBpKyspIHsNCj4gKyAgICAgICAgQVJNNjRTeXNSZWcgKnN5c3Jl
Z2Rlc2MgPSAmYXJtNjRfaWRfcmVnc1tpXTsNCj4gKyAgICAgICAgQVJNU3lzUmVncyBzeXNyZWcg
PSBpZF9yZWdpc3Rlcl9zeXNyZWdbaV07DQo+ICsgICAgICAgIHVpbnQ2NF90IHByZXZpb3VzLCBu
ZXc7DQo+ICsgICAgICAgIHVpbnQ2NF90ICpjcHJlZzsNCj4gKw0KPiArICAgICAgICBpZiAoIXN5
c3JlZ2Rlc2MtPndyaXRhYmxlX21hc2spIHsNCj4gKyAgICAgICAgICAgIGNvbnRpbnVlOw0KPiAr
ICAgICAgICB9DQo+ICsNCj4gKyAgICAgICAgY3ByZWcgPSBrdm1fYXJtX2dldF9jcHJlZ19wdHIo
Y3B1LCBpZHJlZ3Nfc3lzcmVnX3RvX2t2bV9yZWcoc3lzcmVnKSk7DQo+ICsgICAgICAgIHByZXZp
b3VzID0gKmNwcmVnOw0KPiArICAgICAgICBuZXcgPSBjcHUtPmlzYXIuaWRyZWdzW2ldOw0KPiAr
DQo+ICsgICAgICAgIGlmIChwcmV2aW91cyAhPSBuZXcpIHsNCj4gKyAgICAgICAgICAgICpjcHJl
ZyA9IG5ldzsNCj4gKyAgICAgICAgICAgIHRyYWNlX2t2bV9hcm1fd3JpdGFibGVfaWRyZWdzX3Rv
X2NwcmVnX2xpc3Qoc3lzcmVnZGVzYy0+bmFtZSwNCj4gKyAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgcHJldmlvdXMsIG5ldyk7DQo+ICsgICAg
ICAgICB9DQo+ICsgICAgfQ0KPiArfQ0KPiArDQo+IHZvaWQga3ZtX2FybV9yZXNldF92Y3B1KEFS
TUNQVSAqY3B1KQ0KPiB7DQo+ICAgICBpbnQgcmV0Ow0KPiBAQCAtMjExNSw3ICsyMTkxLDIzIEBA
IGludCBrdm1fYXJjaF9pbml0X3ZjcHUoQ1BVU3RhdGUgKmNzKQ0KPiAgICAgfQ0KPiAgICAgY3B1
LT5tcF9hZmZpbml0eSA9IG1waWRyICYgQVJNNjRfQUZGSU5JVFlfTUFTSzsNCj4gDQo+IC0gICAg
cmV0dXJuIGt2bV9hcm1faW5pdF9jcHJlZ19saXN0KGNwdSk7DQo+ICsgICAgcmV0ID0ga3ZtX2Fy
bV9pbml0X2NwcmVnX2xpc3QoY3B1KTsNCj4gKyAgICBpZiAocmV0KSB7DQo+ICsgICAgICAgIHJl
dHVybiByZXQ7DQo+ICsgICAgfQ0KPiArICAgIC8qIG92ZXJ3cml0ZSB3cml0YWJsZSBJRCByZWdz
IHdpdGggdGhlaXIgdXBkYXRlZCBwcm9wZXJ0eSB2YWx1ZXMgKi8NCj4gKyAgICBrdm1fYXJtX3dy
aXRhYmxlX2lkcmVnc190b19jcHJlZ19saXN0KGNwdSk7DQo+ICsgICAgcmV0ID0gd3JpdGVfbGlz
dF90b19rdm1zdGF0ZShjcHUsIEtWTV9QVVRfRlVMTF9TVEFURSk7DQo+ICsgICAgaWYgKCFyZXQp
IHsNCj4gKyAgICAgICAgcmV0dXJuIC0xOw0KPiArICAgIH0NCj4gKyAgICAvKg0KPiArICAgICAq
IG1vZGlmaWVkIHZhbHVlcyBtYXkgaGF2ZSBjaGFuZ2VkIHRoZSB2aXNpYmlsaXR5IG9mIHNvbWUg
cmVncywNCj4gKyAgICAgKiByZWluaXRpYWxpemUgdGhlIGNwcmVnX2xpc3QgYWNjb3JkaW5nbHkN
Cj4gKyAgICAgKi8NCj4gKyAgICAgcmV0ID0ga3ZtX2FybV9pbml0X2NwcmVnX2xpc3QoY3B1KTsN
Cm5pdDogaW5kZW50DQo+ICsNCj4gKyAgICByZXR1cm4gcmV0Ow0KPiB9DQo+IA0KPiBpbnQga3Zt
X2FyY2hfZGVzdHJveV92Y3B1KENQVVN0YXRlICpjcykNCj4gZGlmZiAtLWdpdCBhL3RhcmdldC9h
cm0vdHJhY2UtZXZlbnRzIGIvdGFyZ2V0L2FybS90cmFjZS1ldmVudHMNCj4gaW5kZXggODUwMmZi
MzI2NS4uYzI1ZDJhMTE5MSAxMDA2NDQNCj4gLS0tIGEvdGFyZ2V0L2FybS90cmFjZS1ldmVudHMN
Cj4gKysrIGIvdGFyZ2V0L2FybS90cmFjZS1ldmVudHMNCj4gQEAgLTEzLDYgKzEzLDggQEAgYXJt
X2d0X3VwZGF0ZV9pcnEoaW50IHRpbWVyLCBpbnQgaXJxc3RhdGUpICJndF91cGRhdGVfaXJxOiB0
aW1lciAlZCBpcnFzdGF0ZSAlZCINCj4gDQo+ICMga3ZtLmMNCj4ga3ZtX2FybV9maXh1cF9tc2lf
cm91dGUodWludDY0X3QgaW92YSwgdWludDY0X3QgZ3BhKSAiTVNJIGlvdmEgPSAweCUiUFJJeDY0
IiBpcyB0cmFuc2xhdGVkIGludG8gMHglIlBSSXg2NA0KPiArZ2V0X2hvc3RfY3B1X2lkcmVncyhj
b25zdCBjaGFyICpuYW1lLCB1aW50NjRfdCB2YWx1ZSkgInNjcmF0Y2ggdmNwdSBob3N0IHZhbHVl
IGZvciAlcyBpcyAweCUiUFJJeDY0DQo+ICtrdm1fYXJtX3dyaXRhYmxlX2lkcmVnc190b19jcHJl
Z19saXN0KGNvbnN0IGNoYXIgKm5hbWUsIHVpbnQ2NF90IHByZXZpb3VzLCB1aW50NjRfdCBuZXcp
ICIlcyBvdmVyd3JpdGUgZGVmYXVsdCAweCUiUFJJeDY0IiB3aXRoIDB4JSJQUkl4NjQNCj4gDQo+
ICMgY3B1LmMNCj4gYXJtX2NwdV9yZXNldCh1aW50NjRfdCBtcF9hZmYpICJjcHUgJSIgUFJJdTY0
DQo+IC0tIA0KPiAyLjUzLjANCj4gDQoNClJldmlld2VkLWJ5OiBLaHVzaGl0IFNoYWggPGtodXNo
aXQuc2hhaEBudXRhbml4LmNvbT4NCg0KDQo=
