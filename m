Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D18551DDF1
	for <kvmarm@lists.linux.dev>; Thu,  1 Oct 2026 14:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790865019; cv=none; b=MeJw0eVWTEqfFmZyjE4AiBWBvPU+hBg5ao4ua/ym3daAW5dOK0aUTfqLIPkqGCZ2Tgh5blhiYxAVfd30xoY57wH8cGA6ic1EnJb2oH8LNyvEy8N8BDY0ov5OXzCDPvcYoDv0EO2rbup14ii9vyo5/HTiuZoJSpZA0/0L2IupXQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790865019; c=relaxed/simple;
	bh=IdYR/8yaRIGkwktNu73Ter3+6neq3k/NNu+zIk3IK5c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aqXZCCF+I5Bo8PaweH80L8kISBm6PvdzJoZAbZ4NEyu1PUmo1YC3rV6dPIQjmn+rnj6+5U5xpoCooGKUi4PpXULVjfKS364Sy8b2cmzf35dIy1ectd4OmUCFCtk3OnZNHbXpNXRw+M7a+rtE2A7ccYW0TAXjyPzHlwqdAqrTTpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kc+BFtEs; arc=none smtp.client-ip=209.85.221.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kc+BFtEs"
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-48b0a199b20so748099f8f.1
        for <kvmarm@lists.linux.dev>; Thu, 01 Oct 2026 07:30:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790865011; x=1791469811; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kEb6Vu3i7LeQ0WrrmmClxachzkqqgLj3XAr2+t7WRUk=;
        b=kc+BFtEsltDMw7ggkOYWbRBig9WYCFlYLrxQLviC7pxjN9wWh9FU1M+jaGSwq9j352
         /286/8th5znpnBOpVFBN4/MOaZL4CiOn/y5ql6YNl9i5/AwdqXLArTVUS5ZEzyHtcI2o
         0zFFm1tSipjATlrKyuQjKrZ7NBXFjZIM3s0kEF+SjULVjKzpo+CdmbidqWeqvCXiWixv
         M0OEX8EFcqmMt/o7N1oMlp70ARWSUdt4v2PkvSeLJ/q9nKFaGVbpvdR/xrNKEmUKf8hB
         zj50S6PrABNjqtLrEe6jjDPXabvB5CdSm2hcdRo7V5T3eUxn/2P209nPFYi4WyRcTOKN
         1miA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790865011; x=1791469811;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kEb6Vu3i7LeQ0WrrmmClxachzkqqgLj3XAr2+t7WRUk=;
        b=p7LYIhhQBo8qj0jpc/dxxm6hNCrtO0C4Zb+UXs8X5wqE0rYLfoTFEN9aSoynWdz7Du
         LurJWZJ+jFV6MC6xjUvxVfPnOvtbuyXhJw9tn06yCbO4reP9SPkt1mzWlycpEC/VwBxR
         hGB0ckDt0U8zhuM6NNv41GlB3QjpC0kdJP5svfx7o7AIGMMf6iw2C9lj78X/uaHobRKd
         w5WeSIJsSerJLH7TDikzWfXofNWGbkRzBvJ6K3+/YFIruiHWs4IlkBH+FJl0Gg875DSC
         Obo6X9zCPMcVjR2RT1ND2MwSvbeQv+G1sTDyU3W2heAno6P5J8czwttH122Frd7yBFQ6
         K1Hg==
X-Forwarded-Encrypted: i=1; AKwUvBxOvEd/ld2egWbzwuOCACd/i++V9fWFeATUpQ6WC4gQuS2aDqVl8qhgHxYDABBM61NPa7zxjhQ=@lists.linux.dev
X-Gm-Message-State: AFq9FYLkUoBfysXcVZMbgomEXKlI5jsHB8gdQS2YyHoVnfwqGJt5FgCV
	gDYDcHl8QZgWU0ddqUNxH5QxKnIlEWOhGz9E7bRTsG0EmwRwkZj/9i/A5NOnJDhhx4ZIUq8HAQT
	P03HTDVNrMBsCuymrUegl5A==
X-Received: from wrbfq6.prod.google.com ([2002:a05:6000:2a06:b0:488:847d:dd10])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a5d:5d08:0:b0:48b:f92:1f75 with SMTP id ffacd0b85a97d-48b0f92213dmr3323065f8f.48.1790865010543;
 Thu, 01 Oct 2026 07:30:10 -0700 (PDT)
Date: Thu,  1 Oct 2026 15:29:58 +0100
In-Reply-To: <20261001143000.3371786-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20261001143000.3371786-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20261001143000.3371786-3-vdonnefort@google.com>
Subject: [PATCH v5 2/4] KVM: arm64: Move kvm_define_hypevents.h to arch/arm64/kvm/
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, 
	Vincent Donnefort <vdonnefort@google.com>, Fuad Tabba <tabba@google.com>
Content-Type: text/plain; charset="UTF-8"

kvm_define_hypevents.h is used to define the kernel-side structures for
hypervisor events. It doesn't need to be used anywhere else than in
hyp_trace.c.

Rename and move it to arch/arm64/kvm/

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Fuad Tabba <tabba@google.com>
---
 .../asm/kvm_define_hypevents.h => kvm/define_hypevents.h}       | 0
 arch/arm64/kvm/hyp_trace.c                                      | 2 +-
 2 files changed, 1 insertion(+), 1 deletion(-)
 rename arch/arm64/{include/asm/kvm_define_hypevents.h => kvm/define_hypevents.h} (100%)

diff --git a/arch/arm64/include/asm/kvm_define_hypevents.h b/arch/arm64/kvm/define_hypevents.h
similarity index 100%
rename from arch/arm64/include/asm/kvm_define_hypevents.h
rename to arch/arm64/kvm/define_hypevents.h
diff --git a/arch/arm64/kvm/hyp_trace.c b/arch/arm64/kvm/hyp_trace.c
index 9644c424819b..8faaec899f92 100644
--- a/arch/arm64/kvm/hyp_trace.c
+++ b/arch/arm64/kvm/hyp_trace.c
@@ -402,7 +402,7 @@ static struct trace_remote_callbacks trace_remote_callbacks = {
 
 static const char *__hyp_enter_exit_reason_str(u8 reason);
 
-#include <asm/kvm_define_hypevents.h>
+#include "define_hypevents.h"
 
 static const char *__hyp_enter_exit_reason_str(u8 reason)
 {
-- 
2.56.0.rc1.315.gc6ed9934b7-goog

