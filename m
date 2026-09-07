Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 006862F30
	for <kvmarm@lists.linux.dev>; Mon,  7 Sep 2026 04:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788756296; cv=none; b=RzWeH7dzP6tcRojNzxZbtS1+v680X8Gz5qkUtE8foOQK2auKCupEDP7YH34TemiOzriETan8zSnqmM6cO96T8WX9XVKqTrign/m6qfcbIR8GSJ1teUTsqhJd7xpfe+W672v3ISI4/nLBQO+bx7nOF/i/44XMkC62GprBIFVNyH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788756296; c=relaxed/simple;
	bh=q/VShi8y2Rb70ozxxxWRAtjTcKmlnjijX7MzBXAKbSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XTRtUMwQm1t6KXhiVRAsoTpgxh+5AE38fNMQFotu5rYxQZ1de59jb4FcjKCY68TuCX1sIkyATObPp/CjPYjaXW1yByoaY3DrBqqfTjxpTuMyV5NqmAJyRrejNhDVPeikbvIWgpbw0VJE498GNW5z3SbveqVN96QXUrtkyRqNcyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SmByheap; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SmByheap"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-85339ed040aso2322261b3a.1
        for <kvmarm@lists.linux.dev>; Sun, 06 Sep 2026 21:44:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788756294; x=1789361094; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NsCXtS0F1ozalP9OgDEtI+4ABXzVdG2gEkR2YSb8sls=;
        b=SmByheapjiEmdX13e3785xe9umiVsGcJT7LJG8isDeOyV6wcHP5B70tfkYBZ6VKf4k
         Bq88x+bjFgvdjtG5dp2B/lAH+eFPJUHMJaCnlcnqa6NxaciQWDn8HQySVeFR/iCJENzC
         UhxT7qqgFi/FM2rxzWIKEY4Nc7DmSEon98Shg8sinENBugiRk5qlN9Rh3HiCm/sLFuow
         6n7MNGO488ZVGykxXpXM+Mj443otuoYWGuv3pmokZciljpWLgz/OtuhEqRztNoempVfq
         PACBCFGyaW44xz/HEbIYZ2s84oiJ2mNhja/9OCHGstKaPb2fUKB5ARQN9qpxH1AObgxx
         7qAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788756294; x=1789361094;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=NsCXtS0F1ozalP9OgDEtI+4ABXzVdG2gEkR2YSb8sls=;
        b=T1x8y8Iv/QqV7jgUh7nhizlhqgFOEaGpkNqG8yZQ7ApZk9zYP+VXP8UlOMnJ0A4Pz0
         aV+tV19rz46Q3PI8quruy2sifjqt8VF8vRRRNHpC9QxKL2aos04iPsNHl5FX8AtOoLL5
         00b4RWewaOQVG7XQYZpEhSrwwucrEOyvW7ZmO4/oIav7/rqY6zh5sn6wYky2MTNO4yVr
         00jJmqnhw5gy5ReyO7C0jlMCTuwplTPuw0gDCwORnZL+umoZdUccV8kpZrMCPZ3AErDN
         X41y5r68xVPz0xRSrC+xQ0vxvVGVPEaKQjHb91g8m2dxqQkbZfRYLCUXodjzJvPFHhxx
         rNdg==
X-Forwarded-Encrypted: i=1; AKwUvByIYQq2GcEYSQov1IjSVDV00NE5/7d2l+3+Oy5jQCTyVoc7XznoHMiKJ416WM++Ltmz4Qn+ywM=@lists.linux.dev
X-Gm-Message-State: AFuF++kal3RAQMul4cLGpgA7slDQg6l/2yHhwyddlTnLLCZ2wBoeZoWg
	8Dx/HhtBx7iy2J5Nx8ogRqw0OQz7hailKBm4QmoXr+JUWkTejtUVG3YK
