Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 755E9651B4
	for <kvmarm@lists.linux.dev>; Fri,  9 Feb 2024 07:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707462161; cv=none; b=bEEOgv5UMoVOYbmFD4M5UIzDM7RIbDwds1NDsENI0n+ZQg+EddQES21kqx/jzEoOgQwlt+L61+IzZBmVS1on0YDNjMJ70SsDt9zTEMID5RABeVe21avX21nGNvz4Ym61yNmEbdGmZvCicif9IwAd2Xz8UBubi5iHBpxn96HHfUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707462161; c=relaxed/simple;
	bh=Ggiy/j+eNNquv7fJGl0mDomtLALKGr93XSs0exwN1fM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YfT2GYkfKVXO6ny+6aREiFBO3HbeVt8X4NnEY/e70fUz61+YAVZoWg+vyzZ3lRnnSi7gPNLBGJuRXACciVwoT/GATUCc/dnlFRilWsMuXfm760C0+bb8lDn2JgW+HKM/5xGZdaycdqyycXUE6zVqfAa6hl6nt6j8kAmtY6vwyrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CAl7/hwR; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CAl7/hwR"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-6e05f6c7f50so413217b3a.3
        for <kvmarm@lists.linux.dev>; Thu, 08 Feb 2024 23:02:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707462158; x=1708066958; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cy1X5Ca29tArtn0NovkNFsMlSyreo5G7UR6M9QUaMzw=;
        b=CAl7/hwRaLPK71JB3hayFZ9ahZDFofp92OjuKWvG2hREQwA+QKQCWMVqR8N2KwY5nS
         dCgogjRC94/kttSPgGzavqFeT9iogSSdC2tP6V1yhe7NeFxSYIC804seH5es3ol9EABt
         q6Wx6gpdFNv4PAgrED0k13gnEYw9KupZ0/VDMbJSrbQb4eOw07riV7VbEDjRH4DjkBjg
         dhkpUrJsnpmVgZT7U3AGfZm9IpDEjzfpob2xbsnUfq20I/x/DO7E23y57sI6PvedL87u
         4zO2IxBeimjQRM3h6Nw4plVeSN2Q6K6sI3KkD1+FZ26SvgoBOBgjVvV4+p66V+PHziwz
         zoVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707462158; x=1708066958;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cy1X5Ca29tArtn0NovkNFsMlSyreo5G7UR6M9QUaMzw=;
        b=AFRJBqxUbA/sZOX6WbPGOEXDhB4mzegM92iArrhAvE6IDn8SxOd366bDxFaSpaT/hP
         Zc3ltO71zUAoMzkbLi2XeEc/Xb3ckbWPJGYhTEa/SUkaZ5K2yOIEtZgsfMIu76WSIF6i
         FEq8+zEqGJdVPeyp5WQNOaqDO9A7avq5drq8UycM2gnReoz98v44ckd+c0FOF58ImB1w
         P7y6/ECgjKjGpNeGvJ1Xn6OEusHTZcr3MazTMsTb7On9bBg84+tGiR/MVZuwkvWQZjlj
         9JQvRSQKzM6UWs47Bfv+DfBNbb1qYWZ0xQEGkYJdr+iKKkv7kr8P6JSro0DphRnlCxWw
         hXSQ==
X-Forwarded-Encrypted: i=1; AJvYcCXKQgsRS9/B1T2CdIjRYLgMOITfqxcZYzMxl+cA0z6h9N4IOS7QKW9a7hSFmHMrjy7diz368jtFFUEb9GX/ulGD8zvEkZ2Q
X-Gm-Message-State: AOJu0Yz/xIV2Fdse2zUOMe5FZaQXCYfYK7Dt6MYDX+sZfb2X/bLy2qu5
	j3/FdUF6eETZ0v52o2c4A7oraAC/elJxuDTyu29xrd4iCBzOI1Ta
