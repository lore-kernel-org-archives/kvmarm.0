Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5202F7F0
	for <kvmarm@lists.linux.dev>; Fri, 12 May 2023 23:31:30 +0000 (UTC)
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-6434307a64bso10633387b3a.2
        for <kvmarm@lists.linux.dev>; Fri, 12 May 2023 16:31:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683934289; x=1686526289;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LOZreDabNqpUj7u+V8APqRqu4TK74uLHH24UEDNUCHI=;
        b=Zja9mH7oY+lw1E5/US7t2dlayN3yjG5xJZYmUi1MDWPsxw2Sy/jDu9vsw5olTvhSNd
         QCgQkjoYs8efeFbYFt87WjqxowUr6XJhvHeiVn9eyKykCmOnrNkC55/LgY0EDQKPJWim
         a6bM36P7UC21fS6BS4B6XHLZIivgPIeib0cLg0JTtNa1n0cX/fMBHSQHX3dvNKG/WG8t
         7N6LK6oLs/SBnJzm/i9BkS6O236X4516CUCogNmtvONYwYxdHDnwbvIqcgYmEUafFWKk
         UvqFOltbKLn9ANbffrpoouV/QgP0kXGjj8DMEuk7Yewe9MtzPew9TLs8tss9e/tpkpqd
         7WPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683934289; x=1686526289;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LOZreDabNqpUj7u+V8APqRqu4TK74uLHH24UEDNUCHI=;
        b=cJ4SCQ4il0w1SdBApD9/DJjowl9DCbi0mfrTkJIUuoa99h2DEM0TNMOWKB5O5eZW04
         Q9DvoGaZoTb3pmJzlu1IWUa++vBjYjOToCE/5XRdDhdnlzIxFGglZY0RDDJ5KtNeE97c
         2eg2Vpdxqci2A4fHusB09e2KAR6/yWwrgrZKqwZ4N39n3jESFdZ3DnBTJ9RYeu2fgPGR
         Ez019zlIfLfhKeWr8fU0+GFboXHMqm+n4V0d+ONeYX50yWyl4eMHBln3sKHK2Ue8nZX+
         O2MoSlWlrLmB1vkYYJH6bFernyktTfLlXwOCQxEowT7N+vjxNFuZHbK5Ful6ZWIk//hz
         ULVQ==
X-Gm-Message-State: AC+VfDzKPQ/0kDrBsH2rBR0ly7aqO+rHLBgMwjgS+zBOPEsPTLxsDd4/
	t7SF8ajVq4R5R5fmawi/kcW8agK91JQ=
X-Google-Smtp-Source: ACHHUZ4+wXYsC9AiEzl5m7UK3UfElGCg0UgJLKMd3X0fuTu7gvDDXKM0VCK/mWN3zQh5HT0lfa6pt+xxtg8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:d42:b0:643:a029:5b3f with SMTP id
 n2-20020a056a000d4200b00643a0295b3fmr6979951pfv.2.1683934289733; Fri, 12 May
 2023 16:31:29 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 12 May 2023 16:31:25 -0700
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.1.606.ga4b1b128d6-goog
Message-ID: <20230512233127.804012-1-seanjc@google.com>
Subject: [PATCH v2 0/2] KVM: Fix race between reboot and hardware enabling
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

Fully tested only on x86, compile tested on other architectures.

v2:
 - Rename KVM's callback to kvm_shutdown() to match the hook. [Marc]
 - Don't add a spurious newline. [Marc]

v1: https://lore.kernel.org/all/20230310221414.811690-1-seanjc@google.com

Sean Christopherson (2):
  KVM: Use syscore_ops instead of reboot_notifier to hook
    restart/shutdown
  KVM: Don't enable hardware after a restart/shutdown is initiated

 virt/kvm/kvm_main.c | 43 +++++++++++++++++++++++++++----------------
 1 file changed, 27 insertions(+), 16 deletions(-)


base-commit: b3c98052d46948a8d65d2778c7f306ff38366aac
-- 
2.40.1.606.ga4b1b128d6-goog

