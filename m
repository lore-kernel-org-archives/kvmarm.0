Return-Path: <SRS0=7dZW=56=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2DFBC352BE
	for <kvmarm@archiver.kernel.org>; Tue, 14 Apr 2020 09:11:39 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8C9D82074D
	for <kvmarm@archiver.kernel.org>; Tue, 14 Apr 2020 09:11:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Wj+mC8hl"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8C9D82074D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 45E7A4B1E5;
	Tue, 14 Apr 2020 05:11:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id T6cpybIfopLy; Tue, 14 Apr 2020 05:11:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D9E484B1EF;
	Tue, 14 Apr 2020 05:11:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1C4844B1BD
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Apr 2020 01:40:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id g06HFzTBGOFg for <kvmarm@lists.cs.columbia.edu>;
 Tue, 14 Apr 2020 01:40:18 -0400 (EDT)
Received: from us-smtp-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [207.211.31.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D18404B153
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Apr 2020 01:40:18 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1586842818;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=SzGXdrr02xEETNvxPooAet3btKkqhAyq5AZ2occpcYA=;
 b=Wj+mC8hlWnzFvG62ngzT+7jpxsWtNqQM86gBZsL9wR/sa+D68i5/dYURLXJc0K131nvkjW
 NPEwGvqFGsKxcx9OO2RrH8yV/g+HTV850u1kL1eEyrPnBmeLN5pRhT+7yGOiAhxWxDcHS4
 BV6zI7jmBRyhk8iBDIXaHat8bbyU1fE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-333-yw5T7HaGOEe6nG4ifQYWoA-1; Tue, 14 Apr 2020 01:40:10 -0400
X-MC-Unique: yw5T7HaGOEe6nG4ifQYWoA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
 [10.5.11.11])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5FED98017F5;
 Tue, 14 Apr 2020 05:40:08 +0000 (UTC)
Received: from localhost.localdomain (vpn2-54-77.bne.redhat.com [10.64.54.77])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 53B5B18A8E;
 Tue, 14 Apr 2020 05:39:59 +0000 (UTC)
Subject: Re: [PATCH RFCv1 0/7] Support Async Page Fault
To: Marc Zyngier <maz@kernel.org>
References: <20200410085820.758686-1-gshan@redhat.com>
 <d2882e806ad2f9793437160093c8d3fa@kernel.org>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <6a1d7e8b-da10-409f-16d0-354004566a1a@redhat.com>
Date: Tue, 14 Apr 2020 15:39:56 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <d2882e806ad2f9793437160093c8d3fa@kernel.org>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
X-Mailman-Approved-At: Tue, 14 Apr 2020 05:11:35 -0400
Cc: catalin.marinas@arm.com, shan.gavin@gmail.com, sudeep.holla@arm.com,
 will@kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
Reply-To: Gavin Shan <gshan@redhat.com>
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

Hi Marc,

On 4/10/20 10:52 PM, Marc Zyngier wrote:
> Hi Gavin,
> 
> On 2020-04-10 09:58, Gavin Shan wrote:
>> There are two stages of page faults and the stage one page fault is
>> handled by guest itself. The guest is trapped to host when the page
>> fault is caused by stage 2 page table, for example missing. The guest
>> is suspended until the requested page is populated. To populate the
>> requested page can be costly and might be related to IO activities
>> if the page was swapped out previously. In this case, the guest has
>> to suspend for a few of milliseconds at least, regardless of the
>> overall system load.
>>
>> The series adds support to asychornous page fault to improve above
>> situation. If it's costly to populate the requested page, a signal
>> (PAGE_NOT_PRESENT) is sent to guest so that the faulting process can
>> be rescheduled if it can be. Otherwise, it is put into power-saving
>> mode. Another signal (PAGE_READY) is sent to guest once the requested
>> page is populated so that the faulting process can be waken up either
>> from either waiting state or power-saving state.
>>
>> In order to fulfil the control flow and convey signals between host
>> and guest. A IMPDEF system register (SYS_ASYNC_PF_EL1) is introduced.
>> The register accepts control block's physical address, plus requested
>> features. Also, the signal is sent using data abort with the specific
>> IMPDEF Data Fault Status Code (DFSC). The specific signal is stored
>> in the control block by host, to be consumed by guest.
>>
>> Todo
>> ====
>> * CONFIG_KVM_ASYNC_PF_SYNC is disabled for now because the exception
>>    injection can't work in nested mode. It might be something to be
>>    improved in future.
>> * KVM_ASYNC_PF_SEND_ALWAYS is disabled even with CONFIG_PREEMPTION
>>    because it's simply not working reliably.
>> * Tracepoints, which should something to be done in short term.
>> * kvm-unit-test cases.
>> * More testing and debugging are needed. Sometimes, the guest can be
>>    stuck and the root cause needs to be figured out.
> 
> Let me add another few things:
> 
> - KVM/arm is (supposed to be) an architectural hypervisor. It means
>    that one of the design goal is to have as few differences as possible
>    from the actual hardware. I'm not keen on deviating from it (next
>    thing you know, you'll add all the PV horror from Xen, HV, VMware...).
> 
> - The idea of butchering the arm64 mm subsystem to handle a new exotic
>    style of exceptions is not something I am looking forward to. We
>    might as well PV the whole MMU, Xen style, and be done with it. I'll
>    let the arm64 maintainers comment on this though.
> 

Thanks for your comments. The feature won't be enabled on guest side until
CONFIG_KVM_GUEST is enabled. More details can be found from PATCH[7/7]. So
it would be one specific features supported by KVM. I'm not familiar with
xen and would like to learn how MMU is para-virtualized there. Do you have
documents recommended to start with? Otherwise, I will try google later.

> - We don't add IMPDEF sysregs, period. That's reserved for the HW. If
>    you want to trap, there's the HVC instruction to that effect.
> 

Yes, HVC can be used for trapping as PV stolen time did. However, I guess
it's guarded by specification? For example, the para-virtualized time calls
are specified by DEN0057A, as highlighted in include/linux/arm-smccc.h.

/* Paravirtualised time calls (defined by ARM DEN0057A) */
#define ARM_SMCCC_HV_PV_TIME_FEATURES                           \
         ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,                 \
                            ARM_SMCCC_SMC_64,                    \
                            ARM_SMCCC_OWNER_STANDARD_HYP,        \
                            0x20)

#define ARM_SMCCC_HV_PV_TIME_ST                                 \
         ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,                 \
                            ARM_SMCCC_SMC_64,                    \
                            ARM_SMCCC_OWNER_STANDARD_HYP,        \
                            0x21)

I really don't understand how IMPDEF sysreg is used by hardware vendors.
Do we have an existing functionality, which depends on IMPDEF sysreg?
I was thinking the IMPDEF sysreg can be used by software either, but
it seems I'm wrong.

> - If this is such a great improvement, where are the performance
>    numbers?
> 

Yep, Ineed. I'm still looking for appropriate workload currently and hopefully,
I can share performance data in RFCv2 :)

> - The fact that it apparently cannot work with nesting nor with
>    preemption tends to indicate that it isn't future proof.
> 

I didn't make myself clear about the nesting. The data abort exception is injected
by tweaking ELR_EL1/SPSR_EL1 if the guest is runing in 64-bits and EL1 mode. These
registers are loaded when the guest gets chance to run. However, it's impossible to
inject two (nested) data abort exception at once. It's something different from nested
VM.

There was a hot discusson about the preemption support. It's something in the TODO list
and needs to be sorted out in future.

https://lore.kernel.org/patchwork/patch/1206121/


> Thanks,
> 
> 	M.
> 

Thanks,
Gavin

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
