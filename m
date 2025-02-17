Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37A48148832
	for <kvmarm@lists.linux.dev>; Mon, 17 Feb 2025 15:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739804783; cv=none; b=AhrkKFbvj6QalSriHxSRh5lReY72n8Iw98p+EbCYrujqYGUPkULr0dbO4+cwPgT7UKWJ3xQYH2eATOS8HF2uyo3YNLcp3O9vbkxxTkDLAnyEPdXG/XqpQDDDXk3SFeGKHJYNH08M2TevaddoWpNuWHgQT3EOe+xbpRlTsMmHQFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739804783; c=relaxed/simple;
	bh=INWds5QQuqynn3QPpkRTgci6yvzjpymnUwqXmd6yz5k=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=p5PzoLNprNh4jcoS16LEjWnRrkkr5clTr0r+S9am721Zmax5lM58i1MoY2WJaxGtjeA7XMO/bhh0sjVVz2k4dvv3b3iAz+aR7U83hoVd//lXGVGs8kiA/6nfYC1xdaud6M8FQhhtwSOKiia2RAgktNaNkeGTeG7PlppN7ODrMQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JR8wWPic; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JR8wWPic"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739804781;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cIhN0R5QlN5gfMPD8y/C9Ok4w/DGGUuFXTQ4OChy43E=;
	b=JR8wWPic3TySoWxnOWoSu1KnHpro9Z5373oWQpE0wO3fk/8qAtdP49Tm2huVW530m2D9Jf
	KFmUSrDKV6RHEPKbLO8L0XnfiQTM7QbyMR0oBqoybWaBvPRS1sNLQDlymdhEQnx0M0CjZ8
	4a++msOXHqrjaqTppAmmZfQS5eVGXVw=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-451-KL5B8tjMPWyp70lFDhZnqA-1; Mon, 17 Feb 2025 10:06:19 -0500
X-MC-Unique: KL5B8tjMPWyp70lFDhZnqA-1
X-Mimecast-MFC-AGG-ID: KL5B8tjMPWyp70lFDhZnqA_1739804779
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4393535043bso25682705e9.1
        for <kvmarm@lists.linux.dev>; Mon, 17 Feb 2025 07:06:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739804778; x=1740409578;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cIhN0R5QlN5gfMPD8y/C9Ok4w/DGGUuFXTQ4OChy43E=;
        b=jyZK8IecqfB8ocYWKGj++/IRuFSJ4GRxWGy/pZbfvviLNuM0okkuRzl6eM7mzDcdm3
         53kQVttGfnTW8gtsP5dZhVZ2XzGctvzY6ZQ0mVLtUJZDCkmxUFSlmhOfaqjLsZAU7ZB+
         L6JxUFe2Go9HLJGzZxtcCRxgxpMq0H1uLKhYLGlKFka2HxkaITuG6IFr8aHaqFNrgtfV
         J494QHSVwZlPw+bB2S3nBoQ53WLWOzEBviGNjVCuqX004QXu2ujlO4YxdoI60ir3EqkW
         wXG2vApBcS81tmc4dqRcXS7rAMAjFOLkObHK3/GQi37ti83RgYvZ8iNDbcM5qvaaSw9v
         Ho3g==
X-Forwarded-Encrypted: i=1; AJvYcCXr6u0wj/DW67Ur0OhHalLSuSmgxAx59m/UCH8D3+ZygxDt/bkPdZW2OAjOBNkzCMFBw+puwF8=@lists.linux.dev
X-Gm-Message-State: AOJu0YyvjJY4YLvcszfmqE1mM1Od3LpC42Wi+1/2RUb1Pg6V5cT2Mh4L
	wvo+XTHuHiONPVXyHY5Ap4uct3KhEiVJsjyd8rMyP4xRlsIuNm9CTUCLaivR8xmNcHoHO/5uCn5
	PmZ6OtyiMNmlI6bOj6mQU/gxzh6QYP3Lbg2IKxgIec3jTTvvp6jlyfg==
