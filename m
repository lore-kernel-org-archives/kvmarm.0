Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47094C0502C
	for <kvmarm@archiver.kernel.org>; Tue, 30 Aug 2022 14:42:28 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A6B4A4B95C;
	Tue, 30 Aug 2022 10:42:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id aCYdTo27heEl; Tue, 30 Aug 2022 10:42:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 68F154B8F6;
	Tue, 30 Aug 2022 10:42:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4A8F84B8F2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Aug 2022 10:42:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uWrfYVwXaLOR for <kvmarm@lists.cs.columbia.edu>;
 Tue, 30 Aug 2022 10:42:24 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 166104B5CC
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Aug 2022 10:42:24 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1661870543;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=+te87sYtTGczNabgaJy1Pj2NfLsGoso4jkdFkum7FlU=;
 b=CSIpuUbJSsAo/yBeYOCmUjpoFvClmr6cpvTT5Zw5fg5qdUeBO3dvkmavL/LVSKah8fI5Nh
 aZPcgPF91ahQIC5MzW+3+ZatcYIE6XvUg3HkaoQL/U3Ud3X2vY7VGxjEze25G4Oa8FRCBJ
 YOh6ZNSfDkQ+d+oY8Bb4gqCuznzLH0U=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-619-EhPzaHS8P3uU7b4TK7yxEw-1; Tue, 30 Aug 2022 10:42:20 -0400
X-MC-Unique: EhPzaHS8P3uU7b4TK7yxEw-1
Received: by mail-qk1-f197.google.com with SMTP id
 r14-20020a05620a298e00b006be796b6164so5708204qkp.19
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Aug 2022 07:42:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
 bh=+te87sYtTGczNabgaJy1Pj2NfLsGoso4jkdFkum7FlU=;
 b=seJWOlEgN0bWav3GuIMY8U3kQERUxQkBOq5BFFPq57xv5o/t6u3xKsq7StNrVXlt+j
 tr1Ru3MjSnJqL78I8YOVM77WuK+zG45pDRKDG4jEiHYX82ruabLHURbf3YuW6g8DRrzm
 mm8eSe1JFdfcqz1D1JV6/nIG/HBFGmEqo9ypY6r/tsOXcqO1692fSZ5DALNJuoJDNyah
 wQYEM3SXbEWWobSSL2y3v1O2N61Lkk88ydKiZmxS3x7O4c1XCb8+LffEfggCDnoSqaB7
 L5To/Nd4VY66/T27ZhNM9ux60ynH3i9dKetSY6JkGmeMicCogGx1UTKqhpavFG+uDcz0
 pR3Q==
X-Gm-Message-State: ACgBeo3COORXr31etFdv41Fn3UAEcTj8mQcvwI1hHTD6Mc1GbiF4kc07
 8CSyWDyLOy2rFm8ezv3O4JYpTrFlLd6Enj2ClAyuGYnePBAPS6SHbEgcbdeT4b5rN9wVXiLAl0o
 /eBYJ381b1ciGfYTj5qB6f3Sc
X-Received: by 2002:a05:622a:1a0d:b0:343:6284:cbc8 with SMTP id
 f13-20020a05622a1a0d00b003436284cbc8mr15163350qtb.341.1661870540141; 
 Tue, 30 Aug 2022 07:42:20 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6D8op/R0BZbn270yGLNeyiqE7221aPAIVz7ZsIkOvVsCOIjnQ86kAB8hellaaWH315TLq1vg==
X-Received: by 2002:a05:622a:1a0d:b0:343:6284:cbc8 with SMTP id
 f13-20020a05622a1a0d00b003436284cbc8mr15163320qtb.341.1661870539902; 
 Tue, 30 Aug 2022 07:42:19 -0700 (PDT)
Received: from xz-m1.local
 (bras-base-aurron9127w-grc-35-70-27-3-10.dsl.bell.ca. [70.27.3.10])
 by smtp.gmail.com with ESMTPSA id
 x6-20020ac86b46000000b00339b8a5639csm7064707qts.95.2022.08.30.07.42.17
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 30 Aug 2022 07:42:19 -0700 (PDT)
Date: Tue, 30 Aug 2022 10:42:16 -0400
From: Peter Xu <peterx@redhat.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v1 1/5] KVM: arm64: Enable ring-based dirty memory tracking
Message-ID: <Yw4hyEAyivKT35vQ@xz-m1.local>
References: <20220819005601.198436-1-gshan@redhat.com>
 <20220819005601.198436-2-gshan@redhat.com>
 <87lerkwtm5.wl-maz@kernel.org>
 <41fb5a1f-29a9-e6bb-9fab-4c83a2a8fce5@redhat.com>
 <87fshovtu0.wl-maz@kernel.org> <YwTn2r6FLCx9mAU7@google.com>
 <87a67uwve8.wl-maz@kernel.org>
 <99364855-b4e9-8a69-e1ca-ed09d103e4c8@redhat.com>
 <874jxzvxak.wl-maz@kernel.org>
