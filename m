Return-Path: <SRS0=3CJn=MP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8BA4C4320A
	for <kvmarm@archiver.kernel.org>; Fri, 23 Jul 2021 13:38:56 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 40DF860F39
	for <kvmarm@archiver.kernel.org>; Fri, 23 Jul 2021 13:38:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 40DF860F39
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C36904B148;
	Fri, 23 Jul 2021 09:38:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QvqvNK1-BBDt; Fri, 23 Jul 2021 09:38:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BAF784B12B;
	Fri, 23 Jul 2021 09:38:54 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 161004B11C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Jul 2021 09:38:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id M0bygiqYoXrH for <kvmarm@lists.cs.columbia.edu>;
 Fri, 23 Jul 2021 09:38:52 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0BC734B11A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Jul 2021 09:38:52 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1627047531;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=CNrCnNEi8YU3NjpLXktV8L2vGTneNrqBq6dOtm+we8Y=;
 b=Y5G+imUs3tWu4A6G+0OI/TzOINrUSgDLIn5tmms9bxq14J/f4VJLFsa+DcvpwtoPafaqPw
 nupzLAnJ5UhL1ChVnFjTIMsT+D1CjM1qJywHx2pqyjHCJKkv3G8AtDjiyeHLYmLLOKRosN
 nWdudvC4BYZ3as7KaPnAmOsB+yCenME=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-68-98raZBSPOX69pmdQwBfMug-1; Fri, 23 Jul 2021 09:38:49 -0400
X-MC-Unique: 98raZBSPOX69pmdQwBfMug-1
Received: by mail-il1-f199.google.com with SMTP id
 d6-20020a056e020506b0290208fe58bd16so1088718ils.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Jul 2021 06:38:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=CNrCnNEi8YU3NjpLXktV8L2vGTneNrqBq6dOtm+we8Y=;
 b=SOY+Wj2pK+E8jNUxFS8y0+W20vKJmpZU2sKnq5ytd655v6OCVKGaSgsDhuSB7b6X9R
 nqZcB6YKo6xw+WZrWpe/qRlfdmGGtCjTzOsZ2a0ri39JAevJR85ZTpz/1GEtgCYklK8S
 SLFoQMiRi5Vw/JPbQswv3K0VAB1or7FipGgwGk9drZRGwc1tPtLjZiaT5eDKlpDJlMkB
 Ce5VpCtxIe4MXDRnwjy3w86ysDWjvVMAG8sv2ebaPXXhyxXQfgIaAP3QWW2NChoiTnFW
 ZFh+1QCbkJSwa9Ss4/5IpuOTuUCGSsSgAz1I0UgRpvTQ0FD7Q2Mzk0gNSFoGKNiltpY6
 m/1Q==
X-Gm-Message-State: AOAM533S1tdvscPgcX0OmWr2re00JAZUBzz8mlLd5iWqLCMEg4XLbJKu
 xiMg/ouDY2KrHb1Q+gD+qs6yjDhII0RER/DSd+ujOEGckFWB5gTJ1/3ilZG/r4WhrGEiJIKLASD
 XRE+EgnEtHtoPCAUh282scM88
X-Received: by 2002:a02:cd0a:: with SMTP id g10mr4243219jaq.18.1627047529244; 
 Fri, 23 Jul 2021 06:38:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwek83fSduz7V8CLkiqtAngLuJBjs5iDFj4SG3DhS5HRyk7g8pS0JfJqY3+Yo29wQu7Wx0j/g==
X-Received: by 2002:a02:cd0a:: with SMTP id g10mr4243213jaq.18.1627047529098; 
 Fri, 23 Jul 2021 06:38:49 -0700 (PDT)
Received: from gator ([204.16.59.133])
 by smtp.gmail.com with ESMTPSA id p8sm11466441iol.49.2021.07.23.06.38.47
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 23 Jul 2021 06:38:48 -0700 (PDT)
Date: Fri, 23 Jul 2021 15:38:45 +0200
From: Andrew Jones <drjones@redhat.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 10/16] KVM: arm64: Add some documentation for the MMIO
 guard feature
Message-ID: <20210723133845.jwp3ljkfnupgv36i@gator>
References: <20210715163159.1480168-1-maz@kernel.org>
 <20210715163159.1480168-11-maz@kernel.org>
 <20210721211743.hb2cxghhwl2y22yh@gator>
 <60d8e9e95ee4640cf3b457c53cb4cc7a@kernel.org>
MIME-Version: 1.0
In-Reply-To: <60d8e9e95ee4640cf3b457c53cb4cc7a@kernel.org>
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

On Fri, Jul 23, 2021 at 02:30:13PM +0100, Marc Zyngier wrote:
...
> > > +
> > > +    ==============    ========
> > > ======================================
> > > +    Function ID:      (uint32)    0xC6000004
> > > +    Arguments:        (uint64)    The base of the PG-sized IPA range
> > > +                                  that is allowed to be accessed as
> > > +				  MMIO. Must aligned to the PG size (r1)
> > 
> > align
> 
> Hmmm. Ugly mix of tab and spaces. I have no idea what the norm
> is here, so I'll just put spaces. I'm sure someone will let me
> know if I'm wrong! ;-)

Actually, my comment wasn't regarding the alignment of the text. I was
commenting that we should change 'aligned' to 'align' in the text. (Sorry,
that was indeed ambiguous.) Hmm, it might be better to just add 'be', i.e.
'be aligned'.

I'm not sure what to do about the tab/space mixing, but keeping it
consistent is good enough for me.

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
