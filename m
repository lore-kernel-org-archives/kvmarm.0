Received: from mta1.migadu.com (out-70.mta1.migadu.com [95.215.58.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E05BF4E80BA
	for <kvmarm@lists.linux.dev>; Mon, 28 Sep 2026 15:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790609168; cv=none; b=iQD0GGzHPUd6s41EHqKAIrKXL8Uq8WEFUpnnypWhZxFsnzQWQgBsokFZxOt7/nU4AIiY5qTZIXJPZuaTLYWDX+VU+BxZU5Dp0vQwt8nUZdajQLpcebWzVWHhZRrvlaAhBEoVegQnBY1HG4ucapFf3Oj6MbB2uIAURzImZOsIrow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790609168; c=relaxed/simple;
	bh=15qFRotLPfvjMOJ1gQJLuHOeW3ckIYvFdOdvtKh1ci4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=cJmusEyyUFLiqchBkLoMdMGb30yPBaTCyf/XyyY1HZtexibf4rUQRpO5CU+GfAb/25q926Hh5DK2dLCpVVmRF69kFMCjOyTVpP9KseYoI1D/2zzE4O16/acD82SSTdhjRjkYintH1/MOnTXVCUOpclrVl//4Nfi7aajTTPTPMUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=obeJo6St; arc=none smtp.client-ip=95.215.58.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="obeJo6St"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=15qFRotLPfvjMOJ1gQJLuHOeW3ckIYvFdOdvtKh1ci4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790609159; v=1; x=1791213959;
 b=obeJo6StcivAizKpQ5GgnZ399raDyXsPg37tv4FKHsgZPyVYMzyfgnIx7JE+IDYXSHadONnn
 hNhvppxhR0iv/L1LXC3X4mvdKtgraeX/pf6aNTgVH1V5Cq9UfeZh5nqZnE/2ArsK5UH3M0XyEyZ
 TT3LabDMZ6e+PGHUdFraG/4k=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 39eed6f455da3869;
	Mon, 28 Sep 2026 15:25:59 +0000
X-Mizu-Trace-ID: 39eed6f455da3869
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Jing Zhang <jingzhangos@google.com>,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Fuad Tabba <tabba@google.com>,
	kvm@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v1 08/10] Documentation: KVM: Fix the name of KVM_ARM_FEATURE_ID_RANGE_IDX
Date: Mon, 28 Sep 2026 16:25:05 +0100
Message-Id: <20260928152507.2116110-9-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260928152507.2116110-1-fuad.tabba@linux.dev>
References: <20260928152507.2116110-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

api.rst says the array KVM_ARM_GET_REG_WRITABLE_MASKS returns is
indexed by ARM64_FEATURE_ID_RANGE_IDX(), a macro that exists nowhere
else. The macro is KVM_ARM_FEATURE_ID_RANGE_IDX().

Fixes: 6656cda0f3b26 ("KVM: arm64: Document KVM_ARM_GET_REG_WRITABLE_MASKS")
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 Documentation/virt/kvm/api.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index e5efdc56f3d29..58265372db165 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6337,7 +6337,7 @@ The Feature ID range is defined as the AArch64 System register space with
 op0==3, op1=={0, 1, 3}, CRn==0, CRm=={0-7}, op2=={0-7}.
 
 The mask returned array pointed to by ``addr`` is indexed by the macro
-``ARM64_FEATURE_ID_RANGE_IDX(op0, op1, crn, crm, op2)``, allowing userspace
+``KVM_ARM_FEATURE_ID_RANGE_IDX(op0, op1, crn, crm, op2)``, allowing userspace
 to know what fields can be changed for the system register described by
 ``op0, op1, crn, crm, op2``. KVM rejects ID register values that describe a
 superset of the features supported by the system.
-- 
2.39.5

