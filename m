Received: from mail-yx2-f30.google.com (mail-yx2-f30.google.com [74.125.224.158])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DC55485931
	for <kvmarm@lists.linux.dev>; Sun, 20 Sep 2026 19:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.158
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789933199; cv=none; b=fhOvTTDgcuS9mg1T2/XAQCQU+sukm9+PyjmD2CKkkCAZzvDxk+to3agA4QaWUtVMsnd+yPSulyPDF8MfZgVrhXw69zW0EGP7lHW9VcAauielT3c3hzULi4y5a2YXf4OVGsNI++VvzbdfHktz+ZTwC9lqXIXKKxxQCmDHnC2rYWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789933199; c=relaxed/simple;
	bh=Sp9aHUzQTLzOWIuHSw5bbKy7oQ3sB+lvxCIeFLKmdHo=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HVzgnZIANdQK2PEHhnNGuDVYEGZznD1Sc3msOhA2XrhzGsu8gnPzUk5bk1SuhC9Esiz0tTc5Zz09e/Y+GvNOes4rtCWVTZhtt1kGiO0ye/r7w4z4Gh/eNCY5csPPy6cSr3qNmYtQrG/vDYMCT5uUdcn6JZBz9oKIH6rLAsowttY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com; spf=pass smtp.mailfrom=soleen.com; dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b=I4HIJuYu; arc=none smtp.client-ip=74.125.224.158
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=soleen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b="I4HIJuYu"
Received: by mail-yx2-f30.google.com with SMTP id 00721157ae682-85d440939efso18020087b3.1
        for <kvmarm@lists.linux.dev>; Sun, 20 Sep 2026 12:39:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1789933193; x=1790537993; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=cf5rLykmCWIC3OsLJKmCN2FyaY3ZIm+gv4og5D7dmSY=;
        b=I4HIJuYuxWnFOgiaijMQVLd95h56HhE/o04sbdiWss37uqA9ly7yxGuVoWhj3GISWz
         y6zlrOiONvWGprkY98ELlQ/ftkblBYW8w0UdvbXD4x4p8t2O3D1ocYH1Opj5qy6XZyLu
         MnqLCRHeNgDKvQjtCdBTGDpGJQUpcftrvb2G4vN1TN1Izz9ccYo45YawFp2uL1P4Iblq
         BJgGeqt//BTxt+yyzPTk5wlifrupd9WplQT+kEUqThLDqIvDMWi+XDlYDZLyhDWb3BiS
         C7XGHauyFk9A3Y9NW+M9cSijyPBuUgi4XZLiM2dHwwpXVkrIukQyt+XZdMqzFkDkLcHC
         /r1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789933193; x=1790537993;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=cf5rLykmCWIC3OsLJKmCN2FyaY3ZIm+gv4og5D7dmSY=;
        b=GlRBYvtVqZX41B9qfnXoq4n4EABTaPPYDB+h6dIzh+flJMLVLpq9TvdopbEt+6H0Ou
         iY8m45o9FmRphxywB6Lc7LdwctUw41blEItphTqhWi44qHFAdE/yVgcRo8B6ko5Hw3Pq
         YUNVdHa3fBMzR9sPPEIkxahCtIDbHjYIJSjUv5+h089eRVix2EyvhbF1MpOEYfq6TQoM
         ip2K8Z9OT8fRW7dggBpMA9yUPw7SCrJUJwIjB7Omu/apPh6ChbrzIoIBuYz4sHNsAceE
         jKRM+w6kgqFRJ4pl+k9l4ez7VWRPgMJbJc4cpKn5VYZHpn6GzcL+fwyHdoprfFfns9hw
         WCZg==
X-Forwarded-Encrypted: i=1; AKwUvBxT4hU/nm5H+TG4is90DrKEklX24BasCvt/oKNqwzGlnihQc+uyNjW30+WYrnuX8rAoJYSS7j0=@lists.linux.dev
X-Gm-Message-State: AFuF++mcKStdFp7iioZIdSdiyPWYcDtBrfr6EHEURjd+6CF1esBY8Bgi
	B3gUdutt68sUAxpGuhw2d18PQQTc2hiRkDl+L65Y+0P8Ra2GKTtsZZi8Y4A+mtMrVro=
