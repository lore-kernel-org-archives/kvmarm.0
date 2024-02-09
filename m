Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1086F657A3
	for <kvmarm@lists.linux.dev>; Fri,  9 Feb 2024 07:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707462168; cv=none; b=mGEMwbXuxMjLOahZ8DOsH3RGn/4rQpWPSbsjj03QD9OX3tZkhZ772NOpLl+s5nbIEFCmXy5RAAPmsRm73dg0yly25ApAT7V88nHwpH9+IiFcctL5TTkuav6DJUeVqOwNsj0JcHG+8rV5f9fJw4ykqt9/MjPKOBmhsE9HyYkBT+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707462168; c=relaxed/simple;
	bh=2We+TY3TrSFlAYJp9qjCOG7hr8bE3hpOyLxv0thXofA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dG0y74AL6knFrumvaUE0M5qUna96btytcLRCbMvBv9oRNpMDQgCYg724uUgZylswjox3goIdt3+O9xhTxRU88OdCTsJh4NDzbOCHdmDfBGYs52ClkzuuURN5EvW0nEUVxckyMc8mKKgxOTYgIQ1VLLjOhn4vAR0yM7B02u9Y9DM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SM1YypCf; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SM1YypCf"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1d958e0d73dso5126755ad.1
        for <kvmarm@lists.linux.dev>; Thu, 08 Feb 2024 23:02:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707462166; x=1708066966; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Qsb66D3Bdnju/B4wMjZRE5sQcB0Os6ZjxNoeFhHSgYI=;
        b=SM1YypCfOOBE2vf0j3CXyAqlA5jc7NpsQorD1W5BpYULoIXrL4UJm31YbcNCkzV2dY
         pxp+vrKpkV+C6dPs3kkW/uEr9Tg+1h29RU4rom3YDe8JdYEZdHhglosLCB7rVGVleoUo
         w0tzKOVIiW+30W34Fde6972RvSbbMAN1ucixprpvNFvTltUwJs+2YxwAybXTUku2Wlm/
         amFwAIj8EucBZu6p5LCg7Gd8X3Xq89KO3QhDPr5hOZi58TOb6DYfW/pW8Elw4D7EuR28
         F+dFPkLg6gwQHj8ZtC10hBIEWPB0UtZk0QHAhmGf6OJL5JKI6Sxi/Teov4Fxu3kjPniZ
         uyOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707462166; x=1708066966;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Qsb66D3Bdnju/B4wMjZRE5sQcB0Os6ZjxNoeFhHSgYI=;
        b=hUV39F8b9pQxk84LG87kqajG2BcbXTc6FiAd4l3btgDyn5ORLfbqkWXt83pZxRhapO
         gb5jes72/4c6itfYbLhFbdRklTt8MJuoFiGrzdtyHqUs7dqv1XK79UEQjw9AS32vxN1m
         z/AxAmzayWYvAibG2cVD8GQ22Ytm/oi2Y1hUj6iLccqQzIunX/myapRSu/wlDCv5CyoQ
         ubLDg1ZiqD/XZOMLvlbtPxFqfoJ6ejwywHhSjls6prniYnyQkb6BaHTxvNK9dNWU5/XI
         B2DULMj4tXvn1kb2lEEVMuYB55wRTO6rfk+0gssZYCmbJkRXYtPwxTgFU19Ja1hqi5BW
         S00g==
X-Forwarded-Encrypted: i=1; AJvYcCVcETAw/t4wYmo5Am+6nPV3JoOYcM+EFik1WNr8CxWBTCvypiFUNhEoMxX5SZiWaBVAbD6Wn+87oOE6JqXvpVzDTWRo6hdb
X-Gm-Message-State: AOJu0YzO0ThxlM9rkMROfK9G0zbjeZW1z3v4XujDMEXrzaAlXwRncAyf
	yRvu8hn58hlhoKEE/VbinlBDR6p9sD8zrE2tV01lRfT31OkDBkwP
X-Google-Smtp-Source: AGHT+IHU0yLvmoVA6RKCQ6uyd2pMX3xvxjI2eIt3+EkdLZ4rFtP2o0Kv2c+t5MKAEvXWGxoEJoqkhA==
X-Received: by 2002:a17:902:dac4:b0:1d8:ff72:eef8 with SMTP id q4-20020a170902dac400b001d8ff72eef8mr252746plx.18.1707462166439;
        Thu, 08 Feb 2024 23:02:46 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWUS07VqJtp8QffWN3zhicRM8LYt8elB5iTOnmCfZ9yy015fREDprJMZMviRnS98UcXQ/VxQw5ldSNprvJDhbVvdZ2iTvfcBiAjIzZfqX58zO6C8/i7isMINudyqNMaFxktdnnzLNazq6uh+2kKcYxmW4vZDXt8HbVI8+QYEcbcIRlCYgMvivyCqBZ6LkfiVKkaqRVhOnH1HSaJkFlOP64LphaRgHUHEniYyVPhgJ2cftwYq3LZ8hQtH3X4i94sQ1NmT12Uu39pJiWkIUij9SP4kCLNt41SD0xaEIECmybtiFoq1h7Fkr3ziDK8J0m7NyoAcZ9UwSVZivUHtCuYCt6i6nZMHfN2FIL+UC4mt/7Vt9FQ4OftEaUD4g0Uj75ilOzRkKQiRzXv2CJAB7cV7goDUn40aKB6FotefYlzCEHOwttpUYJdMEU+iksnfmeV0C1WAhxVF6EOkXiv/2qUsbmlWT/TJBT5tupgBrXLQc4X/zjmDQsWKW/5uB/n2l1aRYc2ChurcIcQZOSF9H1AL/ldjQ168IPS9m45kha/V5LyIKKwVJYZc17j
Received: from wheely.local0.net ([1.146.102.26])
        by smtp.gmail.com with ESMTPSA id r10-20020a170903410a00b001d7284b9461sm839285pld.128.2024.02.08.23.02.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Feb 2024 23:02:46 -0800 (PST)
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
Subject: [kvm-unit-tests PATCH v3 6/8] migration: Add quiet migration support
Date: Fri,  9 Feb 2024 17:01:39 +1000
Message-ID: <20240209070141.421569-7-npiggin@gmail.com>
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
index 0b45eb61..29cf9b0c 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -152,7 +152,7 @@ run_migration ()
 		-chardev socket,id=mon,path=${src_qmp},server=on,wait=off \
 		-mon chardev=mon,mode=control > ${src_outfifo} &
 	live_pid=$!
-	cat ${src_outfifo} | tee ${src_out} &
+	cat ${src_outfifo} | tee ${src_out} | grep -v "Now migrate the VM (quiet)" &
 
 	# The test must prompt the user to migrate, so wait for the "migrate"
 	# keyword
@@ -200,7 +200,7 @@ do_migration ()
 		-mon chardev=mon,mode=control -incoming unix:${dst_incoming} \
 		< <(cat ${dst_infifo}) > ${dst_outfifo} &
 	incoming_pid=$!
-	cat ${dst_outfifo} | tee ${dst_out} &
+	cat ${dst_outfifo} | tee ${dst_out} | grep -v "Now migrate the VM (quiet)" &
 
 	# The test must prompt the user to migrate, so wait for the "migrate" keyword
 	while ! grep -q -i "Now migrate the VM" < ${src_out} ; do
-- 
2.42.0

