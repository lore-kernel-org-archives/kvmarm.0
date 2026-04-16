Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CAF2329E5A
	for <kvmarm@lists.linux.dev>; Thu, 16 Apr 2026 17:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776361514; cv=pass; b=dprIguv44CaCjVw7G+vlTFs7/SBceIpY8UhDw8He9JvLFuPvLfDITkoJdpeijv7yIfHf5voNa64TvuUAaHg5FrjpRYEJp/FEdgteAUCQx51PLzDtled+/alul24aPejbM/fJNkPms809dwVOhtjUZ1qSrlSSeIQDbqqNuY+ZT5I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776361514; c=relaxed/simple;
	bh=jzm6W1Z6bNw1R7/BddIGRoaarTGeMoKKc61rcr/dEKQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AwNdAPrvZBZ/IOmL7Lak373n5bZGH/L5HqMdbz7qRrvn7QWg8X5Z936bzYvx3A5tzIQyIbhM2GNTe0zex6MFabyU5fvH8KBM0hmFargQjJdtAJTATuCsnegi/8JL/CimPUKkJg/RzjzhK06oe4UiMd3CYcsJkUYwo73SiTCUsu8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rBL4NAH3; arc=pass smtp.client-ip=209.85.219.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rBL4NAH3"
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-8a5800772f3so66034026d6.2
        for <kvmarm@lists.linux.dev>; Thu, 16 Apr 2026 10:45:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776361512; cv=none;
        d=google.com; s=arc-20240605;
        b=jx0UizCKRygMmXhbCXU+GGt7Jz22O/sHH7PzxvWdEU4IX+OeBaPpNDHOL7bxwnmUwq
         5ElMf+G3PSpzKbgmAr3MwVa/o8Xzden3Nd9w9wFdOyE0u0pGNkorCkOtNNy+cgaQkKw0
         AAhKKGkg+bckvhewaNH0nBhyPuX6vu63oSk8p443mWi0W4KmFVEo+PPrEUpFurbw3R0z
         z0f99AiP9ZkwTJxgwUo/k0RtZpUYqiMcE0vQ15NXNEXPJmWrjzJT1o03oXzLSja1P2bW
         TOQahncxke0ODLYOSjCR0p6bRmZ7TTlyCQt5HrbDUpPTosqQE6CWU6ZJt3JqyEybpgCD
         TkQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=jzm6W1Z6bNw1R7/BddIGRoaarTGeMoKKc61rcr/dEKQ=;
        fh=lb9Qjor4ERM2/p2iPIStu+7isd3ttyo+5FOJfDmaPgI=;
        b=lBMYbF/PSuw4Ye/j1UjfBuj3CVLpeqVGThINIuPt3XEj9dCJn0RaC7z5ddkkdj0FRs
         yEU/OzcPXK1tpzgObqM8qFQakJc73mrAWp4X5qDXKxv+idvPRZyKUokNy+Je3P2q+tGE
         nXlNfWXs0i7JC7v9fy5QKW05APOQqU4sSexbIy0YsuZzRO1MDFvW8jWkYztC0Zr+EjeU
         Mdu8jk3NXLnNRJNspfRCIpZYcw9C9whlaZGL2vSf+P1RgeBnELkAbW6c9QVFXWaGqT5F
         W1kOsUW2qTxxww7nLTDHrqnkguSjWUtvwlFT+NUnM+t3RHRM5n5TltNcqWOzGicnr2N5
         q7tA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776361512; x=1776966312; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jzm6W1Z6bNw1R7/BddIGRoaarTGeMoKKc61rcr/dEKQ=;
        b=rBL4NAH3mxcczWVnsHfQuUhrJ4XedsG6xmXY4mj+3G3BYz4YSQFFvtyuEz7oVnWb0N
         tTimDW0t9dsTbJhuYZqn5SnWN2nbAlnhPBLfQ0nnmvMirEUbT87LyMM45PCRVEXYB1GZ
         5xCFdB7+Uglvk47PrTQ7kp+y1bEfzVBtDfR3Mh6xb356kjQL5ZZbSwgrwuzXMdZi8Zvq
         uYU+cw2G0QtWAckDP1+r7216EYbYr5ygT0jMVg7UTfqxc2oykf+/OThz+cFDwG805NfQ
         atdyUwNI2KVcJWjz1pZUrR9zTQUUMQZB2Lm8QEJ0Td/SbUCQE2IX/k8AEaNmxDoog+G9
         KQ+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776361512; x=1776966312;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jzm6W1Z6bNw1R7/BddIGRoaarTGeMoKKc61rcr/dEKQ=;
        b=WnfrTdh2/c5b5oVtcgv7TETJ8np7lXfQ0txPphRCcHwNwmUPTSCPObGCELpEWq5tEc
         hrpaSEFAIQljS4uAuDGJ8T9O3bxdXYvYm0H965hT9TF6EubpE5MyeTM5I+tnDgdjFYHw
         rj6HOJSBJxiKjVZikB6K/dXpzVIOLMNJ50UdbJB9ZsRgkHsioG62LqxGK1Af//gE8xhD
         g5Ip0QjcaeMeZyyrkW3nT59bCusktlgxZdcraic9wBgrruiK/P5bugct1xbHnu+FSyyn
         lPpuVHdwdJe0OC5sp9tssNma7mY+l1mlNS/wU0C1nSkBi5EFqCbjwk0kYM7GfM8GIhFc
         pt6w==
