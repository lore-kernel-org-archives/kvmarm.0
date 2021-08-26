Return-Path: <SRS0=T8IC=NR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38394C432BE
	for <kvmarm@archiver.kernel.org>; Thu, 26 Aug 2021 20:28:05 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A71F26101C
	for <kvmarm@archiver.kernel.org>; Thu, 26 Aug 2021 20:28:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org A71F26101C
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 314564B0E1;
	Thu, 26 Aug 2021 16:28:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id LBwp+mMfFW36; Thu, 26 Aug 2021 16:28:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4C7D04B0F4;
	Thu, 26 Aug 2021 16:28:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 174574B0D7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Aug 2021 16:27:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nhtSxKa05RCj for <kvmarm@lists.cs.columbia.edu>;
 Thu, 26 Aug 2021 16:27:58 -0400 (EDT)
Received: from mail-il1-f179.google.com (mail-il1-f179.google.com
 [209.85.166.179])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 10D164B0CD
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Aug 2021 16:27:58 -0400 (EDT)
Received: by mail-il1-f179.google.com with SMTP id b4so4560514ilr.11
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Aug 2021 13:27:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=AwDm+mXSvlo5Neiekp0GAgNRqFQziU4+j890jb22XOk=;
 b=qeNfkkt3UntsGfR34EMyrGz6DwD4eZGa/xrYQ0kX3UP52yq2/1YyMxaDslK4Tsler8
 C2KD8TEdVVKz/jSaS3VS053Djd4dzRCkEnDC3fgmqMl4yaYJYs+NVu6DMqLRq+4ZIseZ
 BZmWyU+ILyFVViRWa33c/pp9kUAHe+mgq8P6S0Wh2gF68UquFTqVyWGSCjqMp/lR+SDi
 89KUDLXNZhKY92uHH6y/JBJZ0J4t6UoR7CiPWLJ2rspNHd7EG32Tbkb6gcZVpFyyIBg/
 gBTRY85POJ0UeKuKSUMhxLSO2aQRKW4CXZZk29uLFXndKYrQBwjUrz3cWVVlj+83olMy
 jF4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=AwDm+mXSvlo5Neiekp0GAgNRqFQziU4+j890jb22XOk=;
 b=BZSepqj1gx7O8x0Tj6EdijgGiMXaOP2+BP+E8G61q3tU4+hDTRyYYs9nuSn+Wvs8r9
 AXnnatdMlA28+Hrm395EAlep3gRPyUYMLn4pkVKbi0KOdAh7J7apUGXocZEim3iC7ubB
 MXRgqWgMpuhp1AxjvpMZo2xc0R+/Al0/k7cei8IOMpwtLlYgDXY4uXLu7a8F9sVZist9
 4QUjT6zXk1YtQfb8qwUNbCnPXQeKa04KIcei8WwGFL753Aobq/kTlHEe0zi6U37cLrJ+
 gbT5ZviC7NdG2Nwh94DFBE/i/y06yfW/WvE2zs5zfq8cgWcMyUrN7Gt9Cne9GLrB3bnI
 E0rg==
X-Gm-Message-State: AOAM530qRVN82istcYAD6CphcSsRy+x1yQXyPob2qMiMtxjeSMs+NR1k
 Wfr/4R+cP22OUiEY5qfj9fGXdQ==
X-Google-Smtp-Source: ABdhPJxeTBH+DbI4bX1tRHeZzKIvT/4efUkT/jM1XYfogFV5usnZuUXcUrUYOTAvOqiM4kxoO07UxQ==
X-Received: by 2002:a05:6e02:128b:: with SMTP id
 y11mr3913467ilq.104.1630009677230; 
 Thu, 26 Aug 2021 13:27:57 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194])
 by smtp.gmail.com with ESMTPSA id o2sm2359596ilg.47.2021.08.26.13.27.56
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 26 Aug 2021 13:27:56 -0700 (PDT)
Date: Thu, 26 Aug 2021 20:27:53 +0000
From: Oliver Upton <oupton@google.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH v7 6/6] KVM: x86: Expose TSC offset controls to userspace
Message-ID: <YSf5SV0AZMvfIEib@google.com>
References: <20210816001130.3059564-1-oupton@google.com>
 <20210816001130.3059564-7-oupton@google.com>
 <CAOQ_Qsj_MfRNRRSK1UswsfBw4c9ugSW6tKXNua=3O78sHEonvA@mail.gmail.com>
 <20210826124836.GA155749@fuller.cnet>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210826124836.GA155749@fuller.cnet>
Cc: Catalin Marinas <catalin.marinas@arm.com>, kvm@vger.kernel.org,
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, Sean Christopherson <seanjc@google.com>,
 David Matlack <dmatlack@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
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

Marcelo,

On Thu, Aug 26, 2021 at 09:48:36AM -0300, Marcelo Tosatti wrote:
> On Mon, Aug 23, 2021 at 01:56:30PM -0700, Oliver Upton wrote:
> > Paolo,
> > 
> > On Sun, Aug 15, 2021 at 5:11 PM Oliver Upton <oupton@google.com> wrote:
> > >
> > > To date, VMM-directed TSC synchronization and migration has been a bit
> > > messy. KVM has some baked-in heuristics around TSC writes to infer if
> > > the VMM is attempting to synchronize. This is problematic, as it depends
> > > on host userspace writing to the guest's TSC within 1 second of the last
> > > write.
> > >
> > > A much cleaner approach to configuring the guest's views of the TSC is to
> > > simply migrate the TSC offset for every vCPU. Offsets are idempotent,
> > > and thus not subject to change depending on when the VMM actually
> > > reads/writes values from/to KVM. The VMM can then read the TSC once with
> > > KVM_GET_CLOCK to capture a (realtime, host_tsc) pair at the instant when
> > > the guest is paused.
> > >
> > > Cc: David Matlack <dmatlack@google.com>
> > > Cc: Sean Christopherson <seanjc@google.com>
> > > Signed-off-by: Oliver Upton <oupton@google.com>
> > 
> > Could you please squash the following into this patch? We need to
> > advertise KVM_CAP_VCPU_ATTRIBUTES to userspace. Otherwise, happy to
> > resend.
> > 
> > Thanks,
> > Oliver
> 
> Oliver,
> 
> Is there QEMU support for this, or are you using your own
> userspace with this?

Apologies for not getting back to you on your first mail. Sadly, I am
using our own userspace for this. That being said, adding support to
QEMU shouldn't be too challenging. I can take a stab at it if it makes
the series more amenable to upstream, with the giant disclaimer that I
haven't done work in QEMU before. Otherwise, happy to review someone
else's implementation.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
