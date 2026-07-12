Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 976C623394A
	for <kvmarm@lists.linux.dev>; Sun, 12 Jul 2026 14:25:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783866345; cv=none; b=cVkClTyMyvD8G0kLm0gcDsb8/FLI84SR5YycQ5oKo44S2noBT83iqnyaD0IOHoiSHbKnHJbjYPSS4Jeq4YFhDHfg0k7fU8BnmJLlKBEYF/COrWZEFx589odkyxPHMoICeEaHZCpEfpYTp2GlTEHkmfPQNGaOLtxlgxkzNiwyrtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783866345; c=relaxed/simple;
	bh=6QNOkdhCbS1zSrynkcrf4iXWNtn7FlSJMHDEznG+FJs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YRQHECc1ulYxIRj1ChLhdpdtV5MucXWmVn5y5eSVMYfWOyUaDz7CFxXn0Sx309zRWq5tpkYAblVXdQY0Bht3h9KAqbj+W5W7iuse7zcWeMU+1JD5Y7jpaJBLviB64DeQCvyQz3HtqQh+ENuIdXXocXmdrGXGBZ0jo/R+qYy4Zso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ojFG6rlb; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ojFG6rlb"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783866341;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GmUXCwO/YG7npJOqJHZit2JMx0cXqLbuiAg6odak188=;
	b=ojFG6rlblrgsGAGjGw7OtitTORSccIOnviTuASTt5GfgMAzsyWtg77D05Upb1Bryb5mS0b
	I8jiWtU5ApMt55aZd3u0k+CzD8gDZFzLejtPUswBoEpHngvhWz8cgremtw6uNG9is6zxe+
	hpZz2BO3WQ+INuIq4t5Bx70PVvswOhA=
From: Fuad Tabba <fuad.tabba@linux.dev>
To: kvm@vger.kernel.org
Cc: kvmarm@lists.linux.dev,
	Will Deacon <will@kernel.org>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>,
	Fuad Tabba <tabba@google.com>
Subject: [PATCH kvmtool v3 1/4] Initialize the return value in kvm__for_each_mem_bank()
Date: Sun, 12 Jul 2026 15:25:33 +0100
Message-Id: <20260712142536.1391557-2-fuad.tabba@linux.dev>
In-Reply-To: <20260712142536.1391557-1-fuad.tabba@linux.dev>
References: <20260712142536.1391557-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

If none of the bank types match, the function would return an
uninitialized value.

Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 kvm.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kvm.c b/kvm.c
index 7a52c6a..95ccfcb 100644
--- a/kvm.c
+++ b/kvm.c
@@ -383,14 +383,15 @@ u64 host_to_guest_flat(struct kvm *kvm, void *ptr)
  * their type.
  *
  * If one call to @fun returns a non-zero value, stop iterating and return the
- * value. Otherwise, return zero.
+ * value. If none of the bank types match, return -ENODEV. Otherwise, return
+ * zero.
  */
 int kvm__for_each_mem_bank(struct kvm *kvm, enum kvm_mem_type type,
 			   int (*fun)(struct kvm *kvm, struct kvm_mem_bank *bank, void *data),
 			   void *data)
 {
-	int ret;
 	struct kvm_mem_bank *bank;
+	int ret = -ENODEV;
 
 	list_for_each_entry(bank, &kvm->mem_banks, list) {
 		if (type != KVM_MEM_TYPE_ALL && !(bank->type & type))
-- 
2.39.5

