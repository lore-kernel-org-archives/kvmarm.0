Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 107A92E3FE
	for <kvmarm@lists.linux.dev>; Wed, 21 Feb 2024 03:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708486131; cv=none; b=AGuCWse/RPfGTg1tESjljHS7g9bpS5dGtvG8flkRjrNcLeQKzkslGg/MWxG430j2TmvNeHF2RtWAmGcxqttQYyR3nHwfE46SJXVK7JWj0J6hzeOSIDdX2JuwFiE0j8yncEIWRBk1Karz18w60CcOrFRjYq0/L1lopPckhDHNyHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708486131; c=relaxed/simple;
	bh=H1wRxzOCbQ9LlcX8uPKoxvTEVRreXVCTRDk0tZeAGFA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aRev4IxfQ7rWD2rY5aY2USPG0c6M+OfuzEP49umNp5UIgRiaW6y1rdKNJe9+Ss0yrSyyzH1r9wVZs6ZXEoF03fi6Ak+s/rWmq5suthSOVCjiHRFjNUPprAGUrUmVXkrHsLT9mBgkORU1/7PgLXgi1XE5QVtmQgaI9J5KpWWmOWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=C6TkKgeb; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C6TkKgeb"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-1dba94f9201so40628825ad.0
        for <kvmarm@lists.linux.dev>; Tue, 20 Feb 2024 19:28:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708486129; x=1709090929; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3D869cFhRopw5qITnMcIX0RsIcUf5yocR4SzD+VoOnY=;
        b=C6TkKgebgSbpBnekk3uVYJUF4q0xFu4KhsepQChYlLpPB5hOVVOtQM3zCXSaAwffQu
         v6XyNtRjheopDrHQ4g+SLbiBK7wZU0X1nDgfFb+YcsCbsdSPQJM5izr4+fdrHDY4cE+G
         ak/+Qepf56VZX9HGug+yEauT6OHQ/RtW13MK/edVoWWS0J1cORtCgMf+gcL4hFP4WKnt
         Pvkl5al0831o7K84zKh38MtkB3gMpSo02U/8YOSjzgBFq+CtomPoDRx8nReyDXq1OCKJ
         GLFpe/BX3EJRLzwNTpTGiU9f4Tmq32Xt4HelIh7X1b89dqzC0YVfeOsvqJrgGzkf2oXx
         yj2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708486129; x=1709090929;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3D869cFhRopw5qITnMcIX0RsIcUf5yocR4SzD+VoOnY=;
        b=gItsz+lZd/nlBvuqGf+U9ftjxPEPLy6kVH7NMilhW63hzYBqv11AFWZz4RRphG4pAl
         OhnrViQKUBI8hN66voWCQmUPJp8ZGFt+/qu0IoiN0SfTstoGK3LJxdigZY141+9IfHzg
         tzbiH4Oiw+0dyaZ6Rbd+ySPXd+Un1mCD83wpc8p4K1dxLgceyKd2mogoB4WWRYO6iHhB
         spqksc1sciDRDjufCXZZjoFaHu9rXCaZgGzFFe6ahP40lCvCIheTPtTEP3xVVBYi49AO
         I5ZunydyE7PNjTjrm9Ij+ug/Wb8N257/A93y35CzHIzM+nt+ou+rme1uV/1I+/iS6vwj
         7lXw==
X-Forwarded-Encrypted: i=1; AJvYcCVWD/3FfzBpxK23AM+FucDfrGTKRuF6bmeKmaAveZmy9njmbK2dBcZA6MVM0LxuccM0cnGEhgVT2VDCDPvTdZw8n406c1Ii
X-Gm-Message-State: AOJu0YzEHCWZFbvXHYiHzNbn30L1GuKACCj/vZogJe+J63pFMTElhWKS
	+VaaXZKdJP8odo0M1VlcY9ZZbOu0IBNCBxp5+VauL9EPPSBxSKjN
X-Google-Smtp-Source: AGHT+IHwwMBr2JmzFJDzZeVdYZUelRxdGLpWAB3n/eeLq7GSP7C3diyEMO0XE7I94wUzHFDofRzLAg==
X-Received: by 2002:a17:902:d58a:b0:1dc:29df:277e with SMTP id k10-20020a170902d58a00b001dc29df277emr1909586plh.47.1708486129301;
        Tue, 20 Feb 2024 19:28:49 -0800 (PST)
