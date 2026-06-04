Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED4822BE057
	for <kvmarm@lists.linux.dev>; Thu,  4 Jun 2026 15:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780585971; cv=none; b=L9Qg4kTMko1oNsVhkdXeEBcebFDRAIvZnsIs9Lq79gOc0KrkAHH6jaon7c5G3Hny430JvzlNrC1a7DfHSmHs4MLsVS6O5hiZpqbWUNYfCu5HH6ALVpNS2DSbsLJz9AGwcOUbnl/zFdA8HgZAuwjraXRFQF4nLMONrmRWwcZBrow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780585971; c=relaxed/simple;
	bh=zgD9ytodoO9t8/Zb8onF3WUr2JYEaY19jW9WQtAYMXo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UbjAvzlMzwnwNaWXRLzugimbCOXy0o8rtHuwBU+6e/Up2gD8VjprY9eibHVXOxY+8fvEpxRlgUrlJ5/K5iOrkVgmQxjo8rQFxUMmPB16XzKb4a5dkdU/tSQkQTg9Uqyq1e/hLXuSFuMqg2JEzf2Ne674rWdR6TR7awdqDXFQAYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HvQWOI7f; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HvQWOI7f"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2c0bb4a94b8so6791195ad.2
        for <kvmarm@lists.linux.dev>; Thu, 04 Jun 2026 08:12:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780585969; x=1781190769; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=SjCybsytUAOTYLqtwuovzu83bCVlxAZgYvPdM4tCjnY=;
        b=HvQWOI7fXWuwUYKnM0uQ03k9Pid4zKb/1dpAz1l10NC1R6h5lpSlel1DwbEPqbPIPz
         ZmU2Kghp2FT/KEmWP7oX/Nc7WOJV9s/1KmGcVWmDGaUEneo/NO4hHyn7lDyfCPbBKPTr
         q+6rY2x6+3WxVkgpNGmev2TYx5xiJ0WVaYN0y1mYJ6j34qw0p/0EylY1SPVBGK3rggmx
         rYLq6zhxXA2HcqRgTJ5Nsps1FNEWzJSrLuWpUzkhdz6qGAal2rVFj700mx07FFf8NHJ0
         sW2VlusDaMwH6u6eNM1SXC2SkuOF4uNd2iEzltjXL8N8xqhIS59Pp6P4ym8IQTySyWb3
         KmKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780585969; x=1781190769;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SjCybsytUAOTYLqtwuovzu83bCVlxAZgYvPdM4tCjnY=;
        b=Ssx1NqCh45C9iCRo5wpLiVJBZEHaTO+vNAxrgx7NuWfBfcWU0LAA322nu72R6AAdA1
         bQN04yvf+GeUgSGywGbquiNplRRsBrJnRYmqE2ZNTbNvqzZMj2wvTs9+8ZooAN7IF26N
         D8pmATbqcSo6MXqZZSJUdTmb9g/QJazWkHmxJ7mHh3rs6y+dY4VJv0st2g1poyK1Gbo5
         WfxfXwF5R+oUFEKq9+KoiCUeSf2USVlvErBrr0EaWSXxTaxdp44QxJU9v/jsQiTZiHsd
         ncCREz1Sx159YrkYCvlk9p/oIMtJz/wQmoisJ2vnvwV0RQI0KLqnIJx5lURJcU2Fgi6w
         w4qA==
X-Forwarded-Encrypted: i=1; AFNElJ9TQWZc/PCgYJ3U/jq+ms4Y4OfXZq2imC7teOAM7NiXfHSW0YlUIJvFpMzeX1tWHbDwjkTKNnw=@lists.linux.dev
X-Gm-Message-State: AOJu0YzRU2aetpM0RxbJd9+21DOhWLBDmsFnShIQr2WS9ONGuT4TgQih
	M+yef+vfi9CFmM7C/hem/FpgwApDTiAhwdnZvDFO27zZhSPhD3x4ZNQ7
X-Gm-Gg: Acq92OHpMsPwZsVWWq7p8I7BuOsMbpC2tw2PrfJcItoSVS37P0XX7R1vlluWWCbasOm
	zpMBOOqEI6U5zoTnu5aigyYL7gk6+iRZLAWRDqdkXU08rvBq+HxytrcOdtcE5bLgbBAQQJzyihW
	L6iwlnRWTaifBzRWfU/sbFOzrXIHXssdeOGa1ArICGfPhyhGwRM4ZJ9Q/lbIBzmXWGiGjPVDiJT
	5/axXA73YFDo4h7zG+JBErCuF0nQJgINhfQd2pRLDHJIoCE+UWo0b9KGTc2OU+3BswrlfbxKjrD
	IqnJIbgwQdoo1jdzXYWihgfgKuN6KWL3EBMO7CPeJi3gigLub1urlge5lF624VyWha4lDrx6F+S
	Gg1h6VNTBDPWcudApjRuWssTFC2RXKyTED5TI/kEJAcDfLGj5HPkUh+6Snitp3h9KUO5+K8DVb9
	0dkTvnL6ktZQ4gVtUKLwOVv7hsOY6emR8hL88JeUxyZ2zhHhbkjGGC0nQN
X-Received: by 2002:a17:903:1b28:b0:2c0:c625:4019 with SMTP id d9443c01a7336-2c163fadcdemr90406655ad.25.1780585968885;
        Thu, 04 Jun 2026 08:12:48 -0700 (PDT)
Received: from v4bel.. ([58.123.110.97])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c1664a67b0sm62705105ad.80.2026.06.04.08.12.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jun 2026 08:12:48 -0700 (PDT)
From: Hyunwoo Kim <imv4bel@gmail.com>
To: tabba@google.com,
	maz@kernel.org,
	oupton@kernel.org,
	joey.gouly@arm.com,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org
Cc: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	imv4bel@gmail.com
Subject: [PATCH v2 0/2] KVM: arm64: Sanitise host vCPU fields copied in flush_hyp_vcpu()
Date: Fri,  5 Jun 2026 00:12:01 +0900
Message-ID: <20260604151210.1304051-1-imv4bel@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

flush_hyp_vcpu() copies the host vCPU context and vGIC state into the
hyp's private vCPU on every run. This series sanitises two fields that
it currently copies verbatim (host -> EL2): __hyp_running_vcpu is
cleared in the guest context, and used_lrs is bounded by the number of
implemented list registers.

v1 -> v2: split into two patches, one per field, per review.

Hyunwoo Kim (2):
  KVM: arm64: Clear __hyp_running_vcpu when flushing the pKVM hyp vCPU
  KVM: arm64: Bound used_lrs when flushing the pKVM hyp vCPU

 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

-- 
2.43.0

