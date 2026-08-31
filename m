Received: from mta1.migadu.com (out-234.mta1.migadu.com [95.215.58.234])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2E3844E673
	for <kvmarm@lists.linux.dev>; Mon, 31 Aug 2026 16:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.234
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788194067; cv=none; b=XbUnhinHHoPfr4g5INRM7/Cg0aQkUv8tj6kLiLBahLBEpGOchhDkeR/jYur9ghlpkpm2NGxKojJl5YDLnV8tCQ8c+MtslZVUA2A+HMqv4mJMrLGgSC0uM06p0hJMunyUzpAeQyVx1IbXQ+13YSt28/4XVev+bflQbEMPD6ZvzJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788194067; c=relaxed/simple;
	bh=FNewsXbgZk6ir7Tq/DaFYrMHnt1LVf+kHlt1OXPPVRQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WzslC/2dJCeN+Ihhr4/H5I2zfyaCVUBQ6zos/4Bp4asoAT7Cj7CRG62UcYiKMPNdaeypmZgIs0rPQbFGoISkEUrXRKenykZSULZ1HIg35eZDxmbRCKsi+2CMMfSjFLeNikEx8O/L6AIIBziX+n2Bl/mHRDuYQ+Fh9ml4j95YOOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=PG9dyAEN; arc=none smtp.client-ip=95.215.58.234
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="PG9dyAEN"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=FNewsXbgZk6ir7Tq/DaFYrMHnt1LVf+kHlt1OXPPVRQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788194063; v=1; x=1788798863;
 b=PG9dyAEND8VSa8noM1PtoqkPn7vLScwS6NbOplgGV5p6S5EVBWZn5rbU8XVR7E9xRTPifAWM
 faWo9HN+mpbLgAzLlTuHkJjc+jYmuetKFAl3LoSM5jjfzJvoN7snrAcGWiXKvibiVVpfRwwJRs2
 d80Wpd9nPEG0QMppjXINcERY=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id b210bfa048418e89;
	Mon, 31 Aug 2026 16:34:23 +0000
X-Mizu-Trace-ID: b210bfa048418e89
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
	Fuad Tabba <tabba@google.com>
Subject: [PATCH 02/17] KVM: arm64: Advertise the capabilities that protected VMs support
Date: Mon, 31 Aug 2026 17:34:06 +0100
Message-Id: <20260831163421.272420-3-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260831163421.272420-1-fuad.tabba@linux.dev>
References: <20260831163421.272420-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

kvm_pkvm_ext_allowed() denies every capability it does not name, so a
protected VM reports 0 for interfaces it implements: KVM_CHECK_EXTENSION
denies KVM_CAP_ONE_REG while KVM_{GET,SET}_ONE_REG stage the guest's
boot state.

Allow the capabilities that work for a protected guest, the vGIC and
the I/O bus being host-managed, subject to the restrictions the rest of
this series adds.

Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/include/asm/kvm_pkvm.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
index beea00e693a0a..c4c834d55e503 100644
--- a/arch/arm64/include/asm/kvm_pkvm.h
+++ b/arch/arm64/include/asm/kvm_pkvm.h
@@ -42,6 +42,15 @@ static inline bool kvm_pkvm_ext_allowed(struct kvm *kvm, long ext)
 	case KVM_CAP_ARM_VM_IPA_SIZE:
 	case KVM_CAP_ARM_PTRAUTH_ADDRESS:
 	case KVM_CAP_ARM_PTRAUTH_GENERIC:
+	case KVM_CAP_ONE_REG:
+	case KVM_CAP_MP_STATE:
+	case KVM_CAP_VCPU_EVENTS:
+	case KVM_CAP_VCPU_ATTRIBUTES:
+	case KVM_CAP_IMMEDIATE_EXIT:
+	case KVM_CAP_IOEVENTFD:
+	case KVM_CAP_IRQFD_RESAMPLE:
+	case KVM_CAP_ARM_IRQ_LINE_LAYOUT_2:
+	case KVM_CAP_ARM_INJECT_SERROR_ESR:
 		return true;
 	case KVM_CAP_ARM_MTE:
 		return false;
-- 
2.39.5

