Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEC883254A2
	for <kvmarm@lists.linux.dev>; Mon,  4 May 2026 20:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777927924; cv=pass; b=YJcadkI9RgJY1tV2T0ObvgxnphBpuvMzjS4mf9q9GcgglkYIoAgNu3Ynyr+aDKf1dAx8+8M+IxJdsKk0O/J2MGgpNjXy5tA84JFIw4hv5m49WDYS3ybe96Vr5jxSSbnqjYB+VOa9yqzGcUCHn87tDoA1m13Z9Yb+QDRnJLq/zC8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777927924; c=relaxed/simple;
	bh=tJ66m+Ap+y9oidCE5FFl7LELM0PChA2R+pYpwfkimac=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Cra8CcEzkBM+2pTVcmf/PEC3nIwWGbxoJ1qXBJpmKGwejxK4Csn3ankKFQO0KfZjvfSnOdDdclH5btzW7x56gDJet4z8G6N2XkSVxeR9SXUmXa1Q8+puWVNWsaqaY47RZqaryB0/6mH3lxascBHv30pEQOnZYmqawhvk0VUyw+k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=QhS/Yd2k; arc=pass smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="QhS/Yd2k"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-8296d553142so3406066b3a.3
        for <kvmarm@lists.linux.dev>; Mon, 04 May 2026 13:52:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777927920; cv=none;
        d=google.com; s=arc-20240605;
        b=JpJ/ChrU42qB+JiRABKWQuR8GfUYPCebP0SmaCgfZ/eWNT66xBRSqx3zSHIXZvJxss
         wmBC07lLAfRYR0UEvVJyvJ8XLpiyxEBlorWbkwD3oz+/VxZlM1TFjWUMScTcsGwlZXrQ
         QrzIVusw+PBudhuenZ5EgLTucsgFYXv5x4J9y2t4iVHR2u56qyBK9S1CFm6DFH8gmS2L
         W5rwgGxc99LvAu4RP6rkQl8rvyXl70UW9/XOpIN48IY53gTZU5HqfCcu48O39bJaa7OS
         wfKAuDIAluBSBxYKI7jflbDWKryFInjZI1FrkuJx0eAhL2HMLZX0kq2CZlHuGfhc5nrz
         U6cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=WJ2eAXPYNTEsOYZ4v8rz7h3jNo4Zy8g4wcsmv8Syleg=;
        fh=NZPXrjFVFktAJge4WZ9LKVROb8sZ4rT5phfs/xMK5YY=;
        b=K/i98FjBlxtfeiG4xZUzi5uRpCju98LjMr4nymWomHe1+h+H4hiDr2kDPBgHM45hmN
         pd7ic/Ovo0upWqt7sAHEYovCSCXknG6lPkYxZe3/v/dIy2/9PVWkySCQAfa56pqiZdQe
         t2GopFmQz21TtBfHUMu85zNDFXk8ZSa5WE5W/deCdtbx4Tf1NIIhVTCI/R6Nz1xx3Bqq
         FcTu7BgxVdwQqCSG+owuxIDeWvwpMeKOjsoiqLX0yul2AvCpNPuGZDd1scewKZLisc4e
         BYQv1gBFdtzlWbTYdH0afW6guoDQL45zs7vS2OtNXBLMAVrXLChI3C4MT+QbRsE/dB/C
         Uzvw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1777927920; x=1778532720; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WJ2eAXPYNTEsOYZ4v8rz7h3jNo4Zy8g4wcsmv8Syleg=;
        b=QhS/Yd2k89olOit7dnfFKM5Xuzz23j6cGv7Ob4Ic6gf/d9Ng4Uj1crjVUyvLoAUUkl
         BOa0P1R934e/BAOuKxmQGVq8538d6El8AtFSLw/MsZzQkT+wdYDpsdFnASmIh61lXVs/
         ARp21FPuUQzU1Lgi+zBObwqHat/m20XZzTlJJkWrHXZkrsj6XALIw3A2+1OiQasntVmJ
         wJSdJp7773pUZReqWoq0d6yfNIEYIG4NtD6hcMyW8cOv00N4uBdiuQosCmUQpVsfndKD
         YQvdCwdldQx8IKl/SsoZ91eIimQkbpleWtCfCB+r607vuoo1M0Urk/YPebjR4BLjWK9k
         DGHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777927920; x=1778532720;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WJ2eAXPYNTEsOYZ4v8rz7h3jNo4Zy8g4wcsmv8Syleg=;
        b=b+9KbeFbinemNAHELg7EWJh+JYEDfG1khvA8ToO73wa36kQW3G/X7XXJ7avy1YctAm
         Ia6NSEbepUNh49/5R6ZnlScnWYqDxguHWrf+u/a48pdnerSlEdUiIndQJ73/6y9XoaOm
         /EP/0SG4aQN5hBPZooDCglLV+jJeNUGOwQk6RQuE73nW5A7Zt8kpu59paTZvEiA8Kf/q
         Xyf+Li8sZg3TwQr91JTJ+tCq8EEYy1RnnkLLhe9ABVYpnGR2aeSjq6FF04D4Wylbg74s
         uCGQt3af0Yrlz1m4T9WdgbgV0sFJzRrpEOsl8tPdA0v2EInjCz3x0P2mIy66dLtPC4Qg
         /jXw==
