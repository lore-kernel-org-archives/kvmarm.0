Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D10D40EBB7
	for <kvmarm@lists.linux.dev>; Mon, 20 Jul 2026 12:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784549521; cv=none; b=oUHosUHdcpjFKW2vhbz6Nm8xrCvXaPlhmlRmhN6OZI/VIQ8oZDHIbunJWH4hRUZn6ET1t6hYF8xHaLloiXZa7bo2NE7jNqAfW2zvnoncJ42FHD8GD1LUUHjtdaUGrnyWCENbhggdbLsSqX79wDFznO6IXt3OQ4KSCOkdEytcIog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784549521; c=relaxed/simple;
	bh=CVlE4/3K2iR2edl7+jvBL4EkrKAQ8AXKb0lA5D/uevg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ttqhGWw9zRMGiTgK3pGDWrYS/PMNGaaih7BRoL/8fU+5++fdbZ9FOrdvTPgWC19BjV9aBF8QR5cPuyAXmTqBh7MWM21T5ioqg3mwde7XyRNxhFkMgJ6qvEWpDzN8QlEjrGCievsrObLYpMH+c3/BbZGziG8Au7u9OkaC+MGnQhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WfeAN1wJ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WfeAN1wJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784549518;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xd9y3mATfQIKtcIXvAkA2ABfdkCApbp+cQtC4H0DoTY=;
	b=WfeAN1wJvoHMFK3XMOgN1HyhMOqAkDp+S2IYTJDlA5lrufV/z1ZnkeG9joOD6hFEYAkqyg
	HPaQQxOngbR7UajEFE3SGhP5Uzs2dhteS5iIHxpRMdh6AI4l+jUWbBKot2Tk+N9W2GgIJJ
	uni4RCwMb4GfZAcbu+RMMTefcwvH2Kg=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-457-HkS0BDCSPL6Jg8zrK0AIYA-1; Mon, 20 Jul 2026 08:11:57 -0400
X-MC-Unique: HkS0BDCSPL6Jg8zrK0AIYA-1
X-Mimecast-MFC-AGG-ID: HkS0BDCSPL6Jg8zrK0AIYA_1784549516
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-c1670dd0f5dso684737466b.2
        for <kvmarm@lists.linux.dev>; Mon, 20 Jul 2026 05:11:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784549516; x=1785154316;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xd9y3mATfQIKtcIXvAkA2ABfdkCApbp+cQtC4H0DoTY=;
        b=GCC1MeoZ6CT8yvHG5Neb7iRlqSQJM0b+nMxFGRsvQBOnT2gb5FekOPuwZyY6ccP5Jo
         N4f5heLj0J5NAEuzYfykupcbdnGVOd33xYDY7parai72RQ7VA79QWfaH6+OR8/rwZePh
         knH6aJPR72b7fq7TizZ7dGdQ0xSTSvt7j8cHwKnADlySxZyUHxfg4oN0O4LePJ2wHPgj
         NgsH19H2t/WtfAWMKbQn9Dnx1XFsIuRTEQSHUeqGzhaMAcnxqCM4gm5kouvVBr3Tbiay
         zsbrciQ1dql7BD3+qwQVJkpQzy1n8AlmUarZmL2Bg/5Mzm+oM2nxmTrJV+30eT+kVoW/
         js2Q==
X-Forwarded-Encrypted: i=1; AHgh+RqdhhEkneyn9SI3bi0mTGRmuDE8J7JOsKTmjFQyszQR1HIEelKG1Cpn92VwAbbnmKvNdJNOVLE=@lists.linux.dev
X-Gm-Message-State: AOJu0YxgYAFmCS+hqsmLsx5Z1592YoQM53uHO0Jbq5WPkhbIspeV8kgP
	VsV+wwMtK2GUqTXo5OstoEM1UWzTQxtmAF3fPN6QsvCdqSsQCHGNd0w569haRJHxMTWMdzmBZf0
	RAE5OOpsRkrQMceAzRQyOc8wAz8YmdsXNc3+SxTDPxi6V8LE8hKsK3t48KQ==