X-Google-Smtp-Source: AGHT+IGyObXJhAJtuRZSnotzajDKS6+1BQXtukEa0pBvdlsdU+rx6fNsJtri4ZZ4yQH/wfN6q/qLvQ==
X-Received: by 2002:a05:6a20:d70f:b0:19b:e91c:1a42 with SMTP id iz15-20020a056a20d70f00b0019be91c1a42mr981104pzb.55.1707462157792;
        Thu, 08 Feb 2024 23:02:37 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXWAILiGdtpXRUr7E9L3EvTMs439ia4KHvSemZiVQD134LyHPDF51alZyQePs8N9GRrcv2AonRJWQNOwMDtxtn3q3aTo/z1z/1lOobjPcC+hT2oAdS03H9B8USvSh5E9qGsoPDGEAIT0SU5K5yg06Po55yRrSO4l/yTxbYGYB5jXZ9L9WNdutQlL/QgEh8eakjz5RV9/hGjx7h3s9sdIHQuwOpgUFvBrzZch1nv1GZABrPHBTc1qygJTH6Nv1aOaqIQxgF+1FcdRntS2/d/qozZ5R1zNRrQRGIcIajEQAvDmSkqHxe0arg/kmH7bpWUCT1fSWlmNaLr47aFKLM7iiSMRjjO5ZivAISeehm0pZKHjGMJNNG5M5C4brt+iKrPi3tznROuJQkTzZ4p6DeDNRinOFXEPuGX3NIdGS750TrUF/qxsWQKR/7EpNNB95FJ+51yG/5MpD7ahY1HxfxbaEueCD6sQ4VoTS8abizpSc8NwIpy7YWlwXpl67SbLDmSGAC7dTX4YzCB7N1lSBsAEHYh9s4FVZNEcJ/a5nV2LVkwRC+NUxcHEs0j
Received: from wheely.local0.net ([1.146.102.26])
        by smtp.gmail.com with ESMTPSA id r10-20020a170903410a00b001d7284b9461sm839285pld.128.2024.02.08.23.02.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Feb 2024 23:02:37 -0800 (PST)
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
Subject: [kvm-unit-tests PATCH v3 5/8] arch-run: rename migration variables
Date: Fri,  9 Feb 2024 17:01:38 +1000
Message-ID: <20240209070141.421569-6-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240209070141.421569-1-npiggin@gmail.com>
References: <20240209070141.421569-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Using 1 and 2 for source and destination is confusing, particularly
now with multiple migrations that flip between them. Do a rename
pass to tidy things up.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 scripts/arch-run.bash | 115 +++++++++++++++++++++---------------------
 1 file changed, 58 insertions(+), 57 deletions(-)

diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index a914ba17..0b45eb61 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -132,34 +132,34 @@ run_migration ()
 	migcmdline=$@
 
 	trap 'trap - TERM ; kill 0 ; exit 2' INT TERM
-	trap 'rm -f ${migout1} ${migout2} ${migout_fifo1} ${migout_fifo2} ${migsock} ${qmp1} ${qmp2} ${fifo}' RETURN EXIT
-
-	migsock=$(mktemp -u -t mig-helper-socket.XXXXXXXXXX)
-	migout1=$(mktemp -t mig-helper-stdout1.XXXXXXXXXX)
-	migout_fifo1=$(mktemp -u -t mig-helper-fifo-stdout1.XXXXXXXXXX)
-	migout2=$(mktemp -t mig-helper-stdout2.XXXXXXXXXX)
-	migout_fifo2=$(mktemp -u -t mig-helper-fifo-stdout2.XXXXXXXXXX)
-	qmp1=$(mktemp -u -t mig-helper-qmp1.XXXXXXXXXX)
-	qmp2=$(mktemp -u -t mig-helper-qmp2.XXXXXXXXXX)
-	fifo=$(mktemp -u -t mig-helper-fifo.XXXXXXXXXX)
-	qmpout1=/dev/null
-	qmpout2=/dev/null
-
-	mkfifo ${migout_fifo1}
-	mkfifo ${migout_fifo2}
+	trap 'rm -f ${src_out} ${dst_out} ${src_outfifo} ${dst_outfifo} ${dst_incoming} ${src_qmp} ${dst_qmp} ${dst_infifo}' RETURN EXIT
+
+	dst_incoming=$(mktemp -u -t mig-helper-socket-incoming.XXXXXXXXXX)
+	src_out=$(mktemp -t mig-helper-stdout1.XXXXXXXXXX)
+	src_outfifo=$(mktemp -u -t mig-helper-fifo-stdout1.XXXXXXXXXX)
+	dst_out=$(mktemp -t mig-helper-stdout2.XXXXXXXXXX)
+	dst_outfifo=$(mktemp -u -t mig-helper-fifo-stdout2.XXXXXXXXXX)
+	src_qmp=$(mktemp -u -t mig-helper-qmp1.XXXXXXXXXX)
+	dst_qmp=$(mktemp -u -t mig-helper-qmp2.XXXXXXXXXX)
+	dst_infifo=$(mktemp -u -t mig-helper-fifo-stdin.XXXXXXXXXX)
+	src_qmpout=/dev/null
+	dst_qmpout=/dev/null
+
+	mkfifo ${src_outfifo}
+	mkfifo ${dst_outfifo}
 
 	eval "$migcmdline" \
