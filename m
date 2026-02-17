Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 067DA36EA87
	for <kvmarm@lists.linux.dev>; Tue, 17 Feb 2026 17:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771350474; cv=none; b=V9PJvNdqLA0/bKFaFAP/lBAxGa+MmKtV9sxjYYGhNArqOOHG71x0mNZ863mhOJXECGVjjXzy9J4jc/6OxLRJ87o7ssl22IXzl5DFqd/wCCpvBVOLKZV/O+wsMARBjhvciG2XQ1ATuf2jD38beiR3/3EvQpJHyiaqeVRl1OAKyGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771350474; c=relaxed/simple;
	bh=Ldc3kA/B8po7HRBL7zpvt1BJaIEwgDG3685rS8QLkdY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KomQsegjU2KsxYG1E9oLqBMLBANUTTo0U1XM4Npn0g8a55GGjm3UwjZLZ0ltmoKJ8Olu1E8aIbVvrf8O8M+fVS5qZXLWFhPT0x0VU17P0MjR5b2huRXzsI9O52VC6QB423Jv3Pn4AQXTRBESygWOgv2XAgYu36ZAoNobvcpWfSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=A9oixH1a; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="A9oixH1a"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-8217f2ad01eso446045b3a.2
        for <kvmarm@lists.linux.dev>; Tue, 17 Feb 2026 09:47:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1771350471; x=1771955271; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=NzMITkEXZs34lceKZ1bkvJdV8jpP8i6Cd6H1ke9i4qg=;
        b=A9oixH1ac4IXAejS9Zp4r6mgY74jR/sCagl1k7U84U5COeQ7sEqJ20heTCXshSRc66
         mZYp4I6uHglMV2KojEPF8n9bQS7XjM6LAdIsM/Wh9G+OvivwkgtfymYS4f/cOHfeS0X7
         ZFzcZRJ7Hi4tV9F9HTQAUrKVKdsKXGvMJcpdZazbo98J0EzDrT+D0xz7uP2UKAwl4fUK
         2h0w+cnhNQA0+L9Z9f5inJD3IQTzqUZa6uDzkOmMdTWmNIPI3VJhWmvl90Q2nVRaqZp5
         ILellNLXQUx5MrgACJFqNWQpvMq1Jq+HS4Vk7SyS11mHQ9054j0PsX3E8DJj9dRMkiCX
         FFxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771350471; x=1771955271;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NzMITkEXZs34lceKZ1bkvJdV8jpP8i6Cd6H1ke9i4qg=;
        b=Q8J2UBeoGKIaTTWlAJdctPfk9/t3YPj4uPHdFo1bQlpYabFQIYL0eAoMLS6RLhqPez
         bS7Ee5JJeKOY56WA9UkFPPNgx9Opr6xXoeoV3JVGZVS+l9ms+dWh6bHshtZ+i2VIRcM9
         lvGxpWsQYnxCoB+JkGUUChM4VkHSYBNvcx33i3eKq9j0RYVs+Lm4HJn5rk63rc651I4h
         AeXQSdc6JM9C7f4XjkRJUs0AJDn45++BbWkf53Qbx2MJLSU8niKA8G8cgs1NbMtkwe9B
         5LyImoxvXU28SofmAafLXPlo1h8EumB/4gje6rCFocn22EKHespGSoGUmEG1SM6KjEhS
         NuDA==
X-Forwarded-Encrypted: i=1; AJvYcCUugJo86J+Vzbvzvt12PdyxtHzpJLdAm/2+D5wVT+WVwsDvHsu89BXdi81XHvoACgJPQcBRlRg=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy+/htsX1qq6nttJB0M7fm85i5czOd556p0wyG2qU+n9gxrqNxr
	QMwZvbeGZlAi7XACgOALzr4sxSH9R2K0WSpZ3Idr80nVUMuogCs8RQ4N2fxqlvSWXCs=
X-Gm-Gg: AZuq6aIsNNuZ/LH6erFyd3/+gF3jcFtckq54gnNFHgcZccg77GirmIZSdB9PoSf3Fr/
	KEkT7q8gSMTQdFwgLvQSQGJuFYxamnjRRy9tJTzAaDBCiDJHgsRSIygOtj3xF83k3FCFQKEHNdQ
	xrLaKgYzo6p3E9WvMCfMhSMOe478SDiRK+QZT0SzLNUuOjjPR8GI8nHyfajciT9u8LY/S7nfICn
	vp5l74aTSVBrIeVnLVy35d90buhdfUqCCewhbo5X9GSRtzL1DPRU+1l5iBJXOQ2W8reWJgugRos
	SXFzVy85B18OJQhTWg5gcEV0MfQ/dkmHFgA88hHI4ay9Qtd+k8Mbg3+jl3Q6vfCcRq0ZcL26zeR
	C/WV3m35FtUN61Ef4ZibErUi2rLelpnGe6FuDHC1qe/4gNd2Cz2fvIfAhup1Kf0/IavBf31kc5b
	vAxc3VgPPNGtS3Aw31NdshBUJiQA==
X-Received: by 2002:a05:6a21:4916:b0:38b:ebdd:919f with SMTP id adf61e73a8af0-394671145b5mr13583057637.1.1771350471095;
        Tue, 17 Feb 2026 09:47:51 -0800 (PST)
Received: from p14s ([2604:3d09:148c:c800:970a:754:4a36:44d0])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c6e5331ba14sm10310210a12.29.2026.02.17.09.47.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Feb 2026 09:47:50 -0800 (PST)
Date: Tue, 17 Feb 2026 10:47:46 -0700
From: Mathieu Poirier <mathieu.poirier@linaro.org>
To: Steven Price <steven.price@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Gavin Shan <gshan@redhat.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
	Emi Kisanuki <fj0570is@fujitsu.com>,
	Vishal Annapurve <vannapurve@google.com>
