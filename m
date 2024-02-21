Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE7B12E842
	for <kvmarm@lists.linux.dev>; Wed, 21 Feb 2024 03:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708486124; cv=none; b=kX+2wjUKa6gxjB/pEZvre4y0myw8ZN6lPUBX8G7GGLk7SwcNimVitGN6VkyMiBINCV/7Wb9SfLDwwlB3JxtUVL7Zmar4O3Knfyn0T9ndQSJW2rS7aOgx5eK/3WharTatCLQdRI/IMa+NXns9FG5Ov+0NTl6cxvXdodDohI5IydI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708486124; c=relaxed/simple;
	bh=zWC/ztnXPY0Ut0zueLckM+4+xHH3S+YXXr6p5gm7W0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K6LAHqmVMj/K8mEJTELHuQv8i/OhOLQbXkE3hv4fPk5rgtqJg2eZwISmW8BGhHBHAk43eTKoNci+TDCH6DRe0ht+5CO/HnlZbBuTORQwZ5ixLssfY8FbSqhq1l//IWcSGeciFNsQZPkmaKjysMUusl+DWlM9TPYH5PdWO0VpPpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lp0T83De; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lp0T83De"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-1d71cb97937so60635985ad.3
        for <kvmarm@lists.linux.dev>; Tue, 20 Feb 2024 19:28:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708486122; x=1709090922; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aML22p2QMiBfalmtqZDWpeCg6Y3ng+Yw7h/JELXYVmQ=;
        b=lp0T83De+9CF6uE2dqoCY+HmFgCi+Nc7k1hDErSolAJ0/h9ONVRmUV/DpZpHy13GGC
         LoLpV6K5t6DphA8PlEPFFJsG2Nm/rlxC1u5wdDKEWfO2YvxoJbqSbc3X0u+vXfmVtttF
         o6flK2opDJsBssvFw/wGcYUAuFzJ5myI1VZMFgVb6AkN6nwUXoGswZGFdP2MGC9m5C/B
         vWCL+zxdMy1y0sFCaTgL8UF0/MxB5p8qwJz8aBqrc+TM0/1X4fYNdcXxvvJ4UT8+DQlt
         HD+ShIU8Uf5N7hJCWzU0TGOYqdborwuQXQ6lAEtEtqmSAvotao9XMOUDhfZ+vSQtenQI
         jRiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708486122; x=1709090922;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aML22p2QMiBfalmtqZDWpeCg6Y3ng+Yw7h/JELXYVmQ=;
        b=X6P/Is5knlwHePmkfczCg+gDdNilT2oacqpYsbT+5mAeffXdMQV/1kQG+RiK7SuJfx
         fUgVBoIDZMlpxZwEk+bqQG/WLZoAEYmaFh9UiPLnkih/x/XpjGe4SFle+JAQWkWS/2Hi
         GPXvJlwykgWjtwTqFUTldXbkEvBs/GmFzfN5T6zTLSf50wHMmJTwE3qR6uEpHFvdZJxj
         zeb7AzfXD2rYrKHGQonXRlwBImGDiY/zOwWKgWJF0fmnXSxplD5P20v9ACHjvsnpA9dl
         lIQkgqaY4iumUi1cX/TYvBk6a4P9lsR2FR1HUqxe1MCsyqr2MTpooT/4Onj+LFuuLvUX
         lxVQ==
X-Forwarded-Encrypted: i=1; AJvYcCWEvZ6jeR1tDbrUk53ozvsulbpDyuoZ/gOBUfQSC2zZU83O2izJwwjcTbvfXhLRYsqJH0HW+VcTfpdG6NKUnC4pHoKXA73H
X-Gm-Message-State: AOJu0Yx8jrMG2sajDrxirlXuZPHO6MIxRQIky/R21G3oMTi+taprs2V3
	78Pl1UkNW0b43VBfiMK6f3DLPbTi0WyxCt498b+EGuCWO4AWekB9
