Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com [209.85.208.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D3CC3D953A
	for <kvmarm@lists.linux.dev>; Mon, 10 Aug 2026 12:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786366535; cv=none; b=SWVLtcYYd0P8/gaDz9CWizh+Wj1eZMC4XUTBBlmR+hvZc5rwEU7piBqGq898vjzO5Wuf1U8yMWFmbFjjHN1mEGuT7NXv6qaNPSTDqz6GROJlFxQn8gI6U1UCsCoIiY8MI7xOs36KZNdR471k+hrtKASM5+/6y0gAQKzexjxVpEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786366535; c=relaxed/simple;
	bh=ABQ7rLH8LdDNKLwT5rPObn5whIed+p2i6tm3SaUf8iY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=beOE+piEs2SsTFHbdZGpr/QzZ4g9RZqvGT2FSvhjwd1GY0sOSyUc5lLgVC9Uh3jVi9puBgKdlgyYFLUNGmxt1qorswNjb9+n2f+0yGVI4q3uxG780GBlO3zu/+KiMMYOCDeJoJNqoBbM/mKMB3WvpOS7n/T9rVrEL9xBGi+xwE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tarunsahu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LHBlAV8c; arc=none smtp.client-ip=209.85.208.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tarunsahu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LHBlAV8c"
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-6a178080182so2460107a12.2
        for <kvmarm@lists.linux.dev>; Mon, 10 Aug 2026 05:55:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786366531; x=1786971331; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=CXS0NEGBTZuSyd76xEU6892riTmJKR4JCJe3n8Ek3/c=;
        b=LHBlAV8cmPecaatXdbL20WVSqeWmK5GT4Ouq2JeSe3QD3J9WBre5+R8ah+Sdi5zyUJ
         GeYQEvmf/HRnhysrkvqc1NLtUhys0PrJogBGFi5qKqWR0NboMOuydayxDrqUi/1cjh7G
         Huhy16N8RfRi9xZCceY5E/4a3BEqyvgwVYG7NC+akaN/h7VSuBnrz+ZbwRMBPUPfmiTo
         z76TYta3/+SPB68VKTHM1KtxgbVlxNl2eJWqwI9gy0dGfc0VhvqbmVMvKlExzzrYbjGw
         eONswa3ykrjaPnSChh3sQK8XIg2KheNxr1/yC/MkSD3l9/w6sRnH8LHtDTULKRVrVJmG
         Y9AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786366531; x=1786971331;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CXS0NEGBTZuSyd76xEU6892riTmJKR4JCJe3n8Ek3/c=;
        b=SDxIIaHxu2utuOm85Cp8YkuR4sMIwLVH41BtIw7VQyOuELMAvF+AyWSd38o/a5UUbA
         NsUkiRojeMYaPwBO9djcBwVClH7zJpksFOAFvkrvpAD9kHGD+n4XdYxqzlK4m/N2Dsu5
         3iQNgtgeYj2Qn05dYDNGSr21erpBy4YpwOdDzUf5eZA3qEPqWcABq59M1GyOpp+6gyfp
         mM8JwzE1UhsO2ocnFif7TRNNxzfNu8VA/0XV+ojY+kxxQl8BIBEFGcsBryR2lv4HPRd2
         xK/L3zm9YwFhifrpBYiwsE/XqQecDPzrhM/EX/5pRB65oObOxy+FxBzGkNBg214uhvf9
         pMJg==
X-Forwarded-Encrypted: i=1; AHgh+Rpd1ljUVrHZ0CGLdHg9JcDe2aB549VLFcWEPGLsGoWbggFTw2KhTsXGF3JDEvQ1QC8nxKr2EX4=@lists.linux.dev
X-Gm-Message-State: AOJu0YzYfze/Ux0DrBEvbqpHF8BAIqgVT8eun6j2Fu3RayR5Pk9ZJeLN
	rbnAtwuXODcG/oyFPmziLvkgGGsijL8BY/y2Zn9YuwJxJbIpTKjuHsjgGGWlQG0dKn9J97H3Zt4
	frGVsMgxkAkyVoQDXEQ==
X-Received: from edeu12-n1.prod.google.com ([2002:a05:6402:a6cc:10b0:6a1:f089:88d7])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:21cc:b0:6a1:88e:90c1 with SMTP id 4fb4d7f45d1cf-6a355da6287mr898442a12.9.1786366531239;
 Mon, 10 Aug 2026 05:55:31 -0700 (PDT)
Date: Mon, 10 Aug 2026 12:55:30 +0000
In-Reply-To: <CAEvNRgGDhcu2LUqhwVtGJSUo4uXQHrGOYRDaM2qzPTO4LX=jKQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260728121138.1103610-1-tarunsahu@google.com>
 <20260728121138.1103610-4-tarunsahu@google.com> <20260728122655.17C791F00A3A@smtp.kernel.org>
 <CAEvNRgGDhcu2LUqhwVtGJSUo4uXQHrGOYRDaM2qzPTO4LX=jKQ@mail.gmail.com>
Message-ID: <9huza4qu8799.fsf@tarunix.c.googlers.com>
Subject: Re: [PATCH v4 03/11] KVM: Export kvm_uevent_notify_vm_create()
From: tarunsahu@google.com
To: Ackerley Tng <ackerleytng@google.com>, sashiko-reviews@lists.linux.dev
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	Oliver Upton <oupton@kernel.org>, Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Ackerley Tng <ackerleytng@google.com> writes:

> sashiko-bot@kernel.org writes:
>
>> Thank you for your contribution! Sashiko AI review found 1 potential iss=
ue(s) to consider:
>> - [Low] The patch claims to export `kvm_uevent_notify_vm_create()` but f=
ails to include the `EXPORT_SYMBOL_GPL()` or `EXPORT_SYMBOL_FOR_KVM_INTERNA=
L()` macro.
>> --
>>
>> --- Patch [3]: [PATCH v4 03/11] KVM: Export kvm_uevent_notify_vm_create(=
) ---
>> commit 5e642ea16f0d267e622a352de60bfe397ecf79df
>> Author: Tarun Sahu <tarunsahu@google.com>
>>
>> KVM: Export kvm_uevent_notify_vm_create()
>>
>> This commit exposes the kvm_uevent_notify_vm_create function to allow
>> triggering KVM event notifications during VM creation.
>>
>> [ ... ]
>>
>>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>>> --- a/virt/kvm/kvm_main.c
>>> +++ b/virt/kvm/kvm_main.c
>>> @@ -6348,6 +6348,11 @@ static void kvm_uevent_notify_change(unsigned in=
t type, struct kvm *kvm)
>>>  	kfree(env);
>>>  }
>>>
>>> +void kvm_uevent_notify_vm_create(struct kvm *kvm)
>>> +{
>>> +	kvm_uevent_notify_change(KVM_EVENT_CREATE_VM, kvm);
>>> +}
>>
>> [Severity: Low]
>> The commit message mentions exporting this function, but is it missing a=
n
>> EXPORT_SYMBOL_GPL or EXPORT_SYMBOL_FOR_KVM_INTERNAL declaration?
>>
>> Without the macro, won't dynamically loaded architecture-specific module=
s
>> like kvm-intel.ko hit undefined symbol linking errors when they try to
>> call it?
>>
>
> I'm not 100% sure about the use of EXPORT_SYMBOL... here but usually I
> compile kvm as a module to try and catch these types of linking
> issues. Maybe Sean will have a better method/explanation for this.

The Intention is just to make it global to kvm module files. it is only
used in kvm module so need to use EXPORT symbol as Sean also mentioned.
>
> This brings about another question I have though. How does luo work if
> the new kernel's deserialization of the persisted data structures
> depends on a module? Like in this case, KVM is a module, if KVM isn't
> loaded in the new kernel, do the data structures stick around until KVM
> is loaded? Or is KVM required to be loaded as a module in the new
> kernel?

If kvm module is not loaded then guest_memfd_luo/kvm_luo handler will
also not be registered. So luo_finish call will leak this memory and not
be freed. This is aligned with LUO design.

I have raised the saperate thread with LUO list to discuss if LUO_CORE
should throw a warning in such cases. [1]

[1] https://lore.kernel.org/all/9huzecg6ta6h.fsf@tarunix.c.googlers.com/

~Tarun
>
>> --
>> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260728121138.1=
103610-1-tarunsahu@google.com?part=3D3
