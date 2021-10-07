Return-Path: <SRS0=Cc05=O3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CC9AC433EF
	for <kvmarm@archiver.kernel.org>; Thu,  7 Oct 2021 15:52:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A28406113E
	for <kvmarm@archiver.kernel.org>; Thu,  7 Oct 2021 15:52:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org A28406113E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0BDC64B2D3;
	Thu,  7 Oct 2021 11:52:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 92rK0VDZOUxi; Thu,  7 Oct 2021 11:52:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0939C4B2E0;
	Thu,  7 Oct 2021 11:52:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 75B164B268
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Oct 2021 11:52:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iurkJI5AyicS for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 Oct 2021 11:52:53 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 412824B267
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Oct 2021 11:52:53 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1633621973;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=mki5wTjxXGr+IGNPFHM4xHf+VH4JglD76WJd/mMOISs=;
 b=ZW4NS9yiYE4RatWENqfxdIrdexBE5IuyMYLpDtyjwrKc9vRjnSADKsPFvzAA5DAQGjnXeH
 FtUYzyh0WKIuTO9Bnw8ZDq8ORN8pZc1SRkc5QSVFV538/KEo6dBG2x/FzbujCfFklzDG0r
 RpD512sTJRv9mGDWMOpr1c4lRR/OI0s=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-389-lAyka312Mg-Pr4eK4rcgWA-1; Thu, 07 Oct 2021 11:52:52 -0400
X-MC-Unique: lAyka312Mg-Pr4eK4rcgWA-1
Received: by mail-wr1-f71.google.com with SMTP id
 r16-20020adfbb10000000b00160958ed8acso5055911wrg.16
 for <kvmarm@lists.cs.columbia.edu>; Thu, 07 Oct 2021 08:52:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=mki5wTjxXGr+IGNPFHM4xHf+VH4JglD76WJd/mMOISs=;
 b=iHpgoI0LvhU70I1uYIfIuuZgrpcv5iIqKbxDGmZTgo7UjvAG7wv8VuNYaS+c2tpohB
 hhZ+gOPoikh3iKECe6ssJ9a8wpkJZOobvng2Hj/xLO0UpKHrC7lBmY9bUcLR/stauqqA
 sXtP0+VHsoXn0roBepKhBaAjk1CEti5X+K7Qgu7VsF1JaPzyGnAZ7KI6/ERbuPwdrLSZ
 ukLs6g7ul0/YWDYf3v2SiUoXWR2EimCDkNou5u4/XfEpRwFCORFtjzrWebRcBOQMexgr
 7N7MHOcAm4/89AnypujCb1YEIRu9y7v1gobWT4C0sOnAbdx6nzbBnyam11SV/298qMue
 jU3g==
X-Gm-Message-State: AOAM531o7FoVVs6b3RR9XDPRRMTFPeMt28ZeTcK0ZSdRKFKTZk4CGPt7
 4lmQ+rr7knWdwMyrWA1woq8/nbejwxkah89PgWJblwx5vHhupNPW7s6l7x8GZ+ndtmJNnmU4DhG
 fPPEuahKCnd4wf7IA3B5uRyFt
X-Received: by 2002:adf:9b97:: with SMTP id d23mr6386618wrc.53.1633621970915; 
 Thu, 07 Oct 2021 08:52:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxxS9zzcdO8gEa8I10rZOiZ3zEoCv1L5U3v+lF61OvcEjd+iZrkvzPdw2F8ibmZvXvAL8shTg==
X-Received: by 2002:adf:9b97:: with SMTP id d23mr6386598wrc.53.1633621970756; 
 Thu, 07 Oct 2021 08:52:50 -0700 (PDT)
Received: from gator (nat-pool-brq-u.redhat.com. [213.175.37.12])
 by smtp.gmail.com with ESMTPSA id i92sm13012wri.28.2021.10.07.08.52.49
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 07 Oct 2021 08:52:50 -0700 (PDT)
Date: Thu, 7 Oct 2021 17:52:48 +0200
From: Andrew Jones <drjones@redhat.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 00/16]  KVM: arm64: MMIO guard PV services
Message-ID: <20211007155248.ejwclkwnnsaunmc6@gator>
References: <20211004174849.2831548-1-maz@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20211004174849.2831548-1-maz@kernel.org>
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

On Mon, Oct 04, 2021 at 06:48:33PM +0100, Marc Zyngier wrote:
> This is the second version of this series initially posted at [1] that
> aims at letting a guest express what it considers as MMIO, and only
> let this through to userspace. Together with the guest memory made
> (mostly) inaccessible to the host kernel and userspace, this allows an
> implementation of a hardened IO subsystem.
> 
> A lot has been fixed/revamped/improved since the initial posting,
> although I am still not pleased with the ioremap plugging on the guest
> side. I'll take any idea to get rid of it!
>

Pros/cons of the hooks

Pros:
 1) VM only needs to have a kernel that supports the feature (and a
    kernel command line that enables it)
 2) All the ioremapped MMIO ranges are permitted immediately, rather than
    deferring until some other event (which would probably be too late in
    many cases)

Cons:
 1) Having to have hooks, which is never pretty
 2) Adding the hypcalls to each ioremap, which adds some overhead
 3) Having to reference count all the mappings, which adds even more overhead
 4) Not giving the owner of the VM control over what MMIO is permitted
    (Well, maybe the VM owner just needs to blacklist drivers for anything
     that it doesn't want.)

I don't think any of the Con's are too bad and probably Pro-2 more or less
makes the hooks a necessity.

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
