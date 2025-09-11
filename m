Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1792434AB1F
	for <kvmarm@lists.linux.dev>; Thu, 11 Sep 2025 16:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757608153; cv=none; b=iJolr2RBZWLwXZEA2TO6vqM8nirAY+HQt4Ab1RyWkPkODvmMlnfZ3mudWHZA/tQ+VDzTyUJGkGGYsozmhbN4+rNL8cCMS7YMhQWQX5lzS3lQaf1agxlKDpQahqIwtFXOPQxwwjT/2UdHHzLcv5z/IvVLvQ90ual4Ma/Zn416yYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757608153; c=relaxed/simple;
	bh=jWqECjnzNNEBJVb6hoiDTVqP5vpjQCwqoIckY4xgjR8=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=kjjpaTH0m5cptO3Enz/ysj4ZKwohNIE++Uj49Hm6X/jjb5RxLSwDqKiCW1B2J89jTI4zxgf7P0tfoP2X/QI2muuyxPfEgTeUUUyp8NqZRxVndN/o8W4prOR7aM+VdgDZxGCCPrxVC78yaCB7EF1Us81Ak5+RwPn3jHm22Nz6fVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=L2uiqsWK; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="L2uiqsWK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757608151;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6IfJq0PeXXpJnmQfIgkF/V+uc6bP+zPZYW7h5in2crk=;
	b=L2uiqsWKpWVnqrNIFkXTJqAjtRmX1IpWAmhBjrf6s/61OrVIAgL0XztBvMX6+RE1YmpPuy
	hdpAZ3T4mjfujk/BnX7HQqrluH6/4/EMSkM6SxBYtl558RQtuRIw9VwF6Bc5sO8H+5ugIt
	aB3z0hBvyhMJSEBu9yZw83hgH3Si374=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-45-RNs3BJdiOsyrujih4qG2Wg-1; Thu, 11 Sep 2025 12:29:09 -0400
X-MC-Unique: RNs3BJdiOsyrujih4qG2Wg-1
X-Mimecast-MFC-AGG-ID: RNs3BJdiOsyrujih4qG2Wg_1757608148
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45cb604427fso6384735e9.1
        for <kvmarm@lists.linux.dev>; Thu, 11 Sep 2025 09:29:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757608148; x=1758212948;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6IfJq0PeXXpJnmQfIgkF/V+uc6bP+zPZYW7h5in2crk=;
        b=LhxMCgyAyh4zezciVa3fX++4nQwPCdaK64RCXH7KAht0M/mlFe3W4D9X+qBfDq2vng
         c3uCp/dK1VYLdJJszxOZ5lUCvFm2iWGNho/kGANz9AZOTsvSf1iV2GEPGKzjk6to7R/U
         hNwVx6QqqISDYiRPLezBf9JggMJT3ptl8V2rc/MSWtJRJuCPdoD9DdsZpuQS2EPpQy39
         5GgstYbw/gF72Dm+6lEz8qy/SFcnjgDeaX8LPYfh6JjX0XAA4/gzTHHCTZSnSV8t8vyz
         OtKR1BWLIrxba8vLwDR6uZ6jC6Ps8sdOwPsU+r9xR9bNvLRtPhu7cBFadrG8Dwtq7d52
         zBzQ==
X-Forwarded-Encrypted: i=1; AJvYcCW25C6TaJrzf+GdSjdMvpDYPYQWkPun/l62P5a6crexdt1LcR/ymuznmflmEp9nNEHOV5DUDDI=@lists.linux.dev
X-Gm-Message-State: AOJu0YwlwDVXp4lfZkhIOg2FSQBrSHZ9v8h3N48s9AXBGgvMgnWQ3XH8
	5nWriJO++WZd+tiizqp4/o8YFnLGwZsc4IXL7yuuwZJerLe+Jplz/JDSubIAZNKFXIT4tNATrWJ
	oWMn+nZxh+pSBbszRJvJOc3w9k4gY6QQ/nTJodcFaQSWCZgHzux4Yuv/bwg==
X-Gm-Gg: ASbGncuhE6LchqG6SR2wiQYB3omVvXvvJ8H+bBeJ67CbH2lFRfkTxKSu8qq51REPEjd
	wxHe7dWMLN6FywNbN4NiPjlv3ZEvQGPxJywnnzJpRnX1NlCXQLnR4/tSTD0727x5FKALZ4Pg3ku
	/vU7mh/NWA45OnZR+dGICwxhnnPIXOowWXdWRXtNmWqBE92SNiw9ye4uFEolVCaQycOrOFlXF3R
	wxNHCdBVOUs0LQJ5T4Br0l+LUxFibq35RZzObgwH7kWCDUasMfU9it6i1gmBopFT3XShqEHUTxD
	vEDGYow1Rp0soFe+xLe/uNNYAwswydkwCwggvIgksHNGVzUvER1M50QRsdH9jVIgETHEENFjSZ9
	ToPfK9oKgiU13wQ==
