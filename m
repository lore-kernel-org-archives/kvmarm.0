Return-Path: <SRS0=JLBt=LF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 395FBC48BD1
	for <kvmarm@archiver.kernel.org>; Fri, 11 Jun 2021 12:46:33 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AADC2613DF
	for <kvmarm@archiver.kernel.org>; Fri, 11 Jun 2021 12:46:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AADC2613DF
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 39BBC49FB0;
	Fri, 11 Jun 2021 08:46:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id B7TgFy3HNtpg; Fri, 11 Jun 2021 08:46:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 087574A4E5;
	Fri, 11 Jun 2021 08:46:31 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 53F124A418
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Jun 2021 08:46:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lN6l3lpcyvWj for <kvmarm@lists.cs.columbia.edu>;
 Fri, 11 Jun 2021 08:46:28 -0400 (EDT)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EB95B49FB0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Jun 2021 08:46:27 -0400 (EDT)
Received: by mail-yb1-f201.google.com with SMTP id
 u48-20020a25ab330000b029053982019c2dso3883161ybi.2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Jun 2021 05:46:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=Ho/DEjMpdsHHhO7ht7jErSM7pqZQLsxy56J3r0tZ1qE=;
 b=cY6xspWCN3ZaaYXM2Ylh4WKJo59wK1Ly33TcOY+3M6Zi//nTLuq/QAZjvo2PIMvC4N
 3IKL0DcWTtBorei00eie7b/qgiKmHMhjTHMq866EvA1B4apLtxkWBP+3phdpGylTUffS
 s7vqWklPC/XXdtB6kXD4I+tqXW8GXgZKZNwUgCLKKLwiljS2EUae2hdO6PDtnYqw3yrp
 pYWWvlKZxPWUwbEI1QJ1w7eTriwzt73EwF/sjwjurbLX4dPl7d1axOqSsbtdYfwXBFks
 WgUVwpQwiPecLRR1z41kwXcxVz5YV8uAgzpM3aaW9dUxqCfWQsRL0K5aKQZsWcnwQ5xe
 tGnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=Ho/DEjMpdsHHhO7ht7jErSM7pqZQLsxy56J3r0tZ1qE=;
 b=OFCokPB1ZXS7Mmk6vTnByPYTMr8f1dn9ADC/M/SNh/YWLNKhf+3Fbk06uAE9SAI8/w
 6gscbPk7qGmFLJtRDjTScSAtvg4zuUD/yXEKKvP6vmzM0cHCON6AVr2xec9dI6ZInOzP
 Ks3KyyV/PBi0358dgt/blpBPrjV3bWMvtUGl75X28YAE0Q1J51hMu7mX7brMzt+5Ye0c
 Bi6akeOUxsXjK2lqi7U1gEp2m4t0TRV6lXT4Gj2NZqD9BhwgmePjm7SVfJh73Jn/mcVb
 MEM97KEoyxPp7ePcmmXo3kAczjk6LnA5IY+Qs+t7Mu1EnO2rZ595O7EtZbSZ07cj/GoG
 SzCg==
X-Gm-Message-State: AOAM533EEIbgS1LcYtF+pe1f4FufFb0Xofu3c7415j7yatKBxJVlzpd9
 JmJwdlQXP/t/UZKxK0nrUOeyxFdC1mo/Z+iZpg==
X-Google-Smtp-Source: ABdhPJzRhxBOlm8NTEnDLbnoLqOCGcumkeszvV0W9YOxF2xohXqVg3ILFvB2MHjyLkfdCks/mKyw0ADUTsT+pcLFoQ==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a25:ba06:: with SMTP id
 t6mr5422206ybg.459.1623415587231; Fri, 11 Jun 2021 05:46:27 -0700 (PDT)
Date: Fri, 11 Jun 2021 12:46:20 +0000
Message-Id: <20210611124624.1404010-1-jingzhangos@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.272.g935e593368-goog
Subject: [PATCH v8 0/4] KVM statistics data fd-based binary interface
From: Jing Zhang <jingzhangos@google.com>
To: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.cs.columbia.edu>, 
 LinuxMIPS <linux-mips@vger.kernel.org>, KVMPPC <kvm-ppc@vger.kernel.org>, 
 LinuxS390 <linux-s390@vger.kernel.org>, 
 Linuxkselftest <linux-kselftest@vger.kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, 
 Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
 Julien Thierry <julien.thierry.kdev@gmail.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Will Deacon <will@kernel.org>, Huacai Chen <chenhuacai@kernel.org>, 
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>, 
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Paul Mackerras <paulus@ozlabs.org>, 
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>, 
 David Hildenbrand <david@redhat.com>, Cornelia Huck <cohuck@redhat.com>, 
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 Sean Christopherson <seanjc@google.com>, 
 Vitaly Kuznetsov <vkuznets@redhat.com>, Jim Mattson <jmattson@google.com>, 
 Peter Shier <pshier@google.com>, Oliver Upton <oupton@google.com>, 
 David Rientjes <rientjes@google.com>,
 Emanuele Giuseppe Esposito <eesposit@redhat.com>, 
 David Matlack <dmatlack@google.com>, Ricardo Koller <ricarkol@google.com>, 
 Krish Sadhukhan <krish.sadhukhan@oracle.com>
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

