Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32A833AD515
	for <kvmarm@lists.linux.dev>; Thu, 24 Sep 2026 11:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790250471; cv=none; b=Th2G+asKwyLYL0tls3Casp3wx4p7vXSTZo/Y69IsT+e+EJZg+zgbic28LSfX89irudFuN2tR5MZ8KUxcTnt0+0T/ePVP40t3UUrN7uUVBRfKSVDuUkfnNC/DuJi/tcQ1jfi8OFn5q71giq2hpaNegvcOzALj+Rb/Bjx4HGDK/Nw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790250471; c=relaxed/simple;
	bh=zFEpJJW2Ygnswic7m+wgOQUXXnuzXBT68x93F9YM8Dk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AtDSW+SVI/mP52jqctuWj5I9EvxSH/kYFbYdIL91LZanlWlqAWnM8I/DaMo3CYWp6bPMsABg1/K40GR7RkdVnus66FdbJfH+sETQCoYKiMOETlxJ1EgooOCreKzIZpCd3Mtw6lupFODtDPR8QyD+BZ43U3BLDe6+Sk/woZCwKy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fKKQmUyI; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fKKQmUyI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790250469;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zFEpJJW2Ygnswic7m+wgOQUXXnuzXBT68x93F9YM8Dk=;
	b=fKKQmUyILl+qlW3zZBR61Vmj3x6WPMjc5cuV9iU2RhC19UDmm+a0dvY8D5poQSKLn6RZp1
	m+uo0oj+G4XC2Fzg5YFxk3pT/xrGkx4RQtJCuAAfXcqIZTmlgI8g7IgojSuXZaApGiAQdL
	GFTNLVWOyhC9YaJZi4hSsEvBgpzPg7Y=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-76-dIj7yPiINsSVkuX3tyWYBw-1; Thu, 24 Sep 2026 07:47:46 -0400
X-MC-Unique: dIj7yPiINsSVkuX3tyWYBw-1
X-Mimecast-MFC-AGG-ID: dIj7yPiINsSVkuX3tyWYBw_1790250465
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-486f3c0d896so988690f8f.3
        for <kvmarm@lists.linux.dev>; Thu, 24 Sep 2026 04:47:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790250465; x=1790855265;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zFEpJJW2Ygnswic7m+wgOQUXXnuzXBT68x93F9YM8Dk=;
        b=v6f+7AMOXJ1zqdnjdX6+YxO2t8LzDpso+7G3s5+MXqCuTt0F3bfVamB4rOQSRfKc/f
         SIlR1RF//o2qQ3/APeeSuJxtJnvPWqyc/yl2jiCuA+CODFqfcHuzN4hJ+tjd41mZk/K6
         MSLnIgmebeQinB1f8fSSf57zm3AGroL7SRztyivwxzrUnA/oOCuXOWEUfd6CX+Epq+a9
         GXT0hEH3xrTZWylpj4UWPCkR4i+Q7wur3BYXxp1WU5St4PDMTRNvaemqoF4Ssot2kqbl
         KbjcfmssRK7JsewhFwCsvDOeGY+/TLbAS5IGD6aaKdu0oLuIWHXTPGhQXTVjBbo+auum
         OJEw==
X-Forwarded-Encrypted: i=1; AKwUvBydYFozyMly3OXqCUHvcWU/FH0ts1kzDYjL+DgMVZxgkLltyBiTQEJmLOIG2wpGAxYBs3Po7o0=@lists.linux.dev
X-Gm-Message-State: AFuF++mSrxcI0rJ2AS5pIX78LiqZx4ue2ufyUbrMyUnER451GJTeJOK1
	s64AueOJx9uh5R7y+bFcsjL+Pn0eyd/AHRkaHXc5wQp7I7M5b1yEWAHsHw68Vsy7gC4bsGZf0bM
	EUkkvA0cVCrg4dt7lMOLI5fXWa4tzJmx03NAhUzLQFGiDOMrH3KqXb/T/Yw==
