Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92F363939A6
	for <kvmarm@lists.linux.dev>; Wed, 15 Apr 2026 23:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776295644; cv=pass; b=Qorwn1WLpWloeCM/ePt8IWBxL1hA1+srq75E7Qske844omGMHa5YowwVrOPBnBpZ1ahEuHdgSbQ0PjccKpqIblYZg0FQOe8kYpclX88NacaH/04mXFWB/K1LYA52FsEKTY4ksnHu/fEdAbXW7QaArUdX9XcMn9SlOTYC5yNbrrM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776295644; c=relaxed/simple;
	bh=x+QG3xhCQwRR1qC6hXy7NcWy7080+KY3YK+kXqaECJ0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NMOHoS0dx6M54MY+3VpdjW8ST0yJdEmmTRDCKYHctwy2bExlVzIXnY4ha+JrQNdlxBBklrBrHwDgY8TMoNNmZEM38+OD5UsLKIdH+Gk/FEffL7YDRz6w1H3nZmFT7AHVqwLcDIknajb8QN6yb+HxW62cDrU/pdat1YLQnL/LC7A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WaSOiQTl; arc=pass smtp.client-ip=209.85.219.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WaSOiQTl"
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-8a151012558so85943366d6.3
        for <kvmarm@lists.linux.dev>; Wed, 15 Apr 2026 16:27:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776295641; cv=none;
        d=google.com; s=arc-20240605;
        b=lvyrXjsi+5Jxzp5MH5z2mB5LFdJtF/O3ELqWczNah9bgvfjZTXimacez2HH0a9Rjk8
         n0mNfSJTgkxVHJ2QvJ5Njx0B9SIi/gJ/0yYLB+9/75JlOXw4JajS5TuN43s/JTKxshwK
         OlGNfYT29oprfl6Ev9c8Wd7Ri8Muht4wyotYYZMn+YNTM771e9dduXA5MaoT3JnQLG8T
         uv6OniLL+3JG8f/0Fo8MYeYTUye32n9GNwTN4ue2UhHT1ovzAujr+RqoG7OlH3+m7v21
         Bld//1LA/CTSsDPEXUy2U7TlNHv+/qdz4LXbwWGbEz9YnNLMPyA0RiW2zp0w4+fb4j+4
         64DQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=x+QG3xhCQwRR1qC6hXy7NcWy7080+KY3YK+kXqaECJ0=;
        fh=0ZSVmAdxFdlPGCfb69G/ons1ws5J0Sv7n7SWC4k4u9I=;
        b=GL/Q9Bdhe9D3K0xq8weeXhlfP7QhzwWOU2lRgDuXFDltPQGxke10BF1qjrIEQZz/iz
         ol5LEYSzoAqz2LtuuFMHUjQkhOjEIoiFuHp0Tl1S88pxa/KGu1RDJCDouY/YIpSU6Yqz
         VhUh9deAlBFgpM/yLRmNgeCLhdYFkWdFUKtlnNS3vlgCrdol7AczaiUaWA/7k91jifA0
         HPJBfvxzFmOlG1ugCVX8nOfuzhdoyGB07CEl+qO03MUJmfUXBPpLKrdIW0O5/PDy1/uS
         9DQYAEQgX1PBz6XhoaWHurfjq7uwHdrvSYbJaf210ZEJ3tJhWZU90EF9f8ifjILLoBPG
         3tWw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776295641; x=1776900441; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x+QG3xhCQwRR1qC6hXy7NcWy7080+KY3YK+kXqaECJ0=;
        b=WaSOiQTl2gWozybJPf8Ak+z1qb4lOfpqnVhFi5p2Z72zeeHwV+ymJPRerr+QeqnAKq
         rNHT1x3QSaTAbsVKjnnhYNwUayJc/bGJ3IgY7zDy+6bRaVu6oWcSuLIcEx8MObT60GWh
         PoTAu8ukSMP0oQQoorRBtxckV6vK3ejqpSgleFzXdCnxATFGNjBx5+1ekcjWXdBBBDSS
         2VS/XdJB7syBGqeIfegbsEB6TIrI9hPxHaENmLPGNQbY/dbSfGVqbOLtJDo29zLgkPNq
         +3ve/YPTgrVL9QNF9CIl20O0ZZtZcJfSsG14aFjRSkzd2m4+5uTS/Yn+fZIk5o44haCd
         Uubw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776295641; x=1776900441;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=x+QG3xhCQwRR1qC6hXy7NcWy7080+KY3YK+kXqaECJ0=;
        b=P6/2mzhXDAKy15YKA1Ec6E4d9swL0OievX6KhxWNlTX6O5IzskmuNBwba5RqKLbaEK
         wAzEv7NRmOfqoG9f0Khv77kjousVGcDEDqZunyKMvIrR3MKUzuIR1XgmFqa3/Z7b9alu
         raXZQz2gD/badIKjTEUFkuSv7FEmgimYAT5RMRK7hZeo7SX2rrVF4GUqisu66ChtSo9a
         wlfXdZp5JeomG+GPLYBF8G50zqDRe3v6BE1z7WPcGWOy1qYm3ZZ3Xhody+T3+BMIbg7V
         +F3Om9z72EOTMLEw7ppmIoqiI3cxbokUVLx59veihsz8EWsjt0UVQl/mP0Nfr95XvTvk
         DVKQ==
