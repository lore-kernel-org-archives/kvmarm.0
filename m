Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.73
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793182416;
	b=EqphwvweTkYyNWjuyqVlV8niWHn/YUikRNt1z0s9Abtduy/YuQg2qAoLZKLBd8GWkoD2
	 kK0glpCB+qfPQmMzoUXeF4Q3k83ePqykEday0dx5c06pB6oO/pd3IZWP3QawCm7eVy3aw
	 jEPOAWlkPsNjW0+AqfG/7WKkoCsEoFl+7IjmrWUm9Jc4v4iyrzwpr+ofiKraMct+SDAVA
	 HKW4azjolxOQd9RpnM4yJNlSwmmVV9dQ3iYzzszeobc0X4zMK+hkp6PKAHkOu5n52w5bf
	 ymbG/co2T8izvknkl3yzzi65mDk2Tlc8hB9Z+bKOq8FHBcgPzQVmgoWy9rl6r62aPAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793182416;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=5NABG2AiXntzQQhgrbFs5uOv8MiJIKrNTvyQWAjpfGM=;
	b=r5pbaSmFuOZPLUYeDhihqIchXm/aCKGsn9PadnCP2+ZkcS7fk+Fj4tzpKM0x47YatO3a
	 sqQ9R3jJZLNTdxT5t2i+4G/yldvSzwhcZqtKYzIYpdcmMXaU9mZuxy7B+jvRnwCZrhJG4
	 jOHpebulebiFZPrGPbqiqhU9pwTu6rbtKqdrrXWI1ETNCrb4ncFWrNdOeoMqdJ6Yiwe68
	 96Ufmp9IDOLXBQF+oql1RMMo/5tP9QUlVRRpVm2BsmSmPXWNEDQUtJ/oSOVk51kNOKIkA
	 UUTmoQvoMg4RMhNeDpBmwgxcmq2RfD7QjrabJFeZd8zwRwuEfzkqVhJISgoDHXniKMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=j64q8qUb;
	arc=none smtp.remote-ip=91.218.175.73
Received: from mta0.migadu.com (out-73.mta0.migadu.com [91.218.175.73])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48609606A31C
	for <kvmarm@lists.linux.dev>; Wed, 28 Oct 2026 10:13:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 48609606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=j64q8qUb
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=kg3kdJ38Ft3AD46ZxOYLXC0C0yujn9suVYw9Z8g/U9Y=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793182414; v=1; x=1793787214;
 b=j64q8qUbnIImZVnnR94EjYfCqijHtVApq4tBd9c7UecgpowHQdKQ0YVAzh/473sxqNm+N3Eb
 RgxM1RTMOfqkd17Ph5ETyzwZ4fygmIS+uFy56vYlIutGl2koa4ScNG4rNMHmaUpq29QVVBRNvmq
 j1kUINqeL81wTs9XPrBqc1Zs=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 8e770c70f83dabeb;
	Wed, 28 Oct 2026 10:13:34 +0000
X-Mizu-Trace-ID: 8e770c70f83dabeb
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Eric Auger <eric.auger@redhat.com>,
	Sascha Bischoff <Sascha.Bischoff@arm.com>,
	Will Deacon <will@kernel.org>,
	Fuad Tabba <tabba@google.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] KVM: arm64: vgic-v4: Don't allocate vPEs when userspace clears nASSGIcap
Date: Wed, 28 Oct 2026 10:13:18 +0000
Message-ID: <20261028101318.2170928-3-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261028101318.2170928-1-fuad.tabba@linux.dev>
References: <20261028101318.2170928-1-fuad.tabba@linux.dev>
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

Since commit c652887a92887 ("KVM: arm64: vgic-v3: Allow userspace to
write GICD_TYPER2.nASSGIcap"), userspace can disable vPE allocation for
a VM on a GICv4.1 host with vSGIs by clearing nASSGIcap before the vgic
is initialised. vgic_init() then skips vgic_v4_init(), and
kvm_vgic_dist_destroy() skips vgic_v4_teardown(). vgic_its_create()
still calls vgic_v4_init() for an ITS created after the vgic is
initialised, though, and vgic_v4_init() allocates the vPEs and requests
a doorbell IRQ for each vCPU. Destroying the VM leaks them, and leaves
each doorbell handler registered with a vCPU that's about to be freed.

Move the part of vgic_supports_direct_msis() that doesn't depend on the
ITS into vgic_supports_vpes(), together with vgic_v4_init()'s GICv3
check. Gate vgic_v4_init() on it rather than on
vgic_supports_direct_irqs(), which reads has_its before
vgic_its_create() sets it. vgic_supports_direct_msis() returns what it
did before, since vgic_has_its() is already false for a non-GICv3 VM.

Fixes: c652887a92887 ("KVM: arm64: vgic-v3: Allow userspace to write GICD_TYPER2.nASSGIcap")
Suggested-by: Oliver Upton <oupton@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/vgic/vgic-mmio-v3.c | 9 +++++++--
 arch/arm64/kvm/vgic/vgic-v4.c      | 2 +-
 arch/arm64/kvm/vgic/vgic.h         | 1 +
 3 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
index 5913a20d83019..a60697238a7a7 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
@@ -48,7 +48,7 @@ bool vgic_has_its(struct kvm *kvm)
 	return dist->has_its;
 }
 
-bool vgic_supports_direct_msis(struct kvm *kvm)
+bool vgic_supports_vpes(struct kvm *kvm)
 {
 	/*
 	 * Deliberately conflate vLPI and vSGI support on GICv4.1 hardware,
@@ -58,7 +58,12 @@ bool vgic_supports_direct_msis(struct kvm *kvm)
 	if (system_supports_direct_sgis() && !vgic_supports_direct_sgis(kvm))
 		return false;
 
-	return kvm_vgic_global_state.has_gicv4 && vgic_has_its(kvm);
+	return kvm_vgic_global_state.has_gicv4 && vgic_is_v3(kvm);
+}
+
+bool vgic_supports_direct_msis(struct kvm *kvm)
+{
+	return vgic_supports_vpes(kvm) && vgic_has_its(kvm);
 }
 
 bool system_supports_direct_sgis(void)
diff --git a/arch/arm64/kvm/vgic/vgic-v4.c b/arch/arm64/kvm/vgic/vgic-v4.c
index a01de4de608a6..0a4b9a74425b4 100644
--- a/arch/arm64/kvm/vgic/vgic-v4.c
+++ b/arch/arm64/kvm/vgic/vgic-v4.c
@@ -248,7 +248,7 @@ int vgic_v4_init(struct kvm *kvm)
 
 	lockdep_assert_held(&kvm->arch.config_lock);
 
-	if (!kvm_vgic_global_state.has_gicv4 || dist->vgic_model != KVM_DEV_TYPE_ARM_VGIC_V3)
+	if (!vgic_supports_vpes(kvm))
 		return 0; /* Nothing to see here... move along. */
 
 	if (dist->its_vm.vpes)
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index b71d486ae5145..7fc29a395a7db 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -500,6 +500,7 @@ static inline bool vgic_host_has_gicv5(void)
 }
 
 bool system_supports_direct_sgis(void);
+bool vgic_supports_vpes(struct kvm *kvm);
 bool vgic_supports_direct_msis(struct kvm *kvm);
 bool vgic_supports_direct_sgis(struct kvm *kvm);
 
-- 
2.47.3

