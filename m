Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD517C4332F
	for <kvmarm@archiver.kernel.org>; Wed,  2 Nov 2022 14:29:37 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 19A064B8FB;
	Wed,  2 Nov 2022 10:29:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id uSlyI9w73b+L; Wed,  2 Nov 2022 10:29:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D75D04B8EF;
	Wed,  2 Nov 2022 10:29:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 93F634B8EF
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Nov 2022 10:29:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Yqi1-ZQv-WRk for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Nov 2022 10:29:33 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2240F4B8E7
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Nov 2022 10:29:33 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1667399372;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=ps9cbOxn8myNQkKIEtCMET8fcnuAnpf2+gT/tQF2P5Q=;
 b=V67i33ud27R9qgMVFmMtF3uxltamfrgq3QEg1jFSZUPMZYQKMeXHj5kb6ERKROPL4C7XOq
 kZbq0C2eUxChtdDIuU2GYqniXT8LWY5sh76mkNbirjoBAsGTlllJgxk9934freiCKpxRr8
 MPiLxxI57kboqLZG9u7GyqUxc9yNVsw=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-592-gvnqdnAbMC-l4Eq0zxT0Mw-1; Wed, 02 Nov 2022 10:29:29 -0400
X-MC-Unique: gvnqdnAbMC-l4Eq0zxT0Mw-1
Received: by mail-qv1-f71.google.com with SMTP id
 mi12-20020a056214558c00b004bb63393567so10118464qvb.21
 for <kvmarm@lists.cs.columbia.edu>; Wed, 02 Nov 2022 07:29:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=ps9cbOxn8myNQkKIEtCMET8fcnuAnpf2+gT/tQF2P5Q=;
 b=IAVLR3Mn56gwD+HuetY05CID0if2dmGr7buNMxaSEUiCyALY4dHiWHZSnLXF+orr/J
 3Kc75l5ICK9Rrdg5MX/IfhnLKvsJ9rnK1n2MyYx4j7JSXfpZGrQJXHGeZ71GmMu1C8at
 2HunrrbDT4+oTOGzcY6dj1gk2DKEDWFue4eB1iIZfuX/bBEa99l8ApJw2pbecpBC3R6z
 Y0aoOOh61+6VA/WpjR3EcL7qDtGm8j5GaIRlNtZlTMSkQSXMuzz6N0ECZcHggltJ7Ldk
 3R8gfrGHXXJDQvYPlgVgQLYg5+iQFGwo7b5ytZDTpiinYNc/NXu7Hyr/uAQRBulMt9zm
 h9Qw==
X-Gm-Message-State: ACrzQf3RQKsC1Oum2ocwfTATpEPW1LjbTLchhvmOrv0t5oCeWl8ZIspL
 DSwcRcy+xfQRo3GOApbjMMZ8fulBRBYmDERkvGkpOaJt6iy8YEHPeQZBnKkz/A5m5d7+AOmhUIX
 g0Lb0elQOYnYnU7WoWQMYqoc4
X-Received: by 2002:a05:620a:f82:b0:6f9:d795:3f10 with SMTP id
 b2-20020a05620a0f8200b006f9d7953f10mr17162281qkn.675.1667399369242; 
 Wed, 02 Nov 2022 07:29:29 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7HQSoT03q9RYt45NNK062Snoc6XJiiqn2B5bpIZKFd3P+Iejj5f4Pza1S6pf/FRJShrYUf4w==
X-Received: by 2002:a05:620a:f82:b0:6f9:d795:3f10 with SMTP id
 b2-20020a05620a0f8200b006f9d7953f10mr17162243qkn.675.1667399368917; 
 Wed, 02 Nov 2022 07:29:28 -0700 (PDT)
Received: from x1n (bras-base-aurron9127w-grc-46-70-31-27-79.dsl.bell.ca.
 [70.31.27.79]) by smtp.gmail.com with ESMTPSA id
 ez5-20020a05622a4c8500b0039c37a7914csm6626967qtb.23.2022.11.02.07.29.27
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 02 Nov 2022 07:29:28 -0700 (PDT)
Date: Wed, 2 Nov 2022 10:29:26 -0400
From: Peter Xu <peterx@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH v7 1/9] KVM: x86: Introduce KVM_REQ_DIRTY_RING_SOFT_FULL
Message-ID: <Y2J+xhBYhqBI81f7@x1n>
References: <20221031003621.164306-1-gshan@redhat.com>
 <20221031003621.164306-2-gshan@redhat.com>
 <Y2F17Y7YG5Z9XnOJ@google.com>
MIME-Version: 1.0
In-Reply-To: <Y2F17Y7YG5Z9XnOJ@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: shuah@kernel.org, kvm@vger.kernel.org, maz@kernel.org,
 andrew.jones@linux.dev, dmatlack@google.com, will@kernel.org,
 shan.gavin@gmail.com, bgardon@google.com, kvmarm@lists.linux.dev,
 pbonzini@redhat.com, zhenyzha@redhat.com, catalin.marinas@arm.com,
 kvmarm@lists.cs.columbia.edu, ajones@ventanamicro.com
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

On Tue, Nov 01, 2022 at 07:39:25PM +0000, Sean Christopherson wrote:
> > @@ -142,13 +144,17 @@ int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring)
> >  
> >  	kvm_reset_dirty_gfn(kvm, cur_slot, cur_offset, mask);
> >  
> > +	if (!kvm_dirty_ring_soft_full(ring))
> > +		kvm_clear_request(KVM_REQ_DIRTY_RING_SOFT_FULL, vcpu);
> > +
> 
> Marc, Peter, and/or Paolo, can you confirm that clearing the request here won't
> cause ordering problems?  Logically, this makes perfect sense (to me, since I
> suggested it), but I'm mildly concerned I'm overlooking an edge case where KVM
> could end up with a soft-full ring but no pending request.

I don't see an ordering issue here, as long as kvm_clear_request() is using
atomic version of bit clear, afaict that's genuine RMW and should always
imply a full memory barrier (on any arch?) between the soft full check and
the bit clear.  At least for x86 the lock prefix was applied.

However I don't see anything stops a simple "race" to trigger like below:

          recycle thread                   vcpu thread
          --------------                   -----------
      if (!dirty_ring_soft_full)                                   <--- not full
                                        dirty_ring_push();
                                        if (dirty_ring_soft_full)  <--- full due to the push
                                            set_request(SOFT_FULL);
          clear_request(SOFT_FULL);                                <--- can wrongly clear the request?

But I don't think that's a huge matter, as it'll just let the vcpu to have
one more chance to do another round of KVM_RUN.  Normally I think it means
there can be one more dirty GFN (perhaps there're cases that it can push >1
gfns for one KVM_RUN cycle?  I never figured out the details here, but
still..) pushed to the ring so closer to the hard limit, but we have had a
buffer zone of KVM_DIRTY_RING_RSVD_ENTRIES (64) entries.  So I assume
that's still fine, but maybe worth a short comment here?

I never know what's the maximum possible GFNs being dirtied for a KVM_RUN
cycle.  It would be good if there's an answer to that from anyone.

-- 
Peter Xu

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
