Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EE5E1581FC
	for <kvmarm@lists.linux.dev>; Wed, 19 Jun 2024 17:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718818873; cv=none; b=Sq3cUi3pRN7W+NuyZqjrr8p2s9BzuXlTlR9GmDSBbm5683f/mv3deOWA5+l1Rhd3f3XTpur1Bt2wCjxyir0qI+wYu0BT2vbs2bulw46rBBEx5c2JI65dif27TF0SkL0ywGApR4HPkzt5ROkRs2ieUdNlNBRxAmFqGh6pp4vQcGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718818873; c=relaxed/simple;
	bh=QdkSxu8RWXYAe3d4ZOF2/aNp2IqZy+O8nOdjJwYWIQA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FlGoMtB6jzC0ybf7m4HTUkMM740E9ybC52CInJZF5CMeiE/EkxrF1KhFGCUAFIWM0jjyzqQ4TV0+j6LdA84RjbrItS/ZSdG4lYsqiOnu5e04I0ipUjaZRKufPbojwiVBC+e+Ja3cunVM+3UXUJRrU5yezoLqpl2YmwBoKYQ9fvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=pMSD5DNL; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="pMSD5DNL"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1718818870;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0r3LHAfIdQgocAIW5eYByrh9rwZzcWsyVJwKWHfsoaA=;
	b=pMSD5DNLD0mckbTeX47jCn95koa+zPl2fp86ZMig+g61kSVwOuvAMbdnDJHLtDwUrzcC9M
	U7tNtmpo5pGUyz+zfFyhWslQ60KVUSKiM7ty1IzPIPblxJglpaCkkRdVtSmZwVLR9WcHPW
	+4qeDRL+utMyAefQzY34g1GNWK38QOM=
X-Envelope-To: maz@kernel.org
X-Envelope-To: james.morse@arm.com
X-Envelope-To: suzuki.poulose@arm.com
X-Envelope-To: yuzenghui@huawei.com
X-Envelope-To: kvm@vger.kernel.org
X-Envelope-To: sebott@redhat.com
X-Envelope-To: shahuang@redhat.com
X-Envelope-To: eric.auger@redhat.com
X-Envelope-To: oliver.upton@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	kvm@vger.kernel.org,
	Sebastian Ott <sebott@redhat.com>,
	Shaoqin Huang <shahuang@redhat.com>,
	Eric Auger <eric.auger@redhat.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v5 10/10] KVM: selftests: arm64: Test writes to CTR_EL0
Date: Wed, 19 Jun 2024 17:40:36 +0000
Message-ID: <20240619174036.483943-11-oliver.upton@linux.dev>
In-Reply-To: <20240619174036.483943-1-oliver.upton@linux.dev>
References: <20240619174036.483943-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Sebastian Ott <sebott@redhat.com>

Test that CTR_EL0 is modifiable from userspace, that changes are
visible to guests, and that they are preserved across a vCPU reset.

Signed-off-by: Sebastian Ott <sebott@redhat.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 .../testing/selftests/kvm/aarch64/set_id_regs.c  | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/tools/testing/selftests/kvm/aarch64/set_id_regs.c b/tools/testing/selftests/kvm/aarch64/set_id_regs.c
index a7de39fa2a0a..9583c04f1228 100644
--- a/tools/testing/selftests/kvm/aarch64/set_id_regs.c
+++ b/tools/testing/selftests/kvm/aarch64/set_id_regs.c
@@ -219,6 +219,7 @@ static void guest_code(void)
 	GUEST_REG_SYNC(SYS_ID_AA64MMFR1_EL1);
 	GUEST_REG_SYNC(SYS_ID_AA64MMFR2_EL1);
 	GUEST_REG_SYNC(SYS_ID_AA64ZFR0_EL1);
+	GUEST_REG_SYNC(SYS_CTR_EL0);
 
 	GUEST_DONE();
 }
@@ -490,11 +491,25 @@ static void test_clidr(struct kvm_vcpu *vcpu)
 	test_reg_vals[encoding_to_range_idx(SYS_CLIDR_EL1)] = clidr;
 }
 
+static void test_ctr(struct kvm_vcpu *vcpu)
+{
+	u64 ctr;
+
+	vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_CTR_EL0), &ctr);
+	ctr &= ~CTR_EL0_DIC_MASK;
+	if (ctr & CTR_EL0_IminLine_MASK)
+		ctr--;
+
+	vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_CTR_EL0), ctr);
+	test_reg_vals[encoding_to_range_idx(SYS_CTR_EL0)] = ctr;
+}
+
 static void test_vcpu_ftr_id_regs(struct kvm_vcpu *vcpu)
 {
 	u64 val;
 
 	test_clidr(vcpu);
+	test_ctr(vcpu);
 
 	vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_MPIDR_EL1), &val);
 	val++;
@@ -525,6 +540,7 @@ static void test_reset_preserves_id_regs(struct kvm_vcpu *vcpu)
 		test_assert_id_reg_unchanged(vcpu, test_regs[i].reg);
 
 	test_assert_id_reg_unchanged(vcpu, SYS_CLIDR_EL1);
+	test_assert_id_reg_unchanged(vcpu, SYS_CTR_EL0);
 
 	ksft_test_result_pass("%s\n", __func__);
 }
-- 
2.45.2.627.g7a2c4fd464-goog

