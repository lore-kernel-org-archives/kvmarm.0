Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9A0F15FA95
	for <kvmarm@lists.linux.dev>; Fri,  5 Apr 2024 09:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712307792; cv=none; b=TdIb7LKGNtkQBJdnt7GFgY08AwKfvnuDWavaSiLfO2ITCGg3EVjq13CNSCYDRniiXOBf3IpRdzPLQBCyyNw4Ql62yOHY5UrslaQPUFYKSnTwC6L6jGc5yxtgIlV9aoPiDRck2BgYX4ZzxJljKrT6+gkRrQolZteQfZP0NfBRpZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712307792; c=relaxed/simple;
	bh=6p41UD/Qlbix35q2GMWXKkxcjMPc3SCEBB08xXaduLo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eBHVfsMFyZkiR+E/0S6kgK4eHiUp1EEdkVw0CLIsXAQ55Mu7hZPpZopPwLfeGkxKzkDZ/vY8gACuav19IooZ1xtzUuXME6IL+YCFwzolqOU2iUByLWyI6ierrZrJNI1LxzownYA/2NPquUp3en2B/9drdinyR0dezqPI8mIxaRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MO2HBXZl; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MO2HBXZl"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-6ecf1bb7f38so1219804b3a.0
        for <kvmarm@lists.linux.dev>; Fri, 05 Apr 2024 02:03:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712307790; x=1712912590; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R9jePsdBCGcy8FOcE4Dl0oxWEJ48LRHCUA6lv3K1JxQ=;
        b=MO2HBXZlGYKRs540ZBxEnzco5OrEX20k0yo47p8Mh/+vgdXWsymemeD2bw3M9QZY8U
         x8p1x1yGb/F38oajcx4780S4jGDvA2OOwVDlPX9Tt91fq47imTyKXt3fs7ueKoFLvV5d
         MfBqv59efaM5d1TcuTJN/rpms4jFEXWco4sjptuNu1MQCor8StTRv7xq0S2NME8vbjYB
         38cP1WCzeEoZkU+7BSyBy315MeU0tqYoIZEtan1X5L4NpySX3hFF52SUDyKIN9eeyJyb
         TruZMIryfm/TNaMgTjsBxBndDNnCfcxrCSM93+fvwXCiU6TknDTozWCmqFYafYoOQczZ
         Ymxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712307790; x=1712912590;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=R9jePsdBCGcy8FOcE4Dl0oxWEJ48LRHCUA6lv3K1JxQ=;
        b=ujwLmgqMJDn0oDdrigY/hYJirY0xo+7jMOc2ZQKxw7wOO77KSwGsPvUehctgA07RGC
         6uM0mkd5VoBDADLEYLd7J3tt6Nr0nkQucM/ZLJGCBFLC7hRUEssFIq0PAcu6CpXUShUi
         5DvFHnWyK77Brz28aETIf51xmG9WbaUMpGvGdMh59xTLWbpSBa8JuOuaqtLvURrE1yHE
         pqnEYKZxg9GV7jLYCB1r8OnD9JLVRvkMX7z2yIdlhLkNyMRVQUWKINsw68ETtFxbvOLP
         uP9BmOGbmrb0bctqtmL0BLMKSe2gkRpHLUc1apl5qDJGHeGz/eVG6USIEuxRer/IsYun
         H9hw==
X-Forwarded-Encrypted: i=1; AJvYcCX+gPWW7LeDtWEOR+3mOOb5qkZH/iov17kLWa2Vh3+fCwPWrAE7frd2pyga4grm2oWPlvQKnqipfzKKdRuq3mdy2VMqQWO1
X-Gm-Message-State: AOJu0Yzd+mzaZWbQjz/5j9K/VCuG/kmOS+5nxnPbMDTvYskbsemDaIfK
	6lpHvFVzu42+7Idu0Fm5SiBw0llKfYFP0Tl4VdvNX0Md9GbyZUD8
X-Google-Smtp-Source: AGHT+IEMEJ3nCJeD++W+neSnwL46t0FBmKBloHUglg2zIiLw0F8GdaDYwaaevNYobN9Y4Al5iZ2kEQ==
X-Received: by 2002:a05:6a00:4f89:b0:6ea:e31e:dc75 with SMTP id ld9-20020a056a004f8900b006eae31edc75mr827353pfb.5.1712307789932;
        Fri, 05 Apr 2024 02:03:09 -0700 (PDT)
Received: from wheely.local0.net (124-169-104-130.tpgi.com.au. [124.169.104.130])
        by smtp.gmail.com with ESMTPSA id s12-20020a62e70c000000b006ecf25d0b8dsm995783pfh.184.2024.04.05.02.03.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Apr 2024 02:03:09 -0700 (PDT)
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
Subject: [kvm-unit-tests RFC PATCH 14/17] shellcheck: Fix SC2178
Date: Fri,  5 Apr 2024 19:00:46 +1000
Message-ID: <20240405090052.375599-15-npiggin@gmail.com>
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

  SC2178 (warning): Variable was used as an array but is now assigned a
  string.

Not sure if there's a real bug.

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

