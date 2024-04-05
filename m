Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C3A6611E
	for <kvmarm@lists.linux.dev>; Fri,  5 Apr 2024 09:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712307687; cv=none; b=ets0jWNzhvRPsLPKfroorT4knEGdH8LJFnR/stuq3BcJ6oS0ujBer0eUOxXFqdfl4suBITAa8w3pRNTzc1nw1M3r45uuw0R4YO9cO1LqIIwEf+y1AdaRfHxH5s6zzSUeF1RUsFxF+2daN/z3f6t3Mlng9P+8JqrQsVG24z8rfD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712307687; c=relaxed/simple;
	bh=JfJMxUdKZR8GL8vEZBI0bBxnPTsZ62D9OnWb7Hg3WEs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fqTUtt27aYm+YXMFtKxqDa6AmBq1WVLhQj4y0S23mNyyRg42dzp3Rwp8En/VcssC6i6SguEFVS31FZpme7Y4/DBOZzmgT2t9ZJvK3P6R/9b329zaxUOE3ZXpcK7m3IptLQX+8cQu3zd6oHCjq8MBXQgK0l3vD3IOBFfZEof5svU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RRFxppV9; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RRFxppV9"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-6e74bd85f26so1711344b3a.1
        for <kvmarm@lists.linux.dev>; Fri, 05 Apr 2024 02:01:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712307686; x=1712912486; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Uu6wGEwM6aIXMj2Zv0exGHWMPbPED90o0LJmrvuij2Q=;
        b=RRFxppV9mFP7hYC/aCW1XxNwZr8B4d9Qqzouvqv+HJXar5vD1HHZXIpnA5077f//DU
         WsXtjrOEkRnywmaJNhC9DWs9/Q3C+rPTKf6BereDz9sTIXnreFAWkYZH+YNV3TJykBE/
         BfMViRF+PHcjldynae1HHUldu7oaATpp+BMOG0Plk092zmuvNpZcUmaAc0U899z7wuRw
         3IFSI07Ovp2vBUrl5yT2+gCJnk+8Q38hfG6gwRL01LGlJ/aybHdYSZfvMXVPghctPOkF
         x4SfKbMklP4N8GoKYftLTR28qUPY7SbXmhuHs/Obg4sroBa/u3uwu8hnjseT85q6Acey
         XjaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712307686; x=1712912486;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Uu6wGEwM6aIXMj2Zv0exGHWMPbPED90o0LJmrvuij2Q=;
        b=U6wlxCggpxNTZmp0cHIlweNMbOKYbaSPeP/9X2+BuvesuxGlf1CtFGAhnrTdnR0Yvc
         R7UTb2ANCON1g/fO6ogJXMs15z7BbUNEPSG5N3bbVXvha8YyI8zGco+uSt5jQildMH2J
         htru7jDKeL/rb41YEuEzgeLfAjrkcDLP6J3UZICt+se4bJmiTQaG7+zCSo2x+ZUqTEP3
         szXRKCZK02q6qb/Jdmwhp4LBvUl14UaOJufRZuaneNz0X+Raf71miSV+4cmxnb5g1zUp
         eFtHoBruzuML85rvpCvThmzhNNy3NfdhsG8yOvguaw8yv2QN4RgKngIdua6puf3auDC7
         xxww==
X-Forwarded-Encrypted: i=1; AJvYcCWQMOipfuJSUGI0IEudEBbHskMysIvYLgt6uFEf1tMTqPoVjW18kzTyneGFffvNtZlX2JEQx4IN8QIqwNcx/9VzUlm/N6cR
X-Gm-Message-State: AOJu0Yxt4KWCZvhKpX9WhnUbZNWRVDwkCnd/GyreadpIUe589PBseFJ+
	7lxd1l1GD4PmSK71D+7ZHdAs4Fu6G9yP+OpZ8nRfEyZl0I4/c/Gj
X-Google-Smtp-Source: AGHT+IHzCPSa8orVhvE583R1aVmAhgho8AabCJP5Cs3T+kAcshecv2v+XDz4XgLOLVKXC5dMRzf0KA==
X-Received: by 2002:a05:6a20:a122:b0:1a6:f913:afdf with SMTP id q34-20020a056a20a12200b001a6f913afdfmr991282pzk.46.1712307683777;
        Fri, 05 Apr 2024 02:01:23 -0700 (PDT)
Received: from wheely.local0.net (124-169-104-130.tpgi.com.au. [124.169.104.130])
        by smtp.gmail.com with ESMTPSA id s12-20020a62e70c000000b006ecf25d0b8dsm995783pfh.184.2024.04.05.02.01.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Apr 2024 02:01:23 -0700 (PDT)
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
Subject: [kvm-unit-tests RFC PATCH 02/17] shellcheck: Fix SC2223
Date: Fri,  5 Apr 2024 19:00:34 +1000
Message-ID: <20240405090052.375599-3-npiggin@gmail.com>
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

  SC2223 (info): This default assignment may cause DoS due to globbing.
  Quote it.

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

