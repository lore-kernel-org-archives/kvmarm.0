Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C8ED32B991
	for <kvmarm@lists.linux.dev>; Thu, 16 Oct 2025 17:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760635823; cv=none; b=nlm9av/D81vN2j0rAG5n+5eE/PQCsj3WZ5FkKcHnUOWOPHCIO+78esR0RaIk/JRoNRxQZ9t9a/VRuGJYbx8GkrvUjfKDP1jaTJHShns/fk0GGi7X79KaytOwA1c2DA3vi4qvdlj2Lh3f8mNZQ7txTT2p0H4SWbGUAg+jBXJ0+sU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760635823; c=relaxed/simple;
	bh=+k5e0Sea10S5Qat1scXRV+R+j3jkE6pkdq3dHOcJZR0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fEsJA0sS/EpDNYcjvjngHO8Pt+K6wzfddMnnyxENEugFlhpdHk0rdrxWGQaV/tdARcdZ4gIFgXvZOX84lh+CM78khrD5ndwMKZoaoFlCxwXwu/FjZZ0E7PLdKSMqpdasuzggRRSb7vTWcuc1dTK2n2bYYaLtSVRoP/a3DtKTjzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dq+HLABM; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dq+HLABM"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-32ee4998c50so890767a91.3
        for <kvmarm@lists.linux.dev>; Thu, 16 Oct 2025 10:30:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760635821; x=1761240621; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=zq1tgXWhdaEPjv5XRrUDfAt6UbT40u8GeEVyLVyfpR8=;
        b=dq+HLABMYa0gCHmQ3+M7XOZ42h9ucGyeT9ZHjnjO3AOmyVWHqRoeNsb1+B/a664ixv
         YiRU48YmTHNMiJlkyxmDOU3705uO5hji4p6InqE8tYVrRwjGxwMvqR0tc+n61Eq/o6I2
         XRJIzR6VEHEVP+L7AbhXVg2/ywawWsZQdyQtS/vRafnL0syc5RFFG7oh9vUx23MoPlDk
         v0S/ArRl44X0E9PjpiW8Oo11yi5+HhkAO55WIws6KxFHr++mACQhWMl5Zr9ytk2ePv33
         HTP3bLa+lbSJgXzJLYiDlBclFO4rYLpUDD06tcSogdw6Frz1RAwPNqpf3H9KLnvA7ym9
         u4JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760635821; x=1761240621;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zq1tgXWhdaEPjv5XRrUDfAt6UbT40u8GeEVyLVyfpR8=;
        b=LSs5N2yoFtfNL9O76kqlEE/M15PUuosLpYSmtj2K5Hodc1G1T2F1cSqu8zzIqtrjdX
         fys4LRTE2lLLpKdbeIKR7/Trbf421Pm1mN7Tt57AYZ+TdHeV7NEno26ABNoDhW3gJ9T1
         N8LE4TNg1Vp+j9fzbYRmXACeSUKnWtdkUC2zz8T82WOC38NkIkMeXNUWXMVLGL6Exdlb
         JmHaIhXKRFGxPdq/qKMQH9MIilbnA2GJh0yEtAC/drCjn+278xXoAscl54pK+U57k9As
         iT77X0YzL1kudmA5alfXX7A5hKkpIUZwY/2OowkVCtYlbFKTbvCTbskW4w6GS8j0ZapQ
         bLlQ==
X-Forwarded-Encrypted: i=1; AJvYcCW+RW6raK8eJRs623TLMHJqJtBMXzaL95o4xsZGuK28bLEo9VvcKZw7YVm6De2It8TmLLnIZgY=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywh/3twlDB0P3kPvwq+ayo51sZnhitjtYQUuEpa+tSCd8hPTgoO
	hdqWEg4vFbGy9r91JJeDEYAF4OYfzoYlXk9DvV7We9pkfUvhvoLcsxOGBTJJAMUBMvusxXKR8M6
	qtKzNqg==
X-Google-Smtp-Source: AGHT+IEB/z+VBtg6OE+012RtMrAcNLRkjMeLsa6vSWEgt3UDRue4tkCjjeMMCGdXCD5ilhuA7eHznquW6sA=
X-Received: from pjzh17.prod.google.com ([2002:a17:90a:ea91:b0:32f:46d:993b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3c0e:b0:33b:c5de:6a4e
 with SMTP id 98e67ed59e1d1-33bcf853711mr677585a91.5.1760635821102; Thu, 16
 Oct 2025 10:30:21 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 16 Oct 2025 10:28:48 -0700
In-Reply-To: <20251016172853.52451-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251016172853.52451-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.858.gf9c4a03a3a-goog
Message-ID: <20251016172853.52451-8-seanjc@google.com>
Subject: [PATCH v13 07/12] KVM: selftests: Report stacktraces SIGBUS, SIGSEGV,
 SIGILL, and SIGFPE by default
From: Sean Christopherson <seanjc@google.com>
To: Miguel Ojeda <ojeda@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Ackerley Tng <ackerleytng@google.com>, Shivank Garg <shivankg@amd.com>, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, Ashish Kalra <ashish.kalra@amd.com>, 
	Vlastimil Babka <vbabka@suse.cz>
Content-Type: text/plain; charset="UTF-8"

Register handlers for signals for all selftests that are likely happen due
to test (or kernel) bugs, and explicitly fail tests on unexpected signals
so that users get a stack trace, i.e. don't have to go spelunking to do
basic triage.

Register the handlers as early as possible, to catch as many unexpected
signals as possible, and also so that the common code doesn't clobber a
handler that's installed by test (or arch) code.

Tested-by: Ackerley Tng <ackerleytng@google.com>
Reviewed-by: Ackerley Tng <ackerleytng@google.com>
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
2.51.0.858.gf9c4a03a3a-goog

