Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A8C415FD15
	for <kvmarm@lists.linux.dev>; Fri,  5 Apr 2024 09:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712307746; cv=none; b=tsRvgz3ipZ94VQI2lyd4YR+2LQ43fyOX9TsoCZIwcp4mr9nSDqn+Iv0CfYjZs4jThxVp3OSTcijjrXIFUpnIstesNDiRZ8J1VnU62g5WrZMgx10ZdXUYXvfi2uTBBLBIVTyKOTuTyC8JlrfWu791z2TFtdviplKzwVRZPgFBC+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712307746; c=relaxed/simple;
	bh=5GeQjgmyuUTE42hH1s2QbxPN2QS1tsG/7YB+V3jiAPo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eTyXJSDmOzWLEHwZXaPgPV9ZDmTjiiymOBuibYi42A1h4UqAKtj7vb+5gKfXuNTurrGMt0rClEWXI1r0077Zs9mtKPxHf6hugfnLUJwuCuwzWCfqnsHUeIdApb4yLnMzFRAYZTNZazbOkHE+qjMHSih/nlVZU0dAHFy5hBt0yco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eP7um+6F; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eP7um+6F"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-6e74aa08d15so1507281b3a.1
        for <kvmarm@lists.linux.dev>; Fri, 05 Apr 2024 02:02:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712307744; x=1712912544; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Pxe6HTJDpXeWz+A4d/z3W+WfFv5s26i6kZ8vmOxuk2w=;
        b=eP7um+6FaaPwhE4QiOolLYA+icgrLtrslrlnxpOTdbCNA6bKOGgx+8WTsve0jGaxGd
         sC50nB3T7Ac6zHqEcUQag0qOkXpv3xSCiioIiLcdNlTlkOCzyQTURZatexfbsPW7EbtK
         IJLqzIsC8xtSTsC/mZWeql+7hGzBS8WlvNJrlxPslB0NTVs6xb1YKamjt+5oiU+3DQ4R
         TYkYNZ/gqbV0vckNDU3xJDaa+9ZZ0sgumq0GneZJyID7y5JY2zw74LUfGEr674HZvv08
         pAbG/4WSvJJUAZMizVBUksoqk8bOyFr7vzEP2YtAngpBYwnZqvNIGKZUltXDaAvLZYhY
         uLFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712307744; x=1712912544;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Pxe6HTJDpXeWz+A4d/z3W+WfFv5s26i6kZ8vmOxuk2w=;
        b=wOeHIvc7gBCXrEvweR75n8HGbc4PTDP/ihB41CsD+/4YiTZr69eK1pJOC1aHwSnpqP
         UUjhtIqECPO5mxzCVuE4AMuivvDQqi1B4l1tmHEsbQzIzstohRRmDASKe/nFaJfjyVV6
         z93lUm0ijKefKUdzBy5TrsELw4ZJ6MrpOsAHQJPbjUR/xqsviNZfI0YgFynuAXQyf26o
         n1xRhVoyocsMSzzDRllVixzyaLY46U8tfSZ2X2cuJssRn/0iIxMlmk6brjUE12eVtF8f
         8UHRdWSoUDsDX54tyv5PGXGkiIdm6AFtvcT446lnhwpiHsC7X4MIzYTw8kvtajGZpLVH
         aQow==
X-Forwarded-Encrypted: i=1; AJvYcCX66up1iCqWEw4c3Ed+R+8qIfnZdDYGHwTm+4YuK8xaaD9E5ZtwSV7uzSux5qWDW6WsS1t8UnFcnnSOELsn9RyzjGU4pq8G
X-Gm-Message-State: AOJu0Ywyw4DBaWg32S/hK32mINJ5Lk3FC55/kNKM5wKp3q1YQYbY3Zms
	1ihd5yfwGk3que3p0FB5EEGB090kZ42gLm3g4syJ5YNwPTNQYKr5
X-Google-Smtp-Source: AGHT+IFi0wcgnFzUT48JpEZlFnQyd03or96zaStrZ3u3axPTcX7D20CB8PvzKwnmjg2fzqLkBgB2zA==
X-Received: by 2002:aa7:8893:0:b0:6e5:faca:3683 with SMTP id z19-20020aa78893000000b006e5faca3683mr1042054pfe.26.1712307744654;
        Fri, 05 Apr 2024 02:02:24 -0700 (PDT)
Received: from wheely.local0.net (124-169-104-130.tpgi.com.au. [124.169.104.130])
        by smtp.gmail.com with ESMTPSA id s12-20020a62e70c000000b006ecf25d0b8dsm995783pfh.184.2024.04.05.02.02.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Apr 2024 02:02:24 -0700 (PDT)
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
Subject: [kvm-unit-tests RFC PATCH 09/17] shellcheck: Fix SC2143
Date: Fri,  5 Apr 2024 19:00:41 +1000
Message-ID: <20240405090052.375599-10-npiggin@gmail.com>
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

  SC2143 (style): Use ! grep -q instead of comparing output with
  [ -z .. ].

Not a bug.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 scripts/arch-run.bash | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index d1edd1d69..9dc34a54a 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -61,7 +61,11 @@ run_qemu ()
 		# Even when ret==1 (unittest success) if we also got stderr
 		# logs, then we assume a QEMU failure. Otherwise we translate
 		# status of 1 to 0 (SUCCESS)
-		if [ -z "$(echo "$errors" | grep -vi warning)" ]; then
+	        if [ "$errors" ]; then
+			if ! grep -qvi warning <<<"$errors" ; then
+				ret=0
+			fi
+		else
 			ret=0
 		fi
 	fi
-- 
2.43.0

