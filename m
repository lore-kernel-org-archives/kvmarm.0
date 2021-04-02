Return-Path: <SRS0=9BEn=I7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98168C433B4
	for <kvmarm@archiver.kernel.org>; Fri,  2 Apr 2021 09:20:39 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id ED72160FF3
	for <kvmarm@archiver.kernel.org>; Fri,  2 Apr 2021 09:20:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ED72160FF3
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5F6EF4B303;
	Fri,  2 Apr 2021 05:20:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ADTiqs-LcK-L; Fri,  2 Apr 2021 05:20:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 240844B2CF;
	Fri,  2 Apr 2021 05:20:37 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C8E4C4B722
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Apr 2021 20:57:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NMv4iw121dgi for <kvmarm@lists.cs.columbia.edu>;
 Thu,  1 Apr 2021 20:57:01 -0400 (EDT)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A2AB04B6D6
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Apr 2021 20:57:01 -0400 (EDT)
Received: by mail-yb1-f202.google.com with SMTP id f18so4724038ybq.3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 01 Apr 2021 17:57:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=reply-to:date:message-id:mime-version:subject:from:to:cc;
 bh=FViJNMuAQXVG92IcJ9ASyfw+gqYDqmookinTy4APMz8=;
 b=tM5HW6/xk4O5sMn2fgKiWu76aEhiiETLruJpg/eDqJDR4WtSvS9+XoKICGLJgo/aR9
 PHUygm3nt6Iyd9H+hRkE+aN2uWXSniHsrGAukhueCHEWKNiGLvDdvm/C35c51KL7qq/J
 fgt3utJuyw2N+OiFjKc36bNdeTZMCG2OXJjHEkQxFIqyXipTvjAOsKRQR3H93WpjXiTJ
 zZlKgCHu1/48AstcZ0TNb2v8J6l74NmyyCG68O3osE84/6JpVuFsdO2EgEGawRt1qn/R
 MTRQMS94V9rHBAev+i0CHpGE75U1N9vbPoIhstygJ3ud1d//b6oFND6DleWTsUfEpKQo
 REdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
 :from:to:cc;
 bh=FViJNMuAQXVG92IcJ9ASyfw+gqYDqmookinTy4APMz8=;
 b=fGVduGWJQmqUEMFkCmQsVdrGt3TB+O9Vzs2b8KaPOi2lWOBA9JXGLHxAczwpvgA0Pn
 S/KgRYJfd/Pxi2WL3Yhi8XYWr+RhWmurDTUBg/oEJT2JB/SfAYCb5awU/PC5A9erPrY/
 KawkZ99eopYTR5MH/kzlC4HKdaTbwLt+Y2I4b8jXifebYx4MSSKKQjKTP+sPzGt+ywLf
 KXKOsEeX1T3K3XMZY6mgNBfwdmT5u3RGeMNbHJ2oKAggpSOJuvDmzs+z6g99z47GnW65
 l9Uyk0daZDT7Y1zLTevy9Hpofw06N6xtbHOWwIsVW1aKUx3cwqLyHSxrrUgCnCsXO0tm
 2Tfg==
X-Gm-Message-State: AOAM532b0jy1sSee2Jmf/wt9VngcWB+QO5Z80mbwaqK2M8Awmitts/Oi
 b7G11o/UkWOHyM6gYJHjNoOyZvMf154=
X-Google-Smtp-Source: ABdhPJzX9kzo85wBh2DvMcR2Y9UxX/gVfIA/wY1qXyxNt7lm9J3jjA4HAyWrYbcDrQf6yDOm390BaT3pn8k=
X-Received: from seanjc798194.pdx.corp.google.com
 ([2620:15c:f:10:c0b4:8b8:bb34:6a56])
 (user=seanjc job=sendgmr) by 2002:a25:a187:: with SMTP id
 a7mr8464267ybi.377.1617325020964; 
 Thu, 01 Apr 2021 17:57:00 -0700 (PDT)
Date: Thu,  1 Apr 2021 17:56:48 -0700
Message-Id: <20210402005658.3024832-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.0.208.g409f899ff0-goog
Subject: [PATCH v2 00/10] KVM: Consolidate and optimize MMU notifiers
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>, 
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Paul Mackerras <paulus@ozlabs.org>, Paolo Bonzini <pbonzini@redhat.com>
X-Mailman-Approved-At: Fri, 02 Apr 2021 05:20:36 -0400
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Sean Christopherson <seanjc@google.com>, Joerg Roedel <joro@8bytes.org>,
 linux-mips@vger.kernel.org, kvm-ppc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Ben Gardon <bgardon@google.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 kvmarm@lists.cs.columbia.edu, Jim Mattson <jmattson@google.com>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
