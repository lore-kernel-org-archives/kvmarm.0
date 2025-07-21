Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1F2F2DAFA4
	for <kvmarm@lists.linux.dev>; Mon, 21 Jul 2025 13:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753103122; cv=none; b=h7qzZF4kMMTlPtAD+PnGVVJoKJwS09E96A3SWDnfZCZIhDNycmLAQUgJI85FhQxB33bNpSgX2MgegLX0r/xr6RekCSKjw+Wafn+OuAeqOTZFG+AdW5aGHTZCbQS9MF6gqgt/02rGh8eBgQPwNSbcbjF6vYfvxh5u8QFhlcG9gq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753103122; c=relaxed/simple;
	bh=+SpNfvIdNfTZltOmSX39gMGmWG5o7oWGDEW8UKH3C24=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Ll7AUhQllVWYgny50EZ7UVE+jKF6l365FC7mgYjwr0nwj4LNEvhecQE56D1VGIZ3qSkR4Ov7ibucPgqq0MMdRS3+qLZxxLLvPXTEm35vC+0C6OYmLCGaIhAs3kqPlSQFWkgTPy0rbSpC0wmfytELV32xw6aLXbNh2sfcCFxcIiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=y24alUyv; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="y24alUyv"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-451d3f72391so43799185e9.3
        for <kvmarm@lists.linux.dev>; Mon, 21 Jul 2025 06:05:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1753103119; x=1753707919; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aZ3PtlOR0m4xvI+xrlOA19tnjKSe6qe5HMQ0ewIzj6Q=;
        b=y24alUyvNXHhe+qoiJNY9tvNCH7OasABX7XX4v9z8U85uFKPjEGuZK5IKoxn0iR7wW
         f3HXnvHHh39ux3+q+uuY3NUqA/Izj8tkETA3rZULSlu1l4IHYsWdfB8kB9XhVBq1QlK7
         tOmjXf7BhZQl8RSQ7ls/le5dU7jMjbC/r1LsSB2Zl1IfHZM9v1LKXjWVBaU4tk5HP++a
         MQ6LDhzNjN4V8/za4KV4wDNn5nLkx17OrUAfe9+fcJLcTICjFvMb58oXRFk3Ed5O7P8k
         Ip/m3jB8KbSDUbfI6IWqsQjkxm4slH3LRmgoibBgtZMwfabOpcD4z7cGPaMNPyQTg+7D
         YkFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753103119; x=1753707919;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aZ3PtlOR0m4xvI+xrlOA19tnjKSe6qe5HMQ0ewIzj6Q=;
        b=aSB6+RpCEY/I771HSoWaM8ecADeDEHi0fCS6ECh47/KUfQcsoCR8+bhTXI7iM4N5LV
         6ndOUVO/VAveocwD1fC0bZrNeLYh7iUX6nVBWZt1uAfJA27nkBila3s5kLkAU7lybAxD
         F93H2nWME2kn/NnP5G8PVOgoQOvOYUBFjBjAXPSpqrDVxyjCoEbTfnTlK43EKP+RI7Pw
         J3QdI3A2VMVu5zlCWd0dokdQTRh4KeHni4OJZ0HdYbS+SwJNol1X4O33zoeJ/EC+hikY
         6qJZnYhjjdVfyTPNkzT1hQrNE/Rpo9VmPAqQ5cGQaYUE2LIq6PIaXnvdid1ffqn7s/bI
         Hbpw==
X-Forwarded-Encrypted: i=1; AJvYcCUijCUTsxHIKMZZJyBDWoh8HavG9l/dKw0B7fZQVQjjNWh9d8ak4LXLhku93ZaV082akdTvRf8=@lists.linux.dev
X-Gm-Message-State: AOJu0YwUMP8nBbN3uF9MOaJfOuRnedI0ZDw8GVjyZlRv8z5+cZDQuwhE
	+i7+izk7880Maw3P+mBDBCgsHHG0GitfpbchulXf/A73Xc2v6JQ0OtdSrPcTHUCyocs=
X-Gm-Gg: ASbGnctukhAex54MT/lxUDCaEaC3KvEkhqKeo0rC7RFJcJGXRW+MqaMESGoP+EW5FMW
	chC/iBqdfbzlwyALn8TzR0XMhJrYRH6+4/j+5v+m1E0t0uMGXCNw55jnknGlTdAjFXUanz/u48V
	7yFKFVKDgpOBJlvukVbriJO7l0OL7sgqSkE7fHyvnt7Zt84oZRVYQZuLYt31H+jkqiunHPIRh7w
	HwPzOdMhico3scA6HCfQwxw5GvibqZWRzCrSFIS1P3XhlKK1No40j2bZeD6sDLiOWNX6DIlu1oq
	x1tTdXgs50TsnFv28y4hfHEvEbiOiCYneAA7v/0xy4gpP3vLxaqAWvdDVKTVwn0RitPVOGimRKQ
	cwMfJDoZ+bmZ6fQNc7EXs2+R2RF9FWtM=
