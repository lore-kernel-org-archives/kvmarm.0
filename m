Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C75B23CC7DF
	for <kvmarm@lists.linux.dev>; Wed, 19 Aug 2026 22:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787179385; cv=none; b=oMFL9XCRxtHL/Nk3UGYNZJO9hJuIQxoaUug1XeOV0jagZZJ+hA9P8CRxZGShRX3DXgrhDcuDEJefbYwXttvlMGdbFAW6Rwfg7szfAurCO6bURWgmVrz7XFuvTXsW+gCU8fzNuRb8508jiACAQTMYmYDmR4255ZR1MtD1Cam1yPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787179385; c=relaxed/simple;
	bh=QtGuQD6Y9WhA9fpXpeTIYaXrx/WTjnsW3HXx6vlkPTo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rs3RnThGi72RsmCtDKZDv3+NpM2pOzV/oD24wc4nybsWOIRa54vntQkph2krpKYTs8SLMAcGG34/33cjuJqmvTJ8c/JM8SDxRx0+EzFW47x8RAY8h37sZiEswxgaIn1l7Ak9BbxFSa8prah5DP8Ezd9/mm7EiO+jbn58yAbw5Cc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pGYJ3xfN; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pGYJ3xfN"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-47fe377a217so920350f8f.1
        for <kvmarm@lists.linux.dev>; Wed, 19 Aug 2026 15:43:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787179381; x=1787784181; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=spw3TDdOtLdIsF7CwDxVZdY48WpWL2JF0u4UNC1DfkY=;
        b=pGYJ3xfNvsnMASrLwE7Himabl7xaNynd97PsNKLO5PFqIHV2Rdsivf3N2q5WbvmUFc
         L0yNp6rQbJZeQ5siyWYDugNVMMt7H4vHq89fukZCK9og2PytABnVOYMWcihfzPgMrrvx
         ru1KGtOT3iLM+fs96YmD8rFPE99Xb4M9GPNNoISa863lE934hw/a0xX9ruGk0PjxFh3L
         whAYw5bYq4XU49+9M+TdR2gP2HydMtNvyfbHRZGx+j6VEetIFuOXuVsK9u2kiFLk/Qo/
         9FcCe1GWdDnhZV9RXE0FLvKQxkykdk/nbEW5EesT9oGgdFdznMokB0DKaXbxds/vF9j9
         /gXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787179381; x=1787784181;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=spw3TDdOtLdIsF7CwDxVZdY48WpWL2JF0u4UNC1DfkY=;
        b=Otkt1kEqMQBErZqmU0OV+ODl9TlKzuJvlnyH3fvWmNgIndSBdpUNZu0GMsJpgknZAC
         pQGU8JeK1nt1GxM0uBdewaELuC2+515Mk4WSVi32x6ogjn8hiKq0/ws69QP3/YH5/g2M
         uQkMixdnKw4J0WmX51AN1Spz1Un89qs0hMcsH3+WRyfq/a+e8TUaXmwHhhxGSivDxFPw
         aTXC1J9m1wWCccCEFt9ItpwT5dgmU8aTk0Gu216zaa7mQup64Ia/bFxmlbK/EHPCDqOx
         ZOU2vWmcS5erCsIuIPGk+cm6SRsw3czT61hQ9tbThCIkpCOEB6ZcXG/4SgOiduBePLp2
         vdAQ==
X-Forwarded-Encrypted: i=1; AHgh+RrIIh1zIGiSfX3scXaqbq/x8ObEfax7hqgXbc1tlaI79CWGjnrX1DQovH4iM2z+NKX1isAaH30=@lists.linux.dev
X-Gm-Message-State: AFuF++nenvzlTa9C2KXhsudZx/eFmVKEgWZbiphXrBp/yIHazgpu3K/z
	Hh687nzF6+2EOfX/EQaKpSr3tQH1aKFmNOV2UpWOXtWQL37qaAyRGzkb
