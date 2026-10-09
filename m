Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7A8C42902E
	for <kvmarm@lists.linux.dev>; Fri,  9 Oct 2026 08:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791535551; cv=none; b=Uhce+dGcPNrLWSY1dW005RTwVLdbPLGZdaAoA1O3h+0hSwN8VPFScDeMRbtIWYUDnu1X0se32mkKGLT+zYZqByqTPumh/mAtdCuqUN2RFQQg3OKG4FnonrInqWqlHn2ADcG5YwmmjB0LQ50YWZ/mf33HmnG//TEmiamxZ4ZtlY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791535551; c=relaxed/simple;
	bh=Bg71rvPo2pxNdyRbwPbRvDE+FtchYLHpgHUHkoZf8hM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PONmPO2tfvsztY15Hth4GqWcTbvt8qIXdsD7qD6AQvGDIY2dUI4rh7Jvp9nodQe9vbvC4R//4ch84W4OGSR6taKf3rghz7YxRieklEP5DhL0Q0s9bfa5P5SQypD+CbLv8mSy+dR3UugLn1v09LKENBfu408g9bBHHcUcAqQ0XwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aq78Gler; arc=none smtp.client-ip=209.85.221.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aq78Gler"
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-48c430f0f01so5095394f8f.1
        for <kvmarm@lists.linux.dev>; Fri, 09 Oct 2026 01:45:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791535548; x=1792140348; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dSnohHHBpGGpGTNKjTwOu2NqWIBpAQaNGLki6PGnCsg=;
        b=aq78GlerOo5A2U+CqoCzUmebanqcqd7wY+q6jOi6eXFZ5k/wDVfBxCmxy+qVam32Su
         BX1K/Ls9XGYpIp5nGoSHYgfir3mGzJr5uboqRY9wzeqUtl/hw93Qp2yoHVDlII+sXJgH
         zM9kVHjue3g9cVqgCzat+E+3cTGUUSXGIAeWzehTM+Yz6HqX+TEplpJCDjXZhAz6UCig
         q4TMXq5LNKG3Dtc9jp5ZxUFeDHDkvl0hcEApMGLhHNfENcQHEjaTejeb046Y6mnDAaRG
         Si83G3b0koMknLLAMiPD6l+oTQCeZ6YbnR21K5Ltrsm4q7UeqSwWxQOI1BkB5cqccmMS
         ZjFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791535548; x=1792140348;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dSnohHHBpGGpGTNKjTwOu2NqWIBpAQaNGLki6PGnCsg=;
        b=GsUJyDvaatsdHHL9UOGnPe4NxzlRHVT7E0Aui3ndrkJPIBtIOAWm1eiLOMNbgACaiQ
         wNUOk4U+zJIO++W0TsM8o5UKity0ChRH/AQ/M88tIbckCjRDZ+QicQ9kMR8usi9aavmV
         atT5caRC7x2d5LoDxMsndaebKlmuHuBBmzRB2LAsS3oDErSreXojm6h6EgFihgtKIVuh
         up/Z04EQPLue63MmLeDYKXZQyUsQztByAvrMKF7LZEHxJKgalNKs6YiNlYxHqML97UyA
         5iUh2MgRgZfl7OAwBJbHuJF9dEHGTrt8tUbQDqDnTR59DAqbaJFZOBJw/Xd0d492p7yO
         OuLQ==
X-Forwarded-Encrypted: i=1; AKwUvBw7f2hkB9YyPrkNVnr/fKGPJc1JF4Yc2ZSABtgbFGSTiZNR7JSRrRbMMbgG3TAcR62cFcCEMZQ=@lists.linux.dev
X-Gm-Message-State: AFuF++kNiIEluSImseAIg1UDpQ7V8E7OaOckbVdQc2z2kL6ZmBTBgtbB
	HRDY00PHLnhdewG+gJMCNlEcV5zmSvyHa8iGIZvTO+9d4edsYrZWg3C/pTXBr6c/axBRTXYOGhn
	DYA3mMaSD9RNYtDe+ZpEh2Q==
X-Received: from wmbev15.prod.google.com ([2002:a05:600c:800f:b0:4a1:7481:171e])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:190a:b0:4a1:746e:589a with SMTP id 5b1f17b1804b1-4a18e4aea54mr22105455e9.18.1791535547899;
 Fri, 09 Oct 2026 01:45:47 -0700 (PDT)
Date: Fri,  9 Oct 2026 09:45:28 +0100
In-Reply-To: <20261009084529.462577-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20261009084529.462577-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
Message-ID: <20261009084529.462577-3-vdonnefort@google.com>
Subject: [PATCH v1 2/3] KVM: arm64: Add guest_hvc hyp event
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, qperret@google.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Add a guest_hvc hypervisor trace event to log protected VM HVC call IDs,
return values, and whether the call was handled by the hypervisor.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
---
 arch/arm64/include/asm/kvm_hypevents.h | 16 ++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/pkvm.c         |  7 ++++++-
 2 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_hypevents.h b/arch/arm64/include/asm/kvm_hypevents.h
index 96985c93a15e..c1239d78c8f9 100644
--- a/arch/arm64/include/asm/kvm_hypevents.h
+++ b/arch/arm64/include/asm/kvm_hypevents.h
@@ -59,4 +59,20 @@ HYP_EVENT(selftest,
 	),
 	RE_PRINTK("id=%llu", __entry->id)
 );
+
+HYP_EVENT(guest_hvc,
+	HE_PROTO(u32 id, u64 val, u8 handled),
+	HE_STRUCT(
+		he_field(u8, handled)
+		he_field(u32, id)
+		he_field(u64, val)
+	),
+	HE_ASSIGN(
+		__entry->id = id;
+		__entry->val = val;
+		__entry->handled = handled;
+	),
+	HE_PRINTK("id=0x%x val=0x%llx handled=%u",
+		  __entry->id, __entry->val, __entry->handled)
+);
 #endif
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 6290c4b62659..0deed0622677 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -10,6 +10,7 @@
 #include <linux/mm.h>
 
 #include <asm/kvm_emulate.h>
+#include <asm/kvm_hypevents.h>
 
 #include <nvhe/mem_protect.h>
 #include <nvhe/memory.h>
@@ -1142,9 +1143,10 @@ static void pkvm_memunshare_call(u64 *ret, struct kvm_vcpu *vcpu)
 bool kvm_handle_pvm_hvc64(struct kvm_vcpu *vcpu, u64 *exit_code)
 {
 	u64 val[4] = { SMCCC_RET_INVALID_PARAMETER };
+	u32 fn = smccc_get_function(vcpu);
 	bool handled = true;
 
-	switch (smccc_get_function(vcpu)) {
+	switch (fn) {
 	case ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID:
 		val[0] = BIT(ARM_SMCCC_KVM_FUNC_FEATURES);
 		val[0] |= BIT(ARM_SMCCC_KVM_FUNC_HYP_MEMINFO);
@@ -1183,5 +1185,8 @@ bool kvm_handle_pvm_hvc64(struct kvm_vcpu *vcpu, u64 *exit_code)
 
 	if (handled)
 		smccc_set_retval(vcpu, val[0], val[1], val[2], val[3]);
+
+	trace_guest_hvc(fn, val[0], handled);
+
 	return handled;
 }
-- 
2.56.0.385.gd3acb90ef8-goog

