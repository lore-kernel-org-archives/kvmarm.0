Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D11635BDAA
	for <kvmarm@lists.linux.dev>; Mon, 23 Mar 2026 06:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774248501; cv=none; b=ZqMq8STSEGpxEIcduD2r51U+3G2IuJPpIDvr5LhSIwFMOzOqxaZGB27VQzVo4NM4FZbc8ZlCAZbtIwujUgQ57Zd6rQWQyOldLEBguu3dAFKIhz6XWxHzsH8gQsoa/+9s3YYMUc7q/1qqsEcgWlzbtWuTnj523Pn5505C1YI70fs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774248501; c=relaxed/simple;
	bh=qBxOceRaYDnXDlLbO5irFD7BqQZ8YGfUKwhYJ71fAPs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TPpkJZlV//3uEXo8AlxLRYJHiHWR9SmTZ9KHneOmAhkCYSrf+5sUhd8UMqKDa/iRkHz1QiPrtw72XTXF8MRnk2lQCMcc7NW1dOEV4AwqjmYkr6brhr5STjChZJE3RghqZ7O2io5Su0+zIZ0kFWIi+B9ZlBiAOydN+xjTptqFoFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=c3QJpL3N; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="c3QJpL3N"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774248499;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=A1jfkKoIoyOx8Kv10DppX+EOFqlkSt8Sl6eKNbUG7kA=;
	b=c3QJpL3NeGtEOH8s31KlQy0gLYg8Zgy0nCbCtuuL2R9aiCEObPpRsGGhWv1jdQFa+bi0zh
	wpaWH35mSvUKTRjaQnNXFpBO8Gb5o8oWMV72BtbbKlf1sDfqP8tnVG5L2Vd7RA71abwMhb
	TfMbB5WkwE6whM0uHJPcFh5dKqMJbVs=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-1-55selu8ANGGcvJ6JQv1cxg-1; Mon, 23 Mar 2026 02:48:17 -0400
X-MC-Unique: 55selu8ANGGcvJ6JQv1cxg-1
X-Mimecast-MFC-AGG-ID: 55selu8ANGGcvJ6JQv1cxg_1774248497
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-35b96fbfc64so14169984a91.2
        for <kvmarm@lists.linux.dev>; Sun, 22 Mar 2026 23:48:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774248497; x=1774853297;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=A1jfkKoIoyOx8Kv10DppX+EOFqlkSt8Sl6eKNbUG7kA=;
        b=r8vHpKrK+V5de4yH5BWzxX2bxQLtj4EgcTK8OejEFV2QYN8kRDfav88HH2WHDPHpIE
         5oYriuk2dlpE0cVKM3HBQ+i4BcgVOhXXlrfaDIqaQ8eow+tbPDfmEi1OYkiadEuw4FaF
         lgLRM70MjSMrvM/uVsZfjQAssXOKCic38fc6pa3CCCUSE19UJL8RqToETntCR3sxunU6
         7ZlfgMqiqLvUPFV3imUAceMuCVgp2NNfo5k9sAYvPm4YAC4PQ1TUlwSNEEV7Y/kAV92L
         tSWBVMNezHW6M5YyaGkz+QMSr5lhlld8GC8C4agxQFeTihckb3/nuKGEEvgU4LQbSXHB
         TizQ==
X-Forwarded-Encrypted: i=1; AJvYcCW17SvOzyXb7FoyDxn9VJenp6DBcJmd0FPfLmR6iXaPZnOtjwQbNe157JEwFwjzPAbyzIr144c=@lists.linux.dev
X-Gm-Message-State: AOJu0Yznt6Ga9fJdM8c5ggQAUKfdUf6YWlyapNQ3qQyHdznhVcgkq5IJ
	3D5IQDCITWdfe0q5lcOTMM+EQiXvJXrwa8Q8FEmcUcHjqsgBCuAcpfD6ilvLeYHAmG2FYTVhshu
	1ImLwciAm42lp032Zrotr9UHMm5Spt73lR5xD7792aeartjKidHelrteyhg==
X-Gm-Gg: ATEYQzxt8UGwozWOMMC+eTXmRZMHrxbC1z42PTJ6iqH+K3GoJBT9kHf5KhbU80Xr3Tx
	11bRqb/4PVAMZxzUaiYcrsIm8sf+SVxoKJ9SuPWHp7k4qW2U4v8LQ4C2y5cRbYk+6OZFKzcgRjC
	L+WE7RVSSsCooHXhQ2sN3r8KUVF1BCohcnZcHo9jH0rtwV1c+zodwQ5z2qbXQQDiZun2aX805Vr
	r6cSvzccRoV/6zjnKoDuWembO/7j7Qb7Vw4PdwJXiwrQrHTk97WYrO2GNF+WYLiKxi0UeMkcReS
	PNFamzaaUhpE6CjvHJO0UEvufK86D312VJtX7EKrjpzhqeZEMsbea3eVWZ+8Ncq2W64gx+c0nty
	yo6IfXogv9MnGqO0L8ZDucKa+1SrjPdzjzuEdtqV6oI4cJ57hU+9ET4uf5H0dekDN
X-Received: by 2002:a17:90b:530f:b0:35b:9720:98d0 with SMTP id 98e67ed59e1d1-35bd2c20602mr10397211a91.5.1774248496668;
        Sun, 22 Mar 2026 23:48:16 -0700 (PDT)
X-Received: by 2002:a17:90b:530f:b0:35b:9720:98d0 with SMTP id 98e67ed59e1d1-35bd2c20602mr10397188a91.5.1774248496287;
        Sun, 22 Mar 2026 23:48:16 -0700 (PDT)
Received: from [192.168.68.51] (n175-34-8-244.mrk21.qld.optusnet.com.au. [175.34.8.244])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35bd40e4bf2sm8105752a91.11.2026.03.22.23.48.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Mar 2026 23:48:15 -0700 (PDT)
Message-ID: <dd4990fa-a864-41f3-bf61-7696416b772b@redhat.com>
Date: Mon, 23 Mar 2026 16:47:59 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 17/40] arm_mpam: resctrl: Add resctrl_arch_get_config()
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
 <20260313144617.3420416-18-ben.horgan@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20260313144617.3420416-18-ben.horgan@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ei-I6lhaPdtHw-OJ9BTUSb-DHEfdDZAqnFAc15NvZJo_1774248497
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/14/26 12:45 AM, Ben Horgan wrote:
> From: James Morse <james.morse@arm.com>
> 
> Implement resctrl_arch_get_config() by testing the live configuration for a
> CPOR bitmap. For any other configuration type return the default.
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
>   drivers/resctrl/mpam_resctrl.c | 43 ++++++++++++++++++++++++++++++++++
>   1 file changed, 43 insertions(+)
> 
Reviewed-by: Gavin Shan <gshan@redhat.com>

