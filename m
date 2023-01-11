Received: from mail-io1-f73.google.com (mail-io1-f73.google.com [209.85.166.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05C1917EA
	for <kvmarm@lists.linux.dev>; Wed, 11 Jan 2023 21:55:26 +0000 (UTC)
Received: by mail-io1-f73.google.com with SMTP id z9-20020a6be009000000b006e0577c3686so9852396iog.0
        for <kvmarm@lists.linux.dev>; Wed, 11 Jan 2023 13:55:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5+Lc80XI6+/XFtzqxxXoccg5ZlmmZp+XMvjzGNjlgdY=;
        b=pr0T7+PBBqvw8ZDsfjBgUZvMxddbqCU2+hLCUXb5Q/KNZ5wGdziczOEwtEzvV4FSxp
         Bl7Jra9HhzQ7/NUopse/UBLr5cK8fb8aRnbZB4+PDoHIJaOxwmc8kNpy76z7d2wd8su8
         l+I2M3eQ+g5rzaSJvRtvE8KU+d2Up0JrW5+6yhGfU8i/lZ+Mk/yuaUyDYMeIlsEWzmwz
         E+1q8xjwP0deCiIJ9yVWd7lyka48i5ZQ1jYV9CcEC95pHA8TopwNRc2BfRi+ExZmVDce
         DL2JkDQnLsjTrP/O58FSpAlsql0DlR91nWEuYFn3KMiALJYfBbu7/RPhPlfbJZzt88IK
         Bevw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5+Lc80XI6+/XFtzqxxXoccg5ZlmmZp+XMvjzGNjlgdY=;
        b=yNCtiC5I1cXXc9QDkZKXYfOgu9gs4osa2BydK3vZS4l3rwed9SmGR7I/+oCNRWv0jx
         r3RFS9OahYGQxmN7mbbcoheknSJd5bPcJuXos9atAL7qAv5ERXXgD8JidAF3xBjVe/Yc
         12fDroxzcw/yf8YxERhxUXqG2E7jGTOsxsi5fIfO6kEGQ0HagDvLb/lADKSBNj4jJCqH
         hXC7WQSt9lY1fMXYf0uixMOyzoVXYzcruA4DDSc48f0ylDFKtSz2rO4HhapQDQ25FDrR
         21UxYrdL/BcO1YJma8ssMsZqUbEPgxIzCcVRrzT2irYABG7NAtfBW9WjVrONjCgiM7V4
         GOrQ==
X-Gm-Message-State: AFqh2kqkWMPFvyLJr4FUOIesTuTnDhLNRnElHjSaIaDWAkgjjqKDYl9d
	bVH9QFwIg69QUBUQJhoUwTsqFuRAVNA03Wl+Yg==
X-Google-Smtp-Source: AMrXdXulAe/2ABqltLbTgZW1LSdHJugjxwY87bzglaZvzTwnfUG6Pl+BSLM/nDkAXj74lzq+bOcj5pSZe+zjuAIXNw==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a92:d6cd:0:b0:30d:b0fe:852f with SMTP
 id z13-20020a92d6cd000000b0030db0fe852fmr1171090ilp.126.1673474126135; Wed,
 11 Jan 2023 13:55:26 -0800 (PST)
Date: Wed, 11 Jan 2023 21:54:22 +0000
In-Reply-To: <20230111215422.2153645-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230111215422.2153645-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20230111215422.2153645-2-coltonlewis@google.com>
Subject: [kvm-unit-tests PATCH v2 1/1] arm: Replace MAX_SMP probe loop in
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
isn't a power of two. A machine with 8 CPUs will test with MAX_SMP=8
but a machine with 12 CPUs will test with MAX_SMP=6 because 12 >> 2 ==
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
index f8794e9..4377e75 100644
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
+if $RUNTIME_arch_run _NO_FILE_4Uhere_ -smp $MAX_SMP \
+      |& grep -qi 'exceeds max CPUs'; then
+	GET_LAST_NUM='/exceeds max CPUs/ {match($0, /[[:digit:]]+)$/); print substr($0, RSTART, RLENGTH-1)}'
+	MAX_SMP=$($RUNTIME_arch_run _NO_FILE_4Uhere_ -smp $MAX_SMP |& awk "$GET_LAST_NUM")
+fi
-- 
2.39.0.314.g84b9a713c41-goog

