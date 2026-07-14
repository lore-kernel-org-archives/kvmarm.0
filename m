Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB2F436494C
	for <kvmarm@lists.linux.dev>; Tue, 14 Jul 2026 10:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784024444; cv=none; b=X+oRucoZWnL5SvW6RqDheiqA9ackLnHfrXjOVwaEqClr2he14Go5Sr6GM5LrPJrj36Kf8YHEBZqj7Bb+2AfXSRMnrSoIQVIf1lVlzRQuaVr6Khj6eRg4yEBNa+zZf4rqJH/xw2mcIa/tqR/Wtk6giaM3zilSob00MqcCrMyNNqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784024444; c=relaxed/simple;
	bh=c77uFUVgfJ05mGTz42Oxlye2lWOsU1Hake6afPEeEPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=O/UGmStc0aZsbrbE6c+Sq0X9GZ79n066ctTR8rCA/fPYEnmpg0VCdFCfFnmwnFpE2XnSOcHNl5vRmsSj4ncJTusNvzrsUps0tGlok0AIZmb4nF+/tvzgWDVkiJjIVhrRxti8HnsKMq2LTyP0oJDk5S8vaMzMFrkp/W3XjqsbEjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=uk6F5TpQ; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="uk6F5TpQ"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A3361497;
	Tue, 14 Jul 2026 03:20:37 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 88B163F7B4;
	Tue, 14 Jul 2026 03:20:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784024441; bh=c77uFUVgfJ05mGTz42Oxlye2lWOsU1Hake6afPEeEPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uk6F5TpQWkphk/6l4qeUni50zp5hcGobptnFkKTHCmH49LPAMZYLISkl7NeszC45b
	 OEe++W+nFKAMqOVmeU5Vh7XaiMgzkQmu4OT08Za+vpqtbygAJjAuspZqXmPGyb8sTZ
	 th3WksP5yMlHkekGOpO4c66dKP8d0d69y+lxxNKk=
From: Leonardo Bras <leo.bras@arm.com>
To: Tian Zheng <zhengtian10@huawei.com>
Cc: Leonardo Bras <leo.bras@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	oupton@kernel.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	yuzenghui@huawei.com,
	wangzhou1@hisilicon.com,
	yangjinqian1@huawei.com,
	caijian11@h-partners.com,
	liuyonglong@huawei.com,
	yezhenyu2@huawei.com,
	yubihong@huawei.com,
	linuxarm@huawei.com,
	joey.gouly@arm.com,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com
Subject: Re: [PATCH v4 3/6] KVM: arm64: Add auto DBM support for hardware dirty tracking
Date: Tue, 14 Jul 2026 11:20:36 +0100
Message-ID: <alYNdPKCYOiHXqpZ@LeoBrasDK>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <e01b9a9d-9f38-44ab-acfc-069f143863d6@huawei.com>
References: <20260709104026.2612599-1-zhengtian10@huawei.com> <20260709104026.2612599-4-zhengtian10@huawei.com> <alTJOy8Sv4aAp_9y@LeoBrasDK> <8f949334-3ce7-44f4-b6da-f08a4126affd@huawei.com> <86zezunifl.wl-maz@kernel.org> <e01b9a9d-9f38-44ab-acfc-069f143863d6@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Tue, Jul 14, 2026 at 03:44:37PM +0800, Tian Zheng wrote:
> 
> On 7/14/2026 3:23 PM, Marc Zyngier wrote:
> > On Tue, 14 Jul 2026 02:14:45 +0100,
> > Tian Zheng <zhengtian10@huawei.com> wrote:
> > > 
> > > On 7/13/2026 7:17 PM, Leonardo Bras wrote:
> > > > On Thu, Jul 09, 2026 at 06:40:23PM +0800, Tian Zheng wrote:
> > > > > The DBM (Dirty Bit Modifier) attribute, introduced in ARMv8.1, enables
> > > > > hardware to automatically promote write-clean pages to write-dirty. This
> > > > > prevents the guest from being trapped in EL2 due to missing write
> > > > > permissions.
> > > > > 
> > > > > In this design, DBM is controlled by the page-table level flag
> > > > > KVM_PGTABLE_S2_DBM rather than per-PTE software flags. DBM is
> > > > > automatically set for writable non-device pages when the page-table has
> > > > > KVM_PGTABLE_S2_DBM flag, which is determined at MMU init time based on
> > > > > hardware capability.
> > > > > 
> > > > > The DBM bit is set in stage2_set_prot_attr() for initial mappings and
> > > > > hugepage splitting, and directly manipulated in
> > > > > kvm_pgtable_stage2_relax_perms() when removing write-protection. On
> > > > > W->RO downgrade, DBM is cleared to prevent hardware from silently
> > > > > upgrading RO+DBM back to W+dirty, which would bypass KVM's write
> > > > > tracking.
> > > > > 
> > > > > kvm_pgtable_stage2_pte_prot() does not extract the DBM bit back into
> > > > > enum kvm_pgtable_prot because DBM is a page-table policy determined by
> > > > > pgt->flags, not a per-PTE property. Callers should check
> > > > > pgt->flags & KVM_PGTABLE_S2_DBM instead.
> > > > > 
> > > > > This ensures DBM is consistently applied across all PTEs, including
> > > > > during hugepage splitting where child PTEs inherit DBM from the parent
> > > > > block entry via the pgt->flags mechanism.
> > > > > 
> > > > > Safety: DBM bit is only interpreted by hardware when VTCR_EL2.HD=1.
> > > > > When HDBSS is not enabled (HD=0), ARM architecture guarantees hardware
> > > > > completely ignores DBM bit in PTEs.
> > > > > 
> > > > > Co-developed-by: Eillon <yezhenyu2@huawei.com>
> > > > > Signed-off-by: Eillon <yezhenyu2@huawei.com>
> > > > > Co-developed-by: Leonardo Bras <leo.bras@arm.com>
> > > > > Signed-off-by: Leonardo Bras <leo.bras@arm.com>
> > > > Hello Tian,
> > > > 
> > > > Have you added the above tags due to this patch being based on the below?
> > > > https://lore.kernel.org/all/20260629111820.1873540-2-leo.bras@arm.com/
> > > > 
> > > > Thanks!
> > > > Leo
> > > Hi Leo,
> > > 
> > > 
> > > Yes, I added your Signed-off-by because the DBM-related code in this patch
> > You really can't do that. Only Leo can give his SoB, you can't forge
> > it yourself.
> > 
> > > is based on your implementation in:
> > > 
> > > https://lore.kernel.org/all/20260629111820.1873540-2-leo.bras@arm.com/
> > Then take the patch as is, and add to it as a separate patch. Or work
> > out in private with Leo whether he's happy with a Co-dev. But never do
> > that unilaterally.
> > 
> > Thanks,
> > 
> > 	M.
> Got it, thanks for the clarification, Marc.
> 
> I'm sorry about that — I'll remove them in the next version.
> Instead, I'll mention the reference in the commit message with a link to
> Leo's original patch:
> 
> Based on Leonardo Bras's patch:
> https://lore.kernel.org/all/20260629111820.1873540-2-leo.bras@arm.com/

That works out for me!

Thanks!
Leo
