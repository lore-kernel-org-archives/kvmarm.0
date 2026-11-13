Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=90.155.50.34
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794594372;
	b=OyLvOWzsGS33NJU0vwKzEZhYxoUdsxU14dlgkugMzJ+b02ldZMAKxmXUMWY05aLYfTQb
	 TFcjwRIQhaSS7GEAscuX3WW86J3vSVvzoohki0jGg5q1A2nfq4HrTMza95z9n77TufkXX
	 V9lyZ19yQIzJL9fOoaPjRGl3yPd9IQTnje6wVKExCQbvnu49q93PyxUN6ar2mcoWWrqAS
	 PGI9kWNqkDM3l344UEOF0mOBWCIKyRaTV7Tfng/0SZtPbAsiYJogn+kAfTpTqAOaG9OLB
	 +jheo679PVqQVO9b7iy9IEMIYa+CDfmRXXACfPQ2a7d6znT2xPMr07RBohZdbTsE3nQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794594372;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:Sender:X-SRS-Rewrite;
	bh=uJwxGiCNrLccKkPAYgxzqqIkLA0Ci2FLhVovz3dBzjE=;
	b=wqnDMCXFVt6oTXCQOxj0SGPJtVCom24skeZfmf7lEQOMYPSVkc6YNRF4RcQjC/uAKLwH
	 RLHyMTSZ6v+N7HXUTRi5wbaGN0+AZu/OJ840m4M5Bc4/1F0la1rsnpgVxlKb3Sg5gS6PV
	 nzNYWRf/NFT/nl6v00i/+fkMEn1u8BCKtSrZEvOftFg1aD6BskAbGt0JhHWoK7TthVQHP
	 2NGARpZun6O1xyNcOUZdG8Ln+8e0pcd09iqkpVAcwGMeYoCdPUMsupNQMJKfRhHDS1rGd
	 VLX0p5jZFOtF/ueRMc2AFNsqZp/0okSAG4cu5dXNcqRs8XLednHptdq+Niz1j2Nb7iw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=casper.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=uXXARgDP;
	arc=none smtp.remote-ip=90.155.50.34
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 516CC606A339;
	Fri, 13 Nov 2026 18:26:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 516CC606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=uXXARgDP
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=uJwxGiCNrLccKkPAYgxzqqIkLA0Ci2FLhVovz3dBzjE=; b=uXXARgDPDrpVMup/atRRhgObFJ
	7IXpas924Fj1ggK5cRuYyQBuK3eEd/LiSSt7WX3Yqnkhf/4FzOCX7S7fGsFm0yBLw1nIFEFBAHKIZ
	YF2yTJh03jNUzhmc1pGSGHtiFX4QeiutmXdumDKzY1UeNV7mDQWPJUWr9XPWpC3cCEmlPd6Tkptbp
	ZD+BgzjfQ9NDL+andOTbfIICVdFwLEjKAxtMSaB1DgDUcjjLS/8D+1uLjvwfLi9yYdc/ke8+w9gOb
	MRbAO4c8f7c3HxSAvCq29bNFYhZrPR4QGCfY81DRUAWu4+NHKHepABOT5zXeLhBg5bJk22k6+bNbA
	0bLAGGUg==;
Received: from [2001:8b0:10b:1::425] (helo=i7.infradead.org)
	by casper.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xRvyR-00000004cSt-2tFx;
	Fri, 13 Nov 2026 18:26:07 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.99.5 #2 (Red Hat Linux))
	id 1xRvyR-00000000LY3-22XJ;
	Fri, 13 Nov 2026 18:26:07 +0000
From: David Woodhouse <dwmw2@infradead.org>
To: =?UTF-8?q?J=C3=B6rg=20R=C3=B6del?= <joro@8bytes.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	ashish.kalra@amd.com,
	michael.roth@amd.com,
	nsaenz@amazon.com,
	anelkz@amazon.de,
	James.Bottomley@HansenPartnership.com,
	Melody Wang <huibo.wang@amd.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev,
	loongarch@lists.linux.dev,
	linux-mips@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	kvm-riscv@lists.infradead.org,
	x86@kernel.org,
	coconut-svsm@lists.linux.dev,
	joerg.roedel@amd.com,
	Mushahid Hussain <hmushi@amazon.co.uk>,
	Sriram Nambakam <snambakam@linux.microsoft.com>,
	David Woodhouse <dwmw@amazon.co.uk>
