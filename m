Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8223242925
	for <kvmarm@lists.linux.dev>; Thu, 15 Jan 2026 02:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768443199; cv=none; b=nFbUa9s7SPGKZG7R2EAyi/7/t6noHszk6778dKgTAhyD3CvqeOQppu0vAvcGjeO/JtiQUTvUAMp/Jh0P1PD7283DDkJYpPmOs+ZQpogIfos8+kIfABYI1YzmIxbq4yXycmo68DIlz4FPF7tl9jUJEOWeAtH4ASDXRnpH9HrPjiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768443199; c=relaxed/simple;
	bh=8GLGXuPs93ibDOjKWmu5Fr2kMEjgfbYxMX2KPwd+TuM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SuSUI57oH5vpXiZ0Obov4wk6ySJsoy51lFF6/1yi9v37bOsL4J3GxHDSR1Ztv4/AtCU6DifTZPmj0uJ/dmZGVGvnYwNoufXmtg/ifqjC8DQ3NzZgzoYPwPEZkshVgrFdD/jppW65NNx2NKw79+KXjn61B29N2NfbXDkSF5B42SI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hLUlIcDy; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hLUlIcDy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768443197;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Toy1ZyaLVodwPTTRmNCo/wZeyOVmB3/xwLKWz+z4Kq0=;
	b=hLUlIcDyO3z2i3trfMPWNSxYWuIyvrWuuc/Qo2CZJfyBkH8DNwZY/KKcH3vX344XMew4QB
	tXpmRnKoIpoqX4dndYm4beuw9Al1jekRTr01jNdO0LxrAuncSnDuVmjFXgyTttC2BxneAu
	rPXK9faHi5TI891zSZkBxtoRgN2inpc=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-237-pT30m6hqOvS5Y_BoDmFqxA-1; Wed, 14 Jan 2026 21:13:15 -0500
X-MC-Unique: pT30m6hqOvS5Y_BoDmFqxA-1
X-Mimecast-MFC-AGG-ID: pT30m6hqOvS5Y_BoDmFqxA_1768443194
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-34cc88eca7eso362513a91.2
        for <kvmarm@lists.linux.dev>; Wed, 14 Jan 2026 18:13:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768443194; x=1769047994;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Toy1ZyaLVodwPTTRmNCo/wZeyOVmB3/xwLKWz+z4Kq0=;
        b=JoOq66Gd86mCte4IIFhzt0aG/NGZ94YBucUCgpRafAxRByOhU2EqDnWedyYgW9aURy
         i8emMz9rA6d+f4QVtc9zuSCCRfGvGW0nWjmA5D/n2tXqadlsnYIekWIs5etjEkFA2Ey6
         Ee/jqEpegz+usUwEDCQ0Ik7V58RC6egpY8Y8vqM3IHcZrINroaVg0Jd5Ye2sd544eNuZ
         sfiY+okhQ44+VsBhbfAxiSNQv6N/eAJoqrbbDEdXRzG5wP2yffN+ub3EVUqNSU1TA/xw
         SGPve4yKaj0t7xg2+XP8IDaezy2MF0Efh6stobHe3ynladPXQmOrWiryFSSdj1ybG13d
         Q4ww==
X-Forwarded-Encrypted: i=1; AJvYcCUSttJtsc6H9k2PD8aORlcnv5BDPr8HqdwYmRrYZoG07j6L07H6cSot1e1iqlxCJRwyNPBtWkc=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzf85+O9+1Q6jfHVZSDpWKK/XZ8fhpRu+lZDSZ/AH9gO5Opuxgk
	kfiTLmXdx5/kOxDs0Jw6ID8xnbtmdjQBt5vtR1m1z+1Y5FnU1dcYLAxhOkv4E40Y0dpTXAjGx10
	I7Qv7BUrhhlcPHbtQI+Ix0Lz74nZ3/UVWyR0516w049GBIAThjB3AoMotgg==
X-Gm-Gg: AY/fxX7fA79+X+G/yjREAzvCTO5FvyT98qDShaV3vkhLbBR+tGki55rqyyAF3bIVEK+
	FpoRtAJvEbusgqvfaXbEXj9yubtnzsxnzZPrKE86YpsIZs0a/UqD9COZhNW1cYzztbbGgzJstuu
	sw7Qyqo790Mx/vjVsulhdrTsYKSCNTK+m2/ZAfj15e86sp7YulKfBTZviU9Pf5aZ6WA34damIAo
	qeRsfwhBD38enRBuB1vSAPjb0F2GOVdt2VFTYQEBJd6ZuiSY4CdOhbC5NBnYTabrQTZFTu4AZqi
	qDO0+OwCbN0c0DAcb97sGsI/SfNLa0iB4UfQyh0GEJbXDwwAbRtXm3wU0ACP85E/dAf5HAT45I5
	L89FlH6jEDyc=
X-Received: by 2002:a17:90b:3b87:b0:34a:b8e0:dd64 with SMTP id 98e67ed59e1d1-3510b08f706mr3668306a91.1.1768443194158;
        Wed, 14 Jan 2026 18:13:14 -0800 (PST)
X-Received: by 2002:a17:90b:3b87:b0:34a:b8e0:dd64 with SMTP id 98e67ed59e1d1-3510b08f706mr3668262a91.1.1768443193741;
        Wed, 14 Jan 2026 18:13:13 -0800 (PST)
Received: from [10.72.112.168] ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-352678c6a10sm574950a91.15.2026.01.14.18.13.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Jan 2026 18:13:12 -0800 (PST)
Message-ID: <aee2390d-faa8-4060-8441-9d70d6d7bc67@redhat.com>
Date: Thu, 15 Jan 2026 10:12:57 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 01/47] arm_mpam: Remove duplicate linux/srcu.h header
To: Ben Horgan <ben.horgan@arm.com>
Cc: amitsinght@marvell.com, baisheng.gao@unisoc.com,
 baolin.wang@linux.alibaba.com, carl@os.amperecomputing.com,
 dave.martin@arm.com, david@kernel.org, dfustini@baylibre.com,
 fenghuay@nvidia.com, james.morse@arm.com, jonathan.cameron@huawei.com,
 kobak@nvidia.com, lcherian@marvell.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 peternewman@google.com, punit.agrawal@oss.qualcomm.com,
 quic_jiles@quicinc.com, reinette.chatre@intel.com, rohit.mathew@arm.com,
 scott@os.amperecomputing.com, sdonthineni@nvidia.com,
 tan.shaopeng@fujitsu.com, xhao@linux.alibaba.com, catalin.marinas@arm.com,
 will@kernel.org, corbet@lwn.net, maz@kernel.org, oupton@kernel.org,
 joey.gouly@arm.com, suzuki.poulose@arm.com, kvmarm@lists.linux.dev,
 Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
 Abaci Robot <abaci@linux.alibaba.com>
References: <20260112165914.4086692-1-ben.horgan@arm.com>
 <20260112165914.4086692-2-ben.horgan@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20260112165914.4086692-2-ben.horgan@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: drBNH0A1qKLs-X40_sRfQVH6RmTVRZfVrH_hjEFUsg8_1768443194
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/13/26 12:58 AM, Ben Horgan wrote:
> From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> 
> ./drivers/resctrl/mpam_internal.h: linux/srcu.h is included more than once.
> 
> Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Closes: https://bugzilla.openanolis.cn/show_bug.cgi?id=27328
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> Acked-by: James Morse <james.morse@arm.com>
> [BH: Keep alphabetical order]
> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
> ---
>   drivers/resctrl/mpam_internal.h | 1 -
>   1 file changed, 1 deletion(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

