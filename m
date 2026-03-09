Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCDC63D6F
	for <kvmarm@lists.linux.dev>; Mon,  9 Mar 2026 06:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773038747; cv=none; b=mhTi6pl7YRhEkVLjz99V+hzfC3MSS8Ehk+FoB17OYL2PPHGgxbg8oLsb2TFg2uLAz/nKQ9Lic6most8BAjS1AtueWpabT1XIMivxotsqJMqct8RC90Atbhj/WyX+zGO3ZS3Wcw/R0eYdcy0lXmA5hspICL0qViStb7rbJGPVJos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773038747; c=relaxed/simple;
	bh=QkKK4fWpumxzrhaCggneBeugGhgpEzJlB/gJYTUgD9I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CfB3yzZLJ6xt+vh2CWI7e3O82jEhI28vrBMZ4uQBn6JooClA5E1U7CLrl5iiq6ychjtg4lzohKEMrz2WS2gXVRGHcqL7RaU/oifZJrYpB9gRUh+JrpJwgnSmvGgcBh61nyem563X7sAbnFQfEJWFaqp/pOW62iDWABZHsI21tPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hRfAZg0K; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hRfAZg0K"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773038745;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=30KVmZahPHcWNSCxYdF/dWg9gkm2uvgSkG/Do3sMyq0=;
	b=hRfAZg0KzfL0hZHIdUgs8HcubyCx+19UhrN6TamvkmC5bS9lzXNWlkpTq4b75AL3KN0us6
	eoQtyh3alijIYm5eUeGRe+ygBMMzjncjbax57D1F0lH//F5Y4Hn0farCTFJza+NiRFrm76
	itvnghQLt4mSDOA8PiWgMxnBXjIyNIQ=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-662-uCvA00IqPRSVAlYlxOCCoQ-1; Mon, 09 Mar 2026 02:45:43 -0400
X-MC-Unique: uCvA00IqPRSVAlYlxOCCoQ-1
X-Mimecast-MFC-AGG-ID: uCvA00IqPRSVAlYlxOCCoQ_1773038743
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-359887aece0so8366956a91.1
        for <kvmarm@lists.linux.dev>; Sun, 08 Mar 2026 23:45:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773038743; x=1773643543;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=30KVmZahPHcWNSCxYdF/dWg9gkm2uvgSkG/Do3sMyq0=;
        b=PKELhKaCftP8liOmoW1cxImSa9K4k6+I+oNUh316VWT+TWdna4Ikmhlvt5K7cEuboQ
         k0nCA4LT9XEN/N7YQoqJz3L5M/h2Gn86kWlOiumGr9NQv96p27AtNuwFejLk1L4rGslp
         uconbHG4LZj31RugIQg0lyV+VzcCnUk4HrwGvxH2H6Y5YsfL/kN4IxYRYOU55SElz2sJ
         UkCmn7kCtZndv9dd0EGbLKXXQceTj/YAz4PElxzsNR03EEHmmQslfDZsAvn2HA+b3HC8
         dUtFWw4oRssQBfh3v2RidI0JkE/WIbd+KBHoA7qo44A7cR0Q/8/C/mxD7ocxQaf6YIia
         OPNw==
X-Forwarded-Encrypted: i=1; AJvYcCX21cg63a9ev01QziJ+2BjmyGxDJ18+2f3tO7GRoCSjoos0eI4gTXy8+rM2AiJP/lJHb2eLQOw=@lists.linux.dev
X-Gm-Message-State: AOJu0YyqDHQ5DCw8un6qjKX7LaycTNOANskDbWxjoa1o1y3pwJ+aD9m9
	LJhS4YvliTJQxsy9rxlxisrTgD2zGEoWj6zvCHyOI2dGVr1nM4OG1C3HdXGGjP+guzCEydWYCrM
	ZHgQwYwLjOFgCH+VlAUcV7qFC9Mi1M4uCs5B/KH2wpi6pVlk85uH11wONbQ==
