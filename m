Return-Path: <SRS0=w8eh=K3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3433DC4708F
	for <kvmarm@archiver.kernel.org>; Tue,  1 Jun 2021 15:48:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A379F6136E
	for <kvmarm@archiver.kernel.org>; Tue,  1 Jun 2021 15:48:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A379F6136E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1B4C14B0C4;
	Tue,  1 Jun 2021 11:48:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YQOxEHzw8+xz; Tue,  1 Jun 2021 11:48:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F36124A32E;
	Tue,  1 Jun 2021 11:48:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D13E649E5F
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Jun 2021 11:48:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WpOXdxhf14DN for <kvmarm@lists.cs.columbia.edu>;
 Tue,  1 Jun 2021 11:48:10 -0400 (EDT)
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com
 [209.85.221.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BFD0D40895
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Jun 2021 11:48:10 -0400 (EDT)
Received: by mail-wr1-f46.google.com with SMTP id q5so14863896wrs.4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 01 Jun 2021 08:48:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=wEwX9WZesArWKsstP4MgeMs+pB7+trRKG9aUiLAejfI=;
 b=j7funsS3lgOohm05QYVU+t8GGWwgu0Wf20fsocDj/LBWHAlMAMRLryyp9qyZQdrJzs
 19JU1dDbayAu7X9IC/gXiuse+1XBdQMfra6E8X8im1Yf2OuhFVB2afWXKUoinPmFOOsT
 WPj3A3VI2jJ9+9fQQNj9JN6DPMCpDDlgMtYnZFDqsVHiJGEBq/t0E30gB5368QBOEng3
 t09QPgcYsVUjhowSdXx8Ng0XLom4WcaVit5zzpCJYbZ9aVUisMW4KnUnndLFhcGfPzsj
 4BhVindCVW1K6mhnWo+HBMMbmTXdM22cbOPjRiJqXlAQK73xamnHyuk/u/yMHQtVVMUS
 IC+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=wEwX9WZesArWKsstP4MgeMs+pB7+trRKG9aUiLAejfI=;
 b=GYa8LvZp/FNdoWorYj7jf6fUUdlM49RzitsDTUlY+hTnFtDK7yHZiK9bK0/pPfflpW
 CKHZgA8EXjLCnnatO1cWM9GOvkhqe35gvF6xjystginZEV76nNTMPQiToBccEH4B3YGL
 THtIRM0IOIp8wfDGqrAr/GcuCUcOlw89g5VLICxkoFgi/zIstdw70RJKvhVpfSbSyWQv
 80jFzkowylv64nkY3yGIClOiwkG1Pelm2MLhl3YapYGAkBAT7Jpr5u3RsJKFsOnjdJ1h
 eSCZICOSFgF0aK8FeuNV5QlJh/WKWlfv+OPJypqQ8W6VLHUGhdVTrSLSCaTdUE6FkOmA
 xV5A==
X-Gm-Message-State: AOAM533ZryCWUnOnnjVJUkhkOvmo2pC1LSS0QVWiX9sSlGzEW2PDJ3X3
 +ciN/2bZxcTe4MNHOlNfQrtOTQ==
X-Google-Smtp-Source: ABdhPJypLSgdyQrzYGtYN1BysUUWmR3te0VbHpPr02pGuGIYnfWllUWNT85DgCvXAJ1Jr1mor+fMhQ==
X-Received: by 2002:a5d:50c1:: with SMTP id f1mr29105131wrt.168.1622562489528; 
 Tue, 01 Jun 2021 08:48:09 -0700 (PDT)
Received: from google.com (105.168.195.35.bc.googleusercontent.com.
 [35.195.168.105])
 by smtp.gmail.com with ESMTPSA id b15sm3342934wru.64.2021.06.01.08.48.08
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 01 Jun 2021 08:48:08 -0700 (PDT)
Date: Tue, 1 Jun 2021 15:48:06 +0000
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 3/7] KVM: arm64: Remove list_head from hyp_page
Message-ID: <YLZWtnGVQSguI1P6@google.com>
References: <20210527125134.2116404-1-qperret@google.com>
 <20210527125134.2116404-4-qperret@google.com>
 <87k0nd1wgx.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87k0nd1wgx.wl-maz@kernel.org>
Cc: kernel-team@android.com, catalin.marinas@arm.com,
 linux-kernel@vger.kernel.org, will@kernel.org, kvmarm@lists.cs.columbia.edu,
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

On Tuesday 01 Jun 2021 at 15:38:22 (+0100), Marc Zyngier wrote:
> On Thu, 27 May 2021 13:51:30 +0100,
> Quentin Perret <qperret@google.com> wrote:
> > +/*
> > + * Pages that are available for allocation are tracked in free-lists, so we use
> > + * the pages themselves to store the list nodes to avoid wasting space. As the
> > + * allocator always returns zeroed pages (which are zeroed on the hyp_put_page()
> > + * path to optimize allocation speed), we also need to clean-up the list node in
> > + * each page when we take it out of the list.
> > + */
> > +static inline void page_remove_from_list(struct hyp_page *p)
> > +{
> > +	struct list_head *node = (struct list_head *)hyp_page_to_virt(p);
> 
> Nit: How about changing hyp_page_to_virt() so that it returns a
> convenient 'void *', and get rid of the ugly casts?

It should already return void *, but I kind of liked the explicit cast
here for documentation purpose. We're turning a 'random' piece of unused
memory into a typed object, so that felt like a useful annotation. Happy
to get rid of it though.

> > +
> > +	__list_del_entry(node);
> > +	memset(node, 0, sizeof(*node));
> > +}
> > +
> > +static inline void page_add_to_list(struct hyp_page *p, struct list_head *head)
> > +{
> > +	struct list_head *node = (struct list_head *)hyp_page_to_virt(p);
> > +
> > +	INIT_LIST_HEAD(node);
> > +	list_add_tail(node, head);
> > +}
> > +
> > +static inline struct hyp_page *node_to_page(struct list_head *node)
> > +{
> > +	return (struct hyp_page *)hyp_virt_to_page(node);
> 
> Why is this cast necessary? If I'm not mistaken, hyp_vmemmap is
> already cast as a 'struct hyp_page *', so hyp_virt_to_page() should
> return the same type.

Right, that one is totally unnecessary, I'll remove.

Cheers,
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
