Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BC82296BD5
	for <kvmarm@lists.linux.dev>; Wed, 25 Feb 2026 07:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772003787; cv=none; b=CAgqrVCZ4ZgafjpEW/o+S0qI+2jHIvf1BbemrRddni3ULjY11p0VKLE9EPQkEjWZTE0f4zq84RdNe3eboULzrntuwdgF42gYnLEnJKsoaLYvqio12hH2ELy9A0ma3BZWLMqPiNNRouSPQxd+TPaJNtnJtn4c1+B2IFuIbeunRrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772003787; c=relaxed/simple;
	bh=xGXEyXsSQzRmxM8FtMy3STvmc4DMp9BHLwqRTciX6BE=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=BiQZicb1sTH+/RIEIN5rKl3l3+nQ3RBo0lIbf84t76L1lTFRXdINyG0GsMgOlSC/AzgT0KkGsNJR/7nmJD/pWstsp5x+8ra/WI3QMgjMPG6PnuKiVPd+oFTH5UFWK6/LMXCRoxlRDkhbWoihINfooF/gVO6ZrveLIHArm35STn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=W5EutY1o; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="W5EutY1o"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772003784;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qL6dea3nPOVHlv2oBcUsVZrWZwNNBBgQt3IQvJSqORw=;
	b=W5EutY1o0Xw2DKHzrU3GtvbN50aVCikTMLFtp2qQ1nw+N93gBeScg5Z8Xg05gdbZrMpRGA
	l61wl9/Hf68qhJSM+qhfUewhr4SL7qXolgGz11HZp9li/4fPYHZKnUSchVyZOKo0M/4S2J
	L+dHI4IxEwSlMdC9+HVjaeYcISsqTFY=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-664-GRR2gRE_MOy50BD62Hmrgg-1; Wed, 25 Feb 2026 02:16:22 -0500
X-MC-Unique: GRR2gRE_MOy50BD62Hmrgg-1
X-Mimecast-MFC-AGG-ID: GRR2gRE_MOy50BD62Hmrgg_1772003782
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4837b7903f3so76411655e9.2
        for <kvmarm@lists.linux.dev>; Tue, 24 Feb 2026 23:16:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772003781; x=1772608581;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qL6dea3nPOVHlv2oBcUsVZrWZwNNBBgQt3IQvJSqORw=;
        b=LebRfTAfdVLUun9FjNWfjPGQx5AoZC5XQG+oHNVsGvVKkg4Yln+B+GF8hq6h28Id2j
         2WHyz90SmqSpxrgwcYocgCdM0qywg4Rw0IF7bq5dLxyt42qpHUKqg0XnJORvqppHsbrw
         ozckFm5+VOTCjWevfCAUYpFrcPOY/6ort6aPs+YdP6gHcptB5zUT6+0If28bFLKKmT6U
         pYeVOu6hhGaTztMK83J8AAerkMeoaOEi5uEVDaU96gT7E63HLlBdkj4jy2fTDyFQn5E7
         XxgRfKIPW61PeibovsIp4TdzR9Jt7YYvtUJq+ryQ2pfevpu4lAAU3euIbBFuYWckQxYb
         1Ibg==
X-Forwarded-Encrypted: i=1; AJvYcCW9t2XzXZzmsrUzwyXZeo7hvP4oKhiqdrBOqytC1EbW0i5yiSQ1exWM2eK5aI5+rd8LownZjLo=@lists.linux.dev
X-Gm-Message-State: AOJu0YyvuqWrXhz0ewpzuz2MomejNAdTS6JU2wrTk+d6MF8xA8Hh1+U8
	OcmnGsqV2wCMv3bxgjq/fzogkmO5xiBCLUncjTr/3lF+lmrGiQohQmpaWhFwWGUHYUxhdYiSr+T
	QyyTiTbtWXCcL0r7hbWZqorRcFMl0nv6N27yxHoAbFmeLnBsx/BGG4pIsxw==
