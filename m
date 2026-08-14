Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 433FB3D093A
	for <kvmarm@lists.linux.dev>; Fri, 14 Aug 2026 13:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786714746; cv=none; b=WUVbVvWlwbNTcVi3p6d+v41vqzvwTm+9HwCUs0Ipbfkko5o56v+WlNhZrckSMsonhWDLZU0Iqm/qyF/6Xs8RficXZ7SFTpjLIKr/cJ9GtKfeQAHGr8OngqTQs9t8v41P1tHjeLXx5nx6Iqv7A6LxQAKSGfPVCk6OlBxppDHduaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786714746; c=relaxed/simple;
	bh=QpUQuuG7/+rqT7wnWFGA/3pwxnnWqslskt0CYKYtDqc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Hh9kX6uG2MX80CKzb+HVuYNRnusZ88+IUPjAdov+mUmkRjtt12GlCAVEPPtZKx+NWsNKLR/wWZ2+IxLeym+/fiFQ9tn0AxsP0N7BzxZ1+7xbfxL1FqPOo7tFuZY6ZH4PekW/FV4bXCjTjgjOr1Ku7rtx+L5k1fAvcWlQzdMbmns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NWtCP1HR; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NWtCP1HR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786714744;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LXky0SHEEqjOX8UubfqEiUPD1zbdoOGebeozSEqSXho=;
	b=NWtCP1HRT03HQMisTiTPJ9e23T+3NGmdNiJKm3/9qV7Z1aZNMhxKTf0Rs/5G4Ma/JQ98np
	jlnG+j4P2uhCecFs005n1ISDDkCAtczZqek/W4HSzoqQWKfna/9a5JZlS3T08n5dOgoe5K
	8BqlvPULnwhXiSFYMly5ZrKV/XvWyDY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-35-smsvvkJKM4CHqLIA7hBr6A-1; Fri, 14 Aug 2026 09:39:02 -0400
X-MC-Unique: smsvvkJKM4CHqLIA7hBr6A-1
X-Mimecast-MFC-AGG-ID: smsvvkJKM4CHqLIA7hBr6A_1786714742
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4955fd77c18so6770985e9.2
        for <kvmarm@lists.linux.dev>; Fri, 14 Aug 2026 06:39:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786714741; x=1787319541;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LXky0SHEEqjOX8UubfqEiUPD1zbdoOGebeozSEqSXho=;
        b=nYCF9B/Tqqq4psZ83UTGQll6TXwtKMb7UiXFxdFvvJDy8Y01Xp/Fnmv5Lcmx5ky9AE
         +Je2JQ7y0Wi54cJkbg4jWU+6OPxsHdupmAdL0ZHm5WWsZU1mXS73hyFF3Vg4qVrwVwst
         VpSDb4jeZ6rJIrDpj++rR/3TDRy9srO/05lxk52NJopeJmH7kuatMwCnfMMKZ+doOch/
         APHAMz2LxjQe1xxl46XA3NmtbKZxOYoyWgVkcRsIJP7+n79gP6GFl9rzLYJdjZuwmfq/
         YlW8eeP1aQT2156o2HFtwmWYNT2kbp7Mcl6zAfMOhiPawix6yMkXWds4MUZgV/XSKqq8
         xIeQ==
X-Forwarded-Encrypted: i=1; AHgh+Rpyzw0Lmtjv1nuzJAewXtxD4QPmPb3XqOp48iAYWXEfmHueeWbL9Hs4zd6gK9EOlVS8nBmv9YI=@lists.linux.dev
X-Gm-Message-State: AOJu0YxzDHgGHkbz9t1/wEZqcbl0IpzgVSCvXQh4ZPBv9+godNrIgPyk
	cQENPqCiR1QXteKpCnUCdvEP5YpnOfgC3EqAjBKQS8qCyXLN5u+H72l5+n7RzjnK1Up6Wc7+6kV
	prgC0Op326bLWZFeHX7czkJi6Riq7kB1Rch4gr3c93A95Z9DIU5GOT9qDcw==
X-Gm-Gg: AR+sD116ZNLDaA4lF0CCO9CvgwVa57VRRXbPK7moX7pN57Wnlb1zSLsQ3PdjaKUnefI
	8eViYheN+fHbxmAg/DUGOU+wapqOxntsBXc1V7rHtfRA1dDisV6X6c4QskpYGD3UL2JPr5yr5TJ
	BKpv71tJ+8kq1scc9kHoopZzKFAhQr2aXtpJoQ8zOH66Z7X3et86Fvnb4BypnaXA8x/I6Tkleqn
	IQhXHomspQpEtgy9AVJH4AKcmw4Q2ZCPfZFoHb74K3q2cmTt5C+uu1y92uCDMR0cwsqKSEaJuv2
	vIRMuURFpc9bneUUhj9AWM1qBNUWQ/1oQJz6BHcEerbeo4j5N+gvPAB5+27E6KtqyxQiNT0tUci
	hd43FUoxkYXXmkiudaSX1qx4CUDSA+XZcZoO1oAhEvSkP+uGb
