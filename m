Return-Path: <SRS0=qtHs=O2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85592C433F5
	for <kvmarm@archiver.kernel.org>; Wed,  6 Oct 2021 10:13:56 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 07FAD61184
	for <kvmarm@archiver.kernel.org>; Wed,  6 Oct 2021 10:13:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 07FAD61184
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 821444B2B2;
	Wed,  6 Oct 2021 06:13:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qGzPgCnSusSR; Wed,  6 Oct 2021 06:13:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 947F34B2A7;
	Wed,  6 Oct 2021 06:13:54 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A22634B2AE
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Oct 2021 06:13:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WU+OpB4INBCT for <kvmarm@lists.cs.columbia.edu>;
 Wed,  6 Oct 2021 06:13:52 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CD9B64B2A7
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Oct 2021 06:13:52 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1633515232;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=/J+FI9BmegXNC9OorjI5/QExOSyFnucr7CzcEa9NXjY=;
 b=J60m88vsS3NpwwbmYAMwtdJyuokcHUJU+xGKCa1eF0Aa4u52vypavfBdjPwQf0QvzxBunH
 2nKXhQli74oYV73P01fEmsgGAB2IQk/S/9Ec6R+z4UdgCEXjFvlLIcMA7+6XP9cawGfe2z
 oEysqcVH4l2ltVoQb+mnM142mUwS+cc=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-22-Iy3CcSqhM1uiCECqmmMEtQ-1; Wed, 06 Oct 2021 06:13:51 -0400
X-MC-Unique: Iy3CcSqhM1uiCECqmmMEtQ-1
Received: by mail-ed1-f72.google.com with SMTP id
 z6-20020a50cd06000000b003d2c2e38f1fso2204577edi.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 06 Oct 2021 03:13:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=/J+FI9BmegXNC9OorjI5/QExOSyFnucr7CzcEa9NXjY=;
 b=qdGq7XHXZV11n1C7drSm+wcnCP8Yo7IjxGWrvN9Jr0YOp1wcUNOAZXuYa1QWuiLB/y
 6aBKwoIzmy4AnAPxJSbx3MUDF33hVqxT2vWkTurxEydGxbhEBknLjWJaDHfSL2PrG8Vn
 JkYoeoirHohWQfklhxdZ40ZwcjTtPK3B79pz2JWqELSX8+BIxQTyAnOyLwwOTozU8onf
 wZzaLDIga/sBXJ1JryjiTRDHdTl8c7OdY5QBm1k8MM6AljVCMBMsOVks10TpL4pKkCpH
 fe81GJaRXneXuJ3QlvnrHNbyYNAjiK29c9mcTOTQ/PkL59B+n5NUcSHi9TPkFZDBuizX
 wUlw==
X-Gm-Message-State: AOAM5301+u0fV1EQukCeB/mD2IOedBx+ubGMhE4pE7wIwVTWwQ8kbF67
 lB/i8pPN0wdvwSNGBYez+vwhqQjIKiHHFXvHoWRhurTUpDmRL6iRonTzkbFT1jPBVmppOobE2NB
 HRUu8vI8rtx/bMEpK3EmRkWKw
X-Received: by 2002:a50:9d49:: with SMTP id j9mr32029500edk.39.1633515230283; 
 Wed, 06 Oct 2021 03:13:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyqHiAUfNXJLrOpbjMnYwSPrvrVfqR+aEtx42GvvD8RJOVmpaWCmZRwYhEQ8Ul4GC5ywSc7ig==
X-Received: by 2002:a50:9d49:: with SMTP id j9mr32029469edk.39.1633515230134; 
 Wed, 06 Oct 2021 03:13:50 -0700 (PDT)
Received: from gator.home (cst2-174-28.cust.vodafone.cz. [31.30.174.28])
 by smtp.gmail.com with ESMTPSA id bf23sm3465236edb.88.2021.10.06.03.13.49
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 06 Oct 2021 03:13:49 -0700 (PDT)
Date: Wed, 6 Oct 2021 12:13:48 +0200
From: Andrew Jones <drjones@redhat.com>
To: Ricardo Koller <ricarkol@google.com>
Subject: Re: [PATCH v4 11/11] KVM: arm64: selftests: Add init ITS device test
Message-ID: <20211006101348.7d6z2oivnv2tteof@gator.home>
References: <20211005011921.437353-1-ricarkol@google.com>
 <20211005011921.437353-12-ricarkol@google.com>
MIME-Version: 1.0
In-Reply-To: <20211005011921.437353-12-ricarkol@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: shuah@kernel.org, kvm@vger.kernel.org, maz@kernel.org, pshier@google.com,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu
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

On Mon, Oct 04, 2021 at 06:19:21PM -0700, Ricardo Koller wrote:
> Add some ITS device init tests: general KVM device tests (address not
> defined already, address aligned) and tests for the ITS region being
> within the addressable IPA range.
> 
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  .../testing/selftests/kvm/aarch64/vgic_init.c | 42 +++++++++++++++++++
>  1 file changed, 42 insertions(+)
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
