Received: from TYVP286CU001.outbound.protection.outlook.com (mail-japaneastazon11011018.outbound.protection.outlook.com [52.101.125.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67A34245031
	for <kvmarm@lists.linux.dev>; Fri, 13 Feb 2026 07:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.125.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770966184; cv=fail; b=ZXYN0itvE5v6aWDWWBvkmylhAcz4tLanv+OrYBfpZZKwwEltQjZgrRpaPPgjBPm9A+OC5kQfAkN3zY+czASn6LApI3NHd8HpnNohL+KGpEjYADOZj0UWeVLGpwZ8Dw+HjXLLBUlyKqIqqv8Nvh8f2MG67yVP7wK5LGhHMzrvB6Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770966184; c=relaxed/simple;
	bh=uHbQ8ufgsNRmtZCFMXarR2HArU0UnzyW4YLF/UzOERI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=J6hHLHGQVDbRrA25cwfOhlYIK1G2IBK/pLx9cF3WTXXSV2A/8jNFr7wFSwdKK69beHAlT88ycjgfxDQE4x08iiWGohC28hY8zOX0bHUtbwl+fwZkQeFHpAelv0mNpCSB0LHwDwA199dyg93VjDjmNyFBWybFIPVdRm0SFlTXrJw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=K2mfGP9N; arc=fail smtp.client-ip=52.101.125.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="K2mfGP9N"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mKQnaBt2bn3HViMLAZK15xmCiiu1SvyC7coQG9STnBhWk1jmIAqHArrDdylnIip6Tedn54bBUMeCLJJMSfxuC4Js8qVzKy6T8YvpvduSg34MQaHoM50XbKa2phg69byNsNryh1hswRvt4ORF/PBEzpK6g+YWJD5BrMNmMxiiW4Zd/kwWrnMNbSxnHL8GADppgQpZzz2bW9H21u+FBY14tLHTaZjZwdb6xqAia0TbUpFGUMsF5g92E22NEKvAvVQq69WaJpBlHq37woM4kaHgjXTZWuGm9uvADjfvCcxPgkx6+3iC18AySBZczyNlMWMOg/55c8kN0sFzRIzu1VBTcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uHbQ8ufgsNRmtZCFMXarR2HArU0UnzyW4YLF/UzOERI=;
 b=OgzTRpoHK2+EtILOmBd/lygEjE8LSTW8rnWDvJCXUU6l6kLS2AO+WfmU5jLEGR8tikwFVKjSKXoBJQ7J1b+jalSg9mXwyphTuEnnZmIRM779X//CiKllSjjOXT0fh/8vEz0d+aA5rb0tHzIA4xVKROvY263s9Zerko9/Yi8paGLiAuxgmymZY+0jIZGrOslv81V08ASc89IuM539zU9KQmb3dRTR4r2BQZc6pS1v7lv4Zn7Ld+88ORCehhTdtlxWmS2sb3Lqcq1uTSSqjk5Qm5eBQMuRl+NSoH7x2SWXWBhlsv91KMeqUdVc/odmbFKmTVid0obfTeAsDrOeiNnrhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fujitsu.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uHbQ8ufgsNRmtZCFMXarR2HArU0UnzyW4YLF/UzOERI=;
 b=K2mfGP9NO3d/5T5ed7j8AYgQ5AzrWYxEJyo9KKUWMJsjzAD1qrJ+tVaImHuRydUVHHdIV38xpfaQtD5pnATssETwbMN1FpkL8omWNQhvAY3nwEBge4CWq6fTmvfm+Am1vvsZ9QXwGcjaMSIMctuTjpReXzhwyVMC6zkdGSQ7rguhO2z1tiewH4yRpINInpyF2PSMLeTcO65SRGVeoiTN9ND/wuIPdCdvcZ4d6GPGP2Nl5douRLiAaWMGy7iqcOoivUfliRfmk0Mo17QuMFzF3H56gX4PAZN+NnkdV4/BpEynIXEKM5hbx+82sBigoNgWdcaVkbXafZN4f2uNYd4JKA==
Received: from OSZPR01MB8798.jpnprd01.prod.outlook.com (2603:1096:604:15f::6)
 by TY4PR01MB17885.jpnprd01.prod.outlook.com (2603:1096:405:34d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.10; Fri, 13 Feb
 2026 07:02:59 +0000
Received: from OSZPR01MB8798.jpnprd01.prod.outlook.com
 ([fe80::e366:d390:4474:8cfa]) by OSZPR01MB8798.jpnprd01.prod.outlook.com
 ([fe80::e366:d390:4474:8cfa%5]) with mapi id 15.20.9611.012; Fri, 13 Feb 2026
 07:02:59 +0000
From: "Shaopeng Tan (Fujitsu)" <tan.shaopeng@fujitsu.com>
To: Ben Horgan <ben.horgan@arm.com>
CC: "amitsinght@marvell.com" <amitsinght@marvell.com>,
	"baisheng.gao@unisoc.com" <baisheng.gao@unisoc.com>,
	"baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>,
	"carl@os.amperecomputing.com" <carl@os.amperecomputing.com>,
	"dave.martin@arm.com" <dave.martin@arm.com>, "david@kernel.org"
	<david@kernel.org>, "dfustini@baylibre.com" <dfustini@baylibre.com>,
	"fenghuay@nvidia.com" <fenghuay@nvidia.com>, "gshan@redhat.com"
	<gshan@redhat.com>, "james.morse@arm.com" <james.morse@arm.com>,
	"jonathan.cameron@huawei.com" <jonathan.cameron@huawei.com>,
	"kobak@nvidia.com" <kobak@nvidia.com>, "lcherian@marvell.com"
	<lcherian@marvell.com>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "peternewman@google.com"
	<peternewman@google.com>, "punit.agrawal@oss.qualcomm.com"
	<punit.agrawal@oss.qualcomm.com>, "quic_jiles@quicinc.com"
	<quic_jiles@quicinc.com>, "reinette.chatre@intel.com"
	<reinette.chatre@intel.com>, "rohit.mathew@arm.com" <rohit.mathew@arm.com>,
	"scott@os.amperecomputing.com" <scott@os.amperecomputing.com>,
	"sdonthineni@nvidia.com" <sdonthineni@nvidia.com>, "xhao@linux.alibaba.com"
	<xhao@linux.alibaba.com>, "catalin.marinas@arm.com"
	<catalin.marinas@arm.com>, "will@kernel.org" <will@kernel.org>,
	"corbet@lwn.net" <corbet@lwn.net>, "maz@kernel.org" <maz@kernel.org>,
	"oupton@kernel.org" <oupton@kernel.org>, "joey.gouly@arm.com"
	<joey.gouly@arm.com>, "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, "zengheng4@huawei.com"
	<zengheng4@huawei.com>, "linux-doc@vger.kernel.org"
	<linux-doc@vger.kernel.org>
Subject: Re: [PATCH v4 38/41] arm_mpam: Add workaround for T241-MPAM-4
Thread-Topic: [PATCH v4 38/41] arm_mpam: Add workaround for T241-MPAM-4
Thread-Index: AQHclVa8w6wA8SC8+EK1Vycko6qcMLWAPTlN
Date: Fri, 13 Feb 2026 07:02:59 +0000
Message-ID:
 <OSZPR01MB879872E55F0625D737AD06578B61A@OSZPR01MB8798.jpnprd01.prod.outlook.com>
References: <20260203214342.584712-1-ben.horgan@arm.com>
 <20260203214342.584712-39-ben.horgan@arm.com>
In-Reply-To: <20260203214342.584712-39-ben.horgan@arm.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Enabled=True;MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_SiteId=a19f121d-81e1-4858-a9d8-736e267fd4c7;MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_SetDate=2026-02-13T07:02:58.946Z;MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Name=FUJITSU-RESTRICTED;MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_ContentBits=1;MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Method=Standard;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: OSZPR01MB8798:EE_|TY4PR01MB17885:EE_
x-ms-office365-filtering-correlation-id: 9bad75f3-7b01-42ec-e071-08de6acdec11
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|376014|7416014|1800799024|38070700021|1580799027;
x-microsoft-antispam-message-info:
 =?utf-8?B?aTVQeHVjVnRCM0EzM2hZRkVCeXZhVGx6eWoyYlAvTjQxMThhQnN3aVNpeUZR?=
 =?utf-8?B?UU9kK2Y0VGRJSitSdGtBRnVtaFg0YUdXbldQNEdpb25UMm5FQ0xaM3R4bXd5?=
 =?utf-8?B?YllHVFNVNXA2V293NWJZSGpXYzIyMDFTQ3owWHU3cmkreFIrR042VzVKa3Fi?=
 =?utf-8?B?aWJ0SkdkTHlaV1hxZEFINllJczNTWUYxUXpMYk9MeXlWWHUzMnY4eWZjQVpM?=
 =?utf-8?B?bTMyMXVodWVSQ0FyQXpsU050UVdNYUlGOW9IQzJtRmlxMEx2WWNTN1E0Ymc5?=
 =?utf-8?B?d1JoWFN5TmFlZXRUYkt0VUsvOW5PZXR2MTBoMFhYdWwvQVRETGhVZnNGR0pp?=
 =?utf-8?B?RVMzZDNWSHh3QW1xek0zL3lQUG5xQUQ0cjZWOVlVZTdNY21JRlNVQktXbC9j?=
 =?utf-8?B?ZFIveGEyVDVWWXB1QnBOV2tJR0Y3Nkp0azg0OGc2b0kyY3VmZExPL1gxczFh?=
 =?utf-8?B?OWJBZkJpaWRINXFuV3Y3c01GYzAxcHlBVlh5ZTBDMXExc2pjWHNoZWhLdXdE?=
 =?utf-8?B?bDdkL2NhcnRZZ0JDQUd1WkNnYUlMb3dyUHFMWWI4aS9KeERWeld0aHkyUncw?=
 =?utf-8?B?QVNENHRwdFNjK1JrNzJ1Qk1wWk1tTlJVTlEweWlBdFluRi9KUlgyUFk2Wk9V?=
 =?utf-8?B?WXdQZ3paSjFZUDhxUW9rTjgxcXpocW0xa1hzRGNTMy9SYUlqWklkL3E2TzVq?=
 =?utf-8?B?OU5jQWdBam9oaXNXMkVCT0dlS1VLNFMrQ0UzRHhKSUJzRzF1OTNXU2ZKc3RP?=
 =?utf-8?B?MzN3SGhHam1WUHlOUGZWWXB6a2d6d3NlbmF3NnBwcHRxZ29BaXhsMHkzSlpw?=
 =?utf-8?B?bXdKd0h1cUxYRkFCdG9sdzlvQnh2dDFzNUN0YThiVCtSQlg3VDM1azR1eVho?=
 =?utf-8?B?VUJLSnArS3FYaFlISU8vT3F3alZPb1hiL1dpSU9hdllPcEF5b1dtNlA4WEJw?=
 =?utf-8?B?Z0dacGNTa1NzWDVabUFSSEl6aVdUY202cVZkb2pZb3dpRWNDSGszV1RQNGMv?=
 =?utf-8?B?bEF0cWFPMFdkTThQOElhd1VmbDNKZGVqTDBNL1lKZ2tiYndjaUlramRWTlJ3?=
 =?utf-8?B?RFE0bXlxNndFMTRJSFFqZEs5SGd3aDhSNFRFTFB6aW9SQ3RINXdSeXUxRDNP?=
 =?utf-8?B?TmRNN3Q1b3NkT3pKajJYM2o1UFg4Wjg0VFBteHlvNTVZSXg2aFVvZU1TZzRz?=
 =?utf-8?B?R2RlbkRJMHZ0am5QZlJBbHg5Z1FVdElrSVZTV1pMNStQZndUVDJ1MURzUkxn?=
 =?utf-8?B?MVlCdGszNThQMHZmcEhUbnUzNDBZZjFZZFYxOGFhMExCS0V1ZDQrcC9UdFlj?=
 =?utf-8?B?MEdOS1kzU2dCTnVmSmw3TkpKeU9UenBzOUllYy9Md2Y0WFJpMzFQZkJSRW9i?=
 =?utf-8?B?UnVIdWZPb2dzSm84Q0Z6RmdmaDlwaG1mQnNKTXpVUWdrSm9wK0tTWFpmbkpz?=
 =?utf-8?B?aDRTNmFaeW82TzNBRnUvbmVVZUgvNCtuNzU1dUlYM2FJaTFpY20rM1JreEJo?=
 =?utf-8?B?c0MyQ1pVaTJHa2M3MFFVUW9MT1JnS2tTaXBoVEpPMTJmYU1vV2gzTGRjYnJa?=
 =?utf-8?B?bktXVVMzV2szNTcwWlBZSy8xODBWUGJlaVNaRWlNeEZTQjZHN0RJekZvUWp5?=
 =?utf-8?B?amR3eDhiTzUwbmQvQWQrL3dOQW91NUxCWlJydjJUNTR2ZnhzTDAzNzJSTERE?=
 =?utf-8?B?L1hTeTZyZGljOGhWdE9sMkY1Y1N3djZ2Nmw0VWtYTXVGdHJFWXFDcUZnalNj?=
 =?utf-8?B?VUNmWnZUd3ZMd0ZNdk9oRVB0dzVjNVB3WmM1WkVySmNycE1uY0Q4YWVwYSsw?=
 =?utf-8?B?bGRpaHpWcmJZeWJaMUNRY3JRMlMrQWlBKzErZS9XS3JOdlFtTUpyRC9OMXZC?=
 =?utf-8?B?Vkc0S0RGRGpHK0RES1pqcHFrOHEzRHpIckpTY3pMa3JCV2tjVjd5TUwySisx?=
 =?utf-8?B?VTloL0UzT3llakppS2hKOGNtdnpmbHZKdGJVbmR3UjFSWVdnendHMHd0cWxz?=
 =?utf-8?B?b2FnL1VDVXRlSXBKaUxzUWJQMUdnN1lqdXlrSXFZYTZZQisvY1NFaGZMSzVy?=
 =?utf-8?B?Myt4bmtVS1FRRXNZVmtnU0Jyc0ZxSGpWOXIvVVpxTWpuUGpkSi90VjVjSk1P?=
 =?utf-8?B?eUxNUGR3b3hXUzR4ckFZMmlBMlJZV2k4TFlwalNZcE9HVUQzWVprWGZtRXhM?=
 =?utf-8?Q?KsJetXMun5crJp4YMdSQ12leE2TSj0tdflW+us7pSGC7?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:ja;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OSZPR01MB8798.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(38070700021)(1580799027);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?UkQzRjlwRU0wdjFsL280MXo0dnE3a2RPalFsT2F6by9KcjVaamRUS1RUQXh0?=
 =?utf-8?B?aFdld0tocU04TjBzU0ZCMTkrYm4rUzFnWEVKRmRWUmdvVkVaR3crUS9UdUZ3?=
 =?utf-8?B?YklHZ0V0SDJDSWlPY1RhWTlpS1IySzMrUC84MEhwcXhaWkk0TmNxZnBvRHp4?=
 =?utf-8?B?SjNzTFFtL1NqYmdDaVZyUDJEM0JsL2dtdldLbklXeWhUY09CaDBTRTE5Skwv?=
 =?utf-8?B?WWpSczR6Vk9jN0VuNjdZdnFOanpHL3NiRjNIbDZSMjhsalYwS2o2L0wyWlVP?=
 =?utf-8?B?SmxkTVY0K2JIT2VremFlSUpYVmM4dDdwL1l2c0h6bmN2aUZXK20xQnNCVXZv?=
 =?utf-8?B?dXRFRk1IZ0ZLc0haaEYvY20zUGRyVEpxRW9iNEg5L2QvOWV4K004N0NDb0ow?=
 =?utf-8?B?WkdWL3RKVzJaRHNuQkdQdU1aeDZrSmpLc1FMOThoSnorZTBIS25OeDVacWRQ?=
 =?utf-8?B?N1FvSmxORktiUHhDUUpkNDJLK0pWZUxJRHM0OUJaVWZHZHQ5eG1WTXQwQjlJ?=
 =?utf-8?B?V21taHZTcEgwc0hXSmFiN2cyQXpMb3IzTWoxdjJzN2djdzhBaml3UEFsamd6?=
 =?utf-8?B?cWY0ajc0T3A3R0UzZUxWVXowTFdiRXhmcUxPYm9PdXlML2VacUZmdUdmc29H?=
 =?utf-8?B?S3ZzTkMzWUtoOW9JekNIN1FFSFY1aHdabnljK2hJbVlLd0xOR3pGZTlyRzV2?=
 =?utf-8?B?S0xuMCtMNlArejVDUEMwZnNqZ21JbVpOMitNcWJQTGZURUdTMzVTRHR3SkVi?=
 =?utf-8?B?WXlzQVNVTndOUHNQZGwrdEp1SzdFcHhQS0R6cURZVm4vaDdkMi9vSGxIVEll?=
 =?utf-8?B?dzNCcENnRmRQKzJOYjg0OGo1SzdKWmFiQ0YyMWVKWTlFVURseVk4NTdidHNI?=
 =?utf-8?B?NjlPc0NzUFdNdm5LRVdCQXIyRi8rQzlnYUd1TE1ueGhXREhQdDg2NmY3bDQw?=
 =?utf-8?B?WWNJeDNmNTBsVzV4aC9PYUI1NDBnQTA5N0IxMElTODNFd3VHQzduTUszeTFm?=
 =?utf-8?B?TWhEU0hLVlJyc1ArNkJnUzNOcWpFeC9UaE9oeFFJNzhKVnZreHpMYzhGYUUv?=
 =?utf-8?B?VmwyeVluQVZ2enkyQmFXaGZSUWxyczF4MWU5eVZ1MU9mQ1JYSk1IZzN2VHhJ?=
 =?utf-8?B?aDdhbVJlMEtpYzR0Ui9jdjk4b200N0hyVUE2SDk0ZHY1V0dIQUduL1Nwanh0?=
 =?utf-8?B?UlVpM3J1YmNNbXRETlhpYXNFcUx0eDIzdStnRkRObWc3bHhWODlLWjZCcDNi?=
 =?utf-8?B?NlJ3R0g3aHB1YlZ6bzBWMHBPeEFYbGQyZFE0aTBlNFNQRU92UkxDYXRVd1oz?=
 =?utf-8?B?YzB6YTY1cUhxOG5sd0htMDRxYzRsazlZdUdBc21wMVJVRGlmdEFVaXNFWFJS?=
 =?utf-8?B?cHNpOEwyRksvZFRjNm54Y3J1MjhBVTZLeE5sQURDNFBHZTRkTm5pazRML3hn?=
 =?utf-8?B?OFNkMFprdmkzMUtpUHZmdjc5TWFFOVhsUERHcWw5THNiK245WnBaRW9SNjgr?=
 =?utf-8?B?U2lpZkRRVkhpVllhWmh0SlVNTi9yWEZWaUIvMll0WW1qRjlzeS9QZUZQTUJa?=
 =?utf-8?B?T21tUVNtSFhpb0xPZUlNZndSOXdIOG9Ba0hTM2hTK2grbWIrSmY0aWlSdzFB?=
 =?utf-8?B?SmZzMnNVRFRkMUtCZjdBOFM5UDdRbWVaRjFpVjJSWkswZUVCTVlFMnZhdGlv?=
 =?utf-8?B?bXBWbFlPV2VHcUh6ZGUwcFgvNFk0WUpIRndpQXVnZVZhZk1vbkhxSUxkUC92?=
 =?utf-8?B?aFY4QVJmcVJQTjZ1aE5RTlp2VWdLSTRXNmFhbmtYcFJNL3pGMFYySk1lY2Ja?=
 =?utf-8?B?S0NuYk5Tc0xvM3ROUDhaM1BQMnowWjZCaEYzVHNrMW02ek9PelF0K2hPakdT?=
 =?utf-8?B?ZnFFMENOcW41QkV3ODhMUlVIREYvVjRKS0lvT3JIYUxVS05VYVpSWUtTbngy?=
 =?utf-8?B?c0FxQ1VqVmhlZ2VTcWlERDFGN0NmalBnVloyZHFjSDR6MkJ4RFd2T2V0eVJT?=
 =?utf-8?B?UlpxKzJ4WnlOZk8venhrL1lLUGkwY3JEa0NtVUxONjFqRk84OG1WdWZ6RzFZ?=
 =?utf-8?B?M2JpRVBVYUhMcmpieFJVR202UE92TVZZMHBRc1hiSDdoVkg4bGt0RW4ydUhL?=
 =?utf-8?B?dHo0OWYvaFZKaUZuWHkzZ3NwS0ZwbmMwMzNnVVhONHNTWGRJRFpZeUhhNnEw?=
 =?utf-8?B?aERvSGV4WEdhUkxtcStRTDRkWTE1VUJXWm9JcDNOV2JEckJ1Nk8yeXdjcW1k?=
 =?utf-8?B?OEdFV094MEZxV0t2c3lmSlorSHQvMWNHbFBSbXJJYlEvMk11TFVoVW9XZE00?=
 =?utf-8?B?QkwzUEx5NCtkSWlYOVJPOXh2cjV6cUM0L2szU01nT2krVlNLempMQT09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OSZPR01MB8798.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9bad75f3-7b01-42ec-e071-08de6acdec11
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Feb 2026 07:02:59.4008
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rGY1FNXHWIXICFHYQvC6bSrMx1SdElGLEmV5d4lAYW3JibTJhjEWF/GZKRR9csyll/ZXaxsjA/2o+GBf05fK/KzCH8avOqGji83w2BxLxcY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY4PR01MB17885

SGVsbG8gQmVuLCBGZW5naHVhIAoKPiBGcm9tOiBTaGFua2VyIERvbnRoaW5lbmkgPHNkb250aGlu
ZW5pQG52aWRpYS5jb20+Cj4gCj4gSW4gdGhlIFQyNDEgaW1wbGVtZW50YXRpb24gb2YgbWVtb3J5
LWJhbmR3aWR0aCBwYXJ0aXRpb25pbmcsIGluIHRoZSBhYnNlbmNlCj4gb2YgY29udGVudGlvbiBm
b3IgYmFuZHdpZHRoLCB0aGUgbWluaW11bSBiYW5kd2lkdGggc2V0dGluZyBjYW4gYWZmZWN0IHRo
ZQo+IGFtb3VudCBvZiBhY2hpZXZlZCBiYW5kd2lkdGguIFNwZWNpZmljYWxseSwgdGhlIGFjaGll
dmVkIGJhbmR3aWR0aCBpbiB0aGUKPiBhYnNlbmNlIG9mIGNvbnRlbnRpb24gY2FuIHNldHRsZSB0
byBhbnkgdmFsdWUgYmV0d2VlbiB0aGUgdmFsdWVzIG9mCj4gTVBBTUNGR19NQldfTUlOIGFuZCBN
UEFNQ0ZHX01CV19NQVguwqAgQWxzbywgaWYgTVBBTUNGR19NQldfTUlOIGlzIHNldAo+IHplcm8g
KGJlbG93IDAuNzgxMjUlKSwgb25jZSBhIGNvcmUgZW50ZXJzIGEgdGhyb3R0bGVkIHN0YXRlLCBp
dCB3aWxsIG5ldmVyCj4gbGVhdmUgdGhhdCBzdGF0ZS4KPiAKPiBUaGUgZmlyc3QgaXNzdWUgaXMg
bm90IGEgY29uY2VybiBpZiB0aGUgTVBBTSBzb2Z0d2FyZSBhbGxvd3MgdG8gcHJvZ3JhbQo+IE1Q
QU1DRkdfTUJXX01JTiB0aHJvdWdoIHRoZSBzeXNmcyBpbnRlcmZhY2UuIFRoaXMgcGF0Y2ggZW5z
dXJlcyBwcm9ncmFtCj4gTUJXX01JTj0xICgwLjc4MTI1JSkgd2hlbmV2ZXIgTVBBTUNGR19NQldf
TUlOPTAgaXMgcHJvZ3JhbW1lZC4KPiAKPiBJbiB0aGUgc2NlbmFyaW8gd2hlcmUgdGhlIHJlc2N0
cmwgZG9lc24ndCBzdXBwb3J0IHRoZSBNQldfTUlOIGludGVyZmFjZSB2aWEKPiBzeXNmcywgdG8g
YWNoaWV2ZSBiYW5kd2lkdGggY2xvc2VyIHRvIE1CV19NQVggaW4gdGhlIGFic2VuY2Ugb2YgY29u
dGVudGlvbiwKPiBzb2Z0d2FyZSBzaG91bGQgY29uZmlndXJlIGEgcmVsYXRpdmVseSBuYXJyb3cg
Z2FwIGJldHdlZW4gTUJXX01JTiBhbmQKPiBNQldfTUFYLiBUaGUgcmVjb21tZW5kYXRpb24gaXMg
dG8gdXNlIGEgNSUgZ2FwIHRvIG1pdGlnYXRlIHRoZSBwcm9ibGVtLgoKSSBoYXZlIGEgcXVlc3Rp
b24gcmVnYXJkaW5nIHRoZSBNQldfTUlOIHZhbHVlcy4gCkFyZSB0aGVyZSBhbnkgY2FzZXMgd2hl
cmUgdGhlIHN1bSBvZiBhbGwgTUJXX01JTiB2YWx1ZXMgZnJvbSBkaWZmZXJlbnQgY29udHJvbCBn
cm91cHMgZXhjZWVkcyAxMDAlPyAKQW5kIGlmIHNvLCBpcyBpdCBhY2NlcHRhYmxlIGZvciBpdCB0
byBleGNlZWQgMTAwJT8iCgpCZXN0IHJlZ2FyZHMsClNoYW9wZW5nIFRBTgoKPiBDbGVhciB0aGUg
ZmVhdHVyZSBNQldfTUlOIGZlYXR1cmUgZnJvbSB0aGUgY2xhc3MgdG8gZW5zdXJlIHdlIGRvbid0
Cj4gYWNjaWRlbnRhbGx5IGNoYW5nZSBiZWhhdmlvdXIgd2hlbiByZXNjdHJsIGFkZHMgc3VwcG9y
dCBmb3IgYSBNQldfTUlOCj4gaW50ZXJmYWNlLgo+IAo+IFRlc3RlZC1ieTogR2F2aW4gU2hhbiA8
Z3NoYW5AcmVkaGF0LmNvbT4KPiBUZXN0ZWQtYnk6IFNoYW9wZW5nIFRhbiA8dGFuLnNoYW9wZW5n
QGpwLmZ1aml0c3UuY29tPgo+IFNpZ25lZC1vZmYtYnk6IFNoYW5rZXIgRG9udGhpbmVuaSA8c2Rv
bnRoaW5lbmlAbnZpZGlhLmNvbT4KPiBTaWduZWQtb2ZmLWJ5OiBKYW1lcyBNb3JzZSA8amFtZXMu
bW9yc2VAYXJtLmNvbT4KPiBTaWduZWQtb2ZmLWJ5OiBCZW4gSG9yZ2FuIDxiZW4uaG9yZ2FuQGFy
bS5jb20+Cj4gLS0tCj4gWyBtb3JzZTogQWRkZWQgYXMgc2Vjb25kIHF1aXJrLCBhZGFwdGVkIHRv
IHVzZSB0aGUgbmV3IGludGVybWVkaWF0ZSB2YWx1ZXMKPiBpbiBtcGFtX2V4dGVuZF9jb25maWco
KSBdCj4gCj4gQ2hhbmdlcyBzaW5jZSByZmM6Cj4gTVBBTV9JSURSX05WSURJQV9UNDIxIC0+IE1Q
QU1fSUlEUl9OVklESUFfVDI0MQo+IEhhbmRsaW5nIHdoZW4gcmVzZXRfbWJ3X21pbiBpcyBzZXQK
PiAKPiBDaGFuZ2VzIHNpbmNlIHYzOgo+IE1vdmUgdGhlIDUlIGdhcCBwb2xpY3kgYmFjayBoZXJl
Cj4gQ2xlYXIgbWJ3X21pbiBmZWF0dXJlIGluIGNsYXNzCj4gLS0tCj4gwqBEb2N1bWVudGF0aW9u
L2FyY2gvYXJtNjQvc2lsaWNvbi1lcnJhdGEucnN0IHzCoCAyICsKPiDCoGRyaXZlcnMvcmVzY3Ry
bC9tcGFtX2RldmljZXMuY8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHwgNTAgKysrKysrKysr
KysrKysrKysrKy0tCj4gwqBkcml2ZXJzL3Jlc2N0cmwvbXBhbV9pbnRlcm5hbC5owqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgIHzCoCAxICsKPiDCoDMgZmlsZXMgY2hhbmdlZCwgNTAgaW5zZXJ0aW9u
cygrKSwgMyBkZWxldGlvbnMoLSkKPiAKPiBkaWZmIC0tZ2l0IGEvRG9jdW1lbnRhdGlvbi9hcmNo
L2FybTY0L3NpbGljb24tZXJyYXRhLnJzdCBiL0RvY3VtZW50YXRpb24vYXJjaC9hcm02NC9zaWxp
Y29uLWVycmF0YS5yc3QKPiBpbmRleCA0ZTg2Yjg1ZmUzZDYuLmIxOGJjNzA0ZDRhMSAxMDA2NDQK
PiAtLS0gYS9Eb2N1bWVudGF0aW9uL2FyY2gvYXJtNjQvc2lsaWNvbi1lcnJhdGEucnN0Cj4gKysr
IGIvRG9jdW1lbnRhdGlvbi9hcmNoL2FybTY0L3NpbGljb24tZXJyYXRhLnJzdAo+IEBAIC0yNDgs
NiArMjQ4LDggQEAgc3RhYmxlIGtlcm5lbHMuCj4gwqArLS0tLS0tLS0tLS0tLS0tLSstLS0tLS0t
LS0tLS0tLS0tLSstLS0tLS0tLS0tLS0tLS0tLSstLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LSsKPiDCoHwgTlZJRElBwqDCoMKgwqDCoMKgwqDCoCB8IFQyNDEgTVBBTcKgwqDCoMKgwqDCoCB8
IFQyNDEtTVBBTS0xwqDCoMKgwqAgfCBOL0HCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqAgfAo+IMKgKy0tLS0tLS0tLS0tLS0tLS0rLS0tLS0tLS0tLS0tLS0t
LS0rLS0tLS0tLS0tLS0tLS0tLS0rLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0rCj4gK3wg
TlZJRElBwqDCoMKgwqDCoMKgwqDCoCB8IFQyNDEgTVBBTcKgwqDCoMKgwqDCoCB8IFQyNDEtTVBB
TS00wqDCoMKgwqAgfCBOL0HCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqAgfAo+ICsrLS0tLS0tLS0tLS0tLS0tLSstLS0tLS0tLS0tLS0tLS0tLSstLS0tLS0t
LS0tLS0tLS0tLSstLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLSsKPiDCoCstLS0tLS0tLS0t
LS0tLS0tKy0tLS0tLS0tLS0tLS0tLS0tKy0tLS0tLS0tLS0tLS0tLS0tKy0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tKwo+IMKgfCBGcmVlc2NhbGUvTlhQwqAgfCBMUzIwODBBL0xTMTA0M0Eg
fCBBLTAwODU4NcKgwqDCoMKgwqDCoMKgIHwgRlNMX0VSUkFUVU1fQTAwODU4NcKgwqDCoMKgwqDC
oMKgwqAgfAo+IMKgKy0tLS0tLS0tLS0tLS0tLS0rLS0tLS0tLS0tLS0tLS0tLS0rLS0tLS0tLS0t
LS0tLS0tLS0rLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0rCj4gZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvcmVzY3RybC9tcGFtX2RldmljZXMuYyBiL2RyaXZlcnMvcmVzY3RybC9tcGFtX2Rldmlj
ZXMuYwo+IGluZGV4IDc2YzhjZmNlZjNjMC4uMzdhMTA1ZDk1ZDY2IDEwMDY0NAo+IC0tLSBhL2Ry
aXZlcnMvcmVzY3RybC9tcGFtX2RldmljZXMuYwo+ICsrKyBiL2RyaXZlcnMvcmVzY3RybC9tcGFt
X2RldmljZXMuYwo+IEBAIC02NzksNiArNjc5LDEyIEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3QgbXBh
bV9xdWlyayBtcGFtX3F1aXJrc1tdID0gewo+IMKgwqDCoMKgwqDCoMKgwqAgLmlpZHJfbWFza8Kg
ID0gTVBBTV9JSURSX01BVENIX09ORSwKPiDCoMKgwqDCoMKgwqDCoMKgIC53b3JrYXJvdW5kID0g
VDI0MV9TQ1JVQl9TSEFET1dfUkVHUywKPiDCoMKgwqDCoMKgwqDCoMKgIH0sCj4gK8KgwqDCoMKg
wqDCoCB7Cj4gK8KgwqDCoMKgwqDCoCAvKiBOVklESUEgdDI0MSBlcnJhdHVtIFQyNDEtTVBBTS00
ICovCj4gK8KgwqDCoMKgwqDCoCAuaWlkcsKgwqDCoMKgwqDCoCA9IE1QQU1fSUlEUl9OVklESUFf
VDI0MSwKPiArwqDCoMKgwqDCoMKgIC5paWRyX21hc2vCoCA9IE1QQU1fSUlEUl9NQVRDSF9PTkUs
Cj4gK8KgwqDCoMKgwqDCoCAud29ya2Fyb3VuZCA9IFQyNDFfRk9SQ0VfTUJXX01JTl9UT19PTkUs
Cj4gK8KgwqDCoMKgwqDCoCB9LAo+IMKgwqDCoMKgwqDCoMKgwqAgeyBOVUxMIH0gLyogU2VudGlu
ZWwgKi8KPiDCoH07Cj4gwqAKPiBAQCAtMTQ2NCw2ICsxNDcwLDMxIEBAIHN0YXRpYyB2b2lkIG1w
YW1fcXVpcmtfcG9zdF9jb25maWdfY2hhbmdlKHN0cnVjdCBtcGFtX21zY19yaXMgKnJpcywgdTE2
IHBhcnRpZCwKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBtcGFtX2FwcGx5X3Qy
NDFfZXJyYXR1bShyaXMsIHBhcnRpZCk7Cj4gwqB9Cj4gwqAKPiArc3RhdGljIHUxNiBtcGFtX3dh
X3QyNDFfZm9yY2VfbWJ3X21pbl90b19vbmUoc3RydWN0IG1wYW1fcHJvcHMgKnByb3BzKQo+ICt7
Cj4gK8KgwqDCoMKgwqDCoCB1MTYgbWF4X2h3X3ZhbHVlLCBtaW5faHdfZ3JhbnVsZSwgcmVzMF9i
aXRzOwo+ICsKPiArwqDCoMKgwqDCoMKgIHJlczBfYml0cyA9IDE2IC0gcHJvcHMtPmJ3YV93ZDsK
PiArwqDCoMKgwqDCoMKgIG1heF9od192YWx1ZSA9ICgoMSA8PCBwcm9wcy0+YndhX3dkKSAtIDEp
IDw8IHJlczBfYml0czsKPiArwqDCoMKgwqDCoMKgIG1pbl9od19ncmFudWxlID0gfm1heF9od192
YWx1ZTsKPiArCj4gK8KgwqDCoMKgwqDCoCByZXR1cm4gbWluX2h3X2dyYW51bGUgKyAxOwo+ICt9
Cj4gKwo+ICtzdGF0aWMgdTE2IG1wYW1fd2FfdDI0MV9jYWxjX21pbl9mcm9tX21heChzdHJ1Y3Qg
bXBhbV9jb25maWcgKmNmZykKPiArewo+ICvCoMKgwqDCoMKgwqAgdTE2IHZhbCA9IDA7Cj4gKwo+
ICvCoMKgwqDCoMKgwqAgaWYgKG1wYW1faGFzX2ZlYXR1cmUobXBhbV9mZWF0X21id19tYXgsIGNm
ZykpIHsKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB1MTYgZGVsdGEgPSAoKDUgKiBN
UEFNQ0ZHX01CV19NQVhfTUFYKSAvIDEwMCkgLSAxOwo+ICsKPiArwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoCBpZiAoY2ZnLT5tYndfbWF4ID4gZGVsdGEpCj4gK8KgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHZhbCA9IGNmZy0+bWJ3X21heCAtIGRlbHRhOwo+
ICvCoMKgwqDCoMKgwqAgfQo+ICsKPiArwqDCoMKgwqDCoMKgIHJldHVybiB2YWw7Cj4gK30KPiAr
Cj4gwqAvKiBDYWxsZWQgdmlhIElQSS4gQ2FsbCB3aGlsZSBob2xkaW5nIGFuIFNSQ1UgcmVmZXJl
bmNlICovCj4gwqBzdGF0aWMgdm9pZCBtcGFtX3JlcHJvZ3JhbV9yaXNfcGFydGlkKHN0cnVjdCBt
cGFtX21zY19yaXMgKnJpcywgdTE2IHBhcnRpZCwKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHN0cnVj
dCBtcGFtX2NvbmZpZyAqY2ZnKQo+IEBAIC0xNTA2LDkgKzE1MzcsMTkgQEAgc3RhdGljIHZvaWQg
bXBhbV9yZXByb2dyYW1fcmlzX3BhcnRpZChzdHJ1Y3QgbXBhbV9tc2NfcmlzICpyaXMsIHUxNiBw
YXJ0aWQsCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
IG1wYW1fd3JpdGVfcGFydHNlbF9yZWcobXNjLCBNQldfUEJNLCBjZmctPm1id19wYm0pOwo+IMKg
wqDCoMKgwqDCoMKgwqAgfQo+IMKgCj4gLcKgwqDCoMKgwqDCoCBpZiAobXBhbV9oYXNfZmVhdHVy
ZShtcGFtX2ZlYXRfbWJ3X21pbiwgcnByb3BzKSAmJgo+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoCBt
cGFtX2hhc19mZWF0dXJlKG1wYW1fZmVhdF9tYndfbWluLCBjZmcpKQo+IC3CoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgIG1wYW1fd3JpdGVfcGFydHNlbF9yZWcobXNjLCBNQldfTUlOLCAwKTsK
PiArwqDCoMKgwqDCoMKgIGlmIChtcGFtX2hhc19mZWF0dXJlKG1wYW1fZmVhdF9tYndfbWluLCBy
cHJvcHMpKSB7Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgdTE2IHZhbCA9IDA7Cj4g
Kwo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGlmIChtcGFtX2hhc19xdWlyayhUMjQx
X0ZPUkNFX01CV19NSU5fVE9fT05FLCBtc2MpKSB7Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgIHUxNiBtaW4gPSBtcGFtX3dhX3QyNDFfZm9yY2VfbWJ3X21p
bl90b19vbmUocnByb3BzKTsKPiArCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgIHZhbCA9IG1wYW1fd2FfdDI0MV9jYWxjX21pbl9mcm9tX21heChjZmcpOwo+
ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBpZiAodmFsIDwg
bWluKQo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqAgdmFsID0gbWluOwo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIH0K
PiArCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgbXBhbV93cml0ZV9wYXJ0c2VsX3Jl
Zyhtc2MsIE1CV19NSU4sIHZhbCk7Cj4gK8KgwqDCoMKgwqDCoCB9Cj4gwqAKPiDCoMKgwqDCoMKg
wqDCoMKgIGlmIChtcGFtX2hhc19mZWF0dXJlKG1wYW1fZmVhdF9tYndfbWF4LCBycHJvcHMpICYm
Cj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIG1wYW1faGFzX2ZlYXR1cmUobXBhbV9mZWF0X21i
d19tYXgsIGNmZykpIHsKPiBAQCAtMjMwNCw2ICsyMzQ1LDkgQEAgc3RhdGljIHZvaWQgbXBhbV9l
bmFibGVfbWVyZ2VfY2xhc3NfZmVhdHVyZXMoc3RydWN0IG1wYW1fY29tcG9uZW50ICpjb21wKQo+
IMKgCj4gwqDCoMKgwqDCoMKgwqDCoCBsaXN0X2Zvcl9lYWNoX2VudHJ5KHZtc2MsICZjb21wLT52
bXNjLCBjb21wX2xpc3QpCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgX19jbGFz
c19wcm9wc19taXNtYXRjaChjbGFzcywgdm1zYyk7Cj4gKwo+ICvCoMKgwqDCoMKgwqAgaWYgKG1w
YW1faGFzX3F1aXJrKFQyNDFfRk9SQ0VfTUJXX01JTl9UT19PTkUsIGNsYXNzKSkKPiArwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBtcGFtX2NsZWFyX2ZlYXR1cmUobXBhbV9mZWF0X21id19t
aW4sICZjbGFzcy0+cHJvcHMpOwo+IMKgfQo+IMKgCj4gwqAvKgo+IGRpZmYgLS1naXQgYS9kcml2
ZXJzL3Jlc2N0cmwvbXBhbV9pbnRlcm5hbC5oIGIvZHJpdmVycy9yZXNjdHJsL21wYW1faW50ZXJu
YWwuaAo+IGluZGV4IDZiODMyZjIxMDBkOS4uZjZiZjQ2MjA1OGQ5IDEwMDY0NAo+IC0tLSBhL2Ry
aXZlcnMvcmVzY3RybC9tcGFtX2ludGVybmFsLmgKPiArKysgYi9kcml2ZXJzL3Jlc2N0cmwvbXBh
bV9pbnRlcm5hbC5oCj4gQEAgLTIyMCw2ICsyMjAsNyBAQCBzdHJ1Y3QgbXBhbV9wcm9wcyB7Cj4g
wqAvKiBXb3JrYXJvdW5kIGJpdHMgZm9yIG1zYy0+cXVpcmtzICovCj4gwqBlbnVtIG1wYW1fZGV2
aWNlX3F1aXJrcyB7Cj4gwqDCoMKgwqDCoMKgwqDCoCBUMjQxX1NDUlVCX1NIQURPV19SRUdTLAo+
ICvCoMKgwqDCoMKgwqAgVDI0MV9GT1JDRV9NQldfTUlOX1RPX09ORSwKPiDCoMKgwqDCoMKgwqDC
oMKgIE1QQU1fUVVJUktfTEFTVAo+IMKgfTsKPiDCoAo+IC0tIAo+IDIuNDMuMAo+IAo+IA==
