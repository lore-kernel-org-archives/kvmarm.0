Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DE5026ED3D
	for <kvmarm@lists.linux.dev>; Wed,  6 May 2026 02:11:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778033509; cv=none; b=uZqMoG6W/zWKzDu3RrOK5QJlIAjuv8uJb/5Em2NWLgYsshfL2g1H5UOjtw7fFloqEi5CbIzKKoxq4JS7Y3IVa1Ln5OpT9XULof6MEgBptTp5ZebaCRRWpgYQdklNd8TtqgaGAgFKegLxZ/fI6ZY8mlLXWPUsNwGNZGSK1DyjuXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778033509; c=relaxed/simple;
	bh=jr0C3ws9gN/dCpRosmQxsI5jdCjT1h5T1Ng7TbjVcBY=;
	h=From:To:CC:Date:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=ZaAAzTl9/aHZvQ0yiHLQxhySAZvt4KRvxXi4bBDeaqzqcAqKKkb5ygw7H5XYO6mDeElZVYl2BdrOimez/mDCoQKUXErS2V+i3c/3Yu2DAkGLtR3KVBg1jeVHtg7y0EfWSsqtbm9IxVXiqAnoS/4icX+m/1QiIA+s6ahv6RyRDkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=FYyneWe6; arc=none smtp.client-ip=209.85.222.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="FYyneWe6"
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-8c70b5594f4so56466485a.1
        for <kvmarm@lists.linux.dev>; Tue, 05 May 2026 19:11:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1778033506; x=1778638306; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:subject:user-agent
         :references:in-reply-to:message-id:date:cc:to:from:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yrGezS/XNq9+psZQ70L22Z8q+JOJb1NZlusetExcJPM=;
        b=FYyneWe6EzYtXESTChYBmy/Ix45r5n9u8wknQVF1avJ8X3eonx3bFcCXlbEzdMMNFW
         HZWAgDbJa/p/o4r3PUCo2kbRk4h6sTLnHmKNE8P+M3l9QTw9/2ye6X/crzartbhipMeV
         b9oag/QP4FSxNuFMKyhIlJos1eHGcmyi4GvYxpNuaL5tp+OMT14hLvyCbVx4L/VIJJyy
         RFPXjre71z7IzVllAfOurHMfZ/D6h0OBUDWAKliuQqKR9+cwkjXQ9BYFTCMPGSuN8gUL
         1OOJsdV96wysWOAlpV2dsyyDbS8W4b0z3VDMeA62BUSsCe45f3Rmyjsu7fjSmQNHo+Cs
         I5nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778033506; x=1778638306;
        h=content-transfer-encoding:mime-version:subject:user-agent
         :references:in-reply-to:message-id:date:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yrGezS/XNq9+psZQ70L22Z8q+JOJb1NZlusetExcJPM=;
        b=MktQHp/kG47do3iGX3jLSQuys/MIJo0Z8f7lgzpQDf1xgsTYAXRdDx/4pyARrHpqIA
         wr5M68QmYkvcfZU1QoNac1nhCMoLeQ7yKypMyPbj/reZET8kdg3DHcZoQNl1/Dq8lGlj
         TfLX64XfBmitH5O7cuIS3mmClJGXWOMliA1Y9jKZTJH2UFGndO9dXigTw/Tad4E0xeK4
         EnAtuwzC0+bQ/eZZS14HCsZLegg50WBzahJljQUIBVjf9BLcrbfGhH2MX49dAD2l+q75
         FEF+ajKoWXwf/fr7IVWnQH1xSogR0qJQn95sScepI5YehMQPCzAFOco2689c6X/Dtclb
         S6NA==
X-Forwarded-Encrypted: i=1; AFNElJ95/tm4JfvPg43qVT5wwhviGNlDd9txhETo2BPiOpBqXHkaGt+P6VnlhfXLoENZlfs12KB7eQM=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw4lor23NDNEEQAC2lr58uRo5H1XGihDVMvewRtKYQySQLv1Gpm
	IYd05m5N6Lf+HY5rgQwoRHXMpkcATUi00H2D1r0S+Ez+Xe2QQdmkzt/zwjqdlwMKmA==
X-Gm-Gg: AeBDiesRD6gS1rlBPLKvike4K7uG3o+PEwRQ96ii3qvZ4/GMcUs7Zt+BJgO8xpqJ3dK
	MAIAt8EJsGV4koB3Gx7s6MDjbKFuRzxjwoWpJHa4bJS8Fep0TBqLEtscW9CobHdRqn6UWCN5KQX
	fC/L8wCYIdJD4EUy+SeZ/hm9BszJIOzqNQWCNIi8Razf/QRv6l2B127oTxW0UCfPt4Mim8tJY3t
	5gOMfwIgfe5H3DggWGnjeSpETUwZ4z+yxWUmstWcBc5emzqz+4WRUVCR6G6CT97nZOMhZN7Mq7x
	Hed+6HomXgtF6xh8o0R3F8clu7BiBJK6fZmPE2mFRC8xoImwS/qF7n5Va06lT8vgUx5PaUvRWqF
	025nNnT85KCQFqTdDiitqNF8VrmBFe09NtbZDyhq0/TimI6Z84JNw7MrYHNlIjNy0Twk63EuP+W
	eugUFjShZrrIdKS2UZAuS3jBo4KMUU/x38NdGk8BzJlrqvdwp5ElCGtkFA4jcgsbaDkeoXLzXe+
	jzYrWOoF2EA9sUiQDEI6A==
X-Received: by 2002:a05:620a:318e:b0:8ee:fc5e:e2e9 with SMTP id af79cd13be357-902e298aa9cmr923174085a.13.1778033506563;
        Tue, 05 May 2026 19:11:46 -0700 (PDT)