Subject: Re: [PATCH v12 00/46] arm64: Support for Arm CCA in KVM
Message-ID: <aZSpwlZmpjdh3Oxr@p14s>
References: <20251217101125.91098-1-steven.price@arm.com>
 <aY4Sf4lMlWd9LyTo@p14s>
 <55fc4877-666c-4d5f-a167-5692f7cfbd0b@arm.com>
 <9140efaa-dc54-4a1b-8936-3ef876ca9121@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9140efaa-dc54-4a1b-8936-3ef876ca9121@arm.com>

On Mon, Feb 16, 2026 at 02:27:02PM +0000, Steven Price wrote:
> On 16/02/2026 12:33, Steven Price wrote:
> > On 12/02/2026 17:48, Mathieu Poirier wrote:
> >> Hi Steven,
> >>
> >> On Wed, Dec 17, 2025 at 10:10:37AM +0000, Steven Price wrote:
> >>> This series adds support for running protected VMs using KVM under the
> >>> Arm Confidential Compute Architecture (CCA). I've changed the uAPI
> >>> following feedback from Marc.
> >>>
> >>> The main change is that rather than providing a multiplex CAP and
> >>> expecting the VMM to drive the different stages of realm construction,
> >>> there's now just a minimal interface and KVM performs the necessary
> >>> operations when needed.
> >>>
> >>> This series is lightly tested and is meant as a demonstration of the new
> >>> uAPI. There are a number of (known) rough corners in the implementation
> >>> that I haven't dealt with properly.
> >>>
> >>> In particular please note that this series is still targetting RMM v1.0.
> >>> There is an alpha quality version of RMM v2.0 available[1]. Feedback was
> >>> that there are a number of blockers for merging with RMM v1.0 and so I
> >>> expect to rework this series to support RMM v2.0 before it is merged.
> >>> That will necessarily involve reworking the implementation.
> >>>
> >>> Specifically I'm expecting improvements in:
> >>>
> >>>  * GIC handling - passing state in registers, and allowing the host to
> >>>    fully emulate the GIC by allowing trap bits to be set.
> >>>
> >>>  * PMU handling - again providing flexibility to the host's emulation.
> >>>
> >>>  * Page size/granule size mismatch. RMM v1.0 defines the granule as 4k,
> >>>    RMM v2.0 provide the option for the host to change the granule size.
> >>>    The intention is that Linux would simply set the granule size equal
> >>>    to its page size which will significantly simplify the management of
> >>>    granules.
> >>>
> >>>  * Some performance improvement from the use of range-based map/unmap
> >>>    RMI calls.
> >>>
> >>> This series is based on v6.19-rc1. It is also available as a git
> >>> repository:
> >>>
> >>> https://gitlab.arm.com/linux-arm/linux-cca cca-host/v12
> >>>
> >>> Work in progress changes for kvmtool are available from the git
> >>> repository below:
> >>>
> >>> https://gitlab.arm.com/linux-arm/kvmtool-cca cca/v10
> >>
> >> The first thing to note is that branch cca/v10 does not compile due to function
> >> realm_configure_parameters() not being called anywhere.  Marking the function as
> >> [[maybe_unused]] solved the problem on my side.
> > 
> > This is in the kvmtool code - and yes I agree "work in progress" is a
> > bit generous for the current state of that code, "horrid ugly hacks to
> > get things working" is probably more accurate ;)
> > 
> > The issue here is that the two things that realm_configure_parameters()
> > set up (hash algorithm and RPV) are currently unsupported with the Linux
> > changes, but will need to be reintroduced in the future. So the contents
> > of the functions which set this up (using the old uAPI) are just #if 0'd
> > out.
> > 
> > Depending on the compile flags the code will compile with a warning, but
> > using __attribute__((unused)) would at least make this clear. I'd want
> > to avoid the "[[maybe_unused]]" as it's not used elsewhere in the code
> > base and limits compatibility.
> > 
> >> Using the FVP emulator, booting a Realm that includes EDK2 in its boot stack
> >> worked.  If EDK2 is not part of the boot stack and a kernel is booted directly
> >> from lkvm, mounting the initrd fails.  Looking into this issue further, I see
> >> that from a Realm kernel's perspective, the content of the initrd is either
> >> encrypted or has been trampled on.  
> > 
> > I can reproduce that, a quick fix is to change INITRD_ALIGN:
> > 
> > #define INITRD_ALIGN	SZ_64K
> > 
> > But the code was meant to be able to deal with an unaligned initrd -
> > I'll see if I can figure out what's going wrong.
> 
> Looks like a simple bug in kvm_arm_realm_populate_ram() - it wasn't
> updating the source address when it had to align the start of the
> region. Simple fix below:
> 
> ---8<---
> diff --git a/arm/aarch64/realm.c b/arm/aarch64/realm.c
> --- a/arm/aarch64/realm.c
> +++ b/arm/aarch64/realm.c
> @@ -104,7 +104,7 @@ void kvm_arm_realm_populate_ram(struct kvm *kvm,
> unsigned long start,
> 
>         new_region->start = ALIGN_DOWN(start, SZ_64K);
>         new_region->file_end = ALIGN(start + size, SZ_64K);
> -       new_region->source = source;
> +       new_region->source = source - (start - new_region->start);

That also worked on my side.

> 
>         list_add_tail(&new_region->list, &realm_ram_regions);
>  }
> ---8<---
> 
> Thanks for the pointer, and I'll try to remember to include initrd
> testing in future.
> 

Very well.

Thanks for looking into this.

> Steve
> 
