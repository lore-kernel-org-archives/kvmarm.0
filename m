Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BFEC19EED2
	for <kvmarm@lists.linux.dev>; Thu, 24 Apr 2025 14:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745504030; cv=none; b=e7boSu5NiIgJ37A8Xhyl4ubSN450ymrLCzJh2pnnquBny7H+WmQ1RL0WJ5F41DLgSX+qI6pGSuSYoTj7PZOxmNY4XIY5a/IKHJmZeR8FAMyGTuZtJnojOmumAtgbaXztHc9XjB4zoNh7Z/+FsPBhrTeqdkNiGGriMWwoxvBrpNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745504030; c=relaxed/simple;
	bh=gE5B+DRuvYdm1Xx80LASYKx8JQnPdEVc7dWEXx/LEcw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=u8YqEQle4MTCcTiUMg0r+DwuRGMPgnFjW0AD/X7tqISXh87DiJRn9O9UREHxE1bN9L3w0SXRUYYaG2Y9XHyfXjdagYtt6NqDpgYHeAhGXN4WC8WGAUHW1Jia+AGs1jtFVsk8xJAZEbJpBhnhXmSaJ/8J3+ZkpiaEu8nTX0o4leM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=V46pFh3B; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="V46pFh3B"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-39c14016868so1019438f8f.1
        for <kvmarm@lists.linux.dev>; Thu, 24 Apr 2025 07:13:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1745504025; x=1746108825; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+Gp3+Ahd9oztFC0Ee90Z+LBETEK7lh7obhrs3g0E+vA=;
        b=V46pFh3B54Zjv1rkHjzng9tQLwLIbXYf3Gz5vCqt7tT0rKDDHg8nJiP01rq7rM0uge
         HTm12wZB6bLZJ5HUCZ6YexFKsrzjOAW3Af5x/79Qj6WJJnBZIQlH+mf7eu8263/2Npn2
         JZHXa+taQ1H2n/tFDw1zkm18ykpB/dgu0joTbFYm2WpU6G5+C0P8lMRLcqDzzGbYDCIn
         UU/G6CnxLOTMb9MkTdPPXhbwUn3HOwNw2C8qHb7t5w2wGEzWmf5dPasKWzKjj5vUb31D
         OOUlREaXtEJcY+wYKb9CiZixDuPIpjV2ZXoa7o5NQSKLFHb0idGavwbj/AsXSzxiXxbZ
         pLAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745504025; x=1746108825;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+Gp3+Ahd9oztFC0Ee90Z+LBETEK7lh7obhrs3g0E+vA=;
        b=UelRssMmpKBGYBMJ6QUxfuuJShnS3jYTivt9GnBoeAMvuTOmhex2bHOHt/C5p6csxr
         cdZWMTARBdLZ16bzTGlA2sNlhZRImDZIkFNWEGFy9A386fe2BsEiXYHvbSdLwfZDMXDg
         IOwJ0F/Nyefe9F7GeU/3mjmrvXqk40f8wlXzQMktGALn6CPvGanPmdsX5qTZ6//Vf8c+
         wcc6Fl0aPR/jZiG3IOrPwuB/U4y9UoBn8M5REo9cU2nLk4Uuyxo1ZHophFLZWVycuPho
         6KjNKwccjEbolIMNdSdXuEd9PYw4ZbYlEE1cpaS6m7LyLKFH0pKhlJpRGoXvviB2LR5D
         ssjA==
X-Forwarded-Encrypted: i=1; AJvYcCVsmMT50VUaEUKe0EdniBQTjVQSP0mVZCHAL4yfOSDePhlA4m8x2aAu9Gy5uMMu2pl8/ZVLwi4=@lists.linux.dev
X-Gm-Message-State: AOJu0YwiTt+y+BcjoJ5TQpugwsS0wk/stpRbEZzk3S1XaNS7fP90Vw8I
	A3rWRVYWizha8eA72KYAkU2Hd9v9MVvNqHn2OuSMX8StOg+51Zy72DJNj1V0tU8=
