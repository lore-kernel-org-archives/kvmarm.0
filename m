Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11AA51803D
	for <kvmarm@lists.linux.dev>; Fri,  2 Feb 2024 06:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706857126; cv=none; b=roGkD62irvB6OJR1I6az94tSZGMGO2TOKavf3hHPvc3AkQGbiHr+q3JImF7D8AYjixrv0pnUwKMur8o2xO1dfjAZhgEDhIQQrGPCrdycN4RL4yGQ7J/L9vhOpPiOpFi9NpOykP5x9/siOVh60Tex539btxfGVi/gpoIBeEUzHr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706857126; c=relaxed/simple;
	bh=qf+Z507zWm1DYmhr84DySroy53fHkmOS7q7f629dhLo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JXopRguK9VGvt7pEYXApHVe604o0dsVq04GgZHcBREoRi0eg2u6yrC1KoGNHIyAGqze/xq8OQjSJ+S5TRs2tRfp5splGbHkGExoLXbGWbzXhdjCGlelLgnXLFEk8oCghaIPsZdAXPHK/VAFuUxZDhN0L8swsa02/OGVRtmhX1Sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jyz+/Nq+; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jyz+/Nq+"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-1d73066880eso15400105ad.3
        for <kvmarm@lists.linux.dev>; Thu, 01 Feb 2024 22:58:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706857124; x=1707461924; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CEmc8hWH0N3MbdgZGlp8+ITWi7wqdjs4A+FtzR//oQE=;
        b=jyz+/Nq+rCtEIXbNWSRD4FYkbevmhmCY7dkdN6ixQUISKb5N7MCfduZYDN4lsZzVpv
         x6HTms0GqxLqQr0bQeZJV+jVPh7vsfF8pBKSn11824cRocSZDNVHF/EIavlyk3i8UHaw
         8N0LMCnoqr1RbHeEPYhj+wpoHWRTDivWu4uRYe81hUXm3ik3Zpr4u8MtsWfqrYm5Ru3R
         UA54oqKjpConRIXn2ztxeCY0iOCZKOuY75DmNSd355da0KzvAhu79Fo/WFE7yaZaN3UF
         t9jpt2FlXCRWLBHUXQ3LjK+9/PpV+QmWQHf2qI1v5Ydf/t6gJGxK+7tH2BQcWDXVOcyZ
         UNMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706857124; x=1707461924;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CEmc8hWH0N3MbdgZGlp8+ITWi7wqdjs4A+FtzR//oQE=;
        b=m94CK0dRKd+QUuXqVAmbgCz8G1b7YpdEppPx6CKgzM4wXGTZz+F9DnFOyT6DUOLMpv
         MXqBlllqfDt8xLYY7SFAC88ykUjK2gT71RhuurAgDpXiW7u5ViI7mPW5felq48XUbZNI
         Hg5LNHcn2CB3iUeOKaaxrHGLi+inzh6NkGvPO4Aqsg/MwngyNTzR85sNckcp5setfW0/
         j6cavVyNMnuKjShfuaydMJ+eKAaJcU18zAwjgEyKpTh46r+bjs89SpfUJtIR3Lnq1KD/
         rlkIMWU6teCkVoXKp10TMqHJgOPLlirRvDgHBlJQTnzTPMYjxSQ1JEWMg8Q5+1O8/Ild
         E9wQ==
X-Gm-Message-State: AOJu0Yy87VpQFAVZdOGEV9Q+jUXS/EtARfdMQZFguka8aDeUUqEcUlgT
	2A8jmOdOF/FKE3lMB2auhb73Y4UEffJ3E8TgIzhSKk1w28TuDyLW
X-Google-Smtp-Source: AGHT+IEKYSABCOjkDGMGdflmfxV2qc3jRIH3QBD7Yhpq7BkGGiFXaxmnSnvXekXjilfsnWCWCzgQEw==
X-Received: by 2002:a17:902:ee44:b0:1d9:711b:2698 with SMTP id 4-20020a170902ee4400b001d9711b2698mr803903plo.11.1706857124309;
        Thu, 01 Feb 2024 22:58:44 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCVGs40QBZIB/PfkkQGjhB9nNwbC6szViKBKZbD4ssk5eDDBBXi3L3W4/xnS+CNzjZjseBDW6soqOFMTzUp7VUdlpLWOvvbqW0ZFKRdKAlITp0zIzzXEvie/kSq/k6NkaBf6OdKxreuobIT8w8amTZSCylrDZGsgpRAWKCv71MuBaILpYLuGNeYdwkdOxsXiYxfVtPa8bI5CAYATcitzsm3j/RHzXjMf4iji5mNgAR5szw/iLTWEEcWbap/JJliBi3QrUH7tvtUbTbs3RFX4LodEpXF6ygmvVoaQoCqNkwGQnB0363KLrjutPDGK40bX7dAAlpTNKgGjtCfvquUCTFm68Z2xoH1j7VP1PHDltFnZHpxTBM83/CC7WOknxgF/MyMQcXhQhV1+YxbZHTKlK7gAQ4FDgtA3IYk3wawkOvOwVNj3azwgzD7w3xun3mqkX0Y7T5/3Of98pM32Q7DbHnzvqnVrejo0j6//MVmoXE/iL1MIJK2aVoMuqo4uYSLbi9+sosQGzqLwFGo=
