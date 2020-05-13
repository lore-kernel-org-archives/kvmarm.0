Return-Path: <SRS0=/ewP=63=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CB95CA90AF
	for <kvmarm@archiver.kernel.org>; Wed, 13 May 2020 09:07:00 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B0256206A5
	for <kvmarm@archiver.kernel.org>; Wed, 13 May 2020 09:06:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="NSVYfRzX"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B0256206A5
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1CFF34B20E;
	Wed, 13 May 2020 05:06:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id asL8Y0v2hnWG; Wed, 13 May 2020 05:06:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E0C144B24D;
	Wed, 13 May 2020 05:06:57 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3773B4B207
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 May 2020 05:06:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vh8RU6XKvj7k for <kvmarm@lists.cs.columbia.edu>;
 Wed, 13 May 2020 05:06:55 -0400 (EDT)
Received: from mail-wr1-f67.google.com (mail-wr1-f67.google.com
 [209.85.221.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1D51F4B1CD
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 May 2020 05:06:55 -0400 (EDT)
Received: by mail-wr1-f67.google.com with SMTP id v12so19857848wrp.12
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 May 2020 02:06:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=sAz22Qf5FRJKdunB6aL5p2mmvJR5GBHWvdnGZkiVqTA=;
 b=NSVYfRzXzR7uUhwc5wpgdH4cy/nHDWl6Ycsvjllye+7k2RoNJaAbfSrhysBV3nQRFR
 Vv4hrCsx4XjIKsglu2ZKqe3WGYeQaI5yNPPde4hZU2ifJH4BlNEgtApcgN4fF8H4/jSQ
 a9LrjX5AAQFngrJM2YsZ79hofUuj3XXNEgAq+8wy+3WTfxSi+cByUp+9Bb6lGiq6kMZq
 E+tc9ZgM3iV6L9DmlObACm3hAUWvXh6ZQismk2m8LLAEX5OtD6Vqj4thsx+AWW+QXD4t
 Ot0diSIBEoeSy8j8NW+A2nDtCSWBGN/uPZM4o5K6GjnS8sZ0zcCbWseZ8BV1wW3VeztU
 0XnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=sAz22Qf5FRJKdunB6aL5p2mmvJR5GBHWvdnGZkiVqTA=;
 b=aEJ2ASIsLodloILogYnNeGvCVkBRnGKPTHswvqsqS9LwjW4dmofQdJqWCkavHtvrQa
 WtocQ5HCn1ChJfCBeORx/loHlhWmyC5EjkRS7eUppCXQ+yjW0Mz/aYgZlAGHWpclkDSR
 vMQNQMDo6bJq7+ITAj1kRzLq5mtrDC9fYelorlw6+jg/MKrzoJoypIgTZzA8E4NxW4bm
 WBolWXvyg1bPO8tUro3SdDeuOKQ+g/nDwPzr3w+DCfddTG3Mih//ryLCrTdlr/4n191k
 UYOQJ7EbHukB6x88wkCnQnignfZ3LZkEEkaGq3DYevaXNv84LLog7QCxKujrxn7C1UrU
 vm1Q==
X-Gm-Message-State: AGi0PuYxpWPpF9bedLZxkbIp6x+JyMyqK7beB6qCtNJWGL1s1GsB2d1f
 7H2iNP/bWKlD2z8B2vqP6cn2lg==
X-Google-Smtp-Source: APiQypIIFOViZHe/I++TwFOrfnuWl7zhlP4ZWLO5ZAjebaUXaOhLLT0nrmxPGsJEtdQd9W5w4E+DNQ==
X-Received: by 2002:a5d:4dc9:: with SMTP id f9mr20206671wru.407.1589360813739; 
 Wed, 13 May 2020 02:06:53 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:109:355c:447d:ad3d:ac5c])
 by smtp.gmail.com with ESMTPSA id w18sm27011053wro.33.2020.05.13.02.06.52
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 13 May 2020 02:06:53 -0700 (PDT)
Date: Wed, 13 May 2020 10:06:48 +0100
From: Andrew Scull <ascull@google.com>
To: James Morse <james.morse@arm.com>
Subject: Re: [PATCH 08/26] KVM: arm64: Use TTL hint in when invalidating
 stage-2 translations
