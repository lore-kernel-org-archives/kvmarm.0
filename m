Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 228A13321DC
	for <kvmarm@lists.linux.dev>; Mon, 15 Dec 2025 15:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765811854; cv=none; b=OpJzctRGRxZ0sfHOXNPscx6zqb0gakkmLnNc2mx3xhh56O5LegJr97ac05cRfbUm/glkw0HSUbpnqEQlCp9mZiZpoLbBDyM8by+B7F0NHPdQG/6u+wnuJBa3TNIRvf8ZijkzAb8ms2PLbpQ140DWBKz91bJ/2iehEmCFVpFeE9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765811854; c=relaxed/simple;
	bh=d/adGWngjmh3KY5aNcQJ7lGK40Id0jPxuSQbr8vZHI8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FA/cFCUXNXfpzcLxaOJWhJnq1G/ZVk0VWuD1rDYN+B5a5WQDMTO1dKTyqeuu4Q4LGsde47rv2Haud4Rx1DdHQzw9wB5n6qOobd2F51c0QzacgpchS3pUiMaCsT3b2a6ENRa0ehvMyBWFm9te4R6DixYmMUF5aQVIIIDatmqXu9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5CEB4497;
	Mon, 15 Dec 2025 07:17:24 -0800 (PST)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id ECE5A3F73B;
	Mon, 15 Dec 2025 07:17:29 -0800 (PST)
Date: Mon, 15 Dec 2025 15:17:27 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: oupton@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, qperret@google.com, will@kernel.org,
	tabba@google.com, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH v2 2/4] KVM: arm64: Print register encoding if there's no
 accessor
Message-ID: <aUAmh32jCUOWMg8K@raptor>
References: <20251215114409.212512-1-alexandru.elisei@arm.com>
 <20251215114409.212512-3-alexandru.elisei@arm.com>
 <86ike7onhr.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86ike7onhr.wl-maz@kernel.org>

Hi Marc,

On Mon, Dec 15, 2025 at 01:58:40PM +0000, Marc Zyngier wrote:
> On Mon, 15 Dec 2025 11:44:07 +0000,
> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
> > 
> > Configuring a register trap without specifying an accessor function is
> > abviously a bug. Instead of calling die() when that happens, let's be a bit
> > more helpful and print the register encoding and kill the virtual machine
> > instead.
> > 
> > Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> > ---
> >  arch/arm64/kvm/sys_regs.c | 8 +++++++-
> >  1 file changed, 7 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index c8fd7c6a12a1..d669f6fef177 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -4668,7 +4668,13 @@ static void perform_access(struct kvm_vcpu *vcpu,
> >  	 * that we don't know how to handle. This certainly qualifies
> >  	 * as a gross bug that should be fixed right away.
> >  	 */
> > -	BUG_ON(!r->access);
> > +	if (!r->access) {
> > +		KVM_BUG(1, vcpu->kvm,
> > +			"Unexpected access to register: { Op0(%2u), Op1(%2u), CRn(%2u), CRm(%2u), Op2(%2u) } (%s)",
> > +			params->Op0, params->Op1, params->CRn, params->CRm, params->Op2,
> > +			str_write_read(params->is_write));
> > +		return;
> > +	}
> 
> Why not writing
> 
> 	if (KVM_BUG(!r>access, ...))
> 		return;
> 
> instead? And you could reuse the format that's already defined in
> print_sys_reg_msg().
> 
> You could instead consider injecting an UNDEF in the guest, which I

Injecting an undefined instruction exception early in the boot process can lead
to an infinite loop of undefined instruction exceptions in the guest. This is
what happens for the unhandled PIRE0_EL1 trap that the previous patch fixes. The
guest access takes place in __cpu_setup(), when there are no vectors installed.

If you're ok with this, I can move forward with the below:

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index c8fd7c6a12a1..516072417649 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -4668,7 +4668,10 @@ static void perform_access(struct kvm_vcpu *vcpu,
         * that we don't know how to handle. This certainly qualifies
         * as a gross bug that should be fixed right away.
         */
-       BUG_ON(!r->access);
+       if (!r->access) {
+               bad_trap(vcpu, params, r, "Unexpected register access");
+               return;
+       }

        /* Skip instruction if instructed so */
        if (likely(r->access(vcpu, params, r)))

And this is what KVM prints (the register encoding is outside the trace snippet,
if you think that would make a difference to the end user):

[ 4926.964472] ------------[ cut here ]------------
[ 4926.964529] Unexpected Unexpected register access
[ 4926.964713] WARNING: arch/arm64/kvm/sys_regs.c:64 at bad_trap.isra.0+0x70/0x7c, CPU#5: kvm-vcpu-0/179
[ 4926.965014] Modules linked in:
[ 4926.965097] CPU: 5 UID: 0 PID: 179 Comm: kvm-vcpu-0 Not tainted 6.19.0-rc1-dirty #85 PREEMPT
[ 4926.965240] Hardware name: FVP Base RevC (DT)
[ 4926.965316] pstate: 63402005 (nZCv daif +PAN -UAO +TCO +DIT -SSBS BTYPE=--)
[ 4926.965442] pc : bad_trap.isra.0+0x70/0x7c
[ 4926.965564] lr : bad_trap.isra.0+0x70/0x7c
[ 4926.965687] sp : ffff800080be39f0
[ 4926.965760] x29: ffff800080be39f0 x28: ffff0008031e2dc0 x27: 0000000000000000
[ 4926.965943] x26: 0000000000000000 x25: 0000000000000000 x24: 000000000000ae80
[ 4926.966124] x23: ffff000800b78048 x22: ffff00080164c9c0 x21: ffff0008031e2dc0
[ 4926.966314] x20: ffff000800b78000 x19: ffff000800b78000 x18: ffffffffff00b468
[ 4926.966506] x17: 0000000000000000 x16: 0000000000000000 x15: ffffa991688ee120
[ 4926.966689] x14: fffffffffe00b467 x13: 0000000000001408 x12: 0000000000001470
[ 4926.966874] x11: 0000000000000058 x10: 0000000000000018 x9 : ffff000875334bc0
[ 4926.967058] x8 : 0000000002bfffa8 x7 : 0000000000000081 x6 : ffff000877f34bc0
[ 4926.967241] x5 : 0000000000000081 x4 : ffffa991674022a8 x3 : 0000000000000001
[ 4926.967423] x2 : 0000000000000000 x1 : 0000000000000000 x0 : ffff0008031e2dc0
[ 4926.967605] Call trace:
[ 4926.967664]  bad_trap.isra.0+0x70/0x7c (P)
[ 4926.967805]  perform_access+0xcc/0xd8
[ 4926.967943]  kvm_handle_sys_reg+0x100/0x170
[ 4926.968068]  handle_exit+0x58/0x168
[ 4926.968187]  kvm_arch_vcpu_ioctl_run+0x2f8/0x900
[ 4926.968336]  kvm_vcpu_ioctl+0x168/0xa18
[ 4926.968479]  __arm64_sys_ioctl+0x2ec/0xaf4
[ 4926.968599]  invoke_syscall.constprop.0+0x48/0xc8
[ 4926.968758]  do_el0_svc+0x3c/0xb8
[ 4926.968903]  el0_svc+0x3c/0x160
[ 4926.969014]  el0t_64_sync_handler+0xa0/0xe4
[ 4926.969137]  el0t_64_sync+0x198/0x19c
[ 4926.969255] ---[ end trace 0000000000000000 ]---
[ 4926.969427] kvm [166]:  { Op0( 3), Op1( 0), CRn(10), CRm( 2), Op2( 2), func_write },

Thanks,
Alex
