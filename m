Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12B4E268683
	for <kvmarm@lists.linux.dev>; Tue, 22 Jul 2025 16:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753202235; cv=none; b=tl1aCQ4mTdvvO9TH5/UyuLu2llJqr4hTm9V+f0i4Q+JXHosxTovi5KVkBIbW3PLejsuywoRNwqAysjESqIrZYJccT2F5YnNQDIJwHilLHG2h8y3qFchrLuV13A6phfpmTp7SKW1VjH5b3CyTpz0XQb9Wb+YCk9ZfNUOSdvo+RX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753202235; c=relaxed/simple;
	bh=7nZg7NqjYH1H6JgtaArIT/6n27NslXHEFoJA+fbWTYI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s5BGag6twH/D6c0vHMwu7Urph6VG3Iaj1uLh0Z5yKqx3Sl47IovSDs8CNwdHeoo6FfkgVUV+b9TMJl8OnA1OeThZX0NbbtN3nLhWEmZGpzTky13KSa7VCuxOwSSMZgviHCexwwmw9EkSXYmXxR8pcPlwKcZuDib4pm8Csg1uW6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com; spf=none smtp.mailfrom=foss.arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=foss.arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6AEB01515;
	Tue, 22 Jul 2025 09:37:07 -0700 (PDT)
Received: from bogus (e133711.arm.com [10.1.196.55])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B36AE3F5A1;
	Tue, 22 Jul 2025 09:37:09 -0700 (PDT)
Date: Tue, 22 Jul 2025 17:37:06 +0100
From: Sudeep Holla <sudeep.holla@arm.com>
To: Will Deacon <will@kernel.org>
Cc: Per Larsen <perl@immunant.com>, mark.rutland@arm.com,
	Sudeep Holla <sudeep.holla@arm.com>,
	Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
	Marc Zyngier <maz@kernel.org>, perlarsen@google.com,
	Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, ahomescu@google.com,
	armellel@google.com, ayrton@google.com, qperret@google.com,
	sebastianene@google.com, qwandor@google.com
Subject: Re: [PATCH v7 2/5] KVM: arm64: Use SMCCC 1.2 for FF-A initialization
 and in host handler
Message-ID: <20250722-shrewd-hyena-from-saturn-dbcfc1@sudeepholla>
References: <20250701-virtio-msg-ffa-v7-0-995afc3d385e@google.com>
 <20250701-virtio-msg-ffa-v7-2-995afc3d385e@google.com>
 <8634bdbgaz.wl-maz@kernel.org>
 <3b10fa81-bfdd-4325-a330-c79df2e21621@immunant.com>
 <aHpOClH1k-3NhI_y@willie-the-truck>
 <67cc6766-6493-4171-a6b1-2a105c3e6ff5@immunant.com>
 <CAMP5XgeUwDnf=PbySy6aoF_zc7dtxymDQZEp8DuRSOLg4WEnFQ@mail.gmail.com>
 <dd136db0-1ac7-4f75-b550-ccf7e14c032a@immunant.com>
 <aH-0cx9YhdWRe2nq@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aH-0cx9YhdWRe2nq@willie-the-truck>

