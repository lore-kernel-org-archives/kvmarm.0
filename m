Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F0AC382F01
	for <kvmarm@lists.linux.dev>; Wed, 27 May 2026 16:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779897911; cv=none; b=VFrB7gDUgISjBUtEw9ewp3vu4KSb0qGIebVAM6KBrqE/+QmQDeqL4qzFSvBn1gxnd018XPmTPeJ3+Y4nbbmePoAVIGERBe8KWHBPWaVLyyRYQMfkTjx4Lx2zYxMiUKXb5y9inZblOEckerEvMpFZgjkK+GWEXu9ZmFa6FarQNCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779897911; c=relaxed/simple;
	bh=W9A4+gq9EjTPdwQQjlj209WwOG6q9XRP8lnKT0ILuw8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NFP6zjfZSYdXbvB9f/9Lhb51oMvayZVgkv5hYGtqVX/Mld0eZq4F2oP02dK44FkGgylwh5iHRZPbx/ni0KhS4AjGzJv4umVswCOjwWVG+kkqJf0YXvb3PIi70Le3pWbsf3tHjBz3oVDlmpMrm4i9gQmGaR9WeqVt/wPxks6N9ZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aedvuyWs; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aedvuyWs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779897909;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jmx5VvulXmU8ksGA1QX9PtZR7i2VA/lb19l1GvSvoMs=;
	b=aedvuyWsnlOkZ7P0zD+EGbwfTzFkyi3HIao1p6XERsjxT59HgqOc0a4cBSEznkY12GxQ9G
	SSc1RaNwgp9L9phWiHiT49iYljKgvgwRicw9i9sptf2dVSGCYq/HZo5CF1hoyYrKjKaG6D
	hUqtZVP4HHYzCNz8Z60h5Nby7iruVis=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-653-DAWTGlzMPoGNWq6ybxFiWw-1; Wed, 27 May 2026 12:05:03 -0400
X-MC-Unique: DAWTGlzMPoGNWq6ybxFiWw-1
X-Mimecast-MFC-AGG-ID: DAWTGlzMPoGNWq6ybxFiWw_1779897902
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-4411a36715dso7786052f8f.2
        for <kvmarm@lists.linux.dev>; Wed, 27 May 2026 09:05:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779897902; x=1780502702;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jmx5VvulXmU8ksGA1QX9PtZR7i2VA/lb19l1GvSvoMs=;
        b=Ttn52T2adsCCCLzYjA47fgVDwCEs1JaFG5XZr6HZwg7crKwCxAhe38UZWci/BF5lWA
         Wvb2MWCUF+vFvUcgwkLC7TPdLiuLi84+oiOPwcf8TztYCCW6aqYMTVORJ/9VLgTlBDL5
         zv17CoXb6YZPG27FJAG4BH6LBA9/k5dHH2f7nanoh5EOZBDM2WC0P9uYzOC0XjiCLt6B
         6wyNBPaRGTO0kE9fkc9IPQAOZ/fx2gb9woL3f+t0Cq9ntaHuIlAREAFw5K1xDYeDz2XH
         HUQKumrkuj9R/KDfvUwLBiQwuD+fLhiN/S30zWVMmtyddWHdQJ2V/FnpWjGQ/02JqYQ2
         aTMA==
X-Forwarded-Encrypted: i=1; AFNElJ+ld4TCWdZ7ie+oiK/GPUpct2CXdB2iQsY2HH0mpWeRk9wEzfO6F6qSObom18d5RAoWJ9+yRtg=@lists.linux.dev
X-Gm-Message-State: AOJu0YxEPgLSBrTlhzbEmX1xqo55CXmY6yNbyoSTiUpmfCZwYA/HTxO5
	+fuDhT3CBO1NaWDOnZtFxB3s6aDMHnaeIVRLgsFh24CxUeBjfO4EhBsh6HZoVNYqS3aBI1JL7Z/
	3jF4Jm1ByVSowZOVGW7KZybZFwnj69+NqbzOEkP4gJ3V1uuM+zybopzza0g==
