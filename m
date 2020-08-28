Return-Path: <SRS0=xBPq=CG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1552DC433E6
	for <kvmarm@archiver.kernel.org>; Fri, 28 Aug 2020 15:50:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7ADAA2075B
	for <kvmarm@archiver.kernel.org>; Fri, 28 Aug 2020 15:50:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7ADAA2075B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0AE4D4C23E;
	Fri, 28 Aug 2020 11:50:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6EIpLNm+o+lz; Fri, 28 Aug 2020 11:50:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E85D34C044;
	Fri, 28 Aug 2020 11:50:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EFED44BEC2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Aug 2020 11:50:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fRPdFPC4gc7t for <kvmarm@lists.cs.columbia.edu>;
 Fri, 28 Aug 2020 11:50:10 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C5A8F4BE44
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Aug 2020 11:50:10 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1FF9F31B;
 Fri, 28 Aug 2020 08:50:10 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 49B9D3F71F;
 Fri, 28 Aug 2020 08:50:09 -0700 (PDT)
Subject: Re: [PATCH v3 02/21] KVM: arm64: Add stand-alone page-table walker
 infrastructure
To: Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu
References: <20200825093953.26493-1-will@kernel.org>
 <20200825093953.26493-3-will@kernel.org>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <8afa26de-1839-7e5e-a324-351b241e0976@arm.com>
Date: Fri, 28 Aug 2020 16:51:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200825093953.26493-3-will@kernel.org>
Content-Language: en-US
Cc: Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
 linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>
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

Hi Will,

On 8/25/20 10:39 AM, Will Deacon wrote:
> [..]
> +static void kvm_set_table_pte(kvm_pte_t *ptep, kvm_pte_t *childp)
> +{
> +	kvm_pte_t old = *ptep, pte = kvm_phys_to_pte(__pa(childp));
> +
> +	pte |= FIELD_PREP(KVM_PTE_TYPE, KVM_PTE_TYPE_TABLE);
> +	pte |= KVM_PTE_VALID;
> +
> +	WARN_ON(kvm_pte_valid(old));
> +	smp_store_release(ptep, pte);
> +}
> +
> +static bool kvm_set_valid_leaf_pte(kvm_pte_t *ptep, u64 pa, kvm_pte_t attr,
> +				   u32 level)
> +{
> +	kvm_pte_t old = *ptep, pte = kvm_phys_to_pte(pa);
> +	u64 type = (level == KVM_PGTABLE_MAX_LEVELS - 1) ? KVM_PTE_TYPE_PAGE :
> +							   KVM_PTE_TYPE_BLOCK;
> +
> +	pte |= attr & (KVM_PTE_LEAF_ATTR_LO | KVM_PTE_LEAF_ATTR_HI);
> +	pte |= FIELD_PREP(KVM_PTE_TYPE, type);
> +	pte |= KVM_PTE_VALID;
> +
> +	/* Tolerate KVM recreating the exact same mapping. */
> +	if (kvm_pte_valid(old))
> +		return old == pte;
> +
> +	smp_store_release(ptep, pte);
> +	return true;
> +}

These two functions look inconsistent to me - we refuse to update a valid leaf
entry with a new value, but we allow updating a valid table. Is there something
that I'm not taking into account?

Thanks,

Alex

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
