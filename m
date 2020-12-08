Return-Path: <SRS0=0wdR=FM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45E36C4361B
	for <kvmarm@archiver.kernel.org>; Tue,  8 Dec 2020 18:21:21 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AA79523B4B
	for <kvmarm@archiver.kernel.org>; Tue,  8 Dec 2020 18:21:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AA79523B4B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 184514B270;
	Tue,  8 Dec 2020 13:21:20 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4t6g-T7leaUF; Tue,  8 Dec 2020 13:21:18 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EC85A4B135;
	Tue,  8 Dec 2020 13:21:18 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 00D294B129
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Dec 2020 13:21:17 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jsxtHF3Xyb11 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Dec 2020 13:21:15 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C70B84B125
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Dec 2020 13:21:15 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id A5E3823B46;
 Tue,  8 Dec 2020 18:21:14 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kmhbs-00H9Yx-CO; Tue, 08 Dec 2020 18:21:12 +0000
MIME-Version: 1.0
Date: Tue, 08 Dec 2020 18:21:12 +0000
From: Marc Zyngier <maz@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v5 0/2] MTE support for KVM guest
In-Reply-To: <20201208172143.GB13960@gaia>
References: <20201119184248.4bycy6ouvaxqdiiy@kamzik.brq.redhat.com>
 <db5ad775fa7cfe7defbd78d9ca6ccfd8@kernel.org>
 <c25c297e-e9b5-ab3f-e401-c21ddd4d2ad1@arm.com>
 <CAJc+Z1H7akXwDtVvQLiGVVyZ0DfmsxyJQhE7Sno6aAO9GaafEA@mail.gmail.com>
 <46fd98a2-ee39-0086-9159-b38c406935ab@arm.com>
 <CAFEAcA_Q8RSB-zcS8+cEfvWz_0U5GLzmsf12m_7BFjX8h-1hrA@mail.gmail.com>
 <b975422f-14fd-13b3-c8ca-e8b1a68c0837@arm.com>
 <0d0eb6da6a11f76d10e532c157181985@kernel.org> <20201207163405.GD1526@gaia>
 <874kkx5thq.wl-maz@kernel.org> <20201208172143.GB13960@gaia>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <7ff14490e253878d0735633b792e1ea9@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: catalin.marinas@arm.com, steven.price@arm.com,
 peter.maydell@linaro.org, haibo.xu@linaro.org, linux-kernel@vger.kernel.org,
 quintela@redhat.com, richard.henderson@linaro.org, qemu-devel@nongnu.org,
 dgilbert@redhat.com, tglx@linutronix.de, will@kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 Dave.Martin@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Juan Quintela <quintela@redhat.com>,
 QEMU Developers <qemu-devel@nongnu.org>, Dave Martin <Dave.Martin@arm.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Steven Price <steven.price@arm.com>,
 arm-mail-list <linux-arm-kernel@lists.infradead.org>,
 Thomas Gleixner <tglx@linutronix.de>, Will Deacon <will@kernel.org>,
 kvmarm <kvmarm@lists.cs.columbia.edu>,
 "Dr. David Alan Gilbert" <dgilbert@redhat.com>
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

On 2020-12-08 17:21, Catalin Marinas wrote:
> On Mon, Dec 07, 2020 at 07:03:13PM +0000, Marc Zyngier wrote:
>> On Mon, 07 Dec 2020 16:34:05 +0000,
>> Catalin Marinas <catalin.marinas@arm.com> wrote:
>> > On Mon, Dec 07, 2020 at 04:05:55PM +0000, Marc Zyngier wrote:
>> > > What I'd really like to see is a description of how shared memory
>> > > is, in general, supposed to work with MTE. My gut feeling is that
>> > > it doesn't, and that you need to turn MTE off when sharing memory
>> > > (either implicitly or explicitly).
>> >
>> > The allocation tag (in-memory tag) is a property assigned to a physical
>> > address range and it can be safely shared between different processes as
>> > long as they access it via pointers with the same allocation tag (bits
>> > 59:56). The kernel enables such tagged shared memory for user processes
>> > (anonymous, tmpfs, shmem).
>> 
>> I think that's one case where the shared memory scheme breaks, as we
>> have two kernels in charge of their own tags, and they obviously can't
>> be synchronised
> 
> Yes, if you can't trust the other entity to not change the tags, the
> only option is to do an untagged access.
> 
>> > What we don't have in the architecture is a memory type which allows
>> > access to tags but no tag checking. To access the data when the tags
>> > aren't known, the tag checking would have to be disabled via either a
>> > prctl() or by setting the PSTATE.TCO bit.
>> 
>> I guess that's point (3) in Steven's taxonomy. It still a bit ugly to
>> fit in an existing piece of userspace, specially if it wants to use
>> MTE for its own benefit.
> 
> I agree it's ugly. For the device DMA emulation case, the only sane way
> is to mimic what a real device does - no tag checking. For a generic
> implementation, this means that such shared memory should not be mapped
> with PROT_MTE on the VMM side. I guess this leads to your point that
> sharing doesn't work for this scenario ;).

Exactly ;-)

>> > The kernel accesses the user memory via the linear map using a match-all
>> > tag 0xf, so no TCO bit toggling. For user, however, we disabled such
>> > match-all tag and it cannot be enabled at run-time (at least not easily,
>> > it's cached in the TLB). However, we already have two modes to disable
>> > tag checking which Qemu could use when migrating data+tags.
>> 
>> I wonder whether we will have to have something kernel side to
>> dump/reload tags in a way that matches the patterns used by live
>> migration.
> 
> We have something related - ptrace dumps/resores the tags. Can the same
> concept be expanded to a KVM ioctl?

Yes, although I wonder whether we should integrate this deeply into
the dirty-log mechanism: it would be really interesting to dump the
tags at the point where the page is flagged as clean from a dirty-log
point of view. As the page is dirtied, discard the saved tags.

It is probably expensive, but it ensures that the VMM sees consistent
tags (if the page is clean, the tags are valid). Of course, it comes
with the added requirement that the VMM allocates enough memory to
store the tags, which may be a tall order. I'm not sure how to
give a consistent view to userspace otherwise.

It'd be worth looking at how much we can reuse from the ptrace (and
I expect swap?) code to implement this.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
