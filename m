Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF6EB2869B
	for <kvmarm@lists.linux.dev>; Sat,  6 Apr 2024 12:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712407160; cv=none; b=NzVAEd8tVObMF+Ln7nXc8u5cWSAo2pEMx6xNcEq826JkfXiLWETCnnxsdkiF3jmQCPLe2NrHiZPEoT+i0i2Bm1LUs8ox/B7qKUovn6qFpUTrDkYy1LrUenHE9JCRBIstsWKX9FROdbSq0Iw66gpxnRKhzeICAsvwC9d6qmvxovY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712407160; c=relaxed/simple;
	bh=9OMbAsnU+2GHeCnIyNL2D/RSvQn0Or13ZlM7FSCcym8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IlG9nj+TgdOiVq3yG3nuTBZ0QN+IgyJ/ABNc4qBqzh/y7qtuPDxDl6PTWYq7mrskL1OAyDIAzDnXqFXox6FPoqqlI+3eXvkOm0fbwe0pnLmqYpPEsKQOleIGU2kWoZOu+TyUaDNWf9QUTuy+jKw60ssBlY49O84q/pmncFGyI0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=f3mcjMgP; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f3mcjMgP"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-6eced6fd98aso2521040b3a.0
        for <kvmarm@lists.linux.dev>; Sat, 06 Apr 2024 05:39:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712407158; x=1713011958; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4JXiqEZUiNUnXuxmqi+ca5TsUVImKZg5r/shld6kwl0=;
        b=f3mcjMgPzyXxdS8kWt6aLMyoxrxjHzqTGCA9T5OhrXC5YhVi6cBk6IzGiEMQRrfdtP
         QhhLImVK5ag30mLPEBIl48TmYJKq4dgewk/LWRH/RYOQUtx4FexPfFAOcvmv4k1pi8dG
         4DBQIazkyr02xOa8PC5LRzQmtMSH1RyzgWIvLYm7cT+zKCezo2jtR6jpa1wWhq8y4xYB
         xU6zdUfi5t9qPVjR23mbX6vgJF6IT6VWYWNe6oP8JPFLdqzgbhajODkSZU3Xd26l4kl7
         F+8toKVXFRy4kso7rJXV40k0UfMScZ8l/b5UgtQBT1xi9Yfqpkqj8gde+KyXfbFahrQA
         JGNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712407158; x=1713011958;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4JXiqEZUiNUnXuxmqi+ca5TsUVImKZg5r/shld6kwl0=;
        b=HFstCSJcRDtrat2sagwUIkxA+nI4XVYpEBQ7Pvyu/o9MrBf9vFUHiBHeaMZhVGk82/
         6ZdCwfZpUwbtbHUW2WB/KO0l31YZMEgw0VjdyeDiAspYkaN5LJdMyOmZq+NMfYjL7t3k
         omAVM9G+JdcntIBvuvkWmU5RoExbnLatA/M7XWrHTj+uw6EscHjOA46qVPvOf7a5mtGn
         AR3yC7oM54Vlgl0TI1zl4iF7KTRpT+N8kAXLT9iGV0CcQiELjxCFbmK/zj1LvOIzuSbT
         zImt2aVJ43RwjddNm8yciWC4omkU82+xHIsxgFSe9LN3L9A4QVAHWdGZ7SN5VzOEgXyw
         EWNQ==
X-Forwarded-Encrypted: i=1; AJvYcCXBLGZh4aslyMaIVBwOIOTEY9OvqLww0bOecECXHs1nBuECQ0ekNc5KIn5F0DkDOS1WSx+OURhvul8ZL+xiKTdbCVfdWieJ
X-Gm-Message-State: AOJu0YwnNTxoZNPTRgKaf0YDnm3q/GuNNTqxOTkKmI+TbAq/eBHO1MYl
	B3eUrANqZiNfj/O1l1X5Zr9f/87Ed0D61YsSMPWIUsgkarpFusb9
X-Google-Smtp-Source: AGHT+IG333LDkbX9VhVWof9DtloUszYhWmLouAuBT0iCtpIluUHJkcW3r50xGy82vnO7oaHc8GPVug==
X-Received: by 2002:a05:6a21:7889:b0:1a7:5509:a603 with SMTP id bf9-20020a056a21788900b001a75509a603mr591062pzc.27.1712407158090;
        Sat, 06 Apr 2024 05:39:18 -0700 (PDT)
Received: from wheely.local0.net (124-169-104-130.tpgi.com.au. [124.169.104.130])
        by smtp.gmail.com with ESMTPSA id nt5-20020a17090b248500b002a279a86e7asm5050576pjb.7.2024.04.06.05.39.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Apr 2024 05:39:17 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Andrew Jones <andrew.jones@linux.dev>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Eric Auger <eric.auger@redhat.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	=?UTF-8?q?Nico=20B=C3=B6hr?= <nrb@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Shaoqin Huang <shahuang@redhat.com>,
	Nikos Nikoleris <nikos.nikoleris@arm.com>,
	David Woodhouse <dwmw@amazon.co.uk>,
	Ricardo Koller <ricarkol@google.com>,
	rminmin <renmm6@chinaunicom.cn>,
	Gavin Shan <gshan@redhat.com>,
	Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
	Sean Christopherson <seanjc@google.com>,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	kvm-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org
Subject: [RFC kvm-unit-tests PATCH v2 03/14] shellcheck: Fix SC2295
Date: Sat,  6 Apr 2024 22:38:12 +1000
Message-ID: <20240406123833.406488-4-npiggin@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240406123833.406488-1-npiggin@gmail.com>
References: <20240406123833.406488-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

  SC2295 (info): Expansions inside ${..} need to be quoted separately,
  otherwise they match as patterns.

Doesn't appear to be a bug since the match string does not include
patterns.

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 run_tests.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/run_tests.sh b/run_tests.sh
index 9067e529e..116188e92 100755
--- a/run_tests.sh
+++ b/run_tests.sh
@@ -99,7 +99,7 @@ else
         local testname="$1"
         CR=$'\r'
         while read -r line; do
-            line="${line%$CR}"
+            line="${line%"$CR"}"
             case "${line:0:4}" in
                 PASS)
                     echo "ok TEST_NUMBER - ${testname}: ${line#??????}" >&3
-- 
2.43.0

