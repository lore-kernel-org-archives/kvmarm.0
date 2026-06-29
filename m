Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 975D23EDAAE
	for <kvmarm@lists.linux.dev>; Mon, 29 Jun 2026 12:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782734703; cv=none; b=OV4XTJL26hkLYQJwWbfDO5hp8taw4nAvsThOTlMhO7I+fPfcwi6ummOEnZhXmxFbn/S+0CYmYjBWtm7+R0zz+1Owdldr5iNtQtw66cigiIGQfAtT75OH8TxiLBwuPUWzEVE9rJMdAGza3jTys71ohJBQ7nnJoFcINd6FmRU6gb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782734703; c=relaxed/simple;
	bh=hduq/+QUzvOYvyBjV6zvOD13s4oXxdEzyFDF6XcgV/o=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=DAih6k+pu66C0KzYfZMHMfRPRBTlhVxD+bTv7a0TQk/itVJXBXEJji9xkHwT9OVkNKKqTyCfvrUHJQbgwRMjHkoENOkPooV/qxK3t9p/uwCjlbbLbN6OKgGF1YJwJgBvavVOqryI/agVxyFCJLgyV20iLGeXVTln2Hfppfk0IZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Rsv/fO1Y; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Rsv/fO1Y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1782734700;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yxPybTnAynYrqMa7xM6kuJZ/NYcVq9nFK+M5bYeVejI=;
	b=Rsv/fO1Yzm0t7ZhwY49MrFav1utHnY0bFHdw3UHioR4FqhaMdPd/Oxi0Vf8Q4uRcsY+EQa
	VoqsFNfzX+bcW8B5k8THhCsw4T2ZvPoPGH67TQ+Xa6SSWmut8HLHy+hkFZArBjHBC5y+X/
	j1pmr2857aFQnVRo4LoeJXMZZyL8FlU=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-684-R2wFPN08ONylTjAm-ZgqDg-1; Mon, 29 Jun 2026 08:04:59 -0400
X-MC-Unique: R2wFPN08ONylTjAm-ZgqDg-1
X-Mimecast-MFC-AGG-ID: R2wFPN08ONylTjAm-ZgqDg_1782734698
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-49271013dcdso19316345e9.0
        for <kvmarm@lists.linux.dev>; Mon, 29 Jun 2026 05:04:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782734698; x=1783339498;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yxPybTnAynYrqMa7xM6kuJZ/NYcVq9nFK+M5bYeVejI=;
        b=Erb3uappO2fFFvaybvm5eUuS59ZrKo4tCa+d/MiEx+5lsMB9ebGPRlW5/mF3WAWDDk
         +EglsKiJ9wIFgMgDxpsMPHg4ncvb8qS+17clK5BrvYXVcBIUlEIrkxnbsj6Q0m0Cswo5
         /Bv2QlsA8dIgf52kA0Pt4FcwlKGSMXFqfpxbupRFecyFSOD2DW/JzvBVGhSkQvqmju4I
         pkHe5EBlU2xz0leOa678r7rRpAOP82Fgiv5LCEzUrNwe3B5MrVSQ998lzg83qRvYyY2z
         xgZ/uwZz2kCzAS+TVm75wXk2sVJGm2Fm/xQbqsgPScfc+eOLwdBqyp+20jlSw1gjBxCh
         lKbg==
X-Forwarded-Encrypted: i=1; AFNElJ9c1D5dw+xIDlIygexHvzon2OmW5e7KpdWcWVeNFbLieDBswkAF2biyieC4J9fIOPkNjO13XDI=@lists.linux.dev
X-Gm-Message-State: AOJu0YzA/1DPbthsdMtRe3QPZlr+Ol7SRx+3PIyx4py+IJZU9otU5Pha
	zDJMIldHG03XmtfjmzbocHBwZNfLL6AZW0mH0lTcVHsYXV1oG3EOhBNQnBSyPKiW7IiHF8k0A5w
	/tz9a22rE3rwfHuV/Lk2b77RZXY1cqyTDAnT46nudJX3HwaPAt4c4f0bT6Q==
X-Gm-Gg: AfdE7ckghpbOA60VERb/5Qfid7UPDNWWBXRFh3oG8Gfw6VvFpu3/4qaSfDbbILJiF+t
	uIE0EwEHtanOdvOlRpMstC+/hNoNSUYjO1Q75g2tSK7IbI35av0Ec9/UAce6WfpHLLCNeDDuFVO
	X744c6JxfwlqFPGtElE5gV9VdPUqpFHG1H0Dp94N24LEuwgeGARQHkBthhXXvNXIZdTyX8EX0PM
	HRF7FBmR1K7J1uHx7xN7MWbCVEGzK9cApFzztIg9scHAOIwL66n0FEn/0MQ+yzZOrLEfyOX+Fin
	7J4KdeGpkYX6nxY/MbCtL2UF+oGoKf+LjjnqzFjJLBeMRhovrTG8jimlTHKAVHXo2bwluSKn0nN
	qgo5He1MwhJ0awjrcGWUvSF2ROTsbhjbcz8qkaw6LDsLZsW7YUAEDPwMzG4se
