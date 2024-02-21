Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B1A138FBE
	for <kvmarm@lists.linux.dev>; Wed, 21 Feb 2024 03:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708486145; cv=none; b=rr9E1V3HPn3ZQTDUk/rUfM8bDlLUOOHDKOUavlkD29hq/PLOrzUqwZ652c9WCRwkGU2GUZus90iedmiajN0ddXq6XiPSkELGfrbHotVvz+Q1S5wC+Z7Vav+fV8D/nlng5H0dkU9CjVyKSwVA0hatbm14R+gDsUeOnp92F1y9AZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708486145; c=relaxed/simple;
	bh=qDu6HLAwjNl8M0s+0tLz6VpR3l1XS4W0h0eQig5mi1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=leKsGIdrDUDBwR58YaM8TPEIvj2dK8jcKQ7eJftqgmIwLA8bUukdNZ3fU2E8K8o7ToTGaQWLr6WsIvFjJFGtG2AA68CwIB8cji4IysDku3ylENQWKwVrT9O8P9NIZrKUjmpXvdexxqpf93fAUxR8cQanBVBqHe/BnPt0hWMx9Kk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DymGYPLA; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DymGYPLA"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-1dba94f9201so40629875ad.0
        for <kvmarm@lists.linux.dev>; Tue, 20 Feb 2024 19:29:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708486144; x=1709090944; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IIo+YCQIpcqZZQl5SQPpBtKwaaGVQawpmU1ARg6aVZc=;
        b=DymGYPLAQyKRXPKratta6BQprf7GXisFgpT2MdJYELhMvyt70nARFKFfDGXt5TkIIE
         1LuGiL4whlElnKCds5XXuzegk2h5qpImoL0GTYXzOtEjwjltcpxsAktVgCrchkOE167a
         bxHw5mneyqMmhaaYY36AEVLXKICdkYPQ/kaf28xiGniv/4mgVhpXMXAOUDJTJnp336ui
         f+hQDEt0cj3NomtIsaOxqsJU9LKfqh3IMVC6NspDueG6588zHJ4qzE2gkDsajYkPsaUt
         gIKLV34Xs3DcM+D7/4Fol6yEn5Ia+rTHcVjjoA4tFedWIto6/81cJBT2G1IejUZilG9Q
         fAVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708486144; x=1709090944;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IIo+YCQIpcqZZQl5SQPpBtKwaaGVQawpmU1ARg6aVZc=;
        b=goxHCAFLSwFTV3S3vHi56JHOPUGMHhgNOxXJhL4wQH3k86mGXSlXQ5VEBYN+8u8XwY
         wPXkLZxKCycsmIn+obF8tcoyPxt764R+4Q9kyk1vJ+NvcEdp7lM44QASX6zhAwqEjysg
         YXCuy4rWIB53nc8cv+uR2ab+qopCS2msSwW7WH6t8PrBXodOS5tD02Chdfvm3EkdA2Hi
         mRnKp0ITGrN1ObTU6099ZGtn+6VXV3XLl4GGoW+evJyVlOrJhumHAlW0AEdQjLB1pO4l
         1NByUIwho1anDnT78ol8oxdnNvCbm14XiuBw1ctWkSkwqBk6xlde+0xJ6Ke+puiPWESj
         1cQA==
X-Forwarded-Encrypted: i=1; AJvYcCW/op4h5gXNgHiT7TfhG85DNU3WYfiCkWRL6z0AXJMJHC3K554KRZxFEgv0j/8JAR6EMF+Os2/kGlCg81Fk+w0EJq1qldk+
X-Gm-Message-State: AOJu0YwLtacVu1HIoW34Ej59ynniJp31kGExfNCn2I2pKRaaUccLh+lF
	nE0fdugB/1TBs7LqWS+jS/wp1+OFkzfU7Ce727iwzCosI7LyqDuu
X-Google-Smtp-Source: AGHT+IGkE2tXMoP+uu2dMPF9yafXmDF1WYeLW14EiA+DBNvKy9Jy7TtJJX6AdHjI0vAVunFoMBALqg==
X-Received: by 2002:a17:903:1211:b0:1d9:a609:dd7e with SMTP id l17-20020a170903121100b001d9a609dd7emr19873074plh.55.1708486143769;
        Tue, 20 Feb 2024 19:29:03 -0800 (PST)
Received: from wheely.local0.net (220-235-194-103.tpgi.com.au. [220.235.194.103])
        by smtp.gmail.com with ESMTPSA id q7-20020a170902b10700b001dc214f7353sm1246457plr.249.2024.02.20.19.28.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Feb 2024 19:29:03 -0800 (PST)
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
Subject: [kvm-unit-tests PATCH v5 6/8] migration: Add quiet migration support
Date: Wed, 21 Feb 2024 13:27:55 +1000
Message-ID: <20240221032757.454524-7-npiggin@gmail.com>
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

Console output required to support migration becomes quite noisy
when doing lots of migrations. Provide a migrate_quiet() call that
suppresses console output and doesn't log a message.

Reviewed-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 lib/migrate.c         | 11 +++++++++++
 lib/migrate.h         |  1 +
 scripts/arch-run.bash |  4 ++--
 3 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/lib/migrate.c b/lib/migrate.c
index b77216594..92d1d957d 100644
--- a/lib/migrate.c
+++ b/lib/migrate.c
@@ -18,6 +18,17 @@ void migrate(void)
 	report_info("Migration complete");
 }
 
+/*
+ * Like migrate() but suppress output and logs, useful for intensive
+ * migration stress testing without polluting logs. Test cases should
+ * provide relevant information about migration in failure reports.
+ */
+void migrate_quiet(void)
+{
+	puts("Now migrate the VM (quiet)\n");
+	(void)getchar();
+}
+
 /*
  * Initiate migration and wait for it to complete.
  * If this function is called more than once, it is a no-op.
diff --git a/lib/migrate.h b/lib/migrate.h
index 2af06a72d..95b9102b0 100644
--- a/lib/migrate.h
+++ b/lib/migrate.h
@@ -7,4 +7,5 @@
  */
 
 void migrate(void);
+void migrate_quiet(void);
 void migrate_once(void);
diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index c98429e8c..0a98e5127 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -152,7 +152,7 @@ run_migration ()
 		-chardev socket,id=mon,path=${src_qmp},server=on,wait=off \
 		-mon chardev=mon,mode=control > ${src_outfifo} &
 	live_pid=$!
-	cat ${src_outfifo} | tee ${src_out} &
+	cat ${src_outfifo} | tee ${src_out} | grep -v "Now migrate the VM (quiet)" &
 
 	# Start the first destination QEMU machine in advance of the test
 	# reaching the migration point, since we expect at least one migration.
@@ -190,7 +190,7 @@ do_migration ()
 		-mon chardev=mon,mode=control -incoming unix:${dst_incoming} \
 		< <(cat ${dst_infifo}) > ${dst_outfifo} &
 	incoming_pid=$!
-	cat ${dst_outfifo} | tee ${dst_out} &
+	cat ${dst_outfifo} | tee ${dst_out} | grep -v "Now migrate the VM (quiet)" &
 
 	# The test must prompt the user to migrate, so wait for the
 	# "Now migrate VM" console message.
-- 
2.42.0

