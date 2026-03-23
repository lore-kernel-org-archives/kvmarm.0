Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56986238D52
	for <kvmarm@lists.linux.dev>; Mon, 23 Mar 2026 23:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774307456; cv=none; b=p5oN2cjIi2/IDdmn1PcDepM9IDUKfYUxjIvEWRlbrYh3zFaV/eE2YE3A1CHPFLdv57vKuPYCRpIOiEbVOug/ZLDh0xrqKP2wqiDU6C+SB5gIEVwnElPxnCH9jP1kRKZiu4RE/b307JKR6Tq+DXds6xIzS+0k4rVWFOzS4XunP1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774307456; c=relaxed/simple;
	bh=AZ9TpcvA7JbHmddDEEW46nc8M9aYhe0GaeJO6Vw0r3Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jW42uKXvtfWy5q5egEghik6xANB/mQujSe6BL5N2xZPD2n5TllAmo8MW8uxTYH8p7ogK4UYEuq8vH75o+brgLUDJYhxE2a8JuC8VAWR5oI2un9XC1fQx/We54W3SvX9b8QyxhkEBBM8DkD4tg9TMA5Dhuliy+g5TwDTtt1iiZR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aaIAPh/M; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aaIAPh/M"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774307454;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NL7u0uXFVbBow0LkO2mREfC0sqBnGNJGi0Yb4KYOjHE=;
	b=aaIAPh/MELGyimEx+iqcfohCqM8zV+bSFNacE4HX3hMrOuFwKq96qIfArXwHEjmkSZjw1c
	/LIM3epZBAbEt8UuzxJJ99e1SU3eN8rbX08giBTGOcmARigN6EW8WaGN5Qlo7QK6iASdz0
	/Y5sKOLOGllBszHBV6U9vxyYdwuNeXc=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-395-ykQGwYKvNjmng3IUuLr7Ow-1; Mon, 23 Mar 2026 19:10:53 -0400
X-MC-Unique: ykQGwYKvNjmng3IUuLr7Ow-1
X-Mimecast-MFC-AGG-ID: ykQGwYKvNjmng3IUuLr7Ow_1774307452
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2b0554888cfso9181575ad.3
        for <kvmarm@lists.linux.dev>; Mon, 23 Mar 2026 16:10:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774307452; x=1774912252;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NL7u0uXFVbBow0LkO2mREfC0sqBnGNJGi0Yb4KYOjHE=;
        b=cF607XY9Z5egVjKVZwFZnK1UP7oDHQ1omawkaSWqbh2PTPXWZyMdqjqJfyou103lue
         fjhERGb0kaLubNHryUVYRggpQwQOkWDgNpOhqf264EhnuXX7aouy8epEMfY7Y7yYxQJs
         5UWdpWfMqLBfsw21dtQ7WaMkFrEmeEbYVxK7RbYG+vqvuoFX1ru4FnucZbU7/688grkO
         xv8efc++0V0m3HPe4FzpMjmav4QX0Wrrcnb9A6nNQN2/pkq042WjIDt396vmgdLbxPhZ
         UoT2zFv3vv83H4gsTRDpRvgkO8qarhEX3QNcAZfqF4KnFXWXkmtQFR43l/J2xUaR4MAs
         a2DA==
X-Forwarded-Encrypted: i=1; AJvYcCUhWCayvN26MjYqL1e0DAiHIDuEXgybibq2VTZ+SljBDv9juufx/eZbXjUO7heZvD5B+Xu2iNw=@lists.linux.dev
X-Gm-Message-State: AOJu0YwddhQiiPjpMcgT4kbotoluo4t84GDge+YmDIKP3y3Ug5HjRf+Z
	yd1BryLZz/OgTsiZ4vFkXNPoA/JKCOTIKmyv85oQtJnuMHixjj6zZffBgLdFXghQJfATs5wCE8v
	wGsu+RV5Po5JHluVIGlIW594FnIQjkNlZNZruoUQxD/Z/XQwQU1qte9DcdA==
X-Gm-Gg: ATEYQzx7Wi0ZJJ1YpKKSAKnm8CGKOTRdi7FQ3mDSg/P+2wk1HeO3a1fRV5rOCBC4Jed
	ibzV7Pv8iuXnHmUzVCVHLufQeKsL6x9ro5NoFQJuSNS1OFJziEBWpszqCHB0k73P1/m7+q1Iw/X
	+myuEbJRH9lF43M7oqY2m2kM4Y0ny1EebfOOmhuku/Ct9w/Lzkqxhwaeg4gQ6MZtl9g3euu1+lp
	JSVeB5Q0MqZ+d3YUcvBnEF6l27A58wS8RsCsX2K+6Cv7U6lq0K/dDZV/UM+23PC8P66YKQuU93C
	6jKKOKwW1uXyXpqFIS58IqOmfATykL+sVJK/XNCAIVOshj65LBRcA+6QlgzFUZ9AinAOTGhixAq
	SBuMjw2z/xwAmQwNQtzwrI0GdGcZD8RcFIfsyrXBdEbffIrHGouPOF5/2/B8yhSpQ
X-Received: by 2002:a17:903:41cf:b0:2b0:6d56:8d29 with SMTP id d9443c01a7336-2b08278b258mr140241765ad.32.1774307452084;
        Mon, 23 Mar 2026 16:10:52 -0700 (PDT)
X-Received: by 2002:a17:903:41cf:b0:2b0:6d56:8d29 with SMTP id d9443c01a7336-2b08278b258mr140241545ad.32.1774307451710;
        Mon, 23 Mar 2026 16:10:51 -0700 (PDT)
Received: from [192.168.68.51] (n175-34-8-244.mrk21.qld.optusnet.com.au. [175.34.8.244])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b083656b51sm152188685ad.54.2026.03.23.16.10.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Mar 2026 16:10:51 -0700 (PDT)
Message-ID: <ea39c13c-56d2-4f9e-b427-085b32720e40@redhat.com>
Date: Tue, 24 Mar 2026 09:10:34 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 26/40] arm_mpam: resctrl: Add kunit test for control
 format conversions
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
 <20260313144617.3420416-27-ben.horgan@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20260313144617.3420416-27-ben.horgan@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: GRLl8zd5LzWl9WMXYKUHvLXP7beAOuiSjt2s4T-7w9Y_1774307452
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/14/26 12:46 AM, Ben Horgan wrote:
> From: Dave Martin <Dave.Martin@arm.com>
> 
> resctrl specifies the format of the control schemes, and these don't match
> the hardware.
> 
> Some of the conversions are a bit hairy - add some kunit tests.
> 
> Tested-by: Gavin Shan <gshan@redhat.com>
> Tested-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
> Tested-by: Peter Newman <peternewman@google.com>
> Tested-by: Zeng Heng <zengheng4@huawei.com>
> Tested-by: Punit Agrawal <punit.agrawal@oss.qualcomm.com>
> Reviewed-by: Zeng Heng <zengheng4@huawei.com>
> Reviewed-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
> Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
> Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> [morse: squashed enough of Dave's fixes in here that it's his patch now!]
> Signed-off-by: James Morse <james.morse@arm.com>
> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
> ---
> Changes since v2:
> Include additional values from the latest spec
> ---
>   drivers/resctrl/mpam_resctrl.c      |   4 +
>   drivers/resctrl/test_mpam_resctrl.c | 315 ++++++++++++++++++++++++++++
>   2 files changed, 319 insertions(+)
>   create mode 100644 drivers/resctrl/test_mpam_resctrl.c
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

