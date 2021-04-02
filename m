Return-Path: <SRS0=9BEn=I7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31F8CC43461
	for <kvmarm@archiver.kernel.org>; Fri,  2 Apr 2021 22:44:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 933CC611AC
	for <kvmarm@archiver.kernel.org>; Fri,  2 Apr 2021 22:44:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 933CC611AC
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0B9794B2FA;
	Fri,  2 Apr 2021 18:44:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hrip3IV6eTwn; Fri,  2 Apr 2021 18:44:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C39C54B22E;
	Fri,  2 Apr 2021 18:44:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E8044B202
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Apr 2021 18:44:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id V5eKrCpE4-OE for <kvmarm@lists.cs.columbia.edu>;
 Fri,  2 Apr 2021 18:44:14 -0400 (EDT)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0675F4B1CC
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Apr 2021 18:44:13 -0400 (EDT)
Received: by mail-yb1-f202.google.com with SMTP id 10so10764942ybx.11
 for <kvmarm@lists.cs.columbia.edu>; Fri, 02 Apr 2021 15:44:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=irIfy9SDJhrUqaDE5ZN6w1PVEQaG5IbsoR3bDTu0jl4=;
 b=oINmMmgMmoW/oyIcAkt+qHnpbVapAHO0BtBXorG5hnuc57P8B5zKJ7zBvQRstcANLe
 g5n4RamBX4W+J0lM7mec5Dp6K9/13ohk6ZXhVLCPFigMH64M84+iBExfaQf9hmAzQUiH
 bZY7VNQunFlIiJhRNQFdKfJbFOB0Z5ctHSCkx6H0TH0GoqpNH18oGgLzf1ZN153zxYSn
 am8EWHgEB72tVSDwUwtxKSTamIpb7vD/rP8Huv89Yo4aqk6V3/tf8JCDm3oqnXL+hCsQ
 02z6sYthCN9r+ritpQhL7w8X3C0Qqdj7AVHhTJsVELFIHoQjykQwl0v9h8r/bTrDVKjH
 X99w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=irIfy9SDJhrUqaDE5ZN6w1PVEQaG5IbsoR3bDTu0jl4=;
 b=m34pOYbS4llbSGqvbdjTWgqZkthvDSAlOIZDdlvkcJHyBJzImSMhjTTaEQXr8mGVRr
 67J+QryV8HFqDuj5Q2sw8AcIVmuB1WxmyyaFtpO16Gkqhi1X8l7LOx9AtgGTUCZeWCNO
 uJ8Iv5YsIGYCGjdxC1NTxXfqW1iBqYRwOKhq/XZIHacrNwuX+5vrsbUcyhklYm2HAk1L
 59PFmY/idxXvoPA+as/JxDbOyay5exanpKdcbWRFLb4Yvg0YgfXquCL/yXJ12t771LL1
 HNkvcOmcEnkritVPGL7nxRrV2Y3+YwdGI0yLnPb64VuobRlPqCDg1ehHF14SH1CmMH5N
 qI9Q==
X-Gm-Message-State: AOAM533qRTRUajfdpHYa1vgP8GTF9T1VviwDJJz00mpzyoVyRgt4JbQI
 1k7bbKSMD+0BwPRhruEiLYxTE7Rrg9uEKgps1Q==
X-Google-Smtp-Source: ABdhPJyjY/9bgZ4cfSTi5H9NxDPqiTmNCSs6veZkAE2t6SvpxZwTxmf38XzA4gMlvXfjJgmYTh/5eLdnr+RrZ8+4Rw==
X-Received: from jingzhangos.c.googlers.com
 ([fda3:e722:ac3:10:2b:ff92:c0a8:513])
 (user=jingzhangos job=sendgmr) by 2002:a25:4dc4:: with SMTP id
 a187mr21783146ybb.78.1617403453215; Fri, 02 Apr 2021 15:44:13 -0700 (PDT)
Date: Fri,  2 Apr 2021 22:43:55 +0000
Message-Id: <20210402224359.2297157-1-jingzhangos@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.0.208.g409f899ff0-goog
Subject: [PATCH 0/4] KVM statistics data fd-based binary interface
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

Jing Zhang (4):
  KVM: stats: Separate common stats from architecture specific ones
  KVM: stats: Add fd-based API to read binary stats data
  KVM: stats: Add documentation for statistics data binary interface
  KVM: selftests: Add selftest for KVM statistics data binary interface

 Documentation/virt/kvm/api.rst                | 169 ++++++++
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
 include/uapi/linux/kvm.h                      |  48 +++
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   3 +
 .../testing/selftests/kvm/include/kvm_util.h  |   3 +
 .../selftests/kvm/kvm_bin_form_stats.c        | 370 ++++++++++++++++++
 tools/testing/selftests/kvm/lib/kvm_util.c    |  11 +
 virt/kvm/kvm_main.c                           | 237 ++++++++++-
 24 files changed, 1401 insertions(+), 90 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/kvm_bin_form_stats.c


base-commit: f96be2deac9bca3ef5a2b0b66b71fcef8bad586d
-- 
2.31.0.208.g409f899ff0-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
