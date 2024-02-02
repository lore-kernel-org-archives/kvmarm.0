Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2CE7182DA
	for <kvmarm@lists.linux.dev>; Fri,  2 Feb 2024 06:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706857144; cv=none; b=IpBCuoGtioKVjY9+9zPlWHM+2Bat4OLg+WWigGZg6mGueGlVrCRFjoBqycDlLuw2Zu2J0L4j9du7nBATfSZQjJ2C2L/OV5Qb/sHVE72ZSbg2bxTelVn37UmmmV71tl+g9pjA1QLWL3dzf4N26Avu6dRfcly9JdunJcOY/Yphtdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706857144; c=relaxed/simple;
	bh=2beTdUj4YXNqigb6jUTF4KkxHyvHbagk5SI7K1z8HW0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YDO4gojNJjJfIfMju16pviCw7qcAOeAW5VGiBaY0pgrQesMfD1anlAW9RRYO6kUJdelA747A3pfuKbSpgUHROkMcBg8YknrpKlzRdHyxGxMS5ZpH84HW3huZKgX/dDVNGy0CALJ2qwkIXM1HluPmukC+yUc3DHnmI2MPClmqfNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Wj4x/dWZ; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Wj4x/dWZ"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-1d918008b99so14160015ad.3
        for <kvmarm@lists.linux.dev>; Thu, 01 Feb 2024 22:59:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706857142; x=1707461942; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AcbZ3b72z5JTsiEYQiD8/BwtKqeQBzzGW/MZj7+sxQo=;
        b=Wj4x/dWZvKTFBAdiYA5UVuTjh0DzB/h4wLE1WM69UYpoP2BnQEuSvcAStl0ktLoWIz
         FZ49tLv1SQdKjPHaWZ+k8aDLP2UKyUJLYjI+uciu5CKNWxA7pZV+TukkEeZPzLAKje/S
         XJCOI1T1w0fFzsjDVOcvPu3ChHJNa/hxEfHsh4HD0MBOVNDkKeCTPb9dO8paFkhTraba
         UsDrwdi2meHBJqutjsvOiDTUP1q+CIU7BNCITimwfS8qskYaB7b5sKkduFID4sILwcdj
         2pkAdnHVPyhynhDrf+dHuKJVZMtflN33G4Hb+L85NqdA6BbR2TaV8QbqfFvbJdKbJt3o
         BeZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706857142; x=1707461942;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AcbZ3b72z5JTsiEYQiD8/BwtKqeQBzzGW/MZj7+sxQo=;
        b=ncmyJEFfdaz0yTLl7PuJGv1P9T0ZOdYFw+AkmyzfO0xDGixMkh65lXSx0lY30cYf1S
         lgm4c4SBHOL7vNs/J+4Pji7kzvFBXa4tJ3LBKcNB4CabTtSmaydmvrBR0zw5WYCaEPON
         11zivm83YUv2wmK5TwXXVHtQbSS3kmHVBUf0J3FkK0ariAvNTnMUq8YeACRDLtvvz2dq
         Xe3h54xgcnSFlep2+0nmsbOVi5QbzNwCAaWgsOOMIOOAjwkRC3wwZZdKF768tyTIGIgG
         evBVtDcHaF+n1Oo7XP9tayAJDi7SAFCq7GZ3U8m+Bo9QvB3ydJBXIGY5G4mJV7VPNZKY
         392w==
X-Gm-Message-State: AOJu0YwfjnRM0VY8BKXg0wl42uYXE7A53Ia+Nl3XtuQ2zhA7llJeqh93
	qsgK+GpLBFc/QpqrIheSqtqE3i3de7dc2Yrx45t2iIKMeYPL0XN3
