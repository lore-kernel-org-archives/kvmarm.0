Return-Path: <SRS0=MRip=75=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF72CC433E0
	for <kvmarm@archiver.kernel.org>; Tue, 16 Jun 2020 09:23:00 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 48C0720707
	for <kvmarm@archiver.kernel.org>; Tue, 16 Jun 2020 09:23:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ZHTY5CeC"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 48C0720707
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B6C4F4B0E2;
	Tue, 16 Jun 2020 05:22:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id thc0+NX1U7Fn; Tue, 16 Jun 2020 05:22:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B8C324B0E3;
	Tue, 16 Jun 2020 05:22:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 924704B0E0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Jun 2020 05:22:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dIB-1Q7t5T7V for <kvmarm@lists.cs.columbia.edu>;
 Tue, 16 Jun 2020 05:22:56 -0400 (EDT)
Received: from mail-ot1-f65.google.com (mail-ot1-f65.google.com
 [209.85.210.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B2BBE4B0C4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Jun 2020 05:22:56 -0400 (EDT)
Received: by mail-ot1-f65.google.com with SMTP id g5so15414102otg.6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Jun 2020 02:22:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=evxvWdLGySiDb4ijImDiRjoXKAGoZTla3vJnx4JycZ4=;
 b=ZHTY5CeCYyBYekI3ELVWSR2rCOZKoC+CKzWdLsMuvl9WPpXVl13OCNPmcyJVimZf/4
 84AqafepIlsb5urNLPJ2SxOmnySlo1FTEtKw0HifnK8saFOowiM1dknY8CcpXFz0yziO
 roG6knETh5AHLq57uRWxysgIMDilPgBNptcbRk/Y02mHDTKNnop9JmjdrTy55TyavEkz
 S/3GD0QBzwpAEztrWzsY+gi1bMrFU2zSMHn6Vc6uzhfkPv3Rc1PSrIitXyT9Xst/19ze
 0bt+J14hwD6Tug+SgqcgB8QS50Xg/OoY9K431pNoMbWsk9nV4z+XlWNXiKB0W3nU+Sns
 2juw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=evxvWdLGySiDb4ijImDiRjoXKAGoZTla3vJnx4JycZ4=;
 b=oI4NJYwRDLoPwAwXPl14GBh1lqnWmmzEJuQrNUFGwtWePFxk1bBAZdYnj0QtKLuUjP
 i9XgXXMpuKXLM3M3iL2atoZe+bIlvXMPDZ03bZMNi+9l7BlqK/FVe3KlupKe/TZ2sc4g
 DyXGP3MvyMLhCTvlQHZkcpHfsVH1ewdSLZatZ6crm1G3L66WC2zAmO6p4mM6a+QDg+DL
 ALc12FEPkJT4hCqMI5wHC3Llb9YMhlmxoc6aXmW1gOWxjxnxPd8zDkJeyFSkOB86KUrg
 Drj/S/cMgAMVra1A1rtfL0noA5feP6cCIrxQyBE/Po8lc+fGFK12XyZU5+Zw8iiHYbrD
 IMkw==
X-Gm-Message-State: AOAM5326f/z4sdo4jswLp3zJxH8e7ppZI2/WT3f05pAEiy7pgfxnuryB
 fUAGzk6Mh3T+rSnScosgHG9CND6jP/xzVfMSfBA1Qw==
X-Google-Smtp-Source: ABdhPJznaFc2phNW440Ak7xBQ1NgO04/pWbdU9fZWz6qnsHjzAdEJe2e+tW2U6RZfGUL6vrF+oXqi39WLktOrRjjzx8=
X-Received: by 2002:a05:6830:8d:: with SMTP id
 a13mr1645786oto.91.1592299376022; 
 Tue, 16 Jun 2020 02:22:56 -0700 (PDT)
MIME-Version: 1.0
References: <20200529112757.32235-1-beata.michalska@linaro.org>
 <20200529112757.32235-2-beata.michalska@linaro.org>
 <20200616083337.yfgc4cyad4ipaqb7@kamzik.brq.redhat.com>
In-Reply-To: <20200616083337.yfgc4cyad4ipaqb7@kamzik.brq.redhat.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Tue, 16 Jun 2020 10:22:44 +0100
Message-ID: <CAFEAcA8uX-CCSac8tQ6=pzeDtZWxCvA=DuoV9ZhT_OJVHXfdqw@mail.gmail.com>
Subject: Re: [PATCH v5 1/2] target/arm: kvm: Handle DABT with no valid ISS
To: Andrew Jones <drjones@redhat.com>
Cc: QEMU Developers <qemu-devel@nongnu.org>, qemu-arm <qemu-arm@nongnu.org>,
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

On Tue, 16 Jun 2020 at 09:33, Andrew Jones <drjones@redhat.com> wrote:
>
> Hi Beata,
>
> I see Peter just picked this up, so I'm a bit late getting to it. I do
> have a couple comments below though.

I'll drop it from my queue again for the moment, then.

thanks
-- PMM
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
