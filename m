Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF0F0214A8B
	for <kvmarm@lists.linux.dev>; Thu,  5 Jun 2025 10:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749119826; cv=none; b=RApkbxMMQELVJQU5jxNGPPBvA5WD+Ks+AWMefk9nxyh+AsEllJoyWPvdzDKGKtpKg2jMi1LjnPnNRU3AGele3rmyMBsApxg6K2s/SjTwBhvy3tTisl+AVS3JpYgbORnrWz1RAqYilf52QXzQ0OixDop9DjFyNUEOJ5w8uSwOi4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749119826; c=relaxed/simple;
	bh=cOsu4Qrb+3bx73g5aMRxtPG7+Gkx5amoz9G8WVXNU9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=jS1dY4RjGAIZPoPC2x6DtzuxYID6V+1ViAYwEbeb/vLxnZZi7SVdvXEMC21YrYJxTP1K/7+ioARrh7rvlOYfLDte+Dd+OEdTpPm5LGndgGQyaaAbsURumbXNHwCAArt/0NNTom6dtqtXZ1VjxX/5TIqiK5JET05/YZg17OCIX84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TtJoCBmx; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TtJoCBmx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749119822;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HiFig5XrzaKxrne/VffAS5Dccms79XHv1+bktez4Dgg=;
	b=TtJoCBmxsAvqtB9W1k6aDDzX2i8cePPVyf/yZMvOSgKLdGmW1dNoZr3Kkmm53WuyOAlRQg
	HScGhHSmm6kxn9BSCkNqr3QJOTkJCs84IuiR4UJGafej4tiCRtocM+ULUiP37O2J/7l08V
	htSRfSYRBBONz6sSM+nJo2VAIoDJVO4=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-225-TpUwPebWNUmV1TespaCN4Q-1; Thu, 05 Jun 2025 06:37:01 -0400
X-MC-Unique: TpUwPebWNUmV1TespaCN4Q-1
X-Mimecast-MFC-AGG-ID: TpUwPebWNUmV1TespaCN4Q_1749119821
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-442dc702850so4787155e9.1
        for <kvmarm@lists.linux.dev>; Thu, 05 Jun 2025 03:37:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749119820; x=1749724620;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HiFig5XrzaKxrne/VffAS5Dccms79XHv1+bktez4Dgg=;
        b=FoRAZ/Mfpe4PJoUxWNzpNb94iKO4jZvCAT4uVa62JArfWWVDZzuuluXBXieKEz6/zY
         eS53OiVsZBUHgeKWGmtfn3o7AlCYQrPfxe3ArwBU5r9eLKIPuzNtoL/zKLdBwbPx7/Ta
         AsceIoa7aNfoXLFtdb/4Ek4R078mHX41kperGgSgvXNtkr0ZBWmohRhBcZmkL8TDCzNX
         86R1K813q0laEB6Z9p/QQovrcnf7j0zUOccqcno4lD75euAHUtkBP2ziTTwJaAvNnujb
         O2LAhfHGWUv2wniJ+8PBrVKlDDdmiMVb0ywwLixPqK++qNM2HRcH4ht8rFIlfatM+wRz
         rUuw==
X-Forwarded-Encrypted: i=1; AJvYcCVv1nFj/ZjhyK0ef2eQTSW8LN+1x1u/cpxq3gzsOthAZkMHAdcei4MOpFin63Hnzekhs+VsWgI=@lists.linux.dev
X-Gm-Message-State: AOJu0YwXp0SaKJ8Im6DuR+sf+GCr0g50MphbJW92re3sabGX+C6YFmd1
	/ChH+kVAjYFxMevXcysB3iK+026xKSYjBwYRZrDKjzjb6otcx5kUNJXP/cs5NcjnM2/QCHYf4si
	oqbWValG3L0xfIaCHwZHvc16mafuDu3MdpAQfN6yI6o7NNTUVb2IxTgOZbg==
X-Gm-Gg: ASbGncuCriqqMcW29HrsgoXyJ+ZS5LfUORxv2u2dCxLUeerndpLBq3hB5Nsxl1t7oLz
	zU+DOjk1pbZPqIq69Op70j0ylz8u3eskhtNOB3Aez15QttQRFPyO8Xe66yvDwHStyg7Lle/LIlS
	g+V5S0q/k7xQKWmln8pojYTg3kSNRD/8SeovXUcP+k8AV5u93kUH4amEsxGOrAZJn40kAJO3yEY
	l2TkqsX+5MjpTLR4yx3shM+Gwk9RL56Ep2HvUX5nKRWUEWGSZz8p+cWWJbMbVEYbz37/RwdlOGU
	qF9Cndg6LO5F/hZQvZdBkxUOmI7P9syQQnToKI+UyKQN1OV6nqi2ZHaeGMB/b+YvhdAq8klTFQ=
	=
X-Received: by 2002:a05:600c:828f:b0:43d:ac5:11e8 with SMTP id 5b1f17b1804b1-451f0b26621mr50050515e9.21.1749119820634;
        Thu, 05 Jun 2025 03:37:00 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFs6aFjV1ri9gglwDDly0k/rNzs1/j6SDKTIoXHxHHy0T2KK5H3bwQ524CbBRzv8yzrX28AyQ==
X-Received: by 2002:a05:600c:828f:b0:43d:ac5:11e8 with SMTP id 5b1f17b1804b1-451f0b26621mr50050275e9.21.1749119820235;
        Thu, 05 Jun 2025 03:37:00 -0700 (PDT)
Received: from rh.fritz.box (p200300f6af1bce00e6fe5f11c0a7f4a1.dip0.t-ipconnect.de. [2003:f6:af1b:ce00:e6fe:5f11:c0a7:f4a1])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-451f8311ae6sm14105175e9.2.2025.06.05.03.36.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jun 2025 03:36:59 -0700 (PDT)
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
Subject: [PATCH v3 2/4] KVM: arm64: selftests: fix thread migration in arch_timer_edge_cases
Date: Thu,  5 Jun 2025 12:36:11 +0200
Message-ID: <20250605103613.14544-3-sebott@redhat.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250605103613.14544-1-sebott@redhat.com>
References: <20250605103613.14544-1-sebott@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: E_rBxSHdWceFq6MxbrlGngyYI7mRszeq4EqhveLpSjc_1749119821
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

