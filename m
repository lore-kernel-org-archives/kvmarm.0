Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBA6F393402
	for <kvmarm@lists.linux.dev>; Tue, 13 Jan 2026 15:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768318056; cv=none; b=FF+m2Ows2EOnEv8pqkpXd2UgSRF4S9py1r/PnuY+VYY+/wjSRYIUb8t9U/SayVpvu86t7n/7GhDXNsy/xGfnQI1kE0iiHtDdEF5FyAuRw37/74rhDID7CZioi8Y9V9c2UsSlia8CcK/QXwbrPlRI3rRg5m9w2t2931qyjcMh2mo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768318056; c=relaxed/simple;
	bh=6hD5bFYTiFw+u5WlC3Ja4RO6p0L5y/V0JPy40yb4pNA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=chDpf0gZQJiCUMlCiOyQeEpN0FWMkdyDVoOxMTQotQ9ldyjw+VqkJplTPAZ82LBTMqvFGlQMBzoC+Ezkbb9wInGtaQNelCVr+wQ1mgCfKart6arlSvsugEgPVgOajPXHUsDEsIL3oCjuNycBEnpTpW6oKKNurXDV3hFHs0z4Cck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Xo8DfHSM; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Xo8DfHSM"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-477ba2c1ca2so84359725e9.2
        for <kvmarm@lists.linux.dev>; Tue, 13 Jan 2026 07:27:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768318051; x=1768922851; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=VbTTWN64JGBAoQywDuAxXApY2+pw8bYawwCoCRHZJYI=;
        b=Xo8DfHSMRiaACIum1lPxFTlGT2tNPuUlGDGJIGKydjquA5P626YX16fytyFbE+N1zK
         kaHG9sOFsMZicVfbnp1gPjWjbOGcw3dyJN9L2Rjgi6rjbd1jT0mfQo2lOUpIoLdu/fM+
         9FvH67KPpGEwKo/sN1rms8u4V3JF+F80xZQ7bLky87dcEmMvBew+pGaXaeSnBxnga1fG
         pSllX01WliMc/gPXdaAVa19EPLrwSmbxJ/uZT5g7srSJ2qIboBSlaKrvzlALGvswn0bO
         EJMNd0XDrtBABuBhwFxKXSGPkChhNlaUaE0CAkbfGw+ywQrJv75A4RhO0yMC6fprXIBw
         7Bjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768318051; x=1768922851;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VbTTWN64JGBAoQywDuAxXApY2+pw8bYawwCoCRHZJYI=;
        b=R2gs+V5N/eZ+COmSgP1WfVGd8kf+w4mzTtRCwkj7gjlSTyxLntTpzA7eDX8RTDqIzI
         zTBIXLszIqag2XVXCHttqrKwBiE/eawWIF/gaxYnuMJtCGw2xF1Ye/eg6D0h83K4ZusY
         WGy4K0J4JlD9+o23HhE5Kw08mTlz6aHSZCBVX3XkTzPz9yi2mu60TRBHLKr24i2Eq9/J
         +rPRmyuq2ApjvZQnHKNESopzLpXvIqVzrMlyt2EqnmQ4zegtmGd7g603N3GjUyN7KUGb
         TFfXJZRC4cLTUejhiILkLw6D+p5Kep8WJJ4DPJxRhVtSy/HQxzBUY4R8m9+SblP4pbcf
         ADrA==
X-Forwarded-Encrypted: i=1; AJvYcCW3M5YWTYkr/aDsZEdjeXBra2OYXol3tNLDk0kBw+8IRkcdM1gVLK6a05Rh+EAfD8MDCjxX1s4=@lists.linux.dev
X-Gm-Message-State: AOJu0YzPnx8FLvaIUGY9ta7YljZWOjRTfwxSNQD/a4ulY58t2ordAHT9
	Q2zHg3qHmdGOridZAr3Er4dl4tC2EZp7YUSTXKjWNiK0rz5Dn/Qwa2TA
