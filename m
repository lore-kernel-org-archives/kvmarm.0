Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BE0B386556
	for <kvmarm@lists.linux.dev>; Wed, 13 May 2026 16:24:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778689494; cv=none; b=Qi6TxIZ23h4+mFz3F/19DD+0hFPw/pmvBC2h+rREqc7lvwLzJkVWGPWrtvuVfYQZbGsA1hcLVostpODo9WLn2Voe6nXVMn2DcfIElgJjCwkqTxo4Dv1IHcJcx7p00OoaDWwsIPXWyA4VYSLhi4AyTCPmmfNo1haaZqWvzSvdD9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778689494; c=relaxed/simple;
	bh=dFqjGcDESPJs1sYvvaTVqiEjpmMW73N7IioLhMndVnk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uX01eVZxoHfjUNqawNCAOBN2jux73iCgtsKmGNEP0Zu5L3Z+YpEsKCPbdvzXthwSqlthN7xFXRCxsPEKhJE6wHpUKlDlCbzeNwq21rL65K/uqrQCc/LqnTAp60lwhIY0QJRvR3tpFHFhy7VpRLWgFN/LfoPWebrzcPE+YdYA6E4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QuMZmI31; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QuMZmI31"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778689492;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LFP7K7Lzf/qFmjwBHFqhDwhsq/kaKAVcEgRqthL+0Is=;
	b=QuMZmI31M/YUFimT9BNY9VLRTtsAilLH5YsCjp5ICsUcnQT1CeOw/21YLDXZ5qOdzg8EXg
	swmCuS3zwokidwoD9YImaNqmP9eCVj0yGkaOWFE+UuJ87wFIpeAjN6XvDqufps1PimVLJX
	VLzDWMQ9ZyRZKwbazh14HzNtQ/YOJ7Q=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-617-UcwSHRfbMJS-BPSQp7htDA-1; Wed, 13 May 2026 12:24:48 -0400
X-MC-Unique: UcwSHRfbMJS-BPSQp7htDA-1
X-Mimecast-MFC-AGG-ID: UcwSHRfbMJS-BPSQp7htDA_1778689487
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-44bf1ac8893so6120905f8f.0
        for <kvmarm@lists.linux.dev>; Wed, 13 May 2026 09:24:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778689487; x=1779294287;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LFP7K7Lzf/qFmjwBHFqhDwhsq/kaKAVcEgRqthL+0Is=;
        b=Uacd09cGZVS7wsCJcuw+uN6op3Zop+eqm0GE11ALQ/2XMLAho+3qc3Ybr7lRhovyqj
         49sPqwcn1Mln/Zrr/s2lSrsCpSHUNXsRmKL+Nx4M2P1JklyMnLtx0LQdv+75EdNglbHT
         YklO9tqbz8NlSgG0CotgbVEKyfGunkKDXGcYH8Mku42A9YzjKPYPJ8RVml765HYqvdr4
         0XUWkL5omhRokWQy5XOtKB6DO1+7UMubwxy/Vf4gx0txKYYcCmwP99dUfWqGGwqpqXoN
         ejY9yLdUhLfzALe0c5Xhoh6LnugFDUci9vgN7cL2R/1SWl9eF/wv8DwqbMSsKjgLNhzd
         k9ZQ==
X-Forwarded-Encrypted: i=1; AFNElJ93lmqQaToWpLOduTLK94g0vL0t7Ktg9YW5yARhntdQuO9MM12aUxfmgzwezF0Yp5/UR3toGYY=@lists.linux.dev
X-Gm-Message-State: AOJu0YwiQGRZfA0iRTXyUH80a79ima3txkwAH6e3CVcotsu3VSzbbf6s
	Y3m/GoztIC8AE4gcq4jKGXP1tx7FDmHs/EcabIAdRNEIVEjpCxVoZdA26khiqgaStBEeg1crsB1
	rN5GErPexMElHuV2NZUYKnQoOj49Byu35WQvJ/1yjrh4aojocUz4IOzdy5gutVXHriZw+0I72a1
	ESX1Ln/QXkcA87OjtnayfvQQEp9ZN2qAER
