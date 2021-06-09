Return-Path: <SRS0=1TKy=LD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 805FEC48BCF
	for <kvmarm@archiver.kernel.org>; Wed,  9 Jun 2021 22:05:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E57E3613EF
	for <kvmarm@archiver.kernel.org>; Wed,  9 Jun 2021 22:05:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E57E3613EF
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 37D85407B0;
	Wed,  9 Jun 2021 18:05:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id O+29qzzK8HA8; Wed,  9 Jun 2021 18:05:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EE4C440CF8;
	Wed,  9 Jun 2021 18:05:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 23CE0406D3
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Jun 2021 18:05:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qNS3pu7Fc8n4 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Jun 2021 18:05:11 -0400 (EDT)
Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com
 [209.85.208.174])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D081340617
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Jun 2021 18:05:10 -0400 (EDT)
Received: by mail-lj1-f174.google.com with SMTP id e11so1771509ljn.13
 for <kvmarm@lists.cs.columbia.edu>; Wed, 09 Jun 2021 15:05:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=4vr2tBHks9ZBBCNjLgkmwbQ5QJI5NTkstZNlpt1qagU=;
 b=RazSI0IwVhztNcLYGcPLLoPrHxs2ar0yzXkSt3W6WGNGHWsMxpJaYTP9NEIf6ASgJD
 N6Xgux5HtSGOaStAc84anHQxcgAs56eTPw9jpK4ydrlZeKyX4t/8YQVhbbKMbhof5KWS
 Ns9NY239sKswxxVTeGkN08ZvrlVTwKBnmr/WMZ6qPDpE4SWF3b5lUWDPWPmh+8Bm8MSP
 tsD5RzDj/reVH08U1gTRd2MuyXPSdAbEklEEIwBJM0NdSJEjEaMBrSxx2W/YqZyIn0ZM
 CV/Ysyyj7fo8/VEc+j6Dx3+RWx3v5jyXudO4vsI9CeTMxPHXHFDJLLFHBzjQU650cMku
 86Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=4vr2tBHks9ZBBCNjLgkmwbQ5QJI5NTkstZNlpt1qagU=;
 b=aFPAW2TsDJI6STsYF9905JeWz0pzAVO+SLV8iSiBMZGF738vtxrewjXM+5SlYF6iVU
 N/1CNc+xw6+BXPpSD9DRuHmyoPry/dz/YMyAAJx8jbNieGWgI6NX6HtMc0guqNr58N3l
 pPQiTCFSihpkV9Q0xkZS3dsMNT856sGBu/3oyqmCxacJwSi8onY9eBnci3pQ7vKJR3u8
 wTPNMAXlGvUwg73F8MobmVG8P/GHwcbU4kbaNYIG0Dw+/6FWfHhuKRGgj/noUkU4Bwja
 Bb8qDeXrPeqaNZHPzSKpFZ9Mc/rBw/wF8cDOtJVAUa43Vly6WYd8+kPq+MHvpQfKps1f
 D4UQ==
X-Gm-Message-State: AOAM531DpeS14IpsehiOFu7Sp0eKws5ZsPWTrjGUxi6EtiVRiCrExL2S
 IdU1RQs1crTTFBK5NqKDMiospddCoHIOgCbRfhigbQ==
X-Google-Smtp-Source: ABdhPJy7amfMMNI9BVqffQnd2f3UaNboqUWX2CbIPWkfwsMGpwMQKSYrxM7Q52wynbMbN8j1smXqh5iad9xOhKETNx4=
X-Received: by 2002:a2e:7d0f:: with SMTP id y15mr1404039ljc.388.1623276309082; 
 Wed, 09 Jun 2021 15:05:09 -0700 (PDT)
MIME-Version: 1.0
References: <20210608214742.1897483-1-oupton@google.com>
 <63db3823-b8a3-578d-4baa-146104bb977f@redhat.com>
 <CAOQ_QsgPHAUuzeLy5sX=EhE8tKs7yEF3rxM47YeM_Pk3DUXMcg@mail.gmail.com>
 <d5a79989-6866-a405-5501-a3b1223b2ecd@redhat.com>
