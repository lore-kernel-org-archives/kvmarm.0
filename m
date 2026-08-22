Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 019733C1D6E
	for <kvmarm@lists.linux.dev>; Sat, 22 Aug 2026 09:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787392438; cv=none; b=Yq76wGd9ncIs+vXo6CXxC557nFIxAwZqzeYVCjUtRkTgVlXVFPzA2AztT92pW7Scn2a4t6w9KIpCwZ6hUjg/+OqQ3Ww6i+xc/dL3+XErBrw+8Av/viahHv22k9yp0ycyjrC/IXoY8LuEusKuMUdFR9vz/iMagj+Lyx0HagjbNa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787392438; c=relaxed/simple;
	bh=ah6a8+r9Fx1EVjERXoUoTSdBjhjWjPdaic29SNFB80I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XkWV8btr7lym7Wz2Cgbz+cU/wuXzQATCwAADiX+Glwx2fKfL/kGbmeXUls5c3mbxINrLQBJw/+wYi2IATpQT0G94/2U0GwHTdIEjh2uybc9B2ZpUXv5b2YbNjyL29UTrbyYK1Et99rDMkaJ2PVVGOFZBiICOXJJZjE7iOPP5lY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AMayUOnO; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AMayUOnO"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-6a15d54ac95so3313661a12.0
        for <kvmarm@lists.linux.dev>; Sat, 22 Aug 2026 02:53:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787392435; x=1787997235; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GqVzAbnyjF6+2pKtzAxu1aGHo1gAHNbWqpu34didy+A=;
        b=AMayUOnOvb473ycXN3ZwbpkcVNhwBNOnuPmyzExiRWMi+widKOLSl09tWxqoRBdyYI
         3HVUOxScnYBYK6ihwzPBrOI+gEVx2sTIgr+CE6gjkEVeSdsGvpozinMktGwYzh3EKSv7
         BEknmcB3d9Yv92+YEp3xYhF1dihwO4/gc7NxJ5vwQyyf7xDpVMt+H5OMwH29ERQM1/Sy
         Dk3zHxrN3/4jALRalxF2uiYCXDEDWY0eqKKhmUOyCakhLWjQ9BE+vUqkomL9uO0oHNeJ
         B5V0xgRBbA2QeOhI99vEE9sk6zWW4kcTy3C8xHkHejv/AFBK2m9hIZuvOCAcm6fS3dWk
         O8Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787392435; x=1787997235;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=GqVzAbnyjF6+2pKtzAxu1aGHo1gAHNbWqpu34didy+A=;
        b=m59mD7Z+6urCZIsXFN6iY2e/3G2SAnLN0H5x8GSz6blEEF8ujEq2ZvhAdHyvkHJuTt
         /NITOT5bbjWimkVbLzpjTkuBtnj9F7ZFZPCHx8W7UrLXCIBybrr0c8cgB1IhfNH/5vMo
         taP421UbwCHKd9sIZk5xXAEALBuQiYE6Ri1wHoutoXtXiKPHVVuJrV2UFLfzdMFV8Txo
         A90ESENvP4CvAmLNlCovQ86f4/JfkbTGngkOj362PathnBY2q+haaiWvFdOTLpTJXT/n
         ElVTKp4SCL2TIxFEYqLYv5cGbLhvAp+90cIYM36+Mi/i5l02SL9XZE4ZhodF6iwoWgVj
         v5qA==
X-Forwarded-Encrypted: i=1; AHgh+RrncpJYF55oScsqDqd5eax4sbhKscXVhRJxW5E1AYDsinuvAQhgQ/uceiHUVxle94oFGn9/3l8=@lists.linux.dev
X-Gm-Message-State: AFuF++kStgfPuxSF6zw2jIzxp2ZBR7yVaK9htcdlOtO28i0pARcESoJ6
	bpsFZ3ZzvFR7fH/aooxsmFkCmBl8ZU6TU3O70JN4OlJB40KoE64heUdd
