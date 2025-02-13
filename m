Received: from mail-il1-f201.google.com (mail-il1-f201.google.com [209.85.166.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFA63242931
	for <kvmarm@lists.linux.dev>; Thu, 13 Feb 2025 18:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739469921; cv=none; b=TsAO+fuY74CulbDXVKA2vYW8knTc0U7WPepmYQYe3xBEi0rvPBRKpSafIMe6vjO/aR4EKsYgs+ISyv+URTW6LbiNUMgCCeYjHzDhLun8YvWmfNAtKZz+aFNdV+VF1es5R1QQ0lWJ7Hv4RvCHRyoRyAJrDM+/jaut/cgsUSwConc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739469921; c=relaxed/simple;
	bh=v+3HOVLmAnq3kkRj1HHToRzS1R/S8QWxsxkOXOcO6PE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hAI9Cj5fz5jEsGt6/6IkWXeeBhDwUIGQNfO2TUs5jlCNXrJVDuaElc+nldrE0HcKctZKDJA4fTLJcZD1egW9iGr6cpLRU1qFxU++GMZnxHaey4HZf7lZhdLYRpcHdWuEINDMSmuFaL6rDZJAUPl+iw4LHSjnrvy2SyXJZDFzIeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Fw44BuO9; arc=none smtp.client-ip=209.85.166.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Fw44BuO9"
Received: by mail-il1-f201.google.com with SMTP id e9e14a558f8ab-3d14950ac9fso19026005ab.2
        for <kvmarm@lists.linux.dev>; Thu, 13 Feb 2025 10:05:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739469917; x=1740074717; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=azo+14HeAmGjnMr0Vdj3xinAaL5HZge2DDBa/K8+Coo=;
        b=Fw44BuO9VajaKV2GlY8t5J3rbyDO07PaatDrME6aMJdJIcYKn8wrIDS3RqdQIHT/iM
         E6SFCpxw5npHkPXzt2u3BlK9jkV3uCOSbVWF8/eIkN8qDHqsluF8w9jvQi1LAGGKHiox
         djo/1my2hTCDqiDt3JlKWGICwFp7b1z+M2gSX7vjOWV3aAkl1viyvUIXBlwwd+DMo84s
         oK61/hAwb+y2KdlUjBaSvH43yjih5qGjXIQYjTf3xwlRYrXgfj5/ycSh3F2xZzUB49ib
         C90ghLZM+kf53UGfIzaVO2HmzCjasPfvGR2CETWZCqAIUgnfn4AW7Qe16rq6Qsgr1nw3
         bkDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739469917; x=1740074717;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=azo+14HeAmGjnMr0Vdj3xinAaL5HZge2DDBa/K8+Coo=;
        b=UZcqCApA8HFuFLryd7kPEtQZvzGaHkRu1TattWN0unRNadAcTC3Aa+d3DqmaHRrr93
         6sL96ubZ2ulDHrJpxt/EoJHQ1oSjVIci8y15ZEscromYUkUQlGK3uv1gp0yqUpj28Gwi
         ley+Ip2Oo3vfkOgqbZurFepRS2p3g58PQNSUnYzByaFgE1sz52cuCIk4Ne1BZhnAO2oU
         e1Kb59haZcWucHi966p7obUo5AOEigJlGxT2IuyMSBhr+4UVbIUymB1WffVBdUzy9FBQ
         UHhHlkXXp55pIlr289xeRzYOgl55xRvzkjRoCNyn88/+1Zl790BGziqUUJF+7SHf6TKc
         jIug==
X-Forwarded-Encrypted: i=1; AJvYcCUKHlWQyeqqOwvlZmweczvjJd+sMLomwcFYbJDwGpP+J+aZXvKE6hLu8Qa20uUplszMyni9U0s=@lists.linux.dev
X-Gm-Message-State: AOJu0YwxIeUMWTPNFTPGPSEv2P2rt0iubAVN8LEo8WeB2xXIFbgclfi/
	NJRb6kMhre9Mu/NGZjjf+hB/V29g1l6Jgn2X4yapMFapE9WAjcqeUwXJO79IzYNGMvNIzJB7ZE4
	Rm7pPwOF/ZUHUclgr2rJNuw==
X-Google-Smtp-Source: AGHT+IEy5YVI3p9y9PPdbxxSL3+aY42Gx+CIGhUYeoIGQ50w7BVgP/zMrF/otp0RuXTOXMV66ObFIzCa2Ha7BSoLtA==
X-Received: from ilbbs3.prod.google.com ([2002:a05:6e02:2403:b0:3d1:3f2e:4bce])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6e02:170e:b0:3d0:4a82:3f4b with SMTP id e9e14a558f8ab-3d18c2d55d4mr31564925ab.14.1739469916921;
 Thu, 13 Feb 2025 10:05:16 -0800 (PST)
Date: Thu, 13 Feb 2025 18:03:11 +0000
In-Reply-To: <20250213180317.3205285-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250213180317.3205285-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <20250213180317.3205285-3-coltonlewis@google.com>
Subject: [RFC PATCH v3 2/8] arm64: Generate sign macro for sysreg Enums
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Mark Rutland <mark.rutland@arm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

There's no reason Enums shouldn't be equivalent to UnsignedEnums and
explicitly specify they are unsigned.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm64/tools/gen-sysreg.awk | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/tools/gen-sysreg.awk b/arch/arm64/tools/gen-sysreg.awk
index 1a2afc9fdd42..a227f73cd31e 100755
--- a/arch/arm64/tools/gen-sysreg.awk
+++ b/arch/arm64/tools/gen-sysreg.awk
@@ -306,6 +306,7 @@ END {
 	parse_bitdef(reg, field, $2)
 
 	define_field(reg, field, msb, lsb)
+	define_field_sign(reg, field, "false")
 
 	next
 }
-- 
2.48.1.601.g30ceb7b040-goog

