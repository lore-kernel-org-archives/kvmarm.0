Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39DD92233B
	for <kvmarm@lists.linux.dev>; Tue, 22 Oct 2024 00:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729558038; cv=none; b=Wo74thliabvp9gY9xRWjv0ca+4Q5S5izFUHbaGVlKSXgtBgBzxVsBJCwZafnFStJAvlhlOVCsHdn5QTxDATGcgIvM4mPx0CzC1EQI9QfrLjQqYIHFzEk47W5tjaN7c2uLMRaXAKgr+PKDLjNQgsbygOIeofu3lKJiUs2s/TSQoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729558038; c=relaxed/simple;
	bh=oddlXzPrbA0KUDkQ/VqCUaaziMk5kQcLpmj6TYb3IOE=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=XYLkPax4iz2RCf2rNa1lpRVuHopQQKFsRrIhaWHCTb3HfKDvwf5Pvzq3gULwi3FIiHJ3tjvl+HojpCutztouTMNnKdxNcEJqljSwB0UzqWa3ZIdkLNMk8cZRTuRMjInJFy+O5mCxSSBaWphbsKnAXsPw95BowapTw2R/0iYd840=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rfXic+2Y; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rfXic+2Y"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6e36cfed818so76128137b3.3
        for <kvmarm@lists.linux.dev>; Mon, 21 Oct 2024 17:47:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1729558036; x=1730162836; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=eKlqNI7codORggOmuakZnfoKtsVxCBFbd76VCr1Cfs4=;
        b=rfXic+2YjFUQyft1jcGv+Q13z/IEXdkIIzBMRFlqLFCURZ/Gd4oR//AxCX/Bt/r/VA
         SojdJA7RJ/kU0RXGLb96Zq1zbTxphzW4AIRalOToSWzvBQUeFtQbWAKdtPy6UkQYgfwF
         x+1xXKlbK4YQO0WxIM7bsX7Ba5x6T9mXDCN1lk6rYMFXNaw2zO2Ot6aXwDS9ozR+dSc8
         KSQkxUw6MdYUJKGEKkcrIS1KTkU2X78x3Q5w8iTAFyIc3jv93g28qeQgcJoI3DRRpQK2
         pa638OLPXMlKruLQn8pHxAisPhn6IFVBsOoGbFwtu/rJvYTodX78jzHqf45nmvwQHhZ0
         4TEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729558036; x=1730162836;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eKlqNI7codORggOmuakZnfoKtsVxCBFbd76VCr1Cfs4=;
        b=Z8AJZvkwrXe2IyNx3ve/trhrBStGVkO5KCyIW7+GFO80Sd96Jd+eUpNnfQFevej2pF
         yvdyCx3lpifnSKLxl2Vv2o4eJ09imgyreYqMMQiYVFg+iaQtk9623xmpreMgsk0zqIC/
         /grOqO5LbPyAgBb3hY4/75L0ASFDMgbyTkv3KVBW08QY4V0pYZhafHw+hlplh9b8Nt8s
         wtI5uk3td1P9DRd5AuHjAGzMcBFgyyKm+o2aT8h80+PdUjfBgSON9+rHh8Q1sFXVOHb2
         hVhXt0HyxCSbxBktIImPoXl9mbNGrh3aHuFSzvV0tEMJWKjEM4nS/ohkdNLcvwRT6f/T
         JAHg==
X-Forwarded-Encrypted: i=1; AJvYcCVSSAR8jKJX9E6xSnaruuBswwSPX5oDG4iiXj5JyNoO9CV4gw22FNnXzuHfHMxuE16hVlN9Ufw=@lists.linux.dev
X-Gm-Message-State: AOJu0YyzoT80MWr4irFMELqwMUcGuuV0XzmuiTpR7ox9nw+Ec2WMx8bH
	8IEOCuEoI2ZD/g6YcQm/IIyX2w7n1Xen4hoOGMgoEFT+jlTtvjeqGVCjdUkpWUJWExw1BoKEDjA
	RaQi58Q==
X-Google-Smtp-Source: AGHT+IHOQrd1jIWY9X7tdhL/R0YUgEB2OIskxOwSIWT5phgxs/Ny0301xMZAECFC/6CJbI+nE0pfGWzv7OGK
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:11b:3898:ac11:fac1])
 (user=rananta job=sendgmr) by 2002:a05:690c:25c7:b0:6e3:eab:18b1 with SMTP id
 00721157ae682-6e5bf622fdfmr2750087b3.1.1729558036138; Mon, 21 Oct 2024
 17:47:16 -0700 (PDT)
Date: Tue, 22 Oct 2024 00:47:07 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.47.0.105.g07ac214952-goog
Message-ID: <20241022004710.1888067-1-rananta@google.com>
Subject: [kvm-unit-tests PATCH 0/3] Fix arm64 clang errors on fpu tests
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

The series tries to addresses these issues.

- Raghavendra

Raghavendra Rao Ananta (3):
  arm: Fix clang error in sve_vl()
  arm: fpu: Convert 'q' registers to 'v' to satisfy clang
  arm: fpu: Fix the input/output args for inline asm in fpu.c

 arm/fpu.c                 | 46 +++++++++++++++++++--------------------
 lib/arm64/asm/processor.h |  2 +-
 2 files changed, 24 insertions(+), 24 deletions(-)


base-commit: f246b16099478a916eab37b9bd1eb07c743a67d5
-- 
2.47.0.105.g07ac214952-goog

