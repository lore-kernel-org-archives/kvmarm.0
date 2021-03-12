Return-Path: <SRS0=ChHZ=IK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27EDCC433E6
	for <kvmarm@archiver.kernel.org>; Fri, 12 Mar 2021 15:19:31 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B52A964FEE
	for <kvmarm@archiver.kernel.org>; Fri, 12 Mar 2021 15:19:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B52A964FEE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6B8D04B4DF;
	Fri, 12 Mar 2021 10:19:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id LZiFR2zqwT1U; Fri, 12 Mar 2021 10:19:29 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 225184B548;
	Fri, 12 Mar 2021 10:19:29 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B5D5A4B544
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Mar 2021 10:19:28 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rTWnYrNEJXyc for <kvmarm@lists.cs.columbia.edu>;
 Fri, 12 Mar 2021 10:19:27 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 696AF4B4B9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Mar 2021 10:19:27 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 17F161063;
 Fri, 12 Mar 2021 07:19:27 -0800 (PST)
Received: from e112269-lin.arm.com (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 402213F7D7;
 Fri, 12 Mar 2021 07:19:24 -0800 (PST)
From: Steven Price <steven.price@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>
Subject: [PATCH v10 5/6] KVM: arm64: ioctl to fetch/store tags in a guest
Date: Fri, 12 Mar 2021 15:19:01 +0000
Message-Id: <20210312151902.17853-6-steven.price@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210312151902.17853-1-steven.price@arm.com>
References: <20210312151902.17853-1-steven.price@arm.com>
MIME-Version: 1.0
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>, qemu-devel@nongnu.org,
 Dave Martin <Dave.Martin@arm.com>, Juan Quintela <quintela@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>, linux-kernel@vger.kernel.org,
 Steven Price <steven.price@arm.com>, Thomas Gleixner <tglx@linutronix.de>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

The VMM may not wish to have it's own mapping of guest memory mapped
with PROT_MTE because this causes problems if the VMM has tag checking
enabled (the guest controls the tags in physical RAM and it's unlikely
the tags are correct for the VMM).

Instead add a new ioctl which allows the VMM to easily read/write the
tags from guest memory, allowing the VMM's mapping to be non-PROT_MTE
while the VMM can still read/write the tags for the purpose of
migration.

Signed-off-by: Steven Price <steven.price@arm.com>
---
 arch/arm64/include/uapi/asm/kvm.h | 14 +++++++
 arch/arm64/kvm/arm.c              | 69 +++++++++++++++++++++++++++++++
 include/uapi/linux/kvm.h          |  1 +
 3 files changed, 84 insertions(+)

diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 24223adae150..2b85a047c37d 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -184,6 +184,20 @@ struct kvm_vcpu_events {
 	__u32 reserved[12];
 };
 
+struct kvm_arm_copy_mte_tags {
+	__u64 guest_ipa;
+	__u64 length;
+	union {
+		void __user *addr;
+		__u64 padding;
+	};
+	__u64 flags;
+	__u64 reserved[2];
+};
+
+#define KVM_ARM_TAGS_TO_GUEST		0
+#define KVM_ARM_TAGS_FROM_GUEST		1
+
 /* If you need to interpret the index values, here is the key: */
 #define KVM_REG_ARM_COPROC_MASK		0x000000000FFF0000
 #define KVM_REG_ARM_COPROC_SHIFT	16
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 46bf319f6cb7..9a6b26d37236 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1297,6 +1297,65 @@ static int kvm_vm_ioctl_set_device_addr(struct kvm *kvm,
 	}
 }
 
+static int kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
+				      struct kvm_arm_copy_mte_tags *copy_tags)
+{
+	gpa_t guest_ipa = copy_tags->guest_ipa;
+	size_t length = copy_tags->length;
+	void __user *tags = copy_tags->addr;
+	gpa_t gfn;
+	bool write = !(copy_tags->flags & KVM_ARM_TAGS_FROM_GUEST);
+	int ret = 0;
+
+	if (copy_tags->reserved[0] || copy_tags->reserved[1])
+		return -EINVAL;
+
+	if (copy_tags->flags & ~KVM_ARM_TAGS_FROM_GUEST)
+		return -EINVAL;
+
+	if (length & ~PAGE_MASK || guest_ipa & ~PAGE_MASK)
+		return -EINVAL;
+
+	gfn = gpa_to_gfn(guest_ipa);
+
+	mutex_lock(&kvm->slots_lock);
+
+	while (length > 0) {
+		kvm_pfn_t pfn = gfn_to_pfn_prot(kvm, gfn, write, NULL);
+		void *maddr;
+		unsigned long num_tags = PAGE_SIZE / MTE_GRANULE_SIZE;
+
+		if (is_error_noslot_pfn(pfn)) {
+			ret = -EFAULT;
+			goto out;
+		}
+
+		maddr = page_address(pfn_to_page(pfn));
+
+		if (!write) {
+			num_tags = mte_copy_tags_to_user(tags, maddr, num_tags);
+			kvm_release_pfn_clean(pfn);
+		} else {
+			num_tags = mte_copy_tags_from_user(maddr, tags,
+							   num_tags);
+			kvm_release_pfn_dirty(pfn);
+		}
+
+		if (num_tags != PAGE_SIZE / MTE_GRANULE_SIZE) {
+			ret = -EFAULT;
+			goto out;
+		}
+
+		gfn++;
+		tags += num_tags;
+		length -= PAGE_SIZE;
+	}
+
+out:
+	mutex_unlock(&kvm->slots_lock);
+	return ret;
+}
+
 long kvm_arch_vm_ioctl(struct file *filp,
 		       unsigned int ioctl, unsigned long arg)
 {
@@ -1333,6 +1392,16 @@ long kvm_arch_vm_ioctl(struct file *filp,
 
 		return 0;
 	}
+	case KVM_ARM_MTE_COPY_TAGS: {
+		struct kvm_arm_copy_mte_tags copy_tags;
+
+		if (!kvm_has_mte(kvm))
+			return -EINVAL;
+
+		if (copy_from_user(&copy_tags, argp, sizeof(copy_tags)))
+			return -EFAULT;
+		return kvm_vm_ioctl_mte_copy_tags(kvm, &copy_tags);
+	}
 	default:
 		return -EINVAL;
 	}
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 6dc16c09a2d1..470c122f4c2d 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1424,6 +1424,7 @@ struct kvm_s390_ucas_mapping {
 /* Available with KVM_CAP_PMU_EVENT_FILTER */
 #define KVM_SET_PMU_EVENT_FILTER  _IOW(KVMIO,  0xb2, struct kvm_pmu_event_filter)
 #define KVM_PPC_SVM_OFF		  _IO(KVMIO,  0xb3)
+#define KVM_ARM_MTE_COPY_TAGS	  _IOR(KVMIO,  0xb4, struct kvm_arm_copy_mte_tags)
 
 /* ioctl for vm fd */
 #define KVM_CREATE_DEVICE	  _IOWR(KVMIO,  0xe0, struct kvm_create_device)
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
