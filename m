Return-Path: <SRS0=1TKy=LD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B021BC48BCF
	for <kvmarm@archiver.kernel.org>; Wed,  9 Jun 2021 13:06:09 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1ADF9613B6
	for <kvmarm@archiver.kernel.org>; Wed,  9 Jun 2021 13:06:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1ADF9613B6
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8955340256;
	Wed,  9 Jun 2021 09:06:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id T8VKwNt5AI6F; Wed,  9 Jun 2021 09:06:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BB3CF40878;
	Wed,  9 Jun 2021 09:06:06 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D564C40256
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Jun 2021 09:06:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aApiyoH0ussl for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Jun 2021 09:06:03 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3C17A401A4
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Jun 2021 09:06:03 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1623243963;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=tfZIA1RD1LZXKSjC7tQzyT3Zz4AbIitiVu33W8QcHZc=;
 b=fX7rM4TGyb/E+MVPcNfiH3vv5gEU2cdZfHDuy9zeBSVP9GgsI88zc8JMSTq8eg5F+hgvIZ
 7iBCcwjski2L426w3STbkrbaV2CWc1EOJxjqtNTKL0M+2hQ4ICxJ+BLsq48cKpVIC0QiR7
 sAjgoweMQGPWliwB0AMr8U1/aIM6VuY=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-268-ZI4VAJkOPxSKAY-cc27cKg-1; Wed, 09 Jun 2021 09:06:00 -0400
X-MC-Unique: ZI4VAJkOPxSKAY-cc27cKg-1
Received: by mail-wr1-f71.google.com with SMTP id
 v15-20020a5d4a4f0000b0290118dc518878so10797477wrs.6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 09 Jun 2021 06:06:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:to:cc:references:from:subject:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=tfZIA1RD1LZXKSjC7tQzyT3Zz4AbIitiVu33W8QcHZc=;
 b=bY/gh038i0EwX+VWQVQvTOYox9LxGFOgXBulqeG0plWEW2++X5RTtMuFlBZ2ZFZW2O
 KA3S9CTNBovh6M8cm7bbbhKb9q23aMFSdKYWSGGo471uK3C8zUIfxNPeXkDbIHSB8/O4
 SJjzrR7HLhXnRF5B2N/k99XICqkOAqM0Od207AMdrRYvyvZizXzpD69LhGYAr+Id3sDX
 fPDzopqWpFr+rgIbLvLuIKS6AuyT9L5SS+4GTMIvv3tjxH/h+1jr6W+hB/isP8EYig6G
 Q+rbtmR92XwJaLiHXvqp95ZitiE1zPUAtQ/SuAHmKidtOYNv6Vkn+iqPAKQKh35Ot5L6
 ge/w==
X-Gm-Message-State: AOAM5328mAx+ecveiH6u6dq9IOgpka4hn5uLBf38WzizkFueJAkGf92s
 Aory979NyxcS5Di1KA0AQAsZcKY9x41tmzDMgpeFJSOWFw8krGwD9Gi7kbKRxTcWOsShfm2Tv3o
 d8ijaEM03i1Uzxxv+F3faGv71
X-Received: by 2002:a05:6000:229:: with SMTP id
 l9mr21895565wrz.43.1623243959343; 
 Wed, 09 Jun 2021 06:05:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzNZpCmexeTYepugYVxKtIrw/V4KZhj0zKnSQiqFCM66i0gzUTV95CdITRYDyNRJ2IA3nAI+w==
X-Received: by 2002:a05:6000:229:: with SMTP id
 l9mr21895527wrz.43.1623243959126; 
 Wed, 09 Jun 2021 06:05:59 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id z11sm22741484wrs.7.2021.06.09.06.05.57
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 09 Jun 2021 06:05:58 -0700 (PDT)
To: Oliver Upton <oupton@google.com>, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, Maxim Levitsky <mlevitsk@redhat.com>
References: <20210608214742.1897483-1-oupton@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 00/10] KVM: Add idempotent controls for migrating system
 counter state
Message-ID: <63db3823-b8a3-578d-4baa-146104bb977f@redhat.com>
Date: Wed, 9 Jun 2021 15:05:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210608214742.1897483-1-oupton@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Sean Christopherson <seanjc@google.com>,
 Raghavendra Rao Anata <rananta@google.com>, Peter Shier <pshier@google.com>,
 Marc Zyngier <maz@kernel.org>, David Matlack <dmatlack@google.com>,
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

On 08/06/21 23:47, Oliver Upton wrote:
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
> introduces KVM_{GET,SET}_SYSTEM_COUNTER_STATE ioctls, meant to provide
> userspace with idempotent controls of the guest system counter.

Hi Oliver,

