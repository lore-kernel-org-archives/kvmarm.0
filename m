Return-Path: <SRS0=Rd7Q=OP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BEC2C433FE
	for <kvmarm@archiver.kernel.org>; Sat, 25 Sep 2021 00:55:39 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DAB15610EA
	for <kvmarm@archiver.kernel.org>; Sat, 25 Sep 2021 00:55:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org DAB15610EA
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 21C754B0C0;
	Fri, 24 Sep 2021 20:55:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id upqtjA7eTCmr; Fri, 24 Sep 2021 20:55:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6A1774B0DE;
	Fri, 24 Sep 2021 20:55:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 784F34B0C5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 20:55:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id U2hfDt33zrQn for <kvmarm@lists.cs.columbia.edu>;
 Fri, 24 Sep 2021 20:55:31 -0400 (EDT)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8884F4B0C0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 20:55:31 -0400 (EDT)
Received: by mail-yb1-f201.google.com with SMTP id
 l11-20020a056902072b00b005a776eefb28so5838208ybt.5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 17:55:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=reply-to:date:message-id:mime-version:subject:from:to:cc;
 bh=7raooij+tUym7W5s5WPrsLkrWPVticCVkKY3RWsiNDM=;
 b=DXmlShHbjvZa1JvxxvOqKfYKe30mtQRur87j+123oY2dFsBNlIAv8O9qEBNpSOGVM0
 b5Sl+lbCoTOZX+zxJ51FQGhzcy9kOU+kuN3HT7C+f5nB6pN5R9AkQ8rfnjTjbSc6y1L3
 1xXBLePNa9IJaU5EZa6ilhTbqnfNBkXudDaPUTNvEb8RjoCOqehEtkbp9fcq+twCr1dj
 7pQFp14KUjSeBu0Lomx7YgO5vlp+0uTYliIei7NH6p2gACqnEuNLOy869NtJ5XSjME8N
 QoN0wBA2Bv2bcnfhLjSPkQbfYQGKsKIy45up5bnYKrvy1J3XDWY6xOjC4rNSR6s7vMuY
 cddw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
 :from:to:cc;
 bh=7raooij+tUym7W5s5WPrsLkrWPVticCVkKY3RWsiNDM=;
 b=ya4SjFCdtOOSIDan9jT7Si1gjVhQTet/qU6esKYxwj5zYmSlX0KyY0NQGDfQIM17Qa
 er0igj0X9UYUBFj6pXpcX2IPQ5B6rWm7ivkltLZPMfzfZyYKSAYrgRctXQOGtT3DTrIU
 BqMBoU2UVztYsM5Zd3Yo+VntK1jPfjiV9BZJO+isZH+sysH4wO9OjxR+34nqi/Hs/K/s
 lGzBmq9kTzwZt6X1qlVa8dg6YzA0j1Yroww7AEBA5ur63uBzbjCzw8ikOyIosmenrwhg
 wiPHXfub5YDmSxk/NFp+Jhp4nGcvmDuahzyr/8jsGhUGCf0GLiAnM55GuPT3t/U/UhGv
 p/QA==
X-Gm-Message-State: AOAM530vT9S7WCmgaldLhocdWDGI777yS3JWuUWjsB3jUoGgPMOf+32x
 ENMpOwCnUQskmCjWLZvEdNuOqlaEymo=
X-Google-Smtp-Source: ABdhPJz8Y4bPpJ9bNnOFRpqK33tyNqeaLzwcsIjpAg9bIC4dVS+lANHryvRV962R2bWiwjuBZB41gPX4lxc=
X-Received: from seanjc798194.pdx.corp.google.com
 ([2620:15c:90:200:4c72:89be:dba3:2bcb])
 (user=seanjc job=sendgmr) by 2002:a25:d482:: with SMTP id
 m124mr15615049ybf.73.1632531330879; 
 Fri, 24 Sep 2021 17:55:30 -0700 (PDT)
Date: Fri, 24 Sep 2021 17:55:14 -0700
Message-Id: <20210925005528.1145584-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [PATCH 00/14] KVM: Halt-polling fixes, cleanups and a new stat
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>, 
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Paul Mackerras <paulus@ozlabs.org>, 
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, Joerg Roedel <joro@8bytes.org>,
 Cornelia Huck <cohuck@redhat.com>, linux-mips@vger.kernel.org,
 kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, David Matlack <dmatlack@google.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, kvmarm@lists.cs.columbia.edu,
 Jim Mattson <jmattson@google.com>
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

The main purpose of this series is differentiate between "halt" and a more
generic "block", where "halt" aligns with x86's HLT instruction, the
halt-polling mechanisms, and associated stats, and "block" means any guest
action that causes the vCPU to block/wait.