X-Google-Smtp-Source: AGHT+IFs+IN8kqrNAOK7L1kdhKg2x+fFZzGf5XMf2+FBY9Nbg8lXWJKa6GZTbVG9lE7J4tad2sbYug==
X-Received: by 2002:a17:902:ce8c:b0:1d9:7412:834 with SMTP id f12-20020a170902ce8c00b001d974120834mr719999plg.8.1706857141947;
        Thu, 01 Feb 2024 22:59:01 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCWSPDjupVheTRpWjNG3qQOcVOPZJWHEhIlPhxS7xEOECZT/j+hA5vA7EhckWrkOUVp1YN/gMV83pWB6BlPQnN464jm5KGO0FaR/AV/72oUiwHzfmmMXB6AfWsXAYGreRlgFfBq4q4v6indtcbkufNSdGjsgqswIjC9s7nUFqPjexotrw7C85wdEReHZ4i4Hc+8/N4m44m9fAMAT3yAWTKAuRw+HxNNdwwHUbfL06hssswrFRRGhvZqesWG9HRgrSFM5+hbwwelX/CD22eTA4iFEQsrzWQ1WCRHt1Rl3QDWgENNcYBjqIAfOAr+7Nw+VVm+kmHyXa61hG/SGbSzt47XfF81ZEZIU4/dt0kycXB3YA5i/hltb8mlyQhIfojSw8EiSEAX/hczMK1BJxR1JblUApaYd1Yu1trsAUfTu5Efg2L8YNp3UnHiMD9WXpZJcE6f79A5grOoZGB/t1Fq41wpCqsWUsrcSembgQLmQNRqA2UZytjtZI/hxLRLhl13CTJQgHhr2cqx8R6E=
Received: from wheely.local0.net ([1.146.53.155])
        by smtp.gmail.com with ESMTPSA id d18-20020a170903209200b001d948adc19fsm905734plc.46.2024.02.01.22.58.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Feb 2024 22:59:01 -0800 (PST)
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
Subject: [kvm-unit-tests PATCH v2 7/9] migration: Add quiet migration support
Date: Fri,  2 Feb 2024 16:57:38 +1000
Message-ID: <20240202065740.68643-8-npiggin@gmail.com>
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

Console output required to support migration becomes quite noisy
when doing lots of migrations. Provide a migrate_quiet() call that
suppresses console output and doesn't log a message.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 lib/migrate.c         | 12 ++++++++++++
 lib/migrate.h         |  1 +
 scripts/arch-run.bash |  4 ++--
 3 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/lib/migrate.c b/lib/migrate.c
index b7721659..4e0ab516 100644
--- a/lib/migrate.c
+++ b/lib/migrate.c
@@ -18,6 +18,18 @@ void migrate(void)
 	report_info("Migration complete");
 }
 
+/*
+ * Like migrate() but supporess output and logs, useful for intensive
+ * migration stress testing without polluting logs. Test cases should
+ * provide relevant information about migration in failure reports.
+ */
+void migrate_quiet(void)
+{
+	puts("Now migrate the VM (quiet)\n");
+	(void)getchar();
+}
+
+
 /*
  * Initiate migration and wait for it to complete.
  * If this function is called more than once, it is a no-op.
diff --git a/lib/migrate.h b/lib/migrate.h
index 2af06a72..95b9102b 100644
--- a/lib/migrate.h
+++ b/lib/migrate.h
@@ -7,4 +7,5 @@
  */
 
 void migrate(void);
+void migrate_quiet(void);
 void migrate_once(void);
diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index 0feaa190..5810f9a1 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -154,7 +154,7 @@ run_migration ()
 		-chardev socket,id=mon,path=${src_qmp},server=on,wait=off \
 		-mon chardev=mon,mode=control > ${src_outfifo} &
 	live_pid=$!
-	cat ${src_outfifo} | tee ${src_out} &
+	cat ${src_outfifo} | tee ${src_out} | grep -v "Now migrate the VM (quiet)" &
 
 	# The test must prompt the user to migrate, so wait for the "migrate"
 	# keyword
@@ -202,7 +202,7 @@ do_migration ()
 		-mon chardev=mon,mode=control -incoming unix:${dst_incoming} \
 		< <(cat ${dst_infifo}) > ${dst_outfifo} &
 	incoming_pid=$!
-	cat ${dst_outfifo} | tee ${dst_out} &
+	cat ${dst_outfifo} | tee ${dst_out} | grep -v "Now migrate the VM (quiet)" &
 
 	# The test must prompt the user to migrate, so wait for the "migrate" keyword
 	while ! grep -q -i "Now migrate the VM" < ${src_out} ; do
-- 
2.42.0

