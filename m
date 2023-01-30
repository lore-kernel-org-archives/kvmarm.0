Received: from mail-il1-f201.google.com (mail-il1-f201.google.com [209.85.166.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 203C479E0
	for <kvmarm@lists.linux.dev>; Mon, 30 Jan 2023 19:57:30 +0000 (UTC)
Received: by mail-il1-f201.google.com with SMTP id v6-20020a056e0213c600b00310f8577354so2059970ilj.9
        for <kvmarm@lists.linux.dev>; Mon, 30 Jan 2023 11:57:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=z6gmmqhW+IYMWFDbVJ6/MzX/KNEajJSwcYQ2uFtyuKg=;
        b=gxhr32GQ/xmstpGaP6PU3nXe9xpqy+d/8NVc6YHwr1nBBOdSeldA/6eaMdZQX+v2aS
         xFUmIzD3Leqz5t6p59w6JbsjDnacODp50bzhKIx3GvBCOJOpCnJC2IjZV6sd/Rr7JR3h
         rHctNUPPwM0ToIiexs9RIvPT9XZ/q/Txcn1K/0MFq37uf4YB6Jg0mdauEdcbqlNVd9X5
         jc+u7nsvGex+Pp6bkYSWuGFVadvf8hqfnUu59SMxocdCSnsL4Yb2NNYHVQwFjgHUxpo9
         W7yQxl468d63dupQfPoVQs3fjurPG+MjAcdsdtaoMIeEMz2/bRh8lwO8Th5AJRi5H74g
         YlRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=z6gmmqhW+IYMWFDbVJ6/MzX/KNEajJSwcYQ2uFtyuKg=;
        b=VH2OwbAfT8RaCVF0R+uRHVUwk3I1IYXLXHRSlp4X0qZpPKThKWQxndOG6dKBwILSBe
         rjETEQ8q+uCr6wTjTBXGzZs/qCGyvmCNWc9YIXXlM6aVbYdl4JKH4kUOvfOodDMCDnE3
         v1t+V74z3s8mI7WebPdXs762n36oAZB3bz1P3BVjiOXyMezi8MsQXQ58UlRx+2LZW9Hh
         CK6quL2q78dF5haNqaA+1F5bA4k1TA/vyn9XwLEw2xu6pJLb/ThUJXGcMKejHeD1ytQE
         zMiZN8itkoCpZn7Xijn1berwkYfah2VX6MC93YaRLL1A2NHoYVbnhx+IsWKcnwCyWrTx
         mFnQ==
X-Gm-Message-State: AO0yUKUh35z1yyNUUDyxqO1ain+5J+VTbrxxcLarxv/CbJgaEbQj8SDU
	9aigfcueZn3TPJrrJ5ERyUPvTQNFW/qD2GTNeg==
X-Google-Smtp-Source: AK7set97xhUn/2/FFkoBCuXCQijzY8JuzQ6elQ9xGjGwxoBZ5lilAcTCzVWqgl+9QXnl02zRuqImqwyDioJ5rI4tZw==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a6b:c817:0:b0:71a:b7de:6e1c with SMTP
 id y23-20020a6bc817000000b0071ab7de6e1cmr931509iof.87.1675108650087; Mon, 30
 Jan 2023 11:57:30 -0800 (PST)
Date: Mon, 30 Jan 2023 19:57:00 +0000
In-Reply-To: <20230130195700.729498-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230130195700.729498-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.39.1.456.gfc5497dd1b-goog
Message-ID: <20230130195700.729498-2-coltonlewis@google.com>
Subject: [kvm-unit-tests PATCH v3 1/1] arm: Replace MAX_SMP probe loop in
 favor of reading directly
From: Colton Lewis <coltonlewis@google.com>
To: thuth@redhat.com, pbonzini@redhat.com, nrb@linux.ibm.com, 
	andrew.jones@linux.dev, imbrenda@linux.ibm.com, marcorr@google.com, 
	alexandru.elisei@arm.com, oliver.upton@linux.dev
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Replace the MAX_SMP probe loop in favor of reading a number directly
from the QEMU error message. This is equally safe as the existing code
because the error message has had the same format as long as it has
existed, since QEMU v2.10. The final number before the end of the
error message line indicates the max QEMU supports. A short awk
program is used to extract the number, which becomes the new MAX_SMP
value.

This loop logic is broken for machines with a number of CPUs that
isn't a power of two. This problem was noticed for gicv2 tests on
machines with a non-power-of-two number of CPUs greater than 8 because
tests were running with MAX_SMP less than 8. As a hypthetical example,
a machine with 12 CPUs will test with MAX_SMP=6 because 12 >> 1 ==
6. This can, in rare circumstances, lead to different test results
depending only on the number of CPUs the machine has.

A previous comment explains the loop should only apply to kernels
<=v4.3 on arm and suggests deletion when it becomes tiresome to
maintian. However, it is always theoretically possible to test on a
machine that has more CPUs than QEMU supports, so it makes sense to
leave some check in place.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 scripts/runtime.bash | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/scripts/runtime.bash b/scripts/runtime.bash
index f8794e9a..587ffe30 100644
--- a/scripts/runtime.bash
+++ b/scripts/runtime.bash
@@ -188,12 +188,10 @@ function run()
 # Probe for MAX_SMP, in case it's less than the number of host cpus.
 #
 # This probing currently only works for ARM, as x86 bails on another
-# error first. Also, this probing isn't necessary for any ARM hosts
-# running kernels later than v4.3, i.e. those including ef748917b52
-# "arm/arm64: KVM: Remove 'config KVM_ARM_MAX_VCPUS'". So, at some
-# point when maintaining the while loop gets too tiresome, we can
-# just remove it...
-while $RUNTIME_arch_run _NO_FILE_4Uhere_ -smp $MAX_SMP \
-		|& grep -qi 'exceeds max CPUs'; do
-	MAX_SMP=$((MAX_SMP >> 1))
-done
+# error first. The awk program takes the last number from the QEMU
+# error message, which gives the allowable MAX_SMP.
+if smp=$($RUNTIME_arch_run _NO_FILE_4Uhere_ -smp $MAX_SMP \
+      |& grep 'exceeds max CPUs'); then
+	smp=${smp##*(}
+	MAX_SMP=${smp:0:-1}
+fi
-- 
2.39.1.456.gfc5497dd1b-goog

