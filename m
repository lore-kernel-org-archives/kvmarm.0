Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C51F0357D08
	for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 14:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781274179; cv=none; b=cmwGeQ3ZGwAzzKMTO+6o7OhB5pIlLh7rHUc0P4w08p+qeHYQYsweLwHniR02zjBoS7JC2b7Es6tgrTne45pOxGYpkd7PxzXRCXFQXVZrbMCl9PIoN3+FJs/8lI0oGH3s1iQXcZppFTlJwoS8eefRkcjDi6SB32njaUKFsRe57Dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781274179; c=relaxed/simple;
	bh=MOIrogE+Jj5NIqdwNtHyfNX0MGXz5oGEZmw53liDats=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kCLj4MXbAT4wfJUvShMQsHF+xRlZmJ1D8OL1nLbZsYYjW7giBvNClm6CH+6kX/LhhUDYekLOLPnFOoDFhKLOleMDGFjGIiZyqOu9mIexecg9j5aX6+PSAp+WFBCDMHjfihHipnwHQ5Cq44+tonBtwu8/tp2FD6shz/1r0yKpzeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ParBpKQ1; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ParBpKQ1"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-490b3f53c81so4610995e9.3
        for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 07:22:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781274176; x=1781878976; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=W+oMnuoNcP2dDCb/ggwjh0luXU4L3Te1sVGigfxt6Ig=;
        b=ParBpKQ1o5DIqOG5+7m89IeHkwD5xKDl7YAl4vTT5++hIMhIfpQEJmoufSejpFhJ/G
         d3kq5ecVSmp41+tuEdd6Zw/XztPQPc9CFGSVpPls+AUm/OHkuyKUC0u7QYggQvBq83uA
         ZnnOCfgYSgal27jgDIEJ5ygJPo9p3XGyzDqkV3KJjONK1IE/X54du/bEgEyNYZ8UxW0m
         Go11w8yCEq2zfaor2kiGNkT+E6dPpnnhwY1HOVnM+aW7MFxFN+2vIzjCVo5wqhH56EiN
         C4MCLVKNOb6OQwdst6ZIjsLuwziYgIe8RUKGX8Y1ikf7gG58MTsqqPdPVQJKHLsi4mJT
         OJow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781274176; x=1781878976;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=W+oMnuoNcP2dDCb/ggwjh0luXU4L3Te1sVGigfxt6Ig=;
        b=SAogQqq/fPKQVvJTdSFVy3daw8VkT4rBQ/JWVb6yodPDmWU0PpxvKiRJeVPnbqVXd1
         emaZnnDhpB1zwp+6fMkijoDF0GnhCvpAaiIcr10aG7TNijgk77y9OfrqBj8QJJgSn6v3
         4zMKZhOn/Y1d9qo+0lMQvXpvqp3tH8A/sKwh+gcQ/c0Auzg5GLb9TGGWks4PkVHq1lA4
         B3GXLaxmvRzeP1xn0XvhcVeBV4RcGlEZuGi3sCbuJSnchqw4pz/CRLARWxacXw/IShHl
         v8PfxSHKWCWSWwo30TNW2Oi82IEvekVQs/AAWqt7e5NauMx/MPP2sp3jgSshN6RrgJnj
         HtYA==
X-Forwarded-Encrypted: i=1; AFNElJ8Wmk+Gx6tj9bxrdpDyYE2Ha8cKmYEB7w2f+SDWeAqCHsvoMBsa/tFGTorphNdHRLaVTe88ltc=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzaq16hc+0SuYazL6pncmLBx34r4kWXPZy7CK8xiiK1T8jUkZ4D
	VUm0BfZgGZDo8WO4cTocWtpsCGFxO7vh2aQ338FrN/2GJERI4fg9DlmWJ5P9Z2AtaCnIc27mpKg
	JeYpf46y20Ane2xdEk15zrA==
X-Received: from wmmr8.prod.google.com ([2002:a05:600c:4248:b0:490:bd6f:3b92])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3b15:b0:490:b189:212d with SMTP id 5b1f17b1804b1-490ec522d44mr42776115e9.33.1781274175762;
 Fri, 12 Jun 2026 07:22:55 -0700 (PDT)
Date: Fri, 12 Jun 2026 15:22:43 +0100
In-Reply-To: <20260612142245.1015744-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260612142245.1015744-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.54.0.1136.gdb2ca164c4-goog
Message-ID: <20260612142245.1015744-3-vdonnefort@google.com>
Subject: [PATCH v1 2/4] KVM: arm64: Move kvm_define_hypevents.h to arch/arm64/kvm/
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, rostedt@goodmis.org
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kernel-team@android.com, tabba@google.com, qerret@google.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

kvm_define_hypevents.h is used to define the kernel-side structures for
hypervisor events. It doesn't need to be used anywhere else than in
hyp_trace.c.

Move it to arch/arm64/kvm/

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/include/asm/kvm_define_hypevents.h b/arch/arm64/kvm/define_hypevents.h
similarity index 100%
rename from arch/arm64/include/asm/kvm_define_hypevents.h
rename to arch/arm64/kvm/define_hypevents.h
diff --git a/arch/arm64/kvm/hyp_trace.c b/arch/arm64/kvm/hyp_trace.c
index c4b3ee552131..821bc93ecdd1 100644
--- a/arch/arm64/kvm/hyp_trace.c
+++ b/arch/arm64/kvm/hyp_trace.c
@@ -391,7 +391,7 @@ static struct trace_remote_callbacks trace_remote_callbacks = {
 
 static const char *__hyp_enter_exit_reason_str(u8 reason);
 
-#include <asm/kvm_define_hypevents.h>
+#include "define_hypevents.h"
 
 static const char *__hyp_enter_exit_reason_str(u8 reason)
 {
-- 
2.54.0.1136.gdb2ca164c4-goog

