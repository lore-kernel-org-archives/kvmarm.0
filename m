Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2B792F52
	for <kvmarm@lists.linux.dev>; Wed, 19 Apr 2023 10:16:19 +0000 (UTC)
Received: by mail-wm1-f41.google.com with SMTP id v3so3800830wml.0
        for <kvmarm@lists.linux.dev>; Wed, 19 Apr 2023 03:16:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681899378; x=1684491378;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rPcJtM/qvgD7Ydsb0412bscSrzwXXzWCh+7Eqp0cORw=;
        b=KXsLSpx0jI1kNU+p0EO76wj/TL7n3/j0tKh99FFz9OAsCvrhMPt4DieEOZF5akBNIL
         WxKlTwjfRl6wEYtN/bi14odLZeL3WllmKOxi0QPucg0x/UoRJ65VwHi+V1izPJs0kOYJ
         vb1dIF5ccvoTbZjWYX92NCMjHTPJ4godzoiudWhHpd7ZgaBEIzhjhFsJ5+/RRD1NXact
         6wc+5AbnbJB77Khmop9CVf24OurLZxwrJjPDhViffKYAr8HP56K5V0n4aMYz0xzk4S/a
         YS9LNSGYyUEvDjQ/su5bQvahjjXB6Wl65VN7PgNutpgPGAUjDqcFcA2s1XehR07aMGQh
         VqfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681899378; x=1684491378;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rPcJtM/qvgD7Ydsb0412bscSrzwXXzWCh+7Eqp0cORw=;
        b=ZNTJWkaKBsBszOoyJnnSgjpzTECHv5ZoToCbnbxoE4YcAIHZ0irTuL+mVqKDmF1dMC
         wH1js6ChVo55k7Z6RgMGOUtPQrhDCRWE2zgFyot15gVix9ufGHlks0X4QCjIVzHEl0/c
         PagDOiTPwuRhwuHCOtsSR/0dQLkMiAvPQN3aMS3croRtK9ZaaqAqeld+pLmwkJUWklMw
         0J+rtZh8UtJtj3EhYfuFA2GSaJIUafLnlaTrifQ4LtxGUfU8qirZOoy+486XbHDAJBjn
         EtXgBs1LTJ1OVzIwEH8nA/u/TX9L6pOsoPrVvftgQVYsx1v6jPGeFmGWcLuOugThTbXO
         fTjQ==
X-Gm-Message-State: AAQBX9d+1XdVntm15Z4nY909ZNA8fPWadko5Eh+JnlGtunn/yNdl3jad
	YH0ygpNcrfYEtaCMGUYBKb7Xbg==
X-Google-Smtp-Source: AKy350aEHBzsMieGjP0fxml8DwagDGYBm2MsSTUbOaxuPaDLRKC+WnSJcv/TzlDiCUp8g0ECW60bKg==
X-Received: by 2002:a7b:ce06:0:b0:3eb:29fe:f922 with SMTP id m6-20020a7bce06000000b003eb29fef922mr15929105wmc.29.1681899377915;
        Wed, 19 Apr 2023 03:16:17 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id s13-20020a7bc38d000000b003f1745c7df3sm1728394wmj.23.2023.04.19.03.16.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 03:16:17 -0700 (PDT)
Date: Wed, 19 Apr 2023 13:16:13 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Andre Przywara <andre.przywara@arm.com>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Eric Auger <eric.auger@redhat.com>,
	Steven Price <steven.price@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	kernel-janitors@vger.kernel.org
Subject: [PATCH v2] KVM: arm64: Fix buffer overflow in kvm_arm_set_fw_reg()
Message-ID: <4efbab8c-640f-43b2-8ac6-6d68e08280fe@kili.mountain>
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
v2: The original patch was okay but checking for != sizeof(val) is
    stricter and more Obviously Correct[tm].  Return -ENOENT instead of
    -EINVAL in case future ioctls are added which take a different size.

 arch/arm64/kvm/hypercalls.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index 2e16fc7b31bf..7fb4df0456de 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -544,6 +544,8 @@ int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	u64 val;
 	int wa_level;
 
+	if (KVM_REG_SIZE(reg->id) != sizeof(val))
+		return -ENOENT;
 	if (copy_from_user(&val, uaddr, KVM_REG_SIZE(reg->id)))
 		return -EFAULT;
 
-- 
2.39.2

