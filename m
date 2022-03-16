Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC8CFC433F5
	for <kvmarm@archiver.kernel.org>; Thu, 17 Mar 2022 09:28:58 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A3B149F5B;
	Thu, 17 Mar 2022 05:28:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id pVSwMtbZ5MHg; Thu, 17 Mar 2022 05:28:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4EBC64B08D;
	Thu, 17 Mar 2022 05:28:52 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E1A5049EFC
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Mar 2022 18:39:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IiP1Qq4f4J0d for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 Mar 2022 18:39:32 -0400 (EDT)
Received: from mail-oo1-f51.google.com (mail-oo1-f51.google.com
 [209.85.161.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CD97D49EFB
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Mar 2022 18:39:32 -0400 (EDT)
Received: by mail-oo1-f51.google.com with SMTP id
 g5-20020a4ae885000000b003240bc9b2afso4430655ooe.10
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Mar 2022 15:39:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=references:user-agent:from:to:cc:subject:date:in-reply-to
 :message-id:mime-version;
 bh=1+QbwgDl1LJslolUIJ7aexnhE/1LwjAWswIgk1iXd24=;
 b=xzzNr7XnXnHN9KieNsWW12uHCOnL1fvC5NJz2h9xZHzRho5cO/9nl2sPy+zpi89PBw
 t90jzK1RBl4EyUSMsVIuuw+T2Nw1vvRfuwtMNgivb6kL9jlZTKmHbeJK0MuJX6P+sQOm
 p9AVmuXrFwKy3HW/IwJkQRC8uSeBuS9JpgzPvcswFNxTZYoj+XYlT/vRBMS9rxbKSzi6
 fOnJyNYN0yTqvLdAD5OCLWSpyAdYtt3HvAZvoasf8hWMND+Qy+jeJ6NllsSE8mP8iXUL
 X6rudyfiV07RrbdjldFxbQi8+RJuE2aavPChDRaUKQwLFP/OfsoW/UUiRBLMRfjRDVhQ
 luRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:references:user-agent:from:to:cc:subject:date
 :in-reply-to:message-id:mime-version;
 bh=1+QbwgDl1LJslolUIJ7aexnhE/1LwjAWswIgk1iXd24=;
 b=X1j8m1jXCYisvb9BxQluWbM77qLA/sk4Ft54EGITHEBkUqXOvuKu45xpvRXCmJ3f6j
 c9Iv9Osk1Me3pOZS4GIqvjHFl5pVSfu/52LR/NM1AxEIvdiA91jVJogyJheQ/7n/MJFW
 tSoxDVCVpQ/rdu41ejAjOfCeb+IHU54y5EUP6Og8exlykeMOE9ip2nahJFwjdT30dCbn
 aNPeBSME0e2qqcA59rKlvyqT0Cfs6QOoWm4jlHPxat265N5JzSAgUrRBaoINSjAmWhOG
 nTV/igQsrBMWbsWU/5NBGEdKOCp3hreQBVcjWHWJEHrM8azG22f0Ge7BZRBSZESkfKIz
 edug==
X-Gm-Message-State: AOAM532D9F5FxRajvZE7rm9/ErARLBE4ObORnDbxXF5B5JcUf1GHi/hw
 WAXMP91W1Og3YRJktKNLCUUGKw==
X-Google-Smtp-Source: ABdhPJxCOYtAyq6RuYOy4M7ev+ABARQur36mgrpikApcM4DwinFa1ybZoRDFPU3zAD2BCczsS2YIug==
X-Received: by 2002:a05:6870:d10e:b0:dd:a653:a25 with SMTP id
 e14-20020a056870d10e00b000dda6530a25mr1837976oac.299.1647470372180; 
 Wed, 16 Mar 2022 15:39:32 -0700 (PDT)
Received: from localhost ([2804:14d:7e39:8470:b171:978c:2a42:8690])
 by smtp.gmail.com with ESMTPSA id
 p8-20020a0568301cc800b005b2259500e2sm1550391otg.25.2022.03.16.15.39.31
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 16 Mar 2022 15:39:31 -0700 (PDT)
References: <20220225165923.1474372-1-broonie@kernel.org>
 <20220225165923.1474372-21-broonie@kernel.org>
User-agent: mu4e 1.6.10; emacs 27.2
From: Thiago Jung Bauermann <thiago.bauermann@linaro.org>
To: Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v12 20/40] arm64/sme: Implement streaming SVE signal
 handling
Date: Wed, 16 Mar 2022 19:38:30 -0300
In-reply-to: <20220225165923.1474372-21-broonie@kernel.org>
Message-ID: <84v8wdbjz4.fsf@linaro.org>
MIME-Version: 1.0
X-Mailman-Approved-At: Thu, 17 Mar 2022 05:28:50 -0400
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

Mark Brown <broonie@kernel.org> writes:

> @@ -186,9 +189,16 @@ struct sve_context {
>   * sve_context.vl must equal the thread's current vector length when
>   * doing a sigreturn.
>   *
> + * On systems with support for SME the SVE register state may reflect either
> + * streaming or non-streaming mode.  In streaming mode the streaming mode
> + * vector length will be used and the flag SVE_SIG_FLAG_SM will be set in
> + * the flags field. It is permitted to enter or leave streaming mode in
> + * a signal return, applications should take care to ensure that any difference
> + * in vector length between the two modes is handled, including any resixing
> + * and movement of context blocks.

s/resixing/resizing/

-- 
Thiago
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
