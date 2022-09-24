Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16539C32771
	for <kvmarm@archiver.kernel.org>; Sat, 24 Sep 2022 13:29:56 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 815D14B62C;
	Sat, 24 Sep 2022 09:29:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FzImqtROnlc3; Sat, 24 Sep 2022 09:29:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1EDDE4B629;
	Sat, 24 Sep 2022 09:29:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 72B654B64D
 for <kvmarm@lists.cs.columbia.edu>; Sat, 24 Sep 2022 09:29:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4ZAQKt6k40ms for <kvmarm@lists.cs.columbia.edu>;
 Sat, 24 Sep 2022 09:29:52 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 507514B646
 for <kvmarm@lists.cs.columbia.edu>; Sat, 24 Sep 2022 09:29:52 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1664026192;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=qXr4DOckx0LDMYlOGBYzUKtsg02p6ZUhk0YKodVLz8o=;
 b=bVC63A+cog/bUjKl6V86Nj1cg6nS6K9M3FMXT0FKKlRehjVHxeE4aGwcA2pqOT+ajzDvmw
 2h/xn8Hz+0XDEoPY8vORjevpjcz17fmKalE04H0rOuvxpgvnv3qcL30N+PEaCSIKHMYksX
 XtBUh0MCSEs0H6Uh2KqzILL6P3aS0jQ=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-182-HAyRZILZM8yAVljWBr7oBQ-1; Sat, 24 Sep 2022 09:29:50 -0400
X-MC-Unique: HAyRZILZM8yAVljWBr7oBQ-1
Received: by mail-qk1-f198.google.com with SMTP id
 az15-20020a05620a170f00b006cece4cd0beso1846468qkb.22
 for <kvmarm@lists.cs.columbia.edu>; Sat, 24 Sep 2022 06:29:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
 bh=qXr4DOckx0LDMYlOGBYzUKtsg02p6ZUhk0YKodVLz8o=;
 b=K2OQ8tOv8oRp/rcsoECqDw2ExzvliCXPIs/OIbq6eHTM2CYWNJm5fFwM1jqFOOg8P/
 UgqLaNC1lwzGMvcMBP7XVm/dPkva+Cpu5qilSQ32L/OXMcHUbqthlNdnHb/OHPpkJ1P3
 vzwv6zCE87mvjhfkzeT0z+/Ql1UpfGjSjJoSXkAdRkdzQE0X8xqZA7LJ5JRvQLV+HqvD
 PIzmDQ7/HxlE0wtAlX5S8vntHzARniT+317pp8GYvCplgFwDdgWGM7f+8kk+MvYyHjXb
 HXL7co/YqME13VZEX1MmaU+C8JgIynY47Yj8hO7XSlvXygcRvwGsSlylnJO/DfU3hMHy
 px0Q==
X-Gm-Message-State: ACrzQf2d2wBTIAfiBgs9li7RHHnrR0DkNmEhW1B35dWNhX32J27/qltC
 XKsvvamcJbDSN9eB3lbMiLiyFBWO6H4/9VPJ+BX+5RQsHTE4G2aq2FUdxESytva6zc42Ehb0uFy
 Szc7r4jkBJHaHvVsloumITxhE
X-Received: by 2002:a05:620a:404e:b0:6ce:d80e:7813 with SMTP id
 i14-20020a05620a404e00b006ced80e7813mr8570049qko.421.1664026190200; 
 Sat, 24 Sep 2022 06:29:50 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7BwReIOcrFIDEbMHRQghN+FYjNbq3iIOl2p0fzSRr0eqxGkxb1FAuziFdB8lQzK6tmdQK8mA==
X-Received: by 2002:a05:620a:404e:b0:6ce:d80e:7813 with SMTP id
 i14-20020a05620a404e00b006ced80e7813mr8570039qko.421.1664026189990; 
 Sat, 24 Sep 2022 06:29:49 -0700 (PDT)
