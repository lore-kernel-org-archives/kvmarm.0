Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02FEEC433F5
	for <kvmarm@archiver.kernel.org>; Thu,  9 Dec 2021 16:38:08 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6EB4E4B0DE;
	Thu,  9 Dec 2021 11:38:08 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2UwOGJc0HBap; Thu,  9 Dec 2021 11:38:06 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C9F5D4B0BF;
	Thu,  9 Dec 2021 11:38:06 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 836994B0B3
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Dec 2021 11:38:05 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gv6-MugjYont for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Dec 2021 11:38:04 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9DF804B0A3
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Dec 2021 11:38:04 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1639067884;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=jNxrSJ7hA39700PK5sP9nWrntBLNr8e9xNebTOGiU18=;
 b=aMB9he4adxWVAHPddpbC7tYDw+MnVsvOtIe57Owss6iC7nFbaZgjeygzO/RHU4GZ+lQOzB
 TSXx/shiNYMaC6QlwYpEdaF0DzvEPFleXPqpYnUQXBD7kX7u7HS+qhTDACoGneBGC9ZwyY
 Ujv4qwrWrCLP/rmvLvpwrzG6jlA0+/U=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-542-9BvP4gRHNfa4xW1dOCC4qg-1; Thu, 09 Dec 2021 11:38:02 -0500
X-MC-Unique: 9BvP4gRHNfa4xW1dOCC4qg-1
Received: by mail-wr1-f72.google.com with SMTP id
 r2-20020adfe682000000b00198af042b0dso1581047wrm.23
 for <kvmarm@lists.cs.columbia.edu>; Thu, 09 Dec 2021 08:38:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:subject:to:cc:references:from
 :message-id:date:user-agent:mime-version:in-reply-to
 :content-transfer-encoding:content-language;
 bh=jNxrSJ7hA39700PK5sP9nWrntBLNr8e9xNebTOGiU18=;
 b=cFIvlSUvuqhXqNLkTKr9Y75yTAbJdrN0zL5wKPlh83kfjqVZWA18J/gFeNv95F+Ksp
 qcKAAz/J3gQzrUDrclor5TRVsNy+M6KLI2Y+BcPuM8aKK9KGC+BKraY9g9kYnnp6mnC2
 yVvg2yvHp0goNQLc9YxQ/1AmRI+haOt78p2x7w+7SxTYyIW7AbJmSB4Dv4XTpGs77Kbg
 ZespxrZy92bkSM4smhjVjHJfBMlJ8+Ng1kdJckH4PKFlcHZIa5DlMhVheNpDLNHElXso
 5hwPyB41PgzFJatiukzuTw0G4297pm/xI1hf8iCX8JoTvO0eDnoBhpt9z4RvNOc22Bs4
 2c8A==
X-Gm-Message-State: AOAM531HcwkEVMuWwypfABpATE64yPFhuY8Riqlx6tAbSh6VdQuB6GQi
 3q0EXPubPVfTRQyKD9K+RpW8TfRxjAQuSMOnlxAPLOrFyCzRASXXwwGdJ2WxxhDeY9L2t3SEyw7
 DX8XKTM6SbRSkiW6gYpMbvOzy
X-Received: by 2002:a5d:58ed:: with SMTP id f13mr7636102wrd.373.1639067881512; 
 Thu, 09 Dec 2021 08:38:01 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzaV0R+9HzYiSu0FZYalbofmj5ndV0Ij51Jvm3EMXiekkqz6rpjx+QrGmfxHOtUjUM3LxbGgQ==
X-Received: by 2002:a5d:58ed:: with SMTP id f13mr7636061wrd.373.1639067881306; 
 Thu, 09 Dec 2021 08:38:01 -0800 (PST)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874?
 ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
 by smtp.gmail.com with ESMTPSA id d7sm163025wrw.87.2021.12.09.08.37.59
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 09 Dec 2021 08:38:00 -0800 (PST)
Subject: Re: [RFC v16 1/9] iommu: Introduce attach/detach_pasid_table API
To: Jason Gunthorpe <jgg@nvidia.com>
References: <20211027104428.1059740-1-eric.auger@redhat.com>
 <20211027104428.1059740-2-eric.auger@redhat.com>
 <Ya3qd6mT/DpceSm8@8bytes.org>
 <c7e26722-f78c-a93f-c425-63413aa33dde@redhat.com>
 <e6733c59-ffcb-74d4-af26-273c1ae8ce68@linux.intel.com>
 <fbeabcff-a6d4-dcc5-6687-7b32d6358fe3@redhat.com>
 <20211208125616.GN6385@nvidia.com> <YbDpZ0pf7XeZcc7z@myrica>
 <20211208183102.GD6385@nvidia.com>
 <b576084b-482f-bcb7-35a6-d786dbb305e1@redhat.com>
 <20211209154046.GQ6385@nvidia.com>
From: Eric Auger <eric.auger@redhat.com>
Message-ID: <f6e93350-e0ee-649a-bf97-314398481fc8@redhat.com>
Date: Thu, 9 Dec 2021 17:37:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20211209154046.GQ6385@nvidia.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=eric.auger@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: kevin.tian@intel.com, lushenming@huawei.com, robin.murphy@arm.com,
 ashok.raj@intel.com, kvm@vger.kernel.org,
 Jean-Philippe Brucker <jean-philippe@linaro.org>, maz@kernel.org,
 Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
 iommu@lists.linux-foundation.org, vsethi@nvidia.com, vivek.gautam@arm.com,
 alex.williamson@redhat.com, wangxingang5@huawei.com, zhangfei.gao@linaro.org,
 eric.auger.pro@gmail.com, will@kernel.org, kvmarm@lists.cs.columbia.edu,
 Lu Baolu <baolu.lu@linux.intel.com>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
Reply-To: eric.auger@redhat.com
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

Hi Jason,

On 12/9/21 4:40 PM, Jason Gunthorpe wrote:
> On Thu, Dec 09, 2021 at 08:50:04AM +0100, Eric Auger wrote:
>
>>> The kernel API should accept the S1ContextPtr IPA and all the parts of
>>> the STE that relate to the defining the layout of what the S1Context
>>> points to an thats it.
>> Yes that's exactly what is done currently. At config time the host must
>> trap guest STE changes (format and S1ContextPtr) and "incorporate" those
>> changes into the stage2 related STE information. The STE is owned by the
>> host kernel as it contains the stage2 information (S2TTB).
> [..]
>
>> Note this series only coped with a single CD in the Context Descriptor
>> Table.
> I'm confused, where does this limit arise?
>
> The kernel accepts as input all the bits in the STE that describe the
> layout of the CDT owned by userspace, shouldn't userspace be able to
> construct all forms of CDT with any number of CDs in them?
>
> Or do you mean this is some qemu limitation?
The upstream vSMMUv3 emulation does not support multiple CDs at the
moment and since I have no proper means to validate the vSVA case I am
rejecting any attempt from user space to inject guest configs featuring
mutliple PASIDs. Also PASID cache invalidation must be added to this series.

Nevertheless those limitations were tackled and overcomed by others in
CC so I don't think there is any blocking issue.

Thanks

Eric
>
> Jason
>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
