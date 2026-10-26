Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793050212;
	b=T3+yT/HUrvTgQCpRUyyBorIrVYsqMoPaysKDOTidcvzXhC89SQ1u/a9VuvSVqH3SlrYb
	 aVwILBevw1FU6Mr5bVWatPhw/sg2Kz4YP0g0x8fdMQAIOGmm0X0GwimYBvx92oFh7/VQJ
	 hImLT8XI26PGi9DWjA0t1uz+yv76yTdghOLw9EkSplVxSc/+BxLkETqPfHc8y1AlWU6qK
	 0Z8PAWdLPcBPp1G6NNACr3GE1w2Uwi9gQKSgHlkap2qz/SyawKolngAJedh3++YfWGEiX
	 gXlf4WP5QQGFeQsyK10uORMsxmWC3I8LkAQQcKtrh4ojIqRw83ERSo8vsDPDSHuaerw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793050212;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=wnInlAoM7eCnwc4pQzCJ3JjKUOaq29EJiA2dB7FE3lc=;
	b=w61mVtqcOpY4sInENPCXYeU/gvzoA5YSIAHuuCl9y/75VcOdH9JEQVNSm5JNb1hEqZL+
	 xuTPHqj0gfCDMOLks0uELMo+EzT0ZwKdb9TJrwCzF3o3uNddvrFji+PaomU16UkCb/DeT
	 gbozVLG2gSBOvJIiUyp75Zz7oIXLzxMfXT/4lk2srYVSyUBFDaa3dqFf5wC8RqEpLx4DK
	 IFXq7JIhX7cLQzOPywtKQJPXqJj6J6CbQHQtxay3CHnF5a6ZmP/T6IaFCuAt1ULb94ASq
	 fAmxJRCQelGu8ih1gFcVeYGJpnjAbPpElNAU/z9FywpOFv6HX6gYBbMMlwWgJ2Glu+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="Tv6/cPLh";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07757606A31D;
	Mon, 26 Oct 2026 21:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Tv6/cPLh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58B081F01829;
	Mon, 26 Oct 2026 21:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793050211;
	bh=wnInlAoM7eCnwc4pQzCJ3JjKUOaq29EJiA2dB7FE3lc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Tv6/cPLh4sVaKXCK89oJRyF7wE8NcPivUztYh15k6VmzCpjEp2C5Fzg2+rfb/Hcbb
	 xTJWKm66k1H4p5qcWHcV9aF+DPo0UJNegdI439bi3n3PeXtlKUIV87EkAQLZeqgH1P
	 GWCDtb+BEg0x/d5SU7bB+uAPMyh+wxK2/20v/alpOXo+GNNUoDpr614XE8MzjldNO3
	 Y1Rdm/bJqjDAymCb1ai5mV+DldMj6FiZjQJdaK7lnZ/3xkIFmAiT4ClF7cdzgqPXd5
	 11mx2fsBPP+ZhjtQlBuAQ9i4uj4GTRCmcmnLelhhdsorLoH0P7DAW/zk4bdgvjGXXP
	 I3ENK1ifhMJXQ==
Date: Mon, 26 Oct 2026 14:30:09 -0700
From: Oliver Upton <oupton@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Eric Auger <eric.auger@redhat.com>, Will Deacon <will@kernel.org>,
	Fuad Tabba <tabba@google.com>, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] KVM: arm64: vgic-v4: Don't allocate vPEs for a GICv2
 VM
Message-ID: <at_GYZQr1RIUi2Tf@kernel.org>
References: <20261026152639.3926498-1-fuad.tabba@linux.dev>
 <20261026152639.3926498-2-fuad.tabba@linux.dev>
 <at-mF3Qvq67Nh_v5@kernel.org>
 <87qzhc8ce6.wl-maz@kernel.org>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87qzhc8ce6.wl-maz@kernel.org>

On Mon, Oct 26, 2026 at 07:55:45PM +0000, Marc Zyngier wrote:
> On Mon, 26 Oct 2026 19:12:23 +0000,
> Oliver Upton <oupton@kernel.org> wrote:
> > 
> > On Mon, Oct 26, 2026 at 03:26:38PM +0000, Fuad Tabba wrote:
> > > KVM can run a GICv2 VM on a GICv4.0 host whose CPU interface supports
> > > legacy operation.
> > 
> > I'm pretty sure there's no IP out there that has GICv4.0 and legacy
> > mode...
> 
> My favourite space heater, HiSi D05, says otherwise: 64 A72,
> GICv4.0. Remember that it is the *CPU* that provides compat mode, and
> not the GIC.

Well I forgot that one got glued together. Good thing you're on the hook
for fixes this round then ;)

Thanks,
Olier
