Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFA9623A5
	for <kvmarm@lists.linux.dev>; Tue, 13 Jun 2023 06:43:48 +0000 (UTC)
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-4f624daccd1so5893406e87.0
        for <kvmarm@lists.linux.dev>; Mon, 12 Jun 2023 23:43:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1686638626; x=1689230626;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WwJ84lVw08wCsE95kQ0UTXAZqJk3Huei6Deabf+TMMI=;
        b=a8WCsz0oVX69Jbpov+VLq0SWUe+h1mt1pwDO9ey85cvKAGtRk/EdWbadNdyUHMjP37
         8roQjrqIOm6+VaSM0cJLF8rgdUFH/Kuk2xKq9noEXAZzETpj1mdARqp/n2JhCrtz6cPg
         ZI9RwF9Fzk/XZ0shuaPvLK7DlCtU/21OQvGG0+iOKAvEx13PmpSV2T5LRrDohBWLtH+w
         u4PkaBL75sDY/AEZnRk2F5P2EYdNCu5Fyb2IJ8CNCGb6kv7taTieMNIllOAtqqAa4AUm
         ZihiA3ojcHPC0oz5zCKqdi2dK8vhA1+O7rjUVUUiMOETGXniNA4f1xiAf8VZsAQL/6qD
         gt3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686638626; x=1689230626;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WwJ84lVw08wCsE95kQ0UTXAZqJk3Huei6Deabf+TMMI=;
        b=dJqD/hb3stOU1Tj7K3xXLv9+7V5zDs+goSydxGtmsF9MDxAv81jS1BB5GjBz7MeiMA
         07qIriYJTIP/lB2lG0UUOfluNJnx7ZJFUG9HNJCs/AlwOvPypsfiBCHECDcl6YwvnSGA
         oORdM+eTjwt8jAhZvRr4Eoe8EvpF2oKW+HtSnqgjgrAeRf1bwQNOGGMGBxa/8eha7o4l
         tuCoZY7k9DnFzBV+zA4JqFLn68A0ZkoWem0bM+HKRcxbt4/z9dRvkI2TBbPDBonHLCDm
         N/YVjHB5GBo9+IjRt9FGIS5X5IQOAYeyThqrRhV5dC5HV+ru4ASuUAkUDWaUoW28Qbhi
         8gxA==
X-Gm-Message-State: AC+VfDwkXaet5s5luDsW48CYzdswuZhIi8hs4NF3wTuOUxsMZk/lRO2w
	EfxVPh0qdbtfX2c8Lk9DzXHNmA==
X-Google-Smtp-Source: ACHHUZ49Lblei1XzaLcZJ1ENLHSgfvYbxjwZINob+g4GPuDl/9J8CpY7n6u+x2U4zthUt/Nb0q5T6g==
X-Received: by 2002:ac2:465b:0:b0:4f6:4f9a:706e with SMTP id s27-20020ac2465b000000b004f64f9a706emr5685303lfo.15.1686638626525;
        Mon, 12 Jun 2023 23:43:46 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id t25-20020a1c7719000000b003f7eeec829asm13365954wmi.10.2023.06.12.23.43.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jun 2023 23:43:44 -0700 (PDT)
Date: Tue, 13 Jun 2023 09:43:39 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Christoffer Dall <christoffer.dall@arm.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, kernel-janitors@vger.kernel.org
Subject: [PATCH v2] KVM: arm64: timers: Fix resource leaks in
 kvm_timer_hyp_init()
Message-ID: <72fffc35-7669-40b1-9d14-113c43269cf3@kili.mountain>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding

Smatch detected this bug:
    arch/arm64/kvm/arch_timer.c:1425 kvm_timer_hyp_init()
    warn: missing unwind goto?

There are two resources to be freed the vtimer and ptimer.  The
line that Smatch complains about should free the vtimer first
before returning and then after that cleanup code should free
the ptimer.

I've added a out_free_ptimer_irq to free the ptimer and renamed
the existing label to out_free_vtimer_irq.

Fixes: 9e01dc76be6a ("KVM: arm/arm64: arch_timer: Assign the phys timer on VHE systems")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
---
v2: renamed the label as Oliver Upton requested.

 arch/arm64/kvm/arch_timer.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index 05b022be885b..0696732fa38c 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -1406,7 +1406,7 @@ int __init kvm_timer_hyp_init(bool has_gic)
 					    kvm_get_running_vcpus());
 		if (err) {
 			kvm_err("kvm_arch_timer: error setting vcpu affinity\n");
-			goto out_free_irq;
+			goto out_free_vtimer_irq;
 		}
 
 		static_branch_enable(&has_gic_active_state);
@@ -1422,7 +1422,7 @@ int __init kvm_timer_hyp_init(bool has_gic)
 		if (err) {
 			kvm_err("kvm_arch_timer: can't request ptimer interrupt %d (%d)\n",
 				host_ptimer_irq, err);
-			return err;
+			goto out_free_vtimer_irq;
 		}
 
 		if (has_gic) {
@@ -1430,7 +1430,7 @@ int __init kvm_timer_hyp_init(bool has_gic)
 						    kvm_get_running_vcpus());
 			if (err) {
 				kvm_err("kvm_arch_timer: error setting vcpu affinity\n");
-				goto out_free_irq;
+				goto out_free_ptimer_irq;
 			}
 		}
 
@@ -1439,11 +1439,15 @@ int __init kvm_timer_hyp_init(bool has_gic)
 		kvm_err("kvm_arch_timer: invalid physical timer IRQ: %d\n",
 			info->physical_irq);
 		err = -ENODEV;
-		goto out_free_irq;
+		goto out_free_vtimer_irq;
 	}
 
 	return 0;
-out_free_irq:
+
+out_free_ptimer_irq:
+	if (info->physical_irq > 0)
+		free_percpu_irq(host_ptimer_irq, kvm_get_running_vcpus());
+out_free_vtimer_irq:
 	free_percpu_irq(host_vtimer_irq, kvm_get_running_vcpus());
 	return err;
 }
-- 
2.39.2

