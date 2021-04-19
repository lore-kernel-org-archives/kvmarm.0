Return-Path: <SRS0=F21+=JQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C697C433B4
	for <kvmarm@archiver.kernel.org>; Mon, 19 Apr 2021 10:40:49 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0470161157
	for <kvmarm@archiver.kernel.org>; Mon, 19 Apr 2021 10:40:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0470161157
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 640ED4B501;
	Mon, 19 Apr 2021 06:40:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IWkNOfJQkwS7; Mon, 19 Apr 2021 06:40:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 70D464B3D6;
	Mon, 19 Apr 2021 06:40:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 628C34B34C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Apr 2021 04:49:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZwTGTkjjy755 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 19 Apr 2021 04:49:30 -0400 (EDT)
Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com
 [209.85.167.173])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 63A6F4B32D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Apr 2021 04:49:30 -0400 (EDT)
Received: by mail-oi1-f173.google.com with SMTP id k18so29802806oik.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Apr 2021 01:49:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=j08yIBwXLk5HTWZ6SAY1miLlwOHxJ1A2dFdxyi2DvcY=;
 b=ukeWmfzj4t9brWPWzsNE3efem5PCcXY6cXNQYcKhjpD9UkFz4br1NIN8f/JBbihNmc
 vYpUKm/Vr/B4dKqp2kH4f6bCVJejPqdAhqwyGlqZ+V5te749g4/JhajR6YKNGTZfHPE4
 9GAqcvd4JZc+6feJzwqc0YVM3+6G4G83pBQSCd2ZZ3rooz34mB/YLXy6ZS8PLGZh8Omx
 mFd0TiOioATJNxlJI2ajCidOxSN6ig9CoEKCLhG4SSrQkVZHB+uNTmYbGuntT3PFGI0J
 n+/n6yEnzHnvcEFp2rzTzc+KrdM8uac5ciHP738zzQ0p/eD208FmpVF7kZw4Z+kSIUDs
 cFJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=j08yIBwXLk5HTWZ6SAY1miLlwOHxJ1A2dFdxyi2DvcY=;
 b=Ty4qidKf2S+LRfy5GhPOr5tSYTM7sWGO36cC5uhTEeaS4Ugn7R0IMUqTUqvaJff+iI
 e3Xdo24LIMwsf2n37Mu1Uz5IUW4ADKdYuDIxenE6E5SWOGHTg+kWr5Sb4JE895L3VKQP
 lL3EoM2G/CQ8dm/mdiHEN05v0y7AIX/0JrMlDRqr7zY6jYPVSQ/QbHZCALFcyIxGf79q
 UuXQtLItqrPwytnwjotCsSaUuzaSLmhISM6sh+JNPdJsuLXezFZPlUqxzLrJa6IQCSPM
 tFhC03Yl3bYEV9XtTu2sFX8ddfIfim3cXCGZMpoHqVAjaG5971sPMP83FIHWeoV7LPlh
 ZzKg==
X-Gm-Message-State: AOAM532kDx0zqZfLbyLkyxqCndyMeyBHUbkHJZc5gGFV/XZGyAsoYDYA
 ZRGGcplTYMDTFc1gZaMQsuuH3oJaIOcmyw3uRoc=
X-Google-Smtp-Source: ABdhPJy8F5yRINkAPts04KIndUObakf6+CqY0t8sQ3XggJcJX4zD4FAEWgQI/Ot5FoTZGR5pMwoWgxTwQHjcY6LtqVc=
X-Received: by 2002:a05:6808:5c5:: with SMTP id
 d5mr15029122oij.141.1618822169834; 
 Mon, 19 Apr 2021 01:49:29 -0700 (PDT)
MIME-Version: 1.0
References: <20210402005658.3024832-1-seanjc@google.com>
 <20210402005658.3024832-10-seanjc@google.com>
In-Reply-To: <20210402005658.3024832-10-seanjc@google.com>
From: Wanpeng Li <kernellwp@gmail.com>
Date: Mon, 19 Apr 2021 16:49:20 +0800
Message-ID: <CANRm+Cwt9Xs=13r9E4YWOhcE6oEJXmVrkKrv_wQ5jMUkY8+Stw@mail.gmail.com>
Subject: Re: [PATCH v2 09/10] KVM: Don't take mmu_lock for range invalidation
 unless necessary
To: Sean Christopherson <seanjc@google.com>
X-Mailman-Approved-At: Mon, 19 Apr 2021 06:40:43 -0400
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm <kvm@vger.kernel.org>,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 Huacai Chen <chenhuacai@kernel.org>, linux-mips@vger.kernel.org,
 kvm-ppc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
 Paul Mackerras <paulus@ozlabs.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 LAK <linux-arm-kernel@lists.infradead.org>, Ben Gardon <bgardon@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 kvmarm@lists.cs.columbia.edu, Jim Mattson <jmattson@google.com>
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

