Return-Path: <SRS0=HAfI=OF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBDC5C433F5
	for <kvmarm@archiver.kernel.org>; Wed, 15 Sep 2021 09:39:34 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 688976124E
	for <kvmarm@archiver.kernel.org>; Wed, 15 Sep 2021 09:39:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 688976124E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CE1834B0BE;
	Wed, 15 Sep 2021 05:39:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hUA5lt59B2jC; Wed, 15 Sep 2021 05:39:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4803D4B091;
	Wed, 15 Sep 2021 05:39:32 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 142B74ACC9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Sep 2021 21:19:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id s08NaQMxp90m for <kvmarm@lists.cs.columbia.edu>;
 Tue, 14 Sep 2021 21:19:24 -0400 (EDT)
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 499C74A19F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Sep 2021 21:19:24 -0400 (EDT)
X-IronPort-AV: E=McAfee;i="6200,9189,10107"; a="209407411"
X-IronPort-AV: E=Sophos;i="5.85,292,1624345200"; d="scan'208";a="209407411"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
 by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 14 Sep 2021 18:19:22 -0700
X-IronPort-AV: E=Sophos;i="5.85,292,1624345200"; d="scan'208";a="544371674"
Received: from zhoushua-mobl1.ccr.corp.intel.com (HELO [10.255.30.237])
 ([10.255.30.237])
 by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 14 Sep 2021 18:19:14 -0700
Message-ID: <186c330e-be42-4c49-545c-8f73573b5869@intel.com>
Date: Wed, 15 Sep 2021 09:19:12 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.0.3
Subject: Re: [PATCH V10 01/18] perf/core: Use static_call to optimize
 perf_guest_info_callbacks
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>
References: <20210806133802.3528-1-lingshan.zhu@intel.com>
 <20210806133802.3528-2-lingshan.zhu@intel.com> <YSfykbECnC6J02Yk@google.com>
From: "Zhu, Lingshan" <lingshan.zhu@intel.com>
In-Reply-To: <YSfykbECnC6J02Yk@google.com>
X-Mailman-Approved-At: Wed, 15 Sep 2021 05:39:31 -0400
Cc: wanpengli@tencent.com, Like Xu <like.xu@linux.intel.com>,
 peterz@infradead.org, eranian@google.com, Guo Ren <guoren@kernel.org>,
 linux-riscv@lists.infradead.org, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, kan.liang@linux.intel.com, ak@linux.intel.com,
 kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>, joro@8bytes.org,
 x86@kernel.org, linux-csky@vger.kernel.org, wei.w.wang@intel.com,
 linux-arm-kernel@lists.infradead.org, xen-devel@lists.xenproject.org,
 liuxiangdong5@huawei.com, bp@alien8.de,
 Paul Walmsley <paul.walmsley@sifive.com>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, boris.ostrvsky@oracle.com,
 jmattson@google.com, like.xu.linux@gmail.com, Nick Hu <nickhu@andestech.com>,
 linux-kernel@vger.kernel.org, pbonzini@redhat.com, vkuznets@redhat.com
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu



On 8/27/2021 3:59 AM, Sean Christopherson wrote:
> TL;DR: Please don't merge this patch, it's broken and is also built on a shoddy
>         foundation that I would like to fix.
Hi Sean,Peter, Paolo

I will send out an V11 which drops this patch since it's buggy, and Sean 
is working on fix this.
Does this sound good?

