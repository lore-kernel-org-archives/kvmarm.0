Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B52EE2144D7
	for <kvmarm@lists.linux.dev>; Thu,  5 Jun 2025 10:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749119824; cv=none; b=DXyQF3f/uQS2hMiww6bijQxP11BVis/ri3Jihbo+GObM3q1oOdKGnnPUHgqGKCBTZlU2TAIqF2p4fxTg2NdIm4Bkg8NgoPPUyLTTd5lFAQGxYIm7aK8QoEs3fS4GvFSTJ57XQoU7M3astCs4bg88i5N5tfsh4Wyd8tdpZf0v3oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749119824; c=relaxed/simple;
	bh=VzQyPkruYWrDZAOkmL/UT3N0xShjKnGR9pQJo0jQ/Qk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=E75KzG7M2SC41IMzR/8Y7kDc0y/xtFCDLTjGlXXks8DbScQLCOC/FLKKKkx2B8DQq174pFejTxb05QOza2RQrZiXPZ8jjDlqJEyuNDk7ra0uR7pDQVA25lg3+BXFHoyWisnHkIZPDWBsrqV9c483tqCOs8mCYxZ/pisyC6e/o4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ve28W+lI; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ve28W+lI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749119821;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AdRsO2Uefrz8JMO751IFZEkS7KH/EcFqwNDUBdHYAOY=;
	b=Ve28W+lIHXb73GiLLC5LjugHznqIoq0SKEuftLIr1w8K5o15Je1Kty47BnUL/BXG5l3uet
	EJ1sJkGwotW3/JUBRqj0/5uk7rKmy4hX+nRF0lUdp5dyfzhKvyBbAHjB7/e/9sHyPNVSAC
	iDyqWnnYGyKI+C5uhbNdJgGFQZXjk6k=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-668-kwKEbbEaMYGMy40eIkOwNA-1; Thu, 05 Jun 2025 06:37:00 -0400
X-MC-Unique: kwKEbbEaMYGMy40eIkOwNA-1
X-Mimecast-MFC-AGG-ID: kwKEbbEaMYGMy40eIkOwNA_1749119819
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3a4eb9c80deso360747f8f.0
        for <kvmarm@lists.linux.dev>; Thu, 05 Jun 2025 03:37:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749119819; x=1749724619;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AdRsO2Uefrz8JMO751IFZEkS7KH/EcFqwNDUBdHYAOY=;
        b=rcdEL4uHKZnO/UIBUuTqjsxTdRnjRWgBowaXwL9MEdc1E4SIzWdF22jjhV54wCYrAg
         d/4dDVyz59+kFerUF7e9mHQ4WuQjWNJ5hZA8ei1cAAodNLyh8LkkqBfp/H6XNAEThXQJ
         HQTY5gnbLATbr8Vv/uOOOaWK/zfufPMifFwNTj/G3wn3d2HvZCJiKgiUOF0j9RnwiCBP
         s7Y4i4J1EtKeT/zHWjQ2AALbCfPV9Gxp4uNAKmTekU9d45ygyNJynHq7r7T7gSMtICDq
         DvCs7zn4k5MC7llNuN6akkkUWZNF34aSQcp3HAk62Za+IW8cEgNnmncgjDnI25JmRYbc
         APTg==
X-Forwarded-Encrypted: i=1; AJvYcCWJikaFqgm/q71ealEBO9U9QFK+14GfOwZdZrbvNP1l/912pQcBCvGiOphHrMrkoOha6yDQOy8=@lists.linux.dev
X-Gm-Message-State: AOJu0YwbmKpcqR1g7UGFn3w2FpjhY1zHCjJIZiu0h4P9yv4V4+A4dd1F
	uPl1ZJfXkHgb70G7cPwZHZQoCiLU/ULDvEUzBV2uYuyQiqKD3loTxZEa+rIj1ZDq4KBrH/ZCk6V
	wRUkY1IVYyDSM+5rk260IcMBpGRnPqtZ182s1N3iTxe8u1aOdeQy7aAQlFw==
