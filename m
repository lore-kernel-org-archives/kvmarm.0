Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E8A116DEC6
	for <kvmarm@lists.linux.dev>; Tue, 28 May 2024 12:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716901180; cv=none; b=bAxtyBrgVMWm/oUigxYPq3JH3pbwvQo+oLcF96fFr5+j4lzM77+xdqOuudqvzB3fiEAXpD1dbDHMwUKQM/K965z3QIGBQf21BsQhDmEyWC5i0V8OUdXrfPidigyFovE3vFguOplvf3yScIhT3F9NoPkJHR44wCeu1jIPYKYRC6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716901180; c=relaxed/simple;
	bh=ruD1/8KmDokGzeceiV7Mw6Lxhv0bK6ORijIVen+oVZc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=O/qvaSft2YZ/QfhPknURqTDIbSVHzv6yJNKmmoKItj6o4zGFPQ0pRIKoyM0rMTMcS6mkjvxxp27rfEbMoiTmZfYoA1iNsnk83MGgPXHGx60AXEeTk4MYfRdF4IEvy6XNmOvUfORModCJQ1EHLw4E1X8WZytSUVEuUwV9SYPXmFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=U6GoEqo9; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="U6GoEqo9"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-df78b274073so1348457276.3
        for <kvmarm@lists.linux.dev>; Tue, 28 May 2024 05:59:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716901178; x=1717505978; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Xp4TCseA8S3pG6dkj/s1gzJJ872SKDig/yFvrCI2SV0=;
        b=U6GoEqo9y10bYli0MEGtq1q/dR7hfUnYQP7W8L0tWXOslkMfV1T6P3PSqzvnc76xFi
         HhnlCT8PZoh+TmlDatK1ocwsLhOFBLequF8icvXeVKbI6u8eyGuGPHsormVhkA6wSnLU
         ujTuj+PpDyNxOAzPYz9rAeWCb8p6271xhQE8+IYRp0GMkj924B7/m9jlkWDuqeOVC9OS
         M3qpulZvqj83YPKkRrMV5TpuIqC2Tt51fWsBy5SakBQ5bci4cfENJae2Phnc+SB/zrGW
         SOqjJV68vLmdkDHO+4eDJksBDIkDVGeqldWCg7zmkTd102SDcCHfTBN4jpjaF6Uvfr1T
         I8Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716901178; x=1717505978;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Xp4TCseA8S3pG6dkj/s1gzJJ872SKDig/yFvrCI2SV0=;
        b=H1hsdSjmSRGr728P+vUMTViMn1/xxkemMOafOqy8du7fgBHTVqb8dUSIORHOGJtlee
         8pv/DIB+A5VMpys1Jh9ZJjMTqMGvgL/Msi+Uc4irgRZ15Xv8DwbRvvP5FAhtaZoJUpYc
         VxJx0v335n6gxV52UV1G04NK9wKdP448E5ZRWeTRUQe+/2aiKO82HaWFzMXn+MotNEuS
         YyPy3avsdWhO3tlJ3pUSFTU5yLlZx+kSHqBWMqLIrh0Ch3tKke+eVMCbTwrdeKaKo7cw
         lkcBOjQfhvTrLzLelHvXzpone1KTHaReixA2IfBuOWQ3aKj56XzbD7TpgqeAiVevLGIA
         oW9A==
X-Gm-Message-State: AOJu0YzgrixSP8xGLo5W6YH0xIk/kk7D5wq6R88KyeipO8+1LbwRMlU8
	LXtLSSL+R6oX2ZI4KWqyhcpYIPLm4zL5zB44z5/qnOK8qSjUjIU0u/gCRgmHvcm3P1ue62k2YwL
	IfPh1lzPazEDvLCpPcFl5hn5/xNb2ejA+GGSjCiJLI+GguGGzGjaVKrypCKtL5pwKrsIPn4bPRG
	h6C/iVdXej50Un/5v3kKNfoYJ/Qxo=
X-Google-Smtp-Source: AGHT+IEvPGQEXgcVtlwFwfvohMrl8h9bv++S4JYU0s4Tq8mNBnEuIpsELqH9pDFR6aLY5IgHq4tB6CTx7Q==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:6902:114d:b0:df7:a340:45e5 with SMTP id
 3f1490d57ef6-df7a3404caamr1868809276.9.1716901177880; Tue, 28 May 2024
 05:59:37 -0700 (PDT)
Date: Tue, 28 May 2024 13:59:12 +0100
In-Reply-To: <20240528125914.277057-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240528125914.277057-1-tabba@google.com>
X-Mailer: git-send-email 2.45.1.288.g0e0cd299f1-goog
Message-ID: <20240528125914.277057-10-tabba@google.com>
Subject: [PATCH v3 09/11] KVM: arm64: Do not use sve_cond_update_zcr updating
 with ZCR_ELx_LEN_MASK
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com, yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"

A conditional update of ZCR with ZCR_ELx_LEN_MASK is unlikely to
be beneficial, since at the time nobody implements 2k vectors.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 1088b0bd3cc5..b28d7d8cdc30 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -468,7 +468,7 @@ void handle_trap(struct kvm_cpu_context *host_ctxt)
 	case ESR_ELx_EC_SVE:
 		cpacr_clear_set(0, CPACR_ELx_ZEN);
 		isb();
-		sve_cond_update_zcr_vq(ZCR_ELx_LEN_MASK, SYS_ZCR_EL2);
+		write_sysreg_s(ZCR_ELx_LEN_MASK, SYS_ZCR_EL2);
 		break;
 	case ESR_ELx_EC_IABT_LOW:
 	case ESR_ELx_EC_DABT_LOW:
-- 
2.45.1.288.g0e0cd299f1-goog

