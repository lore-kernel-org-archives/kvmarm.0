Received: from mta1.migadu.com (out-206.mta1.migadu.com [95.215.58.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C47337B402
	for <kvmarm@lists.linux.dev>; Sat, 29 Aug 2026 07:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787987490; cv=none; b=BsbNzr6TrrdhcA2gR8ARjdsJd84rCBkXsSa8YrDqTXdSMQarhVNBL3eLTKdMJx/6zJ2z+6r/hULNp55lTvNCTvzdG5lu8UeHb0xfRUqeao2c/Eq1J0CQdthtfE9cB7sG+VNJ0diSMz+quu/nPUmstntfHhKQ6sFXBw/8A0cFHrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787987490; c=relaxed/simple;
	bh=oSLoS8auaNbOgwA1cZGo0TZ/MHGsOYbNVd/3zqTdn/s=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=r3RdAcNhaksEtteUPdOwAMSIaYv6tSICZ7GThhFpwS/g6h9y+p6FAlVhvL031LbdzvJ40cuU/pWrritAQEJI74x1GQOr540J6nOoCFeRE6bfAw03Z1fbZD5cvWhsU4D6sAflEJ/fFUyfAb357cxQVd36Cnr+1sxmJXVL5LzLBt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=JO1HgOfJ; arc=none smtp.client-ip=95.215.58.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="JO1HgOfJ"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=oSLoS8auaNbOgwA1cZGo0TZ/MHGsOYbNVd/3zqTdn/s=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787987485; v=1; x=1788592285;
 b=JO1HgOfJ4THQQHKUkvRdapwzp40sW4mPXcrH9PLwX1siE8U/aX7TtsOyqaUTt+BxPpn+zi7J
 8H7L/gsRWJVr8CF1tk6Vlwj6/eSzL3hKoHJ+GkY/vvANCtkypnSqj56jvw0yP0g7w715HHOnyQj
 DsQNiu2PQQMbFp0RTfosjrGg=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 5fdc89b2f6ddef32;
	Sat, 29 Aug 2026 07:11:25 +0000
X-Mizu-Trace-ID: 5fdc89b2f6ddef32
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Quentin Perret <qperret@google.com>,
	Sebastian Ene <sebastianene@google.com>,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Fuad Tabba <tabba@google.com>
Subject: [PATCH 1/2] KVM: arm64: Sync HCR_EL2.VSE back to the host vCPU under pKVM
Date: Sat, 29 Aug 2026 08:11:19 +0100
Message-Id: <20260829071120.2522788-1-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

flush_hyp_vcpu() copies HCR_EL2.VSE from the host vCPU into the hyp
vCPU on every entry, and nothing copies it back. Once the guest takes
the vSError the hyp vCPU's copy clears with the hardware bit while the
host's stays set, so the next entry pends the same SError again,
KVM_GET_VCPU_EVENTS keeps reporting it, and kvm_arch_vcpu_runnable()
never lets the vCPU block in WFI.

Reflect VSE back on every exit, which the flush-side comment already
promises.

Fixes: 734dc8c01c838 ("KVM: arm64: Implement lazy vCPU state sync for non-protected guests")
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 65a7c735aa398..be35ff5958c82 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -276,6 +276,10 @@ static void sync_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
 
 	host_vcpu->arch.iflags		= hyp_vcpu->vcpu.arch.iflags;
 
+	/* Cleared by hardware once the guest takes the vSError. */
+	host_vcpu->arch.hcr_el2 &= ~HCR_VSE;
+	host_vcpu->arch.hcr_el2 |= hyp_vcpu->vcpu.arch.hcr_el2 & HCR_VSE;
+
 	sync_hyp_vgic_state(hyp_vcpu);
 }
 

base-commit: aa8e5dc6a7a2a1141ab40706a51010adcd0e57d2
-- 
2.39.5

