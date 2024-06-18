Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D82122626
	for <kvmarm@lists.linux.dev>; Tue, 18 Jun 2024 17:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718731099; cv=none; b=TTTwgYzIkdgX0JQk96BIyV3gAohIJa37gpv+BN75ZQEa2WftNC/RBSvegVh2tMZR3udWRMuUD7DZ/FT8yhNzooyL9wl3VE86OVqz4ywlixFoZf+p8adfGtqpmbkEmeLCv7rp/StwPn4+oP5qj30J5nvpQjqqBkuMPIluYwY17KQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718731099; c=relaxed/simple;
	bh=E88BmaAsDqYTdfzwzSxjDe2vL9VlXR7afjBpCMNDWnk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=o4hX9k/EAXSNLsbfbIzEoMrlJ56kBOY4N6XMx0hNViirmIQh96ZOxv4hFVT1tuvu/rqK2/VFW1c62rAuMOMHK6UoTX9eBptcuGnDgbSPukLhyyJcsZ+GxPseZeAO9B3iES5Q0Pe75/HXIcxONagrgW4kapHUM3QEkNp4F3Fb62I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=N7L8x5fb; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="N7L8x5fb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718731096;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OfA3LwMbE/DUvF/p13i3FzTY1dQr+PSeG8moXb5mK1s=;
	b=N7L8x5fbAVOoDnc2xmXqk8fMtcmQA7GSCwgx/ZlOFi+RubzPlbxX3qEmBMrzi3be0dUu24
	BDmAtYuyrc+LGQuV60tLH/IEtUjj1axKcP81r5pJuSA39naeSA0glACZbmr4ZnMoEUeR7g
	tbDUpBVCwVuvPT8616wJXHNUCfp6tpA=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-528-3ALzVm5YNHq6pY3v5Nhwkw-1; Tue, 18 Jun 2024 13:18:14 -0400
X-MC-Unique: 3ALzVm5YNHq6pY3v5Nhwkw-1
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-6b06812d93bso71510506d6.3
        for <kvmarm@lists.linux.dev>; Tue, 18 Jun 2024 10:18:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718731094; x=1719335894;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OfA3LwMbE/DUvF/p13i3FzTY1dQr+PSeG8moXb5mK1s=;
        b=QFZcEbhgAMLA05jtqAJFnJiO+EsC8GFJHxmxj00OSj2lTmZPr14m+AkDS7HUknk73s
         FGpl5nu+jZswqIOdcIjLZ6JCSARQ5g4GpzQKyinm2nCeGRR2O4IUwPM+tZE0BgFqIY34
         6FX71sLMc9bmzMXyfCyiixmxKZ6LtSAR9k8xkbikDZOx+z6D1CvwADrbeiUuNoZxI1Wf
         zvfMvhzOU55wjNTQF0sNf47Bw4OchBT/YZlW+gqU2whBEbzytSrM6Ratn43IeURo1Oex
         kLLDyFKn5o3T6sJedEdPM4ZykEkWyZ7KwdohoN5bmCULQhRFNhUD5U/G94jKsg67rbNm
         iwcg==
X-Forwarded-Encrypted: i=1; AJvYcCVKIDMHufkpbwTwlr2IM43sSzfpnMawpO4VmmCvWi6yHoYfdUgveOu8Sf1sLdGgi/VqmhAlwy3Mmg3wnMxuJqcHvBASYs4t
X-Gm-Message-State: AOJu0YybuoqnAAf0dl6Q+q6ey/049v3INTnXyOHG43Z7F8wYRrIADHQe
	MYIZrAHlEu7s67r0iyibu8sVUKIkpeSFixRzYaZsSX0H5yOEb+CGKFPi7/afynZKgk189KoM8hw
	1vl71hC4eDcyhoXct1RXZBqObLZ/pKCZ+xhLJYbApqe/ukITcWZ0l0g==
X-Received: by 2002:ad4:5508:0:b0:6b2:9e65:2246 with SMTP id 6a1803df08f44-6b501e0a68emr4186136d6.1.1718731094105;
        Tue, 18 Jun 2024 10:18:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGnOWYZtT+CrBMBJyfraQd9XFFGxxruwbtn92rRH2IHusIXYoHSyCpTlIommLhnHzvRVdf/nA==
X-Received: by 2002:ad4:5508:0:b0:6b2:9e65:2246 with SMTP id 6a1803df08f44-6b501e0a68emr4185246d6.1.1718731092764;
        Tue, 18 Jun 2024 10:18:12 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6b2a5c18209sm68915006d6.42.2024.06.18.10.18.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Jun 2024 10:18:12 -0700 (PDT)
