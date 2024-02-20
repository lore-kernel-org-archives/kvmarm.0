Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C61C62160
	for <kvmarm@lists.linux.dev>; Tue, 20 Feb 2024 08:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708419119; cv=none; b=GEQAQJY5AbpsOtlapdqsuoNyKImWyU7H5jxeGaVgCIT8SkM82Lt+HSSFAIOT9aDDeSGWRhi+OWqNseFurMM9tbqDatQ+QmUc+3jLhGPJLZoq+sQyzzzEMr3aemboVaqDUPmVimJwLlu4OiztPziMvoLpj9d4h3buf1MH4b+HGXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708419119; c=relaxed/simple;
	bh=6UsEcVg9fs955dIXXCf2kt0xbeMG9Ov3y7WZ6RkN4uU=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=Qhx6NoHKdW7j3LUntSKcmMsbUxj7TzZTeFtA0+RCmxkdmT+zu7ggjqNMdKFBLlHf69B2vVwJt+yqniOg5Rm+0tWx8VTIAxEdLiMvmjKKajRchFytGJy9Hbpqbvi6z+1NNWPpOaGnTtSoh0vvPo5hEDG4pgK0jmyd5Ce5LA2ZXdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bKVeDXAp; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bKVeDXAp"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1dc139ed11fso3939135ad.0
        for <kvmarm@lists.linux.dev>; Tue, 20 Feb 2024 00:51:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708419117; x=1709023917; darn=lists.linux.dev;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RHRw7NfUQxOmzf6TUbuN67SVbSWk7iT5PJ4EhCUmtMI=;
        b=bKVeDXApww9Dmsj4ae5snIVpmgRKQj3BcHLRUSX2jauhYQOotxMZrKz0yaafXclnlA
         mSwgwW6wh8px/xvVofeAg1BRBqdKrDprlvnSAzGZpXeBTfTzBbIKjm5Ip6b0SMQh/d4H
         JrhOcflOaDu2ljHdj7Q3WEE4etuznW2gomrjeM9R9ObJE9Ez94cxwhnduXDpecnq5v12
         hI50F+YwlvI+mDf6eu++qHSvA71k/jCVmaM8hm+7LQlMSt9HWgxRd1zcG74GeE9VKcar
         HO9yf791nnLvcgWHLS13l1scPD+vkkeZprZ7YBBQz59kSDHM3mExeRue8qOCGlir0rQI
         IaVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708419117; x=1709023917;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=RHRw7NfUQxOmzf6TUbuN67SVbSWk7iT5PJ4EhCUmtMI=;
        b=T6h3QFssh5LoeQX5koHo47/EtWD3+qEXH7mxh0YJjDZFj+UGoD96eWp2zNfFtcnon5
         hKP0ozDKARqlvQ3sAbtdS0hMoO1nkAURE2DjRtLrJvw3gZ3XzbgeOKWg82DFsKCyOw8+
         KSXdANReAZw5uU7auSezR52xcF0QhKvOcYUp+wveJgu0A1D0nV3Ms6bJsPt3+ZoEQPIj
         hwDsVsMevGsqbswcWzRc5iiL7hOlFT/nAPgpAPFfNiwJETojJTmIqDlCeP1Lgz59R0y/
         F12G9CxfPt8+nthnLkWrvPDapN9UKIk1iQ5xbo533x8DI2lbfsH+McEjTyKd91mokk2W
         Y0mA==
X-Forwarded-Encrypted: i=1; AJvYcCXoZKq5NLdnfWJXMGunhgU1ua1l17bQp4uYFTL4eL66uT16/FcdGszPiY87oe/NNaLemJmAtixKDNw+iwp9ljnUK7wRqIze
X-Gm-Message-State: AOJu0YzIF8ifq7jBzL+cRBcK6BvSmvwGq13swWO7GJ/Uj9lZCV7Xd1jD
	Q8y5BnFvQTMTZE8pENf0ZBgZZqR4Q32tx5uovDQ7DdcnVKmej1nr
