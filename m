Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7643535CB6F
	for <kvmarm@lists.linux.dev>; Mon,  3 Aug 2026 09:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785749960; cv=none; b=PtTyEGNIfTzBshVqQEvNyozt9z6Frn2SFKPCYJtuGMCl83shEZvzQQa8UE7Lq7tTOFGk+H0myk1KhjActGslDQ1rr6XLjuR0w0XbXQbB+3363a4owg8oNvNEN5FpJHZl/WYCAYRUV7RotFbiCYzIBdxVxPD90f3CaqLrwogrvMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785749960; c=relaxed/simple;
	bh=04JfKHW9A7RCP1c9QHJ7SwBy0/xvQo1xmmDxuN+lyEA=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=j/oOquwZS3MzbiZkxyx/28xIjC6yqRrnHxEwd09ZGNC8OM6o+QJgkkrjaQclIQxAXE2weinayvui9uQBtR+XuOqpdTnY2D7dnETkYhJ5a1XG4qeHGwrKmkLCTy+hGzNtfdemIZO0tAI7LbUrGhFLzqxh487sbyb2RXYTxh8c3eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=d9hzfaIV; arc=none smtp.client-ip=209.85.128.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="d9hzfaIV"
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-493fa6e28a7so22385585e9.1
        for <kvmarm@lists.linux.dev>; Mon, 03 Aug 2026 02:39:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785749950; x=1786354750; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=i7nVKeMcCmrPSAlaMzrZkMXb8FR+2oHKNn3SPXNfhnQ=;
        b=d9hzfaIVtUXbdvsulB7bGtt7uVZWZ1uC/tA8EqCWY7Q1abZZWvF5Xu8bAFda/87u0c
         xbNYh3qeeC0uaGQqV3v8rShjE51NvTQA7adjSSRF0wwmu4z9zgaWwBC+RKxy82DtdNBK
         Rc+ANqSifVFvRK8pWT7DTqjnsNSkvXmqN+NJF80U8iVD9E522VDWdvn272qBlvlbNh2Q
         OxE9ebq/2Cwvw0+jRChXGVEybBZ7BZj0N8WYIizmmFwOB9vEIsm2GhPmjhSBFXK0KXJ5
         ZwiwtXw1ZWo4AOgFeijHYNjno3YFxFOvfG82M0W1XLX8SrbLf1Wb8s00+ENu4YLQ2z6B
         y/3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785749950; x=1786354750;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=i7nVKeMcCmrPSAlaMzrZkMXb8FR+2oHKNn3SPXNfhnQ=;
        b=gR0o1evIlY5Yu4e4r8L4bZ+LqwiQTLQSNsfpoU6OGRsCd/wDOBZeoSUUB6kF2g5Hjj
         BcMUpxGSDETmiNMNv6cnWQD2dC6S+2+HX9LPOXq4acD7KgyFKxNbSI8CDq6TranVfi+z
         SKsVgi0OZG8wszELYGQAO9e2JGgyv8+UHXy+iruNJsibmEXiAi02vMs2gY/MCF6uW6GK
         7X2SABJS9QakWkqQJJcV3inPJ6jFUS0Xk0HaiQTuDhjrbPPyp6B6xymmPRoO4rCbaszo
         uxgp2VQVb0w3eqFPOBtwBrcOqlWwQb4IUUj3pvEQ49ZTGc4jV4T25Bs2Xlp5GrFhKkLn
         o2BA==
X-Forwarded-Encrypted: i=1; AHgh+Rpgs5xNDs4b8kAkEBoZy05+MchcPsHOKYBoYnQXqRGn/2v7I5a7rGyVoXInON5YxCsJ2Zmgnes=@lists.linux.dev
X-Gm-Message-State: AOJu0YzNbQl/VMDWygUZ31Rr4EBd5n/iCLxS9M5Szxoz+VEvA01tTupR
	kNprKSekgLzLtMsVZAttTP2a4HMhyviOdPL3hbSiEIkfe0L1E+3wWZT+YTtiFg2MfIuNv2dwy9B
	di3rog8tuLP2qSG9hk9QdRQ==
X-Received: from wmbe4.prod.google.com ([2002:a05:600c:5904:b0:488:9b69:9379])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:c113:b0:495:4689:1e98 with SMTP id 5b1f17b1804b1-4980c674e1dmr159181765e9.10.1785749949727;
 Mon, 03 Aug 2026 02:39:09 -0700 (PDT)
Date: Mon,  3 Aug 2026 10:39:06 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
Message-ID: <20260803093906.3531699-1-vdonnefort@google.com>
Subject: [PATCH v2] KVM: arm64: Drop %pB on nVHE panic when stage-2 is active
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, qperret@google.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

With pKVM, the host stage-2 is lazily mapped. kallsyms, accessed via
the modifier %pB is therefore potentially unmapped. If the hyp panic
occurred while the host stage-2 lock was held, handling this fault
deadlocks.

Skip %pB formatting unless the host stage-2 is disabled.

Fixes: 6ccf9cb557bd ("KVM: arm64: Symbolize the nVHE HYP addresses")
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Tested-by: Fuad Tabba <fuad.tabba@linux.dev>

---
v1 -> v2:
 - Introduce nvhe_hyp_panic_host_s2_disabled()
 - Collect Fuad's tags
 - v1: https://lore.kernel.org/all/20260731182231.1277064-1-vdonnefort@google.com/

diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 54aedf93c78b..88dcb8cb36f3 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -507,10 +507,20 @@ void handle_exit_early(struct kvm_vcpu *vcpu, int exception_index)
 		kvm_handle_guest_serror(vcpu, kvm_vcpu_get_esr(vcpu));
 }
 
+static bool nvhe_hyp_panic_host_s2_disabled(void)
+{
+	return !is_protected_kvm_enabled() ||
+	       IS_ENABLED(CONFIG_PKVM_DISABLE_STAGE2_ON_PANIC);
+}
+
 static void print_nvhe_hyp_panic(const char *name, u64 panic_addr)
 {
-	kvm_err("nVHE hyp %s at: [<%016llx>] %pB!\n", name, panic_addr,
-		(void *)(panic_addr + kaslr_offset()));
+	/* Kallsyms might not be mapped in the host stage-2 */
+	if (nvhe_hyp_panic_host_s2_disabled())
+		kvm_err("nVHE hyp %s at: [<%016llx>] %pB!\n", name, panic_addr,
+			(void *)(panic_addr + kaslr_offset()));
+	else
+		kvm_err("nVHE hyp %s at: %016llx!\n", name, panic_addr);
 }
 
 static void kvm_nvhe_report_cfi_failure(u64 panic_addr)
@@ -538,8 +548,7 @@ void __noreturn __cold nvhe_hyp_panic_handler(u64 esr, u64 spsr,
 		unsigned int line = 0;
 
 		/* All hyp bugs, including warnings, are treated as fatal. */
-		if (!is_protected_kvm_enabled() ||
-		    IS_ENABLED(CONFIG_PKVM_DISABLE_STAGE2_ON_PANIC)) {
+		if (nvhe_hyp_panic_host_s2_disabled()) {
 			struct bug_entry *bug = find_bug(elr_in_kimg);
 
 			if (bug)

base-commit: f5098b6bae761e346ebcd9da7f95622c04733cff
-- 
2.55.0.508.g3f0d502094-goog

