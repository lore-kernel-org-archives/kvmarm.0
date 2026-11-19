Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.199
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795114350;
	b=NxHCjoLxWzqXiywYHcbftqRpR0HWuuteS6Dc72tAER7hCxOqswEQRU+kELw+O85Aqv/P
	 zWkOpy8NWcjlOv0qNqfrtFpAMAu7FC2tLLb3XOzqRr1FlpdbGCg5ieXzILbcqHbHYcU22
	 x30sB2XZJYhWvYNbksUQVf1JoJdbsjwJ99mSjSyzFPRYQhDSpU5/POOvvlsgjKrX6I6rM
	 CMZ/pq8P4sS6oH2h0KH9Fe6OzZsMn1cLssEAATg9wQIweuMhxjz45EUNWhfr7zktH7Lvw
	 ojQM96HSTIvOwJN81WSrXsTmVpaTfSEARRIT+HtWjKDAol+Dk/OAXcpc81uIjcAu/NA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795114350;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=Dri93dGf86JD2a4x55noboCN1Q6q179kTQsK767li90=;
	b=ryV1f93lzi+jU69YoLbhnBJbKhLa+IixbUcPbofVSr8uj9PayT3l0ArUMvZ33Vwm6gdm
	 rmawxRvpK3UmWQM0+XMCI8d2FJoNaleHbCUcwVCAs2v6368DFUVOgs1CkmhrlEj/mGL9O
	 LPthefaCqcZZh8AfETxXNJglCmnCg9lS1GrgngRt41soW/cVrbnCS+nIki5PJoaka0SG1
	 cIVixP9qGHddJIA0tvL2stkWPNw4GCghMdF7pqVfgboIf5nKhU1sS4dbhOON6oOUzIOit
	 TiHlAzb9nJab9d/6unytK/sgf5YjU4H9Uz42MNFFYiY0JZ0eTTU69UCiDD4VRTtXh/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b="LHL+LAE/";
	arc=none smtp.remote-ip=209.85.167.199
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFE3F60A260D
	for <kvmarm@lists.linux.dev>; Thu, 19 Nov 2026 18:52:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CFE3F60A260D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=LHL+LAE/
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-4b597558c4cso178647b6e.1
        for <kvmarm@lists.linux.dev>; Thu, 19 Nov 2026 10:52:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795114349; x=1795719149; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Dri93dGf86JD2a4x55noboCN1Q6q179kTQsK767li90=;
        b=LHL+LAE/+gaLrkqUC7vbOuCE/dIBQZrrzAzlqrDYUE7EvIWDQV7axiiu6cSluszyrP
         C+kenIUmYsp10macGdjksXL/MbvmWWKUzXsv/fduEfSE2Xx7bNDSzTzFmieyMOIJ3Zv/
         aKOUwLsXkJ5NAJCiRiAi79igbJ99nx5tFAsreL83JPJk3iZaK0P8BKs0cZC0fYwj+tBj
         35XR0J0hsSnzqMHEnmKxUBexo3g2V74UMq+hNuXgLrI3kH9JCHfYZnjal+H48ewZl1pf
         VYSKhRcYkTv7/iBChIF+j7D1kr6wGUfX1s7YPhJOh2ovfF7FL0FD6TNWYFnLVzqkuuLk
         UWiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795114349; x=1795719149;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Dri93dGf86JD2a4x55noboCN1Q6q179kTQsK767li90=;
        b=K0ouUA6cSxRh/r7EiA7BQwb8BpIvB3LRMLf3SQ9Em1piP3Ee/b3j3THNHo56Vj4DJ9
         mHRBYm8ajP4MncQ+R8hU4iij0+R/dR3V++PqJhfRJtFUPM3+UMf8Bfjoz+cfylU8Ivba
         s4CWELC40N8DxzJ4lhAK4A9tE8d5PYMDOEDpHeXYduW2DyS4y2ZGhPD0h+DoMMMKEh9D
         pYXZdcXHDAwb8ANjIN0up4AXw35YY2V9lbpry2VJo7uHi6ERIDeHNNo6dpqzxuagS6xm
         kpAOFAdu0x1ZG+Pc7nrIbw9gP5ykJZEcJFJfU6vw62Tw7SV8McLvwKd9q33GmgUE+xNn
         bXXQ==
