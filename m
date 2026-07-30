Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ADEE38644D
	for <kvmarm@lists.linux.dev>; Thu, 30 Jul 2026 18:06:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.216.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785434819; cv=pass; b=U7TPZ0caWtmz6QclGkRCrGUJ6HqwLKhzkMM+v3C+f2sX0pq3GL3i6F4vmxwq/u1VFJs7z6hcjlLJ6sVeTOTAM4H9QVr0UcOREhppEvfKuZe9S0sAQg3l7RgK1mQmh6ygYai77eOWZ4lxT+vjX8mkdN81Tbxwcb7uEJch8qyQvCo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785434819; c=relaxed/simple;
	bh=dEihRTHtQ5+rqzTB5gZENLrIKf/vdVkf+94K6FYyTic=;
	h=From:In-Reply-To:References:MIME-Version:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fWc5sF0qy4GeS8rKd1gH9evTVpWI03DASnXGamkvJ1I3FlLDcY9UE/ehUfGWljvaiBk6OnLP8Tyruak8QX8CsuoAV3NrsEarJNcpHKewPMgyk+WQ4bdFC51xpSaHYo/Ci4cnLe5kKh1yrJfANV9mGwD3ZIsQyyQY8tU2ywXG654=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pAnY8WxG; arc=pass smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pAnY8WxG"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-38e88b60121so145803a91.3
        for <kvmarm@lists.linux.dev>; Thu, 30 Jul 2026 11:06:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785434817; cv=none;
        d=google.com; s=arc-20260327;
        b=PwZbYxPqSAgZlFqZaw5Xdgi24tsd+KYuBpiHl4n8S3U2TopZNlX578nc8PuSAeYlYL
         wkzzqKLJOTXfMrjOaCJX4s83hltByCnymFKDs+8gh4x7DB6joklMDOiWhmMWdl4NZ9kO
         f7Q3JDHn60y4MFjPeR45x4WQD8QHUxpwWleQye0Uw8+kh30YuC6CFZaTuLZmtx1f2fpM
         7HfkexvErRZvTDm4s4dgv73YGYu0CCajf8j0QpQW6gluY0hSB5kjoQaKrqBEtzZWM/cR
         ThLUPPizhY73rdiAwgO1MduDAsr7lZtmjGIMzpFeGorWgXT0+ntdpeFMBtxDyuH6FfMK
         He/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date
         :mime-version:references:in-reply-to:from:dkim-signature;
        bh=ksA4Cb+zc98xgjMVnrwp9nVxjWZKE5S3Fc2xP42UsGM=;
        fh=k6iBIZgjKkaR7H8eKFbRgpJzwBTBMQqV7Lk5KMQwZo8=;
        b=iQpevLBAM8X5ep+WUAYgBPy4yIZNjXwA/X6RlL7B+O5ILhjsbOV3GVHVfITftllQWV
         Jnb7TwvpUQaBPmsse181Twd7FyZA7OGFHh/LP5bsro6yvgCOBVh95xkAPlCJswLhBczP
         K+zjv+WQk6gHJ9uU2jA7gfDdtW65wSHUnPpZeUgjR7GQPzREOU88mH9Cn9xBZeHquon2
         F+xQbdq6dDmR2AYgxXL7GH+vOi1BARWwOuNDbGbnmbsVT9UFFQyRcNAKAXwUqKCTgamz
         jLW6zisUjiIhNdAdLLNgS/7JBc5v3SpK0wjDlQkHh5pSphmnFKXQ1SEXaJxjdHII6YQL
         o+iw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785434817; x=1786039617; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:mime-version:references:in-reply-to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ksA4Cb+zc98xgjMVnrwp9nVxjWZKE5S3Fc2xP42UsGM=;
        b=pAnY8WxGfvG6N1h613bd88k/mfYc1GXrzS58NWBzY05pphx/nQsMPuKMMFnnNsu/wi
         Q/V4yeF08sea8ivyO89YcdUvY6fghdOvGO5nZizS1E+HMqrUk17I1MBd//KGYFubahoq
         +upRjTjrvgBteV6AiaFG3BSfdhQMv96fb3yCZeH8arUTH9UJas11UenUpWvAvN4eUg4b
         93UZSgKPFV4B8QYQP4BbvrjZTJS+NuRYtn9v5t03uJqbv0MNs3PlGcZqt4Qo6LtJUPZ3
         YGV3SjLOZji4wP79aDy02CL34roT7X5ziYrOe7bbQeXIc+eCfqI+mz9lGr/p5t24v3Hz
         /ELA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785434817; x=1786039617;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:mime-version:references:in-reply-to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ksA4Cb+zc98xgjMVnrwp9nVxjWZKE5S3Fc2xP42UsGM=;
        b=ica+rzzOaNn00l9qkGp5j1qXtmDfprMQmzzE4P6NsxWorHJsUvsOWXrsOCnQozILXy
         XBD5iQCAXXKR2TAY+mPPOBmD3foXfwwVjVvWGtu1xhoj63DGCbtja2WnjVHZiIBQeu9h
         1HOJerwAgj9kPu0xSrijknk4OejZR9aM7kSOFnA4PnI4fPcHZhGm54gRaVbgFhyj9gSg
         ilXzBDdQ81MzQe5TAgjcZvqUhh5a4eh3VeZ/LLJvHbHpCuUBmyXufY+rpu1CLkcz6qZO
         +foO7Cuj57IZ/WjquWCDfswyI5z4GODgkHwXGl9V23ZcAyYpuxYMo2aJbun91nhIHthF
         6MrA==
