Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795814897;
	b=y2qrlXcL+RIQpECAp1OPWLxdwRl12oxzPX+Ob5h3k3F9DUHRH+oQXxRFAyTeRdM5GZpE
	 Tbof3n5TEP4+svI4clGjyXnFYr0QiHEP3ZHJyVd57En6gJIb2kg2Kcq4NXGKvDJK2atpv
	 nkFlu3W38zseF0wH/DJiuZY1qB5dK8ZOn4qX95trFKz/ObqXF5Y4WWayZUv9k4LYFkPBx
	 /9KAFrke/IZgXb9UNgt7iNJALeXR12YiEottVQVDMc5fDpDSKK4FFccDO8MlOx2m9L2bx
	 F1KJbEA+TUD9SpU5gXyXxcwjMboXN2jHPga78nsxYaDXisTa8/GmO7mFVLw+MVbjyqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795814897;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:Mime-Version:
	 X-Mailer:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=+mb9rF6VJRzXR4i4y89PW+yVWJyrkXOWuPHAFuVlX7c=;
	b=ToQbjJNMId9l9R4oJlFRtvRLqzIJ+n+1MlQM80FeTNVibPWCnwKHVsl9o+ZXlBFVEISx
	 vQO9m5g0emI0In0/zyJvAWEKqciU3+KyLKjJ3ZYM2e1SxlK2Q5lkVv0WVSS57oGEb4g/v
	 dDmLl4c1b1EAcr4nIUTs5lexZup4Uj6TDSY8PNlpJu097lyYpu9tfOcDJIlOKLiwq5qOe
	 wW2etyKuSmO67Tx8zSEF4c/weQSRAl62oGCP+lN0MZdr7wpbW0AvxxrN9mj756D8CPwkJ
	 cJBXeoS742/5YGXoyO1belm0eMMO5rq7rsBX57LZI1OL7b6ZO8aFQnuCCyn8pKXmJPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=n4hgj3JI;
	arc=none smtp.remote-ip=209.85.218.72
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com [209.85.218.72])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3953A606A31E
	for <kvmarm@lists.linux.dev>; Fri, 27 Nov 2026 21:28:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3953A606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=n4hgj3JI
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-c42888c50c4so785078966b.0
        for <kvmarm@lists.linux.dev>; Fri, 27 Nov 2026 13:28:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795814895; x=1796419695; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=+mb9rF6VJRzXR4i4y89PW+yVWJyrkXOWuPHAFuVlX7c=;
        b=n4hgj3JIaShoIM6TLWqAexGrju7C8E4MM0PcN+QsBoGN8Hf8rQJmRIMcsJoiRA4opX
         mgVAMNWykN9DrUQo+IJbFrTk9xqtS4k+q5vUXqu41+ZO1/ShJCINtNfDDmYFTVjvWCuV
         E37QS3Fn5rMjWg06eKMtYHal7+dtQ3/P/nvXNVIwWuGkYTRJvJrfikzrGwnv/TSAnrm2
         Oe6gPxLCOWXJjLde4Ne74NVLh+74AIeJoPdiF0azdF9LIeip+5LyRES8fKuaDDGqL1TA
         pJtxsSWCbWoGoEWJEdJv0+yco3txY2RZkMC5ajF43ZN7z+lI5A3964gS8qHsW8YcNa0a
         xB9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795814895; x=1796419695;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+mb9rF6VJRzXR4i4y89PW+yVWJyrkXOWuPHAFuVlX7c=;
        b=a9ygkYsEwqKdvMaLOgUK58J4TzgRyCTJMBqzh9qQT7UEmekyQJVyUZi8m3u2gnhe81
         R/dhHguduqrj3dYtNnKqlFsM4KUF5+Wbb+e/hnNx9dl161pjdUu4NYrAVm7BqWIL6+Cy
         7iQH+WCl8vklXYyy1bs9sbCa7IaOtn10PzURjtri8U3hXzpi1XFBrtkLcRXRYN90xzet
         C6EgdIQ3TMUiWRGlHhA8mgH4FX8t+Oe9XwvnjbBEXqMH1KoewGK12Lv95Gof4990CLNr
         HkQUjbeOWxMR4Le1S6OmP2grXXqsoVccF229BjRzF7rEVN+I6kpsCtRHnwNtU6ClsPOq
         DYhg==
