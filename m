Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 211BE372EF6;
	Tue, 19 May 2026 22:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779231465; cv=none; b=iJOhzKc4D3F79Vj7iCi9Wl0WJ6IcLczX4QmM2Pb1XhfY3iNj1zETuOFbHJZoqvvuq7MsYf9pgqJdxrtpxmcNMCDOC7xvXLhy8vylwG8yAHE9N7XeIAVP9IKZeb/oFkIPh1dT1CmQwicMrhBxN4VAGEIEO6Mr+fLFuUqyhGNRhzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779231465; c=relaxed/simple;
	bh=Xu0Wzsuqb3UJUFiMu/NhOeqe0Fl6d7jfePXfdrq4gGE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bsFA2aWWYyhf/Ek5ndPaZaxqecwiwi9nkjNMLSJ5ES9iFE4Y66q/Vmy27knxVT/D2z//I0Tm5m6xeZOWonezsuRTwctH1AkLxuK6eFn2Isch8/XOoGJ4z8ttNitc65tdLybbL3fhImbpoly4vS1n83tTeprZPSRPFSkzNFi9dTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EZvlZuw1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EZvlZuw1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 632361F000E9;
	Tue, 19 May 2026 22:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779231463;
	bh=vlczZf+tmGw8IPcdnoLC+JUsg1rmEL1pieN0hKrWjbE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=EZvlZuw1VED308JyJcnm+ZCcWB9qCZjmAvJ0kifEyyoENrG12qn0dvsSCjLGcaRa6
	 QcpLh15vokgNbSpAALR7q8uSWiio5M9ti1gFHiz0gF2lBln9RtdIG6ES0hc6o1MfOQ
	 Bc7+ntO82BL4025y/pvTUtNewTuw//ZKvtzZMLals6YA11Lupm8hJPZUynvBjaAb16
	 q5L5a9lU1Ab4LrGB2MQQnmEmPnPEVaKMRjwFDQK6Km22EJFcaLJBBThmstxmkc5pXO
	 ifrMf1nhQi8+e3YEI1/6m6TJQtX+8VbC32BGlXU9vAdOqZrwvy/abxLr3B7uvHRmWa
	 ktaMwGUF4h8+A==
Date: Tue, 19 May 2026 15:57:42 -0700
From: Oliver Upton <oupton@kernel.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>, kvm <kvm@vger.kernel.org>,
	Linux Doc Mailing List <linux-doc@vger.kernel.org>,
	"Kernel Mailing List, Linux" <linux-kernel@vger.kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Jim Mattson <jmattson@google.com>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Eric Auger <eric.auger@redhat.com>, Kees Cook <kees@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Nathan Chancellor <nathan@kernel.org>,
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
	kvmarm@lists.linux.dev,
	linux-kselftest <linux-kselftest@vger.kernel.org>
Subject: Re: [PATCH] Documentation: KVM: Document guest-visible compatibility
 expectations
Message-ID: <agzq5kwzuJvd7Mh5@kernel.org>
References: <3f9d731c3d26b0367600f1069e6425099bc34eac.camel@infradead.org>
 <agxFbniU_6eQ98t2@willie-the-truck>
 <cf429f2082e863571595f74d1d3dedc3e6a82964.camel@infradead.org>
 <CABgObfacAYexR25SMi1kSZMRnHx3EDGj8=E84V1DumER66ibnQ@mail.gmail.com>
 <86qzn7wp3y.wl-maz@kernel.org>
 <593a782c50f3c8656e13b36dfb975a67d43a908e.camel@infradead.org>
 <CABgObfbS-z3OphDna5W_JQPvw+OK=yXJurVMHp1ANZ5uGEgVhQ@mail.gmail.com>
 <9d0429ddbe4d8c6993e74237c4395697f80092d6.camel@infradead.org>
 <agzR2kaJsNa8X9lF@kernel.org>
 <1243d375846c4f4e20c229a6f09300126188fc8b.camel@infradead.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1243d375846c4f4e20c229a6f09300126188fc8b.camel@infradead.org>

