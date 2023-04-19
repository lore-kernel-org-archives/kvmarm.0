Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B756B15A8
	for <kvmarm@lists.linux.dev>; Wed, 19 Apr 2023 02:19:00 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id u188-20020a2560c5000000b00b8f15f2111dso22400061ybb.4
        for <kvmarm@lists.linux.dev>; Tue, 18 Apr 2023 19:19:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681870739; x=1684462739;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=uIQVFmX2aoFoB7i2FrXfQsGBMoh8PIBdIK2tuO4hjcE=;
        b=CqkfmgshtxXCDoumegN3GvSg7vBd4yCTTTm8UpwCMPCCVp/+QHAP9RorSdNPlx2Wxq
         oa3W/9rcPxRhN9uVS6DS3+wDEsjjrmdvTpM505bOpJhFyREhyCUQRSoja6211lvE0uwp
         MLyZ29Ez/o6xihqBuvIELX4fo4yx0SVROkrEiGa9TBOugFnouJamqyFmrw+TXpFoDbJ4
         nHlfWBq/UX0RaPCsqDYkrvcz1CnYoQosrNzHaq5QLLegTTtEV0xt+sVpe9MYllWKdN82
         tAMVDYBE7a9Y3nH/KMAQcjpuIUcxFgfeAfPPyANOafHx7Unfra7dj46EYLyHR172zvVv
         HJ5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681870739; x=1684462739;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uIQVFmX2aoFoB7i2FrXfQsGBMoh8PIBdIK2tuO4hjcE=;
        b=OGEReSlHdfzAArUdhpJYndNgBEdDcJkilrPMya65jhdXm8XPMBqEZUvZxaPoMBfVs9
         zQsqoqGy9B4GloIMIvbH0AX7K+eXSp/ZvWKEi8C63Phk4jQfIlMNOdiRtI8YTdL4OECh
         ReMpK4B4P5h/dFijSj46LZ130XaaOFdxssxSLoDvMLGrMRXCYtiEt2FAHaVEJIhrS/DE
         8t9GpnB298rwNDHm0r1Ka4Q0IpmTyKkpwhe5RI3Wwmk3UGshY632x3IUqWCEQobEyu6c
         l1mJxi9dvuzC3W0Rv0/OnMV1vNzeIdrsYo6+SL4t4yyin+oUWJYhnVcqURMzjjiGxQDM
         rHkA==
X-Gm-Message-State: AAQBX9dl0mOjTUAuqwzgwtjwRXnhzAXRHcBEkNTv1WqwhiYIxapDbfjO
	g4t/heVWAhTotSj0+9SlcL5aKkQbMW8=
X-Google-Smtp-Source: AKy350ZLWc6OkYyhEAgKi+QBFBzZGsmT+IJkc0Q/GXXtRpvSXCQVykIPCe0taP5PrBoHwrlqYeadfzkeFv0=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a05:690c:2787:b0:54f:e2ca:3085 with SMTP id
 dz7-20020a05690c278700b0054fe2ca3085mr649642ywb.1.1681870739753; Tue, 18 Apr
 2023 19:18:59 -0700 (PDT)
Date: Tue, 18 Apr 2023 19:18:50 -0700
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.396.gfff15efe05-goog
Message-ID: <20230419021852.2981107-1-reijiw@google.com>
Subject: [PATCH v1 0/2] KVM: arm64: Fix bugs related to mp_state updates
From: Reiji Watanabe <reijiw@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Ricardo Koller <ricarkol@google.com>, 
	Jing Zhang <jingzhangos@google.com>, Raghavendra Rao Anata <rananta@google.com>, 
	Will Deacon <will@kernel.org>, Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"

This series adds fixes that were missing in the patch [1].

The patch [1] added the mp_state_lock to serialize writes to
kvm_vcpu_arch::{mp_state, reset_state}, and promoted all
accessors of mp_state to {READ,WRITE}_ONCE() as readers do not
acquire the mp_state_lock.

Since the patch [1] didn't fix all the relevant code, fix the
code that weren't addressed yet.

This series is based on v6.3-rc7 with the series [2] applied.

[1] https://lore.kernel.org/all/20230327164747.2466958-2-oliver.upton@linux.dev/
[2] https://lore.kernel.org/all/20230327164747.2466958-1-oliver.upton@linux.dev/

Reiji Watanabe (2):
  KVM: arm64: Acquire mp_state_lock in kvm_arch_vcpu_ioctl_vcpu_init()
  KVM: arm64: Have kvm_psci_vcpu_on() use WRITE_ONCE() to update
    mp_state

 arch/arm64/kvm/arm.c  | 5 ++++-
 arch/arm64/kvm/psci.c | 2 +-
 2 files changed, 5 insertions(+), 2 deletions(-)

-- 
2.40.0.396.gfff15efe05-goog

