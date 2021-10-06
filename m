Return-Path: <SRS0=qtHs=O2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE86CC433EF
	for <kvmarm@archiver.kernel.org>; Wed,  6 Oct 2021 09:48:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3CB75610FC
	for <kvmarm@archiver.kernel.org>; Wed,  6 Oct 2021 09:48:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 3CB75610FC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A77EC4B2AB;
	Wed,  6 Oct 2021 05:48:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id H2J1FBP+MuJc; Wed,  6 Oct 2021 05:47:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0FE2E4B2B4;
	Wed,  6 Oct 2021 05:47:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EC51B4B2AB
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Oct 2021 05:47:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rGvpv+jc2t+K for <kvmarm@lists.cs.columbia.edu>;
 Wed,  6 Oct 2021 05:47:55 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EC8824B261
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Oct 2021 05:47:55 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1633513675;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=LIgH8gu1r21yeBq6abOkIDI2JxH09Ml9MBToyvOxu20=;
 b=Ij+hS50oMtZ6BoNvG6NReGoPwsCgqfY2mDH5RSK6m0cn8i8WKVgo1yFUdzJQyMSn51PacC
 5KLjF+SdtSRPEKB6kHMFdVeIJzE7VAJV1qA7CBcn5L7abVTeRw9uuz6zfv471uL6XrNJCU
 377ntj7KXusPjaNC1HY56toisdi/f3w=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-11-n4dKA6FhNIKYuR1ul5GTjQ-1; Wed, 06 Oct 2021 05:47:54 -0400
X-MC-Unique: n4dKA6FhNIKYuR1ul5GTjQ-1
Received: by mail-ed1-f70.google.com with SMTP id
 p20-20020a50cd94000000b003db23619472so2079124edi.19
 for <kvmarm@lists.cs.columbia.edu>; Wed, 06 Oct 2021 02:47:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=LIgH8gu1r21yeBq6abOkIDI2JxH09Ml9MBToyvOxu20=;
 b=wLLymrJbxOWxUK44D+HmVJybF/thoKdpRDUUWCjC6F++w9oO6BeHdjfPxyTdZxsdWe
 0+9qmjmV/a8OcYnKe8pCm8qY9CKo9hFbyEoO7sgoobwoz9dfUiJuzlgw7kJW+YxypbBr
 aV0rAeoaoCihgA09dRqlRPL7iBJjpYf96nTEZkS8UK6f8S0i2nssvqSwmMielWT/7SeV
 cg6phPz8twJixUDqo82zE3uIajYinxwr0hFzdn6s6RtH9boeVOaQYIgHTVicsmztpLiU
 /6nDz6jzHRU/5LTRzTKOgmf0rVhgRBxovMPDYgkZqJZVX/iWpUkiUX4NyYkCl8yfXUop
 y4GA==
X-Gm-Message-State: AOAM531adpF2dxMGuOs/M5gSfGIbqOuFOxiDVyVvQVHe1vR5JRpz/uQc
 CxSIA4EbPqoS8ga7inwpktj7AHskZIoyF/tOAbAYklPbNNVNg+ZMY0mbIwPBzRXIBDEVB5CI6CZ
 YrM6cb0aqK0EB/HrH/xoI/nMs
X-Received: by 2002:a17:906:2706:: with SMTP id
 z6mr31136663ejc.551.1633513673589; 
 Wed, 06 Oct 2021 02:47:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyLsv7QfJ9edq3MbAwDzJGPzcyo85uxhptP4qfeMda0Ru51+ZwihXwCVe1lDsAKEIfAjcnZJQ==
X-Received: by 2002:a17:906:2706:: with SMTP id
 z6mr31136628ejc.551.1633513673369; 
 Wed, 06 Oct 2021 02:47:53 -0700 (PDT)
Received: from gator.home (cst2-174-28.cust.vodafone.cz. [31.30.174.28])
 by smtp.gmail.com with ESMTPSA id v10sm1921159edw.96.2021.10.06.02.47.52
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 06 Oct 2021 02:47:53 -0700 (PDT)
Date: Wed, 6 Oct 2021 11:47:51 +0200
From: Andrew Jones <drjones@redhat.com>
To: Ricardo Koller <ricarkol@google.com>
Subject: Re: [PATCH v4 07/11] KVM: arm64: selftests: Make
 vgic_init/vm_gic_create version agnostic
Message-ID: <20211006094751.asalvm7ufhjovttg@gator.home>
References: <20211005011921.437353-1-ricarkol@google.com>
 <20211005011921.437353-8-ricarkol@google.com>
MIME-Version: 1.0
In-Reply-To: <20211005011921.437353-8-ricarkol@google.com>
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

On Mon, Oct 04, 2021 at 06:19:17PM -0700, Ricardo Koller wrote:
> Make vm_gic_create GIC version agnostic in the vgic_init test. Also
> add a nr_vcpus arg into it instead of defaulting to NR_VCPUS.
> 
> No functional change.
> 
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  .../testing/selftests/kvm/aarch64/vgic_init.c | 19 ++++++++++---------
>  1 file changed, 10 insertions(+), 9 deletions(-)
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
