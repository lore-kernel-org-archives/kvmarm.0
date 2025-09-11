Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D969C31B833
	for <kvmarm@lists.linux.dev>; Thu, 11 Sep 2025 13:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757598580; cv=none; b=XTWrgvQxKpKW488C/IxTcIpSFZwcQErDSC2CUMbt7v6z2Qd+JRi9fIO+C9WkGOc4ZDJT9+F8Dqle5J06/PANiFkzxj+rtRIPe0f7/xkDxdySA2617PVbVKe7bSwtMpYRM3eZluHeSRffmphIjuS4ROi/YtcWwx5Y+W83z18AlEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757598580; c=relaxed/simple;
	bh=T8VtWbZoh0VIipzuyBrHjr9wwGoQSoHS3Ynzhj6XMgs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=DEs431QpzrAZMBF93OvU33iE/e4+lMHY4pUA8TxL+XipXzsjPhJ9XLoGUVJZEMSePPr9lVWiHbbrrxreU0n2UNcZNRewU0J9HqiziG+qEZsI/gHrQd0mjeYHrZYnZETCcCFKXx+9sHkus6AjADojLSk8kh0XPTlWCS1erBQpOaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QVJr09np; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QVJr09np"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-45de60d39b7so5840175e9.0
        for <kvmarm@lists.linux.dev>; Thu, 11 Sep 2025 06:49:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757598577; x=1758203377; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=vEbc34OfcWsmZ87K3FZrtli36glSfRnoXSobn53PJa0=;
        b=QVJr09npl0V/ciiM+32I41wqtT8wJhkFDkib9B3NbJFopQkiOb5qy/tAnwgZfdjiJJ
         4LNcbFKatkLqtyJ+ImiE2KRnhEQmB8DONO0CRNTnTfLSXQtlInlE8e+zk1UMEjIoJwq9
         BfI4Xuf17BU6eRabu1cIqL5QPSiFu6UPQaJ/HCH9zcK27mzk92G8GmAhvLIeRpriKGS/
         L9RlxWGLSX1gjKFro1V15QHvCucVyCNglIirrYlJJ5N7/+a4XbOFamJqsqpYUg2ybD8t
         XD2nD5Vdzmty/mHdGDg348SceooVIC3589rjeOi6N9vuiJH+QBXlC/DUyRiXHDUwQiSZ
         Ujnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757598577; x=1758203377;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vEbc34OfcWsmZ87K3FZrtli36glSfRnoXSobn53PJa0=;
        b=qx+hHKqYTxJ4YMTdphPABkKCGv1yN2gp8SLL1496g9vj2vHg6v4vHoWZCRWqFIL/eS
         DwsRj2VbuLfDThB4g8Zishp1vcDgII5WIJ4Y3rmr5+fZnLWc6U0LtN0DKya24y7znDIA
         R4zvc8uCKISSZ4Raz9GmO2S+WCGE81yUvacB+aZ5a4di2eAcjMgO13UI63T7wLvZbRbv
         MWxJGuyFRMC3facEYoey9CNcxobO7B3sdTwsbMg4TdcpZlIkSLpqQZPcUFaP0oU7YFLF
         zKbVor+Hb5Z3AkZeRozsah8YRnWLn98z93O8d6TeG5jVm0tu4E/HnzXIRVBDh70ZUPT7
         i/Iw==
X-Forwarded-Encrypted: i=1; AJvYcCUFINxUGOyi/3J7JFfuYrgoBMQA0Zr7sXf1abgMC17kTXrIgJO1LTXh0LWXFrQD6U4JkMN7PII=@lists.linux.dev
X-Gm-Message-State: AOJu0YwL7EXYiguP0C6KqtSYuis11i+jik3WYDg4jSTpus0Otnezl1qs
	PWtEcE+U8bkOd3xEv2bnDDYZYhgHLZwe0VaOqsXQ3RfSyh58laJ2fU5O
