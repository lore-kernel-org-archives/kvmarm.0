Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AA7528E24
	for <kvmarm@lists.linux.dev>; Tue, 19 Sep 2023 17:50:30 +0000 (UTC)
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-59eea906b40so569877b3.0
        for <kvmarm@lists.linux.dev>; Tue, 19 Sep 2023 10:50:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695145829; x=1695750629; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+FfNGTxjW46m0vYg5JQZcFmeN0Q+crU/shufIChYdkI=;
        b=2ebwpeATTgHxmwZ/I4CxxVX0i/I9g0Anj+07y6wRJLH+2oTFZ3npBNvJXPt8bfzXoh
         Jhg6g17dNLya/gCGhcDEXC2OE/zTjnC5frFHf1ceGje9TdiWBnvZB7G8H4FgsLYApAuy
         gT5OqcSppOG5pnuzWEt5RpQErT/sSF14yy7xc1MpSLpTuvgyawFf0zzxZ1H5oEGG0GYR
         lz21z2TO16Ol41zVdaUHOXakygewgP+/9zuEndJTsJVdgGELpIts7tTsY5f0Qur7u3yB
         Sn3TanFbFtIc4p2FR71gpgJte7SVUkNgJYS8lU378Zgh+Q6t1JV7wSA51gKejaYSGi8y
         9Sfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695145829; x=1695750629;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+FfNGTxjW46m0vYg5JQZcFmeN0Q+crU/shufIChYdkI=;
        b=qW6LUbLaWdbR/f5DONpn72uObiftrGzzg7SQfMfRulyAXItQYAz6zeimGrwapnkoGE
         P7pEAiEG+Zh7rPI9ADWKS0+ThuPBUpQf4EyAgpsdcJn0m34sVTZMqi+Mqod5WPsNOtHh
         UScKEYaDlCtTeqXRI2MpDyhkWqvqbpD1YrSOCs1+spMmlbr2LEwOBqtDeT33daW/BMt2
         s78td27B6+u41nav8W1kiP2vzflzeSKjOogbuw01D0c2963OjuFHsbyaAz0LspTu84Va
         7LW0UikTX4IvapddP/BuAfyB4BP9x+Mg9+BDLqTy6rMixokRMnbseb5KqhLqn8zGGg0A
         NI6w==
X-Gm-Message-State: AOJu0Yy9BZMw9CUdhtMBbsD5H2iFmqZ7jNQbbvBxeRMXzdmIz3R91Tj7
	hudojEzeBpIWnlCuH7NYKqDJCmXOjuTZ036Uzw==
X-Google-Smtp-Source: AGHT+IHzfDyzqT0qS3LWIHvfZz7RLjnCjuKsmPhD/Jh5rsxGnZ1+liEskGzE0UZSm4JarDPcCE5W4ld3r7CjK2ykmA==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a25:db07:0:b0:d81:78ec:c403 with SMTP
 id g7-20020a25db07000000b00d8178ecc403mr5069ybf.12.1695145829452; Tue, 19 Sep
 2023 10:50:29 -0700 (PDT)
Date: Tue, 19 Sep 2023 10:50:15 -0700
In-Reply-To: <20230919175017.538312-1-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230919175017.538312-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.42.0.459.ge4e396fd5e-goog
Message-ID: <20230919175017.538312-4-jingzhangos@google.com>
Subject: [PATCH v1 3/4] KVM: arm64: Use guest ID register values for the sake
 of emulation
From: Jing Zhang <jingzhangos@google.com>
To: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	ARMLinux <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>
Cc: Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Fuad Tabba <tabba@google.com>, 
	Suraj Jitindar Singh <surajjs@amazon.com>, Cornelia Huck <cohuck@redhat.com>, 
	Shaoqin Huang <shahuang@redhat.com>, Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"

Since KVM now supports per-VM ID registers, use per-VM ID register
values for the sake of emulation for DBGDIDR and LORegion.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/kvm/sys_regs.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index cdb9976d8091..4dcc9272fbb8 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -379,7 +379,7 @@ static bool trap_loregion(struct kvm_vcpu *vcpu,
 			  struct sys_reg_params *p,
 			  const struct sys_reg_desc *r)
 {
-	u64 val = read_sanitised_ftr_reg(SYS_ID_AA64MMFR1_EL1);
+	u64 val = IDREG(vcpu->kvm, SYS_ID_AA64MMFR1_EL1);
 	u32 sr = reg_to_encoding(r);
 
 	if (!(val & (0xfUL << ID_AA64MMFR1_EL1_LO_SHIFT))) {
@@ -2445,8 +2445,8 @@ static bool trap_dbgdidr(struct kvm_vcpu *vcpu,
 	if (p->is_write) {
 		return ignore_write(vcpu, p);
 	} else {
-		u64 dfr = read_sanitised_ftr_reg(SYS_ID_AA64DFR0_EL1);
-		u64 pfr = read_sanitised_ftr_reg(SYS_ID_AA64PFR0_EL1);
+		u64 dfr = IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1);
+		u64 pfr = IDREG(vcpu->kvm, SYS_ID_AA64PFR0_EL1);
 		u32 el3 = !!cpuid_feature_extract_unsigned_field(pfr, ID_AA64PFR0_EL1_EL3_SHIFT);
 
 		p->regval = ((((dfr >> ID_AA64DFR0_EL1_WRPs_SHIFT) & 0xf) << 28) |
-- 
2.42.0.459.ge4e396fd5e-goog

