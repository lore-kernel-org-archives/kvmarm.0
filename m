Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795076305;
	b=331vaL5KLaQhm+sOuIF1zNlgcuU1oECdR0RzEBOBU3CmW4qPy0zslLdP8iSr68cYbdQU
	 XkViOSBlJgxdLHGnaE+TP9U36PmgNb5npICsFdK1e0I2xl14u7ZLZIsw9+Fy+RtwcrVC2
	 X8drb3GZ2WwVV/8twgTqWPnWImecrG6bpEvOms40bvKjBpGaw/4OwHhjCjOKcjF2XI3o8
	 2ROrHF2FdsKAJ+rCOkHreD1RTQUthqz83NXtebOOVUhWDfjbbGq6RhaT+SK3hIIXZGkwB
	 J79MPI6loHHQttzApJX5oCGpTA0oNTL574TwV/UTtkvH9F8wa3JYz/NmSCH7x31yEKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795076305;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=fN32snRSV36lEFPD1aw7PskPfU8Y7+zoH5BNPUXA4wM=;
	b=phnuKa9yOyYogd4/Qexbfpwkzzy235iklbH5ayY+VklNzue6kh8YZ+rDwWfXm6atj3w5
	 AduEYUhR7XbIoWkybsBYFzrGdDNVH9AgL0D9QTbXPSqD0H2F7fIgxhYmEBHl4AO5Lufeu
	 pGjFZMYSWypruUpX2C3Lh7dU8S27LgsGaz7iNyUdpxuo+SZoBm8rluj4wGABcITCz7wjD
	 DX4rq+uM+R7PVIM6oE9NUnejRcu7XjYvL+zw67K4eiMRkvG4gAFKaEIexdWFKCrgP2auN
	 ws3wz7ltWs3IIj4br3k/8t9zTmvKQh+zI+qrjXcR+F8yFp19y4gKibpzUsTa96P7vGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=pereq.eu;
	spf=pass smtp.mailfrom=cryspen.com;
	dkim=pass header.d=pereq.eu header.i=@pereq.eu header.a=rsa-sha256 header.s=google header.b=DD+hejfA;
	arc=none smtp.remote-ip=209.85.128.47
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49DF6606A320
	for <kvmarm@lists.linux.dev>; Thu, 19 Nov 2026 08:18:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 49DF6606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pereq.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cryspen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pereq.eu header.i=@pereq.eu header.a=rsa-sha256 header.s=google header.b=DD+hejfA
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4a2d6d01ecbso11813335e9.0
        for <kvmarm@lists.linux.dev>; Thu, 19 Nov 2026 00:18:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pereq.eu; s=google; t=1795076303; x=1795681103; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=fN32snRSV36lEFPD1aw7PskPfU8Y7+zoH5BNPUXA4wM=;
        b=DD+hejfA2jGqwD9Z8nSuNcgCX0xz8MWC89+eZzM40NQ304e6j9PxBSuVMXZzJSOAru
         6QxgIsCgcwr+/rQVSLQVGc6gJxv8kVKcsoQCAVtTj9Otsilkv3UgIRdveE2aeDSW59d0
         e5LmcsP4bpOoTpPWKMcCNLa3llkJtelx6WHjrgknpN7+qfYJfghPo1TDMVbJsL26gA+Z
         lL3QTj6O+ZsxXMKG6A+/g20DNMTvkbgSktzC8q/gel6gCV2OSuvRz4HeO9dk3fLf+jfW
         V06I13cokic71XgxfC1z/ylqINGX9NKNZn4C3hrBGOMqg7ls3wxTgLAuE50Rd5+fc/wI
         FI4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795076303; x=1795681103;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fN32snRSV36lEFPD1aw7PskPfU8Y7+zoH5BNPUXA4wM=;
        b=D6Tc1n/mtOF/3O2znY3EIkaOgIq33s26Se0TVs5CxUjrX/0ScMjKAzg1ssejRGBLNk
         m8LafZr74c9XvSlwzDl7BFuX/E7WLR5jF/1ebCt1K1QP01bvWos/lkM45lREHNFlzWqF
         C9PqGeY6A/AcO3+Uf/BddSYcnKz5lWlj6lRMLSz4E6Y87Z9Xq1kzcN2cf/IjmXhvkZLn
         IkkjPuiPPK+kk47Sl0sVh1ki58hocPAbr+4RgRajqMCl1htsvWxrtWjaMP7QENEr0UYV
         /9wy7VlZgpopHCP5jlqNVwDQ4IPtfDwLfn5S2w6LQPkcfEuD0ZX2r4C4Ta6mYw0QgfmX
         XTLg==