X-Gm-Gg: ASbGncuTvF60+MjsFSrBRIqQpJFoPYcGN9x+FODqYG2BL5CLJ+YGgqiTNBJdSMgkVJV
	var6UerDdpAcfwTwDlz52DOaeqAHtF5JG3DnNGf8gUpL/xKnh/6PSiIV+I8fzZKFLeiUU7XX3Au
	VFsePgdh30tyn8ZmhNNi3uGWfjcR4E+fEWjPxMTKlz8rpx8wURdOy13C7dowTXmT7E9MgX6tfTv
	e5O55PL5OgoGqFN6pahUbiTmtzh0qcQpPMwCiOirRszkTMCwHogVwYWX/bRkKqnR/iFqIGh1ngP
	DckXMuC/AZCoGHpX/945G0KRU6QY8FpY9Z7l3bb2WV+9eUkLqwziyNJ6fk0xO2SAqPGMC4IlNw=
	=
X-Received: by 2002:a05:6000:144e:b0:3a3:ec58:ebf2 with SMTP id ffacd0b85a97d-3a51d8f6a68mr5594166f8f.7.1749119819365;
        Thu, 05 Jun 2025 03:36:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFRjZpPO2+0jMcuZP9CR9nsUnOUJ7V0YuUBqF23a88OV3aPhw4HnJ7EZRrzi+l8ZxUNJutO1Q==
X-Received: by 2002:a05:6000:144e:b0:3a3:ec58:ebf2 with SMTP id ffacd0b85a97d-3a51d8f6a68mr5594137f8f.7.1749119819002;
        Thu, 05 Jun 2025 03:36:59 -0700 (PDT)
Received: from rh.fritz.box (p200300f6af1bce00e6fe5f11c0a7f4a1.dip0.t-ipconnect.de. [2003:f6:af1b:ce00:e6fe:5f11:c0a7:f4a1])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-451f8311ae6sm14105175e9.2.2025.06.05.03.36.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jun 2025 03:36:58 -0700 (PDT)
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
Subject: [PATCH v3 1/4] KVM: arm64: selftests: fix help text for arch_timer_edge_cases
Date: Thu,  5 Jun 2025 12:36:10 +0200
Message-ID: <20250605103613.14544-2-sebott@redhat.com>
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
X-Mimecast-MFC-PROC-ID: iW5Tm8zp2NCtZy77Ucr_ssWlJqQagNWw7yPHpT8_Vmw_1749119819
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Fix the help text for arch_timer_edge_cases to show the correct
option for setting the wait time.

Signed-off-by: Sebastian Ott <sebott@redhat.com>
---
 tools/testing/selftests/kvm/arm64/arch_timer_edge_cases.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/arm64/arch_timer_edge_cases.c b/tools/testing/selftests/kvm/arm64/arch_timer_edge_cases.c
index a36a7e2db434..c4716e0c1438 100644
--- a/tools/testing/selftests/kvm/arm64/arch_timer_edge_cases.c
+++ b/tools/testing/selftests/kvm/arm64/arch_timer_edge_cases.c
@@ -986,7 +986,7 @@ static void test_print_help(char *name)
 	pr_info("\t-b: Test both physical and virtual timers (default: true)\n");
 	pr_info("\t-l: Delta (in ms) used for long wait time test (default: %u)\n",
 	     LONG_WAIT_TEST_MS);
-	pr_info("\t-l: Delta (in ms) used for wait times (default: %u)\n",
+	pr_info("\t-w: Delta (in ms) used for wait times (default: %u)\n",
 		WAIT_TEST_MS);
 	pr_info("\t-p: Test physical timer (default: true)\n");
 	pr_info("\t-v: Test virtual timer (default: true)\n");
-- 
2.49.0