Received: from wheely.local0.net (220-235-194-103.tpgi.com.au. [220.235.194.103])
        by smtp.gmail.com with ESMTPSA id q7-20020a170902b10700b001dc214f7353sm1246457plr.249.2024.02.20.19.28.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Feb 2024 19:28:49 -0800 (PST)
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
	kvmarm@lists.linux.dev,
	kvm-riscv@lists.infradead.org
Subject: [kvm-unit-tests PATCH v5 4/8] migration: Support multiple migrations
Date: Wed, 21 Feb 2024 13:27:53 +1000
Message-ID: <20240221032757.454524-5-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240221032757.454524-1-npiggin@gmail.com>
References: <20240221032757.454524-1-npiggin@gmail.com>
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

Reviewed-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 lib/migrate.c         |  8 ++--
 lib/migrate.h         |  1 +
 scripts/arch-run.bash | 86 ++++++++++++++++++++++++++++++++++++-------
 3 files changed, 77 insertions(+), 18 deletions(-)

diff --git a/lib/migrate.c b/lib/migrate.c
index 527e63ae1..b77216594 100644
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
index 3c94e6af7..2af06a72d 100644
--- a/lib/migrate.h
+++ b/lib/migrate.h
@@ -6,4 +6,5 @@
  * Author: Nico Boehr <nrb@linux.ibm.com>
  */
 
+void migrate(void);
 void migrate_once(void);
diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index 9a5aaddcc..c2002d7ae 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -129,12 +129,16 @@ run_migration ()
 		return 77
 	fi
 
+	migcmdline=$@
+
 	trap 'trap - TERM ; kill 0 ; exit 2' INT TERM
-	trap 'rm -f ${migout1} ${migout_fifo1} ${migsock} ${qmp1} ${qmp2} ${fifo}' RETURN EXIT
+	trap 'rm -f ${migout1} ${migout2} ${migout_fifo1} ${migout_fifo2} ${migsock} ${qmp1} ${qmp2} ${fifo}' RETURN EXIT
 
 	migsock=$(mktemp -u -t mig-helper-socket.XXXXXXXXXX)
 	migout1=$(mktemp -t mig-helper-stdout1.XXXXXXXXXX)
 	migout_fifo1=$(mktemp -u -t mig-helper-fifo-stdout1.XXXXXXXXXX)
+	migout2=$(mktemp -t mig-helper-stdout2.XXXXXXXXXX)
+	migout_fifo2=$(mktemp -u -t mig-helper-fifo-stdout2.XXXXXXXXXX)
 	qmp1=$(mktemp -u -t mig-helper-qmp1.XXXXXXXXXX)
 	qmp2=$(mktemp -u -t mig-helper-qmp2.XXXXXXXXXX)
 	fifo=$(mktemp -u -t mig-helper-fifo.XXXXXXXXXX)
@@ -142,20 +146,54 @@ run_migration ()
 	qmpout2=/dev/null
 
 	mkfifo ${migout_fifo1}
-	eval "$@" -chardev socket,id=mon1,path=${qmp1},server=on,wait=off \
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
+	# Start the first destination QEMU machine in advance of the test
+	# reaching the migration point, since we expect at least one migration.
+	# Then destination machines are started after the test outputs
+	# subsequent "Now migrate the VM" messages.
+	do_migration || return $?
+
+	while ps -p ${live_pid} > /dev/null ; do
+		# Wait for test exit or further migration messages.
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
 
-	# The test must prompt the user to migrate, so wait for the "migrate" keyword
+	# The test must prompt the user to migrate, so wait for the
+	# "Now migrate VM" console message.
 	while ! grep -q -i "Now migrate the VM" < ${migout1} ; do
 		if ! ps -p ${live_pid} > /dev/null ; then
 			echo "ERROR: Test exit before migration point." >&2
@@ -164,7 +202,7 @@ run_migration ()
 			qmp ${qmp2} '"quit"'> ${qmpout2} 2>/dev/null
 			return 3
 		fi
-		sleep 1
+		sleep 0.1
 	done
 
 	# Wait until the destination has created the incoming and qmp sockets
@@ -176,7 +214,7 @@ run_migration ()
 	# Wait for the migration to complete
 	migstatus=`qmp ${qmp1} '"query-migrate"' | grep return`
 	while ! grep -q '"completed"' <<<"$migstatus" ; do
-		sleep 1
+		sleep 0.1
 		if ! migstatus=`qmp ${qmp1} '"query-migrate"'`; then
 			echo "ERROR: Querying migration state failed." >&2
 			echo > ${fifo}
@@ -192,14 +230,34 @@ run_migration ()
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

