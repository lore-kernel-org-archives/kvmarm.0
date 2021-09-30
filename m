Return-Path: <SRS0=H8K6=OU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11948C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 30 Sep 2021 17:35:55 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 680E1619E5
	for <kvmarm@archiver.kernel.org>; Thu, 30 Sep 2021 17:35:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 680E1619E5
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CD5E64B0B4;
	Thu, 30 Sep 2021 13:35:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id T2OULTwgkTuk; Thu, 30 Sep 2021 13:35:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B693B4A534;
	Thu, 30 Sep 2021 13:35:52 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AB7AD4A1B0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Sep 2021 13:35:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id A9JlSJsLF5q2 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Sep 2021 13:35:50 -0400 (EDT)
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com
 [209.85.167.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4D25040762
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Sep 2021 13:35:50 -0400 (EDT)
Received: by mail-lf1-f46.google.com with SMTP id b15so28346219lfe.7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Sep 2021 10:35:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=s5N4b19Q49QeVKOuC0SBVfXLj3HIljMXb2q43UZ1RZU=;
 b=Wzcae0dC0R4migP9faLoevPT6NeA4ofALujPzFb5LPchEtGYDaYEcpfcMHc3f6nL4u
 vsCYkmkrivUsiaSdXfvOys+LPVWgFMALtu7w+TgbZL6hpW1Y9cXfHcXfDpx8TGt4aqyI
 q+oAA3nRydIPNQTBCKSIzDBOO12926TNCH/+KRaBua5pg0YrvjqQgqz7fZzyP/eaFUar
 nQNbEEwOdwzVkP/pQJU7lcMLxORWob2euKcVzisb30yGwrshGtJ18z4ZYVMtkWLLpLbn
 MGKvdoG44SqXYzJztlrV58yv+cUwHjo1U3NXPE66ppDN4+zM3cceep2FW/xNsuoHA+5l
 BWVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=s5N4b19Q49QeVKOuC0SBVfXLj3HIljMXb2q43UZ1RZU=;
 b=HK617bf9wOIqakfYs8f5zs306iv9HghoB09Z3kcWso7tfahGSyAiOxVgttHmMlFt3W
 mSlRQWAwcbhLfbZw20te7p8RJBVGqmzzSfp0FKC55tJfxxYjt9lwWWKAXSPI4mlR/oVf
 Y8QWPfMVhBGNKiPPinc09c8oMCnPo1p4M0YiaR6GvMMkvZHaovWl0BSaqDSwnm7W68uy
 pcy0B+cvJQt7HSbK0KNMdm0XtoecjP+kOF8G6syyEECy2FZ7yuaV7xvYuOFtGoELHDYN
 p2H6i08N9ba2GFNd1f9YX4BW0+8tOgVkIXqEBsDIDVyjvWc6wok+rNSI6J5HXK9/uuPe
 DXHg==
X-Gm-Message-State: AOAM530bcTm9aD2PEbTS44L41ugl3sYiuI5H2lFeJqnLtmRQgKwqlK6b
 ejVjcPjl3qHFLEu7VjXK6VQWOgl+Hn15aO032V554g==
X-Google-Smtp-Source: ABdhPJxqPGj5cL1Lx+IjKbi+sEIpu/qet2OJxG2dnCOQma9Vui7OB+v+y/6skqu8JhFPQHC/P7ckRH2kXO2E1obtI+4=
X-Received: by 2002:ac2:4c50:: with SMTP id o16mr453283lfk.286.1633023346789; 
 Thu, 30 Sep 2021 10:35:46 -0700 (PDT)
MIME-Version: 1.0
References: <20210923191610.3814698-1-oupton@google.com>
 <20210923191610.3814698-7-oupton@google.com>
 <877deytfes.wl-maz@kernel.org> <YVXxlg6g4fYsphwM@google.com>
In-Reply-To: <YVXxlg6g4fYsphwM@google.com>
From: Oliver Upton <oupton@google.com>
Date: Thu, 30 Sep 2021 10:35:35 -0700
Message-ID: <CAOQ_QsjQL-o926c_dQ4_snRKGQN+WhScX9yRQ4UPkbMJcmRvGQ@mail.gmail.com>
Subject: Re: [PATCH v2 06/11] KVM: arm64: Add support for SYSTEM_SUSPEND PSCI
 call
To: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
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

On Thu, Sep 30, 2021 at 10:19 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Thu, Sep 30, 2021, Marc Zyngier wrote:
> > Hi Oliver,
> >
> > On Thu, 23 Sep 2021 20:16:05 +0100,
> > Oliver Upton <oupton@google.com> wrote:
> > >
> > > ARM DEN0022D 5.19 "SYSTEM_SUSPEND" describes a PSCI call that may be
> > > used to request a system be suspended. This is optional for PSCI v1.0
> > > and to date KVM has elected to not implement the call. However, a
> > > VMM/operator may wish to provide their guests with the ability to
> > > suspend/resume, necessitating this PSCI call.
> > >
> > > Implement support for SYSTEM_SUSPEND according to the prescribed
> > > behavior in the specification. Add a new system event exit type,
> > > KVM_SYSTEM_EVENT_SUSPEND, to notify userspace when a VM has requested a
> > > system suspend. Make KVM_MP_STATE_HALTED a valid state on arm64.
> >
> > KVM_MP_STATE_HALTED is a per-CPU state on x86 (it denotes HLT). Does
> > it make really sense to hijack this for something that is more of a
> > VM-wide state? I can see that it is tempting to do so as we're using
> > the WFI semantics (which are close to HLT's, in a twisted kind of
> > way), but I'm also painfully aware that gluing x86 expectations on
> > arm64 rarely leads to a palatable result.
>
> Agreed, we literally have billions of possible KVM_MP_STATE_* values, and I'm pretty
> sure all of the existing states are arch-specific.  Some are common to multiple
> architectures, but I don't think _any_ are common to all architectures.

Yeah, I was debating this as well when cooking up the series. No need
to overload the x86-ism when we can have a precisely named state for
ARM.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
