Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C511B1272AC;
	Fri, 12 Apr 2024 08:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712911466; cv=none; b=XIAHcj0lJihZ8bn3ZBsc5CZ7LoWKgkCO0buYYSzjIAxmxQ1+recnkeQsiBtqpzGOOC8zLH4+1tEJgduUeb9+GLxGkjFOOVjFa0b0/UezsgQaD0Q6/REhV3xkeufrwNnuLUjhzY/yz/4Iug9S0VfjsF+8GQIox7K2JyoTr/XvcQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712911466; c=relaxed/simple;
	bh=VLPO//f8iiRAMFU63YIgd04F7MJMw7wgmtrqbH6xF48=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hRFD/+XBFLD9q/wV33G+Wy8XgDps8QjdSsi/EVkiBUmXTRk1kRmFXcgjtz4lsQrmlYyQvYgjWbdfRX5sUCBBvulMOJdzkWY1tQnseY2kkBK8z2XWtBOH5dW8rBQSKQBaoCMls1dtHuiiT4i5LxKhEYvmGz5Udi3aD9AVgnoboo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 79C0F14BF;
	Fri, 12 Apr 2024 01:44:53 -0700 (PDT)
Received: from e112269-lin.cambridge.arm.com (e112269-lin.cambridge.arm.com [10.1.194.51])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1DE8C3F6C4;
	Fri, 12 Apr 2024 01:44:22 -0700 (PDT)
From: Steven Price <steven.price@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: Joey Gouly <joey.gouly@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>,
	linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Steven Price <steven.price@arm.com>
Subject: [PATCH v2 28/43] arm64: rme: support RSI_HOST_CALL
Date: Fri, 12 Apr 2024 09:42:54 +0100
Message-Id: <20240412084309.1733783-29-steven.price@arm.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240412084309.1733783-1-steven.price@arm.com>
References: <20240412084056.1733704-1-steven.price@arm.com>
 <20240412084309.1733783-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Joey Gouly <joey.gouly@arm.com>

Forward RSI_HOST_CALLS to KVM's HVC handler.

Signed-off-by: Joey Gouly <joey.gouly@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
---
 arch/arm64/kvm/rme-exit.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/arch/arm64/kvm/rme-exit.c b/arch/arm64/kvm/rme-exit.c
index 2ddaec09cc98..b442e9a00d07 100644
--- a/arch/arm64/kvm/rme-exit.c
+++ b/arch/arm64/kvm/rme-exit.c
@@ -116,6 +116,29 @@ static int rec_exit_ripas_change(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+static int rec_exit_host_call(struct kvm_vcpu *vcpu)
+{
+	int ret, i;
+	struct realm_rec *rec = &vcpu->arch.rec;
+
+	vcpu->stat.hvc_exit_stat++;
+
+	for (i = 0; i < REC_RUN_GPRS; i++)
+		vcpu_set_reg(vcpu, i, rec->run->exit.gprs[i]);
+
+	ret = kvm_smccc_call_handler(vcpu);
+
+	if (ret < 0) {
+		vcpu_set_reg(vcpu, 0, ~0UL);
+		ret = 1;
+	}
+
+	for (i = 0; i < REC_RUN_GPRS; i++)
+		rec->run->entry.gprs[i] = vcpu_get_reg(vcpu, i);
+
+	return ret;
+}
+
 static void update_arch_timer_irq_lines(struct kvm_vcpu *vcpu)
 {
 	struct realm_rec *rec = &vcpu->arch.rec;
@@ -177,6 +200,8 @@ int handle_rme_exit(struct kvm_vcpu *vcpu, int rec_run_ret)
 		return rec_exit_psci(vcpu);
 	case RMI_EXIT_RIPAS_CHANGE:
 		return rec_exit_ripas_change(vcpu);
+	case RMI_EXIT_HOST_CALL:
+		return rec_exit_host_call(vcpu);
 	}
 
 	kvm_pr_unimpl("Unsupported exit reason: %u\n",
-- 
2.34.1

