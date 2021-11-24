Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72EB1C433EF
	for <kvmarm@archiver.kernel.org>; Wed, 24 Nov 2021 16:15:03 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B194C4B1DB;
	Wed, 24 Nov 2021 11:15:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Fl8EXzDs+JrN; Wed, 24 Nov 2021 11:15:01 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4D97F4B1DD;
	Wed, 24 Nov 2021 11:15:01 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A76304B1DB
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Nov 2021 11:14:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cDgSG41Y4CAf for <kvmarm@lists.cs.columbia.edu>;
 Wed, 24 Nov 2021 11:14:58 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5AB974B1CC
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Nov 2021 11:14:58 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1637770498;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=mJrAXo0yOwYDhqzWJltPdXBtYsqn5jxXKwheMp22Ick=;
 b=avdladGihBr7aE8k9duo47r8wmBBuVxuJH1YPrWy3mRvA0Ue0vVUShKvauVCGlUMAHb26T
 NYGhu6zoBKFI5q5sDDVuFk66FyjvGsQiH+lXT2VEeS7jnyf/fOZ5y0GbtgfaiC6Gxn59nx
 2ieIc7EOOunNk7BILK/HZiml11z61Ls=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-423-AYH3O1XJORiX97qdKuz_5g-1; Wed, 24 Nov 2021 11:14:56 -0500
X-MC-Unique: AYH3O1XJORiX97qdKuz_5g-1
Received: by mail-wm1-f71.google.com with SMTP id
 r6-20020a1c4406000000b0033119c22fdbso1563572wma.4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Nov 2021 08:14:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:content-transfer-encoding
 :in-reply-to;
 bh=mJrAXo0yOwYDhqzWJltPdXBtYsqn5jxXKwheMp22Ick=;
 b=0TeR4KXM7UIcgdUAGcEn/4A2+zifKwTcdonleNGfk0QQU6Z7TIVqOqnyQ/LyzXYIQ1
 DMxMlCM4Z/s1o82QObKAg+nLideHo5pR8ORF9QzwIeCNbG7sakcO4COyVMRfPWmBUjlG
 tMSYQalNDfu1rt+lFJuWYR1vk7pU9MnuTAgjhulEetyY2uIXvhg5ZOdQFVtUMEakvTH4
 XglD0nD8x4yxJ+nKceM1zljitB/4w8gA7rtx1atzS8yVdOLIGdBdhT19DNPAAVzJ0DDw
 kg6GVZo4ETeGGjgyQGm3hzUVpTXy/dUY9E7ub8noW2Pxabm4t2iVuDktXIDn0KPsWaKt
 SXjg==
X-Gm-Message-State: AOAM530XQzWPXiBadDg2D+J6fVEvHi7FRiYLRyu4u8559QEMupUxo9VD
 WoR0c6w7IFSwY8WzVmQKM4vJ1+fZquKNqXbA6g7VN+9EgVSLtkQlI65t5Oj/9LdNiGMyRYWieAn
 4mNWEkoyO5I59Vvw2S7Rj5YCE
X-Received: by 2002:a1c:448b:: with SMTP id r133mr17043662wma.85.1637770495398; 
 Wed, 24 Nov 2021 08:14:55 -0800 (PST)
X-Google-Smtp-Source: ABdhPJymmCc+u6oBfH4XVYWnBhwOgHSX0hlfUcbUYa1AN2TAUKehwrKpAWg2/27EFWQM986LicPmXg==
X-Received: by 2002:a1c:448b:: with SMTP id r133mr17043615wma.85.1637770495102; 
 Wed, 24 Nov 2021 08:14:55 -0800 (PST)
Received: from gator (nat-pool-brq-u.redhat.com. [213.175.37.12])
 by smtp.gmail.com with ESMTPSA id b6sm5303470wmq.45.2021.11.24.08.14.54
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 24 Nov 2021 08:14:54 -0800 (PST)
Date: Wed, 24 Nov 2021 17:14:53 +0100
From: Andrew Jones <drjones@redhat.com>
To: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [kvm-unit-tests PATCH v8 08/10] arm/barrier-litmus-tests: add
 simple mp and sal litmus tests
Message-ID: <20211124161453.aqkcykcfq5gphvzw@gator>
References: <20211118184650.661575-1-alex.bennee@linaro.org>
 <20211118184650.661575-9-alex.bennee@linaro.org>
MIME-Version: 1.0
In-Reply-To: <20211118184650.661575-9-alex.bennee@linaro.org>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kvm@vger.kernel.org, maz@kernel.org, idan.horowitz@gmail.com,
 qemu-arm@nongnu.org, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Thu, Nov 18, 2021 at 06:46:48PM +0000, Alex Benn=E9e wrote:
> This adds a framework for adding simple barrier litmus tests against
> ARM. The litmus tests aren't as comprehensive as the academic exercises
> which will attempt to do all sorts of things to keep racing CPUs synced
> up. These tests do honour the "sync" parameter to do a poor-mans
> equivalent.
> =

