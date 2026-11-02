Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793652444;
	b=rMScDl03rDPH9wZJJyYVUz7F2Lk+Lv1tL48F7I8JBOkOrICqz3zqLB9L2wGiPpemM12w
	 1K+HwatOCSEuUi439UhoaMFTDZVWnaU52oqj0cvltGygRKMgycloxUfofNFioOomv4e/N
	 Rcy5cvJUi0PHbhUT/KCCXCZb1zhSK5octBIsBBvdEv/vQ2tOREodojT74+8ww71dUIfsN
	 cIgAaawCdkNjOIXzvQhMHsW2SlBL+dnJ5CXxirlBKiHc/f9GE/oOR2OInGbVlSkvcj54r
	 ntr4h3fRRrRKsN2HEi3gwfVZY/vrtJhsr/DsR9dmrIYAfhxdp3rQMocrMYkBPhfex1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793652444;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=I6BQoFnF9ikMH0E7xIp1BG2aoqpM1gNnG8JpjKNdNFY=;
	b=Usyy+08ZiR2lsR3ASGSQ6Dp4o4hN5Oi6OU/9xnvMqlsxbs0N2NWX11NIJIvHxoJCUvEG
	 JB4n7OQ6ZMJbQuc4+UNKetKtZzhHR8W/17c5xxMpBBVOf3m94t/veB0u+ffcj3odJ0qOz
	 /g7Kb3bPu2DjCH5ys9TeVlU8vB7GIRn2ZnA8fxqF5I1WZjSWaqN+4K/skG9T3NLwbhBEF
	 rXC8nhYo4uTUZpRrfRyzZ2TDr+kMqUfMfLK85piibWE5kRQ1Czd9eKj8l3C4ZRVny+8W6
	 kmTkiE0pI5hiAzvKHSr8yk8r1itdKm5HPorSLKUWJ0KeO2uNq+aTtiNZf4di3xVgFug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=KQbwCOz8;
	arc=none smtp.remote-ip=209.85.128.72
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B7AA606A32D
	for <kvmarm@lists.linux.dev>; Mon,  2 Nov 2026 20:47:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8B7AA606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=KQbwCOz8
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4a17741243eso26253695e9.0
        for <kvmarm@lists.linux.dev>; Mon, 02 Nov 2026 12:47:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793652443; x=1794257243; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=I6BQoFnF9ikMH0E7xIp1BG2aoqpM1gNnG8JpjKNdNFY=;
        b=KQbwCOz8AsUTZLhPHnJJ3F0ewBLydWa657DtL+x+Jh26H1pj4QSqCgb0uwBlKNOPfY
         74eXm2Wbm7vjC71g0m4gkSx1tbMqgC3ZGoGrqWFM0qV49pZ0+vq9C4Ltq8MLzQDZZuIG
         q/tt7r7P8uCS+Cy33T4DL3EAq7x3nQaKdN/R+lkQVHXNLqX+LxRhcDlRhXcZlWKWkivE
         kRVUAEapMQRd9R+Nb8HTDZ3awwtmbHSyl2uyvVhnf+6nbTFLASUBbr7g9rwid72eepJB
         /AsKyve94Q85iSxLpzQzbDNvkUff/AIpENNxVhZ3T82z+fpgehQ8s8dgbhCe8WMkeAvn
         CpkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793652443; x=1794257243;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=I6BQoFnF9ikMH0E7xIp1BG2aoqpM1gNnG8JpjKNdNFY=;
        b=xf2elKD/duReqUI7pHsNeZTDHMIlyq6ru/9r4H3V+Er1sDwcL3rPWIpi3a5zy3Fcts
         nreT70es9ag0tOFbzYjy3wo8/xUBJtUxXwLFnr5eS54mJx/j1mWHMMDqN5YVV297u1K7
         8Nc55ioZf5AEQJ6zvO2r62aOMtdVx30Xhimcm/Yfot8vqEAsm7LfP/zZzdP9oBMIeDPN
         jWZZg8yCESztjasI47uG3fkM8o0RLaBYogFo6/MEVDnIUlkxsdhJGQMq/CFbB9J6igtX
         k0mS46nNqlMKvMLadPzWNQjfLnyJXmqSaCMts/CcV0lyF1PgsTo3G6W22ZJ/7gGGn8dt
         ZlHQ==
