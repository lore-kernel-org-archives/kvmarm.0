Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.115
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793028415;
	b=xNyiePUCtAK22kVp9DBzaT20KjEJM1dhADIZSuM3EJZnoXufhx2zi71+pb9bql1zsCXj
	 l+oD9Q5oCLXPwjxNLnsiJ/7AAHFn6Fbk15TrngiNF4MNmwB1Wf3MLaMaPTal+SYh3MVYk
	 KRd2cy79H/ZPS+CCt/rLybHpl3aJ+LMwtLSugPn240tJeIorQOuLBTyGR6r9WwsHDjgdo
	 uh0XtYNZIr2EUZ1LIr1nGYwCyBkt1wkdDuLfJeZZN+FlFG/LXKH7O6AI9w69+Cwk8tWiy
	 gGtvsUkJoFvWKGQtVa1IxXMtKxnj6YejijfL8zbybzLLIATCZVRggyKih8N2M1hxTVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793028415;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=R+uyHs9ywIaM0i/9cYv3M9HNaFEltPzXJeKYyT3HeLQ=;
	b=IdQqoFLj2UlUuT3BdSfvPmONkx817V2O8fXNbIPs9L8SUcLYZ+EhYU6x2QmTHR6+NZW4
	 6TD6DamMns3bvoabeF9gXY3C9TtYYWtxFCGhgGM4PUnVkjcfQvy+IVUVvnbuTQ6fbfkM4
	 5lIsyNBahJq5bGumpeyh8ZGPJuBWf2Ffg8Bsx9dVCdgOlGtv7uWBu/Wx7kPSTjZji3Iy1
	 C4W5ojbr7/7SwJ3HJq0iTzpxMm0aJoxmdjTFBFUnyTQIeSNDwynCO2jaTsr2BJf3Rizil
	 jmoyvpRa4++rS6ZKpDKnIY/U8YlHEUejrMJI0jeBkhI9i/m8TJQCofmQAbp5jPJ4XJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=GGcSxjh1;
	arc=none smtp.remote-ip=95.215.58.115
Received: from mta1.migadu.com (out-115.mta1.migadu.com [95.215.58.115])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19048606A32C
	for <kvmarm@lists.linux.dev>; Mon, 26 Oct 2026 15:26:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 19048606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=GGcSxjh1
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=HeX2/geBxz2dlu9U8tei1sYnbTS6/PpznfxzSmtORYY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793028413; v=1; x=1793633213;
 b=GGcSxjh1UC0cDCLlNJtR4af/Jfdu7XvwZolqns7vXAfIesqqt7TVSd7HO4oPf/+limgiRxdw
 DV0LNNzoxOi0BKQIM5w8+YSY284Gd3P5rFgj1nJFGGaXexmKRrjsNgRg/j8w9T9DVJeSk8kT8XY
 BkuAX/k18vmb9DWM3QRsX2pY=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 069beff3eddbe141;
	Mon, 26 Oct 2026 15:26:53 +0000
X-Mizu-Trace-ID: 069beff3eddbe141
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
	Will Deacon <will@kernel.org>,
	Fuad Tabba <tabba@google.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] KVM: arm64: vgic-v4: Don't allocate vPEs when userspace clears nASSGIcap
Date: Mon, 26 Oct 2026 15:26:39 +0000
Message-ID: <20261026152639.3926498-3-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261026152639.3926498-1-fuad.tabba@linux.dev>
References: <20261026152639.3926498-1-fuad.tabba@linux.dev>
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

Rather than gate on vgic_supports_direct_irqs(), which reads has_its
before vgic_its_create() sets it, check for a cleared nASSGIcap in
vgic_v4_init().

Fixes: c652887a92887 ("KVM: arm64: vgic-v3: Allow userspace to write GICD_TYPER2.nASSGIcap")
Cc: stable@vger.kernel.org
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/vgic/vgic-v4.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-v4.c b/arch/arm64/kvm/vgic/vgic-v4.c
index a01de4de608a6..12a57921f6af3 100644
--- a/arch/arm64/kvm/vgic/vgic-v4.c
+++ b/arch/arm64/kvm/vgic/vgic-v4.c
@@ -251,6 +251,10 @@ int vgic_v4_init(struct kvm *kvm)
 	if (!kvm_vgic_global_state.has_gicv4 || dist->vgic_model != KVM_DEV_TYPE_ARM_VGIC_V3)
 		return 0; /* Nothing to see here... move along. */
 
+	/* Userspace disabled vPE allocation by clearing nASSGIcap */
+	if (system_supports_direct_sgis() && !vgic_supports_direct_sgis(kvm))
+		return 0;
+
 	if (dist->its_vm.vpes)
 		return 0;
 
-- 
2.47.3