X-Forwarded-Encrypted: i=1; AHgh+RodUXsVVW9BDGwwzUdxmfTJnuguLmokWs/n9Sr3YprFm5opjQqfjEBKzzxEIw/1Ai+zx1PpgCk=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywp3p7rkeeb3AS7mHE3GFz1E1IsrMYOP9hoNfUBfAtV6yj1ys3p
	2luLRTMRdrhoWL7gbxZbak2QtG2rdTR2EGoBTWZPk8Fm6soxcEFZm7jLiDV/jXgZm2WhSy803fC
	VCT1qAaq3QxT6h0VTUp8MUjmorNU9R3wP67phtrun
X-Gm-Gg: AR+sD12+79czYAN2a0lXAVlJeFwjP7TPUDyXCzY51nxWT3fbeLVJpSrttfOqEE7cgRV
	RxYGA47538WYqpEGgUPpTkmnxgqhjr9KxVT2AmL+baD/IW5KLZNNhQIxXRnhRJto6hwXAZXyVDq
	8Heijas2Ab/oE6wLOwovsQilt0hLP6xJ3PpnHMk7braKGpKas3yh/0lHnxdePJgOwTuFf7YyIo3
	Jsb2RjEMsuEmXu2zJZyArFtuWAWtgbngAu8QwQ9NjFYsBjUirp5KsyDTMPu+UoA9clcl/JwcrWw
	sBZ427wFu7+3h4UQMC7X/gXQkBruensaTLad9qXFu1j2367fZoKKOiYdB/SsoiXBw33olM/75Y1
	i4xZWUGKSiviiu7MHPwNOT3IqkJIhXgCUEuAmltjKmlct
X-Received: by 2002:a17:90b:4424:b0:38e:2517:5d1f with SMTP id
 98e67ed59e1d1-38f9bd3e096mr2908488a91.9.1785434816901; Thu, 30 Jul 2026
 11:06:56 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 30 Jul 2026 11:06:56 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 30 Jul 2026 11:06:56 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <20260728122245.AA83D1F000E9@smtp.kernel.org>
References: <20260728121138.1103610-1-tarunsahu@google.com>
 <20260728121138.1103610-2-tarunsahu@google.com> <20260728122245.AA83D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Thu, 30 Jul 2026 11:06:56 -0700
X-Gm-Features: AUfX_mxg8N6Cgn4jHI_wA550VSPb-h9Q0N7SiD0v3YCrbcFHGVvI1NAH9Wyaw3c
Message-ID: <CAEvNRgGHuiXG1KZ24+kX-ZgTS_rqGPFqJMjoJhqf6GpZh4xN3g@mail.gmail.com>
Subject: Re: [PATCH v4 01/11] liveupdate: Add LIVEUPDATE_GUEST_MEMFD config option
To: sashiko-reviews@lists.linux.dev, Tarun Sahu <tarunsahu@google.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev, 
	Oliver Upton <oupton@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

sashiko-bot@kernel.org writes:

> Thank you for your contribution! Sashiko AI review found 1 potential issu=
e(s) to consider:
> - [Medium] The patch introduces the `LIVEUPDATE_GUEST_MEMFD` Kconfig opti=
on claiming to enable a new feature, but there is no actual implementation =
provided.
> --
>
> --- Patch [1]: [PATCH v4 01/11] liveupdate: Add LIVEUPDATE_GUEST_MEMFD co=
nfig option ---
> commit e0c3fde657d56c548cd9a7467d2143f0f42c5242
> Author: Tarun Sahu <tarunsahu@google.com>
>
> liveupdate: Add LIVEUPDATE_GUEST_MEMFD config option
>
> This commit introduces the LIVEUPDATE_GUEST_MEMFD Kconfig option, which a=
ims
> to enable live update support for KVM guest_memfd files.
>
>> diff --git a/kernel/liveupdate/Kconfig b/kernel/liveupdate/Kconfig
>> index 1a8513f16ef7c..0bbc4037192e9 100644
>> --- a/kernel/liveupdate/Kconfig
>> +++ b/kernel/liveupdate/Kconfig
>> @@ -88,4 +88,19 @@ config LIVEUPDATE_MEMFD
>>
>>  	  If unsure, say N.
>>
>> +config LIVEUPDATE_GUEST_MEMFD
>> +	bool "Live update support for guest_memfd"
>> +	depends on LIVEUPDATE
>> +	depends on KVM_GUEST_MEMFD
>> +	default LIVEUPDATE
>
> [Severity: Medium]
> Is the implementation for this feature missing from this patch?
>
> The commit message notes that this patch enables live update support for =
KVM
> guest_memfd files, but the newly added LIVEUPDATE_GUEST_MEMFD symbol appe=
ars
> to be unreferenced in the tree. Since there are no Makefiles, C files, or
> preprocessor checks that use it, this currently acts as dead code.
>
> Could the implementation be missing, or was this intended to be introduce=
d as
> part of a larger series where the symbol is used in a subsequent patch?
>

Sashiko is right here, I think this patch should be squashed with the
first usage.

>> +	help
>> +	  Enable live update support for KVM guest_memfd files. This allows
>> +	  preserving VM Memory backed by guest_memfd file across kernel live
>> +	  updates.
>> +
>> +	  This can only be used for the guest_memfd that are fully-shared
>> +	  and pre-faulted.
>> +
>> +	  If unsure, say N.
>> +
>>  endmenu
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260728121138.11=
03610-1-tarunsahu@google.com?part=3D1
