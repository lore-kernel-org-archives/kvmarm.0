Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8E003FF1C7
	for <kvmarm@lists.linux.dev>; Fri, 15 May 2026 15:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778859455; cv=fail; b=uGHt76ZMzaPJ+OEH4d5HYS0d+ARTzsGyDX2zqwxvEar/BqQgvJ7hSW8ta6SpI3NvTSG3/cjt8EIH6q8X7M83pps12MfaiqoAhvIHyuh40MabPmBQS6VFK0qKIAdsj1NLqo6PPM+KKHQyyiDoJv3mfRY75JVVw99AzExuCkHXt+g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778859455; c=relaxed/simple;
	bh=ToEFsOMnLBbqMeBmhrWJL26gzt7CFY/Uu/aO4fvaaGs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ahTawojUdUFDKhlxKBm7Y1X/+ctSv9LstfjJcNvH8E0cjdE9T7/PUYnTZuhfGsoHnRxdOg+kUYW7gMwY10Ttf25oUTEJ1HX0azQSzb6DKppZ0/x+9K3OKIqgTAM8WgPDmGrjBAyTc08KC7eewZKBdl6WIOd4pZ7vIVU7Seelibo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=CG7r2w70; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=HiYCKsLu; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="CG7r2w70";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="HiYCKsLu"
Received: from pps.filterd (m0127837.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64F9mLQ71160002;
	Fri, 15 May 2026 08:37:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=ToEFsOMnLBbqMeBmhrWJL26gzt7CFY/Uu/aO4fvaa
	Gs=; b=CG7r2w70EsvRzbc2PIB08iExb8Q6beHM14uzHfXtyhdIDu2WqrJHp0nDR
	p/zaztTc5L0YgH6Ds3j3775beZKYzATxKXa54Z4JjKcSVGmYLn6djYQ3Wwpjgyp1
	jKM0tyFwzlHbtvGnGqzKNU0HdijsYVkeIn75EXf9US1/i2K0ZSfmXj8Ee4C/WwRa
	2wcgobwzPfoeWcOL7N+6b32nhEhXxSV2nUQuZwVZjV+rZ3BPzPV8iWYoKFCl5S4W
	sYwN5NGbP8RPrI20+vZTI4xynnILDTLLYP0S5hu0jJ0+3BBlilw6rLPKdjAM0AOA
	ACoaEdpcvzUZgmKDDiedsbJGzNOEw==
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11020115.outbound.protection.outlook.com [40.93.198.115])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4e5m22jcwy-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 15 May 2026 08:37:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eB73qvXbfdQJlubJdaSucu76oQBcHH1PC740n4+q3CQbJqyz8DV/lOGeoWhie6oVcnorfjBZArSr1nSSk/TBdMI1pq2i8tHrkXazSWRfDJ7K0pP+5UqiEr/Duf3X+/t4+AU7duhHAT5izwxmhCcBS4dSV0jaBQOGfi8zzMVZbFEN6aUzZFKVMdaRK0eM/XbqaXlrLHKQi3wnEDqbzw+gFved3ecVnI2iMF6B+/8XQFdhY/ze6VfQo8guKh/27f++t9cw0e1HdhyfYtfbJC4nejE3oiVvNExa4gFU+I2/l9THPmLUeBZwb5gqImvoj/k1c6UqGf3eSWAbBwcqSofZZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ToEFsOMnLBbqMeBmhrWJL26gzt7CFY/Uu/aO4fvaaGs=;
 b=kxG1IuYlBsp2t3eB+0ZFyipkg62sIlvWnHjTKInWzPFvSZXpef+FD035Bjxv+Wjj95+/YKEilkfku9+kV9wY0NbvVfDqgWY5CJjfMpkdI7n/Vthr3j1mCVhFVXg1l3QYig2b+YhGsg36/wkuRrF8bJaUxYMlkb7lzTX2af0Uqx9ye30Ow76G4LHlOMrDmgF5p4GyEtsVE57JKuY0x0rRXmw/BSa5TL66E44MMfm1sbvjabVIfZqgBgerKDlKuYItTigX/hWvR5yRsRRqFqtzz+T2xesyS3p4033bfMCPqrLnZq0eJ2N1BNifbHVL/QmE30to7iKrs6pHnYip4dB34g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ToEFsOMnLBbqMeBmhrWJL26gzt7CFY/Uu/aO4fvaaGs=;
 b=HiYCKsLuYR7m7WxDiWJTIjAxKI0YOcoWwYFk2XzV96Yul7jhoXAw+DXXLJ5IkLoTu86EYIs+OniNk78f/rZZwGvJF6Np42VjDjjXf+cGm/Y0iYS4rbRi98fgHMzPtKoTzUyAgvdBNBK2vJmwnpT7jMqwhph1d/j4yDLTQo0GNfsxkx2zZMhm5XWEYY1eaFnWHz67tUx+PWpUsx1cgjOROp6xd6b91MGOWPusPnbziBg8FPwGE//rhu07pR0JP61w5ijMKgpLW3HuQwkZu0EJJ7YxsXtK4AyjIM46/LYsiUht5AZDXI7vRba1gMRfFxaLDj2v9GZr7APL/FKc0DChYg==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by LV3PR02MB10740.namprd02.prod.outlook.com (2603:10b6:408:285::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.25.19; Fri, 15 May
 2026 15:37:18 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%6]) with mapi id 15.21.0025.019; Fri, 15 May 2026
 15:37:18 +0000
