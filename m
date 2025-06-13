Received: from mail-io1-f73.google.com (mail-io1-f73.google.com [209.85.166.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B620920E313
	for <kvmarm@lists.linux.dev>; Fri, 13 Jun 2025 15:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749829966; cv=none; b=kLfTqhtNJuQEQxYDJGibihLFfmGQ/gsyzr6DIiNTHYEF6qsMMmc7AAHe48hGjQm91h7HANYqhFvLh1mVrrNIV1W91o+1RCXrdJQB5HRm4qwKnXR9n1no5ZnGosr+ymX4pitCuQ3K0R1dQ5J4/35DtxqSaivBdMXwNDe6UI24oxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749829966; c=relaxed/simple;
	bh=Ci1/ilbhd8VIC+oxHWhP8i2cQbOsisZvulH3qn/eMlw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=juQ4Uu1th76exhKiOWQAMwPCk8bUtZIEnGdDFgQW0HN6n+/5zKgJzNvaEmO1JUIO/a2y63LInXseLH5JjKI9u2IB4JkW9gSZgOrViVkMH6fWKTav6A0wS/d5n5NZMs3Ifwbs5jk6PP97Issy3C8ZRPjnJYnyZEm//2psFH9G2CM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ponzq9oX; arc=none smtp.client-ip=209.85.166.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ponzq9oX"
Received: by mail-io1-f73.google.com with SMTP id ca18e2360f4ac-86463467dddso255098239f.3
        for <kvmarm@lists.linux.dev>; Fri, 13 Jun 2025 08:52:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749829964; x=1750434764; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=oeEVYUZ5YyS7Po4kQ9W2WYTxXWOxgfNLZlSZcUsGw0o=;
        b=ponzq9oX1sPHuWNNRMBeWxLExgu5oHgdxndvylbbauBi2H2BfmhvtATXqDLiaGm26o
         4nNWUkH3UPq8EJtycxZSpkuU/VQ7iWz/sF7IroAsNGqHem+hP91EAYmZaMZYD3hKBMaa
         zghQYRZ0ejtMHIIIcmAot+px9NZc3zU3JXtBCv37s0Mmobszno628XtHulpY75EIBlq8
         oKssY7vyjyrNh1Pg7gjfT0kN8yyg8s/cJ1xriJOc5vfI09FzqCEwafupcOGiCM9gc+B9
         sQPGrTHwsktIuxlexKKkUlvsre7MFJoALiRc2Y/Hs7rEm/xscMntaihqWtDOdbqTyv4t
         yCAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749829964; x=1750434764;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oeEVYUZ5YyS7Po4kQ9W2WYTxXWOxgfNLZlSZcUsGw0o=;
        b=YS5fj9gCeJjcPT1cGW2UFioBa343mYR+YljQ3o0Xi33R8M28Y4JalTMiYmdDOJVfqu
         CQvLKfOhu0wI46GAh+WCSd0LpQMIPz0qp0VXU38b1s8d2elOkSUdL5Ib5mTSEH0qwp7k
         ZPD5bJZLM21pZWKLTbFzSacIIS/3PZuetirFJk2gtA+/wC/QvvyKIfpoWn9Ysr6+4JJE
         QP3dkpTlucOce3sVHN3DFTkViVhZgPoite8olEW5KqspzNaiqy9Nh6/nkbqDYihIvhts
         ujscyNDH32E5wRzmet3mJoaL/6ShlEAJtmlkZI+BR0WjfX1U2E8UJEWYFLBDI277W94s
         p+9Q==
X-Forwarded-Encrypted: i=1; AJvYcCUQYgg6Se8sXacfDYUYjQA4AY9PMRgnwkfFmeIMbnCYbfsKayKHeLVHCQjAalzqJ5I1y1JBOyc=@lists.linux.dev
X-Gm-Message-State: AOJu0YzX/msWZ082IjUXPj54fT/YkYAmqNMSqSkDoB+7nSjL8+ucxyAO
	T+SNLqV5TUnwnhTcF0/H7nem6q/tAhhKxF5vsp8DXmhGNR0mNDoaGUMNEPPX/F1lqSVpFMCXc5m
	4Qergjlq+FA==
X-Google-Smtp-Source: AGHT+IFunbFJhKmi5ZFShXe5exfB3EJuEIksn0wi7XdmxJ1Imwtlw1UTfq/1Z4OxBS2uV1KpJFLBY6hAS3Gk
X-Received: from iobel14.prod.google.com ([2002:a05:6602:3e8e:b0:86c:fede:130b])
 (user=rananta job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6602:7504:b0:873:f22:92fb
 with SMTP id ca18e2360f4ac-875d3bf0780mr439553039f.1.1749829963955; Fri, 13
 Jun 2025 08:52:43 -0700 (PDT)
Date: Fri, 13 Jun 2025 15:52:35 +0000
In-Reply-To: <20250613155239.2029059-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250613155239.2029059-1-rananta@google.com>
X-Mailer: git-send-email 2.50.0.rc2.692.g299adb8693-goog
Message-ID: <20250613155239.2029059-2-rananta@google.com>
Subject: [PATCH v3 1/4] KVM: arm64: Disambiguate support for vSGIs v. vLPIs
From: Raghavendra Rao Ananta <rananta@google.com>
To: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>
Cc: Raghavendra Rao Anata <rananta@google.com>, Mingwei Zhang <mizhang@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

From: Oliver Upton <oliver.upton@linux.dev>

vgic_supports_direct_msis() is a bit of a misnomer, as it returns true
if either vSGIs or vLPIs are supported. Pick it apart into a few
predicates and replace some open-coded checks for vSGIs.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/vgic/vgic-init.c    |  4 ++--
 arch/arm64/kvm/vgic/vgic-mmio-v3.c | 16 ++++++++++------
 arch/arm64/kvm/vgic/vgic-v4.c      |  4 ++--
 arch/arm64/kvm/vgic/vgic.c         |  4 ++--
 arch/arm64/kvm/vgic/vgic.h         |  7 +++++++
 5 files changed, 23 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index eb1205654ac8..5e0e4559004b 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -395,7 +395,7 @@ int vgic_init(struct kvm *kvm)
 	 * v4 support so that we get HW-accelerated vSGIs. Otherwise, only
 	 * enable it if we present a virtual ITS to the guest.
 	 */
-	if (vgic_supports_direct_msis(kvm)) {
+	if (vgic_supports_direct_irqs(kvm)) {
 		ret = vgic_v4_init(kvm);
 		if (ret)
 			goto out;
@@ -443,7 +443,7 @@ static void kvm_vgic_dist_destroy(struct kvm *kvm)
 		dist->vgic_cpu_base = VGIC_ADDR_UNDEF;
 	}
 
-	if (vgic_supports_direct_msis(kvm))
+	if (vgic_supports_direct_irqs(kvm))
 		vgic_v4_teardown(kvm);
 
 	xa_destroy(&dist->lpi_xa);
diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
index ae4c0593d114..1a9c5b4418b2 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
@@ -50,8 +50,12 @@ bool vgic_has_its(struct kvm *kvm)
 
 bool vgic_supports_direct_msis(struct kvm *kvm)
 {
-	return (kvm_vgic_global_state.has_gicv4_1 ||
-		(kvm_vgic_global_state.has_gicv4 && vgic_has_its(kvm)));
+	return kvm_vgic_global_state.has_gicv4 && vgic_has_its(kvm);
+}
+
+bool vgic_supports_direct_sgis(struct kvm *kvm)
+{
+	return kvm_vgic_global_state.has_gicv4_1 && gic_cpuif_has_vsgi();
 }
 
 /*
@@ -86,7 +90,7 @@ static unsigned long vgic_mmio_read_v3_misc(struct kvm_vcpu *vcpu,
 		}
 		break;
 	case GICD_TYPER2:
-		if (kvm_vgic_global_state.has_gicv4_1 && gic_cpuif_has_vsgi())
+		if (vgic_supports_direct_sgis(vcpu->kvm))
 			value = GICD_TYPER2_nASSGIcap;
 		break;
 	case GICD_IIDR:
@@ -119,7 +123,7 @@ static void vgic_mmio_write_v3_misc(struct kvm_vcpu *vcpu,
 		dist->enabled = val & GICD_CTLR_ENABLE_SS_G1;
 
 		/* Not a GICv4.1? No HW SGIs */
-		if (!kvm_vgic_global_state.has_gicv4_1 || !gic_cpuif_has_vsgi())
+		if (!vgic_supports_direct_sgis(vcpu->kvm))
 			val &= ~GICD_CTLR_nASSGIreq;
 
 		/* Dist stays enabled? nASSGIreq is RO */
@@ -133,7 +137,7 @@ static void vgic_mmio_write_v3_misc(struct kvm_vcpu *vcpu,
 		if (is_hwsgi != dist->nassgireq)
 			vgic_v4_configure_vsgis(vcpu->kvm);
 
-		if (kvm_vgic_global_state.has_gicv4_1 &&
+		if (vgic_supports_direct_sgis(vcpu->kvm) &&
 		    was_enabled != dist->enabled)
 			kvm_make_all_cpus_request(vcpu->kvm, KVM_REQ_RELOAD_GICv4);
 		else if (!was_enabled && dist->enabled)
@@ -178,7 +182,7 @@ static int vgic_mmio_uaccess_write_v3_misc(struct kvm_vcpu *vcpu,
 		}
 	case GICD_CTLR:
 		/* Not a GICv4.1? No HW SGIs */
-		if (!kvm_vgic_global_state.has_gicv4_1)
+		if (vgic_supports_direct_sgis(vcpu->kvm))
 			val &= ~GICD_CTLR_nASSGIreq;
 
 		dist->enabled = val & GICD_CTLR_ENABLE_SS_G1;
diff --git a/arch/arm64/kvm/vgic/vgic-v4.c b/arch/arm64/kvm/vgic/vgic-v4.c
index 193946108192..e7e284d47a77 100644
--- a/arch/arm64/kvm/vgic/vgic-v4.c
+++ b/arch/arm64/kvm/vgic/vgic-v4.c
@@ -356,7 +356,7 @@ int vgic_v4_put(struct kvm_vcpu *vcpu)
 {
 	struct its_vpe *vpe = &vcpu->arch.vgic_cpu.vgic_v3.its_vpe;
 
-	if (!vgic_supports_direct_msis(vcpu->kvm) || !vpe->resident)
+	if (!vgic_supports_direct_irqs(vcpu->kvm) || !vpe->resident)
 		return 0;
 
 	return its_make_vpe_non_resident(vpe, vgic_v4_want_doorbell(vcpu));
@@ -367,7 +367,7 @@ int vgic_v4_load(struct kvm_vcpu *vcpu)
 	struct its_vpe *vpe = &vcpu->arch.vgic_cpu.vgic_v3.its_vpe;
 	int err;
 
-	if (!vgic_supports_direct_msis(vcpu->kvm) || vpe->resident)
+	if (!vgic_supports_direct_irqs(vcpu->kvm) || vpe->resident)
 		return 0;
 
 	if (vcpu_get_flag(vcpu, IN_WFI))
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index 8f8096d48925..f5148b38120a 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -951,7 +951,7 @@ void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu)
 	 * can be directly injected (GICv4).
 	 */
 	if (list_empty(&vcpu->arch.vgic_cpu.ap_list_head) &&
-	    !vgic_supports_direct_msis(vcpu->kvm))
+	    !vgic_supports_direct_irqs(vcpu->kvm))
 		return;
 
 	DEBUG_SPINLOCK_BUG_ON(!irqs_disabled());
@@ -965,7 +965,7 @@ void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu)
 	if (can_access_vgic_from_kernel())
 		vgic_restore_state(vcpu);
 
-	if (vgic_supports_direct_msis(vcpu->kvm))
+	if (vgic_supports_direct_irqs(vcpu->kvm))
 		vgic_v4_commit(vcpu);
 }
 
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index 4349084cb9a6..ebf9ed6adeac 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -370,6 +370,13 @@ int vgic_its_inv_lpi(struct kvm *kvm, struct vgic_irq *irq);
 int vgic_its_invall(struct kvm_vcpu *vcpu);
 
 bool vgic_supports_direct_msis(struct kvm *kvm);
+bool vgic_supports_direct_sgis(struct kvm *kvm);
+
+static inline bool vgic_supports_direct_irqs(struct kvm *kvm)
+{
+	return vgic_supports_direct_msis(kvm) || vgic_supports_direct_sgis(kvm);
+}
+
 int vgic_v4_init(struct kvm *kvm);
 void vgic_v4_teardown(struct kvm *kvm);
 void vgic_v4_configure_vsgis(struct kvm *kvm);
-- 
2.50.0.rc2.692.g299adb8693-goog