-		-chardev socket,id=mon1,path=${qmp1},server=on,wait=off \
-		-mon chardev=mon1,mode=control > ${migout_fifo1} &
+		-chardev socket,id=mon,path=${src_qmp},server=on,wait=off \
+		-mon chardev=mon,mode=control > ${src_outfifo} &
 	live_pid=$!
-	cat ${migout_fifo1} | tee ${migout1} &
+	cat ${src_outfifo} | tee ${src_out} &
 
 	# The test must prompt the user to migrate, so wait for the "migrate"
 	# keyword
-	while ! grep -q -i "Now migrate the VM" < ${migout1} ; do
+	while ! grep -q -i "Now migrate the VM" < ${src_out} ; do
 		if ! ps -p ${live_pid} > /dev/null ; then
 			echo "ERROR: Test exit before migration point." >&2
-			qmp ${qmp1} '"quit"'> ${qmpout1} 2>/dev/null
+			qmp ${src_qmp} '"quit"'> ${src_qmpout} 2>/dev/null
 			return 3
 		fi
 		sleep 0.1
@@ -172,7 +172,7 @@ run_migration ()
 
 	while ps -p ${live_pid} > /dev/null ; do
 		# Wait for EXIT or further migrations
-		if ! grep -q -i "Now migrate the VM" < ${migout1} ; then
+		if ! grep -q -i "Now migrate the VM" < ${src_out} ; then
 			sleep 0.1
 		else
 			do_migration || return $?
@@ -194,79 +194,80 @@ do_migration ()
 	# We have to use cat to open the named FIFO, because named FIFO's,
 	# unlike pipes, will block on open() until the other end is also
 	# opened, and that totally breaks QEMU...
-	mkfifo ${fifo}
+	mkfifo ${dst_infifo}
 	eval "$migcmdline" \
-		-chardev socket,id=mon2,path=${qmp2},server=on,wait=off \
-		-mon chardev=mon2,mode=control -incoming unix:${migsock} \
-		< <(cat ${fifo}) > ${migout_fifo2} &
+		-chardev socket,id=mon,path=${dst_qmp},server=on,wait=off \
+		-mon chardev=mon,mode=control -incoming unix:${dst_incoming} \
+		< <(cat ${dst_infifo}) > ${dst_outfifo} &
 	incoming_pid=$!
-	cat ${migout_fifo2} | tee ${migout2} &
+	cat ${dst_outfifo} | tee ${dst_out} &
 
 	# The test must prompt the user to migrate, so wait for the "migrate" keyword
-	while ! grep -q -i "Now migrate the VM" < ${migout1} ; do
+	while ! grep -q -i "Now migrate the VM" < ${src_out} ; do
 		if ! ps -p ${live_pid} > /dev/null ; then
 			echo "ERROR: Test exit before migration point." >&2
-			echo > ${fifo}
-			qmp ${qmp1} '"quit"'> ${qmpout1} 2>/dev/null
-			qmp ${qmp2} '"quit"'> ${qmpout2} 2>/dev/null
+			echo > ${dst_infifo}
+			qmp ${src_qmp} '"quit"'> ${src_qmpout} 2>/dev/null
+			qmp ${dst_qmp} '"quit"'> ${dst_qmpout} 2>/dev/null
 			return 3
 		fi
 		sleep 0.1
 	done
 
 	# Wait until the destination has created the incoming and qmp sockets
-	while ! [ -S ${migsock} ] ; do sleep 0.1 ; done
-	while ! [ -S ${qmp2} ] ; do sleep 0.1 ; done
+	while ! [ -S ${dst_incoming} ] ; do sleep 0.1 ; done
+	while ! [ -S ${dst_qmp} ] ; do sleep 0.1 ; done
 
