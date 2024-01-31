Received: from mail-io1-f73.google.com (mail-io1-f73.google.com [209.85.166.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE5E917BD7
	for <kvmarm@lists.linux.dev>; Wed, 31 Jan 2024 18:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706726294; cv=none; b=gdZ13Nr89GGXepiN+mXMdwhSjohC8NG8zLlBIzEdSSRKRFDihpqVLbKyY7K182BoosmwX1zVzctHW8R/IjLUKPOu4DL48A78wrpyOU5TdPBc+0tUA3sxmC3dF9nxHt6t+89bLJQMzXyV0l0XzU9WX/CSz38AqoBymtEbN2Go6Os=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706726294; c=relaxed/simple;
	bh=UfjYc4q1VOylXIyltW4pByW+ntMGUUi2w22Mn2XGXdw=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=XrAQBAM/e+cOQVDgIl1agn0ZZ6YhwgWJbv9WxAm+RU6PT5XKVOfaEIPOAKw/v2RxuwX9rjcUnZ8C9G5/+I3w8Ulxq0jTXo5JcNsvck8jOlmPpfBC2mcss3rpGa/RfAeyMFL/9lS5rT7hpWMpL32H0TK+8rVABurfP6TlZ7EfW+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IPTL/wvS; arc=none smtp.client-ip=209.85.166.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IPTL/wvS"
Received: by mail-io1-f73.google.com with SMTP id ca18e2360f4ac-7c018ee4e46so4861939f.1
        for <kvmarm@lists.linux.dev>; Wed, 31 Jan 2024 10:38:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706726292; x=1707331092; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=B+7qh5lgqKvRJ5XTxEYs6sYIXkTaK5rzWchXA2WiWMs=;
        b=IPTL/wvSPs4/kof6uHF6UgFA/U5Nk71F6ZgpYw/dfQLntVUjukIKVc0esupEWow7Bz
         9za3qZUq4eEsI7OinyhmZFimy9fPOgtCq1vbhCBWzodj5MflYhXS/0A/zXJsJPNUU4k1
         fJazSQRlsBMRLAnB/GGxJAUzgu9hxhbbcUYrHy0vN12h5RmfMRFiIsOLhk6LISPWjvhV
         FqDTaGVG2mxqM39PRmoeThEYFYEhF5K7Xx+80ZO3YvnTaJOWoFF4oFR+1FYPninRUwNY
         S4Zbb+tT1S3cBBG3iEGwxAyRkLSE0wX8LnGqDYXdfinNuPR8hzj9YtUH2l8yvceAr07A
         rq0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706726292; x=1707331092;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=B+7qh5lgqKvRJ5XTxEYs6sYIXkTaK5rzWchXA2WiWMs=;
        b=FEwDXHKAgwwoRihN7c8+orUWIjcuF8wLDmZNEbzX31MBRkBpicp9xFXyrdSV44Uwbo
         /F6EjUm1Seh6KnOD7xokTfxCJYBiYv4YnWXTPPYqVDJps8eJtfiIKQ20394d301xNzTT
         uWzbjh34lwl9dieBd+xaQGLXcf+WLjpBFq7ymiFHKfGRsXYPvNPPv/n+vNHTlgNmgczV
         CWY7xpkbNT7h139nCmyOVMBBR35ot7hRgPIuVVlsEWDtm6nS4RbVcoNHvOwSmWpr6ej3
         Wi70osMtn4LcOWDNXHWl0M7sRrAF84N5jFFlgYheLkVB6ki6Snvgqnm/vxTFFNnFBEhc
         3/Tg==
X-Gm-Message-State: AOJu0YwEIh4m8JcGwmkGQVzOk2tLIVVbDUFPGadURXYQFw9Fbk5BO1ei
	/iDi1PYOAAFKGOQ76PMe1Xl8qIlc88S5QbAOHvu/HrRkmqgF6OLQlkCMDHdF7Ht9d0y4qdiUvkT
	cnCoUm2R22l1Eaesv9/VYgA==
X-Google-Smtp-Source: AGHT+IEWULPllFBaQ8dQeEAuZdnKaMWtTDPxrWTLe4io4YQ7kFWLbe1eQTSY5SCp/s+Zau2KSwPR0XFYd0AUCsyFhw==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a5d:9c07:0:b0:7bf:ff87:209f with SMTP
 id 7-20020a5d9c07000000b007bfff87209fmr25977ioe.2.1706726292022; Wed, 31 Jan
 2024 10:38:12 -0800 (PST)
Date: Wed, 31 Jan 2024 18:38:10 +0000
In-Reply-To: <Zbgx8hZgWCmtzMjH@linux.dev> (message from Oliver Upton on Mon,
 29 Jan 2024 23:17:06 +0000)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Message-ID: <gsntcythl565.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH] KVM: arm64: Add capability for unconditional WFx passthrough
From: Colton Lewis <coltonlewis@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvm@vger.kernel.org, maz@kernel.org, james.morse@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, pbonzini@redhat.com, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

Oliver Upton <oliver.upton@linux.dev> writes:

> Hi Colton,

> On Mon, Jan 29, 2024 at 09:39:17PM +0000, Colton Lewis wrote:
>> Add KVM_CAP_ARM_WFX_PASSTHROUGH capability to always allow WFE/WFI
>> instructions to run without trapping. Current behavior is to only
>> allow this if the vcpu is the only task running. This commit keeps the
>> old behavior when the capability is not set.

>> This allows userspace to set deterministic behavior and increase
>> efficiency for platforms with direct interrupt injection support.

> Marc and I actually had an offlist conversation (shame on us!) about
> this very topic since there are users asking for the _opposite_ of this
> patch (unconditionally trap) [*].

> I had originally wanted something like this, but Marc made the very good
> point that (1) the behavior of WFx traps is in no way user-visible and
> (2) it is entirely an IMP DEF behavior. The architecture only requires
> the traps be effective if the instruction does not complete in finite
> time.

> We need to think of an interface that doesn't depend on
> implementation-specific behavior, such as a control based on runqueue
> depth.

Good to know. I'll be thinking about that.


> [*]  
> https://lore.kernel.org/kvmarm/a481ef04-ddd2-dfc1-41b1-d2ec45c6a3b5@huawei.com/

> --
> Thanks,
> Oliver
