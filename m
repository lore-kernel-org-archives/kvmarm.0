Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com [209.85.218.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEEBF4322FB
	for <kvmarm@lists.linux.dev>; Fri, 31 Jul 2026 18:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785522166; cv=none; b=ta21GL8Ph95PynCYDARynuIHt7wYq5/6b7+Sp6fgpwobC91pUtRzV7KgiaEoluBDj6phtLdCWgm246RoZS0X0tfHW90eNGW3rOY+keYk53WqzoH2vLrDv1Q3A4ExMQYQcIt4J5luvZ7vnngVrjTeLeVSqc0g2IQ4qWFEZmuzoj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785522166; c=relaxed/simple;
	bh=iYlJy1kSxeKPVqdnCV2wDbbIuyQF96X7i5Ro7kcA7hw=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=rwgE5gTietdofWGVMkFkITprSDtkk8PTjPAzmwS/6rh2L8O5sd6f5kkElls9dQvP6GRZ1fbi3ScaMJNxrXz2O+L457hvwpw6GuqY+8p5yMRfF0pWbbNwbW/o2b7Q4trFDddsnmQXKrytc9Pgtw1ETH5MxPIcHZ4RNJxjE006cPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nf30O1ko; arc=none smtp.client-ip=209.85.218.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nf30O1ko"
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-c1c4715cf0eso143932166b.2
        for <kvmarm@lists.linux.dev>; Fri, 31 Jul 2026 11:22:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785522163; x=1786126963; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=1t219Uo5uTrxIXX4Pq8w6KIqBvayeGDC3OL82qt7QsE=;
        b=nf30O1koHHTR1+gmQ8XGimNJR+1R78rSTmwxWY7twlkC/XBPS52kSJ35PP2pLO839F
         eovFTbTUYamkL8xduz0yeC8MX9k3IosDu2q3MHKv1tG3gSvKnGmxkmemt1QAd/0EwIFp
         uHil+GXkrVBHUiy0w9yYtYRUtnzWoIPPrz6DBYrookRsVPXHkiflDVP9LpX9xZj3XQ41
         O9720R7hA5sIq2gfWCJLvBLNgjyyokW8085MzHswhvEDJxf7EfWQCfcVXdF43K9xGZ4h
         kBcfbmRA0VXHLPR9nk+19m50P7V14l4ijV6+Kh4uSX8Y9z4okUvPOu3bjlEkaq0WddHH
         HGYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785522163; x=1786126963;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1t219Uo5uTrxIXX4Pq8w6KIqBvayeGDC3OL82qt7QsE=;
        b=SNJm6YYHRWrzz5HaNm+aKUAh9A7Q3ylCQhStp4b3MQ6Ue6dkaOK9QxWGRdDxzH1sB4
         rhhF/nBts6v6GZNplgiIFrZldRbJjMj5xchg6E2Vzlnwac2L2zWdxHQjhmd2L92mmuPN
         7h7q4xdCSUXM7cGZa/zgenEJnsECXXFvzrjBbAo5wb1gJzPYIbsZUpefJjxjq8o/Tpkn
         cn/kH8RN4Ze8RaEc6s5bcbhQv0cmSogFAfciqHC/bURbN+jaJWaMT/KJw2fEeSZ9TUCc
         8pBEhOH7Aq3Qvvv3baAW8Q7F8zzlx73CHAStlTT3I74olcUhbrWzloyy31phntx2CWTT
         rILQ==
X-Forwarded-Encrypted: i=1; AHgh+RrAGP/kUiv/6Tkdl26Cx2U3VMQGn1PVE797qCYCads9ttXHZJObYg0C+Kk+xrjKkT+XfhsZdRo=@lists.linux.dev
X-Gm-Message-State: AOJu0YyiaMp2HhqhNtxCtJbZqWDEBHFfnqdgY+AGVR7m8Z/RN8VYqldT
	GCOsBz3vy8Onj0U/KMp24R5FI+Txf2xpKp+9EMlfGEYXA2EsWBjqHufI2PrnN+XAOLlKVyNagua
	uUZZUZslqmgcNx/Da/oQHwQ==
X-Received: from ejcwb5.prod.google.com ([2002:a17:907:d505:b0:c12:5033:55e7])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:c05:b0:c16:6669:a4fd with SMTP id a640c23a62f3a-c1fe8103ebcmr38912166b.16.1785522162650;
 Fri, 31 Jul 2026 11:22:42 -0700 (PDT)
Date: Fri, 31 Jul 2026 19:22:31 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
Message-ID: <20260731182231.1277064-1-vdonnefort@google.com>
Subject: [PATCH] KVM: arm64: Drop %pB on nVHE panic when stage-2 is active
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, qperret@google.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Currently, the host stage-2 is lazily mapped. kallsyms, accessed with
the modifier %pB is therefore potentially unmapped. If the hyp panic
occured with the host stage-2 lock taken, a dead lock will occur.

Fixes: 6ccf9cb557bd ("KVM: arm64: Symbolize the nVHE HYP addresses")
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 54aedf93c78b..2e1951c215ae 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -509,8 +509,12 @@ void handle_exit_early(struct kvm_vcpu *vcpu, int exception_index)
 
 static void print_nvhe_hyp_panic(const char *name, u64 panic_addr)
 {
-	kvm_err("nVHE hyp %s at: [<%016llx>] %pB!\n", name, panic_addr,
-		(void *)(panic_addr + kaslr_offset()));
+	/* Kallsyms might not be mapped in the host stage-2 */
+	if (is_protected_kvm_enabled() && !IS_ENABLED(CONFIG_PKVM_DISABLE_STAGE2_ON_PANIC))
+		kvm_err("nVHE hyp %s at: %016llx!\n", name, panic_addr);
+	else
+		kvm_err("nVHE hyp %s at: [<%016llx>] %pB!\n", name, panic_addr,
+			(void *)(panic_addr + kaslr_offset()));
 }
 
 static void kvm_nvhe_report_cfi_failure(u64 panic_addr)

base-commit: f5098b6bae761e346ebcd9da7f95622c04733cff
-- 
2.55.0.508.g3f0d502094-goog

