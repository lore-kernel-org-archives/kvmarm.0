Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBE761FC1
	for <kvmarm@lists.linux.dev>; Wed, 19 Jul 2023 15:06:42 +0000 (UTC)
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-cf70b25bec1so458881276.3
        for <kvmarm@lists.linux.dev>; Wed, 19 Jul 2023 08:06:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689779202; x=1690384002;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=eBIhzWfDS+UF35slzZBaGQv35ttbn9DL2xgC+Ekb+iQ=;
        b=IlGZPX5F4SSdyFnDJtp36bcl6o7wvow7cHpDq0et6kecKltHa/FzES8Fi8MDnph9ox
         QWHhwAqzLbgbdEpW3DxIZtS3t6ke4allTLDYG1uBiXX9mdwM2y9LV4iElZiyN/AlJhGw
         8+nPgIJSBxz886OZq/48cD1WTjD2w08p8IsUtj1tIhbXlkOqO65leXl7E2+vxmvJUKQv
         qoRK5RtiLdEHZbs5StSAfhBfXveYgUNpRZK5yZjSTEIihrLjh9RaVX2ScgaF5rUPtWQh
         zw2Zm/Od0EcAuCssAnxAJsyoovhSqdxlS0Fu+UFi363v2TyuWdS712WjUYGZ7UwDUgt9
         Zu1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689779202; x=1690384002;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eBIhzWfDS+UF35slzZBaGQv35ttbn9DL2xgC+Ekb+iQ=;
        b=NahOiYgf0y8obiTfPgQirvmT2lf9tKAgph0QKqoGcK1AXMGBbKALpuBML7CkIFDJwl
         xlkpJDubfxbZb+B9RQWe7l3po2ziF6AeA0HZVP0wxB0blpcR1sMJrQXH/astAqpZuIS4
         zL7GvKfBq/BjMlIYewRDArqgXC1fUbWvsLWBc8okDiFuJdZW3SfQo7I4Wt6wa612HCLg
         5XHLwia3c7MUFyEt+bTDtsco6GKYQnz/gfnx6fnMW9QYsWB+lgznLirZiFxvM8C6L++u
         l710zrDLfeB+uCvjTY5bVd8sGRLEOQnOxw1/DvBJ/uUQKQeNvwjdWY1pPMtt39zOdmSO
         E+qA==
X-Gm-Message-State: ABy/qLa47ViCrKsuk38F0X/9eokH/hINE5L+B+ktn4MLC9QI+BcZ9Kyt
	2iwvF8QRQl20oXcmzNj0fchpaEDRiMY9NAlxt/Eo75ui4y9fRuWs0TQBb96GyBjq2ulzXrvo+/t
	v1Vu8ou2eLNPExKlcau3kZwAOdWETYNd/vreAGsIGiJkJ+c/tk/16Dl/NKyw=
X-Google-Smtp-Source: APBJJlEnpyER6hasefyardCvdGyJFKFkgPt6JYKN68YOsv9RGWEbjPakhns/+sjGbVIEhAIyuRR5WDxmKg==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a5b:b03:0:b0:c5e:9e7e:4847 with SMTP id
 z3-20020a5b0b03000000b00c5e9e7e4847mr24956ybp.5.1689779201652; Wed, 19 Jul
 2023 08:06:41 -0700 (PDT)
Date: Wed, 19 Jul 2023 16:06:34 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.255.g8b1d071c50-goog
Message-ID: <20230719150639.1968034-1-tabba@google.com>
Subject: [PATCH v1 0/5] Fix setting SVE and SME traps in (h)VHE
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, oliver.upton@linux.dev, catalin.marinas@arm.com, 
	james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	will@kernel.org, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

The (re)setting and disabling of SVE/SME trap handling (mostly)
done for the hVHE work [*] misses a couple of cases.

This patch series ensures that these traps are disabled on setup
and reset. Moreover, it makes the code consistent in using
CPACR_EL1 or CPTR_EL2, depending on the mode.

Based on Linux 6.5-rc2.

Cheers,
/fuad

[*] https://lore.kernel.org/all/20230609162200.2024064-1-maz@kernel.org/

Fuad Tabba (5):
  KVM: arm64: Use the appropriate feature trap register for SVE at EL2
    setup
  KVM: arm64: Disable SME Traps for (h)VHE at setup
  KVM: arm64: Use the appropriate feature trap register when activating
    traps
  KVM: arm64: Fix resetting SVE trap values on reset for hVHE
  KVM: arm64: Fix resetting SME trap values on reset for (h)VHE

 arch/arm64/include/asm/el2_setup.h   | 27 +++++++++++++++++++++------
 arch/arm64/include/asm/kvm_emulate.h |  8 ++++++++
 arch/arm64/kvm/hyp/nvhe/switch.c     |  6 +++++-
 3 files changed, 34 insertions(+), 7 deletions(-)


base-commit: fdf0eaf11452d72945af31804e2a1048ee1b574c
-- 
2.41.0.255.g8b1d071c50-goog

