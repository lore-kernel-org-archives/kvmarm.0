Received: from mail-yx2-f43.google.com (mail-yx2-f43.google.com [74.125.224.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C05A747207A
	for <kvmarm@lists.linux.dev>; Sun, 20 Sep 2026 19:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789933060; cv=none; b=cL9gFiwRLSximtbYKZ/5njUzyqe/+8txWvb/Y2wsmCaVoG/AXBTafi9ZTAMjn28jLmcj8t/wmgPjdrQ3VG8gI+m8hq3ITxVCWA+WS6/GRKec4UkiPyJ85SSTuscEqkBdvTwdm/ea0yNv3XRLheHEXCTPTQH7nZr0IDWnvdTj7k4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789933060; c=relaxed/simple;
	bh=AMlO+48kz8CjqgfUAzZ4A0uztNecrVG46O6/Scvpx20=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KROXcsxgLe3eA6JqcOJ4okEbJSCSqO/8igKIRYGmBi8RAUC4utfo723w71MKMQwbrl+ghQoDDqqCMvJ0d7W+aF4DNKwR25z3Q3f8rk2KfvIewDqojBPhJilU5JVRmuhm+HnPaLDNmqIrGKqHSeRKJ/gGVi0HKC8bpTW7oAQD/Mw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com; spf=pass smtp.mailfrom=soleen.com; dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b=lFEcztQZ; arc=none smtp.client-ip=74.125.224.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=soleen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b="lFEcztQZ"
Received: by mail-yx2-f43.google.com with SMTP id 00721157ae682-895eaf30817so23269417b3.0
        for <kvmarm@lists.linux.dev>; Sun, 20 Sep 2026 12:37:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1789933057; x=1790537857; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=z+0zDYCWnORIsjY8meHJFhyUNQ+KgCcFKzQxoWC/8Bo=;
        b=lFEcztQZ13Va7NU5pmjT9i5yTL0trVUZyFHpzSZvhZmz71BJhztFagTkBsqQr/YeTJ
         aSJ9V3l1nwQva4FpDTALIeaMYitV78AkkqEOjV9KQj4nhhM2pmnUqs/Nvrl/nHHoNTPs
         zjGh2RN1h/UgGygyt3NhPVg+a/N0Q2QLqHI/htCv27M5wROwKyrkYSobZap/3QyPvGKx
         dMDM1HUtZfAqvupY15T4liJBqvDGCJgfjpjJmltYuLEUd53hSVPVI8o+jqPuyvD6/Ete
         oOUmryU6PKOE4fuhOP7ed4gCZGKJQXx5mA7bcjMu34KQ6I64wzOz5QQ9KN+s7zaIt3rg
         WyMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789933057; x=1790537857;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=z+0zDYCWnORIsjY8meHJFhyUNQ+KgCcFKzQxoWC/8Bo=;
        b=cw+yUh2zbtwvRYW2B8UTmGWzTUaKZ3yAmt3qNxP52eO5Wua1VuwYD0ZH8a+geX6o/t
         HNBZTu/DzjSKPeSnTzECqXutsu4rVVw1A+t+ourrVI+CEwrB4VqaOzEYBKSh8mS6lN/G
         cp0wFdMeD1iRb7qD2LKzDqE78arCSLMQ8frJFsw9Rj2IHQCNmo1SM1kSP5JL3QjPA+Ob
         OOUo61yd04yUAag8eOMYIG9oRRS9+eU2kuXD6OdvOUaTgNm/arNXBjQfPxJN8pAlnZkt
         U0mTIR4qILelUPZAoqfNKitBDITzrmtOJhhtycWcDCOAB1vnn9yZPUutmMaV6jFLokyc
         7SFQ==
X-Forwarded-Encrypted: i=1; AKwUvBwiC+ZfAVV5Hygu3/By6GcSliyo+LdI04ciw34cBTfNsaAZjagAaglcQvLm+BJqizaSWRmsqXU=@lists.linux.dev
X-Gm-Message-State: AFuF++nE7XBHP9BZgx7OUREeg/34zefvAiTCg6Em3DxMhaLEppRiZhGY
	3UavMPKAfPJR5Nka20UEasiBi+r+tTT43OYDZSbCc0i4c/VcoRdThlRIfE1R5kLceDo=
X-Gm-Gg: AYBFou3JiScxGSXQ6TjxpA1WCwPqK83Q2sVaQ19tOHvaVEARdS9zJcO2faZ0Kx4xfYe
	ZwiIydcOkeJX7K34KlHxZTl8bT/wDy/qi4A9T1PxDvUsp7QR2CPJjxZ30Wcw2yoIwk/u/6sCPRu
	3rOMYeCooOqCGRMBxYgudD0M6U9BBluyZtGD7VbATnA+Hjj0LM6pSE5qdm0X6LihY/5f32kKG8p
	iqd0rwpW+xQijiFuEntRRrLUAQesr9o2mU2LKM4VPMcDAKlLpLVn9CeaWigFPurPWGr9icLLTGK
	kLNPIfYambEjcnNlURYggYcrfMqPtUW9PFmDBXUdctHxqYRlAYAQIW1oMyVybrngQ3UHuROgdhR
	H+Q7phPfMs+GGUTyBNm6b6l7+PaTiMpnZ3ixv0qA8mvGWzPQdgXO5Pd0bHrfFfejjwdtyGFJO4P
	56kdVFi2g3IEMkmlncDe63x9ZxVeauunBK/ngMZVeX0wN1yhKLtv1NdYterj9vsKjsN7LzARXsf
	jjJS1jSvteoU+b5TPsgt2Kbipts+jNUSaL4k0F2gck94YwIjgKTK/rHMh4vepcO50q11jpv/ET8
	dO7k/xR6mRNM+OMN1vE=
X-Received: by 2002:a05:690e:418c:b0:66a:d2cf:1b8e with SMTP id 956f58d0204a3-6717fc7670amr2083970d50.20.1789933056700;
        Sun, 20 Sep 2026 12:37:36 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67298f64c7esm2656351d50.2.2026.09.20.12.37.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Sep 2026 12:37:35 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	legion@kernel.org,
	kees@kernel.org,
	will@kernel.org,
	ruanjinjie@huawei.com,
	atomlin@atomlin.com,
	rppt@kernel.org,
	jani.nikula@intel.com,
	hamzamahfooz@linux.microsoft.com,
	joey.gouly@arm.com,
	tglx@kernel.org,
	nsc@kernel.org,
	alexandre.chartre@oracle.com,
	james.morse@arm.com,
	dianders@chromium.org,
	bp@alien8.de,
	jpoimboe@kernel.org,
	shuah@kernel.org,
	catalin.marinas@arm.com,
	linux-kbuild@vger.kernel.org,
	linux-arch@vger.kernel.org,
	kvmarm@lists.linux.dev,
	jaredwhite@microsoft.com,
	johan@kernel.org,
	pbonzini@redhat.com,
	mingo@redhat.com,
	linux-mm@kvack.org,
	seanjc@google.com,
	mark.rutland@arm.com,
	vdonnefort@google.com,
	tarunsahu@google.com,
	gshan@redhat.com,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	xur@google.com,
	djbw@kernel.org,
	oupton@kernel.org,
	nogikh@google.com,
	sumitg@nvidia.com,
	linux-kernel@vger.kernel.org,
	zengheng4@huawei.com,
	peterz@infradead.org,
	corbet@lwn.net,
	suzuki.poulose@arm.com,
	luto@kernel.org,
	hpa@zytor.com,
	zhangpengjie2@huawei.com,
	x86@kernel.org,
	yuzenghui@huawei.com,
	jic23@kernel.org,
	ardb@kernel.org,
	pasha.tatashin@soleen.com,
	petr.pavlu@suse.com,
	ryan.roberts@arm.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	dave.hansen@linux.intel.com,
	rdunlap@infradead.org,
	kvm@vger.kernel.org,
	fuad.tabba@linux.dev,
	maz@kernel.org,
	mbenes@suse.cz,
	jgross@suse.com,
	seiden@linux.ibm.com,
	pierre.gondois@arm.com,
	song@kernel.org,
	nathan@kernel.org,
	pmladek@suse.com,
	graf@amazon.com,
	chao.gao@intel.com,
	zhenglifeng1@huawei.com,
	arnd@arndb.de,
	sidnayyar@google.com,
	linux-arm-kernel@lists.infradead.org,
	vladimir.murzin@arm.com,
	kas@kernel.org
Subject: [RFC PATCH 07/46] KVM: luo: Support vCPU file preservation across live updates
Date: Sun, 20 Sep 2026 15:36:11 -0400
Message-ID: <20260920193650.3373435-8-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
In-Reply-To: <20260920193650.3373435-1-pasha.tatashin@soleen.com>
References: <20260920193650.3373435-1-pasha.tatashin@soleen.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Register LUO file handler for KVM vCPU file descriptors to allow
preserving vCPU state across live updates.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 include/linux/kho/abi/kvm.h |  25 ++++++
 include/linux/kvm_host.h    |  53 ++++++++++++
 include/uapi/linux/kvm.h    |   1 +
 virt/kvm/Kconfig            |   3 +
 virt/kvm/kvm_luo.c          | 161 +++++++++++++++++++++++++++++++++++-
 virt/kvm/kvm_main.c         |  58 ++++++++++---
 6 files changed, 286 insertions(+), 15 deletions(-)

diff --git a/include/linux/kho/abi/kvm.h b/include/linux/kho/abi/kvm.h
index 42074d76e04a..166a0a2f13c8 100644
--- a/include/linux/kho/abi/kvm.h
+++ b/include/linux/kho/abi/kvm.h
@@ -39,6 +39,31 @@ struct kvm_luo_ser {
 /* The compatibility string for KVM VM file handler */
 #define KVM_LUO_FH_COMPATIBLE	"kvm_vm_luo_v1"
 
+/**
+ * enum kvm_vcpu_luo_flags - Flags for KVM vCPU LUO preservation
+ * @KVM_VCPU_LUO_FLAG_CARETAKER: vCPU is preserved with on-core Caretaker execution.
+ */
+enum kvm_vcpu_luo_flags {
+	KVM_VCPU_LUO_FLAG_CARETAKER = BIT(0),
+};
+
+/**
+ * struct kvm_vcpu_ser - Main serialization structure for a KVM vCPU.
+ * @vcpu_id:    The ID of the virtual CPU.
+ * @flags:      Flags for vCPU preservation.
+ * @vm_token:   Token of the associated KVM VM instance.
+ * @arch_state: Preservation pointer to vCPU architectural state.
+ */
+struct kvm_vcpu_ser {
+	u32 vcpu_id;
+	u32 flags;
+	u64 vm_token;
+	DECLARE_KHOSER_PTR(arch_state, struct kvm_vcpu_arch_ser *);
+} __packed;
+
+/* The compatibility string for KVM vCPU file handler */
+#define KVM_VCPU_LUO_FH_COMPATIBLE	"kvm_vcpu_luo_v1"
+
 /**
  * struct guest_memfd_luo_folio_ser - Serialization layout for a single folio in guest_memfd.
  * @pfn:   Page Frame Number of the folio.
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 1217cd6ec6ab..643b941286c2 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1094,7 +1094,9 @@ void kvm_get_kvm(struct kvm *kvm);
 bool kvm_get_kvm_safe(struct kvm *kvm);
 void kvm_put_kvm(struct kvm *kvm);
 bool file_is_kvm(struct file *file);
+bool file_is_kvm_vcpu(struct file *file);
 struct file *kvm_create_vm_file(unsigned long type, const char *fdname);
+struct file *kvm_create_vcpu_file(struct kvm *kvm, unsigned long id);
 void kvm_put_kvm_no_destroy(struct kvm *kvm);
 void kvm_uevent_notify_vm_create(struct kvm *kvm);
 
@@ -2661,4 +2663,55 @@ long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
 				    struct kvm_pre_fault_memory *range);
 #endif
 
+struct kvm_luo_ser;
+struct kvm_vcpu_ser;
+
+#ifdef CONFIG_HAVE_KVM_ARCH_VCPU_PRESERVE
+int kvm_arch_vm_luo_preserve(struct kvm *kvm, struct kvm_luo_ser *ser);
+int kvm_arch_vm_luo_retrieve(struct kvm *kvm, struct kvm_luo_ser *ser);
+void kvm_arch_vm_luo_unpreserve(struct kvm *kvm, struct kvm_luo_ser *ser);
+/*
+ * Unlike unpreserve(), finish() runs after the kexec on a VM that was never
+ * reclaimed, so there is no struct kvm to pass: it may only free what @ser
+ * points at.
+ */
+void kvm_arch_vm_luo_finish(struct kvm_luo_ser *ser);
+
+int kvm_arch_vcpu_luo_preserve(struct kvm_vcpu *vcpu, struct kvm_vcpu_ser *ser);
+int kvm_arch_vcpu_luo_retrieve(struct kvm_vcpu *vcpu, struct kvm_vcpu_ser *ser);
+void kvm_arch_vcpu_luo_unpreserve(struct kvm_vcpu_ser *ser);
+void kvm_arch_vcpu_luo_finish(struct kvm_vcpu_ser *ser);
+#else
+static inline int kvm_arch_vm_luo_preserve(struct kvm *kvm,
+					   struct kvm_luo_ser *ser)
+{
+	return 0;
+}
+
+static inline int kvm_arch_vm_luo_retrieve(struct kvm *kvm,
+					   struct kvm_luo_ser *ser)
+{
+	return 0;
+}
+
+static inline void kvm_arch_vm_luo_unpreserve(struct kvm *kvm,
+					      struct kvm_luo_ser *ser) {}
+static inline void kvm_arch_vm_luo_finish(struct kvm_luo_ser *ser) {}
+
+static inline int kvm_arch_vcpu_luo_preserve(struct kvm_vcpu *vcpu,
+					     struct kvm_vcpu_ser *ser)
+{
+	return 0;
+}
+
+static inline int kvm_arch_vcpu_luo_retrieve(struct kvm_vcpu *vcpu,
+					     struct kvm_vcpu_ser *ser)
+{
+	return 0;
+}
+
+static inline void kvm_arch_vcpu_luo_unpreserve(struct kvm_vcpu_ser *ser) {}
+static inline void kvm_arch_vcpu_luo_finish(struct kvm_vcpu_ser *ser) {}
+#endif
+
 #endif
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index ac2d77d14963..4b1754050681 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -999,6 +999,7 @@ struct kvm_enable_cap {
 #define KVM_CAP_S390_HPAGE_2G 249
 #define KVM_CAP_PPC_COMPAT_CAPS 250
 #define KVM_CAP_ARM_PMU_V3_STRICT 251
+#define KVM_CAP_VCPU_PRESERVE 252
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index c3c0ee253fc7..fcaf57377e73 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -71,6 +71,9 @@ config KVM_GENERIC_DIRTYLOG_READ_PROTECT
 config KVM_GENERIC_PRE_FAULT_MEMORY
        bool
 
+config HAVE_KVM_ARCH_VCPU_PRESERVE
+       bool
+
 config KVM_COMPAT
        def_bool y
        depends on KVM && COMPAT && !(S390 || ARM64 || RISCV)
diff --git a/virt/kvm/kvm_luo.c b/virt/kvm/kvm_luo.c
index b3bd9bebe17a..f7e259bef4b7 100644
--- a/virt/kvm/kvm_luo.c
+++ b/virt/kvm/kvm_luo.c
@@ -35,7 +35,6 @@
  *
  * The preservation does not cover:
  *
- * - vCPUs and vCPU states
  * - Memspots / Memory slot layout (memslots)
  * - Interrupt controllers and IRQ routings
  * - Coalesced MMIO zones
@@ -46,6 +45,7 @@
 #include <linux/liveupdate.h>
 #include <linux/kvm_host.h>
 #include <linux/pagemap.h>
+#include <linux/fdtable.h>
 #include <linux/file.h>
 #include <linux/err.h>
 #include <linux/anon_inodes.h>
@@ -65,6 +65,7 @@ static int kvm_luo_preserve(struct liveupdate_file_op_args *args)
 {
 	struct kvm *kvm = args->file->private_data;
 	struct kvm_luo_ser *ser;
+	int err;
 
 	if (kvm->vm_dead || kvm->vm_bugged)
 		return -EINVAL;
@@ -80,6 +81,11 @@ static int kvm_luo_preserve(struct liveupdate_file_op_args *args)
 	 * architecture that does not implement the hook.
 	 */
 	ser->type = 0;
+	err = kvm_arch_vm_luo_preserve(kvm, ser);
+	if (err) {
+		kho_unpreserve_free(ser);
+		return err;
+	}
 
 	args->serialized_data = virt_to_phys(ser);
 	return 0;
@@ -111,18 +117,26 @@ static int kvm_luo_retrieve(struct liveupdate_file_op_args *args)
 
 	kvm = file->private_data;
 
+	err = kvm_arch_vm_luo_retrieve(kvm, ser);
+	if (err) {
+		fput(file);
+		goto err_free_ser;
+	}
+
 	args->file = file;
 
 	kvm_uevent_notify_vm_create(kvm);
 	return 0;
 
 err_free_ser:
+	kvm_arch_vm_luo_finish(ser);
 	kho_restore_free(ser);
 	return err;
 }
 
 static void kvm_luo_unpreserve(struct liveupdate_file_op_args *args)
 {
+	struct kvm *kvm = args->file ? args->file->private_data : NULL;
 	struct kvm_luo_ser *ser;
 
 	/*
@@ -135,7 +149,7 @@ static void kvm_luo_unpreserve(struct liveupdate_file_op_args *args)
 		return;
 
 	ser = phys_to_virt(args->serialized_data);
-
+	kvm_arch_vm_luo_unpreserve(kvm, ser);
 	kho_unpreserve_free(ser);
 }
 
@@ -150,7 +164,7 @@ static void kvm_luo_finish(struct liveupdate_file_op_args *args)
 		return;
 
 	ser = phys_to_virt(args->serialized_data);
-
+	kvm_arch_vm_luo_finish(ser);
 	kho_restore_free(ser);
 }
 
@@ -168,6 +182,139 @@ static struct liveupdate_file_handler kvm_luo_handler = {
 	.compatible = KVM_LUO_FH_COMPATIBLE,
 };
 
+static bool kvm_vcpu_luo_can_preserve(struct liveupdate_file_handler *handler,
+				      struct file *file)
+{
+	return file_is_kvm_vcpu(file);
+}
+
+static int kvm_vcpu_luo_preserve(struct liveupdate_file_op_args *args)
+{
+	struct kvm_vcpu *vcpu = args->file->private_data;
+	struct kvm_vcpu_ser *ser;
+	struct file *kvm_file;
+	u64 vm_token;
+	int err;
+
+	kvm_file = get_file_active(&vcpu->kvm->vm_file);
+	if (!kvm_file)
+		return -ENOENT;
+
+	err = liveupdate_get_token_outgoing(args->session, kvm_file, &vm_token);
+	fput(kvm_file);
+	if (err)
+		return err;
+
+	if (mutex_lock_killable(&vcpu->mutex))
+		return -EINTR;
+
+	ser = kho_alloc_preserve(sizeof(*ser));
+	if (IS_ERR(ser)) {
+		mutex_unlock(&vcpu->mutex);
+		return PTR_ERR(ser);
+	}
+
+	ser->vcpu_id = vcpu->vcpu_id;
+	ser->flags = 0;
+	ser->vm_token = vm_token;
+
+	err = kvm_arch_vcpu_luo_preserve(vcpu, ser);
+	mutex_unlock(&vcpu->mutex);
+	if (err) {
+		kho_unpreserve_free(ser);
+		return err;
+	}
+
+	args->serialized_data = virt_to_phys(ser);
+	return 0;
+}
+
+static int kvm_vcpu_luo_retrieve(struct liveupdate_file_op_args *args)
+{
+	struct kvm_vcpu_ser *ser;
+	struct file *vm_file, *file;
+	struct kvm_vcpu *vcpu;
+	int err;
+
+	if (!args->serialized_data)
+		return -EINVAL;
+
+	ser = phys_to_virt(args->serialized_data);
+
+	err = liveupdate_get_file_incoming(args->session, ser->vm_token, &vm_file);
+	if (err)
+		goto err_free_ser;
+
+	if (!file_is_kvm(vm_file)) {
+		fput(vm_file);
+		err = -EINVAL;
+		goto err_free_ser;
+	}
+
+	file = kvm_create_vcpu_file(vm_file->private_data, ser->vcpu_id);
+	fput(vm_file);
+	if (IS_ERR(file)) {
+		err = PTR_ERR(file);
+		goto err_free_ser;
+	}
+
+	vcpu = file->private_data;
+	err = kvm_arch_vcpu_luo_retrieve(vcpu, ser);
+	if (err) {
+		fput(file);
+		goto err_free_ser;
+	}
+
+	args->file = file;
+	return 0;
+
+err_free_ser:
+	kvm_arch_vcpu_luo_finish(ser);
+	kho_restore_free(ser);
+	return err;
+}
+
+static void kvm_vcpu_luo_unpreserve(struct liveupdate_file_op_args *args)
+{
+	struct kvm_vcpu_ser *ser;
+
+	if (WARN_ON_ONCE(!args->serialized_data))
+		return;
+
+	ser = phys_to_virt(args->serialized_data);
+	kvm_arch_vcpu_luo_unpreserve(ser);
+	kho_unpreserve_free(ser);
+}
+
+static void kvm_vcpu_luo_finish(struct liveupdate_file_op_args *args)
+{
+	struct kvm_vcpu_ser *ser;
+
+	if (args->retrieve_status < 0)
+		return;
+
+	if (!args->serialized_data)
+		return;
+
+	ser = phys_to_virt(args->serialized_data);
+	kvm_arch_vcpu_luo_finish(ser);
+	kho_restore_free(ser);
+}
+
+static const struct liveupdate_file_ops kvm_vcpu_luo_file_ops = {
+	.can_preserve = kvm_vcpu_luo_can_preserve,
+	.preserve = kvm_vcpu_luo_preserve,
+	.retrieve = kvm_vcpu_luo_retrieve,
+	.unpreserve = kvm_vcpu_luo_unpreserve,
+	.finish = kvm_vcpu_luo_finish,
+	.owner = THIS_MODULE,
+};
+
+static struct liveupdate_file_handler kvm_vcpu_luo_handler = {
+	.ops = &kvm_vcpu_luo_file_ops,
+	.compatible = KVM_VCPU_LUO_FH_COMPATIBLE,
+};
+
 int kvm_luo_init(void)
 {
 	int err = liveupdate_register_file_handler(&kvm_luo_handler);
@@ -177,11 +324,19 @@ int kvm_luo_init(void)
 		return err;
 	}
 
+	err = liveupdate_register_file_handler(&kvm_vcpu_luo_handler);
+	if (err && err != -EOPNOTSUPP) {
+		pr_err("Could not register kvm_vcpu_luo handler: %pe\n", ERR_PTR(err));
+		liveupdate_unregister_file_handler(&kvm_luo_handler);
+		return err;
+	}
+
 	return 0;
 }
 
 void kvm_luo_exit(void)
 {
+	liveupdate_unregister_file_handler(&kvm_vcpu_luo_handler);
 	liveupdate_unregister_file_handler(&kvm_luo_handler);
 }
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 4b03a65a8428..ae91123e1822 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4121,12 +4121,12 @@ static struct file_operations kvm_vcpu_fops = {
 /*
  * Allocates an inode for the vcpu.
  */
-static int create_vcpu_fd(struct kvm_vcpu *vcpu)
+static struct file *create_vcpu_file(struct kvm_vcpu *vcpu)
 {
 	char name[8 + 1 + ITOA_MAX_LEN + 1];
 
 	snprintf(name, sizeof(name), "kvm-vcpu:%d", vcpu->vcpu_id);
-	return anon_inode_getfd(name, &kvm_vcpu_fops, vcpu, O_RDWR | O_CLOEXEC);
+	return anon_inode_getfile(name, &kvm_vcpu_fops, vcpu, O_RDWR);
 }
 
 #ifdef __KVM_HAVE_ARCH_VCPU_DEBUGFS
@@ -4163,11 +4163,12 @@ static void kvm_create_vcpu_debugfs(struct kvm_vcpu *vcpu)
 /*
  * Creates some virtual cpus.  Good luck creating more than one.
  */
-static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, unsigned long id)
+struct file *kvm_create_vcpu_file(struct kvm *kvm, unsigned long id)
 {
-	int r;
 	struct kvm_vcpu *vcpu;
+	struct file *file;
 	struct page *page;
+	int r;
 
 	/*
 	 * KVM tracks vCPU IDs as 'int', be kind to userspace and reject
@@ -4179,23 +4180,23 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, unsigned long id)
 	 */
 	BUILD_BUG_ON(KVM_MAX_VCPU_IDS > INT_MAX);
 	if (id >= KVM_MAX_VCPU_IDS)
-		return -EINVAL;
+		return ERR_PTR(-EINVAL);
 
 	mutex_lock(&kvm->lock);
 	if (kvm->created_vcpus >= kvm->max_vcpus) {
 		mutex_unlock(&kvm->lock);
-		return -EINVAL;
+		return ERR_PTR(-EINVAL);
 	}
 
 	if (test_bit(id, kvm->vcpu_ids)) {
 		mutex_unlock(&kvm->lock);
-		return -EEXIST;
+		return ERR_PTR(-EEXIST);
 	}
 
 	r = kvm_arch_vcpu_precreate(kvm, id);
 	if (r) {
 		mutex_unlock(&kvm->lock);
-		return r;
+		return ERR_PTR(r);
 	}
 
 	kvm->created_vcpus++;
@@ -4259,9 +4260,11 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, unsigned long id)
 	 */
 	mutex_lock(&vcpu->mutex);
 	kvm_get_kvm(kvm);
-	r = create_vcpu_fd(vcpu);
-	if (r < 0)
+	file = create_vcpu_file(vcpu);
+	if (IS_ERR(file)) {
+		r = PTR_ERR(file);
 		goto kvm_put_xa_erase;
+	}
 
 	/*
 	 * Pairs with smp_rmb() in kvm_get_vcpu.  Store the vcpu
@@ -4274,7 +4277,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, unsigned long id)
 	mutex_unlock(&kvm->lock);
 	kvm_arch_vcpu_postcreate(vcpu);
 	kvm_create_vcpu_debugfs(vcpu);
-	return r;
+	return file;
 
 kvm_put_xa_erase:
 	mutex_unlock(&vcpu->mutex);
@@ -4295,7 +4298,30 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, unsigned long id)
 	kvm->created_vcpus--;
 	__clear_bit(id, kvm->vcpu_ids);
 	mutex_unlock(&kvm->lock);
-	return r;
+	return ERR_PTR(r);
+}
+
+static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, unsigned long id)
+{
+	struct file *file;
+	int fd;
+
+	/*
+	 * Reserve the fd up front: kvm_create_vcpu_file() publishes the vCPU
+	 * in kvm->vcpu_array, and there is no clean way to unwind that.
+	 */
+	fd = get_unused_fd_flags(O_RDWR | O_CLOEXEC);
+	if (fd < 0)
+		return fd;
+
+	file = kvm_create_vcpu_file(kvm, id);
+	if (IS_ERR(file)) {
+		put_unused_fd(fd);
+		return PTR_ERR(file);
+	}
+
+	fd_install(fd, file);
+	return fd;
 }
 
 static int kvm_vcpu_ioctl_set_sigmask(struct kvm_vcpu *vcpu, sigset_t *sigset)
@@ -4961,6 +4987,8 @@ static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
 	case KVM_CAP_GUEST_MEMFD_FLAGS:
 		return kvm_gmem_get_supported_flags(kvm);
 #endif
+	case KVM_CAP_VCPU_PRESERVE:
+		return IS_ENABLED(CONFIG_HAVE_KVM_ARCH_VCPU_PRESERVE);
 	default:
 		break;
 	}
@@ -5506,6 +5534,12 @@ bool file_is_kvm(struct file *file)
 }
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(file_is_kvm);
 
+bool file_is_kvm_vcpu(struct file *file)
+{
+	return file && file->f_op == &kvm_vcpu_fops;
+}
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(file_is_kvm_vcpu);
+
 struct file *kvm_create_vm_file(unsigned long type, const char *fdname)
 {
 	struct kvm *kvm = kvm_create_vm(type, fdname);
-- 
2.55.0.1082.g2b9226bbc0-goog

