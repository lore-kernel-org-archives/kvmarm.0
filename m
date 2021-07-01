Return-Path: <SRS0=4KxT=LZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78422C11F64
	for <kvmarm@archiver.kernel.org>; Thu,  1 Jul 2021 13:24:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E7D0361417
	for <kvmarm@archiver.kernel.org>; Thu,  1 Jul 2021 13:24:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E7D0361417
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6B4B84B088;
	Thu,  1 Jul 2021 09:24:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id S1z4C5AcNqAQ; Thu,  1 Jul 2021 09:24:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5AD9E4A98B;
	Thu,  1 Jul 2021 09:24:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F219E4A5A0
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Jul 2021 09:24:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6iSvslj0rShP for <kvmarm@lists.cs.columbia.edu>;
 Thu,  1 Jul 2021 09:24:53 -0400 (EDT)
Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com
 [209.85.167.182])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EBDBB49D50
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Jul 2021 09:24:52 -0400 (EDT)
Received: by mail-oi1-f182.google.com with SMTP id o6so7231769oic.9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 01 Jul 2021 06:24:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=jUbeSTVKF0eUVIxWOIFcB+k8q041q6JOmxNQFfd2nRM=;
 b=ve5mzz3EVO7csAUwWqbABT4cpkH0EFBLclPV5PKkCEWgc73uj9gJqNeWpwcGNNeQus
 M+P39JbVjU1UNyPKEzXRThlj/2T2/6b8hJqbKH4eu2Hyk3NZOcKakDwYtDpTZ+tIZPYC
 XIayF62YAfk77CPjsmyH5rDCHdfoCpItxhGVs8Xx4kw1d39o7VwDYBVY2z7kRx/73sJi
 CoYXQewAF/PMrG1sGbfxwvXsOmClfIXoCSaWTvHJt2x/YQ6IdoWfx79BT5BGpERIEDn7
 LVEdzviRyzOdxS4zWqwnDdrLULbz94/uFD510jFVNsBvycxJ79mdNtNPf2/tSSPpn4bN
 HZEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=jUbeSTVKF0eUVIxWOIFcB+k8q041q6JOmxNQFfd2nRM=;
 b=aMjf60gAdOomKyi5eU4J4P0CgU0Wy6jkyAT++HxXrdpTsR1FlRZ93IeDr9vwDE1i70
 VTtkZWWkEgpZLR/HZ3nRxc81/3BJgNy3uSvpkMgIqlAwHhWakClXtxSybGkWzYSZvxl5
 y1doe505aOVjfK5u7zlOh8Wx1NVsXGxXrmXTJfGqEf4zSHFSYfjeJSugkbdHBacixaGt
 gRBhxiRrlvfa6sZs+P0RGuKGHHxU9YLPmqBoxE7PxYnpqFBmoZnYFIy5w0f/pEhkkB4y
 fpgaymyRF94eZw8we40binYGCQ1IaCB9tYHHTXWX+nGT0I0JKIuX0PvdHU29/B02SUFG
 AMIg==
X-Gm-Message-State: AOAM533NBiX/gOitb/FRq+MNyanKCcaO4UYPZtvDDDU6/70aJRFCLuk4
 qO1/sqd39M3MbRAsQAEQdXwnY5GDAoiDCb4dszOdOw==
X-Google-Smtp-Source: ABdhPJz/fEAi1Npbkk/8h0gLjtrPsO9U1jtbHI69/yfBMeX5BV7f0u+BJgIQAi4kuMbjo5qGtIwZ/ER3pvIx+Rntwio=
X-Received: by 2002:a54:408b:: with SMTP id i11mr1266746oii.67.1625145892215; 
 Thu, 01 Jul 2021 06:24:52 -0700 (PDT)
MIME-Version: 1.0
References: <20210615133950.693489-1-tabba@google.com>
 <20210615133950.693489-2-tabba@google.com>
 <20210701125558.GB9757@willie-the-truck>
In-Reply-To: <20210701125558.GB9757@willie-the-truck>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 1 Jul 2021 14:24:16 +0100
Message-ID: <CA+EHjTwWggSopafNcftkPbhfD+aPC7UOtLJjSxm9Td4M9Az-5w@mail.gmail.com>
Subject: Re: [PATCH v2 01/13] KVM: arm64: Remove trailing whitespace in
 comments
To: Will Deacon <will@kernel.org>
Cc: kernel-team@android.com, kvm@vger.kernel.org, maz@kernel.org,
 pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu,
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

Hi Will,

On Thu, Jul 1, 2021 at 1:56 PM Will Deacon <will@kernel.org> wrote:
>
> On Tue, Jun 15, 2021 at 02:39:38PM +0100, Fuad Tabba wrote:
> > Editing this file later, and my editor always cleans up trailing
> > whitespace. Removing it earler for clearer future patches.
>
> s/earler/earlier/

Will fix this.

> Although the commit message is probably better as:
>
>   "Remove trailing whitespace from comment in trap_dbgauthstatus_el1()."

Will change the commit message.

Thanks,
/fuad

> Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
