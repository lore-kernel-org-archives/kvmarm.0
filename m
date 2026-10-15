Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DD944CDA36;
	Thu, 15 Oct 2026 10:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792058747; cv=none; b=TrKMoo7UyLln1EHE6z6E/cJToYR8vO0ZQdHiXmqz2FcVWfsDBQiBiuZpmyAx+VFLm7d6/3J/Nrj+TUEG3vSAi4s66GuCfWMRwTfw9uWGAy//0uAdPSKMtMftjno5rFx+TBkrPWGuZitCZvngAMhc3dXyUJ8O/IwmizgPAmxZLDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792058747; c=relaxed/simple;
	bh=XemyTu1guX1fO0MNgohfpd9YNpsa60jN6nTSeQ4pGMc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u353Q2I52KAzJ2j5YwDXf9RwikSRumXoky44ozW3Qtvd4GLZWBohcP2nPdmCkRaA56AWzjkqROMzU78eouZM+tVf6dobyGtLTF9nHXsJTqHmlYAdEOpNOmFXItbGal5+QfXnrlNir633W//x4KP7534nAHhX4GETBAr3UQsvRJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O4J8jMkN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O4J8jMkN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6233E1F000CA;
	Thu, 15 Oct 2026 10:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792058745;
	bh=KhijomrVgpU5nlp7P5LehWDg9luMd/07B0ez7SrB20I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O4J8jMkN/oVXCbOwp54mOsV0gq8TVDrbE8CyHnpbT1373tcbyhO0qdtgSNSttkErz
	 +AsUgx1ZbS6SZvjqt0GnqnmeoqgoFEhq2KfQfxA09/aZpsuRB+N2hRKlJy2qQR9MdN
	 HBXlpDL9TjVzQ1PNycuaUJLM6L56v4gQWY7D7cJ8NBlC18oQxnd8o4obpPaQQPSGHF
	 op9xPXefuVtdDs+Hno4f0NvY8ra3O2HxENN7YQTrZa82l0BQEX011sThQTNAbE/ivc
	 dpYRE0c4L2WXE29sR1hIPASkdSBD2X8N0CnlWZu/eMJB2W58yv3hRtalh1aQs8hkQ7
	 QNpAbXttgncEg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1xHILH-00000003EfK-2jnd;
	Thu, 15 Oct 2026 10:05:43 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Fuad Tabba <fuad.tabba@linux.dev>
Subject: [PATCH 5/7] KVM: arm64: Add helpers to halt a vCPU
Date: Thu, 15 Oct 2026 11:05:37 +0100
Message-ID: <20261015100539.1011760-6-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261015100539.1011760-1-maz@kernel.org>
References: <20261015100539.1011760-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, fuad.tabba@linux.dev
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

From: Oliver Upton <oupton@kernel.org>

Currently we pause the entire VM when modifying VGIC state that requires
state to be synchronized back from hardware. This is perfectly fine for
heavyweight operations but not ideal for 'simple' things like migrating
an active/pending IRQ.

Add helpers for halting a single vCPU such that they can be used to
manipulate the AP list remotely.

Signed-off-by: Oliver Upton <oupton@kernel.org>
Link: https://patch.msgid.link/20260929212925.31775-2-oupton@kernel.org
[maz: fixed to use kvm_make_vcpus_request_mask(), guaranteeing that the
      caller waits for the target vcpu to handle the IPI]
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h |  2 ++
 arch/arm64/kvm/arm.c              | 21 +++++++++++++++++----
 2 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 9c068f27f9b8a..7b4f7b6d94b8d 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1254,6 +1254,8 @@ int __kvm_arm_vcpu_set_events(struct kvm_vcpu *vcpu,
 
 void kvm_arm_halt_guest(struct kvm *kvm);
 void kvm_arm_resume_guest(struct kvm *kvm);
+void kvm_pause_vcpu(struct kvm_vcpu *vcpu);
+void kvm_resume_vcpu(struct kvm_vcpu *vcpu);
 
 #define vcpu_has_run_once(vcpu)	(!!READ_ONCE((vcpu)->pid))
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 07bf8b2e683d5..a2f1606822614 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1017,6 +1017,21 @@ bool kvm_arch_intc_initialized(struct kvm *kvm)
 	return vgic_initialized(kvm);
 }
 
+void kvm_pause_vcpu(struct kvm_vcpu *vcpu)
+{
+	DECLARE_BITMAP(vcpu_bitmap, KVM_MAX_VCPUS) = { };
+
+	atomic_inc(&vcpu->arch.pause);
+	__set_bit(vcpu->vcpu_idx, vcpu_bitmap);
+	kvm_make_vcpus_request_mask(vcpu->kvm, KVM_REQ_SLEEP, vcpu_bitmap);
+}
+
+void kvm_resume_vcpu(struct kvm_vcpu *vcpu)
+{
+	if (atomic_dec_and_test(&vcpu->arch.pause))
+		__kvm_vcpu_wake_up(vcpu);
+}
+
 void kvm_arm_halt_guest(struct kvm *kvm)
 {
 	unsigned long i;
@@ -1032,10 +1047,8 @@ void kvm_arm_resume_guest(struct kvm *kvm)
 	unsigned long i;
 	struct kvm_vcpu *vcpu;
 
-	kvm_for_each_vcpu(i, vcpu, kvm) {
-		if (atomic_dec_and_test(&vcpu->arch.pause))
-			__kvm_vcpu_wake_up(vcpu);
-	}
+	kvm_for_each_vcpu(i, vcpu, kvm)
+		kvm_resume_vcpu(vcpu);
 }
 
 static void kvm_vcpu_sleep(struct kvm_vcpu *vcpu)
-- 
2.47.3

