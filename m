Received: from mail-il1-f202.google.com (mail-il1-f202.google.com [209.85.166.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59A371DF997
	for <kvmarm@lists.linux.dev>; Tue, 28 Jan 2025 22:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738103409; cv=none; b=ov9Odm8NDN9G3oojUO7rwhdwfRPhK/+XeCfWJPXtgkUVnETijbTG1F9UJ08C31Lk8do+WmLL00o/Gap4vE7mhgoMW+5lwp9ldP4VbKYb0uhc9i2x82pq8DLsOffQusFnFn+aRWBWRELG0ylxmdGZGLUMK5niL2++0f7xOmFWHaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738103409; c=relaxed/simple;
	bh=czbiir5pfHlcVyxdIwc1ZdOJadwEL2taxGiP/GViFzo=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=T+S7Lye1YLx7U53QpHlfLrs6kJaddhmvsT09r88Z4VHXl0XvkX00FQaEAshPNwgyjIcFjRf2I9N00ENJA/1h6XZ99wZtOjkRrXeg3wLCT3+SA5QbSf8+FmxEDwx5x+oLa/R6VzTt1gLn40H9nECvrtFF3pRucMt+py/r6/4RPNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=E8lGui4u; arc=none smtp.client-ip=209.85.166.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="E8lGui4u"
Received: by mail-il1-f202.google.com with SMTP id e9e14a558f8ab-3ce7b6225aeso99434795ab.0
        for <kvmarm@lists.linux.dev>; Tue, 28 Jan 2025 14:30:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738103407; x=1738708207; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=PJyyD6VmEYWxcK330MV1aDFyCcL0XkNUkxzA2EFgIdQ=;
        b=E8lGui4uA6vvyfgbdw+Zo5c/C/ya1RGB/GyHXNOq+hJDckBDkS/zalXHdUdSxoSGFX
         zwOax0OZrlrIdmAw7s+xvjhmdi4mBF81NYEJdY/xSag6G9DY5Maxo81YfQn+c21B+MQw
         fP+5vep63+ykPMYVGQqhJ9jJ95aQTgGkWrukPwhn+6iisEc+P8G9dhscPQQfuapddhw0
         lx88kwZAe9tB953okhHsEJaHb3NzpMN7LrbMa73JmAJmLGqzqO/an6oT4kKY82rSBKXi
         wPrjeHc3BPJLRsmTy3MghL8krtilggWs6xpW3aEhHb35obz9zmUbapSDwxITZQSWv/XZ
         S9ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738103407; x=1738708207;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PJyyD6VmEYWxcK330MV1aDFyCcL0XkNUkxzA2EFgIdQ=;
        b=CMywSWOkMaE4jOsc8czNBavnjEJ7S1DOb/Cj8nG+YPR+qT0pQyCMTVPiL8kW7+PqxQ
         R/ZiZ0nfhrHc3KMY/YtpwexunuAx51HEqTIGYRbpEiP//JiMGpOUehbhOL9L05xZMsIr
         EXDURX6F/yLuVnslbuko3SVquqHL8vLCb1+EwEFKL/jEgh1Mu8s1bpHu6Nmcho7bsDX8
         b53KPazYLr9MEHWsgc2bUZK5F1W9roV/8zRzCgX4d8tUBa+7noOS4sPDfRaIthrUaIDe
         kSSekaTy9KsBrOHhgLaZAF4hlsYEZ6s3LM6lMmxilTG9DeLeAAVE1H23f5G+Vfe2eH0V
         2mRw==
X-Forwarded-Encrypted: i=1; AJvYcCVwpyjcAmwFi3gO1GkaRZq2J7oRRlgOQUZVKIGz/HSv6iCBo28n1crcF6joYNoP/FV76WFx+Q8=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywa86PBP2D0F5ftVZwwmlgSIeLnjkPrt+TQpudumv7T5hmWV1Yu
	kMby3zPF4I2oxSr2YwgdqNWqSRqix5jlsdBfUAih8GeWGaqM8ocPhfn36BuOuL3YD5PNEeqhbqh
	bTA5J2f3afeGj7y+tcsYCbw==
X-Google-Smtp-Source: AGHT+IEzKUN81fJKc8eE6WAbDE6ZVYHJOboxJYYulvMty+JLLQCGAA/P2PHrSwX2t2Fmqv3l22wjepYmRho8Tz2r6Q==
X-Received: from ilbby2.prod.google.com ([2002:a05:6e02:2602:b0:3a7:cfdb:57d])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6e02:1fc2:b0:3ce:78ab:dcd1 with SMTP id e9e14a558f8ab-3cffe4a7bf1mr8589345ab.19.1738103407532;
 Tue, 28 Jan 2025 14:30:07 -0800 (PST)
Date: Tue, 28 Jan 2025 22:30:06 +0000
In-Reply-To: <a6152acf-67e1-4800-857f-cffb35a5d738@arm.com> (message from
 Suzuki K Poulose on Tue, 28 Jan 2025 15:55:00 +0000)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Message-ID: <gsnt5xly372p.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [RFC PATCH 4/4] perf: arm_pmuv3: Keep out of guest counter partition
From: Colton Lewis <coltonlewis@google.com>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, linux@armlinux.org.uk, catalin.marinas@arm.com, 
	will@kernel.org, maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	yuzenghui@huawei.com, mark.rutland@arm.com, pbonzini@redhat.com, 
	shuah@kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

Suzuki K Poulose <suzuki.poulose@arm.com> writes:

> On 27/01/2025 22:20, Colton Lewis wrote:
>>    	/* Disable all counters */
>> -	armv8pmu_pmcr_write(armv8pmu_pmcr_read() & ~ARMV8_PMU_PMCR_E);
>> +	if (cpu_pmu->partitioned)
>> +		armv8pmu_mdcr_write(armv8pmu_pmcr_read() & ~ARMV8_PMU_MDCR_HPME);

> typo: s/armv8pmu_pmcr_read/armv8pmu_mdcr_read

Good catch. Thanks
