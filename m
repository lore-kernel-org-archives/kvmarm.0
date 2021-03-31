Return-Path: <SRS0=odEw=I6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CDEAC43461
	for <kvmarm@archiver.kernel.org>; Thu,  1 Apr 2021 09:28:22 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0D5B1610C7
	for <kvmarm@archiver.kernel.org>; Thu,  1 Apr 2021 09:28:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0D5B1610C7
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9131D4B5F8;
	Thu,  1 Apr 2021 05:28:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xk0p6IzGAdNN; Thu,  1 Apr 2021 05:28:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AAA804B611;
	Thu,  1 Apr 2021 05:28:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D2E9D4B4DA
 for <kvmarm@lists.cs.columbia.edu>; Wed, 31 Mar 2021 15:47:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EwgTbIqN7GTr for <kvmarm@lists.cs.columbia.edu>;
 Wed, 31 Mar 2021 15:47:30 -0400 (EDT)
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com
 [209.85.210.179])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B37964B4D8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 31 Mar 2021 15:47:30 -0400 (EDT)
Received: by mail-pf1-f179.google.com with SMTP id x26so15359931pfn.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 31 Mar 2021 12:47:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=rXm/nrr7cYYIlQJb0K7kNX2znqQaRXVsKWhpXjS7Y2I=;
 b=CDypuGGrGw60J4khFNkq4AEV9gEEkbaVaUqFpR2D7gf8tSeMlwyf6nUvLGw5rNTBh2
 90XQzii0SYEovLXzoVaQjvGeQeHndrQULcF0QWkSZbcoJwB5ql9Ob5Gl0OkYvOMObYXM
 PwQIir8z4T4I0j/bFveoAqjDn6togPwkzvrmQkFjCtgGWwq8oscdeBxw+lhkNUgr0hWm
 HXKb2gq5qA41y4lLmIaRntCJ35FzXcivETY+ele6LdBo5hR9Rdw5GU8WKZABZWs5l5fj
 8JlgLggRkFrPzsokWbabc+GXcvYWIYDIVvThpt0UqySXiDlCUpLG+W2dOsggjxgt560h
 NTmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=rXm/nrr7cYYIlQJb0K7kNX2znqQaRXVsKWhpXjS7Y2I=;
 b=DQkzDYwCQmC5LtZqA7l565GvLRb+PV7+neJZ5NWMDLXVNMbN6PESkwgyBrKeB1ItYV
 wfv4GclVUjP2FrlaIE7NpOh5MIS3jL3IxLPxT/LDN4Zu53U4BVYrLBvu51ESIggG4ivj
 wqRVBYmxMS/v1xBlDVZ9R01q0NTSxFXjc1YBPFlKNzW6yzFx3vRLtil4ip4knhQ/h2jU
 t92XlkZJ4rTECPYuLMT8fkUNA+zm7pBBfOk1qRm6ocEBaqsWY7R/SCDWNM/Bqjq0DQ/y
 IYEyn9z76HizGZcrGqfWwPAKEzmq6l6j5DpUjj1r9s6vHozUJA1jM44te16KyNMEhy2M
 Jutw==
X-Gm-Message-State: AOAM5325kmomTe1thADRySOg6DKI7p+5FmF0sTUBGCyDf7b4JRUIRwPw
 vWVjysxTp7/aFgRfTTsQYAZpug==
X-Google-Smtp-Source: ABdhPJxre3DS307rwPCOHwWEZe4TtjFTW40vfmhoKbdPXBUPZaU3Ljhlizc9oUjhXKKagxfqerxWhA==
X-Received: by 2002:aa7:8814:0:b029:21d:d2ce:7be with SMTP id
 c20-20020aa788140000b029021dd2ce07bemr4305854pfo.80.1617220049616; 
 Wed, 31 Mar 2021 12:47:29 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com.
 [35.247.111.240])
 by smtp.gmail.com with ESMTPSA id r2sm3226686pgv.50.2021.03.31.12.47.28
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 31 Mar 2021 12:47:28 -0700 (PDT)
Date: Wed, 31 Mar 2021 19:47:25 +0000
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 16/18] KVM: Don't take mmu_lock for range invalidation
 unless necessary