-	qmp ${qmp1} '"migrate", "arguments": { "uri": "unix:'${migsock}'" }' > ${qmpout1}
+	qmp ${src_qmp} '"migrate", "arguments": { "uri": "unix:'${dst_incoming}'" }' > ${src_qmpout}
 
 	# Wait for the migration to complete
-	migstatus=`qmp ${qmp1} '"query-migrate"' | grep return`
+	migstatus=`qmp ${src_qmp} '"query-migrate"' | grep return`
 	while ! grep -q '"completed"' <<<"$migstatus" ; do
 		sleep 0.1
-		if ! migstatus=`qmp ${qmp1} '"query-migrate"'`; then
+		if ! migstatus=`qmp ${src_qmp} '"query-migrate"'`; then
 			echo "ERROR: Querying migration state failed." >&2
-			echo > ${fifo}
-			qmp ${qmp2} '"quit"'> ${qmpout2} 2>/dev/null
+			echo > ${dst_infifo}
+			qmp ${dst_qmp} '"quit"'> ${dst_qmpout} 2>/dev/null
 			return 2
 		fi
 		migstatus=`grep return <<<"$migstatus"`
 		if grep -q '"failed"' <<<"$migstatus"; then
 			echo "ERROR: Migration failed." >&2
-			echo > ${fifo}
-			qmp ${qmp1} '"quit"'> ${qmpout1} 2>/dev/null
-			qmp ${qmp2} '"quit"'> ${qmpout2} 2>/dev/null
+			echo > ${dst_infifo}
+			qmp ${src_qmp} '"quit"'> ${src_qmpout} 2>/dev/null
+			qmp ${dst_qmp} '"quit"'> ${dst_qmpout} 2>/dev/null
 			return 2
 		fi
 	done
 
-	qmp ${qmp1} '"quit"'> ${qmpout1} 2>/dev/null
+	qmp ${src_qmp} '"quit"'> ${src_qmpout} 2>/dev/null
 
 	# keypress to dst so getchar completes and test continues
-	echo > ${fifo}
-	rm ${fifo}
+	echo > ${dst_infifo}
+	rm ${dst_infifo}
 
 	# Ensure the incoming socket is removed, ready for next destination
-	if [ -S ${migsock} ] ; then
+	if [ -S ${dst_incoming} ] ; then
 		echo "ERROR: Incoming migration socket not removed after migration." >& 2
-		qmp ${qmp2} '"quit"'> ${qmpout2} 2>/dev/null
+		qmp ${dst_qmp} '"quit"'> ${dst_qmpout} 2>/dev/null
 		return 2
 	fi
 
 	wait ${live_pid}
 	ret=$?
 
-	# Now flip the variables because dest becomes source
+	# Now flip the variables because destination machine becomes source
+	# for the next migration.
 	live_pid=${incoming_pid}
-	tmp=${migout1}
-	migout1=${migout2}
-	migout2=${tmp}
-	tmp=${migout_fifo1}
-	migout_fifo1=${migout_fifo2}
-	migout_fifo2=${tmp}
-	tmp=${qmp1}
-	qmp1=${qmp2}
-	qmp2=${tmp}
+	tmp=${src_out}
+	src_out=${dst_out}
+	dst_out=${tmp}
+	tmp=${src_outfifo}
+	src_outfifo=${dst_outfifo}
+	dst_outfifo=${tmp}
+	tmp=${src_qmp}
+	src_qmp=${dst_qmp}
+	dst_qmp=${tmp}
 
 	return $ret
 }
@@ -289,8 +290,8 @@ run_panic ()
 	qmp=$(mktemp -u -t panic-qmp.XXXXXXXXXX)
 
 	# start VM stopped so we don't miss any events
-	eval "$@" -chardev socket,id=mon1,path=${qmp},server=on,wait=off \
-		-mon chardev=mon1,mode=control -S &
+	eval "$@" -chardev socket,id=mon,path=${qmp},server=on,wait=off \
+		-mon chardev=mon,mode=control -S &
 
 	panic_event_count=$(qmp_events ${qmp} | jq -c 'select(.event == "GUEST_PANICKED")' | wc -l)
 	if [ "$panic_event_count" -lt 1 ]; then
-- 
2.42.0

