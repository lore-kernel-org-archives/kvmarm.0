Return-Path: <SRS0=81/H=MN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2E77C12002
	for <kvmarm@archiver.kernel.org>; Wed, 21 Jul 2021 15:28:16 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 39BDE61248
	for <kvmarm@archiver.kernel.org>; Wed, 21 Jul 2021 15:28:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 39BDE61248
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B525B4B0FE;
	Wed, 21 Jul 2021 11:28:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2siQQnBJTNK1; Wed, 21 Jul 2021 11:28:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 96CEE4B103;
	Wed, 21 Jul 2021 11:28:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 017654B0FE
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Jul 2021 11:28:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BgKaKtDdOlIp for <kvmarm@lists.cs.columbia.edu>;
 Wed, 21 Jul 2021 11:28:12 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D9CD94B0FD
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Jul 2021 11:28:12 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1626881292;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=FdvVljLxaRoKu02p/XKHt8pLC1+aQhmZqpHxlBYeaQA=;
 b=EnFABkCBlEpTRx22j5dbH5LNiTrSfZmp030dnCwscwek56a1jN8q/BBrjBAHMglx43TV9t
 e3lIG89HXy7zIIyHnB5wQxMeiK4SKdNs/Wr4Y5dmDjHLKainX2ezEh1Du5KJ5/Y/msM/Cl
 THNCTvr+vgIqLlan07um0BFrZvLFjUs=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-557-GGEv9uX7OYuYbYuEephAOg-1; Wed, 21 Jul 2021 11:28:11 -0400
X-MC-Unique: GGEv9uX7OYuYbYuEephAOg-1
Received: by mail-il1-f199.google.com with SMTP id
 a13-20020a92c54d0000b0290216ae9088ffso1787820ilj.9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Jul 2021 08:28:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=FdvVljLxaRoKu02p/XKHt8pLC1+aQhmZqpHxlBYeaQA=;
 b=j1Zj/fGcT61sl5a7hG9wP77m3luvxCeSVb0pUATTLwBeky8OlCUqQ8JSxEY8maixRQ
 4qbG37bxj6Kh45bLJ0rFI7yhwbYU4SOKzR2kbdwvjrdSn1Uh1Ab4A0Dmy6HasiuWhPfv
 PoJvg5Na6x8wiaFwZDD6IYSj/L0+X2vj1+0SydYKnCVuovB72jmG+ATnaqgJHm+LV2CA
 w29k4sMhlvawWYeo0kIzKlthmKKZtnNrr8cRw2eWDldo9fwXnyVcJzfqqCGK8pmNQHWt
 /3xwNaa8pBO1/lzKfRD3K+HvvkmLk2xmIT0+hIFdcfFCpv8J1FMjx5vR6oLN8a7mjWaF
 mDPA==
X-Gm-Message-State: AOAM533/1B6eJ9rV9nFYcxU3UQREAaHZPNsDDfdUvwWkJDUyCIUYQ3Jl
 lhUZ11HlNGv7VY4bDGQniTpTMyBbvC5cMUTTVCHbGKY94p2EnG0e6eksSu4ztb6UXZdUmb70sPw
 8enMUvFrgvkNaWLXqtVtOOukH
X-Received: by 2002:a02:cf31:: with SMTP id s17mr31776937jar.46.1626881291060; 
 Wed, 21 Jul 2021 08:28:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyXsUlUSfaaSu/VgVW9B0i+z/O7lclfXTzWxt6V521RZmWaIu4pVkdUyLATZI2zGAntaYUAnw==
X-Received: by 2002:a02:cf31:: with SMTP id s17mr31776920jar.46.1626881290789; 
 Wed, 21 Jul 2021 08:28:10 -0700 (PDT)
Received: from gator ([140.82.166.162])
 by smtp.gmail.com with ESMTPSA id k4sm1848796ilu.67.2021.07.21.08.28.09
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 21 Jul 2021 08:28:10 -0700 (PDT)
Date: Wed, 21 Jul 2021 17:28:08 +0200
From: Andrew Jones <drjones@redhat.com>
To: Oliver Upton <oupton@google.com>
Subject: Re: [PATCH v2 00/12] KVM: Add idempotent controls for migrating
 system counter state
Message-ID: <20210721152808.lsnphkl3urz6bu3v@gator>
References: <20210716212629.2232756-1-oupton@google.com>
MIME-Version: 1.0
In-Reply-To: <20210716212629.2232756-1-oupton@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Raghavendra Rao Anata <rananta@google.com>, Peter Shier <pshier@google.com>,
 Sean Christopherson <seanjc@google.com>, David Matlack <dmatlack@google.com>,
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