Reply-To: Sean Christopherson <seanjc@google.com>
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

The end goal of this series is to optimize the MMU notifiers to take
mmu_lock if and only if the notification is relevant to KVM, i.e. the hva
range overlaps a memslot.   Large VMs (hundreds of vCPUs) are very
sensitive to mmu_lock being taken for write at inopportune times, and
such VMs also tend to be "static", e.g. backed by HugeTLB with minimal
page shenanigans.  The vast majority of notifications for these VMs will
be spurious (for KVM), and eliding mmu_lock for spurious notifications
avoids an otherwise unacceptable disruption to the guest.

To get there without potentially degrading performance, e.g. due to
multiple memslot lookups, especially on non-x86 where the use cases are
largely unknown (from my perspective), first consolidate the MMU notifier
logic by moving the hva->gfn lookups into common KVM.

Based on kvm/queue, commit 5f986f748438 ("KVM: x86: dump_vmcs should
include the autoload/autostore MSR lists").

Well tested on Intel and AMD.  Compile tested for arm64, MIPS, PPC,
PPC e500, and s390.  Absolutely needs to be tested for real on non-x86,
I give it even odds that I introduced an off-by-one bug somewhere.

v2:
 - Drop the patches that have already been pushed to kvm/queue.
 - Drop two selftest changes that had snuck in via "git commit -a".
 - Add a patch to assert that mmu_notifier_count is elevated when
   .change_pte() runs. [Paolo]
 - Split out moving KVM_MMU_(UN)LOCK() to __kvm_handle_hva_range() to a
   separate patch.  Opted not to squash it with the introduction of the
   common hva walkers (patch 02), as that prevented sharing code between
   the old and new APIs. [Paolo]
 - Tweak the comment in kvm_vm_destroy() above the smashing of the new
   slots lock. [Paolo]
 - Make mmu_notifier_slots_lock unconditional to avoid #ifdefs. [Paolo]

v1:
 - https://lkml.kernel.org/r/20210326021957.1424875-1-seanjc@google.com

Sean Christopherson (10):
  KVM: Assert that notifier count is elevated in .change_pte()
  KVM: Move x86's MMU notifier memslot walkers to generic code
  KVM: arm64: Convert to the gfn-based MMU notifier callbacks
  KVM: MIPS/MMU: Convert to the gfn-based MMU notifier callbacks
  KVM: PPC: Convert to the gfn-based MMU notifier callbacks
  KVM: Kill off the old hva-based MMU notifier callbacks
  KVM: Move MMU notifier's mmu_lock acquisition into common helper
  KVM: Take mmu_lock when handling MMU notifier iff the hva hits a
    memslot
  KVM: Don't take mmu_lock for range invalidation unless necessary
  KVM: x86/mmu: Allow yielding during MMU notifier unmap/zap, if
    possible

 arch/arm64/kvm/mmu.c                   | 117 +++------
 arch/mips/kvm/mmu.c                    |  97 ++------
 arch/powerpc/include/asm/kvm_book3s.h  |  12 +-
 arch/powerpc/include/asm/kvm_ppc.h     |   9 +-
 arch/powerpc/kvm/book3s.c              |  18 +-
 arch/powerpc/kvm/book3s.h              |  10 +-
 arch/powerpc/kvm/book3s_64_mmu_hv.c    |  98 ++------
 arch/powerpc/kvm/book3s_64_mmu_radix.c |  25 +-
 arch/powerpc/kvm/book3s_hv.c           |  12 +-
 arch/powerpc/kvm/book3s_pr.c           |  56 ++---
 arch/powerpc/kvm/e500_mmu_host.c       |  27 +-
 arch/x86/kvm/mmu/mmu.c                 | 127 ++++------
 arch/x86/kvm/mmu/tdp_mmu.c             | 245 +++++++------------
 arch/x86/kvm/mmu/tdp_mmu.h             |  14 +-
 include/linux/kvm_host.h               |  22 +-
 virt/kvm/kvm_main.c                    | 325 +++++++++++++++++++------
 16 files changed, 552 insertions(+), 662 deletions(-)

-- 
2.31.0.208.g409f899ff0-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
