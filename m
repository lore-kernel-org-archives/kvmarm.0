Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC8E22BE7BA
	for <kvmarm@lists.linux.dev>; Wed,  6 Aug 2025 19:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754510257; cv=none; b=OJ2RcJJH+WqVWH4bKpDJqFvu6Td9eJu78LYfUw8QujQ8pHqyciETCo/tYHPLpjXidxu5k3UabWtj3deXvb2HsxfAPxkgK3YVgPkPqTqzLZa9KacbVaDK1LrTNreduywuvRCv1xEbaXGDrQ43UubEk14h4RgDVIEI0H2WqoNvo2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754510257; c=relaxed/simple;
	bh=tS0WmC5r+kmTtxkhhYKlXDU+egOc68kS1ctzXr8LOA8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nFu5u8AAIzEg0tYQnaKQ1fDzS6bRImGsNldt+zIdFDI2S/PBE0FgdIY27LZGCcRsjc8ZiA4WpYo1FzDZ7sbcM1YcisCa+LDmv1i+x394aZVNPcz4dREuUsfQX4tI7lDwKFcunazZVLgzXaoYkB3YcnjNubF5JfxKNF9GHOYTpRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KAQhCwwr; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KAQhCwwr"
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-76c115731eeso519802b3a.0
        for <kvmarm@lists.linux.dev>; Wed, 06 Aug 2025 12:57:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754510254; x=1755115054; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=tP9GWyHDKyhyNham1AJeXmzoVBEhNFAEzN5Uklpk9I0=;
        b=KAQhCwwr8WbYdbZsUWvUgGXCOMNUTatYd2lavS5ZSh5uBKe/VhqN6HiwH0zGxf5T0x
         EPib3T1p/i3535AVIzwn22PyeU5DK6h8hcs/P5lvkkG3R0o6ZijLMv7wrin0nglKWXbT
         B6rd/mnhn1XIAX1yTa/3TrcBewZpxRerBWUsd+l+KoTef8LXG6/qKUoxwrHDzVO4i/wJ
         C72PfSSXGkxAIprSAPez751RnA6bWOJgop0egDWTGOJZNMDUPkSe1wx5FkyFB+1m70nf
         2tZBPSGJl0lQKFZa5tzRFu5hzp6dS4Kvlcq4CVQVzCSC12gx0CZ2XVvV//8U0b0o6k7R
         vPSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754510254; x=1755115054;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tP9GWyHDKyhyNham1AJeXmzoVBEhNFAEzN5Uklpk9I0=;
        b=XGDuD/0CpnXQXEv0xgTQBIxadpk+J8mXGhrnH2XFOQabJ2YDfHpC7RUAeqQTkjCVoj
         57qBpuN+IO7Z+RwHJBAJW5ftCJOM2pgKM6vmhWvqdwJfnTSoOG7g4z6IAzUCyCXfrPLO
         GOeZ4+qoBB22FBkwnp6ELrSixVs9dejvW6Oy4SPhzZoEaFFiSWld5ts8F4byLOTN5lgm
         S+MryBNAGyvsuUwJuADE5fZnBeuIwbW5RRB4l+BI2k4QvWBzingr2cpQNmyVGUjmffjJ
         Dc3GhhVjLP2oK4zBqi/rnqDghJXnESg6bFUnapq43Bf/0IlJa/tLR1Mdal/TSsiK8N/l
         b0wQ==
X-Forwarded-Encrypted: i=1; AJvYcCUk9ceu2JPP4DxAwe0dGj2xWJ21zldWGaFuuYvx6viqFX3bRj5tUllK1ZthHrn9inM9Auzyvz8=@lists.linux.dev
X-Gm-Message-State: AOJu0YzsoNnAUOdABQrhkT/GZ2pejh1C8viSx/1U61oHk1DQQXKp5x3X
	gJ+Yr2W0wNISHxRBVa01jZ96g9clRILcvVRuKkEjfUQZOFLKKejDI7WAjfFiPQQg9Vde1OVBEQr
	Myb4T2w==
X-Google-Smtp-Source: AGHT+IE0CEB3xtAs9hI54+H7B1IyMBLcepknW0FCY+2mxv/eXxKsKgLhnBmg0Z6EMAhWWlTkD97yQMZQQo8=
X-Received: from pgg21.prod.google.com ([2002:a05:6a02:4d95:b0:b42:3ec5:d919])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:5493:b0:220:aea6:2154
 with SMTP id adf61e73a8af0-2403125bcacmr7040722637.17.1754510253905; Wed, 06
 Aug 2025 12:57:33 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  6 Aug 2025 12:56:25 -0700
In-Reply-To: <20250806195706.1650976-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250806195706.1650976-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
Message-ID: <20250806195706.1650976-4-seanjc@google.com>
Subject: [PATCH v5 03/44] perf: Move security_perf_event_free() call to __free_event()
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Xin Li <xin@zytor.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, Kan Liang <kan.liang@linux.intel.com>, 
	Yongwei Ma <yongwei.ma@intel.com>, Mingwei Zhang <mizhang@google.com>, 
	Xiong Zhang <xiong.y.zhang@linux.intel.com>, Sandipan Das <sandipan.das@amd.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

Move the freeing of any security state associated with a perf event from
_free_event() to __free_event(), i.e. invoke security_perf_event_free() in
the error paths for perf_event_alloc().  This will allow adding potential
error paths in perf_event_alloc() that can occur after allocating security
state.

Note, kfree() and thus security_perf_event_free() is a nop if
event->security is NULL, i.e. calling security_perf_event_free() even if
security_perf_event_alloc() fails or is never reached is functionality ok.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 kernel/events/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 3a98e11d8efc..1753a97638a3 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5596,6 +5596,8 @@ static void __free_event(struct perf_event *event)
 {
 	struct pmu *pmu = event->pmu;
 
+	security_perf_event_free(event);
+
 	if (event->attach_state & PERF_ATTACH_CALLCHAIN)
 		put_callchain_buffers();
 
@@ -5659,8 +5661,6 @@ static void _free_event(struct perf_event *event)
 
 	unaccount_event(event);
 
-	security_perf_event_free(event);
-
 	if (event->rb) {
 		/*
 		 * Can happen when we close an event with re-directed output.
-- 
2.50.1.565.gc32cd1483b-goog