Received: from x1n (bras-base-aurron9127w-grc-46-70-31-27-79.dsl.bell.ca.
 [70.31.27.79]) by smtp.gmail.com with ESMTPSA id
 v11-20020a05622a014b00b0035cf0f50d7csm8283880qtw.52.2022.09.24.06.29.48
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sat, 24 Sep 2022 06:29:49 -0700 (PDT)
Date: Sat, 24 Sep 2022 09:29:47 -0400
From: Peter Xu <peterx@redhat.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 3/6] KVM: x86: Select CONFIG_HAVE_KVM_DIRTY_RING_ORDERED
Message-ID: <Yy8GSwk8vXPTMZU/@x1n>
References: <20220922170133.2617189-1-maz@kernel.org>
 <20220922170133.2617189-4-maz@kernel.org> <Yy43UM/+qTxc+/qt@x1n>
 <87fsghi2f4.wl-maz@kernel.org>
MIME-Version: 1.0
In-Reply-To: <87fsghi2f4.wl-maz@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kvm@vger.kernel.org, catalin.marinas@arm.com, andrew.jones@linux.dev,
 will@kernel.org, shan.gavin@gmail.com, bgardon@google.com, dmatlack@google.com,
 pbonzini@redhat.com, zhenyzha@redhat.com, shuah@kernel.org,
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

On Sat, Sep 24, 2022 at 09:47:59AM +0100, Marc Zyngier wrote:
> On Fri, 23 Sep 2022 23:46:40 +0100,
> Peter Xu <peterx@redhat.com> wrote:
> > 
> > On Thu, Sep 22, 2022 at 06:01:30PM +0100, Marc Zyngier wrote:
> > > Since x86 is TSO (give or take), allow it to advertise the new
> > > ORDERED version of the dirty ring capability. No other change is
> > > required for it.
> > > 
> > > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > > ---
> > >  arch/x86/kvm/Kconfig | 1 +
> > >  1 file changed, 1 insertion(+)
> > > 
> > > diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> > > index e3cbd7706136..eb63bc31ed1d 100644
> > > --- a/arch/x86/kvm/Kconfig
> > > +++ b/arch/x86/kvm/Kconfig
> > > @@ -29,6 +29,7 @@ config KVM
> > >  	select HAVE_KVM_PFNCACHE
> > >  	select HAVE_KVM_IRQFD
> > >  	select HAVE_KVM_DIRTY_RING
> > > +	select HAVE_KVM_DIRTY_RING_ORDERED
> > >  	select IRQ_BYPASS_MANAGER
> > >  	select HAVE_KVM_IRQ_BYPASS
> > >  	select HAVE_KVM_IRQ_ROUTING
> > 
> > Before patch 2-3, we only have HAVE_KVM_DIRTY_RING.
> > 
> > After that, we'll have:
> > 
> > HAVE_KVM_DIRTY_LOG
> > HAVE_KVM_DIRTY_RING
> > HAVE_KVM_DIRTY_RING_ORDERED
> > 
> > I'm wondering whether we can just keep using the old HAVE_KVM_DIRTY_RING,
> > but just declare a new KVM_CAP_DIRTY_LOG_RING_ORDERED only after all memory
> > barrier patches merged (after patch 1).
> 
> The problem is to decide, on a per architecture basis, how to expose
> the old property. I'm happy to key it on being x86 specific, but that
> feels pretty gross, and totally unnecessary for strongly ordered
> architectures (s390?).
> 
> > IIUC it's a matter of whether any of the arch would like to support
> > !ORDERED version of dirty ring at all, but then IIUC we'll need to have the
> > memory barriers conditional too or not sure how it'll help.
> 
> Memory barriers do not affect the semantics of the userspace, while
> the lack thereof do. On strongly ordered architectures,
> acquire/release is usually "free", because that's implied by their
> memory model. If it thus free for these to implement both versions of
> the API.

Right, that's why I thought it won't help.  now I see what you meant,
indeed if without the three config we'll need a x86 ifdef which may not be
as clean as this approach.  Thanks for explaining.

-- 
Peter Xu

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
