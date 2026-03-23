Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 321FB29BDBB
	for <kvmarm@lists.linux.dev>; Mon, 23 Mar 2026 04:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774240921; cv=none; b=Ss8Vr/OAEVHIYVG3EJzZhAAnjOs3icaxZRmpH/zLylMop9mD5FWdXUr3UOhMMVSdNwekof1U/ASNe3rBn1Pt9bMvFkLa2AO64+zqBa5diO0hQphASi2p51CQq+mxc78zLfcbU8m0KzZZSCeoL8l0HfEQNf3+4TN0aM/sWpvlGIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774240921; c=relaxed/simple;
	bh=DVS68/R5TWDOz7LatH6NeVCBhR71o6dbSgRwSPCLqiA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mZ1PJnb+j3xfsx4z5xA5Xweq5zKrfc5jUUkrSYW9Q4np2rz8eK9b0jERUoH4pbMi1nNIU39Nf3mQ/r30tDVYiSzFNdcl3RnyKT8NPzp1+2MKhMh/sn56FOW5gVZz5zyqmtn+GMU2E+BQYzYtiqYrXeGm/inaxvVADGYjAXY3VJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IQh0coUv; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IQh0coUv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774240918;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bpzF/CEF7fwWVk/imLxKyu7B/chXAu6y92czDhmcd0o=;
	b=IQh0coUvxzjvf3YqDSHotoIiaBClcc1BbOWuf8lR0NBvhZhsX2BGBBfpHcojCUQmQHu1OZ
	+IVy9RON7O2GkClAfT3l0TtBAB8XVYoJC4ASMgSExOyjAl6RNAHP2NeJVk7R1KPa2bjpvr
	hZEYGLJtGBvgRz8SdlUP+11NQusM8c8=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-298-C4Xf1pvCM7iITCwVd0FPHg-1; Mon, 23 Mar 2026 00:41:56 -0400
X-MC-Unique: C4Xf1pvCM7iITCwVd0FPHg-1
X-Mimecast-MFC-AGG-ID: C4Xf1pvCM7iITCwVd0FPHg_1774240915
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-c74262a2988so11221073a12.1
        for <kvmarm@lists.linux.dev>; Sun, 22 Mar 2026 21:41:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774240915; x=1774845715;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bpzF/CEF7fwWVk/imLxKyu7B/chXAu6y92czDhmcd0o=;
        b=JKH/9Y/dcA5H+uxvGTEkdzGtsBkwJaTWMX2pckWwxSbIxd8uKF1lxfgkznaXT68YrM
         fKKEkqwAMUQ38w+IqCunAHjbmXoCk/o4scMpNCLnQaYc+o+L+cHEacnI0Q30dp2PvHyU
         vBYGsxBPzA8q5E2rVOvgDj4lXEkqPvwJ0cuAcqokuAHiBL5RXK7o2eKiXba/UKnMNhCa
         B9XSP5Wuv/zwGelsQxSCb963gF+zFEpdzA9nFXnnos/zjInzhy5l/e414NXIvZ6qk0xy
         K+sqlVskFap2kD2jAEB5C9TX/SZmepYzXXWMdNuaoddqAdOvduhuDVqGlsoilcL4mWY3
         FYLQ==
X-Forwarded-Encrypted: i=1; AJvYcCW7OJIwLsXZY8CQ6F20KQeXRRwHUYx+S0yz1eepqryPAOOV66sAlewh75ZkaKCkyF9ypen0CgI=@lists.linux.dev
X-Gm-Message-State: AOJu0YxX/38ND0lCYRWY0FOBDOBLHYG9F552uXKkWf64G5Vq6zjvNqPL
	wDiXnu3JAPVSTY549TgQG/Un2u5yU/jw20slyaWf2O7JUHXkPuywDjL8Bsj32t4/lywd97k4/hb
	jA2uMtfHCKT30BtkSbPXFkysJ2ARO7eS0U1Xxb5IJB+AMXIfIu+d8NDUPuA==
X-Gm-Gg: ATEYQzz2SclUS5O/HNQueRBUkKFuwe08ugxV++hBOpxgjhEQRh0bNqSUFRWWl63w+0w
	GGzN2ysIHG2EkJyZexMsBKDHMxw0hODy73ptnxJFG6vOXcbJ+QuxrS6KZXdp9Y6GJwLarUmmJwM
	9sGrvAuOSP4f+uu3V3N644/u8cNu67h9EjP6/53kCSgAz6o72IWtIbFVlXAwUTxwZLuOpqmlnWF
	KAMoDHxzrKlfhPlBSUkGfkeKJ6IsgSXIDkkFDc0KXM67hebSHKDism917/Beh5gnOzST3Ckv5AZ
	6Xlbe+FxqImQttiziJeObHnJr7LEFdGVSzD7xbMh5dQICYQpTGlOV4kDzZMu5DhQA+Y6iwGnFIb
	fs1xxZ0WhqGZujwHF5YefWLkTpWITcfWe9cPxoPUX6RS7K8t3a4mN6hTVuVr6NGwn
