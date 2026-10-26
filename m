Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.102
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793028404;
	b=SBXEI0+EgEDdk39d0SThElKlF7BmFe6sCLmHGNbbhKUHcWJf0E6qqQrA/sK+4qwc960/
	 T5JbO/VcwUmFRi/Z2zb0hU8JyZXymv15/cRtIS6VSN5fzTvg0rzTSBLWuFVGzZMBzLoVH
	 xqPYVA70ym6pFdWl2cF7NDdp/hN8Wbe/96CbMXPdMdKtQFm748NnRTB9WeEYrgCvg74Rm
	 Z7xP3E3eRyRBkusDiKYd4p4hPRBvQnX3pBezE9h8BQWd0PrG/Pjqa4cDp10I+6D2eyxLN
	 Ka8j2kdR4tSDuYR5JoAF91VCM3QjWbk8b45f4eepP4VQPUXN7r24ZpiEciQGF+SZrjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793028404;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=6sX1ckCkCo0C9crGPLuXV3itI4WluLyfMysqHfXOIc8=;
	b=b27kE85ML8nm2dmZSYpb0tPrDfb4AUbDwdkbv3Jc2iKuSARZ4SShFIPQTP92A53yQDS5
	 QpskpsRGqg5gbTLDgKzhgBhUhtW0tzvTNY8niHTlindJrbshUW5o2wq0kU3RxssjLxD/L
	 UF4jDor9VPD+dAB9a5eU3njvQWKDGg9o3ZC7isgr1DhFPyoi31eZfcb80jvfqBXXhN8A2
	 rCUVy292lfR9Cq4j5uvDqF6IfKG3YtG8JMC2Iy1aVZ5jGjr0OUTPnoYTJQ+hVQ9YZT8Qp
	 5RnBxyyaOt8LB5nD4C+cNo/NIoHYGA9OT27fZmUjfYxXSCxArEDHf4JDocDmclOlsDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Yug95bfy;
	arc=none smtp.remote-ip=95.215.58.102
Received: from mta1.migadu.com (out-102.mta1.migadu.com [95.215.58.102])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02F5E606A31A
	for <kvmarm@lists.linux.dev>; Mon, 26 Oct 2026 15:26:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 02F5E606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Yug95bfy
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=s46YFljZH4peYcKfdSw0ukYEvKh0IVavDFv9NTBlyqg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793028402; v=1; x=1793633202;
 b=Yug95bfyhInIBBLxd8u3eOeUaRUZqKDFTlAV245v9MCfpVidsG9MXF15Tx24oWy50Mg1BJkh
 V0TMFYqROCTeGQCVJ3V0OBA0bbduJ0VkrglxqpiOGhozxi1/5kfGZmon83H6SE8PJdBGObF1qqY
 1cJJ1un2J85n79Im7RnTVi8s=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id c79fc02862921bcd;
	Mon, 26 Oct 2026 15:26:42 +0000
X-Mizu-Trace-ID: c79fc02862921bcd
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Eric Auger <eric.auger@redhat.com>,
	Will Deacon <will@kernel.org>,
	Fuad Tabba <tabba@google.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] KVM: arm64: vgic-v4: Don't allocate vPEs that a VM can't use
Date: Mon, 26 Oct 2026 15:26:37 +0000
Message-ID: <20261026152639.3926498-1-fuad.tabba@linux.dev>
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

Two fixes for vgic_its_create() allocating vPEs for a VM that never
uses them. Nothing frees them when the VM is destroyed, and each
doorbell handler stays registered with a freed vCPU.

The first is for a GICv2 VM, which KVM can run on a GICv4.0 host whose
CPU interface supports legacy operation. The second is for a GICv3 VM
whose VMM cleared nASSGIcap on a GICv4.1 host with vSGIs.

Tested on AEM FVP, with has-gicv4.1=0 for the GICv2 case and =1 for the
other. With my reproducer (clear nASSGIcap for the second case,
initialise the vgic, create an ITS, destroy the VM), the kernel without
the fix leaves four "vcpu" doorbells in /proc/interrupts in each case,
and the fixed one doesn't leave any.

It doesn't conflict with my vgic init error-path series [1].

Based on Linux 7.3-rc3 (fd73f4a665989; also applies to kvmarm-7.4).

Cheers,
/fuad

[1] https://lore.kernel.org/all/20260921072958.2918477-1-fuad.tabba@linux.dev/

Fuad Tabba (2):
  KVM: arm64: vgic-v4: Don't allocate vPEs for a GICv2 VM
  KVM: arm64: vgic-v4: Don't allocate vPEs when userspace clears
    nASSGIcap

 arch/arm64/kvm/vgic/vgic-v4.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)


base-commit: fd73f4a6659897191fa0d40695fe370925dd3780
-- 
2.47.3

