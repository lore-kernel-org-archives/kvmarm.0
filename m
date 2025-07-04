Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08F8D72612
	for <kvmarm@lists.linux.dev>; Fri,  4 Jul 2025 04:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751605109; cv=none; b=CXlDdLFKg4sX1wPVZzvt/ieje7/1fwcmzBkXVato8Ldwb8NQlHUebUrc6NgY4/QxpCwj4quHiqqgP1OgaFRlXO8kKWAYmVz4KpNt4Kc4l2Hjs3asRCIX30a/rSXpVenQpTntVqiBWqUHZ21krmH+jCwkKUJ6yFFYZqvk3sHha7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751605109; c=relaxed/simple;
	bh=SR78OUN999y80a2xAo+6NpCQXfueXEeGFkK75F8f5CU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=thwp3jMn/sl9lupCae+JSI8e0YAHB5Jd5v6//Ifwmn2+CLVbs9ZVHSwVn/C+gQxwBiNxHwwgJzSniK/nRqnnV3+al1Uz8E/c8ujRE2Lja3XWgFnE6kry46U48KBJKrb4LYicpwYX6Ury+aGt34fmLw2T2PqfV3kfn984us25Y8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YvAy/tHi; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YvAy/tHi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751605106;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RWA9x7qhxNW2l1p6ltGUfCp8OmCZaJaVxhg1nTkJ0sU=;
	b=YvAy/tHiLYwF7Ahqo3ll4tTgsaZll03gi9AEW1JXD2490i99Umi9ff2NyyRHqAcB8Vx9T8
	yh9rMUWRwB9qJancrqSwuGdBrboXZvbr4KuyTWxrF6gbKg2jfBWCsXQLRDMWhtLlLlHZ1H
	idFNIWa2+meq58FV2uO9L25FFBC+XDU=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-404-LmDniS_VMFCsIuWWPDoICw-1; Fri, 04 Jul 2025 00:58:25 -0400
X-MC-Unique: LmDniS_VMFCsIuWWPDoICw-1
X-Mimecast-MFC-AGG-ID: LmDniS_VMFCsIuWWPDoICw_1751605104
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-7425efba1a3so675618b3a.0
        for <kvmarm@lists.linux.dev>; Thu, 03 Jul 2025 21:58:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751605104; x=1752209904;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RWA9x7qhxNW2l1p6ltGUfCp8OmCZaJaVxhg1nTkJ0sU=;
        b=u+8Z9ThILiWH6xO9E5gzvTUdqF1UlcMSQ+SJnLhB/2bTg4uPMQ1JBEXg9h3u506Cwc
         nk6JVMSjYOoMufWBsA9tC0H5jQHr0sgHw566CNWwHUN6Ho/Sk6oOrZvOPwNxQWh84iOt
         t1km8VPKg+/P59rRyJrFb6dh4uxMjAxHeyTsHQxKM1HXfSSxwe3uyM/XawpAabk6jCeb
         MxNdzQ+4valpWbBDUDzcNWs+UTiJ+J65w8Y6ljEGlhZBP7MRpYpURE4EPsRgtOTzSVhx
         P3SLH8W/+pC5rA1eZWy6E18HEOsidkQNj+s4VU1Ds8TkyV2Pbt2HHEJhL3iY/QBgM6LT
         3hgA==
X-Forwarded-Encrypted: i=1; AJvYcCV0NHLph6v+IxViyf7DaiRi5VD4ifGfqXAMRazprVwR+7oXKCdfFitOAugFU6vW2EAfxknW2G8=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw3Iy79ilHpETgBjR6yTxV1XuVQm8hYIKs9iQYX9/wC8CP9f97v
	SiAThFrbMGcHgQsqN7V45pot2aDMQI8JO+uGfZDlLMdD3V5+JUrAuvJJWw13/SLUok6oOtsD8kF
	FU7CrcZBpb+TxjYIAYnW31pYXgGGo3UfFMrwy4NVY4Hj2RyhXiTokJt4rdA==
X-Gm-Gg: ASbGncvDNVQl3Ji3+Ee8YdN8N3lpMupOTxwuIsL7eLl4BfpFYxX+/xyibisT1G1gdL0
	z2M788Jtg//wjlfrqDVZ50TuHxQSaI3tScpXLHifoLewaRr+aSCeDhCgT5KTLb7StrTvOxDng73
	lVSYTT4VQwqQfrXgbOqKa84/jecEnlQScxi10Gk5irO1NaT5NrO8rcaE6uEWd5ksqTWo+cS2zkB
	fDv7dscvljALt0kxqoT3lrVisaKGuMO7s5LnNC1blOfkg80so8MtqLFEHI1rofcOiXf6BkO5TRj
	BP+4MhqsgtIqrSF4J/BG4ugr62o0QaQpDFz9tvkmkVWGQEqS94F3bqmgcECf1g==
