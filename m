Return-Path: <SRS0=wPN+=FL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24A27C433FE
	for <kvmarm@archiver.kernel.org>; Mon,  7 Dec 2020 17:44:32 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7D9D621D42
	for <kvmarm@archiver.kernel.org>; Mon,  7 Dec 2020 17:44:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7D9D621D42
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 035614B26F;
	Mon,  7 Dec 2020 12:44:31 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ozSEUoXpzvPo; Mon,  7 Dec 2020 12:44:29 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D693C4B2A6;
	Mon,  7 Dec 2020 12:44:29 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5ABEB4B27F
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Dec 2020 12:44:28 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QPg6Su6LkjnO for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Dec 2020 12:44:27 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [63.128.21.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3D6FA4B27C
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Dec 2020 12:44:27 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1607363067;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=8CxERT4u5MDQXm5Jldr8EFPIiLsHrezNO76Dqv+04UU=;
 b=EpH1IcSnQwM7xzC6qsDRe24aecl/7ZFiKVqLTrn8cbqX2HixhfgZKtdQ1sJS9SJjNe37eK
 a78G/kQvYf49j2YMnCm0ESEhyN0F4KtlHVbVf3m9MFNd6RwArUM52IZPPtxt693/M1wkcM
 //VIZBl455iiKIhFokl3yqSKQAw7JAY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-380-1LUvcVXBNISK6Oz0QmAItQ-1; Mon, 07 Dec 2020 12:44:25 -0500
X-MC-Unique: 1LUvcVXBNISK6Oz0QmAItQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
 [10.5.11.11])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9FF75804024;
 Mon,  7 Dec 2020 17:44:23 +0000 (UTC)
Received: from work-vm (ovpn-114-87.ams2.redhat.com [10.36.114.87])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B8F6C60636;
 Mon,  7 Dec 2020 17:44:20 +0000 (UTC)
Date: Mon, 7 Dec 2020 17:44:18 +0000
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH v5 0/2] MTE support for KVM guest
Message-ID: <20201207174418.GF3135@work-vm>
References: <CAFEAcA85fiqA206FuFANKbV_3GkfY1F8Gv7MP58BgTT81bs9kA@mail.gmail.com>
 <20201119184248.4bycy6ouvaxqdiiy@kamzik.brq.redhat.com>
 <db5ad775fa7cfe7defbd78d9ca6ccfd8@kernel.org>
 <c25c297e-e9b5-ab3f-e401-c21ddd4d2ad1@arm.com>
 <CAJc+Z1H7akXwDtVvQLiGVVyZ0DfmsxyJQhE7Sno6aAO9GaafEA@mail.gmail.com>
 <46fd98a2-ee39-0086-9159-b38c406935ab@arm.com>
 <CAFEAcA_Q8RSB-zcS8+cEfvWz_0U5GLzmsf12m_7BFjX8h-1hrA@mail.gmail.com>
 <b975422f-14fd-13b3-c8ca-e8b1a68c0837@arm.com>
 <20201207164428.GD3135@work-vm>
 <CAFEAcA9mq0xh1CNvw9UZoNwcOBuoVnCNcBkRDSUv7UK27qdESg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAFEAcA9mq0xh1CNvw9UZoNwcOBuoVnCNcBkRDSUv7UK27qdESg@mail.gmail.com>
User-Agent: Mutt/1.14.6 (2020-07-11)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Cc: Juan Quintela <quintela@redhat.com>,
 QEMU Developers <qemu-devel@nongnu.org>, Marc Zyngier <maz@kernel.org>,
 Richard Henderson <richard.henderson@linaro.org>,
 lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Steven Price <steven.price@arm.com>, Catalin Marinas <catalin.marinas@arm.com>,
 David Gibson <dgibson@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
 Will Deacon <will@kernel.org>, kvmarm <kvmarm@lists.cs.columbia.edu>,
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

* Peter Maydell (peter.maydell@linaro.org) wrote:
> On Mon, 7 Dec 2020 at 16:44, Dr. David Alan Gilbert <dgilbert@redhat.com> wrote:
> > * Steven Price (steven.price@arm.com) wrote:
> > > Sorry, I know I simplified it rather by saying it's similar to protected VM.
> > > Basically as I see it there are three types of memory access:
> > >
> > > 1) Debug case - has to go via a special case for decryption or ignoring the
> > > MTE tag value. Hopefully this can be abstracted in the same way.
> > >
> > > 2) Migration - for a protected VM there's likely to be a special method to
> > > allow the VMM access to the encrypted memory (AFAIK memory is usually kept
> > > inaccessible to the VMM). For MTE this again has to be special cased as we
> > > actually want both the data and the tag values.
> > >
> > > 3) Device DMA - for a protected VM it's usual to unencrypt a small area of
> > > memory (with the permission of the guest) and use that as a bounce buffer.
> > > This is possible with MTE: have an area the VMM purposefully maps with
> > > PROT_MTE. The issue is that this has a performance overhead and we can do
> > > better with MTE because it's trivial for the VMM to disable the protection
> > > for any memory.
> >
> > Those all sound very similar to the AMD SEV world;  there's the special
> > case for Debug that Peter mentioned; migration is ...complicated and
> > needs special case that's still being figured out, and as I understand
> > Device DMA also uses a bounce buffer (and swiotlb in the guest to make
> > that happen).
> 
> Mmm, but for encrypted VMs the VM has to jump through all these
> hoops because "don't let the VM directly access arbitrary guest RAM"
> is the whole point of the feature. For MTE, we don't want in general
> to be doing tag-checked accesses to guest RAM and there is nothing
> in the feature "allow guests to use MTE" that requires that the VMM's
> guest RAM accesses must do tag-checking. So we should avoid having
> a design that require us to jump through all the hoops.

Yes agreed, that's a fair distinction.

Dave


 Even if
> it happens that handling encrypted VMs means that QEMU has to grow
> some infrastructure for carefully positioning hoops in appropriate
> places, we shouldn't use it unnecessarily... All we actually need is
> a mechanism for migrating the tags: I don't think there's ever a
> situation where you want tag-checking enabled for the VMM's accesses
> to the guest RAM.
> 
> thanks
> -- PMM
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