Message-ID: <20200513090648.GA193035@google.com>
References: <20200422120050.3693593-1-maz@kernel.org>
 <20200422120050.3693593-9-maz@kernel.org>
 <20200507151321.GH237572@google.com>
 <63e16fdd-fe1b-07d3-23b7-cd99170fdd59@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <63e16fdd-fe1b-07d3-23b7-cd99170fdd59@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, kvm@vger.kernel.org,
 Marc Zyngier <maz@kernel.org>, Dave Martin <Dave.Martin@arm.com>,
 George Cherian <gcherian@marvell.com>,
 "Zengtao \(B\)" <prime.zeng@hisilicon.com>,
 Andre Przywara <andre.przywara@arm.com>, Will Deacon <will@kernel.org>,
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

On Tue, May 12, 2020 at 01:04:31PM +0100, James Morse wrote:
> Hi Andrew,
> 
> On 07/05/2020 16:13, Andrew Scull wrote:
> >> @@ -176,7 +177,7 @@ static void clear_stage2_pud_entry(struct kvm_s2_mmu *mmu, pud_t *pud, phys_addr
> >>  	pmd_t *pmd_table __maybe_unused = stage2_pmd_offset(kvm, pud, 0);
> >>  	VM_BUG_ON(stage2_pud_huge(kvm, *pud));
> >>  	stage2_pud_clear(kvm, pud);
> >> -	kvm_tlb_flush_vmid_ipa(mmu, addr);
> >> +	kvm_tlb_flush_vmid_ipa(mmu, addr, S2_NO_LEVEL_HINT);
> >>  	stage2_pmd_free(kvm, pmd_table);
> >>  	put_page(virt_to_page(pud));
> >>  }
> >> @@ -186,7 +187,7 @@ static void clear_stage2_pmd_entry(struct kvm_s2_mmu *mmu, pmd_t *pmd, phys_addr
> >>  	pte_t *pte_table = pte_offset_kernel(pmd, 0);
> >>  	VM_BUG_ON(pmd_thp_or_huge(*pmd));
> >>  	pmd_clear(pmd);
> >> -	kvm_tlb_flush_vmid_ipa(mmu, addr);
> >> +	kvm_tlb_flush_vmid_ipa(mmu, addr, S2_NO_LEVEL_HINT);
> >>  	free_page((unsigned long)pte_table);
> >>  	put_page(virt_to_page(pmd));
> >>  }
> > 
> > Going by the names, is it possible to give a better level hint for these
> > cases?
> 
> There is no leaf entry being invalidated here. After clearing the range, we found we'd
> emptied (and invalidated) a whole page of mappings:
> |	if (stage2_pmd_table_empty(kvm, start_pmd))
> |		clear_stage2_pud_entry(mmu, pud, start_addr);
> 
> Now we want to remove the link to the empty page so we can free it. We are changing the
> structure of the tables, not what gets mapped.
> 
> I think this is why we need the un-hinted behaviour, to invalidate "any level of the
> translation table walk required to translate the specified IPA". Otherwise the hardware
> can look for a leaf at the indicated level, find none, and do nothing.
> 
> 
> This is sufficiently horrible, its possible I've got it completely wrong! (does it make
> sense?)

Ok. `addr` is an IPA, that IPA is now omitted from the map so doesn't
appear in any entry of the table, least of all a leaf entry. That makes
sense.

Is there a convention to distinguish IPA and PA similar to the
distinction for VA or does kvmarm just use phys_addr_t all round?

It seems like the TTL patches are failry self contained if it would be
easier to serparate them out from these larger series?
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
