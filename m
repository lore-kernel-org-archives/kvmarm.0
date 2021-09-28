Return-Path: <SRS0=Tw+U=OS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A8B5C433F5
	for <kvmarm@archiver.kernel.org>; Tue, 28 Sep 2021 18:48:12 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7840B61209
	for <kvmarm@archiver.kernel.org>; Tue, 28 Sep 2021 18:48:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 7840B61209
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E1FA7407E7;
	Tue, 28 Sep 2021 14:48:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vhwNPhohsTw7; Tue, 28 Sep 2021 14:48:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9B76D4B0DB;
	Tue, 28 Sep 2021 14:48:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C1A6F4B0B6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Sep 2021 14:48:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WgGUpA24BVl4 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 Sep 2021 14:48:07 -0400 (EDT)
Received: from mail-qt1-f201.google.com (mail-qt1-f201.google.com
 [209.85.160.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id ADC91407E7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Sep 2021 14:48:07 -0400 (EDT)
Received: by mail-qt1-f201.google.com with SMTP id
 w10-20020ac87e8a000000b002a68361412bso102110924qtj.7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Sep 2021 11:48:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=qgqb6YKppRB8NfJVVv7xfeFr8BtHiKUWj2cOAf7GOM8=;
 b=TLC2VRgTW9eZlhKSjXJgG6luzYm1j8ILJoYprMicHRJoF5l8NyLTLIX2KZegIO/n/Y
 dv8/Z+h+iE5VBQP2KtRDTqg88Y6iS7IgJz7+69qP1G6FycrEVvhHCO34pqMP0JRZl64l
 8+gnFDiA+Vyfud7PCbBBzuAL1TUDBqHcnpO5WDzEPDGa5JzrVrNFijCCgSXjbvbA7bFB
 ixGCjz5lzQKTqRVXoELXTADjslwCiLxJzaCiEx1+sNRDekV9NuU0Qv3wvVlZr9CpLoJD
 5+rzFq4vU+Bo+PgypWAUMgHTb1+6dZN/g4RoQnF05tSkT3Y3zDxenkP2jgYAF12de9Rl
 EvIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=qgqb6YKppRB8NfJVVv7xfeFr8BtHiKUWj2cOAf7GOM8=;
 b=QaGbdqIJre+qDOq2ocqBXAO4sMCT6bsIKJqlB+hwnlAYynZ+LOGug9+Z62+fakpA7X
 i7jJwzu/xd+mHOl69mzeEMQ5Svm1CDd0ATGyGAi0zP4/tP0HJC23z/2Gs3aWXQZZ/+go
 aGI8X492IQCNyPEirwHwGyjI9VzlDBZ+LgSK9ZMJgkFCmF/iRu6fOgVjatrHdwYbVXFg
 nAFdqtceIFSUSAFCwvbikGVT3JkK9Ir/VZ1SMCYnvxUrEJlY7Ih79zq2BBm3J95mGVYV
 ETmjS/jSwogkuxdeogdKF8pbEevweFinAJv41tJAtyNaQamXo1ZYy6CyKJhM+5TVddk5
 vasQ==
X-Gm-Message-State: AOAM530vdSZwCN7lIb79FAbTDRBvFT8M2HVU8C4lUMrZCzG1GkXBbfuP
 NeizlyHXbT51zrJMNO8TJk7BNNzhco5rgg==
X-Google-Smtp-Source: ABdhPJxmw0t3Ktxkm3ZcxHbs/rMQve8y9VxdIkWB/eXtfkGFPpQjbY6Vqo64auyj0jWhjiH+kb808xRC3FZlAA==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a05:6214:12ac:: with SMTP id
 w12mr7283357qvu.44.1632854887215; Tue, 28 Sep 2021 11:48:07 -0700 (PDT)
Date: Tue, 28 Sep 2021 11:47:54 -0700
Message-Id: <20210928184803.2496885-1-ricarkol@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [PATCH v3 00/10] KVM: arm64: vgic: Missing checks for REDIST/CPU and
 ITS regions above the VM IPA size
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

KVM doesn't check for redist, CPU interface, and ITS regions that extend
partially above the guest addressable IPA range (phys_size).  This can happen
when using the V[2|3]_ADDR_TYPE_CPU, ADDR_TYPE_REDIST[_REGION], or
ITS_ADDR_TYPE attributes to set a new region that extends partially above
phys_size (with the base below phys_size).  The issue is that vcpus can
potentially run into a situation where some redistributors are addressable and
others are not, or just the first half of the ITS is addressable.

Patches 1-4 fixes the issue for GICv2 and GICv3 (and the ITS). Patches 5-10 add
some selftests for all these fixes. While adding these tests, these add support
for some extra GICv2 and ITS device tests.

Changes:
v3: add missing checks for GICv2 and the ITS, plus tests for the fixes.
v2: adding a test for KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, and returning E2BIG
    instead of EINVAL (thanks Alexandru and Eric).

Ricardo Koller (10):
  kvm: arm64: vgic: Introduce vgic_check_iorange
  KVM: arm64: vgic-v3: Check redist region is not above the VM IPA size
  KVM: arm64: vgic-v2: Check cpu interface region is not above the VM
    IPA size
  KVM: arm64: vgic-v3: Check ITS region is not above the VM IPA size
  KVM: arm64: selftests: Make vgic_init gic version agnostic
  KVM: arm64: selftests: Make vgic_init/vm_gic_create version agnostic
  KVM: arm64: selftests: Add some tests for GICv2 in vgic_init
  KVM: arm64: selftests: Add tests for GIC redist/cpuif partially above
    IPA range
  KVM: arm64: selftests: Add test for legacy GICv3 REDIST base partially
    above IPA range
  KVM: arm64: selftests: Add basic ITS device tests

 arch/arm64/kvm/vgic/vgic-its.c                |   4 +-
 arch/arm64/kvm/vgic/vgic-kvm-device.c         |  29 +-
 arch/arm64/kvm/vgic/vgic-mmio-v3.c            |   6 +-
 arch/arm64/kvm/vgic/vgic-v3.c                 |   4 +
 arch/arm64/kvm/vgic/vgic.h                    |   4 +
 .../testing/selftests/kvm/aarch64/vgic_init.c | 372 +++++++++++++-----
 6 files changed, 317 insertions(+), 102 deletions(-)

-- 
2.33.0.685.g46640cef36-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
