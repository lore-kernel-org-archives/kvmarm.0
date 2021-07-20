Return-Path: <SRS0=KNUW=MM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FSL_HELO_FAKE,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 174FFC07E9B
	for <kvmarm@archiver.kernel.org>; Tue, 20 Jul 2021 10:38:27 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 848626113C
	for <kvmarm@archiver.kernel.org>; Tue, 20 Jul 2021 10:38:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 848626113C
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 126F64B08E;
	Tue, 20 Jul 2021 06:38:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4gG+uAnDT1QL; Tue, 20 Jul 2021 06:38:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 113304B090;
	Tue, 20 Jul 2021 06:38:25 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9E68E4B087
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Jul 2021 06:38:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aknMQCwumC2k for <kvmarm@lists.cs.columbia.edu>;
 Tue, 20 Jul 2021 06:38:22 -0400 (EDT)
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com
 [209.85.221.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8E87D4A5A0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Jul 2021 06:38:22 -0400 (EDT)
Received: by mail-wr1-f52.google.com with SMTP id f17so25467054wrt.6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Jul 2021 03:38:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=S2sNXLvJ4dwORJ7M5/nfuYVqqM+rERqyTBGgtikYXaE=;
 b=mPoeiN3M2AOmzdQgoZ+DsS2PhTUq2lw5i1UCT1ddfJG9kUVbabmUf6v6T/MJAnkcik
 Ud4mVQ2cHb5Bg2HqtZvCddGuPnOeb8RhDgH3SzMzXKHj4uvX2jEN8Bw0VcGbglQe2Dsq
 vouf/5a7Mc3Pn/bkqJbHrfvkh70Dq9nxzGQBXEDXMaQzIFsYiHlqx2FuNizQXtVY7UNp
 Kv41e6ik1XPLx4m6TiqW4Ngp46rhtMgmWDFnv+zX1TtY4Da+Ls+n3zuQMIb5C0HXeGY9
 c0JEnJGW7vgmMokunPk94EwP213E7vP7VRB1R/sKUjGSVeoOAqC0hBSVX+t0qmsR8XOf
 aT4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=S2sNXLvJ4dwORJ7M5/nfuYVqqM+rERqyTBGgtikYXaE=;
 b=m54NCaCDbW10GOTZU50mDnLZfIBMoAL7pPgiZi8rtucPm/nAFrG9uzURZlDuDEWWBE
 VXTQdF4fQAMrH5P7HaFgpggAGnJBY/UHGoY9wo1pN/5cyrjrjmcvgNrjxEaW2MAsNk2l
 pD1ntWr3ygfk4D0DAXyLpcvTEq+Ea1JcSRQ8KwFgCc9P5NW7E3MAWTM9M0Mz2Lpmjwto
 9/D+NIRh6X+ZsQcm7jGh8OCsR6vI0VTRlyVxcqy25LoxCec+Rw3Wgf63wIiK/9zu17sc
 4Z7OIVMnkCPgFMBXgp4o7Ixd4xdrpZagkqZMQ5nSkPjcRpH9JHXi9PtXzqrwTrz9is/w
 B4bw==
X-Gm-Message-State: AOAM530odUA2hmpmoHOE4dzS0U33Btm0tQ8up9ujddxQUQ/rceT3+1A4
 ooQVKjRGRmSG5xP/pnDZeFNF5g==
X-Google-Smtp-Source: ABdhPJy7g7Xq2cQ/7zmh8X/o4J7TfkA9+eUT4oUX5FYEN6LxPQ9LUW/2mD3SHGS2l5+cFKz+ca5WyA==
X-Received: by 2002:a5d:6992:: with SMTP id g18mr35879296wru.118.1626777501471; 
 Tue, 20 Jul 2021 03:38:21 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:210:83e0:11ac:c870:2b97])
 by smtp.gmail.com with ESMTPSA id a10sm22857100wrm.12.2021.07.20.03.38.20
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 20 Jul 2021 03:38:20 -0700 (PDT)
Date: Tue, 20 Jul 2021 11:38:17 +0100
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 03/16] KVM: arm64: Turn kvm_pgtable_stage2_set_owner into
 kvm_pgtable_stage2_annotate
Message-ID: <YPanmXfdr9rqnICK@google.com>
References: <20210715163159.1480168-1-maz@kernel.org>
 <20210715163159.1480168-4-maz@kernel.org>
 <YPag0YQHB0nph5ji@google.com> <871r7t9tgi.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <871r7t9tgi.wl-maz@kernel.org>
Cc: kernel-team@android.com, kvm@vger.kernel.org,
 Srivatsa Vaddagiri <vatsa@codeaurora.org>, linux-kernel@vger.kernel.org,
 Shanker R Donthineni <sdonthineni@nvidia.com>, will@kernel.org,
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

On Tuesday 20 Jul 2021 at 11:21:17 (+0100), Marc Zyngier wrote:
> On Tue, 20 Jul 2021 11:09:21 +0100,
> Quentin Perret <qperret@google.com> wrote:
> > 
> > On Thursday 15 Jul 2021 at 17:31:46 (+0100), Marc Zyngier wrote:
> > > @@ -815,7 +807,7 @@ int kvm_pgtable_stage2_set_owner(struct kvm_pgtable *pgt, u64 addr, u64 size,
> > >  		.arg		= &map_data,
> > >  	};
> > >  
> > > -	if (owner_id > KVM_MAX_OWNER_ID)
> > > +	if (!annotation || (annotation & PTE_VALID))
> > >  		return -EINVAL;
> > 
> > Why do you consider annotation==0 invalid? The assumption so far has
> > been that the owner_id for the host is 0, so annotating a range with 0s
> > should be a valid operation -- this will be required when e.g.
> > transferring ownership of a page back to the host.
> 
> How do you then distinguish it from an empty entry that doesn't map to
> anything at all?

You don't, but that's beauty of it :)

The host starts with a PGD full of zeroes, which in terms of ownership
means that it owns the entire (I)PA space. And it loses ownership of a
page only when we explicitly annotate it with an owner id != 0.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
