Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF214C433F5
	for <kvmarm@archiver.kernel.org>; Tue,  3 May 2022 17:14:37 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7E8BD4B0B3;
	Tue,  3 May 2022 13:14:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id p87efRLGWXV8; Tue,  3 May 2022 13:14:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5CD5840FD3;
	Tue,  3 May 2022 13:14:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 76F2C400D1
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 May 2022 13:14:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DaYhBI5mPWG1 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  3 May 2022 13:14:34 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6921F4B12E
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 May 2022 13:14:34 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1651598074;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=h0UT80e2OsE53D4hX7NPBQUv2OnFyP0f8Hl74ukax6s=;
 b=SUCdLE4pSxzShOkBhDaCla+h41E05FodjMXn/SL5ZVho/UetrOjT8ZxeIPYp9YUYJgf+70
 JPUskNg7oGYV/kpiPoOeDtjDf39uwiqOL7UJpdYMpm46LQ94P6s4v9qT9QdrMhmMtg7C4n
 lMksdx6odFPbA4S0Cn8voQOTiqDglHI=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-625-90HH8Gd5P-O_uEus6Uzt5Q-1; Tue, 03 May 2022 13:14:23 -0400
X-MC-Unique: 90HH8Gd5P-O_uEus6Uzt5Q-1
Received: by mail-wr1-f69.google.com with SMTP id
 p10-20020adfaa0a000000b0020c4829af5fso4341415wrd.16
 for <kvmarm@lists.cs.columbia.edu>; Tue, 03 May 2022 10:14:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:reply-to
 :subject:content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=h0UT80e2OsE53D4hX7NPBQUv2OnFyP0f8Hl74ukax6s=;
 b=RM+puSePkOhBA83tMYaIjwljeSE1rcD3FW7nd2Z7G/SvoNVP6Vi5Yy5Z0kFXzDHklw
 3VsPHn7ZVqYmDHyd6W0fHt7MYswDt6lk1zie8VmfUHCK0fNHZ1wW+PXmlHPPF6HOYRTH
 LpSTQebEQyRs4YEwYVc4rTMsfX2f/0bexKoPHjUnljUP4y1tK0iMQtlUZpa7G+AGlox6
 gjiIg7+kH6jiOhuWuWVZ9RAnFF6KpVvgkJ2R4Z9NUa3fUlkoo7mhGpClcLk4WDr1G6wJ
 nmMbXZ3dDpDFWZFQgPORkq3o066L+TrSRl0ATXBiQMI2MusHfQzKj7W4nmkUf8BaaLp0
 j4Qg==
X-Gm-Message-State: AOAM530kUzQTC/kUnBcyYLi1tvpL1xVxcnRChpa00rGFF2d7m1qmI9hM
 k4W8KmHHp/4IzAyFeuFNgT1D5TPJEO6XTCK2DeyzYDRpVBb/Sb8QAjyjILBoU3EEyHwK4mpgtfl
 2uGveE8/XTITlKWQ69TcWzHK4
X-Received: by 2002:adf:b64c:0:b0:1e3:16d0:3504 with SMTP id
 i12-20020adfb64c000000b001e316d03504mr13448948wre.333.1651598061986; 
 Tue, 03 May 2022 10:14:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJya43tZ6jxxsbkw9572l1+qFt/gUK79IGQU1kaGfQ6INDKO08w2SsPjVH/HLOTiYFV5o9hkTQ==
X-Received: by 2002:adf:b64c:0:b0:1e3:16d0:3504 with SMTP id
 i12-20020adfb64c000000b001e316d03504mr13448923wre.333.1651598061742; 
 Tue, 03 May 2022 10:14:21 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874?
 ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
 by smtp.gmail.com with ESMTPSA id
 l20-20020a05600c1d1400b003942a244ed1sm2461871wms.22.2022.05.03.10.14.20
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 03 May 2022 10:14:20 -0700 (PDT)
Message-ID: <b29fcba7-2599-bf1b-0720-26b05cc37fd4@redhat.com>
Date: Tue, 3 May 2022 19:14:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v2 2/4] KVM: arm64: vgic: Add more checks when restoring
 ITS tables
To: Ricardo Koller <ricarkol@google.com>, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu
References: <20220427184814.2204513-1-ricarkol@google.com>
 <20220427184814.2204513-3-ricarkol@google.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20220427184814.2204513-3-ricarkol@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=eric.auger@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: andre.przywara@arm.com, pshier@google.com, maz@kernel.org,
 pbonzini@redhat.com
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

Hi Ricardo,

On 4/27/22 20:48, Ricardo Koller wrote:
> Try to improve the predictability of ITS save/restores (and debuggability
> of failed ITS saves) by failing early on restore when trying to read
> corrupted tables.
>
> Restoring the ITS tables does some checks for corrupted tables, but not as
> many as in a save: an overflowing device ID will be detected on save but
> not on restore.  The consequence is that restoring a corrupted table won't
> be detected until the next save; including the ITS not working as expected
> after the restore.  As an example, if the guest sets tables overlapping
> each other, which would most likely result in some corrupted table, this is
> what we would see from the host point of view:
>
> 	guest sets base addresses that overlap each other
> 	save ioctl
> 	restore ioctl
> 	save ioctl (fails)
>
> Ideally, we would like the first save to fail, but overlapping tables could
> actually be intended by the guest. So, let's at least fail on the restore
> with some checks: like checking that device and event IDs don't overflow
> their tables.
>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  arch/arm64/kvm/vgic/vgic-its.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
>
> diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
> index e14790750958..fb2d26a73880 100644
> --- a/arch/arm64/kvm/vgic/vgic-its.c
> +++ b/arch/arm64/kvm/vgic/vgic-its.c
> @@ -2198,6 +2198,12 @@ static int vgic_its_restore_ite(struct vgic_its *its, u32 event_id,
>  	if (!collection)
>  		return -EINVAL;
>  
> +	if (find_ite(its, dev->device_id, event_id))
> +		return -EINVAL;
Unsure about that. Nothing in the arm-vgic-its.rst doc says that the
KVM_DEV_ARM_ITS_RESTORE_TABLES ioctl cannot be called several times
(although obviously useless)
> +
> +	if (!vgic_its_check_event_id(its, dev, event_id))
> +		return -EINVAL;
> +
>  	ite = vgic_its_alloc_ite(dev, collection, event_id);
>  	if (IS_ERR(ite))
>  		return PTR_ERR(ite);
> @@ -2319,6 +2325,7 @@ static int vgic_its_restore_dte(struct vgic_its *its, u32 id,
>  				void *ptr, void *opaque)
>  {
>  	struct its_device *dev;
> +	u64 baser = its->baser_device_table;
>  	gpa_t itt_addr;
>  	u8 num_eventid_bits;
>  	u64 entry = *(u64 *)ptr;
> @@ -2339,6 +2346,12 @@ static int vgic_its_restore_dte(struct vgic_its *its, u32 id,
>  	/* dte entry is valid */
>  	offset = (entry & KVM_ITS_DTE_NEXT_MASK) >> KVM_ITS_DTE_NEXT_SHIFT;
>  
> +	if (find_its_device(its, id))
> +		return -EINVAL;
same here.
> +
> +	if (!vgic_its_check_id(its, baser, id, NULL))
> +		return -EINVAL;
> +
>  	dev = vgic_its_alloc_device(its, id, itt_addr, num_eventid_bits);
>  	if (IS_ERR(dev))
>  		return PTR_ERR(dev);
Thanks

Eric

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
