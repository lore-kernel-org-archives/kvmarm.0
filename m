Received: from mail-dl1-f73.google.com (mail-dl1-f73.google.com [74.125.82.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D830F35E527
	for <kvmarm@lists.linux.dev>; Tue, 13 Jan 2026 19:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768333457; cv=none; b=tSXrYEPv5Zz3W3tkrjH2hmXjqKXMizaiBLrKYDiT7TvZzbxtnkaV4iBfCVdpPA1nUL1iAMDntZ9ZYJU90E/A2cAchfKf4Q016hkvfwCcRY5D5N4X0B+LmEPqXpoNpqNVg8UgoZinBjq/WCxTvk034T55SaZigZmLe0EVvgvO9Pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768333457; c=relaxed/simple;
	bh=n24GXqBwqppxIfs2NYlKXmJaWJIje+KKZFhh6y/IuS8=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=IsY9KErSoKj3u81nTt7xGgZnRpE4kv6bfWzDzzylqSEWaajg6xid+1jkMyPAcrghLkKiP8ziNN8vjlns3vnWKL02PPwKuJzcBWG+K+XcdWJ+rakcMr8CjyXVIyYdPoZuQEhFoakQKj5QQBhPPG0t8EygfilgzqPOeuFvwSqwKsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--pekangas.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BLdrxt49; arc=none smtp.client-ip=74.125.82.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--pekangas.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BLdrxt49"
Received: by mail-dl1-f73.google.com with SMTP id a92af1059eb24-12175e560b3so10097487c88.0
        for <kvmarm@lists.linux.dev>; Tue, 13 Jan 2026 11:44:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768333455; x=1768938255; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=RIhN6dRLokM9eZt/p8tgQxPQl4snplBSSr5i8hEn3SY=;
        b=BLdrxt499NAkxYmzSIOfxcI9vOcVLZ1+Ro3W9KOrAXcpKuA3fV3d7Vq2YDRoriXJ/q
         5956V0P8IJpJ9wn1wmOjDllEpgzwkp+Bw/VVFZwRsNqxDv3K8Ru35OrtE0K1argMioUy
         kqZlwFEi+kvtI1xkWhq7pSbhv79uuZIvhCn9Lbw7NEyn47gEZO0c5pIOgAapH66MXjXd
         H45d7YP+xo7pK4yGBksHfKaDZzInO79QFSCuqOiP8suhyjHCsCCR/lWqDNvs9GQaHyWZ
         bTeux0bR5RCBfqpOQeG/3yYxXnDQ0p4HGGLXVDtTCPXnUqPc1sI1d/oomkyDd/WKtM4F
         SvHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768333455; x=1768938255;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RIhN6dRLokM9eZt/p8tgQxPQl4snplBSSr5i8hEn3SY=;
        b=BnWdi3/vV/qtG8KFUzrUGIDDQR4jL9WsicWTcO6TyIqYRWk13JQByIOsryvNqeQreQ
         MRXwNkenl31PytuN8K8vTGwejXPzozWjyt8OwuaOcl8kOFjeuuxoVHaUxcVLyF4TM7cT
         qybcOH1vK+q3uaZbiLMfOkSY9JfdIv1oYTYS6iMnX8kf0Tc/FSdxuC65ib2aGOLfMcSE
         0l7aLSGQDyS/r4wTX4akEXsHGS8BeKbcBMdTEsrDahSj3rxpAfKZ5aIDSh1FXjfZfZ2h
         1MQYvhlJ/MlbSp1ou/v1U7fIPNPaLOC5O1Hs6w+mHxNMd1691zY3zRTwJyvjkPeu1jGY
         DaJg==
X-Gm-Message-State: AOJu0Yy1d5V3NRb5K22SKR3i7n6hp4k6ozDRb4UGv5bnT0fz583rxlJn
	eC3iB2hJrkwFdJYnqHvvgpwgivI6BpOhWoEA6KwIzdnJQ6UrGGLcuIJN5VKvwFnc0oiWjZjSjrV
	od4wfzy3/0FqRgukSj6fnFqRqnDWdKeLMkFNCYnLkUutcRfmCMV7lUS2QuT0PSO7SwaKp/0l463
	EGwfu0k73AN+131cSmpBIkwHua+Spp8ex3OV4hSu6WfQh/SdQ=
X-Received: from dlbrp10.prod.google.com ([2002:a05:7022:160a:b0:119:49ca:6b8b])
 (user=pekangas job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7022:7f14:b0:11b:9386:8256 with SMTP id a92af1059eb24-12336a9084emr94672c88.43.1768333454899;
 Tue, 13 Jan 2026 11:44:14 -0800 (PST)
Date: Tue, 13 Jan 2026 19:44:08 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260113194409.2970324-1-pekangas@google.com>
Subject: [PATCH v2 0/1] KVM: arm64: Calculate hyp VA size only once
From: Petteri Kangaslampi <pekangas@google.com>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Vincent Donnefort <vdonnefort@google.com>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Petteri Kangaslampi <pekangas@google.com>
Content-Type: text/plain; charset="UTF-8"

All,

Here's a reworked fix to keep VA size calculations consistent between
the MMU and layout initialization code paths.

Previously, if the kernel was configured with a VA size of less than
48 bits (like happens in our environment), the assumptions used to
calculate hyp_physvirt_offset in kvm_compute_layout() and the code
that determines the VA size used in the rest of the system (calculated
in kvm_mmu_init()) would get out of sync. This could eventually result
in mapping failures.

The patch here is against 6.19-rc4 and tested in default, nVHE, and pKVM
configurations thanks to help from Vincent Donnefort. Detailed
knowledge of the address map remains somewhat distributed inside the
codebase, but at least everything now uses the same VA size, and
further refactoring is probably best done if/when Will's pKVM changes
have been merged.

Petteri Kangaslampi (1):
  KVM: arm64: Calculate hyp VA size only once

 arch/arm64/include/asm/kvm_mmu.h |  3 ++-
 arch/arm64/kvm/arm.c             |  4 ++--
 arch/arm64/kvm/mmu.c             | 28 ++++-----------------------
 arch/arm64/kvm/va_layout.c       | 33 +++++++++++++++++++++++++++-----
 4 files changed, 36 insertions(+), 32 deletions(-)

-- 
2.52.0.457.g6b5491de43-goog

