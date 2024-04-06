Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90E002D05E
	for <kvmarm@lists.linux.dev>; Sat,  6 Apr 2024 12:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712407177; cv=none; b=mOsNePebC8YqcrCh6h9mgO9ZLDVuSb4z+JNy5OuB1/Hvh706fa0tahrBAGGK2qj1nT7T8dgbmcbAMTuz9ZZA4zYaScnjEQN3jk/8L+6UHtKc9J8l3O3zieD1OEoYDb6fGbuuVBXp+vAZreVSUMz+fECcf77ZIpV+2urrox0keE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712407177; c=relaxed/simple;
	bh=U34po4updKQxQ4IZ87lCoa6hfZpy0R9FdoTvDox5LYE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OqRjrAhDvQTJFBD8q03d1Ae+GrEWPvZeE196dRVNbzg4DfynZxn1ddUgBYD9s+B9Om7jH3TPw5MHvKqMu0jfqLP7W8KIEkhRU/6EQOs/Gt/IakYhykP5UsHabslWN4xbuq7Fg6TcO9BlKG1rwUce0rR64iuqQ4NLVHEd2N3F1QU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZoKzxxcD; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZoKzxxcD"
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-5cf2d73a183so2923777a12.1
        for <kvmarm@lists.linux.dev>; Sat, 06 Apr 2024 05:39:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712407176; x=1713011976; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ctDYQgLStioQbOFeEtouOSGyQc9IUR3PlFjjsp3HZ2Q=;
        b=ZoKzxxcD3/9tQsIF2uaAn0RqiRFC1j7blEVTknNXhkUuuSJp2CWhs36zwHZ1eAK4wr
         Z+6yCf3Jmhj50WN+pfNMFwSg4fi2HGl8/tZIPfc99O04OLF3L8zQaGZlVcV0HO15w3mE
         BOFaRCqvn+c1Oo7EH+UvK78CPwpn++Z3JqyizTVxvyd/A9aD3vetIjgTGoOZTjd20/qM
         St7oPrKPkPvlvdQy4I5oFA4NIwSYl7g8pF7M7BEl+gPpdJIvZYQygfbBj4inbt/49E9s
         Ra12uNjfKa0jk48m1L+8nItI1c4TAOTviycS2a91sZDsYQjtbNyPmVbOYHNoXy2RicCJ
         U/JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712407176; x=1713011976;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ctDYQgLStioQbOFeEtouOSGyQc9IUR3PlFjjsp3HZ2Q=;
        b=lQlx97P9S2mYHB+J0d9Pkdgpquu5Th1XPJcB0BBUIpI+C4UtyK1dLXfNbpHQCskP4V
         I3NH8pAmKKeCuJ3SK7m+3PNWz3OLYyNZYdzkKjAbxYg8PCh2lrkaIAALNjlLvIvr9nr/
         4ELNMB5NPoTCXO+T4QVhvZtnxtovOIllx4ycq1o2R7CTzv+yUVNMfaK2+DBRSIyIT8km
         F2/0NYnMoKtGBVbXUAqRnchtYWOVlhsei4j2HY1YVyBq8o8GBNGUPF/iwOjeH64FmzbM
         ikph27kGEkiJruqPP5MIFLbxuvTB2pLL+BWiRjKkh2ZxzoT7EfkBzXH9t6C39ezqhbcQ
         qiew==
X-Forwarded-Encrypted: i=1; AJvYcCVMdm1B/Olbnatk0j50mkbU38jS/T7B4rpPYZgGN14do/sdN8991AOpz7qcEttj5VcDUIJ7xgSDspd1VwhYL7y0FrInxD9t
X-Gm-Message-State: AOJu0YxE/sKYB0AQKsr2yVpn62xeeK16MjDQBtcGtD3FbyqaXQFre+2E
	fIKCKAM3fPqO+krFPxQxzDSluMSFn52rJ+52JQclCmni2YW9UoPv
X-Google-Smtp-Source: AGHT+IFubLHuw+tn9P2k0qkE0L7n1y54S4hs/qXXktspKqdJ/DtIjqspW0ZznPjBc8pACbaNSoegBA==
X-Received: by 2002:a17:90a:1109:b0:2a3:846:6a45 with SMTP id d9-20020a17090a110900b002a308466a45mr6611290pja.5.1712407175820;
        Sat, 06 Apr 2024 05:39:35 -0700 (PDT)
Received: from wheely.local0.net (124-169-104-130.tpgi.com.au. [124.169.104.130])
        by smtp.gmail.com with ESMTPSA id nt5-20020a17090b248500b002a279a86e7asm5050576pjb.7.2024.04.06.05.39.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Apr 2024 05:39:35 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Andrew Jones <andrew.jones@linux.dev>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Eric Auger <eric.auger@redhat.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	=?UTF-8?q?Nico=20B=C3=B6hr?= <nrb@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Shaoqin Huang <shahuang@redhat.com>,
	Nikos Nikoleris <nikos.nikoleris@arm.com>,
	David Woodhouse <dwmw@amazon.co.uk>,
	Ricardo Koller <ricarkol@google.com>,
	rminmin <renmm6@chinaunicom.cn>,
	Gavin Shan <gshan@redhat.com>,
	Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
	Sean Christopherson <seanjc@google.com>,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	kvm-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org
Subject: [RFC kvm-unit-tests PATCH v2 05/14] shellcheck: Fix SC2006
Date: Sat,  6 Apr 2024 22:38:14 +1000
Message-ID: <20240406123833.406488-6-npiggin@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240406123833.406488-1-npiggin@gmail.com>
References: <20240406123833.406488-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

  SC2006 (style): Use $(...) notation instead of legacy backticks `...`.

No bug identified.

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 scripts/arch-run.bash | 6 +++---
 scripts/runtime.bash  | 4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index 472c31b08..f9d1fade9 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -271,16 +271,16 @@ do_migration ()
 	qmp ${src_qmp} '"migrate", "arguments": { "uri": "unix:'${dst_incoming}'" }' > ${src_qmpout}
 
 	# Wait for the migration to complete
-	migstatus=`qmp ${src_qmp} '"query-migrate"' | grep return`
+	migstatus=$(qmp ${src_qmp} '"query-migrate"' | grep return)
 	while ! grep -q '"completed"' <<<"$migstatus" ; do
 		sleep 0.1
-		if ! migstatus=`qmp ${src_qmp} '"query-migrate"'`; then
+		if ! migstatus=$(qmp ${src_qmp} '"query-migrate"'); then
 			echo "ERROR: Querying migration state failed." >&2
 			echo > ${dst_infifo}
 			qmp ${dst_qmp} '"quit"'> ${dst_qmpout} 2>/dev/null
 			return 2
 		fi
-		migstatus=`grep return <<<"$migstatus"`
+		migstatus=$(grep return <<<"$migstatus")
 		if grep -q '"failed"' <<<"$migstatus"; then
 			echo "ERROR: Migration failed." >&2
 			echo > ${dst_infifo}
diff --git a/scripts/runtime.bash b/scripts/runtime.bash
index 2d7ff5baa..f79c4e281 100644
--- a/scripts/runtime.bash
+++ b/scripts/runtime.bash
@@ -61,9 +61,9 @@ function print_result()
     local reason="$4"
 
     if [ -z "$reason" ]; then
-        echo "`$status` $testname $summary"
+        echo "$($status) $testname $summary"
     else
-        echo "`$status` $testname ($reason)"
+        echo "$($status) $testname ($reason)"
     fi
 }
 
-- 
2.43.0

