Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5999C43334
	for <kvmarm@archiver.kernel.org>; Wed, 20 Jul 2022 18:26:35 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 32EDE4CAB9;
	Wed, 20 Jul 2022 14:26:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2O-i6vjEj0Qx; Wed, 20 Jul 2022 14:26:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 248C64CB68;
	Wed, 20 Jul 2022 14:26:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B6C54CA53
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Jul 2022 14:26:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Hecz+1ZJWeJd for <kvmarm@lists.cs.columbia.edu>;
 Wed, 20 Jul 2022 14:26:32 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 425E04CAB8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Jul 2022 14:26:32 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id AADCCB821B3;
 Wed, 20 Jul 2022 18:26:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95BF8C3411E;
 Wed, 20 Jul 2022 18:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1658341589;
 bh=1yszCxwggYM4jJ5bah2lLB5C4oXcdYdLEA0qjz82pAc=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=oR4ERFNR2+UVNBGGeoTFnTaaCoPW3ezYofdRY1WsECL0Og0X17PdO1j0IAic6PNq5
 lJXxMQwcuoogN6wkbeKDDAQuLpOsE+SZ4tFcT3te+BcQgJhc6wHJTogCdJZo9nKUJk
 FW9C8rCPvo7x8jejTULVSWM1gaVZn0q26kV8aU4T7Z66BeV8CSNP6cUtus08KsLEgu
 MlPCJ3a0VNYYRuJ047pHFQ8xUWMY01bSxut7tt6Pzi0uCX+M5v6GeYfmW+U6rVC2NV
 lsb8AY9f93HbEauX8FpWAvrwXY9hkNj3Kbyuu0ip4sdoTQFLFlNCSf6ovWVFx0Fvce
 aiqLRl8JfZIcQ==
Date: Wed, 20 Jul 2022 19:26:22 +0100
From: Will Deacon <will@kernel.org>
To: Vincent Donnefort <vdonnefort@google.com>
Subject: Re: [PATCH v2 18/24] KVM: arm64: Instantiate guest stage-2
 page-tables at EL2
Message-ID: <20220720182621.GC16603@willie-the-truck>
References: <20220630135747.26983-1-will@kernel.org>
 <20220630135747.26983-19-will@kernel.org>
 <YtayYuo2qBplXcdi@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <YtayYuo2qBplXcdi@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: Marc Zyngier <maz@kernel.org>, kernel-team@android.com, kvm@vger.kernel.org,
 Oliver Upton <oliver.upton@linux.dev>, Andy Lutomirski <luto@amacapital.net>,
 linux-arm-kernel@lists.infradead.org, Michael Roth <michael.roth@amd.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Chao Peng <chao.p.peng@linux.intel.com>, kvmarm@lists.cs.columbia.edu
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

On Tue, Jul 19, 2022 at 02:32:18PM +0100, Vincent Donnefort wrote:
> [...]
> 
> >  }
> >  
> >  void reclaim_guest_pages(struct kvm_shadow_vm *vm)
> >  {
> > -	unsigned long nr_pages;
> > +	unsigned long nr_pages, pfn;
> >  
> >  	nr_pages = kvm_pgtable_stage2_pgd_size(vm->kvm.arch.vtcr) >> PAGE_SHIFT;
> > -	WARN_ON(__pkvm_hyp_donate_host(hyp_virt_to_pfn(vm->pgt.pgd), nr_pages));
> > +	pfn = hyp_virt_to_pfn(vm->pgt.pgd);
> > +
> > +	guest_lock_component(vm);
> > +	kvm_pgtable_stage2_destroy(&vm->pgt);
> > +	vm->kvm.arch.mmu.pgd_phys = 0ULL;
> > +	guest_unlock_component(vm);
> > +
> > +	WARN_ON(__pkvm_hyp_donate_host(pfn, nr_pages));
> >  }
> 
> The pfn introduction being removed in a subsequent patch, this is probably
> unecessary noise.

Quite right, that should be left as-is. Will fix.

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
