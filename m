Return-Path: <SRS0=fRMP=K4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8E4DC47083
	for <kvmarm@archiver.kernel.org>; Wed,  2 Jun 2021 23:56:12 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 15E15613E7
	for <kvmarm@archiver.kernel.org>; Wed,  2 Jun 2021 23:56:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 15E15613E7
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8293F4A319;
	Wed,  2 Jun 2021 19:56:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id N8A87z2P9ga7; Wed,  2 Jun 2021 19:56:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3318C49E5F;
	Wed,  2 Jun 2021 19:56:10 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8136640825
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Jun 2021 19:56:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aybO555J1LWx for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Jun 2021 19:56:07 -0400 (EDT)
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com
 [209.85.215.175])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 31280407E7
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Jun 2021 19:56:07 -0400 (EDT)
Received: by mail-pg1-f175.google.com with SMTP id t9so3678770pgn.4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 02 Jun 2021 16:56:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=w8bKAvJDF2/ejbmITp0Y9SOKD0U71nS0Tkvr2qtI/5k=;
 b=H2Nq+IXAm43kIiKRPbtw0K7qyEo/9Gw3yBPAwMkMDpodMpfHmz7sZRzZZI3bOiBGfw
 qN2PVTrxDVwyvoVKXFp7I5q212UWS8bxcqecLMmth27nlPpqAGbJ64I5Jhd6n7GjK7Lt
 F/1NtIDw0LWEUG9pQSpupEK6hVrkvediHSABps8059FJuWQenrwopscHUhcqu+UxWEM+
 aAtqs74dgkV3hTtP+vMeDeVXqtkkFVjBSoHMszyouhLKrKAT7Ee/hqyTgbsmNH9NIwbU
 a23d2E5GWCQOXNcuWZ5Y5KXV4bbWxqMb39N2xzqfWO4eahI9K3PjUBOw1dH+9+c+pSCw
 pixA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=w8bKAvJDF2/ejbmITp0Y9SOKD0U71nS0Tkvr2qtI/5k=;
 b=dlM9D7JJi9CnpWcEZl7ovlimJRkPFFV7rhoYWCUvUNVo1ACfrJK5dNPiZLokC3vdqr
 QnIfwdk4HHQWhkqfA3rAhtXoCOUP3FcLG+75aQ/4fr1RDVxpkLxw297ufZhiXeu1RBov
 FCJMSHBNtXeM0EapL57ZuzIEId1IiTrQYekOwEwdnIsdnOQ0Nq74MCHFOAgAMLQQr3eJ
 4mepWFREFNzo5WypwcPCmpgXzjDpwFQP7leVlQOJZSd7NPSfQeMdlLnnqkZQtkLf2QY3
 0vYctpIapK7Kq711p8LVjFhsFUWdgPHCqYQAflMhXkr5r7crY222YlwIG+4qiNf2NVGn
 HWBw==
X-Gm-Message-State: AOAM5320+klOE8viAvxwzu38aIQJ0fA20yZAIy8mV0J2/PHIwroz/BN5
 Z9nDg/Wnc5NfEUd7Fg6iiorueg==
X-Google-Smtp-Source: ABdhPJzjb89zQaridnBNqeIcwirFsJPJ8AiysuXbJ/FWVCSqWdrlpD+fTXcJAQ/fBGX8VKYMQmTEDw==
X-Received: by 2002:a63:4b18:: with SMTP id y24mr36580105pga.438.1622678165836; 
 Wed, 02 Jun 2021 16:56:05 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com.
 [34.83.12.150])
 by smtp.gmail.com with ESMTPSA id s24sm549111pfh.104.2021.06.02.16.56.05
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 02 Jun 2021 16:56:05 -0700 (PDT)
Date: Wed, 2 Jun 2021 16:56:01 -0700
From: Ricardo Koller <ricarkol@google.com>
To: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v3 2/5] KVM: arm64: selftests: get-reg-list: Prepare to
 run multiple configs at once
Message-ID: <YLgakV2Eru1J2f4K@google.com>
References: <20210531103344.29325-1-drjones@redhat.com>
 <20210531103344.29325-3-drjones@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210531103344.29325-3-drjones@redhat.com>
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

On Mon, May 31, 2021 at 12:33:41PM +0200, Andrew Jones wrote:
> We don't want to have to create a new binary for each vcpu config, so
> prepare to run the test for multiple vcpu configs in a single binary.
> We do this by factoring out the test from main() and then looping over
> configs. When given '--list' we still never print more than a single
> reg-list for a single vcpu config though, because it would be confusing
> otherwise.
> 
> No functional change intended.
> 
> Signed-off-by: Andrew Jones <drjones@redhat.com>

