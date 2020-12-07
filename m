Return-Path: <SRS0=wPN+=FL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0306C433FE
	for <kvmarm@archiver.kernel.org>; Mon,  7 Dec 2020 16:44:42 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 00E0E23787
	for <kvmarm@archiver.kernel.org>; Mon,  7 Dec 2020 16:44:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 00E0E23787
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1ADE94B281;
	Mon,  7 Dec 2020 11:44:41 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5qWnD5ShQIdg; Mon,  7 Dec 2020 11:44:40 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0C7D14B234;
	Mon,  7 Dec 2020 11:44:40 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E1C7C4B234
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Dec 2020 11:44:38 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hOyG-MIWO7Rw for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Dec 2020 11:44:38 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [63.128.21.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0162A4B137
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Dec 2020 11:44:37 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1607359477;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=UgdjE4fKcDjZBY/heUx1DQEDENSCD7DYWWLFE/GwBEg=;
 b=AiaaUCVjHrh0hsEJDm7XD1DLKeFeODroWOcMEKElNocjWdD6QJiazBUI6e+XlMMrZPnGGr
 F8O9ilw/PxpDF1ddAFb+1BEL4WknsTAl3iMl/P4/8yg5toi04zaRiuI7HZDq59d6oQgwBj
 0JTOE9AJxHD1aKb4FGaFjtyH+5jzj9g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-212-xjKu7mQ6NxSw7npi5lgtfA-1; Mon, 07 Dec 2020 11:44:36 -0500
X-MC-Unique: xjKu7mQ6NxSw7npi5lgtfA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
 [10.5.11.12])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1C09D1922020;
 Mon,  7 Dec 2020 16:44:34 +0000 (UTC)
Received: from work-vm (ovpn-114-87.ams2.redhat.com [10.36.114.87])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 32D6A60C0F;
 Mon,  7 Dec 2020 16:44:30 +0000 (UTC)
Date: Mon, 7 Dec 2020 16:44:28 +0000
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To: Steven Price <steven.price@arm.com>, dgibson@redhat.com
Subject: Re: [PATCH v5 0/2] MTE support for KVM guest
Message-ID: <20201207164428.GD3135@work-vm>
References: <20201119153901.53705-1-steven.price@arm.com>
 <CAFEAcA85fiqA206FuFANKbV_3GkfY1F8Gv7MP58BgTT81bs9kA@mail.gmail.com>
 <20201119184248.4bycy6ouvaxqdiiy@kamzik.brq.redhat.com>
 <db5ad775fa7cfe7defbd78d9ca6ccfd8@kernel.org>
 <c25c297e-e9b5-ab3f-e401-c21ddd4d2ad1@arm.com>
 <CAJc+Z1H7akXwDtVvQLiGVVyZ0DfmsxyJQhE7Sno6aAO9GaafEA@mail.gmail.com>
 <46fd98a2-ee39-0086-9159-b38c406935ab@arm.com>
 <CAFEAcA_Q8RSB-zcS8+cEfvWz_0U5GLzmsf12m_7BFjX8h-1hrA@mail.gmail.com>
 <b975422f-14fd-13b3-c8ca-e8b1a68c0837@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <b975422f-14fd-13b3-c8ca-e8b1a68c0837@arm.com>
User-Agent: Mutt/1.14.6 (2020-07-11)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Cc: Juan Quintela <quintela@redhat.com>, Marc Zyngier <maz@kernel.org>,
 Richard Henderson <richard.henderson@linaro.org>,
 lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
 QEMU Developers <qemu-devel@nongnu.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Thomas Gleixner <tglx@linutronix.de>, Will Deacon <will@kernel.org>,
 kvmarm <kvmarm@lists.cs.columbia.edu>,
 arm-mail-list <linux-arm-kernel@lists.infradead.org>,
 Dave Martin <Dave.Martin@arm.com>
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

* Steven Price (steven.price@arm.com) wrote:
> On 07/12/2020 15:27, Peter Maydell wrote:
> > On Mon, 7 Dec 2020 at 14:48, Steven Price <steven.price@arm.com> wrote:
> > > Sounds like you are making good progress - thanks for the update. Have
> > > you thought about how the PROT_MTE mappings might work if QEMU itself
> > > were to use MTE? My worry is that we end up with MTE in a guest
> > > preventing QEMU from using MTE itself (because of the PROT_MTE
> > > mappings). I'm hoping QEMU can wrap its use of guest memory in a
> > > sequence which disables tag checking (something similar will be needed
> > > for the "protected VM" use case anyway), but this isn't something I've
> > > looked into.
> > 
> > It's not entirely the same as the "protected VM" case. For that
> > the patches currently on list basically special case "this is a
> > debug access (eg from gdbstub/monitor)" which then either gets
> > to go via "decrypt guest RAM for debug" or gets failed depending
> > on whether the VM has a debug-is-ok flag enabled. For an MTE
> > guest the common case will be guests doing standard DMA operations
> > to or from guest memory. The ideal API for that from QEMU's
> > point of view would be "accesses to guest RAM don't do tag
> > checks, even if tag checks are enabled for accesses QEMU does to
> > memory it has allocated itself as a normal userspace program".
> 
> Sorry, I know I simplified it rather by saying it's similar to protected VM.
> Basically as I see it there are three types of memory access:
> 
> 1) Debug case - has to go via a special case for decryption or ignoring the
> MTE tag value. Hopefully this can be abstracted in the same way.
> 
> 2) Migration - for a protected VM there's likely to be a special method to
> allow the VMM access to the encrypted memory (AFAIK memory is usually kept
> inaccessible to the VMM). For MTE this again has to be special cased as we
> actually want both the data and the tag values.
> 
> 3) Device DMA - for a protected VM it's usual to unencrypt a small area of
> memory (with the permission of the guest) and use that as a bounce buffer.
> This is possible with MTE: have an area the VMM purposefully maps with
> PROT_MTE. The issue is that this has a performance overhead and we can do
> better with MTE because it's trivial for the VMM to disable the protection
> for any memory.

Those all sound very similar to the AMD SEV world;  there's the special
case for Debug that Peter mentioned; migration is ...complicated and
needs special case that's still being figured out, and as I understand
Device DMA also uses a bounce buffer (and swiotlb in the guest to make
that happen).


I'm not sure about the stories for the IBM hardware equivalents.

Dave

> The part I'm unsure on is how easy it is for QEMU to deal with (3) without
> the overhead of bounce buffers. Ideally there'd already be a wrapper for
> guest memory accesses and that could just be wrapped with setting TCO during
> the access. I suspect the actual situation is more complex though, and I'm
> hoping Haibo's investigations will help us understand this.
> 
> Thanks,
> 
> Steve
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
