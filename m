Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D23722564
	for <kvmarm@lists.linux.dev>; Wed, 19 Apr 2023 08:06:49 +0000 (UTC)
Received: by mail-wm1-f51.google.com with SMTP id o6-20020a05600c4fc600b003ef6e6754c5so972606wmq.5
        for <kvmarm@lists.linux.dev>; Wed, 19 Apr 2023 01:06:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681891608; x=1684483608;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5OSy/8KzIeE0uT9f/JXeORSJpU/CYejtTTaWQ7l0cpk=;
        b=I8aI/cLLjYoF3kyrKmp9YJiuCEi4+DaA0/Tf1Wlln3rCKFpfdw2256mLJX0HaWUoNK
         xW4PWvfMz83BrqmG3fo+l9pem/lnSXQ+cD99N/RIzI7LH+1jumcHIKAxgUx6t6gsKcu2
         eOGQO7G1/crQL3gXYxjOAuGMtnLaD3Gj/GFKOgfF+KY2l9rF38QZnfx3p6U/yHiZOlku
         B2/Dbw+4Z4ajzhpGGRJQQth5rzjUJHOldvXVSBAO3N6/44yd830J6oSARQlZwJonMg1j
         G/PrUVBpAUBdcxU07zzD/uu/yNhwmRxzRy6mtZKGZNpONul/NLciyp8+mNV5BD2v/Wio
         H4Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681891608; x=1684483608;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5OSy/8KzIeE0uT9f/JXeORSJpU/CYejtTTaWQ7l0cpk=;
        b=fhqfPOOqiw1RbuFxGiuDw+UQyQxlxmMzgQL5CvKlD5+WL2Z/pGpm3mNN0eIwvvMl7C
         WPdz5XjXc4pf3U693B+nEnJk/RdEyU+6DHnlUr76F7OYOoYKDbR8MBXs7ty6Wk89eG41
         OIxxcKin+3+0HNJpTU5bGPSFsenA0AVvzTFpA3wuP2/FsF/tVf/Gy6UI56pqTakWoom2
         V0X3IlGRH1Ts5idZdcB3I6AQ7/sCnHL7givkt42jzvq+S5o7wMPZz8dAjtZgxw0tcpFJ
         UQdEnq+fLOWe6y5lixgypBE4Ci6lUcUBCx0dd9L4Q3HvBsvmQOdHchHcY+jqDUtuHLr2
         qa0g==
X-Gm-Message-State: AAQBX9f7DXDj4776Zoo8WL4ybuoaGAbhxnuZcfMo1qLmH4k8fv76jB14
	PNlPPhVMJL3QiP3KSmBM1VOKrA==
X-Google-Smtp-Source: AKy350bsXyYLNtU1VpGGhfXi3kZDPExX20afgftMWFgCyE1KG7y4AfQzl/Q5ztY1W9WRfVoR4ylEnw==
X-Received: by 2002:a7b:c404:0:b0:3f0:a785:f0e0 with SMTP id k4-20020a7bc404000000b003f0a785f0e0mr14741958wmi.40.1681891608041;
        Wed, 19 Apr 2023 01:06:48 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id q18-20020a7bce92000000b003f09d7b6e20sm1386729wmj.2.2023.04.19.01.06.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 01:06:47 -0700 (PDT)
Date: Wed, 19 Apr 2023 11:06:44 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Andre Przywara <andre.przywara@arm.com>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Steven Price <steven.price@arm.com>,
	Eric Auger <eric.auger@redhat.com>,
	Andre Przywara <andre.przywara@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	kernel-janitors@vger.kernel.org
Subject: [PATCH] KVM: arm64: Fix buffer overflow in kvm_arm_set_fw_reg()
Message-ID: <ab7b9caf-5c90-4616-8517-b38637293639@kili.mountain>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding

The KVM_REG_SIZE() comes from the ioctl and it can be a power of two
between 0-32768 but if it is more than sizeof(long) this will corrupt
memory.

Fixes: 99adb567632b ("KVM: arm/arm64: Add save/restore support for firmware workaround state")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
---
 arch/arm64/kvm/hypercalls.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index 2e16fc7b31bf..4f5767fcaca5 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -544,6 +544,8 @@ int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	u64 val;
 	int wa_level;
 
+	if (KVM_REG_SIZE(reg->id) > sizeof(val))
+		return -EINVAL;
 	if (copy_from_user(&val, uaddr, KVM_REG_SIZE(reg->id)))
 		return -EFAULT;
 
-- 
2.39.2

