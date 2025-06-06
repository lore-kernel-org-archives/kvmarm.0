Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9FB323F42A
	for <kvmarm@lists.linux.dev>; Fri,  6 Jun 2025 23:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749254217; cv=none; b=pjqwFTql/ERSELpIgb+NeNxyHNbhmwkfoTsjlXUbY9S5JzB6q/LF6fkbztgdTmvCmS4jJFraxnPmy9Ior0+bqgvkBx1coNK+iqiSVnx+z/H2F0RqV29PYRIcxjlObqMy/iAY93w56Xg+fFRNqlRLm4ag6Q19938C9Wf7rGeBhZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749254217; c=relaxed/simple;
	bh=FfZjBFrJnHL5qXqPJ52iFYwiecqXQgGEH17UAzM8jjw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=O1EVwJRrTMccdmlF/GKJ4Ctas+pP2LbnfwvxRLVBEYPzPVrjJlhR2LpS2KdQJbxZQ9g/AGu3AlddT4lpN7X8u3jIdGVy/2pWbCZw0re3fR0dvoKp5bAzJWyuI8qmwc8x++wQdg8dT1B6NRd/M/Kfz/rQhdofbXtj/D50G7ehja4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1JdaNYtm; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1JdaNYtm"
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-747d143117eso2090037b3a.3
        for <kvmarm@lists.linux.dev>; Fri, 06 Jun 2025 16:56:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749254215; x=1749859015; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rQsDpgf8u91vw/WrLSGz0iJXQ6JiA2bq0U/tEH5QJI8=;
        b=1JdaNYtm5KUSK2WI3rLFpELKrGcsiI4A/ZCD7JE3iEm80Ql3kIjEatqcFVvlRXtzVW
         CThA+k3AxyES6HNBcDRSYjeGCnJ9Zl7SAE36/w+6g071uHo/GF57G8vKKLDc2CGDYrfA
         9NcbV/dFocUAv72Bq2TNLCNNCxSgySUzYZ0eY2JDxsgefjjz2U9tQDC27QVHnlmLLk6k
         XuPuUpqmJaCUgpseY5julRQGtmYqyNxowQgdpHmuiE/jPTWgcQjRe7HFk+3vJdXsNURA
         SyyAM7brWAjCR6g+93iIESUbrpL9YMlzH4TOnhizoIOpjNhbJglAjwxtn2F/bjfxd0R2
         A8gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749254215; x=1749859015;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rQsDpgf8u91vw/WrLSGz0iJXQ6JiA2bq0U/tEH5QJI8=;
        b=U3eU5HgYiPj3TzeIlCyY16Icxd99MJ3fVyCyEU74hl+xpLxHkyZvcVabzvuTn4oOAt
         g2H1BklCSsct8MVPw7xYWHR5p93NMGKYrATxCllqR7yZ2SQPEufegvA0JePWJwQnkFKV
         9v6qbEwm/2jiV47yyN/KPVNwxVErXOhJsYCZwhjJHBh/E3kr3Er24Vlcj+AFDvVZdsfo
         1YR88fuBIaXneDQMLW4V73voEme3PsJopECdbiv/ckOTVoC/aCg8L/Cgd1IRRpjxcer6
         GVCH3dCfOBAUrpjJNcN3yyIe5MGQZcrdZ0jeCalAM6ENKfWDZqUItIHkLHLWrT3usbr0
         DwDg==
X-Forwarded-Encrypted: i=1; AJvYcCX4QQqRMRgb9uENgp4IMdq5mlfesK/Y7VyKfE/wmBHsMBIqSKOi82n4+knLIzIxyc1OHk7F92M=@lists.linux.dev
X-Gm-Message-State: AOJu0YwIme2lfLb/tk7YTXDz3v05Ag2yeiksimq5ihYS7/WRPe41UB2O
	gAesllABDft/Xc5Mcs6IEZKW2I9UHm+CejfVJyLXuhzX2CpMXOEDvw4dQAdO+mDdGJ+px8MyteT
	9T+smZ6FrzQ==
X-Google-Smtp-Source: AGHT+IGyp1ZByaQWclr+E1KDubTeknVJBEMfz1Flqb1492oOI1nXyfJVxjejhM42yZAw1MjGchfJyqOnrrck
X-Received: from pfiu22.prod.google.com ([2002:a05:6a00:1256:b0:747:b608:3d8e])
 (user=vipinsh job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:6009:b0:218:c22:e3e6
 with SMTP id adf61e73a8af0-21ee2555021mr6804011637.12.1749254215203; Fri, 06
 Jun 2025 16:56:55 -0700 (PDT)
Date: Fri,  6 Jun 2025 16:56:19 -0700
In-Reply-To: <20250606235619.1841595-1-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250606235619.1841595-1-vipinsh@google.com>
X-Mailer: git-send-email 2.50.0.rc0.604.gd4ff7b7c86-goog
Message-ID: <20250606235619.1841595-16-vipinsh@google.com>
Subject: [PATCH v2 15/15] KVM: selftests: Add riscv auto generated test files
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
 tools/testing/selftests/kvm/tests/riscv/ebreak_test/default.test | 1 +
 .../testing/selftests/kvm/tests/riscv/sbi_pmu_test/default.test  | 1 +
 2 files changed, 2 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/tests/riscv/ebreak_test/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/riscv/sbi_pmu_test/default.test

diff --git a/tools/testing/selftests/kvm/tests/riscv/ebreak_test/default.test b/tools/testing/selftests/kvm/tests/riscv/ebreak_test/default.test
new file mode 100644
index 000000000000..d34b4b9b77ae
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/riscv/ebreak_test/default.test
@@ -0,0 +1 @@
+riscv/ebreak_test
diff --git a/tools/testing/selftests/kvm/tests/riscv/sbi_pmu_test/default.test b/tools/testing/selftests/kvm/tests/riscv/sbi_pmu_test/default.test
new file mode 100644
index 000000000000..5abb62c51097
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/riscv/sbi_pmu_test/default.test
@@ -0,0 +1 @@
+riscv/sbi_pmu_test
-- 
2.50.0.rc0.604.gd4ff7b7c86-goog

