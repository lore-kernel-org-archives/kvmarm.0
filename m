Return-Path: <SRS0=6EXF=7G=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.8 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40DE8C433E2
	for <kvmarm@archiver.kernel.org>; Sun, 24 May 2020 01:47:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C485E20735
	for <kvmarm@archiver.kernel.org>; Sun, 24 May 2020 01:47:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DlWRE4ke"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C485E20735
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 546394B22E;
	Sat, 23 May 2020 21:47:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BHs--pwaV17g; Sat, 23 May 2020 21:47:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4303A4B258;
	Sat, 23 May 2020 21:47:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 308144B24E
 for <kvmarm@lists.cs.columbia.edu>; Sat, 23 May 2020 21:47:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RdZ4LsNVDSum for <kvmarm@lists.cs.columbia.edu>;
 Sat, 23 May 2020 21:47:26 -0400 (EDT)
Received: from mail-pg1-f193.google.com (mail-pg1-f193.google.com
 [209.85.215.193])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 24FBC4B22E
 for <kvmarm@lists.cs.columbia.edu>; Sat, 23 May 2020 21:47:26 -0400 (EDT)
Received: by mail-pg1-f193.google.com with SMTP id 124so680052pgi.9
 for <kvmarm@lists.cs.columbia.edu>; Sat, 23 May 2020 18:47:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to:user-agent;
 bh=MiZtZyUhvNO0RTN36GUvH+7s5VqvfFaGqxQpJXB604Y=;
 b=DlWRE4keNL1xYGr6LP7Z9dr6iDQDPvvYMwJuIn/pIXRqNGmrDDcSmH4wOySMJOlu9r
 R/3Z0WdpikEsiyrTcig2R+2qjmyfTURUOR87OLthliUvOkWLr+oxZCIaPSv71Ud6iaxX
 pP2YDXyvqEQbtJn4eptzd7DafNQ6zhj58PcaPV2KE2+G0fVR5zxHQuOocRcxPhFR88Q+
 KAG5cI2D618nv/MPnp65P3cyjOG+ntOCqmBZOZvEdfgGay76oZN5Lpot8t/Pl+i6I/3Y
 b4eIvWXswrLd2PWDQcO+2sqHOsK6mh0ymYGWdwXwwp6lYiz1svI+ZzUR8uJdv5YbWJpm
 qWwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to:user-agent;
 bh=MiZtZyUhvNO0RTN36GUvH+7s5VqvfFaGqxQpJXB604Y=;
 b=uBcOwQ9MlI7l0xs7xdcjfNJ5GFds9+0hkFpO10KUsAZYPmAyQlQQQsBdE8VXSqklYJ
 AeNtA+OmgcQGUJMCFHwjBDeQxZYajyIn4n2744hMM7KEBu9eT3raoEKL++YwFElulfte
 cUF8FzVBed39/6nMWvyG8dKepKq22wDIgUG3+OmEqSzFI4mh5PcyFgFqyxrlCWaUD+fW
 +upjGTTqR9XH4Gw5tAqsbUjRyPBGfRIO4+PJOAz2Y/SVCJfmXkbJQ5AsgEYVNcNUWZlv
 2P3UpKPJCjA6t0dIzauQl0MdA64hVDYHmVc3ZcuQArmqIQeK8hRy5kwNvrDwUnGCxwbl
 0y9g==
X-Gm-Message-State: AOAM530puLmgqzbsiUnDU5KTFIFswFjDrahi1dsUPa6sQKiYH3hWIri3
 leaPcI3uSyC+D3VTjfDDOWQ=
X-Google-Smtp-Source: ABdhPJzNPkHzT4jcUH5lzJbYJGrTRfk3+5AMtRKlysF8ZixPkX7Nsuntu1LZYVVTbFr81nsx5i4U/Q==
X-Received: by 2002:a63:68c3:: with SMTP id
 d186mr20864807pgc.269.1590284845176; 
 Sat, 23 May 2020 18:47:25 -0700 (PDT)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net.
 [73.241.114.122])
 by smtp.gmail.com with ESMTPSA id q3sm9871423pfg.22.2020.05.23.18.47.23
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sat, 23 May 2020 18:47:24 -0700 (PDT)
Date: Sat, 23 May 2020 18:47:21 -0700
From: Richard Cochran <richardcochran@gmail.com>
To: Jianyong Wu <jianyong.wu@arm.com>
Subject: Re: [RFC PATCH v12 10/11] arm64: add mechanism to let user choose
 which counter to return
Message-ID: <20200524014721.GB335@localhost>
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

> To use this feature, you should call PTP_EXTTS_REQUEST(2) ioctl with flag
> set bit PTP_KVM_ARM_PHY_COUNTER in its argument then call
> PTP_SYS_OFFSET_PRECISE(2) ioctl to get the cross timestamp and phyical
> counter will return. If the bit not set or no call for PTP_EXTTS_REQUEST2,
> virtual counter will return by default.

I'm sorry, but NAK on this completely bizarre twisting of the user
space API.

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
> +#endif
>  	switch (cmd) {
>  
>  	case PTP_CLOCK_GETCAPS:
> @@ -149,6 +152,24 @@ long ptp_ioctl(struct posix_clock *pc, unsigned int cmd, unsigned long arg)
>  			err = -EFAULT;
>  			break;
>  		}
> +
> +#ifdef CONFIG_ARM64
> +		/*
> +		 * Just using this ioctl to tell kvm ptp driver to get PHC
> +		 * with physical counter, so if bit PTP_KVM_ARM_PHY_COUNTER
> +		 * is set then just exit directly.
> +		 * In most cases, we just need virtual counter from host and
> +		 * there is limited scenario using this to get physical counter
> +		 * in guest.
> +		 * Be careful to use this as there is no way to set it back
> +		 * unless you reinstall the module.
> +		 * This is only for arm64.
> +		 */
> +		if (req.extts.flags & PTP_KVM_ARM_PHY_COUNTER) {
> +			flag = 1;
> +			break;
> +		}
> +#endif

This file contains the generic PTP Hardware Clock character device
implementation.  It is no place for platform specific hacks.

Sorry,
Richard
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
