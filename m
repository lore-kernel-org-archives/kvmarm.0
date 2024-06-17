Received: from mail-io1-f74.google.com (mail-io1-f74.google.com [209.85.166.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61DC71990BB
	for <kvmarm@lists.linux.dev>; Mon, 17 Jun 2024 18:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718648567; cv=none; b=mA0PNNAOd8P80+ZGy7lktCFTWNTq0hWLQFCwf7nzJIqiNDtppUHPHPueB7TxNPGCP7x+SzOy6N6dJGpPIBhdeniTztlyjtA53jxlXYUe3f461/fNYA/Cm5aWtZOgE4YgI4nqYUxl0kjX2sI5NW/m84oiOcCxu4OYVv2Zc8ec8PA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718648567; c=relaxed/simple;
	bh=qhSM1PBvU7joTxqhlWMSmcyf1OdS106mDM5IHpvzoPw=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=CGX6Bq4isoH0+4dDQWjPQFVZy9UkTmvIldEtjwTBcNT+uFcZIZG9uU1nU0t8O5tyCjhNy2g67O7PkjIcThTKN1427deUjXm6kypA7m/Jug5xtM+Y0xn586/XkxyepR+H5Vy1rGy8PDsdkilAi0Xatrfr/0B1TlzZTEAQUm5ZV8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MirXv63Y; arc=none smtp.client-ip=209.85.166.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MirXv63Y"
Received: by mail-io1-f74.google.com with SMTP id ca18e2360f4ac-7ec00e71ab9so343388139f.0
        for <kvmarm@lists.linux.dev>; Mon, 17 Jun 2024 11:22:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718648565; x=1719253365; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=pny2UzPtVZNTzHF4IsxaYZ+f2GCEeGNxOUJXm/PCpXQ=;
        b=MirXv63Yw08+2n5vy7iJbPV1lgvOwCp2eTNZVXPkTNw/gF9b/TOg2z/Ci3MAJz1NnX
         7fLes4KASthYDc1qHkOD8hpZFLHCewNfPGUWtQ7fBuAXd9ikVEUmHcF5svuBZSjLTadw
         3lx8Masa8doRoQ+t17Um+GWGtnorg8tnBGe/vFO8/AK6mwVHLOMPwjU2wu4zwmMdi3Qs
         BjwI9llGmE0mPj4NTb0gOXdJaY4IzxW0BySb2hRSyf5g8nlyXCoPB4mmAZhOfmyJul5Z
         jqBnZgEljq8ZTquqMllw4jFx6TYfFNj0153JPRqZcnC+C4LnltZqE3I0w9WOT09cm2C0
         rE7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718648565; x=1719253365;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pny2UzPtVZNTzHF4IsxaYZ+f2GCEeGNxOUJXm/PCpXQ=;
        b=iZWtHacVluMYLOicg6ExHWjDiUYYNw4QDj3kFvz+f0EqUV61gOqggNoKhVhEzzY7xW
         xwIpQ0eAlvm5fC1O9xeAKQX6iB8HvkYTz4Kk16Hkk9U9UHG1yhzs4BfFZf5Bo0qBAYPS
         UYNAKP4ZCa+w8f5EvnVoXHcM812brHd5S5r4LT24+jcfEOwV0pJ/ml5HUvvQ692VePTN
         vItRjtjz2MzZCnNfIkPTT0c/8r5n02YKvdGtgda2OWGZoQl5CxaLc4B5n3Xy/a5jvWxV
         N8FcwwGvCd9QkT/0vOW0xaY0utqCHn9TqcYPTTN7Cog/eH9ksWyAOviUIVPrRxG8Qlr3
         +Wwg==
X-Forwarded-Encrypted: i=1; AJvYcCXBfYB+ueHpycVHhS5tomQgy1eub7KsjpVEeMBQMFEmOGpQE9iAAgudDErLW0p/dYf+1RRG1G/ij2FEbkG2icZNVxBOH/Os
X-Gm-Message-State: AOJu0YzZgUeQK9Lq8y1411RBuISPtH3LVzA9I1PFKmx69atNMUDrVTyN
	mESuQpyDnqMyybIeiAjx07XOQNEs/7A/70lhyuElIBNryagWET64ONtgtHLxjD0vaECyVMK3Rvx
	usZ1qt/SZIhWa3yrlJbhd6A==
X-Google-Smtp-Source: AGHT+IEjud4xQdH2Jdh7XuNPZ20RXq/rHRZKEIbMLpx/a0M5UDBisxWRfV6ZxH0660BmRU4E5fKorzt/Ng9lgPN54A==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a05:6602:3f87:b0:7eb:823b:9583 with
 SMTP id ca18e2360f4ac-7ebeb638b3cmr21918139f.3.1718648565639; Mon, 17 Jun
 2024 11:22:45 -0700 (PDT)
Date: Mon, 17 Jun 2024 18:22:44 +0000
In-Reply-To: <171839594069.633615.6902666817551787618.b4-ty@linux.dev>
 (message from Oliver Upton on Fri, 14 Jun 2024 20:12:27 +0000)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Message-ID: <gsntplsf5szv.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH v6] KVM: arm64: Add early_param to control WFx trapping
From: Colton Lewis <coltonlewis@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvm@vger.kernel.org, oliver.upton@linux.dev, yuzenghui@huawei.com, 
	linux-doc@vger.kernel.org, catalin.marinas@arm.com, corbet@lwn.net, 
	linux-kernel@vger.kernel.org, suzuki.poulose@arm.com, 
	linux-arm-kernel@lists.infradead.org, james.morse@arm.com, maz@kernel.org, 
	will@kernel.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

Oliver Upton <oliver.upton@linux.dev> writes:

> On Thu, 23 May 2024 17:40:55 +0000, Colton Lewis wrote:
>> Add an early_params to control WFI and WFE trapping. This is to
>> control the degree guests can wait for interrupts on their own without
>> being trapped by KVM. Options for each param are trap and notrap. trap
>> enables the trap. notrap disables the trap. Note that when enabled,
>> traps are allowed but not guaranteed by the CPU architecture. Absent
>> an explicitly set policy, default to current behavior: disabling the
>> trap if only a single task is running and enabling otherwise.

>> [...]

> Applied to kvmarm/next, thanks!

> [1/1] KVM: arm64: Add early_param to control WFx trapping
>        https://git.kernel.org/kvmarm/kvmarm/c/0b5afe05377d

Thank you! And I will keep your comments in mind in the future.
