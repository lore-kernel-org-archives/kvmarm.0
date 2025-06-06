Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AEE0242D77
	for <kvmarm@lists.linux.dev>; Fri,  6 Jun 2025 23:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749254215; cv=none; b=uKlorptOUheDEnktPI56e/vk0ySpSmeTh8T8Shbhsw2KhsvrX6EKX7Y55hyvu78l6vF1vu/jLUJzsTxnNIxtFNuMz7aeTQgp7vjUq/4wYVhkzFINUmb+JVu/Fk2pstYueE/KOKkUSxXNDovnW8Toa7nzeqiS3j2h9Wto4NyhvwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749254215; c=relaxed/simple;
	bh=X+N5g5XrDuhwGEsVAuvu1akbTIwI2YElq0jJKkUB17c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YaLe/FSlZ2VVUxfATZBvyeQC6pNyK1OEN2a1G1ZiwYX8FJ7ycbr5pGhf6kjyvQH7ZIxGOLvi690sutwjW8A4oUvrpIcrgGzSqOkCGwztVpVsL41GAdu0HjzWW7EN3igFQqxR78V8sRjYTv2gIT2oRQH46CY92C4VBx+fj2rWw/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mkUH8Cn0; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mkUH8Cn0"
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-74620e98ec8so2373277b3a.1
        for <kvmarm@lists.linux.dev>; Fri, 06 Jun 2025 16:56:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749254213; x=1749859013; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=21lsbUP4Pev7+bZRjEiLUIwgm/TC/un4IRPgZinq0rE=;
        b=mkUH8Cn0p03vm4I0mpGYTtjkjJP6h1dW+x6lYl1DjkIbH2dV45hKfICW5XPeVvn3+S
         hYYHPHUZsdabATAMISLNhlaOpGL+SyRhrNW6EHlgYmxnuymlKkOu4p64KOH6XVQhIT6H
         IX1G/EAL2mfWKXUz/h2qPdNmf5PCNd9kV+eMvhfRZzuRcfXDC9c4r6+cjPu86VjZr/Df
         wfXwbLmqZO83RQk9EpYL0GqkybJGieKcSH+SqLh9L7o5IillYgEHxpmtKb+iUn5sHHLH
         72TbnGOUFO3VNLF9bNaovx8Wt31dXaw7H+GCxGb5mxgi9/NhjwgA+A/prZmxeMTiOYUY
         HzBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749254213; x=1749859013;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=21lsbUP4Pev7+bZRjEiLUIwgm/TC/un4IRPgZinq0rE=;
        b=DDvbfiu0eNtYzca4lp7o2YKl2Z2gB80j8BXD+mZxLUhuVR7fzJxsBZJDJ0A0CviHRY
         MkJCZeW2SI/EhSqjLVXAs3c6Zg95qxOIBk5+chweozu3rKj4QonDZx9TqNWdhUiuuRsU
         nxRi2ZUDWi2S3w6LLRQ39CyVrG/3UGs58VxXJVtws44ipU4cEHiT4Ur4T5qVdAN16JXv
         R+5HiLSvFUJkE/YGRN/HF6qy2hESnSK7FoopJDfGmDZA2gHQWt2cg4Z3HyaOVb04H7Zy
         orohjKSIx//owBsILWX8ZLb9DJuN1AfB6ufz6VQk1D8J1wemLG8dJ4MEbChyoPE0hjSt
         osKA==
X-Forwarded-Encrypted: i=1; AJvYcCXYUS4ZAHlqihhDLalw6KK0HLM/26A9uU/EJcFxCKtC2Zz4AvDAYjOcan4huOPSSQcOzgEwLGI=@lists.linux.dev
X-Gm-Message-State: AOJu0YwojYyawTZf2v2nHrw5LD7qkpcW+6nJykA953qF3f/JfYPoGr8p
	yYBeL4nIAPF3JiyFGT5kNXz1UuKB8oIe7LY/tulrUE+OpNIImyl+iwtm0SuYR5BxUjLkoSFa/Ii
	VtW0xYKBvxg==