X-Received: by 2002:a05:600c:8218:b0:499:593b:a15b with SMTP id 5b1f17b1804b1-499879357cemr96313025e9.1.1786714741628;
        Fri, 14 Aug 2026 06:39:01 -0700 (PDT)
X-Received: by 2002:a05:600c:8218:b0:499:593b:a15b with SMTP id 5b1f17b1804b1-499879357cemr96312185e9.1.1786714741198;
        Fri, 14 Aug 2026 06:39:01 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49989af26eesm31815315e9.15.2026.08.14.06.38.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Aug 2026 06:39:00 -0700 (PDT)
Message-ID: <9909725f-7dd8-4f88-b016-2a6134906a60@redhat.com>
Date: Fri, 14 Aug 2026 15:38:57 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [RFC PATCH v3 16/19] qmp: add query-cpu-props-info command
To: Khushit Shah <khushit.shah@nutanix.com>,
 Markus Armbruster <armbru@redhat.com>
Cc: "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
 "qemu-arm@nongnu.org" <qemu-arm@nongnu.org>,
 "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
 "cohuck@redhat.com" <cohuck@redhat.com>,
 "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
 "richard.henderson@linaro.org" <richard.henderson@linaro.org>,
 "maz@kernel.org" <maz@kernel.org>,
 "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
 "berrange@redhat.com" <berrange@redhat.com>,
 "abologna@redhat.com" <abologna@redhat.com>,
 "jdenemar@redhat.com" <jdenemar@redhat.com>,
 "gshan@redhat.com" <gshan@redhat.com>,
 "skolothumtho@nvidia.com" <skolothumtho@nvidia.com>,
 "sebott@redhat.com" <sebott@redhat.com>,
 "philmd@linaro.org" <philmd@linaro.org>,
 "yangjinqian1@huawei.com" <yangjinqian1@huawei.com>,
 Shaju Abraham <shaju.abraham@nutanix.com>,
 Mark Cave-Ayland <mark.caveayland@nutanix.com>,
 Prerna Saxena <prerna.saxena@nutanix.com>
References: <20260716213858.609699-1-khushit.shah@nutanix.com>
 <20260716213858.609699-17-khushit.shah@nutanix.com>
 <878q6m5qox.fsf@pond.sub.org>
 <3099C064-6051-4B93-BE0F-C54B7FD91D82@nutanix.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <3099C064-6051-4B93-BE0F-C54B7FD91D82@nutanix.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ypnPLnoKpRCMGCboHpUuKdR9R_dhm0wxC_Xg3dT3dg4_1786714742
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Khushit,

On 8/5/26 8:47 AM, Khushit Shah wrote:
>
>> On 4 Aug 2026, at 12:15 PM, Markus Armbruster <armbru@redhat.com> wrote:
>>
>> !-------------------------------------------------------------------|
>>  CAUTION: External Email
>>
>> |-------------------------------------------------------------------!
>>
>> Khushit Shah <khushit.shah@nutanix.com> writes:
>>
>>> Introduce the 'query-cpu-props-info' QMP command. For CPU model
>>> properties it reports the type (boolean or number) and the set of values
>>> supported under the active accelerator and host.
>>>
>>> For numbers the supported values are expressed as a list of inclusive
>>> {min, max} ranges; for booleans as the list of allowed true/false
>>> values.
>>>
>>> The command and its return types (CpuPropertyType, CpuPropertyInfo and
>>> friends) are defined in qapi/machine.json rather than an Arm-specific
>>> schema, since the concept applies to other targets (e.g. x86, riscv)
>>> too. Target that do not implement it return an error.
>>>
>>> The Arm/KVM implementation spins up a scratch "host" vCPU object,
>>> walks its QOM properties: SYSREG_ ID-register fields become 'number'
>>> properties whose ranges come from arm_field_get_supported_values(),
>>> and the advertised feature toggles become 'boolean' properties.
>>>
>>> Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
>> This explains what the command does and how it's implemented.  It's
>> silent on the most important aspect: why do we want the command?  What
>> is its intended purpose?
> Will add something like:
>
> This helps the management stack to discover which values are supported
> for a given CPU property. This is especially important for non-boolean
> properties, where knowing that the host has value 'x' does not inherently
> reveal the full range of valid values supported on the host.

How does x86 handle this at the moment, they don't have the cmd either?
How do they currently introspect what are the valid values for a
specific host? Is it easier for them?

Thanks

Eric
>
>
>

