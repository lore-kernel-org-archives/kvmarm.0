Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2125.outbound.protection.outlook.com [40.107.220.125])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEEED23C8CB
	for <kvmarm@lists.linux.dev>; Wed, 16 Apr 2025 23:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.125
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744846937; cv=fail; b=N9GRpIXGsKXsrevGJw3xxDEcwISzMyyqIrpjn7LDHyJI0Z31arY5ojwxNjHuohrdT7nNlGIV14grvHAARb6QHY2JPjuez+NJBYMw3dpGXaNfkvjTysAYyw8HIvimMh9L8VJzuEgiRRyldwYXKHsALU0SGtqEl37RD/EG7WrL9co=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744846937; c=relaxed/simple;
	bh=y8q1Ix+o4Obb+6oPTdzmmcqryz6EZG8h4Wglz2IeZTk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 Content-Type:MIME-Version; b=ZAFN6fgIzaMb+8ahDmBIe387XcBka6vVqTrcg6ADCABlkEdZrhY5YgNshEAzHQEWCx0bX6iEbA6YwpH2tB5sdJUZeUehgjyYPX5sraOfewwp8IVt4hHdAWLFwII9zi2lYtXDU5O0XNPNjPSHcIAuPV8V4oQRh2CkDNZrBwCbD44=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com; spf=pass smtp.mailfrom=os.amperecomputing.com; dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b=sZmKV5LK; arc=fail smtp.client-ip=40.107.220.125
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b="sZmKV5LK"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=H4E1prAvEYhLKU4rYBaFQyx9GpN/BhcgSoQbSv7FMaQzd0bZqcMdBGSHInIvJi5RTOIviTVwUoh3NGUYZ6fWNCIIr405WqIGKqLreYdjLU1kOuEiKutnZV74yPOrTmQAgQoqyhyAcccOnSwaUkiCShytlsTglKD1gQBLlOnkLzJhfEgZh6+UmhnyZ8YOXJ5XC9x2CGApbxRyttq1WlCInJ2e7rtEuiywsCGFhY43NuDh2XgjqyeUk/Rme1jhnhhKphvK/5Z1Dycaw086pFssAW8mtRQa7699NMdBoCm7UII/GMDnD70rUqG83ATYWRGBsV8rB0/yxbhdcY7B4MCL/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KD73Inq+6i6amVW2Bei//iIgRRccVOTse9+mrZlSN6g=;
 b=S+4kwrVAY60TfoUdQYs3hpA/Td/MlpfLJlYcv8bY7wWetO6vwZnjcncRDjWReF0vbWKmtgIqmNR6MeqOg/PictNS0ezTtz3clFkOnYD1OIoSiMcEcYOFAoz3DpTbeSSyZDo+oQVRE68Q+WY7ewXIIYnRNUWWdJlwlwvT2gB/k+x1HYF3GODjbgr6Vp8hs4gsx1dR01cWjXiz+nMbE6JWzOM+FXbwQH4AFRU/ZrkUxMlnabw06SHlIUM1bBjB3riKPu3UiDazFgiURnhU7bC97NtZfACQOJi+r8tneRs3UicTLtJwFK+zz36Fc1zlJeuqMnqfF0SK5/7CyZJgt++lcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KD73Inq+6i6amVW2Bei//iIgRRccVOTse9+mrZlSN6g=;
 b=sZmKV5LKB/Zu7MufEtjKYsJ/tBenVXRZkhefn7bNzuyGUUEp1QvfHbDly7SzdJxU2aI1VIahgknOYTvaor871hFbHqfhQuWqa+AJglw/m+M5+CN+bQeM+U09/D6GiZ641XMNkJxG2WIzlbRuZHExq0b4ZFT0+SABaEcqmYkgSHQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from LV2PR01MB7792.prod.exchangelabs.com (2603:10b6:408:14f::10) by
 CO1PR01MB9009.prod.exchangelabs.com (2603:10b6:303:275::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8655.22; Wed, 16 Apr 2025 23:42:12 +0000
Received: from LV2PR01MB7792.prod.exchangelabs.com
 ([fe80::2349:ebe6:2948:adb9]) by LV2PR01MB7792.prod.exchangelabs.com
 ([fe80::2349:ebe6:2948:adb9%5]) with mapi id 15.20.8655.022; Wed, 16 Apr 2025
 23:42:11 +0000
From: D Scott Phillips <scott@os.amperecomputing.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Joey Gouly
 <joey.gouly@arm.com>, Oliver Upton <oliver.upton@linux.dev>, Suzuki K
 Poulose <suzuki.poulose@arm.com>, Will Deacon <will@kernel.org>, Zenghui
 Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] KVM: arm64: fix config.hcr used uninitialized in
 __kvm_at_s1e01_fast
