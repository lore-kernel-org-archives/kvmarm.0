Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72871204935
	for <kvmarm@lists.linux.dev>; Wed,  9 Oct 2024 15:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728489018; cv=none; b=SC3niERJF8R7L0L00BiWConJdZTKyRKIm/+pjRtL1p3WKHTW2OHeeZ8xjGanS2Zpwxg+QY7WQnNKiNYjZ5uUcAf6aUWhjqQHom96ZaeF4H2FfdqA88vR8lAZPKWNSzk/nawBWO7X0rUk5bJyGM7dMbnRZtQWnb3aMuONcJ+RS0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728489018; c=relaxed/simple;
	bh=IEk3C5HK+2fLDSHn3IY0LURHtrY8S+z4Dg7g0+3tBIE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bqIqAgDBO0hhaQpCOc8+/UNgL0lzaPYMonqjuEBurlH9LcOUNJiP2I+NnWLyEDG/ZsBv/RMTRDoDmsaSEywDpdsl4rFfV3h+ZPpvVrkSpOkdM5lAeY0pL5Tm/XU9XA4VGPlq9wMBOXffM+rIYcJ5IdRldTuEdPdUKbkd3MLXZA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NLxD9wy/; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NLxD9wy/"
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-71e0228d71dso3363901b3a.0
        for <kvmarm@lists.linux.dev>; Wed, 09 Oct 2024 08:50:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728489017; x=1729093817; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=jc3MwSNX0+J+oR+H6AzLHubLG9mcnf8agevCb1Rjaqg=;
        b=NLxD9wy/p2l4bGR7O4nUm7OcTfy1ksdhMVx8JRnqJxDEUpA4sAj4qVuEdl5wY4KE4q
         ShThMXjROLx2iY4XQj/HPARnVKxxnkAXA8NZQ9cizFPkl3XlLkUqH1Opx6h246eypxvO
         Ad4wG5ovTrblniLF87GvBVzWMbn+nT0dqjgzXvEm0q0b4M0bqoHKYKRzBSlgKezpcWE9
         vaaMf8rJb/vvbyHUZw4heL29Ae4pGOipa65Mt2sunMALUvRKMT8fPWuA7ts9db5AVKvt
         WLl0NnAo5sS/ZMI9Drq2GCLTqZqeZKJaT/JQZ70lcESbGmbWklgNnM0NXxcrbapKUC6W
         WaOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728489017; x=1729093817;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jc3MwSNX0+J+oR+H6AzLHubLG9mcnf8agevCb1Rjaqg=;
        b=ZWk16cBs2wGk9MxwxAJopydBqBA66vL/0V6jOnTuwlwWFyGqAjwu/5zYcc3CzY82yN
         4jzefWoY6mHJKK7QdoiCLLna6IunSRVOMP0yML331m4f8IvBbMPZpCT9T22WT3DjCZPl
         Znmg9Du+fULIAucAZrXYlXGy3gVnWUPWRjp4oXec97weukw6gGrO7FHO1UH8x3N8wFF6
         ppSQDZJ7xzw7gmonZillQwOXKei2hiKK1pxyye9CYHcKelXlIw7F67fnRsGRj0iAX9wW
         Mpn2pl2oH45G7WrXwEVwYo9X4aPNJihkHbSMFKxBuRYm5FJ570arMEyAhRWsrEuEJSlw
         1m5Q==
X-Forwarded-Encrypted: i=1; AJvYcCWkKOqYnrvRt9soWKF1toSJbH1OlCm0fF44UWB8094p1gIhqAumsCf8dXvDkLOQfmGn5YS+v9I=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx6lz6xkpgc9a/LAeQxuFjsVdZ03dJxcEqg/tNp1qjFMYjG/f0o
	2DIbWjVyk1EJLZ6fNnN2xflaI53WP9OEUstnC2ArPvg05pHFaByD1Cv0TR8gYo2hBPBuB0qHGr6
	+ow==
X-Google-Smtp-Source: AGHT+IHtPJEK4UvnUH2lB7bwyfqs7oKhFlAZAFDdmrNEVSIuNr6gJJns/OGC4yt52V7y0o2FJEVYvG06l9M=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:aa7:8f88:0:b0:71d:ec11:1214 with SMTP id
 d2e1a72fcca58-71e1daad342mr3780b3a.0.1728489015563; Wed, 09 Oct 2024 08:50:15
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  9 Oct 2024 08:49:49 -0700
In-Reply-To: <20241009154953.1073471-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241009154953.1073471-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc0.187.ge670bccf7e-goog
Message-ID: <20241009154953.1073471-11-seanjc@google.com>
Subject: [PATCH v3 10/14] KVM: selftests: Enable mmu_stress_test on arm64
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Paolo Bonzini <pbonzini@redhat.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, Andrew Jones <ajones@ventanamicro.com>, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

Enable the mmu_stress_test on arm64.  The intent was to enable the test
across all architectures when it was first added, but a few goofs made it
unrunnable on !x86.  Now that those goofs are fixed, at least for arm64,
enable the test.

Cc: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>
Reviewed-by: James Houghton <jthoughton@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 8c69a14dc93d..4db74792d689 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -178,6 +178,7 @@ TEST_GEN_PROGS_aarch64 += kvm_create_max_vcpus
 TEST_GEN_PROGS_aarch64 += kvm_page_table_test
 TEST_GEN_PROGS_aarch64 += memslot_modification_stress_test
 TEST_GEN_PROGS_aarch64 += memslot_perf_test
+TEST_GEN_PROGS_aarch64 += mmu_stress_test
 TEST_GEN_PROGS_aarch64 += rseq_test
 TEST_GEN_PROGS_aarch64 += set_memory_region_test
 TEST_GEN_PROGS_aarch64 += steal_time
-- 
2.47.0.rc0.187.ge670bccf7e-goog

