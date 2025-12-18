Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F165627A92D
	for <kvmarm@lists.linux.dev>; Thu, 18 Dec 2025 19:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766086308; cv=none; b=RkINEWHuSYSC2kNP4COxZ1o4ZQJP0Woq8vohdzU8E4nT8k4UlNwTXoB3DBSsVSG5ESthFl4d5MNRPuKQ4Az4T+xZbRLmjhvSB4UgPPI3OBwJrgRkTqzLXQlsjusoIC5KT1KwgAPTlGI7mfSQTPdl+yOUBzsag8OI4O3SS5t/dLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766086308; c=relaxed/simple;
	bh=HSjfEZ6MAtUrQ3sgRd2td3b93U9ZXVjY9ZLoRlP3/pw=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=LP6EfAQAKWFw32cKRlni4P6asLIRPib8ubLWNP6er9PEy3emte1YzsFRceGVDgZCxjB5/UWpRxH9G6t4ZZ3XsTtfpE3ZBTEGMYwBD8NeNYpQI86ji30blxX5hfk3gykyWb47HFXZp3TSWqHi3bdlci9ibAhrwvJDsicxHK62uEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cqmwR2PM; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cqmwR2PM"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-7e1651ae0d5so842148b3a.1
        for <kvmarm@lists.linux.dev>; Thu, 18 Dec 2025 11:31:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766086304; x=1766691104; darn=lists.linux.dev;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=HSjfEZ6MAtUrQ3sgRd2td3b93U9ZXVjY9ZLoRlP3/pw=;
        b=cqmwR2PMpaFlHF7evrtwY99gSQzYov01GRKOdTitu1Hxx6TeSzDvvdY7MJCX1Wo3Dn
         O4+6Bx1w2RJ0arkdyLXb6LnDnW34R9pBug/c6+ZtNTrTGW6pNa5couw7EFB4vwfUA8Mq
         JtWbDpjDlh1DssbdTFsA3+uLZ8DWy1Js42qBzkSahtmTTDYL5qFknoS7FoRuCnwGxmxb
         65SrnnEDTo9RZJbFe6t46xcHmcOxLRCZmY+hHJ0K7n5lWddYd/LL9WVv9/YNjgzoxW8p
         IBjDZLxmf5xR3XxwXJSllae+PMXvY3P/NviQtOZ2jrOEQHrIZYh2oocZjC8qAins2r6L
         C6cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766086304; x=1766691104;
        h=to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HSjfEZ6MAtUrQ3sgRd2td3b93U9ZXVjY9ZLoRlP3/pw=;
        b=Fw4rkk6ZVjw8Sq2Yhs/7gUMdVzoT8B5C5tph+VhkS7bTUHt8Cddzq/Nf21rcgES/Er
         2VQD3xLLLxb5z1gQ1jhxKrybC1BEbzxWzYiwuSausmDpXz2skzu0G6+I0ZQObxxbQoQE
         uSrq41vmO+DMy1rOryDaZc+7NzjwQqFeCzkKg6O7qll+lLyKmQFGrbWIrBaxts1T1cR5
         Zhi+BbtqpdclNLJD7wT3x8if4B2/IpdAsvXo+XrhCZGZv5M68k27E1jJETf3T4A/bTG8
         fAzGK5vqptm2rF/QYREQF40y6DejFiplsoRx+7IDeFH+lNL6KQGnsIOZuZEEgzrdaaBL
         xBNw==
X-Gm-Message-State: AOJu0Yw4A5z8BmPyGxALi3vZ1ToqgM0nrO6k4lVROScM/LrKyV/jNhuZ
	xWukEGcdoUYnwe+c/HnnDqhnzZ5IfKM9K87/AbLNd/cwObIlKiYNP/Luf9nLqJ0CLce/S9yxJRl
	yMtJwxb8ggYrE1ZKd+bVzluVuxOZuQuMnzjeb
X-Gm-Gg: AY/fxX4ISjQb7osz+dtJ7Aghd1X4xdlcDbIFRo3mMlQx/78eqNRz+dP8/rOtYDRbHQE
	p1WOcaGC/b5GRITxNz1t/pLqNSVeSE7qgvagkq09eIIdG4jSvzFoo+kD5MJfLsMSsdHITEYp2Bu
	H5YmJ9MiiD4PUM2f1qyoVGwB+wkSpCqEYJJXEZfsPV/yzPiNrpySFyACKum26/F0r3PkX1ynHuh
	froPi8K+m7dq09yRCxoqruNCeiTVtkbIug6fyJziORDfkg+O/S2fkMg27z/CGvboaqOOs4=
X-Google-Smtp-Source: AGHT+IHA69h3WEqevl7AVpff2ELJ8oimxTYQj1VO1ZhE6Ce7tt4qQGxK5xjPa5F9iZGvSm4Vk/TQ7qGVfR7nPuf1w5Y=
X-Received: by 2002:a05:6a20:939f:b0:366:1fea:9b54 with SMTP id
 adf61e73a8af0-376a96b9a4fmr476820637.39.1766086304428; Thu, 18 Dec 2025
 11:31:44 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
From: TotallyMonke <trontanner@gmail.com>
Date: Thu, 18 Dec 2025 13:31:33 -0600
X-Gm-Features: AQt7F2pEHjiNhlcK9BqwuNp0HMKGDD4kQFl5ldPKpvucVpc8ysWGbt4JvcTrm2c
Message-ID: <CA+n6O0DKgC3RqfxQPAo7RgmP73uxO0Hys84tSCRrs3V5e1UU4g@mail.gmail.com>
Subject: hello
To: kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

im just checking this place out because i like arm and this is
supposed to have something about arm
