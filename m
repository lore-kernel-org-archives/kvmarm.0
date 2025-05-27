Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFF962797A0
	for <kvmarm@lists.linux.dev>; Tue, 27 May 2025 14:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748355891; cv=none; b=r1IR54l33CDWJY7ojrgToB3SrckqM1MfWEhrfDw3dGaDVe4rfecd4JgHkR1MPgjGDsmtoRBE0A4XjozB69ANGvjULs08mkTZtQDBkRsQ3QZDwLIww9K1JWJR2T8Bdy9x3WsP5GFN4wcy1vTxzGT+uw+muiSCuutZXFbl7+JIyng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748355891; c=relaxed/simple;
	bh=cOsu4Qrb+3bx73g5aMRxtPG7+Gkx5amoz9G8WVXNU9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=gSlOFuIvzgzv7qJXmut+jYZgFZFCMXCDrjZrsEVhTkPfsVMo7Bm9ou0nbwqON+p+BkdUZh+lF/Fj+ZeyUWQx7YNQYdzcfASfgfFn0YheMvGFNl/GfH+Gwz+f08gu709s+OPBGS4xqvneT89e7kF82htLQtE+cz0EzboBs+qiU7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SAYnB4vL; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SAYnB4vL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1748355888;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HiFig5XrzaKxrne/VffAS5Dccms79XHv1+bktez4Dgg=;
	b=SAYnB4vLvclNcUmXOhgouOPBzGSzjYCSPrkmiCpPQy3iFmlsWdBbDsdWwD1z0Pnjavi69T
	FBFbdLqZYMwxCRacuRF0j4PF8cJmQsDFw1Fbe5IbHBKZoPSSRnIKdc5+4qtOiPZv8SngVp
	cYyYIPrSrVWj1ipx1lU59WSZPrufxjg=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-661-bn9csBo6P3CaWpb0V51XEQ-1; Tue, 27 May 2025 10:24:47 -0400
X-MC-Unique: bn9csBo6P3CaWpb0V51XEQ-1
X-Mimecast-MFC-AGG-ID: bn9csBo6P3CaWpb0V51XEQ_1748355886
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-442f4a3851fso25273135e9.1
        for <kvmarm@lists.linux.dev>; Tue, 27 May 2025 07:24:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748355886; x=1748960686;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HiFig5XrzaKxrne/VffAS5Dccms79XHv1+bktez4Dgg=;
        b=gI8lBOw/RbhXjPKGnCEZRR29owDF9ktPPtwSgmBxdsmmpyPacX5srj9cm9zOVIXyM9
         MbZOtrKdmDwoV6i4cWv/j1+mBK/F59ftSWK8ASlfMg6HlBe5YSw7wc/mGoJYynyQVjGE
         1Ws9+mTn8ubDFb0I9ICL47YdAdVT5owmXvh0e9e/06z98vZORQ4WPGga26m69u+BD0OR
         qJtXtT9IML1dRikSeXJGBJyVDUjzsXGRmZn+hCdebXJrX6+BIFaeunBgs1ZMKHjHkBKF
         /tPVNBdVLHlE87mZvQLJxjG8aYss3q20yVb+XWFEEgEq/q9a1mUwa8kucRLXFVvLnDQ7
         jLbg==
X-Forwarded-Encrypted: i=1; AJvYcCWEYopQWPtpx1MkOpLJsIIJEgMaT1pqzM/aNPnx6I0JdssOlCJpB9SwhGAfphH/yx4YRy1pErg=@lists.linux.dev
X-Gm-Message-State: AOJu0YwitdSKoLUMmXd3b1wlQEAlRaTCTLnAT3xrN+OKsrv8HyTOMEp0
	RB/p3T4uEPVtcXm1kP7HCTNyxxY39/dCFXgt4+4xnQClK4HMCyNI6shi+S/OnLen78UdF8sx/QW
	i1KdmG9E9GudwdqEJI7CHk72LWoYL/1lf6wwL5k+G9ZeXASyqcfVopw579rOpxTvNKQ==
X-Gm-Gg: ASbGncuL1Ri1bspXd7SO5BUHdUuNzbZtPj0T6FLIy4fuIe61Mn5ovkDGWtBUkgu7Od9
	5Los9S8agNNGyzXagZ2/DaRdbDsCQZM0WqXi9HgE2v89PvActDWjlqZ/tfm2f2EhorWy0h/z8ds
	LcIKx2TLZ7wH5ZNXAHVKuHS4JS8/hEEkSS0FqSQ0EW37UK9RNNoN+zNolW7ghxTEh0lJBiVzZcE
	td2DSE3uJrd3ZPI5S92ABwQzLB8h1Jc8Sl1fppQJXub8NeK1Psmt4imTiSJnMJDjVcBKlM48av7
	Uuh6fNFtmEmNipm2WjAdEvH3kBqvxtjz1hti1ZuYadzMbLyvM3dcxMEQ+YsbrDUTp2O1sBaVgA=
	=
X-Received: by 2002:a05:600c:5120:b0:43d:683:8cb2 with SMTP id 5b1f17b1804b1-44c94374ed0mr124870055e9.14.1748355886252;
        Tue, 27 May 2025 07:24:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IELzaCUvaTNc9Adiu9Az9zHtuATeQC88HKSvkrZ4YDOc4EmiLqQ4b0pQxQ8ybi5Fu++RvO9Hg==
X-Received: by 2002:a05:600c:5120:b0:43d:683:8cb2 with SMTP id 5b1f17b1804b1-44c94374ed0mr124869595e9.14.1748355885791;
        Tue, 27 May 2025 07:24:45 -0700 (PDT)
Received: from rh.fritz.box (p200300f6af1bce00e6fe5f11c0a7f4a1.dip0.t-ipconnect.de. [2003:f6:af1b:ce00:e6fe:5f11:c0a7:f4a1])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-447f73d3edcsm278766415e9.20.2025.05.27.07.24.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 May 2025 07:24:45 -0700 (PDT)
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
Subject: [PATCH v2 2/3] KVM: arm64: selftests: fix thread migration in arch_timer_edge_cases
Date: Tue, 27 May 2025 16:24:33 +0200
Message-ID: <20250527142434.25209-3-sebott@redhat.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527142434.25209-1-sebott@redhat.com>
References: <20250527142434.25209-1-sebott@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: RWYa_AUFe5G_Xay7sm43AGUPHiASlLFGJXwY2qiYgEI_1748355886
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

