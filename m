Received: from mail.8bytes.org (mail.8bytes.org [85.214.250.239])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 324B83F8252;
	Mon,  8 Jun 2026 14:43:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.250.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780929815; cv=none; b=ARUIF0iP/kM6YZwVauJzJEdQfSB8Ifw7ivBtiivjRb/f8HE62Kg5vjqzfUhJjTy9wdaJ5IOPFKigAp44Xk9WTMxWuaAltCYJ4C4J6mvpBNkjdyI36aL09mY2Pnp8iucM3KHcqaNmBE0SaeLByOGS8fmzpwdgEtVe8ClJfPz9UzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780929815; c=relaxed/simple;
	bh=aVqlOlfWSlxkvl0aGEqOt0VKD9r53NJ0PvMQ3ZrPPvY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q5sVBaJTCNUlVUsyWPmbqvCvVZ4YmePs7AuAiIR6fQTj2CWkE8U63WPzVZYjfQ9UiNvYrJq14hpNgB76dqjipr9Eq7Mt4rt0s0n6ilvKLV53GmJziyYqZCn009t5jpS+hNQI8G1954obKm9NmkVxe6nPckNJ+ygy8muR1stl7FE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org; spf=pass smtp.mailfrom=8bytes.org; arc=none smtp.client-ip=85.214.250.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=8bytes.org
Received: from io.home.8bytes.org (p4ffe1d30.dip0.t-ipconnect.de [79.254.29.48])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.8bytes.org (Postfix) with ESMTPSA id 2E2042028D2;
	Mon,  8 Jun 2026 16:43:15 +0200 (CEST)
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
Subject: [PATCH 47/60] kvm: x86: Select a plane to run
Date: Mon,  8 Jun 2026 16:42:39 +0200
Message-ID: <20260608144252.351443-48-joro@8bytes.org>
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

In the KVM_RUN path, select a runnable VCPU plane and use it to enter
the guest. Also handle KVM_REQ_PLANE_RESCHED events to switch planes
without exiting to user-space.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/x86.c | 29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7e94a378b3d2..b9828cd31136 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11398,6 +11398,12 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 				goto out;
 			}
 		}
+
+		if (kvm_check_request(KVM_REQ_PLANE_RESCHED, vcpu)) {
+			vcpu->common->plane_switch = true;
+			r = 0;
+			goto out;
+		}
 	}
 
 	if (kvm_check_request(KVM_REQ_EVENT, vcpu) || req_int_win ||
@@ -12076,7 +12082,7 @@ static int kvm_x86_vcpu_pre_run(struct kvm_vcpu *vcpu)
 	return kvm_x86_call(vcpu_pre_run)(vcpu);
 }
 
-int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
+static int __kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 {
 	struct kvm_queued_exception *ex = &vcpu->arch.exception;
 	struct kvm_run *kvm_run = vcpu->run;
@@ -12196,6 +12202,27 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 	return r;
 }
 
+int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu_plane0)
+{
+	struct kvm_vcpu_common *common = vcpu_plane0->common;
+	int ret;
+
+	do {
+		struct kvm_vcpu *vcpu = kvm_vcpu_select_plane(vcpu_plane0);
+
+		if (vcpu == NULL)
+			return -EINVAL;
+
+		common->plane_switch = false;
+
+		ret = __kvm_arch_vcpu_ioctl_run(vcpu);
+		if (ret)
+		       break;
+	} while (vcpu_plane0->common->plane_switch);
+
+	return ret;
+}
+
 static void __get_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
 {
 	if (vcpu->arch.emulate_regs_need_sync_to_vcpu) {
-- 
2.53.0

