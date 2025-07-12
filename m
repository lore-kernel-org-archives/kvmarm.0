Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97B4D278767
	for <kvmarm@lists.linux.dev>; Sat, 12 Jul 2025 13:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752328524; cv=none; b=mtzrL9zeP2FJszTFUkDh6D55W/tTG1+ab5WNbM5+8I4pkJgnKfAFC2O2HxpC5MJy9Bf8OVC5awCcNjaJWhdlOLwFmAQpkyW7E8+KlEptGjS0bB/U3kCCqW4Fe6znbHndfKzuOWjElVTcW9YBV38KBMmj3vguCdSGMEst88RBe00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752328524; c=relaxed/simple;
	bh=RKgGfotXYydNQpTmp9EldXAQ8RrwqhRJUaEpLQizexw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JwrKwPhJCihLt2GaB2B8RMCiyOiKlj1pVtmz85DZEUt7er/kzXQSW+hRgyPi3eIO05FwcWh7gfKhXIChjAri6v7dTTKfGwCKfKJpaFn14THq3r9UP+0wzlZ1hJHfxQUEssIdKeVpNbJykZMYlQ2yOfSwltlltVdrNvdjU1SGXus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=civs1ts5; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="civs1ts5"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-23694cec0feso27447465ad.2
        for <kvmarm@lists.linux.dev>; Sat, 12 Jul 2025 06:55:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752328522; x=1752933322; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RKgGfotXYydNQpTmp9EldXAQ8RrwqhRJUaEpLQizexw=;
        b=civs1ts5qlUENy/tGv05Mye2czqnjcIW/xhoL6zipFlzkEk00dJfkH2T099ebeXNoy
         OKwtxZV8dlxnd6jvbG7YFil7F7b7ytyunwlim0CHEvc6C+M+sJMPa1E+o57Ci+BtbUqO
         r1p1xFsJZsTOHQURnJmsi4HvIU8tbqazl+L6wL/tTB20gYQJU9hpkd1sqO2DWDcBpWfc
         dntMyM6FviWSXWa0/R9OOzSNH1Y+2dObJbWB+c+EucpVv19bwmmKujOYIRTm43yp0BUq
         Tt6trkcBlL3FWTm86u1+esA6BXXdQyMtRKX0hxjvc3f0bLX7KW7jIOmANeFipGdhsiVl
         rTdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752328522; x=1752933322;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RKgGfotXYydNQpTmp9EldXAQ8RrwqhRJUaEpLQizexw=;
        b=Nv2z9TuTJtyPdro9Rf4uSlqBq4HwnqljxovjyItjIpI45YnthW/K4Ps2HYWJ714D1o
         tvS+Fzte7jixjwcSEuzESkFF+w97yxL4EWxCQjCZrj1RdEFsyxPnBnryEkRgHsEdZak7
         nH5ncT6cu9vWXZNnPzm8EThmKzhx9Y6j0XabhqAiJcADr/fvGrWy8dDPded01ZOlZBAg
         cupxh/sF21RzXXQYVm86t9jK46ALGJzidO1bJzZlWKDY4YD5j7yV1f2hUw7h228wYOo+
         lfz1pBJaNFQkCCyqmBdzwvGagy0Bo5JCsJu/92jj+E2o9EJmpeJF/FkyzOZg6sdDvzR/
         Ywfw==
X-Forwarded-Encrypted: i=1; AJvYcCULZMxOthZsoxpVBFc0gWLT+KKlI+W5J3QYyS/zYSY5JssaqBoDUXeFHwsIMIB8upVjbfYKFh0=@lists.linux.dev
X-Gm-Message-State: AOJu0Yws5ViVm8vhuUiRNQ1Mbiyc2jBcy/QmwapbnbVxNbvBH77DdDk4
	R9dvTA+RULt7hKCFIgaCDrE6uyrzmC942BF78MHV9niDlXBLC9KvyvOR
X-Gm-Gg: ASbGncuElZJBInhmKDro6tYOe2hbgRqwNnwmnxjiu/73wqXWIbsb3p8CF6TBXzbfqH7
	lm7uTtbGD1y8o9jmikTDQLgzaejn6Dr9vdVsth4iv0RFQ738gbKHknYT1+3JU0KXhLDm3V4BWQ2
	YMM/xWDzRHQeeXg4V2VwngzBZovPwcY1LLqbrQYeqGMXT/kmeU9Kwjg+jrxDnJC6HYNeW15tiSZ
	7ZSmKYl5twvhoO/q6bPFuMaM7JmmGEflWS8LB0tzn0FH0824ufECFm4vv8H1lJZxkCRZleXwC8D
	bHp8NKmRWijc76UUla1uVHfHRBSLRYnQVsBCM+qyjDeWcjHxZQzRvhg9FWQG+M5mp0zu/B13z/B
	slFnK2KwKeys5XALvYVUxv/WdjgOg0qz9gd/B
X-Google-Smtp-Source: AGHT+IH6HY+p7Hp/Yk/auxux6EFH/0htf4yyEg33W/v6Shc5j9xmPAHiObaFWd+rVZyTMTg5E1r2zw==
X-Received: by 2002:a17:903:fa7:b0:234:11f9:a72b with SMTP id d9443c01a7336-23dede96972mr84775955ad.50.1752328521616;
        Sat, 12 Jul 2025 06:55:21 -0700 (PDT)
Received: from daerolee-Swift-SF316-51.. ([49.142.96.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23de43227acsm65559485ad.124.2025.07.12.06.55.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Jul 2025 06:55:20 -0700 (PDT)
From: daeroro <skseofh@gmail.com>
X-Google-Original-From: daeroro <skseofh@naver.com>
To: will@kernel.org
Cc: alexandru.elisei@arm.com,
	james.morse@arm.com,
	kernel-team@android.com,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	maz@kernel.org,
	oliver.upton@linux.dev,
	qperret@google.com,
	sebastianene@google.com,
	sudeep.holla@arm.com,
	suzuki.poulose@arm.com,
	tabba@google.com
Subject: [QUESTION] KVM: arm64: Handle FFA_MEM_LEND calls from the host
Date: Sat, 12 Jul 2025 22:55:13 +0900
Message-Id: <20250712135513.608609-1-skseofh@naver.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230523101828.7328-9-will@kernel.org>
References: <20230523101828.7328-9-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> Handle FFA_MEM_LEND calls from the host by treating them identically to
> FFA_MEM_SHARE calls for the purposes of the host stage-2 page-table, but
> forwarding on the original request to EL3.

Hello Will,
I have a question about your patch.

Does treating FFA_MEM_LEND as identical to FFA_MEM_SHARE imply that the host
can still access the memory even after it has been 'lent'?
