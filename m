Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58BC02F32
	for <kvmarm@lists.linux.dev>; Wed,  1 Feb 2023 12:59:27 +0000 (UTC)
Received: by mail-wr1-f41.google.com with SMTP id bk16so17209889wrb.11
        for <kvmarm@lists.linux.dev>; Wed, 01 Feb 2023 04:59:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mpqAxnbuSEle+b4ZozqvuRbtg84sOU2wLsHHXy60Xf4=;
        b=H8N6t8azgmWBH886NvtNIa/88xftg/d47CN1lNWpwQY8g41X2dJULDBUt8RWJTJeSI
         WThReSjvqRrR6PVFUKbeH+UFULZSwESdu2a/Lm9dDMa5lpETn4ZZ/+Opu68LiZmqq9sN
         7P/93+ZxvEA2KO5Usrr4b/D33b6zAhssqHN/jocvhOTGBVp9C2dmRhMkotIsbkaCIu35
         VlkRPDQbg9E1wdVnf/L6ySFyOuxkCqSpAFTCvU8t7w+YTqswvLQFx7+ljAE9t0xAPWKe
         1n4xTnAPGdVNWDKH/odBfQ6RBeJ1YG99BQDMs9ceNFwJeIzOmly9KiYRBCORoZE+neG/
         rcxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mpqAxnbuSEle+b4ZozqvuRbtg84sOU2wLsHHXy60Xf4=;
        b=Jkee/DLiVhcntH4Xx+bsgFj21yAn0wcLEhHhfp+zpln4LFSjVT9syxnAOhojSbYtSC
         C+6vXXS2b0fKOhCfbPKmVe2AvS1Yk3jK+8ObWL7T+QSEn0zJNTJT9uPsdHqqv/ef62lw
         DgL7poUDWksEmEsk9P8EIg6kQxqFyEC58HzuwRmxFkmETIpR2zV/tq+BmQ+HEZGq4O94
         su+bDR1MxFtVvbzraVVlmnZ+UMKi6A4YZNu06n6Hw7+XJBbMdF7wSPDIaTjs/URBQCfq
         ASt+EwFX/66Ay8iDpWH8KjOrNIiRZUzWkSP7PLEjJ7+vRG2ru3TA2jHAjOW0SFcpcPgB
         yYig==
X-Gm-Message-State: AO0yUKVbxPXAm5biBhWFXupfPwm/CJPMdsWe+Y7IKKdXc5tLwIFhD7k7
	SaJjpVVZNApY9cmby9rGJokykA==
X-Google-Smtp-Source: AK7set8PyrVNoe2MKjwL7WkMsO801xwUwupVDKmMI+GE07B0RcxtODTmVsZbmKSEFKICiI5L55zPfQ==
X-Received: by 2002:adf:e181:0:b0:2bd:c4ea:3b59 with SMTP id az1-20020adfe181000000b002bdc4ea3b59mr2690988wrb.0.1675256365691;
        Wed, 01 Feb 2023 04:59:25 -0800 (PST)
Received: from localhost.localdomain (054592b0.skybroadband.com. [5.69.146.176])
        by smtp.gmail.com with ESMTPSA id m15-20020a056000024f00b002bfae16ee2fsm17972811wrz.111.2023.02.01.04.59.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Feb 2023 04:59:25 -0800 (PST)
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: maz@kernel.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	joro@8bytes.org
Cc: robin.murphy@arm.com,
	james.morse@arm.com,
	suzuki.poulose@arm.com,
	oliver.upton@linux.dev,
	yuzenghui@huawei.com,
	smostafa@google.com,
	dbrazdil@google.com,
	ryan.roberts@arm.com,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	iommu@lists.linux.dev,
	Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [RFC PATCH 08/45] KVM: arm64: pkvm: Add pkvm_udelay()
Date: Wed,  1 Feb 2023 12:52:52 +0000
Message-Id: <20230201125328.2186498-9-jean-philippe@linaro.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230201125328.2186498-1-jean-philippe@linaro.org>
References: <20230201125328.2186498-1-jean-philippe@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a simple delay loop for drivers.

This could use more work. It should be possible to insert a wfe and save
power, but I haven't studied whether it is safe to do so with the host
in control of the event stream. The SMMU driver will use wfe anyway for
frequent waits (provided the implementation can send command queue
events).

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h |  3 ++
 arch/arm64/kvm/hyp/nvhe/setup.c        |  4 +++
 arch/arm64/kvm/hyp/nvhe/timer-sr.c     | 43 ++++++++++++++++++++++++++
 3 files changed, 50 insertions(+)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
index 6160d1a34fa2..746dc1c05a8e 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
@@ -109,4 +109,7 @@ bool kvm_handle_pvm_hvc64(struct kvm_vcpu *vcpu, u64 *exit_code);
 
 struct pkvm_hyp_vcpu *pkvm_mpidr_to_hyp_vcpu(struct pkvm_hyp_vm *vm, u64 mpidr);
 
+int pkvm_timer_init(void);
+void pkvm_udelay(unsigned long usecs);
+
 #endif /* __ARM64_KVM_NVHE_PKVM_H__ */
diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index 8a357637ce81..629e74c46b35 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -300,6 +300,10 @@ void __noreturn __pkvm_init_finalise(void)
 	};
 	pkvm_pgtable.mm_ops = &pkvm_pgtable_mm_ops;
 
+	ret = pkvm_timer_init();
+	if (ret)
+		goto out;
+
 	ret = fix_host_ownership();
 	if (ret)
 		goto out;
diff --git a/arch/arm64/kvm/hyp/nvhe/timer-sr.c b/arch/arm64/kvm/hyp/nvhe/timer-sr.c
index 9072e71693ba..202df9003a0d 100644
--- a/arch/arm64/kvm/hyp/nvhe/timer-sr.c
+++ b/arch/arm64/kvm/hyp/nvhe/timer-sr.c
@@ -10,6 +10,10 @@
 
 #include <asm/kvm_hyp.h>
 
+#include <nvhe/pkvm.h>
+
+static u32 timer_freq;
+
 void __kvm_timer_set_cntvoff(u64 cntvoff)
 {
 	write_sysreg(cntvoff, cntvoff_el2);
@@ -46,3 +50,42 @@ void __timer_enable_traps(struct kvm_vcpu *vcpu)
 	val |= CNTHCTL_EL1PCTEN;
 	write_sysreg(val, cnthctl_el2);
 }
+
+static u64 pkvm_ticks_get(void)
+{
+	return __arch_counter_get_cntvct();
+}
+
+#define SEC_TO_US 1000000
+
+int pkvm_timer_init(void)
+{
+	timer_freq = read_sysreg(cntfrq_el0);
+	/*
+	 * TODO: The highest privileged level is supposed to initialize this
+	 * register. But on some systems (which?), this information is only
+	 * contained in the device-tree, so we'll need to find it out some other
+	 * way.
+	 */
+	if (!timer_freq || timer_freq < SEC_TO_US)
+		return -ENODEV;
+	return 0;
+}
+
+
+#define pkvm_time_us_to_ticks(us) ((u64)(us) * timer_freq / SEC_TO_US)
+
+void pkvm_udelay(unsigned long usecs)
+{
+	u64 ticks = pkvm_time_us_to_ticks(usecs);
+	u64 start = pkvm_ticks_get();
+
+	while (true) {
+		u64 cur = pkvm_ticks_get();
+
+		if ((cur - start) >= ticks || cur < start)
+			break;
+		/* TODO wfe */
+		cpu_relax();
+	}
+}
-- 
2.39.0

