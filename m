Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17B5C1CD21C
	for <kvmarm@lists.linux.dev>; Thu,  6 Feb 2025 20:08:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738872496; cv=none; b=VZm1oXxOeEMEi2eqPHmT/Po1FokFaxuZYJMygraYHlGnSXNmFLEChOJzcUS65ZnA1QW4tCQaysUunEiQgjQGmlzH9EGHQSdoGu9HwAfKPiFHbyu98Iwv3GdZXpHVKd8OllS6+x2UpdRsG/TcB5TJeajUTKTCg5NdQNT3ftKa43s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738872496; c=relaxed/simple;
	bh=+dkpAnbdjh0dgrGIHhIPBxApKDschrnxYPtbm5oWAqc=;
	h=Message-ID:Subject:From:To:Cc:Date:MIME-Version:Content-Type; b=mfdBseFRl5DYQYnokP1+Ce81QBvfLqlKFfjp/GwKt3GYDre2SmEl0Tj+phdYh9EZ3WmOYpqQ4L8hCBE7bWymQ+AMX7F1jo7uHYKf49/Au3etl4I+QPfAmzVlZMf8xxl6niPZVxoaa2sH+FKLZ3ybeWUSQaNTA4mTBM4vi32c728=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aU8vrraf; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aU8vrraf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738872494;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=lMTAS8pZ+dV5XxQmV6jHa6Bjt73X5ogir1Fm2eB6TvE=;
	b=aU8vrrafKNz90Yoo2sZi4Jty+klTp0FfsoIN/93Y0P9HF1M4YeTWpjHENnipAcElKVjD0w
	FGtk7Zs2RIHvswBkS9EHwk9s+JG6y0a9AimT1x19GCFSeSnHb5Y4EFwIuR4SATZV/azjQQ
	98a9JMtb99wLINYBDAO6Kw8vV6yEonI=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-663-9T91EAbXP12DzGJ4Z1mXjw-1; Thu, 06 Feb 2025 15:08:13 -0500
X-MC-Unique: 9T91EAbXP12DzGJ4Z1mXjw-1
X-Mimecast-MFC-AGG-ID: 9T91EAbXP12DzGJ4Z1mXjw
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-6e43fb256a2so14763246d6.0
        for <kvmarm@lists.linux.dev>; Thu, 06 Feb 2025 12:08:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738872492; x=1739477292;
        h=content-transfer-encoding:mime-version:user-agent:date:cc:to:from
         :subject:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lMTAS8pZ+dV5XxQmV6jHa6Bjt73X5ogir1Fm2eB6TvE=;
        b=ebb0c6uC4lqfjl4hdzYoNB1oO/tAGP8ihNkgCT/KGGWhksRUu+IRFv3rkd4S+KXwaZ
         75z4MUHGogcOa/M64Cyz0sUuNJvHTdTLlVxg7YCH2Lx+ZHD+3IsPsyi30lCCtdlrdEax
         /k0/Hr2m3qFruKCE8eo+HbvdiZkA1It/5xPfZ90gGBxbwhmbLpFHO3zPR/yeooZsS/RO
         RI3MO+1hz7dp+9RoNlSkLf5kSnwgDFl3VdoS/cLwStF0lg0IN7Ykbiu8Zf0DuGSbmr8R
         euI++a03LBCpC41JZRCF6Lq/KKd9kgx44V4XN/HT5xbrDqRAkpMCr1yrEbw1DqO68xvB
         Atfw==
X-Gm-Message-State: AOJu0YzT5pS9swb++jj5hYeqEHCjukD9AihWl7392ls6jsx9VJ/uV7Hw
	Xfkp/JHUzjGiWK8VrOhuoJQVhrD7DeWjALOKBNY3qEJY4NPZ+TOht0dwmlSf0Ph7ZwQV5wZHxtd
	Fh734rtRHAXqQcmjO3j1sPIFmD2Ht0uynZy1OHBtv8PnIERI1bT9B5c+78L0TGaaKfKPnc4/oYu
	ByKQwZq5QRhYJlfcSFXP7h8ZHKFAuwZuWYjfRfaw==
