Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94B856FB8
	for <kvmarm@lists.linux.dev>; Fri,  3 May 2024 15:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714748825; cv=none; b=L+JhmUOisqhsibOzA7rXMFOwGUR9tREuwC3QLe/xUoLfrroPLBBAaSoZST7+xYrmg/JAL7Pp4EuomLPQKa9R743XSXcUaDEyMJYocQV26UMU27216lRmByBUYOqn0lywtH2QuJb5wlLytMNx3DaJPtxphEeomkqWumJECMF8D9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714748825; c=relaxed/simple;
	bh=k9s24ntmSBOewn9Zrhb/0BIr0dPxZe+x4zy/XWS4LFU=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=fr6ypIlJVbkVSijbDzL4dQCdST9HlSTtM8oQVWV8wJic3WWkzxwSbUJhxeMEtpDlCFkT1pnotRuZbxJwXFS00PAHV3YiAx1XDhvT8vm6MIrsiHtaJkMVd42KkUo9wCAzoDyizf+BM/H9e1OEmW1F56mN9BwBED4PefvKdJuTzh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cI1CcAOk; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cI1CcAOk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714748822;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WQPeshu6niEUNuSz35jaYgA/Ulg7rIGCZOHChBJq76g=;
	b=cI1CcAOkDHqVli3I5HOH1CETjcxOPHKc+djL0NGUGmbVv8WGo/IHPbYwGnlZxalAsIisKz
	yLqbsHBHzGfvfkP9alTeDMMg5fHh8xFMtjktwLIZgQ8WQ0Xg+FlSG68HFmNKC7uVKIVCBB
	6jUDS9S4eDK9+eTMW9+fKU0cUH5elDE=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-536-dY9Ls2bBOI6HNf74oKzYtA-1; Fri, 03 May 2024 11:07:01 -0400
X-MC-Unique: dY9Ls2bBOI6HNf74oKzYtA-1
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-6a0e2c337bfso44176786d6.1
        for <kvmarm@lists.linux.dev>; Fri, 03 May 2024 08:07:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714748820; x=1715353620;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WQPeshu6niEUNuSz35jaYgA/Ulg7rIGCZOHChBJq76g=;
        b=OttkrlbSqQsmwYiT3jx/TU6AbNluEWDEEpwtmdV3X0WcbjESSF46SjLrrwC6OOKJ0c
         7Lax7tlUYPXqV3uTRBPQdNuez1UIpgEECp2d6ZLQHHywRbgvxAhOd8HGqda1lEPpgV6K
         PF7hbG9ccMJRnk3oPQJp33cMlqK7OirNEEq9dGRVAjxP72UJAtf/ZyuMkriUEhkNkgDS
         Rhu2tM7DAmTGx7hzDr2b2bY32QmFO6dOX2i/2Gg4gtBaqZSwnT4W0PUn4ftX3nxjBkZo
         JRSoQyPAn+sYm3dP9WjtZcgp7fQGF5R60Jsea/kIM8nsd+LZdea3S3JpkJsOwhTjjanC
         +Tmg==
X-Forwarded-Encrypted: i=1; AJvYcCXltHcpR7PbU/bCEGaS6GreHHKtKyXyrAHglGxpheapnQbsdbA+6+Wn0YgjaTgqJwgFnjTBAOGZg+LfrPbf+NovT+wt9r4N
X-Gm-Message-State: AOJu0Yy4BQ2uEmq+j111XNdl5BIjWtRmrEodTpVtstrAlkQ/DRx2Puin
	Tr5Ikq1vZ2yI9qoe1KUP6b8dEkupvLfHIfiCKXoq53/TE6+BMYsbmzUwrcNZHYJfgBsUoeAnxkj
	3BWXFuNZMYw4Z6tjJeqvJ7JSigka5JcZapCzFRYjERNsP/XnvqVgTpg==
