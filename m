Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792421997;
	b=sTanikHvY3SFu51KvyG4G5hefEErKn31RuLL43K+Iiw5p2TbP1qTbnpyGAn9LrJgkgMV
	 k1Eulu/sWlham1TBrld7o0uBUHOigUFnH+Mx+B/DOiwn1aVRNteN6sYI0vJpIN6dQgTmT
	 WwrefqnuB+CGjrIi/xhFUmZcWsTgdtzlVbBG3+nPj9zvfducEcYzOr3oGPB5z3knnCwIL
	 DSmEwtGuVMpfUBdIcf/RDNuPSlNfgjPAVMWsfR8gaozEw4bxzSokakC05gVM6JRK22K+X
	 nBYmuo96xNbksR7qzouwncDD0jMM/8ap766n6Ojtt8Aorvzzg6iY3xV0+pV2N4ed8IQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792421997;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:Mime-Version:
	 X-Mailer:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=Meq30BGUrGHp6xcOF0w5JprFYd5g2Y2UtUcpUpaVjGQ=;
	b=2UaOtoEK2AO3h/1N5Ob31AbaI1Sh/xp/JF0TC9KKnkDvfYBroZg+WgUXWxNhWH5rAnNX
	 rYP+JBcEMEpxdzPXXg2LEc2dIVR1CslIcCqBPgR/rEwQ0EV1kd0XTM2JGup/PDiupafIH
	 /SDnSkOSvpJlca+Hh+D/DoakQdlok+gF6XW2ynzb0vrUHGwYrr1lFWCpnFVxBqhbovWpR
	 X0Qu/t+1wa7mTy2Gwd0REk7DCzziFeycq8dmdNfvssnawB7Oerqw+jDzsOZTZKhI9ipNY
	 UIglMT40v4R+hmDFvn3DAxy1n8EJehEs8HaA2/CO+7QqOWBeZ9XDP1JNkA+AkfroPow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=sLDfJbe0;
	arc=none smtp.remote-ip=209.85.221.72
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D0F7607886B
	for <kvmarm@lists.linux.dev>; Mon, 19 Oct 2026 14:59:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1D0F7607886B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=sLDfJbe0
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-48b01a74792so1629502f8f.0
        for <kvmarm@lists.linux.dev>; Mon, 19 Oct 2026 07:59:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792421995; x=1793026795; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Meq30BGUrGHp6xcOF0w5JprFYd5g2Y2UtUcpUpaVjGQ=;
        b=sLDfJbe0oQgOaX0K7WJvqrSsd0R6dTUD8XeVNEUFmpcHwMJw/+ngznxpfVtvFeJYc3
         jwHU0d0S2KjvpiTJwHpnm9Y59Pgjqwekl+tYN9b4gfILg1w3GXfoWThDlQ5ggvYOWD/G
         4biKWrJGfRBPGlSz40HnFTjU7WS1NVkpaeNC85e5wX2TdKFto6fCDJHXqUpZpylhFWHg
         y0OVfHF/7zXYtb+/ItAvZRjpNwgqWVABaeZwl56m4i2ZtQaXqvkRxY9DrKRiHRGa8eUV
         ZHRcL+80Iq33pRDnJs2q4sJIZgVuGoVBBNRFSA5OoF7ydpWExR/ranLhd8uo/NkzAUyX
         hdvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792421995; x=1793026795;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Meq30BGUrGHp6xcOF0w5JprFYd5g2Y2UtUcpUpaVjGQ=;
        b=tyCxeLS7gWc1WmCg2Aj7zztj6mXJpK1x5otb/TPaPtrAiJAPIbBG/lgagWuZs1UNGp
         KWK0suHBUy5+SIEy+tycW0OTEbGbt9DuO8OsBD556evPI2oIZ5IL3utYVSGb9NB+beWx
         Gq0RuEKYF/dqJWgqkrkKwFfrIMF0mWK7Bt/Ls+t/Kgipa0RYV/SFjEdP46mE63UTtvLG
         RVQiT3AjKnM1WdSng2yECjrkoXtMdJLXo5y3lMoPUaZbiyHB0pluklE4ZzndN8hIvdfH
         8LrH0747M0tUMbCSrVgrJSQqa2iqR7de+g+3LdgdvDouM0PgBKqtDhkYZNAHVKeIP85Q
         m+rg==
