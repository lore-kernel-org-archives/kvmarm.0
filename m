Return-Path: <SRS0=A4hI=LM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDD2DC49EAF
	for <kvmarm@archiver.kernel.org>; Fri, 18 Jun 2021 22:27:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4FB1B613DA
	for <kvmarm@archiver.kernel.org>; Fri, 18 Jun 2021 22:27:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4FB1B613DA
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B743F4A17F;
	Fri, 18 Jun 2021 18:27:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Y0UvSTjdnPHJ; Fri, 18 Jun 2021 18:27:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 561EB49F8F;
	Fri, 18 Jun 2021 18:27:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D335A49F6C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Jun 2021 18:27:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CCW-JvnzL1lr for <kvmarm@lists.cs.columbia.edu>;
 Fri, 18 Jun 2021 18:27:13 -0400 (EDT)
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com
 [209.85.210.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CC21A40874
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Jun 2021 18:27:13 -0400 (EDT)
Received: by mail-pf1-f202.google.com with SMTP id
 r15-20020a62e40f0000b02902ec871096d3so6518437pfh.12
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Jun 2021 15:27:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=Rfo1W3uIN+oXhpQ4fFbpzg3hhziXATDdq5mP9Sy8YmE=;
 b=aIYN4+wVVAkm16BxMrsAIblZurqsWDq1k5rpZKYzrpPVtnjJooCxHt+wvHKu/vmUXT
 tzRsVJb2kPXWI/iihrS2Q6RnhUZ6g4QZXgEEBLP556HTfjvzXKT9Jyf+uc/U1P0GzogT
 VoRq4kVv9Tu4cSCrt47bOaSueq1yP0Cqh8UQHk+O9WqEHf5jZyK/xxfcfiG5eAGJS3Cu
 MWl11xl4UjW3wELOFkYJwjjDSaAW5ZJLIR8tf+1hmcX8/36Z0/QvwJeS6CgkUbGo4nQE
 mvz5bzypgVY1WSBO4fjKCbig37vmOW+gMDXLlrsLKtFD/NuEG0ImluxQrtNM5gp5SHa4
 eRcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=Rfo1W3uIN+oXhpQ4fFbpzg3hhziXATDdq5mP9Sy8YmE=;
 b=OTG3XGdaLVF6N42TwVEkGHXZ1X2dn1A+WcsbgRC5s399pL0ClhN+fP1fnFTu4/LzG5
 gs9mEu9dcBLvrBMFqWGDTR/2cZOhGKgea8zp62SXsnyLLpWREMDM73//sTF4mp9wiyG8
 Q8nWvO7+Z/4QNrEzpSkv1DdxK5HoZxx62Oytr2cAgfBwbY+79gEmPSyXKVJd/jEgCDbc
 T4evAOMGVqn4GQf62FW3B9oVF6mrZQIot7aIw8PFB0PNDSSCwmPgSuaWsCpm1MOD/ppC
 7D09q9smUw+3i6N36osIyWxQeCxR7kTed+rHjngQqXkcF5b/3rIt4Aw9CeUE36EDcfb7
 dxlg==
X-Gm-Message-State: AOAM533YtsT9x+7Ies+YBRh/nxQqCyFRlD+pBiGNeOiGKU2ea6lbc3K9
 h+RsfNxB1vKpoCLm26i4bwpHjTqKkN2RqJ6u9w==
X-Google-Smtp-Source: ABdhPJxq7gZzEkJhd70zVlEMr7IlzZeL5JxVSf0DCO+Q9uRpodXSo9AqnAN/jRwaShxfxk4IPXPUTJbxDu62WSfIEw==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a17:902:e04f:b029:eb:66b0:6d08 with
 SMTP id x15-20020a170902e04fb02900eb66b06d08mr6816032plx.50.1624055232365;
 Fri, 18 Jun 2021 15:27:12 -0700 (PDT)
Date: Fri, 18 Jun 2021 22:27:02 +0000
Message-Id: <20210618222709.1858088-1-jingzhangos@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.288.g62a8d224e6-goog
Subject: [PATCH v12 0/7] KVM statistics data fd-based binary interface
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
 Krish Sadhukhan <krish.sadhukhan@oracle.com>, Fuad Tabba <tabba@google.com>, 
 Greg KH <gregkh@linuxfoundation.org>
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
  * type: cumulative, instantaneous, peak
  * unit: none for simple counter, nanosecond, microsecond,
    millisecond, second, Byte, KiByte, MiByte, GiByte, Clock Cycles
Since no lock/synchronization is used, the consistency between all
the statistics data is not guaranteed. That means not all statistics
data are read out at the exact same time, since the statistics data
are still being updated by KVM subsystems while they are read out.

---

* v11 -> v12
  - Revised the structure kvm_stats_header and corresponding code by
    Paolo's suggestion. Move the id string out of header.
  - Define stats header and stats descriptors as const.
  - Update some comments by Greg's review.

* v10 -> v11
  - Rebase to kvm/queue, commit f1b832550832
    (KVM: x86/mmu: Fix TDP MMU page table level)
  - Separate binary stats implementation commit
  - Use flexible length array member field in API structure instead of
    zero-length array member field
  - Move major binary stats reading function in a separate source file
  - Move stats id string into vm/vcpu structures
  - Add some detailed comments and update commit messages
  - Addressed some other review comments from Greg K.H. and Paolo.

* v9 -> v10
  - Relocate vcpu stat in vcpu's slab's usercopy region
  - Fix test issue for capability checking
  - Update commit message to explain why/how we need to add this new
    API for KVM statistics

* v8 -> v9
  - Rebase to commit 8331a2bc0898
    (KVM: X86: Introduce KVM_HC_MAP_GPA_RANGE hypercall)
  - Reduce code duplication between binary and debugfs interface
  - Add field "offset" in stats descriptor to let us define stats
    descriptors in any order (not necessary in the order of stats
    defined in vm/vcpu stats structures)
  - Add static check to make sure the number of stats descriptors
    is the same as the number of stats defined in vm/vcpu stats
    structures
  - Fix missing/mismatched stats descriptor definition caused by
    rebase

* v7 -> v8
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
[8] https://lore.kernel.org/kvm/20210611124624.1404010-1-jingzhangos@google.com
[9] https://lore.kernel.org/kvm/20210614212155.1670777-1-jingzhangos@google.com
[10] https://lore.kernel.org/kvm/20210617044146.2667540-1-jingzhangos@google.com
[11] https://lore.kernel.org/kvm/20210618044819.3690166-1-jingzhangos@google.com

---

Jing Zhang (7):
  KVM: stats: Separate generic stats from architecture specific ones
  KVM: stats: Add fd-based API to read binary stats data
  KVM: stats: Support binary stats retrieval for a VM
  KVM: stats: Support binary stats retrieval for a VCPU
  KVM: stats: Add documentation for binary statistics interface
  KVM: selftests: Add selftest for KVM statistics data binary interface
  KVM: stats: Remove code duplication for binary and debugfs stats

 Documentation/virt/kvm/api.rst                | 198 ++++++++++++++-
 arch/arm64/include/asm/kvm_host.h             |   9 +-
 arch/arm64/kvm/Makefile                       |   2 +-
 arch/arm64/kvm/guest.c                        |  48 ++--
 arch/mips/include/asm/kvm_host.h              |   9 +-
 arch/mips/kvm/Makefile                        |   2 +-
 arch/mips/kvm/mips.c                          |  90 ++++---
 arch/powerpc/include/asm/kvm_host.h           |   9 +-
 arch/powerpc/kvm/Makefile                     |   2 +-
 arch/powerpc/kvm/book3s.c                     |  91 ++++---
 arch/powerpc/kvm/book3s_hv.c                  |  12 +-
 arch/powerpc/kvm/book3s_pr.c                  |   2 +-
 arch/powerpc/kvm/book3s_pr_papr.c             |   2 +-
 arch/powerpc/kvm/booke.c                      |  76 ++++--
 arch/s390/include/asm/kvm_host.h              |   9 +-
 arch/s390/kvm/Makefile                        |   3 +-
 arch/s390/kvm/kvm-s390.c                      | 232 +++++++++--------
 arch/x86/include/asm/kvm_host.h               |   9 +-
 arch/x86/kvm/Makefile                         |   2 +-
 arch/x86/kvm/x86.c                            | 109 ++++----
 include/linux/kvm_host.h                      | 182 ++++++++++++--
 include/linux/kvm_types.h                     |  14 ++
 include/uapi/linux/kvm.h                      |  73 ++++++
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   3 +
 .../testing/selftests/kvm/include/kvm_util.h  |   3 +
 .../selftests/kvm/kvm_binary_stats_test.c     | 234 ++++++++++++++++++
 tools/testing/selftests/kvm/lib/kvm_util.c    |  12 +
 virt/kvm/binary_stats.c                       | 144 +++++++++++
 virt/kvm/kvm_main.c                           | 218 +++++++++++++---
 30 files changed, 1443 insertions(+), 357 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/kvm_binary_stats_test.c
 create mode 100644 virt/kvm/binary_stats.c


base-commit: f1b8325508327a302f1d5cd8a4bf51e2c9c72fa9
-- 
2.32.0.288.g62a8d224e6-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
