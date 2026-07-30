Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 584C6446078
	for <kvmarm@lists.linux.dev>; Thu, 30 Jul 2026 17:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.216.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785433431; cv=pass; b=jE/e6Xo6V2SvkFPrMrwnoKCqf/V8I1VZ9R9Ikoi1oxFPRbE/NLaLOotsDIKU9lGC+9YVZkcmXsdeuER/U29i5A6Bsn1IVNVndw/j0XiDB3ByP96yFALbcod4TEDDJVDYKEhjNkOkO4hSHlfoAPNiyiMQ5LrEgVd3BOiK3cxESK4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785433431; c=relaxed/simple;
	bh=OlBwlhKOiCMRiIdYne4F/M0ahn6Xw3rouRdmpnSET1s=;
	h=From:In-Reply-To:References:MIME-Version:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JayGfExLirjb6bS5EDDNz8OKESRol141W2hS9wu094C+hr1ob2NLiVMpRLZbPrEcjDZ4AW8T8MWEicd8XHXeUnsfzGoRwOSDG8ITPjxSKAyPFrFqBS5guFPofr53fy/DWsdZ+XYls0M95s+jrLBHjKMCOXUMnC9TssgKL+bwklY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=flZkQY2N; arc=pass smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="flZkQY2N"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-38e07ebd263so121816a91.1
        for <kvmarm@lists.linux.dev>; Thu, 30 Jul 2026 10:43:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785433427; cv=none;
        d=google.com; s=arc-20260327;
        b=gv5px/FaljI87s3HHLlvkVr0yigL1XHEgSqZoT9hBZGU7UvfeyDyEaQwoJMn8V13zZ
         ZQG7f35d7IpT9921sLzDV/FEZAZUtpjr2CFDBlaDPD93k8IWI9/dwr9LITscgNg7eB8p
         QB6Jp5PXZFAsl/4RiUKu0KGRr4AAM8K5K7TgxUEWPesYRmA0kf9wwVA2TPaKWwVAOXSG
         3rZ6t0gmlTnCYpkXphWmgFqkGHo3n7jfg1d8J3GFsVyxRYZ61S5N6zFTtfhyxG/TODUK
         XqvEFD/gr+sgHBuHeAkM0wQVj0TAS909KhN4Qsa9/zs/DSQChOwbeb2DOtZzWo093f48
         cPNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date
         :mime-version:references:in-reply-to:from:dkim-signature;
        bh=63PGhmBtUzf4vUZbWnyFr9JI9DJZU2NrWkZa1qKZ4cY=;
        fh=7wpUQBwS+YPBmEj5k7Vnc/925K310IPvHyGBonIlPYU=;
        b=p/H2gXTdcEkSUGPboftKHcedeMcCWxGOcbug0odtyrQcnFCjQwpuXHbrQKR/EmSAf3
         GKVp+ApOkG/oCpjKPxCLzpFNJJvOnR3PAUawUAJWeeVWT9Srnxz0pM4PBwStnL9q4NZA
         tU1gJGr9Ut+drsPR+b6vSicawtH4nW1mKWebQ9OZMORGLQu7KWYkB+SPpReRA5iVLQdo
         IpMD3So3jxbhfQCeDtdQPww4OmABj7dkk8z8xDpbafONPc0gHI2K5SPqe8NYB5L5xpz0
         lw2xsgXoKCs3mBNTzEMPOtRzIAY30hODPxtpRHomPMlr9ML5/K30axxpKgwbZB5ArALD
         KYUw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785433427; x=1786038227; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:mime-version:references:in-reply-to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=63PGhmBtUzf4vUZbWnyFr9JI9DJZU2NrWkZa1qKZ4cY=;
        b=flZkQY2NWYDrXrtXEspRyWNlUfPcF3jhZSn39uLUaC8n87ZQocw4NVAlWQXGLBZ7aE
         KKfDWKfu44CLqkV/7pgFza2Vt5RloXCR8IR7DrwhZWeqyXWIBMRDvIk9qItpqDmo+E5I
         GlF7WUWhMl5BMHeX4RxDVkl4Lk3UOPekgk4Chnzqx2+DXlwmHUnHE4rd4CTuCYQeSW1W
         VGxnNnQb0dhEAwZakWUUpeQbFbQgDdIbr8KW5yTcAnCtrEizFVpW+ybTNk+MeQBdKR9g
         wrP5TliBq7IIMVSZArln2aMn0WVYOwfoyOHFd2nzWez3+8/EaPhWY9+PsLK25rObb2iO
         jXJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785433427; x=1786038227;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:mime-version:references:in-reply-to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=63PGhmBtUzf4vUZbWnyFr9JI9DJZU2NrWkZa1qKZ4cY=;
        b=IOOONWLm2zbXomP4c1LZdNSIuflkV/X7QBnpSjDGbDTFFdCVABrUklDjULBO9Bcf+8
         HmUmZxS8m7UVCeTmwjORDncJ2s9Fn6uPy5or/tMhkg4nC8MBFS4j9RBdcWO1DDZPkxUG
         xz4CjtRr4aEF+QkwyeXWXkjjXggvv4ip1fl0Ryv8xFgPaw6EvhIrpqdW7sltG/+KvIBR
         De8cejtOeM73/cE9jUWA0orGAiISgwRqsUh3lrF1ce47UbpzR/a3eipU0AFwXIOebVhv
         mmVSOVdlv2YhS+7PV7v6P3b+FfKc7U0/YnE814CkEa2v7uhizEw+ZOJvogwBQUUOiBM3
         roIQ==
