Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E4C727714
	for <kvmarm@lists.linux.dev>; Tue, 14 Feb 2023 17:13:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1676394790;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=y/5VgWxD5A7kEC1uUIaEm14WHnCpjbWdzDimNIwkMXo=;
	b=aUHbYn7dQgYEL51cejFJsSbHQx2rzo+zoVF6ES+e79uSaVSHQiFc2ZQ1qtLdFya6MPCABf
	qPKJZpLRTuzF0HBveYxH/2FPrui8AGATYEW538izl7vU2/VVfB4mIc3J+FkO+tiiHBQ6dP
	p/AB4TsbfQ8XgRdTc7EjC471DjRJ/So=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-622-J1HrrobaOTG5wgXEntABDA-1; Tue, 14 Feb 2023 12:13:06 -0500
X-MC-Unique: J1HrrobaOTG5wgXEntABDA-1
Received: by mail-wm1-f72.google.com with SMTP id k17-20020a05600c1c9100b003dd41ad974bso8985407wms.3
        for <kvmarm@lists.linux.dev>; Tue, 14 Feb 2023 09:13:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=y/5VgWxD5A7kEC1uUIaEm14WHnCpjbWdzDimNIwkMXo=;
        b=GhZkUr+CHk+5bSi0QmnKNnIdlPXCQyYYltiwOc6hCWRf2wNiVoFDzSfIJcBntv+tkJ
         QMgg4iaHcaPbk5u11oARyK7WqchRVcVKOCP+HYm2a94mrYDW1kDjrlKn6IT6ahKaNCqX
         QGeSX+A6adfrTc2WnCesq1CaCCSZl4Q6Rd+QaCZBmlXvHoACzYQe9C4AstvKSzntJ+B2
         qvO1ymjfAnzHIn/OGltOE6ZdXlXfBb7lxDHtgCMg47SX3xAe7vkkuv6+WZk/kp3lNPc6
         biH5FaZ8aYF8DmUcVl2apnC483qNIcrEVLfjUq24td1MTs70qrLIsyjCX5o0EqnlgNIC
         GXsA==
X-Gm-Message-State: AO0yUKW2d11nOsOHcT+qfFJrO1xE5mnJgiVff0iznn8f2LhGpqsMCLZ6
	JSRzSLD2jzwVQ1XiFpwzhs8Urww/COgHaQpVwh6IrSwvsf45yvVkmF2hsdaO73lokOn+CwmKjYA
	AarGwCBhJ4oryXeC3
X-Received: by 2002:a05:600c:2e95:b0:3dc:d5b:5f6a with SMTP id p21-20020a05600c2e9500b003dc0d5b5f6amr2691503wmn.30.1676394784976;
        Tue, 14 Feb 2023 09:13:04 -0800 (PST)
X-Google-Smtp-Source: AK7set/cJ2piCMFvK42J7bNZHKpTnu+3/VQ2u9+S6qVF3JZHtDfSzPg6gZVBJQN9lL9IMudwblyc5Q==
X-Received: by 2002:a05:600c:2e95:b0:3dc:d5b:5f6a with SMTP id p21-20020a05600c2e9500b003dc0d5b5f6amr2691475wmn.30.1676394784663;
        Tue, 14 Feb 2023 09:13:04 -0800 (PST)
Received: from work-vm (ward-16-b2-v4wan-166627-cust863.vm18.cable.virginm.net. [81.97.203.96])
        by smtp.gmail.com with ESMTPSA id o19-20020a05600c4fd300b003dc59d6f2f8sm18425547wmq.17.2023.02.14.09.13.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Feb 2023 09:13:04 -0800 (PST)
Date: Tue, 14 Feb 2023 17:13:01 +0000
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Chao Peng <chao.p.peng@linux.intel.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>, James Morse <james.morse@arm.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Joey Gouly <Joey.Gouly@arm.com>, Marc Zyngier <maz@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Quentin Perret <qperret@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Steven Price <steven.price@arm.com>, Thomas Huth <thuth@redhat.com>,
	Will Deacon <will@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>,
	kvmarm@lists.cs.columbia.edu
Subject: Re: [RFC] Support for Arm CCA VMs on Linux
Message-ID: <Y+vBHXbxPBgHxzGY@work-vm>
References: <20230127112248.136810-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20230127112248.136810-1-suzuki.poulose@arm.com>
User-Agent: Mutt/2.2.9 (2022-11-12)
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