Subject: [RFC PATCH 04/13] KVM: Add KVM_GET/SET_PLANE_RUN_STATE vCPU ioctls
Date: Fri, 13 Nov 2026 11:25:58 -0700
Message-ID: <20261113182607.82813-5-dwmw2@infradead.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261113182607.82813-1-dwmw2@infradead.org>
References: <20260608144252.351443-1-joro@8bytes.org>
 <20261113182607.82813-1-dwmw2@infradead.org>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html

From: David Woodhouse <dwmw@amazon.co.uk>

A VMM doing VSM in userspace has to switch the executing plane when
the guest asks for a privilege transition, but a vCPU's plane run
state is kernel-internal, set only by the SEV-SNP VMPL switch,
plane-0 event delivery, and vCPU creation. A VTL call forwarded to
userspace is a dead end.

Add ioctls that read and write a plane vCPU's run state as three flags.
KVM_PLANE_RUN_STATE_USER_HOLD is userspace policy: the plane is
stopped, and only KVM_SET_PLANE_RUN_STATE clears it again.
KVM_PLANE_RUN_STATE_SUSPENDED marks a plane suspended by a guest
privilege transition; KVM does not set it yet, but userspace can
restore it. KVM_PLANE_RUN_STATE_INACTIVE marks a non-zero plane that
has not been started, which is how every such plane begins; SUSPENDED
implies a started plane, so the two together are refused. A plane with
no flag is runnable. KVM_RUN already executes the lowest-numbered
runnable plane, so a userspace plane switch is just: clear the
target's flags, hold the current plane, re-enter KVM_RUN.

A held or suspended plane 0 *stays* stopped. Forcing it runnable on a
pending event fits the SEV-SNP model, but under a userspace privilege
model plane 0 would preempt the higher VTL on any interrupt and resume
mid-hypercall with whatever completion value the shared kvm_run last
held; the events stay pending until the VMM switches back. For the same
reason KVM_RUN no longer falls back to a held plane 0 when nothing is
runnable: it exits with KVM_EXIT_PLANE_EVENT and the new
KVM_PLANE_EVENT_HELD cause, through plane 0's normal exit path, so
immediate_exit and the kvm_run state userspace reads behave as for any
other exit. When KVM makes a plane runnable it clears the two
kernel-owned flags, SUSPENDED and INACTIVE, and never the hold.

The held exit must not disturb what the shared kvm_run carries for a
plane. It neither applies kvm_dirty_regs nor refreshes the
kvm_valid_regs area; those belong to the plane that runs next. A
completion still pending from plane 0's last exit is harder. Running it
first, as any other KVM_RUN would, is right only if kvm_run still holds
that exit's data, and KVM cannot tell whether it does: a VMM doing VSM
holds plane 0 inside a forwarded VtlCall while VTL1 runs, VTL1's exits
reuse the same union, and the completion would retire the VtlCall with
VTL1's bytes. Exiting with the completion still armed would instead
overwrite completion data the VMM did write. So with a completion
pending, a held KVM_RUN fails with -EBUSY and leaves kvm_run alone; the
completion runs when plane 0 next runs.

The flags round-trip: a VMM that saves them and writes them back, for
example on a migration destination, restores the same state, including
a plane that was never started. Which runnable plane happens to be
executing is not part of the interface.

