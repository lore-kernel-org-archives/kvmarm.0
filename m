Received: from mta0.migadu.com (out-3.mta0.migadu.com [91.218.175.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3541D44470A
	for <kvmarm@lists.linux.dev>; Mon, 14 Sep 2026 11:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789385769; cv=none; b=bfYFDU29Kw+JTS+VUtY/KHWItbWjG9iXsxAHOd7Mlw7j1TlFcE4scI0RApBWdzL/Kih0nLGiwfP+a0WhEoRUJVxksjEesV2OXeIHOKYtabu5ykMGOZtFuup7rkNEUZN3e558eZlwXwVX4YSeEl6VpzLhZ7Mo1B6AyW1TGQ3BgKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789385769; c=relaxed/simple;
	bh=2tuch6nKrMgq3ucfEYUyfKrn4X670ODoqukWreMj99k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BBPoUGKCdBhJCGYuuLzyF1L/9Q6X78pAnUjLMy8hKP7OPdg2C2jtYdlMcp3DSuPjeQMAnZpzYFwfNoDbdB7OndilEzzvd+s3RhQK5lYKZmDRe3vjggsr6BjrxiQzHVaUNTxJ/2D96rFHv1BQMXhQI03S4cVPAVkBrHpnmAnPHMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=RnloSrl6; arc=none smtp.client-ip=91.218.175.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="RnloSrl6"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=2tuch6nKrMgq3ucfEYUyfKrn4X670ODoqukWreMj99k=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789385766; v=1; x=1789990566;
 b=RnloSrl6ponThZ9yBOV/KxDHLg+/PpcVbSg1G6DCM/itFEES9rKl0DVDq+BBcwBqtnyybJAm
 W+KlhfCF7T3wLfmusYoh9gi1SP46GNlKjnbmkJhGXtEVXJ+zuT2YwMoWKTARysd5jTbBfZkff95
 w6pD4td6x8XY3r7B6IlJEBUM=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 4aad1262d0248429;
	Mon, 14 Sep 2026 11:36:05 +0000
X-Mizu-Trace-ID: 4aad1262d0248429
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: maz@kernel.org,
	oupton@kernel.org,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: catalin.marinas@arm.com,
	will@kernel.org,
	joey.gouly@arm.com,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	mark.rutland@arm.com,
	steven.price@arm.com,
	vdonnefort@google.com,
	qperret@google.com,
	tabba@google.com
Subject: [PATCH v3 17/18] KVM: arm64: Advertise the capabilities that protected VMs support
Date: Mon, 14 Sep 2026 12:33:37 +0100
Message-Id: <20260914113338.159227-18-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260914113338.159227-1-fuad.tabba@linux.dev>
References: <20260914113338.159227-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For a protected VM, kvm_pkvm_ext_allowed() returns false on every
capability it doesn't name, so KVM_CHECK_EXTENSION returns 0 for
interfaces the VM implements: it denies KVM_CAP_ONE_REG while
KVM_{GET,SET}_ONE_REG stage the guest's boot state.

Allow the capabilities that work for a protected guest under the
restrictions the preceding patches add, the vGIC and the I/O bus being
host-managed.

Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/include/asm/kvm_pkvm.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
index fbea052fa3e16..a165af0d75689 100644
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

