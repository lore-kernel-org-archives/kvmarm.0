Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5AE41DEFEB
	for <kvmarm@lists.linux.dev>; Mon,  6 Jan 2025 14:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736173537; cv=none; b=hRNRQiU7AjhAj6/syDUcTLUXwy4fs/x7mnk7vlVrZBIGRV5UycnpEZOOsxAPtqFXu610F953O9u+RfGk8yRaOQvuUgqi0QIKQegkLbKIDoKPBqMVhFinLS6rdpCSARapJZkxA4CaVf2YGKWn8v7GBI6BiFrwGOZwP+o+7b+nUZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736173537; c=relaxed/simple;
	bh=basFdqxsucbXYKlHn41Ysfk6IzsWrMLuIbJNEpIJJz4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TXZPDo6FfjPqIT9Gse7phKXP/nUyACYcznPzxK8/dpIrdq1enFGmM7DWJq4ejnims0o+STMuLetltQAvm2Lr+PEQwFSc0tekUQuQREiEIh6FlaiD5O+P/m/akOx6ZFZQ+hSM71MZ5x5T8rIwe/04oqfR1U3hpbyx5CSBA2rnklk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=sfuaiwkR; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="sfuaiwkR"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4361c705434so104360765e9.3
        for <kvmarm@lists.linux.dev>; Mon, 06 Jan 2025 06:25:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1736173534; x=1736778334; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RxHaRwE8K9zHhfXkFI0ar+C1f1f9RJaVIjhqGS2PIW0=;
        b=sfuaiwkRewtOfudaCIQebUBokBhv6YbhW9zM/iKxNPdEy5Nh5Jy2RSIToXeBaSo5CV
         1ghHdJc36jtTncaG7OWkGUtQdJz9/ZEEgly2LgjapkqXE3JDIcY3ipJFyagv4EE2hlW5
         OjXcFeUBZ69+XegEA8VnQWHthoLuyFijqPfNu3CKgDB6QXQSjpIQF5oPCFWAdvCwCdm6
         ZfYXEUre3R2SqIbhpwyA571TrUPG/+LmRdoTNln0sheFiL1M6VD1NCc6FnORy9F0vnag
         HCYliU2YUVuqBPlyr5BKJfnPBsW6bd1Z0felh8UZzjAK38sFSEpWf5Q8u9YXdMT5z+oF
         VKqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736173534; x=1736778334;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RxHaRwE8K9zHhfXkFI0ar+C1f1f9RJaVIjhqGS2PIW0=;
        b=D29SaIM+rDceHjfNTOPH2rzewE9zzI7eU77wtqKBNCWMzlzvLIrEKTOfvEHrHEoSt9
         7u3yQLEtegM869aMT/S6dZbr0gUREND9UgqY1Zsst1hojv4WZeFP49hxVXjHSOvOfaCG
         8lusA5jQwIJR13CWSnpTj7Zaioz3Sw1OlPnHqXgGZaSReS8SymksDIYPfNsWE7PpqoV3
         G1u1NUv9ZSbcmIrGE+sqpT9Vo5Cf5+WNohuf3k4F97Fi9mNYcFftkq6Oz8EwkNU09L7t
         WzMNmjg4GVYfLrrsKwPcsFd6T7E/CsIaWFSKXpOQdc1s1YSXWspzFLAXnFeb4OyJ9ll0
         YD9A==
X-Forwarded-Encrypted: i=1; AJvYcCXZBAB6TUmRJFNQUwq6xKy0Vw9obkDsUu8ZilONQqqq+RgGrttIr3xpwJ2u5MSdbbtJ7vDA8cU=@lists.linux.dev
X-Gm-Message-State: AOJu0YwKF5qWSPuFWKcgQlcXIUKEPIZK+FGduxbpgexD5PuLVIMJG9vq
	qCacjhwoQjMEEyYGsOVEuxH0OnP2eE6uQqvn3eWtNzUjTpROuAndGEGdl2eTdEg=
X-Gm-Gg: ASbGncvonIBa4mp3qEE50YLqHVy+wa5sJwhIcuWGsyED05TZytqBv2eLyrO19jIsUV4
	glC0DceYUqwS8EPMCV4x2D2EFYL+ZedTMzXezX9UFcMwz6LDu2V5sZGZqfHJVX/Ra/VsYo8a9SV
	Gl5SqTaLY4iauBOQSrwM4itDNarl7K1kLy8lOslWb3CFRh6353UI3sT7f1Ogt3xhQ4ugIXaBLq2
	mOOzUpn3nWMPBRnAnaPeCZe2MklOusZyeF4V35mHtn+4MZtee4MteLN
