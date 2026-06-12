Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 293E9399352
	for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 06:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781247571; cv=none; b=CJ2zT0DhpH83zUQDZWvY3l/sdLxr5TrkQLG9LZRIa5UDMUnqTYeNMlkhqkh8ea5IKTapxKi593y7cZuy/w5aUZTCWx73ngtD1y0jbvsw3eWIO2aPBcqfigMrzT/2Fwt1BD9XAhtistLR6vH4H6G99Cha8TnxpJnXy2xh/4tAFMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781247571; c=relaxed/simple;
	bh=m6OXBGJMXeZbXknwwxjueTeThKmplVgR0U3uoZlrVd0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LkZKFq5EhZqLpvtpjiFG0nlH7nsxv2lEd9VfddmeFxuOP/O6vrXNCeVwbTH+cB6DA11p9COs+liZ6087UNABCJclxSqvjuZD3jQd0IwZ+6IgnrQtC5D/9vuVEbPgo98lNWH+KsoZ5ImMc5EwM3i5lA9bT0Mw6U0nN1i+uyYxq9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mfx+/8Mz; arc=none smtp.client-ip=209.85.208.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mfx+/8Mz"
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-68b6f4ef5a2so521932a12.1
        for <kvmarm@lists.linux.dev>; Thu, 11 Jun 2026 23:59:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781247567; x=1781852367; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Wz1k2GgxstbvUGr74v2KjphysWOu90GWRraqbzm662g=;
        b=mfx+/8Mz5dQpf72bKvPSyt1axZWKw2OO8mZz2UxQ0mJkXQSYdcmUiVM2nG5SLfoWne
         cfX3dMorJAZQlTjwQiMDxPLEjWEuuUONqDqb7mM/JZLJjXHWTo73qJQhd/xplZVK7erc
         S0DfEnNUHyT3KoSNi/yQLqfteRv5pQ7EBQCpatcfs3QRsoC3pBMHiciaozdAonU/cz/a
         zHdvmRWGj7m/HtCJfW2pFD5YnHiKjBfys3OcyFL3LRZLaGA1YMSVuFcD8sUAd7TYkvd0
         AwY92iBl+OYlqIbMnpFBTLgfNG1h2C3abNELA0lSJyFfeDCfMVn/P/ZESvjR6vp1vsWF
         6Hog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781247567; x=1781852367;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Wz1k2GgxstbvUGr74v2KjphysWOu90GWRraqbzm662g=;
        b=jXaVTvJVbJEcHjHWIn0RdoCQJyJROvOCcjIYj1NCjj/8ZDNGcWO/zTztfMVmn+gKmC
         agYb1wkAvg9IqeD/93SoKieUWFyw20VjDkCHLAbHY3VXdizlqmP//2dW4PD8AyB2mFrO
         IfcP957ZzSx4qpu3R8WQTzvldRNwrRCJcp+9qkhhW06adVAm3A7FMvlMthj05+BbOPF/
         TDeANPjplNY9/w+96Oc6TYuPSXsaV/EEnaV7tT7IH1X0b9Jq+llce7jWrL6YOK1UhPvk
         r6056oN51i70MWoYDeqMjzhP2KlnMGMqL5J1tOvNvYYV68ErOa/ZXPyxtLuxceSO42QP
         zruw==
X-Forwarded-Encrypted: i=1; AFNElJ9DkZg42wzpjDxq2WHk+bRm1IO4Eu3VCnGeDWhEImLJBWI4DypeGi9X9Jn5+garJ5PtXAeWhSs=@lists.linux.dev
X-Gm-Message-State: AOJu0YxKSAogsbS2iygM0hRwabCy+bFCCfzY+vb9TCk40YmDyzDZ/gnv
	DitkTvonrDgIRRsNZBkBiamSiV2E8TrIPFoFuB5jQeY5RGhdg+BotMX5w1GFx3xeZRVLSNIBl+O
	Tkw==
X-Received: from edb8.prod.google.com ([2002:a05:6402:2388:b0:691:ad32:f754])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:3901:b0:68d:abcf:9593
 with SMTP id 4fb4d7f45d1cf-69378a104a3mr557406a12.17.1781247567338; Thu, 11
 Jun 2026 23:59:27 -0700 (PDT)
Date: Fri, 12 Jun 2026 07:59:15 +0100
In-Reply-To: <20260612065925.755562-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260612065925.755562-1-tabba@google.com>
X-Mailer: git-send-email 2.54.0.1136.gdb2ca164c4-goog
Message-ID: <20260612065925.755562-2-tabba@google.com>
Subject: [PATCH v1 01/11] KVM: arm64: Add scoped resource management (guard)
 for hyp_spinlock
From: tabba@google.com
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>
Cc: Fuad Tabba <tabba@google.com>, Will Deacon <will@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Quentin Perret <qperret@google.com>, 
	Vincent Donnefort <vdonnefort@google.com>, Sebastian Ene <sebastianene@google.com>, 
	Per Larsen <perlarsen@google.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Mark Rutland <mark.rutland@arm.com>, 
	Jonathan Cameron <jonathan.cameron@huawei.com>, Hyunwoo Kim <imv4bel@gmail.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

The nVHE hypervisor manages hyp_spinlock_t locks by hand across error
paths, where a missed unlock deadlocks the next CPU to take the lock.
Wire hyp_spinlock_t into <linux/cleanup.h> via DEFINE_LOCK_GUARD_1 so
callers can use guard(hyp_spinlock) and scoped_guard(hyp_spinlock),
letting later patches replace the manual lock/unlock pairs.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/include/nvhe/spinlock.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/spinlock.h b/arch/arm64/kvm/hyp/include/nvhe/spinlock.h
index 7c7ea8c55405..63ba826d8e3d 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/spinlock.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/spinlock.h
@@ -13,6 +13,8 @@
 #ifndef __ARM64_KVM_NVHE_SPINLOCK_H__
 #define __ARM64_KVM_NVHE_SPINLOCK_H__
 
+#include <linux/cleanup.h>
+
 #include <asm/alternative.h>
 #include <asm/lse.h>
 #include <asm/rwonce.h>
@@ -98,6 +100,10 @@ static inline void hyp_spin_unlock(hyp_spinlock_t *lock)
 	: "memory");
 }
 
+DEFINE_LOCK_GUARD_1(hyp_spinlock, hyp_spinlock_t,
+		    hyp_spin_lock(_T->lock),
+		    hyp_spin_unlock(_T->lock))
+
 static inline bool hyp_spin_is_locked(hyp_spinlock_t *lock)
 {
 	hyp_spinlock_t lockval = READ_ONCE(*lock);
-- 
2.54.0.1136.gdb2ca164c4-goog

