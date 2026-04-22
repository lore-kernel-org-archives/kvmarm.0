Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11021101.outbound.protection.outlook.com [52.101.57.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E50131E82E
	for <kvmarm@lists.linux.dev>; Wed, 22 Apr 2026 14:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.57.101
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776869891; cv=fail; b=sXpep5ExpwUTf7bG2GDky3yVBJk2gprMKlk+k+u8pIqVx8nVBWGVgp3aBrjhphVHtVqY4t7JPJkrI1/BELje7JoA5bW6D5ly5sXFcn47a07+iU2VlAJaSeTwdIMUOrRWgJo/bsnTGOTefUeuAF3peTXrQtSA/yxp4e+O3dWINoA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776869891; c=relaxed/simple;
	bh=kpSvEgstaLh1fQzZE0GQTYyJ0nZIbG783LxtMc7q0aQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=BsVcpbBKT5ZbvpWHKuqbuk79gKOW9hKJZhlkj7Dkqj2A8q7j7rXdgI9UflntWgBo1x9kcjdvAvxyqjnAyMEnfxx6Byz9zhJpGIDthalttlnt42LsPGTKWVy0hEdXZ1td/YxMBgzH1zOLk+zUZ7rmbieL0eMsby8051PjDyyC5k4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com; spf=pass smtp.mailfrom=os.amperecomputing.com; dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b=rjElNcCT; arc=fail smtp.client-ip=52.101.57.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b="rjElNcCT"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GQlvvpdUirKjzFy4lR070aFEPr25hspFGQgPlUmOnDubdN17iKnN4d01vdVO63KTg4nqLLlnWKDkDWfyeQJSaZu2Lvqc8AOU3weG7Tv/xz/t5Bh4Dbth+ZU4DhOOozUJl2dYXinjFfTj4n3LSHjJt6781K0NcnerCpzRfd1VaUVUeBpwuVj68yUVZmXwc+IG4IS4zL/f0AC565BXihS6oUr7pNRCNppjJmtZQYrp2Xzkx1f+z+Q8SAAJ2C8WNXcEjL5yudjhlaAuEelLE2yFQ0zK+JMoLiDmWSgrHqdSSbziu6blaoWNkcDztSigNcB4r7N1Ws7er1ZG1V+Os9a6GA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9ifBygjbj6UPKcQL+joaZ7cqiOIzNm1n3V0ljRxExjg=;
 b=PIcRlJsr4hoE857S0C3ATQENA3KPJccuECY8uum1Nc7HG6SmqO8Y8LpEodbCDZLA8o0foENK8CRfyLqDPUUdYlxjnK73g5Mp+1/5R9RnuAN5VCNMf5J4a+4EQw+kr/XPRxcvhUfDcRVjHTI2Ubq60vo1TyqM351pmbSWtIp961FWaSJbpN6dGX/XQIAgLbA4z+k7/nuTfFcM6xiTIkSvxINKf/GKsuNaZirHMZZGUd56MoAxluvf/ZFFMF7n5oKIm6QfBH0GUtwE3pNFwKgZQ+xQY7lw7n2iUlWhLnvoG5pve+8R5MPqepub6vqB95zH5ZF/Qm9q+GmE4bIiCGyI0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9ifBygjbj6UPKcQL+joaZ7cqiOIzNm1n3V0ljRxExjg=;
 b=rjElNcCTtW9TDrsKMKiCz6pFTBAhLlaI8+fCluG8W8VV4r1ANcOkBQgV0yVL1gdTm+6hlvPmBtn7GqKforWbLBdNHWCh1SIQ4DJtEmS9Q3tLwzDGLOjoc4xX58t8/Dy81PrLdd+6wS0ZUhA8FKOdAip48SM8UKy/z+CLYP0tOMs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from DM8PR01MB7142.prod.exchangelabs.com (2603:10b6:8:1::11) by
 DS0PR01MB7961.prod.exchangelabs.com (2603:10b6:8:142::8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9846.18; Wed, 22 Apr 2026 14:58:04 +0000
Received: from DM8PR01MB7142.prod.exchangelabs.com
 ([fe80::11b:da91:4857:6dda]) by DM8PR01MB7142.prod.exchangelabs.com
 ([fe80::11b:da91:4857:6dda%4]) with mapi id 15.20.9846.019; Wed, 22 Apr 2026
 14:58:03 +0000
Message-ID: <e283e755-c348-43cf-b5fe-278c5eab742d@os.amperecomputing.com>
Date: Wed, 22 Apr 2026 20:27:44 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 35/49] KVM: arm64: GICv3: nv: Plug L1 LR sync into
 deactivation primitive
To: Marc Zyngier <maz@kernel.org>
Cc: Fuad Tabba <tabba@google.com>, Joey Gouly <joey.gouly@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>,
 Zenghui Yu <yuzenghui@huawei.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Mark Brown
 <broonie@kernel.org>, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 Darren Hart <darren@os.amperecomputing.com>
References: <20251120172540.2267180-1-maz@kernel.org>
 <20251120172540.2267180-36-maz@kernel.org>
 <2e12c5c2-a1b6-47b7-b54c-7281a77bbe0a@os.amperecomputing.com>
 <878qb9cxzr.wl-maz@kernel.org>
 <1e050b67-2276-41ad-9265-796ba853dc7c@os.amperecomputing.com>
 <86a4vo49ni.wl-maz@kernel.org> <86eck71o1v.wl-maz@kernel.org>
Content-Language: en-US
From: Vishnu Pajjuri <vishnu@os.amperecomputing.com>
In-Reply-To: <86eck71o1v.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA5PR01CA0213.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:1b0::13) To DM8PR01MB7142.prod.exchangelabs.com
 (2603:10b6:8:1::11)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM8PR01MB7142:EE_|DS0PR01MB7961:EE_
