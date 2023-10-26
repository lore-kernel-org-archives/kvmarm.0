Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54099C123
	for <kvmarm@lists.linux.dev>; Thu, 26 Oct 2023 08:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="LaDyRbMb"
Date: Thu, 26 Oct 2023 08:23:10 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1698308594;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vyThnddEdLJVkMZ8kXSPh+J95ZiePcRvMml5TUTrySM=;
	b=LaDyRbMbiDMFa1NhG1AW4OAaAIcTlJGUb3XM0ST4cnarYenEuicN0WHq0tS13XbP/9VInt
	BWnK9QNsi6LHy8gtJbAG25Yxy84gibCI7YsShwNXaQ/B9Flk2xHHI/0QPqrpar7D1lm8ff
	4oFXnSoVBuPkvJTmobbx2Mj7m/W7ztE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH] KVM: arm64: Stop printing about MMIO accesses where
 ISV==0
Message-ID: <ZToh7pNhz1zzQw6C@linux.dev>
References: <20231024210739.1729723-1-oliver.upton@linux.dev>
 <86il6v3z6d.wl-maz@kernel.org>
 <ZTjQ43gpJUvfh6rG@linux.dev>
 <86fs1z3xia.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86fs1z3xia.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Wed, Oct 25, 2023 at 09:41:01AM +0100, Marc Zyngier wrote:
> On Wed, 25 Oct 2023 09:25:07 +0100,
> Oliver Upton <oliver.upton@linux.dev> wrote:
> > 
> > On Wed, Oct 25, 2023 at 09:04:58AM +0100, Marc Zyngier wrote:
> > 
> > [...]
> > 
> > > While I totally agree that this *debug* statement should go, we should
> > > also replace it with something else.
> > > 
> > > Because when you're trying to debug a guest (or even KVM itself),
> > > seeing this message is a sure indication that the guest is performing
> > > an access outside of memory. The fact that KVM tries to handle it as
> > > MMIO is just an implementation artefact.
> > > 
> > > So I'd very much welcome a replacement tracepoint giving a bit more
> > > information, such as guest PC, IPA being accessed, load or store. With
> > > that, everybody wins.
> > 
> > Aren't we already covered by the kvm_guest_fault tracepoint? Userspace
> > can filter events on ESR to get the faults it cares about. I'm not
> > against adding another tracepoint, but in my experience kvm_guest_fault
> > has been rather useful for debugging any type of guest fault.
> 
> That tracepoint is one of the most triggered, and sifting through this
> is a painful experience. If we go down that road, adding a bit of
> extra documentation (pointed to from the KVM_RUN entry) and an example
> filter script would be most useful.

Eh, I'd rather write kernel code than documentation, and I think you
knew that too ;-)

How do you feel about this:

diff --git a/arch/arm64/kvm/mmio.c b/arch/arm64/kvm/mmio.c
index 3dd38a151d2a..200c8019a82a 100644
--- a/arch/arm64/kvm/mmio.c
+++ b/arch/arm64/kvm/mmio.c
@@ -135,6 +135,9 @@ int io_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
 	 * volunteered to do so, and bail out otherwise.
 	 */
 	if (!kvm_vcpu_dabt_isvalid(vcpu)) {
+		trace_kvm_mmio_nisv(*vcpu_pc(vcpu), kvm_vcpu_get_esr(vcpu),
+				    kvm_vcpu_get_hfar(vcpu), fault_ipa);
+
 		if (test_bit(KVM_ARCH_FLAG_RETURN_NISV_IO_ABORT_TO_USER,
 			     &vcpu->kvm->arch.flags)) {
 			run->exit_reason = KVM_EXIT_ARM_NISV;
@@ -143,7 +146,6 @@ int io_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
 			return 0;
 		}
 
-		kvm_pr_unimpl("Data abort outside memslots with no valid syndrome info\n");
 		return -ENOSYS;
 	}
 
diff --git a/arch/arm64/kvm/trace_arm.h b/arch/arm64/kvm/trace_arm.h
index 8ad53104934d..c18c1a95831e 100644
--- a/arch/arm64/kvm/trace_arm.h
+++ b/arch/arm64/kvm/trace_arm.h
@@ -136,6 +136,31 @@ TRACE_EVENT(kvm_mmio_emulate,
 		  __entry->vcpu_pc, __entry->instr, __entry->cpsr)
 );
 
+TRACE_EVENT(kvm_mmio_nisv,
+	TP_PROTO(unsigned long vcpu_pc, unsigned long esr,
+		 unsigned long far, unsigned long ipa),
+	TP_ARGS(vcpu_pc, esr, far, ipa),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long,	vcpu_pc		)
+		__field(	unsigned long,	esr		)
+		__field(	unsigned long,	far		)
+		__field(	unsigned long,	ipa		)
+	),
+
+	TP_fast_assign(
+		__entry->vcpu_pc		= vcpu_pc;
+		__entry->esr			= esr;
+		__entry->far			= far;
+		__entry->ipa			= ipa;
+	),
+
+	TP_printk("ipa %#016lx, esr %#016lx, far %#016lx, pc %#016lx",
+		  __entry->ipa, __entry->esr,
+		  __entry->far, __entry->vcpu_pc)
+);
+
+
 TRACE_EVENT(kvm_set_way_flush,
 	    TP_PROTO(unsigned long vcpu_pc, bool cache),
 	    TP_ARGS(vcpu_pc, cache),

-- 
Thanks,
Oliver