Reviewed-by: Ricardo Koller <ricarkol@google.com>

> ---
>  .../selftests/kvm/aarch64/get-reg-list.c      | 68 ++++++++++++++-----
>  1 file changed, 51 insertions(+), 17 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/aarch64/get-reg-list.c b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> index 7bb09ce20dde..14fc8d82e30f 100644
> --- a/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> +++ b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> @@ -56,8 +56,8 @@ struct vcpu_config {
>  	struct reg_sublist sublists[];
>  };
>  
> -static struct vcpu_config vregs_config;
> -static struct vcpu_config sve_config;
> +static struct vcpu_config *vcpu_configs[];
> +static int vcpu_configs_n;
>  
>  #define for_each_sublist(c, s)							\
>  	for ((s) = &(c)->sublists[0]; (s)->regs; ++(s))
> @@ -400,29 +400,20 @@ static void check_supported(struct vcpu_config *c)
>  	}
>  }
>  
> -int main(int ac, char **av)
> +static bool print_list;
> +static bool print_filtered;
> +static bool fixup_core_regs;
> +
> +static void run_test(struct vcpu_config *c)
>  {
> -	struct vcpu_config *c = reg_list_sve() ? &sve_config : &vregs_config;
>  	struct kvm_vcpu_init init = { .target = -1, };
>  	int new_regs = 0, missing_regs = 0, i, n;
>  	int failed_get = 0, failed_set = 0, failed_reject = 0;
> -	bool print_list = false, print_filtered = false, fixup_core_regs = false;
>  	struct kvm_vm *vm;
>  	struct reg_sublist *s;
>  
>  	check_supported(c);
>  
> -	for (i = 1; i < ac; ++i) {
> -		if (strcmp(av[i], "--core-reg-fixup") == 0)
> -			fixup_core_regs = true;
> -		else if (strcmp(av[i], "--list") == 0)
> -			print_list = true;
> -		else if (strcmp(av[i], "--list-filtered") == 0)
> -			print_filtered = true;
> -		else
> -			TEST_FAIL("Unknown option: %s\n", av[i]);
> -	}
> -
>  	vm = vm_create(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES, O_RDWR);
>  	prepare_vcpu_init(c, &init);
>  	aarch64_vcpu_add_default(vm, 0, &init, NULL);
> @@ -442,7 +433,7 @@ int main(int ac, char **av)
>  				print_reg(c, id);
>  		}
>  		putchar('\n');
> -		return 0;
> +		return;
>  	}
>  
>  	/*
> @@ -541,6 +532,44 @@ int main(int ac, char **av)
>  		    "%d registers failed get; %d registers failed set; %d registers failed reject",
>  		    config_name(c), missing_regs, failed_get, failed_set, failed_reject);
>  
> +	pr_info("%s: PASS\n", config_name(c));
> +	blessed_n = 0;
> +	free(blessed_reg);
> +	free(reg_list);
> +	kvm_vm_free(vm);
> +}
> +
> +int main(int ac, char **av)
> +{
> +	struct vcpu_config *c, *sel = NULL;
> +	int i;
> +
> +	for (i = 1; i < ac; ++i) {
> +		if (strcmp(av[i], "--core-reg-fixup") == 0)
> +			fixup_core_regs = true;
> +		else if (strcmp(av[i], "--list") == 0)
> +			print_list = true;
> +		else if (strcmp(av[i], "--list-filtered") == 0)
> +			print_filtered = true;
> +		else
> +			TEST_FAIL("Unknown option: %s\n", av[i]);
> +	}
> +
> +	if (print_list || print_filtered) {
> +		/*
> +		 * We only want to print the register list of a single config.
> +		 * TODO: Add command line support to pick which config.
> +		 */
> +		sel = vcpu_configs[0];
> +	}
> +
> +	for (i = 0; i < vcpu_configs_n; ++i) {
> +		c = vcpu_configs[i];
> +		if (sel && c != sel)
> +			continue;
> +		run_test(c);
> +	}
> +
>  	return 0;
>  }
>  
> @@ -945,3 +974,8 @@ static struct vcpu_config sve_config = {
>  	{0},
>  	},
>  };
> +
> +static struct vcpu_config *vcpu_configs[] = {
> +	reg_list_sve() ? &sve_config : &vregs_config,
> +};
> +static int vcpu_configs_n = ARRAY_SIZE(vcpu_configs);
> -- 
> 2.31.1
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
