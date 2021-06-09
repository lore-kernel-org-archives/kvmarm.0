Return-Path: <SRS0=1TKy=LD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F73BC48BCF
	for <kvmarm@archiver.kernel.org>; Wed,  9 Jun 2021 17:05:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id EABF0613CB
	for <kvmarm@archiver.kernel.org>; Wed,  9 Jun 2021 17:05:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EABF0613CB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6482C40874;
	Wed,  9 Jun 2021 13:05:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rTaodhtIbqit; Wed,  9 Jun 2021 13:05:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E58640895;
	Wed,  9 Jun 2021 13:05:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E5E4C40874
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Jun 2021 13:05:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KyLhLh1wefhg for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Jun 2021 13:05:05 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1CCB740877
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Jun 2021 13:05:05 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1623258304;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=z/0IZRZoC3ri5K//x8QvcCXoHJZ9nYpVsoZ41efk2hc=;
 b=F3sxpGERveqOT0nHbXVt2s3sM0a324IyeJLnqWFdJ3L4AYTQVsNluxQcHQKq9NA3dvzt1D
 7zJVYSlUIN7pp4w0ZOeDk7KujS0Fidf0iTJbWY9sJwI81RHtrLTB05pLQK3Ii32Z8XD0sD
 hCLEdA0B1si50lMmwK34fa2oAeInY38=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-269-22kcvtcXNWyBRYvopv2OFg-1; Wed, 09 Jun 2021 13:05:03 -0400
X-MC-Unique: 22kcvtcXNWyBRYvopv2OFg-1
Received: by mail-wm1-f71.google.com with SMTP id
 n21-20020a7bcbd50000b02901a2ee0826aeso2763376wmi.7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 09 Jun 2021 10:05:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:to:cc:references:from:subject:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=z/0IZRZoC3ri5K//x8QvcCXoHJZ9nYpVsoZ41efk2hc=;
 b=habqx7vozDrJ96mYBPnmfzqYztC8Q+CuAR+ZnBYxAUqPUvSTFQcM0w+m59ujVZ2VS7
 UEd1U21LGMEcY52c/KXNc+KsDKgrk6dyUvt8PNGzOSVRjs6YgQUlaCC/Iu3oe7AGWuGq
 SCGQJ/rSyrNQEa5tURoMixXeyiK/dYZrN+Piw8TGvAFvzn8uGWqbq+iwYncLqHlfyE6/
 TDZvpu9D/G/0frstSo+QmxBusPwsl9ZMiPNzv9cFZkbPzRVYcxVtgw31CXAr/FDLjdpK
 QI9sc9IGVBLnYBuOa4t8sl4eDoocTKNjRxtsxLc/FlRYY08lz/bFjK7QAE6j63IuJB9P
 oDzw==
X-Gm-Message-State: AOAM533KQIfrlIWoNSXS/MzNOeeMtsiRc/4Y74bCi8PzOKU1WkD76yG5
 LKNEHLBzWR2ngWBV1G4mSqtsbrA5Fx1xXY9dw8huVMkku2cQt3V7OSPSt2AwDz7OA/t6voN6NMw
 r3Q4mH1G0NcsIEAC1/fEiX4TE
X-Received: by 2002:adf:ebc6:: with SMTP id v6mr826824wrn.398.1623258302701;
 Wed, 09 Jun 2021 10:05:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxaW3OOmEAQH+v0OvxZ0vKkU470FzSpAi/RT8NhguIjbrHXsEL8uvseKqREFNzGs715WEKSsw==
X-Received: by 2002:adf:ebc6:: with SMTP id v6mr826808wrn.398.1623258302507;
 Wed, 09 Jun 2021 10:05:02 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id j18sm528979wrw.30.2021.06.09.10.05.01
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 09 Jun 2021 10:05:01 -0700 (PDT)
To: Oliver Upton <oupton@google.com>
References: <20210608214742.1897483-1-oupton@google.com>
 <63db3823-b8a3-578d-4baa-146104bb977f@redhat.com>
 <CAOQ_QsgPHAUuzeLy5sX=EhE8tKs7yEF3rxM47YeM_Pk3DUXMcg@mail.gmail.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 00/10] KVM: Add idempotent controls for migrating system
 counter state
Message-ID: <d5a79989-6866-a405-5501-a3b1223b2ecd@redhat.com>
Date: Wed, 9 Jun 2021 19:05:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAOQ_QsgPHAUuzeLy5sX=EhE8tKs7yEF3rxM47YeM_Pk3DUXMcg@mail.gmail.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 09/06/21 17:11, Oliver Upton wrote:
> Perhaps this will clarify the motivation for my approach: what if the
> kernel wasn't the authoritative source for wall time in a system?
> Furthermore, VMMs may wish to define their own heuristics for counter
> migration (e.g. we only allow the counter to 'jump' by X seconds
> during migration blackout). If a VMM tried to assert its whims on the
> TSC state before handing it down to the kernel, we would inadvertently
> be sampling the host counter twice again. And, anything can happen
> between the time we assert elapsed time is within SLO and KVM
> computing the TSC offset (scheduling, L0 hypervisor preemption).
> 
> So, Maxim's changes would address my concerns in the general case, but
> maybe not as much in edge cases where an operator may make decisions
> about how much time can elapse while the guest hasn't had CPU time.

I think I understand.  We still need a way to get a consistent 
(host_TSC, nanosecond) pair on the source, the TSC offset is not enough. 
  This is arguably not a KVM issue, but we're still the one having to 
provide a solution, so we would need a slightly more complicated interface.

1) In the kernel:

* KVM_GET_CLOCK should also return kvmclock_ns - realtime_ns and 
host_TSC.  It should set two flags in struct kvm_clock_data saying that 
the respective fields are valid.

* KVM_SET_CLOCK checks the flag for kvmclock_ns - realtime_ns.  If set, 
it looks at the kvmclock_ns - realtime_ns field and disregards the 
kvmclock_ns field.

2) On the source, userspace will:

* per-VM: invoke KVM_GET_CLOCK.  Migrate kvmclock_ns - realtime_ns and 
kvmclock_ns.  Stash host_TSC for subsequent use.

* per-vCPU: retrieve guest_TSC - host_TSC with your new ioctl.  Sum it 
to the stashed host_TSC value; migrate the resulting value (a guest TSC).

3) On the destination:

* per-VM: Pass the migrated kvmclock_ns - realtime_ns to KVM_SET_CLOCK. 
  Use KVM_GET_CLOCK to get a consistent pair of kvmclock_ns ("newNS" 
below) and host TSC ("newHostTSC").  Stash them for subsequent use, 
together with the migrated kvmclock_ns value ("sourceNS") that you 
haven't used yet.

* per-vCPU: using the data of the previous step, and the sourceGuestTSC 
in the migration stream, compute sourceGuestTSC + (newNS - sourceNS) * 
freq - newHostTSC.  This is the TSC offset to be passed to your new ioctl.

Your approach still needs to use the "quirky" approach to host-initiated 
MSR_IA32_TSC_ADJUST writes, which write the MSR without affecting the 
VMCS offset.  This is just a documentation issue.

Does this make sense?

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
