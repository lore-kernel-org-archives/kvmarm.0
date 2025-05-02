Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com [209.85.167.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4347F17A31B
	for <kvmarm@lists.linux.dev>; Fri,  2 May 2025 03:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746157812; cv=none; b=BJlyteZRYgCzGqiKwHSul/ulasmtEkDpByaiRRM1HJGgPaocWl5QQ6E+4ryId7KFkeoaVund5ITc1a8BrZfWNYT5GWpYKnc5Hn+ySQtTVuDERulaEoxZ3CEyJdBLktJLBY3k9pUgzx1xJaAhVX3Y0y3Ydqsd7gQO7dWBxJqvtRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746157812; c=relaxed/simple;
	bh=yqu8sxN8vXWGWRHsJGlCQvKRYulQkFz+N2frigbjAhs=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=qIY0f4JtkeHxEff+CG/Gl1HonElPh40zbPqrwRtVJ6MACd6Jl9nypOMiXmzFdESyvCs89lQjlnHS+Hb1Te0z67YE7mmQmWYF2k2g5fWMv69kGiyU2MS7dtfCB7mZtjWBrI/pumLwtw9Sv3h/6GfUzrDdi3pUYBP9OxKPFGxSBz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=immunant.com; spf=none smtp.mailfrom=immunant.com; dkim=pass (2048-bit key) header.d=immunant-com.20230601.gappssmtp.com header.i=@immunant-com.20230601.gappssmtp.com header.b=DRBln1C0; arc=none smtp.client-ip=209.85.167.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=immunant.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=immunant.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=immunant-com.20230601.gappssmtp.com header.i=@immunant-com.20230601.gappssmtp.com header.b="DRBln1C0"
Received: by mail-oi1-f173.google.com with SMTP id 5614622812f47-3f8ae3ed8f4so1133264b6e.3
        for <kvmarm@lists.linux.dev>; Thu, 01 May 2025 20:50:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=immunant-com.20230601.gappssmtp.com; s=20230601; t=1746157810; x=1746762610; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=200bRbkNG4RFm4RNlBvwI80KWoLNHSBTitlUXIIUifY=;
        b=DRBln1C0KrIf5MnFYLy3DcjIfyPz/J/Zylo+gIScfWFrn7uDCRrjItc1U5AcuhZaJe
         hDVQb/qHzmcCb+wJSla4QlSi8fNh/K7HEKYm9PvxbCrXtNJ3hELhtNlB04bF2K9cufcY
         BmadT8dTJUzmoFLBf4pLzmhjh36+w19hegU63YO4aMY0C38pjjKNPfgiUpMxiwEdw0o1
         kjx4KR3R6/qvRNhm3f6Vc/ZkYJrS65nBs5MK8rjVegIP9TsbyPEyTrPuWaja6KSTwKAs
         erllCetaQNOHCcVKCseyGiVGY66fM0Vkm8NGiEGhaAeiZFOgC7rqxutnCMTWqwuCy3re
         rwHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746157810; x=1746762610;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=200bRbkNG4RFm4RNlBvwI80KWoLNHSBTitlUXIIUifY=;
        b=uNmYB7KDxtnShP1ZDFkzeJX8I8BgNS+8z7dFsdQujShkg7ZR1ydWCXrgDVB4xTJ4C4
         cFi6XoZhzhdFNBpYEewbLH7qoec1fwmS0dyxG+gF7gPVhP4jnpUs/IVjptheKwk+2c+0
         hsXBUFu6Vr+jmQFRVKV4YwEQl0zEfNrXkunR92jhzw2gmy0iBTW1cIaguLTIfep/5Adt
         izuy6GTTq2rS2a/+sh3dboidQeEooB72zpeYrL6oZKeYL4CZ9t/rNeln4ehXf/8ORN2y
         LzwZbUUk5eXmN22LtpDpQ8eLkkW0V+ABoy9oD803igzIK+YPrf71qFoxDxxCSEq3S4s5
         8xqA==
X-Forwarded-Encrypted: i=1; AJvYcCWbadYQOKOY0qv/bKdsRubeOo7Y5S7vxhlHNffpW6YWaRquBh8ED73/IlZNLXdB7NvxlDrnGfs=@lists.linux.dev
X-Gm-Message-State: AOJu0YzcXe6yVhCCZv/HTeqZqPWYeh+IJC69ZsR//IMqz2FZIa/tvP7Y
	w/z4XHXOLhf58/v05/JIHcArt2whl/KN1AZcqjB0SURvwown/F1RelH9L/BigZfX9oM5PwGH1ys
	nOBgHiliSub3KnBrtPXcvCX70N6jE6VjAGmaCNw==
X-Gm-Gg: ASbGncukXgJIY4A8YQyZxgLf26uzgQTBKFwr2f7oh4dEl75p3249gElk0dP7aYwdW8W
	j3I4PzAdLa5vUlK1cCoclUSzAiu8OnPyR6mOJQTwo60sC5Cs5+gRU5Gikfb2Xg+dpgejeo3sdwH
	yprenI8PmaA+zOAgdfXw==
X-Google-Smtp-Source: AGHT+IFWDH1QH7ebTs8UuQsCRHiO0kkjYVbdpD1lI2qZLhDSsrRH3ei2huvBBDrcoqitjfmO+306hZ3bUjGoQYSjf1c=
X-Received: by 2002:a05:6808:4e11:b0:3fb:a7d0:3b1f with SMTP id
 5614622812f47-403414c0ac9mr902368b6e.39.1746157810107; Thu, 01 May 2025
 20:50:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
From: Per Larsen <perl@immunant.com>
Date: Thu, 1 May 2025 20:49:33 -0700
X-Gm-Features: ATxdqUH6DSpDNWj9GH7IVvgNReOtTawW4yUp6qlFfnIUyWLaN_WIyzpu7vU_EyE
Message-ID: <CA+AY4Xc7SEhSd-zQzhDnuewEOksxEqDHarcHzDwp-_SibDu2pg@mail.gmail.com>
Subject: [PATCH 0/3] KVM: arm64: Support FF-A 1.2 and SEND_DIRECT2 ABI
To: linux-kernel@vger.kernel.org
Cc: "qperret@google.com" <qperret@google.com>, "sebastianene@google.com" <sebastianene@google.com>, kernel-team@android.com, 
	"will@kernel.org" <will@kernel.org>, maz@kernel.org, 
	"sudeep.holla@arm.com" <sudeep.holla@arm.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, "catalin.marinas@arm.com" <catalin.marinas@arm.com>, yuzenghui@huawei.com, 
	Armelle Laine <armellel@google.com>, arve@android.org
Content-Type: text/plain; charset="UTF-8"

Hi,

The FF-A 1.2 specification introduces a new SEND_DIRECT2 ABI which
allows registers x4-x17 to be used for the message payload. This patch
set prevents the host from using a lower FF-A version than what has
already been negotiated with the hypervisor. This is necessary because
the hypervisor does not have the necessary compatibility paths to
translate from the hypervisor FF-A version to a previous version.

Support for FF-A 1.2 in the hypervisor is added as a precursor to the
addition of the FFA_MSG_SEND_DIRECT_REQ2 messaging interface. The bulk
of this change has to do with the upgrade to SMCCC 1.2 required by
FF-A 1.2. Additionally, unimplemented FF-A 1.2 interfaces are added to
the list of unsupported functions.

Tested by booting Android under QEMU and loading Trusty as the guest
VM and observing the SEND_DIRECT2 ABI being used successfully during
guest boot.

Thanks,
Per Larsen

Per Larsen (3):
  KVM: arm64: Restrict FF-A host version renegotiation
  KVM: arm64: Bump the supported version of FF-A to 1.2
  KVM: arm64: Support FFA_MSG_SEND_DIRECT_REQ2 in host handler

 arch/arm64/kvm/hyp/nvhe/Makefile |   1 +
 arch/arm64/kvm/hyp/nvhe/ffa.c    | 235 ++++++++++++++++++++++++++++---
 include/linux/arm_ffa.h          |   2 +
 3 files changed, 221 insertions(+), 17 deletions(-)

-- 
2.49.0.906.g1f30a19c02-goog
