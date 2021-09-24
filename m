Return-Path: <SRS0=7V6P=OO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15843C433EF
	for <kvmarm@archiver.kernel.org>; Fri, 24 Sep 2021 16:43:31 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 710D1610D1
	for <kvmarm@archiver.kernel.org>; Fri, 24 Sep 2021 16:43:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 710D1610D1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0239F4AC78;
	Fri, 24 Sep 2021 12:43:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vaYhDtAHB75h; Fri, 24 Sep 2021 12:43:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9F68D4B08D;
	Fri, 24 Sep 2021 12:43:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1AEDE4B086
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 12:43:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8qYUvR+DuACy for <kvmarm@lists.cs.columbia.edu>;
 Fri, 24 Sep 2021 12:43:26 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F3BD44AC78
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 12:43:25 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1632501805;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=Xrd9wID+O6lXydA/auUdyoLz8h/dNJ6woqTmdu062kc=;
 b=Jnx3hbkaA34G/FRK4jiDkbOpHMMxs2dOFq/Y8+pxhMfMGzgm+/CEcCpL2UgoTKkVilY/nY
 lejcTMyVmjJy7HmBquCQsDQ0YTH2CNnstMTz1eqOJNe+y8081CB6n6BmxPAnaCN33Hfizc
 9UQ++0N2JdJ6Gg86D2zA5jsRf8ZwXRs=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-584-axArCNxONKS9LUSNlM8TYA-1; Fri, 24 Sep 2021 12:43:24 -0400
X-MC-Unique: axArCNxONKS9LUSNlM8TYA-1
Received: by mail-ed1-f69.google.com with SMTP id
 h6-20020a50c386000000b003da01adc065so10847466edf.7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 09:43:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=Xrd9wID+O6lXydA/auUdyoLz8h/dNJ6woqTmdu062kc=;
 b=4c9EHQ/QNuI7CgSQ4YEaLHMuxXJsX5i4USTtTOObkRkiCLQPfqEYW9PLr9XpEZ0z3L
 zRPB+rRotsFJQ0PNKLD9fBFfrF+9FytXJDvkJuNtO5IbOhiQy/OjGk9jCHgiUiGjEo01
 s8jacwGm5TX90jOnXI9CfjxN1Mk+Cth0mEjGTqAJVA9cQyYt11ctl2zSXTLADr93+WO1
 NOsDR7f41Q4n5WQEKHM68ZOKYVMd8+bkK8ykdtrhxUVec0ElomDMjC9Ghq7iWENDvLSP
 GToSLSbR/xo011PHrP4FmmW2PkuH0yHDO8AXhSb23mHaJn3qOPKHX4QNZHfLrkdt7MiS
 pLiA==
X-Gm-Message-State: AOAM533Y+YzhuTjDT+93QYz8UPc0cDTwVRL4lOFVv4MIaOHBUrRzVngn
 SKLKgfZ75JD+aA/74T/fbz8Etdg1V++TAgyMFnKxWCqy/32pX2pNHyrXC8f7m4G1Lab5AvHd6eQ
 YF6VrxVb/72aA6hf2uvPVbEf0
X-Received: by 2002:a17:906:32c9:: with SMTP id
 k9mr12526946ejk.218.1632501803387; 
 Fri, 24 Sep 2021 09:43:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJycJysgKh7IfROIXy7X+AKIfF9Ahyp8Cqy6RCpIsmYlwjlA3xpaOkwlN4ADHD6VhHck9ohNyA==
X-Received: by 2002:a17:906:32c9:: with SMTP id
 k9mr12526912ejk.218.1632501803170; 
 Fri, 24 Sep 2021 09:43:23 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id x7sm6009332ede.86.2021.09.24.09.43.19
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 24 Sep 2021 09:43:22 -0700 (PDT)
Message-ID: <bceb41e9-164e-0a84-5205-daef58e13097@redhat.com>
Date: Fri, 24 Sep 2021 18:43:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v8 0/7] KVM: x86: Add idempotent controls for migrating
 system counter state