X-Gm-Gg: ASbGnctVYfDGKEUzsUCJxa7MwkoZHKbhkyOQBa2kZMan+Dx7upvzlDBo7rC5c6CyJPt
	uZ7ZUU6bGaAOBS0bFw8poj2BLEdE244X6meCKUfCI2Ls9U1U4OcgcApxpgJGt2g06Zgi2hxx4EI
	mv5Xb01oGbAcHVIeSaKFFIAlnwBaY9xUnc4TXPBxFUoVYzq9FlU7jbQFVhVIjtxjn6TdtgzO2cY
	IlmisMcW9R66ndCvpCTE0xTZnAahqOevlfe4jYPRXbQBTs7oR9vKOvcDI8vIR9n+ZbtEbbbHKHO
	NmOsa9Bn1dxbVHXxaPfuIKEXwA3JmeL5IO/BfaEIVbK2SPWz8BFgKQ3cmaD/pQzMbYULKbLRLwz
	3gBYQr6kyLYuTnhGq9uZPghOkp6PZdmOYEf1us0daX4Y3ZFOFZkIXzlcnPvN2Ofey+GKzngSQo0
	bqinO8p/0=
X-Google-Smtp-Source: AGHT+IFuIFRdqHBZCko8vFOdNi4YwrG+SNtH2f5JJFAo5fww3TZYrgIbpWxJK/MEue66sSX1sYEkLQ==
X-Received: by 2002:a05:6000:1ac6:b0:3df:f065:ca13 with SMTP id ffacd0b85a97d-3e64392b761mr17129810f8f.33.1757598577050;
        Thu, 11 Sep 2025 06:49:37 -0700 (PDT)
Received: from f4d4888f22f2.ant.amazon.com.com ([15.248.2.27])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e760778915sm2608361f8f.12.2025.09.11.06.49.35
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 11 Sep 2025 06:49:36 -0700 (PDT)
From: Jack Thomson <jackabt.amazon@gmail.com>
To: maz@kernel.org,
	oliver.upton@linux.dev,
	pbonzini@redhat.com
Cc: joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	shuah@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	isaku.yamahata@intel.com,
	roypat@amazon.co.uk,
	kalyazin@amazon.co.uk,
	jackabt@amazon.com
Subject: [PATCH 0/6] KVM ARM64 pre_fault_memory
Date: Thu, 11 Sep 2025 14:46:42 +0100
Message-Id: <20250911134648.58945-1-jackabt.amazon@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jack Thomson <jackabt@amazon.com>

Overview:

This patch series adds ARM64 support for the KVM_PRE_FAULT_MEMORY
feature, which was previously only available on x86 [1]. This allows
a reduction in the number of stage-2 faults during execution. This is
beneficial in post-copy migration scenarios, particularly in memory
intensive applications, where high latencies are experienced due to
the stage-2 faults when pre-populating memory via UFFD / memcpy.

Patch Overview:

 - The first patch is a preparatory refactor.

 - The second patch is adding a page walk flag for pre-faulting.

 - The third patch adds support for the KVM_PRE_FAULT_MEMORY ioctl
   on arm64.

 - The fourth patch fixes an issue with unaligned mmap allocations
   in the selftests.

 - The fifth patch updates the pre_fault_memory_test to support
   arm64.

 - The last patch extends the pre_fault_memory_test to cover
   different vm memory backings.

[1]: https://lore.kernel.org/kvm/20240710174031.312055-1-pbonzini@redhat.com

Jack Thomson (6):
  KVM: arm64: Add __gmem_abort and __user_mem_abort
  KVM: arm64: Add KVM_PGTABLE_WALK_PRE_FAULT walk flag
  KVM: arm64: Add pre_fault_memory implementation
  KVM: selftests: Fix unaligned mmap allocations
  KVM: selftests: Enable pre_fault_memory_test for arm64
  KVM: selftests: Add option for different backing in pre-fault tests

 arch/arm64/include/asm/kvm_pgtable.h          |   3 +
 arch/arm64/kvm/Kconfig                        |   1 +
 arch/arm64/kvm/arm.c                          |   1 +
 arch/arm64/kvm/hyp/pgtable.c                  |   6 +-
 arch/arm64/kvm/mmu.c                          |  97 +++++++++++++--
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 tools/testing/selftests/kvm/lib/kvm_util.c    |  12 +-
 .../selftests/kvm/pre_fault_memory_test.c     | 110 +++++++++++++-----
 8 files changed, 186 insertions(+), 45 deletions(-)


base-commit: 42188667be387867d2bf763d028654cbad046f7b
-- 
2.43.0

