Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14F45225791
	for <kvmarm@lists.linux.dev>; Fri,  9 May 2025 14:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746801214; cv=none; b=X42OlY6D4cpNYmZ4tfZLJlBSwITkGkqe1cIU/rQ5OzGHzm+A0axiCvSZXgBwoCRce38EK9pSa6gbQa+9Oyrb+gBJSjxMHLOyPAmY+fyunWGPqY7ki5mzp8OqWc1teIhrUTkuzQzHhSpPqyjUoa+HXoL/MF2wTqeu4SXzQjgI60E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746801214; c=relaxed/simple;
	bh=cOsu4Qrb+3bx73g5aMRxtPG7+Gkx5amoz9G8WVXNU9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=ipqdq9KbDv8w3lFyAyt6fiJUFyjzskVaxonjYLVdAN1V8/57CbPqECDn1HOg45poaCdhya1k61qPKkBaHxM2JI4RwNk3g3WrYEkoptvgU5KzGqcCmKs4Vz0ac5mGLLdtEir/DhHv00Jj0hSFZjXZ+z5U0/3RNHEfgRtVJIar1T4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=i3/Q7oZ2; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="i3/Q7oZ2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746801211;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HiFig5XrzaKxrne/VffAS5Dccms79XHv1+bktez4Dgg=;
	b=i3/Q7oZ26Ha4lKrJcPc1rTenXA7nXfR+8fNDHL6pZzfl587wjNkBPU7v5uDFhO7Ag3l1bE
	8nBYAjlP+6COkHOO4VHxDtHzahCvD+s1jBkub0V4oQYEdxqw6tAlLZjesBrG7ytNQEvOdy
	qiWVpCgQGuJzE7gU+EHMDbm+jkHyffM=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-119-pewYNeruP5WBSH0zLgQ02w-1; Fri, 09 May 2025 10:33:30 -0400
X-MC-Unique: pewYNeruP5WBSH0zLgQ02w-1
X-Mimecast-MFC-AGG-ID: pewYNeruP5WBSH0zLgQ02w_1746801210
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-43efa869b0aso15226055e9.3
        for <kvmarm@lists.linux.dev>; Fri, 09 May 2025 07:33:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746801209; x=1747406009;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HiFig5XrzaKxrne/VffAS5Dccms79XHv1+bktez4Dgg=;
        b=wuW3AM20s+vS5QQEJH9hXZR84Eu5ZVIHuQrnNJt9wlHAgAOheZzWzrl9XGumtfwOph
         UXryYKfUdLCadU8dEEMCT/iAyAV5hu8bEvGBLTj4zlpT5YYNA+AIidgtAgYYiCxtNRSf
         EckM7QzWThXsJHRgq5vV1xF4ZW6AKiTShJSwv643J5uTBtCm3uBJTqioaP93IzO7pFXp
         S+EvuBt+nldfEkptSnZX5FdLiJrTbD4CiDhd/YYhJLoE5V3s3YUaAY+7KkJq7DYbXz5N
         ZpDcnAjBrDLyu6dOeJyZaccnqrqx/urnOA7wKE5rQB5ILVsMdXd2aD3oyA78N/0yoPDa
         CEAg==
X-Forwarded-Encrypted: i=1; AJvYcCWovPuSmZisfeNSVWNKtHBneUIBQWLhAytXDwE6pvbR9vRZ4PwWEOUDJ6DajWcVGyGPhsZkJ2c=@lists.linux.dev
X-Gm-Message-State: AOJu0YxVd/tbqW1a+i5FhJvr/BKBCYs587hHMsJQuVFrXPsHzMG/2fqA
	o0HFSM+ML3lLCkLdmlqntLihgiESXI4dhvxLDqeTQVG1P/eWq47D/LqsWJCRQnDMMaqGI2B2bvS
	1pSDmx5I1NKdHSqWnZbVNtgvmhLrCaMJOQaWsSLCng6aNLv3zmabQkw==
