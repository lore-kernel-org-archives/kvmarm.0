Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D205209F5F
	for <kvmarm@lists.linux.dev>; Thu, 12 Dec 2024 13:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734009218; cv=none; b=CUEfLnviHoRLFJyPm8MJkgaOxI+wqH/w0eG+k7CEFnO27nIBQT2swK4qFy4wsq/0rTi9ExVqMsqw3e0PJLDq6IoRji0vcD2oGb8DXmel3vToAxw0Bo1qSHGLrWax0gFHeOryBy9whe9CswOE/7B3TuSJXdghus3HIb3K31aywUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734009218; c=relaxed/simple;
	bh=1gWJ627Oewxt6wS9Eh2CHGrTM20edxHBpdt7ByE6PEY=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=Nd9OIQvV4I2HeTkNVr0mhdFx4XVPHuuUlFeF0US5IvEajY1GzWsa4koYMNDzcyxy2bP12yD1QQcmq7zks99NKfUSBFq4r/ofR4nlCW28drjytyIzMxrxjwbzTGt3zvci0+Tp+0eE6VB/t3cVwLHtqd72UHSJIHzPeWLLJD1a4Vs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gRZR0lrG; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gRZR0lrG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734009215;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Wxof28cpgCbDnkhoQWNSoVVTvYRkzUUHJ4j75bS+0v0=;
	b=gRZR0lrGHgwIuHSrT/G7TF7DVCcZbxDSUx/kLA3t3EMDRf/czzyE3+6/QFC+2+DEQKvTt5
	4SqkNUjgAjmuYlJFgQ5JWu5EofwzhQvaKeh0ZGFpk35V/NKiSn6H8CAeaynqrSaHrfapQe
	a0YMHAKgudMoDXSW4oDjW0h0JOPPAAY=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-117-IdC1jEKePEaD5Knu7RwZgA-1; Thu, 12 Dec 2024 08:13:32 -0500
X-MC-Unique: IdC1jEKePEaD5Knu7RwZgA-1
X-Mimecast-MFC-AGG-ID: IdC1jEKePEaD5Knu7RwZgA
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-385e9c69929so283032f8f.1
        for <kvmarm@lists.linux.dev>; Thu, 12 Dec 2024 05:13:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734009211; x=1734614011;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Wxof28cpgCbDnkhoQWNSoVVTvYRkzUUHJ4j75bS+0v0=;
        b=kZl3GDpoqvRerWbvNlc0e23zqk3O4ylTImkLM6Rm81gRUgPtd4torDnSf5UkjXZjdz
         E6OApugNkC3xcVfZzGyGkBdu7xfHvWpQ8zlHF6RUOLo0dh3svFbvicUdLlh4t5W5sVnY
         8xnwkD69EaEgxluZc8w9KLPyA2tOkFtRBrqsPKXtCo2qMGe2dw9j6r06soZ1BL2PPdlN
         cHKy04UbcsSic38SRPqQJ9MU3hley46AXS6UY/7PHqE0F5Enp1EtEIXXqT+1GKMR3rKI
         FseEvm2FXWPqX6romDy1Z/YfKhlSe/Q79OMTsglrKBYareRQ13ILBOHS8mGx6mi/p+oj
         OFIg==
X-Forwarded-Encrypted: i=1; AJvYcCWweaLb1iPBhIeyWPrvroZgeIPPhzw0jMcjEkL5L499O7i6eCgpK0shZmUvzRIqqMSldFviI60=@lists.linux.dev
X-Gm-Message-State: AOJu0YzRT9+lVZbzNIy5mLq/Qp8k4Jn9V4d6j1vO5HGND0GSHdNv3aSo
	ceixpEMtQErZifvqjMbDaYQOi6jixwG013BfOjUms5SEIgU4r1wi15lZc7TqPXtT1KpOGPlhToH
	Vt8KpAOd8JxtAsjgI+/J02gm4Ms+BjHbxDb1AMV6bfn6PcsUXGYWXMg==
