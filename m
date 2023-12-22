Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0A771A707
	for <kvmarm@lists.linux.dev>; Fri, 22 Dec 2023 13:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SXttPG7Q"
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-5cde7afa1d7so893313a12.1
        for <kvmarm@lists.linux.dev>; Fri, 22 Dec 2023 05:51:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1703253094; x=1703857894; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=csZzn8Tts4GDrY3qLQnkSR7QOMG8LbSslE35UizKPQ4=;
        b=SXttPG7QQfT2dRCvPS9EnRPPEDtZ2nCsfqQzovIy1sup1zQosMPbuOb3X2lkrGrI2T
         GMRxA8GhTKZQsZdnRD9OjUxqaeALSYxkUubt7rUEc7xHYxmYIEjAMsDhyIKFo0aKWn50
         BNCYy2+c5ApUMar7Fk/xtTt7BcoWDjBsFsApmLsP91q0rSV3CnWb1KnfxuKLQPcBm21p
         LxjE5W5VCFviJ7V+5GILYHh0O6b4oRmOF9VFVKIUKW/AMzhjRunCEKLeiTj9u1n9zRAs
         UQkWrFuVfFffm1IjwYVIzng/X1EhFu6L4Z5E5YtBIaa57MZqliX8W2C0qYA7dq1wBpYR
         C/sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703253094; x=1703857894;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=csZzn8Tts4GDrY3qLQnkSR7QOMG8LbSslE35UizKPQ4=;
        b=avR+AwFY+A0i2hWdN1nwLNkeHNKgBgmSZ0GshNTaxOLJFveqRZZKhSWm4q3e9CuX81
         EnfOUBr7T6xcD4+3mwyWi//9RhZAM31w/G6VWG/AOIGkrPA3/TjsAhFuER1j7qPdMZZn
         kaw2X+jHV+dPFvsTWtWuqJpprMnYSOwKgNyxIr1UXyAT9Fob5tScl0/kWXtVCn75WiJc
         6ZQxSSwLuJ6c+JjYXboYW1PycJjzDu+qFSzeX5OIkxZfiGl2b1EInLZnw7BfUjDXJiPy
         W/z5SUjU7c7tO0NgkJP0TE3eK82Gw0DF/StXxp15mfvToxrtd/l1cpaaZguGqQwZ2wGp
         yvoA==
X-Gm-Message-State: AOJu0YzYCW3eMzEcIqWIdn8fgJgUkWlNMYVDVVtFVe5qtbpW2jtK3H51
	S8d5D6GgodMMwWZLy8VWLPc=
X-Google-Smtp-Source: AGHT+IE6JiPXZ1JzgMGiiikrcjbc4fNoco/0elFrP5j2RkHuY2dRuJka6YReTK90dppqCxw0PpOIIA==
X-Received: by 2002:a17:90b:33c5:b0:28c:d84:f77e with SMTP id lk5-20020a17090b33c500b0028c0d84f77emr440214pjb.21.1703253094258;
        Fri, 22 Dec 2023 05:51:34 -0800 (PST)
Received: from wheely.local0.net ([203.220.145.68])
        by smtp.gmail.com with ESMTPSA id n12-20020a17090ac68c00b0028ae54d988esm3629280pjt.48.2023.12.22.05.51.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Dec 2023 05:51:33 -0800 (PST)
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
	linuxppc-dev@lists.ozlabs.org,
	linux-s390@vger.kernel.org,
	kvmarm@lists.linux.dev
Subject: [kvm-unit-tests PATCH 4/9] migration: use a more robust way to wait for background job
Date: Fri, 22 Dec 2023 23:50:43 +1000
Message-ID: <20231222135048.1924672-5-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231222135048.1924672-1-npiggin@gmail.com>
References: <20231222135048.1924672-1-npiggin@gmail.com>
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

