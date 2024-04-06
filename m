Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57B334C84
	for <kvmarm@lists.linux.dev>; Sat,  6 Apr 2024 12:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712407256; cv=none; b=F7XwzACxXPWzsYRazZAZS0pqjw82rCq0YUuOElWYRe2S9YD4PhJOAczGDh6xUEenlQSsl61hu3e7jyAkd0gbnrpGT7+0UMJwFN++CvVz3SzQiEKIIldI5hLhCE44O3OXpaOEdsmBQOYzhWwdqCvNaTjxpV8n1YuWbNoN0lgGVmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712407256; c=relaxed/simple;
	bh=jEImH+rp2QfqaInI9V+ckUXsXCCEKUKIWMgodp+ePuQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cThqVepC7R21qIU4CI3njhOpzA/REYakPgeICvTrflCkSrWX3J54U7VNn5foaY37x023u7kO4G0p5UkcQFITcifspsl9DvKlwB8SKadnHHYe5R80tqXZLzU7wqpQOn1W1qEWR43S09E32JEuYVXUfLwSbuDcB6xbf7oKir/Dd0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Z0nCUNK5; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z0nCUNK5"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-2a485169476so817505a91.1
        for <kvmarm@lists.linux.dev>; Sat, 06 Apr 2024 05:40:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712407255; x=1713012055; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TKbzy8znHr26CvO7hMQVAmzLED6LumWRP6wamBTxOWo=;
        b=Z0nCUNK5+V3ARPO8ysJv5hereKqo1IeA3A7QgheZu1fpzuo6COrQdEPJdsIyqM9dtt
         tXZq4xvPI895ADkOQDfWxp5R8B31bvkpW/kYNb6wGmUD4JWK7jr2xjmIwbS8msQ86bvV
         /SJNfuMZ/RFSMJJeSZ8+jZbz7z7hsc0yjNKmZ8eo3ut168cjUeJBaJXkS9NYt1g8c8/j
         Gp4eZpcN8F+MayV0n/36rNe0c3BYTlsOG3xGNUQqDeVhB1OqFfelGHnLE9zhhlmkbQOf
         y1aWvvyItldixDRJQcFVY5gpM4hynJk3gO4+u2Zhm80PH88/b01VZ/KJ080sYO98byEt
         1TOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712407255; x=1713012055;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TKbzy8znHr26CvO7hMQVAmzLED6LumWRP6wamBTxOWo=;
        b=ELqzqyyI/ictLMucEDCF1yQMAT/uLtC35SqQP2YKYIP6nTqAxwhKW5fdOfNyR+6pjy
         r10lMBn2o37U7KpY3YKB8LwDXE/f0yJ+v2iJSf77Oac/GFiyA8Vgva/3C4NY0q5l/C7O
         Xzj33gpVM4Lu9z4kdA16jYvZrcxOCSfzpwkc5OiOyDCt0PmRbFKxDkdHLx/NBiAir9Di
         uLWSCDAb0c1QaAO4y0KQ85ayLxB+Dhct6jub3WDxWwl8NGizgyREfrP8uOIkuBJxMN3t
         i//sKdAokPC0ful5mnNtGxhhxj/Id5TAVqrDZ0norN2tPtVT81qXaKKosiILGYLJBtc2
         PBEg==
X-Forwarded-Encrypted: i=1; AJvYcCUkZUvfLi/+LvF5/hEV0CNcbWxs9u+9FWYAzwFLEDaUkp7hT0EClQ3XY7W2qo0O48r7yj+pX20xA5QFJjDCFA5kLgmuD02K
X-Gm-Message-State: AOJu0Yy4NqbGOyIiDnvWQRBhuV2WOzvUlPNkvRi3z7eFpH17mtsz6HnG
	l1XY9Tt5OCQvADRVGO197pG2VYG6gwgluPLirapmxUi/hFUwJbIy
X-Google-Smtp-Source: AGHT+IGH923lILkg6k1D5LY3F7XHuUJem0umJ9lfWz87O3KBdX4fIyH0Pvbo4QqzZ+EqQUgQggrzMQ==
X-Received: by 2002:a17:90b:118e:b0:29b:b6eb:3c0d with SMTP id gk14-20020a17090b118e00b0029bb6eb3c0dmr3754945pjb.36.1712407254690;
        Sat, 06 Apr 2024 05:40:54 -0700 (PDT)
Received: from wheely.local0.net (124-169-104-130.tpgi.com.au. [124.169.104.130])
        by smtp.gmail.com with ESMTPSA id nt5-20020a17090b248500b002a279a86e7asm5050576pjb.7.2024.04.06.05.40.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Apr 2024 05:40:54 -0700 (PDT)
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
Subject: [RFC kvm-unit-tests PATCH v2 14/14] shellcheck: Suppress various messages
Date: Sat,  6 Apr 2024 22:38:23 +1000
Message-ID: <20240406123833.406488-15-npiggin@gmail.com>
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

Various info and warnings are suppressed here, where circumstances
(commented) warrant.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 configure               |  2 ++
 run_tests.sh            |  3 +++
 scripts/arch-run.bash   | 15 +++++++++++++++
 scripts/mkstandalone.sh |  2 ++
 scripts/runtime.bash    |  2 ++
 5 files changed, 24 insertions(+)

diff --git a/configure b/configure
index 8508396af..6ebac7e0a 100755
--- a/configure
+++ b/configure
@@ -437,6 +437,8 @@ ln -sf "$asm" lib/asm
 
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
index 98d29b671..7e5b2bdf1 100644
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
+		# SC does not seee QEMU_MAJOR|MINOR|MICRO are used
+		# shellcheck disable=SC2034
 		IFS='[ .]' read -r _ _ _ QEMU_MAJOR QEMU_MINOR QEMU_MICRO rest <<<"$QEMU_VERSION_STRING"
 	fi
 	env_add_params QEMU_ACCEL QEMU_VERSION_STRING QEMU_MAJOR QEMU_MINOR QEMU_MICRO
@@ -597,6 +610,8 @@ hvf_available ()
 
 set_qemu_accelerator ()
 {
+	# Shellcheck does not seee ACCEL_PROPS is used
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
index 3b76aec9e..6e712214d 100644
--- a/scripts/runtime.bash
+++ b/scripts/runtime.bash
@@ -137,6 +137,8 @@ function run()
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

