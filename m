Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50E054437A
	for <kvmarm@lists.linux.dev>; Sat, 11 Jan 2025 00:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736556658; cv=none; b=E29KbSP+xFQ/h9oZaMWiucJ8l/hwV1zLMGKV8eqZ2+Kevyh/KcuJ+hJqHFCWaxZN89rvxEYzunvmi3v2LGCGy0fZqp8KWwCR8e2eyxd9cK1ZyW1EPhLQQ+FgMVnP7tMJ4zRTADdqO2fbAj1RA5nE7w2AG5NYXMfsjJOSuZHUoKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736556658; c=relaxed/simple;
	bh=nrdiuySPKeqHKMTcasOrezgYsu9kEOPLrcUW0My/0sA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hvssQ8gqVKQVDmVqAB8K8OxV/2z5SBP78+WYvNpivzoqHh9HDihIVnJG0/fTNIqULKq3Lz9ZYI9BxbpyQrZEopNyeSlnV8Vi104JQ1OVDauYtI/tjwhUkkSrjH5hYS0tcH/qGbAJFCk8Ns2JknKGYFSQdFq4LoygaqaMkIjR8AQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ywhKPngr; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ywhKPngr"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ee8ced572eso4788226a91.0
        for <kvmarm@lists.linux.dev>; Fri, 10 Jan 2025 16:50:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736556657; x=1737161457; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=fmZxaHK89gYqxCqQ02UIn+br/dW4oBYWdpIBYGTzQvU=;
        b=ywhKPngr7JfomfZ2i3WqyEUN0nxVytDtU7vGuubGPbiLCtvDJNp1JBh6FSyYLMMZPb
         DplYGogSM94S9MfHWKG6oO96Qqme5PqsJi1gpcwnueOWVeR7UZJ3UD0z2BknliAZcka1
         nLi91nyS5/YEb9ridTCyu9HqQ1Hd01ufUwx1U5G8mXfu0ZO0ser0RtzE67HsZosZwve2
         /1uaJw8WF4JtxbddEI4xGKqCzj2kOyAOJM10hzJ0oj3vaELHUFP36admhqXwRhqmBnSE
         JAC+7Mb6zV42s4nsUfu7fS3jNB3nvQNoYtwo3hdltEaKJV7A1PjDKV7hspkGRtAhVwk/
         nGAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736556657; x=1737161457;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fmZxaHK89gYqxCqQ02UIn+br/dW4oBYWdpIBYGTzQvU=;
        b=R4KMw0oxc8YnmxTUxy+K2wXuEzIv3oxMmaOrS9sTjENnsCBWUPxMZfJya0lJY+r3hZ
         lO/1fNup/g+k+ECPp8F66megMcmhT65OQ6ERIN2Z/sbIU9MtEG1khuw0+Yyjh3EhGCLb
         GzxLz7+JCYOxv6Ccnx5ear7mmRksGawAJfKQYIhJwXjbNNqzCmsKJj/iaNhR3hxu3f3Z
         NNgQkABku0HnrGiAMTlOknJQDtJT7wuSXbR+XACy9EziBrsnbmbahLBjsXIzAgvaf9+0
         AC/iar1MFK/9FKrZj9aMLlYnDCRKra0ROD1M2zoYQ5GTzFbrz1Xeiw5FRNeyHkBqJY3b
         Fcmg==
X-Forwarded-Encrypted: i=1; AJvYcCUY25CE3qByLsR0T3R194VXTwtifYujbdroa64nopRFe/ok9u/jGvJMHMKbKJMPmmlhA/NCQTQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YxOBfJ1JksTR8NaXbbr3xkdXARv9eGVCIqxRZ90JxHVIfUY3aR/
	4icTNlLczSIunPc5OHdvFZoThn8YJa742BzHNb2VmKRCs7ksYWlGs5gkkqltx81G/pmHbM9v7YK
	GTg==
X-Google-Smtp-Source: AGHT+IEiPYhZFrxECLTpeRyhrniySkHxs86k154WoHT+4SPRvFRx2z0MZkxZdNLfF3LCv7K79vdra9fQLrE=
X-Received: from pjz13.prod.google.com ([2002:a17:90b:56cd:b0:2ef:7af4:5e8e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2cc5:b0:2ee:c91a:ad05
 with SMTP id 98e67ed59e1d1-2f548e984abmr17519047a91.3.1736556656714; Fri, 10
 Jan 2025 16:50:56 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 10 Jan 2025 16:50:43 -0800
In-Reply-To: <20250111005049.1247555-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250111005049.1247555-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20250111005049.1247555-4-seanjc@google.com>
Subject: [PATCH v2 3/9] KVM: selftests: Assert that __vm_get_stat() actually
 finds a stat
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Fail the test if it attempts to read a stat that doesn't exist, e.g. due
to a typo (hooray, strings), or because the test tried to get a stat for
the wrong scope.  As is, there's no indiciation of failure and @data is
left untouched, e.g. holds '0' or random stack data in most cases.

Fixes: 8448ec5993be ("KVM: selftests: Add NX huge pages test")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 9138801ecb60..21b5a6261106 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -2238,9 +2238,10 @@ void __vm_get_stat(struct kvm_vm *vm, const char *stat_name, uint64_t *data,
 
 		read_stat_data(vm->stats_fd, &vm->stats_header, desc,
 			       data, max_elements);
-
-		break;
+		return;
 	}
+
+	TEST_FAIL("Unabled to find stat '%s'", stat_name);
 }
 
 __weak void kvm_arch_vm_post_create(struct kvm_vm *vm)
-- 
2.47.1.613.gc27f4b7a9f-goog

