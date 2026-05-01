Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 414972236E3
	for <kvmarm@lists.linux.dev>; Fri,  1 May 2026 02:18:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777601932; cv=none; b=tt63YC+JCwb2ulvY36UFMDnpfjLJU6/MAb9Gpw6ZrRfmJYFMkRG6kc4wFPTIJiIcdDZNBEUm5XEcUCqmN/EzKmPN14VTPjOfVb315iDGKorzty8c716+SwhyeRBlMtjdDlckTAlh1oSbhAQhWj97g/ysWh3dmDD4M9AYi7Vsvj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777601932; c=relaxed/simple;
	bh=dWAEja02q+f6DlyQkqQx/RdtkSSxU8Pw8Mn2QCk6Wso=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ifj/XbXYExqqH2mkqh5Gaj+P+gG6yPTilNAQH4wgwsl4+aJcQog5IzJAuBAq3peRTGjTqNeujNAVtN58yGfJmAFRkW1EpVeCemBnof1gSJqvtubsdn+g0q/VgRb+UzIeTYS5ajT83Xj9f9/wY/Q38VM/jwQAhSX/7Mcan7NCyS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=immunant.com; spf=none smtp.mailfrom=immunant.com; dkim=pass (2048-bit key) header.d=immunant-com.20251104.gappssmtp.com header.i=@immunant-com.20251104.gappssmtp.com header.b=egsUeQM6; arc=none smtp.client-ip=209.85.128.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=immunant.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=immunant.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=immunant-com.20251104.gappssmtp.com header.i=@immunant-com.20251104.gappssmtp.com header.b="egsUeQM6"
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-7927261a3acso14983027b3.0
        for <kvmarm@lists.linux.dev>; Thu, 30 Apr 2026 19:18:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=immunant-com.20251104.gappssmtp.com; s=20251104; t=1777601929; x=1778206729; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2Zz06y3dy6mo3qg7oz1Qz0EljeplPY7aX5ubVoycO3M=;
        b=egsUeQM6lrtEnZ0njgYSNcl+YXf3diZb6Iul+Of2JF8lU6qgG70aQSSZfgPc8e5lrn
         C4MChyWecQI/2MiS7xO35CzIKbI7CjvpMr5DmJQV9dZoKYRAz0WofDJ5X5Wz+8XxF9jR
         eCB8W0hN6EwjIFMTOFPn+3WABU74tKTaJ4AR1YII9GGBpbdo0bbHum7/aotWSIAS3pxp
         7Blti+KaNetpxIBLEMSUW3PJWDBAzy79WhC8b05205bbIdDEPmv8h1TzeKGYjzTqsZng
         giSc/mV91vdMu5OWmHjBUPYFrM/50r9WVWEfMKuGNV1yc6ygT6WYcuEBHNCV6ACK6f0V
         +uPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777601929; x=1778206729;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2Zz06y3dy6mo3qg7oz1Qz0EljeplPY7aX5ubVoycO3M=;
        b=CMcHBxV4acGyg7OnEXPv59iVyvLiI/qn5oLxkGwpkOkgI9fdNt0DgaRbs74YFL1RNd
         mSYsuXEkRJwV98a8z7NkMEqzy0a6o55zlNgdkZDDMOFllsJIjmyZc6yGONWHHQ730Bsd
         CUCXtoiPdZnSnoVEv6Sw4iXSauClMPOqp+f4QIUPHZgGR5AyFNnh6sVRdt+JB4t65tlB
         hkqhC7p0R5bHixRLyeutXAchqPrCUbmgKaVtqUPzx5JRajRKXk+vEv3/sMOpP/bCv8nV
         uQ9fq8e0oJT+yp5UrtAFApRrk7dMuPci1fXvpq+G8+A4OazjI27bM3eSbrhbxON0Dp8X
         fwJQ==
X-Forwarded-Encrypted: i=1; AFNElJ8Neya1Vq2mjbhzxVldKGo6h/z+iZZ0dg0kIIR2GNeEr5NfXDVgjYz+nDADPusZSPVkIaVRzGs=@lists.linux.dev
X-Gm-Message-State: AOJu0YwjcFZsxBl8UClDD7ayo6PG8AveYlUcAq3xU1Rr7kGEULK2+AJA
	jYyXeMGDm4dyEZ9ns/b4MNUur8zMRxqoHQ4JVqCh8drmvf8xUom+VtDcNx7vygFv5dU=
