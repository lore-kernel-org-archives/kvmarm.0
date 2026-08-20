Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF5F235E1CC
	for <kvmarm@lists.linux.dev>; Thu, 20 Aug 2026 16:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787241669; cv=none; b=U7rBSDoNnRhfeRrRungZa1/quiJC/UfzwZVninZJUV83aMRXvm6wCwvT9NCG7kjXO7Uv8QZJqfhx4iIDCke45uM9ijvH6IJY11Ym2E7opfm9yIz7L8P8TOL8bk1SyUiXIITUlpbUA7AH6nx7wFqnWeBtOnz76xb4Yk8hR8KaVFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787241669; c=relaxed/simple;
	bh=AvY50aSMtMWJ4p+XuiL7FTmaQsPKV0PzBamyis2Ut7k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fLARWRx3bwhADEz3dHCpP4A3iuHYJSdWA+MIGSM3075xufRNy44birOkiSX4w1y2YC65G375rOmbsF01Iy17ZZMWY+Gj0DsS5MPaTkn5F1PUJJyDSavOwvdu3Qw22425C7sRSsrVoH6Zh52FLl5VCW4XQyiA4dmBl+SqLdS8WBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MW1dBImf; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MW1dBImf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787241666;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bfcVWwh/y440qFMJt0bsGIXtJnzC4KlT0imLo1y60K4=;
	b=MW1dBImfNw58ao6IbSXQ8Nc8M6cq8SpmDiZg+X82UnPdyeFg8yYBFubhjGxPLyBGbCAzV6
	6IibQxFpuydZ0a2zFAYw8vYUv8QWtQpFOnmvKHd6LElI2UiVPloILHQUp12UcDyNyi5PkJ
	r0DiM5nthzKrDLT0w1fDRYnCS5c+lJI=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-271-LHuxx2WJPUufvJ_tI-scKg-1; Thu, 20 Aug 2026 12:00:59 -0400
X-MC-Unique: LHuxx2WJPUufvJ_tI-scKg-1
X-Mimecast-MFC-AGG-ID: LHuxx2WJPUufvJ_tI-scKg_1787241658
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-47f8f8fde2dso57211f8f.0
        for <kvmarm@lists.linux.dev>; Thu, 20 Aug 2026 09:00:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787241658; x=1787846458;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bfcVWwh/y440qFMJt0bsGIXtJnzC4KlT0imLo1y60K4=;
        b=Io63y+4S7pIrzBo1qov+xB3YRHO2n0jE88ICY8XcpfonJ+xOvDgR7VnMRhNnR2gD2k
         /IyNJtkInZwWWJZ20j7nzRvkmgxzufZEUhqgWQrpeuNw4uqZqIdoyceN018fHzn7q6eH
         sn5Vq2mXyTvyEnH6Oe7fazErkDV9CmokW0FtttNA3C3IoOtUDGJ8QfsV+Uvrf9uad/55
         VYgHj4txdB4//0hZLmWprTawEezGSsqQjYzvG2m2QGjv3rRiJiFsSCbxLMTVFH5d/Tjf
         zAKioBnmAvCCCgjW//hsrVOkwajTP2lGM7rTA+82JsJ4F1fTS/HcNvjOd79DBSLz689D
         uXjA==
X-Forwarded-Encrypted: i=1; AHgh+RqMf0vg97Lb86ah1CL7Equcr0gz8sibWleSzHnPgIYnYfRlTgTWfg9Cmz/gRxn38XHWeY9N9qc=@lists.linux.dev
X-Gm-Message-State: AOJu0YxclEyXos/AfGNq8X44geQhi3cT29+qDIQkFjTFgc7q/94e8xmC
	vNL4pwNVxvMkAbuPC+rBtBuPijOELcHWIFBpKPpUjIRzKNTJCo6xF3qEvpbN9JvTll8hTHDiW7g
	6FQ3aOiBRYka6iMbQ3LC3+9HVlKOgyfC/E2ZmeFK9xQRE24hqr/wqi5tRWg==
X-Gm-Gg: AR+sD1168wn+Srx/Cy1M0cEGZHE4LZgL7PrJoMh+K5uxUaWdbDXlBldfZ+YSJRtrNCK
	IML9os+QCqQMQ/rzloaprsAulnw76hSaixq5QrU+KzfvDjC1G2FCx+buZ3XvFnYVvDPPkPshXlm
	5TjipkTbqygVVJUMKtxhJebWe5hiiERTSVYPrKFn7GCsDCGiksmVJ6u1YoaYrGJu2eRYpB547pU
	sas9bBUMVPgfwDi+7aNO/ihK6x3NOyUXq5o9KcjLbWBCEzImW+YmrePX4e9PzwKVZ3sddkr6NQ6
	nLbQLmirjaExzd3gxqPTktJO6yq8dNk49oe1cDj4XWqI+weBWGUCQSNbVvu9gftP/x8hNGwoXKz
	8f7Rm6Zq5QZKQ7Xpb5j8AIxz9MpPIXIq/LkdGMAhfPq+SZJub
