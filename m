Received: from mta0.migadu.com (out-42.mta0.migadu.com [91.218.175.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01BF137DE8B
	for <kvmarm@lists.linux.dev>; Mon, 31 Aug 2026 19:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788204509; cv=none; b=NJ4sdljTt50tmZh9RNIiRjZH6HLxte6O3a1LMBVIRIst8CXIi8cQXahB731GJAjZVd5uDO8FLwl2yFEjCcdHbB2NB24rCohXJf5kKqO3MQl1r3fm0pAXX8OUYkXbU2UL76nlaeCZFl92rd/svLlNuzmzdVc1kN6/Haa+OpqKiRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788204509; c=relaxed/simple;
	bh=QL9iDzTYCKrAUBeXvATSPUv4Y1G32BzzX2eraj3q3jQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Keeu5wOXOZoZwouNp2kHDKs5JMMmotRFwJ/zc7t1zVybFQ/r3+lyHZx5ThvY6zbUxJ/ueteWAdOTeHwXnokMF7F8wzSdVmMt0V/Eo6vGXtFFjABheRD/rgfTNFCRxXzpfXEreFvl00iapEym5BXIIhei3rK+fvQhO+clUZve5Eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=FxB9SjgT; arc=none smtp.client-ip=91.218.175.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="FxB9SjgT"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=QL9iDzTYCKrAUBeXvATSPUv4Y1G32BzzX2eraj3q3jQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788204505; v=1; x=1788809305;
 b=FxB9SjgTPHIbJKePpWznl6I732NYqdH0ak2NrADH2Vr+ey33oe54SUTGVGoQ9edwJYvHTnX2
 6bGimqGRQp+ooLfv5ghrp/JoO5bxa63OXOLAFQARudngh4d2tWhyVIWg0uKUdoFaO8XCJ1bZZxj
 5iDdG+qE5xqmV/VFmVjH9ZGM=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id a0b0cfaec9299cca;
	Mon, 31 Aug 2026 19:28:15 +0000
X-Mizu-Trace-ID: a0b0cfaec9299cca
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-5aeb688ae83so1321e87.1
        for <kvmarm@lists.linux.dev>; Mon, 31 Aug 2026 12:28:15 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzkFKDPFj60lLIhrfHTTOIis8ZP0JpXS/8HlfIoT4uzw1c/QocOU4GjQ4gkkRYCBQ6l4po7vmY=@lists.linux.dev
X-Gm-Message-State: AFuF++kotYLBaz6K378YpLeOQt6gHqOPR9pyp43/Of66pfswg/lL7vPX
	ZPIisFIxRz9zSh0QcbTE2KtjVbCLeVoAjrnVnHmtRPSaAIGAWrngUMGM9Th4FCUQffoT7cJwXFr
	WX73AS46e6zUbWVhycLCSIwHEZxZTRfw7jF9inPKP
X-Received: by 2002:a05:6512:3b0d:b0:5b4:9dba:4ece with SMTP id
 2adb3069b0e04-5b5ff2ae0dcmr23112e87.12.1788204494566; Mon, 31 Aug 2026
 12:28:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260831163421.272420-1-fuad.tabba@linux.dev>
In-Reply-To: <20260831163421.272420-1-fuad.tabba@linux.dev>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Mon, 31 Aug 2026 20:27:38 +0100
X-Gmail-Original-Message-ID: <CA+EHjTycOnoVv6jCE2M5bVLG5m1MhnaWSNTpS8vJaWVDk1+S3g@mail.gmail.com>
X-Gm-Features: AcwNN1VeQcT49sFWxBpO5p7UEcrKsOyar9oNS5xestQbF8q3MfimLDxR9Ts3ohk
Message-ID: <CA+EHjTycOnoVv6jCE2M5bVLG5m1MhnaWSNTpS8vJaWVDk1+S3g@mail.gmail.com>
Subject: Re: [PATCH 00/17] KVM: arm64: Confine protected VM vCPU state to EL2
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Vincent Donnefort <vdonnefort@google.com>, Quentin Perret <qperret@google.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, 31 Aug 2026 at 17:34, Fuad Tabba <fuad.tabba@linux.dev> wrote:
...
>
> The kvmtool changes that go with this will be posted separately, and I
> will reply here with a link.

... and here they are:
https://lore.kernel.org/all/20260831192406.1341841-1-fuad.tabba@linux.dev/

Cheers,
/fuad

>
> Patch 1 is the HCR_EL2.VSE fix posted separately [2]. It is not part
> of this series; it is carried so the series applies as is and Sashiko
> can run on it.
>
> The KVM_ARM_PREFERRED_TARGET documentation fix [3] went out just ahead
> of this series. Nothing here needs it to apply, but patch 17 documents
> vCPU feature availability as something the capabilities report, while
> api.rst 4.83 still points userspace at a bitmap that has always been
> empty.
>
> The series is structured as follows:
>
>   01:     The HCR_EL2.VSE fix, posted separately.
>   02-03:  Capability allowlist and the PVTIME rejection.
>   04-05:  Per-exception-class entry handlers; EL2 owns a protected
>           vCPU's trap configuration.
>   06-08:  Timer state, system register reset and HVC handling at EL2.
>   09-10:  PSCI at EL2, and the KVM_ARM_VCPU_INIT and PSCI version
>           restrictions.
>   11-14:  Host PC adjustments blocked; an UNDEF at EL2 for exit
>           classes the host does not emulate; per-class state
>           marshalling; a protected guest's SError pended with
>           HCR_EL2.VSE.
>   15-16:  Host access to private state, and host power-on of a vCPU
>           EL2 holds powered off, rejected.
>   17:     Documentation.
>
> Still to come: selftests, self-hosted debug, SVE for protected guests,
> and much more, as separate series.
>
> Based on v7.3-rc1 (cee9395acd804).
>
> Cheers,
> /fuad
>
> P.S. Sashiko, bring it on!
>
> [1] https://lore.kernel.org/all/20260729131823.2021516-1-fuad.tabba@linux.dev/
> [2] https://lore.kernel.org/all/20260829071120.2522788-1-fuad.tabba@linux.dev/
> [3] https://lore.kernel.org/all/20260831162815.269851-1-fuad.tabba@linux.dev/
>
> Fuad Tabba (15):
>   KVM: arm64: Sync HCR_EL2.VSE back to the host vCPU under pKVM
>   KVM: arm64: Advertise the capabilities that protected VMs support
>   KVM: arm64: Reject the PVTIME vCPU attribute for protected VMs
>   KVM: arm64: Skip fixed-feature state flush for protected vCPUs
>   KVM: arm64: Add system register reset framework for protected VMs
>   KVM: arm64: Implement HVC handling for protected guests at EL2
>   KVM: arm64: Handle PSCI calls for protected VMs at EL2
>   KVM: arm64: Restrict KVM_ARM_VCPU_INIT and PSCI version for protected
>     VMs
>   KVM: arm64: Prevent host PC adjustments for protected vCPUs
>   KVM: arm64: Inject an UNDEF at EL2 for unhandled protected guest exits
>   KVM: arm64: Add per-EC entry/exit state marshalling for protected
>     guests
>   KVM: arm64: Pend a protected guest's SError with HCR_EL2.VSE only
>   KVM: arm64: Reject host access to protected VM private state
>   KVM: arm64: Reject host power-on of a vCPU that EL2 holds powered off
>   KVM: arm64: Document the protected VM userspace API
>
> Marc Zyngier (2):
>   KVM: arm64: Introduce per-EC entry handlers for pKVM
>   KVM: arm64: Add {flush,sync}_hyp_timer_state() primitives
>
>  Documentation/virt/kvm/api.rst                |  22 +-
>  .../virt/kvm/arm/fw-pseudo-registers.rst      |   2 +
>  Documentation/virt/kvm/arm/pkvm.rst           | 141 ++++-
>  Documentation/virt/kvm/devices/vcpu.rst       |   4 +-
>  arch/arm64/include/asm/kvm_asm.h              |   1 +
>  arch/arm64/include/asm/kvm_host.h             |  21 +
>  arch/arm64/include/asm/kvm_pkvm.h             |  34 +-
>  arch/arm64/kvm/arm.c                          |  40 ++
>  arch/arm64/kvm/guest.c                        |  29 +
>  arch/arm64/kvm/hyp/exception.c                |  27 +-
>  arch/arm64/kvm/hyp/include/nvhe/pkvm.h        |  18 +
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c            | 564 +++++++++++++++++-
>  arch/arm64/kvm/hyp/nvhe/pkvm.c                | 401 ++++++++++++-
>  arch/arm64/kvm/hyp/nvhe/switch.c              |  29 +-
>  arch/arm64/kvm/hyp/nvhe/sys_regs.c            |  91 ++-
>  arch/arm64/kvm/hypercalls.c                   |   7 +
>  arch/arm64/kvm/inject_fault.c                 |   5 +-
>  arch/arm64/kvm/pkvm.c                         |  21 +-
>  arch/arm64/kvm/psci.c                         |   3 +
>  19 files changed, 1378 insertions(+), 82 deletions(-)
>
>
> base-commit: cee9395acd8043be0644b25c34bfa86623f2b935
> --
> 2.39.5
>
