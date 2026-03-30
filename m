Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11021108.outbound.protection.outlook.com [52.101.62.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF87B3C5525
	for <kvmarm@lists.linux.dev>; Mon, 30 Mar 2026 11:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.108
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774871524; cv=fail; b=F0XxQCNrszu1DYIiTd47gIoGFXF1hAdSmhEKlY0L8syyojGQDCjQuQKwUxs+WCdOEY2lOXCq3ZZEJwSIs//HgwEQkyxTl8ESCUPd7pNdxfnlO/chW7topA5ondnpBb0F8hceCvUl9nIyKHmHr6b20rIjpYSJcjlWk74FedBCgDo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774871524; c=relaxed/simple;
	bh=qgfLaRhVFxhozO4K13j5gq7Cmny534Aakj/khfrQIfk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=W6hc0hYg/YpiQyAJP1luSYziEP7lfs1E4Nh4ZkDl+0rOhk5+bDTiOZ7wc/wFytPVcdodhbBSntbCA2RFwPyeLpBhWShWP1o2BGPmOd22SAmCDslEJmRbuNytKauB2zthlQT0yeS8UAi/wpLZRBWF1TuhvnkyR/WVxBA1xdIYm6U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com; spf=pass smtp.mailfrom=os.amperecomputing.com; dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b=tLib1Trh; arc=fail smtp.client-ip=52.101.62.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b="tLib1Trh"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xrJKNeWS8izYCBLx1TUAyv92pMTVoZWUC4Cc/1NZk1+l6DLfIZ2wZX+UiGXsvWwwN/nbWHcpAltgl7AN/YefjhixzQDfAhfOb2dU2r2vcq/l33sTQKvCLFVXVeQu7CA9uSQ/4yIptSaNnuv6Ss2LZ6FNZJ7USw4sUHBGCjYirbuWWlIIulGrEFOV9mMVMkrJhjvXSuAFtv03pH+zYSTocWWDHuAEzrTrDWalJHctSNRuJuOAKvAw2Qm9CkK+nWKxdveQG5UE+taA+ZNEzKNO5RXrLUDHHC6cczQTTRl9ancWz1GezOe5rD1B+G4I2WRlVTKRodQzVVPqE4ENO8JCcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WeBkqq5O1ar9tokoeech/QijVdroZixpni4x29l7RsU=;
 b=f+LDh5O1dMTNROSAh2EftH8JPgY8usz42cM1vObl65t5gw347XICBad4F/dw7A871Sddmg2ybDlkf3EtC2V/VezLrZk2xuoxbSRlj6DvgObUq0Q2BU2f46uHkZYUTb5v78ANVYvcB6BQvsfPUZtCJzTDJmBkM4tUvQoNWV1HEZaxCq6orm5cxP/UvGs5fGFIAy4gJiELbHAZF0Gib1onEW4ZL2BDHOGnNfpUL2YYPgMZ/nHT/o6UIVy+42UDVVa5hZZlXgqFE5yaDTFHrNbsqq1i7KX7T4P0/UST2LzvEomN5+1WR6RY/LPXRt2dIVa/i42+47QzvEUZgA9mEbXT6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WeBkqq5O1ar9tokoeech/QijVdroZixpni4x29l7RsU=;
 b=tLib1TrhOPcykjtQejjMOemgZXoHAqmn6agUKFnfs2uGiAWFOzJHk1VjbIPCBPymPCr3PVA4TaarjQRMrVOEFk/JWnpqFXrp3f/w4ZJn+GYtGOv63a6MpdHPjn+mxJsBwvqLsfwnDu10wozJhz/YM7PvM2mOue+GDKOoYGTIN04=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from DM8PR01MB7142.prod.exchangelabs.com (2603:10b6:8:1::11) by
 SJ0PR01MB6509.prod.exchangelabs.com (2603:10b6:a03:294::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9745.28; Mon, 30 Mar 2026 11:51:58 +0000
Received: from DM8PR01MB7142.prod.exchangelabs.com
 ([fe80::11b:da91:4857:6dda]) by DM8PR01MB7142.prod.exchangelabs.com
 ([fe80::11b:da91:4857:6dda%6]) with mapi id 15.20.9745.027; Mon, 30 Mar 2026
 11:51:58 +0000
Message-ID: <2e12c5c2-a1b6-47b7-b54c-7281a77bbe0a@os.amperecomputing.com>
Date: Mon, 30 Mar 2026 17:21:51 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 35/49] KVM: arm64: GICv3: nv: Plug L1 LR sync into
 deactivation primitive
To: Marc Zyngier <maz@kernel.org>, Fuad Tabba <tabba@google.com>
Cc: Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>,
 Zenghui Yu <yuzenghui@huawei.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Mark Brown
 <broonie@kernel.org>, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
References: <20251120172540.2267180-1-maz@kernel.org>
 <20251120172540.2267180-36-maz@kernel.org>
Content-Language: en-US
From: Vishnu Pajjuri <vishnu@os.amperecomputing.com>
In-Reply-To: <20251120172540.2267180-36-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA5P287CA0148.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a01:1d7::18) To DM8PR01MB7142.prod.exchangelabs.com
 (2603:10b6:8:1::11)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM8PR01MB7142:EE_|SJ0PR01MB6509:EE_
