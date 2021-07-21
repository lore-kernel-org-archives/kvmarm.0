Return-Path: <SRS0=81/H=MN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.9 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FSL_HELO_FAKE,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E430AC12002
	for <kvmarm@archiver.kernel.org>; Wed, 21 Jul 2021 16:13:24 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6E702608FC
	for <kvmarm@archiver.kernel.org>; Wed, 21 Jul 2021 16:13:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6E702608FC
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B56D44B10A;
	Wed, 21 Jul 2021 12:13:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YPREoPJLcFMk; Wed, 21 Jul 2021 12:13:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A45574B111;
	Wed, 21 Jul 2021 12:13:22 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 87F5C4B0B2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Jul 2021 11:56:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KOc8GZBKgNHd for <kvmarm@lists.cs.columbia.edu>;
 Wed, 21 Jul 2021 11:56:14 -0400 (EDT)
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com
 [209.85.215.177])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 650544B0AD
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Jul 2021 11:56:14 -0400 (EDT)
Received: by mail-pg1-f177.google.com with SMTP id a6so2314558pgw.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Jul 2021 08:56:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=z/3hbAsJ6hHRh2rV5PKBBKqWA8JlmZPRUnge7XIh/YQ=;
 b=ehQoWoN4b32AKEfbvzq/TqZJcLxqy2qFsIQziLzJY6uB8BoZ6VYVXo7jbfZA7sVLhS
 8fwH8/fgfuxwV65KU8TnaTBtuJkomxvtsAn2CLr52BuqX6i4x557dh/zFbderYhUX1Df
 QDSSRw1+j/NyTogqgIsTFijnm02thPGW7FqPn2BBof24v+z2kXpV5f9hFCwJS0L1kAGk
 Y3/u7w7mpkBuq+fL9JkzBCLDmamQVNFhqZ+b/ZCY/RJgbAxBX/Zpy9smexy1YOE1lTZF
 9OkteuG+A1w/N40tI8fQh95DzeFnb5Qg8mvr19ukAQtdgJtNvytkN1HA+jZWxrIVQU+/
 +Pig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=z/3hbAsJ6hHRh2rV5PKBBKqWA8JlmZPRUnge7XIh/YQ=;
 b=GJeqjFRYdFYq+BDo/dFkYh0WQUI5Jo8WHQHu8HU7h8gDMZk3zz5fmCou83/05Ci1Jb
 t0HctktDsKmwYD4VH4Sj+tqsvH0EHccayA+qJ6OUrSveRQ4YOX+9H8hMAwlEDw8KSt0n
 PutQgpEXVnAdja5FDj6CFDHyIlHYZ/iVvGkQBURimQ+UJ3D0biD8XCQnXH1IuCGXLrPK
 5EM7caYCPuASMY2Ndx80WwYSEomDG+ea+YKD+IVZW2iBa0y1rhGJXef6UkyPvzyoL2Fj
 jRUVt2WjWAnjz0x5PWeJX6cXzh+yBRcvxKRjwJRx4JnjrdoylX7XBC+tXVJ/cSOx0I+Q
 zmBQ==
X-Gm-Message-State: AOAM533CWGaqz7NpeeBvAsJ6HYeOYSwSAaFXvfmNnR161F00rwPlPIIF
 g9LThTkgfDPiq1m4RLokYhZr7Q==
X-Google-Smtp-Source: ABdhPJyQd9ZxyuvcAtcCKZ9XQkD55IW0oavb0JRtrpoVXiY7PwyAKlaBAOyUgIFyn8iBMuitZ9cxjA==
X-Received: by 2002:aa7:8d10:0:b029:303:8d17:7b8d with SMTP id
 j16-20020aa78d100000b02903038d177b8dmr36719282pfe.26.1626882973209; 
 Wed, 21 Jul 2021 08:56:13 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157])
 by smtp.gmail.com with ESMTPSA id e23sm26592454pfd.26.2021.07.21.08.56.12
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 21 Jul 2021 08:56:12 -0700 (PDT)
Date: Wed, 21 Jul 2021 15:56:09 +0000
From: Sean Christopherson <seanjc@google.com>
To: Will Deacon <will@kernel.org>
Subject: Re: [PATCH 1/5] KVM: arm64: Walk userspace page tables to compute
 the THP mapping size
Message-ID: <YPhDmZya2Up7fYNN@google.com>
References: <20210717095541.1486210-1-maz@kernel.org>
 <20210717095541.1486210-2-maz@kernel.org>
 <f09c297b-21dd-a6fa-6e72-49587ba80fe5@arm.com>
 <YPczKoLqlKElLxzb@google.com>
 <20210721145828.GA11003@willie-the-truck>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210721145828.GA11003@willie-the-truck>
X-Mailman-Approved-At: Wed, 21 Jul 2021 12:13:21 -0400
Cc: kernel-team@android.com, kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, linux-mm@kvack.org,
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

On Wed, Jul 21, 2021, Will Deacon wrote:
> > For the page tables liveliness, KVM implements mmu_notifier_ops.release, which is
> > invoked at the beginning of exit_mmap(), before the page tables are freed.  In
> > its implementation, KVM takes mmu_lock and zaps all its shadow page tables, a.k.a.
> > the stage2 tables in KVM arm64.  The flow in question, get_user_mapping_size(),
> > also runs under mmu_lock, and so effectively blocks exit_mmap() and thus is
> > guaranteed to run with live userspace tables.
> 
> Unless I missed a case, exit_mmap() only runs when mm_struct::mm_users drops
> to zero, right?

Yep.

> The vCPU tasks should hold references to that afaict, so I don't think it
> should be possible for exit_mmap() to run while there are vCPUs running with
> the corresponding page-table.

Ah, right, I was thinking of non-KVM code that operated on the page tables without
holding a reference to mm_users.

> > Looking at the arm64 code, one thing I'm not clear on is whether arm64 correctly
> > handles the case where exit_mmap() wins the race.  The invalidate_range hooks will
> > still be called, so userspace page tables aren't a problem, but
> > kvm_arch_flush_shadow_all() -> kvm_free_stage2_pgd() nullifies mmu->pgt without
> > any additional notifications that I see.  x86 deals with this by ensuring its
> > top-level TDP entry (stage2 equivalent) is valid while the page fault handler is
> > running.
> 
> But the fact that x86 handles this race has me worried. What am I missing?

I don't think you're missing anything.  I forgot that KVM_RUN would require an
elevated mm_users.  x86 does handle the impossible race, but that's coincidental.
The extra protections in x86 are to deal with other cases where a vCPU's top-level
SPTE can be invalidated while the vCPU is running.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
