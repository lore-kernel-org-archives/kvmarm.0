Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8338E4C1
	for <kvmarm@lists.linux.dev>; Fri, 10 Mar 2023 22:14:17 +0000 (UTC)
Received: by mail-pj1-f73.google.com with SMTP id in10-20020a17090b438a00b002376d8554eeso3291650pjb.1
        for <kvmarm@lists.linux.dev>; Fri, 10 Mar 2023 14:14:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678486457;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=o66EQfRmNxj+8F9jQg6/TZSeZfgO5WRCRyYyFHjsDdI=;
        b=TwMa3uXaJ/UYaq3eCVBhXdLLTBKJpqP7TapiMeVQQ8a9a3fdYAN7ttsg4P9jfrrsF8
         xUjcebWBSQqB34rXHC0GsJgb1rwQ6lGUXUSHYihGJrvHCayz5tkQgedJ3V9G985l6OXN
         fUDafN+8jo+SAVLa6b+gsNsVwmwUKOcRmGUdY280AwstjVC+S/SC22eMPXAcqRRdEU77
         wBIRL/FBFCnTfA7H48+xC+vGrenXEb1/X4N5KKU2IiVLQlyYMquH2BwZEhy/6xVYAYww
         Vy7lCsYX1/GGHaVWVEedLosBE0844f0lEyS14Z1tJajmZbl+IAjkU2lZwqMvnW0aop6L
         Qd3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678486457;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=o66EQfRmNxj+8F9jQg6/TZSeZfgO5WRCRyYyFHjsDdI=;
        b=JgCjzqtRIUndtNbpefjY1PiAKk98cGINiuxz6A6WLwY7+jMEgmqK6AIv7J7RX6SSG3
         qPHsSNMO7uYFcmhupni14tSlZBez6Vbiqpzd8dwz3qwigk6fMWwjaizVFP6MPOG3JrQz
         cAUmCwllb6RGEYsnRb32rDkCi9pHWHQW5Umbdldgxw0MG/7E1EMC/B6CLETclgXv4p/v
         WiT4Gou2jO52+xLJIgAAOg6mgUs2M5mDvkInKr3x8Yo7SvocBsFCvXa52xthD+h+vt/7
         xHmI/RxkIqE3HdyqE/q+m5gh3wqzPGuO5PrrdDB5U5kslJaGR3y7G+TyR0f8cuze0vSq
         1k/w==
X-Gm-Message-State: AO0yUKUuBH2xlu1AhTPLuCMkOczrTWwVXJa6evcK1BHxEZuUEiT98rTc
	hFxl8/jpRWLi0WyJOIFQfd/jT5ZOymQ=
X-Google-Smtp-Source: AK7set805goRIsvSnul2pFSt3XcMbMwyPEPkZcFMUxZ30t6oqEBqPbhDmjMy4wuRS+A0hc3zwjCrmOjJRYw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:dacc:b0:19a:6b55:a44d with SMTP id
 q12-20020a170902dacc00b0019a6b55a44dmr1555083plx.1.1678486456993; Fri, 10 Mar
 2023 14:14:16 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 10 Mar 2023 14:14:12 -0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
Message-ID: <20230310221414.811690-1-seanjc@google.com>
Subject: [PATCH 0/2] KVM: Fix race between reboot and hardware enabling
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev, 
	Huacai Chen <chenhuacai@kernel.org>, 
	Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, kvm-riscv@lists.infradead.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Fix a bug where enabling hardware virtualization can race with a forced
reboot, e.g. `reboot -f`, and result in virt hardware being enabled when
the reboot is attempted, and thus hanging the reboot.

Found by inspection, confirmed by hacking the reboot flow to wait until
KVM loads (the problematic window is ridiculously small).

Tested only on x86, though there would have to be some seriously subtle
arch and/or driver code for this to break other architectures.

Sean Christopherson (2):
  KVM: Use syscore_ops instead of reboot_notifier to hook
    restart/shutdown
  KVM: Don't enable hardware after a restart/shutdown is initiated

 virt/kvm/kvm_main.c | 31 +++++++++++++++++++------------
 1 file changed, 19 insertions(+), 12 deletions(-)


base-commit: 45dd9bc75d9adc9483f0c7d662ba6e73ed698a0b
-- 
2.40.0.rc1.284.g88254d51c5-goog

