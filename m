Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCE0D2144C3
	for <kvmarm@lists.linux.dev>; Wed, 16 Oct 2024 20:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729109291; cv=none; b=bM9BO6TsrLfe5wPGDsQiF1RT4LGcxwYHJSSWuy8HCEJ6kM1tMG12txrOwNX8ncYq4KdGTMHBnj+oAB+k1/hBXt8DBc30CUMIjx3iWBPWi79vne5RH0Q/fBlzEod5k8FQHGdrxqtIuDocQkVjJi+Mal2gKPjA0AZr2m37S0Gy8K4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729109291; c=relaxed/simple;
	bh=GdkznF4IVV6bJMBN5T9UjLgi67lcbrBzwicDpDkQp9I=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=Pss3N8hYpuFdPUYKckUVVgBCZ15/tonyb7JEdjq98EKl+QD9YolpZIc0w1yNgW7vBV30xtVhdfOq9GiMdWDgRxY/cSXx5aqTNvKqztjq+BXR+Et1OUaZw/NmDQJ2lgW1qehnymQiOrIWo7ts9n7tcut5hqHe0jJmE+0ZFj8jQzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zBqLs64b; arc=none smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zBqLs64b"
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-45fb0ebb1d0so15921cf.1
        for <kvmarm@lists.linux.dev>; Wed, 16 Oct 2024 13:08:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1729109289; x=1729714089; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=4x8ZP9Vbh+VTFMg/xiymQsuRxJWNJs+6ZIoiCkqRAm0=;
        b=zBqLs64bZGLSLyX93GEurJnhh7ApTA+/6GG32MSiQYAo4Ay8MGczFai2zWTJX3LhxM
         ITg00NV5lVh8lCs0dDemfKzuy4HTAkYpcNU9B0qQ0rejiXqEqruj/V6LHNhBQzI/ywBT
         XFirVt31ze3Ipm85UufWFF0MWoHAWyvIu3ZEjiALyK+SprBEVwhyEn0OXZXqANPGi3La
         OCcvqp/IdXBeQJfaMpe7njFeteMw6QYaYzUPwrobAo2M+4s581uDNs3osHCpQybdw8Af
         t8BhuTJZ/97IfOtrZWjPeQn/2kQrfiLiZ6KqTkY4tNwAxx2yzhUhwyvEKFJ29mFrwY1C
         zGow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729109289; x=1729714089;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4x8ZP9Vbh+VTFMg/xiymQsuRxJWNJs+6ZIoiCkqRAm0=;
        b=JnBWnPBVlO7EYVdGAQFInnL0Kjb6uvkeQTaw7NjUtQlU6gATX2l/lQUTvQKFRMIMO2
         47MksZlR1OieSyY9+Gsr7DMUz8YL2Y8pdEdNh47Nzi0JkUzhoFLbzd6kOfov5Xk2yWQE
         3ipughybDcs3dRMJUJMKVBLWOj/wD8QaP/3flFl1oqfrf1Cn0t9jxCBi/gpkEQXwVNoF
         TYdI9EPeG5e83lA9LS5JRhGGTtRiWHRt8AotqFP+a/nSXJnFJJlGDCB9cfjxfu9RKyqX
         Up2MyOwLa2sXKWHcjsBoPEHNdRFtRRuIrVG2KRdS/MgthlyX7EGlQlQG5dlH9rFquDhQ
         gLug==
X-Forwarded-Encrypted: i=1; AJvYcCVv/uUZEJbrJUbkHFiKwYVahWsKDkyuZCMZCo9f+QiEUg9a6GKIp4tAHJmuvxB8D9EVqkyjljM=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw4TfDIbNGyxzu4aqAv8xl0NRBgxxuZxI/GWHoBQS6NjYABOnic
	HdCNZsNSmkW1BUuSRpg9WpJpKdcOWsKnFsTPw1ZCUTZM3RIHM/oybjPPRb+DzbfgzTw6MsEcnRF
	+xNxzAwpk68w7hyQYxLwoDVlfSd68WOoVf7k9
X-Google-Smtp-Source: AGHT+IF5hnOqY+1pTXpL3951R89pfy6xU8zLwGpCYH8n03Mf3vHjGku1bi4mgVj553z973h+Q6KOOQ98ZWYCxNR51ds=
X-Received: by 2002:a05:622a:4e98:b0:45f:6f3:5671 with SMTP id
 d75a77b69052e-4609c8e1896mr731531cf.20.1729109288691; Wed, 16 Oct 2024
 13:08:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Wed, 16 Oct 2024 13:07:58 -0700
Message-ID: <CAJHc60yoipTA7WywvPSM52X-NgCTgy2Dvxn8OrCT=vPJNNxNxw@mail.gmail.com>
Subject: [kvm-unit-tests] arm64: Build failures in fpu.c test with clang
To: subhasish.ghosh@arm.com, andrew.jones@linux.dev, joey.gouly@arm.com
Cc: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev, 
	Linux ARM <linux-arm-kernel@lists.infradead.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello,

Compiling the kvm-unit-tests for arm64 with clang gives the following error:

arm/fpu.c:235:3: error: unknown register name 'q0' in asm
                fpu_reg_read(outdata);
                ^
arm/fpu.c:59:10: note: expanded from macro 'fpu_reg_read'
                     : "q0", "q1", "q2", "q3",          \
                       ^
arm/fpu.c:281:3: error: unknown register name 'q0' in asm
                fpu_reg_write(*indata);
                ^
arm/fpu.c:92:10: note: expanded from macro 'fpu_reg_write'
                     : "q0", "q1", "q2", "q3",          \
                       ^
2 errors generated.

It's likely that clang doesn't have "q" registers in its dictionary,
so I tried replacing it with "v" registers, only in the clobbered
list. However, I think this granted clang to optimize the code in a
way that causes data abort at in fpu_reg_read() at the first
instruction:

stp q0, q1, [%0], #32\n\t"

Although removing the optimization flag, -O2, generates correct code
and the test passes.

Any suggestions on how to deal with this in a better way?

Thank you.
Raghavendra
