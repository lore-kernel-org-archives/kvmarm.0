Return-Path: <SRS0=+5+0=QF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03F14C433FE
	for <kvmarm@archiver.kernel.org>; Thu, 18 Nov 2021 13:05:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AD13A61ABA
	for <kvmarm@archiver.kernel.org>; Thu, 18 Nov 2021 13:05:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org AD13A61ABA
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 277484B1FC;
	Thu, 18 Nov 2021 08:05:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@infradead.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HiAWz17cR6BI; Thu, 18 Nov 2021 08:05:40 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5093E4B20B;
	Thu, 18 Nov 2021 08:05:21 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EDF4C4B0ED
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Nov 2021 16:10:50 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iE+aNXZdNqlY for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Nov 2021 16:10:48 -0500 (EST)
Received: from twosheds.infradead.org (twosheds.infradead.org [90.155.92.209])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6DDE74A534
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Nov 2021 16:10:48 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=twosheds.20170209; h=Content-Transfer-Encoding:
 Content-Type:MIME-Version:Cc:To:From:Subject:Date:References:In-Reply-To:
 Message-ID:Sender:Reply-To:Content-ID:Content-Description;
 bh=PY24mY1Y2geRmk7LjuGhOiKBHR3iZW7SC/NuUGtVeMM=; b=fInAvRfbXmsj2mRaAOMhBYLcLy
 rNV3j1Ejy+5tp8+gefj0Ci1K8wUw/TqCwo4phGfDDq1OEX+zE3T5+9J+WUu8XZ68WvfujlJMgRUdq
 fxcgLANbQ0bA5uHCFb8tfnVZy19nrvr3qujLNM1CEy+eRbFuppcsu+2Gu1haaPtMH2OZeBT48dIJ+
 MgZ7cnFoCPvFUVHKjy+wj1KRDU0pwv46XKxGiQF5msM9UIjM+UBm/pQusxMLzB2JKBaHEMNFaf1cY
 EwEp9WOb3Jf2IfUCshGJH9Upz2d6mUreD3M3e/7okHzoEyb/daAOFczuRJZBRtYk6sazwxlVM7FPi
 Qu9mdBIA==;
Received: from localhost ([127.0.0.1] helo=twosheds.infradead.org)
 by twosheds.infradead.org with esmtp (Exim 4.94.2 #2 (Red Hat Linux))
 id 1mnSBT-00FV0l-BJ; Wed, 17 Nov 2021 21:09:35 +0000
Received: from 2001:8b0:10b:1:d129:67c1:5868:c3aa
 (SquirrelMail authenticated user dwmw2)
 by twosheds.infradead.org with HTTP; Wed, 17 Nov 2021 21:09:35 -0000
Message-ID: <85d9fec17f32c3eb9e100e56b91af050.squirrel@twosheds.infradead.org>
In-Reply-To: <20211117174003.297096-9-dwmw2@infradead.org>
References: <20211117174003.297096-1-dwmw2@infradead.org>
 <20211117174003.297096-9-dwmw2@infradead.org>
Date: Wed, 17 Nov 2021 21:09:35 -0000
Subject: Re: [PATCH v3 08/12] KVM: Propagate vcpu explicitly to
 mark_page_dirty_in_slot()
From: "David Woodhouse" <dwmw2@infradead.org>
To: "David Woodhouse" <dwmw2@infradead.org>
User-Agent: SquirrelMail/1.4.23 [SVN]-5.fc33.20190710
MIME-Version: 1.0
X-Priority: 3 (Normal)
Importance: Normal
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by
 twosheds.infradead.org. See http://www.infradead.org/rpr.html
X-Mailman-Approved-At: Thu, 18 Nov 2021 08:05:18 -0500
Cc: Anup Patel <anup.patel@wdc.com>,
 "wanpengli @ tencent . com" <wanpengli@tencent.com>, kvm <kvm@vger.kernel.org>,
 Benjamin Herrenschmidt <benh@kernel.crashing.org>,
 Joao Martins <joao.m.martins@oracle.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-s390@vger.kernel.org,
 Michael Ellerman <mpe@ellerman.id.au>, "joro @ 8bytes . org" <joro@8bytes.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>, karahmed@amazon.com,
 Catalin Marinas <catalin.marinas@arm.com>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>,
 linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
 "jmattson @ google . com" <jmattson@google.com>,
 "mtosatti @ redhat . com" <mtosatti@redhat.com>, linux-mips@vger.kernel.org,
 kvm-riscv@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>,
 "vkuznets @ redhat . com" <vkuznets@redhat.com>, linuxppc-dev@lists.ozlabs.org
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



> From: David Woodhouse <dwmw@amazon.co.uk>
>
> The kvm_dirty_ring_get() function uses kvm_get_running_vcpu() to work out
> which dirty ring to use, but there are some use cases where that doesn't
> work.
>
> There's one in setting the Xen shared info page, introduced in commit
> 629b5348841a ("KVM: x86/xen: update wallclock region") and reported by
> "butt3rflyh4ck" <butterflyhuangxx@gmail.com> in
> https://lore.kernel.org/kvm/CAFcO6XOmoS7EacN_n6v4Txk7xL7iqRa2gABg3F7E3Naf5uG94g@mail.gmail.com/
>
> There's also about to be another one when the newly-reintroduced
> gfn_to_pfn_cache needs to mark a page as dirty from the MMU notifier
> which invalidates the mapping. In that case, we will *know* the vcpu
> that can be 'blamed' for dirtying the page, and we just need to be
> able to pass it in as an explicit argument when doing so.
>
> This patch preemptively resolves the second issue, and paves the way
> for resolving the first. A complete fix for the first issue will need
> us to switch the Xen shinfo to be owned by a particular vCPU, which
> will happen in a separate patch.
>
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>



> --- a/virt/kvm/dirty_ring.c
> +++ b/virt/kvm/dirty_ring.c
> @@ -36,12 +36,16 @@ static bool kvm_dirty_ring_full(struct kvm_dirty_ring
> *ring)
>  	return kvm_dirty_ring_used(ring) >= ring->size;
>  }
>
> -struct kvm_dirty_ring *kvm_dirty_ring_get(struct kvm *kvm)
> +struct kvm_dirty_ring *kvm_dirty_ring_get(struct kvm *kvm, struct
> kvm_vcpu *vcpu)
>  {
> -	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
> +	struct kvm_vcpu *running_vcpu = kvm_get_running_vcpu();
>
> +	WARN_ON_ONCE(vcpu && vcpu != running_vcpu);
>  	WARN_ON_ONCE(vcpu->kvm != kvm);

Ah, that one needs to be changed to check running_vcpu instead. Or this
needs to go first:

I think I prefer making the vCPU a required argument. If anyone's going to
pull a vCPU pointer out of their posterior, let the caller do it.

> +	if (!vcpu)
> +		vcpu = running_vcpu;
> +
>  	return &vcpu->dirty_ring;
>  }
>

-- 
dwmw2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
