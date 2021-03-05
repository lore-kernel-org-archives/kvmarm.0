Return-Path: <SRS0=QgbO=ID=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42CE9C433E0
	for <kvmarm@archiver.kernel.org>; Fri,  5 Mar 2021 09:17:25 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7F12164F53
	for <kvmarm@archiver.kernel.org>; Fri,  5 Mar 2021 09:17:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7F12164F53
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E6B314B3D2;
	Fri,  5 Mar 2021 04:17:23 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9UJGICesz7QZ; Fri,  5 Mar 2021 04:17:22 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CF1764B3FA;
	Fri,  5 Mar 2021 04:17:22 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D95084B3FA
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Mar 2021 04:17:21 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dQjiuQsJ8k3h for <kvmarm@lists.cs.columbia.edu>;
 Fri,  5 Mar 2021 04:17:20 -0500 (EST)
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com
 [209.85.221.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A9CB84B3D2
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Mar 2021 04:17:20 -0500 (EST)
Received: by mail-wr1-f44.google.com with SMTP id b18so1258544wrn.6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 05 Mar 2021 01:17:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=m0BaSCINjuV6YKS4LQw2bQ0VOXZwqzhx3JH5vS4yw4A=;
 b=dSK8cK8YdJCHbOxvyzk4NaS2W1an+k1SSlSqlbzAfzisIIOT114FG3nmrlwBPZfX/L
 IWpalQMzqqRrpNoJN3JNcSt+XkcD1u5p3Mfw18YrEXh2neL+YKp5CGnvLQ21jChB6el0
 Zr22QATr21AzfIQlNTeAXBJC4bnCpLCjsBMe7/2NVXPnniv2k2OGDq1TnpAx+Vq/tPw4
 uf0A6ZKubbxRsOBfwliKV+8Nh8/1fVB9EzCnyK0IYPAGcHm5fwnl9BLs1Q3yvhz37ycd
 SRZgFuQUQVV3T4Gk4DB+f1O2eaCSx7GeK/l9XkEANOk6165hF7fVKRFToyHmNLxVG636
 xjbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=m0BaSCINjuV6YKS4LQw2bQ0VOXZwqzhx3JH5vS4yw4A=;
 b=a/joArySmTSM0+SDQIrsaSamp/FAaCC17AEzK7sUBawlRF0xACm0+aC8zLa24HnYtY
 ZGpSKxYUa3KaYIv0ByeinFz3ML/LQoXu+Rjj/NWHJrkXoas3V08oTU9KSKsV6nUJD4+/
 zAvE1rUKkz5vLAszYjXcNbzye5DczxgpP7kuWKyX7i2U6CWe0ILv6sc2nKQn3BOI14OD
 u14TxLIB+MBJednSCAftIYizuLC/1vYrT8QSi13OXdlCGZanhzLp2NqC4w5yWAVbF7me
 G5RUJTq+NWhDGf677FR1KJh6HKPRscr4bPvG2lT86BFE8uxCoNsZT218aYjG8lrmoOFc
 4s9A==
X-Gm-Message-State: AOAM530WBXiFfUCGo2QfCLqA+j4K/aX105uW3U7iIyjbmzeiAJf2/rWC
 Xg/+H4d9NcdUCkIULvomhOojlA==
X-Google-Smtp-Source: ABdhPJwkqGaJDZi1qJyXxeSAeeGexX9CiTR+848rPCJ3/MZ5zmUWeN2uI8ddfxcqr8O1iyHfvoSCkg==
X-Received: by 2002:a5d:4dd2:: with SMTP id f18mr8379236wru.366.1614935839616; 
 Fri, 05 Mar 2021 01:17:19 -0800 (PST)
Received: from google.com (230.69.233.35.bc.googleusercontent.com.
 [35.233.69.230])
 by smtp.gmail.com with ESMTPSA id s20sm3833269wmj.36.2021.03.05.01.17.19
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 05 Mar 2021 01:17:19 -0800 (PST)
Date: Fri, 5 Mar 2021 09:17:16 +0000
From: Quentin Perret <qperret@google.com>
To: Will Deacon <will@kernel.org>
Subject: Re: [PATCH v3 24/32] KVM: arm64: Reserve memory for host stage 2
Message-ID: <YEH3HNn9+Y3UbKPj@google.com>
References: <20210302150002.3685113-1-qperret@google.com>
 <20210302150002.3685113-25-qperret@google.com>
 <20210304194953.GD21950@willie-the-truck>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210304194953.GD21950@willie-the-truck>
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

On Thursday 04 Mar 2021 at 19:49:53 (+0000), Will Deacon wrote:
> On Tue, Mar 02, 2021 at 02:59:54PM +0000, Quentin Perret wrote:
> > Extend the memory pool allocated for the hypervisor to include enough
> > pages to map all of memory at page granularity for the host stage 2.
> > While at it, also reserve some memory for device mappings.
> > 
> > Signed-off-by: Quentin Perret <qperret@google.com>
> > ---
> >  arch/arm64/kvm/hyp/include/nvhe/mm.h | 23 ++++++++++++++++++++++-
> >  arch/arm64/kvm/hyp/nvhe/setup.c      | 12 ++++++++++++
> >  arch/arm64/kvm/hyp/reserved_mem.c    |  2 ++
> >  3 files changed, 36 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/arm64/kvm/hyp/include/nvhe/mm.h b/arch/arm64/kvm/hyp/include/nvhe/mm.h
> > index ac0f7fcffd08..411a35db949c 100644
> > --- a/arch/arm64/kvm/hyp/include/nvhe/mm.h
> > +++ b/arch/arm64/kvm/hyp/include/nvhe/mm.h
> > @@ -53,7 +53,7 @@ static inline unsigned long __hyp_pgtable_max_pages(unsigned long nr_pages)
> >  	return total;
> >  }
> >  
> > -static inline unsigned long hyp_s1_pgtable_pages(void)
> > +static inline unsigned long __hyp_pgtable_total_pages(void)
> >  {
> >  	unsigned long res = 0, i;
> >  
> > @@ -63,9 +63,30 @@ static inline unsigned long hyp_s1_pgtable_pages(void)
> >  		res += __hyp_pgtable_max_pages(reg->size >> PAGE_SHIFT);
> >  	}
> >  
> > +	return res;
> > +}
> > +
> > +static inline unsigned long hyp_s1_pgtable_pages(void)
> > +{
> > +	unsigned long res;
> > +
> > +	res = __hyp_pgtable_total_pages();
> > +
> >  	/* Allow 1 GiB for private mappings */
> >  	res += __hyp_pgtable_max_pages(SZ_1G >> PAGE_SHIFT);
> >  
> >  	return res;
> >  }
> > +
> > +static inline unsigned long host_s2_mem_pgtable_pages(void)
> > +{
> > +	return __hyp_pgtable_total_pages() + 16;
> 
> Is this 16 due to the possibility of a concatenated pgd?

Yes it is, to be sure we have a safe upper-bound.

> If so, please add a comment to that effect.

Will do, thanks.
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
