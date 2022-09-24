Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF81CC07E9D
	for <kvmarm@archiver.kernel.org>; Sat, 24 Sep 2022 13:22:43 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4F09743399;
	Sat, 24 Sep 2022 09:22:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id kZeEOdcDjUEI; Sat, 24 Sep 2022 09:22:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 01F6D4B602;
	Sat, 24 Sep 2022 09:22:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9331F43399
 for <kvmarm@lists.cs.columbia.edu>; Sat, 24 Sep 2022 09:22:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NtMctY4SxQfZ for <kvmarm@lists.cs.columbia.edu>;
 Sat, 24 Sep 2022 09:22:39 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 018EA40FAA
 for <kvmarm@lists.cs.columbia.edu>; Sat, 24 Sep 2022 09:22:38 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1664025758;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=3uxj1+GKvLhjTJsBYDFACeIios9PGOogVxZ0xR9xLAE=;
 b=Gq6RXwKrghFcXohwn94Vwq6cn1CoD01DljMSYekfyzDYYM0a+eQmz/oAn+chUeENhOrV4G
 5F+4nQdS5rjQICl0EWaUfwIb+zls9AXrtTOH8rPyACauuoXL9UhUzs7rZI0QIAEZsDjTd4
 jBKCEgK5taBVidP0pdqPyL7Ehigyhck=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-654-nzM7erApOhiCWf2IHc2-Zw-1; Sat, 24 Sep 2022 09:22:35 -0400
X-MC-Unique: nzM7erApOhiCWf2IHc2-Zw-1
Received: by mail-qk1-f197.google.com with SMTP id
 bm21-20020a05620a199500b006cf6a722b16so1885922qkb.0
 for <kvmarm@lists.cs.columbia.edu>; Sat, 24 Sep 2022 06:22:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
 bh=3uxj1+GKvLhjTJsBYDFACeIios9PGOogVxZ0xR9xLAE=;
 b=dTapU9YNHY80K4Q9728JN/XhXfSdmdeTwAH/sspMVU4l5eoN5FDRYEVdnnTmUQMozR
 3sMSTmJnZgjUNJQ5OUJMnUV1bXc7cakm00YoFj/bHPwYzp4IYJiF/INeU52z8N4HTjEZ
 5w214c1xMLVilpHkAGbgQiu3rJ9I9n3z0fvLwgXIHG6XEQztzkAYGrxEDly8kgx63PoK
 QTHy9VRcKBwvFfZzk+ekAyfjFN4BGPAfmWo3DHpoBaRqIaLh4DmIeCNIRRDUNMUIqvQB
 Szagpog3tF+MtDCgkGFs7eVJ6jCgLlLZJL6Ewy5n6j6tdSm93gX2TOjyV5/gEZd92f8+
 uskQ==
X-Gm-Message-State: ACrzQf1vfQmYWDb+4/vPZfCfvMa2phZlpiGBgj3Ua5q+pzbJircbOgxL
 G2pMdHwpeaJ2TMTUT3NsY0EHnsOSxlqL0bepq2r83JZIh58Gfz0T5HYQks/i2Y0AEVU1q2dt2dI
 7lsVhYxZ6UQrPHISyI3dV4Bm6
X-Received: by 2002:ae9:efc9:0:b0:6cb:e321:12fb with SMTP id
 d192-20020ae9efc9000000b006cbe32112fbmr8522658qkg.446.1664025754894; 
 Sat, 24 Sep 2022 06:22:34 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5YA1JL1/uDMHUoxAlHxScMC7JDEiu9eEbcqunQtBxM+ofG9JVSf89kU1SBvFY6Em2al/iirQ==
X-Received: by 2002:ae9:efc9:0:b0:6cb:e321:12fb with SMTP id
 d192-20020ae9efc9000000b006cbe32112fbmr8522645qkg.446.1664025754653; 
 Sat, 24 Sep 2022 06:22:34 -0700 (PDT)
Received: from x1n (bras-base-aurron9127w-grc-46-70-31-27-79.dsl.bell.ca.
 [70.31.27.79]) by smtp.gmail.com with ESMTPSA id
 s2-20020a05620a29c200b006ce40fbb8f6sm7649270qkp.21.2022.09.24.06.22.33
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sat, 24 Sep 2022 06:22:34 -0700 (PDT)
Date: Sat, 24 Sep 2022 09:22:32 -0400
From: Peter Xu <peterx@redhat.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 2/6] KVM: Add KVM_CAP_DIRTY_LOG_RING_ORDERED capability
 and config option
Message-ID: <Yy8EmMhF+2jcm3m6@x1n>
References: <20220922170133.2617189-1-maz@kernel.org>
 <20220922170133.2617189-3-maz@kernel.org>
 <YyzYI/bvp/JnbcxS@xz-m1.local> <87czbmjhbh.wl-maz@kernel.org>
 <Yy36Stppz4tYBPiP@x1n> <87edw1i290.wl-maz@kernel.org>
 <87czblhv2a.wl-maz@kernel.org>
