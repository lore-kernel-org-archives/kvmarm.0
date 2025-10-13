Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08B5F260566
	for <kvmarm@lists.linux.dev>; Mon, 13 Oct 2025 15:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368532; cv=none; b=jVvy1KNyypvVqPbAI1615oO86mqz6rnRwJj13u9uSnO1V51+1gNH9uYpv6Gcr4FFVacdNSLUb+4F1FSjCAU22irqy+o0PZbcS6HCPeTLVafJT9e2tJROnrTN3H6jEp6iP6kdC4A00WyQLtDrG+saqsmvAJ7gAk2jEOaOGZPRMZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368532; c=relaxed/simple;
	bh=u9a3zosxSdz3WZpPJYTywNjxVaWRBJXzveMfBERek7A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EX3P4Ug0OR4ALBCtGFqsEa+vGK0bPXtAygfweqR0INlK90A0YMsTC0uCjQIfLMoIvpEfyarXzxTc2TUIvGQgGERKZ/iJuKhjn23x3aKu+LC32miBWqVNTnIVuIzPWGAYm0UHYkGf1l/OOhCpmX2LjyweKj3ns9ffU3a8EyFKbeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nlnFB6nD; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nlnFB6nD"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-46e4ad36541so46223175e9.0
        for <kvmarm@lists.linux.dev>; Mon, 13 Oct 2025 08:15:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760368529; x=1760973329; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=H9v2BaCzqTwwaKihxHneX2NKtRg+AsrUK2wCvz8acXU=;
        b=nlnFB6nDZLdbxEs+3DBwCezZ1oYtSF0+yqLK5BUhraXe0tSh2HzRqp30bo3yzyi1Nf
         V68QGeDijtfRMRGncOsWI8DdAv0f+VdACyrCWTM365A8+d6QjQCrtzKCNoJjQ9i4dEQu
         hK2SQC1yb3gLzVucNkCvKYsnTaZnWzbqLjFJn8Hs4/psSkBzq3dl3z139r6dZo2SSm/Q
         dUhg8Zk0a8c4o6cqYbwCsgRs21jxsVNbMit3Sss7CfaVIK7TBU6X+0FtKACtL9qjG7X6
         HJqwwky81B8CCFNjy/qSlJYTdEbIicoynmOd2oDHp2I/+Cc/t2w65pNIgAraU0P7ayeu
         sLnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760368529; x=1760973329;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=H9v2BaCzqTwwaKihxHneX2NKtRg+AsrUK2wCvz8acXU=;
        b=q6Re3eSrkEZLzqlIvbnto0Tf13pSrTarbLntIabgaaz7PJxxU8uyhOVCyDjoa/yoeN
         Kl5VFfkqDz49sQMlu+gT+U4FhaoeG0Y763NEgGlFwO4hOWd4aHUjyDq1FFUW4d6IoPOZ
         hLqphizTiaFUIKLa7xsh6g8GNGzewlUZBm67dkds6ufUrIjYjaYrAWelHL6l7sNoIiSK
         dmtY6O7kcFBdz7C1aS+lAjqHDxYZw/Kf75tvasYY8Y5s9WMD2KDmJQ2wjfLptuePkxYq
         j2pkw/l6a2auRY83QlqH9PLOpSFsa8sRzmAdT6lzLG3JqrQEIqFqqI/cTKEldNOmSSra
         Uj9w==
X-Forwarded-Encrypted: i=1; AJvYcCWYEz0MmLFKxxrA4YqHQH3+LOWPb3k64cDma6i7YRlcUafcvI5Ys52VGP3iwjX73oEuITuzh5M=@lists.linux.dev
X-Gm-Message-State: AOJu0YzSU2OsGPh+qtcmZykyObw5rOwrVsDnWx1E7S7TaBl2n3sKmrII
	TIYMdjnptJvR7Q5OwyKr7uSR5LZkhhz0AYSe+1fVNPVxH6Ouk+w8iDKN