X-Google-Smtp-Source: AGHT+IHCOTgBz8F34jaXArxWnHGtuhxxlqEqR4+fUf3AafBkZCORlDzDbK6ysUpJFvEkQMWPuP1vtQ==
X-Received: by 2002:a17:903:58d:b0:1db:a7bb:492d with SMTP id jv13-20020a170903058d00b001dba7bb492dmr13463979plb.5.1708419117076;
        Tue, 20 Feb 2024 00:51:57 -0800 (PST)
Received: from localhost (123-243-155-241.static.tpgi.com.au. [123.243.155.241])
        by smtp.gmail.com with ESMTPSA id b15-20020a170902d50f00b001d9aa663282sm5686547plg.266.2024.02.20.00.51.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Feb 2024 00:51:56 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 20 Feb 2024 18:51:51 +1000
Message-Id: <CZ9S150A3M1Y.1HVL51OVY2ZW8@wheely>
Cc: "Andrew Jones" <andrew.jones@linux.dev>, "Eric Auger"
 <eric.auger@redhat.com>, <kvm@vger.kernel.org>, <kvmarm@lists.linux.dev>
Subject: Re: [kvm-unit-tests PATCH] lib/arm/io: Fix calling getchar()
 multiple times
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Alexandru Elisei" <alexandru.elisei@arm.com>, "Thomas Huth"
 <thuth@redhat.com>
X-Mailer: aerc 0.15.2
References: <20240216140210.70280-1-thuth@redhat.com>
 <ZdOIJfvVm7C23ZdZ@raptor>
In-Reply-To: <ZdOIJfvVm7C23ZdZ@raptor>

On Tue Feb 20, 2024 at 2:56 AM AEST, Alexandru Elisei wrote:
> Hi,
>
> Thanks for writing this. I've tested it with kvmtool, which emulates a 82=
50
> UART:
>
> Tested-by: Alexandru Elisei <alexandru.elisei@arm.com>
>
> This fixes a longstanding bug with kvmtool, where migrate_once() would re=
ad
> the last character that was sent, and then think that migration was
> completed even though it was never performed.
>
> While we are on the subject of migration:
>
> SKIP: gicv3: its-migration: Test requires at least 4 vcpus
> Now migrate the VM, then press a key to continue...
> INFO: gicv3: its-migration: Migration complete
> SUMMARY: 1 tests, 1 skipped
>
> That's extremely confusing. Why is migrate_once() executed after the
> test_its_pending() function call without checking if the test was skipped=
?

Seems not too hard, incremental patch on top of multi migration
series below. After this series is merged I can try that (s390
could benefit with some changes too).

Thanks,
Nick

---
diff --git a/arm/gic.c b/arm/gic.c
index c950b0d15..bbf828f17 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -782,13 +782,15 @@ static void test_its_migration(void)
 	struct its_device *dev2, *dev7;
 	cpumask_t mask;
=20
-	if (its_setup1())
+	if (its_setup1()) {
+		migrate_skip();
 		return;
+	}
=20
 	dev2 =3D its_get_device(2);
 	dev7 =3D its_get_device(7);
=20
-	migrate_once();
+	migrate();
=20
 	stats_reset();
 	cpumask_clear(&mask);
@@ -819,8 +821,10 @@ static void test_migrate_unmapped_collection(void)
 	int pe0 =3D 0;
 	u8 config;
