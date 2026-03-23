Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7749038229A
	for <kvmarm@lists.linux.dev>; Mon, 23 Mar 2026 22:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774305375; cv=none; b=jAJjjDJScrL6WwQc5DgmMe8ytiDBCP1CT9QV/pr3DCZ9DiW1l5C9zFYR+7PKNr78Xt/sqOq9GgAgzeRYEwf+pv9GjrysMAN98kbV2dnSNyn5IcMdTVXddZU3WujkIU0y46J0tQIFRijCm6WGXxjECm+Y1H2oOEqe9D1oQfzFRNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774305375; c=relaxed/simple;
	bh=92mx1vd3nTLm/qY/qEPoFQFOOxFsH3NIMvTYU/DmME0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iL19298Gtmk8zMGEzoc53YusZVe8xY7LuySsx9GGheJw8tZvDDVURXMfcx5rG5VPRn/9LDfPkiB9785OJAyxfSysXUAitCzihhLX5M/63lPewNxsx8sMaFQsYRPDPmm1oL07ENXYimjkASQU90PUIZgFv84y/WjbSvvHcXdqH9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JJ3YMXZs; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JJ3YMXZs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774305373;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lNabF40iumNbt7yuFgKTAYx+laicPNx0TXvhfX8ttWU=;
	b=JJ3YMXZsLH9NCKNEiVZ4GS5RgTfFWgntBPuq4XMLka/o/d4vbUfQC9Sz0eoBmmd51IJx5N
	Rht/bct30W2BcRLzfN4LZkTGDuOe4h5cjlwhTmkRkOzYKsaGYTuV0cwvPdEaip8R0CQXfW
	wr57QlETlwFGBIxHOCOP+tjs9VT/eAw=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-595-Ag6XzQPrOrGmhQvABVJ2DA-1; Mon, 23 Mar 2026 18:36:12 -0400
X-MC-Unique: Ag6XzQPrOrGmhQvABVJ2DA-1
X-Mimecast-MFC-AGG-ID: Ag6XzQPrOrGmhQvABVJ2DA_1774305371
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-35b96fbfc64so17320880a91.2
        for <kvmarm@lists.linux.dev>; Mon, 23 Mar 2026 15:36:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774305371; x=1774910171;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lNabF40iumNbt7yuFgKTAYx+laicPNx0TXvhfX8ttWU=;
        b=fPJYOHyjmL6QrlE7h7vfG7iRdNe4npXhPTM9TlR6LsfEJTRbdIWbliSz5Z/Gf3yqVB
         pcWQB2ibm/Yo1iK6cmTPeeHCaSHSw93kCYQIPBE4YyhySQqBW7CzV3L+d5hpcs3IvjYR
         qoRkgo1OFSMQhgyIrGnLqNC622RkJEi1A/ZETnQ7uoyz2el0Ev1BgNGhRD+TdiNlCJWz
         tcGkHj24fMb8JJWOGPG8zZIPmv9j5ebihEGxyiWR/geEfgJE1uk3TYEHLY2+sfC7fHn+
         Q5i/3KJfe/a/jVQ94KBZYuKMksdDIC7SFA5Xp2Ky/3F9ekISjNUyKc0Nnm4CO7+ETMR3
         aFLQ==
X-Forwarded-Encrypted: i=1; AJvYcCXdgirFuR7manHMXmDQJgIXxM/hf113Prkp2JAUS5FAEEBzmKqtlAQKvcPH5Cxhr+MaMX+LMy8=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw08ZwUo6s5RxWnGP9/u9TFsrgwAHIF6TVRve8odCw5zoMxW70s
	MA/M1cQ24KlTJBrTDcuETWEnDs6+vG2hrRnltr3S9yXmuk5NaYCzkWlgXjhACsHX2TdeFe+h47G
	PVmQ4LwYcXK7YCx7ZqK9V98ao/ocncHLU2Zv39QggKkiRzLBWPqm2Bfx6+w==
X-Gm-Gg: ATEYQzzE/k/BsEqKcXwsNSxJQ26IXZ4QGJMlBGCnUefLtbGpr2s2Hu5A/Fccxsah0NH
	PxjR4+eEoHFucVwvkJtk7cdXIpXIsUuEG4ihQYQXXlRH+qkHro92469o3zcMhqfrAINtReCszwd
	HdxZFZpNOCmWO+hhpyquh+iBPIDehKjxRBI90ZFbTi26+D6JfygcgysXCzjcM5H+Nk235Cfci3S
	t6wcVpVLNWNTfEHXyy0WYnIXOxjssmLDucLehYlbYGzImGArohoxPgu/7yxUgClTb8md41ZBHd8
	1tg9MGcIOcAfgU/9Rv/t2s167W4oUKWUAVEc77EBsInax/TnJbamOKoda5zx7j2D99zHaI3Kajh
	EiCDsP9G/e27+360F8E3ksjUgdy87WlhlLzSsUYTKu88Uig+6ehdyG2wO1jfCoHf+
