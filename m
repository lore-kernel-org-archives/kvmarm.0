Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E76961FCE
	for <kvmarm@lists.linux.dev>; Fri, 25 Sep 2026 00:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790294868; cv=none; b=M8cLG4hbRYIz8qoKbDx6yqiQgZC358XCGbMw2yZCndFfJL3io4Y84nvjOrN2dL9od2A/gvsdrtIZtTwOelydlYSE/64V+m3Tx3dc/fiCJVjUuunGTUrK0CcRPPUT+GAt1NinVfpom0WQ1zxpJ/8fvAoWENJHW1Tj/K+e4PAgo64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790294868; c=relaxed/simple;
	bh=MfzCj5n/qzaDRiZjBdIWIPdLsqB/Z8mKb7SNpeiywnE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=osQzeL+5qGTJOUnQ53sU4OdJRSgRuV58FNTw5btjnBqwAGrN45ofWHEi0q+Fxp2hf0bI5if3QVzWSRpP8XpQJcfjO+vFcBOHAmEXQeKbOCEj1ALRiwxE4RngH5yMYSotCfyCfY8wQSUkdn5ciJ+PyfZVQX0BoHbqEWfzfKHuau0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=F3awLiiB; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="F3awLiiB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790294865;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QtjK9f50/jK8SHecvHOqY5pCCQhpN2otdhXEwvLzMjs=;
	b=F3awLiiBniggHGjUD8BAJfzOzOFE9VrPiYefLhSvcIuJ5/TMVOWNqTfsueWn1c3PqhQ8oa
	3B3rdmOMeMonmuVcvPHG9hf+67XUp/DAr/f58F7s+2tHnrlCovmGH6hCNDXW47zBcUWmJY
	SOEjdJ6UqEFUlU+C5zalai+n5LPreqA=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-310-qJVVx3ANMc6lbEqEqTlcxg-1; Thu, 24 Sep 2026 20:07:43 -0400
X-MC-Unique: qJVVx3ANMc6lbEqEqTlcxg-1
X-Mimecast-MFC-AGG-ID: qJVVx3ANMc6lbEqEqTlcxg_1790294863
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-3a0bce9739bso141283a91.0
        for <kvmarm@lists.linux.dev>; Thu, 24 Sep 2026 17:07:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790294862; x=1790899662;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QtjK9f50/jK8SHecvHOqY5pCCQhpN2otdhXEwvLzMjs=;
        b=o7b6opqraY/MP23A08+Qju/2hdhB/hlJfWjphyKajnlMf1bls536ZPRGTwPFfenr8W
         92auRdMNQn1bkHW+jNYqfztQ9kYs2A6+NRcwPOjgncm51rA269yo3tW/BhPpxk7exyY5
         A9QX5txMG8JHLdwPG/0O+6OSUjdKJPMjO4nosHaRBXMzAnWhf2aQUh/rK57n5gSNJefB
         MS1YtJSD2QVyanLp3q4m0+IaCBU8ShPpVdQFf7za0fo7EVrn+xMUr6W6xdLdUEw39kmW
         kggDSe+xPS+M4+UHe2OzZWWeUWBC3HiiQgi8Jnhk3StKiflORM0NqE4STeyHQ2USXPku
         06pQ==
X-Forwarded-Encrypted: i=1; AKwUvBzYZb0S32PiBkA5d6wu8iQp72FB9o+lqhdmKK0lD0+QkeqbAvSD7cFA9hhD9FQgkvuWUR4UPOQ=@lists.linux.dev
X-Gm-Message-State: AFuF++kHeWWZLM+Te1UNmf8h0JmXjNAugi9hIWPTU2IyPD2B6Vr+63vL
	qlWYC8Ic6yIxrpH3atC9bfKpu7POuvTh7pKJDxvILZUFgy7goyorqcofjA9YyfamCy94iOFO4Xp
	verjBJW+TKmhbP3ysW5qNmlb0yovukQeaGPFsD90V9YMw9U4Jwb55g6EDIA==
X-Gm-Gg: AYBFou17XfiZPCSuDWfY2Zq98o81PZ+QqtCu/+Xzhdv7ouHdFuJ06EOtotPLCnuBgKq
	XunZ9qxTibC2MXJsIErY9To4WPL0dGFBnR2kqXBql8nLYiXy5JQjM+nJHr/3AlNSpa3ETPKopfA
	Qh202Q06FR75raGhMc0P3oiLiWWnSH9E0HgjWXLFQzvR+BsyV9nYMHr4RfGMYWQTmnYz++84+tG
	VGQNJMzaMKKd7Fr7ioK67l76D+s4u2t+mNeBXfp1zj26RnZ40bV011evbJ6L1+khx0Vde2AIMqq
	Xx4QvMTtwEalnzno2hsbvmLvLRWKu3HXhP43SMQdGg9yUwCPaU2I7OoLQihorXiz17qU8A8ayFh
	fNY+rQ/6EIvjTgFCHqhfclGo0Gp8UrQNKkCRsNPIGlg==
