Received: from mail.8bytes.org (mail.8bytes.org [85.214.250.239])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9ACE53EFFDC;
	Mon,  8 Jun 2026 14:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.250.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780929814; cv=none; b=V2xVN3Z5G+wIIMNsQgwPHVbIHG3vi+mlNC9CAIFXCYhJnxuqcoNaI2yVSADfpzFZ8kFM3ze1QhkSAosMxlqia0CIdGxFi4xjzUUA+Iqf2ua5ZR1D8A8ly3Gia5hnI8biPllcHeGaYRiK6AiVSiuwhvAWIFDKmHzBc7o1h9cZlLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780929814; c=relaxed/simple;
	bh=rjRicFhdiHr6AqgukbSCnxUOsYOwJrllYxviYzEIXME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sLQgYWSOkCu3AYRfM6phIkIWrWIrZVVCJx4g9WqJcKD0qN/WAI1TuVZLraa6NrE8ffQ+q9XV910mUijX4T79NjYqMcrR+T2l3vSN2re8jiMv3KdQEZ5atGgouJa4GCBXKr5sLfo5nOpbLzjnrjVarjmhKJS/VetH7fBzFsi41WE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org; spf=pass smtp.mailfrom=8bytes.org; arc=none smtp.client-ip=85.214.250.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=8bytes.org
Received: from io.home.8bytes.org (p4ffe1d30.dip0.t-ipconnect.de [79.254.29.48])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.8bytes.org (Postfix) with ESMTPSA id A6BAD2028CB;
	Mon,  8 Jun 2026 16:43:13 +0200 (CEST)
From: =?UTF-8?q?J=C3=B6rg=20R=C3=B6del?= <joro@8bytes.org>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>,
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
	joerg.roedel@amd.com
Subject: [PATCH 40/60] kvm: x86: Handle IOAPIC EOIs per plane
Date: Mon,  8 Jun 2026 16:42:32 +0200
Message-ID: <20260608144252.351443-41-joro@8bytes.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260608144252.351443-1-joro@8bytes.org>
References: <20260608144252.351443-1-joro@8bytes.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Joerg Roedel <joerg.roedel@amd.com>

Make sure the handling of IOAPIC EOIs is aware of planes.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/irq.c              |  3 ++-
 arch/x86/kvm/x86.c              | 10 ++++++++--
 3 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 1393566741a0..134bc02962fd 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -109,7 +109,7 @@
 #define KVM_REQ_APIC_PAGE_RELOAD \
 	KVM_ARCH_REQ_FLAGS(17, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQ_HV_CRASH		KVM_ARCH_REQ(18)
-#define KVM_REQ_IOAPIC_EOI_EXIT		KVM_ARCH_REQ(19)
+#define KVM_REQ_IOAPIC_EOI_EXIT		KVM_ARCH_PLANE_REQ(19)
 #define KVM_REQ_HV_RESET		KVM_ARCH_REQ(20)
 #define KVM_REQ_HV_EXIT			KVM_ARCH_REQ(21)
 #define KVM_REQ_HV_STIMER		KVM_ARCH_REQ(22)
diff --git a/arch/x86/kvm/irq.c b/arch/x86/kvm/irq.c
index 90e2d2db2123..bc748a4b7cbd 100644
--- a/arch/x86/kvm/irq.c
+++ b/arch/x86/kvm/irq.c
@@ -400,7 +400,8 @@ void kvm_scan_ioapic_routes(struct kvm_vcpu *vcpu,
 		hlist_for_each_entry(entry, &table->map[i], link) {
 			struct kvm_lapic_irq irq;
 
-			if (entry->type != KVM_IRQ_ROUTING_MSI)
+			if (entry->type != KVM_IRQ_ROUTING_MSI ||
+			    entry->msi.plane_level != vcpu->plane_level)
 				continue;
 
 			kvm_msi_to_lapic_irq(vcpu->kvm, entry, &irq);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 623838885753..a158740a6fc1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11336,8 +11336,14 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 				goto out;
 			}
 		}
-		if (kvm_check_request(KVM_REQ_SCAN_IOAPIC, vcpu))
-			vcpu_scan_ioapic(vcpu);
+		if (kvm_check_request(KVM_REQ_SCAN_IOAPIC, vcpu)) {
+			struct kvm_vcpu *v;
+			unsigned i;
+
+			vcpu_for_each_plane(vcpu->common, i, v) {
+				vcpu_scan_ioapic(v);
+			}
+		}
 		if (kvm_check_request(KVM_REQ_LOAD_EOI_EXITMAP, vcpu))
 			vcpu_load_eoi_exitmap(vcpu);
 		if (kvm_check_request(KVM_REQ_APIC_PAGE_RELOAD, vcpu))
-- 
2.53.0

