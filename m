Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7091B2D5A0C
	for <kvmarm@lists.linux.dev>; Mon, 21 Jul 2025 14:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753106453; cv=none; b=UheSHTGXNQvigPimeDXM9fpqN3TMC0lwkV34aMkOWCjWXTKy6Z7J31hH6XeZxWeWqOAqupojnQVvJ+HO/LKeS6Zaq29dWROtkYgW2mmseQey2J6H7jse1HKbAi9A/StcJvZQJrIDc6z6ykHWy8KRWN6Mfr+tTYDibT+WqQdhcao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753106453; c=relaxed/simple;
	bh=1PQZ5wEHcoCEtER0af1nZDuJAWLlSAlkcq8MdPvmiaA=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=kB77WwaAMQNsysMR6g1KYnWn73Eq4HrZnH59X+y7e9JuVRfaE97WWoCUDBFSvn8axsMrcnSn3gPdX0r5xArB2280wgrbotZbxu1S3vAgIb+Pi6+GRZp4bQVPc0E4i+TL2u2G/fv9HDgxZSoESv8dcuVeU2Qxtt/sSDlSzmZMOsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DlcFocKC; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DlcFocKC"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-456007cfcd7so133255e9.1
        for <kvmarm@lists.linux.dev>; Mon, 21 Jul 2025 07:00:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753106450; x=1753711250; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=r0VWK6cB9v+a0NyyEJgT96YS0NmW+Gj3bVw1g3G7ew4=;
        b=DlcFocKCoCkN2L6G3ryc6Ef8PkPhrf+oYSk0QEzIiGruB3veID4je8tW62KbQ3di8j
         jBdQEYTTbhYSazyFN+vRwqJZo/yAb9LgKySePEXEqcP8jf8747glySs3iSNhbAlnfg8z
         SXkY0kPVQqC8r0QlwhNThsPwU2Ccr2dU5XIBXrjJqQ2FGtqXHUvuz0AP7p5DAEW95Njo
         7sIchL9U6dbN47AWaoz2iX5U5Bu5s4nrWQIY/UVCw9tlW7RFiuTc/4Sa9FEtVbxx8MUN
         Y6NER103fVAPo2g72zbGxtV4cNkTXOaHF4oRcnFc9UKr1qnUyDws0BxlbGyPi7wJH69c
         LDvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753106450; x=1753711250;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=r0VWK6cB9v+a0NyyEJgT96YS0NmW+Gj3bVw1g3G7ew4=;
        b=CyPBSF+OOTUggs0y+HWpjdkDnhUp+f+ZBpDfWryYLkKsoJHsDr+dfOr98UavUMD8zc
         pvEzIc2+5uuAcWxKWt8I2V9rJp6jxiexK2+Lqn70mr3+khqRcfpz8HEWj1oirXAzVP8t
         aeDQ8edPW9fyg/Yj38h1ylcyZd2gP57Bw+5QmJ4/YFjnjZQvDW4WhNL96Q69j6+YPvub
         8u57dmO+8U4WleZAD+SScDt6Zr4ua4gNEldmfuvwvypIzyUR5KEK9cKzkUIKphAR/zg4
         j2nd1QK/XhhRv9lRno57QIhgosJjbPxzHhdfETG9onXO+DkZnCKwOwUqEBC8E8dtMu4Z
         pqjA==
X-Gm-Message-State: AOJu0YwM/CgZZQXOUMce3ufmbWxht8dI9i03AWrZ8O8zv9gA2+nuRxMB
	cgizG0NDcYV+QYi83Zb4yBOFnke+Js5zZiBainj/Vh/iAFqkzh4CTrfYJoGu9ywcpsp2XLXTPA4
	8P2Y3nM20UcP6c+BWlG4YG1TUOOc6O5QZauuQg+K2
X-Gm-Gg: ASbGncv5HMI2IKLfeBwI+xd0tgdttPbEmr+nH7p3r74zvNvKQgOaEcYwFEGMKEhw6Gh
	vjgjoTm+yGinF+NUMvEw8ok/untxHr1NLCi36VV14jof4BQHXG+SsbctcBKRwrqV8fu2Q73yM8u
	LEE7TQuvhQCPFhUdoD8QrYw3WnIKv+QuYOZ69tXcGl4DKO3sPsP+QP+jfLuNOnjeGU83o5kBYEf
	NdxGSK2J5VF9W/u7nmQPK+VqwFA9LHacawYF05v
X-Google-Smtp-Source: AGHT+IHzrPlFuf9cksmZ/Es+Xf1aPI79vfvoqBBLKfiQw3E1U+weKYQAyTKorgpdHvEuDDhSlkSHEj7XF78SYKtS+o4=
X-Received: by 2002:a05:600c:8b81:b0:453:65e6:b4a6 with SMTP id
 5b1f17b1804b1-456428e598fmr3424825e9.6.1753106449459; Mon, 21 Jul 2025
 07:00:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Mon, 21 Jul 2025 07:00:00 -0700
X-Gm-Features: Ac12FXxRlhkToUCbXGkOTjf1DAqkBtxHHrS7fMi_NmUO7y_c0p3cGBlWugT0e_w
Message-ID: <CACw3F53VTDQeUbj3C75pkjz=iehbFCqbrTjYbUC3ViUbQJAhsg@mail.gmail.com>
Subject: [Bug Report] external_aborts failure related to efa1368ba9f4 ("KVM:
 arm64: Commit exceptions from KVM_SET_VCPU_EVENTS immediately")
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Oliver,

I was doing some SEA injection dev work and found
tools/testing/selftests/kvm/arm64/external_aborts.c is failing at the
head of my locally-tracked kvmarm/next, commit 811ec70dcf9cc ("Merge
branch 'kvm-arm64/config-masks' into kvmarm/next"):

vobeb33:/export/hda3/tmp/yjq# ./external_aborts
Random seed: 0x6b8b4567
test_mmio_abort <= fail
==== Test Assertion Failure ====
  arm64/external_aborts.c:19: regs->pc == expected_abort_pc
  pid=25675 tid=25675 errno=4 - Interrupted system call
  (stack trace empty)
  0x0 != 0x21ed20 (regs->pc != expected_abort_pc)
vobeb33:/export/hda3/tmp/yjq#
vobeb33:/export/hda3/tmp/yjq#
vobeb33:/export/hda3/tmp/yjq# ./external_aborts
Random seed: 0x6b8b4567
test_mmio_nisv       <= pass
test_mmio_nisv_abort <=fail
==== Test Assertion Failure ====
  arm64/external_aborts.c:19: regs->pc == expected_abort_pc
  pid=26153 tid=26153 errno=4 - Interrupted system call
  (stack trace empty)
  0x0 != 0x21eb18 (regs->pc != expected_abort_pc)

It looks like the PC in the guest register is lost / polluted. I only
tested test_mmio_abort (fail), test_mmio_nisv (pass), and
test_mmio_nisv_abort (fail), but from reading the code of
test_mmio_nisv vs test_mmio_nisv_abort, I guess test failure is
probably due to some bug in the code kvm injects SEA into guest.

If I revert a single commit efa1368ba9f4 ("KVM: arm64: Commit
exceptions from KVM_SET_VCPU_EVENTS immediately"), all tests in
tools/testing/selftests/kvm/arm64/external_aborts.c pass. I have not
yet figured out the bug tho. Want to report since you are the author
maybe you can (or already) spot something.

Thanks,

Jiaqi
