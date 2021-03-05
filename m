Return-Path: <SRS0=QgbO=ID=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D962C433E9
	for <kvmarm@archiver.kernel.org>; Fri,  5 Mar 2021 09:19:05 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C5AE164F73
	for <kvmarm@archiver.kernel.org>; Fri,  5 Mar 2021 09:19:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C5AE164F73
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 20AF54B2F4;
	Fri,  5 Mar 2021 04:19:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BBNHEztsDaH8; Fri,  5 Mar 2021 04:19:03 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 319724B26E;
	Fri,  5 Mar 2021 04:19:03 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8AAC04B216
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Mar 2021 04:19:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VS0u9HQpHN17 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  5 Mar 2021 04:19:00 -0500 (EST)
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com
 [209.85.128.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 835374B213
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Mar 2021 04:19:00 -0500 (EST)
Received: by mail-wm1-f42.google.com with SMTP id
 n11-20020a05600c4f8bb029010e5cf86347so433501wmq.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 05 Mar 2021 01:19:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=8vJPV4FFwyt82QjbLhQn3+aWfcjT4u1dwj3bRwwYUZg=;
 b=nCBqUkSK4KKfw+b3O4dSAu30OZObhhK/hc1tmfr0QT3OO6SNikoNtfNIf4ImrZaBuw
 fOGpB6D3w5mu1Gp2MxOq3MgCDDGuwJ4sCyCvPaqVq0/Mr95qRW6kzhjE4JV2Ve+f0v5J
 R1yoy9l/FhsBx2wCqKFePLGMw8c82/N2GMro9PFvhk/1uLsiyorZZspXPxcK9ddNXO62
 XvuFtQ3byMIjjlpM7qT2JSuOPoxkzi+/bZQWjzWi3ks52l9wPzTV9ZqEliqraKdqbR14
 35v+2X0/aVQyqEfV5/UlTH2rUQpz7AL4/vw4r4DdG8ugNfROUrkY2vGE3LsGATptCuz7
 77Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=8vJPV4FFwyt82QjbLhQn3+aWfcjT4u1dwj3bRwwYUZg=;
 b=CejiACGw64d+GkuNJZgxUW8pRG9fpCqi46c17/Ue3iMQi6E1oUrW2wyCATY9NLenKG
 +WCbEYre9+qc/1qKflJuTI4QJt8DefHsIhQ9gI5MIyXpIbGYBMBQEzYclVyIyJ4IjV69
 VJQ2NHwu3kC6XuXfBZF1Wmr0SqA1vrOI07c5VwCv9AJkvffJBQmRTHc5FiHYlLn9DwnN
 B+hxMYrzxxPVpSX0fnOKk/jTIxrUYF+ASrf7FWcH3ojguCmKCaU3YTcavMX2xiL+48UT
 53hQnXTikcSfHyRd4b7Emdf6PJjJC0AdQe3qybt6j5Rf8jtMc3NRafFXwSVSZqMtKQEB
 lRgA==
X-Gm-Message-State: AOAM530BeQX2EFtzkjiP+kn4tRiDnn6dJmO9+X33vCMlv7w0AeDnPZzd
 O8S7z7wOpAMiIRQxDN12Zx9VaQ==
X-Google-Smtp-Source: ABdhPJwrDZdyUEX/CX8cn+VF0ajEbirzA9wYgQWCTVvm8e666ZxT2NbDPANZG6FBAnU7u4fM8Tdvcw==
X-Received: by 2002:a1c:2155:: with SMTP id h82mr8014110wmh.169.1614935939487; 
 Fri, 05 Mar 2021 01:18:59 -0800 (PST)
Received: from google.com (230.69.233.35.bc.googleusercontent.com.
 [35.233.69.230])
 by smtp.gmail.com with ESMTPSA id k11sm3545806wmj.1.2021.03.05.01.18.59
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 05 Mar 2021 01:18:59 -0800 (PST)
Date: Fri, 5 Mar 2021 09:18:56 +0000
From: Quentin Perret <qperret@google.com>
To: Will Deacon <will@kernel.org>
Subject: Re: [PATCH v3 27/32] KVM: arm64: Refactor stage2_map_set_prot_attr()
Message-ID: <YEH3gKYY/Rz7W+50@google.com>
References: <20210302150002.3685113-1-qperret@google.com>
 <20210302150002.3685113-28-qperret@google.com>
 <20210304200335.GG21950@willie-the-truck>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210304200335.GG21950@willie-the-truck>
Cc: android-kvm@google.com, catalin.marinas@arm.com, mate.toth-pal@arm.com,
 seanjc@google.com, tabba@google.com, linux-kernel@vger.kernel.org,
 robh+dt@kernel.org, linux-arm-kernel@lists.infradead.org, maz@kernel.org,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu
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

On Thursday 04 Mar 2021 at 20:03:36 (+0000), Will Deacon wrote:
> On Tue, Mar 02, 2021 at 02:59:57PM +0000, Quentin Perret wrote:
> > In order to ease its re-use in other code paths, refactor
> > stage2_map_set_prot_attr() to not depend on a stage2_map_data struct.
> > No functional change intended.
> > 
> > Signed-off-by: Quentin Perret <qperret@google.com>
> > ---
> >  arch/arm64/kvm/hyp/pgtable.c | 19 ++++++++-----------
> >  1 file changed, 8 insertions(+), 11 deletions(-)
> > 
> > diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> > index 8e7059fcfd40..8aa01a9e2603 100644
> > --- a/arch/arm64/kvm/hyp/pgtable.c
> > +++ b/arch/arm64/kvm/hyp/pgtable.c
> > @@ -494,8 +494,7 @@ u64 kvm_get_vtcr(u64 mmfr0, u64 mmfr1, u32 phys_shift)
> >  	return vtcr;
> >  }
> >  
> > -static int stage2_map_set_prot_attr(enum kvm_pgtable_prot prot,
> > -				    struct stage2_map_data *data)
> > +static kvm_pte_t stage2_get_prot_attr(enum kvm_pgtable_prot prot)
> >  {
> >  	bool device = prot & KVM_PGTABLE_PROT_DEVICE;
> >  	kvm_pte_t attr = device ? PAGE_S2_MEMATTR(DEVICE_nGnRE) :
> > @@ -504,15 +503,15 @@ static int stage2_map_set_prot_attr(enum kvm_pgtable_prot prot,
> >  
> >  	if (prot & KVM_PGTABLE_PROT_NONE) {
> >  		if (prot != KVM_PGTABLE_PROT_NONE)
> > -			return -EINVAL;
> > +			return 0;
> 
> Hmm, does the architecture actually say that having all these attributes
> as 0 is illegal?

Hmm, that's a good point, that might not be the case. I assumed we would
have no use for this, but there we can easily avoid the restriction
so...

> If not, I think it would be better to keep the int return
> code and replace the 'data' parameter with a pointer to a kvm_pte_t.
> 
> Does that work?

I think so yes, I'll fix it up.

Cheers,
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