X-Gm-Gg: AYBFou16EeECkj0vIKEft9XoTSHYXr6cuE5W+pTkuQvhV1nK47Sbp2YDtFyX2b2DyKV
	IQYwXwnVibdjfK4xN0u2OvJob8WDFI/GEiUr4MUcnIgKOJ+Q3PJzCozG7CRDwiEmysjuuENf0he
	IzIy+75GZE/0HRAmb2IlL7hYVfLzJThtA+kaB1x2bsDvPM+5ze8IUMit7s7YBuT/2mYu6ouoDGu
	8HmfLNc9yGRoxMrBvWfSdu86H85xqIXCJTq5zLwRmvAeKT4OaAP/wTpB6Z9tMK+DAZDZFhE+swm
	6DvS3iaWNlJbABmIARNUEArUR7eorOlTciiUx/4854pBenjre2wj5piGIImoaIrz/3MD2cc3jIe
	rSiRnkeEYlEa1mbF6ZY3gKEsVOYu5iQPGitCdDBWPSZKpVtyP
X-Received: by 2002:a05:6000:4012:b0:487:930:8acc with SMTP id ffacd0b85a97d-488717168c1mr3343499f8f.16.1790250464703;
        Thu, 24 Sep 2026 04:47:44 -0700 (PDT)
X-Received: by 2002:a05:6000:4012:b0:487:930:8acc with SMTP id ffacd0b85a97d-488717168c1mr3343461f8f.16.1790250464334;
        Thu, 24 Sep 2026 04:47:44 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4886877c379sm13964440f8f.29.2026.09.24.04.47.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Sep 2026 04:47:43 -0700 (PDT)
Message-ID: <b32547b3-c6ac-4887-8a10-59ee84b28938@redhat.com>
Date: Thu, 24 Sep 2026 13:47:42 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [RFC PATCH v4 08/25] target/arm/kvm: handle writeback for special
 ID register fields
To: Khushit Shah <khushit.shah@nutanix.com>
Cc: "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
 "qemu-arm@nongnu.org" <qemu-arm@nongnu.org>,
 "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
 "cohuck@redhat.com" <cohuck@redhat.com>,
 "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
 "richard.henderson@linaro.org" <richard.henderson@linaro.org>,
 "maz@kernel.org" <maz@kernel.org>,
 "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
 "berrange@redhat.com" <berrange@redhat.com>,
 "abologna@redhat.com" <abologna@redhat.com>,
 "jdenemar@redhat.com" <jdenemar@redhat.com>,
 "gshan@redhat.com" <gshan@redhat.com>,
 "skolothumtho@nvidia.com" <skolothumtho@nvidia.com>,
 "sebott@redhat.com" <sebott@redhat.com>,
 "armbru@redhat.com" <armbru@redhat.com>,
 "philmd@linaro.org" <philmd@linaro.org>,
 "yangjinqian1@huawei.com" <yangjinqian1@huawei.com>,
 Shaju Abraham <shaju.abraham@nutanix.com>,
 Mark Cave-Ayland <mark.caveayland@nutanix.com>,
 "ping@khushitshah.com" <ping@khushitshah.com>,
 Sandesh Patel <sandesh.patel@nutanix.com>
References: <20260921123249.1708067-1-khushit.shah@nutanix.com>
 <20260921123249.1708067-9-khushit.shah@nutanix.com>
 <aabcb61b-8341-423f-b113-e7ab2b34c2ac@redhat.com>
 <C220B122-8B4A-43DF-A665-AF1B9DCE3734@nutanix.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <C220B122-8B4A-43DF-A665-AF1B9DCE3734@nutanix.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: UrokQTPC_0x5AF2iQnkBZLIPB5_Hm5ueUTovOxeqKBQ_1790250465
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 9/24/26 12:21 PM, Khushit Shah wrote:
>
>> On 24 Sep 2026, at 3:27 PM, Eric Auger <eric.auger@redhat.com> wrote:
>>
>> v9 has changed the way new field values are stored. writable field props
>> and non writable field props could have different setters. A non
>> writable field setter just needs to check the new value is the same as
>> the current host value. No need to record the new value in the hashtable
>> for further commitment.
> How will that work? as based on certain vCPU init options, non-writable fields will change… right?
I meant the new value does not need to be written into KVM because it
must be equal to the current value. But maybe I missed your point

Eric
>
> Warm Regards,
> Khushit

