Received: from out-18.mta1.migadu.com (out-18.mta1.migadu.com [95.215.58.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E109AD4E
	for <kvmarm@lists.linux.dev>; Thu, 16 Mar 2023 23:42:19 +0000 (UTC)
Date: Thu, 16 Mar 2023 23:42:12 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1679010137;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Z9wFXHFTqY0qDRcH43pszZPbHt+9ze46oN5dD5scERM=;
	b=LtNgIIiFchLoDQZMYIjfVErlc53+gEFMCv31zVbKG+w/WX/9cNgUJtNhJsaE+oGs4zhs9Y
	Xmejd3PTagnQcaBzhRVlOhhT9fNC5mNMCSe6dDDiK5yOIT3LggZ4EJY7B3QDQzi5qpwu0c
	oTpCCSGaN7OezLzUDYGEL35c1tuTeAs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, Ard Biesheuvel <ardb@kernel.org>,
	Will Deacon <will@kernel.org>, Quentin Perret <qperret@google.com>,
	Sean Christopherson <seanjc@google.com>,
	David Matlack <dmatlack@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] KVM: arm64: Disable interrupts while walking
 userspace PTs
Message-ID: <ZBOpVLEPEJazjyGD@linux.dev>
References: <20230316174546.3777507-1-maz@kernel.org>
 <20230316174546.3777507-2-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230316174546.3777507-2-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

Marc,

On Thu, Mar 16, 2023 at 05:45:45PM +0000, Marc Zyngier wrote:
> We walk the userspace PTs to discover what mapping size was
> used there. However, this can race against the userspace tables
> being freed, and we end-up in the weeds.
> 
> Thankfully, the mm code is being generous and will IPI us when
> doing so. So let's implement our part of the bargain and disable
> interrupts around the walk. This ensures that nothing terrible
> happens during that time.
> 
> We still need to handle the removal of the page tables before
> the walk. For that, allow get_user_mapping_size() to return an
> error, and make sure this error can be propagated all the way
> to the the exit handler.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Cc: stable@vger.kernel.org

Looks good. I've squashed in this meaningless diff to make use of an existing
helper.


diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index e95593736ae3..3b9d4d24c361 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -691,7 +691,7 @@ static int get_user_mapping_size(struct kvm *kvm, u64 addr)
 		return -EFAULT;
 
 	/* Oops, the userspace PTs are gone... Replay the fault */
-	if (!(pte & PTE_VALID))
+	if (!kvm_pte_valid(pte))
 		return -EAGAIN;
 
 	return BIT(ARM64_HW_PGTABLE_LEVEL_SHIFT(level));

-- 
Thanks,
Oliver