X-Gm-Gg: AY/fxX7ansOtYYcpVvRZVjNssd65LPVKNONt4+Kzn4m0Fves4i7q5V5voRVbCpu7uBX
	g7fB+2AX6KozIUUH+fETXUCTLLSTbqSqs0AYAPIqMVaRjXJ+4VivgG0P5F3XykDgLmhTm25rlfQ
	wdRuy+NVS0GC2OOigl1Q/qxQtp6yEkh1r4TpCtuoDmswUvUHNbKlx85wbCMTB7tehsTTpbsvfRh
	W8egpaFMJhkM332747NGNtxWAnxNznJIGzp1ljplnNfAFB2UEgBnMeoY1GAgXSqam/O0djHHdoM
	eclkVODk97xz4Z/P4l2/yPGCfsM9S44RQn+/OECp98DglLTtbz/16Aw9iZN6z7H8ngDlyPlq3fI
	XKvHOyfTno1D/Gmktt2cehEWRkpTX9H79ye5Xe//qPoecxdh3NUZq25S92K2aqGqnBNYKk2sQb8
	1Gp5A0jcAtqOu710UgqxRqVZPjaL7M06elMHYd1Z5isK0X61BTPhvNQMY=
X-Google-Smtp-Source: AGHT+IGxO1vUemwqVC6JKUpSwSlNgSOMLT+M80yAIztyVdNJEhHixQ6jTf/ZgIZ7VfPNTxO2jx4HyQ==
X-Received: by 2002:a05:600c:6096:b0:47a:935f:61a0 with SMTP id 5b1f17b1804b1-47d849ba979mr245697915e9.0.1768318051058;
        Tue, 13 Jan 2026 07:27:31 -0800 (PST)
Received: from f4d4888f22f2.ant.amazon.com.com ([15.248.2.27])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47d7f68f4ddsm421025325e9.2.2026.01.13.07.27.29
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 13 Jan 2026 07:27:30 -0800 (PST)
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
	xmarcalx@amazon.co.uk,
	kalyazin@amazon.co.uk,
	jackabt@amazon.com
Subject: [PATCH v4 0/3] KVM ARM64 pre_fault_memory
Date: Tue, 13 Jan 2026 15:26:39 +0000
Message-ID: <20260113152643.18858-1-jackabt.amazon@gmail.com>
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

 - The second patch updates the pre_fault_memory_test to support
   arm64.

 - The last patch extends the pre_fault_memory_test to cover
   different vm memory backings.


With regards to the additional parameter to `user_mem_abort`, noted in
the v3 review, would you like this to be fixed in this series or would
a follow-up series be ok? I also found a series from Sean which looks
to address this [2].

=== Changes Since v3 [3] ===

 - Updated to now return -EOPNOTSUPP for pKVM. Previously this was not 
   checked.
 - When running a nested guest, properly resolve the L2 IPA to L1 IPA 
   before pre faulting.
 - Refactoring, page_size is now unsigned and ordered definitions at 
   top of pre_fault function.

Thanks Marc for your review

=== Changes Since v2 [4] ===

 - Update fault info synthesize value. Thanks Suzuki
 - Remove change to selftests for unaligned mmap allocations. Thanks
   Sean

[1]: https://lore.kernel.org/kvm/20240710174031.312055-1-pbonzini@redhat.com
[2]: https://lore.kernel.org/linux-arm-kernel/20250821210042.3451147-1-seanjc@google.com/
[3]: https://lore.kernel.org/linux-arm-kernel/20251119154910.97716-1-jackabt.amazon@gmail.com
[4]: https://lore.kernel.org/linux-arm-kernel/20251013151502.6679-1-jackabt.amazon@gmail.com

Jack Thomson (3):
  KVM: arm64: Add pre_fault_memory implementation
  KVM: selftests: Enable pre_fault_memory_test for arm64
  KVM: selftests: Add option for different backing in pre-fault tests

 Documentation/virt/kvm/api.rst                |   3 +-
 arch/arm64/kvm/Kconfig                        |   1 +
 arch/arm64/kvm/arm.c                          |   1 +
 arch/arm64/kvm/mmu.c                          |  79 +++++++++++-
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../selftests/kvm/pre_fault_memory_test.c     | 115 ++++++++++++++----
 6 files changed, 169 insertions(+), 31 deletions(-)


base-commit: 3611ca7c12b740e250d83f8bbe3554b740c503b0
-- 
2.43.0

