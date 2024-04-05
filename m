Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 645E9611E
	for <kvmarm@lists.linux.dev>; Fri,  5 Apr 2024 09:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712307720; cv=none; b=TyCEDHAfZb8LgKUjwoO8xf33H8h487KYAHY06DOD8Dw0yKaZxEc5h34Q+bIuCa/SA30oeQjTmBLZwt9RBSBu5B+bK4BrJCviFpQcsDiR2E+b/TdjHVEZdWLQkWIf8luqdFZOAOc0nLefd7ndTGPSyZDT+OkYXmns39HNmORItR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712307720; c=relaxed/simple;
	bh=cgOlMFOLTOAhPaG8TMTBDw1poLawKTTj8nPBJ3XWL8A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CU/Mpz7n3LLAQM+wGv/F8+4ResbgVZB+8TAY/rETT0Qqxcy1VWb2+mSTY4+aZSJGyJphceKdkvELs7OlkKhNyDPVjR+8SJUE/sg2WpAfIYWsXRzllQ/wqC2vaFbT0V8Icpc5pjK+pLeJ5oRLUdORS1cdOOcH2zCVmBBK0wEwqag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ACgomZ8P; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ACgomZ8P"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-6ecf3f001c5so1250368b3a.1
        for <kvmarm@lists.linux.dev>; Fri, 05 Apr 2024 02:01:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712307719; x=1712912519; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xvXYLc0uu+LcIsnEe4bo5tAncaXv58vUX5rvt7kRU2I=;
        b=ACgomZ8PESr3myg904Uce76SgLCvEFIpADVckWSsBSususUOghuz/PF4vH7uRg23aE
         mGHRVYGvMV4oVcQJjzr68a4gKr82xtEzwHJnMbO2nSKtC6gyivFRyqBwIstCedABllcn
         v9aMBVJk52FOi0XRoMKYcyMmvF1wwR4ZDeT64BhA7stzY2di7dJy1ZQ5bKkkwgQ5wcj8
         PwRsLQZJ1J/bOWpR35M/LDIYSL7//Nwv8aFW/r86Kdc+C3qdEBqpmxoZmI9ydOPQdxHR
         LmTWECCWB7Nu8u2z+BoBCkTMaMiOg3BWG/hgI4ueMcRNnaY3sCzmFtivRwZoD2i4W4c6
         Uj4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712307719; x=1712912519;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xvXYLc0uu+LcIsnEe4bo5tAncaXv58vUX5rvt7kRU2I=;
        b=VuKDJJSGKdPLufMXNIBZlDI7ouaKeNmi8ZsKbPeCwyxLr9bcrVRTBC7VKk1UjMTZRD
         7ZItvwJsqMkGQ1JYK08ozZJ9ArQVcyzThwsVMOMduJ5zQQQ2wbMYFbS/jLTuob0iC2F7
         E/xDxXtcNUexyZZMNTowVDDrzyaEt5c/p0gZ4VAbdexJBpVYWCUkeQlFnG904WCG5mZf
         KBKBcZA6WYrowTHOO26WV6ykDzGw7JWeatqL+f3WG4FCvIYDC9TlSq/ctLnlXFNIAg5b
         77/IFxrqPdP3Bl8dR4lOrRB6uehn1DpTPHeSAcKLwZnWWE4Ujyyp1OUdFmCvu9qbACvU
         T8aQ==
X-Forwarded-Encrypted: i=1; AJvYcCXeaBi9zdW+8CB0mHXpmCOG7Nl6j3hPxbVw3uuxo84x4OFTLhB20Jp0RMGBljGeNa1VUHA2TPOFfVvfsORhO7M+JpUFvJtu
X-Gm-Message-State: AOJu0YyF9BvnwT0nphtZ8Zf//x71xPftkwHBkDWJkqpxok8OpJaBBD/b
	ad5VgmdVrreP5JL6RbLS3kymQ0rZpM7bKt8e9DDtHWLbNSM7FJVF
X-Google-Smtp-Source: AGHT+IFj7I4WRf6mG1Ngr9iOIJklIrAymGwlwsRpKSgckGok7UED5Jz/iGyna+dzLfvclH/dWdFZdw==
X-Received: by 2002:a05:6a00:9296:b0:6ec:ceb4:49b8 with SMTP id jw22-20020a056a00929600b006ecceb449b8mr1142659pfb.0.1712307718798;
        Fri, 05 Apr 2024 02:01:58 -0700 (PDT)
Received: from wheely.local0.net (124-169-104-130.tpgi.com.au. [124.169.104.130])
        by smtp.gmail.com with ESMTPSA id s12-20020a62e70c000000b006ecf25d0b8dsm995783pfh.184.2024.04.05.02.01.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Apr 2024 02:01:58 -0700 (PDT)
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
Subject: [kvm-unit-tests RFC PATCH 06/17] shellcheck: Fix SC2155
Date: Fri,  5 Apr 2024 19:00:38 +1000
Message-ID: <20240405090052.375599-7-npiggin@gmail.com>
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

  SC2155 (warning): Declare and assign separately to avoid masking
  return values.

No bug identified.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 scripts/arch-run.bash | 10 +++++++---
 scripts/runtime.bash  |  4 +++-
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index f9d1fade9..ae4b06679 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -411,7 +411,8 @@ initrd_cleanup ()
 {
 	rm -f $KVM_UNIT_TESTS_ENV
 	if [ "$KVM_UNIT_TESTS_ENV_OLD" ]; then
-		export KVM_UNIT_TESTS_ENV="$KVM_UNIT_TESTS_ENV_OLD"
+		export KVM_UNIT_TESTS_ENV
+		KVM_UNIT_TESTS_ENV="$KVM_UNIT_TESTS_ENV_OLD"
 	else
 		unset KVM_UNIT_TESTS_ENV
 	fi
@@ -423,7 +424,8 @@ initrd_create ()
 	if [ "$ENVIRON_DEFAULT" = "yes" ]; then
 		trap_exit_push 'initrd_cleanup'
 		[ -f "$KVM_UNIT_TESTS_ENV" ] && export KVM_UNIT_TESTS_ENV_OLD="$KVM_UNIT_TESTS_ENV"
-		export KVM_UNIT_TESTS_ENV=$(mktemp)
+		export KVM_UNIT_TESTS_ENV
+		KVM_UNIT_TESTS_ENV=$(mktemp)
 		env_params
 		env_file
 		env_errata || return $?
@@ -566,7 +568,9 @@ env_generate_errata ()
 
 trap_exit_push ()
 {
-	local old_exit=$(trap -p EXIT | sed "s/^[^']*'//;s/'[^']*$//")
+	local old_exit
+
+	old_exit=$(trap -p EXIT | sed "s/^[^']*'//;s/'[^']*$//")
 	trap -- "$1; $old_exit" EXIT
 }
 
diff --git a/scripts/runtime.bash b/scripts/runtime.bash
index f79c4e281..3b76aec9e 100644
--- a/scripts/runtime.bash
+++ b/scripts/runtime.bash
@@ -15,7 +15,9 @@ extract_summary()
 # We assume that QEMU is going to work if it tried to load the kernel
 premature_failure()
 {
-    local log="$(eval "$(get_cmdline _NO_FILE_4Uhere_)" 2>&1)"
+    local log
+
+    log="$(eval "$(get_cmdline _NO_FILE_4Uhere_)" 2>&1)"
 
     echo "$log" | grep "_NO_FILE_4Uhere_" |
         grep -q -e "[Cc]ould not \(load\|open\) kernel" \
-- 
2.43.0