X-Received: by 2002:a17:90b:1a91:b0:35b:929f:7e95 with SMTP id 98e67ed59e1d1-35bd2c20675mr11602586a91.4.1774305371160;
        Mon, 23 Mar 2026 15:36:11 -0700 (PDT)
X-Received: by 2002:a17:90b:1a91:b0:35b:929f:7e95 with SMTP id 98e67ed59e1d1-35bd2c20675mr11602567a91.4.1774305370690;
        Mon, 23 Mar 2026 15:36:10 -0700 (PDT)
Received: from [192.168.68.51] (n175-34-8-244.mrk21.qld.optusnet.com.au. [175.34.8.244])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35c017a161fsm139948a91.2.2026.03.23.15.35.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Mar 2026 15:36:10 -0700 (PDT)
Message-ID: <b5029581-c846-432a-837e-f02e225e2fc7@redhat.com>
Date: Tue, 24 Mar 2026 08:35:55 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 20/40] arm_mpam: resctrl: Add CDP emulation
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
 <20260313144617.3420416-21-ben.horgan@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20260313144617.3420416-21-ben.horgan@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 9zpMq4hFhgBKJ3IURieU2u2HiyGhXNXRAUtc9xKQmC4_1774305371
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/14/26 12:45 AM, Ben Horgan wrote:
> From: James Morse <james.morse@arm.com>
> 
> Intel RDT's CDP feature allows the cache to use a different control value
> depending on whether the accesses was for instruction fetch or a data
> access. MPAM's equivalent feature is the other way up: the CPU assigns a
> different partid label to traffic depending on whether it was instruction
> fetch or a data access, which causes the cache to use a different control
> value based solely on the partid.
> 
> MPAM can emulate CDP, with the side effect that the alternative partid is
> seen by all MSC, it can't be enabled per-MSC.
> 
> Add the resctrl hooks to turn this on or off. Add the helpers that match a
> closid against a task, which need to be aware that the value written to
> hardware is not the same as the one resctrl is using.
> 
> Update the 'arm64_mpam_global_default' variable the arch code uses during
> context switch to know when the per-cpu value should be used instead. Also,
> update these per-cpu values and sync the resulting mpam partid/pmg
> configuration to hardware.
> 
> resctrl can enable CDP for L2 caches, L3 caches or both. When it is enabled
> by one and not the other MPAM globally enabled CDP but hides the effect
> on the other cache resource. This hiding is possible as CPOR is the only
> supported cache control and that uses a resource bitmap; two partids with
> the same bitmap act as one.
> 
> Awkwardly, the MB controls don't implement CDP and CDP can't be hidden as
> the memory bandwidth control is a maximum per partid which can't be
> modelled with more partids. If the total maximum is used for both the data
> and instruction partids then then the maximum may be exceeded and if it is
> split in two then the one using more bandwidth will hit a lower
> limit. Hence, hide the MB controls completely if CDP is enabled for any
> resource.
> 
> Tested-by: Gavin Shan <gshan@redhat.com>
> Tested-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
> Tested-by: Peter Newman <peternewman@google.com>
> Tested-by: Zeng Heng <zengheng4@huawei.com>
> Tested-by: Punit Agrawal <punit.agrawal@oss.qualcomm.com>
> Cc: Dave Martin <Dave.Martin@arm.com>
> Cc: Amit Singh Tomar <amitsinght@marvell.com>
> Reviewed-by: Zeng Heng <zengheng4@huawei.com>
> Reviewed-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
> Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
> Signed-off-by: James Morse <james.morse@arm.com>
> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
> ---
> Changes since rfc:
> Fail cdp initialisation if there is only one partid
> Correct data/code confusion
> 
> Changes since v2:
> Don't include unused header
> 
> Changes since v3:
> Update the per-cpu values and sync to h/w
> 
> Changes since v4:
> Enable separately for L2 and L3
> Disable MB controls if CDP enabled
> Consider cdp hiding in resctrl_arch_update_one()
> 
> Changes since v5:
> Update comment on call sites
> ---
>   arch/arm64/include/asm/mpam.h   |   1 +
>   drivers/resctrl/mpam_internal.h |   1 +
>   drivers/resctrl/mpam_resctrl.c  | 122 ++++++++++++++++++++++++++++++++
>   include/linux/arm_mpam.h        |   2 +
>   4 files changed, 126 insertions(+)
> 
Reviewed-by: Gavin Shan <gshan@redhat.com>

