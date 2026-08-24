Received: from mta1.migadu.com (out-52.mta1.migadu.com [95.215.58.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DB5039B952
	for <kvmarm@lists.linux.dev>; Mon, 24 Aug 2026 07:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787557397; cv=none; b=sN2tIFVGwoE9tzml+SwBNVBm9cr9C0XeB0sZar7JvHTRgjucke2mZ/lnTQMiSVD8bU/RSWjKgDLRol7+uTP9+3V46JCMzNfo5OC5a3AghD97dLT7zULVZ+4/R4mdqR4D2a0AiSIM2yZ0xDVuE+guFSHcjIhf89Pq/fwKxvzdqY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787557397; c=relaxed/simple;
	bh=0njPdbaKLdmcvhV4JMlTlxwDuJcfUS+uR9TLYY7nzIc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sYWY+smymMgqlkEDC39VqaQSPVI60vKk45As2tptfkIPcoFXqFOSCKYwVnU+VWTOP3RINnSGGcvmypmp37mDr/ABWTUzSnAQ83YaW5GgG0FEgReCr42TGQdVSH4YXBVY+rFSjsHHjeKhfehlVTbfHXsTeqC4amPB/8X+9CMwBVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=JJAdsQy+; arc=none smtp.client-ip=95.215.58.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="JJAdsQy+"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=0njPdbaKLdmcvhV4JMlTlxwDuJcfUS+uR9TLYY7nzIc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787557388; v=1; x=1788162188;
 b=JJAdsQy+YavOzIDLH65HB/iZm0vza4sNVTZIQ8N1RP0GjcSD7shL3/kJfU/e7rwJ4jYURSsI
 3OBPJmbLhzIcBUKzzwV2eBORQ5CUPuM4yWqPbpklc2/KteiczFnsvIGoIusHaDZYLrHwnT/BVkQ
 0ScXddug5zKf31ayZjvgWx1g=
X-Envelope-To: kvmarm@lists.linux.dev
Received: from claudy.local (2a01:4b00:ad36:1d00:3a05:25ff:fe33:35a9)
	by smtp.migadu.com with ESMTPS id 599f795f6d738f63;
	Mon, 24 Aug 2026 07:43:08 +0000
X-Mizu-Trace-ID: 599f795f6d738f63
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: Thomas Gleixner <tglx@kernel.org>,
	Eric Auger <eauger@redhat.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Sascha Bischoff <Sascha.Bischoff@arm.com>,
	Sebastian Ene <sebastianene@google.com>,
	Fuad Tabba <tabba@google.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/4] KVM: arm64: vgic-v4: Restore nr_vpes before freeing the vPE resources
Date: Mon, 24 Aug 2026 08:42:45 +0100
Message-Id: <20260824074245.710955-5-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260824074245.710955-1-fuad.tabba@linux.dev>
References: <20260824074245.710955-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

vgic_v4_init() truncates its_vm.nr_vpes to the failing index to bound
vgic_v4_teardown()'s free_irq() loop, but its_free_vcpu_irqs() reads
the same field: the vPE irqs and the v4.1 SGI domains at or above that
index are never freed, each one leaking a vpe_id and an LPI pending
table.

Restore the count from online_vcpus before that call. This depends on
the previous patch: a failed vgic_init() keeps admitting vCPUs, so
without that patch's teardown the vPE array outlives the failure while
online_vcpus grows past the size it was allocated with.

Fixes: bdb2d2ccac65 ("KVM: arm/arm64: GICv4: Add doorbell interrupt handling")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/all/20260820130616.1A7241F000E9@smtp.kernel.org/
Suggested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/vgic/vgic-v4.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-v4.c b/arch/arm64/kvm/vgic/vgic-v4.c
index ed236f083f0d7..30e1de3fc7d9d 100644
--- a/arch/arm64/kvm/vgic/vgic-v4.c
+++ b/arch/arm64/kvm/vgic/vgic-v4.c
@@ -333,6 +333,9 @@ void vgic_v4_teardown(struct kvm *kvm)
 		free_irq(irq, vcpu);
 	}
 
+	/* Make sure we free all VM-wide, per-CPU resources */
+	its_vm->nr_vpes = atomic_read(&kvm->online_vcpus);
+
 	its_free_vcpu_irqs(its_vm);
 	kfree(its_vm->vpes);
 	its_vm->nr_vpes = 0;
-- 
2.39.5