X-Gm-Gg: AYBFou2RNVQ4KVy4J9T2gBahxDaDqCMUkv8Pn40hEYwYZnxbEQ30p6w6Ykj89QnuQWj
	TdGENZETtn6a0J3puZ39vEHUQa1y01YFL0XBZUWI7C1YDg1WCbtWPwSEBfYtZAzBf1V1WrKF2U5
	evWOMIn5Z5BR6hSArgMo8i9m8skfP80AcHYphm+lGhkMUsPTB6RhYUWsjZvf4bUv9oO40HhhRFJ
	f+zYkMpZqCmviZB+3fDF3kXcG3ZIzfnrtG0hn3U3+AE6GXVKbFFA7tiQ3zckolnsmkDOsS9zEiJ
	Z46msnkdFBrJfbEHHEMJpRAmsfQZYpt73PMwAq1yLp7fjr75wPdZGS0YMRc2rCQmYi22eapyX0h
	hnriygV7jWI8Pn3IRUdz3EHjFwiCoVvfrC2v1AaWAlNDX3pj4v4jxB7eKp0KFrJ8IwlZ7jK0wO5
	4xP7MmbvMQJpVL5UTzJEWO4SFnOaL88V2vcxlGuhhkpONgQDGPExGUSPbCdgIHuPYkqSIcB3H3m
	lA7FJlaPD1qyMBxBMEkuJXzALZ6LrxC+jz4wNs2nSMQMBpOR7rvA7U6pkbrZ6SinSjCtSgRsEx4
	BBOAskoXurhrLqC6JBE=
X-Received: by 2002:a05:690c:385:b0:81e:45a6:bd53 with SMTP id 00721157ae682-897308fc956mr28724767b3.8.1789933193482;
        Sun, 20 Sep 2026 12:39:53 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-89a45d8fb3csm19035517b3.13.2026.09.20.12.39.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Sep 2026 12:39:52 -0700 (PDT)
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
Subject: [RFC PATCH 30/46] KVM: caretaker: Integrate Caretaker vCPU detach, attach, and cancel with KVM
Date: Sun, 20 Sep 2026 15:36:34 -0400
Message-ID: <20260920193650.3373435-31-pasha.tatashin@soleen.com>
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

Integrate Caretaker vCPU preservation, re-attachment, and cancellation
with KVM LUO handlers and enable CONFIG_KVM_CARETAKER build rules.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 Documentation/liveupdate/vmm.rst |  15 +++
 include/linux/kvm_caretaker.h    |   1 +
 virt/kvm/Kconfig                 |  28 +++++
 virt/kvm/Makefile.kvm            |   7 ++
 virt/kvm/caretaker.c             | 197 ++++++++++++++++++++++++++++++-
 virt/kvm/kvm_luo.c               |  70 ++++++++++-
 virt/kvm/kvm_main.c              |   7 ++
 7 files changed, 318 insertions(+), 7 deletions(-)

diff --git a/Documentation/liveupdate/vmm.rst b/Documentation/liveupdate/vmm.rst
index b8e8fb2b63c2..a0b54d6f1220 100644
--- a/Documentation/liveupdate/vmm.rst
+++ b/Documentation/liveupdate/vmm.rst
@@ -100,8 +100,23 @@ VM & Guest_Memfd Preservation ABI
 .. kernel-doc:: include/linux/kho/abi/kvm.h
    :internal:
 
+KVM Caretaker (Orphaned VM Execution)
+=====================================
+
+.. kernel-doc:: virt/kvm/caretaker.c
+   :doc: KVM Caretaker Architecture and Lifecycle
+
+KVM Caretaker Core & Architecture API
+=====================================
+
+.. kernel-doc:: include/linux/kvm_caretaker.h
+
+.. kernel-doc:: virt/kvm/caretaker.c
+   :identifiers:
+
 See Also
 ========
 
 - :doc:`/core-api/liveupdate`
+- :doc:`/liveupdate/cpu_preservation`
 - :doc:`/userspace-api/liveupdate`