X-Received: by 2002:a05:600c:6096:b0:490:d32b:39c3 with SMTP id 5b1f17b1804b1-493b719262emr8675195e9.6.1782734697940;
        Mon, 29 Jun 2026 05:04:57 -0700 (PDT)
X-Received: by 2002:a05:600c:6096:b0:490:d32b:39c3 with SMTP id 5b1f17b1804b1-493b719262emr8674565e9.6.1782734697481;
        Mon, 29 Jun 2026 05:04:57 -0700 (PDT)
Received: from rh (p200300f6af2a6100f239e076bbd76784.dip0.t-ipconnect.de. [2003:f6:af2a:6100:f239:e076:bbd7:6784])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-46f8d6f10absm43526066f8f.5.2026.06.29.05.04.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2026 05:04:56 -0700 (PDT)
Date: Mon, 29 Jun 2026 14:04:55 +0200 (CEST)
From: Sebastian Ott <sebott@redhat.com>
To: Zenghui Yu <zenghui.yu@linux.dev>
cc: Jiakai Xu <xujiakai2025@iscas.ac.cn>, Shuah Khan <shuah@kernel.org>, 
    Andrew Jones <andrew.jones@oss.qualcomm.com>, 
    Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org, 
    linux-kselftest@vger.kernel.org, kvmarm@lists.linux.dev, 
    Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
    Oliver Upton <oupton@kernel.org>
Subject: Re: [PATCH] KVM: selftests: fix steal_time for arm64 with host page
 size > 4K
In-Reply-To: <a6ccc7a8-488b-4454-81b1-f29dd875845c@linux.dev>
Message-ID: <073cfbe1-0a27-015b-c688-53c186100fa1@redhat.com>
References: <20260504112808.21276-1-sebott@redhat.com> <7575a845-a542-4b16-b512-aec3126f97f3@linux.dev> <335f21e5-493d-012d-b07c-2e48cc2b9aeb@redhat.com> <a6ccc7a8-488b-4454-81b1-f29dd875845c@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: RTAsNIk2B_F7M3I6SxuiHYFeyDA9tycDAqgwd3osIaI_1782734698
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII; format=flowed

On Sun, 28 Jun 2026, Zenghui Yu wrote:

> On 6/22/26 10:14 PM, Sebastian Ott wrote:
>>
>> Fix the following failure when running with 16K host page size:
>> ==== Test Assertion Failure ====
>>   lib/kvm_util.c:991: vm_adjust_num_guest_pages(vm->mode, npages) == npages
>>   pid=873 tid=873 errno=0 - Success
>>      1  0x0000000000405a27: vm_mem_add at kvm_util.c:991
>>      2  0x000000000040241f: check_steal_time_uapi at steal_time.c:223 (discriminator 7)
>>      3   (inlined by) main at steal_time.c:539 (discriminator 7)
>>      4  0x00007fff8b57af3b: ?? ??:0
>>      5  0x00007fff8b57b007: ?? ??:0
>>      6  0x0000000000402b6f: _start at ??:?
>>   Number of guest pages is not compatible with the host. Try npages=4
>>
>> Fixes: fc240715fc50 ("KVM: selftests: arm64: Fix steal_time test after UAPI refactoring")
>> Reported-by: Zenghui Yu <zenghui.yu@linux.dev>
>> Link: https://lore.kernel.org/kvmarm/7575a845-a542-4b16-b512-aec3126f97f3@linux.dev/T/#u
>> Signed-off-by: Sebastian Ott <sebott@redhat.com>
>> ---
>>  tools/testing/selftests/kvm/steal_time.c | 6 ++++--
>>  1 file changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/tools/testing/selftests/kvm/steal_time.c b/tools/testing/selftests/kvm/steal_time.c
>> index 76fcdd1fd3cb..cdb81f3ee4b2 100644
>> --- a/tools/testing/selftests/kvm/steal_time.c
>> +++ b/tools/testing/selftests/kvm/steal_time.c
>> @@ -208,6 +208,7 @@ static void check_steal_time_uapi(void)
>>  {
>>      struct kvm_vm *vm;
>>      struct kvm_vcpu *vcpu;
>> +    unsigned int gpages;
>>      u64 st_ipa;
>>      int ret;
>>
>> @@ -220,8 +221,9 @@ static void check_steal_time_uapi(void)
>>      };
>>
>>      vcpu_ioctl(vcpu, KVM_HAS_DEVICE_ATTR, &dev);
>> -    vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, ST_GPA_BASE, 1, 1, 0);
>> -    virt_map(vm, ST_GPA_BASE, ST_GPA_BASE, 1);
>> +    gpages = vm_calc_num_guest_pages(VM_MODE_DEFAULT, 1);
>
> Would vm_calc_num_guest_pages(VM_MODE_DEFAULT, STEAL_TIME_SIZE) be better
> to describe the number of pages we want to add?

Hm, I don't think we care. This is just for the uapi checker - the vm/vcpu
doesn't even run..

Thanks,
Sebastian

