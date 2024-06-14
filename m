Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E5CA15A85B
	for <kvmarm@lists.linux.dev>; Fri, 14 Jun 2024 15:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718379108; cv=none; b=KwIH5t2KHELVq4CxRypK2ImKnKzpfhbt3d3ZzQQImW2PoHBlENDZ2QD5B/WfTGTCLUvgUKBJFElxGzsnQ5TSe0LEjMrKh0cUkETfBarf+3fLc9ZsqEIRIhqSpWlOc6RtZ2h6NxyNbtmXCYMZH+CTucjhjVSVHDMOvNTvXZWoN6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718379108; c=relaxed/simple;
	bh=hSgZmiAS+svIYqQDF8KSPSvHB4W5pXbLYGkhdqqsXJI=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=hbPwBND1WzY1s2Iu34vzbGcI0SzQUkRlCJMu/xzfO7j4oe49c3m0FAC49GE50cQP788ora8Kz8Zk9LPcgv1OAQ2Iezma480CDZ2n1qlCFYRsErckfnPBXTIquzt/3YtOxTXTR2aqOX0r9X7uYLBT9W1cvtuRj4kxLh/hzRtVdOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=C3xheYXO; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="C3xheYXO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718379105;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zw5mxcQ5wldSbOobj9exImYqdyspUnQRuccECHVHSQU=;
	b=C3xheYXOxKtMzJY3qvxjBfL4VG6ulFGmPdzc/kRN8suoMaUl16pIGFZpeYD3IOJFDECKW5
	rIWpkCgnymF9y7th1PCHvuLU5+SRmH/Aty+InifhJSFsMBuubzu8dTMp3fEgZyOxQtFJSu
	7KPqBcT27tVYGsmIpw1xUnM9/EYhE+g=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-677-k9_fVN19O4mwMeXBcpSAMw-1; Fri, 14 Jun 2024 11:31:42 -0400
X-MC-Unique: k9_fVN19O4mwMeXBcpSAMw-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-35f1f8d48b3so1354154f8f.0
        for <kvmarm@lists.linux.dev>; Fri, 14 Jun 2024 08:31:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718379101; x=1718983901;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zw5mxcQ5wldSbOobj9exImYqdyspUnQRuccECHVHSQU=;
        b=pmKO2y3PtKfVoPp+ztknQgej3f1QlFgsTg4qcQZRfjIOdJ3gRaw+dJLzWP17dN3YX3
         DSuaTifKngBKqxY2Dv0KVDQjjR00w7DQdUdggFmR35ZWx4YkPiPLuvVgjwVSymuIRUFt
         //bd4Z4h/4tkn5yA16EvcNnDLZfnR3dBiMZk8TEHbkwptL9TdgW4CtJ6rbnWd23CznAV
         2hl2LjxXdEyhCm2+7ZpiSaYeTPpO/1p7n6FD8rrEh/sG16CivuhEsnNaCGgW9Zs9LLW7
         pd1Rj9O4H6LtJ9jE9oRWz41vLkrfQTVIr2vzgtHwGerKJ1rhweTeB64KWsvwSILCoYTt
         YJoA==
X-Forwarded-Encrypted: i=1; AJvYcCW9NuFpzPyLP4LEZP8mYK15YqBY4oKWqWlqJ8TBiRAuTcXboagEK+K3RZvkFpz/dOeWGFetIZA9pHv/XS9JVgKyN3T1I13z
X-Gm-Message-State: AOJu0Yx9kjq/0zfJyBG1dYPH4A6yZ8EftWvb+kja+VNkMNkn7Z6PLRfL
	yaacloa01uzwnI+2Wk+waUJdwaR0abLeuB0KhV2Mzs7AZN7/UjOWqlYy2f91WOFypV0QjB2u7w9
	eSU9utEycMvaYgJbxCTcKMujpWgLdBQHlc8tV5pZwiY02crMgYd8EHA==
X-Received: by 2002:a5d:6306:0:b0:35f:f58:38fc with SMTP id ffacd0b85a97d-3607a764d63mr1976967f8f.26.1718379100948;
        Fri, 14 Jun 2024 08:31:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFysnn8yQfXYEELPiEMpb7qalQGUfkEF5dvkN1fWbdzkeZrNdNu860UPxNqrvm/1llrzek+jg==
X-Received: by 2002:a5d:6306:0:b0:35f:f58:38fc with SMTP id ffacd0b85a97d-3607a764d63mr1976956f8f.26.1718379100569;
        Fri, 14 Jun 2024 08:31:40 -0700 (PDT)
