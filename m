Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C10732E3FE
	for <kvmarm@lists.linux.dev>; Wed, 21 Feb 2024 03:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708486117; cv=none; b=h6ChXD9Pk9eGIamrJJd9iVqaAa1uUZkgwuB7zPoe+OTb9KaWo4H0o5S2TJy+DsF37FXkxAis26ap3JTrPxphhZP1MGKDuYw0vrAm7qSp1PJ3ZYa36Uedf7v135ei53C5ZOViA4Dqz30o3ZLohaULDle2bhOn4VR4qaQppvAM7rE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708486117; c=relaxed/simple;
	bh=y2BU4+PN8T27EuGhaIHzmKLCmns9lA/wgYSlFtfkTGA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OyaPF0vDvCoQjWvnsU9MnOLPRYqJVKNWZEqci2ERBi50rSpA1UEt/SBYydAS2sRjiKCpELqey2DG+nLgJ+xms4HMapqMcFWTZlYHjIF816lgjWEp5oozc76lSiTitGEe9WWQE/9QSCy9j2UT1rjuV4PeAAFZqzxUsAEsY3crEiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dfUMor93; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dfUMor93"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1dc09556599so1018965ad.1
        for <kvmarm@lists.linux.dev>; Tue, 20 Feb 2024 19:28:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708486115; x=1709090915; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5FLaKcAirk3CTYgyOfE+aKJ+UIKz3IbgFgbToFNpwyg=;
        b=dfUMor9344tVg9ee9tQUTkraOu7TyVVl9GJSpRBhEOL1SRr8mqBWUPA4e4iPl1ld+k
         MLjVsWgezZq5iTVxKC/ATWqjaeVCcxM3K/ikbwy4/QgUkgXCgLB0NzYEmxC+cMUWBHfr
         td6XTYPIoCX1U3je2DaIWLlVV3zSyIGux58TCL4eKbJRjmV2qRg401nLPPwo65JCUHxp
         s2U4Yj5GuOl2LP4YdERmy2QXAls7fJleG2enhMKilN3u3bCw7YnH5XSAHNmtmYYnedH6
         cSAAY1P3e7MQLJP6oPLsftVDX5HzDLi9ZIPhQmke9+FvVNPavbH/RJDZQzAZd4unZ3M3
         KMIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708486115; x=1709090915;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5FLaKcAirk3CTYgyOfE+aKJ+UIKz3IbgFgbToFNpwyg=;
        b=aMi+AOtcUJDKljS5s3m2dX3ig7FMcLabLkj/ouJMSdlaqOoOq8ISqewXN8iMXlH/ZC
         le5Xhht/dpvfyYR+6A12tOEpUnwd4NnFoAIV3mp5+TOUGYFgvOiQx9np3Ya84pVJDn8O
         NJih51niRV9VHt8lb+I118gPqWREIXlfyxmvDWig588Txjk0Jid+PkzOpsQ1cGQEr8dr
         2r99RFIR2fnH5Bk7PWLCtOHMx41wINl3LBAy76BqI5Vrec+QVM6lxUwD+73Mz7lhR5f/
         CuEjQ2CaoTc8dyxjcVbN1iQb11I/0MZvZQhnVNSTzWhcH27MtVmswSKi62wfSeadgVQ4
         Cusg==
X-Forwarded-Encrypted: i=1; AJvYcCWyFrE69Rzn8OyZ1nrnF7/F7GztSdco5zWvmGmkfS3OrHsW7rMPwoA70NkRdGWDU10JXSRdOKt0RMv49HT9n2xKuCmPuK+W
X-Gm-Message-State: AOJu0Ywq93aXgIGB7EH5hlnDfek2J97JKs/2mW6Sn0+8cn7YwLex/6re
	IyFag0PG1rrF/ucfgnDVWfVsJAYzoAeQxIvkozbx+oLqSIPninnx
X-Google-Smtp-Source: AGHT+IG+5kUDxEEdP+IqiK5SZK+gSM7uxbwCRRCoyT5fAJOZNRoAtH8MrNNdmRsQBrctGqSWy5fX0Q==
X-Received: by 2002:a05:6a20:d498:b0:1a0:7e2f:ad44 with SMTP id im24-20020a056a20d49800b001a07e2fad44mr19469432pzb.31.1708486114991;
        Tue, 20 Feb 2024 19:28:34 -0800 (PST)
Received: from wheely.local0.net (220-235-194-103.tpgi.com.au. [220.235.194.103])
        by smtp.gmail.com with ESMTPSA id q7-20020a170902b10700b001dc214f7353sm1246457plr.249.2024.02.20.19.28.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Feb 2024 19:28:34 -0800 (PST)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	kvm@vger.kernel.org,
	Laurent Vivier <lvivier@redhat.com>,
	"Shaoqin Huang" <shahuang@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Nico Boehr <nrb@linux.ibm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Eric Auger <eric.auger@redhat.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Marc Hartmayer <mhartmay@linux.ibm.com>,
	linuxppc-dev@lists.ozlabs.org,
	linux-s390@vger.kernel.org,
	kvmarm@lists.linux.dev,
	kvm-riscv@lists.infradead.org
Subject: [kvm-unit-tests PATCH v5 2/8] arch-run: Clean up initrd cleanup
Date: Wed, 21 Feb 2024 13:27:51 +1000
Message-ID: <20240221032757.454524-3-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240221032757.454524-1-npiggin@gmail.com>
References: <20240221032757.454524-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Rather than put a big script into the trap handler, have it call
a function.

Reviewed-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 scripts/arch-run.bash | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index 11d47a85c..c1dd67abe 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -269,10 +269,21 @@ search_qemu_binary ()
 	export PATH=$save_path
 }
 
+initrd_cleanup ()
+{
+	rm -f $KVM_UNIT_TESTS_ENV
+	if [ "$KVM_UNIT_TESTS_ENV_OLD" ]; then
+		export KVM_UNIT_TESTS_ENV="$KVM_UNIT_TESTS_ENV_OLD"
+	else
+		unset KVM_UNIT_TESTS_ENV
+	fi
+	unset KVM_UNIT_TESTS_ENV_OLD
+}
+
 initrd_create ()
 {
 	if [ "$ENVIRON_DEFAULT" = "yes" ]; then
-		trap_exit_push 'rm -f $KVM_UNIT_TESTS_ENV; [ "$KVM_UNIT_TESTS_ENV_OLD" ] && export KVM_UNIT_TESTS_ENV="$KVM_UNIT_TESTS_ENV_OLD" || unset KVM_UNIT_TESTS_ENV; unset KVM_UNIT_TESTS_ENV_OLD'
+		trap_exit_push 'initrd_cleanup'
 		[ -f "$KVM_UNIT_TESTS_ENV" ] && export KVM_UNIT_TESTS_ENV_OLD="$KVM_UNIT_TESTS_ENV"
 		export KVM_UNIT_TESTS_ENV=$(mktemp)
 		env_params
-- 
2.42.0

