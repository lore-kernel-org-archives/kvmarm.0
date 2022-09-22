Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD7EFC54EE9
	for <kvmarm@archiver.kernel.org>; Thu, 22 Sep 2022 19:32:52 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 268DE4B282;
	Thu, 22 Sep 2022 15:32:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id t5BkV301rpgm; Thu, 22 Sep 2022 15:32:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E476F4B256;
	Thu, 22 Sep 2022 15:32:50 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9C4544B256
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Sep 2022 15:32:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OR2W71j-YzhJ for <kvmarm@lists.cs.columbia.edu>;
 Thu, 22 Sep 2022 15:32:48 -0400 (EDT)
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com
 [209.85.216.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 307EE4B08A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Sep 2022 15:32:48 -0400 (EDT)
Received: by mail-pj1-f44.google.com with SMTP id
 x1-20020a17090ab00100b001fda21bbc90so3459822pjq.3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Sep 2022 12:32:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date;
 bh=Ny4mS6pSDyL84H1BdG99sfUYk9g3T27xf8u3RbpkR3g=;
 b=ew8sDwy+EkU8W7ZAio8iLRqNCKXMaSBkLgJi0QS4iv3I14D1Mw/Q4iitHB92m+HF4A
 33oEJIfBRydLjz9JNuf1axbwtLHhS8r8ZbP3DhUX7Y570jsP0XVN+bKhqSMTZnq3O7hQ
 R4wVJOv4o0HUTE/xMCQ9hdDMsfc/sWLPuvCPNg5s3Ia72spYvozxWOFbFIN0ra+hDK/v
 xzi2hsDPz1FlBp87VIdCo93fphkP/od4Knzia3WU1sDMsUfu2tP0P5kMZCw/P69sVjGe
 UvaCwOnXCCSBOPR8f0DJxgIyCHA3+rb9va8Px+Xzx4KuotM32lhTMzfKXSESqpukjG+W
 guZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
 bh=Ny4mS6pSDyL84H1BdG99sfUYk9g3T27xf8u3RbpkR3g=;
 b=PvLeCso9xTHjZIhVzwCDZck6GUB14AcebNYRGXjOq4Ep5w0L8G4EjP+uqdn23WycdK
 /Yo4JTdA/yKfmtbbGZu083Ulj9TYPGtXhzite2k876onMbQZeW2qgU0xFMMrjmQkcA4d
 sh4EQcXRCEika0tOBxR2zVpvH+LlH6XQFyTyZAU/aczrO3s5cRGtXRQzhdE80eBIM9Ww
 IXKmTNm9gLgwmr5CdnHnhqEMIYImUyC7dQs45q/TkWdiMQ2/Ruh61LK7fypgjJSg7CnH
 8qLH86ApCvCRHs5XhdKuEFJKMXY4NnzlSAR9JcrbEYlcb7I23NoCT/sXd+qmBZQ14Fe7
 Zh6Q==
X-Gm-Message-State: ACrzQf0EEF1CH8ZdteoUWBhYU59JzDSqMl3oZCKmoO6q5cSM23iy53Kl
 L86psV/tzN/V+Au6MLFFkJBMkg==
X-Google-Smtp-Source: AMsMyM56UY+azR04/Q7tdxr2gQHDeSWmzGZg2J4abiFuofIPx2Zvmd0WSJChG1Ko2HRLwnzZ77A3AQ==
X-Received: by 2002:a17:903:32cf:b0:178:3d49:45b0 with SMTP id
 i15-20020a17090332cf00b001783d4945b0mr4732611plr.5.1663875167015; 
 Thu, 22 Sep 2022 12:32:47 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com.
 [34.168.104.7]) by smtp.gmail.com with ESMTPSA id
 s8-20020a170902ea0800b00179b6d0f90esm1877037plg.159.2022.09.22.12.32.46
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 22 Sep 2022 12:32:46 -0700 (PDT)
Date: Thu, 22 Sep 2022 19:32:42 +0000
From: Sean Christopherson <seanjc@google.com>
To: Ricardo Koller <ricarkol@google.com>
Subject: Re: [PATCH v8 10/14] KVM: selftests: aarch64: Add
 aarch64/page_fault_test
