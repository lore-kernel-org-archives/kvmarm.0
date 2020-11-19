Return-Path: <SRS0=Ckwh=EZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55091C63697
	for <kvmarm@archiver.kernel.org>; Thu, 19 Nov 2020 15:57:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8D82D22248
	for <kvmarm@archiver.kernel.org>; Thu, 19 Nov 2020 15:57:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8D82D22248
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BDDDC4B4CB;
	Thu, 19 Nov 2020 10:57:50 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 95feHaAPYui6; Thu, 19 Nov 2020 10:57:49 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A91BA4B4E4;
	Thu, 19 Nov 2020 10:57:49 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C64524B4CA
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Nov 2020 10:57:48 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id y1KjoMXuBtlT for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 Nov 2020 10:57:47 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 92A794B4A7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Nov 2020 10:57:47 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 407571478;
 Thu, 19 Nov 2020 07:57:47 -0800 (PST)
Received: from [192.168.1.179] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E23D33F719;
 Thu, 19 Nov 2020 07:57:44 -0800 (PST)
Subject: Re: [PATCH v5 0/2] MTE support for KVM guest
To: Peter Maydell <peter.maydell@linaro.org>
References: <20201119153901.53705-1-steven.price@arm.com>
 <CAFEAcA85fiqA206FuFANKbV_3GkfY1F8Gv7MP58BgTT81bs9kA@mail.gmail.com>
From: Steven Price <steven.price@arm.com>
Message-ID: <b434977d-08d7-f753-f95c-81fc533cae0a@arm.com>
Date: Thu, 19 Nov 2020 15:57:43 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAFEAcA85fiqA206FuFANKbV_3GkfY1F8Gv7MP58BgTT81bs9kA@mail.gmail.com>
Content-Language: en-GB
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
 QEMU Developers <qemu-devel@nongnu.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Juan Quintela <quintela@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Dave Martin <Dave.Martin@arm.com>,
 arm-mail-list <linux-arm-kernel@lists.infradead.org>,
 Marc Zyngier <maz@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
 Will Deacon <will@kernel.org>, kvmarm <kvmarm@lists.cs.columbia.edu>
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

On 19/11/2020 15:45, Peter Maydell wrote:
> On Thu, 19 Nov 2020 at 15:39, Steven Price <steven.price@arm.com> wrote:
>> This series adds support for Arm's Memory Tagging Extension (MTE) to
>> KVM, allowing KVM guests to make use of it. This builds on the existing
>> user space support already in v5.10-rc1, see [1] for an overview.
> 
>> The change to require the VMM to map all guest memory PROT_MTE is
>> significant as it means that the VMM has to deal with the MTE tags even
>> if it doesn't care about them (e.g. for virtual devices or if the VMM
>> doesn't support migration). Also unfortunately because the VMM can
>> change the memory layout at any time the check for PROT_MTE/VM_MTE has
>> to be done very late (at the point of faulting pages into stage 2).
> 
> I'm a bit dubious about requring the VMM to map the guest memory
> PROT_MTE unless somebody's done at least a sketch of the design
> for how this would work on the QEMU side. Currently QEMU just
> assumes the guest memory is guest memory and it can access it
> without special precautions...

I agree this needs some investigation - I'm hoping Haibo will be able to 
provide some feedback here as he has been looking at the QEMU support. 
However the VMM is likely going to require some significant changes to 
ensure that migration doesn't break, so either way there's work to be done.

Fundamentally most memory will need a mapping with PROT_MTE just so the 
VMM can get at the tags for migration purposes, so QEMU is going to have 
to learn how to treat guest memory specially if it wants to be able to 
enable MTE for both itself and the guest.

I'll also hunt down what's happening with my attempts to fix the 
set_pte_at() handling for swap and I'll post that as an alternative if 
it turns out to be a reasonable approach. But I don't think that solve 
the QEMU issue above.

The other alternative would be to implement a new kernel interface to 
fetch tags from the guest and not require the VMM to maintain a PROT_MTE 
mapping. But we need some real feedback from someone familiar with QEMU 
to know what that interface should look like. So I'm holding off on that 
until there's a 'real' PoC implementation.

Thanks,

Steve
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
