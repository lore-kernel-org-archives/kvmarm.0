Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 242A017B50A
	for <kvmarm@lists.linux.dev>; Mon, 14 Jul 2025 02:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752459251; cv=none; b=l2jyGQ/ghb7/C7qeOYQ4tFUXEDJ+JY2teiL5LPxs9/8ZQs9ycNRXoM15QOjItNQyiaiZWpQpF+3ikhU7qWJNo//swIG1+Oy2Z8Vkwvpqbir7UXVA73s9X8muXQxTyFG+HLBbh2Xfkx5bYo5+YTsqccdP+ivjg5oPq+X8khhkqE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752459251; c=relaxed/simple;
	bh=f28NzlPclTUQrm9z8qWDo9K5sejEm68bwyiiU26NRcs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TfBEgkVaa0m0lMNqGCkXRHZ2EvcY54a2HrnA2UDgP+VVCccULDZEl4nUT/7zTS6KddDmbhXxg/92kbfE/deuvpAejIWOIh+NCXo+SeRU53rMAs41m27CIQqg9l+Q5TY5GzWkb2sOL9a4kOAUYAdskMS9mMSz3JXI5sFXfiZfkqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WIbsT2Pm; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WIbsT2Pm"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-237e6963f63so21067665ad.2
        for <kvmarm@lists.linux.dev>; Sun, 13 Jul 2025 19:14:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752459249; x=1753064049; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f28NzlPclTUQrm9z8qWDo9K5sejEm68bwyiiU26NRcs=;
        b=WIbsT2Pmrzv+9uaMh66AF6LTmk4r/btyiClTuiWK44MsvB8tDMt+6M1w2mhdpZEYY6
         OujNjNagGTA1P7Rhxgda8chF7gWornzfK1AxwbaNScdvsBRZ6Pjn6VN2rpaliP4MZthN
         fUoyTxPXGCU3P+KkRiGlsP0P4jjqn0uMkmJSC/noPc9Qxb80q/59RynFifKZUNmcYbLt
         r5Y5USTqufKlLCQsThj51ySknazizpbwpdkS3hjc4e/1Wsj/LLmy0sdxju2SLV1a0eYg
         3/8pyfHBDKOU3nPWTgjeyG1vdq3HGSpuDNcwOt0u2ZOLXxomlVPs5uV3IOFhLCPEWcNg
         7cEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752459249; x=1753064049;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=f28NzlPclTUQrm9z8qWDo9K5sejEm68bwyiiU26NRcs=;
        b=kWkMCGYNig8JynzEEQJJKgTLBEDqlNfQtJJllsorUZmduZPdQcfwBMS4zacq08736W
         BuNiIrFb+Upehso4jYJeyOPAKwb6nePRU3VPPkNQGlkTp4UcbY67O6NJOnq8GRGSGt18
         WRrZbqqFlcb7XsRTbpNdN6gxOIh4B536gYBpNYNBAKJ9yQELmTkup3d2hjgdBid/EpDt
         zz7qwlLbyoSuOxYrh/grTBRwQdcIpDSTpdTkoyfCC3stezop72tVsvBa1HW5NLHpb3md
         730B9RhR/b3J1qu6HyIUjuw/kwNBAS3635DNHPULP2MyTPVgaZ+pMOirxhajIAyodKvF
         QJqA==
X-Forwarded-Encrypted: i=1; AJvYcCVS0CIlStyQp+h0dzAZPuENc2NTMYj2mUGLHDVq1fwORbW0wpkVaWIH7SchLGkTDjU6T6/abYw=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy/9TWBoEu+zjbBriDTyjqVogVJAyzTsYRM/+v6qfbwe3t3+NZI
	qNCGkYJKfxovD7Elo1FuecqH5iyzVKbEdkvxiiAGAsVFRaeTZ0wfyPNn
X-Gm-Gg: ASbGncse59WvnEcMITqm29pvP6N4G5glXdqF5XpfslqtvysJmXi+bLn5gJwzsLWEkqV
	L8Z11rQFz31TDTs9s9aHLNF7pLmiPl6wUsnr/bsWU7K1HqjlnJj+0ygjF/GFK3wyPQMh+IKJXVh
	SgComc/8GqfpVs5ACJ4L/mDvgBTsdab6KeQld74w1ZN2iDYZhc48kXW1AcmkS3kNM0fKQLXtUdb
	1nw/SZvUOfBYCpkmKlIr7cwuFGz9P5MnmvhhkqtB0aNNoIQydJFeFKditeXX0z3Elx3rs9shQyL
	6U8tmEJ8mYz2DDm6FmE2SZZm6T7iU8JInC73jgEE08V53qlrRJwzdaKvQP4+4jEJUOutF422aY5
	sNirOiFpTFNqQwJ7d54LyfuACOpVcyvZzCJsJYsTwPz4jZ4k=
X-Google-Smtp-Source: AGHT+IECqiDZzuBM1Py+ovvAtJ/BufPA/xN2pM0u0YOxFUEFZUGGbSxMQOZDROS/ufqDSQZ0lprfhg==
X-Received: by 2002:a17:902:d58c:b0:235:f298:cbb3 with SMTP id d9443c01a7336-23dee1e84c4mr160698155ad.18.1752459249241;
        Sun, 13 Jul 2025 19:14:09 -0700 (PDT)
Received: from daerolee-Swift-SF316-51.. ([49.142.96.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23de4345e6bsm81331175ad.192.2025.07.13.19.14.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Jul 2025 19:14:08 -0700 (PDT)
From: DaeRo Lee <skseofh@gmail.com>
X-Google-Original-From: DaeRo Lee <skseofh@naver.com>
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
	skseofh@gmail.com,
	sudeep.holla@arm.com,
	suzuki.poulose@arm.com,
	tabba@google.com
Subject: Re: [PATCH v3 08/10] KVM: arm64: Handle FFA_MEM_LEND calls from the host
Date: Mon, 14 Jul 2025 11:14:00 +0900
Message-Id: <20250714021400.631762-1-skseofh@naver.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <aHQQiJr2xLe9KotP@willie-the-truck>
References: <aHQQiJr2xLe9KotP@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Is it pKVM's policy to not manage Non-secure memory using FF-A, while the FF-A
specification supports memory management between Host/Guest within Non-secure
hypervisors?

Then, how does someone lend memory to a Guest from the Host/Guest via FF-A? Can
pKVM prevent this? Or should Host/Guest developers use it with caution?
