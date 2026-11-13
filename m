Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=90.155.50.34
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794594372;
	b=Xl2LmBgBRJ+3ZPChALQan3U6OiYSSkLoe1oyUC5vzGysTNKBZGSyHoaWbcdLyMWg5dA+
	 nt/nBn8YxAGGf0ThYUXOizbpfl0tUwhST6GM1v62Qw+lct7QkNFIWdrRod++ON6pTrlbO
	 pgPX3WHT13/xWA4q6h8gsvo3rkAUC0BcSrPsdlNIVD+Hj4xF65m7zr8o3AkbwxzFDsYw5
	 V/oRT/onWIO2HI/ZR3tt5Ohtp2MRchR+deAHirzCh1uTOj4d5lxB/XPzULuE5PH8v71qM
	 dQ62Vw/4khdCq211Pj5IzvcEiM4TYYWfRI0EuR8Pk/LrjOtMwX0+Hc/igivwNsvtOLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794594372;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:Sender:X-SRS-Rewrite;
	bh=FJlTkZ/+iGrc2on2sDv49DKbHeUd0ygGYuQcqQHw4O4=;
	b=dxhmkKxipXR7s+ZJb/juDwBIuJfEvUWBDfaedJl5YpQiR3ibVlczlskn655V0t8fQXTs
	 /XhHhoHiBwhJtQu9ZGZA/U9vksYfRkIggAbnReQPhK+ZIOJC/me/8VDs/0eL+rNGgYYUZ
	 YBWGvi6uNYyW3EHazy1Wr3uyprQs1lBoeYsSz5k4LKF0uooq62NEpvKUtnc+6SJ5BPnvB
	 dRRZ9Rc9AQZd1ECrvzRNZyjrXSjhm7D6oSgvEBbToclVk+RLSSAxqpyF86J+3SIkAEy/4
	 8EFgwEr5Fqik/D1q++TiKJVF5qjs8OUjf9MjYlfqjivM0mxlq5MJpV139Q8+eVY3Lvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=casper.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=SN+d9u9J;
	arc=none smtp.remote-ip=90.155.50.34
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50AC8606A338;
	Fri, 13 Nov 2026 18:26:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 50AC8606A338
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=SN+d9u9J
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=FJlTkZ/+iGrc2on2sDv49DKbHeUd0ygGYuQcqQHw4O4=; b=SN+d9u9JFQzBGQf4NAy7qocbuh
	0u7FgiaAx4+xKinMjXCbFmNXxBYZwqp1PbHkFFEAwMi/92Pxm5LWltQuv/fa/pF00zpn4HZuVA2DH
	t4QVa94FAMgTh7vK7Vl91fkp/MbV6B4nrCJS8qP20fQ7gGOCdQctg5UpiUeLaA2HfDcpAuRnkgmnq
	WRSmBzqeS2sIKrET1fJth6ATFydSlEsESFwrfoD6k/rvO02kf5M7I5ExzEdSB+tmG9W01vwQpMgQI
	2cwflpfBsvALHtC+r0o9GwiZFmrpPjE7U4J5f1ubxCLVMdK9xnLy0cQsPjDcXmJ0ufxrO/45Z9Njg
	TTK9Y63A==;
Received: from [2001:8b0:10b:1::425] (helo=i7.infradead.org)
	by casper.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xRvyS-00000004cT5-0AX8;
	Fri, 13 Nov 2026 18:26:08 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.99.5 #2 (Red Hat Linux))
	id 1xRvyR-00000000LYV-3HIa;
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
Subject: [RFC PATCH 11/13] KVM: planes: Let plane twins share DR6
Date: Fri, 13 Nov 2026 11:26:05 -0700
Message-ID: <20261113182607.82813-12-dwmw2@infradead.org>
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

The TLFS leaves DR6 sharing between VTLs processor-dependent and tells
the guest which way it went in HvRegisterVsmCapabilities.Dr6Shared. KVM
cannot know what the VMM advertises there, so make it a share bit and
let the VMM keep the two consistent: KVM_PLANE_SHARE_DR6.

The twins keep their own arch.dr6, kept equal whenever no plane is in
the guest:

 - after each plane's run in the KVM_RUN plane loop, its DR6 is copied
   to the twins. By then the exit has synced any DR6 the guest owned in
   hardware back into arch.dr6 (sync_dirty_debug_regs() on VMX and SVM,
   under KVM_DEBUGREG_WONT_EXIT); otherwise DR accesses are intercepted
   and arch.dr6 is the only copy. A VTL switch done in the kernel
   returns through the same loop;
 - KVM_SET_DEBUGREGS copies the new value to the twins at once;
 - a twin created later starts with plane 0's DR6, as for XCR0.

Converting every arch.dr6 user to a shared location instead would touch
the vendor, nested, SMM and exception code for no gain. Writers audited
for the copy-after-run rule:

 - MOV to DR6 (emulated, or direct under KVM_DEBUGREG_WONT_EXIT), #DB
   payload delivery (kvm_deliver_exception_payload()), RSM, INIT and
   nested VMRUN on SVM all write the DR6 of the plane that is running,
   so the next copy carries them;
 - a #DB still pending on a plane that is switched away from updates
   DR6 when that plane next takes it, which matches a debug exception
   that has not been delivered yet;
 - host-side debugging (KVM_SET_GUEST_DEBUG) reports in
   kvm_run->debug.arch.dr6 and leaves arch.dr6 alone;
 - vCPU ioctls on twins take the shared vCPU mutex, so none of them can
   observe a plane mid-run.

