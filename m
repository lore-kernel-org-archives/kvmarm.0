Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F1A41F175
	for <kvmarm@lists.linux.dev>; Wed, 13 Sep 2023 14:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694613617;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1yK3xgmt1aeFdUkAxw9Y0+ZQFHP2f+qkDkwODsKtQl0=;
	b=XZ1evR91CpdLnhkuH/KEjMBaU8YJNadRa7LkJxiOHa/Z5IVKXX8WCsMimJPHwgPUTQ9W4t
	sNz3M2DmvMeUsXnvppSLpbfrgBPlA/VIIt34yY4H0qexoq7zvEufQUlpJL/hBHr+uGhvoR
	nmS3AhzFqK2xafRU7CBtRtEH+kK7XRg=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-562-jEIEbgVAPhmFlE8cM_zVpA-1; Wed, 13 Sep 2023 10:00:13 -0400
X-MC-Unique: jEIEbgVAPhmFlE8cM_zVpA-1
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-76ef205d695so68817085a.0
        for <kvmarm@lists.linux.dev>; Wed, 13 Sep 2023 07:00:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694613613; x=1695218413;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1yK3xgmt1aeFdUkAxw9Y0+ZQFHP2f+qkDkwODsKtQl0=;
        b=snc0Fv9+OlRXisU8gevz3I6HLJlt2AXrBZYUx+JuvXie40gfnPeRMb6JfpLqZy6o80
         rzG1aZ33quEEjfWln0R0fYBynPdSGYvZTlYDQEme8hy8ABUEP0KlyvXtFAX3gfDM6mYe
         EQwDJxjmtdkfLATq6JVVumCLK/801Qec1JySeBdFqd9kZzcqTO5vm7ycuAOTx4cFJ3Tn
         dm9jvcsMi9TaKVLR3CFg7fdzJ+ZIZ1+C4qeUI8Y138rTVI/8V5aamZOoxvLS17u7d/me
         3wcV8nNNRYTdfaXkdzG5U7uTBozSBWcv1YbC+u3J0xVA+T24uEyn/lL2DIFzzxkqxUak
         uacg==
X-Gm-Message-State: AOJu0Yz9IilA4rezjgiZhO2MQi51d0X0ABnBLZ0of6Yua+FGe3fSAHdD
	iy+02lKmfcoMzlpjffcBchsf6DwSBi+jnOoFzZRFjPbJ6aqOqoVXiX7coPfsQeyngKiKNqmvolW
	9md6Dffl49459daNm
X-Received: by 2002:a05:620a:44c3:b0:76e:f686:cad8 with SMTP id y3-20020a05620a44c300b0076ef686cad8mr7244563qkp.13.1694613613044;
        Wed, 13 Sep 2023 07:00:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEfk9vTwiioPzhJO0D1j6+0LQmPdk1mn8JxTGfaPUXi0LyXZ0YuCSf940L14zsRR6mW81HaUA==
X-Received: by 2002:a05:620a:44c3:b0:76e:f686:cad8 with SMTP id y3-20020a05620a44c300b0076ef686cad8mr7244535qkp.13.1694613612753;
        Wed, 13 Sep 2023 07:00:12 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id u9-20020a0cf1c9000000b00653589babcbsm4456536qvl.87.2023.09.13.07.00.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Sep 2023 07:00:11 -0700 (PDT)
Message-ID: <bed381a8-7d3d-d596-bc88-6ff8a7a5a33b@redhat.com>
Date: Wed, 13 Sep 2023 16:00:08 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v2] vhost: Allow null msg.size on VHOST_IOTLB_INVALIDATE
To: eric.auger.pro@gmail.com, elic@nvidia.com, mail@anirudhrb.com,
 jasowang@redhat.com, mst@redhat.com, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, netdev@vger.kernel.org,
 virtualization@lists.linux-foundation.org, kvmarm@lists.linux.dev
Cc: stable@vger.kernel.org
References: <20230824093722.249291-1-eric.auger@redhat.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20230824093722.249291-1-eric.auger@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

On 8/24/23 11:37, Eric Auger wrote:
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

Gentle ping for this fix? Any other comments besides Jason's A-b?

Best Regards

Eric
>
> ---
> v1 -> v2:
> - Added Cc stable and Jason's Acked-by
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