X-Received: by 2002:a05:600c:8b62:b0:499:a6ae:20a1 with SMTP id 5b1f17b1804b1-499aa1dc5b6mr266871865e9.14.1787241657665;
        Thu, 20 Aug 2026 09:00:57 -0700 (PDT)
X-Received: by 2002:a05:600c:8b62:b0:499:a6ae:20a1 with SMTP id 5b1f17b1804b1-499aa1dc5b6mr266870255e9.14.1787241657090;
        Thu, 20 Aug 2026 09:00:57 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-499aa0fda98sm231359415e9.1.2026.08.20.09.00.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Aug 2026 09:00:56 -0700 (PDT)
Message-ID: <4d45766a-f0f5-4e59-b1ca-cf8d5b039a80@redhat.com>
Date: Thu, 20 Aug 2026 18:00:54 +0200
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
 <87y0f5u78t.fsf@pond.sub.org>
 <6AA3BD42-9596-476B-9F64-AB09372821B9@nutanix.com>
 <87tspa5skn.fsf@pond.sub.org>
 <FD805FA0-9323-450C-9D79-319C0883F05E@nutanix.com>
 <FDD5760F-94E6-46F4-AC62-AB0DC98322FD@nutanix.com>
 <8733wu5qfs.fsf@pond.sub.org>
 <08DA9B28-D5BD-4EC3-8182-FEE212F0C2A0@nutanix.com>
 <871pcd12bf.fsf@pond.sub.org>
 <5F6481F1-B5E1-4B30-A4D1-481D9C0731AC@nutanix.com>
 <87o6fgzopu.fsf@pond.sub.org>
 <7B2898F0-DA7A-4DFD-A2CB-997833A47A05@nutanix.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <7B2898F0-DA7A-4DFD-A2CB-997833A47A05@nutanix.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: hhSLuvFANu252nevT8CMWLgBAO2WT8XrQQJfWhADUaU_1787241658
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 8/6/26 11:24 AM, Khushit Shah wrote:
>
>> On 5 Aug 2026, at 6:52 PM, Markus Armbruster <armbru@redhat.com> wrote:
>>
>> !-------------------------------------------------------------------|
>>  CAUTION: External Email
>>
>> |-------------------------------------------------------------------!
>>
>> Khushit Shah <khushit.shah@nutanix.com> writes:
>>
>>>> On 5 Aug 2026, at 12:28 PM, Markus Armbruster <armbru@redhat.com> wrote:
>>>>
>>>> !-------------------------------------------------------------------|
>>>> CAUTION: External Email
>>>>
>>>> |-------------------------------------------------------------------!
>>>>
>>>> Khushit Shah <khushit.shah@nutanix.com> writes:
>>>>
>>>>>> On 4 Aug 2026, at 12:21 PM, Markus Armbruster <armbru@redhat.com> wrote:
>>>>>>
>>>>>> !-------------------------------------------------------------------|
>>>>>> CAUTION: External Email
>>>>>>
>>>>>> |-------------------------------------------------------------------!
>>>>>>
>>>>>> Khushit Shah <khushit.shah@nutanix.com> writes:
>>>>>>
>>>>>> [...]
>>>>>>
>>>>>>> Stub file was missing on arm user builds. 
>>>>>>>
>>>>>>> I have fixed this on the private branch if you want to take a look.
>>>>>> I'm willing to pull an update to v3, assuming it's a small fix.
>>>>> It is a small fix :)
>>>> Please tell me what to pull.  When you're ready, of course.
>>> It’s on the same private branch: https://urldefense.proofpoint.com/v2/url?u=https-3A__github.com_khushit-2Dshah-2Dnx_qemu_tree_upstream-2Drfc-2Dv3-2Dfixups&d=DwIFaQ&c=s883GpUCOChKOHiocYtGcg&r=PGWMyignA0NiDmTlyP7vOTHozBws_VN86yrVmSMkBp0&m=lv46ybodStjAtdapjMwLnohED9-uQST3KdkvwYej9yhiKYNrRdzDyHjeuYqUxdyg&s=7IbcSv1pGL29PTHAOxj2lZWr2tySQeQqB88qHxlTpvE&e=
>> Builds, but fails "make check" on my box *sigh*.
>>
>> tests/qtest/qmp-cmd-test.c needs an update.
> :’)
>
> Fixed it, available on: 
> https://github.com/khushit-shah-nx/qemu/tree/upstream-rfc-v3-fixups
>
> On my machine, qemu:qtest+qtest-aarch64 / qtest-aarch64/device-introspect-test
> still fails. (It will likely not fail for you if you are on (arm + kvm or any
> other Arch))
>
> I have reported this to Eric as the fail stems from the base "customizable host
> model” series.

yes my bad, this will be fixed in v8

Eric
>
> Sorry for the hiccups, and thanks for your patience, will take care from now on.
>
>
>