Thanks,
Zhu Lingshan
>
> On Fri, Aug 06, 2021, Zhu Lingshan wrote:
>> diff --git a/kernel/events/core.c b/kernel/events/core.c
>> index 464917096e73..e466fc8176e1 100644
>> --- a/kernel/events/core.c
>> +++ b/kernel/events/core.c
>> @@ -6489,9 +6489,18 @@ static void perf_pending_event(struct irq_work *entry)
>>    */
>>   struct perf_guest_info_callbacks *perf_guest_cbs;
>>   
>> +/* explicitly use __weak to fix duplicate symbol error */
>> +void __weak arch_perf_update_guest_cbs(void)
>> +{
>> +}
>> +
>>   int perf_register_guest_info_callbacks(struct perf_guest_info_callbacks *cbs)
>>   {
>> +	if (WARN_ON_ONCE(perf_guest_cbs))
>> +		return -EBUSY;
>> +
>>   	perf_guest_cbs = cbs;
>> +	arch_perf_update_guest_cbs();
> This is horribly broken, it fails to cleanup the static calls when KVM unregisters
> the callbacks, which happens when the vendor module, e.g. kvm_intel, is unloaded.
> The explosion doesn't happen until 'kvm' is unloaded because the functions are
> implemented in 'kvm', i.e. the use-after-free is deferred a bit.
>
>    BUG: unable to handle page fault for address: ffffffffa011bb90
>    #PF: supervisor instruction fetch in kernel mode
>    #PF: error_code(0x0010) - not-present page
>    PGD 6211067 P4D 6211067 PUD 6212063 PMD 102b99067 PTE 0
>    Oops: 0010 [#1] PREEMPT SMP
>    CPU: 0 PID: 1047 Comm: rmmod Not tainted 5.14.0-rc2+ #460
>    Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
>    RIP: 0010:0xffffffffa011bb90
>    Code: Unable to access opcode bytes at RIP 0xffffffffa011bb66.
>    Call Trace:
>     <NMI>
>     ? perf_misc_flags+0xe/0x50
>     ? perf_prepare_sample+0x53/0x6b0
>     ? perf_event_output_forward+0x67/0x160
>     ? kvm_clock_read+0x14/0x30
>     ? kvm_sched_clock_read+0x5/0x10
>     ? sched_clock_cpu+0xd/0xd0
>     ? __perf_event_overflow+0x52/0xf0
>     ? handle_pmi_common+0x1f2/0x2d0
>     ? __flush_tlb_all+0x30/0x30
>     ? intel_pmu_handle_irq+0xcf/0x410
>     ? nmi_handle+0x5/0x260
>     ? perf_event_nmi_handler+0x28/0x50
>     ? nmi_handle+0xc7/0x260
>     ? lock_release+0x2b0/0x2b0
>     ? default_do_nmi+0x6b/0x170
>     ? exc_nmi+0x103/0x130
>     ? end_repeat_nmi+0x16/0x1f
>     ? lock_release+0x2b0/0x2b0
>     ? lock_release+0x2b0/0x2b0
>     ? lock_release+0x2b0/0x2b0
>     </NMI>
>    Modules linked in: irqbypass [last unloaded: kvm]
>
> Even more fun, the existing perf_guest_cbs framework is also broken, though it's
> much harder to get it to fail, and probably impossible to get it to fail without
> some help.  The issue is that perf_guest_cbs is global, which means that it can
> be nullified by KVM (during module unload) while the callbacks are being accessed
> by a PMI handler on a different CPU.
>
> The bug has escaped notice because all dererfences of perf_guest_cbs follow the
> same "perf_guest_cbs && perf_guest_cbs->is_in_guest()" pattern, and AFAICT the
> compiler never reload perf_guest_cbs in this sequence.  The compiler does reload
> perf_guest_cbs for any future dereferences, but the ->is_in_guest() guard all but
> guarantees the PMI handler will win the race, e.g. to nullify perf_guest_cbs,
> KVM has to completely exit the guest and teardown down all VMs before it can be
> unloaded.
>
> But with a help, e.g. RAED_ONCE(perf_guest_cbs), unloading kvm_intel can trigger
> a NULL pointer derference, e.g. this tweak
>
> diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
> index 1eb45139fcc6..202e5ad97f82 100644
> --- a/arch/x86/events/core.c
> +++ b/arch/x86/events/core.c
> @@ -2954,7 +2954,7 @@ unsigned long perf_misc_flags(struct pt_regs *regs)
>   {
>          int misc = 0;
>
> -       if (perf_guest_cbs && perf_guest_cbs->is_in_guest()) {
> +       if (READ_ONCE(perf_guest_cbs) && READ_ONCE(perf_guest_cbs)->is_in_guest()) {
>                  if (perf_guest_cbs->is_user_mode())
>                          misc |= PERF_RECORD_MISC_GUEST_USER;
>                  else
>
>
> while spamming module load/unload leads to:
>
>    BUG: kernel NULL pointer dereference, address: 0000000000000000
>    #PF: supervisor read access in kernel mode
>    #PF: error_code(0x0000) - not-present page
>    PGD 0 P4D 0
>    Oops: 0000 [#1] PREEMPT SMP
>    CPU: 6 PID: 1825 Comm: stress Not tainted 5.14.0-rc2+ #459
>    Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
>    RIP: 0010:perf_misc_flags+0x1c/0x70
>    Call Trace:
>     perf_prepare_sample+0x53/0x6b0
>     perf_event_output_forward+0x67/0x160
>     __perf_event_overflow+0x52/0xf0
>     handle_pmi_common+0x207/0x300
>     intel_pmu_handle_irq+0xcf/0x410
>     perf_event_nmi_handler+0x28/0x50
>     nmi_handle+0xc7/0x260
>     default_do_nmi+0x6b/0x170
>     exc_nmi+0x103/0x130
>     asm_exc_nmi+0x76/0xbf
>
>
> The good news is that I have a series that should fix both the existing NULL pointer
> bug and mostly obviate the need for static calls.  The bad news is that my approach,
> making perf_guest_cbs per-CPU, likely complicates turning these into static calls,
> though I'm guessing it's still a solvable problem.
>
> Tangentially related, IMO we should make architectures opt-in to getting
> perf_guest_cbs and nuke all of the code in the below files.  Except for arm,
> which recently lost KVM support, it's all a bunch of useless copy-paste code that
> serves no purpose and just complicates cleanups like this.
>
>>   arch/arm/kernel/perf_callchain.c   | 16 +++++++-----
>>   arch/csky/kernel/perf_callchain.c  |  4 +--
>>   arch/nds32/kernel/perf_event_cpu.c | 16 +++++++-----
>>   arch/riscv/kernel/perf_callchain.c |  4 +--

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
