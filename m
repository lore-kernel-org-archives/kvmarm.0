Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7B4F4CCDD4
	for <kvmarm@lists.linux.dev>; Tue,  1 Sep 2026 08:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788250205; cv=none; b=Yep9/E2mFjtOQC9h+6Hzxdp95gDwJSSkAEFBfWG4fZpZTQvTJvjrXI8hyrMCUhJAqXmAqr0r66gHhm1Sue+5F5hyXE2OX1mEGKak3/rOFfAl+kFvMDlx7xPJ7e+alFwa7ziVOc1iPTnxlSVpqBvLgLE3je5J1T0vhoiN0btYg6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788250205; c=relaxed/simple;
	bh=Bz/EwSKkOmFLk8gNhKT3aq7eVAxopTMJvJTawHDVAqo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=B3H2NNn20GBSwfMaxzt+uxYARtoIliLE8WrSmUk228PlUhgJ/T7hhaH5xSiv4evA1oIKc9gRkZQI3ZvFyuMdInRWgNXnWxZqZHI7oDGU/JgYQy88BHsEqnAD0A4eZpGhfBnQ0UrkeHMe0r94iujYYphCPXOylAt9Z+WpnmcTX8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UzZcJVj7; arc=none smtp.client-ip=209.85.128.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UzZcJVj7"
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4994aebe932so43622555e9.3
        for <kvmarm@lists.linux.dev>; Tue, 01 Sep 2026 01:10:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788250202; x=1788855002; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nL1guVDD9UTKGUkKf+l7bjgonMYEE9LjjwttOmgr0Yg=;
        b=UzZcJVj7Z428ZZL1J1k4sU5IJhjbHM+QwVnkAWPsTdxArGLNNasWUDHM76X5VYIp2o
         u+qitYVEjay5HCOEX96MSkzZ3PQ0WGAdxD7X6swifAGRbj0Cz8ZfGYpE4GRDgOANqxVl
         7ybZUAoNVtx/b5NtJrbJ4SIc5O0Ru2yFeUyW685jBqAojXZ2NGjEsrb95G16G3sutXzM
         k5QF46imWtxbrGTNNjVCg6o/2SowuD8MLfEJME7wKLbvGbn6Rt/XLxyKoYbqPeiF061p
         SqudlhSv4cx2g20jVin1tVtrDsqgPSkf43OPzrVuIwfvQpXqx59pO909YQsjo+D9+yHa
         iuPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788250202; x=1788855002;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nL1guVDD9UTKGUkKf+l7bjgonMYEE9LjjwttOmgr0Yg=;
        b=YQbZj76HvekUbfbH1h7xHINoyUYyqm+8unIP3hDLCwFaewPs9czjYFxYnna4X+JHJL
         1czseLrhwrwjAVRAwQhqTv8+43on1StuPyUOH4j+PdeBnP+mBVgkaxGb8vlDd+UnPqvn
         l3FU/ms8FmK5II706N1oLNq8KDvM1qSgfTcnpMO/6t6hZdOmmRrNsgaM5ju6fbTKMYnP
         jUkUI5Jz4uqyaeFsyobd++2fvlMr6n5NQQkeRndnfCkmi+RbiCrjkYn720UywVhjJ/BU
         i0eriprfp0+fEnD2G3y2khQxyRFMvnmpqhpt07IOBxuJW4cKkCOEY0U7Pi7872s2cPnp
         txog==
X-Forwarded-Encrypted: i=1; AHgh+Rqg+ZCc13NtryCJ3yD19n89PBBu/bY24oOngIVmRQK51xr7Mmi5V6QVNT+MLW9MB3UnunmAjIQ=@lists.linux.dev
X-Gm-Message-State: AFuF++lJPqGhjHeXs1fGJzFTrwfihVbl71sS3fNHpFnJQouXx3K0LgZf
	S1um8I9Xwd9cQUjPD+vXEv8zcJthdkqMGNXkKgK+XA49J6n/JH+j/6wBH9o/n6K7m7LH8G0NFMs
	xHminOIk/hbtWAP5mgxRTUg==
X-Received: from wmbb13.prod.google.com ([2002:a05:600c:588d:b0:49b:e69:99f3])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4fd4:b0:499:83f1:398 with SMTP id 5b1f17b1804b1-49cdc59f62emr114474425e9.9.1788250201805;
 Tue, 01 Sep 2026 01:10:01 -0700 (PDT)
Date: Tue,  1 Sep 2026 09:09:34 +0100
In-Reply-To: <20260901080941.997769-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260901080941.997769-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.897.gb25b4bd76c-goog
Message-ID: <20260901080941.997769-12-vdonnefort@google.com>
Subject: [PATCH v5 11/18] KVM: arm64: Filter out non-kernel addresses in kern_hyp_va
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
index 6eae7e7e2a68..d89864c4b961 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -126,6 +126,9 @@ static __always_inline unsigned long __kern_hyp_va(unsigned long v)
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
2.55.0.897.gb25b4bd76c-goog

