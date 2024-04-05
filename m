Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9518F15FD19
	for <kvmarm@lists.linux.dev>; Fri,  5 Apr 2024 09:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712307738; cv=none; b=fkLz0Kj1hbaFzVR+XUInFquM/SQU9JnH66xq3LAUGt53rDoyemS8+7VB/D9tyWeakSLo+udHpsGx6IW6+AFkLvET+RGNf4+o8TFIUOajhiIJvGERI2GWstbWDKMnr/BRseo0T3ZdTuphECYje4uM2RT2my/ExTxYm73ur+qDsM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712307738; c=relaxed/simple;
	bh=D2NZsjGRY1JDUL/nxvnSyIqqAbyckX5TCaIHUVo+eHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pc21UDylOXzVpacQ2r0pG5GTMoyi9EGqzS6EXYDgCUdim52hkXhY9FHXbXD5Jy3FUyIN2Kv2LEftqXE4p5isjqumbQ7152nveNldLEqZSkFu5SloVOnagz8tjqrbf4z5fyFGd4WbUAlBAvqw5qU06huNKEt2W+w4LOsCkf/fwlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Bohth2lh; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Bohth2lh"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-6ed04c91c46so64113b3a.0
        for <kvmarm@lists.linux.dev>; Fri, 05 Apr 2024 02:02:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712307736; x=1712912536; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cohi3aKjv+1U6Puqidh80iZqRFzOJIsMybMNYjaL8SU=;
        b=Bohth2lhTLyyyIwgUw8T2oS5ADemtdlSkDGLlWmp+jnTrrl9DBYhoZhg316OpSZcYC
         nQd3+NdiFJttGybtnPKOzLFcgB5jqMTMndPBY3jvVtLV489syPC0Yfao2nGcaH5utkNh
         S/1oYGpgzcKeuTFpn5tU37Ym4J5ZIATEUfWQcP4uh3l9piNwK+hUiKrWf9LIq70eQYxE
         jbXOOCa2ze8rSpXk2Jo+cgLdVirywCHHTJiaMgEpWAYwWQhpb3wA/62De+lW+fCBVd3O
         U/naMXXSenJV4agIxt985wiSwHBD06QcJQ2chsANfoKL8NHlT+o8MRYj3wCGhG4cU/Bt
         6/hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712307736; x=1712912536;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cohi3aKjv+1U6Puqidh80iZqRFzOJIsMybMNYjaL8SU=;
        b=o2Mv4RnHmJQkLSVydlsldCxgl4DI7c/qedIx/qfJO6dtQmWuedO7V//7ASLEfrnGM/
         FZXg3V5BjkEg0o/behfzFuSkIzvMhCUdojRCebl64HSw7iNN24zU2aQ3vce1879vr2SZ
         TiyYvR+BgC7YLFDGnEUx1NXIpYl7/AW23pnV18gIYlyeCKfSLWCfCJ8kzLAT5o1Olz7g
         +r/fk3y8aeTNod3sKAmNhKiOxTSTU9PH1++hsXAAAUNyUVmAqmruC1f4dY6u97d4MKla
         6U7z3e68pOOU6ucJ7HMSKCPW7pYpA1vtcXv4XPnrDaQrgjnrTgr7fiH0iscKE5RNeFPQ
         wyig==
X-Forwarded-Encrypted: i=1; AJvYcCVJaP6Vw1yAkVKKOzbluFX45+1qEjZmsqdaId1jzjnExJ4775LZmEf3U9M8sp50Mc4mSRNTfaXJlSyceBHSMxcghiTiBVW6
X-Gm-Message-State: AOJu0YwuIYM3PL211SH3ogmBeEjXigbZZiWl3YqdfFu2h401bpimGkeA
	oMOinrU6/uicCbnyMymKSJ3XwhG4Ac8YUqs7OV5w061RWmTFo3pY
X-Google-Smtp-Source: AGHT+IG9dVdT+vakcHxy2GC/HHhs+O8CS4HJBxtK610mZlct905ZAPsg+YVWeNrmXHHatzgeuDW9jQ==
X-Received: by 2002:a05:6a20:8d24:b0:1a3:c8db:97b7 with SMTP id q36-20020a056a208d2400b001a3c8db97b7mr713286pzi.47.1712307735963;
        Fri, 05 Apr 2024 02:02:15 -0700 (PDT)
Received: from wheely.local0.net (124-169-104-130.tpgi.com.au. [124.169.104.130])
        by smtp.gmail.com with ESMTPSA id s12-20020a62e70c000000b006ecf25d0b8dsm995783pfh.184.2024.04.05.02.02.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Apr 2024 02:02:15 -0700 (PDT)
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
Subject: [kvm-unit-tests RFC PATCH 08/17] shellcheck: Fix SC2119, SC2120
Date: Fri,  5 Apr 2024 19:00:40 +1000
Message-ID: <20240405090052.375599-9-npiggin@gmail.com>
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

  SC2119 (info): Use is_pv "$@" if function's $1 should mean script's
  $1.

  SC2120 (warning): is_pv references arguments, but none are ever
  passed.

Could be a bug?

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 s390x/run | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/s390x/run b/s390x/run
index e58fa4af9..34552c274 100755
--- a/s390x/run
+++ b/s390x/run
@@ -21,12 +21,12 @@ is_pv() {
 	return 1
 }
 
-if is_pv && [ "$ACCEL" = "tcg" ]; then
+if is_pv "$@" && [ "$ACCEL" = "tcg" ]; then
 	echo "Protected Virtualization isn't supported under TCG"
 	exit 2
 fi
 
-if is_pv && [ "$MIGRATION" = "yes" ]; then
+if is_pv "$@" && [ "$MIGRATION" = "yes" ]; then
 	echo "Migration isn't supported under Protected Virtualization"
 	exit 2
 fi
@@ -34,12 +34,12 @@ fi
 M='-machine s390-ccw-virtio'
 M+=",accel=$ACCEL$ACCEL_PROPS"
 
-if is_pv; then
+if is_pv "$@"; then
 	M+=",confidential-guest-support=pv0"
 fi
 
 command="$qemu -nodefaults -nographic $M"
-if is_pv; then
+if is_pv "$@"; then
 	command+=" -object s390-pv-guest,id=pv0"
 fi
 command+=" -chardev stdio,id=con0 -device sclpconsole,chardev=con0"
-- 
2.43.0

