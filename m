Return-Path: <SRS0=f6Gw=II=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFA4DC433E0
	for <kvmarm@archiver.kernel.org>; Wed, 10 Mar 2021 00:30:46 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 481626510B
	for <kvmarm@archiver.kernel.org>; Wed, 10 Mar 2021 00:30:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 481626510B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AEC5B4B58A;
	Tue,  9 Mar 2021 19:30:45 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MeYnZrJZXBU7; Tue,  9 Mar 2021 19:30:44 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A58AB4B572;
	Tue,  9 Mar 2021 19:30:44 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9DB7C4B39A
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Mar 2021 19:30:43 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MaP9ZXwEtvNF for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Mar 2021 19:30:42 -0500 (EST)
Received: from mail-io1-f74.google.com (mail-io1-f74.google.com
 [209.85.166.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A0C294B133
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Mar 2021 19:30:42 -0500 (EST)
Received: by mail-io1-f74.google.com with SMTP id x9so9368143iob.5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 09 Mar 2021 16:30:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=1BcHrgVIevscHGOPbP9Sxwife20LoA3ZZqd9CRbz5Bw=;
 b=DKv71NfHgZl9K+3WTTgnMIMFhTJhw0KdiZ+0DsSSoWMbruSU8JYpotmsteHcMpFnKP
 p3oJl9d7poG/uNqx9QVjZxRsDg84eU0xeqR/z3zNbVYX8v/8Pqaq2D2o6XtuLtoQIAWn
 XZIko6RjucQT9l8eCAbgMb2o84jv4v0MYqAUW+gbWQ/6DAdn7cgT09hkIvc7uvV40U3/
 OXNI1psrB1fZwZO3xGQK35hCSkEnWUaO1l3/peXbxmeOQdZwn1Qj3XsVRuxh8uptWwNf
 ZpoGFHSOUGyGujS8e+ldyI4tL/z2BcdRYhlTSsMqOPaw7n36OXxIcUJIiplu0hMkQaNX
 IFPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=1BcHrgVIevscHGOPbP9Sxwife20LoA3ZZqd9CRbz5Bw=;
 b=I6rxgbulGOMsGqZlKYQVbtvJhVptkygFAroCEqLxfrjTgRUsWF4PM2QyDQM1UjazpV
 TeYv9XOk82kyz3SpbACNiwYunhVmeje39l/yyB3IX9GrqW3odvZRkD8/NevYQ28FH5Jr
 IIJCkYgQrt6ZUxQTayBXx/k47Yf6ke/AEWzW5Efe1OkZYsnjFY0jmUIglYE2jEwh8weS
 dXte2TlIIxNPETek2YnQNDG+TCx23Wm+Uxpsl1tQO2AkarWNEUtrcFMHrAzO3QGXkGOn
 G+eHsBhG2sYPv3JnOEH5fAZ42tJ98UA3lWi40mnuSU/iaXk8qq4Io1bJhUp0DfYsB2Ab
 TAGQ==
X-Gm-Message-State: AOAM533dJv1+bxqhrjjDt3lCilVcOfvFKRkj/J4qOlesuA6FsnWNuF8L
 p8Sx6d8KNShGs1pTJkmJ+hUgE6iPKzLXiN/YRg==
X-Google-Smtp-Source: ABdhPJzu6oYBav/oVxbZg4DkYFlYy8mfxqu7QjB5WE/gplPDgic3NrLr6r8qLWmnqz7/bt/7iNP/OuQ+NB4k0O9fnQ==
X-Received: from jingzhangos.c.googlers.com
 ([fda3:e722:ac3:10:2b:ff92:c0a8:513])
 (user=jingzhangos job=sendgmr) by 2002:a92:b00d:: with SMTP id
 x13mr708430ilh.128.1615336242003; Tue, 09 Mar 2021 16:30:42 -0800 (PST)
Date: Wed, 10 Mar 2021 00:30:20 +0000
Message-Id: <20210310003024.2026253-1-jingzhangos@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [RFC PATCH 0/4] KVM: stats: Retrieve statistics data in binary format
From: Jing Zhang <jingzhangos@google.com>
To: KVM <kvm@vger.kernel.org>, KVM ARM <kvmarm@lists.cs.columbia.edu>, 
 Linux MIPS <linux-mips@vger.kernel.org>, KVM PPC <kvm-ppc@vger.kernel.org>, 
 Linux S390 <linux-s390@vger.kernel.org>, 
 Linux kselftest <linux-kselftest@vger.kernel.org>,
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

This patchset extends IOCTL interface to retrieve KVM statistics data
in aggregated binary format.
It is meant to provide a lightweight, flexible, scalable and efficient 
lock-free solution for userspace telemetry applications to pull the
statistics data periodically for large scale systems.
The capability is indicated by KVM_CAP_STATS_BINARY_FORM.
Ioctl KVM_STATS_GET_INFO is used to get the information about VM or
vCPU statistics data (The number of supported statistics data which is
used for buffer allocation).
Ioctl KVM_STATS_GET_NAMES is used to get the list of name strings of
all supported statistics data.
Ioctl KVM_STATS_GET_DATA is used to get the aggregated statistics data
per VM or vCPU in the same order as the list of name strings. This is
the ioctl which would be called periodically to retrieve statistics
data per VM or vCPU.

Jing Zhang (4):
  KVM: stats: Separate statistics name strings from debugfs code
  KVM: stats: Define APIs for aggregated stats retrieval in binary
    format
  KVM: stats: Add ioctl commands to pull statistics in binary format
  KVM: selftests: Add selftest for KVM binary form statistics interface

 Documentation/virt/kvm/api.rst                |  79 +++++
 arch/arm64/kvm/guest.c                        |  47 ++-
 arch/mips/kvm/mips.c                          | 114 +++++--
 arch/powerpc/kvm/book3s.c                     | 107 ++++--
 arch/powerpc/kvm/booke.c                      |  84 +++--
 arch/s390/kvm/kvm-s390.c                      | 320 ++++++++++++------
 arch/x86/kvm/x86.c                            | 127 ++++---
 include/linux/kvm_host.h                      |  30 +-
 include/uapi/linux/kvm.h                      |  60 ++++
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   3 +
 .../selftests/kvm/kvm_bin_form_stats.c        |  89 +++++
 virt/kvm/kvm_main.c                           | 115 +++++++
 13 files changed, 935 insertions(+), 241 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/kvm_bin_form_stats.c


base-commit: 357ad203d45c0f9d76a8feadbd5a1c5d460c638b
-- 
2.30.1.766.gb4fecdf3b7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
