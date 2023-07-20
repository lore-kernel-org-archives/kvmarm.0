Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD6C82598
	for <kvmarm@lists.linux.dev>; Thu, 20 Jul 2023 11:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1689854301;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0dNgYkR9W7VbSPxZGAcgSDALg6OyW+ZsaC5VGkZKv2Q=;
	b=QouPsMFVAezlR4wAGgxSlXpdLauLgfajZoj0XBfHzg+RGqutEQC/bP+AxonRACt2SJw16g
	H9lUIE6ubwf8EoLPdUjDQ7LDZGdFsonmwEHzTvBXBaWNApKvk1rBDT2YeIracLl6wh38o9
	0kRnpf1A6YxzRyTiJlknnbKJcZPtNRg=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-306-NdJfVdCuPpKwkEVvawexQA-1; Thu, 20 Jul 2023 07:58:19 -0400
X-MC-Unique: NdJfVdCuPpKwkEVvawexQA-1
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-1b88676ef9fso912835ad.1
        for <kvmarm@lists.linux.dev>; Thu, 20 Jul 2023 04:58:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689854298; x=1690459098;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0dNgYkR9W7VbSPxZGAcgSDALg6OyW+ZsaC5VGkZKv2Q=;
        b=X0Zyf9AyW9f0mDBimhYBl8znD5rP//XKKUOoPKVYFBuuKdAqOvRSyyn1BDG3DpVQAT
         SImjDEkaHewm9ocvppfc/GBOTbKNDgprYCKdn99NpJkwG0EwHGZ56vhGQGEwdyBfr5XP
         CP2WNQucwp8F/qTGHfWvlV4rnjvisvrVxxf885cgpT1DpvWOcLChK/r3RkznOVIj3UjR
         oRVSTUEzYbQcssXab/pq9gQuD/pLGqGNG5iLE901MLXmMphL0SrqVXGNxOV6NEY2aHgZ
         l+LOnsdFOmiDC3od887TLT98DwfC/T5Ns9vHtPzrOkHaEwVzRf5CvSlRb1VXLWTliP7r
         ZpqQ==
X-Gm-Message-State: ABy/qLZ8wO5FPdhNdPmy5KzlQGRpxhvE6WIwtL2dcRG+x7H393Qvr331
	gzK+ubkxxd8QIrNrCQu++zO7xubTBGxAseAMlOGmylgRfjb67KJW9bX9zwWpkkmj6AdiSlww+6v
	NOd5i3Fth8/rXYvNA
X-Received: by 2002:a17:902:d50e:b0:1b8:811:b079 with SMTP id b14-20020a170902d50e00b001b80811b079mr3135247plg.0.1689854298355;
        Thu, 20 Jul 2023 04:58:18 -0700 (PDT)
X-Google-Smtp-Source: APBJJlGjBq2vTMir1cBsPHCjdcjF3pXZv3IdwkvYZkbkcoa2SqoyCuxpuAvOR6jX0+7TBeGFOEuucg==
X-Received: by 2002:a17:902:d50e:b0:1b8:811:b079 with SMTP id b14-20020a170902d50e00b001b80811b079mr3135227plg.0.1689854298032;
        Thu, 20 Jul 2023 04:58:18 -0700 (PDT)
Received: from [10.66.61.39] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d17-20020a170902c19100b001b9e1d5f8e0sm1176040pld.91.2023.07.20.04.58.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Jul 2023 04:58:17 -0700 (PDT)
Message-ID: <0a2dab13-b7ea-7621-00d9-7af2b17aa5ce@redhat.com>
Date: Thu, 20 Jul 2023 19:58:15 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [kvm-unit-tests PATCH v1 2/2] arm64: Define name for the bits
 used in SCTLR_EL1_RES1
To: eric.auger@redhat.com, andrew.jones@linux.dev
Cc: Alexandru Elisei <alexandru.elisei@arm.com>, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org
References: <20230719031926.752931-1-shahuang@redhat.com>
 <20230719031926.752931-3-shahuang@redhat.com>
 <433bb06d-5eaa-d21f-70c8-02311c06a650@redhat.com>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <433bb06d-5eaa-d21f-70c8-02311c06a650@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Eric,

