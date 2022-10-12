Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3E8CC4332F
	for <kvmarm@archiver.kernel.org>; Wed, 12 Oct 2022 20:15:02 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5DD204B239;
	Wed, 12 Oct 2022 16:15:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Ncv8t1Jr8uB6; Wed, 12 Oct 2022 16:15:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0A01B40C67;
	Wed, 12 Oct 2022 16:15:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E9F440C67
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Oct 2022 16:14:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id u3qCiKVxmisG for <kvmarm@lists.cs.columbia.edu>;
 Wed, 12 Oct 2022 16:14:57 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0A8F740C23
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Oct 2022 16:14:56 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1665605696;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=5EB/DMRCnjFi7ZgYNILnixPMhGaL5v8DVftfiPTripc=;
 b=GwNWHJtvZPTpluI647X8KveJgq/yeT3iJhQzR6v105n+f2Jl+IWZDMG7IpIgFG1Zvt54dP
 MeXZeBcVunAKvIT+fds1McUcch/gV1YB41yAUdXNjN/1/BAcLWPkg5s1kyQLibOk92q74W
 iM0df+Ww67MuDO8qixMXHjedo84M5VM=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-73-reJWS8u8MmCRyLDN4rpqhw-1; Wed, 12 Oct 2022 16:14:55 -0400
X-MC-Unique: reJWS8u8MmCRyLDN4rpqhw-1
Received: by mail-qt1-f199.google.com with SMTP id
 b12-20020a05622a020c00b003983950639bso7961256qtx.16
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Oct 2022 13:14:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:reply-to:user-agent:mime-version:date
 :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=5EB/DMRCnjFi7ZgYNILnixPMhGaL5v8DVftfiPTripc=;
 b=bZu3PTxxF3RyqfrS47aQAv6uux7GUHCwDMU1IPL44z/2nfx5w2665LAbgV6urM5le1
 z7jih/6Yepnl08BZl0HZoABdJL3Zo6Dxf0hxZ76yvfKXCRYkrF4P+9giKkv2cfmHNo+3
 S/0bLlf50bO8Lui5aWvRRTze8IEZYoTFyeMm6OJ/pkzGCusYKeaJ2+RWvytiEWfjxM4G
 zQ3A+g2x+vBh3N6kwTfT5KLFQdE5mSVkTnvtsf45xrC+8HZNB6lYqNt6KkS1CHFqd2K1
 rQm2rEd8LV9P1OCwi254JA0vlKD0iKL6S6q5Hoq/40ThuS5KcSEt207rUZjotnjmskHk
 rCZw==
X-Gm-Message-State: ACrzQf3JyEwQQpvjEW32Eir+eO3MqT1IlWHwk0GXiRKyBakLwEm9zfYL
 qPfofeLglpFdkS3g2wS3GZddParFQzrTU2vra8X1l6J+Eq85IT5R+SB1z4DD9emDVsZ45a7Z9lo
 iAIOhIX/5bAQksdDjhT9cXxIE
X-Received: by 2002:ad4:5765:0:b0:4b1:bf78:83cd with SMTP id
 r5-20020ad45765000000b004b1bf7883cdmr24119206qvx.81.1665605695062; 
 Wed, 12 Oct 2022 13:14:55 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5hELiNb2iAcZbm+u2knphj7pDvXbYgBc89xcAg9YPNU6/ZOz6A+P6uasXPuS2tZ9FVOuJUjg==
X-Received: by 2002:ad4:5765:0:b0:4b1:bf78:83cd with SMTP id
 r5-20020ad45765000000b004b1bf7883cdmr24119193qvx.81.1665605694868; 
 Wed, 12 Oct 2022 13:14:54 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874?
 ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
 by smtp.gmail.com with ESMTPSA id
 br7-20020a05620a460700b006e9b3096482sm14514681qkb.64.2022.10.12.13.14.53
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 12 Oct 2022 13:14:54 -0700 (PDT)
Message-ID: <30e5d940-8964-1ca8-1f40-45e0d8c62724@redhat.com>
Date: Wed, 12 Oct 2022 22:14:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] KVM: arm64: vgic: fix wrong loop condition in
 scan_its_table()
To: Eric Ren <renzhengeek@gmail.com>, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
References: <acd9f1643980fbd27cd22523d2d84ca7c9add84a.1665592448.git.renzhengeek@gmail.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <acd9f1643980fbd27cd22523d2d84ca7c9add84a.1665592448.git.renzhengeek@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Marc Zyngier <maz@kernel.org>
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

Hi,

On 10/12/22 18:59, Eric Ren wrote:
> Reproducer hints:
> 1. Create ARM virt VM with pxb-pcie bus which adds
>    extra host bridges, with qemu command like:
>
> ```
>   -device pxb-pcie,bus_nr=8,id=pci.x,numa_node=0,bus=pcie.0 \
>   -device pcie-root-port,..,bus=pci.x \
>   ...
>   -device pxb-pcie,bus_nr=37,id=pci.y,numa_node=1,bus=pcie.0 \
>   -device pcie-root-port,..,bus=pci.y \
>   ...
>
> ```
> 2. Perform VM migration which calls save/restore device tables.
>
> In that setup, we get a big "offset" between 2 device_ids (
> one is small, another is big), which makes unsigned "len" round
> up a big positive number, causing loop to continue exceptionally.
>
> Signed-off-by: Eric Ren <renzhengeek@gmail.com>

I fixed Marc's address and removed Christoffer's one. Please use the
scripts/get_maintainer.pl to identify the right email addresses.

Just to make sure I correctly understand, you mean len -= byte_offset
becomes negative and that is not properly reflected due to the unsigned
type. I agree we should be robust against that but doesn't it also mean
that the saved table has an issue in the first place (the offset points
to a location outside of the max size of the table)?

Thanks

Eric
> ---
>  arch/arm64/kvm/vgic/vgic-its.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
> index 24d7778d1ce6..673554ef02f9 100644
> --- a/arch/arm64/kvm/vgic/vgic-its.c
> +++ b/arch/arm64/kvm/vgic/vgic-its.c
> @@ -2141,7 +2141,7 @@ static int scan_its_table(struct vgic_its *its, gpa_t base, int size, u32 esz,
>  			  int start_id, entry_fn_t fn, void *opaque)
>  {
>  	struct kvm *kvm = its->dev->kvm;
> -	unsigned long len = size;
> +	ssize_t len = size;
>  	int id = start_id;
>  	gpa_t gpa = base;
>  	char entry[ESZ_MAX];

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
