Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC638C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 13 Jan 2022 17:21:28 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 598EB49ED1;
	Thu, 13 Jan 2022 12:21:28 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id pwueOZ-jp88f; Thu, 13 Jan 2022 12:21:27 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 483864A19F;
	Thu, 13 Jan 2022 12:21:27 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A78CF49EBE
 for <kvmarm@lists.cs.columbia.edu>; Thu, 13 Jan 2022 12:21:25 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TapW2Wg53rXb for <kvmarm@lists.cs.columbia.edu>;
 Thu, 13 Jan 2022 12:21:24 -0500 (EST)
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com
 [209.85.215.176])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9A79F49EBD
 for <kvmarm@lists.cs.columbia.edu>; Thu, 13 Jan 2022 12:21:24 -0500 (EST)
Received: by mail-pg1-f176.google.com with SMTP id i8so434454pgt.13
 for <kvmarm@lists.cs.columbia.edu>; Thu, 13 Jan 2022 09:21:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=fbtEGzJF4Pri1PYcfPX7asBEf22RcTqncsyblqc+OvY=;
 b=Sl9FnTulo3H/YWpf/aLfhSezCJjNzfPIcyIfQnWaI/T+ls4BqPWyqk0HJpiNM9kBV3
 yGWtR900nHAhsuqatRtea8l3DKjGXWlo8s5kuMoFNZ7F9GpaNNS4XkSbvkXTqsrf2Zt2
 APxjvu6wgUo4v3/0Ed+fzz74FUPs60sq9kEb5Q6U4T6Wfw2sHFVn2yOiqSEIvjuhjNo4
 kuPwFSKBgU+46N6R3bu0BV7BPQos4gfZusOXH4QF94O+R0NhEUt2Q27T1c7bwrI8vByj
 u1niyPmODAf23UyQipBFWfpwwWDFqW/fDcCcLJAKR6WcuHkeCsBMoMFkcTlmmC0+SUbj
 kR/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=fbtEGzJF4Pri1PYcfPX7asBEf22RcTqncsyblqc+OvY=;
 b=UYlfSqQAMwUPQr0g2z4HbdkybnmZuE8dViIp0A0x4jGJ/eCjMnywouuwAfsY/3qRqe
 YR5kKbSZnuH6oCoLHf25nvWWEpWhJkDu+BQ/ByfwyB/LXzgPP/e5LtzX0vz4FrnUmorb
 BeXMeyt7XdGz9mAcWFl7Tra1aLCytY6rvy7ATAqFTvcb2hwFnURUmi0OlGPKcdS5qqEh
 ws6F4CVMowndrcqDAr08bXPNxGPxzq8xHSpOoRC+KhU6dNHwbIm2IsHdST0Lx9w3zisX
 CYJLCDHubj44PNDMVN72FW1RCXxsFIS7wvPIyU6pjDYcCJ8Puwd2vt4BGhmuKfP0Lq+A
 WUzg==
X-Gm-Message-State: AOAM530epbwXdWeFavuBMEEpG2M1pTWJ0svd3f38yIyh0mpeA5C7W+9o
 WE+DRTQjlm3gbyJV5774Pb2h7A==
X-Google-Smtp-Source: ABdhPJwscB6iGP0ZkbE0k3eKaRnQ7Ca7BDedLEYyrWxbsoa7id33e6ZYFRtTIaHRtcelXaAQ3lqEHA==
X-Received: by 2002:a62:178a:0:b0:4c0:25a5:d389 with SMTP id
 132-20020a62178a000000b004c025a5d389mr5156670pfx.1.1642094483546; 
 Thu, 13 Jan 2022 09:21:23 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157])
 by smtp.gmail.com with ESMTPSA id pi15sm3309892pjb.43.2022.01.13.09.21.22
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 13 Jan 2022 09:21:22 -0800 (PST)
Date: Thu, 13 Jan 2022 17:21:19 +0000
From: Sean Christopherson <seanjc@google.com>
To: Raghavendra Rao Ananta <rananta@google.com>
Subject: Re: [RFC PATCH v3 01/11] KVM: Capture VM start
Message-ID: <YeBfj89mIf8SezfD@google.com>
References: <20220104194918.373612-1-rananta@google.com>
 <20220104194918.373612-2-rananta@google.com>
 <CAAeT=Fxyct=WLUvfbpROKwB9huyt+QdJnKTaj8c5NKk+UY51WQ@mail.gmail.com>
 <CAJHc60za+E-zEO5v2QeKuifoXznPnt5n--g1dAN5jgsuq+SxrA@mail.gmail.com>
 <CALMp9eQDzqoJMck=_agEZNU9FJY9LB=iW-8hkrRc20NtqN=gDA@mail.gmail.com>
 <CAJHc60xZ9emY9Rs9ZbV+AH-Mjmkyg4JZU7V16TF48C-HJn+n4A@mail.gmail.com>
 <CALMp9eTPJZDtMiHZ5XRiYw2NR9EBKSfcP5CYddzyd2cgWsJ9hw@mail.gmail.com>
 <CAJHc60xD2U36pM4+Dq3yZw6Cokk-16X83JHMPXj4aFnxOJ3BUQ@mail.gmail.com>
 <CALMp9eR+evJ+w9VTSvR2KHciQDgTsnS=bh=1OUL4yy8gG6O51A@mail.gmail.com>
 <CAJHc60zw1o=JdUJ+sNNtv3mc_JTRMKG3kPp=-cchWkHm74hUYA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAJHc60zw1o=JdUJ+sNNtv3mc_JTRMKG3kPp=-cchWkHm74hUYA@mail.gmail.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 Linux ARM <linux-arm-kernel@lists.infradead.org>,
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

On Wed, Jan 12, 2022, Raghavendra Rao Ananta wrote:
> On Tue, Jan 11, 2022 at 11:16 AM Jim Mattson <jmattson@google.com> wrote:
> > Perhaps it would help if you explained *why* you are doing this. It
> > sounds like you are either trying to protect against a malicious
> > userspace, or you are trying to keep userspace from doing something
> > stupid. In general, kvm only enforces constraints that are necessary
> > to protect the host. If that's what you're doing, I don't understand
> > why live migration doesn't provide an end-run around your protections.
> It's mainly to safeguard the guests. With respect to migration, KVM
> and the userspace are collectively playing a role here. It's up to the
> userspace to ensure that the registers are configured the same across
> migrations and KVM ensures that the userspace doesn't modify the
> registers after KVM_RUN so that they don't see features turned OFF/ON
> during execution. I'm not sure if it falls into the definition of
> protecting the host. Do you see a value in adding this extra
> protection from KVM?

Short answer: probably not?

There is precedent for disallowing userspace from doing stupid things, but that's
either for KVM's protection (as Jim pointed out), or because KVM can't honor the
change, e.g. x86 is currently in the process of disallowing most CPUID changes
after KVM_RUN because KVM itself consumes the CPUID information and KVM doesn't
support updating some of it's own internal state (because removing features like
GB hugepage support is nonsensical and would require a large pile of complicated,
messy code).

Restricing CPUID changes does offer some "protection" to the guest, but that's
not the goal.  E.g. KVM won't detect CPUID misconfiguration in the migration
case, and trying to do so is a fool's errand.

If restricting updates in the arm64 is necessary to ensure KVM provides sane
behavior, then it could be justified.  But if it's purely a sanity check on
behalf of the guest, then it's not justified.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
