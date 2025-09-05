Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A810734F48B
	for <kvmarm@lists.linux.dev>; Fri,  5 Sep 2025 12:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757075236; cv=none; b=uh55iv2DfLWkH7X1jevZNJb85a0hjTRn2q1d+ESe5djdyXK2qn2zGDi6GiW3nzMChH+5Ud1pdAn+BkTEb6jQ512jM6F7S+grehxEYxtY9C3EI9xLVvPZ1Yc7G98P8rWig6MuyR4c3nDgfV/XgTtMCyuzweH3718nxTWlUrE32HY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757075236; c=relaxed/simple;
	bh=wKevWlaDVATFTRv5UskfQdVzbKDKhm6MQDY8OOEDKcs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lOQTYjEEiz8u5nJPB/7i2+dQRfgG8iSzZOeRNE5SZWso1jgYYHoPBzOVOh6z1ZF8JxGm6DKdXQDy6pMGgPlzb7H1sUAtXmPq33YCLxWDDTqD9eU8r6DXsHD0xQmJDMDwlKL4Rw9X9q0PB5RSvefJozCbHz2ZEif3MPc26BnV7+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MeXi1HPF; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MeXi1HPF"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-329745d6b89so3605122a91.1
        for <kvmarm@lists.linux.dev>; Fri, 05 Sep 2025 05:27:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757075234; x=1757680034; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uEtLYmY8JOalgrgOv2U5MLx2Oeht0cmwE/ZJBlYZqa4=;
        b=MeXi1HPFiyj3wxO1PeTp2kvdx81ur6TPd9WTKMlKVOvbiRZ4LmCRhctNecQCSFyH7W
         23WU1EdkUyJwyvfcGrzHKpq7ZUz581XQKomMgo7ZYMlsZOlw02Ub6WtF/XLJKKDoJc5E
         5IX1suBPXWxx1hASMZgUkIbOU0OVhEN0ve72bBnZbqgxJ2zL25p3stE+zAZdnlwb43aO
         Qx46n4jFfPIGIZH0MbFPAhlBP6X2l6bD7ziMCyfoZAg859+ov4I8mDqZhZ2+u6bFPeFa
         FUORW7kY9r0KlxHQ0KfCj/4tySpqUIrAFTQkT+Fg5W16HQMEXiIY0felNx5zBlibe1MY
         SWNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757075234; x=1757680034;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=uEtLYmY8JOalgrgOv2U5MLx2Oeht0cmwE/ZJBlYZqa4=;
        b=ojGetMlDOw9H7b3Nrw4BYvgaLHxprXMfaGgabZl/GL7l4D3+Mdt51qp6aF4oSiD3YA
         z7jhvu8kBk/yrOfLd+rH8jmHCjWIF9b/1Ahl5ikB90KJPdS+VYvMm5VmrusaIjYCP/48
         WPbuA62ax7eRgP6aK2zNvDJAuBGJ8rotEd3aa+ygQEtkuz7x3FbydqzYFGrhATOJNFzd
         5kT691H2ovDDSHvrvVz/49ImbGoovCh4XY0dCG4UPB2JAYo7QBSoTo8r3nQwsO4RbGGk
         6F1HJGz6B8tD7+9oIfrCX1wMMoThZmZNU8KLIKVUkNvULuwWEYNQoFkx+hMZNAxAc7xH
         l0Tg==
X-Forwarded-Encrypted: i=1; AJvYcCWeFKDI+7IPM0XOgcVsQU9Y+gkr5NiPtbiBTn/M/VorISgsNusapNlu6O3odOd24x274TNzTDE=@lists.linux.dev
X-Gm-Message-State: AOJu0YwZB0NieslX3fhQ2phe3XsiAdfzL1CCEcOXUbceDbcEVNrsDnn+
	MNyDIVrbLLvcLTEGj46hc3rOQRmonq/qYZz6+OKknrAckUq2P0e4/MGjRP0hc5YIt5Lh1N1fc6n
	GFu0hGg==
X-Google-Smtp-Source: AGHT+IGL6U3Es4ziofS/w8+rJpx7HwQEqsdYgzJc5tlMCihXPtFAaEH2AeP3MpoxcgsR8e9ya+5ty4Rf6kk=
X-Received: from pjbmf13.prod.google.com ([2002:a17:90b:184d:b0:32b:35fb:187f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1a8b:b0:32b:b26e:1569
 with SMTP id 98e67ed59e1d1-32bb26e2965mr6479994a91.15.1757075233964; Fri, 05
 Sep 2025 05:27:13 -0700 (PDT)
Date: Fri, 5 Sep 2025 05:27:01 -0700
In-Reply-To: <CADrL8HVxvwB4JrnUf6QtDCyzZojEvR4tr-ELEn+fL8=1cnbMQQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250618042424.330664-1-jthoughton@google.com>
 <de7da4d8-0e9d-46f2-88ec-cfd5dc14421c@amazon.com> <CADrL8HVxvwB4JrnUf6QtDCyzZojEvR4tr-ELEn+fL8=1cnbMQQ@mail.gmail.com>
Message-ID: <aLrXFWDgDkHqPQda@google.com>
Subject: Re: [PATCH v3 00/15] KVM: Introduce KVM Userfault
From: Sean Christopherson <seanjc@google.com>
To: James Houghton <jthoughton@google.com>
Cc: kalyazin@amazon.com, Paolo Bonzini <pbonzini@redhat.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Yan Zhao <yan.y.zhao@intel.com>, Anish Moorthy <amoorthy@google.com>, 
	Peter Gonda <pgonda@google.com>, Peter Xu <peterx@redhat.com>, 
	David Matlack <dmatlack@google.com>, wei.w.wang@intel.com, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 04, 2025, James Houghton wrote:
> On Thu, Sep 4, 2025 at 9:43=E2=80=AFAM Nikita Kalyazin <kalyazin@amazon.c=
om> wrote:
> > Are there any blockers for merging this series?  We would like to use
> > the functionality in Firecracker for restoring guest_memfd-backed VMs
> > from snapshots via UFFD [1].  [2] is a Firecracker feature branch that
> > builds on top of KVM userfault, along with direct map removal [3], writ=
e
> > syscall [4] and UFFD support [5] in guest_memfd (currently in discussio=
n
> > with MM at [6]) series.
>=20
> Glad to hear that you need this series. :)

Likewise (though I had slightly-advanced warning from Patrick that Firecrac=
ker
wants KVM Userfault).  The main reason I haven't pushed harder on this seri=
es is
that I didn't think anyone wanted to use it within the next ~year.

> I am on the hook to get some QEMU patches to demonstrate that KVM
> Userfault can work well with it. I'll try to get that done ASAP now
> that you've expressed interest. The firecracker patches are a nice
> demonstration that this could work too... (I wish the VMM I work on
> was open-source).
>=20
> I think the current "blocker" is the kvm_page_fault stuff[*]; KVM
> Userfault will be the first user of this API. I'll review that series
> in the next few days. I'm pretty sure Sean doesn't have any conceptual
> issues with KVM Userfault as implemented in this series.

Yep, Oliver and I (and anyone else that has an opinion) just need to align =
on the
interface for arch-neutral code.  I think that's mostly on me to spin a v2,=
 and
maybe to show how it all looks when integrated with the userfault stuff.
