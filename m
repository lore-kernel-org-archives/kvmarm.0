Return-Path: <SRS0=P5lD=NZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61425C433F5
	for <kvmarm@archiver.kernel.org>; Fri,  3 Sep 2021 08:25:44 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D15B960FD7
	for <kvmarm@archiver.kernel.org>; Fri,  3 Sep 2021 08:25:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org D15B960FD7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 438714B177;
	Fri,  3 Sep 2021 04:25:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8tb7XNXavbRL; Fri,  3 Sep 2021 04:25:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 01D134B17E;
	Fri,  3 Sep 2021 04:25:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E8BB4B178
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Sep 2021 04:25:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WZIA7eFp2hD8 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  3 Sep 2021 04:25:39 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B67D4B177
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Sep 2021 04:25:39 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1630657539;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=784omy9+f5Am5nR2Vqkl2J0I13vidMEZa3qsfoNTT4c=;
 b=OoruEPaOqG+v63x8EC8z3lC03T5j2aFWlTDvLGYlbr4ex366xDZMXlubhUnYh5XyuQWffs
 Y/wxjSpkPLREc5gTW5gI4+e91NQi5qUDJ+Fe41PP4POfhYd7NlX8jG38EWpxvXotUAhgZl
 443VhpwTdii+vL+N+J7A28uGf9RdacI=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-110-SPTQljBBMB-o5emc0G3reQ-1; Fri, 03 Sep 2021 04:25:38 -0400
X-MC-Unique: SPTQljBBMB-o5emc0G3reQ-1
Received: by mail-ed1-f72.google.com with SMTP id
 o11-20020a056402038b00b003c9e6fd522bso2369463edv.19
 for <kvmarm@lists.cs.columbia.edu>; Fri, 03 Sep 2021 01:25:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=784omy9+f5Am5nR2Vqkl2J0I13vidMEZa3qsfoNTT4c=;
 b=FXTFXltr8cP6EP+kOPuef8hVyZPT099IahrJMf/kjkn8iZU//uq3t0eHcPu8S9HLAE
 Yc0qgZ5wGJ+dX7fXvaQQdrKHrRBF8E/cKe1qfS9kYtgWRUbEQ6ipjLfK6FkbmtNlteOR
 87YXpHFA6pd+4CwXur35iFtJSFpTkNV3jWgd0nPEHtq/of+iMc47+/Yh8RRH+PKn+iRb
 osViTpK05rTI4SX6sLfW0m0+5M9KN4zxMAiKK6IdHXhTCKU7+X5dIA8XM50HMxGB9foG
 zwKB+CQ1zjSP/ZyXsIh+x/SO05q/mr4j+EMhiLs+PsL5UpGdhOuXATkfRPaDVQjyT9l8
 DG3w==
X-Gm-Message-State: AOAM532IvgmXnC44wLFhq3QOyNvnRNT0KHZ3t9SohHkTsr1TO5ANj0Dx
 ZR7XPqtXyMz1x2mcDdb5DTm65qlTq8GKYOk4Pnm5VYstg2BGIa4M+33JIFzVC8Ypq8wFw3n8GeJ
 vYWSN8n0/w+O8pMk5ro+iO4Rs
X-Received: by 2002:a17:906:fcda:: with SMTP id
 qx26mr2880451ejb.121.1630657536931; 
 Fri, 03 Sep 2021 01:25:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzLYFAkqk2qzchrOeqo0XEuIjG+9suLbk+5wak6Qfy73DWOVulKVNgzSe4ifU3BL65WnsM8eg==
X-Received: by 2002:a17:906:fcda:: with SMTP id
 qx26mr2880426ejb.121.1630657536690; 
 Fri, 03 Sep 2021 01:25:36 -0700 (PDT)
Received: from gator.home (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
 by smtp.gmail.com with ESMTPSA id o19sm2450076edr.18.2021.09.03.01.25.35
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 03 Sep 2021 01:25:36 -0700 (PDT)
Date: Fri, 3 Sep 2021 10:25:34 +0200
From: Andrew Jones <drjones@redhat.com>
To: Raghavendra Rao Ananta <rananta@google.com>
Subject: Re: [PATCH v3 08/12] KVM: arm64: selftests: Add light-weight
 spinlock support
Message-ID: <20210903082534.jz3r2defqnrt2ee6@gator.home>
References: <20210901211412.4171835-1-rananta@google.com>
 <20210901211412.4171835-9-rananta@google.com>
MIME-Version: 1.0
In-Reply-To: <20210901211412.4171835-9-rananta@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
 Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
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

On Wed, Sep 01, 2021 at 09:14:08PM +0000, Raghavendra Rao Ananta wrote:
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
> +	int v;
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
> +	uint32_t val, res;
> +
> +	asm volatile(
> +	"1:	ldaxr	%w0, [%2]\n"
> +	"	cbnz	%w0, 1b\n"
> +	"	mov	%w0, #1\n"
> +	"	stxr	%w1, %w0, [%2]\n"
> +	"	cbnz	%w1, 1b\n"
> +	: "=&r" (val), "=&r" (res)
> +	: "r" (&lock->v)
> +	: "memory");
> +}
> +
> +void spin_unlock(struct spinlock *lock)
> +{
> +	asm volatile("stlr wzr, [%0]\n"	: : "r" (&lock->v) : "memory");
> +}
> -- 

Reviewed-by: Andrew Jones <drjones@redhat.com>

It makes sense that the explicit barriers in kvm-unit-tests weren't also
inherited, because we already have the implicit barriers with these ld/st
instruction variants. (I suppose we could improve the kvm-unit-tests
implementation at some point.)

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