X-Forwarded-Encrypted: i=1; AHgh+Ro2mUwQcLqgUdMlLb7AOnwGbAHbctyq4Fb1xlK/uAzYGN/Y+XW5St/EL/xorFGjy1HmiCLFwxg=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw3Yp5MOQQfuKgTV2g0zQty4U5PRkA5pqxZISHUfdnLzsUJ577O
	oPuC3cwQ+UnQw+8rHuTFoydwj3Qb4oZN8pjlcORJ0rNMmlK8Sr2mDANDtwIXDlUlP4029WjVl//
	1vhXdB9DejO/uWh4c2xbX7nXu4IKmyFuKuoWLsH48kT7+gx07/a3IS0/g
X-Gm-Gg: AR+sD13weRPbcm7mlJZhwfW+O4Q6WB1DoOWpdre11/PaoKtnifgJw/CATjSrcpfJcr6
	0izchjE4jEfXdFSs9230UiWhczTybBoEHvnrbBWU8tScwUin4/cEdpGGW1dV2/l6wro1Q2CGBIg
	BVqZwmqnIM0nrTwSNiaspwRjWIdPhJJ1INS/RF0ZNFTNT/pNjXa+7ysgm6aC0opcnXSPcmrvX/O
	PXcev0i+r8TrLzeGe0JrlXSYeFtIASkek8du4+EV1VMV7njCSRjcXSe0xHnC8aUXKpbDjaAQKra
	X41j0BsJu4W9d9/PMVlBtMDHplJlo6Wq+9A4ZgzRCMU2OmtlmUqkoTzLsDysY757N4/olR2Ilf4
	UwemvU/vnvRnqH8pIrp8fnBFk2eumW+95vwMO320za8DRDQ==
X-Received: by 2002:a17:90b:1dc7:b0:38f:240d:b857 with SMTP id
 98e67ed59e1d1-38f9bda5d44mr2890773a91.2.1785433426437; Thu, 30 Jul 2026
 10:43:46 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 30 Jul 2026 10:43:45 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 30 Jul 2026 10:43:45 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <20260728122655.17C791F00A3A@smtp.kernel.org>
References: <20260728121138.1103610-1-tarunsahu@google.com>
 <20260728121138.1103610-4-tarunsahu@google.com> <20260728122655.17C791F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Thu, 30 Jul 2026 10:43:45 -0700
X-Gm-Features: AUfX_myKuoszqFvWeEwTloNt1W9Hm9CCDiUlXfsqzDGDzLiGRc2fM4YKO_l1eUo
Message-ID: <CAEvNRgGDhcu2LUqhwVtGJSUo4uXQHrGOYRDaM2qzPTO4LX=jKQ@mail.gmail.com>
Subject: Re: [PATCH v4 03/11] KVM: Export kvm_uevent_notify_vm_create()
To: sashiko-reviews@lists.linux.dev, Tarun Sahu <tarunsahu@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	Oliver Upton <oupton@kernel.org>, Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

sashiko-bot@kernel.org writes:

> Thank you for your contribution! Sashiko AI review found 1 potential issu=
e(s) to consider:
> - [Low] The patch claims to export `kvm_uevent_notify_vm_create()` but fa=
ils to include the `EXPORT_SYMBOL_GPL()` or `EXPORT_SYMBOL_FOR_KVM_INTERNAL=
()` macro.
> --
>
> --- Patch [3]: [PATCH v4 03/11] KVM: Export kvm_uevent_notify_vm_create()=
 ---
> commit 5e642ea16f0d267e622a352de60bfe397ecf79df
> Author: Tarun Sahu <tarunsahu@google.com>
>
> KVM: Export kvm_uevent_notify_vm_create()
>
> This commit exposes the kvm_uevent_notify_vm_create function to allow
> triggering KVM event notifications during VM creation.
>
> [ ... ]
>
>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>> --- a/virt/kvm/kvm_main.c
>> +++ b/virt/kvm/kvm_main.c
>> @@ -6348,6 +6348,11 @@ static void kvm_uevent_notify_change(unsigned int=
 type, struct kvm *kvm)
>>  	kfree(env);
>>  }
>>
>> +void kvm_uevent_notify_vm_create(struct kvm *kvm)
>> +{
>> +	kvm_uevent_notify_change(KVM_EVENT_CREATE_VM, kvm);
>> +}
>
> [Severity: Low]
> The commit message mentions exporting this function, but is it missing an
> EXPORT_SYMBOL_GPL or EXPORT_SYMBOL_FOR_KVM_INTERNAL declaration?
>
> Without the macro, won't dynamically loaded architecture-specific modules
> like kvm-intel.ko hit undefined symbol linking errors when they try to
> call it?
>

I'm not 100% sure about the use of EXPORT_SYMBOL... here but usually I
compile kvm as a module to try and catch these types of linking
issues. Maybe Sean will have a better method/explanation for this.

This brings about another question I have though. How does luo work if
the new kernel's deserialization of the persisted data structures
depends on a module? Like in this case, KVM is a module, if KVM isn't
loaded in the new kernel, do the data structures stick around until KVM
is loaded? Or is KVM required to be loaded as a module in the new
kernel?

> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260728121138.11=
03610-1-tarunsahu@google.com?part=3D3
