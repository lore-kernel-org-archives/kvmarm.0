Received: from mail-lf2-f12.google.com (mail-lf2-f12.google.com [74.125.229.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BD925237B9
	for <kvmarm@lists.linux.dev>; Wed,  9 Sep 2026 13:19:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.229.204
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788959971; cv=pass; b=spAYjouTnh62LQpBPcqxTdomsKeF/duzoejvVh2oFzqXzDNFU+I3qeJVSd0d6l+OZWRq9CphVNEbIpGqlEy1+P7IT0tS8ldGNuO0GPpXwi5Ye4aI+Fz4LS/OPxKVr2+zHnbTe2NmyWe0K4BG4DwT3fUkNjj2doeCUuXVesQK86U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788959971; c=relaxed/simple;
	bh=/lXKMho56Iawzotjf9gqPSSOK8+fhDi4DHNzWXgEKCw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Cn7JK6b+N218FL7nZ97SLDfoR73mrDQwxlSjduVW8G/OCFAxGyodz8Hwh8yO+H7otpUz1hsRmqmqgcVqbaY/MqN9u1tj4Nl/LXOwcluRMv/gUWklBJ8OLamg/G+h3/YJ4K/E8ZllXywT3U0trmqyh4tItLSFOrT1RSvsu+ks7Lc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lR88kbvy; arc=pass smtp.client-ip=74.125.229.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lR88kbvy"
Received: by mail-lf2-f12.google.com with SMTP id 2adb3069b0e04-5b4a0b17359so6958e87.0
        for <kvmarm@lists.linux.dev>; Wed, 09 Sep 2026 06:19:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788959965; cv=none;
        d=google.com; s=arc-20260327;
        b=S4m/ygIBEjYhbxAe1M7IYAK8DodHpmiBhhbLHAN5NCCQv8PQZ0LFZWCnBxl0M2xzr0
         rmsqG7sfso+h1sWMZgeZGOf5SySHoTFHunoKuKm3QuSp2hGdoaCvytdIidaxtqO6+ULA
         +6WdlXhW4oPd0HDsJvMQBuWnIbufLJOJU9HIc+aRkTEA1KOa23kq5UPLiI5WN+W88/E/
         0fAGv9IxRcp9qTJ6/wcVYJPuuxvAKcQMkq9VMuPY1cuaXrb5Qalucb/5tPTs4YiiY0Ld
         6/CR5upJLeoqo8zLW6vMjMXD+mFVwxLmC6o4WeWfatiHWrbaDNGXCw8mvve08pekVy7Z
         QFUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=STg7xRV8j3OkHmv1a51bOo5IRu3aXP7QERSx2DeQDNI=;
        fh=Buje+HPtPHtZ0zQkSeCzeCZWKq6AuAhsLGdFm8k3g/E=;
        b=WWEqOwv5W/AGVXdWLXLHNUB9iaRWzw/9PwY/QxMyXKEmTfW2heoYrzLufwHYZm6nxu
         ehRfONLdVxYGOhVS2HJXXtIXRJ0o2jzN117X7Rhffv0QIu9rAGRTc6G7178AG5PCutpw
         s2NonTILjsq99p92q9VUoZRHD+www0lCILbnxoDiEdc9ch62SpHm+sQKlUSEdMYt7+XE
         1BcqNL7rgQs0YBf48w1LyeUWhpCan/6R5EWxyIi1My5af0fQNbQsQ932gPUfCR+s1eqQ
         C+q0OOk6RtVH45S80+aQVipAyBHfdyu5UTBADWuqNz75f5VMGkA+ty/0xsOZwm5S2OBS
         AU0Q==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788959965; x=1789564765; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=STg7xRV8j3OkHmv1a51bOo5IRu3aXP7QERSx2DeQDNI=;
        b=lR88kbvy/xMvM6qjtC5ojivt05zJeNE7ZrqxQA47dTAu7DM9PrGF5Bact19784LiVP
         xWQZQptZjvZk6UgVzgGk9rhzDJ6Hf7gaFMVR4e03m7wVW5Vi8L3Bq8pz6nEGYzY/CsXu
         lW5hdBi1M9K/M7HZRvUJIqTkVayo1msXwvsH60NS9lsxwlHoYivsGbB32MV3WaRNGjOe
         zt7rCQLNzcIlW596gXyfkwl2pXuhmKvrN8hM7zhxpKIvuZ0+nIHvMOFFQ0jOUbH1VyX3
         IU6fhKfyL91uLzLePQgQtjliHPGcGmVMN7VLbhNzvW9edgWUji1I+OExWfkzQY/yAl+A
         5h5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788959965; x=1789564765;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=STg7xRV8j3OkHmv1a51bOo5IRu3aXP7QERSx2DeQDNI=;
        b=BV8WtM35Eyaql8aO4kbdfmJOJa/nsKQhhacYswtwvA5IHWmX/UYKlSPISMPv0D3YHm
         AW3s5dcBbeK5u+Xc6ZcBaWES+rlJQw1EphBiuuv6MigNBdFM/sfFA6LRbZWVpdm6ON5Q
         FPzdSXBviANhsrxd/3fSiac7BJFJ4u0XVhKFHZ18arrhJzyD+NNuIRBCtdGO80O4gIHN
         XrQbRIoC2eKbJ9NQpyJR92yrxeojL+nbhz7xZvCx9xMCWxwvLlnbISNlieaq9/iRdfeY
         ct2cuwx+rs/rHJoBdJxxjGVIlx64b1O+Fg0EfNnucQoqj3jMn/XLf6YrUERJmKt8whJU
         2hdA==
X-Forwarded-Encrypted: i=1; AKwUvByhCdM+w9AF9R0Fgoaul3UYPlYL0kP+i5KB6bgH3TC0xwCW3H5H0JQ2a1P5UgilwoelThamNB8=@lists.linux.dev
X-Gm-Message-State: AFuF++kOtW5GCkfdVdMLkUOGKzRXP5EmTlqdHpCf6uZgsCJOTcHbkVoK
	BEVLW+FAtzzy4u5B5SAzcQgZVBOsKcaBsJuuD7EiRolnPGsD0shw5d3/kEgJik/NQZw3c4kqd8C
	y+uH0h70U8ZLGB0yintETugyekUUnPk2a0ruKcAvw
X-Gm-Gg: AYBFou1WguiVLJH7/Ta71Zp6NeBPu/NWWGDelN1dzgHuL08M17A1PrgJauHpEetaWkz
	donWNZ4bOuGLNcx6jZZY5PQoITygZmLzD2P20iBsmXiiaC4SfRYuHIjFsqa2fjZWCDx6AJPciOx
	fUg3UzpJfQc95yVDEejnyl8xpyz+zmhNhDBBgwbSWnOgBixmDod+Vog71sVA159OqhgU6Pwryi5
	e5uqax6dfG0kZzwZUlKehv0GSSHoPSz1h2QtbG1IvSq+tHbt1MSynZ1WVyqIF2KSLPV3orVO1Dj
	g5JeqX77KFs9QtdMAjnmAKDI1lLd9Pr0c437mKz3DWHJ7GygY5HPC3Jcd/jG878eOHbi5EjUoql
	4sksCdUEj8Q==
X-Received: by 2002:a05:6512:234e:b0:5b6:bea:f091 with SMTP id
 2adb3069b0e04-5b764bba2f4mr141895e87.10.1788959964067; Wed, 09 Sep 2026
 06:19:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260908162223.1683432-1-suzuki.poulose@arm.com>
In-Reply-To: <20260908162223.1683432-1-suzuki.poulose@arm.com>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 9 Sep 2026 14:18:47 +0100
X-Gm-Features: AcwNN1W9J0hO2XvyP_iEth4oT8xwRLULtx1NyAOMY4yUoohn2-IYZWX_G_vBhiM
Message-ID: <CA+EHjTzr-r1FRuJ-X3E38_SSHsNSz_vdO-8sFOtBdsiB3V_x=g@mail.gmail.com>
Subject: Re: [PATCH v17 00/20] KVM: arm64: CCA: Add basic plumbing for Realms
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, maz@kernel.org, 
	will@kernel.org, catalin.marinas@arm.com, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, steven.price@arm.com, 
	aneesh.kumar@kernel.org, oupton@kernel.org, gshan@redhat.com, 
	joey.gouly@arm.com, yuzenghui@huawei.com, linux-coco@lists.linux.dev, 
	gankulkarni@os.amperecomputing.com, sdonthineni@nvidia.com, 
	alpergun@google.com, fj0570is@fujitsu.com, WeiLin.Chang@arm.com, 
	lpieralisi@kernel.org, enju.kohei@fujitsu.com
Content-Type: text/plain; charset="UTF-8"

Hi Suzuki,

On Tue, 8 Sept 2026 at 17:22, Suzuki K Poulose <suzuki.poulose@arm.com> wrote:
...
>  3) NEW: Enlighten KVM arm64 about the different VM types and use call backs for
>    the VM type, rather than spilling the is_this_type_of_vm() everywhere. This is
>    not complete yet, but it is largely functional. Adds VCPU and Stage2 MMU related
>    callbacks with support for the existing VM types.

A design thought on the vm_flavor dispatch tables. They're
hand-maintained arrays indexed by enum, and a gap fails silently at
runtime, not at build: arm64_vm_s2_ops[] has no VM_REALM row, so a
realm VM would get NULL ops.

How about something like declaring it unsized with
BUILD_BUG_ON(ARRAY_SIZE(arm64_vm_s2_ops) != VM_FLAVOR_MAX), as
host_hcall does? A non-NULL check of the selected ops' mandatory
callbacks at VM init would catch the s2_ops naming typo Sashiko
caught, where the rows point at zeroed forward-declared structs.

Cheers,
/fuad