X-MS-Office365-Filtering-Correlation-Id: 6eaf0d56-e21c-477e-6260-08dea07f8de9
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|55112099003|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	exlJzS6KGyAnQ0aDWpaNzgrul8WqKGE76m0lRX7Oj4ShJCOZuj3EMPh2Mbn/fqm+txLTsAMYsGH2Lm/H8xlcU6HxJh0rvfQTbNJ16aBFq9I0n7OlbugnzmwS+RKW53p6r0alI4spihnIO1XNzClROV6AxFCB50gDmqJVA4x0xKVd6Qytrqt8L0oAFvqCbSGP7zzI56MdTWQ2yDaBgpH/v+a468ou5Fpd4uWzXYjMNTvp9CEKM3hWN47Fpkt1oFAsom4YaP/uqay5sI+t8PmBMBDSXuoywhp66nzP25Ldwh7fPS0LzpLdc3GXMw9oTvn8h4nSg43XfdQe4F0iZlTjNMmdcRv/UPY16mT6LQbhU98Xi10P//gHqZD5FcH1v/M0wLvcJezEuMQ0wYqJBxkTf788ey95mvA0oBH8ys+CBGB7RyVzIn6uf8W4nsA/JJ+Ywq2w3oVe0YlwVmPGLMdgYMIn+0hr39culSD+LbkIuq8f2A21b+7og3HbrJJ0HeJdj3oZAKu186gYxp0QvhZopC5kSBdBzX0GImTgyWGTwcx5/D2BmIbGWHooWgb6/Z4Tu4eSFw0DmKhqVn5S+geVqipz8e3BvR4mzvnX18Y1DiHZCgB25IMrKn9d5KqPY7ROkIsgBmp/+mdiR2aA9r3QaXcwfSd6orURsat2V3x/xiJPvXHVmFeArNrjaQVT4AesHwc2TBQQVsr3h4fqKJQ86OQ8POFxTRMxV98mG2vVx7Y=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR01MB7142.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(55112099003)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?d053Wmh1akthNTRqdTFnb3o1em9xaXNqZEwvRm9jWkZSWEZkbHVWa2FoM1lQ?=
 =?utf-8?B?dlM3ZDRYU25HOEFBNUVuWkRMUUFCRTdSNE5YUGtrc3ZuNUNKS3hIL1JsSllq?=
 =?utf-8?B?RmE4aTBuRzZvblVoZ2VqcW9QcXQzV3g2TkV5NGZSTzI4Ni9KaERLbDNPSWNI?=
 =?utf-8?B?Z054bDN3dHJpbEJDeURjcy9rZDdRMlJKSjdGMTFXelpCbkVOZ0I4VHduclJt?=
 =?utf-8?B?Yno4TzV5SFVoNXlMTjQ1YTZ0bGVTNk80bkpveVFSRzVldzBNUU5tb3lWemJI?=
 =?utf-8?B?cElWV2xoRnNZNlRNRy91b0dkTkxablIzdXpNOFBkYmFEeTFOallOS0Q1Rm90?=
 =?utf-8?B?QVlwLzAwV3ptU3VCejVuMnlrOTFIQmIzczJ6QWhjcVdJeWJ0Yy9vYnhNdGla?=
 =?utf-8?B?UnczU3JObk1OTkdMbXdobGJUSm1wc2ErTDc2bEpYUTlWVzhmYWtCdlM3b1pM?=
 =?utf-8?B?MmIySDFjbXd2WjdZSGlVc3NXNTE4L2lLcHpCYWE4OXI2QW55aUlGYStPNHRN?=
 =?utf-8?B?Um4zSFVHZ0kwaHF6QWtaY1ZTb2c0YWtJZS8wQ2poM3J3aW53Y3VvWUxlRE1v?=
 =?utf-8?B?T09XaUdhNmtyR3FHbzZoZk5pRzNwSmRhNXF5UGtpc1pCMUw5aWJ2VUFUK2JR?=
 =?utf-8?B?bmttbFB5OHZhZVpKY0lJRmV2SURkNWVEaUJYNkY0WUdMMWtuWUpNMGdCOCtE?=
 =?utf-8?B?TWhmRkZNYVBIRVVFWmQ5elRtdURNb3dnUEEwdWxna3VEMWMxcG03MkdvWDFL?=
 =?utf-8?B?K1ArKzRpMFdySVdFS0oyaUlNTmU1SXFKa2R6ZGNxUUVrM2dYb3Q5VDl3QkZo?=
 =?utf-8?B?Mko2TE9BZmEyd05LZGQwMmZKWXU5R0c5R3JVaUFUNXRQM3ZDMU5kTDNoaVc0?=
 =?utf-8?B?cXNYVUdkdzdGU04rR2x1bVJwZ0VjbEVoNFZ4VVVtZk9SV0lpcUNmaHh3eVdi?=
 =?utf-8?B?TExTSU5ZSms1eEtNelhOSTNydWRpQVg3SHlva1ZwOUdobDAwWWlydCtkdlJL?=
 =?utf-8?B?MFNabWhxR1V3UE1VdkUyRFBtSDRoSnZNYnI3V1RvdEpHczV5d1FoUEpmdldQ?=
 =?utf-8?B?UHJoSTB2MldrT21OQXdTTE85RDZDQmpsQjM4ak55OEk4RHFGQ0MweStwWXhW?=
 =?utf-8?B?TGxEZ0lQZEdlMjd2NjNiQnpCcjFjbWkzTmJzRlFCTWcyeXNVWm1UUnU5RlZq?=
 =?utf-8?B?M3I0bkJ0Y3U3TGRyV3hOOW9ld1BEWFdpdFFtUzhyczllZTdzWTlTcnZpZDhB?=
 =?utf-8?B?RSt2V1ZSTmhhS0srYVE0RlJrUXNFb0lZU3BacEVUaWpKa1hDeXhuQWZHVXJX?=
 =?utf-8?B?a1Z2Y1lGdThaK0ZMMENQNkpHd3psMGNBRlNGWG9qV2IyTHVubXlsWDRmVTdm?=
 =?utf-8?B?ZmRNZVRLTTBOQ3FYNDUxV0dGZFlrOXlRZWs3VXZJaGI5eW42R2J1T01STzYv?=
 =?utf-8?B?OS9kd0VMSjBRTEV5UllhV2hrQ1JaYWRqVWd3dmVTbzVXMWJ6RTJLUHBITEtW?=
 =?utf-8?B?NGF2Vko1MXRIa2ZkN1I4Z1ZHdW10d2dwdy9nNEgwdlM2d3pnS3BRYTYzSm54?=
 =?utf-8?B?RU15bjlDZk8raFUzZmN5TFhjbG4yNXkvWmhuRkwvNjdwQXQrU3Axdi9RT1pt?=
 =?utf-8?B?VHI3RWhLS04vWERlZEMveUY1ZG4rTWVwWkxQTWE4anE2VlF4UVVoWkxtWExC?=
 =?utf-8?B?cm1nay81L3doNFZaQlkvTldYc1dwT2h0cDQrWndPWTFSY3VTemh4c05YeEFI?=
 =?utf-8?B?ZDJHSyt6Z1VUdkxGdGJ4VUdhckQvZVJoNE5pZGlXODRkODduUWkvcGZyb2J2?=
 =?utf-8?B?WElQS0t2OElDZlErUExmN2RRcCswbVhQSGpEaFFrNFdCMFZLMzhSNmlTMVBx?=
 =?utf-8?B?NzZSV0tPbDVGVXBjN1N0dk1EaktPZWc1UkxqU0s5YVRZTW9DQS9DOGduTWlT?=
 =?utf-8?B?aXJKZFRDOTdwL1lXc1RZUjVqdk5mb2RSaEVzeXJwRm9NOTR4Tno3cFlFb0FC?=
 =?utf-8?B?a1JUSjYyZ1NnK2R5SjFPejd4ZzZIOXNBYTU0U252OUw3VDg0NUh0Nkw1dGxj?=
 =?utf-8?B?c3NoTUpFWDIxbXR6TFN2eEZaMVhHYmk1UTNJYXNjbHAxVURUZlk4MnZrN0Vp?=
 =?utf-8?B?bm94b1lpOVFjbW5GVGpDY3ZkalA2NnZINVloS3dpQXlnNUo1UkhYWTNWTFlU?=
 =?utf-8?B?eDdlZU9GVmZQMkZSWFVCdk9oaktzYTI2c1F1UW9RZTJCY2VaT2VQVTlnbmU1?=
 =?utf-8?B?OHlHbFJTZlZOdzE2WHBaZVloUkFKdTVHN2NyT2VVa2hkQjM5UFF6bWdYWmxu?=
 =?utf-8?B?elpZYmtmcks1eWhJZk1pcHBTWHQ3OTZ2bklOa3ozQzIzcnNvVGcvSVNrcGls?=
 =?utf-8?Q?BNW8Fjv00I1Xi3myUNWwtQAz7IKPZYsnUOxwq?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6eaf0d56-e21c-477e-6260-08dea07f8de9
