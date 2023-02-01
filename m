Received: from mail-il1-f202.google.com (mail-il1-f202.google.com [209.85.166.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 034CD8492
	for <kvmarm@lists.linux.dev>; Wed,  1 Feb 2023 17:21:35 +0000 (UTC)
Received: by mail-il1-f202.google.com with SMTP id z12-20020a92d6cc000000b00310d4433c8cso8832800ilp.6
        for <kvmarm@lists.linux.dev>; Wed, 01 Feb 2023 09:21:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vixU9pzYhiOIncz9zX7lMuKnpujKybYqZj2xZH7tetQ=;
        b=sQEjai0uI3qOrLb6DRDGWSLF38T3/lb+HhYxA9+PZAfg2jPauHRpIvyVUjOkOmtSAk
         5dryqdBMCQNqG8NWE1+YzakqVh13rtbsvpL4S6N40CpAr6OE1jF1PH6m0nL/vtGnzFC/
         jqiuJtdtHt4+YZIuFoZEOTRYHnpbSGq4AJCfcK1TBpTR0RfufarXi+pe9bjLLxKjD1GZ
         aQO8lHp3nwbklsf6IUiRL9WoNumJBkuwL+Bsx50k3Y9RGqMAMuYAHrM30DQ0gA3vrgVe
         3/lshYL0mNpKeQJq9ib8EOeL/fDcyTqVmJ6wuq3yPBKJjVU0IUkY/GgFZ/nQsjjljuII
         ellA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vixU9pzYhiOIncz9zX7lMuKnpujKybYqZj2xZH7tetQ=;
        b=Ko4MNvv6ckaUKuZ7mKTKY6qf+6B5WXVUYZd5pDIlGAuiwrAHhqTZlM+ju2RDQUcuHq
         4svc3dplaUENxGEWwvV4MSIpd8SgnBN+sAA2Wmy6e66gpQW5uMIcfWWeDvVj1jignXui
         eFBDpiRAdrmphC00MSwoD+QglXPXGJg7+LYM+fKfIZMXPgfud1L45bUeGXxr+5H4k/w2
         UwEpZmEC4CWvp+1stubo1nw2NnSGFmctxJIffN0aNO+oYnUTc7pS6ZEdbMJyk4LueWqv
         xSw48ytS0M27KbN9J4FcWizm0E33WAhKCyBEz8VVBMtbjnQ6YW2p8rhwygZGyezFK57B
         bMyg==
X-Gm-Message-State: AO0yUKXeu2Sa5xfERvLjHqOVoRurdKZoCeE9Hcg2nSppgdGCWjtc9rG4
	nOHDbcmfCcJBNrlwhciAptADc0CTElBNzkcDmA==
X-Google-Smtp-Source: AK7set+UzX3gG1XPgKuvwDtcN7U1fDyg7jbdKztXIPTFDY92+NzE9OAAn4OUdFJxb6VsVVYZM30v2et1JJQ9EOpnTg==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a92:c712:0:b0:310:9907:2319 with SMTP
 id a18-20020a92c712000000b0031099072319mr612423ilp.113.1675272095007; Wed, 01
 Feb 2023 09:21:35 -0800 (PST)
Date: Wed,  1 Feb 2023 17:21:10 +0000
In-Reply-To: <20230201172110.1970980-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230201172110.1970980-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.39.1.456.gfc5497dd1b-goog
Message-ID: <20230201172110.1970980-2-coltonlewis@google.com>
Subject: [kvm-unit-tests PATCH v4 1/1] arm: Replace MAX_SMP probe loop in
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
error message line indicates the max QEMU supports.

This loop logic is broken for machines with a number of CPUs that
isn't a power of two. This problem was noticed for gicv2 tests on
machines with a non-power-of-two number of CPUs greater than 8 because
tests were running with MAX_SMP less than 8. As a hypothetical example,
a machine with 12 CPUs will test with MAX_SMP=6 because 12 >> 1 ==
6. This can, in rare circumstances, lead to different test results
depending only on the number of CPUs the machine has.

A previous comment explains the loop should only apply to kernels
<=v4.3 on arm and suggests deletion when it becomes tiresome to
maintain. However, it is always theoretically possible to test on a
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