I wonder how this compares to the idea of initializing the TSC via a 
synchronized (nanoseconds, TSC) pair. 
(https://lore.kernel.org/r/20201130133559.233242-2-mlevitsk@redhat.com), 
and whether it makes sense to apply that idea to ARM as well.  If so, it 
certainly is a good idea to use the same capability and ioctl, even 
though the details of the struct would be architecture-dependent.

In your patches there isn't much architecture dependency in struct 
kvm_system_counter_state.  However,  Maxim's also added an 
MSR_IA32_TSC_ADJUST value to the struct, thus ensuring that the host 
could write not just an arbitrary TSC value, but also tie it to an 
arbitrary MSR_IA32_TSC_ADJUST value.  Specifying both in the same ioctl 
simplifies the userspace API.

Paolo

> Patch 1 defines the ioctls, and was separated from the two provided
> implementations for the sake of review. If it is more intuitive, this
> patch can be squashed into the implementation commit.
> 
> Patch 2 realizes initial support for ARM64, migrating only the state
> associated with the guest's virtual counter-timer. Patch 3 introduces a
> KVM selftest to assert that userspace manipulation via the
> aforementioned ioctls produces the expected system counter values within
> the guest.
> 
> Patch 4 extends upon the ARM64 implementation by adding support for
> physical counter-timer offsetting. This is currently backed by a
> trap-and-emulate implementation, but can also be virtualized in hardware
> that fully implements ARMv8.6-ECV. ECV support has been elided from this
> series out of convenience for the author :) Patch 5 adds some test cases
> to the newly-minted kvm selftest to validate expectations of physical
> counter-timer emulation.
> 
> Patch 6 introduces yet another KVM selftest for aarch64, intended to
> measure the effects of physical counter-timer emulation. Data for this
> test can be found below, but basically there is some tradeoff of
> overhead for the sake of correctness, but it isn't too bad.
> 
> Patches 7-8 add support for the ioctls to x86 by shoehorning the
> controls into the pre-existing synchronization heuristics. Patch 7
> provides necessary helper methods for the implementation to play nice
> with those heuristics, and patch 8 actually implements the ioctls.
> 
> Patch 9 adds x86 test cases to the system counter KVM selftest. Lastly,
> patch 10 documents the ioctls for both x86 and arm64.
> 
> All patches apply cleanly to kvm/next at the following commit:
> 
> a4345a7cecfb ("Merge tag 'kvmarm-fixes-5.13-1' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD")
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
> Oliver Upton (10):
>    KVM: Introduce KVM_{GET,SET}_SYSTEM_COUNTER_STATE ioctls
>    KVM: arm64: Implement initial support for KVM_CAP_SYSTEM_COUNTER_STATE
>    selftests: KVM: Introduce system_counter_state_test
>    KVM: arm64: Add userspace control of the guest's physical counter
>    selftests: KVM: Add test cases for physical counter offsetting
>    selftests: KVM: Add counter emulation benchmark
>    KVM: x86: Refactor tsc synchronization code
>    KVM: x86: Implement KVM_CAP_SYSTEM_COUNTER_STATE
>    selftests: KVM: Add support for x86 to system_counter_state_test
>    Documentation: KVM: Document KVM_{GET,SET}_SYSTEM_COUNTER_STATE ioctls
> 
>   Documentation/virt/kvm/api.rst                |  98 +++++++
>   Documentation/virt/kvm/locking.rst            |  11 +
>   arch/arm64/include/asm/kvm_host.h             |   6 +
>   arch/arm64/include/asm/sysreg.h               |   1 +
>   arch/arm64/include/uapi/asm/kvm.h             |  17 ++
>   arch/arm64/kvm/arch_timer.c                   |  84 +++++-
>   arch/arm64/kvm/arm.c                          |  25 ++
>   arch/arm64/kvm/hyp/include/hyp/switch.h       |  31 +++
>   arch/arm64/kvm/hyp/nvhe/timer-sr.c            |  16 +-
>   arch/x86/include/asm/kvm_host.h               |   1 +
>   arch/x86/include/uapi/asm/kvm.h               |   8 +
>   arch/x86/kvm/x86.c                            | 176 +++++++++---
>   include/uapi/linux/kvm.h                      |   5 +
>   tools/testing/selftests/kvm/.gitignore        |   2 +
>   tools/testing/selftests/kvm/Makefile          |   3 +
>   .../kvm/aarch64/counter_emulation_benchmark.c | 209 ++++++++++++++
>   .../selftests/kvm/include/aarch64/processor.h |  24 ++
>   .../selftests/kvm/system_counter_state_test.c | 256 ++++++++++++++++++
>   18 files changed, 926 insertions(+), 47 deletions(-)
>   create mode 100644 tools/testing/selftests/kvm/aarch64/counter_emulation_benchmark.c
>   create mode 100644 tools/testing/selftests/kvm/system_counter_state_test.c
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
