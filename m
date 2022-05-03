Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 393BBC433F5
	for <kvmarm@archiver.kernel.org>; Tue,  3 May 2022 19:40:58 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 773C94B176;
	Tue,  3 May 2022 15:40:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id pCCIum3duCnn; Tue,  3 May 2022 15:40:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 42C544B092;
	Tue,  3 May 2022 15:40:56 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3BE0E49F22
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 May 2022 15:40:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NRWL65+vcucn for <kvmarm@lists.cs.columbia.edu>;
 Tue,  3 May 2022 15:40:54 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 34A264B0B3
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 May 2022 15:40:54 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1651606852;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=qyazgKmNz6MvewagZP0q+tDesycMY+RcOXxoB9vbg74=;
 b=aN6vzCgpEx6x/kWX3eq3hdaxDIq9v4azfSN0FzXf9QxTzKnndNAC6a+xWBhQeEqkTPnKiF
 JD0z/MrXNdc70tUFodMBtx5fEKyx+QhX/pK0GlZ3NCaV0k2iuhuByfSoNttpwktv7K8rB2
 KjmSJD+xMTIy4J5+Qk6/FhS9fCFESis=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-587-4k-ayDagPPOAZ7M0mVSUpw-1; Tue, 03 May 2022 15:40:51 -0400
X-MC-Unique: 4k-ayDagPPOAZ7M0mVSUpw-1
Received: by mail-qv1-f71.google.com with SMTP id
 p3-20020a05621421e300b004562c4a6b08so14038566qvj.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 03 May 2022 12:40:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:reply-to
 :subject:content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=qyazgKmNz6MvewagZP0q+tDesycMY+RcOXxoB9vbg74=;
 b=fAdy3lSrc9LF/+CoXuXVe4bgG0uH1/TV/TeVbm03V4kS8FNUAyiELvW/ej/u9NiAcQ
 yuaKEwqdiQ0ZE9at+bdN6/uZ4bzJ8Vqf1guz0StFgyAqVlHCoA2yfkNWuZv5U3fMZZEV
 1z9nEvUyvBvaq1JrxqSnb7unMQrhjnNv10AnCcag0CJY3A6bhhXPcXR9FHmQE/8TeBN2
 2EddGRqA/3283u2C7CEEBrxH+JsekSRhleDT9Mz3ad4ktk+wVkbcKHUwDSo0L2+ZdJZh
 sCU1yxSRdfGN3JhC9NotQTjggH5+gisV0Z3cLeTYx+/xp25U0XWKeEkINxKtfGHWm8SC
 RHvA==
X-Gm-Message-State: AOAM531dwBq5ZrtaBjc3MJhuuqDIEbXEDwuimTkNbrEKDWiUaMjwth+p
 Lu9htMfKyWnhnMWclcCF8lN9PNKZlmvpXa3YJXd+T8MKmGVlWtFyRj9/N/57wRx6b7wjLZIuaJ6
 8OGz393xxkYS66NMh3pygyjkP
X-Received: by 2002:ac8:7f0a:0:b0:2f1:f60d:2b39 with SMTP id
 f10-20020ac87f0a000000b002f1f60d2b39mr16038540qtk.470.1651606850800; 
 Tue, 03 May 2022 12:40:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyUzjOo6cdaooCBJoI2l9Mjw62a4uKABfTpoWuDdloGnEHRUre3/Lrt0n+yxqvJ2c59h8moIA==
X-Received: by 2002:ac8:7f0a:0:b0:2f1:f60d:2b39 with SMTP id
 f10-20020ac87f0a000000b002f1f60d2b39mr16038516qtk.470.1651606850552; 
 Tue, 03 May 2022 12:40:50 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874?
 ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
 by smtp.gmail.com with ESMTPSA id
 s15-20020a05620a030f00b0069fc13ce254sm6152999qkm.133.2022.05.03.12.40.47
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 03 May 2022 12:40:49 -0700 (PDT)
Message-ID: <7b5f03d4-1db1-c2c4-c7d6-9e6be3a427e2@redhat.com>
Date: Tue, 3 May 2022 21:40:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v2 4/4] KVM: arm64: vgic: Undo work in failed ITS restores
To: Ricardo Koller <ricarkol@google.com>, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu
References: <20220427184814.2204513-1-ricarkol@google.com>
 <20220427184814.2204513-5-ricarkol@google.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20220427184814.2204513-5-ricarkol@google.com>
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
> Failed ITS restores should clean up all state restored until the
> failure. There is some cleanup already present when failing to restore
> some tables, but it's not complete. Add the missing cleanup.
>
> Note that this changes the behavior in case of a failed restore of the
> device tables.
I assume this is acceptable
>
> 	restore ioctl:
> 	1. restore collection tables
> 	2. restore device tables
>
> With this commit, failures in 2. clean up everything created so far,
> including state created by 1.
>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  arch/arm64/kvm/vgic/vgic-its.c | 15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
> index 86c26aaa8275..c35534d7393a 100644
> --- a/arch/arm64/kvm/vgic/vgic-its.c
> +++ b/arch/arm64/kvm/vgic/vgic-its.c
> @@ -2222,8 +2222,10 @@ static int vgic_its_restore_ite(struct vgic_its *its, u32 event_id,
>  		vcpu = kvm_get_vcpu(kvm, collection->target_addr);
>  
>  	irq = vgic_add_lpi(kvm, lpi_id, vcpu);
> -	if (IS_ERR(irq))
> +	if (IS_ERR(irq)) {
> +		its_free_ite(kvm, ite);
>  		return PTR_ERR(irq);
> +	}
>  	ite->irq = irq;
>  
>  	return offset;
> @@ -2491,6 +2493,9 @@ static int vgic_its_restore_device_tables(struct vgic_its *its)
>  	if (ret > 0)
>  		ret = 0;
>  
> +	if (ret < 0)
> +		vgic_its_free_device_list(its->dev->kvm, its);
> +
>  	return ret;
>  }
>  
> @@ -2617,6 +2622,9 @@ static int vgic_its_restore_collection_table(struct vgic_its *its)
>  		read += cte_esz;
>  	}
>  
> +	if (ret < 0)
> +		vgic_its_free_collection_list(its->dev->kvm, its);
> +
>  	return ret;
>  }
>  
> @@ -2648,7 +2656,10 @@ static int vgic_its_restore_tables_v0(struct vgic_its *its)
>  	if (ret)
>  		return ret;
>  
> -	return vgic_its_restore_device_tables(its);
> +	ret = vgic_its_restore_device_tables(its);
> +	if (ret)
> +		vgic_its_free_collection_list(its->dev->kvm, its);
> +	return ret;
>  }
>  
>  static int vgic_its_commit_v0(struct vgic_its *its)

Looks good to me.
Reviewed-by: Eric Auger <eric.auger@redhat.com>


Eric



_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
