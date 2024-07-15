Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BB0826AF5
	for <kvmarm@lists.linux.dev>; Mon, 15 Jul 2024 21:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721079480; cv=none; b=ESs+WjlvN0D5ZMUGJCVFF/FUQTjiEYDtAgkX2FHVnS1TXrxVJjpJdapFkZpEo2pCX7XJ6ifEaNM4ZWZZ41u6vsOo1ZlZkDExuOrKxxbEUji4EjLm7mLXUcdGuxkAStAf0qlLMY3epvZdG7udVsdOPu4UEP1+4aKVDMSJJTcOS08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721079480; c=relaxed/simple;
	bh=XdO7wIyX46Gc6A4zpOoYKHrIE5C8ZCiQW+adQqLkIOM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IfSlyGj2KuZmnzKny1jrKF61AH7tI/oZrFHPN3WAzwZWZ/JMRInCS9QH4Uw4i12CZIu8L8xh8gORUIMU0axkkSx2mb3+xYFiiI+zUe+LJFSwAvf7SNNsqvzl1Msc1iGYXNUttbjKsrRu38O6YQYxuu6z9sRgfoENnFW8y5h4OWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hURHwXxp; arc=none smtp.client-ip=209.85.210.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hURHwXxp"
Received: by mail-ot1-f54.google.com with SMTP id 46e09a7af769-708adad61f8so2573250a34.1
        for <kvmarm@lists.linux.dev>; Mon, 15 Jul 2024 14:37:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721079478; x=1721684278; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tYT7RZte+jpSY6YDB1OuEYOLCT1GQosdmk1JeVvIqQo=;
        b=hURHwXxp48JwVT+XcMmVHTCfJSNdKNcEP8bIgtGktEjFDeW44FxyVv6hNJ+gTfuaNN
         tOau/k5XSWk7Z/XPz1AmzZXHauQIzQprsvwmhPThZPRL1w/urqwoRr//CjUTA65gDBYI
         3srt1CZXjVjv7IVvPBk6p5EYDXkBPFpZBOdIBx2JcmKMfHpWIs8r6CIy2k3CUXOl2N4t
         D7lyNSsTXrR0kyRBuUMZKdze1trQ91a3z0ajsmI8w+LG+YgjTNceOeH62Kdu4UH71UVW
         sxwimlg37ogNS6Podaglj81RLXRCvFETMCtyPdExhF5LnINUZ9i5OO+Ar2QIzeOMDieg
         1bzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721079478; x=1721684278;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tYT7RZte+jpSY6YDB1OuEYOLCT1GQosdmk1JeVvIqQo=;
        b=Y09taCr2c/9dkOL1fW69QJ0rBDZeuHzby8MqXAI+ejybmrt4mzyUe98o8cKwxcmfuA
         KXa0g4rKUqkg7YxtwSXvowH8PxXymMen8th4EKnXn/zD7bM19CtCFYsUQY5DL33s7EhF
         eCpJ4sfKPof8WICYIfNDx+4FErj0c3VxZ4b7zqNhfcGcStWeuThUEPAHZrih1UaHLuMh
         oW6bL0A9QIUm4B9kaMDoFUOztnqK+4X/W8mE0bZtUSIJbortJiUjwDZeUYmjPz8vPdm7
         9q3hWGSXNwb/aUUa5q+PFNm0xm7Ze6sw25/DuWDyIRb4qgTa7kwfX/5/oM9dh3bWLfVm
         B46w==
X-Forwarded-Encrypted: i=1; AJvYcCUxbEqE0V4E9RJL6HAp98u/GZERDH/oKz840RKIDlN9N0V8QM6dZn17Vsdxm79mwAPNQKM/dz7jeD1ZBZAYa8PY7a+Aj6uF
X-Gm-Message-State: AOJu0YxYP9zC4oBsd70wl7hbK17xuKSQSGh/FNxUNbKm0d7JJZUUZ2bm
	3HzyPAVNEVRYX4pPw1URr7lfdud/xGMsPxYq1KYMKngJOR7oscwAdd+x+vBpjOXftj1veNQreTs
	ZV3COOUn6DfQKgijixHwm4xp5wRc9aXpDuKrI
X-Google-Smtp-Source: AGHT+IFo5Jg9Iet8BbL/iNTVTBM9bSolkTbUgSvwA/5qBUXi+M06ocwSdrUcSEL7avW0kur1t8VRn6Y+Ut7Wj828r/M=
X-Received: by 2002:a05:6870:390a:b0:25e:bdf7:2883 with SMTP id
 586e51a60fabf-260bde68931mr39462fac.25.1721079478153; Mon, 15 Jul 2024
 14:37:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240710234222.2333120-1-jthoughton@google.com> <20240710234222.2333120-3-jthoughton@google.com>
In-Reply-To: <20240710234222.2333120-3-jthoughton@google.com>
From: Anish Moorthy <amoorthy@google.com>
Date: Mon, 15 Jul 2024 14:37:22 -0700
Message-ID: <CAF7b7moeOeJEv+zPQ-VQrP8M+O7r8Ru3GZjfrAKj25Hc0pQGnw@mail.gmail.com>
Subject: Re: [RFC PATCH 02/18] KVM: Add KVM_CAP_USERFAULT and KVM_MEMORY_ATTRIBUTE_USERFAULT
To: James Houghton <jthoughton@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>, Peter Xu <peterx@redhat.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, David Matlack <dmatlack@google.com>, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Not to nitpick an RFC, but since the stuff in this patch seems less
likely to change I think you should avoid using #ifdefs

For instance

On Wed, Jul 10, 2024 at 4:43=E2=80=AFPM James Houghton <jthoughton@google.c=
om> wrote:
> +static inline bool kvm_userfault_enabled(struct kvm *kvm)
> +{
> +#ifdef CONFIG_KVM_USERFAULT
> +       return !!rcu_access_pointer(kvm->userfault_ctx);
> +#else
> +       return false;
> +#endif
> +}

can be

> +static inline bool kvm_userfault_enabled(struct kvm *kvm)
> +{
> +    if (IS_ENABLED(CONFIG_KVM_USERFAULT)) {
> +       return !!rcu_access_pointer(kvm->userfault_ctx);
> +    } else {
> +       return false;
> +   }
> +}

(however kernel style tells you to write that :), the cap-supported
check can be moved into kvm_vm_ioctl_enable_userfault(), etc
