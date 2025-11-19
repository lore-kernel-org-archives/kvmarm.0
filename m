Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB70436C0AB
	for <kvmarm@lists.linux.dev>; Wed, 19 Nov 2025 15:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763567367; cv=none; b=jCinzHScvY/uWkD2p3jxfl6FsB3FGS/ybuHR3pyO4ThHLM1mV+7tXZCKlfNmPwPjyvIcVXmRal49qJ5guhVsBDojd4gg0SOhIZanmGEVdTztlNvp7sqc/v5gYTLX1Tb+X7ShwLxkWsd1NR4IUWkuxbLFGpzUMfWxP8xMM0dpyPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763567367; c=relaxed/simple;
	bh=e9o1/GNMLjcy+Zk5rqn6PgwLxkXMSjNL5BWwJUqnu/4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Hs3+R4KBeB8y8NsUC1NhJGHodCKknLy1rcM45IkcmuwFd+6o9Go2NPf89q5INFfK5RVQKXFO/yeb5OtY+e6Dzee+ojQookF+VA3aBp9kwVWkELaPj0YgMXnbcTPuG0Vrb8X8psPj8AplfYV6DP6zrg3gpYcbMByQwAAS6kO42S8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KB/9xE+l; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KB/9xE+l"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-42bb288c17bso2713376f8f.2
        for <kvmarm@lists.linux.dev>; Wed, 19 Nov 2025 07:49:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763567364; x=1764172164; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=zsMgANA5eM7ZKAX6n6+aWoRlKM8M0oaGArWvq51zEek=;
        b=KB/9xE+lpMMDFl3ZwMzfPuf8WJx1T30M31lEB5kcPX3ffdw9iqOxeZbLRVlSpq6tVA
         ZH2tQDJMp4PTgZ5+Ws/LC8pZNUEgqXqL7UJGyjwqRE89tkOIQ3jVbTjMPwy5AingsjpM
         jrSxh9pyXHdhOybK7RGY0iAW6XgazG9bC+CKq2HzURQwbowi20YZuAO2YJULhX0Oo27H
         VpqBpLJUmH0OP6iBLCoNORAcHoxaXvF2mApcXUBY1n9P+Colhw4HRwy+iZIvd54lY3PR
         /nwPW0ENYhvC7K6+5GRf6IAQl4QzjXkdUl2moH3OG8ZvSNJFl7XFYcBDUh5jo7R7uyAj
         hfLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763567364; x=1764172164;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zsMgANA5eM7ZKAX6n6+aWoRlKM8M0oaGArWvq51zEek=;
        b=rAfCkmVsL+ptPyj9wi04GtlVsjrdS/GFNp5qsAckoleJPgD1dpjJoWHUOUjTBg+2ba
         KGR/0gkMYQt/FiQnzrE7k2j0egDhhe0D/mrfJakh47LVm8Ac4URyUQh7M6dket/RPjoQ
         ngoVywmH3lgulp1lmUS49jLP9dSFQmjy0ZVeMrWal5Bd9WpFSi4TpHZvU5+SXNMtTWKq
         zEiURZw89N7hHm4B/NboxhqJ0LfT/3Ir7aVQdvvgZT1JOE2PHksIwlFFi6ZQwVeeRYi1
         QXjiuaZ2EVecHGH9YwZ93/Nk7kAslxRIh2nLyTSPKUiooNxZcZWOU4keprF5dbscrkej
         f4Pg==
X-Forwarded-Encrypted: i=1; AJvYcCXxKq5IeY9+GTWXc13IVjb7YbNIkqZrV9F0q+kZ3yUFyUq86MRhRy1hKr4yJrjD/jjtXFgIUWU=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw33VtfI2+39s2lq1+XRTPomXw13DBxryvatqcpZAw8Bk39RHoo
	1DlJ9L1T5sQcVtWoTEPss+j77bWAG6BiYA1Wftz5BKZwm2Yjyg0hO3Io
X-Gm-Gg: ASbGncsj3/FD9SlrkSpxj4yGrC1PL+MxeO+fLHRvqYjP5adu209DCkPbdgoQ9/Ree7F
	nAFDGuPMd6Iv6jtuD/rLjapfzfRdKwS9/xokZcsGaOcuJOVvZ51ZC7mHlQBCn6IQdt+FdMrT9ED
	8HSTXxcDeNE4iTW5vb8mg007F0DivTQQVG2Au7BTRHindiF29hvgeRt7YwQhsChvcGP7FW75Jad
	L38oTw6C+wWWbBLMvRC3EAw7OdUJqxzpYbWGWdvOVd2ohXDBOg2931Z4w5824rBvZvDZEE6LwS3
	rlEi50L5Dkq+JRj0hMwmTpp49cjMXqysDbg8fK6VVyJVjhwGeNn4Np4IkzGi52jetbR3fF8QASP
	e5n17YU3/7vlAyxdGyt5aIbtJyeFI73kTBy6LomI7UYyNQPdyZDTIYvgaSPatnQ1Azp8RM3gjPT
	D8YykfP34TRXjiHn1FYc2cI/NmsUlXX3kYUa/A+2JISyJ4fgInwzPAMB16Z+Q0J5Zrig==
X-Google-Smtp-Source: AGHT+IHKBCKSyXwqmqDibyNSehgzgh3KJ1v3HqV1svmFXRruujCX1mFQdmNmlH2lr9fy9Bcfr5S55w==
X-Received: by 2002:a05:6000:4024:b0:42b:2dd5:42be with SMTP id ffacd0b85a97d-42b593234e0mr18915716f8f.8.1763567364171;
        Wed, 19 Nov 2025 07:49:24 -0800 (PST)
Received: from f4d4888f22f2.ant.amazon.com.com ([15.248.3.91])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42c9628ebacsm25969755f8f.30.2025.11.19.07.49.23
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 19 Nov 2025 07:49:23 -0800 (PST)
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
Subject: [PATCH v3 0/3] KVM ARM64 pre_fault_memory
Date: Wed, 19 Nov 2025 15:49:07 +0000
Message-ID: <20251119154910.97716-1-jackabt.amazon@gmail.com>
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

=== Changes Since v2 [2] ===

 - Update fault info synthesize value. Thanks Suzuki
 - Remove change to selftests for unaligned mmap allocations. Thanks
   Sean

[1]: https://lore.kernel.org/kvm/20240710174031.312055-1-pbonzini@redhat.com
[2]: https://lore.kernel.org/linux-arm-kernel/20251013151502.6679-1-jackabt.amazon@gmail.com

Jack Thomson (3):
  KVM: arm64: Add pre_fault_memory implementation
  KVM: selftests: Enable pre_fault_memory_test for arm64
  KVM: selftests: Add option for different backing in pre-fault tests

 Documentation/virt/kvm/api.rst                |   3 +-
 arch/arm64/kvm/Kconfig                        |   1 +
 arch/arm64/kvm/arm.c                          |   1 +
 arch/arm64/kvm/mmu.c                          |  73 +++++++++++-
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../selftests/kvm/pre_fault_memory_test.c     | 110 ++++++++++++++----
 6 files changed, 159 insertions(+), 30 deletions(-)


base-commit: 8a4821412cf2c1429fffa07c012dd150f2edf78c
-- 
2.43.0

