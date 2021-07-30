Return-Path: <SRS0=HDjL=MW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D943C4338F
	for <kvmarm@archiver.kernel.org>; Fri, 30 Jul 2021 12:27:09 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C895461058
	for <kvmarm@archiver.kernel.org>; Fri, 30 Jul 2021 12:27:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org C895461058
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 53F4D4B0B7;
	Fri, 30 Jul 2021 08:27:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PBgUtJrovTYv; Fri, 30 Jul 2021 08:27:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 372F34B09C;
	Fri, 30 Jul 2021 08:27:07 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 838374B08D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Jul 2021 08:27:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vDwqwAaZ7vvd for <kvmarm@lists.cs.columbia.edu>;
 Fri, 30 Jul 2021 08:27:05 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 82A3A4A483
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Jul 2021 08:27:05 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4B1F66103B;
 Fri, 30 Jul 2021 12:27:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1627648024;
 bh=wT4Jmfp7K7e7610QIG6UJIKHHYTDycOajWViNs/FQzc=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=qOvuP+PZHGEQ6QFN9P+8FzxInej00GZmWtK4vwy+MZHMp1WOGMrViCMD0C4E/22gb
 MLo9g0h9j0QBO24ETL9yVk+AyNhZxKNKXxTWahTA5VCPHB65mgTEuHclGoqvxNecn5
 35Rpc2I2tuELdVK3Zmf8w431pR7IeEuLHZVO1yZ2sGEVlACBETPeYaXCT47Gy4u1ca
 do/tEe5NT7emIko7C5viwa0FRQ9Lo27DJljdYaZCHS8xYb0RglMeBNuIdFY302g55t
 llilOsUMxh7gMxsM5V2437OQA72tkzPS28rHXsx8u+qJ0OcWkMXN/UpQzpy19blt9G
 Wl4B6Bo4b/VRw==
Date: Fri, 30 Jul 2021 13:26:59 +0100
From: Will Deacon <will@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 04/16] KVM: arm64: Add MMIO checking infrastructure
Message-ID: <20210730122658.GG23589@willie-the-truck>
References: <20210715163159.1480168-1-maz@kernel.org>
 <20210715163159.1480168-5-maz@kernel.org>
 <20210727181107.GC19173@willie-the-truck>
 <8735ryep6d.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <8735ryep6d.wl-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: kvm@vger.kernel.org, kernel-team@android.com,
 Srivatsa Vaddagiri <vatsa@codeaurora.org>, linux-kernel@vger.kernel.org,
 Shanker R Donthineni <sdonthineni@nvidia.com>, kvmarm@lists.cs.columbia.edu,
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

On Wed, Jul 28, 2021 at 10:57:30AM +0100, Marc Zyngier wrote:
> On Tue, 27 Jul 2021 19:11:08 +0100,
> Will Deacon <will@kernel.org> wrote:
> > On Thu, Jul 15, 2021 at 05:31:47PM +0100, Marc Zyngier wrote:
> > > +bool kvm_install_ioguard_page(struct kvm_vcpu *vcpu, gpa_t ipa)
> > > +{
> > > +	struct kvm_mmu_memory_cache *memcache;
> > > +	struct kvm_memory_slot *memslot;
> > > +	int ret, idx;
> > > +
> > > +	if (!test_bit(KVM_ARCH_FLAG_MMIO_GUARD, &vcpu->kvm->arch.flags))
> > > +		return false;
> > > +
> > > +	/* Must be page-aligned */
> > > +	if (ipa & ~PAGE_MASK)
> > > +		return false;
> > > +
> > > +	/*
> > > +	 * The page cannot be in a memslot. At some point, this will
> > > +	 * have to deal with device mappings though.
> > > +	 */
> > > +	idx = srcu_read_lock(&vcpu->kvm->srcu);
> > > +	memslot = gfn_to_memslot(vcpu->kvm, ipa >> PAGE_SHIFT);
> > > +	srcu_read_unlock(&vcpu->kvm->srcu, idx);
> > 
> > What does this memslot check achieve? A new memslot could be added after
> > you've checked, no?
> 
> If you start allowing S2 annotations to coexist with potential memory
> mappings, you're in for trouble. The faulting logic will happily
> overwrite the annotation, and that's probably not what you want.

I don't disagree, but the check above appears to be racy.

> As for new (or moving) memslots, I guess they should be checked
> against existing annotations.

Something like that, but the devil is in the details as it will need to
synchronize with this check somehow.

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
