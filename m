Return-Path: <SRS0=6EXF=7G=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.8 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23F6BC433E0
	for <kvmarm@archiver.kernel.org>; Sun, 24 May 2020 02:11:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A4A5E20759
	for <kvmarm@archiver.kernel.org>; Sun, 24 May 2020 02:11:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J786UewE"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A4A5E20759
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 26F544B2C6;
	Sat, 23 May 2020 22:11:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id RK-SYPzMxD5h; Sat, 23 May 2020 22:11:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 55AAD4B287;
	Sat, 23 May 2020 22:11:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 017624B287
 for <kvmarm@lists.cs.columbia.edu>; Sat, 23 May 2020 22:11:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZnhaOJP-mYgz for <kvmarm@lists.cs.columbia.edu>;
 Sat, 23 May 2020 22:11:12 -0400 (EDT)
Received: from mail-pl1-f195.google.com (mail-pl1-f195.google.com
 [209.85.214.195])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D9CF74B274
 for <kvmarm@lists.cs.columbia.edu>; Sat, 23 May 2020 22:11:11 -0400 (EDT)
Received: by mail-pl1-f195.google.com with SMTP id x11so5014073plv.9
 for <kvmarm@lists.cs.columbia.edu>; Sat, 23 May 2020 19:11:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to:user-agent;
 bh=1NYHauUBWTQgbc43oFTAJCreNKv+baIo/68K96Zs4rc=;
 b=J786UewExllUKHofcVvgLTI358KCYatvgJpAOm0F2OufvL+pVNAtJGo1pj6JUBbbpC
 3NF7ePvGe1k+NcGAVJWA2jqXhGQgat6fKQL9C+cfS+HDIRW3Ap1PV2RjfeIRroac1Ezk
 KhFr6z8QBUa1W8cUNJnD/40ivm8kFHrTlkiHK7cocLe4YIU63lxvhlKVJLa1uVkKSRXG
 K5T/3uWMrNaxJoDU2eQqFcsAoD5BLt9X90hzco/4eRKjYTM1gkTYB1q7X53w991RSW2v
 1MVV+EKruZWQnr+ZrRghABtNQQDfIE7Sfy1pYYOvIS3EeWc8l92vFliiDW9EjpixaL1h
 Qflg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to:user-agent;
 bh=1NYHauUBWTQgbc43oFTAJCreNKv+baIo/68K96Zs4rc=;
 b=D+PLD+rfupTz0tJe1nJktPguGs3uH4lKz36ou+J2EYQH9Vdn9pcMvP1dj9rUn1CFSq
 ZvaKy556LlI7VCpqpLBRnO1VKwqrKP03HY954XS8y1CS7rd5rXvt/nCCEzWM2Dp5D+qx
 g77AUHgdPuST31kq0qm21iEipyQBhzhnIu7Rd3ZvQ/0D6W0cxgROcyrIxaZ5k8Olw0CG
 Cff+s3MNMhLdhycD4boIebF+dicK4JDpu6Sp5a6eTZ8bJAo5scV0TkeSim7vlpzyXIfw
 ryIi6ssAGx9+i+tEiTNFXKUGcskaD6IXRuXFCUcTBWyvjZM9UWvdJE1pdX/conDACq5r
 2Aug==
X-Gm-Message-State: AOAM530c5j9noLs0pDpkfzAHM+JS+in93wnscc1I2Le3UzJt+VzqqWCI
 wKKwql0zlBt5WI8O9EqUuSA=
X-Google-Smtp-Source: ABdhPJzjaswgBjGeZOebznwn3ru9lufOX3WhHax+o+4Bd9NRfLzG3TqcRXoKe1CoWCEUQMaErKCTqQ==
X-Received: by 2002:a17:90a:10c1:: with SMTP id
 b1mr7863131pje.232.1590286270773; 
 Sat, 23 May 2020 19:11:10 -0700 (PDT)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net.
 [73.241.114.122])
 by smtp.gmail.com with ESMTPSA id p1sm1961780pjz.36.2020.05.23.19.11.08
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sat, 23 May 2020 19:11:10 -0700 (PDT)
Date: Sat, 23 May 2020 19:11:06 -0700
From: Richard Cochran <richardcochran@gmail.com>
To: Jianyong Wu <jianyong.wu@arm.com>
Subject: Re: [RFC PATCH v12 10/11] arm64: add mechanism to let user choose
 which counter to return
Message-ID: <20200524021106.GC335@localhost>
References: <20200522083724.38182-1-jianyong.wu@arm.com>
 <20200522083724.38182-11-jianyong.wu@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200522083724.38182-11-jianyong.wu@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: maz@kernel.org, justin.he@arm.com, Wei.Chen@arm.com, kvm@vger.kernel.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 sean.j.christopherson@intel.com, steven.price@arm.com, john.stultz@linaro.org,
 yangbo.lu@nxp.com, pbonzini@redhat.com, tglx@linutronix.de, nd@arm.com,
 will@kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

On Fri, May 22, 2020 at 04:37:23PM +0800, Jianyong Wu wrote:
> In general, vm inside will use virtual counter compered with host use
> phyical counter. But in some special scenarios, like nested
> virtualization, phyical counter maybe used by vm. A interface added in
> ptp_kvm driver to offer a mechanism to let user choose which counter
> should be return from host.

Sounds like you have two time sources, one for normal guest, and one
for nested.  Why not simply offer the correct one to user space
automatically?  If that cannot be done, then just offer two PHC
devices with descriptive names.

> diff --git a/drivers/ptp/ptp_chardev.c b/drivers/ptp/ptp_chardev.c
> index fef72f29f3c8..8b0a7b328bcd 100644
> --- a/drivers/ptp/ptp_chardev.c
> +++ b/drivers/ptp/ptp_chardev.c
> @@ -123,6 +123,9 @@ long ptp_ioctl(struct posix_clock *pc, unsigned int cmd, unsigned long arg)
>  	struct timespec64 ts;
>  	int enable, err = 0;
>  
> +#ifdef CONFIG_ARM64
> +	static long flag;

static?  This is not going to fly.

> +		 * In most cases, we just need virtual counter from host and
> +		 * there is limited scenario using this to get physical counter
> +		 * in guest.
> +		 * Be careful to use this as there is no way to set it back
> +		 * unless you reinstall the module.

How on earth is the user supposed to know this?

From your description, this "flag" really should be a module
parameter.

Thanks,
Richard
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
