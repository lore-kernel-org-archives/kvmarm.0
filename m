Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3820ABE77
	for <kvmarm@lists.linux.dev>; Mon, 12 Jun 2023 07:07:53 +0000 (UTC)
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-3f7f4819256so28710675e9.1
        for <kvmarm@lists.linux.dev>; Mon, 12 Jun 2023 00:07:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1686553672; x=1689145672;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tnCxW0itTMo6yA3XNQbbmF8xoq0kbOuc9xf7ZwUXCgc=;
        b=AjUEzLuwBYYyf1jbHOpvc6+JllXdUSMtkFr7TKGPKZqLBlwOnHdzRr9qoaUibyzByR
         a991lbdsojsORGHg6in+lAYfB9j+dMIoJtcLQ9eJGWGuLXQLvXtkrWseNO/H6dQ4KDeE
         A2pqJXmxFq6OE9g9/+3ni3XOKzCPNffoizAvUD77PzhVLQ3jimoQ3GNHe7uWHDXrSLQI
         ReMP8kHpIBPYOJNCgdjgMzQrF2ZRXkzTkic7vvCw5qqOyE4nNRTHQBX3jO2z4Dq89mR1
         I76wcyDZnfDpKiBnuwHfsClrmYl+MxdYAktvhxyErCq6i5orQU4fD/9PNuehG7Jpcf7S
         cWOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686553672; x=1689145672;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tnCxW0itTMo6yA3XNQbbmF8xoq0kbOuc9xf7ZwUXCgc=;
        b=XObu7lwQTYLyua0jPKxS6L3kurRV7b/1yrQone3+oTv6RfP7WrHX6tphw+mxSMoX/i
         378IfkEJOw0Btbvh8FBx/dRfSRp8luJiG3uzOSICp9fyW1H+YGIeCPn33suWWA5xW+f2
         HIRw1h9URT8TszGTei8RQcrOQHfzedDFb1c5OoD7PZ12s58QDobbCfhS8mFwmGtFULdA
         ZVfzbOnK0+gv7FVZLtHkay4u3CPuXs9G3p3mPjizjoY8uIn3CjTeGiAhQCWV4Hwtrmrd
         uEpYMdeJMmH9kTGHQR2Z612uLArYOY7TKCKUrvKuiYFt0oIfvOC04h7kdPOrTiyG7Ahg
         uBtA==
X-Gm-Message-State: AC+VfDwn815UcSpSLnhoY+Rdz7RiXpIcm9cx5v75nHamYXxFK+t6lfqx
	muKBigZQVJHmhJWvdxWhir7ZMQ==
X-Google-Smtp-Source: ACHHUZ4pmw8BWg0wWjjye8G9cWexophtsTqyab55gNCps5/WPk8Yrdx2UsNUrSaI5OFSkNxilzQIDQ==
X-Received: by 2002:a7b:c8da:0:b0:3f7:e8fc:678d with SMTP id f26-20020a7bc8da000000b003f7e8fc678dmr5977585wml.13.1686553672137;
        Mon, 12 Jun 2023 00:07:52 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id e13-20020a05600c218d00b003f709a7e46bsm10317708wme.46.2023.06.12.00.07.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jun 2023 00:07:50 -0700 (PDT)
Date: Mon, 12 Jun 2023 10:07:46 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Marc Zyngier <maz@kernel.org>,
	Christoffer Dall <christoffer.dall@arm.com>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, kernel-janitors@vger.kernel.org
Subject: [PATCH] KVM: arm64: timers: Fix resource leaks in
 kvm_timer_hyp_init()
Message-ID: <e0dd820f-52d2-4c54-97f3-5aa02e0bd6e0@kili.mountain>
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

There are a couple error paths which do not release their resources
correctly.  Fix them.

Fixes: 9e01dc76be6a ("KVM: arm/arm64: arch_timer: Assign the phys timer on VHE systems")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
---
 arch/arm64/kvm/arch_timer.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index 05b022be885b..c2df8332d2bd 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -1422,7 +1422,7 @@ int __init kvm_timer_hyp_init(bool has_gic)
 		if (err) {
 			kvm_err("kvm_arch_timer: can't request ptimer interrupt %d (%d)\n",
 				host_ptimer_irq, err);
-			return err;
+			goto out_free_irq;
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
 
@@ -1443,6 +1443,10 @@ int __init kvm_timer_hyp_init(bool has_gic)
 	}
 
 	return 0;
+
+out_free_ptimer_irq:
+	if (info->physical_irq > 0)
+		free_percpu_irq(host_ptimer_irq, kvm_get_running_vcpus());
 out_free_irq:
 	free_percpu_irq(host_vtimer_irq, kvm_get_running_vcpus());
 	return err;
-- 
2.39.2

