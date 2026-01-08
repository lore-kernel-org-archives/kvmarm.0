Received: from TY3P286CU002.outbound.protection.outlook.com (mail-japaneastazon11010067.outbound.protection.outlook.com [52.101.229.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 091ED3FB6B7
	for <kvmarm@lists.linux.dev>; Thu,  8 Jan 2026 10:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.229.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767867539; cv=fail; b=MmDb/rJI4IMEiMLrJqhVnHlpCHaBIbfLN+y7MrOmprWoLEgLX/mNEX4Mn9HXP6S2npzQalgBOrQo71/TmGDSvB+AZboF+NOKiiAU03c8wqVxIq6FhMbAvvAr4UGbyylu0I32UgwHXKTM2XPmIOWGBjHMx2SUJ7JgS7aDGHHzcwI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767867539; c=relaxed/simple;
	bh=8X116aOEAcxnyac3oAWN3SG8YezPuhRNKZbRi25OI8c=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=abbEgTPIa1Cj6J0q80v3tG5nw9AGEkZ/v4w+H+/bRCSCuxV8OOeaP5hfrWuIhT4P5ou3VieHucF2krJpbq7TXrXtW1P7pucHMFZ7mmflxNxNFPa2cSstJfHYbSZZmtqDjqpjTF4psrsJJhYlDDvJsqpuq9SAXiHpSu1t3FSKk8U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=p1yKuZ4U; arc=fail smtp.client-ip=52.101.229.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="p1yKuZ4U"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gk8AAHEm1Iq0F5QQRnLXPy5UEWmbUOlr4L8q0MCDsETqwJZwfPFcEwm7bfwBIbDtGyPn/PxEX6AXHcOSlPoWJ1ps+4eu9ehaGhKCu6GJS+/7AzPRBBRXJ0coUhPhPNCWoxFbBpYoDEYNJhCqb7XWOEYggZk3mmr9W9/sHhnUXzNhzjRpX+A56sI7Nur/LsQIF2lohAcfJTLKcFR+4lykt6SHsieDbuic8HuyW5NTfBkj0ClYicLBLdBRNEusjJVrITVSiYUBUds5W5Qi92/vzZ1caXFX4ekIyM32KfbJO+xWROL645F6ZZoQoNRpH4/PYvwP5d7HuQ03mTuu4v6CkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0htHolU17FZeM7DJLwKbOxnLsMNhmwy5/iRaPBKcrCU=;
 b=xGI4d9rfkP6yD5LIPLNJXNMO5QAvFBq8Xe1iOr1FtXG1CrCiXVWU/dxFUrrwU6Ffjt9LbZJ/HXg0uLX+QQQ99iSDlpzTuatRyjZJwp7uHxVMCZ+1iZHYXFXOIa3DSeShL6+rpG1RX8UknPAqawhglDUJYu4md9YCO4whsbgnn0EqSkZutuK1IqOq9L1oYLgXWuXJhThWIeyRVApECFT6yWQPonmgGuRQk8oGt9tYTk/RqPDYurWtkwfWkPK+3qUnVoHFX+fqE8QED4OXYLDq25Hcski3j7v51VJm2IL26EtcDn+FU6eVFviUqea19b1t1m2X4MbZPAHe+A/LjDATiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fujitsu.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0htHolU17FZeM7DJLwKbOxnLsMNhmwy5/iRaPBKcrCU=;
 b=p1yKuZ4UQINzDRCliS0DiwSxD1ez01FXQLoYOGYtcCh7lp02zJL0Z+DhderwR1AxwVJJmFi3u23NDDuliTliEWqOu2IUDeaWggzuwEn0MFVVG2kuh6kBdRdWdSuHXnQ55z1eVLsJ3Bvn4aIa9utv0vqlMbqeteKRUzsTcwPmHUDW1nwy6g/SWfiW1Hdo3cT/aIbgtWupXvTn7YgrhwB/bpCFmjTFflrRrSxx0a1aLfm8qMVRJWf4HNGPQd/gIpaqy5GERNoKUme0JEnoFzXsGJTD3wO3oz9DVfmol4nK7JOyl3hLSSuWcz6o54x56LM1PTBgiVmijbTkSFRZm2TNWA==
Received: from OSZPR01MB8798.jpnprd01.prod.outlook.com (2603:1096:604:15f::6)
 by TYCPR01MB7872.jpnprd01.prod.outlook.com (2603:1096:400:185::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.1; Thu, 8 Jan
 2026 10:18:49 +0000
Received: from OSZPR01MB8798.jpnprd01.prod.outlook.com
 ([fe80::e366:d390:4474:8cfa]) by OSZPR01MB8798.jpnprd01.prod.outlook.com
 ([fe80::e366:d390:4474:8cfa%6]) with mapi id 15.20.9520.001; Thu, 8 Jan 2026
 10:18:49 +0000
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
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, "dave.martin@arm.com"
	<dave.martin@arm.com>
Subject: Re: [PATCH v2 12/45] arm64: mpam: Add helpers to change a task or
 cpu's MPAM PARTID/PMG values
Thread-Topic: [PATCH v2 12/45] arm64: mpam: Add helpers to change a task or
 cpu's MPAM PARTID/PMG values
Thread-Index: AQHccRMeLWg+7B4NFEmaFt9COZeLz7VILh5t
Date: Thu, 8 Jan 2026 10:18:49 +0000
Message-ID:
 <OSZPR01MB87982085E0E5B09D0FBB58208B85A@OSZPR01MB8798.jpnprd01.prod.outlook.com>
References: <20251219181147.3404071-1-ben.horgan@arm.com>
 <20251219181147.3404071-13-ben.horgan@arm.com>
In-Reply-To: <20251219181147.3404071-13-ben.horgan@arm.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Enabled=True;MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_SiteId=a19f121d-81e1-4858-a9d8-736e267fd4c7;MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_SetDate=2026-01-08T10:18:49.251Z;MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Name=FUJITSU-RESTRICTED;MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_ContentBits=1;MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Method=Standard;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: OSZPR01MB8798:EE_|TYCPR01MB7872:EE_
x-ms-office365-filtering-correlation-id: a00eaaf1-9008-4e02-ede9-08de4e9f50e0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|7416014|376014|1800799024|1580799027|38070700021;
x-microsoft-antispam-message-info:
 =?iso-2022-jp?B?L3FUbzBMQ0thcjAxZW9VK0c3Z0J5ZjNUL0xoMmhrSmt3UDh2QTdmLzA3?=
 =?iso-2022-jp?B?Zm5hM3VZWFlOeEdFeDM3cHJlNk9ZR1cycFphb0J3Zk15dU5vemQ4ZkFR?=
 =?iso-2022-jp?B?UUs0cVNhbzdkTTR1SFA4eDA3UVRPVFZERmxSTXVSa0pJdjRuay82ZzBz?=
 =?iso-2022-jp?B?MVRRRm5QbnRHbG91Y3dJeVpoNmZQTnczRlZmc3IvQVFCMFVveUNKVXhS?=
 =?iso-2022-jp?B?NURlTzh0UGt1bThwTWs2WUdWSHdTYTZPODhjQkJRRE9Ic1E0anpSQ29t?=
 =?iso-2022-jp?B?VGZNbFRnNERKcmZwc0JkeTF2UTByVUgva0tMakZJdFdFUFRjOEVYY0tu?=
 =?iso-2022-jp?B?Sy9SNTllUlJpMlk5bGhRZ2JuS042c3pEN00ydjNsWDZtZlNYZjN2M0J4?=
 =?iso-2022-jp?B?bU5PenNCckxEeEE3d00zSk1wVHJWK05RUG5BTXp3eFV6TmFPNXdiQ0FN?=
 =?iso-2022-jp?B?THdzeUh6UnhQWXFTOThueHdHeEkrOWFTckhkTEpmYUo0dG16d1E4elhI?=
 =?iso-2022-jp?B?bjdpRWVyY2FWN2xwRnUyRmhhd2dQN2ZjOGxoZVlKUzRHbFFhVzAyYmdo?=
 =?iso-2022-jp?B?Z3hQektsTnlucjhVOUN2SXB1cEl1d0lmcnpsZXlJdDF1TjNzRVZrVmR1?=
 =?iso-2022-jp?B?U1VmcFBSMlJUb1pCci9BbW1hVVROVlRCejFJWDNEK3ZHRGNsTHRwUVk4?=
 =?iso-2022-jp?B?TU5MZSsxMlp0YWVNNlE0THM0RXZMSDNWWEhnN3drK1VZM2JnZWhDdEpK?=
 =?iso-2022-jp?B?a09tQWNNdk1mTGFLYVluWjVNa3JEdVg0RTlTcjd3ZE92SG9wYjU2Nnl1?=
 =?iso-2022-jp?B?SDFBZHh0OEZYWlI3YUdHYTNSSEZ5bjAwZ3ppMHpnOU9nNnh5T3l3Sk1H?=
 =?iso-2022-jp?B?UWRDM0E0ZUtCNFV5STdnLzJWMjVBTkNlV2FmcTBkZWVtdFIzeEZCMlhV?=
 =?iso-2022-jp?B?YjVtMVVPN2VxaHEwa2RpaWNnUm5uSC85dENMZzNPbHYyZVZlVXd3ODNm?=
 =?iso-2022-jp?B?eHJxWkFUeWxLVzMyMkFkWjdCMytyWHU3aUNYTkkveEhMeTQra3hLTnR6?=
 =?iso-2022-jp?B?YndnV1NlYlJXRHd1UUIrQWY5VE1qcHdBbURjT2MrOFZia1VlUlpKeWYy?=
 =?iso-2022-jp?B?SXhZZ1BDV3A5TElQeG8rT1Q2V2xVOWtQa0xaR2ZRL3JMT0lPQklOb0xT?=
 =?iso-2022-jp?B?TCtsdisrSDltRW1IYUl4YUdEdHZVRTBFZjZDL0s4ZlVWWlkzcjF2M3p1?=
 =?iso-2022-jp?B?MEhXSmN2NGRDNU16UkZ3dWtncXVrWE9PdEc2YlNwczdNYXlGMmNVd1Ns?=
 =?iso-2022-jp?B?NFVEaVZsYURxcm1RSXVVa3BTSGZYM3hkKzRFL0R2M1dVSU9SdEt4SVJN?=
 =?iso-2022-jp?B?cVpaaGZMNGoxRVZiakczb2NkbmdTVW5lNFV1cUU2anJWUFlGS3FBK3dt?=
 =?iso-2022-jp?B?d3RHY3FsSW45MVNvTXhhL0xMZE5aaW5heUJwMWpNVjhkOEJ2d0htdlpM?=
 =?iso-2022-jp?B?V05Cc0JCQ05SZDE1V2ZlRWRsRDZKeUpWVzNLbENlKy92MjMrdFpZYjJE?=
 =?iso-2022-jp?B?WUlNRlc5NlAxakpVWmNSNEZBeENTVmJxOE12SmkvTDEyN1BQcE8yajVl?=
 =?iso-2022-jp?B?VmJycGVVZ0s3RGUvSHJ0TktoeENBYlRQNlAvNzc2TGFyZ3N4MnJVbURT?=
 =?iso-2022-jp?B?WjQrYm1DaGVIaThyeG4xRTV5MzFXdTNQVThZY2tMSnVPTURiYUUwTDha?=
 =?iso-2022-jp?B?b2tMM2Y2YllNd3FoczdpWGhDWjBEKzB6YnlPYnVVS281eUozRm5qdHMy?=
 =?iso-2022-jp?B?RGFrbkNXU1ZNNmJ0cnBEVW5handZVllSUjNka1plQWJ6R2JjUWlncGZG?=
 =?iso-2022-jp?B?Zy96eHUzYUVLQ2ZSWFgwU21HRGVWTWx5c2tJU1ExMTBMZGJsU25ndGUz?=
 =?iso-2022-jp?B?VW9kQ2tLY3B4WkJMdkJUTWUvMVRaRlVMUFJOeXBCTWNqRE5hRUljNncv?=
 =?iso-2022-jp?B?QkhXTzRxNE9UOGRTaFVIb21UTkkzMzc1YWlhQnlYaVVrVUxZMWxyRHZj?=
 =?iso-2022-jp?B?VUduZHF3RzhtSFpGckRxNzhSSno2amJsTmN6Y2cwVnFzOU1jYU0wMDdk?=
 =?iso-2022-jp?B?NGNBWjNiNnQxcjZ2WnprZUxtSWx3YlRzbExtQUFSbXdsNjBCQ0pFd2c3?=
 =?iso-2022-jp?B?WnA0Wms3ZWFrQk0wYWtneE5FaW1lTUxUQWpjZDZaenY3ZHNvTzRDdi80?=
 =?iso-2022-jp?B?Q3pidz09?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:ja;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OSZPR01MB8798.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(1580799027)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-2022-jp?B?VzRPKzUrajYxR0kwODEyREtDdWlVZk9MT3lDRGgzZlJSVkRXNEwxTCti?=
 =?iso-2022-jp?B?Si9EbUJ0bTIwZXd5RXk3Z1pEZGc0TFdVUnRiKzFmekpPNU5SU0ZXWTht?=
 =?iso-2022-jp?B?RFp2eFZhc2M0azFhOVd2NVFLNHN1Rkk4Z0ROWEIya0FOVmxSTlE2Y0Y0?=
 =?iso-2022-jp?B?anJEVUNsdnZRYnhQN08wMkc4ekMzcFdUUmZaSlBXVWZXd1Vaa0dPQjJm?=
 =?iso-2022-jp?B?QndNYWQydTBOeGVOQiswUkFJdVcwSUdzaHpKUkRtM3FjbG9wcXdtdlNr?=
 =?iso-2022-jp?B?T3NrYXFaSS9LZzBTWFBaT3VxRE1SS0JJd05SR2l2b0pRa1ViRFc1VW5N?=
 =?iso-2022-jp?B?M1JobStVakdsRG1MejRtZUI2NSsyZXh1UTJWbUVia0NYSktPM0Z2bXhq?=
 =?iso-2022-jp?B?bkRwcHlnTWtpRlZFNFZOWExSK0RFUXQxVHVnVTVzKzlPZG9zQVFnRjVC?=
 =?iso-2022-jp?B?OUZnNnA1NkJmdzVyT2hHSVVtNDI5K2RSSlY1ZWw0WExwa1FWRUdIQ1FW?=
 =?iso-2022-jp?B?b2wvNEswNDdteW1rWnRiZStNRitjTVIvekpxTGQvU09DVmE3eFVWdDJq?=
 =?iso-2022-jp?B?a1l3U1F0eitNeFRsOW55ai9oM0F4Y0JGdDVVcEFZK3J5VmQ0ZkFBdWNn?=
 =?iso-2022-jp?B?ZEFCeDNXbXk0am1kUmEyUE1jM1dSQkZwcVpRUVQyOE5pS3dZSHdaVEtC?=
 =?iso-2022-jp?B?ZG56ZGhOQW9OMjhtT09Udkx6RHFkYlkxNmJmMGNwN1ZhOFpDUHJxS3ZH?=
 =?iso-2022-jp?B?SGgvNVMxTVlUQW5OS3FINEg5aGRVZER0dWRVVkM4Q01USkovUzcvWjls?=
 =?iso-2022-jp?B?QnJtVkF1UGp4ZTd2SjBTN2J1TWhIQ2VFK1hiVmdGUFJwRU1FK2VtYUdD?=
 =?iso-2022-jp?B?Y1NQc3F3V0ljSmNxQlVjNnQ1VC9NNkZsOHhYTUpyalhWUG94cFdlT3d5?=
 =?iso-2022-jp?B?UkdaWkt0a2FpSUU2WFdtWlVSS0x5VEZrbFd5bEh6R2JVUlh0MWJvVDBq?=
 =?iso-2022-jp?B?VnJwVFN5WXVTTjNkL1MyWUtycDRTQTREMFlMcjRrR0RmYjBIMXVXSVdM?=
 =?iso-2022-jp?B?OTZianFxNnhzRDcvWVIyZDNkeWQ5RVMzc2hKRWxIOGV4bTlKQ01QdFd3?=
 =?iso-2022-jp?B?SDNITUtCMEx6NlhFaG9KcW84SElra2JCN0I5clptdU5QQ3JDQ3NtNE9L?=
 =?iso-2022-jp?B?a3QvRnBjeURodzJUblMxVDNuc1ZGb1BHZkdXaVY0Y2grTDFSaEFOVWVa?=
 =?iso-2022-jp?B?TldkSkFROTZNMU8rQXVqb1pSVW1MZng5S0hsNWxiOE9WMlI5UWxhc01h?=
 =?iso-2022-jp?B?aWd5dk1lRmNkMG5MbG5HUVgvWkQ2dGgvUGtsZjdUZ3g1MTVyR2xYM3hE?=
 =?iso-2022-jp?B?ODBhdFp2NlBRMThmcmhJU3BzRWxNTXZUdnAyOHFWMjBITkdVM25Yc3Bk?=
 =?iso-2022-jp?B?NW5tQllXSWFRcHh3c1dpUWxGbzFyZkpidFNpN2hIZ21VMDFIUzZzTkRP?=
 =?iso-2022-jp?B?UTN0SGt3VUVWUEdmVzFPUGtycnlUeG1zd1FjWUp1aFRrdzZrVkNRcDZM?=
 =?iso-2022-jp?B?SjFVSlZJOS9iSXdKT051UFFtVUJQd2tDUEtoRjZadGFmemhOUy83SjZI?=
 =?iso-2022-jp?B?Y0VhYkNyaERRVGlOLzdQOWpGTlJrU05YMVVMZ1lEcS9PRFlhclVwMTEz?=
 =?iso-2022-jp?B?OXhsK2N6OE9tOVRyTUJCL3ROMzJ4T2RmeG14cm9aQ0NPWW8zb0d5SE5h?=
 =?iso-2022-jp?B?V21wbk45RDltYlQ0N2pvYktNVi9UMkVTODkwRFJTc0MreENpekxVazlm?=
 =?iso-2022-jp?B?MGpNTUFhZUIrMXVaWS9UOXRvSjg0cjU0NzFZK1FHRU9wKzZLcmVxMUxQ?=
 =?iso-2022-jp?B?U3dvaXZkQUhMNTBWRDFvc3VEenBqKzdYS2dDYk1YV215cWpZN0RXOExG?=
 =?iso-2022-jp?B?UW1xMFdNQkZOMnlOY3ZpUzMreTNNUzExbFNCOWk4OWgwNzhrMHVnd1VE?=
 =?iso-2022-jp?B?alRRb1lVaXdERWEzajJ3YTlIeFBoekRjZDhRUmpNODlzUjc4S3hEN1k1?=
 =?iso-2022-jp?B?dlZXQzcvcmhhVUFxV0N0Q25nTzU2K2w2Yjh5cUhGRU9nWk1IVXpRNTBq?=
 =?iso-2022-jp?B?NmVGYnBDdDdDbTMzWUZ5Rnc2cW5yVnRyMThNN1Z6aVI5Ukd3YTUyell6?=
 =?iso-2022-jp?B?dEpZd3J4QlV3a1pBalIzWUpVK3FIbFQ3aXV1aElVRjZ3NC9ZRHhKTXVE?=
 =?iso-2022-jp?B?Y1pIQ0s4TjFUbzc0SkRZWVlLSkxVL0l0Sk5zYTZ6VFNPdFF0dzZLUzlV?=
 =?iso-2022-jp?B?TjVPQm02dXdCczZqMnpLdTMrOSsydXF5TWpxN2RzYUR0bVk5Qnplam51?=
 =?iso-2022-jp?B?QWllL0hxMW5aVFg3RmJyaGhJZW9FTDZFeEdQZGthbjA5OVd4MWhkZDBx?=
 =?iso-2022-jp?B?dHJ6RFdLNTM1R3l3M2tnSVlCemRvWW5uY2JISWhhSmhNajA0N1JqSm9Z?=
 =?iso-2022-jp?B?WVpnTW5XdTBOSU5DczZmejR0bENJbFhCZGNVZz09?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: a00eaaf1-9008-4e02-ede9-08de4e9f50e0
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jan 2026 10:18:49.6635
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9Yln+Q9OEt36yIPwtHTNe39UZROSf7eGAjYypKldo5ndUxXqnM8vCmn026A9gnSWsbYEBLdL+w3wNNO+J84KXtbwzmZuV/pn7D0KS6Q673c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYCPR01MB7872

Hello  Ben,=0A=
=0A=
> From: James Morse <james.morse@arm.com>=0A=
> =0A=
> Care must be taken when modifying the PARTID and PMG of a task in any=0A=
> per-task structure as writing these values may race with the task being=
=0A=
> scheduled in, and reading the modified values.=0A=
> =0A=
> Add helpers to set the task properties, and the CPU default value.  These=
=0A=
> use WRITE_ONCE() that pairs with the READ_ONCE() in mpam_get_regval() to=
=0A=
> avoid causing torn values.=0A=
> =0A=
> CC: Dave Martin <Dave.Martin@arm.com>=0A=
> Signed-off-by: James Morse <james.morse@arm.com>=0A=
> Signed-off-by: Ben Horgan <ben.horgan@arm.com>=0A=
> ---=0A=
> Changes since rfc:=0A=
> Keep comment attached to mpam_get_regval()=0A=
> Add internal helper, __mpam_regval() (Jonathan)=0A=
> ---=0A=
>  arch/arm64/include/asm/mpam.h | 28 ++++++++++++++++++++++++++++=0A=
>  1 file changed, 28 insertions(+)=0A=
> =0A=
> diff --git a/arch/arm64/include/asm/mpam.h b/arch/arm64/include/asm/mpam.=
h=0A=
> index c4cb015e8d8f..a7fd0656bf90 100644=0A=
> --- a/arch/arm64/include/asm/mpam.h=0A=
> +++ b/arch/arm64/include/asm/mpam.h=0A=
> @@ -4,6 +4,7 @@=0A=
>  #ifndef __ASM__MPAM_H=0A=
>  #define __ASM__MPAM_H=0A=
>  =0A=
> +#include <linux/bitfield.h>=0A=
>  #include <linux/jump_label.h>=0A=
>  #include <linux/percpu.h>=0A=
>  #include <linux/sched.h>=0A=
> @@ -22,6 +23,22 @@ DECLARE_PER_CPU(u64, arm64_mpam_current);=0A=
>   */=0A=
>  extern u64 arm64_mpam_global_default;=0A=
>  =0A=
> +static inline u64 __mpam_regval(u16 partid_d, u16 partid_i, u8 pmg_d, u8=
 pmg_i)=0A=
> +{=0A=
> +       return FIELD_PREP(MPAM0_EL1_PARTID_D, partid_d) |=0A=
> +               FIELD_PREP(MPAM0_EL1_PARTID_I, partid_i) |=0A=
> +               FIELD_PREP(MPAM0_EL1_PMG_D, pmg_d) |=0A=
> +               FIELD_PREP(MPAM0_EL1_PMG_I, pmg_i);=0A=
> +}=0A=
> +=0A=
> +static inline void mpam_set_cpu_defaults(int cpu, u16 partid_d, u16 part=
id_i,=0A=
> +                                        u8 pmg_d, u8 pmg_i)=0A=
> +{=0A=
> +       u64 default_val =3D __mpam_regval(partid_d, partid_i, pmg_d, pmg_=
i);=0A=
> +=0A=
> +       WRITE_ONCE(per_cpu(arm64_mpam_default, cpu), default_val);=0A=
> +}=0A=
> +=0A=
>  /*=0A=
>   * The resctrl filesystem writes to the partid/pmg values for threads an=
d CPUs,=0A=
>   * which may race with reads in mpam_thread_switch(). Ensure only one of=
 the old=0A=
> @@ -45,6 +62,17 @@ static inline u64 mpam_get_regval(struct task_struct *=
tsk)=0A=
>  #endif=0A=
>  }=0A=
>  =0A=
> +static inline void mpam_set_task_partid_pmg(struct task_struct *tsk,=0A=
> +                                           u16 partid_d, u16 partid_i,=
=0A=
> +                                           u8 pmg_d, u8 pmg_i)=0A=
> +{=0A=
> +#ifdef CONFIG_ARM64_MPAM=0A=
=0A=
Since `mpam_set_task_partid_pmg()` is only called from MPAM, is this necess=
ary?=0A=
=0A=
Best regards,=0A=
Shaopeng TAN=0A=
=0A=
> +       u64 regval =3D __mpam_regval(partid_d, partid_i, pmg_d, pmg_i);=
=0A=
> +=0A=
> +       WRITE_ONCE(task_thread_info(tsk)->mpam_partid_pmg, regval);=0A=
> +#endif=0A=
> +}=0A=
> +=0A=
>  static inline void mpam_thread_switch(struct task_struct *tsk)=0A=
>  {=0A=
>          u64 oldregval;=0A=
> --=0A=
> 2.43.0=0A=
