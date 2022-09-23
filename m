Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F49DC07E9D
	for <kvmarm@archiver.kernel.org>; Fri, 23 Sep 2022 18:26:28 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7A2E440E00;
	Fri, 23 Sep 2022 14:26:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id s4f1FZ-IFAc9; Fri, 23 Sep 2022 14:26:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 55D6F40FAA;
	Fri, 23 Sep 2022 14:26:27 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D8EE140E62
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Sep 2022 14:26:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id v+ZoczH+9yLG for <kvmarm@lists.cs.columbia.edu>;
 Fri, 23 Sep 2022 14:26:25 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A79A040BEF
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Sep 2022 14:26:25 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1663957585;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=sKwAzZec8KipecaZ1JzamS6Z7a4oJagSVbwGtwJhtZs=;
 b=LhVg+miHLZswEJ3rvelWPu69hZveZ525tI8T0nq06BZc7Z84ynogel2y4TP+xz9f/UeoEv
 /rm7ZX0iUVa/9X90FWv2Nzbah6DJkKyAAFIj0+9GBi0dVuH9RgfklfmTuAaHxk7H4HXOdU
 SYXUiazfBTXu7fm9HNbfW21zNo+SGSg=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-196-TICnAe7XM9K7EdXqVPC71Q-1; Fri, 23 Sep 2022 14:26:22 -0400
X-MC-Unique: TICnAe7XM9K7EdXqVPC71Q-1
Received: by mail-qv1-f69.google.com with SMTP id
 i10-20020ad45c6a000000b004a25d0fea96so417832qvh.3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Sep 2022 11:26:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
 bh=sKwAzZec8KipecaZ1JzamS6Z7a4oJagSVbwGtwJhtZs=;
 b=pUOk4RvQ/i08/C06RAmbrMu97/ndRmswqiFIy1wILPru5qHtnwbz/y+7LkWnuM6RTT
 X9ToIlJ3lS2SNYmI7sKb6inYF5EKycwDv9I41ggfgygJkpkRlVxHq0FAohhDpWy65bVQ
 e18jPFWmMxFosth/vyIMgO9v79ryD3SsgPev0HaQMC/l4/DsbLAmzPSvajpVTIXPc5BI
 U+SrmrmEWtNvHksYsjtODVzzAa4+4Q33rIKctTJbgIWI8pYhmqsvGqK4Cg8yvLQD0eae
 vl6MSgcpgOKIXGMy49zr/Irxdf9SuHWrHSnNA9XVLVVrISCjV5vcY7kU/xD8twd1Zc3D
 8j4Q==
X-Gm-Message-State: ACrzQf1BFe5HNZB3UOvembX5MMzmUb0Pk+Y3JlbDST7LY+74O0PuUyRe
 B7B1K1ZWqdH1jSY+4NSLrgr+jjN8QFgjsmEGZFaKRy+lJtIpOHLwRmyTANbCoVntYY/IKWO9PyL
 R0KdmDlHvMqzgpWtWs/v6v1+Y
X-Received: by 2002:a05:622a:1002:b0:35b:baaf:24bb with SMTP id
 d2-20020a05622a100200b0035bbaaf24bbmr8450486qte.85.1663957581655; 
 Fri, 23 Sep 2022 11:26:21 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5klgSD6rdsCB+xreJDWo2YXT/MOk2drMbEljCnhf9MK11IyCj/1lotbhwRYcmUHZVuWQJ/dw==
X-Received: by 2002:a05:622a:1002:b0:35b:baaf:24bb with SMTP id
 d2-20020a05622a100200b0035bbaaf24bbmr8450467qte.85.1663957581402; 
 Fri, 23 Sep 2022 11:26:21 -0700 (PDT)
Received: from x1n (bras-base-aurron9127w-grc-46-70-31-27-79.dsl.bell.ca.
 [70.31.27.79]) by smtp.gmail.com with ESMTPSA id
 u15-20020a05620a0c4f00b006cf19068261sm6714936qki.116.2022.09.23.11.26.19
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 23 Sep 2022 11:26:20 -0700 (PDT)
Date: Fri, 23 Sep 2022 14:26:18 -0400
From: Peter Xu <peterx@redhat.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 2/6] KVM: Add KVM_CAP_DIRTY_LOG_RING_ORDERED capability
 and config option
