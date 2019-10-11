Return-Path: <SRS0=GvsF=YE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9847EC47404
	for <kvmarm@archiver.kernel.org>; Fri, 11 Oct 2019 11:07:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5CB1C21D71
	for <kvmarm@archiver.kernel.org>; Fri, 11 Oct 2019 11:07:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5CB1C21D71
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DCEFF4A8BF;
	Fri, 11 Oct 2019 07:07:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xFEuLvQeU6Bc; Fri, 11 Oct 2019 07:07:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 758F74A8D1;
	Fri, 11 Oct 2019 07:07:27 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 981204A8B0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Oct 2019 07:07:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3KZv70zhmLgm for <kvmarm@lists.cs.columbia.edu>;
 Fri, 11 Oct 2019 07:07:25 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 428594A873
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Oct 2019 07:07:25 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EFAA51570;
 Fri, 11 Oct 2019 04:07:24 -0700 (PDT)
Received: from localhost (e113682-lin.copenhagen.arm.com [10.32.145.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 655803F703;
 Fri, 11 Oct 2019 04:07:24 -0700 (PDT)
From: Christoffer Dall <christoffer.dall@arm.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [kvmtool v3 5/5] arm: Inject external data aborts when accessing
 holes in the memory map
Date: Fri, 11 Oct 2019 13:07:09 +0200
Message-Id: <20191011110709.2764-6-christoffer.dall@arm.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20191011110709.2764-1-christoffer.dall@arm.com>
References: <20191011110709.2764-1-christoffer.dall@arm.com>
Cc: =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
 Marc Zyngier <maz@kernel.org>, Stefan Hajnoczi <stefanha@redhat.com>,
 Heinrich Schuchardt <xypron.glpk@gmx.de>, linux-arm-kernel@lists.infradead.org
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
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Occasionally guests will attempt to access parts of the guest memory map
where there is... nothing at all.  Until now, we've handled this by
either forcefully killing the guest, or silently (unless a debug option
was enabled) ignoring the access.  Neither is very helpful to a user,
who is most likely running either a broken or misconfigured guest.

A more appropriate action is to inject an external abort to the guest.
Luckily, with KVM_CAP_ARM_INJECT_EXT_DABT, we can use the set event
mechanism and ask KVM to do this for us.

So we add an architecture specific hook to handle accesses to MMIO
regions which cannot be found, and allow them to return if the invalid
access was handled or not.

Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
---
 arm/include/arm-common/kvm-cpu-arch.h | 16 ++++++++++++++++
 arm/kvm-cpu.c                         |  2 +-
 mips/include/kvm/kvm-cpu-arch.h       |  5 +++++
 mmio.c                                |  3 ++-
 powerpc/include/kvm/kvm-cpu-arch.h    |  5 +++++
 x86/include/kvm/kvm-cpu-arch.h        |  5 +++++
 6 files changed, 34 insertions(+), 2 deletions(-)

diff --git a/arm/include/arm-common/kvm-cpu-arch.h b/arm/include/arm-common/kvm-cpu-arch.h
index 923d2c4..33defa2 100644
--- a/arm/include/arm-common/kvm-cpu-arch.h
+++ b/arm/include/arm-common/kvm-cpu-arch.h
@@ -57,6 +57,22 @@ static inline bool kvm_cpu__emulate_mmio(struct kvm_cpu *vcpu, u64 phys_addr,
 	return kvm__emulate_mmio(vcpu, phys_addr, data, len, is_write);
 }
 
+static inline bool kvm_cpu__mmio_not_found(struct kvm_cpu *vcpu, u64 phys_addr)
+{
+	struct kvm_vcpu_events events = {
+		.exception.ext_dabt_pending = 1,
+	};
+	int err;
+
+	if (!kvm__supports_extension(vcpu->kvm, KVM_CAP_ARM_INJECT_EXT_DABT))
+		return false;
+
+	err = ioctl(vcpu->vcpu_fd, KVM_SET_VCPU_EVENTS, &events);
+	if (err)
+		die("failed to inject external abort");
+	return true;
+}
+
 unsigned long kvm_cpu__get_vcpu_mpidr(struct kvm_cpu *vcpu);
 
 #endif /* ARM_COMMON__KVM_CPU_ARCH_H */
diff --git a/arm/kvm-cpu.c b/arm/kvm-cpu.c
index 25bd3ed..321a3e4 100644
--- a/arm/kvm-cpu.c
+++ b/arm/kvm-cpu.c
@@ -142,7 +142,7 @@ bool kvm_cpu__handle_exit(struct kvm_cpu *vcpu)
 
 		if (!arm_addr_in_ioport_region(phys_addr) &&
 		    !kvm__mmio_exists(vcpu, phys_addr))
-			die("Guest accessed memory outside RAM and IO ranges");
+			return kvm_cpu__mmio_not_found(vcpu, phys_addr);
 
 		/*
 		 * We cannot fetch and decode instructions from a KVM guest,
diff --git a/mips/include/kvm/kvm-cpu-arch.h b/mips/include/kvm/kvm-cpu-arch.h
index 45e69f6..512ab34 100644
--- a/mips/include/kvm/kvm-cpu-arch.h
+++ b/mips/include/kvm/kvm-cpu-arch.h
@@ -40,4 +40,9 @@ static inline bool kvm_cpu__emulate_mmio(struct kvm_cpu *vcpu, u64 phys_addr, u8
 	return kvm__emulate_mmio(vcpu, phys_addr, data, len, is_write);
 }
 
+static inline bool kvm_cpu__mmio_not_found(struct kvm_cpu *vcpu, u64 phys_addr)
+{
+	return false;
+}
+
 #endif /* KVM__KVM_CPU_ARCH_H */
diff --git a/mmio.c b/mmio.c
index 2ab7fa7..d6df303 100644
--- a/mmio.c
+++ b/mmio.c
@@ -130,7 +130,8 @@ bool kvm__emulate_mmio(struct kvm_cpu *vcpu, u64 phys_addr, u8 *data, u32 len, u
 	if (mmio)
 		mmio->mmio_fn(vcpu, phys_addr, data, len, is_write, mmio->ptr);
 	else {
-		if (vcpu->kvm->cfg.mmio_debug)
+		if (!kvm_cpu__mmio_not_found(vcpu, phys_addr) &&
+		    vcpu->kvm->cfg.mmio_debug)
 			fprintf(stderr,	"Warning: Ignoring MMIO %s at %016llx (length %u)\n",
 				to_direction(is_write),
 				(unsigned long long)phys_addr, len);
diff --git a/powerpc/include/kvm/kvm-cpu-arch.h b/powerpc/include/kvm/kvm-cpu-arch.h
index a69e0cc..64b69b1 100644
--- a/powerpc/include/kvm/kvm-cpu-arch.h
+++ b/powerpc/include/kvm/kvm-cpu-arch.h
@@ -76,4 +76,9 @@ static inline bool kvm_cpu__emulate_io(struct kvm_cpu *vcpu, u16 port, void *dat
 
 bool kvm_cpu__emulate_mmio(struct kvm_cpu *vcpu, u64 phys_addr, u8 *data, u32 len, u8 is_write);
 
+static inline bool kvm_cpu__mmio_not_found(struct kvm_cpu *vcpu, u64 phys_addr)
+{
+	return false;
+}
+
 #endif /* KVM__KVM_CPU_ARCH_H */
diff --git a/x86/include/kvm/kvm-cpu-arch.h b/x86/include/kvm/kvm-cpu-arch.h
index 05e5bb6..10cbe6e 100644
--- a/x86/include/kvm/kvm-cpu-arch.h
+++ b/x86/include/kvm/kvm-cpu-arch.h
@@ -47,4 +47,9 @@ static inline bool kvm_cpu__emulate_mmio(struct kvm_cpu *vcpu, u64 phys_addr, u8
 	return kvm__emulate_mmio(vcpu, phys_addr, data, len, is_write);
 }
 
+static inline bool kvm_cpu__mmio_not_found(struct kvm_cpu *vcpu, u64 phys_addr)
+{
+	return false;
+}
+
 #endif /* KVM__KVM_CPU_ARCH_H */
-- 
2.18.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