Received: from wheely.local0.net ([1.146.53.155])
        by smtp.gmail.com with ESMTPSA id d18-20020a170903209200b001d948adc19fsm905734plc.46.2024.02.01.22.58.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Feb 2024 22:58:43 -0800 (PST)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	kvm@vger.kernel.org,
	Laurent Vivier <lvivier@redhat.com>,
	"Shaoqin Huang" <shahuang@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Nico Boehr <nrb@linux.ibm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Eric Auger <eric.auger@redhat.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Marc Hartmayer <mhartmay@linux.ibm.com>,
	linuxppc-dev@lists.ozlabs.org,
	linux-s390@vger.kernel.org,
	kvmarm@lists.linux.dev
Subject: [kvm-unit-tests PATCH v2 5/9] migration: Support multiple migrations
Date: Fri,  2 Feb 2024 16:57:36 +1000
Message-ID: <20240202065740.68643-6-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240202065740.68643-1-npiggin@gmail.com>
References: <20240202065740.68643-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Support multiple migrations by flipping dest file/socket variables to
source after the migration is complete, ready to start again. A new
destination is created if the test outputs the migrate line again.
Test cases may now switch to calling migrate() one or more times.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 lib/migrate.c         |  8 ++--
 lib/migrate.h         |  1 +
 scripts/arch-run.bash | 93 +++++++++++++++++++++++++++++++++++++------
 3 files changed, 85 insertions(+), 17 deletions(-)

diff --git a/lib/migrate.c b/lib/migrate.c
index 527e63ae..b7721659 100644
--- a/lib/migrate.c
+++ b/lib/migrate.c
@@ -8,8 +8,10 @@
 #include <libcflat.h>
 #include "migrate.h"
 
