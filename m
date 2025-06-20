Received: from mail-il1-f201.google.com (mail-il1-f201.google.com [209.85.166.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7F63241105
	for <kvmarm@lists.linux.dev>; Fri, 20 Jun 2025 22:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750457922; cv=none; b=OJNJQMU1N1boTvGLLF48fGHULliLKW6syGjmAJmt1UsDAPlsaNqnqBii2giNBs8nLzrBrWESA0Qkk79qhyhw+NEwc29CitBCnKV+iNoB21OZpb37sxHtBhPIjH+w4yNXsx5UX0DyirUwgmAdkW50YtTB0XoYWwn4OyiGvzad0R8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750457922; c=relaxed/simple;
	bh=hEI+Ws5Ed4T0XYMyDeyGmT0ZhHqtHUDKeUxZmkH++E0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=AY/YFlDzIqOBhd+l/DYG9wVLJ/ANCL3IOLCbIvZxOmPyuz07UQxrYeOfljvjhWNRHSfJzpXta5P99UfvGA+4y+feT8MpE3CifPAKOZggeUwiyOVOF057cLHIVgE2rd71p1+Xmwe2eh2glbUXcoFgmnum15+BhS0fWdK8N4iEdEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=h8fz16Te; arc=none smtp.client-ip=209.85.166.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="h8fz16Te"
Received: by mail-il1-f201.google.com with SMTP id e9e14a558f8ab-3ddc1af1e5bso53318615ab.0
        for <kvmarm@lists.linux.dev>; Fri, 20 Jun 2025 15:18:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750457919; x=1751062719; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tzpL3Ld7f3Wg7N4Mr5qllGNQ06XKr05fHXYYgZEl88s=;
        b=h8fz16Te3eyVCuOFt8Rjqt7zdSjouLULGyNJMX/CPRkGxxvb61xGOE2mTT7YzOsknM
         sAzfKPhvjcnVfrHN9hUJn74rrvoXV8MpS0Pk7jgDvfAw4g8yzWblyd2OrpX2npHtU1Ms
         gYRW1/a7qIFCAh8/35c7Ahm+wgeQnrHWVcecuBKDk6bOrNsw2uiahXPv6TH8Xu3t4USO
         r1/nm/8CaSObxwpYv7o5UYQi0m3FPkLICXcvJFIAhOTTJVDKhxFRN45y+9WOaZbxlHSt
         dcNnxxVlAw8atmVzEGyxmMGiG0n6XuHOdsQ+BA0RUXKtQ1eYUPRsbA5CgPFFXSziNpD8
         oxYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750457919; x=1751062719;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tzpL3Ld7f3Wg7N4Mr5qllGNQ06XKr05fHXYYgZEl88s=;
        b=Nw8/s/9S+3LvOEaVn3OOuuIdrcaFEUyWkHTZspF4TGfgNuivXcjGTr+ZXi0rBRqgnQ
         104RgbsUpL9zu8A/Kyampj1W70Xu8FfKYluDy41VtljMQD+D+15lPTl+nAHWVmLOz+/q
         OA4zQSIxges8taz2kUZ020fSN/fmbAgeKG8/u0hf/FY0U1kxuEdiQzLPcL97O5KK0bKp
         n+gFypgv33o1eLRDLB3i87D291GpknDyR105PEURSq9u3Y0aMXKdEwgvhk93koK8yg+c
         lvL2eJXAP5Al6jdszZZroua5mjDDgDL1P6kApv7rVE4DjbpoY/H9J5S47DT1NfIaOnsB
         gb3Q==
X-Forwarded-Encrypted: i=1; AJvYcCU0hAfYdrqbqcAWcM8lF93unOHm8Ow5R3wu0vuhmm4AMAzBQ1Q60JQWCwtBXD/SDj2jNh5045M=@lists.linux.dev
X-Gm-Message-State: AOJu0YxDfynHSFyjMYNJob1PutZhYba41jEpuOoPM7sstW6iFFN8msH4
	P1hW79oZ9wUwjFEPuNQwlitOPU+Q0dPgYWgMC29NIi6q3+W6OGy/QMWh+aEtsdq8/KH9GAGCdAo
	vQ0KwFtSrMI5ArhFBCMxnUOCXvg==
X-Google-Smtp-Source: AGHT+IGe+i459NmOZi236cX8Bur8HwnWegO6n5YG8V2oQ3pdTXQJfj8y4MrKY8v3FuSI+vF/XixyV2nwOspzfQufmQ==
X-Received: from ilbea3.prod.google.com ([2002:a05:6e02:4503:b0:3dd:d24f:26bc])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a92:cd83:0:b0:3dd:cdea:8f85 with SMTP id e9e14a558f8ab-3de38cc7adbmr52345645ab.20.1750457919574;
 Fri, 20 Jun 2025 15:18:39 -0700 (PDT)
Date: Fri, 20 Jun 2025 22:13:04 +0000
In-Reply-To: <20250620221326.1261128-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250620221326.1261128-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.50.0.714.g196bf9f422-goog
Message-ID: <20250620221326.1261128-5-coltonlewis@google.com>
Subject: [PATCH v2 04/23] arm64: Define PMI{CNTR,FILTR}_EL0 as undef_access
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Mark Rutland <mark.rutland@arm.com>, 
	Shuah Khan <shuah@kernel.org>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Because KVM isn't fully prepared to support these yet even though the
host PMUv3 driver does, define them as undef_access for now.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm64/kvm/sys_regs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 76c2f0da821f..99fdbe174202 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -3092,6 +3092,9 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_SVCR), undef_access, reset_val, SVCR, 0, .visibility = sme_visibility  },
 	{ SYS_DESC(SYS_FPMR), undef_access, reset_val, FPMR, 0, .visibility = fp8_visibility },
 
+	{ SYS_DESC(SYS_PMICNTR_EL0), undef_access },
+	{ SYS_DESC(SYS_PMICFILTR_EL0), undef_access },
+
 	{ PMU_SYS_REG(PMCR_EL0), .access = access_pmcr, .reset = reset_pmcr,
 	  .reg = PMCR_EL0, .get_user = get_pmcr, .set_user = set_pmcr },
 	{ PMU_SYS_REG(PMCNTENSET_EL0),
-- 
2.50.0.714.g196bf9f422-goog