MIME-Version: 1.0
In-Reply-To: <874jxzvxak.wl-maz@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kvm@vger.kernel.org, linux-doc@vger.kernel.org, catalin.marinas@arm.com,
 linux-kselftest@vger.kernel.org, bgardon@google.com, shuah@kernel.org,
 kvmarm@lists.cs.columbia.edu, corbet@lwn.net, will@kernel.org,
 shan.gavin@gmail.com, drjones@redhat.com, zhenyzha@redhat.com,
 dmatlack@google.com, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
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

On Fri, Aug 26, 2022 at 04:28:51PM +0100, Marc Zyngier wrote:
> On Fri, 26 Aug 2022 11:58:08 +0100,
> Paolo Bonzini <pbonzini@redhat.com> wrote:
> > 
> > On 8/23/22 22:35, Marc Zyngier wrote:
> > >> Heh, yeah I need to get that out the door. I'll also note that Gavin's
> > >> changes are still relevant without that series, as we do write unprotect
> > >> in parallel at PTE granularity after commit f783ef1c0e82 ("KVM: arm64:
> > >> Add fast path to handle permission relaxation during dirty logging").
> > > 
> > > Ah, true. Now if only someone could explain how the whole
> > > producer-consumer thing works without a trace of a barrier, that'd be
> > > great...
> > 
> > Do you mean this?
> >
> > void kvm_dirty_ring_push(struct kvm_dirty_ring *ring, u32 slot, u64 offset)
> 
> Of course not. I mean this:
> 
> static int kvm_vm_ioctl_reset_dirty_pages(struct kvm *kvm)
> {
> 	unsigned long i;
> 	struct kvm_vcpu *vcpu;
> 	int cleared = 0;
> 
> 	if (!kvm->dirty_ring_size)
> 		return -EINVAL;
> 
> 	mutex_lock(&kvm->slots_lock);
> 
> 	kvm_for_each_vcpu(i, vcpu, kvm)
> 		cleared += kvm_dirty_ring_reset(vcpu->kvm, &vcpu->dirty_ring);
> [...]
> }
> 
> and this
> 
> int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring)
> {
> 	u32 cur_slot, next_slot;
> 	u64 cur_offset, next_offset;
> 	unsigned long mask;
> 	int count = 0;
> 	struct kvm_dirty_gfn *entry;
> 	bool first_round = true;
> 
> 	/* This is only needed to make compilers happy */
> 	cur_slot = cur_offset = mask = 0;
> 
> 	while (true) {
> 		entry = &ring->dirty_gfns[ring->reset_index & (ring->size - 1)];
> 
> 		if (!kvm_dirty_gfn_harvested(entry))
> 			break;
> [...]
> 
> }
> 
> which provides no ordering whatsoever when a ring is updated from one
> CPU and reset from another.

Marc,

I thought we won't hit this as long as we properly take care of other
orderings of (a) gfn push, and (b) gfn collect, but after a second thought
I think it's indeed logically possible that with a reversed ordering here
we can be reading some garbage gfn before (a) happens butt also read the
valid flag after (b).

It seems we must have all the barriers correctly applied always.  If that's
correct, do you perhaps mean something like this to just add the last piece
of barrier?

===8<===
diff --git a/virt/kvm/dirty_ring.c b/virt/kvm/dirty_ring.c
index f4c2a6eb1666..ea620bfb012d 100644
--- a/virt/kvm/dirty_ring.c
+++ b/virt/kvm/dirty_ring.c
@@ -84,7 +84,7 @@ static inline void kvm_dirty_gfn_set_dirtied(struct kvm_dirty_gfn *gfn)
 
 static inline bool kvm_dirty_gfn_harvested(struct kvm_dirty_gfn *gfn)
 {
-       return gfn->flags & KVM_DIRTY_GFN_F_RESET;
+       return smp_load_acquire(&gfn->flags) & KVM_DIRTY_GFN_F_RESET;
 }
 
 int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring)
===8<===

Thanks,

-- 
Peter Xu

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
