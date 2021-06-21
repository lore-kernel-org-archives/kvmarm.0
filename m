Return-Path: <SRS0=rYk4=LP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A67C4C48BE5
	for <kvmarm@archiver.kernel.org>; Mon, 21 Jun 2021 08:48:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 12D67611B0
	for <kvmarm@archiver.kernel.org>; Mon, 21 Jun 2021 08:48:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 12D67611B0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8D59E4024F;
	Mon, 21 Jun 2021 04:48:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QWb7VBQgs4YM; Mon, 21 Jun 2021 04:48:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4A67940629;
	Mon, 21 Jun 2021 04:48:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EACD54029F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Jun 2021 04:48:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YG45XfqoQOxC for <kvmarm@lists.cs.columbia.edu>;
 Mon, 21 Jun 2021 04:48:14 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1193D4024F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Jun 2021 04:48:13 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 399FA60C3D;
 Mon, 21 Jun 2021 08:48:10 +0000 (UTC)
Date: Mon, 21 Jun 2021 09:48:07 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Steven Price <steven.price@arm.com>
Subject: Re: [PATCH v16 7/7] KVM: arm64: Document MTE capability and ioctl
Message-ID: <20210621084806.GA11552@arm.com>
References: <20210618132826.54670-1-steven.price@arm.com>
 <20210618132826.54670-8-steven.price@arm.com>
 <20210618145241.GG16116@arm.com>
 <1273c642-d2b0-b81d-2052-1f2f0deafdae@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1273c642-d2b0-b81d-2052-1f2f0deafdae@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>, qemu-devel@nongnu.org,
 Marc Zyngier <maz@kernel.org>, Juan Quintela <quintela@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>, linux-kernel@vger.kernel.org,
 Dave Martin <Dave.Martin@arm.com>, linux-arm-kernel@lists.infradead.org,
 Thomas Gleixner <tglx@linutronix.de>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu
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

On Mon, Jun 21, 2021 at 09:18:31AM +0100, Steven Price wrote:
> On 18/06/2021 15:52, Catalin Marinas wrote:
> > On Fri, Jun 18, 2021 at 02:28:26PM +0100, Steven Price wrote:
> >> +When this capability is enabled all memory in (non-device) memslots must not
> >> +used VM_SHARED, attempts to create a memslot with a VM_SHARED mmap will result
> >> +in an -EINVAL return.
> > 
> > "must not used" doesn't sound right. Anyway, I'd remove VM_SHARED as
> > that's a kernel internal and not something the VMM needs to be aware of.
> > Just say something like "memslots must be mapped as shareable
> > (MAP_SHARED)".
> 
> I think I meant "must not use" - and indeed memslots must *not* be
> mapped as shareable. I'll update to this wording:
> 
>   When this capability is enabled all memory in memslots must be mapped as
>   not-shareable (no MAP_SHARED), attempts to create a memslot with MAP_SHARED
>   will result in an -EINVAL return.

It looks fine. Feel free to keep my reviewed-by.

-- 
Catalin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
