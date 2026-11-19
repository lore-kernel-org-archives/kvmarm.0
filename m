Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795094773;
	b=R3eiwgJ7mDAGGCWwiJEYIGw/g1INSAMbuESxMyePfuYkEDlE7HV8agDYZc0sdBLLZ2xj
	 zLqsLH6+fOefy7Ku/RM/JStvxmUQ77T+go9hkt74n6wB1SdNCfnT403m7VRmF0UnyzjB1
	 EzTL/RijXJd3KD+X4QscOybFae2SFv4elnZp+ivAb41MvkAS5MePt6WWV15K7bwcY/hJF
	 4uIqMM2pdcxKord5oyDFGNKsgzwDxaDcSI+/BygpVh7hiPRbKXykxkkWGFcwp8CFxEgM/
	 uWmuwPM7fWsotx1hqHxFFMiBhA8JVyUWDI/h0jCf0eZApluyMK4ZCsr9LD0R1/uyMBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795094773;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer;
	bh=+KzwTxyJe1Er1zgZJn5wO+VPIKKM9MReJr20XBLcIEA=;
	b=UupIj1Ccge6SYaZBKkcb2o4KLTTUUmUwUcNAEO5SfVJnxw96Xq/ZYqV91mCl6dOCeOWd
	 0AgyTOw8jqJQYXHGH0X51hdT3czgHY3Hi/PD2NfgAfsp0gbnjZaoToVMF7E658D6KIyDT
	 4Jbj3nnxkPnefzB2D2osfDAANEQNkhqt88NeemV5aojb+12H5HQAttSsS4h9zK14bogIW
	 UwmX5Ojidlf8zaxMyrTHvK+HHZAQ5qXKBSF4TeS21LcxweLAffWJJVFmiHJLGCnYuIjQg
	 T8QFrkCUgiatFtWVuxG1d2f/RL3JOOOV/SAq9gfoAJlyKa6GNaoYpq+Txgzui4Fg2oQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=pereq.eu;
	spf=pass smtp.mailfrom=cryspen.com;
	dkim=pass header.d=pereq.eu header.i=@pereq.eu header.a=rsa-sha256 header.s=google header.b=Avq+aj7E;
	arc=none smtp.remote-ip=209.85.221.47
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D19FB606A325
	for <kvmarm@lists.linux.dev>; Thu, 19 Nov 2026 13:26:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D19FB606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pereq.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cryspen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pereq.eu header.i=@pereq.eu header.a=rsa-sha256 header.s=google header.b=Avq+aj7E
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-4a68190a2a7so1974985f8f.1
        for <kvmarm@lists.linux.dev>; Thu, 19 Nov 2026 05:26:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pereq.eu; s=google; t=1795094771; x=1795699571; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+KzwTxyJe1Er1zgZJn5wO+VPIKKM9MReJr20XBLcIEA=;
        b=Avq+aj7EwfYJlX7Y19cT6UnOxWLTmPLV5N7J/alnDuKXnR41BtHXCQdVwnyTvK3sGj
         HwwwKUKnM9l6rbyhKbB8BstWCvfO3lw0uFrFTc5K+HzE23SdtfANrmSP7qe81RPkqU4S
         PQMuUA8PTDhF2csKV2E4JGzHuYlm8Tjj45Ga6P+DdztQdToOcTDlL/IHvAb4f5X2M828
         mBR27C8DCDlVHyzRTqT5ob9u9e6iaxLzAMAb1ngeMDYWPYc7IOCGx+leW7JbkvBMif3C
         BX3GnoMBEpNOHJBuayXEclGhMTr2aujXs35ABKLW1Nsdkg88xsTvqP8o6Ay2Uep/ZZcO
         9huA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795094771; x=1795699571;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+KzwTxyJe1Er1zgZJn5wO+VPIKKM9MReJr20XBLcIEA=;
        b=ZBL7V0fdEMiHFq/SlF5ckzjGsbE+0z3vi69uMS6VW/T87WlFx+wlEee3YI9jXkTTxR
         TtLNGNi7BGO/HAo06RK7PbOGxwAm/RLPqs+fWQoIXZ9YbUJIEGhx9OAhlOpYLOmt0FVM
         YZ7qJWBjBYbSAvq/JUiw1oSzVaOi4DEW9v3ISREPQuMNY6De70r1AqWKj9lKQIfyPda5
         JsdxhJWGXEMccfr5jiyDUuCEFZryrbWUeWbczzxF2RGgLVcyW4H1GK+QxA7EcS5PBHfm
         waavClMOXpmShZzEFDQ//iDl5YLwiPyK34UVwNJpn1SYffNCWcQh+jMzdTJfHmR2LH3n
         vS5A==
