Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D98C21E091
	for <kvmarm@lists.linux.dev>; Sat,  6 Dec 2025 00:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764980255; cv=none; b=REqtJBNsOF33+iXe1B0exMMWHHfzsliwjqlJQ8YFTlUaRcmjDH5hHNvIkhiIy6Yy/+wCCdq1XDMaekdcblJW96H+M7ejdUM3xRu2S4fnrZ48XlLuogyTJm9QfnrA466hbVo+joinuD7/M65k/FgxTl+W18I2m5YwXqjq4OgST10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764980255; c=relaxed/simple;
	bh=LI1sDcOO4Y4+JFloEIGoQdv+YZQhyxul+6jzUgodhT0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=iFQop8SordN6kGoPFMOHF6oG6yxx517CeKiO+p+CEp0ogwtCzB8jSysacovN22Rzedyc5o/rFV65gjnrVn1b2aFl6wJlg0gLw0c7tBuLVBJGe29XE/+03zDn6vmVBoaSK5cXt2zf2SbGibNXOIr2f/8SvTmP0BUptNH9Q+qGIAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=guPkpGVx; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="guPkpGVx"
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7b80de683efso4335338b3a.3
        for <kvmarm@lists.linux.dev>; Fri, 05 Dec 2025 16:17:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764980253; x=1765585053; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=8zDbYh8g4andZgSq5KjxfJP+Yx1X56NwE8CC/T+SiEI=;
        b=guPkpGVxp9yeJ+eP82J6KTFfFisv3zUA228Vaex0HDWxD3fgZj9JBbvqd2wpHlU/1g
         00Bc6tEqJwLZpYquPsQnKOHnN5I4x7ctTNidkiMCsVS1Zlietm6CfT9PwT8Iz9LYKrXF
         dIrTdxDDIMxex3cGgpB0UiTf1wpcZdk1J6sq3RKd3l2V7Et3TPSzltv8Q5hGrcuO4Zd2
         /rxS9uge9ydC6BgHwNtNeMGceJMUWr3VYENsq4/57CUCV15vYABHtRa5RS5CG5VDc0tU
         /b6yQZHWjsc75vUTjSbSX++bc/IrCoHuxxJCoYAAmHCH83aXnAdcaJmLZZR+GxnE4J3b
         LLbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764980253; x=1765585053;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8zDbYh8g4andZgSq5KjxfJP+Yx1X56NwE8CC/T+SiEI=;
        b=nYICq7tJqk1v+vTAjR0MRjIlGj33bJ8m4k318nJiaV21iMC4MZ/Og8prBsFBNHAUBT
         8dFl2agLTXS2rIK4d4MMJUWDFE8D/mWYaBnf18RbnVQt1shPSlHXNd/4OTAFfA6hRZju
         VEWiZFyL/6akamLXbDkoj3ukaE4VxpbZpK1X/sLnKCkW3KFQkcMfOotjR4g3I+ucsTZx
         UdhY6aUWFj5w/+owOFi+cG21JyVFe6ppOTiCmzlpNTDB0rD6uHOvN8zOkt1Oo/wcmiC2
         LppMJrW5JDqvv3YWSyuzMgZExKOKykm9VDi11rjZs1orUCVNyu5Y50bPIJQP/vBB8pSa
         mWYA==
X-Forwarded-Encrypted: i=1; AJvYcCV2OyhBFNNJKBxHEPA+1PpD/nb2E1wujKcWOEy6irHBUSHCUB5bhRXG0pLF4yf/78e4U/mlAFM=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz4KDKnphiPUvDEde+qlPteY+83Zp6U1YdgHzL1i30yjx9g65ku
	b7CTnrrCuUmtiCd/smTAeYM081MZVQh8lh/nWhxODaUND0/Ey9/fwm1R07AmbVLijdWayPT7v/q
	FA0YxjQ==
X-Google-Smtp-Source: AGHT+IF/oM705F739LTH8aiHz6AKpqWGtQrIi8ngNpofrp5S2I+xWIdijTs20meiR96WS9wVH7kHD0C0BxI=
X-Received: from pgce2.prod.google.com ([2002:a05:6a02:1c2:b0:bd0:79b2:aa3f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:7b23:b0:366:1880:7e06
 with SMTP id adf61e73a8af0-36618807e8dmr621575637.0.1764980252791; Fri, 05
 Dec 2025 16:17:32 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  5 Dec 2025 16:16:39 -0800
In-Reply-To: <20251206001720.468579-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251206001720.468579-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <20251206001720.468579-4-seanjc@google.com>
Subject: [PATCH v6 03/44] perf: Move security_perf_event_free() call to __free_event()
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Xin Li <xin@zytor.com>, "H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, Mingwei Zhang <mizhang@google.com>, 
	Xudong Hao <xudong.hao@intel.com>, Sandipan Das <sandipan.das@amd.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>, Xiong Zhang <xiong.y.zhang@linux.intel.com>, 
	Manali Shukla <manali.shukla@amd.com>, Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

Move the freeing of any security state associated with a perf event from
_free_event() to __free_event(), i.e. invoke security_perf_event_free() in
the error paths for perf_event_alloc().  This will allow adding potential
error paths in perf_event_alloc() that can occur after allocating security
state.

Note, kfree() and thus security_perf_event_free() is a nop if
event->security is NULL, i.e. calling security_perf_event_free() even if
security_perf_event_alloc() fails or is never reached is functionality ok.

Tested-by: Xudong Hao <xudong.hao@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 kernel/events/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 1e37ab90b815..e34112df8b31 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5602,6 +5602,8 @@ static void __free_event(struct perf_event *event)
 {
 	struct pmu *pmu = event->pmu;
 
+	security_perf_event_free(event);
+
 	if (event->attach_state & PERF_ATTACH_CALLCHAIN)
 		put_callchain_buffers();
 
@@ -5665,8 +5667,6 @@ static void _free_event(struct perf_event *event)
 
 	unaccount_event(event);
 
-	security_perf_event_free(event);
-
 	if (event->rb) {
 		/*
 		 * Can happen when we close an event with re-directed output.
-- 
2.52.0.223.gf5cc29aaa4-goog