Received: from rh (p200300c93f02d1004c157eb0f018dd01.dip0.t-ipconnect.de. [2003:c9:3f02:d100:4c15:7eb0:f018:dd01])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3607509c8fbsm4690652f8f.43.2024.06.14.08.31.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jun 2024 08:31:40 -0700 (PDT)
Date: Fri, 14 Jun 2024 17:31:37 +0200 (CEST)
From: Sebastian Ott <sebott@redhat.com>
To: Oliver Upton <oliver.upton@linux.dev>
cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
    linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>, 
    James Morse <james.morse@arm.com>, 
    Suzuki K Poulose <suzuki.poulose@arm.com>, 
    Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
    Shaoqin Huang <shahuang@redhat.com>, Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH v4 3/6] KVM: arm64: add emulation for CTR_EL0 register
In-Reply-To: <Zmty99X4hnYwtRS4@linux.dev>
Message-ID: <0b148e21-1714-f4f7-bc77-2a12b990572d@redhat.com>
References: <20240603130507.17597-1-sebott@redhat.com> <20240603130507.17597-4-sebott@redhat.com> <ZmtwjLbP283ra0Xq@linux.dev> <Zmty99X4hnYwtRS4@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII; format=flowed

Hi Oliver,

On Thu, 13 Jun 2024, Oliver Upton wrote:
> On Thu, Jun 13, 2024 at 10:19:56PM +0000, Oliver Upton wrote:
>> On Mon, Jun 03, 2024 at 03:05:04PM +0200, Sebastian Ott wrote:
>>> +static int validate_cache_topology(struct kvm_vcpu *vcpu, u64 ctr_el0)
>>> +{
>>> +	const struct sys_reg_desc *clidr_el1;
>>> +	unsigned int i;
>>> +	int ret;
>>> +
>>> +	clidr_el1 = get_sys_reg_desc(SYS_CLIDR_EL1);
>>> +	if (!clidr_el1)
>>> +		return -ENOENT;
>>
>> This doesn't actually matter if we agree on dropping the cross-checking,
>> but if this lookup fails it is 100% a KVM bug. Returning ENOENT isn't
>> exactly right here, since it gives userspace the impression that the
>> sysreg index it tried to access does not exist.
>>
>> So in the future it'd be good to return EINVAL in places where the
>> kernel did something stupid, probably with a warning for good measure.

OK.

>>> +static int set_ctr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
>>> +		   u64 val)
>>> +{
>>> +	u64 ctr, writable_mask = rd->val;
>>> +	int ret = 0;
>>> +
>>> +	mutex_lock(&vcpu->kvm->arch.config_lock);
>>> +	ctr  = vcpu->kvm->arch.ctr_el0;
>>> +	if (val == ctr)
>>> +		goto out_unlock;
>>> +
>>> +	ret = -EBUSY;
>>> +	if (kvm_vm_has_ran_once(vcpu->kvm))
>>> +		goto out_unlock;
>>> +
>>> +	ret = -EINVAL;
>>> +	if ((ctr & ~writable_mask) != (val & ~writable_mask))
>>> +		goto out_unlock;
>>> +
>>> +	if (((ctr & CTR_EL0_DIC_MASK) < (val & CTR_EL0_DIC_MASK)) ||
>>> +	    ((ctr & CTR_EL0_IDC_MASK) < (val & CTR_EL0_IDC_MASK)) ||
>>> +	    ((ctr & CTR_EL0_DminLine_MASK) < (val & CTR_EL0_DminLine_MASK)) ||
>>> +	    ((ctr & CTR_EL0_IminLine_MASK) < (val & CTR_EL0_IminLine_MASK))) {
>>> +		goto out_unlock;
>>
>> I'd prefer if we addressed the issue w/ arm64_check_features() by making
>> CTR_EL0 behave like the other registers in the ID space instead of
>> open-coding these sorts of checks.
>>
>> I believe that can be accomplished by using kvm_read_sanitised_id_reg()
>> as the ::reset() function in the descriptor and initializing
>> kvm->arch.ctr_el0 in kvm_reset_id_regs().
>
> Durr, I got rid of kvm_reset_id_regs() in commit 44cbe80b7616 ("KVM: arm64:
> Reset VM feature ID regs from kvm_reset_sys_regs()"), I should engage
> brain before responding.
>
> Adding a check for encoding == CTR_EL0 to is_vm_ftr_id_reg() seems to be
> the best way out.

Hm, but in that case we'd use reset_vm_ftr_id_reg() meaning we would have
to make IDREG() work for this reg. Either by adding special handling to
that macro or by increasing kvm->arch.id_regs[] a lot - both options don't
sound very appealing.

I'll think of smth to make arm64_check_features() work for this.

Thanks,
Sebastian