From: Khushit Shah <khushit.shah@nutanix.com>
To: "eric.auger@redhat.com" <eric.auger@redhat.com>
CC: Shaju Abraham <shaju.abraham@nutanix.com>,
        "qemu-devel@nongnu.org"
	<qemu-devel@nongnu.org>,
        "qemu-arm@nongnu.org" <qemu-arm@nongnu.org>,
        "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
        "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>,
        "richard.henderson@linaro.org"
	<richard.henderson@linaro.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "sebott@redhat.com" <sebott@redhat.com>,
        "skolothumtho@nvidia.com"
	<skolothumtho@nvidia.com>,
        "philmd@linaro.org" <philmd@linaro.org>,
        "maz@kernel.org" <maz@kernel.org>,
        "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        Prerna
 Saxena <prerna.saxena@nutanix.com>,
        Jon Kohler <jon@nutanix.com>, Jonathan
 Davies <jond@nutanix.com>
Subject: Re: [RFC PATCH v1 02/13] target/arm: named_cpu_model: Add ID Register
 Fields
Thread-Topic: [RFC PATCH v1 02/13] target/arm: named_cpu_model: Add ID
 Register Fields
Thread-Index: AQHc4vZUSy91MSEtGEqhLU61tmz+/LYPOD6AgAADNgA=
Date: Fri, 15 May 2026 15:37:18 +0000
Message-ID: <7AB23C5F-92AE-4D1C-87AF-5D43E2A90F86@nutanix.com>
References: <20260513163356.3033159-1-shaju.abraham@nutanix.com>
 <20260513163356.3033159-3-shaju.abraham@nutanix.com>
 <2c4741a4-e37e-48bc-8fe5-cab2b9e67793@redhat.com>