X-Gm-Gg: Acq92OHPTdJfP9CBKlfGmGp6DeRFbULCbdjUrcrJb0J3mDQ/9DgoTRQgeU01Hu+8QK8
	n7t7tQnq1uIHNUCKdgmN0tCoEvQ7Jm8y9qTjat72dF6iOFdNvrNjbQaxl0o4gAg3OSo5KwDZFhK
	sHG22JfoB89UDVMiaeGjciebSHYhSxZP1Wp8TFt13SgE2rg39cXOwywISFF/GcUVNJH/QgY12GV
	IS5hYxyrq58U8sNTQ3r8asy/m0ZNPj5fAgxwlnr4oqen/Z2Yp8afoZje3Sp1mimwsFbpH+LhhDl
	CnJxFIC9pjvOEanNVzDFycvyF4bbzwUi4qeGVay2YKPE6fx5FdRuwMmv+1zFgJEVjSZWqoOPBe1
	VOaK/j36DvtoWf4gxmaz2XuftP0HIRRLn4v38I9fdNpc8L3siWTekEl8k5joHFSuxgTjrVlbngu
	by0y42
X-Received: by 2002:a05:6000:1888:b0:441:1e1e:a050 with SMTP id ffacd0b85a97d-45eb38b8a09mr40497332f8f.16.1779897901981;
        Wed, 27 May 2026 09:05:01 -0700 (PDT)
X-Received: by 2002:a05:6000:1888:b0:441:1e1e:a050 with SMTP id ffacd0b85a97d-45eb38b8a09mr40497254f8f.16.1779897901534;
        Wed, 27 May 2026 09:05:01 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45edb5a296bsm6557834f8f.21.2026.05.27.09.04.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 May 2026 09:05:00 -0700 (PDT)
Message-ID: <2fd2057d-c74b-4bbe-b2d0-cb9ed092a37d@redhat.com>
Date: Wed, 27 May 2026 18:04:58 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v5 16/18] target/arm/cpu: Expose writable ID reg field
 properties on the kvm host vcpu model
To: Khushit Shah <khushit.shah@nutanix.com>
Cc: "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
 "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
 "qemu-arm@nongnu.org" <qemu-arm@nongnu.org>,
 "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
 "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
 Shaju Abraham <shaju.abraham@nutanix.com>,
 "yangjinqian1@huawei.com" <yangjinqian1@huawei.com>,
 "cohuck@redhat.com" <cohuck@redhat.com>,
 "richard.henderson@linaro.org" <richard.henderson@linaro.org>,
 "sebott@redhat.com" <sebott@redhat.com>,
 "skolothumtho@nvidia.com" <skolothumtho@nvidia.com>,
 "philmd@linaro.org" <philmd@linaro.org>, "maz@kernel.org" <maz@kernel.org>,
 "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "armbru@redhat.com" <armbru@redhat.com>,
 "berrange@redhat.com" <berrange@redhat.com>,
 "abologna@redhat.com" <abologna@redhat.com>,
 "jdenemar@redhat.com" <jdenemar@redhat.com>
References: <20260519132905.145643-1-eric.auger@redhat.com>
 <20260519132905.145643-17-eric.auger@redhat.com>
 <30F66A6A-E26B-486C-81D1-8E1B2CCB558A@nutanix.com>
 <6c14a58a-60ab-419f-9395-ca3489f6cff8@redhat.com>
 <CA136979-E0CC-420E-9271-63CF27CD7DA5@nutanix.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <CA136979-E0CC-420E-9271-63CF27CD7DA5@nutanix.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: QE9jk30mtJiSigY5QwSy7skO3YymEjxMOnmcKAm3Iik_1779897902
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/27/26 5:56 PM, Khushit Shah wrote:
> So you are saying, if I do, 
> 	-cpu host,sve=on,SYSREG_ID_AA64PFR0_SVE=0
> QEMU will still show sve capabilities to the guest?
Yes that's what I expect. Require more extensive testing though. That
could be way to handle coexistence of different levels of granulaity.
Lowest level applies first, overriden by legacy compositive options. I
guess if you plan to introduce other layers of compositive props you
will most probably handle this situation too.

Thanks

Eric

