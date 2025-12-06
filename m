Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84A292D97B9
	for <kvmarm@lists.linux.dev>; Sat,  6 Dec 2025 00:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764980299; cv=none; b=LjakcrWPobjS+UjvQu8AoeUNgGhpl0fiQoBrknY8Wo6oUcVKHwEa6034a+alBM1gah0/Kle3ZbvRyrRXZowXCgSQ64eqE5aXOw7GNKZq5nLof0gf2/Wzqd67ExfR+C6arXjTYi/6IfTCh9NnDzpY0Vz8G16zrk19jUA9cu6+ySI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764980299; c=relaxed/simple;
	bh=jX+tE0pJsaHvJh6IrTkcgDEB5TFVK0tRq1c1m4xYkUI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XjO72PZ7I89Gwrb0Oqp+h9K5BiG9yNgJy1usJLfDNucs9Zz8MwNKhnpKmUnTdvKM2MssoiIAB+VESkmWRHIQ5+6p7/W9Bk7BpIKOx/1s2j8Wsa0PFqwwigKq31VlF801CoZyZqnBRpA8qf84kbWiGaNcSgdUladETWKAoxB90FA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nkMK6Kf2; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nkMK6Kf2"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34188ba5990so6123628a91.0
        for <kvmarm@lists.linux.dev>; Fri, 05 Dec 2025 16:18:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764980297; x=1765585097; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=1e8bcRXtuFwsQIbYtccrwhgHSv5SpQkyZPUQMVVAuRI=;
        b=nkMK6Kf2NRWsJK7jKCtnv1Y42GZpSa+rYhU6gjMFbPsSPwh7pVvuK8wIoqPsUJJy+C
         Ih0xb/M7nhPiMXcr/4L5vFvb0e3gKrnljdq1zWGJKvykhxlCjd3vDZxn3NNaJTCs8xgC
         FhcQfCUj0AmkgoWFdOhO3HGWNojwfxTnRS6CynGsxBC0aHPcu1qnaaxO3MBMKNEuW2SX
         PaBPkNKGHclFKjPm3/EGHZENl1u1/9rS4Wx+GM/a7Qh12jzxmlgILnTMgGenIPWrra/n
         YsPYBGwsXhIkSn6czxTsnknRfy+/8I7rngpQC+Mo50k0WG12LNJvGJ/b392PXRoEOil3
         0K/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764980297; x=1765585097;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1e8bcRXtuFwsQIbYtccrwhgHSv5SpQkyZPUQMVVAuRI=;
        b=gWv9EfwTXohQp0imed1USwyLOyfTvx+npTqYyYriEIpU5zueoj93Ok/t+T8vAlevFu
         5MF6+VpSC0f5fGQ2epH/2UPwTR14ZoYanPnJfBV6Q89X3Fvksm6/WZy7OAL9rYC4mlU6
         wUMTKtPh4L+VGXkMAJRxoJou9XKXfcCmTjXggDo/ePfXh3bQQUwD1s56askhfbTgLZRQ
         YRote3S1oqior1EyT1216Rs1SdWiHhYnR3UmGMxGFWDdNPL3tAF7VIyzpznJY6klJouN
         u6r5HsagcX4B3cYkNYTZQPMWgJDXvxZKqCBqUUAxZSjMDNvrgUdqHsMNVg0bEVJyJyvV
         0HUQ==
X-Forwarded-Encrypted: i=1; AJvYcCX1YDpUXXEVorHenjRP8v4QNpXJUgaV/QbrOKhr8m9Dp4cKriduFFBBuaHpk+D3J0iltIDzYxA=@lists.linux.dev
X-Gm-Message-State: AOJu0YycmqzLBCQy52G0WKhjQy7M41dkzmYmQcdeXdqi6R0T2nn/SDMm
	Bo7QaNZDqMZSqvoPLbYQ/DbWHsko96jrY6fz41Z/hJl1jQZ+7jTbD0Wrw2QV+YJydxLUFhHmx2F
	MLlIviw==
X-Google-Smtp-Source: AGHT+IFA+TmENZM8zZH3xQmTmkf0AAav0uZn++oR8JtE8dy0fhXg220AvOxyf1+YRyhWVdU9HyzyXzK52Ag=
X-Received: from pjwo11.prod.google.com ([2002:a17:90a:d24b:b0:33b:51fe:1a89])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5750:b0:330:84c8:92d0
 with SMTP id 98e67ed59e1d1-349a261424emr607582a91.24.1764980296958; Fri, 05
 Dec 2025 16:18:16 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  5 Dec 2025 16:17:01 -0800
In-Reply-To: <20251206001720.468579-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251206001720.468579-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <20251206001720.468579-26-seanjc@google.com>
Subject: [PATCH v6 25/44] KVM: x86/pmu: Reprogram mediated PMU event selectors
 on event filter updates
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Xin Li <xin@zytor.com>, "H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, Mingwei Zhang <mizhang@google.com>, 
	Xudong Hao <xudong.hao@intel.com>, Sandipan Das <sandipan.das@amd.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>, Xiong Zhang <xiong.y.zhang@linux.intel.com>, 
	Manali Shukla <manali.shukla@amd.com>, Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Dapeng Mi <dapeng1.mi@linux.intel.com>

Refresh the event selectors that are programmed into hardware when a PMC
is "reprogrammed" for a mediated PMU, i.e. if userspace changes the PMU
event filters

Note, KVM doesn't utilize the reprogramming infrastructure to handle
counter overflow for mediated PMUs, as there's no need to reprogram a
non-existent perf event.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Co-developed-by: Mingwei Zhang <mizhang@google.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
[sean: add a helper to document behavior, split patch and rewrite changelog]
Tested-by: Xudong Hao <xudong.hao@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/pmu.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 36eebc1c7e70..39904e6fd227 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -522,6 +522,25 @@ static bool pmc_is_event_allowed(struct kvm_pmc *pmc)
 	return is_fixed_event_allowed(filter, pmc->idx);
 }
 
+static void kvm_mediated_pmu_refresh_event_filter(struct kvm_pmc *pmc)
+{
+	bool allowed = pmc_is_event_allowed(pmc);
+	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
+
+	if (pmc_is_gp(pmc)) {
+		pmc->eventsel_hw &= ~ARCH_PERFMON_EVENTSEL_ENABLE;
+		if (allowed)
+			pmc->eventsel_hw |= pmc->eventsel &
+					    ARCH_PERFMON_EVENTSEL_ENABLE;
+	} else {
+		u64 mask = intel_fixed_bits_by_idx(pmc->idx - KVM_FIXED_PMC_BASE_IDX, 0xf);
+
+		pmu->fixed_ctr_ctrl_hw &= ~mask;
+		if (allowed)
+			pmu->fixed_ctr_ctrl_hw |= pmu->fixed_ctr_ctrl & mask;
+	}
+}
+
 static int reprogram_counter(struct kvm_pmc *pmc)
 {
 	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
@@ -530,6 +549,11 @@ static int reprogram_counter(struct kvm_pmc *pmc)
 	bool emulate_overflow;
 	u8 fixed_ctr_ctrl;
 
+	if (kvm_vcpu_has_mediated_pmu(pmu_to_vcpu(pmu))) {
+		kvm_mediated_pmu_refresh_event_filter(pmc);
+		return 0;
+	}
+
 	emulate_overflow = pmc_pause_counter(pmc);
 
 	if (!pmc_is_globally_enabled(pmc) || !pmc_is_locally_enabled(pmc) ||
-- 
2.52.0.223.gf5cc29aaa4-goog