X-Forwarded-Encrypted: i=1; AKwUvBwVpMjJ2ASrD2Fx2m+zGZTvDdRuDjdDztXIwISaNuSmfuB5KJa81zd8UCpA37oSlJtxgQPgn7o=@lists.linux.dev
X-Gm-Message-State: AFq9FYIiWO5ciOLAgfAVyx9iRYjZiBvW16uPPTj8ZWGjGSCgVUQLz5l1
	cC/I/Ftvm6Qd2JA8x0OLmwW8ezDm6gnIH5jxZexOmBzk9fWVJLQbZr7QnawOrvER9bc8xVJMMcK
	HlnFMTz2e5tVD+resiPztsA==
X-Received: from wrus7.prod.google.com ([2002:a5d:6a87:0:b0:48e:1449:1f6c])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a5d:60cc:0:b0:48d:f14a:9177 with SMTP id ffacd0b85a97d-48e07fb9180mr11409788f8f.56.1792421995213;
 Mon, 19 Oct 2026 07:59:55 -0700 (PDT)
Date: Mon, 19 Oct 2026 15:59:49 +0100
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.176.g3575e65682-goog
Message-ID: <20261019145949.1922019-1-vdonnefort@google.com>
Subject: [PATCH kvmtool] arm64: THPs for systems with pages bigger than 4K
From: Vincent Donnefort <vdonnefort@google.com>
To: will@kernel.org, julien.thierry.kdev@gmail.com
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, maz@kernel.org, oliver.upton@linux.dev, 
	suzuki.poulose@arm.com, alexandru.elisei@arm.com, andre.przywara@arm.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

The THP support imposes an alignment of the memslot userspace address to
the size of a THP (PMD_SIZE). To do so, kvmtool overallocates the RAM
size and aligns it. However it assumes PMD_SIZE is 2MiB, which is only
true on 4KiB page systems.

Use a huge-page size, based on the system page size. This value can be
massive for a 64KiB page system, so skip the alignment if we couldn't
even install one THP.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arm64/kvm.c b/arm64/kvm.c
index 36b3284e4a92..2c01dc32fa9a 100644
--- a/arm64/kvm.c
+++ b/arm64/kvm.c
@@ -18,6 +18,8 @@
 
 #include <asm/image.h>
 
+#define HUGEPAGE_SIZE (PAGE_SIZE * (PAGE_SIZE / 8UL))
+
 static struct arm64_image_header *kernel_header;
 
 struct kvm_ext kvm_req_ext[] = {
@@ -35,20 +37,23 @@ bool kvm__arch_cpu_supports_vm(void)
 
 void kvm__init_ram(struct kvm *kvm)
 {
-	u64 phys_start, phys_size;
+	u64 phys_start, phys_size, ram_alloc_align = SZ_64K;
 	void *host_mem;
 	int err;
 
 	/*
-	 * Allocate guest memory. We must align our buffer to 64K to
-	 * correlate with the maximum guest page size for virtio-mmio.
-	 * If using THP, then our minimal alignment becomes 2M.
-	 * 2M trumps 64K, so let's go with that.
+	 * Allocate guest memory. We must align our buffer to 64K to correlate
+	 * with the maximum guest page size for virtio-mmio. If using THP, then
+	 * our minimal alignment trumps 64K, so let's go with that.
 	 */
 	kvm->ram_size = kvm->cfg.ram_size;
 	kvm->arch.ram_alloc_size = kvm->ram_size;
-	if (!kvm->cfg.hugetlbfs_path)
-		kvm->arch.ram_alloc_size += SZ_2M;
+	if (!kvm->cfg.hugetlbfs_path) {
+		if (kvm->ram_size >= HUGEPAGE_SIZE)
+			ram_alloc_align = HUGEPAGE_SIZE;
+
+		kvm->arch.ram_alloc_size += ram_alloc_align;
+	}
 
 	if (kvm->cfg.arch.guest_memfd)
 		kvm->arch.ram_alloc_start = mmap_guest_memfd(kvm,
@@ -63,7 +68,7 @@ void kvm__init_ram(struct kvm *kvm)
 		    kvm->arch.ram_alloc_size, errno);
 
 	kvm->ram_start = (void *)ALIGN((unsigned long)kvm->arch.ram_alloc_start,
-					SZ_2M);
+					ram_alloc_align);
 
 	if (!kvm->cfg.arch.guest_memfd) {
 		madvise(kvm->arch.ram_alloc_start, kvm->arch.ram_alloc_size,

base-commit: f67bc0bdae9433a9cfd05e65ea2c1bb6102566d9
-- 
2.56.0.176.g3575e65682-goog

