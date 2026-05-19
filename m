Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 316DB2745E
	for <kvmarm@lists.linux.dev>; Tue, 19 May 2026 13:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779198661; cv=none; b=ZgT+nGwUVVDP+lVdnflpeKabPZjFz2mUjdsVj5Kg5dv1e+5uVPgOgzkbWQG8CgWA+z1UDrOtsgbWyosqoZC0XWEfNcToslkCCdP/CbE0IgPtKS0cJyYStIElguDObSfQkGC6t/nmvZa5i4dwbtfbdjyeC91O/7DFGNO7gM3K0ro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779198661; c=relaxed/simple;
	bh=bG/QhvrDzqOyTT25ScqRVuCKWen5BPNvWMdOdivWRMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FCIAeLmgfRg1HOI2xdVghT/5fMUHCTvwfimkBftjnydb3wmZFMPI2PwbMLtFBNg48bGetnorenYe8uFh7XHK96R2J7h+nDEVHNgaR8dXCz9nMp/fl0rzXSOEqKsmqXmsH81NRCV7NVo+sEB0lcC4GynBziem0C3xsq+2hYdsp/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gmNswVxz; arc=none smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gmNswVxz"
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-51306c36c3eso43207311cf.0
        for <kvmarm@lists.linux.dev>; Tue, 19 May 2026 06:50:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779198658; x=1779803458; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yUcArKvUj1jkcs2OK6MvhEPcHSKMY4c3Dv90/tfztKo=;
        b=gmNswVxzukslnf5Zto9uBVvVfKp025dOLuw35WCkWGPhe5xfiRx5cfCyuYPMginaRT
         FlGmgnV0taeojS/tOMxteI/RoMDn3UEGac8JgjXsmeto0DvmFxBu25C+6yESIFv2+F8X
         oBUt/8GD+PWHbj1JrTmBF44QFf/tJuVGMsAYlc0a5HeIEUuFflfVTuNrfz/EYctPOLaU
         J0xPEuSRUUm1Vef/lvPe3O0F1saPcbxdUavpsYuB5FMFyVb2p9PdvcjIFMFUJA3CMuYr
         kk1o9DkwAd6o9VyGUyD5SwmYNSJRmoLuZkb1ao8+g5yMAHFUZtKw1ceihgjHX5psnYqp
         5agA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779198658; x=1779803458;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yUcArKvUj1jkcs2OK6MvhEPcHSKMY4c3Dv90/tfztKo=;
        b=HU97x/1UldmjsAsY1ne5MQuAmEGwrqLyYaRhbz39tsCZ8gazNaFl/wKMuQMn+odGs4
         WtpMKaTcijyD4XSE6zGrhNv9S7+ZeJgwTaaMzvgG0+xnjefuIdq1mPX85vOvGTml7/Gh
         qdY0M0dYR3dKB0QyL5nJS2ZHTkCWEmkiLIyMDmtgmLdVNFzxTCAXDfkHzLZWo/bDUL+h
         H3zyknQFLRs1SoqQ0teLtNAQxLoQvYTk5/jYOEQ3pb5yheMYns5ey/3Y2adavPiM0fnQ
         r5krY+gI/ts8hV3QPV2TDK4OEOu65CSas7HF8V32gr7iNCVDlhwGFW+E9tTp25q/1To1
         qJgA==
X-Forwarded-Encrypted: i=1; AFNElJ8s5FMGRoblmWqbx+c1NDjG0btjWLhvtNpMqkGs1mgfkydl8GE1Hb4+QjPIWv78/TnpENzV9FY=@lists.linux.dev
X-Gm-Message-State: AOJu0YxXGjkiAJDyF+WQMhw6HIrpcBtanrlIxHoE5ktqPaZWn6fUZOLU
	AJd4JLIwI0d1UdagHUy4FHIqRHVGjnKrSi4aEfuDu99FI63SPlFt7EeW
X-Gm-Gg: Acq92OGY+0VVF+omesMWotVwwWE/Yi7dlaz67dylLGQpvUixqI6B+Rwrz4TmRjXKEwx
	8OgdtM1jL99HIT2T+yAsaVXuSaFJ6DBpHZOuC3Lj917YxuVMgcYGHyS7cMz5fAukML8j4LaQtRL
	NQ5K6731YDn/XnK+xDOJClUlJrUPUR7An0DoUaP3eWLNGJ8cRkWeD9ewT/R1ta5NPmQr2p53inC
	T1W8turR97amNAbVPcCJo5GbBOszjO5rfE4Go1yD/df8mBaNn7GbWWnHWG/hOjouTH9z1irS0bW
	nZlvRR/lZ28QL4laM0b9kUtxvJvJkmZBJyixvPNgmYCtD2G5iBuGj908WC5ygSPvSHKNciWja0n
	h7CrF/LQCjCJf1eYe/h91vF2lvaKe7EGOCUWiZbdAL6kEq2lT7RtSjtsRRzcxwYqMyUmy8yYk8F
	1Sb1WcI2uRcZb/uTmQn+QlCjuiYJ5Vm9Fa4EQd3uaHqxlcNsKePC2zp8zpVju0sroISWNoxBHS9
	pOYBEP+b3QzFZoD+jaa
X-Received: by 2002:a05:622a:5e16:b0:50b:445a:4139 with SMTP id d75a77b69052e-5165a30cb12mr283906821cf.54.1779198658020;
        Tue, 19 May 2026 06:50:58 -0700 (PDT)
Received: from server0 (c-68-48-65-54.hsd1.mi.comcast.net. [68.48.65.54])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-516457da48dsm162585401cf.17.2026.05.19.06.50.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 May 2026 06:50:57 -0700 (PDT)
From: Michael Bommarito <michael.bommarito@gmail.com>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: Yao Yuan <yaoyuan@linux.alibaba.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v2] KVM: arm64: vgic: free private_irqs when init fails after allocation
Date: Tue, 19 May 2026 09:50:42 -0400
Message-ID: <20260519135042.2219239-1-michael.bommarito@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260517181331.367676-1-michael.bommarito@gmail.com>
References: <20260517181331.367676-1-michael.bommarito@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

Companion to commit 250f25367b58 ("KVM: arm64: Tear down vGIC on
failed vCPU creation"), which added the missing kvm_vgic_vcpu_destroy()
call to the kvm_share_hyp() failure path in kvm_arch_vcpu_create(). The
kvm_vgic_vcpu_init() failure path immediately above it has the same
shape and still needs the same cleanup.

Call kvm_vgic_vcpu_destroy() when kvm_vgic_vcpu_init() fails so private
IRQs allocated before a redistributor iodev registration failure are
released before the failed vCPU is freed.

Fixes: 03b3d00a70b5 ("KVM: arm64: vgic: Allocate private interrupts on demand")
Cc: stable@vger.kernel.org
Cc: Will Deacon <will@kernel.org>
Reviewed-by: Yuan Yao <yaoyuan@linux.alibaba.com>
Assisted-by: Claude:claude-opus-4-7
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
---
Changes in v2:
- Add the Fixes tag Marc agreed with.
- Add Yao's Reviewed-by tag.
- Trim the commit message.

 arch/arm64/kvm/arm.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 176cbe8baad30..5d5e2f81b9c94 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -554,8 +554,10 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	kvm_destroy_mpidr_data(vcpu->kvm);
 
 	err = kvm_vgic_vcpu_init(vcpu);
-	if (err)
+	if (err) {
+		kvm_vgic_vcpu_destroy(vcpu);
 		return err;
+	}
 
 	err = kvm_share_hyp(vcpu, vcpu + 1);
 	if (err)
-- 
2.53.0