On Tue, May 19, 2026 at 10:58:05PM +0100, David Woodhouse wrote:
> On Tue, 2026-05-19 at 14:10 -0700, Oliver Upton wrote:
> > And in the absence of clear evidence of a guest depending on the broken
> > IGROUPR behavior, I don't see how the guest-side changes of Christoffer's
> > series are any different from the multitude of bug fixes that we take
> > every single release cycle. It is an unfortunate bug and I concur with
> > Marc that it doesn't seem like the sort of thing a guest could rely
> > upon.
> 
> I find this concerning, because I've already explained this.
> 
> There is a very real possibility of guests simply not *noticing* that
> they had bugs in this area, as it didn't *matter* what they wrote to
> these registers since it never worked.
> 
> There is an even larger possibility of guests having worked around the
> original issue by *detecting* whether the registers were actually
> writable before choosing to use the alternative groups. And if such a
> guest launches on a new kernel and then needs to be rolled back to an
> older kernel, that will also break.

The onus is on you to substantiate this claim. I would imagine after
carrying the revert for so long that there must be at least one example
of such a guest?

What ifs and maybes do not meet the bar, in my opinion, for preserving
bug emulation in KVM. Of course there could be a little flexibility with
that but we need to have some way of discriminating between bug fixes
and genuine guest expectations around the behavior of virtual hardware.

> > Wrong or not, this behavior is documented unambiguously. From the VGICv2
> > UAPI documentation:
> > 
> > """
> > Userspace should set GICD_IIDR before setting any other registers (both
> > KVM_DEV_ARM_VGIC_GRP_DIST_REGS and KVM_DEV_ARM_VGIC_GRP_CPU_REGS) to ensure
> > the expected behavior. Unless GICD_IIDR has been set from userspace, writes
> > to the interrupt group registers (GICD_IGROUPR) are ignored.
> > """
> > 
> > I'm not inclined to change that.
> 
> That'll all very well... but as far as I can tell, QEMU *doesn't* set
> GICD_IIDR, so it still gets the bizarre behaviour where the *guest* can
> write the registers, but userspace can't. So it looks like it'll work
> except migration will fail. Am I missing something?

That's exactly it, and why I said tying up UAPI opt-in with
guest-visible registers is a really bad idea.

> But honestly, I don't care one iota about GICv2; I was only trying to
> do the cleanup while I was there. Feel free to drop that part entirely.
> 
> >  As a way out of this whole mess, can we
> > instead:
> > 
> >  - Allow userspace to set IIDR.Revision to 1
> > 
> >  - Drop any bug emulation from the handling of IGROUPR registers
> 
> It doesn't make sense to allow setting IIDR.Revision to 1 *without* the
> one-liner that actually implements the corresponding behaviour change
> in the IGROUPR registers.

As I described earlier, this whole IIDR crap inarguably broke UAPI and
obviously normal guest behavior (i.e. reading the register). At minimum
we need to permit previously-valid values for IIDR, even if they carry
no implied behaviors.

> And as explained at least twice now, it's the
> behaviour change that's *important* here.
> 
> The fact that it's a long-standing bug in KVM which downstream has been
> working around for a long time doesn't matter. The unconditional
> behavioural change *is* a bug and we should fix it.

That is the nature of a bug fix. If you can provide some concrete
evidence of a guest depending on the RAZ/WI behavior then I agree we
need to preserve the old behavior.

Otherwise I see this as a matter of principle in how we do bug fixes to
KVM. Even if upstream took the strictest possible stance towards behavior
changes we will invariably fail to account for some minutia.

> >  - Special-case the stupid GICv2 UAPI where IGROUPR are only writable if
> >    the VMM has written to IIDR and the revision >= 2
> 
> That already *is* a special case, right? And you'd rather leave it as it is?

Left as documented, yes. With the exception that revision == 1 writes
not be considered opt-in to restorable IGROUPR.

Thanks,
Oliver
