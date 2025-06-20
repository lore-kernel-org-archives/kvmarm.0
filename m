Received: from mail-io1-f74.google.com (mail-io1-f74.google.com [209.85.166.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59A9D23C8C9
	for <kvmarm@lists.linux.dev>; Fri, 20 Jun 2025 22:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750457920; cv=none; b=T/enbbsbdly8vCdamw/90vb15+Crif4LezyIjY0MU/Jlc5O6iES9IGu5IcMeYLS4emIGicQzYyvQ1Fc2291hnzu/+c/IcZ8NKfay5pk1f8W2fvBX6DqaQAWssWmOWVVhXC95Ieiy0XSsaK4KlDzfPiREAjhKlGb92FISFMyGMwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750457920; c=relaxed/simple;
	bh=ZTAgaNMzI4qiekOqkv3pNeLxj5wOqxlFzSL0ObZQoaI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tkfGBU4vELfnsKbObI8CguOlDqm349Jir2Wc1c5of96vmzlVVT1DT/FuO/X9YhK33SH+MYM2TS7zyqTZyWtB0B6ZH5aAdcrZuF7vAoAM22kYtJC3+Tn3j0B/Gweo9un2qJbVIjGkii6UVtjunifsgeszUs7XAbKHfAw/IrqsNWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gkQRvTEo; arc=none smtp.client-ip=209.85.166.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gkQRvTEo"
Received: by mail-io1-f74.google.com with SMTP id ca18e2360f4ac-86463467dddso188098339f.3
        for <kvmarm@lists.linux.dev>; Fri, 20 Jun 2025 15:18:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750457917; x=1751062717; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Tgz/COFsBAperIPw3jbaNsXNDBcCpCZIFlLHMRVJgqY=;
        b=gkQRvTEomoa+5bHGYqoLmhx+9+qHNHoAoTawc9pH9XTLH3Hh1X+BzcZQluH4qWCZKR
         LD7Ofj/v/nAN9+nQ/v/8ynkQf67ko59tpAC7YNOLfRjB1PAoiIilBWGgpshLkBrwZbHR
         VpJRL1u6ZvLquGoPrY2LIzBHQMCl5rgUX50ZG7HGztNn6Y9AQVdetoKxATYzBc+JI95M
         hTmbq7+0K1tE2/C/ilfvMVQlGIHvNepA/89rxPLTzDPhpzixwE1HyytVLuIq6SVe/Vzq
         XSilkfOdQhwBLMrmHnVx8g4uWmV9MfxBroakn9At828V9wJV7eUcnhlG8qoMIqdf054W
         HFTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750457917; x=1751062717;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Tgz/COFsBAperIPw3jbaNsXNDBcCpCZIFlLHMRVJgqY=;
        b=lI2NRvLtlLYTNgiOijwT6EWmGJndEljsJpnP/PYedrM3+9CqNz39LtyxyFxlZrccih
         ndDjwhdkAk6QWR+TeD6A7sEG4YvrWxa2wGVsqaFJ4NZ8uGJ1fyi/ol2bbxIO23DpKCm0
         zg4L3vEg7++IMyZOYkbo3HhAlCGGdH5afi/LUGB7WQzM48HwvfLY4q8mh2J/jobESLMT
         uOzkNrB11TY5k8Wpe8m4KRA353PdX/JN2bPSWEK2NvG12AQAGnCkH0o/CfLMjk7XhPKa
         m+uSwNEGyUuxIVi+f4C6uPVgwmnJVMPu15vover7u4oDxBjVyVUk9N1m/e00eUt6Nzxj
         n88w==
X-Forwarded-Encrypted: i=1; AJvYcCXVowOYxkHPXnlp5fgOjgkVwX6GD58z4L5aDPOYDrNu8k0pHLv8EgudYd1mMqxPBq/OMHAbNaA=@lists.linux.dev
X-Gm-Message-State: AOJu0YysdXm14VHT4SsO/Rzf4+eVOPSrZh9PkBLYJ7+SCI3yW5f11Zn5
	2aUAzJYY0QMBoZWQWhPGFFjwG5I/gVuCnJYCSMWnJHidA67rUWjdTR3cl9dLbBwZ3gsbsmjcEvK
	kMlnWyVhvHF99Heek7frpZnZ/sw==
X-Google-Smtp-Source: AGHT+IGjEFFNY2ukf5QiVzn6d0Iwii2o/2bYlxITJ69QjxdmPFLoVLBssIQF8Rhp8gGY8wow9/U+VX25kMai0q6pUg==
X-Received: from ilbee13.prod.google.com ([2002:a05:6e02:490d:b0:3dd:bec6:9d56])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6e02:1646:b0:3db:86fc:d328 with SMTP id e9e14a558f8ab-3de38c2e1c2mr57720245ab.5.1750457917550;
 Fri, 20 Jun 2025 15:18:37 -0700 (PDT)
Date: Fri, 20 Jun 2025 22:13:02 +0000
In-Reply-To: <20250620221326.1261128-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250620221326.1261128-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.50.0.714.g196bf9f422-goog
Message-ID: <20250620221326.1261128-3-coltonlewis@google.com>
Subject: [PATCH v2 02/23] arm64: Generate sign macro for sysreg Enums
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

There's no reason Enums shouldn't be equivalent to UnsignedEnums and
explicitly specify they are unsigned. This will avoid the annoyance I
had with HPMN0.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm64/tools/gen-sysreg.awk | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/tools/gen-sysreg.awk b/arch/arm64/tools/gen-sysreg.awk
index f2a1732cb1f6..fa21a632d9b7 100755
--- a/arch/arm64/tools/gen-sysreg.awk
+++ b/arch/arm64/tools/gen-sysreg.awk
@@ -308,6 +308,7 @@ $1 == "Enum" && (block_current() == "Sysreg" || block_current() == "SysregFields
 	parse_bitdef(reg, field, $2)
 
 	define_field(reg, field, msb, lsb)
+	define_field_sign(reg, field, "false")
 
 	next
 }
-- 
2.50.0.714.g196bf9f422-goog

