Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEC1C27A90A
	for <kvmarm@lists.linux.dev>; Thu, 24 Apr 2025 14:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745504040; cv=none; b=Z1hk80R4cYDGFnbXDgGvrFNxtzjCL45egxmjy9qKCCAkZ2n2vR0yzuBhsfUXggTFVMp1sEwcTBLZWUtFdGw4PqdqMArltU4FASFGpq9sQMWgIpXS37j3uNMaqDuAxfQt95OCX2gJFPLHBI9Mrt2Bfe8VxvGazlsqKNNDXqanPh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745504040; c=relaxed/simple;
	bh=DSNuQ7AXSuhIK9F2t1tEvg2Y4H20TKEQaYmf+C1AL10=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=cbVE8GHxhL+QqCBxph0S/8R6fyR9Ue/GHEn7Pndn6Q1vOhMtAgtM6ZPCKj1S70RfZWltp/PJRlfqDlgxTh8Kv1A7UurkmFMkkF9seK3H0nItruyynndZPddMYHo0rc7UUtRsexoXTY2Ijav9jXBdxFWM9Cqq9g4hSgVT8ekcT6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=RDvDl95s; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="RDvDl95s"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-39ee57c0b8cso1148384f8f.0
        for <kvmarm@lists.linux.dev>; Thu, 24 Apr 2025 07:13:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1745504036; x=1746108836; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ys+r4b/bN1N9MasjKmdqEss1ssV3C7RnEHLMtxbroxU=;
        b=RDvDl95smySu9SXeCOdPw00AIxpToqKfpEDIpHPJzU0V0ASlUN8J9EB3w2qOEqZkJA
         x66o64F8GTKLwKVd1ZRifeglIcTD37b9Y6VoIIc5qxoDOqKsvJ5zmBHnRcKrrL2qFqpo
         xlONMNbEBPQocXr1vQByNut/1/jgUVUyrS7UHozQwr5ZqXHIy4QwPLKfc7PBEieJw+Mm
         nMligee6F1/xF2aqJ18nHI7/tE1tkBFyttzhsNXG/yLYLsGbSFj9IWJZLDx8hin305yp
         UMQ6ybVCHJN2zrzqVP17xVH6QZiBW71QZeunJFeLhsujF1U/KEM24YEdJQfFkSvmjKPZ
         s2gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745504036; x=1746108836;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ys+r4b/bN1N9MasjKmdqEss1ssV3C7RnEHLMtxbroxU=;
        b=T0aHCgPfJXxKwa3D2sg0jNFrCqBuiUeX2xqCBfw5okpsXIrpFTTtbZ00Pw3vVVWCG4
         mpA71F44+7ZJALeRpIk+8AiD+sACYfEi/VVel0jlj1dpWyA7boBLez2YcdE8LFDjdkoh
         gnH2KrA8J/vqMDX4qbJu7glnnayM4xswGkIn6abcWUCTOUBc/4u8XPCEBUYKDG3PJd+f
         8bEAEIMsx5RBIOvFPqd/ZlN+9pferkzBcO+g6DalsLi/1wg40qlz/J0jJRZBY3DaQWNW
         +ZDlA2dJTcVV16rd4+44Hy+epR0dJy0bUO9aG8shmQHW7oqVhUX+eWPM1iFREMuFxB6L
         kPFg==
X-Forwarded-Encrypted: i=1; AJvYcCVbV1Rk5Zry5FLUBqWui6sIjybEvJNIiYADdjdFmZvrjzrs8IlCLbIB3jUXA60nY3h49OQduYQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YyFaCigsWltjxlSdqBOADKVc3GIhj+qfXfXkHWUmGK18REfcf/V
	gZEbKrugX5Qyub0rkd1eYFD0J7iBG1v+h+tTqWyQPg6mioE4xKz7XKfc7BzuPt8=
