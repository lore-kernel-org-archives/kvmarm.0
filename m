Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F94032E729
	for <kvmarm@lists.linux.dev>; Thu,  4 Jun 2026 15:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780585976; cv=none; b=PqC8N8TMdQZcWPh1Tb1z26ftgw6JjvHZ0CHcE+P3v+q0QpOanrRZRHdynsUIb9Y9jfT4CwWeMgZLGllXbl8+bKdPnn/NUWp/2M9FSGmEWyYbOGCRTj/iFv51PI34M4IDiiv39A8royg7v0peg9QjnYXED5wxSetBUQ+w8PWUIm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780585976; c=relaxed/simple;
	bh=uhkjkeFfxBlSmF6NWqd8fxwIvS1cOGFLyH/kXBg4EXc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BKS5zqzgjkHL16smP4IMl9ZZJ5pWyODfQNkTuPzqF2X8Br10N9p7BV5hEy1/UrZjSrRzK8iObM7+IeWnsT1kxgRpV01ON/ZGd2Rk9ysRVV9W6i3PhdQsB8RTX9b2a/CItM3AaCRpiHKvh4XvGySC7XNN40xOjt4oHC/m8xIfXB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fjq8Usrb; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fjq8Usrb"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2c0c35980fdso8590285ad.2
        for <kvmarm@lists.linux.dev>; Thu, 04 Jun 2026 08:12:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780585975; x=1781190775; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P3K/SsiNlFZbdlNJvq9UTu1Y1PGOQfd1S84EHwWLfQU=;
        b=fjq8UsrbH4Vt5w6ADaR3aqTNgRtZeutJtjlsAgQN+MIy4/+RbdTjDCxSCnFj1wxScy
         Gz0fktOx59BQq6eknIvGye4oyBFqWKAvn0Ov6bHJfa3fi/skWRB5kiXeQYHKp9Zgyb5T
         mIrJxE5x5pdQemqpYbv0EfGyOU15v89wrZWkyfTf5h8WeZCsr4BQUe9rEmAhS5jN9Mus
         rGfAsaPb4oM/ci9tpKAE/QmWwkzwAhphcXpVu1GTJsWjvVDC+E89v/0aLYqGp1HVNQpV
         Xb4JvzG2dxWtdpljjopPp1XCopZIjfdXzeH/bncj3vGMcYq5QQwFHn48uUMCIvp4uW9/
         ZRGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780585975; x=1781190775;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=P3K/SsiNlFZbdlNJvq9UTu1Y1PGOQfd1S84EHwWLfQU=;
        b=WwtrG6G+aWUf71fxZ8X/sbj+8Hm2IcnJgXxmmF5NqL8c3SceUPeG5zv0nCAenRpkM9
         3pJSZ2mp/kENKePAhxgWspLGkjJz3G32i8xYmtCBZaN5n006AxI3GMO8ubiH58RsAPbs
         5+6QrUM7d3Soay5gMhYhrBbu31Nw8oIxmnMslyoduvuGDU+b8PMPr+tMUbz1AJ1YLyEq
         /AaTfQvKghMwO8StB28ZvVXviDpOlL2+y+WKiQxg+ol6nGJ6k09kKw5ZnkOHbGNBBFDz
         ovZDpZnuibg6sFe8z6MXvv47trBzcW5Y+cRTSh6zrmqtoDjo6YhLEtzs+SpJEP1j5o4c
         Adgg==
X-Forwarded-Encrypted: i=1; AFNElJ9T6FoI+jMt2NIBKJ9/+NWc9Tz1WExLjkJWJ9wUOdGp6K4KBPie6YJwGtddrvZ/LahemOzD5nw=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyms1voygSfE1674vWnWNxj0DK3wNHb2zLUU2reuabneLYXlVd4
	4G295myeVjJ4Q3aZPhKXIID9fKEeCekKz2ZNcM6e+7kfN4ejLrdvsuG2
X-Gm-Gg: Acq92OHCZaotgH/q24HpiBpKuCfT3EaAEYcuTcnBgikAX5f4tlGUntDDqWGnh3YXRcy
	9viLkIYiHpGnhCdLu8drMTSw/n0plGN4FuAcmxGXOFxtyugotvcwl/WJuf+XV6Crbu4oFvh2Aqa
	x2WVlyIF5fgab7VSQtqQzFqRjoY26hQzOluO90GxHAvXZY71o2C9aiteSo1yd5rO/0x3EIUN8hE
	kmRf0wfbwAq0JrfhQxMROBUe+jVu+oosS3KZdQ+23k9JtouOGDYAhy2AJDo8gliQKWXc/u/EOHH
	6FUr9McvG6et7Kzg+bpuyxUWUaEgDvkwnAh98NIAnc+cBofVD7hP2DYaNcpm6hJTx505Zq1XAWw
	Ysfqe8pb7mfHzghC+sJwVpv0Bwc++FhcSXrIbaP1LYq7SAK2ZUxnG7eeGG/PQcH4ErQ4970Xo14
	7hQHflPkf618OVzuHgIT0NLoGquKKvzGn/IYqtWRVTtHYIksVc9uq6B1Tz
X-Received: by 2002:a17:902:f60d:b0:2c0:c3c2:c710 with SMTP id d9443c01a7336-2c163a5744emr90941045ad.17.1780585974815;
        Thu, 04 Jun 2026 08:12:54 -0700 (PDT)
Received: from v4bel.. ([58.123.110.97])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c1664a67b0sm62705105ad.80.2026.06.04.08.12.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jun 2026 08:12:54 -0700 (PDT)
From: Hyunwoo Kim <imv4bel@gmail.com>
To: tabba@google.com,
	maz@kernel.org,
	oupton@kernel.org,
	joey.gouly@arm.com,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org
Cc: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	imv4bel@gmail.com
Subject: [PATCH v2 1/2] KVM: arm64: Clear __hyp_running_vcpu when flushing the pKVM hyp vCPU
Date: Fri,  5 Jun 2026 00:12:02 +0900
Message-ID: <20260604151210.1304051-2-imv4bel@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260604151210.1304051-1-imv4bel@gmail.com>
References: <20260604151210.1304051-1-imv4bel@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

flush_hyp_vcpu() copies the host vCPU context into the hyp's private
vCPU on every run. ctxt_to_vcpu() expects a guest context to have a
NULL __hyp_running_vcpu, which is only ever set on the host context, so
that it resolves the vCPU via container_of(). While this is generally
the case, flush_hyp_vcpu() copies the context verbatim and does not
enforce this, so a value provided by the host is dereferenced at EL2
(host -> EL2).

Fix by clearing __hyp_running_vcpu after the copy.

Fixes: be66e67f1750 ("KVM: arm64: Use the pKVM hyp vCPU structure in handle___kvm_vcpu_run()")
Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
---
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 06db299c37a89..02c5d6e5abcbf 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -128,6 +128,9 @@ static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
 
 	hyp_vcpu->vcpu.arch.ctxt	= host_vcpu->arch.ctxt;
 
+	/* __hyp_running_vcpu must be NULL in a guest context. */
+	hyp_vcpu->vcpu.arch.ctxt.__hyp_running_vcpu = NULL;
+
 	hyp_vcpu->vcpu.arch.mdcr_el2	= host_vcpu->arch.mdcr_el2;
 	hyp_vcpu->vcpu.arch.hcr_el2 &= ~(HCR_TWI | HCR_TWE);
 	hyp_vcpu->vcpu.arch.hcr_el2 |= READ_ONCE(host_vcpu->arch.hcr_el2) &
-- 
2.43.0

