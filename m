Return-Path: <SRS0=6EXF=7G=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.8 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0429C433E1
	for <kvmarm@archiver.kernel.org>; Sun, 24 May 2020 01:42:31 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3B7D220825
	for <kvmarm@archiver.kernel.org>; Sun, 24 May 2020 01:42:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GtZPJ7jM"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3B7D220825
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 711094B21A;
	Sat, 23 May 2020 21:42:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dvF8RIaL6ROp; Sat, 23 May 2020 21:42:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 781384B1EB;
	Sat, 23 May 2020 21:42:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 07E0B4B1EB
 for <kvmarm@lists.cs.columbia.edu>; Sat, 23 May 2020 21:42:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HL8pefVQzwpl for <kvmarm@lists.cs.columbia.edu>;
 Sat, 23 May 2020 21:42:26 -0400 (EDT)
Received: from mail-pg1-f193.google.com (mail-pg1-f193.google.com
 [209.85.215.193])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0DE694B1DD
 for <kvmarm@lists.cs.columbia.edu>; Sat, 23 May 2020 21:42:26 -0400 (EDT)
Received: by mail-pg1-f193.google.com with SMTP id j21so6875447pgb.7
 for <kvmarm@lists.cs.columbia.edu>; Sat, 23 May 2020 18:42:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to:user-agent;
 bh=WOxnSmEbJ8sld8voIH7dFeotuFTK+vKmyxU3MIIUb6w=;
 b=GtZPJ7jMgTd975u9HvJI8Vb4cQ0PF/kILo5F96YhAHphc7CWosNo5glezVlXxhXmfe
 2gU8cK7Y8pxzBSBxL2vGV0mECSCAAp8pkJw0+o85UREcMBs5pU34VmV2PquiuIlMBZVS
 I6mX64GzgFs+eJMW1wOvV1EV776L2G42DYYbsYCNlRri+pFm1GFU598QW95NFZbyWUIv
 mkxS+NW/iDwbC1BzK0EnISSbg2E5G/UhDnndhRbKFe1rh3EbsWJYpuQ85dqvt96abTs7
 h0rIdsreV3awAzUw83FAk+0u4QFJaMqks/RfYUAH6W3qqEF3vq6g7HD6yqmDacd3ngUG
 boqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to:user-agent;
 bh=WOxnSmEbJ8sld8voIH7dFeotuFTK+vKmyxU3MIIUb6w=;
 b=i5rmqscn70ih3pf8nwO9UexYYe1eqEe0eeY4pMUFSh7wcE/Bm//nqAlpRJEDuy2k3B
 xDF8TRo74OxjCmEhNNRv/qrTiJHGWPGEeTSkUET9pp5QPFb+hQIa1fNWdLU8w1EiOpOz
 w7Xdy02/kq+cDyQ1+lSFM85f7gUj1PSnvUkgTh0qqWZ/LKz3OMBiZRNODA6qgbqB6N8M
 BrTDh5RwVN1Mfj8nzNgf/6NJX8g1ryx+wtihS+HdIIfsTNMmWp905/RIk4qUrY8fPqgQ
 JG6wlP3zgvRGIu9RohJkapZUYyN6sDGNfB9AIJI8c/eJd/5x6SGUl/ef/mQXiQSV3rrI
 paLQ==
X-Gm-Message-State: AOAM5327Cz2Ju7dPzOXUy8TNS0ae/gVJje0Ws8d2nreEtF+a+aT1mXXO
 agRomX1b7Ei1JNEn1sRETYA=
X-Google-Smtp-Source: ABdhPJz/r2ARO1+zFfzMU6tmLJif4eacW94VQyHfz5ZBMq8FJBOIwE90YKcA4DCDXFxeOk1t1yVKbQ==
X-Received: by 2002:a62:c5c2:: with SMTP id j185mr3837671pfg.74.1590284544972; 
 Sat, 23 May 2020 18:42:24 -0700 (PDT)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net.
 [73.241.114.122])
 by smtp.gmail.com with ESMTPSA id y18sm9957798pfr.100.2020.05.23.18.42.22
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sat, 23 May 2020 18:42:24 -0700 (PDT)
Date: Sat, 23 May 2020 18:42:20 -0700
From: Richard Cochran <richardcochran@gmail.com>
To: Jianyong Wu <jianyong.wu@arm.com>
Subject: Re: [RFC PATCH v12 09/11] ptp: extend input argument for
 getcrosstimestamp API
Message-ID: <20200524014220.GA335@localhost>
References: <20200522083724.38182-1-jianyong.wu@arm.com>
 <20200522083724.38182-10-jianyong.wu@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200522083724.38182-10-jianyong.wu@arm.com>
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

On Fri, May 22, 2020 at 04:37:22PM +0800, Jianyong Wu wrote:
> sometimes we may need tell getcrosstimestamp call back how to perform
> itself. Extending input arguments for getcrosstimestamp API to offer more
> exquisite control for the operation.

This text does not offer any justification for the change in API.
 
> diff --git a/include/linux/ptp_clock_kernel.h b/include/linux/ptp_clock_kernel.h
> index c602670bbffb..ba765647e54b 100644
> --- a/include/linux/ptp_clock_kernel.h
> +++ b/include/linux/ptp_clock_kernel.h
> @@ -133,7 +133,8 @@ struct ptp_clock_info {
>  	int (*gettimex64)(struct ptp_clock_info *ptp, struct timespec64 *ts,
>  			  struct ptp_system_timestamp *sts);
>  	int (*getcrosststamp)(struct ptp_clock_info *ptp,
> -			      struct system_device_crosststamp *cts);
> +			      struct system_device_crosststamp *cts,
> +			      long *flag);

Well, you ignored the kernel doc completely.  But in any case, I must
NAK this completely opaque and mysterious change.  You want to add a
random pointer to some flag?  I don't think so.

Thanks,
Richard


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