X-MS-Office365-Filtering-Correlation-Id: 79946559-d7d4-4fd8-d7b2-08de8e52befe
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|56012099003|22082099003|18002099003|55112099003;
X-Microsoft-Antispam-Message-Info:
	pTgn19wqSROW3oMYgxy7kNpbzpDIg7xu8BLDQA1wsKXlxHPxJ4QsI7cYZ8m6kJ0XFwNKge+bmFIOhNHPFybI+Gf2lBI5TYC6+PuQLn3cBnHiQUQkFZEupFad+CW3VMQaAlvyX1GOIb4HBUIGUKvsHaHfybjHQIV11at00o5eCvRh6QAJDH8OdpPihMIfrA+e/JMD1NGFIl74UwajMC3q95kVOJdRYjyeHO7zU3GCox/s+/+Szvw7EuN9K5pPJKc46mVzueljPdejiI+AvsXKnXzzhHIPSGK3IrqSXkipTkCys+eIWolxvR81wK3V7Y7LMk8A3DcEbFQDQNtez7f1H0J7AWRTyw0QzaESD18SO/ERAtyjqKKMF8BaiXuBoClA8LD2HounoHSkO5jzF+BCAAoQHove3B3xxZz1i352UI0f6OLzy+NuJNUpC/Xe7zXVoQIAT6WGPgGUPfKRBoqPhsw//iBXrE0IICF2NKn4OSqh63rhYg1Oahehp78CxWgb7m6Vp5bk+DEOKdYrnswrNgv2WyfOj7G7kO8bNfPbyJgna7V8GALAlBQXs4SJh9HdnnSlzjVOqNT3PWHZjTENQ/g2FGRgHO6VVsE/6RtvDOsvheJcMRLnSnsenm4pox+1y3MLKTCKrFO2EdIdITJFoh3AdUhC4IFF98g5QlNAdb0iTgt7Q0efUzHkMmX4EHjv8ywT3KXytSXaD7xTQMaYAXPrm39VsshSok+TcCnrFes=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR01MB7142.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(56012099003)(22082099003)(18002099003)(55112099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?V0Y3bERHTE5wUzFFTzJQeTErUWlEaHhvYVBQUlhqaWVud3I1Umo4eW1Zc3Ny?=
 =?utf-8?B?cmk3NGd4dUJBVzUzYTNSd0VmRFBaMGN5QzV4d1NXVzRvV01VL29ndkNiVGw4?=
 =?utf-8?B?aUllWXBZTWwrR3NvOWZVaVlhUjlpNWxjdy9HUnMwOTVpcGMvUkNyMTRaRFpN?=
 =?utf-8?B?eDlzTU1hSFM3NG9QVEoySXdiTUdXbjRVMGFQNkEzaE9YN29zVGVLS3VJQ1cy?=
 =?utf-8?B?SlhON0h3SDU4cy9Wa1g3WCtDeDdhSVpHRkVqc2xpZ3V2SUxYSm8zR1YwNndn?=
 =?utf-8?B?UE9vemt0R0pDY3lZQVVsTXNuUWxJOVJiSlUwK2pjalRWK2xQTUdVekI0T1NH?=
 =?utf-8?B?SDUxYVJaeWk4M0xuWEpEeXpYaEVFeDlQVnlMbjZyTkh6TVRaU3R6a3oxa1FX?=
 =?utf-8?B?V2dVUWcvYzByOWNYcUFOdWgxUWxzSkVnRzBqNTl6SXZSODZkb1V0Q3BTRm92?=
 =?utf-8?B?N3Y4U0xyM3diWVhwclp5VDJIL1hrRE5nZFZId0h0Y0FnRlJqcmZZeVlJbGh5?=
 =?utf-8?B?clNvNEp5SkUrTG80R2doaWFOc3BERGlQU0N5RWlGRWJjWU50SERnRHJZZzhs?=
 =?utf-8?B?R2k1c3FubW5TYnlnRTRldFY3My9uOTZSMXNpMXh1SU8rd3Zkay8zejZ3N3c5?=
 =?utf-8?B?WjQvcTRqdFZPU2tTanZJZ3YyUkhLT1hnRVI3LzlNSWxScUpsd2cvNGxRYkFP?=
 =?utf-8?B?dENCSzRJcWxaZGdJMFVZblh5SkdVcldtVWhtT2gyOVdtRG1WV0NVRWpPazdC?=
 =?utf-8?B?M2ZIQ0hVZk5CbTh2ZWJFREFoLzNkVnoxUnowUVNOYVJabEExNHM5S203ZUk2?=
 =?utf-8?B?THJJWDNyWmhDWGduM0lPQ0U1Qm1CQnlRdm1pVk9HRUdRUlErbW9FOGo5eFMr?=
 =?utf-8?B?VVdzdTNvSkp0eWI1TDhYbms4OTJhSUZpVDA4Tk5GS3V4ZjA2ZzNXRkVJNjh2?=
 =?utf-8?B?aTZGVTRuTFpURWhHbktmeGxDN1NTQlBWN3NxRm1xVWl6Z1FzblE0QUk0bTk2?=
 =?utf-8?B?S2xTNlViRFl0WjRzSG9YekxjZ0c3Sndxemh5VFlJcHh6RFcyUXpkUlFJSXhK?=
 =?utf-8?B?d0hLOWRybjNwdiswZTl2ZVNKRFNEL0tlaDZkUnZVV3BTUjVmYzBad0VBQmRr?=
 =?utf-8?B?aGx0Yk5qL1Y4VWlkamlleU91UEpBWjFHN0hxV2tiNUJ4dHN3dHlFWlNONlpT?=
 =?utf-8?B?VFd5aWhMTUhocXc0Rm80ditmWWtRQVorQnZsaUZqYXpYZ1IvUGN2VW5Bb0JN?=
 =?utf-8?B?ZkNxNG9meFpId0FMdkdyUHVIUXVLZXRXaENpZWlmMUVacXBmL2lXdCtjajF4?=
 =?utf-8?B?UVNTK0h2RlhNV0lRUDBobTBtOUZyRjBocGdLd2dBejk4cXR1dmYwWnpSSjIy?=
 =?utf-8?B?Z3VFVTYwS1VGcnlYd1hQbFVtTGphYXdBcTdUY3lMeGRYQk1NUnBqbUJBcUF6?=
 =?utf-8?B?dG9zb0NtMmFXblZuWXZ2NHdCSFNHQ0IxZUdob216Tndvc1oyS3cybXN1UXda?=
 =?utf-8?B?QjBRaE4wcks2RloraytDbDhjZGhTZkZqRlVXb0FxUGNGdUpZMWRZTFRDM0dj?=
 =?utf-8?B?TEMxWWY0bWtmS1liYTgyZC9zZjhrUHFtWUN5Wm1FSDFLUzJQMzZrQityS0xM?=
 =?utf-8?B?MUJHdDByOWhTbmZQVVhVY25lZkhvSkIvVGJDL3NkREg2TldxM3ZybUlhYjZV?=
 =?utf-8?B?U0Zob3VuTlRRQW1maG1vcW1FZ2hyU3M5bzBvaG5PQmhOQmVXbi81N1BMQWo5?=
 =?utf-8?B?aERHYm55ZVV4ellGaU13S2Z4Ym9zMDAzYzVoSWI0Z1NlV1BmYzJ2MSs5bkwv?=
 =?utf-8?B?c0EyeGVYN2ZEU1ZzUTl5OWg1VlJFQk0rU2N4SGk4M2l3cUFneis2VWVFb0o0?=
 =?utf-8?B?NDNjK3NIQlI4NWRUQkxxaW1mQVJWZnlIU3ZXS3JJbGViUXdURVhvUTlRbjky?=
 =?utf-8?B?dXZJVTd0dHloWTZsbVV2NWdBcFM5VEMwVTlKc3o2S085cTJtMFYwSHEwZFVM?=
 =?utf-8?B?Z3hwSHRaUDJzZGc1SStNZzYxalpkaFc2ajVDY2IvRUNoVVFlVHV5K2UyZDli?=
 =?utf-8?B?M1FKZlNpY2I5TWJVNFRqdHByMEFwaWJhZlhRQ2ZvZHFCMFpRUDd1Rk84c1Ix?=
 =?utf-8?B?b2hzb242dXUxWCtNaVltSVpOU0IzQnpJSmYxRCs5Y1FIYWNpZXJZb1pmSFRH?=
 =?utf-8?B?ZmhoWW1KUG05WVlpVG5JS1hna2ppWGVLcWxscTlac2k4OHo0TW9PbW11TEZm?=
 =?utf-8?B?dTZkUC9CNWZKalhyS1pnS2ZzWmFlbmtaU0NiODRRTGcxalRTRzBvZTVvMzQz?=
 =?utf-8?B?NW1jR1RHZWRWSW5JNGdJTHNCNmlIOWsrdUc0MHhjM3BjWGNvZStlY2kwQnhY?=
 =?utf-8?Q?bzucqMkOy41TALTKKVwX6p9qB8lbjfz7JjmoL?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79946559-d7d4-4fd8-d7b2-08de8e52befe