To: Oliver Upton <oupton@google.com>, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu
References: <20210916181538.968978-1-oupton@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20210916181538.968978-1-oupton@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Peter Shier <pshier@google.com>, Marc Zyngier <maz@kernel.org>,
 David Matlack <dmatlack@google.com>, linux-arm-kernel@lists.infradead.org,
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

On 16/09/21 20:15, Oliver Upton wrote:
> KVM's current means of saving/restoring system counters is plagued with
> temporal issues. On x86, we migrate the guest's system counter by-value
> through the respective guest's IA32_TSC value. Restoring system counters
> by-value is brittle as the state is not idempotent: the host system
> counter is still oscillating between the attempted save and restore.
> Furthermore, VMMs may wish to transparently live migrate guest VMs,
> meaning that they include the elapsed time due to live migration blackout
> in the guest system counter view. The VMM thread could be preempted for
> any number of reasons (scheduler, L0 hypervisor under nested) between the
> time that it calculates the desired guest counter value and when
> KVM actually sets this counter state.
> 
> Despite the value-based interface that we present to userspace, KVM
> actually has idempotent guest controls by way of the TSC offset.
> We can avoid all of the issues associated with a value-based interface
> by abstracting these offset controls in a new device attribute. This
> series introduces new vCPU device attributes to provide userspace access
> to the vCPU's system counter offset.
> 
> Patches 1-2 are Paolo's refactorings around locking and the
> KVM_{GET,SET}_CLOCK ioctls.
> 
> Patch 3 cures a race where use_master_clock is read outside of the
> pvclock lock in the KVM_GET_CLOCK ioctl.
> 
> Patch 4 adopts Paolo's suggestion, augmenting the KVM_{GET,SET}_CLOCK
> ioctls to provide userspace with a (host_tsc, realtime) instant. This is
> essential for a VMM to perform precise migration of the guest's system
> counters.
> 
> Patch 5 does away with the pvclock spin lock in favor of a sequence
> lock based on the tsc_write_lock. The original patch is from Paolo, I
> touched it up a bit to fix a deadlock and some unused variables that
> caused -Werror to scream.
> 
> Patch 6 extracts the TSC synchronization tracking code in a way that it
> can be used for both offset-based and value-based TSC synchronization
> schemes.
> 
> Finally, patch 7 implements a vCPU device attribute which allows VMMs to
> get at the TSC offset of a vCPU.
> 
> This series was tested with the new KVM selftests for the KVM clock and
> system counter offset controls on Haswell hardware. Kernel was built
> with CONFIG_LOCKDEP given the new locking changes/lockdep assertions
> here.
> 
> Note that these tests are mailed as a separate series due to the
> dependencies in both x86 and arm64.
> 
> Applies cleanly to 5.15-rc1
> 
> v8: http://lore.kernel.org/r/20210816001130.3059564-1-oupton@google.com
> 
> v7 -> v8:
>   - Rebased to 5.15-rc1
>   - Picked up Paolo's version of the series, which includes locking
>     changes
>   - Make KVM advertise KVM_CAP_VCPU_ATTRIBUTES
> 
> Oliver Upton (4):
>    KVM: x86: Fix potential race in KVM_GET_CLOCK
>    KVM: x86: Report host tsc and realtime values in KVM_GET_CLOCK
>    KVM: x86: Refactor tsc synchronization code
>    KVM: x86: Expose TSC offset controls to userspace
> 
> Paolo Bonzini (3):
>    kvm: x86: abstract locking around pvclock_update_vm_gtod_copy
>    KVM: x86: extract KVM_GET_CLOCK/KVM_SET_CLOCK to separate functions
>    kvm: x86: protect masterclock with a seqcount
> 
>   Documentation/virt/kvm/api.rst          |  42 ++-
>   Documentation/virt/kvm/devices/vcpu.rst |  57 +++
>   arch/x86/include/asm/kvm_host.h         |  12 +-
>   arch/x86/include/uapi/asm/kvm.h         |   4 +
>   arch/x86/kvm/x86.c                      | 458 ++++++++++++++++--------
>   include/uapi/linux/kvm.h                |   7 +-
>   6 files changed, 419 insertions(+), 161 deletions(-)
> 

Queued, thanks.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