X-Gm-Gg: ASbGncuLool5zNxm/P3aR2m0WEUd4R6OFAqS7LtGSHjUfmdiWgRr7s6ooEchNUI9TtI
	vfZ4w1laHcIKsc36Npn+jnFquBvXvdRghOA1fWqkOmEkLcVen7cAON2Xc+eCN7OaiSVLltCYCFA
	y5gg+fXIIKqaROX3PMJjQo75mm7Cb6GdkvUmQ0tENLsUVwMMJX9uBOZwbOsYRa9XG/kijx9P6YT
	tOmr8plnnDtBSyC6gK9aOrj4sozhTlyJlBVYcFe+np4G/UT6DW6IE3JlElwlznMae5GsBUYXOhI
	hwWsi/jvbYZcp/RJS/q4qOOd4VVmgUW1TNej/rrTvmGJyMLWh8W4IQ==
X-Received: by 2002:a05:600c:1784:b0:439:5fa1:af56 with SMTP id 5b1f17b1804b1-43960bbfd9fmr182694385e9.2.1739804778572;
        Mon, 17 Feb 2025 07:06:18 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEVu6DcpgSOODbx4M+M3zf9KaHfo6c0Pz4pVxnIXGaBPyQrP1BWzFL6eAilUcGtKBfEe91Usw==
X-Received: by 2002:a05:600c:1784:b0:439:5fa1:af56 with SMTP id 5b1f17b1804b1-43960bbfd9fmr182693755e9.2.1739804778154;
        Mon, 17 Feb 2025 07:06:18 -0800 (PST)
Received: from rh (p200300f6af0e4d00dda53016e366575f.dip0.t-ipconnect.de. [2003:f6:af0e:4d00:dda5:3016:e366:575f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38f259d5c29sm12533867f8f.72.2025.02.17.07.06.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Feb 2025 07:06:17 -0800 (PST)
Date: Mon, 17 Feb 2025 16:06:16 +0100 (CET)
From: Sebastian Ott <sebott@redhat.com>
To: Oliver Upton <oliver.upton@linux.dev>
cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
    Suzuki K Poulose <suzuki.poulose@arm.com>, 
    Zenghui Yu <yuzenghui@huawei.com>, 
    Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
    Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>, 
    Cornelia Huck <cohuck@redhat.com>, Eric Auger <eric.auger@redhat.com>, 
    linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
    linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/4] KVM: arm64: Allow userspace to change MIDR_EL1
In-Reply-To: <Z7BoydkyT_h0gwOV@linux.dev>
Message-ID: <afac82bb-2d7d-66d0-cdb8-d8e3471a2bed@redhat.com>
References: <20250211143910.16775-1-sebott@redhat.com> <20250211143910.16775-2-sebott@redhat.com> <Z7BoydkyT_h0gwOV@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: gwlsz-wADaABMMhDCnViBGPMVNxSs-lSy5TfVE-_0sM_1739804779
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII; format=flowed

Hello Oliver,

On Sat, 15 Feb 2025, Oliver Upton wrote:
> On Tue, Feb 11, 2025 at 03:39:07PM +0100, Sebastian Ott wrote:
>> +static int set_id_reg_non_ftr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
>> +			      u64 val)
>> +{
>> +	u32 id = reg_to_encoding(rd);
>> +	int ret;
>> +
>> +	mutex_lock(&vcpu->kvm->arch.config_lock);
>
> There's quite a few early outs, guard() might be a better fit than
> explicitly dropping the lock.

Yea, I thought about that too but most of the other functions in that file
use the classic lock primitives. But you're right - it looks cleaner.

>
>> +	/*
>> +	 * Since guest access to MIDR_EL1 is not trapped
>> +	 * set up VPIDR_EL2 to hold the MIDR_EL1 value.
>> +	 */
>> +	if (id == SYS_MIDR_EL1)
>> +		write_sysreg(val, vpidr_el2);
>
> This is problematic for a couple reasons:
>
> - If the kernel isn't running at EL2, VPIDR_EL2 is undefined
>
> - VPIDR_EL2 needs to be handled as part of the vCPU context, not
>   written to without a running vCPU. What would happen if two vCPUs
>   have different MIDR values?

Indeed. Sry, I hadn't thought about that. That makes much more sense now.

> Here's a new diff with some hacks thrown in to handle VPIDR_EL2
> correctly. Very lightly tested :)

Thank you very much! I've integrated that and currently run some tests
with it.

Sebastian