X-Gm-Gg: AR+sD11DUzlIwdfPolKKZxjlgkpQnyV27M+aogkApfJ8AFtesU5gMubeKpBdOo4oqwU
	f9GlylWi50/WMMrquLKdFw50z+fzqbpK9BXB9fOdV3n41kbXR1Slyhn5i+thE9aaOpIbW5cbwIs
	HSy8FoVWfh5adMWH09vVkRg5LJPsk9jrTNGEo6+r9pzbUw62ZesCiOgaSpayAbT1FHslkq/x2IJ
	W1+FMp47/NXAPGSZzPSRdg1m1yDUnCeBavDa4jh5BE5+/RCGFgXY7ybT8yR715Qv4p5T7aNufLu
	sszUBoZLRkDvcUX1ujcdJ+jOz7/iJqLD0gUOQBdjP/jvmj3UXth2Q4344d7sqHlrdoM/2DP6U3A
	OD4EqXAdkVVcoqw64KQrcWV3LJT/ih5v4KHh/7CV8T3n7xc7+emxN95swl6ZaW4HyqOPzHFzKdg
	6aBFeva2Qos95ZuLHA/Uut90CF6LzJvjxdwyGwzrskHsh0yhHf3pjb2YVQpO9Dunfz65at+Jqsb
	JynPcvxOATwtGNryRDB/+k1sCNJxByuRmoq4RbSIstw0MxWrF2Fk7ZekY5HLvgh6vBzoSY5s+9M
	iqg0x+SXaBJ+eGP2f8rq4lULZHS4Mpe8dhlBQEiuyLOp98kl4vyXlrg7ULDoo5xMvIQ=
X-Received: by 2002:a05:6000:27cc:20b0:482:bb55:8bdc with SMTP id ffacd0b85a97d-482bb558d7fmr23879f8f.1.1787179380523;
        Wed, 19 Aug 2026 15:43:00 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a02-3100-ae9e-1d01-58d3-443d-4fa6-01cd.310.pool.telefonica.de. [2a02:3100:ae9e:1d01:58d3:443d:4fa6:1cd])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-482b1450e61sm8553317f8f.13.2026.08.19.15.42.59
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 19 Aug 2026 15:43:00 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	Fuad Tabba <tabba@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	Eric Auger <eric.auger@redhat.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v2 1/5] KVM: arm64: vgic-v3: Undo assignment on iodev registration failure
Date: Thu, 20 Aug 2026 00:42:25 +0200
Message-Id: <20260819224229.82948-2-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20260819224229.82948-1-kmehltretter@gmail.com>
References: <20260819224229.82948-1-kmehltretter@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

vgic_register_redist_iodev() assigns a redistributor region and base
address to the vCPU before adding its iodev to the MMIO bus. However, the
region's free_index is advanced only after registration succeeds.

If kvm_io_bus_register_dev() fails, the vCPU retains the assignment while
free_index still identifies the same slot as free. A later registration can
therefore reuse a slot that remains assigned to the vCPU.

Advance free_index when assigning the slot. On registration failure, return
the slot and clear rdreg and base_addr.

Fixes: dbd9733ab674 ("KVM: arm/arm64: Replace the single rdist region by a list")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
---
 arch/arm64/kvm/vgic/vgic-mmio-v3.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
index 5913a20d8301..c75caadbd1d3 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
@@ -766,6 +766,18 @@ unsigned int vgic_v3_init_dist_iodev(struct vgic_io_device *dev)
 	return SZ_64K;
 }
 
+static void vgic_unassign_redist_iodev(struct kvm_vcpu *vcpu)
+{
+	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
+
+	guard(mutex)(&vcpu->kvm->arch.config_lock);
+	if (vgic_cpu->rdreg) {
+		vgic_cpu->rdreg->free_index--;
+		vgic_cpu->rdreg = NULL;
+	}
+	vgic_cpu->rd_iodev.base_addr = VGIC_ADDR_UNDEF;
+}
+
 /**
  * vgic_register_redist_iodev - register a single redist iodev
  * @vcpu:    The VCPU to which the redistributor belongs
@@ -818,16 +830,17 @@ int vgic_register_redist_iodev(struct kvm_vcpu *vcpu)
 	rd_dev->nr_regions = ARRAY_SIZE(vgic_v3_rd_registers);
 	rd_dev->redist_vcpu = vcpu;
 
+	/* Protected by slots_lock */
+	rdreg->free_index++;
+
 	mutex_unlock(&kvm->arch.config_lock);
 
 	ret = kvm_io_bus_register_dev(kvm, KVM_MMIO_BUS, rd_base,
 				      2 * SZ_64K, &rd_dev->dev);
 	if (ret)
-		return ret;
+		vgic_unassign_redist_iodev(vcpu);
 
-	/* Protected by slots_lock */
-	rdreg->free_index++;
-	return 0;
+	return ret;
 
 out_unlock:
 	mutex_unlock(&kvm->arch.config_lock);
-- 
2.39.5 (Apple Git-154)
