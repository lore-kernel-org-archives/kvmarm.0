Return-Path: <SRS0=V360=D6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B601C4363A
	for <kvmarm@archiver.kernel.org>; Fri, 23 Oct 2020 16:54:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8D2B320E65
	for <kvmarm@archiver.kernel.org>; Fri, 23 Oct 2020 16:54:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8D2B320E65
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9B7B44B746;
	Fri, 23 Oct 2020 12:54:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ymGK2CXRWWXn; Fri, 23 Oct 2020 12:54:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7DA494B6DC;
	Fri, 23 Oct 2020 12:54:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 975F04B5D3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Oct 2020 12:54:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 70fRZ74891ii for <kvmarm@lists.cs.columbia.edu>;
 Fri, 23 Oct 2020 12:54:21 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A9704B6D4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Oct 2020 12:54:21 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D4BA51FB;
 Fri, 23 Oct 2020 09:54:20 -0700 (PDT)
Received: from [172.16.1.113] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CAF893F719;
 Fri, 23 Oct 2020 09:54:19 -0700 (PDT)
Subject: Re: [PATCH 0/6] Support Asynchronous Page Fault
To: Gavin Shan <gshan@redhat.com>, kvmarm@lists.cs.columbia.edu
References: <20200818011319.91777-1-gshan@redhat.com>
From: James Morse <james.morse@arm.com>
Message-ID: <4dcaea7a-a4d1-9bf3-eb95-ea9d8826ad99@arm.com>
Date: Fri, 23 Oct 2020 17:54:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200818011319.91777-1-gshan@redhat.com>
Content-Language: en-GB
Cc: maz@kernel.org, will@kernel.org, shan.gavin@gmail.com, pbonzini@redhat.com
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Gavin,

I think this series would benefit from being in smaller pieces. I got lost in patch 4 for
quite a while. Suggestion on where to do that in patch 4.


On 18/08/2020 02:13, Gavin Shan wrote:
> There are two stages of page fault. The guest kernel is responsible
> for handling stage one page fault, while the host kernel is to take
> care of the stage two page fault. When page fault is triggered because
> of stage two page fault, the guest is suspended until the requested
> memory (page) is populated. Sometimes, the cost to populate the requested
> page isn't cheap and can take hundreds of milliseconds in extreme
> cases. This impacts the overall guest's performance.

You really need to use postcopy live migration to justify these changes. Otherwise the
story here is "over-commited hosts suck", which I don't think anyone cares about.


> This series introduces the feature (asynchronous page fault) to resolve
> the issue and improve the guest's performance. It depends on the series
> to support SDEI virtualization and refactoring SDEI client driver.

SDEI gives you an NMI ... which you use to set a TIF flag. This can only work reliably for
user-space. So much so that you have code in the hypervisor to only deliver the NMI ...
when in user-space.
The only reason you would need an NMI is to interrupt interrupts-masked code. Linux can't
reschedule when this is the case.

I can only conclude, you really don't need an NMI here.


Why couldn't we use an IRQ here, it would be a lot simpler? ... the reason is the arm
architecture can't guarantee us that we take the irq when there is also a stage2 fault for
the first instruction.
I reckon we can work around this in the hypervisor:
https://lore.kernel.org/r/20201023165108.15061-1-james.morse@arm.com


My problem with SDEI is, you don't really need an NMI, and it creates extra in-kernel
state that has to be migrated. I think having this state in the kernel complicates the
user-space handling of SIGBUS_MCEERR_AO signals that don't get delivered to a vCPU thread.


Thanks,

James
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
