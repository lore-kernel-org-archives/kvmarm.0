Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=90.155.92.199
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794594399;
	b=cr5jv5dNs9EPk41wJvLuVsU7qC4i9NrroNe9rJsxrHXMZK8SO8fXkbHYDIaw37jdioEe
	 aoFKaeG+pvZlp8+UsLMe+8hbljWbA8O7mP7yTshzTCmkIPYsHcplPhGrZCe9Dx3EtEW2Z
	 f6+iDzIsJUawWWkexcYufS0VGZRL+4Qr7pUmi2nN2ZsXFrgjtaUSfqhnCE4cqAw/p/S2s
	 xnFi8PbSbsBtv9UE0ga+gOYnd9gD5LN01XcfUvshp3AWn0ldVtkF/hf93mE3Nhvu2MpQr
	 xqFHQ7dc67kCfdG6b08JWxAlpqLgqAgzdETmz1Kh6okniX42wyd4BXC6t7VeTbps5Tg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794594399;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:Sender:X-SRS-Rewrite;
	bh=a8uW+4oqYv72sJkgKsoP+73URG/7qnLsk5wAKeTN0oY=;
	b=hJu0POCyzBp+gs2ZBAI5HWaeHA6u5UJHjhjHzdfi5Q8x7DYeVuIRPkSvN+S6w5lp4IC6
	 gUIUJ9pCcG0Ve1Y99SJAg0J7Dvj2d6jFxlUM8I0IHDQD8jcAfSPgWTm3TGs45Oz9ddp9a
	 U/WcnwIJnLVF+Drk39Yvfl9df2SC+Gw7KtjIDQaDPo02JfNT5OiJuY4emBASk1/3HEKmm
	 1hC2kP4449JhikQPn8Hogl5vNOthZ+XQfsWX3np8LvXHZCtkVn7s4q1y90Wybfrn7w8BB
	 MPXR6pLEbkyQofjnYhro95l1TC76fEGCzi6cBDMnlYFRnss5Ka1rdCjcSKKYhaGEl/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=desiato.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=desiato.20200630 header.b=NYFEjsv5;
	arc=none smtp.remote-ip=90.155.92.199
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ED6D606C14A;
	Fri, 13 Nov 2026 18:26:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9ED6D606C14A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=desiato.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=desiato.20200630 header.b=NYFEjsv5
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=a8uW+4oqYv72sJkgKsoP+73URG/7qnLsk5wAKeTN0oY=; b=NYFEjsv5JTvQrCDdrUhtjYOnVL
	LzDBfP+Mjsbl3xJLs2jAxr3kd4oBKbxYWYpZ8iMXU+tLpBC7KqTAxCkMgBPYQc8eknIgPjUmWSz7N
	02Sb3NLmDWCINk3ZFejM+d2NHgjVf0C2ySvFgg7mjD57V+zP8RWF4IXmqxY2gB5ugzmRLvMOq7hQ1
	QutSMlT8ZFUUutHNk1hCGW6/UIc/S52KoMICy6LsrK6FZRbd5nDvGBUZ0SLRxkrtswQoCWlZEHHNG
	SAf6YGF3lcDdqFMBTwL1Pf5kQGFgCPkH8NVs3McggKSUHpAB0IyUP7zob49fNmWJmSAJ0BggMsZ8a
	96bz1rwg==;
Received: from [2001:8b0:10b:1::425] (helo=i7.infradead.org)
	by desiato.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xRvyU-0000000BeOZ-1731;
	Fri, 13 Nov 2026 18:26:30 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.99.5 #2 (Red Hat Linux))
	id 1xRvyR-00000000LYB-2VCU;
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
Subject: [RFC PATCH 06/13] KVM: planes: Fan out per-plane requests to twin vCPUs
Date: Fri, 13 Nov 2026 11:26:00 -0700
Message-ID: <20261113182607.82813-7-dwmw2@infradead.org>
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
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html

From: David Woodhouse <dwmw@amazon.co.uk>

A request raised on one plane's vCPU for a VM-wide reason (TLB flush
after a host-side zap, APIC page reload, obsolete-roots release) is
consumed by whichever twin runs first, so the other planes keep stale
translations. The plane-1 twin of a Windows VSM guest then runs on a
zapped root and the guest bugchecks.

Mark those three requests per-plane and make kvm_make_vcpu_request()
replicate any KVM_REQUEST_PER_PLANE request to every twin of the
target vCPU through vcpu_for_each_plane(). Mode and wait live in the
shared common and the kick targets the running twin's pCPU, so the
existing kick logic already reaches the twins.

The x86 kvm_exit and powerpc kvm_check_requests tracepoints logged
only the shared request word, so the three requests would vanish from
them. OR in the vCPU's plane requests instead; a separate field would
say which word a bit came from, but changes the tracepoint format for
little gain.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/powerpc/kvm/trace.h        |  3 ++-
 arch/x86/include/asm/kvm_host.h |  6 ++++--
 arch/x86/kvm/mmu/mmu.c          | 13 ++++++++-----
 arch/x86/kvm/trace.h            |  3 ++-
 include/linux/kvm_host.h        |  3 ++-
 virt/kvm/kvm_main.c             | 20 +++++++++++++++++++-
 6 files changed, 37 insertions(+), 11 deletions(-)