X-Gm-Gg: ASbGncv49oc41NrdMmteYFDR+4BxL6MUnBzOEqjBoEOKSzG0wvw1E3w5VuPcdnfI1lt
	QouBgd7y7qtGjK1kmp2djw3J+XE453xVDXp+CQmhwT0xARPH1GK2Sm0KOVFctRV5cabr3iPBblT
	SWwZ3Bfi6exLAwpuiNMwVBgyKfaVVnMq2MLE2EfG8z4EmmZvaLF2nvwMwb4jc9hh1oy1BciI5WP
	6ILZI9Kaj3FhbUFkZWNdaoDuiQj3rXkT5fGBxI/EG4D874Z+AmmgiAUDU36/+PmhlU+A71Po7/p
	cqHwlqqmy2ivI9ObAITNmkBzFk6OhvzO85BLxZ16RIDk76qV1MAo2qQ/+Pyd7y++6/RR25DRw6A
	v3JkxTv7hQIldnisg
X-Google-Smtp-Source: AGHT+IEV5wfX7DpJOSMs66ZIGfzUTJLqW6iFySId3MuH6gASyxb/C/SH9jqJ4yi7vysyGZwOnlgesg==
X-Received: by 2002:a5d:47cb:0:b0:391:3fa7:bf77 with SMTP id ffacd0b85a97d-3a06cf63697mr2421146f8f.31.1745504035418;
        Thu, 24 Apr 2025 07:13:55 -0700 (PDT)
Received: from seksu.systems-nuts.com (stevens.inf.ed.ac.uk. [129.215.164.122])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a06d4a8150sm2199951f8f.7.2025.04.24.07.13.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Apr 2025 07:13:54 -0700 (PDT)
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
	Stefan Schmidt <stefan.schmidt@linaro.org>,
	Elliot Berman <quic_eberman@quicinc.com>
Subject: [RFC PATCH 08/34] docs: gunyah: Introduce Gunyah Hypervisor
Date: Thu, 24 Apr 2025 15:13:15 +0100
Message-Id: <20250424141341.841734-9-karim.manaouil@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250424141341.841734-1-karim.manaouil@linaro.org>
References: <20250424141341.841734-1-karim.manaouil@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Elliot Berman <quic_eberman@quicinc.com>

Gunyah is an open-source Type-1 hypervisor developed by Qualcomm. It
does not depend on any lower-privileged OS/kernel code for its core
functionality. This increases its security and can support a smaller
trusted computing based when compared to Type-2 hypervisors.

Add documentation describing the Gunyah hypervisor and the main
components of the Gunyah hypervisor which are of interest to Linux
virtualization development.

Signed-off-by: Elliot Berman <quic_eberman@quicinc.com>
Reviewed-by: Srivatsa Vaddagiri <quic_svaddagi@quicinc.com>
Signed-off-by: Karim Manaouil <karim.manaouil@linaro.org>
---
 Documentation/virt/gunyah/index.rst         | 135 ++++++++++++++++++++
 Documentation/virt/gunyah/message-queue.rst |  68 ++++++++++
 Documentation/virt/index.rst                |   1 +
 3 files changed, 204 insertions(+)
 create mode 100644 Documentation/virt/gunyah/index.rst
 create mode 100644 Documentation/virt/gunyah/message-queue.rst

