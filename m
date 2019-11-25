Return-Path: <SRS0=lGdW=ZR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 380A7C43215
	for <kvmarm@archiver.kernel.org>; Mon, 25 Nov 2019 15:47:53 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B77B220863
	for <kvmarm@archiver.kernel.org>; Mon, 25 Nov 2019 15:47:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B77B220863
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 13A9E4AE94;
	Mon, 25 Nov 2019 10:47:52 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dAeGEmWjI+t0; Mon, 25 Nov 2019 10:47:50 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BD1ED4AC68;
	Mon, 25 Nov 2019 10:47:50 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 73AD84A944
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Nov 2019 10:47:50 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NttDgMGLzGYI for <kvmarm@lists.cs.columbia.edu>;
 Mon, 25 Nov 2019 10:47:49 -0500 (EST)
Received: from inca-roads.misterjones.org (inca-roads.misterjones.org
 [213.251.177.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 399E64A830
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Nov 2019 10:47:49 -0500 (EST)
Received: from www-data by cheepnis.misterjones.org with local (Exim 4.80)
 (envelope-from <maz@kernel.org>)
 id 1iZGaS-00029Q-Ac; Mon, 25 Nov 2019 16:47:40 +0100
To: Jianyong Wu <jianyong.wu@arm.com>
Subject: Re: [RFC PATCH v8 3/8] ptp: Reorganize =?UTF-8?Q?ptp=5Fkvm=20modu?=
 =?UTF-8?Q?les=20to=20make=20it=20arch-independent=2E?=
X-PHP-Originating-Script: 0:main.inc
MIME-Version: 1.0
Date: Mon, 25 Nov 2019 15:47:40 +0000
From: Marc Zyngier <maz@kernel.org>
In-Reply-To: <20191125104506.36850-4-jianyong.wu@arm.com>
References: <20191125104506.36850-1-jianyong.wu@arm.com>
 <20191125104506.36850-4-jianyong.wu@arm.com>
Message-ID: <a13a4f9554f36a46781308358fc63519@www.loen.fr>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/0.7.2
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Rcpt-To: jianyong.wu@arm.com, netdev@vger.kernel.org,
 yangbo.lu@nxp.com, john.stultz@linaro.org, tglx@linutronix.de,
 pbonzini@redhat.com, sean.j.christopherson@intel.com, richardcochran@gmail.com,
 mark.rutland@arm.com, will@kernel.org, suzuki.poulose@arm.com,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, steve.capper@arm.com,
 kaly.xin@arm.com, justin.he@arm.com, nd@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org);
 SAEximRunCond expanded to false
Cc: justin.he@arm.com, kvm@vger.kernel.org, netdev@vger.kernel.org,
 richardcochran@gmail.com, linux-kernel@vger.kernel.org,
 sean.j.christopherson@intel.com, john.stultz@linaro.org, yangbo.lu@nxp.com,
 pbonzini@redhat.com, tglx@linutronix.de, nd@arm.com, will@kernel.org,
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 2019-11-25 10:45, Jianyong Wu wrote:
> Currently, ptp_kvm modules implementation is only for x86 which 
> includs
> large part of arch-specific code.  This patch move all of those code
> into new arch related file in the same directory.
>
> Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
> ---
>  drivers/ptp/Makefile                        |  1 +
>  drivers/ptp/{ptp_kvm.c => ptp_kvm_common.c} | 77 +++++-------------
>  drivers/ptp/ptp_kvm_x86.c                   | 87 
> +++++++++++++++++++++
>  include/asm-generic/ptp_kvm.h               | 12 +++
>  4 files changed, 118 insertions(+), 59 deletions(-)
>  rename drivers/ptp/{ptp_kvm.c => ptp_kvm_common.c} (63%)
>  create mode 100644 drivers/ptp/ptp_kvm_x86.c
>  create mode 100644 include/asm-generic/ptp_kvm.h

[...]

> diff --git a/include/asm-generic/ptp_kvm.h 
> b/include/asm-generic/ptp_kvm.h
> new file mode 100644
> index 000000000000..e5dd386f6664
> --- /dev/null
> +++ b/include/asm-generic/ptp_kvm.h
> @@ -0,0 +1,12 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + *  Virtual PTP 1588 clock for use with KVM guests
> + *
> + *  Copyright (C) 2019 ARM Ltd.

I think you should live the original copyright assignment here.
This really isn't anything new.

> + *  All Rights Reserved
> + */
> +
> +int kvm_arch_ptp_init(void);
> +int kvm_arch_ptp_get_clock(struct timespec64 *ts);
> +int kvm_arch_ptp_get_crosststamp(unsigned long *cycle,
> +		struct timespec64 *tspec, void *cs);

Why is this include file in asm-generic? This isn't a kernel-wide API.

I think it should be sitting in drivers/ptp, as it is only shared 
between
the generic and arch-specific stuff.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