X-Gm-Gg: AeBDiev8OlnuU6m86oWQ54xHPtRBHBAJ1jAjTSlcCEuYmcTDHw7SIUpxf4Zu2Kr2QOX
	h69mD3ZOOuMDt5lsyd8prUcLUuijyHDr6zB5xUYaHs4NZ+zrNyTCmrNIlcEFwVt3fu3g2RCUsYz
	BmRqLHFMbLxuaFT9kp9fA5pcf/P2HnOa0nEI3v3tM7Pyyhe+AutkYOZDltQgvsi0LvW9MDPqFiX
	WcZokAHZyNRyAA8rnVjNfy82thZAJSV1jKBfWVDMRGNQCt4PoIH04B8j6wntQeA15kmZ+MxtOAe
	azqoWAKO7LAinquxt/bYA1/lTt2jkT/NzBWa7+bgZZwnBlXuhdfnNf7/7m2Awz4mbihIIw6PfXA
	IDod9Oyo3kFKsqgnvk+nrNRstFUazedg2dZpz5Yz6x3/3amZtTr1ORhVeoAkJY2jyNlIppsaB/l
	QeRy7bqXaMqubPtdNGJEL9Q1+EsgiEA5F0jIVgbHZxy/RHdsdgf5lKhAEI9OkqayN3XkincvMxl
	0gaimA=
X-Received: by 2002:a05:690c:348a:b0:7bb:eaf:5101 with SMTP id 00721157ae682-7bd52844a2cmr58631067b3.16.1777601929088;
        Thu, 30 Apr 2026 19:18:49 -0700 (PDT)
Received: from [10.87.48.52] ([12.15.201.178])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7bd66838851sm5182957b3.23.2026.04.30.19.18.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Apr 2026 19:18:48 -0700 (PDT)
Message-ID: <635b64dc-0083-4421-9145-59636c4ac7cc@immunant.com>
Date: Thu, 30 Apr 2026 19:18:46 -0700
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 1/2] KVM: arm64: Support FFA_MSG_SEND_DIRECT_REQ in
 host handler
To: Will Deacon <will@kernel.org>, perlarsen@google.com
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Yeoreum Yun <yeoreum.yun@arm.com>, Ben Horgan <ben.horgan@arm.com>,
 Oliver Upton <oupton@kernel.org>, Armelle Laine <armellel@google.com>,
 Sebastien Ene <sebastianene@google.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 linux-kernel@vger.kernel.org
References: <20260121-host-direct-messages-v5-0-2c1614c94e80@google.com>
 <20260121-host-direct-messages-v5-1-2c1614c94e80@google.com>
 <aXNvzxoBXr-oRB8r@willie-the-truck>
Content-Language: en-US
From: Per Larsen <perl@immunant.com>
In-Reply-To: <aXNvzxoBXr-oRB8r@willie-the-truck>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 1/23/26 4:55 AM, Will Deacon wrote:
> Per,
> 
> On Wed, Jan 21, 2026 at 08:27:12AM +0000, Per Larsen via B4 Relay wrote:
>> From: Sebastian Ene <sebastianene@google.com>
>>
>> Allow direct messages to be forwarded from the host. The host should
>> not be sending framework messages so they are filtered out.
>>
>> Signed-off-by: Sebastian Ene <sebastianene@google.com>
>> Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
>> Signed-off-by: Per Larsen <perlarsen@google.com>
>> ---
>>   arch/arm64/kvm/hyp/nvhe/ffa.c | 26 ++++++++++++++++++++++++++
>>   1 file changed, 26 insertions(+)
>>
>> diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
>> index f731cc4c3f280a32acccca0de92b9ac6c8e05602..9967916278a7ca051500946ef2fcfe7bb40e0e8d 100644
>> --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
>> +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
>> @@ -862,6 +862,28 @@ static void do_ffa_part_get(struct arm_smccc_1_2_regs *res,
>>   	hyp_spin_unlock(&host_buffers.lock);
>>   }
>>   
>> +static void do_ffa_direct_msg(struct arm_smccc_1_2_regs *res,
>> +			      struct kvm_cpu_context *ctxt,
>> +			      u64 vm_handle)
>> +{
>> +	DECLARE_REG(u32, flags, ctxt, 2);
>> +
>> +	struct arm_smccc_1_2_regs *args = (void *)&ctxt->regs.regs[0];
>> +
>> +	if (vm_handle != HOST_FFA_ID) {
>> +		ffa_to_smccc_error(res, FFA_RET_INVALID_PARAMETERS);
>> +		return;
>> +	}
> 
> Sorry, but this isn't what I had in mind. 'vm_handle' is just a local
> variable and the only caller passes HOST_FFA_ID, so this isn't really
> achieving anything.
> 
> What you had in v4 dropped the 'vm_handle' argument entirely, which I
> think is the right thing to do. However, the FF-A spec encodes the sender
> ID in bits 31:16 of register W1 and so _that_ is what I think we should
> be checking because _that_ is what the receiver will see.

I should have read your feedback more closely and checked against the 
spec. I will add a new mask for bits 31:16 to check sender ID against
HOST_FFA_ID. Sorry to waste a review cycle and your attention on this.

> Honestly, we could avoid quite a lot of these review cycles if you
> actually replied to my emails on the list instead of just responding
> with a new patch series each time. It's supposed to be a technical
> discussion...

Acknowledged; will do! Apologies for the very late reply.