X-Gm-Gg: Acq92OEYgcDl31tliLzy5l3dE3yvBVuX/zbCGr4IK6T0RvxOhjFmZr6umupJj0LRuH+
	yCNSKj6Wuq5zadYrMGqmviq3+x/9JxacmQVfqoeRQNASgRZwsJx8j5SKo97+D9bOUStnpTYNmPp
	KcZFhog96ofhbqXA5gVhuYV7vEoQhrtxCr1rV92AYNbkLkafNuzOZN4TEdjg8DTN2yTRAWWT7TZ
	qMyQVZM0jg+DqWm/QoXg1tBGDIxglxdMs15m7uvLNp0Het7TVuqpjLDflX1hlPuEint3BnNq4uB
	RNw8r/5k
X-Received: by 2002:a5d:5d0b:0:b0:43d:7d24:b4ff with SMTP id ffacd0b85a97d-45c7b85de69mr5836110f8f.40.1778689486821;
        Wed, 13 May 2026 09:24:46 -0700 (PDT)
X-Received: by 2002:a5d:5d0b:0:b0:43d:7d24:b4ff with SMTP id
 ffacd0b85a97d-45c7b85de69mr5836059f8f.40.1778689486387; Wed, 13 May 2026
 09:24:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6856b269d2af706eae397e0cf9c1231f89d9a932.camel@infradead.org>
 <6afc4b95-3c15-4d71-877d-19b84e91ce05@redhat.com> <57bc082f4824d6114d3156744c25986effc29aca.camel@infradead.org>
 <baff82ca-6321-4b16-aa61-b2d6d60b6535@redhat.com> <86h5obya2r.wl-maz@kernel.org>
 <48b06e5655d56ff6eda30e563b34894fa0eb2f07.camel@infradead.org>
 <ba08dfe9-932b-40c3-9fdf-fc891d52e1d8@redhat.com> <d9d4471a7f5ec1e297b3ca07f42a59090aa91e15.camel@infradead.org>
In-Reply-To: <d9d4471a7f5ec1e297b3ca07f42a59090aa91e15.camel@infradead.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 13 May 2026 18:24:32 +0200
X-Gm-Features: AVHnY4JneGWlgI2TZN3pA0snVaHMgFYvSCN-3eBEab4JAE5jQOEAQHtyebNrVkM
Message-ID: <CABgObfaM-JtNn2MuYXaiadQnLfAhTEaoHAcTG9=J6LkMcQCJ3A@mail.gmail.com>
Subject: Re: [PATCH] Documentation: KVM: Document guest-visible compatibility expectations
To: David Woodhouse <dwmw2@infradead.org>
Cc: Marc Zyngier <maz@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, kvm <kvm@vger.kernel.org>, 
	Linux Doc Mailing List <linux-doc@vger.kernel.org>, 
	"Kernel Mailing List, Linux" <linux-kernel@vger.kernel.org>, Sean Christopherson <seanjc@google.com>, 
	Jim Mattson <jmattson@google.com>, Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Raghavendra Rao Ananta <rananta@google.com>, Eric Auger <eric.auger@redhat.com>, Kees Cook <kees@kernel.org>, 
	Arnd Bergmann <arnd@arndb.de>, Nathan Chancellor <nathan@kernel.org>, 
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, kvmarm@lists.linux.dev, 
	linux-kselftest <linux-kselftest@vger.kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: sOu70uMkPnlvI3cRptYhOBZaH78QudLHmLvn8gITSmk_1778689487
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"

