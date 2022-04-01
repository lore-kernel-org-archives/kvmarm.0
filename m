Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFF1AC433F5
	for <kvmarm@archiver.kernel.org>; Fri,  1 Apr 2022 14:05:44 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 307944B25D;
	Fri,  1 Apr 2022 10:05:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GUExAQ+kcp+m; Fri,  1 Apr 2022 10:05:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 56E404B259;
	Fri,  1 Apr 2022 10:05:39 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9F2CA4B25D
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Apr 2022 10:05:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VfZ974K1JV4y for <kvmarm@lists.cs.columbia.edu>;
 Fri,  1 Apr 2022 10:05:36 -0400 (EDT)
Received: from mail-il1-f181.google.com (mail-il1-f181.google.com
 [209.85.166.181])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 97F684B245
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Apr 2022 10:05:36 -0400 (EDT)
Received: by mail-il1-f181.google.com with SMTP id z10so2050639iln.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 01 Apr 2022 07:05:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=uXCsVFWD0w4UXVh3Fm9w12+K/OXplZUFIZtiYekvHOc=;
 b=OnRuDW1exu8WenVX/hdv7SauOsLKx9F7IbXLwA5bW1DRWnwcvgCQCLyRK1ri6iZlDi
 eQwsmB8XJ8egNj7UM1643Rt0PfDFFSRhMpNflrh8tRDOYw6w+dbSh0ScSRu95tYOQIq4
 bmbc6oZtQEMLODJE0iaSN4Pt0Ge1WcXAPwLVQixNil046ixreKkN1UYI4Er2jeeuqCR8
 Zwwa4zVlf/bV4mnY+T+kqNbNrMvcb2ypeFTOvoqNLWzy8Q9+6OWMxG+rES6zex+cdNnR
 6e9Zx1ZUkAv9JoJbA7FERY8waWfpDlCcjWjSs2EoCq12eG0deRpR5Vnc/j6AbcPiAhvl
 F4gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=uXCsVFWD0w4UXVh3Fm9w12+K/OXplZUFIZtiYekvHOc=;
 b=M9zqBjagEIFBw332VTVomKrBUmhc2oshK+tc4sSpCwBut0fxe7UqLnVSSC9gW9zPpX
 PubIEumLVVlGbHTfANgCdj2A26xk2Yh6g/Sq0pA8XVsAXrJMwA5EyiN368YAAw/iq+gf
 Z8sG9YhOdneOEf2Wx2PtlrF5qMJzH6qaZydpYFw6DnCuSIiA63lPyYznQwZYx9nShi+6
 SUssmhyUznGD97hIBrtcgJkScrdsTFIV/ySogUBx8X4/w9r6LPFVoqQhMZb6SNwodI0g
 M8LTyGm3WAvfBSdjwVhiN6XFchkv24WOEO5hHyeAlxNDbKJepGr7Ss72Ph/4G9wUcaZ6
 5RjA==
X-Gm-Message-State: AOAM530jO8QjSLIQxoYi5iZ6C/tlbz/Xof/jdpUfBYe2Stum+YL6Lblk
 JrYPT64k/mz+ibY+8DT8x/0nIg==
X-Google-Smtp-Source: ABdhPJwE8ilKQ9QfD3xy/86HeFqHu2rPR9sYvkA0605Z0iQcRtHcmIDbU/M+ee2N5iC+wi8KuITDFA==
X-Received: by 2002:a05:6e02:1b0f:b0:2c7:9ec2:1503 with SMTP id
 i15-20020a056e021b0f00b002c79ec21503mr15653859ilv.209.1648821935764; 
 Fri, 01 Apr 2022 07:05:35 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194]) by smtp.gmail.com with ESMTPSA id
 h5-20020a92c085000000b002c9fcc469c8sm1342037ile.81.2022.04.01.07.05.34
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 01 Apr 2022 07:05:34 -0700 (PDT)
Date: Fri, 1 Apr 2022 14:05:31 +0000
From: Oliver Upton <oupton@google.com>
To: Reiji Watanabe <reijiw@google.com>
Subject: Re: [PATCH] KVM: arm64: Don't split hugepages outside of MMU write
 lock
Message-ID: <YkcGq5IHx5HUodGd@google.com>
References: <20220331213844.2894006-1-oupton@google.com>
 <CAAeT=FzmvwmXoxn41xqYJByNgGMwCRViCUP9yZ0cun13nJ43PQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAAeT=FzmvwmXoxn41xqYJByNgGMwCRViCUP9yZ0cun13nJ43PQ@mail.gmail.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 kvmarm@lists.cs.columbia.edu, Linux ARM <linux-arm-kernel@lists.infradead.org>
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

Hi Reiji,

Thanks for the review!

On Thu, Mar 31, 2022 at 11:07:23PM -0700, Reiji Watanabe wrote:
> > @@ -1267,10 +1268,24 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> >          */
> >         if (fault_status == FSC_PERM && vma_pagesize == fault_granule) {
> >                 ret = kvm_pgtable_stage2_relax_perms(pgt, fault_ipa, prot);
> 
> When use_read_lock is set to true, it appears the above condition will
> become always true (since fault_granule is PAGE_SIZE and force_pte
> is true in this case).  So, I don't think the following "else" changes
> really make any difference.  (Or am I overlooking something?)
> Looking at the code, I doubt that even the original (before the regression)
> code detects the case that is described in the comment below in the
> first place.

Yes, you are right.

I liked the explicit check against !use_read_lock (even if it is dead)
to make it abundantly clear what is guarded by the write lock.
Personally, I'm not a big fan of the conditional locking because it is
hard to tell exactly what is protected by the read or write lock.

Maybe instead a WARN() could suffice. That way we bark at anyone who
changes MMU locking again and breaks it. I found the bug with the splat
above, but warning about replacing an already present PTE is rather far
removed from the smoking gun in this situation.

Outside of the regression, I believe there are some subtle races where
stage-2 is modified before taking the MMU lock. I'm going to think
further about the implications of these, but perhaps we should pass
through a page level argument to kvm_pagetable_stage2_relax_perms() and
only do the operation if the paging structures match what is reported in
the FSC. If the IPA is not in fact mapped at the specified page level,
retry the faulting instruction.

I'll get a patch up that addresses your comment and crams a WARN() in to
assert the write lock is held.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
