Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50CAC2F1FC8
	for <kvmarm@lists.linux.dev>; Tue, 18 Nov 2025 10:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763462292; cv=none; b=j20GGptK53S7wTtL7xO66ssAJtqgzyQaa9BWRvsZ0ufxov+QCMoS8hXaTKKsS7yQOUYeviH+gdp2ye+7MPitx1aVAirQXxjqaxM6Cu9VY+OhZ5Y75EGMCBLYnHCeg0F3qQ0bLTPctcDADZEcejZUgAwOud7Yq8vI5nFkO/HEivk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763462292; c=relaxed/simple;
	bh=qmo55mH6jK6yYM49f9VcL/7fvxF5sgOVqxYjderhkJo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZADblJzVLnVl3sCFmdjUxacA0hcpvfAlZWy5zxVExyPXcCSMHnipXImHuy4Dmuev5D6Jq9Qqdhrfi8uR08dd0HtSszgbBpgI/WN3NyDLS7aZ+KcVB3FVdmttwZ7hwir35wNgF9cpkoxsu8Q6R8OnYpA5gJrPuEcyBwuF/BEmtko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fJa9IlRI; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fJa9IlRI"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4779b432aecso13994025e9.0
        for <kvmarm@lists.linux.dev>; Tue, 18 Nov 2025 02:38:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763462289; x=1764067089; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=z9KRn/Dxx5SCay75EDvYE55m9LJK2/HJnZMeChQUWtk=;
        b=fJa9IlRIGhOzWvBBOa4vvihKBEQmoOIx1wCowGgUqYQ76bqM1LkZ6d4LLWt/cTrywa
         hM32KiGc38sEDqAyVzdbbLLE+6CA2PwyoQ9pl4cJlWnhZHrRsnqK07MXl6uoMQthxi6G
         mWIH1UbhxbHJJLrZv5QxPzvP/5YmW0iDlLxRlsJbAybhrwGv7HXv2esnv0t0ejZ6Yfnz
         j3s7V0J9s8Vm/V0GDYFYbijjRf65HjQaBLmHKFcvvu4MHkpqr7V8ckxShduPSZgXNo6G
         coQfPD5+juTUnlf1B/Xf5DK4DD6HMlPl+SkQGwkYcu6IAc7cPjjL+XQ7XqBbu5/Dc2Kg
         uQaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763462289; x=1764067089;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=z9KRn/Dxx5SCay75EDvYE55m9LJK2/HJnZMeChQUWtk=;
        b=gkMAiQZr4xlZjACoc3XCbNTSvDLY7tu7AspMpMEmkFQWSgoyuXGXqQ0RpCZLh4Gq4u
         VaaayIsNR80DbWryQZjIoLQ7hpUgFqBPV/r8h7Vehrtm51f07/6UiqV1TpkOjVcrM5a7
         1MpDh16xIDnzRxnUQXXzzcwGDd+JQFOaFFYD7biaF42daaRleHK4rRRYin1SnNKWBhLF
         dV0R+tOgWs9/rT2QSDdvf4OBXw9pk75mD5MujY9VvObBjwsQRA5zx96XBHXfMi2Wno6i
         JuHmvKAnHoUh4dQSiTaAH3Csf8IaETgCvxf1gu8MRnBnQuPZwy7N/yscK6yl4gaJti0c
         4Lug==
X-Gm-Message-State: AOJu0Yx9HGoNG74GL+FgeHd4KcLn/esQHlwG/UFC7iNY8SCKtjL8R9Xt
	aEDp8Lw4iHb42dy4pdXQpFgJOnbw/oGIso0JB1tPKkKYtfBE+MzkGJJkpha42o7+P3c8oLqIGEb
	FS6ETLt165gySZLzgbqzIZkpD+GpBYugD3j65wyUrAgc5aVTJppw3igRPL5Lc9aBkrdE/QCISCf
	YH+QVwxmvMgDzzQzLdwFx6G4+OAkU0x5s=
X-Google-Smtp-Source: AGHT+IGZkcmmVxFPxoDyPbv3zlvZywpQhBQNq9TJDWBaYaiID0Y8cksGdVzbX50fRSuo/B+EKDyNVMXcOQ==
X-Received: from wmbgx25.prod.google.com ([2002:a05:600c:8599:b0:477:a338:214b])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:1d19:b0:476:d494:41d2
 with SMTP id 5b1f17b1804b1-4778feadf96mr134759845e9.29.1763462288748; Tue, 18
 Nov 2025 02:38:08 -0800 (PST)
Date: Tue, 18 Nov 2025 10:37:58 +0000
In-Reply-To: <20251118103807.707500-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251118103807.707500-1-tabba@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251118103807.707500-2-tabba@google.com>
Subject: [PATCH v5 1/9] KVM: arm64: Fix Trace Buffer trapping for protected VMs
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, will@kernel.org, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, vladimir.murzin@arm.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

For protected VMs in pKVM, the hypervisor should trap accesses to trace
buffer system registers if Trace Buffer isn't supported by the VM.
However, the current code only traps if Trace Buffer External Mode isn't
supported.

Fix this by checking for FEAT_TRBE (Trace Buffer) rather than
FEAT_TRBE_EXT.

Fixes: 9d5261269098 ("KVM: arm64: Trap external trace for protected VMs")
Reported-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/pkvm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 43bde061b65d..8d06a246dfd1 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -117,7 +117,7 @@ static void pvm_init_traps_mdcr(struct kvm_vcpu *vcpu)
 	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, TraceFilt, IMP))
 		val |= MDCR_EL2_TTRF;
 
-	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, ExtTrcBuff, IMP))
+	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, TraceBuffer, IMP))
 		val |= MDCR_EL2_E2TB_MASK;
 
 	/* Trap Debug Communications Channel registers */
-- 
2.52.0.rc1.455.g30608eb744-goog

