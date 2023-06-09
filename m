Received: from out-54.mta1.migadu.com (out-54.mta1.migadu.com [95.215.58.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C3A318C34
	for <kvmarm@lists.linux.dev>; Fri,  9 Jun 2023 19:01:33 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1686337291;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ITYLxPVAQ13jG985nUYJse0vQlKeZMLqivFjek+lM8g=;
	b=czVuWQOUdWWwQQWGJng0Lm4GZiGl/m5HUda6JMX/NYSqqeL4Q/oBcjzaABnzcFCgqT0bOO
	3pBl1e12rr+piSFnm+hJA9rEMG0cwmQygcIH7vLoTiH8sORT1vQIGL9xFIlvhtPDmvM4nt
	een/SexxgPWpO9RaoJIoz3X1sfeclv0=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Fuad Tabba <tabba@google.com>,
	linux-arm-kernel@lists.infradead.org,
	surajjs@amazon.com,
	Cornelia Huck <cohuck@redhat.com>,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Jing Zhang <jingzhangos@google.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v12 10/11] KVM: arm64: Handle ID register reads using the VM-wide values
Date: Fri,  9 Jun 2023 19:00:53 +0000
Message-ID: <20230609190054.1542113-11-oliver.upton@linux.dev>
In-Reply-To: <20230609190054.1542113-1-oliver.upton@linux.dev>
References: <20230609190054.1542113-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Everything is in place now to use the generic ID register
infrastructure. Use the VM-wide values to service ID register reads.
The ID registers are invariant after the VM has started, so there is no
need for locking in that case. This is rather desirable for VM live
migration, as the needless lock contention could prolong the VM blackout
period.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/sys_regs.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 6f2ce6619993..e5b71ede7928 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1395,7 +1395,7 @@ static u64 kvm_read_sanitised_id_reg(struct kvm_vcpu *vcpu,
 
 static u64 read_id_reg(const struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 {
-	return __kvm_read_sanitised_id_reg(vcpu, r);
+	return IDREG(vcpu->kvm, reg_to_encoding(r));
 }
 
 /*
@@ -1634,7 +1634,19 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
 static int get_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 		      u64 *val)
 {
+	/*
+	 * Avoid locking if the VM has already started, as the ID registers are
+	 * guaranteed to be invariant at that point.
+	 */
+	if (kvm_vm_has_ran_once(vcpu->kvm)) {
+		*val = read_id_reg(vcpu, rd);
+		return 0;
+	}
+
+	mutex_lock(&vcpu->kvm->arch.config_lock);
 	*val = read_id_reg(vcpu, rd);
+	mutex_unlock(&vcpu->kvm->arch.config_lock);
+
 	return 0;
 }
 
-- 
2.41.0.162.gfafddb0af9-goog

