Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 265F563136
	for <kvmarm@lists.linux.dev>; Thu,  7 Mar 2024 08:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709799596; cv=none; b=lEMRs923EhoK9OOpxT2u5ZqMe2ZAzhGycM3YYRJ9s98SvFhShQhYaTr0Vo2sUCi7aDcvuSwmqXyKXu3urfQpIwpfG6Zt03HATLEGKjEu9lszZcYZcbDQCgTm10SiGLH6wzLAKyjixmInIJehEBD26/9bc0nqb0WPlC7/QLet8P0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709799596; c=relaxed/simple;
	bh=8FP38S7OrZ+MpTjf4w+My1/hNKejVVNsZfh22HhsIUI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=DYOjrfq2chQnrFqexlbuFei0KrHgsRcIaQrFDD2iGMk8OBwiQjbM2qyBeENB4flhCnZqJ818Q0Z4gJZtD76gHrr0L/aycMF/Nl3cXskti+kpFxo6DS3F18tSaCAyN/xNjSi9VhWJ40NI7wwXTe18/ebO7PimkqywA9ckFj9TtdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hYJq7TK0; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hYJq7TK0"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-412e784060cso10287795e9.1
        for <kvmarm@lists.linux.dev>; Thu, 07 Mar 2024 00:19:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709799593; x=1710404393; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Q3cfeh/qgTCzNyqJWZG5K1iEv2VogtsczNtBj4FEYbc=;
        b=hYJq7TK0dO2edN8uW7TPUW9MPDwGepHY+PK3irHrV9jImEZXuQG9Gv1yEn1KdGIH1A
         C6ob2hpNU6x9T+VCBB7YbagujQeFD7P60VQX8in3QEbePx84OUzF5YwtLafYYo8I3Q/C
         2eiqPecWOAyIG9J19Jy+EeX/KoZgz080CkMyAgL7+S6mFWW+cevHfifi7+0eW2gU4liS
         LLiaCx+jPqZIWPa66r6B4eJgaE3g0LpQIQ9gfGKTgeI3YSSgo/FJRZduSVRW1IpoEST8
         fsOySHXSb9Adpc8944pqRDY1aPddEJr8mbmdIAs3pIWAFF7Bn9dsg9ovHMFBncQF1NKX
         7cXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709799593; x=1710404393;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Q3cfeh/qgTCzNyqJWZG5K1iEv2VogtsczNtBj4FEYbc=;
        b=Ssc1CKIZ5d7EZq8CqmoIG8k2r4iVZsm08vI6T0Z1/J9Mt6vE15RGdXHMi8FLR9jdpW
         E2ALFgTCVyIZ+Lahoi0T1niv6gQ5gz+FPs2Ht/R5ijsSQg8/ffcMntbPm1LnXvs/Ur6x
         /pP5sNlC4pbPAW7jAdJh/SEDm5nl4bGMUTX0PhMcIBZBo8OlQfB5GeSVJ+R563G/SDl3
         a1otboWoj4bRw3uvI8ITY4UhDVPo8riIZqrLpCaL+mraKFV+7AQwyF4weGH3If5vpQqn
         VoxnGXuykksmfpXwt2T+mjuoKUGc1D7IklY6neWa9SW84FW8R6EXyLeWiOMDThrmRknI
         krKQ==
X-Forwarded-Encrypted: i=1; AJvYcCWTlhmgWbFuswww/AJeLCw0SFsbSJxhFEqN6kRhf2mZMhhewTy5LUzSjLpHbF7FelfMWuPsBcwBbpALuDOBRjRtoAHtkioM
X-Gm-Message-State: AOJu0YxD+yM28YK/UslgAAu9XSaXYKXZCxnZKrYjEJlPzA9lUpgsGNUX
	QfKwjnhol3DHB+jAMTiY7LeUT1KdN2W9gs6nRxwbl0h/Knl8Flz+
X-Google-Smtp-Source: AGHT+IHxp22ZICjNl26x1Qf0pwp3S9ZJz469LBsA59Wew3XXWy7W/Otp9bwAH8nrbisN+qEZRG5Xig==
X-Received: by 2002:a05:600c:4f91:b0:413:119:33e2 with SMTP id n17-20020a05600c4f9100b00413011933e2mr701067wmq.14.1709799593095;
        Thu, 07 Mar 2024 00:19:53 -0800 (PST)
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.gmail.com with ESMTPSA id fb12-20020a05600c520c00b00412f81ba413sm1788954wmb.11.2024.03.07.00.19.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Mar 2024 00:19:52 -0800 (PST)
From: Colin Ian King <colin.i.king@gmail.com>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org
Cc: kernel-janitors@vger.kernel.org
Subject: [PATCH][next] KVM: selftests: Fix spelling mistake "trigged" -> "triggered"
Date: Thu,  7 Mar 2024 08:19:51 +0000
Message-Id: <20240307081951.1954830-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

There are spelling mistakes in __GUEST_ASSERT messages. Fix them.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 tools/testing/selftests/kvm/aarch64/arch_timer.c | 2 +-
 tools/testing/selftests/kvm/riscv/arch_timer.c   | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/arch_timer.c b/tools/testing/selftests/kvm/aarch64/arch_timer.c
index ddba2c2fb5de..16ac74d07d68 100644
--- a/tools/testing/selftests/kvm/aarch64/arch_timer.c
+++ b/tools/testing/selftests/kvm/aarch64/arch_timer.c
@@ -136,7 +136,7 @@ static void guest_run_stage(struct test_vcpu_shared_data *shared_data,
 		irq_iter = READ_ONCE(shared_data->nr_iter);
 		__GUEST_ASSERT(config_iter + 1 == irq_iter,
 				"config_iter + 1 = 0x%lx, irq_iter = 0x%lx.\n"
-				"  Guest timer interrupt was not trigged within the specified\n"
+				"  Guest timer interrupt was not triggered within the specified\n"
 				"  interval, try to increase the error margin by [-e] option.\n",
 				config_iter + 1, irq_iter);
 	}
diff --git a/tools/testing/selftests/kvm/riscv/arch_timer.c b/tools/testing/selftests/kvm/riscv/arch_timer.c
index e22848f747c0..0f9cabd99fd4 100644
--- a/tools/testing/selftests/kvm/riscv/arch_timer.c
+++ b/tools/testing/selftests/kvm/riscv/arch_timer.c
@@ -60,7 +60,7 @@ static void guest_run(struct test_vcpu_shared_data *shared_data)
 		irq_iter = READ_ONCE(shared_data->nr_iter);
 		__GUEST_ASSERT(config_iter + 1 == irq_iter,
 				"config_iter + 1 = 0x%x, irq_iter = 0x%x.\n"
-				"  Guest timer interrupt was not trigged within the specified\n"
+				"  Guest timer interrupt was not triggered within the specified\n"
 				"  interval, try to increase the error margin by [-e] option.\n",
 				config_iter + 1, irq_iter);
 	}
-- 
2.39.2

