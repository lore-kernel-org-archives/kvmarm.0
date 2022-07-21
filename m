Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E082CCA479
	for <kvmarm@archiver.kernel.org>; Thu, 21 Jul 2022 09:58:48 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 208424C91D;
	Thu, 21 Jul 2022 05:58:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ubLsetmvqskO; Thu, 21 Jul 2022 05:58:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E0B474C930;
	Thu, 21 Jul 2022 05:58:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 350DC4C91B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jul 2022 05:58:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3ul+t4T77DYr for <kvmarm@lists.cs.columbia.edu>;
 Thu, 21 Jul 2022 05:58:45 -0400 (EDT)
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com
 [209.85.208.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F24354C90E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jul 2022 05:58:44 -0400 (EDT)
Received: by mail-ed1-f43.google.com with SMTP id m13so1491610edc.5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jul 2022 02:58:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=AERHviI4+0lw5BuAPlcVYCLTAkZUrRuqNMfCTEsNzwA=;
 b=IR6NulFxPs9l1r3DCpl0GsssXvQTjDkW96EKXvU5yfQ1DuHCOFid3C9fRUblWfinVN
 jkvwy1uGlqg3qi1PwdrEdMPqIL3ytQH2v0fHrO5119cVr6AboHr/9ipOsvIIy0ywQHCV
 cGfTR/4mknReSjL2XtzUhWNhs/5mBjOHIP41w6fFXI5HJ+HkL3kaFjoIEBDQOoR+pRAi
 dw9YmlE8NGbcSxgBt3tpMHWpqOm0PxJBC2m0cuKVU5YYdeUYcz2k0ibc2APu9p092jI6
 q282U60M68ovgG6MLOJkrDogSHMg7/8e9leob//39z5sF9nva4vx2dWLM7ldCfXqQNVv
 ZdyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=AERHviI4+0lw5BuAPlcVYCLTAkZUrRuqNMfCTEsNzwA=;
 b=htZstWhONGKO6wPlNUH9FTIg2HPBpYId+BBky/Xau39p2kVfI1teUGvLv2ux5CbDQp
 u3SOCs8CXuEuuZA/sPchyANA3I8QtVsctwchoDIZ+eUPmueqvNKnsOiKd25gBIkhaZtP
 a5bzdqTjqfrEomG37KF7K4a4XEV8P2Xp5i5bA0vZZ2mIgPrjOh2m7CPhsyONyPXrHgDE
 C0nacEIVLJAkxvh67SDSXoPI+AmmqlER21JoSdyngDv5W8lPCS9Tn/QSMarLoJ9Ts2Yp
 5pzGEmJLUr3dWKOuAcC9sKYCTXJ+El+PPr3gfTXELX8riZTODNHzmomXDv0+OFD492S1
 j7qw==
X-Gm-Message-State: AJIora+oGqGTt09oqK5oJP7UZB0rm8ehBqH3BZ4ChGNttmYd3pC7J924
 qnT/BNLgey2Pk9f5spwQNd/xE6hNBLboEsrS9KRnPw==
X-Google-Smtp-Source: AGRyM1swg11Ki2871ymoOzicSCKaS/ZXXCwRw72mjD6HJVcQJ4xYR7fgViWJ5PqxZxzOVd77ydBJeAMS/hAwpybi8bM=
X-Received: by 2002:aa7:cd86:0:b0:43a:26e3:d333 with SMTP id
 x6-20020aa7cd86000000b0043a26e3d333mr56365170edv.178.1658397523919; Thu, 21
 Jul 2022 02:58:43 -0700 (PDT)
MIME-Version: 1.0
References: <20220721055728.718573-1-kaleshsingh@google.com>
 <20220721055728.718573-11-kaleshsingh@google.com>
In-Reply-To: <20220721055728.718573-11-kaleshsingh@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 21 Jul 2022 10:58:04 +0100
Message-ID: <CA+EHjTxJoaeSom51fGZCtFdOo0D16GYC_QUuQ26jLKgo_pfEFw@mail.gmail.com>
Subject: Re: [PATCH v5 10/17] KVM: arm64: Stub implementation of pKVM HYP
 stack unwinder
To: Kalesh Singh <kaleshsingh@google.com>
Cc: wangkefeng.wang@huawei.com, catalin.marinas@arm.com, ast@kernel.org,
 vincenzo.frascino@arm.com, will@kernel.org, kvmarm@lists.cs.columbia.edu,
 maz@kernel.org, madvenka@linux.microsoft.com, kernel-team@android.com,
 elver@google.com, broonie@kernel.org, linux-arm-kernel@lists.infradead.org,
 andreyknvl@gmail.com, linux-kernel@vger.kernel.org, mhiramat@kernel.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Kalesh,

On Thu, Jul 21, 2022 at 6:57 AM Kalesh Singh <kaleshsingh@google.com> wrote:
>
> Add some stub implementations of protected nVHE stack unwinder, for
> building. These are implemented later in this series.
>
> Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
> ---

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad


>
> Changes in v5:
>   - Mark unwind_next() as inline, per Marc
>
>  arch/arm64/include/asm/stacktrace/nvhe.h | 59 ++++++++++++++++++++++++
>  arch/arm64/kvm/hyp/nvhe/stacktrace.c     |  3 +-
>  2 files changed, 60 insertions(+), 2 deletions(-)
>  create mode 100644 arch/arm64/include/asm/stacktrace/nvhe.h
>
> diff --git a/arch/arm64/include/asm/stacktrace/nvhe.h b/arch/arm64/include/asm/stacktrace/nvhe.h
> new file mode 100644
> index 000000000000..80d71932afff
> --- /dev/null
> +++ b/arch/arm64/include/asm/stacktrace/nvhe.h
> @@ -0,0 +1,59 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * KVM nVHE hypervisor stack tracing support.
> + *
> + * The unwinder implementation depends on the nVHE mode:
> + *
> + *   1) pKVM (protected nVHE) mode - the host cannot directly access
> + *      the HYP memory. The stack is unwinded in EL2 and dumped to a shared
> + *      buffer where the host can read and print the stacktrace.
> + *
> + * Copyright (C) 2022 Google LLC
> + */
> +#ifndef __ASM_STACKTRACE_NVHE_H
> +#define __ASM_STACKTRACE_NVHE_H
> +
> +#include <asm/stacktrace/common.h>
> +
> +static inline bool on_accessible_stack(const struct task_struct *tsk,
> +                                      unsigned long sp, unsigned long size,
> +                                      struct stack_info *info)
> +{
> +       return false;
> +}
> +
> +#ifdef __KVM_NVHE_HYPERVISOR__
> +/*
> + * Protected nVHE HYP stack unwinder
> + *
> + * In protected mode, the unwinding is done by the hypervisor in EL2.
> + */
> +
> +#ifdef CONFIG_PROTECTED_NVHE_STACKTRACE
> +static inline bool on_overflow_stack(unsigned long sp, unsigned long size,
> +                                    struct stack_info *info)
> +{
> +       return false;
> +}
> +
> +static inline int notrace unwind_next(struct unwind_state *state)
> +{
> +       return 0;
> +}
> +NOKPROBE_SYMBOL(unwind_next);
> +#else  /* !CONFIG_PROTECTED_NVHE_STACKTRACE */
> +static inline bool on_overflow_stack(unsigned long sp, unsigned long size,
> +                                    struct stack_info *info)
> +{
> +       return false;
> +}
> +
> +static inline int notrace unwind_next(struct unwind_state *state)
> +{
> +       return 0;
> +}
> +NOKPROBE_SYMBOL(unwind_next);
> +#endif /* CONFIG_PROTECTED_NVHE_STACKTRACE */
> +
> +#endif /* __KVM_NVHE_HYPERVISOR__ */
> +#endif /* __ASM_STACKTRACE_NVHE_H */
> diff --git a/arch/arm64/kvm/hyp/nvhe/stacktrace.c b/arch/arm64/kvm/hyp/nvhe/stacktrace.c
> index 69e65b457f1c..96c8b93320eb 100644
> --- a/arch/arm64/kvm/hyp/nvhe/stacktrace.c
> +++ b/arch/arm64/kvm/hyp/nvhe/stacktrace.c
> @@ -4,8 +4,7 @@
>   *
>   * Copyright (C) 2022 Google LLC
>   */
> -#include <asm/memory.h>
> -#include <asm/percpu.h>
> +#include <asm/stacktrace/nvhe.h>
>
>  DEFINE_PER_CPU(unsigned long [OVERFLOW_STACK_SIZE/sizeof(long)], overflow_stack)
>         __aligned(16);
> --
> 2.37.0.170.g444d1eabd0-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
