Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6DD11459F6
	for <kvmarm@lists.linux.dev>; Tue,  7 Jan 2025 08:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736237346; cv=none; b=VhwYV5g9a4ybF4xqElxRiOSoIB9HQCEVwoq4JrtMDg+XS9t+Iufq8B1F69LiuzThIjGQqeSGg8EO0RL29VRWVMGjYUcTcgNuwqjuAQW9i6um1i7+BAEkX5Rqf3rlSTdHJFluZqw1glLY4WWWBvWJqfmdvpCV45vUotxWo7muwH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736237346; c=relaxed/simple;
	bh=yOHRyBJRfgO+UdwG9qqSG3QsQJye+Ouz7Yw38baSXIo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=L54TF+7XjzranCXHs7dL3ZMPjyQu5fJhqEmj+81zbtTLxrbV+IqUcQNVh5XcgcEpWt2tI9BSGXCfu/5fY7vhueSXbMj5TrlkI7mOLs7vDiKsJacXDtJCWJSgZbnw0zXCDJequKa+NXW/xOrByM0YQmYRYCeM6iA7prEo6r+txxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=avG5zNDZ; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="avG5zNDZ"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-43621d2dd4cso34435e9.0
        for <kvmarm@lists.linux.dev>; Tue, 07 Jan 2025 00:09:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736237341; x=1736842141; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=yOHRyBJRfgO+UdwG9qqSG3QsQJye+Ouz7Yw38baSXIo=;
        b=avG5zNDZJDv9MAnztQEJV+CTNCeH8iuXrFwYHr/v6QNfbv47kp9v/qZ66sj8JfA1kU
         wVgOlyphJDmEgxhI0qd9Ik0kD7+BkofuVvMQjdkpEPEKr+RaKy5A1/tsR/WnFjr7x1vn
         7qU6wwbWSwcR3roufDbHZ2P60176OvoXoXSUNBc4KesIlUSQiJD8+/2jZFv3/GwV5X7R
         6X0x1PypvSdRh8vfsunMn5AV5bc1kAwWiXCIwS9W0v4WO92tFij8wqTo/Gt+ooyznwps
         5a9n/1hPqACXhcSI1fZLRvr/tpz5us82PG2pC8w5tKLy9zhL3eQ7CY48MeNC5voOy0vA
         CTuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736237341; x=1736842141;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yOHRyBJRfgO+UdwG9qqSG3QsQJye+Ouz7Yw38baSXIo=;
        b=Rwz5cX1p2QQRqQ1vhAUTNGjBCdT/m1xq4qCITQe2G75fiQd6yHojLeIxkPIPkPM0JT
         ka/JACnkfznoc1AMmEikU0WKQ0MQhe4CJMv3n3X5Xt+6SRow5/AQCsAIFYsPlx/+lO6V
         NWGLP8fPT5Ul7ob0NqpX4m4pkJBFJ214EgfgFBPI9Jf+I3cHEgX4yvjNCUf3E959AP1A
         UJFWBip2JPGzIEbUxSlD0bvmRnNOw6DnKWhjS9j5KvF6fxA9P2G0OmyI03rGU83h2lkC
         QQ+CNlp62x3M9Oy2Rfz/IDJjvwZHI1nPSqI8Ox+xkYcu83DRcstgE3dJUsOFynAYCxWF
         lwtw==
X-Forwarded-Encrypted: i=1; AJvYcCU2krBE8yAcOn0o82aUBbq/lqYVEq+pcwvyWdcKTWSmZH+XYVm5BWsEMAqKN1EdB6MFkuUDZp0=@lists.linux.dev
X-Gm-Message-State: AOJu0YzDcK2MDuAbnd3hWrdI5ev3eoKJM1MG/ptjRVjPmG9QoyZZXm50
	/BcBV8FAbICDhPrYKRKNtSJwQ0NGYndBQ0yehMEbVW3WUWR0NtdMpCkklo97XF74Mvuo88l/rji
	pxxbz4AA5iY49uDcuyqS+b6gCfTa5v9+AnTTl1TXrF3AT+9RdVw==
X-Gm-Gg: ASbGncu89NEpjSE+C3ViD7birWf2d2a5rOyN6PMFlVtU+Ip3Y0JpV82+Pi6XQ1m8MH9
	h5529Zf8942JJE7SovpT4bjQ4JnFg5/GJbur3
X-Google-Smtp-Source: AGHT+IG6sKjVkdAPbWRi0eBjsN0N4vsF0Xv5s6djDqqe2n1NqGS6WUZvQubcputkI1kunVXe6PbPG5yqyRoh2Fn716s=
X-Received: by 2002:a05:600c:138a:b0:436:1868:b29f with SMTP id
 5b1f17b1804b1-436dca07978mr824305e9.6.1736237340942; Tue, 07 Jan 2025
 00:09:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250106112329.64013-1-vladimir.murzin@arm.com> <Z3xlT51luMieOAab@linux.dev>
In-Reply-To: <Z3xlT51luMieOAab@linux.dev>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 7 Jan 2025 08:08:24 +0000
Message-ID: <CA+EHjTwraTsHmLRbyYV1-u-FQ8dqFPL1E5z2DFOe4yFUbQYXQQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: Fix FEAT_MOPS in pKVM
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Vladimir Murzin <vladimir.murzin@arm.com>, kvmarm@lists.linux.dev, maz@kernel.org, 
	joey.gouly@arm.com
Content-Type: text/plain; charset="UTF-8"

On Mon, 6 Jan 2025 at 23:20, Oliver Upton <oliver.upton@linux.dev> wrote:
>
> +cc Fuad
>
> On Mon, Jan 06, 2025 at 11:23:29AM +0000, Vladimir Murzin wrote:
> > Flush HCRX_EL2 when switching between the host and the guests.
> >
> > Fixes: 84de212d739e ("KVM: arm64: Make FEAT_MOPS UNDEF if not advertised to the guest")
> > Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
>
> We shouldn't be trusting the host's hcrx_el2 in this case and should
> instead calculate it for the pVM similar to the other trap registers
> (see pkvm_vcpu_init_traps() and friends).
>
> It is apparent, though, that we erroneously exposed MOPS before commit
> 3d7ff00700d1 ("KVM: arm64: Rework specifying restricted features for protected VMs").

Yeah, actually FEAT_MOPS needs a bit more work for it to work with
pKVM. I have patches (downstream, Android) that add MOPS support for
pKVM. If there's interest I can post them now, but since protected VMs
aren't completely done upstream I thought I'd wait a bit.

Cheers,
/fuad

>
> --
> Thanks,
> Oliver
