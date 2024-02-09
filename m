Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F51A664B1
	for <kvmarm@lists.linux.dev>; Fri,  9 Feb 2024 09:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707469951; cv=none; b=kRPmJwZxjki7poBWH6yTcaxTUY6aSSQ+FmiYT99dd0SrSCcZ3IW+MJqYlbsQZnElYXrjHr2bGZxnB/zC5zpdVRMoklwnweyePRfCpUhwuSrqS0MHps1e7wE4tsAjNpgaoUqXB59L9wrkUF2jJeFP3SWBZIs75AOIvBd4JlmH4zI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707469951; c=relaxed/simple;
	bh=H5zOkFsThYHS+CIs/f4GLylAaVSi5mDx3GgSSHbQBfc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jsm8YeROWpaXeLNr82J//pe6jV1Tt2p1eDZT5gIGNuYaBD2VTxX/CJgHDPjpsXWpMgcN1LShqOksS+ij5UlIH30tUESDYHe104OAw7KHlC4Zz5/EI5Gz6FXpOU10xknpkgeznt+kjoxi63HpxLYqnspxFccnrYaCe2MkKlAteJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mCNlfM57; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mCNlfM57"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-6e0947e488cso74119b3a.2
        for <kvmarm@lists.linux.dev>; Fri, 09 Feb 2024 01:12:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707469949; x=1708074749; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J+sqr3M98Kde9sdnxslUPSokF3Ng1Usn2pZLKUoX5aU=;
        b=mCNlfM57YHmtuVWPayGxWw9Hk2r3t0lFVWPKZqY6QafoJPEMJIuHe3YdgRlqjFt022
         YZhcg+z7/tcTNG0q7XolnXmh46RJK/55VJRdZKlMMrMH7166i6Pi8oC3XIKeAWNFhjsj
         4ckvkigihitt7atmQstys1BvPMHRygjoCDzb+oh3urzPlidWSMVGVtNptjw1IU8sBKTx
         K6QQy0Fa0ZYDk3uaVv3fwgeabbP0YXaejgnxcQG6TUErrfMaWRUf67lXNdRdHQYRV/yK
         iKsGx5jCj5Bi8oU+haiRNAZTndpGF+aOvDSMAGZF1zdFtZDC+lGnXg0SVcNCZorvloaQ
         M/vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707469949; x=1708074749;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J+sqr3M98Kde9sdnxslUPSokF3Ng1Usn2pZLKUoX5aU=;
        b=wWQIGnWKvI7ZCl/teCLCfBrIpRMXLAoEK4uIMOY//UcTnfe6q0Z66+kNhyhBCAlLqp
         Q1/5OOmU8jA9rDHhc7F4crl1dauNL4JpfCRirel5iirvwBslxhtRr8F5sVMKcx7JjFDW
         GLwBrcVMIYyyPiVFH7NXpnf+QD+bhF72d05U6H/bOFCFYvNHg0NC+as8TuYmwqLBvQnS
         gkTIkiWSaP6PgiBlgITTQyYFo7tFlR+Wqqet49tLAhaz9YYA8DUECbeM+QYvFnY+xjrC
         mcBJvyhmx6UwNtJp0zbpZwdY/nUnPJaXUYHJI5fvb7B9WWFIGwo5jle+PPVQuVvGiB3Z
         hneA==
X-Forwarded-Encrypted: i=1; AJvYcCUPCuinm9y1q7L1DpgztAaCcgghjNpKcqu/7cy1LIKsDqk2OZp+q0AzegNimltxlju35G7YefcP35eUvPTsvqgZDs1QcpVo
X-Gm-Message-State: AOJu0Ywty9mUw3GGo+2PTwUUstrDGcJV/qr9ib/wdaj43AgqvBBfco9K
	abZEboShPfhafAjAooj7XGBisZMQPE9BO+h1OlI0kq7pR/PzPxkC
X-Google-Smtp-Source: AGHT+IGZiCLeAGHQEeXZBPf6iULKQpILOZ0yiXZFxdekf6snAicAqOXMJ5tAAJqWOoJoPAenpSfyfA==
X-Received: by 2002:a05:6a20:9e47:b0:19e:3a9f:f925 with SMTP id mt7-20020a056a209e4700b0019e3a9ff925mr1379427pzb.14.1707469949311;
        Fri, 09 Feb 2024 01:12:29 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVzluO77dA063QfZWhHREA8V27IxpTe9fFgjzHmlT7bplmWFF152odg1GY/Slh6d8UPJTMANFSrITjUQ0ZsVqx+spgRQEVJ+SXxTdj5OfvWG+QyNpKU9ojdeobZTJuurl6QEnqzJRn8ypfSc7USux7m6h7xZIg7cohLhOljnsjBWtwgpByMWvWzkO0mdnEY3SWfG3gwAL4H+xgDUxWM8QW45cQdlEv09vFEnxijUHiMTGFLxivLp13tBWO76S87z7kfj5i5flJj7daI57LyoDUeCGACU0VoFibaf5To0doTdDkoHOHRoXm4+EJWraVJ4Ds7QDbk+DbyQtdPgekRLpc8g2sjQ1pg9DWaX3y0a0r4zsA/Yd1bs+KTkH9jh/ruwgLzmm+RqM9n+MKClAnuNel5pMLNrqL7lJTegkrgd0nxN30CMzv8ZF62Kmvmcaj5ENlPByFuO4bgJYcuJFcH0GKBZP7EqW6fsS7i0hLhK9gNM0eIdKi1J+4btINqVsA1oz8hCafDKYNlQZ3riVPWLHUfmS1tJdMfZfjOWB6XLSjgK2AJ2HR/qIXT
Received: from wheely.local0.net ([118.208.150.76])
        by smtp.gmail.com with ESMTPSA id cb1-20020a056a02070100b005c1ce3c960bsm1101742pgb.50.2024.02.09.01.12.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Feb 2024 01:12:29 -0800 (PST)
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
Subject: [kvm-unit-tests PATCH v4 6/8] migration: Add quiet migration support
Date: Fri,  9 Feb 2024 19:11:32 +1000
Message-ID: <20240209091134.600228-7-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240209091134.600228-1-npiggin@gmail.com>
References: <20240209091134.600228-1-npiggin@gmail.com>
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
 lib/migrate.c         | 11 +++++++++++
 lib/migrate.h         |  1 +
 scripts/arch-run.bash |  4 ++--
 3 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/lib/migrate.c b/lib/migrate.c
index b7721659..92d1d957 100644
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
index 2af06a72..95b9102b 100644
--- a/lib/migrate.h
+++ b/lib/migrate.h
@@ -7,4 +7,5 @@
  */
 
 void migrate(void);
+void migrate_quiet(void);
 void migrate_once(void);
diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index c98429e8..0a98e512 100644
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

