Return-Path: <SRS0=Ht+8=K5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7179BC47083
	for <kvmarm@archiver.kernel.org>; Thu,  3 Jun 2021 00:03:54 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DBABA613E9
	for <kvmarm@archiver.kernel.org>; Thu,  3 Jun 2021 00:03:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DBABA613E9
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5353C4A19E;
	Wed,  2 Jun 2021 20:03:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3dn9S0dQuCSM; Wed,  2 Jun 2021 20:03:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3C23049F8F;
	Wed,  2 Jun 2021 20:03:52 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 322C940839
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Jun 2021 20:03:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XYl7sINJBdL8 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Jun 2021 20:03:50 -0400 (EDT)
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com
 [209.85.210.171])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0EF40407EF
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Jun 2021 20:03:50 -0400 (EDT)
Received: by mail-pf1-f171.google.com with SMTP id f22so3556353pfn.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 02 Jun 2021 17:03:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=dSK1YghDEHh+NV8WsQLZprl8Ws0Sp5bz7g+xU8GwfWE=;
 b=cm17XxNaMSMR4SOuZSnpk2SRft8oC+mfLDu9RybmyNepi4gUrIISOiX2VoxgrnX6w5
 WMbAvC3Smfu3ZmIMPi3sjGFGnyj2bSiEDvB4TEJeOmrxvgj0rgLE3qoXfSndU76vhDMc
 pIw1fm3w7HixdXbKUPVXMV/YhZPS+3CIxpbcv/+Dcs7Dxo3vKYrmUUXE2exYDOugUNOr
 UQqle5R/FePtFo8EYkaTudzJhCzeVzP9drhnaUibtD/XvrBY3O1R2zQPYyZ5palnyarC
 PKdm7u7RcqaVoAKeJB5dXjmbzrpB0gQXWS+p11JdRM0yA4xQcJ+qTHgBB8MCsLBIikp2
 ewbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=dSK1YghDEHh+NV8WsQLZprl8Ws0Sp5bz7g+xU8GwfWE=;
 b=gFAkXHxJuu6XzYENWjohgN7oswoAB2YF2n8Gn/U6C8wML0RSFDWH+rmTUvAiAmCs29
 4HjDZ8DnlTEwBY2d92CryC9sfXTgOuUI8kP/mptHmFYbppupmBCcLltxgGw1dF2C8+71
 dBL7B+AmLmy965ZVTO2t1UUoXXjmAHuHpTlQQl6hlrKv4IyOzAK+QdCLx+9tRPGeuehY
 zkkX29Seuyc3H6Ufl0dwATsQih0vGsiCE0vX2l52y3TI5/K4OJfDgVLVVEAvwkcZiZvX
 flH2mlVozlJy2sy1fWBnqdcBYpp6v/9FU+BGcMjntmXGT1+kLgpcFS3qhSsG4aDfKAOF
 HrIw==
X-Gm-Message-State: AOAM532jagxpYkJ41wgNxYHhOsrGJj76cjEoi+KVy3QMq/Yb/xLeBK78
 DaFbbkBNA+pmENH99Y/uPIdIWA==
X-Google-Smtp-Source: ABdhPJz/msCR3BtclVo5R8Ez6EZDkYmxTH8rLz/N5JNqkqt0OdwLp4bYONOFQLPYnZlk3Xeyp6Qt2g==
X-Received: by 2002:a05:6a00:216a:b029:2df:3461:4ac3 with SMTP id
 r10-20020a056a00216ab02902df34614ac3mr29187497pff.80.1622678628971; 
 Wed, 02 Jun 2021 17:03:48 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com.
 [34.83.12.150])
 by smtp.gmail.com with ESMTPSA id q23sm747849pgj.61.2021.06.02.17.03.48
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 02 Jun 2021 17:03:48 -0700 (PDT)
Date: Wed, 2 Jun 2021 17:03:45 -0700
From: Ricardo Koller <ricarkol@google.com>
To: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v3 3/5] KVM: arm64: selftests: get-reg-list: Provide
 config selection option
