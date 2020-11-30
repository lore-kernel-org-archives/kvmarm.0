Return-Path: <SRS0=p1b3=FE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD78AC64E8A
	for <kvmarm@archiver.kernel.org>; Mon, 30 Nov 2020 15:27:03 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0B2FF20731
	for <kvmarm@archiver.kernel.org>; Mon, 30 Nov 2020 15:27:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="oZtkSq2L"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0B2FF20731
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 24D414B962;
	Mon, 30 Nov 2020 10:27:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7gES8QEmXeZB; Mon, 30 Nov 2020 10:27:01 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3B6054B964;
	Mon, 30 Nov 2020 10:27:01 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1CA024B962
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Nov 2020 10:27:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Eov1T34N8yzC for <kvmarm@lists.cs.columbia.edu>;
 Mon, 30 Nov 2020 10:26:59 -0500 (EST)
Received: from mail-wr1-f68.google.com (mail-wr1-f68.google.com
 [209.85.221.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1D7C04B95F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Nov 2020 10:26:59 -0500 (EST)
Received: by mail-wr1-f68.google.com with SMTP id 64so16720942wra.11
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Nov 2020 07:26:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=tONxU2U9GL0gMUjpyZwJygnVpWZHjPgrlpNaw6Fic48=;
 b=oZtkSq2Ljzo+vuM1EdpYt4mGvnekUHwbfMD4nZGtJHrP3zH3OmY4r/NK/mDNQkqyiz
 q5zRZLHniWJSmOEsxXeY96qUHXaMuceZhg0phtxUHF7iibJmUmyWkkKKZJJRqnZt+t5A
 clolipjKljpNA5i1MtZZQzEi8jZ3SW36zfPRzzMG9iTsiEkyvwQUtLPFsvji0U6fLdI7
 mWrDEZMXrOPf6cc3OCHYxGMRMKUBDPIc30+Kp7aK3rLbKlvvLsnW2EhLtn3yk7EsbNv2
 z1v0kX6t0wVpcYgfQH45SV2nNdsuqwdg/xORx8NrmNpDubBvXRdWvN0RGBgJAF5NZxRO
 /jpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=tONxU2U9GL0gMUjpyZwJygnVpWZHjPgrlpNaw6Fic48=;
 b=GSykwcTzCpJkUI9Sfv2rjUF61Gth26IzPCCEC6MDRpstW6kK0FUmLFOm3gXncm5Gw8
 s+18oxuwwqVyjUX7h3SJ1OXKf520UGsQlmn1Zn4WkmwyhLLy12Lo52GdJncwZRQFhZ9W
 N1Q8b6z74TkeznsDheY0lDBJ8Va953mlO8nMQ33ohHXggke5np+rRVxCkjn+qtMGVcbG
 ayTondN5AtocTOsRsaKuI9BYxFATdEgFJyzK+L38Czbsa3C4IZENuxoTrbtfHlrhBb9P
 Hwb7GusePjnqfiTXoUB+UzUmQJRxaxAIt45UapxpkclkG8nbS87jsifmeoxlGA4HBy4y
 BQQQ==
X-Gm-Message-State: AOAM531hCFokOPwcbTnZRoQr2oGOI8Wbi+mmXfs67ypmYeLJHj0+vX0X
 IjdN/aJ0ro4h8alztgzpMwWmTg==
X-Google-Smtp-Source: ABdhPJxpMmIXCRaiBBxkPTGUoiQKyhIZmvSM1oRqrg7e8aAjHI9Ui3kbXFIzmmmqQTpXTmWMypzCkw==
X-Received: by 2002:a5d:4349:: with SMTP id u9mr28116179wrr.319.1606750017869; 
 Mon, 30 Nov 2020 07:26:57 -0800 (PST)
Received: from google.com ([2a01:4b00:8523:2d03:acd2:909f:46a6:675])
 by smtp.gmail.com with ESMTPSA id b14sm27372063wrq.47.2020.11.30.07.26.56
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 30 Nov 2020 07:26:56 -0800 (PST)
Date: Mon, 30 Nov 2020 15:26:55 +0000
From: David Brazdil <dbrazdil@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 2/2] KVM: arm64: Advertise ID_AA64PFR0_EL1.CSV3=1 if the
 CPUs are Meltdown-safe
Message-ID: <20201130152655.oyzs2l4qg2pfzxmv@google.com>
References: <20201128124659.669578-1-maz@kernel.org>
 <20201128124659.669578-3-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20201128124659.669578-3-maz@kernel.org>
Cc: kvm@vger.kernel.org, kernel-team@android.com,
 linux-arm-kernel@lists.infradead.org, Will Deacon <will@kernel.org>,
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

> @@ -1227,9 +1229,16 @@ static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
>  	    (csv2 && arm64_get_spectre_v2_state() != SPECTRE_UNAFFECTED))
>  		return -EINVAL;
>  
> -	/* We can only differ with CSV2, and anything else is an error */
> +	/* Same thing for CSV3 */
> +	csv3 = cpuid_feature_extract_unsigned_field(val, ID_AA64PFR0_CSV3_SHIFT);
> +	if (csv3 > 1 ||
> +	    (csv3 && arm64_get_meltdown_state() != SPECTRE_UNAFFECTED))
> +		return -EINVAL;
> +
> +	/* We can only differ with CSV[23], and anything else is an error */
>  	val ^= read_id_reg(vcpu, rd, false);
> -	val &= ~(0xFUL << ID_AA64PFR0_CSV2_SHIFT);
> +	val &= ~((0xFUL << ID_AA64PFR0_CSV2_SHIFT) ||
> +		 (0xFUL << ID_AA64PFR0_CSV3_SHIFT));

That boolean OR looks like a typo.

David
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
