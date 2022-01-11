Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52B9CC433EF
	for <kvmarm@archiver.kernel.org>; Tue, 11 Jan 2022 09:55:19 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C84504B1DA;
	Tue, 11 Jan 2022 04:55:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cP1e1aDKjeKY; Tue, 11 Jan 2022 04:55:17 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B1EA14B209;
	Tue, 11 Jan 2022 04:55:17 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BABA04B20A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Jan 2022 04:55:16 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JJHJjoIJisq6 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 Jan 2022 04:55:15 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 933EC4B1E4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Jan 2022 04:55:15 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1641894915;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=uMRIJvycuUhx7h41E38Clut9x9CtptwubWi+vWGBfAc=;
 b=OtzaCClYe62uK0nVTLkgyvlJqM+D+c8KRbhzZdGQBN/3BXIqNntIZryofIwxyHjtkbtAqh
 KgICPwKEwdR7tD40hhH0uFDPSP2W9vMoAu61G/eqv/REe/Yg8SpJrvZalasqXYSC7FWztm
 ga5FuCTuP0EdPExmQtOkG9vDZpMbTfw=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-187-v1ACHVamMg-XuyM-pc8Pqg-1; Tue, 11 Jan 2022 04:55:10 -0500
X-MC-Unique: v1ACHVamMg-XuyM-pc8Pqg-1
Received: by mail-qt1-f197.google.com with SMTP id
 d26-20020ac800da000000b002c43d2f6c7fso12931585qtg.14
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Jan 2022 01:55:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=uMRIJvycuUhx7h41E38Clut9x9CtptwubWi+vWGBfAc=;
 b=wTIp9gHyxjZSblQIvLSDzwQrW3piYxRKlSQz3uPgVs3V1jhlWTkXPepvB0JhPrEowP
 nMuPkc76AeTb1tuUoRZ6KmCi0uj7ED4MYtxpVQs+fezJi36XKkWPKASAkTIIvIYDBkVj
 ikN7z8p+ObFIjfcbg3gl/zxoG1jisUkqaQHt0SISAFUNKsNBi8ecfRBU3f+4nM0uItal
 eL9UJR0VP3e0/aKLi+ZW0HEgXGafnw4ZngvfDyC25L1B9p4mploYovvo+lEYKW9Mwmje
 zIYKPagbYpnUPQmOCHx7Cu1pMBYLZfSEet08vtmK9nbVtFM8L5nwAt2YAR0zh5VAi3km
 Ni9g==
X-Gm-Message-State: AOAM531hjr3lY4smVbh0eyh1L6P2boh+0kQMFYL7j43h8lWttPFauaxs
 FhZ0nvWrNlKF6MbOjY5LQVIjkSvv6paD3wm8lZz0VEw3HYIEtw7uZJ/g0wErmXVMd3ykj1LR6K/
 9CSDoUFUKGp4DfKQlcd1Z5Yc+
X-Received: by 2002:ac8:5cd4:: with SMTP id s20mr1931910qta.426.1641894909882; 
 Tue, 11 Jan 2022 01:55:09 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyt2oY5Iv7+h0zYh5JClHXf+9izVN3nAg8r3JTSwK2sGJu05xeSvkHkTZb5Ua/EfbiSyufcIg==
X-Received: by 2002:ac8:5cd4:: with SMTP id s20mr1931896qta.426.1641894909674; 
 Tue, 11 Jan 2022 01:55:09 -0800 (PST)
Received: from gator (nat-pool-brq-u.redhat.com. [213.175.37.12])
 by smtp.gmail.com with ESMTPSA id s19sm6646780qtk.40.2022.01.11.01.55.07
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 11 Jan 2022 01:55:09 -0800 (PST)
Date: Tue, 11 Jan 2022 10:55:05 +0100
From: Andrew Jones <drjones@redhat.com>
To: Jing Zhang <jingzhangos@google.com>
Subject: Re: [RFC PATCH 3/3] KVM: selftests: Add vgic initialization for
 dirty log perf test for ARM
Message-ID: <20220111095505.spwflhcdfxwveh3u@gator>
References: <20220110210441.2074798-1-jingzhangos@google.com>
 <20220110210441.2074798-4-jingzhangos@google.com>
MIME-Version: 1.0
In-Reply-To: <20220110210441.2074798-4-jingzhangos@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
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

On Mon, Jan 10, 2022 at 09:04:41PM +0000, Jing Zhang wrote:
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
> +#define GICD_BASE_GPA			0x8000000ULL
> +#define GICR_BASE_GPA			0x80A0000ULL
> +#endif
>  
>  /* How many host loops to run by default (one KVM_GET_DIRTY_LOG for each loop)*/
>  #define TEST_HOST_LOOP_N		2UL
> @@ -200,6 +206,10 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>  		vm_enable_cap(vm, &cap);
>  	}
>  
> +#ifdef __aarch64__
> +	vgic_v3_setup(vm, nr_vcpus, 64, GICD_BASE_GPA, GICR_BASE_GPA);
                                    ^^ extra parameter

Thanks,
drew

> +#endif
> +
>  	/* Start the iterations */
>  	iteration = 0;
>  	host_quit = false;
> -- 
> 2.34.1.575.g55b058a8bb-goog
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
