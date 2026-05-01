Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 873C13A1E6A
	for <kvmarm@lists.linux.dev>; Fri,  1 May 2026 11:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777634518; cv=none; b=XLOXj8UkjQMFo532oIx+znzzIlfRNm7mBAOw9inHcGbJo4YT2G8KVqERPbSjRLZ+b9LEdDevFmPhrjsRYWOWCNHH0gkxJ46+KdJTLacAmoT8Nf1gE4ZqfTKY2vqTZFONEp/SiHYHMaNveIX6uJfVqqIcsK4Z/Y/hhYLbtJJTGWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777634518; c=relaxed/simple;
	bh=W4DGq5FQ3yG9XVJf1X8noklkNaBHnhoJ5jehTTSaoHU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tth9alVyF3c2gBtgNocTLQi5iPs68hEFDvB6gF9ZFwksskZ9YyXT3BY79AvJk74abCUPFsXhYXuDKOXRC8YSqRdVm1VhdgGGJDO3Sboflloj+z77+Ouo2GD5GuBRR5HP9lRZfaSnnZRA/76COk2UrVmTkUek3NUUrt5cVFUdxBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UgqqzgDP; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UgqqzgDP"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-43ff19e54beso1246218f8f.2
        for <kvmarm@lists.linux.dev>; Fri, 01 May 2026 04:21:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777634515; x=1778239315; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=pkGXruA+MAauMM9ApRELF9QcQ1O0uA1Qqp7VMYhHPII=;
        b=UgqqzgDPbSxU/HxxQ28hlLIodVpwrQ4FdgfDXopV92r2/grv3raN84hYHeEemQXB4w
         go6psKzGFEA0p0Gn9gbR4xxDP8NeOR5ra4UsxK1FeqByu9TQeC4sGvILrNxnMSKMGBji
         p7jNVmdWZhcrJJauhSMFbJOKYZ0rSdkczlQi4+7gXu3NKs+lXk0rzIQ4/12bp3KIPVFV
         VGtEhqaGakoTOm8j10Q5QyIogFAUCCuxjXvhIO+KjeuXUVUOp9rEqN5U7IeKTVjygswd
         7Ahr1zu1oF4wgwqZmarsE9etClZVo10JWbMhGGsDRxbBb4r4hs7S7Fsh7AQjGFpr+cGz
         244w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777634515; x=1778239315;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pkGXruA+MAauMM9ApRELF9QcQ1O0uA1Qqp7VMYhHPII=;
        b=egRY5fgpBPDHbYGh1O5AiSc+qgoz2yJsBU3qNGcfVxYUxw8xtBtXJjGKKVXyvJmX0E
         boQdS/c33LpICN0htfGZK7v0e4gHDH1EamFraJAAtOM7Dsuo/PR/u7ojOOlj69+VeyuP
         j2lCHzg9q2/BdWdXhuzJTBX3EMQqJLWJoVoDR8W88kDp6bhHMLoWlQymO+2XuUgpIVVv
         ZL7amdgLSljXZOW7v4dg4AXDLp1n1XpJg3oYM2y6yXquAac7Ln4mVgLPUFhuo5K2mBE8
         YUx2B31NsEyceuad5GkJ3i+AFYdK9B3MWyTJat9aubD8yz1sj0ZdGdIfZqcX49TV3DFF
         FchA==
X-Forwarded-Encrypted: i=1; AFNElJ8WFNZH2feGGncLWwL5hkRaGDXe1LIjRycje6eBTlPS+M5KKwBjb26GuZ/Y4xbisDbsVBXumsY=@lists.linux.dev
X-Gm-Message-State: AOJu0YxGcZC87gB/rhHPWIUEuascfPTCbERQuLidwDMncD3iSyM2US+C
	O5B39Jshe6kngrfPKxPXGP31lssQMewciyFJO8q51A34Bb6OUFkEvM4QhhOECOcQ+dZW/rdFy8o
	bZw==
X-Received: from wrcz10.prod.google.com ([2002:a05:6000:454a:b0:44a:2a68:f4aa])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:24c5:b0:43d:71f4:7ed5
 with SMTP id ffacd0b85a97d-4493cc3fdffmr11707041f8f.17.1777634514643; Fri, 01
 May 2026 04:21:54 -0700 (PDT)
Date: Fri,  1 May 2026 12:21:46 +0100
In-Reply-To: <20260501112149.2824881-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260501112149.2824881-1-tabba@google.com>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
Message-ID: <20260501112149.2824881-4-tabba@google.com>
Subject: [PATCH v2 3/6] KVM: arm64: Fix __deactivate_fgt macro parameter typo
From: Fuad Tabba <tabba@google.com>
To: maz@kernel.org, oliver.upton@linux.dev
Cc: james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	qperret@google.com, vdonnefort@google.com, tabba@google.com, 
	catalin.marinas@arm.com, will@kernel.org, yaoyuan@linux.alibaba.com, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

__deactivate_fgt() declares its first parameter as "htcxt" but the body
references "hctxt". The parameter is unused; the macro silently captures
"hctxt" from the enclosing scope. Both existing callers
(__deactivate_traps_hfgxtr() and __deactivate_traps_ich_hfgxtr()) happen
to define a local "struct kvm_cpu_context *hctxt", so the macro works
by coincidence.

A future caller without an "hctxt" local in scope, or naming it
differently, would compile but bind to the wrong context. Align the
parameter name with the sibling __activate_fgt() macro.

The "vcpu" parameter remains unused in the body, kept for API symmetry
with __activate_fgt() (which uses it).

Fixes: f5a5a406b4b8 ("KVM: arm64: Propagate and handle Fine-Grained UNDEF bits")
Assisted-by: Gemini:gemini-3.1-pro review-prompts
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 98b2976837b1..bf0eb5e43427 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -245,7 +245,7 @@ static inline void __activate_traps_ich_hfgxtr(struct kvm_vcpu *vcpu)
 	__activate_fgt(hctxt, vcpu, ICH_HFGITR_EL2);
 }
 
-#define __deactivate_fgt(htcxt, vcpu, reg)				\
+#define __deactivate_fgt(hctxt, vcpu, reg)				\
 	do {								\
 		write_sysreg_s(ctxt_sys_reg(hctxt, reg),		\
 			       SYS_ ## reg);				\
-- 
2.54.0.545.g6539524ca2-goog

