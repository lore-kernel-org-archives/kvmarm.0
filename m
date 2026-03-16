Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0A1338D019
	for <kvmarm@lists.linux.dev>; Mon, 16 Mar 2026 10:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773658364; cv=none; b=IabWikJ0Z3FRzQrTRUIQTOicc1kItzbs3sgYsvw+i8WzG8fAO4DPcJTQhbT5apD8BfINDC4M8Qgjq6Pkyk9Qshr/STudtVUSwQLL1Xa6yNtHUQ4T5ZKk/I8o/SMjbHmiTmObqRp56okx6nZ5joKKrIejMgQjfvFP+RjNRG2Pf9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773658364; c=relaxed/simple;
	bh=3zhQaxFO8a9VJ9tTK77FDY1jPImEJXULhQaMs5r2qp8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uwoyKIFJGlhTXhU3isRKyykLCNtVJh0Qjnh6PbqWuLx8av9MRKXAFndLOlT/wf6lnSd23rcKTspeDc867lie0BtxUGTFbQMlXrEr/0nl8pLei/8UtQT8WgIqOnwXZPNelqYeJIEcB4zY6BbQZ06WUGNp4cr4bXR3f1B0N2KGS1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0A9F21477;
	Mon, 16 Mar 2026 03:52:36 -0700 (PDT)
Received: from thinkpad-e142931.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 557F23F73B;
	Mon, 16 Mar 2026 03:52:39 -0700 (PDT)
Date: Mon, 16 Mar 2026 10:52:32 +0000
From: Wei-Lin Chang <weilin.chang@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Sebastian Ene <sebastianene@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Subject: Re: [PATCH RESEND 2/2] KVM: arm64: nv: Expose shadow page tables in
 debugfs
Message-ID: <vrfd433vtewptnmirvb36i632i2wot4uh7mxkghac2lkww42dy@anzjc5fqojwz>
References: <20260308231829.864983-1-weilin.chang@arm.com>
 <20260308231829.864983-3-weilin.chang@arm.com>
 <abGNLOfKLcNGYcxh@google.com>
 <3virc5zxa7aow3qfuyyjwvzlmnjk4wlsfmmg7lixhder7rhd6q@qtlumbj33fks>
 <87ldfuda2i.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ldfuda2i.wl-maz@kernel.org>

On Sat, Mar 14, 2026 at 09:39:17AM +0000, Marc Zyngier wrote:
> On Fri, 13 Mar 2026 22:28:38 +0000,
> Wei-Lin Chang <weilin.chang@arm.com> wrote:
> > 
> > On Wed, Mar 11, 2026 at 03:41:32PM +0000, Sebastian Ene wrote:
> > > On Sun, Mar 08, 2026 at 11:18:29PM +0000, Wei-Lin Chang wrote:
> 
> [...]
> 
> > > > +void kvm_nested_s2_ptdump_create_debugfs(struct kvm_s2_mmu *mmu)
> > > > +{
> > > > +	struct dentry *dent;
> > > > +	/* format: 0x<vttbr>-0x<vtcr>-s2-{en, dis}abled\0 */
> > > > +	char file_name[2 + 16 + 1 + 2 + 16 + 4 + 3 + 6];
> > > 
> > > Can you hide the size of this definition behind a macro ?
> > 
> > Sure, no problem.
> 
> I don't think a macro helps that much on its own. I'd rather this is
> made a bit more foolproof by directly expressing the actual string
> this results into, and use that for the size:
> 
>   #define S2FNAMESZ sizeof("0x0123456789abcdef-0x0123456789abcdef-s2-disabled")
> 
>   char file_name[S2FNAME];
> 
> which is less ambiguous. The compiler will happily optimise this to a
> nice constant that also accounts for the final '\0'.

Thanks for the advice!
Makes sense to me, I'll change it to that.

Thanks,
Wei-Lin Chang

> 
> Thanks,
> 
> 	M.
> 
> -- 
> Jazz isn't dead. It just smells funny.