In-Reply-To: <2c4741a4-e37e-48bc-8fe5-cab2b9e67793@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA2PR02MB7564:EE_|LV3PR02MB10740:EE_
x-ms-office365-filtering-correlation-id: 49c9a872-4472-49e3-2bd7-08deb297d93a
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|376014|366016|10070799003|1800799024|4143699003|56012099003|22082099003|18002099003|38070700021;
x-microsoft-antispam-message-info:
 FtGItVdCTwZzUCTj4XC1KXiDOzIOzd5ukCmT4vU9GT6iR3cLGUDpCyTjwvR+ajXqWHmSYc0zFy2Tg13C7IIm44esi98jFTrHgzZXKVEx5VpNVPUUKt2+4fK1y7osJqY8O/yOXSAqPi6upXE4ux8O9l6aZlMg7pE21ivjSUBTUqyi1TsQc5MwZmd72qRXCwyLrDzqCkaJzkpy5MjorWfEdQCwvgNIJ+DWHPrHTn4RReJr5IflbWArPgmmYt2JPWmCkG2DnpfZ3RstbHiEWR9gp4O3gG+9Ej+qZbxASRMsOWAi7Pp+Tr6MlvflPk49JeNz3QyllK5ksuUAvyA6umZoIENKW/rhbEs+udC7CnrDtoXlUUDWOhg8s6gZU88nR+MhHBBj0bj+CBcKawGk5mu65UCIzzIszJb7P7aSWRtRqg7VYek92Lm8tlngHuzZhDzejda4ZSQNeLJzNOJUT84ZQbdWuj2DW3MimIOXuT4dvoJWgnP+BFQXV3sFAdS/bEo1mwZ4X00g00X8fxbW5qjqUwoyK6E1qvbRqz8NW+WuTp0Oup0W+5hrh2t8Y4I3FOczbdlegn7k2KRqoq1W1njI8nV3dQ/d1VO4emD+/QgnzoPBFH/w2CYHuncmndmvoqLF5o3i3CZ0z7z9OyxYB4KZE5yw+LqdafQcF4pynsJOJ/Nfr0bZPTcUQ+ugRMxvpfABMGwUWMeh/CVAzXZJq7Z2cbeh8wYb6fQtvV2w0rO9HUp13/gVKk5/nFq+IHT0oNfE
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(10070799003)(1800799024)(4143699003)(56012099003)(22082099003)(18002099003)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?Q3JTWTIxZ293SlJtYjNDSGxsVUd4cVp1dXZEVm01SC9FQ1hLdGY3RGs5VWVr?=
 =?utf-8?B?clRFemUxRTVsR3NYeDJkTnRXZWswWkpvOVA3SXZ5MnVSWWRrSVloQ2RTUTFU?=
 =?utf-8?B?VGhIMW1zc0pkVDBFa1JZbFN0eVpyOEQ0Z2lkRktzKzdZUnEyNlZFK0Z2SkdT?=
 =?utf-8?B?MVVIQStvbThSMHRzVXVCdGliOHZ4WFJFeW0vRk43VjNCYmFCS0YxYm5qNk9R?=
 =?utf-8?B?Y1hzZTh1V2dIQ2lhY1ZSbVJPcFFhTkMwanIrRGlxejRUVXJJcys1VVlxYUVs?=
 =?utf-8?B?ZFFxK3dURWQ1NmhZNXRhajRQRENrd1pGb3VoN2tvYW1idGRsbDFIVnVTMDhJ?=
 =?utf-8?B?N2ZCNTJpbVVtTW44VXJrTWt6d3dvYXVxVDJRNFk3ZlpGOVppbC95ZWtoYmJO?=
 =?utf-8?B?N1FWcDVkR0VFTjZrVTNTLzk1UzhoSVhObnBna2gzbHlvVUNlbEZ4c1NqeFNF?=
 =?utf-8?B?YVVqWnJ1WmVmT2I4Ym5LL2lWaVZUMUhlOS9PWEpMMW94bmtnQVVlWkc1Nlpl?=
 =?utf-8?B?WHdTTWxOR0xLWGV5Z1dpNEZTTlVTdTNNK3FJREl5SGJvaWhDZnVkY0pOblZk?=
 =?utf-8?B?UE94bGYvSVRHYXJ4aWlrTWFvRi9TRm15Y2pLVEJnaFpFWCtJNEZJcEI0RDZO?=
 =?utf-8?B?SFh0Z1FneGdDdVNTYTZoNGdmVmp3a0IrTXVVeFFSczhXTmpqdXpzRnVxd3FV?=
 =?utf-8?B?RXkxSlk4a1dObFJTQTZzZ3VrNS9CRTlsWkNGMEFNb1ZRWnRUYnlOTExEQWpz?=
 =?utf-8?B?YlZoU2liYWFSSzA0RjB1NDVhVjlDZmdHVnJFUDVHZXpyRWZsZS8weTFDNlR2?=
 =?utf-8?B?WHVSa0ZHeEwwRnc0SzBjVHRoNHB1UDVpbGN3TjhtNktOc3VTSFcrcG9YTTdD?=
 =?utf-8?B?cUp1T2NWVDdHUzF2TzZ5ckE4Q2FCRlpOUDVsQWRCWm5kV1ZuYTR3Ri9MOW1J?=
 =?utf-8?B?N0g2S0d3b1lTTktLVXNZRFRnVWZsWjdqOXptVWVSNHg1ZjYyOWlWL1JIUkVh?=
 =?utf-8?B?Y2ZDU2ZNL29tUkg1ZGRMMDFXZmY3SUJZaC9ySGFib1hYNmUwZkJCZTdUdTVr?=
 =?utf-8?B?dFlGK0craE5iNHBoNmtUUVhEZGNmTUlhdy9RNk5VYUZTSFdUUjRFOTlhV3ZZ?=
 =?utf-8?B?T2oweFFEanNMNlVsb0tTNkNPRXBxNDgzRXZDTDZNZ1JsTkVKVTVMYzJUM0hv?=
 =?utf-8?B?RThqcEg0V1pJNncxNnFSMVFCQkNQVnpsSko2RFdZd3VpNUZTQ2hxOWlVdWNo?=
 =?utf-8?B?NjJOZjEwN3lpalhYM1hHdDJ4YTI1R3FlZE54RVpBam9Sb3d6R3MwSjlxZU1J?=
 =?utf-8?B?OTNiZ1EzdlNIS25KS2ljSmtaeXhmdjEzc0J0L082OGdhZEV1MW95TCtCMnBo?=
 =?utf-8?B?Z01rd2Q4UStMb2ZCdyszb1haZXZWNTlOMkExc24zQk8xUzRNZmYwZE5EU2Jx?=
 =?utf-8?B?Yk9KVFJUQ0JqVEVqUUc3cVBsRFZSMUNCMzN4YW4yQmxVc3FoR3BiYXVBSWRu?=
 =?utf-8?B?dnJxQzU0dmIyV0NzbUh5bllCRExQa0ZobDVvZ3paZWtXN2hHM3JkdnFUendz?=
 =?utf-8?B?clpKK3NCeGZ5S1RjZW55am9yeFp1b1VnbUtjbmZuYWxscE1jNC9aSzdrR1FT?=
 =?utf-8?B?VzY2S3Uvb3hIRmR0a3dFVHVkbHI3ZVc5aDVSc3kvTTVUaUpxZTg3K1I2bHhI?=
 =?utf-8?B?bEk0VVdIcnFxNEM4MHJJMUh0SENzL1RrdkJUTlNPUmZ3bE1TN1NGU1NoZW9S?=
 =?utf-8?B?QnZqTWdOTXBVcUlBNUVYTjltQXVpTldTdkhqSGZtZ2VRc1dic3FQM2ZIcmlC?=
 =?utf-8?B?NzBDR1RGWW1iaVBIei9mc1RKdzhkN00zOGlrTFA4NGhXekYralJHZlZsN0Vn?=
 =?utf-8?B?akY0WkFKdE1Ua0pUUGFWdjJTcFlyNWdxSUQvMFJPbWlyeWZDK05nM1dVa2h5?=
 =?utf-8?B?emZJUFdVYmlMOElieFZGaFZwc3k1UFJ6UjRtczFmZVYxdlh5bmFGbnIvZ2xJ?=
 =?utf-8?B?ZWxjNWNzeDZFYStNNjZTSlk2VmVnVGRORTJGKzJ3ZlBTSFFyK3dCR1diSENQ?=
 =?utf-8?B?dXh4Slp0N0QybEVvT090ckRnZHp6S2IvbHRnbWxTYzVjY1FXdE5XYWdYRXN5?=
 =?utf-8?B?a1ZuTEJSRDBEUXFMTzlUVnJNTW54WE9Qa1A3bGU3dFlkZWtlZ3kvRVhEMzNG?=
 =?utf-8?B?SmdzUjRyYldtQWVLeUlsNXN3TC9JVHVuRTN0ZmtneVJIN0IwUlZwU05ndFYy?=
 =?utf-8?B?VFpBSFZsSWgya3o5Z0FpZkYvM0FXcGtyRSs0UCtpTGlJM0J6d241VjRTTGdj?=
 =?utf-8?B?K0pKTjBFN2NxU25jOHdxTEI4RHJ6ZDhPb3EvWXZDZ2xRRFdBQkMwVDVnWEgy?=
 =?utf-8?Q?wGX71Kbf5dNwhGRE0U/5yBCftRh+N1/spSZPCTwEfUiB2?=
