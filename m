Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79C18641
	for <kvmarm@lists.linux.dev>; Sat, 19 Aug 2023 04:39:58 +0000 (UTC)
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-589f986ab8aso33880457b3.1
        for <kvmarm@lists.linux.dev>; Fri, 18 Aug 2023 21:39:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692419997; x=1693024797;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=NAca2i6UT+kRpNiNFqciMgXTaQn9Xpc8llxW6p9qkeo=;
        b=wmIKDueAzDkg5mxJ5ZNP7/6f52f0rR1DEpWv1vDg7bdBkBfkOgRv05OXQ/KKza9duU
         uDwvjRW87K84Qhy4J8KTfnh0b6jdbRXjmGzp4u2pGu9K8tQjC94kna1KZJx20pnvRyup
         mrxBr0kSUBIfwpcvAsdB6PuIBMcwoMVQRGcAIZ5y0u7+zq8BnBGvoY2w6XUZQOR3yxE4
         EJUqIfKniCMX0CdUcKBHQ1izczUuoqhi8wfBszr9HvGfmys3idkABS4tN+oplISb8Gxm
         z6CrkDrgL5xBld6lDyfrzeH9jB3Lw15Jys03dUw/g1G4cYc5E5OsPwRa3NloehhPOrmn
         VAhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692419997; x=1693024797;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NAca2i6UT+kRpNiNFqciMgXTaQn9Xpc8llxW6p9qkeo=;
        b=Qp/W2SLyR3upiLeuVYFma+DfNRrP/767WFNdIgff0N36SqQ4A84EfRzjENAWxOvdwM
         xibX9RM1x+EwFr8LqfhQFmWoZ7EEV6CtgZMXvdKaqhg7TZMmSSm7VEYOX1eWIldggPHK
         HFNz4MMdvAZx6FHeIQI8qf4Fnl+5Co0qpVjjxqDua702J5F035Y3CY26WmYkcFq3kNx2
         FLov4N6zbAZ8Z2SNdKHMHjruelv3ReKHaw8bZd++LBYlTfbB+NttnEQ/qem9wZa5ZBLJ
         ZY1PL7VD37nMNmMu1DoFdamG+mvf8SkL0Gd3+JYit73RgSEKOmS9B43ushKUppGcmWwy
         pdCg==
X-Gm-Message-State: AOJu0YweWNwUxq/5b3kXqXtjarONRT2XWCefv+l61qp4exPx5Fl+x0HU
	TXeGrOWpOrGMyL8uneAn7ENr3ivT1lI=
X-Google-Smtp-Source: AGHT+IGLkxH4sNOcvfoAui6Ma2VTVQiLV5xCvAMws96y7VjkfHFnbrmf7s5kJj1FZo4uuGY9VtISRDLFkkM=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a05:690c:3588:b0:58d:4ff2:58c with SMTP id
 fr8-20020a05690c358800b0058d4ff2058cmr22549ywb.1.1692419997257; Fri, 18 Aug
 2023 21:39:57 -0700 (PDT)
Date: Fri, 18 Aug 2023 21:39:43 -0700
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.42.0.rc1.204.g551eb34607-goog
Message-ID: <20230819043947.4100985-1-reijiw@google.com>
Subject: [PATCH v3 0/4] KVM: arm64: PMU: Fix PMUver related handling of vPMU support
From: Reiji Watanabe <reijiw@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Jing Zhang <jingzhangos@google.com>, Raghavendra Rao Anata <rananta@google.com>, 
	Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"

This series fixes a couple of PMUver related handling of
vPMU support.

On systems where the PMUVer is not uniform across all PEs,
KVM currently does not advertise PMUv3 to the guest,
even if userspace successfully runs KVM_ARM_VCPU_INIT with
KVM_ARM_VCPU_PMU_V3.

The patch-1 will address this inconsistent behavior by
disallowing userspace from configuring vPMU,
as such systems would be extremely uncommon and unlikely
to even use KVM (according to Marc [1]).

The patch-2 will fix improper use of the host's PMUver to
determine a valid range of PMU events for the guest (the
guest's PMUver should be used instead).

The patch-3 and patch-4 will try to hide the STALL_SLOT*
events unconditionally per Oliver's suggestion [2].
Presently, KVM hides the STALL_SLOT event depending on the
host PMU version, instead of the guest's PMU version, which
doesn't seem to be accurate, as it appears that older PMU than
PMUv3p4 could implement the event according to the Arm ARM.
Exposing the STALL_SLOT event without PMMIR_EL1 (supported
from PMUv3p4) for the guest won't be very useful though.
The patch-3 stops advertising the event for guest unconditionally,
rather than fixing or keeping the inaccurate checking to advertise
the event for the case, where it is not very useful.
The patch-4 stops advertising the STALL_SLOT_{FRONT,BACK}END
events to the guest, similar to the STALL_SLOT event, as when any
of these three events are implemented, all three of them should
be implemented, according to the Arm ARM.

This series is based on 6.5-rc6.

v3:
 - Fixed to not insert the host PMU instance in the list of valid
   PMUs [Oliver]

v2: https://lore.kernel.org/all/20230728181907.1759513-1-reijiw@google.com/
 - Combined a two separate v1 series
 - Disallow STALL_SLOT* event unconditionally [Oliver]

v1: https://lore.kernel.org/all/20230610061520.3026530-1-reijiw@google.com/
    https://lore.kernel.org/all/20230610194510.4146549-1-reijiw@google.com/

[1] https://lore.kernel.org/all/874jnqp73o.wl-maz@kernel.org/
[2] https://lore.kernel.org/all/ZIm1kdFBfXYMdfbV@linux.dev/

Reiji Watanabe (4):
  KVM: arm64: PMU: Disallow vPMU on non-uniform PMUVer
  KVM: arm64: PMU: Avoid inappropriate use of host's PMUVer
  KVM: arm64: PMU: Don't advertise the STALL_SLOT event
  KVM: arm64: PMU: Don't advertise STALL_SLOT_{FRONTEND,BACKEND}

 arch/arm64/kvm/pmu-emul.c | 37 ++++++++++++++++++++++++++-----------
 1 file changed, 26 insertions(+), 11 deletions(-)


base-commit: 2ccdd1b13c591d306f0401d98dedc4bdcd02b421
-- 
2.42.0.rc1.204.g551eb34607-goog

