Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E14A7FF
	for <kvmarm@lists.linux.dev>; Sat, 17 Jun 2023 01:32:28 +0000 (UTC)
Received: by mail-il1-f170.google.com with SMTP id e9e14a558f8ab-3420ed1a745so3684865ab.3
        for <kvmarm@lists.linux.dev>; Fri, 16 Jun 2023 18:32:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686965547; x=1689557547;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QCFh45Qsuxbnb3g0rM8fH1ZiENcg3IHzIVBkkFabZuA=;
        b=lKUS3XrMHKO/IAyQlaR+bTGozWS2E4YkTio25buE4PJ7GoQu54ndBzxCOhqaQWJhs/
         IhG5XchDDSey75xzX1nEPYPt16nlpugDzrINTybuA1+myv/QX1WNrVqMyLYg1wPf/b1G
         bgO0Q9QPU8wrOJeV2yVyT1w3VuJdgWZr+3sZ3hkV7wW0pIScymwToVWDrni21g4B6Tyj
         ReS9bWaYwwoaoMDV4nO7OpZcvXTJkVDddWNqyivQeRNp0A0k72SiwZP1//TKG276/BIE
         fgoLGAD/45RJrkdn6CLIr6eIakoAnkDET8WK89M47ArTydu+csJHlIoFMX8nD8dyuNRn
         T5uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686965547; x=1689557547;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QCFh45Qsuxbnb3g0rM8fH1ZiENcg3IHzIVBkkFabZuA=;
        b=cAw05wGU0ls5Jg1cP491chO5b8b4YmAkduKD2eqVbswVEbuHfIDBfFhrKsIcXOof2+
         ieBoQqNW8X8bScO/QizUzc9jr1FSPlDKFb0Bctl+kaI+pb2vrfj9NAp5Hbtp+unOYrd3
         HPpkNCbAU/Uo1w4D4X3FJmaTCGd0Mjk7jnjSCLRtcDeRbmreOE1ORqMUSZ/Gi+OgV+73
         nE+vj4Nm65ofY5/cmmKEIjnHHetnDkLbVyIDAIwoY/fsUNcYLMK2SNALodPWUUnO6Ojf
         Q8WH9ZhAkQhZ3BdC3dulxByY9tGaeZHr67SA91Z8TOVgQqR2W5Rc0eY1aFE3WBGN38F3
         cGrw==
X-Gm-Message-State: AC+VfDylWN5nmY5KiCqAKCnRs0U3+ObmaiudfSum9tv4xT0C9oPeL85F
	kQEVQQB7gsthlfvVN1ozdbU=
X-Google-Smtp-Source: ACHHUZ56q6e08Ddrinzp/hEGan9to7/X04Bp38cROLMLVviVEnxslB11hbwWIsOrFwxuJUdAUL7KZw==
X-Received: by 2002:a92:d1d2:0:b0:331:9a82:33f6 with SMTP id u18-20020a92d1d2000000b003319a8233f6mr1020746ilg.5.1686965547172;
        Fri, 16 Jun 2023 18:32:27 -0700 (PDT)
Received: from sc9-mailhost2.vmware.com (c-24-6-216-183.hsd1.ca.comcast.net. [24.6.216.183])
        by smtp.gmail.com with ESMTPSA id c15-20020a63724f000000b0053ba104c113sm455042pgn.72.2023.06.16.18.32.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jun 2023 18:32:26 -0700 (PDT)
From: Nadav Amit <nadav.amit@gmail.com>
X-Google-Original-From: Nadav Amit
To: Andrew Jones <andrew.jones@linux.dev>
Cc: kvmarm@lists.linux.dev,
	kvmarm@lists.cs.columbia.edu,
	kvm@vger.kernel.org,
	Nadav Amit <namit@vmware.com>
Subject: [kvm-unit-tests PATCH 2/2] arm64: ensure tlbi is safe
Date: Sat, 17 Jun 2023 01:31:38 +0000
Message-Id: <20230617013138.1823-3-namit@vmware.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230617013138.1823-1-namit@vmware.com>
References: <20230617013138.1823-1-namit@vmware.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Nadav Amit <namit@vmware.com>

While no real problem was encountered, having an inline assembly without
volatile keyword and output can allow the compiler to ignore it. And
without a memory clobber, potentially reorder it.

Add volatile and memory clobber.

Signed-off-by: Nadav Amit <namit@vmware.com>
---
 lib/arm64/asm/mmu.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/arm64/asm/mmu.h b/lib/arm64/asm/mmu.h
index 5c27edb..cf94403 100644
--- a/lib/arm64/asm/mmu.h
+++ b/lib/arm64/asm/mmu.h
@@ -14,7 +14,7 @@
 static inline void flush_tlb_all(void)
 {
 	dsb(ishst);
-	asm("tlbi	vmalle1is");
+	asm volatile("tlbi	vmalle1is" ::: "memory");
 	dsb(ish);
 	isb();
 }
@@ -23,7 +23,7 @@ static inline void flush_tlb_page(unsigned long vaddr)
 {
 	unsigned long page = vaddr >> 12;
 	dsb(ishst);
-	asm("tlbi	vaae1is, %0" :: "r" (page));
+	asm volatile("tlbi	vaae1is, %0" :: "r" (page) : "memory");
 	dsb(ish);
 	isb();
 }
-- 
2.34.1

