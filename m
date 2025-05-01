Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8D9A225775
	for <kvmarm@lists.linux.dev>; Thu,  1 May 2025 18:33:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746124411; cv=none; b=sFqdhETs2Qkif1RBWY7+lvXoB6GZs9wAMqmkH2IBis8c3im2JpAJdLav8xTxGe7bHNYPypGLc4nTEN8KzwGhAo6P3NR/5I9qgaRplENpyhNziDz9qu7U1TOEnmGwoL+/f7lZuDK4wSfHnD0j/7/EBUPzB4NWDUT4/ieJJbZOHaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746124411; c=relaxed/simple;
	bh=AyQYns9VrYXUgKE1RAyvfX8Qdmj+bL5M40qUKypPI3U=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DaPW4NXB/WyU+749+/zukcbUEGZkYXFxjWq4mczKNB0PGfDsn/qPNVrTTLM0w22IHk5cfZZYoI3dWcAsuWmLrkykGdNLNH9zA6n3/mKLtSZPJYnxrAKkyiIt9JkoJThg58Jcw2gHcMH9bTaVWLBk00/16i687uEx3Cg09WhXZw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nRZ/OdnY; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nRZ/OdnY"
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-af2f03fcc95so1249229a12.1
        for <kvmarm@lists.linux.dev>; Thu, 01 May 2025 11:33:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746124409; x=1746729209; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vmZxT8OePR70IlcHk3w9PyaS2Ebe0ZK5Neg7TiicVTQ=;
        b=nRZ/OdnYEuTeWYOEtwq35TWirCcdkP1hA3VuHlCDozXPdI7zLi3/4m2ydKCBEBu0Mx
         fGrYzjIIqqrUwfORZjzkVPmw6sld+4Z5m/XmgOjm8dUJioXIYO4Tw0keZY/50ZCG8lzh
         0PX+L0bV9zXOwKrewMFerKTp7Mi6KJBKE8rhyM1YaYe8msdxoUahV/ezED4zMfLdt+Ws
         ZvVywDk62xR+MjmZf9BDnwjuOTvJU0g2rrNxXwA8iV3v1ejhTw0VZP++A38fN5xT/jk6
         +kC3A2gxMHHimb0W6MrYn4xGKWto81lnVJMjgNgSQzLeE7jwziIIprpf2EdpzplDTYbH
         PQhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746124409; x=1746729209;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vmZxT8OePR70IlcHk3w9PyaS2Ebe0ZK5Neg7TiicVTQ=;
        b=jpwSNvuoxnh8KQTmI1xqHYxTQmnuHMUALnzslpriarr6nbmDGxh1g9bo4uDaRhEDy2
         X8meuayaKBcLb6uH0JPO/qk/SNsaOslmnPjr2xYTPev2v6IRmT2BZHoXt6gSdZDFPBYd
         dC2k24F1Q6EPo9Z3+GMkiazPTPTDyCW0z+cnmjFje67UD15a1AbaW8VksJqw0ttYmQAZ
         Qb3PzFcn/nb0Q3rrPWkNe7oaz2nUFp+kHoE7FzyDpSGCZxoVkY6Nf/3Pb/e6GW6iuSAj
         QQSzNYsUDxv6F3mEicUROENCSf4A2xkIqEKhif3v/SVHp7xirx8ViWoXyU+/SLUbtQlu
         K3vA==
X-Forwarded-Encrypted: i=1; AJvYcCV8goUmwm41FNNtRtUKDdV9eZU40koOqo34+rQiCLJ00EpazuFeNTKidSvWGOyzrFf2GJ/2NgE=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx+fJrR3P9fzN+driNv+EwDy35RkdipK6cuReosShxoDxUSpkuz
	E4xCUL+7TtuHLlACmxpjT0X8iw0962/BuBfka8gX5tlDGbmyhhwzzhRkN2sAnLUUaA4+ZvGJxIJ
	u1wgZWbdtPQ==
X-Google-Smtp-Source: AGHT+IG7ZB54jjneYfe1tn18St+FGK/8C/RP49qADT4OdwlvOWaJA1tk/v3Dm4OeF0p3gO05OEVmZwLAOdDMmg==
X-Received: from pgct19.prod.google.com ([2002:a05:6a02:5293:b0:b1b:54f8:d2ee])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:1587:b0:1f5:8262:2c0b with SMTP id adf61e73a8af0-20cde46dddemr28056637.2.1746124409090;
 Thu, 01 May 2025 11:33:29 -0700 (PDT)
Date: Thu,  1 May 2025 11:33:03 -0700
In-Reply-To: <20250501183304.2433192-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250501183304.2433192-1-dmatlack@google.com>
X-Mailer: git-send-email 2.49.0.906.g1f30a19c02-goog
Message-ID: <20250501183304.2433192-10-dmatlack@google.com>
Subject: [PATCH 09/10] KVM: selftests: Use s16 instead of int16_t
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	David Hildenbrand <david@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	David Matlack <dmatlack@google.com>, Andrew Jones <ajones@ventanamicro.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, Reinette Chatre <reinette.chatre@intel.com>, 
	Eric Auger <eric.auger@redhat.com>, James Houghton <jthoughton@google.com>, 
	Colin Ian King <colin.i.king@gmail.com>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"

Use s16 instead of int16_t to make the KVM selftests code more concise
and more similar to the kernel (since selftests are primarily developed
by kernel developers).

This commit was generated with the following command:

  git ls-files tools/testing/selftests/kvm | xargs sed -i 's/int16_t/s16/g'

Then by manually adjusting whitespace to make checkpatch.pl happy.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 tools/testing/selftests/kvm/lib/guest_sprintf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/lib/guest_sprintf.c b/tools/testing/selftests/kvm/lib/guest_sprintf.c
index afbddb53ddd6..0f6d5c3e060c 100644
--- a/tools/testing/selftests/kvm/lib/guest_sprintf.c
+++ b/tools/testing/selftests/kvm/lib/guest_sprintf.c
@@ -288,7 +288,7 @@ int guest_vsnprintf(char *buf, int n, const char *fmt, va_list args)
 		else if (qualifier == 'h') {
 			num = (u16)va_arg(args, int);
 			if (flags & SIGN)
-				num = (int16_t)num;
+				num = (s16)num;
 		} else if (flags & SIGN)
 			num = va_arg(args, int);
 		else
-- 
2.49.0.906.g1f30a19c02-goog

