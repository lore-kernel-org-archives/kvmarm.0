Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9306119E97F
	for <kvmarm@lists.linux.dev>; Mon, 10 Nov 2025 13:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762782331; cv=none; b=lUkB8oRUJQ//YpCQ8qTmjv148p9GB0THrF58WkZE1wr9GhLhHkMxqjwk5TyxtVgfkxKWqYInxy9+QAV5A/haWmW9tjI2FrEiv3OZEeQ8ICJSxuxRjrdteQP0RajmEabhCT1gphpHuyn7efj+s63WIcVs+q9WDchoaMjzi1FbvFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762782331; c=relaxed/simple;
	bh=V/TCtJ7VuR8VnLAxueK54DstYUU0u6j0AkE9ZHM5+C0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ad7ztGtfA9COe3T4/ymekSNX94cYObIm8HC4tBM3G59oIE/O+H014uaQ2/pbzGwCyJQ76x1rxt4AsbT+g97grXENaQOJOCyZb5e40i/jdesDyIX1wA5yXspopxhjJItYEWTz4fC0xD/Rtad4uOICIY9gPf8A5kcwB8HpaBhDYok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=F4p/7B2V; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="F4p/7B2V"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-47777158a85so19325295e9.3
        for <kvmarm@lists.linux.dev>; Mon, 10 Nov 2025 05:45:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762782328; x=1763387128; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KWYzkbp7pgBrTyt1NisY6LsxXizq6AqdKv5W+aeRvmM=;
        b=F4p/7B2Ve1R10tqyZ7ZaZaFPWQr64lpS8cFRr9/Mu5iMV8l41tD4yNl5GEOrhBpMdM
         QahJbm4V+0pN7K2kEIja2cwxBlbX6/JMxv9VD/aKEEv11oPHuA6p6nCDqkNhNxAsf6/d
         VGAJjrB0R+5SCPKCoBDJTL+//QD9GWxvilxaNGGbtI3Iz9r22WtRqzk03XnaSJlmYDir
         CddFwM6ebfZDz2dpCLISQwPMgysIwO3k2fuTQfUt8EBAk8wIRrcuPbBjXghLPukArMKz
         bz0DIa4rC/1IHrVU7a2PoIUxlXD0+Qf2lDuqdJST62sSFkwqoNW/b0DQ1EW9UecLYpPC
         sUGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762782328; x=1763387128;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KWYzkbp7pgBrTyt1NisY6LsxXizq6AqdKv5W+aeRvmM=;
        b=Zq5dAUwN+I8KSR3imojxfVJy0CF2EBTazYpeSc2UXbi1/+lOjdbz+mpc6/lwBBw5ib
         gu+fcKt1tTowz2/8irFckTFs74uK51BZfm2g+tky27xTeURALFcNKsEpMN/rqmrShM4w
         gmkLFCGQ4qtxlb3ugB0BCHTaF6jocVIoH4oJefAfVHM7PSdaOibJT8KjG/HMbwS68TxH
         xuMFE3h43zggBKg2r7Ykzq9yqOr+eVEW1IDRpVPsaHXar8SNlMIjVGt1ScWhBhxmVe6b
         urRiqRSTIBUu1IgEdmRWZgSo3QB63iPIPmf0w8IUZBw8PES4Rud3dFJlPkoic8MTCs01
         256w==
X-Gm-Message-State: AOJu0YwvOMaPZ+S1qRfZs4cDs4kQNKU5weeojgPpUxQg0GaeYytmwvaQ
	0FO3l/GRIro+Bs5YTz7NtC4Ao6Zbwb/4Svgy9jP8XFk7DuSvxLHxXcUk885Eu2cwOY2Ek6XaIwl
	Dt8G2BOX5anF0baXHa9UxGX18zfxdmQyT/llVpEFJpMUzrXD00SxBUFNJaQf0AH2qVZMUztId9w
	7WbUXBj8W+j0L/ra5doJ5R0OLighGmSfU=
X-Google-Smtp-Source: AGHT+IGfU1BqA9eNhyFKGEkjRPjnqWGxP1+pFP7NhnoASQHOzBziL/8YW7i3Jw6fiGBSzdHa2GQpOJgylQ==
X-Received: from wmoo8-n1.prod.google.com ([2002:a05:600d:108:10b0:477:55e7:9973])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4704:b0:477:a9e:859b
 with SMTP id 5b1f17b1804b1-4777327cb50mr64673825e9.24.1762782327801; Mon, 10
 Nov 2025 05:45:27 -0800 (PST)
Date: Mon, 10 Nov 2025 13:45:18 +0000
In-Reply-To: <20251110134525.3768197-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251110134525.3768197-1-tabba@google.com>
X-Mailer: git-send-email 2.51.2.1041.gc1ab5b90ca-goog
Message-ID: <20251110134525.3768197-2-tabba@google.com>
Subject: [PATCH v3 1/8] KVM: arm64: Fix Trace Buffer trapping for protected VMs
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
2.51.2.1041.gc1ab5b90ca-goog