DR0-DR3 and DR7 stay per plane.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 Documentation/virt/kvm/api.rst  |  5 +++++
 arch/x86/include/uapi/asm/kvm.h |  1 +
 arch/x86/kvm/regs.c             |  1 +
 arch/x86/kvm/x86.c              | 25 +++++++++++++++++++++++++
 arch/x86/kvm/x86.h              |  4 +++-
 5 files changed, 35 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 22dc3c793bc4..351cc7448fe1 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -9353,6 +9353,11 @@ is set once.  The bits are:
 - KVM_PLANE_SHARE_XCR0: XCR0, whether written by the guest with XSETBV or
   with KVM_SET_XCRS on any plane's vCPU fd.  A plane vCPU created later
   starts with plane 0's value.
+- KVM_PLANE_SHARE_DR6: DR6.  A guest write, or a debug exception, in one
+  plane is seen by the others once that plane returns from KVM_RUN or
+  switches to another plane; a KVM_SET_DEBUGREGS on any plane's vCPU fd is
+  seen at once.  A plane vCPU created later starts with plane 0's value.
+  DR0-DR3 and DR7 stay per plane.
 
 8. Other capabilities.
 ======================
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index edec00979acf..dbfdc1188c20 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -924,6 +924,7 @@ struct kvm_sev_snp_launch_finish {
 
 /* KVM_CAP_PLANES args[1]: state the planes of a vCPU share */
 #define KVM_PLANE_SHARE_XCR0				_BITULL(0)
+#define KVM_PLANE_SHARE_DR6				_BITULL(1)
 
 struct kvm_hyperv_eventfd {
 	__u32 conn_id;
diff --git a/arch/x86/kvm/regs.c b/arch/x86/kvm/regs.c
index 3621f1a47d37..8a856e478095 100644
--- a/arch/x86/kvm/regs.c
+++ b/arch/x86/kvm/regs.c
@@ -876,6 +876,7 @@ int kvm_vcpu_ioctl_x86_set_debugregs(struct kvm_vcpu *vcpu,
 
 	kvm_update_dr0123(vcpu);
 	vcpu->arch.dr6 = dbgregs->dr6;
+	kvm_plane_share_dr6(vcpu);
 	vcpu->arch.dr7 = dbgregs->dr7;
 	kvm_update_dr7(vcpu);
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ceec10d116a9..7206ee889e9b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9362,6 +9362,26 @@ static int __kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, bool held)
 	return r;
 }
 
+/*
+ * With KVM_PLANE_SHARE_DR6, every twin holds the same DR6 whenever no plane
+ * is in the guest.  Copy it from @vcpu to its twins after @vcpu changed it:
+ * after an ioctl write, or after @vcpu ran, by which time its exit has
+ * synced any guest-owned hardware DR6 back into arch.dr6
+ * (sync_dirty_debug_regs() on both vendors).
+ */
+void kvm_plane_share_dr6(struct kvm_vcpu *vcpu)
+{
+	struct kvm_vcpu *twin;
+	int i;
+
+	if (!kvm_plane_shares(vcpu->kvm, KVM_PLANE_SHARE_DR6) ||
+	    vcpu->common->vcpus[vcpu->plane_level] != vcpu)
+		return;
+
+	vcpu_for_each_plane(vcpu->common, i, twin)
+		twin->arch.dr6 = vcpu->arch.dr6;
+}
+
 int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu_plane0)
 {
 	struct kvm_vcpu_common *common = vcpu_plane0->common;
@@ -9374,6 +9394,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu_plane0)
 		common->plane_switch = false;
 
 		ret = __kvm_arch_vcpu_ioctl_run(vcpu, held);
+		kvm_plane_share_dr6(vcpu);
 		if (ret)
 		       break;
 	} while (vcpu_plane0->common->plane_switch);
@@ -9854,6 +9875,10 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	if (kvm_plane_shares(vcpu->kvm, KVM_PLANE_SHARE_XCR0) &&
 	    vcpu->plane_level && vcpu->common->vcpus[0])
 		vcpu->arch.xcr0 = vcpu->common->vcpus[0]->arch.xcr0;
+	/* Likewise for a shared DR6. */
+	if (kvm_plane_shares(vcpu->kvm, KVM_PLANE_SHARE_DR6) &&
+	    vcpu->plane_level && vcpu->common->vcpus[0])
+		vcpu->arch.dr6 = vcpu->common->vcpus[0]->arch.dr6;
 	kvm_init_mmu(vcpu);
 	vcpu_put(vcpu);
 	return 0;
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index aa8abd219507..4da224eb1745 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -927,11 +927,13 @@ unsigned kvm_x86_default_max_planes(struct kvm *kvm);
  * The per-vCPU state that userspace may ask the planes of a vCPU to share,
  * in args[1] of KVM_ENABLE_CAP(KVM_CAP_PLANES).
  */
-#define KVM_PLANE_SHARE_VALID	KVM_PLANE_SHARE_XCR0
+#define KVM_PLANE_SHARE_VALID	(KVM_PLANE_SHARE_XCR0 | KVM_PLANE_SHARE_DR6)
 
 static inline bool kvm_plane_shares(struct kvm *kvm, u64 state)
 {
 	return READ_ONCE(kvm->arch.plane_share) & state;
 }
 
+void kvm_plane_share_dr6(struct kvm_vcpu *vcpu);
+
 #endif
-- 
2.50.1

