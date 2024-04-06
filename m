Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C14452869B
	for <kvmarm@lists.linux.dev>; Sat,  6 Apr 2024 12:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712407151; cv=none; b=f5FkZ8+BYTkvDoH3wAtHo4sza6ewRr7c6ruKgMPOmOTmRNmGxut/vbsIHCjVC42+KGftKFubCKjDRtAaiZXrW+CWX5sf43i71qYyGcC+74X3stVztfuxY1cstBZkhOD+98FwH2YoSRWGf+V4F/gwFZMlgEm3zkw5MsiW8Sds29k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712407151; c=relaxed/simple;
	bh=ynVkD9kpyp73EWy70emPQEfa+B2E+GzlRMJPQM8F8zw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FK3I9J9RKCjlc0h9kqm/pKBDmcXcGctYb7UQodc2baHFfroeb3hbSpSWlo9jTSzdLKHm9uqy/WNvEoCYrDOazSggFRExLtCO34S06F59HVjfdF9ak722SWJ2ZiTdvDGjFzFUEvyjYyfjBWI4+Mh90ZP82nD21FwSBlJtRcyMh58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aeqWbouN; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aeqWbouN"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-2a485169476so816816a91.1
        for <kvmarm@lists.linux.dev>; Sat, 06 Apr 2024 05:39:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712407149; x=1713011949; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n6Ak2eXV9+uxmKDVMVAvdf5h+W+GwHpU0A4GvgnXZ/Y=;
        b=aeqWbouNBMFVD85f+Suj05W2UK/FefdJ19Cs2Z+vAZi1Ek/PGTtyu/T7si+dWyMNtx
         8/7g2bhpVSiaOjTj2mMX9xX9pOx53NFhKgorydc7iWC/6WS+YytshGlgVmNSvPW9FYHy
         blrCcdzJSEZEpMnH7BByoI8qjlHIdHtUrTfpqVLnghXgyvug/6n35T0ADR10kqocgqao
         Hz6OybuW+UYYQqpUYps+CXnz1JWpdopNv78Q5nGKlybu2UWkL0TrnANVyqLsrnE0oa3Q
         nczeYIGfKU3vM/CRxWUMdVvT0saq4qgfpKnVzV4eOSCkUpwQwM1cJwBFrbohXJXISeeS
         YiPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712407149; x=1713011949;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=n6Ak2eXV9+uxmKDVMVAvdf5h+W+GwHpU0A4GvgnXZ/Y=;
        b=cC76morB3Ym+jRLeMl8JBZa89g4AC/cCQR0OQBzhNV0MsDKJmFsFk7thRrPjyR8znf
         80kSdkFxQP1bMBuwNAKKXzeJ2fkLmQdRW0Q/tKdpuN02oQLx6gLQGRgW6Skiyjn6hhSD
         ry98rQpnFbAhXdVe/4kmTe04T5tl7282QFzZmBPxiWWQGE8dNL+pzHULONd1xR8+rd7E
         MMc4dFBVqGkpJ26YDZb9zG8uufp5uB+59dW3vYsJcIq2HgsqgkRQxtowGUpS4Lw9EUCS
         hZfQrIU0L+4Loq9uy56ATccstWXdKpCOmhxQR1VJ5shUZGkNUlZxElEp85Gfqis8x/ow
         hhHg==
X-Forwarded-Encrypted: i=1; AJvYcCVvoxugUeQxFZ7OKWj9J0Y9JbMX74Rx27czt+3tI6rX9F5sKQjHmMtsZjRzqDwGqHOnJzN16Qt5nIIntKrge0TR9q1Iq8Lf
X-Gm-Message-State: AOJu0YxFwEugpURvlCa+tjXZBs3kwZK6UvOXcvKtVLgEOsEgBaIFFRVZ
	u8/GynRZD710DcrpEpwVb+d8f+oHR8PKvThpMuvB/OtMxHbqhD9n
X-Google-Smtp-Source: AGHT+IEYhDuK2nSdoxNUh6rlvyThWG0NnDzHTSnNytiX2YBBGS47j7JwgJow8VWW5Xms5PawMFdZFg==
X-Received: by 2002:a17:90a:f413:b0:2a2:8250:b5d5 with SMTP id ch19-20020a17090af41300b002a28250b5d5mr3527170pjb.18.1712407149116;
        Sat, 06 Apr 2024 05:39:09 -0700 (PDT)
Received: from wheely.local0.net (124-169-104-130.tpgi.com.au. [124.169.104.130])
        by smtp.gmail.com with ESMTPSA id nt5-20020a17090b248500b002a279a86e7asm5050576pjb.7.2024.04.06.05.39.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Apr 2024 05:39:08 -0700 (PDT)
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
Subject: [RFC kvm-unit-tests PATCH v2 02/14] shellcheck: Fix SC2223
Date: Sat,  6 Apr 2024 22:38:11 +1000
Message-ID: <20240406123833.406488-3-npiggin@gmail.com>
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

  SC2223 (info): This default assignment may cause DoS due to globbing.
  Quote it.

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 run_tests.sh         | 4 ++--
 scripts/runtime.bash | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/run_tests.sh b/run_tests.sh
index bb3024ff9..9067e529e 100755
--- a/run_tests.sh
+++ b/run_tests.sh
@@ -158,8 +158,8 @@ function run_task()
 	fi
 }
 
-: ${unittest_log_dir:=logs}
-: ${unittest_run_queues:=1}
+: "${unittest_log_dir:=logs}"
+: "${unittest_run_queues:=1}"
 config=$TEST_DIR/unittests.cfg
 
 print_testname()
diff --git a/scripts/runtime.bash b/scripts/runtime.bash
index e4ad1962f..2d7ff5baa 100644
--- a/scripts/runtime.bash
+++ b/scripts/runtime.bash
@@ -1,6 +1,6 @@
 : "${RUNTIME_arch_run?}"
-: ${MAX_SMP:=$(getconf _NPROCESSORS_ONLN)}
-: ${TIMEOUT:=90s}
+: "${MAX_SMP:=$(getconf _NPROCESSORS_ONLN)}"
+: "${TIMEOUT:=90s}"
 
 PASS() { echo -ne "\e[32mPASS\e[0m"; }
 SKIP() { echo -ne "\e[33mSKIP\e[0m"; }
-- 
2.43.0

