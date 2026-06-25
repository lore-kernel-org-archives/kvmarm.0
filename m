Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DE47260580
	for <kvmarm@lists.linux.dev>; Thu, 25 Jun 2026 19:43:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782416607; cv=none; b=CB6OZ8RmlMVQzbufpwCx5x4fEOvs53nfcGS94SQ5kqfCy/j7HZl+dTCgtyb5hecE12aDWlFvIm8LOBXAZL6xOMLo/JZ4inXdsJvMqYkj+/NY+ZBQcl5dRuCBL/oGFabC1IrupRRYUH+uM2TADl+cfBB2IuTlyRpsBVKdNott7R8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782416607; c=relaxed/simple;
	bh=41K2ntIJwIiJ1XV9qQH8RX2RkhiTpGcUQQvILEiKK2A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VE6YiHXnC8vVEmvXaLU2GDxt+40eb7ZxWCYSsECGjTh4ge0t5WGa16t8is/9XBg0Nxh6hc7nIiT3Pxtr0snBe2kzA5V/s7WwdaIytOcdSt9/jD+F0dYv0JJGUr5KNtbHGj3VKe53pu89+O/Beg0e07GWrycHxnByhLVw1l91YU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=rEUFIoL9; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="rEUFIoL9"
X-Forwarded-Encrypted: i=1; AFNElJ949joanuafL4KJZswd6Sst6MVGp3GJVqt2wXAXtku7jrWEf0GM7vrOHltfdIVgDrDvBy4P6qg=@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782416603;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nbSjX9AvDpdxOLt0RWMwNd5KM4HdVWEarS1sfRM2aeQ=;
	b=rEUFIoL9iU4h2HCJn6lCMEWggvWAo0/BE7L8O1NiCWD69TlMOaDQo1vk6cBUEOhoK9bd3P
	41bxuz3DL8OO19CPIdmyBKLlXmcxT5k3nN/QwgtmI/+CimYW1psSeamHZa3OrvQdxXGICD
	eK+aUcyO/5RHhav2JvKHQcima9Jrp34=
X-Gm-Message-State: AOJu0YxqHqX4XElLIuNexq957KyXQo1sVfppKyYQZGynJOBiNLE8JqLg
	ZFSCu75aPDKRCyNljHM1HREGPBNqRL8YOjZY/QQCnu4VKoU4QknDZoviDAWRj5UkpEFz7BP2yUM
	mv8WbWbNwEKsyB5wNHARgIH3jpG53zNHKQt0N2imY
X-Received: by 2002:a05:622a:d0:b0:517:5ec3:b59c with SMTP id
 d75a77b69052e-51a7d60c48emr1462271cf.2.1782416599791; Thu, 25 Jun 2026
 12:43:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260625171046.4482-1-will@kernel.org>
In-Reply-To: <20260625171046.4482-1-will@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Thu, 25 Jun 2026 20:42:00 +0100
X-Gmail-Original-Message-ID: <CA+EHjTzT74Yq2Aj9VdSoCNDKc5qP2q7cu0H40MJAoMohw0t6Kw@mail.gmail.com>
X-Gm-Features: AVVi8CfexivWnztJTGmBWTKtn7LsHEu_5HRnrMWMwOS4QS8mV8LVyPjpMXXEgWc
Message-ID: <CA+EHjTzT74Yq2Aj9VdSoCNDKc5qP2q7cu0H40MJAoMohw0t6Kw@mail.gmail.com>
Subject: Re: [PATCH v2 kvmtool 0/4] Add support for running protected VMs on arm64
To: Will Deacon <will@kernel.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Andre Przywara <andre.przywara@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Migadu-Flow: FLOW_OUT

On Thu, 25 Jun 2026 at 18:10, Will Deacon <will@kernel.org> wrote:
>
> Hi folks,
>
> This is v2 of the patches I previously posted here:
>
>   https://lore.kernel.org/r/20260619115415.5475-1-will@kernel.org
>
> Changes since v1 include:
>
>   * Bail if user specifies less guest memory than the restricted DMA pool.
>   * Avoid silently dropping KVM_VM_TYPE_ARM_PROTECTED on old host kernels.
>   * Added R-b/T-b tags (thank you!)
>
> The patches are also available here if you want to pull them directly:
>
>   https://git.kernel.org/pub/scm/linux/kernel/git/will/kvmtool.git/log/?h=pkvm
>
> Cheers,
>
> Will

For the new series:

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Tested-by: Fuad Tabba < fuad.tabba@linux.dev>

Cheers,
/fuad

>
> Cc: Alexandru Elisei <alexandru.elisei@arm.com>
> Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
> Cc: Andre Przywara <andre.przywara@arm.com>
> Cc: Fuad Tabba <fuad.tabba@linux.dev>
> Cc: Oliver Upton <oliver.upton@linux.dev>
> Cc: Marc Zyngier <maz@kernel.org>
>
> --->8
>
> Will Deacon (4):
>   Sync kernel UAPI headers with v7.1
>   virtio: Factor out base features for modern virtio transports
>   virtio: Add helper for enabling VIRTIO_F_ACCESS_PLATFORM
>   arm64: Add support for protected VMs
>
>  arm64/fdt.c                         | 37 ++++++++++++++++++--
>  arm64/include/asm/kvm.h             |  1 +
>  arm64/include/kvm/fdt-arch.h        | 10 +++++-
>  arm64/include/kvm/kvm-arch.h        |  2 ++
>  arm64/include/kvm/kvm-config-arch.h |  5 ++-
>  arm64/kvm.c                         | 28 +++++++++++++--
>  arm64/pci.c                         |  2 ++
>  include/kvm/virtio.h                |  2 ++
>  include/linux/kvm.h                 | 53 +++++++++++++++++++++++++----
>  include/linux/virtio_ring.h         |  5 +--
>  riscv/include/asm/kvm.h             | 11 +++---
>  virtio/core.c                       | 12 +++++++
>  virtio/mmio-modern.c                |  2 +-
>  virtio/pci-modern.c                 |  2 +-
>  x86/include/asm/kvm.h               | 21 +++++++-----
>  15 files changed, 163 insertions(+), 30 deletions(-)
>
> --
> 2.55.0.rc0.799.gd6f94ed593-goog
>
