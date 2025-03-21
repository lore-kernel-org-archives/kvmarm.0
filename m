Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56296191484
	for <kvmarm@lists.linux.dev>; Fri, 21 Mar 2025 14:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742567579; cv=none; b=ojaS2SNLNyOtf+Sq9W7fwmS1VbsDEIOB8WtvjCdxXkCxTmwKPhV3dVI0D/j6sp02eX3Bc053GomGhwSks4RwG5Vvi42k2owGa9rUTrjnDwijD30U2Z25oh6RXwkxAeMJJKWCi8m393yVT7WXbWG+DHWkZg7Tmo6WCcIEdYuUjys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742567579; c=relaxed/simple;
	bh=+LDlUo8we7HXs412riW2XVXscOex6Sq1qjsJfiM5m7E=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=a0gHZOk8a+MeWp7xShIlmKMVOVUqtvJO4F4xbj7cT/dyOlvyi4C0Az8pgFqANovhoHJO6229ZgFN/4tk+C22YUzxLJ4/1/Dj5sLcdmKVEIWyKeMnee2SOfZEMmLrIvh8NRigi7EcXgVo4Wg+qfu3IrfpAzAFDrX3RuHfhUseEQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=A/TcHO1j; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="A/TcHO1j"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-43cfa7e7f54so12816085e9.1
        for <kvmarm@lists.linux.dev>; Fri, 21 Mar 2025 07:32:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742567575; x=1743172375; darn=lists.linux.dev;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MzFQfhx5F8dx0RL9AvvQYwg76iw5NXa4lMy+vsdeqMg=;
        b=A/TcHO1jigEyMvHjKJKWb7JPs5viJPN1S1zDDsEwhndzOZ2hlNLfp7Dd8RWzZxqV+G
         jZJixwojMEaalCRpMFO4H0XZdhrMsZfk7rxMSnJDxQNtGK5vX8zj6USE9wfBvsDgiukA
         J2KMkQt+ZuPGY9MOjNCjnNV+GaME8UczhrnXUFbQ140CxZL+Qr8FTFbHfzkMcLcfy++n
         3pVjEL2jy3xTA5GKxqdiGNN7ZWr3LZ9/149lmpH5TPx5b4RAzPH17XO9U4Bw2aLTwhHr
         as/MlVtTeFRCN2SlpP4q04iz4StS0QuK4ww0bzmTwZItk8CaH/sp9ENab3xlqXpNi5+s
         3Y0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742567575; x=1743172375;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MzFQfhx5F8dx0RL9AvvQYwg76iw5NXa4lMy+vsdeqMg=;
        b=o2HsrlrVyh1lfhc9jZYlMiZThayYubfuvcNNanuLoCf3cqh+2/igRhpc/V4HgqwdeK
         GyNgNkRJUxbHKiDub5ldAbROQNMewyzyVpPhFLUlz1Qy3mzuVVzNNWMYw7dSDc0DIDEG
         m3HN6UTXOJs69PnVAHJdiY1BeYuDp4FTkEMTo2timqWcOstkrFcsMQlIbENH1vEQcFtO
         WeEnmWnIT7cdGc2Yz3YeSANlN5WqxJupFIMoLBHbctYifWmyK1TKAdQWLGQCVP1UtrnX
         jO6VYxlCpyOafBszyrA5LZPfPF/ewOaV0f5G4yYVTC1na5fj73y+DmyCs3KkBDpl4hVe
         v38A==
X-Forwarded-Encrypted: i=1; AJvYcCUI1vF65nrd4dOmo2+QsRCv3xALlCltKDv4DL/EqOnDj96LrmBMQwUBqVh6ehqdFUrm1gehUmU=@lists.linux.dev
X-Gm-Message-State: AOJu0YywO0BkBjpuJMgp0tL150ITvmCKOukZLtbyl+PZtXX96F2eCdna
	V3+thxWdOlGHFcclVyynHUAui958gyeiBz2XZ1Z7pmDKdswF1UtoniVDpGv/jvA=
X-Gm-Gg: ASbGncsf73Tlzt0feR05HdZZw40NYPSuIAwnFim/ty/rJy65/9jRwvGUFkX9Z2B8xa6
	2cqwubMnf8bgQomnHGzDpKK/eizbBbrlZM/qh5oqxf65LtwwcBWjqeZgNV5kGX72LZyskmQi3dG
	jmBVIj9mzW2TKrNDe/71sRlMMcVuj1qe597jAG0wwPzcrahtqmMpF+mNztokEyUk56q9RDhnYEe
	1JLChtgDz+CYTIPdIjBLP5cYX8XmeI0bWhGY5Bhc5Atdi/9n9sJUFxEEoRLYLHOwdW6fTd7B0i+
	BcX593L4D9DwWVygJTlfKtYOPRFpIVYW+h24PsTbPYfByWN53g==
X-Google-Smtp-Source: AGHT+IFdHgCx4C5nFq7a41Rl1TdfpLB7mC6eqzVe1FxFvJX3eQdkfF3U3LPtyEx8bVlfn1VSsrBleA==
X-Received: by 2002:a05:600c:1c02:b0:43d:5264:3cf0 with SMTP id 5b1f17b1804b1-43d52a08ed8mr22225315e9.11.1742567575525;
        Fri, 21 Mar 2025 07:32:55 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-43d4fd27980sm28845345e9.21.2025.03.21.07.32.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Mar 2025 07:32:55 -0700 (PDT)
Date: Fri, 21 Mar 2025 17:32:53 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Ricardo Koller <ricarkol@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
	Andrew Jones <drjones@redhat.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] KVM: selftests: Fix a couple "prio" signedness bugs
Message-ID: <ca579322-dc9d-4300-bd74-7e9240e930c7@stanley.mountain>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding

There is an assert which relies on "prio" to be signed.

	GUEST_ASSERT(prio >= 0);

Change the type from uint32_t to int.

Fixes: 728fcc46d2c2 ("KVM: selftests: aarch64: Add test for restoring active IRQs")
Fixes: 0ad3ff4a6adc ("KVM: selftests: aarch64: Add preemption tests in vgic_irq")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
---
---
 tools/testing/selftests/kvm/arm64/vgic_irq.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/arm64/vgic_irq.c b/tools/testing/selftests/kvm/arm64/vgic_irq.c
index f4ac28d53747..e89c0fc5eef3 100644
--- a/tools/testing/selftests/kvm/arm64/vgic_irq.c
+++ b/tools/testing/selftests/kvm/arm64/vgic_irq.c
@@ -294,7 +294,8 @@ static void guest_restore_active(struct test_args *args,
 		uint32_t first_intid, uint32_t num,
 		kvm_inject_cmd cmd)
 {
-	uint32_t prio, intid, ap1r;
+	uint32_t intid, ap1r;
+	int prio;
 	int i;
 
 	/*
@@ -362,7 +363,8 @@ static void test_inject_preemption(struct test_args *args,
 		uint32_t first_intid, int num,
 		kvm_inject_cmd cmd)
 {
-	uint32_t intid, prio, step = KVM_PRIO_STEPS;
+	uint32_t intid, step = KVM_PRIO_STEPS;
+	int prio;
 	int i;
 
 	/* Set the priorities of the first (KVM_NUM_PRIOS - 1) IRQs
-- 
2.47.2

