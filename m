Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF0D2C04A95
	for <kvmarm@archiver.kernel.org>; Wed, 28 Sep 2022 04:24:19 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EBA824B62E;
	Wed, 28 Sep 2022 00:24:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id b8OP-zfh8lOo; Wed, 28 Sep 2022 00:24:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9AE4F4B636;
	Wed, 28 Sep 2022 00:24:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E24D24B62E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Sep 2022 00:24:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ueEKeUWbVYu8 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Sep 2022 00:24:14 -0400 (EDT)
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com
 [209.85.216.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C2BF54B177
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Sep 2022 00:24:14 -0400 (EDT)
Received: by mail-pj1-f49.google.com with SMTP id
 q35-20020a17090a752600b002038d8a68fbso798324pjk.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2022 21:24:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date;
 bh=84y5cVFPqn7JdmKlB0INiH26jqZn3FwsuFj1nkhevE0=;
 b=leb1DMlrdBQlXituY1fllABDc1rX2Y/sfj5EjhSd00SHDHjY5TrDzEGj+vKXQmmONs
 /xdw+DFqbet7/tgeJWT7Wf81yXRJkVgXTFjIBPgI0ZWU+0t3w8H+c5ReVPeXVur5oWFM
 qjTMbUzJN0dl1dexQVQ/BS5ADe3iPO7v2sXw16iby8v0YuMsTQDBY51CVwTl2sTg/Ww6
 POyz1gvu3l4/31WwpFY/47fP3kmynWQYWaRB5QvAatYQ6kD8f7Eu0KVs1v8FPEEOCNFU
 tjXv0EGR4KHOUkPX86yeDOeFBXLQVtWeFdVMyeW9omz70tnYH9hLS3GQY4b5wlnpUFOZ
 hMBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
 bh=84y5cVFPqn7JdmKlB0INiH26jqZn3FwsuFj1nkhevE0=;
 b=3SFgxv0rx54pN1rh9mGTpBjzIVr+lWwtIRAks02DayYJZxeip/YSIv+xUC9zHZjmaI
 OCDyMJl0pc8vUxlbp0YHVTv/6dwKKW1MMFLiUBMt7oJ+9AUXco8KRCbuQ/R/yxwd+jAL
 pquzilgGmGtRKfSi3hMt6/fqb9bUKPZtEiuSHbnR6Iu5mMrIrhNJwMNIEAi75NdPtnEK
 GpNtdmueSqjAWU0w2Sz1GprKG7ZaEssmpqppbBdhYMrBRWGv7V/sYUtkvvCj5zjIGYob
 Dk5kXlt6bEunF0HdUSJKqd+XpZqm8gLQ7lmLHSihlkBO12kNyoNVhgjArGZ+S4ydYS8k
 dKhg==
X-Gm-Message-State: ACrzQf2k9cT66OvzoSxh8sm6FZN4qFS+7ChLCmNB7xg7uIKZTpTk8CVK
 bbQpzZw20V3gFuL6gBTVx3q5dQ==
X-Google-Smtp-Source: AMsMyM6O7dOJoGrGACvEl/k7n7NYRr028Nsgp4sVYpO6c9B/6uiJJ83uMjNC1TjMMFAEKfz6blk6Rw==
X-Received: by 2002:a17:902:e807:b0:179:fc64:7288 with SMTP id
 u7-20020a170902e80700b00179fc647288mr3586121plg.137.1664339053509; 
 Tue, 27 Sep 2022 21:24:13 -0700 (PDT)
Received: from google.com (220.181.82.34.bc.googleusercontent.com.
 [34.82.181.220]) by smtp.gmail.com with ESMTPSA id
 y15-20020a17090a2b4f00b002005fcd2cb4sm412541pjc.2.2022.09.27.21.24.12
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 27 Sep 2022 21:24:12 -0700 (PDT)
Date: Tue, 27 Sep 2022 21:24:08 -0700
From: Ricardo Koller <ricarkol@google.com>
To: Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH v8 10/14] KVM: selftests: aarch64: Add
 aarch64/page_fault_test
Message-ID: <YzPMaEPBtaXguJaT@google.com>
References: <20220922031857.2588688-1-ricarkol@google.com>
 <20220922031857.2588688-11-ricarkol@google.com>
 <Yyy4WjEmuSH1tSZb@google.com> <YzHfwmZqMQ9xXaNa@google.com>
 <YzNz36gZqrse9GzT@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <YzNz36gZqrse9GzT@google.com>
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

On Tue, Sep 27, 2022 at 10:06:23PM +0000, Sean Christopherson wrote:
> On Mon, Sep 26, 2022, Ricardo Koller wrote:
> > On Thu, Sep 22, 2022 at 07:32:42PM +0000, Sean Christopherson wrote:
> > > On Thu, Sep 22, 2022, Ricardo Koller wrote:
> > > > +	void *hva = (void *)region->region.userspace_addr;
> > > > +	uint64_t paging_size = region->region.memory_size;
> > > > +	int ret, fd = region->fd;
> > > > +
> > > > +	if (fd != -1) {
> > > > +		ret = fallocate(fd, FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
> > > > +				0, paging_size);
> > > > +		TEST_ASSERT(ret == 0, "fallocate failed, errno: %d\n", errno);
> > > > +	} else {
> > > > +		if (is_backing_src_hugetlb(region->backing_src_type))
> > > > +			return false;
> > > 
> > > Why is hugetlb disallowed?  I thought anon hugetlb supports MADV_DONTNEED?
> > > 
> > 
> > It fails with EINVAL (only tried on arm) for both the PAGE_SIZE and the huge
> > page size. And note that the address is aligned as well.
> > 
> > madvise(0xffffb7c00000, 2097152, MADV_DONTNEED) = -1 EINVAL (Invalid argument)
> > 	^^^^^^^^^^^^^^	^^^^^^^
> > 	2M aligned	2M (hugepage size)
> > 			
> > madvise(0xffff9e800000, 4096, MADV_DONTNEED) = -1 EINVAL (Invalid argument)   
> > 			^^^^
> > 			PAGE_SIZE
> 
> I think this needs to be root caused before merging.  Unless I'm getting turned
> around, MADV_DONTEED should work, i.e. there is a test bug lurking somewhere.

Turns out that the failure is documented. Found this in the madvise manpage:

  MADV_DONTNEED cannot be applied to locked pages, Huge TLB pages, or VM_PFNMAP pages.

Was also playing with the following non-selftest program (before checking the
manpage, and I now remember that I actually read the above sentence before).

This fails on both x86 and arm:

	#include <stdio.h>
	#include <stddef.h>
	#include <sys/mman.h>
	#include <linux/mman.h>
	#include <assert.h>

	#define SZ_2M (1 << 21)

	int main()
	{
		void *p = mmap(NULL, SZ_2M, PROT_READ | PROT_WRITE,
			       MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB | MAP_HUGE_2MB,
			       -1, 0);
		assert(p != MAP_FAILED);
		assert(madvise(p, 4096, MADV_DONTNEED) == 0); // this fails
		assert(madvise(p, SZ_2M, MADV_DONTNEED) == 0); // this fails
	}

And for completeness, this passes on both:

	int main()
	{
		void *p = mmap(NULL, SZ_2M, PROT_READ | PROT_WRITE,
			       MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
		assert(p != MAP_FAILED);
		assert(madvise(p, SZ_2M, MADV_DONTNEED) == 0);
	}
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
