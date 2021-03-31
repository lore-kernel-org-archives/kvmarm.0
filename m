Return-Path: <SRS0=odEw=I6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A434CC433ED
	for <kvmarm@archiver.kernel.org>; Thu,  1 Apr 2021 09:28:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2AF5C60FEA
	for <kvmarm@archiver.kernel.org>; Thu,  1 Apr 2021 09:28:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2AF5C60FEA
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B9FE54B5F8;
	Thu,  1 Apr 2021 05:28:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id e+NXJyrm+2Oc; Thu,  1 Apr 2021 05:28:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 23AC14B636;
	Thu,  1 Apr 2021 05:28:19 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8E43D4B50F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 31 Mar 2021 17:47:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SB-JQPhqU+gv for <kvmarm@lists.cs.columbia.edu>;
 Wed, 31 Mar 2021 17:47:56 -0400 (EDT)
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com
 [209.85.214.176])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 766114B468
 for <kvmarm@lists.cs.columbia.edu>; Wed, 31 Mar 2021 17:47:56 -0400 (EDT)
Received: by mail-pl1-f176.google.com with SMTP id f17so8600385plr.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 31 Mar 2021 14:47:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=8xelLMkxcC6WtOofiMih6F32tqKnPtSyw2jgK+CDHu4=;
 b=lRekl3fx/1xVTY4VSWAcqWY60kFcYfE3ex87ZMiyF3YMama3alXemQAvey4ua2Q2NU
 eIzwbu8ulmg+dSFPJ/LLw9M8TUwNtZ6Kf+zsLYX2btGWc+Mt6r+WqI3nE4cuuPodpDWB
 vkPyVKuV4l3DmqBnpyedy5K2ELlMSQALGThaUNGPrMsL7lsHqmcjeklTCzt6GLWxXFOh
 fcNEDPnE/MDmfK1tIflC1u5mhPxRa8t1lqjHjJZcz8mlLg7SmVa3KnKTiibQ3TVoVdfM
 W0WQ/smihKucHGWCEceoSVORhE99fiU+/wSW3je405yKPyFBfEyxm9lRJkvzLqkv3YeD
 nlyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=8xelLMkxcC6WtOofiMih6F32tqKnPtSyw2jgK+CDHu4=;
 b=n4jNfKGCauHGKToVcjNlehu2k199SGW1KdKRlNHzIlGe1Ij5qh3Stu9v/+MmMguyVe
 vDaaZhbLhY8GZcOgfd3gkAImaJnLy3t6lbk71XHLY+ZbuTK5dyuUmjwsU4fPJYti8Oju
 7qhPQFjC275Nf8gMeXLzKssxm+L5QqXclmWkyCMj23VXr2Y4BBNqwy4FXn3+uJyoBANf
 oFFXlTvjXxjGr58tI6wOfGPgVJeq58jOwOIn3TCJ3WnozpluVdqUi0A8iFfXuhiQoDo8
 1rrYG+xn4tPQk00J4DmwrLoVhUmupt3VYDGkm5O5PmiNuzGe7wlMR0F9eILtcMJ+T+OB
 Ztnw==
X-Gm-Message-State: AOAM530I0Y9552xifdW0REwY3Azy6J/8nfWzjegEQ7sFOwceXHCLeWl6
 z+fyMcZjtiEoXeiWBWtwlxr+oA==
X-Google-Smtp-Source: ABdhPJyZugl5lfedBulyUfvB1YGfF9LGCaOpUeSH521YqKnnt+A07YJz3hlU79HRomGEJDuqkrmSZg==
X-Received: by 2002:a17:90b:1987:: with SMTP id
 mv7mr5273831pjb.152.1617227275455; 
 Wed, 31 Mar 2021 14:47:55 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com.
 [35.247.111.240])
 by smtp.gmail.com with ESMTPSA id a30sm3300970pfr.66.2021.03.31.14.47.54
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 31 Mar 2021 14:47:54 -0700 (PDT)
Date: Wed, 31 Mar 2021 21:47:51 +0000
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 16/18] KVM: Don't take mmu_lock for range invalidation
 unless necessary
Message-ID: <YGTuB3/JRvUwH64K@google.com>
References: <20210326021957.1424875-1-seanjc@google.com>
 <20210326021957.1424875-17-seanjc@google.com>
 <6e7dc7d0-f5dc-85d9-1c50-d23b761b5ff3@redhat.com>
 <YGSmMeSOPcjxRwf6@google.com>
 <56ea69fe-87b0-154b-e286-efce9233864e@redhat.com>
 <YGTRzf/4i9Y8XR2c@google.com>
 <0e30625f-934d-9084-e293-cb3bcbc9e4b8@redhat.com>
 <YGTkLMAzk88wOiZm@google.com>
 <345ab567-386f-9080-f9cb-0e17fa90a852@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <345ab567-386f-9080-f9cb-0e17fa90a852@redhat.com>
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
> On 31/03/21 23:05, Sean Christopherson wrote:
> > > Wouldn't it be incorrect to lock a mutex (e.g. inside*another*  MMU
> > > notifier's invalidate callback) while holding an rwlock_t?  That makes sense
> > > because anybody that's busy waiting in write_lock potentially cannot be
> > > preempted until the other task gets the mutex.  This is a potential
> > > deadlock.
> > 
> > Yes?  I don't think I follow your point though.  Nesting a spinlock or rwlock
> > inside a rwlock is ok, so long as the locks are always taken in the same order,
> > i.e. it's never mmu_lock -> mmu_notifier_slots_lock.
> 
> *Another* MMU notifier could nest a mutex inside KVM's rwlock.
> 
> But... is it correct that the MMU notifier invalidate callbacks are always
> called with the mmap_sem taken (sometimes for reading, e.g.
> try_to_merge_with_ksm_page->try_to_merge_one_page->write_protect_page)?

No :-(

File-based invalidations through the rmaps do not take mmap_sem.  They get at
the VMAs via the address_space's interval tree, which is protected by its own
i_mmap_rwsem.

E.g. try_to_unmap() -> rmap_walk_file() -> try_to_unmap_one() 

> We could take it temporarily in install_memslots, since the MMU notifier's mm
> is stored in kvm->mm.
> 
> In this case, a pair of kvm_mmu_notifier_lock/unlock functions would be the
> best way to abstract it.
> 
> Paolo
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
