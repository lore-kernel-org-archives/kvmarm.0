Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CAF226B761
	for <kvmarm@lists.linux.dev>; Tue,  7 Oct 2025 22:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759875291; cv=none; b=hOCPvI1t17EKtGfmLUBZr3/4OSepxwk42SCqKJlYRksz/Ms6KY7p7vdtm09hZ5KF5wrsOkyeZKe1JS7ERqn6XVhVRjKxMi14f7dq0BV6od9BIk3zGcfcqRvx2DV/RQOv2v/V2dTya3XgN1/eUsKKpODvQ9Et4tVs4TpYMux803U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759875291; c=relaxed/simple;
	bh=DQgULNgEfY1Jt0H2/OfuNvBsjc9CKm5CpMZ3jXWuIWw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hXnasWvE/kAzYbMJKlOUS/e2w6y7rtALwPJIkl0qSmA1UAgOD/FRAFBzlVJ22UEGtm9x3I/q1PKcQr3jRInEVsau/BohD8Wfq3x5y8AR+ImjT/9zsC1LeG6r3qqa+JX48rtayMNKxdTHMRhbncAluoi5c5dHOG3pyTrxVybAtRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sY1Xgy/i; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sY1Xgy/i"
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-781171fe1c5so6340104b3a.0
        for <kvmarm@lists.linux.dev>; Tue, 07 Oct 2025 15:14:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759875290; x=1760480090; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=ZRjLOkLi9BSY1X/Dn5kuYV5Nji5pDR3uoMZxLkUFt2o=;
        b=sY1Xgy/iAmK5X7uCUGzmlUb85YqLZTyNXTpRB4CVd90W34Zme4reKJxLO3+Tpkp/rk
         gcLfbcJb2mUC0cyvQo+cffQY24Uur9kuAofIhv32y4bUVs8zH5AANKIh4JVbloGcWz4J
         rTEMVYRRp1Kb2ghuT/fAnM1kCj1MbCVYZ/GynXEhSSJkLlFR2HUIr6lD7LmezuSdl0Vk
         yEhZTQGrz+eOq8AnkfCgAKL+ZfjyQLc9has00s7AeP+N/eDAgfhkeA6dvB5ydVpUjKAr
         pCE8PUCJqgg7eb/vVJoQaonVt3LdwtsgNkJrZls+yjbirr/Um6/IbmIyocEmaksQPj6p
         27XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759875290; x=1760480090;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZRjLOkLi9BSY1X/Dn5kuYV5Nji5pDR3uoMZxLkUFt2o=;
        b=HNHmZ2JQVvucPxzs0WTPRaled92ZzUbtzginTOv4M9jADNup6R5fxuPCrzyh5kMWBe
         pKfTxRVru/i4uqCF8QQP5Z5S0BNQBfImwC2U2Dj1RfyJ1yCZ9Qepyb7Aff6Hl9iyLKHU
         dm4wyF2GWzNNcJzTPGQoIRT5afG6cH0NexWfDclC7C6jWy2gantq363lpwDJguhFFgKZ
         8WW7iuC4EQHd+ndakOjPcueoAK3cE5aFBoOyYmFCmYnXiBohSEc4L29BjLZ3FegDI/g3
         bR04HL/yp17QvAVr+06drNKsp/w/CpN5swaPWPZt10WpS/FnUnQq/j2KsWHC6/J/wsXu
         m0wg==
X-Forwarded-Encrypted: i=1; AJvYcCUlBo9MhSFFcqLRbPbBWnVrRIj13jgFZXvecunn4DAu0JHSS8VUpHbwO9udgMoP8f6kQpdez4g=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx/9PuHKhJ69hKbmK3syBbzc+fio8Dr2ORGjzLS0TGCxWj8O7Ck
	WI31Al7TvJKNkqpy86/1Shd52VC6Bvj5OzUhbowbgJlFMJuwwWq2yUHj40RZVa+TyTCHSFosofI
	iQ5r+kw==
X-Google-Smtp-Source: AGHT+IEms4qpmxT3+KnDpQ4qOyqPi3vhEOg4w0WfOhks0tfRQIlFpS+IHju/WYm3RYsFn35p+Bdpiaz8XEQ=
X-Received: from pfbig5.prod.google.com ([2002:a05:6a00:8b85:b0:77f:33ea:96e9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:3cce:b0:77e:5c9f:f85a
 with SMTP id d2e1a72fcca58-79385ce1122mr1342534b3a.14.1759875289698; Tue, 07
 Oct 2025 15:14:49 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  7 Oct 2025 15:14:15 -0700
In-Reply-To: <20251007221420.344669-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251007221420.344669-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.710.ga91ca5db03-goog
Message-ID: <20251007221420.344669-8-seanjc@google.com>
Subject: [PATCH v12 07/12] KVM: selftests: Report stacktraces SIGBUS, SIGSEGV,
 SIGILL, and SIGFPE by default
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Shivank Garg <shivankg@amd.com>, 
	Ashish Kalra <ashish.kalra@amd.com>, Vlastimil Babka <vbabka@suse.cz>
Content-Type: text/plain; charset="UTF-8"

Register handlers for signals for all selftests that are likely happen due
to test (or kernel) bugs, and explicitly fail tests on unexpected signals
so that users get a stack trace, i.e. don't have to go spelunking to do
basic triage.

Register the handlers as early as possible, to catch as many unexpected
signals as possible, and also so that the common code doesn't clobber a
handler that's installed by test (or arch) code.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 24 ++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 8b60b767224b..0c3a6a40d1a9 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -2290,11 +2290,35 @@ __weak void kvm_selftest_arch_init(void)
 {
 }
 
+static void report_unexpected_signal(int signum)
+{
+#define KVM_CASE_SIGNUM(sig)					\
+	case sig: TEST_FAIL("Unexpected " #sig " (%d)\n", signum)
+
+	switch (signum) {
+	KVM_CASE_SIGNUM(SIGBUS);
+	KVM_CASE_SIGNUM(SIGSEGV);
+	KVM_CASE_SIGNUM(SIGILL);
+	KVM_CASE_SIGNUM(SIGFPE);
+	default:
+		TEST_FAIL("Unexpected signal %d\n", signum);
+	}
+}
+
 void __attribute((constructor)) kvm_selftest_init(void)
 {
+	struct sigaction sig_sa = {
+		.sa_handler = report_unexpected_signal,
+	};
+
 	/* Tell stdout not to buffer its content. */
 	setbuf(stdout, NULL);
 
+	sigaction(SIGBUS, &sig_sa, NULL);
+	sigaction(SIGSEGV, &sig_sa, NULL);
+	sigaction(SIGILL, &sig_sa, NULL);
+	sigaction(SIGFPE, &sig_sa, NULL);
+
 	guest_random_seed = last_guest_seed = random();
 	pr_info("Random seed: 0x%x\n", guest_random_seed);
 
-- 
2.51.0.710.ga91ca5db03-goog

