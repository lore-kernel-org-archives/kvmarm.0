Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2D101465B4
	for <kvmarm@lists.linux.dev>; Fri,  5 Apr 2024 09:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712307712; cv=none; b=VT32a4P/MvD/jG7cZYQvL3guzzFckn+GpAjR4sHkTHfHeCGrWaT3OWa88A7ZzB0NU4w/UtX/EJUWT5zjf4Xfrffg2KpSZa8otp9g8YwK/HYYm7PSyo0vRBA9WDkzz7cK+sp4D5iykUKlcf+pO9rIag5zJiBed8OdHNWxFhxJ/m0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712307712; c=relaxed/simple;
	bh=4g1r/UsnPqbm9eIN4ayWeeOIX2i8p9mAV/a9qMDvTH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o0vJAfGXlllJASp1IqRuYXrTLCm3u3GixrQq9FInaZzpMjCkKJ8e5YNLMz8+u3iYOPZOZ/idFaG4xBPtXETQY4ltxe/bqFVASsvOXOTOPuXDmfv0i8CYSLoiVWpHV2fWLtTIGxdyFx/Ykpisw5lq21mtirGYOF/dCSSJrO5eJoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OsCprRdw; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OsCprRdw"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-6eaf9565e6bso1439811b3a.2
        for <kvmarm@lists.linux.dev>; Fri, 05 Apr 2024 02:01:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712307710; x=1712912510; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tE5LrHkhPWwsD1wVtesjtmAMJJFllrOtQDVtshSFCEA=;
        b=OsCprRdwOAbztvRGLsWhnVYIlbGYwp+3BUznurKPBhpffW2qIcaGLbRqpo/IM94060
         uFIRnQalfygHYe9fY61vF2hsvmk6UkkcmLlUkcdxLkftoBhKRuMdIO+vSBrsk4FOApAC
         Qxz7V/RQXju4oHy7DhRHTY/cqzEF+pVAetj0XhwOjiIe7crwXEg5NfOiFEx+YSl66piQ
         fUG0b6eg46mmkzR3RxL+ntk1c496yyQsQhgfX3StDdnJeAQegSmEQp0IUwRHeWsX8DXf
         7+OtxjI8yFYE0XiHOSi8qvMtKye4m8OMP+3/NuLqzySs15pwD6y/VRJjKf3P0bQW2gFl
         tWFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712307710; x=1712912510;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tE5LrHkhPWwsD1wVtesjtmAMJJFllrOtQDVtshSFCEA=;
        b=OGOLjbj+RyxJcUrQZujfB7aj7t7GGg+zvyjAkX150Th2jS4tfD4k5F3mgdxzDI2zm/
         Tb0RwECfMv2T2jA9hFoZjEPkmAK/J2fKjodgJjk2UvwfMLCBCNdX6BFlgTu41BabMkTM
         C4llkexjInLv+RUx84XiHoBhEv7uiCLj2acva2pBXFIgtU9joNG86P85O7302s+KnP14
         MpC2VCcyxADlSPGilNQGT9fxTfGDvIbBTouO2bQJgOVGPAaR1ziR5dx9Mi00RgA5Ep83
         mUS5cAdXO9PE21puO6sukzToo+uOQCPrnb8HpxgiUaY7Zr8+gjEo6BcFeizmKQ9mN15x
         VOVw==
X-Forwarded-Encrypted: i=1; AJvYcCXuE7tl2rN+MHu0+QCCokqplvBZaEnzPtX8j0Ok6QHjOHwR+jbHNWAhtSMECB+KrIkJszVcYpUaLeb9XuEBWaZgEW+vc0cx
X-Gm-Message-State: AOJu0Yxl6rNVZ4uNzDAp3VqjOv3A3HKNcCkIaFun44QmKesVUDmCrpTj
	blX7knBJV+sQrQuOQt83gdPJyzCDOYRmvgQsDA7TqTnbGNJK+1UQ
X-Google-Smtp-Source: AGHT+IG8zRLKzBiTQEfRs0hBIeVmr7NK/SMycA7/nOPbTjd9DY0AzfGVwPzzqjCddECVKUaZg6xLKQ==
X-Received: by 2002:a05:6a00:988:b0:6ec:da6c:fd42 with SMTP id u8-20020a056a00098800b006ecda6cfd42mr1095467pfg.5.1712307709981;
        Fri, 05 Apr 2024 02:01:49 -0700 (PDT)
Received: from wheely.local0.net (124-169-104-130.tpgi.com.au. [124.169.104.130])
        by smtp.gmail.com with ESMTPSA id s12-20020a62e70c000000b006ecf25d0b8dsm995783pfh.184.2024.04.05.02.01.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Apr 2024 02:01:49 -0700 (PDT)
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
	Nadav Amit <namit@vmware.com>,
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
Subject: [kvm-unit-tests RFC PATCH 05/17] shellcheck: Fix SC2006
Date: Fri,  5 Apr 2024 19:00:37 +1000
Message-ID: <20240405090052.375599-6-npiggin@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240405090052.375599-1-npiggin@gmail.com>
References: <20240405090052.375599-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

  SC2006 (style): Use $(...) notation instead of legacy backticks `...`.

No bug identified.

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