X-Gm-Gg: ATEYQzzJVgW6mz/v05EDzoP59o0LpVmmNmSvX7AdxS638TRaFArzRtVR8b4++Mb9w0X
	0CJ6q9tVPbpC6hq6gtFGa8MRvx0zsyucP5emMJRzC8Crz2KZSJSy+iDLnRatH05156IER15uAqn
	8zf9VEPv89/OaNyDpOjamAiE3IoCkkBYaN2VcV4eINFPXeivK1eMd8EePGZ3pyADrjJpqZGm7kQ
	QZEGuub6GtUxlnKbtRRWQO+5dCun6q9pL5zMTWnVY6r0aAXOXAj8MY8pzxQVqZFE5vUV6Ah+9bS
	ZdxrXMwpLF8Yf79FdYiDhxNHWEY42mgEp/jrn4Hc5JXFvnOxWLBvHhrc1Uk3Druk39WjMTGFTxv
	T9RyKp1rm6MYOxx9CU9o4XTOx2VzKEpL+C9zc+z6RYZV9bP2S22DaprvIH91/rL8d
X-Received: by 2002:a17:90a:fc45:b0:359:9224:6c26 with SMTP id 98e67ed59e1d1-359be238ec4mr9680083a91.3.1773038742758;
        Sun, 08 Mar 2026 23:45:42 -0700 (PDT)
X-Received: by 2002:a17:90a:fc45:b0:359:9224:6c26 with SMTP id 98e67ed59e1d1-359be238ec4mr9680051a91.3.1773038742409;
        Sun, 08 Mar 2026 23:45:42 -0700 (PDT)
Received: from [192.168.68.51] (n175-34-8-244.mrk21.qld.optusnet.com.au. [175.34.8.244])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-359b2e0e1aasm16842789a91.15.2026.03.08.23.45.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 Mar 2026 23:45:41 -0700 (PDT)
Message-ID: <d4cef1f4-5329-4f0a-a951-7c23716ee78f@redhat.com>
Date: Mon, 9 Mar 2026 16:45:24 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 11/41] KVM: arm64: Force guest EL1 to use user-space's
 partid configuration
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
References: <20260224175720.2663924-1-ben.horgan@arm.com>
 <20260224175720.2663924-12-ben.horgan@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20260224175720.2663924-12-ben.horgan@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: PCb7RvTtMZiuo_yLT12ZwQBXbMZiacWzEK_hlTYk22A_1773038743
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/25/26 3:56 AM, Ben Horgan wrote:
> From: James Morse <james.morse@arm.com>
> 
> While we trap the guest's attempts to read/write the MPAM control
> registers, the hardware continues to use them. Guest-EL0 uses KVM's
> user-space's configuration, as the value is left in the register, and
> guest-EL1 uses either the host kernel's configuration, or in the case of
> VHE, the UNKNOWN reset value of MPAM1_EL1.
> 
> We want to force the guest-EL1 to use KVM's user-space's MPAM
> configuration. On nVHE rely on MPAM0_EL1 and MPAM1_EL1 always being
> programmed the same and on VHE copy MPAM0_EL1 into the guest's
> MPAM1_EL1. There is no need to restore as this is out of context once TGE
> is set.
> 
> Tested-by: Gavin Shan <gshan@redhat.com>
> Tested-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
> Tested-by: Peter Newman <peternewman@google.com>
> Tested-by: Zeng Heng <zengheng4@huawei.com>
> Reviewed-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
> Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
> Signed-off-by: James Morse <james.morse@arm.com>
> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
> ---
> Changes since rfc:
> Drop the unneeded __mpam_guest_load() in nvhre and the MPAM1_EL1 save restore
> Defer EL2 handling until next patch
> 
> Changes since v2:
> Use mask (Oliver)
> 
> Changes since v4:
> Explicitly set the mpam enable bit
> ---
>   arch/arm64/kvm/hyp/vhe/sysreg-sr.c | 16 ++++++++++++++++
>   1 file changed, 16 insertions(+)
> 
Reviewed-by: Gavin Shan <gshan@redhat.com>

