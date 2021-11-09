Return-Path: <SRS0=lFky=P4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9025C433F5
	for <kvmarm@archiver.kernel.org>; Tue,  9 Nov 2021 02:39:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 41A08619BB
	for <kvmarm@archiver.kernel.org>; Tue,  9 Nov 2021 02:39:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 41A08619BB
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9542F4B1C8;
	Mon,  8 Nov 2021 21:39:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6Fd0KBxw9OYN; Mon,  8 Nov 2021 21:39:16 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CB7CC4B1A5;
	Mon,  8 Nov 2021 21:39:16 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3D6D64B125
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Nov 2021 21:39:15 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vqgfscENIURg for <kvmarm@lists.cs.columbia.edu>;
 Mon,  8 Nov 2021 21:39:13 -0500 (EST)
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com
 [209.85.214.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D190B4B11E
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Nov 2021 21:39:13 -0500 (EST)
Received: by mail-pl1-f201.google.com with SMTP id
 a4-20020a170902ecc400b00142562309c7so2659591plh.6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 08 Nov 2021 18:39:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=9kfjkwh0XeCTSxvEq2rSuYCXrCO8cNiwIU3519UtjQc=;
 b=pbf3M2iVHeF14qUsyMIOeVLd7BZ2/YXwEev0iQZ8Ka2isZ/J6/aNkE7JsSKGZ5CL1a
 KW3irQLhsUmxsH4Aej+wgE3bwRDbLmkjryi9TDCn7Zprx3NBlvp9vE1G5AVm57AzNNRu
 IYi0RnfKi4BUwdDJetDZ6IFtmAFkAULwJkXBWgC7bJy0HMawJsMGsIVq2BE+AqBEOejk
 DsPvZRvl8dz9C9AePdbR+Hiszj3zQVcBhwXLHL98xo+dw7lbn0vCqUEL7flYw+uMYHK+
 BG+h56ap9V2LLRjiHIlSB2/cnlA9HdmSBcHPg2U96CFQOeFKxoblQnlP9XXtnhVYJ1rt
 pzRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=9kfjkwh0XeCTSxvEq2rSuYCXrCO8cNiwIU3519UtjQc=;
 b=3THVHrwdG0FkR91MJ6UOcYVgKv9RcKYw+ElzqOeFRyhkuCl9glOhd6m9qqamzwima4
 2LmsNWYt2YhNjngASoJMD9mracyEQlIJ2frCLqvUwTcS9zpMNvr8TTIAE6wmOj2pzesD
 T0/NgXjaX7YZJRGOI7Yp12A3zlF48Q2uNU0eNXUL4XKOGzl8IOtSYjLfSEbNJP3e5Vvm
 RdV5udWpTYRhsxubcz5G9/RWdbauVpleGpo4nHcTK2HbuRnpFBWrzraG/pYC3tv4G0IM
 zyjhynSJPPtVCMtB8jufu0GEMFp+tJrHRM6GOgtViebqKjPumXLNMM6sRBiIvoYO1c6D
 h+CA==
X-Gm-Message-State: AOAM532sDKzor8/odJukAubDRH4amjQHgGoCIRUsGD9qOKuERgMgyg5/
 IiabsUOlUALxwxLoDkjcHgaON5En+FxLag==
X-Google-Smtp-Source: ABdhPJyEaUpzC3JP/YSAblsMH687yjvwYd2dNYq5Vd9uD22fsk3Uu1dvR2/eGxjJjXIibqlAla0BEREdORMgdA==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:902:e789:b0:140:801:1262 with SMTP id
 cp9-20020a170902e78900b0014008011262mr4046586plb.42.1636425552990; Mon, 08
 Nov 2021 18:39:12 -0800 (PST)
Date: Mon,  8 Nov 2021 18:38:49 -0800
Message-Id: <20211109023906.1091208-1-ricarkol@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.0.rc0.344.g81b53c2807-goog
Subject: [PATCH 00/17] KVM: selftests: aarch64: Test userspace IRQ injection
From: Ricardo Koller <ricarkol@google.com>
To: kvm@vger.kernel.org, maz@kernel.org, kvmarm@lists.cs.columbia.edu, 
 drjones@redhat.com, eric.auger@redhat.com, alexandru.elisei@arm.com
Cc: pshier@google.com, Paolo Bonzini <pbonzini@redhat.com>, shuah@kernel.org
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

This series adds a new test, aarch64/vgic-irq, that validates the injection of
different types of IRQs from userspace using various methods and configurations
(when applicable):

    Intid        Method     |       |          Configuration
                            |       |
               IRQ_LINE     |       |
    SGI        LEVEL_INFO   |       |
    PPI    x   IRQFD        |   x   | level-sensitive  x  EOIR + DIR
    SPI        ISPENDR      |       | edge-triggered      EOIR only
    bogus      ISACTIVER    |       |
                            |       |

vgic-irq is implemented by having a single vcpu started in any of the 4 (2x2)
configurations above.  The guest then "asks" userspace to inject all intids of
a given IRQ type using each applicable method via a GUEST_SYNC call.  The
applicable methods and intids for a given configuration are specified in tables
like this one:

    /* edge-triggered */
    static struct kvm_inject_desc inject_edge_fns[] = {
            /*                            sgi    ppi    spi */
            { KVM_IRQ_LINE,               false, false, true },
            { IRQFD,                      false, false, true },
            { ISPENDR,                    true,  false, true },
    };

Based on the (example) table above, a guest running in an edge-triggered
configuration will try injecting SGIs and SPIs.  The specific methods are also
given in the table, e.g.: SGIs are injected from userspace by writing into the
ISPENDR register.

This test also adds some extra edge tests like: IRQ preemption, restoring
active IRQs, trying to inject bogus intid's (e.g., above the configured KVM
nr_irqs).