This series arose out of a discussion over adding a stat to track if a
vCPU is blocked/halted[*].  The TL;DR of the discussion is that x86 has
several non-halt "wait" states, and arguably those states should not
participate in halt-polling.  In practice, it really doesn't matter from
a functionality perspective because there are typically so few occurences
of the non-halt waits that they're in the noise compared to the number of
actual HLTs, especially for a long-running VM.  So, my justification for
the rename is that because it doesn't truly affect functionality, KVM
might as well be technically correct and only use halt-polling for HLT.

The other annoyance this series addresses is that KVM mixes "halt" and
"block", e.g. the existing function is kvm_vcpu_block(), but all the stats
and the tracepoint use "halt".  Ideally, KVM would probably avoid "block"
altogether as people often think of "blocked" as meaning the vCPU is
blocked due to _host_ activity.  But I don't have a better alternative,
e.g. "halt" is obviously taken, "wait" is equivalent to "halt" on arm64,
"stop" has specific meaning on s390, etc...  I tried to address the host
vs. guest issue by naming the new stat "blocking" instead of "blocked",
e.g. to convey that the vCPU is "actively blocking" instead of "being
blocked".

Patch 01 fixes a theoretical, benign s390 bug, and sets the stage for
additional cleanups.

Patches 02-04 reconcile discrepancies in when KVM considers halt-polling
to be "successful".  Some stats consider it a success so long as KVM
doesn't schedule() away, others consider it a success if and only if a
wake event is detected in the halt-polling loop.

Patches 05-06 are prep cleanup to split out the core "block" routine.

Patch 07 is more prep, and should also be a small perf optimization for
halt-polling on arm64.

Patch 08 is x86 cleanup to free up the name kvm_vcpu_halt().

Patches 09-10 rename the existing kvm_vcpu_block() to kvm_vcpu_halt(), and
split out the core "block" routine to a new helper.

Patches 11-12 are minor cleanups to avoid unnecessary ktime_get().

Patches 13-14 convert non-HLT x86 flows to use kvm_vcpu_block().

[*] https://lkml.kernel.org/r/20210817230508.142907-1-jingzhangos@google.com

Jing Zhang (1):
  KVM: stats: Add stat to detect if vcpu is currently blocking

Sean Christopherson (13):
  KVM: s390: Ensure kvm_arch_no_poll() is read once when blocking vCPU
  KVM: Update halt-polling stats if and only if halt-polling was
    attempted
  KVM: Refactor and document halt-polling stats update helper
  KVM: Reconcile discrepancies in halt-polling stats
  KVM: s390: Clear valid_wakeup in kvm_s390_handle_wait(), not in arch
    hook
  KVM: Drop obsolete kvm_arch_vcpu_block_finish()
  KVM: Don't block+unblock when halt-polling is successful
  KVM: x86: Tweak halt emulation helper names to free up kvm_vcpu_halt()
  KVM: Rename kvm_vcpu_block() => kvm_vcpu_halt()
  KVM: Split out a kvm_vcpu_block() helper from kvm_vcpu_halt()
  KVM: Don't redo ktime_get() when calculating halt-polling
    stop/deadline
  KVM: x86: Directly block (instead of "halting") UNINITIALIZED vCPUs
  KVM: x86: Invoke kvm_vcpu_block() directly for non-HALTED wait states

 arch/arm64/include/asm/kvm_host.h   |   1 -
 arch/arm64/kvm/arch_timer.c         |   2 +-
 arch/arm64/kvm/handle_exit.c        |   4 +-
 arch/arm64/kvm/psci.c               |   2 +-
 arch/mips/include/asm/kvm_host.h    |   1 -
 arch/mips/kvm/emulate.c             |   2 +-
 arch/powerpc/include/asm/kvm_host.h |   1 -
 arch/powerpc/kvm/book3s_pr.c        |   2 +-
 arch/powerpc/kvm/book3s_pr_papr.c   |   2 +-
 arch/powerpc/kvm/booke.c            |   2 +-
 arch/powerpc/kvm/powerpc.c          |   2 +-
 arch/s390/include/asm/kvm_host.h    |   2 -
 arch/s390/kvm/interrupt.c           |   3 +-
 arch/s390/kvm/kvm-s390.c            |   7 +-
 arch/x86/include/asm/kvm_host.h     |   4 +-
 arch/x86/kvm/vmx/nested.c           |   2 +-
 arch/x86/kvm/vmx/vmx.c              |   4 +-
 arch/x86/kvm/x86.c                  |  25 ++++--
 include/linux/kvm_host.h            |   6 +-
 include/linux/kvm_types.h           |   1 +
 virt/kvm/kvm_main.c                 | 131 +++++++++++++++++-----------
 21 files changed, 118 insertions(+), 88 deletions(-)

-- 
2.33.0.685.g46640cef36-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
