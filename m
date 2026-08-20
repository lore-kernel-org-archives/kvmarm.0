Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C26F43BDC9
	for <kvmarm@lists.linux.dev>; Thu, 20 Aug 2026 11:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787226592; cv=none; b=q7HA5xyjLVdAMCBzkzCpq6iTBopdF9Nd6NkAurU/cTXrDjKcNoKg+3VHQiB6cHEZyjhrNHuuvVyf33BEGZsVJ4GYa4s9k3T2uS95mO7sY59DLVOifpo7tYO5uryBeb+z94J/wxH3dXMyOUp9jOabidTMg6UKXAU+nd0zq9FEYNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787226592; c=relaxed/simple;
	bh=+ZX8LYgvSyz0Ca8RkSNuRkyCyXrX4BMJYsgsuJR5i1U=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=kzOGeIRDZ8iDMeVLCzUcoCbO2m+RjQsauonaGiA8DkB7BfF4lYwBGzJebZvgbZ35PX1Jfr8TUD6yUC1OeAHF8G4luFVo2E/66/1kmjXsNcm3JHsApqBgCpsgJCqe4DuipwpoSVt6CnxgT+dDUSpTvxenhDDyWX/+WMy6h/Ek8O0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=grNs4l7m; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="grNs4l7m"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787226586;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=A4vay6hXX3iVyfYX6w1TLG8aJVsF5JcuByAXnGPdkGM=;
	b=grNs4l7mjSUmCkT5S1kiEGQXjvORlmrYiAh4jmExPlQBQ0qJ01n9msPo631aM2ASNja8Yw
	ZeCVUNUhgmssZujqEABt9VZ+bbAamZzYyZTljEV4TIuhsn+kiHVikpFdBGSkvmY7PHoZPq
	glbeXfQeLGXbywOTHgg51/evdnCRIkw=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-364-tIc7fU1lP0CeVIM_P1tuJw-1; Thu,
 20 Aug 2026 07:49:38 -0400
X-MC-Unique: tIc7fU1lP0CeVIM_P1tuJw-1
X-Mimecast-MFC-AGG-ID: tIc7fU1lP0CeVIM_P1tuJw_1787226576
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7CF68180034C;
	Thu, 20 Aug 2026 11:49:35 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.44.22.12])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 99F0F180034C;
	Thu, 20 Aug 2026 11:49:34 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 3314A21E6920; Thu, 20 Aug 2026 13:49:32 +0200 (CEST)
From: Markus Armbruster <armbru@redhat.com>
To: Eric Auger <eric.auger@redhat.com>
Cc: eric.auger.pro@gmail.com,  qemu-devel@nongnu.org,  qemu-arm@nongnu.org,
  kvmarm@lists.linux.dev,  peter.maydell@linaro.org,
  shaju.abraham@nutanix.com,  khushit.shah@nutanix.com,
  yangjinqian1@huawei.com,  cohuck@redhat.com,
  richard.henderson@linaro.org,  sebott@redhat.com,
  skolothumtho@nvidia.com,  philmd@oss.qualcomm.com,  maz@kernel.org,
  oliver.upton@linux.dev,  pbonzini@redhat.com,  berrange@redhat.com,
  abologna@redhat.com,  jdenemar@redhat.com
Subject: Re: [RFC PATCH v7 12/18] target/arm/kvm: Introduce
 kvm_arm_expose_idreg_properties
In-Reply-To: <20260726153221.24773-13-eric.auger@redhat.com> (Eric Auger's
	message of "Sun, 26 Jul 2026 17:29:50 +0200")
References: <20260726153221.24773-1-eric.auger@redhat.com>
	<20260726153221.24773-13-eric.auger@redhat.com>
Date: Thu, 20 Aug 2026 13:49:32 +0200
Message-ID: <87a4qh3tbn.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: 8YoxVv4c2SZnGiIW8qQqkc7Y5M8CkkKGgfi65j3XX60_1787226576
X-Mimecast-Originator: redhat.com
Content-Type: text/plain

Eric Auger <eric.auger@redhat.com> writes:

> This helper decode the ID reg writable mask, matches it against
> ID reg fields defined in target/arm/cpu-idregs.h.inc and
> for each writable named field, generates a uint64 property.
>
> REVIDR_EL1 and AIDR_EL1 are writable but they do not expose any
> field. They will be handled separately.
>
> Signed-off-by: Eric Auger <eric.auger@redhat.com>

[...]

> diff --git a/target/arm/kvm.c b/target/arm/kvm.c
> index 4f9b0a559d..1a78893f87 100644
> --- a/target/arm/kvm.c
> +++ b/target/arm/kvm.c

[...]

> +static void set_sysreg_prop(Object *obj, Visitor *v,
> +                            const char *name, void *opaque,
> +                            Error **errp)
> +{
> +    ARM64SysRegField *field = (ARM64SysRegField *)opaque;
> +    ARMCPU *cpu = ARM_CPU(obj);
> +    uint64_t *idregs = cpu->isar.idregs;
> +    uint64_t old, value, mask;
> +    int lower = field->shift;
> +    int length = field->length;
> +    int index = field->index;
> +
> +    if (!visit_type_uint64(v, name, &value, errp)) {
> +        return;
> +    }
> +
> +    if (length < 64 && value > ((1 << length) - 1)) {
> +        error_setg(errp,
> +                   "idreg %s set value (0x%lx) exceeds length of field (%d)!",
> +                   name, value, length);
> +        return;
> +    }
> +
> +    if (field->arch_vals) {
> +        /* this field has some enum values */
> +        for (int i = 0; i < field->arch_vals_count; i++) {
> +            if (value == field->arch_vals[i].value) {
> +                goto valid;
> +            }
> +        }
> +        error_setg(errp,
> +                   "idreg %s set value (0x%lx) does not match any "
> +                   "arch valid enum value!", name, value);

Scratch the !

From error_setg()'s contract:

 * The resulting message should be a single phrase, with no newline or
 * trailing punctuation.

> +        return;
> +    }
> +
> +valid:
> +
> +    mask = MAKE_64BIT_MASK(lower, length);
> +    value = value << lower;
> +    old = idregs[index];
> +    idregs[index] = old & ~mask;
> +    idregs[index] |= value;
> +    trace_set_sysreg_prop(name, old, mask, value, idregs[index]);
> +}

[...]