X-Google-Smtp-Source: AGHT+IFawjIwwAf5PF3Wi/OcDWRJ/ksSgwU5Sx+YrDH8kG+RVuMa1d7ri+swcbrCB/2Jc5d9zeGSaoAOQdJ+
X-Received: from pfop3.prod.google.com ([2002:a05:6a00:b43:b0:747:af58:72ca])
 (user=vipinsh job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:8705:b0:746:195b:bf1c
 with SMTP id d2e1a72fcca58-74839e1f2admr529438b3a.10.1749254213601; Fri, 06
 Jun 2025 16:56:53 -0700 (PDT)
Date: Fri,  6 Jun 2025 16:56:18 -0700
In-Reply-To: <20250606235619.1841595-1-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250606235619.1841595-1-vipinsh@google.com>
X-Mailer: git-send-email 2.50.0.rc0.604.gd4ff7b7c86-goog
Message-ID: <20250606235619.1841595-15-vipinsh@google.com>
Subject: [PATCH v2 14/15] KVM: selftests: Add s390 auto generated test files
 for KVM Selftests Runner
From: Vipin Sharma <vipinsh@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-arm-kernel@lists.infradead.org
Cc: seanjc@google.com, pbonzini@redhat.com, anup@brainfault.org, 
	borntraeger@linux.ibm.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com, 
	maz@kernel.org, oliver.upton@linux.dev, dmatlack@google.com, 
	Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"

Add auto generated test files for s390 platforms.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 tools/testing/selftests/kvm/tests/s390/cmma_test/default.test    | 1 +
 .../selftests/kvm/tests/s390/cpumodel_subfuncs_test/default.test | 1 +
 tools/testing/selftests/kvm/tests/s390/debug_test/default.test   | 1 +
 tools/testing/selftests/kvm/tests/s390/memop/default.test        | 1 +
 tools/testing/selftests/kvm/tests/s390/resets/default.test       | 1 +
 .../selftests/kvm/tests/s390/shared_zeropage_test/default.test   | 1 +
 .../testing/selftests/kvm/tests/s390/sync_regs_test/default.test | 1 +
 tools/testing/selftests/kvm/tests/s390/tprot/default.test        | 1 +
 .../testing/selftests/kvm/tests/s390/ucontrol_test/default.test  | 1 +
 9 files changed, 9 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/tests/s390/cmma_test/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/s390/cpumodel_subfuncs_test/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/s390/debug_test/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/s390/memop/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/s390/resets/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/s390/shared_zeropage_test/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/s390/sync_regs_test/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/s390/tprot/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/s390/ucontrol_test/default.test

diff --git a/tools/testing/selftests/kvm/tests/s390/cmma_test/default.test b/tools/testing/selftests/kvm/tests/s390/cmma_test/default.test
new file mode 100644
index 000000000000..c6655b3e9472
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/s390/cmma_test/default.test
@@ -0,0 +1 @@
+s390/cmma_test
diff --git a/tools/testing/selftests/kvm/tests/s390/cpumodel_subfuncs_test/default.test b/tools/testing/selftests/kvm/tests/s390/cpumodel_subfuncs_test/default.test
new file mode 100644
index 000000000000..d02545ae1f3b
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/s390/cpumodel_subfuncs_test/default.test
@@ -0,0 +1 @@
+s390/cpumodel_subfuncs_test
diff --git a/tools/testing/selftests/kvm/tests/s390/debug_test/default.test b/tools/testing/selftests/kvm/tests/s390/debug_test/default.test
new file mode 100644
index 000000000000..bd0a9c8965b2
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/s390/debug_test/default.test
@@ -0,0 +1 @@
+s390/debug_test
diff --git a/tools/testing/selftests/kvm/tests/s390/memop/default.test b/tools/testing/selftests/kvm/tests/s390/memop/default.test
new file mode 100644
index 000000000000..76073a59f58d
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/s390/memop/default.test
@@ -0,0 +1 @@
+s390/memop
diff --git a/tools/testing/selftests/kvm/tests/s390/resets/default.test b/tools/testing/selftests/kvm/tests/s390/resets/default.test
new file mode 100644
index 000000000000..133beeb1260b
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/s390/resets/default.test
@@ -0,0 +1 @@
+s390/resets
diff --git a/tools/testing/selftests/kvm/tests/s390/shared_zeropage_test/default.test b/tools/testing/selftests/kvm/tests/s390/shared_zeropage_test/default.test
new file mode 100644
index 000000000000..8ea3ec559fda
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/s390/shared_zeropage_test/default.test
@@ -0,0 +1 @@
+s390/shared_zeropage_test
diff --git a/tools/testing/selftests/kvm/tests/s390/sync_regs_test/default.test b/tools/testing/selftests/kvm/tests/s390/sync_regs_test/default.test
new file mode 100644
index 000000000000..7eacd6f9bd2d
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/s390/sync_regs_test/default.test
@@ -0,0 +1 @@
+s390/sync_regs_test
diff --git a/tools/testing/selftests/kvm/tests/s390/tprot/default.test b/tools/testing/selftests/kvm/tests/s390/tprot/default.test
new file mode 100644
index 000000000000..78e603c3b671
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/s390/tprot/default.test
@@ -0,0 +1 @@
+s390/tprot
diff --git a/tools/testing/selftests/kvm/tests/s390/ucontrol_test/default.test b/tools/testing/selftests/kvm/tests/s390/ucontrol_test/default.test
new file mode 100644
index 000000000000..211cceee1bbd
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/s390/ucontrol_test/default.test
@@ -0,0 +1 @@
+s390/ucontrol_test
-- 
2.50.0.rc0.604.gd4ff7b7c86-goog

