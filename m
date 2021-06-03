Return-Path: <SRS0=Ht+8=K5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5C99C47083
	for <kvmarm@archiver.kernel.org>; Thu,  3 Jun 2021 00:09:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 39880613BF
	for <kvmarm@archiver.kernel.org>; Thu,  3 Jun 2021 00:09:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 39880613BF
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A20CC4A483;
	Wed,  2 Jun 2021 20:09:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3TFhWC22SA-d; Wed,  2 Jun 2021 20:09:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 44A6640CC5;
	Wed,  2 Jun 2021 20:09:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2CC0740CC5
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Jun 2021 20:09:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jsIVvlQBFhli for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Jun 2021 20:09:31 -0400 (EDT)
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com
 [209.85.216.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CF2A040839
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Jun 2021 20:09:31 -0400 (EDT)
Received: by mail-pj1-f51.google.com with SMTP id
 d5-20020a17090ab305b02901675357c371so4088458pjr.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 02 Jun 2021 17:09:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=KgoxK5UQJ3kZ7ylqlhDO43tmp7163zUwhiNj0BfHXdQ=;
 b=NJtl5G//rP3VlOMT5/AFEAUnfv9Uyi1UWa0sdnuShpWWPYj7hThl3A0Vz8JsBQgUt7
 QsiHtcOCnjGSnwEO2LVKiD+xn95hln6GrpXiRTAZF5ThayB8rXu3IjJuIxnl9YoZR9Rz
 CvqH1ankaiVA1uYaIhJngocIc2UqqnPEBB8ehYLWItUYsv28e10FulqRAgQpuKdLfYyy
 d289zk5TmCWI7yoKek710LcDjWAgc6DBFGLAH4PrXsYRzip4oWSUogAQFP+oyN5meI0y
 NH2yho3fpT1wWHjgFAWE7abyoP8y6kCKYvXP2fbINSP8Dpd5OhLLuUKHYlcJcMQksWdJ
 s04Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=KgoxK5UQJ3kZ7ylqlhDO43tmp7163zUwhiNj0BfHXdQ=;
 b=ntE8PZ3FQyPvLaE5N0s/G5s2cPaaigddCh92b8ns6/9jTLsdRj5eBxP4QHI53U0Pxx
 PNzZTzV15hI3i8ALW5sY4UhdZrsMJ6ys0GmpA7LXRjYSnlJuvRuh574j+JLNMvUIRff4
 P3lHMC08pv3nAIPvMv0h2/ovVVc+dpPPW/82X2+geI5g+YQBb025VKfKVeYGbvioJ2M4
 HMV+SSJlzALB9oxIX6kD1PmIn32gbql1sCxqemlmA56MtdWndlYbrFzEIV8nQj5ewiSt
 7bilvMf8ueSys3fI9iX+Gr0137mZVaJke1WVUCva0GK7ltLaWIp7dNNLVqDA7SXWMh7l
 mgjw==
X-Gm-Message-State: AOAM532l2spdzQaDCqrZjy0ljWSByqDJSQZ7TRX6gbcXnzGUaxcgGtAY
 yxvsn7sMz3rkHT/aDlaFnDS9Zw==
X-Google-Smtp-Source: ABdhPJzu2DlDCfQt2uy8zgwfsH5CDfV0mQIzsgP6mz5Kms+RtoW4iQr6dNVMBRs/dS7v3qmcWK1ZQw==
X-Received: by 2002:a17:90a:8c97:: with SMTP id
 b23mr33180951pjo.74.1622678970569; 
 Wed, 02 Jun 2021 17:09:30 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com.
 [34.83.12.150])
 by smtp.gmail.com with ESMTPSA id z185sm755360pgb.4.2021.06.02.17.09.29
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 02 Jun 2021 17:09:30 -0700 (PDT)
Date: Wed, 2 Jun 2021 17:09:26 -0700
From: Ricardo Koller <ricarkol@google.com>
To: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v3 4/5] KVM: arm64: selftests: get-reg-list: Remove
 get-reg-list-sve
Message-ID: <YLgdtgfrdr9ctQFW@google.com>
References: <20210531103344.29325-1-drjones@redhat.com>
 <20210531103344.29325-5-drjones@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210531103344.29325-5-drjones@redhat.com>
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

On Mon, May 31, 2021 at 12:33:43PM +0200, Andrew Jones wrote:
> Now that we can easily run the test for multiple vcpu configs, let's
> merge get-reg-list and get-reg-list-sve into just get-reg-list. We
> also add a final change to make it more possible to run multiple
> tests, which is to fork the test, rather than directly run it. That
> allows a test to fail, but subsequent tests can still run.
> 
> Signed-off-by: Andrew Jones <drjones@redhat.com>