X-Forwarded-Encrypted: i=1; AL+hErHnQGr0Y459GXoHIgWrjBE7RQk3Xq2wDQKuuR8zMiRGT9qI0aoZEbnZ+QeF7aMLHhgcWI8VdZY=@lists.linux.dev
X-Gm-Message-State: APuU4Z/aFXgGPfq3yDP8wgIq39K1fPTfFLTS3GAMha5JQRRasfYiXhg4
	96yc2zm+kLDujfWdCEvoZOS6mRm8ZwDcaT055XW+uZ7c9L7LozqIVN+SdUYDzVwKtnF8yMvMdW+
	3IMTN/1If0gEDOTpRcXyJ+w==
X-Received: from ejbbx9.prod.google.com ([2002:a17:906:a1c9:b0:c50:487b:9fb8])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:906:c10e:b0:c41:5e31:5184 with SMTP id a640c23a62f3a-c513a99abe6mr2130168566b.13.1795814895264;
 Fri, 27 Nov 2026 13:28:15 -0800 (PST)
Date: Fri, 27 Nov 2026 21:27:43 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.1.839.g22a8290db9-goog
Message-ID: <20261127212743.1139739-1-vdonnefort@google.com>
Subject: [PATCH v1] KVM: arm64: Use CNTPCT_EL0 for hyp trace clock
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, 
	Vincent Donnefort <vdonnefort@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

trace_hyp_clock() reads the virtual counter (CNTVCT_EL0). Under nVHE
(and pKVM without hVHE), loading a guest with a non-zero offset applies
that offset to CNTVCT_EL0, corrupting the trace timestamps. Use
CNTPCT_EL0 instead.

Cc: stable@vger.kernel.org
Fixes: b22888917fa4 ("KVM: arm64: Sync boot clock with the nVHE/pKVM hyp")
Reported-by: Fuad Tabba <fuad.tabba@linux.dev>
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
---
 arch/arm64/kvm/hyp/nvhe/clock.c | 2 +-
 arch/arm64/kvm/hyp_trace.c      | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/clock.c b/arch/arm64/kvm/hyp/nvhe/clock.c
index f3e2619db4e4..ea4412e6737c 100644
--- a/arch/arm64/kvm/hyp/nvhe/clock.c
+++ b/arch/arm64/kvm/hyp/nvhe/clock.c
@@ -54,7 +54,7 @@ u64 trace_hyp_clock(void)
 	u64 bank = smp_load_acquire(&clock->cur);
 	u64 cyc, ns;
 
-	cyc = __arch_counter_get_cntvct() - clock->data[bank].epoch_cyc;
+	cyc = __arch_counter_get_cntpct() - clock->data[bank].epoch_cyc;
 
 	if (likely(cyc < clock->data[bank].cyc_overflow64)) {
 		ns = cyc * clock->data[bank].mult;
diff --git a/arch/arm64/kvm/hyp_trace.c b/arch/arm64/kvm/hyp_trace.c
index b9404496f977..06d6bd7aeac7 100644
--- a/arch/arm64/kvm/hyp_trace.c
+++ b/arch/arm64/kvm/hyp_trace.c
@@ -510,8 +510,8 @@ int __init kvm_hyp_trace_init(void)
 			per_cpu(timer_unstable_counter_workaround, cpu);
 
 		if (IS_ENABLED(CONFIG_ARM_ARCH_TIMER_OOL_WORKAROUND) &&
-		    wa && wa->read_cntvct_el0) {
-			pr_warn("hyp trace can't handle CNTVCT workaround '%s'\n", wa->desc);
+		    wa && wa->read_cntpct_el0) {
+			pr_warn("hyp trace can't handle CNTPCT workaround '%s'\n", wa->desc);
 			return -EOPNOTSUPP;
 		}
 	}

base-commit: b6a9fa34ce4187cb69d3c588a4bbffc31ce5db8f
-- 
2.56.1.839.g22a8290db9-goog

