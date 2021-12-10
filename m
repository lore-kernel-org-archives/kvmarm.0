Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BFDFC433F5
	for <kvmarm@archiver.kernel.org>; Fri, 10 Dec 2021 14:49:02 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1E69A4B1D1;
	Fri, 10 Dec 2021 09:49:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Ufj1H33wR1UP; Fri, 10 Dec 2021 09:49:01 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F18AF4B1E2;
	Fri, 10 Dec 2021 09:49:00 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 76D284B1D1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Dec 2021 09:48:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id H+a2bb97KWHT for <kvmarm@lists.cs.columbia.edu>;
 Fri, 10 Dec 2021 09:48:58 -0500 (EST)
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com
 [209.85.221.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 104BE4B1C1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Dec 2021 09:48:58 -0500 (EST)
Received: by mail-wr1-f53.google.com with SMTP id t18so15287636wrg.11
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Dec 2021 06:48:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=XSGjwIt9RpPIjkr6liBZIwGzdNBMMcqErsUs7NKqs3g=;
 b=eFa+/5A+zfMKqzOSVMBePCnsVCvDiruKqK0HXpczVW9xdUh2bI5XBpZykeV00eoyn0
 Ps0U7SIG3EJbM2kI0skWEcTnH6lkua7grTJTjDqX4T8jIuSkNqfqNddprnKjZOHHCBOr
 lAxx8avwGZkdKqJIhrNTAB+UHYQ2NTf1l05If80e5qPJhuhh8x/UU89YQ2EJiE8cor6K
 O1TOpAxYAh0Omdk6QzNXX51mJBiVH5OGAK5U+h85oIkduoyeNxLMk7CK7/LlxQAb6DOz
 9IZqTT8YSfKXYrk4aMHLmYOXa1wCvpRvUVnfICn8/QIi6iSE6JjmwvPvYentz7mJzyTz
 084g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=XSGjwIt9RpPIjkr6liBZIwGzdNBMMcqErsUs7NKqs3g=;
 b=SgdWIy+glwF71brWO1zwy2FLanVarmsFWkCNozOZZq2mFlQsJJSgaAVI9gO7pjkuxF
 LjV8BHzfUk32BDpCRiBTSEkm+ozOoGgMYCFSmOdSxIzmUPVnltDRO2KgyDoJIsAoa2TF
 qBB5F0eegKO6sLwRA8VWQnno3nLzFMq5YWcTkAmKXXwCN5O3/CfQKREB81sRtdQXq5/q
 anB23AjCOZobDVFfPJPDxpVJHfNbknoMeEFdK7bN8Tvyvm8nGLR66dU4gyzSL7LdNcPx
 X8uya7iZgYMallN6jjL8GWl1vdrs+cjb6BsimMnxIOKVCW9IzbY8AICaqiW6q6TOBY7j
 ew/g==
X-Gm-Message-State: AOAM532eeeaMjqqWHyXBTbV3v51zjHdtiHIoBSv8fFDLHYWJKkV/nXks
 Fnsj2iflwqa6FCyOgoXPfKcjPg==
X-Google-Smtp-Source: ABdhPJwvEUvtytgXDIUTqN1i7hPX5BX/gnJ9OxL+n5KP+mAtXq7F0bdSrTa2ut2djOds2sajpum1GA==
X-Received: by 2002:adf:a412:: with SMTP id d18mr14714578wra.529.1639147736805; 
 Fri, 10 Dec 2021 06:48:56 -0800 (PST)
Received: from google.com ([2a00:79e0:d:210:76c1:fb36:1e22:8677])
 by smtp.gmail.com with ESMTPSA id c4sm2669899wrr.37.2021.12.10.06.48.56
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 10 Dec 2021 06:48:56 -0800 (PST)
Date: Fri, 10 Dec 2021 14:48:53 +0000
From: Quentin Perret <qperret@google.com>
To: Will Deacon <will@kernel.org>
Subject: Re: [PATCH v3 15/15] KVM: arm64: pkvm: Unshare guest structs during
 teardown
Message-ID: <YbNo1SBn7ZNf89qL@google.com>
References: <20211201170411.1561936-1-qperret@google.com>
 <20211201170411.1561936-16-qperret@google.com>
 <20211209112233.GD1912@willie-the-truck>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20211209112233.GD1912@willie-the-truck>
Cc: kernel-team@android.com, Marc Zyngier <maz@kernel.org>,
 linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
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

On Thursday 09 Dec 2021 at 11:22:33 (+0000), Will Deacon wrote:
> On Wed, Dec 01, 2021 at 05:04:09PM +0000, Quentin Perret wrote:
> > Make use of the newly introduced unshare hypercall during guest teardown
> > to unmap guest-related data structures from the hyp stage-1.
> > 
> > Signed-off-by: Quentin Perret <qperret@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_host.h |  2 ++
> >  arch/arm64/include/asm/kvm_mmu.h  |  1 +
> >  arch/arm64/kvm/arm.c              |  2 ++
> >  arch/arm64/kvm/fpsimd.c           | 34 ++++++++++++++++++++++---
> >  arch/arm64/kvm/mmu.c              | 42 +++++++++++++++++++++++++++++++
> >  arch/arm64/kvm/reset.c            |  8 +++++-
> >  6 files changed, 85 insertions(+), 4 deletions(-)
> 
> [...]
> 
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index d72566896755..8e506ba8988e 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -344,6 +344,32 @@ static int share_pfn_hyp(u64 pfn)
> >  	return ret;
> >  }
> >  
> > +static int unshare_pfn_hyp(u64 pfn)
> > +{
> > +	struct rb_node **node, *parent;
> > +	struct hyp_shared_pfn *this;
> > +	int ret = 0;
> > +
> > +	mutex_lock(&hyp_shared_pfns_lock);
> > +	this = find_shared_pfn(pfn, &node, &parent);
> > +	if (WARN_ON(!this)) {
> > +		ret = -EINVAL;
> 
> -ENOENT?

Sure.

> > +		goto unlock;
> > +	}
> > +
> > +	this->count--;
> > +	if (this->count)
> > +		goto unlock;
> 
> Again, if we did an RCU lookup then this could be converted to a refcount_t
> to take the mutex only when it hits zero. But for now I think it's fine.

No objection to do this in the future, but yeah I think we might as well
start simple :)

> > +
> > +	rb_erase(&this->node, &hyp_shared_pfns);
> > +	kfree(this);
> > +	ret = kvm_call_hyp_nvhe(__pkvm_host_unshare_hyp, pfn, 1);
> > +unlock:
> > +	mutex_unlock(&hyp_shared_pfns_lock);
> > +
> > +	return ret;
> > +}
> > +
> >  int kvm_share_hyp(void *from, void *to)
> >  {
> >  	phys_addr_t start, end, cur;
> > @@ -376,6 +402,22 @@ int kvm_share_hyp(void *from, void *to)
> >  	return 0;
> >  }
> >  
> > +void kvm_unshare_hyp(void *from, void *to)
> > +{
> > +	phys_addr_t start, end, cur;
> > +	u64 pfn;
> > +
> > +	if (is_kernel_in_hyp_mode() || kvm_host_owns_hyp_mappings() || !from)
> 
> I don't think you need the is_kernel_in_hyp_mode() check any more not that
> you've moved that into kvm_host_owns_hyp_mappings().

The logic is a little odd, but I think I still do as
kvm_host_owns_hyp_mappings() will return false if is_kernel_in_hyp_mode()
is true.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