Message-ID: <Yyy4WjEmuSH1tSZb@google.com>
References: <20220922031857.2588688-1-ricarkol@google.com>
 <20220922031857.2588688-11-ricarkol@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220922031857.2588688-11-ricarkol@google.com>
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

On Thu, Sep 22, 2022, Ricardo Koller wrote:
> +/* Returns true to continue the test, and false if it should be skipped. */
> +static bool punch_hole_in_memslot(struct kvm_vm *vm,

This is a very misleading name, and IMO is flat out wrong.  The helper isn't
punching a hole in the memslot, it's punching a hole in the backing store, and
those are two very different things.  Encountering a hole in a _memslot_ yields
emualted MMIO semantics, not CoW zero page semantics.

Ideally, if we can come up with a not awful name, I'd also prefer to avoid "punch
hole" in the function name.  I can't think of a better alternative, so it's not
the end of the world if we're stuck with e.g punch_hole_in_backing_store(), but I
think the "punch_hole" name will be confusing for readers that are unfamiliar with
PUNCH_HOLE, especially for anonymous memory as "punching a hole" in anonymous
memory is more likely to be interpreted as "munmap()".

> +				  struct userspace_mem_region *region)
> +{
> +	void *hva = (void *)region->region.userspace_addr;
> +	uint64_t paging_size = region->region.memory_size;
> +	int ret, fd = region->fd;
> +
> +	if (fd != -1) {
> +		ret = fallocate(fd, FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
> +				0, paging_size);
> +		TEST_ASSERT(ret == 0, "fallocate failed, errno: %d\n", errno);
> +	} else {
> +		if (is_backing_src_hugetlb(region->backing_src_type))
> +			return false;

Why is hugetlb disallowed?  I thought anon hugetlb supports MADV_DONTNEED?

> +
> +		ret = madvise(hva, paging_size, MADV_DONTNEED);
> +		TEST_ASSERT(ret == 0, "madvise failed, errno: %d\n", errno);
> +	}
> +
> +	return true;
> +}

...

> +	/*
> +	 * Accessing a hole in the data memslot (punched with fallocate or

s/memslot/backing store

> +	 * madvise) shouldn't fault (more sanity checks).


Naming aside, please provide more detail as to why this is the correct KVM
behavior.  This is quite subtle and relies on gory implementation details that a
lot of KVM developers will be unaware of.

Specifically, from an accessibility perspective, PUNCH_HOLE doesn't actually create
a hole in the file.  The "hole" can still be read and written; the "expect '0'"
checks are correct specifically because those are the semantics of PUNCH_HOLE.

In other words, it's not just that the accesses shouldn't fault, reads _must_
return zeros and writes _must_ re-populate the page.

Compare that with e.g. ftruncate() that makes the size of the file smaller, in
which case an access should result in KVM exiting to userspace with -EFAULT.

> +	 */
> +	TEST_ACCESS(guest_read64, no_af, CMD_HOLE_DATA),
> +	TEST_ACCESS(guest_cas, no_af, CMD_HOLE_DATA),
> +	TEST_ACCESS(guest_ld_preidx, no_af, CMD_HOLE_DATA),
> +	TEST_ACCESS(guest_write64, no_af, CMD_HOLE_DATA),
> +	TEST_ACCESS(guest_st_preidx, no_af, CMD_HOLE_DATA),
> +	TEST_ACCESS(guest_at, no_af, CMD_HOLE_DATA),
> +	TEST_ACCESS(guest_dc_zva, no_af, CMD_HOLE_DATA),
> +
> +	{ 0 }
> +};
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
