Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2136.outbound.protection.outlook.com [40.107.244.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7384B1FBEB3
	for <kvmarm@lists.linux.dev>; Fri, 13 Jun 2025 03:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.136
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749784802; cv=fail; b=sh6zQYu3eiTxseK0iF6ZV599Wc4OfW7aKjY9dvfKxWjpeoIg8iDbIfP3hcIcaP0eDliT3icy3B3DVMhafraX3JvQIKNGruUtqE0N+10p9pe38IAvkqm+VhIf8kXd6yGfyREx+zn+u+/EelzuOPwvtYD9ApOOC6qUPef2vdCnkQs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749784802; c=relaxed/simple;
	bh=vmXoHdXtmHNVPFu22TM2d6R+5mgIsajK/HLvl0Ve8YY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=RJO0nDPWKUFQdhSXjXA8HcQi4ZSEGdnAY03fwJiAxqkklfszbPoLTg6FntHY7GEu+nes0yHlnRB6h1P20vGU6biSiwVCgNENHxe3NjYUlo/Q4PABsbrjGGXjV8UP2OCZRJol1MbZdFQyquxLcJNkeR9QU3Yg9sAz+OOFsOJJASw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amperemail.onmicrosoft.com; spf=pass smtp.mailfrom=os.amperecomputing.com; dkim=fail (0-bit key) header.d=amperemail.onmicrosoft.com header.i=@amperemail.onmicrosoft.com header.b=APHvZb65 reason="key not found in DNS"; arc=fail smtp.client-ip=40.107.244.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amperemail.onmicrosoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=amperemail.onmicrosoft.com header.i=@amperemail.onmicrosoft.com header.b="APHvZb65"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GZskjBKXuKP0ebYTG1hVRHHRehgak9FQHsNXpbN26cdyDsePnJkouqI3dua7O9ja16w2eGfy/Bf7cIu29BDxncz3C7SjlX//bGfnu8LUo/ra4L4mnGdN42fTna8xkn+NhCxUzXE1UYWljmT6pBVE5/r8nFynsRT3/nQZmHxt+R+r/48+YlNRJQ2PCtnOTsmNibKbdoxJ14YqHrpah4PihXlVw3519qEnXSaSk1aAB5yqjGlgMDpRqC0cShcVRYhVjdrUF3d2M2NtfpAXKfqx2mRv0Jg/oF9FuxD/QLub9vmic9WUDeXoz2v3eNhFu5hTymG3W8N5xE+FgL1+TFp+ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H/M+yOxrEQk/d29SQBLJSftNX73VYr1WMpMuGoyDcx8=;
 b=zEdLUreAgKw8kwcZkpDNdIjUR/CD+tBdVFUjKHbtjHPSte5JjCchbVmZZnNeh2zdvchQXwKbFNxF46MYl9kv4MGnrR9HhDyk0Y/h+pc4suD2PIHmBo3m4UJJuLwrB9wagE/CycME9h3vgMVS6xExReGjUgEN22e7az1/miFExBJuZvQtj7hCUpLpW3j+9+oDkq4bA+y5OrlHpc97zii/nKXEdqnEF3crqETQjP8p9WoR9LF/NRMuTdE7JENKz98xFBOsY7atk4keBy2wXv+qqeHvgFEYKFvIxL1SSptAq04A0uGuN9dxKk74ifMKKe1ADhCLdDU5yrjx2IWGyjFoSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=amperemail.onmicrosoft.com; dkim=pass
 header.d=amperemail.onmicrosoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amperemail.onmicrosoft.com; s=selector1-amperemail-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H/M+yOxrEQk/d29SQBLJSftNX73VYr1WMpMuGoyDcx8=;
 b=APHvZb65y47gyYR7PXoBgs2NezlcQNwilRlVA+WD+q4TC2/YE9oTySiw6uK/dZBkgERkMAXqD7XNgRONrrOg0pAX+iuP8UfgLl1loCRWrEutQME953idriisqrZL2CvuEOy6d23bDsOpY090ryO07i4VHjc4p6w01mcK9sLEFR0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amperemail.onmicrosoft.com;
Received: from BN3PR01MB9212.prod.exchangelabs.com (2603:10b6:408:2cb::8) by
 SA1PR01MB8564.prod.exchangelabs.com (2603:10b6:806:37b::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8835.18; Fri, 13 Jun 2025 03:19:56 +0000
Received: from BN3PR01MB9212.prod.exchangelabs.com
 ([fe80::3513:ad6e:208c:5dbd]) by BN3PR01MB9212.prod.exchangelabs.com
 ([fe80::3513:ad6e:208c:5dbd%3]) with mapi id 15.20.8835.018; Fri, 13 Jun 2025
 03:19:56 +0000
Message-ID: <e513b32f-78fb-46d2-90e1-e7868bffa368@amperemail.onmicrosoft.com>
Date: Thu, 12 Jun 2025 23:19:54 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v23 4/4] perf: arm_pmuv3: Add support for the Branch
 Record Buffer Extension (BRBE)
To: "Rob Herring (Arm)" <robh@kernel.org>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Jonathan Corbet <corbet@lwn.net>,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
 Zenghui Yu <yuzenghui@huawei.com>, James Clark <james.clark@linaro.org>,
 Anshuman Khandual <anshuman.khandual@arm.com>, Leo Yan <leo.yan@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-perf-users@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 kvmarm@lists.linux.dev
References: <20250611-arm-brbe-v19-v23-0-e7775563036e@kernel.org>
 <20250611-arm-brbe-v19-v23-4-e7775563036e@kernel.org>
Content-Language: en-US
From: Adam Young <admiyo@amperemail.onmicrosoft.com>
In-Reply-To: <20250611-arm-brbe-v19-v23-4-e7775563036e@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BL1PR13CA0207.namprd13.prod.outlook.com
 (2603:10b6:208:2be::32) To BN3PR01MB9212.prod.exchangelabs.com
 (2603:10b6:408:2cb::8)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PR01MB9212:EE_|SA1PR01MB8564:EE_
X-MS-Office365-Filtering-Correlation-Id: 0b142539-9929-4cfb-86e8-08ddaa292bb7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|10070799003|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?R0FsZ2xOYm9DME9SNWpPQ3BkOGtoZ2ZtL2NEbEs0NjZaTWlSZnBnNklYTzNm?=
 =?utf-8?B?YVdlNms4VjVRNWl2Vmx0Wk8rR1NRcDVlMklOMjJROWRwMS9Mejh6N3NvNmZw?=
 =?utf-8?B?M09hWGRqZXFuTlBzaC9pZGZqTG9LaW5pUG9JS1RIZk1TdnFtdjlQSEVKRkhU?=
 =?utf-8?B?SjVGam5NcTBycWlwd1RTcTB1RGU2YTl0Z3AvWUVQSzlDNktMR1VLVkNidjRY?=
 =?utf-8?B?bGlocE1JM0RmQzN0UXV0bGtxd0hjOG5icnF3MFA0MHg2RWZteU1kRFR4NUZz?=
 =?utf-8?B?RkhTNk1ZUkliV2JSeDgxRkxmeURWS0pLT3R3VkZPeGVZdlRtcm1oQXI3Nk4z?=
 =?utf-8?B?UXVXUnFzMUdZMjZYRktiUU5sNWdpcUU1ZFArdjIvNkRobkNKaUxNQzdDa3Z5?=
 =?utf-8?B?WjIxYk9rcDRpdGdlc0hUOStiVU9HaXc4bGhrZTNrc21ZVi9uQlBDZXMvMzhy?=
 =?utf-8?B?RkE3ZStYR3ZRNXlTT21PKzVmc01RTEhRQ1V4bzlnVlR2bW8yVnhTNnFBYklV?=
 =?utf-8?B?Y3ZhN0YvdTdrZG4ybXhaczdrRHBPUi9tMXhFQXE4TUhxVlNUTmorVi81U0Rt?=
 =?utf-8?B?ZWRLem9iQ2lHcDFLWGwzMEUzc0dmQnFsU0VrR2xCQ1JqWnVhSUx1RmNUK3pp?=
 =?utf-8?B?eEFzYzVrUFhualFRMldCZzFGVnduZ05QZHhGYUsxTDBzY0MzaXhYUEZXVVhW?=
 =?utf-8?B?SHB6VGtiMldjeFFUd05JdmxXMmpreXdhY09pN0ZWdEJVeWJsbjlWaUxNbktp?=
 =?utf-8?B?eDI4OWMzaHFWQ3lNSXVaKzZ6ZWVLNkZUaGE1ZmFndkRJRERkMWg4SmhpM0VR?=
 =?utf-8?B?SWpTZXFLcmxkMTZ5SnVpdTNKV2xZZUJGV0YrU2Rua2E4Qng3Wk1LMEUxb2Jp?=
 =?utf-8?B?YUNhVDVRVzM1UitxTmtQZS92ZzcwRDdXZnJhSnNpQVpBT1lGN1dNQWY3eE85?=
 =?utf-8?B?M1hxL3ZyNUxuL2xrL2MzL2NKTEJZck5GVUlweUVoSXNna3g0bFI1cDJFbXND?=
 =?utf-8?B?OVJRdTlxS0RrWkJ5K1FUNDYvemRLKzFwOUxOZnBBTFFIWk1yRk5JejA5U0J3?=
 =?utf-8?B?WGpIbDM5aCtaNVFwWlQyckh1Z2w0TWdQYS90VC84bjRPWk9Jbm1nM2RXajZj?=
 =?utf-8?B?M1FRS3BLbzVnMGpQekF5M2EreXZNN2tLSmhTaDR6d2FyMmlkMzBMZFlxR0g5?=
 =?utf-8?B?bGM2RHpnQmlhM1hjcXRBb0YvWGtMOC9WR2RtWVM2T3Vyei8wbzV4VVd4NXBY?=
 =?utf-8?B?TG1ZS3puL2hRZC8weE9VMDJGRGRjSExYcjNYMktrRGxhU3lqNFdaL2UwYWpk?=
 =?utf-8?B?elVFclNHUHdhakNrNXh4Zjc0Y296QmphclFRQlcwTnBaZVdLdDBaS3RnR3p3?=
 =?utf-8?B?dWtNZjNSOGJ5T0ZzREFPRzJnclRRRWhUK2IxVGl0OTZabjFzdXZ0RXlWRTlO?=
 =?utf-8?B?ZXhQUEg4WDFZd2lGUzFadkZFRVdkemZ1ZjlxV042SXNNdWgrMWhtNFVoOHhW?=
 =?utf-8?B?N21hZ1pKV3FhZWlpM0ZRcWV5TExwVUNzYU9xNWhCQnlvTjJKelprYmVaVDRE?=
 =?utf-8?B?bFdxVTNjSnR6YzVJeDVNaXM0eEZPaEt6aVhnZ2Qvc20ralRwQjFuK1V3b2Yy?=
 =?utf-8?B?bzJoNXlFVzlwZU4xMG9vajNxcTIwM29TYnJuMkJobCtrSWNKZUcwMVNLVHRv?=
 =?utf-8?B?SHBpY0x4RTF6Slc0MHp2b0gwcnVkOUlRZExXVWo3MUNPVG1nVUdSMWdKczJD?=
 =?utf-8?B?Vjd5N2ZaWks0MkxtZU5IMHZzUnJjbTlHTW02dndweUhFM3doWThNVVFMTkRP?=
 =?utf-8?B?cWtFL1g2Ukh0VEIxdWpRU0lpTGN5ZnZ4ellkK0tFZ3FiZ3k0QjY1Rk45Z2Ew?=
 =?utf-8?B?NnhBQ0FYaXU4ZTQrTCtJWTJLblI3dVlvR050cnVSK2Y5NjJkV2MyL25XbnNi?=
 =?utf-8?B?c3pNQWJuWXlia2lqcUEwK0VLZjdoQ2ZUYlhJeHo0Y3MvREZNRHFLS2txVU5Z?=
 =?utf-8?B?bUNxSTFrcWl3PT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN3PR01MB9212.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(10070799003)(921020);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?U0QwNjhVc2RSaFAycWpKKzVJRE4wKzZJUkI5Vm1jRDkvYXo4UVQvU1EzeHBR?=
 =?utf-8?B?TTFnT1lCQ1lCRlljZE9XRDIxOFUwc2ovTHZVMFFBYUpWYkFySGt0ZyszUnRU?=
 =?utf-8?B?TzQyaUZvY0VZRVM5WXNiM3lkK3JjbjJqc0t4dWdTQllpRjhab2FET3NERVBq?=
 =?utf-8?B?SVFZR2JYYjVaNnVRWkIzUUFVZG0xYWhYR2J1R2NmeThoTVRhWHlNSlRBdUM1?=
 =?utf-8?B?NmpIVHI5RjA4bGJJcEVaUk5oT3RHUXhwTVpYMWZrRXJjVXpjYnVYeGNvZHQz?=
 =?utf-8?B?Y3pFTW4wRXJhSDhJM2RvSlFYUDNzUWtlQklxMEZWL3N4YzVPYXdiWEpGWUZ3?=
 =?utf-8?B?SmRoSFNaTEtTTVFPRnVKSmtjOWZ3MmVNcGt1OG1mUXJMaUlUaHRZMUsyUzdk?=
 =?utf-8?B?RDM1eGZTbkxaYmVZa0FPRkx3OW4wRXJOMXRqTExldHFPVGpONm5MMlRSdFdU?=
 =?utf-8?B?SzBOL2RjSmZZblIwcFFYNlNTNWFPM1ovM0tGZlNDbUU1VU42L1pTSVgxL05l?=
 =?utf-8?B?N2U3MzI1TVM1NWtBMkRmNnB4OEQxRUEwa1ZVeldyZFdCS3dzK0ZCOG5tVWFE?=
 =?utf-8?B?UnQwMVlnZFJmWTdmckp0aG9nY1YwMXJnbnFkWkFNbEF5YXFlT2tnZXU3bFBH?=
 =?utf-8?B?YkkyaW9tMmJqMXpxQ2VLRlN1U0FDdm1CM0ZNSTJXYUt5dFBlb1dLTkJMc2Q4?=
 =?utf-8?B?UG5hM3ptTWxwSCtsS1Yxd0VqcEFBYmNZUitnZkpBRXdtdzRCWi90eW5HUVlW?=
 =?utf-8?B?Vk5BeGViSGNna3JBSUpUUnJwbHg0bGZ2V3EycGwwclJybjQvMWswVkl1SjVW?=
 =?utf-8?B?bUJCTlVoMWlqMjJqUUJNVVc3eXY5QmhJL3FNVjVVT0RyOVZjeTJNRnBGYUZR?=
 =?utf-8?B?alJDWUVQdmRUazNNNTF5SUVHVWl3ME40Rk1SU29JMzhUbVF6WEswTWJ6ZURZ?=
 =?utf-8?B?Q25nYU0xS2sveXBzaG1ONXR5OCtRa3Z6QlZXK1FLdTBGWnR4SzVrNk9JNkpF?=
 =?utf-8?B?bGtxQVk5K3d0NnJwVU1QTEIwN3F1cjFGRitCNytVMnRRUW4yRFh4SVRDejFI?=
 =?utf-8?B?SmJpb0cxYkd5VC83cTQzYk5oZmwvRkxaM1RKSjY2bkxGNlQ1L1I5RUZFS3pT?=
 =?utf-8?B?K0tVWXBJYWkwRXFHOGZ6aE5mMStNY0Vjd1V6MG1RL0ZLRXJvYjRZMEN3cHFj?=
 =?utf-8?B?bkFmWlBESEd1Mi9QQ0tDS1ZzUGY3MWdSeWxvN3h3UUc3YmpOWUpzQ0s5NEtm?=
 =?utf-8?B?dUVZbW1yRm5CQzRhT08xcVBUNmJkZ1F0Q2tkTWFjb0IxcXVtcmZBTWhrUnY0?=
 =?utf-8?B?Qnl1Yys0ZUFsSVJmbVNWOCtqa2J3b2wvMUJsck5nS0pFb05RVUdCV0tXN0JP?=
 =?utf-8?B?YmNkMWc0TlJ0NVk5Tmp2RHltVENwaHJqOTMyMHlSRjYrbldUUTdTTDU3SEUy?=
 =?utf-8?B?cVZFVTEwK1pMdG5OK1RDdlNsekRFZlpuNVBUbmxLL1ZGQmZQY2ZwWEdIbmVl?=
 =?utf-8?B?aWhhbFhuV3Rkb3ZBaHo4NStDWS9DRndmeUR6U0pDdVQ0Z2UvUHdjbVdCcnhu?=
 =?utf-8?B?QTFlUG1vR2dpcXh4SkVFNk50L1FIRjJIQ2NBTlk0ZmJScjlIK1NGbzdxZkky?=
 =?utf-8?B?dXN1WVcrZkVKWHZITWF2ZzQzNVdFakN2ckhsakxRaVRET1MwZ0dKdXErODF6?=
 =?utf-8?B?TXorWVVFT0plZmZvT1EvUVlwMzdZcDVmZTF6T2RhTkk4R1dUQkcxRTJYUVh1?=
 =?utf-8?B?QUcrZUVZYVRORVU4SVFMKzNRSkU1eG1WUEZuZ0ZpclJ4eEIvQXdDaVYyWXk1?=
 =?utf-8?B?NnpxNW9aeS9xRVVKSXF0eG1ycHZrczFBOTVEQ1BGbVRlNC83T1oyeHB0MVNB?=
 =?utf-8?B?N3JNdS92QlMzWENPaWFWVTFjZ20xVWdEeHY2WjFldWlrU3kvdDVRejJkNEE4?=
 =?utf-8?B?cDlBeWZyUUVlQ2Jwa3VFdnVHZExKTHRIVDNnZmliZ2hTQStVTlFBeVVoU2tL?=
 =?utf-8?B?eEI2bHhYN1p4TW5hUThkWUVha2tZNmJ0YkpLRHRkZzVEZzZGYUJQVGVhQ0pz?=
 =?utf-8?B?VU9FVGRhMjlSWis0dUVBdm9CVHREMlpvTW9oOGZFOXhxci9nNm4xNktydzAy?=
 =?utf-8?B?eEdVVHV2bEFzeEIrUmxQMXdsZ21WNGJkeGZJZ0FMNzNva2ltb0hWd0tDTFFL?=
 =?utf-8?B?UzNENjF0dVdNOXZycnVGUEkrOU1ZZTVJeTZtQ3BZNkV4ZkhRb3ZPTlFVWDND?=
 =?utf-8?Q?nWZkuwYwK+98eX0Zq25YphjD6+KFKd/gUF9w+bVjTg=3D?=
X-OriginatorOrg: amperemail.onmicrosoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b142539-9929-4cfb-86e8-08ddaa292bb7
X-MS-Exchange-CrossTenant-AuthSource: BN3PR01MB9212.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2025 03:19:56.1830
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lO+x3mczuAi9MzfY5Yjt8v/hAk25TSG+zcnu0XDDmxQqxdDyyz+XjPNGBc+WNa/nO85fTzmwgOJocsM+EIeRGsYyc/4vYFDNViSFo4+3/HdWmDKTZp7fu5tLOgrPR3F3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR01MB8564


On 6/11/25 14:01, Rob Herring (Arm) wrote:
> The ARMv9.2 architecture introduces the optional Branch Record Buffer
> Extension (BRBE), which records information about branches as they are
> executed into set of branch record registers. BRBE is similar to x86's
> Last Branch Record (LBR) and PowerPC's Branch History Rolling Buffer
> (BHRB).
>
> BRBE supports filtering by exception level and can filter just the
> source or target address if excluded to avoid leaking privileged
> addresses. The h/w filter would be sufficient except when there are
> multiple events with disjoint filtering requirements. In this case, BRBE
> is configured with a union of all the events' desired branches, and then
> the recorded branches are filtered based on each event's filter. For
> example, with one event capturing kernel events and another event
> capturing user events, BRBE will be configured to capture both kernel
> and user branches. When handling event overflow, the branch records have
> to be filtered by software to only include kernel or user branch
> addresses for that event. In contrast, x86 simply configures LBR using
> the last installed event which seems broken.
>
> It is possible on x86 to configure branch filter such that no branches
> are ever recorded (e.g. -j save_type). For BRBE, events with a
> configuration that will result in no samples are rejected.
>
> Recording branches in KVM guests is not supported like x86. However,
> perf on x86 allows requesting branch recording in guests. The guest
> events are recorded, but the resulting branches are all from the host.
> For BRBE, events with branch recording and "exclude_host" set are
> rejected. Requiring "exclude_guest" to be set did not work. The default
> for the perf tool does set "exclude_guest" if no exception level
> options are specified. However, specifying kernel or user events
> defaults to including both host and guest. In this case, only host
> branches are recorded.
>
> BRBE can support some additional exception branch types compared to
> x86. On x86, all exceptions other than syscalls are recorded as IRQ.
> With BRBE, it is possible to better categorize these exceptions. One
> limitation relative to x86 is we cannot distinguish a syscall return
> from other exception returns. So all exception returns are recorded as
> ERET type. The FIQ branch type is omitted as the only FIQ user is Apple
> platforms which don't support BRBE. The debug branch types are omitted
> as there is no clear need for them.
>
> BRBE records are invalidated whenever events are reconfigured, a new
> task is scheduled in, or after recording is paused (and the records
> have been recorded for the event). The architecture allows branch
> records to be invalidated by the PE under implementation defined
> conditions. It is expected that these conditions are rare.
>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Co-developed-by: Anshuman Khandual <anshuman.khandual@arm.com>
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> Co-developed-by: Mark Rutland <mark.rutland@arm.com>
> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> Tested-by: James Clark <james.clark@linaro.org>
> Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
> ---
> v23:
>   - Drop the syscall fixup and directly convert BRBE CALL type to perf
>     SYSCALL as only calls to higher EL generate a CALL event
>
> v22:
>   - Move branch stack disabling after armpmu_stop() in armpmu_del()
>   - Fix branch_records_alloc() to work on heterogeneous systems
>   - Make setting .sched_task function ptr conditional on BRBE support
>
> v21:
>   - update .sched_task() parameters. task_struct added in v6.15
>
> v20:
>   - Fix sparse percpu warning in branch_records_alloc()
>   - Use pr_debug instead of pr_debug_once. Add debug print on all error
>     cases when event.attr is rejected.
>   - Add back some arm64 specific exception types
>   - Convert 'call' from user to kernel to syscall as appropriate
>   - Drop requiring event and branch privileges to match
>   - Only enable exceptions and exception returns if recording kernel
>     branches
>   - Add "branches" caps sysfs attribute like x86
>   - Drop some unused defines
>   - Use u64 instead of unsigned long for branch record fields
>   - use min() in brbinf_get_cycles()
>   - Reword comment about FZP and MDCR_EL2.HPMN interaction
>   - Add comments on assumptions about calling brbe_enable()
>   - Merge capture_brbe_flags() into perf_entry_from_brbe_regset()
>   - Rework BRBE invalidation to avoid invalidating in interrupt handler
>     when no handled events capture the branch stack.
>   - Also clear BRBCR_ELx in brbe_disable(). This is for KVM nVHE checks
>     if BRBE is enabled.
>
> v19:
> - Drop saving of branch records when task scheduled out. (Mark)
> - Got rid of added armpmu ops. All BRBE support contained within pmuv3
>    code.
> - Dropped armpmu.num_branch_records as reg_brbidr has same info.
> - Make sched_task() callback actually get called. Enabling requires a
>    call to perf_sched_cb_inc().
> - Fix freeze on overflow for VHE
> - The cycle counter doesn't freeze BRBE on overflow, so avoid assigning
>    it when BRBE is enabled.
> - Drop all the Arm specific exception branches. Not a clear need for
>    them.
> - Simplify enable/disable to avoid RMW and document ISBs needed
> - Fix handling of branch 'cycles' reading. CC field is
>    mantissa/exponent, not an integer.
> - Save BRBFCR and BRBCR settings in event->hw.branch_reg.config and
>    event->hw.extra_reg.config to avoid recalculating the register value
>    each time the event is installed.
> - Rework s/w filtering to better match h/w filtering
> - Reject events with disjoint event filter and branch filter
> - Reject events if exclude_host is set
>
> v18: https://lore.kernel.org/all/20240613061731.3109448-6-anshuman.khandual@arm.com/
> ---
>   drivers/perf/Kconfig         |  11 +
>   drivers/perf/Makefile        |   1 +
>   drivers/perf/arm_brbe.c      | 798 +++++++++++++++++++++++++++++++++++++++++++
>   drivers/perf/arm_brbe.h      |  47 +++
>   drivers/perf/arm_pmu.c       |  16 +-
>   drivers/perf/arm_pmuv3.c     | 125 ++++++-
>   include/linux/perf/arm_pmu.h |   8 +
>   7 files changed, 999 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/perf/Kconfig b/drivers/perf/Kconfig
> index 278c929dc87a..a9188dec36fe 100644
> --- a/drivers/perf/Kconfig
> +++ b/drivers/perf/Kconfig
> @@ -223,6 +223,17 @@ config ARM_SPE_PMU
>   	  Extension, which provides periodic sampling of operations in
>   	  the CPU pipeline and reports this via the perf AUX interface.
>   
> +config ARM64_BRBE
> +	bool "Enable support for branch stack sampling using FEAT_BRBE"
> +	depends on ARM_PMUV3 && ARM64
> +	default y
> +	help
> +	  Enable perf support for Branch Record Buffer Extension (BRBE) which
> +	  records all branches taken in an execution path. This supports some
> +	  branch types and privilege based filtering. It captures additional
> +	  relevant information such as cycle count, misprediction and branch
> +	  type, branch privilege level etc.
> +
>   config ARM_DMC620_PMU
>   	tristate "Enable PMU support for the ARM DMC-620 memory controller"
>   	depends on (ARM64 && ACPI) || COMPILE_TEST
> diff --git a/drivers/perf/Makefile b/drivers/perf/Makefile
> index de71d2574857..192fc8b16204 100644
> --- a/drivers/perf/Makefile
> +++ b/drivers/perf/Makefile
> @@ -23,6 +23,7 @@ obj-$(CONFIG_STARFIVE_STARLINK_PMU) += starfive_starlink_pmu.o
>   obj-$(CONFIG_THUNDERX2_PMU) += thunderx2_pmu.o
>   obj-$(CONFIG_XGENE_PMU) += xgene_pmu.o
>   obj-$(CONFIG_ARM_SPE_PMU) += arm_spe_pmu.o
> +obj-$(CONFIG_ARM64_BRBE) += arm_brbe.o
>   obj-$(CONFIG_ARM_DMC620_PMU) += arm_dmc620_pmu.o
>   obj-$(CONFIG_MARVELL_CN10K_TAD_PMU) += marvell_cn10k_tad_pmu.o
>   obj-$(CONFIG_MARVELL_CN10K_DDR_PMU) += marvell_cn10k_ddr_pmu.o
> diff --git a/drivers/perf/arm_brbe.c b/drivers/perf/arm_brbe.c
> new file mode 100644
> index 000000000000..acdde61a8559
> --- /dev/null
> +++ b/drivers/perf/arm_brbe.c
> @@ -0,0 +1,798 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Branch Record Buffer Extension Driver.
> + *
> + * Copyright (C) 2022-2025 ARM Limited
> + *
> + * Author: Anshuman Khandual <anshuman.khandual@arm.com>
> + */
> +#include <linux/types.h>
> +#include <linux/bitmap.h>
> +#include <linux/perf/arm_pmu.h>
> +#include "arm_brbe.h"
> +
> +#define BRBFCR_EL1_BRANCH_FILTERS (BRBFCR_EL1_DIRECT   | \
> +				   BRBFCR_EL1_INDIRECT | \
> +				   BRBFCR_EL1_RTN      | \
> +				   BRBFCR_EL1_INDCALL  | \
> +				   BRBFCR_EL1_DIRCALL  | \
> +				   BRBFCR_EL1_CONDDIR)
> +
> +/*
> + * BRBTS_EL1 is currently not used for branch stack implementation
> + * purpose but BRBCR_ELx.TS needs to have a valid value from all
> + * available options. BRBCR_ELx_TS_VIRTUAL is selected for this.
> + */
> +#define BRBCR_ELx_DEFAULT_TS      FIELD_PREP(BRBCR_ELx_TS_MASK, BRBCR_ELx_TS_VIRTUAL)
> +
> +/*
> + * BRBE Buffer Organization
> + *
> + * BRBE buffer is arranged as multiple banks of 32 branch record
> + * entries each. An individual branch record in a given bank could
> + * be accessed, after selecting the bank in BRBFCR_EL1.BANK and
> + * accessing the registers i.e [BRBSRC, BRBTGT, BRBINF] set with
> + * indices [0..31].
> + *
> + * Bank 0
> + *
> + *	---------------------------------	------
> + *	| 00 | BRBSRC | BRBTGT | BRBINF |	| 00 |
> + *	---------------------------------	------
> + *	| 01 | BRBSRC | BRBTGT | BRBINF |	| 01 |
> + *	---------------------------------	------
> + *	| .. | BRBSRC | BRBTGT | BRBINF |	| .. |
> + *	---------------------------------	------
> + *	| 31 | BRBSRC | BRBTGT | BRBINF |	| 31 |
> + *	---------------------------------	------
> + *
> + * Bank 1
> + *
> + *	---------------------------------	------
> + *	| 32 | BRBSRC | BRBTGT | BRBINF |	| 00 |
> + *	---------------------------------	------
> + *	| 33 | BRBSRC | BRBTGT | BRBINF |	| 01 |
> + *	---------------------------------	------
> + *	| .. | BRBSRC | BRBTGT | BRBINF |	| .. |
> + *	---------------------------------	------
> + *	| 63 | BRBSRC | BRBTGT | BRBINF |	| 31 |
> + *	---------------------------------	------
> + */
> +#define BRBE_BANK_MAX_ENTRIES	32
> +
> +struct brbe_regset {
> +	u64 brbsrc;
> +	u64 brbtgt;
> +	u64 brbinf;
> +};
> +
> +#define PERF_BR_ARM64_MAX (PERF_BR_MAX + PERF_BR_NEW_MAX)
> +
> +struct brbe_hw_attr {
> +	int	brbe_version;
> +	int	brbe_cc;
> +	int	brbe_nr;
> +	int	brbe_format;
> +};
> +
> +#define BRBE_REGN_CASE(n, case_macro) \
> +	case n: case_macro(n); break
> +
> +#define BRBE_REGN_SWITCH(x, case_macro)				\
> +	do {							\
> +		switch (x) {					\
> +		BRBE_REGN_CASE(0, case_macro);			\
> +		BRBE_REGN_CASE(1, case_macro);			\
> +		BRBE_REGN_CASE(2, case_macro);			\
> +		BRBE_REGN_CASE(3, case_macro);			\
> +		BRBE_REGN_CASE(4, case_macro);			\
> +		BRBE_REGN_CASE(5, case_macro);			\
> +		BRBE_REGN_CASE(6, case_macro);			\
> +		BRBE_REGN_CASE(7, case_macro);			\
> +		BRBE_REGN_CASE(8, case_macro);			\
> +		BRBE_REGN_CASE(9, case_macro);			\
> +		BRBE_REGN_CASE(10, case_macro);			\
> +		BRBE_REGN_CASE(11, case_macro);			\
> +		BRBE_REGN_CASE(12, case_macro);			\
> +		BRBE_REGN_CASE(13, case_macro);			\
> +		BRBE_REGN_CASE(14, case_macro);			\
> +		BRBE_REGN_CASE(15, case_macro);			\
> +		BRBE_REGN_CASE(16, case_macro);			\
> +		BRBE_REGN_CASE(17, case_macro);			\
> +		BRBE_REGN_CASE(18, case_macro);			\
> +		BRBE_REGN_CASE(19, case_macro);			\
> +		BRBE_REGN_CASE(20, case_macro);			\
> +		BRBE_REGN_CASE(21, case_macro);			\
> +		BRBE_REGN_CASE(22, case_macro);			\
> +		BRBE_REGN_CASE(23, case_macro);			\
> +		BRBE_REGN_CASE(24, case_macro);			\
> +		BRBE_REGN_CASE(25, case_macro);			\
> +		BRBE_REGN_CASE(26, case_macro);			\
> +		BRBE_REGN_CASE(27, case_macro);			\
> +		BRBE_REGN_CASE(28, case_macro);			\
> +		BRBE_REGN_CASE(29, case_macro);			\
> +		BRBE_REGN_CASE(30, case_macro);			\
> +		BRBE_REGN_CASE(31, case_macro);			\
> +		default: WARN(1, "Invalid BRB* index %d\n", x);	\
> +		}						\
> +	} while (0)
> +
> +#define RETURN_READ_BRBSRCN(n) \
> +	return read_sysreg_s(SYS_BRBSRC_EL1(n))
> +static inline u64 get_brbsrc_reg(int idx)
> +{
> +	BRBE_REGN_SWITCH(idx, RETURN_READ_BRBSRCN);
> +	return 0;
> +}
> +
> +#define RETURN_READ_BRBTGTN(n) \
> +	return read_sysreg_s(SYS_BRBTGT_EL1(n))
> +static u64 get_brbtgt_reg(int idx)
> +{
> +	BRBE_REGN_SWITCH(idx, RETURN_READ_BRBTGTN);
> +	return 0;
> +}
> +
> +#define RETURN_READ_BRBINFN(n) \
> +	return read_sysreg_s(SYS_BRBINF_EL1(n))
> +static u64 get_brbinf_reg(int idx)
> +{
> +	BRBE_REGN_SWITCH(idx, RETURN_READ_BRBINFN);
> +	return 0;
> +}
> +
> +static u64 brbe_record_valid(u64 brbinf)
> +{
> +	return FIELD_GET(BRBINFx_EL1_VALID_MASK, brbinf);
> +}
> +
> +static bool brbe_invalid(u64 brbinf)
> +{
> +	return brbe_record_valid(brbinf) == BRBINFx_EL1_VALID_NONE;
> +}
> +
> +static bool brbe_record_is_complete(u64 brbinf)
> +{
> +	return brbe_record_valid(brbinf) == BRBINFx_EL1_VALID_FULL;
> +}
> +
> +static bool brbe_record_is_source_only(u64 brbinf)
> +{
> +	return brbe_record_valid(brbinf) == BRBINFx_EL1_VALID_SOURCE;
> +}
> +
> +static bool brbe_record_is_target_only(u64 brbinf)
> +{
> +	return brbe_record_valid(brbinf) == BRBINFx_EL1_VALID_TARGET;
> +}
> +
> +static int brbinf_get_in_tx(u64 brbinf)
> +{
> +	return FIELD_GET(BRBINFx_EL1_T_MASK, brbinf);
> +}
> +
> +static int brbinf_get_mispredict(u64 brbinf)
> +{
> +	return FIELD_GET(BRBINFx_EL1_MPRED_MASK, brbinf);
> +}
> +
> +static int brbinf_get_lastfailed(u64 brbinf)
> +{
> +	return FIELD_GET(BRBINFx_EL1_LASTFAILED_MASK, brbinf);
> +}
> +
> +static u16 brbinf_get_cycles(u64 brbinf)
> +{
> +	u32 exp, mant, cycles;
> +	/*
> +	 * Captured cycle count is unknown and hence
> +	 * should not be passed on to userspace.
> +	 */
> +	if (brbinf & BRBINFx_EL1_CCU)
> +		return 0;
> +
> +	exp = FIELD_GET(BRBINFx_EL1_CC_EXP_MASK, brbinf);
> +	mant = FIELD_GET(BRBINFx_EL1_CC_MANT_MASK, brbinf);
> +
> +	if (!exp)
> +		return mant;
> +
> +	cycles = (mant | 0x100) << (exp - 1);
> +
> +	return min(cycles, U16_MAX);
> +}
> +
> +static int brbinf_get_type(u64 brbinf)
> +{
> +	return FIELD_GET(BRBINFx_EL1_TYPE_MASK, brbinf);
> +}
> +
> +static int brbinf_get_el(u64 brbinf)
> +{
> +	return FIELD_GET(BRBINFx_EL1_EL_MASK, brbinf);
> +}
> +
> +void brbe_invalidate(void)
> +{
> +	// Ensure all branches before this point are recorded
> +	isb();
> +	asm volatile(BRB_IALL_INSN);
> +	// Ensure all branch records are invalidated after this point
> +	isb();
> +}
> +
> +static bool valid_brbe_nr(int brbe_nr)
> +{
> +	return brbe_nr == BRBIDR0_EL1_NUMREC_8 ||
> +	       brbe_nr == BRBIDR0_EL1_NUMREC_16 ||
> +	       brbe_nr == BRBIDR0_EL1_NUMREC_32 ||
> +	       brbe_nr == BRBIDR0_EL1_NUMREC_64;
> +}
> +
> +static bool valid_brbe_cc(int brbe_cc)
> +{
> +	return brbe_cc == BRBIDR0_EL1_CC_20_BIT;
> +}
> +
> +static bool valid_brbe_format(int brbe_format)
> +{
> +	return brbe_format == BRBIDR0_EL1_FORMAT_FORMAT_0;
> +}
> +
> +static bool valid_brbidr(u64 brbidr)
> +{
> +	int brbe_format, brbe_cc, brbe_nr;
> +
> +	brbe_format = FIELD_GET(BRBIDR0_EL1_FORMAT_MASK, brbidr);
> +	brbe_cc = FIELD_GET(BRBIDR0_EL1_CC_MASK, brbidr);
> +	brbe_nr = FIELD_GET(BRBIDR0_EL1_NUMREC_MASK, brbidr);
> +
> +	return valid_brbe_format(brbe_format) && valid_brbe_cc(brbe_cc) && valid_brbe_nr(brbe_nr);
> +}
> +
> +static bool valid_brbe_version(int brbe_version)
> +{
> +	return brbe_version == ID_AA64DFR0_EL1_BRBE_IMP ||
> +	       brbe_version == ID_AA64DFR0_EL1_BRBE_BRBE_V1P1;
> +}
> +
> +static void select_brbe_bank(int bank)
> +{
> +	u64 brbfcr;
> +
> +	brbfcr = read_sysreg_s(SYS_BRBFCR_EL1);
> +	brbfcr &= ~BRBFCR_EL1_BANK_MASK;
> +	brbfcr |= SYS_FIELD_PREP(BRBFCR_EL1, BANK, bank);
> +	write_sysreg_s(brbfcr, SYS_BRBFCR_EL1);
> +	/*
> +	 * Arm ARM (DDI 0487K.a) D.18.4 rule PPBZP requires explicit sync
> +	 * between setting BANK and accessing branch records.
> +	 */
> +	isb();
> +}
> +
> +static bool __read_brbe_regset(struct brbe_regset *entry, int idx)
> +{
> +	entry->brbinf = get_brbinf_reg(idx);
> +
> +	if (brbe_invalid(entry->brbinf))
> +		return false;
> +
> +	entry->brbsrc = get_brbsrc_reg(idx);
> +	entry->brbtgt = get_brbtgt_reg(idx);
> +	return true;
> +}
> +
> +/*
> + * Generic perf branch filters supported on BRBE
> + *
> + * New branch filters need to be evaluated whether they could be supported on
> + * BRBE. This ensures that such branch filters would not just be accepted, to
> + * fail silently. PERF_SAMPLE_BRANCH_HV is a special case that is selectively
> + * supported only on platforms where kernel is in hyp mode.
> + */
> +#define BRBE_EXCLUDE_BRANCH_FILTERS (PERF_SAMPLE_BRANCH_ABORT_TX	| \
> +				     PERF_SAMPLE_BRANCH_IN_TX		| \
> +				     PERF_SAMPLE_BRANCH_NO_TX		| \
> +				     PERF_SAMPLE_BRANCH_CALL_STACK	| \
> +				     PERF_SAMPLE_BRANCH_COUNTERS)
> +
> +#define BRBE_ALLOWED_BRANCH_TYPES   (PERF_SAMPLE_BRANCH_ANY		| \
> +				     PERF_SAMPLE_BRANCH_ANY_CALL	| \
> +				     PERF_SAMPLE_BRANCH_ANY_RETURN	| \
> +				     PERF_SAMPLE_BRANCH_IND_CALL	| \
> +				     PERF_SAMPLE_BRANCH_COND		| \
> +				     PERF_SAMPLE_BRANCH_IND_JUMP	| \
> +				     PERF_SAMPLE_BRANCH_CALL)
> +
> +
> +#define BRBE_ALLOWED_BRANCH_FILTERS (PERF_SAMPLE_BRANCH_USER		| \
> +				     PERF_SAMPLE_BRANCH_KERNEL		| \
> +				     PERF_SAMPLE_BRANCH_HV		| \
> +				     BRBE_ALLOWED_BRANCH_TYPES		| \
> +				     PERF_SAMPLE_BRANCH_NO_FLAGS	| \
> +				     PERF_SAMPLE_BRANCH_NO_CYCLES	| \
> +				     PERF_SAMPLE_BRANCH_TYPE_SAVE	| \
> +				     PERF_SAMPLE_BRANCH_HW_INDEX	| \
> +				     PERF_SAMPLE_BRANCH_PRIV_SAVE)
> +
> +#define BRBE_PERF_BRANCH_FILTERS    (BRBE_ALLOWED_BRANCH_FILTERS	| \
> +				     BRBE_EXCLUDE_BRANCH_FILTERS)
> +
> +/*
> + * BRBE supports the following functional branch type filters while
> + * generating branch records. These branch filters can be enabled,
> + * either individually or as a group i.e ORing multiple filters
> + * with each other.
> + *
> + * BRBFCR_EL1_CONDDIR  - Conditional direct branch
> + * BRBFCR_EL1_DIRCALL  - Direct call
> + * BRBFCR_EL1_INDCALL  - Indirect call
> + * BRBFCR_EL1_INDIRECT - Indirect branch
> + * BRBFCR_EL1_DIRECT   - Direct branch
> + * BRBFCR_EL1_RTN      - Subroutine return
> + */
> +static u64 branch_type_to_brbfcr(int branch_type)
> +{
> +	u64 brbfcr = 0;
> +
> +	if (branch_type & PERF_SAMPLE_BRANCH_ANY) {
> +		brbfcr |= BRBFCR_EL1_BRANCH_FILTERS;
> +		return brbfcr;
> +	}
> +
> +	if (branch_type & PERF_SAMPLE_BRANCH_ANY_CALL) {
> +		brbfcr |= BRBFCR_EL1_INDCALL;
> +		brbfcr |= BRBFCR_EL1_DIRCALL;
> +	}
> +
> +	if (branch_type & PERF_SAMPLE_BRANCH_ANY_RETURN)
> +		brbfcr |= BRBFCR_EL1_RTN;
> +
> +	if (branch_type & PERF_SAMPLE_BRANCH_IND_CALL)
> +		brbfcr |= BRBFCR_EL1_INDCALL;
> +
> +	if (branch_type & PERF_SAMPLE_BRANCH_COND)
> +		brbfcr |= BRBFCR_EL1_CONDDIR;
> +
> +	if (branch_type & PERF_SAMPLE_BRANCH_IND_JUMP)
> +		brbfcr |= BRBFCR_EL1_INDIRECT;
> +
> +	if (branch_type & PERF_SAMPLE_BRANCH_CALL)
> +		brbfcr |= BRBFCR_EL1_DIRCALL;
> +
> +	return brbfcr;
> +}
> +
> +/*
> + * BRBE supports the following privilege mode filters while generating
> + * branch records.
> + *
> + * BRBCR_ELx_E0BRE - EL0 branch records
> + * BRBCR_ELx_ExBRE - EL1/EL2 branch records
> + *
> + * BRBE also supports the following additional functional branch type
> + * filters while generating branch records.
> + *
> + * BRBCR_ELx_EXCEPTION - Exception
> + * BRBCR_ELx_ERTN     -  Exception return
> + */
> +static u64 branch_type_to_brbcr(int branch_type)
> +{
> +	u64 brbcr = BRBCR_ELx_FZP | BRBCR_ELx_DEFAULT_TS;
> +
> +	if (branch_type & PERF_SAMPLE_BRANCH_USER)
> +		brbcr |= BRBCR_ELx_E0BRE;
> +
> +	/*
> +	 * When running in the hyp mode, writing into BRBCR_EL1
> +	 * actually writes into BRBCR_EL2 instead. Field E2BRE
> +	 * is also at the same position as E1BRE.
> +	 */
> +	if (branch_type & PERF_SAMPLE_BRANCH_KERNEL)
> +		brbcr |= BRBCR_ELx_ExBRE;
> +
> +	if (branch_type & PERF_SAMPLE_BRANCH_HV) {
> +		if (is_kernel_in_hyp_mode())
> +			brbcr |= BRBCR_ELx_ExBRE;
> +	}
> +
> +	if (!(branch_type & PERF_SAMPLE_BRANCH_NO_CYCLES))
> +		brbcr |= BRBCR_ELx_CC;
> +
> +	if (!(branch_type & PERF_SAMPLE_BRANCH_NO_FLAGS))
> +		brbcr |= BRBCR_ELx_MPRED;
> +
> +	/*
> +	 * The exception and exception return branches could be
> +	 * captured, irrespective of the perf event's privilege.
> +	 * If the perf event does not have enough privilege for
> +	 * a given exception level, then addresses which falls
> +	 * under that exception level will be reported as zero
> +	 * for the captured branch record, creating source only
> +	 * or target only records.
> +	 */
> +	if (branch_type & PERF_SAMPLE_BRANCH_KERNEL) {
> +		if (branch_type & PERF_SAMPLE_BRANCH_ANY) {
> +			brbcr |= BRBCR_ELx_EXCEPTION;
> +			brbcr |= BRBCR_ELx_ERTN;
> +		}
> +
> +		if (branch_type & PERF_SAMPLE_BRANCH_ANY_CALL)
> +			brbcr |= BRBCR_ELx_EXCEPTION;
> +
> +		if (branch_type & PERF_SAMPLE_BRANCH_ANY_RETURN)
> +			brbcr |= BRBCR_ELx_ERTN;
> +	}
> +	return brbcr;
> +}
> +
> +bool brbe_branch_attr_valid(struct perf_event *event)
> +{
> +	u64 branch_type = event->attr.branch_sample_type;
> +
> +	/*
> +	 * Ensure both perf branch filter allowed and exclude
> +	 * masks are always in sync with the generic perf ABI.
> +	 */
> +	BUILD_BUG_ON(BRBE_PERF_BRANCH_FILTERS != (PERF_SAMPLE_BRANCH_MAX - 1));
> +
> +	if (branch_type & BRBE_EXCLUDE_BRANCH_FILTERS) {
> +		pr_debug("requested branch filter not supported 0x%llx\n", branch_type);
> +		return false;
> +	}
> +
> +	/* Ensure at least 1 branch type is enabled */
> +	if (!(branch_type & BRBE_ALLOWED_BRANCH_TYPES)) {
> +		pr_debug("no branch type enabled 0x%llx\n", branch_type);
> +		return false;
> +	}
> +
> +	/*
> +	 * No branches are recorded in guests nor nVHE hypervisors, so
> +	 * excluding the host or both kernel and user is invalid.
> +	 *
> +	 * Ideally we'd just require exclude_guest and exclude_hv, but setting
> +	 * event filters with perf for kernel or user don't set exclude_guest.
> +	 * So effectively, exclude_guest and exclude_hv are ignored.
> +	 */
> +	if (event->attr.exclude_host || (event->attr.exclude_user && event->attr.exclude_kernel)) {
> +		pr_debug("branch filter in hypervisor or guest only not supported 0x%llx\n", branch_type);
> +		return false;
> +	}
> +
> +	event->hw.branch_reg.config = branch_type_to_brbfcr(event->attr.branch_sample_type);
> +	event->hw.extra_reg.config = branch_type_to_brbcr(event->attr.branch_sample_type);
> +
> +	return true;
> +}
> +
> +unsigned int brbe_num_branch_records(const struct arm_pmu *armpmu)
> +{
> +	return FIELD_GET(BRBIDR0_EL1_NUMREC_MASK, armpmu->reg_brbidr);
> +}
> +
> +void brbe_probe(struct arm_pmu *armpmu)
> +{
> +	u64 aa64dfr0 = read_sysreg_s(SYS_ID_AA64DFR0_EL1);
> +	u32 brbe;
> +
> +	brbe = cpuid_feature_extract_unsigned_field(aa64dfr0, ID_AA64DFR0_EL1_BRBE_SHIFT);
> +	if (!valid_brbe_version(brbe))
> +		return;
> +
> +	u64 brbidr = read_sysreg_s(SYS_BRBIDR0_EL1);
> +	if (!valid_brbidr(brbidr))
> +		return;
> +
> +	armpmu->reg_brbidr = brbidr;
> +}
> +
> +/*
> + * BRBE is assumed to be disabled/paused on entry
> + */
> +void brbe_enable(const struct arm_pmu *arm_pmu)
> +{
> +	struct pmu_hw_events *cpuc = this_cpu_ptr(arm_pmu->hw_events);
> +	u64 brbfcr = 0, brbcr = 0;
> +
> +	/*
> +	 * Merge the permitted branch filters of all events.
> +	 */
> +	for (int i = 0; i < ARMPMU_MAX_HWEVENTS; i++) {
> +		struct perf_event *event = cpuc->events[i];
> +
> +		if (event && has_branch_stack(event)) {
> +			brbfcr |= event->hw.branch_reg.config;
> +			brbcr |= event->hw.extra_reg.config;
> +		}
> +	}
> +
> +	/*
> +	 * In VHE mode with MDCR_EL2.HPMN equal to PMCR_EL0.N, BRBCR_EL1.FZP
> +	 * controls freezing the branch records on counter overflow rather than
> +	 * BRBCR_EL2.FZP (which writes to BRBCR_EL1 are redirected to).
> +	 * The exception levels are enabled/disabled in BRBCR_EL2, so keep EL1
> +	 * and EL0 recording disabled for guests.
> +	 *
> +	 * As BRBCR_EL1 CC and MPRED bits also need to match, use the same
> +	 * value for both registers just masking the exception levels.
> +	 */
> +	if (is_kernel_in_hyp_mode())
> +		write_sysreg_s(brbcr & ~(BRBCR_ELx_ExBRE | BRBCR_ELx_E0BRE), SYS_BRBCR_EL12);
> +	write_sysreg_s(brbcr, SYS_BRBCR_EL1);
> +	isb(); // Ensure BRBCR_ELx settings take effect before unpausing
> +
> +	// Finally write SYS_BRBFCR_EL to unpause BRBE
> +	write_sysreg_s(brbfcr, SYS_BRBFCR_EL1);
> +	// Synchronization in PMCR write ensures ordering WRT PMU enabling
> +}
> +
> +void brbe_disable(void)
> +{
> +	/*
> +	 * No need for synchronization here as synchronization in PMCR write
> +	 * ensures ordering and in the interrupt handler this is a NOP as
> +	 * we're already paused.
> +	 */
> +	write_sysreg_s(BRBFCR_EL1_PAUSED, SYS_BRBFCR_EL1);
> +	write_sysreg_s(0, SYS_BRBCR_EL1);
> +}
> +
> +static const int brbe_type_to_perf_type_map[BRBINFx_EL1_TYPE_DEBUG_EXIT + 1][2] = {
> +	[BRBINFx_EL1_TYPE_DIRECT_UNCOND] = { PERF_BR_UNCOND, 0 },
> +	[BRBINFx_EL1_TYPE_INDIRECT] = { PERF_BR_IND, 0 },
> +	[BRBINFx_EL1_TYPE_DIRECT_LINK] = { PERF_BR_CALL, 0 },
> +	[BRBINFx_EL1_TYPE_INDIRECT_LINK] = { PERF_BR_IND_CALL, 0 },
> +	[BRBINFx_EL1_TYPE_RET] = { PERF_BR_RET, 0 },
> +	[BRBINFx_EL1_TYPE_DIRECT_COND] = { PERF_BR_COND, 0 },
> +	[BRBINFx_EL1_TYPE_CALL] = { PERF_BR_SYSCALL, 0 },
> +	[BRBINFx_EL1_TYPE_ERET] = { PERF_BR_ERET, 0 },
> +	[BRBINFx_EL1_TYPE_IRQ] = { PERF_BR_IRQ, 0 },
> +	[BRBINFx_EL1_TYPE_TRAP] = { PERF_BR_IRQ, 0 },
> +	[BRBINFx_EL1_TYPE_SERROR] = { PERF_BR_SERROR, 0 },
> +	[BRBINFx_EL1_TYPE_ALIGN_FAULT] = { PERF_BR_EXTEND_ABI, PERF_BR_NEW_FAULT_ALGN },
> +	[BRBINFx_EL1_TYPE_INSN_FAULT] = { PERF_BR_EXTEND_ABI, PERF_BR_NEW_FAULT_INST },
> +	[BRBINFx_EL1_TYPE_DATA_FAULT] = { PERF_BR_EXTEND_ABI, PERF_BR_NEW_FAULT_DATA },
> +};
> +
> +static void brbe_set_perf_entry_type(struct perf_branch_entry *entry, u64 brbinf)
> +{
> +	int brbe_type = brbinf_get_type(brbinf);
> +
> +	if (brbe_type <= BRBINFx_EL1_TYPE_DEBUG_EXIT) {
> +		const int *br_type = brbe_type_to_perf_type_map[brbe_type];
> +
> +		entry->type = br_type[0];
> +		entry->new_type = br_type[1];
> +	}
> +}
> +
> +static int brbinf_get_perf_priv(u64 brbinf)
> +{
> +	int brbe_el = brbinf_get_el(brbinf);
> +
> +	switch (brbe_el) {
> +	case BRBINFx_EL1_EL_EL0:
> +		return PERF_BR_PRIV_USER;
> +	case BRBINFx_EL1_EL_EL1:
> +		return PERF_BR_PRIV_KERNEL;
> +	case BRBINFx_EL1_EL_EL2:
> +		if (is_kernel_in_hyp_mode())
> +			return PERF_BR_PRIV_KERNEL;
> +		return PERF_BR_PRIV_HV;
> +	default:
> +		pr_warn_once("%d - unknown branch privilege captured\n", brbe_el);
> +		return PERF_BR_PRIV_UNKNOWN;
> +	}
> +}
> +
> +static bool perf_entry_from_brbe_regset(int index, struct perf_branch_entry *entry,
> +					const struct perf_event *event)
> +{
> +	struct brbe_regset bregs;
> +	u64 brbinf;
> +
> +	if (!__read_brbe_regset(&bregs, index))
> +		return false;
> +
> +	brbinf = bregs.brbinf;
> +	perf_clear_branch_entry_bitfields(entry);
> +	if (brbe_record_is_complete(brbinf)) {
> +		entry->from = bregs.brbsrc;
> +		entry->to = bregs.brbtgt;
> +	} else if (brbe_record_is_source_only(brbinf)) {
> +		entry->from = bregs.brbsrc;
> +		entry->to = 0;
> +	} else if (brbe_record_is_target_only(brbinf)) {
> +		entry->from = 0;
> +		entry->to = bregs.brbtgt;
> +	}
> +
> +	brbe_set_perf_entry_type(entry, brbinf);
> +
> +	if (!branch_sample_no_cycles(event))
> +		entry->cycles = brbinf_get_cycles(brbinf);
> +
> +	if (!branch_sample_no_flags(event)) {
> +		/* Mispredict info is available for source only and complete branch records. */
> +		if (!brbe_record_is_target_only(brbinf)) {
> +			entry->mispred = brbinf_get_mispredict(brbinf);
> +			entry->predicted = !entry->mispred;
> +		}
> +
> +		/*
> +		 * Currently TME feature is neither implemented in any hardware
> +		 * nor it is being supported in the kernel. Just warn here once
> +		 * if TME related information shows up rather unexpectedly.
> +		 */
> +		if (brbinf_get_lastfailed(brbinf) || brbinf_get_in_tx(brbinf))
> +			pr_warn_once("Unknown transaction states\n");
> +	}
> +
> +	/*
> +	 * Branch privilege level is available for target only and complete
> +	 * branch records.
> +	 */
> +	if (!brbe_record_is_source_only(brbinf))
> +		entry->priv = brbinf_get_perf_priv(brbinf);
> +
> +	return true;
> +}
> +
> +#define PERF_BR_ARM64_ALL (				\
> +	BIT(PERF_BR_COND) |				\
> +	BIT(PERF_BR_UNCOND) |				\
> +	BIT(PERF_BR_IND) |				\
> +	BIT(PERF_BR_CALL) |				\
> +	BIT(PERF_BR_IND_CALL) |				\
> +	BIT(PERF_BR_RET))
> +
> +#define PERF_BR_ARM64_ALL_KERNEL (			\
> +	BIT(PERF_BR_SYSCALL) |				\
> +	BIT(PERF_BR_IRQ) |				\
> +	BIT(PERF_BR_SERROR) |				\
> +	BIT(PERF_BR_MAX + PERF_BR_NEW_FAULT_ALGN) |	\
> +	BIT(PERF_BR_MAX + PERF_BR_NEW_FAULT_DATA) |	\
> +	BIT(PERF_BR_MAX + PERF_BR_NEW_FAULT_INST))
> +
> +static void prepare_event_branch_type_mask(u64 branch_sample,
> +					   unsigned long *event_type_mask)
> +{
> +	if (branch_sample & PERF_SAMPLE_BRANCH_ANY) {
> +		if (branch_sample & PERF_SAMPLE_BRANCH_KERNEL)
> +			bitmap_from_u64(event_type_mask,
> +				BIT(PERF_BR_ERET) | PERF_BR_ARM64_ALL |
> +				PERF_BR_ARM64_ALL_KERNEL);
> +		else
> +			bitmap_from_u64(event_type_mask, PERF_BR_ARM64_ALL);
> +		return;
> +	}
> +
> +	bitmap_zero(event_type_mask, PERF_BR_ARM64_MAX);
> +
> +	if (branch_sample & PERF_SAMPLE_BRANCH_ANY_CALL) {
> +		if (branch_sample & PERF_SAMPLE_BRANCH_KERNEL)
> +			bitmap_from_u64(event_type_mask, PERF_BR_ARM64_ALL_KERNEL);
> +
> +		set_bit(PERF_BR_CALL, event_type_mask);
> +		set_bit(PERF_BR_IND_CALL, event_type_mask);
> +	}
> +
> +	if (branch_sample & PERF_SAMPLE_BRANCH_IND_JUMP)
> +		set_bit(PERF_BR_IND, event_type_mask);
> +
> +	if (branch_sample & PERF_SAMPLE_BRANCH_COND)
> +		set_bit(PERF_BR_COND, event_type_mask);
> +
> +	if (branch_sample & PERF_SAMPLE_BRANCH_CALL)
> +		set_bit(PERF_BR_CALL, event_type_mask);
> +
> +	if (branch_sample & PERF_SAMPLE_BRANCH_IND_CALL)
> +		set_bit(PERF_BR_IND_CALL, event_type_mask);
> +
> +	if (branch_sample & PERF_SAMPLE_BRANCH_ANY_RETURN) {
> +		set_bit(PERF_BR_RET, event_type_mask);
> +
> +		if (branch_sample & PERF_SAMPLE_BRANCH_KERNEL)
> +			set_bit(PERF_BR_ERET, event_type_mask);
> +	}
> +}
> +
> +/*
> + * BRBE is configured with an OR of permissions from all events, so there may
> + * be events which have to be dropped or events where just the source or target
> + * address has to be zeroed.
> + */
> +static bool filter_branch_privilege(struct perf_branch_entry *entry, u64 branch_sample_type)
> +{
> +	/* We can only have a half record if permissions have not been expanded */
> +	if (!entry->from || !entry->to)
> +		return true;
> +
> +	bool from_user = access_ok((void __user *)(unsigned long)entry->from, 4);
> +	bool to_user = access_ok((void __user *)(unsigned long)entry->to, 4);
> +	bool exclude_kernel = !((branch_sample_type & PERF_SAMPLE_BRANCH_KERNEL) ||
> +		(is_kernel_in_hyp_mode() && (branch_sample_type & PERF_SAMPLE_BRANCH_HV)));
> +
> +	/*
> +	 * If record is within a single exception level, just need to either
> +	 * drop or keep the entire record.
> +	 */
> +	if (from_user == to_user)
> +		return ((entry->priv == PERF_BR_PRIV_KERNEL) && !exclude_kernel) ||
> +			((entry->priv == PERF_BR_PRIV_USER) &&
> +			 (branch_sample_type & PERF_SAMPLE_BRANCH_USER));
> +
> +	/*
> +	 * Record is across exception levels, mask addresses for the exception
> +	 * level we're not capturing.
> +	 */
> +	if (!(branch_sample_type & PERF_SAMPLE_BRANCH_USER)) {
> +		if (from_user)
> +			entry->from = 0;
> +		if (to_user)
> +			entry->to = 0;
> +	}
> +
> +	if (exclude_kernel) {
> +		if (!from_user)
> +			entry->from = 0;
> +		if (!to_user)
> +			entry->to = 0;
> +	}
> +	return true;
> +}
> +
> +static bool filter_branch_type(struct perf_branch_entry *entry,
> +			       const unsigned long *event_type_mask)
> +{
> +	if (entry->type == PERF_BR_EXTEND_ABI)
> +		return test_bit(PERF_BR_MAX + entry->new_type, event_type_mask);
> +	else
> +		return test_bit(entry->type, event_type_mask);
> +}
> +
> +static bool filter_branch_record(struct perf_branch_entry *entry,
> +				 u64 branch_sample,
> +				 const unsigned long *event_type_mask)
> +{
> +	return filter_branch_type(entry, event_type_mask) &&
> +		filter_branch_privilege(entry, branch_sample);
> +}
> +
> +void brbe_read_filtered_entries(struct perf_branch_stack *branch_stack,
> +				const struct perf_event *event)
> +{
> +	struct arm_pmu *cpu_pmu = to_arm_pmu(event->pmu);
> +	int nr_hw = brbe_num_branch_records(cpu_pmu);
> +	int nr_banks = DIV_ROUND_UP(nr_hw, BRBE_BANK_MAX_ENTRIES);
> +	int nr_filtered = 0;
> +	u64 branch_sample_type = event->attr.branch_sample_type;
> +	DECLARE_BITMAP(event_type_mask, PERF_BR_ARM64_MAX);
> +
> +	prepare_event_branch_type_mask(branch_sample_type, event_type_mask);
> +
> +	for (int bank = 0; bank < nr_banks; bank++) {
> +		int nr_remaining = nr_hw - (bank * BRBE_BANK_MAX_ENTRIES);
> +		int nr_this_bank = min(nr_remaining, BRBE_BANK_MAX_ENTRIES);
> +
> +		select_brbe_bank(bank);
> +
> +		for (int i = 0; i < nr_this_bank; i++) {
> +			struct perf_branch_entry *pbe = &branch_stack->entries[nr_filtered];
> +
> +			if (!perf_entry_from_brbe_regset(i, pbe, event))
> +				goto done;
> +
> +			if (!filter_branch_record(pbe, branch_sample_type, event_type_mask))
> +				continue;
> +
> +			nr_filtered++;
> +		}
> +	}
> +
> +done:
> +	brbe_invalidate();
> +	branch_stack->nr = nr_filtered;
> +}
> diff --git a/drivers/perf/arm_brbe.h b/drivers/perf/arm_brbe.h
> new file mode 100644
> index 000000000000..b7c7d8796c86
> --- /dev/null
> +++ b/drivers/perf/arm_brbe.h
> @@ -0,0 +1,47 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Branch Record Buffer Extension Helpers.
> + *
> + * Copyright (C) 2022-2025 ARM Limited
> + *
> + * Author: Anshuman Khandual <anshuman.khandual@arm.com>
> + */
> +
> +struct arm_pmu;
> +struct perf_branch_stack;
> +struct perf_event;
> +
> +#ifdef CONFIG_ARM64_BRBE
> +void brbe_probe(struct arm_pmu *arm_pmu);
> +unsigned int brbe_num_branch_records(const struct arm_pmu *armpmu);
> +void brbe_invalidate(void);
> +
> +void brbe_enable(const struct arm_pmu *arm_pmu);
> +void brbe_disable(void);
> +
> +bool brbe_branch_attr_valid(struct perf_event *event);
> +void brbe_read_filtered_entries(struct perf_branch_stack *branch_stack,
> +				const struct perf_event *event);
> +#else
> +static inline void brbe_probe(struct arm_pmu *arm_pmu) { }
> +static inline unsigned int brbe_num_branch_records(const struct arm_pmu *armpmu)
> +{
> +	return 0;
> +}
> +
> +static inline void brbe_invalidate(void) { }
> +
> +static inline void brbe_enable(const struct arm_pmu *arm_pmu) { };
> +static inline void brbe_disable(void) { };
> +
> +static inline bool brbe_branch_attr_valid(struct perf_event *event)
> +{
> +	WARN_ON_ONCE(!has_branch_stack(event));
> +	return false;
> +}
> +
> +static void brbe_read_filtered_entries(struct perf_branch_stack *branch_stack,
> +				       const struct perf_event *event)
> +{
> +}
> +#endif
> diff --git a/drivers/perf/arm_pmu.c b/drivers/perf/arm_pmu.c
> index 2f33e69a8caf..5c310e803dd7 100644
> --- a/drivers/perf/arm_pmu.c
> +++ b/drivers/perf/arm_pmu.c
> @@ -99,7 +99,7 @@ static const struct pmu_irq_ops percpu_pmunmi_ops = {
>   	.free_pmuirq = armpmu_free_percpu_pmunmi
>   };
>   
> -static DEFINE_PER_CPU(struct arm_pmu *, cpu_armpmu);
> +DEFINE_PER_CPU(struct arm_pmu *, cpu_armpmu);
>   static DEFINE_PER_CPU(int, cpu_irq);
>   static DEFINE_PER_CPU(const struct pmu_irq_ops *, cpu_irq_ops);
>   
> @@ -318,6 +318,12 @@ armpmu_del(struct perf_event *event, int flags)
>   	int idx = hwc->idx;
>   
>   	armpmu_stop(event, PERF_EF_UPDATE);
> +
> +	if (has_branch_stack(event)) {
> +		hw_events->branch_users--;
> +		perf_sched_cb_dec(event->pmu);
> +	}
> +
>   	hw_events->events[idx] = NULL;
>   	armpmu->clear_event_idx(hw_events, event);
>   	perf_event_update_userpage(event);
> @@ -345,6 +351,11 @@ armpmu_add(struct perf_event *event, int flags)
>   	/* The newly-allocated counter should be empty */
>   	WARN_ON_ONCE(hw_events->events[idx]);
>   
> +	if (has_branch_stack(event)) {
> +		hw_events->branch_users++;
> +		perf_sched_cb_inc(event->pmu);
> +	}
> +
>   	event->hw.idx = idx;
>   	hw_events->events[idx] = event;
>   
> @@ -509,8 +520,7 @@ static int armpmu_event_init(struct perf_event *event)
>   		!cpumask_test_cpu(event->cpu, &armpmu->supported_cpus))
>   		return -ENOENT;
>   
> -	/* does not support taken branch sampling */
> -	if (has_branch_stack(event))
> +	if (has_branch_stack(event) && !armpmu->reg_brbidr)
>   		return -EOPNOTSUPP;
>   
>   	return __hw_perf_event_init(event);
> diff --git a/drivers/perf/arm_pmuv3.c b/drivers/perf/arm_pmuv3.c
> index 3db9f4ed17e8..256c5ee8709c 100644
> --- a/drivers/perf/arm_pmuv3.c
> +++ b/drivers/perf/arm_pmuv3.c
> @@ -25,6 +25,8 @@
>   #include <linux/smp.h>
>   #include <linux/nmi.h>
>   
> +#include "arm_brbe.h"
> +
>   /* ARMv8 Cortex-A53 specific event types. */
>   #define ARMV8_A53_PERFCTR_PREF_LINEFILL				0xC2
>   
> @@ -438,7 +440,19 @@ static ssize_t threshold_max_show(struct device *dev,
>   
>   static DEVICE_ATTR_RO(threshold_max);
>   
> +static ssize_t branches_show(struct device *dev,
> +			     struct device_attribute *attr, char *page)
> +{
> +	struct pmu *pmu = dev_get_drvdata(dev);
> +	struct arm_pmu *cpu_pmu = container_of(pmu, struct arm_pmu, pmu);
> +
> +	return sysfs_emit(page, "%d\n", brbe_num_branch_records(cpu_pmu));
> +}
> +
> +static DEVICE_ATTR_RO(branches);
> +
>   static struct attribute *armv8_pmuv3_caps_attrs[] = {
> +	&dev_attr_branches.attr,
>   	&dev_attr_slots.attr,
>   	&dev_attr_bus_slots.attr,
>   	&dev_attr_bus_width.attr,
> @@ -446,9 +460,22 @@ static struct attribute *armv8_pmuv3_caps_attrs[] = {
>   	NULL,
>   };
>   
> +static umode_t caps_is_visible(struct kobject *kobj, struct attribute *attr, int i)
> +{
> +	struct device *dev = kobj_to_dev(kobj);
> +	struct pmu *pmu = dev_get_drvdata(dev);
> +	struct arm_pmu *cpu_pmu = container_of(pmu, struct arm_pmu, pmu);
> +
> +	if (i == 0)
> +		return brbe_num_branch_records(cpu_pmu) ? attr->mode : 0;
> +
> +	return attr->mode;
> +}
> +
>   static const struct attribute_group armv8_pmuv3_caps_attr_group = {
>   	.name = "caps",
>   	.attrs = armv8_pmuv3_caps_attrs,
> +	.is_visible = caps_is_visible,
>   };
>   
>   /*
> @@ -806,9 +833,10 @@ static void armv8pmu_disable_event(struct perf_event *event)
>   	armv8pmu_disable_event_irq(event);
>   }
>   
> -static void armv8pmu_start(struct arm_pmu *cpu_pmu)
> +static void armv8pmu_restart(struct arm_pmu *cpu_pmu)
>   {
>   	struct perf_event_context *ctx;
> +	struct pmu_hw_events *hw_events = this_cpu_ptr(cpu_pmu->hw_events);
>   	int nr_user = 0;
>   
>   	ctx = perf_cpu_task_ctx();
> @@ -822,16 +850,44 @@ static void armv8pmu_start(struct arm_pmu *cpu_pmu)
>   
>   	kvm_vcpu_pmu_resync_el0();
>   
> +	if (hw_events->branch_users)
> +		brbe_enable(cpu_pmu);
> +
>   	/* Enable all counters */
>   	armv8pmu_pmcr_write(armv8pmu_pmcr_read() | ARMV8_PMU_PMCR_E);
>   }
>   
> +static void armv8pmu_start(struct arm_pmu *cpu_pmu)
> +{
> +	struct pmu_hw_events *hw_events = this_cpu_ptr(cpu_pmu->hw_events);
> +
> +	if (hw_events->branch_users)
> +		brbe_invalidate();
> +
> +	armv8pmu_restart(cpu_pmu);
> +}
> +
>   static void armv8pmu_stop(struct arm_pmu *cpu_pmu)
>   {
> +	struct pmu_hw_events *hw_events = this_cpu_ptr(cpu_pmu->hw_events);
> +
> +	if (hw_events->branch_users)
> +		brbe_disable();
> +
>   	/* Disable all counters */
>   	armv8pmu_pmcr_write(armv8pmu_pmcr_read() & ~ARMV8_PMU_PMCR_E);
>   }
>   
> +static void read_branch_records(struct pmu_hw_events *cpuc,
> +				struct perf_event *event,
> +				struct perf_sample_data *data)
> +{
> +	struct perf_branch_stack *branch_stack = cpuc->branch_stack;
> +
> +	brbe_read_filtered_entries(branch_stack, event);
> +	perf_sample_save_brstack(data, event, branch_stack, NULL);
> +}
> +
>   static irqreturn_t armv8pmu_handle_irq(struct arm_pmu *cpu_pmu)
>   {
>   	u64 pmovsr;
> @@ -882,6 +938,13 @@ static irqreturn_t armv8pmu_handle_irq(struct arm_pmu *cpu_pmu)
>   		if (!armpmu_event_set_period(event))
>   			continue;
>   
> +		/*
> +		 * PMU IRQ should remain asserted until all branch records
> +		 * are captured and processed into struct perf_sample_data.
> +		 */
> +		if (has_branch_stack(event))
> +			read_branch_records(cpuc, event, &data);
> +
>   		/*
>   		 * Perf event overflow will queue the processing of the event as
>   		 * an irq_work which will be taken care of in the handling of
> @@ -889,7 +952,7 @@ static irqreturn_t armv8pmu_handle_irq(struct arm_pmu *cpu_pmu)
>   		 */
>   		perf_event_overflow(event, &data, regs);
>   	}
> -	armv8pmu_start(cpu_pmu);
> +	armv8pmu_restart(cpu_pmu);
>   
>   	return IRQ_HANDLED;
>   }
> @@ -938,7 +1001,7 @@ static int armv8pmu_get_event_idx(struct pmu_hw_events *cpuc,
>   
>   	/* Always prefer to place a cycle counter into the cycle counter. */
>   	if ((evtype == ARMV8_PMUV3_PERFCTR_CPU_CYCLES) &&
> -	    !armv8pmu_event_get_threshold(&event->attr)) {
> +	    !armv8pmu_event_get_threshold(&event->attr) && !has_branch_stack(event)) {
>   		if (!test_and_set_bit(ARMV8_PMU_CYCLE_IDX, cpuc->used_mask))
>   			return ARMV8_PMU_CYCLE_IDX;
>   		else if (armv8pmu_event_is_64bit(event) &&
> @@ -987,6 +1050,19 @@ static int armv8pmu_user_event_idx(struct perf_event *event)
>   	return event->hw.idx + 1;
>   }
>   
> +static void armv8pmu_sched_task(struct perf_event_pmu_context *pmu_ctx,
> +				struct task_struct *task, bool sched_in)
> +{
> +	struct arm_pmu *armpmu = *this_cpu_ptr(&cpu_armpmu);
> +	struct pmu_hw_events *hw_events = this_cpu_ptr(armpmu->hw_events);
> +
> +	if (!hw_events->branch_users)
> +		return;
> +
> +	if (sched_in)
> +		brbe_invalidate();
> +}
> +
>   /*
>    * Add an event filter to a given event.
>    */
> @@ -1004,6 +1080,13 @@ static int armv8pmu_set_event_filter(struct hw_perf_event *event,
>   		return -EOPNOTSUPP;
>   	}
>   
> +	if (has_branch_stack(perf_event)) {
> +		if (!brbe_num_branch_records(cpu_pmu) || !brbe_branch_attr_valid(perf_event))
> +			return -EOPNOTSUPP;
> +
> +		perf_event->attach_state |= PERF_ATTACH_SCHED_CB;
> +	}
> +
>   	/*
>   	 * If we're running in hyp mode, then we *are* the hypervisor.
>   	 * Therefore we ignore exclude_hv in this configuration, since
> @@ -1070,6 +1153,11 @@ static void armv8pmu_reset(void *info)
>   	/* Clear the counters we flip at guest entry/exit */
>   	kvm_clr_pmu_events(mask);
>   
> +	if (brbe_num_branch_records(cpu_pmu)) {
> +		brbe_disable();
> +		brbe_invalidate();
> +	}
> +
>   	/*
>   	 * Initialize & Reset PMNC. Request overflow interrupt for
>   	 * 64 bit cycle counter but cheat in armv8pmu_write_counter().
> @@ -1238,6 +1326,25 @@ static void __armv8pmu_probe_pmu(void *info)
>   		cpu_pmu->reg_pmmir = read_pmmir();
>   	else
>   		cpu_pmu->reg_pmmir = 0;
> +
> +	brbe_probe(cpu_pmu);
> +}
> +
> +static int branch_records_alloc(struct arm_pmu *armpmu)
> +{
> +	size_t size = struct_size_t(struct perf_branch_stack, entries,
> +				    brbe_num_branch_records(armpmu));
> +	int cpu;
> +
> +	for_each_cpu(cpu, &armpmu->supported_cpus) {
> +		struct pmu_hw_events *events_cpu;
> +
> +		events_cpu = per_cpu_ptr(armpmu->hw_events, cpu);
> +		events_cpu->branch_stack = kmalloc(size, GFP_KERNEL);
> +		if (!events_cpu->branch_stack)
> +			return -ENOMEM;
> +	}
> +	return 0;
>   }
>   
>   static int armv8pmu_probe_pmu(struct arm_pmu *cpu_pmu)
> @@ -1254,7 +1361,15 @@ static int armv8pmu_probe_pmu(struct arm_pmu *cpu_pmu)
>   	if (ret)
>   		return ret;
>   
> -	return probe.present ? 0 : -ENODEV;
> +	if (!probe.present)
> +		return -ENODEV;
> +
> +	if (brbe_num_branch_records(cpu_pmu)) {
> +		ret = branch_records_alloc(cpu_pmu);
> +		if (ret)
> +			return ret;
> +	}
> +	return 0;
>   }
>   
>   static void armv8pmu_disable_user_access_ipi(void *unused)
> @@ -1313,6 +1428,8 @@ static int armv8_pmu_init(struct arm_pmu *cpu_pmu, char *name,
>   	cpu_pmu->set_event_filter	= armv8pmu_set_event_filter;
>   
>   	cpu_pmu->pmu.event_idx		= armv8pmu_user_event_idx;
> +	if (brbe_num_branch_records(cpu_pmu))
> +		cpu_pmu->pmu.sched_task		= armv8pmu_sched_task;
>   
>   	cpu_pmu->name			= name;
>   	cpu_pmu->map_event		= map_event;
> diff --git a/include/linux/perf/arm_pmu.h b/include/linux/perf/arm_pmu.h
> index 6dc5e0cd76ca..93c9a26492fc 100644
> --- a/include/linux/perf/arm_pmu.h
> +++ b/include/linux/perf/arm_pmu.h
> @@ -70,6 +70,11 @@ struct pmu_hw_events {
>   	struct arm_pmu		*percpu_pmu;
>   
>   	int irq;
> +
> +	struct perf_branch_stack	*branch_stack;
> +
> +	/* Active events requesting branch records */
> +	unsigned int		branch_users;
>   };
>   
>   enum armpmu_attr_groups {
> @@ -115,6 +120,7 @@ struct arm_pmu {
>   	/* PMUv3 only */
>   	int		pmuver;
>   	u64		reg_pmmir;
> +	u64		reg_brbidr;
>   #define ARMV8_PMUV3_MAX_COMMON_EVENTS		0x40
>   	DECLARE_BITMAP(pmceid_bitmap, ARMV8_PMUV3_MAX_COMMON_EVENTS);
>   #define ARMV8_PMUV3_EXT_COMMON_EVENT_BASE	0x4000
> @@ -126,6 +132,8 @@ struct arm_pmu {
>   
>   #define to_arm_pmu(p) (container_of(p, struct arm_pmu, pmu))
>   
> +DECLARE_PER_CPU(struct arm_pmu *, cpu_armpmu);
> +
>   u64 armpmu_event_update(struct perf_event *event);
>   
>   int armpmu_event_set_period(struct perf_event *event);
>


tested-by: Adam Young<admiyo@os.amperecomputing.com>

Built and run on a BRBE capable machine.
Built userland perf tool.  With these, I can build the bubble sort 
program posted  here:

https://gcc.gnu.org/wiki/AutoFDO/Tutorial

and run

perf record --branch-filter any,save_type,u ./sort


And will generate a perf.data file.
The mechanism applies cleanly and produced what looks like sane output.

Using autofdo to convert to a gcov format created a file that could be 
included in a gcc build as profiling data.

~/autofdo/build/create_gcov --binary ./sort --profile ./perf.data

produces fbdata.afdo which can be used to make a profiled build.

gcc -O3 sort.c -o sort_fdo_ified -fprofile-use=fbdata.afdo




