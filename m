Return-Path: <SRS0=SY58=OK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DC5FC433EF
	for <kvmarm@archiver.kernel.org>; Mon, 20 Sep 2021 14:39:38 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A0CDF610FB
	for <kvmarm@archiver.kernel.org>; Mon, 20 Sep 2021 14:39:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org A0CDF610FB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1BBB040256;
	Mon, 20 Sep 2021 10:39:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8OyjRV6X+WCp; Mon, 20 Sep 2021 10:39:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EBACE4057F;
	Mon, 20 Sep 2021 10:39:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F301B40256
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Sep 2021 10:39:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GkmfDLoXjgxe for <kvmarm@lists.cs.columbia.edu>;
 Mon, 20 Sep 2021 10:39:33 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D2C4F4024F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Sep 2021 10:39:33 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1632148773;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=nhpibeqk4PvPTYyqOpXGwb8TL8EsN3x82upWewR9w28=;
 b=E/4/DFihWWfuH2AoPFpnb4H+g8pmpJnEaHiKVy/KU3nQDwpgYN9+Ns5/7fVj1aN37yAbpG
 gIZ/ANSSndEFwUpRjcTCC4ERgph52crv4PFjZLism0xAH4wwgIOzgQJV9KQoWM4VdZnPW9
 QlzNT1WUZhI1dI/Q5+EObEhLe8zkxy4=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-475-ar-EhhCIP72s2e-GXJV7Fg-1; Mon, 20 Sep 2021 10:39:30 -0400
X-MC-Unique: ar-EhhCIP72s2e-GXJV7Fg-1
Received: by mail-qk1-f197.google.com with SMTP id
 bk33-20020a05620a1a2100b00432fff50d40so62587661qkb.22
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Sep 2021 07:39:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=nhpibeqk4PvPTYyqOpXGwb8TL8EsN3x82upWewR9w28=;
 b=5+jCcvaw4Ta6qGNIQmFubPnkGaZ4fj5JKB1+KU/X0f15kIaXyfyj4juPVkSIv5hED2
 G/D+teMRhe4NxN9AneVktqJiETl7VDijCs4uCiDZavJ5VcjJPGYvMvXrPLCDtJ+/vd6r
 tUxAPi1dxTW0IQZUym7Kvx+ezXDnYT3pgnqdsDy2IR1CLCTZIY1h7abY5HpqvFAMzzXa
 AkhOOtvKBbVPBiLel9BmPeA6DYrJJ1gh53AfvXWZNY9pj6oUUKp/meIveYU4McDFYV1l
 Ek1x/Yyz/AKuWHXerQqDHnbcRDkcLmwJOFQFsQpUPp3jnU/i3HdHTGDknEXFWR6pKVvO
 8rkw==
X-Gm-Message-State: AOAM532xHiHsg+vyJh/pE5hvqQBicwEbtaZbWmP9pL5fVzCRlAJdLskt
 dFdMLslP5iAiaBBf8ZuaMN0yb2Perhy83WZL4n35qJjgMra+KAZvoc3Vs9wu7UAt4YBtdj1T6L3
 OuwmUqkwRzvgGUhVh2n+lIRoq
X-Received: by 2002:a05:620a:cd0:: with SMTP id
 b16mr24832172qkj.136.1632148769871; 
 Mon, 20 Sep 2021 07:39:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzxB2Y7T7b4bSWSVgRi7HdyZbRCph2nN2tQ4jNT1Sag+Z5mGiiad+h22+bslkc/EIiCd4pdyg==
X-Received: by 2002:a05:620a:cd0:: with SMTP id
 b16mr24832151qkj.136.1632148769680; 
 Mon, 20 Sep 2021 07:39:29 -0700 (PDT)
Received: from gator (nat-pool-brq-u.redhat.com. [213.175.37.12])
 by smtp.gmail.com with ESMTPSA id n20sm11509869qkk.135.2021.09.20.07.39.27
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 20 Sep 2021 07:39:28 -0700 (PDT)
Date: Mon, 20 Sep 2021 16:39:24 +0200
From: Andrew Jones <drjones@redhat.com>
To: "Russell King (Oracle)" <linux@armlinux.org.uk>
Subject: Re: REGRESSION: Upgrading host kernel from 5.11 to 5.13 breaks QEMU
 guests - perf/fw_devlink/kvm
Message-ID: <20210920143924.zh3zb7gf7wmd2uyx@gator>
References: <YUYRKVflRtUytzy5@shell.armlinux.org.uk>
 <877dfcwutt.wl-maz@kernel.org>
 <YUhYNnwaTt+5oMzh@shell.armlinux.org.uk>
MIME-Version: 1.0
In-Reply-To: <YUhYNnwaTt+5oMzh@shell.armlinux.org.uk>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
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

On Mon, Sep 20, 2021 at 10:45:26AM +0100, Russell King (Oracle) wrote:
> On Sun, Sep 19, 2021 at 02:36:46PM +0100, Marc Zyngier wrote:
> > Urgh. That's a bummer. T1he PMU driver only comes up once it has found
> > its interrupt controller, which on the Armada 8040 is not the GIC, but
> > some weird thing on the side that doesn't actually serve any real
> > purpose. On HW where the PMU is directly wired into the GIC, it all
> > works fine, though by luck rather than by design.
> > 
> > Anyway, rant over. This is a bug that needs addressing so that KVM can
> > initialise correctly irrespective of the probing order. This probably
> > means that the static key controlling KVM's behaviour wrt the PMU must
> > be controlled by the PMU infrastructure itself, rather than KVM trying
> > to probe for it.
> > 
> > Can you please give the following hack a go (on top of 5.15-rc1)? I've
> > briefly tested it on my McBin, and it did the trick. I've also tested
> > it on the M1 (which really doesn't have an architectural PMU) to
> > verify that it was correctly failing.
> 
> My test program that derives the number of registers qemu uses now
> reports 236 registers again and I see:

Hi Russell,

You may be interested in kvm selftests and this one[1] in particular.

[1] tools/testing/selftests/kvm/aarch64/get-reg-list.c

Thanks,
drew


> 
> kvm [7]: PMU detected and enabled
> 
> in the kernel boot log.
> 
> Tested-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> 
> Thanks.
> 
> -- 
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