X-Forwarded-Encrypted: i=1; AL+hErEi5wFWKMWmNsKzrm6+PmVdgb70J67mpIiUZQltln14XDAVh3C42wKeL4VjmSqGsReds64sjD4=@lists.linux.dev
X-Gm-Message-State: APuU4Z/c+fmDagJnNbA+iePBSUA73vLaW/GbyuMpk00MzdmHSeNiey7M
	TQfvbMDxdS9pDl3ocGr1W67MvhwU/aNHShtBS7YoSh2tV0h/QbGlnamzUKkKSihRK7w=
X-Gm-Gg: AZFdTZfFxtYkZ8x+jPUw2q9+ZUVcIeCQJG0GylWKPgN4CHZT5tCVTvBACAJzEgBt5HP
	F9NbIqI3ham3zCay4qUx78RnzsWZt3HyJz2uUTcHtspPvlcCHsdwMjyjn/z32cLcn4Nvim3NlYv
	FYcwfMj80hyTRQSCmdoKRMQXemqOHsX41HpFZ91eldOr0CAUCrI3v0PVM18B3Pl4MCyw7taqHL8
	ZkKyQCyC0xkj2Sbe8HXOsIoUzQJbIioZMwsTRaQB4dQKp8HF7HhCjH4riw5UkhxI/rQ38kygO9Q
	zmzJF3gtEZdPb8KuttbFvpYsZhgWZQWloQAvTaQbq1IwB5iHzRpU+TfVZP7jvuG6tHAO3aeoQoW
	3rRBFZKEO60dZr/PJpH++jXg8uewj7Pwx20Ukn0wlG6L3mbkpmOjScukbMFQoB0K+VbJk0bhdkz
	WndlUjaF8R/x1ZUy5Ez0k3MXhzy5c4nyXCubsqery4R09LK5sLutsAUN+X+D+bkaxROOsG4bZkM
	wrWL0bPCHCL2TmnHMj6yQsJXi3qEto6F86vcgGaZQDE9mvbY++gbbxCLCHaFJZ4dLWz5WACMZWe
	qwAKv6kFj/EI6gza8J0=
X-Received: by 2002:a05:6000:4555:b0:4a4:7328:21f1 with SMTP id ffacd0b85a97d-4a63ac6be9fmr8858836f8f.24.1795094771068;
        Thu, 19 Nov 2026 05:26:11 -0800 (PST)
Received: from localhost ([2c0f:3d00:6be:8900:ce5e:9212:ea4b:f30])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4a6573bccb0sm10584515f8f.55.2026.11.19.05.26.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2026 05:26:10 -0800 (PST)
From: Dan Carpenter <dan@pereq.eu>
Date: Thu, 19 Nov 2026 16:25:37 +0300
Subject: [PATCH v2 4/4] KVM: arm64: nv: Update the shadow MMU's VMID for AT
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
Message-Id: <20261119-nv-tcr2-v2-4-3deb1a6cdba8@pereq.eu>
References: <20261119-nv-tcr2-v2-0-3deb1a6cdba8@pereq.eu>
In-Reply-To: <20261119-nv-tcr2-v2-0-3deb1a6cdba8@pereq.eu>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
 Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
 Steffen Eiden <seiden@linux.ibm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Mark Rutland <mark.rutland@arm.com>, Jintack Lim <jintack.lim@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 Dan Carpenter <dan@pereq.eu>, Karthik Bhargavan <karthik@pereq.eu>, 
 =?utf-8?q?Cl=C3=A9ment_Blaudeau?= <clement@cryspen.com>, 
 stable@vger.kernel.org
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
---
 arch/arm64/kvm/at.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index 9dfabd0586e2..5924cfa01bd4 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -1476,6 +1476,7 @@ static u64 __kvm_at_s1e01_fast(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
 		}
 	}
 	write_sysreg_el1(vcpu_read_sys_reg(vcpu, SCTLR_EL1),	SYS_SCTLR);
+	kvm_arm_vmid_update(&mmu->vmid);
 	__load_stage2(mmu);
 
 skip_mmu_switch:
@@ -1523,8 +1524,11 @@ static u64 __kvm_at_s1e01_fast(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
 
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

