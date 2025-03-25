Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C9D518CBFB
	for <kvmarm@lists.linux.dev>; Tue, 25 Mar 2025 16:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742918873; cv=none; b=WKksSxkVa/f+DctTL7tUeH2K8hyFDkVJy9iQ3AGuQNqbWdVEyWtWi+Qdj4p35zxFOwjVKoqaCZCoj9I9l5KzE9BdIIkin7vBxWl6Wp4P1s87PeF3hA4Ygiu2WBMWKGzmAobZw3Kz+CQ+buQ2/wmGWdNI7MBB1rlQMdtsXGJsAuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742918873; c=relaxed/simple;
	bh=NbA+n7cBicvkCk21uXZmI/fvdlcThsInEqcdoWNUAtc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hcdeYqmBemaOP+lCGwWZLzhtqinV2rvLEcLmKTLSciMcf9arA+qvNrxRIeL5F1MpwHpAb+oBlbDaz/N00K5XAU/fPDfVw26RnUMahYLvjO+VkvY9mhhOStUBXozEz5fuJxHZLhvFflY0AdTAYAAXdQ9jWvvBl8EZlh1y0FJVsSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=I+SNqhoV; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="I+SNqhoV"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-39143200ddaso3379227f8f.1
        for <kvmarm@lists.linux.dev>; Tue, 25 Mar 2025 09:07:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742918870; x=1743523670; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=yQTSPvF1hw0TOBoPMd31WqVvKG9w/U98Z3g9Yg4clUE=;
        b=I+SNqhoVKUWoaQpDAVDfICBrYoDdYiH0i/LqdLf9jokz+7OHsldJ9RrSr9TrkpRc3u
         ldHUQHr1VqN7SUlRE08kae/iRRImwG9X0epuMcS/AE/kKEjkGYWltKVI5LzoDziiEnW7
         0IReMOirBjsTC33sHyNZLDB2wiv3YJs0VdrFNShh9g9lWlW/EMCYeWId1+kL94PA3dET
         J8EIM2ztWde5OxLaj6aVwgEcGr3hKPYysI4wzB5h3rBgSTtPr+GG30azq6ktdoFNNvey
         o0GZ5b05Fsns7XIiUoKOCWGUl9Pojmi3Z/uy5NRgd2VhkqIknbr+YxhFvjCC46E5wUbh
         WvAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742918870; x=1743523670;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yQTSPvF1hw0TOBoPMd31WqVvKG9w/U98Z3g9Yg4clUE=;
        b=GqRN39F1goiiNwbeLp27tZZLnCypmdgLcDPy37WdqnBjmfIiYm/GTK6S1z6l/nCqBt
         vxWXWshGA+LWSganKHJBieDQ+zQMb5ZvKitOF++W6mb3Anx1QuXLQ73FcojobJIb9PwR
         E7G/Qv38RwYjHFdyq/Oqef0ixVMXlREOEoNlGpIprCMXSuGbpJcVBsmxsGYCuGOOilBh
         h/fcDkQXIt75H8fv6WpiwC9axhVl28kp+y4QJZEw7Dfw0nuFHWlxUmKGP88qxTBBBlDF
         5fzieRwXHXs3fgo0p5oIF/ka0JtOulVoeGttxTI4+JKz2MG47VDmO7Ecy6VbFGh4mRDL
         +fXQ==
X-Forwarded-Encrypted: i=1; AJvYcCWSzGbTXKaVzy2PyYE+3kSOxyphhm64dNtMvepy147O3TNPRfdpVF3I790fAiArT+qXdK3GlFU=@lists.linux.dev
X-Gm-Message-State: AOJu0YzrhnT7aecN0500xyPtQ/Eh6t3lsyCO7EslNKAfJLi+MXLrn3p1
	RUbmonSWju4W2wE+bvBY+iVMoelFelDWnXvizctsRJbhof/AX4fo+LNWrvcLX4o=
X-Gm-Gg: ASbGncvDJs7LE0GWKdTEPvHeT6qMBedPImG/i04qaWez6o0S2717cUaGR7tcGVSuBEW
	JHEoXcnwVJALJM5hqfWXrpjBbwd2QlvFvs/yJBcZkLfWvMDFQUlSfV8dGmRli+inad2GUE/wBm6
	yqWqEuAk/F+pdluP83tRCgzn/LE8IFiRUbhNJg5SWw19oEFMbRflRV2RfxvaUzjmvTnlipchyTb
	a+u2VKkryDphiP+airtvQPIIZek8jh5akfpnCu1RSoCmcvIgCFwNv+Zb5KKKYUPUJA2XCedJsfG
	PFXbY1UEd6GUB/HppwP4Pjh1ba5zGiFT0MVtv93ljRbeyfZguexSOaVcBmtY54M=
X-Google-Smtp-Source: AGHT+IHOT5jOCGHfjXZiwn0hAT2YJ2NpVHcZDDE7JLfDT/x7D7gnwHssedDwTGk0WlzARWAy46l2EQ==
X-Received: by 2002:a05:6000:184b:b0:390:d796:b946 with SMTP id ffacd0b85a97d-3997f932d65mr17628426f8f.44.1742918869724;
        Tue, 25 Mar 2025 09:07:49 -0700 (PDT)
Received: from localhost.localdomain ([2.221.137.100])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d43f43cbasm203972195e9.9.2025.03.25.09.07.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Mar 2025 09:07:49 -0700 (PDT)
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: andrew.jones@linux.dev,
	alexandru.elisei@arm.com
Cc: eric.auger@redhat.com,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	vladimir.murzin@arm.com,
	Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [kvm-unit-tests PATCH v3 0/5] arm64: Change the default QEMU CPU type to "max"
Date: Tue, 25 Mar 2025 16:00:28 +0000
Message-ID: <20250325160031.2390504-3-jean-philippe@linaro.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is v3 of the series that cleans up the configure flags and sets the
default CPU type to "max" on arm64, in order to test the latest Arm
features.

Since v2 [1] I moved the CPU selection to ./configure, and improved the
help text. Unfortunately I couldn't keep most of the Review tags since
there were small changes all over.

[1] https://lore.kernel.org/all/20250314154904.3946484-2-jean-philippe@linaro.org/

Alexandru Elisei (3):
  configure: arm64: Don't display 'aarch64' as the default architecture
  configure: arm/arm64: Display the correct default processor
  arm64: Implement the ./configure --processor option

Jean-Philippe Brucker (2):
  configure: Add --qemu-cpu option
  arm64: Use -cpu max as the default for TCG

 scripts/mkstandalone.sh |  3 ++-
 arm/run                 | 15 ++++++-----
 riscv/run               |  8 +++---
 configure               | 55 +++++++++++++++++++++++++++++++++++------
 arm/Makefile.arm        |  1 -
 arm/Makefile.common     |  1 +
 6 files changed, 63 insertions(+), 20 deletions(-)

-- 
2.49.0