X-Gm-Gg: AfdE7clIG372RgcmREitl78Wtk3U7Ges+5YT8/6Z5b2SZELAy9S9mWMW9hmrPDHxVTi
	AymutEtRQFpGO/S8LAPAI0m33Lrwu3tmd+g/zftLih8bUVQapnVflQfDxuklXtrGVLizcNoiA96
	94zdsOgNvLAa1U/UGPmarKX0//W9y7lS7nRMxm294+hpsSbT23ffNgzZQ2XbGjRWAR39BXafSYV
	f+RpChP90XSpcolX2NLSlpX4xsFHGn3aSZYFOS6rDHlMX3DUvr057X2nHS2DbaoVR7v7mbEjrwu
	SZWkn5S44WxHCR5Lcy5G7TACFIrC1NbnRqAykEqGMS22EP1zZXYpqbcWKC8B8BeVFgVhBUasyVO
	9GLjgOALLJwUI0aQWy+U2Dmrz4upPfeON9OWCjaq74f+AMfil
X-Received: by 2002:a17:907:9720:b0:bf0:2253:ad67 with SMTP id a640c23a62f3a-c16b482612amr577603866b.46.1784549516317;
        Mon, 20 Jul 2026 05:11:56 -0700 (PDT)
X-Received: by 2002:a17:907:9720:b0:bf0:2253:ad67 with SMTP id a640c23a62f3a-c16b482612amr577602266b.46.1784549515869;
        Mon, 20 Jul 2026 05:11:55 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c17009ae00asm447960566b.7.2026.07.20.05.11.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Jul 2026 05:11:55 -0700 (PDT)
Message-ID: <c09c55df-a79d-4ea9-a5b4-3eb4c489370f@redhat.com>
Date: Mon, 20 Jul 2026 14:11:53 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [RFC PATCH v3 01/19] target/arm/sysreg: regenerate
 cpu-sysregs.h.inc
To: Khushit Shah <khushit.shah@nutanix.com>, qemu-devel@nongnu.org,
 qemu-arm@nongnu.org, kvmarm@lists.linux.dev
Cc: cohuck@redhat.com, peter.maydell@linaro.org,
 richard.henderson@linaro.org, maz@kernel.org, oliver.upton@linux.dev,
 berrange@redhat.com, abologna@redhat.com, jdenemar@redhat.com,
 gshan@redhat.com, skolothumtho@nvidia.com, sebott@redhat.com,
 armbru@redhat.com, philmd@linaro.org, yangjinqian1@huawei.com,
 shaju.abraham@nutanix.com, mark.caveayland@nutanix.com,
 prerna.saxena@nutanix.com
References: <20260716213858.609699-1-khushit.shah@nutanix.com>
 <20260716213858.609699-2-khushit.shah@nutanix.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20260716213858.609699-2-khushit.shah@nutanix.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: yRlzTuKWaAKrlxBZ1HscCDy1ErwYs3S32I5utT8cMss_1784549516
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Khushit,

On 7/16/26 11:38 PM, Khushit Shah wrote:
> Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
> ---
>  target/arm/cpu-sysregs.h.inc | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/target/arm/cpu-sysregs.h.inc b/target/arm/cpu-sysregs.h.inc
> index 05f558610b..2188cd7be0 100644
> --- a/target/arm/cpu-sysregs.h.inc
> +++ b/target/arm/cpu-sysregs.h.inc
> @@ -19,6 +19,7 @@ DEF(ID_AA64FPFR0_EL1, 3, 0, 0, 4, 7)
>  DEF(ID_AA64ISAR0_EL1, 3, 0, 0, 6, 0)
>  DEF(ID_AA64ISAR1_EL1, 3, 0, 0, 6, 1)
>  DEF(ID_AA64ISAR2_EL1, 3, 0, 0, 6, 2)
> +DEF(ID_AA64ISAR3_EL1, 3, 0, 0, 6, 3)
Please could you send a branch. It is difficult to understand on which
code base you applied thise series as
ID_AA64ISAR3_EL1 definition is already upstream

Thanks

Eric
>  DEF(ID_AA64MMFR0_EL1, 3, 0, 0, 7, 0)
>  DEF(ID_AA64MMFR1_EL1, 3, 0, 0, 7, 1)
>  DEF(ID_AA64MMFR2_EL1, 3, 0, 0, 7, 2)