X-Forwarded-Encrypted: i=1; AFNElJ/xHwOLPXqZaQecD/ngEgzu5miBRO7MRZOmvflie9LXyl8Eh60LKehm9dBGTzRlxibaKHvET7k=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyp9WceiORuz+WG5v+4naS+5sH49I7Ou+m6gjR0ERhLNxDbr057
	2p8BPfZIN1nrrv1Mj+V6jwICN/onVtGfBhuIkn5fNxF8q1l+un4To6pQM+Ks8TvJAtRS23P0E3W
	nRcrIrWszmxn6owTu8bLaSmlngal7zJt2x5CN9cLC
X-Gm-Gg: AeBDies6gog/hgKhRcWCKvQiP3vXbgmQy9cCgaR2HYHW3cq5mvCNsJkgbxXyCziJdyx
	Db1EnfOifnFktfWD9NEotwwio01EqIKKvEbgsJiKl0687h4a3fJr0ZxPUqI84nHrABZv9db/0l3
	uw/d+4zXH9I2hH1Zvq7O2zc2Lpio/k3/mc2ge3qi7+w+Ygf13z1fSuKucpUNgAa8EbhhCGIl9N6
	qodW8nzFp4G5cDxbEsbgK4CNqQiWe2xw7ht2noziiEKgTB9Y4+ChhtsbKRMENy5ITkFtEhU62f3
	sZ/Fnyi8NBSX0bGMkUo3X0CVI6LyWQ9tlHJVtkdRSmqxlorsiBVr1Lzh30E=
X-Received: by 2002:ad4:5baf:0:b0:8ac:ab13:8f15 with SMTP id
 6a1803df08f44-8acab1391c9mr232004096d6.7.1776295640870; Wed, 15 Apr 2026
 16:27:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260318155413.793430-1-steven.price@arm.com> <CABpDEukEO4Y_fg8fv5Nr1_Pw_qOK=2UmioXk=WyPEzoEprPcGA@mail.gmail.com>
 <d661a24c-6619-4734-96bd-075d3416e809@arm.com>
In-Reply-To: <d661a24c-6619-4734-96bd-075d3416e809@arm.com>
From: Alper Gun <alpergun@google.com>
Date: Wed, 15 Apr 2026 16:27:08 -0700
X-Gm-Features: AQROBzCS-xITaK7ztBjux37Usj-fD7VQebkqcRVamG9jxnrdFdKeF2d2D3KViso
Message-ID: <CABpDEumAVf02uOS5Bj07EDyuU=z9FV-iocQU1j7gFM5z0BeV_w@mail.gmail.com>
Subject: Re: [PATCH v13 00/48] arm64: Support for Arm CCA in KVM
To: Steven Price <steven.price@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, 
	James Morse <james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev, 
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, Gavin Shan <gshan@redhat.com>, 
	Shanker Donthineni <sdonthineni@nvidia.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>, 
	Emi Kisanuki <fj0570is@fujitsu.com>, Vishal Annapurve <vannapurve@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 15, 2026 at 4:01=E2=80=AFAM Steven Price <steven.price@arm.com>=
 wrote:
