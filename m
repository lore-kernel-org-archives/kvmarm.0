Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EF1FC433FE
	for <kvmarm@archiver.kernel.org>; Fri, 10 Dec 2021 14:34:26 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AE6314B1CB;
	Fri, 10 Dec 2021 09:34:25 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fFSMuUyMzfqP; Fri, 10 Dec 2021 09:34:24 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4FA314B1EF;
	Fri, 10 Dec 2021 09:34:24 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 62F3F4B1CC
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Dec 2021 09:34:23 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XCI6RXdDBCtA for <kvmarm@lists.cs.columbia.edu>;
 Fri, 10 Dec 2021 09:34:22 -0500 (EST)
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com
 [209.85.221.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CF08E4B1CB
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Dec 2021 09:34:21 -0500 (EST)
Received: by mail-wr1-f47.google.com with SMTP id q3so15251952wru.5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Dec 2021 06:34:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=2GRxg5k+GfsTEG/HHuVw87NAnSnT8iO/e9MJjPT+e+o=;
 b=L1Ulimte4Z0H1umx57noMXuSMT9z2pNYcjaEcRkOmHyohqLlZ+Jry54jxw02IUiQ6b
 hZIeoWT+jE63R1PqJaesjr0s292gCWiojZhiGY8yrz8EvqzDidcmdx/BscgF2d0Gsw/c
 z+BcffbPwxmOIHinccz2yA5mfDkPrGDPikdswIP0JX2bHiTzy136GaNEbksFDzmHWkjA
 mM/uKKrvrs0+ilM7xZ5243GOYfYAZCPRIWdDiVy71XqKOxGNran1gLigBpqsktzZZZJL
 NTFLY8vXktAMnsiiuZwJXRS+33761Fln7pNz4LY9Gq37455yUWc28PC2BiTuyxFi8OeG
 LAYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=2GRxg5k+GfsTEG/HHuVw87NAnSnT8iO/e9MJjPT+e+o=;
 b=bMYCReHkaehKD5Vdq7lUErh4rbhVDzuVkp3Td+Lf2AolfwNQBiqvarh4LfRuVdJBx7
 HSnT+W+LbkPb5h6B2FCnUh86Y4bb7ACQ7ns4BIaXOv2GHBXZKm0dSeQ++vnyCuYJXQ3a
 iFtUJeyXqjqpeW3WEeWuvMcVniIvGG4O83VDjnGXGY4mHXg5zu8xyJuPzPYhqyUv0fSG
 E3CbwdHZqc4mSU/fbz/A0toxal7eC53nTH8k5acMHWvI8/+pFzdlx0BUizycimPexbAz
 wA356D5Hq3DKVICikUtObx6EVnUtxicso3KPxiZm0gRWgqQi8XADxSY1Rwvhsz1SJImR
 6brg==
X-Gm-Message-State: AOAM532JMl35V3gmSDbUQypg5NjUEjJDo10LWPpXZjkAnG4Es+BAXT8m
 et7WsSXRZNxqhfJnFe6Y5GqZlw==
X-Google-Smtp-Source: ABdhPJxiJpf2C0a+T3mNrYtnyB6jDvTMU3ozNfVS8W1q01Qvfry0eiftJK86AH/NRJNix5u8rcTx0A==
X-Received: by 2002:a5d:514a:: with SMTP id u10mr14460951wrt.321.1639146860456; 
 Fri, 10 Dec 2021 06:34:20 -0800 (PST)
Received: from google.com ([2a00:79e0:d:210:76c1:fb36:1e22:8677])
 by smtp.gmail.com with ESMTPSA id z8sm2918950wrh.54.2021.12.10.06.34.19
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 10 Dec 2021 06:34:20 -0800 (PST)
Date: Fri, 10 Dec 2021 14:34:16 +0000
From: Quentin Perret <qperret@google.com>
To: Will Deacon <will@kernel.org>
Subject: Re: [PATCH v3 03/15] KVM: arm64: Refcount hyp stage-1 pgtable pages
Message-ID: <YbNlaIczPLXwSCcZ@google.com>
References: <20211201170411.1561936-1-qperret@google.com>
 <20211201170411.1561936-4-qperret@google.com>
 <20211209102924.GC1833@willie-the-truck>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20211209102924.GC1833@willie-the-truck>
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

On Thursday 09 Dec 2021 at 10:29:24 (+0000), Will Deacon wrote:
> On Wed, Dec 01, 2021 at 05:03:57PM +0000, Quentin Perret wrote:
> > To prepare the ground for allowing hyp stage-1 mappings to be removed at
> > run-time, update the KVM page-table code to maintain a correct refcount
> > using the ->{get,put}_page() function callbacks.
> > 
> > Signed-off-by: Quentin Perret <qperret@google.com>
> > ---
> >  arch/arm64/kvm/hyp/pgtable.c | 17 ++++++++++++++---
> >  1 file changed, 14 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> > index f8ceebe4982e..768a58835153 100644
> > --- a/arch/arm64/kvm/hyp/pgtable.c
> > +++ b/arch/arm64/kvm/hyp/pgtable.c
> > @@ -408,8 +408,10 @@ static bool hyp_map_walker_try_leaf(u64 addr, u64 end, u32 level,
> >  		return false;
> >  
> >  	new = kvm_init_valid_leaf_pte(phys, data->attr, level);
> > -	if (hyp_pte_needs_update(old, new))
> > +	if (hyp_pte_needs_update(old, new)) {
> >  		smp_store_release(ptep, new);
> > +		data->mm_ops->get_page(ptep);
> 
> In the case where we're just updating software bits for a valid pte, doesn't
> this result in us taking a spurious reference to the page?

Ahem, yes, that is the case. I ended up with the below diff to fix it,
which I intend to fold in the next version:

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 6ad4cb2d6947..e2047d3f05a2 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -383,21 +383,6 @@ enum kvm_pgtable_prot kvm_pgtable_hyp_pte_prot(kvm_pte_t pte)
        return prot;
 }

-static bool hyp_pte_needs_update(kvm_pte_t old, kvm_pte_t new)
-{
-       /*
-        * Tolerate KVM recreating the exact same mapping, or changing software
-        * bits if the existing mapping was valid.
-        */
-       if (old == new)
-               return false;
-
-       if (!kvm_pte_valid(old))
-               return true;
-
-       return !WARN_ON((old ^ new) & ~KVM_PTE_LEAF_ATTR_HI_SW);
-}
-
 static bool hyp_map_walker_try_leaf(u64 addr, u64 end, u32 level,
                                    kvm_pte_t *ptep, struct hyp_map_data *data)
 {
@@ -407,13 +392,16 @@ static bool hyp_map_walker_try_leaf(u64 addr, u64 end, u32 level,
        if (!kvm_block_mapping_supported(addr, end, phys, level))
                return false;

+       data->phys += granule;
        new = kvm_init_valid_leaf_pte(phys, data->attr, level);
-       if (hyp_pte_needs_update(old, new)) {
-               smp_store_release(ptep, new);
+       if (old == new)
+               return true;
+       else if (!kvm_pte_valid(old))
                data->mm_ops->get_page(ptep);
-       }
+       else if (WARN_ON((old ^ new) & ~KVM_PTE_LEAF_ATTR_HI_SW))
+               return false;

-       data->phys += granule;
+       smp_store_release(ptep, new);
        return true;
 }
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