X-Gm-Gg: ASbGncu0Ik13XhZbEqy8SMHi7DtjhNaBL5TJcDV4Rw9zsXXFEvfcDnGMlHl+jlUXrQA
	oC2EGt7DssccMfweXnDqNub15swH3y8zikRFdXczIWeG+d7x8lplC6F+CGK39HSDj4dbLaDrTO3
	SuMHcH8gQyHW22wXjN2cbQRMQ8JxF74kYsMK2h1FaA2XpC4isEoX5m86Hjw/BCpZPfoYu7K1Qeg
	KFlls2lZaDcKUPW6pgPg+fbZebrk9vifY9B/OYV4ynxaD+e5Dins5TbEqK/935mo/v4oJDsSlMK
	yoOXb4P2hXRnXoB3oNsv+IJVLY1i
X-Received: by 2002:a05:6000:1842:b0:386:4034:f9a8 with SMTP id ffacd0b85a97d-3864cec576fmr5320001f8f.38.1734009210969;
        Thu, 12 Dec 2024 05:13:30 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFA9jreMWG/dYyAwe1URrFUYx8Xo0dt4ngkcqqQNsGq7c7BNDX5RAIlfNLMhrZNJ9g/WfPCmw==
X-Received: by 2002:a05:6000:1842:b0:386:4034:f9a8 with SMTP id ffacd0b85a97d-3864cec576fmr5319966f8f.38.1734009210560;
        Thu, 12 Dec 2024 05:13:30 -0800 (PST)
Received: from rh (p200300f6af0bca008282df582fad0b68.dip0.t-ipconnect.de. [2003:f6:af0b:ca00:8282:df58:2fad:b68])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38782521dfesm3907401f8f.107.2024.12.12.05.13.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Dec 2024 05:13:30 -0800 (PST)
Date: Thu, 12 Dec 2024 14:13:29 +0100 (CET)
From: Sebastian Ott <sebott@redhat.com>
To: Cornelia Huck <cohuck@redhat.com>
cc: eric.auger.pro@gmail.com, eric.auger@redhat.com, qemu-devel@nongnu.org, 
    qemu-arm@nongnu.org, kvmarm@lists.linux.dev, peter.maydell@linaro.org, 
    richard.henderson@linaro.org, alex.bennee@linaro.org, maz@kernel.org, 
    oliver.upton@linux.dev, shameerali.kolothum.thodi@huawei.com, 
    armbru@redhat.com, berrange@redhat.com, abologna@redhat.com, 
    jdenemar@redhat.com, shahuang@redhat.com, mark.rutland@arm.com, 
    philmd@linaro.org, pbonzini@redhat.com
Subject: Re: [PATCH RFCv2 00/20] kvm/arm: Introduce a customizable aarch64
 KVM host model
In-Reply-To: <20241206112213.88394-1-cohuck@redhat.com>
Message-ID: <90431f60-e366-50e9-e95e-2ec9c6812056@redhat.com>
References: <20241206112213.88394-1-cohuck@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: VIPDwdlMKOifxdpwVzzUeyCaxbrJpHla0sIj03h7GhA_1734009211
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; format=flowed; charset=US-ASCII

On Fri, 6 Dec 2024, Cornelia Huck wrote:
> A respin/update on the aarch64 KVM cpu models. Also available at
> gitlab.com/cohuck/qemu arm-cpu-model-rfcv2
>
> Find Eric's original cover letter below, so that I do not need to
> repeat myself on the aspects that have not changed since RFCv1 :)
>
> Changes from RFCv1:
>
> Rebased on more recent QEMU (some adaptions in the register conversions
> of the first few patches.)
>
> Based on feedback, I have removed the "custom" cpu model; instead, I
> have added the new SYSREG_<REG>_<FIELD> properties to the "host" model.
> This works well if you want to tweak anything that does not correspond
> to the existing properties for the host model; however, if you e.g.
> wanted to tweak sve, you have two ways to do so -- we'd probably either
> want to check for conflicts, or just declare precedence. The kvm-specific
> props remain unchanged, as they are orthogonal to this configuration.
>
> The cpu model expansion for the "host" model now dumps the new SYSREG_
> properties in addition to the existing host model properties; this is a
> bit ugly, but I don't see a good way on how to split this up.
>

I gave this a spin today and successfully migrated a VM between 2 similar
machines that only differ in the DIC bit of the cache type register using:

 	-cpu host,SYSREG_CTR_EL0_DIC=0

This allows me to get rid of my horrid qemu hacks to achieve the same.

Thanks,
Sebastian

