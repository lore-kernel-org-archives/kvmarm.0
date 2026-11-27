Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795798746;
	b=scIjHzBBLjd2BOYV5dC0sWOkx0KO7idZiSSKnicMo3RB8E7LHrmzg5xeaBEeXP9czx3F
	 hwnYNsPAMlWVsi+7+18PuX/YAjloCdExJye/XbvOigEcNNhXOEUC2MIFoZYfTT510GJ5c
	 p1wWUM8Xij32ag31Ooow4FEwCYGbqEOyVb+UnGDOJjBUYWPLBkTebkvl690iNholKbsr1
	 QoYAvj3DYzAwjXJRqNlZrQANigJoKM+kFUGUfXf9XJ5uBY00tvZ2spjdDTxH3tG9+qERq
	 Nd6resBEeerLPiUF4KoVqTYilQz5iJXEibo5xPaLl6q/n99g4Wo3vKMcmbZtRBk2reQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795798746;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=9ZXEacqR3rbcMgUrTgI8rcS8c5nOk1mz2EbR1FK4c64=;
	b=E8uGfke5kubzSTv0L1QVMaWlLJbV4ko489GOZu0mHIEEQtTSUlRqxy9ABiy3cXnkvfxV
	 lx0S7ZxaeJNfqY3Mbu7xr8jIPN5KWtSx3W237/AE+GOwh73fVIkygI99i9R+ivU8M1Nzk
	 I3vbZ54WZQp5IcJFu34lSoOT9n9HscP/FDdFy6NmGdRXxp4EFreuehrgtZOIyIUfWzntk
	 AdiUABJ+AwU61VDVZ1yOJWFFlTNNoOQP1GUSpMqiYKSthT5heE41ml4M0Jj6S6G3klt6b
	 t1mtpSPUmQ4eJGV+OzEGYj8YgS7MUjRlWYK2Y9hqXTY76nIO4SJh56ENXJ8LUh20YRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=D6S6ET5p;
	arc=none smtp.remote-ip=209.85.128.72
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C508606A336
	for <kvmarm@lists.linux.dev>; Fri, 27 Nov 2026 16:59:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7C508606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=D6S6ET5p
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4bb6bbc025aso63942785e9.3
        for <kvmarm@lists.linux.dev>; Fri, 27 Nov 2026 08:59:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795798744; x=1796403544; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9ZXEacqR3rbcMgUrTgI8rcS8c5nOk1mz2EbR1FK4c64=;
        b=D6S6ET5p+F6nIp/F0LWpjvXDVzUxxoEl8fSfyTd8YBq8bq1MV/e6TFuCDDgGJdk3Lu
         6zHcM58Zrd5RcBbi5LCvE3KMapyr9eYS5BpqToM8M6p9xH3SMcwmGX07c7lOYkoGMqca
         30SV3IL1Wh9gZHnKp4vjHjEfzY3j8RrjEmn44OzNg0U9TWwBrvWSyBe5fBkNhyFYOZjk
         uugho4rguV4Py0+36LGOytfhRYys6Q6cs1KcP5iPW1urRHwFATkuAYi0U6H+TQ9BsSTe
         4SpynCHrvg6AJinVoUbk55nYrOiV+iYVlWdRJntRMfSp0vs52tmpSeFDlfic1lKYnhyC
         7gRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795798744; x=1796403544;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9ZXEacqR3rbcMgUrTgI8rcS8c5nOk1mz2EbR1FK4c64=;
        b=rxQP3IWN28Y2b3NHoARuO3QqT/358ZkjIroUNgTMQaQ17FjLf1dpi8m4qrRuXXaBhV
         MAMSQ8NCdR+gGXrzVUCjy5lK5SFNSqmH8Yw/ZZXVanB9g4ZLSn3Md0WYFjdKQX8ulakL
         fgUPe3cPmgPk8ZY4utfXnQljOSrw+Oqkt5hXpQDYEMusdkMUclsLmmPqUfrRSAQdxpY4
         lJMz0fm1o/cX1uIrnfIgs/EVzEtJablVtgHhkxr5ogrh/GOYdfSBhvgW1gzPa9PfayWM
         /WblRR9hMSAHoopuFZYZ/5+7cMSYe8MspJSnm8eHa1tLRy63lfYspcUnLteC24bpwYzP
         NG6A==
X-Forwarded-Encrypted: i=1; AL+hErEJ648sNEoDfF6IqFuqdLvUgTIbbpn1zgMOMXPDCly25VCYyR1gUZka9VhcZr6p31BA6ae/VSo=@lists.linux.dev
X-Gm-Message-State: APuU4Z+wLt5LzzTgxEHhOUGOPNVmr4K2XuerfLJmXo0LXszlNkHSzS8v
	g/8liuFsBzPuNFqFyDea+hM+hcMmkDiSvMSzrlIP7kTYUi82s9np6dZ85N5Rlz3vbCb01FfmlXT
	6v7tcqK3kn5RBblpaqWmP1Q==
X-Received: from wmbz10.prod.google.com ([2002:a05:600c:c08a:b0:4a1:8bbb:59bd])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4585:b0:4a1:83f0:7c91 with SMTP id 5b1f17b1804b1-4bb8882948dmr520359785e9.18.1795798743614;
 Fri, 27 Nov 2026 08:59:03 -0800 (PST)
Date: Fri, 27 Nov 2026 16:58:42 +0000
In-Reply-To: <20261127165843.709034-1-vdonnefort@google.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20261127165843.709034-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.56.1.839.g22a8290db9-goog
Message-ID: <20261127165843.709034-3-vdonnefort@google.com>
Subject: [PATCH v2 2/2] arm64: THPs for systems with pages bigger than 4K
From: Vincent Donnefort <vdonnefort@google.com>
To: will@kernel.org, julien.thierry.kdev@gmail.com
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, maz@kernel.org, oliver.upton@linux.dev, 
	suzuki.poulose@arm.com, alexandru.elisei@arm.com, andre.przywara@arm.com, 
	kernel-team@android.com, Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

The THP support imposes guest RAM over-allocation to align the memslot
userspace address to PMD_SIZE. However the alignment is currently
hardcoded to 2MiB, which only works with 4K page systems.

Instead, derive the hugepage size from PAGE_SIZE and skip the alignment
if the guest RAM size can't even contain a single hugepage.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
---
 arm64/kvm.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/arm64/kvm.c b/arm64/kvm.c
index 35aa6f260dd1..02cd519a5cbb 100644
--- a/arm64/kvm.c
+++ b/arm64/kvm.c
@@ -17,6 +17,8 @@
 
 #include <asm/image.h>
 
+#define HUGEPAGE_SIZE (PAGE_SIZE * (PAGE_SIZE / 8UL))
+
 static struct arm64_image_header *kernel_header;
 
 struct kvm_ext kvm_req_ext[] = {
@@ -34,20 +36,23 @@ bool kvm__arch_cpu_supports_vm(void)
 
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
@@ -62,7 +67,7 @@ void kvm__init_ram(struct kvm *kvm)
 		    kvm->arch.ram_alloc_size, errno);
 
 	kvm->ram_start = (void *)ALIGN((unsigned long)kvm->arch.ram_alloc_start,
-					SZ_2M);
+					ram_alloc_align);
 
 	if (!kvm->cfg.arch.guest_memfd) {
 		madvise(kvm->arch.ram_alloc_start, kvm->arch.ram_alloc_size,
-- 
2.56.1.839.g22a8290db9-goog

