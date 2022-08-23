Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7CACC3F6B0
	for <kvmarm@archiver.kernel.org>; Tue, 23 Aug 2022 23:19:15 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 08B3A4C573;
	Tue, 23 Aug 2022 19:19:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lITs6uivbq5E; Tue, 23 Aug 2022 19:19:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B21904C578;
	Tue, 23 Aug 2022 19:19:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 866134C573
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Aug 2022 19:19:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xQ+WE0oasoZw for <kvmarm@lists.cs.columbia.edu>;
 Tue, 23 Aug 2022 19:19:11 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0E0844C56B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Aug 2022 19:19:10 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1661296750;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=Ejd2XqlPIsLaN92xua+1YOCeIUPLipE6EMcANIURHpk=;
 b=GaRBxrW7Se08u39DZdK8ByMaOQVXRtkTe70bkf5M1TxrF50rczUQPAdx6a8ZqW8djylJfA
 wFsV+46uqnkzAeYbntY+/JkrCF/y+F6aAdelTM7lD0uekIla1OCSlI6lXZdq+0/wfMtQfA
 eSg2KUOIKmjatZ/c4MC2efo3nl9AQxQ=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-202-yg-su6N-MT60-12FFZI8Aw-1; Tue, 23 Aug 2022 19:19:09 -0400
X-MC-Unique: yg-su6N-MT60-12FFZI8Aw-1
Received: by mail-qt1-f197.google.com with SMTP id
 s2-20020ac85cc2000000b00342f8ad1f40so11656806qta.12
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Aug 2022 16:19:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
 bh=Ejd2XqlPIsLaN92xua+1YOCeIUPLipE6EMcANIURHpk=;
 b=OtLuJbE1G71dExJZunXLPdySH0uHzlKsrnGd6EINO93hoMqPoCAjASQlLJHobV5t/U
 GXxXL8DhQWsCz8SwGbmnHB2JWNmzkiPvS631OpjO634NmWvQmZat1Lcmv/hisA0smiza
 /y4jAzvMh2bLfg4NO8YPc/But5SZpKtesPgqwUEgNLC6TO1YhxA1oouJsGpd37rtsV0d
 3dO6b5vdmlAnR26VXyHPwlgQcU+mOUggLlerzc5z1yoP9g6HeM1ohWB3QThE7qVak2iJ
 L+0DyXzhKcDHKfeeTcjjpGkk2Hfo/yLTNMTCZppgspvZ9dNislGntzcyckOj/5Wb6IKy
 F0XQ==
X-Gm-Message-State: ACgBeo0WgUFsJ3UZBDoIHqMcV6SvOD8ybf1CB5SWvtQlZ5o1M/R0CUso
 5UvvE7d2G1aBmEd/Bl6agqRM5US3oCBaSt0mjjV9hp6TohT3kBFojcJxxTHB0cMwU2K3uGyXecq
 jmHEM3gamErP7ziB0rlQL7DTG
X-Received: by 2002:a37:b243:0:b0:6bc:3d04:623f with SMTP id
 b64-20020a37b243000000b006bc3d04623fmr4888001qkf.672.1661296748655; 
 Tue, 23 Aug 2022 16:19:08 -0700 (PDT)
X-Google-Smtp-Source: AA6agR68qAn5UZduxSvc7YFRPNkyTTJD1EBYt7TKsqkGY0aznLoNst64fUxKKLOOcY75RG0ZX5cbHQ==
X-Received: by 2002:a37:b243:0:b0:6bc:3d04:623f with SMTP id
 b64-20020a37b243000000b006bc3d04623fmr4887979qkf.672.1661296748284; 
 Tue, 23 Aug 2022 16:19:08 -0700 (PDT)
Received: from xz-m1.local
 (bras-base-aurron9127w-grc-35-70-27-3-10.dsl.bell.ca. [70.27.3.10])
 by smtp.gmail.com with ESMTPSA id
 dm33-20020a05620a1d6100b006b5f8f32a8fsm15149348qkb.114.2022.08.23.16.19.05
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 23 Aug 2022 16:19:07 -0700 (PDT)
Date: Tue, 23 Aug 2022 19:19:04 -0400
From: Peter Xu <peterx@redhat.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v1 1/5] KVM: arm64: Enable ring-based dirty memory tracking
Message-ID: <YwVgaGp3HOGzC8k2@xz-m1.local>
References: <20220819005601.198436-1-gshan@redhat.com>
 <20220819005601.198436-2-gshan@redhat.com>
 <87lerkwtm5.wl-maz@kernel.org>
 <41fb5a1f-29a9-e6bb-9fab-4c83a2a8fce5@redhat.com>
 <87fshovtu0.wl-maz@kernel.org>
 <171d0159-4698-354b-8b2f-49d920d03b1b@redhat.com>
 <YwTc++Lz6lh3aR4F@xz-m1.local> <87bksawz0w.wl-maz@kernel.org>
 <YwVEoM1pj2MPCELp@xz-m1.local> <878rnewpaw.wl-maz@kernel.org>
MIME-Version: 1.0
In-Reply-To: <878rnewpaw.wl-maz@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kvm@vger.kernel.org, linux-doc@vger.kernel.org, catalin.marinas@arm.com,
 linux-kselftest@vger.kernel.org, bgardon@google.com, shuah@kernel.org,
 kvmarm@lists.cs.columbia.edu, corbet@lwn.net, will@kernel.org,
 shan.gavin@gmail.com, zhenyzha@redhat.com, dmatlack@google.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 pbonzini@redhat.com
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

