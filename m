Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1009C52FE2A
	for <kvmarm@lists.linux.dev>; Wed, 23 Sep 2026 14:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173903; cv=none; b=MpbFcnGjwjIz1rQtYKHWyShixUBrNYSjdnFwvGoDQoneDkFuJmKjdP4vO4q+LloavVrd2WiKtqXZMpPmIOguhzqYNgpQo4FZ7DDqNLqY82aB3YYRSBrHxp96xH12+uLC+Vu51FYNkazAvZA6uC7Z+odDpVH9Rh8ULNkn9VEZKuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173903; c=relaxed/simple;
	bh=MUzrLs0lR/Oe8D54eAsDUY6kfGDrpGhi+dVUR8nDw7Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kdpBnWSGO7ksMQqbCHqyNw5W2iF7i6c0RsSw1pjtAzb8Er9nvOGtCxbHZFQVQP1WfebfwvDLF/v/2/x+pFXsRUyBO0EMo2L8IIi9AVZT9LQGl+6KauS02LDXTfcixbI1WixqJkCAELVNByVwk3aTbc7IQKw+qZPxIWFRjFg1G7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ui59tHZq; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ui59tHZq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790173900;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oxDyo6wS9tLNRj9z6xsNaM4tf77SpHmeasoP+i9z6qY=;
	b=Ui59tHZqa2z3EtwP28XTFKxprfdtpskVCi4hkD/ygnLkLKOI04+3i+e+g9Nt7ijlWL0P8N
	YgLFUGmVGWbE7YFl6yHmmc93eLvwteHz+pIY4iCzCzTLwb3odT0g/SZT5dXSVqasSo5+9E
	aZvcFu0uJ5nUZrQh4MdtCtbqEYtvtCE=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-328-CLgIHSt-OoiRLYMgz1gbWw-1; Wed, 23 Sep 2026 10:31:39 -0400
X-MC-Unique: CLgIHSt-OoiRLYMgz1gbWw-1
X-Mimecast-MFC-AGG-ID: CLgIHSt-OoiRLYMgz1gbWw_1790173898
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-48704504d61so299217f8f.3
        for <kvmarm@lists.linux.dev>; Wed, 23 Sep 2026 07:31:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790173898; x=1790778698;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oxDyo6wS9tLNRj9z6xsNaM4tf77SpHmeasoP+i9z6qY=;
        b=snhwMQCI48RRVpVonpiDEHCny6G3MgfsjxbEJfiX4SJQ4ShF2Ydh/gKH1nKaWSyKeI
         E9/EzMu/0zpSr7ri0WP3BN1k/nJNTqO8+xTV7PvnSxl5pGEXCIuyT5GKENBzN34AsfIp
         dipkF4wW1g9kICw8Y2O8PzcGoTb02BiWfTFA5GDAWOO9iB9O3mamHCrUpZAOe+Caxsac
         EFmYEwRtgx6n6Dbs7Q2MdNzLPnjpHfcflhijqGj46WpD8G4IR4NvHYc0JAuK/9WGs4LE
         1851PGlftfR254CTw0Twj2f0fzV62Gvf/XQbYG/zyEIw4TYgTis11o8zGczqgiJxCzFJ
         3d+w==
X-Forwarded-Encrypted: i=1; AKwUvByTFGV9nr289gP+ecR4kl+63km+Kf+SfDu2KMStnRvS4eFI1fXSppFemYFFnqSfi0fG1Xe2mGs=@lists.linux.dev
X-Gm-Message-State: AFuF++ndMe6na+GFp2If8JH1nBEGTJEj49OSTXYAIKZhje13GcEMw2Rt
	ngF7WGWYmaU599/NvP99ilJ3+talgitgWFpY1Mtn+CSzmQqv/sX32P/h6eWNGsEG4dOeSmkDgiP
	gz/mhIGu73rM0OYO81broZymmOAPPHQDCFys1qPzOvR559uFZyVJxTLUqZg==
X-Gm-Gg: AYBFou0R12WooiVdo/XmE8X4U/P0gncXqpj7lZoAAxGZ8w2MMMrnl1CMaLAdXqDHOZU
	xAWhcmtSFw8I8+XHGx4LHYh+gEDOv/+HZ4RFf7xqA1Y8gV7r/mkDkedtmJTZx+vCCJ2SzkxLqCd
	i/vVMEWI/i+06rUNnNxDP2Erqkft7Fw+UYtgrkXg6g1ZODXrK/zjKvUcfLkrWQoGuU3CTYc5rIz
	LUvgSi+vo8LJlgHIuF1a1sToSsqBUVLvRZ9C9+ZPnCjvf9e2RcpHIjfWXaO4Dlm23y6uZjq2pFe
	QB804MWiFZ22rDiG/2kHS9UjBTKCEQpc22/u/U0MWF9+JXX8OOYK8KWxM3g/BCUR8bVRzqg8ATG
	t0elk1+5jKq/tSoNsaSfaT+bH3QhAP7wLTHVi0+isFpo13qhdpQ5WqD/z3wk=
X-Received: by 2002:a5d:5f88:0:b0:485:8a46:b3cc with SMTP id ffacd0b85a97d-488670c51fcmr4871180f8f.52.1790173898241;
        Wed, 23 Sep 2026 07:31:38 -0700 (PDT)
