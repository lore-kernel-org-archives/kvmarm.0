Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2391E426D03
	for <kvmarm@lists.linux.dev>; Mon, 14 Sep 2026 10:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789380006; cv=none; b=VJkXuZ/R3EWLnRxKZ+T9CL8emYCcD1C9Bi8umpn/oYDztBvDmnskAVBSIjD9Eyi6esTscknvH5L2sA49bNPEKSbbsB2G7j5WdQXpfd2wrYJccLLN+9SAWhF/JJN5yefM807ez2ke5hvfqtUmwbVI4ieYkhvbud+y7LfRUGeRT8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789380006; c=relaxed/simple;
	bh=b4naa9WlCWXdDgBBJw3o2FWfn8Zxu+C00MCs2fJh1Ho=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kc3ZgYOVb8TZWF3d6Wu7svhJddE1AA7nIkmJdWV9oA5fojQU9z0VCfwSZ/MWGBsS+4Sc8oNgD1gEnQdu2anYb6cL9s/lksj1iMy0mM7b1eJceaQJUlG91k+lGeWJWQ2qglVvVbxjGtq6RqW7FtqKBVnsUJr/fBNStoF28GZdrGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IgDi+nsr; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IgDi+nsr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789380002;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ypy8vva409xUcIhg7UrFn+M558mkrKtyBpJ0I/QZb8I=;
	b=IgDi+nsro5gqN75OGxeZQBAOFA8orYZow48BaAtNyw2N4CnKh3yXnABmCoHwqHEYSiJzsZ
	+BJEMEZUTbiBy+rUiCpqCWImAencO+AtfwiSE3ZozhELEOR0pA07Eb1PsGaMSNv3hWnY8X
	8vDu3tDw1os6oFLWwmPx+/PwMG2PSRo=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-331-3tihqaBpNnypCHnHFf1m8w-1; Mon, 14 Sep 2026 05:59:59 -0400
X-MC-Unique: 3tihqaBpNnypCHnHFf1m8w-1
X-Mimecast-MFC-AGG-ID: 3tihqaBpNnypCHnHFf1m8w_1789379998
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-39de4e72b33so1323215a91.2
        for <kvmarm@lists.linux.dev>; Mon, 14 Sep 2026 02:59:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789379998; x=1789984798;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ypy8vva409xUcIhg7UrFn+M558mkrKtyBpJ0I/QZb8I=;
        b=jzXhLaWyqDr6GRgzCbukNJvwZ489gsTH5IHvM7EqscxhykFFlXSkyYDLroiIwoiyps
         6YFS69s9SrtFfsPy6J0Img8dV1iio2dXedLmK07OybFIesd+EjLd4Lv9XO7kTcUJSwhr
         E9heCE0u0Y9Jj79awsoG0r0Uc9HR/rUr2ZVaCmjJyiqBr/cMl88aiM2JnLRC2MNH4T6P
         A/1cYtK9+1P5n+tTIndap5QAr0PvPgDXCZid9Yix1f+/XtFwGu99TWMzdx8Zy44vHmpv
         1y4wOODcq7Hdr/1UWa5tA5cddPPNucr9AC0hmPpI40mC6QgoYdWRMQVmTL/g9aPSWbjT
         mOAQ==
X-Forwarded-Encrypted: i=1; AKwUvBzj7b6iuaWD4sndvbjxLlIMb1/wweVBipVSzVMjenlL8nvLnv91c0WNyi/GzTge3JpE+v4d86w=@lists.linux.dev
X-Gm-Message-State: AFuF++kbq8xZEUWsirXaUA5skHztLGvOvWt5WbAlVGiFyYP/KxBHocYY
	bJrkD8nptMw09fWyBA4XDJ0qQvWpaKant5+PbQuiZGOYOjLLNrJnZdKN37elGKRlT4KboDrUY/d
	Jich5HfzzJ/1Y2i+zecFpW0/A08ofKZG/Xt8nPFptBPrMixQhjxkVJ4LyyQ==
X-Gm-Gg: AYBFou2CfPGKJa9kyZtW8y9xZSGbgxZIbxrUJZqk7VE+nPO13wm0uqs1DJBWC6gOra8
	S3G0YspogEmf0j0EExgtv+tDzR+IGag7u4/VT+o/Vi8JpghHXJdAWSzVHVzPeQW5GCXQZ2vyaDZ
	7t6LtuLXin2NVbTxEcKPOIJme0/6tYlUsUWMZ3IkRZmyDzccsfUbS0SkqjRDb8i84+f07HrE8xt
	PbT6pikNqMvYmgTz1PUHzRqAUqd4/Mq8NKht9UsOufkpUo1ujSd/hp8U2O10wYvsxMg+xYoriYc
	i+7faq873xdUgGchPVlNk3tKbgCigPxS9f3zHI+qgfuMRXQJg7L2MJlYvXlGvyaYEw+TJoCzd1n
	RoqTUe701UIiITURPWp29nwuMuw8SE9THDU7Kak8J+w==
X-Received: by 2002:a17:90b:4a47:b0:39d:eda4:43f2 with SMTP id 98e67ed59e1d1-39deda4487amr3464038a91.7.1789379998051;
        Mon, 14 Sep 2026 02:59:58 -0700 (PDT)
