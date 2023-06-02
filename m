Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E6631C758
	for <kvmarm@lists.linux.dev>; Fri,  2 Jun 2023 16:09:39 +0000 (UTC)
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-56552a72cfbso33353427b3.3
        for <kvmarm@lists.linux.dev>; Fri, 02 Jun 2023 09:09:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685722178; x=1688314178;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=NyrihgmYesBmBKLp4ITVdJ3LGNh6LVDPlJHbJ3BWmKo=;
        b=6JvB68luEiFeoyKEfjP/g+vMwC/sRddTQaYllS5g+5bpQDmhXIgwwZiHHiYhNY6/hh
         +N3LQSiNtnyna/XZaiM18ivCXXQ4yuX/15A1AGZwy0Qa/f1hIAf3oKXB2h5AuHkYQgCs
         xj8Y82H0f8TZvkTqQ0Hx5MWBndbNiI7NCzZ3czEuYGWHs7LAUCirzskxbkVOl+noMZFx
         tm27fSCTKAwfbeEstcfEbI/nW6D9qAihf0lb2MdszgnmyhfNayDhGNG1boLJ+W+UNY9A
         PKxN0bCcFoMuNsJAFUnK+mzP9snrdOrZPjuzoVjhjXEuIkdNPWm6zU7rdhcbdNuxMxHK
         DaOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685722178; x=1688314178;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NyrihgmYesBmBKLp4ITVdJ3LGNh6LVDPlJHbJ3BWmKo=;
        b=M0evK5XNUndE/UmDeXW9zGO7hmEk80rrAduJ78jCIELKx1TCH4R7YNl6PvmYEQlDNP
         Vz8Zc40hjoAaQkeiyAAjIKO5hS3NdhQ06wIA23z7tchOQW2YKemg4J0iOqu+6v3e/0be
         61zJt9bh7/tNzzOreTAdtevyqx1d4iea3NlvXnSav+AHrrZQhZy+qj1E9Kcw3PBIV/Vs
         jJ6lau1m6XAo5Y43kfeCy1TYgRinUFj6fKI4qbB+jEeghQQ0qjBtmf/bmmSWJIsuusi+
         /4ZvKHKR5vk7csGIzJrQtg0Uy4fxHAOn1zX5k542d7oOslS39UIkHFEGrUZPMvwSZ1b8
         UQMQ==
X-Gm-Message-State: AC+VfDyNrpBWsWhR2Phk9+nJh8RAR6LWMftcbwJnomj96S2684qp/dt5
	7qS4NbtC6ADFmN0GSVQjto5jWHPlL0M2
X-Google-Smtp-Source: ACHHUZ7z74Jy0Y96qFW+7u40ZiTgX4ucCC/5bWAvnbf5ZGF1cU7Xjv0z02cQ2QpbWgJAAII5qTnOdyVeR9zk
X-Received: from vipin.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:479f])
 (user=vipinsh job=sendgmr) by 2002:a81:b620:0:b0:561:b8d1:743b with SMTP id
 u32-20020a81b620000000b00561b8d1743bmr170869ywh.10.1685722178126; Fri, 02 Jun
 2023 09:09:38 -0700 (PDT)
Date: Fri,  2 Jun 2023 09:09:07 -0700
In-Reply-To: <20230602160914.4011728-1-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230602160914.4011728-1-vipinsh@google.com>
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230602160914.4011728-10-vipinsh@google.com>
Subject: [PATCH v2 09/16] KVM: arm64: Document the page table walker actions
 based on the callback's return value
From: Vipin Sharma <vipinsh@google.com>
To: maz@kernel.org, oliver.upton@linux.dev, james.morse@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, chenhuacai@kernel.org, aleksandar.qemu.devel@gmail.com, 
	tsbogend@alpha.franken.de, anup@brainfault.org, atishp@atishpatra.org, 
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	seanjc@google.com, pbonzini@redhat.com, dmatlack@google.com, 
	ricarkol@google.com
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kselftest@vger.kernel.org, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"

Document what the page table walker do when walker callback function returns
a value.

Current documentation is not correct as negative error of -EAGAIN on a
non-shared page table walker doesn't terminate the walker and continues
to the next step.

There might be a better place to keep this information, for now this
documentation will work as a reference guide until a better way is
found.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 arch/arm64/include/asm/kvm_pgtable.h | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 8ef7e8f3f054..957bc20dab00 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -711,8 +711,19 @@ int kvm_pgtable_stage2_split(struct kvm_pgtable *pgt, u64 addr, u64 size,
  * after invoking the walker callback, allowing the walker to descend into
  * a newly installed table.
  *
- * Returning a negative error code from the walker callback function will
- * terminate the walk immediately with the same error code.
+ * Depending on the return value from the walker callback function, the page
+ * table walk will continue or exit the walk. This is also dependent on the
+ * type of the walker, i.e. shared walker (vCPU fault handlers) or non-shared
+ * walker.
+ *
+ * Walker Type  | Callback         | Walker action
+ * -------------|------------------|--------------
+ * Non-Shared   | 0                | Continue
+ * Non-Shared   | -EAGAIN          | Continue
+ * Non-Shared   | Any other        | Exit
+ * -------------|------------------|--------------
+ * Shared       | 0                | Continue
+ * Shared       | Any other        | Exit
  *
  * Return: 0 on success, negative error code on failure.
  */
-- 
2.41.0.rc0.172.g3f132b7071-goog

