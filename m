Return-Path: <SRS0=v2jq=2J=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D9A2C43603
	for <kvmarm@archiver.kernel.org>; Thu, 19 Dec 2019 13:46:28 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E13332146E
	for <kvmarm@archiver.kernel.org>; Thu, 19 Dec 2019 13:46:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E13332146E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 38A594A49F;
	Thu, 19 Dec 2019 08:46:27 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jdAKa+12QKy8; Thu, 19 Dec 2019 08:46:26 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 057434A536;
	Thu, 19 Dec 2019 08:46:26 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4BE134A4DF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Dec 2019 08:46:25 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id o4fgmYM+qFQw for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 Dec 2019 08:46:23 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8D9AC4A49F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Dec 2019 08:46:23 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E151131B;
 Thu, 19 Dec 2019 05:46:22 -0800 (PST)
Received: from [10.1.196.105] (eglon.cambridge.arm.com [10.1.196.105])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A8C063F6CF;
 Thu, 19 Dec 2019 05:46:20 -0800 (PST)
Subject: Re: [PATCH 7/7] KVM: arm/arm64: Elide CMOs when unmapping a range
To: Marc Zyngier <maz@kernel.org>
References: <20191213182503.14460-1-maz@kernel.org>
 <20191213182503.14460-8-maz@kernel.org>
 <0c832b27-7041-a6c8-31c0-d71a25c6f5b8@arm.com>
 <de462fe29fb40fb1644e6a071e6c0c69@www.loen.fr>
From: James Morse <james.morse@arm.com>
Message-ID: <01c9439f-0de1-78ca-632b-f662876cc4a1@arm.com>
Date: Thu, 19 Dec 2019 13:46:19 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <de462fe29fb40fb1644e6a071e6c0c69@www.loen.fr>
Content-Language: en-GB
Cc: kvm-ppc@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
 kvm@vger.kernel.org, James Hogan <jhogan@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, linux-mips@vger.kernel.org,
 Sean Christopherson <sean.j.christopherson@intel.com>,
 Paul Mackerras <paulus@ozlabs.org>, linux-arm-kernel@lists.infradead.org,
 Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 kvmarm@lists.cs.columbia.edu, Jim Mattson <jmattson@google.com>
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

Hi Marc,

On 18/12/2019 15:30, Marc Zyngier wrote:
> On 2019-12-18 15:07, James Morse wrote:
>> On 13/12/2019 18:25, Marc Zyngier wrote:
>>> If userspace issues a munmap() on a set of pages, there is no
>>> expectation that the pages are cleaned to the PoC.

>>> So let's
>>> not do more work than strictly necessary, and set the magic
>>> flag that avoids CMOs in this case.
>>
>> I think this assumes the pages went from anonymous->free, so no-one
>> cares about the contents.
>>
>> If the pages are backed by a file, won't dirty pages will still get
>> written back before the page is free? (e.g. EFI flash 'file' mmap()ed in)
> 
> I believe so. Is that a problem?

If we skipped the dcache maintenance on unmap, when the the dirty page is later reclaimed
the clean+stale lines are written back to the file. File-backed dirty pages will stick
around in the page cache in the hope someone else needs them.

This would happen for a guest:device-mapping that is written to, but is actually backed by
a mmap()d file. I think the EFI flash emulation does exactly this.


>> What if this isn't the only mapping of the page? Can't it be swapped
>> out from another VMA? (tenuous example, poor man's memory mirroring?)
> 
> Swap-out wouldn't trigger this code path, as it would use a different
> MMU notifier event (MMU_NOTIFY_CLEAR vs MMU_NOTIFY_UNMAP), I believe.

This was a half thought-through special case of the above. The sequence would be:

VM-A and VM-B both share a mapping of $page.

1. VM-A writes to $page through a device mapping
2. The kernel unmaps $page from VM-A for swap. KVM does the maintenance

3. VM-B writes to $page through a device mapping
4. VM-B exits, KVM skips the maintenance, $page may have clean+stale lines

5. Swap finds no further mappings, and writes $page and its clean+stale lines to disk.

Two VMs with a shared mapping is the 'easy' example. I think you just need a second
mapping for this to happen: it means the page isn't really free after the VM has exited.



Thanks,

James
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
