Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FCA4C433EF
	for <kvmarm@archiver.kernel.org>; Mon, 16 May 2022 15:55:37 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D575C4B29C;
	Mon, 16 May 2022 11:55:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id RTHHWOA4tN+w; Mon, 16 May 2022 11:55:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A6A604B2A0;
	Mon, 16 May 2022 11:55:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0ADB24B291
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 May 2022 11:55:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZY4S0Ve1Es1u for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 May 2022 11:55:32 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B26034B29C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 May 2022 11:55:31 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6AFD31063;
 Mon, 16 May 2022 08:55:31 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 051CA3F881;
 Mon, 16 May 2022 08:55:29 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: will@kernel.org, julien.thierry.kdev@gmail.com, maz@kernel.org,
 suzuki.poulose@arm.com, julien@xen.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 james.morse@arm.com
Subject: [PATCH v2 kvmtool 05/12] arm/arm64: Fail if RAM size is too large for
 32-bit guests
Date: Mon, 16 May 2022 16:55:19 +0100
Message-Id: <20220516155526.181694-6-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516155526.181694-1-alexandru.elisei@arm.com>
References: <20220516155526.181694-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
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

For 64-bit guests, kvmtool exists with an error in kvm__get_vm_type() if
the memory size is larger than what KVM supports. For 32-bit guests, the
RAM size is silently rounded down to ARM_LOMAP_MAX_MEMORY in
kvm__arch_init().

Be consistent and exit with an error when the user has configured the
wrong RAM size for 32-bit guests.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/aarch32/kvm.c | 4 ++++
 arm/aarch64/kvm.c | 5 +++++
 arm/kvm.c         | 2 +-
 3 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/arm/aarch32/kvm.c b/arm/aarch32/kvm.c
index ae33ac92479a..9d68d7a15ee2 100644
--- a/arm/aarch32/kvm.c
+++ b/arm/aarch32/kvm.c
@@ -2,4 +2,8 @@
 
 void kvm__arch_validate_cfg(struct kvm *kvm)
 {
+	if (kvm->cfg.ram_size > ARM_LOMAP_MAX_MEMORY) {
+		die("RAM size 0x%llx exceeds maximum allowed 0x%llx",
+		    kvm->cfg.ram_size, ARM_LOMAP_MAX_MEMORY);
+	}
 }
diff --git a/arm/aarch64/kvm.c b/arm/aarch64/kvm.c
index 46f20e5a5a86..5db8e295c433 100644
--- a/arm/aarch64/kvm.c
+++ b/arm/aarch64/kvm.c
@@ -39,6 +39,11 @@ int vcpu_affinity_parser(const struct option *opt, const char *arg, int unset)
 
 void kvm__arch_validate_cfg(struct kvm *kvm)
 {
+	if (kvm->cfg.arch.aarch32_guest &&
+	    kvm->cfg.ram_size > ARM_LOMAP_MAX_MEMORY) {
+		die("RAM size 0x%llx exceeds maximum allowed 0x%llx",
+		    kvm->cfg.ram_size, ARM_LOMAP_MAX_MEMORY);
+	}
 }
 
 /*
diff --git a/arm/kvm.c b/arm/kvm.c
index c5913000e1ed..af0feae495d7 100644
--- a/arm/kvm.c
+++ b/arm/kvm.c
@@ -65,7 +65,7 @@ void kvm__arch_init(struct kvm *kvm, const char *hugetlbfs_path, u64 ram_size)
 	 * If using THP, then our minimal alignment becomes 2M.
 	 * 2M trumps 64K, so let's go with that.
 	 */
-	kvm->ram_size = min(ram_size, (u64)ARM_MAX_MEMORY(kvm));
+	kvm->ram_size = ram_size;
 	kvm->arch.ram_alloc_size = kvm->ram_size + SZ_2M;
 	kvm->arch.ram_alloc_start = mmap_anon_or_hugetlbfs(kvm, hugetlbfs_path,
 						kvm->arch.ram_alloc_size);
-- 
2.36.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
