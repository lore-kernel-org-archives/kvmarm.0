Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE3D71F7569;
	Tue, 22 Jul 2025 15:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753199738; cv=none; b=iEeHFBJxHG/HFntpB5+5jNL13ByqwHmN3mNUUjSsm5vzZJGqSUZm5EAIYopVnMwF4oKucQA/cdDo0Jnr1TzSkHjiGuHmHV4AxtG9+3MwHepxy1h8k56PIzync+2dlvG8plIS+h2QvwxAXuX1nhPMwwN9UFHcf5Kw8WdJ7DHizSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753199738; c=relaxed/simple;
	bh=qCAlLytfe5uxUR+Ym8p1FvfXAOoNuadaGk+KsaQe0GE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DMlQY2MVMA2OjAToNrty6pTrNxwvG+rC6n3J6jG809zSVZLQNhmMgtALdWzr8VkoENqOdYi6y9JHOEdTH/fK/J8weY11+8w8nkHCV/59WQNRnaycelXBhcEhMiIXwNp7DJ06YeEXCg3ZAc4VUTw+g0shEsC1Z7jzh5tHKiYp7Hg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uEx3cvh4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uEx3cvh4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A1FDC4CEEB;
	Tue, 22 Jul 2025 15:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753199738;
	bh=qCAlLytfe5uxUR+Ym8p1FvfXAOoNuadaGk+KsaQe0GE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uEx3cvh4RQAKwfDQDSG1z19MJSzX0YiEluAR3i27plhReW9oFMQX2Zf08RebVDp28
	 1Ax+KPJISu+JpTeItf9SHNhIsA9PF6jrcTZiOBhAn8thphl4xr9HcQOa32wW6YesJi
	 cD40Jv2F/53isZEfm1vwqCAGlJTi3sDiEpOXD+R+B4ljbPtogaP3IcngE5+U42Q5+T
	 Dbt/sUvi/ye2+P5bcWJU/8YR8pnf67HfDEtGZCwohcsFEp0uM+8azAk66lRN/YFZkT
	 clK3/7rUq7gDBFVBLwwhrGJFYsvrUeVorIeSOjyKGzzj/im4WhtLPzHKmZ/hB4dYt/
	 pG/J9FCWTSagw==
Date: Tue, 22 Jul 2025 16:55:31 +0100
From: Will Deacon <will@kernel.org>
To: Per Larsen <perl@immunant.com>, sudeep.holla@arm.com,
	mark.rutland@arm.com
Cc: Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
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
Message-ID: <aH-0cx9YhdWRe2nq@willie-the-truck>
References: <20250701-virtio-msg-ffa-v7-0-995afc3d385e@google.com>
 <20250701-virtio-msg-ffa-v7-2-995afc3d385e@google.com>
 <8634bdbgaz.wl-maz@kernel.org>
 <3b10fa81-bfdd-4325-a330-c79df2e21621@immunant.com>
 <aHpOClH1k-3NhI_y@willie-the-truck>
 <67cc6766-6493-4171-a6b1-2a105c3e6ff5@immunant.com>
 <CAMP5XgeUwDnf=PbySy6aoF_zc7dtxymDQZEp8DuRSOLg4WEnFQ@mail.gmail.com>
 <dd136db0-1ac7-4f75-b550-ccf7e14c032a@immunant.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <dd136db0-1ac7-4f75-b550-ccf7e14c032a@immunant.com>

[Sudeep & Mark to To:]

