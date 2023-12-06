Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06F5749F75
	for <kvmarm@lists.linux.dev>; Wed,  6 Dec 2023 17:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="L5Cpw7Hi"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-a00cbb83c80so124309266b.0
        for <kvmarm@lists.linux.dev>; Wed, 06 Dec 2023 09:02:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1701882167; x=1702486967; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/Kp7BCmNsK0DEM7rucSiubKQj48qbRMInEEicew47CI=;
        b=L5Cpw7HidG8F7Bn0BxJkRGPDVkMXM/vlmK5xMah6hytZbzvSWnfer4KWyCsdZ+qS//
         hTiPCykWboRjzovIb7EC8jmbUBXuwf/IVSmZW1lctwsJmL6B1J9ngpz7ngiGqDMa9MKi
         +xJwSB9qBCRjSijZbrRKlrxryzb3INYwOn9HTdU2xNVePe8z4bEaxSeHzrlpBdyVftdz
         +bFBGMA/fsYntTSva2oy6CIP6IEEhCpv5o4Zgi8HLm6X62zAsLn6p/ac4vn9GgdR9o/k
         Zd64rgQzjK5hD1l/YbFdXHdYCKuqpmAGhLoNHI/B+narPc/ISEjW7150H5IDTB1wbw5U
         /tyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701882167; x=1702486967;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/Kp7BCmNsK0DEM7rucSiubKQj48qbRMInEEicew47CI=;
        b=cOvxpPBbvaShPYxzXztyQ9WbmGgHoqG8bPfsnSrOeHO99l4vKjMC26e4oCLwGUIm7k
         tVjQ6ieEePiAkUihp6xwT7Ia5K0/O0bTscV7gCUP2pz5WH8epRCgLSXt7pTV1dJMkk7o
         XqGLj65+qoxpBFJB33ontre7RV/LXb4kN76oqUq0jE0RaRykk6o3WIkfO66umAeEzd8O
         m/IzxrDwSLeUa834bu5UcaNW7px/dKNA6EUOrS3Wkcqw+rAwHpfA5v0vTeQDewBHk5iN
         pU7lDZEAw6ZyHMPHuHjcJrOZR9RIhofErmBdii+0/K0dUNHnM92Mqfo5i/joXAzccxT2
         VeYw==
X-Gm-Message-State: AOJu0Yw1Rs8Nga9uM1BcsT9vHfBJlCQYE++3mPr2XV+glCEXHpC39C7L
	qpTodiNJPdZni530W5AMer8eoQ==
X-Google-Smtp-Source: AGHT+IEKDxB7NgfA4KWg/wc6ee4tQZUdtc3hfUtVNGbPYazUN/5PYDyXVHg1rFMHNPTn6y1yyB9LLA==
X-Received: by 2002:a17:906:3f58:b0:a19:a19a:ea9e with SMTP id f24-20020a1709063f5800b00a19a19aea9emr879624ejj.87.1701882167228;
        Wed, 06 Dec 2023 09:02:47 -0800 (PST)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id sa18-20020a1709076d1200b00a1a8d03347csm180212ejc.13.2023.12.06.09.02.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Dec 2023 09:02:46 -0800 (PST)
From: Andrew Jones <ajones@ventanamicro.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	kvm-riscv@lists.infradead.org
Cc: seanjc@google.com,
	pbonzini@redhat.com,
	maz@kernel.org,
	oliver.upton@linux.dev,
	anup@brainfault.org,
	borntraeger@linux.ibm.com,
	frankja@linux.ibm.com,
	imbrenda@linux.ibm.com
Subject: [PATCH 3/5] KVM: selftests: riscv: Remove redundant newlines
Date: Wed,  6 Dec 2023 18:02:45 +0100
Message-ID: <20231206170241.82801-10-ajones@ventanamicro.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231206170241.82801-7-ajones@ventanamicro.com>
References: <20231206170241.82801-7-ajones@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit

TEST_* functions append their own newline. Remove newlines from
TEST_* callsites to avoid extra newlines in output.

Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
---
 tools/testing/selftests/kvm/lib/riscv/processor.c | 2 +-
 tools/testing/selftests/kvm/riscv/get-reg-list.c  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/riscv/processor.c b/tools/testing/selftests/kvm/lib/riscv/processor.c
index d146ca71e0c0..b3082da05c76 100644
--- a/tools/testing/selftests/kvm/lib/riscv/processor.c
+++ b/tools/testing/selftests/kvm/lib/riscv/processor.c
@@ -327,7 +327,7 @@ void vcpu_args_set(struct kvm_vcpu *vcpu, unsigned int num, ...)
 	int i;
 
 	TEST_ASSERT(num >= 1 && num <= 8, "Unsupported number of args,\n"
-		    "  num: %u\n", num);
+		    "  num: %u", num);
 
 	va_start(ap, num);
 
diff --git a/tools/testing/selftests/kvm/riscv/get-reg-list.c b/tools/testing/selftests/kvm/riscv/get-reg-list.c
index 6bedaea95395..4355e33c0cec 100644
--- a/tools/testing/selftests/kvm/riscv/get-reg-list.c
+++ b/tools/testing/selftests/kvm/riscv/get-reg-list.c
@@ -112,7 +112,7 @@ void finalize_vcpu(struct kvm_vcpu *vcpu, struct vcpu_reg_list *c)
 
 		/* Double check whether the desired extension was enabled */
 		__TEST_REQUIRE(vcpu_has_ext(vcpu, s->feature),
-			       "%s not available, skipping tests\n", s->name);
+			       "%s not available, skipping tests", s->name);
 	}
 }
 
-- 
2.43.0