X-Forwarded-Encrypted: i=1; AFNElJ8l6eLBkc2NPTlG9X2Jqi3+VuXhY5+B6eqzZLfP0kma+EHInzOl7qkSQTwaUFRKSLRAqxiwjOU=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzy1drOtUcIOBxcU1cwEjCv0+LZbIwMkRm/jAs2jlDqZ1utASW5
	y/1K8mGy0ljaDQbctbmHDGm+FLtATKprYbpRvtbniTgT8dSxLtXFrgKxcpLI9NUPqm2d06a2Zek
	kzBjDp48AdIh13u7jFG6A7ezOJzKzvTH22bfTZ05D
X-Gm-Gg: AeBDietrw7+Ho23VGpaWk0Wd/EZoBj4uzqxGZGj1k5DXiqRBr3UlB2BEIB9+ewIYdEf
	SAbLJbniPYX836MCN8ub7NdqJ7dcAxVwcSVPPs9E9NEekjMqlglg/rMx0MrR3K0f1lARf/adAe1
	xRFTQ9D9o2HJj7U8OpqwZfw3da3v3TDV/6yXezCX2UJmzNDkSYRhpCbwbsFS+bDHEhbpSEzQLzi
	1T1snzKGPTVQ6DXM33dgl/rt0hxalqk7T9i9c3mEZ9md7orwekUBnzddVeFiJbYpgIZMJVIu3Tp
	hP/vm1Vq64h2HMTHo3xjsl4UNx17KfKg/NYB3DK9NhSXYQGaVXHEJZ/jhkY=
X-Received: by 2002:a05:6214:4b0c:b0:8ac:a0b0:64d5 with SMTP id
 6a1803df08f44-8b025ec904dmr2618146d6.37.1776361511320; Thu, 16 Apr 2026
 10:45:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260318155413.793430-1-steven.price@arm.com> <CABpDEukEO4Y_fg8fv5Nr1_Pw_qOK=2UmioXk=WyPEzoEprPcGA@mail.gmail.com>
 <d661a24c-6619-4734-96bd-075d3416e809@arm.com> <CABpDEumAVf02uOS5Bj07EDyuU=z9FV-iocQU1j7gFM5z0BeV_w@mail.gmail.com>
 <97d26e6e-b565-447f-95eb-2ece0755fe57@arm.com>
In-Reply-To: <97d26e6e-b565-447f-95eb-2ece0755fe57@arm.com>
From: Alper Gun <alpergun@google.com>
Date: Thu, 16 Apr 2026 10:44:59 -0700
X-Gm-Features: AQROBzAsj7mxI_HflVua65l9TneHSVQXwlFi8oSRcQgYzKeZgfQilvBV9R8pGsg
Message-ID: <CABpDEu=vbo9cDL1PKh2h9JjWCHPP3M9-ueogkPc571c1OQPuhA@mail.gmail.com>
Subject: Re: [PATCH v13 00/48] arm64: Support for Arm CCA in KVM
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, 
	James Morse <james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Zenghui Yu <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, 
	Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev, 
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, Gavin Shan <gshan@redhat.com>, 
	Shanker Donthineni <sdonthineni@nvidia.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>, 
	Emi Kisanuki <fj0570is@fujitsu.com>, Vishal Annapurve <vannapurve@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 16, 2026 at 4:05=E2=80=AFAM Suzuki K Poulose <suzuki.poulose@ar=
