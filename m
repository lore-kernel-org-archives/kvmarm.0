Return-Path: <SRS0=sayA=JR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6745C433ED
	for <kvmarm@archiver.kernel.org>; Tue, 20 Apr 2021 12:58:12 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0B3F7613CD
	for <kvmarm@archiver.kernel.org>; Tue, 20 Apr 2021 12:58:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0B3F7613CD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F1144B3A7;
	Tue, 20 Apr 2021 08:58:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PFkGm8KbcxAO; Tue, 20 Apr 2021 08:58:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 196D84B396;
	Tue, 20 Apr 2021 08:58:10 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DCDB24B396
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Apr 2021 08:58:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wVZcgDjbHUbL for <kvmarm@lists.cs.columbia.edu>;
 Tue, 20 Apr 2021 08:58:04 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 552754B38E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Apr 2021 08:58:04 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 89A4A613C3;
 Tue, 20 Apr 2021 12:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1618923481;
 bh=pj7iH5/7ryvKV0103e/WzDqoTVMCnCeOsU1aueXSSWs=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=AELGbPakwwA189udgGAWTMEERvHJSzMiJJ6zXc+pUHeHypJdz0V2fLe+BD1bzM3Nx
 u9j/1K2l5BkbehD9ogeiYm7EMiRtZo3pybYvM6cZGY5LcQAnHIi9VRZ7v8vxG+stQK
 GZ2TdxDIffeM0R+97tZrgAqWdhdoTu45VU5HxgOq9PfOoGh0glAUuurDI2Bad4nDOo
 KZECeDYreSNaGkVAIyk8uMOKfQSmqol2Tr19JuTT7Jw0eQB08RumVkZeFP3Qz2yLts
 SHCbpptQUT2ALWZS3QX0qSFE7JldhhO5+xK9SIm7k9tZyQCR2vjrXrovnnIkVMTz5M
 Ap+IrrXFwGzUw==
Date: Tue, 20 Apr 2021 15:57:52 +0300
From: Mike Rapoport <rppt@kernel.org>
To: David Hildenbrand <david@redhat.com>
Subject: Re: [PATCH v1 1/4] include/linux/mmzone.h: add documentation for
 pfn_valid()
Message-ID: <YH7P0J4+1erJK7v5@kernel.org>
References: <20210420090925.7457-1-rppt@kernel.org>
 <20210420090925.7457-2-rppt@kernel.org>
 <f900f889-f059-7d48-dfc7-145c8cd54cf6@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <f900f889-f059-7d48-dfc7-145c8cd54cf6@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 Mike Rapoport <rppt@linux.ibm.com>, linux-mm@kvack.org,
 kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org
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

On Tue, Apr 20, 2021 at 11:22:53AM +0200, David Hildenbrand wrote:
> On 20.04.21 11:09, Mike Rapoport wrote:
> > From: Mike Rapoport <rppt@linux.ibm.com>
> > 
> > Add comment describing the semantics of pfn_valid() that clarifies that
> > pfn_valid() only checks for availability of a memory map entry (i.e. struct
> > page) for a PFN rather than availability of usable memory backing that PFN.
> > 
> > The most "generic" version of pfn_valid() used by the configurations with
> > SPARSEMEM enabled resides in include/linux/mmzone.h so this is the most
> > suitable place for documentation about semantics of pfn_valid().
> > 
> > Suggested-by: Anshuman Khandual <anshuman.khandual@arm.com>
> > Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
> > ---
> >   include/linux/mmzone.h | 11 +++++++++++
> >   1 file changed, 11 insertions(+)
> > 
> > diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> > index 47946cec7584..961f0eeefb62 100644
> > --- a/include/linux/mmzone.h
> > +++ b/include/linux/mmzone.h
> > @@ -1410,6 +1410,17 @@ static inline int pfn_section_valid(struct mem_section *ms, unsigned long pfn)
> >   #endif
> >   #ifndef CONFIG_HAVE_ARCH_PFN_VALID
> > +/**
> > + * pfn_valid - check if there is a valid memory map entry for a PFN
> > + * @pfn: the page frame number to check
> > + *
> > + * Check if there is a valid memory map entry aka struct page for the @pfn.
> > + * Note, that availability of the memory map entry does not imply that
> > + * there is actual usable memory at that @pfn. The struct page may
> > + * represent a hole or an unusable page frame.
> > + *
> > + * Return: 1 for PFNs that have memory map entries and 0 otherwise
> > + */
> >   static inline int pfn_valid(unsigned long pfn)
> >   {
> >   	struct mem_section *ms;
> > 
> 
> I'd rephrase all "there is a valid memory map" to "there is a memory map"
> and add "pfn_valid() does to indicate whether the memory map as actually
> initialized -- see pfn_to_online_page()."
> 
> pfn_valid() means that we can do a pfn_to_page() and don't get a fault when
> accessing the "struct page". It doesn't state anything about the content.

Well, I mean valid in the sense you can access the struct page :)
How about:

/**
 * pfn_valid - check if there is a memory map entry for a PFN
 * @pfn: the page frame number to check
 *
 * Check if there is a memory map entry aka struct page for the @pfn and it
 * is safe to access that struct page; the struct page state may be
 * uninitialized -- see pfn_to_online_page().
 *
 * Note, that availability of the memory map entry does not imply that
 * there is actual usable memory at that @pfn. The struct page may
 * represent a hole or an unusable page frame.
 *
 * Return: 1 for PFNs that have memory map entries and 0 otherwise.
 */

-- 
Sincerely yours,
Mike.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
