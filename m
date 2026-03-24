Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC1B93FE37A
	for <kvmarm@lists.linux.dev>; Tue, 24 Mar 2026 13:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774360654; cv=none; b=giPEndhZyN4P5iqXNHURH2r2ivtO+SW1Fan5XArAhfMj5Wrv+MbHF4IbmFCxz8aMh6cb0m6xGlrpl9pPR8TaOBDZMEcT6j1Mz8zpoY9YcMZ9VUH6KKtptgt2o7RvhoM/Uz6HPjAaVK/ZQIDEtEuU4omIWo9mHRsJXXDOj253YLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774360654; c=relaxed/simple;
	bh=zGEeROof9gA0W9ZhmvfGBhkwy5T1SiUSisxKNgVng0M=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=e4w+FnW7KMyqykK9AcKEX6OPwbe0Mp08HP4jUAaHvD1tFkPmyCmdgQmK25Rqc2hvv8SRC/S30CQ/ApCxPtu7IgaZUBul+UOH1MpjDkYaSjlkAM4c1XHGWcEBEF6bkshPBM7pWkARoc236XYFwmnN4BKkz2kLAQzWN5bU+Vt2V/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KXsf5c9N; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KXsf5c9N"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-486fcc05b20so24893035e9.3
        for <kvmarm@lists.linux.dev>; Tue, 24 Mar 2026 06:57:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774360651; x=1774965451; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=as56aPNtWm44s9wE7zPwXim0QPC6mmk0ed7R9T8xyHw=;
        b=KXsf5c9NTQZ3EJpBAq3HXpO5nwW1uLQHkqXwXeQolpcZiWkvLBZv3C+Ui5Qc0d1rTg
         yEhTzX0llgzoNDIjQflxZvuW6VHM/KX+VJFM59dztVVCknhiHMES5CLKv1XbHX5N/4la
         8SFWwDnXpVsu/kYpzltoqDEU0WTeZxsYBOKV28PjoTTUXBVh9daW/ETkkC/kgDQ9OHkN
         E4WSnwzfEUYlwF+wkhr7I7J/IO5JA/eExhGItjbgYK3flA3XVYcXsVQzCNuUkJPNGyxN
         tQshOVpz1R89zzcOYSRPj21UAHxVJB9ifV2cslJnL7lK7GBTwWqAQrYtRy0XF/Gt5T/7
         AHXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774360651; x=1774965451;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=as56aPNtWm44s9wE7zPwXim0QPC6mmk0ed7R9T8xyHw=;
        b=qd9InJWBXVrqypDmu62Z9MrNw3XfSW0n/ajyxP4m5w5bLYTXg51S3fGAxBfWeF5uUT
         5sI+8Q0NdtSnw4d4alVYte46hJC11P6i5jl3tsvZvzGtEScUJ0/n2Nt6G8mh6F48dYmm
         VoxSwXmaw7bNtIMN8iuejkA0dp4TpLiOQUADC3Ch9sGOyoWD86aw5JSrArEAktRig+VD
         k5zCOk2b9W4BYrXXTIH8n0udwLxYr4ZRs5S1z/l/X/B4HvAxWYPL7RxWcR8rdyKwfCf9
         yY8Bm37lSPORY/u8ZZimHIbP8i2JWUkjlGvAYBMLDdpHhU+/QNcDaezbYE7uniMauveD
         9Zmw==
X-Gm-Message-State: AOJu0YyodDY44AZ7Up8dZf3wPaJE4+Uz0IVfp9RKLfKD7pabVsb0nsM3
	vMXvVZxubkZjVqkU3ljABSBkTTdG9Y82EU0oBr72Zue3+9yvCNwOCSFo0Mz5uNAXM6Kg8/nArB8
	yI6+opi4Spn6whafgMdyTONXYUV1qC81UU3AEF5Im976tW1XWaf2ICScDYKctIYGGmhItH2ZrAR
	FOu8k5FkVY5Ror4Yw5IU6fTPEbfFRHyrOEo4ZMH4eunb6BOHPKnvw/HonjeAWOVIUxmNjD
X-Received: from wmbjx8.prod.google.com ([2002:a05:600c:5788:b0:485:3ddc:f26b])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:33a3:b0:486:ffa3:584 with SMTP id 5b1f17b1804b1-486ffa30b40mr104955515e9.15.1774360651034;
 Tue, 24 Mar 2026 06:57:31 -0700 (PDT)
Date: Tue, 24 Mar 2026 13:57:28 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.983.g0bb29b3bc5-goog
Message-ID: <20260324135728.3532400-1-sebastianene@google.com>
Subject: [PATCH] KVM: arm64: Inject UNDEF when host is executing an smc with
 imm16 != 0
From: Sebastian Ene <sebastianene@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, android-kvm@google.com
Cc: catalin.marinas@arm.com, joey.gouly@arm.com, mark.rutland@arm.com, 
	maz@kernel.org, oupton@kernel.org, sebastianene@google.com, 
	suzuki.poulose@arm.com, tabba@google.com, vdonnefort@google.com, 
	will@kernel.org, yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"

The ARM Service Calling Convention (SMCCC) specifies that the function
identifier and parameters should be passed in registers, leaving the
16-bit immediate field of the SMC instruction un-handled.
Currently, our pKVM handler ignores the immediate value, which could lead
to non-compliant software relying on implementation-defined behavior.
Enforce the host kernel running under pKVM to use an immediate value
of 0 by decoding the ISS from the ESR_EL2 and inject an undefined
instruction exception back to the caller.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index e7790097db93..ff6a90a4a4c7 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -756,13 +756,18 @@ static bool handle_host_mte(u64 esr)
 void handle_trap(struct kvm_cpu_context *host_ctxt)
 {
 	u64 esr = read_sysreg_el2(SYS_ESR);
+	u16 imm16;
 
 	switch (ESR_ELx_EC(esr)) {
 	case ESR_ELx_EC_HVC64:
 		handle_host_hcall(host_ctxt);
 		break;
 	case ESR_ELx_EC_SMC64:
-		handle_host_smc(host_ctxt);
+		imm16 = esr & U16_MAX;
+		if (!imm16)
+			handle_host_smc(host_ctxt);
+		else
+			inject_undef64();
 		break;
 	case ESR_ELx_EC_IABT_LOW:
 	case ESR_ELx_EC_DABT_LOW:
-- 
2.53.0.983.g0bb29b3bc5-goog

