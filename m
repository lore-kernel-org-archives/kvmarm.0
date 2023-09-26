Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA9ED1FA1
	for <kvmarm@lists.linux.dev>; Tue, 26 Sep 2023 16:37:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 094E1C433C7;
	Tue, 26 Sep 2023 16:37:52 +0000 (UTC)
Date: Tue, 26 Sep 2023 17:37:50 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	"maz@kernel.org" <maz@kernel.org>,
	"will@kernel.org" <will@kernel.org>,
	"james.morse@arm.com" <james.morse@arm.com>,
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
	yuzenghui <yuzenghui@huawei.com>, zhukeqian <zhukeqian1@huawei.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Linuxarm <linuxarm@huawei.com>
Subject: Re: [RFC PATCH v2 3/8] KVM: arm64: Add some HW_DBM related pgtable
 interfaces
Message-ID: <ZRMI3hFZm8riE4fu@arm.com>
References: <20230825093528.1637-1-shameerali.kolothum.thodi@huawei.com>
 <20230825093528.1637-4-shameerali.kolothum.thodi@huawei.com>
 <ZQ2xmzZ0H5v5wDSw@arm.com>
 <ZQ3TjMcc0FhZCR0r@linux.dev>
 <c4e12638b4874dc4809d24ce131d7b07@huawei.com>
 <ZRL2owYDvKF6gnlb@arm.com>
 <eeaa28549e22499cae2e23021832a28b@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eeaa28549e22499cae2e23021832a28b@huawei.com>

On Tue, Sep 26, 2023 at 03:52:19PM +0000, Shameerali Kolothum Thodi wrote:
> From: Catalin Marinas [mailto:catalin.marinas@arm.com]
> > On Mon, Sep 25, 2023 at 08:04:39AM +0000, Shameerali Kolothum Thodi wrote:
> > > From: Oliver Upton [mailto:oliver.upton@linux.dev]
> > > > In both cases the 'old' translation should have DBM cleared. Even if the
> > > > PTE were dirty, this is wasted work since we need to do a final scan of
> > > > the stage-2 when userspace collects the dirty log.
> > > >
> > > > Am I missing something?
> > >
> > > I think we can get rid of the above mark_page_dirty(). I will test it to confirm
> > > we are not missing anything here.
> > 
> > Is this the case for the other places of mark_page_dirty() in your
> > patches? If stage2_pte_writeable() is true, it must have been made
> > writeable earlier by a fault and the underlying page marked as dirty.
> > 
> 
> One of the other place we have mark_page_dirty() is in the stage2_unmap_walker().
> And during the testing of this series, I have tried to remove that and
> found out that it actually causes memory corruption during VM migration.
> 
> From my old debug logs:
> 
> [  399.288076]  stage2_unmap_walker+0x270/0x284
> [  399.288078]  __kvm_pgtable_walk+0x1ec/0x2cc
> [  399.288081]  __kvm_pgtable_walk+0xec/0x2cc
> [  399.288084]  __kvm_pgtable_walk+0xec/0x2cc
> [  399.288086]  kvm_pgtable_walk+0xcc/0x160
> [  399.288088]  kvm_pgtable_stage2_unmap+0x4c/0xbc
> [  399.288091]  stage2_apply_range+0xd0/0xec
> [  399.288094]  __unmap_stage2_range+0x2c/0x60
> [  399.288096]  kvm_unmap_gfn_range+0x30/0x48
> [  399.288099]  kvm_mmu_notifier_invalidate_range_start+0xe0/0x264
> [  399.288103]  __mmu_notifier_invalidate_range_start+0xa4/0x23c
> [  399.288106]  change_protection+0x638/0x900
> [  399.288109]  change_prot_numa+0x64/0xfc
> [  399.288113]  task_numa_work+0x2ac/0x450
> [  399.288117]  task_work_run+0x78/0xd0
> 
> It looks like that the unmap path gets triggered from Numa page migration code
> path, so we may need it there.

I think I confused things (should have looked at the code).
mark_page_dirty() is actually about marking the bitmap for dirty
tracking rather than the actual struct page. The latter is hidden
somewhere deep down the get_user_pages() code.

So yeah, I think we still need mark_page_dirty() in some places as to
avoid losing the dirty information with DBM being turned on.

-- 
Catalin
