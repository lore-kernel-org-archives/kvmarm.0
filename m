Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F09F7ECAAA1
	for <kvmarm@archiver.kernel.org>; Fri, 28 Oct 2022 09:19:31 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7AD8B40BFA;
	Fri, 28 Oct 2022 05:19:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BySsE+cXv4Sw; Fri, 28 Oct 2022 05:19:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4ABCD40D02;
	Fri, 28 Oct 2022 05:19:30 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 835C740BFA
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Oct 2022 05:19:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id a30yMySeh8lQ for <kvmarm@lists.cs.columbia.edu>;
 Fri, 28 Oct 2022 05:19:27 -0400 (EDT)
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3A14040B75
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Oct 2022 05:19:27 -0400 (EDT)
Date: Fri, 28 Oct 2022 09:19:15 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1666948765;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=1neScYfEnwSJ+NX5bJKyCKTwiZXUeEpGO+gHaDwAPPk=;
 b=sDxLyh93SB9mcl5De1HP2Yk7RB6c4UYvrsf9ar0vcv4D9NFlPce7E2c8C0Pq1i88TJMWAb
 VoJ3p+UmF98/Hw19Lvnxu0TZHvr5IbooniT3GN3MJVbZqPzF9p0TXucQMVY7o1LHTLewWO
 hc1CT6/5k7yPcxG+xZ/JjPpYYE2iZEE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH v3 08/15] KVM: arm64: Protect stage-2 traversal with RCU
Message-ID: <Y1uek8RygHO+cXCF@google.com>
References: <20221027221752.1683510-1-oliver.upton@linux.dev>
 <20221027221752.1683510-9-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20221027221752.1683510-9-oliver.upton@linux.dev>
X-Migadu-Flow: FLOW_OUT
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Ben Gardon <bgardon@google.com>, David Matlack <dmatlack@google.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
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

On Thu, Oct 27, 2022 at 10:17:45PM +0000, Oliver Upton wrote:
> The use of RCU is necessary to safely change the stage-2 page tables in
> parallel. Acquire and release the RCU read lock when traversing the page
> tables.
> 
> Use the _raw() flavor of rcu_dereference when changes to the page tables
> are otherwise protected from parallel software walkers (e.g. holding the
> write lock).
> 
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>  arch/arm64/include/asm/kvm_pgtable.h | 41 ++++++++++++++++++++++++++++
>  arch/arm64/kvm/hyp/pgtable.c         | 10 ++++++-
>  2 files changed, 50 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index e70cf57b719e..d1859e8550df 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -37,6 +37,13 @@ static inline u64 kvm_get_parange(u64 mmfr0)
>  
>  typedef u64 kvm_pte_t;
>  
> +/*
> + * RCU cannot be used in a non-kernel context such as the hyp. As such, page
> + * table walkers used in hyp do not call into RCU and instead use other
> + * synchronization mechanisms (such as a spinlock).
> + */
> +#if defined(__KVM_NVHE_HYPERVISOR__) || defined(__KVM_VHE_HYPERVISOR__)
> +
>  typedef kvm_pte_t *kvm_pteref_t;
>  
>  static inline kvm_pte_t *kvm_dereference_pteref(kvm_pteref_t pteref, bool shared)
> @@ -44,6 +51,40 @@ static inline kvm_pte_t *kvm_dereference_pteref(kvm_pteref_t pteref, bool shared
>  	return pteref;
>  }
>  
> +static inline void kvm_pgtable_walk_begin(void) {}
> +static inline void kvm_pgtable_walk_end(void) {}
> +
> +static inline bool kvm_pgtable_walk_lock_held(void)
> +{
> +	return true;
> +}
> +
> +#else
> +
> +typedef kvm_pte_t __rcu *kvm_pteref_t;
> +
> +static inline kvm_pte_t *kvm_dereference_pteref(kvm_pteref_t pteref, bool shared)
> +{
> +	return rcu_dereference_check(pteref, shared);

I accidentally squashed the fix for !shared into 9/15, not this patch.
Fix ready for v4.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
