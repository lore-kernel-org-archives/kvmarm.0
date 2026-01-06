Received: from mail-wm1-f68.google.com (mail-wm1-f68.google.com [209.85.128.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4703D19CCFC
	for <kvmarm@lists.linux.dev>; Tue,  6 Jan 2026 15:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.68
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767715191; cv=none; b=Uo48ENvBtfxxSVL/f4J3sGjNUK2TNvo/aG3D5rOYYolTyF76d2IkfzM8OIBjOxcfTGRpEIZPV4y039oeQwjo/T0QLFxfMFVCuh4t0XCjVP1zoCfKlhXfNdFo1A5GYiYJJrbHZuTa29Kr8Lw/fycdbMRaDOUaTgU/KkD7NWXmjI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767715191; c=relaxed/simple;
	bh=usNCg98JZzPUx5YO1iUbjXtLglJxpMC5jJp1tab0F24=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AbP6tY38Nm1Lyxcj25ZHIfZMn1H0vqRbqosQVNwRFBU+KDQ1AS2kVbaJzQmSD9nJyUJtTkq88ULq9DUtgbbCwGkUSTQKetLi11VOTcQUP88GcYzy7JU87UPWjksw8ct87eFoDxNorpbzA9DLixx+qsn2b/rZuhf7Vmjc1tz2E0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HPWCaI+F; arc=none smtp.client-ip=209.85.128.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HPWCaI+F"
Received: by mail-wm1-f68.google.com with SMTP id 5b1f17b1804b1-47d3ffb0f44so7271655e9.3
        for <kvmarm@lists.linux.dev>; Tue, 06 Jan 2026 07:59:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767715181; x=1768319981; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=recndSpVRxacMOc/NQ+rqHcm8FvHHulQC7DjT4UhT8s=;
        b=HPWCaI+FEO5Rh/GKEHm0UJaIKZEzgowi9CUTyndAIBVON4g5WJmL5tTkIX1yS+HCUV
         +gXmgQg5Mq91oGSV8SS17I0Ow9S3fInArrcpsBNu7c2nLvUAU2XNj58CIJrTEpAERGoB
         tpHBlL1X22eCpcuJybhC1D6obcNFzaKZ3V3Tas0W3daRBcRDBHTM9wVuxd/k3QfURJOb
         VwcUfmy6eifEBYFBax36rP9FQ20McOzgEm4CywisGpTO8beoDVM+c/qFneDkTzd7NN+7
         6t1JDpfuP4Jruc8pSnemrzR0AEHI2a8EUycwJzpdGoJFP7P3ylc5FCg/AAzxJ7Y+p5XP
         u6Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767715181; x=1768319981;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=recndSpVRxacMOc/NQ+rqHcm8FvHHulQC7DjT4UhT8s=;
        b=AWjpTe3KIyt0a8hgzV6AFRO/kWw9utXqd+FlLwDdpeaN8cChdwYtOZ+E859iGATrSB
         NSVW+FqARwVLZl5wNDjSV1UkFZ3hbuS+qQhH6SUwrMN2CLZNgPgDKDgnteuEJvbgBotQ
         m0NDiC99XL4vgzPDxC+DyK1reQNXOTsLRcQIJw00NLsCKqxwKl0Cltrf3s086HfPKJUh
         fndCLknOr5VmwnpHSDWqztn/nrQWKDJ2mJNUP6wUkywlMBj9MzTxvNBdiG+3lvg6pRGm
         mvCdMTxlD7VcBKBgjocjwIXs+Zwc/IH3/SNmrf7ur+dJbyCJjs/Mh6UZxdOrD14jCqjA
         UINA==
X-Gm-Message-State: AOJu0YyTOJbeW8ClB+yKc7HkrRTJjauAjG8EkYBkBlpjX10zBu1Z+dNn
	ZrnaysZ9+QZWPsSwaLyRp9dxyUX/ccPCTeaMz66PIRTNH9cFM6IQKg0RjO6JdzjnZQ==
X-Gm-Gg: AY/fxX6SmjwdMCrtl2CX1Rm6PFt+5G1RTMFrl3Omn7l0Plx+1/7BlCIyWloBDzCBrjU
	nmQUDnpSJ+pSvFtBBOa3UNYGIp9IWxATwsKs6qF93YaXjmzxVz4Mz5q2WdqtJZJDMlb92sYMfR4
	SMj8Oe1U9UtOOSt4XIc+pyXg2ZQ8YciEFOwT5GNordT6NDmivh7+ciGtV9dZk+2qo1xNEybniLd
	1SDUC97VkK+6MDAkISM4MGvYodz/NuJtAvCrQx04t5y/NmaQE+HusOVoWdpnOYFQjgkwLapOxWn
	mJEU1YzhyNBvveFedh09bUyJSsreDB1zOy7fQGg3y+D3eMo8YS/45j9BKzQzN5COwoCO+bx9cai
	7WQvqKBMVs1UrFhrpHVU5NwNreKq1dlLXUpKJJOnJepjZsYtVLKy96wR/MqaRUSp9le9RAE1tXk
	+6o8p4Mj2zb77Jiyyao2H1tHSKS7eIIofjpNHL9HfjbXa2WEy0+g==
X-Google-Smtp-Source: AGHT+IHgQG4n6bkU9UNc+S3Rf0s0cs9v/rYkSfUX4JjXBVVvp3ClgsYmai2b+ZGXIe7uEjuKIwHjXw==
X-Received: by 2002:a05:600c:a108:b0:471:14b1:da13 with SMTP id 5b1f17b1804b1-47d7f36e2abmr28330165e9.14.1767715180422;
        Tue, 06 Jan 2026 07:59:40 -0800 (PST)
Received: from google.com (44.145.34.34.bc.googleusercontent.com. [34.34.145.44])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-432bd5ff0b2sm5090628f8f.42.2026.01.06.07.59.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jan 2026 07:59:40 -0800 (PST)
Date: Tue, 6 Jan 2026 15:59:37 +0000
From: Vincent Donnefort <vdonnefort@google.com>
To: Will Deacon <will@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Quentin Perret <qperret@google.com>, Fuad Tabba <tabba@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH 27/30] KVM: arm64: Add some initial documentation for pKVM
Message-ID: <aV0xaa8MpsmxMMkL@google.com>
References: <20260105154939.11041-1-will@kernel.org>
 <20260105154939.11041-28-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260105154939.11041-28-will@kernel.org>

On Mon, Jan 05, 2026 at 03:49:35PM +0000, Will Deacon wrote:
> Add some initial documentation for pKVM to help people understand what
> is supported, the limitations of protected VMs when compared to
> non-protected VMs and also what is left to do.
> 
> Signed-off-by: Will Deacon <will@kernel.org>
> ---
>  .../admin-guide/kernel-parameters.txt         |   4 +-
>  Documentation/virt/kvm/arm/index.rst          |   1 +
>  Documentation/virt/kvm/arm/pkvm.rst           | 101 ++++++++++++++++++
>  3 files changed, 104 insertions(+), 2 deletions(-)
>  create mode 100644 Documentation/virt/kvm/arm/pkvm.rst
> 
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index a8d0afde7f85..9939dc5654d2 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -3141,8 +3141,8 @@ Kernel parameters
>  			for the host. To force nVHE on VHE hardware, add
>  			"arm64_sw.hvhe=0 id_aa64mmfr1.vh=0" to the
>  			command-line.
> -			"nested" is experimental and should be used with
> -			extreme caution.
> +			"nested" and "protected" are experimental and should be
> +			used with extreme caution.
>  
>  	kvm-arm.vgic_v3_group0_trap=
>  			[KVM,ARM,EARLY] Trap guest accesses to GICv3 group-0
> diff --git a/Documentation/virt/kvm/arm/index.rst b/Documentation/virt/kvm/arm/index.rst
> index ec09881de4cf..0856b4942e05 100644
> --- a/Documentation/virt/kvm/arm/index.rst
> +++ b/Documentation/virt/kvm/arm/index.rst
> @@ -10,6 +10,7 @@ ARM
>     fw-pseudo-registers
>     hyp-abi
>     hypercalls
> +   pkvm
>     pvtime
>     ptp_kvm
>     vcpu-features
> diff --git a/Documentation/virt/kvm/arm/pkvm.rst b/Documentation/virt/kvm/arm/pkvm.rst
> new file mode 100644
> index 000000000000..1882bde8cc0b
> --- /dev/null
> +++ b/Documentation/virt/kvm/arm/pkvm.rst
> @@ -0,0 +1,101 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +====================
> +Protected KVM (pKVM)
> +====================
> +
> +**NOTE**: pKVM is currently an experimental, development feature and
> +subject to breaking changes as new isolation features are implemented.
> +Please reach out to the developers at kvmarm@lists.linux.dev if you have
> +any questions.
> +
> +Overview
> +========
> +
> +Booting a host kernel with '``kvm-arm.mode=protected``' enables
> +"Protected KVM" (pKVM). During boot, pKVM installs a stage-2 identity
> +map page-table for the host and uses it to isolate the hypervisor
> +running at EL2 from the rest of the host running at EL1/0.
> +
> +If ``CONFIG_PROTECTED_VM_UAPI=y``, pKVM permits creation of protected
> +virtual machines (pVMs) by passing the ``KVM_VM_TYPE_ARM_PROTECTED``
> +machine type identifier to the ``KVM_CREATE_VM`` ioctl(). The hypervisor
> +isolates pVMs from the host by unmapping pages from the stage-2 identity
> +map as they are accessed by a pVM. Hypercalls are provided for a pVM to
> +share specific regions of its IPA space back with the host, allowing
> +for communication with the VMM. See hypercalls.rst for more details.
> +
> +Isolation mechanisms
> +====================
> +
> +pKVM relies on a number of mechanisms to isolate PVMs from the host:
> +
> +CPU memory isolation
> +--------------------
> +
> +Status: Isolation of anonymous memory and metadata pages.
> +
> +Metadata pages (e.g. page-table pages and '``struct kvm_vcpu``' pages)
> +are donated from the host to the hypervisor during pVM creation and
> +are consequently unmapped from the stage-2 identity map until the pVM is
> +destroyed.
> +
> +Similarly to regular KVM, pages are lazily mapped into the guest in
> +response to stage-2 page faults handled by the host. However, when
> +running a pVM, these pages are first pinned and then unmapped from the
> +stage-2 identity map as part of the donation procedure. This gives rise
> +to some user-visible differences when compared to non-protected VMs,
> +largely due to the lack of MMU notifiers:
> +
> +* Memslots cannot be moved or deleted once the pVM has started running.
> +* Read-only memslots and dirty logging are not supported.
> +* With the exception of swap, file-backed pages cannot be mapped into a
> +  pVM.
> +* Donated pages are accounted against ``RLIMIT_MLOCK`` and so the VMM
> +  must have a sufficient resource limit or be granted ``CAP_IPC_LOCK``.

Perhaps worth to add that there's no runtime reclaim either so the accounting
will only grow until the VM is destroyed?

> +* Changes to the VMM address space (e.g. a ``MAP_FIXED`` mmap() over a
> +  mapping associated with a memslot) are not reflected in the guest and
> +  may lead to loss of coherency.
> +* Accessing pVM memory that has not been shared back will result in the
> +  delivery of a SIGSEGV.
> +* If a system call accesses pVM memory that has not been shared back
> +  then it will either return ``-EFAULT`` or forcefully reclaim the
> +  memory pages. Reclaimed memory is zeroed by the hypervisor and a
> +  subsequent attempt to access it in the pVM will return ``-EFAULT``
> +  from the ``VCPU_RUN`` ioctl().
> +
> +CPU state isolation
> +-------------------
> +
> +Status: **Unimplemented.**
> +
> +DMA isolation using an IOMMU
> +----------------------------
> +
> +Status: **Unimplemented.**
> +
> +Proxying of Trustzone services
> +------------------------------
> +
> +Status: FF-A and PSCI calls from the host are proxied by the pKVM
> +hypervisor.
> +
> +The FF-A proxy ensures that the host cannot share pVM or hypervisor
> +memory with Trustzone as part of a "confused deputy" attack.
> +
> +The PSCI proxy ensures that CPUs always have the stage-2 identity map
> +installed when they are executing in the host.
> +
> +Protected VM firmware (pvmfw)
> +-----------------------------
> +
> +Status: **Unimplemented.**
> +
> +Resources
> +=========
> +
> +Quentin Perret's KVM Forum 2022 talk entitled "Protected KVM on arm64: A
> +technical deep dive" remains a good resource for learning more about
> +pKVM, despite some of the details having changed in the meantime:
> +
> +https://www.youtube.com/watch?v=9npebeVFbFw
> -- 
> 2.52.0.351.gbe84eed79e-goog
> 
