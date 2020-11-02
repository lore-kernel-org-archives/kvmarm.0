Return-Path: <SRS0=lygO=EI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E12CC00A89
	for <kvmarm@archiver.kernel.org>; Mon,  2 Nov 2020 05:23:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 58B57221FF
	for <kvmarm@archiver.kernel.org>; Mon,  2 Nov 2020 05:23:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iuoKOMzm"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 58B57221FF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A2AC84B56F;
	Mon,  2 Nov 2020 00:23:48 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Aw+Ct889Z5jc; Mon,  2 Nov 2020 00:23:47 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 916144B571;
	Mon,  2 Nov 2020 00:23:47 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 775224B56B
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Nov 2020 00:23:46 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cxRVVlr4ug4m for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 Nov 2020 00:23:45 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [63.128.21.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 698234B485
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Nov 2020 00:23:45 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1604294625;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=7UtcPEETWXjyYnC6APNrMia13qjWKApPL5wKeT1uE+4=;
 b=iuoKOMzmRbcRAHRVJfJrNzVOnDY4Eatgp+OqjyJ9T68LhsFYuK0cDvbCk/k3VRcXjfqUbf
 6f+/ICm5RJr2BMEm4vkPAVR8XF4cXJ5qkBUPQpcTjW/X4T/Yvmeup9WAw32bOhGFnltbWt
 wCk7wgFyupnx2q7wWEDsl9bkwDAhQlM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-180-C4hjzJfiM5WMewplTEfXqA-1; Mon, 02 Nov 2020 00:23:43 -0500
X-MC-Unique: C4hjzJfiM5WMewplTEfXqA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
 [10.5.11.23])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E8DAC57203;
 Mon,  2 Nov 2020 05:23:41 +0000 (UTC)
Received: from [10.64.54.160] (vpn2-54-160.bne.redhat.com [10.64.54.160])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E3D111A8AC;
 Mon,  2 Nov 2020 05:23:39 +0000 (UTC)
Subject: Re: [PATCH 0/6] Support Asynchronous Page Fault
To: James Morse <james.morse@arm.com>, kvmarm@lists.cs.columbia.edu
References: <20200818011319.91777-1-gshan@redhat.com>
 <4dcaea7a-a4d1-9bf3-eb95-ea9d8826ad99@arm.com>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <f78cd0d7-904b-5ebf-01d3-c1f165cb827f@redhat.com>
Date: Mon, 2 Nov 2020 16:23:37 +1100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <4dcaea7a-a4d1-9bf3-eb95-ea9d8826ad99@arm.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=gshan@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: maz@kernel.org, will@kernel.org, shan.gavin@gmail.com, pbonzini@redhat.com
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

Hi James,

On 10/24/20 3:54 AM, James Morse wrote:
> I think this series would benefit from being in smaller pieces. I got lost in patch 4 for
> quite a while. Suggestion on where to do that in patch 4.
> 

Yes, I will split the patches into small ones for easier review
in next revision. Thanks for your comments :)

> 
> On 18/08/2020 02:13, Gavin Shan wrote:
>> There are two stages of page fault. The guest kernel is responsible
>> for handling stage one page fault, while the host kernel is to take
>> care of the stage two page fault. When page fault is triggered because
>> of stage two page fault, the guest is suspended until the requested
>> memory (page) is populated. Sometimes, the cost to populate the requested
>> page isn't cheap and can take hundreds of milliseconds in extreme
>> cases. This impacts the overall guest's performance.
> 
> You really need to use postcopy live migration to justify these changes. Otherwise the
> story here is "over-commited hosts suck", which I don't think anyone cares about.
> 

Yes, I will use live migration as the justification in next revision :)

> 
>> This series introduces the feature (asynchronous page fault) to resolve
>> the issue and improve the guest's performance. It depends on the series
>> to support SDEI virtualization and refactoring SDEI client driver.
> 
> SDEI gives you an NMI ... which you use to set a TIF flag. This can only work reliably for
> user-space. So much so that you have code in the hypervisor to only deliver the NMI ...
> when in user-space.
> The only reason you would need an NMI is to interrupt interrupts-masked code. Linux can't
> reschedule when this is the case.
> 
> I can only conclude, you really don't need an NMI here.
> 
> 
> Why couldn't we use an IRQ here, it would be a lot simpler? ... the reason is the arm
> architecture can't guarantee us that we take the irq when there is also a stage2 fault for
> the first instruction.
> I reckon we can work around this in the hypervisor:
> https://lore.kernel.org/r/20201023165108.15061-1-james.morse@arm.com
> 
> 
> My problem with SDEI is, you don't really need an NMI, and it creates extra in-kernel
> state that has to be migrated. I think having this state in the kernel complicates the
> user-space handling of SIGBUS_MCEERR_AO signals that don't get delivered to a vCPU thread.
> 
> 

Currently, the asynchronous page fault is only supported for memory access in
guest's userspace, but we needn't to be sticky to the use model in future. It
means the asynchornous page fault could be supported for memory access in guest's
kernel space where the interrupt can be disabled or masked. So NMI is needed and
SDEI fits the use model very well as Paolo replied in another thread.

About the feature to support SDEI virtualization, I thought there might be some
use cases where the emulated devices need inject SDEI event to guest. However,
I'm not too much familiar with the architecture yet. If it's required by the
emulated devices, there are more more justifications to merge the code. However,
the implementation itself isn't simple and I would say it's complicated.

Thanks,
Gavin

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