Reviewed-by: Ricardo Koller <ricarkol@google.com>

> ---
>  tools/testing/selftests/kvm/.gitignore        |  1 -
>  tools/testing/selftests/kvm/Makefile          |  1 -
>  .../selftests/kvm/aarch64/get-reg-list-sve.c  |  3 --
>  .../selftests/kvm/aarch64/get-reg-list.c      | 31 +++++++++++++------
>  4 files changed, 21 insertions(+), 15 deletions(-)
>  delete mode 100644 tools/testing/selftests/kvm/aarch64/get-reg-list-sve.c
> 
> diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
> index 524c857a049c..dd36575b732a 100644
> --- a/tools/testing/selftests/kvm/.gitignore
> +++ b/tools/testing/selftests/kvm/.gitignore
> @@ -1,6 +1,5 @@
>  # SPDX-License-Identifier: GPL-2.0-only
>  /aarch64/get-reg-list
> -/aarch64/get-reg-list-sve
>  /aarch64/vgic_init
>  /s390x/memop
>  /s390x/resets
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index daaee1888b12..5c8f3725a7f0 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -79,7 +79,6 @@ TEST_GEN_PROGS_x86_64 += set_memory_region_test
>  TEST_GEN_PROGS_x86_64 += steal_time
>  
>  TEST_GEN_PROGS_aarch64 += aarch64/get-reg-list
> -TEST_GEN_PROGS_aarch64 += aarch64/get-reg-list-sve
>  TEST_GEN_PROGS_aarch64 += aarch64/vgic_init
>  TEST_GEN_PROGS_aarch64 += demand_paging_test
>  TEST_GEN_PROGS_aarch64 += dirty_log_test
> diff --git a/tools/testing/selftests/kvm/aarch64/get-reg-list-sve.c b/tools/testing/selftests/kvm/aarch64/get-reg-list-sve.c
> deleted file mode 100644
> index efba76682b4b..000000000000
> --- a/tools/testing/selftests/kvm/aarch64/get-reg-list-sve.c
> +++ /dev/null
> @@ -1,3 +0,0 @@
> -// SPDX-License-Identifier: GPL-2.0
> -#define REG_LIST_SVE
> -#include "get-reg-list.c"
> diff --git a/tools/testing/selftests/kvm/aarch64/get-reg-list.c b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> index 03e041d97a18..b46b8a1fdc0c 100644
> --- a/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> +++ b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> @@ -27,16 +27,13 @@
>  #include <stdio.h>
>  #include <stdlib.h>
>  #include <string.h>
> +#include <unistd.h>
> +#include <sys/types.h>
> +#include <sys/wait.h>
>  #include "kvm_util.h"
>  #include "test_util.h"
>  #include "processor.h"
>  
> -#ifdef REG_LIST_SVE
> -#define reg_list_sve() (true)
> -#else
> -#define reg_list_sve() (false)
> -#endif
> -
>  static struct kvm_reg_list *reg_list;
>  static __u64 *blessed_reg, blessed_n;
>  
> @@ -588,7 +585,8 @@ static struct vcpu_config *parse_config(const char *config)
>  int main(int ac, char **av)
>  {
>  	struct vcpu_config *c, *sel = NULL;
> -	int i;
> +	int i, ret = 0;
> +	pid_t pid;
>  
>  	for (i = 1; i < ac; ++i) {
>  		if (strcmp(av[i], "--core-reg-fixup") == 0)
> @@ -617,10 +615,22 @@ int main(int ac, char **av)
>  		c = vcpu_configs[i];
>  		if (sel && c != sel)
>  			continue;
> -		run_test(c);
> +
> +		pid = fork();
> +
> +		if (!pid) {
> +			run_test(c);
> +			exit(0);
> +		} else {
> +			int wstatus;
> +			pid_t wpid = wait(&wstatus);
> +			TEST_ASSERT(wpid == pid && WIFEXITED(wstatus), "wait: Unexpected return");
> +			if (WEXITSTATUS(wstatus) && WEXITSTATUS(wstatus) != KSFT_SKIP)
> +				ret = KSFT_FAIL;
> +		}
>  	}
>  
> -	return 0;
> +	return ret;
>  }
>  
>  /*
> @@ -1026,6 +1036,7 @@ static struct vcpu_config sve_config = {
>  };
>  
>  static struct vcpu_config *vcpu_configs[] = {
> -	reg_list_sve() ? &sve_config : &vregs_config,
> +	&vregs_config,
> +	&sve_config,
>  };
>  static int vcpu_configs_n = ARRAY_SIZE(vcpu_configs);
> -- 
> 2.31.1
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
