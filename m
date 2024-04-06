Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8F90BA55
	for <kvmarm@lists.linux.dev>; Sat,  6 Apr 2024 12:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712407204; cv=none; b=MveFcAMXS5GG1W1JgyMPcEGu67nSiTjrxjQYqqzdXj9lO9tgwbHGGtee2kmlRM6n8VMubg9ZXu2HenpOb++pYWEFw9nvFN8sVeq86rC2JtrsqBYOnsWFJR5FpLpf/1WYWa1ZgHUvUdhA1c5Q/FOXcKRYB6m0TWCp5cuAL0Njzic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712407204; c=relaxed/simple;
	bh=C9hhWnwCALdwqG5WyS4H7F9rVkRx8HCoDY3R0fruCbQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=niNJbG9aa+dE9APtX/Cw1LQVDu3yldzkC1mc8vE4SG56R5rXH/Uz2CBdVWacHYrwS6r1V8++MT1ECyVSxa4zVAzX0teI8Pqh0xHFJAoR0Gsu9TJq8balvDg8cxEqtcQzDD/3onxe+OfJlVYUSq1GSPmFoUnP4fW/aMfZB1QnyC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lCMZ8epU; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lCMZ8epU"
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-5d4d15ec7c5so2451467a12.1
        for <kvmarm@lists.linux.dev>; Sat, 06 Apr 2024 05:40:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712407202; x=1713012002; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jc9Ns5Gs4d6EQrXAeFAipEGyYWBXJXNznus1Vgd5gEY=;
        b=lCMZ8epUckLZTBtQv+Jcm4cBghCnJqgE8zvw/gFPU7kaNbUZZPojhJhScJTJVpqAU8
         tZr27Kb3iT9ZbXjkvE2p27rH5Y3IOT24Zf0R3Pe0qL53w4Qr0sw+3tf+X6sngbPFUiUa
         d0Eym6uBFpUI0FknZBcmEFGPXbcAf/T5A9paB4WmHjCI8Keu9X3k0hgOguPwhYC4Tmal
         LurFeUd9zDosOjGQIfhiBuZc/VNs0j5jNdYWNAuAgtQ18cIpUowzlQorbEvtGJhDG8s+
         7aqhNBnmf6m7vIlQRgXTb+wfr1zkWnl0uBa0caTVoWlAGgKT6JeIjnMTHi0lUFcG7JTS
         +WKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712407202; x=1713012002;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jc9Ns5Gs4d6EQrXAeFAipEGyYWBXJXNznus1Vgd5gEY=;
        b=tXOG7QzERHf69pRYP8Nf0DthlO+pklEJc6KN+PFzIEj0kL3z/V9zXE+1fDCZm53DHD
         Ti3oCZy8HND5mOQnbi9vD9PW1XC2ivNk8SoueYBFg/VyVvmsWYHtBnsN+A2vij5bhV0W
         INbetgRnno9Kh3r82tYJsoRoIa+NTRXCooigoDI823Tq+CClctAIppRHm1yictzBBYr6
         GxHhCaMylW9v1VHD0ahUqAi1wDPZi1qmQ1wEGl4R7vsGw+v3PBRq89/6mZKgN70RyjBU
         q7p+p1D7mQeSzFuRpY74dAKBpil4ZJqzjGg8JVlsCKk7LYbTpgddX1X1TPiYazdU08Sk
         HqEg==
X-Forwarded-Encrypted: i=1; AJvYcCU6DH40CUGzMV1BppkhmI8mi1nphOhqYGYNGKNIgOkXKYW6wVv2YNTRRAe2ALz1mUljR5nsAz3bqlKfepd3S93TjXTYv9sQ
X-Gm-Message-State: AOJu0YydW9dO9ExAXXCvTg90nt50Y/mZT1cfsrONhYFPk3RNRFs1BHJj
	yU+8/KQES2wMIaa7fO8/oJGOgOQGNf0lmNHxMuPqBlfhX5EqcGsT
X-Google-Smtp-Source: AGHT+IGFqwzSPVPQ9YT3jplB+7wqnHfvH8TCbOoaXrxURWMaPygGn8PVC/qsnNpJzSZ+kKAlRUuDBA==
X-Received: by 2002:a05:6a20:12ca:b0:1a7:c63:add2 with SMTP id v10-20020a056a2012ca00b001a70c63add2mr5190444pzg.10.1712407202215;
        Sat, 06 Apr 2024 05:40:02 -0700 (PDT)
Received: from wheely.local0.net (124-169-104-130.tpgi.com.au. [124.169.104.130])
        by smtp.gmail.com with ESMTPSA id nt5-20020a17090b248500b002a279a86e7asm5050576pjb.7.2024.04.06.05.39.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Apr 2024 05:40:01 -0700 (PDT)
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
Subject: [RFC kvm-unit-tests PATCH v2 08/14] shellcheck: Fix SC2013
Date: Sat,  6 Apr 2024 22:38:17 +1000
Message-ID: <20240406123833.406488-9-npiggin@gmail.com>
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

  SC2013 (info): To read lines rather than words, pipe/redirect to a
  'while read' loop.

Not a bug.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 scripts/arch-run.bash | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index cd75405c8..45ec8f57d 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -487,7 +487,7 @@ env_file ()
 
 	[ ! -f "$KVM_UNIT_TESTS_ENV_OLD" ] && return
 
-	for line in $(grep -E '^[[:blank:]]*[[:alpha:]_][[:alnum:]_]*=' "$KVM_UNIT_TESTS_ENV_OLD"); do
+	grep -E '^[[:blank:]]*[[:alpha:]_][[:alnum:]_]*=' "$KVM_UNIT_TESTS_ENV_OLD" | while IFS= read -r line ; do
 		var=${line%%=*}
 		if ! grep -q "^$var=" $KVM_UNIT_TESTS_ENV; then
 			eval export "$line"
-- 
2.43.0

