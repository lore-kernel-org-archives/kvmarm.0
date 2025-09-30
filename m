Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A29612FB60E
	for <kvmarm@lists.linux.dev>; Tue, 30 Sep 2025 11:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759230009; cv=none; b=pV9P27IzMbqQiesRYRH7eLbRkotCbbbHIbkXEjsCh5jVnPZT9r6GJqqQSmhnd9Vv+esVOxdB60242q0wLkgiyCtZQpo2lG0TDFPrZBxZwW/MTyPXzjS6sl0Ig++bUpQzDOh86HM1mwxQqFEvV+eFQpkFPOyL3sjsnGQxgQGs3xw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759230009; c=relaxed/simple;
	bh=wFnoy4QXjxAmYJyA1+5t7l0ikN0i8PEuNczTcDuAws4=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=rZei607N8kLC18Fx64grYgPrbuS/tQMvQetYC27SdQ1grMRdgmsejVYlyEnqy09lSVLLfW+ngI4kOtjByZNgY7nKAmgtUl8rIXKfOap/IBPv0rD5xjdI7UIm8dHDSYpfwmhWXSWNNXDZ/VAwGRRFV0tV+zBMHE//wOtFXutDL2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=BQihEaK+; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="BQihEaK+"
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-b4ee87cc81eso5065649a12.1
        for <kvmarm@lists.linux.dev>; Tue, 30 Sep 2025 04:00:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759230007; x=1759834807; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=BW2Qtj+KVSZo32MbcvWapFjwhM8eljdM2/EMaeJKXfU=;
        b=BQihEaK+B6vVDoOxeNQ4G2o4KAGX8UKOzeGjUHadd+NyVY53757A2fI5EYs54FqFs2
         zp6bDNMl2iAcIJGQk/85R5gBThIvNdYgkNq1aQJRbTJgq24TLLErBxzwJrsoJiiHhthU
         3JYpBpG78cT2FlBk1dDZyq/zPV2LFO5QjWOhNK2DaY/sOdH/1lc7VoKFbm7jwLgePWL+
         MfYaMxlCeyaxxjfMGbnliu+boCIwf/Mt4ZfvBC6lozaiUpUvdoHuEHJBNA3Hg7ImFb/M
         Zn286EXo/Ec9RBzJQ3MAPwYOD8FXr6Bz/XIFILeNcF6xrU8qSWZdqwArxp4ONjW3BndO
         Qk9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759230007; x=1759834807;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BW2Qtj+KVSZo32MbcvWapFjwhM8eljdM2/EMaeJKXfU=;
        b=PU9LsSzJM5L8+/FrD4XcPqhMLnrsz5S/eU23ibqQbIWb8gMcfTR/Gx9+9kOOz6OAGO
         8JtCsuu7vHK6JEa3id1FheN/Zojp52oSYJYTViMG6qr6TRzqv+sPW54S+MP8Tari93Ci
         9zeeE+lmJDkTljmdHm/OjG86Jl727klHJEYxCuDduqOmxi3CxVY0AgXTtoX4euqYSqlT
         EVSbLcvxO8fskmKxcjg+qaH4QZTf2EZmx9mqul6J1vT8MMMMKYyX1Trn6SVSQxD01UqM
         JLdag7w5yQQ/XFrySMujesAk2/M9XQbLAucuzzxh8cmCMjnHfNs2YDJYkcf3TpzMy+ic
         rG9A==
X-Forwarded-Encrypted: i=1; AJvYcCVWSENJ1+CkYJtikAJ7LIIhgkuqxSFhLF5Il+VDi2pcI3Hm/R2My71NNYoBQ6xEZWBJDrbOeyw=@lists.linux.dev
X-Gm-Message-State: AOJu0YxeivjPfUHAW7YLK22BlTiCPbBrcH76Df7ZWPK3SkIxjkscicBB
	So0kG4fHq6KGLmDdJ69e8v+qFy1yreYX2nnJE6C9Udz3410O+0ceQWpBltitb1M4yLXMqYu/N2c
	xQyyX8DtaxgCAKWOz5xgr/jzHBWpKA09czh2X2TYL4g==
