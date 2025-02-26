Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5DFA1E1E01
	for <kvmarm@lists.linux.dev>; Wed, 26 Feb 2025 21:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740606930; cv=none; b=LF/m3akDlEtBCJ5SmkdH8eKBm1p0aYZireJurY+fIigI8caSDxecYPeY0v6ugyWVB3D9dFwNL1psJKJaHksBc/2fNkLTIEOLdxttc4oVONmHp+vT5CJB6za13q2bmeClPkW9NkSYnCtDb1hNJTBEaU+1ZE8V66AobyTvk3SXO+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740606930; c=relaxed/simple;
	bh=J5r+z6S5dXSAkSIN5DMXToEmYQM5OhBx5qxFFkgJ8CE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kThP7j8qaJp0/7+ARwyeNRLt9A+IIFivxuTEKppW/Iw6XgovzkyxVm5iAnIZIO47yIFcOTf8zC48VWQYQGezkLJ+LKuDxVieZrCTjIPftsTbj3cU0SuLkKUflXu9ByMfXc1kM2llrM25E68ghrok9CuYE3cJBOCtUhBDcGQAIs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0T0Zvg4K; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0T0Zvg4K"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4398a60b61fso1433265e9.0
        for <kvmarm@lists.linux.dev>; Wed, 26 Feb 2025 13:55:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740606927; x=1741211727; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=uqZ6XQOG6VZQbAio3/rIqBlzFzoIEUifPodtQubNHl8=;
        b=0T0Zvg4KD5/pXjbsBUPhHua5Elkf8fzEQNR6+acJpR7+dBUYyIt6hMA3RoAth4qbVB
         oDWZITSwjThfAn2A6U1HqB83wEUk6s2r145hKUj2LdHHFeUtiZcj/PLD1aIeGnamUC4P
         wiiGfEpZl4QJu3ttlGiMezcVKjaFd1PLcsiUjvoDx40bdsLTH3lK6zxM+RP0iY94V/mP
         IFfaTcQijh4bxyTAWV4oqZJHEYfSRH3Nqsj2AWiQF9yuv11tXGU/7Qb08PhpQCXbfDpg
         b8NwvNQZEOuL61o86CHTRxVWXTqnuzMXgrQ2bQJiuTkKEYEZFne14zjpKkMjo3cwgS86
         0YpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740606927; x=1741211727;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uqZ6XQOG6VZQbAio3/rIqBlzFzoIEUifPodtQubNHl8=;
        b=cIV9/5F0NyoEEuQoxeooEV7rOG45eLHEl6Q/k8egq6zLeagbYmCGozpQPJf0e9//qS
         G5Us0N2JqnyhSPsXvwMu3l8gnQEC47jWXC6glLIkc2QqdDX6PfIksXykB2dPiSn1QC6X
         8x2uftCd4oaRtQAeOYCbp05+cZTldsPVpcGru0NbD/nCAjPDzIRcpK2lKDrQtTfIVp2f
         d2gPxyEFc+QvE65sQgy174QEDG0N+KNNZmoVQmNwo+3OYS6xZJh97/+HSn3OiaVPIJi6
         x85YzU9YNqi9B54uHHGKFs1ctKRGuV2TteCbgs978kaZOaCYmtttXs2hUpCno3jM+T+r
         HdPQ==
X-Gm-Message-State: AOJu0YyvlfdrkWu1GmudWk6G3OGTcEe6XloEfF+a4nYK3PTbfdTUiDsW
	Ve0FZArv5BeXWZlMiuxmLXsZwM4rd00MN+O8y77ozSgqX0yP9NPMNNtLyNIum+Zu0Xtn7EuPZVh
	/xoloDEqLPEvS+VPCFQ1ATjKR66ztjVwuJ+nwWBqjLy3SxoSAZr9m50RMm1LjnNFbijZVO9X6AS
	ubzd6fupRebaKz/lvOegjVGHk+2wA=
X-Google-Smtp-Source: AGHT+IGcdJx0F/SEgDdLOiwRrbPHFrSTncjn9smRK0tUigpTMlpaxS3SaYe8GOM83dky7LXzCw7XKzq2iA==
X-Received: from wmbeq9.prod.google.com ([2002:a05:600c:8489:b0:439:8e81:fd03])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:46c7:b0:439:955d:c4e2
 with SMTP id 5b1f17b1804b1-43ab0f3c192mr75104895e9.13.1740606927078; Wed, 26
 Feb 2025 13:55:27 -0800 (PST)
Date: Wed, 26 Feb 2025 21:55:18 +0000
In-Reply-To: <20250226215520.1759218-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250226215520.1759218-1-tabba@google.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250226215520.1759218-3-tabba@google.com>
Subject: [PATCH v2 2/4] KVM: arm64: Initialize HCRX_EL2 traps in pKVM
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, mark.rutland@arm.com, 
	will@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, broonie@kernel.org, 
	qperret@google.com, vdonnefort@google.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Initialize and set the traps controlled by the HCRX_EL2 in pKVM.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/pkvm.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 3927fe52a3dd..6efb9bf56180 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -166,8 +166,13 @@ static int pkvm_vcpu_init_traps(struct pkvm_hyp_vcpu *hyp_vcpu)
 
 	pkvm_vcpu_reset_hcr(vcpu);
 
-	if ((!pkvm_hyp_vcpu_is_protected(hyp_vcpu)))
+	if ((!pkvm_hyp_vcpu_is_protected(hyp_vcpu))) {
+		struct kvm_vcpu *host_vcpu = hyp_vcpu->host_vcpu;
+
+		/* Trust the host for non-protected vcpu features. */
+		vcpu->arch.hcrx_el2 = host_vcpu->arch.hcrx_el2;
 		return 0;
+	}
 
 	ret = pkvm_check_pvm_cpu_features(vcpu);
 	if (ret)
@@ -175,6 +180,7 @@ static int pkvm_vcpu_init_traps(struct pkvm_hyp_vcpu *hyp_vcpu)
 
 	pvm_init_traps_hcr(vcpu);
 	pvm_init_traps_mdcr(vcpu);
+	vcpu_set_hcrx(vcpu);
 
 	return 0;
 }
-- 
2.48.1.711.g2feabab25a-goog

