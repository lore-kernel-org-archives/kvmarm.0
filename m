Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794291267;
	b=IxM5EMvPsQyhyVC6U0Yk5riNxulbNcbgf7CeOVJF34sGOkct7axyTgV/7ClwfMgnnYG2
	 7Asz7m922+TYKOGM8mF7miL0YZBewRoUVmPkLlsQvlrIzoUsMe2tG0BQIyBEnxKnphHLu
	 wKwPPZN5oU6GS2pXqc9R/i8H5Olj8fLOOwCnFOaDOnK6aMjM/32hG+ZofkkUJzvhuz1sK
	 atICW4jsC+Su6pu+uGJVhp1M3oWtlq6xv6UrVuGExjbkHs5RNuuglbjg+aRVNCKcolUjM
	 R2PuqQPhMzQ0AKYJHnjrtMEVtrCvC8rfNJomIJ+FtCn6Rz9i4XFj87a5tylhLvavR7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794291267;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:MIME-Version:Content-Type:Content-Disposition;
	bh=BjkJxNIOZYjYtRtEqr5Rr8/9mY4LqFUYFiIwbhcKsds=;
	b=DRVL29zM/9vQTAdaqRgMpkMPznwXLq9WBVm59Bx/m7/IzAPc/gE5aCJK8CEiZfOsLYMg
	 f2UnVnII1v04JwJwxcENtQ+r+/mUCRn3Kr4KSFU3WK9ZcNd4nToiyPbqOWI0hX67UhF2O
	 Fc6yTEgXEB8eCKLV4j7NrBkzHqYVW6nJdjZGHQuB83yaZ3qZQ/VefYMTE5hYBQJmcxX5R
	 DqDF6wTj2g+jf1GL1qAYILIKFSN6MifowR68SRDQAKFjTFR4Wy8aFGPtkpIxeycqYWx2B
	 DTC6/w9OPhkZ6a7bEu98Uoytfd1SNvFFqLwOwslZz95uksHkr4h6tqmvWcB0RotyfxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=cryspen.com;
	spf=pass smtp.mailfrom=gmail.com;
	arc=none smtp.remote-ip=209.85.128.41
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB62D606A321
	for <kvmarm@lists.linux.dev>; Tue, 10 Nov 2026 06:14:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CB62D606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cryspen.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4a2000d5fb1so9103485e9.1
        for <kvmarm@lists.linux.dev>; Mon, 09 Nov 2026 22:14:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794291265; x=1794896065;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BjkJxNIOZYjYtRtEqr5Rr8/9mY4LqFUYFiIwbhcKsds=;
        b=pR1G1ky8CgbJDLdM6j9pFf/4gcFqfSBf5MstxhK32NTYuK4QcIrQCw/8EhEmwizJ/E
         nmqz+g68LydFhHwSzTG0r2oQbwR/SHhUnPJ9k7YOrXNz1bWssDpcKET+BCu26p0ogp++
         e7yEXBuWhi9e9Tj+X7LH0bs61P4x56pCX3rnNqw0Bbu57vcq5LRRQbQrLfMp4UFihCzd
         rgogm2bjnv+fJfTaCzHkDqmwBG+CKXP6jTk5ZjfvMsQLFdAy6oO1FKHVCKLQJIgV+7N+
         Qv52DAAlauJ+KCcGCEwDAr0VFZy/SSd44o71uNVY4XX00w5Qw0q5xOL+7T0E0zx4K1FC
         1ixw==
X-Forwarded-Encrypted: i=1; AL+hErFGWCe0T+dM24DquS2G/iVgoMEgEFXRTWM9ExBCgUZlm4wuhDQIfNNGsaorWftepc5a8zeWNdI=@lists.linux.dev
X-Gm-Message-State: APuU4Z/1p5zECaApsROoDSRkj8iVYfZziG9UyiOLKyH/OxS9TOA70c4c
	XcYiOj/lRx4m4B2h7Yn/+clg4bfZ2KIrXuuCc0afuBAJlrK/6VsvUboU
X-Gm-Gg: AYBFou135C3MA7SGYN7XEXFHI4gl5aXbFNnaMSaIasqCZsoilw9WPcoLv1vjjD2L8Yt
	ZtIr6BG+I3uKfdLI3GSlimeeFcOGtUIBY9/KupHrpI2qb2Lg1cMbswiCeFzsyKotwLLYDHOeKvU
	i5zEbke28twtTdLPk+0TCZVZPgQaY3CVG9yckC/ui6+KoloR+wu3O1ECZySiv8mgvL5h2kYwK9O
	PbLZQNAnjhnnt58bzwiY0+L0lU018GN8NmLzKtQZ1SlMpTDKEFmAr8NeDNCZv7vI3pnKyWYg0yq
	NpXgX9htXhUmEV4huJbTkTXDUmUXLnSGzj5VI6pI5rNP3sTxM1vq4dsc556Kbe9C/84IlQqBT/H
	+RUVADEXboBv3BTKaLcTjFVeyxbRrLfy3hEjEln0peEs5omlK48FhvbKbD3IpDZJBTNPxlip/aG
	JrlLv6dUWE1olo0ASncZ8Ubel1NEjJeaxEhDPXq8pK2iAIwayNsa/1szHTr6i3hD85b/oOA4cgH
	hEU3ODYUSjWwTuKfwuv1Iipj7lwArnfuhTZSYnGlCi776IhAtKPVDmO5vs2srkvR+/ULlFdyjao
	qET5TtE8SgaYbh/eppQ4bwdUxAw4QDOvgeDjEDqUd3/ljW/RVPdNsFR8uyEZRMiWP9fTJNzgVTm
	z6ZGHr2rQI0nDQno7EbjoTRD3FZZkrTAXzFfPizZjAyoj2cePS3dJ03cn3zezd02+