m.com> wrote:
>
> On 16/04/2026 00:27, Alper Gun wrote:
> > On Wed, Apr 15, 2026 at 4:01=E2=80=AFAM Steven Price <steven.price@arm.=
com> wrote:
> >>
> >> On 14/04/2026 22:40, Alper Gun wrote:
> >>> On Wed, Mar 18, 2026 at 8:54=E2=80=AFAM Steven Price <steven.price@ar=
m.com> wrote:
> >>>>
> >>>> This series adds support for running protected VMs using KVM under t=
he
> >>>> Arm Confidential Compute Architecture (CCA).
> >>>>
> >>>> New major version number! This now targets RMM v2.0-bet0[1]. And unl=
ike
> >>>> for Linux this represents a significant change.
> >>>>
> >>>> RMM v2.0 brings with it the ability to configure the RMM to have the
> >>>> same page size as the host (so no more RMM_PAGE_SIZE and dealing wit=
h
> >>>> granules being different from host pages). It also introduces range
> >>>> based APIs for many operations which should be more efficient and
> >>>> simplifies the code in places.
> >>>>
> >>>> The handling of the GIC has changed, so the system registers are use=
d to
> >>>> pass the GIC state rather than memory. This means fewer changes to t=
he
> >>>> KVM code as it looks much like a normal VM in this respect.
> >>>>
> >>>> And of course the new uAPI introduced in the previous v12 posting is
> >>>> retained so that also remains simplified compared to earlier posting=
s.
> >>>>
> >>>> The RMM support for v2.0 is still early and so this series includes =
a
> >>>> few hacks to ease the integration. Of note are that there are some R=
MM
> >>>> v1.0 SMCs added to paper over areas where the RMM implementation isn=
't
> >>>> quite ready for v2.0, and "SROs" (see below) are deferred to the fin=
al
> >>>> patch in the series.
> >>>>
> >>>> The PMU in RMM v2.0 requires more handling on the RMM-side (and
> >>>> therefore simplifies the implementation on Linux), but this isn't qu=
ite
> >>>> ready yet. The Linux side is implemented (but untested).
> >>>>
> >>>> PSCI still requires the VMM to provide the "target" REC for operatio=
ns
> >>>> that affect another vCPU. This is likely to change in a future versi=
on
> >>>> of the specification. There's also a desire to force PSCI to be hand=
led
> >>>> in the VMM for realm guests - this isn't implemented yet as I'm wait=
ing
> >>>> for the dust to settle on the RMM interface first.
> >>>>
> >>>> Stateful RMI Operations
> >>>> -----------------------
> >>>>
> >>>> The RMM v2.0 spec brings a new concept of Stateful RMI Operations (S=
ROs)
> >>>> which allow the RMM to complete an operation over several SMC calls =
and
> >>>> requesting/returning memory to the host. This has the benefit of
> >>>> allowing interrupts to be handled in the middle of an operation (by
> >>>> returning to the host to handle the interrupt without completing the
> >>>> operation) and enables the RMM to dynamically allocate memory for
> >>>> internal tracking purposes. One example of this is RMI_REC_CREATE no
> >>>> longer needs "auxiliary granules" provided upfront but can request t=
he
> >>>> memory needed during the RMI_REC_CREATE operation.
> >>>>
> >>>> There are a fairly large number of operations that are defined as SR=
Os
> >>>> in the specification, but current both Linux and RMM only have suppo=
rt
> >>>> for RMI_REC_CREATE and RMI_REC_DESTROY. There a number of TODOs/FIXM=
Es
> >>>> in the code where support is missing.
> >>>>
> >>>> Given the early stage support for this, the SRO handling is all conf=
ined
> >>>> to the final patch. This patch can be dropped to return to a pre-SRO
> >>>> state (albeit a mixture of RMM v1.0 and v2.0 APIs) for testing purpo=
ses.
> >>>>
> >>>> A future posting will reorder the series to move the generic SRO sup=
port
> >>>> to an early patch and will implement the proper support for this in =
all
> >>>> RMI SMCs.
> >>>>
> >>>> One aspect of SROs which is not yet well captured is that in some
> >>>> circumstances the Linux kernel will need to call an SRO call in a
> >>>> context where memory allocation is restricted (e.g. because a spinlo=
ck
> >>>> is held). In this case the intention is that the SRO will be cancell=
ed,
> >>>> the spinlock dropped so the memory allocation can be completed, and =
then
> >>>> the SRO restarted (obviously after rechecking the state that the
> >>>> spinlock was protecting). For this reason the code stores the memory
> >>>> allocations within a struct rmi_sro_state object - see the final pat=
ch
> >>>> for more details.
> >>>>
> >>>> This series is based on v7.0-rc1. It is also available as a git
> >>>> repository:
> >>>>
> >>>> https://gitlab.arm.com/linux-arm/linux-cca cca-host/v13
> >>>>
> >>>>
> >>>
> >>> Hi Steven,
> >>>
> >>> I have a question regarding host kexec and kdump scenarios, and
> >>> whether there is any plan to make them work in this initial series.
> >>>
> >>> Intel TDX and AMD SEV-SNP both have a firmware shutdown command that
> >>> is invoked during the kexec or panic code paths to safely bypass
> >>> hardware memory protections and boot into the new kernel. As far as
> >>> I know, there is no similar global teardown command available for
> >>> the RMM.
> >>
> >> Correct, the RMM specification as it stands doesn't provide a mechanis=
m
> >> for the host to do this. The host would have to identify all the realm
> >> guests in the system: specifically the address of the RDs (Realm
> >> Descriptors) and RECs (Realm Execution Contexts). It needs this to tea=
r
> >> down the guests and be able to undelegate the memory.
> >>
> >> It's an interesting point and I'll raise the idea of a "firmware
> >> shutdown command" to make this more possible.
> >>
> >>> What is the roadmap for supporting both general kexec and
> >>> more specifically kdump (panic) scenarios with CCA?
> >>
> >> I don't have a roadmap I'm afraid for these. kexec in theory would be
> >> possible with KVM gracefully terminating all realms. For kdump/panic
> >> that sort of graceful shutdown isn't really appropriate (or likely to
> >> succeed).
> >>
> >
> > Thanks Steven for the clarification.
> >
> > For us, kdump is highly critical as it is our primary diagnostic tool
> > for host crashes. Without it, monitoring and debugging at fleet scale
> > would become unmanageable.
> >
> > To confirm my understanding of the current architecture: if a host
> > panics while no Realms are actively running (and therefore no pages
> > are currently in the delegated state), the standard kdump extraction
> > should work perfectly fine without any modifications, correct?
>
> This may not be true. We could have pages donated to RMM for GPT,
> Tracking etc. So, unless Linux keeps track of them, it may be
> unsafe for a crash kernel to access them.
>
> >
> > Regarding the KVM tracking structures (RDs, RECs, RTTs, etc.) when VMs
> > are running, perhaps we could use `vmcoreinfo` to export the physical
> > addresses of these delegated pages. This would allow tools like
>
> Thinking of this, do we really need to ? We could access the pages from
> "vmcore" read and handle the GPFs for such accesses and give out 0s
> for the Granules. Anyways, we can't get access to the data on those
> pages that are still in Realm PAS.
>

