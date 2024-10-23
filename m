Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 613F61A08C2
	for <kvmarm@lists.linux.dev>; Wed, 23 Oct 2024 15:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729697203; cv=none; b=YAZvnmJWf93BqGLEVexioS6dDR3ZDjcRLPalHknGRRSUKumXrbSJnIxPsy6y2Ow1fns9NuRCzORTN+vzwwQxH0GAIwiLsPEQZctZ1sFOJfy3RES5/Dg7POqbhR9z7jIUa/nQnRUSP5R8l0NmnyL4Tp+vbn8GYkWXdjniYRfDGME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729697203; c=relaxed/simple;
	bh=hHfBZftXhNOJ3HtBKDzEps5lRrh8yzrWQIEEayw2NdQ=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=ZpQbgMqVJBxxzq3FZ4EsZSrF3i/j7KsVLg6D/KnAlXnuExeRlt7Fj5/7L/+sN5X70uzNKQI+LIwW+9KJZhpCXK5TezkWoMNnSHWIBxJdAibByZy/fd91xgoa6CQLhOYAOcfjb6i2izFvbF4BVSCGI6elxr+V7Jc3IqWeZINZ+x4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FCPTxGle; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FCPTxGle"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6e35199eb2bso129952257b3.3
        for <kvmarm@lists.linux.dev>; Wed, 23 Oct 2024 08:26:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1729697201; x=1730302001; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=LgyTGB3pqM8nd2tlaCQUWlInWbsb/ECPLI+TMKap3wE=;
        b=FCPTxGlewIYeK/ZH4X0cXX+4mzDJthX990TPT7014Zjj8YUYj9Dqd8uLq/d+1E2hJm
         OJBGSeJYDCUFrh4z93LRc1OdtxVefQGgHnSVk+EWyBWyjlSnvwZiRaom1PG9iXz8f5tH
         1JD9WoDm0T3HGFUrQZQzJF/88wXotguIOl+B1dRHHh6tQ7ceoQhJN+COB5BI0JiGJAQv
         u3l6AHVlD292cXNP7kriCE5hnIroDLrlrqhhaHPyprnucCDN/8/UK46ZQhPXsVHVEJ04
         SjNpKFzb9maj7Dumemt5G5rTBEiJ43vKHIxnVzUoLn4oIJQlubdsvXA+1UUp/QaYUJUo
         Iu1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729697201; x=1730302001;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LgyTGB3pqM8nd2tlaCQUWlInWbsb/ECPLI+TMKap3wE=;
        b=saycW8zuyc6gco/2DB3f6lmsaFFkiFejo/bemKrkYED/LAAdyMYLpycWmwJ8xdiObf
         mUcaGNasvyv19fz0Vu0sI9u1PKyPUOcc63xuj2rjolvRLwHyxSyRljsrhTMek+MPEDB9
         v2YyhtqawB8SQYB7QxV7AmZWDDBt45zwfSmbHuXblOcLISbH3PP2oZdhcCadiuegxl8i
         wn3QEhXpNN1zvSDUyxcaTYd3ixbkHSI41JM1oHJQm6eScyN2zmYbzKZvPi+LWz/bHN/2
         5yYBcIoxtsuFYO/DiBnRrAjqOCDftiI1NWkvVtBkfD4ncy88KiHiJ7b2KEL6N0IOhYrM
         W1ZQ==
X-Forwarded-Encrypted: i=1; AJvYcCV0JjVX9phONbJnD2sqFaBMkEBstQIWEN6TrqpBeKrbTt16cnxNSbQjzy806t2ZSGJC2F0GnY0=@lists.linux.dev
X-Gm-Message-State: AOJu0YxjDnuXEuM9eFl839BE4C9B40Xmv6+orxEG01gwtie5qAcz6kQv
	aE8ghHS/FOcAuzkrP8zbbS1gvURVUk3KPTDQqu5UgKXP0EejVa+yoEgLScaLA0zRYPhdsjXAIdS
	2JEhMmw==
X-Google-Smtp-Source: AGHT+IGZLylUFfRaeoUChkh5zta51HqScos57+PeLEawa/Zj6Vb0Z2er1q5qfJlHjZXBZG3OR/irola46j3M
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:11b:3898:ac11:fac1])
 (user=rananta job=sendgmr) by 2002:a25:b21f:0:b0:e2b:d28f:bf28 with SMTP id
 3f1490d57ef6-e2e3a5fa7a4mr5506276.2.1729697201237; Wed, 23 Oct 2024 08:26:41
 -0700 (PDT)
Date: Wed, 23 Oct 2024 15:26:34 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.47.0.105.g07ac214952-goog
Message-ID: <20241023152638.3317648-1-rananta@google.com>
Subject: [kvm-unit-tests PATCH v2 0/4] Fix arm64 clang errors on fpu tests
From: Raghavendra Rao Ananta <rananta@google.com>
To: Subhasish Ghosh <subhasish.ghosh@arm.com>, Joey Gouly <joey.gouly@arm.com>, 
	Andrew Jones <andrew.jones@linux.dev>
Cc: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, 
	Raghavendra Rao Anata <rananta@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

When compiled with clang for arm64, some build errors were observed
along the fpu code. Moreover, data aborts were seen while running
the arm/fpu test due to misconfigured input/output args in the inline
assembly.

The series tries to address these issues.

v2:
 - Fix build errors for newer clang versions that push 'q' registers out
   of scope under '-mgeneral-regs-only'. (Andrew)

v1:
https://lore.kernel.org/all/20241022004710.1888067-1-rananta@google.com/

- Raghavendra

Raghavendra Rao Ananta (4):
  arm: Fix clang error in sve_vl()
  arm: fpu: Convert 'q' registers to 'v' to satisfy clang
  arm: fpu: Add '.arch_extension fp' to fpu macros
  arm: fpu: Fix the input/output args for inline asm in fpu.c

 arm/fpu.c                 | 52 ++++++++++++++++++++-------------------
 lib/arm64/asm/processor.h |  2 +-
 2 files changed, 28 insertions(+), 26 deletions(-)


base-commit: f246b16099478a916eab37b9bd1eb07c743a67d5
-- 
2.47.0.105.g07ac214952-goog

