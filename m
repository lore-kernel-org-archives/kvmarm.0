Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B38267EA
	for <kvmarm@lists.linux.dev>; Wed, 28 Jun 2023 00:14:28 +0000 (UTC)
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-1b82bf265b2so6269475ad.0
        for <kvmarm@lists.linux.dev>; Tue, 27 Jun 2023 17:14:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687911268; x=1690503268;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=4ZjcXPxOnEy7+SOVIdg9yFzDIlL6q00qvIVRkRmdKtM=;
        b=DKB7JOxPefuZO7KixVJFWWixhZBrTUmoOWjWM6HbkNPtDJ7RbVMWVl6G+QYa8/0Nez
         VHQVCnrnSTflid3YqbihoTRbjdG7G0cJHmZOgIfoEorGz8Op/66NSyMDNTTtlUDzw4JU
         aMKiH+2Vw0Tgx2tMg9ITPTCQP69+dvxX1tatkgiK5oR8pL+yrznMTNWbHvORRCs5Sp++
         XEh0e9zrdznltdWvWNkc3wOlpsb0AuPPu0LN+zg7fj/OzOWE+EIsND1JVrKHMQZ4ZY2p
         TAZCmwRU4oT6/4tm6fmZGWH4Cni0vHZG5naAUjbEM4lu6mgCdpx3HiPS7zENgM9B0V5k
         GdHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687911268; x=1690503268;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4ZjcXPxOnEy7+SOVIdg9yFzDIlL6q00qvIVRkRmdKtM=;
        b=DZCUBGzI+cPVU4vDcpY5G/gArzxBW+ZazGOxMzMXas/KR2uurwACthW880rA7cdJUO
         3u+aK5qc5cteanSwECZlmhPkz6GJDcyJNA7GDv5VeoqzpL3QUE/uir+BbsOhqcHgohdx
         PVT8lNwfojsJZS7v3155Hs4S/Ot5ZGcK0MfI4Aj661dqTPdQAW5q2p2I9atQUgfU6eDh
         DsPvO6QdHQTiCNklZaD/f5b+en4R1xY+C2ct/BFNyR4iDgjkei5vsVPxwXpiVRoI+bFR
         d/ToMZ7hb+YedBXOh0SZdUj2MO8X6o0eHyv0FQTQBSel/l9fYev0yZLtPKj0lARqeiR+
         4oGg==
X-Gm-Message-State: AC+VfDxXYIsA3Q/F85DPeTDOSBCOzYDlbPM7qm68KxWvoNzmuX7S9c7J
	DcVRBFfccxXfBFQiOFsvIAI=
X-Google-Smtp-Source: ACHHUZ4ajl/K9Afuy4wmkbZFJTlHaXfzvMo7K6CnfYtIi4x1dX/K2YDRLAr1sl1b7VUp9WmPnjfpFA==
X-Received: by 2002:a17:902:ea06:b0:1b8:50d:9dd9 with SMTP id s6-20020a170902ea0600b001b8050d9dd9mr7276070plg.51.1687911267850;
        Tue, 27 Jun 2023 17:14:27 -0700 (PDT)
Received: from sc9-mailhost2.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id jd4-20020a170903260400b001b1920cffdasm343796plb.204.2023.06.27.17.14.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jun 2023 17:14:27 -0700 (PDT)
From: Nadav Amit <nadav.amit@gmail.com>
X-Google-Original-From: Nadav Amit
To: Andrew Jones <andrew.jones@linux.dev>
Cc: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	Nikos Nikoleris <nikos.nikoleris@arm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	Nadav Amit <namit@vmware.com>
Subject: [PATCH] .debug ignore - to squash with efi:keep efi
Date: Wed, 28 Jun 2023 00:13:48 +0000
Message-Id: <20230628001356.2706-1-namit@vmware.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Nadav Amit <namit@vmware.com>

---
 .gitignore | 1 +
 1 file changed, 1 insertion(+)

diff --git a/.gitignore b/.gitignore
index 29f352c..2168e01 100644
--- a/.gitignore
+++ b/.gitignore
@@ -7,6 +7,7 @@ tags
 *.flat
 *.efi
 *.elf
+*.debug
 *.patch
 .pc
 patches
-- 
2.34.1