Il mer 13 mag 2026, 15:57 David Woodhouse <dwmw2@infradead.org> ha scritto:
> > x86 doesn't do bug-for-bug compatibility, thankfully - we have quirks
> > but only 11 of them, or about one per year since we started adding them.
> >   We only add quirks, generally speaking, when 1) we change the way file
> > descriptors are initialized, 2) guests in the wild were relying on it,
> > or 3) it prevends restoring state saved from an old kernel.  Is there
> > anything else?
> >
> > https://lore.kernel.org/kvm/e03f092dfbb7d391a6bf2797ba01e122ba080bcd.camel@infradead.org/
> > is an example of a bug that "no SW can make any reasonable use of".
>
> I actually believe that the focus on ICEBP was triggered by some weird
> gaming software's anti-DRM mechanism, and that it *did* affect actual
> guests in the wild?
>
> But yeah, *fixing* it should not have any adverse effects. That's the
> key.

Yep, so "bug for bug" is not it.

> > That is *also* obviously nonsense though, isn't it (see example above)?
> > The truth is in the middle, "once it is in the architecture" is likely
> > too narrow but "once it is in a Linux release" is way too broad.
>
> How about "once it is in a Linux release and guest visible, and unless
> we *know* that changing it in either direction underneath running
> guests cannot cause problems".
>
> > And besides, both miss the point of *configurability* which is the basis of
> > it all.
>
> Hm, configurability *is* the point, I thought.

Yes, and configurability goes way beyond bugs/quirks, which are to
some extent a red herring. Configurability for example says that "KVM:
arm64: vgic: Allow userspace to set IIDR revision 1" shouldn't be
controversial at all.

> > So we have the third case, "restoring state saved from an old kernel".
> > If this case arises, I do believe that Arm will have to deal with it and
> > introduce quirks or KVM_GET/SET_REG hacks.  Maybe it hasn't happened
> > yet, lucky you.
>
> We literally have those mechanisms already.

I am not talking about guest-visible changes across save/restore here,
but rather about round-trips through userspace. For example, see the
effect of KVM_X2APIC_API_USE_32BIT_IDS on KVM_GET/SET_LAPIC: it
couldn't be made the default, because userspace expects to take old
data returned by KVM_GET_LAPIC and shove it into KVM_SET_LAPIC. Sucks
but can't be avoided.

> See commit https://git.kernel.org/torvalds/c/49a1a2c70a7f which adds a
> new guest-visible feature in revision 3, but allowed userspace to
> restore the old behaviour by setting it to revision 2. All my patch above does, is make it possible to set it to revision 1 as
> well. Because https://git.kernel.org/torvalds/c/d53c2c29ae0d previously
> changed the behaviour and bumped the default to 2 *without* allowing
> userspace to restore the prior behaviour, and we've been carrying a
> *revert* of that patch.
>
> Why would we *not* accept such a patch?

Agreed. Even ignoring your revert, there's no reason why any upgrade
past 49a1a2c70a7f has to be from after d53c2c29ae0d.

> Marc seems terribly insistent that we SHOULD NOT
> restore the behaviour that older KVM offered to guests, and we MUST
> change it unconditionally underneath running guests, making these
> registers writable on upgrade... and reverting them to read-only for
> running guests on a rollback.
>
> And there we do have a very different viewpoint.

That's the design decision I mentioned, of not starting the guest
configuration from a clean slate. I believe it complicates things
because you have to design from the beginning with the ability to
rollback to old versions and to potentially detect conflicts
introduced by the rollback. This is exactly why
KVM_X86_QUIRK_STUFF_FEATURE_MSRS was introduced: "KVM's initialization
of feature MSRs during vCPU creation results in a failed save/restore
of PERF_CAPABILITIES. If userspace configures the VM to _not_ have a
PMU, because KVM initializes the vCPU's PERF_CAPABILITIES, trying to
save/restore the non-zero value will be rejected by the destination."
(https://lkml.org/lkml/2024/8/2/1032)

For Arm, however, it may be too late to change it; if not, I'll
happily watch you argue with Marc about it. But even without that,
this doc patch (and the idea that "Where a new kernel introduces a
guest-visible change, it provides a mechanism for userspace to select
the previous behaviour") should be uncontroversial.

Paolo

