Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.138
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794308848;
	b=NDHvrgvWos9thE4GQ31SQtck7a28A3Wc2o/ETX12iFel5RdR92TC9qkA6jxOTYv/ZVtg
	 x5IsvfhztSosnCs1V1wVkaXTSdPHw+dcYhYZ8K0L/3soBOEOOglDDKmShFXaGu4lnWa6j
	 TanSRZCURZlvp+DBEbjTZ/LBl21esiHx3e2qAV1FtMPoZJ6eZc4M35U7kVjyC8z1Rgvit
	 L1jFxMOkNkvLSKyQ3CYVHv7qEjuxei3fqyI6Qe2a7Ke2k+K1j3LgPQw77vNdczztMnYma
	 QqrvZ3fuQyF/2FWT33uNxK/flAleJYwF4Nidyqrk5gW83vRhPsgKAsBSWdnIGXR4tJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794308848;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=+WuNPbw52lAW5nlPUrA1jkhNZsabep1sDeJA5piAoms=;
	b=Wl9j80vVp5z9FsYpMosaXiGUFxrVBhswgs5dtHdvXTZ+MOE2zPLRdD9pAEah8ifcwEPV
	 FNKUv6gOC75M8oFZ2apVLljyp/TQJZMzltlHsN5c81gpufPiZCio94rMyf+g7Bl493Vnl
	 l24hZ2prMUDEiEyWzTqv5o52akqdWL9uNEPf6KFoQrsgEL0o6zfc4hiQvQ/GG2H1grXlE
	 Ura6YrQXvy0vQ4LB93fkdL6A66zFRWqepl2L8VP8Gi3QD7F4VSqS0kwZvbr2oxK3EsSZW
	 s8SQcZttHY50A4IC1xa7yfJflzPnrY9aiSe5Q3rwp+j2MgqU/Qzuy2YEI9uF+tFyZMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=BwrYfzBq;
	arc=none smtp.remote-ip=91.218.175.138
Received: from mta0.migadu.com (out-138.mta0.migadu.com [91.218.175.138])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CF5C606A31C
	for <kvmarm@lists.linux.dev>; Tue, 10 Nov 2026 11:07:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8CF5C606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=BwrYfzBq
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=36LRZfyr2OW4sVBNO3Dr02OzqJxkojxqpAlVuG8gQtI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794308845; v=1; x=1794913645;
 b=BwrYfzBqy01tK58Abn2QpNMEP9IAl7aiaY7r5v6sXKr+oYs6igvVm2u5bDqeUaOX/ql42fMV
 /t3Hf17CBNKq9zx0809S+p4C0Yj8uilC0pBh0q/Kqgw1aaH17P6P5875OFUlnM63qiTdDlCKrOQ
 4d3Tp/GwlVmzKDgt3I5Feh3A=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 6358020379288e82;
	Tue, 10 Nov 2026 11:07:25 +0000
X-Mizu-Trace-ID: 6358020379288e82
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	kvmarm@lists.linux.dev,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Will Deacon <will@kernel.org>,
	Fuad Tabba <tabba@google.com>
Subject: [PATCH 0/2] KVM: Bound KVM_PRE_FAULT_MEMORY by the vCPU's dirty ring
Date: Tue, 10 Nov 2026 11:07:22 +0000
Message-ID: <20261110110724.3614412-1-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.47.3
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

Hi folks,

KVM_PRE_FAULT_MEMORY never checks the vCPU's dirty ring, so one call
over enough populated, dirty-logged pages overflows it. The first patch
stops the loop at the soft limit, as KVM_RUN does. A stopped call
returns its partial progress, or, if it stopped before any, -ENOSPC
rather than the retryable -EAGAIN, since no retry can succeed until the
ring is harvested. The second patch adds the case to
pre_fault_memory_test.

On x86 a read fault normally maps a host-writable page writable and logs
it at once, so pre-faulting overflows the ring. Sean's auto-prefetch
series [1] keeps that behaviour for a pre-fault, so this series bounds
the loop rather than have x86 write-protect a pre-faulted page. On
arm64, which gained the ioctl in 7.4, pre-faulting RAM logged with the
ring alone overflows it too, until Wei-Lin's fix [2] is in mainline.

Pre-faulting isn't the only ioctl that can push past the ring's
reserve. On x86, KVM_SET_MSRS does too when it writes the wall clock or
the Hyper-V hypercall page: up to a few hundred entries in a single
call, with no bound across calls. KVM_SET_MSRS can't take the same
stop, since a short count from it means the MSR failed and QEMU asserts
on it.

What those paths should do when the ring fills is an open question for
the dirty ring API, which I don't think belongs in this series.
Pre-faulting a large logged range is a supported use of the ioctl, so
the loop should handle a full ring rather than lose entries.

Tested on x86 and arm64 under QEMU: without the first patch, the new
case hits the WARN on both.

Based on Linux 7.4-rc2 (7475ea8b58616).

Cheers,
/fuad

[1] https://lore.kernel.org/all/20261028202607.1844883-1-seanjc@google.com/
[2] https://lore.kernel.org/all/20261029175238.3214788-2-weilin.chang@arm.com/

Fuad Tabba (2):
  KVM: Stop KVM_PRE_FAULT_MEMORY when the vCPU's dirty ring is full
  KVM: selftests: Test KVM_PRE_FAULT_MEMORY against a full dirty ring

 Documentation/virt/kvm/api.rst                |  9 +-
 include/linux/kvm_dirty_ring.h                |  6 ++
 .../selftests/kvm/pre_fault_memory_test.c     | 85 +++++++++++++++++++
 virt/kvm/dirty_ring.c                         |  2 +-
 virt/kvm/kvm_main.c                           |  6 ++
 5 files changed, 105 insertions(+), 3 deletions(-)


base-commit: 7475ea8b58616b33c04afb976cf0fbaad9dd63fb
-- 
2.47.3

