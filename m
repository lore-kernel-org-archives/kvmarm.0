Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 492B7493D3B
	for <kvmarm@lists.linux.dev>; Thu,  8 Oct 2026 10:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791456168; cv=none; b=skW+NUxaSMJHrJ8L0k4FvOw0OB8HdYH58gGpjQc2Zl3sjOAhZNZb1/3kSa+xh2bfOasCop58RxfONaY0MnZcBWsQjsih4kz6ezszkg7D0QFPAJbKHwjvf2R09QxxmM5FcrYbTHofuQcwRkEx3+jIuRNhLrQ8JMpXCJRmk7VgE2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791456168; c=relaxed/simple;
	bh=jamhyh65AfYNUeCVAcEb/Lf0kPCloATW31KC5KohUD8=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=HVScFhUEo4t3qkmSsJjFSQhS1DIK40CdecD7kH5w2XQmEAtCzIEI5jzkfU0nrXdDCqjfz70Kni2cjL3lEhgwkdOLwYpMsbipTt29E+1bpi6msY8MMSi9KLelGdF82oEYZEZRycdOxSexqpHSCZxsRagFVH2yZwn49pnfb/fA9Cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=r6oRxqDe; arc=none smtp.client-ip=209.85.128.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="r6oRxqDe"
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4a0761224e1so47517375e9.0
        for <kvmarm@lists.linux.dev>; Thu, 08 Oct 2026 03:42:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791456165; x=1792060965; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=yw+/KyODhQGlE9PVW/UB15lvPyjHuqtv5OR4/2DWzv4=;
        b=r6oRxqDeU6l5fWDqaVqlFq2gaJ2SIFlStapvpzEwevbxExD30ijymBW6wPFncCBRk1
         MXP08eQxHCYQ29pHZlYfaOFuJ3aW0iuUmhQpGKt47+o3C8rMsDnjEwimQQYe2Nic+eY9
         CKrXapnjZSY9wnZsCCvZnBHgofs+6qLLZqaiAv6B1lxmPEe/pm6Ady9ja7OliX6MnW+o
         HQh0zwn2Y/P4oIOuS0DmHysOHFvRPjWsTCTU9oRTpSAL3bofHFx+BB2XxSQdq7DFMget
         1oq6HpIApe4p94kEEJ3sa3ij763R0QfOQfOcy1b2ndfTApMQ/PjH3Afo4zVrzuYPG4vY
         dPAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791456165; x=1792060965;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yw+/KyODhQGlE9PVW/UB15lvPyjHuqtv5OR4/2DWzv4=;
        b=UwUrdtge+yYVvyRicl1DkkQxeo+6gqfMccp9HwLLf0idmiNxf/XwDZKIOgzV55XEpY
         KjeyZaAw9vpvB+M2c14by8BBwM7RR3Di8CxZDFtRUUAEmzyjZUbDunltCVg4Q1cnIHZp
         DUYKa+OJnh8F40TWWbaNca8PJA88Z8S074bFec3sxkS9JT41AJaZ04+KSaD/3TJNC3jr
         7n0y7uFCLEv9HF+GQEgPLMD0Im8TTVtbwmvBhUFNczrlhg93zkuk3fNGIO1OZ2GbgP7h
         V5K6gu0GnpU8lLxEyA8zVdr7LZMUT4KHQnzpEYmdkUNp6IPTzPhg93LdORk7GtNPvArb
         noDQ==
X-Forwarded-Encrypted: i=1; AKwUvBxqXV7cazyEbkLjJB0mFGXTOMbaZUNcYkOdoules3gHoqzQWkQk7iFBz39rwM7c4CA8EBzlilU=@lists.linux.dev
X-Gm-Message-State: AFuF++k5krDv7I2jD80cr/GhiWDxJbjXhARV2jvkdIgPaP299N2g4OBP
	/Z8fUlgdOZB8AZgDr209h1uwID6/VdyCo7GQ4IOu7sDy7v1f4UkuombQ1RosKdWnqR3jq3qO3et
	vP+XL7i8eQrKmTwMYQ7eOZA==
X-Received: from wmpd9.prod.google.com ([2002:a05:600c:4c09:b0:49f:e58b:90d5])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:46c4:b0:4a0:eae0:769a with SMTP id 5b1f17b1804b1-4a180660fc7mr81234745e9.28.1791456165231;
 Thu, 08 Oct 2026 03:42:45 -0700 (PDT)
Date: Thu,  8 Oct 2026 11:42:10 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.360.g66cac248cb-goog
Message-ID: <20261008104212.3134550-1-vdonnefort@google.com>
Subject: [PATCH v1 0/2] KVM: arm64: Fixes for hyp_trace
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, qperret@google.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Here's a couple of fixes for hyp_trace:

The first one fixes a potential 64 bits overflow in the hypervisor trace
clock.

The second may prevent tracing loading for certain buffer_size_kb
configuration. This one depends on the allocator, so I have based the
series on kvmarm/next.

Vincent Donnefort (2):
  KVM: arm64: Prevent 64-bit overflow when computing hyp clock rate
  KVM: arm64: Fix bpages backing allocation size in hyp_trace

 arch/arm64/kvm/hyp_trace.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)


base-commit: 8ed245078003cc5f61ca4c8f9920374086f2515c
-- 
2.56.0.360.g66cac248cb-goog

