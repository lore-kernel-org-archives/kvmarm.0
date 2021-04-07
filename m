Return-Path: <SRS0=nct1=JE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A6B4C433B4
	for <kvmarm@archiver.kernel.org>; Wed,  7 Apr 2021 15:13:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 292AE61222
	for <kvmarm@archiver.kernel.org>; Wed,  7 Apr 2021 15:13:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 292AE61222
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 948914B5F5;
	Wed,  7 Apr 2021 11:13:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id u5niH0AoCRGn; Wed,  7 Apr 2021 11:13:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8F6024B8DB;
	Wed,  7 Apr 2021 11:13:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 45EE14B657
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Apr 2021 11:13:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EdNWvgX+BIBC for <kvmarm@lists.cs.columbia.edu>;
 Wed,  7 Apr 2021 11:13:39 -0400 (EDT)
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com
 [209.85.215.180])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 064FF4B5F5
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Apr 2021 11:13:39 -0400 (EDT)
Received: by mail-pg1-f180.google.com with SMTP id b17so9636493pgh.7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 07 Apr 2021 08:13:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to:user-agent;
 bh=8gSjC0WXXO0hyXex8pLBlZgJJ3C7tLcObU3Ri/R7BbE=;
 b=FWLkxi8L5ScjBYku9DHP82+AoKKDTgiXDj5CeSLW9WZ7l02g+wa9AaAR0DefJ72Tlk
 tTgx2RnGgHCH7V6Y7E5SnVAdcg2Qo09HuigOiyIL+eJDYdYOn75ia5NROQ4/PPjrB6Im
 SdotBRwae7sMhDq5ujnlQAXuBRoAhlmZJfv47BFwvls8Zwflvh4WaRpWqiabpGK3Iwq/
 Aq6IRIvcPC5/A8UNEc3BFAA9FhRnBYjrM5Y2gpSiYEbqE2XxUh3A3jv+Z6g/emsSH9vh
 +YmcErc3p+N1BR5pfSmgJKXOQbgiltEG/c2v/avbdp2VW3i4xivIhvc6kJ0aw4LTSH5w
 xqmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to:user-agent;
 bh=8gSjC0WXXO0hyXex8pLBlZgJJ3C7tLcObU3Ri/R7BbE=;
 b=Kxcy6FgHHpw58CX91x+R65DolauPqhsflea5Xvto8YR//47KKTJcyN36P6razivSeI
 yQUDFBZD3IfmMXLKEN0g7z+/e56c6EI4hUIUgdf8C0O3E47fsNTzKKUgyR5TWfBMUFHn
 Mluj3npKYuuMUolkoBGjihxNVhvGG7t3DwKBjeIMBE17u2/ACKMr9wRcUoYsox7Ipnyd
 9n4WmUMPMfmYQEgc5GvImwT5Q3UJCLDiIjxzqNR4Wb4m8yeocLMISWTxsO/hO5mbzKVR
 447IDtrKZ22pEDjgEpmXVRBp4ON0VathDNK4YFI2WeThNYEeqJ7hYwdz06Wrr3EZwShP
 9+dA==
X-Gm-Message-State: AOAM531BaPYrdHFIVYeSErfRW3ywz9PRYQRpXANzSHyXEoc3zWYskyfm
 7XqGEibHrIptItvzNg1/z1Y=
X-Google-Smtp-Source: ABdhPJy5ZPRmaIO7nEBFmAuQOQ0Y8GY3inREsOnbc9BdLsN540bPamng3WsIf87RWRfNOC3QrsUeFA==
X-Received: by 2002:a05:6a00:2301:b029:204:9bb6:de72 with SMTP id
 h1-20020a056a002301b02902049bb6de72mr3386966pfh.62.1617808417948; 
 Wed, 07 Apr 2021 08:13:37 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:35:e2d5:5eff:fea5:802f])
 by smtp.gmail.com with ESMTPSA id g5sm23385518pfb.77.2021.04.07.08.13.36
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 07 Apr 2021 08:13:37 -0700 (PDT)
Date: Wed, 7 Apr 2021 08:13:34 -0700
From: Richard Cochran <richardcochran@gmail.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v19 3/7] ptp: Reorganize ptp_kvm.c to make it
 arch-independent
Message-ID: <20210407151334.GB7379@hoboy.vegasvil.org>
References: <20210330145430.996981-1-maz@kernel.org>
 <20210330145430.996981-4-maz@kernel.org>
 <87eefmpho3.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87eefmpho3.wl-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: kernel-team@android.com, lorenzo.pieralisi@arm.com, justin.he@arm.com,
 kvm@vger.kernel.org, seanjc@google.com, sudeep.holla@arm.com,
 linux-kernel@vger.kernel.org, steven.price@arm.com, Andre.Przywara@arm.com,
 netdev@vger.kernel.org, john.stultz@linaro.org, yangbo.lu@nxp.com,
 pbonzini@redhat.com, tglx@linutronix.de, will@kernel.org,
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

On Wed, Apr 07, 2021 at 10:28:44AM +0100, Marc Zyngier wrote:
> On Tue, 30 Mar 2021 15:54:26 +0100,
> Marc Zyngier <maz@kernel.org> wrote:
> > 
> > From: Jianyong Wu <jianyong.wu@arm.com>
> > 
> > Currently, the ptp_kvm module contains a lot of x86-specific code.
> > Let's move this code into a new arch-specific file in the same directory,
> > and rename the arch-independent file to ptp_kvm_common.c.
> > 
> > Reviewed-by: Andre Przywara <andre.przywara@arm.com>
> > Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
> > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > Link: https://lore.kernel.org/r/20201209060932.212364-4-jianyong.wu@arm.com
> 
> Richard, Paolo,
> 
> Can I get an Ack on this and patch #7? We're getting pretty close to
> the next merge window, and this series has been going on for a couple
> of years now...

For both patches:

Acked-by: Richard Cochran <richardcochran@gmail.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
