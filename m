Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20682C54EE9
	for <kvmarm@archiver.kernel.org>; Wed, 28 Sep 2022 16:59:03 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8B3084B63F;
	Wed, 28 Sep 2022 12:59:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id StQR5USMh2pe; Wed, 28 Sep 2022 12:59:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 649714B645;
	Wed, 28 Sep 2022 12:59:02 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5DEE14B62E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Sep 2022 12:59:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WgDKOzThM+5S for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Sep 2022 12:59:00 -0400 (EDT)
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com
 [209.85.214.174])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 454D54B63F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Sep 2022 12:59:00 -0400 (EDT)
Received: by mail-pl1-f174.google.com with SMTP id w20so12227549ply.12
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Sep 2022 09:59:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date;
 bh=JPHVsQZph796quobJWecE9d8WYuQzTyeUzZ9fJLJCt0=;
 b=YoST0dNL+tr2MxBQPBb3gEUaaq2rchEwRpYCm/C4/zvdm9UbKh4weE6f9Rse5smcva
 0ahnHpBHQGqD6xuD07bwTCdT6qGIDSf9F6/AboMMdLNCblGFmx69YPL/461ja3bispRg
 k153DDi1J/ci/zwEhY4ofIjbRC0HhlW960PgWUe/WeFDrYHoLQ39lc8uF/VM7e5pQVuz
 2eTDb0AMqf01PjFToZsmQF4Fj0BS16kv5rz2+m7xcKElBgh8RAV574fvfcPkJMbQVVgU
 43/eaF6HCiqUcc3OI8Dv6vd+rxicq1Qoydc+AH/IWaov28Ka3KoT6aBdmKLOjV3965OP
 xnjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
 bh=JPHVsQZph796quobJWecE9d8WYuQzTyeUzZ9fJLJCt0=;
 b=Xdr96rbwJAsL/Z5Nw1eaW/tLopSsNDSvCwqFOyDydFmgsOK5tx+m0S+cF0MuMkXMxH
 6JybScRJSRzqvEkDptXNwsUMBfwBRAwHfdhobzdUH0vwtjjsRMj7lOOsDn+kk+hVpgRt
 x1fgUos3JFRuDj6HZFjLDwXdlgACgr2lpGfvhgdFEGFrMkkMDrCj54iyeG/Ov9CzLCLD
 Z+/dVTHjLW3VeY9FDDknryXJuXfjF5gIsIZdWcWI6aROb0j8EswZrAvt1kEKGVvT6C4O
 L/ClKkQ9NC4PFr4ztGlwDjaaZ7aCIQsVsGXTJAoVg8hBiBJSRuqoUl/wLsl2lYaXYKMn
 W1zQ==
X-Gm-Message-State: ACrzQf2O1KophBNVhZGyb1bkjnLUrDRPZyA5UyeeTjGcLa+RGNXHhJ0Y
 d+BU+gzWSlWGad2oCNhQRuH7UQ==
X-Google-Smtp-Source: AMsMyM6PrX/MsmRBqg1sXs0jHHhg5Yrxul40DjOGHB7X7ofNSd1KnKk+KnOzfR/QXB8u3pbAG0zRAQ==
X-Received: by 2002:a17:90a:4e8a:b0:203:9556:1b7d with SMTP id
 o10-20020a17090a4e8a00b0020395561b7dmr11605672pjh.0.1664384338687; 
 Wed, 28 Sep 2022 09:58:58 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com.
 [34.168.104.7]) by smtp.gmail.com with ESMTPSA id
 e8-20020a056a0000c800b005361f6a0573sm4218372pfj.44.2022.09.28.09.58.57
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 28 Sep 2022 09:58:58 -0700 (PDT)
Date: Wed, 28 Sep 2022 16:58:53 +0000
From: Sean Christopherson <seanjc@google.com>
To: Ricardo Koller <ricarkol@google.com>
Subject: Re: [PATCH v8 10/14] KVM: selftests: aarch64: Add
 aarch64/page_fault_test
Message-ID: <YzR9TRjVFi+P7UOp@google.com>
References: <20220922031857.2588688-1-ricarkol@google.com>
 <20220922031857.2588688-11-ricarkol@google.com>
 <Yyy4WjEmuSH1tSZb@google.com> <YzHfwmZqMQ9xXaNa@google.com>
 <YzNz36gZqrse9GzT@google.com> <YzPMaEPBtaXguJaT@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <YzPMaEPBtaXguJaT@google.com>
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

On Tue, Sep 27, 2022, Ricardo Koller wrote:
> On Tue, Sep 27, 2022 at 10:06:23PM +0000, Sean Christopherson wrote:
> > On Mon, Sep 26, 2022, Ricardo Koller wrote:
> > > On Thu, Sep 22, 2022 at 07:32:42PM +0000, Sean Christopherson wrote:
> > > > On Thu, Sep 22, 2022, Ricardo Koller wrote:
> > > > > +	void *hva = (void *)region->region.userspace_addr;
> > > > > +	uint64_t paging_size = region->region.memory_size;
> > > > > +	int ret, fd = region->fd;
> > > > > +
> > > > > +	if (fd != -1) {
> > > > > +		ret = fallocate(fd, FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
> > > > > +				0, paging_size);
> > > > > +		TEST_ASSERT(ret == 0, "fallocate failed, errno: %d\n", errno);
> > > > > +	} else {
> > > > > +		if (is_backing_src_hugetlb(region->backing_src_type))
> > > > > +			return false;
> > > > 
> > > > Why is hugetlb disallowed?  I thought anon hugetlb supports MADV_DONTNEED?
> > > > 
> > > 
> > > It fails with EINVAL (only tried on arm) for both the PAGE_SIZE and the huge
> > > page size. And note that the address is aligned as well.
> > > 
> > > madvise(0xffffb7c00000, 2097152, MADV_DONTNEED) = -1 EINVAL (Invalid argument)
> > > 	^^^^^^^^^^^^^^	^^^^^^^
> > > 	2M aligned	2M (hugepage size)
> > > 			
> > > madvise(0xffff9e800000, 4096, MADV_DONTNEED) = -1 EINVAL (Invalid argument)   
> > > 			^^^^
> > > 			PAGE_SIZE
> > 
> > I think this needs to be root caused before merging.  Unless I'm getting turned
> > around, MADV_DONTEED should work, i.e. there is a test bug lurking somewhere.
> 
> Turns out that the failure is documented. Found this in the madvise manpage:
> 
>   MADV_DONTNEED cannot be applied to locked pages, Huge TLB pages, or VM_PFNMAP pages.

The manpages are stale:

   c4b6cb884011 ("selftests/vm: add hugetlb madvise MADV_DONTNEED MADV_REMOVE test")
   90e7e7f5ef3f ("mm: enable MADV_DONTNEED for hugetlb mappings")

The tools/testing/selftests/vm/hugetlb-madvise.c selftest effectively tests what
is being done here, so _something_ is broken.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
