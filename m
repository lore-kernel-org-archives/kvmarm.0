Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792808697;
	b=PnPZiCTeJn+YQ1JFGuiHDrLSq3fwiNVNXQ6if93kUGluvdQelqHv9DKAZ2cqLkRwIrCT
	 W3bDQc6TqNezn/N99yBptCtrIS7Xaljpjw3b1k5pZENkL9n0rcAFGxYfLtokR0EtBfqWe
	 C1EGBoXt73ehsUuMS5UhZKTNdE1jfA7NcKR5Ly1wXtDLJF3k9OT3PWt7r3LePnDLENNSZ
	 fIgfgInapuC/PJBxUWElGMlOlnZEBgVgkt/7j6VSwnSI1imUs+3azNZVcMlJbahb4+IeL
	 JDKCzSnZtW85QFGYhFbdE1Jc87bA8bzs9EsfFfbVKxkA6x6gk5evUkRoQywMtftAtLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792808697;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=IVlkwGJQd53FilqK8CCX7q0KQcQC9PlRvrNFImbfNek=;
	b=0aOpnGi0xWS1KyqkUq/OYz3lbwjzOjIYrnPaxhDh1ylzVB9gmH8EA2esehE8/t4d5C0j
	 sx1VNfen3Cf35OhlTKyTp9Q1AvGB15qrnEfYIMQjtmtatCcNvuuOJBt5Tg5kT/DMSzu4l
	 8rxO0bTiz8g8iL3o+7+7p8zIRLLZDbYaw4SZaYWDvfjKevu+Tf1vpia03EhRc/Lzrz3UA
	 aYwhKwBjeciHlT44YPjNHWGkWX9lM3BewR7qHhHbvCQEaf+4Xx/qb0BAoM+Tu1vScL4q8
	 w3ozvdIjpYel/k+Yo/oAqfMjlBvPyKghP4u3Qbc9mpbzsxqYhGYzUVUSh0rFgNUoViQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=OE57lqpM;
	arc=none smtp.remote-ip=209.85.128.45
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AB33606A31B
	for <kvmarm@lists.linux.dev>; Sat, 24 Oct 2026 02:24:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2AB33606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=OE57lqpM
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4a20a37703bso10681195e9.1
        for <kvmarm@lists.linux.dev>; Fri, 23 Oct 2026 19:24:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792808694; x=1793413494; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=IVlkwGJQd53FilqK8CCX7q0KQcQC9PlRvrNFImbfNek=;
        b=OE57lqpMfAImVyARPaYhvJ6Dx8kzOYEPSD1zniCFB4meWKRFkQCmk9qjjyLHbuZXas
         tvHZlz8uqlZNwK2lE+NoqxMwg5no4HrmCA3Cjbymp1zEfjtBFg88ESgC24j6bth8YxGB
         ZuCMtt9xdlfl2MVbE9ky8VsZqwloSgMWpgZSDDDQfqidfXEf1EbucbMnECdqMvrbSFPS
         R+Bm+hPi6CCK4Lbo2y2377Z4pVluiGGA8g4lZI4bkIERqukgjS2qrgI2+V3SerP85zQn
         Q9pXEfcgJ+fAtNiJWfPsmqBk4CCs+ol+UtVBs+vBOJBYyc3f9aGo+O1XUjuhc3ehvZsO
         Aj0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792808694; x=1793413494;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IVlkwGJQd53FilqK8CCX7q0KQcQC9PlRvrNFImbfNek=;
        b=D/9syxZDjRje66JOHmWQWiWWI8T4FMNfkjvbIGiSlaCLk+gn0NVkfWGkv0l4k3REdu
         nkteY2PEXI0bK8DnaOPm03zStcZ5H83tMN+HwnG6euaMQoFCnJyx9zLqQhDVaZvAR/mV
         T4BZRN0sZSl4ZkPW63DwSzoa8fK3p3geySqHVtUEG2JMp1w0aC+6HKqYGRrOS4vgsaov
         bX8/7NNi1JHxvjYjlmlCcNgG/K66bv4+He+4MtODeTf/MGQJNth3hbZkfxPw7udPDB4E
         ATxrRovNPOilKcCNt5B+PoU+kjA0F8V81+Eg0iysf22RyWk19htMXkL1qWmB9iHItFFf
         Ubew==
X-Forwarded-Encrypted: i=1; AKwUvBze6zsXfjOoqtXJ+kYMTYE76IW2vJNBpOoQCjnpqjTRm9Bfa9NdsRVhTfOBDbUSeg8mWPtNx6M=@lists.linux.dev
X-Gm-Message-State: AFq9FYLAOwgFwXyhCwpVnIQD71rv9yNRbiasEsOyzqctsK2rq7h+xi3M
	pBk1jr1peXZ9jcmYsbsRJFriO/mu9UVqPMwOI8o5HaSbOYhDE330/61V