* Suzuki K Poulose (suzuki.poulose@arm.com) wrote:
> We are happy to announce the early RFC version of the Arm
> Confidential Compute Architecture (CCA) support for the Linux
> stack. The intention is to seek early feedback in the following areas:
>  * KVM integration of the Arm CCA
>  * KVM UABI for managing the Realms, seeking to generalise the operations
>    wherever possible with other Confidential Compute solutions.
>    Note: This version doesn't support Guest Private memory, which will be added
>    later (see below).
>  * Linux Guest support for Realms
> 
> Arm CCA Introduction
> =====================
> 
> The Arm CCA is a reference software architecture and implementation that builds
> on the Realm Management Extension (RME), enabling the execution of Virtual
> machines, while preventing access by more privileged software, such as hypervisor.
> The Arm CCA allows the hypervisor to control the VM, but removes the right for
> access to the code, register state or data that is used by VM.
> More information on the architecture is available here[0].
> 
>     Arm CCA Reference Software Architecture
> 
>         Realm World    ||    Normal World   ||  Secure World  ||
>                        ||        |          ||                ||
>  EL0 x-------x         || x----x | x------x ||                ||
>      | Realm |         || |    | | |      | ||                ||
>      |       |         || | VM | | |      | ||                ||
>  ----|  VM*  |---------||-|    |---|      |-||----------------||
>      |       |         || |    | | |  H   | ||                ||
>  EL1 x-------x         || x----x | |      | ||                ||
>          ^             ||        | |  o   | ||                ||
>          |             ||        | |      | ||                ||
>  ------- R*------------------------|  s  -|---------------------
>          S             ||          |      | ||                ||
>          I             ||          |  t   | ||                ||
>          |             ||          |      | ||                || 
>          v             ||          x------x ||                ||
>  EL2    RMM*           ||              ^    ||                ||
>          ^             ||              |    ||                ||
>  ========|=============================|========================
>          |                             | SMC
>          x--------- *RMI* -------------x
> 
>  EL3                   Root World
>                        EL3 Firmware
>  ===============================================================
> Where :
>  RMM - Realm Management Monitor
>  RMI - Realm Management Interface
>  RSI - Realm Service Interface
>  SMC - Secure Monitor Call

Hi,
  It's nice to see this full stack posted - thanks!

Are there any pointers to information on attestation and similar
measurement things?  In particular, are there any plans for a vTPM
for Realms - if there were, it would make life easy for us, since we
can share some user space stuff with other CoCo systems.

Dave