X-MS-Exchange-CrossTenant-AuthSource: DM8PR01MB7142.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2026 11:51:58.0570
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aBxACutA8bKy/fdx2m2sjhf75QDCOqo6ye41h9bA+bxqbfeVbsH4Mp+itDT2qzJfuuAaSjFirAVGP37aUR7LtmAmOocyXyzvU3pE1KmPVpfBpgx9Qbvwcs+ur2Hpmcm0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR01MB6509

Hi Fuad Tabba,
    I'm trying to run nested VMs on Ampere platforms after this patch 
series(v6.19+) but nested VMs are not booting and triggering soft 
lockups on L0 and L0 hang. But just before this patch I could able to 
successfully boot the Nested VMs.

I bisected the failure to a single commit which is this patch which is 
causing the issue.

I would like to understand from you that did you observed anything like 
that?

Were you able to boot Nested VMs successfully after v6.19+?

LOG:
[  164.647367] Call trace:
[  164.647368]  smp_call_function_many_cond+0x334/0x7a0 (P)
[  164.647372]  smp_call_function_many+0x20/0x40
[  164.647374]  kvm_make_all_cpus_request+0xec/0x1b8
[  164.647377]  vgic_queue_irq_unlock+0x1c8/0x2c8
[  164.647380]  kvm_vgic_inject_irq+0x194/0x1e0
[  164.647381]  kvm_vm_ioctl_irq_line+0x170/0x400
[  164.647386]  kvm_vm_ioctl+0x7b8/0xc88
[  164.647389]  __arm64_sys_ioctl+0xb4/0x118
[  164.647393]  invoke_syscall+0x6c/0x100
[  164.647397]  el0_svc_common.constprop.0+0x48/0xf0
[  164.647398]  do_el0_svc+0x24/0x38
[  164.647400]  el0_svc+0x3c/0x170
[  164.647403]  el0t_64_sync_handler+0xa0/0xe8
[  164.647405]  el0t_64_sync+0x1b0/0x1b8



