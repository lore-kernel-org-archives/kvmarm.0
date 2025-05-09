Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86EA0224B1E
	for <kvmarm@lists.linux.dev>; Fri,  9 May 2025 14:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746801213; cv=none; b=aA4DiXJ1l9Srsf1r1zGQpLPn2Dpufhuz5VPbberdoK4ZoVrdzmsXkt1DrVn392nmJMfJ2gDJ0M8sic0UCdAq/bFOVn33+ChJXxGMr4pInAym8dqnh0oWzjYyB44AeDBSZzaZwTG+y5pYP3GjWqMRGy8tLn5mzanUaKmXzBM2eI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746801213; c=relaxed/simple;
	bh=VzQyPkruYWrDZAOkmL/UT3N0xShjKnGR9pQJo0jQ/Qk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=h3bdGmHNkYXFwrEkXih8HuJQJUK1q/L232nDdrztZcykMGg+fKRD0qoSxg31xea2ak8fMeUryIt0CaHZyTMh9bha/Ttx+SrB7tICAgsHhbFM/olJtn3Natx+OzH9qRfK3xD0CQJ4TFPVGmRV9jaPI6ahFlxZNSbJlDaxl9mWnrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Khacbic/; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Khacbic/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746801210;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AdRsO2Uefrz8JMO751IFZEkS7KH/EcFqwNDUBdHYAOY=;
	b=Khacbic/wESm9hX5V7JtrNuQAJRKUCXAT455ONE8y2AJJ/zgkvhMJyipOhcQWs0jHNC+Og
	qCxRm2brWoQBYln/rnesmg/K9Q9tECjsJ7zcP4WpRgiJjFrtdUO6gg13u7Gp7iZDtBNVZX
	FcC55EWvlY62MOcapU9PFkfil5IujiE=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-184-B5vWmeQbPXWgnI7-VjJe0Q-1; Fri, 09 May 2025 10:33:29 -0400
X-MC-Unique: B5vWmeQbPXWgnI7-VjJe0Q-1
X-Mimecast-MFC-AGG-ID: B5vWmeQbPXWgnI7-VjJe0Q_1746801208
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-442ccf0eb4eso16756395e9.1
        for <kvmarm@lists.linux.dev>; Fri, 09 May 2025 07:33:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746801208; x=1747406008;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AdRsO2Uefrz8JMO751IFZEkS7KH/EcFqwNDUBdHYAOY=;
        b=rQk2UOz8domUhz8+3OuyuAjlhWAofsRsFxOrbu6IEIGMX8PyguIiRMZVN/FLzKUZiO
         z/Fvk1wWKZZLGhkOMD4iOYO7MEDe2jg6bo3EqRTNWoVqeHgNsz9Ko1mj5X4GXL+1C2In
         OAFUUoZIGAcIQGbyJhx5dOp8xKoMVTuer8ZKr80XOKxk5zymmtfJNEEWUJGr+92UwwI+
         KxH7c1OLtZjWL0VW6/dDxRROzU/g5+RwOPudvyxGKaUCt2Bbg7G4HJWx/FZbL4jhIBhM
         orMK3wugA7fz6p2cdf3SKoDQn94Bkx0U/wk/qPuzR/OPCvS97J6aMarNZWqnsZ5jdxy6
         5IXw==
X-Forwarded-Encrypted: i=1; AJvYcCWUnaFZig0W2XuVmAn2MebCWk1Vsve6QTGsP7fYRFki+L+ppjWXQPtvsWdtIfV8BebFdNokcpE=@lists.linux.dev
X-Gm-Message-State: AOJu0YxfMqX1mr5FPm2shJV7GREB59wF37b7TpTVjMD8xzF0eMlalRQD
	rSvouDsz8eSbdqYr9z1ktdbSXqVbCmfRRnXbGox1GAhXhNbLSWZceuB8IwyPAcSpta5chGe7r1G
	blp+Iwc/lcLPBRvFDRuISAOyLAp3hkS1jV7UghuuZ4TYs0Mc+WeVsJg==
X-Gm-Gg: ASbGncvZ3I+YjECr9fS5M3xFivbHF3DcB8tTGbH2KM7hXP83xEP8OoFHk5LjSq1/Krf
	LPjzyF9zykGQCfk4nHzBMgLsEiPZxK3oel4V4Kgm9H1m6XjwOLO+luQvubAGopXug7Avlta6jBV
	Thl6NQZaEkC1//RXe85/TSPvxoO65Twi+k4VpUW0LDlnqcXK/l1PApmqvb3yUDyNrCGPXv9us++
	+PEekpOgn0vj27gs5sICZeUhaoVyBMyzwdUW7Y7HUszGK1+dKEAarV592KIJQJMZGnBbDiOLHYg
	n0HrTp+kUxOpwYl76SNEJ5p6GSoL9d0pgB189kqEeSYwFwTjrTtMZJl4pLpSZuhF+7+AaKFJMSc
	=
X-Received: by 2002:a05:600c:83ca:b0:43c:fb95:c752 with SMTP id 5b1f17b1804b1-442d6d18b68mr35853885e9.3.1746801207832;
        Fri, 09 May 2025 07:33:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHm9MkDy/quubUQsSnalTOipje79m4aFFrG3Bj/W0QEAlm0r1Z0dt5gqWlFblcQZwsloaT3Fw==
X-Received: by 2002:a05:600c:83ca:b0:43c:fb95:c752 with SMTP id 5b1f17b1804b1-442d6d18b68mr35853555e9.3.1746801207515;
        Fri, 09 May 2025 07:33:27 -0700 (PDT)
Received: from rh.redhat.com (p200300f6af1bce00e6fe5f11c0a7f4a1.dip0.t-ipconnect.de. [2003:f6:af1b:ce00:e6fe:5f11:c0a7:f4a1])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-442d67d5c7bsm32150775e9.4.2025.05.09.07.33.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 May 2025 07:33:27 -0700 (PDT)
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
Subject: [PATCH 1/3] KVM: arm64: selftests: fix help text for arch_timer_edge_cases
Date: Fri,  9 May 2025 16:33:10 +0200
Message-ID: <20250509143312.34224-2-sebott@redhat.com>
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
X-Mimecast-MFC-PROC-ID: 6WN1rMbRzVoPO2oW8jb4S9hIFVz6rtif9erqsnzB79M_1746801208
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

