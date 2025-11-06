Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F9F13321CF
	for <kvmarm@lists.linux.dev>; Thu,  6 Nov 2025 14:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762440262; cv=none; b=iYSvGfrBZYRqACdz5VJnItCxgmBIeK48f3sgMtRzVdqcvXzHUQKU+vvpi7uwq0erGi+aUWq2KQ2a9172Eh3rdmF17F3gkc4jJqFbEksMiPc5xtUpv2Ktf/acFTadAk3l1F8L3rz5pi6U2EjKRFsYlqoU7Hl50gK3A7B7TbMfz6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762440262; c=relaxed/simple;
	bh=fPGy+Qo6hQ4O1ne5b3sAZEf0TK6EzklkWv4OjN0CfJU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dXo3r4G/yj3myMQwxk1ydcKASGj5cHZrVG4R/3Nj9Pq02vz9pSoUFlzvWYP8meWA2NRfLq3pJIaaJDtNAV9YiUihhMFJ5dFeEKy/DCIIVqAKtY6b4hXBX0jFXl7ghxqJ27pnSVtsrRwAVGStNzNpttzHLxij/+IyDqC3VUbgo0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ophk9TES; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ophk9TES"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-470fd92ad57so11180325e9.3
        for <kvmarm@lists.linux.dev>; Thu, 06 Nov 2025 06:44:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762440260; x=1763045060; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZxATvlfrAs6kPTkjH086Q4K5vdnLQEYuZzyZbmCochI=;
        b=Ophk9TESwu7TFF28j0ORo+/IPfe/htA7+Hq3dUxyBxRRJaWY5bz272q5F6nBEkzNRy
         P2cL8IZ24kxObzGRbithwIWCAeTAN4xmdmAi7xBB6WOnn0j5/XrCcheSt+ZajgXyi7pr
         81+9uWQ0eVBUv93kxO2BrN6l4VD7ydGTH2BpEdKMTKI71s+KZBWpG9OChfjGXCz9X3FN
         hy8CLx/eZnWg52rAXZAT9hQZt+OO3J37R02lSsOIgp7xIhUKTeJD7GJYRjyIeYIkB03O
         BtdxP1bdOe6sbsuB7+Kg5mnDCnR7M28VfTloRyauXIqMkv8AFodxvsgCmWQYk2DJyUpc
         zxtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762440260; x=1763045060;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZxATvlfrAs6kPTkjH086Q4K5vdnLQEYuZzyZbmCochI=;
        b=jEW5IZlk733Uf8gB694PsQI2ziDmSuKTaEyhW8RHWBXFmrqSJHiBnthqIX/nP/WoUg
         0Z85/A+4/gbf7XvH6CdezY6aL7y3a4XxQvsMo1S44zSmmayJFcmp7u/s4AKjMpCv9aiA
         qPHoJA2mxWYYYiTpz1vuplypnV5remIVsXU2ZhX94LM9gqVDlI5oL+M70v1mKxeEzPMX
         y3Q3SDn9jmhLGuFKOHJPbgC9BJD3j92BupRLhhC+JDW1LzoQrRkifCgc969YlNfZ4xX1
         7XdA3PihXO06Yx1EAXWqM4oArfeXBcBKMK/eotnIrtTM3Xsfzx8bX9dTQ5kkwKqx1JP6
         GOHw==
X-Gm-Message-State: AOJu0YzQsJw5tDJCdn2imm+mm2bt93OXeGL0prED2275VQljLzEolY6D
	sSptiNognPhUewr/Q9sWKN4U1Q+EddmCOEsmCwzgeRFWnzN9Gded5fG6xJcTN3ZQCcS/oN+PoQi
	Gn6A7DJw1MBFXTEcxWtRlQr0aYgRwQQqjgiqZyL1wWVKZTrPUvoi5awB9UKUOvl255mdNiydP3B
	iosmAXDuUy02mbR4vxccfKQKt3zQrJQKA=
X-Google-Smtp-Source: AGHT+IEVyaIwoMfP0yfMDIthHFjuU2aK5E0vvak4krGXtReD/5DU8J3wL4/vur4Zr92jt89ZLLm5pAOlSQ==
X-Received: from wmbz16.prod.google.com ([2002:a05:600c:c090:b0:477:1208:651d])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:3551:b0:475:dd59:d8da
 with SMTP id 5b1f17b1804b1-4775ce2b673mr73956545e9.40.1762440259695; Thu, 06
 Nov 2025 06:44:19 -0800 (PST)
Date: Thu,  6 Nov 2025 14:44:13 +0000
In-Reply-To: <20251106144418.2847443-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251106144418.2847443-1-tabba@google.com>
X-Mailer: git-send-email 2.51.2.1041.gc1ab5b90ca-goog
Message-ID: <20251106144418.2847443-2-tabba@google.com>
Subject: [PATCH v2 1/5] KVM: arm64: Fix Trace Buffer trapping for protected VMs
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