>
> On 14/04/2026 22:40, Alper Gun wrote:
> > On Wed, Mar 18, 2026 at 8:54=E2=80=AFAM Steven Price <steven.price@arm.=
com> wrote:
> >>
> >> This series adds support for running protected VMs using KVM under the
> >> Arm Confidential Compute Architecture (CCA).
> >>
> >> New major version number! This now targets RMM v2.0-bet0[1]. And unlik=
e
> >> for Linux this represents a significant change.
> >>
> >> RMM v2.0 brings with it the ability to configure the RMM to have the
> >> same page size as the host (so no more RMM_PAGE_SIZE and dealing with
> >> granules being different from host pages). It also introduces range
> >> based APIs for many operations which should be more efficient and
> >> simplifies the code in places.
> >>
> >> The handling of the GIC has changed, so the system registers are used =
to
> >> pass the GIC state rather than memory. This means fewer changes to the
> >> KVM code as it looks much like a normal VM in this respect.
> >>
> >> And of course the new uAPI introduced in the previous v12 posting is
> >> retained so that also remains simplified compared to earlier postings.
> >>
> >> The RMM support for v2.0 is still early and so this series includes a
> >> few hacks to ease the integration. Of note are that there are some RMM
> >> v1.0 SMCs added to paper over areas where the RMM implementation isn't
> >> quite ready for v2.0, and "SROs" (see below) are deferred to the final
> >> patch in the series.
> >>
> >> The PMU in RMM v2.0 requires more handling on the RMM-side (and
> >> therefore simplifies the implementation on Linux), but this isn't quit=
e
> >> ready yet. The Linux side is implemented (but untested).
> >>
> >> PSCI still requires the VMM to provide the "target" REC for operations
> >> that affect another vCPU. This is likely to change in a future version
> >> of the specification. There's also a desire to force PSCI to be handle=
d
> >> in the VMM for realm guests - this isn't implemented yet as I'm waitin=
g
> >> for the dust to settle on the RMM interface first.
> >>
> >> Stateful RMI Operations
> >> -----------------------
> >>
> >> The RMM v2.0 spec brings a new concept of Stateful RMI Operations (SRO=
s)
> >> which allow the RMM to complete an operation over several SMC calls an=
d
> >> requesting/returning memory to the host. This has the benefit of
> >> allowing interrupts to be handled in the middle of an operation (by
> >> returning to the host to handle the interrupt without completing the
> >> operation) and enables the RMM to dynamically allocate memory for
> >> internal tracking purposes. One example of this is RMI_REC_CREATE no
> >> longer needs "auxiliary granules" provided upfront but can request the
> >> memory needed during the RMI_REC_CREATE operation.
> >>
> >> There are a fairly large number of operations that are defined as SROs
> >> in the specification, but current both Linux and RMM only have support
> >> for RMI_REC_CREATE and RMI_REC_DESTROY. There a number of TODOs/FIXMEs
> >> in the code where support is missing.
> >>
> >> Given the early stage support for this, the SRO handling is all confin=
ed
> >> to the final patch. This patch can be dropped to return to a pre-SRO
> >> state (albeit a mixture of RMM v1.0 and v2.0 APIs) for testing purpose=
s.
> >>
> >> A future posting will reorder the series to move the generic SRO suppo=
rt
> >> to an early patch and will implement the proper support for this in al=
l
> >> RMI SMCs.
> >>
> >> One aspect of SROs which is not yet well captured is that in some
> >> circumstances the Linux kernel will need to call an SRO call in a
> >> context where memory allocation is restricted (e.g. because a spinlock
> >> is held). In this case the intention is that the SRO will be cancelled=
,
> >> the spinlock dropped so the memory allocation can be completed, and th=
en
> >> the SRO restarted (obviously after rechecking the state that the
> >> spinlock was protecting). For this reason the code stores the memory
> >> allocations within a struct rmi_sro_state object - see the final patch
> >> for more details.
> >>
> >> This series is based on v7.0-rc1. It is also available as a git
> >> repository:
> >>
> >> https://gitlab.arm.com/linux-arm/linux-cca cca-host/v13
> >>
> >>
> >
> > Hi Steven,
> >
> > I have a question regarding host kexec and kdump scenarios, and
> > whether there is any plan to make them work in this initial series.
> >
> > Intel TDX and AMD SEV-SNP both have a firmware shutdown command that
> > is invoked during the kexec or panic code paths to safely bypass
> > hardware memory protections and boot into the new kernel. As far as
> > I know, there is no similar global teardown command available for
> > the RMM.
>
> Correct, the RMM specification as it stands doesn't provide a mechanism
> for the host to do this. The host would have to identify all the realm
> guests in the system: specifically the address of the RDs (Realm
> Descriptors) and RECs (Realm Execution Contexts). It needs this to tear
> down the guests and be able to undelegate the memory.
>
> It's an interesting point and I'll raise the idea of a "firmware
> shutdown command" to make this more possible.
>
> > What is the roadmap for supporting both general kexec and
> > more specifically kdump (panic) scenarios with CCA?
>
> I don't have a roadmap I'm afraid for these. kexec in theory would be
> possible with KVM gracefully terminating all realms. For kdump/panic
> that sort of graceful shutdown isn't really appropriate (or likely to
> succeed).
>

Thanks Steven for the clarification.

For us, kdump is highly critical as it is our primary diagnostic tool
for host crashes. Without it, monitoring and debugging at fleet scale
would become unmanageable.

To confirm my understanding of the current architecture: if a host
panics while no Realms are actively running (and therefore no pages
are currently in the delegated state), the standard kdump extraction
should work perfectly fine without any modifications, correct?

Regarding the KVM tracking structures (RDs, RECs, RTTs, etc.) when VMs
are running, perhaps we could use `vmcoreinfo` to export the physical
addresses of these delegated pages. This would allow tools like
`makedumpfile` to explicitly filter them out. I assume these pages must
remain hardware-locked while the VMs are active.

Long-term, having an architectural shutdown command - similar to the
TDH.SYS.DISABLE command in Intel TDX - would be incredibly useful. It
would allow the kdump kernel to safely bypass these hardware security
checks, especially when extracting host-side KVM state.

As for the protected realm memory, I assume that is an easier problem.
We naturally want to exclude guest pages from a host dump regardless
of whether they are Realm pages or not. However, accidental touches
are still fatal.

> There is also some RMM configuration which cannot be repeated (see
> RMI_RMM_CONFIG_SET) - which implies that the kexec kernel must be
> similar to the first kernel (i.e. same page size).
>
> Thanks,
> Steve