On Tue, Aug 23, 2022 at 11:47:03PM +0100, Marc Zyngier wrote:
> On Tue, 23 Aug 2022 22:20:32 +0100,
> Peter Xu <peterx@redhat.com> wrote:
> > 
> > On Tue, Aug 23, 2022 at 08:17:03PM +0100, Marc Zyngier wrote:
> > > I don't think we really need this check on the hot path. All we need
> > > is to make the request sticky until userspace gets their act together
> > > and consumes elements in the ring. Something like:
> > > 
> > > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > > index 986cee6fbc7f..e8ed5e1af159 100644
> > > --- a/arch/arm64/kvm/arm.c
> > > +++ b/arch/arm64/kvm/arm.c
> > > @@ -747,6 +747,14 @@ static int check_vcpu_requests(struct kvm_vcpu *vcpu)
> > >  
> > >  		if (kvm_check_request(KVM_REQ_SUSPEND, vcpu))
> > >  			return kvm_vcpu_suspend(vcpu);
> > > +
> > > +		if (kvm_check_request(KVM_REQ_RING_SOFT_FULL, vcpu) &&
> > > +		    kvm_dirty_ring_soft_full(vcpu)) {
> > > +			kvm_make_request(KVM_REQ_RING_SOFT_FULL, vcpu);
> > > +			vcpu->run->exit_reason = KVM_EXIT_DIRTY_RING_FULL;
> > > +			trace_kvm_dirty_ring_exit(vcpu);
> > > +			return 0;
> > > +		}
> > >  	}
> > >  
> > >  	return 1;
> > 
> > Right, this seems working.  We can also use kvm_test_request() here.
> > 
> > > 
> > > 
> > > However, I'm a bit concerned by the reset side of things. It iterates
> > > over the vcpus and expects the view of each ring to be consistent,
> > > even if userspace is hacking at it from another CPU. For example, I
> > > can't see what guarantees that the kernel observes the writes from
> > > userspace in the order they are being performed (the documentation
> > > provides no requirements other than "it must collect the dirty GFNs in
> > > sequence", which doesn't mean much from an ordering perspective).
> > > 
> > > I can see that working on a strongly ordered architecture, but on
> > > something as relaxed as ARM, the CPUs may^Wwill aggressively reorder
> > > stuff that isn't explicitly ordered. I have the feeling that a CAS
> > > operation on both sides would be enough, but someone who actually
> > > understands how this works should have a look...
> > 
> > I definitely don't think I 100% understand all the ordering things since
> > they're complicated.. but my understanding is that the reset procedure
> > didn't need memory barrier (unlike pushing, where we have explicit wmb),
> > because we assumed the userapp is not hostile so logically it should only
> > modify the flags which is a 32bit field, assuming atomicity guaranteed.
> 
> Atomicity doesn't guarantee ordering, unfortunately.

Right, sorry to be misleading.  The "atomicity" part I was trying to say
the kernel will always see consistent update on the fields.

The ordering should also be guaranteed, because things must happen with
below sequence:

  (1) kernel publish dirty GFN data (slot, offset)
  (2) kernel publish dirty GFN flag (set to DIRTY)
  (3) user sees DIRTY, collects (slots, offset)
  (4) user sets it to RESET
  (5) kernel reads RESET

So the ordering of single-entry is guaranteed in that when (5) happens it
must be after stablized (1+2).

> Take the
> following example: CPU0 is changing a bunch of flags for GFNs A, B, C,
> D that exist in the ring in that order, and CPU1 performs an ioctl to
> reset the page state.
> 
> CPU0:
>     write_flag(A, KVM_DIRTY_GFN_F_RESET)
>     write_flag(B, KVM_DIRTY_GFN_F_RESET)
>     write_flag(C, KVM_DIRTY_GFN_F_RESET)
>     write_flag(D, KVM_DIRTY_GFN_F_RESET)
>     [...]
> 
> CPU1:
>    ioctl(KVM_RESET_DIRTY_RINGS)
> 
> Since CPU0 writes do not have any ordering, CPU1 can observe the
> writes in a sequence that have nothing to do with program order, and
> could for example observe that GFN A and D have been reset, but not B
> and C. This in turn breaks the logic in the reset code (B, C, and D
> don't get reset), despite userspace having followed the spec to the
> letter. If each was a store-release (which is the case on x86), it
> wouldn't be a problem, but nothing calls it in the documentation.
> 
> Maybe that's not a big deal if it is expected that each CPU will issue
> a KVM_RESET_DIRTY_RINGS itself, ensuring that it observe its own
> writes. But expecting this to work across CPUs without any barrier is
> wishful thinking.

I see what you meant...

Firstly I'm actually curious whether that'll really happen if the gfns are
collected in something like a for loop:

  for(i = 0; i < N; i++)
    collect_dirty_gfn(ring, i);

Because since all the gfps to be read will depend on variable "i", IIUC no
reordering should happen, but I'm not really sure, so more of a pure
question.

Besides, the other thing to mention is that I think it is fine the RESET
ioctl didn't recycle all the gfns got set to reset state.  Taking above
example of GFNs A-D, if when reaching the RESET ioctl only A & D's flags
are updated, the ioctl will recycle gfn A but stop at gfn B assuming B-D
are not reset.  But IMHO it's okay because it means we reset partial of the
gfns not all of them, and it's safe to do so.  It means the next ring full
event can come earlier because we recycled less, but that's functionally
safe to me.

> 
> > IIRC we used to discuss similar questions on "what if the user is hostile
> > and wants to hack the process by messing up with the ring", and our
> > conclusion was as long as the process wouldn't mess up anything outside
> > itself it should be okay. E.g. It should not be able to either cause the
> > host to misfunction, or trigger kernel warnings in dmesg, etc..
> 
> I'm not even discussing safety here. I'm purely discussing the
> interactions between userspace and kernel based on the documentation
> and the existing kernel code.

I see.  Please let me know if above makes sense.

Thanks!

-- 
Peter Xu

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
