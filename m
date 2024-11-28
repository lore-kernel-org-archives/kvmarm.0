Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0EC313DB9F
	for <kvmarm@lists.linux.dev>; Thu, 28 Nov 2024 00:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732755367; cv=none; b=KI69QG47TPZICrytAbwxv6g8fjMm6s27J/YbDJY4qc7rFCaRVaVz6sfYrQvQ+BqkO7U1RGGXcrmqNRAf/ItRDDFrjvIrgzKV1hSiRMNaNLxRTXK8t72fmtYpRh7dR3ldBdxJdjdAFksRjch7kZRASkPeY9WXK17cFaj29BI1owU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732755367; c=relaxed/simple;
	bh=aNYWrhV3+Hlqkeo6/DSEk9PQ+DunnQgH+0LyxQ37ZvY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=I542vN0UtMJkOv4mM/TNiOF8vFOe2zFUhZ1TT0U7yFVniwk5Vfg9/53rokiGykd1H5KimIqWUrbIpzDteQ5nVlwPMzy+JRLXpQAswhZjyvtd8Qoqn1AAR+3Y5D4gBoEr9Y0apFtoMAU0U3jqv/gLtP/2AyU62XZ0Tri5jhVlcfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IdiJ6Wwj; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IdiJ6Wwj"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ea9d209e75so301195a91.3
        for <kvmarm@lists.linux.dev>; Wed, 27 Nov 2024 16:56:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732755365; x=1733360165; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=m3N0I2xWsrfV4i9nnr3KT1Cpmm4B4GrEhZX0cF+2Gqk=;
        b=IdiJ6Wwj2SflF0Oma0GsgVlX6eKxzJxCGWINGLlfI1vCi9aghETEIyPTbrjTKkT0Bv
         jSnimeVe+OBRFNikN91MWJXmEKhQ4YECsICcLnGcvkwcF4D3QG/7lCbheSwfUI+rjXVg
         qsxgJc6U770ZHxMHepgB2i/8tBKReGn2uXW1Dl9FdBIBUw9nhwuJS0bT/GQguhVgZz83
         H7SQuo9+KYH9MUBF44jk40j1KYy9RHdVddQ6tsvS+yOUYIEAMAIuxe5jfVpBaWCqXdDB
         3tQajIHTvQg8AJJM3vY/hVKFEOHq3x3vQ5GVlzYEfGnyEv/YpQnS8DM0xcO3CZ2pW9Ue
         NyZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732755365; x=1733360165;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=m3N0I2xWsrfV4i9nnr3KT1Cpmm4B4GrEhZX0cF+2Gqk=;
        b=Kv3sf4Zci9z1h3/WNpk5sW4zEGEoSfdMzhjyAwAkxNXoxj85nNq6wlCqTtmA6mwXJq
         vZQjsOn0bHMmRjFvCFp0ViVOKgT6gbTlAEFjpjVxQH1Smcl2hiSKE4gjyIxgy6Kkp6Cr
         Wd0gqUK20MYximRo8TaaqBeemVifhoF1c2J+JZMajFjobApKYHJN+210G9bHaI4StGZz
         bVm9fFVJ8Qo/VUjYo/5KEBmOzWSfKWZlJDW0ktGZbus0zb5Yk++FLgrHN/feCZfHP14a
         lNqLQSld0DPr4pm7juuFuw2RB4gdf7xcsguk3BzRJ6gA/vgR4hEVoPktyB+uDvxQaLuN
         3+sA==
X-Forwarded-Encrypted: i=1; AJvYcCXkM5LlOwz2gOJepEScbv2VQxVRsmm0ryANf5i7RIDNrSrkHb7WdIcXb7tj6wpA2fifs+q1FmU=@lists.linux.dev
X-Gm-Message-State: AOJu0YzdW+dnLJaiCJd8T0kOXSXH9IySLdsZr7NVfvxgZgapA1VwNQaI
	1Gu9oVMv3T0WDtlzF26EUUGzBOiTCeKpK2Y0bnKIz6ADgFI6QihPYpwKfwbLwEa/JvCZlGkHI+j
	bHQ==
X-Google-Smtp-Source: AGHT+IE4OA2YWpjZt4cUyGKEolrSn+wbKfMl6eazhCePp/W8mIleK1HW5p9Pm9svs3J06p9qg41Q+800XRI=
X-Received: from pjbsn5.prod.google.com ([2002:a17:90b:2e85:b0:2da:5868:311c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:28c6:b0:2ea:6f96:6504
 with SMTP id 98e67ed59e1d1-2ee08e9c7a3mr6508990a91.1.1732755365479; Wed, 27
 Nov 2024 16:56:05 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 27 Nov 2024 16:55:40 -0800
In-Reply-To: <20241128005547.4077116-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241128005547.4077116-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241128005547.4077116-10-seanjc@google.com>
Subject: [PATCH v4 09/16] KVM: selftests: Enable mmu_stress_test on arm64
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Paolo Bonzini <pbonzini@redhat.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Sean Christopherson <seanjc@google.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Andrew Jones <ajones@ventanamicro.com>, James Houghton <jthoughton@google.com>, 
	Muhammad Usama Anjum <usama.anjum@collabora.com>
Content-Type: text/plain; charset="UTF-8"

Enable the mmu_stress_test on arm64.  The intent was to enable the test
across all architectures when it was first added, but a few goofs made it
unrunnable on !x86.  Now that those goofs are fixed, at least for arm64,
enable the test.

Cc: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>
Reviewed-by: James Houghton <jthoughton@google.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 4384e5f45c36..c59a337cd4da 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -180,6 +180,7 @@ TEST_GEN_PROGS_aarch64 += kvm_create_max_vcpus
 TEST_GEN_PROGS_aarch64 += kvm_page_table_test
 TEST_GEN_PROGS_aarch64 += memslot_modification_stress_test
 TEST_GEN_PROGS_aarch64 += memslot_perf_test
+TEST_GEN_PROGS_aarch64 += mmu_stress_test
 TEST_GEN_PROGS_aarch64 += rseq_test
 TEST_GEN_PROGS_aarch64 += set_memory_region_test
 TEST_GEN_PROGS_aarch64 += steal_time
-- 
2.47.0.338.g60cca15819-goog

