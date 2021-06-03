Return-Path: <SRS0=Ht+8=K5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC292C47096
	for <kvmarm@archiver.kernel.org>; Thu,  3 Jun 2021 10:37:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 207E06138C
	for <kvmarm@archiver.kernel.org>; Thu,  3 Jun 2021 10:37:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 207E06138C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=nuviainc.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 90D854B0E8;
	Thu,  3 Jun 2021 06:37:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered)
	header.i=@nuviainc-com.20150623.gappssmtp.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id mo9k0BNaf5yn; Thu,  3 Jun 2021 06:37:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 433EF4B0CD;
	Thu,  3 Jun 2021 06:37:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 58A3E4B089
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Jun 2021 03:07:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YtshZLTKiuFY for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Jun 2021 03:07:25 -0400 (EDT)
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com
 [209.85.128.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 63D4A4A523
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Jun 2021 03:07:25 -0400 (EDT)
Received: by mail-wm1-f47.google.com with SMTP id m18so2742464wmq.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 03 Jun 2021 00:07:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=nuviainc-com.20150623.gappssmtp.com; s=20150623;
 h=date:from:to:cc:subject:message-id:mail-followup-to:references
 :mime-version:content-disposition:in-reply-to;
 bh=swTqT+JBPk12ncEzOYoOSk8MfnzP+PLyF+iYHFtT61c=;
 b=fuALpjEBCmQS3d00X52WWRgr/gePIoNMXojP7jyYk+Z9NXNArq9QJV0UMq93XENuxb
 fq3zTi+yMmLIxYtuRzzDcvMtbra02NbNl4bnKmiU582LjAX27DrulwpZOlKUCYb2BihK
 9QlAAfvoVfe4oQInhgY0qp8VPCUnYsYWcok8HJUpDqZVXGJOXIt/A6Lcg9Va7S7cZKMC
 l11FW3UwfNBSfXxAa8L9EmgQ+2/AdGuBIVINOb8QSSQ1WBzEdQL9sGj5RyX6KjdLA6xk
 9qMpJREaHSDGdWHz2BROw4Kd+IOpfZ50XVjpLUZmP55yTQn9CbfDIAyv/DRFq9L+TP3Z
 nP9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id
 :mail-followup-to:references:mime-version:content-disposition
 :in-reply-to;
 bh=swTqT+JBPk12ncEzOYoOSk8MfnzP+PLyF+iYHFtT61c=;
 b=pw5Q6bkh4OQP1R7qitCA/Yalk85PMjJfRbj6ZXKJT7MJwcbI2Zv8KUolvyMvHWH3aP
 wv1EMCIr8k++/qC2ngcfZaSzCD1J88BFXA0lVxIfTUBzAHzSQXS8d94hGXn9PfoOM5ap
 SQiDzk/yZB4Oh+d0ejNsTGaJMWln4gRBFYQUv0NgBRBJF1YipsslhIxwqhmS0wd3mK5B
 jBi98DX7b0AvzXUXGHDh6Ab+hxUxVqWkHDpeiK7Eg2aV1UJyX1urViDRxdWeZoQjacWY
 zZ/DO+syAZGNK/cJ92qcb0V+McZt0WseeAcrG/ey6ykIWXLSL+24Y/upK6cUeUDr84JY
 8Kgw==
X-Gm-Message-State: AOAM533/lC+b15x2sCrI3odrQsya8chJBHdGz1D+fqHlfFxSf78WPKAF
 9fvqgCPYdMnskz02PQCl9B1FSA==
X-Google-Smtp-Source: ABdhPJyKYnBJGEQb+Nkwb/uT2+RRLkdLFQM3//Ylsfzfcko0Ag534F59xhbPPyCcGmi7N7vecIQT8Q==
X-Received: by 2002:a05:600c:2209:: with SMTP id
 z9mr35507257wml.120.1622704044067; 
 Thu, 03 Jun 2021 00:07:24 -0700 (PDT)
Received: from localhost ([82.44.17.50])
 by smtp.gmail.com with ESMTPSA id o9sm2186295wrw.69.2021.06.03.00.07.23
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 03 Jun 2021 00:07:23 -0700 (PDT)
Date: Thu, 3 Jun 2021 08:07:22 +0100
From: Jamie Iles <jamie@nuviainc.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v4 00/66] KVM: arm64: ARMv8.3/8.4 Nested Virtualization
 support
Message-ID: <YLh/qsmKDJ86n75w@hazel>
Mail-Followup-To: Marc Zyngier <maz@kernel.org>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>,
 Jintack Lim <jintack@cs.columbia.edu>,
 Haibo Xu <haibo.xu@linaro.org>, James Morse <james.morse@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 kernel-team@android.com
References: <20210510165920.1913477-1-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210510165920.1913477-1-maz@kernel.org>
X-Mailman-Approved-At: Thu, 03 Jun 2021 06:37:42 -0400
Cc: kernel-team@android.com, kvm@vger.kernel.org,
 Andre Przywara <andre.przywara@arm.com>, kvmarm@lists.cs.columbia.edu,
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

Hi Marc,

On Mon, May 10, 2021 at 05:58:14PM +0100, Marc Zyngier wrote:
> Here the bi-annual drop of the KVM/arm64 NV support code.
> 
> Not a lot has changed since [1], except for a discovery mechanism for
> the EL2 support, some tidying up in the idreg emulation, dropping RMR
> support, and a rebase on top of 5.13-rc1.
> 
> As usual, blame me for any bug, and nobody else.
> 
> It is still massively painful to run on the FVP, but if you have a
> Neoverse V1 or N2 system that is collecting dust, I have the right
> stuff to keep it busy!

I've been testing this series on FVP and get a crash when returning from 
__kvm_vcpu_run_vhe because the autiasp is failing.

The problem is when the L1 boots and during EL2 setup sets hcr_el2 to 
HCR_HOST_NVHE_FLAGS and so enables HCR_APK|HCR_API.  Then the guest 
enter+exit logic in L0 starts performing the key save restore, but as we 
didn't go through __hyp_handle_ptrauth, we haven't saved the host keys 
and invoked vcpu_ptrauth_enable() so restore the host keys back to 0.

I wonder if the pointer auth keys should be saved+restored 
unconditionally for a guest when running nested rather than the lazy 
faulting that we have today?  Alternatively we would need to duplicate 
the lazy logic for hcr_el2 writes.  A quick hack of saving the host keys 
in __kvm_vcpu_run_vhe before sysreg_save_host_state_vhe is enough to 
allow me to boot an L1 with --nested and then an L2.

Do we also need to filter out HCR_APK|HCR_API for hcr_el2 writes when 
pointer authentication hasn't been exposed to the guest?  I haven't yet 
tried making ptrauth visible to the L1.

Thanks,

Jamie
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