Note that vgic-irq is currently limited to a single vcpu, GICv3, and does not
test the vITS (no MSIs).

- Commits 1-3 add some GICv3 library functions on the guest side, e.g.: set the
  priority of an IRQ.
- Commits 4-5 add some vGICv3 library functions on the userspace side, e.g.: a
  wrapper for KVM_IRQ_LINE.
- Commit 6 adds the basic version of this test: inject an SPI using
  KVM_IRQ_LINE.
- Commits 7-17 add other IRQs types, methods and configurations.

Ricardo Koller (17):
  KVM: selftests: aarch64: move gic_v3.h to shared headers
  KVM: selftests: aarch64: add function for accessing GICv3 dist and
    redist registers
  KVM: selftests: aarch64: add GICv3 register accessor library functions
  KVM: selftests: add kvm_irq_line library function
  KVM: selftests: aarch64: add vGIC library functions to deal with vIRQ
    state
  KVM: selftests: aarch64: add vgic_irq to test userspace IRQ injection
  KVM: selftests: aarch64: abstract the injection functions in vgic_irq
  KVM: selftests: aarch64: cmdline arg to set number of IRQs in vgic_irq
    test
  KVM: selftests: aarch64: cmdline arg to set EOI mode in vgic_irq
  KVM: selftests: aarch64: add preemption tests in vgic_irq
  KVM: selftests: aarch64: level-sensitive interrupts tests in vgic_irq
  KVM: selftests: aarch64: add tests for LEVEL_INFO in vgic_irq
  KVM: selftests: aarch64: add test_inject_fail to vgic_irq
  KVM: selftests: add IRQ GSI routing library functions
  KVM: selftests: aarch64: add tests for IRQFD in vgic_irq
  KVM: selftests: aarch64: add ISPENDR write tests in vgic_irq
  KVM: selftests: aarch64: add test for restoring active IRQs

 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/aarch64/arch_timer.c        |   2 +-
 .../testing/selftests/kvm/aarch64/vgic_irq.c  | 853 ++++++++++++++++++
 .../selftests/kvm/include/aarch64/gic.h       |  26 +
 .../kvm/{lib => include}/aarch64/gic_v3.h     |  12 +
 .../selftests/kvm/include/aarch64/vgic.h      |  18 +-
 .../testing/selftests/kvm/include/kvm_util.h  |  10 +
 tools/testing/selftests/kvm/lib/aarch64/gic.c |  66 ++
 .../selftests/kvm/lib/aarch64/gic_private.h   |  11 +
 .../selftests/kvm/lib/aarch64/gic_v3.c        | 206 ++++-
 .../testing/selftests/kvm/lib/aarch64/vgic.c  | 103 ++-
 tools/testing/selftests/kvm/lib/kvm_util.c    |  72 ++
 13 files changed, 1352 insertions(+), 29 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/aarch64/vgic_irq.c
 rename tools/testing/selftests/kvm/{lib => include}/aarch64/gic_v3.h (80%)

-- 
2.34.0.rc0.344.g81b53c2807-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