MIME-Version: 1.0
In-Reply-To: <87czblhv2a.wl-maz@kernel.org>
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

On Sat, Sep 24, 2022 at 12:26:53PM +0100, Marc Zyngier wrote:
> On Sat, 24 Sep 2022 09:51:39 +0100,
> Marc Zyngier <maz@kernel.org> wrote:
> > 
> > On Fri, 23 Sep 2022 19:26:18 +0100,
> > Peter Xu <peterx@redhat.com> wrote:
> > > 
> > > On Fri, Sep 23, 2022 at 03:28:34PM +0100, Marc Zyngier wrote:
> > > > On Thu, 22 Sep 2022 22:48:19 +0100,
> > > > Peter Xu <peterx@redhat.com> wrote:
> > > > > 
> > > > > On Thu, Sep 22, 2022 at 06:01:29PM +0100, Marc Zyngier wrote:
> > > > > > In order to differenciate between architectures that require no extra
> > > > > > synchronisation when accessing the dirty ring and those who do,
> > > > > > add a new capability (KVM_CAP_DIRTY_LOG_RING_ORDERED) that identify
> > > > > > the latter sort. TSO architectures can obviously advertise both, while
> > > > > > relaxed architectures most only advertise the ORDERED version.
> > > > > > 
> > > > > > Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> > > > > > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > > > > > ---
> > > > > >  include/linux/kvm_dirty_ring.h |  6 +++---
> > > > > >  include/uapi/linux/kvm.h       |  1 +
> > > > > >  virt/kvm/Kconfig               | 14 ++++++++++++++
> > > > > >  virt/kvm/Makefile.kvm          |  2 +-
> > > > > >  virt/kvm/kvm_main.c            | 11 +++++++++--
> > > > > >  5 files changed, 28 insertions(+), 6 deletions(-)
> > > > > > 
> > > > > > diff --git a/include/linux/kvm_dirty_ring.h b/include/linux/kvm_dirty_ring.h
> > > > > > index 906f899813dc..7a0c90ae9a3f 100644
> > > > > > --- a/include/linux/kvm_dirty_ring.h
> > > > > > +++ b/include/linux/kvm_dirty_ring.h
> > > > > > @@ -27,7 +27,7 @@ struct kvm_dirty_ring {
> > > > > >  	int index;
> > > > > >  };
> > > > > >  
> > > > > > -#ifndef CONFIG_HAVE_KVM_DIRTY_RING
> > > > > > +#ifndef CONFIG_HAVE_KVM_DIRTY_LOG
> > > > > 
> > > > > s/LOG/LOG_RING/ according to the commit message? Or the name seems too
> > > > > generic.
> > > > 
> > > > The commit message talks about the capability, while the above is the
> > > > config option. If you find the names inappropriate, feel free to
> > > > suggest alternatives (for all I care, they could be called FOO, BAR
> > > > and BAZ).
> > > 
> > > The existing name from David looks better than the new one.. to me.
> > 
> > I'm happy to bikeshed, but please spell it out for me. If we follow
> > the current scheme, we need 3 configuration symbols (of which we
> > already have one), and 2 capabilities (of which we already have one).

I hope it's not bikeshedding.  I normally don't comment on namings at all
because many of them can be "bikeshedding" to me.  But this one is so
special because it directly collides with KVM_GET_DIRTY_LOG, which is other
method of dirty tracking.

> > 
> > Do you have any concrete proposal for those?
> 
> In order to make some forward progress, I've reworked the series[1]
> with another proposal for those:
> 
> Config symbols:
> 
> - HAVE_KVM_DIRTY_RING:
>   * mostly the same meaning as today
>   * not directly selected by any architecture
>   * doesn't expose any capability on its own
> 
> - HAVE_KVM_DIRTY_RING_TSO:
>   * only for strongly ordered architectures
>   * selects HAVE_KVM_DIRTY_RING
>   * exposes KVM_CAP_DIRTY_LOG_RING
>   * selected by x86
> 
> - HAVE_KVM_DIRTY_RING_ACQ_REL:
>   * selects HAVE_KVM_DIRTY_RING
>   * exposes KVM_CAP_DIRTY_LOG_RING_ACQ_REL
>   * selected by arm64 and x86
> 
> Capabilities:
> 
> - KVM_CAP_DIRTY_LOG_RING: the good old x86-specific stuff, advertised
>   when HAVE_KVM_DIRTY_RING_TSO is selected
> 
> - KVM_CAP_DIRTY_LOG_RING_ACQ_REL: the new acquire/release semantics,
>   advertised when HAVE_KVM_DIRTY_RING_ACQ_REL is selected
> 
> This significantly reduces the churn and makes things slightly more
> explicit.

This looks good to me, thanks.

-- 
Peter Xu

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
