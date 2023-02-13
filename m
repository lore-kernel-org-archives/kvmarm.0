Received: from mail-il1-f201.google.com (mail-il1-f201.google.com [209.85.166.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD31EA945
	for <kvmarm@lists.linux.dev>; Mon, 13 Feb 2023 18:02:44 +0000 (UTC)
Received: by mail-il1-f201.google.com with SMTP id k8-20020a056e02156800b003152ca1c48aso4522350ilu.21
        for <kvmarm@lists.linux.dev>; Mon, 13 Feb 2023 10:02:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=m5yslkEpatxEcn+ZjK5j+e94Zo++KRDXawZarevQP94=;
        b=lcEuCEa97ssf+wWD9q1X2jC8NG6WwfI+HwutzvJgCa6Uq+ZlQvO6nZ4fTZ1DOuWvCH
         QYfQMES86DFpGnJNaCKSYUITRt/fnbFRlV24rRk/9s+HJOK4uK3HUoXbUfKpYuWWbdGM
         JAkmmiPtglLKasxoEqGau0AV+ap1NMUKKv6f9Q0J6+GYYOqy5tXTw0cA3vI0PsY+8Ti9
         6DRHzCp9lRTmscj+OMpjzyRj19bIqkMSdns7IbL4DdWskvbfqjdhHYeYx/pEtPAC/xpy
         7SX2rfvXEDyQVkwgmKnDgLQKOy/Rc39ynIF8Wwbekx9vLgo9IWDVOMuK3NLGvfW1CAvj
         N/RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=m5yslkEpatxEcn+ZjK5j+e94Zo++KRDXawZarevQP94=;
        b=KSnagLjx1SBv+G8yaZsUugm573VOgzfkdoUWeaKars01Bp+eTSWug1QvhLUr4//w3X
         vhVu590QeNo5YtUgZOoO1fWEhEKfI3by+u4E8sAHTbGMRMVnNV5UA1prVAOVcB7UMTfe
         Q+avJ2M0Qqcjs+Zoj6cli2q0pctFUY/dbmPXocTkT3yPL0PS8PAh0krZz4br/lFdGS38
         yXRF05k4LuCACObEHqwTOiZg3xuiQKOaf3Adw9TcpiYjaejNAkM7IkR98vPyO/TBbPJ4
         PeJ6oTT/ljHg+qDMU2NF/u6tqLf2KketKa1jl0NttWwoJcNNf7cecPsN49otI2rUjpIS
         lcww==
X-Gm-Message-State: AO0yUKXVD3hXQCK5u2cRlNV0FV9qYo/oStPKBgr/L/D9TNRixyk8wRPj
	ZChMIb6AggQcxM4nl8CAOb3z9gyfZnhi
X-Google-Smtp-Source: AK7set/0edXrdMAO+nSquBaytN7bLQuBx2MZ7S0viOK1DwWUM7ZNzi/YO3vgRtPP1oEgxZM2YSawlRvX5KHR
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a02:854b:0:b0:3a7:e46f:1016 with SMTP id
 g69-20020a02854b000000b003a7e46f1016mr298jai.0.1676311363803; Mon, 13 Feb
 2023 10:02:43 -0800 (PST)
Date: Mon, 13 Feb 2023 18:02:25 +0000
In-Reply-To: <20230213180234.2885032-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230213180234.2885032-1-rananta@google.com>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Message-ID: <20230213180234.2885032-5-rananta@google.com>
Subject: [PATCH 04/13] selftests: KVM: aarch64: Add PMU cycle counter helpers
From: Raghavendra Rao Ananta <rananta@google.com>
To: Oliver Upton <oupton@google.com>, Reiji Watanabe <reijiw@google.com>, Marc Zyngier <maz@kernel.org>, 
	Ricardo Koller <ricarkol@google.com>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jing Zhang <jingzhangos@google.com>, 
	Colton Lewis <coltonlewis@google.com>, Raghavendra Rao Anata <rananta@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Add basic helpers for the test to access the cycle counter
registers. The helpers will be used in the upcoming patches
to run the tests related to cycle counter.

No functional change intended.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 .../testing/selftests/kvm/aarch64/vpmu_test.c | 40 +++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/tools/testing/selftests/kvm/aarch64/vpmu_test.c b/tools/testing/selftests/kvm/aarch64/vpmu_test.c
index d72c3c9b9c39f..15aebc7d7dc94 100644
--- a/tools/testing/selftests/kvm/aarch64/vpmu_test.c
+++ b/tools/testing/selftests/kvm/aarch64/vpmu_test.c
@@ -147,6 +147,46 @@ static inline void disable_counter(int idx)
 	isb();
 }
 
+static inline uint64_t read_cycle_counter(void)
+{
+	return read_sysreg(pmccntr_el0);
+}
+
+static inline void reset_cycle_counter(void)
+{
+	uint64_t v = read_sysreg(pmcr_el0);
+
+	write_sysreg(ARMV8_PMU_PMCR_C | v, pmcr_el0);
+	isb();
+}
+
+static inline void enable_cycle_counter(void)
+{
+	uint64_t v = read_sysreg(pmcntenset_el0);
+
+	write_sysreg(ARMV8_PMU_CNTENSET_C | v, pmcntenset_el0);
+	isb();
+}
+
+static inline void disable_cycle_counter(void)
+{
+	uint64_t v = read_sysreg(pmcntenset_el0);
+
+	write_sysreg(ARMV8_PMU_CNTENSET_C | v, pmcntenclr_el0);
+	isb();
+}
+
+static inline void write_pmccfiltr(unsigned long val)
+{
+	write_sysreg(val, pmccfiltr_el0);
+	isb();
+}
+
+static inline uint64_t read_pmccfiltr(void)
+{
+	return read_sysreg(pmccfiltr_el0);
+}
+
 static inline uint64_t get_pmcr_n(void)
 {
 	return FIELD_GET(ARMV8_PMU_PMCR_N, read_sysreg(pmcr_el0));
-- 
2.39.1.581.gbfd45094c4-goog

