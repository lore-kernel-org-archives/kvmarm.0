Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08AF23A6F09
	for <kvmarm@lists.linux.dev>; Fri, 29 May 2026 07:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780040627; cv=none; b=X+1Z9NBLP4LY1psFi+WoyLXhqtrM7tIuxtdHWTEeOy43Q2B3ooyF8/h/EOxi7WzkdWeZZJDguW8tjWbE4gUHL26leExEA+YkaNIMZzsBEJMgaiZgm+v0HFOrsHKeMVMxCHOHbsuMP6nQPghds0+dWkXbgaa2owqOsJjdO6Fb+/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780040627; c=relaxed/simple;
	bh=T+BBvU9dPmONncq6+SDVFvPjdvMQiwJ6JRgLwFD5SZs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PV3r16aUl6UI7EnKt+5dF5gN0zwZrLBSrp6hANTMs3azEVB2FUL+1zzaWd+yvU4gYJ/s4hCngtGQK5kNynCche4CuKsyLT1tP209/B1uys1p+2Mm+bYUwf8H8kXaqXggug9T21aDEUYu8rU/V03tXzWy3voqN+oM47ZtzN8oWec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Hes3a3tt; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Hes3a3tt"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-48fd33b4921so88988365e9.2
        for <kvmarm@lists.linux.dev>; Fri, 29 May 2026 00:43:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780040623; x=1780645423; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/7Mniq795v9HO00xIoc8A38A3iAvF/LweIfmdHSlDEU=;
        b=Hes3a3tttI0w+nMXl0wnNu0Jfb+ehy4yEi3knC8jWX/g3yDsAbGtPURe3amB1YWD/i
         K5w8jW7ZoDzbfG6VZ1sDzJIiUZ7SGnb5tnbz2A6crEtlTJFkWzoP3O15hsFJIUoaEob2
         fTiGP3j0ItV7wZa9hfT0Gaw4Uq8wdLS03aCi3dL3j9aEVXlwKSNnyZPOwxsklnzXCQzw
         eAs9XZoO4l4Ah693DKLt0/SSxkKuDbjuIIVz0AgQxwXELeY/9cco+ucIcRTNk8n4sZ2e
         /79THqq9tQlNEzZ2YNVPTeEMq+L6w1D8XEWO6WpPLkDgFsJmPuBHeM3w29rhw9/oAsAs
         ZuwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780040623; x=1780645423;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/7Mniq795v9HO00xIoc8A38A3iAvF/LweIfmdHSlDEU=;
        b=pkgjh8xD8ik/6D7+LQqhoH0Mud0LoKN87UaKNownhHfA7QmQC9HmO8oz+H6oDPrbwt
         aeO+3lM7bgZ4+sZI0GtDtCD4X3f7dDq5KAhSoXOJLYcd6goTZYAHedtlix7tJbvYfziW
         ASv68O1lJDepeKaiPvauFVybja7Bli5bQUV37SifUkjf+i/wQajZt72P6ByQFl7aBUPh
         tGmfRm7Q+kCoFjnYkCHC4U37eQyvhfbWeTls3o8LeSl7mszigJit2T5rRcRUNcl6p0xz
         ZpyU7+Y4odFf3d+FtWxl9kr4hoA/4BBt62Wc/fPesUuG7bq8SR2S3Jk2IiNnPkd+zxS3
         ZwPQ==
X-Forwarded-Encrypted: i=1; AFNElJ91qySF88/ho0D/WBCNFDTWv1mzfhMp1QcAJhfPvl5YMwikd56eShGeukmE7Q+NFZXflIbFYZA=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywvre2XAal1aQTh5ODij5di4dAJcKoAQLIVmR8lrZuAH9RVDCV4
	cy+hwK3dyL6iipp1AVe3mcpg46NPbmPwqFfVO3P36zBgnmo5k+Lm9p0S8mV40ZQ17JP13PfUERz
	UcA==
X-Received: from wmlz26.prod.google.com ([2002:a05:600c:221a:b0:490:4896:4968])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:8582:b0:48e:5fb8:f80f
 with SMTP id 5b1f17b1804b1-4909c0e4624mr19865835e9.24.1780040623192; Fri, 29
 May 2026 00:43:43 -0700 (PDT)
Date: Fri, 29 May 2026 08:43:40 +0100
In-Reply-To: <20260529074341.2271950-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260529074341.2271950-1-tabba@google.com>
X-Mailer: git-send-email 2.54.0.929.g9b7fa37559-goog
Message-ID: <20260529074341.2271950-2-tabba@google.com>
Subject: [PATCH 1/2] KVM: arm64: Free hyp-share tracking node when share
 hypercall fails
From: tabba@google.com
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Quentin Perret <qperret@google.com>, Vincent Donnefort <vdonnefort@google.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

share_pfn_hyp() inserts a tracking node into hyp_shared_pfns and
then invokes __pkvm_host_share_hyp. If the hypercall rejects the
share (page-state mismatch at EL2), the node stays in the tree
with refcount 1: a phantom share that leaks the allocation and
that a later unshare will trust.

Erase the node and free it on hypercall failure.

Fixes: a83e2191b7f1 ("KVM: arm64: pkvm: Refcount the pages shared with EL2")
Reported-by: Sashiko (local):gemini-3.1-pro
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/mmu.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 4da9281312eb..4a928fb003ff 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -501,6 +501,10 @@ static int share_pfn_hyp(u64 pfn)
 	rb_link_node(&this->node, parent, node);
 	rb_insert_color(&this->node, &hyp_shared_pfns);
 	ret = kvm_call_hyp_nvhe(__pkvm_host_share_hyp, pfn);
+	if (ret) {
+		rb_erase(&this->node, &hyp_shared_pfns);
+		kfree(this);
+	}
 unlock:
 	mutex_unlock(&hyp_shared_pfns_lock);
 
-- 
2.54.0.929.g9b7fa37559-goog