X-Gm-Gg: AYBFou1vHsc/Eno1CY6z3C+sBI2JyW6FFnmVG0RIzUehgz5nOQ/IIJpBtLDs9joKMyu
	0MQSnyyObfV/YVYMXjfhLv1P6w7zO3ICuEoBOVHEMSWv/wppLfr1DauC4jmw5EtbsNIyDcenvaw
	uWmcnkOx0bMRyX6lC+e4u5PmEs4sOdn+b0W9qGOwAcoHyuiuYLiciyS2BHRto387xhfsycfEPMH
	acgzKJATAalaHheH6rgRaYL9oIKciIRaHGh7/TBSsmz2NIxfWeA0blmxNWmvInMT99heBNtVAt7
	8RgMhVTcyBk542eIO5RGn/GqQoMbCOoI+/PVKZY0aBsXd/X4VYvePnKUuFB9D0uxRpqF4eMwLRT
	Yr0nUgl4795LxbDzL2GrK45F8xY1xl9TSq2ggxqkEr/idIWPnvHoqWd1g50DLgLBBS2nPkZ9B8k
	/ZGE1RaEzn/ib0M9odYkQtgeSO/ZNc2JmzMMhJk1xJo75dtGisBLDybYSdwCMnQ5BlM6hmeYLGJ
	j0zOl0DIRilpQs6Kv/qjpShLgCzIhWimefIFVkK2+n+R+HyBaYcjybydcJ4KS47nZ8MSgXzGyIA
	q//Z
X-Received: by 2002:a05:600c:4746:b0:4a3:59c9:a744 with SMTP id 5b1f17b1804b1-4a35ac8bb3fmr10452595e9.7.1792808694219;
        Fri, 23 Oct 2026 19:24:54 -0700 (PDT)
Received: from ASHA ([2001:630:3c1:164:1a66:daff:fe85:4026])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a35a5698f1sm21088415e9.8.2026.10.23.19.24.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2026 19:24:52 -0700 (PDT)
From: Amir Noohi <amirmnoohi@gmail.com>
To: Thomas Gleixner <tglx@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: Radu Rendec <radu@rendec.net>,
	Igor Velkov <iav@iav.lv>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Christoffer Dall <cdall@linaro.org>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Amir Noohi <amirmnoohi@gmail.com>
Subject: [PATCH 0/2] genirq, KVM: arm64: Avoid the irq descriptor lock on vCPU load
Date: Sat, 24 Oct 2026 02:24:48 +0000
Message-ID: <20261024022450.629980-1-amirmnoohi@gmail.com>
X-Mailer: git-send-email 2.53.0
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

KVM/arm64 vCPUs slow each other down even when every vCPU has a physical
CPU to itself. On a 32 CPU Ampere Altra (GICv3, VHE) running mainline,
with an in-kernel GICv3 and each vCPU thread pinned to its own otherwise
idle CPU, a vCPU which exits to userspace in a loop manages 320k exits/s
on its own, 120k when 16 vCPUs do the same and 59k with 31. The aggregate
rate stops growing at 8 vCPUs. No two vCPUs share a CPU and nothing is
over-subscribed.

The cause is the interrupt descriptor lock of the host timer interrupts.
Every vCPU load sets their active state with irq_set_irqchip_state()
(twice on VHE: virtual and physical timer). The timer interrupts are per
CPU interrupts, so all CPUs share one descriptor and its lock, while the
state being written is per CPU (a redistributor register on GICv3, a
system register on GICv5). The lock serializes nothing but CPUs updating
their own state. At 8 vCPUs, 99.9% of all lock contention events during
the test have __irq_get_desc_lock() or irq_set_irqchip_state() on the
stack.

Patch 1 adds irq_set_percpu_irqchip_state(), which sets the state of the
calling CPU's instance of a per CPU devid interrupt without taking the
descriptor lock. Patch 2 makes the KVM timer use it. With the series the
same test gets 326k exits/s per vCPU at 31 vCPUs (5.6x), the per vCPU
rate no longer depends on the number of vCPUs, the aggregate rate goes
from 1.8M to 10.1M exits/s, and at 8 vCPUs no lock contention event has
either function on the stack.

