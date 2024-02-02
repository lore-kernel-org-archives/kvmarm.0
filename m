Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C17D61802B
	for <kvmarm@lists.linux.dev>; Fri,  2 Feb 2024 06:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706857117; cv=none; b=GxP0rI5F57/Q8PgVlJqJmyop7itPvfA58/KL1DYOCl0ZoQn6IpZClO107uRyDbhZMQ/+TcMhsforNHg5EJC8e9RZscq8Mrk2NQIwlbi1ivk9J+5gC2yBcdNwdZWkQptwa7gi1LqRiBVA/IofEdyRxn34bvGE/xBdnk9fYBp9xDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706857117; c=relaxed/simple;
	bh=vZ3YMwX66EaqbN2ORZOVXLG/sa0Qdj2N0D2ckqa3J3g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Eif5tzWxlcZ4S3rmmXS94PElaBH6U1ftAmb2KCoHV7z9cx0I11Q6sUAYZV+FkeaSxRVnCci8LS8im4C2pQBbprk8atUfXhUzNXntYHNTaCoJq3Cufz7efdg7gqUIbh6cSv32yWEbFbJ/Z8tTQgsTO8vrN8vJPCiXvPzAV9GNHc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NF4DkrQn; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NF4DkrQn"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-1d953fa3286so10437075ad.2
        for <kvmarm@lists.linux.dev>; Thu, 01 Feb 2024 22:58:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706857115; x=1707461915; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=csZzn8Tts4GDrY3qLQnkSR7QOMG8LbSslE35UizKPQ4=;
        b=NF4DkrQn/H974cfLCVirMGs/3tCvPlI7TzFb8cX6JZr+33QIiem+OdHOS6P5XPDY2U
         /2rNDmL++ypNyxb1iYAgZwn/dileb4+E/sbtlwLc1Ka4DWPv82qL4xaCa07IzMkZsxFl
         2UTMN04IfGfB2lZwlgXDyf9P8q0b2vvWjACgcOVeCwCm0hsKVB/xAy6Yzkz1LSMoHmjX
         VXufYKa+rZKYCQ7UojVsGCsjIEOXW9vSqsJcLh7url2USXP2cUwsB94tcCNENfseneTe
         121IhIuE8V/xTG8z4HFXY3LWCdyn5PAtbFrCkkna07Xu0ulKqYVTMZ8K58kwvDLpHwRB
         V8Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706857115; x=1707461915;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=csZzn8Tts4GDrY3qLQnkSR7QOMG8LbSslE35UizKPQ4=;
        b=f28iTvV7/sfiYKhoarjSCyiORfBPiBfKCAlRr9dh8z2yx9ZoMP2t1AuL5Qc1eFZ+Pr
         /cY4cNda2+sjKnJ4q9Cet0ch2QGw0FpoBXzLZvpjiXMtQhCpsWE7Ypuc528ITP7m82qP
         hLU6yJswF5Yl4/g1mpyiYj8d3ThO58y/PsWOjawHcH/yru7tT/evuEAzOVdKG83Q/Kmx
         LQSzuTJsp8e16FJBhpcbvgIII9Z0t/1HZ1p3j1DAtnb40NAZul+JXFCCDIjRre+QJzp4
         cEZn3i3xCSP/wlgnUYr+XW4gVaAh4CDRvkLMum0e4Dm44JWE4tDMrg8Nu98607Ihegt0
         E8fQ==
X-Gm-Message-State: AOJu0Yz75ShgQTBdcSw47D1ogd7AThVCAVGq8t8egPMHYqpMXK1sqbOW
	l+xwppZUi60hNp5j2cB1KjEqbqgfbF7aTbK7vzgA4iCH2SN6vvV1
