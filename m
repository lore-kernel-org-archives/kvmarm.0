Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1DE6C4332F
	for <kvmarm@archiver.kernel.org>; Fri, 21 Oct 2022 15:25:57 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 40ECF4B64A;
	Fri, 21 Oct 2022 11:25:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5p1BBmKaWXYq; Fri, 21 Oct 2022 11:25:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2FC8A4B64B;
	Fri, 21 Oct 2022 11:25:56 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CB7154B644
 for <kvmarm@lists.cs.columbia.edu>; Fri, 21 Oct 2022 11:25:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NelnhI6ov55D for <kvmarm@lists.cs.columbia.edu>;
 Fri, 21 Oct 2022 11:25:53 -0400 (EDT)
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com
 [209.85.210.182])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8065949F49
 for <kvmarm@lists.cs.columbia.edu>; Fri, 21 Oct 2022 11:25:53 -0400 (EDT)
Received: by mail-pf1-f182.google.com with SMTP id m6so2934804pfb.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 21 Oct 2022 08:25:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
 bh=WXtKc1Skis76MTjC49qNl1llLLLE1O6jaSQt7bDlJ00=;
 b=LLN1PyCuNtLJP31hg/jw5udlBPxnBHULHo1dZDNJIDuWb0283AFmhB8P5iN/B9vtrh
 M2GoDLTYLNOQaCq3awbwhGTdGbjQb0zC5mNE0Im4hqlr953oOxe1SKpOBdVqtchIth52
 tOKpxIkPRrDMKbHBEaYZ++fAm9kKfGxd/ULiBuLUDO7s5MZf14+gDBmhebU6Q9OLRE2i
 +/MnVwOQZ1+Dj/IL5mQY5g6nHY0l7nnRDMO1vZBS8CB0B7Tv23OG4ECTb8h73Kas0iU0
 7kyI+zBXIlGsLZsXKHZnAxHwiGaB+fG3ZZCmRFGr0h9eoJiAqmXiwaama1YdEeq0+g6B
 v7Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=WXtKc1Skis76MTjC49qNl1llLLLE1O6jaSQt7bDlJ00=;
 b=W1ece7ha1FZf+iCdeAoR/dsnTIQ0SBd0CdHjHBj5AaEklSwmwyPvfEtzATitY4f035
 msuafO06VSpY8RIiWON1kI5UJCSDQWLFwX82tm0n9NddEuC/j2w4AQeZwgWRL3dOl/48
 ZFUNukvTQKLeEThR/jTbd99fh+f2KuZlrPB3UCp7jKR7hNOCXP33uZAreCCjQPTqClfC
 WgSW2RMhsDopNd0pZOrtXiAmZH6so6OQ9Mw5pTBJfNNxVgLnBDtCNuutvzmahrpuehdx
 UPSPdZqzfIEW6xUxb8d4/qGyLWuPkuFLKfrQQaAhZtqRMOPloSii1KQyKOQ+Qdpu2ie/
 DvSw==
X-Gm-Message-State: ACrzQf07I4RCzqg77+UQ+N26mBTf/8XtNxhKZzNyT/HhxYWhH/MLGRrk
 BiDppSfymG9snkw2GjXekc/zWA==
X-Google-Smtp-Source: AMsMyM4DcER9kXQVj2PgcEv6TkmlXH7wJ1BMCn03xYmCnoxgMu2tlWOlzuDgT2rlyWpkhPVwwmNakg==
X-Received: by 2002:a65:4d46:0:b0:43b:e00f:8663 with SMTP id
 j6-20020a654d46000000b0043be00f8663mr16399783pgt.147.1666365952431; 
 Fri, 21 Oct 2022 08:25:52 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com.
 [34.168.104.7]) by smtp.gmail.com with ESMTPSA id
 m8-20020a170902db0800b0018157b415dbsm15091230plx.63.2022.10.21.08.25.51
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 21 Oct 2022 08:25:51 -0700 (PDT)
Date: Fri, 21 Oct 2022 15:25:48 +0000
From: Sean Christopherson <seanjc@google.com>
To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v6 1/8] KVM: x86: Introduce KVM_REQ_RING_SOFT_FULL
Message-ID: <Y1K5/MN9o7tEvYu5@google.com>
References: <20221011061447.131531-1-gshan@redhat.com>
 <20221011061447.131531-2-gshan@redhat.com>
 <Y1HO46UCyhc9M6nM@google.com>
 <db2cb7da-d3b1-c87e-4362-94764a7ea480@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <db2cb7da-d3b1-c87e-4362-94764a7ea480@redhat.com>
Cc: shuah@kernel.org, kvm@vger.kernel.org, maz@kernel.org, bgardon@google.com,
 andrew.jones@linux.dev, dmatlack@google.com, shan.gavin@gmail.com,
 catalin.marinas@arm.com, kvmarm@lists.linux.dev, pbonzini@redhat.com,
 zhenyzha@redhat.com, will@kernel.org, kvmarm@lists.cs.columbia.edu
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

On Fri, Oct 21, 2022, Gavin Shan wrote:
> I think Marc want to make the check more generalized with a new event [1].

Generalized code can be achieved with a helper though.  The motivation is indeed
to avoid overhead on every run:

  : A seemingly approach would be to make this a request on dirty log
  : insertion, and avoid the whole "check the log size" on every run,
  : which adds pointless overhead to unsuspecting users (aka everyone).


https://lore.kernel.org/kvmarm/87lerkwtm5.wl-maz@kernel.org

> > I'm pretty sure the check can be moved to the very end of the request checks,
> > e.g. to avoid an aborted VM-Enter attempt if one of the other request triggers
> > KVM_REQ_RING_SOFT_FULL.
> > 
> > Heh, this might actually be a bug fix of sorts.  If anything pushes to the ring
> > after the check at the start of vcpu_enter_guest(), then without the request, KVM
> > would enter the guest while at or above the soft limit, e.g. record_steal_time()
> > can dirty a page, and the big pile of stuff that's behind KVM_REQ_EVENT can
> > certainly dirty pages.
> > 
> 
> When dirty ring becomes full, the VCPU can't handle any operations, which will
> bring more dirty pages.

Right, but there's a buffer of 64 entries on top of what the CPU can buffer (VMX's
PML can buffer 512 entries).  Hence the "soft full".  If x86 is already on the
edge of exhausting that buffer, i.e. can fill 64 entries while handling requests,
than we need to increase the buffer provided by the soft limit because sooner or
later KVM will be able to fill 65 entries, at which point errors will occur
regardless of when the "soft full" request is processed.

In other words, we can take advantage of the fact that the soft-limit buffer needs
to be quite conservative.

> > Would it make sense to clear the request in kvm_dirty_ring_reset()?  I don't care
> > about the overhead of having to re-check the request, the goal would be to help
> > document what causes the request to go away.
> > 
> > E.g. modify kvm_dirty_ring_reset() to take @vcpu and then do:
> > 
> > 	if (!kvm_dirty_ring_soft_full(ring))
> > 		kvm_clear_request(KVM_REQ_RING_SOFT_FULL, vcpu);
> > 
> 
> It's reasonable to clear KVM_REQ_DIRTY_RING_SOFT_FULL when the ring is reseted.
> @vcpu can be achieved by container_of(..., ring).

Using container_of() is silly, there's literally one caller that does:

	kvm_for_each_vcpu(i, vcpu, kvm)
		cleared += kvm_dirty_ring_reset(vcpu->kvm, &vcpu->dirty_ring);
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
