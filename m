Return-Path: <SRS0=9BEn=I7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92A21C43462
	for <kvmarm@archiver.kernel.org>; Fri,  2 Apr 2021 12:17:55 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E445B61158
	for <kvmarm@archiver.kernel.org>; Fri,  2 Apr 2021 12:17:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E445B61158
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4AAAF4B28D;
	Fri,  2 Apr 2021 08:17:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dGdL4q8Q9xzQ; Fri,  2 Apr 2021 08:17:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 001644B2E4;
	Fri,  2 Apr 2021 08:17:52 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 37BAF4B273
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Apr 2021 08:17:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mcjQgGi4EX-K for <kvmarm@lists.cs.columbia.edu>;
 Fri,  2 Apr 2021 08:17:51 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 166824B25B
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Apr 2021 08:17:51 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1617365870;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=Muwx+qawsLcE0Xkj8kzlIVuDAwSyy9qsNyKVPtLvlps=;
 b=HZSAyiwAUqB52KGI0S8JoX9rhjlNj2PlC8kb2tysRAKr2y5AEQ6DR2nMx+VwAPTfikc6hG
 19ssD2UVmV1m8B0XoKnMpLw2KzRO0SHNZmBWTCtXa6G739mUWjyvV72CZv9V5BeLOiv1Ij
 RCAPXJSxdHEHL70qBIry8+eXleMSFJE=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-61-ctcJN_TnPPmwE7IXohx61Q-1; Fri, 02 Apr 2021 08:17:49 -0400
X-MC-Unique: ctcJN_TnPPmwE7IXohx61Q-1
Received: by mail-wr1-f70.google.com with SMTP id z17so4273057wrv.23
 for <kvmarm@lists.cs.columbia.edu>; Fri, 02 Apr 2021 05:17:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=Muwx+qawsLcE0Xkj8kzlIVuDAwSyy9qsNyKVPtLvlps=;
 b=r5Xw5FYa5U5/yVwBdi4TcmxN6RhTG63ExZVsM9JHKpJ3jwe5bKQV4YLmlqjJlhXnNt
 EC6QEQYyxdNqNuRmQm2okN0rbn8Nf6pM2YklcJPecVp/0c7o/u4Ycs2x8mamXKHFB5SB
 hRTkbmCcdTFLAnje78HckESZ5AJXlF8VjYaGUp9upoU0X9A4Lpw9b/5oyD2vFHk9QmPz
 8kDulpDgTuARiMLp44U8g6ETfsMndCNjh6zxcb60n9lC/Owi5F4lDbpX5vT47dO/++On
 HURZtnIrGE4VKgOSK/Xq2yB1odCcoeRTWDAm+LqPIl4RFLtdu7rycJ8tKncmo9RnKBht
 PQ9Q==
X-Gm-Message-State: AOAM533QaDpw0U6pums3+1bLb/au0Fsc1soV7l65P1ueU0P1HgMReeZL
 /+TX5zGAZ/9wR46bktw9dgpJFKTMtsXOKjrwbkJv7Ok2VuEFV+m/6BNSMEQeaSO5zOWV9vbvbxc
 rACh1gI5KSk8nMIBU650XDCHl
X-Received: by 2002:a05:6000:362:: with SMTP id
 f2mr15172715wrf.141.1617365868280; 
 Fri, 02 Apr 2021 05:17:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzLaJxTI8QPBvKFmAdjnuuObyL8/ENWh8opXUP0PYyDWSCUQKuWQD6mlne9MO5n6MrTzGeeiQ==
X-Received: by 2002:a05:6000:362:: with SMTP id
 f2mr15172680wrf.141.1617365868029; 
 Fri, 02 Apr 2021 05:17:48 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e?
 ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
 by smtp.gmail.com with ESMTPSA id n9sm14323662wrx.46.2021.04.02.05.17.46
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 02 Apr 2021 05:17:47 -0700 (PDT)
Subject: Re: [PATCH v2 00/10] KVM: Consolidate and optimize MMU notifiers
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Paul Mackerras <paulus@ozlabs.org>
References: <20210402005658.3024832-1-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <9376b453-be3a-f8b7-d53a-7e54c25161ce@redhat.com>
Date: Fri, 2 Apr 2021 14:17:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210402005658.3024832-1-seanjc@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Joerg Roedel <joro@8bytes.org>, linux-mips@vger.kernel.org,
 kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, Ben Gardon <bgardon@google.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, kvmarm@lists.cs.columbia.edu,
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

