Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11021113.outbound.protection.outlook.com [40.107.208.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BAE83ACEF5
	for <kvmarm@lists.linux.dev>; Wed, 25 Feb 2026 11:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.113
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772020770; cv=fail; b=a4qtMvHrqHz7YvMIm8H8QRyZ76RCvM7Hdw8yJydz1Pv/op/+W8acNnnGwppTLxGiltn7VBMOvUo/4bdDGUaqjJsOIPEPxQ++iXToDVBFLbQpva/GrN10HqXizlYwesp1EaBFVC7OkH5KwLvDSygm4izbD++gK52vaneTxrRZZHs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772020770; c=relaxed/simple;
	bh=yqu9mVbK5KrPyH6KGBZeL8OUcI++2tdp2AwTw+vYLFI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=jq8h8w+GwHnIDJkVahGfzvrzcj9YC1zPmAGXHq8lTUfxklEDSIdf2Opj+nEfN1TX/Cm9UA7+dbfbHqq++9DqXZw6xuU3nciJ5E+03braCvw+klANqRgeQnFihi4SUo1iHoKm7LablL2ZqnlSsPQwyW/eET3Dj8qW6fzO5qbWMOE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com; spf=pass smtp.mailfrom=os.amperecomputing.com; dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b=tlHdO7kJ; arc=fail smtp.client-ip=40.107.208.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b="tlHdO7kJ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wdab2Qf4NSeFKsk7KzstPwxgY5yduDfnZNKdocii/BcfqeeDcbELdcohw/Q1QO/xtaSl6NSKy7sW+C9Ew//edkFehtwxMj3qQrcqEOws6LAkeO/BnSsKvM81DZ4FvkBu86ZdTtFuxqC/+ITH1rOwolI8Meq+ibTztK0p0Drmcjk7KOh9MXirlRb6Ky36bUjNPJ4uXQ7TDo2UP55QyYRrxx1e7m9ok5kF3vEGpNIgAXM9+YgZUBKRPgBxe6wHLXNjVLVOrb8/beeIPGMwNLn3I2L/c83ZZwycghsjhcN7LyTfRp8QqhRTlCehAxQdXZ9NVTyOZuztEobeUKk4OCeWGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qcutlck2gvm7xEeGgZ4OYGc4ru0UO2KnL4MWbhHSrjc=;
 b=Rtkg1RDzvh7zFDfRYl7zsMjq6g8O+TTOgXLhxsmXOSFGkPgWtLtL3tu8QMBYAqldzoNn8mqfzHJcjdHAqud/TG5W4KXTvbX0UDUKWVc17FtHmvO1DcqSygmqvBW/K2Y9tHCIJLy0TX4Yz+rWabFhHQ0SS/J8kLHDFc1eGLZdPcF3yrgDt1IISxCOyKOn76+yFFyq84VKCFyjGp34DJBO6mrB8fMMs7bh7SeB2YK83pchrCeemXYZN2xPZTSPu4x6aC4vE9GAA8NcfsMTu/AzyoYWJ4wQT2jBexnSZg6HARtGmEucf8DJKoCv+qTajZHRkXnkvvoUmg7bcbWhpRFI9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qcutlck2gvm7xEeGgZ4OYGc4ru0UO2KnL4MWbhHSrjc=;
 b=tlHdO7kJXn+FChw9TvKV72IZJ8huzACEkC5rK4WPdXjBIxHXcoIyp0x9Nyio7grB4smT/of6CnmJb69TjkjLLV4osLnx5s9eNQBT59TjqAcxjFy9hYWeab3hDFqLeR8rv9Ke67cCLyOcXUctaO99hekymtBrx90ke52AP8jU7sI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from DM8PR01MB7142.prod.exchangelabs.com (2603:10b6:8:1::11) by
 DS9PR01MB994463.prod.exchangelabs.com (2603:10b6:8:35d::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.22; Wed, 25 Feb 2026 11:59:25 +0000
Received: from DM8PR01MB7142.prod.exchangelabs.com
 ([fe80::11b:da91:4857:6dda]) by DM8PR01MB7142.prod.exchangelabs.com
 ([fe80::11b:da91:4857:6dda%6]) with mapi id 15.20.9654.007; Wed, 25 Feb 2026
 11:59:25 +0000
Message-ID: <ce2551b6-a2fd-43b8-9da0-4f6c82af991e@os.amperecomputing.com>
Date: Wed, 25 Feb 2026 17:29:05 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] KVM: arm64: nv: Optimize unmapping of shadow S2-MMU
 tables
To: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 linux-kernel@vger.kernel.org, oliver.upton@linux.dev, will@kernel.org,
 catalin.marinas@arm.com, suzuki.poulose@arm.com, joey.gouly@arm.com,
 yuzenghui@huawei.com, darren@os.amperecomputing.com, cl@gentwo.org,
 scott@os.amperecomputing.com, gklkml16@gmail.com
References: <20251013065125.767779-1-gankulkarni@os.amperecomputing.com>
 <0345c510-5db4-462f-95fb-591e71468aca@os.amperecomputing.com>
 <87v7k53cud.wl-maz@kernel.org>
 <060fe820-85b8-4476-be95-a0d37e53fa12@os.amperecomputing.com>
 <86wm4fus4n.wl-maz@kernel.org>
 <8c5c236c-8753-4738-96ce-e51c9465eeb3@os.amperecomputing.com>
Content-Language: en-US
From: Vishnu Pajjuri <vishnu@os.amperecomputing.com>
In-Reply-To: <8c5c236c-8753-4738-96ce-e51c9465eeb3@os.amperecomputing.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MA0P287CA0006.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a01:d9::12) To DM8PR01MB7142.prod.exchangelabs.com
 (2603:10b6:8:1::11)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM8PR01MB7142:EE_|DS9PR01MB994463:EE_
