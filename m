Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11021085.outbound.protection.outlook.com [52.101.62.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A067623C8CB
	for <kvmarm@lists.linux.dev>; Wed, 16 Apr 2025 23:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744846894; cv=fail; b=U0te7+yoDwMJGMNPuldSDy5CvP43sEPUu9df6i8VeLr3eWGvEX2w3Vft6WMbkdw4nP6RnOURlTV/IL4nJWAYEp2IKLqK4EZe2TEZtatEmyooyxoSXTUxTo1mPFKD/LKuuINJXzABRnHe/+GZU4ejszoPJMtaGAXF957vdfhthKE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744846894; c=relaxed/simple;
	bh=/+GdQNjHBx7xQc8bTVX1SUJHVpUSULa1DWmcmPD2+to=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 Content-Type:MIME-Version; b=gQk4qnQkEdr7l+TGl/uq8jjpYl4nSlpObykH28An4JLl8qmiGs7swK2ZXFm2zXU94nx+3GWRoCjKjYsTDUCJq0sB6xbe7fPWQV9jEBRrXhXURlGnpszj8IbexQmSkXiAGg99Rw+h+T9xIre+FkgV6wOMbXSDjRjsPOWfpKUyDzw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com; spf=pass smtp.mailfrom=os.amperecomputing.com; dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b=fpHVstPK; arc=fail smtp.client-ip=52.101.62.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b="fpHVstPK"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VJwBKxb5QfzIJvL3zdBee5u198S8LoEwobsjAn0N5rlR50p2LTyUXFaj3JE9fvDKBCMWzVyVm7hs8odaOX1E4wpqDGljYgjgvi7au3D4hfyMVG1y337SdBOZhEgl/724RGKG5aM6KTz5lMOYsen7m12dBgm2DOqMaQ43c9b3LBl05An3LsAcFG4upQkHswbAdUqHYmLvdbkGz2DcI0dJF9KVGcsYZAlHKhKrt7Iex1hmN3wm2fk3FSY8VBwrB7q/HC6KTZag8Pb6swOSnlc/aHMfpbp/aAz9PEwSlWKaQ5P8LdowjVdyqbywQfwJ/EqQkFqyjLdfC2DlpKkc2YN6tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MZwA1dfoRctUeVrl2BPLQ7U8hCqiqxDEH/c5bwbai7w=;
 b=hsJvk02QG+wp4yNXuvFuuCdigm+Dp6/G6K2zeQB0WKQ+C9nItA6oAAeOv2FtYfjYUn3GsFpESLoA0UAVGrmAq+ADcE6OM1Sag2Dgz0Y2u59tfMBFDaEiPBjyZgEJ0tcWAPJnbmHcTxUKZgDlxSGRPiMEZ3VM/P/v9Tv8wQOFthEp4bj9fe5r369Yjn9TPczm61xdhI7qcifD1g2dwACC0zt/8cLjeahkkiV2LWP5qBOfVhlLa/wD6NrmzHhp5UzwGdTm9eNjXbnfluZ1LKAg2Tqj7/4mZEg0HgEIfESv7rA1dgupuoV8VWLaj/MQCdrd1bG+X1Y5aX+A7zrWCjs1SA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MZwA1dfoRctUeVrl2BPLQ7U8hCqiqxDEH/c5bwbai7w=;
 b=fpHVstPK4umY4wCbdv/8g8SVxFmdadY4rimf9m3xiI5AY5BuW/uOuq1szsSZVI1oUE1YNppw6tSbTJWimiLvgYNwJNe0b5pZdBSoCocrOzr9Sp9wl9gv5LGihAbAeDvV5cS6SyX13OSnOFBIxY4CS4kU5vXILqV9MxGjlVS2kH0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from LV2PR01MB7792.prod.exchangelabs.com (2603:10b6:408:14f::10) by
 SJ0PR01MB6205.prod.exchangelabs.com (2603:10b6:a03:297::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8606.32; Wed, 16 Apr 2025 23:41:22 +0000
Received: from LV2PR01MB7792.prod.exchangelabs.com
 ([fe80::2349:ebe6:2948:adb9]) by LV2PR01MB7792.prod.exchangelabs.com
 ([fe80::2349:ebe6:2948:adb9%5]) with mapi id 15.20.8655.022; Wed, 16 Apr 2025
 23:41:22 +0000
From: D Scott Phillips <scott@os.amperecomputing.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Joey Gouly
 <joey.gouly@arm.com>, Oliver Upton <oliver.upton@linux.dev>, Suzuki K
 Poulose <suzuki.poulose@arm.com>, Will Deacon <will@kernel.org>, Zenghui
 Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] KVM: arm64: Avoid blocking irqs when tlb
 flushing/ATing with HCR.TGE=0
In-Reply-To: <861pttl1g0.wl-maz@kernel.org>
References: <20250415154656.1698522-1-scott@os.amperecomputing.com>
 <20250415154656.1698522-2-scott@os.amperecomputing.com>
 <861pttl1g0.wl-maz@kernel.org>
Date: Wed, 16 Apr 2025 15:59:49 -0700
Message-ID: <86v7r3yaoq.fsf@scott-ph-mail.amperecomputing.com>
Content-Type: text/plain
X-ClientProxiedBy: BY5PR17CA0048.namprd17.prod.outlook.com
 (2603:10b6:a03:167::25) To LV2PR01MB7792.prod.exchangelabs.com
 (2603:10b6:408:14f::10)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR01MB7792:EE_|SJ0PR01MB6205:EE_
X-MS-Office365-Filtering-Correlation-Id: 6d2b7fce-24e9-4ba2-baeb-08dd7d40318f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|52116014|1800799024|38350700014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?qmQJI9R99QVIMrny9zxEu1qUABJDWG+f+LaZB/HRXUrCjkqQO8BoP7A5bjuo?=
 =?us-ascii?Q?1xwtmt4DpXKPecf4vpOEfn2/orCaJP2uCGoAiYdr6BVlTO1Yik13YIlX7nfq?=
 =?us-ascii?Q?FLnbeAQGC7Xm3hhP9YBBuonL0fG9/WT2/4y5ygO/5e0XEwHmsLjvJCR2Myx6?=
 =?us-ascii?Q?IHYqf2ZaR2JpVpg7m3seajZJrl/enk6FeUTwfDmldkXOg9blSanvTjjd8zQN?=
 =?us-ascii?Q?h0/3BTY0feHb/rLDLJ4CQSpzvd/qU5NZMP6A4jaf4gLte67yshZrWo4XEg3T?=
 =?us-ascii?Q?uyz97ZLMD3TI3OzJtnvcTBbDtDnkh129dpcPrCOXBlo6fJam0ilgSHnuFudW?=
 =?us-ascii?Q?kNUjHkCGtCZZQAuAr6bLsAp5dgS1Z/EKWJq1LO3u3ilLrS/bAl67vKYiDR/M?=
 =?us-ascii?Q?AhDbHDc7YThK4yzAlNqLcFJIsjcCbJEG3jFKVzS8S354lui2JgQgn2d1uEzg?=
 =?us-ascii?Q?/fOFHv3lI6JuIOF5+Up3KQj2HjhfPJHLxAPg8mPGqQ8r3Uj3xkU7raNqbBHp?=
 =?us-ascii?Q?E0GtJIF8KJy4NZSnMem66teh7VOuyGUG+eui6w+fiLELwTw/aU9r3jd13F2R?=
 =?us-ascii?Q?KtNFlIqGOSKtkmQsYQyG9ZUFZw67xIUzgWz8MZsNpoM6DPHzlxIertYa5Iij?=
 =?us-ascii?Q?UpnQjeglJ8Kkf5rigOu1O9kIWILAmCiXD5keUOwG3nAGtGMthABe3KI2bFc9?=
 =?us-ascii?Q?pvQSpj3vNtXCz2GFOnbCevie4yqDL2d2qtdUNZmWZ8wSELBASmnBPkjTvZy7?=
 =?us-ascii?Q?cxsw/9m26ZqetORkYzXo2l0Dc+3qbMwx6DCI5OoaJnxmiK/pvVPdt6Q349a3?=
 =?us-ascii?Q?tpzVxVgcoRXmbg72EZN+QWb1xirDZiH61ugKFnYjEjRoCAhO3eF4xM7JB718?=
 =?us-ascii?Q?me4mI9td4x8jmQWutbVEQUR6fpBrT5xgxDNRR8vSBCJ6jb70eVjCkcDGDpBI?=
 =?us-ascii?Q?GoxfyZ4l1gGysED1KGosQKzAgVdbBmmll50u0lFcqHakS5QVk1EB/B0PSrI7?=
 =?us-ascii?Q?3nOhStU68Ex881J8fjUfoNQtMWU+SS86Yp4TC8O9nFXKe046yPvq0YwEfDIv?=
 =?us-ascii?Q?7DYrXKkybOev/dJi7gryfgzLOz1E2tTL0du3MbDxZZ6QUU6GZ1xK25MI9UCq?=
 =?us-ascii?Q?ab7c6m43KPgigKL5bE27cp9ddUS2B6r46SSkMwbKqFzdfIozu+CdWIPZjASi?=
 =?us-ascii?Q?5D1HvhldEvgnBNUGMLzdp2+/NEhnFv/0k/eiLC+lOTKKPFVhbTAhvSJ945IQ?=
 =?us-ascii?Q?u+nh6PXluSZDBf/3cgBviUbwtddNijUNqpk+xgjttfXMnD0y91ZsJUaoHSlT?=
 =?us-ascii?Q?5aK9U94UZTJHXophpMl47s0HXuTD1/eGpruFUQ6rq1DcAQ6cTNtMDEU+9UP1?=
 =?us-ascii?Q?6eXCawmuvrZEFPvPzxD+bCV9f64qKN1pLhNgtEbHuLnsmx9UUI3dKDbvSImp?=
 =?us-ascii?Q?X9JHE2y9ZXFdaRSYBknxl5Xzq9wlzovUPcDWx1Ovn+Zi855hSZc1cQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR01MB7792.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(52116014)(1800799024)(38350700014)(7053199007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Fz+/Gd9M1RKbQRafhQFM6sh82rrmXIcq1hsmRZVcN5wjkNRRhsiY4cxbiVLR?=
 =?us-ascii?Q?Mdk7Np9BueX9vu6+rKijA+iNQhZAbo1aKiZ+5hn4Yno1oUF7esYacWAWgBzV?=
 =?us-ascii?Q?JvYaWBYiTp5YDgsGkCoRwb/nUZzFbjD72oON6KHCwMv7brEaot9dWIU/xkeg?=
 =?us-ascii?Q?lZzm4AGEyKF9Wc6TkiaVmvKL3e8NyRaqtcQN0bIeTiloJL4fQUJJ/mk6gPNa?=
 =?us-ascii?Q?1ZAgOeZY0IjhI8PHBdyTMW+8pc4F5EPqF81mp5JTQoPAxnrOBEwxaofAkr7t?=
 =?us-ascii?Q?z2kFx51ghBUB0/PB8Uoe50OcoleMnTPmQnPY9/YZUlFfaObPvwL+X+bg3sOZ?=
 =?us-ascii?Q?yqh9pHcqRGMqnsGZvnDvJG+q0cNllxLBlhsfWeJu1rdM4jfPjQLztdqb2Ejq?=
 =?us-ascii?Q?AyfmH9EQ3xP3syfF9burAGIic+0hIZDXg/wuf4/FcJX4R+MwIM10EFpG5xsO?=
 =?us-ascii?Q?SmgONflZdvBgndrgVDWo9gmSUNUkVVkeu9dWXJ15SmjWuP88MWppLiuPEzzE?=
 =?us-ascii?Q?1PQOgYvRqZgRimBWuf/ISS3ERnbYFn+x0XBn9yZ3F1MAFyDApKgxscJOLIzU?=
 =?us-ascii?Q?PIW9f6Ahv61z1pJy6AxfviMzeIqmdPOaAAQs0m3MuEyPyx/KhBL41QZcZtx5?=
 =?us-ascii?Q?buqpmEBKRYHIrAqKoJYu6pmK4LfnCoDpsMyWHhk4Fd3LMDzbS4xH1S5Q/oeA?=
 =?us-ascii?Q?AfTZbF5PjwJHj5mM4ujUFwL6QfK71dFXI3NgfA5HpQDi1PJyyQO9xPCd6Ugv?=
 =?us-ascii?Q?mdO37tjW8psZ1AmhrfAdHseiQCqXLjL2N76fLMo41LiWlzzWsiw9oU6zT+wz?=
 =?us-ascii?Q?z7bNqaorpfzoBHnu4P4i08asTw5/maoAuqESbDISvtEpS/1Ju2vulv3X63SS?=
 =?us-ascii?Q?RP8IXSDsyXUuJ7yWlY/LBlUjY+CfX0SGYxudKyitsrftyIMH4GJbVbcpAIDP?=
 =?us-ascii?Q?3TtC8wmaIMxO5siYwdLtK5rWO4jLaEmbO8n9IMHPzkp1OC0w24+TNlketCOz?=
 =?us-ascii?Q?zaipWpjXloObyXcecL4ksUuaPKFNf8rVXjuhFVioKi4DNpOqgXGD4HcrLoAj?=
 =?us-ascii?Q?1iQqt8RSE7KuePO9r3tvg3mAyWPnOcF6ETyqK8pZLM/BEoScLv1xyksmgIvh?=
 =?us-ascii?Q?l8JAzLwjBb3qcBeVDP5R29SDPC972w+BA7wsiwSMLl04iXU9kWC+/u0wmwju?=
 =?us-ascii?Q?5Aty+O7zFznuHPInOSX9fshcPbAQcC64bPWFPaq2jyWbi95qDUUPb0IahDc7?=
 =?us-ascii?Q?8qe9WVzwJuKIhacffG/o6l8ZWC5bQmr0kKOtXmNEqty5kxTuzK8vZwu7ZnPN?=
 =?us-ascii?Q?NXxTTy4O6Bch4nqFwuiIN2MyN5F0k/UoqIKXlCmTS5Ie6Q34Zfd/1ZcGprMb?=
 =?us-ascii?Q?rsxC31CYGNQVEMpd3g2vAajJpCy8IDIVed+CWfG4ZmZ1lwOgLdFLroHgAAjl?=
 =?us-ascii?Q?MWlT++mYZ1eM28Z/mUXLBfwPSPoUahKjGFoB94axF1bBa6PK/317wrqVR1Qn?=
 =?us-ascii?Q?qXPb7FnvzTFD0OHtTTN+uuIPYgrFbVMefmD+N3VQuQxhYNo0afARgZFTSrrk?=
 =?us-ascii?Q?lAV41vQvVrQYisS017xkWNPywyQ82HgKFOuvvSllecl7F1XlFXe6AjyylwPl?=
 =?us-ascii?Q?fFvmSWj0OIBCmXOqLCb8IMY=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d2b7fce-24e9-4ba2-baeb-08dd7d40318f
X-MS-Exchange-CrossTenant-AuthSource: LV2PR01MB7792.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2025 23:41:22.2070
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VKGAOG8d+M0RZ+HmbQbrap3AkQjcT8e4DfNMlKzyVNv7LzI+ohJmv3KObM45tuW0R1TPM8ZjUN2xQvK75pjWEdZmeBgZvHZ/t4LvxJaaMiHVkU0jDr0sXcU4PtFP4W6Q
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR01MB6205

Marc Zyngier <maz@kernel.org> writes:

> On Tue, 15 Apr 2025 16:46:56 +0100,
> D Scott Phillips <scott@os.amperecomputing.com> wrote:
>> 
>> pNMIs are intended to be deliverable during operations like guest
>> tlb flushing or nested AT, however the setting of HCR_EL2 controls
>> are accidentally blocking async exceptions.
>> 
>> You can see this by doing:
>> 
>>      # perf record -e cycles:Hk -g ./dirty_log_perf_test -m 3 \
>>        -i 4 -s anonymous -b 4G -v 32
>> 
>> Where no samples will be collected in __kvm_tlb_flush_vmid_ipa_nsh()
>> between enter_vmid_context() and exit_vmid_context() then many
>> samples are collected right after the write to HCR_EL2 in
>> exit_vmid_context(), where pNMIs actually get unmasked.
>> 
>> Set HCR_EL2.IMO so that pNMIs are not blocked during guest tlb
>> flushing or nested AT.
>>
>> Signed-off-by: D Scott Phillips <scott@os.amperecomputing.com>
>> ---
>>  arch/arm64/include/asm/hardirq.h |  3 ++-
>>  arch/arm64/kvm/at.c              |  4 +++-
>>  arch/arm64/kvm/hyp/vhe/tlb.c     | 10 ++++++++++
>>  3 files changed, 15 insertions(+), 2 deletions(-)
>> 
>> diff --git a/arch/arm64/include/asm/hardirq.h b/arch/arm64/include/asm/hardirq.h
>> index cbfa7b6f2e098..6eb3f93851023 100644
>> --- a/arch/arm64/include/asm/hardirq.h
>> +++ b/arch/arm64/include/asm/hardirq.h
>> @@ -41,7 +41,8 @@ do {									\
>>  									\
>>  	___hcr = read_sysreg(hcr_el2);					\
>>  	if (!(___hcr & HCR_TGE)) {					\
>> -		write_sysreg(___hcr | HCR_TGE, hcr_el2);		\
>> +		write_sysreg((___hcr & ~(HCR_AMO | HCR_IMO | HCR_FMO)) |\
>> +			     HCR_TGE, hcr_el2);				\
>>  		isb();							\
>>  	}								\
>>  	/*								\
>> diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
>> index ff4b06ce661af..f31f0d78c5813 100644
>> --- a/arch/arm64/kvm/at.c
>> +++ b/arch/arm64/kvm/at.c
>> @@ -1269,7 +1269,9 @@ static u64 __kvm_at_s1e01_fast(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
>>  
>>  skip_mmu_switch:
>>  	/* Clear TGE, enable S2 translation, we're rolling */
>> -	write_sysreg((config.hcr & ~HCR_TGE) | HCR_VM,	hcr_el2);
>> +	write_sysreg((config.hcr & ~HCR_TGE) |
>> +		     HCR_AMO | HCR_IMO | HCR_FMO | HCR_VM,
>> +		     hcr_el2);
>>  	isb();
>>  
>>  	switch (op) {
>> diff --git a/arch/arm64/kvm/hyp/vhe/tlb.c b/arch/arm64/kvm/hyp/vhe/tlb.c
>> index 3d50a1bd2bdbc..ecb700bab3b8f 100644
>> --- a/arch/arm64/kvm/hyp/vhe/tlb.c
>> +++ b/arch/arm64/kvm/hyp/vhe/tlb.c
>> @@ -55,6 +55,15 @@ static void enter_vmid_context(struct kvm_s2_mmu *mmu,
>>  	 * bits. Changing E2H is impossible (goodbye TTBR1_EL2), so
>>  	 * let's flip TGE before executing the TLB operation.
>>  	 *
>> +	 * One other fun complication to consider is the target EL for
>> +	 * asynchronous exceptions. We want to allow NMIs during tlb flushing,
>> +	 * so we need to ensure that the target EL for IRQs remains as EL2.
>> +	 * HCR_EL2.{E2H,TGE,IMO} = {1,0,0} would set the target EL for IRQs as
>> +	 * EL1, and IRQs at EL2 would be "C" (Interrupts not taken regardless
>> +	 * of the value of interrupt masks). So we need to set
>> +	 * HCR_EL2.{E2H,TGE,IMO} = {1,0,1} so that NMIs will still be
>> +	 * delivered.
>> +	 *
>>  	 * ARM erratum 1165522 requires some special handling (again),
>>  	 * as we need to make sure both stages of translation are in
>>  	 * place before clearing TGE. __load_stage2() already
>> @@ -63,6 +72,7 @@ static void enter_vmid_context(struct kvm_s2_mmu *mmu,
>>  	__load_stage2(mmu, mmu->arch);
>>  	val = read_sysreg(hcr_el2);
>>  	val &= ~HCR_TGE;
>> +	val |= HCR_AMO | HCR_IMO | HCR_FMO;
>>  	write_sysreg(val, hcr_el2);
>>  	isb();
>>  }
>
> This seems terribly complicated for no good reasons. Why can't we run
> with HCR_xMO set at all times? i.e. like this:

Ah, good point Marc. You're right, this is much simpler.

Tested-by: D Scott Phillips <scott@os.amperecomputing.com>
Reviewed-by: D Scott Phillips <scott@os.amperecomputing.com>

> diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
> index 974d72b5905b8..bba4b0e930915 100644
> --- a/arch/arm64/include/asm/kvm_arm.h
> +++ b/arch/arm64/include/asm/kvm_arm.h
> @@ -100,7 +100,7 @@
>  			 HCR_FMO | HCR_IMO | HCR_PTW | HCR_TID3 | HCR_TID1)
>  #define HCR_HOST_NVHE_FLAGS (HCR_RW | HCR_API | HCR_APK | HCR_ATA)
>  #define HCR_HOST_NVHE_PROTECTED_FLAGS (HCR_HOST_NVHE_FLAGS | HCR_TSC)
> -#define HCR_HOST_VHE_FLAGS (HCR_RW | HCR_TGE | HCR_E2H)
> +#define HCR_HOST_VHE_FLAGS (HCR_RW | HCR_TGE | HCR_E2H | HCR_AMO | HCR_IMO | HCR_FMO)
>  
>  #define HCRX_HOST_FLAGS (HCRX_EL2_MSCEn | HCRX_EL2_TCR2En | HCRX_EL2_EnFPM)
>  #define MPAMHCR_HOST_FLAGS	0
>
> There should never be a case where we don't want physical interrupts
> to be taken at EL2 when running VHE, and we should never use these
> bits to mask interrupts. This has been relaxed in the architecture to
> have an IMPDEF behaviour anyway, as it cannot be implemented on NV.
>
> Thanks,
>
> 	M.
>
> -- 
> Without deviation from the norm, progress is not possible.