X-Gm-Gg: ASbGncsZ91OjcXLhN5JG6+zhRPsYwfrAe27oCPUm+LMHJmIMevoOE/TDrlQtvlXe4D7
	FeCdZyMs3nhYReiBf/DBHOn9A13rqa10E62ARqhGW53vYiqsJEG4ADj5iqDtPpfAYqBDUp+zV+r
	ekgdvAfUhKsDtW7ln2u5k33++cwie6dtjj2vM+XR7W4fYV6DlNIv4oSh15OJtmWP61ACPjI8ovz
	44BJOgiGa2pLuhEYCBVRdqJZ72M6dFjML5YhbF9E6P/ry34uVaBx5FqKiG65HeGcwu6A5azbohj
	HvGf3QDQWpaWwoaTAX/HKaaxOZKDAGtZF6qiqGizp5mHOBSHnkfWjhwqgDEBzexEASoMNKWeIYg
	q7BdZn2+a0rgbA9i/
X-Google-Smtp-Source: AGHT+IG84/KbH73HJzgia5gWQQPbSCf6KDXX629rg6dbolYAjXdYgdIHXLTmBvWlH/T2NybxvuuICA==
X-Received: by 2002:a05:6000:4304:b0:39c:1257:cd40 with SMTP id ffacd0b85a97d-3a06cfb31damr2275855f8f.58.1745504025160;
        Thu, 24 Apr 2025 07:13:45 -0700 (PDT)
Received: from seksu.systems-nuts.com (stevens.inf.ed.ac.uk. [129.215.164.122])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a06d4a8150sm2199951f8f.7.2025.04.24.07.13.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Apr 2025 07:13:44 -0700 (PDT)
From: Karim Manaouil <karim.manaouil@linaro.org>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Karim Manaouil <karim.manaouil@linaro.org>,
	Alexander Graf <graf@amazon.com>,
	Alex Elder <elder@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Marc Zyngier <maz@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Prakruthi Deepak Heragu <quic_pheragu@quicinc.com>,
	Quentin Perret <qperret@google.com>,
	Rob Herring <robh@kernel.org>,
	Srinivas Kandagatla <srini@kernel.org>,
	Srivatsa Vaddagiri <quic_svaddagi@quicinc.com>,
	Will Deacon <will@kernel.org>,
	Haripranesh S <haripran@qti.qualcomm.com>,
	Carl van Schaik <cvanscha@qti.qualcomm.com>,
	Murali Nalajala <mnalajal@quicinc.com>,
	Sreenivasulu Chalamcharla <sreeniva@qti.qualcomm.com>,
	Trilok Soni <tsoni@quicinc.com>,
	Stefan Schmidt <stefan.schmidt@linaro.org>
Subject: [RFC PATCH 00/34] Running Qualcomm's Gunyah Guests via KVM in EL1
Date: Thu, 24 Apr 2025 15:13:07 +0100
Message-Id: <20250424141341.841734-1-karim.manaouil@linaro.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This series introduces the capability of running Gunyah guests via KVM on
Qualcomm SoCs shipped with Gunyah hypervisor [1] (e.g. RB3 Gen2).

The goal of this work is to port the existing Gunyah hypervisor support from a
standalone driver interface [2] to KVM, with the aim of leveraging as much of the
existing KVM infrastructure as possible to reduce duplication of effort around
memory management (e.g. guest_memfd), irqfd, and other core components.

In short, Gunyah is a Type-1 hypervisor, meaning that it runs independently of any
high-level OS kernel such as Linux and runs in a higher CPU privilege level than VMs.
Gunyah is shipped as firmware and guests typically talk with Gunyah via hypercalls.
KVM is designed to run as Type-2 hypervisor. This port allows KVM to run in EL1 and
serve as the interface for VM lifecycle management,while offloading virtualization
to Gunyah.

