Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BEEA4D8D1
	for <kvmarm@lists.linux.dev>; Thu, 28 Nov 2024 00:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732755360; cv=none; b=NmivF9LiQ5GScn0djIgdVblAN5G2Qt3iS6Jw7NFpUH44moxfqYwLqt20rAQ6/xIfExpuBXzaESlWdZnjKVhKDTrmbs+NkbIJW+sWKUsDNZ9HfjwdDw+zKPW8R5HInNJ5VCKJK8Iwv6/L5nw/+05xkxBWC4ZkQCjk1oYiwIlEjyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732755360; c=relaxed/simple;
	bh=6/wTQsGJs8irAo/psByDX9+eFhZ+LD4ILASalomr9Cw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=t9rnTGhJlMkBUV+FRgbC4HFjqM+pju3VPrrh4r8kZcLQbaTLxqPzltgtVlSrk7k0ybpRuAjHt91uIqgO/lZFKo1gyIXYXcmHM4orgkSFCwj5Keu7TuVDVsTppxmnapFQhv9dFZgEJmfb0KptASe464wzvXLrPMxvZtEJ9kH9qnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=arl/vzDi; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="arl/vzDi"
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-724fc3f60c1so413443b3a.2
        for <kvmarm@lists.linux.dev>; Wed, 27 Nov 2024 16:55:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732755359; x=1733360159; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Qp0x5jmf6wCt1OmSFixie+OQOct6OMtePnY0hHC3FqE=;
        b=arl/vzDi3p5sCM+oceVY+IIM2cnsx+ohoNe0VqMv/Wki2bOxVU3I5UNRB5fR75xpFy
         MbOqp7S0JY6HdHAyEYO2fqsSkBZR+JXhX0WIYJinNPSlL3P1/UxGjppTJkCgU6zo3WqH
         j7qtrX6mKLD0TfSrcJjD/3e4aGALJFc/VdUXqEZVkflISJ8zQpiuIgbLMVQkzeYuh8we
         QYKBkD8lY/ZB6WZNG4NRzRRf8uhcafDY7502/0BYS2h1kGvkZV+SDXtzwL18iDtTf/Vi
         Z7j7dGlyVRC54o/Auk0uMFU3VVdilbBzgq3GNhdH1VMO3rVl0MzzFHLjY7i9y58MsURg
         X4FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732755359; x=1733360159;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Qp0x5jmf6wCt1OmSFixie+OQOct6OMtePnY0hHC3FqE=;
        b=e365bbpUQAxQU2wsAbeZRZPnI2usXB+VTFgoXxrylXEGimcMdOcWMr5r4GuiDcihbG
         ENEeB97o+dKOB7OiErM7JlsjHUiKff35tsm7cDGDrvRPMsSqT7ffnslUy5vZz7WPrv4l
         XduDZUBPR81vj3W/luS6K/+Blh+7poscEEEv9qfJpGKWHyMEMbz9xm8V4GSpWDDLCWSJ
         b0rb5kk2lToCa8GTHNp6xIL/newmi4HeM7jv+RXz1A8fT4UD1Jck9tedrMRGJN/g/PYF
         j9Xv2E+CNfdIZNhHG0lvQoMEOPiti7RzfGR+9J0SEQiwGiZCaWbBQ1ieFiufcg4ABybz
         6vDg==
X-Forwarded-Encrypted: i=1; AJvYcCVPqLijPaX7ErT09dZ/WZssUhmfEy/LrO812Je5LOeB6mYwDZU2K/vCIdmXgAOS+60KawPvsso=@lists.linux.dev
X-Gm-Message-State: AOJu0YzhXAjdDqa1twoRiVydJCcBVNlw66I8Z0bC0hSzL/kugoRmH0Z5
	eBcRk0c1l4lzfVBvrCta3uoHEEm2DEd3lm6UQvYJX5gZ7U1qKei5iMm0QLPmf96FGUe+tB+w/U9
	14w==
X-Google-Smtp-Source: AGHT+IHRct+tg9si6FXkj3XDfvATucfZZx/pmM1rsyJ2yuaIieXkck617uTZGF3kPo5jFFwMAZ2X8QIv/Kc=
X-Received: from pfbjo14.prod.google.com ([2002:a05:6a00:908e:b0:725:325e:59d5])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:1492:b0:724:f404:7101
 with SMTP id d2e1a72fcca58-7252ffcbf80mr6785726b3a.1.1732755358707; Wed, 27
 Nov 2024 16:55:58 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 27 Nov 2024 16:55:36 -0800
In-Reply-To: <20241128005547.4077116-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241128005547.4077116-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241128005547.4077116-6-seanjc@google.com>
Subject: [PATCH v4 05/16] KVM: selftests: Rename max_guest_memory_test to mmu_stress_test
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

Rename max_guest_memory_test to mmu_stress_test so that the name isn't
horribly misleading when future changes extend the test to verify things
like mprotect() interactions, and because the test is useful even when its
configured to populate far less than the maximum amount of guest memory.

Reviewed-by: James Houghton <jthoughton@google.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/Makefile                            | 2 +-
 .../kvm/{max_guest_memory_test.c => mmu_stress_test.c}          | 0
 2 files changed, 1 insertion(+), 1 deletion(-)
 rename tools/testing/selftests/kvm/{max_guest_memory_test.c => mmu_stress_test.c} (100%)

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 41593d2e7de9..4384e5f45c36 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -140,7 +140,7 @@ TEST_GEN_PROGS_x86_64 += guest_print_test
 TEST_GEN_PROGS_x86_64 += hardware_disable_test
 TEST_GEN_PROGS_x86_64 += kvm_create_max_vcpus
 TEST_GEN_PROGS_x86_64 += kvm_page_table_test
-TEST_GEN_PROGS_x86_64 += max_guest_memory_test
+TEST_GEN_PROGS_x86_64 += mmu_stress_test
 TEST_GEN_PROGS_x86_64 += memslot_modification_stress_test
 TEST_GEN_PROGS_x86_64 += memslot_perf_test
 TEST_GEN_PROGS_x86_64 += rseq_test
diff --git a/tools/testing/selftests/kvm/max_guest_memory_test.c b/tools/testing/selftests/kvm/mmu_stress_test.c
similarity index 100%
rename from tools/testing/selftests/kvm/max_guest_memory_test.c
rename to tools/testing/selftests/kvm/mmu_stress_test.c
-- 
2.47.0.338.g60cca15819-goog

