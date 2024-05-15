Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C57175815
	for <kvmarm@lists.linux.dev>; Wed, 15 May 2024 17:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715793792; cv=none; b=rQwC6kF2EvsowqvJEwtKCrOkcFmX0cEjGRVkuYsnYyWWx7gPPtHANXjqBbnGt7KFukfAsOccnXSU7RfAoocpBHeorDDvg4wIGVZIzkseQ8LvggohkdrSPCSaae6OHPB1tk13M0eMS6sd3Zqlq36JKNzhiRCxbpQ9FV6LTa0Y48Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715793792; c=relaxed/simple;
	bh=3Hey8yGfFDeNGoMd+KV/s1c9VtxcoIDls3Ojr/oIhm4=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=Nw7qhg5F5YzbMIsIiGQLbub6J55UWwKJjUT8gWSBrGx0wlhUsIzLd8hV5Gi51pwS9zl3pSh8XKmxdzwm27HwB7z+ZpRuq3FLFCTOcnzssYKmY0jMGDdnedTAAewMjJ1X4tKgZqtvqjW/qbM7c4iBOPqMnuzVvtxjJgxKu1KieHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GQpiO1Xg; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GQpiO1Xg"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-420151eb455so16431235e9.1
        for <kvmarm@lists.linux.dev>; Wed, 15 May 2024 10:23:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715793788; x=1716398588; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=9RvZSZw4jxBqtRsNUm11hD2fyY6WsB4is9eFDyT77bE=;
        b=GQpiO1XgoZfWdLLM+CCuqtggVyk44u4cJFYs3+WmYYXmDvq5ea/vv1x769kWa+eqjB
         IZm+mypX/33pidisNDGW4vJRGYFS54PH/6ZL7GutQOLV5mxFgs+fmoYyIFY/Uz/bZpsv
         HeuSZLJAnzTslPrEBsU5cP0KGiaK9maXCUIzYIzQypuSWcj/sF1Ez9yXPHdfu4x2GqEh
         Znn8JoSeWch4WVM0pCl0qX5u2PHyTSSCayYUqsnYPBQssrjdLEfyD6UjWxRLui5byxbv
         j+ZW5YVZ0LjnhayaRp1R0gENaBoOEzHpuXzmqEZxpjjJFOVOrRevKhSNNTLwpZfKfsK/
         +QJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715793788; x=1716398588;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9RvZSZw4jxBqtRsNUm11hD2fyY6WsB4is9eFDyT77bE=;
        b=Z3ze1tACNXK9dNZelogoEukOm5hA6zRjT2njQDIy66oZkFAndZ1AhhUZR3FDuiWqrQ
         6zo2WP9s5/kQ6MfjN9q9oB5jxHz4b4NqMQ4DupAcQgcHRslq5f9o+q7aP1Y2wkBrH5mS
         h8lLkP13NaHO4bGhGq4eij60ncUKbBPmuR6Qlw3zQTnK8pRARlMLXJtZ0Ha+lDc2K16Z
         bZNSX+oVItB81hX9lPmo9tTN/VPIGJ5sflNGc4X7Q8viIu5ObnLghU7PtnG0UAP9z94A
         uDi4fdeGOCpJCDe7Zn0sUt0gBdrEN6FBRQiFLO71F5cBimmdlRveWiDTXuTRe/Gbryek
         w2xg==
X-Gm-Message-State: AOJu0YyBl4C2Bps/pX6xBgkHP7sRiBeW54WUmhQLNInbqZ5Kwv3y4lQZ
	6pWe3C1U7d0s0fdpOl2O6aij7PQ0e2WebEK0TbJDfga+98tamNnvw9lKSQ/oPT50/+W8bi6u1iE
	gc7y67u75oOaZlsWOFbcE4gqryw==
X-Google-Smtp-Source: AGHT+IHARczV2e6GphBvu/GRT1dSaZeTKSmihgV/GKa3xOn2mh1vlMNsjz+sFoMVlqfAVVR0jb3CJk0/60m2L6gideM=
X-Received: from sebkvm.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:cd5])
 (user=sebastianene job=sendgmr) by 2002:a05:600c:3b86:b0:41f:9ffd:fd33 with
 SMTP id 5b1f17b1804b1-41fea52ef1fmr737175e9.0.1715793787741; Wed, 15 May 2024
 10:23:07 -0700 (PDT)
Date: Wed, 15 May 2024 17:22:54 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.45.0.rc1.225.g2a3ae87e7f-goog
Message-ID: <20240515172258.1680881-1-sebastianene@google.com>
Subject: [PATCH v2 0/4] KVM: arm64: pKVM host proxy FF-A fixes
From: Sebastian Ene <sebastianene@google.com>
To: catalin.marinas@arm.com, james.morse@arm.com, jean-philippe@linaro.org, 
	maz@kernel.org, oliver.upton@linux.dev, qperret@google.com, 
	qwandor@google.com, sudeep.holla@arm.com, suzuki.poulose@arm.com, 
	tabba@google.com, will@kernel.org, yuzenghui@huawei.com, 
	lpieralisi@kernel.org
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kernel-team@android.com, 
	Sebastian Ene <sebastianene@google.com>
Content-Type: text/plain; charset="UTF-8"

Hello,


This series contains some small fixes for the host pKVM proxy code. I included
some of the patches that I already sent on the list as part of this series
to make it easier to keep track of them.

I verified the functionality with OPTEE as a TEE-OS.

Changelog:
 
v1 -> v2:

* applied the feedback received from Will on the FFA_VERSION patch:
  The spec requires that no other calls to be issued prior to the FFA
  version negotiation and the current change reflects this. After the
  version negotiation phase is complete with Trustzone we will just
  return the hypervisor version.

* corrected some mistakes on the FFA_PARTITION_INFO_GET patch:
  - don't trim the number of bytes copied from the hypervisor buffer
  - introduce FFA_1_0_PARTITON_INFO_SZ definition
  - simplify the logic when the input flag is specified 

* collected the Ack from Will and embbeded it in the commit - Thanks Will ! 

v1:

* previously posted FFA_PARTITION_INFO_GET patch here:
https://lore.kernel.org/kvmarm/20240411133249.2134696-1-sebastianene@google.com/
 -> minor changes from the previous version, look for the current
    ffa_version in the host_buffer structure

* previously posted "Fix the identification range for the FF-A smcs" here:
https://lore.kernel.org/kvmarm/20240322124303.309423-1-sebastianene@google.com/

Thank you,
Sebastian

Sebastian Ene (4):
  KVM: arm64: Trap FFA_VERSION host call in pKVM
  KVM: arm64: Add support for FFA_PARTITION_INFO_GET
  KVM: arm64: Fix the identification range for the FF-A smcs
  KVM: arm64: Use FF-A 1.1 with pKVM

 arch/arm64/kvm/hyp/include/nvhe/ffa.h |   2 +-
 arch/arm64/kvm/hyp/nvhe/ffa.c         | 183 +++++++++++++++++++++-----
 include/linux/arm_ffa.h               |   3 +
 3 files changed, 154 insertions(+), 34 deletions(-)

-- 
2.45.0.rc1.225.g2a3ae87e7f-goog

