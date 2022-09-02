Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C9C9ECAAD5
	for <kvmarm@archiver.kernel.org>; Fri,  2 Sep 2022 13:45:39 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1F87C4B2C2;
	Fri,  2 Sep 2022 09:45:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8co1aOQ5ifz4; Fri,  2 Sep 2022 09:45:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 42B4B4B231;
	Fri,  2 Sep 2022 09:45:37 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5F8514B231
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Sep 2022 09:45:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XrJa7DlPDblQ for <kvmarm@lists.cs.columbia.edu>;
 Fri,  2 Sep 2022 09:45:34 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 21CAF4B21C
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Sep 2022 09:45:34 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 13FD26211B;
 Fri,  2 Sep 2022 13:45:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1852C433D6;
 Fri,  2 Sep 2022 13:45:30 +0000 (UTC)
Date: Fri, 2 Sep 2022 14:45:27 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Peter Collingbourne <pcc@google.com>
Subject: Re: [PATCH v3 6/7] KVM: arm64: permit all VM_MTE_ALLOWED mappings
 with MTE enabled
Message-ID: <YxII905jjQz0FH4D@arm.com>
References: <20220810193033.1090251-1-pcc@google.com>
 <20220810193033.1090251-7-pcc@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220810193033.1090251-7-pcc@google.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Cornelia Huck <cohuck@redhat.com>, Steven Price <steven.price@arm.com>,
 linux-arm-kernel@lists.infradead.org,
 Vincenzo Frascino <vincenzo.frascino@arm.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, Evgenii Stepanov <eugenis@google.com>
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

On Wed, Aug 10, 2022 at 12:30:32PM -0700, Peter Collingbourne wrote:
> Certain VMMs such as crosvm have features (e.g. sandboxing) that depend
> on being able to map guest memory as MAP_SHARED. The current restriction
> on sharing MAP_SHARED pages with the guest is preventing the use of
> those features with MTE. Now that the races between tasks concurrently
> clearing tags on the same page have been fixed, remove this restriction.
> 
> Signed-off-by: Peter Collingbourne <pcc@google.com>
> ---
>  arch/arm64/kvm/mmu.c | 8 --------
>  1 file changed, 8 deletions(-)
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index d54be80e31dd..fc65dc20655d 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1075,14 +1075,6 @@ static void sanitise_mte_tags(struct kvm *kvm, kvm_pfn_t pfn,
>  
>  static bool kvm_vma_mte_allowed(struct vm_area_struct *vma)
>  {
> -	/*
> -	 * VM_SHARED mappings are not allowed with MTE to avoid races
> -	 * when updating the PG_mte_tagged page flag, see
> -	 * sanitise_mte_tags for more details.
> -	 */
> -	if (vma->vm_flags & VM_SHARED)
> -		return false;

I think this is fine with the locking in place (BTW, it may be worth
mentioning in the commit message that it's a relaxation of the ABI). I'd
like Steven to have a look as well when he gets the time, in case we
missed anything on the KVM+MTE side.

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
