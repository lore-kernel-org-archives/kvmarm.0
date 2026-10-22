Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.71
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792677737;
	b=NN1vGQpTfTAdsbuTkLInLK4ul/YtyunHJSaN20zJEIQk1j0UbUDNcYOsVYUhs2wucDjh
	 UxDf+zLxzty/1CQ/xkUaa7+CXfTyiQHzHDEetYUzhPGAIdA+oI0nSZzZyatdzenLSSO3I
	 KvChdIdNESqeNrle8UvKM7k6DTjgdCFoOdpdx9M6RTAY79AG8TlbHlwFlFsN3pP8u3ksE
	 gmm2k/61AkcsLxM2WXFGZl75B38MJq5lYt95UbdHqG3a3R6S9U5+L31S5utrg0Bq4UWjd
	 4Ul2htAgWRxTio3TyabJr3LZl2dCofkpIJUMvyVbEiZuGw3/O6TC0X2V6oG5B8yGYew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792677737;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=Hp9JeT3gf9bLn3Zliqx08JQ0NLgTD4FcuPPlzeVHa14=;
	b=Nu7Lo6MDzYPsqNyKrCD/5XFE+GkOcaYTzg82O3pss2LurJoNZwDBig5XQneagVz2v6Ln
	 PMfAWwF1UNO+P2K4PFzdagB0kGoZjOasXVQIbnXholxbcJVT04kNQJvNiurzQ745ct5sL
	 qVNeXXU9x+R24uLdAWtP5aXqJjuMGAxpl//2/KMQ5r77TVKesFmfJoqMHwvLVcCWmGVCd
	 cU/ySRG4OvxBGIKx+hTO0YtWrWaavy0qaLnvefKwHyqco7BmetjSZxDktKRhgG6tvZmKf
	 XCX072adXKvB/HIEVZHAsWsB0iMmN0JO1rPtLlsgm3mgnsy/99iyoztX7mxFLxFk9fQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=TtElXZMv;
	arc=none smtp.remote-ip=209.85.128.71
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC515606A319
	for <kvmarm@lists.linux.dev>; Thu, 22 Oct 2026 14:02:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AC515606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=TtElXZMv
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4a20a6e8426so5099285e9.0
        for <kvmarm@lists.linux.dev>; Thu, 22 Oct 2026 07:02:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792677735; x=1793282535; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Hp9JeT3gf9bLn3Zliqx08JQ0NLgTD4FcuPPlzeVHa14=;
        b=TtElXZMvkAO8kgjWhFPXuKi2K5GqnuFoWLqyWUV1ftAiXDRS2G5cLr6tlxZoKta1wG
         KvJXwpe24MUKhKBWYWtnrJx32yHp9Vqp5csZ8hMlK/2TpPYqbjXjbWjBf/HHFCy4bKdO
         Ccho9WZzx2oMnuGBM2BF1njJAybAoEjJsLCsmac+uhUZ/8umvVWKrV5ircpL+yZ8Qz44
         DFd5mZPjfaek08GXs4chZG92GKhvVxsTiTMrc6/YcYgQNgzQZUcL+VukzoOsM8wxBLqK
         bUuh1wEGf9w9wAmEru+5J5+aFv32tnjvv6fdt9kuqcMpMw1jvUf8IoZPYyyGuMeem4Hk
         fYbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792677735; x=1793282535;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Hp9JeT3gf9bLn3Zliqx08JQ0NLgTD4FcuPPlzeVHa14=;
        b=L+YclZWfxB+NCIwUIHiVL6RC9rBxX+NMmy6+p/DjmP7yj9n8JVzXCSRZsm5sYbOaec
         VWCaLh5IeDVN0+TMilTVHtWY4tjqUktWrAOt1H3Ko0Iqt1QvNpH9s74+nJ9BHp2Pvn76
         ynyDsrvv0HwLC5YIXnZLGzUdVpubXzJwxsx4dhUP3d+NqYaSF1z4ZUqtvuVvQyV7e8qc
         sZWml+k6HlMdzckM3LpInNtvzV0KD+6qEPg3AS+WXsriIUdDa2B66VnP9l+285OR+Cmy
         7bG0fRqy6h2W7OTG3vg/CSyK1JTUyNfXHth/A1WOsf46UnyRSSdpapg7mnYqukoSkczL
         TvMQ==
X-Forwarded-Encrypted: i=1; AKwUvBxPAerbWtA5oyIfI3oglP6/cnS1P9cqP0ww+8338jXDi0QHWCy4o5Qkj8JQe4/6JLx61OzWclk=@lists.linux.dev
X-Gm-Message-State: AFq9FYLuQ5YPqwaJTSRTBTWdhxlF5dNThnB5IRhkaVGg2FIHtTjXpXkn
	jxWhc4PBTnOmTE5qB9fX0JVL/F9MwwgTjUoQ5jX1lolK4h5qXgTdfux6QG0Mu6C2LaAjSJ8eLhJ
	n8tAjr5RaBqJBrs9xPNtDZg==
X-Received: from wmbe11.prod.google.com ([2002:a05:600c:590b:b0:4a1:91fb:4150])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:46d3:b0:4a1:c5eb:b445 with SMTP id 5b1f17b1804b1-4a1fdd6bec7mr114091885e9.35.1792677734835;
 Thu, 22 Oct 2026 07:02:14 -0700 (PDT)
Date: Thu, 22 Oct 2026 15:00:48 +0100
In-Reply-To: <20261022140048.2522787-1-vdonnefort@google.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20261022140048.2522787-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.56.0.257.gf7497c7d27-goog
Message-ID: <20261022140048.2522787-5-vdonnefort@google.com>
Subject: [PATCH v2 4/4] KVM: arm64: pkvm: Avoid trapping on HVC_RESET_VECTORS
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

pKVM prevents the reset of the hypervisor vector and as a consequence,
kvm_hyp_initialized can never be reset. Add a fast-path for this case to
skip unnecessary HVCs on the CPU hotplug and PM path.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
---
 arch/arm64/kvm/arm.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 4c4e2fb7b660..3d7199a87ca9 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2248,8 +2248,13 @@ static void cpu_init_hyp_mode(void)
 
 static int cpu_hyp_reset(void)
 {
-	if (!is_kernel_in_hyp_mode())
+	if (!is_kernel_in_hyp_mode()) {
+		/* pKVM fast-path */
+		if (is_protected_kvm_enabled() && __this_cpu_read(kvm_hyp_initialized))
+			return -EPERM;
+
 		return __hyp_reset_vectors() ? -EPERM : 0;
+	}
 
 	return 0;
 }
-- 
2.56.0.257.gf7497c7d27-goog