Message-ID: <YLgcYSJ3COevI7/0@google.com>
References: <20210531103344.29325-1-drjones@redhat.com>
 <20210531103344.29325-4-drjones@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210531103344.29325-4-drjones@redhat.com>
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

On Mon, May 31, 2021 at 12:33:42PM +0200, Andrew Jones wrote:
> Add a new command line option that allows the user to select a specific
> configuration, e.g. --config=sve will give the sve config. Also provide
> help text and the --help/-h options.
> 
> Signed-off-by: Andrew Jones <drjones@redhat.com>

Reviewed-by: Ricardo Koller <ricarkol@google.com>

> ---
>  .../selftests/kvm/aarch64/get-reg-list.c      | 56 ++++++++++++++++++-
>  1 file changed, 53 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/aarch64/get-reg-list.c b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> index 14fc8d82e30f..03e041d97a18 100644
> --- a/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> +++ b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> @@ -539,6 +539,52 @@ static void run_test(struct vcpu_config *c)
>  	kvm_vm_free(vm);
>  }
>  
> +static void help(void)
> +{
> +	struct vcpu_config *c;
> +	int i;
> +
> +	printf(
> +	"\n"
> +	"usage: get-reg-list [--config=<selection>] [--list] [--list-filtered] [--core-reg-fixup]\n\n"
> +	" --config=<selection>        Used to select a specific vcpu configuration for the test/listing\n"
> +	"                             '<selection>' may be\n");
> +
> +	for (i = 0; i < vcpu_configs_n; ++i) {
> +		c = vcpu_configs[i];
> +		printf(
> +	"                               '%s'\n", config_name(c));
> +	}
> +
> +	printf(
> +	"\n"
> +	" --list                      Print the register list rather than test it (requires --config)\n"
> +	" --list-filtered             Print registers that would normally be filtered out (requires --config)\n"
> +	" --core-reg-fixup            Needed when running on old kernels with broken core reg listings\n"
> +	"\n"
> +	);
> +}
> +
> +static struct vcpu_config *parse_config(const char *config)
> +{
> +	struct vcpu_config *c;
> +	int i;
> +
> +	if (config[8] != '=')
> +		help(), exit(1);
> +
> +	for (i = 0; i < vcpu_configs_n; ++i) {
> +		c = vcpu_configs[i];
> +		if (strcmp(config_name(c), &config[9]) == 0)
> +			break;
> +	}
> +
> +	if (i == vcpu_configs_n)
> +		help(), exit(1);
> +
> +	return c;
> +}
> +
>  int main(int ac, char **av)
>  {
>  	struct vcpu_config *c, *sel = NULL;
> @@ -547,20 +593,24 @@ int main(int ac, char **av)
>  	for (i = 1; i < ac; ++i) {
>  		if (strcmp(av[i], "--core-reg-fixup") == 0)
>  			fixup_core_regs = true;
> +		else if (strncmp(av[i], "--config", 8) == 0)
> +			sel = parse_config(av[i]);
>  		else if (strcmp(av[i], "--list") == 0)
>  			print_list = true;
>  		else if (strcmp(av[i], "--list-filtered") == 0)
>  			print_filtered = true;
> +		else if (strcmp(av[i], "--help") == 0 || strcmp(av[1], "-h") == 0)
> +			help(), exit(0);
>  		else
> -			TEST_FAIL("Unknown option: %s\n", av[i]);
> +			help(), exit(1);
>  	}
>  
>  	if (print_list || print_filtered) {
>  		/*
>  		 * We only want to print the register list of a single config.
> -		 * TODO: Add command line support to pick which config.
>  		 */
> -		sel = vcpu_configs[0];
> +		if (!sel)
> +			help(), exit(1);
>  	}
>  
>  	for (i = 0; i < vcpu_configs_n; ++i) {
> -- 
> 2.31.1
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