diff --git a/include/linux/kvm_caretaker.h b/include/linux/kvm_caretaker.h
index 3e89738d7fdf..0d4bdde7b1c3 100644
--- a/include/linux/kvm_caretaker.h
+++ b/include/linux/kvm_caretaker.h
@@ -241,6 +241,7 @@ void kvm_arch_vcpu_luo_pre_retrieve_caretaker(struct kvm_vcpu *vcpu,
 void kvm_arch_vcpu_luo_attach_caretaker(struct kvm_vcpu *vcpu,
 					struct kvm_vcpu_ser *ser);
 
+void kvm_caretaker_vm_pre_retrieve(void);
 int kvm_caretaker_vcpu_pre_preserve(struct kvm_vcpu *vcpu,
 				    struct liveupdate_session *session,
 				    struct kvm_vcpu_ser *ser);
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index fcaf57377e73..165e0c85b8aa 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -125,3 +125,31 @@ config HAVE_KVM_ARCH_GMEM_INVALIDATE
 config HAVE_KVM_ARCH_GMEM_POPULATE
        bool
        depends on KVM_GUEST_MEMFD
+
+config HAVE_KVM_ARCH_CARETAKER
+	bool
+
+config KVM_CARETAKER
+	bool "Orphaned VM Caretaker execution and lifecycle management"
+	depends on KVM
+	depends on LIVEUPDATE_CPU
+	depends on SMP
+	depends on HOTPLUG_CPU
+	depends on HAVE_KVM_ARCH_CARETAKER
+	select LIVEUPDATE_ONCORE
+	default LIVEUPDATE_CPU
+	help
+	  Enable Caretaker CPU preservation and standalone execution for
+	  orphaned virtual machines across host kernel live updates.
+
+	  During a host kernel live update, user space hypervisors
+	  and host services terminate, leaving running guest virtual
+	  machines in an orphaned state. Caretaker keeps designated physical
+	  CPUs running their respective guest vCPUs on-core in a standalone
+	  execution loop throughout the entire live update transition.
+
+	  Caretaker attaches to preserved CPUs via the cpu_preserve subsystem
+	  and continues guest vCPU execution across the kexec live update
+	  without pausing the guest.
+
+	  If unsure, say N.
diff --git a/virt/kvm/Makefile.kvm b/virt/kvm/Makefile.kvm
index d30fca094c42..ae1fcf9861b7 100644
--- a/virt/kvm/Makefile.kvm
+++ b/virt/kvm/Makefile.kvm
@@ -14,3 +14,10 @@ kvm-$(CONFIG_HAVE_KVM_DIRTY_RING) += $(KVM)/dirty_ring.o
 kvm-$(CONFIG_HAVE_KVM_PFNCACHE) += $(KVM)/pfncache.o
 kvm-$(CONFIG_KVM_GUEST_MEMFD) += $(KVM)/guest_memfd.o
 kvm-$(CONFIG_LIVEUPDATE_GUEST_MEMFD) += $(KVM)/guest_memfd_luo.o $(KVM)/kvm_luo.o
+kvm-$(CONFIG_KVM_CARETAKER) += $(KVM)/caretaker.o
+KASAN_SANITIZE_$(KVM)/caretaker.o := n
+KCSAN_SANITIZE_$(KVM)/caretaker.o := n
+UBSAN_SANITIZE_$(KVM)/caretaker.o := n
+KCOV_INSTRUMENT_$(KVM)/caretaker.o := n
+CFLAGS_REMOVE_$(KVM)/caretaker.o = $(CC_FLAGS_FTRACE)
+CFLAGS_$(KVM)/caretaker.o += -fno-stack-protector $(call cc-option,-ftrivial-auto-var-init=uninitialized) -fno-builtin-memset -fno-builtin-memcpy $(call cc-option,-fno-tree-loop-distribute-patterns) $(call cc-option,-fno-jump-tables)
diff --git a/virt/kvm/caretaker.c b/virt/kvm/caretaker.c
index b4a203562727..dac64c466d76 100644
--- a/virt/kvm/caretaker.c
+++ b/virt/kvm/caretaker.c
@@ -196,7 +196,7 @@ kvm_caretaker_should_exit(struct kvm_caretaker_vcpu *cvcpu)
 
 	cpu_preserved_inval(cvcpu->cb);
 
-	st = READ_ONCE(cvcpu->cb->state);
+	st = smp_load_acquire(&cvcpu->cb->state);
 	if (st != KVM_CARETAKER_PAUSED && st != KVM_CARETAKER_RUNNING)
 		return true;
 
@@ -365,7 +365,7 @@ static bool kvm_caretaker_try_stop(struct kvm_caretaker_cb_ser *cb)
 {
 	cpu_preserved_inval(cb);
 
-	if (READ_ONCE(cb->state) == KVM_CARETAKER_STOPPED)
+	if (smp_load_acquire(&cb->state) == KVM_CARETAKER_STOPPED)
 		return true;
 
 	if (cmpxchg(&cb->state, KVM_CARETAKER_PAUSED,
@@ -397,10 +397,8 @@ int kvm_caretaker_wait_for_attach(struct kvm_caretaker_cb_ser *cb, int pcpu)
 		return 0;
 
 	if (!cpu_is_preserved(pcpu)) {
-		WRITE_ONCE(cb->state, KVM_CARETAKER_STOPPED);
+		smp_store_release(&cb->state, KVM_CARETAKER_STOPPED);
 		cpu_preserved_clean(cb);
-		/* Ensure state update is visible before returning to caller */
-		smp_wmb();
 		return 0;
 	}
 
@@ -450,3 +448,192 @@ void kvm_caretaker_post_attach_vcpu(struct kvm_vcpu *vcpu)
 	}
 }
 
+/**
+ * kvm_caretaker_vcpu_pre_preserve - Submit an On-Core job for a vCPU prior to arch preserve
+ * @vcpu:    KVM vCPU being preserved.
+ * @session: Active Live Update session.
+ * @ser:     Serialized KHO vCPU descriptor to populate.
+ *
+ * Submits a Caretaker job to @session before kvm_arch_vcpu_luo_preserve() runs.
+ * If @session has preserved physical CPUs, assigns the job to the least-loaded
+ * preserved CPU and sets %KVM_VCPU_LUO_FLAG_CARETAKER in @ser->flags so the
+ * architecture hook allocates and populates a Caretaker runtime page.  If
+ * @session has no preserved physical CPUs, returns 0 without setting the flag
+ * so the vCPU is preserved in RAM only.
+ *
+ * Return: 0 on success, or a negative errno on job allocation failure.
+ */
+int kvm_caretaker_vcpu_pre_preserve(struct kvm_vcpu *vcpu,
+				    struct liveupdate_session *session,
+				    struct kvm_vcpu_ser *ser)
+{
+	struct oncore_job *job;
+
+	/*
+	 * Submit with no data: the run callback's argument is the caretaker
+	 * control block, which does not exist until the architecture's
+	 * kvm_arch_vcpu_luo_preserve() has allocated it.  It is installed with
+	 * oncore_job_set_data() from _post_preserve(), before activation.
+	 */
+	job = oncore_session_submit_job(session, kvm_arch_vcpu_caretaker_run,
+					NULL);
+	if (IS_ERR(job))
+		return PTR_ERR(job);
+	if (!job)
+		return 0;
+
+	vcpu->caretaker.job = job;
+	ser->flags |= KVM_VCPU_LUO_FLAG_CARETAKER;
+
+	return 0;
+}
+
+/**
+ * kvm_caretaker_vcpu_post_preserve - Activate the Caretaker On-Core job after arch preserve
+ * @vcpu:     KVM vCPU being preserved.
+ * @session:  Active Live Update session.
+ * @ser:      Serialized KHO vCPU descriptor.
+ * @arch_err: Result of kvm_arch_vcpu_luo_preserve() (non-zero on failure).
+ *
+ * If @arch_err is non-zero, cancels and frees any job created in
+ * kvm_caretaker_vcpu_pre_preserve().  Otherwise, installs @vcpu->caretaker.cb
+ * as the job's run argument, flushes the control block to PoC, and activates
+ * the job on the session's runqueue so the preserved physical CPU begins
+ * executing the vCPU.
+ *
+ * Return: 0 on success, or @arch_err / negative errno on failure.
+ */
+int kvm_caretaker_vcpu_post_preserve(struct kvm_vcpu *vcpu,
+				     struct liveupdate_session *session,
+				     struct kvm_vcpu_ser *ser,
+				     int arch_err)
+{
+	struct kvm_caretaker_cb_ser *cb = vcpu->caretaker.cb;
+	struct oncore_job *job = vcpu->caretaker.job;
+	int err;
+
+	if (arch_err) {
+		if (job)
+			oncore_session_cancel_job(session, job);
+		vcpu->caretaker.job = NULL;
+		vcpu->caretaker.cb = NULL;
+		return arch_err;
+	}
+
+	if (!(ser->flags & KVM_VCPU_LUO_FLAG_CARETAKER) || !cb)
+		return 0;
+
+	oncore_job_set_data(job, cb);
+
+	kvm_caretaker_pause(cb);
+	cpu_preserved_clean(cb);
+
+	err = oncore_session_activate_job(session, job);
+	if (err) {
+		oncore_session_cancel_job(session, job);
+		vcpu->caretaker.job = NULL;
+		kvm_caretaker_stop(cb);
+		vcpu->caretaker.cb = NULL;
+		return err;
+	}
+
+	return 0;
+}
+
+/**
+ * kvm_caretaker_vm_pre_retrieve - Stop Caretaker execution before retrieving VM state
+ *
+ * Detaches preserved physical CPU workloads before the incoming kernel creates
+ * the restored KVM VM instance so Caretaker execution stops immediately when
+ * userspace begins reclaiming the VM session.
+ */
+void kvm_caretaker_vm_pre_retrieve(void)
+{
+	int cpu;
+
+	for_each_cpu(cpu, cpu_get_preserved_mask())
+		cpu_preserved_detach_workload(cpu);
+}
+
+/**
+ * kvm_caretaker_vcpu_pre_retrieve - Stop Caretaker execution before retrieving vCPU state
+ * @vcpu: Incoming KVM vCPU being restored.
+ * @ser:  Serialized KHO vCPU descriptor.
+ *
+ * Resolves @ser->cb and invokes kvm_arch_vcpu_luo_pre_retrieve_caretaker() so
+ * the preserved physical CPU stops guest execution and serializes its latest
+ * state into @ser->arch_state before kvm_arch_vcpu_luo_retrieve() reads it.
+ */
+void kvm_caretaker_vcpu_pre_retrieve(struct kvm_vcpu *vcpu,
+				     struct kvm_vcpu_ser *ser)
+{
+	if (ser->flags & KVM_VCPU_LUO_FLAG_CARETAKER)
+		vcpu->caretaker.cb = KHOSER_LOAD_PTR(ser->cb);
+
+	kvm_arch_vcpu_luo_pre_retrieve_caretaker(vcpu, ser);
+}
+
+/**
+ * kvm_caretaker_vcpu_retrieve - Complete Caretaker hardware attachment during vCPU retrieve
+ * @vcpu: Incoming KVM vCPU being restored.
+ * @ser:  Serialized KHO vCPU descriptor.
+ *
+ * Invokes kvm_arch_vcpu_luo_attach_caretaker() after architectural register
+ * state has been restored into @vcpu.
+ */
+void kvm_caretaker_vcpu_retrieve(struct kvm_vcpu *vcpu,
+				 struct kvm_vcpu_ser *ser)
+{
+	kvm_arch_vcpu_luo_attach_caretaker(vcpu, ser);
+}
+
+/**
+ * kvm_caretaker_vcpu_unpreserve - Roll back Caretaker execution on live update cancellation
+ * @vcpu:    Outgoing KVM vCPU being unpreserved.
+ * @session: Live Update session being cancelled.
+ * @ser:     Serialized KHO vCPU descriptor.
+ *
+ * Stops the vCPU on the preserved physical CPU, synchronizes any guest state
+ * updates back into the outgoing @vcpu, frees KHO telemetry buffers, and
+ * cancels the On-Core job.
+ */
+void kvm_caretaker_vcpu_unpreserve(struct kvm_vcpu *vcpu,
+				   struct liveupdate_session *session,
+				   struct kvm_vcpu_ser *ser)
+{
+	if (ser->flags & KVM_VCPU_LUO_FLAG_CARETAKER) {
+		kvm_arch_vcpu_luo_pre_retrieve_caretaker(vcpu, ser);
+		kvm_arch_vcpu_luo_retrieve(vcpu, ser);
+		kvm_arch_vcpu_luo_attach_caretaker(vcpu, ser);
+		kvm_caretaker_telemetry_free(ser, false);
+	}
+
+	if (vcpu->caretaker.job) {
+		oncore_session_cancel_job(session, vcpu->caretaker.job);
+		vcpu->caretaker.job = NULL;
+	}
+	vcpu->caretaker.cb = NULL;
+}
+
+/**
+ * kvm_caretaker_vcpu_finish - Release Caretaker KHO resources after live update completion
+ * @vcpu:    Incoming KVM vCPU (or %NULL on retrieve failure cleanup).
+ * @session: Completed Live Update session.
+ * @ser:     Serialized KHO vCPU descriptor.
+ *
+ * Ensures the Caretaker vCPU has detached and frees KHO-preserved telemetry
+ * buffers in the incoming kernel.
+ */
+void kvm_caretaker_vcpu_finish(struct kvm_vcpu *vcpu,
+			       struct liveupdate_session *session,
+			       struct kvm_vcpu_ser *ser)
+{
+	if (ser->flags & KVM_VCPU_LUO_FLAG_CARETAKER) {
+		kvm_arch_vcpu_luo_pre_retrieve_caretaker(vcpu, ser);
+		kvm_caretaker_telemetry_free(ser, true);
+	}
+
+	if (vcpu)
+		vcpu->caretaker.cb = NULL;
+}
+
diff --git a/virt/kvm/kvm_luo.c b/virt/kvm/kvm_luo.c
index f7e259bef4b7..fe30f2d41eb4 100644
--- a/virt/kvm/kvm_luo.c
+++ b/virt/kvm/kvm_luo.c
@@ -44,6 +44,7 @@
  */
 #include <linux/liveupdate.h>
 #include <linux/kvm_host.h>
+#include <linux/kvm_caretaker.h>
 #include <linux/pagemap.h>
 #include <linux/fdtable.h>
 #include <linux/file.h>
@@ -55,6 +56,45 @@
 #include <linux/kho/abi/kvm.h>
 #include "kvm_mm.h"
 
+struct kvm_kho_folios_ser *kvm_kho_folios_alloc(unsigned int max_folios)
+{
+	struct kvm_kho_folios_ser *kp;
+	size_t sz = struct_size(kp, folios_pa, max_folios);
+
+	kp = kho_alloc_preserve(sz);
+	if (IS_ERR(kp))
+		return kp;
+
+	kp->nr_folios = 0;
+	return kp;
+}
+
+void kvm_kho_folios_unpreserve(struct kvm_kho_folios_ser *kp)
+{
+	unsigned int i;
+
+	if (!kp)
+		return;
+
+	for (i = 0; i < kp->nr_folios; i++)
+		kho_unpreserve_folio(page_folio(phys_to_page(kp->folios_pa[i])));
+
+	kho_unpreserve_free(kp);
+}
+
+void kvm_kho_folios_finish(struct kvm_kho_folios_ser *kp)
+{
+	unsigned int i;
+
+	if (!kp)
+		return;
+
+	for (i = 0; i < kp->nr_folios; i++)
+		kho_restore_free(phys_to_virt(kp->folios_pa[i]));
+
+	kho_restore_free(kp);
+}
+
 static bool kvm_luo_can_preserve(struct liveupdate_file_handler *handler,
 				 struct file *file)
 {
@@ -81,6 +121,7 @@ static int kvm_luo_preserve(struct liveupdate_file_op_args *args)
 	 * architecture that does not implement the hook.
 	 */
 	ser->type = 0;
+	ser->kho_folios.phys = 0;
 	err = kvm_arch_vm_luo_preserve(kvm, ser);
 	if (err) {
 		kho_unpreserve_free(ser);
@@ -104,6 +145,8 @@ static int kvm_luo_retrieve(struct liveupdate_file_op_args *args)
 	if (!args->serialized_data)
 		return -EINVAL;
 
+	kvm_caretaker_vm_pre_retrieve();
+
 	ser = phys_to_virt(args->serialized_data);
 
 	snprintf(fdname, sizeof(fdname), "%d",
@@ -130,6 +173,7 @@ static int kvm_luo_retrieve(struct liveupdate_file_op_args *args)
 
 err_free_ser:
 	kvm_arch_vm_luo_finish(ser);
+	kvm_kho_folios_finish(KHOSER_LOAD_PTR(ser->kho_folios));
 	kho_restore_free(ser);
 	return err;
 }
@@ -150,6 +194,9 @@ static void kvm_luo_unpreserve(struct liveupdate_file_op_args *args)
 
 	ser = phys_to_virt(args->serialized_data);
 	kvm_arch_vm_luo_unpreserve(kvm, ser);
+	if (kvm)
+		kvm->kho_folios = NULL;
+	kvm_kho_folios_unpreserve(KHOSER_LOAD_PTR(ser->kho_folios));
 	kho_unpreserve_free(ser);
 }
 
@@ -165,6 +212,7 @@ static void kvm_luo_finish(struct liveupdate_file_op_args *args)
 
 	ser = phys_to_virt(args->serialized_data);
 	kvm_arch_vm_luo_finish(ser);
+	kvm_kho_folios_finish(KHOSER_LOAD_PTR(ser->kho_folios));
 	kho_restore_free(ser);
 }
 
@@ -217,8 +265,15 @@ static int kvm_vcpu_luo_preserve(struct liveupdate_file_op_args *args)
 	ser->vcpu_id = vcpu->vcpu_id;
 	ser->flags = 0;
 	ser->vm_token = vm_token;
-
-	err = kvm_arch_vcpu_luo_preserve(vcpu, ser);
+	ser->arch_state.phys = 0;
+	ser->cb.phys = 0;
+
+	err = kvm_caretaker_vcpu_pre_preserve(vcpu, args->session, ser);
+	if (!err) {
+		err = kvm_arch_vcpu_luo_preserve(vcpu, ser);
+		err = kvm_caretaker_vcpu_post_preserve(vcpu, args->session,
+						       ser, err);
+	}
 	mutex_unlock(&vcpu->mutex);
 	if (err) {
 		kho_unpreserve_free(ser);
@@ -259,16 +314,19 @@ static int kvm_vcpu_luo_retrieve(struct liveupdate_file_op_args *args)
 	}
 
 	vcpu = file->private_data;
+	kvm_caretaker_vcpu_pre_retrieve(vcpu, ser);
 	err = kvm_arch_vcpu_luo_retrieve(vcpu, ser);
 	if (err) {
 		fput(file);
 		goto err_free_ser;
 	}
+	kvm_caretaker_vcpu_retrieve(vcpu, ser);
 
 	args->file = file;
 	return 0;
 
 err_free_ser:
+	kvm_caretaker_vcpu_finish(NULL, args->session, ser);
 	kvm_arch_vcpu_luo_finish(ser);
 	kho_restore_free(ser);
 	return err;
@@ -276,18 +334,24 @@ static int kvm_vcpu_luo_retrieve(struct liveupdate_file_op_args *args)
 
 static void kvm_vcpu_luo_unpreserve(struct liveupdate_file_op_args *args)
 {
+	struct kvm_vcpu *vcpu = args->file ? args->file->private_data : NULL;
 	struct kvm_vcpu_ser *ser;
 
 	if (WARN_ON_ONCE(!args->serialized_data))
 		return;
 
 	ser = phys_to_virt(args->serialized_data);
+
+	if (vcpu)
+		kvm_caretaker_vcpu_unpreserve(vcpu, args->session, ser);
+
 	kvm_arch_vcpu_luo_unpreserve(ser);
 	kho_unpreserve_free(ser);
 }
 
 static void kvm_vcpu_luo_finish(struct liveupdate_file_op_args *args)
 {
+	struct kvm_vcpu *vcpu = args->file ? args->file->private_data : NULL;
 	struct kvm_vcpu_ser *ser;
 
 	if (args->retrieve_status < 0)
@@ -297,6 +361,8 @@ static void kvm_vcpu_luo_finish(struct liveupdate_file_op_args *args)
 		return;
 
 	ser = phys_to_virt(args->serialized_data);
+
+	kvm_caretaker_vcpu_finish(vcpu, args->session, ser);
 	kvm_arch_vcpu_luo_finish(ser);
 	kho_restore_free(ser);
 }
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index ae91123e1822..4f661c5d2ee2 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4521,6 +4521,11 @@ static long kvm_vcpu_ioctl(struct file *filp,
 
 			put_pid(oldpid);
 		}
+
+		if (!kvm_caretaker_vcpu_is_attached(vcpu)) {
+			r = -EBUSY;
+			break;
+		}
 		vcpu->wants_to_run = !READ_ONCE(vcpu->run->immediate_exit__unsafe);
 		r = kvm_arch_vcpu_ioctl_run(vcpu);
 		vcpu->wants_to_run = false;
@@ -4989,6 +4994,8 @@ static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
 #endif
 	case KVM_CAP_VCPU_PRESERVE:
 		return IS_ENABLED(CONFIG_HAVE_KVM_ARCH_VCPU_PRESERVE);
+	case KVM_CAP_CARETAKER:
+		return IS_ENABLED(CONFIG_KVM_CARETAKER);
 	default:
 		break;
 	}
-- 
2.55.0.1082.g2b9226bbc0-goog

