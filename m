Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C06DF3DCD94;
	Tue, 19 May 2026 21:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779225053; cv=none; b=oi0oAz1EemAi9ZcVg+qCexUW62zfyXWEs5Z7k4i/TTQ0K2VUDd+GcSH3A0bAl2Ds6y9hA4Fh1mMRKLUNnx8hX7nwdaSGRGgYg8shUnEwyjzPF4TaBnhrZTgJ4rrOmo+y6vsFeb5LB72KdPc/vYUe9PrvJpnIrMG4pcRswvQUSck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779225053; c=relaxed/simple;
	bh=PMBbCkriMIJCPtnxEiVilsP0qVT+oqDX7B6s76Q9GBo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iJEFVZDiCId7/Q3yyr+qmlxPllXL8D+rth97uKok1WZv6EVqfT+ShzpwgcgaRUTIPharOxsvfxvkVypPwWIXFos4jesk5ERk6YCT2QZf5qtfTXci4Z1b07aRPBpsukyxUfNNz/g4yjpiJaVSHVFK+gsRo+Pm1YDzjb2V+EJJxoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PpF+/Qs+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PpF+/Qs+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C9C41F000E9;
	Tue, 19 May 2026 21:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779225052;
	bh=/J21S+Ld/hEhF27pPKSQ3l92mo4qOAr3o1Wi79JUnPo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PpF+/Qs+ycT4A8rWHJ/2DlTEDC2i0j/k3x9lrVRnSVvoqOOYYCaH5oDvCXXHRfgAW
	 y1nzP4QlnoFKEjFtRVrSTHhl7gLvWebJ2lt1VrAbGbVEEEWhCzSXhkfe3kwZ+Tv91F
	 WIkkGeNJsBlHxHEj9qdnVRmc3v6Jgi2dzvhHcT+JAmrlnsGeguE3WlCTEuB1tRZTud
	 3bLAPhSMMQzLOaGYixd4SPKTsWHWm1bSqOWWUln6tiYSNTjaGkrRWYybGHryRNNsO7
	 7lv/z7sGNzkLVvCxn2RZVMzjfDjStBmvCbEDlS5i7BNE0sCXMW1h+YsUFTlGgTtycQ
	 bzBCjf8IrvBDg==
Date: Tue, 19 May 2026 14:10:50 -0700
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
Message-ID: <agzR2kaJsNa8X9lF@kernel.org>
References: <d9d4471a7f5ec1e297b3ca07f42a59090aa91e15.camel@infradead.org>
 <CABgObfaM-JtNn2MuYXaiadQnLfAhTEaoHAcTG9=J6LkMcQCJ3A@mail.gmail.com>
 <3f9d731c3d26b0367600f1069e6425099bc34eac.camel@infradead.org>
 <agxFbniU_6eQ98t2@willie-the-truck>
 <cf429f2082e863571595f74d1d3dedc3e6a82964.camel@infradead.org>
 <CABgObfacAYexR25SMi1kSZMRnHx3EDGj8=E84V1DumER66ibnQ@mail.gmail.com>
 <86qzn7wp3y.wl-maz@kernel.org>
 <593a782c50f3c8656e13b36dfb975a67d43a908e.camel@infradead.org>
 <CABgObfbS-z3OphDna5W_JQPvw+OK=yXJurVMHp1ANZ5uGEgVhQ@mail.gmail.com>
 <9d0429ddbe4d8c6993e74237c4395697f80092d6.camel@infradead.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9d0429ddbe4d8c6993e74237c4395697f80092d6.camel@infradead.org>

