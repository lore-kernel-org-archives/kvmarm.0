Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92D39242D77
	for <kvmarm@lists.linux.dev>; Fri,  6 Jun 2025 23:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749254211; cv=none; b=PBY0lh43fOd/xUTFE8GOA23hKaDkApdug9+/wujI9VjmD/guORYhkwLRy3PUyIA5JKo0s4nO9fEbJTNHgoiZrAZ8moN3e8AxbHLxGK16fLpT+Z68ecnGoNyAnNkPmVqnpYHuObh3iH+Dp07/sjyjnh6vXosf406NnMYV3TQU6Ag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749254211; c=relaxed/simple;
	bh=5kWmyg0mzQCWaMvRR7AqG1JiSbOPIy1E7Aj/zN7WjQs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qJYXUM4DlxIupg6eOk71/Kvszi6C+/sjUQKg3ax6/85NfD2KFkLxASRXmKorZ3Jhb/F/pWFsbGPKRRS/+1PjOpQL3vlovGnydno/YA8kBOiVDYDjO0sELZrE6nqFvpxiyIhXq9vr8a81Cnky3oJapzdVxg2TNE7vY5xxlTf++3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ydTfETAc; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ydTfETAc"
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-748269c6516so1243005b3a.1
        for <kvmarm@lists.linux.dev>; Fri, 06 Jun 2025 16:56:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749254209; x=1749859009; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+L9DXCjLorTxOh1B5xNStH2dnZ/sReG4cpxDvwmWD0Y=;
        b=ydTfETAchGRlpGKjY6JcFAc2vtAejBK06gIRzmV+dYvI9coO7UH7QT4RFRnSbHkJBy
         AbNxnhAmflgZqjFZCanwEsrtikD/SAmNt7cNrxCmuYIpIWqvT/5/puCwaOM604kfAQX8
         8Nu4A1J8S9XfVwYhCtGEUPco6gH8diJiw2MiX2wf/EgKhxS3GnhiC3oiuEZ0JYTmOx5a
         sTBNQn1X1uvdgFjJDuX4cNwu9P8LshVmA96CLMhl/j1TBZJj5eEjpDAHieOpFVm0KWZB
         +WvRYbvt1zcHKDwY78Wb3dsTc00Ra2f1C1h+0Mk2NVZf+3NF44rMxoaGdQ8X/E/TpQ1d
         PUKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749254209; x=1749859009;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+L9DXCjLorTxOh1B5xNStH2dnZ/sReG4cpxDvwmWD0Y=;
        b=cblHTHItAU11qaLb9mS03b3TAfJjViqYHmzzSYaj6CiWQlkDXJeHtw7viipMaNgn9i
         MqpzzsICSnZ6INvFn/FHMPQpOSpnLzTEcwks01civ1E2Yi3Th+s2Sz7vX7MPknPMJ8A3
         12hX934YgHzvO4ozLbJ8iGJ5btIZ4De6PrAyGHATJwsTyETzawwsZXFul+KKHP+wglk+
         YkgbjPLXKI1XCD+hxYh3NMCMjuQiwMkGsfLsswFoynVIl1HhSw+/doRWsJ4A5g3MuaH6
         B97IYZQa/rYGtA24gXVSre9B0kn/XA3vPCoM5xy6hArYr/+2g9nS/Igh4kVM++Ih57Nh
         z3ug==
X-Forwarded-Encrypted: i=1; AJvYcCUDNJm+Sx5RwSZtylxkQVwP2OsbJhphbKigYkTj7I1kHDsv41E8lHb2QVIsVOgor28dtSNwYzc=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw32rE3kFH+8o0XNuwcywZ1xF7bz8hJ8L4SnZ2bhi1nctgk1ad3
	n+kK4qi9IzD2EIlbD/prna94Rwub2WYFBKQMV0YzHM87dyxN/9iUYi2RArqlMPM8IzTs5fy9n0B
	DLFgxwp919g==
X-Google-Smtp-Source: AGHT+IG03XZnvqZOkOqBwMRzzNhIPgcN1ZsHQWgIs4EPRw8vsSrtSnCZF4xjJkBMv/LE7Ar4ODi53Kp40Xk2
X-Received: from pfbdw13.prod.google.com ([2002:a05:6a00:368d:b0:746:30f0:9b33])
 (user=vipinsh job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:3016:b0:742:a23e:2a67
 with SMTP id d2e1a72fcca58-74827f14a6dmr7102295b3a.16.1749254208946; Fri, 06
 Jun 2025 16:56:48 -0700 (PDT)
Date: Fri,  6 Jun 2025 16:56:15 -0700
In-Reply-To: <20250606235619.1841595-1-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250606235619.1841595-1-vipinsh@google.com>
X-Mailer: git-send-email 2.50.0.rc0.604.gd4ff7b7c86-goog
Message-ID: <20250606235619.1841595-12-vipinsh@google.com>
Subject: [PATCH v2 11/15] KVM: selftests: Auto generate default tests for KVM
 Selftests Runner
From: Vipin Sharma <vipinsh@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-arm-kernel@lists.infradead.org
Cc: seanjc@google.com, pbonzini@redhat.com, anup@brainfault.org, 
	borntraeger@linux.ibm.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com, 
	maz@kernel.org, oliver.upton@linux.dev, dmatlack@google.com, 
	Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"

Add logic in Makefile.kvm to auto generate default test files for KVM
Selftests Runner. Preserve the hierarchy of test executables for
autogenerated files.

Autogeneration of default test files guards against missing these files
for new tests cases or rename of existing ones. These autogenerated
files will be checked in so that during git-diff one can easily identify
if the existing test files for the same test binary also needs an
update. It also add new tests automatically in the default coverage.

These files will be auto generated with each make invocation but
overhead should be very small as these are very small files and won't
be shown in git-diff unless test name changes.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 tools/testing/selftests/kvm/Makefile.kvm | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index 307ef31d3557..a76502406123 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -201,6 +201,14 @@ TEST_GEN_PROGS += $(TEST_GEN_PROGS_$(ARCH))
 TEST_GEN_PROGS_EXTENDED += $(TEST_GEN_PROGS_EXTENDED_$(ARCH))
 LIBKVM += $(LIBKVM_$(ARCH))
 
+$(foreach tc, $(TEST_PROGS), $(shell mkdir -p tests/$(patsubst %.sh,%,$(tc))))
+$(foreach tc, $(TEST_PROGS), \
+	$(shell echo $(tc) > $(patsubst %.sh,tests/%/default.test,$(tc))))
+
+$(foreach tc, $(TEST_GEN_PROGS), $(shell mkdir -p tests/$(tc)))
+$(foreach tc, $(TEST_GEN_PROGS), \
+	$(shell echo $(tc) > $(patsubst %,tests/%/default.test,$(tc))))
+
 OVERRIDE_TARGETS = 1
 
 # lib.mak defines $(OUTPUT), prepends $(OUTPUT)/ to $(TEST_GEN_PROGS), and most
-- 
2.50.0.rc0.604.gd4ff7b7c86-goog

