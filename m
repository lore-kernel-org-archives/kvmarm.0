Return-Path: <SRS0=Cc05=O3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53B78C43217
	for <kvmarm@archiver.kernel.org>; Thu,  7 Oct 2021 14:39:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C1BE261175
	for <kvmarm@archiver.kernel.org>; Thu,  7 Oct 2021 14:39:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org C1BE261175
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 37E1B4B313;
	Thu,  7 Oct 2021 10:39:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6cUvqZFxJ8NC; Thu,  7 Oct 2021 10:38:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D2CB64B2EA;
	Thu,  7 Oct 2021 10:38:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C386B4B2E7
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Oct 2021 10:38:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8tSVlBMBsiqP for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 Oct 2021 10:38:56 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B0E1C4B273
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Oct 2021 10:38:56 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1633617536;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=NGm1yWS8geF2sO0H/4Ce/J+RgIXVQpoAvhPhIp+yNF0=;
 b=iY/EjFClUtHIbvmZ42U6+VdHEwF/PvLHqAepZ6uQnuVcBejROEMDJLAf6dHZi/L86tE5OZ
 cnNwN1gBkLPAgRVGG0CBnuaxsBEEpuxJ/qbKwujNBvVc7qVxTBFFEAsC4MepIWDcKU0iP2
 69dwGYMBH49pRLGprdLxoYeDYRfRaAw=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-564-nIRErnAyMD-j0Yrxq7S69Q-1; Thu, 07 Oct 2021 10:38:55 -0400
X-MC-Unique: nIRErnAyMD-j0Yrxq7S69Q-1
Received: by mail-wr1-f72.google.com with SMTP id
 h11-20020adfa4cb000000b00160c791a550so4693027wrb.6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 07 Oct 2021 07:38:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=NGm1yWS8geF2sO0H/4Ce/J+RgIXVQpoAvhPhIp+yNF0=;
 b=DsY7cX1s9AQ9gPnyi05NDgHknAT/+Fd2Wr5C7enNo9sUiX6aPHLFaoA70Yi7qck+/A
 5bjmFaGW6OetNlxyIYviMDyk11VGvX+wOMxprWzBfL/tbExFld1INPAysyW4sudBuLF+
 ZYlkAf2HFuWMIczNBFx9AyFcK6XJ3Z698wdiE6PthQqDSDvNDn0c/JwkugSkKWKvAKAv
 xxeoyV0OHsofMx8zLG67XOPSmSN7b9R3+tUkaVHLERpocve1Rtemliar+RLpy+xnRMwj
 mHC4aVDaZUHiriWUYCR7mqsE5lPLZvlo69k81+Fh8Y7bS1Svm/GXKcAyXaeFxPcJVQbA
 nhnw==
X-Gm-Message-State: AOAM5324U22V7jA1JJxgPy5hD23DeXoWotpJ3sUVXZY4CooO5Tj2MFi1
 M96PUhHrCRQPHYLTmWEs90maeggleRua0VyzI3xz1HYYzS/BCjGnhsQYpH0yFC8JeErJ0kGlR+P
 VpfImnOcao4MZc5NxuJwrs7xe
X-Received: by 2002:adf:bb09:: with SMTP id r9mr6004161wrg.238.1633617534503; 
 Thu, 07 Oct 2021 07:38:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxO9BCo0zdcmxbDxAudW4jdTSomLkbbEHDoD+axd3gGY/vYr4NNhmBMpyQQvOrtL3YclzCczw==
X-Received: by 2002:adf:bb09:: with SMTP id r9mr6004113wrg.238.1633617534208; 
 Thu, 07 Oct 2021 07:38:54 -0700 (PDT)
Received: from gator (nat-pool-brq-u.redhat.com. [213.175.37.12])
 by smtp.gmail.com with ESMTPSA id a2sm9231329wrv.15.2021.10.07.07.38.53
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 07 Oct 2021 07:38:53 -0700 (PDT)
Date: Thu, 7 Oct 2021 16:38:52 +0200
From: Andrew Jones <drjones@redhat.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 10/16] KVM: arm64: Add some documentation for the MMIO
 guard feature
Message-ID: <20211007143852.pyae42sbovi4vk23@gator>
References: <20211004174849.2831548-1-maz@kernel.org>
 <20211004174849.2831548-11-maz@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20211004174849.2831548-11-maz@kernel.org>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kernel-team@android.com, kvm@vger.kernel.org,
 Srivatsa Vaddagiri <vatsa@codeaurora.org>, linux-kernel@vger.kernel.org,
 Steven Price <steven.price@arm.com>,
 Shanker R Donthineni <sdonthineni@nvidia.com>, will@kernel.org,
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

