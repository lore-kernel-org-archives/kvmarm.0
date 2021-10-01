Return-Path: <SRS0=fGD+=OV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05A76C433F5
	for <kvmarm@archiver.kernel.org>; Fri,  1 Oct 2021 19:33:47 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6B43061AF9
	for <kvmarm@archiver.kernel.org>; Fri,  1 Oct 2021 19:33:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 6B43061AF9
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BC9714B103;
	Fri,  1 Oct 2021 15:33:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id aVRiqmwYoDIP; Fri,  1 Oct 2021 15:33:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 96B9D4B108;
	Fri,  1 Oct 2021 15:33:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 611054B103
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Oct 2021 15:33:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gB0b5QtJohmz for <kvmarm@lists.cs.columbia.edu>;
 Fri,  1 Oct 2021 15:33:42 -0400 (EDT)
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com
 [209.85.167.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E45644A98B
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Oct 2021 15:33:41 -0400 (EDT)
Received: by mail-lf1-f45.google.com with SMTP id j5so37883961lfg.8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 01 Oct 2021 12:33:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=lii4irCWuescdgJ8qHne5ganrtx81N8HthbF9dME2UM=;
 b=h1rHeVjKjeLEj8nGjof49Pd0T2ie4OmSkMTfgALjI5Gcernl+YZjCCuobSOgsdFgc3
 j8dNkCsydm1fsBYbesTaViMtqL2yGxR5evbon0tMz6H1xbxXcZJesqo/m7c3dK+BoyT4
 4dPGdbvi7CIH4BalIV8bDBVqB9ospaBvuw4hxVJqE/FTt6BvYEZE5tmPvN8/16Vr2OaE
 4hWnW+uL3Yvb4sE35q72t5/FxZWCUtnrhmxpRoz594iyROR/W9PpDckHb9hmpXDOEC2Y
 L8Kph7DALD0JvkM/lNVQjGjtv8rsgrXkbMDc2Z+bJDgO5SMf+4hGocrKpEDtXGoQSYdz
 Fv0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=lii4irCWuescdgJ8qHne5ganrtx81N8HthbF9dME2UM=;
 b=nVPDeKBWcw8fboHj9+EFBWBSfrG5y4nrdlqeads9YbGSd+g4zabbUxyzYMTm0jPByY
 gRGMOP2I4JugtnWwT+HLUBSN2J1zEM4gwyACBPWXPIPjYJKiJi9gwy5Ce3Mpv211N1N4
 JUxMWMyM9ZW+xT2GLAN9WHUmNa4GN85pn1UlKuKCoTrcxtT+kvVCTtR3BOsuILwnLtbm
 mJjEEM8Xy2Vr+L1RmChVpDUhvJlr6OWbkQtZTvv9aEy4y/WSKmHefYbLtn7R8nZ5r9or
 bzgjGM3eV7EpOrG3dkQ21XNE90kFS1Jw5H0ao0+SKAQp5UwAdGwsffXoEv31m8/PGPyh
 UfGw==
X-Gm-Message-State: AOAM530Zcd48XN/5y82rkaGeSq312ioBmJhnS8EHdSuQ2IqFGJ+zS7Pj
 eqpzIGADgJwn1OJmh3eXIO2iHsRLfOym7e12aASDaQ==
X-Google-Smtp-Source: ABdhPJw+Z01osONV6J5L1RS3jy7EKpHAdiP4X9TWYz7i69dZ0Te0HCclKlzbP9IDkAvJszp37qVwwCaOu6pLSTJ9OSQ=
X-Received: by 2002:a2e:b88c:: with SMTP id r12mr14315182ljp.479.1633116820090; 
 Fri, 01 Oct 2021 12:33:40 -0700 (PDT)
MIME-Version: 1.0
References: <20210916181538.968978-1-oupton@google.com>
 <20210916181538.968978-8-oupton@google.com>
 <20210930191416.GA19068@fuller.cnet>
 <48151d08-ee29-2b98-b6e1-f3c8a1ff26bc@redhat.com>
 <20211001103200.GA39746@fuller.cnet>
 <7901cb84-052d-92b6-1e6a-028396c2c691@redhat.com>
 <20211001191117.GA69579@fuller.cnet>
In-Reply-To: <20211001191117.GA69579@fuller.cnet>
From: Oliver Upton <oupton@google.com>
Date: Fri, 1 Oct 2021 12:33:28 -0700
Message-ID: <CAOQ_Qsj9ObSakmqgFQf598VscQWDh_Cq3WFqF7EpKqe2+RRgVg@mail.gmail.com>
Subject: Re: [PATCH v8 7/7] KVM: x86: Expose TSC offset controls to userspace
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, kvm@vger.kernel.org,
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, David Matlack <dmatlack@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>
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

On Fri, Oct 1, 2021 at 12:11 PM Marcelo Tosatti <mtosatti@redhat.com> wrote:
>
> On Fri, Oct 01, 2021 at 05:12:20PM +0200, Paolo Bonzini wrote:
> > On 01/10/21 12:32, Marcelo Tosatti wrote:
> > > > +1. Invoke the KVM_GET_CLOCK ioctl to record the host TSC (t_0), +
> > > > kvmclock nanoseconds (k_0), and realtime nanoseconds (r_0). + [...]
> > > >  +4. Invoke the KVM_SET_CLOCK ioctl, providing the kvmclock
> > > > nanoseconds +   (k_0) and realtime nanoseconds (r_0) in their
> > > > respective fields. +   Ensure that the KVM_CLOCK_REALTIME flag is
> > > > set in the provided +   structure. KVM will advance the VM's
> > > > kvmclock to account for elapsed +   time since recording the clock
> > > > values.
> > >
> > > You can't advance both kvmclock (kvmclock_offset variable) and the
> > > TSCs, which would be double counting.
> > >
> > > So you have to either add the elapsed realtime (1) between
> > > KVM_GET_CLOCK to kvmclock (which this patch is doing), or to the
> > > TSCs. If you do both, there is double counting. Am i missing
> > > something?
> >
> > Probably one of these two (but it's worth pointing out both of them):
> >
> > 1) the attribute that's introduced here *replaces*
> > KVM_SET_MSR(MSR_IA32_TSC), so the TSC is not added.
> >
> > 2) the adjustment formula later in the algorithm does not care about how
> > much time passed between step 1 and step 4.  It just takes two well
> > known (TSC, kvmclock) pairs, and uses them to ensure the guest TSC is
> > the same on the destination as if the guest was still running on the
> > source.  It is irrelevant that one of them is before migration and one
> > is after, all it matters is that one is on the source and one is on the
> > destination.
>
> OK, so it still relies on NTPd daemon to fix the CLOCK_REALTIME delay
> which is introduced during migration (which is what i would guess is
> the lower hanging fruit) (for guests using TSC).

