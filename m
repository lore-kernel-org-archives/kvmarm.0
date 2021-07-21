Return-Path: <SRS0=81/H=MN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2D3DC6377C
	for <kvmarm@archiver.kernel.org>; Wed, 21 Jul 2021 21:17:53 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 37BE261285
	for <kvmarm@archiver.kernel.org>; Wed, 21 Jul 2021 21:17:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 37BE261285
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A7C3249FB7;
	Wed, 21 Jul 2021 17:17:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id l6DWrlF6aJX2; Wed, 21 Jul 2021 17:17:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7FA354B0CF;
	Wed, 21 Jul 2021 17:17:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E915E49FB7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Jul 2021 17:17:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1hJgQi4xeksi for <kvmarm@lists.cs.columbia.edu>;
 Wed, 21 Jul 2021 17:17:49 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C193A49E8C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Jul 2021 17:17:49 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1626902269;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=xS7zB88wP1Ct8tl3wZJBYvmGfA8uHUm0YRA5Jgo14nI=;
 b=RiJ1I3fhYr630IOji9XRmWIPPARE8oNVKson8hvGyAuq5TR+oBIgxYhOkN4y2KucvynwwD
 0oWAaiDrx1Gr5Mc7v2YhKhy61fZ1h+WYdRiaVWEVPLbvhcCZpAg2kviPFnwGzB7CeLtsz3
 KqrleK/8Dm+La8J2TDHkvUX88imb6AE=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-574-WQIpWBEYMQOfd9PNLnwqAw-1; Wed, 21 Jul 2021 17:17:47 -0400
X-MC-Unique: WQIpWBEYMQOfd9PNLnwqAw-1
Received: by mail-il1-f200.google.com with SMTP id
 c7-20020a92b7470000b0290205c6edd752so2285725ilm.14
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Jul 2021 14:17:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=xS7zB88wP1Ct8tl3wZJBYvmGfA8uHUm0YRA5Jgo14nI=;
 b=or23/763d6nyLm7pxVyzNAoFSCe9a4oDm+rAkMc5vyeYQTf7QHBuvtEvXi2YXYuQu3
 DFbyBfVDuqGNw3fkC1zmxMBM7jJC5JXQyMcyydjwMdUBY0Sw96gSHmMczPv0dSsWH9Ht
 vkAgJL0TeIC2UnwONNYaTFetZwTvbcEOQwUOKsvhI2qzKKp9QTj6/xzGNFuhXZQu0A/x
 jA4LRPxr7FwafnH8Gg90Ypy6di/Ahh7bg527+qls1qDkfHT1YPu6Dtm3GOWbPwFwfzU0
 XJjUBoXFOrnbMjglvP0wWqoDdomSvQQ/SjEZi1Q0gxU2wf2qvH7hjaCvS/lFx5Lg389w
 wMQA==
X-Gm-Message-State: AOAM531IisBRbxEW2f23GpAcgn84QVRj8TvwCdTdp8P3qfBxhthKjxyI
 2yq2ggYAABEYgCB4zOspKyaDxtS8odSjey+44gETMyzNi3+gWnGvTQq+TBVORopiuQV5FPmk4DF
 v0OWF4BUHlwQRKZM6K427lOV1
X-Received: by 2002:a05:6638:240c:: with SMTP id
 z12mr32205852jat.41.1626902266819; 
 Wed, 21 Jul 2021 14:17:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzBlvz5/fIzXCPHPyLAiDDc3sODGKzE5IDkrPThRVZQuX/uKMDGuLWG9b8A3eweAr3W8umHRw==
X-Received: by 2002:a05:6638:240c:: with SMTP id
 z12mr32205837jat.41.1626902266587; 
 Wed, 21 Jul 2021 14:17:46 -0700 (PDT)
Received: from gator ([140.82.166.162])
 by smtp.gmail.com with ESMTPSA id w21sm14507636iol.52.2021.07.21.14.17.45
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 21 Jul 2021 14:17:45 -0700 (PDT)
Date: Wed, 21 Jul 2021 23:17:43 +0200
From: Andrew Jones <drjones@redhat.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 10/16] KVM: arm64: Add some documentation for the MMIO
 guard feature
Message-ID: <20210721211743.hb2cxghhwl2y22yh@gator>
References: <20210715163159.1480168-1-maz@kernel.org>
 <20210715163159.1480168-11-maz@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20210715163159.1480168-11-maz@kernel.org>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kvm@vger.kernel.org, will@kernel.org,
 Srivatsa Vaddagiri <vatsa@codeaurora.org>, linux-kernel@vger.kernel.org,
 Shanker R Donthineni <sdonthineni@nvidia.com>, kernel-team@android.com,
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

On Thu, Jul 15, 2021 at 05:31:53PM +0100, Marc Zyngier wrote:
> Document the hypercalls user for the MMIO guard infrastructure.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  Documentation/virt/kvm/arm/index.rst      |  1 +
>  Documentation/virt/kvm/arm/mmio-guard.rst | 73 +++++++++++++++++++++++
>  2 files changed, 74 insertions(+)
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
> index 000000000000..a5563a3e12cc
> --- /dev/null
> +++ b/Documentation/virt/kvm/arm/mmio-guard.rst
> @@ -0,0 +1,73 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +==============
> +KVM MMIO guard
> +==============
> +
> +KVM implements device emulation by handling translation faults to any
> +IPA range that is not contained a memory slot. Such translation fault
                                  ^ in                ^ a

> +is in most cases passed on to userspace (or in rare cases to the host
> +kernel) with the address, size and possibly data of the access for
> +emulation.
> +
> +Should the guest exit with an address that is not one that corresponds
> +to an emulatable device, userspace may take measures that are not the
> +most graceful as far as the guest is concerned (such as terminating it
> +or delivering a fatal exception).
> +
> +There is also an element of trust: by forwarding the request to
> +userspace, the kernel asumes that the guest trusts userspace to do the

assumes
  
> +right thing.
> +
> +The KVM MMIO guard offers a way to mitigate this last point: a guest
> +can request that only certainly regions of the IPA space are valid as

certain

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
> +		                  bytes (r0)
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
> +    ==============    ========    ======================================
> +    Function ID:      (uint32)    0xC6000004
> +    Arguments:        (uint64)    The base of the PG-sized IPA range
> +                                  that is allowed to be accessed as
> +				  MMIO. Must aligned to the PG size (r1)

align

> +                      (uint64)    Index in the MAIR_EL1 register
> +		                  providing the memory attribute that
> +				  is used by the guest (r2)
> +    Return Values:    (int64)     NOT_SUPPORTED(-1) on error, or
> +                                  RET_SUCCESS(0) (r0)
> +    ==============    ========    ======================================
> +
> +* ARM_SMCCC_KVM_FUNC_MMIO_GUARD_UNMAP
> +
> +    ==============    ========    ======================================
> +    Function ID:      (uint32)    0xC6000004

copy+paste error, should be 0xC6000005

> +    Arguments:        (uint64)    The base of the PG-sized IPA range
> +                                  that is forbidden to be accessed as

is now forbidden

or

was allowed

or just drop that part of the sentence because its covered by the "and
have been previously mapped" part. Something like

PG-sized IPA range aligned to the PG size which has been previously mapped
(r1)

> +				  MMIO. Must aligned to the PG size

align

> +				  and have been previously mapped (r1)
> +    Return Values:    (int64)     NOT_SUPPORTED(-1) on error, or
> +                                  RET_SUCCESS(0) (r0)
> +    ==============    ========    ======================================
> -- 
> 2.30.2
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
> 

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