On 02/04/21 02:56, Sean Christopherson wrote:
> The end goal of this series is to optimize the MMU notifiers to take
> mmu_lock if and only if the notification is relevant to KVM, i.e. the hva
> range overlaps a memslot.   Large VMs (hundreds of vCPUs) are very
> sensitive to mmu_lock being taken for write at inopportune times, and
> such VMs also tend to be "static", e.g. backed by HugeTLB with minimal
> page shenanigans.  The vast majority of notifications for these VMs will
> be spurious (for KVM), and eliding mmu_lock for spurious notifications
> avoids an otherwise unacceptable disruption to the guest.
> 
> To get there without potentially degrading performance, e.g. due to
> multiple memslot lookups, especially on non-x86 where the use cases are
> largely unknown (from my perspective), first consolidate the MMU notifier
> logic by moving the hva->gfn lookups into common KVM.
> 
> Based on kvm/queue, commit 5f986f748438 ("KVM: x86: dump_vmcs should
> include the autoload/autostore MSR lists").
> 
> Well tested on Intel and AMD.  Compile tested for arm64, MIPS, PPC,
> PPC e500, and s390.  Absolutely needs to be tested for real on non-x86,
> I give it even odds that I introduced an off-by-one bug somewhere.
> 
> v2:
>   - Drop the patches that have already been pushed to kvm/queue.
>   - Drop two selftest changes that had snuck in via "git commit -a".
>   - Add a patch to assert that mmu_notifier_count is elevated when
>     .change_pte() runs. [Paolo]
>   - Split out moving KVM_MMU_(UN)LOCK() to __kvm_handle_hva_range() to a
>     separate patch.  Opted not to squash it with the introduction of the
>     common hva walkers (patch 02), as that prevented sharing code between
>     the old and new APIs. [Paolo]
>   - Tweak the comment in kvm_vm_destroy() above the smashing of the new
>     slots lock. [Paolo]
>   - Make mmu_notifier_slots_lock unconditional to avoid #ifdefs. [Paolo]
> 
> v1:
>   - https://lkml.kernel.org/r/20210326021957.1424875-1-seanjc@google.com
> 
> Sean Christopherson (10):
>    KVM: Assert that notifier count is elevated in .change_pte()
>    KVM: Move x86's MMU notifier memslot walkers to generic code
>    KVM: arm64: Convert to the gfn-based MMU notifier callbacks
>    KVM: MIPS/MMU: Convert to the gfn-based MMU notifier callbacks
>    KVM: PPC: Convert to the gfn-based MMU notifier callbacks
>    KVM: Kill off the old hva-based MMU notifier callbacks
>    KVM: Move MMU notifier's mmu_lock acquisition into common helper
>    KVM: Take mmu_lock when handling MMU notifier iff the hva hits a
>      memslot
>    KVM: Don't take mmu_lock for range invalidation unless necessary
>    KVM: x86/mmu: Allow yielding during MMU notifier unmap/zap, if
>      possible
> 
>   arch/arm64/kvm/mmu.c                   | 117 +++------
>   arch/mips/kvm/mmu.c                    |  97 ++------
>   arch/powerpc/include/asm/kvm_book3s.h  |  12 +-
>   arch/powerpc/include/asm/kvm_ppc.h     |   9 +-
>   arch/powerpc/kvm/book3s.c              |  18 +-
>   arch/powerpc/kvm/book3s.h              |  10 +-
>   arch/powerpc/kvm/book3s_64_mmu_hv.c    |  98 ++------
>   arch/powerpc/kvm/book3s_64_mmu_radix.c |  25 +-
>   arch/powerpc/kvm/book3s_hv.c           |  12 +-
>   arch/powerpc/kvm/book3s_pr.c           |  56 ++---
>   arch/powerpc/kvm/e500_mmu_host.c       |  27 +-
>   arch/x86/kvm/mmu/mmu.c                 | 127 ++++------
>   arch/x86/kvm/mmu/tdp_mmu.c             | 245 +++++++------------
>   arch/x86/kvm/mmu/tdp_mmu.h             |  14 +-
>   include/linux/kvm_host.h               |  22 +-
>   virt/kvm/kvm_main.c                    | 325 +++++++++++++++++++------
>   16 files changed, 552 insertions(+), 662 deletions(-)
> 

For MIPS, I am going to post a series that simplifies TLB flushing 
further.  I applied it, and rebased this one on top, to 
kvm/mmu-notifier-queue.

Architecture maintainers, please look at the branch and review/test/ack 
your parts.

Thanks!

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
