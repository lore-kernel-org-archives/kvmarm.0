Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11020133.outbound.protection.outlook.com [52.101.85.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86AA41F92E
	for <kvmarm@lists.linux.dev>; Tue, 31 Mar 2026 06:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.133
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774938738; cv=fail; b=ILR2OqP06UXXhW+A4/RByC6EDZIS4SvXi229O6TOnITSf3BysfKEvf7B1MPuqShUIqOIxn7ms4j37XbNSW7bpIUFDjXSGXuK0LbsinMVMinKJPNIs8qTf2+jaxBEutThfO8nLOmKATm389kp39iJUgwHOeq3KFz6GpGrJNSsP1o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774938738; c=relaxed/simple;
	bh=k68+oo6NFMF0xMMcjqT2aJk1/5bj4KLHkGEmdffP2kI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=nGq0AiYRi6UsCwJf6IGuVZoeou/YK325ydYLx3S/SS3p3pGui/auZZqYTPuaVPc6oa09haUPygde/EjKdhOfjbSaNodz4fzKLcfCetHCNDkoNz3c1/mXM1gVq+p2Kj10mx65UAIqWs9bQl2oPiQB7wZHbJ9vF3910JOwaeuBR1U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com; spf=pass smtp.mailfrom=os.amperecomputing.com; dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b=tdbyj6nq; arc=fail smtp.client-ip=52.101.85.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b="tdbyj6nq"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ES4Z1hFqP3S7az0neUSnorZH/t8DGYvLrl3bPWCfoasxKuA8HFxvMfrFB/qIUuZlPcsJLN8C51SvgSDR0UtymRdBcIlp1w9qnSXrWqeM9UkPdZ7U5Pvc7k72UqeG03Y4YsS8nvFHL5OyIXpDxo/6GmCdtQF6mqo6LO71shifB5zpI4qPMlm9Zi5cxnQrYgx+0IZWypuWAurGixE8rpoBuaZZq0vt6K36S1FCiUgZhu5HdA1770D4TmlocLXc3uYpddOnQYhr0wJPgCceVDlX+UvmhvHpAjCdgRckTgisZitx6xixgVxeWzhRTaPBi6v2KdQEUzg4EU5q53Oxm+j5hQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QvYd9YQuQNQQ9Wtfd6gKzpDAIxTvUTRXNXSg/XQ1wSs=;
 b=jbGAQcleKOEVBTQWj2nQWfe91fg0v6jGjkTGIAjHMJgn/6Ohypmk78N4lwD5XdNkzemkLlp2zqWfZzxY0yTwwMmH/oI7+v5XA53H3T22rEd28g6fFhZrterkC2tOT3bqfWBefJkgDFaoEFJAPuXGqH3Bw91einuzD7M9lFDMY3JAoMGaxTdQX8/EV1VRfwL7RhCt1AnHu1+pNv0I62Y3oUT0hM9vxEk61JYBNDMARUfwhUAScpFmhaw9rcjeVRQasrQeQcLpsQFEJJ0DxhgasKjeASDLP+n1Ksqa53OjYVigi7rWMYZRLGDGp7726DGZ90dwk70l9qtsBCdV5HCPHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QvYd9YQuQNQQ9Wtfd6gKzpDAIxTvUTRXNXSg/XQ1wSs=;
 b=tdbyj6nqiTbENYTp+8jJofUUiO5dsl3nKbpd+eGH36PgNLJOrel1/9Q/QAHv8YSCfeX5aMpf8vSL8Xp8CHErq4E23RsZx1Ub9JkMTrnYVbvioZVvVQGtjaI534lxsdpEl76yc9jsUyPtYJGUymDsNODIN5k+zvluGRH0GDSmhDA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from DM8PR01MB7142.prod.exchangelabs.com (2603:10b6:8:1::11) by
 SA1PR01MB994644.prod.exchangelabs.com (2603:10b6:806:4db::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9745.28; Tue, 31 Mar 2026 06:32:13 +0000
Received: from DM8PR01MB7142.prod.exchangelabs.com
 ([fe80::11b:da91:4857:6dda]) by DM8PR01MB7142.prod.exchangelabs.com
 ([fe80::11b:da91:4857:6dda%6]) with mapi id 15.20.9745.027; Tue, 31 Mar 2026
 06:32:12 +0000
Message-ID: <1e050b67-2276-41ad-9265-796ba853dc7c@os.amperecomputing.com>
Date: Tue, 31 Mar 2026 12:01:54 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 35/49] KVM: arm64: GICv3: nv: Plug L1 LR sync into
 deactivation primitive
To: Marc Zyngier <maz@kernel.org>
Cc: Fuad Tabba <tabba@google.com>, Joey Gouly <joey.gouly@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>,
 Zenghui Yu <yuzenghui@huawei.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Mark Brown
 <broonie@kernel.org>, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
References: <20251120172540.2267180-1-maz@kernel.org>
 <20251120172540.2267180-36-maz@kernel.org>
 <2e12c5c2-a1b6-47b7-b54c-7281a77bbe0a@os.amperecomputing.com>
 <878qb9cxzr.wl-maz@kernel.org>
Content-Language: en-US
From: Vishnu Pajjuri <vishnu@os.amperecomputing.com>
In-Reply-To: <878qb9cxzr.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA5PR01CA0038.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:1d6::18) To DM8PR01MB7142.prod.exchangelabs.com
 (2603:10b6:8:1::11)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM8PR01MB7142:EE_|SA1PR01MB994644:EE_
