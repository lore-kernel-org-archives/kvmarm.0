Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71B06283FEE
	for <kvmarm@lists.linux.dev>; Wed, 12 Nov 2025 09:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762939256; cv=none; b=eYRVSJRCKapJOWX8XGOFsLn2tTLAqclqhWcKYEPmpo9kjd3Dp6wECz1gdITiah7M3kyUlwS0iznywFD9lI6dN0RynEJfRmTfe351xiroobM4y8fnviMNWEjt8Ip5yzisyL9KjiyiVuyX+ueXekE8xX1RzdYWNm5CHqUaqum7RBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762939256; c=relaxed/simple;
	bh=V/TCtJ7VuR8VnLAxueK54DstYUU0u6j0AkE9ZHM5+C0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mZwei3N+4JbbrsPXq2imGWgOxayGZGSQ87LkMb6dg/2P69axRzGCOX5PluUreux8eJM6DPUBAjZyWI3DazzuDms3fvlbSERqd/esvBoZfiu2XkNb97Ri9AXsqYMGKp8YZO/9JVQRt8eQ1Z/ltCSra1EO5RLQzcv9/oSltLVIXPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AHMrq3cC; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AHMrq3cC"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-477171bbf51so3292665e9.3
        for <kvmarm@lists.linux.dev>; Wed, 12 Nov 2025 01:20:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762939253; x=1763544053; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KWYzkbp7pgBrTyt1NisY6LsxXizq6AqdKv5W+aeRvmM=;
        b=AHMrq3cC46AGFzm+35uFUQRw2kIhI+8sx+LEQ8eDldTBXpkbZew6l4UYGPmYLQV5Ha
         noXeeJKST0L0E7pxeRlbFcWbXyhF5dOB8E/K6YPp2M2BKZUt3EWyQoVuh8QW9k5d8K2C
         FA9UQKEjrRleN68zBLN+tAe2LXoC0Tz6w6NZgNhegGPQDAvD8XusBLgEizH2lKFUOOjJ
         8ESAuw9jNnoYhlGs3mfSs4KEpEsfNZyGtnjVBswlznFTE3+n/Nkw3IhHmh1Wx+gy3LOc
         g9grXDUJZwduErMg/YjA6zOkmWoRv1WC7PHrk20D7sht0MUvkzAEsywJ9uJ9n0z0Blu3
         XEhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762939253; x=1763544053;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KWYzkbp7pgBrTyt1NisY6LsxXizq6AqdKv5W+aeRvmM=;
        b=AeYCQPPy/FYp+/lEpVt0bWWF95u/cZN9A+kFUOt3I1nvsOr9aJeODDrxNfYt5RwJLv
         RRbTNP37QAOAdCef/2+EPCarwAtdGmo+vYjlD3/GIfF0au4a1qxD/BNwYeezvx5Hok+9
         814xpqBfK0d9m2omrSyxkkhtCzf9tSxHCthe0KTMwhC9iTHwGGEX4cFk19s9z3+huMIh
         KQY3DXauctffFnl5gI9+lnDvYN9hNK4zCw9QzowL3l7YQ+qrGzleTHR+U44tAqh49d/s
         C9JaLk0vqWL3FFDBHlEmqJBXJJLT4ZeKfQqmCGGkLc52yhoTML3TtDlo/yvaPn5/0ySh
         e1wQ==
X-Gm-Message-State: AOJu0YxP+PgAa6i7vowfqGkP6rDaiVGKqkAzmf5OZz+6OO1WBzGvgVU0
	/2htGVoRnsGCP5QoWPJl7uyFRnjMQGNM3s0DOYctmWI7wsTEVfUsuZ6um0dLGLtfFUkKXfPQNW1
	yyfmYMNKMf9FHBPR+Upckm/OuLH9Cr9HUtQma1lK163aPrOfreteOOeD6CbQI2AvN8/nmrCkdi0
	1hnJ/F8E255SYHTeuyl9VjKqhCUWjJjJ4=
X-Google-Smtp-Source: AGHT+IGUxVjjdxFwwNK4gZXP4qgE13aKlaUArWEuRF3RKto04rT8yPc6uk6hvts3WN96BEEYzipP0OdKrw==
X-Received: from wmjl26.prod.google.com ([2002:a7b:c35a:0:b0:46e:37d6:c1a6])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:354d:b0:477:7d94:5d28
 with SMTP id 5b1f17b1804b1-47787061cfcmr17563335e9.7.1762939252639; Wed, 12
 Nov 2025 01:20:52 -0800 (PST)
Date: Wed, 12 Nov 2025 09:20:44 +0000
In-Reply-To: <20251112092051.1376245-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251112092051.1376245-1-tabba@google.com>
X-Mailer: git-send-email 2.51.2.1041.gc1ab5b90ca-goog
Message-ID: <20251112092051.1376245-2-tabba@google.com>
Subject: [PATCH v4 1/8] KVM: arm64: Fix Trace Buffer trapping for protected VMs
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, will@kernel.org, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, vladimir.murzin@arm.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

For protected VMs in pKVM, the hypervisor should trap accesses to trace
buffer system registers if Trace Buffer isn't supported by the VM.
However, the current code only traps if Trace Buffer External Mode isn't
supported.

Fix this by checking for FEAT_TRBE (Trace Buffer) rather than
FEAT_TRBE_EXT.

Fixes: 9d5261269098 ("KVM: arm64: Trap external trace for protected VMs")
Reported-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/pkvm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 43bde061b65d..8d06a246dfd1 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -117,7 +117,7 @@ static void pvm_init_traps_mdcr(struct kvm_vcpu *vcpu)
 	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, TraceFilt, IMP))
 		val |= MDCR_EL2_TTRF;
 
-	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, ExtTrcBuff, IMP))
+	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, TraceBuffer, IMP))
 		val |= MDCR_EL2_E2TB_MASK;
 
 	/* Trap Debug Communications Channel registers */
-- 
2.51.2.1041.gc1ab5b90ca-goog

