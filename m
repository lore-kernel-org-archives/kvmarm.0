Return-Path: <SRS0=p2dm=M2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,FSL_HELO_FAKE,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B1D5C432BE
	for <kvmarm@archiver.kernel.org>; Tue,  3 Aug 2021 10:20:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id ABBC760FC2
	for <kvmarm@archiver.kernel.org>; Tue,  3 Aug 2021 10:20:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org ABBC760FC2
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 209374086C;
	Tue,  3 Aug 2021 06:20:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id axIaeZ6zK7av; Tue,  3 Aug 2021 06:20:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 013B549E8A;
	Tue,  3 Aug 2021 06:20:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E0AA406AD
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Aug 2021 06:20:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vytaHRIbz4av for <kvmarm@lists.cs.columbia.edu>;
 Tue,  3 Aug 2021 06:20:05 -0400 (EDT)
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com
 [209.85.221.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 35B5E407E7
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Aug 2021 06:20:05 -0400 (EDT)
Received: by mail-wr1-f48.google.com with SMTP id c16so24703500wrp.13
 for <kvmarm@lists.cs.columbia.edu>; Tue, 03 Aug 2021 03:20:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=BH6VSubQLcCEeiXp46qRZOXRNaTnzvfumnh86E0J8aM=;
 b=NQYGJM/XzsrAJWy8BNxS7s5O7GkQgGVRYjx+8M/j9wHLNhSSVCVnmOw51NtulDRnRA
 YCrgVK54gw85K3GHJCd3kW0jmE48JlVl28VXS9mK9YrBDrotXYSyUcT+NhBO+eMx71sQ
 8KmrjMkyKg0DgnEJfodsW3C/yzAu4Y9E1ZOaW1AycJiMWXRAhJt2GqL22/BTK42XNN1m
 EfTqLZ5rwAO1wGEkJz4bWP/rrNEq64U+FN9ar5keUt3upGBQWHWvJ5K5Zph3vhV+fgQu
 grHCCISsAfzFD4PmL3Hhv8XvH+7cI0Sd117guye40xRgVwI2ospt3iM5xcn81EcjojHw
 VVcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=BH6VSubQLcCEeiXp46qRZOXRNaTnzvfumnh86E0J8aM=;
 b=K+DYwSpEMdZ9W/Ddhe2qtDA+JaHdIcWbPmWjqlRIuTxBbmEb2efB2qNsD167jPUNcL
 iJato72YI+cH770UuTLOLq0WDRvsgZmZ40iTWPZ0RkJYeSFO0IRiFEE71rW0Z+1xu1Mv
 ivGDijo+v4LI0QFJpSGIY7vPaN7h/sQxYS/vRpgdKUFJwtRMbYw9zckHHz29HEjhc5Yc
 zGbBNrDL2PENJI3PmknvY3dT7qrrGi6mZpQQi+vefWICbjNXFQR6wyRX6gW9V74p4C+W
 bMeRlnLDd3EBPK0in6by13yvXD7Fwjf2aZ4jOw2WbGpuSALw/r9+YT+zLg/YjnV/iO+C
 +gCA==
X-Gm-Message-State: AOAM533g4D7e5fip2z/dXrn3xXHIOuXDqEKnP3OTxTJ/5MughjH8cPtF
 6vSm26P9u5B54anQhbx8K8agdQ==
X-Google-Smtp-Source: ABdhPJz5+GPO3jAnmWN6At04JUGrSTja+UukYyBxLjRle00PwQsgFNeR9zO+8tsOnRxejD25t1bw1g==
X-Received: by 2002:a5d:6589:: with SMTP id q9mr22819763wru.284.1627986004001; 
 Tue, 03 Aug 2021 03:20:04 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:210:754:7d1b:7303:129a])
 by smtp.gmail.com with ESMTPSA id e3sm14173327wrw.51.2021.08.03.03.20.03
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 03 Aug 2021 03:20:03 -0700 (PDT)
Date: Tue, 3 Aug 2021 11:20:00 +0100
From: Quentin Perret <qperret@google.com>
To: Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH v3 13/21] KVM: arm64: Expose host stage-2 manipulation
 helpers
Message-ID: <YQkYUOaXx7+/EQP/@google.com>
References: <20210729132818.4091769-1-qperret@google.com>
 <20210729132818.4091769-14-qperret@google.com>
 <CA+EHjTxTaPc=bt_kyXf0TE85v5eyHnq0o3KQ3Pd6+kOwmm5oMw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CA+EHjTxTaPc=bt_kyXf0TE85v5eyHnq0o3KQ3Pd6+kOwmm5oMw@mail.gmail.com>
Cc: kernel-team@android.com, qwandor@google.com, maz@kernel.org,
 linux-kernel@vger.kernel.org, catalin.marinas@arm.com, will@kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On Monday 02 Aug 2021 at 13:13:20 (+0200), Fuad Tabba wrote:
> Hi Quentin,
> 
> On Thu, Jul 29, 2021 at 3:28 PM Quentin Perret <qperret@google.com> wrote:
> >
> > We will need to manipulate the host stage-2 page-table from outside
> > mem_protect.c soon. Introduce two functions allowing this, and make
> > them usable to users of mem_protect.h.
> >
> > Signed-off-by: Quentin Perret <qperret@google.com>
> > ---
> >  arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  2 ++
> >  arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 17 ++++++++++++++++-
> >  2 files changed, 18 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> > index ae355bfd8c01..47c2a0c51612 100644
> > --- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> > +++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> > @@ -49,6 +49,8 @@ extern struct host_kvm host_kvm;
> >  int __pkvm_prot_finalize(void);
> >  int __pkvm_mark_hyp(phys_addr_t start, phys_addr_t end);
> >
> > +int host_stage2_idmap_locked(u64 start, u64 end, enum kvm_pgtable_prot prot);
> > +int host_stage2_set_owner_locked(u64 start, u64 end, u8 owner_id);
> >  int kvm_host_prepare_stage2(void *pgt_pool_base);
> >  void handle_host_mem_abort(struct kvm_cpu_context *host_ctxt);
> >
> > diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > index 70c57d2c3024..a7f6134789e0 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > @@ -272,6 +272,21 @@ static int host_stage2_adjust_range(u64 addr, struct kvm_mem_range *range)
> >         return 0;
> >  }
> >
> > +int host_stage2_idmap_locked(u64 start, u64 end, enum kvm_pgtable_prot prot)
> > +{
> > +       hyp_assert_lock_held(&host_kvm.lock);
> > +
> > +       return host_stage2_try(__host_stage2_idmap, start, end, prot);
> > +}
> > +
> > +int host_stage2_set_owner_locked(u64 start, u64 end, u8 owner_id)
> > +{
> > +       hyp_assert_lock_held(&host_kvm.lock);
> > +
> > +       return host_stage2_try(kvm_pgtable_stage2_set_owner, &host_kvm.pgt,
> > +                              start, end - start, &host_s2_pool, owner_id);
> > +}
> 
> This is a potential issue elsewhere as well, but all functions in
> kvm_pgtable.h, including kvm_pgtable_stage2_set_owner, specify an
> address range via address and size. The two you have introduced here
> take a start and an end. I'm not sure if making these two consistent
> with the ones in kvm_pgtable.h would be good, or would just complicate
> things in other places.

Good point, and it looks like specifying these two with start-size
parameters would simplify the callers a tiny bit as well, so I'll fold
that in v4.

Thanks,
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
