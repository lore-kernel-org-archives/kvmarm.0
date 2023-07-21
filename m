Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E637F14F98
	for <kvmarm@lists.linux.dev>; Fri, 21 Jul 2023 09:51:48 +0000 (UTC)
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-31443e13f9dso949373f8f.0
        for <kvmarm@lists.linux.dev>; Fri, 21 Jul 2023 02:51:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689933107; x=1690537907;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=NaXLo/zDYfyK07ytwfnmz28uaau/n3v4DANqqhj2aBk=;
        b=1OnrV2BSusRm8WkVl0YxJVXLGJrimZEnEyDUc6CazxXh+tXYNvsnmWltLobUX8YDy9
         bmPjvHgdcMGB1tn+VySp4oOXq/3XtAP0jsOSMQHGWdNqPAJa+Ay3X47fv6ZDHsoHeW+i
         oTOtwIZ6szM5F0rghLI8heMr3iSsf7V22lNDOscPrMdH48bEC0ILphHCSj3ngo1df9mg
         Wc9JxWLxcbcJiAGkG7znyUTP9Fyk/Foc3AGrCxWjnH5FhHHbxcU6SxVoBioA1yjfkW/l
         PVw6WJAYCvQf4BL+B7M78PZOKyVomnqNzWIdfTNKkbAT61pCSO4FQtgUJRKu14RPvcyV
         Z9cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689933107; x=1690537907;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NaXLo/zDYfyK07ytwfnmz28uaau/n3v4DANqqhj2aBk=;
        b=AJoMGqQjjXTkOWskV2KaYHIknZgEvS2YUSQHUQp0gq3zKMseD1fEUQBqAMH+nFNq9H
         ry0CfCkBuibFcu0US5p48XimSF3+zD3zxf7wi4fWQb4nx25UALdCYpWqHGb8Uguo7TE6
         KFj6N5WQY4vR0EXsNbvdthlHUvv92IhCDS5QYbmtIMPMpv1tFTIhW1hq2LrIYBMJK5B3
         oz9ruFtvasTIc5qD71Sg/oxAVVzZkiGg9SwSw2T17sjcRH/l+QihKkNSeGbzNkvsomAY
         51rpmB56WWsFLH/Y7yY1a4rCVjInCNk8SNgltgs1mIMqlMGpNdUWl4zIgwBwhbdBMq73
         xOvg==
X-Gm-Message-State: ABy/qLY/wRhGGkkCmtaovaGEaDQ5ezA5a3rss0XkZ62UyohsDiBFsboM
	dFYqgmziSoY2027Pbx4BG5zUtG+jfHzHuG27GjjgOdOC+WZwKT/4HO5wqrobqWA8R+KfJJOV4Rh
	Jaw5Hx1LOOPf1/KT2klmpbqiaRvJ9v0Wi1V0lmytDkjGtlWF7HpNGUQmriXc=
X-Google-Smtp-Source: APBJJlF+5cNUU2w8w9riyhquIfq94ZeyJerlmCPBz6VnvKzlSjhuJgm6tzbbHsM01Ok5rSyCT++1rznCwg==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a5d:508e:0:b0:30f:d210:8c5a with SMTP id
 a14-20020a5d508e000000b0030fd2108c5amr8650wrt.1.1689933106628; Fri, 21 Jul
 2023 02:51:46 -0700 (PDT)
Date: Fri, 21 Jul 2023 10:51:37 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230721095144.306817-1-tabba@google.com>
Subject: [PATCH v2 0/7] Fix setting SVE and SME traps in (h)VHE
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, oliver.upton@linux.dev, catalin.marinas@arm.com, 
	james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	will@kernel.org, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Hi,

Changes from V1:
- Expanded the cover letter to clarify the reasoning behind being
consistent in writing to the architectural trap register based on
the KVM mode (Marc)
- Factored out the code for checking E2H into a macro (Oliver)
- Factored out the code that selects which register to write to
into a function (Oliver)

The (re)setting and disabling of SVE/SME trap handling (mostly)
done for the hVHE work [*] misses a couple of cases.

This patch series ensures that these traps are disabled on setup
and reset. Moreover, it makes the code consistent in using
CPACR_EL1 or CPTR_EL2, depending on the mode.

CPACR_EL1 aliases to CPTR_EL2 when HCR_EL2.E2H == 1, but by being
consistent we don't need to issue a synchronisation when
alternating between one or the other accessor. Moreover, when
running hVHE under NV, we don't trap unnecessarily on accessing
CPTR_EL2, while CPACR_EL1 can be used directly without any trap.

Based on Linux 6.5-rc2.

Cheers,
/fuad

[*] https://lore.kernel.org/all/20230609162200.2024064-1-maz@kernel.org/

Fuad Tabba (7):
  KVM: arm64: Factor out code for checking E2H into a macro
  KVM: arm64: Use the appropriate feature trap register for SVE at EL2
    setup
  KVM: arm64: Disable SME traps for (h)VHE at setup
  KVM: arm64: Helper to write to appropriate feature trap register based
    on mode
  KVM: arm64: Use the appropriate feature trap register when activating
    traps
  KVM: arm64: Fix resetting SVE trap values on reset for hVHE
  KVM: arm64: Fix resetting SME trap values on reset for (h)VHE

 arch/arm64/include/asm/el2_setup.h   | 44 ++++++++++++++++++----------
 arch/arm64/include/asm/kvm_emulate.h | 21 ++++++++++---
 arch/arm64/kvm/hyp/nvhe/switch.c     |  2 +-
 3 files changed, 47 insertions(+), 20 deletions(-)


base-commit: fdf0eaf11452d72945af31804e2a1048ee1b574c
-- 
2.41.0.487.g6d72f3e995-goog