X-Received: by 2002:a5d:5f88:0:b0:485:8a46:b3cc with SMTP id ffacd0b85a97d-488670c51fcmr4871097f8f.52.1790173897738;
        Wed, 23 Sep 2026 07:31:37 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-488682673bdsm7322098f8f.2.2026.09.23.07.31.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Sep 2026 07:31:37 -0700 (PDT)
Message-ID: <1ccea6d2-418c-481a-85ff-072d3dd837b3@redhat.com>
Date: Wed, 23 Sep 2026 16:31:35 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v9 03/26] target/arm/cpu-sysregs.h.inc: Update with
 automatic generation
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
 "philmd@oss.qualcomm.com" <philmd@oss.qualcomm.com>,
 "maz@kernel.org" <maz@kernel.org>,
 "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "armbru@redhat.com" <armbru@redhat.com>,
 "berrange@redhat.com" <berrange@redhat.com>,
 "abologna@redhat.com" <abologna@redhat.com>,
 "jdenemar@redhat.com" <jdenemar@redhat.com>
References: <20260916144721.751810-1-eric.auger@redhat.com>
 <20260916144721.751810-4-eric.auger@redhat.com>
 <ECC98331-BFD5-4630-ADBC-FEDA0B32F889@nutanix.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <ECC98331-BFD5-4630-ADBC-FEDA0B32F889@nutanix.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: QZQ5THLd6e-X_jhTs1twU5oL4h0uuw779zAV0uWo3tE_1790173898
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 9/23/26 11:13 AM, Khushit Shah wrote:
>
>> On 16 Sep 2026, at 8:15 PM, Eric Auger <eric.auger@redhat.com> wrote:
>>
>> !-------------------------------------------------------------------|
>>  CAUTION: External Email
>>
>> |-------------------------------------------------------------------!
>>
>> Generated definitions with scripts/update-aarch64-cpu-sysregs-header.py
>> based on "AARCHMRS containing the JSON files for Arm A-profile
>> architecture (2026-03)" Registers.json file.
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
>> Reviewed-by: Shameer Kolothum <skolothumtho@nvidia.com>
>> ---
>> target/arm/cpu-sysregs.h.inc | 11 +++++++++++
>> 1 file changed, 11 insertions(+)
>>
>> diff --git a/target/arm/cpu-sysregs.h.inc b/target/arm/cpu-sysregs.h.inc
>> index ec5a12b0f4..8b77c490d4 100644
>> --- a/target/arm/cpu-sysregs.h.inc
>> +++ b/target/arm/cpu-sysregs.h.inc
>> @@ -1,11 +1,18 @@
>> /* SPDX-License-Identifier: GPL-2.0-or-later */
>> +
>> +/* This file is autogenerated by scripts/update-aarch64-cpu-sysregs-header.py */
>> +/* DEF(<name>, <op0>, <op1>, <crn>, <crm>, <op2>) */
>> +
>> +DEF(AIDR_EL1, 3, 1, 0, 0, 7)
>> DEF(CLIDR_EL1, 3, 1, 0, 0, 1)
>> DEF(CTR_EL0, 3, 3, 0, 0, 1)
>> DEF(DCZID_EL0, 3, 3, 0, 0, 7)
>> +DEF(GMID_EL1, 3, 1, 0, 0, 4)
>> DEF(ID_AA64AFR0_EL1, 3, 0, 0, 5, 4)
>> DEF(ID_AA64AFR1_EL1, 3, 0, 0, 5, 5)
>> DEF(ID_AA64DFR0_EL1, 3, 0, 0, 5, 0)
>> DEF(ID_AA64DFR1_EL1, 3, 0, 0, 5, 1)
>> +DEF(ID_AA64DFR2_EL1, 3, 0, 0, 5, 2)
>> DEF(ID_AA64FPFR0_EL1, 3, 0, 0, 4, 7)
>> DEF(ID_AA64ISAR0_EL1, 3, 0, 0, 6, 0)
>> DEF(ID_AA64ISAR1_EL1, 3, 0, 0, 6, 1)
>> @@ -40,6 +47,10 @@ DEF(ID_MMFR5_EL1, 3, 0, 0, 3, 6)
>> DEF(ID_PFR0_EL1, 3, 0, 0, 1, 0)
>> DEF(ID_PFR1_EL1, 3, 0, 0, 1, 1)
>> DEF(ID_PFR2_EL1, 3, 0, 0, 3, 4)
>> +DEF(MIDR_EL1, 3, 0, 0, 0, 0)
>> +DEF(MPIDR_EL1, 3, 0, 0, 0, 5)
>> DEF(MVFR0_EL1, 3, 0, 0, 3, 0)
>> DEF(MVFR1_EL1, 3, 0, 0, 3, 1)
>> DEF(MVFR2_EL1, 3, 0, 0, 3, 2)
>> +DEF(REVIDR_EL1, 3, 0, 0, 0, 6)
>> +DEF(SMIDR_EL1, 3, 1, 0, 0, 6)
> After this, we should probably refactor cpu->midr/revidr/mp_affinity into the idregs[]?

Hum yes. We can now rely on MIDR, REVIDR and MPIDR storage in
isar.idregs[]. I will handle that in v10

Thanks

Eric
>
> Warm Regards,
> Khushit
>> -- 
>> 2.53.0
>>

