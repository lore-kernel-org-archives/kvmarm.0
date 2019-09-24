Return-Path: <SRS0=oENQ=XT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20819C432C1
	for <kvmarm@archiver.kernel.org>; Tue, 24 Sep 2019 15:39:32 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9EF51207FD
	for <kvmarm@archiver.kernel.org>; Tue, 24 Sep 2019 15:39:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9EF51207FD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 254A34A681;
	Tue, 24 Sep 2019 11:39:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id f5+J7-P3jN-e; Tue, 24 Sep 2019 11:39:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F1CB04A567;
	Tue, 24 Sep 2019 11:39:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4C3634A567
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Sep 2019 11:39:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MAzO4yUAxk9N for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 Sep 2019 11:39:26 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3167F4A53F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Sep 2019 11:39:26 -0400 (EDT)
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mx1.redhat.com (Postfix) with ESMTPS id 4EB598830A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Sep 2019 15:39:25 +0000 (UTC)
Received: by mail-qt1-f200.google.com with SMTP id e13so2359926qto.18
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Sep 2019 08:39:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=PTQQeXWO5vPTU6tigUaFPHUuGjp5uZ3Hgvq/mbe0/q8=;
 b=ZROi1/Zm7ORbBxGaVBi6yGJpedRsBoEcfkVSqoi4CqTInknxadEPVaC47KJ8yIfdDT
 2kNyFc6X7xeEcogRBNQKDqsnnZw8tj89nJiO4EGxZngsOZYx7XpQptUcfYF8DAmLc7yT
 DrK5y5NGU//kPr8HxOxAMe2/HRUieHXBuA4Um0OfwXH/zpJP4hTTxWPX196YPjAVCWJn
 QrVhNRNDnHd0zNWc8wfPKTnLTVlr0XnQJbqi0JSlhsIZqDf6bfFk9pZwKSRIO1mW52Ld
 qUFXEVTCQUqYHzR/MEQRYfEbtIPQwHyNavg+QLQmASxxAAg5eigouqpPXLJ7dF48i9sY
 eTnQ==
X-Gm-Message-State: APjAAAU8LiM2uLiftIYPDYP4kbYno4pkG62poCHORHiu9t7QE8dz61nu
 fhjyN9ULMcaY3X/0fdKtrOZtPirAA2bLSCed1SX9qSJNFrtSJo7pCfH6Qu5jwpG2My3c0+Xc4Er
 Fs1jnz6VMxSCk/L3Rr3tOKj/L
X-Received: by 2002:ac8:342a:: with SMTP id u39mr3465214qtb.7.1569339564628;
 Tue, 24 Sep 2019 08:39:24 -0700 (PDT)
X-Google-Smtp-Source: APXvYqznlDhsLQpyIFK6nRFjbhudaZrRRV3OOlTnkVZlvYzC4PZu5ddm6L574qRzPyehnZUU6ffx+Q==
X-Received: by 2002:ac8:342a:: with SMTP id u39mr3465181qtb.7.1569339564339;
 Tue, 24 Sep 2019 08:39:24 -0700 (PDT)
Received: from redhat.com (bzq-79-176-40-226.red.bezeqint.net. [79.176.40.226])
 by smtp.gmail.com with ESMTPSA id v5sm1448122qtk.66.2019.09.24.08.39.20
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 24 Sep 2019 08:39:23 -0700 (PDT)
Date: Tue, 24 Sep 2019 11:39:17 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Heyi Guo <guoheyi@huawei.com>
Subject: Re: [RFC PATCH 01/12] linux-headers: import arm_sdei.h
Message-ID: <20190924113640-mutt-send-email-mst@kernel.org>
References: <1569338511-3572-1-git-send-email-guoheyi@huawei.com>
 <1569338511-3572-2-git-send-email-guoheyi@huawei.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1569338511-3572-2-git-send-email-guoheyi@huawei.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Cornelia Huck <cohuck@redhat.com>,
 qemu-devel@nongnu.org, Dave Martin <Dave.Martin@arm.com>, qemu-arm@nongnu.org,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
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

On Tue, Sep 24, 2019 at 11:21:40PM +0800, Heyi Guo wrote:
> Import Linux header file include/uapi/linux/arm_sdei.h from kernel
> v5.3 release.
> 
> This is to prepare for qemu SDEI emulation.
> 
> Signed-off-by: Heyi Guo <guoheyi@huawei.com>
> Cc: Peter Maydell <peter.maydell@linaro.org>
> Cc: Dave Martin <Dave.Martin@arm.com>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: James Morse <james.morse@arm.com>
> Cc: "Michael S. Tsirkin" <mst@redhat.com>
> Cc: Cornelia Huck <cohuck@redhat.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>

Some issues with this.  First linux-headers is for linux as a host.
This is for linux as a guest, so belongs in include/standard-headers.

Second, please add to scripts/update-linux-headers.sh in a 1st patch,
then add the file in the second patch.



