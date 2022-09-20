Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B974C6FA82
	for <kvmarm@archiver.kernel.org>; Tue, 20 Sep 2022 18:57:21 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B07544B655;
	Tue, 20 Sep 2022 14:57:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6dZgpc0ecXX7; Tue, 20 Sep 2022 14:57:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 996254B640;
	Tue, 20 Sep 2022 14:57:19 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 138D84B639
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 14:57:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BzdCKYh68mdY for <kvmarm@lists.cs.columbia.edu>;
 Tue, 20 Sep 2022 14:57:18 -0400 (EDT)
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com
 [209.85.214.169])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EC2774B62A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 14:57:17 -0400 (EDT)
Received: by mail-pl1-f169.google.com with SMTP id f23so3325339plr.6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 11:57:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date;
 bh=qR+LuVTt7SenxWyTQj9QGBqupmm5d3dwuEs9Y271sKg=;
 b=kLhljSrt+E5ElK+0GjWZ/EUOZhAbmVexhZGYPz8vKbKrviJoSNR3Eoc9pIvFte4Kbb
 wzOWaqd0JlPZ90KlGJMw3xE+AUxywnTir8Oo2PCvXlybaTVkPAg7SM97GzxGdUyK6Wwg
 C1STJo8BddmOVLpOTzsjFN0j3EGIppiHBhazj2fj7BOxrjPgKcB1jI/iP7xl4NYXfBlC
 b27I8S/hwPDlbnLOFPBjg4wzQlIqkKiOfPrF5P46v59tmAEBkTzUwngSXAphqDDp6qRs
 DSI4OIQKxEOqdb3B4LfUWyLE0rZKKxe/Afg/jR+/MBBRrrVgkeBHlyQ+tuEcrDYQ3YG2
 twTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
 bh=qR+LuVTt7SenxWyTQj9QGBqupmm5d3dwuEs9Y271sKg=;
 b=Tpq/4nsjNUudG35vMUUBOLgRItjbK5pgB2Vv+hs79rQe94klgFSDtWc8o1Ljg4Dr8a
 aOWviD80Dmfgg1kg1juAO0kTCwGdjmwAJJfr8Q8Obyu1uGX2T1U1+clxQvauJ+J/MKHV
 rrK2cY83GgcwGGnf44JmVyrx6XTq7GH44llzmjXqQziB74DkE6ZpK9arp2ky8OQ5PYoh
 5WN0Vd8KMTucg6c5CYO/8qoFKxI3HnWHgyEK008LKtVd0/ITXCmZ+ZQ5l7ByoKHoC7GB
 ie5s8zA9ZWm+jg5Fmwvz6exDaT4ecwwexYsziAFxKPLizc3KGRTej0JyLfedfpkO6GVP
 a7xw==
X-Gm-Message-State: ACrzQf0kaRyy3nErCKh9Z4YDOHk0fPJevhjZ8eKouDlGJulmcV977SIv
 pDT3ZKkBr8A27SyFRpjTV95ing==
X-Google-Smtp-Source: AMsMyM7bb7yxnYsMkhRd0wVvY5A8h/96nA7mT3fFI2aAXX3+5hVZrHo5C00JnYuUPiNzko1xnDz3qA==
X-Received: by 2002:a17:902:f550:b0:178:5b6a:3a1c with SMTP id
 h16-20020a170902f55000b001785b6a3a1cmr1007667plf.36.1663700236828; 
 Tue, 20 Sep 2022 11:57:16 -0700 (PDT)
Received: from google.com (220.181.82.34.bc.googleusercontent.com.
 [34.82.181.220]) by smtp.gmail.com with ESMTPSA id
 e1-20020a17090301c100b00172cb8b97a8sm281881plh.5.2022.09.20.11.57.15
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 20 Sep 2022 11:57:16 -0700 (PDT)
Date: Tue, 20 Sep 2022 11:57:12 -0700
From: Ricardo Koller <ricarkol@google.com>
To: Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH v7 08/13] KVM: selftests: Use the right memslot for code, 
 page-tables, and data allocations
Message-ID: <YyoNCMmQ0cYzYQIy@google.com>
References: <20220920042551.3154283-1-ricarkol@google.com>
 <20220920042551.3154283-9-ricarkol@google.com>
 <YyoBUcSD6ZyxKxza@google.com> <YyoFBBn9uevAkIHT@google.com>
 <YyoJA7gjEaSiGwFi@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <YyoJA7gjEaSiGwFi@google.com>
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

On Tue, Sep 20, 2022 at 06:40:03PM +0000, Sean Christopherson wrote:
> On Tue, Sep 20, 2022, Ricardo Koller wrote:
> > On Tue, Sep 20, 2022 at 06:07:13PM +0000, Sean Christopherson wrote:
> > > On Tue, Sep 20, 2022, Ricardo Koller wrote:
> > > > The previous commit added support for callers of ____vm_create() to specify
> > > 
> > > Changelog is stale, ____vm_create() no longer takes the struct.
> > > 
> > > Side topic, it's usually a good idea to use "strong" terminology when referencing
> > > past/future changes, e.g. if patches get shuffled around for whatever reason,
> > > then "previous commit" may become stale/misleading.
> > > 
> > > It's fairly easy to convey the same info ("something happened recently" or
> > > "something is going to happen soon") without being so explicit, e.g.
> > > 
> > >   Wire up common code to use the appropriate code, page table, and data
> > >   memmslots that were recently added instead of hardcoding '0' for the
> > >   memslot.
> > > 
> > > or
> > > 
> > >   Now that kvm_vm allows specifying different memslots for code, page
> > >   tables, and data, use the appropriate memslot when making allocations
> > >   in common/libraty code.
> > > 
> > > > what memslots to use for code, page-tables, and data allocations. Change
> > > > them accordingly:
> > > > 
> > > > - stacks, code, and exception tables use the code memslot
> > > 
> > > Huh?  Stacks and exceptions are very much data, not code.
> > >
> > 
> > I would *really* like to have the data region only store test data. It
> > makes things easier for the test implementation, like owning the whole
> > region.
> 
> That's fine, but allocating stack as "code" is super confusing.
> 
> > At the same I wanted to have a single region for all the "core pages" like
> > code, descriptors, exception tables, stacks, etc. Not sure what to call it
> > though.
> 
> Why?  Code is very different than all those other things.  E.g. the main reason
> KVM doesn't provide "not-executable" or "execute-only" memslots is because there's
> never been a compelling use case, not because it's difficult to implement.  If KVM
> were to ever add such functionality, then we'd want/need selftests to have a
> dedicated code memslot.
> 
> > So, what about one of these 2 options:
> > 
> > Option A: 3 regions, where we call the "code" region something else, like
> > "core".
> > Option B: 4 regions: code, page-tables, core-data (stacks, exception tables, etc),
> > test-data.
> 
> I like (B), though I'd just call 'em "DATA" and "TEST_DATA".  IIUC, TEST_DATA is
> the one you want to be special, i.e. it's ok if something that's not "core" allocates
> in DATA, but it's not ok if "core" allocates in TEST_DATA.  That yields an easy
> to understand "never use TEST_DATA" rule for library/common/core functionality,
> with the code vs. page tables vs. data decision (hopefully) being fairly obvious.
> 
> Defining CORE_DATA will force developers to make judgement calls and probably
> lead to bikeshedding over whether something is considered "core" code.

Sounds good, Option B then (with code, pt, data, test-data).

Thanks,
Ricardo
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
