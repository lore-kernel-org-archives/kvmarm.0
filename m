Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C16EC433EF
	for <kvmarm@archiver.kernel.org>; Tue,  5 Apr 2022 00:13:41 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7675E4B156;
	Mon,  4 Apr 2022 20:13:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GDqhTmLUEexN; Mon,  4 Apr 2022 20:13:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5233C4B1D0;
	Mon,  4 Apr 2022 20:13:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F109B4B1D0
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Apr 2022 20:13:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qzZEdWRqhKeK for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Apr 2022 20:13:38 -0400 (EDT)
Received: from mail-il1-f173.google.com (mail-il1-f173.google.com
 [209.85.166.173])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EB5FB4B156
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Apr 2022 20:13:37 -0400 (EDT)
Received: by mail-il1-f173.google.com with SMTP id e9so8075732ilu.9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 04 Apr 2022 17:13:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=6uDd17eqwT3Kpy62aoXwkm+HeQSk1YT26c4Ib6umdL4=;
 b=eXNk/+Eq0+HjpVZOXFXfe7cNbm+VUddUNlWtr1BGApmmRektjC1jvbuB0FfCDevYlS
 nmKmxsMSuWq3gko2J21n3r7+bYdamBpe+zL6GcVWC9Kwql/kIqZ/Rivjy31cQJ616Oyq
 /ASpc2xBTdORjFXO+FeZvQCM7YbXooHUoy8p2AUJZbnQpCDJVG4CXMSoQ2fZLyq9tGD3
 fGcWw/QvSypvvRoIrJKNjfOJmYwgC3od/HgjWXFMe9DnHleiv80upavVoVsLdvOmui/G
 flswyJeDv1J18vUhyNBh5cw5WJ37p4yBJYY3Ds1vuz5TQGAezs4zT2P0cRs7KdfJ1Drt
 Qxzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=6uDd17eqwT3Kpy62aoXwkm+HeQSk1YT26c4Ib6umdL4=;
 b=TxWYvRG1eo22xlBnqeWacMq8UvB8DymgOeUle6PlYiBnvNTI9lp435bdpF8m0viyWg
 Gsyv4kcvQRvVdFotoazGBfkF2W/q+4u4FKtuiytWaoTmlMTQxzQtHgEI+/IYu4qH3H/b
 cx9f35aeMuPhob9b3W2pketn4t0mzSoYLRPyEqOrTRk2zLO/iZLi1r5ibeqUCjtH/GyZ
 edHUvpJ3dWBUkJB5Kz7S0rYYm/3o2NCOWazA5VoTKCV3O9uzd8NhJxqznkmkLT+44dxg
 rF1cXGTyFZnZOer50oM01e/jGNw/hzN163j9F8GQITjDZBwkwjKyD+uFzvTWz3IF/82c
 JF0Q==
X-Gm-Message-State: AOAM533d15HEgRy5qK1RgKYOWySM3n2gIO2IsfOJkg0qyvUe89xUKMNA
 Pki5iHaaKjy0v1qgWElDs5+CnA==
X-Google-Smtp-Source: ABdhPJxmyC1L9wkkrUUenUb5ORTP4NSkIcJ3Bf8yc58eH9UEbTTh92WpCfYd6OwYBVX+KUckN6tkZw==
X-Received: by 2002:a05:6e02:1b0f:b0:2c7:9ec2:1503 with SMTP id
 i15-20020a056e021b0f00b002c79ec21503mr398706ilv.209.1649117617127; 
 Mon, 04 Apr 2022 17:13:37 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194]) by smtp.gmail.com with ESMTPSA id
 y8-20020a920908000000b002ca38acaa60sm2802439ilg.81.2022.04.04.17.13.36
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 04 Apr 2022 17:13:36 -0700 (PDT)
Date: Tue, 5 Apr 2022 00:13:33 +0000
From: Oliver Upton <oupton@google.com>
To: Ricardo Koller <ricarkol@google.com>
Subject: Re: [PATCH v4 2/4] KVM: selftests: add is_cpu_eligible_to_run()
 utility function
Message-ID: <YkuJrYL6wL5P5JY/@google.com>
References: <20220404214642.3201659-1-ricarkol@google.com>
 <20220404214642.3201659-3-ricarkol@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220404214642.3201659-3-ricarkol@google.com>
Cc: kvm@vger.kernel.org, maz@kernel.org, pbonzini@redhat.com,
 kvmarm@lists.cs.columbia.edu
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

Hi Ricardo,

On Mon, Apr 04, 2022 at 02:46:40PM -0700, Ricardo Koller wrote:
> Add is_cpu_eligible_to_run() utility function, which checks whether the current
> process, or one of its threads, is eligible to run on a particular CPU.
> This information is obtained using sched_getaffinity.
> 
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  .../testing/selftests/kvm/include/test_util.h |  2 ++
>  tools/testing/selftests/kvm/lib/test_util.c   | 20 ++++++++++++++++++-
>  2 files changed, 21 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/testing/selftests/kvm/include/test_util.h
> index 99e0dcdc923f..a7653f369b6c 100644
> --- a/tools/testing/selftests/kvm/include/test_util.h
> +++ b/tools/testing/selftests/kvm/include/test_util.h
> @@ -143,4 +143,6 @@ static inline void *align_ptr_up(void *x, size_t size)
>  	return (void *)align_up((unsigned long)x, size);
>  }
>  
> +bool is_cpu_eligible_to_run(int pcpu);
> +
>  #endif /* SELFTEST_KVM_TEST_UTIL_H */
> diff --git a/tools/testing/selftests/kvm/lib/test_util.c b/tools/testing/selftests/kvm/lib/test_util.c
> index 6d23878bbfe1..7813a68333c0 100644
> --- a/tools/testing/selftests/kvm/lib/test_util.c
> +++ b/tools/testing/selftests/kvm/lib/test_util.c
> @@ -4,6 +4,7 @@
>   *
>   * Copyright (C) 2020, Google LLC.
>   */
> +#define _GNU_SOURCE
>  
>  #include <assert.h>
>  #include <ctype.h>
> @@ -13,7 +14,9 @@
>  #include <sys/stat.h>
>  #include <sys/syscall.h>
>  #include <linux/mman.h>
> -#include "linux/kernel.h"
> +#include <linux/kernel.h>
> +#include <sched.h>
> +#include <sys/sysinfo.h>
>  
>  #include "test_util.h"
>  
> @@ -334,3 +337,18 @@ long get_run_delay(void)
>  
>  	return val[1];
>  }
> +
> +bool is_cpu_eligible_to_run(int pcpu)
> +{
> +	cpu_set_t cpuset;
> +	long i, nprocs;
> +
> +	nprocs = get_nprocs_conf();
> +	sched_getaffinity(0, sizeof(cpu_set_t), &cpuset);
> +	for (i = 0; i < nprocs; i++) {
> +		if (i == pcpu)
> +			return CPU_ISSET(i, &cpuset);
> +	}

I don't think you need the loop and can just do CPU_ISSET(pcpu, &cpuset),
right?

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
