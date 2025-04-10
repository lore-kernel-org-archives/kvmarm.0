Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA8921D95A3
	for <kvmarm@lists.linux.dev>; Thu, 10 Apr 2025 15:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744297851; cv=none; b=qi3mKwy/3fRMf8USplaE83A6mBX4HIOtetntC9sToUOtsR0rmMpllXte1SA8kzen8KUA1QIHVzh4TN27d6dLAbNvKDRdFMXjuxwixEn8c2hTHIkmydtpmIbwoEurw/95VrFj9+EhwoXBo0u2ZD0oaTYCysCaJnM26C60Z4gwdFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744297851; c=relaxed/simple;
	bh=ng9xh/PG1LUIBqUCqRBp1J3efi6ls83MH75OfUbQ4+4=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=s8FUhNo4PBy8WenuU09LcYPIrTYBfSQ2EcRM+M9+fjRxHifeed+VMGl0O+oQTUjkJJxKJIPQlCzWW3+3YNDBfx5OptDMcPW4HlTwlW4XDueVaFL9ODXHDpimvBk3hwX4AhvtBXPt6I1ecZR7CbD50umwEzSL+7egnyOkhZ1y0Hk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KTN4dxpn; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KTN4dxpn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744297848;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=EXKgyYog58kyfqHQcoNTtvL08JiFX/6XLrBhO7Ve8ts=;
	b=KTN4dxpndtc7uw1Xg1FlmFSV/ktvhDpf2DIA4bzaoO/KR41oG+PQgVBhNkHlgCBDHNXZY9
	Bnv73xEEm+MUojQ+ww3yqEmqdfsa9xo/1aHiEP2zL3NyQsZuTh+jIYFw6q2C80OdKfI4n1
	doqubiTOdjGwAjSJCOnUCCo3X9xstiA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-386-nAw8LezJN1SEdLNE3QOSww-1; Thu, 10 Apr 2025 11:10:47 -0400
X-MC-Unique: nAw8LezJN1SEdLNE3QOSww-1
X-Mimecast-MFC-AGG-ID: nAw8LezJN1SEdLNE3QOSww_1744297846
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-43d51bd9b45so6427165e9.1
        for <kvmarm@lists.linux.dev>; Thu, 10 Apr 2025 08:10:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744297846; x=1744902646;
        h=mime-version:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EXKgyYog58kyfqHQcoNTtvL08JiFX/6XLrBhO7Ve8ts=;
        b=dIaUlcKzv3dMmVmVFkc/b70d5OkBGKovDwH1Dcu/6PX1r+MlmJIAz5UV497gM4rxD/
         xQJ8ZDUghZHWUmIAANknml1eQeRgYudoDcTFEsueCqskgc69o8MwIhoWdTOLRBhVMuY6
         Ggyzqfp+Z2vPQ/xPCjXuhAy0/FLzZ3dP6RQ+97y7hg9FivFfLGicBH6f+2eeg/E14RTy
         3eamdLtlo+pxLnxR75zMj9MFdVV2JFmZBXUG3WKUa1fRRWJczLmwCpHpAKEAHQhVH8ad
         NYclZXZj8R2at3qeRx1i7n8mLqICl64xp0G5waXIiTehYO8qmFIhpgn7sHolqFfxd0+6
         YD9Q==
X-Forwarded-Encrypted: i=1; AJvYcCVo7hgIa9hSIaL5LSpdw4SB7JfeDJ1QlSW7Nb0vR5VIuY9sBiy3A1VpoXqZroULfumeVrT9eAI=@lists.linux.dev
X-Gm-Message-State: AOJu0YyUegayqbiuJOLkkHBy77s8Mlmgt3uTasbOpVMzq86w5JjEDdTI
	6AxKUk3igd7EGF+qVcIjNUCxktc0EwjPWgxWqWtmeHQNCi5jpD92TfIl4D1ka14xkA2wMhnG5cM
	JC5OLjfxbp/V9QdKTrV9Vr59OgZJAPU0od9G49qtcgHLbuKWxjHbvOQ==