On Mon, Oct 04, 2021 at 06:48:43PM +0100, Marc Zyngier wrote:
> Document the hypercalls user for the MMIO guard infrastructure.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  Documentation/virt/kvm/arm/index.rst      |  1 +
>  Documentation/virt/kvm/arm/mmio-guard.rst | 74 +++++++++++++++++++++++
>  2 files changed, 75 insertions(+)
>  create mode 100644 Documentation/virt/kvm/arm/mmio-guard.rst
> 
> diff --git a/Documentation/virt/kvm/arm/index.rst b/Documentation/virt/kvm/arm/index.rst
> index 78a9b670aafe..e77a0ee2e2d4 100644
> --- a/Documentation/virt/kvm/arm/index.rst
> +++ b/Documentation/virt/kvm/arm/index.rst
> @@ -11,3 +11,4 @@ ARM
>     psci
>     pvtime
>     ptp_kvm
> +   mmio-guard
> diff --git a/Documentation/virt/kvm/arm/mmio-guard.rst b/Documentation/virt/kvm/arm/mmio-guard.rst
> new file mode 100644
> index 000000000000..8b3c852c5d92
> --- /dev/null
> +++ b/Documentation/virt/kvm/arm/mmio-guard.rst
> @@ -0,0 +1,74 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +==============
> +KVM MMIO guard
> +==============
> +
> +KVM implements device emulation by handling translation faults to any
> +IPA range that is not contained in a memory slot. Such a translation
> +fault is in most cases passed on to userspace (or in rare cases to the
> +host kernel) with the address, size and possibly data of the access
> +for emulation.
> +
> +Should the guest exit with an address that is not one that corresponds
> +to an emulatable device, userspace may take measures that are not the
> +most graceful as far as the guest is concerned (such as terminating it
> +or delivering a fatal exception).
> +
> +There is also an element of trust: by forwarding the request to
> +userspace, the kernel assumes that the guest trusts userspace to do
> +the right thing.
> +
> +The KVM MMIO guard offers a way to mitigate this last point: a guest
> +can request that only certain regions of the IPA space are valid as
> +MMIO. Only these regions will be handled as an MMIO, and any other
> +will result in an exception being delivered to the guest.
> +
> +This relies on a set of hypercalls defined in the KVM-specific range,
> +using the HVC64 calling convention.
> +
> +* ARM_SMCCC_KVM_FUNC_MMIO_GUARD_INFO
> +
> +    ==============    ========    ================================
> +    Function ID:      (uint32)    0xC6000002
> +    Arguments:        none
> +    Return Values:    (int64)     NOT_SUPPORTED(-1) on error, or
> +                      (uint64)    Protection Granule (PG) size in
> +                                  bytes (r0)
> +    ==============    ========    ================================
> +
> +* ARM_SMCCC_KVM_FUNC_MMIO_GUARD_ENROLL
> +
> +    ==============    ========    ==============================
> +    Function ID:      (uint32)    0xC6000003
> +    Arguments:        none
> +    Return Values:    (int64)     NOT_SUPPORTED(-1) on error, or
> +                                  RET_SUCCESS(0) (r0)
> +    ==============    ========    ==============================
> +
> +* ARM_SMCCC_KVM_FUNC_MMIO_GUARD_MAP
> +
> +    ==============    ========    ====================================
> +    Function ID:      (uint32)    0xC6000004
> +    Arguments:        (uint64)    The base of the PG-sized IPA range
> +                                  that is allowed to be accessed as
> +                                  MMIO. Must be aligned to the PG size
> +                                  (r1)
> +                      (uint64)    Index in the MAIR_EL1 register
> +		                  providing the memory attribute that
> +				  is used by the guest (r2)
    ^^ some tabs got in here

> +    Return Values:    (int64)     NOT_SUPPORTED(-1) on error, or
> +                                  RET_SUCCESS(0) (r0)
> +    ==============    ========    ====================================
> +
> +* ARM_SMCCC_KVM_FUNC_MMIO_GUARD_UNMAP
> +
> +    ==============    ========    ======================================
> +    Function ID:      (uint32)    0xC6000005
> +    Arguments:        (uint64)    PG-sized IPA range aligned to the PG
> +                                  size which has been previously mapped.
> +                                  Must be aligned to the PG size and
> +                                  have been previously mapped (r1)
> +    Return Values:    (int64)     NOT_SUPPORTED(-1) on error, or
> +                                  RET_SUCCESS(0) (r0)
> +    ==============    ========    ======================================
> -- 
> 2.30.2
>

Otherwise,

Reviewed-by: Andrew Jones <drjones@redhat.com>

Thanks,
drew 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