Regards,
-Vishnu.

On 20-11-2025 22:55, Marc Zyngier wrote:
> Pretty much like the rest of the LR handling, deactivation of an
> L2 interrupt gets reflected in the L1 LRs, and therefore must be
> propagated into the L1 shadow state if the interrupt is HW-bound.
> 
> Instead of directly handling the active state (which looks a bit
> off as it ignores locking and L1->L0 HW propagation), use the new
> deactivation primitive to perform the deactivation and deal with
> the required maintenance.
> 
> Tested-by: Fuad Tabba <tabba@google.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>   arch/arm64/kvm/vgic/vgic-v3-nested.c | 19 +++++++++----------
>   1 file changed, 9 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/arm64/kvm/vgic/vgic-v3-nested.c b/arch/arm64/kvm/vgic/vgic-v3-nested.c
> index 40f7a37e0685c..15e7033a7937e 100644
> --- a/arch/arm64/kvm/vgic/vgic-v3-nested.c
> +++ b/arch/arm64/kvm/vgic/vgic-v3-nested.c
> @@ -280,7 +280,6 @@ void vgic_v3_sync_nested(struct kvm_vcpu *vcpu)
>   
>   	for_each_set_bit(i, &shadow_if->lr_map, kvm_vgic_global_state.nr_lr) {
>   		u64 val, host_lr, lr;
> -		struct vgic_irq *irq;
>   
>   		host_lr = __gic_v3_get_lr(lr_map_idx_to_shadow_idx(shadow_if, i));
>   
> @@ -290,7 +289,14 @@ void vgic_v3_sync_nested(struct kvm_vcpu *vcpu)
>   		val |= host_lr & ICH_LR_STATE;
>   		__vcpu_assign_sys_reg(vcpu, ICH_LRN(i), val);
>   
> -		if (!(lr & ICH_LR_HW) || !(lr & ICH_LR_STATE))
> +		/*
> +		 * Deactivation of a HW interrupt: the LR must have the HW
> +		 * bit set, have been in a non-invalid state before the run,
> +		 * and now be in an invalid state. If any of that doesn't
> +		 * hold, we're done with this LR.
> +		 */
> +		if (!((lr & ICH_LR_HW) && (lr & ICH_LR_STATE) &&
> +		      !(host_lr & ICH_LR_STATE)))
>   			continue;
>   
>   		/*
> @@ -298,14 +304,7 @@ void vgic_v3_sync_nested(struct kvm_vcpu *vcpu)
>   		 * need to emulate the HW effect between the guest hypervisor
>   		 * and the nested guest.
>   		 */
> -		irq = vgic_get_vcpu_irq(vcpu, FIELD_GET(ICH_LR_PHYS_ID_MASK, lr));
> -		if (WARN_ON(!irq)) /* Shouldn't happen as we check on load */
> -			continue;
> -
> -		if (!(host_lr & ICH_LR_STATE))
> -			irq->active = false;
> -
> -		vgic_put_irq(vcpu->kvm, irq);
> +		vgic_v3_deactivate(vcpu, FIELD_GET(ICH_LR_PHYS_ID_MASK, lr));
>   	}
>   
>   	/* We need these to be synchronised to generate the MI */

