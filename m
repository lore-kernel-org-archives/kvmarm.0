Return-Path: <SRS0=Z53j=WK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_ADSP_ALL,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7A16C32757
	for <kvmarm@archiver.kernel.org>; Wed, 14 Aug 2019 13:02:37 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 58B75206C1
	for <kvmarm@archiver.kernel.org>; Wed, 14 Aug 2019 13:02:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="QeVkZCd2"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 58B75206C1
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B51EC4A4BE;
	Wed, 14 Aug 2019 09:02:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@amazon.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id F5y915OTXjXU; Wed, 14 Aug 2019 09:02:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8959B4A4E1;
	Wed, 14 Aug 2019 09:02:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 208544A4E1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Aug 2019 09:02:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5WnhyEbvTEEX for <kvmarm@lists.cs.columbia.edu>;
 Wed, 14 Aug 2019 09:02:32 -0400 (EDT)
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B700A4A4A9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Aug 2019 09:02:32 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
 t=1565787752; x=1597323752;
 h=subject:to:cc:references:from:message-id:date:
 mime-version:in-reply-to:content-transfer-encoding;
 bh=ahedc4jUDKTjKYr/t9LKGSVGXplFx3U807P6YTr2BXY=;
 b=QeVkZCd2rxiA5LnNmWsUck7ZdMr/SvnkBhFmIewjlAWFqT6aD/IiwBqS
 0WqLDiJE4VyalyyUhDET4WkWQevYbbaCIFLLF+TFlt18QC0I1KNUDbzRP
 R+eLfZevx1x12UbMfNPmw8FpYe6D6/nbH5nzXiDLXqak7diPGWaiiE0H3 w=;
X-IronPort-AV: E=Sophos;i="5.64,385,1559520000"; d="scan'208";a="409587587"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO
 email-inbound-relay-2a-8549039f.us-west-2.amazon.com) ([10.124.125.6])
 by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP;
 14 Aug 2019 13:02:30 +0000
Received: from EX13MTAUWC001.ant.amazon.com
 (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
 by email-inbound-relay-2a-8549039f.us-west-2.amazon.com (Postfix) with ESMTPS
 id C0243A227C; Wed, 14 Aug 2019 13:02:29 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 14 Aug 2019 13:02:29 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.160.211) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 14 Aug 2019 13:02:26 +0000
Subject: Re: [PATCH 0/9] arm64: Stolen time support
To: Steven Price <steven.price@arm.com>, Marc Zyngier <maz@kernel.org>
References: <20190802145017.42543-1-steven.price@arm.com>
 <20190803190522.5fec8f7d@why> <6789f477-8ab5-cc54-1ad2-8627917b07c9@arm.com>
From: Alexander Graf <graf@amazon.com>
Message-ID: <8ca5c106-7c12-4c6e-6d81-a90f281a9894@amazon.com>
Date: Wed, 14 Aug 2019 15:02:25 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <6789f477-8ab5-cc54-1ad2-8627917b07c9@arm.com>
Content-Language: en-US
X-Originating-IP: [10.43.160.211]
X-ClientProxiedBy: EX13D03UWA002.ant.amazon.com (10.43.160.144) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Precedence: Bulk
Cc: kvm@vger.kernel.org, linux-doc@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 Russell King <linux@armlinux.org.uk>, Paolo Bonzini <pbonzini@redhat.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
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



On 05.08.19 15:06, Steven Price wrote:
> On 03/08/2019 19:05, Marc Zyngier wrote:
>> On Fri,  2 Aug 2019 15:50:08 +0100
>> Steven Price <steven.price@arm.com> wrote:
>>
>> Hi Steven,
>>
>>> This series add support for paravirtualized time for arm64 guests and
>>> KVM hosts following the specification in Arm's document DEN 0057A:
>>>
>>> https://developer.arm.com/docs/den0057/a
>>>
>>> It implements support for stolen time, allowing the guest to
>>> identify time when it is forcibly not executing.
>>>
>>> It doesn't implement support for Live Physical Time (LPT) as there are
>>> some concerns about the overheads and approach in the above
>>> specification, and I expect an updated version of the specification to
>>> be released soon with just the stolen time parts.
>>
>> Thanks for posting this.
>>
>> My current concern with this series is around the fact that we allocate
>> memory from the kernel on behalf of the guest. It is the first example
>> of such thing in the ARM port, and I can't really say I'm fond of it.
>>
>> x86 seems to get away with it by having the memory allocated from
>> userspace, why I tend to like more. Yes, put_user is more
>> expensive than a straight store, but this isn't done too often either.
>>
>> What is the rational for your current approach?
> 
> As I see it there are 3 approaches that can be taken here:
> 
> 1. Hypervisor allocates memory and adds it to the virtual machine. This
> means that everything to do with the 'device' is encapsulated behind the
> KVM_CREATE_DEVICE / KVM_[GS]ET_DEVICE_ATTR ioctls. But since we want the
> stolen time structure to be fast it cannot be a trapping region and has
> to be backed by real memory - in this case allocated by the host kernel.
> 
> 2. Host user space allocates memory. Similar to above, but this time
> user space needs to manage the memory region as well as the usual
> KVM_CREATE_DEVICE dance. I've no objection to this, but it means
> kvmtool/QEMU needs to be much more aware of what is going on (e.g. how
> to size the memory region).

You ideally want to get the host overhead for a VM to as little as you 
can. I'm not terribly fond of the idea of reserving a full page just 
because we're too afraid of having the guest donate memory.

> 
> 3. Guest kernel "donates" the memory to the hypervisor for the
> structure. As far as I'm aware this is what x86 does. The problems I see
> this approach are:
> 
>   a) kexec becomes much more tricky - there needs to be a disabling
> mechanism for the guest to stop the hypervisor scribbling on memory
> before starting the new kernel.

I wouldn't call "quiesce a device" much more tricky. We have to do that 
for other devices as well today.

>   b) If there is more than one entity that is interested in the
> information (e.g. firmware and kernel) then this requires some form of
> arbitration in the guest because the hypervisor doesn't want to have to
> track an arbitrary number of regions to update.

Why would FW care?

>   c) Performance can suffer if the host kernel doesn't have a suitably
> aligned/sized area to use. As you say - put_user() is more expensive.

Just define the interface to always require natural alignment when 
donating a memory location?

> The structure is updated on every return to the VM.

If you really do suffer from put_user(), there are alternatives. You 
could just map the page on the registration hcall and then leave it 
pinned until the vcpu gets destroyed again.

> Of course x86 does prove the third approach can work, but I'm not sure
> which is actually better. Avoid the kexec cancellation requirements was
> the main driver of the current approach. Although many of the

I really don't understand the problem with kexec cancellation. Worst 
case, let guest FW set it up for you and propagate only the address down 
via ACPI/DT. That way you can mark the respective memory as reserved too.

But even with a Linux only mechanism, just take a look at 
arch/x86/kernel/kvmclock.c. All they do to remove the map is to hook 
into machine_crash_shutdown() and machine_shutdown().


Alex

> conversations about this were also tied up with Live Physical Time which
> adds its own complications.
> 
> Steve
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
