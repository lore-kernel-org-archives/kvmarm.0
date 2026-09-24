Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AEA44C77AF
	for <kvmarm@lists.linux.dev>; Thu, 24 Sep 2026 17:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790271009; cv=none; b=CGafMKQGcvHDQN4UuOBufhylJiuNhGAgTNlmeGYUS9TdRgH1eHYplfJoRx5IqYyxGsveqU5GWEYGjx0LIslbM4sHrITaTFWySrWBHHWkWPI2qA2afI+VSUdimeT4hmcJ6Yz2YLIts+2x0gp9pOYW+ZcSiUKUWPM26l3ek01X2T0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790271009; c=relaxed/simple;
	bh=wEtQJcZvj82M47L7Tjmw+DpGbgxUqRqdySWeYlB244k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nU7/jTe1066XZjWoJdAS5kIOFSivwvPwrfcuc2ykWlfht72m88fXTeFUt2ki4Qigjc1i5NUmFOWoG429fbFccHtib3ZHqj2yE2yg6qM0R8gxZR0inUbMpnMkhhMvARvvI29CXjeBPLIdFwnTPHh9Z6P02rHG/y7MohmYQ8BzLrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=D1FKFibs; arc=none smtp.client-ip=209.85.167.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="D1FKFibs"
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-4cd3e90ff97so140351b6e.2
        for <kvmarm@lists.linux.dev>; Thu, 24 Sep 2026 10:30:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790271002; x=1790875802; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sDXNTscT9mKzWNXLRmPqiMgiEZh+nFQVdJuFACvc/Zg=;
        b=D1FKFibsVa+yv7P/dOBtFVQ0idux5QHI81rRtPyZwYd3znhBsyT5Oy2fmu5H9ROqO7
         DFU+oxkLqWY6N5xV8yuCRsob2hXKtzEFRD6kl4Htv87iEHz8YHezeGtsuv8JEVUiTPBW
         Y8AF6TA9c9IQJ+Ay5F2/jbyv4TtdBfVDqLl2GMPtRJglXDCz2jxEqThRWN+Y1ibjgM4F
         eTJRQZ5KzCjmv//7R65jPjvoNrJYd9u1tqK/yQ/pkzWKW3ywrtj9gUocB6WYHJ+aIFhk
         5kt+HRUsuuuciTrdvjxg8uy9C9pm7hdyoIAy3HRbrz+fxTKhohpctzMRp8BCpHHMcLSc
         VZdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790271002; x=1790875802;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sDXNTscT9mKzWNXLRmPqiMgiEZh+nFQVdJuFACvc/Zg=;
        b=v3h3dx8nrFgOFV/3+0cAzxjuqDTZahXUXnERpfEYkpIiJRSo+B3W/yPal9GGm/XWA6
         Ncb31a0ceqygT2/mufEvVRFpvN/2a6DSHFv77g37hzy1PL2GZhpIdIbNbCVynsmfY5Dn
         4kiIG8vacxBc+mlAPNHg0uu9pQZI7B9bdBLVFrmK7qU/klxOoko87sQ15iTae5y+BFBt
         tb0KTVnqn+JVjll//aUrJ/asRRoz3WHTAjmuVuzS1NjOxdX9Gwefr95YV3mmEUjHN8tt
         V+9Pwpyjf0+Xc0cpWZ1XD9AA6ojRFR8MG9dxyoda3mL3LY7l8mfC40hcKumnOlI4Jc8T
         U53w==
X-Forwarded-Encrypted: i=1; AKwUvBxwXW9TGIrajoZuyIRO3q3KvToFmqemYbzuh9WbAi9ovtM3xyt485YQZqVBMconlI+MxtIRQFk=@lists.linux.dev
X-Gm-Message-State: AFuF++kiz86bfX+k+MVDJij/5Ihc5npT5OLCVI9JP/Gf9VB1z4KDqc1x
	C6hhfoSwXpgS9/DtTELcvSYeLR8q5YMN44DTqQbl3WFQIXMC40xPBPL6dJg73acKby1G0jkg+vq
	PbJ2+h6Gyog+cH05wcGUjL7uh4A==
X-Received: from jablt1.prod.google.com ([2002:a05:6638:ac01:b0:5f1:a6b8:62bf])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:11ce:b0:4b9:a88b:888b with SMTP id 5614622812f47-4d72c739696mr3040492b6e.33.1790271001357;
 Thu, 24 Sep 2026 10:30:01 -0700 (PDT)
Date: Thu, 24 Sep 2026 17:29:27 +0000
In-Reply-To: <20260924172928.2110956-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260924172928.2110956-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20260924172928.2110956-22-coltonlewis@google.com>
Subject: [PATCH v9 21/22] KVM: selftests: Add find_bit to KVM library
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Fuad Tabba <fuad.tabba@linux.dev>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	James Clark <james.clark@linaro.org>, Robin Murphy <robin.murphy@arm.com>, 
	Zide Chen <zide.chen@intel.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, Mingwei Zhang <mizhang@google.com>, 
	Jonathan Corbet <corbet@lwn.net>, Russell King <linux@armlinux.org.uk>, Shuah Khan <shuah@kernel.org>, 
	linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Add lib/find_bit.c to the KVM selftests build using the same wrapper
pattern as lib/rbtree.c so selftests that depend on find_bit helpers
link cleanly when built standalone.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 tools/testing/selftests/kvm/Makefile.kvm   | 1 +
 tools/testing/selftests/kvm/lib/find_bit.c | 2 ++
 2 files changed, 3 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/lib/find_bit.c

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index 96bab7002d39e..cfd1a4fe09ec4 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -5,6 +5,7 @@ all:
 
 LIBKVM += lib/assert.c
 LIBKVM += lib/elf.c
+LIBKVM += lib/find_bit.c
 LIBKVM += lib/guest_modes.c
 LIBKVM += lib/io.c
 LIBKVM += lib/kvm_util.c
diff --git a/tools/testing/selftests/kvm/lib/find_bit.c b/tools/testing/selftests/kvm/lib/find_bit.c
new file mode 100644
index 0000000000000..5534248c663f7
--- /dev/null
+++ b/tools/testing/selftests/kvm/lib/find_bit.c
@@ -0,0 +1,2 @@
+// SPDX-License-Identifier: GPL-2.0
+#include "../../../../lib/find_bit.c"
-- 
2.56.0.rc1.310.g51773c2048-goog