X-Gm-Gg: ATEYQzwN2pT7yLBbm1UqMUVUoU7mCX8LgIaAfKw5RhDQco7r5kZfYg9GkiG59bCLuot
	t3BnMqGa9FzqOh8P4B0iC7ama/kY+wI/gtfvq+l9/R4IGiRGi+/MdOgrTJi6sxcSvNF43MNvf7x
	b2snOJztI/6abBA8VYJl+MpCVNGidR+L9OJgxj6SebqWexEACS6VG98vrv/NiI/n1+WtGu2/ojL
	HL9PNZnjLq242KPK58uEebrd3ViAC9Yc0ktl7K9IJJtZ3eY10YSGx4yU7nXtCn4QoRTFDXk16dp
	hB8jvLDUaNst7vRQIw2DlfhnE1x6cnuAUv8r9tMDN+dlY/GdlSVHa4T+5Op55U4P6z2U5Ng62TF
	F1TtNiuTUH2SvtbCHsnPQ2qVcg5ppcqyPLBO0lmBVukTG4B/B2cNVOtVZniyHHYmEcvDjHm8=
X-Received: by 2002:a05:600c:8708:b0:477:7c7d:d9b2 with SMTP id 5b1f17b1804b1-483a963d62amr213324425e9.32.1772003781523;
        Tue, 24 Feb 2026 23:16:21 -0800 (PST)
X-Received: by 2002:a05:600c:8708:b0:477:7c7d:d9b2 with SMTP id 5b1f17b1804b1-483a963d62amr213324075e9.32.1772003781071;
        Tue, 24 Feb 2026 23:16:21 -0800 (PST)
