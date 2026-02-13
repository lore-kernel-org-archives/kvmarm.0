Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D84D36166B
	for <kvmarm@lists.linux.dev>; Fri, 13 Feb 2026 14:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770993500; cv=none; b=usjDyFNB1lTPdtB2M140E4ONiqI9JF5ftbqKpzqp/iy3ik55jFpSg3L8NQlZWVE5MMfmLBA5sy8lcjHWeAvedAKrC/KbaPnBrQiaCl/EI1NYotmZXLvPovjiMpYVcM2pmAzPmv92uvs7nupA3cLtxDPw/dqgEXX2m/+ugJAcBVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770993500; c=relaxed/simple;
	bh=CBGX9joKWS1ZTVo7NrOlT+lG2W3Inq1FjMPAVo9hcsA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NLAiR36QkWmFHNB63z0vufvJvuf6lOO86rhjdBRWUvq3btLfpUlaOaFOkw3gVzjv42xi0/g/Eo2ki9Ta0cDu4EulisPVsytuRDnvZOXIBOLDmhBHLMkppYv9C9oubGGhiye6bU+iYNzj/wwz4sjG998eSId/SOWn95W+7zxn8ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=x+MCGdCs; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="x+MCGdCs"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4831192e66aso14713265e9.2
        for <kvmarm@lists.linux.dev>; Fri, 13 Feb 2026 06:38:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770993497; x=1771598297; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZI3PiRBCJaOtbE31TrtopwnjhpEV4zI9W7Z3S9kmPS8=;
        b=x+MCGdCstbD06YoXTJJ8g0z3/Y+1ufb7DlnVxw8tpNCk1ioWPWHq+8ll35pJSSxN++
         pkun8TrU7WR+G2o4rfRzmo+NaUMJc+ok940IGt2cwGjPs2xJH6iD9TRwgPaLjr2k9CBL
         lhsJlVBbomA/RpibrUQNyzpdod1KeOcnCzZ2JHnIJU9bsjmo4plyi8hFLl0flpEbdy22
         QnnbLDukaUJYot6JpbIFgXMtu/leN5N5ELhkZ3FyxG1lL/+yRn/IibhTEgEFjyvhA7jG
         fQ7AsP/RWdeezz+/V/Er99dPkMoXoxmH1YStZcU3TeFsUZk1mHwfvu4aIXw2wUyWCLW9
         Djig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770993497; x=1771598297;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZI3PiRBCJaOtbE31TrtopwnjhpEV4zI9W7Z3S9kmPS8=;
        b=PjXMYmw6Xt/z+/rRmMxFOFdYkn2GsKyYeOwMxmiIpqhYDZR1yxX4ExUBMzujjHmieM
         k2cjLWolbr0aL4EYM6a16dYrKwQ3SrRm1P2X7YSsSjFZpord2av4M7CO1wUv17+6UuvC
         jF/cUiGMOZLpUT2f+YwFoh9L116ffHtqLOCx5PHSWQkBdsSTplWEx+jkZeW63dIZlE6X
         kmGfOXs6ujTXDQvc3pBje/Baw9v9+cZyFQZWvWC9dOq0yax/Si43k59u1IKOCgStkMM2
         AloTg2GqvW8hEKgr7Tw35Ej4cbc0DHLNyE/88z/F+ycjNep8vcm6YCxpupTQQNCAw7RU
         N45w==
X-Forwarded-Encrypted: i=1; AJvYcCWCYoutNr3mRoS9QJvjvmp6Fhyh65xjgUqa1YCOqGoYgBRQj4bCZGo+VTb1zKDYkv2W8D8946I=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyw0Omk86s4V2o3dSj6jy1zKX5F8c1ZOGhhtyfmp6ZOD7/dBsEZ
	cpN/GCtKVxJouCTG2WF1SxVzfTFTA7X8TKKB4yn9salVbRPkIC5doEdPvrHl1NHAVpu/JquNOmj
	2vw==
X-Received: from wmbz20.prod.google.com ([2002:a05:600c:c094:b0:47b:d5ad:dd7f])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:474e:b0:480:4be7:4f53
 with SMTP id 5b1f17b1804b1-48371095fa6mr56214175e9.31.1770993497276; Fri, 13
 Feb 2026 06:38:17 -0800 (PST)
Date: Fri, 13 Feb 2026 14:38:12 +0000
In-Reply-To: <20260213143815.1732675-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260213143815.1732675-1-tabba@google.com>
X-Mailer: git-send-email 2.53.0.273.g2a3d683680-goog
Message-ID: <20260213143815.1732675-2-tabba@google.com>
Subject: [PATCH v2 1/4] KVM: arm64: Hide S1POE from guests when not supported
 by the host
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, tabba@google.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

When CONFIG_ARM64_POE is disabled, KVM does not save/restore POR_EL1.
However, ID_AA64MMFR3_EL1 sanitisation currently exposes the feature to
guests whenever the hardware supports it, ignoring the host kernel
configuration.

If a guest detects this feature and attempts to use it, the host will
fail to context-switch POR_EL1, potentially leading to state corruption.

Fix this by masking ID_AA64MMFR3_EL1.S1POE in the sanitised system
registers, preventing KVM from advertising the feature when the host
does not support it (i.e. system_supports_poe() is false).

Fixes: 70ed7238297f ("KVM: arm64: Sanitise ID_AA64MMFR3_EL1")
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/sys_regs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 88a57ca36d96..237e8bd1cf29 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1816,6 +1816,9 @@ static u64 __kvm_read_sanitised_id_reg(const struct kvm_vcpu *vcpu,
 		       ID_AA64MMFR3_EL1_SCTLRX |
 		       ID_AA64MMFR3_EL1_S1POE |
 		       ID_AA64MMFR3_EL1_S1PIE;
+
+		if (!system_supports_poe())
+			val &= ~ID_AA64MMFR3_EL1_S1POE;
 		break;
 	case SYS_ID_MMFR4_EL1:
 		val &= ~ID_MMFR4_EL1_CCIDX;
-- 
2.53.0.273.g2a3d683680-goog