On Fri, Jul 16, 2021 at 09:26:17PM +0000, Oliver Upton wrote:
> KVM's current means of saving/restoring system counters is plagued with
> temporal issues. At least on ARM64 and x86, we migrate the guest's
> system counter by-value through the respective guest system register
> values (cntvct_el0, ia32_tsc). Restoring system counters by-value is
> brittle as the state is not idempotent: the host system counter is still
> oscillating between the attempted save and restore. Furthermore, VMMs
> may wish to transparently live migrate guest VMs, meaning that they
> include the elapsed time due to live migration blackout in the guest
> system counter view. The VMM thread could be preempted for any number of
> reasons (scheduler, L0 hypervisor under nested) between the time that
> it calculates the desired guest counter value and when KVM actually sets
> this counter state.
> 
> Despite the value-based interface that we present to userspace, KVM
> actually has idempotent guest controls by way of system counter offsets.
> We can avoid all of the issues associated with a value-based interface
> by abstracting these offset controls in new ioctls. This series
> introduces new vCPU device attributes to provide userspace access to the
> vCPU's system counter offset.
> 
> Patch 1 adopts Paolo's suggestion, augmenting the KVM_{GET,SET}_CLOCK
> ioctls to provide userspace with a (host_tsc, realtime) instant. This is
> essential for a VMM to perform precise migration of the guest's system
> counters.
> 
> Patches 2-3 add support for x86 by shoehorning the new controls into the
> pre-existing synchronization heuristics.
> 
> Patches 4-5 implement a test for the new additions to
> KVM_{GET,SET}_CLOCK.
> 
> Patches 6-7 implement at test for the tsc offset attribute introduced in
> patch 3.
> 
> Patch 8 adds a device attribute for the arm64 virtual counter-timer
> offset.
> 
> Patch 9 extends the test from patch 7 to cover the arm64 virtual
> counter-timer offset.
> 
> Patch 10 adds a device attribute for the arm64 physical counter-timer
> offset. Currently, this is implemented as a synthetic register, forcing
> the guest to trap to the host and emulating the offset in the fast exit
> path. Later down the line we will have hardware with FEAT_ECV, which
> allows the hypervisor to perform physical counter-timer offsetting in
> hardware (CNTPOFF_EL2).
> 
> Patch 11 extends the test from patch 7 to cover the arm64 physical
> counter-timer offset.
> 
> Patch 12 introduces a benchmark to measure the overhead of emulation in
> patch 10.
> 
> Physical counter benchmark
> --------------------------
> 
> The following data was collected by running 10000 iterations of the
> benchmark test from Patch 6 on an Ampere Mt. Jade reference server, A 2S
> machine with 2 80-core Ampere Altra SoCs. Measurements were collected
> for both VHE and nVHE operation using the `kvm-arm.mode=` command-line
> parameter.
> 
> nVHE
> ----
> 
> +--------------------+--------+---------+
> |       Metric       | Native | Trapped |
> +--------------------+--------+---------+
> | Average            | 54ns   | 148ns   |
> | Standard Deviation | 124ns  | 122ns   |
> | 95th Percentile    | 258ns  | 348ns   |
> +--------------------+--------+---------+
> 
> VHE
> ---
> 
> +--------------------+--------+---------+
> |       Metric       | Native | Trapped |
> +--------------------+--------+---------+
> | Average            | 53ns   | 152ns   |
> | Standard Deviation | 92ns   | 94ns    |
> | 95th Percentile    | 204ns  | 307ns   |
> +--------------------+--------+---------+
> 
> This series applies cleanly to the following commit:
> 
> 1889228d80fe ("KVM: selftests: smm_test: Test SMM enter from L2")
> 
> v1 -> v2:
>   - Reimplemented as vCPU device attributes instead of a distinct ioctl.
>   - Added the (realtime, host_tsc) instant support to
>     KVM_{GET,SET}_CLOCK
>   - Changed the arm64 implementation to broadcast counter offset values
>     to all vCPUs in a guest. This upholds the architectural expectations
>     of a consistent counter-timer across CPUs.
>   - Fixed a bug with traps in VHE mode. We now configure traps on every
>     transition into a guest to handle differing VMs (trapped, emulated).
>

Oops, I see there's a v3 of this series. I'll switch to reviewing that. I
think my comments / r-b's apply to that version as well though.

Thanks,
drew 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
