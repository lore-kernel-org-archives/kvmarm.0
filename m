Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EE6EC3A59D
	for <kvmarm@archiver.kernel.org>; Sat, 22 Oct 2022 07:33:08 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BA81140AEA;
	Sat, 22 Oct 2022 03:33:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id uAXt3wTHRJx0; Sat, 22 Oct 2022 03:33:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AFBEF49AF7;
	Sat, 22 Oct 2022 03:33:06 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AA734412AF
 for <kvmarm@lists.cs.columbia.edu>; Sat, 22 Oct 2022 03:33:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YSgdT+3Tt0N6 for <kvmarm@lists.cs.columbia.edu>;
 Sat, 22 Oct 2022 03:33:04 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 968BB4087B
 for <kvmarm@lists.cs.columbia.edu>; Sat, 22 Oct 2022 03:33:04 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1666423984;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=UD1oLm9Hn5bxNzWtEkUvZu/ox9ybbs3hLmz1f3bzisg=;
 b=dr8B6OgRNx6igZx2hEivGYc6VHw6pGThy5b9+ATEHZIGR/rQ06GTFJXr0MLFGBUXurggoP
 Xymey+5abCClk1DLSTQ75twVk5ddTuxeWh+c3oBY848Br7qEaukiAVi5Rki3s8sFZYoIV6
 PDztX7Sw0TIOcERCBxg+IIxnGLarUHc=
Received: from mail-ua1-f72.google.com (mail-ua1-f72.google.com
 [209.85.222.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-649-4OlglnlsM1G-0uISmsEayw-1; Sat, 22 Oct 2022 03:33:02 -0400
X-MC-Unique: 4OlglnlsM1G-0uISmsEayw-1
Received: by mail-ua1-f72.google.com with SMTP id
 v15-20020ab0558f000000b003ea524863e4so3007415uaa.0
 for <kvmarm@lists.cs.columbia.edu>; Sat, 22 Oct 2022 00:33:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=UD1oLm9Hn5bxNzWtEkUvZu/ox9ybbs3hLmz1f3bzisg=;
 b=taRFcDrKuBTJRKvpsVs+3DTnQxPefmI8qIMrKfy4njaK3/vo5JDfUZ3JjjyF7DWUxK
 nLoaOWS9U1m/84x7JTOEn0Fp84IkC2DnIDmrLb1B2chBjZxpd3CYw8rK53MMqYQSpocI
 Nhl3JlaAJPtb069P+Ef7qHeAupmBtgxE36UO8S6ql7bFpMunxQ9cw47RY7q+CDKgFNNN
 EVmnYz1epS2wO4XXGtdeAdlbMaquRYVPUXRntIDSxiK4/ulcJ2Ehv9INebTmI0mMdi62
 ECQ2p1cJJe4O0DOcx/gjln+tMMWX8/pn4WPgkD66SUn72WB5qZfUwMQrwfF/FOKTzaER
 u6BQ==
X-Gm-Message-State: ACrzQf0dls7xIDDBfE0LG2qOBBGAOkjjNLQoaUU5AjaVFoHiTvthcF6z
 Ez7h9+VV1XsuS2dacd7P7jnhl6oHOn/BIw0l+aAgp+XJn8GLg6iSGQqFbNKswsZ322/PVf9ao8P
 NIZvPq+TeBLm8qnJ4E+F7PIxVGB2l/VLVGTfw5Gkw
X-Received: by 2002:a05:6102:290f:b0:3a9:58e4:21e4 with SMTP id
 cz15-20020a056102290f00b003a958e421e4mr15185756vsb.16.1666423982080; 
 Sat, 22 Oct 2022 00:33:02 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7n2r61OPuivZoFkcwGIIhNnUj6Oumoro17gWYamx6wmsyOrWyfDfcB7j2agdpVk+jXKxHd35lMn+Edv5flcH8=
X-Received: by 2002:a05:6102:290f:b0:3a9:58e4:21e4 with SMTP id
 cz15-20020a056102290f00b003a958e421e4mr15185746vsb.16.1666423981772; Sat, 22
 Oct 2022 00:33:01 -0700 (PDT)
MIME-Version: 1.0
References: <20221013132830.1304947-1-maz@kernel.org>
In-Reply-To: <20221013132830.1304947-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Sat, 22 Oct 2022 09:32:50 +0200
Message-ID: <CABgObfaPLnwLVL3_QYwPw2ToaBJ331ihuSHqo2bqzr-mEauw5Q@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64 fixes for 6.1, take #1
To: Marc Zyngier <maz@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
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

On Thu, Oct 13, 2022 at 3:28 PM Marc Zyngier <maz@kernel.org> wrote:
> Paolo,
>
> Here's the first set of fixes for 6.1. The most interesting bit is
> Oliver's fix limiting the S2 invalidation batch size the the largest
> block mapping, solving (at least for now) the RCU stall problems we
> have been seeing for a while. We may have to find another solution
> when (and if) we decide to allow 4TB mapping at S2...
>
> The rest is a set of minor selftest fixes as well as enabling stack
> protection and profiling in the VHE code.
>
> Please pull,

Done, thanks.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
