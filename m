Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82BE737A84A
	for <kvmarm@lists.linux.dev>; Mon, 14 Sep 2026 05:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789362395; cv=none; b=XE6pIk+k7L272YhrL7ziNE+jRIFs4ajiRsnyIDtl5QMyi9mms3xhjRFqSfozRuJI7S/GQdIwD1xckggjYoMf6+URaikDFIM7SZVbMdxE8h3Pw+kxwFgX4sbxlRnkrRfj/e+bC+/4uPG8KE1GNwVsZnuKAPUNJ13qYkM5u8gNUc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789362395; c=relaxed/simple;
	bh=E9cc/135TTwNgjmAOrXJSDfGY3OksbkbWgtTU95PGtw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nlcxmAZKWCEiqdbqbeG1plqslwQu1DXJ+27XNj7GGSxWkyHYXnTYf5Lp7W/wEYCKRxxX06MP3TCcylKIGDMrNz5+9xs5sKP+tiGWiUeIAQSwfIqg+e2iQNSjwx4c0FE/C0mWuQHBSp0uZkDWBv6gfvazlMsDKg3LfuRMPBsKAG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iebbuoxf; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iebbuoxf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789362393;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CTGrNcFkd0r7wvxM+LayJdDhB/Bf4MUfRoY837NnKYo=;
	b=iebbuoxfdHNDrRrH+OPJGQsqFSlydKTpVup364qWyXRhkb7X/lCQcO5ar+8YWaXJS2Dh2B
	mur5u1MfPbUYeQTopBYcwH3uFuHjmVSWDMvje8tumZlaO6Juw4AFK8oIUs4IQ9gNRQtoHL
	hnrrK2uHXv4ggbXIlW+osooA/Rto02E=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-614-gj6KglwvNTGLuFzorsyWug-1; Mon, 14 Sep 2026 01:06:30 -0400
X-MC-Unique: gj6KglwvNTGLuFzorsyWug-1
X-Mimecast-MFC-AGG-ID: gj6KglwvNTGLuFzorsyWug_1789362389
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-cc4e496e5c3so827140a12.0
        for <kvmarm@lists.linux.dev>; Sun, 13 Sep 2026 22:06:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789362389; x=1789967189;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CTGrNcFkd0r7wvxM+LayJdDhB/Bf4MUfRoY837NnKYo=;
        b=Z8ApGtgHBsuog6vOIEg3+3CjiQGK0g5gI3jHfSxra/6WoHxA8K10ZcXRDZaECzpf/E
         Nndk5BxbiBPfHzHbv9FwNCDPGukCYgWTLl8ZeCxHYsR7SXP9zeK/A/vjp3/BtJjMKEkM
         Ws5m9UmIGlM26lWWqN0bT7Qdb4Gk+k0tg/vM0FSx6zzZh/g0uc1RyHNp1xwyG6aJm+SJ
         0/CZfd/rEFzC72vzffY64+VI5x24S+AFvoSrufZrrn9/hH2lHluXXOhSHfMiyPI2FXq2
         mudn7YEcPk/XfW6FJH5W5857y4YaRH+cbEeC2iBAzJU/8Ygg/mVIwhXTYclbAr2wiYON
         GUuA==
X-Forwarded-Encrypted: i=1; AKwUvByrgLAmq55BMjdaCV+T3u7T7YwSjAW2jn6MiI42nyOr3RC5HZuaoPfBDhSAHAM/aIO14bcH6Sc=@lists.linux.dev
X-Gm-Message-State: AFuF++l7BQ+5BOJFnBREPfeqlDet6YcXlKKYqXGb0CVoHRAIhi176W3B
	5xU7ZQqEvOCcqy8xOD8wLTdq7ygjaff4GdIJArYpXVND76yRrs81nImE0Z4+UROJLLq4AGkMIg5
	+PXD7uDrxBWmwGjbzMfTBKHzW7TLlE0suHcmtJcqPoZZcIGiM8EbC0BSPcw==
X-Gm-Gg: AYBFou2/ghjhBPSXDrp4qUouSXjeC3tf9l74Yi+D2jW5FD5Y57jkiI+oC3lJ6+EtRA/
	QWOox7YRTmwZdgMq4o/ndJleIF/5Mn9crwbzyv1EXndBsPIpjLGyhSYfsyj2/DoOUYUS+pM8pih
	TbTWvLUsw5+YmmksIAqsHhORneFHlNNHvUONKNcA3iRzA4ss5ORtPFo8+F2fUXYg9I/02vpokt2
	YjTHRvLawrvM5056jR18xTsHP8SfZGadKKrMrZ1PtBnRICFtMPqk3Qr0LqIo3V2715rgDMxnCCC
	YLmj3AKe8xLjpfT9Aq0JRYKeFnuweTZyZcxqadv00d44J2bgaSfk/s/qZs2fHb434sfeSV025S4
	EJtWruRmJlKHRGH9bmKMMmiAjv85tciopeYpKI1Gkaw==
X-Received: by 2002:a05:6a20:7290:b0:3d1:2dc5:7d37 with SMTP id adf61e73a8af0-3db4039c82cmr2007597637.3.1789362388781;
        Sun, 13 Sep 2026 22:06:28 -0700 (PDT)
X-Received: by 2002:a05:6a20:7290:b0:3d1:2dc5:7d37 with SMTP id adf61e73a8af0-3db4039c82cmr2007526637.3.1789362388369;
        Sun, 13 Sep 2026 22:06:28 -0700 (PDT)
Received: from [192.168.68.52] (n175-34-8-244.mrk21.qld.optusnet.com.au. [175.34.8.244])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc4c654b5b0sm4167221a12.13.2026.09.13.22.06.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 13 Sep 2026 22:06:27 -0700 (PDT)
Message-ID: <e15dff15-74d5-459c-98ed-0473a7761c69@redhat.com>
Date: Mon, 14 Sep 2026 15:06:15 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18 5/7] firmware: arm_rmm: Activate the RMM
To: Suzuki K Poulose <suzuki.poulose@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, catalin.marinas@arm.com,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 steven.price@arm.com, aneesh.kumar@kernel.org, oupton@kernel.org,
 joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
 linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
 sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
 WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com
References: <20260912083611.2513845-1-suzuki.poulose@arm.com>
 <20260912083611.2513845-6-suzuki.poulose@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20260912083611.2513845-6-suzuki.poulose@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 248ONMuKSfjsaxKyTn4Nd-Z1HD3ZhjpNpSWuU8RdL1E_1789362389
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/12/26 6:36 PM, Suzuki K Poulose wrote:
> From: Steven Price <steven.price@arm.com>
> 
> Activate the RMM after the basic configuration. This is a memory transferring,
> stateful operation.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
> Changes since v17:
>   * Inline RMM_ACTIVATE command and remove the definitions from arm-rmi-cmds.h
>   * Use scope-based cleanup to free sro object
> Changes since v16:
>   * Split into a new patch
> ---
>   drivers/firmware/arm_rmm/rmi.c | 14 +++++++++++++-
>   1 file changed, 13 insertions(+), 1 deletion(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

