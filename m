Return-Path: <SRS0=wPN+=FL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02AA5C433FE
	for <kvmarm@archiver.kernel.org>; Mon,  7 Dec 2020 13:41:05 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5803723437
	for <kvmarm@archiver.kernel.org>; Mon,  7 Dec 2020 13:41:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5803723437
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9E29C4B299;
	Mon,  7 Dec 2020 08:41:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YEBcGnYvX+eV; Mon,  7 Dec 2020 08:41:02 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7EF834B277;
	Mon,  7 Dec 2020 08:41:02 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CAD7F4B27B
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Dec 2020 08:41:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2bV9wIShXkUS for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Dec 2020 08:40:59 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B0EB84B276
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Dec 2020 08:40:59 -0500 (EST)
Date: Mon, 7 Dec 2020 13:40:52 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1607348458;
 bh=Wi5SMyGM9uyVoSdAy74aJh2UMPtwUKtUU8CMK6gezcY=;
 h=From:To:Cc:Subject:References:In-Reply-To:From;
 b=n1w8OR/NmXAqtAa8TG0UjI7ivuFVDdh99zrbuXxuXdjaJj31CB7VBLOirM/bAJS89
 xZI/TZofhOEFLT6hz7Bk9ZaQRideoWzX2+ceTsmxQgkWdvi87rbOTrMpCMx+kCBXu8
 ohFnUg0gTLdgsT+hsR7Ld4Udy3oVEjXZQIZ8gydCMrLFbfTOkd6pZuZkfxQay6joup
 itjjEC/PMT5kDwTSX3fvlmV8E+DjjuptXAA/gVhFZu/ndKJH5USQFbUN5ZC6zMNDVw
 KG3BYjdAXn9UQ7OyFx2gj1KuApgM81+6T38W6F5JY/+flBam8HAwROhu0ndJP40J/d
 PX1/VsdBJSkug==
From: Will Deacon <will@kernel.org>
To: Quentin Perret <qperret@google.com>
Subject: Re: [RFC PATCH 16/27] KVM: arm64: Prepare Hyp memory protection
Message-ID: <20201207134052.GA4563@willie-the-truck>
References: <20201117181607.1761516-1-qperret@google.com>
 <20201117181607.1761516-17-qperret@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20201117181607.1761516-17-qperret@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE"
 <devicetree@vger.kernel.org>, kernel-team@android.com, android-kvm@google.com,
 Catalin Marinas <catalin.marinas@arm.com>,
 open list <linux-kernel@vger.kernel.org>, Rob Herring <robh+dt@kernel.org>,
 "moderated list:ARM64 PORT \(AARCH64 ARCHITECTURE\)"
 <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <maz@kernel.org>,
 Frank Rowand <frowand.list@gmail.com>,
 "open list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <kvmarm@lists.cs.columbia.edu>
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

Hi Quentin,

On Tue, Nov 17, 2020 at 06:15:56PM +0000, Quentin Perret wrote:
> When memory protection is enabled, the Hyp code needs the ability to
> create and manage its own page-table. To do so, introduce a new set of
> hypercalls to initialize Hyp memory protection.
> 
> During the init hcall, the hypervisor runs with the host-provided
> page-table and uses the trivial early page allocator to create its own
> set of page-tables, using a memory pool that was donated by the host.
> Specifically, the hypervisor creates its own mappings for __hyp_text,
> the Hyp memory pool, the __hyp_bss, the portion of hyp_vmemmap
> corresponding to the Hyp pool, among other things. It then jumps back in
> the idmap page, switches to use the newly-created pgd (instead of the
> temporary one provided by the host) and then installs the full-fledged
> buddy allocator which will then be the only one in used from then on.
> 
> Note that for the sake of symplifying the review, this only introduces
> the code doing this operation, without actually being called by anyhing
> yet. This will be done in a subsequent patch, which will introduce the
> necessary host kernel changes.

[...]

> diff --git a/arch/arm64/kvm/hyp/reserved_mem.c b/arch/arm64/kvm/hyp/reserved_mem.c
> new file mode 100644
> index 000000000000..02b0b18006f5
> --- /dev/null
> +++ b/arch/arm64/kvm/hyp/reserved_mem.c

[...]

> +extern bool enable_protected_kvm;
> +void __init reserve_kvm_hyp(void)
> +{
> +	u64 nr_pages, prev;
> +
> +	if (!enable_protected_kvm)
> +		return;
> +
> +	if (!is_hyp_mode_available() || is_kernel_in_hyp_mode())
> +		return;
> +
> +	if (kvm_nvhe_sym(hyp_memblock_nr) <= 0)
> +		return;
> +
> +	hyp_mem_size += num_possible_cpus() << PAGE_SHIFT;
> +	hyp_mem_size += hyp_s1_pgtable_size();
> +
> +	/*
> +	 * The hyp_vmemmap needs to be backed by pages, but these pages
> +	 * themselves need to be present in the vmemmap, so compute the number
> +	 * of pages needed by looking for a fixed point.
> +	 */
> +	nr_pages = 0;
> +	do {
> +		prev = nr_pages;
> +		nr_pages = (hyp_mem_size >> PAGE_SHIFT) + prev;
> +		nr_pages = DIV_ROUND_UP(nr_pages * sizeof(struct hyp_page), PAGE_SIZE);
> +		nr_pages += __hyp_pgtable_max_pages(nr_pages);
> +	} while (nr_pages != prev);
> +	hyp_mem_size += nr_pages << PAGE_SHIFT;
> +
> +	hyp_mem_base = memblock_find_in_range(0, memblock_end_of_DRAM(),
> +					      hyp_mem_size, SZ_2M);
> +	if (!hyp_mem_base) {
> +		kvm_err("Failed to reserve hyp memory\n");
> +		return;
> +	}
> +	memblock_reserve(hyp_mem_base, hyp_mem_size);

Why not use the RESERVEDMEM_OF_DECLARE() interface for the hypervisor
memory? That way, the hypervisor memory can either be statically partitioned
as a carveout or allocated dynamically for us -- we wouldn't need to care.

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
