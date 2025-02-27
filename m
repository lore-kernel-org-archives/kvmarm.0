Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CDE417D355
	for <kvmarm@lists.linux.dev>; Thu, 27 Feb 2025 18:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740680277; cv=none; b=RVLHGmnkfqcEnWkM6eLE+EqQovMIquObY9RgsKHVOxVF5okgxauBbCqEMOs9mCphhx60C0rt4Q2xiiy4kFIc4nFnv3VaQFZkYPgXJM3eup7AgwigDZrcjMRmaaRyrM6k6jQFb5Co/ibdBk41YobJqa249vyQ2xfUrcC2SIrWbko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740680277; c=relaxed/simple;
	bh=OOQnd0cgPVqA4hicU0YVfjL7ytbVCqNXzH9fXVa8jDA=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=D/DPQjeLuPXoEz5kmM4gBj9jeH///S6I6bTd07p6qBS+Vs6TWwheQKFeD5k7CdSQaJ9G9vp9uU1tfThXClKcl8muHKGrIdEcxslfZX5e2ZaZTs+bHKry5sVQIbjXDWftoYEaBAI08fWJVw+p1j2yYjGoytXJODbg+GFVa4sgYTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IlWAzqtc; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IlWAzqtc"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-390de58dc09so854428f8f.0
        for <kvmarm@lists.linux.dev>; Thu, 27 Feb 2025 10:17:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740680274; x=1741285074; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=WML+/ObPWkSPRoaiWIHFm8yG2IrgtdFB4ZBzBau4x8I=;
        b=IlWAzqtcA6xTWKyfwTSAVPdjTyyjxY7Kt5hkMv9hbAGF7gCKY7aMsG/SPqMdSw2Gjq
         3TqnArePC6jgPvQ016/1bhHNJxS02mcrtExdDwPA7l17ZUDN18Ay2tcSC9yBX7Ughc/P
         YR6yB+mw40ek+psSpoQRBCsfjzfIARicn6Tqv2wTLaMJLOLI0ctY97fJHWX5ZkOg6jpC
         1mZkbirfJgWThfyFLbHux6a5pBUheyReJYJFqYiFOUkcISfK5uxIUFBMHO0FXO78vxxW
         xaOrV0FwOu42lxvvst8gRFZPNg+HglzDq7LbK5HEW3MOSOM/HNp63ckEg5AwcS6NexhG
         8y6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740680274; x=1741285074;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WML+/ObPWkSPRoaiWIHFm8yG2IrgtdFB4ZBzBau4x8I=;
        b=U47Dx8J9MF54sS6xuCpSWhTQRFeF9LbKA8/47RAdHDz3caUmM2ryZBc1riPrRpUKlf
         jgjptpDNoIukBYzGeCItihGazmp6XTKcZ10ZOeNz6hjJJI+0nrjarH+6GFeV5nKLPl/H
         YkDxI15yNUVXMnXMng+MQyHNAr7h9OzS4dKJKGTZpleeX5FSJy/6o4B2EzHDSdr0HHrZ
         6k3XGOOXS/LsbOZ1FsFKKC9PF6I0kXLuA+LWWOhYtvWiF3ED+6uX9MYqjtLXNbwGIcjV
         soDkZmqwX3esn+y5rSGZ6pmEzWGK6wOISlcr2fIRO4Sw3TafdM3dyr75edFTysV4bB1L
         kfcA==
X-Gm-Message-State: AOJu0YyDiKLc/3QpSRGDdjnjXbhxpUFFbUisHMBbpyq9ob2X3j69ooNX
	mT3NF0gD9BE2wof7toollq8007DVvwUOE9YZ8Wt5NcZ/B/7nyu9BU1u9Vs4Yd5r5jQ9u1v8n+S/
	wyP0kGhax0yZUucyMggVqS/7Wmw==
X-Google-Smtp-Source: AGHT+IFFgy3uOiYkfgXSKvEHx/UgS5vFK40ACXZHcvac3+mJfnimRkLhC2vM9vssr/5l88QZLrGZkaFEBXqbcHd+ZhA=
X-Received: from wrbfa8.prod.google.com ([2002:a05:6000:2588:b0:390:e9d7:900b])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:1a8f:b0:38d:d274:4533 with SMTP id ffacd0b85a97d-390eca41791mr151865f8f.55.1740680274621;
 Thu, 27 Feb 2025 10:17:54 -0800 (PST)
Date: Thu, 27 Feb 2025 18:17:45 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250227181750.3606372-1-sebastianene@google.com>
Subject: [PATCH v2 0/4] KVM: arm64: Separate the hyp FF-A buffers init from
 the host
From: Sebastian Ene <sebastianene@google.com>
To: catalin.marinas@arm.com, joey.gouly@arm.com, maz@kernel.org, 
	oliver.upton@linux.dev, sebastianene@google.com, snehalreddy@google.com, 
	sudeep.holla@arm.com, suzuki.poulose@arm.com, vdonnefort@google.com, 
	will@kernel.org, yuzenghui@huawei.com
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

v1 -> this version:

Split the patch that maps the ff-a buffers of ffa init and introduce
"Move the ffa_to_linux definition to the ffa header".

Thanks,

Sebastian Ene (4):
  KVM: arm64: Use the static initializer for the vesion lock
  KVM: arm64: Move the ffa_to_linux definition to the ffa header
  KVM: arm64: Map the hypervisor FF-A buffers on ffa init
  KVM: arm64: Release the ownership of the hyp rx buffer to Trustzone

 arch/arm64/kvm/hyp/nvhe/ffa.c     | 56 +++++++++++++------------------
 drivers/firmware/arm_ffa/driver.c | 24 -------------
 include/linux/arm_ffa.h           | 24 +++++++++++++
 3 files changed, 47 insertions(+), 57 deletions(-)

-- 
2.48.1.711.g2feabab25a-goog

