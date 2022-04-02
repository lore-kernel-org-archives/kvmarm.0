Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA1C8C433F5
	for <kvmarm@archiver.kernel.org>; Sat,  2 Apr 2022 19:26:59 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1F88F4B29D;
	Sat,  2 Apr 2022 15:26:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id U7pdQ8xMNQ0Y; Sat,  2 Apr 2022 15:26:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B901C4B215;
	Sat,  2 Apr 2022 15:26:57 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CFA814B215
 for <kvmarm@lists.cs.columbia.edu>; Sat,  2 Apr 2022 15:26:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Mckqgx5Vq9lT for <kvmarm@lists.cs.columbia.edu>;
 Sat,  2 Apr 2022 15:26:54 -0400 (EDT)
Received: from mail-vs1-f48.google.com (mail-vs1-f48.google.com
 [209.85.217.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 80F0D4B1B5
 for <kvmarm@lists.cs.columbia.edu>; Sat,  2 Apr 2022 15:26:54 -0400 (EDT)
Received: by mail-vs1-f48.google.com with SMTP id z134so5640666vsz.8
 for <kvmarm@lists.cs.columbia.edu>; Sat, 02 Apr 2022 12:26:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=t/LC14YDwSQI5azw7ZF6FVDGNIAV0jkW1G7okaOGqRk=;
 b=nEtckNjOBTMKrbOIJasT7EOXCkxcZrAXX8Hf8vWDFS5Wf89sktGV058venfJBa4a7o
 hya4/qffZtsCGpkhiTeokA/sUlOJRpVrMQykZzLuwpiOzGrqCxBtDNtQm+xZr05FGc7q
 g0yRQUHCxftpBEaEp+AHnb0uLZO3JMSc7ANyXudIAKvODNn2HM1/3ZPyX+mpP24dkJiX
 uMmMiLVaNneXc6FEcikUA8mddRTzMB1HoBTGEtAAdg86JsNnZAGlGPnLMQJgiR8Zb1Mz
 NDUTtn/3SQOTOW7Acba5+BESDbAip+Q42MN8xc4vz0sqbtIr8uZeCro6uw/SOqftA+Wz
 SXRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=t/LC14YDwSQI5azw7ZF6FVDGNIAV0jkW1G7okaOGqRk=;
 b=khyD0XUu5tba4e0echblDYQcLja6bb3gBOWdUiUNclElmz274GSDGXs68v5mKnWuyW
 7IMz0nhgjFAtM6FkLDLrVtX4o2rFFt/aYXx874kLCtlbios7c50RSQuN2bcv4vYksJPC
 tCNnDxf3pnE1lYuCtKSpvW440uBmulZKUiaRnuSjv4PAMxUbwbV8z0YA62yZZWiSOZ81
 5YdeM/cew3Rr3gzuQ0T1ZMWeJKX+mDmWlW9QlHotPQGao78SV3T0kXLnqlItqVaYZ3tZ
 vi43CCar6c1X/PUzjHoCW/WKQaE7wMiSzOkaa4C9g32xpXGP1UQzfBfprRPmwDvFp6Ng
 8qig==
X-Gm-Message-State: AOAM530dv7XjVaQnOOS95sjiuijfBVzts2tJ8aVeeYmHIJYqFdQ3r729
 Yj1AlWuS8eTkckU/b6ROwK4jnId5LAJHA4jVKW70MA==
X-Google-Smtp-Source: ABdhPJwLoXKzHzsBiEB7M9xDR4ymXqNoGSUoH8thPTWAdfRCM7w8J8tF92PXQIdN09YqyktiqFV+OuhFJaFHVURxbdA=
X-Received: by 2002:a05:6102:cd1:b0:325:932b:2c51 with SMTP id
 g17-20020a0561020cd100b00325932b2c51mr5111223vst.38.1648927613782; Sat, 02
 Apr 2022 12:26:53 -0700 (PDT)
MIME-Version: 1.0
References: <20220402174044.2263418-1-oupton@google.com>
 <20220402174044.2263418-4-oupton@google.com>
In-Reply-To: <20220402174044.2263418-4-oupton@google.com>
From: Jing Zhang <jingzhangos@google.com>
Date: Sat, 2 Apr 2022 12:26:42 -0700
Message-ID: <CAAdAUthAHgWpmzg+bVrN7wLunA6cKJBpkyz8tgtYxmpxiYW5Qw@mail.gmail.com>
Subject: Re: [PATCH 3/4] selftests: KVM: Don't leak GIC FD across dirty log
 test iterations
To: Oliver Upton <oupton@google.com>
Cc: KVM <kvm@vger.kernel.org>, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 KVM ARM <kvmarm@lists.cs.columbia.edu>, linux-arm-kernel@lists.infradead.org
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

On Sat, Apr 2, 2022 at 10:40 AM Oliver Upton <oupton@google.com> wrote:
>
> dirty_log_perf_test instantiates a VGICv3 for the guest (if supported by
> hardware) to reduce the overhead of guest exits. However, the test does
> not actually close the GIC fd when cleaning up the VM between test
> iterations, meaning that the VM is never actually destroyed in the
> kernel.
>
> While this is generally a bad idea, the bug was detected from the kernel
> spewing about duplicate debugfs entries as subsequent VMs happen to
> reuse the same FD even though the debugfs directory is still present.
>
> Abstract away the notion of setup/cleanup of the GIC FD from the test
> by creating arch-specific helpers for test setup/cleanup. Close the GIC
> FD on VM cleanup and do nothing for the other architectures.
>
> Fixes: c340f7899af6 ("KVM: selftests: Add vgic initialization for dirty log perf test for ARM")
> Cc: Jing Zhang <jingzhangos@google.com>
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  .../selftests/kvm/dirty_log_perf_test.c       | 34 +++++++++++++++++--
>  1 file changed, 31 insertions(+), 3 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
> index c9d9e513ca04..7b47ae4f952e 100644
> --- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
> +++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
> @@ -18,11 +18,40 @@
>  #include "test_util.h"
>  #include "perf_test_util.h"
>  #include "guest_modes.h"
> +
>  #ifdef __aarch64__
>  #include "aarch64/vgic.h"
>
>  #define GICD_BASE_GPA                  0x8000000ULL
>  #define GICR_BASE_GPA                  0x80A0000ULL
> +
> +static int gic_fd;
> +
> +static void arch_setup_vm(struct kvm_vm *vm, unsigned int nr_vcpus)
> +{
> +       /*
> +        * The test can still run even if hardware does not support GICv3, as it
> +        * is only an optimization to reduce guest exits.
> +        */
> +       gic_fd = vgic_v3_setup(vm, nr_vcpus, 64, GICD_BASE_GPA, GICR_BASE_GPA);
> +}
> +
> +static void arch_cleanup_vm(struct kvm_vm *vm)
> +{
> +       if (gic_fd > 0)
> +               close(gic_fd);
> +}
> +
> +#else /* __aarch64__ */
> +
> +static void arch_setup_vm(struct kvm_vm *vm, unsigned int nr_vcpus)
> +{
> +}
> +
> +static void arch_cleanup_vm(struct kvm_vm *vm)
> +{
> +}
> +
>  #endif
>
>  /* How many host loops to run by default (one KVM_GET_DIRTY_LOG for each loop)*/
> @@ -206,9 +235,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>                 vm_enable_cap(vm, &cap);
>         }
>
> -#ifdef __aarch64__
> -       vgic_v3_setup(vm, nr_vcpus, 64, GICD_BASE_GPA, GICR_BASE_GPA);
> -#endif
> +       arch_setup_vm(vm, nr_vcpus);
>
>         /* Start the iterations */
>         iteration = 0;
> @@ -302,6 +329,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>         }
>
>         free_bitmaps(bitmaps, p->slots);
> +       arch_cleanup_vm(vm);
>         perf_test_destroy_vm(vm);
>  }
>
> --
> 2.35.1.1094.g7c7d902a7c-goog
>
Reviewed-by: Jing Zhang <jingzhangos@google.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
