Return-Path: <SRS0=JP/k=N7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A56CBC433EF
	for <kvmarm@archiver.kernel.org>; Thu,  9 Sep 2021 05:19:03 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1FCBF6113A
	for <kvmarm@archiver.kernel.org>; Thu,  9 Sep 2021 05:19:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 1FCBF6113A
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9524F4B0FC;
	Thu,  9 Sep 2021 01:19:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zD1t8vvxVuvl; Thu,  9 Sep 2021 01:19:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6D091406E0;
	Thu,  9 Sep 2021 01:19:01 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 47503406E0
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Sep 2021 01:19:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nfNmPv5SfMZW for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Sep 2021 01:18:58 -0400 (EDT)
Received: from mail-io1-f51.google.com (mail-io1-f51.google.com
 [209.85.166.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5DC374029C
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Sep 2021 01:18:58 -0400 (EDT)
Received: by mail-io1-f51.google.com with SMTP id f6so813024iox.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 08 Sep 2021 22:18:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=+CYFnjvQGu3qEtGCtuJvH4Bp2b8Zt/XnVuPY3zDRm/4=;
 b=iASH6O9lWrdEVAkELUB1zBmanzld5X4HWNeQXJAqq4lnMka+pE0wihP0EZNLG+Dy+8
 W6SPfpydSSrMwC1ldEnMQcQ2aAfiXV9pjugauT1C/yeoYYfo3z39B/61zOyQLd17GKJP
 6Dv57E9J6sge/+PgOd3g6uDp+SypcWMPm2LBSXk9qCCHQr0UhKzxV4+t2+IISw3gLV/c
 6a0a5VVclG8dgvz5n5ud8UQ/AjDjXL/wrCPHtQk0u5w0X/1JPM67/pV79+7NFP6DCyWT
 oEuKEMfPe7ohxC+nb3cByLN2hAZCwAPuUYSf90DB6qFu6yUErJA6M6iNesHjRNL6mZSs
 V4Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=+CYFnjvQGu3qEtGCtuJvH4Bp2b8Zt/XnVuPY3zDRm/4=;
 b=2gzwX8be7L4KMShMyz/ohfubS/sDFgOeQAOOLYxniiBe/SO10vgjjLU4JnR8OEz6oM
 B3S+0EFgU765i6nqajXpP2tx7uU48EF852X4wRt6tkGPV9zKMv0+3xHeyC13KaSiLYFl
 X2ss1xYljj8ZqEr7MC1958Af8yTdZ31nsixal3iO2wZVMSzmAz7P+q4HFbAd+D7gMWmf
 V2hdWyqTUlzixvorhVwbCAmU699iHq2VS3kAZLuOZXhZinhErozrj97Ojw92bEfgEAIF
 ctiRQU7RJ04vIa34x4UI7ez6cHbZWYXh6oITYSJVRIJUnqNSu1p/KXr6P9OQgYziUHNy
 xbag==
X-Gm-Message-State: AOAM530oEW6IPmi7EPw9zIwWTm0I7z+LFuGPSWf5kC9We741QoqkF4xE
 5GyHLcUB///P7jBbfXn1qapi4g==
X-Google-Smtp-Source: ABdhPJzq92DTfukBJOnIWgAl3htCHd8+vLrGENISalBbgwBC7v97HZRdGs9hOdm2RvVO8uV/scNEeg==
X-Received: by 2002:a6b:8f4e:: with SMTP id r75mr1131550iod.172.1631164737554; 
 Wed, 08 Sep 2021 22:18:57 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194])
 by smtp.gmail.com with ESMTPSA id z26sm426323iol.6.2021.09.08.22.18.56
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 08 Sep 2021 22:18:56 -0700 (PDT)
Date: Thu, 9 Sep 2021 05:18:53 +0000
From: Oliver Upton <oupton@google.com>
To: Raghavendra Rao Ananta <rananta@google.com>
Subject: Re: [PATCH v4 11/18] KVM: arm64: selftests: Add basic GICv3 support
Message-ID: <YTmZPSEm3Fj6l1PN@google.com>
References: <20210909013818.1191270-1-rananta@google.com>
 <20210909013818.1191270-12-rananta@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210909013818.1191270-12-rananta@google.com>
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
 linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
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

On Thu, Sep 09, 2021 at 01:38:11AM +0000, Raghavendra Rao Ananta wrote:
> Add basic support for ARM Generic Interrupt Controller v3.
> The support provides guests to setup interrupts.
> 
> The work is inspired from kvm-unit-tests and the kernel's
> GIC driver (drivers/irqchip/irq-gic-v3.c).
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> Reviewed-by: Andrew Jones <drjones@redhat.com>
> ---
>  tools/testing/selftests/kvm/Makefile          |   2 +-
>  .../selftests/kvm/include/aarch64/gic.h       |  21 ++
>  tools/testing/selftests/kvm/lib/aarch64/gic.c |  93 +++++++
>  .../selftests/kvm/lib/aarch64/gic_private.h   |  21 ++
>  .../selftests/kvm/lib/aarch64/gic_v3.c        | 240 ++++++++++++++++++
>  .../selftests/kvm/lib/aarch64/gic_v3.h        |  70 +++++
>  6 files changed, 446 insertions(+), 1 deletion(-)
>  create mode 100644 tools/testing/selftests/kvm/include/aarch64/gic.h
>  create mode 100644 tools/testing/selftests/kvm/lib/aarch64/gic.c
>  create mode 100644 tools/testing/selftests/kvm/lib/aarch64/gic_private.h
>  create mode 100644 tools/testing/selftests/kvm/lib/aarch64/gic_v3.c
>  create mode 100644 tools/testing/selftests/kvm/lib/aarch64/gic_v3.h
> 

[...]

> +static void
> +gic_dist_init(enum gic_type type, unsigned int nr_cpus, void *dist_base)
> +{
> +	const struct gic_common_ops *gic_ops;

does this need to be initialized? I haven't tried compiling, but it
seems it should trigger a compiler warning as it is only initialized if
type == GIC_V3.

> +	spin_lock(&gic_lock);
> +
> +	/* Distributor initialization is needed only once per VM */
> +	if (gic_common_ops) {
> +		spin_unlock(&gic_lock);
> +		return;
> +	}
> +
> +	if (type == GIC_V3)
> +		gic_ops = &gicv3_ops;
> +
> +	gic_ops->gic_init(nr_cpus, dist_base);
> +	gic_common_ops = gic_ops;
> +
> +	/* Make sure that the initialized data is visible to all the vCPUs */
> +	dsb(sy);
> +
> +	spin_unlock(&gic_lock);
> +}

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