X-Forwarded-Encrypted: i=1; AKwUvByOAg1ZBeaif6Oqul++9undhFfXkOVjwDednXorsGSy86KYQYTbwksBafq1ZnpEoGFRRLSS3hI=@lists.linux.dev
X-Gm-Message-State: AFq9FYLUnZAGA5IMaS4k4l1dnXBt1QRE1vQdgBxp4uVFledTzW2C1oD/
	ysCwcGVquB6G0S5idDLlhAaP0GvRUDIzy7J2/gyiE/8KeEVJ97nMgW6qppku4HkuDD8jE5+cNXs
	MjwEchEEaVeMcjwYyhs+69w==
X-Received: from wrbfl11.prod.google.com ([2002:a05:6000:29cb:b0:48e:20b:f597])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:6215:b0:4aa:1527:659 with SMTP id 5b1f17b1804b1-4ac17a366c0mr266862815e9.17.1793652443131;
 Mon, 02 Nov 2026 12:47:23 -0800 (PST)
Date: Mon,  2 Nov 2026 20:46:25 +0000
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
Message-ID: <20261102204628.401871-21-vdonnefort@google.com>
Subject: [PATCH v3 20/23] KVM: arm64: Extend pKVM page ownership selftests to
 cover guest block split
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Extend the pKVM page ownership selftests to test the split of a guest
stage-2 block and the per-page reclaim of that same block.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
---
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 41 +++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 7ecf4c98d7b5..82fcec43f16a 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -2128,6 +2128,47 @@ int __pkvm_ownership_selftest(u64 pfn, u64 nr_pages, u64 pgtable_pfn,
 	assert_transition_res(-EPERM,	__pkvm_host_donate_guest, pfn, gfn, nr_pages, vcpu);
 	assert_transition_res(-EPERM,	__pkvm_host_share_guest, pfn, gfn, nr_pages, vcpu, prot);
 
+	if (size == PMD_SIZE) {
+		/* [gfn, gfn + nr_pages) was poisoned. Skip it */
+		gfn += nr_pages;
+
+		selftest_state.host = PKVM_NOPAGE;
+		selftest_state.guest[1] = PKVM_PAGE_OWNED;
+		assert_transition_res(0,	__pkvm_host_donate_guest, pfn, gfn, nr_pages, vcpu);
+		assert_transition_res(-E2BIG,	__pkvm_host_reclaim_guest, gfn, 1, vm);
+		assert_transition_res(-E2BIG,	__pkvm_guest_share_host, vcpu, gfn, 1);
+		assert_transition_res(0,	__pkvm_host_split_guest, gfn, nr_pages, vcpu);
+
+		assert_transition_res(-E2BIG,	__pkvm_host_split_guest, gfn, nr_pages, vcpu);
+		assert_transition_res(-E2BIG,	__pkvm_host_reclaim_guest, gfn, nr_pages, vm);
+		assert_transition_res(-E2BIG,	__pkvm_guest_share_host, vcpu, gfn, nr_pages);
+
+		for (int i = 0; i < nr_pages; i++) {
+			WARN_ON(__pkvm_guest_share_host(vcpu, gfn + i, 1));
+			WARN_ON(__pkvm_guest_unshare_host(vcpu, gfn + i, 1));
+		}
+		assert_page_state();
+
+		for (int i = 0; i < nr_pages; i++)
+			WARN_ON(__pkvm_host_reclaim_guest(gfn + i, 1, vm));
+
+		selftest_state.host = PKVM_PAGE_OWNED;
+		selftest_state.guest[1] = PKVM_NOPAGE;
+		assert_page_state();
+
+		selftest_state.host = PKVM_NOPAGE;
+		selftest_state.guest[1] = PKVM_PAGE_OWNED;
+		assert_transition_res(0,	__pkvm_host_donate_guest, pfn, gfn, nr_pages, vcpu);
+		assert_transition_res(0,	__pkvm_host_split_guest, gfn, nr_pages, vcpu);
+
+		for (int i = 0; i < nr_pages; i++)
+			WARN_ON(__pkvm_host_force_reclaim_page_guest(phys + i * PAGE_SIZE));
+
+		selftest_state.host = PKVM_PAGE_OWNED;
+		selftest_state.guest[1] = PKVM_POISON;
+		assert_page_state();
+	}
+
 	selftest_state.host = PKVM_NOPAGE;
 	selftest_state.hyp = PKVM_PAGE_OWNED;
 	assert_transition_res(0,	__pkvm_host_donate_hyp, pfn, nr_pages);
-- 
2.56.0.385.gac671c819a-goog