X-Received: by 2002:a05:6a00:21c4:b0:81f:52d4:a5ec with SMTP id d2e1a72fcca58-82a8c37fbfdmr9102379b3a.43.1774240915361;
        Sun, 22 Mar 2026 21:41:55 -0700 (PDT)
X-Received: by 2002:a05:6a00:21c4:b0:81f:52d4:a5ec with SMTP id d2e1a72fcca58-82a8c37fbfdmr9102343b3a.43.1774240914907;
        Sun, 22 Mar 2026 21:41:54 -0700 (PDT)
Received: from [192.168.68.51] (n175-34-8-244.mrk21.qld.optusnet.com.au. [175.34.8.244])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82b03aa9fc6sm8259697b3a.7.2026.03.22.21.41.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Mar 2026 21:41:54 -0700 (PDT)
Message-ID: <71f9ac1e-9f5a-4f12-807b-bbe0803f99e7@redhat.com>
Date: Mon, 23 Mar 2026 14:41:39 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 00/40] arm_mpam: Add KVM/arm64 and resctrl glue code
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
 zengheng4@huawei.com, linux-doc@vger.kernel.org
References: <20260313144617.3420416-1-ben.horgan@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20260313144617.3420416-1-ben.horgan@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: znK5T5ohqfOTtbq9TpFY-DU2f6klmnVakrvcVt5Rsvc_1774240915
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/14/26 12:45 AM, Ben Horgan wrote:
> This version of the mpam missing pieces series sees a couple of things
> dropped or hidden. Memory bandwith utilization with free-running counters
> is dropped in preference of just always using 'mbm_event' mode (ABMC
> emulation) which simplifies the code and allows for, in the future,
> filtering by read/write traffic. So, for the interim, there is no memory
> bandwidth utilization support. CDP is hidden behind config expert as
> remount of resctrl fs could potentially lead to out of range PARTIDs being
> used and the fix requires a change in fs/resctrl. The setting of MPAM2_EL2
> (for pkvm/nvhe) is dropped as too expensive a write for not much value.
> 
> There are a couple of 'fixes' at the start of the series which address
> problems in the base driver but are only user visible due to this series.
> 
> Changelogs in patches
> 
> Thanks for all the reviewing and testing so far. Just a bit more to get this
> over the line.
> 
> There is a small build conflict with the MPAM abmc precursors series [1], which
> alters some of the resctrl arch hooks. I will shortly be posting a respin
> of that too.
> 
> [1] https://lore.kernel.org/lkml/20260225201905.3568624-1-ben.horgan@arm.com/
> 
>  From James' cover letter:
> 
> This is the missing piece to make MPAM usable resctrl in user-space. This has
> shed its debugfs code and the read/write 'event configuration' for the monitors
> to make the series smaller.
> 
> This adds the arch code and KVM support first. I anticipate the whole thing
> going via arm64, but if goes via tip instead, the an immutable branch with those
> patches should be easy to do.
> 
> Generally the resctrl glue code works by picking what MPAM features it can expose
> from the MPAM drive, then configuring the structs that back the resctrl helpers.
> If your platform is sufficiently Xeon shaped, you should be able to get L2/L3 CPOR
> bitmaps exposed via resctrl. CSU counters work if they are on/after the L3. MBWU
> counters are considerably more hairy, and depend on hueristics around the topology,
> and a bunch of stuff trying to emulate ABMC.
> If it didn't pick what you wanted it to, please share the debug messages produced
> when enabling dynamic debug and booting with:
> | dyndbg="file mpam_resctrl.c +pl"
> 
> I've not found a platform that can test all the behaviours around the monitors,
> so this is where I'd expect the most bugs.
> 
> The MPAM spec that describes all the system and MMIO registers can be found here:
> https://developer.arm.com/documentation/ddi0598/db/?lang=en
> (Ignored the 'RETIRED' warning - that is just arm moving the documentation around.
>   This document has the best overview)
> 
> 
> Based on v7.0-rc3
> 
> The series can be retrieved from:
> https://gitlab.arm.com/linux-arm/linux-bh.git mpam_resctrl_glue_v6
> 

[...]

Retested this series on NVidia's grace-hopper machine where L3 cache partitioning
and MBW (soft) limiting worked as expected. Besides, The L3 cache monitor counters
are increased as more cache usage is observed.

Tested-by: Gavin Shan <gshan@redhat.com>

Thanks,
Gavin

