Return-Path: <SRS0=JP/k=N7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D54A3C433F5
	for <kvmarm@archiver.kernel.org>; Thu,  9 Sep 2021 06:53:48 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4837161176
	for <kvmarm@archiver.kernel.org>; Thu,  9 Sep 2021 06:53:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 4837161176
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A3F574B10C;
	Thu,  9 Sep 2021 02:53:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0Z3zvFW3wH7K; Thu,  9 Sep 2021 02:53:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8057E4B0F4;
	Thu,  9 Sep 2021 02:53:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E382A4B0F4
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Sep 2021 02:53:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 00T530v2y+0H for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Sep 2021 02:53:43 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C5F5A4B0DB
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Sep 2021 02:53:43 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1631170423;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=lVJoPeTJ14ks4lQWKf8FQkfVIx9pT4lGJxslkRQboLs=;
 b=HvsfbpsSV3PFD8ErzwcbMuqLQHHAc5I5xzLc9pIXp1BKDOSVFN+8fFIJVEAxNNIntZxrIA
 K9LMKfYPl7R03Xm3JFzGeyAHlA7PcB3APADd3QyfZxD2rGtt0Bs53fuIwrVwxDlCdyCrSD
 NGx6gGw4QwKOQnum/pNv76h1FISl8Us=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-175-iN_068oZMCeLZX0n6iF2kg-1; Thu, 09 Sep 2021 02:53:42 -0400
X-MC-Unique: iN_068oZMCeLZX0n6iF2kg-1
Received: by mail-ed1-f70.google.com with SMTP id
 u2-20020aa7d982000000b003cda80fa659so465122eds.14
 for <kvmarm@lists.cs.columbia.edu>; Wed, 08 Sep 2021 23:53:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=lVJoPeTJ14ks4lQWKf8FQkfVIx9pT4lGJxslkRQboLs=;
 b=zdoOyiFJyc0mHgxtdaOCANTH7sSS9xo4fj7XsBuH8zKwlkO88VBAdYsyEGupQc3TGu
 VNQqn2t8CWTKhXdQs1neSBaRDGKU5Z7RkzubAUQJ/xa8betwiMDFD+E6+NsjQLrQpv5H
 O8hw5Hk4pw7ZeHe+4LapTxi1i6dk2aCV2sEHlDUPZxeQuPdfNhIV+o5i/UFtxDU6mFON
 qSuHnJKsCjg/873oOT80LhrjnVfDN46gjVo5cOiYhKniidsnJ/mPq9pFLYzLjHiF9enG
 v9DKY6WrT2b5oAT2WE5SQ7dBEfm5kuw4OnVhkyiy0t9IyD2vJ+o3b7mZSVJdbj2TC8lz
 VqBQ==
X-Gm-Message-State: AOAM531O+38yifRQO2gGT6mC8VNQXJvwXF/WdaJdZ1Xhz9UVLOQaHHVb
 N71jWtK0Tlll32EZzKQ8K2No458sBZmLivskdthpHokYc/+DMHmZXzrUJKox8yFG6EOU6CDmi1N
 aZnYcyEcVUSVNfcFmDI2o8HQE
X-Received: by 2002:aa7:d1d3:: with SMTP id g19mr1558604edp.373.1631170421272; 
 Wed, 08 Sep 2021 23:53:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwzT2kVMpMwhqwvnc4mwNm5O0NWY9+knRg4l5/t0Fuho97if+WNms/fZtVChK5kAL+kRk5zWw==
X-Received: by 2002:aa7:d1d3:: with SMTP id g19mr1558597edp.373.1631170421138; 
 Wed, 08 Sep 2021 23:53:41 -0700 (PDT)
Received: from gator (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
 by smtp.gmail.com with ESMTPSA id bs13sm378308ejb.98.2021.09.08.23.53.40
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 08 Sep 2021 23:53:40 -0700 (PDT)
Date: Thu, 9 Sep 2021 08:53:38 +0200
From: Andrew Jones <drjones@redhat.com>
To: Oliver Upton <oupton@google.com>
Subject: Re: [PATCH v4 02/18] KVM: arm64: selftests: Add sysreg.h
Message-ID: <20210909065338.ulh32fqi4e6gnh2o@gator>
References: <20210909013818.1191270-1-rananta@google.com>
 <20210909013818.1191270-3-rananta@google.com>
 <CAOQ_Qsh=F-tTre_ojiLXUfAriH-coTF_gXCcLyRb3kKM+LLhQA@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAOQ_Qsh=F-tTre_ojiLXUfAriH-coTF_gXCcLyRb3kKM+LLhQA@mail.gmail.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: Catalin Marinas <catalin.marinas@arm.com>, kvm@vger.kernel.org,
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
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

On Wed, Sep 08, 2021 at 10:47:31PM -0400, Oliver Upton wrote:
> Hi Raghu,
> 
> On Wed, Sep 8, 2021 at 9:38 PM Raghavendra Rao Ananta
> <rananta@google.com> wrote:
> >
> > Bring-in the kernel's arch/arm64/include/asm/sysreg.h
> > into selftests to make use of all the standard
> > register definitions in consistence with the kernel.
> >
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > ---
> >  .../selftests/kvm/include/aarch64/sysreg.h    | 1278 +++++++++++++++++
> >  1 file changed, 1278 insertions(+)
> >  create mode 100644 tools/testing/selftests/kvm/include/aarch64/sysreg.h
> 
> This belongs in tools/arch/arm64/include/asm/sysreg.h, I believe.
>

Yes, that's also where I expected it to land.

Thanks,
drew 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