On Mon, Jul 21, 2025 at 05:20:01PM -0700, Per Larsen wrote:
> On 7/21/25 4:01 AM, Arve Hjønnevåg wrote:
> > On Fri, Jul 18, 2025 at 10:54 PM Per Larsen <perl@immunant.com> wrote:
> > > On 7/18/25 6:37 AM, Will Deacon wrote:
> > > > On Mon, Jul 07, 2025 at 05:06:23PM -0700, Per Larsen wrote:
> > > > > On 7/3/25 5:38 AM, Marc Zyngier wrote:
> > > > > > On Tue, 01 Jul 2025 23:06:35 +0100,
> > > > > > Per Larsen via B4 Relay <devnull+perlarsen.google.com@kernel.org> wrote:
> > > > > > > +  /*
> > > > > > > +   * DEN0028C 2.6: SMC32/HVC32 call from aarch64 must preserve x8-x30.
> > > > > > > +   *
> > > > > > > +   * The most straightforward approach is to look at the function ID
> > > > > > > +   * sent by the caller. However, the caller could send FFA_MSG_WAIT
> > > > > > > +   * which is a 32-bit interface but the reply could very well be 64-bit
> > > > > > > +   * such as FFA_FN64_MSG_SEND_DIRECT_REQ or FFA_MSG_SEND_DIRECT_REQ2.
> > > > > > > +   *
> > > > > > > +   * Instead, we could look at the function ID in the response (a0) but
> > > > > > > +   * that doesn't work either as FFA_VERSION responses put the version
> > > > > > > +   * number (or error code) in w0.
> > > > > > > +   *
> > > > > > > +   * Set x8-x17 iff response contains 64-bit function ID in a0.
> > > > > > > +   */
> > > > > > > +  if (func_id != FFA_VERSION && ARM_SMCCC_IS_64(res->a0)) {
> > > > > > > +          cpu_reg(ctxt, 8) = res->a8;
> > > > > > > +          cpu_reg(ctxt, 9) = res->a9;
> > > > > > > +          cpu_reg(ctxt, 10) = res->a10;
> > > > > > > +          cpu_reg(ctxt, 11) = res->a11;
> > > > > > > +          cpu_reg(ctxt, 12) = res->a12;
> > > > > > > +          cpu_reg(ctxt, 13) = res->a13;
> > > > > > > +          cpu_reg(ctxt, 14) = res->a14;
> > > > > > > +          cpu_reg(ctxt, 15) = res->a15;
> > > > > > > +          cpu_reg(ctxt, 16) = res->a16;
> > > > > > > +          cpu_reg(ctxt, 17) = res->a17;
> > > > > > > +  }
> > > > > > >     }
> > > > > > 
> > > > > > I don't see how that can ever work.
> > > > > > 
> > > > > > Irrespective of how FFA_MSG_WAIT actually works (and I couldn't find
> > > > > > anything in the spec that supports the above), the requester will
> > > > > > fully expect its registers to be preserved based on the initial
> > > > > > function type, and that alone. No ifs, no buts.
> > > > > > 
> > > > > > If what you describe can happen (please provide a convincing example),
> > > > > > then the spec is doomed.
> > > > > 
> > > > > DEN0077A 1.2 Section 8.2 (Runtime Model for FFA_RUN) and 8.3 (Runtime Model
> > > > > for Direct request ABIs) contains Figures 8.1 and 8.2. Each figure shows
> > > > > transitions between states "waiting", "blocked", "running", and "preempted".
> > > > > Key to my understanding is that the waiting state in Figure 8.1 and Figure
> > > > > 8.2 is the exact same state. This appears to be the case per Section 4.10.
> > > > > 
> > > > > So we have to consider the ways to get in and out of the waiting state by
> > > > > joining the state machines in Figures 8.1 and 8.2. Figure 8.1 has an edge
> > > > > between "running" and "waiting" caused by FFA_MSG_WAIT. Figure 8.2 has an
> > > > > edge between "waiting" and "running" caused by a "Direct request ABI".
> > > > > 
> > > > > Direct request ABIs include FFA_MSG_SEND_DIRECT_REQ2 which is why the FF-A
> > > > > 1.2 spec, in my read, permits the response to a 32-bit FFA_MSG_WAIT call can
> > > > > be a 64-bit FFA_MSG_SEND_DIRECT_REQ2 reply.
> > > > 
> > > > That seems bonkers to me and I agree with Marc's assessment above. The
> > > > SMCCC is crystal clear that a caller using the SM32/HVC32 calling
> > > > convention can rely on x8-x30 (as well as the stack pointers) being
> > > > preserved. If FF-A has a problem with that then it needs to be fixed
> > > > there and not bodged in Linux.
> > > Ack. Patchset v8 addresses Marc's feedback by using the func_id detect
> > > SMC64 instead.>
> > > > Setting that aside, I'm still not sure I follow this part of your check:
> > > > 
> > > >        if (... && ARM_SMCCC_IS_64(res->a0))
> > > > 
> > > > won't res->a0 contain something like FFA_SUCCESS? The FFA spec states:
> > > > 
> > > >     FFA_SUCCESS64, is used only if any result register encodes a 64-bit
> > > >     parameter.
> > > > 
> > > > which doesn't really seem related to whether or not the initial call
> > > > was using SMC32 or SMC64. What am I missing?I agree that we cannot use res->a0 to distinguish SMC32/SMC64 for the
> > > reason you stated.
> > 
> > I don't think using the function-id of the original call works
> > correctly in this context though. If you look at
> > drivers/firmware/arm_ffa/driver.c:ffa_msg_send_direct_req2 it has the
> > same problem as the FFA_MSG_WAIT example in your comment. In the
> > simple case it will use FFA_MSG_SEND_DIRECT_REQ2 for the call and
> > FFA_MSG_SEND_DIRECT_RESP2 for the response, both 64 bit opcodes, and
> > either approach here will have the same correct result. However if
> > FFA_MSG_SEND_DIRECT_REQ2 responds with FFA_INTERRUPT or FFA_YIELD,
> > then the driver will resume the call with FFA_RUN, a 32 bit opcode,
> > and still expect a 64 bit FFA_MSG_SEND_DIRECT_RESP2 response with a
> > full response in x4-17. If you use ARM_SMCCC_IS_64(func_id) here
> > instead of ARM_SMCCC_IS_64(res->a0), then the part of response in
> > x8-x17 will be lost.

Can't we just update the FF-A driver? This is clearly all the result of
a half-baked spec...

Sudeep -- any chance you can add support for the hot-off-the-press
64-bit FFA_RUN call to the Linux driver, please? Without that, I don't
see how the REQ2/RESP2 calls can work properly.

> > The FF-A 1.3 ALP2 fixes this by adding a 64 bit FF-A run opcode, but
> > at the current patchstack only adds ff-a 1.2 support and the linux
> > ff-a driver does not yet support the new 1.3 ALP2 call flow either so
> > I think the current v7 patch here is the best option for now.
> > 
> FFA_RUN is passed through to EL3 by kvm_host_ffa_handler so I'm not sure
> there is a code path where func_id == FFA_RUN in set_ffa_retval.

That's actually a really interesting point...

The passthrough code in __kvm_hyp_host_forward_smc() assumes SMC64 and
populates/reloads X0-X17 across the SMC. If the firmware replies to an
SMC32 call with an SMC64, then so be it, but it's not the hypervisor's
job to fix that up and the same problem would presumably happen even if
the hypervisor wasn't present.

So perhaps there's an argument that the proxy should be consistent with
that behaviour, otherwise we end up with different semantics depending
on whether we chose to proxy the call or pass it through. That would
mean always populating X8-X17 in the return value, regardless of the
function ID or anything else.

The spec should still be fixed because the current wording makes very
little sense in this area, but in the meantime maybe it's best just to
pass the hot potato between the host and the firmware rather than try to
fix it up ourselves.

Marc -- what do you think? We're damned if we do, damned if we don't,
but there's something to be said for being consistent when we get into
this messy situation.

Will