X-Received: by 2002:a17:90b:49:b0:3a0:9ed5:5420 with SMTP id 98e67ed59e1d1-3a0bb6139bdmr380657a91.44.1790294862467;
        Thu, 24 Sep 2026 17:07:42 -0700 (PDT)
X-Received: by 2002:a17:90b:49:b0:3a0:9ed5:5420 with SMTP id 98e67ed59e1d1-3a0bb6139bdmr380627a91.44.1790294861906;
        Thu, 24 Sep 2026 17:07:41 -0700 (PDT)
Received: from [192.168.68.52] (n175-34-8-244.mrk21.qld.optusnet.com.au. [175.34.8.244])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0b9355e49sm997611a91.4.2026.09.24.17.07.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Sep 2026 17:07:41 -0700 (PDT)
Message-ID: <a3984ac2-ca04-4e46-87e9-6277491acf7c@redhat.com>
Date: Fri, 25 Sep 2026 10:07:34 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 6/7] firmware: arm_rmm: Ensure the RMM has GPT entries
 for memory
To: Suzuki K Poulose <suzuki.poulose@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, catalin.marinas@arm.com,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 steven.price@arm.com, aneesh.kumar@kernel.org, oupton@kernel.org,
 joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
 linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
 sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
 WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com,
 sudeep.holla@arm.com, jonathan.cameron@oss.qualcomm.com
References: <20260924135201.850038-1-suzuki.poulose@arm.com>
 <20260924135201.850038-7-suzuki.poulose@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20260924135201.850038-7-suzuki.poulose@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 2yYIqi37L3wR9bvafnp14coZ6CDwwNwq6nYq6922S2Y_1790294863
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/24/26 11:52 PM, Suzuki K Poulose wrote:
> From: Steven Price <steven.price@arm.com>
> 
> The RMM maintains the state of all the granules in the system to make
> sure that the host is abiding by the rules. This state can be maintained
> at different granularity, per page (TRACKING_FINE) or per region
> (TRACKING_COARSE or TRACKING_INTERMEDIATE). The region size depends on the
> underlying "RMI_GRANULE_SIZE". For a "coarse"/"intermediate" region,
> all pages in the region must be of the same state, this implies we need to
> have "fine" tracking for DRAM, so that we can delegate individual pages.
> 
> For now we only support a statically carved out memory for tracking
> granules for the "fine" regions. This can be extended in the future to
> allow modifying the tracking granularity and remove the need for a
> static allocation by the firmware.
> 
> Similarly, the firmware may create L0 GPT entries describing the total
> address space. But if we change the "PAS" (Physical Address Space) of a
> granule, then the firmware may need to create L1 tables to track the PAS
> at a finer granularity. Linux therefore checks if the platform firmware
> manages the PAR region. i.e., the firmware is in charge of managing the
> L1 GPTs (creation and the required memory for the GPT tables - via static
> carveouts) without host intervention. Support for dynamic GPT creation by
> the host will be added later.
> 
> If the firmware requires us to manage the tracking or GPT memory,
> deactivate the RMM and reclaim any memory donated at RMM activation.
> 
> Apply the same checks when hotplugged memory is brought online.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> [ Switch to RMI_GPT_L1_INFO for checking GPTs and deactivate RMM ]
> Co-developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
>   Changes since v19:
>       * Avoid mixing gotos with __free cleanups for arm64_init_rmi()
>   Changes since v18:
>       * Handle buggy RMM to make forward progress for RMI_GPT_INFO and
>         RMI_GRANULE_TRACKING_GET
>       * Make sure the memory ranges are not inverted and reject such ranges.
>       * Move granule_tracking_get/gpt_info wrappers closer to the callers
>         Drop "inline", let the compiler do its job
>   Changes since v17:
>       * Move wrappers that may not be used elsewhere, out of arm-rmi-cmds.h
>   Changes since v16:
>       * Check fine tracking and create L1 GPTs for hotplug-added memory.
>       * Clarify the L1 GPT setup and move the explanatory comment.
>       * Switch to using RMI_GPT_INFO command for checking the GPTs.
>       * Deactivate the RMM and reclaim the memory if we can't proceed.
>   Changes since v15:
>       * Skip firmware-reserved NOMAP memory in rmi_init_metadata()
>       * Handle negative error codes from wrappers.
>   Changes since v14:
>       * Move the implementation into drivers/firmware/arm_rmm.
>   Changes since v13:
>       * Moved out of KVM
> ---
>   drivers/firmware/arm_rmm/rmi.c | 218 ++++++++++++++++++++++++++++++++-
>   include/linux/arm-rmi-cmds.h   |   2 +
>   2 files changed, 219 insertions(+), 1 deletion(-)
> 

With Jonathan's comments addressed:

Reviewed-by: Gavin Shan <gshan@redhat.com>

Thanks,
Gavin

