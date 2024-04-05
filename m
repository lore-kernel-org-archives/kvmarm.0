Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1984F16132A
	for <kvmarm@lists.linux.dev>; Fri,  5 Apr 2024 09:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712307729; cv=none; b=UfoYWVfLjWJAmVBJvnmMzCQH15U64kGbYQ0zNGgaboPOa9bCehDaeWCLhAaKSnYIHqnhJyAR2I7Saq9ZRJZv3MZFRRlOR+4Iokk7QVdtgtc2dnc9fXfQtXbk22jungzIQYZz1ihJyFPue0GD8IM33q0//81/XIV90ik3EDsC9FA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712307729; c=relaxed/simple;
	bh=47fkLuLqHEZtB3S2cnlevqOMobm0CWU9n/5DYYSuwNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=scN9tU8JgBEsIUbYB329DoweuMQlVYGW7cuxtb6osBCCzsHIVGoaai59LuQEmlMhV8PtcHPvEP9YWS9y1ssLG5twb/uUfsTHurFerxd43w6gcnfP1k093ZgoHW1O4VyJWsSctOUGrdB1QicNY+Tf/gijGte4hXKn/rLWxT2sjy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nLOm1NOW; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nLOm1NOW"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-6eced6fd98aso1444148b3a.0
        for <kvmarm@lists.linux.dev>; Fri, 05 Apr 2024 02:02:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712307727; x=1712912527; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XTMqAyJBqz4rOiSgRtnzTZtMbx0voGPftwqzEIUfG30=;
        b=nLOm1NOWyk9M2XCo1pDr9fER1pqE3/2/UAeGaEpkmtjmih5Ffv59eWc93MXfP0ykFw
         R4eW5DBq49rrD7WeHQ8sim5/wsH3ZwNa891cybxusCg/S7kY/2mj2CUyZr5JefQGbJWB
         b20JZoxmyWdhKiIxn5f82DJeRaAJMQ5TWIfXzk8lg0aNoxPb6JzLnzmIibe6OpzbS0AK
         bUGIEs4OR7Kti6dDW2uL+DnRMOh18IaWOe+Qh/z9R7GcQXQ0/Iq3SI1ILwy/eDfM5Cpr
         wGgBrfMRjw9mWmmRihUq+KELVGgakKsvkBzuiuD9iTemYe9XzUg7iPJCEqL3rebyVR+0
         gorA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712307727; x=1712912527;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XTMqAyJBqz4rOiSgRtnzTZtMbx0voGPftwqzEIUfG30=;
        b=v5+JWv75XqgUDf8JadrmSKcMHoCsx5S6iFyO6Ecl4LXdARwaXdOELkhx3F8KFM5usQ
         BEKLXz490OFYJjCpch9AuGiE45KCxpWSDYOdxI5D9CnofD5PIzof1ryG8p0zLknPIjJE
         RQV4DUhN5hfiRbJ2GlgZXxkfIyNavRCQkfNAojeBhEbkTmvwRtFCm5RvVXqJu62Sq0NQ
         Oa0KzRXZG7Q41KN+OtD3xzj6lInl4zrLDcJNr9p0+yrpcz/bT1b0FyAjAfW2WLNFOe9z
         FGejDALvuP+1/U/YWXue7To+zu0JyLDv9iYcyXdSatxVkIO82wHDGTkHjqMCt/ANFDTP
         5MGA==
X-Forwarded-Encrypted: i=1; AJvYcCV29p9uGdCxEopYkndDxYArKnlZWBO0SUcRu2GnqrJPaLPmCcdbj/kcWRiSqS/4SI5X0wePUecDAovQMH5EetfS7AMNOjO5
X-Gm-Message-State: AOJu0YyyhVBLWXWg9x0PPHCCzMqMyw9dBfvEefL0lWfTu9rZ/4q0REPn
	fFW6U/RXE0SRGZ9ZphmEExXFW0jdhxEJQgkE0+IHdtXFWzz9SIxs
X-Google-Smtp-Source: AGHT+IEXfc3N1ZI16wRWq13BpZo+ByZPJ7Mm8iWXe4JP9NepPrfWkfcdQ8IrIrN/6TID9n4Pw5Bi8A==
X-Received: by 2002:a05:6a20:9785:b0:1a3:a99c:cd4d with SMTP id hx5-20020a056a20978500b001a3a99ccd4dmr926415pzc.48.1712307727470;
        Fri, 05 Apr 2024 02:02:07 -0700 (PDT)
Received: from wheely.local0.net (124-169-104-130.tpgi.com.au. [124.169.104.130])
        by smtp.gmail.com with ESMTPSA id s12-20020a62e70c000000b006ecf25d0b8dsm995783pfh.184.2024.04.05.02.01.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Apr 2024 02:02:07 -0700 (PDT)
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
Subject: [kvm-unit-tests RFC PATCH 07/17] shellcheck: Fix SC2235
Date: Fri,  5 Apr 2024 19:00:39 +1000
Message-ID: <20240405090052.375599-8-npiggin@gmail.com>
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

  SC2235 (style): Use { ..; } instead of (..) to avoid subshell
  overhead.

No bug identified. Overhead is pretty irrelevant.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 scripts/arch-run.bash | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index ae4b06679..d1edd1d69 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -580,15 +580,15 @@ kvm_available ()
 		return 1
 
 	[ "$HOST" = "$ARCH_NAME" ] ||
-		( [ "$HOST" = aarch64 ] && [ "$ARCH" = arm ] ) ||
-		( [ "$HOST" = x86_64 ] && [ "$ARCH" = i386 ] )
+		{ [ "$HOST" = aarch64 ] && [ "$ARCH" = arm ] ; } ||
+		{ [ "$HOST" = x86_64 ] && [ "$ARCH" = i386 ] ; }
 }
 
 hvf_available ()
 {
 	[ "$(sysctl -n kern.hv_support 2>/dev/null)" = "1" ] || return 1
 	[ "$HOST" = "$ARCH_NAME" ] ||
-		( [ "$HOST" = x86_64 ] && [ "$ARCH" = i386 ] )
+		{ [ "$HOST" = x86_64 ] && [ "$ARCH" = i386 ] ; }
 }
 
 set_qemu_accelerator ()
-- 
2.43.0