On Tue, May 19, 2026 at 03:13:30PM +0100, David Woodhouse wrote:
> On Tue, 2026-05-19 at 15:53 +0200, Paolo Bonzini wrote:
> > On Tue, May 19, 2026 at 3:00 PM David Woodhouse <dwmw2@infradead.org> wrote:
> > > Or some guest configurations which have only ever been tested under KVM
> > > could have a bug where they *rely* on the registers not being writable,
> > > and write values which are inconsistent with the rest of their
> > > configuration. Which breaks the moment those registers become writable.
> > 
> > Yeah, just having guests that worked by utter chance - but you still
> > don't want to break them - is the case that is most likely. Crappy
> > code that runs only under emulation/virtualization appears with
> > probability 1 over time.
> > 
> > Is this likely in this specific case---probably not, honestly.
> > Christoffer's patch dates back to 2018 (commit d53c2c29ae0d); *back
> > then* KVM/Arm was a lot less mature, and people developing for Arm on
> > vanilla upstream kernels have moved on from Linux 4.19.
> 
> It's not really 2018 though. EC2 is still running kernels with that
> older commit reverted because of the breaking change that it
> introduced.
> 
> So the behaviour corresponding to GICD_IIDR.implementation_rev=1 is
> still current for *millions* of guests.
> 
> I'm now finding that revert in our tree during a *later* kernel upgrade
> and trying to eliminate it. 

Still, as far as upstream is concerned this is damn near a decade old.
Decisions that you or your peers made in the downstream doesn't change
that.

> And sure, I have given the engineers responsible for that a very hard
> stare and suggested that they should have fixed it 'properly' in the
> first place with a patch like the one we're discussing right now.
> 
> And they're looking at this thread and saying "haha no, if fixing
> things properly for Arm is this hard then we'll stick with the crappy
> approach".

The appropriate time to ask for accomodation was a *very* long time ago.

And in the absence of clear evidence of a guest depending on the broken
IGROUPR behavior, I don't see how the guest-side changes of Christoffer's
series are any different from the multitude of bug fixes that we take
every single release cycle. It is an unfortunate bug and I concur with
Marc that it doesn't seem like the sort of thing a guest could rely
upon.

Because it is very much a bug fix, it should've happened without a
change to the revision number.

Now, the handling of GICD_IIDR itself is a separate issue. By my count,
the series broke UAPI on three separate occasions. Before b489edc36169
IIDR was RAZ/WI from userspace. And of course dd6251e463d3 and d53c2c29ae0d
changed the revision with no way of restoring the old value.

And really, IIDR should've *never* been used as a buy in for new UAPI
because it unnecessarily becomes guest visible. 49a1a2c70a7f ("KVM: arm64:
vgic-v3: Advertise GICR_CTLR.{IR, CES} as a new GICD_IIDR revision") is
a much better example for IIDR going forward as it gates *guest-side*
behavior.

> I do not want them to be right. I don't think any of us want that.
> 
> > I would still lean towards accepting the code considering the limited
> > complexity of the addition (in fact I like it more now that it uses
> > IIDR instead of v2_groups_user_writable, but that's taste). 
> 
> I'm absolutely prepared to have a separate technical discussion about
> the v2_groups_user_writable thing for GICv2, which is the second part
> of that series.
> 
> It seems like the right thing to do, and as far as I can tell, this
> code *never* worked with QEMU. But I'm not sure who even cares about
> GICv2 any more. I couldn't find hardware and I had to test the whole
> thing inside qemu-tcg.
> 
> But the 'IIDR defaults to 3 but the *behaviour* doesn't match until you
> explicitly *set* it to 3' thing seemed so *egregiously* wrong to me,
> that I fixed it anyway.

Wrong or not, this behavior is documented unambiguously. From the VGICv2
UAPI documentation:

"""
Userspace should set GICD_IIDR before setting any other registers (both
KVM_DEV_ARM_VGIC_GRP_DIST_REGS and KVM_DEV_ARM_VGIC_GRP_CPU_REGS) to ensure
the expected behavior. Unless GICD_IIDR has been set from userspace, writes
to the interrupt group registers (GICD_IGROUPR) are ignored.
"""

I'm not inclined to change that. As a way out of this whole mess, can we
instead:

 - Allow userspace to set IIDR.Revision to 1

 - Drop any bug emulation from the handling of IGROUPR registers

 - Special-case the stupid GICv2 UAPI where IGROUPR are only writable if
   the VMM has written to IIDR and the revision >= 2

Thanks,
Oliver
