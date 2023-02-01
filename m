Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 533DE369
	for <kvmarm@lists.linux.dev>; Wed,  1 Feb 2023 10:38:01 +0000 (UTC)
Received: by mail-wm1-f74.google.com with SMTP id h9-20020a1ccc09000000b003db1c488826so857190wmb.3
        for <kvmarm@lists.linux.dev>; Wed, 01 Feb 2023 02:38:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=s4zWblSgk9sC59/aeD2C4zXhl1NkdUvsWjCEZ+kae5w=;
        b=kDd5sNOxRKfGTyQyrwC8Z9FLlQkrpsj/Nng2DTWB6IJUir3WQndNIexufILUN++wdV
         JDwcGHttIbcRuSGZu7j9qulGqGELbopzYZ3m8BIvsoLl5QqurHIf6HGUOy+1AH4o06Ba
         VNDrWbdJVT7ESS5kjdleefmF0NLuB3WcOoOJtsonsWVaNaBJDrHQTAgCuYmv5i/ph5Zl
         UR2zJtbSKKV85ivzBHyqklZSKeSB/QSPrTRbPWkBl7+94vRWUCwYOn/R+g7PNWGcQH08
         xrRKBM3IyQbvObsc3VmNRqTfnUlUIxxqTU0sIC/IIuFBnorDytqD1S3czSqHoRXsHpoc
         XzaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=s4zWblSgk9sC59/aeD2C4zXhl1NkdUvsWjCEZ+kae5w=;
        b=jH+y1+b2EYrQKOyChFA2GZAe0aBVopz8juW/Kjck5YzkYtNXt2A+wQdaoFjo6hgvdD
         F3M4K/Ef8WwDMIqwByTzAHCMXfOL/0QzV6VU2zBGm875s8SZ3WGMjK9TfP+vX8c4vcyz
         T7lo6Z4hJ4iwArQqbGq6WxT9o+AtBfwghNxycPW2fn+t1FasNKosjFxMy2l7OSzEF4z9
         T8lQV+VKLWUyq5cxtxfxUc4SX52OfubJsjtY+Wdr6UrA7ScILOqDjPoeMvVll3T7HQ2A
         daRwXN7aGPMrKYm579HpaXgPJW6xLRet/yi6xUz19VyxmgFF7xzW2uMjC5hTgMzKNg/i
         Ad5A==
X-Gm-Message-State: AO0yUKUlWL+OsjNR3+UShyHus9y1UkXeeOWBk3necRhY+MgJhtl0uOUO
	I0aXhhRWaRViIcOlDglQujnMWkfupoJg
X-Google-Smtp-Source: AK7set9OO31MOIG5ytUAh8LFORGHH4kWKzwK1XEnu8LH1geO7NiaHrTAAjdFjC0NALlJrHjXuGZHsPmGikuT
X-Received: from big-boi.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:129])
 (user=qperret job=sendgmr) by 2002:a05:600c:170a:b0:3dc:5240:a87b with SMTP
 id c10-20020a05600c170a00b003dc5240a87bmr145717wmn.12.1675247879605; Wed, 01
 Feb 2023 02:37:59 -0800 (PST)
Date: Wed,  1 Feb 2023 10:37:50 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.1.456.gfc5497dd1b-goog
Message-ID: <20230201103755.1398086-1-qperret@google.com>
Subject: [PATCH 0/4] KVM: arm64: Fix CPU resume/on with pKVM
From: Quentin Perret <qperret@google.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Zenghui Yu <yuzenghui@huawei.com>, Mark Brown <broonie@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu, kernel-team@android.com, 
	Quentin Perret <qperret@google.com>
Content-Type: text/plain; charset="UTF-8"

When using pKVM, we do not reset the EL2 exception vectors back to the
stubs for e.g. Power Management or CPU hotplug as we normally do in KVM.
As consequence, the initialisation perfomed by __finalise_el2 is missing
on e.g. the CPU_RESUME path with pKVM, hence leaving certain registers
in an incorrect state.

One such example is ZCR_EL2 which remains configured with SVE traps
enabled. And so using SVE on a CPU that has gone through a hotplug
off/on cycle leads to a hyp panic. Not good.

This series fixes this by macroizing the first half of __finalise_el2
(that is, the part that is not specific to VHE) to allow its re-use
from pKVM's PSCI relay.

Quentin Perret (4):
  KVM: arm64: Provide sanitized SYS_ID_AA64SMFR0_EL1 to nVHE
  KVM: arm64: Introduce finalise_el2_state macro
  KVM: arm64: Use sanitized values in __check_override in nVHE
  KVM: arm64: Finalise EL2 state from pKVM PSCI relay

 arch/arm64/include/asm/el2_setup.h | 92 ++++++++++++++++++++++++++++++
 arch/arm64/include/asm/kvm_hyp.h   |  1 +
 arch/arm64/kernel/hyp-stub.S       | 79 +------------------------
 arch/arm64/kvm/arm.c               |  1 +
 arch/arm64/kvm/hyp/nvhe/hyp-init.S |  1 +
 arch/arm64/kvm/hyp/nvhe/sys_regs.c |  1 +
 6 files changed, 98 insertions(+), 77 deletions(-)

-- 
2.39.1.456.gfc5497dd1b-goog