X-Gm-Gg: ASbGnct1D9A6hr7AHd7zH+Toz+mXj7+XZSZdFJNeBKMrs3w3mxqmJgX8Ri14T38Df2U
	MaHYhMcl8aQWgAsilz0R3C947I2ENymf8tNfdV68S9DHtaz3nWky755R9A82dlmZYTHAyoNkSFy
	JpACWmUuwIaWxfoRIHRgaPUAYhRn8G3TovKOEvnH5JYlpx/mdH0dcdRTqnTm4sV44yzdmlNYxNp
	MxLSUx3N4ooxtTqd/xL8w1yCXV8JeqUUa2r5aV8BdvUmICRh9jPtoamTBChqtmN/4moXjumOCmd
	F+tWqYsw5tH8ip4AIyzKcPScytfmWrA4t/cdScG8RVB2HAF8sozjrp036F1yQbJg46geJPrs6gM
	=
X-Received: by 2002:a05:600c:6819:b0:442:cab1:e092 with SMTP id 5b1f17b1804b1-442d6d1fadamr28832945e9.11.1746801209569;
        Fri, 09 May 2025 07:33:29 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE4IBkLXeH3i+YVDUJRmaB8MUsHfZ+AUrzGIQQxg7u/gveAvDEEBf8Vr8fYNwiDc753UVZiWA==
X-Received: by 2002:a05:600c:6819:b0:442:cab1:e092 with SMTP id 5b1f17b1804b1-442d6d1fadamr28832755e9.11.1746801209169;
        Fri, 09 May 2025 07:33:29 -0700 (PDT)
Received: from rh.redhat.com (p200300f6af1bce00e6fe5f11c0a7f4a1.dip0.t-ipconnect.de. [2003:f6:af1b:ce00:e6fe:5f11:c0a7:f4a1])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-442d67d5c7bsm32150775e9.4.2025.05.09.07.33.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 May 2025 07:33:28 -0700 (PDT)
From: Sebastian Ott <sebott@redhat.com>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Cc: Colton Lewis <coltonlewis@google.com>,
	Ricardo Koller <ricarkol@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Sebastian Ott <sebott@redhat.com>
Subject: [PATCH 2/3] KVM: arm64: selftests: fix thread migration in arch_timer_edge_cases
Date: Fri,  9 May 2025 16:33:11 +0200
Message-ID: <20250509143312.34224-3-sebott@redhat.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250509143312.34224-1-sebott@redhat.com>
References: <20250509143312.34224-1-sebott@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: N7ZnZmKughuHP_BpFdnGLAFLujU3N0sid0q459pH8_k_1746801210
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

arch_timer_edge_cases tries to migrate itself across host cpus. Before
the first test it migrates to cpu 0 by setting up an affinity mask with
only bit 0 set. After that it looks for the next possible cpu in the
current affinity mask which still has only bit 0 set. So there is no
migration at all.

Fix this by reading the default mask at start and use this to find
the next cpu in each iteration.

Signed-off-by: Sebastian Ott <sebott@redhat.com>
---
 tools/testing/selftests/kvm/arm64/arch_timer_edge_cases.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/arm64/arch_timer_edge_cases.c b/tools/testing/selftests/kvm/arm64/arch_timer_edge_cases.c
index c4716e0c1438..a813b4c6c817 100644
--- a/tools/testing/selftests/kvm/arm64/arch_timer_edge_cases.c
+++ b/tools/testing/selftests/kvm/arm64/arch_timer_edge_cases.c
@@ -849,17 +849,17 @@ static void guest_code(enum arch_timer timer)
 	GUEST_DONE();
 }
 
+static cpu_set_t default_cpuset;
+
 static uint32_t next_pcpu(void)
 {
 	uint32_t max = get_nprocs();
 	uint32_t cur = sched_getcpu();
 	uint32_t next = cur;
-	cpu_set_t cpuset;
+	cpu_set_t cpuset = default_cpuset;
 
 	TEST_ASSERT(max > 1, "Need at least two physical cpus");
 
-	sched_getaffinity(0, sizeof(cpuset), &cpuset);
-
 	do {
 		next = (next + 1) % CPU_SETSIZE;
 	} while (!CPU_ISSET(next, &cpuset));
@@ -1046,6 +1046,8 @@ int main(int argc, char *argv[])
 	if (!parse_args(argc, argv))
 		exit(KSFT_SKIP);
 
+	sched_getaffinity(0, sizeof(default_cpuset), &default_cpuset);
+
 	if (test_args.test_virtual) {
 		test_vm_create(&vm, &vcpu, VIRTUAL);
 		test_run(vm, vcpu);
-- 
2.49.0

