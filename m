Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 068B33FE375
	for <kvmarm@lists.linux.dev>; Fri, 17 Jul 2026 13:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784293455; cv=none; b=ietr8Nm0oQQAY+CFlgZU13exbgn50eHVGBdYzPYARHXCWKVVl7PTYaYdm39uv++FREBxRV/5kVqtQiXNhhtbkpv8DFlaseKS/k444mgEHnSdxAHvho7z/Xqo0SfWoLXwTIgQS8U/gXcThbbMMEKzHUoe+MZJpLXSvVtd6OChR4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784293455; c=relaxed/simple;
	bh=/dJq1ElgkuWD4WVTYnRbakmDuhEmWZkPbbAcOrtDOFg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tAghpAghXdQBYoJcxALbL2UQ2W4x7PN0GY5Flsw1d8Qwl/8XMZ3ChD9ff1KP71sYTaWPbTMrU5lZuLGA21LKmkOVNVlzoaZ1sZx31KNFfWNYhLHRt6tqHt2D20P311+5Xari1aHJ0UBJuBzkbAAubEQ8GwC9tn6B6mMrYuvn6MY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=vTqZQVcv; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="vTqZQVcv"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784293451;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=w6Awn3Cip6WinOaXp4OqAmFuhAYE4A4acDGbfEewbog=;
	b=vTqZQVcvnbqTera6vR3ctDXJn/somZz5PfLLM0khrASOMvrxrDjGa+jgm1rPclTNFJ9VHZ
	W4pJeIuM2LskrdT4zeBAcXZHQUPnlN5eiS2bHHkWZJaBd/S03Nu+a9kOjG2hURa0tnI5vo
	3fnSaxpDtapXRTv/t+dkvxH3HOBBF4I=
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Quentin Perret <qperret@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Gavin Shan <gshan@redhat.com>,
	Dev Jain <dev.jain@arm.com>,
	Bradley Morgan <include@grrlz.net>,
	Fuad Tabba <tabba@google.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v5 6/7] KVM: arm64: Don't advertise eager page splitting under pKVM
Date: Fri, 17 Jul 2026 14:03:16 +0100
Message-Id: <20260717130317.1953574-7-fuad.tabba@linux.dev>
In-Reply-To: <20260717130317.1953574-1-fuad.tabba@linux.dev>
References: <20260717130317.1953574-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Under pKVM the stage-2 walker resolves to pkvm_pgtable_stage2_split(), a
WARN_ON_ONCE(1) stub, yet KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE is still
enabled and reported for non-protected guests: the capability check keys
on the per-VM protected state while the walker dispatch keys on the
host-global mode. Enabling the cap and then dirty-logging the guest
reaches the stub, splatting a userspace-reachable WARN.

Reject the capability, and stop reporting a chunk size and the
supported block sizes, for every VM once pKVM is enabled, keyed on the
host-global mode like the split dispatch. Gating only protected VMs
would leave the non-protected guests that reach the stub still able to
enable it. Userspace decides whether eager splitting is available from
the block-size bitmap (QEMU falls back to no eager splitting when it
reads 0), so leaving it advertised steers an explicit request into the
enable failure instead of the fallback.

Fixes: e912efed485a ("KVM: arm64: Introduce the EL1 pKVM MMU")
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/include/asm/kvm_pkvm.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
index 57afb07d6b13..beea00e693a0 100644
--- a/arch/arm64/include/asm/kvm_pkvm.h
+++ b/arch/arm64/include/asm/kvm_pkvm.h
@@ -45,6 +45,9 @@ static inline bool kvm_pkvm_ext_allowed(struct kvm *kvm, long ext)
 		return true;
 	case KVM_CAP_ARM_MTE:
 		return false;
+	case KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE:
+	case KVM_CAP_ARM_SUPPORTED_BLOCK_SIZES:
+		return false;
 	default:
 		return !kvm || !kvm_vm_is_protected(kvm);
 	}
-- 
2.39.5