X-Gm-Gg: AYBFou1Iha5fHektCx/YvSYTQx8bKZyk1EGguXeue6hBiIPLRYV7A3zovJorQrOW2CK
	N/pAvJH3irkcs8ebHJIcywUfwiK/W40GXvV+Q2IhEEngFu6g3icN6QuXjBJ5b++j4HkI/AmiG5d
	sMksOTiNT7tRJqMDt0DOnEBQZFzZG7Vrk8VtXMta+xvsYW9XDqn0gHRAkVIXV/MecOgC8IqRH03
	QLUw8HvvU/ZuNMj4b4TrOOZ159gHJoyMiVMQDbNXFZeVx9ymKamijYXQzBr1ZqvT+Nr2duZJi/T
	Ecb9eaQsVwFo2jP8pL3Uj2b8aA1oQNSVzsdLvh/s4igY7AEUmo4YVVCwv2VFLHg8tL0te/tvELc
	Z+3KgX4xxlAh5zgeicw4s80PcAUg0PphEGsH+KYI3XU8+qQEW+C3IoXQ6l7isPDlFnNbCMZsST2
	iempAz+phciEXrpHJ8fuU0RkrXeu3mJNfuyqKh2UAom0FlB5gAgpKQm4vtAW5tnSf9RMdqEqEk0
	/YqzKMSq/qMLw==
X-Received: by 2002:a05:6a20:9630:b0:3cd:9f0b:f7a2 with SMTP id adf61e73a8af0-3da39ee15d0mr32834555637.11.1788756294346;
        Sun, 06 Sep 2026 21:44:54 -0700 (PDT)
Received: from volcano9f6e-hostos.amd.com ([165.204.217.251])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3339af25062sm37823751eec.16.2026.09.06.21.44.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Sep 2026 21:44:54 -0700 (PDT)
From: Hemanth Selam <hemanth.selam@gmail.com>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH v2 2/3] selftests: kvm: fix typos in comments
Date: Mon,  7 Sep 2026 10:14:33 +0530
Message-ID: <20260907044434.4682-3-hemanth.selam@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20260907044434.4682-1-hemanth.selam@gmail.com>
References: <20260907044434.4682-1-hemanth.selam@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix typos in comments, reported by scripts/checkpatch.pl using the
misspelling list in scripts/spelling.txt.  Only touches comments, no code
changes.

Assisted-by: Cursor:claude-opus-5
Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
---
 tools/testing/selftests/kvm/arm64/debug-exceptions.c | 2 +-
 tools/testing/selftests/kvm/arm64/hypercalls.c       | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/arm64/debug-exceptions.c b/tools/testing/selftests/kvm/arm64/debug-exceptions.c
index 7dc5f0b4f6ad..9da6dc5bcfe6 100644
--- a/tools/testing/selftests/kvm/arm64/debug-exceptions.c
+++ b/tools/testing/selftests/kvm/arm64/debug-exceptions.c
@@ -387,7 +387,7 @@ static void guest_code_ss(int test_cnt)
 		 * Enable Single Step execution.  Note!  This _must_ be a bare
 		 * ucall as the ucall() path uses atomic operations to manage
 		 * the ucall structures, and the built-in "atomics" are usually
-		 * implemented via exclusive access instructions.  The exlusive
+		 * implemented via exclusive access instructions.  The exclusive
 		 * monitor is cleared on ERET, and so taking debug exceptions
 		 * during a LDREX=>STREX sequence will prevent forward progress
 		 * and hang the guest/test.
diff --git a/tools/testing/selftests/kvm/arm64/hypercalls.c b/tools/testing/selftests/kvm/arm64/hypercalls.c
index 5d96cdf382c4..a24becda9e62 100644
--- a/tools/testing/selftests/kvm/arm64/hypercalls.c
+++ b/tools/testing/selftests/kvm/arm64/hypercalls.c
@@ -1,9 +1,9 @@
 // SPDX-License-Identifier: GPL-2.0-only
 
-/* hypercalls: Check the ARM64's psuedo-firmware bitmap register interface.
+/* hypercalls: Check the ARM64's pseudo-firmware bitmap register interface.
  *
  * The test validates the basic hypercall functionalities that are exposed
- * via the psuedo-firmware bitmap register. This includes the registers'
+ * via the pseudo-firmware bitmap register. This includes the registers'
  * read/write behavior before and after the VM has started, and if the
  * hypercalls are properly masked or unmasked to the guest when disabled or
  * enabled from the KVM userspace, respectively.
