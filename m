Return-Path: <SRS0=ROvZ=CM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5413EC433E2
	for <kvmarm@archiver.kernel.org>; Thu,  3 Sep 2020 12:30:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id ADFD1206E7
	for <kvmarm@archiver.kernel.org>; Thu,  3 Sep 2020 12:30:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="iBqBAKHv"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ADFD1206E7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3FCC24B252;
	Thu,  3 Sep 2020 08:30:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SoVhYGr4Xaqu; Thu,  3 Sep 2020 08:30:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0E0CB4B23E;
	Thu,  3 Sep 2020 08:30:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 203F84B23E
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Sep 2020 08:30:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RLYNeQ+-itOM for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Sep 2020 08:30:39 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 231C64B238
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Sep 2020 08:30:39 -0400 (EDT)
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 60E74206E7;
 Thu,  3 Sep 2020 12:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1599136238;
 bh=xFR3P+zYPHxM2sBzwoV1/YxIxKxtNl1+GVkKMJb59tY=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=iBqBAKHvrS6U8lGNjU7J3nwf+8JfMYD0wbak01Z+bZkNTzcvpZpOOcEAfW2Q5pjkB
 Rl2JqgOioqJQuwVn2U29c1Lngw01Q3lrkIDlrbv3J/nsj4HVIFvchRjhNqg0oeUN5l
 RAC/SpwLHpkfEA2rnbNoonfm05QJi25IoKhpFcNs=
Date: Thu, 3 Sep 2020 13:30:33 +0100
From: Will Deacon <will@kernel.org>
To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v3 06/21] KVM: arm64: Add support for stage-2
 map()/unmap() in generic page-table
Message-ID: <20200903123032.GB7412@willie-the-truck>
References: <20200825093953.26493-1-will@kernel.org>
 <20200825093953.26493-7-will@kernel.org>
 <4cb1fbc9-c20d-35f1-c0cc-da21c0562f0a@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4cb1fbc9-c20d-35f1-c0cc-da21c0562f0a@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: Marc Zyngier <maz@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
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

On Thu, Sep 03, 2020 at 09:18:27PM +1000, Gavin Shan wrote:
> On 8/25/20 7:39 PM, Will Deacon wrote:
> > Add stage-2 map() and unmap() operations to the generic page-table code.
> > 
> > Cc: Marc Zyngier <maz@kernel.org>
> > Cc: Quentin Perret <qperret@google.com>
> > Signed-off-by: Will Deacon <will@kernel.org>
> > ---
> >   arch/arm64/include/asm/kvm_pgtable.h |  39 ++++
> >   arch/arm64/kvm/hyp/pgtable.c         | 262 +++++++++++++++++++++++++++
> >   2 files changed, 301 insertions(+)

[...]

> > +static int stage2_map_walk_table_post(u64 addr, u64 end, u32 level,
> > +				      kvm_pte_t *ptep,
> > +				      struct stage2_map_data *data)
> > +{
> > +	int ret = 0;
> > +
> > +	if (!data->anchor)
> > +		return 0;
> > +
> > +	free_page((unsigned long)kvm_pte_follow(*ptep));
> > +	put_page(virt_to_page(ptep));
> > +
> > +	if (data->anchor == ptep) {
> > +		data->anchor = NULL;
> > +		ret = stage2_map_walk_leaf(addr, end, level, ptep, data);
> > +	}
> > +
> > +	return ret;
> > +}
> > +
> 
> As discussed in another thread, *ptep has been invalidated in stage2_map_walk_table_pre().
> It means *ptep has value of zero. The following call to free_page() is going to release
> the page frame corresponding to physical address 0x0. It's not correct. We might cache
> the original value of this page table entry so that it can be used here.

Ah, yes, I see what you mean. But it's odd that I haven't run into this
myself, so let me try to reproduce the issue first. Another solution is
to invalidate the table entry only by clearing the valid bit of the pte,
rather than zapping the entire thing to 0, which can be done later when we
clear the anchor.

Cheers,

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