X-Google-Smtp-Source: AGHT+IHloA4lPV1h3NnRO9wb8wmRssFTGmRoI3MuzFAdRdZDmNqGWg7XAdoSic5qIBVsB6jy4FznyQ==
X-Received: by 2002:a17:902:7001:b0:1da:1e83:b961 with SMTP id y1-20020a170902700100b001da1e83b961mr14195507plk.63.1708486122293;
        Tue, 20 Feb 2024 19:28:42 -0800 (PST)
Received: from wheely.local0.net (220-235-194-103.tpgi.com.au. [220.235.194.103])
        by smtp.gmail.com with ESMTPSA id q7-20020a170902b10700b001dc214f7353sm1246457plr.249.2024.02.20.19.28.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Feb 2024 19:28:42 -0800 (PST)
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
Subject: [kvm-unit-tests PATCH v5 3/8] migration: use a more robust way to wait for background job
Date: Wed, 21 Feb 2024 13:27:52 +1000
Message-ID: <20240221032757.454524-4-npiggin@gmail.com>
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

Starting a pipeline of jobs in the background does not seem to have
a simple way to reliably find the pid of a particular process in the
pipeline (because not all processes are started when the shell
continues to execute).

The way PID of QEMU is derived can result in a failure waiting on a
PID that is not running. This is easier to hit with subsequent
multiple-migration support. Changing this to use $! by swapping the
pipeline for a fifo is more robust.

Reviewed-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 scripts/arch-run.bash | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index c1dd67abe..9a5aaddcc 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -130,19 +130,22 @@ run_migration ()
 	fi
 
 	trap 'trap - TERM ; kill 0 ; exit 2' INT TERM
-	trap 'rm -f ${migout1} ${migsock} ${qmp1} ${qmp2} ${fifo}' RETURN EXIT
+	trap 'rm -f ${migout1} ${migout_fifo1} ${migsock} ${qmp1} ${qmp2} ${fifo}' RETURN EXIT
 
 	migsock=$(mktemp -u -t mig-helper-socket.XXXXXXXXXX)
 	migout1=$(mktemp -t mig-helper-stdout1.XXXXXXXXXX)
+	migout_fifo1=$(mktemp -u -t mig-helper-fifo-stdout1.XXXXXXXXXX)
 	qmp1=$(mktemp -u -t mig-helper-qmp1.XXXXXXXXXX)
 	qmp2=$(mktemp -u -t mig-helper-qmp2.XXXXXXXXXX)
 	fifo=$(mktemp -u -t mig-helper-fifo.XXXXXXXXXX)
 	qmpout1=/dev/null
 	qmpout2=/dev/null
 
+	mkfifo ${migout_fifo1}
 	eval "$@" -chardev socket,id=mon1,path=${qmp1},server=on,wait=off \
-		-mon chardev=mon1,mode=control | tee ${migout1} &
-	live_pid=`jobs -l %+ | grep "eval" | awk '{print$2}'`
+		-mon chardev=mon1,mode=control > ${migout_fifo1} &
+	live_pid=$!
+	cat ${migout_fifo1} | tee ${migout1} &
 
 	# We have to use cat to open the named FIFO, because named FIFO's, unlike
 	# pipes, will block on open() until the other end is also opened, and that
@@ -150,7 +153,7 @@ run_migration ()
 	mkfifo ${fifo}
 	eval "$@" -chardev socket,id=mon2,path=${qmp2},server=on,wait=off \
 		-mon chardev=mon2,mode=control -incoming unix:${migsock} < <(cat ${fifo}) &
-	incoming_pid=`jobs -l %+ | awk '{print$2}'`
+	incoming_pid=$!
 
 	# The test must prompt the user to migrate, so wait for the "migrate" keyword
 	while ! grep -q -i "Now migrate the VM" < ${migout1} ; do
@@ -164,6 +167,10 @@ run_migration ()
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

