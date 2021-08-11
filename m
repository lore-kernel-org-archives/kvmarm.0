Return-Path: <SRS0=13S2=NC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3661CC4338F
	for <kvmarm@archiver.kernel.org>; Wed, 11 Aug 2021 18:56:42 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9E5E860560
	for <kvmarm@archiver.kernel.org>; Wed, 11 Aug 2021 18:56:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 9E5E860560
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0275949DE7;
	Wed, 11 Aug 2021 14:56:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 22Kz1iidj31F; Wed, 11 Aug 2021 14:56:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0DA5C4A32E;
	Wed, 11 Aug 2021 14:56:37 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0E4AC4A2E5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Aug 2021 14:56:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8AK4J-9RnKgi for <kvmarm@lists.cs.columbia.edu>;
 Wed, 11 Aug 2021 14:56:35 -0400 (EDT)
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com
 [209.85.167.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CB4964A1AF
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Aug 2021 14:56:34 -0400 (EDT)
Received: by mail-lf1-f46.google.com with SMTP id c24so7834805lfi.11
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Aug 2021 11:56:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=ScGXpGBVKuemsdnjrMZtpirVRiYqp0nxEwpdjzvAcQc=;
 b=BKzD/phz2V62L+BYy2l6IT1uRjXbNsfEnzJ1FP0i4QNPcJzu7wq5do8D8vcLmOFMdd
 7KpQTTNtf52WOneMY8EYnz8BGgQdqj2Hn1/PyugV0cMwUsu28juY0d7gBj+7y3ap/Yr/
 wbBDtL9syqcrir563sm91vau1YSpqnaTb42w7lyS7D4tUUzvIWRWTiL6mDX8BbNyH+6/
 6bi6aiP5Zmp3R99aKSL7YAvBriWg+BAJBHE+BFjlz2Hbb+1bY+8a49+1+3ekTgERfjHp
 OF7r5f7z69rrUu95q0CIjZuxKjsDyvAJjD6vCEwiKG1XrUAe0CFLx0GFn3FX5zjSO+Sv
 UhHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=ScGXpGBVKuemsdnjrMZtpirVRiYqp0nxEwpdjzvAcQc=;
 b=cOosXKg9viNwFlUR8SggpganHLisz6vmYlPfQQUj2tQEnMaia8PE4X29ImDXI+tyMm
 GJKRMdi3/+Ago1J40hiDgBCNUbasO/h+/HjcEx96uzh8iSSYr0TSUb9d8rHFTsy7FpTt
 BHkDovoOw7KUqxtDMfmZkPWTaIlnmHPIDlVQUaaYoKTh++ObTGG9DNR/kUMa2OM2fO5V
 MRD8L29Y08XTfAW/oKo7w+9Nu3XNAlafMCoIQ6YbIBmK6FIeLokFIvke+RE5pS3iJn6W
 LAS/6Iq2b4IMZtR3i89ZpxChutjGUDltUWjfy8ZgfkLr/bSQHeAfyREXyq6+Zi2ngQFR
 9Xbw==
X-Gm-Message-State: AOAM533xUK2Ui2eLPhc0yghthsNVujd+krRK8Ayf+m5YViiMgrGFYwOa
 CebN1GZs/InrkDL0jmLk0T4OKlUMM7zwqtJPAQXb8A==
X-Google-Smtp-Source: ABdhPJwGtbhMqHwJKvW91HNOMAe2ToUWMYoIqEwOcawUfgK0gps7jUCiF6LzH6yuRTJPb08sopXFSG2mGtm6DyX1DtU=
X-Received: by 2002:ac2:5fc7:: with SMTP id q7mr183843lfg.524.1628708193196;
 Wed, 11 Aug 2021 11:56:33 -0700 (PDT)
MIME-Version: 1.0
References: <20210804085819.846610-1-oupton@google.com>
 <927240ff-a4f4-fcc6-ae1b-92cefeda9e59@redhat.com>
In-Reply-To: <927240ff-a4f4-fcc6-ae1b-92cefeda9e59@redhat.com>
From: Oliver Upton <oupton@google.com>
Date: Wed, 11 Aug 2021 11:56:22 -0700
Message-ID: <CAOQ_Qsjby+z_kU49_s0PDKo5c3V-UD+FRg-2PcPycNq-p2gPVg@mail.gmail.com>
Subject: Re: [PATCH v6 00/21] KVM: Add idempotent controls for migrating
 system counter state
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, kvm@vger.kernel.org,
 Will Deacon <will@kernel.org>, Sean Christopherson <seanjc@google.com>,
 Raghavendra Rao Anata <rananta@google.com>, Peter Shier <pshier@google.com>,
 Marc Zyngier <maz@kernel.org>, David Matlack <dmatlack@google.com>,
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

On Wed, Aug 11, 2021 at 6:05 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 04/08/21 10:57, Oliver Upton wrote:
> > KVM's current means of saving/restoring system counters is plagued with
> > temporal issues. At least on ARM64 and x86, we migrate the guest's
> > system counter by-value through the respective guest system register
> > values (cntvct_el0, ia32_tsc). Restoring system counters by-value is
> > brittle as the state is not idempotent: the host system counter is still
> > oscillating between the attempted save and restore. Furthermore, VMMs
> > may wish to transparently live migrate guest VMs, meaning that they
> > include the elapsed time due to live migration blackout in the guest
> > system counter view. The VMM thread could be preempted for any number of
> > reasons (scheduler, L0 hypervisor under nested) between the time that
> > it calculates the desired guest counter value and when KVM actually sets
> > this counter state.
> >
> > Despite the value-based interface that we present to userspace, KVM
> > actually has idempotent guest controls by way of system counter offsets.
> > We can avoid all of the issues associated with a value-based interface
> > by abstracting these offset controls in new ioctls. This series
> > introduces new vCPU device attributes to provide userspace access to the
> > vCPU's system counter offset.
> >
> > Patch 1 addresses a possible race in KVM_GET_CLOCK where
> > use_master_clock is read outside of the pvclock_gtod_sync_lock.
> >
> > Patch 2 adopts Paolo's suggestion, augmenting the KVM_{GET,SET}_CLOCK
> > ioctls to provide userspace with a (host_tsc, realtime) instant. This is
> > essential for a VMM to perform precise migration of the guest's system
> > counters.
> >
> > Patches 3-4 are some preparatory changes for exposing the TSC offset to
> > userspace. Patch 5 provides a vCPU attribute to provide userspace access
> > to the TSC offset.
> >
> > Patches 6-7 implement a test for the new additions to
> > KVM_{GET,SET}_CLOCK.
> >
> > Patch 8 fixes some assertions in the kvm device attribute helpers.
> >
> > Patches 9-10 implement at test for the tsc offset attribute introduced in
> > patch 5.
>
> The x86 parts look good, except that patch 3 is a bit redundant with my
> idea of altogether getting rid of the pvclock_gtod_sync_lock.  That said
> I agree that patches 1 and 2 (and extracting kvm_vm_ioctl_get_clock and
> kvm_vm_ioctl_set_clock) should be done before whatever locking changes
> have to be done.

Following up on patch 3.

> Time is ticking for 5.15 due to my vacation, I'll see if I have some
> time to look at it further next week.
>
> I agree that arm64 can be done separately from x86.

Marc, just a disclaimer:

I'm going to separate these two series, although there will still
exist dependencies in the selftests changes. Otherwise, kernel changes
are disjoint.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
