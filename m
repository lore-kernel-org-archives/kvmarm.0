Received: from mail-il1-f202.google.com (mail-il1-f202.google.com [209.85.166.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A095C1FCFDA
	for <kvmarm@lists.linux.dev>; Wed,  5 Feb 2025 18:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738781834; cv=none; b=LoAZRBGGf3PTFlQ1bcOivDnuVdEbpJzanQIXhUMmz6hg/LWuOO5kAg8Ofeozgy8iyy4LLzPwAEZCLSfc8MfJYhA3VK2l5BAR0Glw6Xy6Vm4zr6qRnSMyBSHuidBLz0QZ6eG4jheJBYSZe/FytpSl0ohfW6raZwkBH7OazOrX8fQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738781834; c=relaxed/simple;
	bh=rOrAEmmc0o2wzEyiwOq4DQ4uXK1/Mbcgtx+WsCmakwQ=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=U0R/k/GjgQVmxDvpePeyKCfoZpoGZ37ErZggFVmrfQ3poD2szHpURWqqv8xjrTdT5ulbqcEUbWImqp8KnAQXtqw1cSk/Jsm91T3esymxfu5IJ1zm2EPbPa9rahz5QY/YmotwPfDFWV9iud3YDNKLE/gFpLCadsXtDYtE7pf300w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JfRpRAQE; arc=none smtp.client-ip=209.85.166.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JfRpRAQE"
Received: by mail-il1-f202.google.com with SMTP id e9e14a558f8ab-3d0246e4c2dso819265ab.3
        for <kvmarm@lists.linux.dev>; Wed, 05 Feb 2025 10:57:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738781832; x=1739386632; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=rOrAEmmc0o2wzEyiwOq4DQ4uXK1/Mbcgtx+WsCmakwQ=;
        b=JfRpRAQESTuGcpwOE5G9y0ocqMJBzx1boPxSiFRgCG84xSWKSrBp1seVZk1O9KfiT8
         mv0uRF85QCoxdMwSN03LDATeaO/GJZiNPZCfueeIyghG8Lc8dtnMtR0oJScQG7j5SrBw
         NUtgi9PoY6+Wf5T6VD19rgEyvBfSC9Ck1hSsRI+SAz/+eBLq0bwF+doHduoWihMPp2dW
         77LaAMLr4hi4j5tmlLj8CjGscU7UibAGVXx4DQTOfWXbWlIR+EW61vyuFbblbcJmpZ5w
         7pA0uVXvp3iC6b828MCSNMT+VNfpFVUPJh48NV/ki4X1lIgQIG+YgAc1EwkaIsSTnBlF
         +Nnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738781832; x=1739386632;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rOrAEmmc0o2wzEyiwOq4DQ4uXK1/Mbcgtx+WsCmakwQ=;
        b=fHW7ulA/4QZ1ibbWDPXoSycxkXHSg66Vut4wjNNtxxAUjZQHYx2ePLEMZhWTR5oAEV
         uvEA/a/mlEoMFGWOLAvd/1XJ8EctMYaQysPnk8qHf5llnz2mJq/HNQzQCw6JgTqCN67R
         8Bmqd8RqOT2C9Pfhk+RgbeRYj3eKYHQvg+VnzQ+Br/WK5CgQI9dhO+D9GEQuGEiSe9iy
         3BvjQvz1Tp25ZyFgluAmLkYG/Z1tkaV8iEAt71dxXkywAZoeVo69QiTbEbQuEYhJN26Q
         ABMPBPHwzLdk0d/GJS+fYNzRFgNtkO4fGpOAMmmyNCXW2zmsTb/1WivBgpP3lFuxLfj6
         G6aA==
X-Forwarded-Encrypted: i=1; AJvYcCVS/9qvgnHHsbo6LyLmkgEP489YeMWCHIae9aXcZJkN2i1fmK70DO9ZuLHf1RMr8RLJIkLzGls=@lists.linux.dev
X-Gm-Message-State: AOJu0YxyA0AoLNuu5nY8cieD9OklD29NvbQjaZ0IlnIhuvxFCw0CyAHN
	olCEFeOBezMV5m3rYh2ufakkmsySjyuuyBnFIDffTJwxrgKglyvutKUC8yck4V12SsH7buXKZ50
	QrOy3yXa7MQCM5h/Q+OF/fg==
X-Google-Smtp-Source: AGHT+IFWjXwnbjoiuM23Lh8ngijtdwE4nXRVNLab1fsF4fpL0OVJ9k6mAwaRhufdfdCX0QUJltSRVIg24JQ3/eImKg==
X-Received: from ilbbe10.prod.google.com ([2002:a05:6e02:304a:b0:3d0:e0a:64e1])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6e02:2197:b0:3d0:1fc4:edf2 with SMTP id e9e14a558f8ab-3d04f41ec43mr42282665ab.7.1738781831860;
 Wed, 05 Feb 2025 10:57:11 -0800 (PST)
Date: Wed, 05 Feb 2025 18:57:10 +0000
In-Reply-To: <Z6KqDR3S_AWXXLJK@linux.dev> (message from Oliver Upton on Wed, 5
 Feb 2025 00:00:13 +0000)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Message-ID: <gsntpljw1apl.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH 2/2] perf: arm_pmuv3: Uninvert dependency between {asm,perf}/arm_pmuv3.h
From: Colton Lewis <coltonlewis@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvm@vger.kernel.org, linux@armlinux.org.uk, catalin.marinas@arm.com, 
	will@kernel.org, maz@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, mark.rutland@arm.com, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

Oliver Upton <oliver.upton@linux.dev> writes:

> On Tue, Feb 04, 2025 at 07:57:08PM +0000, Colton Lewis wrote:
>> perf/arm_pmuv3.h includes asm/arm_pmuv3.h at the bottom of the
>> file. This counterintiutive decision was presumably made so
>> asm/arm_pmuv3.h would be included everywhere perf/arm_pmuv3.h was even
>> though the actual dependency relationship goes the other way because
>> asm/arm_pmuv3.h depends on the PMEVN_SWITCH macro that was presumably
>> put there to avoid duplicating it in the asm files for arm and arm64.

>> Extract the relevant macro to its own file to avoid this unusual
>> structure so it may be included in the asm headers without worrying
>> about ordering issues.

>> Signed-off-by: Colton Lewis <coltonlewis@google.com>

> Is the intention of this change to allow asm/arm_pmuv3.h to be directly
> included? If yes, what's the issue with using perf/arm_pmuv3.h?

That isn't the primary intent, but it's a good side effect. Headers that
can't be directly included violate people's expectations.

> We already use definitions from the non-arch header in KVM anyway...

My intention here was just reorganizing a counterintuitive use of
headers. The arch header depends on definitions in the non-arch header
even though the inclusion relationship is the other way around.

But this patch doesn't matter as much as fixing the cyclical dependency.
