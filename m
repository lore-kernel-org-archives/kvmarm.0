Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B91DC2951A0
	for <kvmarm@lists.linux.dev>; Fri,  9 May 2025 13:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746796636; cv=none; b=CpybMfeX4I4Ihb/o442xrUmAkPqgnBx9KanfMeDcReKfrhI5uVNQj8s6XUq4XbP/VEKYCG2uLVYmdW46fPlJOsYlVkVczJ4v/agb1UkVQUnrhCWGxnuujVyYKpbQhObXUEkDluiBzc6Cy++YYau8PNBId40pSDYSoMQq03Hs8xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746796636; c=relaxed/simple;
	bh=1KIC4nYkrn3JhyQ1inoc70Z27yDXEBHxrexWlAto368=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SD0Meb0R8JlblG39p7EAnJfgPx+ZEAmqXSHkasQ+9/dC5pDhD9aVqi1i2gQ7Kg8VBY0T5k4m+5rl+eOpRI0QwJQKyZVDR5D9RHweRItHmN+PlHD2pGRHLE4uNccV1aMATXJZPZjtCeUlApywrwM1Qu7l8Xgu+gnFiJLgoe76/8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nRWzlplk; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nRWzlplk"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-43f251dc364so13098265e9.2
        for <kvmarm@lists.linux.dev>; Fri, 09 May 2025 06:17:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746796633; x=1747401433; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=IP6ztp/+QPDQJCJndD5+6IALkAYC7lh/LyjGCv4sMT4=;
        b=nRWzlplk5ULi2A4Ca+85F2sA1xNail0f3/A0qWymeUu+hhbAgGkp3oUa0XfPGcDSd/
         yPnVagIfP/XciopqL2mGYDo6cgyfV/WLv8P3vjAhVNvy5Swrm5pEnpPNvaEuknSLuH9l
         cI94J9HFmwEXgCVDT0vqzseQ/7xqJgKDaedAiCZathh7+7y8HQkcIViEmXcdftCMYDEQ
         FSbbmMQjBDnxhRxWd0nxhBLYxKY37mYeDgItSB4cujPFto1BRKUwKF69xWpZapvZdbB8
         UGTDFqFnc18Anu6o0TR/IfQAfl6GJdgCtMR4QlFbVSgLB2TXzZDa7fDVTZ77G93nS6k7
         gTaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746796633; x=1747401433;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IP6ztp/+QPDQJCJndD5+6IALkAYC7lh/LyjGCv4sMT4=;
        b=GSl3mtcmvX8YgOEnMy2mq9cR018EqGcbV416tJKWQIr2h2HE3nRkRfPuJr40ULpham
         ci7gCpgfQcD3HJ0lzIOpqnmuWPZ+KVrUqz5JTg14BZ3kaxmmJfCY2W9/Y5UXc4Y8Hg5k
         WSLNqRmUkgn8q7JFRaGMsy8dTw8RrLlkCrp0OmanVI7Fa3UYeSIWQGoz7TWbjwrfuCCk
         +1argndqnbH3dV05y9THC7a3XYnLDgLlDeyvl8CZ+0pwXRiS7o2gGdf7g+vR8M29enBh
         JTLrWrSR6vt10otP4b2/E5lv8hK/x/WauNK7WCt00+CMCSrMLDYJma2Yf/eakK6tEjkn
         g9Iw==
X-Forwarded-Encrypted: i=1; AJvYcCWlGflJbuxsPMDo9iae5PjVrLAXrTnHi1fSlPyL0X6kUQazOJb9rVYqMBoXSknC6ZmSzCuvKP0=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywpwine70cAc5tIyzDUSQogHGefqMO7VcxawEaxF3dj7ufhxLpz
	pSnfi4Y/Z1QJ0vOhAMWm87B5KLfwJcbpPY59dwpwlBGciMCoBQLEyMIhleMEUiEh0u1zzXvskdo
	XNfI+pw3stMDmtRlezg==
X-Google-Smtp-Source: AGHT+IHLhslOxv//qelYYDwLSjir28eVrMuxSKOMq29v/O516ODc7zyiSCdmfJB48+QjIQHo3PdA4xoToUMrdg/4
X-Received: from wmbep11.prod.google.com ([2002:a05:600c:840b:b0:441:b3f0:c46])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1e02:b0:43c:eeee:b713 with SMTP id 5b1f17b1804b1-442d6db8d1bmr24441515e9.20.1746796633145;
 Fri, 09 May 2025 06:17:13 -0700 (PDT)
Date: Fri,  9 May 2025 14:16:57 +0100
In-Reply-To: <20250509131706.2336138-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250509131706.2336138-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.49.0.1015.ga840276032-goog
Message-ID: <20250509131706.2336138-2-vdonnefort@google.com>
Subject: [PATCH v4 01/10] KVM: arm64: Handle huge mappings for np-guest CMOs
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org
Cc: qperret@google.com, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kernel-team@android.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

clean_dcache_guest_page() and invalidate_icache_guest_page() accept a
size as an argument. But they also rely on fixmap, which can only map a
single PAGE_SIZE page.

With the upcoming stage-2 huge mappings for pKVM np-guests, those
callbacks will get size > PAGE_SIZE. Loop the CMOs on a PAGE_SIZE basis
until the whole range is done.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 31173c694695..23544928a637 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -219,14 +219,28 @@ static void guest_s2_put_page(void *addr)
 
 static void clean_dcache_guest_page(void *va, size_t size)
 {
-	__clean_dcache_guest_page(hyp_fixmap_map(__hyp_pa(va)), size);
-	hyp_fixmap_unmap();
+	WARN_ON(!PAGE_ALIGNED(size));
+
+	while (size) {
+		__clean_dcache_guest_page(hyp_fixmap_map(__hyp_pa(va)),
+					  PAGE_SIZE);
+		hyp_fixmap_unmap();
+		va += PAGE_SIZE;
+		size -= PAGE_SIZE;
+	}
 }
 
 static void invalidate_icache_guest_page(void *va, size_t size)
 {
-	__invalidate_icache_guest_page(hyp_fixmap_map(__hyp_pa(va)), size);
-	hyp_fixmap_unmap();
+	WARN_ON(!PAGE_ALIGNED(size));
+
+	while (size) {
+		__invalidate_icache_guest_page(hyp_fixmap_map(__hyp_pa(va)),
+					       PAGE_SIZE);
+		hyp_fixmap_unmap();
+		va += PAGE_SIZE;
+		size -= PAGE_SIZE;
+	}
 }
 
 int kvm_guest_prepare_stage2(struct pkvm_hyp_vm *vm, void *pgd)
-- 
2.49.0.1015.ga840276032-goog

