Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8888BC433F5
	for <kvmarm@archiver.kernel.org>; Fri,  7 Jan 2022 16:47:05 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0B9FD4B27B;
	Fri,  7 Jan 2022 11:47:05 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id uZ60BTU03f5v; Fri,  7 Jan 2022 11:47:03 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8E2BD4B271;
	Fri,  7 Jan 2022 11:47:03 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DFB2E4B25F
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Jan 2022 11:47:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id a65VAUZn+AF0 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  7 Jan 2022 11:47:01 -0500 (EST)
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com
 [209.85.216.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8B0234B245
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Jan 2022 11:47:01 -0500 (EST)
Received: by mail-pj1-f50.google.com with SMTP id
 r16-20020a17090a0ad000b001b276aa3aabso12567838pje.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 07 Jan 2022 08:47:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=4HKnywQuY4VwXKVwYl3w2RNebnD31WyuWWzy9wpaOH0=;
 b=BvLHGD7cj4995fLzUhgyy1Xt/a0cC76PQB/jGLGJEKa0b6OFwQ+DrOKU3TYZkymmgS
 BTeAsvkfWAWnUq1WOqL4vGteu6O2Ld4y5+snVVc5+sU0KjMB4RAAFBkX0HWdnx62O14E
 jXbutV6k0H84XcWhw++JJI5F1Nykk+sTfnUcCqMOLs4SQ/KBXxWdpyS9MdxgF/KY3KDS
 NI7p9R4ex+SK8+H2DJkfxklNuGpN9luOoCDx6fhzHrgPfyvFEB+F/9bW9SWvCCoRzQkR
 jsQqJJLcmMM9F3cF1zM9nzl4zZhWBQy2welvXJT1dZZkyc8P8JLHKlmMJs79hca+JweA
 XDNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=4HKnywQuY4VwXKVwYl3w2RNebnD31WyuWWzy9wpaOH0=;
 b=XCNMLl2aJCji1FPQBDnfolueP6vkHoDKiJduSKHdWmpe8/931+e09seOyBwb3G4mUs
 2B/T/ZWViW8h4kKDNkAHbBQTkunFpbb7yIxEebDLxp4fxiiCR4hTMGFT1LT5E/iKjLQY
 7e0W1cLXbWOX0xntIqmn2edXlnDRKGpY4tOPAcHZMruZ4xTqtnindUNyI+OOhHCtgcBE
 I38ZWJIjSUpS9SOF8Ed3L16DKm225yzWZwuNKJpFETvOVBptFxioee5dApT3ix64dWrF
 o75zLKHJUV8ufGo5Rea5iPOvl++DNyD3oGP/cm0Wp+SGMEbEWogCvgM4WzcvoJ6/LbbI
 cKdA==
X-Gm-Message-State: AOAM532EG/0RmExwg0XkTAEVFWCotIxWTxgFsI9wwaKwf9wo5bcMqZhJ
 kXSu9m2MANQxugrW0eSfhQ6ZRA==
X-Google-Smtp-Source: ABdhPJwaWYhBGl15DwbN2c5wYPK8kkGXVkvmKvrtvOqisVVfVfKIeJNZMfFu1VFmjZmU/W5QC8QKVg==
X-Received: by 2002:a17:90b:88e:: with SMTP id
 bj14mr16748325pjb.183.1641574020470; 
 Fri, 07 Jan 2022 08:47:00 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157])
 by smtp.gmail.com with ESMTPSA id d3sm6735893pfv.192.2022.01.07.08.46.59
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 07 Jan 2022 08:47:00 -0800 (PST)
Date: Fri, 7 Jan 2022 16:46:56 +0000
From: Sean Christopherson <seanjc@google.com>
To: David Stevens <stevensd@chromium.org>
Subject: Re: [PATCH v5 4/4] KVM: mmu: remove over-aggressive warnings
Message-ID: <YdhugJ6h76JLHTjT@google.com>
References: <20211129034317.2964790-1-stevensd@google.com>
 <20211129034317.2964790-5-stevensd@google.com>
 <Yc4G23rrSxS59br5@google.com>
 <CAD=HUj5Q6rW8UyxAXUa3o93T0LBqGQb7ScPj07kvuM3txHMMrQ@mail.gmail.com>
 <YdXrURHO/R82puD4@google.com> <YdXvUaBUvaRPsv6m@google.com>
 <CAD=HUj736L5oxkzeL2JoPV8g1S6Rugy_TquW=PRt73YmFzP6Jw@mail.gmail.com>
 <YdcpIQgMZJrqswKU@google.com>
 <CAD=HUj5v37wZ9NuNC4QBDvCGO2SyNG2KAiTc9Jxfg=R7neCuTw@mail.gmail.com>
 <Ydhq5aHW+JFo15UF@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <Ydhq5aHW+JFo15UF@google.com>
