Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC1EA3F86F8
	for <kvmarm@lists.linux.dev>; Tue, 26 May 2026 12:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779797014; cv=none; b=RB0D6NlhUwEOZ8UN1gH6esxsDO/QqczJgcj+3do9u1YiFZWBJ/+4ZUrWeah4EFv48bAhv+sdWV9UU4ZZXOpY1Fp44yoy+2LM/PsMKtjGeSMcC3JUTam5vfq8ZRTa3wb0bkjbTYrjXgleCRLJTsu9ucE+GPWJtwK+lbCfqgZoQjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779797014; c=relaxed/simple;
	bh=FlkpAY2X0Yf6Pfxqf2EFeAIJYm7FxKNht2VVBPprLyY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TYy6Q8Ayh+HSMDaYJHJtNJYUUOg3ZYyzYJSyuE222MaZQ4Sg/k1h1pSmREIQt0gaIREBBhM8iURGVQjUIUO/ObsAbFwOSYh/Jg5G3SficjUOtTlU+UEwpgokyaHaelX5UM+joDMg69mVj4gqltv2UTZjumwcKTgtk5+DkmESswg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=JocWluzf; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="JocWluzf"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C5B89169C;
	Tue, 26 May 2026 05:03:23 -0700 (PDT)
Received: from J2N7QTR9R3 (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EF7E43F7B4;
	Tue, 26 May 2026 05:03:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779797008; bh=FlkpAY2X0Yf6Pfxqf2EFeAIJYm7FxKNht2VVBPprLyY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JocWluzfka/6ENtOHIR4dFPNqvNa8CNewaA4hKshW5Dw0uZjcQsvUUIhXmf4AIjaO
	 0pGRR2jmTc0GcfqCJTAs9/uh/FJ1Evnjc8x+7gw5zRF5zyqTbGZZ8/7HJfVRkQyGXE
	 XdHOXd086EHrfmvunqN2WcSHj0m9rz1IbmlbrMtg=
Date: Tue, 26 May 2026 13:03:19 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Mark Brown <broonie@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: Preserve all guest ZCR_EL2.LEN values
Message-ID: <ahWMByoIme6_oECX@J2N7QTR9R3>
References: <20260522-kvm-arm64-fix-zcr-len-nv-v1-1-ec254e9078cf@kernel.org>
 <ahSWwl-uCv4ZW-nE@J2N7QTR9R3>
 <b4fdceb6-5fa7-4829-a60e-6f80f47f032a@sirena.org.uk>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b4fdceb6-5fa7-4829-a60e-6f80f47f032a@sirena.org.uk>

On Tue, May 26, 2026 at 11:19:38AM +0100, Mark Brown wrote:
> On Mon, May 25, 2026 at 07:36:50PM +0100, Mark Rutland wrote:
> > On Fri, May 22, 2026 at 07:00:04PM +0100, Mark Brown wrote:
> 
> > > Since b3d29a823099 ("KVM: arm64: nv: Handle ZCR_EL2 traps") when guests
> > > write to ZCR_EL2 we have clamped the value of ZCR_EL2.LEN to be at most
> > > that configuring the maximum guest VL. This is not the behaviour the
> 
> ...
> 
> > Have we sought feedback from architects? While I said "*or* the
> > architcture requires a clarification", I think it should be clarified
> > more explicitly either way given that the pattern is unusual.

The part I asked for clarification on was:

  AFAICT, none of the values for the SMCR_ELx.LEN and ZCR_ELx.LEN fields
  are reserved or unallocated. Thus all the bits of those fields should
  be stateful, and a read should observe the last value written,
  regardless of the effective value of the field.

  [...]

  Either what we're doing is wrong, or the architcture requires a
  clarification to say that values corresponding to unimplmented vector
  lengths are reserved.

> > Given this is particularly subtle, please keep me in the loop when
> > speaking with architects about this.
> 
> TBH it didn't strike me as subtle, I don't see anything in the
> architecture which would lead me to expect the current behaviour. 

The point I was trying to get across is that I don't think this is
specified clearly enough, and I think we need to get this clarified.

There's a general principle regarding reserved values. See K1.2.19
("Reserved values in System and memory-mapped registers and translation
table entries"), and specifically note "reserved values of fields".

There's no explicit statement either way regarding the values for
ZCR_ELx.LEN and SMCR_ELx.LEN. The statement regarding the selection of
the effective vector length implies *some* constraints, but
(explicitly!) doesn't specify the behaviour for direct reads.

It's possible for a reader to come to one of the following conclusions:

(a) Any value written to the LEN field must be preserved exactly. In all
    cases a read must observe the last value written.

(b) Some values written to the LEN field are reserved, and don't need to
    be preserved exactly.

    For example, since the only architecturally-defined VLs are
    powers-of-two, the only "legitimate" values are: 0b0000, 0b0001,
    0b0011, 0b0111, 0b1111. Hence any written value could be collapsed
    to that set.

(c) Some values written to the LEN field are reserved, and can be
    replaced with *any* value.

    See the statement at the end of K1.2.19 regarding subsequent reads
    returning an UNKNOWN value.

While one simple reading is that all values must be preserved exactly, I
don't think this watertight, and I think while some people will take
reading (a), others will take (b) or (c). I should have spelled that out
more clearly in my initial mail, sorry.

> The psudocode all just has direct assignments for the write

The pseudocode doesn't capture the detail I've described above.

> and there's language in the ARM (eg, in the ZCR_EL2 description)
> saying "for all purposes other than returning the result of a direct
> read of ZCR_EL2" which seems specifically intended to cover there
> being a divergence between the written and effective values, though I
> guess it doesn't explicitly mention writes in the text.  

That permits a divergence, but does not define the boundary conditions
for what a direct read can observe.

Mark.