X-Gm-Gg: AR+sD107aKlh2gGcslo58CvrGXjk3DhE5H0U/i9La/WCjG0Nk3L0s2U04S1opVzGLwF
	9dT/FjPVyxo1VuQvXJjmHjHrcNHMVgX27B8h4pNnW7U1+cr48GqSnXozAzXx0QoVipJk1elYz2F
	6RHHhWkeOK/dR5S6+R4so4bNztHf5ryp8AJEMY6SUw5asTldGjxamvgOzX6+Syv4HczUr0AClnI
	NTR7vpwgKVDGTY9hMJe1UdEN7BkwT2Br6iadc/pawjXfgyo1qZZs7jZJJ+Mm6XWnMrdeZWH4CrX
	Ptr9qC+RyOuhlXOq++/0sZ/lX4BxJutV/G70Yt7Uzsvue/wLm+5ymIg9B6g8ZtjW59M9uw+9bFy
	oHbPl3JFjOhck6FwGlYgJmFzneF0Ll7woAMGMPdVeq3uQGV+tAV9CuASLDtkcr+2BeYkfn6u94h
	XtzEdrjqMiSxZkL+hxGl5rVBJQZrKkDwkqk16B/GlMEMK/hiCjSnLlc9nRI4kZ07I8FQOiVAC8O
	WQw0txEEIbygdaicF4quALZjkkjG8SqEAEKdz60tu3FU6ocYpvB6TC6m8aF/7+le2e5RuVj5atc
	GD3yTBexbkd7+qpsKV3wo0ppHR2J2RtawQzzrLKLnuWrLaVO2zjF+/xsMQzyNDPQ6VcJ
X-Received: by 2002:a05:6402:501f:b0:698:6084:db7f with SMTP id 4fb4d7f45d1cf-6a582b5f1a2mr5487769a12.10.1787392435123;
        Sat, 22 Aug 2026 02:53:55 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a02-3100-a0f5-8c01-3de3-cd62-aa6f-2fb0.310.pool.telefonica.de. [2a02:3100:a0f5:8c01:3de3:cd62:aa6f:2fb0])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a3ff0c327asm11151586a12.8.2026.08.22.02.53.53
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 22 Aug 2026 02:53:54 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
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
Subject: [PATCH v3 1/5] KVM: arm64: vgic-v3: Undo assignment on iodev registration failure
Date: Sat, 22 Aug 2026 11:53:42 +0200
Message-Id: <20260822095346.53882-2-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20260822095346.53882-1-kmehltretter@gmail.com>
References: <20260822095346.53882-1-kmehltretter@gmail.com>
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

Reserve the slot before registering its iodev. The caller holds slots_lock,
so a registration failure cannot race with a later assignment. Undo the
reservation and clear the cached assignment on failure.

Fixes: dbd9733ab674 ("KVM: arm/arm64: Replace the single rdist region by a list")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
---
 arch/arm64/kvm/vgic/vgic-mmio-v3.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
index 5913a20d8301..22897ce64dbf 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
@@ -766,6 +766,19 @@ unsigned int vgic_v3_init_dist_iodev(struct vgic_io_device *dev)
 	return SZ_64K;
 }
 
+static void vgic_undo_redist_assignment(struct kvm_vcpu *vcpu)
+{
+	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
+
+	lockdep_assert_held(&vcpu->kvm->slots_lock);
+
+	guard(mutex)(&vcpu->kvm->arch.config_lock);
+
+	vgic_cpu->rdreg->free_index--;
+	vgic_cpu->rdreg = NULL;
+	vgic_cpu->rd_iodev.base_addr = VGIC_ADDR_UNDEF;
+}
+
 /**
  * vgic_register_redist_iodev - register a single redist iodev
  * @vcpu:    The VCPU to which the redistributor belongs
@@ -818,16 +831,17 @@ int vgic_register_redist_iodev(struct kvm_vcpu *vcpu)
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
+		vgic_undo_redist_assignment(vcpu);
 
-	/* Protected by slots_lock */
-	rdreg->free_index++;
-	return 0;
+	return ret;
 
 out_unlock:
 	mutex_unlock(&kvm->arch.config_lock);
-- 
2.39.5 (Apple Git-154)

