Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 557C713D265
	for <kvmarm@lists.linux.dev>; Fri,  5 Apr 2024 09:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712307694; cv=none; b=ucjWy+dwN4HBxiGyEIplzjg3DyzB9Cb7ypNA07RnubyWK13zO/LquB4JX5eV8KYZ7opGGKyUfSuOkIZ0Pq+S9SPlTe3a8jwAyRT2xrDM6z6ahwm4gnFLNcIZ9jC2hIdwg3Vl1ay2YbHQsumzhqYE1zDztBO9rfbfZL+e08yP+qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712307694; c=relaxed/simple;
	bh=iorWhAXzDkMgXS5/h1dXUFesPq+RiQ56mLvxEzBdjLQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ilk/gbr44Cph3rQ5rTEXb3NV2/pFH/q3WgAC75oLZf3YnFaBBdvRsVIx1J0A/YUhfrAZXP4+TiRE4PlZitbZdnzoFV2w2Ip0iHrqN3vwYSpUSa7HazGZ8ya9Oez/ztpScBgg53xji6hX5+WZWdxbGjMRlYSE5Oz6nbKCuv5nVvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GkI/5NgL; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GkI/5NgL"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-6ecf406551aso1129184b3a.2
        for <kvmarm@lists.linux.dev>; Fri, 05 Apr 2024 02:01:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712307692; x=1712912492; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OJFizl9fM2o773KG2KC0tcguyLSt89Cu1ul3ajDj2fU=;
        b=GkI/5NgLJKqm6hJO3zIwIHvmeHTPqNNIh873LXrvfcSCsPbJQqXlm/kTBT6OuRZlIN
         zxPOKcYPOgW2EbUvd9WsjAa50FLzJzz9+g0nx4ZjJx8I/cFz3/korgZ+EHkiarc1Cxsh
         z7A0lrxizAvJAqCAm3oTDdq3qHocZUXlIGZz0qSe+7uXsOLhlxfVjritO7gm8GLTjo8k
         Wx9oo8sW8pVGbbm747V0RvHdqF0buAhzN01visnImu9kiXUPY7PYz41EMDUX9OnvsoiD
         RllQbao7FAzt0FdZ1vlfOZc+Akt09itV39MbGbg0Hb7Lt9zrOVZqT/pP41mcni18JakZ
         VauQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712307692; x=1712912492;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OJFizl9fM2o773KG2KC0tcguyLSt89Cu1ul3ajDj2fU=;
        b=FP8Q5k/ggzskI7yG2m/gku3fR1KamrrNupaLAfiTszrL4L5OIj4xL7V9BksbFXX7zS
         GPk6JiHRfSNpQhdQNK0b+IaWbkejBoBBx+Ns59jsS/qFVddsCXC00Ocfnw/eGw1p5VN4
         cVE0Jivo3a4SE53bfumY7Y/Yf+IKWYN2qeIWWfEkUcNofbXL6KotDwT92sRVNSDv8aMF
         OJqCaKQLxWqIUkj8FCDh5UjhWuwe/Py3hXq9GqZS+zPBvH6ChhR8uBy7x+JwCqQ9s3G2
         OdlNPoysq87hO6YJeiPgB+zUqSWTVJFCi0KwPzxwvAxu1401rdkqV3uwQHQ800SKqJ0o
         65IQ==
X-Forwarded-Encrypted: i=1; AJvYcCWbyKNmVB3nvQHU1l+h46LRImAztQdYxKFX8wuYodnn+gM37Pd4sCD0A9/usWOSZbzqBOUBBqEwL9sUOKHptM6+L+61w/i4
X-Gm-Message-State: AOJu0YxWAgeon/0oYz3iIt6NleZTxpNoSD1Bcys7sBNlYQcqgiP22Mnh
	FFskSRuABsAF/NQoSBiC4PTbZZcAgGi7qYw01ULlUX7QVWE84J6r
X-Google-Smtp-Source: AGHT+IFwBaywWHmRGfwbcmA9HRMJtA9TMzs93GW1jGz92SN7GfW4oW/+SF2bpNq91FjZDkLQnrluFw==
X-Received: by 2002:a05:6a21:9996:b0:1a3:55d2:1489 with SMTP id ve22-20020a056a21999600b001a355d21489mr1063196pzb.7.1712307692560;
        Fri, 05 Apr 2024 02:01:32 -0700 (PDT)
Received: from wheely.local0.net (124-169-104-130.tpgi.com.au. [124.169.104.130])
        by smtp.gmail.com with ESMTPSA id s12-20020a62e70c000000b006ecf25d0b8dsm995783pfh.184.2024.04.05.02.01.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Apr 2024 02:01:32 -0700 (PDT)
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
	Nadav Amit <namit@vmware.com>,
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
Subject: [kvm-unit-tests RFC PATCH 03/17] shellcheck: Fix SC2295
Date: Fri,  5 Apr 2024 19:00:35 +1000
Message-ID: <20240405090052.375599-4-npiggin@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240405090052.375599-1-npiggin@gmail.com>
References: <20240405090052.375599-1-npiggin@gmail.com>
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