X-Gm-Gg: ASbGncuwB1P8GCwMg6277ouricEe7kK5PRile77vpMZ3L8JJIkyx/zgS1RqqRd3WLUt
	4LttfsS9wgHCPqvyOYjnOAsSVpIIBtfwlBh03mspPVGgubpVZnmG7WK6O8y9omk+/x0jeYEHANH
	ILGuCJ5NoV6uTQ6y92zJbfxHKYs9jFDIlxyVRTds3qR4QNuuhObsC04ynNGr8YPZxn9qBMyWFT/
	UOWNuzksdOaj+0cQFoB9Uhz0bOvUqnvsJW601jTNnH6RT2IbNPML0Y8O+qa0TAsarzlkAL1sUOV
	6MQIgloc/jcTShuHNOUniKX6npb7Lazzxwhrbq08ucjQZg0/T1pplUq34SOx
X-Received: by 2002:a05:600c:c19:b0:43c:f050:fee8 with SMTP id 5b1f17b1804b1-43f2d96d12bmr27394565e9.20.1744297846044;
        Thu, 10 Apr 2025 08:10:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFxwdlqvMr0+eJqJHcy2sApkT2sXjxRivRro1I+Xe8jUjWmS3HlK9o9rH1isaEbTm3IHTMmxg==
X-Received: by 2002:a05:600c:c19:b0:43c:f050:fee8 with SMTP id 5b1f17b1804b1-43f2d96d12bmr27394165e9.20.1744297845618;
        Thu, 10 Apr 2025 08:10:45 -0700 (PDT)
Received: from rh (p200300f6af1bce00e6fe5f11c0a7f4a1.dip0.t-ipconnect.de. [2003:f6:af1b:ce00:e6fe:5f11:c0a7:f4a1])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39d8938a860sm5156906f8f.54.2025.04.10.08.10.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Apr 2025 08:10:45 -0700 (PDT)
Date: Thu, 10 Apr 2025 17:10:43 +0200 (CEST)
From: Sebastian Ott <sebott@redhat.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
    Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
    Zenghui Yu <yuzenghui@huawei.com>, 
    Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
    kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: arch_timer_edge_cases failures on ampere-one
Message-ID: <ac1de1d2-ef2b-d439-dc48-8615e121b07b@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 6F9kaMP63Jt9Xdu230fiC_gkRT65UuPNZjoNHmoSEPc_1744297846
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; format=flowed; charset=US-ASCII

Hey,

I'm seeing consistent failures for the arch_timer_edge_cases
selftest one ampere-one(x):
==== Test Assertion Failure ====
   arm64/arch_timer_edge_cases.c:170: timer_condition == istatus
   pid=6277 tid=6277 errno=4 - Interrupted system call
      1  0x0000000000403bcf: test_run at arch_timer_edge_cases.c:962
      2  0x0000000000401f1f: main at arch_timer_edge_cases.c:1083
      3  0x0000ffffa8b2625b: ?? ??:0
      4  0x0000ffffa8b2633b: ?? ??:0
      5  0x000000000040202f: _start at ??:?
   0x1 != 0x0 (timer_condition != istatus)

The (first) test that's failing is from test_timers_in_the_past():
     /* Set a timer to counter=0 (in the past) */
     test_timer_cval(timer, 0, wm, true, DEF_CNT);

If I understand this correctly then the timer condition is met, an
irq should be raised with the istatus bit from SYS_CNTV_CTL_EL0 set.

What the guest gets for SYS_CNTV_CTL_EL0 is 1 (only the enable bit
set). KVM also reads 1 in timer_save_state() via
read_sysreg_el0(SYS_CNTV_CTL). Is this a HW/FW issue?

These machines have FEAT_ECV (as a test I disabled that in the kernel
but with the same result).

As a hack I set ARCH_TIMER_CTRL_IT_STAT in timer_save_state() when
the timer condition is met and set up traps for the register - this
lets the testcase succeed.

All with the current upstream kernel - but this is not new, I saw
this a couple of months ago but lost access to the machine before
I could debug..

Any hints what to do here?

Sebastian