The ioctls are for planes userspace manages, so they return -EINVAL
unless the VM enabled more than one plane with KVM_CAP_PLANES. That
leaves SEV-SNP VMPL planes, whose count and switching the architecture
defines, outside the interface, and it keeps other architectures out:
only x86 consumes KVM_REQ_PLANE_RESCHED, and elsewhere a stray request
bit would abort every subsequent entry attempt, leaving KVM_RUN
spinning at 100% with no way for the VMM to recover the vCPU.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 Documentation/virt/kvm/api.rst |  69 +++++++++++++++++++++
 arch/x86/kvm/x86.c             |  41 ++++++++++---
 include/linux/kvm_host.h       |  21 ++++++-
 include/uapi/linux/kvm.h       |   6 ++
 virt/kvm/kvm_main.c            | 107 ++++++++++++++++++++++++++++++++-
 5 files changed, 233 insertions(+), 11 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 25ce35d5361a..4196f3fc5718 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -427,6 +427,9 @@ to be dirty. KVM will not explicitly mark it such.
 Errors:
 
   =======    ==============================================================
+  EBUSY      no plane is runnable, userspace holds plane 0, and plane 0
+             still has an operation from its last exit to complete (x86,
+             see KVM_SET_PLANE_RUN_STATE)
   EINTR      an unmasked signal is pending
   ENOEXEC    the vcpu hasn't been initialized or the guest tried to execute
              instructions from device memory (arm64)
@@ -6847,6 +6850,72 @@ in the future may use the plane id when planes are supported by hardware (as is
 the case for VMPLs in AMD), or if KVM supports accelerated plane switch
 operations (as might be the case for Hyper-V VTLs).
 
+.. _KVM_GET_PLANE_RUN_STATE:
+
+4.148 KVM_GET_PLANE_RUN_STATE / KVM_SET_PLANE_RUN_STATE
+--------------------------------------------------------
+
+:Capability: KVM_CAP_PLANES
+:Architectures: x86
+:Type: vcpu ioctl
+:Parameters: pointer to a __u64 of run state flags
+:Returns: 0 on success, <0 on error
+
+Reads or sets the run state flags of a plane's vCPU:
+
+- KVM_PLANE_RUN_STATE_USER_HOLD (bit 0): userspace has stopped the plane.
+  Only KVM_SET_PLANE_RUN_STATE sets or clears it.
+- KVM_PLANE_RUN_STATE_SUSPENDED (bit 1): the plane is suspended by a
+  guest privilege transition, and resumes when that transition unwinds.
+  KVM does not set it yet; userspace can set it to restore a saved state.
+- KVM_PLANE_RUN_STATE_INACTIVE (bit 2): the plane has not been started.
+  KVM sets it on every vCPU of a non-zero plane at creation and clears it
+  when the plane is made runnable.  It is not accepted on plane 0.
+  KVM_PLANE_RUN_STATE_SUSPENDED implies the plane was started, so setting
+  both flags fails with -EINVAL.
+
+A plane with no flag set is runnable.  Setting any other bit fails
+with -EINVAL.  Writing back the flags previously read restores the same
+state, so a VMM can save and restore the run state of every plane, for
+example across live migration.  Which runnable plane executes at a given
+moment is not part of this state.
+
+When a vCPU thread calls KVM_RUN, KVM executes the lowest-numbered
+runnable plane, falling back to plane 0.  Whenever KVM itself makes a
+plane runnable, it clears KVM_PLANE_RUN_STATE_SUSPENDED and
+KVM_PLANE_RUN_STATE_INACTIVE but leaves a hold alone.  A VMM
+implementing a software privilege model (such as Hyper-V VSM) switches
+planes by clearing the target plane's flags and setting
+KVM_PLANE_RUN_STATE_USER_HOLD on the current one before re-entering
+KVM_RUN.  Pending events for plane 0 make it runnable again on their own
+unless it is held or suspended; a held plane 0 keeps its events pending
+until the VMM clears the hold, so a software privilege model can keep a
+higher plane running undisturbed.  The ioctl is accepted on any plane's
+vCPU fd, on VMs that enabled more than one plane with
+KVM_ENABLE_CAP(KVM_CAP_PLANES); it fails with -EINVAL on other VMs.
+Planes whose count the architecture defines, such as SEV-SNP VMPLs, are
+not managed through this interface.
+
+If no plane is runnable and userspace holds plane 0, KVM_RUN does not
+override the hold.  It returns to userspace through plane 0 with exit
+reason KVM_EXIT_PLANE_EVENT, cause KVM_PLANE_EVENT_HELD and plane 0;
+immediate_exit still yields -EINTR, and the kvm_run fields every exit
+updates, such as if_flag and apic_base, are filled in.  A held KVM_RUN
+leaves kvm_dirty_regs and the kvm_valid_regs register area alone: they
+are applied to, and refreshed from, the plane that runs next.  If plane 0
+still has an operation from its last exit to complete (see the note in
+the description of KVM_EXIT_MMIO), KVM_RUN fails with -EBUSY instead,
+with or without immediate_exit, and leaves exit_reason and the exit
+fields alone.  The operation completes when plane 0 next runs, from what
+kvm_run holds then, so a VMM that ran another plane in between must put
+plane 0's completion data back before releasing it.
+
+The run state is distinct from KVM_GET/SET_MP_STATE, which describes
+the architectural state of a vCPU within its plane.
+
+A newly created vCPU of plane 0 has no flags set; one of a non-zero
+plane has KVM_PLANE_RUN_STATE_INACTIVE.
+
 .. _kvm_run:
 
 5. The kvm_run structure
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 79ea075eceec..e8cefde75838 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -345,6 +345,11 @@ unsigned kvm_arch_max_planes(struct kvm *kvm)
 	return READ_ONCE(kvm->arch.user_max_planes) ? : 1;
 }
 