X-Gm-Gg: ASbGncu6ONoMbazGdnuzcALAXfIRao6fs0+eGiyCNMCwtTdpL4HGfFcnIyM+B96d3zh
	882ILFKmcVricz1ND4YemYhWoJU5eIQqcNCJ98+ifz/dOP7wBL+2lsmPxR6Y9TkdkG1wd1t0fLx
	32I1CjyN5l5whL3nPGg2V0FBBQ3arYblubi6OyKMaD0b6JibGP5s/xRSn+H3EP27gumY+4Yos9B
	agBVVoq3vXsIkQiQMBmJ8ZAuxVQttruAq427ECQKpZoOdh72ZQetEb5Jb4P7VXoRn/KZ0X5IS3A
	mJn3RmdHV7irbJyTQaELQY2ihBx3C5vL+98CWxM0G0tjd7ntIrpw4m9IWBg/xF/zAdWkpPbEfxw
	7hid5agcwnnbxTsB/pabp3QbsMVUxkav7VPIDUCPtrXNlpoltpbdSsguBcy8U9kUg02H/oJ6R4+
	wymsbvdaU6Rql8azk=
X-Google-Smtp-Source: AGHT+IFb9QSIj2pT5DqJHOGWLZeoKzR1HcGUwSCz8TPcIH2zmr4COlYJoCPacXO6TFFsZZUZ1uzZWw==
X-Received: by 2002:a05:600c:1c23:b0:46e:32a5:bd8d with SMTP id 5b1f17b1804b1-46fa9a892d7mr154828545e9.3.1760368529113;
        Mon, 13 Oct 2025 08:15:29 -0700 (PDT)
Received: from f4d4888f22f2.ant.amazon.com.com ([15.248.3.91])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fab36a773sm135545825e9.0.2025.10.13.08.15.28
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 13 Oct 2025 08:15:28 -0700 (PDT)
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
Subject: [PATCH v2 0/4] KVM ARM64 pre_fault_memory
Date: Mon, 13 Oct 2025 16:14:57 +0100
Message-ID: <20251013151502.6679-1-jackabt.amazon@gmail.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jack Thomson <jackabt@amazon.com>

This patch series adds ARM64 support for the KVM_PRE_FAULT_MEMORY
feature, which was previously only available on x86 [1]. This allows us
to reduce the number of stage-2 faults during execution. This is of
benefit in post-copy migration scenarios, particularly in memory
intensive applications, where we are experiencing high latencies due to
the stage-2 faults.

Patch Overview:

 - The first patch adds support for the KVM_PRE_FAULT_MEMORY ioctl
   on arm64.

 - The second patch fixes an issue with unaligned mmap allocations
   in the selftests.

 - The third patch updates the pre_fault_memory_test to support
   arm64.

 - The last patch extends the pre_fault_memory_test to cover
   different vm memory backings.

=== Changes Since v1 [2] ===

Addressing feedback from Oliver:

 - No pre-fault flag is passed to user_mem_abort() or gmem_abort() now
   aborts are synthesized.
 - Remove retry loop from kvm_arch_vcpu_pre_fault_memory()

[1]: https://lore.kernel.org/kvm/20240710174031.312055-1-pbonzini@redhat.com
[2]: https://lore.kernel.org/all/20250911134648.58945-1-jackabt.amazon@gmail.com

Jack Thomson (4):
  KVM: arm64: Add pre_fault_memory implementation
  KVM: selftests: Fix unaligned mmap allocations
  KVM: selftests: Enable pre_fault_memory_test for arm64
  KVM: selftests: Add option for different backing in pre-fault tests

 Documentation/virt/kvm/api.rst                |   3 +-
 arch/arm64/kvm/Kconfig                        |   1 +
 arch/arm64/kvm/arm.c                          |   1 +
 arch/arm64/kvm/mmu.c                          |  73 +++++++++++-
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 tools/testing/selftests/kvm/lib/kvm_util.c    |  12 +-
 .../selftests/kvm/pre_fault_memory_test.c     | 110 +++++++++++++-----
 7 files changed, 163 insertions(+), 38 deletions(-)


base-commit: 42188667be387867d2bf763d028654cbad046f7b
-- 
2.43.0

