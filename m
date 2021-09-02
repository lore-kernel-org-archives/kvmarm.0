Return-Path: <SRS0=/m9d=NY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19EC2C433FE
	for <kvmarm@archiver.kernel.org>; Thu,  2 Sep 2021 21:07:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8B66761074
	for <kvmarm@archiver.kernel.org>; Thu,  2 Sep 2021 21:07:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 8B66761074
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 071B14B10E;
	Thu,  2 Sep 2021 17:07:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6NmjxVvg4tJS; Thu,  2 Sep 2021 17:07:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DF8DE4B103;
	Thu,  2 Sep 2021 17:07:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3DE2F4B0BE
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Sep 2021 17:07:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9VsmLoWHkcyh for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Sep 2021 17:07:13 -0400 (EDT)
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com
 [209.85.167.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1E6EE4B0BD
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Sep 2021 17:07:13 -0400 (EDT)
Received: by mail-lf1-f53.google.com with SMTP id bq28so7214481lfb.7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 02 Sep 2021 14:07:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=XguslLdPIXxVxFmZIelMYc4XAgNZi0tFqmUYgQxOp5M=;
 b=GRl6nsj+q44z1Ha5UTrEb/YbOYWdRlaK0fubHiqDSnXS8sWWJcwTGWoDIW2UCbn6Zr
 Cin4HyfAIjK1TVjdigRZ9ja7ecjITroQf2sZC4PC79Xaz+k+vtV6XvjQXxLLGFS3Tgvd
 rZxyeNE+Shn/fy1exk3CDfTmR+G77EyuLt2WAGw8j5ATWWbDt8eRpAfxm4LgmHc7p2us
 SdVcNLtNJiQPkMgU50e+CmDwIvKnHFdoc0jTOcrwRN3F83mIHv0PA+s/3GaM1tNx243Z
 gMITCnX0rWgJVXu10k47y/pC6aRMKRjTFKL60xjdzuDoDoXohJ5vAGs0C1TJ9uxuED5z
 b2tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=XguslLdPIXxVxFmZIelMYc4XAgNZi0tFqmUYgQxOp5M=;
 b=n5nWzwtvlGF2BJo60jl15zrdIn6/2WBm6H8ArMJHfrN/tEzaPENcA7hJoxSIHdV5V6
 nxFWH2TVXuPlntYZ64wEEw3l9XM3/Ty9zHiCv8Q7pIrjDydxnQMgiEtEAnhxGWwg4Rhe
 7WKt6jWX7ku/PJqHGU2V4tQDDE3gHG2/0CBxEJaO8QBYlN7/q4WyrLlKbi7VeF7qwgEw
 4G2YmUD3l0eSGu1oy2fCApt6sFDEjuryKj5dKfIgmnx6bKQWB+oJHF0w9Bu6PrsWqk4B
 vUu4Q0T5HxMDk5CwaEnAg72roYOSiCCRJc9YgBZwrJxpad5Sbe9dW2PwKd9V17NeOVTZ
 OqTg==
X-Gm-Message-State: AOAM533Rq/c1sJB2eTCKzeIwtyoErMIZVmKJGvYbHHQMnjIYoNkifrF8
 pm3UampcHaDRiY2KvBA+MizbUhJgAGngJPf5FKg2kw==
X-Google-Smtp-Source: ABdhPJy8xnwpcjzdbh31Silho7ZsIAfWPr+R+NuwJ6UvcoeGh2m0fcJ/FCsJ2/qFTEX7zkqJV51h+rVv6z0QgWfOt/4=
X-Received: by 2002:a05:6512:6c3:: with SMTP id u3mr80050lff.411.1630616831502; 
 Thu, 02 Sep 2021 14:07:11 -0700 (PDT)
MIME-Version: 1.0
References: <20210901211412.4171835-1-rananta@google.com>
 <20210901211412.4171835-9-rananta@google.com>
In-Reply-To: <20210901211412.4171835-9-rananta@google.com>
From: Oliver Upton <oupton@google.com>
Date: Thu, 2 Sep 2021 14:06:58 -0700
Message-ID: <CAOQ_QsiYHkyDVUuUjFb5Zc=o4=yrmVEERNqt1aAY=4uy91mbgQ@mail.gmail.com>
Subject: Re: [PATCH v3 08/12] KVM: arm64: selftests: Add light-weight spinlock
 support
To: Raghavendra Rao Ananta <rananta@google.com>
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Peter Shier <pshier@google.com>,
 linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

On Wed, Sep 1, 2021 at 2:14 PM Raghavendra Rao Ananta
<rananta@google.com> wrote:
>
> Add a simpler version of spinlock support for ARM64 for
> the guests to use.
>
> The implementation is loosely based on the spinlock
> implementation in kvm-unit-tests.
>
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>  tools/testing/selftests/kvm/Makefile          |  2 +-
>  .../selftests/kvm/include/aarch64/spinlock.h  | 13 +++++++++
>  .../selftests/kvm/lib/aarch64/spinlock.c      | 27 +++++++++++++++++++
>  3 files changed, 41 insertions(+), 1 deletion(-)
>  create mode 100644 tools/testing/selftests/kvm/include/aarch64/spinlock.h
>  create mode 100644 tools/testing/selftests/kvm/lib/aarch64/spinlock.c
>
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index 5d05801ab816..61f0d376af99 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -35,7 +35,7 @@ endif
>
>  LIBKVM = lib/assert.c lib/elf.c lib/io.c lib/kvm_util.c lib/rbtree.c lib/sparsebit.c lib/test_util.c lib/guest_modes.c lib/perf_test_util.c
>  LIBKVM_x86_64 = lib/x86_64/apic.c lib/x86_64/processor.c lib/x86_64/vmx.c lib/x86_64/svm.c lib/x86_64/ucall.c lib/x86_64/handlers.S
> -LIBKVM_aarch64 = lib/aarch64/processor.c lib/aarch64/ucall.c lib/aarch64/handlers.S
> +LIBKVM_aarch64 = lib/aarch64/processor.c lib/aarch64/ucall.c lib/aarch64/handlers.S lib/aarch64/spinlock.c
>  LIBKVM_s390x = lib/s390x/processor.c lib/s390x/ucall.c lib/s390x/diag318_test_handler.c
>
>  TEST_GEN_PROGS_x86_64 = x86_64/cr4_cpuid_sync_test
> diff --git a/tools/testing/selftests/kvm/include/aarch64/spinlock.h b/tools/testing/selftests/kvm/include/aarch64/spinlock.h
> new file mode 100644
> index 000000000000..cf0984106d14
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/include/aarch64/spinlock.h
> @@ -0,0 +1,13 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +
> +#ifndef SELFTEST_KVM_ARM64_SPINLOCK_H
> +#define SELFTEST_KVM_ARM64_SPINLOCK_H
> +
> +struct spinlock {
> +       int v;
> +};
> +
> +extern void spin_lock(struct spinlock *lock);
> +extern void spin_unlock(struct spinlock *lock);
> +
> +#endif /* SELFTEST_KVM_ARM64_SPINLOCK_H */
> diff --git a/tools/testing/selftests/kvm/lib/aarch64/spinlock.c b/tools/testing/selftests/kvm/lib/aarch64/spinlock.c
> new file mode 100644
> index 000000000000..6d66a3dac237
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/lib/aarch64/spinlock.c
> @@ -0,0 +1,27 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * ARM64 Spinlock support
> + */
> +#include <stdint.h>
> +
> +#include "spinlock.h"
> +
> +void spin_lock(struct spinlock *lock)
> +{
> +       uint32_t val, res;

nit: use 'int' to match the lock value type.

> +
> +       asm volatile(
> +       "1:     ldaxr   %w0, [%2]\n"
> +       "       cbnz    %w0, 1b\n"
> +       "       mov     %w0, #1\n"
> +       "       stxr    %w1, %w0, [%2]\n"
> +       "       cbnz    %w1, 1b\n"
> +       : "=&r" (val), "=&r" (res)
> +       : "r" (&lock->v)
> +       : "memory");
> +}
> +
> +void spin_unlock(struct spinlock *lock)
> +{
> +       asm volatile("stlr wzr, [%0]\n" : : "r" (&lock->v) : "memory");
> +}
> --
> 2.33.0.153.gba50c8fa24-goog
>

Otherwise, LGTM.

Reviewed-by: Oliver Upton <oupton@google.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