X-Forwarded-Encrypted: i=1; AFNElJ/KqRIoKFiLmlGqyIX2FU7gVSwM1RiHZ6IGQAmFjHf8W9H5Mnvz15tXt8FFlYMBzGSUdzpSH5w=@lists.linux.dev
X-Gm-Message-State: AOJu0YxF3/T4G7xGcQ4MgvooHFJhIJW80qUSz8dYRZPEoZtrERbMD8US
	PdjU1pcy5qkhyvTZxuVGffUxzdXhoBDZLDVZes8Pbh+WrG79jgeoWll8ucsJ3M0N9omMxXydZA6
	1hca+Qv5mXyobr9+wc/5sMwJo5zB6SDWmnW/dTlNj
X-Gm-Gg: AeBDieuCsDXS5AEKjJJXyzLnwVOH9lOjXU4iLf7OPtgOLwdeXfe9hAbwwpXZSwLmUSK
	jjs3PS0SwhNzcdML1ntOT02ufuZBUc4mH7QWsbDf1kVqyXZqJ0Wi7Ts/WCVLRt2Xtk+l5w0y+Ps
	SOa+oTz/RpOoDE1Ui9X8rgJwiTLxCLXErL/PUydj9O7oB6irZpHQmVPSpgY2joWQhZtEDdENvhu
	tDpaLzURkLKihf/EJNxbTKJwjkibXLN9hqlK/yMVHAnzhC/GZz7408m0acqhRbUw4yrcPAf8R1b
	YfORUa9OiYp2ulcjZQ==
X-Received: by 2002:a05:6a00:430a:b0:81f:852b:a925 with SMTP id
 d2e1a72fcca58-8352d03bf06mr9580368b3a.1.1777927919687; Mon, 04 May 2026
 13:51:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1777036497.git.noodles@meta.com> <7734099f5e7fda5480bca016a9e6707983325fbd.camel@linux.ibm.com>
 <afMlgstqahnZg68h@e129823.arm.com> <9f188536f09a2db30877d6bfbb84aeaf2565cccf.camel@linux.ibm.com>
 <CAHC9VhRsnmPp2KmQAns5uq5qXX5EF2xQQzyfTgrPi4O9AXyPpg@mail.gmail.com>
 <ba4bf28314b679474a6a8da6298e548e54b3754c.camel@linux.ibm.com>
 <CAHC9VhRE2kRr1fdDf6xgQgpSrtvqtP8Vy9LVGJhDZFUbzLKGmQ@mail.gmail.com> <ff28c6dcb60c357c752724927addaa8c4fd3bf2c.camel@linux.ibm.com>
In-Reply-To: <ff28c6dcb60c357c752724927addaa8c4fd3bf2c.camel@linux.ibm.com>
From: Paul Moore <paul@paul-moore.com>
Date: Mon, 4 May 2026 16:51:48 -0400
X-Gm-Features: AVHnY4Lr6yzqiFvtxlogRXd7Q0IQ_OqPkojIvu5hlaN_AhoE9caMVXM731mJvc8
Message-ID: <CAHC9VhQY2TMkTvQq9P8oZteQWQSr7qq2utOuH+pdVx+8jWLBCw@mail.gmail.com>
Subject: Re: [PATCH] ima: debugging late_initcall_sync measurements
To: Mimi Zohar <zohar@linux.ibm.com>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>, Jonathan McDowell <noodles@earth.li>, 
	linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-integrity@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, jmorris@namei.org, serge@hallyn.com, 
	roberto.sassu@huawei.com, dmitry.kasatkin@gmail.com, eric.snowberg@oracle.com, 
	jarkko@kernel.org, jgg@ziepe.ca, sudeep.holla@kernel.org, maz@kernel.org, 
	oupton@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	noodles@meta.com, sebastianene@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, May 4, 2026 at 8:03=E2=80=AFAM Mimi Zohar <zohar@linux.ibm.com> wro=
te:
> On Sun, 2026-05-03 at 12:46 -0400, Paul Moore wrote:
> > Regardless, assuming you always want IMA to leverage a TPMs when they
> > exist, your reply suggests that using an initcall based IMA init
> > scheme, even a late-sync initcall, may not be sufficient because
> > deferred TPM initialization could happen later, yes?
>
> Well yeah.  The TPM could be configured as a module, but that scenario is=
 not of
> interest.  That's way too late.  The case being addressed in this patch s=
et is
> when the TPM driver tries to initialize at device_initcall, returns
> EPROBE_DEFER, and is retried at deferred_probe_initcall (late_initcall). =
 Since
> ordering within an initcall is not supported, this patch attempts to init=
ialize
> IMA at late_initcall and similarly retries, in this case, at late_initcal=
l_sync.

Okay, so from a TPM initialization perspective you are satisfied with
a late-sync IMA initialization, yes?

--=20
paul-moore.com