Received: from rh (p200300f6af25cc00b2a92b19386de96f.dip0.t-ipconnect.de. [2003:f6:af25:cc00:b2a9:2b19:386d:e96f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483bd732eb1sm50579945e9.12.2026.02.24.23.16.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Feb 2026 23:16:20 -0800 (PST)
Date: Wed, 25 Feb 2026 08:16:19 +0100 (CET)
From: Sebastian Ott <sebott@redhat.com>
To: Peter Maydell <peter.maydell@linaro.org>
cc: qemu-devel@nongnu.org, eric.auger@redhat.com, kvm@vger.kernel.org, 
    kvmarm@lists.linux.dev, pbonzini@redhat.com, qemu-arm@nongnu.org
Subject: Re: [PATCH v6 1/1] target/arm/kvm: add kvm-psci-version vcpu
 property
In-Reply-To: <CAFEAcA8O2UEKToJ+zXA6=vvgkRyPKrPwtfHnti7yyGgCGwoJeA@mail.gmail.com>
Message-ID: <0616fe7f-96b8-251e-dc0f-9e15ec8298ba@redhat.com>
References: <20260220115656.4831-1-sebott@redhat.com> <20260220115656.4831-2-sebott@redhat.com> <CAFEAcA8O2UEKToJ+zXA6=vvgkRyPKrPwtfHnti7yyGgCGwoJeA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: QqEQnSGke1OAsUaPx45bty2kBopvfYAT162YYyZYRJY_1772003782
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII; format=flowed



On Tue, 24 Feb 2026, Peter Maydell wrote:

> On Fri, 20 Feb 2026 at 11:57, Sebastian Ott <sebott@redhat.com> wrote:
>>
>> Provide a kvm specific vcpu property to override the default
>> (as of kernel v6.13 that would be PSCI v1.3) PSCI version emulated
>> by kvm. Current valid values are: 0.1, 0.2, 1.0, 1.1, 1.2, and 1.3
>>
>> Note: in order to support PSCI v0.1 we need to drop vcpu
>> initialization with KVM_CAP_ARM_PSCI_0_2 in that case.
>>
>> Reviewed-by: Eric Auger <eric.auger@redhat.com>
>> Tested-by: Eric Auger <eric.auger@redhat.com>
>> Signed-off-by: Sebastian Ott <sebott@redhat.com>
>> ---
>>  docs/system/arm/cpu-features.rst | 11 ++++++++
>>  target/arm/cpu.c                 |  8 +++++-
>>  target/arm/kvm.c                 | 48 ++++++++++++++++++++++++++++++--
>>  3 files changed, 64 insertions(+), 3 deletions(-)
>>
>> diff --git a/docs/system/arm/cpu-features.rst b/docs/system/arm/cpu-features.rst
>> index 3db1f19401..ce19ae6a04 100644
>> --- a/docs/system/arm/cpu-features.rst
>> +++ b/docs/system/arm/cpu-features.rst
>> @@ -204,6 +204,17 @@ the list of KVM VCPU features and their descriptions.
>>    the guest scheduler behavior and/or be exposed to the guest
>>    userspace.
>>
>> +``kvm-psci-version``
>> +  Set the Power State Coordination Interface (PSCI) firmware ABI version
>> +  that KVM provides to the guest. By default KVM will use the newest
>> +  version that it knows about (which is PSCI v1.3 in Linux v6.13).
>> +
>> +  You only need to set this if you want to be able to migrate this
>> +  VM to a host machine running an older kernel that does not
>> +  recognize the PSCI version that this host's kernel defaults to.
>> +
>> +  Current valid values are: 0.1, 0.2, 1.0, 1.1, 1.2, and 1.3.
>> +
>>  TCG VCPU Features
>>  =================
>>
>> diff --git a/target/arm/cpu.c b/target/arm/cpu.c
>> index 10f8280eef..60f391651d 100644
>> --- a/target/arm/cpu.c
>> +++ b/target/arm/cpu.c
>> @@ -1144,7 +1144,13 @@ static void arm_cpu_initfn(Object *obj)
>>       * picky DTB consumer will also provide a helpful error message.
>>       */
>>      cpu->dtb_compatible = "qemu,unknown";
>> -    cpu->psci_version = QEMU_PSCI_VERSION_0_1; /* By default assume PSCI v0.1 */
>> +    if (!kvm_enabled()) {
>> +        /* By default KVM will use the newest PSCI version that it knows about.
>> +         * This can be changed using the kvm-psci-version property.
>> +         * For others assume PSCI v0.1 by default.
>> +         */
>> +        cpu->psci_version = QEMU_PSCI_VERSION_0_1;
>> +    }
>>      cpu->kvm_target = QEMU_KVM_ARM_TARGET_NONE;
>>
>>      if (tcg_enabled() || hvf_enabled()) {
>> diff --git a/target/arm/kvm.c b/target/arm/kvm.c
>> index ded582e0da..5453460965 100644
>> --- a/target/arm/kvm.c
>> +++ b/target/arm/kvm.c
>> @@ -485,6 +485,28 @@ static void kvm_steal_time_set(Object *obj, bool value, Error **errp)
>>      ARM_CPU(obj)->kvm_steal_time = value ? ON_OFF_AUTO_ON : ON_OFF_AUTO_OFF;
>>  }
>>
>> +static char *kvm_get_psci_version(Object *obj, Error **errp)
>> +{
>> +    ARMCPU *cpu = ARM_CPU(obj);
>> +
>> +    return g_strdup_printf("%d.%d",
>> +                           (int) PSCI_VERSION_MAJOR(cpu->psci_version),
>> +                           (int) PSCI_VERSION_MINOR(cpu->psci_version));
>> +}
>> +
>> +static void kvm_set_psci_version(Object *obj, const char *value, Error **errp)
>> +{
>> +    ARMCPU *cpu = ARM_CPU(obj);
>> +    uint16_t maj, min;
>> +
>> +    if (sscanf(value, "%hd.%hd", &maj, &min) != 2) {
>
> %hd is a signed value, so this will accept "-3.-5" I think ?
> Probably we want %hu.

Ugh, right.

> (If you agree I can just make this fix locally, no need for you to respin.)

That'd be great, Thanks!

Sebastian

