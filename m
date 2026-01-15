Received: from OS0P286CU010.outbound.protection.outlook.com (mail-japanwestazon11011053.outbound.protection.outlook.com [40.107.74.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B60F337B9F
	for <kvmarm@lists.linux.dev>; Thu, 15 Jan 2026 10:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.74.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768471561; cv=fail; b=SsumUIvDbe9plavkcan3nvgun5Hf+46BJVYkwEfTOHU7cOuleyJuTrf6FykGy4kDa76gv+I93RMK6DmkW2X+aU5O/ncB/vetxMT1BOdWZcEKC0RMf2bBIWcsWIbrwHe3dRjHo3Gg5JX9+P9oM0xnHGGtBWa06iN5iYpWLgh5/9s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768471561; c=relaxed/simple;
	bh=AiXHpI2aeCWgxuJtqkbo68iKU0+DqoBSGJAArItoedM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=cezgXCLQPbHBNl1ROuaNdKc7vvHIupSLfPgY9CPbw0IhdFH1aWoSlQS4YAH4zTo8NBgCCdPYEdhc0ib4Pm4SzPM13IA31yzQowJkdPck6HxEw3MhFjWNjPIjLYggRm6FC3dox2JbaYHnIfyW4zjrOzzM/+Jsjx6sfx694EiH/Sw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=QkGOJam5; arc=fail smtp.client-ip=40.107.74.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="QkGOJam5"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LctZwICswuCZgWeYwALg8dHMe3CW/kkmuT2RjpJ6JpRY7XusWS/AK+OyM5TQqmNNPjkL8GUXzefrY6NM5Pf7+Nb/rIYNXNatpy0YAQYqAbnCGWhFyhJEPhhsU5BUK4dFme0Q+UrrI4wJIN8Q1jKAekuvqsYjYPwfoYdOUNbWiZGGZJ6uZCVz2iuHnDTO0+6J5rtcVL+vprrErFjr6UTr1fZU8lj9aA4vr2rQE+oxAME8Raq++HaN+I2Xg3lRvUWoINYJGDOkd2p+8du6JOqYbwfmC82ZLS7k0CfMkuWEayaUVBH8SsGT6t36+TY+FucndVmcwE8KU9NOtZan5n1gLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MYbZuqZh2cbHN7lkhbSnYIFUAnbjEcoGeCu0riANcSw=;
 b=PzxAEN3eJdL9rosBPuMKY3bsJkKLLFMaNnQc4K71mb1qW7fwyGHFEYZ73aOk7EPSmB6jPsdTiIGnSfr96oVVJVYES03iGtR0FuZ2RdgPImpt2thOBXrEozrPC0/9pQqot/DSabeySB1MBdJ0DqPsoBGGHD9ttg8+ODEXmCG84nOeyGBQ6ohGlQ337I3AQDKrwT7j+MjEoCB2C4wHP2hH6WUcy+hHi/HSzjm8NSrBj6DPRC2ThqY5kBy/BnbMDNqdbKo6qtqUA1Lxb0r18iH+wZhnBTOyuCwjyEQyOen5dB6kzCsUB7WoAPN+nFh3s2Wcko3dLaqYaVMRL9nRKoNQEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fujitsu.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MYbZuqZh2cbHN7lkhbSnYIFUAnbjEcoGeCu0riANcSw=;
 b=QkGOJam5/a5rhg60rC1WzIgF/ncF0fbgqEPu8vCX02c0nw+gorzuvQzenOdXxplcAvFyLIESsCBq3YCtO2eGSFN2v65cC5J2qcnCPjnMwW6Z5wkE+nyd4uLm27rBVPd3i5IPtMQWM3/zc5QYyUAutuNRqUT/XFSVX8LSuz5X6O7Bn/a8IRsoPJQwlZVUO3Twzw6GhmphZy6I9nHsV17pDE4DVIfNMfrzXc8CQIYi3N0aw3l2wWnfwhulRoqSBwuY1VGqdvI0+j3hkuuwL67KOpuDM3dK+cs1yTbQPzoFbS5ZExvE5ZRgqc/DTx1aYMjeVATy0xPySSfgwc8BwM1kaw==
Received: from OSZPR01MB8798.jpnprd01.prod.outlook.com (2603:1096:604:15f::6)
 by TYRPR01MB14272.jpnprd01.prod.outlook.com (2603:1096:405:21f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.5; Thu, 15 Jan
 2026 10:05:49 +0000
Received: from OSZPR01MB8798.jpnprd01.prod.outlook.com
 ([fe80::e366:d390:4474:8cfa]) by OSZPR01MB8798.jpnprd01.prod.outlook.com
 ([fe80::e366:d390:4474:8cfa%6]) with mapi id 15.20.9520.003; Thu, 15 Jan 2026
 10:05:49 +0000
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
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>
Subject: Re: [PATCH v3 37/47] arm_mpam: resctrl: Update the rmid reallocation
 limit
Thread-Topic: [PATCH v3 37/47] arm_mpam: resctrl: Update the rmid reallocation
 limit
Thread-Index: AQHcg+VXp7Ew5UT1A0e22/ASA/kWYrVTBSVz
Date: Thu, 15 Jan 2026 10:05:49 +0000
Message-ID:
 <OSZPR01MB8798ED2AFBA3EDFA0D2AFB9B8B8CA@OSZPR01MB8798.jpnprd01.prod.outlook.com>
References: <20260112165914.4086692-1-ben.horgan@arm.com>
 <20260112165914.4086692-38-ben.horgan@arm.com>
In-Reply-To: <20260112165914.4086692-38-ben.horgan@arm.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Enabled=True;MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_SiteId=a19f121d-81e1-4858-a9d8-736e267fd4c7;MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_SetDate=2026-01-15T10:05:48.923Z;MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Name=FUJITSU-RESTRICTED;MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_ContentBits=1;MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Method=Standard;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: OSZPR01MB8798:EE_|TYRPR01MB14272:EE_
x-ms-office365-filtering-correlation-id: 345e2d40-c618-415f-a0cc-08de541da8a5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|7416014|376014|366016|1580799027|38070700021;
x-microsoft-antispam-message-info:
 =?iso-2022-jp?B?YXo3M2dHWXNzMkpDdGM0OHFmazhqYkJHbWtkRHhVQXhYdW1CeGkrY1k0?=
 =?iso-2022-jp?B?OExicmE5Vyt5aW54TGJYbjV2RTEvN1V2MER5bjZLTENVWGRwc2xyazEx?=
 =?iso-2022-jp?B?dEVsSjQ2UjVGcjZhVGRYU25ma0tUUDdNcUJMSGhXcUwwSWFINmVYNUho?=
 =?iso-2022-jp?B?UXhndGRTZ1o3Zy80RWxENzNZdFN6T2RNaEdJbFJXSXprY01FUERBcGNk?=
 =?iso-2022-jp?B?TUVzWnRwaDFJaFk5Y3BzNy9Ndm5vV1VTbUtteUlWMVUzWXFTK1RLMDl0?=
 =?iso-2022-jp?B?M1BraUhBK0tET2ZtM3V2SmFVdGxTeEJYSi9iNnlMOVdDSXk5NGYrTEtY?=
 =?iso-2022-jp?B?emlLS3hnMU5oalBiVnJmYzN5WmptMHo3STN5TWFwVk9wZFFob2xrUHQr?=
 =?iso-2022-jp?B?MUZLWE91TDdsQUNrTjZKYVl6Y1hQUWQ1by9XQjJuU3pyMUZ2ZjFqMHNi?=
 =?iso-2022-jp?B?ektRRFBNRndkVEZobDJMMHZvNUlzVlJRYmdTbU1qSm9XaDVuTVE0Y2d2?=
 =?iso-2022-jp?B?c3JqQ09DaG1pdlg4T01nWmFpcTNyemw3eDhKbjJxWTlTbE5rSG1leFps?=
 =?iso-2022-jp?B?RzVPQWxzSWtKcVc1T1ZiUHo0R1pZVGxoMmp2bXZTbUtDSXd1bEF3MjFB?=
 =?iso-2022-jp?B?NXV3OUxqc2lYNCsxNXkvb0Y2ZzE3bUozZHpzTFo4ZXdvVXJDTGw1Q0FS?=
 =?iso-2022-jp?B?TXY4NC93VmZpTFE4dEJhcXdKL3Q1d3dnNG1RV0YzUXZCN1QrdFNSKy9J?=
 =?iso-2022-jp?B?RDRNVWxjYllHMlVPVE1xRGRnc2JyUzJseVJpRC84NzFOQ0d5TFB3VzdI?=
 =?iso-2022-jp?B?L1VhaWw3eWd2cmxRNjR4MG8zOG1idzVtVk5abXBZVklhZ0RTV0hOTDlv?=
 =?iso-2022-jp?B?K242Z3JlMlUvRjB6SzNPdXdsNERRVHJOL2MyaE5zV2JIWEtkL0l1OE1H?=
 =?iso-2022-jp?B?ekJYdVNIc0RVbGV3K0wrZ2FmeUFzeWZFS1lWZEl3TVl4S0Z3aHpLbVVW?=
 =?iso-2022-jp?B?TldsYTJ2UW1MOHl3SlNiYlplNzhXRlcxY3pqYU54dnErWHdxUnlOdkJC?=
 =?iso-2022-jp?B?elBDNnNOWEdsdW1OUUFBUjExQXVVRmcxVjlrVlpJR2d4MEZWSXdCeERJ?=
 =?iso-2022-jp?B?WVA1ZUVudFV5NUtOeWppc3hROHJZZXBnU0FhRmxGTDFtdDBzMmtTWkV1?=
 =?iso-2022-jp?B?emR1K3VPdWE5RER5MkdGdVRpNkdoMWxkWUIzL3ExTUp0cGhBMDRSK1JG?=
 =?iso-2022-jp?B?UGtGeHFBSmtxUHViSi8vcGo0UWIxMk44ajBWMXl5QW11emFPSXFvSTEw?=
 =?iso-2022-jp?B?dHp2WGJHcUZ0R1ZSOEtVWEw3TmhONWhmekZJaFZwVldObEJEUnlHUStD?=
 =?iso-2022-jp?B?MFBpanBaSk1qUFVmYWNFMVQ5YzBjRURLMmpKZGo1bWtEL3lBcUJwcFVP?=
 =?iso-2022-jp?B?ZmNGL3hDaFllWUF2K2FvNm03T3NpaVhlTVNqSEd4eHBGd1B2QndWSmp1?=
 =?iso-2022-jp?B?Ry94QlFZZHZFOC9QOXpXSXVmT1R2SlEwQ2IzRE5ONXlPSlh1VHVVUlU4?=
 =?iso-2022-jp?B?WEpFdUIvellHUkt1aHBOV0dwK3c4bmlEMFgwSElmWXJtczdtZHE4RGR5?=
 =?iso-2022-jp?B?UklseFJGZmNTK0ZqenZsZEFhSzdEYVBSeGlYUWpGaUdRNStPcHhOUmtt?=
 =?iso-2022-jp?B?dTUyWXZXYkFLd3pkWXpxZW1MbXdicW96Nmg3VzBhVmFxbWowNytMTnZ3?=
 =?iso-2022-jp?B?OG9hVUI3WHYxNTQ3UWRSdkxKVmhyK2VvRm9NOXFpMVQrNnZXbFhpZUQr?=
 =?iso-2022-jp?B?WWNvbVdkNm1zdEhEVXZ6dXFqY1greDBmWEx0bzcwV0RPdjJUamJZYmU3?=
 =?iso-2022-jp?B?RjVpWHRVRXhjcG1mSHFWTkJmbFN0Yi9oUytzMVZmZTd0eWFJcGxQdjVL?=
 =?iso-2022-jp?B?dlhBUGRibUlXQVk4d2twdEJnR1ZNMC8zSzdkRDJvdmlKUVhNV1B5cVNw?=
 =?iso-2022-jp?B?K0RUVFpKTEoySGpua05Eb1NXbWlpTmhaN3g3c3RPVUhrc2tFVkxRbURD?=
 =?iso-2022-jp?B?WVdHbmsreUozNk5WZ0Z3YTN0a0Fqd2owWHdXazhZSUs2Vy8ySXB3aEhO?=
 =?iso-2022-jp?B?M0FRbWp4aEFseEU4RE5DWi9VRVpNb0xjOTFXUkM1WnhLOTUvRjVqQzdG?=
 =?iso-2022-jp?B?MGZSczVWMC84ak05VnpYTEtzUnJjYnZveTg0ZkpPZ2ZERXNnYUlhMFFU?=
 =?iso-2022-jp?B?SSt2Zm1nOE9TWDk3T0lPZG1UMmxlZ0o0WE1IcVZJM1VLRGV2UUxkNndZ?=
 =?iso-2022-jp?B?dE1oRGZoUEVBL1J4cWVkM3dVV0JsSFRONWdlM1cyVm42TEV2a0o4a29V?=
 =?iso-2022-jp?B?UXI2SXlhVUMxZGR4WGV1OGdqVVRRdFBZdzA=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:ja;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OSZPR01MB8798.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(1580799027)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-2022-jp?B?dCtLTElxbXRYSVJ1anNpc3QyRkM1QUsvYThiLzBwdVgzZWpVVHBSajh2?=
 =?iso-2022-jp?B?YlFPZ0NhTHN6ekJmQTN2SHhSTThvdmkzbHBSNTZHWFNWa0xTTXFtSTE2?=
 =?iso-2022-jp?B?azZYS0ViTUxEU0RpK1dpNm92eCtYeEpMNEY0ZHpFM0ZIMnVyUzVYSDZl?=
 =?iso-2022-jp?B?WnQ2dnNsNGFCMkdMVkpaLzBFS3h0ZFk5aFhKZG55dG1aeGpTZDczNFlq?=
 =?iso-2022-jp?B?VGhnbit3VzVwUlFiL0g0NEpKcitmVmdSMFRhNG8xRjdlQktpeUhZdFdV?=
 =?iso-2022-jp?B?dlRVTmlLRmlBN0hudkdBNGdUblFpSmhZd0NYMEh2S0hoZ1VDVGpNK09D?=
 =?iso-2022-jp?B?YU5yTm1hUUlwNnlWUGRBMnhrUndBQVRaN2JxTHVwMUpBSHFRRjFDSjlB?=
 =?iso-2022-jp?B?VE8veEU0WTFuNkg5QytOODN1OWtHV2lkMmRaMDl2bTNCWTJ4Qm1EZ0hX?=
 =?iso-2022-jp?B?R2tubEdZQW0zSnFmV040OVBqekJwbzRPRXhIY1UwL2pLVzljWmoyS0dp?=
 =?iso-2022-jp?B?U2laUFVuVlQ5N3BqQWoxL01KSDJjdjBlT3JxZVYvWmVTTXFPQ3dOeWN1?=
 =?iso-2022-jp?B?MUpBbGpsZ3I0Z0lCVUJEK05DaGdpa0RKa1dqaDBYaUVKV2FGUlVRajl2?=
 =?iso-2022-jp?B?cVBCNFNjWEhUY1Q4emlvemlRd2tFZFRwbnhCYVQrREVROHYzYmM5dW5z?=
 =?iso-2022-jp?B?RWFCdjlBbkY3VDdPMGtDSnFFcTRZTy9NSTJGWHp1UnRYUzkxcnpuSXp0?=
 =?iso-2022-jp?B?VjlaeC9FMVAxOWFBMGh0VVJ0T2xTODVJRjlaVUIwTWhQcmNxcmxSbDgz?=
 =?iso-2022-jp?B?YUVOL2R0c0paMkgvRVJkdFR2UEpVMW5Pc0l0NmJHT3h6dXNPSTFseXh3?=
 =?iso-2022-jp?B?QnlORjJuYW9tQ0J6SmNpeUR6aUQ1T2tBMmEvTVAzTE9FdkRpMlRWNitU?=
 =?iso-2022-jp?B?bEJ5c0JrR1RGNm1EalRLcFBtTXg3NXA4M2N4dzNLS0kyT2JySk4rdTFW?=
 =?iso-2022-jp?B?S3B1dlV0SnhCbmh6MjUvc2JuN0p6QWovNlBvbmlweWQxSlFRekpnZXlt?=
 =?iso-2022-jp?B?dGlQbC9aRktCUmoxcHZYMVowc1pEYUdiSDlQR2l1N2l4U01wMXpTTDRt?=
 =?iso-2022-jp?B?ZGt6QkhyajFKV1A3ZjBGZDNJYkpMMHlJVVVzcHZSbWJmQ090Wm5LcGJa?=
 =?iso-2022-jp?B?aWRoQURkcEMzRXdKYW1CWEpOcXgwOUR3c0pYRlJobG9SSXdmUUhpRy92?=
 =?iso-2022-jp?B?b1JsRys1Q0EyMmk3eVU5VWpXWjQrcHJncWI3M2VDNGk2WDZkbkFZckZL?=
 =?iso-2022-jp?B?cnNONTZsejMwRk1aQ203TnpFbVJmSVR1akZWTCtqWmdVRkZmU1doTEdp?=
 =?iso-2022-jp?B?TmNRV29KcHg3ZTI0Z3BIYjBuNDhQRENkdFcrSDdRN1RBbTFjY2cyZmJT?=
 =?iso-2022-jp?B?VytRQ0JyM1NoSE03UzVDbHpoazdOc2ZCcXg3NS9MekVTREllTGxrOGNt?=
 =?iso-2022-jp?B?THJGMFp3ZzlKT3FZR056NjdlU3NNU2RqT0JVRUM5dmRZQjU0WmdUalps?=
 =?iso-2022-jp?B?MUM2YzFzbFBRR1B1SVVPcU1TNHBySWttL1JGZHVFenJBM2tBSlZYUVFk?=
 =?iso-2022-jp?B?dHY3TzNUY2s4Q1Jwb2hTTXQrM1FPaVBzZ0VHUFpuUEZJcTNCamI5U2o4?=
 =?iso-2022-jp?B?TWd3cWhRWG9lNi9XNTZWcGludFFHS1NhOUhlNE40WWhJOGtyMUM2YW8r?=
 =?iso-2022-jp?B?b0kyUjdPcUJTODljQUE2OURxdjdzcGxmUG9mM205K05RWTYzMU01UlpW?=
 =?iso-2022-jp?B?amJrV25MUlBzQlNzczh3SkZWeFNZRC9SSG9KbXNsSnpJUWJROHh2dnZ0?=
 =?iso-2022-jp?B?WVNwSHorait3MGY3emxua2ZUb0tBQnRibzFKYkV3WFE1eXE0SWVRN0RK?=
 =?iso-2022-jp?B?Uit0Q2ptT2xnTE1pYlBhOWRZZjdFRVA2YmZqRCtWVHFuZ0dwOUlmdlZa?=
 =?iso-2022-jp?B?QUtKY2E3L0VmU3lFT0MxWXdZTE45dDNJYzhBTm9aNVVNU29MNnBiZGxw?=
 =?iso-2022-jp?B?K2tDNkxmUFhsZXQ0Tnp5RENMZ1BGUVRaZDEvZnVTWW04Tkx1eGtHOS9Q?=
 =?iso-2022-jp?B?bjliNlc4MnA2elJDKzhYdW1pNThWeWNWWG1oV3VmVitwV3MxYUlaK29C?=
 =?iso-2022-jp?B?cU1HaStVMTQyblp0NmN1emQ2eEZZTFZqMEh0dU9vR3pnWXJNQzEvaWJv?=
 =?iso-2022-jp?B?Y3hoc2swNWlkSXZZcTI5M2xDVEsvcEZ5UkJNU1JHMXdpL0hwcGcvTHI2?=
 =?iso-2022-jp?B?QmFaOW9vRFgvTXV0TjVXWWM0a0I1OW1LajJGZWIrUkdvekExdFRXRktY?=
 =?iso-2022-jp?B?M0RzUWgvbEh0SFA5cTJsQk0xb1dHVzQ0ZkUrckMvVXV0TGU3RXUzeUJR?=
 =?iso-2022-jp?B?alRUMWFpcTRCbStUc3JWL3B0UFViTTlTWE81TWdibnV4cUt2MkcwVUNR?=
 =?iso-2022-jp?B?ZUZsMG9iSjFXaGJhVlBoQmFRM0tqb1dqcHZmUT09?=
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OSZPR01MB8798.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 345e2d40-c618-415f-a0cc-08de541da8a5
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2026 10:05:49.3264
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Z2fAWToYh+9loa6kiAzz8gkLmcKenrfDOXoE9NtQDtKWf+eT3mFq2SPSLYUxQGhoLa7+/hZUSRoH6U8OsLe0JP1H7Z5JDlBrliECv4GR1zs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYRPR01MB14272

Hello Ben,=0A=
=0A=
> From: James Morse <james.morse@arm.com>=0A=
> =0A=
> resctrl's limbo code needs to be told when the data left in a cache is=0A=
> small enough for the partid+pmg value to be re-allocated.=0A=
> =0A=
> x86 uses the cache size divided by the number of rmid users the cache may=
=0A=
> have. Do the same, but for the smallest cache, and with the number of=0A=
> partid-and-pmg users.=0A=
> =0A=
> Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>=0A=
> Signed-off-by: James Morse <james.morse@arm.com>=0A=
> Signed-off-by: Ben Horgan <ben.horgan@arm.com>=0A=
> ---=0A=
> Changes since v2:=0A=
> Move waiting for cache info into it's own patch=0A=
> ---=0A=
>  drivers/resctrl/mpam_resctrl.c | 35 ++++++++++++++++++++++++++++++++++=
=0A=
>  1 file changed, 35 insertions(+)=0A=
> =0A=
> diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctr=
l.c=0A=
> index 5adc78f9c96f..a6be3ce84241 100644=0A=
> --- a/drivers/resctrl/mpam_resctrl.c=0A=
> +++ b/drivers/resctrl/mpam_resctrl.c=0A=
> @@ -561,6 +561,38 @@ void resctrl_arch_reset_cntr(struct rdt_resource *r,=
 struct rdt_mon_domain *d,=0A=
>          reset_mon_cdp_safe(mon, mon_comp, USE_PRE_ALLOCATED, closid, rmi=
d);=0A=
>  }=0A=
>  =0A=
> +/*=0A=
> + * The rmid realloc threshold should be for the smallest cache exposed t=
o=0A=
> + * resctrl.=0A=
> + */=0A=
> +static int update_rmid_limits(struct mpam_class *class)=0A=
> +{=0A=
> +       u32 num_unique_pmg =3D resctrl_arch_system_num_rmid_idx();=0A=
> +       struct mpam_props *cprops =3D &class->props;=0A=
> +       struct cacheinfo *ci;=0A=
> +=0A=
> +       lockdep_assert_cpus_held();=0A=
> +=0A=
> +       /* Assume cache levels are the same size for all CPUs... */=0A=
> +       ci =3D get_cpu_cacheinfo_level(smp_processor_id(), class->level);=
=0A=
> +       if (!ci || ci->size =3D=3D 0) {=0A=
> +               pr_debug("Could not read cache size for class %u\n",=0A=
> +                        class->level);=0A=
> +               return -EINVAL;=0A=
> +       }=0A=
> +=0A=
> +       if (!mpam_has_feature(mpam_feat_msmon_csu, cprops))=0A=
> +               return 0;=0A=
=0A=
Shouldn't it be return -EOPNOTSUPP;?=0A=
=0A=
However, before the function update_rmid_limits() is called, there is a che=
ck: if (cache_has_usable_csu(class) && topology_matches_l3(class)).=0A=
cache_has_usable_csu(class) already contains an identical check. Therefore,=
 I think it's safe to remove this redundant one.=0A=
=0A=
Best regards,=0A=
Shaopeng TAN=0A=
=0A=
> +       if (!resctrl_rmid_realloc_limit ||=0A=
> +           ci->size < resctrl_rmid_realloc_limit) {=0A=
> +               resctrl_rmid_realloc_limit =3D ci->size;=0A=
> +               resctrl_rmid_realloc_threshold =3D ci->size / num_unique_=
pmg;=0A=
> +       }=0A=
> +=0A=
> +       return 0;=0A=
> +}=0A=
> +=0A=
>  static bool cache_has_usable_cpor(struct mpam_class *class)=0A=
>  {=0A=
>          struct mpam_props *cprops =3D &class->props;=0A=
> @@ -1006,6 +1038,9 @@ static void mpam_resctrl_pick_counters(void)=0A=
>                          /* CSU counters only make sense on a cache. */=
=0A=
>                          switch (class->type) {=0A=
>                          case MPAM_CLASS_CACHE:=0A=
> +                               if (update_rmid_limits(class))=0A=
> +                                       continue;=0A=
> +=0A=
>                                  counter_update_class(QOS_L3_OCCUP_EVENT_=
ID, class);=0A=
>                                  break;=0A=
>                          default:=0A=
> --=0A=
> 2.43.0=0A=
