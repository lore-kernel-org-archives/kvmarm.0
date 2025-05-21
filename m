Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4EC0267B6D
	for <kvmarm@lists.linux.dev>; Wed, 21 May 2025 12:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747831868; cv=none; b=kTE1oDv8FmE87UADJ+hG3khhIy3FyuBPwkgR5lgIsH33UM2el0XWWe+hlgrBXIoVy/nOlaLkh/MBjeYlPRwiSwI/ERj7wdrBu8yPIlZyRZgk3RTL66X7RGxgXsGszxj1z7ShEjkWBY4HKLkUfPBdepLGF2xrnwJxNIhcYeTAnWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747831868; c=relaxed/simple;
	bh=i60uoZKPYYZP5QG1SLs+Mxw0GCgSs0Z3YuYOlmJgTz0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Ws3ajTEIyMgOSAZuV8S83sMo78SykC6TeygyTbfXAYJWoWnA2mp52IxGNDW1ji6wzjD/wC/DpE+zwxwy0hloG4GbkTXg+j6CJdoegmEuybzsfdCR9VqZqULxg76Ug5q94nsXMKRNT5gd0awrAgEKAod+0cA8E11uX0xyikNDQ+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HOGjkHAL; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HOGjkHAL"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-3a1f6c5f4f2so2625034f8f.2
        for <kvmarm@lists.linux.dev>; Wed, 21 May 2025 05:51:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747831865; x=1748436665; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mT8By12179daVSqWK2hMkVVh9hr6dmc7nTaRRdzemjw=;
        b=HOGjkHALqGQqprgeKdVLgi5M89mRFSswxJY/PFkUh6AnwNgKxFVwmSiLFnxedEliQF
         LZ9VlBiFSEa3diNSNXJW5KywS/dx6UAcryscYHRA5STa/lXJrwgCpUzFZGmCxUI1H2bR
         e+i7Dn68lj9chOyz5d05A2jCQLQ2rVSZpcRGqUnQuHAskIIgdURg5u8/2iyW3CBtlaMN
         KygtBxgyDY6RgCWge3uQD9qW2tXOTTeVqqkIXNdQ8xDeD0AATDrrZm9DSFvOYfgIiB9f
         Sk759nMBQgAgXFAgtlroyf6dmDrMaRjvXQ8Kusrt1DakmVMMSmfw9S7aQ6yPpeOj66ll
         Gi9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747831865; x=1748436665;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mT8By12179daVSqWK2hMkVVh9hr6dmc7nTaRRdzemjw=;
        b=r0E5eaue3Jygo6xpbF4rRJ84DM5QOQR3mZr9LjYMr59mC4Z0Vt0FvsYXRXfLYyLsVH
         JDhfqiKgypAw4GCt45ARI6emfwUzop2WIcau5cV6x2iiDgFJ6tdkMLTThTb9MxZyTH4X
         e6tAPe8aNxFqr4WzvKkQ8nttpgtZgOaENVKDt+OORcmux5Uw+J0y5XaTdsVOxw1T/ajY
         iXWlaGHz4kYLmF2cIE51TrvbeU+hnNQezcJYgNX/ei3avZ+Jev+NXJA7fzI3/2nDwMPe
         wg6SyEtO6LuwwxTOUFWmC60ftRxUIU2zDkLDZ3DJDHR9XRwPIleJPIHT27Z2d280xuzv
         uHig==
X-Forwarded-Encrypted: i=1; AJvYcCUr1askaqqcq2bIwFZxSs8wCe5RqZbCMfj+9sMNd3oVo/DvIoAKo/w2LiyBKeNVphRpnQNQfEw=@lists.linux.dev
X-Gm-Message-State: AOJu0YyeZjCCFBq6MZGqlF9PxKHM5kfgMPG4DDuG6OO1DGnPB0BytEHG
	4p7EJ9TsJKnGVFCVVX42/TL3hHW8U1ojKBNhQZ9SLXUAs3TJpSXSoNzfdPaMemuLF0h7GTQKJeL
	Rgx58OCVyymI85xImiPfsKA==
X-Google-Smtp-Source: AGHT+IFxvQXC5e2XyrcGIorm9ck7St5THzNwlwqWNw3VZYKE1iTJWfhId/APZ3vzvHKNI9cTFqGba3uEmZNIfYCd
X-Received: from wmbjg9.prod.google.com ([2002:a05:600c:a009:b0:43d:b30:d2df])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:2384:b0:3a1:f684:39a7 with SMTP id ffacd0b85a97d-3a35fde361amr16068713f8f.0.1747831865060;
 Wed, 21 May 2025 05:51:05 -0700 (PDT)
Date: Wed, 21 May 2025 13:48:25 +0100
In-Reply-To: <20250521124834.1070650-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250521124834.1070650-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.49.0.1112.g889b7c5bd8-goog
Message-ID: <20250521124834.1070650-2-vdonnefort@google.com>
Subject: [PATCH v6 01/10] KVM: arm64: Handle huge mappings for np-guest CMOs
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
index d1488d4e5141..c18d4f691d2b 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -219,14 +219,32 @@ static void guest_s2_put_page(void *addr)
 
 static void clean_dcache_guest_page(void *va, size_t size)
 {
-	__clean_dcache_guest_page(hyp_fixmap_map(__hyp_pa(va)), size);
-	hyp_fixmap_unmap();
+	size += va - PTR_ALIGN_DOWN(va, PAGE_SIZE);
+	va = PTR_ALIGN_DOWN(va, PAGE_SIZE);
+	size = PAGE_ALIGN(size);
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
+	size += va - PTR_ALIGN_DOWN(va, PAGE_SIZE);
+	va = PTR_ALIGN_DOWN(va, PAGE_SIZE);
+	size = PAGE_ALIGN(size);
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
2.49.0.1112.g889b7c5bd8-goog

