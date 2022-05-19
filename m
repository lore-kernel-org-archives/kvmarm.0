Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62FEFC433EF
	for <kvmarm@archiver.kernel.org>; Thu, 19 May 2022 04:05:13 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D4FE24B354;
	Thu, 19 May 2022 00:05:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JF3dLu2788oA; Thu, 19 May 2022 00:05:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B89024B20A;
	Thu, 19 May 2022 00:05:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3B5AC41016
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 00:05:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0I-MvMBvO+wB for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 May 2022 00:05:09 -0400 (EDT)
Received: from mail-io1-f42.google.com (mail-io1-f42.google.com
 [209.85.166.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4DB1D40AFA
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 00:05:09 -0400 (EDT)
Received: by mail-io1-f42.google.com with SMTP id h85so4520372iof.12
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 May 2022 21:05:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=PUGcGcgjY+PPbnlecm2Tn6LpDwtEL6DN9ddiFdVhU74=;
 b=T+YR2EVSbzWb5me6Hd1AfsMVOFmylR4frbRyEo2KCJuJHO3HHwmkWu02Z8Y1dTKbJ5
 JQX0nSnydKj5b7tTCwBk0w3NAUfW7sFgOszPoKlTYOxbiqeyvu2IjKWTKp0J1Gdl5ZTU
 oEK1ICmDSUohZMuz+rKpjG6gujbiho6bdPbV0TuMELvU9Gc/0w7QQ/OKkVn1K/vvEC8Z
 0s/TpQzcSS4g5+zlHMPLpGF27X6hD4zMMYdvXhd6GPhEd5CWArC6BK7YZhrTICtUR7I8
 LV/IdE/53VJTuMBNeJLe/2WtyZuvRcHTjJd9L8JDxhyut2o47xmvdsH53p5xrXbHhblt
 vCZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=PUGcGcgjY+PPbnlecm2Tn6LpDwtEL6DN9ddiFdVhU74=;
 b=OCzh5+82sqsVb4CeWlxh2ww37MUnAA/do23BMCYyy9bXK4zveCghyPCSEbQgJlZ1kG
 BO5tKqdg8PIFPXxjUcSbnsd9hodiBkTCwcGCoY995l3AMJbqjfsSpdC/9OH5zqLaGtdx
 ac9GdlfexQV65fV4K4MFl/7my5K1iMLcQ6NM06+2fyhOWyOJD1F0ZSFu7zLiaArVJV0G
 CXMWw1CgdO4PaRA70Lzfuk07IpmaSVkH33mPxrhCeQJMLzQMZpDfop2fmLYV5yal1VIV
 I7PXjSAlO0ELgb+Vl5EJFppgSbgAkZ5jHJ5QWeNfGzzMdAaeB5gX10uAHrEMf1J0Rg2B
 t64Q==
X-Gm-Message-State: AOAM531fiuPZcWMoslkKJCdqYsIOY5RxgyPdd4ok/Jr8mF4feQat6hOY
 3uNgq/4RCmg1gWKPeinmBQV2Ow==
X-Google-Smtp-Source: ABdhPJz0C2TDvwAse2KZ/T1HrIHSFXsQA+eJE1CxvgzyDE7OzlZrcIaSqLH+tGAQxWM1+N4uCAkomA==
X-Received: by 2002:a05:6638:4185:b0:32b:6a0d:90dc with SMTP id
 az5-20020a056638418500b0032b6a0d90dcmr1550180jab.193.1652933108425; 
 Wed, 18 May 2022 21:05:08 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194]) by smtp.gmail.com with ESMTPSA id
 x15-20020a6bfe0f000000b0065a6bef1568sm415715ioh.23.2022.05.18.21.05.07
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 18 May 2022 21:05:07 -0700 (PDT)
Date: Thu, 19 May 2022 04:05:04 +0000
From: Oliver Upton <oupton@google.com>
To: Ricardo Koller <ricarkol@google.com>
Subject: Re: [PATCH v3 04/13] KVM: selftests: aarch64: Export _virt_pg_map
 with a pt_memslot arg
Message-ID: <YoXB8FJT6Qwb/WFR@google.com>
References: <20220408004120.1969099-1-ricarkol@google.com>
 <20220408004120.1969099-5-ricarkol@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220408004120.1969099-5-ricarkol@google.com>
Cc: kvm@vger.kernel.org, maz@kernel.org, bgardon@google.com,
 pbonzini@redhat.com, axelrasmussen@google.com, kvmarm@lists.cs.columbia.edu
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

On Thu, Apr 07, 2022 at 05:41:11PM -0700, Ricardo Koller wrote:
> Add an argument, pt_memslot, into _virt_pg_map in order to use a
> specific memslot for the page-table allocations performed when creating
> a new map. This will be used in a future commit to test having PTEs
> stored on memslots with different setups (e.g., hugetlb with a hole).
> 
> Signed-off-by: Ricardo Koller <ricarkol@google.com>

Reviewed-by: Oliver Upton <oupton@google.com>

I wonder if we should pay off the churn now to make _all_ arches have a
deeper call to map using memory from a particular memslot...

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