Message-ID: <Yy36Stppz4tYBPiP@x1n>
References: <20220922170133.2617189-1-maz@kernel.org>
 <20220922170133.2617189-3-maz@kernel.org>
 <YyzYI/bvp/JnbcxS@xz-m1.local> <87czbmjhbh.wl-maz@kernel.org>
MIME-Version: 1.0
In-Reply-To: <87czbmjhbh.wl-maz@kernel.org>
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

On Fri, Sep 23, 2022 at 03:28:34PM +0100, Marc Zyngier wrote:
> On Thu, 22 Sep 2022 22:48:19 +0100,
> Peter Xu <peterx@redhat.com> wrote:
> > 
> > On Thu, Sep 22, 2022 at 06:01:29PM +0100, Marc Zyngier wrote:
> > > In order to differenciate between architectures that require no extra
> > > synchronisation when accessing the dirty ring and those who do,
> > > add a new capability (KVM_CAP_DIRTY_LOG_RING_ORDERED) that identify
> > > the latter sort. TSO architectures can obviously advertise both, while
> > > relaxed architectures most only advertise the ORDERED version.
> > > 
> > > Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> > > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > > ---
> > >  include/linux/kvm_dirty_ring.h |  6 +++---
> > >  include/uapi/linux/kvm.h       |  1 +
> > >  virt/kvm/Kconfig               | 14 ++++++++++++++
> > >  virt/kvm/Makefile.kvm          |  2 +-
> > >  virt/kvm/kvm_main.c            | 11 +++++++++--
> > >  5 files changed, 28 insertions(+), 6 deletions(-)
> > > 
> > > diff --git a/include/linux/kvm_dirty_ring.h b/include/linux/kvm_dirty_ring.h
> > > index 906f899813dc..7a0c90ae9a3f 100644
> > > --- a/include/linux/kvm_dirty_ring.h
> > > +++ b/include/linux/kvm_dirty_ring.h
> > > @@ -27,7 +27,7 @@ struct kvm_dirty_ring {
> > >  	int index;
> > >  };
> > >  
> > > -#ifndef CONFIG_HAVE_KVM_DIRTY_RING
> > > +#ifndef CONFIG_HAVE_KVM_DIRTY_LOG
> > 
> > s/LOG/LOG_RING/ according to the commit message? Or the name seems too
> > generic.
> 
> The commit message talks about the capability, while the above is the
> config option. If you find the names inappropriate, feel free to
> suggest alternatives (for all I care, they could be called FOO, BAR
> and BAZ).

The existing name from David looks better than the new one.. to me.

> 
> > Pure question to ask: is it required to have a new cap just for the
> > ordering?  IIUC if x86 was the only supported anyway before, it means all
> > released old kvm binaries are always safe even without the strict
> > orderings.  As long as we rework all the memory ordering bits before
> > declaring support of yet another arch, we're good.  Or am I wrong?
> 
> Someone will show up with an old userspace which probes for the sole
> existing capability, and things start failing subtly. It is quite
> likely that the userspace code is built for all architectures,

I didn't quite follow here.  Since both kvm/qemu dirty ring was only
supported on x86, I don't see the risk.

Assuming we've the old binary.

If to run on old kernel, it'll work like before.

If to run on new kernel, the kernel will behave stricter on memory barriers
but should still be compatible with the old behavior (not vice versa, so
I'll understand if we're loosing the ordering, but we're not..).

Any further elaboration would be greatly helpful.

Thanks,

> and we
> want to make sure that userspace actively buys into the new ordering
> requirements. A simple way to do this is to expose a new capability,
> making the new requirement obvious. Architectures with relaxed
> ordering semantics will only implement the new one, while x86 will
> implement both.

-- 
Peter Xu

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