X-Received: by 2002:a05:600c:5248:b0:45d:d9ab:b85a with SMTP id 5b1f17b1804b1-45f211e520bmr865615e9.7.1757608148303;
        Thu, 11 Sep 2025 09:29:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGY6150HoCh3FfRYfRTEKIcW5EuOXujbRibT3SZGb6KEdyz/nOArM0wpiCpufKuF5ucxLYIpw==
X-Received: by 2002:a05:600c:5248:b0:45d:d9ab:b85a with SMTP id 5b1f17b1804b1-45f211e520bmr865075e9.7.1757608147817;
        Thu, 11 Sep 2025 09:29:07 -0700 (PDT)
Received: from rh (p200300f6af131a0027bd20bfc18c447d.dip0.t-ipconnect.de. [2003:f6:af13:1a00:27bd:20bf:c18c:447d])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45e037b9ebbsm31717955e9.11.2025.09.11.09.29.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Sep 2025 09:29:07 -0700 (PDT)
Date: Thu, 11 Sep 2025 18:29:06 +0200 (CEST)
From: Sebastian Ott <sebott@redhat.com>
To: Peter Maydell <peter.maydell@linaro.org>
cc: Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org, 
    qemu-devel@nongnu.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH 0/2] arm: add kvm-psci-version vcpu property
In-Reply-To: <CAFEAcA8hUiQkYsyLOHFQqexzY3u4ZZZBXvi+DuueExGdJi_HVQ@mail.gmail.com>
Message-ID: <3176813f-77c0-4c39-b363-11af3b181217@redhat.com>
References: <20250911144923.24259-1-sebott@redhat.com> <CAFEAcA8EDJT1+ayyWNsfdOvNoGzczzWV-JSyiP1c1jbxmcBshQ@mail.gmail.com> <8bca09f1-48fe-0868-f82f-cdb0362699e1@redhat.com> <CAFEAcA8hUiQkYsyLOHFQqexzY3u4ZZZBXvi+DuueExGdJi_HVQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: SIip7GTPRpkct5QjqyTKTb-SHI0WxbkIpQ8rDbwsUBA_1757608148
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII; format=flowed

On Thu, 11 Sep 2025, Peter Maydell wrote:
> On Thu, 11 Sept 2025 at 16:59, Sebastian Ott <sebott@redhat.com> wrote:
>>
>> On Thu, 11 Sep 2025, Peter Maydell wrote:
>>> On Thu, 11 Sept 2025 at 15:49, Sebastian Ott <sebott@redhat.com> wrote:
>>>>
>>>> This series adds a vcpu knob to request a specific PSCI version
>>>> from KVM via the KVM_REG_ARM_PSCI_VERSION FW register.
>>>>
>>>> Note: in order to support PSCI v0.1 we need to drop vcpu
>>>> initialization with KVM_CAP_ARM_PSCI_0_2 in that case.
>>>> Alternatively we could limit support to versions >=0.2 .
>>>>
>>>> Sebastian Ott (2):
>>>>   target/arm/kvm: add constants for new PSCI versions
>>>>   target/arm/kvm: add kvm-psci-version vcpu property
>>>
>>> Could we have some rationale, please? What's the use case
>>> where you might need to specify a particular PSCI version?
>>
>> The use case is migrating between different host kernel versions.
>> Per default the kernel reports the latest PSCI version in the
>> KVM_REG_ARM_PSCI_VERSION register (for KVM_CAP_ARM_PSCI_0_2) -
>> when that differs between source and target a migration will fail.
>>
>> This property allows to request a PSCI version that is supported by
>> both sides. Specifically I want to support migration between host
>> kernels with and without the following Linux commit:
>>         8be82d536a9f KVM: arm64: Add support for PSCI v1.2 and v1.3
>
> So if the destination kernel is post that commit and the
> source kernel pre-dates it, do we fail migration?

This case works with current qemu without any changes, since on
target qemu would write the register value it has stored from
the source side (QEMU_PSCI_VERSION_1_1) and thus requests kvm
on target to emulate that version.

> Or is
> this only a migration failure when the destination doesn't
> support the PSCI version we defaulted to at the source end?

Yes, this doesn't work with current qemu. On target qemu would
write QEMU_PSCI_VERSION_1_3 to the KVM_REG_ARM_PSCI_VERSION
register but that kernel doesn't know this version and the
migration will fail.

With this series you could request QEMU_PSCI_VERSION_1_1 on
the source kernel to allow a migration.

(For RHEL we have distro specific machine types that will
use this property to handle that via compats.)

Sebastian

