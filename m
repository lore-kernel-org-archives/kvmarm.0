Received: from mail-il1-f201.google.com (mail-il1-f201.google.com [209.85.166.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A991E19B
	for <kvmarm@lists.linux.dev>; Tue,  7 Feb 2023 23:33:07 +0000 (UTC)
Received: by mail-il1-f201.google.com with SMTP id d2-20020a056e021c4200b00313bdffad9aso6171040ilg.1
        for <kvmarm@lists.linux.dev>; Tue, 07 Feb 2023 15:33:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=N6h618a8IiC/nGqLszjY9LqsjtRfc/MrCQyIIfIRceU=;
        b=kKnQH6i3lSpXOlPwaSR1R49mnXTs6pFalqV3F1N2sYxJBIymUDjZovHWsHbY0T6aEI
         FiN1OTfFRVrjs6cdJBMAb7c1ENszzTCF/oe6vqMi3JCn45OE6qWv6Gz8I6+wWC9VLqF0
         uPntNR9b2YP3br1S6wbHaGWYOo2ccRXK0GDxow3dXHGkej/ItybydTdY7EBFA2Aq0tCo
         EXGDy5JGs5J0kcRuzJ2Koyo+j4R1P1UnXcEqyg02N7dedpr0XKQcFOGiM7oO4uDNQemp
         HaZ2vCzk0u0v4G7KvlHno3j5lt4+zzaK7FO81YzBhx6f42eFh179ybgHVIP+iGpt5lfb
         spzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=N6h618a8IiC/nGqLszjY9LqsjtRfc/MrCQyIIfIRceU=;
        b=P7MAI5za9TdbjVB+sc1szRbzIXTxWkFIpBdffSO8YL3A1mDxRpvQRui62frKUAWls6
         Mpfo5WIhDtaH5ncSJ89YC1EwpHw7CDUnwuaD3FTPisqWte9yypWhcMfh8nAmDgDyka9q
         wHKQVwaDAkSKnyum2HkGUPkMs2xxppiGZAN8betzXZkMXMpZWxlpQfGoHU0lHUfKvg9R
         +S7k9+9SqHAIJqmaeqL8h1CPT5z7L5f6pf1wwAknfK5OFh51ByYt5yWekmN3Wc3/0Z7B
         5FCg1AQdvLcgBd0hlYaTbEqXy2kTAWb/fGMI+fsXUkH1AlZ7AE/al7kcelKu2b1Dw4XB
         G1Rg==
X-Gm-Message-State: AO0yUKXcjLGBrLfuGLD088WhMuifI7IBftMCj+oaZASJevbyjgbtpoCE
	ufOpKhaG18fJ4HVFnz2ZMDQcRW98T83iY0Juvw==
X-Google-Smtp-Source: AK7set+k/u2kIySuEIR0kebO9mmsun3MYIoosq2YGY/w2M2IQl+7JdSKgUbauDGYTzIKCDoA322OA+aSPUaU28+RSw==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a02:b691:0:b0:3b1:92c0:ac28 with SMTP
 id i17-20020a02b691000000b003b192c0ac28mr3685028jam.74.1675812786710; Tue, 07
 Feb 2023 15:33:06 -0800 (PST)
Date: Tue,  7 Feb 2023 23:32:56 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
Message-ID: <20230207233256.3791424-1-coltonlewis@google.com>
Subject: [kvm-unit-tests PATCH v5] arm: Replace MAX_SMP probe loop in favor of
 reading directly
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
 scripts/runtime.bash | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

v5: Remove the last awk reference and guard the probing code with a
check that ARCH = arm or arm64.

v4: https://lore.kernel.org/kvm/20230201172110.1970980-1-coltonlewis@google.com/

v3: https://lore.kernel.org/kvm/20230130195700.729498-1-coltonlewis@google.com/

v2: https://lore.kernel.org/kvm/20230111215422.2153645-1-coltonlewis@google.com/

v1: https://lore.kernel.org/kvm/20221219185250.631503-1-coltonlewis@google.com/

diff --git a/scripts/runtime.bash b/scripts/runtime.bash
index f8794e9a..fb64e855 100644
--- a/scripts/runtime.bash
+++ b/scripts/runtime.bash
@@ -188,12 +188,11 @@ function run()
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
+# error first, so this check is only run for ARM and ARM64. The
+# parameter expansion takes the last number from the QEMU error
+# message, which gives the allowable MAX_SMP.
+if [ "${ARCH%64}" = arm ] && smp=$($RUNTIME_arch_run _NO_FILE_4Uhere_ -smp $MAX_SMP \
+      |& grep 'exceeds max CPUs'); then
+	smp=${smp##*(}
+	MAX_SMP=${smp:0:-1}
+fi
--
2.39.1.519.gcb327c4b5f-goog
