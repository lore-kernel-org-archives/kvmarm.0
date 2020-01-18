Return-Path: <SRS0=0pJY=3H=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38638C33CB6
	for <kvmarm@archiver.kernel.org>; Sat, 18 Jan 2020 20:01:16 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A99A624695
	for <kvmarm@archiver.kernel.org>; Sat, 18 Jan 2020 20:01:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OYyDtusp"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A99A624695
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CDA714AF22;
	Sat, 18 Jan 2020 15:01:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id iYwYq+s8+x7p; Sat, 18 Jan 2020 15:01:13 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 434C54AF23;
	Sat, 18 Jan 2020 15:01:13 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D475C4AF23
 for <kvmarm@lists.cs.columbia.edu>; Sat, 18 Jan 2020 15:01:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lwXAobExAamS for <kvmarm@lists.cs.columbia.edu>;
 Sat, 18 Jan 2020 15:01:10 -0500 (EST)
Received: from us-smtp-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [205.139.110.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 978034AF22
 for <kvmarm@lists.cs.columbia.edu>; Sat, 18 Jan 2020 15:01:10 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1579377670;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=GhV5VFuQrQc9r/3XEQ6PGMYgwgxMdO2z2+l/Tu57i24=;
 b=OYyDtusppg9jM0lx6VZbn9cRv7ZcKfHQnGK9SOCwmT/JHb1XM2vhTi0VbTu6McMKY+8cYM
 qBnZXvaZk7mnVyhT2sbiptAdnOjL8N8RqssY3sE7I61pqaSOQPUxnU+9uFmENOW9y1oPCE
 0lm0EnoePIiQgllkpl0XWZ8Ph+0vLqE=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-360-7KCQju1HOTybtugqKqtZ-w-1; Sat, 18 Jan 2020 15:01:07 -0500
Received: by mail-wr1-f70.google.com with SMTP id k18so12115571wrw.9
 for <kvmarm@lists.cs.columbia.edu>; Sat, 18 Jan 2020 12:01:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=GhV5VFuQrQc9r/3XEQ6PGMYgwgxMdO2z2+l/Tu57i24=;
 b=qyqssH3uouQvCDKitm9hPPm0COABJle7CR5OzUyjlAmUvi6Ou970CnmWrc5qv5v7df
 N3TtE4sQsSxAbSBlSLvZkWKijwhLHPXJZ3EjsnXpQL9ivr///FfCjAP5/VKia82S0zK/
 HGOqnsxNBQb400fE74wvkqC8IPQ3y+draqwNdzzLbtlZv+dxmOL03lc7PTk3PvZ2Aht+
 DqkQHdYoi5u6DSjIxDNKK3PZ6eBhj68ly3u8y1LTYEcowzfHVK6FLXqzPM7lIeKJq4QL
 mhwS+LK/6B5o8fm3b1zZlof6uB9xrvrGw+Lg0A9isZ3XzSGQx9JPmTDHpEy20lSXB5kS
 XChw==
X-Gm-Message-State: APjAAAWh7gfd0DP0LJj0eYc1U1eK/VDeIRJuUsF9uUjPiW8dGoLbExX1
 kzX5bV5vGxI8Dd51rM1PEJzDxUW7XzeN8S8iTZZnu6OzUbHPGI8oIxxj2FLUEtMLC8/VdRjbHkV
 nAkyd+P3v4uFvCSlsFo094oek
X-Received: by 2002:adf:b60f:: with SMTP id f15mr10168429wre.372.1579377666356; 
 Sat, 18 Jan 2020 12:01:06 -0800 (PST)
X-Google-Smtp-Source: APXvYqyiRC3IqnoQxBsM17Oy6gnYbiWwmQOp2vlMdwOkISyap6ZIXyi3L1uJMx7IGcuKnNuVMBYAvQ==
X-Received: by 2002:adf:b60f:: with SMTP id f15mr10168402wre.372.1579377666048; 
 Sat, 18 Jan 2020 12:01:06 -0800 (PST)
Received: from [192.168.10.150] ([93.56.166.5])
 by smtp.gmail.com with ESMTPSA id v8sm38452671wrw.2.2020.01.18.12.01.04
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Sat, 18 Jan 2020 12:01:05 -0800 (PST)
Subject: Re: [PATCH v2 00/45] KVM: Refactor vCPU creation
To: Sean Christopherson <sean.j.christopherson@intel.com>,
 Marc Zyngier <maz@kernel.org>, James Hogan <jhogan@kernel.org>,
 Paul Mackerras <paulus@ozlabs.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>
References: <20191218215530.2280-1-sean.j.christopherson@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <3be0000b-3da9-3321-6e56-7dbb434ba764@redhat.com>
Date: Sat, 18 Jan 2020 21:01:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191218215530.2280-1-sean.j.christopherson@intel.com>
Content-Language: en-US
X-MC-Unique: 7KCQju1HOTybtugqKqtZ-w-1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, Joerg Roedel <joro@8bytes.org>,
 Cornelia Huck <cohuck@redhat.com>, linux-mips@vger.kernel.org,
 kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
 Greg Kurz <groug@kaod.org>, linux-arm-kernel@lists.infradead.org,
 Vitaly Kuznetsov <vkuznets@redhat.com>,
 David Gibson <david@gibson.dropbear.id.au>, kvmarm@lists.cs.columbia.edu,
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

Queued.  Paul, David, please test kvm/next in a couple days.

Paolo

On 18/12/19 22:54, Sean Christopherson wrote:
> The end goal of this series is to strip down the interface between common
> KVM code and arch specific code so that there is precisely one arch hook
> for creating a vCPU and one hook for destroying a vCPU.  In addition to
> cleaning up the code base, simplifying the interface gives architectures
> more freedom to organize their vCPU creation code.  Details below.
> 
> v2:
>   - Rebase to commit e41a90be9659 ("KVM: x86/mmu: WARN if root_hpa is
>     invalid when handling a page fault").  A few minor x86 (VMX) conflicts,
>     and one straightforward arm conflict with commit 8564d6372a7d ("KVM:
>     arm64: Support stolen time reporting via shared structure") in patch
>     "KVM: ARM: Move all vcpu init code into kvm_arch_vcpu_create()".
>   - Collect Reviews and Acks [Christoffer, Greg].
>   - Fix a warning in "KVM: arm64: Free sve_state via arm specific hook"
>     by using a "void" return type [Christoffer].
>   - Fix a bug in "KVM: PPC: Move kvm_vcpu_init() invocation to common code"
>     where the call in kvmppc_core_vcpu_create_e500mc() was inadvertantly
>     left behind.
> 
> 
> KVM's vCPU creation code is comically messy.  kvm_vm_ioctl_create_vcpu()
> calls three separate arch hooks: init(), create() and setup().  The init()
> call is especially nasty as it's hidden away in a common KVM function,
> kvm_init_vcpu(), that for all intents and purposes must be immediately
> invoked after the vcpu object is allocated.
> 
> Not to be outdone, vCPU destruction also has three arch hooks: uninit(),
> destroy() and free(), the latter of which isn't actually invoked by common
> KVM code, but the hook declaration still exists because architectures are
> relying on its forward declaration.
> 
> Eliminating the extra arch hooks is relatively straightforward, just
> tedious.  For the most part, there is no fundamental constraint that
> necessitated the proliferation of arch hooks, rather they crept in over
> time, usually when x86-centric code was moved out of generic KVM and into
> x86 code.
> 
> E.g. kvm_arch_vcpu_setup() was added to allow x86 to do vcpu_load(), which
> can only be done after preempt_notifier initialization, but adding setup()
> overlooked the fact that the preempt_notifier was only initialized after
> kvm_arch_vcpu_create() because preemption support was added when x86's MMU
> setup (the vcpu_load() user) was called from common KVM code.
> 
> For all intents and purposes, there is no true functional change in this
> series.  The order of some allocations will change, and a few memory leaks
> are fixed, but the actual functionality of a guest should be unaffected.
> 
> Patches 01-03 are bug fixes in error handling paths that were found by
> inspection when refactoring the associated code.
> 
> Patches 04-43 refactor each arch implementation so that the unwanted arch
> hooks can be dropped without a functional change, e.g. move code out of
> kvm_arch_vcpu_setup() so that all implementations are empty, then drop the
> functions and caller.
> 
> Patches 44-45 are minor clean up to eliminate kvm_vcpu_uninit().
> 
> The net result is to go from this:
> 
>         vcpu = kvm_arch_vcpu_create(kvm, id);
>                |
>                |-> kvm_vcpu_init()
>                    |
>                    |-> kvm_arch_vcpu_init()
> 
>         if (IS_ERR(vcpu)) {
>                 r = PTR_ERR(vcpu);
>                 goto vcpu_decrement;
>         }
> 
>         preempt_notifier_init(&vcpu->preempt_notifier, &kvm_preempt_ops);
> 
>         r = kvm_arch_vcpu_setup(vcpu);
>         if (r)
>                 goto vcpu_destroy;
> 
> 
> Sean Christopherson (45):
>   KVM: PPC: Book3S HV: Uninit vCPU if vcore creation fails
>   KVM: PPC: Book3S PR: Free shared page if mmu initialization fails
>   KVM: x86: Free wbinvd_dirty_mask if vCPU creation fails
>   KVM: VMX: Allocate VPID after initializing VCPU
>   KVM: VMX: Use direct vcpu pointer during vCPU create/free
>   KVM: SVM: Use direct vcpu pointer during vCPU create/free
>   KVM: x86: Allocate vcpu struct in common x86 code
>   KVM: x86: Move FPU allocation to common x86 code
>   KVM: x86: Move allocation of pio_data page down a few lines
>   KVM: x86: Move kvm_vcpu_init() invocation to common code
>   KVM: PPC: e500mc: Add build-time assert that vcpu is at offset 0
>   KVM: PPC: Allocate vcpu struct in common PPC code
>   KVM: PPC: Book3S PR: Allocate book3s and shadow vcpu after common init
>   KVM: PPC: e500mc: Move reset of oldpir below call to kvm_vcpu_init()
>   KVM: PPC: Move kvm_vcpu_init() invocation to common code
>   KVM: MIPS: Use kvm_vcpu_cache to allocate vCPUs
>   KVM: MIPS: Drop kvm_arch_vcpu_free()
>   KVM: PPC: Drop kvm_arch_vcpu_free()
>   KVM: arm: Drop kvm_arch_vcpu_free()
>   KVM: x86: Remove spurious kvm_mmu_unload() from vcpu destruction path
>   KVM: x86: Remove spurious clearing of async #PF MSR
>   KVM: x86: Drop kvm_arch_vcpu_free()
>   KVM: Remove kvm_arch_vcpu_free() declaration
>   KVM: Add kvm_arch_vcpu_precreate() to handle pre-allocation issues
>   KVM: s390: Move guts of kvm_arch_vcpu_init() into
>     kvm_arch_vcpu_create()
>   KVM: s390: Invoke kvm_vcpu_init() before allocating sie_page
>   KVM: MIPS: Invoke kvm_vcpu_uninit() immediately prior to freeing vcpu
>   KVM: x86: Invoke kvm_vcpu_uninit() immediately prior to freeing vcpu
>   KVM: Introduce kvm_vcpu_destroy()
>   KVM: Move vcpu alloc and init invocation to common code
>   KVM: Unexport kvm_vcpu_cache and kvm_vcpu_{un}init()
>   KVM: Move initialization of preempt notifier to kvm_vcpu_init()
>   KVM: x86: Move guts of kvm_arch_vcpu_setup() into
>     kvm_arch_vcpu_create()
>   KVM: MIPS: Move .vcpu_setup() call to kvm_arch_vcpu_create()
>   KVM: s390: Manually invoke vcpu setup during kvm_arch_vcpu_create()
>   KVM: PPC: BookE: Setup vcpu during kvmppc_core_vcpu_create()
>   KVM: Drop kvm_arch_vcpu_setup()
>   KVM: x86: Move all vcpu init code into kvm_arch_vcpu_create()
>   KVM: MIPS: Move all vcpu init code into kvm_arch_vcpu_create()
>   KVM: ARM: Move all vcpu init code into kvm_arch_vcpu_create()
>   KVM: PPC: Move all vcpu init code into kvm_arch_vcpu_create()
>   KVM: arm64: Free sve_state via arm specific hook
>   KVM: Drop kvm_arch_vcpu_init() and kvm_arch_vcpu_uninit()
>   KVM: Move putting of vcpu->pid to kvm_vcpu_destroy()
>   KVM: Move vcpu->run page allocation out of kvm_vcpu_init()
> 
>  arch/arm/include/asm/kvm_host.h    |   2 +-
>  arch/arm/kvm/guest.c               |   5 -
>  arch/arm64/include/asm/kvm_host.h  |   2 +-
>  arch/arm64/kvm/guest.c             |   5 -
>  arch/arm64/kvm/reset.c             |   2 +-
>  arch/mips/kvm/mips.c               |  84 ++++-------
>  arch/powerpc/include/asm/kvm_ppc.h |   6 +-
>  arch/powerpc/kvm/book3s.c          |   9 +-
>  arch/powerpc/kvm/book3s_hv.c       |  27 +---
>  arch/powerpc/kvm/book3s_pr.c       |  33 ++---
>  arch/powerpc/kvm/booke.c           |  65 ++++----
>  arch/powerpc/kvm/e500.c            |  34 +----
>  arch/powerpc/kvm/e500mc.c          |  28 +---
>  arch/powerpc/kvm/powerpc.c         |  70 ++++-----
>  arch/s390/include/asm/kvm_host.h   |   1 -
>  arch/s390/kvm/kvm-s390.c           | 110 +++++++-------
>  arch/x86/include/asm/kvm_host.h    |   2 +-
>  arch/x86/kvm/svm.c                 |  52 +------
>  arch/x86/kvm/vmx/vmx.c             |  72 +++------
>  arch/x86/kvm/x86.c                 | 230 ++++++++++++++---------------
>  include/linux/kvm_host.h           |  13 +-
>  virt/kvm/arm/arm.c                 |  80 ++++------
>  virt/kvm/kvm_main.c                |  71 +++++----
>  23 files changed, 385 insertions(+), 618 deletions(-)
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