X-Received: by 2002:a05:600c:3d05:b0:4a1:d459:db4b with SMTP id 5b1f17b1804b1-4ba0234d4a0mr21225695e9.24.1794291264969;
        Mon, 09 Nov 2026 22:14:24 -0800 (PST)
Received: from localhost ([2c0f:3d00:6be:8900:ce5e:9212:ea4b:f30])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49835e20f91sm3405814f8f.27.2026.11.09.22.14.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 22:14:23 -0800 (PST)
Date: Tue, 10 Nov 2026 09:14:20 +0300
From: Dan Carpenter <dan@cryspen.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>, Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, Karthik Bhargavan <karthik@pereq.eu>,
	=?iso-8859-1?Q?Cl=E9ment?= Blaudeau <clement@cryspen.com>
Subject: [PATCH] KVM: arm64: nv: Invalidate whole L1 blocks on TLBI RIPAS2E1
Message-ID: <6817d113e5f0a9cafe0ce5bc0847276b7f14aacc.1794210561.git.dan@cryspen.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The shadow stage-2 can map one of the L1's stage-2 blocks with several
smaller leaves.  This happens when the host backs the memory with
smaller pages, when the memslot is dirty logging, or when the L1 block
size falls between two host block sizes.

When the L1 invalidates part of such a block, handle_ripas2e1is() only
unmaps the requested range, so the shadow leaves for the rest of the
block stay valid.  A TLBI must remove every TLB entry for a block it
touches, including the parts outside the range.  The L1 does not need
to issue another TLBI before reusing the rest of the block, so the L2
can still reach those pages through the stale shadow entries.

Use compute_tlb_inval_range() in s2_mmu_unmap_range() to find the L1
block size, the same as the IPAS2E1 path does, and widen the range to
whole L1 blocks.  The other caller, handle_vmalls12e1is(), unmaps the
whole IPA space, so the widening does not change anything there.

This only affects nested virtualization: the host must be booted with
kvm-arm.mode=nested and the VM must be given a virtual EL2.  In such a
VM it breaks the isolation that the L1 hypervisor provides.  An L2 can
keep reading and writing pages that the L1 has taken back and reused,
either for itself or for another L2.  The host, other VMs and VMs
without nested virtualization are not affected, because the shadow
stage-2 only maps the L1 VM's own memory.

Fixes: 5d476ca57d7d ("KVM: arm64: nv: Add handling of range-based TLBI operations")
Cc: stable@vger.kernel.org
Signed-off-by: Dan Carpenter <dan@cryspen.com>
---
This is part of our formal analysis work at Pereq.  I'm not super
familiar with this code.  Claude wrote a self test that I used to
test, but it's crap and not worth preserving.

I also considered widening the range in handle_ripas2e1is().  We would
need to use the largest block size in that scenario and it seemed like
it might hurt performance.

 arch/arm64/kvm/sys_regs.c | 13 ++++++++++++++--
 1 file changed, 12 insertions(+), 1 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 3d3f4eb82fbd..e1a687dfeea7 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -4116,6 +4116,17 @@ union tlbi_info {
 static void s2_mmu_unmap_range(struct kvm_s2_mmu *mmu,
 			       const union tlbi_info *info)
 {
+	u64 start = info->range.start;
+	u64 end = start + info->range.size;
+
+	/*
+	 * An L1 stage-2 block may be held in the shadow S2 as several smaller
+	 * leaves, and R_TVTYQ requires the TLBI to invalidate all of them, so
+	 * widen each end of the range to the L1 block containing it.
+	 */
+	start = ALIGN_DOWN(start, compute_tlb_inval_range(mmu, start >> 12));
+	end = ALIGN(end, compute_tlb_inval_range(mmu, (end - 1) >> 12));
+
 	/*
 	 * The unmap operation is allowed to drop the MMU lock and block, which
 	 * means that @mmu could be used for a different context than the one
@@ -4139,7 +4150,7 @@ static void s2_mmu_unmap_range(struct kvm_s2_mmu *mmu,
 	 * the L1 needs to put its stage-2 in a consistent state before doing
 	 * the TLBI.
 	 */
-	kvm_stage2_unmap_range(mmu, info->range.start, info->range.size, true);
+	kvm_stage2_unmap_range(mmu, start, end - start, true);
 }
 
 static bool handle_vmalls12e1is(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
-- 
2.53.0