This patchset provides a file descriptor for every VM and VCPU to read
KVM statistics data in binary format.
It is meant to provide a lightweight, flexible, scalable and efficient
lock-free solution for user space telemetry applications to pull the
statistics data periodically for large scale systems. The pulling
frequency could be as high as a few times per second.
In this patchset, every statistics data are treated to have some
attributes as below:
  * architecture dependent or generic
  * VM statistics data or VCPU statistics data
  * type: cumulative, instantaneous,
  * unit: none for simple counter, nanosecond, microsecond,
    millisecond, second, Byte, KiByte, MiByte, GiByte. Clock Cycles
Since no lock/synchronization is used, the consistency between all
the statistics data is not guaranteed. That means not all statistics
data are read out at the exact same time, since the statistics date
are still being updated by KVM subsystems while they are read out.

---

* v7-> v8
  - Rebase to kvm/queue, commit c1dc20e254b4 ("KVM: switch per-VM
  stats to u64")
  - Revise code to reflect the per-VM stats type from ulong to u64
  - Addressed some other nits

* v6 -> v7
  - Improve file descriptor allocation function by Krish suggestion
  - Use "generic stats" instead of "common stats" as Krish suggested
  - Addressed some other nits from Krish and David Matlack

* v5 -> v6
  - Use designated initializers for STATS_DESC
  - Change KVM_STATS_SCALE... to KVM_STATS_BASE...
  - Use a common function for kvm_[vm|vcpu]_stats_read
  - Fix some documentation errors/missings
  - Use TEST_ASSERT in selftest
  - Use a common function for [vm|vcpu]_stats_test in selftest

* v4 -> v5
  - Rebase to kvm/queue, commit a4345a7cecfb ("Merge tag
    'kvmarm-fixes-5.13-1'")
  - Change maximum stats name length to 48
  - Replace VM_STATS_COMMON/VCPU_STATS_COMMON macros with stats
    descriptor definition macros.
  - Fixed some errors/warnings reported by checkpatch.pl

* v3 -> v4
  - Rebase to kvm/queue, commit 9f242010c3b4 ("KVM: avoid "deadlock"
    between install_new_memslots and MMU notifier")
  - Use C-stype comments in the whole patch
  - Fix wrong count for x86 VCPU stats descriptors
  - Fix KVM stats data size counting and validity check in selftest

* v2 -> v3
  - Rebase to kvm/queue, commit edf408f5257b ("KVM: avoid "deadlock"
    between install_new_memslots and MMU notifier")
  - Resolve some nitpicks about format

* v1 -> v2
  - Use ARRAY_SIZE to count the number of stats descriptors
  - Fix missing `size` field initialization in macro STATS_DESC

[1] https://lore.kernel.org/kvm/20210402224359.2297157-1-jingzhangos@google.com
[2] https://lore.kernel.org/kvm/20210415151741.1607806-1-jingzhangos@google.com
[3] https://lore.kernel.org/kvm/20210423181727.596466-1-jingzhangos@google.com
[4] https://lore.kernel.org/kvm/20210429203740.1935629-1-jingzhangos@google.com
[5] https://lore.kernel.org/kvm/20210517145314.157626-1-jingzhangos@google.com
[6] https://lore.kernel.org/kvm/20210524151828.4113777-1-jingzhangos@google.com
[7] https://lore.kernel.org/kvm/20210603211426.790093-1-jingzhangos@google.com

---

Jing Zhang (4):
  KVM: stats: Separate generic stats from architecture specific ones
  KVM: stats: Add fd-based API to read binary stats data
  KVM: stats: Add documentation for statistics data binary interface
  KVM: selftests: Add selftest for KVM statistics data binary interface

 Documentation/virt/kvm/api.rst                | 174 +++++++++++++-
 arch/arm64/include/asm/kvm_host.h             |   9 +-
 arch/arm64/kvm/guest.c                        |  46 +++-
 arch/mips/include/asm/kvm_host.h              |   9 +-
 arch/mips/kvm/mips.c                          |  71 +++++-
 arch/powerpc/include/asm/kvm_host.h           |   9 +-
 arch/powerpc/kvm/book3s.c                     |  72 +++++-
 arch/powerpc/kvm/book3s_hv.c                  |  12 +-
 arch/powerpc/kvm/book3s_pr.c                  |   2 +-
 arch/powerpc/kvm/book3s_pr_papr.c             |   2 +-
 arch/powerpc/kvm/booke.c                      |  67 +++++-
 arch/s390/include/asm/kvm_host.h              |   9 +-
 arch/s390/kvm/kvm-s390.c                      | 137 ++++++++++-
 arch/x86/include/asm/kvm_host.h               |   9 +-
 arch/x86/kvm/x86.c                            |  75 +++++-
 include/linux/kvm_host.h                      | 138 ++++++++++-
 include/linux/kvm_types.h                     |  12 +
 include/uapi/linux/kvm.h                      |  46 ++++
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   3 +
 .../testing/selftests/kvm/include/kvm_util.h  |   3 +
 .../selftests/kvm/kvm_binary_stats_test.c     | 218 ++++++++++++++++++
 tools/testing/selftests/kvm/lib/kvm_util.c    |  12 +
 virt/kvm/kvm_main.c                           | 157 ++++++++++++-
 24 files changed, 1202 insertions(+), 91 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/kvm_binary_stats_test.c


base-commit: c1dc20e254b421a2463da7f053b37d822788224a
-- 
2.32.0.272.g935e593368-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
