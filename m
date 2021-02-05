Return-Path: <SRS0=/Ra0=HH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D440AC433E0
	for <kvmarm@archiver.kernel.org>; Fri,  5 Feb 2021 18:01:25 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2287D64E44
	for <kvmarm@archiver.kernel.org>; Fri,  5 Feb 2021 18:01:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2287D64E44
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 81ED04B42E;
	Fri,  5 Feb 2021 13:01:24 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2CL53Of0QHzq; Fri,  5 Feb 2021 13:01:23 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3665A4B430;
	Fri,  5 Feb 2021 13:01:23 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E65764B42E
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Feb 2021 13:01:21 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ydbTx4pJNl69 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  5 Feb 2021 13:01:21 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CB42C4B41F
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Feb 2021 13:01:20 -0500 (EST)
Received: by mail.kernel.org (Postfix) with ESMTPSA id CD84E64E36;
 Fri,  5 Feb 2021 18:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1612548079;
 bh=Bjw+NwhSJiekA9yibIou0xtFz7GFWwM2qh2Z7IfduJs=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=b4HZizp8pcHVlwOrLYNlzVCFECExmAgpMYBpIaotN429mrIqldMuX+mLpVm+aS0MU
 /V8FUuY+jMnKmzgliriV7vFHvHSDdRrB8O7sl8iIcS3DDvZ9Jn6/+4+AE5HsLPiDFa
 aZf9s7FitOkxgvJsmohm0hF9W22GJ/tPEdghM93av/wBi2rIe7vdocYCiN8k9I/F5W
 h0awdwpj52CjngapeMwPC6oNTlGcBYp5NsB6DfbRNsKt4xNz0+K3z4rIhwCQWz7UpE
 1oIzVZLqhPRqap54FS7ZwNWgovFJ+/tTDAZcctOzyDyKEtr2R3rnAwbldU4Vbjg3bp
 p4UY6ypiDH6SA==
Date: Fri, 5 Feb 2021 18:01:13 +0000
From: Will Deacon <will@kernel.org>
To: Quentin Perret <qperret@google.com>
Subject: Re: [RFC PATCH v2 17/26] KVM: arm64: Elevate Hyp mappings creation
 at EL2
Message-ID: <20210205180113.GH22665@willie-the-truck>
References: <20210108121524.656872-1-qperret@google.com>
 <20210108121524.656872-18-qperret@google.com>
 <20210203153138.GB18974@willie-the-truck>
 <YBvVseNd/r8q5He1@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <YBvVseNd/r8q5He1@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: devicetree@vger.kernel.org, kernel-team@android.com, android-kvm@google.com,
 Catalin Marinas <catalin.marinas@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
 linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
 Frank Rowand <frowand.list@gmail.com>, kvmarm@lists.cs.columbia.edu
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

On Thu, Feb 04, 2021 at 11:08:33AM +0000, Quentin Perret wrote:
> On Wednesday 03 Feb 2021 at 15:31:39 (+0000), Will Deacon wrote:
> > On Fri, Jan 08, 2021 at 12:15:15PM +0000, Quentin Perret wrote:
> > > @@ -1481,7 +1486,10 @@ static void cpu_set_hyp_vector(void)
> > >  	struct bp_hardening_data *data = this_cpu_ptr(&bp_hardening_data);
> > >  	void *vector = hyp_spectre_vector_selector[data->slot];
> > >  
> > > -	*this_cpu_ptr_hyp_sym(kvm_hyp_vector) = (unsigned long)vector;
> > > +	if (!is_protected_kvm_enabled())
> > > +		*this_cpu_ptr_hyp_sym(kvm_hyp_vector) = (unsigned long)vector;
> > > +	else
> > > +		kvm_call_hyp_nvhe(__pkvm_cpu_set_vector, data->slot);
> > 
> > *Very* minor nit, but it might be cleaner to have static inline functions
> > with the same prototypes as the hypercalls, just to make the code even
> > easier to read. e.g
> > 
> > 	if (!is_protected_kvm_enabled())
> > 		_cpu_set_vector(data->slot);
> > 	else
> > 		kvm_call_hyp_nvhe(__pkvm_cpu_set_vector, data->slot);
> > 
> > you could then conceivably wrap that in a macro and avoid having the
> > "is_protected_kvm_enabled()" checks explicit every time.
> 
> Happy to do this here, but are you suggesting to generalize this pattern
> to other places as well?

I think it's probably a good pattern to follow, but no need to generalise it
prematurely.

> > > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > > index 3cf9397dabdb..9d4c9251208e 100644
> > > --- a/arch/arm64/kvm/mmu.c
> > > +++ b/arch/arm64/kvm/mmu.c
> > > @@ -225,15 +225,39 @@ void free_hyp_pgds(void)
> > >  	if (hyp_pgtable) {
> > >  		kvm_pgtable_hyp_destroy(hyp_pgtable);
> > >  		kfree(hyp_pgtable);
> > > +		hyp_pgtable = NULL;
> > >  	}
> > >  	mutex_unlock(&kvm_hyp_pgd_mutex);
> > >  }
> > >  
> > > +static bool kvm_host_owns_hyp_mappings(void)
> > > +{
> > > +	if (static_branch_likely(&kvm_protected_mode_initialized))
> > > +		return false;
> > > +
> > > +	/*
> > > +	 * This can happen at boot time when __create_hyp_mappings() is called
> > > +	 * after the hyp protection has been enabled, but the static key has
> > > +	 * not been flipped yet.
> > > +	 */
> > > +	if (!hyp_pgtable && is_protected_kvm_enabled())
> > > +		return false;
> > > +
> > > +	BUG_ON(!hyp_pgtable);
> > 
> > Can we fail more gracefully, e.g. by continuing without KVM?
> 
> Got any suggestion as to how that can be done? We could also just remove
> that line -- that really should not happen.

Or downgrade to WARN_ON.

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