Cc: Chia-I Wu <olv@chromium.org>, Wanpeng Li <wanpengli@tencent.com>,
 kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
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

On Fri, Jan 07, 2022, Sean Christopherson wrote:
> On Fri, Jan 07, 2022, David Stevens wrote:
> > > > These are the type of pages which KVM is currently rejecting. Is this
> > > > something that KVM can support?
> > >
> > > I'm not opposed to it.  My complaint is that this series is incomplete in that it
> > > allows mapping the memory into the guest, but doesn't support accessing the memory
> > > from KVM itself.  That means for things to work properly, KVM is relying on the
> > > guest to use the memory in a limited capacity, e.g. isn't using the memory as
> > > general purpose RAM.  That's not problematic for your use case, because presumably
> > > the memory is used only by the vGPU, but as is KVM can't enforce that behavior in
> > > any way.
> > >
> > > The really gross part is that failures are not strictly punted to userspace;
> > > the resulting error varies significantly depending on how the guest "illegally"
> > > uses the memory.
> > >
> > > My first choice would be to get the amdgpu driver "fixed", but that's likely an
> > > unreasonable request since it sounds like the non-KVM behavior is working as intended.
> > >
> > > One thought would be to require userspace to opt-in to mapping this type of memory
> > > by introducing a new memslot flag that explicitly states that the memslot cannot
> > > be accessed directly by KVM, i.e. can only be mapped into the guest.  That way,
> > > KVM has an explicit ABI with respect to how it handles this type of memory, even
> > > though the semantics of exactly what will happen if userspace/guest violates the
> > > ABI are not well-defined.  And internally, KVM would also have a clear touchpoint
> > > where it deliberately allows mapping such memslots, as opposed to the more implicit
> > > behavior of bypassing ensure_pfn_ref().
> > 
> > Is it well defined when KVM needs to directly access a memslot?
> 
> Not really, there's certainly no established rule.
> 
> > At least for x86, it looks like most of the use cases are related to nested
> > virtualization, except for the call in emulator_cmpxchg_emulated.
> 
> The emulator_cmpxchg_emulated() will hopefully go away in the nearish future[*].

Forgot the link...

https://lore.kernel.org/all/YcG32Ytj0zUAW%2FB2@hirez.programming.kicks-ass.net/

> Paravirt features that communicate between guest and host via memory is the other
> case that often maps a pfn into KVM.
> 
> > Without being able to specifically state what should be avoided, a flag like
> > that would be difficult for userspace to use.
> 
> Yeah :-(  I was thinking KVM could state the flag would be safe to use if and only
> if userspace could guarantee that the guest would use the memory for some "special"
> use case, but hadn't actually thought about how to word things.
> 
> The best thing to do is probably to wait for for kvm_vcpu_map() to be eliminated,
> as described in the changelogs for commits:
> 
>   357a18ad230f ("KVM: Kill kvm_map_gfn() / kvm_unmap_gfn() and gfn_to_pfn_cache")
>   7e2175ebd695 ("KVM: x86: Fix recording of guest steal time / preempted status")
> 
> Once that is done, everything in KVM will either access guest memory through the
> userspace hva, or via a mechanism that is tied into the mmu_notifier, at which
> point accessing non-refcounted struct pages is safe and just needs to worry about
> not corrupting _refcount.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
