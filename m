Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7E2725F7A5
	for <kvmarm@lists.linux.dev>; Tue, 24 Mar 2026 03:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774323847; cv=none; b=Z5FjL6MTX0ROI99YyjXOHXha7zZq4sieCj2HWi6HO7/m0FwaXzaJ2/wnArxR63HfcQmljFSjvm6CBj17rSS6jtBg+7bIMUqHRGDlCLazBnGKxAEc9oZJQDnbjmVCnYIkh0jQ3Q2l3VmVdhhGVJL+upd1Hn6ev48fNu0SRtzhc1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774323847; c=relaxed/simple;
	bh=4N9M70mrOIh0OO9rMT+OhiXTYQ/fudlY2z4WjzA3saQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TCmUdYsph/WlUNEIBsU5A1ZsY8qtV2eym78uDLF6HrR9thor0yC108MIAH6N20DwimNrYM6yaVWg3PDDgKs2XF1D8larTjTLRm8uaLtqQuIDt7JC+CquVM38rq66bsLO+gMtsGZW0gp6PJ0rPCSmlYOXBqYC9qHwIXtFxiqBTts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Z7QHDzby; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Z7QHDzby"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774323844;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=46vkEpgGwh3UWUDmy3UOMOyjg6y8cRBpPBBpbY3RHZo=;
	b=Z7QHDzbyPzWO6RU6PgFomJtv64hprEguElMO7NsphCeHJzTAi3zEHL+OzqXM/f0Mepdvav
	nPlvC39H9ie+X5WjrxJ88LtOe3Lhgn6Xz6RZqDMothsKsp+hTmJF8PUXZ1+jS2iWlLwL8r
	lKn3NGry9XhY0j1Lx4ipmSXa0xneErs=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-592-oXZyGDLHOlelroMDF6hpwQ-1; Mon, 23 Mar 2026 23:44:03 -0400
X-MC-Unique: oXZyGDLHOlelroMDF6hpwQ-1
X-Mimecast-MFC-AGG-ID: oXZyGDLHOlelroMDF6hpwQ_1774323842
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2b06395b8deso12770125ad.1
        for <kvmarm@lists.linux.dev>; Mon, 23 Mar 2026 20:44:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774323842; x=1774928642;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=46vkEpgGwh3UWUDmy3UOMOyjg6y8cRBpPBBpbY3RHZo=;
        b=UXCHyIUkoJUmyi2r++Er1OQxNKEpppquE4aK1YqPrlNHcHW4WlQt1+Pq9s5omirklz
         Hr2AFho1LabGiuyMgt6wVlAErw635HdU7vO+TGpiC8vshx5G9h44/5JktMTwGDhiERPa
         HnPLRHOYNnm2pjVtQDADYRHafdi4wGWyOLVpLsKRI9iPsqMOKXfqhYP/eo35VJBIZ4s+
         H5O9n5HP9VgrKtI1wjnWM+/+6iW86yMknALex2qKLXcz1VOxuiz9fCExVNQ8lTODQht9
         0W49VvRPtFYL9ReDzHkXobZW9JCrtiwiQfX2WegFgOJ+mxJIpGmCOtMT7rT6sX2qr+sb
         AMBQ==
X-Forwarded-Encrypted: i=1; AJvYcCVLEk4j5+Pcac6pVk10PxsueCak+XGmn5aSCNbkPoOKXLuedFp0792pV8lq/IoYGWZ+kXbYkSo=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw/Xv5r1nlLv7p+K1JZQE9LiksYDZL2vb3cXPgKdchhS3pDS7u0
	Wlyijil3KzWS1zmCZbJj03iscrBuSkASwNKSFBDGXz7vITen9WxvJlV0GexDSu0qo13i6hPljB6
	Y3jwRc28muyAbaa0vJ3yRHDf66uUseCBxfw0iQAWDo8l7O8UOk3F5VbZ9eQ==
X-Gm-Gg: ATEYQzyFvtWqHtiv6MUphzPDxtSRMZrIDBu0bny0igIMUc9qcpwjp/SIEaUMBf7Caat
	1UydEk9T8DCWowIRduCaXNrO1HlVWWx8wDvvgNmXSLWDbKd+EuvlTwuZixhh+qt4bUWL2x3+x6V
	AGefKXrAlKCRb2kq4n0je7PFQAcexvUCFX6irEC1Af6pWaHBCL0xyrpY8khMBoDwbERz8uXSczY
	0yvxHj7Rp5RUwb/EcGJRRBZ2JoaqKa5GMGRbZC9Tfvg/gmW2a4+V51v+dk7MAcX3EayVULRsPA2
	YvS3X8B3qVQZ7Vi9lLZuLZtPeA8Dbv5ukCZ9pnj62e2lGRoWoiUu/QIk7MY+J/FD/z6kuGKWery
	rK7b6iw3XKWYcsL6UCbmRZvuUsa5gm9UT2NR5hKmnUFBzlp+dujHHcZNAkLnYNTmU
X-Received: by 2002:a17:903:1a0c:b0:2b0:686a:d461 with SMTP id d9443c01a7336-2b0827b7946mr131722045ad.45.1774323842330;
        Mon, 23 Mar 2026 20:44:02 -0700 (PDT)
X-Received: by 2002:a17:903:1a0c:b0:2b0:686a:d461 with SMTP id d9443c01a7336-2b0827b7946mr131721755ad.45.1774323841960;
        Mon, 23 Mar 2026 20:44:01 -0700 (PDT)
Received: from [192.168.68.51] (n175-34-8-244.mrk21.qld.optusnet.com.au. [175.34.8.244])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b08352aea8sm162613375ad.21.2026.03.23.20.43.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Mar 2026 20:44:01 -0700 (PDT)
Message-ID: <32238136-6edc-4bab-a539-76b66f6276b0@redhat.com>
Date: Tue, 24 Mar 2026 13:43:44 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 34/40] arm_mpam: resctrl: Call resctrl_init() on
 platforms that can support resctrl
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
 <20260313144617.3420416-35-ben.horgan@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20260313144617.3420416-35-ben.horgan@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: AHrltd5_xx4YpI6S-1cINajBhYk7j6WuPo0d6d6yPjM_1774323842
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/14/26 12:46 AM, Ben Horgan wrote:
> From: James Morse <james.morse@arm.com>
> 
> Now that MPAM links against resctrl, call resctrl_init() to register the
> filesystem and setup resctrl's structures.
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
> Use for_each_mpam...
> error path tidying
> 
> Changes since v3:
> Don't consider abmc/mbwu in teardown
> ---
>   drivers/resctrl/mpam_devices.c  | 32 ++++++++++++++---
>   drivers/resctrl/mpam_internal.h |  4 +++
>   drivers/resctrl/mpam_resctrl.c  | 63 ++++++++++++++++++++++++++++++++-
>   3 files changed, 94 insertions(+), 5 deletions(-)
> 
Reviewed-by: Gavin Shan <gshan@redhat.com>

