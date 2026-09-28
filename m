Received: from mta0.migadu.com (out-26.mta0.migadu.com [91.218.175.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A38164E77FE
	for <kvmarm@lists.linux.dev>; Mon, 28 Sep 2026 15:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.26
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790609167; cv=none; b=gUZNKHemYx1h3ByprKmn+c0qqNgQa5TFG9/qW+OlGR+b0geknMsv63Rp6vkDERDq/ZXXGqjulgRFXl4ve/5G3a7R+ivlY1wDMg1DXH/g/SB59x0ElYK0AUXYxvF2nncPJO0IEcq/++u/r+78xMqKn0L3CY4eqLM9tJeMZGLfVNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790609167; c=relaxed/simple;
	bh=TZTf+tvw3LUL1bGKJNCtbY5lbMJJlJLgbm/WT+dWO1Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qhHCCwmS5WShO8st8GcQeNLvd9rR8LEbeKy6+7RrL/jwr/YCdCz4qsC1XW4F1np3sE7NKMwno5xTF2/wUIiVGfhcJngHXnD8KpBco1APrDB3l9bizt9LoFzw4DUl4EJCXqqsDC1L6DZAu9FPx59mOP/zBIrDf+pd7UbO0o2HVo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=i4j446Ev; arc=none smtp.client-ip=91.218.175.26
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="i4j446Ev"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=TZTf+tvw3LUL1bGKJNCtbY5lbMJJlJLgbm/WT+dWO1Q=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790609157; v=1; x=1791213957;
 b=i4j446EvswzeSDjBw7nuKeEVuS+zpKJRh+rKzMlIjjiA3S2e24h5+h/RtP3LmgQYkCBbktZM
 7A1ywReMQ4B2MmTg2jlPpQJhUDG/DnAilVNZF2j5jLHYNUPJFCezvzdwlbL0psOKTfyd4u6GR5P
 efT0OC+4KN75WQqJg2GlvwtU=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 5cf54109416d45bb;
	Mon, 28 Sep 2026 15:25:57 +0000
X-Mizu-Trace-ID: 5cf54109416d45bb
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
Subject: [PATCH v1 07/10] Documentation: KVM: Fix the name of KVM_ARM_SET_COUNTER_OFFSET
Date: Mon, 28 Sep 2026 16:25:04 +0100
Message-Id: <20260928152507.2116110-8-fuad.tabba@linux.dev>
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

The KVM_ARM_SET_COUNTER_OFFSET section of api.rst names the ioctl
KVM_ARM_SET_CNT_OFFSET, which doesn't exist.

Fixes: 1935d34afaebe ("KVM: arm64: Document KVM_ARM_SET_CNT_OFFSETS and co")
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 Documentation/virt/kvm/api.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index fabb1d4bf8f8d..e5efdc56f3d29 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6265,7 +6265,7 @@ set to 0s by userspace.
 
 This capability indicates that userspace is able to apply a single VM-wide
 offset to both the virtual and physical counters as viewed by the guest
-using the KVM_ARM_SET_CNT_OFFSET ioctl and the following data structure:
+using the KVM_ARM_SET_COUNTER_OFFSET ioctl and the following data structure:
 
 ::
 
-- 
2.39.5

