Return-Path: <SRS0=ChHZ=IK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BB06C433DB
	for <kvmarm@archiver.kernel.org>; Fri, 12 Mar 2021 05:10:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DCC8164F76
	for <kvmarm@archiver.kernel.org>; Fri, 12 Mar 2021 05:10:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DCC8164F76
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 320974B41A;
	Fri, 12 Mar 2021 00:10:17 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Y0hBeAuTPTSh; Fri, 12 Mar 2021 00:10:16 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1FBD04B458;
	Fri, 12 Mar 2021 00:10:16 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8CB774B41A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Mar 2021 00:10:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id d6aSTy7Xaa47 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 12 Mar 2021 00:10:13 -0500 (EST)
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com
 [209.85.128.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 66B634B40B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Mar 2021 00:10:13 -0500 (EST)
Received: by mail-wm1-f45.google.com with SMTP id
 f22-20020a7bc8d60000b029010c024a1407so15031122wml.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Mar 2021 21:10:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=8rin+aXdpiE+90osiPBBCiB/kzC/wvTFDlufzLkieLY=;
 b=RLh9oG+E0NRrQf3D4jDx/361FM3yrK1EmWOIlmVfSLVlQ+cwHf8/nT+4l2Ked5A0jn
 rPXhwUvZI8dZFd+C9S0oLI35nPymHdflaDiaKvMxBRzS9+7b2Rc7Wc0TED6EGeaxElzU
 fuJDo6skHJcy8k+l0WkEvRYlNZW0yzvWkTmFTXZfa7dNNDtB8cfNhHFYqIJSFnKEaE7S
 eknHTHSYo9aefxdnodvlaAGCvIGEq+///KeqOBK3+/RP8HIQ/8X78lRz7lcrdQpdBw3Z
 UvcHOPEkT27Cpm0ySKV+1Z2QjbVJOd/YCDYoKUme+3IM6dUGRZir3YPt/iSDmXGquFSR
 6D2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=8rin+aXdpiE+90osiPBBCiB/kzC/wvTFDlufzLkieLY=;
 b=idaaC718GhIta8ZFf/YZAgDuN13hqjcph2wRGCFCreDtxVR7mWDt71M9gK/dprsMW6
 PUSJ8JmBnD74WNGvDuc4AenjPA8aPImeKW8hPe/OZVy2kWi9n4/dPJx8rQbCy4CFEYiP
 hKQqNJeiLaeCb+YCgPP5wP4HV5H3Cu8kIEB/JRtq0Lgzvwsu/bVb3T09sqTUiONGVp0c
 5AVQ+lMZD62o5A8nBKhAM0oqgX+DRs+k+x7axi0xmOY8Pro6xuq1ZFgzYMR5Q4SxMEPb
 YWEMy8O/AapxznHW8lgUDwO0Lb5SbLWI3fiP1kVBuGza62MyAQ6PTQdlO/6zIURlvpPX
 +Bdw==
X-Gm-Message-State: AOAM532jY2ZACSKmj2t2WOCv0K2PfIPSVoLFHKYe5pwpAnbz06Zbe6+D
 u5R3TvharU+rJD/Llvxwz9UK0w==
X-Google-Smtp-Source: ABdhPJyJGE0OAQ0hL9P4QLn56wDbAlpAsInbXKRuWm98JDjTcUCCOJER4MsvkY9zyWkTfWx2MDNxvw==
X-Received: by 2002:a1c:a985:: with SMTP id
 s127mr10952353wme.158.1615525812255; 
 Thu, 11 Mar 2021 21:10:12 -0800 (PST)
Received: from google.com (230.69.233.35.bc.googleusercontent.com.
 [35.233.69.230])
 by smtp.gmail.com with ESMTPSA id d85sm871075wmd.15.2021.03.11.21.10.11
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 11 Mar 2021 21:10:11 -0800 (PST)
Date: Fri, 12 Mar 2021 05:10:09 +0000
From: Quentin Perret <qperret@google.com>
To: Will Deacon <will@kernel.org>
Subject: Re: [PATCH v4 29/34] KVM: arm64: Refactor stage2_map_set_prot_attr()
Message-ID: <YEr3sa0U2NnXqGUP@google.com>
References: <20210310175751.3320106-1-qperret@google.com>
 <20210310175751.3320106-30-qperret@google.com>
 <20210311184836.GA31586@willie-the-truck>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210311184836.GA31586@willie-the-truck>
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

On Thursday 11 Mar 2021 at 18:48:36 (+0000), Will Deacon wrote:
> On Wed, Mar 10, 2021 at 05:57:46PM +0000, Quentin Perret wrote:
> > In order to ease its re-use in other code paths, refactor
> > stage2_map_set_prot_attr() to not depend on a stage2_map_data struct.
> > No functional change intended.
> > 
> > Signed-off-by: Quentin Perret <qperret@google.com>
> > ---
> >  arch/arm64/kvm/hyp/pgtable.c | 8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> > 
> > diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> > index e4670b639726..c16e0306dd9a 100644
> > --- a/arch/arm64/kvm/hyp/pgtable.c
> > +++ b/arch/arm64/kvm/hyp/pgtable.c
> > @@ -489,8 +489,7 @@ u64 kvm_get_vtcr(u64 mmfr0, u64 mmfr1, u32 phys_shift)
> >  	return vtcr;
> >  }
> >  
> > -static int stage2_map_set_prot_attr(enum kvm_pgtable_prot prot,
> > -				    struct stage2_map_data *data)
> > +static int stage2_set_prot_attr(enum kvm_pgtable_prot prot, kvm_pte_t *ptep)
> >  {
> >  	bool device = prot & KVM_PGTABLE_PROT_DEVICE;
> >  	kvm_pte_t attr = device ? PAGE_S2_MEMATTR(DEVICE_nGnRE) :
> > @@ -510,7 +509,8 @@ static int stage2_map_set_prot_attr(enum kvm_pgtable_prot prot,
> >  
> >  	attr |= FIELD_PREP(KVM_PTE_LEAF_ATTR_LO_S2_SH, sh);
> >  	attr |= KVM_PTE_LEAF_ATTR_LO_S2_AF;
> > -	data->attr = attr;
> > +	*ptep = attr;
> > +
> >  	return 0;
> >  }
> >  
> > @@ -728,7 +728,7 @@ int kvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
> >  		.arg		= &map_data,
> >  	};
> >  
> > -	ret = stage2_map_set_prot_attr(prot, &map_data);
> > +	ret = stage2_set_prot_attr(prot, &map_data.attr);
> >  	if (ret)
> >  		return ret;
> 
> (nit: this is now different to hyp_map_set_prot_attr() -- can we do the same
> thing there, please?)

Will do.

Thanks,
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
