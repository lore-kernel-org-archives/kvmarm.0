Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D8EA377EDE
	for <kvmarm@lists.linux.dev>; Tue, 24 Mar 2026 03:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774323662; cv=none; b=ltH/HMl5zs9SbXuAWxohTp4rKuoo5WtdPTYqfxyf4dAwhCRyn4u27pYCtwKYfZ154LVHsqIYvKzbf6iRG7Pt6rSFQ4Kd17WkTFYHpOU5sw8dZiomUvyTomaZs6LD5faGb+jbjtpuT3eh/QNReijf9Lovxptu+hZ6wm8sQmogHaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774323662; c=relaxed/simple;
	bh=at5qO47FiC/Sq0RzqHfPejenzE2Z8Wn2nDR43pAscRU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YSvc1kdXBqK5m6HU1xQACoydwHscQi9uEJDfm5AyS5Xn4rnOZRm5rmklW8rswcOBxD584USOx63guTqMTC/R0odX4GYHK0inDcqYMKGTKhB3kCMnrJI44iw9AgGlOBNIc4NHebE2XsSxmBKNEEYdmJfLBNsHcJT2LUTYs2ikfp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Zn4G1h6p; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Zn4G1h6p"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774323660;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LD86M66XQ6z2RDnVdKVUV2lC/ws2IdjFX4ukZlHTEIA=;
	b=Zn4G1h6pw1IDZCrFMdhPoJ9FZRsncG1dVIVvAeeWZcj8t/2xpXYWRkwHvwYtU4YNK/LsFq
	PbyL75LmwEZ6atFVRt7p+GY1A5BWI4BywnES603+1z1VJ8R79XOLUGeLPaV1YPBGws04tF
	GpNnyLhLEcxVjBuDsVxyt+DlVomAYi0=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-605-r-blGIhFP--RBYveqybRqA-1; Mon, 23 Mar 2026 23:40:58 -0400
X-MC-Unique: r-blGIhFP--RBYveqybRqA-1
X-Mimecast-MFC-AGG-ID: r-blGIhFP--RBYveqybRqA_1774323658
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-c70f19f0f37so3128164a12.0
        for <kvmarm@lists.linux.dev>; Mon, 23 Mar 2026 20:40:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774323657; x=1774928457;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LD86M66XQ6z2RDnVdKVUV2lC/ws2IdjFX4ukZlHTEIA=;
        b=br08/78nDJe4PKFJWmEBDnuNzBMmyaBdKFYVWInk6DfXZypokm3Z6MNx81TF3q2fql
         lnrukN7TcqqMZcDxBBh248cyEvsg7Rw25hkZ5LV4eBzR7zOOKRNXAQkWClSt5qWVjvNp
         apYJd57obYPND+j5ovKpJ1pZcl+jOpLJnYzGCQwJC2SK/gLNwcuyOKRvZY6BzjiiOvxg
         Kl9jYmkQf1LJ7hE2yXspGB4BZs9WeH0i9N7VX+/fEx2hQ0MCqv5OSECfExMOmUMl9kTv
         avVZ9A2HiKwO3TpppLNIvPBfBNl8x5K1lwsLbuIaNuYZ97m58siqo62d5vt9HeyVgW6W
         IwaQ==
X-Forwarded-Encrypted: i=1; AJvYcCUrp7qR7VHK4I5nILV/ZZ/APFgp/pB8t9NcjuehFW2VREWSIzLStVIHQxNWnIV2lpR4cOFRNDY=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw/8OsgK+fCFsxY11ij6wEQoF4qskTeRHFjG30pdMHgpuETh1Oc
	eFS+EZvDTsWigqq6V72J/hO+LFtGFjpmcOZi2josHP7n4ZHWpHRVj3tbCaUiInHWdGd9YLkn7xW
	6Xp/DQlulEX5Vdw6X1qyv5E+u+zOIerFVHhcaZkKLtveRGmR6+1aYFJ+FMw==
