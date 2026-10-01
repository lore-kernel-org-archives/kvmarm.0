Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2ED551B169
	for <kvmarm@lists.linux.dev>; Thu,  1 Oct 2026 14:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790864962; cv=none; b=INlBhuOc09R/XUjvtNSJTZcY3TjXkg9mfWiNb2XTLaqP7nlfdVPRyLDoRLJ/XrPz+0CfCtfbPDhasS1KSWCnV0WLI7PwaeCnsqw7cFx+du3dQcCz2XKVDodvYj20o4l9puYH9AcDw0pFuoLPowe0PHhGtHbsiJQTz3yzF554xs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790864962; c=relaxed/simple;
	bh=HXYv2Nlt9sZI3hswVRRAT339+AHP7HnTpMlsrdZO7Mw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=J3Fx2f+8Dx73jZ9KDOSmgh7jBrRY0JCALQRsGC1ctt5CbCAJwNLx8KVH0tWD0pOuOVc2AU9RvrmU2ppTlxJsPn4aM2Ld2zMr/Z3S4Rp9byBazMmmks0D5fJcLlqVlNkQS5e1gRfASqrqA8HzdYNwmEPNbE7uxL/KJQsIAOhvjmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Il+YunDf; arc=none smtp.client-ip=209.85.221.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Il+YunDf"
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-4870af30a85so848020f8f.1
        for <kvmarm@lists.linux.dev>; Thu, 01 Oct 2026 07:29:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790864951; x=1791469751; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yEFq2rr5EDnNpZBggFgHhQUVCsgLj0Cjnpte+1iST0Y=;
        b=Il+YunDfV1JprhQsT/e4bUtB7tcq2y+jM9QJbTdXw23LNvc64+PbSbqZbUdeivkf6W
         nQfBt8P1qgrLcXezkNSWUlXLkuMFxeO4ID2AMdbkrYaeLFgW79JiNHrsiQBYAKEu5fKQ
         JOdF53CMKkH1FJbeAjhZfc6zzPBVr7JTECOxaZV+wb537nX4zssYTkNwU8q0efdVv/Kx
         0/jvOa+ssCx9tI2eRFzoz83vOXnhPYf5HejovpgOflHUZjlX+DMD2F9RsEwr6X/aOJFg
         OuBfLq9/hMyToS7yBd1ezOXesiha3KgiANyJPskN/9aBIPp7k5AtYxl584OoK74znZGL
         g8MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790864951; x=1791469751;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yEFq2rr5EDnNpZBggFgHhQUVCsgLj0Cjnpte+1iST0Y=;
        b=Ofr/24E1Sz8awUkHEdHbkSWQ6EI+eo8x/f5KwQv7Lglk3YsdCPzgRFDWzcbsQplPMH
         /HJbdtqhYeh6RqRMGiB9HGtz8p0dHTa55mMpKvUBBeqWywcS6KB5JQ11k/gr44jd1igP
         65T7zjRRseu4ta91+dRppY2+8G1PHmxYVneasxmYY2YI8ZWk6UsZFNed81nKu8/kriP+
         4GTGuNmXzZ9xD7/LW5xmRrS5LKnUhDu8OyZlwa96w3ZRyTqPfQVt0fdUqff1liVcwmcs
         i6l0YkfQcl0Ql4cRrz1gx1w9nAEc7+PBgwPvs2ckTTb/nRsTNp+kCfahy3Gf2okQP4en
         EnUA==
X-Forwarded-Encrypted: i=1; AKwUvByHt+kDzq8W3RFSSSac9xsW+qLUVsNZpECQJ29NHDzs3tqwBV7DQAxyil4fZkBZ7Mz1xtnOHL4=@lists.linux.dev
X-Gm-Message-State: AFq9FYJuZ6LXu2Vt1et6aB6ZkTHHMaaxi6dfq1P8NGvrP30OUNtYy1ym
	+7zuhNxe+pfq9TCI7xTqsN8d5hUmgGrMPVZ8KKFhMvVPMmSJUsd1R7Nnbkb8XOeliW3BP1degmx
	eVkGt/Je+Wr084tcApQLtRg==
X-Received: from wrck9.prod.google.com ([2002:a5d:5249:0:b0:48a:fb3c:e7c3])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a5d:6791:0:b0:485:8ea0:da8c with SMTP id ffacd0b85a97d-48b068c7fd4mr5362558f8f.16.1790864950779;
 Thu, 01 Oct 2026 07:29:10 -0700 (PDT)
Date: Thu,  1 Oct 2026 15:28:42 +0100
In-Reply-To: <20261001142849.3367614-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20261001142849.3367614-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20261001142849.3367614-12-vdonnefort@google.com>
Subject: [PATCH v6 11/18] KVM: arm64: Filter out non-kernel addresses in kern_hyp_va
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, 
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

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Tested-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/include/asm/kvm_mmu.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 57f65257bb56..04d9f59db976 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -128,6 +128,9 @@ static __always_inline unsigned long __kern_hyp_va(unsigned long v)
  * replace the instructions with `nop`s.
  */
 #ifndef __KVM_VHE_HYPERVISOR__
+	if (is_protected_kvm_enabled() && !is_ttbr1_addr(v))
+		return v;
+
 	asm volatile(ALTERNATIVE_CB("and %0, %0, #1\n"         /* mask with va_mask */
 				    "ror %0, %0, #1\n"         /* rotate to the first tag bit */
 				    "add %0, %0, #0\n"         /* insert the low 12 bits of the tag */
-- 
2.56.0.rc1.315.gc6ed9934b7-goog

