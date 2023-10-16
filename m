Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C83415491
	for <kvmarm@lists.linux.dev>; Mon, 16 Oct 2023 07:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Vyru7MUz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1697440691;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZMH50QiNx/RpA27e+HDzQ/UaGOzrlDiikAqZXGGX460=;
	b=Vyru7MUzdBs0oCRtlD4H//QT/x3vDD9nRYtBJPzX1oStNSOFVCyIakzEpyfqY+L3kyRezA
	cZrFfPV/f3kTI2ERFlBccAez/igT3jiVC1KpKqDSp4KDKjjkmGuSIq3veAUeUrxaEl64aU
	gKa9KZcaWaMJ6q8trOK6KUvlIX0wxpI=
Received: from mail-vk1-f199.google.com (mail-vk1-f199.google.com
 [209.85.221.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-42-ncjYMw68NFG6Zc9MYri0Rg-1; Mon, 16 Oct 2023 03:18:10 -0400
X-MC-Unique: ncjYMw68NFG6Zc9MYri0Rg-1
Received: by mail-vk1-f199.google.com with SMTP id 71dfb90a1353d-4a40315b416so1604314e0c.0
        for <kvmarm@lists.linux.dev>; Mon, 16 Oct 2023 00:18:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697440689; x=1698045489;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZMH50QiNx/RpA27e+HDzQ/UaGOzrlDiikAqZXGGX460=;
        b=nhqUys3CQKVfSKp9Q+8T+cnqgavO2j0DeA5keZPT5GOjdzm9pXGSGr61DaYsJRz491
         M2PI6iOaqIIIcqnNsjSZEg73qnc7CYu4KyiwPc7xuEsr0hKB3akcGN/WiHcUdsDoDlO+
         8zVWyt+2WLUDCnXe96DLBfimdtpePjv26D0PIEsG98jbvEafw9A5gtFsJBKzyPr9kApM
         6VMize6fnBuq6pDxgDy4yPYZ7IQvp3dbd4KvAcJkKJ1wY4mLp+afrphyd44t4ulSqfiF
         L5G7MMo/EvMt+tzs+WnK1OXtaKJZ5uUDmgETVrj24K5GvdHPm9m4UgK5o2denTi9f8C+
         teWw==
X-Gm-Message-State: AOJu0YxbHeaduXOt1oj6liUS0hiLn3N0ZlsVnoec69g7ZcUPPkyGpn9s
	YvKn4ol+2NFx6fb6Cy7VHDxs8pbrGSH/KB1kUZg/MzMtIuEncVqQ5/N386omTMU5/M0KD8ujWsW
	Av6lo5uWHu6o8NuXu
X-Received: by 2002:a05:6102:3188:b0:457:b01c:4a8e with SMTP id c8-20020a056102318800b00457b01c4a8emr8522094vsh.7.1697440689471;
        Mon, 16 Oct 2023 00:18:09 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFrYKoQ8rnr5V8nFuKW8RRuaP7a7IwQbOXpJHv3bolS3RrOuy5SapWm+qgVLdmd8Y1bvVE4YA==
X-Received: by 2002:a05:6102:3188:b0:457:b01c:4a8e with SMTP id c8-20020a056102318800b00457b01c4a8emr8522084vsh.7.1697440689214;
        Mon, 16 Oct 2023 00:18:09 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id p17-20020ae9f311000000b00772662b7804sm2784186qkg.100.2023.10.16.00.18.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Oct 2023 00:18:08 -0700 (PDT)
Message-ID: <6b9b570c-8d73-eb64-40a7-fe7492e68be5@redhat.com>
Date: Mon, 16 Oct 2023 09:18:04 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Reply-To: eric.auger@redhat.com
Subject: Re: [RESEND PATCH v2] vhost: Allow null msg.size on
 VHOST_IOTLB_INVALIDATE
To: eric.auger.pro@gmail.com, elic@nvidia.com, mail@anirudhrb.com,
 jasowang@redhat.com, mst@redhat.com, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, netdev@vger.kernel.org,
 virtualization@lists.linux-foundation.org, kvmarm@lists.linux.dev
Cc: stable@vger.kernel.org
References: <20230927140544.205088-1-eric.auger@redhat.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20230927140544.205088-1-eric.auger@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

On 9/27/23 16:05, Eric Auger wrote:
> Commit e2ae38cf3d91 ("vhost: fix hung thread due to erroneous iotlb
> entries") Forbade vhost iotlb msg with null size to prevent entries
> with size = start = 0 and last = ULONG_MAX to end up in the iotlb.
>
> Then commit 95932ab2ea07 ("vhost: allow batching hint without size")
> only applied the check for VHOST_IOTLB_UPDATE and VHOST_IOTLB_INVALIDATE
> message types to fix a regression observed with batching hit.
>
> Still, the introduction of that check introduced a regression for
> some users attempting to invalidate the whole ULONG_MAX range by
> setting the size to 0. This is the case with qemu/smmuv3/vhost
> integration which does not work anymore. It Looks safe to partially
> revert the original commit and allow VHOST_IOTLB_INVALIDATE messages
> with null size. vhost_iotlb_del_range() will compute a correct end
> iova. Same for vhost_vdpa_iotlb_unmap().
>
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> Fixes: e2ae38cf3d91 ("vhost: fix hung thread due to erroneous iotlb entries")
> Cc: stable@vger.kernel.org # v5.17+
> Acked-by: Jason Wang <jasowang@redhat.com>
Gentle Ping.

Thanks

Eric
> ---
>  drivers/vhost/vhost.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index c71d573f1c94..e0c181ad17e3 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -1458,9 +1458,7 @@ ssize_t vhost_chr_write_iter(struct vhost_dev *dev,
>  		goto done;
>  	}
>  
> -	if ((msg.type == VHOST_IOTLB_UPDATE ||
> -	     msg.type == VHOST_IOTLB_INVALIDATE) &&
> -	     msg.size == 0) {
> +	if (msg.type == VHOST_IOTLB_UPDATE && msg.size == 0) {
>  		ret = -EINVAL;
>  		goto done;
>  	}