In-Reply-To: <d5a79989-6866-a405-5501-a3b1223b2ecd@redhat.com>
From: Oliver Upton <oupton@google.com>
Date: Wed, 9 Jun 2021 17:04:57 -0500
Message-ID: <CAOQ_QsgvmmiQgV5rUBnNtoz+NfwEe2e4ebfpe8rJviR20QUjoQ@mail.gmail.com>
Subject: Re: [PATCH 00/10] KVM: Add idempotent controls for migrating system
 counter state
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm list <kvm@vger.kernel.org>, Sean Christopherson <seanjc@google.com>,
 Raghavendra Rao Anata <rananta@google.com>, Peter Shier <pshier@google.com>,
 Maxim Levitsky <mlevitsk@redhat.com>, Marc Zyngier <maz@kernel.org>,
 David Matlack <dmatlack@google.com>, kvmarm@lists.cs.columbia.edu,
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

On Wed, Jun 9, 2021 at 12:05 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 09/06/21 17:11, Oliver Upton wrote:
> > Perhaps this will clarify the motivation for my approach: what if the
> > kernel wasn't the authoritative source for wall time in a system?
> > Furthermore, VMMs may wish to define their own heuristics for counter
> > migration (e.g. we only allow the counter to 'jump' by X seconds
> > during migration blackout). If a VMM tried to assert its whims on the
> > TSC state before handing it down to the kernel, we would inadvertently
> > be sampling the host counter twice again. And, anything can happen
> > between the time we assert elapsed time is within SLO and KVM
> > computing the TSC offset (scheduling, L0 hypervisor preemption).
> >
> > So, Maxim's changes would address my concerns in the general case, but
> > maybe not as much in edge cases where an operator may make decisions
> > about how much time can elapse while the guest hasn't had CPU time.
>
> I think I understand.  We still need a way to get a consistent
> (host_TSC, nanosecond) pair on the source, the TSC offset is not enough.
>   This is arguably not a KVM issue, but we're still the one having to
> provide a solution, so we would need a slightly more complicated interface.

Ah, right, good luck doing that without some help from the kernel. +1
to this _not_ being a KVM issue, but anyways...

> 1) In the kernel:
>
> * KVM_GET_CLOCK should also return kvmclock_ns - realtime_ns and
> host_TSC.  It should set two flags in struct kvm_clock_data saying that
> the respective fields are valid.
>
> * KVM_SET_CLOCK checks the flag for kvmclock_ns - realtime_ns.  If set,
> it looks at the kvmclock_ns - realtime_ns field and disregards the
> kvmclock_ns field.

Yeah, these additions all make sense to me.

>
> 2) On the source, userspace will:
>
> * per-VM: invoke KVM_GET_CLOCK.  Migrate kvmclock_ns - realtime_ns and
> kvmclock_ns.  Stash host_TSC for subsequent use.
>
> * per-vCPU: retrieve guest_TSC - host_TSC with your new ioctl.  Sum it
> to the stashed host_TSC value; migrate the resulting value (a guest TSC).
>
> 3) On the destination:
>
> * per-VM: Pass the migrated kvmclock_ns - realtime_ns to KVM_SET_CLOCK.
>   Use KVM_GET_CLOCK to get a consistent pair of kvmclock_ns ("newNS"
> below) and host TSC ("newHostTSC").  Stash them for subsequent use,
> together with the migrated kvmclock_ns value ("sourceNS") that you
> haven't used yet.
>
> * per-vCPU: using the data of the previous step, and the sourceGuestTSC
> in the migration stream, compute sourceGuestTSC + (newNS - sourceNS) *
> freq - newHostTSC.  This is the TSC offset to be passed to your new ioctl.
>
> Your approach still needs to use the "quirky" approach to host-initiated
> MSR_IA32_TSC_ADJUST writes, which write the MSR without affecting the
> VMCS offset.  This is just a documentation issue.

I think I follow what you're saying. To confirm:

My suggested ioctl for the vCPU will still exist, and it will still
affect the VMCS tsc offset, right? However, we need to do one of the
following:

- Stash the guest's MSR_IA32_TSC_ADJUST value in the
kvm_system_counter_state structure. During
KVM_SET_SYSTEM_COUNTER_STATE, check to see if the field is valid. If
so, treat it as a dumb value (i.e. show it to the guest but don't fold
it into the offset).
- Inform userspace that it must still migrate MSR_IA32_TSC_ADJUST, and
continue to our quirky behavior around host-initiated writes of the
MSR.

This is why Maxim's spin migrated a value for IA32_TSC_ADJUST, right?
Doing so ensures we don't have any guest-observable consequences due
to our migration of TSC state. To me, adding the guest IA32_TSC_ADJUST
MSR into the new counter state structure is probably best. No strong
opinions in either direction on this point, though :)

--
Thanks,
Oliver

>
> Does this make sense?
>
> Paolo
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
