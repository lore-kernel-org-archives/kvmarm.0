Return-Path: <SRS0=qtHs=O2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E74A6C433F5
	for <kvmarm@archiver.kernel.org>; Wed,  6 Oct 2021 09:46:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 625A161166
	for <kvmarm@archiver.kernel.org>; Wed,  6 Oct 2021 09:46:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 625A161166
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CF5774B261;
	Wed,  6 Oct 2021 05:46:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id H+-U8pvjd2zt; Wed,  6 Oct 2021 05:46:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B6CC94B2B4;
	Wed,  6 Oct 2021 05:46:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6CDA24B29C
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Oct 2021 05:46:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id asTAJWahGTxO for <kvmarm@lists.cs.columbia.edu>;
 Wed,  6 Oct 2021 05:46:14 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 85AA14B261
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Oct 2021 05:46:14 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1633513574;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=Isv83yUMYdjJZv7dbRJw65ylR0cbrGVXZMMS10Fa4Xc=;
 b=fh0webZFHXTCkIjzsZ0Un0Jo4LILIi+X09BP8Tbl//bUpkxqI7YGprdkLe0BFVmuDfGFyr
 vvFb7Nf5XC9WcqDEwUpj0B5xkLOfE7o7THJVw5R2ogq/OF1leCv+xD65P3X/8w4+cXoZER
 tq10bSAxC5bZyQaQDQWUqHCK3OS0lHg=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-518-9-uMCB1lPomO5Pu_KOJfhQ-1; Wed, 06 Oct 2021 05:46:13 -0400
X-MC-Unique: 9-uMCB1lPomO5Pu_KOJfhQ-1
Received: by mail-ed1-f70.google.com with SMTP id
 r21-20020a50c015000000b003db1c08edd3so2079967edb.15
 for <kvmarm@lists.cs.columbia.edu>; Wed, 06 Oct 2021 02:46:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=Isv83yUMYdjJZv7dbRJw65ylR0cbrGVXZMMS10Fa4Xc=;
 b=kC0VPL7Z7d5plVTmamOiE1XMVVZ0sFO9bo2Ets4Qmh0fstwGL6RDqy03iPz5eup1N7
 +3NjMGvFTeJ7NEgFfBHauPmCLq7pm1zUeEloMRyjDZp0nE0PcEKfGCcMpdaC7PfUoaU7
 BQvqOHZS0uXMG8LEpBw9zGnuLzbiXwyyVLEG1hGJodDs+gxkhMq2t9or0/F9S31KFLkx
 d3xVp4ymfDx+ZdR8GgWe4bsz2qHP05+oNGAg+i93+sRoWMw4aYo0w7sY8P3RpAIJ705O
 bOq2YbtkBu5BIM8mN3P+Yn8GQ/OqbTRC8F4d3O0vq4UNFmglenrXwm/aZFsY2NRa1H8j
 q0Wg==
X-Gm-Message-State: AOAM530DzTy/4OrvwC9EAnwuoOwBneZplDSY5laxHsVgWBz24poLHwWz
 Y+Ud96LM9SfdmMgX6eT4ubafHClHx7RcvfXleTy9iyuo4WiJFMIgrNYktjwnDWqBWvhoHfGGLDH
 UQXK1vgODxYY4w09yPUj+T8sF
X-Received: by 2002:a17:906:a59:: with SMTP id
 x25mr30837161ejf.33.1633513571895; 
 Wed, 06 Oct 2021 02:46:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJypI1RG6bNERNdraDCnperFmmiC0GJAWwP2rbWeg6esoxpIgv/gXYPEvOrtVhDivn1SOhbdEg==
X-Received: by 2002:a17:906:a59:: with SMTP id
 x25mr30837124ejf.33.1633513571564; 
 Wed, 06 Oct 2021 02:46:11 -0700 (PDT)
Received: from gator.home (cst2-174-28.cust.vodafone.cz. [31.30.174.28])
 by smtp.gmail.com with ESMTPSA id x13sm8607889ejv.64.2021.10.06.02.46.10
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 06 Oct 2021 02:46:11 -0700 (PDT)
Date: Wed, 6 Oct 2021 11:46:09 +0200
From: Andrew Jones <drjones@redhat.com>
To: Ricardo Koller <ricarkol@google.com>
Subject: Re: [PATCH v4 06/11] KVM: arm64: selftests: Make vgic_init gic
 version agnostic
Message-ID: <20211006094609.tbocj6phk2hmdydj@gator.home>
References: <20211005011921.437353-1-ricarkol@google.com>
 <20211005011921.437353-7-ricarkol@google.com>
MIME-Version: 1.0
In-Reply-To: <20211005011921.437353-7-ricarkol@google.com>
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

On Mon, Oct 04, 2021 at 06:19:16PM -0700, Ricardo Koller wrote:
> As a preparation for the next commits which will add some tests for
> GICv2, make aarch64/vgic_init GIC version agnostic. Add a new generic
> run_tests function(gic_dev_type) that starts all applicable tests using
> GICv3 or GICv2. GICv2 tests are attempted if GICv3 is not available in
> the system. There are currently no GICv2 tests, but the test passes now
> in GICv2 systems.
> 
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  .../testing/selftests/kvm/aarch64/vgic_init.c | 156 +++++++++++-------
>  1 file changed, 95 insertions(+), 61 deletions(-)
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