X-Google-Smtp-Source: AGHT+IHQJovP9cuDfLX1LEk4K/alkVzLIkRzxJY+QcE5oL7Dd9yHKan4WRASlSMcGCHpHROzl2ZLRQ==
X-Received: by 2002:a17:902:784a:b0:1d7:67ed:f359 with SMTP id e10-20020a170902784a00b001d767edf359mr4716325pln.4.1706857115153;
        Thu, 01 Feb 2024 22:58:35 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCVSwo2DhWJztWTa9U1WjnG2OEHk75aqypz9EENMaN9rCVjm2aNTvzqOjqreNJITShoHo9T7x+ko5qmg+0mV1bnB2ksDTXi9h0E+gKzF0gwzaPU7sZRfQKEE5GBwSp3vXM5daMc87iFTEbp+kKmWIGcoKllxbyyc7GHbbHP2MYk2R6FbS5cCICb3jeBoC95PLl3gQXdpeY3YdDjwN4gufC5UMsFyXUoMhxStsJ7LBtInri13Lv8ml/nw6NMfYwKBWGeEJ8tZYTOh8QEzFmsxwtypjQFDMaYc+rxpO3wB6cftW99sR9jBOzuqUTKG+KBI89qEH5I6L5LJLboUVYgjQm0h4CApMhlBMlEHF30OUwc1tiunLj3s1xlRislLrnE6gQk4nxX+bgKMbXi7ZyK+VprLwbV1fjrSnPLI+OjdwQoV5pGegIY6Uq6Z/3Mb2gELJE4vKhs+PHAA27nlDncGqIpzsXgCDW3i017CdB2wccIpLULEqbD1ub59rwYxNwXZYWe6tGz+X72qL8Y=
Received: from wheely.local0.net ([1.146.53.155])
        by smtp.gmail.com with ESMTPSA id d18-20020a170903209200b001d948adc19fsm905734plc.46.2024.02.01.22.58.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Feb 2024 22:58:34 -0800 (PST)
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
Subject: [kvm-unit-tests PATCH v2 4/9] migration: use a more robust way to wait for background job
Date: Fri,  2 Feb 2024 16:57:35 +1000
Message-ID: <20240202065740.68643-5-npiggin@gmail.com>
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

Starting a pipeline of jobs in the background does not seem to have
a simple way to reliably find the pid of a particular process in the
pipeline (because not all processes are started when the shell
continues to execute).

The way PID of QEMU is derived can result in a failure waiting on a
PID that is not running. This is easier to hit with subsequent
multiple-migration support. Changing this to use $! by swapping the
pipeline for a fifo is more robust.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 scripts/arch-run.bash | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index cc7da7c5..8fbfc50c 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -131,6 +131,7 @@ run_migration ()
 
 	migsock=$(mktemp -u -t mig-helper-socket.XXXXXXXXXX)
 	migout1=$(mktemp -t mig-helper-stdout1.XXXXXXXXXX)
+	migout_fifo1=$(mktemp -u -t mig-helper-fifo-stdout1.XXXXXXXXXX)
 	qmp1=$(mktemp -u -t mig-helper-qmp1.XXXXXXXXXX)
 	qmp2=$(mktemp -u -t mig-helper-qmp2.XXXXXXXXXX)
 	fifo=$(mktemp -u -t mig-helper-fifo.XXXXXXXXXX)
@@ -143,8 +144,9 @@ run_migration ()
 	qmpout2=/dev/null
 
 	eval "$@" -chardev socket,id=mon1,path=${qmp1},server=on,wait=off \
-		-mon chardev=mon1,mode=control | tee ${migout1} &
-	live_pid=`jobs -l %+ | grep "eval" | awk '{print$2}'`
+		-mon chardev=mon1,mode=control > ${migout_fifo1} &
+	live_pid=$!
+	cat ${migout_fifo1} | tee ${migout1} &
 
 	# We have to use cat to open the named FIFO, because named FIFO's, unlike
 	# pipes, will block on open() until the other end is also opened, and that
@@ -152,7 +154,7 @@ run_migration ()
 	mkfifo ${fifo}
 	eval "$@" -chardev socket,id=mon2,path=${qmp2},server=on,wait=off \
 		-mon chardev=mon2,mode=control -incoming unix:${migsock} < <(cat ${fifo}) &
-	incoming_pid=`jobs -l %+ | awk '{print$2}'`
+	incoming_pid=$!
 
 	# The test must prompt the user to migrate, so wait for the "migrate" keyword
 	while ! grep -q -i "Now migrate the VM" < ${migout1} ; do
@@ -166,6 +168,10 @@ run_migration ()
 		sleep 1
 	done
 
+	# Wait until the destination has created the incoming and qmp sockets
+	while ! [ -S ${migsock} ] ; do sleep 0.1 ; done
+	while ! [ -S ${qmp2} ] ; do sleep 0.1 ; done
+
 	qmp ${qmp1} '"migrate", "arguments": { "uri": "unix:'${migsock}'" }' > ${qmpout1}
 
 	# Wait for the migration to complete
-- 
2.42.0

