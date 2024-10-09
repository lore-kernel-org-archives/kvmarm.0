Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1451202F6D
	for <kvmarm@lists.linux.dev>; Wed,  9 Oct 2024 15:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728489010; cv=none; b=DxZ1GSoZ8uqPUOI5kLcaLLQODOiQMO6n0hLuDki5MATZyOUt1KxkSnhO6x+k4MNc5DGjyqHfO/Vu2SykF6107AeYekMqjcrLZg247OJJC7JAux1Qq4pjIk7G4NucGSN40+8Eqsps7ijVf05x0QVNwla0B3n/HqVpCJr9H88MTIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728489010; c=relaxed/simple;
	bh=rzKl++CWaUW8jRUGQiR8avz8+vDBd2uSvVkufkDoQug=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aR8NugL4xiUaJxvetoMyTRBsZqmsER9xQ0eFRT32/V6jy4trw6S5i9+KawEkvGoHc/SmiWqNQan5SvrJhZ6yu/PGkHGoFkE4/5XkcVsgRFM2dRsDUfuafG/R9vZUxyYU3Vs1nTJE+Osu9nT9z9n3wNi6h6TQz+Nym781UwalsqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cDJ0fdXe; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cDJ0fdXe"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6e0082c1dd0so146325527b3.3
        for <kvmarm@lists.linux.dev>; Wed, 09 Oct 2024 08:50:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728489007; x=1729093807; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=9+y7oelTnk6r5KXO5BIzd9TWGjZrwMN3AFTrylQnTmc=;
        b=cDJ0fdXeL3bU9YEY7ikCVgnxIVP5I91weAz0GDOFg9Fz7BTYD8zbt6hzDblYu8jfBV
         5J7mZIv41UPZe5kz3oTPkpyCko4wiaMeFniuMWWXSwtXxMLFb+H/gOM5/UkSG3e1CY0v
         Rwa+oNuSCSheJE71qU61PsZF1aXvO+AECmmqr4Arn1vD0JjRFkxvawytwsmtt71sRfkq
         yQm92VDM3a+VJOwVblvlDKgRynM/dJz3S2cQzNA1/3zY7prNVfRk/LRHpwaDgj2vsmiz
         8a7vIHesJtg02QOoz/kz7ji+AGezHeO2T8mGiyrvbPQw0lvBxYCwlHpUOBIgcGs0tYjP
         xMAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728489007; x=1729093807;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9+y7oelTnk6r5KXO5BIzd9TWGjZrwMN3AFTrylQnTmc=;
        b=TyZQMrOEt9g2VUXYyyV5JtEqI8XIdAzPTiZ3AYSDMmThhP1TStP+muH5y17r4Nas6O
         vZAkxHFRnszuuym7NOUpaV6UhUokZLWuxcSqn5a7ybqbtG4cXRO5VRdfoMjPmVSGERRB
         kaMi2tizbXYFcd+SbjLqJeZgzC2tdWo0MVmy+RP/UZWThFCbMRxl3xNJZ0AKRGsgO/j3
         HCnhuR9Byp25BQQ+2/VaHgEdOFHY2FVLM6BcPprN9JNZ4lAkSIKDxF+khVP9Rd5sEe7r
         WA5BPbNK40V3I/8MzMXHGbtQKDDXkqzy+hKOoJHep72FA1zw5nIAYvEiJkMBMwYeDQ7E
         0Rnw==
X-Forwarded-Encrypted: i=1; AJvYcCXkasRkuTmi1LOS/oAmqYIUElmN3odWzuF9fRMPLGzs+3OXrZNKar84gXltzzsM3DXOPujFxuo=@lists.linux.dev
X-Gm-Message-State: AOJu0YyZ0ApAQNrheaIZhCnTTWTUEt6QJpP1gB/dMqCV8X6oeEZBHk7i
	qsSODpvjjt5ezwJKeL3GsCtCva9NC42AI4Xb4+YT7OftQ0OPwh9WwgH4EsprJQadQ0pgGn2CQDY
	S/Q==
X-Google-Smtp-Source: AGHT+IEnOiEr/7ufmCoIIHo0RYjnE1E6sJgU5IKNyLPqmQLuHnTee5V8zvUGQ36LhzFM/1nmzHnRUzKqVBw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:690c:4b08:b0:6e3:b93:3ae2 with SMTP id
 00721157ae682-6e3220deef6mr671277b3.1.1728489007658; Wed, 09 Oct 2024
 08:50:07 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  9 Oct 2024 08:49:45 -0700
In-Reply-To: <20241009154953.1073471-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241009154953.1073471-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc0.187.ge670bccf7e-goog
Message-ID: <20241009154953.1073471-7-seanjc@google.com>
Subject: [PATCH v3 06/14] KVM: selftests: Rename max_guest_memory_test to mmu_stress_test
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

Rename max_guest_memory_test to mmu_stress_test so that the name isn't
horribly misleading when future changes extend the test to verify things
like mprotect() interactions, and because the test is useful even when its
configured to populate far less than the maximum amount of guest memory.

Reviewed-by: James Houghton <jthoughton@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/Makefile                            | 2 +-
 .../kvm/{max_guest_memory_test.c => mmu_stress_test.c}          | 0
 2 files changed, 1 insertion(+), 1 deletion(-)
 rename tools/testing/selftests/kvm/{max_guest_memory_test.c => mmu_stress_test.c} (100%)

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 6246d69d82d7..8c69a14dc93d 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -139,7 +139,7 @@ TEST_GEN_PROGS_x86_64 += guest_print_test
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
2.47.0.rc0.187.ge670bccf7e-goog

