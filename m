Return-Path: <SRS0=Cc05=O3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A8F5C433F5
	for <kvmarm@archiver.kernel.org>; Thu,  7 Oct 2021 14:42:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 059D861130
	for <kvmarm@archiver.kernel.org>; Thu,  7 Oct 2021 14:42:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 059D861130
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 860544B30D;
	Thu,  7 Oct 2021 10:42:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GrrGkZ6+6hGf; Thu,  7 Oct 2021 10:42:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 59AEE4B252;
	Thu,  7 Oct 2021 10:42:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AA4224B252
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Oct 2021 10:42:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id etVbpPJ8lW+J for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 Oct 2021 10:42:25 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9CA8F4B235
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Oct 2021 10:42:25 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1633617745;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=xazcSRU4hXAvOQ5GWPa9VCWbDLefBI+rO4m0xJqTNOQ=;
 b=CCE/n7UIwT49+x2BVWcWQm5UQ8sRP1TSN0B8J2CY8oWjaxZ3JF711/1H13jcaC5qWAQ1ey
 L8EVq9prMdRM7ka8JgFaY+AkEEVlLdLbZ6oi/6RUqWujx50Ah6Q4wypbi/4UeFmAfhhowH
 WRS7afKwwGUcdEQsGZFVvUQTan44c0w=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-506-3jLkQQI1N9eViAOfzE48Ww-1; Thu, 07 Oct 2021 10:42:22 -0400
X-MC-Unique: 3jLkQQI1N9eViAOfzE48Ww-1
Received: by mail-wr1-f72.google.com with SMTP id
 s18-20020adfbc12000000b00160b2d4d5ebso4908046wrg.7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 07 Oct 2021 07:42:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=xazcSRU4hXAvOQ5GWPa9VCWbDLefBI+rO4m0xJqTNOQ=;
 b=lE2pHguNf9Cu+ycAECNTpnGcsByh/pEeQMubE9F7mumLBaef068CTAtclBwvxx+uu1
 DwcCv8Az/0FEYjuRHXSRYWol6NBakHc+5+KlOKrb7qzLnUwBUjvt/LOpFGeUidBrzqXB
 Y+qIcLeZAiaLLp4qhr7o0WuqLwLAnakBT9pI9fIKhZuBX5MPqUSK8Dbk9C29twBTyHWK
 P/1iGcxm+QYZqCzIvipoyzqjJmpBINS3mMavpPtmRuZvHYfYzn3tBvaphjFcwulDaHGB
 Z2owu4g0tcUnAmPQnIfGLvFMtykLvUEQ3CobaFdURSVMxvLA+BQdqHrCZn9eQYHprYdD
 JrsQ==
X-Gm-Message-State: AOAM531rLX2u/kw9iyyhSVag7wPQAHMThEnZfAqU2CW21j2Ua6WDol67
 gTeDy5QwA+/xVYnuZLrjL6dyxpPZUMB69Hdwh0JUzZ+8L3MOdsXPjhXw1MprOxVMUawaK1j9L0V
 Wbnt2GuOtsOwNZ/PugBk1x2xi
X-Received: by 2002:a1c:a914:: with SMTP id s20mr5090574wme.6.1633617741291;
 Thu, 07 Oct 2021 07:42:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwmbskMeR1xk9N+RgV327boeCxt5BJetcoJmu76NCY9APJsJpEu2sTGpBXGDLxTNSiHEwr3Vg==
X-Received: by 2002:a1c:a914:: with SMTP id s20mr5090538wme.6.1633617741066;
 Thu, 07 Oct 2021 07:42:21 -0700 (PDT)
Received: from gator (nat-pool-brq-u.redhat.com. [213.175.37.12])
 by smtp.gmail.com with ESMTPSA id c132sm9169302wma.22.2021.10.07.07.42.15
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 07 Oct 2021 07:42:18 -0700 (PDT)
Date: Thu, 7 Oct 2021 16:42:14 +0200
From: Andrew Jones <drjones@redhat.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 10/16] KVM: arm64: Add some documentation for the MMIO
 guard feature
Message-ID: <20211007144214.pti5b2wjio6wneye@gator>
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

Already gave my r-b for this document, but after double checking I see
that this r2 argument doesn't appeared used by the implementation
yet. Is this left over from an older design or reserved for later use?

Thanks,
drew


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

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
