Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C770B221F10
	for <kvmarm@lists.linux.dev>; Sat, 12 Jul 2025 13:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752327400; cv=none; b=jLEI2viRZ6QjDnvg97qWO7knubLxifeTED+iyRLjdrY0VXU/xZ8vOriQvxvOOxwi4bTWnKqkyT3QwqCv/qdxthdm2fJ4OcQozfL2pMnafTf7JMeo4Z2B5mhv7ELi99DwYZEjQD45d6nR5L4aQ0gGUKrI+Tqkq6mXy4rx1UtpX20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752327400; c=relaxed/simple;
	bh=YOndc6H20zxrD83nlreI1JYXNtXysRHFHOmt4DK1lus=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=sTeGmY5TDxMGDnNae5M5epOuJ5NrW9pT/8qUZPAXXj5Cy5BTpq6Am5cy1ROcBVu86veHMoDTe4B3ZBFjZsI2iUcnVqu4nqriSHBZSxvmWynP4u4X4Qzb3oqod94PPqOWw/9rlfudEUKHsR6CIAz4M9Ft/yXQdWc6Gr+OKYewvuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DBLeBaUK; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DBLeBaUK"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-60bf5a08729so5384348a12.0
        for <kvmarm@lists.linux.dev>; Sat, 12 Jul 2025 06:36:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752327397; x=1752932197; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=YOndc6H20zxrD83nlreI1JYXNtXysRHFHOmt4DK1lus=;
        b=DBLeBaUK+7PUATLTVAZXU+d4oRa/v2ewNZjjK/MTYCNkF4m3rsPje5sjilxOGfelX1
         EoW8wugrAsBlNB67Ah6Cm+ZEWz0TKap2W+9/YwEUsi6VpzkO2G6GiyRmvjcZ+7XFHqXl
         3cp0c5Wp3oI6XCS7TER6Zrfo55bgp7GFigBbjgpAK+c6wyftaWM9g70CZtzioEgw6YMK
         hOg1mnnDjkChl30YCAxcZXGpLeO84Umk3TJOdV/pyhfcx9LX26MB7JReLh2qBPqPQupw
         kuREW13G8GCuLpVKyj9E/B2+nyZ6rq+Qtqu34RRPlrIXhDtxzmu4kVUdea8ygW44LcfG
         o2lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752327397; x=1752932197;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YOndc6H20zxrD83nlreI1JYXNtXysRHFHOmt4DK1lus=;
        b=DmOg1UZdltCzOIa6HTQPsMFjVMjV0BbC6M8j2yUPbMK8TfcS8aYrEJteaUjuTynQNf
         jOs8wYaiFfu/Pgmnu4M2OlBVsirZ5F2VbpK023M3QiloxNQdhofwz4fMrqmYY1gH35oa
         qub9XiB0NjsTfcCVbWsci1dsGVgFGeOx9OQWdkWk7rwzAVRILaD6yjjTle+9tQBon22O
         wLZvcIIKf88HsXQEsanQtvHHNqtVOyO652zFR9qoH7eEVEotREqNZsWYTga49I7cAK8M
         bV783oBI4Wb3uBgJQlpsXHcHvZrS7zwI5sPwAPVVZ9qa5tC23ArmSbOMtfr7wbmK1Ci7
         2bjQ==
X-Forwarded-Encrypted: i=1; AJvYcCX29CLtwXS84vl02uRtmJ4ndd9eVzY00/I5W6laeuW8J+sAfoBVLGvd2ihSSnIyj9glR5qBras=@lists.linux.dev
X-Gm-Message-State: AOJu0YynMWphMIGKkWXLD5sv0os/vWFWXpm4+t4P3dhm2E+rbXIcWuxR
	WtKTNrzLXDoSfV1T3apKfbdi1Gtdps5ymVl+SzdV52yscyEEdM8kRtMCwtUQrlXTk8A67r6Z+Wz
	QLjlYFXR4myI8FRZxLKLznGUTEuUohJU=
X-Gm-Gg: ASbGncsPKHztHH45HJs7XIBU6TJEdxFYcfD0a2JxJdY/kVi0bA1LJlxaWjFLk92A+P5
	1wdP+26V/ofXU84F+QfUrBSWsZQWa6gY6Lnb7e8OYB/x9hJsKa4TJ4gRwJ71KJVvFxZceoIFZWf
	ociskjypYqao01WvFqZdbutNIeJtq15JooEEV7U8m1d39uLiThCP8nT6LBecjgDLBJQS2stIhYK
	qrmqzo=
X-Google-Smtp-Source: AGHT+IEYYVDKFxeAmqYv/dICV+GSZ7NGwda3BVuEnt5qwx1dGs/ArLr/yc+9i00C+YaXs5Wgw2E53bDwXUiXusMMIMY=
X-Received: by 2002:a17:906:4fca:b0:adf:f82f:fe0a with SMTP id
 a640c23a62f3a-ae6fca48ec3mr847213666b.16.1752327396767; Sat, 12 Jul 2025
 06:36:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
From: DaeRo Lee <skseofh@gmail.com>
Date: Sat, 12 Jul 2025 22:36:24 +0900
X-Gm-Features: Ac12FXw0aLWNnHyHALX6gaR9lKxOPPuPtN0qv8Vl0yjKm2nmq9nN-7vEBGiChn0
Message-ID: <CAATEi5=y6w3jziwKbrnUkWGy=RTGh=+jKdrXEnOdAiEcH=npOQ@mail.gmail.com>
Subject: Re: [PATCH v3 08/10] KVM: arm64: Handle FFA_MEM_LEND calls from the host
To: will@kernel.org
Cc: alexandru.elisei@arm.com, james.morse@arm.com, kernel-team@android.com, 
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, maz@kernel.org, 
	oliver.upton@linux.dev, qperret@google.com, sebastianene@google.com, 
	sudeep.holla@arm.com, suzuki.poulose@arm.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

> Handle FFA_MEM_LEND calls from the host by treating them identically to
> FFA_MEM_SHARE calls for the purposes of the host stage-2 page-table, but
> forwarding on the original request to EL3.

Hi, Will.

I have a question about your patch.
Does treating FFA_MEM_LEND as identical to FFA_MEM_SHARE imply that
the host can still access the memory even after it has been lent?