-/* static for now since we only support migrating exactly once per test. */
-static void migrate(void)
+/*
+ * Initiate migration and wait for it to complete.
+ */
+void migrate(void)
 {
 	puts("Now migrate the VM, then press a key to continue...\n");
 	(void)getchar();
@@ -19,8 +21,6 @@ static void migrate(void)
 /*
  * Initiate migration and wait for it to complete.
  * If this function is called more than once, it is a no-op.
- * Since migrate_cmd can only migrate exactly once this function can
- * simplify the control flow, especially when skipping tests.
  */
 void migrate_once(void)
 {
diff --git a/lib/migrate.h b/lib/migrate.h
index 3c94e6af..2af06a72 100644
--- a/lib/migrate.h
+++ b/lib/migrate.h
@@ -6,4 +6,5 @@
  * Author: Nico Boehr <nrb@linux.ibm.com>
  */
 
+void migrate(void);
 void migrate_once(void);
diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index 8fbfc50c..1ea0f8bc 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -132,29 +132,76 @@ run_migration ()
 	migsock=$(mktemp -u -t mig-helper-socket.XXXXXXXXXX)
 	migout1=$(mktemp -t mig-helper-stdout1.XXXXXXXXXX)
 	migout_fifo1=$(mktemp -u -t mig-helper-fifo-stdout1.XXXXXXXXXX)
+	migout2=$(mktemp -t mig-helper-stdout2.XXXXXXXXXX)
+	migout_fifo2=$(mktemp -u -t mig-helper-fifo-stdout2.XXXXXXXXXX)
 	qmp1=$(mktemp -u -t mig-helper-qmp1.XXXXXXXXXX)
 	qmp2=$(mktemp -u -t mig-helper-qmp2.XXXXXXXXXX)
 	fifo=$(mktemp -u -t mig-helper-fifo.XXXXXXXXXX)
 
 	# race here between file creation and trap
 	trap "trap - TERM ; kill 0 ; exit 2" INT TERM
-	trap "rm -f ${migout1} ${migsock} ${qmp1} ${qmp2} ${fifo}" RETURN EXIT
+	trap "rm -f ${migout1} ${migout2} ${migout_fifo1} ${migout_fifo2} ${migsock} ${qmp1} ${qmp2} ${fifo}" RETURN EXIT
 
 	qmpout1=/dev/null
 	qmpout2=/dev/null
+	migcmdline=$@
 
-	eval "$@" -chardev socket,id=mon1,path=${qmp1},server=on,wait=off \
+	mkfifo ${migout_fifo1}
+	mkfifo ${migout_fifo2}
+
+	eval "$migcmdline" \
+		-chardev socket,id=mon1,path=${qmp1},server=on,wait=off \
 		-mon chardev=mon1,mode=control > ${migout_fifo1} &
 	live_pid=$!
 	cat ${migout_fifo1} | tee ${migout1} &
 
-	# We have to use cat to open the named FIFO, because named FIFO's, unlike
-	# pipes, will block on open() until the other end is also opened, and that
-	# totally breaks QEMU...
+	# The test must prompt the user to migrate, so wait for the "migrate"
+	# keyword
+	while ! grep -q -i "Now migrate the VM" < ${migout1} ; do
+		if ! ps -p ${live_pid} > /dev/null ; then
+			echo "ERROR: Test exit before migration point." >&2
+			qmp ${qmp1} '"quit"'> ${qmpout1} 2>/dev/null
+			return 3
+		fi
+		sleep 0.1
+	done
+
+	# This starts the first source QEMU in advance of the test reaching the
+	# migration point, since we expect at least one migration. Subsequent
+	# sources are started as the test hits migrate keywords.
+	do_migration || return $?
+
+	while ps -p ${live_pid} > /dev/null ; do
+		# Wait for EXIT or further migrations
+		if ! grep -q -i "Now migrate the VM" < ${migout1} ; then
+			sleep 0.1
+		else
+			do_migration || return $?
+		fi
+	done
+
+	wait ${live_pid}
+	ret=$?
+
+	while (( $(jobs -r | wc -l) > 0 )); do
+		sleep 0.1
+	done
+
+	return $ret
+}
+
+do_migration ()
+{
+	# We have to use cat to open the named FIFO, because named FIFO's,
+	# unlike pipes, will block on open() until the other end is also
+	# opened, and that totally breaks QEMU...
 	mkfifo ${fifo}
-	eval "$@" -chardev socket,id=mon2,path=${qmp2},server=on,wait=off \
-		-mon chardev=mon2,mode=control -incoming unix:${migsock} < <(cat ${fifo}) &
+	eval "$migcmdline" \
+		-chardev socket,id=mon2,path=${qmp2},server=on,wait=off \
+		-mon chardev=mon2,mode=control -incoming unix:${migsock} \
+		< <(cat ${fifo}) > ${migout_fifo2} &
 	incoming_pid=$!
+	cat ${migout_fifo2} | tee ${migout2} &
 
 	# The test must prompt the user to migrate, so wait for the "migrate" keyword
 	while ! grep -q -i "Now migrate the VM" < ${migout1} ; do
@@ -165,7 +212,7 @@ run_migration ()
 			qmp ${qmp2} '"quit"'> ${qmpout2} 2>/dev/null
 			return 3
 		fi
-		sleep 1
+		sleep 0.1
 	done
 
 	# Wait until the destination has created the incoming and qmp sockets
@@ -177,7 +224,7 @@ run_migration ()
 	# Wait for the migration to complete
 	migstatus=`qmp ${qmp1} '"query-migrate"' | grep return`
 	while ! grep -q '"completed"' <<<"$migstatus" ; do
-		sleep 1
+		sleep 0.1
 		if ! migstatus=`qmp ${qmp1} '"query-migrate"'`; then
 			echo "ERROR: Querying migration state failed." >&2
 			echo > ${fifo}
@@ -193,14 +240,34 @@ run_migration ()
 			return 2
 		fi
 	done
+
 	qmp ${qmp1} '"quit"'> ${qmpout1} 2>/dev/null
+
+	# keypress to dst so getchar completes and test continues
 	echo > ${fifo}
-	wait $incoming_pid
+	rm ${fifo}
+
+	# Ensure the incoming socket is removed, ready for next destination
+	if [ -S ${migsock} ] ; then
+		echo "ERROR: Incoming migration socket not removed after migration." >& 2
+		qmp ${qmp2} '"quit"'> ${qmpout2} 2>/dev/null
+		return 2
+	fi
+
+	wait ${live_pid}
 	ret=$?
 
-	while (( $(jobs -r | wc -l) > 0 )); do
-		sleep 0.5
-	done
+	# Now flip the variables because dest becomes source
+	live_pid=${incoming_pid}
+	tmp=${migout1}
+	migout1=${migout2}
+	migout2=${tmp}
+	tmp=${migout_fifo1}
+	migout_fifo1=${migout_fifo2}
+	migout_fifo2=${tmp}
+	tmp=${qmp1}
+	qmp1=${qmp2}
+	qmp2=${tmp}
 
 	return $ret
 }
-- 
2.42.0

