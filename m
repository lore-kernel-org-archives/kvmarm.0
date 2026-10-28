Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.183
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793182407;
	b=rVDNa3W6MSZuXz8IUGbcWFFlli/mLoTpyWRiov5d5CFLLmONBJKbO0UnzHCUGSmk3iRH
	 wiIvpk6cTDbWXEKR2NmQzfxZyATv7/C2GW1BZWTJcWt/OIDjQYosMZGAzt/v+sxWEmkGE
	 NXx6nzgJjVRrFVr+zsmeYVCowk5fPk8As8upJ2n+TjqSuwZLApOZ/KmR8zsfXrOIwOFhV
	 m26q9Mv7hjyVuA/WE1aIgHuBCl8RbSQfb/6I567pNahh7/2E2tTBqLUsiDFQzJ+F2336M
	 ObOPXv5c/7uv3wtk+tIYHarwjXWfotb8o3yoyUlBJTeK71bFSe8BqasEpYP43ryFt/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793182407;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=EEYPoRpJNmhk9PNugIQXadp8K0qikeOnykwdRW9fgMk=;
	b=oX1J4S3C4DdrGBxhaa7yD8vBhFNMop75MmKcF3C0XEpmo9EKgJrcTQfMD59H4CdAuo/N
	 wNQsiuV69Gm/ZxNV4ZAZBS4DlNB/A1I/qAGEWaxxsYGq+NlFinbpwHpCXDudmY8+s9JmF
	 g/L0Xa2fTm5IIMJD0dY1dHYgDr3+SdqZgN22+AWMfna1ofmV0iiIFs/c/oR2meIoY6Hso
	 UaLisubyLFsd6zRhglFaTp8ivKgei9BW4B//wXcBE4wN0mVeVVjeZOLfz1lK5rWJ7TXTQ
	 ymDKhKJjKZWvu7QjYTS3Eyg8iJkADp0S3t3/Etu1d0zlY9imGrdOL+dmxkeawOyFtLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=xhoU8ZFY;
	arc=none smtp.remote-ip=95.215.58.183
Received: from mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D07A606A31A
	for <kvmarm@lists.linux.dev>; Wed, 28 Oct 2026 10:13:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5D07A606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=xhoU8ZFY
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=WsoTtYrcTmftLlSUVDE5tQ5r3ngHtWvcYWFlA1bqtiE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793182404; v=1; x=1793787204;
 b=xhoU8ZFYL7qAO+by2nhcdjjpx7w0I2wluDfLubrEI2yjfm2BabPfl7Wm8s1D3Ibzx9V3pH+t
 tpp1ONSwyy3HGhU1QgkHOCO6Rpq1MVs0lTgMS4Mp9IW5TqqwPvWFdY2TbgQRHfyuJe2h29gGXGA
 n1tMLKjzVmFPsoGZKj+ZLqcc=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 81b2b9d47a24842f;
	Wed, 28 Oct 2026 10:13:24 +0000
X-Mizu-Trace-ID: 81b2b9d47a24842f
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
	Sascha Bischoff <Sascha.Bischoff@arm.com>,
	Will Deacon <will@kernel.org>,
	Fuad Tabba <tabba@google.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] KVM: arm64: vgic-v4: Don't allocate vPEs that a VM can't use
Date: Wed, 28 Oct 2026 10:13:16 +0000
Message-ID: <20261028101318.2170928-1-fuad.tabba@linux.dev>
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

Changes since v1 [1]:
  - Gate vgic_v4_init() on vgic_supports_vpes(), split out of
    vgic_supports_direct_msis(), instead of open coding the nASSGIcap
    check. (Oliver)
  - Use vgic_is_v3() for the GICv2 check, in vgic_supports_vpes(). (Oliver)

Two fixes for vgic_its_create() allocating vPEs for a VM that never
uses them. Nothing frees them when the VM is destroyed, and each
doorbell handler stays registered with a freed vCPU.

The first is for a GICv2 VM, which KVM can run on a GICv4.0 host whose
CPU interface supports legacy operation. The second is for a GICv3 VM
whose VMM cleared nASSGIcap on a GICv4.1 host with vSGIs.

The second patch also moves the first one's GICv3 check into
vgic_supports_vpes(). I kept them separate because the first can be
backported on its own to stable kernels that predate nASSGIcap, which
is also why it open codes the check: vgic_is_v3() only exists since
7.1. The end state is what Oliver asked for.

Tested on AEM FVP, with has-gicv4.1=0 for the GICv2 case and =1 for the
other. With my reproducer (clear nASSGIcap for the second case,
initialise the vgic, create an ITS, destroy the VM), the kernel without
the fix leaves four "vcpu" doorbells in /proc/interrupts in each case,
and the fixed one doesn't leave any.

Based on Linux 7.3-rc3 (fd73f4a665989).

Cheers,
/fuad

[1] https://lore.kernel.org/all/20261026152639.3926498-1-fuad.tabba@linux.dev/

Fuad Tabba (2):
  KVM: arm64: vgic-v4: Don't allocate vPEs for a GICv2 VM
  KVM: arm64: vgic-v4: Don't allocate vPEs when userspace clears
    nASSGIcap

 arch/arm64/kvm/vgic/vgic-mmio-v3.c | 9 +++++++--
 arch/arm64/kvm/vgic/vgic-v4.c      | 2 +-
 arch/arm64/kvm/vgic/vgic.h         | 1 +
 3 files changed, 9 insertions(+), 3 deletions(-)


base-commit: fd73f4a6659897191fa0d40695fe370925dd3780
-- 
2.47.3

