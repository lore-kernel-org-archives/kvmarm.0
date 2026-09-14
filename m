Received: from mta0.migadu.com (out-169.mta0.migadu.com [91.218.175.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B0C141F344
	for <kvmarm@lists.linux.dev>; Mon, 14 Sep 2026 09:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789378727; cv=none; b=WKXcyfihM2ALE3QTtvK7fPv+cw+L+TFPeLLa2U9wKWGX8XBHcyRd0D+7+BkxJzF8gMiWBOifrGwM5I++AxjiyGQ+GvpkHZsWiBCz3/nL13xXbUEKKD8QhpkrX9TT2qt+79oICWIQDhMaNvfvx6IdTxaIZFj7BLNyyOmy7dfCdV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789378727; c=relaxed/simple;
	bh=Z56ci8XJpnyMsmeEYOX34hHR6NCwZFp+Ce7KKyuVDqc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=BaUTZenuQpP2yoQ+iSNsnpY4sOXBGhMSKOVVQ+LXE+gB5pUGhCS9QrtXcLf7jD1eO7qtWJUH5aCBm5a+FbOGr3nOFUMuMme07uspKfVd6MjWL9mTbgKwBzoxpw8GgdhomOQ/9eryBwBflCrMwW3BchzW9NR88Wo9lPn2pFOK+dk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=KOdd4U8I; arc=none smtp.client-ip=91.218.175.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="KOdd4U8I"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=Z56ci8XJpnyMsmeEYOX34hHR6NCwZFp+Ce7KKyuVDqc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789378723; v=1; x=1789983523;
 b=KOdd4U8IMyWR0QKicX+iGj3NfOlHq7yOTkIf4iOlmm01miaB6K3Sy5oTfnKT9FkMQLSrAir8
 NMtSZHGWDUWJ7Fc5FnjBi4S+8uiQ41UXlvKvWPycbYGXKS8fD8+e30Ix8kUGMCepySzRDhWiKax
 U97EDNNf/UXcJHIr/eC6W3rU=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 9986b6a69b475a7f;
	Mon, 14 Sep 2026 09:38:43 +0000
X-Mizu-Trace-ID: 9986b6a69b475a7f
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: Fuad Tabba <fuad.tabba@linux.dev>,
	Fuad Tabba <tabba@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: arm64: Don't WARN on an unknown VM ioctl in protected mode
Date: Mon, 14 Sep 2026 10:38:38 +0100
Message-Id: <20260914093838.1082637-1-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

kvm_pkvm_ioctl_allowed() WARNs when kvm_get_cap_for_kvm_ioctl() doesn't
find the ioctl number in vm_ioctl_caps[], and kvm_arch_vm_ioctl() calls
it for every number the generic code doesn't handle, so
ioctl(vm_fd, 0xdeadbeef) from userspace taints a pKVM host and panics it
under panic_on_warn. The lookup is fed userspace input: return false,
and userspace gets the -EINVAL kvm_arch_vm_ioctl() returns for that
number on a host without pKVM.

Fixes: b12b3b04f6ba0 ("KVM: arm64: Check whether a VM IOCTL is allowed in pKVM")
Cc: stable@vger.kernel.org
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/include/asm/kvm_pkvm.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
index beea00e693a0a..cad60569f0619 100644
--- a/arch/arm64/include/asm/kvm_pkvm.h
+++ b/arch/arm64/include/asm/kvm_pkvm.h
@@ -65,8 +65,7 @@ static inline bool kvm_pkvm_ioctl_allowed(struct kvm *kvm, unsigned int ioctl)
 	int r;
 
 	r = kvm_get_cap_for_kvm_ioctl(ioctl, &ext);
-
-	if (WARN_ON_ONCE(r < 0))
+	if (r < 0)
 		return false;
 
 	return kvm_pkvm_ext_allowed(kvm, ext);
-- 
2.39.5