Message-ID: <YGTRzf/4i9Y8XR2c@google.com>
References: <20210326021957.1424875-1-seanjc@google.com>
 <20210326021957.1424875-17-seanjc@google.com>
 <6e7dc7d0-f5dc-85d9-1c50-d23b761b5ff3@redhat.com>
 <YGSmMeSOPcjxRwf6@google.com>
 <56ea69fe-87b0-154b-e286-efce9233864e@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <56ea69fe-87b0-154b-e286-efce9233864e@redhat.com>
X-Mailman-Approved-At: Thu, 01 Apr 2021 05:28:17 -0400
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 Huacai Chen <chenhuacai@kernel.org>, linux-mips@vger.kernel.org,
 kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
 Paul Mackerras <paulus@ozlabs.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 linux-arm-kernel@lists.infradead.org, Ben Gardon <bgardon@google.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, kvmarm@lists.cs.columbia.edu,
 Jim Mattson <jmattson@google.com>
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

On Wed, Mar 31, 2021, Paolo Bonzini wrote:
> On 31/03/21 18:41, Sean Christopherson wrote:
> > > That said, the easiest way to avoid this would be to always update
> > > mmu_notifier_count.
> > Updating mmu_notifier_count requires taking mmu_lock, which would defeat the
> > purpose of these shenanigans.
> 
> Okay; I wasn't sure if the problem was contention with page faults in
> general, or just the long critical sections from the MMU notifier callbacks.
> Still updating mmu_notifier_count unconditionally is a good way to break up
> the patch in two and keep one commit just for the rwsem nastiness.

Rereading things, a small chunk of the rwsem nastiness can go away.  I don't see
any reason to use rw_semaphore instead of rwlock_t.  install_new_memslots() only
holds the lock for a handful of instructions.  Readers could get queued up
behind a writer, but since install_new_memslots() is serialized by slots_lock
(the existing mutex), there is no chance of multiple writers, i.e. the worst
case wait duration is bounded at the length of an in-flight notification.  And
that's _already_ the worst case since notifications are currently serialized by
mmu_lock.  In practice, the existing worst case is probably far worse since
there can be far more writers trying to acquire mmu_lock.

In other words, there's no strong argument for sleeping instead of busy waiting
in the notifiers.

By switching to rwlock_t, taking mmu_notifier_slots_lock doesn't have to depend
on mmu_notifier_range_blockable(), and the must_lock path also goes away.

> > > > +#if defined(CONFIG_MMU_NOTIFIER) && defined(KVM_ARCH_WANT_MMU_NOTIFIER)
> > > > +	down_write(&kvm->mmu_notifier_slots_lock);
> > > > +#endif
> > > >   	rcu_assign_pointer(kvm->memslots[as_id], slots);
> > > > +#if defined(CONFIG_MMU_NOTIFIER) && defined(KVM_ARCH_WANT_MMU_NOTIFIER)
> > > > +	up_write(&kvm->mmu_notifier_slots_lock);
> > > > +#endif
> > > Please do this unconditionally, the cost is minimal if the rwsem is not
> > > contended (as is the case if the architecture doesn't use MMU notifiers at
> > > all).
> > It's not the cost, it's that mmu_notifier_slots_lock doesn't exist.  That's an
> > easily solved problem, but then the lock wouldn't be initialized since
> > kvm_init_mmu_notifier() is a nop.  That's again easy to solve, but IMO would
> > look rather weird.  I guess the counter argument is that __kvm_memslots()
> > wouldn't need #ifdeffery.
> 
> Yep.  Less #ifdefs usually wins. :)
> 
> > These are the to ideas I've come up with:
> > 
> > Option 1:
> > 	static int kvm_init_mmu_notifier(struct kvm *kvm)
> > 	{
> > 		init_rwsem(&kvm->mmu_notifier_slots_lock);
> > 
> > 	#if defined(CONFIG_MMU_NOTIFIER) && defined(KVM_ARCH_WANT_MMU_NOTIFIER)
> > 		kvm->mmu_notifier.ops = &kvm_mmu_notifier_ops;
> > 		return mmu_notifier_register(&kvm->mmu_notifier, current->mm);
> > 	#else
> > 		return 0;
> > 	#endif
> > 	}
> 
> Option 2 is also okay I guess, but the simplest is option 1 + just init it
> in kvm_create_vm.

Arr.  I'll play around with it to try and purge the #ifdefs.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