X-MS-Office365-Filtering-Correlation-Id: f007f571-d653-4df9-f4a3-08de746551bb
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	AFMusuL/5rONJwWa7nzaVnsU0um2RULR9b6c0NtxzkIzo0dgMoY+ADZ5y3U+nHrk5fKh2tII9g5jr6S4Ngr62FcEN+cKEevnhHvSBykRXuup0f1dpx5b9G021WyqF5neqskPFTzI755TurgfJK7CpSWjZ71s3iI0tjf59OTf7T62vLpsaPFMD4/bLjuYAB3AEOMpoYOcXjNSGodqpsKIweJmXx+THKn8LE0QkVhyecr6QidFGRRKzt7JTA0gKmLmmJadQE3EsqGNIxq9EWPUv48geayP/23w+JMpdqokVu6xYlcY58m6RoNcRmpBc6siH1Etp+yfQRfgr8v2BDkqEBEjAkAdjBBxMizRhG2HmqGB/hUE1a8kronKnB/J2eDaddT7C9c5wtx4ennYYvzZEyV2EX/xXM6e/VERcgOq+T5VNbX5a4h9HPN0I4EJGz/HiWXUBMmsWSgooClFr/RI6A/e3/gJtrITcQ+W6aEcWGERn5upOvsyAGdCNhQt6qGPxDIf9sGamd79Gg5Qcy/BCHpRRPYE0Yl3LHV9PIC7Xs/n+TFcmqIUevbxybsoICPw+nUkOhp/RUuebCtWC/QY6c+OkoUuorSRlx9xcdMZ3PXInGkR8ZFiLxocyT5RJiuMEsuUSbHMiN+fhovu2kbojE1SNz1AALYtvGAKcZ+qWy4Q2AuxhWfSe1HfLe6Aw9EaIXR8GAHRNPv2MmoI77QeZTZIEoVSCTnOG1brZeQOWjE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR01MB7142.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?azAyRGI4czJSRHdrdTg1cmdzL0NpcUFMbEJqYWYvODM5QjRGY3kyRFBqZ0Rs?=
 =?utf-8?B?TWVWcGczTjRCRXB6KzlHUnM0RzZ5UklUV01oQ3EvTlV3bjRRZWNURk1PVGFa?=
 =?utf-8?B?WFJ5MFZKakIxVUJ6VG9IdngwZHhKWW1DS244emswYTYwQzVpVHoxUVV0QVl2?=
 =?utf-8?B?MlNOcXp1UEFkNkQraXU4S2N2NjRacXNZK2YvU2Vncjc4dkk1UC9rRDRMUHRR?=
 =?utf-8?B?aytWYTBsOEt5ckxqRnhkeU1IMDRGM3JiQkhDKytGQ1FXT2laTWpFdGFQRGk1?=
 =?utf-8?B?bCtyalY2VE5XWlhRS1lGU0pPM0JGeW10Y2xoZUVleU9lZi9SdWFIQU9wWFFP?=
 =?utf-8?B?elo3OHZhMUFRZ1Nud0JlYkovZXpsOGplVnE0OUhyYmoxRnkxQnMwVVZndWhi?=
 =?utf-8?B?QmlNbDFiSWQ0RlVaMU8xaytaeC9hSm9rNy9uNmRXbkdLTWx5ZnBLanBMeW9T?=
 =?utf-8?B?NitzMnJXR01rcitKSUJpTktoQ1BMZUZYWm9tOVM3NjJwSGIzM2FhVXowMGt1?=
 =?utf-8?B?WXpnakJON2hCS1FZRzhSZlVNRE91dGVwaFRUdUxrYWtzeGpsaUlySFNEalBr?=
 =?utf-8?B?Q0FROWo0MlBpMVJWanRSTzkyTm5aWDhLOEhQWnpFYm1pK0svQmxJYzFOT0ZS?=
 =?utf-8?B?SG5TS1VsODlrdTVlMnNzc2FHc2lubFZzcDZQOU9aTytkWVZvWjRPZzJEL0FI?=
 =?utf-8?B?bEJHWXE3K1NUWTJkTjJjenczVndZYnVFUU9zdnhOZXYycEkrdFZjRkZNR1Jh?=
 =?utf-8?B?cnVjTlFneTFjTS9WQUhMOW1UaW1MZTNNRmR1TXU3L2JjSUlSYlVrQjlWWlp6?=
 =?utf-8?B?UTRkMnB3MUFGanRpZ1UvcGdVcTBwR1Q0T1paRHNFckZJWDRWemxKc29LRHU0?=
 =?utf-8?B?SWJMeTJUd3VsSjNaTmRLWXhSeEw4U3NwSFlMU1hOWFlVTmhBY1g2VDhhOVNX?=
 =?utf-8?B?S0hiU3Q2NjNqaXJLRWI1NWFqOVV0QTAzR3l0dmhJZjIxeDdheW9tamduZTNL?=
 =?utf-8?B?bFltb2U5RFA1UUNzeUoraWE5QVFsR25Zb0VsYnMyVS96aTVRYi9TVjhmZUdq?=
 =?utf-8?B?ekRNYTVyaElmMjRybFRUOGZ2aHYwSXBDMDdWQUNZWXJSRjA2bkFySi9WSmRa?=
 =?utf-8?B?OWoyZ203THVWUndaNUYxR21ObEdPZHV6L0VnY2VDNXlPRTB6cGIyQkU2NWZL?=
 =?utf-8?B?eHJkUUpSeDUzdUNqVEtFY09oSlkwaHJjbHhRYkgxTE1BdC9VKzA1L212WlAx?=
 =?utf-8?B?bFlxMzFtdDV3Vk1BWlV6NVl0TUtGSWNSVUJka0QzL3RwOW8zMEZyOE1NNzJx?=
 =?utf-8?B?V3M2NVpMUTRVV0ZFQUx5S3Fob2psajM3OHJCclAwQ3dhWW9HM1lKWEtaQlZT?=
 =?utf-8?B?QXhUc3lRdm1oYTdjU3JjSTF0ZnprbE0vS0ZiNytvM1dXaStkSnZObG1jVndZ?=
 =?utf-8?B?WWxkUEJTeEpuTGJsV3VJVkFGS0p6d1V6RnhoaHJqUUUxOEcwdWxzTzRLOVdh?=
 =?utf-8?B?Y01QcE1FQTNsbGp4UDFDOEVyTmF6bStocmJDdjRqS1AxcTNBWFhjcWVSVWxx?=
 =?utf-8?B?c0xQenE1ZmRGM3I4cHZvWUFUWVlESjlLVjJDTXJNeGdkRlNQUnNmMFovQ1hr?=
 =?utf-8?B?LzdjWk9Dd0hJUmZtRVJCUjV0cFRVaUpKcURueTZJci81cjVKc09wZG5ndDRi?=
 =?utf-8?B?ZWVqcFVBZXRLaTJwM3h3S2pQVk5JN1plelRaT1hLVHVkaWIrcWpSWlowdmox?=
 =?utf-8?B?eEZNc0R4Wi8zZzk0LzQySEN0bTZUczlUT2FCelhNS3hkK3BNQkplRDdiSWwy?=
 =?utf-8?B?Z3FyTHZyZmxXK3lkdU5MYW5GTStEUXVvaVVLb0lMWXhIWTE5UXBmR1JKVFg1?=
 =?utf-8?B?UHMvMXJ1R3VPbEJjM0RqNnZhMk5iN2NzcEk1S0dlbkluQ0NieHNib1hvOElz?=
 =?utf-8?B?NWNJTk42NG5CYnRhR21aOEFjQnJsL1NhSFUzaXJiN2hLWXluTnRNUzRLUk1Q?=
 =?utf-8?B?NG03OTJCdWliL3EwNGllZklvbFFpUmVFZUtSZVVNZXd4QjJIQUlFVmVncFBr?=
 =?utf-8?B?OVV3YTNDTWxSU1VNcWRpd0s3RStCZzhGZE5TREtxWWUxUG1qUUJkNzhwaExF?=
 =?utf-8?B?dWEvRUVzUXRDeWc1VU5RUDUvVWxzQU04RUdhcXJzSm5mV0drYTNBZ1FJMDlX?=
 =?utf-8?B?NUhQVTB2UWhDOXgvZGZMeGNjTnEyU1hDM2JORTJiV0UrN3VhMWMvSEZ4OE83?=
 =?utf-8?B?UDhpajV5NXk1WFA4VHFlTkI1dXdvY0NZOUJUeFBHYTJrbHZJMkhBNnpjYnJP?=
 =?utf-8?B?TE5BUVF3MVhFRlJHR29mOVRJOWM1citYOGM1Myt6WTRWV1lFbjFuVFE3MnJT?=
 =?utf-8?Q?aK2QInzT4yEWiGW3wIKMjlYZhWojz0GyvJ++n?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f007f571-d653-4df9-f4a3-08de746551bb
