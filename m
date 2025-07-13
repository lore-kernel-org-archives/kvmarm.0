Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C67E1F16B
	for <kvmarm@lists.linux.dev>; Sun, 13 Jul 2025 15:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752418809; cv=none; b=jYNxbfjKWqJArnwFD83qXM/9iQZQZ7CQ+Su9AJWW9mD7KEDhd4GXiipvdmjMoQUHKFdIPPDYwlSMAGOaIn8MP/vp1HifgHv5zG1gKQiOiup4Wdw4sfqBjpz/sNOedM1L68ubVnoTSZHeYEbUam1e4MXOwqYEadRw564jyszfE1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752418809; c=relaxed/simple;
	bh=6a9yrPbT98SJf2gUsRP2F+tGBN2Uf7TW2JAcn+ZqUYM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dvSOtZkpaKAT5gNg4Nd4MTq6jSu79+sGBvEkMG4jd0EigRHRr7qsAFzboJvt5lzWOikccxrs56XVF1H+DD0t3bpGJhZGKqPTo4hcoqGH5P3m7BL/XQu3V6/UftvnCDIcHZEE5RLClaCuOauQRs+1NSDm48niDDR/3f6b3q33cxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CnP3I5vz; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CnP3I5vz"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-748fe69a7baso2895929b3a.3
        for <kvmarm@lists.linux.dev>; Sun, 13 Jul 2025 08:00:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752418808; x=1753023608; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/dv5EhjifjcDzCNkO87ZY3qnAuLmZGZmKdrNsDLf9+s=;
        b=CnP3I5vz9HKLq8M/nUJFPE8Hw+6LhsyexJP2irO822Vq+htmwpqlC3I7Q5FYboLuhS
         Byp/8BE1JPrfaeOzzNZILhLhQnI8+d68j9+Xfdvm702wQy1ZbopX2pCQJsgsNDfYz/N+
         FMm/JMYtuFGa++8Cw4hO/CzBkdb1kPpzJCNhIpgRLTXvHATjBbWgI8c4gPKWiupkk3zg
         zUW/WuiOrHqY39Q/0mo6ThiDmnYFCYEc52Haaec9vHXIlCD5TXAjg3fcv//KLNN0WCkN
         BrytfBMsLrv4k67sLtvfclRiEynvQUyIJzsKPF6nzyecFkNVpsida2BZ1EPCd/FodbBm
         CO9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752418808; x=1753023608;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/dv5EhjifjcDzCNkO87ZY3qnAuLmZGZmKdrNsDLf9+s=;
        b=pTFV8m2MwfqqmF2pG7nE0uqEW8f3rdWrQaa9RyU6mPpDUgruaBgew8pw7L6Co/DENP
         xpTNFQlTkSbes5Ijy2TaZMCtxgdSr64ChOzz8SlwaYNgb9xQ4SVY9D2rLf8ZwFiBTGAn
         IiBpCnI28f7NvhjbMjQkim6yiA/Pou4cnNEdLDvZsGLesRud1HBrMh/JnjHR12k+1F5C
         9zEow/sVhb0nCD7IpGSlb6yIVpet4j7xbZaIh4HflyUBa1S3UJUYYWFCIeGRiWPofRHp
         l0p4KYyjJSPcxLDCO3lLj+cx/Q2WrFNKIjNu7tU9UWHDYR3mJeYLv6874l09kJhVUFxh
         aZHg==
X-Forwarded-Encrypted: i=1; AJvYcCWYOpJ2oULu2Q9TGLaMEN/t1Nv3iMDpYVFuBIb7DT4v1iRTCX71eA7ZSNsdEclIVaQ4y7cWeDg=@lists.linux.dev
X-Gm-Message-State: AOJu0YyfFATfRUCzrlPv3OJ3qxDWSAIIidcbhHn9a0zp7DMVziPu2H4u
	BR/zvgTgLjOI/vQilLTcbFAyTDqrtZxbJf9b/6RS8tmnE57BfDT9I7yj
X-Gm-Gg: ASbGnctqkjGida7Lew0v4yYdBYUsku0bzIZ5kHx3c9DzzdBBPcP5kbh6MWWkJSO53Cz
	eWTmyzhli/MBW4Oe4TQJobPNDAJ0F8O6q5jquD3mUHWM7T3yjzDBkbsykd9uzwgCQamws6kGHUJ
	L9GUXx4KLzH/VIbCYxgcXPxxisXlQwUgz2t96aDefWz6Uk7QzRDdCbrj0uVf1iSgRVOj02pvkqE
	jF5tRgLTqQAyPQ6gKH9AwqsnkJlW99xU8nKX0GZADRr8ZP5hoG3zvjM+1Zbwtxa/agq9uPTh3ok
	SEE6oXumclPQagKxp1/0ugTaDh0zYBDfq3EV9aJGlJqz+FiO6IUOrHWkEI6dUy7Eo8e8/9Y06Lq
	LoB5N7dnSS6VACWCDAMFCeP83Rcgagwms4jYZ
X-Google-Smtp-Source: AGHT+IFC6klH+DUaMNBobnXfYHSVyx0IO6xBlZQmjyeAecZZVdEr8LbAxJeI6zh63pFNGLXODs6Nxw==
X-Received: by 2002:a05:6a00:ad5:b0:746:31d1:f7d0 with SMTP id d2e1a72fcca58-74ee148c825mr13183813b3a.9.1752418807472;
        Sun, 13 Jul 2025 08:00:07 -0700 (PDT)
Received: from daerolee-Swift-SF316-51.. ([49.142.96.162])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74eb9f1b6fbsm8650669b3a.84.2025.07.13.08.00.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Jul 2025 08:00:06 -0700 (PDT)
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
Date: Sun, 13 Jul 2025 23:59:57 +0900
Message-Id: <20250713145957.623842-1-skseofh@naver.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <aHOXzUvGaQ1Bz3jG@willie-the-truck>
References: <aHOXzUvGaQ1Bz3jG@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> > > Handle FFA_MEM_LEND calls from the host by treating them identically to
> > > FFA_MEM_SHARE calls for the purposes of the host stage-2 page-table, but
> > > forwarding on the original request to EL3.
> > 
> > I have a question about your patch.
> > Does treating FFA_MEM_LEND as identical to FFA_MEM_SHARE imply that
> > the host can still access the memory even after it has been lent?
>
> Only if your TZ implementation is broken and relies on the NS hypervisor
> for isolation.

I believe pKVM is managing stage 2 isolation between Host and Non-secure Guest
VMs or between Non-secure Guest VMs

<Quote DEN0140_FF-A_Memory Management Protocol>
2.2.1.2 Relayer responsibilities
10. Unmap the memory region from the translation regime of the Lender, if
managed by the Relayer as specified in 1.2 Address translation regimes. This 
must be done only if the memory region is in the Owner-EA state. This includes
removing access to the memory region from any DMA capable devices assigned to 
the Lender.

From the content, it seems that when performing a Lend operation, it's
necessary to perform a Stage 2 unmap of the host memory area. Am I understanding
this correctly?
