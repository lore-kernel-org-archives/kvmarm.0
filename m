Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B096D50A65
	for <kvmarm@lists.linux.dev>; Wed,  1 May 2024 11:30:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714563055; cv=none; b=GwUaK7plC1SoNg00KvSy9XuBsSJvfvPAH0dcJZniF36rL6iRUN9hk8rZdZeOxRH+67ealMXp1B5AVfLyw6xwJtw3g8zRgdKSnYDD8TwApVUUfG+9wM03fyVCBdTxxOuMoUQWsTV4oxKwlwE3R3PzOt2/b7LgwrASFaHYoE4IzW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714563055; c=relaxed/simple;
	bh=ZPWgrXuqWYUuAjdqFkmq3oOnUFlf/K4b5/Gpn5LRl04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jz4XbD+GS2tSBKh8P2Pumgmk8DQ585AMTLT8LV7Zgi71/KMPVFWn+tdHhFOqlrdMBXaQQZOl58FdWzuvCykHsgMmGdgl36HoeiknZN7iHAi4kzmtl6r04gPoQbaedFbydHalGrFAvPjydirJxCP5lRJmtF9ZyFeIvYJuL7PU0Vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WpQxw6XM; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WpQxw6XM"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-1e4f341330fso61639165ad.0
        for <kvmarm@lists.linux.dev>; Wed, 01 May 2024 04:30:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714563053; x=1715167853; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aYhyM+QV5csxpHLgX/7kmJ/huORg40mwGJt/SbZ3cb0=;
        b=WpQxw6XMyOwn6ueGJDOUzWGu1TcCNNYSRSnMgrA/3qMa3G1VO1oqe2ibeiSlxjxCYM
         0W/0il8yMArgN/0tGajNfVXTXVl/4SXiVFXHXFVgg7Oak+8Uoq1vKRt9wMV/zExlJqb4
         95/QWFLYBifi84HumARQYGIcQCyb8uJuW6d05MYrcsYjj78hOp7MfY9qVli9zTsJn19Z
         imp8czSsOw9R0QbdJOSMMDULHDPorygOFCnxg8coqa308SJ4tnimansDTMv9FFkensCv
         hIFyWs6ceK5xX+AzygLLHXCYPWRv+txDIuxEcZpMzv8AmY0dgiLq0mi2TpH0jOs1ncIv
         a6Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714563053; x=1715167853;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aYhyM+QV5csxpHLgX/7kmJ/huORg40mwGJt/SbZ3cb0=;
        b=cmKCpDoZTKGfMUQSmY45vEqe05exGnlBAE45EQUZ2cRLdXid1Dv/BcsURv7qop4BPA
         mpXV9DHge8VUvgWOzikjlRhgsuzzMZ6e7zX7cdJNxdo8qfZoGuQTV00PuFkJeEqElGvG
         1beig6a6XuXXxkd+dmbMK/9K5j6g7OGPDlHvIy8vht46nqeXLa7nwKsWXtHQP1+5Hwak
         EtC0gW7W2GRqEP3TX9XnSNs+zY6zce+EfePt6+Hh8rXOkt2RyRoh4pZebrcrO3cyQCos
         s0mJf9Z+p/ODEL1MnAMlfja8GnQ3BCN5BuOFF5ktkB6eMEqiDECieuOJGoUF/5DO36VZ
         T3qQ==
X-Forwarded-Encrypted: i=1; AJvYcCVCSqMbLK7LBcjmqRarVAYBQmEPid7FRIUnPhpyJSCzy4vmfc8iyRH4dCBL60RYIADlX4115h8wu7u1XVhxdSh8QqLfm6ZZ
X-Gm-Message-State: AOJu0Ywd7rqkwFL07GSMTkFa+EyMVJB09MjuTCK8dBUfjEmKd33QKBnS
	eeTtr4Os5m0COj+GRAwMhTT0nk1JsyM+ZTyHPuEnxqrYHYsrVwV5
X-Google-Smtp-Source: AGHT+IFRvIa3dx8kGf4HFdIIro2Yu2MuudVt1JrMdj5z3e4X6RY0JLVjSEleK/CrHZosrlvZp4Yc8g==
X-Received: by 2002:a17:902:bc45:b0:1e2:bc3c:bef6 with SMTP id t5-20020a170902bc4500b001e2bc3cbef6mr1904842plz.37.1714563053087;
        Wed, 01 May 2024 04:30:53 -0700 (PDT)
Received: from wheely.local0.net ([1.146.40.196])
        by smtp.gmail.com with ESMTPSA id y22-20020a17090264d600b001ec64b128dasm2267150pli.129.2024.05.01.04.30.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 May 2024 04:30:52 -0700 (PDT)
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
Subject: [kvm-unit-tests PATCH v3 5/5] shellcheck: Suppress various messages
Date: Wed,  1 May 2024 21:29:34 +1000
Message-ID: <20240501112938.931452-6-npiggin@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240501112938.931452-1-npiggin@gmail.com>
References: <20240501112938.931452-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Various info and warnings are suppressed here, where circumstances
(commented) warrant.

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 configure               |  2 ++
 run_tests.sh            |  3 +++
 scripts/arch-run.bash   | 15 +++++++++++++++
 scripts/mkstandalone.sh |  2 ++
 scripts/runtime.bash    |  2 ++
 5 files changed, 24 insertions(+)

