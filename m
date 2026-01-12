Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA7893559CB
	for <kvmarm@lists.linux.dev>; Mon, 12 Jan 2026 14:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768226603; cv=none; b=cGw3Z7nl5AoMlZt35gWtQOn5+JDUsjn8ccsqsB9vNtOBRgVeAfbNa3BAGUJXcbka/Yhx+tjp8/jnp42vduPYosp0TiAIxvAdiyMob2hGHkZDJ32I2ZLYUsTV6KGJLhyW6PITDBueFzAoDgn911000MIT9wRLl8Hgz7FAB0Wh3GI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768226603; c=relaxed/simple;
	bh=351xlPLPHWggasaukz8wC3TwRxXEKXyzMziu0JkTjhM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RnmhJVD/rNZ+6zwqeH+ONd7gbeZ6qSpwHSQdA6r3F/wi98rTls5ZfGcSbsorvjL8RY5pGy5trdPKy8LNODh/LoelzJWGlEJ+PRyKh+I/9do/xzEFIXmAfXTiMhewSw8LaIL+17LWbZHrEWsjJcMvDlaSlBXuvz4PxO1QUTwmgvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 91536497;
	Mon, 12 Jan 2026 06:03:11 -0800 (PST)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 305273F59E;
	Mon, 12 Jan 2026 06:03:16 -0800 (PST)
Date: Mon, 12 Jan 2026 14:03:13 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: James Clark <james.clark@linaro.org>
Cc: mark.rutland@arm.com, james.morse@arm.com, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, will@kernel.org, catalin.marinas@arm.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Subject: Re: [RFC PATCH v6 14/35] KVM: arm64: Add SPE VCPU device attribute
 to set the max buffer size
Message-ID: <aWT_Ic9HeWbtZLI5@raptor>
References: <20251114160717.163230-1-alexandru.elisei@arm.com>
 <20251114160717.163230-15-alexandru.elisei@arm.com>
 <c6e1f67c-6c71-4785-a1b9-3be2acee2a3a@linaro.org>
 <aWTaw_T6jak7Etj1@raptor>
 <3cf80979-e826-4200-8dad-6ac4738f6463@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3cf80979-e826-4200-8dad-6ac4738f6463@linaro.org>

Hi James,

On Mon, Jan 12, 2026 at 11:50:25AM +0000, James Clark wrote:
> 
> 
> On 12/01/2026 11:28 am, Alexandru Elisei wrote:
> > Hi James,
> > 
> > On Fri, Jan 09, 2026 at 04:29:43PM +0000, James Clark wrote:
> > > 
> > > 
> > > On 14/11/2025 4:06 pm, Alexandru Elisei wrote:
> > > > During profiling, the buffer programmed by the guest must be kept mapped at
> > > > stage 2 by KVM, making this memory pinned from the host's perspective.
> > > > 
> > > > To make sure that a guest doesn't consume too much memory, add a new SPE
> > > > VCPU device attribute, KVM_ARM_VCPU_MAX_BUFFER_SIZE, which is used by
> > > > userspace to limit the amount of memory a VCPU can pin when programming
> > > > the profiling buffer. This value will be advertised to the guest in the
> > > > PMBIDR_EL1.MaxBuffSize field.
> > > > 
> > > > Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> > > > ---
> > > >    Documentation/virt/kvm/devices/vcpu.rst |  49 ++++++++++
> > > >    arch/arm64/include/asm/kvm_spe.h        |   6 ++
> > > >    arch/arm64/include/uapi/asm/kvm.h       |   5 +-
> > > >    arch/arm64/kvm/arm.c                    |   2 +
> > > >    arch/arm64/kvm/spe.c                    | 116 ++++++++++++++++++++++++
> > > >    5 files changed, 176 insertions(+), 2 deletions(-)
> > > > 
> > > > diff --git a/Documentation/virt/kvm/devices/vcpu.rst b/Documentation/virt/kvm/devices/vcpu.rst
> > > > index e305377fadad..bb1bbd2ff6e2 100644
> > > > --- a/Documentation/virt/kvm/devices/vcpu.rst
> > > > +++ b/Documentation/virt/kvm/devices/vcpu.rst
> > > > @@ -347,3 +347,52 @@ attempting to set a different one will result in an error.
> > > >    Similar to KVM_ARM_VCPU_PMU_V3_CTRL(KVM_ARM_VCPU_PMU_SET_PMU), userspace is
> > > >    responsible for making sure that the VCPU is run only on physical CPUs which
> > > >    have the specified SPU.
> > > > +
> > > > +5.3 ATTRIBUTE: KVM_ARM_VCPU_MAX_BUFFER_SIZE
> > > > +------------------------------------------
> > > > +
> > > > +:Parameters: in kvm_device_attr.addr the address to an u64 representing the
> > > > +             maximum buffer size, in bytes.
> > > > +
> > > > +:Returns:
> > > > +
> > > > +	 =======  =========================================================
> > > > +	 -EBUSY   Virtual machine has already run
> > > > +	 -EDOM    Buffer size cannot be represented by hardware
> > > > +	 -EFAULT  Error accessing the max buffer size identifier
> > > > +	 -EINVAL  A different maximum buffer size already set or the size is
> > > > +                  not aligned to the host's page size
> > > > +	 -ENXIO   SPE not supported or not properly configured
> > > > +	 -ENODEV  KVM_ARM_VCPU_HAS_SPE VCPU feature or SPU instance not set
> > > 
> > > Hi Alex,
> > > 
> > > I can't reproduce this anymore, but I got this a few times. Or at least I
> > > think it was this, I've pasted the output from kvmtool below and it doesn't
> > > say exactly what the issue was.
> > 
> > I'll try to reproduce it.
> > 
> > Do you remember what were the HEAD commits for the host and kvmtool?
> > 
> 
> I was testing on N1SDP with the SPE driver changes as well so it has a load
> of junk, although I don't think any could have caused this intermittent
> issue. I wouldn't put too much effort into it though because it could have
> been a stale build or something:
> 
>  https://gitlab.com/Linaro/kwg/james-c-linux/-/tree/james-testing-kvm-spe-v6
> 
> kvmtool is just 8890373d5e62 from your kvm-spe-v6 branch