X-Received: by 2002:a05:6a00:18a1:b0:749:1e60:bdd with SMTP id d2e1a72fcca58-74ce5f38772mr2112069b3a.2.1751605104441;
        Thu, 03 Jul 2025 21:58:24 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHF5wv+DE6Xrth2Z9dMtx7SbYzBfl2e7NF0on99f9M31vN5qmwp6uCO7D9ntAdPIgA97WcR6g==
X-Received: by 2002:a05:6a00:18a1:b0:749:1e60:bdd with SMTP id d2e1a72fcca58-74ce5f38772mr2112052b3a.2.1751605103850;
        Thu, 03 Jul 2025 21:58:23 -0700 (PDT)
Received: from [192.168.68.51] (n175-34-62-5.mrk21.qld.optusnet.com.au. [175.34.62.5])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74ce35cc32fsm1076594b3a.52.2025.07.03.21.58.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Jul 2025 21:58:22 -0700 (PDT)
Message-ID: <0ef9c9bf-70df-47fb-976b-acf6bff4ca3a@redhat.com>
Date: Fri, 4 Jul 2025 14:58:13 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 00/43] arm64: Support for Arm CCA in KVM
To: "Emi Kisanuki (Fujitsu)" <fj0570is@fujitsu.com>,
 'Steven Price' <steven.price@arm.com>,
 "'kvm@vger.kernel.org'" <kvm@vger.kernel.org>,
 "'kvmarm@lists.linux.dev'" <kvmarm@lists.linux.dev>
Cc: 'Catalin Marinas' <catalin.marinas@arm.com>,
 'Marc Zyngier' <maz@kernel.org>, 'Will Deacon' <will@kernel.org>,
 'James Morse' <james.morse@arm.com>, 'Oliver Upton'
 <oliver.upton@linux.dev>, 'Suzuki K Poulose' <suzuki.poulose@arm.com>,
 'Zenghui Yu' <yuzenghui@huawei.com>,
 "'linux-arm-kernel@lists.infradead.org'"
 <linux-arm-kernel@lists.infradead.org>,
 "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
 'Joey Gouly' <joey.gouly@arm.com>,
 'Alexandru Elisei' <alexandru.elisei@arm.com>,
 'Christoffer Dall' <christoffer.dall@arm.com>,
 'Fuad Tabba' <tabba@google.com>,
 "'linux-coco@lists.linux.dev'" <linux-coco@lists.linux.dev>,
 'Ganapatrao Kulkarni' <gankulkarni@os.amperecomputing.com>,
 'Shanker Donthineni' <sdonthineni@nvidia.com>,
 'Alper Gun' <alpergun@google.com>,
 "'Aneesh Kumar K . V'" <aneesh.kumar@kernel.org>
References: <20250611104844.245235-1-steven.price@arm.com>
 <TYXPR01MB1886280D98B07E971424D62BC37BA@TYXPR01MB1886.jpnprd01.prod.outlook.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <TYXPR01MB1886280D98B07E971424D62BC37BA@TYXPR01MB1886.jpnprd01.prod.outlook.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: cUbZuIHj5dEbFOJ6DYgobEXlSQoRzXHMI78PdhwbS9Q_1751605104
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/25/25 11:51 AM, Emi Kisanuki (Fujitsu) wrote:
> We tested this patch in our internal simulator which is a hardware simulator for Fujitsu's next generation CPU known as Monaka. and it produced the expected results.
> 
> I have verified the following
> 1. Launching the realm VM using Internal simulator -> Successfully launched by disabling MPAM support in the ID register.
> 2. Running kvm-unit-tests (with lkvm) -> All tests passed except for PMU (as expected, since PMU is not supported by the Internal simulator).[1]
> 
> Tested-by: Emi Kisanuki <fj0570is@fujitsu.com> [1] https://gitlab.arm.com/linux-arm/kvm-unit-tests-cca cca/latest
> 

The series looks good to me in my test where the host runs in the environment
emulated by QEMU. With below components, the VM can be started, destroyed and
simple workloads can be running in the REALM guest.

Tested-by: Gavin Shan <gshan@redhat.com>

   host.tf-rmm    https://git.codelinaro.org/linaro/dcap/rmm.git
                  (cca/v8)
   host.edk2      git@github.com:tianocore/edk2.git
                  (edk2-stable202411)
   host.tf-a      https://git.codelinaro.org/linaro/dcap/tf-a/trusted-firmware-a.git
                  (cca/v4)
   host.qemu      https://git.qemu.org/git/qemu.git
                  (stable-9.2)
   host.linux     https://git.gitlab.arm.com/linux-arm/linux-cca.git
                  (cca-host/v9)
   guest.qemu     https://git.codelinaro.org/linaro/dcap/qemu.git
                  (cca/latest)
   guest.kvmtool  https://gitlab.arm.com/linux-arm/kvmtool-cca
                  (cca/latest)
   guest.linux    upstream (v6.16.rc2)

Thanks,
Gavin