x-ms-exchange-antispam-messagedata-1: nQ62Bi4MAzX3gD6nptUUY3IpJmszMpSMrm4=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1C6D353714988B48B20A68CD1A00C1CC@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	JbrYeNM8WuwsQwbMhqlH85hfY5M+bncF3e0OSWMHj+8ulU6qw119IpVJuzS5MBiAcEYMAmZtml2Vm7AQVQWDzbcptKNTa5fBM61tNO2dVimhByw0zWv/nsDUdFUHp7XiwigUqEk39SPJbQHoMfV/YL6xzyk2WfoG93YTRP9bqrnxxCvU//UtkODbjz/9Z+mVwb0qMrLDCkIeqkO7ktgtvRNdB+gTxqa4bFYevFC4a409QxAas/saV7usSxwtyABA5wfOTN8HNTStq1gcQl7PKUXVQulf997fiGzHn/2ECMPlxCsMJDTE8sYi7YEHJFtluL93WsCX+y5Ovhvk0Zxr7g==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49c9a872-4472-49e3-2bd7-08deb297d93a
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 May 2026 15:37:18.7265
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7ZrSpc2tNDeyvwzn1ipMbDckxcbVeA+dMVw7Jt1nMcCqEvMseLxfk6+36O/wVA9V4O7EzAHfX8pUl8+LtEYBwdFS/WqsDNtS/4KyqwvIf7k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR02MB10740
X-Proofpoint-GUID: yWXET5JAiyOcetw-VUJbGakwAbSEPX4w
X-Proofpoint-ORIG-GUID: yWXET5JAiyOcetw-VUJbGakwAbSEPX4w
X-Authority-Analysis: v=2.4 cv=OIQXGyaB c=1 sm=1 tr=0 ts=6a073db0 cx=c_pps
 a=nlv0CAtHnzzDHnkuFZeoVA==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=NGcC8JguVDcA:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VofLwUrZ8Iiv6rRUPXIb:22 a=Ap8k9tRZuQ82DLYWQqG7:22 a=20KFwNOVAAAA:8
 a=mmcc5uL1AWGqa0-o7y4A:9 a=QEXdDO2ut3YA:10 a=QbcjlK4JNLEA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTE1MDE1OSBTYWx0ZWRfX6PN49N5QndtA
 MrQqcCzl9IHK4PL+Z81GMaPfL04bbkO/OcQXfCrbpgJQqfVNOzT4WvAtediLzUBHYZJol8SVmzp
 KSfGgqPFUyGu3tjoqfRhAF8K5904vdj7mDf8F5u70csuxjeoCMF4vE7fa27JvNKrCUnbrSzSR3g
 Ir5hK5Mmj7xZsUA+vZc+tUgZKPXgH4smn9AwMqfeVSuD99M8APagVTartknl+wYsZ1mhlEvrui3
 n9EAOT5NM1XYrTzW68MwLKf+eGQ7NomhNpGDGcAjw2OXZrnv5csjymqDY8uo1cXTDyg8SetRwvw
 vaRirv0q/UOPafE5Er4W5ugJkrXd16WP+twc/PYPRjYE+Gv7NzuRdliQp+m20mSY7njQ1I7RcQ1
 nz9ULrOJidEle6rRtbKOlG6CZokOJobUuPVIjVNCL36lKtT3xJSaJktvtUK3wOl5zTr2eXyRReB
 kAUB78acx67DSNSGF0A==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-15_03,2026-05-15_01,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gMTUgTWF5IDIwMjYsIGF0IDg6NTXigK9QTSwgRXJpYyBBdWdlciA8ZXJpYy5hdWdl
ckByZWRoYXQuY29tPiB3cm90ZToNCj4gDQo+IEkgZG9uJ3Qgc2VlIENMSURSX0VMMSBmb3IgaW5z
dGFuY2Ugd2hpbGUgc29tZSBmaWVsZHMgYXJlIHdyaXRhYmxlLg0KDQpZZXMsIENMSURSX0VMMSBp
cyBtaXNzaW5nIGlzIGtub3duLiBXaWxsIGJlIGFkZGVkIGluIHYyLCBhbG9uZyB3aXRoIHByb3Bl
ciBoYW5kbGluZyBmb3IgQ0NTSURSX0VMMS4NCg0KDQpXYXJtIFJlZ2FyZHMsDQpLaHVzaGl0
