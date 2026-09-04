Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 216F0486E40
	for <kvmarm@lists.linux.dev>; Fri,  4 Sep 2026 12:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788524708; cv=none; b=r8boqRT8mXnOuIkt4u7yja8MsmbEPoNL7XGfPL5o/6kpe9CA4KzfPdMCORBxFQB1T0kPFgw51b7vKtGP1/FOdAHE3pAZ119bWvcU5F2C845t3+ZRwoiua9Gs8mZrS6viP8JLYvrZFgjKCqM+htyftHYaL2wLQqEcdwZa8glQb0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788524708; c=relaxed/simple;
	bh=3iUriw5G9tLLdUldFdWduwupBM4ijNn3LE6YBKuKoRM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qTRvW7ntPlfANfU06Mkut0eKf0Ab/evTTU0eAUVkS41T5MkKZe93wq1O8KUwTGcbfsSzpKXwyMnzrwOftTVhgqMHQp6k/t6m27n5m3g55W6Th3HZH5wj7bZy4AMb7SrC9j+DoAaiUlTl66GIvVamL3er5GQI2BBlJyyF39630D4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CR+1pCta; arc=none smtp.client-ip=209.85.210.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CR+1pCta"
Received: by mail-ot1-f43.google.com with SMTP id 46e09a7af769-7f5934ba2a5so499032a34.3
        for <kvmarm@lists.linux.dev>; Fri, 04 Sep 2026 05:25:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788524706; x=1789129506; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TQohy1k6O8N4/FlPUm0T2gOe7iYaF+RMdNWyiCLqF0I=;
        b=CR+1pCtaqNYDY4Yy4mhZa1T0sD13+p8XN9HpK3SMtyBTGKSCbMQBX5KNH8emIWVQ3R
         sNVAiYSw/6QyejMjBLV3v5r8jSKQxCrgPfz6GqUomDZnMgqHxsM5LsPU7QWmFKfH4Vhx
         ACDBEQZPw/F4RQ9NHb+ox4ySCk9uvSG/e4r/d/bbmkmv9cnL+U6cU0k5gs4u0m+ZIeaY
         k996gxACP3uiWfMQO4wFf2hlZ8CUklz/sQCXTvPVBuYZ15kc4vxunnGv8XJQecUu4noC
         NOtgaWFM6gRQNnzOkJSXMIjhtxrdqqmIIUK56JjthmSmDlS9/ouVG8sInf0SUOt9OyrC
         7D1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788524706; x=1789129506;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=TQohy1k6O8N4/FlPUm0T2gOe7iYaF+RMdNWyiCLqF0I=;
        b=f/vaQdlXZT0SFXWhqrAD0ZfuFSb3gnaTN43wflOQiXRK8p7ZB12U9vU+CXqAapS+Ku
         oVrH17qUSJfhhvsZHznVpIH0kD8VXhda+cCWyrikVo5JDTWEB28M5+s3CWGKuNy8UImS
         lBoUtuW6muTLx3jV17p37mtxrZ07wY3Cpv0QhV0AZFw1ksZlaRu9elXVR1r3aI5e9+Cz
         fCzPFAxGM/M3t7ZVtWxtIOMZLGINvB0jlnz90aujqpxv7JH6yH5r+CWuUI4/YtCQAGWS
         e5e1VHdgmzkts+90HLoWEUVHkNoYDndWNBDxjKcPWT0YwU6I4TqAdPHQYM09VhOHJSxE
         TDbw==
X-Forwarded-Encrypted: i=1; AKwUvBxQtP0Da9rkO4sZYyepRyPZ5rbq/y/9EGC9uq39rLqCIX9U93EJ/EocbW9M6itJQjDbUgL6SL4=@lists.linux.dev
X-Gm-Message-State: AFuF++nrFWlwJfSIgc90H6P3NZ8P5ym1Eu+PUqxVC2b34r7nYQispSw0
	6EK4R4EPcEJJmpTfGK9tmB+TVEO/CDPNeEz8ecTHzvogOEF8vjDHsfRG
X-Gm-Gg: AYBFou3qUZgFaYWuMfY3qjdzrkqrlJK3mb06rXknEblBwd9uiKI2vQqPcotd1Q9iVL3
	m6xJiXUnL2NU5rtfjML4ajJrNsQQBxxfqNos2/qQ1juvWaS5OWQVHHCZMR8KQp3bmc6hahNqh8a
	fhQr+8D+SGItXI0sAwXvJJlQz0UHNjrmQlvMEA7GsEXMzFEKzi7TaC4jxO7DxKC+Qo7yrM35+Bp
	jMJXyl/n5BVRvu1TLrJcFL/uPgWbDi23+qY1GOscd6FJN7D75OHbDTKVTw3ukayWkCrm49jG+aC
	hj7qNe0qdcRm5YUjjuxIMOdQpkg9DhKHJyAOnup2/fIAW2pjGX/zOpNnX7f/yVMelDTQzY9HUWI
	7wT8I9Kujmj8TLhMNi9lsf1MlbfDAJznvBAXsyKChzH/8J8n8lu50k2fP5pFBrpB1FaMO0ckkaE
	czZoSV70zwGOvPLinx+ojK7PIEqyIDpSk/7V5hBYARQWxZIDazL4NNEjxgKf9Kj+9jctk7o8qFI
	xg7yjyJ21DSal4=
X-Received: by 2002:a05:6820:60b:b0:6b7:8396:f3c2 with SMTP id 006d021491bc7-6b78396f7ecmr1517046eaf.36.1788524705780;
        Fri, 04 Sep 2026 05:25:05 -0700 (PDT)
Received: from volcano9f6e-hostos.amd.com ([165.204.217.251])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3339b8f787esm5880860eec.23.2026.09.04.05.25.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 05:25:04 -0700 (PDT)
From: Hemanth Selam <hemanth.selam@gmail.com>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>
Cc: linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Subject: [PATCH 3/3] arm64: kvm: fix repeated word 'is' in comment
Date: Fri,  4 Sep 2026 17:54:42 +0530
Message-ID: <20260904122445.31163-4-hemanth.selam@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20260904122445.31163-1-hemanth.selam@gmail.com>
References: <20260904122445.31163-1-hemanth.selam@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Drop the second 'is', reported by checkpatch.pl as a possible repeated
word.  Only touches a comment, no code changes.

Assisted-by: Cursor:claude-opus-5
Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
---
 arch/arm64/kvm/pauth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/pauth.c b/arch/arm64/kvm/pauth.c
index d5eb3ae876be..22ff4b78d0e9 100644
--- a/arch/arm64/kvm/pauth.c
+++ b/arch/arm64/kvm/pauth.c
@@ -5,7 +5,7 @@
  *
  * Primitive PAuth emulation for ERETAA/ERETAB.
  *
- * This code assumes that is is run from EL2, and that it is part of
+ * This code assumes that is run from EL2, and that it is part of
  * the emulation of ERETAx for a guest hypervisor. That's a lot of
  * baked-in assumptions and shortcuts.
  *
-- 
2.48.1

