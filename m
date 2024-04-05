Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2E7D15FA7C
	for <kvmarm@lists.linux.dev>; Fri,  5 Apr 2024 09:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712307703; cv=none; b=J2uDKtnDcsSwfbozhDz9xK9UwItpA7GACcHzTnuGwjEaPA59lG7t09ISQNSby8mN7Lv7CjLunOQPthYjsUEAPYA8A7/gPq2yz5aLq4YFvzqsV1BpeC6+c8drTjpqOd3Rsjj3/+Us5eOS/Jg80Ius9TDQepS4JeALqvweREqTvSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712307703; c=relaxed/simple;
	bh=506MTEjbVPXF8Zt3kJ2sS8cgtechUEV91w1R5KBhWo0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hnsVyehVWm71/iZ1Pjht/DrvV73OLtuxTzGchBSJwVn9CBYM3/uOPWjZWgvmgtJVS148DlugAP94Mz1r4+ZK5eswMbKZsmJQpd9t6usePVcxN7xC68OVfH0CdUPcyqxNmzBQ0ikao8aB/jIHj1NnAFiJf0tLMmXGoI/jMgjSPm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=h/Vmz2Gr; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h/Vmz2Gr"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-6ea9a60f7f5so1666920b3a.3
        for <kvmarm@lists.linux.dev>; Fri, 05 Apr 2024 02:01:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712307701; x=1712912501; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jWkgTiRHnk4W4aXSUXKYIpIrbIJtMcwldZh7NhaIyxs=;
        b=h/Vmz2GrqVG7XgZTS/dLm4ABSD+kyhEyQ8+cSWGeiOKGUN9VlKSh3T+rgj1oedLaep
         Nsh/D8UiHCUUWmKvV7/eUR1UOtyzC5cUgER2K3nbBwyxwZCyd102o2SK6NvCASdGt84l
         1twpzN+m8MGJgVhc3+Kav0XdwDe3sFiI/a+doTahR8UuwhdqrM6SmIP2QhSB6qEWSL6z
         RZRGacEwDmhVDxFKkXtsB37v1jNK8is4PEyToxNKpNdu2PMnxcrijpL3BWNlW1myIoYP
         MtYXZMUlY0gKP/mYGRGaSF7B1IVQPXiI1ogoH9lfNz3zVqiGmMQeg5oanyn9RaQIAcoC
         QJqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712307701; x=1712912501;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jWkgTiRHnk4W4aXSUXKYIpIrbIJtMcwldZh7NhaIyxs=;
        b=Ecrp/DlMoVIA3k/s2KGMXndlxC9VFL2SKSozTgGzuj3TIW3rG94zCHdGRinOgzx+Qq
         zxu4TzUXa/Ik51meEQNFE/4TcV7qlyTwb3UelxIlUuv1zuir84r1NSkJ45gRDeNnqMJY
         FeCfTelUvYGuSHIB7sHV80MyPq41E6o0n4p/kQbCrKyZ5xub2IifbNBZuiEvnhqhTzAH
         EHBHqvEw9wZp/GCiYeeCV+pBr8Z81W0r9aMjY2fTydWcpCctZBFRMDu95FsMOpMmuQsu
         L8PwqzXR4ZuzObm3Y0gufqhFIXMqHWssG8K4kGwVwaaNvuvB+q6bQijsj6AjYo0Urg4s
         +/wg==
X-Forwarded-Encrypted: i=1; AJvYcCU5l75LKpQ1kp2moqKXd9ab5Gvw2B5bwtIE2tv1o8YhcEM2e2t5Xu5BW0zCcLjuytN4q5hGO/ZXFAw9Cwe3h91huO36LjJ+
X-Gm-Message-State: AOJu0Yz8JyrydZ78InKwJn0wVGUQkNF0a5bR0+MjHZUmhn3umxrEgbWm
	tU0TArvQqTexDyhfkRSobTusJel/cmsxMP/Jg5Jvqz5hRYpwMkvo
X-Google-Smtp-Source: AGHT+IFKRylcUQSeLpH891qpaLSwfOXby/ZCFByKbFqJhH6RagTfsZsaWuVIt0y3x2KTtKSKRijqgw==
X-Received: by 2002:a05:6a20:5603:b0:1a3:69e9:2fc4 with SMTP id ir3-20020a056a20560300b001a369e92fc4mr759512pzc.22.1712307701154;
        Fri, 05 Apr 2024 02:01:41 -0700 (PDT)
Received: from wheely.local0.net (124-169-104-130.tpgi.com.au. [124.169.104.130])
        by smtp.gmail.com with ESMTPSA id s12-20020a62e70c000000b006ecf25d0b8dsm995783pfh.184.2024.04.05.02.01.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Apr 2024 02:01:40 -0700 (PDT)
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
Subject: [kvm-unit-tests RFC PATCH 04/17] shellcheck: Fix SC2094
Date: Fri,  5 Apr 2024 19:00:36 +1000
Message-ID: <20240405090052.375599-5-npiggin@gmail.com>
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

  SC2094 (info): Make sure not to read and write the same file in the same
  pipeline.

This is not as clearly bad as overwriting an input file with >, but
could appended characters possibly be read in from the input
redirection?

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

