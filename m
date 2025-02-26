Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DFF71E1E01
	for <kvmarm@lists.linux.dev>; Wed, 26 Feb 2025 21:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740606926; cv=none; b=DFOj31v2ROCBjvXRx6hI+6vcch1fwLAbQ7XCe0xYgFeJbjrNKze8HuOogeQ+vuO6cJOm84Cqo9uAjc7Zunp+pf74y7oraPxox7l0fP++JkmrV1VTXS1HBeiNEHIn2sf0DiAUyhZXRojbBPoGfj8IGZcFJPcSF82e4VjIRACqBvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740606926; c=relaxed/simple;
	bh=r0XmNteGt4vJ15q9L6ZRVhHnN8azCu0DEQ8uQYRjKwA=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=Wm/b9IhSVq17UEOyluRrfyQDFl7Tvffae5x07kNVOmVazAQjW4jJkzAiNwo+zUdiL+IZw/teGMky3fMS7xIfHAVmP56I7Onwo0vPujIgyAjS+/IDzCXKVxGphzus9dagJO0lMOprW8fYoO8LLq6RVtKu4cdlxRr60f8RJmwGnPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fxGXW2Cy; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fxGXW2Cy"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4399c5ba9e4so1209235e9.3
        for <kvmarm@lists.linux.dev>; Wed, 26 Feb 2025 13:55:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740606923; x=1741211723; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=7IvPw5iGc/k53b4/rPiCRpRIXAnRcZkrel3cZcM0Zew=;
        b=fxGXW2Cy+1bx+aN2v6bvZQ7F3lt30gso/HECZWwIYGMWRNoGNPS3xDaTcqekkQIqC8
         oYkqgqA9t094Yx01rIbT8S9T1u0gIt3ASj9qOgfa+eiZkWK9mg6PIqc3y7EbYIxoxhp+
         E8VJFgevzywmdkGKxvQ67cROlLJhYpscDxPu3TNlEcJk6u6uGJWt88P09YSvpD3Oj02/
         cerWAnrlAV3AGNl+LlNxLt0Y79ewE3DR/DTFgjbDFSsgzJSlGftfFeuXWo2fcjTukhrq
         qGVyCaMfeyeiiiwJp07VDWRZtV2YaktntJM1QgE8wgsgxWCcAc5jFHf5kDvNr6+WyUfH
         fiyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740606923; x=1741211723;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7IvPw5iGc/k53b4/rPiCRpRIXAnRcZkrel3cZcM0Zew=;
        b=nP75KuLmDBcJq1gwvzG/E47z8X2seF9xBW+t0IIpyn/lblvQ6Pb4wgUi5u1pvL8IRz
         vNDS7RMBlAIsK8wR2hY5ftZ6irRo/F9v45eCo+ErSqMDUNaY2xK7SE7g9Fcq8P/guuMJ
         2V/Z9JUfzss0ur3QbjYyd8DSp/8jlJCt17p9vKb9U6SjuTKTr0EacrizMzzLkUx9qpzP
         JMelc9RMAiJdxFCErGvSbRrGa6ozqY6+Xq9fgik+tLfA7MWwKuoezRfjiu354j2hYNs0
         zuXbwt5IQhCUq3QMQ8eLcVPOWsW1YHFktxffSl8HO6UZiRp4I3SFhsu/BQLz9NgeYeAG
         aixg==
X-Gm-Message-State: AOJu0Yz+55nVquzP9qIhUHoRBnXDDRnnW8xXUn28P2Voqn278+XjGm1J
	6F8qwaqYUh1jqGzvVHRWzPr5jO/M7sdAjNKDJukwGRK0gkNggzfsnSK9NPXB9rzvk6abhs0DEWP
	jxa0ioR2IiKqSaPs13HOw5osGA1QgStRXbvDZfZ6/GcOroUVL5N5ylPTacRADXkUdLa7LRhP6ZQ
	UtqmRvzPrRihskrice+KFIY9XyTnM=
X-Google-Smtp-Source: AGHT+IGXlbqPAwAa2eKU5tILxiLuRG281n0weT0i//QObTL7/xbiqPS0o5r4y1I8zjQNvEu6szJcKMd1wA==
X-Received: from wmbg8.prod.google.com ([2002:a05:600c:a408:b0:439:88bc:d27d])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a5d:588b:0:b0:38c:5dcb:312e
 with SMTP id ffacd0b85a97d-390cc3aff06mr7754343f8f.0.1740606922779; Wed, 26
 Feb 2025 13:55:22 -0800 (PST)
Date: Wed, 26 Feb 2025 21:55:16 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250226215520.1759218-1-tabba@google.com>
Subject: [PATCH v2 0/4] KVM: arm64: Fix initializing HCRX_EL2 and other traps
 in pKVM
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, mark.rutland@arm.com, 
	will@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, broonie@kernel.org, 
	qperret@google.com, vdonnefort@google.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Changes since v1 [*]:
- Factor out setting HCRX_EL2 traps into a separate function and
share logic between protected and non-protected modes
- Rebase on Linux 6.14-rc4

For context, please refer to v1 [*].

Cheers,
/fuad

[*] https://lore.kernel.org/all/20250214150258.464798-1-tabba@google.com/

Fuad Tabba (4):
  KVM: arm64: Factor out setting HCRX_EL2 traps into separate function
  KVM: arm64: Initialize HCRX_EL2 traps in pKVM
  KVM: arm64: Factor out pKVM hyp vcpu creation to separate function
  KVM: arm64: Create each pKVM hyp vcpu after its corresponding host
    vcpu

 arch/arm64/include/asm/kvm_emulate.h   | 24 +++++++++
 arch/arm64/include/asm/kvm_host.h      |  2 +
 arch/arm64/include/asm/kvm_pkvm.h      |  1 +
 arch/arm64/kvm/arm.c                   |  4 ++
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h |  6 ---
 arch/arm64/kvm/hyp/nvhe/pkvm.c         | 62 ++++++++++++++---------
 arch/arm64/kvm/pkvm.c                  | 70 +++++++++++++-------------
 arch/arm64/kvm/sys_regs.c              | 20 +-------
 8 files changed, 104 insertions(+), 85 deletions(-)


base-commit: d082ecbc71e9e0bf49883ee4afd435a77a5101b6
-- 
2.48.1.711.g2feabab25a-goog

