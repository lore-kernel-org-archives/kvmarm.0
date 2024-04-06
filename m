Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76DCFBA55
	for <kvmarm@lists.linux.dev>; Sat,  6 Apr 2024 12:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712407195; cv=none; b=GEIlOTox+XPgUYz8Nzbeh+0s6V0Yub+aguu5W0vvtovQq21XpPnZSNBCzWAnwsqpsXsPK9ww2KhuHXzXinuxkHl80JibaiG+rGkW2sOWPtEeaIiCM7eLoheH1pu2WYryxn65TFnP/mLLYZgKolQugxfy37NU6EzrrQ6nS6FXQ3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712407195; c=relaxed/simple;
	bh=67jvvc1FuFkl4RrldOCyNHxO0KEc+8WgPwVH/pFMsu4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jnsRLr6vOaY4U5sG6sDdmsLdY0PPqtWQV9wuerON10ww7SJEtpmjl6UDgrDObepf8nlDDnN6lZOPyka2PAZY7zYyy4zQA91xbc5c5pGAPMh8tuAipWeyR98uEKoisMRcOYkZzEbzWLmgkY+HQ2w1dJi0AFuIMFxHw5OvoWUTARg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HyCxxAHX; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HyCxxAHX"
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-5cddc5455aeso2240621a12.1
        for <kvmarm@lists.linux.dev>; Sat, 06 Apr 2024 05:39:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712407194; x=1713011994; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8Amd09WCoNGafmrfuk2tT2hw4+gKyq5hmdDwUgtaokg=;
        b=HyCxxAHXD048eFDJ+n5k1dEzp0uPz+J52p3fQ2UkMEKWVX13Dyodm+dwki62hnHe4+
         QdOMmmTVHW3pufiklg9YCMgx1eEUsyxJp4ltyMgYRlsEgnVZgyVU9lYmMwvti7iwBb8j
         jyEYu4iMGCsdWML3EmQ0ODKEbrBGzs45ijADDg83P3tnhXSvi4G91bJILB0ESEzMPr30
         xsngjB7qCkD+whbQgOYnav5HGFe0sm0ugtVIVaYs+k3tMekIDaRgAvcRfJm1AGdHrmnP
         9YxQEYbp4SiYZEqUKX6wE6LMZ6u01T1zKr5sOVDZPzQSY8xRnhijQtpOFeM9gX++W5md
         tSlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712407194; x=1713011994;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8Amd09WCoNGafmrfuk2tT2hw4+gKyq5hmdDwUgtaokg=;
        b=v/KI0/tJHkj4xbyeBIo7/J79Nw2LQCcalKPwaD/44vU6DMUJ2n3z/xY4VeImP/eRrX
         gosiz0Ry0V6qFTOHWEev5A7/hAaTARwJwGwh6so9CjTARilzcqbTbsZ8aWpqF/AZmBwH
         PI7L/k5Ge22QLyoyttIZPh0WRRR0KeMfc3DqqpBrtkLuWaELTh2VvE7bhMgF7t/50lZQ
         QBhM11N3CFjwtrPpydx6LoYVfDe+SdrfRH92xhuJshPzMtx0Q7SGzyLgU3N+jvwYN/ru
         r1dayB43FNHF19ek302ykh5fews8wE6X04y/zUIhyuCvo3peuDR1SO4YJXmRelH5PE7n
         ttZQ==
X-Forwarded-Encrypted: i=1; AJvYcCXDLw34IXd3bNCKgpbGI/hox1GbMBY5kj8on3tfi5Xg2QqYdYsnCEeyYUl8SHDcD/hs70MNBUcHIWgh2hA0PtadCJ9a6aVC
X-Gm-Message-State: AOJu0Yysa9d0hTnQfwwaelnL2AHLP6uxLSHrtjpaXxUpeEHDnH5Q/ZmN
	C475saOeC3OWV+avk/pL7nCSKnFKbVHzLmsXHAlheNYXJ5odBFXH
X-Google-Smtp-Source: AGHT+IGZi4czmCZZqDl75or3p6dCfsMOJaFJfy8Q9bSre2VzGKWSZ+VsWeTYQuMIiFbE4hVRMt9PTQ==
X-Received: by 2002:a05:6a20:c90c:b0:1a3:ae18:f1e4 with SMTP id gx12-20020a056a20c90c00b001a3ae18f1e4mr3511345pzb.34.1712407193831;
        Sat, 06 Apr 2024 05:39:53 -0700 (PDT)
Received: from wheely.local0.net (124-169-104-130.tpgi.com.au. [124.169.104.130])
        by smtp.gmail.com with ESMTPSA id nt5-20020a17090b248500b002a279a86e7asm5050576pjb.7.2024.04.06.05.39.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Apr 2024 05:39:53 -0700 (PDT)
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
Subject: [RFC kvm-unit-tests PATCH v2 07/14] shellcheck: Fix SC2143
Date: Sat,  6 Apr 2024 22:38:16 +1000
Message-ID: <20240406123833.406488-8-npiggin@gmail.com>
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

  SC2143 (style): Use ! grep -q instead of comparing output with
  [ -z .. ].

Not a bug.

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 scripts/arch-run.bash | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index ae4b06679..cd75405c8 100644
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