diff --git a/Documentation/virt/gunyah/index.rst b/Documentation/virt/gunyah/index.rst
new file mode 100644
index 000000000000..fba2c7a11d0f
--- /dev/null
+++ b/Documentation/virt/gunyah/index.rst
@@ -0,0 +1,135 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=================
+Gunyah Hypervisor
+=================
+
+.. toctree::
+   :maxdepth: 1
+
+   message-queue
+
+Gunyah is a Type-1 hypervisor which is independent of any OS kernel, and runs in
+a more privileged CPU level (EL2 on Aarch64). It does not depend on a less
+privileged operating system for its core functionality. This increases its
+security and can support a much smaller trusted computing base than a Type-2
+hypervisor.
+
+Gunyah is an open source hypervisor. The source repository is available at
+https://github.com/quic/gunyah-hypervisor.
+
+Gunyah provides these following features.
+
+- Scheduling:
+
+  A scheduler for virtual CPUs (vCPUs) on physical CPUs enables time-sharing
+  of the CPUs. Gunyah supports two models of scheduling which can coexist on
+  a running system:
+
+    1. Hypervisor vCPU scheduling in which Gunyah hypervisor schedules vCPUS on
+       its own. The default is a real-time priority with round-robin scheduler.
+    2. "Proxy" scheduling in which an owner-VM can donate the remainder of its
+       own vCPU's time slice to an owned-VM's vCPU via a hypercall.
+
+- Memory Management:
+
+  APIs handling memory, abstracted as objects, limiting direct use of physical
+  addresses. Memory ownership and usage tracking of all memory under its control.
+  Memory partitioning between VMs is a fundamental security feature.
+
+- Interrupt Virtualization:
+
+  Interrupt ownership is tracked and interrupt delivery is directly to the
+  assigned VM. Gunyah makes use of hardware interrupt virtualization where
+  possible.
+
+- Inter-VM Communication:
+
+  There are several different mechanisms provided for communicating between VMs.
+
+    1. Message queues
+    2. Doorbells
+    3. Virtio MMIO transport
+    4. Shared memory
+
+- Virtual platform:
+
+  Architectural devices such as interrupt controllers and CPU timers are
+  directly provided by the hypervisor as well as core virtual platform devices
+  and system APIs such as ARM PSCI.
+
+- Device Virtualization:
+
+  Para-virtualization of devices is supported using inter-VM communication and
+  virtio transport support. Select stage 2 faults by virtual machines that use
+  proxy-scheduled vCPUs can be handled directly by Linux to provide Type-2
+  hypervisor style on-demand paging and/or device emulation.
+
+Architectures supported
+=======================
+AArch64 with a GICv3 or GICv4.1
+
+Resources and Capabilities
+==========================
+
+Services/resources provided by the Gunyah hypervisor are accessible to a
+virtual machine through capabilities. A capability is an access control
+token granting the holder a set of permissions to operate on a specific
+hypervisor object (conceptually similar to a file-descriptor).
+For example, inter-VM communication using Gunyah doorbells and message queues
+is performed using hypercalls taking Capability ID arguments for the required
+IPC objects. These resources are described in Linux as a struct gunyah_resource.
+
+Unlike UNIX file descriptors, there is no path-based or similar lookup of
+an object to create a new Capability, meaning simpler security analysis.
+Creation of a new Capability requires the holding of a set of privileged
+Capabilities which are typically never given out by the Resource Manager (RM).
+
+Gunyah itself provides no APIs for Capability ID discovery. Enumeration of
+Capability IDs is provided by RM as a higher level service to VMs.
+
+Resource Manager
+================
+
+The Gunyah Resource Manager (RM) is a privileged application VM supporting the
+Gunyah Hypervisor. It provides policy enforcement aspects of the virtualization
+system. The resource manager can be treated as an extension of the Hypervisor
+but is separated to its own partition to ensure that the hypervisor layer itself
+remains small and secure and to maintain a separation of policy and mechanism in
+the platform. The resource manager runs at arm64 NS-EL1, similar to other
+virtual machines.
+
+Communication with the resource manager from other virtual machines happens as
+described in message-queue.rst. Details about the specific messages can be found
+in drivers/virt/gunyah/rsc_mgr.c
+
+::
+
+  +-------+   +--------+   +--------+
+  |  RM   |   |  VM_A  |   |  VM_B  |
+  +-.-.-.-+   +---.----+   +---.----+
+    | |           |            |
+  +-.-.-----------.------------.----+
+  | | \==========/             |    |
+  |  \========================/     |
+  |            Gunyah               |
+  +---------------------------------+
+
+The source for the resource manager is available at
+https://github.com/quic/gunyah-resource-manager.
+
+The resource manager provides the following features:
+
+- VM lifecycle management: allocating a VM, starting VMs, destruction of VMs
+- VM access control policy, including memory sharing and lending
+- Interrupt routing configuration
+- Forwarding of system-level events (e.g. VM shutdown) to owner VM
+- Resource (capability) discovery
+
+A VM requires boot configuration to establish communication with the resource
+manager. This is provided to VMs via a 'hypervisor' device tree node which is
+overlaid to the VMs DT by the RM. This node lets guests know they are running
+as a Gunyah guest VM, how to communicate with resource manager, and basic
+description and capabilities of this VM. See
+Documentation/devicetree/bindings/firmware/gunyah-hypervisor.yaml for a
+description of this node.
diff --git a/Documentation/virt/gunyah/message-queue.rst b/Documentation/virt/gunyah/message-queue.rst
new file mode 100644
index 000000000000..96864708f442
--- /dev/null
+++ b/Documentation/virt/gunyah/message-queue.rst
@@ -0,0 +1,68 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+Message Queues
+==============
+Message queue is a simple low-capacity IPC channel between two virtual machines.
+It is intended for sending small control and configuration messages. Each
+message queue is unidirectional and buffered in the hypervisor. A full-duplex
+IPC channel requires a pair of queues.
+
+The size of the queue and the maximum size of the message that can be passed is
+fixed at creation of the message queue. Resource manager is presently the only
+use case for message queues, and creates messages queues between itself and VMs
+with a fixed maximum message size of 240 bytes. Longer messages require a
+further protocol on top of the message queue messages themselves. For instance,
+communication with the resource manager adds a header field for sending longer
+messages which are split into smaller fragments.
+
+The diagram below shows how message queue works. A typical configuration
+involves 2 message queues. Message queue 1 allows VM_A to send messages to VM_B.
+Message queue 2 allows VM_B to send messages to VM_A.
+
+1. VM_A sends a message of up to 240 bytes in length. It makes a hypercall
+   with the message to request the hypervisor to add the message to
+   message queue 1's queue. The hypervisor copies memory into the internal
+   message queue buffer; the memory doesn't need to be shared between
+   VM_A and VM_B.
+
+2. Gunyah raises the corresponding interrupt for VM_B (Rx vIRQ) when any of
+   these happens:
+
+   a. gunyah_msgq_send() has PUSH flag. This is a typical case when the message
+      queue is being used to implement an RPC-like interface.
+   b. Explicitly with gunyah_msgq_push hypercall from VM_A.
+   c. Message queue has reached a threshold depth. Typically, this threshold
+      depth is the size of the queue (in other words: when queue is full, Rx
+      vIRQ is raised).
+
+3. VM_B calls gunyah_msgq_recv() and Gunyah copies message to requested buffer.
+
+4. Gunyah raises the corresponding interrupt for VM_A (Tx vIRQ) when the message
+   queue falls below a watermark depth. Typically, this is when the queue is
+   drained. Note the watermark depth and the threshold depth for the Rx vIRQ are
+   independent values. Coincidentally, this signal is conceptually similar to
+   Clear-to-Send.
+
+For VM_B to send a message to VM_A, the process is identical, except that
+hypercalls reference message queue 2's capability ID. The IRQ will be different
+for the second message queue.
+
+::
+
+      +-------------------+         +-----------------+         +-------------------+
+      |        VM_A       |         |Gunyah hypervisor|         |        VM_B       |
+      |                   |         |                 |         |                   |
+      |                   |         |                 |         |                   |
+      |                   |   Tx    |                 |         |                   |
+      |                   |-------->|                 | Rx vIRQ |                   |
+      |gunyah_msgq_send() | Tx vIRQ |Message queue 1  |-------->|gunyah_msgq_recv() |
+      |                   |<------- |                 |         |                   |
+      |                   |         |                 |         |                   |
+      |                   |         |                 |         |                   |
+      |                   |         |                 |   Tx    |                   |
+      |                   | Rx vIRQ |                 |<--------|                   |
+      |gunyah_msgq_recv() |<--------|Message queue 2  | Tx vIRQ |gunyah_msgq_send() |
+      |                   |         |                 |-------->|                   |
+      |                   |         |                 |         |                   |
+      |                   |         |                 |         |                   |
+      +-------------------+         +-----------------+         +---------------+
diff --git a/Documentation/virt/index.rst b/Documentation/virt/index.rst
index 7fb55ae08598..15869ee059b3 100644
--- a/Documentation/virt/index.rst
+++ b/Documentation/virt/index.rst
@@ -16,6 +16,7 @@ Virtualization Support
    coco/sev-guest
    coco/tdx-guest
    hyperv/index
+   gunyah/index
 
 .. only:: html and subproject
 
-- 
2.39.5

