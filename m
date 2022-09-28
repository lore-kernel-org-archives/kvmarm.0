Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F706C32771
	for <kvmarm@archiver.kernel.org>; Wed, 28 Sep 2022 18:10:34 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C8FF94B62E;
	Wed, 28 Sep 2022 14:10:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id a7T5vAWydt20; Wed, 28 Sep 2022 14:10:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A402F4B648;
	Wed, 28 Sep 2022 14:10:32 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5E2684B600
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Sep 2022 14:10:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7z0g7Ac0iSG0 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Sep 2022 14:10:30 -0400 (EDT)
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com
 [209.85.214.174])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4EC804086C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Sep 2022 14:10:30 -0400 (EDT)
Received: by mail-pl1-f174.google.com with SMTP id v1so12389882plo.9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Sep 2022 11:10:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date;
 bh=bs5D0g2ItumdYX+ue+ZykeItEbF4U1JZ3UggoNJ4PwY=;
 b=if4oJ2uaIlB5lHRl7AMaFhWanHUi2pKzVlq8kBHrN93nEhlmd2g5rntnMaoyfdrF5m
 f6rsyEcJ16qH5u/8AYc7teYzcjN45HL9qcdW/CGiSGL4fl+bTYDnOtOTzCEcf4RHIRPo
 frWDcrNldeknW5r1vi8+diUa5uRH9nCnkJBU/gmR/Ed9m/36ou218pq/u0CvE6DpX3/8
 XhmuE9/SdGRN+gnsBFg37PEANcDy2ZgUQMgIEIF7/YrY8obzVdXbiHJUn/e/L84wAi9P
 0dKxtL7ZZxbu4erRKmgkcJCWeeoKHEHlpJbwkiPnOfRPWkofycrlgDUuCQixwIICTYkK
 fIAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
 bh=bs5D0g2ItumdYX+ue+ZykeItEbF4U1JZ3UggoNJ4PwY=;
 b=LbjA7RIgCcgY+oWU4vT1TBykHSoUpbtI+uHRGwAJlETChy8B+PGgIQQemGCIrg3mwc
 03SKuLDDw/0LAqf3plzeB/g046mIYCevscFlaED2xC8SqI9hlTNq7eFu6tsaWcm8YmBu
 caxXY8M+gmIM/4OUX22pJ7ROXKk+xaCU2V79QxHBOphpyLCoDYBPUilqC6DcrNfcFHmg
 0SVQTuOuplikGyY5wHmtlpQ7hY9u/69JsOdlN/BE/xSzzoWsYbNS1u5n3IA+RTCbwGoR
 AGX0KnUk2Y+AVMAXx6ykqyAy67EfoZP8QJzROzSVjH75JBNWkkW02MyHlfn8ySJlEdEI
 jZ9Q==
X-Gm-Message-State: ACrzQf2KUFQ2Pq2/HLE3fhvACAWWkRYE1JN1AQhU11RMR4VZZ2SCBxSy
 zcev2XEsW5M7gmwNv/YxzKE7Cg==
X-Google-Smtp-Source: AMsMyM6sgEQzXow3Ue2nk5mlmhCBBzZ7H3WqSCOpv+sMEOnIornuNw1RUHnOPUTWNYIExbARkbbRsw==
X-Received: by 2002:a17:902:bd8b:b0:179:d10e:97f with SMTP id
 q11-20020a170902bd8b00b00179d10e097fmr1041600pls.18.1664388629063; 
 Wed, 28 Sep 2022 11:10:29 -0700 (PDT)
Received: from google.com (220.181.82.34.bc.googleusercontent.com.
 [34.82.181.220]) by smtp.gmail.com with ESMTPSA id
 h3-20020a628303000000b0053e8f4a10c1sm4266103pfe.217.2022.09.28.11.10.28
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 28 Sep 2022 11:10:28 -0700 (PDT)
Date: Wed, 28 Sep 2022 11:10:25 -0700
From: Ricardo Koller <ricarkol@google.com>
To: Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH v8 10/14] KVM: selftests: aarch64: Add
 aarch64/page_fault_test
Message-ID: <YzSOEYBp25DKYNVa@google.com>
References: <20220922031857.2588688-1-ricarkol@google.com>
 <20220922031857.2588688-11-ricarkol@google.com>
 <Yyy4WjEmuSH1tSZb@google.com> <YzHfwmZqMQ9xXaNa@google.com>
 <YzNz36gZqrse9GzT@google.com> <YzPMaEPBtaXguJaT@google.com>
 <YzR9TRjVFi+P7UOp@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <YzR9TRjVFi+P7UOp@google.com>
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

On Wed, Sep 28, 2022 at 04:58:53PM +0000, Sean Christopherson wrote:
> On Tue, Sep 27, 2022, Ricardo Koller wrote:
> > On Tue, Sep 27, 2022 at 10:06:23PM +0000, Sean Christopherson wrote:
> > > On Mon, Sep 26, 2022, Ricardo Koller wrote:
> > > > On Thu, Sep 22, 2022 at 07:32:42PM +0000, Sean Christopherson wrote:
> > > > > On Thu, Sep 22, 2022, Ricardo Koller wrote:
> > > > > > +	void *hva = (void *)region->region.userspace_addr;
> > > > > > +	uint64_t paging_size = region->region.memory_size;
> > > > > > +	int ret, fd = region->fd;
> > > > > > +
> > > > > > +	if (fd != -1) {
> > > > > > +		ret = fallocate(fd, FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
> > > > > > +				0, paging_size);
> > > > > > +		TEST_ASSERT(ret == 0, "fallocate failed, errno: %d\n", errno);
> > > > > > +	} else {
> > > > > > +		if (is_backing_src_hugetlb(region->backing_src_type))
> > > > > > +			return false;
> > > > > 
> > > > > Why is hugetlb disallowed?  I thought anon hugetlb supports MADV_DONTNEED?
> > > > > 
> > > > 
> > > > It fails with EINVAL (only tried on arm) for both the PAGE_SIZE and the huge
> > > > page size. And note that the address is aligned as well.
> > > > 
> > > > madvise(0xffffb7c00000, 2097152, MADV_DONTNEED) = -1 EINVAL (Invalid argument)
> > > > 	^^^^^^^^^^^^^^	^^^^^^^
> > > > 	2M aligned	2M (hugepage size)
> > > > 			
> > > > madvise(0xffff9e800000, 4096, MADV_DONTNEED) = -1 EINVAL (Invalid argument)   
> > > > 			^^^^
> > > > 			PAGE_SIZE
> > > 
> > > I think this needs to be root caused before merging.  Unless I'm getting turned
> > > around, MADV_DONTEED should work, i.e. there is a test bug lurking somewhere.
> > 
> > Turns out that the failure is documented. Found this in the madvise manpage:
> > 
> >   MADV_DONTNEED cannot be applied to locked pages, Huge TLB pages, or VM_PFNMAP pages.
> 
> The manpages are stale:
> 
>    c4b6cb884011 ("selftests/vm: add hugetlb madvise MADV_DONTNEED MADV_REMOVE test")
>    90e7e7f5ef3f ("mm: enable MADV_DONTNEED for hugetlb mappings")
> 
> The tools/testing/selftests/vm/hugetlb-madvise.c selftest effectively tests what
> is being done here, so _something_ is broken.

Thanks for the pointers. I was using old kernels (~5.15) for these
latest tests. Testing on a 6.0-rc3 kernel fixed things: now able to
madvise(MADV_DONTNEED) on anon-hugetlb from the selftest (arm).

Will remove the check (for skppping the test) in v9.

Thanks!
Ricardo
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
