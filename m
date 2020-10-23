Return-Path: <SRS0=V360=D6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AEF1C388F9
	for <kvmarm@archiver.kernel.org>; Fri, 23 Oct 2020 16:54:56 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5785F20E65
	for <kvmarm@archiver.kernel.org>; Fri, 23 Oct 2020 16:54:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5785F20E65
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BC4AC4B74D;
	Fri, 23 Oct 2020 12:54:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id toNtMAiEiL4S; Fri, 23 Oct 2020 12:54:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9F0A44B6DC;
	Fri, 23 Oct 2020 12:54:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5A3394B5D3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Oct 2020 12:54:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rVd6Mn9lcqnC for <kvmarm@lists.cs.columbia.edu>;
 Fri, 23 Oct 2020 12:54:51 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 510524B6CE
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Oct 2020 12:54:51 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 044EB1FB;
 Fri, 23 Oct 2020 09:54:51 -0700 (PDT)
Received: from [172.16.1.113] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9122B3F719;
 Fri, 23 Oct 2020 09:54:49 -0700 (PDT)
Subject: Re: [PATCH 3/6] kvm/arm64: Export kvm_handle_user_mem_abort() with
 prefault mode
To: Gavin Shan <gshan@redhat.com>, kvmarm@lists.cs.columbia.edu
References: <20200818011319.91777-1-gshan@redhat.com>
 <20200818011319.91777-4-gshan@redhat.com>
From: James Morse <james.morse@arm.com>
Message-ID: <43da773d-a218-ffb4-5648-19cc771c55e8@arm.com>
Date: Fri, 23 Oct 2020 17:54:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200818011319.91777-4-gshan@redhat.com>
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

On 18/08/2020 02:13, Gavin Shan wrote:
> This renames user_mem_abort() to kvm_handle_user_mem_abort(), and
> then exports it. The function will be used in asynchronous page fault
> to populate a page table entry once the corresponding page is populated
> from the backup device (e.g. swap partition):
> 
>    * Parameter @fault_status is replace by @esr.
>    * Parameter @prefault is added
> 
> As the @esr is passed as parameter, not fetched from vCPU struct. This
> also introduces the necessasry helpers in esr.h, to manupulate the @esr.

(Nit: necessary, manipulate)


> The helpers defined in kvm_emulate.h reuses the newly added helper. This
> shouldn't cause functional changes.

user_mem_abort() is deep in the the guts of KVM's arch code. I don't think this should be
exported. It  must be called on the vcpu thread. It must be called under the VMs srcu
lock. There are also tricky interactions with whether the vcpu is loaded on this cpu or not...

I think it would be much simpler to always let the guest take the stage2-fault a second
time. This keeps the property that pages are only populate in response to a stage2 fault.
If the guest behaves, it will only schedule a task that accesses the page once its available.


Thanks,

James
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