Message-ID: <8f9d74fc-f9d9-43ac-a387-91ff804cfaf1@redhat.com>
Date: Tue, 18 Jun 2024 19:18:08 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: arm64: vgic-its: clear dte when mapd unmaps a device
To: Marc Zyngier <maz@kernel.org>, Kunkun Jiang <jiangkunkun@huawei.com>
Cc: Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, Randy Dunlap <rdunlap@infradead.org>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 wanghaibin.wang@huawei.com, lishusen2@huawei.com
References: <20240613093811.710-1-jiangkunkun@huawei.com>
 <86v82ckimh.wl-maz@kernel.org>
From: Eric Auger <eauger@redhat.com>
In-Reply-To: <86v82ckimh.wl-maz@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

On 6/13/24 16:44, Marc Zyngier wrote:
> On Thu, 13 Jun 2024 10:38:11 +0100,
> Kunkun Jiang <jiangkunkun@huawei.com> wrote:
>>
>> vgic_its_save_device_tables will traverse its->device_list to
>> save dte for each device. vgic_its_restore_device_tables will
>> traverse each entry of device table and check if it is valid.
>> Restore if valid.
>>
>> But when mapd unmaps a devices, we do not invalidate the
>> corresponding dte. In the scenario of continuous save
>> and restore, there may be a situation where a device's dte
>> is not saved but is restored. This is unreasonable and may
>> cause restore to fail. This patch clears the corresponding
>> dte when mapd unmaps a device.
>>
>> Singed-off-by: Shusen Li <lishusen2@huawei.com>
> 
>   ^^^^^^^^^^^^^ This isn't a valid tag!
> 
>> Signed-off-by: Kunkun Jiang <jiangkunkun@huawei.com>
> 
> Something is wrong. Either Shusen Li is the author and you are merely
> posting it, in which case there should be a 'From' line in the commit
> message, or you are co-authors and there should be a 'Co-developed-by'
> right after Shusen Li's SoB.
> 
> Please read Documentation/process/submitting-patches.rst for the
> details.
> 
>> ---
>>  arch/arm64/kvm/vgic/vgic-its.c | 13 +++++++++++--
>>  1 file changed, 11 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
>> index 40bb43f20bf3..dd5fba1e8ba3 100644
>> --- a/arch/arm64/kvm/vgic/vgic-its.c
>> +++ b/arch/arm64/kvm/vgic/vgic-its.c
>> @@ -1140,8 +1140,12 @@ static int vgic_its_cmd_handle_mapd(struct kvm *kvm, struct vgic_its *its,
>>  	u8 num_eventid_bits = its_cmd_get_size(its_cmd);
>>  	gpa_t itt_addr = its_cmd_get_ittaddr(its_cmd);
>>  	struct its_device *device;
>> +	gpa_t gpa;
>> +	const struct vgic_its_abi *abi;
>> +	int dte_esz;
>> +	u64 val;
> 
> Aside from 'gpa', all the extra variables should be moved into the
> !valid block. And it would be nicer if this variable was called
> something more descriptive.
> 
>>  
>> -	if (!vgic_its_check_id(its, its->baser_device_table, device_id, NULL))
>> +	if (!vgic_its_check_id(its, its->baser_device_table, device_id, &gpa))
>>  		return E_ITS_MAPD_DEVICE_OOR;
>>  
>>  	if (valid && num_eventid_bits > VITS_TYPER_IDBITS)
>> @@ -1161,8 +1165,13 @@ static int vgic_its_cmd_handle_mapd(struct kvm *kvm, struct vgic_its *its,
>>  	 * The spec does not say whether unmapping a not-mapped device
>>  	 * is an error, so we are done in any case.
>>  	 */
>> -	if (!valid)
>> +	if (!valid) {
>> +		abi = vgic_its_get_abi(its);
>> +		dte_esz = abi->dte_esz;
>> +		val = cpu_to_le64(0);
>> +		vgic_write_guest_lock(kvm, gpa, &val, dte_esz);
> 
> This is just a bit wrong:
> 
> - you store 0 in a u64 after having (pointlessly) converted it to le64
> 
> - you write 'dte_esz' bytes into guest memory, but you don't have any
>   check whether this is *larger* than the u64 you have passed
> 
> Similar issue exists in all the vgic_its_save_*() functions, calling
> for a generic fix, as we're just lucky to never have needed a new ABI
> so far. At the very least a check that we deal with data that is
> exactly 8 bytes.
> 
> Also, is the device table the only one that is subject to this
> 'reload' problem? How about the Collection table?
The collection table is not indexed by the collection ID and when saving
we end up writing an invalid dummy entry to close the recording. So I
don't think we have the same problem there.

For ITT I think we have the same issue on restore because the restore
scans the table until it gets a first valid entry and then chain on next
item. If we have stale entries this looks like the same issue.

Thanks

Eric
> 
> Thanks,
> 
> 	M.
> 

