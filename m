Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D287203D53
	for <kvmarm@lists.linux.dev>; Mon, 16 Dec 2024 10:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734346289; cv=none; b=p8eEkh6rIzQf3nqR8/vAub1Sa9VpmOJ59whmbqdxAxt6bE9YpKJc6CV+3/dB+X4UiUy7x5OeYN8WKrqwNYplgYZddKbzeVCIOB5pzKTC6W3jPEG3/6wII8kUo8W/F5hNIrPMK2S0OFkkYLRen+6PibL/MoVVoQaRWTAPPLkyHZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734346289; c=relaxed/simple;
	bh=/oPNuf+jYK5LM+watKHkZid1epmAvOkQlxWdn6/TKdo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tcmEozKFrZTHQwyGalopim+QtJkeB2z4OnKGhmk+GLJKiaMH6tK0pdpoDE3X70Bu9Gb8WfGGFNJDeXD4UbCyK5j6h9DNknAR5686K5reDgVDpsay1neXPv9tcgoh76Pu1mt7rzkf34rdJcU8J/wjHQDIF5ZqBnLE1Ib9f3K4h3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RiXqwA4V; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RiXqwA4V"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4362b9c15d8so14790045e9.3
        for <kvmarm@lists.linux.dev>; Mon, 16 Dec 2024 02:51:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734346285; x=1734951085; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KlRETVSAd+jtsJNx5YFbu0HDOE62z9vkIYE2WXDLJhM=;
        b=RiXqwA4VebF9Ly3gfflzt+zTZ+q0ldsZ4i7K3f2LATUExPQ/x0jUlJPCvXf9aEGedc
         yWdbcKKYM6HgtuLuRUNQR6AUdbnvagmJ5LTMo0P8ChT6h0cr3i6L+LV3+DmpNAVnoyZn
         doGf5+BWNiNdt6hfLVcukGnXLkTuz6Vclc5nTb2gtPvI67UjkV16wImb/JxIl7CN/WY1
         kAs6WKMiO7Lbfx11BykyFjUXdqdMpe6Pnq+KA2/ESlG2oFpbU4AEtgcB/9ll35e99JoN
         p0obFkyit3nNQvsb0lpq7w9SCPv6d50uWLqkCfM2zXnSlDPeZsWfObRW347j86e3xWa7
         qoKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734346285; x=1734951085;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KlRETVSAd+jtsJNx5YFbu0HDOE62z9vkIYE2WXDLJhM=;
        b=nAawg1XWh7AEG8X85MtW/pQHGmfrkqKqRdN0MSyFEefDVIRgJHzkEygcQyHFyJkCTY
         dwQJtcdDzXIOQTBzKV2vkpIkgl2OxcLxIlrm19NokKTmw4j5zyXZIARFoDIlddu5Du9B
         IUHdI5+h4A3hpBiHh88DoiNqJ3bgPurGPpjLwR5AvGy4GWX6XOFo7Kjth7sHYxgjIVZo
         rqjCdyAjW/oT/Un8EprFeRGy4teyrWLWViM354Je6FADbiQoR0OZNzXWxMSYwPqsLqrK
         YQs4x/kJN2QVOgg5ap2WGFoNg5XsQnExmOSzc3GJ/R5s1WK4f61uE28SnKm5tBcJaYnQ
         G5ug==
X-Gm-Message-State: AOJu0YzH0WX0JVN8KcouXAsHy+Ry6PBaxCAyCmgoiCTolQ0ilSAVwg3d
	1dnK4afutMOh1TOR+A3zmTTiThfCLq7fscXdcqfysu7DguX6W8s5QECKmHmnwfRErBTcXj2lLxN
	u9usuq1E2kGRN1Nj44oOWVVpE+hdPTQnjc3Mkgyt6Lq944cyKrQsZh9wAtYP8RH9+k1ZsvhlDIF
	dhyCdSEZJdNg9lgA6+EAaS8NDIFf0=
X-Google-Smtp-Source: AGHT+IHaiAnCqJjam/xPbGIlUjPkbW/JNT3nelKe6+T4YUlS/5PjJrIWPgIaRiBdeWjDa4HOa1sa9Fkg8g==
X-Received: from wmlf18.prod.google.com ([2002:a7b:c8d2:0:b0:434:9da4:2fa5])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:c18:b0:434:a1d3:a30f
 with SMTP id 5b1f17b1804b1-4362aa1b8c3mr101870875e9.6.1734346285438; Mon, 16
 Dec 2024 02:51:25 -0800 (PST)
Date: Mon, 16 Dec 2024 10:50:53 +0000
In-Reply-To: <20241216105057.579031-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241216105057.579031-1-tabba@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241216105057.579031-14-tabba@google.com>
Subject: [PATCH v5 13/17] KVM: arm64: Refactor kvm_reset_cptr_el2()
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, james.clark@linaro.org, 
	will@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, broonie@kernel.org, 
	qperret@google.com, kristina.martsenko@arm.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Fold kvm_get_reset_cptr_el2() into kvm_reset_cptr_el2(), since it
is its only caller. Add a comment to clarify that this function
is meant for the host value of cptr_el2.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_emulate.h | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index cf811009a33c..7b3dc52248ce 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -619,7 +619,8 @@ static __always_inline void kvm_write_cptr_el2(u64 val)
 		write_sysreg(val, cptr_el2);
 }
 
-static __always_inline u64 kvm_get_reset_cptr_el2(struct kvm_vcpu *vcpu)
+/* Resets the value of cptr_el2 when returning to the host. */
+static __always_inline void kvm_reset_cptr_el2(struct kvm_vcpu *vcpu)
 {
 	u64 val;
 
@@ -643,13 +644,6 @@ static __always_inline u64 kvm_get_reset_cptr_el2(struct kvm_vcpu *vcpu)
 			val &= ~CPTR_EL2_TSM;
 	}
 
-	return val;
-}
-
-static __always_inline void kvm_reset_cptr_el2(struct kvm_vcpu *vcpu)
-{
-	u64 val = kvm_get_reset_cptr_el2(vcpu);
-
 	kvm_write_cptr_el2(val);
 }
 
-- 
2.47.1.613.gc27f4b7a9f-goog

