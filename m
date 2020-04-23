Return-Path: <SRS0=c4fT=6H=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6123FC55193
	for <kvmarm@archiver.kernel.org>; Thu, 23 Apr 2020 17:39:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 20E5D20736
	for <kvmarm@archiver.kernel.org>; Thu, 23 Apr 2020 17:39:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 20E5D20736
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CF1354B19E;
	Thu, 23 Apr 2020 13:39:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vA06+5FpCZkT; Thu, 23 Apr 2020 13:39:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A4E504B1B7;
	Thu, 23 Apr 2020 13:39:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5D2EC4B194
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Apr 2020 13:39:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bQCNUZ9qJ3r5 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 23 Apr 2020 13:39:09 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 49D0F4B19C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Apr 2020 13:39:09 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F346D11B3;
 Thu, 23 Apr 2020 10:39:08 -0700 (PDT)
Received: from localhost.localdomain (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8E9A53F68F;
 Thu, 23 Apr 2020 10:39:07 -0700 (PDT)
From: Andre Przywara <andre.przywara@arm.com>
To: Will Deacon <will@kernel.org>,
 Julien Thierry <julien.thierry.kdev@gmail.com>
Subject: [PATCH kvmtool v4 4/5] memslot: Add support for READONLY mappings
Date: Thu, 23 Apr 2020 18:38:43 +0100
Message-Id: <20200423173844.24220-5-andre.przywara@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200423173844.24220-1-andre.przywara@arm.com>
References: <20200423173844.24220-1-andre.przywara@arm.com>
Cc: kvm@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
 Raphael Gault <raphael.gault@arm.com>, Sami Mujawar <sami.mujawar@arm.com>,
 kvmarm@lists.cs.columbia.edu
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

A KVM memslot has a flags field, which allows to mark a region as
read-only.
Add another memory type bit to allow kvmtool-internal users to map a
write-protected region. Write access would trap and can be handled by
the MMIO emulation, which should register on the same guest address
region.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 include/kvm/kvm.h | 12 ++++++++----
 kvm.c             |  5 +++++
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/include/kvm/kvm.h b/include/kvm/kvm.h
index 9428f57a..53373b08 100644
--- a/include/kvm/kvm.h
+++ b/include/kvm/kvm.h
@@ -40,10 +40,12 @@ enum kvm_mem_type {
 	KVM_MEM_TYPE_RAM	= 1 << 0,
 	KVM_MEM_TYPE_DEVICE	= 1 << 1,
 	KVM_MEM_TYPE_RESERVED	= 1 << 2,
+	KVM_MEM_TYPE_READONLY	= 1 << 3,
 
 	KVM_MEM_TYPE_ALL	= KVM_MEM_TYPE_RAM
 				| KVM_MEM_TYPE_DEVICE
 				| KVM_MEM_TYPE_RESERVED
+				| KVM_MEM_TYPE_READONLY
 };
 
 struct kvm_ext {
@@ -158,17 +160,19 @@ u64 host_to_guest_flat(struct kvm *kvm, void *ptr);
 bool kvm__arch_load_kernel_image(struct kvm *kvm, int fd_kernel, int fd_initrd,
 				 const char *kernel_cmdline);
 
+#define add_read_only(type, str)					\
+	(((type) & KVM_MEM_TYPE_READONLY) ? str " (read-only)" : str)
 static inline const char *kvm_mem_type_to_string(enum kvm_mem_type type)
 {
-	switch (type) {
+	switch (type & ~KVM_MEM_TYPE_READONLY) {
 	case KVM_MEM_TYPE_ALL:
 		return "(all)";
 	case KVM_MEM_TYPE_RAM:
-		return "RAM";
+		return add_read_only(type, "RAM");
 	case KVM_MEM_TYPE_DEVICE:
-		return "device";
+		return add_read_only(type, "device");
 	case KVM_MEM_TYPE_RESERVED:
-		return "reserved";
+		return add_read_only(type, "reserved");
 	}
 
 	return "???";
diff --git a/kvm.c b/kvm.c
index 26f6b9bc..e327541d 100644
--- a/kvm.c
+++ b/kvm.c
@@ -242,6 +242,7 @@ int kvm__register_mem(struct kvm *kvm, u64 guest_phys, u64 size,
 	struct kvm_mem_bank *bank;
 	struct list_head *prev_entry;
 	u32 slot;
+	u32 flags = 0;
 	int ret;
 
 	mutex_lock(&kvm->mem_banks_lock);
@@ -313,9 +314,13 @@ int kvm__register_mem(struct kvm *kvm, u64 guest_phys, u64 size,
 	bank->type			= type;
 	bank->slot			= slot;
 
+	if (type & KVM_MEM_TYPE_READONLY)
+		flags |= KVM_MEM_READONLY;
+
 	if (type != KVM_MEM_TYPE_RESERVED) {
 		mem = (struct kvm_userspace_memory_region) {
 			.slot			= slot,
+			.flags			= flags,
 			.guest_phys_addr	= guest_phys,
 			.memory_size		= size,
 			.userspace_addr		= (unsigned long)userspace_addr,
-- 
2.17.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
