Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A938A18FC6F
	for <kvmarm@lists.linux.dev>; Mon, 17 Jun 2024 18:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718647835; cv=none; b=svP4XWL1rvBiaxa643/y/yPxJ4O12HJi40wQ0lb+JL1a2MHqw5Ke9k8mT0rjpmKbu9/UdFrE0jxdQQdcPYaA4iqT08HlzKstlXbyHj+zndSa3FrYc2RxPNXt6B7vnMf5L8ba2Z3dgBdOUg24xvzPnS41hKmBn3gnJ8R8YRiSOvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718647835; c=relaxed/simple;
	bh=RpX8yRpzR64qaR5ym4hHlRfv1gHFV8mRtWBTwGFYeyQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ArOfLBX+aNMFwkzcIrmrVU1nIbD1zm1q6LUPuWbjwBo5VK4Dd+DA/rgeNomCz4xOcyQ9jONmkdvzq7avvROrXMHlpKEqdSkw+8f7i8omE2fB+yfvuzIRpK8ZZAlLHiaQFNC7ZIJbP3A8EO4jzfwB4cyZ29+r9lsMAUVbHmcSfog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=qcQzDKJj; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="qcQzDKJj"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1718647831;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=i1dzTNX7kiPkv9BnTsw0udSTtNCRCGpYIySxS5nAnT4=;
	b=qcQzDKJjWPX5XPqR34+8tWqxRR7ZcN54OqrTsL5T0FYu8KaUvQYSpXUIEAzwenk1zMjIqp
	e3UE7/2rmCbvGozFxo/5JSld6raRCRaXJswU8BwGTzAedAc+jp2YL3yxb4h4m2yutEe6Wp
	3WxIll+sWODEieN1vCm9PReh0unYVGQ=
X-Envelope-To: maz@kernel.org
X-Envelope-To: james.morse@arm.com
X-Envelope-To: suzuki.poulose@arm.com
X-Envelope-To: yuzenghui@huawei.com
X-Envelope-To: kvm@vger.kernel.org
X-Envelope-To: oliver.upton@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	kvm@vger.kernel.org,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH] KVM: arm64: nv: Use GFP_KERNEL_ACCOUNT for sysreg_masks allocation
Date: Mon, 17 Jun 2024 18:10:18 +0000
Message-ID: <20240617181018.2054332-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Of course, userspace is in the driver's seat for struct kvm and
associated allocations. Make sure the sysreg_masks allocation
participates in kmem accounting.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/nested.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 6813c7c7f00a..57e3fb3eb334 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -196,7 +196,7 @@ int kvm_init_nv_sysregs(struct kvm *kvm)
 		goto out;
 
 	kvm->arch.sysreg_masks = kzalloc(sizeof(*(kvm->arch.sysreg_masks)),
-					 GFP_KERNEL);
+					 GFP_KERNEL_ACCOUNT);
 	if (!kvm->arch.sysreg_masks) {
 		ret = -ENOMEM;
 		goto out;

base-commit: 1613e604df0cd359cf2a7fbd9be7a0bcfacfabd0
-- 
2.45.2.627.g7a2c4fd464-goog