X-MS-Office365-Filtering-Correlation-Id: 292194b6-ace0-4d8f-cf23-08de8eef3e45
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|55112099003|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	9XtDiURLJ6243dn4yz8SCk/X3c/gDgb6wdwHTV/mnG9UUAj0y8hky5Lo7Xl/oUtgQV0p44yp4qObOYiRNUlypP9/r5/FuWTmT8Y9Edh0PPyfdEYHwTa3rPYmFYnhtXmqXMkHvQpa8NXkA73xBlI0DXF+bLvvwGxQbwdFIPklpDn1cNQ1wdhznCTdeXCk3vvheS4VqVlHzxoyuX2SYO6Dcw9u373bSoG7pUIcbq+awrNVzkIwuesNLlc0iiVTmCuAkv7cWg0ubmFWc9YJ/aiPT9c6kU4ixNqqREACWv+vHmnoGBEGtJMn5ypYw0JxcZLdcCrHyH7P8DoYUVnODFXnffl0SXZoO/QjoF5BfXkVzV6pPjimlZ0BuAB51iWK/T+djzlDAGBjr71/OKJQCqaFOSxeANpHhw4/cwyQJ+QPHFNoBCaa9UHNaRl7fLFjwFldc/LIdu/uydWUzVYkGGCAYwGGRIT3jR054auaSrWgz9GDM5yi2fEMwtXxCi/4YNvSYLstblYWTpI6ClwJbMC1GaaDCP7PsxW7kPR9oXEviZIlL/cuCu/fy3tLojXYpdsQghr0Y8YhoUFMBbs1gub40oQyYDE7eDjfPcvWQBhyQ0UUEYpdDHYlyfOP52jS3iDbQsVo1KvId3DjCUxNiaie9s3Ybor2Q51eqYKzPP5UIoe79pkPQkY7zDh0SRa/6MWripbgUHzcZQHzpnNm7Wg5A8Zzufg48xcoNc+ZJwaVN2Q=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR01MB7142.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(55112099003)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NEIwTzQ1UTBSc1ZFT0ROalk1QTNTdE5pbER1Yi9OM005RzdobVVRVi80RU84?=
 =?utf-8?B?NnNES215REtIUFRVcjdFYjNrLzhCV1FrRVhtUWtETXhYaE1oYWJlMmJQUVpJ?=
 =?utf-8?B?ZDdBYVdCMk1yUDNwYUdNaW9kUDNKcWNnT0xLV3NVeFltdUN4YTBjeXBNTkxi?=
 =?utf-8?B?eG10MDU5cnpSZTJDWkVXQ2g2NTNLWjRaNkg3NkN5cmZJL2o0SDNVaHViWGtn?=
 =?utf-8?B?THFLUFhOR1JEUXZNWG9SNzVGUkJXNHk2blRtZGFnOVB1S1pyOVdaZmcvZFNB?=
 =?utf-8?B?a25pdVE4YUpTbllURTVydTMzOXFHRTl1aEhKUFV6Ly90RXBkcklrYUNHcERk?=
 =?utf-8?B?NUtneTBKdzFoUFFRY2gzTG1hUGtRZkZOZkVJMStQTU1hK25STkdUREg5YnRo?=
 =?utf-8?B?NmpoRU85MFV2TXltVFVieFpubjBTSGFrLzlpbXY5MVUva1B0OVB1SXdvMkVu?=
 =?utf-8?B?UWRMZzZZZ2F4RmcvVW5OemlqbCtRbGtwV1RIRHh5ejRrbkk4dW5uTHpEVmVE?=
 =?utf-8?B?VEE0dXNDOENvbjFXM0xkeXF4L2xLUng2cWs1MXEwbGVBbDNaYnRoMHUrcjN4?=
 =?utf-8?B?cHVXMDBIUmIrelZWV1VYMVNOZzM1UVJiYmRLbjBnSWtLd2s0K0lnR2JHWjls?=
 =?utf-8?B?ajRON3Jwa2RSSExLdmcwV1ZwV3dCSEdDUkI5dWF4YjNEVzBJM1VRNlVDUnd3?=
 =?utf-8?B?REwwNHgrMTJqZHc2RTdvVXhac3NHbjQxRXloVHhnTDkxVHBGRTA5Zmtpa1pR?=
 =?utf-8?B?WW1mV1djVjhvaDFXdHhNdnYzYmliRGlaSEtKMnlWeTZGZzIyNDZwSlcrNDMr?=
 =?utf-8?B?aEVFU1BRNFhFMEpsajYrUGpwNExmNlZNTERNSWFOc0luWFZ6OVJCSlJQRUtp?=
 =?utf-8?B?bjVRaWZrZi9rSXZHZTY1R2JjL21QNUl3QXM0emxKY1dlRElpdWZPRWgzbmFu?=
 =?utf-8?B?MWtKVFljYk5TQmttVEFNbkdsMDZ3REZiQjhKSEFENDVYeUtKQzY1U0tUVkMy?=
 =?utf-8?B?cTN4eWdTb3Exa3BuSStJZkw4bC85U2x6VFN1cm1wdHNoYWtIa0w5ZzJHS0lC?=
 =?utf-8?B?cnJnVTVyY21obEVVc3ZGYVcvRHl5UGc2ajlqMEUvaUo3ZVZwRUZHNERoMytP?=
 =?utf-8?B?RkYvMWlkUm5wZ1lGMzF6TE54UEFLRVlCSGJuNlpDMmJ4djVueVhITlRzNXNl?=
 =?utf-8?B?WndDejlYTE5uQnI3R0dzU285SjVxemx0RnZwSFY2cFd4ODlRQ1NDejFSK1pr?=
 =?utf-8?B?SUwyaFFmSFFNdElaMTk5dHRYNElBTjNJTmk5UUQzc2c1QkxiOEdvTEVKdEls?=
 =?utf-8?B?OWV0eDdENmgxUjI0cVFuWUtjVWhML3dWNWtMNVVkTkd2aXlDMXpNWGRicFJK?=
 =?utf-8?B?VWRNYW5xVVpibXFQOWUzU1dSR0EzMTdjRHljNEhLbXF3VFNwV2lZQ1hCR0ly?=
 =?utf-8?B?WmdOWm9FZmJMT1ZKKzZkWGZiZldSQkpoNDcvRVdWQXd3QWRiVzBZNjBZNld6?=
 =?utf-8?B?OGpKaVhHcjRNZk1TaUtnL3N6VTd1VHdTOGlpNjdSRlJKU2ZoVHd5SDZ2dy9r?=
 =?utf-8?B?aWlOdXZkeWhDaGpaQ3ZCZjd6UFdFR0E0dXU2WVVJWE1zUVNmbnVyOTBXV2dT?=
 =?utf-8?B?cDlIc0wwZDVuUU5tanFWeXIxazk0REx1M1FBS1J2eVFadXF1MmlQWlFEcnVO?=
 =?utf-8?B?UkI0d1Bzd0wwbDNPdVFoTUZ3dzZ5MFNoOTc5dHI3WTJCTzhPcjVTWFRaaENX?=
 =?utf-8?B?RnpDVGdhVFNXYlZqME5oVWJsNDFtRkZlT0ZENk9BamxhNHJjbVV3U1lKNU44?=
 =?utf-8?B?TElWYVNJTkJFTzlQTEw0RmRxc2VSWElTWjhFY2FmRUhYbmxDbkdrUDZieEZx?=
 =?utf-8?B?M1BudlFaa0cxMnVDbVRmOXE5bkpMSkxIdXViL3EvR2xvTVNySitDQmpGYjd6?=
 =?utf-8?B?cGh3MnFkUkhQcm53dlhLUlVRNGFVWFl3dU04WEg4a2RrK2lNWWV0VEdDOWxq?=
 =?utf-8?B?R0pOMTZ4SEpJMkpTSVVkRVhVa0tlTW52RUJXbXh1TTRxeFlIWGpqRU5BRk9m?=
 =?utf-8?B?MnVncGhvc1VRR0x5Y2hjVW1qTDZhWmF1d0dQMUxqZXVKWXNYeVdiNnFLckhj?=
 =?utf-8?B?M2RObVB3Y2pYenVaakJTV2FWbllGUFIrdnVxVzdHcllxZjZYNE1OUUdIWStv?=
 =?utf-8?B?azlMUVZxNWFlZWFraERaWFJreDhybUxPM3FwZHJCNEJweWs5cmRZcGljUVBT?=
 =?utf-8?B?dllrdW8zdW5HQUlBRjBPekdDTUp6OTN5OGgraTJKcGRsbWxQeUJXRGV6VFh3?=
 =?utf-8?B?UGI0Ymk5RXFtQVhDWDh5eDVKTm1wTUxWZFRvWGJUS1dPdnZ3UnpXTnJuaFEz?=
 =?utf-8?Q?zqJE4TYY5qhIWH70=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 292194b6-ace0-4d8f-cf23-08de8eef3e45