The series is based on tip/irq/urgent, as it builds on
__irq_set_irqchip_state() from Igor Velkov's patch 717862eac6ef
("genirq/kexec: Do not take the bus lock of an interrupt chip on the
crash path") [1]. It also applies cleanly to v7.3, current mainline and
kvmarm/next on top of that patch.

I'm aware this arrives during the merge window. There is no urgency on
my side; I'm posting it now so it can be looked at after -rc1, and I'm
happy to rebase and resend then.

Results
-------

Reproducer: a /dev/kvm program (no guest OS) which makes N vCPUs exit to
userspace in a loop, each KVM_RUN being one vCPU load/put, each vCPU
thread pinned to its own otherwise idle CPU and running from its own
guest page, with an in-kernel GICv3 or a userspace irqchip.
The test program is at
https://gist.github.com/amirmnoohi/91560854a63cd3e5fc7a359eb5e17302

32 CPU Ampere Altra (Neoverse-N1, GICv3, VHE), mainline 864c07de0c7d
(v7.4 merge window) with and without the series, same kernel config,
exits/s per vCPU, mean of three 5 second runs:

                in-kernel GICv3           userspace irqchip
  vCPUs       before      after          before      after
      1       319694     324584          319670     345088
      2       298808     326063          289274     343884
      4       294895     328420          284269     343528
      8       278579     328736          112423     343984
     16       119943     328887           56120     282905
     24        77267     327478           36948     253529
     31        58722     326056           28114     250586

Aggregate with the in-kernel GICv3: 2.23M exits/s at 8 vCPUs and 1.82M
at 31 before the series, 2.63M and 10.1M with it. With a userspace
irqchip, which also clears the active state after every exit, the rate
with the series still drops to 251k per vCPU at 31 vCPUs (runs varied by
about 8% there); I have not investigated that.

Lock contention events within 5 seconds at 8 vCPUs with
__irq_get_desc_lock() or irq_set_irqchip_state() on the stack: 122800 of
122847 (in-kernel GICv3) and 7865871 of 7865907 (userspace irqchip)
before, none of 49 and 24 with the series.

If all vCPUs instead run from one shared guest page, the aggregate rate
with the series stops at about 3.6M exits/s from 16 vCPUs on this
machine (also with the timer's GIC writes removed altogether, as an
experiment), and the extra time goes to guest context (front-end
stalls) rather than to the host. Measured that way, the series gains
2.0x at 31 vCPUs instead of 5.6x.

A second machine shows the same: on a 384 CPU HiSilicon Kunpeng 950
(GICv3, VHE, 6.6 based distribution kernel, userspace irqchip), 8 vCPUs
on 8 idle CPUs ran 2.4x slower each than a single vCPU, and 69% of the
time spent in irq_set_irqchip_state() was spent waiting for the lock.

Under QEMU TCG (virt, -cpu max), 8 vCPUs, the series removes every
acquisition of the descriptor lock on this path (LOCK_STAT, 10 seconds):

  host             irqchip     irq_desc_lock_class before      after
                               acquisitions  contentions
  GICv3, VHE       in-kernel        393878        36682        none
  GICv3, nVHE      in-kernel        199654        32080        none
  GICv3, nVHE      userspace        429928       122152        none
  GICv2, VHE       userspace        321430        59542        none

Throughput under TCG does not change, so the real hardware numbers
above are the ones that matter.

Testing
-------

- Built for arm64 (defconfig, debug config), x86_64 (defconfig,
  allnoconfig) and i386 (defconfig) without new warnings, no new W=1 or
  sparse warnings (arch_timer.c has two pre-existing sparse warnings),
  checkpatch clean, bisectable.
- On the Ampere Altra, with and without the series: KVM selftests
  arch_timer (8 and 31 vCPUs migrating every 2ms), arch_timer_edge_cases,
  vgic_irq and vgic_init pass.
- Under QEMU with PROVE_LOCKING, DEBUG_PREEMPT and DEBUG_ATOMIC_SLEEP:
  arch_timer, vgic_irq, vgic_init, vgic_lpi_stress, kvm_create_max_vcpus
  and steal_time pass on GICv3 VHE and GICv3 nVHE hosts (on a GICv2 host
  the vGICv3 based tests skip, the others pass), without warnings or
  lockdep splats.
- Not tested: GICv5 (no hardware), hosts with no_hw_deactivation
  (Apple), protected mode.
- Not changed: on hosts without a vGIC (e.g. Raspberry Pi 3), KVM
  toggles the timer interrupt with enable/disable_percpu_irq(), which
  take the same descriptor lock. Those hosts have few CPUs and their
  interrupt controllers do not implement irq_set_irqchip_state(), so
  the series leaves that path alone.

[1] https://lore.kernel.org/r/20261015-kexec-irq-bus-lock-v2-1-2af15f0757b6@iav.lv

Amir Noohi (2):
  genirq/manage: Provide irq_set_percpu_irqchip_state()
  KVM: arm64: timer: Avoid the irq descriptor lock on vCPU load

 arch/arm64/kvm/arch_timer.c |  2 +-
 include/linux/interrupt.h   |  2 ++
 kernel/irq/manage.c         | 36 ++++++++++++++++++++++++++++++++++++
 3 files changed, 39 insertions(+), 1 deletion(-)


base-commit: 717862eac6eff0eea8ac30a0c0de0bed84922aab
-- 
2.53.0