On 7/20/23 01:46, Eric Auger wrote:
> Hi Shaoqin,
> 
> On 7/19/23 05:19, Shaoqin Huang wrote:
>> Currently some fields in SCTLR_EL1 don't define a name and directly used
>> in the SCTLR_EL1_RES1, that's not good now since these fields have been
>> functional and have a name.
>>
>> According to the ARM DDI 0487J.a, define the name related to these
>> fields.
>>
>> Suggested-by: Alexandru Elisei <alexandru.elisei@arm.com>
>> Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
>> ---
>>   lib/arm64/asm/sysreg.h | 13 +++++++++++--
>>   1 file changed, 11 insertions(+), 2 deletions(-)
>>
>> diff --git a/lib/arm64/asm/sysreg.h b/lib/arm64/asm/sysreg.h
>> index c7f529d..9c68698 100644
>> --- a/lib/arm64/asm/sysreg.h
>> +++ b/lib/arm64/asm/sysreg.h
>> @@ -80,17 +80,26 @@ asm(
>>   #define ICC_GRPEN1_EL1			sys_reg(3, 0, 12, 12, 7)
>>   
>>   /* System Control Register (SCTLR_EL1) bits */
>> +#define SCTLR_EL1_LSMAOE	_BITUL(29)
>> +#define SCTLR_EL1_NTLSMD	_BITUL(28)
>>   #define SCTLR_EL1_EE		_BITUL(25)
>> +#define SCTLR_EL1_SPAN		_BITUL(23)
>> +#define SCTLR_EL1_EIS		_BITUL(22)
>> +#define SCTLR_EL1_TSCXT		_BITUL(20)
>>   #define SCTLR_EL1_WXN		_BITUL(19)
>>   #define SCTLR_EL1_I		_BITUL(12)
>> +#define SCTLR_EL1_EOS		_BITUL(11)
>> +#define SCTLR_EL1_SED		_BITUL(8)
>> +#define SCTLR_EL1_ITD		_BITUL(7)
>>   #define SCTLR_EL1_SA0		_BITUL(4)
>>   #define SCTLR_EL1_SA		_BITUL(3)
>>   #define SCTLR_EL1_C		_BITUL(2)
>>   #define SCTLR_EL1_A		_BITUL(1)
>>   #define SCTLR_EL1_M		_BITUL(0)
>>   
>> -#define SCTLR_EL1_RES1	(_BITUL(7) | _BITUL(8) | _BITUL(11) | _BITUL(20) | \
>> -			 _BITUL(22) | _BITUL(23) | _BITUL(28) | _BITUL(29))
>> +#define SCTLR_EL1_RES1	(SCTLR_EL1_ITD | SCTLR_EL1_SED | SCTLR_EL1_EOS | \
>> +			 SCTLR_EL1_TSCXT | SCTLR_EL1_EIS | SCTLR_EL1_SPAN | \
>> +			 SCTLR_EL1_NTLSMD | SCTLR_EL1_LSMAOE)
>>   #define INIT_SCTLR_EL1_MMU_OFF	\
>>   			SCTLR_EL1_RES1
>>   
> The change looks good to me (although _BITULL remark still holds).
> 
> Independently on this patch the _RES1 terminology looks odd to me. For
> example ESO bit is RES1 only if FEAT_ExS is not implemented. Maybe I
> misunderstand why it was named that way but to me RES1 means another
> thing. If confirmed we could simply drop SCTLR_EL1_RES1 which is not
> used elsewhere and directly define INIT_SCTLR_EL1_MMU_OF.

The SCTLR_EL1_RES1 was originally defined by commit 10b65ce ("arm64: 
Configure SCTLR_EL1 at boot"). It seems at that time the BIT(11), yes 
the EOS bit is undefined, and must be reserved for 1, but now it has a 
definition which is EOS. It should have no effect if set EOS bit to 1 
since its originally res to 1.

SCTLR_EL1_RES1 can simply be dropped since it has no other user.

Thanks,
Shaoqin

> 
> Thanks
> 
> Eric
> 

-- 
Shaoqin

