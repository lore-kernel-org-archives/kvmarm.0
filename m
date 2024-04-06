Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4E402CCA0
	for <kvmarm@lists.linux.dev>; Sat,  6 Apr 2024 12:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712407169; cv=none; b=pOEbvLMpRNdJoxkVuO1BkCC+9pEAZ8HYBhBdjoGMqNOxrroYD7ktEZzwj1Z7W2HX00JURFzsrxVLx+Ae1MkXfmHMRowABijM8qeSSxO/WKJzEFHzwWtVywrzNqXTtrN7f9Kf5+pJ9TsspmORBpPj/6jpo54V9Z4JWr1P+3HB0iI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712407169; c=relaxed/simple;
	bh=f797ca6qmLUHud4LT+RvBvCcJQO+xBNS9IZWMtZ/PRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kOTxn9bgdrY39wMKob4wzQe7/MpPeytU6B9tzEGiVYbfQjUhiUmbuC+cP3c1XsdRDFb9tVt6zKOX2Gtg9E82bFQWDDm4N+4QVtinlOE0f7h90VIbhKEFn8RUH8Fs6aO+5Z3iotSYJ8IS1p27sM67s3cHq62aSbQNZtLORNNcP3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZkYc1y7k; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZkYc1y7k"
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-2a074187a42so2203654a91.0
        for <kvmarm@lists.linux.dev>; Sat, 06 Apr 2024 05:39:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712407167; x=1713011967; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sB3ENgv8+Bm1tRLghaKazWKQeuX0gBEHcWKY2qfgh1Q=;
        b=ZkYc1y7kFdQ+pbgrTR0qlasKuzS0H0J4/wMI0u+as0Kei8LLBHbPAb/BG3TZ9vV2tA
         +ou8eDIKOdDLYPZcxILQSXR2U2VK+HSeBgDHPb+Ozjw8GqnfXiZbxM+nWgK1HE9uF5xW
         +zQlrYX3xvArFfxW5jOmdoB3dvTWnT8fxYcR6g0f7tkZT8005DouKTBGsYDByjU4iAdt
         /k+NW+2m/XjwxYEPH8vvMeW2gKGgZf4qRV9y/dVVkUCSfL3ohMxd6sN8cLaGXFxCbDuf
         N+waAoAb1n34cq+jSOGFtrEb0J+yxfGZzg3s6dcaYIOW7YLzUE0Xyao0hHwxeMo9FAW1
         YeMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712407167; x=1713011967;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sB3ENgv8+Bm1tRLghaKazWKQeuX0gBEHcWKY2qfgh1Q=;
        b=pu1YtLii/9EXsuOEv8AWp+QxIhXaNi0XQyQydDghiWmd218Mlh5xEnN8255vwHCj5y
         byTRoqz2X4pDy/Y0uXdvMIG9Qi2EJuPsNITh1OH3M4KNPkR/59EWBGhRgUKyOCF4eWKp
         kjn0N2LfREb6Rxdqhy8Qjrgz85xdINjf23/XjW+HlM+S3LF2XlheSFtp30QT4oUdORgo
         /y4FMm8kqmVT3v2lQWFAqFe+806oy1pciLImgkWSlRLv1ZN3iPygiqlv0w8t2GysCzyU
         tKyeHmWqgJsoTtMBF9iAVAMAwVh+3piCbQ3ah9cecvs1RuBthXC4KQNXWCf4AFNuyeaz
         TPZA==
X-Forwarded-Encrypted: i=1; AJvYcCVe7OA1HwszJMHmuNsflMHyTkQ+eo9brDNY0jl714DBV09cink4x0k1wLtenltFGrJam/hYvWi8e4Bxas6RbrDV/+CRG5E3
X-Gm-Message-State: AOJu0Yy/mXvJj+tyHtxHU9q2r5I1doR4M4uKiJYx0OqjBcUl8dCtjbfi
	0EQXt8XwPKwrlt7d0+hnvlMFzWUWBPv2ok4C21rvJCe/2zzJrqD2
X-Google-Smtp-Source: AGHT+IFsGkW61gbRnUwX+F4+qiUlZL7gQ1ZtjFZ3/rMtUrfy5XWV8+BO9FE9c5M3Fd0JMQ+twYXJKQ==
X-Received: by 2002:a17:90a:1fc9:b0:2a2:1900:493 with SMTP id z9-20020a17090a1fc900b002a219000493mr3185800pjz.40.1712407167008;
        Sat, 06 Apr 2024 05:39:27 -0700 (PDT)
Received: from wheely.local0.net (124-169-104-130.tpgi.com.au. [124.169.104.130])
        by smtp.gmail.com with ESMTPSA id nt5-20020a17090b248500b002a279a86e7asm5050576pjb.7.2024.04.06.05.39.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Apr 2024 05:39:26 -0700 (PDT)
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
Subject: [RFC kvm-unit-tests PATCH v2 04/14] shellcheck: Fix SC2094
Date: Sat,  6 Apr 2024 22:38:13 +1000
Message-ID: <20240406123833.406488-5-npiggin@gmail.com>
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

  SC2094 (info): Make sure not to read and write the same file in the same
  pipeline.

This is not as clearly bad as overwriting an input file with >, but
could appended characters possibly be read in from the input
redirection?

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 scripts/arch-run.bash | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index 1901a929f..472c31b08 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -492,6 +492,8 @@ env_file ()
 
 env_errata ()
 {
+	local new_env
+
 	if [ "$ACCEL" = "tcg" ]; then
 		export "ERRATA_FORCE=y"
 	elif [ "$ERRATATXT" ] && [ ! -f "$ERRATATXT" ]; then
@@ -500,7 +502,8 @@ env_errata ()
 	elif [ "$ERRATATXT" ]; then
 		env_generate_errata
 	fi
-	sort <(env | grep '^ERRATA_') <(grep '^ERRATA_' $KVM_UNIT_TESTS_ENV) | uniq -u >>$KVM_UNIT_TESTS_ENV
+	new_env=$(sort <(env | grep '^ERRATA_') <(grep '^ERRATA_' $KVM_UNIT_TESTS_ENV) | uniq -u)
+	echo "$new_env" >>$KVM_UNIT_TESTS_ENV
 }
 
 env_generate_errata ()
-- 
2.43.0

