Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B161C54EE9
	for <kvmarm@archiver.kernel.org>; Tue, 20 Sep 2022 18:40:13 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0659D4B18F;
	Tue, 20 Sep 2022 14:40:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id llxSz+6C1vm9; Tue, 20 Sep 2022 14:40:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DE62D4B17D;
	Tue, 20 Sep 2022 14:40:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3193B4B17D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 14:40:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zR8WLNb4VOX1 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 20 Sep 2022 14:40:08 -0400 (EDT)
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com
 [209.85.216.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BCAF44B166
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 14:40:08 -0400 (EDT)
Received: by mail-pj1-f50.google.com with SMTP id
 s90-20020a17090a2f6300b00203a685a1aaso3357274pjd.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 11:40:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date;
 bh=/DiWjb7VNp6NnqMqVkeacIID4EanwXZiP2GVnIDjepM=;
 b=dbSEoOGoBjfbP5cORYRAanCs0nsf0IlcEyje9M1XjryCAxb1CuUpoGTEkZG2isfiU7
 bGwknEWhQWqvl4BGW1ZykUulb1V0/fjHGtV/gAaW/a3NNpC7PqA+MtZYjzF87+auY1dQ
 dUeswiSUcMcwsDXpj6g1eofmzh5HnW4tAPRAjgUJl0/mnvh4XkwM/noIwLcP1wSQUeHv
 1w5P78p5KEu2q604OATMyObCOTjNg/qxy/0Uj+93QrLSRY8vxWwjixbe/B1cwVrPQ/3l
 4OqL5oRTLs2z+K2JggQ/llFODQxzrBL9X44GH9pWCBw+bUxQSqP8QcFg3o4iTkd1tFrf
 yrvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
 bh=/DiWjb7VNp6NnqMqVkeacIID4EanwXZiP2GVnIDjepM=;
 b=O/gp2FZazVbOlZbvcFGN5xZzoixbqFWbAQjWoB6k8jZzi36fFVBG3l1ahBbF1FOMQN
 vvHcEa/2dNB3dP1YYfs96VD9uQDlKyVzVNwFBSgHXdop0T7T7oCaiYEZ/5JvXbxQ5f79
 xNlaFzQuMaDEVuR1aTcH2k1h7tNQcr13ueQH8q97Qe/zSKTionsNyggs+zfWQ31aahwN
 7LpCwjckHzTM7toOR9k3nDS+VhmdNItSOEDzRi1540vr71FDUNzshP8EPmRHYZUuNUMC
 yNm8jNyrcVXrVQq2m36K99AMjsxbAU9Ptmt5vfW4S5A57cE41zo/YogP8Z0knk8FdXXN
 HS8A==
X-Gm-Message-State: ACrzQf3cHqTZQ8O9czO5xuw3PhYp+/NW5Dfk4Soi3ZZ1LocSoffyCnAx
 +D4A3BieGXNPOuX+4D7TNqo2bw==
X-Google-Smtp-Source: AMsMyM60ARJVl3WTxhTkeVBFE7UvvwIfglRK/e87tP+10Q6XQNwL6778c8fIBfL5nvZYJI71KmdOpA==
X-Received: by 2002:a17:902:cccc:b0:178:a9b3:43e6 with SMTP id
 z12-20020a170902cccc00b00178a9b343e6mr949541ple.92.1663699207698; 
 Tue, 20 Sep 2022 11:40:07 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com.
 [34.168.104.7]) by smtp.gmail.com with ESMTPSA id
 9-20020a621409000000b0053e6eae9668sm257638pfu.2.2022.09.20.11.40.07
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 20 Sep 2022 11:40:07 -0700 (PDT)
Date: Tue, 20 Sep 2022 18:40:03 +0000
From: Sean Christopherson <seanjc@google.com>
To: Ricardo Koller <ricarkol@google.com>
Subject: Re: [PATCH v7 08/13] KVM: selftests: Use the right memslot for code, 
 page-tables, and data allocations
Message-ID: <YyoJA7gjEaSiGwFi@google.com>
References: <20220920042551.3154283-1-ricarkol@google.com>
 <20220920042551.3154283-9-ricarkol@google.com>
 <YyoBUcSD6ZyxKxza@google.com> <YyoFBBn9uevAkIHT@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <YyoFBBn9uevAkIHT@google.com>
Cc: kvm@vger.kernel.org, maz@kernel.org, bgardon@google.com,
 andrew.jones@linux.dev, dmatlack@google.com, pbonzini@redhat.com,
 axelrasmussen@google.com, kvmarm@lists.cs.columbia.edu
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

On Tue, Sep 20, 2022, Ricardo Koller wrote:
> On Tue, Sep 20, 2022 at 06:07:13PM +0000, Sean Christopherson wrote:
> > On Tue, Sep 20, 2022, Ricardo Koller wrote:
> > > The previous commit added support for callers of ____vm_create() to specify
> > 
> > Changelog is stale, ____vm_create() no longer takes the struct.
> > 
> > Side topic, it's usually a good idea to use "strong" terminology when referencing
> > past/future changes, e.g. if patches get shuffled around for whatever reason,
> > then "previous commit" may become stale/misleading.
> > 
> > It's fairly easy to convey the same info ("something happened recently" or
> > "something is going to happen soon") without being so explicit, e.g.
> > 
> >   Wire up common code to use the appropriate code, page table, and data
> >   memmslots that were recently added instead of hardcoding '0' for the
> >   memslot.
> > 
> > or
> > 
> >   Now that kvm_vm allows specifying different memslots for code, page
> >   tables, and data, use the appropriate memslot when making allocations
> >   in common/libraty code.
> > 
> > > what memslots to use for code, page-tables, and data allocations. Change
> > > them accordingly:
> > > 
> > > - stacks, code, and exception tables use the code memslot
> > 
> > Huh?  Stacks and exceptions are very much data, not code.
> >
> 
> I would *really* like to have the data region only store test data. It
> makes things easier for the test implementation, like owning the whole
> region.

That's fine, but allocating stack as "code" is super confusing.

> At the same I wanted to have a single region for all the "core pages" like
> code, descriptors, exception tables, stacks, etc. Not sure what to call it
> though.

Why?  Code is very different than all those other things.  E.g. the main reason
KVM doesn't provide "not-executable" or "execute-only" memslots is because there's
never been a compelling use case, not because it's difficult to implement.  If KVM
were to ever add such functionality, then we'd want/need selftests to have a
dedicated code memslot.

> So, what about one of these 2 options:
> 
> Option A: 3 regions, where we call the "code" region something else, like
> "core".
> Option B: 4 regions: code, page-tables, core-data (stacks, exception tables, etc),
> test-data.

I like (B), though I'd just call 'em "DATA" and "TEST_DATA".  IIUC, TEST_DATA is
the one you want to be special, i.e. it's ok if something that's not "core" allocates
in DATA, but it's not ok if "core" allocates in TEST_DATA.  That yields an easy
to understand "never use TEST_DATA" rule for library/common/core functionality,
with the code vs. page tables vs. data decision (hopefully) being fairly obvious.

Defining CORE_DATA will force developers to make judgement calls and probably
lead to bikeshedding over whether something is considered "core" code.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
