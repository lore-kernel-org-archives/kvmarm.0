Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43EF63C553B
	for <kvmarm@lists.linux.dev>; Wed, 25 Mar 2026 11:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774438307; cv=none; b=cXKnUtRBhME+12emTfRb6ezzxzlhIXZnEH7DTM716gm1L6CwNvpxhKQZPyhvzHPynig0Wnm/6iBT60PGnSOnWRKNXB+1vgGAKZgsOKcKUzbtENVXPCVEUNcopdMtxVf8zNi7yJ+H8UwqIEYVAasgwQUmdX7HX0RltddE75zmpYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774438307; c=relaxed/simple;
	bh=ngPogGvQ/oHYmBLGmymSGcjEabQ6C2DPBCFrZroAAKU=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=s03OUOZ34eWdAflB9fOkonNmx2ZA0t9AxZjLja2dgcmCS89sYkNCoZhmnrtdGvMeszrbDj5h82Ej5a+P9YIcYIHfvZF9YtIi2+0ukyT9/1EDWsj8/ZjCh8jF4AHXgWwJzUxWTeaPW1T3PofYhmrQhLJlB9nplx3c1LVWCZOA/X0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NwRSXqGj; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NwRSXqGj"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-485c45885e6so65574115e9.0
        for <kvmarm@lists.linux.dev>; Wed, 25 Mar 2026 04:31:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774438303; x=1775043103; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=p84lLdIepUZTxV4B3SNssiaMT7UBerhqgF3wniuKFK8=;
        b=NwRSXqGj38s4op5toIzLSHzJMiSEWLqyQU7X00qsF7dVxG6yoOmljXJpjTwVT9wP7s
         bn50ztKkqnua2Trwpzh4Sfn+YXU3bef9ZYqt7L7KiV3Ko1cICOuAp7WrKNUoSYBx7b4M
         IhhryBmbYbkGDW5HqJhHVlX0S1R+GSS3AGPK5TaCq8aCv2JsLLSsYe0YbpEi8d4VzetX
         BesxkpoD5yG4hGZpZwULZAK8/6ptiIeNi5wRrvNhqasFxRTec4ajyc7GiZbGafBZp5oF
         gAxg0DWD6VMbJmNUlxTphT2JOl1tj+mQOOZs5r4Z1ENp/tR4/vRKdECMu3fyk+dzMXp7
         Th6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774438303; x=1775043103;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=p84lLdIepUZTxV4B3SNssiaMT7UBerhqgF3wniuKFK8=;
        b=PpGboZx0HtM0sYvZ4fN/W5jG4DrTKNQML15AHpQ0PL1abrGy7kmCXbpUMNKu83+shu
         2MsiduQ8B/5/L5zE7bIGQSELCPDBnM0PclUI/qA7X8PJJiYhhrkA4TVAXiXmqe3pxL24
         +NmMdoN1CLmZ/RfhpeQpOt5a3QIDWLcj9VBrgaawzK/nieNJz/n6BArYWgiLm5W+/aQ8
         qRsthMDeDBP9e4NSyfa/HfBbS8ozvumqIVQ51bsGZ8r9/Vli4gZVr22IIdf0Ygh0pT21
         E/9j6tLNbbY8szgXLhYdGzAe9EEIaN18U7XDHBLXTQyHSL8wqEBPP603rWRkImZYObmt
         79zw==
X-Gm-Message-State: AOJu0Yzgptr1w9L03Vtm/3cTwMKPBTI5ovdCfktPqW9NytXuRkFXlfJM
	dD4b7q24KugipKNg0Uq9UI7CASd0Yy864nFXO4Y5oL6pMovPmPmEmc7pBU64XuUbBSv6Ve5TOpw
	UqiQ7CVhOAxnwqeLlWedONHI3+EG1EWGcaDVqRNqxHErIXxSFAdiNI/9neS25L8GPIba6/g4YFX
	h4Dn/lzlnkKpGbvbBEaNjuNjbH1Bkid7zALVmORFy5MaUfgOL5VQx/NcOhMmyx+dC+T644
X-Received: from wruc11.prod.google.com ([2002:a5d:4f0b:0:b0:43b:42a9:2db1])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4692:b0:485:3812:36f6 with SMTP id 5b1f17b1804b1-48716046ee1mr47372355e9.21.1774438303323;
 Wed, 25 Mar 2026 04:31:43 -0700 (PDT)
Date: Wed, 25 Mar 2026 11:31:38 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.1018.g2bb0e51243-goog
Message-ID: <20260325113138.4171430-1-sebastianene@google.com>
Subject: [PATCH v2] KVM: arm64: Prevent the host from using an smc with imm16
 != 0
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
of 0 by decoding the ISS from the ESR_EL2 and return a not supported
error code back to the caller.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
v1 -> v2:

 - Dropped injecting an UNDEF and return an error instead
   (SMCCC_RET_NOT_SUPPORTED)
 - Used the mask ESR_ELx_xVC_IMM_MASK instead of masking with U16_MAX
 - Updated the title of the commit message from:
   "[PATCH] KVM: arm64: Inject UNDEF when host is executing an
    smc with imm16 != 0"
---
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index e7790097db93..4ffe30fd8707 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -762,6 +762,12 @@ void handle_trap(struct kvm_cpu_context *host_ctxt)
 		handle_host_hcall(host_ctxt);
 		break;
 	case ESR_ELx_EC_SMC64:
+		if (ESR_ELx_xVC_IMM_MASK & esr) {
+			cpu_reg(host_ctxt, 0) = SMCCC_RET_NOT_SUPPORTED;
+			kvm_skip_host_instr();
+			break;
+		}
+
 		handle_host_smc(host_ctxt);
 		break;
 	case ESR_ELx_EC_IABT_LOW:
-- 
2.53.0.1018.g2bb0e51243-goog