> RME introduces a new security state "Realm world", in addition to the
> traditional Secure and Non-Secure states. The Arm CCA defines a new component,
> Realm Management Monitor (RMM) that runs at R-EL2. This is a standard piece of
> firmware, verified, installed and loaded by the EL3 firmware (e.g, TF-A), at
> system boot.
> 
> The RMM provides standard interfaces - Realm Management Interface (RMI) - to the
> Normal world hypervisor to manage the VMs running in the Realm world (also called
> Realms in short). These are exposed via SMC and are routed through the EL3
> firmwre.
> The RMI interface includes:
>   - Move a physical page from the Normal world to the Realm world
>   - Creating a Realm with requested parameters, tracked via Realm Descriptor (RD)
>   - Creating VCPUs aka Realm Execution Context (REC), with initial register state.
>   - Create stage2 translation table at any level.
>   - Load initial images into Realm Memory from normal world memory
>   - Schedule RECs (vCPUs) and handle exits
>   - Inject virtual interrupts into the Realm
>   - Service stage2 runtime faults with pages (provided by host, scrubbed by RMM).
>   - Create "shared" mappings that can be accessed by VMM/Hyp.
>   - Reclaim the memory allocated for the RAM and RTTs (Realm Translation Tables)
> 
> However v1.0 of RMM specifications doesn't support:
>  - Paging protected memory of a Realm VM. Thus the pages backing the protected
>    memory region must be pinned.
>  - Live migration of Realms.
>  - Trusted Device assignment.
>  - Physical interrupt backed Virtual interrupts for Realms
> 
> RMM also provides certain services to the Realms via SMC, called Realm Service
> Interface (RSI). These include:
>  - Realm Guest Configuration.
>  - Attestation & Measurement services
>  - Managing the state of an Intermediate Physical Address (IPA aka GPA) page.
>  - Host Call service (Communication with the Normal world Hypervisor)
> 
> The specifications for the RMM software is currently at *v1.0-Beta2* and the
> latest version is available here [1].
> 
> The Trusted Firmware foundation has an implementation of the RMM - TF-RMM -
> available here [3].
> 
> Implementation
> =================
> 
> This version of the stack is based on the RMM specification v1.0-Beta0[2], with
> following exceptions :
>   - TF-RMM/KVM currently doesn't support the optional features of PMU,
>      SVE and Self-hosted debug (coming soon).
>   - The RSI_HOST_CALL structure alignment requirement is reduced to match
>      RMM v1.0 Beta1
>   - RMI/RSI version numbers do not match the RMM spec. This will be
>     resolved once the spec/implementation is complete, across TF-RMM+Linux stack.
> 
> We plan to update the stack to support the latest version of the RMMv1.0 spec
> in the coming revisions.
> 
> This release includes the following components :
> 
>  a) Linux Kernel
>      i) Host / KVM support - Support for driving the Realms via RMI. This is
>      dependent on running in the Kernel at EL2 (aka VHE mode). Also provides
>      UABI for VMMs to manage the Realm VMs. The support is restricted to 4K page
>      size, matching the Stage2 granule supported by RMM. The VMM is responsible
>      for making sure the guest memory is locked.
> 
>        TODO: Guest Private memory[10] integration - We have been following the
>        series and support will be added once it is merged upstream.
>      
>      ii) Guest support - Support for a Linux Kernel to run in the Realm VM at
>      Realm-EL1, using RSI services. This includes virtio support (virtio-v1.0
>      only). All I/O are treated as non-secure/shared.
>  
>  c) kvmtool - VMM changes required to manage Realm VMs. No guest private memory
>     as mentioned above.
>  d) kvm-unit-tests - Support for running in Realms along with additional tests
>     for RSI ABI.
> 
> Running the stack
> ====================
> 
> To run/test the stack, you would need the following components :
> 
> 1) FVP Base AEM RevC model with FEAT_RME support [4]
> 2) TF-A firmware for EL3 [5]
> 3) TF-A RMM for R-EL2 [3]
> 4) Linux Kernel [6]
> 5) kvmtool [7]
> 6) kvm-unit-tests [8]
> 
> Instructions for building the firmware components and running the model are
> available here [9]. Once, the host kernel is booted, a Realm can be launched by
> invoking the `lkvm` commad as follows:
> 
>  $ lkvm run --realm 				 \
> 	 --measurement-algo=["sha256", "sha512"] \
> 	 --disable-sve				 \
> 	 <normal-vm-options>
> 
> Where:
>  * --measurement-algo (Optional) specifies the algorithm selected for creating the
>    initial measurements by the RMM for this Realm (defaults to sha256).
>  * GICv3 is mandatory for the Realms.
>  * SVE is not yet supported in the TF-RMM, and thus must be disabled using
>    --disable-sve
> 
> You may also run the kvm-unit-tests inside the Realm world, using the similar
> options as above.
> 
> 
> Links
> ============
> 
> [0] Arm CCA Landing page (See Key Resources section for various documentations)
>     https://www.arm.com/architecture/security-features/arm-confidential-compute-architecture
> 
> [1] RMM Specification Latest
>     https://developer.arm.com/documentation/den0137/latest
> 
> [2] RMM v1.0-Beta0 specification
>     https://developer.arm.com/documentation/den0137/1-0bet0/
> 
> [3] Trusted Firmware RMM - TF-RMM
>     https://www.trustedfirmware.org/projects/tf-rmm/
>     GIT: https://git.trustedfirmware.org/TF-RMM/tf-rmm.git
> 
> [4] FVP Base RevC AEM Model (available on x86_64 / Arm64 Linux)
>     https://developer.arm.com/Tools%20and%20Software/Fixed%20Virtual%20Platforms
> 
> [5] Trusted Firmware for A class
>     https://www.trustedfirmware.org/projects/tf-a/
> 
> [6] Linux kernel support for Arm-CCA
>     https://gitlab.arm.com/linux-arm/linux-cca
>     Host Support branch:	cca-host/rfc-v1
>     Guest Support branch:	cca-guest/rfc-v1
> 
> [7] kvmtool support for Arm CCA
>     https://gitlab.arm.com/linux-arm/kvmtool-cca cca/rfc-v1
> 
> [8] kvm-unit-tests support for Arm CCA
>     https://gitlab.arm.com/linux-arm/kvm-unit-tests-cca  cca/rfc-v1
> 
> [9] Instructions for Building Firmware components and running the model, see
>     section 4.19.2 "Building and running TF-A with RME"
>     https://trustedfirmware-a.readthedocs.io/en/latest/components/realm-management-extension.html#building-and-running-tf-a-with-rme
> 
> [10] fd based Guest Private memory for KVM
>    https://lkml.kernel.org/r/20221202061347.1070246-1-chao.p.peng@linux.intel.com
> 
> Cc: Alexandru Elisei <alexandru.elisei@arm.com>
> Cc: Andrew Jones <andrew.jones@linux.dev>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Chao Peng <chao.p.peng@linux.intel.com>
> Cc: Christoffer Dall <christoffer.dall@arm.com>
> Cc: Fuad Tabba <tabba@google.com>
> Cc: James Morse <james.morse@arm.com>
> Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
> Cc: Joey Gouly <Joey.Gouly@arm.com>
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Oliver Upton <oliver.upton@linux.dev>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Quentin Perret <qperret@google.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Steven Price <steven.price@arm.com>
> Cc: Thomas Huth <thuth@redhat.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Zenghui Yu <yuzenghui@huawei.com>
> To: linux-coco@lists.linux.dev
> To: kvmarm@lists.linux.dev
> Cc: kvmarm@lists.cs.columbia.edu
> Cc: linux-arm-kernel@lists.infradead.org
> To: linux-kernel@vger.kernel.org
> To: kvm@vger.kernel.org
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

