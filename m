Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.68
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793182412;
	b=QDYVHXnqrFtMur3n79/eUu5LsbLLzcFmKbhjTGA6gvEODs2u/1K9qP3ROBJO+ctLNqR9
	 IEK0WjRhPCuULw7oQUznMa5jAVenf2d2XIpBDeaItgLmk60lhVLuXXqkpdJZZeHbqv9w2
	 +VRia/fwtUh9rP40DyNzbeEFxhY0mfE4RTODnw3/4QBhm0McCshV8h2YppaMer9WZ01td
	 yMpqqrkH01StLtgaAvpBK957wuQbugaD3bQaw7P/8VEy6ShUPRlmJUktx1LvNJlN3FLeZ
	 s6vTOmjNi72cRONw2g1ASWjVhFoMe8TNfE+ilUHWf/1u94sYdwiNhtV4pvrbu4/d6lQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793182412;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=dAFgr5GFVCUFPSyhlg3DUaZpfnARnQey3lMyxNdSf/I=;
	b=kYK08Wb7N4oapd5vL/Pxk5SoEbLAWn1ChDAeSUNWW2vWZk5/7Uw4VlvQXWfFaau9kEew
	 ra1pK++xNRWb8p2ecI7Cv+1JNGyD6ZnBSkajWsblilYTIrv3hO71iq159TQjvcXEf3qJF
	 uY9AX9+ouvwvBKvOf62Md/3iX41kmu0k1LopK9QJRRZEWbSfo4S9/CoXmFJCT0mtxrlu0
	 dT2+Q47raySX/Ip6EzB9rX9LuU9UNRyGAl6Wdm1ZJ+taqmMyh2yWid54bktxbFmw/eyNa
	 P4+Nwfqr8hus+N9rEWOOiuZhkGX4b6kR//uvRXa6lXfflfLnRoafsRI7ZhcHd+G1eWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=u+86nyc+;
	arc=none smtp.remote-ip=91.218.175.68
Received: from mta0.migadu.com (out-68.mta0.migadu.com [91.218.175.68])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE92B606A31D
	for <kvmarm@lists.linux.dev>; Wed, 28 Oct 2026 10:13:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DE92B606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=u+86nyc+
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=Gpfg/CtXJGh5QbnPt7iVXc/Il3CyiL4OHB1+vx17vOU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793182409; v=1; x=1793787209;
 b=u+86nyc+SENRUNyWl4DA32hNmfJJeMw+lr5AfguarO6spG4tvJqcb135F3u+oMLvjTiow/Ri
 zaypz3jI7ndq8t5fDO1wUiWOwjnhly8M7myl26fUQRse8w3+mmd1Q17ezHhQ4y0WjOWv3La5CTP
 u8YTM4QrCH0tm4luaRpSnHY8=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 961729e0969fefcf;
	Wed, 28 Oct 2026 10:13:29 +0000
X-Mizu-Trace-ID: 961729e0969fefcf
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
Subject: [PATCH v2 1/2] KVM: arm64: vgic-v4: Don't allocate vPEs for a GICv2 VM
Date: Wed, 28 Oct 2026 10:13:17 +0000
Message-ID: <20261028101318.2170928-2-fuad.tabba@linux.dev>
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

KVM can run a GICv2 VM on a GICv4.0 host whose CPU interface supports
legacy operation. Such a VM has no LPIs and never uses vPEs, so
vgic_supports_direct_irqs() is false for it and kvm_vgic_dist_destroy()
never tears them down. However, userspace can still create an ITS for
it. Once the vgic is initialised, vgic_its_create() calls
vgic_v4_init(), which allocates the vPEs and requests a doorbell IRQ for
each vCPU. They're then never freed, and each doorbell handler stays
registered with a vCPU that's freed with the VM.

Only allocate vPEs for a GICv3 VM.

Fixes: 74fe55dc9ab77 ("KVM: arm/arm64: GICv4: Add init/teardown of the per-VM vPE irq domain")
Cc: stable@vger.kernel.org
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/vgic/vgic-v4.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v4.c b/arch/arm64/kvm/vgic/vgic-v4.c
index ed236f083f0d7..a01de4de608a6 100644
--- a/arch/arm64/kvm/vgic/vgic-v4.c
+++ b/arch/arm64/kvm/vgic/vgic-v4.c
@@ -248,7 +248,7 @@ int vgic_v4_init(struct kvm *kvm)
 
 	lockdep_assert_held(&kvm->arch.config_lock);
 
-	if (!kvm_vgic_global_state.has_gicv4)
+	if (!kvm_vgic_global_state.has_gicv4 || dist->vgic_model != KVM_DEV_TYPE_ARM_VGIC_V3)
 		return 0; /* Nothing to see here... move along. */
 
 	if (dist->its_vm.vpes)
-- 
2.47.3