=20
-	if (its_setup1())
+	if (its_setup1()) {
+		migrate_skip();
 		return;
+	}
=20
 	if (!errata(ERRATA_UNMAPPED_COLLECTIONS)) {
 		report_skip("Skipping test, as this test hangs without the fix. "
@@ -836,7 +840,7 @@ static void test_migrate_unmapped_collection(void)
 	its_send_mapti(dev2, 8192, 0, col);
 	gicv3_lpi_set_config(8192, LPI_PROP_DEFAULT);
=20
-	migrate_once();
+	migrate();
=20
 	/* on the destination, map the collection */
 	its_send_mapc(col, true);
@@ -875,8 +879,10 @@ static void test_its_pending_migration(void)
 	void *ptr;
 	int i;
=20
-	if (its_prerequisites(4))
+	if (its_prerequisites(4)) {
+		migrate_skip();
 		return;
+	}
=20
 	dev =3D its_create_device(2 /* dev id */, 8 /* nb_ites */);
 	its_send_mapd(dev, true);
@@ -923,7 +929,7 @@ static void test_its_pending_migration(void)
 	gicv3_lpi_rdist_enable(pe0);
 	gicv3_lpi_rdist_enable(pe1);
=20
-	migrate_once();
+	migrate();
=20
 	/* let's wait for the 256 LPIs to be handled */
 	mdelay(1000);
@@ -970,17 +976,14 @@ int main(int argc, char **argv)
 	} else if (!strcmp(argv[1], "its-migration")) {
 		report_prefix_push(argv[1]);
 		test_its_migration();
-		migrate_once();
 		report_prefix_pop();
 	} else if (!strcmp(argv[1], "its-pending-migration")) {
 		report_prefix_push(argv[1]);
 		test_its_pending_migration();
-		migrate_once();
 		report_prefix_pop();
 	} else if (!strcmp(argv[1], "its-migrate-unmapped-collection")) {
 		report_prefix_push(argv[1]);
 		test_migrate_unmapped_collection();
-		migrate_once();
 		report_prefix_pop();
 	} else if (strcmp(argv[1], "its-introspection") =3D=3D 0) {
 		report_prefix_push(argv[1]);
diff --git a/lib/migrate.c b/lib/migrate.c
index 92d1d957d..dde43a90e 100644
--- a/lib/migrate.c
+++ b/lib/migrate.c
@@ -43,3 +43,13 @@ void migrate_once(void)
 	migrated =3D true;
 	migrate();
 }
+
+/*
+ * When the test has been started in migration mode, but the test case is
+ * skipped and no migration point is reached, this can be used to tell the
+ * harness not to mark it as a failure to migrate.
+ */
+void migrate_skip(void)
+{
+	puts("Skipped VM migration (quiet)\n");
+}
diff --git a/lib/migrate.h b/lib/migrate.h
index 95b9102b0..db6e0c501 100644
--- a/lib/migrate.h
+++ b/lib/migrate.h
@@ -9,3 +9,5 @@
 void migrate(void);
 void migrate_quiet(void);
 void migrate_once(void);
+
+void migrate_skip(void);
diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index 2214d940c..3257d5218 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -152,7 +152,9 @@ run_migration ()
 		-chardev socket,id=3Dmon,path=3D${src_qmp},server=3Don,wait=3Doff \
 		-mon chardev=3Dmon,mode=3Dcontrol > ${src_outfifo} &
 	live_pid=3D$!
-	cat ${src_outfifo} | tee ${src_out} | grep -v "Now migrate the VM (quiet)=
" &
+	cat ${src_outfifo} | tee ${src_out} | \
+		grep -v "Now migrate the VM (quiet)" | \
+		grep -v "Skipped VM migration (quiet)" &
=20
 	# Start the first destination QEMU machine in advance of the test
 	# reaching the migration point, since we expect at least one migration.
@@ -190,16 +192,22 @@ do_migration ()
 		-mon chardev=3Dmon,mode=3Dcontrol -incoming unix:${dst_incoming} \
 		< <(cat ${dst_infifo}) > ${dst_outfifo} &
 	incoming_pid=3D$!
-	cat ${dst_outfifo} | tee ${dst_out} | grep -v "Now migrate the VM (quiet)=
" &
+	cat ${dst_outfifo} | tee ${dst_out} | \
+		grep -v "Now migrate the VM (quiet)" | \
+		grep -v "Skipped VM migration (quiet)" &
=20
 	# The test must prompt the user to migrate, so wait for the
 	# "Now migrate VM" console message.
 	while ! grep -q -i "Now migrate the VM" < ${src_out} ; do
 		if ! ps -p ${live_pid} > /dev/null ; then
-			echo "ERROR: Test exit before migration point." >&2
 			echo > ${dst_infifo}
-			qmp ${src_qmp} '"quit"'> ${src_qmpout} 2>/dev/null
 			qmp ${dst_qmp} '"quit"'> ${dst_qmpout} 2>/dev/null
+			if grep -q -i "Skipped VM migration" < ${src_out} ; then
+				wait ${live_pid}
+				return $?
+			fi
+			echo "ERROR: Test exit before migration point." >&2
+			qmp ${src_qmp} '"quit"'> ${src_qmpout} 2>/dev/null
 			return 3
 		fi
 		sleep 0.1