X-MS-Exchange-CrossTenant-AuthSource: DM8PR01MB7142.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 11:59:25.1641
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cuG9ihA5ZDO5PUw6KA0+94wND38DkMc46ZRLOf9Og6D8+zVMNXzn54gUOuCZo76mKtIMJ1DhTqYSnFqF6hkLNaBg/s4Qpnxt8TLUIHpIRl52/ana4wqSEisddCBP9XEY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS9PR01MB994463

Hi Marc,

On 24-11-2025 16:33, Ganapatrao Kulkarni wrote:
> On 10/28/2025 5:59 PM, Marc Zyngier wrote:
>> On Tue, 28 Oct 2025 06:02:03 +0000,
>> Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com> wrote:
>>>
>>> On 10/23/2025 8:05 PM, Marc Zyngier wrote:
>>>> On Thu, 23 Oct 2025 12:11:42 +0100,
>>>> Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com> wrote:
>>>>>
>>>>>
>>>>> Hi Marc, Oliver,
>>>>>
>>>>> On 10/13/2025 12:21 PM, Ganapatrao Kulkarni wrote:
>>>>>> As of commit ec14c272408a ("KVM: arm64: nv: Unmap/flush shadow
>>>>>> stage 2 page tables"), an unmap of a canonical IPA range mapped at L1
>>>>>> triggers invalidation in L1 S2-MMU and in all active shadow (L2) 
>>>>>> S2-MMU
>>>>>> tables. Because there is no direct mapping to locate the 
>>>>>> corresponding
>>>>>> shadow IPAs, the code falls back to a full S2-MMU page-table walk and
>>>>>> invalidation across the entire L1 address space.
>>>>>>
>>>>>> For 4K pages this causes roughly 256K loop iterations (about 8M for
>>>>>> 64K pages) per unmap, which can severely impact performance on large
>>>>>> systems and even cause soft lockups during NV (L1/L2) boots with many
>>>>>> CPUs and large memory. It also causes long delays during L1 reboot.
>>>>>>
>>>>>> This patch adds a maple-tree-based lookup that records canonical- 
>>>>>> IPA to
>>>>>> shadow-IPA mappings whenever a page is mapped into any shadow (L2)
>>>>>> table. On unmap, the lookup is used to target only those shadow IPAs
>>>>>> which are fully or partially mapped in shadow S2-MMU tables, avoiding
>>>>>> a full-address-space walk and unnecessary unmap/flush operations.
>>>>>>
>>>>>> The lookup is updated on map/unmap operations so entries remain
>>>>>> consistent with shadow table state. Use it during unmap to invalidate
>>>>>> only affected shadow IPAs, avoiding unnecessary CPU work and reducing
>>>>>> latency when shadow mappings are sparse.
>>>>>>
>>>>>> Reviewed-by: Christoph Lameter (Ampere) <cl@gentwo.org>
>>>>>> Signed-off-by: Ganapatrao Kulkarni 
>>>>>> <gankulkarni@os.amperecomputing.com>
>>>>>> ---
>>>>>>
>>>>>> Changes since v1:
>>>>>>         Rebased to 6.18-rc1.
>>>>>>         Fixed alignment issue while adding the shadow ipa range
>>>>>>         to lookup.
>>>>>>
>>>>>> Changes since RFC v1:
>>>>>>         Added maple tree based lookup and updated with review
>>>>>>         comments from [1].
>>>>>>
>>>>>> [1] https://lkml.indiana.edu/2403.0/03801.html
>>>>>>
>>>>>>     arch/arm64/include/asm/kvm_host.h   |   3 +
>>>>>>     arch/arm64/include/asm/kvm_nested.h |   9 +++
>>>>>>     arch/arm64/kvm/mmu.c                |  17 ++--
>>>>>>     arch/arm64/kvm/nested.c             | 120 ++++++++++++++++++++ 
>>>>>> ++++++--
>>>>>>     4 files changed, 138 insertions(+), 11 deletions(-)
>>>>>>
>>>>>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/ 
>>>>>> include/asm/kvm_host.h
>>>>>> index b763293281c8..e774681c6ba4 100644
>>>>>> --- a/arch/arm64/include/asm/kvm_host.h
>>>>>> +++ b/arch/arm64/include/asm/kvm_host.h
>>>>>> @@ -227,6 +227,9 @@ struct kvm_s2_mmu {
>>>>>>          * >0: Somebody is actively using this.
>>>>>>          */
>>>>>>         atomic_t refcnt;
>>>>>> +
>>>>>> +    /* For IPA to shadow IPA lookup */
>>>>>> +    struct maple_tree nested_mmu_mt;
>>>>>>     };
>>>>>>       struct kvm_arch_memory_slot {
>>>>>> diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/ 
>>>>>> include/asm/kvm_nested.h
>>>>>> index f7c06a840963..5b7c4e7ed18f 100644
>>>>>> --- a/arch/arm64/include/asm/kvm_nested.h
>>>>>> +++ b/arch/arm64/include/asm/kvm_nested.h
>>>>>> @@ -69,6 +69,8 @@ extern void kvm_init_nested(struct kvm *kvm);
>>>>>>     extern int kvm_vcpu_init_nested(struct kvm_vcpu *vcpu);
>>>>>>     extern void kvm_init_nested_s2_mmu(struct kvm_s2_mmu *mmu);
>>>>>>     extern struct kvm_s2_mmu *lookup_s2_mmu(struct kvm_vcpu *vcpu);
>>>>>> +extern int add_to_shadow_ipa_lookup(struct kvm_pgtable *pgt, u64 
>>>>>> shadow_ipa, u64 ipa,
>>>>>> +        u64 size);
>>>>>>       union tlbi_info;
>>>>>>     @@ -95,6 +97,12 @@ struct kvm_s2_trans {
>>>>>>         u64 desc;
>>>>>>     };
>>>>>>     +struct shadow_ipa_map {
>>>>>> +    u64 shadow_ipa;
>>>>>> +    u64 ipa;
>>>>>> +    u64 size;
>>>>>> +};
>>>>>> +
>>>>>>     static inline phys_addr_t kvm_s2_trans_output(struct 
>>>>>> kvm_s2_trans *trans)
>>>>>>     {
>>>>>>         return trans->output;
>>>>>> @@ -132,6 +140,7 @@ extern int kvm_s2_handle_perm_fault(struct 
>>>>>> kvm_vcpu *vcpu,
>>>>>>     extern int kvm_inject_s2_fault(struct kvm_vcpu *vcpu, u64 
>>>>>> esr_el2);
>>>>>>     extern void kvm_nested_s2_wp(struct kvm *kvm);
>>>>>>     extern void kvm_nested_s2_unmap(struct kvm *kvm, bool may_block);
>>>>>> +extern void kvm_nested_s2_unmap_range(struct kvm *kvm, u64 ipa, 
>>>>>> u64 size, bool may_block);
>>>>>>     extern void kvm_nested_s2_flush(struct kvm *kvm);
>>>>>>       unsigned long compute_tlb_inval_range(struct kvm_s2_mmu *mmu,
>>>>>> u64 val);
>>>>>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>>>>>> index 7cc964af8d30..27c120556e1b 100644
>>>>>> --- a/arch/arm64/kvm/mmu.c
>>>>>> +++ b/arch/arm64/kvm/mmu.c
>>>>>> @@ -1872,6 +1872,10 @@ static int user_mem_abort(struct kvm_vcpu 
>>>>>> *vcpu, phys_addr_t fault_ipa,
>>>>>>             ret = KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, 
>>>>>> fault_ipa, vma_pagesize,
>>>>>>                              __pfn_to_phys(pfn), prot,
>>>>>>                              memcache, flags);
>>>>>> +
>>>>>> +        /* Add to lookup, if canonical IPA range mapped to shadow 
>>>>>> mmu */
>>>>>> +        if (nested)
>>>>>> +            add_to_shadow_ipa_lookup(pgt, fault_ipa, ipa, 
>>>>>> vma_pagesize);
>>>>>>         }
>>>>>>       out_unlock:
>>>>>> @@ -2094,14 +2098,15 @@ int kvm_handle_guest_abort(struct kvm_vcpu 
>>>>>> *vcpu)
>>>>>>       bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range
>>>>>> *range)
>>>>>>     {
>>>>>> +    gpa_t start = range->start << PAGE_SHIFT;
>>>>>> +    gpa_t end = (range->end - range->start) << PAGE_SHIFT;
>>>>>> +    bool may_block = range->may_block;
>>>>>> +
>>>>>>         if (!kvm->arch.mmu.pgt)
>>>>>>             return false;
>>>>>>     -    __unmap_stage2_range(&kvm->arch.mmu, range->start <<
>>>>>> PAGE_SHIFT,
>>>>>> -                 (range->end - range->start) << PAGE_SHIFT,
>>>>>> -                 range->may_block);
>>>>>> -
>>>>>> -    kvm_nested_s2_unmap(kvm, range->may_block);
>>>>>> +    __unmap_stage2_range(&kvm->arch.mmu, start, end, may_block);
>>>>>> +    kvm_nested_s2_unmap_range(kvm, start, end, may_block);
>>>>>>         return false;
>>>>>>     }
>>>>>>     @@ -2386,7 +2391,7 @@ void kvm_arch_flush_shadow_memslot(struct
>>>>>> kvm *kvm,
>>>>>>           write_lock(&kvm->mmu_lock);
>>>>>>         kvm_stage2_unmap_range(&kvm->arch.mmu, gpa, size, true);
>>>>>> -    kvm_nested_s2_unmap(kvm, true);
>>>>>> +    kvm_nested_s2_unmap_range(kvm, gpa, size, true);
>>>>>>         write_unlock(&kvm->mmu_lock);
>>>>>>     }
>>>>>>     diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
>>>>>> index 7a045cad6bdf..3a7035e7526a 100644
>>>>>> --- a/arch/arm64/kvm/nested.c
>>>>>> +++ b/arch/arm64/kvm/nested.c
>>>>>> @@ -7,6 +7,7 @@
>>>>>>     #include <linux/bitfield.h>
>>>>>>     #include <linux/kvm.h>
>>>>>>     #include <linux/kvm_host.h>
>>>>>> +#include <linux/maple_tree.h>
>>>>>>       #include <asm/fixmap.h>
>>>>>>     #include <asm/kvm_arm.h>
>>>>>> @@ -725,6 +726,7 @@ void kvm_init_nested_s2_mmu(struct kvm_s2_mmu 
>>>>>> *mmu)
>>>>>>         mmu->tlb_vttbr = VTTBR_CNP_BIT;
>>>>>>         mmu->nested_stage2_enabled = false;
>>>>>>         atomic_set(&mmu->refcnt, 0);
>>>>>> +    mt_init_flags(&mmu->nested_mmu_mt, MM_MT_FLAGS);
>>>>>>     }
>>>>>>       void kvm_vcpu_load_hw_mmu(struct kvm_vcpu *vcpu)
>>>>>> @@ -1067,6 +1069,99 @@ void kvm_nested_s2_wp(struct kvm *kvm)
>>>>>>         kvm_invalidate_vncr_ipa(kvm, 0, BIT(kvm->arch.mmu.pgt- 
>>>>>> >ia_bits));
>>>>>>     }
>>>>>>     +/*
>>>>>> + * Store range of canonical IPA mapped to a nested stage 2 mmu 
>>>>>> table.
>>>>>> + * Canonical IPA used as pivot in maple tree for the lookup later
>>>>>> + * while IPA unmap/flush.
>>>>>> + */
>>>>>> +int add_to_shadow_ipa_lookup(struct kvm_pgtable *pgt, u64 
>>>>>> shadow_ipa,
>>>>>> +        u64 ipa, u64 size)
>>>>>> +{
>>>>>> +    struct kvm_s2_mmu *mmu;
>>>>>> +    struct shadow_ipa_map *entry;
>>>>>> +    unsigned long start, end;
>>>>>> +    int ret;
>>>>>> +
>>>>>> +    start = ALIGN_DOWN(ipa, size);
>>>>>> +    end = start + size;
>>>>>> +    mmu = pgt->mmu;
>>>>>> +
>>>>>> +    entry = kzalloc(sizeof(struct shadow_ipa_map), 
>>>>>> GFP_KERNEL_ACCOUNT);
>>>>>> +
>>>>>> +    if (!entry)
>>>>>> +        return -ENOMEM;
>>>>>> +
>>>>>> +    entry->ipa = start;
>>>>>> +    entry->shadow_ipa = ALIGN_DOWN(shadow_ipa, size);
>>>>>> +    entry->size = size;
>>>>>> +    ret = mtree_store_range(&mmu->nested_mmu_mt, start, end - 1, 
>>>>>> entry,
>>>>>> +              GFP_KERNEL_ACCOUNT);
>>>>>> +    if (ret) {
>>>>>> +        kfree(entry);
>>>>>> +        WARN_ON(ret);
>>>>>> +    }
>>>>>> +
>>>>>> +    return ret;
>>>>>> +}
>>>>>> +
>>>>>> +static void nested_mtree_erase(struct maple_tree *mt, unsigned 
>>>>>> long start,
>>>>>> +        unsigned long size)
>>>>>> +{
>>>>>> +    void *entry = NULL;
>>>>>> +
>>>>>> +    MA_STATE(mas, mt, start, start + size - 1);
>>>>>> +
>>>>>> +    mtree_lock(mt);
>>>>>> +    entry = mas_erase(&mas);
>>>>>> +    mtree_unlock(mt);
>>>>>> +    kfree(entry);
>>>>>> +}
>>>>>> +
>>>>>> +static void nested_mtree_erase_and_unmap_all(struct kvm_s2_mmu *mmu,
>>>>>> +        unsigned long start, unsigned long end, bool may_block)
>>>>>> +{
>>>>>> +    struct shadow_ipa_map *entry;
>>>>>> +
>>>>>> +    mt_for_each(&mmu->nested_mmu_mt, entry, start, 
>>>>>> kvm_phys_size(mmu)) {
>>>>>> +        kvm_stage2_unmap_range(mmu, entry->shadow_ipa, entry->size,
>>>>>> +                may_block);
>>>>>> +        kfree(entry);
>>>>>> +    }
>>>>>> +
>>>>>> +    mtree_destroy(&mmu->nested_mmu_mt);
>>>>>> +    mt_init_flags(&mmu->nested_mmu_mt, MM_MT_FLAGS);
>>>>>> +}
>>>>>> +
>>>>>> +void kvm_nested_s2_unmap_range(struct kvm *kvm, u64 ipa, u64 size,
>>>>>> +        bool may_block)
>>>>>> +{
>>>>>> +    int i;
>>>>>> +    struct shadow_ipa_map *entry;
>>>>>> +
>>>>>> +    lockdep_assert_held_write(&kvm->mmu_lock);
>>>>>> +
>>>>>> +    for (i = 0; i < kvm->arch.nested_mmus_size; i++) {
>>>>>> +        struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
>>>>>> +        unsigned long start = ipa;
>>>>>> +        unsigned long end = ipa + size;
>>>>>> +
>>>>>> +        if (!kvm_s2_mmu_valid(mmu))
>>>>>> +            continue;
>>>>>> +
>>>>>> +        do {
>>>>>> +            entry = mt_find(&mmu->nested_mmu_mt, &start, end - 1);
>>>>>> +            if (!entry)
>>>>>> +                break;
>>>>>> +
>>>>>> +            kvm_stage2_unmap_range(mmu, entry->shadow_ipa,
>>>>>> +                            entry->size, may_block);
>>>>>> +            start = entry->ipa + entry->size;
>>>>>> +            nested_mtree_erase(&mmu->nested_mmu_mt, entry->ipa,
>>>>>> +                            entry->size);
>>>>>> +        } while (start < end);
>>>>>> +    }
>>>>>> +}
>>>>>> +
>>>>>>     void kvm_nested_s2_unmap(struct kvm *kvm, bool may_block)
>>>>>>     {
>>>>>>         int i;
>>>>>> @@ -1076,8 +1171,10 @@ void kvm_nested_s2_unmap(struct kvm *kvm, 
>>>>>> bool may_block)
>>>>>>         for (i = 0; i < kvm->arch.nested_mmus_size; i++) {
>>>>>>             struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
>>>>>>     -        if (kvm_s2_mmu_valid(mmu))
>>>>>> -            kvm_stage2_unmap_range(mmu, 0, kvm_phys_size(mmu), 
>>>>>> may_block);
>>>>>> +        if (!kvm_s2_mmu_valid(mmu))
>>>>>> +            continue;
>>>>>> +
>>>>>> +        nested_mtree_erase_and_unmap_all(mmu, 0, 
>>>>>> kvm_phys_size(mmu), may_block);
>>>>>>         }
>>>>>>           kvm_invalidate_vncr_ipa(kvm, 0,
>>>>>> BIT(kvm->arch.mmu.pgt->ia_bits));
>>>>>> @@ -1091,9 +1188,14 @@ void kvm_nested_s2_flush(struct kvm *kvm)
>>>>>>           for (i = 0; i < kvm->arch.nested_mmus_size; i++) {
>>>>>>             struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
>>>>>> +        struct shadow_ipa_map *entry;
>>>>>> +        unsigned long start = 0;
>>>>>>     -        if (kvm_s2_mmu_valid(mmu))
>>>>>> -            kvm_stage2_flush_range(mmu, 0, kvm_phys_size(mmu));
>>>>>> +        if (!kvm_s2_mmu_valid(mmu))
>>>>>> +            continue;
>>>>>> +
>>>>>> +        mt_for_each(&mmu->nested_mmu_mt, entry, start, 
>>>>>> kvm_phys_size(mmu))
>>>>>> +            kvm_stage2_flush_range(mmu, entry->shadow_ipa, entry- 
>>>>>> >size);
>>>>>>         }
>>>>>>     }
>>>>>>     @@ -1104,8 +1206,16 @@ void kvm_arch_flush_shadow_all(struct kvm
>>>>>> *kvm)
>>>>>>         for (i = 0; i < kvm->arch.nested_mmus_size; i++) {
>>>>>>             struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
>>>>>>     -        if (!WARN_ON(atomic_read(&mmu->refcnt)))
>>>>>> +        if (!WARN_ON(atomic_read(&mmu->refcnt))) {
>>>>>> +            struct shadow_ipa_map *entry;
>>>>>> +            unsigned long start = 0;
>>>>>> +
>>>>>>                 kvm_free_stage2_pgd(mmu);
>>>>>> +
>>>>>> +            mt_for_each(&mmu->nested_mmu_mt, entry, start, 
>>>>>> kvm_phys_size(mmu))
>>>>>> +                kfree(entry);
>>>>>> +            mtree_destroy(&mmu->nested_mmu_mt);
>>>>>> +        }
>>>>>>         }
>>>>>>         kvfree(kvm->arch.nested_mmus);
>>>>>>         kvm->arch.nested_mmus = NULL;
>>>>>
>>>>> Any review comments or suggestions for this patch?
>>>>
>>>> None. This patch is obviously lacking the basic requirements that such
>>>> an "optimisation" should handle, such as dealing with multiple
>>>> mappings to the same IPA in the shadow S2, hence will happily fail to
>>>> correctly unmap stuff. There is no documentation, and no test.
>>>>
>>> Thanks for the comment.
>>> How about adding list of multiple mappings ranges to the maple tree
>>> entry/node while adding to the lookup and later unmapping every
>>> range present in that list?
>>
>> How will that work when the various mappings don't have the same size?
> 
> Can we have a merged new pivot?
> Say old IPA range is from A to B and the newer range is from C to D 
> (Which are intersecting partially or fully).
> Then can we create new pivot (delete old and insert new) with the range 
> MIN(A,C) to MAX(B,D).
> The new pivot will have list of entries of both old and new shadow ipa 
> ranges.
> This shall be repeated till all intersecting pivots are merged.
> 
> While unmapping, on first intersect detection, unmap all listed shadow 
> IPAs.