On Tue, Jul 22, 2025 at 04:55:31PM +0100, Will Deacon wrote:
> [Sudeep & Mark to To:]
> 
> On Mon, Jul 21, 2025 at 05:20:01PM -0700, Per Larsen wrote:
> > On 7/21/25 4:01 AM, Arve Hjønnevåg wrote:
> > > On Fri, Jul 18, 2025 at 10:54 PM Per Larsen <perl@immunant.com> wrote:
> > > > On 7/18/25 6:37 AM, Will Deacon wrote:
> > > > > On Mon, Jul 07, 2025 at 05:06:23PM -0700, Per Larsen wrote:
> > > > > > On 7/3/25 5:38 AM, Marc Zyngier wrote:
> > > > > > > On Tue, 01 Jul 2025 23:06:35 +0100,
> > > > > > > Per Larsen via B4 Relay <devnull+perlarsen.google.com@kernel.org> wrote:
> > > > > > > > +  /*
> > > > > > > > +   * DEN0028C 2.6: SMC32/HVC32 call from aarch64 must preserve x8-x30.
> > > > > > > > +   *
> > > > > > > > +   * The most straightforward approach is to look at the function ID
> > > > > > > > +   * sent by the caller. However, the caller could send FFA_MSG_WAIT
> > > > > > > > +   * which is a 32-bit interface but the reply could very well be 64-bit
> > > > > > > > +   * such as FFA_FN64_MSG_SEND_DIRECT_REQ or FFA_MSG_SEND_DIRECT_REQ2.
> > > > > > > > +   *
> > > > > > > > +   * Instead, we could look at the function ID in the response (a0) but
> > > > > > > > +   * that doesn't work either as FFA_VERSION responses put the version
> > > > > > > > +   * number (or error code) in w0.
> > > > > > > > +   *
> > > > > > > > +   * Set x8-x17 iff response contains 64-bit function ID in a0.
> > > > > > > > +   */
> > > > > > > > +  if (func_id != FFA_VERSION && ARM_SMCCC_IS_64(res->a0)) {
> > > > > > > > +          cpu_reg(ctxt, 8) = res->a8;
> > > > > > > > +          cpu_reg(ctxt, 9) = res->a9;
> > > > > > > > +          cpu_reg(ctxt, 10) = res->a10;
> > > > > > > > +          cpu_reg(ctxt, 11) = res->a11;
> > > > > > > > +          cpu_reg(ctxt, 12) = res->a12;
> > > > > > > > +          cpu_reg(ctxt, 13) = res->a13;
> > > > > > > > +          cpu_reg(ctxt, 14) = res->a14;
> > > > > > > > +          cpu_reg(ctxt, 15) = res->a15;
> > > > > > > > +          cpu_reg(ctxt, 16) = res->a16;
> > > > > > > > +          cpu_reg(ctxt, 17) = res->a17;
> > > > > > > > +  }
> > > > > > > >     }
> > > > > > > 
> > > > > > > I don't see how that can ever work.
> > > > > > > 
> > > > > > > Irrespective of how FFA_MSG_WAIT actually works (and I couldn't find
> > > > > > > anything in the spec that supports the above), the requester will
> > > > > > > fully expect its registers to be preserved based on the initial
> > > > > > > function type, and that alone. No ifs, no buts.
> > > > > > > 
> > > > > > > If what you describe can happen (please provide a convincing example),
> > > > > > > then the spec is doomed.
> > > > > > 
> > > > > > DEN0077A 1.2 Section 8.2 (Runtime Model for FFA_RUN) and 8.3 (Runtime Model
> > > > > > for Direct request ABIs) contains Figures 8.1 and 8.2. Each figure shows
> > > > > > transitions between states "waiting", "blocked", "running", and "preempted".
> > > > > > Key to my understanding is that the waiting state in Figure 8.1 and Figure
> > > > > > 8.2 is the exact same state. This appears to be the case per Section 4.10.
> > > > > > 
> > > > > > So we have to consider the ways to get in and out of the waiting state by
> > > > > > joining the state machines in Figures 8.1 and 8.2. Figure 8.1 has an edge
> > > > > > between "running" and "waiting" caused by FFA_MSG_WAIT. Figure 8.2 has an
> > > > > > edge between "waiting" and "running" caused by a "Direct request ABI".
> > > > > > 
> > > > > > Direct request ABIs include FFA_MSG_SEND_DIRECT_REQ2 which is why the FF-A
> > > > > > 1.2 spec, in my read, permits the response to a 32-bit FFA_MSG_WAIT call can
> > > > > > be a 64-bit FFA_MSG_SEND_DIRECT_REQ2 reply.
> > > > > 
> > > > > That seems bonkers to me and I agree with Marc's assessment above. The
> > > > > SMCCC is crystal clear that a caller using the SM32/HVC32 calling
> > > > > convention can rely on x8-x30 (as well as the stack pointers) being
> > > > > preserved. If FF-A has a problem with that then it needs to be fixed
> > > > > there and not bodged in Linux.
> > > > Ack. Patchset v8 addresses Marc's feedback by using the func_id detect
> > > > SMC64 instead.>
> > > > > Setting that aside, I'm still not sure I follow this part of your check:
> > > > > 
> > > > >        if (... && ARM_SMCCC_IS_64(res->a0))
> > > > > 
> > > > > won't res->a0 contain something like FFA_SUCCESS? The FFA spec states:
> > > > > 
> > > > >     FFA_SUCCESS64, is used only if any result register encodes a 64-bit
> > > > >     parameter.
> > > > > 
> > > > > which doesn't really seem related to whether or not the initial call
> > > > > was using SMC32 or SMC64. What am I missing?I agree that we cannot use res->a0 to distinguish SMC32/SMC64 for the
> > > > reason you stated.
> > > 
> > > I don't think using the function-id of the original call works
> > > correctly in this context though. If you look at
> > > drivers/firmware/arm_ffa/driver.c:ffa_msg_send_direct_req2 it has the
> > > same problem as the FFA_MSG_WAIT example in your comment. In the
> > > simple case it will use FFA_MSG_SEND_DIRECT_REQ2 for the call and
> > > FFA_MSG_SEND_DIRECT_RESP2 for the response, both 64 bit opcodes, and
> > > either approach here will have the same correct result. However if
> > > FFA_MSG_SEND_DIRECT_REQ2 responds with FFA_INTERRUPT or FFA_YIELD,
> > > then the driver will resume the call with FFA_RUN, a 32 bit opcode,
> > > and still expect a 64 bit FFA_MSG_SEND_DIRECT_RESP2 response with a
> > > full response in x4-17. If you use ARM_SMCCC_IS_64(func_id) here
> > > instead of ARM_SMCCC_IS_64(res->a0), then the part of response in
> > > x8-x17 will be lost.
> 
> Can't we just update the FF-A driver? This is clearly all the result of
> a half-baked spec...
> 
> Sudeep -- any chance you can add support for the hot-off-the-press
> 64-bit FFA_RUN call to the Linux driver, please? Without that, I don't
> see how the REQ2/RESP2 calls can work properly.
> 

Apologies for the delay in following up on this thread. Yes, we can certainly
add the 64-bit FFA_RUN, but we'll need to align with the spec authors first.
I'll follow up internally to ensure there's no conflict between how it's
defined in the spec and how it's used in the kernel.

It looks like the change in the spec is already WIP which I was made aware
just now, so I don't see any issue updating the driver.

-- 
Regards,
Sudeep