X-Gm-Gg: ASbGncuGQylou1SA1Rta3PEwIhFjCox54Zg+dkRBsghY0BeUq6bnUTSiKxZNsPrUULf
	1iL7B/YfiVQR89HCZ43LYEIihe1zVmG8Ma/atlk7jyXVvDP82Bak+H0qFOR4jEBFJQkLST1rGtc
	rPY4m1NrKqXUx5NMUv0QIK8PvDXwCCtELxt0FvHENjBuORbtM6rH09vcFwOYD4jfwZux5tuNl/2
	fG9Q7YzzZgyKYNQ1IrwvdEWc927Xt333I+0LrTlxr8WoUOQhiQZ/XUEAcM6mO1TKDyrK22k2Fhp
	vNOA2gmvEpeuQo8dy4XYsLH0ppLO7g==
X-Google-Smtp-Source: AGHT+IHtPuZgSVMGlUzaI5vj/KwcQ6zTwdUWSWUwa6mgNiKsVgXu8raJbRpSbZR/+jnNv3jtSjo9LDhitaHxBXunC00=
X-Received: by 2002:a17:902:e809:b0:24e:3cf2:2453 with SMTP id
 d9443c01a7336-27ed4a89ac5mr212915705ad.61.1759230006932; Tue, 30 Sep 2025
 04:00:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 30 Sep 2025 16:29:54 +0530
X-Gm-Features: AS18NWA_909avJZvTE7jLbzzAOBb2Sb9YrnKfuZvYcjUAeZSImH28wlpR68IqJ4
Message-ID: <CA+G9fYuUcs_-SKWSbiAgyzuhE9-oqSAGDQOU6pTPfwq57+cWSw@mail.gmail.com>
Subject: selftests: kvm: irqfd_test: KVM_IRQFD failed, rc: -1 errno: 11
 (Resource temporarily unavailable)
To: "open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>, kvmarm@lists.linux.dev, 
	open list <linux-kernel@vger.kernel.org>, lkft-triage@lists.linaro.org, 
	Linux Regressions <regressions@lists.linux.dev>
Cc: kvm list <kvm@vger.kernel.org>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, K Prateek Nayak <kprateek.nayak@amd.com>, 
	Arnd Bergmann <arnd@arndb.de>, Dan Carpenter <dan.carpenter@linaro.org>, 
	Anders Roxell <anders.roxell@linaro.org>, Ben Copeland <benjamin.copeland@linaro.org>
Content-Type: text/plain; charset="UTF-8"

The selftests: kvm: irqfd_test consistently fails across all test platforms
since its introduction in Linux next-20250625. The failure occurs due to
a KVM_IRQFD ioctl returning errno 11 (Resource temporarily unavailable).
This has been observed from day one and is reproducible on all test runs.

Reproducibility: 100% failure on all test platforms since
next-20250625..next-20250929

Test fails on the below list
 * graviton4
 * rk3399-rock-pi-4b

## Initial Observations:
The test is attempting to register an IRQFD but fails with EAGAIN (errno 11).
This likely indicates resource exhaustion or unsupported behavior on
affected ARM-based platforms.

Could you please advise on the way forward for this test?
Should we treat this as an unsupported case on ARM platforms,
or is there a missing implementation/configuration that needs to be addressed?

## Test log
selftests: kvm: irqfd_test
Random seed: 0x6b8b4567
==== Test Assertion Failure ====
  include/kvm_util.h:527: !ret
  pid=721 tid=721 errno=11 - Resource temporarily unavailable
     1 0x000000000040250f: kvm_irqfd at kvm_util.h:527
     2 0x000000000040222f: main at irqfd_test.c:100
     3 0x0000ffffbd43229b: ?? ??:0
     4 0x0000ffffbd43237b: ?? ??:0
addr2line:      5 0x000000000040206f: DWARF error: mangled line number
section (bad file number)
addr2line: DWARF error: mangled line number section (bad file number)
_start at ??:?
  KVM_IRQFD failed, rc: -1 errno: 11 (Resource temporarily unavailable)
not ok 4 selftests: kvm: irqfd_test exit=254

## Links
   * https://qa-reports.linaro.org/lkft/linux-next-master/build/next-20250929/testrun/30048394/suite/kselftest-kvm/test/kvm_irqfd_test/log
   * https://qa-reports.linaro.org/lkft/linux-next-master/build/next-20250929/testrun/30048394/suite/kselftest-kvm/test/kvm_irqfd_test/details/