X-Received: by 2002:a17:90b:4a47:b0:39d:eda4:43f2 with SMTP id 98e67ed59e1d1-39deda4487amr3463941a91.7.1789379997512;
        Mon, 14 Sep 2026 02:59:57 -0700 (PDT)
Received: from [192.168.68.52] (n175-34-8-244.mrk21.qld.optusnet.com.au. [175.34.8.244])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33ba4fa50e3sm27206495eec.29.2026.09.14.02.59.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Sep 2026 02:59:56 -0700 (PDT)
Message-ID: <ca30e5e2-2bb5-40ec-8357-d5c3eab8a6f3@redhat.com>
Date: Mon, 14 Sep 2026 19:59:46 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18 4/7] firmware: arm_rmm: Add support for SRO
To: Suzuki K Poulose <suzuki.poulose@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, catalin.marinas@arm.com,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 steven.price@arm.com, aneesh.kumar@kernel.org, oupton@kernel.org,
 joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
 linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
 sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
 WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com
References: <20260912083611.2513845-1-suzuki.poulose@arm.com>
 <20260912083611.2513845-5-suzuki.poulose@arm.com>
 <f00d01d1-8df0-4865-8e52-c85171cf4ca5@redhat.com>
 <4f18aa66-2296-4b63-87f5-6ab493faecbc@arm.com>
 <1fca136f-5802-449a-81f1-3a76c31a2f74@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <1fca136f-5802-449a-81f1-3a76c31a2f74@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: UGzzmB3QqYGI36f7_PMjmy94OqXZ3JS2tJ3bAbuNf6s_1789379998
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 9/14/26 6:19 PM, Suzuki K Poulose wrote:
> On 14/09/2026 07:22, Suzuki K Poulose wrote:
>> On 14/09/2026 06:04, Gavin Shan wrote:
>>> On 9/12/26 6:36 PM, Suzuki K Poulose wrote:
>>>> RMM v2.0 introduces the concept of "Stateful RMI Operations" (SRO). This
>>>> means that an SMC can return with an operation still in progress. The
>>>> host is expected to continue the operation until it reaches a conclusion
>>>> (either success or failure). During this process the RMM can request
>>>> additional memory ('donate') or hand memory back to the host
>>>> ('reclaim'). The host can request an in progress operation is cancelled,
>>>> but still continue the operation until it has completed (otherwise the
>>>> incomplete operation may cause future RMM operations to fail).
>>>>
>>>> The SRO is tracked using a struct rmi_sro_state object which keeps track
>>>> of any memory which has been allocated but not yet consumed by the RMM
>>>> or reclaimed from the RMM. This allows the memory to be reused in a
>>>> future request within the same operation. It will also permit an
>>>> operation to be done in a context where memory allocation may be
>>>> difficult (e.g. atomic context) with the option to abort the operation
>>>> and retry the memory allocation outside of the atomic context. The
>>>> memory stored in the struct rmi_sro_state object can then be reused on
>>>> the subsequent attempt.
>>>>
>>>> Wrappers for SRO RMI commands are also provided here because they depend
>>>> on the rmi_sro_execute() implementation added by this patch.
>>>> Delegate/undelegate handles are also added here because they now use the
>>>> SRO/stateful command infrastructure and are also used for the memory
>>>> DONATE/RECLAIM flows.
>>>>
>>>> Signed-off-by: Steven Price <steven.price@arm.com>
>>>> Co-Developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>>>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>>
>>
>>
>>>> ---
>>>>   drivers/firmware/arm_rmm/rmi.c | 586 +++++++++++++++++++++++++++++++++
>>>>   include/linux/arm-rmi-cmds.h   |  41 +++
>>>>   2 files changed, 627 insertions(+)
>>>>
>>>> diff --git a/drivers/firmware/arm_rmm/rmi.c b/drivers/firmware/ arm_rmm/rmi.c
>>>> index 5b0e342ce3d58..4f9898ece7547 100644
>>>> --- a/drivers/firmware/arm_rmm/rmi.c
>>>> +++ b/drivers/firmware/arm_rmm/rmi.c
>>
>>>
>>> I would drop rmi_granule_range_{delegate, undelegate}() by combining their logics to
>>> their only callers rmi_{delegate, undelegate}_range(). More details are provided for
>>> rmi_{delegate, undelegate}_range() in the below.
>>
>> Ack
> 
> I have moved them closer, but kept the logic separate, since this is not
> a simple RMI call.
> 

Yeah, it's fine by moving rmi_granule_range_{delegate, undelegate}() to their only
callers. However, the unnecessary if statements can be avoided in their only callers
rmi_{delegate, undelegate)_range(). Besides, rmi_delegate_range() would come before
rmi_undelegate_range().

	while (...) {
		ret = rmi_granule_range_undelegate(phys, top, &next);
		if (ret != RMI_SUCCESS)
			break;

		/* Buggy RMM ? Let the caller leak the pages */
		if (next <= phys) {
			ret = -ENXIO;
			break;
		}

		phys = next;
	}

The variable 'out_top' in rmi_{delegate, undelegate)_range() may be renamed to 'next',
indicating it's the next (starting) granule for the RMI calls.

Thanks,
Gavin

