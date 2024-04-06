Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D2AA1BF40
	for <kvmarm@lists.linux.dev>; Sat,  6 Apr 2024 12:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712407239; cv=none; b=F5Ygxatx6V3ceFOTmcmV+NgQRT3OG/AF4AspDBKf2tUBhiQV0R+kZtVXJXnbdDrFK095q6vBXcB2Kjy7dzwnSFIcY6gjPBD4WVMkaLPR7seyxR1oVULRRUNt8fw/XQN8WAb3CtmB4vUXqPHC+fdw91R+KV/gWN4OltDa7FM0j2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712407239; c=relaxed/simple;
	bh=gGUa3K9zILUvgF5PKH8SMZ/qnhdZyUnL8GXR2wj6lXM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tmKNatys2imdP4QZvXwjM1iru/A+GpmZ3hLvzsUfl+YQLRqALc+Tbx+4IfTBv9fVSXDfjlba48OVlWHugupCRH0Jqm8RSHh7dSTXy8HQXYHjKbH8e7hnHyS7psYlvjqAGXYOKjfOR/qDpEf8aZ/V6tqLrah0Nf0Gl626a6XzY2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RSaa72p6; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RSaa72p6"
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-5e152c757a5so2215859a12.2
        for <kvmarm@lists.linux.dev>; Sat, 06 Apr 2024 05:40:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712407238; x=1713012038; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2eRtFguiVvn3b4AxH0QU+OXVRgeLtifhqAQZ/pJYpnQ=;
        b=RSaa72p63TcF7b1BJDan4dkEBI53xpoM4DL2lcmutp4h5CzxOzvUmplc6XoXQm2qax
         hkL5/aeMJuUg85f4yIuUa85S+BaRMTeBLRWjQ5noaVD+8o9g6hh0XpyhV4eFEA1EpzsR
         ccIR9WWVnR3mk+mG0+FEJsHa7R9kAWlioW1kvj6gnQquSz1dJrBKe2Sq16oQfci74Tdo
         yshs4freVbd9gcgXcHCYKMMGLMGYNcXjoKgzCrJdqTMSeGhZbA5Mm6yXZxE9vKEF/99E
         T/Gzy/QoA8ygiFJ7fEfCXE7Ryi/PK2CklSktKtwf/6EpFKwq0TJTiE5PjX4JnPT/OOgD
         BUeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712407238; x=1713012038;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2eRtFguiVvn3b4AxH0QU+OXVRgeLtifhqAQZ/pJYpnQ=;
        b=vlcIOxkqzFeTRllGByXEVzCMisOYB0WRIdXWaYkUXTO3lyfv07exX2cEeBHyidlgp6
         YVaGZL6MQW6F3nbCCodt4SGm5YrgAEwX56iN5XERvLDA8nFm7pWdyYuvEQvfjJTfXRmj
         OYPIjoWYSzekdIWFq1pJqT7jeXwxPtinLUdblRHJAzNGGC0Ql2KYHlSJq8TOZpPuOPdH
         v1H/Sb/fHGGOt5gCTouQo4Ius1M2EuwF90fade4S8PVPxNwTs3FwFEJ+w6dDAJJJ191S
         8KuwFXvQtKvMR3zRd1XsLd1IQRqmssj1kAt96HsytYOCHHbIRkQIus+I0g8S4NEHUkly
         VjSQ==
X-Forwarded-Encrypted: i=1; AJvYcCVmRGc1KwrCm9VWeVStfosTgOEWEkKgl6OTYJQCDWzpO5qzrr6UhqH/bio+4jpXf8UE9erGfNyusokEvqg7mouFAC1kXW/B
X-Gm-Message-State: AOJu0YzfcYtwVNxeLW21IkLbFOTMtaZOR4MEAPFm4mcoqCD7xgYfAMRA
	srgaTPqJDVoGXETGGfOQoWF0m4cFtJnFfo5Ebqcdha1dj+ho9iMr
X-Google-Smtp-Source: AGHT+IFRwkbTF8lHFVWUWdHITKOoyi+cM/zQNImgd0YNfpYQL2AebNpOitSBxxkyLMi56+NDz70TCQ==
X-Received: by 2002:a05:6a20:1587:b0:1a3:9fa6:74f6 with SMTP id h7-20020a056a20158700b001a39fa674f6mr4468400pzj.58.1712407237671;
        Sat, 06 Apr 2024 05:40:37 -0700 (PDT)
Received: from wheely.local0.net (124-169-104-130.tpgi.com.au. [124.169.104.130])
        by smtp.gmail.com with ESMTPSA id nt5-20020a17090b248500b002a279a86e7asm5050576pjb.7.2024.04.06.05.40.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Apr 2024 05:40:37 -0700 (PDT)
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
Subject: [RFC kvm-unit-tests PATCH v2 12/14] shellcheck: Fix SC2178
Date: Sat,  6 Apr 2024 22:38:21 +1000
Message-ID: <20240406123833.406488-13-npiggin@gmail.com>
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

  SC2178 (warning): Variable was used as an array but is now assigned a
  string.

No bug identified.

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arm/efi/run   | 2 +-
 riscv/efi/run | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arm/efi/run b/arm/efi/run
index cf6d34b0b..8f41fc02d 100755
--- a/arm/efi/run
+++ b/arm/efi/run
@@ -44,7 +44,7 @@ qemu_args=()
 cmd_args=()
 while (( "$#" )); do
 	if [ "$1" = "-append" ]; then
-		cmd_args=$2
+		cmd_args=("$2")
 		shift 2
 	else
 		qemu_args+=("$1")
diff --git a/riscv/efi/run b/riscv/efi/run
index cce068694..5a72683a6 100755
--- a/riscv/efi/run
+++ b/riscv/efi/run
@@ -47,7 +47,7 @@ qemu_args=()
 cmd_args=()
 while (( "$#" )); do
 	if [ "$1" = "-append" ]; then
-		cmd_args=$2
+		cmd_args=("$2")
 		shift 2
 	else
 		qemu_args+=("$1")
-- 
2.43.0

