Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 348571C84A0
	for <kvmarm@lists.linux.dev>; Mon, 28 Sep 2026 01:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790557856; cv=none; b=qNSxmmDXQaZ0fCsaOilUMfmLwb43Uw8ROWEaDb5x8oRVlvzUgqHLsqfUl7t6i9YFgmGY7ehuzjqcHvO5Ceouxw4Vpr5Rys4EN9MISHnh2pOeVSIEfoqUjLrQUfqrJmLLUmlrufGGenccaJKCpd8AqvDvJr7Hzd5M4xwjvIDP6XI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790557856; c=relaxed/simple;
	bh=6yMk76KzWzu+iefeI1Jyf4+Me3XfVQPopFewLbvBPhI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HRJFXxw/Djk44BU6S4/0HQlqK6SjZXrpT3esqJCb1HAPzKZdVFIthFe3QDP+oyzhr4twYma9voCCfj5dxSH9z4Y43Prf/8RVOx/Wtv9gUpDpSIV/wLt1GYfZXcXWxzgfDgz4pvhOtgoqR9Zu8K+v6uv+GjG7W04KVUoSMDtVllc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hhptWLXh; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hhptWLXh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790557854;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SmHYt1Ti8nIvrqszBUhxBgvTrbJZdy2Ri6tFNNhqhDs=;
	b=hhptWLXhnJ5Lw4Wh5/k3VlbMSWQE+/6vz91PX7av8rbENPC8kee+toZjpUI9+MxUXwt7wC
	4MpXs1nf3DQUdPGmzqkDs8SiZ10kAN/ZvqHwYXunXExx6rADy6SQKRcgBz6nc4i33WTVN2
	gJc7tlvRP2R7Vh1zCCBB30TI7pfVJ/s=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-530-I--6V4nCOOqAhBH6oFXHpA-1; Sun, 27 Sep 2026 21:10:52 -0400
X-MC-Unique: I--6V4nCOOqAhBH6oFXHpA-1
X-Mimecast-MFC-AGG-ID: I--6V4nCOOqAhBH6oFXHpA_1790557852
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-cc1cdfb337eso1166174a12.0
        for <kvmarm@lists.linux.dev>; Sun, 27 Sep 2026 18:10:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790557852; x=1791162652;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SmHYt1Ti8nIvrqszBUhxBgvTrbJZdy2Ri6tFNNhqhDs=;
        b=ZvXamWO1bacfvt3RmX8QXQEeH1kJ/S3ATnUQc33Gd/1bAHvsZhRhF0ImLKgerQLMR1
         AqJEIb78iy55MY51wSxQkxsZqq8cZ3c7kVoM/gjDh/FtIhTBBos6w8TyOOe6IgpGRCBi
         RCFVoAmsgLiySym7vWQUlP6Hk8JGwXvBmHVNcvW8+yP1Go8VOeW+mgary+VYqOC1U6HO
         /bhTFAdjDKwhWEFbY10I9S7SYZcuTly0BmPawjKtQ3ZY8V5Iq7jk5L2vZPiB7kPuMfRi
         HtIEr4R4fJUoRNc5Ho58GDJbHwe73Jl4WHguambzpGDAqC3oMLquk3DpgDDQ5xoM+Kil
         LU1Q==
X-Forwarded-Encrypted: i=1; AKwUvBzyvNhegl30dToZZ3WYFZc7zLq28Tyt3iPstI7FOTN0jgOiRztSDwQkGj6nnJjzNAkQTZF78KI=@lists.linux.dev
X-Gm-Message-State: AFq9FYK/eFz9hmOXexBT9wjiFPVPdS1LavB2M4gdnyoeqXFf0W0pGzF3
	cdDzB3fuuNJIPu2UyfnXUjgDhYy+y+URWsOub7+CjN6noMLrnNi+/ZzyrrUpkZMp7v8ai9TB1te
	QfsFfEJ8sBwI7/w+qq1bvLYLwFNvyzukyvCBst/z0AuwrthKxe9zCriIxWA==
X-Gm-Gg: AYBFou25P6UPPidvm77DKCwDgKruGv6iYOdXuRd3GEWxoWpwqGTHajlF0LSD+lftp/m
	eAz7U3nPeuZdOpeuQXDl9g9l73Zsfznk8yFpYSx2IfAOTV+PXyz4fbOTaKUhIigop/vBL6d+YKm
	VVy8uHzuvBFdx87eXbOg0IMbou3KcB19nTCWu3Y5gsT09K0lFuXcUe68rKAB4DF6cucxdwBaI+p
	eBMiTAdpH2jGgPDKnOxd8n6LG4+9QLCtBTVApZTDYtpsOFG8ZT/xAkl/4ZIZw+9vLf5aAOHC7JN
	RhYfkMQej6iUtUWJscBVxvD3ma+S0RnUzIMi0Q2+rSkSZoYyuNfEAao0HLdlBSRtjFEiIAtFZ9v
	+G9KJVDdjS4JkGWgiCftPV99bm+HqGQfXWxnldxe0Wg==
X-Received: by 2002:a17:902:d2c2:b0:2df:4862:6092 with SMTP id d9443c01a7336-2df7dc52ademr80473415ad.56.1790557851465;
        Sun, 27 Sep 2026 18:10:51 -0700 (PDT)
X-Received: by 2002:a17:902:d2c2:b0:2df:4862:6092 with SMTP id d9443c01a7336-2df7dc52ademr80473175ad.56.1790557850985;
        Sun, 27 Sep 2026 18:10:50 -0700 (PDT)
Received: from [192.168.68.52] (n175-34-8-244.mrk21.qld.optusnet.com.au. [175.34.8.244])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2df91476bb4sm32933225ad.83.2026.09.27.18.10.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 27 Sep 2026 18:10:50 -0700 (PDT)
Message-ID: <a4961d90-42ef-4954-beb5-c07fa1d92fd4@redhat.com>
Date: Mon, 28 Sep 2026 11:10:43 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 11/20] KVM: arm64: Mandate VGIC v3 for for VMs running
 on hyp that don't trust the host
To: Suzuki K Poulose <suzuki.poulose@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, catalin.marinas@arm.com,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 steven.price@arm.com, aneesh.kumar@kernel.org, oupton@kernel.org,
 joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
 linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
 sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
 WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com
References: <20260920212845.707-1-suzuki.poulose@arm.com>
 <20260920212845.707-12-suzuki.poulose@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20260920212845.707-12-suzuki.poulose@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ZdMBuPrN52mlRsak3L-XJNDvBElukedN8E6XyCDFV00_1790557852
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/21/26 7:28 AM, Suzuki K Poulose wrote:
> pKVM and RMM, both do not trust the host. Add a helper to detect the VMs
> that have "distrusting" hyp. Use this for blocking ioremap of vgic-v2 into
> stage2 and prevent creation of VGIC other than v3.
> 
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
> Changes since v18:
>   - Cover pKVM guests for VGIC v3 mandate.
>   - Merge the VGIC mandate check in here.
> ---
>   arch/arm64/include/asm/kvm_host.h | 3 +++
>   arch/arm64/kvm/mmu.c              | 2 +-
>   arch/arm64/kvm/vgic/vgic-init.c   | 2 ++
>   3 files changed, 6 insertions(+), 1 deletion(-)
> 
Reviewed-by: Gavin Shan <gshan@redhat.com>