X-Google-Smtp-Source: AGHT+IH9bw7cU8ns9QQ3mV/+eJ2qDxTwHmxGZEX7vgJMgWIg3L3lpoWH95LxFXy5NofnFtzmG3M36A==
X-Received: by 2002:a05:600c:3589:b0:456:1d34:97a with SMTP id 5b1f17b1804b1-456357faf96mr152094745e9.9.1753103118896;
        Mon, 21 Jul 2025 06:05:18 -0700 (PDT)
Received: from ho-tower-lan.lan ([185.48.76.109])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b61ca5c632sm10485077f8f.80.2025.07.21.06.05.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jul 2025 06:05:18 -0700 (PDT)
From: James Clark <james.clark@linaro.org>
Date: Mon, 21 Jul 2025 14:05:01 +0100
Subject: [PATCH v5 07/12] KVM: arm64: Add trap configs for PMSDSFR_EL1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250721-james-perf-feat_spe_eft-v5-7-a7bc533485a1@linaro.org>
References: <20250721-james-perf-feat_spe_eft-v5-0-a7bc533485a1@linaro.org>
In-Reply-To: <20250721-james-perf-feat_spe_eft-v5-0-a7bc533485a1@linaro.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
 Oliver Upton <oliver.upton@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, Peter Zijlstra <peterz@infradead.org>, 
 Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, 
 Namhyung Kim <namhyung@kernel.org>, 
 Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, 
 Adrian Hunter <adrian.hunter@intel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-perf-users@vger.kernel.org, linux-doc@vger.kernel.org, 
 kvmarm@lists.linux.dev, James Clark <james.clark@linaro.org>
X-Mailer: b4 0.14.0

SPE data source filtering (SPE_FEAT_FDS) adds a new register
PMSDSFR_EL1, add the trap configs for it. PMSNEVFR_EL1 was also missing
its VNCR offset so add it along with PMSDSFR_EL1.

Signed-off-by: James Clark <james.clark@linaro.org>
---
 arch/arm64/include/asm/vncr_mapping.h | 2 ++
 arch/arm64/kvm/emulate-nested.c       | 1 +
 arch/arm64/kvm/sys_regs.c             | 1 +
 3 files changed, 4 insertions(+)

diff --git a/arch/arm64/include/asm/vncr_mapping.h b/arch/arm64/include/asm/vncr_mapping.h
index 6f556e993644..dba0e58a5fac 100644
--- a/arch/arm64/include/asm/vncr_mapping.h
+++ b/arch/arm64/include/asm/vncr_mapping.h
@@ -92,6 +92,8 @@
 #define VNCR_PMSICR_EL1         0x838
 #define VNCR_PMSIRR_EL1         0x840
 #define VNCR_PMSLATFR_EL1       0x848
+#define VNCR_PMSNEVFR_EL1       0x850
+#define VNCR_PMSDSFR_EL1        0x858
 #define VNCR_TRFCR_EL1          0x880
 #define VNCR_MPAM1_EL1          0x900
 #define VNCR_MPAMHCR_EL2        0x930
diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index 3a384e9660b8..60bd8b7f0e5b 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -1174,6 +1174,7 @@ static const struct encoding_to_trap_config encoding_to_cgt[] __initconst = {
 	SR_TRAP(SYS_PMSIRR_EL1,		CGT_MDCR_TPMS),
 	SR_TRAP(SYS_PMSLATFR_EL1,	CGT_MDCR_TPMS),
 	SR_TRAP(SYS_PMSNEVFR_EL1,	CGT_MDCR_TPMS),
+	SR_TRAP(SYS_PMSDSFR_EL1,	CGT_MDCR_TPMS),
 	SR_TRAP(SYS_TRFCR_EL1,		CGT_MDCR_TTRF),
 	SR_TRAP(SYS_TRBBASER_EL1,	CGT_MDCR_E2TB),
 	SR_TRAP(SYS_TRBLIMITR_EL1,	CGT_MDCR_E2TB),
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index c20bd6f21e60..82bddd631b47 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -3010,6 +3010,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_PMBLIMITR_EL1), undef_access },
 	{ SYS_DESC(SYS_PMBPTR_EL1), undef_access },
 	{ SYS_DESC(SYS_PMBSR_EL1), undef_access },
+	{ SYS_DESC(SYS_PMSDSFR_EL1), undef_access },
 	/* PMBIDR_EL1 is not trapped */
 
 	{ PMU_SYS_REG(PMINTENSET_EL1),

-- 
2.34.1