On Fri, 2 Apr 2021 at 08:59, Sean Christopherson <seanjc@google.com> wrote:
>
> Avoid taking mmu_lock for unrelated .invalidate_range_{start,end}()
> notifications.  Because mmu_notifier_count must be modified while holding
> mmu_lock for write, and must always be paired across start->end to stay
> balanced, lock elision must happen in both or none.  To meet that
> requirement, add a rwsem to prevent memslot updates across range_start()
> and range_end().
>
> Use a rwsem instead of a rwlock since most notifiers _allow_ blocking,
> and the lock will be endl across the entire start() ... end() sequence.
> If anything in the sequence sleeps, including the caller or a different
> notifier, holding the spinlock would be disastrous.
>
> For notifiers that _disallow_ blocking, e.g. OOM reaping, simply go down
> the slow path of unconditionally acquiring mmu_lock.  The sane
> alternative would be to try to acquire the lock and force the notifier
> to retry on failure.  But since OOM is currently the _only_ scenario
> where blocking is disallowed attempting to optimize a guest that has been
> marked for death is pointless.
>
> Unconditionally define and use mmu_notifier_slots_lock in the memslots
> code, purely to avoid more #ifdefs.  The overhead of acquiring the lock
> is negligible when the lock is uncontested, which will always be the case
> when the MMU notifiers are not used.
>
> Note, technically flag-only memslot updates could be allowed in parallel,
> but stalling a memslot update for a relatively short amount of time is
> not a scalability issue, and this is all more than complex enough.
>
> Based heavily on code from Ben Gardon.
>
> Suggested-by: Ben Gardon <bgardon@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

I saw this splatting:

 ======================================================
 WARNING: possible circular locking dependency detected
 5.12.0-rc3+ #6 Tainted: G           OE
 ------------------------------------------------------
 qemu-system-x86/3069 is trying to acquire lock:
 ffffffff9c775ca0 (mmu_notifier_invalidate_range_start){+.+.}-{0:0},
at: __mmu_notifier_invalidate_range_end+0x5/0x190

 but task is already holding lock:
 ffffaff7410a9160 (&kvm->mmu_notifier_slots_lock){.+.+}-{3:3}, at:
kvm_mmu_notifier_invalidate_range_start+0x36d/0x4f0 [kvm]

 which lock already depends on the new lock.


 the existing dependency chain (in reverse order) is:

 -> #1 (&kvm->mmu_notifier_slots_lock){.+.+}-{3:3}:
        down_read+0x48/0x250
        kvm_mmu_notifier_invalidate_range_start+0x36d/0x4f0 [kvm]
        __mmu_notifier_invalidate_range_start+0xe8/0x260
        wp_page_copy+0x82b/0xa30
        do_wp_page+0xde/0x420
        __handle_mm_fault+0x935/0x1230
        handle_mm_fault+0x179/0x420
        do_user_addr_fault+0x1b3/0x690
        exc_page_fault+0x82/0x2b0
        asm_exc_page_fault+0x1e/0x30

 -> #0 (mmu_notifier_invalidate_range_start){+.+.}-{0:0}:
        __lock_acquire+0x110f/0x1980
        lock_acquire+0x1bc/0x400
        __mmu_notifier_invalidate_range_end+0x47/0x190
        wp_page_copy+0x796/0xa30
        do_wp_page+0xde/0x420
        __handle_mm_fault+0x935/0x1230
        handle_mm_fault+0x179/0x420
        do_user_addr_fault+0x1b3/0x690
        exc_page_fault+0x82/0x2b0
        asm_exc_page_fault+0x1e/0x30

 other info that might help us debug this:

  Possible unsafe locking scenario:

        CPU0                    CPU1
        ----                    ----
   lock(&kvm->mmu_notifier_slots_lock);
                                lock(mmu_notifier_invalidate_range_start);
                                lock(&kvm->mmu_notifier_slots_lock);
   lock(mmu_notifier_invalidate_range_start);

  *** DEADLOCK ***

 2 locks held by qemu-system-x86/3069:
  #0: ffff9e4269f8a9e0 (&mm->mmap_lock#2){++++}-{3:3}, at:
do_user_addr_fault+0x10e/0x690
  #1: ffffaff7410a9160 (&kvm->mmu_notifier_slots_lock){.+.+}-{3:3},
at: kvm_mmu_notifier_invalidate_range_start+0x36d/0x4f0 [kvm]

 stack backtrace:
 CPU: 0 PID: 3069 Comm: qemu-system-x86 Tainted: G           OE
5.12.0-rc3+ #6
 Hardware name: LENOVO ThinkCentre M8500t-N000/SHARKBAY, BIOS
FBKTC1AUS 02/16/2016
 Call Trace:
  dump_stack+0x87/0xb7
  print_circular_bug.isra.39+0x1b4/0x210
  check_noncircular+0x103/0x150
  __lock_acquire+0x110f/0x1980
  ? __lock_acquire+0x110f/0x1980
  lock_acquire+0x1bc/0x400
  ? __mmu_notifier_invalidate_range_end+0x5/0x190
  ? find_held_lock+0x40/0xb0
  __mmu_notifier_invalidate_range_end+0x47/0x190
  ? __mmu_notifier_invalidate_range_end+0x5/0x190
  wp_page_copy+0x796/0xa30
  do_wp_page+0xde/0x420
  __handle_mm_fault+0x935/0x1230
  handle_mm_fault+0x179/0x420
  do_user_addr_fault+0x1b3/0x690
  ? rcu_read_lock_sched_held+0x4f/0x80
  exc_page_fault+0x82/0x2b0
  ? asm_exc_page_fault+0x8/0x30
  asm_exc_page_fault+0x1e/0x30
 RIP: 0033:0x55f5bef2560f
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