> The two litmus tests are:
>   - message passing
>   - store-after-load
> =

> They both have case that should fail (although won't on single-threaded
> TCG setups). If barriers aren't working properly the store-after-load
> test will fail even on an x86 backend as x86 allows re-ording of non
> aliased stores.
> =

> I've imported a few more of the barrier primatives from the Linux source
> tree so we consistently use macros.
> =

> The arm64 barrier primitives trip up on -Wstrict-aliasing so this is
> disabled in the Makefile.
> =

> Signed-off-by: Alex Benn=E9e <alex.bennee@linaro.org>
> CC: Will Deacon <will@kernel.org>
> =

> ---
> v8
>   - move to mttcgtests.cfg
>   - fix checkpatch issues
>   - fix report usage
> v7
>   - merge in store-after-load
>   - clean-up sync-up code
>   - use new counter api
>   - fix xfail for sal test
> v6
>   - add a unittest.cfg
>   - -fno-strict-aliasing
> ---
>  arm/Makefile.common       |   1 +
>  lib/arm/asm/barrier.h     |  61 ++++++
>  lib/arm64/asm/barrier.h   |  50 +++++
>  arm/barrier-litmus-test.c | 450 ++++++++++++++++++++++++++++++++++++++
>  arm/mttcgtests.cfg        |  33 +++
>  5 files changed, 595 insertions(+)
>  create mode 100644 arm/barrier-litmus-test.c
> =

> diff --git a/arm/Makefile.common b/arm/Makefile.common
> index f905971..861e5c7 100644
> --- a/arm/Makefile.common
> +++ b/arm/Makefile.common
> @@ -13,6 +13,7 @@ tests-common +=3D $(TEST_DIR)/sieve.flat
>  tests-common +=3D $(TEST_DIR)/pl031.flat
>  tests-common +=3D $(TEST_DIR)/tlbflush-code.flat
>  tests-common +=3D $(TEST_DIR)/locking-test.flat
> +tests-common +=3D $(TEST_DIR)/barrier-litmus-test.flat
>  =

>  tests-all =3D $(tests-common) $(tests)
>  all: directories $(tests-all)
> diff --git a/lib/arm/asm/barrier.h b/lib/arm/asm/barrier.h
> index 7f86831..2870080 100644
> --- a/lib/arm/asm/barrier.h
> +++ b/lib/arm/asm/barrier.h
> @@ -8,6 +8,8 @@
>   * This work is licensed under the terms of the GNU GPL, version 2.
>   */
>  =

> +#include <stdint.h>
> +
>  #define sev()		asm volatile("sev" : : : "memory")
>  #define wfe()		asm volatile("wfe" : : : "memory")
>  #define wfi()		asm volatile("wfi" : : : "memory")
> @@ -25,4 +27,63 @@
>  #define smp_rmb()	smp_mb()
>  #define smp_wmb()	dmb(ishst)
>  =

> +extern void abort(void);
> +
> +static inline void __write_once_size(volatile void *p, void *res, int si=
ze)
> +{
> +	switch (size) {
> +	case 1: *(volatile uint8_t *)p =3D *(uint8_t *)res; break;
> +	case 2: *(volatile uint16_t *)p =3D *(uint16_t *)res; break;
> +	case 4: *(volatile uint32_t *)p =3D *(uint32_t *)res; break;
> +	case 8: *(volatile uint64_t *)p =3D *(uint64_t *)res; break;
> +	default:
> +		/* unhandled case */
> +		abort();
> +	}
> +}
> +
> +#define WRITE_ONCE(x, val) \
> +({							\
> +	union { typeof(x) __val; char __c[1]; } __u =3D	\
> +		{ .__val =3D (typeof(x)) (val) }; \
> +	__write_once_size(&(x), __u.__c, sizeof(x));	\
> +	__u.__val;					\
> +})
> +
> +#define smp_store_release(p, v)						\
> +do {									\
> +	smp_mb();							\
> +	WRITE_ONCE(*p, v);						\
> +} while (0)
> +
> +
> +static inline
> +void __read_once_size(const volatile void *p, void *res, int size)
> +{
> +	switch (size) {
> +	case 1: *(uint8_t *)res =3D *(volatile uint8_t *)p; break;
> +	case 2: *(uint16_t *)res =3D *(volatile uint16_t *)p; break;
> +	case 4: *(uint32_t *)res =3D *(volatile uint32_t *)p; break;
> +	case 8: *(uint64_t *)res =3D *(volatile uint64_t *)p; break;
> +	default:
> +		/* unhandled case */
> +		abort();
> +	}
> +}
> +
> +#define READ_ONCE(x)							\
> +({									\
> +	union { typeof(x) __val; char __c[1]; } __u;			\
> +	__read_once_size(&(x), __u.__c, sizeof(x));			\
> +	__u.__val;							\
> +})


WRITE_ONCE and READ_ONCE are already defined in lib/linux/compiler.h

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
