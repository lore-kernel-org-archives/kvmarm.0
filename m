Received: from mail.8bytes.org (mail.8bytes.org [85.214.250.239])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC51D3F075E;
	Mon,  8 Jun 2026 14:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.250.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780929803; cv=none; b=b3cVajcYtBH9IpogF/M/3+6HehST+GhODrNUnoXkH6OJYG7qIa86Gs+/gokCOW5vT6yy2VoPyU5ZFG54QSH07XfJffWJtg0iDtV9+hoTw/RxJVKbiEKZLcjUTFDzp1AF98qDVLYcWOxN8TcKpUTz9VSHpAUjHX8ZFCeXsb1XGgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780929803; c=relaxed/simple;
	bh=kOvAnWF8emIWImmwd6rNegwO3tFStg788ZfeLjFwEDE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TzP4lxcXehvzDopr795ssm6Ksx8VucDYNsREqbSHO48gJWXRLq2Z3JkUd13WX8Qr/t7u0VdR594iGK6G8jCrGy08KBBVe/ttycdiPk0BVnE4gHvjQiW6QXB50upx+9ZRyIuKGJ/+BVxAb8O+DHlzFX21FrSzxC39/VQowh1uy4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org; spf=pass smtp.mailfrom=8bytes.org; arc=none smtp.client-ip=85.214.250.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=8bytes.org
Received: from io.home.8bytes.org (p4ffe1d30.dip0.t-ipconnect.de [79.254.29.48])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.8bytes.org (Postfix) with ESMTPSA id 8C9352028B7;
	Mon,  8 Jun 2026 16:43:09 +0200 (CEST)
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
Subject: [PATCH 21/60] kvm: Introduce per-plane VCPU requests
Date: Mon,  8 Jun 2026 16:42:13 +0200
Message-ID: <20260608144252.351443-22-joro@8bytes.org>
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

The bitfield layout is shared with the global vcpu->common->requests
field. A new flag will indicate in which bitmap the request will be
set.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 include/linux/kvm_host.h | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 7704820986da..3c72a462ccfa 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -159,6 +159,7 @@ static inline bool kvm_is_error_gpa(gpa_t gpa)
 #define KVM_REQUEST_NO_WAKEUP      BIT(8)
 #define KVM_REQUEST_WAIT           BIT(9)
 #define KVM_REQUEST_NO_ACTION      BIT(10)
+#define KVM_REQUEST_PER_PLANE      BIT(11)
 /*
  * Architecture-independent vcpu->requests bit members
  * Bits 3-7 are reserved for more arch-independent bits.
@@ -184,6 +185,7 @@ static inline bool kvm_is_error_gpa(gpa_t gpa)
 	(unsigned)(((nr) + KVM_REQUEST_ARCH_BASE) | (flags)); \
 })
 #define KVM_ARCH_REQ(nr)           KVM_ARCH_REQ_FLAGS(nr, 0)
+#define KVM_ARCH_PLANE_REQ(nr)     KVM_ARCH_REQ_FLAGS(nr, KVM_REQUEST_PER_PLANE)
 
 bool kvm_make_vcpus_request_mask(struct kvm *kvm, unsigned int req,
 				 unsigned long *vcpu_bitmap);
@@ -371,6 +373,10 @@ struct kvm_vcpu {
 	int sigset_active;
 	sigset_t sigset;
 	unsigned int halt_poll_ns;
+
+	u64 plane_requests;
+
+	/* S390 only */
 	bool valid_wakeup;
 
 #ifdef CONFIG_HAS_IOMEM
@@ -2356,7 +2362,10 @@ static inline void __kvm_make_request(int req, struct kvm_vcpu *vcpu)
 	 * caller.  Paired with the smp_mb__after_atomic in kvm_check_request.
 	 */
 	smp_wmb();
-	set_bit(req & KVM_REQUEST_MASK, (void *)&vcpu->common->requests);
+	if (req & KVM_REQUEST_PER_PLANE)
+		set_bit(req & KVM_REQUEST_MASK, (void *)&vcpu->plane_requests);
+	else
+		set_bit(req & KVM_REQUEST_MASK, (void *)&vcpu->common->requests);
 }
 
 static __always_inline void kvm_make_request(int req, struct kvm_vcpu *vcpu)
@@ -2382,17 +2391,23 @@ static inline void kvm_make_request_and_kick(int req, struct kvm_vcpu *vcpu)
 
 static inline bool kvm_request_pending(struct kvm_vcpu *vcpu)
 {
-	return READ_ONCE(vcpu->common->requests);
+	return READ_ONCE(vcpu->common->requests) || READ_ONCE(vcpu->plane_requests);
 }
 
 static inline bool kvm_test_request(int req, struct kvm_vcpu *vcpu)
 {
-	return test_bit(req & KVM_REQUEST_MASK, (void *)&vcpu->common->requests);
+	if (req & KVM_REQUEST_PER_PLANE)
+		return test_bit(req & KVM_REQUEST_MASK, (void *)&vcpu->plane_requests);
+	else
+		return test_bit(req & KVM_REQUEST_MASK, (void *)&vcpu->common->requests);
 }
 
 static inline void kvm_clear_request(int req, struct kvm_vcpu *vcpu)
 {
-	clear_bit(req & KVM_REQUEST_MASK, (void *)&vcpu->common->requests);
+	if (req & KVM_REQUEST_PER_PLANE)
+		clear_bit(req & KVM_REQUEST_MASK, (void *)&vcpu->plane_requests);
+	else
+		clear_bit(req & KVM_REQUEST_MASK, (void *)&vcpu->common->requests);
 }
 
 static inline bool kvm_check_request(int req, struct kvm_vcpu *vcpu)
-- 
2.53.0