+bool kvm_arch_has_user_planes(struct kvm *kvm)
+{
+	return READ_ONCE(kvm->arch.user_max_planes) > 1;
+}
+
 struct kvm_plane *x86_alloc_plane(void)
 {
 	/* For better type checking, do not return kzalloc() value directly */
@@ -8500,7 +8505,9 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 			kvm_x86_call(reload_vmsa)(vcpu);
 	}
 
-	if (kvm_check_plane0_events(vcpu)) {
+	if (kvm_check_plane0_events(vcpu) &&
+	    !vcpu->common->vcpus[0]->plane_user_hold &&
+	    !vcpu->common->vcpus[0]->plane_suspended) {
 		kvm_vcpu_set_plane_runnable(vcpu->common->vcpus[0]);
 
 		kvm_make_request(KVM_REQ_EVENT, vcpu);
@@ -9174,7 +9181,7 @@ static int kvm_x86_vcpu_pre_run(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
-static int __kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
+static int __kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, bool held)
 {
 	struct kvm_queued_exception *ex = &vcpu->arch.exception;
 	struct kvm_run *kvm_run = vcpu->run;
@@ -9191,6 +9198,25 @@ static int __kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 	kvm_load_guest_fpu(vcpu);
 
 	kvm_vcpu_srcu_read_lock(vcpu);
+
+	/*
+	 * Userspace holds plane 0 and no plane is runnable: return to it
+	 * without touching state in the shared kvm_run.  kvm_dirty_regs and
+	 * the sync_regs area are left for the plane that runs next.  A
+	 * pending completion of plane 0 may need bytes the exit would
+	 * overwrite, or may find another plane's exit there, so refuse
+	 * instead of running it or exiting.
+	 */
+	if (held) {
+		if (vcpu->arch.complete_userspace_io)
+			r = -EBUSY;
+		else if (!kvm_vcpu_wants_to_run(vcpu))
+			r = -EINTR;
+		else
+			r = kvm_plane_held_exit(vcpu);
+		goto out;
+	}
+
 	if (unlikely(vcpu->arch.mp_state == KVM_MP_STATE_UNINITIALIZED)) {
 		if (!kvm_vcpu_wants_to_run(vcpu)) {
 			r = -EINTR;
@@ -9292,7 +9318,8 @@ static int __kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 
 out:
 	kvm_put_guest_fpu(vcpu);
-	if (kvm_run->kvm_valid_regs && likely(!vcpu->arch.guest_state_protected))
+	if (!held && kvm_run->kvm_valid_regs &&
+	    likely(!vcpu->arch.guest_state_protected))
 		store_regs(vcpu);
 	post_kvm_run_save(vcpu);
 	kvm_vcpu_srcu_read_unlock(vcpu);
@@ -9308,14 +9335,12 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu_plane0)
 	int ret;
 
 	do {
-		struct kvm_vcpu *vcpu = kvm_vcpu_select_plane(vcpu_plane0);
-
-		if (vcpu == NULL)
-			return -EINVAL;
+		bool held;
+		struct kvm_vcpu *vcpu = kvm_vcpu_select_plane(vcpu_plane0, &held);
 
 		common->plane_switch = false;
 
-		ret = __kvm_arch_vcpu_ioctl_run(vcpu);
+		ret = __kvm_arch_vcpu_ioctl_run(vcpu, held);
 		if (ret)
 		       break;
 	} while (vcpu_plane0->common->plane_switch);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 562489ab444d..b30982fcd3e7 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -422,6 +422,23 @@ struct kvm_vcpu {
 
 	u64 plane_requests;
 	enum kvm_vcpu_state plane_state;
+	/*
+	 * KVM_PLANE_RUN_STATE_USER_HOLD: userspace policy, changed only by
+	 * KVM_SET_PLANE_RUN_STATE.  Pending plane-0 events no longer make
+	 * a held plane 0 runnable on their own; the VMM owns the switch.
+	 */
+	bool plane_user_hold;
+	/*
+	 * KVM_PLANE_RUN_STATE_SUSPENDED: the plane is suspended by a guest
+	 * privilege transition and resumes when that transition unwinds.
+	 */
+	bool plane_suspended;
+	/*
+	 * KVM_PLANE_RUN_STATE_INACTIVE: a non-zero plane that has not been
+	 * started.  Set at vCPU creation, cleared when the plane is made
+	 * runnable.
+	 */
+	bool plane_inactive;
 
 	/* S390 only */
 	bool valid_wakeup;
@@ -463,7 +480,7 @@ struct kvm_vcpu {
 
 void kvm_vcpu_set_plane_runnable(struct kvm_vcpu *vcpu);
 void kvm_vcpu_set_plane_stopped(struct kvm_vcpu *vcpu);
-struct kvm_vcpu *kvm_vcpu_select_plane(struct kvm_vcpu *vcpu);
+struct kvm_vcpu *kvm_vcpu_select_plane(struct kvm_vcpu *vcpu, bool *held);
 
 static inline bool kvm_vcpu_wants_to_run(struct kvm_vcpu *vcpu)
 {
@@ -1208,6 +1225,7 @@ void vcpu_put(struct kvm_vcpu *vcpu);
 #define KVM_MAX_USER_PLANES	4
 
 unsigned kvm_arch_max_planes(struct kvm *kvm);
+bool kvm_arch_has_user_planes(struct kvm *kvm);
 struct kvm_plane *kvm_alloc_plane(void);
 void kvm_free_plane(struct kvm_plane *plane);
 
@@ -1733,6 +1751,7 @@ void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu);
 bool kvm_vcpu_wake_up(struct kvm_vcpu *vcpu);
 
 int kvm_request_create_plane(struct kvm_vcpu *vcpu, unsigned plane, u64 apic_id);
+int kvm_plane_held_exit(struct kvm_vcpu *vcpu);
 
 #ifndef CONFIG_S390
 void __kvm_vcpu_kick(struct kvm_vcpu *vcpu, bool wait);
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index af782b001ea8..abf023ed78c4 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -148,6 +148,7 @@ struct kvm_exit_snp_req_certs {
 
 struct kvm_plane_event_exit {
 #define KVM_PLANE_EVENT_CREATE_VCPU	1
+#define KVM_PLANE_EVENT_HELD		2
 	__u32 cause;
 	__u32 plane;
 	__u64 extra[8];
@@ -1372,6 +1373,11 @@ struct kvm_s390_keyop {
 #define KVM_HAS_DEVICE_ATTR	  _IOW(KVMIO,  0xe3, struct kvm_device_attr)
 
 #define KVM_CREATE_PLANE	  _IO(KVMIO, 0xe4)
+#define KVM_GET_PLANE_RUN_STATE	  _IOR(KVMIO, 0xe5, __u64)
+#define KVM_SET_PLANE_RUN_STATE	  _IOW(KVMIO, 0xe6, __u64)
+#define   KVM_PLANE_RUN_STATE_USER_HOLD	(1ULL << 0)
+#define   KVM_PLANE_RUN_STATE_SUSPENDED	(1ULL << 1)
+#define   KVM_PLANE_RUN_STATE_INACTIVE	(1ULL << 2)
 
 /*
  * ioctls for vcpu fds
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 75ceab2d4838..6a00654490ae 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4121,6 +4121,21 @@ int kvm_request_create_plane(struct kvm_vcpu *vcpu, unsigned plane, u64 apic_id)
 }
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_request_create_plane);
 
+/*
+ * No plane is runnable and userspace holds plane 0: hand the decision back
+ * to the VMM instead of running a plane it holds.
+ */
+int kvm_plane_held_exit(struct kvm_vcpu *vcpu)
+{
+	vcpu->run->exit_reason = KVM_EXIT_PLANE_EVENT;
+	memset(&vcpu->run->plane_event, 0, sizeof(vcpu->run->plane_event));
+	vcpu->run->plane_event.cause = KVM_PLANE_EVENT_HELD;
+	vcpu->run->plane_event.plane = 0;
+
+	return 0;
+}
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_plane_held_exit);
+
 #ifndef CONFIG_S390
 /*
  * Kick a sleeping VCPU, or a guest VCPU in guest mode, into host kernel mode.
@@ -4526,6 +4541,7 @@ static int kvm_plane_ioctl_create_vcpu(struct kvm_plane *plane, unsigned long id
 	vcpu->plane = plane;
 	vcpu->plane_level = plane->level;
 	vcpu->plane_state = STOPPED;
+	vcpu->plane_inactive = plane->level > 0;
 	vcpu->run = vcpu->common->run;
 
 	kvm_vcpu_init(vcpu, kvm, id);
@@ -4767,6 +4783,8 @@ static inline bool kvm_is_vcpu_plane_ioctl(unsigned ioctl)
 	case KVM_GET_SREGS:
 	case KVM_SET_SREGS:
 	case KVM_TRANSLATE:
+	case KVM_GET_PLANE_RUN_STATE:
+	case KVM_SET_PLANE_RUN_STATE:
 		return true;
 	default:
 		return kvm_arch_is_vcpu_plane_ioctl(ioctl);
@@ -4907,6 +4925,61 @@ static long kvm_vcpu_ioctl(struct file *filp,
 		r = kvm_arch_vcpu_ioctl_set_sregs(vcpu, kvm_sregs);
 		break;
 	}
+	case KVM_GET_PLANE_RUN_STATE: {
+		u64 flags = 0;
+
+		r = -EINVAL;
+		if (!kvm_arch_has_user_planes(vcpu->kvm))
+			goto out;
+		if (vcpu->plane_user_hold)
+			flags |= KVM_PLANE_RUN_STATE_USER_HOLD;
+		if (vcpu->plane_suspended)
+			flags |= KVM_PLANE_RUN_STATE_SUSPENDED;
+		if (vcpu->plane_inactive)
+			flags |= KVM_PLANE_RUN_STATE_INACTIVE;
+		r = -EFAULT;
+		if (copy_to_user(argp, &flags, sizeof(flags)))
+			goto out;
+		r = 0;
+		break;
+	}
+	case KVM_SET_PLANE_RUN_STATE: {
+		u64 flags;
+
+		/*
+		 * KVM_SET_PLANE_RUN_STATE raises KVM_REQ_PLANE_RESCHED,
+		 * which only plane-aware architecture code consumes; on a
+		 * planes-less VM the stuck request would abort every guest
+		 * entry and spin KVM_RUN at 100%.
+		 */
+		r = -EINVAL;
+		if (!kvm_arch_has_user_planes(vcpu->kvm))
+			goto out;
+		r = -EFAULT;
+		if (copy_from_user(&flags, argp, sizeof(flags)))
+			goto out;
+		r = -EINVAL;
+		if (flags & ~(KVM_PLANE_RUN_STATE_USER_HOLD |
+			      KVM_PLANE_RUN_STATE_SUSPENDED |
+			      KVM_PLANE_RUN_STATE_INACTIVE))
+			goto out;
+		/* Plane 0 runs from creation; it is never inactive. */
+		if (!vcpu->plane_level && (flags & KVM_PLANE_RUN_STATE_INACTIVE))
+			goto out;
+		/* A plane that was never started cannot be suspended in a switch. */
+		if ((flags & KVM_PLANE_RUN_STATE_INACTIVE) &&
+		    (flags & KVM_PLANE_RUN_STATE_SUSPENDED))
+			goto out;
+		vcpu->plane_user_hold = flags & KVM_PLANE_RUN_STATE_USER_HOLD;
+		vcpu->plane_suspended = flags & KVM_PLANE_RUN_STATE_SUSPENDED;
+		vcpu->plane_inactive = flags & KVM_PLANE_RUN_STATE_INACTIVE;
+		if (flags)
+			kvm_vcpu_set_plane_stopped(vcpu);
+		else
+			kvm_vcpu_set_plane_runnable(vcpu);
+		r = 0;
+		break;
+	}
 	case KVM_GET_MP_STATE: {
 		struct kvm_mp_state mp_state;
 
@@ -5149,8 +5222,21 @@ static struct file_operations kvm_plane_fops = {
 	KVM_COMPAT(kvm_plane_ioctl),
 };
 
+/*
+ * Whether userspace manages this VM's planes (KVM_GET/SET_PLANE_RUN_STATE).
+ * Planes whose count the architecture owns, such as SEV-SNP VMPLs, are not
+ * part of that interface.
+ */
+bool __weak kvm_arch_has_user_planes(struct kvm *kvm)
+{
+	return false;
+}
+
 void kvm_vcpu_set_plane_runnable(struct kvm_vcpu *vcpu)
 {
+	/* The kernel-owned flags; only KVM_SET_PLANE_RUN_STATE drops a hold. */
+	vcpu->plane_inactive = false;
+	vcpu->plane_suspended = false;
 	vcpu->plane_state = RUNNABLE;
 	vcpu->common->plane_switch = true;
 	kvm_make_request(KVM_REQ_PLANE_RESCHED, vcpu);
@@ -5164,12 +5250,18 @@ void kvm_vcpu_set_plane_stopped(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_vcpu_set_plane_stopped);
 
-struct kvm_vcpu *kvm_vcpu_select_plane(struct kvm_vcpu *vcpu)
+/*
+ * Pick the plane KVM_RUN executes.  *held is set when nothing is runnable and
+ * userspace holds plane 0: plane 0 is returned only to carry the exit.
+ */
+struct kvm_vcpu *kvm_vcpu_select_plane(struct kvm_vcpu *vcpu, bool *held)
 {
 	struct kvm_vcpu_common *common = vcpu->common;
 	struct kvm_vcpu *ret = NULL;
 	unsigned i;
 
+	*held = false;
+
 	for (i = 0; i < KVM_MAX_PLANES; i++) {
 		if (common->vcpus[i] == NULL)
 			continue;
@@ -5181,8 +5273,19 @@ struct kvm_vcpu *kvm_vcpu_select_plane(struct kvm_vcpu *vcpu)
 	}
 
 	if (ret == NULL) {
+		/*
+		 * Never force a plane 0 that userspace holds to run: the VMM
+		 * owns releasing it, so KVM_RUN exits to it instead.  This
+		 * must not use kvm_vcpu_set_plane_runnable(), which would
+		 * request another plane reschedule.
+		 */
 		ret = common->vcpus[0];
-		ret->plane_state = RUNNABLE;
+		if (ret->plane_user_hold) {
+			*held = true;
+		} else {
+			ret->plane_suspended = false;
+			ret->plane_state = RUNNABLE;
+		}
 	}
 
 	WRITE_ONCE(common->current_vcpu, ret);
-- 
2.50.1

