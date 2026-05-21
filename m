Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 989B338423B
	for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 08:13:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779351188; cv=none; b=gvLLjq1MPjOqnqV4xgBtnoeZGSwbuTTaPUtanIMmrAnGXRflxd22610c2DkbUVQ58x02kqlra9ShLqm3H0s+1dxETyo+2MrrRumicCtQl59jr/IUScmIlVF0pOqGD6LDTgCle08xElHGEdUyZxtz1QgfF7zAvNTqTvdy/flcNvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779351188; c=relaxed/simple;
	bh=P1L3xGC2PCRqdhUgK++ux7CGGp66OI/H77gL/QAJZX8=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=YHBlChJMXWyALgg8RAWFatP/RQXzUtSkJsTLfVcpui8F5yzaJ5Afwyh6nb2MPavmMv/GBcw+mbLTrGQE3Kqb5cY+a+P0C4Z9Jw9RZtU+eqG7KLr492jvAPH4RmSL7+NEOz7nIBp0zsPCSjB4/++cvim1CRD1UhX9Pf5SvaUbSKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=i557qQMr; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="i557qQMr"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-43d7b7bacddso4248188f8f.0
        for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 01:13:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779351185; x=1779955985; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=9eas+8o5MH+y6MgYV1i/0RO9VKyND+KUg4XjJ1gtWmA=;
        b=i557qQMrJMtkxSFyY3bqXr0EPoC8sWCvJHLDK52q655hkXUGtt9qPCQzEZFKAlbk09
         LrZu7ICz6wBK1Omf7PZDGLTBU9nKWzEW/lHXN44TCt/GP87g9/XZ377nStsgnOdmRLRz
         8X+PY4BAKD6bokYMBPhoF1OGBXcClXFxzD8pVk698W861ej99RUxWa+vneB9JYAK6734
         M7nTpD4Dg4Yv+iDym3jJDPaB9TKfFDa1dxf90I9J7SC2nt9bws1f5uTCYCIBLAV1+LnG
         6ujIYB2d6Kweh6Y8IfDQP5j/g5BFuSNxnl0HBYqYfZ2CepOfyrZAD21qScz8KDcFWux9
         +Z7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779351185; x=1779955985;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9eas+8o5MH+y6MgYV1i/0RO9VKyND+KUg4XjJ1gtWmA=;
        b=qox9D3SKmL15X1yjTMPWaqtPsUFtXj8Mr1zFtfKiovMRHN734YROwE6WuedPOtS9nm
         mpWvy4cEs+YJ3j59mvofHC8b1YmbLaTcXY3ih1nHJbtRn+EVa8e81a4c4Io67NvrgvUm
         L2w0u0dzrsp7pLd2YPXgqqPTAZJawCOipBZ0IpWSDs2kc7Ej2OjmlgB6RQ9q0uuubmeP
         +tUcd609kc1dPg2n/ANocNyjqd3Ih8A0144/Jc2oJqDD5KGClenuDWmewTxidILZ99Cz
         BEeqKfl+6AWNSY35UclCQ8pQr/WPQv5tLcFwLiJzgDandx3PnYuOIVv4+Vz/Od9dlveu
         cnbg==
X-Forwarded-Encrypted: i=1; AFNElJ9kK5LTLUNy9KIpEC644wdUI1GcZt7TemAKzxZGw1AogD9HqxrXs0HErf6CUN62/goKxfm4sSU=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzh12B1tWOwV+ddFNMqwUiWhNHHdR8/cfR5azWreOt+kqLkmSx5
	ZrJe3sETk+g8Ju5L21X9/+Lf0RKMhdY9qfayytGGUvNu/f3+WT8PCkHzTm97NFo1WHamJQFVQCw
	h+fCsrY9cLlqoui0XFC/J1A==
X-Received: from wrsx14.prod.google.com ([2002:adf:ffce:0:b0:44f:1ecc:c03f])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:601:b0:45e:7418:a3f2 with SMTP id ffacd0b85a97d-45ea38ea8fdmr2814379f8f.26.1779351184592;
 Thu, 21 May 2026 01:13:04 -0700 (PDT)
Date: Thu, 21 May 2026 09:12:48 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.54.0.746.g67dd491aae-goog
Message-ID: <20260521081250.655226-1-vdonnefort@google.com>
Subject: [PATCH 0/2] Fix __pkvm_init_vm error path
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kernel-team@android.com, qperret@google.com, tabba@google.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Sashiko reported a potential refcount leak in the unlikely case where
insert_vm_table_entry fails.

While at it, I have added a fail-safe to __pkvm_hyp_donate_host to ensure this
function doesn't allow leaking refcounted pages.

Vincent Donnefort (2):
  KVM: arm64: Fix __pkvm_init_vm error path
  KVM: arm64: Add fail-safe for refcounted pages in
    __pkvm_hyp_donate_host

 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  1 +
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 33 ++++++++++++++-----
 arch/arm64/kvm/hyp/nvhe/pkvm.c                |  4 ++-
 3 files changed, 29 insertions(+), 9 deletions(-)


base-commit: 5200f5f493f79f14bbdc349e402a40dfb32f23c8
-- 
2.54.0.746.g67dd491aae-goog