X-Forwarded-Encrypted: i=1; AL+hErHM+QXQUxwNi11tHaYEvfBHweyVhfgLR4wAvfT0ghpZGtqROvBPDkyObUELyVSgGGQLGI4J5eg=@lists.linux.dev
X-Gm-Message-State: APuU4Z9hokFu+k8MSNOQeqlS3444jeAtVm5k35orwewK+na844EAygax
	YzYJfpn1pRXLeajgY0MWRil2D2SIuIaci1i/opPnxM1tHSpqtRz5Ky/DsH1fG1W4JTA=
X-Gm-Gg: AYBFou0R9p37P/Vpm72umGhk3adldIP0GT0mgsC/yIMxVncvYlzXiHctcHmo107LnM0
	ehWyCAEpaPVV8Cqhr/t56S1OGKhulI/lXqC2/Aa0wZD1ERZ+c6PYYDzDJOW9iYdhz0c/YG3aMpD
	mJsp4q1dmpJ2O85Iwb2yVi0Ck7b3wMwVfi2HDYqZyHBFlJ+xe9+x1BICzCBU6a4h2YgOybowpgN
	5C3Aicx0nrR5N0dtc/ZUrQiG9rqogNsfauUnNDQM4n8lyTs9K+RmXjfq1mQ8dajDmk/v8xmT6WX
	7OYADpXiJRtPjJQlAmSN9epOOXN0YgRkYZpHDHOe4rssLOA5GiWOmRpBUF1BHM4gqotZ26b1Bzb
	klAU/YwtuzEOk9zwb0m2aR2Qun8cCdnMimuUTctQ0y8xXiVtKmG1/Z8511sDM3fKWgHIepER7EP
	w19e6VtJdBfh7Q/5KJBxbujBGvI5FzVQeUmD0PfctWDFmrunp5s7rdTCzOjVt3xvpUugkggSsBQ
	wsYSZz0KdJoH1UEM92oV0ipbSk+Qc7qut3L48zeUhjoGb8oR7p5LVfM9sy2G3M2lEqirI+sj630
	0tv/fmF0U8hSHt7bbloqwSxuGW3PdLmAsy7xCnX9
X-Received: by 2002:a05:600c:4e4d:b0:4bb:69b2:d3df with SMTP id 5b1f17b1804b1-4bb7da362e1mr102872455e9.25.1795076303220;
        Thu, 19 Nov 2026 00:18:23 -0800 (PST)
Received: from localhost ([2c0f:3d00:6be:8900:ce5e:9212:ea4b:f30])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb85399e2esm22139735e9.7.2026.11.19.00.18.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2026 00:18:22 -0800 (PST)
Date: Thu, 19 Nov 2026 11:18:18 +0300
From: Dan Carpenter <dan@pereq.eu>
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev,
	sashiko-reviews@lists.linux.dev
Subject: Re: [PATCH v2 1/2] KVM: arm64: Load the vcpu in KVM_SET_VCPU_EVENTS
Message-ID: <av6wypzwAJxIyKOU@stanley.mountain>
References: <cover.1795006659.git.dan@pereq.eu>
 <033a2d49e0f48426281b46eb1131ae64012aba18.1795006659.git.dan@pereq.eu>
 <sashiko-outbox-221074@kernel.org>
 <86zev6yqzd.wl-maz@kernel.org>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="SiI1FD/O0lCfvQZp"
Content-Disposition: inline
In-Reply-To: <86zev6yqzd.wl-maz@kernel.org>

