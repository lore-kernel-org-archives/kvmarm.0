Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.69
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793652440;
	b=NCrTtIiXHUrPdSkBLKTCbW8wnv5Ql0zIki7NFrWq4Lih1N39AzAt0avvIOZ9doRoX6ZS
	 BZV8my5TkA4k/E0gCnPkN7ctRcFElHy7RWxxtE2XXIstX7m4XajoGQXY+IFrx6EcW8T4l
	 trVqNa98FwTSauJq2MAIY1BdKtEF4q/0dFuKqJgndy8nas88g3Kb8yu4bZ0Sl82MJr7bK
	 gG+idGeOFk4CaPRSleB4GE1J1ZT9d/hD05Ifmju7BM7pB0IP/NLwFRIwy5wkfWgEtPluZ
	 Eh36uRD1LIc5JdNEXVwhPRkq8+k8/ig9XN3iuOj4lUhvpKwTWm8qpGKf6+yIlS04DNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793652440;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=PzxpOf9GSU8BWppDC1NmhSxLG0SFtPxkYuGCabdeGqE=;
	b=ZBngJ8Lvyi7uyuCNEy/doyB3r5jjIXjMDbxkNx+rzIfJSUuXF1T1cr2aKHz+ea0kp+N/
	 J3WmNpbEmrlA/xYCEWyR4iX4uzZ3Jzq7NJMufPqVrzL7AZ606KGT01o26Kpvz64H6D4MK
	 o72GjZFKvNG7vTjKwa1xTCOEWLzLGeWcqJXrVuVWWObWUElMTi3ES4xH+ZL+J0mK3zx/P
	 WHykMjUsQWDFsmIHwAhTBwyZd8yNtdYpqzbeRBdn1Z/FcYw6zxWu0MOyHiYc1/G/bbDbz
	 BzBV/v99FmbhQvx5+ptMwJPX3ZQkugN5S2amjRpg8QOtCckwg7DaopbbtyyzJIr/+jA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=WIWSZ5pq;
	arc=none smtp.remote-ip=209.85.221.69
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com [209.85.221.69])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68FC1606A329
	for <kvmarm@lists.linux.dev>; Mon,  2 Nov 2026 20:47:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 68FC1606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=WIWSZ5pq
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-48c430f0f01so3018217f8f.1
        for <kvmarm@lists.linux.dev>; Mon, 02 Nov 2026 12:47:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793652439; x=1794257239; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PzxpOf9GSU8BWppDC1NmhSxLG0SFtPxkYuGCabdeGqE=;
        b=WIWSZ5pqVB0V3i3HrhqcgjudbzRRNkKQ6KECqpJzYM8ANSnQ5t9I9p1/9eW2a8Wo3p
         IAz5BqvgllrspsjhfS0sATJ414B8Zp7ZY0hNFjbUV+8aXtiCgM5IVySFDGhD4YKT+v8k
         gQxkL4kLb1Tf1ubgCokFWFg4eP7s9yVSrEqTbBeJdyM119Kz1S9FY0KcmH7IvPt5BDUr
         W+nLAZvq6cPpS4Txo5hwfaZD8WUzJRUi98nRuhvfwwg6dkcwLAcSqhy+xsDAn0hkprxv
         F0CI2o3eHgI6fjJTojTMbD/4VdN17yYMPJgB5cTvuPnIgV3xSf6iJSCBPmsJn5lb9Tov
         pTzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793652439; x=1794257239;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PzxpOf9GSU8BWppDC1NmhSxLG0SFtPxkYuGCabdeGqE=;
        b=UEw9RkZ20CfUJ2jerGuA9oJNYTXM1B3xt2msAaWEn/8ZjhCRwhM/sPN9rkt8BUhEc1
         m6AK8KS9MGJOgKxWSvM2Y+hLpUptQ2MnyAdWnjR108LwAK5NZh4EnG+9G0eyYT0CowJe
         IZgSTbdB+EIby54/x3H+kvElSe/LQ7w5l5IADGP/Pz0Gg5HRvz5Dy9v96fgEj5Xt7PUu
         NrorZ6SIV/ZgAY1JUfAHXBPav0M1Rg1nGV/SA6mYbrSn56dj3Ei7IOGKqd9fUKRtKkkA
         cCFu4qZ1Q87dUyTburjnMOJuJn0IL/q9j8EYXG2LgC417ux8NRlIYkCfDnUwGMrAuwmN
         ncDA==
X-Forwarded-Encrypted: i=1; AKwUvBx+NAw2UmPV4Dz0G+LpGfqR/TX1mLpZUksj6uPy3i2pIXXKG27ZoP/fqhnj2/tMUpFAgOwxsuY=@lists.linux.dev
X-Gm-Message-State: APuU4Z/HfSD5CMK0HlChe4L3jgsao9s47vS3jyRfIZcA6SDOoB7qKKsq
	NE5NophterLrA4rXEDnoeWygKCyz3LFBNBDU0QMQzoeERW5hzjt9dY0yhuBnQz2LD6RfYghgZiZ
	JWxeZVA9u5BgmWQ3t5+6PYw==
X-Received: from wrri2.prod.google.com ([2002:adf:fc02:0:b0:48d:fd11:11f2])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:4a0a:b0:486:e707:42eb with SMTP id ffacd0b85a97d-48e71a3e74cmr23910206f8f.33.1793652438679;
 Mon, 02 Nov 2026 12:47:18 -0800 (PST)
Date: Mon,  2 Nov 2026 20:46:21 +0000
In-Reply-To: <20261102204628.401871-1-vdonnefort@google.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20261102204628.401871-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.56.0.385.gac671c819a-goog
Message-ID: <20261102204628.401871-17-vdonnefort@google.com>
Subject: [PATCH v3 16/23] KVM: arm64: Warn on pKVM guest stage-2 block collapse
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

When pKVM is enabled, the host relies on a pkvm_mapping tree that
mirrors the actual hypervisor-owned stage-2. The hypervisor is not
allowed to silently split blocks or collapse page-tables. This should be
treated as a bug.

Therefore, WARN on guest stage-2 page-table collapse which would
otherwise be fatal anyway.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
---
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 751f76d3ec39..88af0aec1ea9 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -226,6 +226,12 @@ static void guest_s2_put_page(void *addr)
 	hyp_put_page(&current_vm->pool, addr);
 }
 
+static void guest_s2_free_unlinked_table(void *addr, s8 level)
+{
+	/* We should never collapse guest stage-2 tables into blocks */
+	WARN_ON(1);
+}
+
 static void __apply_guest_page(void *va, size_t size,
 			       void (*func)(void *addr, size_t size))
 {
@@ -294,6 +300,7 @@ int kvm_guest_prepare_stage2(struct pkvm_hyp_vm *vm, void *pgd)
 		.put_page		= guest_s2_put_page,
 		.dcache_clean_inval_poc	= clean_dcache_guest_page,
 		.icache_inval_pou	= invalidate_icache_guest_page,
+		.free_unlinked_table	= guest_s2_free_unlinked_table,
 	};
 
 	guest_lock_component(vm);
-- 
2.56.0.385.gac671c819a-goog