X-MS-Exchange-CrossTenant-AuthSource: DM8PR01MB7142.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2026 06:32:12.7720
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BiBA/Ll4flCZYcW+MIEBVBeNquqxWKrMqhkdRB46rNjPX+6SnvhVcQpEnthqSMRo0CHkKxq0unvct4dKiDnGEOgWiEucJN87Bf8R0fxIoYg5i3UPZ/4nLCpHnj3c5vJl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR01MB994644

Hi Marc,
Many thanks for your reply.

On 30-03-2026 17:47, Marc Zyngier wrote:
> On Mon, 30 Mar 2026 12:51:51 +0100,
> Vishnu Pajjuri <vishnu@os.amperecomputing.com> wrote:
>>
>> Hi Fuad Tabba,
> 
> To be brutally honest, I doubt Fuad really cares about NV,

I see Tested-by: fuad Tabba on this patch so tried to reach out him.

> 
>>     I'm trying to run nested VMs on Ampere platforms after this patch
>> series(v6.19+) but nested VMs are not booting and triggering soft
>> lockups on L0 and L0 hang. But just before this patch I could able to
>> successfully boot the Nested VMs.
> 
> So the host dies? There isn't much here that interacts with the host
> at all. Worse case, the L1 dies by not making progress.

Initially L1 become unresponsive then L0 becomes unresponsive, soft 
lockups and L0 hang.