I'm Vishnu.
Following Ganapat’s departure from Ampere,
I have begun following up on his outstanding patch and
would appreciate your guidance on the proposed approach.

Do you have any recommendations or alternative steps to suggest?

Regards,
-Vishnu.
>>
>>> I tested this patch on an AmpereOne system (2 NUMA nodes, 96 CPUs
>>> per node, numa balance enabled) with large vCPU counts and large
>>> memory to L1 and L2.  The current full-address-space walk caused
>>> very large unmap/flush work and significant delays (exacerbated by
>>> NUMA balancing / page migration activity).  The targeted unmap using
>>> the list per node removes only the affected mappings and reduces the
>>> unmap latency substantially in our workloads.
>>
>> I really don't care how badly things perform. The important thing is
>> that this is architecturally correct, while your approach isn't.
>>
>>> I booted multiple L1s, each hosting several L2s, and observed no
>>> panics or failures related to missing support for multiple‑IPA
>>> mappings.
>>
>> I'm sorry, but Linux isn't a validation tool for the architecture. You
>> have clearly designed something around Linux's own behaviour, not the
>> architectural requirements.
>>
>>> If you have any test cases or scenarios that would validate support
>>> for multiple IPA mappings, could you please share them?
>>
>> The onus is on *you* to provide them, not me.
>>
> Using below kvm selftest code, could generate the 2 shadow IPAs, mapping 
> to same canonical IPA (when ran from L1 shell).
> This code generates 2 shadow IPA ranges of same size(PAGE SIZE) and 
> mapped to same Canonical IPA.
> 
> #include <stdio.h>
> #include <stdlib.h>
> #include <errno.h>
> #include <linux/atomic.h>
> #include <linux/sizes.h>
> 
> #include "kvm_util.h"
> #include "test_util.h"
> #include "processor.h"
> #include "ucall_common.h"
> 
> #define PAGE_SIZE  4096
> 
> static void guest_code(uint64_t slot1_gpa, uint64_t slot2_gpa, uint64_t 
> size, uint64_t page_size)
> {
>          uint64_t gpa;
> 
>          for (gpa = slot1_gpa; gpa < slot1_gpa + size; gpa += page_size)
>                  vcpu_arch_put_guest(*((volatile uint64_t *)gpa), gpa);
> 
>          for (gpa = slot2_gpa; gpa < slot2_gpa + size; gpa += page_size)
>                  vcpu_arch_put_guest(*((volatile uint64_t *)gpa), gpa);
> 
>          /* Write to slot 1 in loop */
>          while(1) {
>                  for (gpa = slot1_gpa; gpa < slot1_gpa + size; gpa += 
> page_size)
>                          vcpu_arch_put_guest(*((volatile uint64_t 
> *)gpa), gpa);
>          }
> 
>          GUEST_PRINTF("Guest DONE\n");
>          GUEST_DONE();
> }
> 
> static void run_vcpu(struct kvm_vcpu *vcpu)
> {
>          struct ucall uc;
> 
>          do {
>                  vcpu_run(vcpu);
>                  switch (get_ucall(vcpu, &uc)) {
>                          case UCALL_ABORT:
>                                  REPORT_GUEST_ASSERT(uc);
>                                  break;
>                          case UCALL_PRINTF:
>                                  printf("%s", uc.buffer);
>                                  break;
>                          case UCALL_DONE:
>                                  break;
>                          default:
>                                  TEST_FAIL("Unknown ucall %lu", uc.cmd);
>                          }
>          } while (uc.cmd != UCALL_DONE);
> }
> 
> int main(int argc, char *argv[])
> {
>          uint64_t gpa, slot_size, slot_stride, i;
>          int slot, fd;
>          struct kvm_vcpu *vcpu;
>          struct kvm_vm *vm;
>          void *mem;
>          int first_slot, nr_slots;
>          uint64_t start_gpa;
> 
>          slot_size = SZ_1M * 128;
>          slot_stride =  SZ_2G;
>          start_gpa = SZ_4G;
>          first_slot = 1;
>          nr_slots = 2;
> 
>          vcpu = malloc(sizeof(vcpu));
>          TEST_ASSERT(vcpu, "Failed to allocate vCPU");
> 
>          vm = __vm_create_with_vcpus(VM_SHAPE_DEFAULT, 1,
>                                      (nr_slots * slot_size) / PAGE_SIZE, 
> guest_code, &vcpu);
> 
>          fd = kvm_memfd_alloc(slot_size, false);
>          mem = mmap(NULL, slot_size, PROT_READ | PROT_WRITE, MAP_SHARED, 
> fd, 0);
>          TEST_ASSERT(mem != MAP_FAILED, "mmap() failed");
> 
>          for (slot = first_slot; slot <= nr_slots; slot++) {
>                  gpa = start_gpa + ((slot - first_slot) * slot_stride);
> 
>                  vm_set_user_memory_region(vm, slot, 0, gpa, slot_size, 
> mem);
>                  for (i = 0; i < slot_size; i += vm->page_size)
>                          virt_pg_map(vm, gpa + i, gpa + i);
>          }
> 
>          vcpu_args_set(vcpu, 4, start_gpa, start_gpa + SZ_2G, slot_size, 
> vm->page_size);
>          run_vcpu(vcpu);
> }
> 
> from host, tried page migration using migratepages command to trigger L1 
> crash with PATCH v2.

