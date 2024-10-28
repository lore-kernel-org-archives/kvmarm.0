Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 905DD1DE2BF
	for <kvmarm@lists.linux.dev>; Mon, 28 Oct 2024 16:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730133864; cv=none; b=lBN2QgX625Enl34k+9rFWNZ3txL1D/XJRQzRm2Yagmd5IfxLD94lsPFmmi/QbRNbPDPYzi4I0SsnOTbSLtLH0wSBFcdhSubJ3WnUhHJNsOMTemD8QfUkRpKFL2YmjuXM8hIcodA4RcL8VrO+WIU2djSvLHE7v19Ktilz9z0StKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730133864; c=relaxed/simple;
	bh=aX0w8inh3SAdKvyxGUwcagnIxGOFQmmq59NbnBZv/FM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Q2YZlib0iPrkON8s7JT02ElOzsyMCaag3s4EW4nIR4poT+k6ny/w08GTYBp868oyd9NYGBPvzzbMljbaerK+tlcxBFycNdZEd9q7V9YCyU7RprDEShve0pSlyNc28cpeCFjhg5db4wO+a1Ca7ep5Ieo2//XaUsTu1z/S0ApcWXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=iOfxSaml; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="iOfxSaml"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-5c99be0a4bbso6215784a12.2
        for <kvmarm@lists.linux.dev>; Mon, 28 Oct 2024 09:44:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1730133861; x=1730738661; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=KVW3ua7sJWaIAit3EE0t5f2qivxeSre5gEdtobhzZ2k=;
        b=iOfxSamlEqSCc5zhTkRw0SD+lB0RnVUlLB50NN5I+HReWDkGCDP1JmGUJblQOccbrt
         NuCTj8ZEXZJKGJTuqgQmzMZOAmk5Xo7kLcQhD1OPmIgmMQNiPCgBT+XD81jvGfHept0w
         lXjp76J1CECIOCN5e4i/9o/o4WYy6C3E/m7Mc7DvpSSL0USZmQNmFFuM6kO9dOrECNCI
         eG8SYY4VbapZ4mXX5oB5bwHig2LqVfxtFukbojPB9s9cUQNHJJWBxEu1yP8Nj+Dx0KMw
         S93Wp6eEQ//7nlDMquVGSXbF9wDZvRSvDjhkbo2Rgf3z0IJvCrLK8NcQKAfjwxR+K9IN
         5mZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730133861; x=1730738661;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KVW3ua7sJWaIAit3EE0t5f2qivxeSre5gEdtobhzZ2k=;
        b=iP2LrfiLPEWeTesG8zFX3jhsE2oujTafsGQwJIJHRZIbMKOCue1cAmPvxFKkbjeNy3
         yvPVRZjmbGk0/b9JizwdrOx4yAdHR//Y9kG1hsmBnLKJ+sioPT8YJxRa8OUOqEkAFGZ/
         z0CZyZPAwPdHg25jDWInMThwDdUipsoVBKIP2v+FwI4/TSq465F2d+995JoHX8jlsBkP
         JoKPTnvDiwceUJu5WZY/xbZsCrMcn5N4NDA0rPfilrzQEDutoVWreWa553//j4bLviIH
         qteQ6BXq2GlaRRFia506gJm+QeMswTOEJ96xvvYeBcc2Z9Zc8uswWHVrRBjtrGlEboPY
         T/+w==
X-Forwarded-Encrypted: i=1; AJvYcCUwiJh1xiV57Nn/Y26WFeKHSiGjvWIKeKu2oyLzQHXETamN0ChdIg+eZYLNoXG2A6LW7XuK5T8=@lists.linux.dev
X-Gm-Message-State: AOJu0YygP/Pf4dInzFhG9x3T/C8T46Q/kobpDVrfwfWE+NDUmiNQCoL7
	Jm2yxC6jNSaWepWAidVgJ08OjUs8tnqIJwf/4ZehruPoiUkFJgHPzJILttNFeqvFbXbEmZDEHBr
	jKbau7SoXmG4pSvfTKjTlQbBtWj8CQIpLyC+8PA==
