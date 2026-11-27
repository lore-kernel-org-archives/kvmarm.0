Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795793516;
	b=DU5ChHMC3IJEZArKhWJyvZlOb9Fnot3c/nh/iNG930U3vieQlkuqWW2bw2vKEt4G92sV
	 VvmWbGAuUB0DMFlksPJPE3hcdR5DQyrTjYQl101ByoT+phkFG3Vu5O9BfmAKV0aOqZVcJ
	 7ROlZ7Dmq7QvvdBSDyR80o6WRNcl2yEj/J8071/sssKTB2ssqkPMF+diFqonHCrjlxXwk
	 t9EabjZWmawPLlwFc0yFUfSXc318ZwwNwo22cIYvIYjb3EMyyq+EyK013BoMoeLbhWXvH
	 Y1dc5Jud+ITvwEvOk8/XElZTJ3eBdECT0ga0DXwyHfY+Pl0jhpE2RrEEJZ5oMloRxyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795793516;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer;
	bh=eJH1nUsnbixxIHEWvpIRBGng9yzgxFYLz8dPDZYEZSU=;
	b=Y5Wfaq3ELAGRAGwZ5A+41wgmQJrySwW8w/8fDxUQi1G2Zk/aVfXtdeVtI7NV6taOTp6t
	 D8wzyEFB966bOfMsctEYBoU+zaMQGD/m2++akF/yr1Kh+AGDSIrG/b7r+74ZMvK4Pp03Z
	 /OdopoU4Xpx3XVfuM27dYgSrBvgbKCFs4yNVlSZOX2CcZWpLVwqQ7SrzX4+yTW/1NADTR
	 i5G8IOf6AaUAUSzWTv/WRxcgFnhWyQ3Zs6XgDttcSXQZU9OPz1QEQTkurWSxM2VS39phg
	 Ngv0wifEerZFTZQSvS59VSF8sU4eyONN50Pc+MYtz9xBnbEU72+crcIlCWGuOHA9ItQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=pereq.eu;
	spf=pass smtp.mailfrom=cryspen.com;
	dkim=pass header.d=pereq.eu header.i=@pereq.eu header.a=rsa-sha256 header.s=google header.b=MBwikhgq;
	arc=none smtp.remote-ip=209.85.221.51
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2237606A321
	for <kvmarm@lists.linux.dev>; Fri, 27 Nov 2026 15:31:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E2237606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pereq.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cryspen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pereq.eu header.i=@pereq.eu header.a=rsa-sha256 header.s=google header.b=MBwikhgq
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-48e3b22e971so4353013f8f.0
        for <kvmarm@lists.linux.dev>; Fri, 27 Nov 2026 07:31:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pereq.eu; s=google; t=1795793514; x=1796398314; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=eJH1nUsnbixxIHEWvpIRBGng9yzgxFYLz8dPDZYEZSU=;
        b=MBwikhgqDyZx6OCLyUWdB+fq6bfO24kNjOsFrYy4Ml5O7mi/yZuniPgrbz8/kZ7JCr
         AGhBKPHw/r3PqvpsifiLugh1l+XLqwG/xJPYEzsWNRYmKdPTya/ydItxZBWRZmpXU6lk
         vkSvvrDm7Axs6hdqqGS6z5GLQAWZxPEqL3vicXnYq9utqfyDC1RqGOEnornLMbtYeTGH
         2Fo7+OSENr3TYtPSEyAPB5HzRAINq62QHZS/LCUh4VXbt1UVjZrqwHoOtst9EWxg+y9a
         a/fqODsA7w7L1u0m5959KbCmIx+d7eUG0Rq1VcmUEwPvKZnnVcLxIdHgwl8fdDsiTdIn
         3AEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795793514; x=1796398314;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eJH1nUsnbixxIHEWvpIRBGng9yzgxFYLz8dPDZYEZSU=;
        b=agJtC35iFfMdPeopZgWsig2VjYKItbh56TpS67JMCnrCu8jsvvKm+zmj9WwzKS757W
         r732q0Xgp93N0KNgpx3GrOudPndLyUQnsZd0mPEi9uxCV5xbIJHr4g5h7WlC+lPSiZY+
         Qxg1FiROfTAyxxgCbiFADRa5K1uJjr+dhvO6LgFd0DxRaRCEldfXYH/NXm0U96VWKHao
         gAZPbHkZTDKd+X5qGWqNrMTi6K+m5Gv91Lql+pIBZpOD8s8ae8KHzmozjIy/1vizQkax
         W8PukOQud5PVs2rHMVB+DBYveBo+0J7+syX8ICu59DClQddhtIHjdMMSqTTOvWN4Iy42
         mTWg==
X-Forwarded-Encrypted: i=1; AL+hErGqsxI6DSfz5Lsm5UQ8f4+o9cfumIGcwoD2TqbNg/Q7plO/91ZXAJiyihywEwI0yQfLE+O+e9c=@lists.linux.dev
X-Gm-Message-State: APuU4Z8TYBtDvBqcF2CYTGB2QeRM9EdxAvyF4EIoDbFOcKiSgNvkZBX5
	aNzzU8spNZfa6BBU9VjX8zZyIc44PMnxD5pVNQPc2fW8q3ENF4by5OAxTe/rFLVktqQ=
