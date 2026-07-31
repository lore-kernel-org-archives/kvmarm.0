Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com [209.85.218.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C053340A7F
	for <kvmarm@lists.linux.dev>; Fri, 31 Jul 2026 14:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785508570; cv=none; b=qT8a1lnSr5gdaOKndCTDLeUZpk1qAcBXyCueIKhuK6B3DImqdRNre6pXd/om1jNyYVBki0gyoCSrCeMciUVivAPmG8nUUFb0SJQ97EUI5159krx26W51RoPTQbbgVem7PwQ4tmurSxOMh77bfxSnVAzZRz+cV/poZ1glTVJ/MSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785508570; c=relaxed/simple;
	bh=ApcLhCTGABI9Et5QTqXaXXov+j+TVLJ3mB/Vl2knLls=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cKMxUMKBz5TLKKQt9Fze0enTai1ojw0fdn3bIN5M21Y2T2KmXM4niyiytE3QwiNuR3lBqlt79D1lo6zBiRdWW/mpXZJS7imil9E9XKwBosua0Nuv5ZZ4+rc2LQikhcJysAg/pUgqucA3vkhj8u2ZFhP4pgwobGO32z5N2u0kU54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=L4RCVZMd; arc=none smtp.client-ip=209.85.218.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="L4RCVZMd"
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-c15fed5653eso80716466b.2
        for <kvmarm@lists.linux.dev>; Fri, 31 Jul 2026 07:36:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785508567; x=1786113367; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Q/CZYwUqsZsC4WZkgw4eFBh78uOJi0Jsf+zut7EQDaI=;
        b=L4RCVZMdQcM+pp/nnbPHZnEWgImrQF4+h731R4Rxmon5qD/Vkhy7B+xDPyUeNGFhGB
         Yl+OYhC+2pe0fm/BqBSQjp4y3qllyXd+XWhJ6Yu5Qz47abU/zsHjIRELyL3gVNmFnz4Z
         pDHYXyJKNuEtdgyag8T95f8uaPeGe3kvlvqiHqZTGW1TUAo/mD0Jcc7iCPMbchQ8MEfd
         zjO56tEELM6UzpnxzfNQ7LxeCSmSjKKuzIQia50d8KRy+zcdleg+d/ZUbbn1YA6ERg4I
         CQZFZpzpLx2/Oz9jGWCUMOTX/I8vtKkL6goKRyUCeEje8Nr0HrHEoFyBQf6UDCdp+u6P
         kDjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785508567; x=1786113367;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Q/CZYwUqsZsC4WZkgw4eFBh78uOJi0Jsf+zut7EQDaI=;
        b=m2ddYs0LXg0JZy9KPMQ1XihFzIQqZ5FvOTyue1AOSam4lA3G9MMAYtU+qn7EV1IJYv
         iuNapjWsm7pfJm4nLX5dZOpSG1sfJcyhjIVKN/lsi8vvjGktG2T4ro0Z1D1vKoVyiTxN
         KZRKanFaQ/WWjwvwA3kHF90+J/XNNC95jtRCN/61jutOMP+6LHSzJfycwQa9VPvbU3vn
         zuTEBVfcriLDo7xJ2nXymwmfd4GXc0qbxijeH5dHcSJCs4PvU+OqGdmlvdplzyfhqz+x
         NV201olHIyleqsC5V/3YlmT5oE+ePgcoOUFX6FDULNTh4gCyT0u2GOV/C2NJqGZN438Q
         lA6g==
X-Forwarded-Encrypted: i=1; AHgh+RoB86HDndV/BKE5liYSdqW0jAIXKyJvuDpH8lD6M6572sVsEvGcfrZrYlRQ0SoeQb0vX4HOaRk=@lists.linux.dev
X-Gm-Message-State: AOJu0YwAyfAhyXh0i8IVDbGKUyY0Q5Elr3A8Sl6yKlvO2kqIxDjbuFoW
	emszb0bmWy2wK1gIzCkldSN47hu45a5JOok2DiHfzMm5O4LiFWYbw9E1vsa7mPSuhdXQw165C32
	4WEGo2MqMQLyew9GbneP12A==
X-Received: from wmqg13.prod.google.com ([2002:a05:600c:4ecd:b0:495:5422:15f2])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:3d09:b0:c12:67d2:3d67 with SMTP id a640c23a62f3a-c1fd28aeba8mr131003566b.45.1785508567274;
 Fri, 31 Jul 2026 07:36:07 -0700 (PDT)
Date: Fri, 31 Jul 2026 15:35:35 +0100
In-Reply-To: <20260731143541.956291-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260731143541.956291-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
Message-ID: <20260731143541.956291-12-vdonnefort@google.com>
Subject: [PATCH v4 11/17] KVM: arm64: Filter out non-kernel addresses in kern_hyp_va
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, qperret@google.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

kern_hyp_va() is idempotent for the hypervisor linear space. This is
handy for nVHE hypervisor callers handling kvm_vcpu or kvm_arch
pointers. Those pointers can originate from the hypervisor space (when
protected mode is enabled, we don't trust the kernel and the hypervisor
uses its own copy) or from the kernel space (we do trust the kernel in
"non-protected" nVHE).

This idempotence does not hold for addresses within the hypervisor
private range, like the ones you get from the pKVM heap allocator
(hyp_alloc()). To resolve this, filter out non-kernel addresses based on
PAGE_OFFSET.

Leave the assembly version untouched as it has no current users.

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Tested-by: Fuad Tabba <fuad.tabba@linux.dev>
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 6eae7e7e2a68..d60e5f2de10c 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -126,6 +126,9 @@ static __always_inline unsigned long __kern_hyp_va(unsigned long v)
  * replace the instructions with `nop`s.
  */
 #ifndef __KVM_VHE_HYPERVISOR__
+	if (!is_ttbr1_addr(v))
+		return v;
+
 	asm volatile(ALTERNATIVE_CB("and %0, %0, #1\n"         /* mask with va_mask */
 				    "ror %0, %0, #1\n"         /* rotate to the first tag bit */
 				    "add %0, %0, #0\n"         /* insert the low 12 bits of the tag */
-- 
2.55.0.508.g3f0d502094-goog