> ---
>  linux-headers/linux/arm_sdei.h | 73 ++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 73 insertions(+)
>  create mode 100644 linux-headers/linux/arm_sdei.h
> 
> diff --git a/linux-headers/linux/arm_sdei.h b/linux-headers/linux/arm_sdei.h
> new file mode 100644
> index 0000000..af0630b
> --- /dev/null
> +++ b/linux-headers/linux/arm_sdei.h
> @@ -0,0 +1,73 @@
> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> +/* Copyright (C) 2017 Arm Ltd. */
> +#ifndef _UAPI_LINUX_ARM_SDEI_H
> +#define _UAPI_LINUX_ARM_SDEI_H
> +
> +#define SDEI_1_0_FN_BASE			0xC4000020
> +#define SDEI_1_0_MASK				0xFFFFFFE0
> +#define SDEI_1_0_FN(n)				(SDEI_1_0_FN_BASE + (n))
> +
> +#define SDEI_1_0_FN_SDEI_VERSION			SDEI_1_0_FN(0x00)
> +#define SDEI_1_0_FN_SDEI_EVENT_REGISTER			SDEI_1_0_FN(0x01)
> +#define SDEI_1_0_FN_SDEI_EVENT_ENABLE			SDEI_1_0_FN(0x02)
> +#define SDEI_1_0_FN_SDEI_EVENT_DISABLE			SDEI_1_0_FN(0x03)
> +#define SDEI_1_0_FN_SDEI_EVENT_CONTEXT			SDEI_1_0_FN(0x04)
> +#define SDEI_1_0_FN_SDEI_EVENT_COMPLETE			SDEI_1_0_FN(0x05)
> +#define SDEI_1_0_FN_SDEI_EVENT_COMPLETE_AND_RESUME	SDEI_1_0_FN(0x06)
> +#define SDEI_1_0_FN_SDEI_EVENT_UNREGISTER		SDEI_1_0_FN(0x07)
> +#define SDEI_1_0_FN_SDEI_EVENT_STATUS			SDEI_1_0_FN(0x08)
> +#define SDEI_1_0_FN_SDEI_EVENT_GET_INFO			SDEI_1_0_FN(0x09)
> +#define SDEI_1_0_FN_SDEI_EVENT_ROUTING_SET		SDEI_1_0_FN(0x0A)
> +#define SDEI_1_0_FN_SDEI_PE_MASK			SDEI_1_0_FN(0x0B)
> +#define SDEI_1_0_FN_SDEI_PE_UNMASK			SDEI_1_0_FN(0x0C)
> +#define SDEI_1_0_FN_SDEI_INTERRUPT_BIND			SDEI_1_0_FN(0x0D)
> +#define SDEI_1_0_FN_SDEI_INTERRUPT_RELEASE		SDEI_1_0_FN(0x0E)
> +#define SDEI_1_0_FN_SDEI_PRIVATE_RESET			SDEI_1_0_FN(0x11)
> +#define SDEI_1_0_FN_SDEI_SHARED_RESET			SDEI_1_0_FN(0x12)
> +
> +#define SDEI_VERSION_MAJOR_SHIFT			48
> +#define SDEI_VERSION_MAJOR_MASK				0x7fff
> +#define SDEI_VERSION_MINOR_SHIFT			32
> +#define SDEI_VERSION_MINOR_MASK				0xffff
> +#define SDEI_VERSION_VENDOR_SHIFT			0
> +#define SDEI_VERSION_VENDOR_MASK			0xffffffff
> +
> +#define SDEI_VERSION_MAJOR(x)	(x>>SDEI_VERSION_MAJOR_SHIFT & SDEI_VERSION_MAJOR_MASK)
> +#define SDEI_VERSION_MINOR(x)	(x>>SDEI_VERSION_MINOR_SHIFT & SDEI_VERSION_MINOR_MASK)
> +#define SDEI_VERSION_VENDOR(x)	(x>>SDEI_VERSION_VENDOR_SHIFT & SDEI_VERSION_VENDOR_MASK)
> +
> +/* SDEI return values */
> +#define SDEI_SUCCESS		0
> +#define SDEI_NOT_SUPPORTED	-1
> +#define SDEI_INVALID_PARAMETERS	-2
> +#define SDEI_DENIED		-3
> +#define SDEI_PENDING		-5
> +#define SDEI_OUT_OF_RESOURCE	-10
> +
> +/* EVENT_REGISTER flags */
> +#define SDEI_EVENT_REGISTER_RM_ANY	0
> +#define SDEI_EVENT_REGISTER_RM_PE	1
> +
> +/* EVENT_STATUS return value bits */
> +#define SDEI_EVENT_STATUS_RUNNING	2
> +#define SDEI_EVENT_STATUS_ENABLED	1
> +#define SDEI_EVENT_STATUS_REGISTERED	0
> +
> +/* EVENT_COMPLETE status values */
> +#define SDEI_EV_HANDLED	0
> +#define SDEI_EV_FAILED	1
> +
> +/* GET_INFO values */
> +#define SDEI_EVENT_INFO_EV_TYPE			0
> +#define SDEI_EVENT_INFO_EV_SIGNALED		1
> +#define SDEI_EVENT_INFO_EV_PRIORITY		2
> +#define SDEI_EVENT_INFO_EV_ROUTING_MODE		3
> +#define SDEI_EVENT_INFO_EV_ROUTING_AFF		4
> +
> +/* and their results */
> +#define SDEI_EVENT_TYPE_PRIVATE			0
> +#define SDEI_EVENT_TYPE_SHARED			1
> +#define SDEI_EVENT_PRIORITY_NORMAL		0
> +#define SDEI_EVENT_PRIORITY_CRITICAL		1
> +
> +#endif /* _UAPI_LINUX_ARM_SDEI_H */
> -- 
> 1.8.3.1
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
