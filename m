Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D0ECC2E6
	for <kvmarm@lists.linux.dev>; Wed, 23 Aug 2023 20:11:25 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-c8f360a07a2so6602092276.2
        for <kvmarm@lists.linux.dev>; Wed, 23 Aug 2023 13:11:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692821484; x=1693426284;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Z0FP+hPub/nKJVBpaXkcDppbwPaEend4VotzFjUig+0=;
        b=EjzFJdOuHMo8ki1aUa7VnSBn5TjF7TKaD+W2f6rfyMLMmxKorIZZCf65hwwa880/TE
         3+G/k1sMKK9b+Oy/sToisvWp5ND0/wVYkvluPwPi8KdTNU1DWzGY6O0G9Vbo3Ta6HHW/
         79Hp40nvyu7DidHlL5NLJjsVIijd8uG3IN3qxDsZ8REddcbpgSaGxDOnMmJrdowGyAtG
         uJDXWlZF0pyJDhjnGvjHZzRvIzWOBhvZhtbFw1T93UVM4FzVceOKFATUao3q7ryn1m37
         LDKkc/RAkBHnyZIU+X0u6J7/YNYnJfYmysepP77vdaSJEVRWAprXWTWkUjzL8wMEhMMx
         neDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692821484; x=1693426284;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Z0FP+hPub/nKJVBpaXkcDppbwPaEend4VotzFjUig+0=;
        b=DLQfYefcOWtpMAVb4uKhiL6UKedIInITgFVVKQJkauIZiF2DSzZP2nYtSl3zvO5s7V
         1FjAHRzcoUv8UwM6DWqua8b9+tUCuef9KtwJF+mNZSChPgtGpwePuKDx6DMVCASxw38y
         8q688CTGn7LARSrhwKujvu04KNeWQVaeHjUJCdd4w6XmErbc2vVnVwj1Cfnluce8TkiU
         d6eCW1lug2hXF2z4FpejfJlxR4hv8s5a6/NhZakW3D7Hd9buppIAJ0CqeyW+IqWjoOvQ
         u+dH74Rudph5l6HoXg7XEwOtWeUOlb11V1x5e2li9lgc2/XT2AgTdACPuKDnUToSBq4U
         /mRg==
X-Gm-Message-State: AOJu0YwFt9MJWh2mbLLdxab4R+bOOrI5GB/OEboEEO6M/l4/Lb8eBDpG
	S7D/w2+aaZFde45SJhN11mOihpJtSCiMrsgj8Q==
X-Google-Smtp-Source: AGHT+IGTqSfTI5bR/0j1hk91mJSFgF9aSd9HvOFQB8d1/WPp9UdimxMPsLgl8W2nNetxghJu0FgyfzGO3pfev32XYg==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a25:d809:0:b0:d01:60ec:d0e with SMTP
 id p9-20020a25d809000000b00d0160ec0d0emr190756ybg.9.1692821484792; Wed, 23
 Aug 2023 13:11:24 -0700 (PDT)
Date: Wed, 23 Aug 2023 20:04:08 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.42.0.rc1.204.g551eb34607-goog
Message-ID: <20230823200408.1214332-1-coltonlewis@google.com>
Subject: [kvm-unit-tests PATCH] arm64: microbench: Benchmark with virtual
 instead of physical timer
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Andrew Jones <andrew.jones@linux.dev>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Eric Auger <eric.auger@redhat.com>, Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev, 
	Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Use the virtual instead of the physical timer for measuring the time
taken to execute the microbenchmark.

Internal testing discovered a performance regression on this test
starting with Linux commit 680232a94c12 "KVM: arm64: timers: Allow
save/restoring of the physical timer". Oliver Upton speculates QEMU is
changing the guest physical counter to have a nonzero offset since it
gained the ability as of that commit. As a consequence KVM is
trap-and-emulating here on architectures without FEAT_ECV.

While this isn't a correctness issue, the trap-and-emulate overhead of
physical counter emulation on systems without ECV leads to surprising
microbenchmark results.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arm/micro-bench.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arm/micro-bench.c b/arm/micro-bench.c
index bfd181dc..fbe59d03 100644
--- a/arm/micro-bench.c
+++ b/arm/micro-bench.c
@@ -348,10 +348,10 @@ static void loop_test(struct exit_test *test)

 	while (ntimes < test->times && total_ns.ns < NS_5_SECONDS) {
 		isb();
-		start = read_sysreg(cntpct_el0);
+		start = read_sysreg(cntvct_el0);
 		test->exec();
 		isb();
-		end = read_sysreg(cntpct_el0);
+		end = read_sysreg(cntvct_el0);

 		ntimes++;
 		total_ticks += (end - start);
--
2.42.0.rc1.204.g551eb34607-goog