X-Received: by 2002:a05:6214:1d28:b0:6a0:7e1b:94b2 with SMTP id f8-20020a0562141d2800b006a07e1b94b2mr3500203qvd.16.1714748820701;
        Fri, 03 May 2024 08:07:00 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE58nX1yMSsXx8T4M1bwWkbRW6TndZK2zPSzImpXTW1iQHJ+hiY0QElGI8RXi6FLWzqh7lbjg==
X-Received: by 2002:a05:6214:1d28:b0:6a0:7e1b:94b2 with SMTP id f8-20020a0562141d2800b006a07e1b94b2mr3500172qvd.16.1714748820323;
        Fri, 03 May 2024 08:07:00 -0700 (PDT)
Received: from rh (p200300c93f4cc600a5cdf10de606b5e2.dip0.t-ipconnect.de. [2003:c9:3f4c:c600:a5cd:f10d:e606:b5e2])
        by smtp.gmail.com with ESMTPSA id f19-20020ac84713000000b00437392f1c20sm1652949qtp.76.2024.05.03.08.06.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 May 2024 08:07:00 -0700 (PDT)
Date: Fri, 3 May 2024 17:06:54 +0200 (CEST)
From: Sebastian Ott <sebott@redhat.com>
To: Oliver Upton <oliver.upton@linux.dev>
cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
    linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>, 
    James Morse <james.morse@arm.com>, 
    Suzuki K Poulose <suzuki.poulose@arm.com>, 
    Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Subject: Re: [PATCH v2 2/6] KVM: arm64: unify trap setup code
In-Reply-To: <ZjHmX_O7KTInLuL5@linux.dev>
Message-ID: <5c17b8e9-9281-f6ef-df71-11821e19b112@redhat.com>
References: <20240426104950.7382-1-sebott@redhat.com> <20240426104950.7382-3-sebott@redhat.com> <ZjHmX_O7KTInLuL5@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII; format=flowed

On Wed, 1 May 2024, Oliver Upton wrote:
> On Fri, Apr 26, 2024 at 12:49:46PM +0200, Sebastian Ott wrote:
>> There are 2 functions to set up traps via HCR_EL2:
>
> nitpick: these functions *calculate* the trap values, but do not
> actually set them up. HCR_EL2 doesn't get written to until further down
> the line on KVM_RUN.
>
>> +	if (cpus_have_final_cap(ARM64_HAS_STAGE2_FWB)) {
>> +		vcpu->arch.hcr_el2 |= HCR_FWB;
>> +	} else {
>> +		/*
>> +		 * For non-FWB CPUs, we trap VM ops (HCR_EL2.TVM) until M+C
>> +		 * get set in SCTLR_EL1 such that we can detect when the guest
>> +		 * MMU gets turned on and do the necessary cache maintenance
>> +		 * then.
>> +		 */
>> +		vcpu->arch.hcr_el2 |= HCR_TVM;
>> +	}
>
> It seems to me like calling this once for the lifetime of a vCPU will
> break non-FWB behavior.
>
> Like the comment suggests, these traps are needed to catch the moment
> the S1 MMU is turned on and do cache maintenance to make sure D$ agrees
> with what the guest was doing before enabling the MMU.
>
> KVM_ARM_VCPU_INIT resets SCTLR_EL1, but it seems we'd miss setting
> HCR_TVM in that case.

Ugh, I didn't think about KVM_ARM_VCPU_INIT being called more than once.

But in that case don't we loose the changes done to hcr_el2 in the current
code? E.g.:

void kvm_init_sysreg(struct kvm_vcpu *vcpu)
{
...
 	if (!kvm_has_feat(kvm, ID_AA64ISAR0_EL1, TLB, OS))
 		vcpu->arch.hcr_el2 |= HCR_TTLBOS;
...
}

static inline void vcpu_reset_hcr(struct kvm_vcpu *vcpu)
{
 	vcpu->arch.hcr_el2 = HCR_GUEST_FLAGS;
...
}

Thanks,
Sebastian

