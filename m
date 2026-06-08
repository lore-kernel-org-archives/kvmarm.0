Received: from mail.8bytes.org (mail.8bytes.org [85.214.250.239])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F0273D9DA6;
	Mon,  8 Jun 2026 14:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.250.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780929810; cv=none; b=OcmEzkKosCIl/79sMmykZkstcPEmlS97R8hn3n1qVj/Pkp3CbgBtJvIMXoW03HiokMu1kF2i87S3K3sZW0FY93VibG7eU8nwM/HKxSwPlZKDN4oX3WZjU7KmDHHoqQJO8f3odUwJRbSiLj+c2OAlAwBEgrtSgtkwAicMIhFAI64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780929810; c=relaxed/simple;
	bh=J+67ah56y0H5ya3e/qDjkJPOMib0mghuvfen1IXiDd4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TKCIOUJNw8anfeIoJvnZnKNZoctbtUr7B7BSwlzMMO2MgT10AZ1VIvPMYw5YYGw9mDsBdFiSe1oRcyjgS5Cmbi3kequOlupzTNLuLfl4rOqT/JhbKaFvuNvBsgAbiESARwn0JuM5wx9EAInK4C9AiAm/6ELpHz71Faa96wLt8kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org; spf=pass smtp.mailfrom=8bytes.org; arc=none smtp.client-ip=85.214.250.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=8bytes.org
Received: from io.home.8bytes.org (p4ffe1d30.dip0.t-ipconnect.de [79.254.29.48])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.8bytes.org (Postfix) with ESMTPSA id F24592028B9;
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
Subject: [PATCH 23/60] kvm: Move kvm_vcpu sigset members to struct kvm_vcpu_common
Date: Mon,  8 Jun 2026 16:42:15 +0200
Message-ID: <20260608144252.351443-24-joro@8bytes.org>
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

These are the same across all planes for one VCPU, so make then
shared.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 include/linux/kvm_host.h |  4 ++--
 virt/kvm/kvm_main.c      | 18 ++++++++++++------
 2 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 73786712495d..9220c452aa3a 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -348,6 +348,8 @@ struct kvm_vcpu_common {
 
 	struct pid *pid;
 	rwlock_t pid_lock;
+	int sigset_active;
+	sigset_t sigset;
 
 	/* Scheduling state */
 #ifdef CONFIG_PREEMPT_NOTIFIERS
@@ -371,8 +373,6 @@ struct kvm_vcpu {
 
 	struct kvm_run *run;
 
-	int sigset_active;
-	sigset_t sigset;
 	unsigned int halt_poll_ns;
 
 	u64 plane_requests;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index af3c4e0081b8..1858880ee3d3 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3694,7 +3694,9 @@ EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_vcpu_mark_page_dirty);
 
 void kvm_sigset_activate(struct kvm_vcpu *vcpu)
 {
-	if (!vcpu->sigset_active)
+	struct kvm_vcpu_common *common = vcpu->common;
+
+	if (!common->sigset_active)
 		return;
 
 	/*
@@ -3703,12 +3705,14 @@ void kvm_sigset_activate(struct kvm_vcpu *vcpu)
 	 * ->real_blocked don't care as long ->real_blocked is always a subset
 	 * of ->blocked.
 	 */
-	sigprocmask(SIG_SETMASK, &vcpu->sigset, &current->real_blocked);
+	sigprocmask(SIG_SETMASK, &common->sigset, &current->real_blocked);
 }
 
 void kvm_sigset_deactivate(struct kvm_vcpu *vcpu)
 {
-	if (!vcpu->sigset_active)
+	struct kvm_vcpu_common *common = vcpu->common;
+
+	if (!common->sigset_active)
 		return;
 
 	sigprocmask(SIG_SETMASK, &current->real_blocked, NULL);
@@ -4391,12 +4395,14 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, unsigned long id)
 
 static int kvm_vcpu_ioctl_set_sigmask(struct kvm_vcpu *vcpu, sigset_t *sigset)
 {
+	struct kvm_vcpu_common *common = vcpu->common;
+
 	if (sigset) {
 		sigdelsetmask(sigset, sigmask(SIGKILL)|sigmask(SIGSTOP));
-		vcpu->sigset_active = 1;
-		vcpu->sigset = *sigset;
+		common->sigset_active = 1;
+		common->sigset = *sigset;
 	} else
-		vcpu->sigset_active = 0;
+		common->sigset_active = 0;
 	return 0;
 }
 
-- 
2.53.0

