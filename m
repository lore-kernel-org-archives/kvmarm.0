Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D355ECAAD3
	for <kvmarm@archiver.kernel.org>; Fri,  9 Sep 2022 19:41:02 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E775E4BC2D;
	Fri,  9 Sep 2022 15:41:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id pwnKzw5YERSG; Fri,  9 Sep 2022 15:41:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BF10C4C343;
	Fri,  9 Sep 2022 15:41:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A7D654C2F8
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Sep 2022 15:40:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rmuHLcksXYqM for <kvmarm@lists.cs.columbia.edu>;
 Fri,  9 Sep 2022 15:40:58 -0400 (EDT)
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com
 [209.85.216.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 742AD4BC2D
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Sep 2022 15:40:58 -0400 (EDT)
Received: by mail-pj1-f48.google.com with SMTP id
 p1-20020a17090a2d8100b0020040a3f75eso2584301pjd.4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 09 Sep 2022 12:40:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date;
 bh=nFqa2TjcyXtG5LfkjrFfIDjlrSVISY6DMyya0dLw/08=;
 b=INWicGDVCHNjRChYQUf3p6ERzcoQzdyQwpLY9F5k31ibyYFWjpYoQkviCN8kRqCiJF
 u6ODVKBTjggi2n2vPWGFEfNgu8Me3at6plEEbvoFbeyyTnrvDa4a5I0zEpqsReX5u6nF
 z2CjcoMh4/7N23U+MFTYfrQta/jU8nffJE6zcIbKiyatnkYPk+Y6MQKi2F0cJPOQV/pn
 Nky6ZkNsVBnQwJKIMgc6PDfvbjoe6KfQ58n6kfSJNHlR2U6TtvvIJrcE1EhvsM5n/Vlv
 HinORdE4AdN/QvWtxw1ZnsX81lVnPY/xdKtJX30OkNiAt4U8AWpiBhZrzC/tgaNaVH0D
 Cdzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
 bh=nFqa2TjcyXtG5LfkjrFfIDjlrSVISY6DMyya0dLw/08=;
 b=6ngqKmh4PMjBkJzk68yiRe92XjkHPYftcfKGrDIFur3a+NksK1VVam4O2SHkd47RcO
 cHTj6ApQgEA0wkxuCS7TeTQkMCUrRH8CITtc7kPT/SBa6Q02U3Etz5u9DEaY4NqcoJ+e
 7caYahKgEQ+QzwO7+5EMgESb7SceFn6ugUEgHYwqOKK+MBRjIGjJP6AJpDEhqITZirtX
 nbOfVAW3X0zFOiHx4+X+uUuDi41eC80MGzAt4VvsBe+P+38W8VvMUp+uCvnGY7dzfkyi
 onB7k4zVZ2ujb7CG37AbGJOCRvvus27Gg0T41VxeZkKcOshQ88WuQgxBdOpSOSkNzLK6
 tP/g==
X-Gm-Message-State: ACgBeo2JDikDLTFT3irCbmDo7XqcrUVCtaRM8YZILsE3M3MxZDODgJ7o
 +fMIQ0aB7JVguVTgyYj2dJCwew==
X-Google-Smtp-Source: AA6agR5cccff42JYvlvNY5vl7unif/7zJ0ajNvKLi6sFiggxdBJLSQi0kZ5wx764yB3OEn8O+Aad/w==
X-Received: by 2002:a17:902:f683:b0:176:cc02:ce83 with SMTP id
 l3-20020a170902f68300b00176cc02ce83mr14899100plg.88.1662752456991; 
 Fri, 09 Sep 2022 12:40:56 -0700 (PDT)
Received: from google.com (220.181.82.34.bc.googleusercontent.com.
 [34.82.181.220]) by smtp.gmail.com with ESMTPSA id
 l125-20020a622583000000b0053659f296a0sm126783pfl.8.2022.09.09.12.40.56
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 09 Sep 2022 12:40:56 -0700 (PDT)
Date: Fri, 9 Sep 2022 12:40:52 -0700
From: Ricardo Koller <ricarkol@google.com>
To: Reiji Watanabe <reijiw@google.com>
Subject: Re: [PATCH 2/9] KVM: arm64: selftests: Add write_dbg{b,w}{c,v}r
 helpers in debug-exceptions
Message-ID: <YxuWxMPNYKuYcREX@google.com>
References: <20220825050846.3418868-1-reijiw@google.com>
 <20220825050846.3418868-3-reijiw@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220825050846.3418868-3-reijiw@google.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Andrew Jones <andrew.jones@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>,
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Wed, Aug 24, 2022 at 10:08:39PM -0700, Reiji Watanabe wrote:
> Introduce helpers in the debug-exceptions test to write to
> dbg{b,w}{c,v}r registers. Those helpers will be useful for
> test cases that will be added to the test in subsequent patches.
>

Reviewed-by: Ricardo Koller <ricarkol@google.com>

> Signed-off-by: Reiji Watanabe <reijiw@google.com>
> ---
>  .../selftests/kvm/aarch64/debug-exceptions.c  | 72 +++++++++++++++++--
>  1 file changed, 68 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
> index 2ee35cf9801e..51047e6b8db3 100644
> --- a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
> +++ b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
> @@ -28,6 +28,69 @@ static volatile uint64_t svc_addr;
>  static volatile uint64_t ss_addr[4], ss_idx;
>  #define  PC(v)  ((uint64_t)&(v))
>  
> +#define GEN_DEBUG_WRITE_REG(reg_name)			\
> +static void write_##reg_name(int num, uint64_t val)	\
> +{							\
> +	switch (num) {					\
> +	case 0:						\
> +		write_sysreg(val, reg_name##0_el1);	\
> +		break;					\
> +	case 1:						\
> +		write_sysreg(val, reg_name##1_el1);	\
> +		break;					\
> +	case 2:						\
> +		write_sysreg(val, reg_name##2_el1);	\
> +		break;					\
> +	case 3:						\
> +		write_sysreg(val, reg_name##3_el1);	\
> +		break;					\
> +	case 4:						\
> +		write_sysreg(val, reg_name##4_el1);	\
> +		break;					\
> +	case 5:						\
> +		write_sysreg(val, reg_name##5_el1);	\
> +		break;					\
> +	case 6:						\
> +		write_sysreg(val, reg_name##6_el1);	\
> +		break;					\
> +	case 7:						\
> +		write_sysreg(val, reg_name##7_el1);	\
> +		break;					\
> +	case 8:						\
> +		write_sysreg(val, reg_name##8_el1);	\
> +		break;					\
> +	case 9:						\
> +		write_sysreg(val, reg_name##9_el1);	\
> +		break;					\
> +	case 10:					\
> +		write_sysreg(val, reg_name##10_el1);	\
> +		break;					\
> +	case 11:					\
> +		write_sysreg(val, reg_name##11_el1);	\
> +		break;					\
> +	case 12:					\
> +		write_sysreg(val, reg_name##12_el1);	\
> +		break;					\
> +	case 13:					\
> +		write_sysreg(val, reg_name##13_el1);	\
> +		break;					\
> +	case 14:					\
> +		write_sysreg(val, reg_name##14_el1);	\
> +		break;					\
> +	case 15:					\
> +		write_sysreg(val, reg_name##15_el1);	\
> +		break;					\
> +	default:					\
> +		GUEST_ASSERT(0);			\
> +	}						\
> +}
> +
> +/* Define write_dbgbcr()/write_dbgbvr()/write_dbgwcr()/write_dbgwvr() */
> +GEN_DEBUG_WRITE_REG(dbgbcr)
> +GEN_DEBUG_WRITE_REG(dbgbvr)
> +GEN_DEBUG_WRITE_REG(dbgwcr)
> +GEN_DEBUG_WRITE_REG(dbgwvr)
> +
>  static void reset_debug_state(void)
>  {
>  	asm volatile("msr daifset, #8");
> @@ -59,8 +122,9 @@ static void install_wp(uint64_t addr)
>  	uint32_t mdscr;
>  
>  	wcr = DBGWCR_LEN8 | DBGWCR_RD | DBGWCR_WR | DBGWCR_EL1 | DBGWCR_E;
> -	write_sysreg(wcr, dbgwcr0_el1);
> -	write_sysreg(addr, dbgwvr0_el1);
> +	write_dbgwcr(0, wcr);
> +	write_dbgwvr(0, addr);
> +
>  	isb();
>  
>  	asm volatile("msr daifclr, #8");
> @@ -76,8 +140,8 @@ static void install_hw_bp(uint64_t addr)
>  	uint32_t mdscr;
>  
>  	bcr = DBGBCR_LEN8 | DBGBCR_EXEC | DBGBCR_EL1 | DBGBCR_E;
> -	write_sysreg(bcr, dbgbcr0_el1);
> -	write_sysreg(addr, dbgbvr0_el1);
> +	write_dbgbcr(0, bcr);
> +	write_dbgbvr(0, addr);
>  	isb();
>  
>  	asm volatile("msr daifclr, #8");
> -- 
> 2.37.1.595.g718a3a8f04-goog
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
