Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A2AF2AF1D
	for <kvmarm@lists.linux.dev>; Fri, 14 Mar 2025 11:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741951117; cv=none; b=lgrJsENb74oLvsS9Zco5Fu0EF8apE8lRCCecDn66APEgS1oUGOz/HY5eCWUlpLkh6VPhCtqZMirettpiXeJBP/0MAONSj3dWIpbYEEaAsoFhZHgXt8KYgko6+dML1pkgHGXf0ScBbFTYPpgV0+g9lL0XUACFbxyDGv4n8PD1eoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741951117; c=relaxed/simple;
	bh=R15fb6BYhmNXYpJmQNDB570ZMBZbZGyrcK63cQ2EU38=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=LNaZdr7J4JrHqNKHUSlZNLz9wlW5P4i14EIGQYL6MlZSX12TnDx+p9j5XF1E6MXAha0DcuM0FiCzHxrguM2w6qwsYSP5MDFOuWBJTuXxY9rsK/bR9kKyNl5o0T1V4TYZAGHFh8M83LnXUs72683co2RD/sLdLoV7BoEwptgowNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=x4fCXC8d; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="x4fCXC8d"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-43935e09897so15598475e9.1
        for <kvmarm@lists.linux.dev>; Fri, 14 Mar 2025 04:18:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741951114; x=1742555914; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=dGlveVYkNT3ORTsa8Y4KKrCzm4MLsBH8s3oP68vMpb8=;
        b=x4fCXC8d2zKDOLvb4N1DsbhrlGK6OP73bdCk+iHtCl6Go/hl0zkEeMR5sI8I0oKiR/
         pf/6mu5+kt/UTd0s2btPsqBT3eI4sG9pF22Lr/Y2blBYY5qfHTP4aaOq8cV1CKUbSMut
         NVtjMIyPh1NXGSiaKhCTyToKfgZD/3ByzXg3IBxCaeos0j+sWL5pomso6C/B0AICDSyJ
         sxAE0etnlhmz9PEc1wKaTC8jVlmlfWqkBsUIAT8yXNMy9i/hsrsnDVFmM47HewgL2Ien
         vWFr8ZBlgA0TKQQmizXSJE8GSmV4kaIk6LVcbgwekSRCAPNNKKe4BWMYRtr4rPWMssuo
         rhRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741951114; x=1742555914;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dGlveVYkNT3ORTsa8Y4KKrCzm4MLsBH8s3oP68vMpb8=;
        b=hEfhnjZ1p4XLQSRZGyQaYVAZG8z7hsGfhqAZ7KXDI6Tw92xCgCENJmrNVkptHau5Sb
         hGs7IdjN6JX5GOccWqhrl8GaYRm2lkjRqTDHGrEC1c5qUa6Vz2PzMnck8HLiQBmBOZlA
         HU0lOAtNc45jjNkIwM2V0AbISlThyfuz0u6lLEIpcVHqkOUpheu9Bld4G4gv2HuhG07u
         XkLWU9Fxo2E//EP1XPsEv/Zxu8fY57YQxn1Nju6OJuCNzBMjQTJpZD0qLOUiLFNEf+zH
         IF4Wqb9MJbWoBWuBFRILOOwUAcsXdDZ6QYnw2Pie0RbqJIuc163ZkVWksuL7IDuOEkAB
         VtoQ==
X-Gm-Message-State: AOJu0Yz4VLUuzGbGnVQpz+zwsOz2nq5OEh5JN/E/9tFZyYsY0wP8sOMv
	uatwwArWWjcfKG5c2YOBYg+K9nq9UIGVD0ySuyIE5fMx95st0yyK0DtfANZ1/GnGeEIa2m4ghL3
	xkL8o6tJ0SJJACaDlpLf3yopB/c0aNL91uoXov31s9VJ/UTdu3NHQz6R+7cngBSCLufgo20vvca
	mD9FtUydJD9ct/SooSnOHkUgkql2U=
X-Google-Smtp-Source: AGHT+IGJOLU5r/fEt2G8VDB8bc+OCYCwiUAaTtua3hlqUyNrvce5rqhGBeHSxBkdMi8rNd4X/72wEQMn4A==
X-Received: from wmqd2.prod.google.com ([2002:a05:600c:34c2:b0:43c:f6c0:3375])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:510f:b0:43d:aed:f7de
 with SMTP id 5b1f17b1804b1-43d1ece301amr23196365e9.21.1741951114433; Fri, 14
 Mar 2025 04:18:34 -0700 (PDT)
Date: Fri, 14 Mar 2025 11:18:28 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.49.0.rc1.451.g8f38331e32-goog
Message-ID: <20250314111832.4137161-1-tabba@google.com>
Subject: [PATCH v3 0/4] KVM: arm64: Fix initializing HCRX_EL2 and other traps
 in pKVM
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, mark.rutland@arm.com, 
	will@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, broonie@kernel.org, 
	qperret@google.com, vdonnefort@google.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Changes since v2 [1]:
- Remove WRITE_ONCE when setting hyp handle (Quentin)
- Rebase on Linux 6.14-rc6

For context, please refer to v1 [2].

Cheers,
/fuad

[1] https://lore.kernel.org/all/20250226215520.1759218-1-tabba@google.com
[2] https://lore.kernel.org/all/20250214150258.464798-1-tabba@google.com/

Fuad Tabba (4):
  KVM: arm64: Factor out setting HCRX_EL2 traps into separate function
  KVM: arm64: Initialize HCRX_EL2 traps in pKVM
  KVM: arm64: Factor out pKVM hyp vcpu creation to separate function
  KVM: arm64: Create each pKVM hyp vcpu after its corresponding host
    vcpu

 arch/arm64/include/asm/kvm_emulate.h   | 24 +++++++++
 arch/arm64/include/asm/kvm_host.h      |  2 +
 arch/arm64/include/asm/kvm_pkvm.h      |  1 +
 arch/arm64/kvm/arm.c                   |  4 ++
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h |  6 ---
 arch/arm64/kvm/hyp/nvhe/pkvm.c         | 62 ++++++++++++++---------
 arch/arm64/kvm/pkvm.c                  | 70 +++++++++++++-------------
 arch/arm64/kvm/sys_regs.c              | 20 +-------
 8 files changed, 104 insertions(+), 85 deletions(-)


base-commit: 80e54e84911a923c40d7bee33a34c1b4be148d7a
-- 
2.49.0.rc1.451.g8f38331e32-goog

