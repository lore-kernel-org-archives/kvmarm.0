Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFBE7C433FE
	for <kvmarm@archiver.kernel.org>; Wed, 16 Mar 2022 09:13:01 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3EC4149F15;
	Wed, 16 Mar 2022 05:13:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id erLsSR0SPnKU; Wed, 16 Mar 2022 05:13:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0BD3449ECC;
	Wed, 16 Mar 2022 05:13:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0476E40C0A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Mar 2022 18:56:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TZHV0ZHXOPUt for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Mar 2022 18:56:23 -0400 (EDT)
Received: from mail-oi1-f177.google.com (mail-oi1-f177.google.com
 [209.85.167.177])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DEC2640BF0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Mar 2022 18:56:23 -0400 (EDT)
Received: by mail-oi1-f177.google.com with SMTP id o64so859175oib.7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Mar 2022 15:56:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=references:user-agent:from:to:cc:subject:date:in-reply-to
 :message-id:mime-version;
 bh=ljhqCefXzcruXQp9WtlPDBfDUy90SHN1xf9SfOB4wXo=;
 b=JJdvfR6X7QbqEPUgushUKYa1RNBQkRRR4WC3wPNl5kIq/jo7YTlvg2icY93SRLQXUh
 /H3mr3foM2w4Zeg0j43gJ+lyqTZfkwfWNtS7hhqrgDZzg1uMGpAMthALWh/NvjFIn0uk
 z3f1NAhLXblGVwDuppexEX2ch+IXdxztXMB0CgXCRibvmSYeh9K1kwtyLMGeo6P19j1N
 Jtli/+ReQBAwDCc1T90MIaQrwJ+HgvzDdaWem43Q2c+fFy3/26A9/HhbRTJRjcCnbG5G
 EuQjWi2H+mQ7i+YNbP971nB8QNYJ9z541H61yb1PbWeBwslBmfI5P8ltP7wPBHkp0K1e
 VZCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:references:user-agent:from:to:cc:subject:date
 :in-reply-to:message-id:mime-version;
 bh=ljhqCefXzcruXQp9WtlPDBfDUy90SHN1xf9SfOB4wXo=;
 b=qVbR6BIoCo4U2qjgdSN5T/yZWjPxGj0WLVxqtwBVu4sMj5EJ/tjUjSt2l3DriQqvsF
 LNBJtUZOx7YSfDfe2G/DFuuFVfEyFY3ETL3aHnhxFNw0OwWDNbfEitE2fXIxZ+qfR5BI
 rhT3CWK8UhQWrbdkuicCwxcm6yzDPKxSmvqcvKn83wvjIMkh6c3OF0XxV2mPwJ99S8nN
 exdoy/svNHU32bnw7a53FknLfjt8lRhZsduJIKzXbtuRXxzR289AOxHI6wb363VDf/7o
 CmgYKCsba8jcJ/+FZgWQ+zURO5alV8Hs71UoBM2TooYgUD/xC9HHzPGbUYO23EMu7VZN
 icuA==
X-Gm-Message-State: AOAM532jm1Al3KBIxixDz03Vkmn9lILJg1SZdcKW6tVNfjqneCPS1Ph8
 noS1X0rNPCyMAKKpwYogFT0FoQ==
X-Google-Smtp-Source: ABdhPJxBltnxj+cRdTc3QSEmr5cFA2sw31omFs/+72HwwBL1IWZvFZ6qtR1216vBiT4g5Njj0Zdmuw==
X-Received: by 2002:aca:db03:0:b0:2da:363b:658b with SMTP id
 s3-20020acadb03000000b002da363b658bmr2763996oig.173.1647384983257; 
 Tue, 15 Mar 2022 15:56:23 -0700 (PDT)
Received: from linaro.org ([189.4.186.55]) by smtp.gmail.com with ESMTPSA id
 a19-20020a056808099300b002da1428db03sm247765oic.7.2022.03.15.15.56.22
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 15 Mar 2022 15:56:22 -0700 (PDT)
References: <20220225165923.1474372-1-broonie@kernel.org>
 <20220225165923.1474372-24-broonie@kernel.org>
User-agent: mu4e 1.6.10; emacs 27.2
From: Thiago Jung Bauermann <thiago.bauermann@linaro.org>
To: Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v12 23/40] arm64/sme: Add ptrace support for ZA
Date: Tue, 15 Mar 2022 18:51:36 -0300
In-reply-to: <20220225165923.1474372-24-broonie@kernel.org>
Message-ID: <84v8werfn3.fsf@linaro.org>
MIME-Version: 1.0
X-Mailman-Approved-At: Wed, 16 Mar 2022 05:12:59 -0400
Cc: Marc Zyngier <maz@kernel.org>,
 Basant Kumar Dwivedi <Basant.KumarDwivedi@arm.com>,
 Will Deacon <will@kernel.org>, Luis Machado <luis.machado@arm.com>,
 Szabolcs Nagy <szabolcs.nagy@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Alan Hayward <alan.hayward@arm.com>,
 linux-arm-kernel@lists.infradead.org, linux-kselftest@vger.kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>, Shuah Khan <shuah@kernel.org>,
 kvmarm@lists.cs.columbia.edu, Salil Akerkar <Salil.Akerkar@arm.com>
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


Hello,

Just one trivial comment:

Mark Brown <broonie@kernel.org> writes:

> +static int za_get(struct task_struct *target,
> +		  const struct user_regset *regset,
> +		  struct membuf to)
> +{
> +	struct user_za_header header;
> +	unsigned int vq;
> +	unsigned long start, end;
> +
> +	if (!system_supports_sme())
> +		return -EINVAL;
> +
> +	/* Header */
> +	memset(&header, 0, sizeof(header));
> +
> +	if (test_tsk_thread_flag(target, TIF_SME_VL_INHERIT))
> +		header.flags |= ZA_PT_VL_INHERIT;
> +
> +	header.vl = task_get_sme_vl(target);
> +	vq = sve_vq_from_vl(header.vl);
> +	header.max_vl = sme_max_vl();
> +	header.max_size = ZA_PT_SIZE(vq);
> +
> +	/* If ZA is not active there is only the header */
> +	if (thread_za_enabled(&target->thread))
> +		header.size = ZA_PT_SIZE(vq);
> +	else
> +		header.size = ZA_PT_ZA_OFFSET;
> +
> +	membuf_write(&to, &header, sizeof(header));
> +
> +	BUILD_BUG_ON(ZA_PT_ZA_OFFSET != sizeof(header));
> +	end = ZA_PT_ZA_OFFSET;
> +;

Stray semicolon.

> +	if (target == current)
> +		fpsimd_preserve_current_state();
> +
> +	/* Any register data to include? */
> +	if (thread_za_enabled(&target->thread)) {
> +		start = end;
> +		end = ZA_PT_SIZE(vq);
> +		membuf_write(&to, target->thread.za_state, end - start);
> +	}
> +
> +	/* Zero any trailing padding */
> +	start = end;
> +	end = ALIGN(header.size, SVE_VQ_BYTES);
> +	return membuf_zero(&to, end - start);
> +}

-- 
Thanks,
Thiago
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