diff --git a/configure b/configure
index 49f047cb2..e13a346d3 100755
--- a/configure
+++ b/configure
@@ -422,6 +422,8 @@ ln -sf "$asm" lib/asm
 
 # create the config
 cat <<EOF > config.mak
+# Shellcheck does not see these are used
+# shellcheck disable=SC2034
 SRCDIR=$srcdir
 PREFIX=$prefix
 HOST=$host
diff --git a/run_tests.sh b/run_tests.sh
index 938bb8edf..152323ffc 100755
--- a/run_tests.sh
+++ b/run_tests.sh
@@ -45,6 +45,9 @@ fi
 only_tests=""
 list_tests=""
 args=$(getopt -u -o ag:htj:vl -l all,group:,help,tap13,parallel:,verbose,list,probe-maxsmp -- "$@")
+# Shellcheck likes to test commands directly rather than with $? but sometimes they
+# are too long to put in the same test.
+# shellcheck disable=SC2181
 [ $? -ne 0 ] && exit 2;
 set -- $args;
 while [ $# -gt 0 ]; do
diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index 98d29b671..8643bab3b 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -44,6 +44,8 @@ run_qemu ()
 	if [ "$errors" ]; then
 		sig=$(grep 'terminating on signal' <<<"$errors")
 		if [ "$sig" ]; then
+			# This is too complex for ${var/search/replace}
+			# shellcheck disable=SC2001
 			sig=$(sed 's/.*terminating on signal \([0-9][0-9]*\).*/\1/' <<<"$sig")
 		fi
 	fi
@@ -174,9 +176,12 @@ run_migration ()
 
 	# Holding both ends of the input fifo open prevents opens from
 	# blocking and readers getting EOF when a writer closes it.
+	# These fds appear to be unused to shellcheck so quieten the warning.
 	mkfifo ${src_infifo}
 	mkfifo ${dst_infifo}
+	# shellcheck disable=SC2034
 	exec {src_infifo_fd}<>${src_infifo}
+	# shellcheck disable=SC2034
 	exec {dst_infifo_fd}<>${dst_infifo}
 
 	"${migcmdline[@]}" \
@@ -184,6 +189,9 @@ run_migration ()
 		-mon chardev=mon,mode=control \
 		< ${src_infifo} > ${src_outfifo} &
 	live_pid=$!
+	# Shellcheck complains about useless cat but it is clearer than a
+	# redirect in this case.
+	# shellcheck disable=SC2002
 	cat ${src_outfifo} | tee ${src_out} | filter_quiet_msgs &
 
 	# Start the first destination QEMU machine in advance of the test
@@ -224,6 +232,9 @@ do_migration ()
 		-mon chardev=mon,mode=control -incoming unix:${dst_incoming} \
 		< ${dst_infifo} > ${dst_outfifo} &
 	incoming_pid=$!
+	# Shellcheck complains about useless cat but it is clearer than a
+	# redirect in this case.
+	# shellcheck disable=SC2002
 	cat ${dst_outfifo} | tee ${dst_out} | filter_quiet_msgs &
 
 	# The test must prompt the user to migrate, so wait for the
@@ -467,6 +478,8 @@ env_params ()
 			[ -n "$ACCEL" ] && QEMU_ACCEL=$ACCEL
 		fi
 		QEMU_VERSION_STRING="$($qemu -h | head -1)"
+		# Shellcheck does not see QEMU_MAJOR|MINOR|MICRO are used
+		# shellcheck disable=SC2034
 		IFS='[ .]' read -r _ _ _ QEMU_MAJOR QEMU_MINOR QEMU_MICRO rest <<<"$QEMU_VERSION_STRING"
 	fi
 	env_add_params QEMU_ACCEL QEMU_VERSION_STRING QEMU_MAJOR QEMU_MINOR QEMU_MICRO
@@ -597,6 +610,8 @@ hvf_available ()
 
 set_qemu_accelerator ()
 {
+	# Shellcheck does not see ACCEL_PROPS is used
+	# shellcheck disable=SC2034
 	ACCEL_PROPS=${ACCEL#"${ACCEL%%,*}"}
 	ACCEL=${ACCEL%%,*}
 
diff --git a/scripts/mkstandalone.sh b/scripts/mkstandalone.sh
index 756647f29..2318a85f0 100755
--- a/scripts/mkstandalone.sh
+++ b/scripts/mkstandalone.sh
@@ -65,6 +65,8 @@ generate_test ()
 	fi
 
 	temp_file bin "$kernel"
+	# Don't want to expand $bin but print it as-is.
+	# shellcheck disable=SC2016
 	args[3]='$bin'
 
 	(echo "#!/usr/bin/env bash"
diff --git a/scripts/runtime.bash b/scripts/runtime.bash
index 597c90991..fb7c83a25 100644
--- a/scripts/runtime.bash
+++ b/scripts/runtime.bash
@@ -127,6 +127,8 @@ function run()
     # the check line can contain multiple files to check separated by a space
     # but each check parameter needs to be of the form <path>=<value>
     if [ "$check" ]; then
+        # There is no globbing or whitespace allowed in check parameters.
+        # shellcheck disable=SC2206
         check=($check)
         for check_param in "${check[@]}"; do
             path=${check_param%%=*}
-- 
2.43.0