--SiI1FD/O0lCfvQZp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 18, 2026 at 05:44:06PM +0000, Marc Zyngier wrote:
> On Wed, 18 Nov 2026 13:45:34 +0000,
> sashiko-bot@kernel.org wrote:
> > 
> > Thank you for your contribution! Sashiko AI review found 1 potential
> > issue to consider:
> > - [Medium] KVM: arm64: stale mmio_needed after kvm_inject_nested() in
> >   KVM_SET_VCPU_EVENTS
> > --
> > 
> > commit 178d0de7451612b8ddf14a943cb82094efbd77d1
> > Author: Dan Carpenter <dan@pereq.eu>
> > 
> > KVM: arm64: Load the vcpu in KVM_SET_VCPU_EVENTS
> > 
> > This commit wraps __kvm_arm_vcpu_set_events() in vcpu_load() and vcpu_put()
> > so that kvm_inject_nested() operates on a loaded vCPU during
> > KVM_SET_VCPU_EVENTS.
> > 
> > > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > > index 84a52e27ed859..a148e80d0aef7 100644
> > > --- a/arch/arm64/kvm/arm.c
> > > +++ b/arch/arm64/kvm/arm.c
> > > @@ -2002,7 +2002,7 @@ static int kvm_arm_vcpu_get_events(struct kvm_vcpu *vcpu,
> > >  static int kvm_arm_vcpu_set_events(struct kvm_vcpu *vcpu,
> > >  				   struct kvm_vcpu_events *events)
> > >  {
> > > -	int i;
> > > +	int i, ret;
> > >  
> > >  	/* check whether the reserved field is zero */
> > >  	for (i = 0; i < ARRAY_SIZE(events->reserved); i++)
> > > @@ -2014,7 +2014,11 @@ static int kvm_arm_vcpu_set_events(struct kvm_vcpu *vcpu,
> > >  		if (events->exception.pad[i])
> > >  			return -EINVAL;
> > >  
> > > -	return __kvm_arm_vcpu_set_events(vcpu, events);
> > > +	vcpu_load(vcpu);
> > > +	ret = __kvm_arm_vcpu_set_events(vcpu, events);
> > > +	vcpu_put(vcpu);
> > > +
> > > +	return ret;
> > >  }
> > 
> > [Severity: Medium]
> > Does vcpu->mmio_needed remain set when KVM_SET_VCPU_EVENTS injects an
> > exception from L2 that routes to L1 EL2?
> > 
> > When an L2 guest exits with KVM_EXIT_MMIO and userspace aborts the access via
> > KVM_SET_VCPU_EVENTS (for example with ext_dabt_pending = 1 while HCR_EL2.TEA
> > is set), kvm_inject_sea_dabt() -> kvm_inject_nested() commits the EL2
> > exception entry directly via __kvm_adjust_pc(), which clears
> > PENDING_EXCEPTION.  When __kvm_arm_vcpu_set_events() then calls
> > commit_pending_events(), PENDING_EXCEPTION is already clear, so it returns
> > early without clearing vcpu->mmio_needed:
> > 
> > arch/arm64/kvm/guest.c:commit_pending_events() {
> > 	if (!vcpu_get_flag(vcpu, PENDING_EXCEPTION))
> > 		return;
> > 
> > 	vcpu->mmio_needed = false;
> > 	kvm_call_hyp(__kvm_adjust_pc, vcpu);
> > }
> > 
> > On the next KVM_RUN, kvm_handle_mmio_return() sees vcpu->mmio_needed still
> > set, writes the MMIO read value into L1 EL2's destination register and
> > advances L1 EL2's exception vector PC by 4 bytes via kvm_incr_pc().
> 
> I think this is a separate issue, which doesn't intersect with the
> current patch.

Yep.

> The problem is that we have multiple ways to "commit'
> the state on exception delivery, and that we miss MMIO handling in the
> EL1->EL2 path.
> 
> Oliver, WDYT?
> 

I have a reproducer for the bug Sashiko found and this patch doesn't
work.  Attached.  Claude wanted to just set vcpu->mmio_needed = false;
but I told it to call commit_pending_events() instead.

I can send that.

regards,
dan carpenter

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 0614c3b3a40dfd..c75b0c62382444 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1354,6 +1354,7 @@ int __kvm_arm_vcpu_get_events(struct kvm_vcpu *vcpu,
 
 int __kvm_arm_vcpu_set_events(struct kvm_vcpu *vcpu,
 			      struct kvm_vcpu_events *events);
+void commit_pending_events(struct kvm_vcpu *vcpu);
 
 void kvm_arm_halt_guest(struct kvm *kvm);
 void kvm_arm_resume_guest(struct kvm *kvm);
diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index 39136a89d74bb6..5a7019bb719b2a 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -2921,7 +2921,7 @@ static int kvm_inject_nested(struct kvm_vcpu *vcpu, u64 esr_el2,
 	 * Make sure the exception actually took place before we load
 	 * the new context.
 	 */
-	__kvm_adjust_pc(vcpu);
+	commit_pending_events(vcpu);
 
 	kvm_arch_vcpu_load(vcpu, smp_processor_id());
 	vcpu_clear_flag(vcpu, IN_NESTED_EXCEPTION);
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index ba4570c52a9162..b7d36c2abfdf9b 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -770,7 +770,7 @@ int __kvm_arm_vcpu_get_events(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
-static void commit_pending_events(struct kvm_vcpu *vcpu)
+void commit_pending_events(struct kvm_vcpu *vcpu)
 {
 	if (!vcpu_get_flag(vcpu, PENDING_EXCEPTION))
 		return;
-- 
2.53.0

--SiI1FD/O0lCfvQZp
Content-Type: application/x-sh
Content-Disposition: attachment; filename=build.sh
Content-Transfer-Encoding: quoted-printable

#!/bin/sh=0A# build.sh: builds stale_mmio, a static arm64 binary, in this d=
irectory.=0A# On an arm64 machine it uses CC (default gcc); elsewhere the c=
ross compiler=0A# (CC, default aarch64-linux-gnu-gcc).=0Acd "$(dirname "$0"=
)" || exit 1=0Aif [ "$(uname -m)" =3D aarch64 ]; then=0A	CC=3D${CC:-gcc}=0A=
else=0A	CC=3D${CC:-aarch64-linux-gnu-gcc}=0Afi=0A$CC -O2 -Wall -static -o s=
tale_mmio stale_mmio.c=0A
--SiI1FD/O0lCfvQZp
Content-Type: text/x-csrc; charset=us-ascii
Content-Disposition: attachment; filename=stale_mmio.c

/*
 * stale_mmio: after an L2 MMIO exit, the KVM_SET_VCPU_EVENTS ioctl with
 * serror_pending routes the SError to L1 (L1's HCR_EL2.AMO is set), and
 * kvm_inject_nested() performs the exception entry straight away.  That
 * must also drop the pending MMIO emulation: otherwise the next KVM_RUN
 * completes the L2 access in L1's context, skips the first instruction of
 * L1's SError vector and, for a read, writes the MMIO data to an L1
 * register.
 *
 * The vcpu is put in L2 context with KVM_SET_ONE_REG (HCR_EL2 = E2H | RW |
 * AMO, PSTATE = EL1h) and run once: L2 does one access to an address with
 * no memslot, which exits to userspace as MMIO.  Then the SError is set
 * pending, the vcpu must be at L1's SError vector (VBAR_EL2 + 0x580), and
 * it is run again.  L1's vector is
 *
 *	+0x580	str	x0, [x3]	// MMIO at L1_MMIO: the vector ran from its start
 *	+0x584	str	x0, [x4]	// MMIO at SKIP_MMIO: its first instruction was skipped
 *
 * Usage: stale_mmio write|read
 *   write: L2 does str x0, [x2].
 *   read:  L2 does ldr x5, [x2]; userspace answers with MMIO_DATA, and x5
 *          must keep its value, as the load never completed.
 *
 * Exit 0 when L1's vector runs from its start (and x5 is untouched), 1
 * when the stale MMIO emulation shows, 2 on a set-up error or another
 * result.  Kernels without "KVM: arm64: Load the vcpu in
 * KVM_SET_VCPU_EVENTS" oops in the ioctl instead (see
 * nv-set-vcpu-events-put-load-unloaded).
 */
#include <errno.h>
#include <fcntl.h>
#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <sys/ioctl.h>
#include <sys/mman.h>
#include <unistd.h>
#include <linux/kvm.h>

#ifndef KVM_ARM_VCPU_HAS_EL2
#define KVM_ARM_VCPU_HAS_EL2	7
#endif
#ifndef KVM_CAP_ARM_EL2
#define KVM_CAP_ARM_EL2		240
#endif

#define MEM_BASE	0x40000000UL		/* the memslot: 64K of guest memory */
#define MEM_SIZE	0x10000UL
#define CODE		(MEM_BASE + 0x0)	/* L2 code */
#define VECTORS		(MEM_BASE + 0x800)	/* L1's EL2 vectors, 2K aligned */
#define MMIO		0x10000000UL		/* no memslot here */
#define L1_MMIO		0x10001000UL
#define SKIP_MMIO	0x10002000UL
#define MMIO_DATA	0x1234567876543210ULL
#define X5_INIT		0x5555555555555555ULL

#define GICD_BASE	0x08000000UL
#define GICR_BASE	0x080a0000UL

#define HCR_AMO		(1ULL << 5)
#define HCR_RW		(1ULL << 31)
#define HCR_E2H		(1ULL << 34)

/* PSR_MODE_MASK, PSR_MODE_EL1h and PSR_MODE_EL2h come from asm/ptrace.h. */
#define PSR_EL1h_DAIF	0x3c5ULL		/* EL1h, D, A, I and F masked */

#define SERROR_LOWER_A64	0x580		/* lower EL using AArch64, SError */

#define CORE_REG(name)	(KVM_REG_ARM64 | KVM_REG_SIZE_U64 | KVM_REG_ARM_CORE | \
			 KVM_REG_ARM_CORE_REG(name))
#define REG_HCR_EL2	ARM64_SYS_REG(3, 4, 1, 1, 0)
#define REG_VBAR_EL2	ARM64_SYS_REG(3, 4, 12, 0, 0)
#define REG_ESR_EL2	ARM64_SYS_REG(3, 4, 5, 2, 0)

static int fail(const char *what)
{
	fprintf(stderr, "%s: %s\n", what, strerror(errno));
	return 2;
}

static int set_reg(int vcpu, uint64_t id, uint64_t val)
{
	struct kvm_one_reg reg = { .id = id, .addr = (uint64_t)(uintptr_t)&val };

	return ioctl(vcpu, KVM_SET_ONE_REG, &reg);
}

static int get_reg(int vcpu, uint64_t id, uint64_t *val)
{
	struct kvm_one_reg reg = { .id = id, .addr = (uint64_t)(uintptr_t)val };

	return ioctl(vcpu, KVM_GET_ONE_REG, &reg);
}

static int dev_attr(int fd, uint32_t group, uint64_t attr, void *val)
{
	struct kvm_device_attr a = {
		.group = group, .attr = attr, .addr = (uint64_t)(uintptr_t)val,
	};

	return ioctl(fd, KVM_SET_DEVICE_ATTR, &a);
}

int main(int argc, char **argv)
{
	struct kvm_userspace_memory_region region;
	struct kvm_create_device gic = { .type = KVM_DEV_TYPE_ARM_VGIC_V3 };
	struct kvm_vcpu_events events;
	struct kvm_vcpu_init init;
	struct kvm_run *run;
	uint64_t gicd = GICD_BASE, gicr = GICR_BASE, pc, pstate, esr, x5;
	int kvm, vm, vcpu, run_size, i, read;
	uint32_t *code;
	uint8_t *mem;

	if (argc != 2 || (strcmp(argv[1], "write") && strcmp(argv[1], "read"))) {
		fprintf(stderr, "usage: %s write|read\n", argv[0]);
		return 2;
	}
	read = !strcmp(argv[1], "read");

	kvm = open("/dev/kvm", O_RDWR);
	if (kvm < 0)
		return fail("/dev/kvm");
	if (ioctl(kvm, KVM_CHECK_EXTENSION, KVM_CAP_ARM_EL2) <= 0) {
		fprintf(stderr, "KVM_CAP_ARM_EL2 missing: boot with kvm-arm.mode=nested\n");
		return 2;
	}
	vm = ioctl(kvm, KVM_CREATE_VM, 0);
	if (vm < 0)
		return fail("KVM_CREATE_VM");

	mem = mmap(NULL, MEM_SIZE, PROT_READ | PROT_WRITE, MAP_SHARED | MAP_ANONYMOUS, -1, 0);
	if (mem == MAP_FAILED)
		return fail("mmap");
	region = (struct kvm_userspace_memory_region) {
		.slot = 0, .guest_phys_addr = MEM_BASE, .memory_size = MEM_SIZE,
		.userspace_addr = (uint64_t)(uintptr_t)mem,
	};
	if (ioctl(vm, KVM_SET_USER_MEMORY_REGION, &region))
		return fail("KVM_SET_USER_MEMORY_REGION");

	/* L2: one access that exits as MMIO.  L1's vectors: spin, except SError. */
	code = (uint32_t *)(mem + (CODE - MEM_BASE));
	code[0] = read ? 0xf9400045 :	/* ldr x5, [x2] */
			 0xf9000040;	/* str x0, [x2] */
	code[1] = 0x14000000;		/* b . */
	for (i = 0; i < 0x800 / 4; i++)
		((uint32_t *)(mem + (VECTORS - MEM_BASE)))[i] = 0x14000000;
	code = (uint32_t *)(mem + (VECTORS + SERROR_LOWER_A64 - MEM_BASE));
	code[0] = 0xf9000060;		/* str x0, [x3] */
	code[1] = 0xf9000080;		/* str x0, [x4] */

	if (ioctl(vm, KVM_CREATE_DEVICE, &gic))
		return fail("KVM_CREATE_DEVICE (vGICv3)");
	if (dev_attr(gic.fd, KVM_DEV_ARM_VGIC_GRP_ADDR, KVM_VGIC_V3_ADDR_TYPE_DIST, &gicd) ||
	    dev_attr(gic.fd, KVM_DEV_ARM_VGIC_GRP_ADDR, KVM_VGIC_V3_ADDR_TYPE_REDIST, &gicr))
		return fail("setting the vGIC addresses");

	vcpu = ioctl(vm, KVM_CREATE_VCPU, 0);
	if (vcpu < 0)
		return fail("KVM_CREATE_VCPU");
	if (ioctl(vm, KVM_ARM_PREFERRED_TARGET, &init))
		return fail("KVM_ARM_PREFERRED_TARGET");
	init.features[0] |= 1U << KVM_ARM_VCPU_HAS_EL2;
	if (ioctl(vcpu, KVM_ARM_VCPU_INIT, &init))
		return fail("KVM_ARM_VCPU_INIT with KVM_ARM_VCPU_HAS_EL2");
	if (dev_attr(gic.fd, KVM_DEV_ARM_VGIC_GRP_CTRL, KVM_DEV_ARM_VGIC_CTRL_INIT, NULL))
		return fail("initialising the vGIC");

	/* L2 context, with L1 asking for SErrors (AMO).  No stage 2 (VM=0). */
	if (set_reg(vcpu, REG_HCR_EL2, HCR_E2H | HCR_RW | HCR_AMO) ||
	    set_reg(vcpu, REG_VBAR_EL2, VECTORS) ||
	    set_reg(vcpu, CORE_REG(regs.regs[2]), MMIO) ||
	    set_reg(vcpu, CORE_REG(regs.regs[3]), L1_MMIO) ||
	    set_reg(vcpu, CORE_REG(regs.regs[4]), SKIP_MMIO) ||
	    set_reg(vcpu, CORE_REG(regs.regs[5]), X5_INIT) ||
	    set_reg(vcpu, CORE_REG(regs.pc), CODE) ||
	    set_reg(vcpu, CORE_REG(regs.pstate), PSR_EL1h_DAIF))
		return fail("KVM_SET_ONE_REG");

	run_size = ioctl(kvm, KVM_GET_VCPU_MMAP_SIZE, 0);
	run = mmap(NULL, run_size, PROT_READ | PROT_WRITE, MAP_SHARED, vcpu, 0);
	if (run == MAP_FAILED)
		return fail("mmap kvm_run");

	if (ioctl(vcpu, KVM_RUN, 0))
		return fail("KVM_RUN");
	if (run->exit_reason != KVM_EXIT_MMIO || run->mmio.phys_addr != MMIO ||
	    run->mmio.is_write == read) {
		fprintf(stderr, "unexpected exit: reason %u (expected an MMIO %s at 0x%lx)\n",
			run->exit_reason, argv[1], MMIO);
		return 2;
	}
	if (get_reg(vcpu, CORE_REG(regs.pstate), &pstate))
		return fail("KVM_GET_ONE_REG PSTATE");
	if ((pstate & PSR_MODE_MASK) != PSR_MODE_EL1h) {
		fprintf(stderr, "after the run the vCPU is not in L2's EL1 (PSTATE 0x%llx)\n",
			(unsigned long long)pstate);
		return 2;
	}
	printf("%s: ran L2 and exited to userspace (MMIO %s at 0x%llx); now KVM_SET_VCPU_EVENTS serror_pending\n",
	       argv[1], argv[1], (unsigned long long)run->mmio.phys_addr);
	fflush(stdout);

	memset(&events, 0, sizeof(events));
	events.exception.serror_pending = 1;
	if (ioctl(vcpu, KVM_SET_VCPU_EVENTS, &events))
		return fail("KVM_SET_VCPU_EVENTS");

	if (get_reg(vcpu, CORE_REG(regs.pc), &pc) ||
	    get_reg(vcpu, CORE_REG(regs.pstate), &pstate) ||
	    get_reg(vcpu, REG_ESR_EL2, &esr))
		return fail("KVM_GET_ONE_REG after the injection");
	printf("KVM_SET_VCPU_EVENTS returned: PC 0x%llx, PSTATE 0x%llx, ESR_EL2 0x%llx\n",
	       (unsigned long long)pc, (unsigned long long)pstate, (unsigned long long)esr);

	if (pc != VECTORS + SERROR_LOWER_A64 || (pstate & PSR_MODE_MASK) != PSR_MODE_EL2h) {
		fprintf(stderr, "the ioctl returned, but the vCPU is not at L1's SError vector\n");
		return 2;
	}
	printf("the SError was delivered to L1's EL2; running again\n");

	/* What a VMM would hand back for the read, had it not aborted it. */
	if (read)
		memcpy(run->mmio.data, &(uint64_t){ MMIO_DATA }, sizeof(uint64_t));

	if (ioctl(vcpu, KVM_RUN, 0))
		return fail("second KVM_RUN");
	if (run->exit_reason != KVM_EXIT_MMIO) {
		fprintf(stderr, "second run: unexpected exit: reason %u (expected MMIO)\n",
			run->exit_reason);
		return 2;
	}
	if (get_reg(vcpu, CORE_REG(regs.regs[5]), &x5))
		return fail("KVM_GET_ONE_REG x5");
	printf("%s: second run: MMIO at 0x%llx, x5 0x%llx\n", argv[1],
	       (unsigned long long)run->mmio.phys_addr, (unsigned long long)x5);

	if (run->mmio.phys_addr == L1_MMIO && x5 == X5_INIT) {
		printf("%s: L1's SError vector ran from its first instruction\n", argv[1]);
		return 0;
	}
	if (run->mmio.phys_addr == SKIP_MMIO || (read && x5 == MMIO_DATA)) {
		printf("%s: stale MMIO emulation: %s%s\n", argv[1],
		       run->mmio.phys_addr == SKIP_MMIO ? "L1's first vector instruction was skipped" : "",
		       read && x5 == MMIO_DATA ? ", x5 got the aborted read's data" : "");
		return 1;
	}
	fprintf(stderr, "%s: unexpected result\n", argv[1]);
	return 2;
}

--SiI1FD/O0lCfvQZp
Content-Type: application/x-sh
Content-Disposition: attachment; filename=run_on_L1.sh
Content-Transfer-Encoding: quoted-printable

#!/bin/sh=0A# run_on_L1.sh: runs stale_mmio (write and read) on an arm64 L1=
 booted with=0A# kvm-arm.mode=3Dnested (build it first with build.sh).  Nee=
ds /dev/kvm (the=0A# kvm group) and sudo for the kernel log.  Prints "Bug r=
eproduced." or=0A# "Unable to reproduce the bug.".=0A#=0A# The L1 kernel ne=
eds "KVM: arm64: Load the vcpu in KVM_SET_VCPU_EVENTS";=0A# without it the =
ioctl oopses first (the NULL hw_mmu bug), and the L1 should=0A# be rebooted=
=2E=0Acd "$(dirname "$0")" || exit 1=0Auname -r=0Abefore=3D$(sudo dmesg | g=
rep -c 'Unable to handle kernel')=0Abug=3D0=0Afor mode in write read; do=0A=
	timeout 30 ./stale_mmio $mode=0A	rc=3D$?=0A	after=3D$(sudo dmesg | grep -c=
 'Unable to handle kernel')=0A	if [ "$after" -gt "$before" ]; then=0A		echo=
 "The kernel oopsed: this L1 lacks the KVM_SET_VCPU_EVENTS load fix.  Reboo=
t it."=0A		exit 2=0A	fi=0A	case $rc in=0A	0) ;;=0A	1) bug=3D1 ;;=0A	*) echo=
 "$mode: set-up error or unexpected result (exit $rc)"; exit 2 ;;=0A	esac=
=0Adone=0Aif [ $bug -eq 1 ]; then=0A	echo "Bug reproduced."=0A	exit 0=0Afi=
=0Aecho "Unable to reproduce the bug."=0Aexit 1=0A
--SiI1FD/O0lCfvQZp--