X-Forwarded-Encrypted: i=1; AL+hErHyv7LiO41SRsgkl9jc1DL1ohXqYLc3JVw8p2uxMNF22iNIL5Q+5hprH+bgxrX4qC343bXAcnY=@lists.linux.dev
X-Gm-Message-State: APuU4Z/nLOGZsg6V71qzah4KhpmdQxiawJ/z7zZdTiJzVTAKp1QYDzQX
	nW0d1ud4huiTssVQEl/YQE5GupMElghRxNIgfve5oAaRF5ufKImnSsp4r+KtKJPQKH7JYGKJWDx
	7OjEVn59KXiRHGPoOOSHmshh3Xg==
X-Received: from iok4-n1.prod.google.com ([2002:a05:6602:c604:10b0:9cb:3bd8:aa36])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:1805:b0:549:572c:fd42 with SMTP id 5614622812f47-57a0bb85010mr976405b6e.47.1795114348499;
 Thu, 19 Nov 2026 10:52:28 -0800 (PST)
Date: Thu, 19 Nov 2026 18:51:55 +0000
In-Reply-To: <20261119185215.632334-1-coltonlewis@google.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20261119185215.632334-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.56.1.809.ga0b61035b5-goog
Message-ID: <20261119185215.632334-14-coltonlewis@google.com>
Subject: [PATCH v10 13/33] KVM: arm64: Make __vcpu_rmw_sys_reg() atomic
From: Colton Lewis <coltonlewis@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Peter Zijlstra <peterz@infradead.org>, 
	Ingo Molnar <mingo@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Russell King <linux@armlinux.org.uk>, Jonathan Corbet <corbet@lwn.net>, 
	Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, James Clark <james.clark@linaro.org>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Mingwei Zhang <mizhang@google.com>, 
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Use try_cmpxchg_local() in __vcpu_rmw_sys_reg() so read-modify-write
updates to vCPU system registers are atomic with respect to local
interrupts and GICv3 pseudo-NMIs. This prevents lost updates when a PMU
overflow handler (which may run as a pseudo-NMI that is not masked by
local_irq_save()) updates PMOVSSET_EL0 concurrently with vCPU register
accesses.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm64/include/asm/kvm_host.h | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 89683a690828e..103c25001c0d2 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1313,12 +1313,14 @@ u64 kvm_vcpu_apply_reg_masks(const struct kvm_vcpu *, enum vcpu_sysreg, u64);
 #define __vcpu_rmw_sys_reg(v, r, op, val)				\
 	do {								\
 		const struct kvm_cpu_context *ctxt = &(v)->arch.ctxt;	\
-		u64 __v = ctxt_sys_reg(ctxt, (r));			\
-		__v op (val);						\
-		if (vcpu_has_nv((v)) && (r) >= __SANITISED_REG_START__)	\
-			__v = kvm_vcpu_apply_reg_masks((v), (r), __v);	\
-									\
-		ctxt_sys_reg(ctxt, (r)) = __v;				\
+		u64 __old = READ_ONCE(ctxt_sys_reg(ctxt, (r)));		\
+		u64 __new;						\
+		do {							\
+			__new = __old;					\
+			__new op (val);					\
+			if (vcpu_has_nv((v)) && (r) >= __SANITISED_REG_START__)	\
+				__new = kvm_vcpu_apply_reg_masks((v), (r), __new); \
+		} while (!try_cmpxchg_local(__ctxt_sys_reg(ctxt, (r)), &__old, __new)); \
 	} while (0)
 
 #define __vcpu_sys_reg(v,r)						\
-- 
2.56.1.708.g77570a6a1d-goog

