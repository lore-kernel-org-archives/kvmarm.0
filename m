Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB97215FCEA
	for <kvmarm@lists.linux.dev>; Fri,  5 Apr 2024 09:03:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712307802; cv=none; b=kcOxBF0squ9b6am4NVocM32nVeZChZcIMLmDVEbSVpVJ5/O1PEPkMS6R2icx80jh168qUsgdDtQLsCjElinWJz91BCKSpYm3F5HUMP93yPcGwwMNNJTZvs7to4iHv+QvifwC13rGWNC0UtOJkAkQgiLrgo9EV+BQPMTP3Xwtfo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712307802; c=relaxed/simple;
	bh=Q9N10wDNVQO2Isx1GrQkRJ55/A8RSrRwkxpCPQXpaCY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DHJp9NXaIFDBbnwn6cyoMu62n5P2D75aFYYCgagK8sd+on8xLwD6c6E7Vg6N9wOU/upRXAYWRwrHUwLvSTiBIQlZwVhJcdpPIzX2uVz9gSofLduwegWfdFnrQ2bT8xcm5zDqgpOr958kA0pWUG+veOPY0uqbCL7hXb7EnWubvSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Fha4fyJh; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Fha4fyJh"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-6ecee5c08e6so1582582b3a.3
        for <kvmarm@lists.linux.dev>; Fri, 05 Apr 2024 02:03:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712307800; x=1712912600; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WZoPeMi4EUbYS5bzq/p7KT/LoRuIgjUs4gHO9gJQvmw=;
        b=Fha4fyJh0I1OrCBhrHMs+PVO1BmS7HbDGZMpCS4mpCL1+5i/mMXXjx5ktvcfAet6tU
         6NrArlcPtdkhxOrSEPq0sUTW3ee6bMA36iAil+f6TpQXWe5xDBsW7FJo05033W2Nl3aM
         w4eqymp1XNrOcdiSVd9KfX2UtfEZmjmkDH0YNMt9qcbd3dfUl9G3sornxnt7rvTnpi8b
         S3i2OZEbnWKpSPjPtwx+1PZ8Qn+qHe/N7PJddIUlhR4D+zebxvGSQ4zKTTJDAMsBkFNQ
         xEnajOHhfM3rat5zwT2JaD3K4Kg6WIts3JFbCE+NqDd5bImG8KYCfnUQ130g5yB0w2hX
         1hLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712307800; x=1712912600;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WZoPeMi4EUbYS5bzq/p7KT/LoRuIgjUs4gHO9gJQvmw=;
        b=j76FiQGD3BkXS2mr+y3FJLTr+NELLg8dXNFcnvqDKJmzmbfeUh2KSuLdc1/M5gS2xf
         VsUvEzLo5T6QWLnve7neZGLTzSFv7XZ/M7qJMKW6pLE0qgHJQVFmYH5SM+UG1SQosssi
         ueE1xhtMdm8fOFRxpZJKvPV7o1IobJrJUekjwxig1W4mCNBuWwQBjDB/cr4EI3jKTZ6d
         uGzso8rmKPzk6k+K9xr39H4zJF6Hy7qEZv/xi+6aXd3xCCxx0PHPuQQ7JByZEOfboACx
         sthygyNtOPtwoayOykMBUcE2lETU+SMlbjU5NBOz2SLVCtum110T7lED0l1GoQuvOv6L
         5UcQ==
X-Forwarded-Encrypted: i=1; AJvYcCXuK3Xvr2egw0xiSQbZvR9OWPzg/dtkREXdSRnpAAD0PjsGAfjLw3deMreK7YfU3WlkpmOSLUjeRaI5Rve9xqm91mrid5oP
X-Gm-Message-State: AOJu0YwK1qiSoiFjgr6cTjAjdnc6F6G25hDhzm2ToK9D231F80Z8YOFk
	qmmYtmbJ9m5BHIvQPe44ZP6yFvweco09EWR8DPqSDEsuboz+HHdb
X-Google-Smtp-Source: AGHT+IGhF6M+sYBw6xULHEvA6i3LuA5ZQUV1BEY4WWHLg6fW1cN5WbIu03G3AJlZbUnpEKHDGrYjVA==
X-Received: by 2002:a05:6a21:9996:b0:1a3:55d2:1489 with SMTP id ve22-20020a056a21999600b001a355d21489mr1068416pzb.7.1712307799958;
        Fri, 05 Apr 2024 02:03:19 -0700 (PDT)
Received: from wheely.local0.net (124-169-104-130.tpgi.com.au. [124.169.104.130])
        by smtp.gmail.com with ESMTPSA id s12-20020a62e70c000000b006ecf25d0b8dsm995783pfh.184.2024.04.05.02.03.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Apr 2024 02:03:19 -0700 (PDT)
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
Subject: [kvm-unit-tests RFC PATCH 15/17] shellcheck: Fix SC2048
Date: Fri,  5 Apr 2024 19:00:47 +1000
Message-ID: <20240405090052.375599-16-npiggin@gmail.com>
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

  SC2048 (warning): Use "$@" (with quotes) to prevent whitespace
  problems.

Not sure if there's a real bug.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 run_tests.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/run_tests.sh b/run_tests.sh
index 116188e92..938bb8edf 100755
--- a/run_tests.sh
+++ b/run_tests.sh
@@ -44,7 +44,7 @@ fi
 
 only_tests=""
 list_tests=""
-args=$(getopt -u -o ag:htj:vl -l all,group:,help,tap13,parallel:,verbose,list,probe-maxsmp -- $*)
+args=$(getopt -u -o ag:htj:vl -l all,group:,help,tap13,parallel:,verbose,list,probe-maxsmp -- "$@")
 [ $? -ne 0 ] && exit 2;
 set -- $args;
 while [ $# -gt 0 ]; do
-- 
2.43.0

