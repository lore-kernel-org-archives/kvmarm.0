Return-Path: <SRS0=mEDx=HE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A720C433DB
	for <kvmarm@archiver.kernel.org>; Tue,  2 Feb 2021 13:23:20 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C0FE964F6C
	for <kvmarm@archiver.kernel.org>; Tue,  2 Feb 2021 13:23:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C0FE964F6C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 45A1F4B176;
	Tue,  2 Feb 2021 08:23:19 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id oWD8huSokhfY; Tue,  2 Feb 2021 08:23:18 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 35BDE4B18B;
	Tue,  2 Feb 2021 08:23:18 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 06F6A4B178
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Feb 2021 08:23:17 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id W8q5VKRPBXxK for <kvmarm@lists.cs.columbia.edu>;
 Tue,  2 Feb 2021 08:23:16 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0FD204B176
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Feb 2021 08:23:16 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id B675B64F5D;
 Tue,  2 Feb 2021 13:23:14 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1l6veC-00BV0O-Nn; Tue, 02 Feb 2021 13:23:12 +0000
MIME-Version: 1.0
Date: Tue, 02 Feb 2021 13:23:12 +0000
From: Marc Zyngier <maz@kernel.org>
To: Jianyong Wu <jianyong.wu@arm.com>
Subject: Re: [PATCH v16 3/9] ptp: Reorganize ptp_kvm module to make it
 arch-independent.
In-Reply-To: <20201209060932.212364-4-jianyong.wu@arm.com>
References: <20201209060932.212364-1-jianyong.wu@arm.com>
 <20201209060932.212364-4-jianyong.wu@arm.com>
User-Agent: Roundcube Webmail/1.4.10
Message-ID: <bd371ba17f40bd114b87f284f3537ec4@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: jianyong.wu@arm.com, netdev@vger.kernel.org,
 yangbo.lu@nxp.com, john.stultz@linaro.org, tglx@linutronix.de,
 pbonzini@redhat.com, sean.j.christopherson@intel.com, richardcochran@gmail.com,
 Mark.Rutland@arm.com, will@kernel.org, suzuki.poulose@arm.com,
 Andre.Przywara@arm.com, steven.price@arm.com, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, Steve.Capper@arm.com, justin.he@arm.com, nd@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: justin.he@arm.com, kvm@vger.kernel.org, netdev@vger.kernel.org,
 richardcochran@gmail.com, linux-kernel@vger.kernel.org,
 sean.j.christopherson@intel.com, steven.price@arm.com, Andre.Przywara@arm.com,
 john.stultz@linaro.org, yangbo.lu@nxp.com, pbonzini@redhat.com,
 tglx@linutronix.de, nd@arm.com, will@kernel.org, kvmarm@lists.cs.columbia.edu,
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 2020-12-09 06:09, Jianyong Wu wrote:
> Currently, ptp_kvm modules implementation is only for x86 which 
> includes
> large part of arch-specific code.  This patch moves all of this code
> into a new arch related file in the same directory.
> 
> Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
> ---
>  drivers/ptp/Makefile                        |  1 +
>  drivers/ptp/{ptp_kvm.c => ptp_kvm_common.c} | 84 +++++-------------
>  drivers/ptp/ptp_kvm_x86.c                   | 96 +++++++++++++++++++++
>  include/linux/ptp_kvm.h                     | 16 ++++
>  4 files changed, 135 insertions(+), 62 deletions(-)
>  rename drivers/ptp/{ptp_kvm.c => ptp_kvm_common.c} (60%)
>  create mode 100644 drivers/ptp/ptp_kvm_x86.c
>  create mode 100644 include/linux/ptp_kvm.h
> 

[...]

> diff --git a/include/linux/ptp_kvm.h b/include/linux/ptp_kvm.h
> new file mode 100644
> index 000000000000..6f104b1967bb
> --- /dev/null
> +++ b/include/linux/ptp_kvm.h
> @@ -0,0 +1,16 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later */
> +/*
> + * Virtual PTP 1588 clock for use with KVM guests
> + *
> + * Copyright (C) 2017 Red Hat Inc.
> + */
> +
> +#ifndef _PTP_KVM_H_
> +#define _PTP_KVM_H_
> +
> +int kvm_arch_ptp_init(void);
> +int kvm_arch_ptp_get_clock(struct timespec64 *ts);
> +int kvm_arch_ptp_get_crosststamp(u64 *cycle,
> +		struct timespec64 *tspec, struct clocksource **cs);

You probably want some forward declarations for timespec64 and
clocksource, so that this include file is standalone.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
