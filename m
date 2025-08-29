Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74780270EBC
	for <kvmarm@lists.linux.dev>; Fri, 29 Aug 2025 09:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756461107; cv=none; b=izkZrXvNBQ3Xy39/bGkgimxDkFaB76wb1uZaszDgs4xZ83FjzvRuSm4e1c6BPddCNusdGL6vpA9vei1fezGWWPwTht3FkFaHBPqHbc06RBx6TFM8sPq3wbaDdZ1/LcHaGMgUpzMrO6Ru53INpO0F52B1Ok8aUDDbMvQeyl5epd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756461107; c=relaxed/simple;
	bh=9GIA2BFF5eLSy6mrBzqSFzk5Ex1qE7rhRRN0WvjbZTE=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=sAxAnXyai74/Hhcs8ZJR0xL1pJ/Jujo7DtjFL1ffi8hGSQ0E5yjc3j6E+ixRzrmlP5u7K6rMDgORKfI0IgGVdgHizzhLf7GVYkkhCCH3QHdjhzv0f2LdWJnI/Jfn43RKJS/+X5O21ErqQyBVpyhkWoc6waqJruqEAW49J9wI75s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WCeyJI7/; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WCeyJI7/"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-45a1b0b14daso11493415e9.2
        for <kvmarm@lists.linux.dev>; Fri, 29 Aug 2025 02:51:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756461104; x=1757065904; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=txk6Ntr1OB9E+08Z6A0ZYjiGrZLcfjKX3b0L/eGpWQ4=;
        b=WCeyJI7/eox/N3f8aXqqvIETg3XKiShCWdhxdotWBVWMOYApDKpXQc8j0ULjNAaxFm
         qSOrtuTiCH/mWgfd7OCsNxpGnN0PU858Iza8KVgxHdlY21TX6ECdtyjlXHtFQERcvP/H
         XgDXyN1ezRCc9tcNzX8hUS9Dgk7FarLuRfWEgidCEM5IP1pNvrwYI3FNu4u5pymLHgES
         UD8vR74Y3qJKc5+iPM4ob1HGykpfVv7INe4W+bYX4bR8lO+NNnLLGOCxYoW8Afj8asL9
         Ym0m3VKfw9BF1hbVNBeD/6G+zjuzQXxhNJDK8b0Wdie7kw3LCeZLga+m9zwRBTIu1n8U
         vwAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756461104; x=1757065904;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=txk6Ntr1OB9E+08Z6A0ZYjiGrZLcfjKX3b0L/eGpWQ4=;
        b=ecVL4+g5FbAep+cljkpg+zcCOrGml84vvgHqT5ibRXWmYv2G4Rwu0a/1GIHWRnw2Dr
         INi5qJX3vYhWVG5kBasP/lx2hnWCGFlboc0ElWzWj0TkS3k+tXH+I3wkmhH97TTikYHA
         WksEvAVS0VI9TmSZEMkwAvtKFj0QiQJumf7YZ26h/gcmmFC6nROjS3+rrmP6vWh7NKry
         ua9z2X6LFuKqUFHQUw8z3aFjQp1thPFYRB4X737lYPlXWv2fg0YM4x5paEVUsQbMSmEw
         PqAzS+To2ELonTArI6h9ezSTed/KbA28d8hZU3czENoKThNknJtJ2ATrKmDhjrEoxPy1
         MlTA==
X-Gm-Message-State: AOJu0Yx7ZYHYcBbeMqZzwYk5btoW70rcUPkWxrSQVm+2JWc/TgS6KNGY
	BsKsgbIjuNy6kjoKiGrQEv1tx5uK0tVCXusrYlH0EtNG5hepEozyU1/yBXOeUIOeilX5G0/X/yP
	GMwsr+JNqU+Uc7af76YgI6mHqL5XtiBq/QmyaqpIUFabdHrUaxtYw89rbSHqb/Q8Xm1WzDC842w
	aeYA7DQdKUMNTnNJzt/PYZUKkXxvgu3Kc=
X-Google-Smtp-Source: AGHT+IEf1nkRoty1oRvWii9Is2r7lcOEZRt6GRqg0M5bkn7wWr7F2w87YgWyLO2mtNb12anWTrGICsLuyg==
X-Received: from wmqa7.prod.google.com ([2002:a05:600c:3487:b0:459:df20:248e])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4248:b0:45b:7e86:7378
 with SMTP id 5b1f17b1804b1-45b7e8676f1mr12711315e9.34.1756461103846; Fri, 29
 Aug 2025 02:51:43 -0700 (PDT)
Date: Fri, 29 Aug 2025 10:51:40 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.338.gd7d06c2dae-goog
Message-ID: <20250829095143.123476-1-tabba@google.com>
Subject: [PATCH v3 0/3] arm64: sysreg: Fix sysreg field definitions and
 generation script
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, will@kernel.org, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, vdonnefort@google.com, qperret@google.com, 
	sebastianene@google.com, keirf@google.com, smostafa@google.com, 
	tabba@google.com
Content-Type: text/plain; charset="UTF-8"

The sysreg definitions file has a few errors. In Enum Security,
NSACR_RFR is set to 0b0001 instead of the spec value of 0b0010.
Additionaly, the sign of the Enums DoubleLock and EIESB are wrong
(should be Signed and Unsigned, respectively).

Moreover, the file has some redundant definitions, e.g.,
RCWSMASK_EL1. While these redundant definitions are not wrong per se,
they add unnecessary code into the generated header file and could be a
source of future bugs.

Fix the Enums and remove the redundant Sysreg definitions.

To reduce the chance of this happening in the future, add validation to
the sysreg header generation script. I didn't want to go overboard with
validation, so I only added validation that would catch most of the
errors that I've seen, which also are errors that wouldn't generate a
build error later on.

Changes since v2 [1]:
- Added patch that fixes field sign definitions for DoubleLock and EIESB
- Removed whitespace fixes from first patch, since there are more
  inconsistent whitespace use in the file, and fixing it all would lead
  to too much churn.
- Collected Reviews/Acks
- Rebased on 6.17-rc3

Cheers,
/fuad

[1] https://lore.kernel.org/all/20250813164506.1203851-1-tabba@google.com/

Fuad Tabba (3):
  arm64: sysreg: Fix and tidy up sysreg field definitions
  arm64: sysreg: Correct sign definitions for EIESB and DoubleLock
  arm64: sysreg: Add validation checks to sysreg header generation
    script

 arch/arm64/tools/gen-sysreg.awk | 20 ++++++++++++++++++++
 arch/arm64/tools/sysreg         | 18 +++++-------------
 2 files changed, 25 insertions(+), 13 deletions(-)


base-commit: 1b237f190eb3d36f52dffe07a40b5eb210280e00
-- 
2.51.0.338.gd7d06c2dae-goog