> 
>>
>> I bisected the failure to a single commit which is this patch which is
>> causing the issue.
>>
>> I would like to understand from you that did you observed anything
>> like that?
> 
> No. If I had, I wouldn't have merged the series.
> 
>>
>> Were you able to boot Nested VMs successfully after v6.19+?
> 
> I boot L3s every day.

Do you mean L2s or L3s on top of L2s?
I running L1 and L2 using latest QEMU, do you use QEMU or kvmtool run L1 
and L2 in your regression tests?


> 
>> LOG:
>> [  164.647367] Call trace:
>> [  164.647368]  smp_call_function_many_cond+0x334/0x7a0 (P)
>> [  164.647372]  smp_call_function_many+0x20/0x40
>> [  164.647374]  kvm_make_all_cpus_request+0xec/0x1b8
>> [  164.647377]  vgic_queue_irq_unlock+0x1c8/0x2c8
>> [  164.647380]  kvm_vgic_inject_irq+0x194/0x1e0
>> [  164.647381]  kvm_vm_ioctl_irq_line+0x170/0x400
>> [  164.647386]  kvm_vm_ioctl+0x7b8/0xc88
>> [  164.647389]  __arm64_sys_ioctl+0xb4/0x118
>> [  164.647393]  invoke_syscall+0x6c/0x100
>> [  164.647397]  el0_svc_common.constprop.0+0x48/0xf0
>> [  164.647398]  do_el0_svc+0x24/0x38
>> [  164.647400]  el0_svc+0x3c/0x170
>> [  164.647403]  el0t_64_sync_handler+0xa0/0xe8
>> [  164.647405]  el0t_64_sync+0x1b0/0x1b8
> 
> This trace is about interrupt injection from userspace, not
> deactivation of a HW interrupt.
> None of that makes much sense.

Although this behavior is puzzling, it matches the trace I typically 
observe on L0. After reverting the patch, I was able to boot L2 guests 
successfully.

Regards,
-Vishnu
> 
> 	M.
> 

