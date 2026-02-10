Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FC7B3161BA
	for <kvmarm@lists.linux.dev>; Tue, 10 Feb 2026 12:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770726475; cv=none; b=CeYGRg3EV/TuJL2URbsa8I2CREXfdG6lcf0glDanBskBHyKpQ5jVT/JTzDPa1oTwARBNYY+ejdHW+7MKq0owiqVDthGK8BOJagHwqmbur8EE+b3w6UQEjh6dn5zGEOkjcm377Tfe5wVL1CqL1QVVceHGgA2zmawldnGBPAAxrU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770726475; c=relaxed/simple;
	bh=FeWT36l1sB3zxTFs86TdlTNFc7iygsGLbEB8Bc015Dg=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=kH9fGFleJqiGZlGR88x5LlD69Ku8wjeNmRqDkyLQfx7Xr80kAHZB9Wr+740FC6j8ERuQzjMOnlZpLOIASNf3BOzY6n+mn1Sa5rrcJDjOEvho0VIxwcMTDgpKZflvVtGSkXai8RcZY/Ew3kkILj4ZpztSgLWblbLXNxbCdAeC+HM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HdFx6IX2; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HdFx6IX2"
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-59b834e3d64so4633662e87.2
        for <kvmarm@lists.linux.dev>; Tue, 10 Feb 2026 04:27:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770726472; x=1771331272; darn=lists.linux.dev;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=luSel7zJgDR4E5WZe1AVsST/5fYdEI5PokNDIflFuQY=;
        b=HdFx6IX2kiWj8jFuI6DM8ktDzUVGdyRqhIa2rWOFEX86vp6l/cKBiGYwakUR3hqRAf
         pWwezDC9/czRCj5TklZ2bkSNPV+LzGEjDz8CalARoxPeAgiIt7qQpUWaAqXpIk9W40tR
         +lq6b/xl0T7Fh5YXBDtd4sX4TuK2StynQKMgPlGQzwYK6W8wbpKQ2SAarHJ7ojlTyzeN
         r9ZCjwfwBBXiU/eAD1u9me7xWTtx0NbhfICyQuQv9g2YHo//+rHSz00fYr6jABlDtmtX
         zdiIpz/V6vqfjTx0ri0pt6cknFSOcjCQGVbA03oVDJqp11E5XcQkRQd80viiA/N5/+xh
         Oitw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770726472; x=1771331272;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=luSel7zJgDR4E5WZe1AVsST/5fYdEI5PokNDIflFuQY=;
        b=Bwf9aY0fh+HOIOefwnFfcppv5H+8eLHBA3pQcIUP47/IpY698aRcRj03OFtinpbwMc
         eVa/ZfQ3gyJxwP7dBzA+buHWAUApTzL3fsT4lQSoKfokBtJXb/rumusuzFrTLCFCTrdp
         YKTpe8JrzIvEoyVqL+jQYph++YX9FUQ5x01dPdOWNKOMk0R52DcOjcxxZiXZd9l0ZFtW
         M5qB3NXSjTpI4oihUPnCU4QZ/IcwclU93QeROXBk/GL0xSOzc7yugKJxStYhQQK6N4eD
         UKeMEVB/tHDxFfBBTwPIzbBH2LVov0wSv0PVFbhIiWKoBada/QTA8dWehDGvUSFbHjIs
         yP+w==
X-Gm-Message-State: AOJu0Yz7jBMDlHm8bkhvEx79Blbn6PBH2mzN75B3N61PhUBXbqTeXf+u
	imLTFx4M7N1AGsEmbfBW+0m/gTPJe+xMzZHzc+0quL9hAP7l+tbMFiDIip0Bt/cacPku+DSwbJu
	58zITnQ==
X-Gm-Gg: AZuq6aKQQ79PjPFfBJxkpQygPVWa1Z99qKu1l4vpmrACO8cRn98l7nIPCfVoQYL+M2E
	6V9AdpWFnpXmWoDZ1oCmYdu0mtz4YpylBN3vtCc2dbE3L+FCu8xzvcy+6TCqRRZjRoMnVQ0/RaN
	9kBKvKQCOZ+bUVsZB73ipoVzZm0rQHwIlPSnxCWaVi3TJ5lXZjLv6j+73jV0FbbvrOqwTOo7e6Y
	VTMX0E6D+RtgPrNDW1KW2FxukBMvFxdPJEAs8Z66Gml5USyHa36PQ8yPCk2vVnTnOBHmfJn0nKA
	BOm0wW3WsGOeE/2w0Jsg0nYvGDc4UezPHRWZINpvKhkIxzWXljduNlv/UBHAHF81ZF1S2PrtcXr
	g7HyAVR2GXm5Ag1BBdXdMVg7Wh7cXCIRgKBiUNgSxNxj7oYlr8xGR+lHAAZfDJ725te0OEKsbJr
	3mO7MSeQwoUK4LrWdoQyELw05+4QN9GtV/0+dukeF0TSXux0Vg/nxHZ9hZpw==
X-Received: by 2002:a05:6512:3501:b0:59d:fe49:7f6d with SMTP id 2adb3069b0e04-59e45044694mr4487623e87.5.1770726471821;
        Tue, 10 Feb 2026 04:27:51 -0800 (PST)
Received: from google.com (133.23.88.34.bc.googleusercontent.com. [34.88.23.133])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-59e44cf6f1csm3196852e87.19.2026.02.10.04.27.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Feb 2026 04:27:51 -0800 (PST)
Date: Tue, 10 Feb 2026 12:27:48 +0000
From: Quentin Perret <qperret@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, oupton@kernel.org, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org
Subject: Broken udelay() on KVM host with a vcpu loaded
Message-ID: <ktosachvft2cgqd5qkukn275ugmhy6xrhxur4zqpdxlfr3qh5h@o3zrfnsq63od>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi all,

I have just received a report from a partner of udelay misbehaving when
running on the host whilst a vCPU is loaded. This hardware has FEAT_WFxT
and uses the matching implementation of udelay. Interestingly, WFIT
triggers using CNTVCT_EL0 unconditionally, but with KVM the host/guest
switch for that happens from the preempt notifiers/vcpu_put which aren't
invoked when e.g. handling an IRQ. Interestingly, udelay reads the arch
timer to set the waiting time for WFIT using an absolute value, and that
gets compared to CNTVCT_EL0 which in the aforementioned
IRQ-with-vCPU-loaded case uses the _guest's_ CNTVCT_EL0.

I can think of two approaches to address the problem:
  1. have KVM context switch cntvoff proactively prior to re-enabling
  preemption when handling a guest exit;
  2. modify the WFIT-based udelay implementation to read from CNTVCT_EL0
  instead of the arch_timer to be a bit more self-consitent;

Other ideas welcome!

Thanks,
Quentin