Received: from [192.168.7.16] (pool-71-126-255-178.bstnma.fios.verizon.net. [71.126.255.178])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8fc2c91e11fsm1471690385a.40.2026.05.05.19.11.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 May 2026 19:11:45 -0700 (PDT)
From: Paul Moore <paul@paul-moore.com>
To: Mimi Zohar <zohar@linux.ibm.com>
CC: Yeoreum Yun <yeoreum.yun@arm.com>, Jonathan McDowell <noodles@earth.li>, <linux-security-module@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <linux-integrity@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>, <jmorris@namei.org>, <serge@hallyn.com>, <roberto.sassu@huawei.com>, <dmitry.kasatkin@gmail.com>, <eric.snowberg@oracle.com>, <jarkko@kernel.org>, <jgg@ziepe.ca>, <sudeep.holla@kernel.org>, <maz@kernel.org>, <oupton@kernel.org>, <joey.gouly@arm.com>, <suzuki.poulose@arm.com>, <yuzenghui@huawei.com>, <catalin.marinas@arm.com>, <will@kernel.org>, <noodles@meta.com>, <sebastianene@google.com>
Date: Tue, 05 May 2026 22:11:42 -0400
Message-ID: <19dfb0e2730.2843.85c95baa4474aabc7814e68940a78392@paul-moore.com>
In-Reply-To: <5debff82dc758d9c91223e4f1f5b9e39a3fcd4f5.camel@linux.ibm.com>
References: <cover.1777036497.git.noodles@meta.com>
 <7734099f5e7fda5480bca016a9e6707983325fbd.camel@linux.ibm.com>
 <afMlgstqahnZg68h@e129823.arm.com>
 <9f188536f09a2db30877d6bfbb84aeaf2565cccf.camel@linux.ibm.com>
 <CAHC9VhRsnmPp2KmQAns5uq5qXX5EF2xQQzyfTgrPi4O9AXyPpg@mail.gmail.com>
 <ba4bf28314b679474a6a8da6298e548e54b3754c.camel@linux.ibm.com>
 <CAHC9VhRE2kRr1fdDf6xgQgpSrtvqtP8Vy9LVGJhDZFUbzLKGmQ@mail.gmail.com>
 <ff28c6dcb60c357c752724927addaa8c4fd3bf2c.camel@linux.ibm.com>
 <CAHC9VhQY2TMkTvQq9P8oZteQWQSr7qq2utOuH+pdVx+8jWLBCw@mail.gmail.com>
 <a9412fe10e70ce95dd70556ace19368bec5c188c.camel@linux.ibm.com>
 <CAHC9VhRUgNA=Sj=jhD=zOt8R80Q+FQj+H0nYSy-FAujTL3EKPA@mail.gmail.com>
 <5debff82dc758d9c91223e4f1f5b9e39a3fcd4f5.camel@linux.ibm.com>
User-Agent: AquaMail/1.58.1 (build: 105801620)
Subject: Re: [PATCH] ima: debugging late_initcall_sync measurements
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset="UTF-8"
Content-Transfer-Encoding: 8bit

On May 5, 2026 9:57:23 PM Mimi Zohar <zohar@linux.ibm.com> wrote:
> On Tue, 2026-05-05 at 18:55 -0400, Paul Moore wrote:
>> On Tue, May 5, 2026 at 5:05 PM Mimi Zohar <zohar@linux.ibm.com> wrote:
>>> On Mon, 2026-05-04 at 16:51 -0400, Paul Moore wrote:
>>>> On Mon, May 4, 2026 at 8:03 AM Mimi Zohar <zohar@linux.ibm.com> wrote:
>>>>> On Sun, 2026-05-03 at 12:46 -0400, Paul Moore wrote:
>>>>>> Regardless, assuming you always want IMA to leverage a TPMs when they
>>>>>> exist, your reply suggests that using an initcall based IMA init
>>>>>> scheme, even a late-sync initcall, may not be sufficient because
>>>>>> deferred TPM initialization could happen later, yes?
>>>>>
>>>>> Well yeah.  The TPM could be configured as a module, but that scenario is 
>>>>> not of
>>>>> interest.  That's way too late.  The case being addressed in this patch set is
>>>>> when the TPM driver tries to initialize at device_initcall, returns
>>>>> EPROBE_DEFER, and is retried at deferred_probe_initcall (late_initcall).  Since
>>>>> ordering within an initcall is not supported, this patch attempts to initialize
>>>>> IMA at late_initcall and similarly retries, in this case, at 
>>>>> late_initcall_sync.
>>>>
>>>> Okay, so from a TPM initialization perspective you are satisfied with
>>>> a late-sync IMA initialization, yes?
>>>
>>> No. On some architectures moving IMA initialization from the late_initcall to
>>> late_initcall_sync does not miss any measurement records. However, as 
>>> previously
>>> mentioned, Linux running in a PowerVM LPAR the move would drop ~30 measurement
>>> records[1].  So no, only if the TPM is not initialized by late_initcall, should
>>> IMA retry at late_initcall_sync.
>>
>> What do you do in the PowerVM LPAR when the TPM is not avaiable at
>> late initcall and you have to defer IMA initialization until
>> late-sync?
>
> Your question is hypothetical ...

<heavy eye roll>

> ... as the TPM isn't deferred, so IMA doesn't go into
> TPM-bypass mode.  Testing on a PowerVM LPAR demonstrated that it skips ~30
> measurement list records.  So moving the initcall to late_initcall_sync would
> cause a regression.

Let me rephrase to make the question clear - how do you plan to handle a 
system where you lose measurements by waiting until late-sync, but the TPM 
is not available at the late initcall.

--
paul-moore.com



