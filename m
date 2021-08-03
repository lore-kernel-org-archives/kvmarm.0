Return-Path: <SRS0=p2dm=M2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF515C4338F
	for <kvmarm@archiver.kernel.org>; Tue,  3 Aug 2021 11:40:46 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 588ED60EBC
	for <kvmarm@archiver.kernel.org>; Tue,  3 Aug 2021 11:40:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 588ED60EBC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DD3F940630;
	Tue,  3 Aug 2021 07:40:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Eh1RFrbJ2xQb; Tue,  3 Aug 2021 07:40:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CEDAC406DD;
	Tue,  3 Aug 2021 07:40:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 87DD5406DD
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Aug 2021 07:40:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qrH0Puyc4DI0 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  3 Aug 2021 07:40:41 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8518440630
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Aug 2021 07:40:41 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 632C360560;
 Tue,  3 Aug 2021 11:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1627990840;
 bh=mhnDfFaIKPn448+Hzr7J/F52MA/wURi3AmBUrc9MzNU=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=Zj4llxImzKOK9cEzegvwPN2NBPwisdhtYpA1j5AgJ8D2jEE7/gxS0TS0FkuEwQZ7R
 83SUbVEhrC1tFtUyUjzK317HW/Lx3zN8wPbmV2PJzgRrcg3rcoCGLPlXJEz+rosmqt
 DZP4ohPJbT84euNBOJh0V3HCEHG6d+MoNJ85AmIpbv4kJkj1Nqt+rTS13aff3PbRO3
 O1fydtpSN8vxykjPHEOOPZ24UEbYZ887KqQHNAGuupEz/zce1hQ0G3wgSX5Mb/es5j
 zMQ7L/GUBrJ1KTbOPyz/gXqPTA10BBWKVtedXq6HjA2333Kxn/IenbeVd/Nhd+USYd
 aEULpIFx8iEiw==
Date: Tue, 3 Aug 2021 12:40:35 +0100
From: Will Deacon <will@kernel.org>
To: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v3 4/4] KVM: arm64: Clear active_vmids on vCPU schedule out
Message-ID: <20210803114034.GB30853@willie-the-truck>
References: <20210729104009.382-1-shameerali.kolothum.thodi@huawei.com>
 <20210729104009.382-5-shameerali.kolothum.thodi@huawei.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210729104009.382-5-shameerali.kolothum.thodi@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: jean-philippe@linaro.org, maz@kernel.org, linux-kernel@vger.kernel.org,
 linuxarm@huawei.com, catalin.marinas@arm.com, kvmarm@lists.cs.columbia.edu,
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
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Thu, Jul 29, 2021 at 11:40:09AM +0100, Shameer Kolothum wrote:
> Like ASID allocator, we copy the active_vmids into the
> reserved_vmids on a rollover. But it's unlikely that
> every CPU will have a=A0vCPU as current task and we may
> end up unnecessarily=A0reserving the VMID space.
> =

> Hence, clear active_vmids when scheduling out a vCPU.
> =

> Suggested-by: Will Deacon <will@kernel.org>
> Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> ---
>  arch/arm64/include/asm/kvm_host.h | 1 +
>  arch/arm64/kvm/arm.c              | 1 +
>  arch/arm64/kvm/vmid.c             | 6 ++++++
>  3 files changed, 8 insertions(+)
> =

> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/k=
vm_host.h
> index bb993bce1363..d93141cb8d16 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -687,6 +687,7 @@ extern unsigned int kvm_arm_vmid_bits;
>  int kvm_arm_vmid_alloc_init(void);
>  void kvm_arm_vmid_alloc_free(void);
>  void kvm_arm_vmid_update(struct kvm_vmid *kvm_vmid);
> +void kvm_arm_vmid_clear_active(void);
>  =

>  static inline void kvm_arm_pvtime_vcpu_init(struct kvm_vcpu_arch *vcpu_a=
rch)
>  {
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 077e55a511a9..b134a1b89c84 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -435,6 +435,7 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>  	kvm_timer_vcpu_put(vcpu);
>  	kvm_vgic_put(vcpu);
>  	kvm_vcpu_pmu_restore_host(vcpu);
> +	kvm_arm_vmid_clear_active();
>  =

>  	vcpu->cpu =3D -1;
>  }
> diff --git a/arch/arm64/kvm/vmid.c b/arch/arm64/kvm/vmid.c
> index 5584e84aed95..5fd51f5445c1 100644
> --- a/arch/arm64/kvm/vmid.c
> +++ b/arch/arm64/kvm/vmid.c
> @@ -116,6 +116,12 @@ static u64 new_vmid(struct kvm_vmid *kvm_vmid)
>  	return idx2vmid(vmid) | generation;
>  }
>  =

> +/* Call with preemption disabled */
> +void kvm_arm_vmid_clear_active(void)
> +{
> +	atomic64_set(this_cpu_ptr(&active_vmids), 0);
> +}

I think this is very broken, as it will force everybody to take the
slow-path when they see an active_vmid of 0.

It also doesn't solve the issue I mentioned before, as an active_vmid of 0
means that the reserved vmid is preserved.

Needs more thought...

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
