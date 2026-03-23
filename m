Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A4F935CBCB
	for <kvmarm@lists.linux.dev>; Mon, 23 Mar 2026 06:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774248940; cv=none; b=d97v9wHYqivBoRrclSOUPX2FRPj+estPXJ6VEh5r1ex3WEGk3AzSam8agPGWfudvX7C9FKpxA/fTgBmV0v11zHUk0dLdojh7pjiS+5o4sPkIekgKJrUP758z671TzAAp222vl+MHDJqu1I/nDdlD641DMfqC0FclcvjhHkoUQJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774248940; c=relaxed/simple;
	bh=vZrXsbPeGeCkiMIqLDbuiKx8v3tlHBlMlQKRAhMixBw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ubDaAdALvEoQtPlhK9VcqylL3mQUQWN9GRuOxWXCP+jQfBUNARpgXMcdoSoiWjwdMFzh2ySiTpbu15Url2wrFgAoYcttYDjb7+NjXjI6lbWrTDNWKq3lMekhiRGdHSmwGkgdeZWDaD74no2yiIdNEKU0oSu8Ulg+DclMmEgLneI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=B6urIHW/; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="B6urIHW/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774248937;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cUFvGhq55JONPygTQtBYsqFeVViX1eQUM3HJHzaMYXs=;
	b=B6urIHW/+3iflRmXEt7qyAVYPs2w5Vkxp/0N2gI0r/kve83auUGe9hPYePS8sNRBa/sIGi
	+vgjHSexoDdZp3ChMbmMWqtCcKDrjcP2ya3psNbgEf9u56jJQyaBRSu53up+Du6h25RWgM
	KdCI3TLHYBqwoh+QAGBiKZg+KVfmvTY=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-373-nyYFgp23PYCRVxVygrRK4w-1; Mon, 23 Mar 2026 02:55:36 -0400
X-MC-Unique: nyYFgp23PYCRVxVygrRK4w-1
X-Mimecast-MFC-AGG-ID: nyYFgp23PYCRVxVygrRK4w_1774248936
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-c7385a1476aso2851177a12.2
        for <kvmarm@lists.linux.dev>; Sun, 22 Mar 2026 23:55:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774248935; x=1774853735;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cUFvGhq55JONPygTQtBYsqFeVViX1eQUM3HJHzaMYXs=;
        b=WsSYVAr9pP0ALmqIdicqvp1pW8egjRu8676iL80YcxZHt/Cm01QWkwONGEEY+i8Kja
         Q+Cdlu59aERHkRVTwpWpFreFIl9yQwTjR7cJXX35b6AJz3mD7szcaIf7MHVBgVZevHvP
         uAzTR+6wzM0tkEtNoXMM7ZyF2c0EvXpxxF+Ym99hGIYC+V7X4dy2sg3GGyYvceFuMCrd
         rhzR2ywUSeF1w9krAAJOeeTlL+YgzQakC5gZTAmsuBrqKnRgzuvbQqdrcTRqS2lfJ98b
         eXYI+wVu3pihfAO1SwHpOlouZWmRpH4CAeaoWsgxmHBiOVkrmvdRE6xZ/8z3U9pXXUam
         fVIA==
X-Forwarded-Encrypted: i=1; AJvYcCXD1K6+zAqLTsYEGepRGL/SGJVdJLT6fbk7pcy5JSWsrWSB/jpFHaIU7TDFNyRv+sQGfiQnlRc=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx+GUP1+fILYKrfTF6M2ag+07eerehOb7A6KT82tU/g7SMkQFjZ
	gS9PbZwTV2m0hGDXGmghAd4bX6kH73wmmzDzrnT0ytjde78fUelV3d4Vi4mqNQ5KbywCIn7ym3O
	7/xdmFqAQUaPLQumMe1ylDfR44OhMBnO3T7FjgLrDOSfsTkY4y216+/xt6A==
X-Gm-Gg: ATEYQzxhrDI7qVsz3Mjo2+Lwar2gbmSd+WIsC7CJE1cBEqQC+VZ2R5IE7Pf6/0+3OWL
	NXPO9dj9KCmbOUsHSVGIiB3S6KPq7F4t9cSPCmA9fmSlX26EthlExfVa/p/J0f3WYXk0ki+HzHB
	MmbTOOdRpCrG6P6GBuWKXVdH6RjW107XOAoWL3iLDYaWGqTYyl6AMivUJS2iu9H8rWgSgFCiK9u
	5OJrf5VQTKv3++zRCSdYi27r7spY6eRH3mpTPTDeMdb+SXEra6seve5c7NV3tBNdFYw1Qu4O7+2
	j5Enmn6V5j0jfnA0quI8bqf1q38YckOlOjkTNBpIN3jHeLVh0TYiUbqI5idFyQr/qekIaOcqP2I
	jYOV8zdtvLxYrueI0dsu9zuayllbFKyEESfnCbIuvjxIbUdFi3otJPJ2daunwiZTd
X-Received: by 2002:a05:6a21:3286:b0:398:7e12:c03b with SMTP id adf61e73a8af0-39bceb41272mr9670981637.44.1774248935566;
        Sun, 22 Mar 2026 23:55:35 -0700 (PDT)
X-Received: by 2002:a05:6a21:3286:b0:398:7e12:c03b with SMTP id adf61e73a8af0-39bceb41272mr9670964637.44.1774248935151;
        Sun, 22 Mar 2026 23:55:35 -0700 (PDT)
Received: from [192.168.68.51] (n175-34-8-244.mrk21.qld.optusnet.com.au. [175.34.8.244])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c743a7ff529sm6924198a12.2.2026.03.22.23.55.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Mar 2026 23:55:34 -0700 (PDT)
Message-ID: <670cca31-ef2b-4fd8-89ad-221526a07f7e@redhat.com>
Date: Mon, 23 Mar 2026 16:55:17 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 19/40] arm_mpam: resctrl: Add plumbing against arm64
 task and cpu hooks
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
 zengheng4@huawei.com, linux-doc@vger.kernel.org,
 Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
References: <20260313144617.3420416-1-ben.horgan@arm.com>
 <20260313144617.3420416-20-ben.horgan@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20260313144617.3420416-20-ben.horgan@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: jb-F5sNoBz_M-2HEBMwKWovSib1LJKNM-_XuspvPGLQ_1774248936
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/14/26 12:45 AM, Ben Horgan wrote:
> From: James Morse <james.morse@arm.com>
> 
> arm64 provides helpers for changing a task's and a cpu's mpam partid/pmg
> values.
> 
> These are used to back a number of resctrl_arch_ functions. Connect them
> up.
> 
> Tested-by: Gavin Shan <gshan@redhat.com>
> Tested-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
> Tested-by: Peter Newman <peternewman@google.com>
> Tested-by: Zeng Heng <zengheng4@huawei.com>
> Tested-by: Punit Agrawal <punit.agrawal@oss.qualcomm.com>
> Reviewed-by: Zeng Heng <zengheng4@huawei.com>
> Reviewed-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
> Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
> Signed-off-by: James Morse <james.morse@arm.com>
> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
> ---
> Changes since v2:
> apostrophes in commit message
> ---
>   drivers/resctrl/mpam_resctrl.c | 58 ++++++++++++++++++++++++++++++++++
>   include/linux/arm_mpam.h       |  5 +++
>   2 files changed, 63 insertions(+)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>