diff --git a/arch/powerpc/kvm/trace.h b/arch/powerpc/kvm/trace.h
index 35c000d918bb..2fc60a4e159f 100644
--- a/arch/powerpc/kvm/trace.h
+++ b/arch/powerpc/kvm/trace.h
@@ -108,7 +108,8 @@ TRACE_EVENT(kvm_check_requests,
 
 	TP_fast_assign(
 		__entry->cpu_nr		= vcpu->vcpu_id;
-		__entry->requests	= vcpu->common->requests;
+		__entry->requests	= READ_ONCE(vcpu->common->requests) |
+					  READ_ONCE(vcpu->plane_requests);
 	),
 
 	TP_printk("vcpu=%x requests=%x",
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index d4628ab99197..596be8ad7154 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -107,7 +107,8 @@
 	KVM_ARCH_REQ_FLAGS(15, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQ_GLOBAL_CLOCK_UPDATE	KVM_ARCH_REQ(16)
 #define KVM_REQ_APIC_PAGE_RELOAD \
-	KVM_ARCH_REQ_FLAGS(17, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
+	KVM_ARCH_REQ_FLAGS(17, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP | \
+			   KVM_REQUEST_PER_PLANE)
 #define KVM_REQ_HV_CRASH		KVM_ARCH_REQ(18)
 #define KVM_REQ_IOAPIC_EOI_EXIT		KVM_ARCH_PLANE_REQ(19)
 #define KVM_REQ_HV_RESET		KVM_ARCH_REQ(20)
@@ -125,7 +126,8 @@
 #define KVM_REQ_UPDATE_CPU_DIRTY_LOGGING \
 	KVM_ARCH_REQ_FLAGS(30, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQ_MMU_FREE_OBSOLETE_ROOTS \
-	KVM_ARCH_REQ_FLAGS(31, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
+	KVM_ARCH_REQ_FLAGS(31, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP | \
+			   KVM_REQUEST_PER_PLANE)
 #define KVM_REQ_HV_TLB_FLUSH \
 	KVM_ARCH_REQ_FLAGS(32, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQ_VMSA_PAGE_RELOAD \
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index e8eb1e48df36..ef6df08f5a99 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6405,11 +6405,14 @@ void kvm_mmu_free_obsolete_roots(struct kvm_vcpu *vcpu)
 	int i;
 
 	/*
-	 * KVM_REQ_MMU_FREE_OBSOLETE_ROOTS is tracked in the request set
-	 * shared by all of the vCPU's planes, so the plane that consumes
-	 * the request is not necessarily the plane whose root is obsolete.
-	 * Service every plane: the inactive twins cannot be running (all
-	 * planes of a vCPU share one thread), so their MMUs are stable.
+	 * KVM_REQ_MMU_FREE_OBSOLETE_ROOTS fans out to every plane twin,
+	 * but each twin only consumes its own copy when it next runs, and
+	 * a plane that userspace never re-enters would pin its obsolete
+	 * roots indefinitely.  Service every plane from whichever twin
+	 * consumes its request first: the inactive twins cannot be
+	 * running (all planes of a vCPU share one thread), so their MMUs
+	 * are stable, and a twin's own later request finds nothing left
+	 * to free.
 	 */
 	vcpu_for_each_plane(vcpu->common, i, v) {
 		__kvm_mmu_free_obsolete_roots(vcpu->kvm, &v->arch.root_mmu);
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index 7038e596019a..ad901836c08a 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -409,7 +409,8 @@ TRACE_EVENT(name,							     \
 		__entry->guest_rip	= tracing_kvm_rip_read(vcpu);		     \
 		__entry->isa            = isa;				     \
 		__entry->vcpu_id        = vcpu->vcpu_id;		     \
-		__entry->requests       = READ_ONCE(vcpu->common->requests); \
+		__entry->requests       = READ_ONCE(vcpu->common->requests) | \
+					  READ_ONCE(vcpu->plane_requests);   \
 		kvm_x86_call(get_exit_info)(vcpu,			     \
 					    &__entry->exit_reason,	     \
 					    &__entry->info1,		     \
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index b30982fcd3e7..6c50c1dc5819 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -168,7 +168,8 @@ static inline bool kvm_is_error_gpa(gpa_t gpa)
  * Architecture-independent vcpu->requests bit members
  * Bits 3-7 are reserved for more arch-independent bits.
  */
-#define KVM_REQ_TLB_FLUSH		(0 | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
+#define KVM_REQ_TLB_FLUSH \
+	(0 | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP | KVM_REQUEST_PER_PLANE)
 #define KVM_REQ_VM_DEAD			(1 | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQ_UNBLOCK			2
 #define KVM_REQ_DIRTY_RING_SOFT_FULL	3
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 6a00654490ae..c323d067256e 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -237,9 +237,27 @@ static void kvm_make_vcpu_request(struct kvm_vcpu *vcpu, unsigned int req,
 {
 	int cpu;
 
-	if (likely(!(req & KVM_REQUEST_NO_ACTION)))
+	if (likely(!(req & KVM_REQUEST_NO_ACTION))) {
 		__kvm_make_request(req, vcpu);
 
+		/*
+		 * A per-plane request raised on "the vCPU" (TLB flush after
+		 * a host-side zap, obsolete-roots reload, ...) concerns
+		 * every plane: fan it out to the twins, or the plane that
+		 * runs next consumes a bit the others still need.  Mode and
+		 * wait live in the common and the kick below targets the
+		 * running twin's pCPU, so it covers the twins too.
+		 */
+		if (req & KVM_REQUEST_PER_PLANE) {
+			struct kvm_vcpu *twin;
+			int p;
+
+			vcpu_for_each_plane(vcpu->common, p, twin)
+				if (twin != vcpu)
+					__kvm_make_request(req, twin);
+		}
+	}
+
 	if (!(req & KVM_REQUEST_NO_WAKEUP) && kvm_vcpu_wake_up(vcpu))
 		return;
 
-- 
2.50.1

