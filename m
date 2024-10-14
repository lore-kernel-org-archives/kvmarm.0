Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1E911BE223
	for <kvmarm@lists.linux.dev>; Mon, 14 Oct 2024 16:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728925094; cv=none; b=I7GSPMpnwaF4Dsm8BK42UpCN1os9W0EwxmFD1pYzelcyzI43VVTOZP/pKkQJX7ZMCx+IBmu/uJ8ffdKuG/wu31/UgaVCRQ7RiSM1FCE1D91DpxVUqCN527wS0EOA4jwZOUW2dyJLkHNBJgHzuaKKgiP2/Niro1bLTT6TG7v9iP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728925094; c=relaxed/simple;
	bh=1Q2PeUoa1O/DwnlQVHcLAAM0O8Lf8VtTfwD1OXvK3Rc=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=qYF747zvgwRaQz087HzpQSh97kZYwleZdg/ruoXk6inZh6myGiGA4jN6Z30jUDTiJoYytJmoaT3F5DZXv2Cwe03PZeNzycNVbhTSrJEZxLE50BlEtknTCfIyq5ioK+u1ITozlJX7r3MzWZyPzR2oUGo6SCtS4VsiTRVQ+UXwf60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=njNa2Q6a; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="njNa2Q6a"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-43058dce286so25548055e9.2
        for <kvmarm@lists.linux.dev>; Mon, 14 Oct 2024 09:58:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728925091; x=1729529891; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=yzwYZlUBX9TVNpq6WnyVAwkYj8mrCX+DY3LNvXT2TTY=;
        b=njNa2Q6a7oDXPqfhO4WT8aSoOxxaZW7KW1KCtfTOnVcr2cB4b7mOdiojijAQI0AUFh
         loQGQgJMyK9OaCkq0JCrM+z6vwVma0QQVFUitkbSJOnvp+DMXa0SawmEtQldQjUE4wzx
         oONJ/niJJLNf1UoRxM3mvgP+ulbva5vC5TSTKePb0NAsnK4kI5CYqWv7I7TsoZeyUgf/
         6FhyrjQICPlkhvELcLdC54MVKY3urJsT/q9iiTyQ36PktIZ6SeQgbR9LXd6ZiCgaU5qr
         1IK3KpeiYuRRP2McUPJnV8OHLlqMQYvhcRTI5FsLaWMP2vaaczPewXan4WYLpF4LgAhU
         7mDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728925091; x=1729529891;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yzwYZlUBX9TVNpq6WnyVAwkYj8mrCX+DY3LNvXT2TTY=;
        b=QdE7zxzqn/BuE7FJBoy1qgIcn0r899CGo07vkw+BT95ce3hHY9mUmZ6YW14d/IrTSK
         31jNe3Z1h9RVZAxnfqRzzZl0DwrCcK2EQseDgWEV7jcgPAS33lkkZnduaXTuRyJMOtZF
         ZgN0zOPJUAsKM4rZSaFe19Y/DQhdVjpzUcy94JA4KRNw8OzxhIrXAhuT3bPYK5SWlBP/
         lYFPvebUihsgGhFliTMpxHxxTVnJgOD9sZ4g6dHCAzRHQluGWyMtm78SuIUVEDn01uez
         Yq/VtXaDG0aOvrMKn4PNXEQkY/FEHMFcGK2MdP6/9DC2WX+TjQOrHKypTgzzjGqZCWpu
         B10A==
X-Gm-Message-State: AOJu0YxrcKlW4ovma1c9mmEzWAlLM03jfsp7yDIpxcabhNr9Ek6a0jVv
	gmvME6TRZirh31Rg0g2SPdTFUIIM1ovsE0jVNG+QaIiIWNG0+NmQnbSa/GxFrJe1hLh7x7/g8Zk
	AmrhRjOe6LoKaUwfseeV9Z4UXi++p3aGiU/P/WGwnYB3sT68a2fhNx9XCdF+ogHKnUuARwSDxGQ
	GHRcy+oeDaXEdt6Gma3wOfJvFUlys=
X-Google-Smtp-Source: AGHT+IEUmeAlz4Imq2JyyzkVhuRTi7a9C8sLwYeYalvsIOuqcx0Zrkrw9fHFsQUFy/tBsY01i2o/sIjt3A==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:600c:17d0:b0:42c:b750:1a1b with SMTP id
 5b1f17b1804b1-4311ddeee1fmr1390955e9.0.1728925091252; Mon, 14 Oct 2024
 09:58:11 -0700 (PDT)
Date: Mon, 14 Oct 2024 17:58:05 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241014165809.984883-1-tabba@google.com>
Subject: [PATCH v1 0/4] KVM: arm64: Update KVM_VCPU_MAX_FEATURES and refactor
 to avoid same issue
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, oliver.upton@linux.dev, catalin.marinas@arm.com, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	will@kernel.org, christoffer.dall@arm.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

The value of KVM_VCPU_MAX_FEATURES has not been updated since
adding new features in commit 89b0e7de3451 ("KVM: arm64: nv:
Introduce nested virtualization VCPU feature").

This patch series updates its value and refactors VCPU feature
values as well as KVM arch flags to reduce the chances of this
happening again.

Based on Linux 6.12-rc3 (8e929cb546ee).

Cheers,
/fuad

Fuad Tabba (4):
  KVM: arm64: Update the value of KVM_VCPU_MAX_FEATURES
  KVM: arm64: Move KVM_VCPU_MAX_FEATURES to the features it is counting
  KVM: arm64: Convert KVM_ARM_VCPU_* features into an enum
  KVM: arm64: Convert KVM_ARCH_FLAG_* into an enum

 arch/arm64/include/asm/kvm_host.h | 58 +++++++++++++++++--------------
 arch/arm64/include/uapi/asm/kvm.h | 22 +++++++-----
 arch/arm64/kvm/arm.c              | 12 ++++---
 3 files changed, 52 insertions(+), 40 deletions(-)


base-commit: 8e929cb546ee42c9a61d24fae60605e9e3192354
-- 
2.47.0.rc1.288.g06298d1525-goog