X-Google-Smtp-Source: AGHT+IHibvVnzv7R808yofL15SsQp9qWs+wpjwny1r44N3Tr9WhPaNu6tWT/+u4yguYgNE3Vex7W8x8V7/yGfguoMx0=
X-Received: by 2002:a05:6402:34cc:b0:5c8:8bde:a1d3 with SMTP id
 4fb4d7f45d1cf-5cbbfa548b3mr7619120a12.22.1730133860747; Mon, 28 Oct 2024
 09:44:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241025101959.601048-1-eric.auger@redhat.com>
 <ZxuwZw2plMI6dNyE@pinwheel> <87v7xcnqrs.fsf@redhat.com>
In-Reply-To: <87v7xcnqrs.fsf@redhat.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Mon, 28 Oct 2024 16:44:09 +0000
Message-ID: <CAFEAcA9qqGMduMC_yXm5Jzbpfy0RVEPkxMoN4q72japiHfRCsg@mail.gmail.com>
Subject: Re: [RFC 00/21] kvm/arm: Introduce a customizable aarch64 KVM host model
To: Cornelia Huck <cohuck@redhat.com>
Cc: Kashyap Chamarthy <kchamart@redhat.com>, Eric Auger <eric.auger@redhat.com>, eric.auger.pro@gmail.com, 
	qemu-devel@nongnu.org, qemu-arm@nongnu.org, kvmarm@lists.linux.dev, 
	richard.henderson@linaro.org, alex.bennee@linaro.org, maz@kernel.org, 
	oliver.upton@linux.dev, sebott@redhat.com, 
	shameerali.kolothum.thodi@huawei.com, armbru@redhat.com, berrange@redhat.com, 
	abologna@redhat.com, jdenemar@redhat.com, shahuang@redhat.com, 
	mark.rutland@arm.com, philmd@linaro.org, pbonzini@redhat.com
Content-Type: text/plain; charset="UTF-8"

On Mon, 28 Oct 2024 at 16:20, Cornelia Huck <cohuck@redhat.com> wrote:
> On Fri, Oct 25 2024, Kashyap Chamarthy <kchamart@redhat.com> wrote:
> > (b) The current CPU features doc[2] for Arm doesn't mention "host
> >     passthrough" at all.  It is only implied by the last part of this
> >     paragraph, from the section titled "A note about CPU models and
> >     KVM"[3]:
> >
> >       "Named CPU models generally do not work with KVM. There are a few
> >       cases that do work [...] but mostly if KVM is enabled the 'host'
> >       CPU type must be used."
> >
> >     Related: in your reply[4] to Dan in this series, you write: "Having
> >     named models is the next thing".  So named CPU models will be a
> >     thing in Arm, too?  Then the above statement in the Arm
> >     'cpu-features' will need updating :-)
>
> The currently existing named models are for cpus like cortex-a57; you
> can use them for KVM if you happen to run on a matching host cpu, but
> they only really make sense for use with tcg.

Note that those are a relic of an old and quickly abandoned
design direction in KVM for Arm, where the idea was that
userspace would specify the target CPU via a KVM_ARM_TARGET_*
constant (initially only permitted on the matching host CPU
but with some vague idea that eventually KVM would emulate
the specified CPU type on different host CPUs also)
On the QEMU side we feed the KVM_ARM_TARGET_* through for the two
CPU models we support in TCG which also have a KVM_ARM_TARGET_*
constant, which is to say Cortex-A57 and Cortex-A53. But none
of the other named CPU models QEMU supports for TCG have that
kind of constant.

Presumably now that KVM supports "pass the guest ID regs
that don't match the host" we would want to support our
existing TCG-modelled named CPU types (for which we
already know the ID register values, for TCG) by telling
the kernel what the ID register values are.

thanks
-- PMM
