Return-Path: <SRS0=MGAT=6T=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C25BFC47254
	for <kvmarm@archiver.kernel.org>; Tue,  5 May 2020 15:59:27 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3E7D52073B
	for <kvmarm@archiver.kernel.org>; Tue,  5 May 2020 15:59:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="gkD+4b/H"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3E7D52073B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8EEF94B35F;
	Tue,  5 May 2020 11:59:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QonI-4zRLxKu; Tue,  5 May 2020 11:59:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 917974B2D9;
	Tue,  5 May 2020 11:59:25 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D66974B2D9
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 May 2020 11:59:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ekPvcDfZge1m for <kvmarm@lists.cs.columbia.edu>;
 Tue,  5 May 2020 11:59:22 -0400 (EDT)
Received: from mail-wm1-f66.google.com (mail-wm1-f66.google.com
 [209.85.128.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B8BB24B2B9
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 May 2020 11:59:22 -0400 (EDT)
Received: by mail-wm1-f66.google.com with SMTP id u16so2916203wmc.5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 05 May 2020 08:59:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=PGN1A+sSuq/RZDk1hxq5pwV+/ZZ2rP8eCBzu/0i9JeE=;
 b=gkD+4b/HuVR1OV+wasxnOnWiiI7SPXpzXXV6NVB0/4aI4sxsX5dMVJHJSdOMD/GURm
 0qolj7BO2CfRRwNI14+BawRnPnhQFbnlUcP94ozWZKQZ1j+V70vzlvFOzNOzEr69a50h
 DB8zN1wrTSCem8xjw10+5voFbemDDzJBFhfQvssigfGPmr4ohNpwDBYQIdOM2SwI6T8a
 HLnlfx9P89ZU7KsSlT4it26YLSo+cIqmksGluTOY68GBTbihTzxie6CFZNiG0k3v9aPx
 K/LPKXjBg/4qPR7FGBucSgPN1l94dxQnIeL+ZTHRdPPaYpokD3D/8eXp7f61AvRYXn11
 zXMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=PGN1A+sSuq/RZDk1hxq5pwV+/ZZ2rP8eCBzu/0i9JeE=;
 b=MsmsPTYAQQsukNFYIvbmv1llkVQfxU3MIUSgHFHuzx1+drnZOYu2VF2mvOJ9jYG4Kk
 d3FThsdxRA/LiByjoFJsSmzb09AhSc5bxp9auh2R0g6+LCoqGOoRGSSN6m7M1d1kd8aW
 Z3A++cORYxhJwypy1Vks49p4DG1WQlZ9HacPOz/QU8BwM2SEvqyJTVyOzPje0oPVLRS1
 srosOGy1YudC7e0JfGdm3I7++xjxF914U1EnNRBWnEiwiEKVF3gdLHfoxnnDUgFfoH/k
 I+nbzrzvb6rWSMnZJVpQ3TROszC9Wwtrlj49E9fBsMCT7kk6Fbj4WyK5izY3gINcRnwL
 K12g==
X-Gm-Message-State: AGi0PubwehihAZWpTesMCHTzI+2/rOpkLogGKIuCNSLjSqdJvTG3SHGa
 VbuBkmKROkWGp5BCTCMUabr0qA==
X-Google-Smtp-Source: APiQypIRbnHubEaPb4xAueBVmUC4wFvaCgRRjttD5slQL+gt6ng+H5WZMUHVwb5dq420a0m0Cc4QGw==
X-Received: by 2002:a7b:c7d2:: with SMTP id z18mr4240013wmk.72.1588694361415; 
 Tue, 05 May 2020 08:59:21 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:109:355c:447d:ad3d:ac5c])
 by smtp.gmail.com with ESMTPSA id a12sm841990wro.68.2020.05.05.08.59.20
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 05 May 2020 08:59:20 -0700 (PDT)
Date: Tue, 5 May 2020 16:59:16 +0100
From: Andrew Scull <ascull@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 05/26] arm64: Document SW reserved PTE/PMD bits in
 Stage-2 descriptors
Message-ID: <20200505155916.GB237572@google.com>
References: <20200422120050.3693593-1-maz@kernel.org>
 <20200422120050.3693593-6-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200422120050.3693593-6-maz@kernel.org>
Cc: kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
 kvmarm@lists.cs.columbia.edu, George Cherian <gcherian@marvell.com>,
 "Zengtao \(B\)" <prime.zeng@hisilicon.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Dave Martin <Dave.Martin@arm.com>, linux-arm-kernel@lists.infradead.org
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

On Wed, Apr 22, 2020 at 01:00:29PM +0100, Marc Zyngier wrote:
> Advertise bits [58:55] as reserved for SW in the S2 descriptors.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/pgtable-hwdef.h | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/pgtable-hwdef.h b/arch/arm64/include/asm/pgtable-hwdef.h
> index 6bf5e650da788..7eab0d23cdb52 100644
> --- a/arch/arm64/include/asm/pgtable-hwdef.h
> +++ b/arch/arm64/include/asm/pgtable-hwdef.h
> @@ -177,10 +177,12 @@
>  #define PTE_S2_RDONLY		(_AT(pteval_t, 1) << 6)   /* HAP[2:1] */
>  #define PTE_S2_RDWR		(_AT(pteval_t, 3) << 6)   /* HAP[2:1] */
>  #define PTE_S2_XN		(_AT(pteval_t, 2) << 53)  /* XN[1:0] */
> +#define PTE_S2_SW_RESVD		(_AT(pteval_t, 15) << 55) /* Reserved for SW */
>  
>  #define PMD_S2_RDONLY		(_AT(pmdval_t, 1) << 6)   /* HAP[2:1] */
>  #define PMD_S2_RDWR		(_AT(pmdval_t, 3) << 6)   /* HAP[2:1] */
>  #define PMD_S2_XN		(_AT(pmdval_t, 2) << 53)  /* XN[1:0] */
> +#define PMD_S2_SW_RESVD		(_AT(pmdval_t, 15) << 55) /* Reserved for SW */
>  
>  #define PUD_S2_RDONLY		(_AT(pudval_t, 1) << 6)   /* HAP[2:1] */
>  #define PUD_S2_RDWR		(_AT(pudval_t, 3) << 6)   /* HAP[2:1] */
> -- 
> 2.26.1
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

This is consistent with "Attribute fields in stage 1 VMSAv8-64 Block and
Page descriptors"

Reviewed-by: Andrew Scull <ascull@google.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
