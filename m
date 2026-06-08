Received: from mail.8bytes.org (mail.8bytes.org [85.214.250.239])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA9923F44EA;
	Mon,  8 Jun 2026 14:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.250.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780929817; cv=none; b=s7yTmp3N0VKNlc/DyrMYn1sQHctlYEYI4Qhgmj/NfnqbcKK90aJ52WQQfoVVaMXGH6nM2mZHuNPdG65BBH7gAOxFr9N3lbKbYbVkjZf5Jwj7SLRyBNNzMRuEFI+CGSZs6aXeiygkv2fWyBnTXLY8nFBzz3heO7Nz2ybu+i2KxXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780929817; c=relaxed/simple;
	bh=eH3f+WuPMLAuoE2Ew5uwF/+/AYqpqginB/0ahvdEg0I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TwOqcfB7oGqacdM5VE1UHTlTn6tH73utBtCHxaIaH30wTXDV3Z/ta9fog+j6jZamvo62uEv49zzBJu8h2bVyoIjN04qM+rRkEmQpJXl6derzzh2XX/TdkiSAQKA6V1J8eyT/zbe/UQe9VZ3Sh2PBmn+s6jCXe+Luh0oCajHxDi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org; spf=pass smtp.mailfrom=8bytes.org; arc=none smtp.client-ip=85.214.250.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=8bytes.org
Received: from io.home.8bytes.org (p4ffe1d30.dip0.t-ipconnect.de [79.254.29.48])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.8bytes.org (Postfix) with ESMTPSA id 3B9172028D7;
	Mon,  8 Jun 2026 16:43:16 +0200 (CEST)
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
Subject: [PATCH 52/60] kvm: x86: Switch to plane0 if it has events
Date: Mon,  8 Jun 2026 16:42:44 +0200
Message-ID: <20260608144252.351443-53-joro@8bytes.org>
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

When there are IRQs or events pending for plane0, make sure it can
handle it.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/x86.c | 34 +++++++++++++++++++++++++++++-----
 1 file changed, 29 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 08fe65b8d57d..60b34bd4da9d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10962,6 +10962,20 @@ static int kvm_check_and_inject_events(struct kvm_vcpu *vcpu,
 	return r;
 }
 
+static inline bool kvm_check_plane0_events(struct kvm_vcpu *vcpu)
+{
+	struct kvm_vcpu *vcpu_plane0;
+
+	if (vcpu->plane_level == 0)
+		return false;
+
+	vcpu_plane0 = vcpu->common->vcpus[0];
+
+	return kvm_cpu_has_injectable_intr(vcpu_plane0) ||
+		vcpu_plane0->arch.nmi_pending ||
+		vcpu_plane0->arch.smi_pending;
+}
+
 static void process_nmi(struct kvm_vcpu *vcpu)
 {
 	unsigned int limit;
@@ -11410,12 +11424,19 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 				goto out;
 			}
 		}
+	}
 
-		if (kvm_check_request(KVM_REQ_PLANE_RESCHED, vcpu)) {
-			vcpu->common->plane_switch = true;
-			r = 0;
-			goto out;
-		}
+	if (kvm_check_plane0_events(vcpu)) {
+		kvm_vcpu_set_plane_runnable(vcpu->common->vcpus[0]);
+
+		kvm_make_request(KVM_REQ_EVENT, vcpu);
+		kvm_make_request(KVM_REQ_PLANE_RESCHED, vcpu);
+	}
+
+	if (kvm_check_request(KVM_REQ_PLANE_RESCHED, vcpu)) {
+		vcpu->common->plane_switch = true;
+		r = 0;
+		goto out;
 	}
 
 	if (kvm_check_request(KVM_REQ_EVENT, vcpu) || req_int_win ||
@@ -11737,6 +11758,9 @@ bool kvm_vcpu_has_events(struct kvm_vcpu *vcpu)
 	if (kvm_test_request(KVM_REQ_UPDATE_PROTECTED_GUEST_STATE, vcpu))
 		return true;
 
+	if (kvm_test_request(KVM_REQ_PLANE_RESCHED, vcpu))
+		return true;
+
 	if (kvm_arch_interrupt_allowed(vcpu) && kvm_cpu_has_interrupt(vcpu))
 		return true;
 
-- 
2.53.0

