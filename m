Return-Path: <SRS0=ioR1=HG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE83CC433E0
	for <kvmarm@archiver.kernel.org>; Thu,  4 Feb 2021 14:26:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 48BCE64F3C
	for <kvmarm@archiver.kernel.org>; Thu,  4 Feb 2021 14:26:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 48BCE64F3C
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C0E914B253;
	Thu,  4 Feb 2021 09:26:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BUXxmFTN-C2j; Thu,  4 Feb 2021 09:26:41 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B48224B1D4;
	Thu,  4 Feb 2021 09:26:41 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9E4554B0F7
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Feb 2021 09:26:40 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mRhmvPb9DZAw for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Feb 2021 09:26:39 -0500 (EST)
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com
 [209.85.128.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 81AE34B0D8
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Feb 2021 09:26:39 -0500 (EST)
Received: by mail-wm1-f52.google.com with SMTP id l12so3300942wmq.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 04 Feb 2021 06:26:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=WHxuqsEXEN4au8FdhV49UEllGtCSQh/DCdcron9InCc=;
 b=Pg47DSWBlJxWDTyOy0uhMGzKVxdYFLXQWQS0K5+zxLWQojmzL5h6ffmzz8z8JphFg+
 GGQnNvn4zYaBYDPyC6oVULe1wxqtXA5XmivtJVmAw1gi3hAHI9cxbYJ8QeLjDxBqhN2z
 sfjDy3JiEEXoc6s37Q0mTdakrkoM5BHiSvuWBi3o11isnRp8muh/HasfGTLX1h7INMPE
 eu5FT15vPLlyQyL95luBYGKr7scOfYg8dDnnK/YcunKE0eaIWI/fCuGuv0YDlc808WV5
 I+uMW4rSIiz6w0P13aivINkdIWrIx32dUc9bZPEOpmtG5xjHFd+ejnKzad1gnP1Q9wvP
 8ztg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=WHxuqsEXEN4au8FdhV49UEllGtCSQh/DCdcron9InCc=;
 b=tKvD0e+fzuSFazp3PMgXW0N0Seru2CyYPwI0j34SgxENPOk6Fm3lRZQjbg4PPGNa+r
 qCwt5iK6gxuwIV7//jK9FB/NTvRURaDGw0xT21RlMR/1cTTnv5NmAuuEOpuRVfDFBp7e
 LMRukdUAPJXnx0aVAXX3LURow8w6t2/xneR91gIYhazsDQJXYR1U6r4yzIESftwkIONh
 Newvuz8gARygAuRUx0VUXtUuaXjdvnYrKvI1fF/uAjAxlwfgbHpT290wunrDM9HqR0S/
 MZA0JBooF4i2ntzPptqQoYePABFx0g/z73BirvtK6n7+ZZtzooUTtHU2PKxz4goDeQV2
 he2A==
X-Gm-Message-State: AOAM530P0FeYgF7uN1B/7ziENLuwq8Ewt2ovfbao2K4qRMbx+qFmDtYf
 5hbO4RjqCTrroGtdtdFJR/i5WA==
X-Google-Smtp-Source: ABdhPJz8JyfdFBQ/Eq1UMUYtaCSGJYG+KqzKASSPlnHSKDldVsKHnk3I1lXTriVT3KNvdGryo6FBXw==
X-Received: by 2002:a05:600c:4f13:: with SMTP id
 l19mr7619926wmq.70.1612448798327; 
 Thu, 04 Feb 2021 06:26:38 -0800 (PST)
Received: from google.com (230.69.233.35.bc.googleusercontent.com.
 [35.233.69.230])
 by smtp.gmail.com with ESMTPSA id u3sm9286516wre.54.2021.02.04.06.26.37
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 04 Feb 2021 06:26:37 -0800 (PST)
Date: Thu, 4 Feb 2021 14:26:35 +0000
From: Quentin Perret <qperret@google.com>
To: Will Deacon <will@kernel.org>
Subject: Re: [RFC PATCH v2 26/26] KVM: arm64: Wrap the host with a stage 2
Message-ID: <YBwEGx1tv8hob9ho@google.com>
References: <20210108121524.656872-1-qperret@google.com>
 <20210108121524.656872-27-qperret@google.com>
 <20210203161146.GJ18974@willie-the-truck>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210203161146.GJ18974@willie-the-truck>
Cc: devicetree@vger.kernel.org, kernel-team@android.com, android-kvm@google.com,
 Catalin Marinas <catalin.marinas@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
 linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
 Frank Rowand <frowand.list@gmail.com>, kvmarm@lists.cs.columbia.edu
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

On Wednesday 03 Feb 2021 at 16:11:47 (+0000), Will Deacon wrote:
> On Fri, Jan 08, 2021 at 12:15:24PM +0000, Quentin Perret wrote:
> > When KVM runs in protected nVHE mode, make use of a stage 2 page-table
> > to give the hypervisor some control over the host memory accesses. At
> > the moment all memory aborts from the host will be instantly idmapped
> > RWX at stage 2 in a lazy fashion. Later patches will make use of that
> > infrastructure to implement access control restrictions to e.g. protect
> > guest memory from the host.
> > 
> > Signed-off-by: Quentin Perret <qperret@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_cpufeature.h       |   2 +
> >  arch/arm64/kernel/image-vars.h                |   3 +
> >  arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  33 +++
> >  arch/arm64/kvm/hyp/nvhe/Makefile              |   2 +-
> >  arch/arm64/kvm/hyp/nvhe/hyp-init.S            |   1 +
> >  arch/arm64/kvm/hyp/nvhe/hyp-main.c            |   6 +
> >  arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 191 ++++++++++++++++++
> >  arch/arm64/kvm/hyp/nvhe/setup.c               |   6 +
> >  arch/arm64/kvm/hyp/nvhe/switch.c              |   7 +-
> >  arch/arm64/kvm/hyp/nvhe/tlb.c                 |   4 +-
> >  10 files changed, 248 insertions(+), 7 deletions(-)
> >  create mode 100644 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> >  create mode 100644 arch/arm64/kvm/hyp/nvhe/mem_protect.c
> 
> [...]
> 
> > +void handle_host_mem_abort(struct kvm_cpu_context *host_ctxt)
> > +{
> > +	enum kvm_pgtable_prot prot;
> > +	u64 far, hpfar, esr, ipa;
> > +	int ret;
> > +
> > +	esr = read_sysreg_el2(SYS_ESR);
> > +	if (!__get_fault_info(esr, &far, &hpfar))
> > +		hyp_panic();
> > +
> > +	prot = KVM_PGTABLE_PROT_R | KVM_PGTABLE_PROT_W | KVM_PGTABLE_PROT_X;
> > +	ipa = (hpfar & HPFAR_MASK) << 8;
> > +	ret = host_stage2_map(ipa, PAGE_SIZE, prot);
> 
> Can we try to put down a block mapping if the whole thing falls within
> memory?

Yes we can! And in fact we can do that outside of memory too. It's
queued for v3 already, so stay tuned ... :)

Thanks,
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
