Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EA261BF40
	for <kvmarm@lists.linux.dev>; Sat,  6 Apr 2024 12:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712407221; cv=none; b=hEiL2DfJ3WAY3bw9VTXdh6nhljFBgHp7joe+1j8sdQIGeLX+MuXegfv79Q0FYlbyIPXvZYDU9PAzaWuOYOb67KfP9WIzuvR+rgV7HJoLoVoxu3D3n2nY9UkynP4GDX5uUZxzgRuF8r+wLWDNmOtnLitrwaGiNdfWIJu6UlkXrvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712407221; c=relaxed/simple;
	bh=SBC9goY0qyeWaqVZEk5sqx6PBhg4VTZbRSRTA2YHwJw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qL0h9thPiZLSdw0rdlne0JNpMHM1UgLY0KXZjMDCrhTNClEPM6t2I7y4lk9oopk1+6dszQDaDHcDy6VwGLIVH41/df1veu1DOTdFeX3zF3W9aqTr/9bFdm0kt37aNsqkZKAtifki8G+wTntmwXpaBptBInjW8/aHgkfRFZtaG8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fZRlhnU8; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fZRlhnU8"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-2a07b092c4fso2314256a91.0
        for <kvmarm@lists.linux.dev>; Sat, 06 Apr 2024 05:40:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712407220; x=1713012020; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CWoWbY1l8dnEVRR/nSiK5WHJ8+U9imW08rrrMnGNnqQ=;
        b=fZRlhnU8u/7cV2BDtvfLkdSZEx0zOtxa0svs05F9YA7M88+b0jzA+zGzylHlsoft74
         8X59T/GJ1BFED8dVSbq0gh3DW/d7NouO2R8OS4xJ7sSbZYu6EawKwKW9MBzMtZmHxecd
         sumFh19qhr7ttUeyjKw/DoNumKA4yLXs6BOzhNxtH5yAjkq4hAzkxmbWwCPZ9aQkIegb
         aFvjoQBikoksGNUEH62v97BEiUGBVHEO9hoN+abXSR4RJdl01vz2nnht4tIxne6ge4ON
         JFW2RdQcUiwYOLChBrANwg+8uexjYEooJSRV7GGqSV4kmT+VKkZCQhiTTN/B+PZLstLm
         G9Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712407220; x=1713012020;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CWoWbY1l8dnEVRR/nSiK5WHJ8+U9imW08rrrMnGNnqQ=;
        b=oGTIigAByknDF5TBbrcVkuIz404DBKXRHQUnsZuMAZBngFPvuFjLEMCi4WEmvn/KqS
         oWnkFJdt+lmfq845MHTYC8LN6bnYOHqAfAkMubPuuzFOCzTzVL2o1s5oKO2lA7hMyh1J
         a7qZ+PPHjSZyI8yKg6BG8erTb1IPcImQDNMhep9w/aqYG4N2wOMk+/kARLilI+WW0WjX
         Wb2SqlNGVMH/VnrqAgG+EUKbv+pkNEGcJqSPkiaOUDrRcrN0Vpq88VY1Aojef4uinwIR
         GT3pxmXuRJP/BnGuc24oDLS+RyMnhfq2M7K2O6Ua7J+Wd959JiF6Bk72qyj8g0FyGkVT
         J4Ww==
X-Forwarded-Encrypted: i=1; AJvYcCV1CBxh+U642Aj4Z/kijyP7/mPu1Lmyt7fj25UAQsH5BKhzPTEjh7ZNIlqvr0ecMDSIrFbWPBlA7vwX7MZuXapSniWpyTho
X-Gm-Message-State: AOJu0YxudBwaGGc8ypAshzpPPIv32wweUiWKNM6f7JERNHmbfWwmYVHY
	FtP/xWpbaojAIh/3mbR0+xtispyLcvD2mrjPOyDMZZKZHwRIGukS5hRKJgmp
X-Google-Smtp-Source: AGHT+IFHZE4Fp2p4OLXDHn3qLZhQ0/SVNeTRqByuHLNxp4zQxBJuEy3e052DXS99usoJooGncv3JtA==
X-Received: by 2002:a17:90a:c797:b0:29c:761e:3955 with SMTP id gn23-20020a17090ac79700b0029c761e3955mr3301807pjb.17.1712407219870;
        Sat, 06 Apr 2024 05:40:19 -0700 (PDT)
Received: from wheely.local0.net (124-169-104-130.tpgi.com.au. [124.169.104.130])
        by smtp.gmail.com with ESMTPSA id nt5-20020a17090b248500b002a279a86e7asm5050576pjb.7.2024.04.06.05.40.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Apr 2024 05:40:19 -0700 (PDT)
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
Subject: [RFC kvm-unit-tests PATCH v2 10/14] shellcheck: Fix SC2124
Date: Sat,  6 Apr 2024 22:38:19 +1000
Message-ID: <20240406123833.406488-11-npiggin@gmail.com>
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

  SC2124 (warning): Assigning an array to a string! Assign as array, or
  use * instead of @ to concatenate.

Shouldn't be a bug since bash concatenates with space and eval is
used on the result.

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 scripts/arch-run.bash | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index 45ec8f57d..95b6fa64d 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -150,7 +150,7 @@ run_migration ()
 		return 77
 	fi
 
-	migcmdline=$@
+	migcmdline=("$@")
 
 	trap 'trap - TERM ; kill 0 ; exit 2' INT TERM
 	trap 'rm -f ${src_out} ${dst_out} ${src_outfifo} ${dst_outfifo} ${dst_incoming} ${src_qmp} ${dst_qmp} ${src_infifo} ${dst_infifo}' RETURN EXIT
@@ -179,7 +179,7 @@ run_migration ()
 	exec {src_infifo_fd}<>${src_infifo}
 	exec {dst_infifo_fd}<>${dst_infifo}
 
-	eval "$migcmdline" \
+	eval "${migcmdline[@]}" \
 		-chardev socket,id=mon,path=${src_qmp},server=on,wait=off \
 		-mon chardev=mon,mode=control \
 		< ${src_infifo} > ${src_outfifo} &
@@ -219,7 +219,7 @@ run_migration ()
 
 do_migration ()
 {
-	eval "$migcmdline" \
+	eval "${migcmdline[@]}" \
 		-chardev socket,id=mon,path=${dst_qmp},server=on,wait=off \
 		-mon chardev=mon,mode=control -incoming unix:${dst_incoming} \
 		< ${dst_infifo} > ${dst_outfifo} &
-- 
2.43.0

