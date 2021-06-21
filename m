Return-Path: <SRS0=rYk4=LP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0A1DC4743C
	for <kvmarm@archiver.kernel.org>; Mon, 21 Jun 2021 12:44:42 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6AD9C61026
	for <kvmarm@archiver.kernel.org>; Mon, 21 Jun 2021 12:44:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6AD9C61026
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CA7174079A;
	Mon, 21 Jun 2021 08:44:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3wbmSpYujA5l; Mon, 21 Jun 2021 08:44:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A385B40463;
	Mon, 21 Jun 2021 08:44:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AB3E8402BD
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Jun 2021 08:44:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jIJ4GrRLtf1g for <kvmarm@lists.cs.columbia.edu>;
 Mon, 21 Jun 2021 08:44:38 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7504B40256
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Jun 2021 08:44:38 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1624279478;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=xY6nAdAkng/ghHrBQBfm1ZmFUpZlorDdA2kwXRZ+7xU=;
 b=IeJddnMBNzRxZYjoe8AYD16RoMkHPxOOZjzkELNuF5g1EOK8lQSpm44BC6cfjprN4SxDzU
 SefAExNb9XCdWGTfrOBjLck3bM8ni2OrYCX75znUwJrPK0njt6ReISxwaUqq/wHT4aFV79
 906UwvAWHE4Udo6BJa7wt0b5/0LNA74=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-307-r6twNxJLNteyBToP3MBQPw-1; Mon, 21 Jun 2021 08:44:37 -0400
X-MC-Unique: r6twNxJLNteyBToP3MBQPw-1
Received: by mail-wr1-f69.google.com with SMTP id
 u16-20020a5d51500000b029011a6a17cf62so8035163wrt.13
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Jun 2021 05:44:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:reply-to:subject:to:references:from:message-id
 :date:user-agent:mime-version:in-reply-to:content-transfer-encoding
 :content-language;
 bh=xY6nAdAkng/ghHrBQBfm1ZmFUpZlorDdA2kwXRZ+7xU=;
 b=kgAaQ7oOXbA78xVdikFhpOXJlO15QT1FnYMyTVyI9KAnEFOX6XGuUkwem/1sT00vvD
 ooxs77vKNE7bfL69oF7eaxNg23Lrrfu/eARjkchXcWday0UT7gPB/EbYh+RBycg6tTqV
 WHrJsyBbDOYaFAqFRw/cQEgYgj1Pp3seiQKQxne//JPjztr5e9ZAo1hH8KpgeuLMks1R
 QydoslFN8OVEvWDTe6gGQcRQCeEeOj31BRyImGd9AmZTfmRJcUEpBw2R4w73Pp6Mdomu
 08MXGYWKzaeE6KLZ/2PKYElozpJw/UUTuEQBnnU/6EDAR+zRHGA7LzC2rBPz/nwEWTiU
 3uNQ==
X-Gm-Message-State: AOAM533qIkA+sxbBcMiYsdOmt98qjH/Gw8AkfsFnR70EfDQ1gweijJS7
 vGsVjg2HN9mb8ptOjQ0dRC9SyQqeGAfhd1Nxk1W5JcDjsCjcfYQe8CuIhfmJ0lD6VEhwFNu7eap
 c6cntKyxEElj8jfDQe9yt5QZs8mr1aM1fWYlOyw/gd9nIbQp/b6QaUR0Tb4aPPCeXojXa2f3wsF
 xKNek=
X-Received: by 2002:a5d:47af:: with SMTP id 15mr27383128wrb.289.1624279475199; 
 Mon, 21 Jun 2021 05:44:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyiQHL5PA0rXiLB9N/4Ymzd355PSqLCUCP+mLc4znMmOdX5sFeuYsZH8JOoThSHcMZrCXCncg==
X-Received: by 2002:a5d:47af:: with SMTP id 15mr27383108wrb.289.1624279475043; 
 Mon, 21 Jun 2021 05:44:35 -0700 (PDT)
Received: from [192.168.43.95] ([37.173.110.237])
 by smtp.gmail.com with ESMTPSA id r1sm716931wmn.10.2021.06.21.05.44.34
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 21 Jun 2021 05:44:34 -0700 (PDT)
Subject: Re: [PATCH] KVM: arm/arm64: Fix KVM_VGIC_V3_ADDR_TYPE_REDIST read
To: eric.auger.pro@gmail.com, stable@vger.kernel.org, maz@kernel.org,
 linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu
References: <20210621121839.792649-1-eric.auger@redhat.com>
From: Eric Auger <eric.auger@redhat.com>
Message-ID: <495e1326-14aa-7d7e-abf4-1054978c8de2@redhat.com>
Date: Mon, 21 Jun 2021 14:44:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210621121839.792649-1-eric.auger@redhat.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=eric.auger@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
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

On 6/21/21 2:18 PM, Eric Auger wrote:
> When reading the base address of the a REDIST region
> through KVM_VGIC_V3_ADDR_TYPE_REDIST we expect the
> redistributor region list to be populated with a single
> element.
>
> However list_first_entry() expects the list to be non empty.
> Instead we should use list_first_entry_or_null which effectively
> returns NULL if the list is empty.
>
> Fixes: dbd9733ab674 ("KVM: arm/arm64: Replace the single rdist region by a list")
> Cc: <Stable@vger.kernel.org> # v4.19
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> Reported-by: Gavin Shan <gshan@redhat.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Link: https://lore.kernel.org/r/20210412150034.29185-1-eric.auger@redhat.com

so I have resent with the [PATCH for-stable-4.19] prefix.
Please ignore that patch and sorry for the mess.

Thanks

Eric
> ---
>  virt/kvm/arm/vgic/vgic-kvm-device.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/virt/kvm/arm/vgic/vgic-kvm-device.c b/virt/kvm/arm/vgic/vgic-kvm-device.c
> index 6ada2432e37c..71d92096776e 100644
> --- a/virt/kvm/arm/vgic/vgic-kvm-device.c
> +++ b/virt/kvm/arm/vgic/vgic-kvm-device.c
> @@ -95,8 +95,8 @@ int kvm_vgic_addr(struct kvm *kvm, unsigned long type, u64 *addr, bool write)
>  			r = vgic_v3_set_redist_base(kvm, 0, *addr, 0);
>  			goto out;
>  		}
> -		rdreg = list_first_entry(&vgic->rd_regions,
> -					 struct vgic_redist_region, list);
> +		rdreg = list_first_entry_or_null(&vgic->rd_regions,
> +						 struct vgic_redist_region, list);
>  		if (!rdreg)
>  			addr_ptr = &undef_value;
>  		else

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
