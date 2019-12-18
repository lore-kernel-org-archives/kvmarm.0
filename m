Return-Path: <SRS0=uTqP=2I=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 797EFC43603
	for <kvmarm@archiver.kernel.org>; Wed, 18 Dec 2019 15:30:29 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0A782206CB
	for <kvmarm@archiver.kernel.org>; Wed, 18 Dec 2019 15:30:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0A782206CB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 76C804A65C;
	Wed, 18 Dec 2019 10:30:28 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id VbU87L7SFQxt; Wed, 18 Dec 2019 10:30:27 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 846144A4CD;
	Wed, 18 Dec 2019 10:30:27 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5CDCC4A4CD
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Dec 2019 10:30:26 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Vcq-s0rlBiST for <kvmarm@lists.cs.columbia.edu>;
 Wed, 18 Dec 2019 10:30:25 -0500 (EST)
Received: from inca-roads.misterjones.org (inca-roads.misterjones.org
 [213.251.177.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 468884A483
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Dec 2019 10:30:25 -0500 (EST)
Received: from www-data by cheepnis.misterjones.org with local (Exim 4.80)
 (envelope-from <maz@kernel.org>)
 id 1ihbH2-0003tk-7u; Wed, 18 Dec 2019 16:30:04 +0100
To: James Morse <james.morse@arm.com>
Subject: Re: [PATCH 7/7] KVM: arm/arm64: Elide CMOs when unmapping a range
X-PHP-Originating-Script: 0:main.inc
MIME-Version: 1.0
Date: Wed, 18 Dec 2019 15:30:04 +0000
From: Marc Zyngier <maz@kernel.org>
In-Reply-To: <0c832b27-7041-a6c8-31c0-d71a25c6f5b8@arm.com>
References: <20191213182503.14460-1-maz@kernel.org>
 <20191213182503.14460-8-maz@kernel.org>
 <0c832b27-7041-a6c8-31c0-d71a25c6f5b8@arm.com>
Message-ID: <de462fe29fb40fb1644e6a071e6c0c69@www.loen.fr>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/0.7.2
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Rcpt-To: james.morse@arm.com, julien.thierry.kdev@gmail.com,
 suzuki.poulose@arm.com, jhogan@kernel.org, paulus@ozlabs.org,
 pbonzini@redhat.com, rkrcmar@redhat.com, sean.j.christopherson@intel.com,
 vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
 joro@8bytes.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
 kvm-ppc@vger.kernel.org, kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org);
 SAEximRunCond expanded to false
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi James,

On 2019-12-18 15:07, James Morse wrote:
> Hi Marc,
>
> On 13/12/2019 18:25, Marc Zyngier wrote:
>> If userspace issues a munmap() on a set of pages, there is no
>> expectation that the pages are cleaned to the PoC.
>
> (Pedantry: Clean and invalidate. If the guest wrote through a device
> mapping, we ditch any clean+stale lines with this path, meaning 
> swapout
> saves the correct values)

Indeed.

>> So let's
>> not do more work than strictly necessary, and set the magic
>> flag that avoids CMOs in this case.
>
> I think this assumes the pages went from anonymous->free, so no-one
> cares about the contents.
>
> If the pages are backed by a file, won't dirty pages will still get
> written back before the page is free? (e.g. EFI flash 'file' mmap()ed 
> in)

I believe so. Is that a problem?

> What if this isn't the only mapping of the page? Can't it be swapped
> out from another VMA? (tenuous example, poor man's memory mirroring?)

Swap-out wouldn't trigger this code path, as it would use a different
MMU notifier event (MMU_NOTIFY_CLEAR vs MMU_NOTIFY_UNMAP), I believe.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