In-Reply-To: <8634e9l1y8.wl-maz@kernel.org>
References: <20250415154656.1698522-1-scott@os.amperecomputing.com>
 <8634e9l1y8.wl-maz@kernel.org>
Date: Wed, 16 Apr 2025 16:00:39 -0700
Message-ID: <86sem7yanc.fsf@scott-ph-mail.amperecomputing.com>
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0239.namprd13.prod.outlook.com
 (2603:10b6:a03:2c1::34) To LV2PR01MB7792.prod.exchangelabs.com
 (2603:10b6:408:14f::10)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR01MB7792:EE_|CO1PR01MB9009:EE_
X-MS-Office365-Filtering-Correlation-Id: 4d2d1b2f-302d-41ab-0a88-08dd7d404efd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|52116014|366016|7416014|376014|1800799024|38350700014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?nJO4qk2vhTiyjyZIPsgBDNKRR54ip+X7Tfv3HBZGfdKG+bEHyaFUUbjGrDLY?=
 =?us-ascii?Q?xFoG0KBDJGpobnw8sLEjLVY8pko0URy57zdH29wJyo0b3gl3VaoblBvXHKQC?=
 =?us-ascii?Q?cFSO7PNqbauHkmH/5gIXc/n7qBeV1IZWtN+iNRQRKxRuEEvvHwglfaVn6ib8?=
 =?us-ascii?Q?ojZr4N3Hpn9Ib0lSbxWTPeUEIo4MxdRU693in8BdA8eTU8BgpBT+GtLtKKj/?=
 =?us-ascii?Q?n4weBDdE14cctSOmZClxyecxVP98ucwAnDhLWScS8EfcAK/mi8ABGmsY13FB?=
 =?us-ascii?Q?hrQhKU4EQzIEPCLAQ+Ls6zLNAL0yoawngj6b2QTdR74ikgbnH1pyjD3N0XTW?=
 =?us-ascii?Q?6jQcQ+gQtz5sOQPSZ1neHElWsorWvJZZW85zcBpnjNseJWc7zzVPHo8p5QuT?=
 =?us-ascii?Q?2hficmZX660E0JYGLod7OdUo7iAohoaAHdI13XeT5d65ZtTY43HvdmTkhQF0?=
 =?us-ascii?Q?xJ2difEgayn+NK0qoiIvEGWdELsoLGVrKfr3fJPnLGU0uTwlaQBIBvsVS1jk?=
 =?us-ascii?Q?BjqfwsE3qftzY6cULbja+DJBC4WjYUl/UJVxsSKYrTCGECzDVLrBDDAhlphQ?=
 =?us-ascii?Q?+LXlHGLipsjWik2GUAvUMEIg3OMJUZEvGgZHDFIhyBaYptLIl5jcD/J7pfcD?=
 =?us-ascii?Q?nqF5fTmlb9K5KpZueyl6/dtY4ZmWj4M+sVS3CcEbjtPnRjy5SllZwvbgAVKX?=
 =?us-ascii?Q?1DLhSDgfbwg5OtFUtzXXA/5t4Rh6eOUcIEweaIvhdOXFusW4LqW+Pc9C4ky8?=
 =?us-ascii?Q?9oJDW3yuvVqNyQ5lh4XU3WhD+R7gOIJSx6WxLQuWkx+s0aAlZVJDSZsGvXCE?=
 =?us-ascii?Q?9PWc1D/PrgNhkZ8xK5Dev5Re4NLQIWj/PlOKGrcmrPiip+EBJcOQASwpkt0x?=
 =?us-ascii?Q?w6brk/T5F484Kyv00hecHiFSr58n6FLgecWryAWmmjCmDAsQAgcEPgl/tw5O?=
 =?us-ascii?Q?N5dEbvwRP8REjalHuAN7As7qlta6tO5Hj7SI0Msv5qjBDLyU3s8T7aiJrUr7?=
 =?us-ascii?Q?j9aztEpbkv/LZ7FS17Hm1nf7IC5ARCTT3ibrkMUYCzMi5u4DJlyRrKCwcPQd?=
 =?us-ascii?Q?hbu4CWsDB+cbikKxic8gU1q8Emjx3pjEMsDE/h0/tDr5FRf2Z4jVWgY7lS+k?=
 =?us-ascii?Q?7VULge8KGoiIsmuTIcqkS0YDSO5pBTsSs+/3HHOLaX/uMcKnq+6lR3m/XTb1?=
 =?us-ascii?Q?jtEV0O2uf6bryVQGT4TCkIufoNIEqz2sGjEKCq+aqvzvy28wCaej7P8o776Y?=
 =?us-ascii?Q?L2O0NfhujAErDW1gn6Xc3cqHnFBNziCLopg8v2tl78/BUhl4SM2ARPay8jaW?=
 =?us-ascii?Q?MQ+O4ExzH7HlqYDSkfs+TKfB5LJJ8LQne+fL/8SHbs9bK9NMn9EdkjhuN3UL?=
 =?us-ascii?Q?8r8mSc2gsGBI5DlgSDV5YrUOJsz1jbOicxM4cRAJEgKvKwojknMEZWB/tjFZ?=
 =?us-ascii?Q?N4y7w1m5Nx121W/x2S+D1+7nzGTDgNEdBIpUIcH3YjnTtlCakSuong=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR01MB7792.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(52116014)(366016)(7416014)(376014)(1800799024)(38350700014)(7053199007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?zXEXsBNz1hBvTbhkguF79ie5iDICpx2onG82Y4q5EEc8+zKQcMYK+OMfIoUG?=
 =?us-ascii?Q?EeOOKJC3ZAfKCDyahYXUZej1LYMIhVX8utosSq+1NXV4NcIRFP8fGKd+lKOg?=
 =?us-ascii?Q?zw0FZP3vCAn89ho+CPSIK+Yup4AWAfwM8V7jaYzCzDTWjU7USYBX/1cCGDOF?=
 =?us-ascii?Q?l3iRmqCbh/EBTblObcscwPKeur1kJYtkGdKJTp0jbFhxVT39ZAGRC7mphvBa?=
 =?us-ascii?Q?wVZgSt4LzSR2x9BZsEUwZjeTbtX+LeHs8DknKjHAeRL4qGWpaJtC2pRIqb+D?=
 =?us-ascii?Q?fMMbKQKeQB1GsELbTZN5C3zF8M35XrZul+Fst2cbzvl4agZEiHdw1GzZuovo?=
 =?us-ascii?Q?Ce4dOA2zZYzgXjXQSHRmQQZ3N2Ia1SeP1XIqjMwLtqfhocZYHZVNyJlAHIe9?=
 =?us-ascii?Q?jkgNQQgwqMvS/QXiQK6C+7kldPkQ9Hs/Umbssf2WtN7l2F9tQXZRK88Teh1r?=
 =?us-ascii?Q?3S1Hj845CY2++BmCN3v4vVKvkxkU6/9zgR/Xyvx8djfXq5cqmpMWZjGMsLMY?=
 =?us-ascii?Q?opVLAuRGIEw4u103l1S9XyeMUjy2kgca4iffVO71JbUypeAI7QOl9co9uWsf?=
 =?us-ascii?Q?wLA7uiTcoe2nx6LI5uTkkaN9DzkWZ850aPhFbFqyztQQSknBv4nWT/VX5Yf9?=
 =?us-ascii?Q?eXHab0v2WZOig0K2SHAbac6JVxE0Q2P4Eu5GVrk4laNdyvaZnHrq/tChXNU9?=
 =?us-ascii?Q?6aHvxHD8UHXOgiSSOSnARKKWLSoABntn2kN30wnwtbR46tV6AGD9cT6gDLtQ?=
 =?us-ascii?Q?k2QMEOdRFlx4Qj5taGJFabpedHMAfRLs9FR6A5tVvLSq+nxpi5wtzlD3uw+X?=
 =?us-ascii?Q?vpG5HNH2QQwGYwQg+p7SXa3erB+WMF9TCc0IhWaQyXHuvklOD0CnBoNbdk4O?=
 =?us-ascii?Q?4+cinbo88oBpwiaWcM8cjQ4SZV9es844FyugSni7RIHrFfFmJPwP12FP91jb?=
 =?us-ascii?Q?iC06q01DU4PWxOnxPy+kuadB4yj2PZz+C+d/Mporu1ZNkjIyS05fFp9E7KEt?=
 =?us-ascii?Q?fLn9TxUg0ObvKZB/jSABG+8rg33aGxyYyNt6YDDTq6wVbgA3rZWrN55X7f5O?=
 =?us-ascii?Q?rdWkfxTdJt+c8O+RibmvDXGcB0p9aoyPEFu11tjbL828Q4u9UEMgF1kLrFem?=
 =?us-ascii?Q?zF+noUbSkWs9S6vXTgblwJ1qL7qsCdceTRV8WQ1zGfyRihcIWwouBxP3iDwO?=
 =?us-ascii?Q?SYlixATuQF6U9exDf3w6Tp3+aKXWtJf2IczK5HxzyqivIVH9Km98gtgxazoc?=
 =?us-ascii?Q?7DlI90NIMXjRHjq6gLJ3TsqqjBxz/ZrCEUWBIhnlY4qZzuY1JpOQB0M5IPUc?=
 =?us-ascii?Q?VvtvujVW87+6OUrgZ+ZMyHli8Gq7QWl+39fPw7IHV4JPOCZuHK37oL955b4I?=
 =?us-ascii?Q?I3fdTOgd/gAzRavlU2h2JDIoGEzHaHy0+uaqNdZoYRBmu+sek8BXtqGxFNSR?=
 =?us-ascii?Q?j9tu0CGyx97YQdrC0QlhnAsrijgyhP+W/KzKZrxQjj+7cf7YM9/s6TayfI1B?=
 =?us-ascii?Q?d6WI0Pupv3xQiOGUzk2eQT/0LIzKfX1on5qfd0Vld0v4hKzsoMrdzs2R1JPX?=
 =?us-ascii?Q?IXP2iBdO9DMAbRGXoyQz9IzEX8Hs6ULjKKSpSp955Hgu4QpU3Ps03yv4G2Du?=
 =?us-ascii?Q?w8yH+1qU+/DbOioB7Qt/RNQ=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d2d1b2f-302d-41ab-0a88-08dd7d404efd
X-MS-Exchange-CrossTenant-AuthSource: LV2PR01MB7792.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2025 23:42:11.4543
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hFKmSCC+K1vWHAbZTqC+soEUzXTjmKxXdX7Ky+v9sro0TBJ7jy+xMan4wLZtPY43Oc2asE3Y8q4BXAk6YrjgNowNbhp0TGhXMrDnZiW4SvwrqYXSXwfR7AoVFstHw5g9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR01MB9009

Marc Zyngier <maz@kernel.org> writes:

> On Tue, 15 Apr 2025 16:46:55 +0100,
> D Scott Phillips <scott@os.amperecomputing.com> wrote:
>> 
>> In the skip_mmu_switch case, config.hcr was used uninitialized. On my
>> machine that caused garbage to be written to HCR_EL2 and then the CPU
>> got stuck at the synchronous exception handler. Also, the restore of
>> HCR_EL2 was missing at the end of the function in the same case.
>
> Huh, how embarrassing. Thanks for spotting this one.
>
>> 
>> In skip_mmu_switch case, initialize config.hcr with HCR_HOST_VHE_FLAGS.
>> 
>> Signed-off-by: D Scott Phillips <scott@os.amperecomputing.com>
>> ---
>>  arch/arm64/kvm/at.c | 8 ++++++--
>>  1 file changed, 6 insertions(+), 2 deletions(-)
>> 
>> diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
>> index f74a66ce3064b..ff4b06ce661af 100644
>> --- a/arch/arm64/kvm/at.c
>> +++ b/arch/arm64/kvm/at.c
>> @@ -1233,8 +1233,10 @@ static u64 __kvm_at_s1e01_fast(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
>>  	 * the right one (as we trapped from vEL2). If not, save the
>>  	 * full MMU context.
>>  	 */
>> -	if (vcpu_el2_e2h_is_set(vcpu) && vcpu_el2_tge_is_set(vcpu))
>> +	if (vcpu_el2_e2h_is_set(vcpu) && vcpu_el2_tge_is_set(vcpu)) {
>> +		config.hcr = read_sysreg(hcr_el2);
>>  		goto skip_mmu_switch;
>> +	}
>>  
>>  	/*
>>  	 * Obtaining the S2 MMU for a L2 is horribly racy, and we may not
>> @@ -1299,7 +1301,9 @@ static u64 __kvm_at_s1e01_fast(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
>>  	if (!fail)
>>  		par = read_sysreg_par();
>>  
>> -	if (!(vcpu_el2_e2h_is_set(vcpu) && vcpu_el2_tge_is_set(vcpu)))
>> +	if (vcpu_el2_e2h_is_set(vcpu) && vcpu_el2_tge_is_set(vcpu))
>> +		write_sysreg(config.hcr, hcr_el2);
>> +	else
>>  		__mmu_config_restore(&config);
>>  
>>  	return par;
>
> I think the diff below should do the trick (and incidently matches
> your commit message).

Looks good Marc, thanks

Reviewed-by: D Scott Phillips <scott@os.amperecomputing.com>

>
> Thanks,
>
> 	M.
>
> diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
> index f74a66ce3064b..773e3b4d5c7e5 100644
> --- a/arch/arm64/kvm/at.c
> +++ b/arch/arm64/kvm/at.c
> @@ -1214,7 +1214,7 @@ static u64 handle_at_slow(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
>   */
>  static u64 __kvm_at_s1e01_fast(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
>  {
> -	struct mmu_config config;
> +	struct mmu_config config = { .hcr = HCR_HOST_VHE_FLAGS, };
>  	struct kvm_s2_mmu *mmu;
>  	bool fail;
>  	u64 par;
> @@ -1301,6 +1301,8 @@ static u64 __kvm_at_s1e01_fast(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
>  
>  	if (!(vcpu_el2_e2h_is_set(vcpu) && vcpu_el2_tge_is_set(vcpu)))
>  		__mmu_config_restore(&config);
> +	else
> +		write_sysreg(config.hcr, hcr_el2);
>  
>  	return par;
>  }
>
> -- 
> Without deviation from the norm, progress is not possible.
