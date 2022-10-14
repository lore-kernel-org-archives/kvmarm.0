Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 471FBC4332F
	for <kvmarm@archiver.kernel.org>; Fri, 14 Oct 2022 21:37:45 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AD6584B62D;
	Fri, 14 Oct 2022 17:37:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id szq53apQgsqF; Fri, 14 Oct 2022 17:37:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8B9B940762;
	Fri, 14 Oct 2022 17:37:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 72C8140762
 for <kvmarm@lists.cs.columbia.edu>; Fri, 14 Oct 2022 17:37:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mDxZ-XBvOVWR for <kvmarm@lists.cs.columbia.edu>;
 Fri, 14 Oct 2022 17:37:40 -0400 (EDT)
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com
 [209.85.210.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5000340755
 for <kvmarm@lists.cs.columbia.edu>; Fri, 14 Oct 2022 17:37:40 -0400 (EDT)
Received: by mail-pf1-f172.google.com with SMTP id i3so6041165pfk.9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 14 Oct 2022 14:37:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
 bh=eZ0cdI79ADlanekkYUSD9fAGVZvM6bIrF+Eq4A7Ygd0=;
 b=koXuqSvky1riggc/IjIcBJ5QKS2r76UwNF0+m1YmtoN6x5TLzY40OyFxikqY09ee+d
 IWauiMTz1Uitfu3NbLRMgzzx2z50RtgVV/3czdNQkQ+VM1MvdWcrkAlrIVbbqRcn0fDb
 PwjvqrFQooRxEcUEpHH+d/XgavD1URG0v7hE3UyLPIjdYo1E+0nBkhHzvNBWTB20/5ws
 D/Z/CbMFtTLggU44MEzsvVbzh9AK7ugtr7wZgHSxwy1WZPmiPJ1lWT5whqPctMZ5nRJ5
 sPO62x9KQr4V/lLMM8AqrcJC2uaMw8dQMgUlwAKzsim2YjmaOC29XqKsNG95dG7+4X7l
 FHCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=eZ0cdI79ADlanekkYUSD9fAGVZvM6bIrF+Eq4A7Ygd0=;
 b=xy6a7nNOnK8NEwEpa34BMs3QS/qkd7T53PJlJSPPXdZ9Iyyek7wsz5GxBkBYRg1KH/
 qAyZP2zPTDAuJJb2pNe3+MRkKCdezmriX7yLWcHT3tVz55fNxY4HsQzAlHDEuW1bWUah
 J/BcMYn3fNYPyqSgJpwIGuJB/iE8iz7anidN3CbUynzJwLrUH5wkWylV/4IIaN3wP5yw
 gwvZEJB7RkF1q5GRHn9Ex2nDjyICicYW5zwgit2QT0YIqxmPLtx+GQFszEbq24BWdYRW
 wpzzzxSUbJmjUNk5loPBSOn0QVrDBK14ET/MFaWWUnq9wvdvnhdN4uGZK+Jr/lmaYfbN
 IOYQ==
X-Gm-Message-State: ACrzQf1EItXmWpsT+7Rz8gaKS6wzhW+Zr1pNjMsVoRMqmBYlkEYRBquW
 vaEzNhPB21WQed9m8tCPTSUjzQ==
X-Google-Smtp-Source: AMsMyM41AXX3Xp6kESIBHSUm21LCu3v/fFVnruKqRqDloxK7fMPiUbElSAmaa5TqV5mp/qM93oOECQ==
X-Received: by 2002:a65:6a12:0:b0:445:84f6:676a with SMTP id
 m18-20020a656a12000000b0044584f6676amr6173417pgu.40.1665783459080; 
 Fri, 14 Oct 2022 14:37:39 -0700 (PDT)
Received: from google.com (220.181.82.34.bc.googleusercontent.com.
 [34.82.181.220]) by smtp.gmail.com with ESMTPSA id
 a6-20020a1709027e4600b0017a0f40fa19sm2122355pln.191.2022.10.14.14.37.38
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 14 Oct 2022 14:37:38 -0700 (PDT)
Date: Fri, 14 Oct 2022 14:37:34 -0700
From: Ricardo Koller <ricarkol@google.com>
To: Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH v9 00/14] KVM: selftests: Add aarch64/page_fault_test
Message-ID: <Y0nWnr7GaPbBfLtf@google.com>
References: <20221011010628.1734342-1-ricarkol@google.com>
 <Y0nU4vIIyjfQuQGV@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <Y0nU4vIIyjfQuQGV@google.com>
Cc: kvm@vger.kernel.org, maz@kernel.org, bgardon@google.com,
 andrew.jones@linux.dev, kvmarm@lists.linux.dev, pbonzini@redhat.com,
 axelrasmussen@google.com, kvmarm@lists.cs.columbia.edu, dmatlack@google.com
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

On Fri, Oct 14, 2022 at 09:30:10PM +0000, Sean Christopherson wrote:
> On Tue, Oct 11, 2022, Ricardo Koller wrote:
> > Ricardo Koller (14):
> >   KVM: selftests: Add a userfaultfd library
> >   KVM: selftests: aarch64: Add virt_get_pte_hva() library function
> >   KVM: selftests: Add missing close and munmap in
> >     __vm_mem_region_delete()
> >   KVM: selftests: aarch64: Construct DEFAULT_MAIR_EL1 using sysreg.h
> >     macros
> >   tools: Copy bitfield.h from the kernel sources
> >   KVM: selftests: Stash backing_src_type in struct userspace_mem_region
> >   KVM: selftests: Add vm->memslots[] and enum kvm_mem_region_type
> >   KVM: selftests: Fix alignment in virt_arch_pgd_alloc() and
> >     vm_vaddr_alloc()
> >   KVM: selftests: Use the right memslot for code, page-tables, and data
> >     allocations
> >   KVM: selftests: aarch64: Add aarch64/page_fault_test
> >   KVM: selftests: aarch64: Add userfaultfd tests into page_fault_test
> >   KVM: selftests: aarch64: Add dirty logging tests into page_fault_test
> >   KVM: selftests: aarch64: Add readonly memslot tests into
> >     page_fault_test
> >   KVM: selftests: aarch64: Add mix of tests into page_fault_test
> 
> A bunch of nits, mostly about alignment/indentation, but otherwise no more whining
> on my end.  A v10 would probably be nice to avoid churn?  But I'm also ok if y'all
> want to merge this asap and do the cleanup on top.

No prob, will send a v10 (most likely on Monday).

Thanks!
Ricardo
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