X-Gm-Gg: ATEYQzwF6bIYJrOfo0KrRjy3NxH75qR4DLtSnTmuF5BkxwWnPg+pwSHMrwC5HZhp+xV
	RLUtPu+zD+j4zzSMjkqMgLreMhmWMBImPaiCdcuCxvhRuVc73Vh2knX33q/tom7ch39Y0/mVIbj
	uLRYL+RaOeocHHSb9ETsSpouGJYz5qH1Fgj0WUi5G2DXE5XWc1bckLsrtRnty5QXxKsXtR61kET
	ET+4XYe5iq19b6HTRRyejbxKlK2iOfw+joLD1yOoTM3Wu/s2On0YUCqUuGsaKBjEMO36+T5ckzO
	efO9U79qb9yi/BBHUF1zDBUTFHJm4l+kAPiwHtOgmbKIZRBO2ZC9tHAJEelor97Go5jyC4qvmHT
	ojieCao5ibwLZqmwGUeUzfgE4iNp/TWQxQyo3an6q/7yD9CJQFJN7cvV9OzriqgDJ
X-Received: by 2002:a05:6a00:2d82:b0:82a:67ce:66de with SMTP id d2e1a72fcca58-82c5bdb0f77mr1586825b3a.14.1774323657527;
        Mon, 23 Mar 2026 20:40:57 -0700 (PDT)
X-Received: by 2002:a05:6a00:2d82:b0:82a:67ce:66de with SMTP id d2e1a72fcca58-82c5bdb0f77mr1586793b3a.14.1774323657062;
        Mon, 23 Mar 2026 20:40:57 -0700 (PDT)
Received: from [192.168.68.51] (n175-34-8-244.mrk21.qld.optusnet.com.au. [175.34.8.244])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82b0354baefsm11044528b3a.0.2026.03.23.20.40.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Mar 2026 20:40:56 -0700 (PDT)
Message-ID: <6ff8f2f2-e7b9-49a5-bbc1-3cfdc2fff4fb@redhat.com>
Date: Tue, 24 Mar 2026 13:40:41 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 28/40] arm_mpam: resctrl: Add support for csu counters
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
 <20260313144617.3420416-29-ben.horgan@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20260313144617.3420416-29-ben.horgan@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: gwwgddnFaQfS5Vbh7Jt4Z13VPUMDeQQxNp3ityTHGPU_1774323658
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/14/26 12:46 AM, Ben Horgan wrote:
> From: James Morse <james.morse@arm.com>
> 
> resctrl exposes a counter via a file named llc_occupancy. This isn't really
> a counter as its value goes up and down, this is a snapshot of the cache
> storage usage monitor.
> 
> Add some picking code which will only find an L3. The resctrl counter
> file is called llc_occupancy but we don't check it is the last one as
> it is already identified as L3.
> 
> Tested-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
> Tested-by: Zeng Heng <zengheng4@huawei.com>
> Tested-by: Punit Agrawal <punit.agrawal@oss.qualcomm.com>
> Reviewed-by: Zeng Heng <zengheng4@huawei.com>
> Reviewed-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
> Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
> Signed-off-by: James Morse <james.morse@arm.com>
> Co-developed-by: Dave Martin <dave.martin@arm.com>
> Signed-off-by: Dave Martin <dave.martin@arm.com>
> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
> ---
> Changes since rfc:
> Allow csu counters however many partid or pmg there are
> else if -> if
> reduce scope of local variables
> drop has_csu
> 
> Changes since v2:
> return -> break so works for mbwu in later patch
> add for_each_mpam_resctrl_mon
> return error from mpam_resctrl_monitor_init(). It may fail when is abmc
> allocation introduced in a later patch.
> Squashed in patch from Dave Martin:
> https://lore.kernel.org/lkml/20250820131621.54983-1-Dave.Martin@arm.com/
> 
> Changes since v3:
> resctrl_enable_mon_event() signature update
> Restrict the events considered
> num-rmid update
> Use raw_smp_processor_id()
> Tighten heuristics:
>   Make sure it is the L3
>   Please shout if this means the counters aren't exposed on any platforms
> Drop tags due to change in policy/rework
> 
> Changes since v4:
> Move generic monitor boilerplate to separate patch
> ---
>   drivers/resctrl/mpam_resctrl.c | 83 ++++++++++++++++++++++++++++++++++
>   1 file changed, 83 insertions(+)
> 
Reviewed-by: Gavin Shan <gshan@redhat.com>

