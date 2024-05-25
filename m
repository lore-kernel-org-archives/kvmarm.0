Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D8FF107A6
	for <kvmarm@lists.linux.dev>; Sat, 25 May 2024 15:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716649388; cv=none; b=MtJd7quPr7qztccfMrPN9EfRNW+8Mq56eMnyeplR6evkeJf1c3vqtW+EX192V123SldkxrP60Mv9mqh9Orzu6a0eZmxSLjofHbrhQjkotQtXBideQrAyHTJaR53/7q1Bb9OMBzqJh/REWfnhPqgtZB1jXKQCfW9ZLu87A/ibi5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716649388; c=relaxed/simple;
	bh=GBoz9hdxZduBQZwXzdDaF3M3aixjjlbw0Nw9YNuuujE=;
	h=From:Message-ID:Date:MIME-Version:To:Subject:Content-Type; b=MrbgCZnUjGCOw3LOjTiojbqULcjJyEgNKCF7l19+a17fQgFaPYF4xrf7Kj0PD4MezB7AwT7W7gHt9S00rzmp6m/u1IgnpaH1lV34G/AUQ/fQHXVBdBkgxLHTcwV+1xc3k0ZAx93stZo18t+Jp+48DR+JGuFYYcP5V/P9DdtVERM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hOjjPb+y; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hOjjPb+y"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-6f693fb0ab6so4879009b3a.1
        for <kvmarm@lists.linux.dev>; Sat, 25 May 2024 08:03:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716649386; x=1717254186; darn=lists.linux.dev;
        h=content-transfer-encoding:subject:content-language:to:user-agent
         :mime-version:date:message-id:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5FRi5s/95uKbsco+n9pTPLg51G5wkMGiP7bn/pz2aPc=;
        b=hOjjPb+y8Pv/BtYULA6gEpoHljGqlhg4WxniTQmP769Lij2wF9rmTBQ9yW6u9DVsph
         2V5nfpKl42sSq35WaEmndDOpuqPIRiD7SZC4ETq7ID9elliotiRfZZKBon2noHQV9tfQ
         Wa5XEKOHbRW5eloVBvb1O9YFURYJpGPApAXJ2osxK9iVtirN/HdJzSGLhAqJkrd07uqV
         XvLs3/AQxf+vOoEC70jFP+xDFlL0fJ8Ly/QtZHNBpiM030ihEr4yC5vL5nEJb6QPqPcT
         0vmxdi5MfYPku1NOvKkm3ztBqRush0Vbitq2SBQmxDw1fnejORMAHRozVM2nnnakKDKO
         89UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716649386; x=1717254186;
        h=content-transfer-encoding:subject:content-language:to:user-agent
         :mime-version:date:message-id:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5FRi5s/95uKbsco+n9pTPLg51G5wkMGiP7bn/pz2aPc=;
        b=BXfQo+jglNDRnSIPpjBh1C9tyJC30V3We7vfIYLHPzbfzVpvRWUUcE3blX0cZ/ffkJ
         hWEj2YoOeiOs6HD2cIZTkAfnm/8iE5VRNPv3+iN9DvihOKkVY51C1Sntc5C2C7KzZHvq
         OjKyQqj83CiFmGkgtUqxJjoIDg/hQtMIMKciOkxgIb9Xnwd3S9JMY0Xq5I+9FBkDVor0
         TlZJB7HTatD5esitV8cmoa/8Mdam8w8tsLWYHmhwKyTkaOZah8TRblB7Ke9GDdXbKTeT
         g0ObTQ7fIssVMrOhpgI8tRT/yF8xpUbK6ZeydIRR8536aLfGFQ5HynQeqW6N1R+TOZX9
         wV+A==
X-Gm-Message-State: AOJu0YzAnRGnzr0RAh++tNel6WWb9QVo2niODHmFzwt4bez3P/AbThhf
	TT5kFbf+mYbXVmEnH04zZ3T4jMEIiZ/sgQfSLDHZGGzgWpP74OutFm5L5pLWlY8=
X-Google-Smtp-Source: AGHT+IGcSvgg4fx9MGrEw6amGh0DIwSwkukBWoDxF8nUZ/dhfMKMIl/p7Qm1rTB4Hg42clHYKnFZKA==
X-Received: by 2002:a05:6a00:8c11:b0:6f6:7bbd:bebf with SMTP id d2e1a72fcca58-6f8f3d67b03mr5359508b3a.24.1716649385679;
        Sat, 25 May 2024 08:03:05 -0700 (PDT)
Received: from [192.168.68.108] ([106.51.161.170])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-6f8fc053bd6sm2553688b3a.45.2024.05.25.08.03.04
        for <kvmarm@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 May 2024 08:03:05 -0700 (PDT)
From: Yuvraj Sakshith <ysakshith@gmail.com>
X-Google-Original-From: Yuvraj Sakshith <ysakshith@Gmail.com>
Message-ID: <6a471cff-a355-4740-9885-b35f25c8e318@Gmail.com>
Date: Sat, 25 May 2024 20:33:03 +0530
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: kvmarm@lists.linux.dev
Content-Language: en-US
Subject: Question: Why does hardware_enable_all() call cpu_hyp_init() again?
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Greetings,


I was following the CREATE_VM ioctl and navigating through 
kvm_dev_ioctl_create_vm(), I found hardware_enable_all(). This calls 
cpu_hyp_init(NULL) on all CPUs.

But, doesn't kvm_arm_init() call cpu_hyp_init() on all CPUs during 
init_subsystems()? I am curious why this needs to be done again during 
every CREATE_VM ioctl.


Regards,

Yuvraj Sakshith

