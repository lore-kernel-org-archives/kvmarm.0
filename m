Return-Path: <SRS0=81/H=MN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.9 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,FSL_HELO_FAKE,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39816C12002
	for <kvmarm@archiver.kernel.org>; Wed, 21 Jul 2021 12:20:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D9E5860D07
	for <kvmarm@archiver.kernel.org>; Wed, 21 Jul 2021 12:20:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D9E5860D07
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8CC044B132;
	Wed, 21 Jul 2021 08:20:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@chromium.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zb-6FVxMyZha; Wed, 21 Jul 2021 08:20:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1182D4B13C;
	Wed, 21 Jul 2021 08:20:06 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E07754A483
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Jul 2021 22:06:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mPwQhjNYs+dj for <kvmarm@lists.cs.columbia.edu>;
 Tue, 20 Jul 2021 22:06:40 -0400 (EDT)
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com
 [209.85.214.179])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C6D184048A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Jul 2021 22:06:40 -0400 (EDT)
Received: by mail-pl1-f179.google.com with SMTP id d1so229832plg.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Jul 2021 19:06:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chromium.org; s=google;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=K5SBha3zR6HnIGPpTHePt7MeaM9Z7zyuvBLYdC04w6M=;
 b=F/V3TL3EIkA+1SPfKpp4W3wIkSZjEdimZxQlJZaxKweBLdvt7CsRSJQ/QxgTsA08vP
 Ff3IblbrLlK/KFckX65genz9i8/AG0pZbUyer9R18KnioTwNWwM1jYwvtopwKZrLRC2f
 OLQRbQcEpEOhmsaN3Ex9d/9KCXsOKFY5qanZY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=K5SBha3zR6HnIGPpTHePt7MeaM9Z7zyuvBLYdC04w6M=;
 b=o7VOQFZeKFrNE8ckLxX0bLiw9zyLXLB7++VW6ncJuABzSDh5HqxNrbLEY2NP8t1ez9
 wiJup1+bitNL9b5/xVF2igjOaX3o3V78cAWcrQdxzRA7Z4dFLwQGrluRk5KJ+QqSOyt1
 lD0D+6czPd+6vnCZ0Q32qdOTKsH0lzrVRzkR/lSALI862aCvCBLgz7OHmUno6I7bxAHX
 VnAcF6AbCcnxdxqvp59I6apOGa0gZHPb3d+heA4BjW6l02sBOqEKsvvvCJe8zvMo/6OV
 zPStBe8OSqZo7arIeUjPqJf/kGSW44LwiJseySLcyR45H52OskyffEVhb9NhQYpwcaof
 AJZg==
X-Gm-Message-State: AOAM533dF4WGhQfhkxpL0JbBVC6oapE3NA3PEwnB/mQ4r4S7rzN6ViIp
 39DQMEIj84+dWv03ipf98BsUmg==
X-Google-Smtp-Source: ABdhPJwo6hl98vCtoCJtqUlnEf/MD/LBM1QEly8wtPd1ZqxMrJU4eNKrvrWI9kd/HRAIwvTyhyDIQQ==
X-Received: by 2002:a17:90a:1704:: with SMTP id
 z4mr1378336pjd.213.1626833199843; 
 Tue, 20 Jul 2021 19:06:39 -0700 (PDT)
Received: from google.com ([2409:10:2e40:5100:808c:1a13:1159:8184])
 by smtp.gmail.com with ESMTPSA id m18sm25367726pfd.42.2021.07.20.19.06.36
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 20 Jul 2021 19:06:39 -0700 (PDT)
Date: Wed, 21 Jul 2021 11:06:34 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCHv2 3/4] arm64: do not use dummy vcpu_is_preempted()
Message-ID: <YPeBKqIS+OTrVKBO@google.com>
References: <20210709043713.887098-1-senozhatsky@chromium.org>
 <20210709043713.887098-4-senozhatsky@chromium.org>
 <875yxf356w.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <875yxf356w.wl-maz@kernel.org>
X-Mailman-Approved-At: Wed, 21 Jul 2021 08:20:04 -0400
Cc: Joel Fernandes <joelaf@google.com>, linux-kernel@vger.kernel.org,
 virtualization@lists.linux-foundation.org,
 Sergey Senozhatsky <senozhatsky@chromium.org>,
 Suleiman Souhlal <suleiman@google.com>, Will Deacon <will@kernel.org>,
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

On (21/07/12 16:47), Marc Zyngier wrote:
> >  #include <asm/qspinlock.h>
> >  #include <asm/qrwlock.h>
> > +#include <asm/paravirt.h>
> >  
> >  /* See include/linux/spinlock.h */
> >  #define smp_mb__after_spinlock()	smp_mb()
> >  
> > -/*
> > - * Changing this will break osq_lock() thanks to the call inside
> > - * smp_cond_load_relaxed().
> > - *
> > - * See:
> > - * https://lore.kernel.org/lkml/20200110100612.GC2827@hirez.programming.kicks-ass.net
> > - */
> 
> Why are you deleting this? Please explain your reasoning in the commit
> message. It seems to me that it still makes complete sense when
> CONFIG_PARAVIRT is not defined.

You are right. I'll move it to !PARAVIRT #else-branch.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
