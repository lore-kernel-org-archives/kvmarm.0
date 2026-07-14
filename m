Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11022097.outbound.protection.outlook.com [52.101.48.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 518092DB78C
	for <kvmarm@lists.linux.dev>; Tue, 14 Jul 2026 23:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.97
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784070374; cv=fail; b=FQ/uh7qay61bRVAzzY04CAerjE2CqRwszYKP8dUNq3ObRZBm8/dS6QmVJKVHM+ZOxxGiNQVzMPhIe0WMbhintt5kIKHtE1vJ2D15zLAM5BDE4DgaS760DfmlMgO7ezEPufOCNNJ3py3ChAYqdw3jsiG9Lrqigmm/LpwG6qsnDCE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784070374; c=relaxed/simple;
	bh=DlYnhLe62dy6Qpe+KNsapyXS2ZF36rOX47n6maEkB7Y=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 Content-Type:MIME-Version; b=ewYI6Hq1cIbg6O8Y1khXuARicW1qCS8ZiqEvlYDp8JMmcnehDzyjfJoNUvDzWP7yGdNw6WWqXxvK6oAAv+TPUbm3pATO3V4O4TuRk70ft+lokvYUyH6DtbL2UQSANrLB/2nvLBs++yAP9niS7VT49JEogX9IuDScYM80Zwjr7SM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com; spf=pass smtp.mailfrom=os.amperecomputing.com; dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b=AkaNXNpA; arc=fail smtp.client-ip=52.101.48.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b="AkaNXNpA"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sdZCLoNe7VSeGQrcLnZ0VpDvuz9D7XJ6iCkkRyYJKmV6q30sosD2Xyi5s851lLuILCXrAdq0qA1BhMLgCAdZ76KK45Qw08cjlvzhq4v8YDH+ORAUpxRSlxzTtX/VDXVDIM+z7F1kIO9f2RrzAT98H0qcvYHcg5cIcyZH2//Xy2U7IZvv4xNL3Kk9c0TkLNegNM8iHBXV7l3cj0cbq67fg4yxj2gk1sYsp1Fp116oOSs0OhTPMURKCp6W/fPPFtap5Hq11pR9rwGZ2YkFUMuDFXSBuvBUVADnjt1AaTHC9WY38rK+jJ9sY1RGYyQKUDyLTocmCER3nLlM0tPFHgl3oA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i+CcBB3j488jkuKx+KOLwWykGtY25VR7Awhl1bqG3Ig=;
 b=XIowwivS2JI9FaPiQwNhNarQ802tHm55LRqKnfab/wg/aIRuDHUgdnVlLX8lPeD+jAprD6B3bKx471+MyFfZ+0PySKLNYG7GYas7BQPzCnspMnUdaUialL5Js+QZ0xW0OkbQ/5YyZjUMVrY5Un/AGQSNKEh/afROpeo9tE0aq2Qn2BilgcpsQ5n6ei4uhRcZxuZqQzeWF3HJbawWd1QlioGE8+WiXt0/o/3ALrXMffafaOFZuQgLUOkTUVvQhxJLgQkZtLKs4IEQHqUWMzV7cvKqttmS2s8A+q10tU2OlocbPbKrIcgOOSnfx37O4btWBl7+HKHje7MPyI9fR6PvyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i+CcBB3j488jkuKx+KOLwWykGtY25VR7Awhl1bqG3Ig=;
 b=AkaNXNpAD1z3q011eEbLfadBgcV8KrtXpjyBXQktabtUPFRpIuAocEQNu9jmsP+tVF98UljNArfC7+uytwrBy6Z5P1lUrBQBnWjABjxRCl8Wqrpj2cjcE+eAzl46hXxuiBbDvtraQKXKcgAsJl/+v5nf05DfmDHks5AqKz4tCI0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from LV2PR01MB7792.prod.exchangelabs.com (2603:10b6:408:14f::10) by
 LV0PR01MB994054.prod.exchangelabs.com (2603:10b6:408:330::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.202.18; Tue, 14 Jul 2026 23:06:05 +0000
Received: from LV2PR01MB7792.prod.exchangelabs.com
 ([fe80::3ee4:7b7c:ee84:7c1a]) by LV2PR01MB7792.prod.exchangelabs.com
 ([fe80::3ee4:7b7c:ee84:7c1a%4]) with mapi id 15.21.0202.014; Tue, 14 Jul 2026
 23:06:05 +0000
From: D Scott Phillips <scott@os.amperecomputing.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>, Catalin Marinas
 <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Jonathan Corbet
 <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, Joey Gouly
 <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, Suzuki K
 Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, Mark
 Rutland <mark.rutland@arm.com>, Zeng Heng <zengheng4@huawei.com>, Wei Xu
 <xuwei5@hisilicon.com>, Vladimir Murzin <vladimir.murzin@arm.com>, Lucas
 Wei <lucaswei@google.com>, Kuninori Morimoto
 <kuninori.morimoto.gx@renesas.com>, Sascha Bischoff
 <Sascha.Bischoff@arm.com>, Yicong Yang <yangyicong@hisilicon.com>, Yeoreum
 Yun <yeoreum.yun@arm.com>, linux-arm-kernel@lists.infradead.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 kvmarm@lists.linux.dev
Subject: Re: [PATCH] arm64: errata: Mitigate AmpereOne erratum AC03_CPU_57
 and AC04_CPU_29
In-Reply-To: <87mrvy5640.wl-maz@kernel.org>
References: <20260710222128.416581-1-scott@os.amperecomputing.com>
 <87mrvy5640.wl-maz@kernel.org>
Date: Tue, 14 Jul 2026 16:06:00 -0700
Message-ID: <86jyqx189z.fsf@scott-ph-mail.amperecomputing.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0108.namprd04.prod.outlook.com
 (2603:10b6:303:83::23) To LV2PR01MB7792.prod.exchangelabs.com
 (2603:10b6:408:14f::10)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR01MB7792:EE_|LV0PR01MB994054:EE_
X-MS-Office365-Filtering-Correlation-Id: 25f3fa85-618a-4f8e-0631-08dee1fc7b44
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|376014|366016|1800799024|6133799003|5023799004|56012099006|11063799006|4143699003|18002099003|22082099003|55112099003;
X-Microsoft-Antispam-Message-Info:
	GePt5WzbUGRCiuhgWNVtcn00Z4eXV2Cj2GlRxs3WUILgYjSA369igLBoucIV24G6tconNp4Ai+7iItZwXPrsCIOsqbJBCdUolURHZP4CIZQ25I/pOxyv8qt3yE0/DCynIrIYIghfjxlnu9f75d4NyLHMKc0b3q6dLAgIc7Q+egN1XEQa+hWKQ/D3CfgithWye09MlwnQ6rGWMYyGRZg9X8VM7liaEaOZqv8JKGQc3iJIYRpwVzHpOLvYba4Jw8F0aerZRJ6havAtusTsZklqdpadiwqSv7pDQMSOuOqVxKiJRGqKp5Kt2bGn+yfkFmKjmXqR3a5VbRRmpoYlSXRsM52MxmyrbjTMeKjNGCERN9mGsWb1RVV8sKL4liZT8Nu7cnXCe8GBpZ0vGaonaBXFMYlJvee0qPoJocE9PuwJiUmonFjFF4zJpMBwae+qzqTU4bQvxQ+FOufIwIikAuFNb0ZsEIUl8/jJJ1wASCM4SFAv0lAHgZZrIL3aQf9gvn5Vwn9WnADOzGKCTw7GjJ8mXCzSK5dB5tmeU9cMF7XXuMu/ZmH49ovHledxmv6y6ie6u8y6YuHbIyKFtRwknRHjmz9Crsl3+Rmt2h+DxI3QrsFRCFw1hPH4UN7vYN2Sx5ScPFSdcFQ7OITs+JitWSY86CJ+wtPGCJD1T664g1LRe0A=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR01MB7792.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(366016)(1800799024)(6133799003)(5023799004)(56012099006)(11063799006)(4143699003)(18002099003)(22082099003)(55112099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2mniLiovGqVT9VlIXwkQZRmPD4/+QEW6Kx4SAvovCAKtoggho4zfRMLy995A?=
 =?us-ascii?Q?4Ok35/QY59CeSCsc1O+VAjkwv084OZ+cU5ojkPKdCLFo1O+h6pNUHHmPs8RI?=
 =?us-ascii?Q?fnDPVJ8k+DcvuJCWboCT0f0I7DorSDy4yMMEZ0xgxFSK1BQdc6+ywEosutOA?=
 =?us-ascii?Q?ROrpOso5LvuowfixhBLD81H111VDivBWL7r4rhgtyv2sKEzxGsCZl/b1d4jl?=
 =?us-ascii?Q?7PvCNK7fpsU1vzIa9dwhkpKodYbFT96/kckoWR6N9XC+ydw5hE4DB3Fqr5SL?=
 =?us-ascii?Q?G03TxIBJ1eKarYd5oRgScAyQo5+pYtszk1fk3hnk4C5OYdC6jVD4WXpkxiMA?=
 =?us-ascii?Q?6+7Jn0hukmWx1aVjRJ8MZx0j24D6EW7+qxdNnfd1OgYe1FztJrvceIIba5Il?=
 =?us-ascii?Q?OBd43ZhZlhHnFG/Hw8DNH7S385Wa9wiu8sCrKCQ+L7tTutRI73pTzP4VNEUr?=
 =?us-ascii?Q?fOdNi0pwSMae1JObBxkrhI2KzMKXmX2CXB7RUpeGB4SYJU7n2DjFoL8YH5I5?=
 =?us-ascii?Q?zCnVBkABY5PcS2X5gGtGu7A4Niijuw+LV8axjV/q4/3BbdVVcp6CVgE0RHXJ?=
 =?us-ascii?Q?5ASRR25uWZ+CX2rUnLG8Dnr/zk/kSpfH49AHpgDgwi6A1m3QGSppagoEhjPV?=
 =?us-ascii?Q?1ys96gGrM24xucrxu2nE71Tjs2xPzIyQFU8rnIWWpxVPUKU2CNC+h+Kf5Q/I?=
 =?us-ascii?Q?Dr21wlW1ITWElXCIvgaDHWtHieR5N31dlcnMXUnkNCUX55QMwbkb39j4gy1L?=
 =?us-ascii?Q?dp4cEpGVDVVSjb/fN4PwiIni8RDh5FVi/FnQiW8z51bEaO17glfXBb78CH0L?=
 =?us-ascii?Q?+/861unYNIKSGjvB2Vrgv020vzGRDs9Kl8BlRvLST4Ai/gKVm/Uc35EQIHUg?=
 =?us-ascii?Q?XX9Gjve9FEn9eLVkiM6xvWP4S1dYEUcADpClUtl+sgDpihYmVvLH7/Rh02tk?=
 =?us-ascii?Q?VFIEgNZNIgj+XGX4bYBZN4zyf12cKWyFXeGuhK5RmNOkniqJWW/IX4LOOXHk?=
 =?us-ascii?Q?fs53ZlrFvDwwlkNn08MDSP6bk8YNwTwIIXhaqIj44PPalDQwIuxn4OSxwM7A?=
 =?us-ascii?Q?uVJ/MgaWLgjHTl2WXol+9J/8OrReZ0TilCwjY0XGJm9cHL2a9KU+OthjxnME?=
 =?us-ascii?Q?qcByXuEtzu21TzMc4kjujfbycHjKp+bPaQ/UDx4kiP4t5Q8LIKjP4DAPcoft?=
 =?us-ascii?Q?TQCFWltIV2pn3EWpkw/rMbUTwv0/pM9qw9JfyG15D3FHGwZXYoBwM2wqBIVq?=
 =?us-ascii?Q?oxI6M69KdQy4Cyqgh5sBPLj7ol/gi0/Y7RpoOZwlhgEeU0K+LvTKfl7LGZKF?=
 =?us-ascii?Q?mwM+xxwDjvPD30deajHiVzDCmZQBeqZW7ttBmvS20RYqxW8l6HTcE2ZD9tWp?=
 =?us-ascii?Q?YFtblaYl2wdw4aSLTyFTUudEJ9KL38JUILE5eDfZ4B6PVyRrQc8eJ2tmdMjd?=
 =?us-ascii?Q?QCSMF9vnLQ2tFgWn385ZZtGnsUG8dgdjFQ9X8Ijrgx6F73U6+RBm/jpjjt0c?=
 =?us-ascii?Q?U3jYeoi5tWcV2nx7SoOTMz75OWFT5m41bAriZHgO3GcHSb7XJ9qC+GjuUf8M?=
 =?us-ascii?Q?LA9RJQnbFS1M3bWZLzMiy+Nyr3CJdciBuIQ18V643+k7cg5AMG1Tdta30VI7?=
 =?us-ascii?Q?Vg0GJjgaVIscTDfqqrWt2FB6a2cV6izv5cVVQKSecIi8FaBJGJuL3US7fI+j?=
 =?us-ascii?Q?pC3j6znsYkIFocbvUaRLIiUXs+ndDO15jUMym27zvH7LVNjAhLs13lAu9OVE?=
 =?us-ascii?Q?uSjKHkJlz41MGJggVuMO02qv22nBhO0=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25f3fa85-618a-4f8e-0631-08dee1fc7b44
X-MS-Exchange-CrossTenant-AuthSource: LV2PR01MB7792.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2026 23:06:05.0934
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lOSNC/91bLJatmVngzaDGT+0LtdpAN4XvdFWM5j0PXrUlbiHwtaGyQB3Hnhd60C/gPP0kn0tW4b/vy1lQgoToLN9OrOc3XGBmxgLxKjwIlEQVLro1Flxt378/y1ZlVTr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV0PR01MB994054

Marc Zyngier <maz@kernel.org> writes:

> Hi Scott,
>
> On Fri, 10 Jul 2026 23:21:28 +0100,
> D Scott Phillips <scott@os.amperecomputing.com> wrote:
>> 
>> On AmpereOne, deactivating a physical interrupt through ICC_DIR_EL1 or
>> ICC_EOIRx_EL1 (depending on EOImode) which is not active, but is the
>> highest priority pending interrupt causes the cpu to lose the interrupt
>> pending state and also prevents the delivery of future interrupts.
>>
>> Work around this in the vgic, avoiding the cpu issue.
>
> Thanks for getting to the bottom of this.
>
>> 
>> Signed-off-by: D Scott Phillips <scott@os.amperecomputing.com>
>> ---
>> 
>> Hi Marc, we've tracked down the nested virt hang reported
>> previously[1] to a cpu erratum in AmpereOne[2].
>> 
>> Here I'm just sort of parroting the change you had posted for
>> debugging. I'm not familiar with the vgic logic well enough to know if
>> this change is sufficient and doesn't have some unintended
>> consequences. I guess read this more are as "I've tested this and I'm
>> not seeing it hang now."
>>
>> Sorry for sending this half-baked, I didn't want to further delay the
>> errata details on my ongoing vgic education. I'm happy to take any
>> advice you can give, otherwise I'll continue familiarizing myself and
>> will hopefully later have a patch which I can actually claim I think is
>> correct.
>
> No worries.
>
> To be perfectly clear, what I posted at [1] *is* a bug-fix. A very
> minor one. Nothing wrong should come as a result, except when it does,
> such as in your case.
>
> The core reason why this happens is that the L2 will have EOI'd its
> timer, and that the HW bit set in the LR will have propagated the
> deactivation all the way to the HW redistributor. Then L1 takes over,
> and needs to reconcile the LR state with its own, namely its view of
> the active state.
>
> The issue here is that when dealing with a nested vgic (the state
> contained in the LRs is for L2, not L1), the deactivation process
> doesn't need to involve the HW again -- this has already be dealt
> with, and results in the double deactivation I mentioned in my email.

Ah ok, thanks, I think I get it.

>> 
>> [1]: https://lore.kernel.org/linux-arm-kernel/87ecjybz30.wl-maz@kernel.org/
>> 
>> [2]: https://amperecomputing.com/products/developer-errata
>> 
>> The updates with AC03_CPU_57 and AC04_CPU_29 have not yet been
>> published at the time I'm writing this. They should be coming
>> soon. I've reproduced the full entries from those two coming documents
>> collapsed together below:
>> 
>> | {AC03_CPU_57, AC04_CPU_29}: Deactivation of the non-active, highest
>> | priority pending interrupt prevents further interrupt delivery.
>> |
>> | Functional Unit: CPU
>> |
>> | Category: 4
>> |
>> | Affected Version(s): AmpereOne AC03 A0, AmpereOne AC03 B0
>> | Affected Version(s): AmpereOne AC04 A0, AmpereOne AC04_1 A0
>> |
>> | Fixed Version(s): Open
>> |
>> | Overview:
>> |
>> | If software directly deactivates a physical interrupt which is not
>> | in the active state, and the interrupt is also currently the highest
>> | priority pending interrupt, then interrupt delivery will cease on
>> | that PE. Deactivation can happen either through ICC_EOIRx_EL1 if
>> | ICC_CTLR_EL1.EOIMode==0, or through ICC_DIR_EL1 if
>> | ICC_CTLR_EL1.EOIMode==1. Deactivation of virtual interrupts that are
>> | redirected through ICV_ registers will not cause this issue, even
>> | when the virtual interrupt deactivation triggers a physical
>> | interrupt deactivation through ICH_LR<n>_EL2.HW=1.
>
> OK, that's pretty good news. Can I safely assume that your HW doesn't
> support VLPIs/VSGIs in any form (no GICv4+)?

AmpereOne AC04 does have gicv4.1 with vlpis/vsgis. Those take a
different enough path in the core that a deactivation of a pending
vlpi/vsgi won't cause the issue. The wording about "physical interrupt"
is meant to exclude vlpis/vsgis, sorry that it didn't come out clearly.

>> |
>> | This has been observed with Nested Virtualization starting with
>> | Linux-KVM v6.19.
>> |
>> | Impact:
>> |
>> | Physical interrupts will not be delivered after the deactivation of
>> | the non-active, highest priority pending interrupt. A core may
>> | appear to be hung.
>> |
>> | Workaround:
>> |
>> | Software must only deactivate interrupts which are currently active
>> 
>> 
>>  Documentation/arch/arm64/silicon-errata.rst |  4 ++++
>>  arch/arm64/Kconfig                          | 17 +++++++++++++++++
>>  arch/arm64/kernel/cpu_errata.c              | 15 +++++++++++++++
>>  arch/arm64/kvm/vgic/vgic-v3.c               |  4 +++-
>>  arch/arm64/tools/cpucaps                    |  1 +
>>  5 files changed, 40 insertions(+), 1 deletion(-)
>> 
>> diff --git a/Documentation/arch/arm64/silicon-errata.rst b/Documentation/arch/arm64/silicon-errata.rst
>> index 014aa1c215a16..89130404ce572 100644
>> --- a/Documentation/arch/arm64/silicon-errata.rst
>> +++ b/Documentation/arch/arm64/silicon-errata.rst
>> @@ -55,10 +55,14 @@ stable kernels.
>>  +----------------+-----------------+-----------------+-----------------------------+
>>  | Ampere         | AmpereOne       | AC03_CPU_38     | AMPERE_ERRATUM_AC03_CPU_38  |
>>  +----------------+-----------------+-----------------+-----------------------------+
>> +| Ampere         | AmpereOne       | AC03_CPU_57     | AMPERE_ERRATUM_AC03_CPU_57  |
>> ++----------------+-----------------+-----------------+-----------------------------+
>>  | Ampere         | AmpereOne AC04  | AC04_CPU_10     | AMPERE_ERRATUM_AC03_CPU_38  |
>>  +----------------+-----------------+-----------------+-----------------------------+
>>  | Ampere         | AmpereOne AC04  | AC04_CPU_23     | AMPERE_ERRATUM_AC04_CPU_23  |
>>  +----------------+-----------------+-----------------+-----------------------------+
>> +| Ampere         | AmpereOne AC04  | AC04_CPU_29     | AMPERE_ERRATUM_AC03_CPU_57  |
>> ++----------------+-----------------+-----------------+-----------------------------+
>>  +----------------+-----------------+-----------------+-----------------------------+
>>  | ARM            | Cortex-A510     | #2457168        | ARM64_ERRATUM_2457168       |
>>  +----------------+-----------------+-----------------+-----------------------------+
>> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
>> index b3afe0688919b..ee5421283d8df 100644
>> --- a/arch/arm64/Kconfig
>> +++ b/arch/arm64/Kconfig
>> @@ -436,6 +436,23 @@ config AMPERE_ERRATUM_AC03_CPU_38
>>  
>>  	  If unsure, say Y.
>>  
>> +config AMPERE_ERRATUM_AC03_CPU_57
>> +	bool "AmpereOne: AC03_CPU_57: Deactivation of the non-active, highest priority pending interrupt prevents further interrupt delivery."
>> +	default y
>> +	help
>> +	  This option adds an alternative code sequence to work around Ampere
>> +	  errata AC03_CPU_57 and AC04_CPU_29 on AmpereOne.
>> +
>> +	  Deactivating a physical interrupt through ICC_DIR_EL1 or
>> +	  ICC_EOIR1_EL1 (depending on EOImode) which is not active, but is the
>> +	  highest priority pending interrupt causes the cpu to lose the
>> +	  interrupt pending state and also prevents the delivery of future
>> +	  interrupts.
>> +
>> +	  The workaround is for KVM to not deactivate interrupts for nested vgics.
>> +
>> +	  If unsure, say Y.
>> +
>>  config AMPERE_ERRATUM_AC04_CPU_23
>>          bool "AmpereOne: AC04_CPU_23:  Failure to synchronize writes to HCR_EL2 may corrupt address translations."
>>  	default y
>> diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
>> index 1995e1198648e..9b03dccd55e09 100644
>> --- a/arch/arm64/kernel/cpu_errata.c
>> +++ b/arch/arm64/kernel/cpu_errata.c
>> @@ -631,6 +631,14 @@ static const struct midr_range erratum_ac03_cpu_38_list[] = {
>>  };
>>  #endif
>>  
>> +#ifdef CONFIG_AMPERE_ERRATUM_AC03_CPU_57
>> +static const struct midr_range erratum_ac03_cpu_57_list[] = {
>> +	MIDR_ALL_VERSIONS(MIDR_AMPERE1),
>> +	MIDR_ALL_VERSIONS(MIDR_AMPERE1A),
>> +	{},
>> +};
>> +#endif
>> +
>>  #ifdef CONFIG_AMPERE_ERRATUM_AC04_CPU_23
>>  static const struct midr_range erratum_ac04_cpu_23_list[] = {
>>  	MIDR_ALL_VERSIONS(MIDR_AMPERE1A),
>> @@ -987,6 +995,13 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
>>  		ERRATA_MIDR_RANGE_LIST(erratum_ac03_cpu_38_list),
>>  	},
>>  #endif
>> +#ifdef CONFIG_AMPERE_ERRATUM_AC03_CPU_57
>> +	{
>> +		.desc = "AmpereOne erratum AC03_CPU_57",
>> +		.capability = ARM64_WORKAROUND_AMPERE_AC03_CPU_57,
>> +		ERRATA_MIDR_RANGE_LIST(erratum_ac03_cpu_57_list),
>> +	},
>> +#endif
>>  #ifdef CONFIG_AMPERE_ERRATUM_AC04_CPU_23
>>  	{
>>  		.desc = "AmpereOne erratum AC04_CPU_23",
>> diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
>> index 9e841e7afd4a7..8f1d10872360c 100644
>> --- a/arch/arm64/kvm/vgic/vgic-v3.c
>> +++ b/arch/arm64/kvm/vgic/vgic-v3.c
>> @@ -275,7 +275,9 @@ void vgic_v3_deactivate(struct kvm_vcpu *vcpu, u64 val)
>>  		lr = vgic_v3_compute_lr(vcpu, irq) & ~ICH_LR_ACTIVE_BIT;
>>  	}
>>  
>> -	if (lr & ICH_LR_HW)
>> +	if ((lr & ICH_LR_HW) &&
>> +	    !(cpus_have_final_cap(ARM64_WORKAROUND_AMPERE_AC03_CPU_57) &&
>> +	      vgic_state_is_nested(vcpu)))
>>  		vgic_v3_deactivate_phys(FIELD_GET(ICH_LR_PHYS_ID_MASK, lr));
>
> I think this is slightly overkill. The hack I posted should be enough,
> and we can replace all the capability business with a simple comment
> referencing the errata numbers and the entries in silicon-errata.rst.
>
> Use the information provided above to beef up the commit message and
> stick:
>
> Cc: stable@vger.kernel.org
> Fixes: 6dd333c8942b2 ("KVM: arm64: GICv3: nv: Plug L1 LR sync into deactivation primitive")
>
> so that we know how far this needs to be backported.

Thanks, will do