X-Gm-Gg: AZFdTZdUyzK4edp61RqEfeQ3SPgyS1+BGNSQA1421PQT6bemdb5FtsJFfeqtzQUBMUt
	s/tsKI4BeX1hLDFN0Cd07Tqh4oogWASJB1L1DPAKadvSYz1wJW34lkAxUol475uGo/Q6SiknmV3
	YopsW/xFNO04S1d5T5KpOYo461u1/H/FrR+V4kZSGDGPlHohUCQZ8ebBxSoE+kH+p+LK3mXDF1v
	splx4L/BNf/hZUaSbYTMuXQuJ9a5/gTFekpIimVJEZ6OD+jSRvggnIcRxYWBDnTM9dVN6hUd7Dx
	QmDVVSfX/JBRQu7YC0tNW3TraiFyJ2fM3ztdRLs8YOWiOF3t5rnwe9qCHs4eN0V8b79s/6sd2ut
	Aivz4zLog9YTVUq8VKpcRjepRvy+vKRgK5/B6ZyFYOwfAANb0arPHdVcx6bvjq/nuzKsCQ/PCCr
	oufeQ3daEoa9446SKvQFOBaLy9KiNsSQ6YJTJtYuQUO2YTbTUmbhaeCqlOrsBMlnTjOVPCUqdYC
	ts/HbGKC0p9NGVtKNjrjE3QOkyBt3JIebJws7tF558Na1t2Xdf7dEsdfzQbDDORmtoipdgyoAvO
	vlpnnqk5vN0ntJh4D8L90Y+y1qJjKJ9A9/RS4ArW
X-Received: by 2002:a05:6000:25ca:b0:4ac:7595:6f67 with SMTP id ffacd0b85a97d-4ac7595721cmr44357884f8f.40.1795793514001;
        Fri, 27 Nov 2026 07:31:54 -0800 (PST)
Received: from localhost ([2c0f:3d00:6be:8900:ce5e:9212:ea4b:f30])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab658e2d55sm47510901f8f.5.2026.11.27.07.31.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2026 07:31:53 -0800 (PST)
From: Dan Carpenter <dan@pereq.eu>
Date: Fri, 27 Nov 2026 18:31:40 +0300
Subject: [PATCH 3/3] KVM: arm64: nv: Update the shadow MMU's VMID for AT
 emulation
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261127-nv-tcr2-v3-v1-3-9c15c1cabe01@pereq.eu>
References: <20261127-nv-tcr2-v3-v1-0-9c15c1cabe01@pereq.eu>
In-Reply-To: <20261127-nv-tcr2-v3-v1-0-9c15c1cabe01@pereq.eu>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
 Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
 Steffen Eiden <seiden@linux.ibm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Mark Rutland <mark.rutland@arm.com>
Cc: Karthik Bhargavan <karthik@pereq.eu>, 
 =?utf-8?q?Cl=C3=A9ment_Blaudeau?= <clement@cryspen.com>, 
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 Dan Carpenter <dan@pereq.eu>, stable@vger.kernel.org
X-Mailer: b4 0.16.0

There is a missing kvm_arm_vmid_update() before the __load_stage2()
in __kvm_at_s1e01_fast().  The bug affects nested virtualization on
arm64.

In KVM a "stage 2" refers to the VM's page table mappings. The
__kvm_at_s1e01_fast() function emulates the AT instruction, which
translates a virtual address the way the MMU would and returns the
result.

Each stage 2 has a VMID, which the hardware uses to tag TLB and
walk-cache entries, so that one VM never uses another's entries.  There
are only 2^8 or 2^16 VMIDs, which is quite limited, so vmid.c hands
them out by generation.  When they run out, a rollover starts a new
generation and flushes the TLBs: the VMIDs active on a CPU at that
moment are kept, and every other VMID can be given to another VM.

The kvm_arm_vmid_update() function checks the VMID's generation, takes
a new VMID if it is from an old generation, and marks it as active on
this CPU.  Without this, the shadow MMU's VMID could be an old one that
now belongs to another VM, or a rollover on another CPU could hand it
to another VM while we are using it.  Either way the AT fills TLB entries
tagged with another VM's VMID.

To fix this, call kvm_arm_vmid_update() to update the VMID before loading
the shadow stage 2.  That marks it as active on the CPU.  Then at the end
of the function, undo that.  Restore the original VMID as active while
checking for and handling rollover.

Fixes: 477e89cabb14 ("KVM: arm64: nv: Add basic emulation of AT S1E{0,1}{R,W}")
Cc: stable@vger.kernel.org
Signed-off-by: Dan Carpenter <dan@pereq.eu>
---
v2: Unchanged
v3: Unchanged
---
 arch/arm64/kvm/at.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index 893bf88f2f75..4a1767704d22 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -1476,6 +1476,7 @@ static u64 __kvm_at_s1e01_fast(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
 		}
 	}
 	write_sysreg_el1(vcpu_read_sys_reg(vcpu, SCTLR_EL1),	SYS_SCTLR);
+	kvm_arm_vmid_update(&mmu->vmid);
 	__load_stage2(mmu);
 
 skip_mmu_switch:
@@ -1530,8 +1531,11 @@ static u64 __kvm_at_s1e01_fast(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
 
 	write_sysreg_hcr(HCR_HOST_VHE_FLAGS);
 
-	if (mmu_cs)
+	if (mmu_cs) {
+		kvm_arm_vmid_update(&vcpu->arch.hw_mmu->vmid);
+		config.vttbr = kvm_get_vttbr(vcpu->arch.hw_mmu);
 		__mmu_config_restore(&config);
+	}
 
 	return par;
 }

-- 
2.53.0

