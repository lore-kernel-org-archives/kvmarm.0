Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1F39221729
	for <kvmarm@lists.linux.dev>; Tue,  1 Apr 2025 20:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743540427; cv=none; b=RzJPtPC+EwlRvN26SLuaCvKXLoA/YNPL2/hiRWz63zVNQr+/uSUto3bMaElO8boBo1Pnk7kK885uX8pAgGhfkmWw6tk9siFjBKwIEC8CFbzECTsDw0ofX12CVyv5XcdsRBRfsqaQDRDVmaI28heqIDYjNj4zPitAnnKrs4rl4PY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743540427; c=relaxed/simple;
	bh=vPE6Zg+Is0XKaMNp6fIjGpoFx3l5te14lZBJu/kZl5I=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NpEQ7cgmUxt57LvNhjDpBFMnmhVK5gbyNcxbbOipLR8Gsb0+qAMgYSGv4v8FugALmPcQmVrZafOQtrTckRONCvrPuHf07EPANjoRbxlFjUBfN+g2F+SCM/DpPAhW5CiogEb4akOYxNRF9qDMMm28L09ihQvVa/hwEw7BX7WTvYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Gm+SRKUf; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Gm+SRKUf"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-229170fbe74so89405035ad.2
        for <kvmarm@lists.linux.dev>; Tue, 01 Apr 2025 13:47:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743540425; x=1744145225; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=5qKsANY9N47hjadaMZNM56aBAj0f8nczwxZTz9+A9lg=;
        b=Gm+SRKUfYV5fOIYidQ0iylV1ZxsMLQzOAdej+2/vzo23Kc+FwDczBbvoh9boqgW/u5
         e2DwHnDzS1a2HIQb7am5u6sqxtYmpL2/5ToWuRQvDOYuk+cjjcrsOZRbDCXlz0gzAKqG
         GxFwkyFQceEbVqYJmoL2IBShn41l8qMlvZhUzaRZQ9dE1BJLejx5GIpFSxMok1Q+c7Qn
         DqMknk+rpuU5H4IopUkUtWsyY7Z//WwaaF+UNJdj+nHYRrI3vVWmpyfKr3xF0WJD31VH
         s4LxecaZ0I3lr115HWjevAeaKBssa59h2u7uQ/mIEs43dLIpOoXfscsjpBiq84WXhQQF
         0/sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743540425; x=1744145225;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5qKsANY9N47hjadaMZNM56aBAj0f8nczwxZTz9+A9lg=;
        b=Ri0z3x+sffn4dOwDZmqgMi08WCnO+JDfH4lJ2M5jvDw4b0eVkm7VgBFRcuVSKCVFkO
         ylDZ0dUrqL6VUFCmRxUn0Ci6m9al5/z0pmggx4WDWzYhMRl+jDy0PU+YppxrwApQC1sl
         0eh75kZ8G+VAe9vBtYMnyRsTNs3oePQLDSbOhkv7H2MZtwu+XXgFqVX5ak7bIsc4Lhd8
         VsMkOzc3aR5LYo7HkRBIIV064XwCN1bzm3PhSEar8unYb/N3ABYVMXVBgU1i+BDIuSCD
         SAIcz6CEeluuCRFi9xm9X9JvmFDwnGih91k4oHAYH0YaujDdE9jzDkym3paXUh51EiPk
         njcw==
X-Forwarded-Encrypted: i=1; AJvYcCUyW4cPuej7Xd1DLq99rPRNFXcdktzHO4eyDwf654FJhXXlCn5hyrM7122vEGJ6p2vkUYmtopQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YxHWIO37TvKT/zjq0wJgRUV0ZooE0K2j/mT0X1+a+NY0H/uWwTR
	IL00ZPWAxYCobmaeU12lq2kANpzwvQ0EP1wRa6HzzwpkIq3FH7B+vwE6189s2TbGGHeoPU9l0jG
	s7A==
X-Google-Smtp-Source: AGHT+IFGVv11dt7rUK+obI9Bx4C62kJ/MvcG+5bk3TDAhhA7vlmUxcL80d04RZFegq2L9eKJhwQmELWuf+4=
X-Received: from pfnz20.prod.google.com ([2002:aa7:85d4:0:b0:730:9951:c9ea])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:84b:b0:736:6279:ca25
 with SMTP id d2e1a72fcca58-73980463170mr23448772b3a.24.1743540425095; Tue, 01
 Apr 2025 13:47:05 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  1 Apr 2025 13:44:22 -0700
In-Reply-To: <20250401204425.904001-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250401204425.904001-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.504.g3bcea36a83-goog
Message-ID: <20250401204425.904001-11-seanjc@google.com>
Subject: [PATCH 10/12] KVM: selftests: Assert that eventfd() succeeds in Xen
 shinfo test
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Sean Christopherson <seanjc@google.com>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-riscv@lists.infradead.org, David Matlack <dmatlack@google.com>, 
	Juergen Gross <jgross@suse.com>, Stefano Stabellini <sstabellini@kernel.org>, 
	Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
Content-Type: text/plain; charset="UTF-8"

Assert that eventfd() succeeds in the Xen shinfo test instead of skipping
the associated testcase.  While eventfd() is outside the scope of KVM, KVM
unconditionally selects EVENTFD, i.e. the syscall should always succeed.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/x86/xen_shinfo_test.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86/xen_shinfo_test.c b/tools/testing/selftests/kvm/x86/xen_shinfo_test.c
index 287829f850f7..34d180cf4eed 100644
--- a/tools/testing/selftests/kvm/x86/xen_shinfo_test.c
+++ b/tools/testing/selftests/kvm/x86/xen_shinfo_test.c
@@ -548,14 +548,11 @@ int main(int argc, char *argv[])
 
 	if (do_eventfd_tests) {
 		irq_fd[0] = eventfd(0, 0);
+		TEST_ASSERT(irq_fd[0] >= 0, __KVM_SYSCALL_ERROR("eventfd()", irq_fd[0]));
+
 		irq_fd[1] = eventfd(0, 0);
+		TEST_ASSERT(irq_fd[1] >= 0, __KVM_SYSCALL_ERROR("eventfd()", irq_fd[1]));
 
-		/* Unexpected, but not a KVM failure */
-		if (irq_fd[0] == -1 || irq_fd[1] == -1)
-			do_evtchn_tests = do_eventfd_tests = false;
-	}
-
-	if (do_eventfd_tests) {
 		irq_routes.info.nr = 2;
 
 		irq_routes.entries[0].gsi = 32;
-- 
2.49.0.504.g3bcea36a83-goog

