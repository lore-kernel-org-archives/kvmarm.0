Received: from mail-oa1-f46.google.com (mail-oa1-f46.google.com [209.85.160.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0993F371
	for <kvmarm@lists.linux.dev>; Sat, 17 Jun 2023 01:32:16 +0000 (UTC)
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-19f3550bcceso1486675fac.0
        for <kvmarm@lists.linux.dev>; Fri, 16 Jun 2023 18:32:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686965536; x=1689557536;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=tqEygQDd/2w/8+707JUmZL/5BF87rV1WGy9Ueb44VpM=;
        b=JCLwscTKzfcVxAy5zZm1Uwi9WPvvVjpssPDYmR+iXIfe3lxChTgO27ay9kFmoGRYsV
         Ei7cxSX3WBX255+8y8e7wTXQrLNM/W38xiyJmei+7fse8mYTxezZvsVWNMTJS6wmk4nm
         lfCGAkt3U3H4qSGCOLP1uIwcarT4VOjzpBbyAm/Y7aASbKIKfTR5k92tYSql9CVe5peC
         VsJxe8RH9vkj7iKdceWXMQukN9ioJlvQsNJ/KE+AUA3HlY0SuP+hPU2Y0wpOOn6K+yfa
         aTCCMlRRa25uuc2t3LrMJQrFE9VXtrGF6ZdY6+QcAP5kPXyMj7gEuSaeiHnOHrh5/pVZ
         //Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686965536; x=1689557536;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tqEygQDd/2w/8+707JUmZL/5BF87rV1WGy9Ueb44VpM=;
        b=SGxC8yzG25cX6ppXBF6a3vLaxFSdHmqgCo8LmD6Jryfeyc6HQegiIwMerzw2fdylkY
         XFF/Jot1oP5pPY+yy3I/IA0SSsmsXj21mXHXhcl3y5mm/RkfxJzObrcwgiL4YDWcJ/Xa
         13c9jV5r4G25PGgzXeenpB9oJga7tP5VIfoOsIAsh8CijGuGdMSuo+zKeQc03NkfarqJ
         gHhLWWBJoPtcVDLFTYut8Bvw1J4Lt2qY5MB7JzX3rLWzUcFd+mTBxIBhNsPmYi9Gdf8/
         K1PF8okZY15qrHJFGiHUUf0ltIGCy45w49Vg4dxDD53UgjEIXUYW8rVXt8DJgkAWpFir
         L0JQ==
X-Gm-Message-State: AC+VfDx1Ifeni2PzdrkDthbSAfmGdaf++M1Kcw7uAmINEiqr6Py/r7z/
	2/ZM64JgCeGJaA42pg2VZZQ=
X-Google-Smtp-Source: ACHHUZ6TUzAkqbGGl+QY0n9VxR6rYU0/GThwRScpy9nQCD4ODsQ6sEoE80yD1/FJbdgJw/8n9+MYFQ==
X-Received: by 2002:a05:6870:d341:b0:1a6:a6fc:f6f1 with SMTP id h1-20020a056870d34100b001a6a6fcf6f1mr720666oag.26.1686965535669;
        Fri, 16 Jun 2023 18:32:15 -0700 (PDT)
Received: from sc9-mailhost2.vmware.com (c-24-6-216-183.hsd1.ca.comcast.net. [24.6.216.183])
        by smtp.gmail.com with ESMTPSA id c15-20020a63724f000000b0053ba104c113sm455042pgn.72.2023.06.16.18.32.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jun 2023 18:32:15 -0700 (PDT)
From: Nadav Amit <nadav.amit@gmail.com>
X-Google-Original-From: Nadav Amit
To: Andrew Jones <andrew.jones@linux.dev>
Cc: kvmarm@lists.linux.dev,
	kvmarm@lists.cs.columbia.edu,
	kvm@vger.kernel.org,
	Nadav Amit <namit@vmware.com>
Subject: [kvm-unit-tests PATCH 0/2] arm64: fix paging issues
Date: Sat, 17 Jun 2023 01:31:36 +0000
Message-Id: <20230617013138.1823-1-namit@vmware.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Nadav Amit <namit@vmware.com>

Two more arm64 fixes, besides the vtimer ISTATUS fix that I recently
sent.

The first patch fixes an actual issue I encountered on my setup and
caused tests to crash.

The second fix is a theoretical one, which I found while reading the
code.

Nadav Amit (2):
  arm64: set sctlr_el1.SPAN
  arm64: ensure tlbi is safe

 arm/cstart64.S         | 1 +
 lib/arm64/asm/mmu.h    | 4 ++--
 lib/arm64/asm/sysreg.h | 1 +
 3 files changed, 4 insertions(+), 2 deletions(-)

-- 
2.34.1

