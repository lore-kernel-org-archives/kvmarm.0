Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBBB9C433EF
	for <kvmarm@archiver.kernel.org>; Tue, 25 Jan 2022 13:23:24 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7D2224083E;
	Tue, 25 Jan 2022 08:23:24 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GppPhGRmk2-s; Tue, 25 Jan 2022 08:23:23 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 38AE049E16;
	Tue, 25 Jan 2022 08:23:23 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D77E340E00
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Jan 2022 08:23:21 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KzeAP-0+-MDJ for <kvmarm@lists.cs.columbia.edu>;
 Tue, 25 Jan 2022 08:23:20 -0500 (EST)
Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com
 [209.85.167.174])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B99704083E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Jan 2022 08:23:20 -0500 (EST)
Received: by mail-oi1-f174.google.com with SMTP id s127so30953974oig.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Jan 2022 05:23:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=QmffA1fbeAbx/qMfx78H51dt2gVeXfmIyiPPBL6SKTQ=;
 b=G/gdmh3WdhdjeY9vF1/SCa1s+oJjrvWa4A+zMWHzWB1BMUFrNit6/xrXAgdyPFVbGh
 ja6vutkqjtUKZTZC8woSZcQ+lTIbgHJadM45P4bBEhI8gqko4/daeLBxgyvhPemguDOs
 Mr8uMALqIlHQFu+jNsccypX3FvKn2z7x5VIENtJTH5j2AB2uc/kEYKzQqUJRcRP0OmiV
 lehQiIbSSuqTp+ujyhxicUs+cg1Cm9+lkbsxi/HOMxUylJBx5cPhIxo+0NHEZ3qLrs+4
 gj18GHbZHEw0TPfTCw7Q0isTynNiXypAWNPRRXKPwxMChFS523eJOuv7X68DViKBJrcJ
 NdxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=QmffA1fbeAbx/qMfx78H51dt2gVeXfmIyiPPBL6SKTQ=;
 b=1ZDCCO313w4+boVR/BUlN0BqGYyvciqaGphGlzWVG03zH5j486OZurhHKxihPYIuOy
 50MZ/WlgCL6XFTp9S6oT4uWpvUEvHJynUet9zYH4/iySkkYbK/+zFk3cGwz4PBTnWWJ/
 Oq/RlqkiHbR7gq9U4ZFKKLY8h7RMX+jGVwyZFZWAL4hkWQ9HU06JpFT4z38Gj98LDoOY
 Z+dDXH76ZivORgIYngDyLOLbHkAl7Iceio5Sqn1S2OJXoWQYTS9mG5B75vLrV4hsfDQw
 FPURPL83kxqlitJ8rRhxfrQyOD9Dm+74gGFjkPeQBQWF7ZIaOXjw8UW5xED0eQ88tyIG
 6HUA==
X-Gm-Message-State: AOAM530KcS3lnJibGxOf0/Yq+QXvcyF8QX1DYTlUAR1xt6xFMWTxvtiG
 oUDdNE7vbwf3y62ku2d9SQ9N4xeCDET8T5azOge/Jg==
X-Google-Smtp-Source: ABdhPJy5EDCOUygXVL1MR05NfKr1mCxSmEry6ObNNVYcmqV5BWVopmYamb6bVVpdjEkQDkhQEBhfYj6vFaTPhWjf0ZU=
X-Received: by 2002:a05:6808:1785:: with SMTP id
 bg5mr579957oib.171.1643116999914; 
 Tue, 25 Jan 2022 05:23:19 -0800 (PST)
MIME-Version: 1.0
References: <20220118015703.3630552-1-jingzhangos@google.com>
 <20220118015703.3630552-4-jingzhangos@google.com>
In-Reply-To: <20220118015703.3630552-4-jingzhangos@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 25 Jan 2022 13:22:44 +0000
Message-ID: <CA+EHjTz+76bD1Lcr8bmdo9W71yaqLpfEKf1jt=2m2DMqwTd=ag@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] KVM: selftests: Add vgic initialization for dirty
 log perf test for ARM
To: Jing Zhang <jingzhangos@google.com>
Cc: KVM <kvm@vger.kernel.org>, Marc Zyngier <maz@kernel.org>,
 David Matlack <dmatlack@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Will Deacon <will@kernel.org>, KVMARM <kvmarm@lists.cs.columbia.edu>
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

Hi Jing,

On Tue, Jan 18, 2022 at 1:57 AM Jing Zhang <jingzhangos@google.com> wrote:
>
> For ARM64, if no vgic is setup before the dirty log perf test, the
> userspace irqchip would be used, which would affect the dirty log perf
> test result.
>
> Signed-off-by: Jing Zhang <jingzhangos@google.com>
> ---
>  tools/testing/selftests/kvm/dirty_log_perf_test.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>
> diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
> index 1954b964d1cf..b501338d9430 100644
> --- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
> +++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
> @@ -18,6 +18,12 @@
>  #include "test_util.h"
>  #include "perf_test_util.h"
>  #include "guest_modes.h"
> +#ifdef __aarch64__
> +#include "aarch64/vgic.h"
> +
> +#define GICD_BASE_GPA                  0x8000000ULL
> +#define GICR_BASE_GPA                  0x80A0000ULL
> +#endif

As you'd mentioned in a previous email, these values are used by other
tests as well as QEMU.

Tested-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>

Thanks,
/fuad




>  /* How many host loops to run by default (one KVM_GET_DIRTY_LOG for each loop)*/
>  #define TEST_HOST_LOOP_N               2UL
> @@ -200,6 +206,10 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>                 vm_enable_cap(vm, &cap);
>         }
>
> +#ifdef __aarch64__
> +       vgic_v3_setup(vm, nr_vcpus, 64, GICD_BASE_GPA, GICR_BASE_GPA);
> +#endif
> +
>         /* Start the iterations */
>         iteration = 0;
>         host_quit = false;
> --
> 2.34.1.703.g22d0c6ccf7-goog
>
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
