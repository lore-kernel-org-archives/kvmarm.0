Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC6AA15B98A
	for <kvmarm@lists.linux.dev>; Thu, 18 Apr 2024 16:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713457904; cv=none; b=uR6BmEIir90pvHRy0QzCN5Z2MWaeEb+nKj648g47w9mt+NnCrk7rEklzSHgxm0LejQczNXIEDBaZBOuM34Pgw2rE7VLw6EpN1/9W0Bio3UlO8xVnIgsNMX2JZissoYYOlonxlMHWsv5aSy10FE+s8B9KyPOPu+ooy7Pc4Ld+VTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713457904; c=relaxed/simple;
	bh=LtaM0rVbLu1ag5cMKPQBBXdIfFxBnZiCY+XchhieBXY=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=DFiCZIoM7CSwmR1lFFaW9wZQG/soF+VPDZm/o6gCiZCs5BCGApQVFUJW1aUGbw2FlCApO/umtymVZ9iQfR5KjQLeUZh45QADB6mAV0XSoT4q6qlrB1NMxmDVj0bJCpHiFG7P8rfDtAD3OsrsV7buyzd81jkM+D8pAMmZ4TFN0hY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yCj0Cg0/; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yCj0Cg0/"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-de4691a0918so1565536276.0
        for <kvmarm@lists.linux.dev>; Thu, 18 Apr 2024 09:31:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713457902; x=1714062702; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=9ltIrcV6ni9WJvy7sa5ZnYfA/lkvYHfjAr3qlJI9BUs=;
        b=yCj0Cg0/4CG6oYo14YrFM/Vm5IavbNSy5Il93meiYkGvI/BeWWKi13yK4OImFzXhhp
         E6FoSJTfKcDgMfI7+IURqPVV1epiou+yZCHmx36R4pWAlojL1bqagMez+gboz+GS+AKC
         xElH4PcUuE+9fbN2NyabO7bbQ66oaBpPwvjKWDiFsFCYhkbuHzqFltFpyzFSIYCLgq+H
         ux3i/b3VAb5Zwi6gmOYgWM4Lhs3l8nk2sgre9SYKoYvogvhAdbd/lueFVm6I33YTHdoQ
         F77iYwrOEB7DvXQi2FO3stjkSDUOlY+y209Iqi2QVsotMzoZD/sgsZy/LeaceI2dWquk
         DJ3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713457902; x=1714062702;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9ltIrcV6ni9WJvy7sa5ZnYfA/lkvYHfjAr3qlJI9BUs=;
        b=gxJExQ9sQOgCNPJ+rv3/cpjtUTbL5KZX5bdrioa/LYgHbr7noGzHZMqENQzf4gYX54
         ecq7gClZq16//Z5lCuLszLsEYE/eUfhkT3clrtWryDnSEK3BNzVjKB5cL+9Qoai3HMfB
         f/icOU4z+89zJADv5qUT9F2gn0Izfsaf6wEwJ2btYkNbKK7W3ArUY1ADkmCAoF5pHeXG
         upC4US9pixe87Ev4wY5YmHhYRdn4f/mrRe7juvfDcx7nRblf3Fx3l78ZWNj8dNUNFzK4
         WJBrCgn3IfXc+mQKVvzWJVDsuC1xmfWJyudmaoYrlu6z0O7dj+7Dx9q9hYdbmg5S4/SV
         smjg==
X-Gm-Message-State: AOJu0YyPpoTK49vBwf/yW6S/EPS5u0DboeefBD8pQyAs6GzlOJnECMZf
	urdSc6He1a7yY5l4wBxaIikTRkdGLd+uAs3C6x0Fdo918JDnGJPLxNtRSes+4QPGd4AnMKQnlGT
	gHc1hznWPTM68BbFDJvWl8sLsHw==
X-Google-Smtp-Source: AGHT+IFzgb9GhfjEE+RHVDZY8Qg+0blXGT4zq/hqyltCjF/7DK1aNMETobD5mbIf5ydAoE4XN1mqzHOyzsEw/eSY4Vg=
X-Received: from sebkvm.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:cd5])
 (user=sebastianene job=sendgmr) by 2002:a05:6902:1001:b0:dda:c4ec:7db5 with
 SMTP id w1-20020a056902100100b00ddac4ec7db5mr801945ybt.4.1713457901819; Thu,
 18 Apr 2024 09:31:41 -0700 (PDT)
Date: Thu, 18 Apr 2024 16:30:22 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
Message-ID: <20240418163025.1193763-2-sebastianene@google.com>
Subject: [PATCH 0/4] KVM: arm64: pKVM host proxy FF-A fixes
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

 arch/arm64/kvm/hyp/include/nvhe/ffa.h |  2 +-
 arch/arm64/kvm/hyp/nvhe/ffa.c         | 95 +++++++++++++++++++++++++--
 2 files changed, 90 insertions(+), 7 deletions(-)

-- 
2.44.0.769.g3c40516874-goog

