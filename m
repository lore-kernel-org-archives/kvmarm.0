Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BDAA15CA
	for <kvmarm@lists.linux.dev>; Mon, 13 Mar 2023 03:30:24 +0000 (UTC)
Received: by mail-pf1-f202.google.com with SMTP id x15-20020a056a000bcf00b0062436f133c1so988814pfu.1
        for <kvmarm@lists.linux.dev>; Sun, 12 Mar 2023 20:30:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678678224;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=SdlPWktROsh+JmiviRgnNdVxeIIiPFplxaQO79O6Ksw=;
        b=qScfWVRHtaNZ7LeoilFi7KVFQvfj43FymK5EnBRDSXjBmUm8JlatP9MRZ64qcejuLs
         XjA/8aKDew9t3Y4rRzL1Y3CsHlQC044bLOfeJpafYcgptPgqGAl0dCIWR5Na2kzN4jjw
         mUGTFwbyUpbno31gPjx4teUokKWQmaHTEHkjPGY6/kN5/KU1jIDLN1tSLLcedvR7biMn
         NDpB3sQh+hWtvRr81AyGceLKKshSMcNhlbUCvNmcXgXyknyICmNYe+sakKSgs2zYUPUa
         Hc4Zh4O5Q/VExhRDjA1KE7/bxKWxfjIQ3pKMVWwBBwSQW299zecsEtI3z8VmE9ZIKmYJ
         U+Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678678224;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SdlPWktROsh+JmiviRgnNdVxeIIiPFplxaQO79O6Ksw=;
        b=uk0hxDk+4nplXNkTlDK8kXgNnv8f7idVBstxfeOHzYMhBWv9STfGMCr9Dxfqx6AUvy
         7R2tMThaWnz52InLNf+6LRd4DflTwO9qdl01vHOpOANbfR9HrbhcET/IGCl0ES1OnHg+
         7FqgmfDc+9LUjYxEzvdsZIB5U2hIZQTN7ix3g9jftJ9ZI8qByPGtKOCeYytso0Dm1KgS
         TZWmcnfjd5p+t3BjzsCwMUIRpWKkfVlNiTYvebXvb/ZGcgZCYkhorPicex00r0Q0/msG
         jgXY7HSnhQ+v51fEXu1IsIpkrRyNYaF6+81o75/9aw54T40oWOQ3vi+rO8UmGNtHvFQw
         Jv2g==
X-Gm-Message-State: AO0yUKVROF0Tvwx9LFY/SdUIrAQnUyoq10nqUU6Q4ruSFDC0NbX10Bqw
	30QDu9ik2/LnxJds6bHw0Jv/BGPMKL0=
X-Google-Smtp-Source: AK7set+gdEoQhj3SJOTWehpvE/gjAq+U6uimdq+vWRo8HEF76CvzRWY0PsNw6/QMUrCk/0uJgQ7FfVNmZ6I=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a17:90a:420b:b0:237:29b1:188f with SMTP id
 o11-20020a17090a420b00b0023729b1188fmr11930655pjg.8.1678678224493; Sun, 12
 Mar 2023 20:30:24 -0700 (PDT)
Date: Sun, 12 Mar 2023 20:29:03 -0700
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
Message-ID: <20230313032905.1474705-1-reijiw@google.com>
Subject: [PATCH v2 0/2] KVM: arm64: PMU: Preserve vPMC registers properly on migration
From: Reiji Watanabe <reijiw@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Ricardo Koller <ricarkol@google.com>, 
	Jing Zhang <jingzhangos@google.com>, Raghavendra Rao Anata <rananta@google.com>, 
	Will Deacon <will@kernel.org>, Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"

The series fixes two problems in preserving vPMU counter (vPMC)
registers (PMCCNTR_EL0/PMEVCNTR<n>_EL0) during migration.

One of the problems is that KVM may not return the current values
of the vPMC registers for KVM_GET_ONE_REG.

The other one might cause KVM to reset the vPMC registers on the
first KVM_RUN on the destination. This is because userspace might
save PMCR_EL0 with PMCR_EL0.{C,P} bits set on the source, and
restore it on the destination.

See patch-1 and patch-2 for details on these issues respectively.

The series is based on v6.3-rc2.

v2:
 - Collect Marc's r-b tags (Thank you!)
 - Added "Fixes:" tags
 - Added Cc: to stable
 - Cosmetics change (remove one line break in kvm_pmu_handle_pmcr())

v1: https://lore.kernel.org/all/20230302055033.3081456-1-reijiw@google.com/

Reiji Watanabe (2):
  KVM: arm64: PMU: Fix GET_ONE_REG for vPMC regs to return the current
    value
  KVM: arm64: PMU: Don't save PMCR_EL0.{C,P} for the vCPU

 arch/arm64/kvm/pmu-emul.c |  3 ++-
 arch/arm64/kvm/sys_regs.c | 21 +++++++++++++++++++--
 2 files changed, 21 insertions(+), 3 deletions(-)


base-commit: eeac8ede17557680855031c6f305ece2378af326
-- 
2.40.0.rc1.284.g88254d51c5-goog

