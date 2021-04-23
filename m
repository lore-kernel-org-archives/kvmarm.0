Return-Path: <SRS0=8Q7i=JU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0A84C43603
	for <kvmarm@archiver.kernel.org>; Fri, 23 Apr 2021 18:17:39 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9067561462
	for <kvmarm@archiver.kernel.org>; Fri, 23 Apr 2021 18:17:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9067561462
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DA4D94B4FD;
	Fri, 23 Apr 2021 14:17:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9OzeCEq5GyWx; Fri, 23 Apr 2021 14:17:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A25D74B4FE;
	Fri, 23 Apr 2021 14:17:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 434A44B3B4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Apr 2021 14:17:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gkuP6iZ8j5qu for <kvmarm@lists.cs.columbia.edu>;
 Fri, 23 Apr 2021 14:17:32 -0400 (EDT)
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com
 [209.85.215.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 14E454B3AE
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Apr 2021 14:17:32 -0400 (EDT)
Received: by mail-pg1-f202.google.com with SMTP id
 m36-20020a634c640000b02901fbb60ec3a6so14716037pgl.15
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Apr 2021 11:17:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=jZ9aELeTtebSkfbpomfAFciujOueU+/1u2IVpj9kO9Q=;
 b=RyBxs7miM4jdCQ3yugSc8OvrTlv5u+dF3p+Ra7seVMrj1RVtjB+pFXakJoRIl1jsLS
 4JBtMKLiNnj9NnUNB9BsPmg2GgDdmytyBuu/qlKens774np+kb3bnNCuXir7AcEhlc1/
 MMqfYw4RQYaFjE94XkSwKSrhOxKcqkWzlvWkJUaoPIQajn3YTSQmT7PSjqoq+mzFElwD
 Nmi2pZp5/s1xwbLuQYIu7SednNnDgqlgHAbjSb3Ng+chogeOuRdzvwODmr0TjSFEqRbh
 /2xlGDh8qLD5AOsfQQHMcbZvPA7WcxPJHgBTYDJjHZfxvE6utLgsp5D6rJBK8yPps95G
 xQ1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=jZ9aELeTtebSkfbpomfAFciujOueU+/1u2IVpj9kO9Q=;
 b=a4HXov8US8vnkNeUz9QPZSjfi+5SB5N4kAtD32GV2DMXo0gchrt04MVwzWA/xTHcY1
 NOY7i7DZ/mjv7u58cDF0dADShuVJO0zSwg6bJZseKV6dF1fznhYrAJUwGQ2S92yOZ1g5
 kvYwAIS49vvl/elvA454lpNbOS7oI91VM/EWjgC9VBYHh/jydzrAg+wHHV/slDP4fMln
 CVTNGc1pqBfYtz+0oATR5zBXcGANmEsAIJeIPjkFD14JFhpwM/NVyWQtoj1x/41qZgYo
 48m0KHeWzrPvgDeXKsLFF60E5a71N0PrYy34Szc5lQSnnLxL4zvjpCbTIHgpAHcLOxIS
 Q8lw==
X-Gm-Message-State: AOAM530/5rXnb9fseahZQtTfBitiByJ3IOfLPsfa7GLn8wan3Zu/yB05
 hJkcmIDuVIlQDCMu2wweu5+jC2mfwxUBVO5LHg==
X-Google-Smtp-Source: ABdhPJybLPMWN/SpAe3p+WeheeiGCmvt6zlmflTWrm4w6vD8liP2VaphrDYff46dFN5dJ0IrExvz0uL99CbVXXMV7Q==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a17:90b:e98:: with SMTP id
 fv24mr1049588pjb.1.1619201850403; Fri, 23 Apr 2021 11:17:30 -0700 (PDT)
Date: Fri, 23 Apr 2021 18:17:23 +0000
Message-Id: <20210423181727.596466-1-jingzhangos@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
Subject: [PATCH v3 0/4] KVM statistics data fd-based binary interface
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
 Emanuele Giuseppe Esposito <eesposit@redhat.com>
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
  * architecture dependent or common
  * VM statistics data or VCPU statistics data
  * type: cumulative, instantaneous,
  * unit: none for simple counter, nanosecond, microsecond,
    millisecond, second, Byte, KiByte, MiByte, GiByte. Clock Cycles
Since no lock/synchronization is used, the consistency between all
the statistics data is not guaranteed. That means not all statistics
data are read out at the exact same time, since the statistics date
are still being updated by KVM subsystems while they are read out.

---

* v2 -> v3
  - Rebase to kvm/queue, commit edf408f5257b ("KVM: avoid "deadlock" between
    install_new_memslots and MMU notifier")
  - Resolve some nitpicks about format

* v1 -> v2
  - Use ARRAY_SIZE to count the number of stats descriptors
  - Fix missing `size` field initialization in macro STATS_DESC

[1] https://lore.kernel.org/kvm/20210402224359.2297157-1-jingzhangos@google.com
[2] https://lore.kernel.org/kvm/20210415151741.1607806-1-jingzhangos@google.com

---

Jing Zhang (4):
  KVM: stats: Separate common stats from architecture specific ones
  KVM: stats: Add fd-based API to read binary stats data
  KVM: stats: Add documentation for statistics data binary interface
  KVM: selftests: Add selftest for KVM statistics data binary interface

 Documentation/virt/kvm/api.rst                | 171 ++++++++
 arch/arm64/include/asm/kvm_host.h             |   9 +-
 arch/arm64/kvm/guest.c                        |  42 +-
 arch/mips/include/asm/kvm_host.h              |   9 +-
 arch/mips/kvm/mips.c                          |  67 +++-
 arch/powerpc/include/asm/kvm_host.h           |   9 +-
 arch/powerpc/kvm/book3s.c                     |  68 +++-
 arch/powerpc/kvm/book3s_hv.c                  |  12 +-
 arch/powerpc/kvm/book3s_pr.c                  |   2 +-
 arch/powerpc/kvm/book3s_pr_papr.c             |   2 +-
 arch/powerpc/kvm/booke.c                      |  63 ++-
 arch/s390/include/asm/kvm_host.h              |   9 +-
 arch/s390/kvm/kvm-s390.c                      | 133 ++++++-
 arch/x86/include/asm/kvm_host.h               |   9 +-
 arch/x86/kvm/x86.c                            |  71 +++-
 include/linux/kvm_host.h                      | 132 ++++++-
 include/linux/kvm_types.h                     |  12 +
 include/uapi/linux/kvm.h                      |  50 +++
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   3 +
 .../testing/selftests/kvm/include/kvm_util.h  |   3 +
 .../selftests/kvm/kvm_bin_form_stats.c        | 370 ++++++++++++++++++
 tools/testing/selftests/kvm/lib/kvm_util.c    |  11 +
 virt/kvm/kvm_main.c                           | 237 ++++++++++-
 24 files changed, 1405 insertions(+), 90 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/kvm_bin_form_stats.c


base-commit: edf408f5257ba39e63781b820528e1ce1ec0f543
-- 
2.31.1.498.g6c1eba8ee3d-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