This series is heavily based on previous work from Elliot Berman and others,
available at:
https://lore.kernel.org/lkml/20240222-gunyah-v17-0-1e9da6763d38@quicinc.com/

Many commits in this series are identical to or derived from previous work. To
preserve authorship and attribution, original `Author:` and `Signed-off-by:` tags
have been retained where appropriate, and occasionally `Reviewed-by:` lines were
kept as well.

While this series builds on much of the original Gunyah implementation, it drops
certain parts in favor of existing upstream features:
  - `gunyah_memfd` is dropped (currently using pinned anonymous pages — see below).
  - `gunyah_irqfd` is dropped in favor of KVM's irqfd.
  - Resource management, vCPU creation, and VM lifecycle are integrated directly
    into KVM’s architecture hooks.

At this stage, the port is functional but still **work in progress**. Notably:
  - Memory for guests is currently backed by **pinned anonymous pages**. This is a
    temporary solution: we intend to migrate to `guest_memfd`.
  - Memory compaction or swap must be avoided for now, as pages donated to Gunyah
    are no longer accessible from the host once mapped into the guest.
  - SMP boot is not available at the moment because Gunyah does not yet
    forward PSCI hypercalls to the host.
  - Virtio is not supported yet.

There is a lot of room for performance improvment. For example, ATM.
there is a lot of privilege level switching between EL1, EL2 (and
possible EL3). As well as context swicthing between guest kernel space
and guest userspace. For those interested, I have a compiled some slides
here to summarise the issues:
https://docs.google.com/presentation/d/1fL1TM1oxBrWFSL8KKw4jQtMDh7NOvyqbWWVu8iQxvoI/edit?usp=sharing

To test the port, a modified version of Qemu is needed. A version can be
found here:
https://github.com/karim-manaouil/qemu-for-gunyah

The series is based on linux-next as of today. A git tree is also
available here (gunyah-kvm branch):
https://github.com/karim-manaouil/linux-next

To test the guest, run (with the modified qemu):
./qemu-system-aarch64 \
	-enable-kvm \
	-machine virt,highmem=off \
	-cpu host \
	-smp 1 \
	-m 1G \
	-nographic \
	-kernel Image \
	-initrd initrd.img \
	-append "console=ttyAMA0 earlycon rdinit=/bin/sh"

Feedback Welcome!

[1] https://www.qualcomm.com/developer/blog/2024/08/learn-about-gunyah--qualcomm-s-open-source--lightweight-hypervis
[2] https://lore.kernel.org/lkml/20240222-gunyah-v17-0-1e9da6763d38@quicinc.com/

Elliot Berman (20):
  docs: gunyah: Introduce Gunyah Hypervisor
  dt-bindings: Add binding for gunyah hypervisor
  gunyah: Common types and error codes for Gunyah hypercalls
  gunyah: Add hypercalls to identify Gunyah
  gunyah: Add hypervisor driver
  gunyah: Add hypercalls to send and receive messages
  gunyah: Add resource manager RPC core
  gunyah: Add VM lifecycle RPC
  gunyah: Translate gh_rm_hyp_resource into gunyah_resource
  gunyah: Add resource tickets
  gunyah: Add hypercalls for running a vCPU
  gunyah: Add hypercalls for demand paging
  gunyah: Add memory parcel RPC
  gunyah: Add interfaces to map memory into guest address space
  gunyah: Add platform ops on mem_lend/mem_reclaim
  gunyah: Add Qualcomm Gunyah platform ops
  gunyah: Share guest VM dtb configuration to Gunyah
  gunyah: Add RPC to enable demand paging
  gunyah: Add RPC to set VM boot context
  gunyah: Add hypercalls for sending doorbell

