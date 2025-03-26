Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 638B41B4139
	for <kvmarm@lists.linux.dev>; Wed, 26 Mar 2025 11:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742989148; cv=none; b=mW92a4fIau1wFMX0+nXif1DHuIS945o72IW5ayaz+awRuEy5nrzFAhhbkd718CRekgyII2IiCPjiPhlWCkLAu6j4VLH2ZtJzTPpwrZ5e/I8LBYTWNxfR2jjf7ZtgGW2Tulo6qwP5Scz5xKZgB6S4JnFxmf39dCyEeAQYh1xzo+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742989148; c=relaxed/simple;
	bh=IuSEcVY+XQgcWWiKyPKuUnqqYJm+G9BasCoqCLzldog=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=KWtWqZgfdDCvMTMEhqg3pBRX8OP8BS7qNgbeWoCkwK1TbCkj80mbaeFjMJskqzVLcX9hisZ8cMCU1h61vP1/W6QtOtNq0SN4qWoMrivd6NK/SE2yTxAV/nD9DstkdTu4/RD+3zKJan8xwzUWSQlOWX5Zb/y0tVWDL4SUZkFkZII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4JTZ9qQj; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4JTZ9qQj"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-43ab5baf62cso45329645e9.0
        for <kvmarm@lists.linux.dev>; Wed, 26 Mar 2025 04:39:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1742989145; x=1743593945; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=fAUrsz9OdOg3wQLEmYa5D4cgvz4ST0mmGNxgNjOcyeU=;
        b=4JTZ9qQjnb5827zAihTksFiazTxZm1lA2CI5RWSPedNS7v9zBo6hZ/9udO0Sk3Sfv7
         Gvc2QUs033X9Vf3sx6krbOLFmwwX53yjewsTqPrHGKXImL9wlV7zGn0hw9qke9UoQFhp
         EhdM6bzAobveVykFD496Y1UeQIDXMK7C3JUT6qW3WprC0PMj7Z9UoYC8E/cCtlaFicWl
         OhLbzvBB4q9yxeOaqHgpaJhfLtg794GdCEhe53xnOyG4lZaID8YlY4XPiU8zh9PbsZzU
         h0WSBVywdB1zDu2b9474hBKViYys1dchedHxmRPqvJ7w9qyEQYC69OtzMSsowLvWheGG
         pFeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742989145; x=1743593945;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fAUrsz9OdOg3wQLEmYa5D4cgvz4ST0mmGNxgNjOcyeU=;
        b=Epelskkwkf1W69XDRcoEkrdCHfBwypXJfmQJXzeeiELN5q1cGTj54Y1smxBLUj/395
         25D/ouWiJkpdvMxARHmMBjOKYMpSwwQ4bOLHe7ph+aahJ7rxm9v94kRE6E7AYQN3Qv8v
         yd/KKj0dFNBnkhIBfyNl1Q2DbbHjHV0WMcwGbMcNHSf3L54+n1MpbxCBpy1hwsMkeWfD
         Pwia8h9NArUa6s8/qbcQYUMW7FYpgnm5uoyvhcU2+ga6/WFYmWL0aLW3LaHWHUmxBLvQ
         1s9kO8+KbkaG+xOZ20KXHMdAUMUZEDT0qVkUC6gzO52OfgDCYpkI+tHJmwc6hIjRfZV/
         EvXg==
X-Gm-Message-State: AOJu0Yxq7DKdza+Hk9xDJzlckKxPcYRdA70pOA3ZjtKBcGmHskVdVWQ+
	W+7B0Nj8bB1wLnpm6yS4a6u7T4qBBr1S7mZXyuVZSX+2YZyjkHjfBHy9cGzjLpsQTVqJKlJR0PV
	n4Z2MWJvVn3vlUaoF7WuXxYSniQ==
X-Google-Smtp-Source: AGHT+IGHwZHepscP8ejJ/xKjHvWMmfkRYj/uDkAFERn0R3gk+2OvGbhbfX9XWEWX38kk7ftW0gGcZ4p7ZxAAjcKTqDs=
X-Received: from wmpz15.prod.google.com ([2002:a05:600c:a0f:b0:43c:ef1f:48d8])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:5021:b0:43c:ea1a:720c with SMTP id 5b1f17b1804b1-43d509f6307mr221896365e9.18.1742989144752;
 Wed, 26 Mar 2025 04:39:04 -0700 (PDT)
Date: Wed, 26 Mar 2025 11:38:58 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.49.0.395.g12beb8f557-goog
Message-ID: <20250326113901.3308804-1-sebastianene@google.com>
Subject: [PATCH v4 0/3] KVM: arm64: Separate the hyp FF-A buffers init from
 the host
From: Sebastian Ene <sebastianene@google.com>
To: catalin.marinas@arm.com, joey.gouly@arm.com, maz@kernel.org, 
	oliver.upton@linux.dev, sebastianene@google.com, snehalreddy@google.com, 
	sudeep.holla@arm.com, suzuki.poulose@arm.com, vdonnefort@google.com, 
	will@kernel.org, yuzenghui@huawei.com, qperret@google.com
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kernel-team@android.com
Content-Type: text/plain; charset="UTF-8"

Hello,

This moves the initialization of the hypervisor FF-A buffers
away from the host FF-A map calling path. If the hypervisor
cannot map the buffers with Trustzone, it rejects any FF-A call
when it runs under protected mode. 
Other than that it moves the definitions of the ffa_to_linux_err
map from the arm_ffa driver to the ffa header so that the hyp code
can make use of it.

*** Changelog ***

v3 -> this version:

- moved the definition of PARTITION_INFO_GET_RETURN_COUNT_ONLY from
  the driver code to the arm_ffa header and dropped the definition
  from the last patch. 

v2 -> v3:

- dropped the "Map the hypervisor FF-A buffers on ffa init" patch
- added ack & reviewed-by tags
- don't release the ownership of the RX buffer if the flag from
 FFA_GET_PARTITION is (1)

v1 -> v2:

Split the patch that maps the ff-a buffers of ffa init and introduce
"Move the ffa_to_linux definition to the ffa header".

Thanks,

Sebastian Ene (3):
  KVM: arm64: Use the static initializer for the version lock
  firmware: arm_ffa: Move the ffa_to_linux definition to the ffa header
  KVM: arm64: Release the ownership of the hyp rx buffer to Trustzone

 arch/arm64/kvm/hyp/nvhe/ffa.c     | 12 +++++++-----
 drivers/firmware/arm_ffa/driver.c | 26 --------------------------
 include/linux/arm_ffa.h           | 27 +++++++++++++++++++++++++++
 3 files changed, 34 insertions(+), 31 deletions(-)

-- 
2.49.0.395.g12beb8f557-goog