I like the idea of handling the GPFs directly during vmcore reads for
kdump case. That's much simpler\cleaner solution.

> > `makedumpfile` to explicitly filter them out. I assume these pages must
> > remain hardware-locked while the VMs are active.
>
>
>
> >
> > Long-term, having an architectural shutdown command - similar to the
> > TDH.SYS.DISABLE command in Intel TDX - would be incredibly useful. It
> > would allow the kdump kernel to safely bypass these hardware security
> > checks, especially when extracting host-side KVM state.
>

> For kexec, may be we could do this. Alternatively we could try to
> reclaim everything back, (GPTs, Tracking) before kexec-reboot.
>

Agreed. Reclaiming all delegated memory prior to the kexec reboot
makes perfect sense.

> >
> > As for the protected realm memory, I assume that is an easier problem.
> > We naturally want to exclude guest pages from a host dump regardless
> > of whether they are Realm pages or not. However, accidental touches
> > are still fatal.
> >
> >> There is also some RMM configuration which cannot be repeated (see
> >> RMI_RMM_CONFIG_SET) - which implies that the kexec kernel must be
> >> similar to the first kernel (i.e. same page size).
>
> That is true, the page sizes must match. RMM spec is updated to probe
> the state of the RMM and detect if it can do the CONFIG_SET
>
> Suzuki
>
> >>
> >> Thanks,
> >> Steve
>
