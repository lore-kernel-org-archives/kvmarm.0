Return-Path: <SRS0=/m9d=NY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47305C432BE
	for <kvmarm@archiver.kernel.org>; Thu,  2 Sep 2021 14:35:37 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B45BC6108E
	for <kvmarm@archiver.kernel.org>; Thu,  2 Sep 2021 14:35:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org B45BC6108E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 182DD4B120;
	Thu,  2 Sep 2021 10:35:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Q2THnyluzOvK; Thu,  2 Sep 2021 10:35:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4577B4B129;
	Thu,  2 Sep 2021 10:35:32 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7D3104B126
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Sep 2021 10:35:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2KBIHQMeOVdS for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Sep 2021 10:35:29 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8F10E4B120
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Sep 2021 10:35:29 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1630593329;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=UXAhxJKeZF3J+7oqF+kPNby+2j1qsB6aw7GpNeUB5QM=;
 b=YHmzDzOVP8fZUk++6rCAUcJOsrlHsgE8XHs9GiokWRQiEULRuwRD4eaRaySs6IhmAaPr9c
 3K/NUgl7N743jZJr4wF9bLkYy3VoFtaneAilv42XWq2xhaeE2588K38iSFvTowox4GPGSn
 vuWoVwZATVMFR0igjrWc5Yhwgsj4OAo=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-454-lDwqr9M1O16H4OIfwcSbTA-1; Thu, 02 Sep 2021 10:35:28 -0400
X-MC-Unique: lDwqr9M1O16H4OIfwcSbTA-1
Received: by mail-wr1-f71.google.com with SMTP id
 i16-20020adfded0000000b001572ebd528eso601487wrn.19
 for <kvmarm@lists.cs.columbia.edu>; Thu, 02 Sep 2021 07:35:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=UXAhxJKeZF3J+7oqF+kPNby+2j1qsB6aw7GpNeUB5QM=;
 b=epZiBnjKjsi5qWMihWxGUArTQLFf3sINT6v30nGM9eyidOWgfXPs+mZtCAviw0AmMA
 XFFDTGCHMTS/9IQVnrrbcjZxtqahji+EIRwJc3wMD9E5teaewpuZqWgBgNBzwDJwSS/K
 IG5jRgLFHU85kjv4aiken21aiESQJTko2HGNlWszs+KXfwLbPr6t7CpP6HpgQ+NoQYAk
 v2PLWReyw0x0tKsToQbrZ7yyoQYY0IpBHsmRm4pDsfOXwyJ1mGhskOpmMOwfVG7Fn/FH
 w5HCJaPT2eTBAE4j6Onukn9lKwaioL5RhB8QEFRmNyhUJ3ueEygyD7WdFdqKGg3wNmz/
 rfhA==
X-Gm-Message-State: AOAM533IZF8C8cEWZn78wh8v86pWifom4q1DxJDP/JT4SDuZCgunlvrY
 piPRGgw3q+XK9Dc4Igvhxk18TvWKDXYyGuw3b2gs7zwesQ6WZW1Jcsc2F4LSmnm+5mm73aFgS2X
 5dHSbtIjWXJCYEVnY/sCQSSpk
X-Received: by 2002:a05:600c:35d6:: with SMTP id
 r22mr3535285wmq.44.1630593327105; 
 Thu, 02 Sep 2021 07:35:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw9o3Br43dEQefXp6QdLiHjyMHkpP9VDy99DVBV7/iLzkKW8NQEuihUoh0UpylVyROp15dTRw==
X-Received: by 2002:a05:600c:35d6:: with SMTP id
 r22mr3535261wmq.44.1630593326922; 
 Thu, 02 Sep 2021 07:35:26 -0700 (PDT)
Received: from gator (nat-pool-brq-u.redhat.com. [213.175.37.12])
 by smtp.gmail.com with ESMTPSA id l17sm2107112wrz.35.2021.09.02.07.35.26
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 02 Sep 2021 07:35:26 -0700 (PDT)
Date: Thu, 2 Sep 2021 16:35:24 +0200
From: Andrew Jones <drjones@redhat.com>
To: Raghavendra Rao Ananta <rananta@google.com>
Subject: Re: [PATCH v3 05/12] KVM: arm64: selftests: Add basic support to
 generate delays
Message-ID: <20210902143524.h74zmunzjrtb3o2v@gator>
References: <20210901211412.4171835-1-rananta@google.com>
 <20210901211412.4171835-6-rananta@google.com>
MIME-Version: 1.0
In-Reply-To: <20210901211412.4171835-6-rananta@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
 Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
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

On Wed, Sep 01, 2021 at 09:14:05PM +0000, Raghavendra Rao Ananta wrote:
> Add udelay() support to generate a delay in the guest.
> 
> The routines are derived and simplified from kernel's
> arch/arm64/lib/delay.c.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>  .../selftests/kvm/include/aarch64/delay.h     | 25 +++++++++++++++++++
>  1 file changed, 25 insertions(+)
>  create mode 100644 tools/testing/selftests/kvm/include/aarch64/delay.h
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
