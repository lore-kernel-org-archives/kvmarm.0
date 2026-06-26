Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F6983C2B8D
	for <kvmarm@lists.linux.dev>; Fri, 26 Jun 2026 21:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782509747; cv=none; b=qa2JeGQ7h4dOZb94wx+fwbHRISu0A3+NS9iUiL1+zmlmMYKVy2O7v1zFMWxdaNRNfcC3Mmbtdb6bfiEMGJjyGWlIvg4csqalxEtAysRtRQJLRkvQtlL2b05QQX9CJW6JbwFDO0g3WvuZlL5/0KhfUMHpXU3INfBFQNL09wa/4Hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782509747; c=relaxed/simple;
	bh=DpuOXkwzCOgbf4lBzoy432Js8GwAiDpEe96hUsDd1ns=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Fx8x/wS8kP7usHWw/tmUwoWd3i5O9lhVPyqLoXGHfUhdvm49V4veNaR3jfgwsj8CesMaZ+vCPY6mkKfmmOsI7zW6VY+CK5n0kPqxNhGS12Rgt4ZwEuQqqiATkA3nuH5KT6tFLK1ZYz5/tgTkpqj7/7uJIXdno7S1iPNmiSMT5nw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PL8bhWB7; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PL8bhWB7"
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-845d3a248f1so264401b3a.0
        for <kvmarm@lists.linux.dev>; Fri, 26 Jun 2026 14:35:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782509744; x=1783114544; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=pWc4GlXVIsd14e/yCg7QaIqalab335GasYtgDQrZMX8=;
        b=PL8bhWB7IByhcYJrT7RM7lRKa9buRhfXJk9S3zhEZFPWw9UXUAIMoC+DD5ADfVsGMO
         WFpM6EQpyTw78U7xE8Y0HX2YwVa3yb06H2263EGi9Wu+RLdh8oq06jj/qg2nxMK5WH0R
         ffQDVNSqpfrT3gi8JCl4ChQonBsOXB3XZnmorbAq9iW5i882B1+xrmN14qGV9yebUBDg
         OZnnjebLqDpGdext8UXY07TzN98D92PSSIWe2BGDhpVVXXdwOKDhVkNHe37YC4WQauFJ
         eK+EmVDkIdNPXPIil/3kpI3Oy712KJ0VgX+dw9fYG8GN+6LgQoqrs0+fgDMULFTSBQsQ
         aZ2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782509744; x=1783114544;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pWc4GlXVIsd14e/yCg7QaIqalab335GasYtgDQrZMX8=;
        b=jUAXw1jlXvyFWtRD4AcFplRtZ7MAF4AiNyfct+vSAEkA47o3FDWHoIdAjFWO/kfJRm
         qeXbTQY3tCkMltypQnCR017iWDPSabSBXTb7kr4jZP6Hp4DZpMBptmgtHGXFnWwuRmDB
         jS+yMl9b4W+g+Ml+xjj9VfcI1iKSDurQYiNeawvnxbl3V+aaXL1THQ6NFgTtnVgD44zN
         lSZCSZCormcfcghNhkb2T0Q4s5BQhFRaj/nc857whKas74mZfp+pS/BkM0CwktuwEHtT
         Poc2xhO8kGPs9cO0xepMR16Q0x/bzOM8KZ+5o8yOkk6SnYe0amtSityq4KFjBz87bcPk
         qG/A==
X-Forwarded-Encrypted: i=1; AHgh+Rr+ALCYKWFfezfbxTcx3c4oWpx/rKMXhI60RBFO6KA915J9mBGNfNIqc3INr6KCTDHwTIRu4qw=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx8DRnCQPecE6aft6eVn9uqO/1TdjNy7HfvXI/L+uP0ScRbCFRK
	PZ4JsaVcV9bbXDQP/ViiTGDfnP72u+9PWxNFrmGq272k7yR41XHirISP8m4U6HtuHB+ZJy0bu1c
	QYZvyiw==
X-Received: from pfbmb6.prod.google.com ([2002:a05:6a00:7606:b0:842:723a:7919])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:189b:b0:83e:f228:b112
 with SMTP id d2e1a72fcca58-845b3b8e2ddmr9010923b3a.34.1782509743991; Fri, 26
 Jun 2026 14:35:43 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Jun 2026 14:35:19 -0700
In-Reply-To: <20260626213534.3866178-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260626213534.3866178-1-seanjc@google.com>
X-Mailer: git-send-email 2.55.0.rc0.799.gd6f94ed593-goog
Message-ID: <20260626213534.3866178-7-seanjc@google.com>
Subject: [PATCH v8 06/20] KVM: selftests: Add helper to generate random u64 in
 range [min,max]
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>, Sean Christopherson <seanjc@google.com>
Cc: Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>, 
	Josh Hilke <jrhilke@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Josh Hilke <jrhilke@google.com>

Introduce kvm_random_u64_in_range(state, min, max). This function
returns a random u64 in the inclusive range of [min, max] using a struct
kvm_random_state.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Josh Hilke <jrhilke@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../testing/selftests/kvm/include/test_util.h  |  3 +++
 tools/testing/selftests/kvm/lib/test_util.c    | 18 ++++++++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/testing/selftests/kvm/include/test_util.h
index 44c0104d60ac..d64c8a228207 100644
--- a/tools/testing/selftests/kvm/include/test_util.h
+++ b/tools/testing/selftests/kvm/include/test_util.h
@@ -134,6 +134,9 @@ static inline u64 kvm_random_u64(struct kvm_random_state *state)
 	return ((u64)kvm_random_u32(state) << 32) | kvm_random_u32(state);
 }
 
+u64 kvm_random_u64_in_range(struct kvm_random_state *state, u64 min,
+			    u64 max);
+
 enum vm_mem_backing_src_type {
 	VM_MEM_SRC_ANONYMOUS,
 	VM_MEM_SRC_ANONYMOUS_THP,
diff --git a/tools/testing/selftests/kvm/lib/test_util.c b/tools/testing/selftests/kvm/lib/test_util.c
index e98ca7ef439c..e208a57f190c 100644
--- a/tools/testing/selftests/kvm/lib/test_util.c
+++ b/tools/testing/selftests/kvm/lib/test_util.c
@@ -42,6 +42,24 @@ u32 kvm_random_u32(struct kvm_random_state *state)
 	return state->seed;
 }
 
+/* Returns a random u64 in the inclusive range [min, max] */
+u64 kvm_random_u64_in_range(struct kvm_random_state *state, u64 min,
+			    u64 max)
+{
+	u64 value;
+	u64 range;
+
+	TEST_ASSERT(min <= max, "PEBKAC, min = 0x%lx, max = 0x%lx", min, max);
+
+	value = kvm_random_u64(state);
+
+	range = max - min;
+	if (range == ULLONG_MAX)
+		return value;
+
+	return min + (value % (range + 1));
+}
+
 /*
  * Parses "[0-9]+[kmgt]?".
  */
-- 
2.55.0.rc0.799.gd6f94ed593-goog

