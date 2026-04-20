Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 600693890EF
	for <kvmarm@lists.linux.dev>; Mon, 20 Apr 2026 21:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776720039; cv=none; b=Y/6ntDpRy1VMTek4Bw6AMoMBoFfdT7HcjAzj3xg+ABUwtjK40HfmAah9yFRDDH5Su17vqSuO8gJ3YuAPKYo5uYVqHScMZRaFD9Z+UNKUA0W77zI9XicHbiI53RtUAheU942vRDq5cxKk1crsHEhFglnTUIf+Pmi05O44Trph1DQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776720039; c=relaxed/simple;
	bh=qI6oBCqdibTVFl6tbO8Uq49A24eLfr4QbQiPcHS6TW8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XOyH/g5gcRMFvBXcXFgePA21R9/Om1aF2AhYIZTmCA2zPy3tmGjly92qmctLVaFCp5v5vPmmn9FhRb1uJ+F66h+sr5bVYgsDoA7Of+xh2eLOTYje4nrD2sOLT9lgb5WgBM/JmyWR45I2aJrxyt9zgi3s/SkI248/QzdsD5ssMAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NVX5hC++; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NVX5hC++"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3568090851aso8470705a91.1
        for <kvmarm@lists.linux.dev>; Mon, 20 Apr 2026 14:20:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776720037; x=1777324837; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=SJ5CEXYUlDO7gWqtPrHpSvURrk9AOobHS7RyhGBvd6g=;
        b=NVX5hC++9vOp/ylpKZdR80uuglLuF5xTmBlhGqwKwNeOdyq+9BKYL2U1mQfjGSm2Ho
         jK0e/2BDAt36sI3dD6YDIuICZ7digmarqAMB2vRKEji0AAEK6GW8uja54mIZ8rAdALAS
         TJeSmjw4i0PMP4961vO1CJa2EYgUhw0T+1MsnDM/VFiFxX7g6ySbR9eCjyNM5uBTxo7d
         jCGIMLG2qjqpNZyy5HSdWT2MiT9Y/9uAaNNL0MQfsmYQ1Z25AEEU4ytcZvdpSe/LyWCE
         0Z46XLdSCg669ctjrkd9KyzIdi05ktQ0MDpYdcIICugjsuekTj2f6Ae36x2ZE+qwOpoH
         OYhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776720037; x=1777324837;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SJ5CEXYUlDO7gWqtPrHpSvURrk9AOobHS7RyhGBvd6g=;
        b=BBXsM/U3TJKseHuQmgxg+5I/qSmDkhGds+034ZyObT27rIEyPOfNcE+tTtxvMsSCRH
         prK58BQTeBsNVaMkmAk1dmcZ6D7syr1gX+uvjZkdqiDI1U1JKIrwqxpKCRWcJqhzlkj0
         Uz2qg25Tc7hTa4WBWpd8Z4Rgwou6iwoebaSR6o+JRzb/EWeBQ4DhLD2tnCh69ch+Zqls
         6CVTo6uN6frfQOQ0olqhGcrA6TI1QBB+6yXbqZA58jAiBIy8OWR4zExkE3tih2i9tkiZ
         mm/Nzn5ikIg4KgrwO1x9Xwyle0N4aAKv6jB5I7myfZcUDQy2axCA+SCdRoB+zqW2ubAN
         pnJw==
X-Forwarded-Encrypted: i=1; AFNElJ9+d4zQdfDMEc6rtqROVKp9JFBy1LIHwmZcswkJDTuFuWxS4PcU8tqTelbvfh+GRBrk31GPXVI=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy6AZFmBvZEO7pGVwGM4auqbwK0EHfqaRaf6LCov59qrE+WiOsD
	Z7B1SsSPFlDEVMU51vbeIhEPKkYlJvyGqRkDGigkBcXgjRh2g+A3W45y/Kq93IWwmc6R3/3fwfs
	pMfAW0A==
X-Received: from pllm7.prod.google.com ([2002:a17:902:7687:b0:2ae:c8e0:1f12])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5865:b0:35e:27ec:dea
 with SMTP id 98e67ed59e1d1-36140493410mr16500380a91.23.1776720036561; Mon, 20
 Apr 2026 14:20:36 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon, 20 Apr 2026 14:20:00 -0700
In-Reply-To: <20260420212004.3938325-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260420212004.3938325-1-seanjc@google.com>
X-Mailer: git-send-email 2.54.0.rc1.555.g9c883467ad-goog
Message-ID: <20260420212004.3938325-16-seanjc@google.com>
Subject: [PATCH v3 15/19] KVM: selftests: Clarify that arm64's inject_uer()
 takes a host PA, not a guest PA
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, loongarch@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Rename inject_uer()'s @paddr to @hpa to make it more obvious that it
injects an error using a host PA, not a guest PA.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/arm64/sea_to_user.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/arm64/sea_to_user.c b/tools/testing/selftests/kvm/arm64/sea_to_user.c
index fb06b9dcb3d9..e16034852470 100644
--- a/tools/testing/selftests/kvm/arm64/sea_to_user.c
+++ b/tools/testing/selftests/kvm/arm64/sea_to_user.c
@@ -93,7 +93,7 @@ static void write_einj_entry(const char *einj_path, u64 val)
 		ksft_exit_fail_perror("Failed to write EINJ entry");
 }
 
-static void inject_uer(u64 paddr)
+static void inject_uer(u64 hpa)
 {
 	if (access("/sys/firmware/acpi/tables/EINJ", R_OK) == -1)
 		ksft_test_result_skip("EINJ table no available in firmware");
@@ -103,7 +103,7 @@ static void inject_uer(u64 paddr)
 
 	write_einj_entry(EINJ_ETYPE, ERROR_TYPE_MEMORY_UER);
 	write_einj_entry(EINJ_FLAGS, MASK_MEMORY_UER);
-	write_einj_entry(EINJ_ADDR, paddr);
+	write_einj_entry(EINJ_ADDR, hpa);
 	write_einj_entry(EINJ_MASK, ~0x0UL);
 	write_einj_entry(EINJ_NOTRIGGER, 1);
 	write_einj_entry(EINJ_DOIT, 1);
-- 
2.54.0.rc1.555.g9c883467ad-goog