The series gives userspace the ability to modify the guest's
perception of the TSC in whatever way it sees fit. The algorithm in
the documentation provides a suggestion to userspace on how to do
exactly that. I kept that advancement logic out of the kernel because
IMO it is an implementation detail: users have differing opinions on
how clocks should behave across a migration and KVM shouldn't have any
baked-in rules around it.

At the same time, userspace can choose to _not_ jump the TSC and use
the available interfaces to just migrate the existing state of the
TSCs.

When I had initially proposed this series upstream, Paolo astutely
pointed out that there was no good way to get a (CLOCK_REALTIME, TSC)
pairing, which is critical for the TSC advancement algorithm in the
documentation. Google's best way to get (CLOCK_REALTIME, TSC) exists
in userspace [1], hence the missing kvm clock changes. So, in all, the
spirit of the KVM clock changes is to provide missing UAPI around the
clock/TSC, with the side effect of changing the guest-visible value.

[1] https://cloud.google.com/spanner/docs/true-time-external-consistency

> My point was that, by advancing the _TSC value_ by:
>
> T0. stop guest vcpus    (source)
> T1. KVM_GET_CLOCK       (source)
> T2. KVM_SET_CLOCK       (destination)
> T3. Write guest TSCs    (destination)
> T4. resume guest        (destination)
>
> new_off_n = t_0 + off_n + (k_1 - k_0) * freq - t_1
>
> t_0:    host TSC at KVM_GET_CLOCK time.
> off_n:  TSC offset at vcpu-n (as long as no guest TSC writes are performed,
> TSC offset is fixed).
> ...
>
> +4. Invoke the KVM_SET_CLOCK ioctl, providing the kvmclock nanoseconds
> +   (k_0) and realtime nanoseconds (r_0) in their respective fields.
> +   Ensure that the KVM_CLOCK_REALTIME flag is set in the provided
> +   structure. KVM will advance the VM's kvmclock to account for elapsed
> +   time since recording the clock values.
>
> Only kvmclock is advanced (by passing r_0). But a guest might not use kvmclock
> (hopefully modern guests on modern hosts will use TSC clocksource,
> whose clock_gettime is faster... some people are using that already).
>

Hopefully the above explanation made it clearer how the TSCs are
supposed to get advanced, and why it isn't done in the kernel.

> At some point QEMU should enable invariant TSC flag by default?
>
> That said, the point is: why not advance the _TSC_ values
> (instead of kvmclock nanoseconds), as doing so would reduce
> the "the CLOCK_REALTIME delay which is introduced during migration"
> for both kvmclock users and modern tsc clocksource users.
>
> So yes, i also like this patchset, but would like it even more
> if it fixed the case above as well (and not sure whether adding
> the migration delta to KVMCLOCK makes it harder to fix TSC case
> later).
>
> > Perhaps we can add to step 6 something like:
> >
> > > +6. Adjust the guest TSC offsets for every vCPU to account for (1)
> > > time +   elapsed since recording state and (2) difference in TSCs
> > > between the +   source and destination machine: + +   new_off_n = t_0
> > > + off_n + (k_1 - k_0) * freq - t_1 +
> >
> > "off + t - k * freq" is the guest TSC value corresponding to a time of 0
> > in kvmclock.  The above formula ensures that it is the same on the
> > destination as it was on the source.
> >
> > Also, the names are a bit hard to follow.  Perhaps
> >
> >       t_0             tsc_src
> >       t_1             tsc_dest
> >       k_0             guest_src
> >       k_1             guest_dest
> >       r_0             host_src
> >       off_n           ofs_src[i]
> >       new_off_n       ofs_dest[i]
> >
> > Paolo
> >

Yeah, sounds good to me. Shall I respin the whole series from what you
have in kvm/queue, or just send you the bits and pieces that ought to
be applied?

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
