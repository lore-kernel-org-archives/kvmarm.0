Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 149492609D4
	for <kvmarm@lists.linux.dev>; Thu, 22 May 2025 23:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747957974; cv=none; b=hgXIKnxNolHnr2cYLQNGpdX2fam3RI5a8X7Qi2SbVkUn2XT21RxkP5dYcb8AgvCFH3Za4gZiYfGgmEs9XLxO46b7aV9yeND4w/6Red2mggZaZlYyH/xDdP3WvjY9lEo2ClOEXnw+mfXeMDpFntGL8ga+w3VRAXfocsaJgrWGbZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747957974; c=relaxed/simple;
	bh=gmLT2D1WB9vmr8rFdHxMOpHNwXh7MFDJ6xUGtYQhimw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NLtsXv0REG5EK/fxTpLx5fkgkUyu1ZKSM6u/orLJ8/XyuWaM9lvE1vbqRQ9sE+c0vUoCuSAGJPph3nCyro7TBoeud9Ol7C+IPXlavVktsbOaAUwfMDi3lkFGF/D0u9ZZApfFoHP/oMwz55kOCRPcXk9U+nOjZP6K2r1n5MfZLQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=afzXRqHf; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="afzXRqHf"
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b16b35ea570so8409918a12.0
        for <kvmarm@lists.linux.dev>; Thu, 22 May 2025 16:52:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747957972; x=1748562772; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=jjMNjs+bdNtZTb3Wdy6sSLCs56ksmcfEkIHqJR2gBFc=;
        b=afzXRqHfxbLWiiF8DBMaEkC787UGYVmDyaYwTRu0ewuZLPr7LJf3/5kBhXTrJ2oAIx
         rIA/EEWsP1bdtE3uOPkleHOHSqYEtN+E8itPAChIQbjQmX6aPQF2N/Hxf4QcgqFrVtkf
         pdkcja+5L8VfeTL4pq0R1/Ue+Seg8IOGkx4E4C+5oZC0pZLWxXKBwTcvrKTBOe2SO20H
         2ox9rXNp85PagtiS/1TrM6lq6LDCGv0liMLEPJlhDGdclO5QMLCsTShjg2bKFbulcema
         pfz5jQPebIEnxNo8FEPEBE8VWDXNsivgxNFWrm9H7feqtTXMlKcy816qaGb6MenUneay
         sqQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747957972; x=1748562772;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jjMNjs+bdNtZTb3Wdy6sSLCs56ksmcfEkIHqJR2gBFc=;
        b=KPcjF9A76k06/7R6RbMGEZ+vAA8W5g/xp9Zzm8fNiNOv61i282luvn+KdS1mbtRbHC
         7/bpqOGPNPpcMq0tul1+jvm/m5qhI9TvFA1TX+ux+aDMFrIng41y0ezmAzN5qH7kqUVn
         iTYbR8F3QoMJdriumM6IBNGIKuxSHq77gZScW/QkVb45AfeZ+HqAxEfS96DwJakmIstk
         sWMMALev6eSRI7ls9YGafgVWNsFDkgU3H4BmjnlRZ9plQ+ZRj4HJO/LpV2XWfh1/AVqn
         NR1MjgfAMWRTzobfDM5o6fxOEegv9y9oBdzAJIbe5+sR1sZHXzG40+qvU83JZGSDAW/V
         SrGg==
X-Forwarded-Encrypted: i=1; AJvYcCWMb3EV2DIYXrQN4Fhm16jQvpZ+45abVaeCaEwfTT8kHwKsf7UunDjmQFQWsVdEfl9F2TVUAKc=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy+L8O6xcmTscQyLAg/kkHlL0hXIxovDlEblLoWEbYGs1xGqfP9
	alhQug6F62Wcbx+87yxtxr9tBQT2KI532Tz0C0KJ7UvqbKbxAFC2jkDTi52o3ohDgjvw/H9Mf+E
	SirhOZg==
X-Google-Smtp-Source: AGHT+IH+y/4Vqk1KMF3LjOCFUbppIPh5ZUErAvUoiEDW2SE/2hXGiqyTLKxlZ9Xh8ZuSjxO0WF45GST49oM=
X-Received: from pjbdy5.prod.google.com ([2002:a17:90b:6c5:b0:2fc:1356:bcc3])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:510f:b0:2ff:58e1:2bb1
 with SMTP id 98e67ed59e1d1-310e973e510mr1311217a91.32.1747957972660; Thu, 22
 May 2025 16:52:52 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 22 May 2025 16:52:21 -0700
In-Reply-To: <20250522235223.3178519-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250522235223.3178519-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1151.ga128411c76-goog
Message-ID: <20250522235223.3178519-12-seanjc@google.com>
Subject: [PATCH v3 11/13] KVM: selftests: Assert that eventfd() succeeds in
 Xen shinfo test
From: Sean Christopherson <seanjc@google.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, 
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>, 
	Juergen Gross <jgross@suse.com>, Stefano Stabellini <sstabellini@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Shuah Khan <shuah@kernel.org>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org, 
	xen-devel@lists.xenproject.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, K Prateek Nayak <kprateek.nayak@amd.com>, 
	David Matlack <dmatlack@google.com>
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
2.49.0.1151.ga128411c76-goog

