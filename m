Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89A7147424A
	for <kvmarm@lists.linux.dev>; Wed,  2 Sep 2026 10:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788346458; cv=none; b=Ra04qQC6ncy/TOy8wAAsbd38IOu62jxgLi8X3VBzBnntc+IYJ9oTiDTmRXaEJg9PbnTo9SCM7HayKrsUSiKn6WiluJXjOwFutq5G1BtQeM0R4t3fuZ1S+CWcjUoflVrVB+mSjLtEzahse2K3aPObNMIUF6QBPgLE4BTTVXd6aZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788346458; c=relaxed/simple;
	bh=VJhrLZI3tnfJzyrU+XBx+aRk7G0SRkdsT882fdzqnGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=ffVblfEDO/B44ufJK7ikdw49KGrOBnB2Kn7v5w653PyOunowsjhkfEkeaf9njrOrRYPx8hSoDiXBU5pKTwjjHQkHRxtM3AH3uA+Z1yUH5idE0tLudt2aAfb5CYYddp9mhcu0YUy7Yizy2nHWPkDgXFe+HSUDfJCF9VqNA1lNeJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=tJZtD3zg; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="tJZtD3zg"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BBDA0165C;
	Wed,  2 Sep 2026 03:54:06 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8553D3F8C6;
	Wed,  2 Sep 2026 03:54:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788346450; bh=VJhrLZI3tnfJzyrU+XBx+aRk7G0SRkdsT882fdzqnGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tJZtD3zgqQnEuGfs/67Yd+ZWlPXHjKoMT0U3ZR57dmGKpRUmMuHF1P6DufUHsQDhc
	 dE9KFKVVLrberz98boWoi5FfokmKbRPvi0j9drfEMvYknfwXCrjP9H//8pt77gtBVH
	 G65T8aXCLl88anRM8TxQgiUP5PGq5sbzBdls3yFI=
From: Leonardo Bras <leo.bras@arm.com>
To: Tian Zheng <zhengtian10@huawei.com>
Cc: Leonardo Bras <leo.bras@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 4/5] KVM: arm64: Add KVM_REQ_RELOAD_STAGE2
Date: Wed,  2 Sep 2026 11:53:55 +0100
Message-ID: <apgAQ8p3hkGItkYK@LeoBrasDK>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <c8a6b6ac-aa4a-4cbc-b4f0-8dd6f4f02341@huawei.com>
References: <20260901171558.2674031-1-leo.bras@arm.com> <20260901171558.2674031-5-leo.bras@arm.com> <c8a6b6ac-aa4a-4cbc-b4f0-8dd6f4f02341@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Wed, Sep 02, 2026 at 11:41:39AM +0800, Tian Zheng wrote:
> 
> 
> On 9/2/2026 1:15 AM, Leonardo Bras wrote:
> > Add a vcpu request to exit guest, reload Stage2, and then come back to
> > guest.
> > 
> > This will be used on future patches that enable S2 HAFDBS and HDBSS, as
> > they may need to change VTCR bits for enabling/disabling the feature when
> > the vcpus are still running.
> > 
> > Signed-off-by: Leonardo Bras <leo.bras@arm.com>
> > ---
> >   arch/arm64/include/asm/kvm_host.h | 2 ++
> >   arch/arm64/kvm/arm.c              | 8 ++++++++
> >   2 files changed, 10 insertions(+)
> > 
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index 27fe0cd5b2d7..00fe169f239f 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -48,20 +48,22 @@
> >   #define KVM_REQ_VCPU_RESET		KVM_ARCH_REQ(2)
> >   #define KVM_REQ_RECORD_STEAL		KVM_ARCH_REQ(3)
> >   #define KVM_REQ_RELOAD_GICv4		KVM_ARCH_REQ(4)
> >   #define KVM_REQ_RELOAD_PMU		KVM_ARCH_REQ(5)
> >   #define KVM_REQ_SUSPEND			KVM_ARCH_REQ(6)
> >   #define KVM_REQ_RESYNC_PMU_EL0		KVM_ARCH_REQ(7)
> >   #define KVM_REQ_NESTED_S2_UNMAP		KVM_ARCH_REQ(8)
> >   #define KVM_REQ_GUEST_HYP_IRQ_PENDING	KVM_ARCH_REQ(9)
> >   #define KVM_REQ_MAP_L1_VNCR_EL2		KVM_ARCH_REQ(10)
> >   #define KVM_REQ_VGIC_PROCESS_UPDATE	KVM_ARCH_REQ(11)
> > +#define KVM_REQ_RELOAD_STAGE2 \
> > +	KVM_ARCH_REQ_FLAGS(12, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
> >   #define KVM_DIRTY_LOG_MANUAL_CAPS   (KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE | \
> >   				     KVM_DIRTY_LOG_INITIALLY_SET)
> >   #define KVM_HAVE_MMU_RWLOCK
> >   /*
> >    * Mode of operation configurable with kvm-arm.mode early param.
> >    * See Documentation/admin-guide/kernel-parameters.txt for more information.
> >    */
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index 8b080804bc90..1e528d53d093 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -1164,20 +1164,28 @@ static int check_vcpu_requests(struct kvm_vcpu *vcpu)
> >   		if (kvm_check_request(KVM_REQ_RESYNC_PMU_EL0, vcpu))
> >   			kvm_vcpu_pmu_restore_guest(vcpu);
> >   		if (kvm_check_request(KVM_REQ_SUSPEND, vcpu))
> >   			return kvm_vcpu_suspend(vcpu);
> >   		if (kvm_dirty_ring_check_request(vcpu))
> >   			return 0;
> > +		if (kvm_check_request(KVM_REQ_RELOAD_STAGE2, vcpu)) {
> > +			unsigned long flags;
> > +
> > +			local_irq_save(flags);
> > +			__load_stage2(vcpu->arch.hw_mmu);
> > +			local_irq_restore(flags);
> > +		}
> > +
> >   		check_nested_vcpu_requests(vcpu);
> >   	}
> >   	return 1;
> >   }
> >   static bool vcpu_mode_is_bad_32bit(struct kvm_vcpu *vcpu)
> >   {
> >   	if (likely(!vcpu_mode_is_32bit(vcpu)))
> >   		return false;
> Hi Leo,
> 
> Thanks for sending this out. I actually implemented a similar request in
> my v5 HDBSS series to reload VTCR on enable/disable, but I named it
> KVM_REQ_HDBSS_RELOAD_VTCR.
> 
> Without such a request, the new VTCR value only takes effect on the next
> vcpu_load, which means enable/disable could be delayed indefinitely if
> the vCPU never goes through a load/put cycle. So I think this request is
> necessary for HDBSS as well.
> 
> Since your KVM_REQ_RELOAD_STAGE2 is more generic, I'd like to rebase on
> top of your patch and reuse it in v5. Would that work for you? Or do you
> prefer to keep them separate for now?
> 

Hi Tian, 
Thanks for reviewing!

The main reason for this patch series (at least up to patch #3) was to give 
you a base for HDBSS, so please rebase as much as you want on top of it.

Thanks!
Leo