X-Google-Smtp-Source: AGHT+IEgYl+0/TPin7WWSmn3OhX4sdnJNx6WPFGc3EzpxEqMLoC40XXnqOZPGdvtsWkfJKcw8cZ2Pw==
X-Received: by 2002:a05:600c:46c7:b0:434:a4b3:5ebe with SMTP id 5b1f17b1804b1-43668b5e244mr445600755e9.24.1736173533153;
        Mon, 06 Jan 2025 06:25:33 -0800 (PST)
Received: from pop-os.. ([145.224.66.180])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4365d116d8fsm577295045e9.17.2025.01.06.06.25.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jan 2025 06:25:32 -0800 (PST)
From: James Clark <james.clark@linaro.org>
To: maz@kernel.org,
	kvmarm@lists.linux.dev,
	oliver.upton@linux.dev,
	suzuki.poulose@arm.com,
	coresight@lists.linaro.org
Cc: James Clark <james.clark@linaro.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mike Leach <mike.leach@linaro.org>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Shiqi Liu <shiqiliu@hust.edu.cn>,
	Mark Brown <broonie@kernel.org>,
	James Morse <james.morse@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Raghavendra Rao Ananta <rananta@google.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v9 6/7] KVM: arm64: Support trace filtering for guests
Date: Mon,  6 Jan 2025 14:24:41 +0000
Message-Id: <20250106142446.628923-7-james.clark@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250106142446.628923-1-james.clark@linaro.org>
References: <20250106142446.628923-1-james.clark@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For nVHE, switch the filter value in and out if the Coresight driver
asks for it. This will support filters for guests when sinks other than
TRBE are used.

For VHE, just write the filter directly to TRFCR_EL1 where trace can be
used even with TRBE sinks.

Signed-off-by: James Clark <james.clark@linaro.org>
---
 arch/arm64/include/asm/kvm_host.h |  2 ++
 arch/arm64/kvm/debug.c            | 18 ++++++++++++++++++
 2 files changed, 20 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 8fdc7b6efc79..7cfa024de4e3 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1396,6 +1396,7 @@ void kvm_clr_pmu_events(u64 clr);
 bool kvm_set_pmuserenr(u64 val);
 void kvm_enable_trbe(void);
 void kvm_disable_trbe(void);
+void kvm_tracing_set_el1_configuration(u64 trfcr_while_in_guest);
 #else
 static inline void kvm_set_pmu_events(u64 set, struct perf_event_attr *attr) {}
 static inline void kvm_clr_pmu_events(u64 clr) {}
@@ -1405,6 +1406,7 @@ static inline bool kvm_set_pmuserenr(u64 val)
 }
 static inline void kvm_enable_trbe(void) {}
 static inline void kvm_disable_trbe(void) {}
+static inline void kvm_tracing_set_el1_configuration(u64 trfcr_while_in_guest) {}
 #endif
 
 void kvm_vcpu_load_vhe(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
index 92a24adadb0e..0e4c805e7e89 100644
--- a/arch/arm64/kvm/debug.c
+++ b/arch/arm64/kvm/debug.c
@@ -245,3 +245,21 @@ void kvm_disable_trbe(void)
 	host_data_clear_flag(TRBE_ENABLED);
 }
 EXPORT_SYMBOL_GPL(kvm_disable_trbe);
+
+void kvm_tracing_set_el1_configuration(u64 trfcr_while_in_guest)
+{
+	if (is_protected_kvm_enabled() || WARN_ON_ONCE(preemptible()))
+		return;
+
+	if (has_vhe()) {
+		write_sysreg_s(trfcr_while_in_guest, SYS_TRFCR_EL12);
+		return;
+	}
+
+	*host_data_ptr(trfcr_while_in_guest) = trfcr_while_in_guest;
+	if (read_sysreg_s(SYS_TRFCR_EL1) != trfcr_while_in_guest)
+		host_data_set_flag(EL1_TRACING_CONFIGURED);
+	else
+		host_data_clear_flag(EL1_TRACING_CONFIGURED);
+}
+EXPORT_SYMBOL_GPL(kvm_tracing_set_el1_configuration);
-- 
2.34.1

