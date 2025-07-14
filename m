Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 684FE41C72
	for <kvmarm@lists.linux.dev>; Mon, 14 Jul 2025 01:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752457772; cv=none; b=Wb22dymfKUriejFLRLiln6uIB6sD7Ax+8sDlyIM78ig+bv/QM1XwaQuqh9cknSuhFZr54k/IDIWPlmFk6+MfygXBeyfrAPTGlfcYopwqR1hH1b5ic3PgUMPJ0lJItM7DXs9QGVQXcWekx39ZOkg7OzJxuF+ARXVrGFff0/3sL8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752457772; c=relaxed/simple;
	bh=f28NzlPclTUQrm9z8qWDo9K5sejEm68bwyiiU26NRcs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=h6J5dP0nJDXH+hi7JldD++K1Box/yARXSFNt6Ll2DERZKCQBL93YTbszopZ37lvWxd1AyKihKhGKybQ757vOLLU3BWar5gnFXxl+KafGD+qhnFRXSh/D+CyJztjpDUJAj50/aOtUE771CZM/rExk1BYFFjtZ0LeMXAJ6NBEVLsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ma6AafZb; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ma6AafZb"
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-b31e0ead80eso2897069a12.0
        for <kvmarm@lists.linux.dev>; Sun, 13 Jul 2025 18:49:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752457771; x=1753062571; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f28NzlPclTUQrm9z8qWDo9K5sejEm68bwyiiU26NRcs=;
        b=Ma6AafZbEWhzX1J13vzSSHnD8nVxfXnZAV63LVKV8L9bdJ1OerKLK0aTKPCPr5bImq
         oIKY8TMwxarhyFLHSGJtx/QW7f6ZktyBiAwx3VBIIA5zcBbO74JYJmL2rdAG3L+0kis0
         T3Uw99LBqtMaBQO9FnmIrlPy+1VDesJ8aofRSZUcIo1IkKdHR5AkYv/O+aTxt4d0bA6T
         Os7U+L96ntjLD/im6GIQQJhq9EzEI/IQaaQnXV/QIA8Pf7YuCAGauDfaH2HKzSacuIrs
         SPip+qePZX3WRmYdsjzdgP/8T0HyRCRtYUX2dk5Pzpiob4ZWdXKXWk7HHx6eCchtlD6p
         DEkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752457771; x=1753062571;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=f28NzlPclTUQrm9z8qWDo9K5sejEm68bwyiiU26NRcs=;
        b=YIQgzLPs5TQczkkEuMS6e9QQzCDGA9LMpVJ92944NW3x3treGOlgPlyHC9inHpClP1
         mZgCGxRmXOFOE1PeU4CBO+R1FE339lsvZMd4LkKU01a0OBttpL5XPf+6SIEY2Q/E47Nv
         Zd20wPFdgpJpP/RsGn7snkOTGiqosDKI8uEhli1sM2dI4TunpTdMOCOjf3bcDDiWptZc
         xmn31JOnWn+dN+6jWvSuooDQH856N81IK7qxXWrWr9+1kI6Vw0RdiQd/T9m0oq6Thack
         VP+G3SE52eq6LGfc/M/QasvLcs97Qxt+a/eWYgdvvt6cPsE9WW5rMnkefbefY6f1dt+0
         4xrg==
X-Forwarded-Encrypted: i=1; AJvYcCVsk7dgFRcX51+XvE9b6P2gJePU5zoa4JjTCFyC4iavkj03OOqXOTTkNWzhQqs97Z9vGYf7QNE=@lists.linux.dev
X-Gm-Message-State: AOJu0YwqPrR5mbv/R4G/xfB4ugaK1CRJpryvwaNepSlCia2OfzWXtjKj
	qSw9xix2wZ/zKZvCnDOmufmz+DJnS8DPBAIg8DMBqIxOpXMuOOsnDddY
X-Gm-Gg: ASbGncudygAbfnJAuqbVPexJiML29PmeylfKdUsNTof7e05qgEJd7pw5QBBv1/lT1Kb
	v14yCzhoaoDw0mU+bu4UjcOU2pfNKlTKZgHwzfNJAzB479sfX1aCNLwhG1xiao55kxf32PFzJRd
	d0WRbpZWNzwM2YPV1SoivGTbi3LDvCHEjbfA868zwtD8G6DLdU8JW9X7enRcbsk50p8G0k8r59f
	A9BtL9ZdlyMrslWwSefd5iPo1TVcR47P/InKCNAiK+3zd57DT6qx+HiPas+LYGrZWSH+qDl+1MM
	1Xq2/3pB3FCKHePBg5ooBz9fjUk7MwIRSpVRkFQD91aBOy1WdfxLeXZjO0Yw0sNDcngqnDgd7+k
	vAo8NY2c+ZCL0qorrSNiQsn6LMjQ8hCtkj56w
X-Google-Smtp-Source: AGHT+IHAMVWJ1KHm6k5TxxbRXzqXkJA2F6PqS1WMTG6K5vCCF+qJ3iHYsumiXDEgPzlsNAggJSgYLA==
X-Received: by 2002:a17:90b:5868:b0:312:29e:9ed5 with SMTP id 98e67ed59e1d1-31c4cd9c12cmr16262763a91.23.1752457770526;
        Sun, 13 Jul 2025 18:49:30 -0700 (PDT)
Received: from daerolee-Swift-SF316-51.. ([49.142.96.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-31c3eb7e362sm9289765a91.44.2025.07.13.18.49.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Jul 2025 18:49:29 -0700 (PDT)
From: DaeRo Lee <skseofh@gmail.com>
X-Google-Original-From: DaeRo Lee <skseofh@naver.com>
To: will@kernel.org
Cc: alexandru.elisei@arm.com,
	=james.morse@arm.com,
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
Date: Mon, 14 Jul 2025 10:49:22 +0900
Message-Id: <20250714014922.631551-1-skseofh@naver.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <aHQQiJr2xLe9KotP@while-the-truck>
References: <aHQQiJr2xLe9KotP@while-the-truck>
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
