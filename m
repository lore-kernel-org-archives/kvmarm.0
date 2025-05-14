Received: from mail-il1-f202.google.com (mail-il1-f202.google.com [209.85.166.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85EAD28DB63
	for <kvmarm@lists.linux.dev>; Wed, 14 May 2025 19:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747250528; cv=none; b=qlSiBQKzcVpU0YJ8c4QIF2JzXMnUJiMMSwZBD4JVQLw9RgzdzgGcQnSLEE+yZ2OTC1RT6wvtYg+dqDLDHaZ2aYR1CQQpf8RPRUyrRNgozd85SnZPh1S2IjDtFMK3whiSa3NEjsSrUNxKSMoJr4AqyhgzcDr4VCtvUmmfy7ubx9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747250528; c=relaxed/simple;
	bh=6GLh2vAUb131giOvQk8M/um3okSJGroCjyJghDkewc8=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=d5w/URyGy8yfPZf7rmAtPR3fqBuOVS2KLBjyQVTLZjFAvhZARodYuhlJBRsKncwsxI+265KbVm8GeQfdjM+97Gc2wLih5Obi/Jw0HJBPI+nsRLgV0QRKNnXD7QOjTPmNeUUIKDq+WDghvWApSRWaOC8hd+pYykJeQdR7IJZ4cdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=P1ZVpI1o; arc=none smtp.client-ip=209.85.166.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="P1ZVpI1o"
Received: by mail-il1-f202.google.com with SMTP id e9e14a558f8ab-3da76423ba1so2936215ab.0
        for <kvmarm@lists.linux.dev>; Wed, 14 May 2025 12:22:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747250525; x=1747855325; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=c8ePtC5HFZo+bckSClZmheBHRBfYWwooCNAcmQiJQhY=;
        b=P1ZVpI1o3jqeOsrUJ/O/yGgDsUhkRpYnBYO0QPaGqzfHZsT4yRZnVz0dDZYEYFFh94
         ye6qSjIy5HqtszoAZeAbnDZYCJ6lGV2UYUdelPZ/VIxusiFvw14/IRY7HPkedU5Hc5Ss
         S7bnAbM6XUp3LH0QSo4AQhqhISg3edE6//Cw+dRfBHlV4ggN6ZxNV9A/lceZhtsl8daA
         CxJOTH0L66SUjCavcx8Ek7bKmaLAIHqA+WSqF794ml2AKY7dkNAiCZwt4govF/WAtf8a
         YAvQ/mV2SpOjm0PCJ2cloSqFsRQUfNEQ4n1VHxbeeUjr/SM4HLWNXxGHgOIvfk57a8hq
         jbVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747250525; x=1747855325;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=c8ePtC5HFZo+bckSClZmheBHRBfYWwooCNAcmQiJQhY=;
        b=xSlJEb4dpZK8g6NT6Krz57f+cEs6WgHVfjuGem/QwQz66qmrV5tEoalE91Kw0mB3AQ
         DVI6cFCAAKM0eVrjIKaD7PPANlrCkGY4zmjURTZwUjqLV0bKiJMlzorrc9BbEdDcb+8b
         vXexFHKDGzTfB8FyIgcgjTw7GRAJGZ32pw2H1lMf6g1j3f3D6ggt5+zbVSHndFf1H6xn
         msgzD+ekiUaVStZkjKAw4/Dcroj7/+6KZd/lP+Iu/NzrBDHDpxau9h95sS9kmFxhsJA+
         S1kUimfw9UikLMhDd5U7cuxz4ITbooKYFlLUutvkvUT1r7f8vwXU/Ds/cLv9jvCflB7O
         qpOA==
X-Forwarded-Encrypted: i=1; AJvYcCVd3FCyzl0xhRzJ9O+/w5XuyzjrEP8CXRwUFAM8Oe0pWEATD+6l3AW+DCezd2P8gCxsYSn65+w=@lists.linux.dev
X-Gm-Message-State: AOJu0YyFDOd0OtA8qQZ8mWKhetr17g8Ip/ruF9B/koqbvyXVXozygQIe
	PXpOyh3aoJDk3ZiFQ37bhPODGsXfbuIS5q+ajIc21fat944OF9wK1y0qOLYbm8qAxrdXeg2znby
	4IHOngw==
X-Google-Smtp-Source: AGHT+IF1ogsTmn2Q4LFsh6tOmFxWnhQ3nGtiA78U3XsyCpRhWXAptzz3zxmhkhTqbmqZ1kXN3wTOk6bikL9+
X-Received: from ilbbt9.prod.google.com ([2002:a05:6e02:2489:b0:3d9:37ff:afd7])
 (user=rananta job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6e02:178f:b0:3d6:cbad:235c
 with SMTP id e9e14a558f8ab-3db6f7ad141mr53575415ab.6.1747250525722; Wed, 14
 May 2025 12:22:05 -0700 (PDT)
Date: Wed, 14 May 2025 19:21:56 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.49.0.1101.gccaa498523-goog
Message-ID: <20250514192159.1751538-1-rananta@google.com>
Subject: [PATCH 0/3] KVM: arm64: Allow vGICv4 configuration per VM
From: Raghavendra Rao Ananta <rananta@google.com>
To: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>
Cc: Raghavendra Rao Anata <rananta@google.com>, Mingwei Zhang <mizhang@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello,

When kvm-arm.vgic_v4_enable=1, KVM adds support for direct interrupt
injection by default to all the VMs in the system, aka GICv4. A
shortcoming of the GIC architecture is that there's an absolute limit on
the number of vPEs that can be tracked by the ITS. It is possible that
an operator is running a mix of VMs on a system, only wanting to provide
a specific class of VMs with hardware interrupt injection support.

To support this, introduce a GIC attribute, KVM_DEV_ARM_VGIC_CONFIG_GICV4,
for the userspace to enable or disable vGICv4 for a given VM.

The attribute allows the configuration only when vGICv4 is enabled in KVM,
else it acts a read-only attribute returning
KVM_DEV_ARM_VGIC_CONFIG_GICV4_UNAVAILABLE as the value.

On the other hand, if KVM has the vGICv4 enabled via the cmdline, the
VM absorbs this configuration by default to maintain the backward
compatibility. Userspace can get the attribute's value to check if the VM
has vGICv4 support if it sees KVM_DEV_ARM_VGIC_CONFIG_GICV4_ENABLE as the
value. As required, it can disable vGICv4 by setting
KVM_DEV_ARM_VGIC_CONFIG_GICV4_DISABLE as the value.

The patches are distrubuted as:

Patch-1 contains the KVM code that introduces the
KVM_DEV_ARM_VGIC_CONFIG_GICV4 attr, and adds all the support around it.

Patch-2 adds the documentation for the said attribute.

Patch-3 extends the vgic_init kvm/arm64 selftest that tests the get and
set of this attribute in various configurations.

Thank you.
Raghavendra

Raghavendra Rao Ananta (3):
  kvm: arm64: Add support for KVM_DEV_ARM_VGIC_CONFIG_GICV4 attr
  docs: kvm: devices/arm-vgic-v3: Document KVM_DEV_ARM_VGIC_CONFIG_GICV4
    attr
  KVM: selftests: Extend vgic_init to test GICv4 config attr

 .../virt/kvm/devices/arm-vgic-v3.rst          | 24 ++++++--
 arch/arm64/include/uapi/asm/kvm.h             |  7 +++
 arch/arm64/kvm/vgic/vgic-init.c               |  3 +
 arch/arm64/kvm/vgic/vgic-its.c                |  2 +-
 arch/arm64/kvm/vgic/vgic-kvm-device.c         | 39 +++++++++++++
 arch/arm64/kvm/vgic/vgic-mmio-v3.c            | 12 ++--
 arch/arm64/kvm/vgic/vgic-v3.c                 | 16 ++++-
 arch/arm64/kvm/vgic/vgic-v4.c                 |  8 +--
 include/kvm/arm_vgic.h                        |  5 ++
 tools/testing/selftests/kvm/arm64/vgic_init.c | 58 +++++++++++++++++++
 10 files changed, 157 insertions(+), 17 deletions(-)


base-commit: 0af2f6be1b4281385b618cb86ad946eded089ac8
--
2.49.0.1101.gccaa498523-goog