X-MS-Exchange-CrossTenant-AuthSource: DM8PR01MB7142.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2026 14:58:03.8174
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wgnfWT9rA8gqULAmx4327UXk9gU5lCXgsYXh7ALHLYDNyGRAIabHA9En3u3vBfDvAzEoK3bTwZLBUjMeKXkuyU+1ocOJF60wn1lcRhpShjxjY4862UCxUnfPRUl/D9oG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR01MB7961

Hi Marc,

On 22-04-2026 12:25, Marc Zyngier wrote:
> [+ Darren]
> 
> On Tue, 31 Mar 2026 10:42:57 +0100,
> Marc Zyngier <maz@kernel.org> wrote:
>>
>> On Tue, 31 Mar 2026 07:31:54 +0100,
>> Vishnu Pajjuri <vishnu@os.amperecomputing.com> wrote:
>>>
>>>>> LOG:
>>>>> [  164.647367] Call trace:
>>>>> [  164.647368]  smp_call_function_many_cond+0x334/0x7a0 (P)
>>>>> [  164.647372]  smp_call_function_many+0x20/0x40
>>>>> [  164.647374]  kvm_make_all_cpus_request+0xec/0x1b8
>>>>> [  164.647377]  vgic_queue_irq_unlock+0x1c8/0x2c8
>>>>> [  164.647380]  kvm_vgic_inject_irq+0x194/0x1e0
>>>>> [  164.647381]  kvm_vm_ioctl_irq_line+0x170/0x400
>>>>> [  164.647386]  kvm_vm_ioctl+0x7b8/0xc88
>>>>> [  164.647389]  __arm64_sys_ioctl+0xb4/0x118
>>>>> [  164.647393]  invoke_syscall+0x6c/0x100
>>>>> [  164.647397]  el0_svc_common.constprop.0+0x48/0xf0
>>>>> [  164.647398]  do_el0_svc+0x24/0x38
>>>>> [  164.647400]  el0_svc+0x3c/0x170
>>>>> [  164.647403]  el0t_64_sync_handler+0xa0/0xe8
>>>>> [  164.647405]  el0t_64_sync+0x1b0/0x1b8
>>>>
>>>> This trace is about interrupt injection from userspace, not
>>>> deactivation of a HW interrupt.
>>>> None of that makes much sense.
>>>
>>> Although this behavior is puzzling, it matches the trace I typically
>>> observe on L0. After reverting the patch, I was able to boot L2 guests
>>> successfully.
>>
>> Well, this patch fixes real bugs, so it isn't going anywhere.
>>
>> The patch you are reverting addresses the deactivation of a HW
>> interrupt, which is likely to be a timer (that's the only one we
>> support). The stacktrace points to the userspace injection of an SPI.
>>
>> If we need to broadcast IPI, that's because there is no other SPI
>> currently in flight. But if a CPU is not responding to the IPI, what
>> is it doing? How does this interact with the patch you are reverting?
>>
>> Given that I don't know what you're running, how you are running it,
>> that I don't have access to whatever HW you are using, and that you
>> are providing no useful information that'd help me debug this, I will
>> leave it up to you to debug it and come back with a detailed analysis
>> of the problem.
> 
> Have you made progress on this? I can't reproduce it at all despite my
> best effort. I'm perfectly happy to help, but you need to give me
> *something* to go on.


Thanks for your support!!

The issue is triggered as soon as the timer interrupt (IRQ 27) is 
deactivated. Preventing the deactivation of IRQ 27 during nested VGIC 
state transitions prevents the failure from reproducing.

I am currently tracing execution paths and inspecting VGIC state to 
determine how disabling this interrupt leads to the observed behavior.

Regards,
-Vishnu.
> Thanks,
> 
> 	M.
> 