Karim Manaouil (14):
  KVM: Allow arch-specific vCPU allocation and freeing
  KVM: irqfd: Add architecture hooks for irqfd allocation and
    initialization
  KVM: irqfd: Allow KVM backends to override IRQ injection via set_irq
    callback
  KVM: Add weak stubs for irqchip-related functions for Gunyah builds
  KVM: Add KVM_SET_DTB_ADDRESS ioctl to pass guest DTB address from
    userspace
  KVM: gunyah: Add initial Gunyah backend support
  KVM: gunyah: Pin guest memory
  gunyah: Add basic VM lifecycle management
  gunyah: add proxy-scheduled vCPUs
  gunyah: Share memory parcels
  gunyah: Enable demand paging
  gunyah: allow userspace to set boot cpu context
  KVM: gunyah: Implement irqfd interface
  KVM: gunyah: enable KVM for Gunyah

 .../bindings/firmware/gunyah-hypervisor.yaml  |   82 +
 Documentation/virt/gunyah/index.rst           |  135 ++
 Documentation/virt/gunyah/message-queue.rst   |   68 +
 Documentation/virt/index.rst                  |    1 +
 arch/arm64/Kbuild                             |    1 +
 arch/arm64/gunyah/Makefile                    |    3 +
 arch/arm64/gunyah/gunyah_hypercall.c          |  279 +++
 arch/arm64/include/asm/gunyah.h               |   57 +
 arch/arm64/include/asm/kvm_host.h             |   10 +-
 arch/arm64/include/asm/virt.h                 |    7 +
 arch/arm64/kernel/cpufeature.c                |    4 +
 arch/arm64/kernel/image-vars.h                |    2 +-
 arch/arm64/kvm/Kconfig                        |   22 +-
 arch/arm64/kvm/Makefile                       |   14 +-
 arch/arm64/kvm/gunyah.c                       | 2085 +++++++++++++++++
 drivers/virt/Kconfig                          |    2 +
 drivers/virt/Makefile                         |    1 +
 drivers/virt/gunyah/Kconfig                   |   29 +
 drivers/virt/gunyah/Makefile                  |    7 +
 drivers/virt/gunyah/gunyah.c                  |   55 +
 drivers/virt/gunyah/gunyah_platform_hooks.c   |  117 +
 drivers/virt/gunyah/gunyah_qcom.c             |  220 ++
 drivers/virt/gunyah/rsc_mgr.c                 |  792 +++++++
 drivers/virt/gunyah/rsc_mgr_rpc.c             |  572 +++++
 include/kvm/arm_pmu.h                         |    2 +-
 include/linux/gunyah.h                        |  425 ++++
 include/linux/gunyah_rsc_mgr.h                |  182 ++
 include/linux/irqchip/arm-vgic-info.h         |    2 +-
 include/linux/kvm_host.h                      |    3 +
 include/linux/kvm_irqfd.h                     |    5 +
 include/linux/perf/arm_pmu.h                  |    2 +-
 include/uapi/linux/kvm.h                      |   14 +-
 virt/kvm/eventfd.c                            |   56 +-
 virt/kvm/kvm_main.c                           |   24 +-
 34 files changed, 5258 insertions(+), 22 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/firmware/gunyah-hypervisor.yaml
 create mode 100644 Documentation/virt/gunyah/index.rst
 create mode 100644 Documentation/virt/gunyah/message-queue.rst
 create mode 100644 arch/arm64/gunyah/Makefile
 create mode 100644 arch/arm64/gunyah/gunyah_hypercall.c
 create mode 100644 arch/arm64/include/asm/gunyah.h
 create mode 100644 arch/arm64/kvm/gunyah.c
 create mode 100644 drivers/virt/gunyah/Kconfig
 create mode 100644 drivers/virt/gunyah/Makefile
 create mode 100644 drivers/virt/gunyah/gunyah.c
 create mode 100644 drivers/virt/gunyah/gunyah_platform_hooks.c
 create mode 100644 drivers/virt/gunyah/gunyah_qcom.c
 create mode 100644 drivers/virt/gunyah/rsc_mgr.c
 create mode 100644 drivers/virt/gunyah/rsc_mgr_rpc.c
 create mode 100644 include/linux/gunyah.h
 create mode 100644 include/linux/gunyah_rsc_mgr.h

-- 
2.39.5