X-Gm-Gg: ASbGncuLM77zZCLhee7btlupPv+T4mt6S8BmO1PlVx62p2QTg9Q43PokpgoNV8gZ6nF
	dQ9pvbSRie7sCuiXZIqZvKtndEVb0cMTYGmCvQwqYR18QmALllZpM/Uh2+wVy0svooUdVHgjO2+
	k0Vs0zC7OwcY7JSDxwm6/fJkO9DQkIRQHVrStE00QXdGNXneP4FSQSqnpEba+zYMzYaYMEPtYIl
	zCxAoyqLhUxpMhWHFKrvmnadH+NHmr52Kiiza0ZdCw40XW90hxeFDhDbfYL0UTZTif6auLefi1O
	ceL2
X-Received: by 2002:a05:6214:2125:b0:6df:97a3:5e5a with SMTP id 6a1803df08f44-6e4456fb68fmr6117116d6.28.1738872492252;
        Thu, 06 Feb 2025 12:08:12 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEvLPFk7n13OymwYmVhEWVp5kTrPK6FDD6vm5LNZc8OL50WsLHUamKJWZR2KL1P8HbqyyuOeQ==
X-Received: by 2002:a05:6214:2125:b0:6df:97a3:5e5a with SMTP id 6a1803df08f44-6e4456fb68fmr6116726d6.28.1738872491822;
        Thu, 06 Feb 2025 12:08:11 -0800 (PST)
Received: from starship ([2607:fea8:fc01:8d8d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6e44628d1fbsm327646d6.112.2025.02.06.12.08.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Feb 2025 12:08:11 -0800 (PST)
Message-ID: <dd333b6d05e2757daf0dffa17ae9af5eb3498e05.camel@redhat.com>
Subject: Question about lock_all_vcpus
From: Maxim Levitsky <mlevitsk@redhat.com>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org
Date: Thu, 06 Feb 2025 15:08:10 -0500
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: k3s9kBilD8HUpxU6d7RNZDh4z1F84Pz8igT4OdFNcfU_1738872492
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Hi!

KVM on ARM has this function, and it seems to be only used in a couple of places, mostly for
initialization.

We recently noticed a CI failure roughly like that:

[  328.171264] BUG: MAX_LOCK_DEPTH too low!
[  328.175227] turning off the locking correctness validator.
[  328.180726] Please attach the output of /proc/lock_stat to the bug report
[  328.187531] depth: 48  max: 48!
[  328.190678] 48 locks held by qemu-kvm/11664:
[  328.194957]  #0: ffff800086de5ba0 (&kvm->lock){+.+.}-{3:3}, at: kvm_ioctl_create_device+0x174/0x5b0
[  328.204048]  #1: ffff0800e78800b8 (&vcpu->mutex){+.+.}-{3:3}, at: lock_all_vcpus+0x16c/0x2a0
[  328.212521]  #2: ffff07ffeee51e98 (&vcpu->mutex){+.+.}-{3:3}, at: lock_all_vcpus+0x16c/0x2a0
[  328.220991]  #3: ffff0800dc7d80b8 (&vcpu->mutex){+.+.}-{3:3}, at: lock_all_vcpus+0x16c/0x2a0
[  328.229463]  #4: ffff07ffe0c980b8 (&vcpu->mutex){+.+.}-{3:3}, at: lock_all_vcpus+0x16c/0x2a0
[  328.237934]  #5: ffff0800a3883c78 (&vcpu->mutex){+.+.}-{3:3}, at: lock_all_vcpus+0x16c/0x2a0
[  328.246405]  #6: ffff07fffbe480b8 (&vcpu->mutex){+.+.}-{3:3}, at: lock_all_vcpus+0x16c/0x2a0


..
..
..
..


As far as I see currently MAX_LOCK_DEPTH is 48 and the number of vCPUs can easily be hundreds.

Do you think that it's possible? or know if there were any efforts to get rid of lock_all_vcpus to avoid
this problem? If not possible, maybe we can exclude the lock_all_vcpus from the lockdep validator?

AFAIK, on x86 most of the similar cases where lock_all_vcpus could be used are handled by 
assuming and enforcing that userspace will call these functions prior to first vCPU is created an/or run, 
thus the need for such locking doesn't exist.

Recently x86 got a lot of cleanups to enforce this, like for example enforce that userspace won't change
CPUID after a vCPU has run.

Best regards,
	Maxim Levitsky

