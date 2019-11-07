Return-Path: <SRS0=4x2k=Y7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83951C5DF60
	for <kvmarm@archiver.kernel.org>; Thu,  7 Nov 2019 07:56:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0C8AE21D6C
	for <kvmarm@archiver.kernel.org>; Thu,  7 Nov 2019 07:56:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0C8AE21D6C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linutronix.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4161B4AC9C;
	Thu,  7 Nov 2019 02:56:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id y6TYBhCVVtCI; Thu,  7 Nov 2019 02:56:08 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4CA3F4AC9D;
	Thu,  7 Nov 2019 02:56:08 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B0CEF4AC88
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Nov 2019 02:56:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BQXveBciss5Y for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 Nov 2019 02:56:06 -0500 (EST)
Received: from Galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6678E4AC85
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Nov 2019 02:56:06 -0500 (EST)
Received: from p5b06da22.dip0.t-ipconnect.de ([91.6.218.34] helo=nanos)
 by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
 (Exim 4.80) (envelope-from <tglx@linutronix.de>)
 id 1iSce3-0000dt-Uf; Thu, 07 Nov 2019 08:55:56 +0100
Date: Thu, 7 Nov 2019 08:55:54 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jianyong Wu <jianyong.wu@arm.com>
Subject: Re: [RFC PATCH v6 4/7] time: Add mechanism to recognize clocksource
 in time_get_snapshot
In-Reply-To: <20191024110209.21328-5-jianyong.wu@arm.com>
Message-ID: <alpine.DEB.2.21.1911070852551.1869@nanos.tec.linutronix.de>
References: <20191024110209.21328-1-jianyong.wu@arm.com>
 <20191024110209.21328-5-jianyong.wu@arm.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required, ALL_TRUSTED=-1,
 SHORTCIRCUIT=-0.0001
Cc: justin.he@arm.com, kvm@vger.kernel.org, maz@kernel.org,
 richardcochran@gmail.com, yangbo.lu@nxp.com, linux-kernel@vger.kernel.org,
 sean.j.christopherson@intel.com, john.stultz@linaro.org,
 netdev@vger.kernel.org, pbonzini@redhat.com, nd@arm.com, will@kernel.org,
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

On Thu, 24 Oct 2019, Jianyong Wu wrote:
> From: Thomas Gleixner <tglx@linutronix.de>
>
> In some scenario like return device time to ptp_kvm guest,
> we need identify the current clocksource outside core time code.
>
> This patch add a mechanism to recognize the current clocksource
> by export clocksource id in time_get_snapshot.

Please check Documentation/process/submitting-patches.rst and search for
'This patch'.

> diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
> index b21db536fd52..ac8016b22734 100644
> --- a/include/linux/clocksource.h
> +++ b/include/linux/clocksource.h
> @@ -19,6 +19,7 @@
>  #include <linux/of.h>
>  #include <asm/div64.h>
>  #include <asm/io.h>
> +#include <linux/clocksource_ids.h>

Please place that include to the other linux includes. You might notice
that there is ordering here.

But where is that include? It's not part of that series, so how is this
supposed to compile?

Thanks,

	tglx
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
