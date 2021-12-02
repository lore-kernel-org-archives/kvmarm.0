Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74F12C433F5
	for <kvmarm@archiver.kernel.org>; Thu,  2 Dec 2021 13:11:35 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D7E0E4B1AA;
	Thu,  2 Dec 2021 08:11:34 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vh3GrmNDvv0z; Thu,  2 Dec 2021 08:11:33 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 454744B175;
	Thu,  2 Dec 2021 08:11:33 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A5D1B4B10E
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Dec 2021 08:11:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KK4bSK4NzIjT for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Dec 2021 08:11:31 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 912EE4B108
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Dec 2021 08:11:31 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1638450691;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=+ORZwySvXsS7bVMV6iSSKGBVEj6KTyOWMLSUM7WG+EM=;
 b=CtM7bNFm1bMCYK6mSnvMSdQj6h9KG8gqZG5c9BMdf6lTS9jBnzGCavUlZPUEk4Ao641gKJ
 v4vuYacmLhhhvoPbQThKen1R5kopNmieAyNl+V6ooCGqqa7ATrtoigzNMAS0ev4gxoouam
 vlMbIlTf2LXxAcH9bzIlvni1kGiob2I=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-590-wSP8phNTOTCDlw9Y8-BHcQ-1; Thu, 02 Dec 2021 08:11:30 -0500
X-MC-Unique: wSP8phNTOTCDlw9Y8-BHcQ-1
Received: by mail-wm1-f70.google.com with SMTP id
 201-20020a1c04d2000000b003335bf8075fso14001025wme.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 02 Dec 2021 05:11:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=+ORZwySvXsS7bVMV6iSSKGBVEj6KTyOWMLSUM7WG+EM=;
 b=s6LRDw4UqPyt3y06/fOwFGHFbAhah+/DnUrl4SJdA76WW/jCHvJg8swlydUPdjDmc/
 ZShR8Z5fB2yUhTfagIn5jz2BYsugW8y2izQDtWrlM4OqYZhjl0cXvG66O7Z5p9vfkzng
 ccyuiUq3TXx7JnKzz8uCgQgFMwcWIpesTGq5+CpmQLLhUnjfcnra7ci4nOsQnSixRbRn
 atM1QhYtT8zh/hbXJbhiXj/hAHb6QzQQfVHXUuhY4UchHbxDCHd95H/2YPTFffzvn9GC
 8Rda73U22Sf4QeHYha2aIbEbx+j7AAzARbI6Y4Z0f0jdI7/B5ckHZ7UEza2qVm0jRUcA
 CeIQ==
X-Gm-Message-State: AOAM531G+RKn/UQUGQrIZDoLQpBanfgWiQfL4Bj5G7S6N8SpwXfzfIDO
 NFmEfMykGXG5tof9bUAjDUkJhYRxyV2MyETmXs8igM75OOqPl3htgG4QLrSSjl6tG7V2BV6vOnD
 +5yW7AQ1hgRSBGRdyth4oZbCt
X-Received: by 2002:adf:dc47:: with SMTP id m7mr14456760wrj.576.1638450689219; 
 Thu, 02 Dec 2021 05:11:29 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzRywFER8Vz2gbwjUzZSItMbLcPLhaPUjX8ZwPMMxFDRKOO8TYuB0M5JAWiIxd6BSWzMOBhjg==
X-Received: by 2002:adf:dc47:: with SMTP id m7mr14456719wrj.576.1638450689005; 
 Thu, 02 Dec 2021 05:11:29 -0800 (PST)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874?
 ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
 by smtp.gmail.com with ESMTPSA id h22sm2174819wmq.14.2021.12.02.05.11.27
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 02 Dec 2021 05:11:28 -0800 (PST)
Subject: Re: [RFC PATCH v3 12/29] KVM: arm64: Make ID_DFR1_EL1 writable
To: Reiji Watanabe <reijiw@google.com>
References: <20211117064359.2362060-1-reijiw@google.com>
 <20211117064359.2362060-13-reijiw@google.com>
 <44073484-639e-3d23-2068-ae5c2cac3276@redhat.com>
 <CAAeT=FyBaKvof6BpPB021MN6k797BcMP+sPMDeiZ9SR6nvXdCA@mail.gmail.com>
From: Eric Auger <eauger@redhat.com>
Message-ID: <7a2ef550-eadb-7fa3-8aa4-f666a14d6efa@redhat.com>
Date: Thu, 2 Dec 2021 14:11:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAAeT=FyBaKvof6BpPB021MN6k797BcMP+sPMDeiZ9SR6nvXdCA@mail.gmail.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=eauger@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, Will Deacon <will@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu



On 11/30/21 6:39 AM, Reiji Watanabe wrote:
> Hi Eric,
> 
> On Thu, Nov 25, 2021 at 12:30 PM Eric Auger <eauger@redhat.com> wrote:
>>
>> Hi Reiji,
>>
>> On 11/17/21 7:43 AM, Reiji Watanabe wrote:
>>> This patch adds id_reg_info for ID_DFR1_EL1 to make it writable
>>> by userspace.
>>>
>>> Signed-off-by: Reiji Watanabe <reijiw@google.com>
>>> ---
>>>  arch/arm64/kvm/sys_regs.c | 6 ++++++
>>>  1 file changed, 6 insertions(+)
>>>
>>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>>> index fbd335ac5e6b..dda7001959f6 100644
>>> --- a/arch/arm64/kvm/sys_regs.c
>>> +++ b/arch/arm64/kvm/sys_regs.c
>>> @@ -859,6 +859,11 @@ static struct id_reg_info id_dfr0_el1_info = {
>>>       .get_reset_val = get_reset_id_dfr0_el1,
>>>  };
>>>
>>> +static struct id_reg_info id_dfr1_el1_info = {
>>> +     .sys_reg = SYS_ID_DFR1_EL1,
>>> +     .ftr_check_types = S_FCT(ID_DFR1_MTPMU_SHIFT, FCT_LOWER_SAFE),
>> what about the 0xF value which indicates the MTPMU is not implemented?
> 
> The field is treated as a signed field.
> So, 0xf(== -1) is handled correctly.
> (Does it answer your question?)

yes thanks

Eric
> 
> Thanks,
> Reiji
> 
>>
>> Eric
>>> +};
>>> +
>>>  /*
>>>   * An ID register that needs special handling to control the value for the
>>>   * guest must have its own id_reg_info in id_reg_info_table.
>>> @@ -869,6 +874,7 @@ static struct id_reg_info id_dfr0_el1_info = {
>>>  #define      GET_ID_REG_INFO(id)     (id_reg_info_table[IDREG_IDX(id)])
>>>  static struct id_reg_info *id_reg_info_table[KVM_ARM_ID_REG_MAX_NUM] = {
>>>       [IDREG_IDX(SYS_ID_DFR0_EL1)] = &id_dfr0_el1_info,
>>> +     [IDREG_IDX(SYS_ID_DFR1_EL1)] = &id_dfr1_el1_info,
>>>       [IDREG_IDX(SYS_ID_AA64PFR0_EL1)] = &id_aa64pfr0_el1_info,
>>>       [IDREG_IDX(SYS_ID_AA64PFR1_EL1)] = &id_aa64pfr1_el1_info,
>>>       [IDREG_IDX(SYS_ID_AA64DFR0_EL1)] = &id_aa64dfr0_el1_info,
>>>
>>
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