Ok, then I'll only try a few times to create a VM with your command line and see
if I hit this. If not, I'll just assume it was something on your side until
proven otherwise :)

> 
> 
> > > 
> > > If I tried again with a different buffer size it worked, then going back to
> > > 256M didn't work, then it went away. I might have done something wrong so if
> > > you didn't see this either then we can probably ignore it for now.
> > > 
> > >   -> sudo lkvm run --kernel /boot/vmlinux-6.18.0-rc2+ -p "earlycon
> > >      kpti=off" -c 4 -m 2000 --pmu --spe --spe-max-buffer-size=256M
> > > 
> > >    Info: # lkvm run -k /boot/vmlinux-6.18.0-rc2+ -m 2000 -c 4 --name
> > >    guest-616
> > >    KVM_SET_DEVICE_ATTR: No such device or address
> > > 
> > > 
> > > > +	 -ERANGE  Buffer size larger than maximum supported by the SPU
> > > > +                  instance.
> > > > +	 =======  ==========================================================
> > > > +
> > > > +Required.
> > > > +
> > > > +Limit the size of the profiling buffer for the VCPU to the specified value. The
> > > > +value will be used by all VCPUs. Can be set for more than one VCPUs, as long as
> > > > +the value stays the same.
> > > > +
> > > > +Requires that a SPU has been already assigned to the VM. The maximum buffer size
> > > 
> > > Very minor nit, but would "Initialised with SPE" be better? Because it's
> > > done through KVM_ARM_VCPU_INIT rather than "ASSIGN_SPU". I think it might
> > > make it easier to understand how you are supposed to use it.
> > > 
> > > SPU is never expanded either and I think users probably wouldn't be familiar
> > > with what that is. A lot of times we could just say "has SPE" and it would
> > > be clearer. I don't think separating the concepts of SPE and SPU gives us
> > > anything in this high level of a doc other than potentially confusing users.
> > 
> > Sure.
> > 
> > > 
> > > > +must be less than or equal to the maximum buffer size of the assigned SPU instance,
> > > 
> > > I don't understand this part. Do you mean "of the assigned physical SPU
> > > instance"? The ARM states "no limit" is the only valid value here:
> > 
> > Yes, physical instance.
> > 
> > > 
> > >    Reads as 0x0000
> > >    The only permitted value is 0x0000, indicating there is no limit to
> > >    the maximum buffer size.
> > > 
> > > It would be good to expand on where the limit you are talking about comes
> > > from.
> > 
> > The hardware value might change in the future. Or the host might be running
> > under nested virtualization, which makes having a different value likely.  Like
> > you said above, I don't think it's necessary to get into this much detail here -
> > the idea I was trying to convey is that userspace cannot set the maximum buffer
> > size to a value larger than what the physical SPU instance supports.
> > 
> 
> Ok makes sense, thanks.
> 
> > > 
> > > > +unless there is no limit on the maximum buffer size for the SPU. In this case
> > > > +the VCPU maximum buffer size can have any value, including 0, as long as it can
> > > > +be encoded by hardware. For details on how the hardware encodes this value,
> > > > +please consult Arm DDI0601 for the field PMBIDR_EL1.MaxBuffSize.
> > > > +
> > > > +The value 0 is special and it means that there is no upper limit on the size of
> > > > +the buffer that the guest can use. Can only be set if the SPU instance used by
> > > > +the VM has a similarly unlimited buffer size.
> > > 
> > > This is a comment about changes in kvmtool, but it's semi related so I'll
> > > leave it here. But you say only half of the buffer is used at a time:
> > > 
> > >    In a guest, perf, when the user is root, uses the default value of 4MB
> > >    for the total size of the profiling memory.  This is split in two by
> > >    the SPE driver, and at any given time only one half (2MB) is
> > >    programmed for the SPE buffer.
> > > 
> > >    However, KVM also has to pin the stage 1 translation tables that
> > >    translate the buffer, so if the default were 2MB, KVM would definitely
> > >    exceed this value. Make the default 4MB to avoid potential errors when
> > >    the limit is exceeded.
> > > 
> > > But isn't that just for snapshot mode? In normal mode the half way point is
> > > set to perf_output_handle->wakeup which comes from the watermark set by
> > > userspace? If you set it to the end then in theory the whole buffer could be
> > > used?
> > 
> > Sure, I'll change the comment to say that 4MiB was chosen because that was the
> > default in perf, and not go into more details.
> > 
> > Thanks,
> > Alex
> > 
> 
> I don't know if kvmtool is going to get used in production, or if anyone is
> going to copy this default value though? If that might happen then maybe a
> bigger value is better in case there is some tool or script that has a
> different watermark setting and it doesn't work.

kvmtool is not used in production as far as I know. But it's good to have a sane
default value, because like you've said it might be borrowed by other software.

I'm not sure what you are saying though. Do you think that there's a better
default value or that kvmtool shouldn't have a default value at all?

> 
> I think we can assume that if someone is enabling SPE then they're not
> memory constrained and we don't need to worry about saving a few MB.

On the countrary, the entire reason for having a maximum buffer size property in
the arhitecture is that people want to use SPE and be able to limit the amount
of memory that a guest can pin because they want to oversubscribe memory for
VMs. I would say that qualifies as a memory constrained environment.

Thanks,
Alex
